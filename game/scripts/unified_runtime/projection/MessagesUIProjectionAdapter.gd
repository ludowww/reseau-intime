extends RefCounted

class_name R8CMessagesUIProjectionAdapter

const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)

const SNAPSHOT_VERSION := 1
const PLAYER_ID := "player"
const SUPPORTED_BEAT_TYPES := ["MESSAGE", "CHOICE"]
const EXECUTOR_METHODS := [
	"current_beat",
	"execution_state",
	"open_current_projection",
	"receive_ack",
	"receive_command",
]
const PORT_METHODS := ["open", "acknowledge", "snapshot"]

var _executor
var _projection_port
var _metadata: Dictionary = {}
var _source: Dictionary = {}
var _messages_screen
var _active: Dictionary = {}
var _presented_message_ids_by_thread: Dictionary = {}
var _notification_presented := false
var _notification_dismissed := false
var _progression_ack_sent := false
var _progression_command_sent := false
var _last_result := _result(false, "NOT_INITIALIZED")


static func create(executor, projection_port, presentation_metadata) -> Dictionary:
	var error_code := _validate_dependencies(executor, projection_port, presentation_metadata)
	if not error_code.is_empty():
		return {"ok": false, "error_code": error_code, "adapter": null}
	var adapter := new()
	adapter._executor = executor
	adapter._projection_port = projection_port
	adapter._metadata = presentation_metadata.duplicate(true)
	adapter._source = adapter._empty_source()
	adapter._last_result = _result(true)
	return {"ok": true, "error_code": null, "adapter": adapter}


func attach_messages_screen(screen) -> void:
	_messages_screen = screen


func on_messages_ui_ready() -> void:
	if _messages_screen == null or _active.is_empty():
		return
	if _active.get("beat_type") == "MESSAGE" and not _notification_dismissed:
		var notification_message_id := str(_active.get("notification_message_id", ""))
		if notification_message_id != "":
			_messages_screen.call(
				"present_runtime_notification", _active["thread_id"], notification_message_id
			)


func presentation_source() -> Dictionary:
	return _source.duplicate(true)


func presented_message_ids_by_thread() -> Dictionary:
	return _presented_message_ids_by_thread.duplicate(true)


func last_result() -> Dictionary:
	return _last_result.duplicate(true)


func open_current_projection() -> Dictionary:
	if _executor == null or _projection_port == null:
		return _publish_result(false, "NOT_INITIALIZED")
	var execution: Dictionary = _executor.execution_state()
	if execution.get("execution_status") not in ["ACTIVE", "RESOLVED_RETURN_PENDING"]:
		return _publish_result(false, "EXECUTION_NOT_READY_FOR_PROJECTION")
	var beat: Dictionary = _executor.current_beat()
	var prepared := _prepare_beat(beat)
	if not prepared["ok"]:
		return _publish_result(false, prepared["error_code"])
	var projection_validation := _validate_beat_projection(beat, prepared["thread"])
	if not projection_validation["ok"]:
		return _publish_result(false, projection_validation["error_code"])
	var opened: Dictionary = _executor.open_current_projection()
	if not bool(opened.get("ok", false)):
		return _publish_result(false, str(opened.get("error_code", "PROJECTION_OPEN_REFUSED")))
	var payload: Dictionary = opened.get("payload", {})
	var request: Dictionary = payload.get("request", {})
	var port_result: Dictionary = payload.get("port_result", {})
	var applied := _apply_opened_projection(request, port_result, prepared["thread"])
	if not applied["ok"]:
		return _publish_result(false, applied["error_code"])
	_refresh_attached_screen()
	return _publish_result(true, null, bool(opened.get("idempotent", false)))


func mark_message_presented(message_id: String) -> bool:
	if _active.is_empty() or message_id.is_empty():
		_publish_result(false, "FOREIGN_PRESENTATION")
		return false
	if bool(_active.get("projection_closed", false)):
		if message_id != str(_active.get("player_bubble_id", "")):
			_publish_result(false, "PROJECTION_NOT_OPEN")
			return false
		_record_presented_message(_active["thread_id"], message_id)
		_publish_result(true)
		return true
	if message_id not in _active.get("message_ids", []):
		_publish_result(false, "FOREIGN_PRESENTATION")
		return false
	var acknowledged := _acknowledge_presentation("PRESENTED", message_id)
	if not acknowledged["ok"]:
		return false
	_record_presented_message(_active["thread_id"], message_id)
	return true


func mark_thread_batch_presented(thread_id: String) -> bool:
	if _active.is_empty() or thread_id != str(_active.get("thread_id", "")):
		_publish_result(false, "FOREIGN_PRESENTATION")
		return false
	if bool(_active.get("projection_closed", false)):
		_active = {}
		call_deferred("_open_next_supported_projection")
	_publish_result(true)
	return true


func on_messages_delivery_completed(thread_id: String) -> void:
	if _messages_screen == null or _active.is_empty():
		return
	if thread_id != str(_active.get("thread_id", "")):
		return
	if not bool(_active.get("projection_closed", false)):
		_refresh_attached_screen()


func on_notification_presented(notification: Dictionary) -> Dictionary:
	var error_code := _validate_notification_callback(notification)
	if not error_code.is_empty():
		return _publish_result(false, error_code)
	var acknowledged := _acknowledge_presentation(
		"PRESENTED", str(notification.get("notification_id", ""))
	)
	if acknowledged["ok"]:
		_notification_presented = true
	return acknowledged


func on_notification_dismissed(notification: Dictionary) -> Dictionary:
	var error_code := _validate_notification_callback(notification)
	if not error_code.is_empty():
		return _publish_result(false, error_code)
	var acknowledged := _acknowledge_presentation(
		"DISMISSED", str(notification.get("notification_id", ""))
	)
	if acknowledged["ok"]:
		_notification_dismissed = true
	return acknowledged


func on_thread_read(thread_id: String, subject_id: String) -> Dictionary:
	if (
		_active.is_empty()
		or _active.get("beat_type") != "MESSAGE"
		or bool(_active.get("projection_closed", false))
		or thread_id != str(_active.get("thread_id", ""))
		or subject_id not in _active.get("message_ids", [])
	):
		return _publish_result(false, "FOREIGN_READ")
	for message_id in _active.get("message_ids", []):
		if message_id not in _presented_message_ids_by_thread.get(thread_id, []):
			return _publish_result(false, "MESSAGE_NOT_PRESENTED")
	if _progression_ack_sent or _progression_command_sent:
		return _publish_result(true, null, true)
	var acknowledged: Dictionary = _executor.receive_ack(_receipt("READ", subject_id))
	if not bool(acknowledged.get("ok", false)):
		return _publish_result(false, str(acknowledged.get("error_code", "ACK_REFUSED")))
	_progression_ack_sent = true
	var command: Dictionary = _command("CONTINUE", null)
	var continued: Dictionary = _executor.receive_command(command)
	if not bool(continued.get("ok", false)):
		return _publish_result(false, str(continued.get("error_code", "COMMAND_REFUSED")))
	_progression_command_sent = true
	_mark_source_thread_read(thread_id)
	_active = {}
	_notification_presented = false
	_notification_dismissed = false
	_progression_ack_sent = false
	_progression_command_sent = false
	call_deferred("_open_next_supported_projection")
	return _publish_result(true, null, bool(continued.get("idempotent", false)))


func on_choices_presented(thread_id: String, choice_ids: Array) -> Dictionary:
	if (
		_active.is_empty()
		or _active.get("beat_type") != "CHOICE"
		or bool(_active.get("projection_closed", false))
		or thread_id != str(_active.get("thread_id", ""))
	):
		return _publish_result(false, "FOREIGN_CHOICE_PRESENTATION")
	var expected: Array = _active.get("choice_ids", [])
	if choice_ids != expected:
		return _publish_result(false, "FOREIGN_CHOICE_PRESENTATION")
	if _progression_ack_sent:
		return _publish_result(true, null, true)
	var subject_id := str(expected[0]) if not expected.is_empty() else str(_active["beat_id"])
	var acknowledged: Dictionary = _executor.receive_ack(_receipt("PRESENTED", subject_id))
	if not bool(acknowledged.get("ok", false)):
		return _publish_result(false, str(acknowledged.get("error_code", "ACK_REFUSED")))
	_progression_ack_sent = true
	return _publish_result(true, null, bool(acknowledged.get("idempotent", false)))


func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	var refused := {
		"accepted": false,
		"idempotent": false,
		"updated_messages": [],
		"new_messages": [],
		"choices": [],
		"transition": {},
		"error_code": "CHOICE_NOT_AVAILABLE",
	}
	if (
		_active.is_empty()
		or _active.get("beat_type") != "CHOICE"
		or thread_id != str(_active.get("thread_id", ""))
		or choice_id not in _active.get("choice_ids", [])
		or not _progression_ack_sent
	):
		_last_result = _result(false, refused["error_code"])
		return refused
	var bubble_id := _player_bubble_id(choice_id)
	if bool(_active.get("projection_closed", false)):
		if choice_id == str(_active.get("selected_choice_id", "")):
			refused["accepted"] = true
			refused["idempotent"] = true
			refused["error_code"] = null
			_last_result = _result(true, null, true)
		return refused
	var selected_choice := _choice_by_id(choice_id)
	if selected_choice.is_empty():
		return refused
	var selected: Dictionary = _executor.receive_command(_command("SELECT_CHOICE", choice_id))
	if not bool(selected.get("ok", false)):
		refused["error_code"] = str(selected.get("error_code", "COMMAND_REFUSED"))
		_last_result = _result(false, refused["error_code"])
		return refused
	var bubble := {
		"message_id": bubble_id,
		"author_id": PLAYER_ID,
		"timestamp": "",
		"content_type": "TEXT",
		"text": str(selected_choice.get("text", "")),
		"media_ref": "",
		"is_player": true,
		"is_read": true,
		"sequence_id": _active["sequence_id"],
		"beat_id": _active["beat_id"],
		"presentation_id": _active["presentation_id"],
		"choice_id": choice_id,
	}
	var thread_messages: Array = _source["messages_by_thread"].get(thread_id, [])
	var new_messages: Array[Dictionary] = []
	if not _message_id_exists(thread_messages, bubble_id):
		thread_messages.append(bubble.duplicate(true))
		_source["messages_by_thread"][thread_id] = thread_messages
		new_messages.append(bubble)
	_source["choices_by_thread"][thread_id] = []
	_update_thread_tail(thread_id, bubble)
	_active["projection_closed"] = true
	_active["selected_choice_id"] = choice_id
	_active["player_bubble_id"] = bubble_id
	_progression_command_sent = true
	_last_result = _result(true, null, bool(selected.get("idempotent", false)))
	return {
		"accepted": true,
		"idempotent": bool(selected.get("idempotent", false)),
		"updated_messages": [],
		"new_messages": new_messages,
		"choices": [],
		"transition": {},
		"error_code": null,
	}


func acknowledge_presentation(receipt: Dictionary) -> Dictionary:
	if _active.is_empty() or bool(_active.get("projection_closed", false)):
		return _publish_result(false, "PROJECTION_NOT_OPEN")
	if not ProjectionContracts.validate_presentation_receipt(receipt)["valid"]:
		return _publish_result(false, "INVALID_RECEIPT")
	if not ProjectionContracts.validate_receipt_against_request(receipt, _active["request"])["valid"]:
		return _publish_result(false, "FOREIGN_RECEIPT")
	if not _receipt_subject_is_local(receipt["kind"], receipt["subject_id"]):
		return _publish_result(false, "FOREIGN_RECEIPT")
	var acknowledged: Dictionary = _projection_port.acknowledge(receipt)
	if not bool(acknowledged.get("accepted", false)):
		return _publish_result(false, str(acknowledged.get("error_code", "PORT_ACK_REFUSED")))
	return _publish_result(true, null, bool(acknowledged.get("idempotent", false)))


func snapshot() -> Dictionary:
	return {
		"accepted": true,
		"snapshot": {
			"snapshot_version": SNAPSHOT_VERSION,
			"source": _source.duplicate(true),
			"active": _active.duplicate(true),
			"presented_message_ids_by_thread": _presented_message_ids_by_thread.duplicate(true),
			"notification_presented": _notification_presented,
			"notification_dismissed": _notification_dismissed,
			"progression_ack_sent": _progression_ack_sent,
			"progression_command_sent": _progression_command_sent,
		},
		"error_code": null,
	}


func restore(snapshot_data: Dictionary) -> Dictionary:
	var expected_keys := [
		"active",
		"notification_dismissed",
		"notification_presented",
		"presented_message_ids_by_thread",
		"progression_ack_sent",
		"progression_command_sent",
		"snapshot_version",
		"source",
	]
	var actual_keys: Array = snapshot_data.keys()
	actual_keys.sort()
	if actual_keys != expected_keys or snapshot_data.get("snapshot_version") != SNAPSHOT_VERSION:
		return _publish_result(false, "INVALID_SNAPSHOT")
	for field in ["source", "active", "presented_message_ids_by_thread"]:
		if typeof(snapshot_data.get(field)) != TYPE_DICTIONARY:
			return _publish_result(false, "INVALID_SNAPSHOT")
	for field in [
		"notification_presented",
		"notification_dismissed",
		"progression_ack_sent",
		"progression_command_sent",
	]:
		if typeof(snapshot_data.get(field)) != TYPE_BOOL:
			return _publish_result(false, "INVALID_SNAPSHOT")
	var candidate_source: Dictionary = snapshot_data["source"]
	if not _source_matches_metadata(candidate_source):
		return _publish_result(false, "INVALID_SNAPSHOT")
	var candidate_active: Dictionary = snapshot_data["active"]
	if not candidate_active.is_empty() and not _active_matches_execution(candidate_active):
		return _publish_result(false, "INVALID_SNAPSHOT")
	_source = candidate_source.duplicate(true)
	_active = candidate_active.duplicate(true)
	_presented_message_ids_by_thread = snapshot_data["presented_message_ids_by_thread"].duplicate(true)
	_notification_presented = snapshot_data["notification_presented"]
	_notification_dismissed = snapshot_data["notification_dismissed"]
	_progression_ack_sent = snapshot_data["progression_ack_sent"]
	_progression_command_sent = snapshot_data["progression_command_sent"]
	return _publish_result(true)


func _prepare_beat(beat: Dictionary) -> Dictionary:
	if beat.is_empty():
		return {"ok": false, "error_code": "NO_CURRENT_BEAT"}
	if beat.get("projection_target") != "MESSAGES":
		return {"ok": false, "error_code": "UNSUPPORTED_TARGET"}
	if beat.get("type") in ["AFTERCARE", "RETURN"]:
		return {"ok": false, "error_code": "UNRESOLVED_CONTENT_REF"}
	if beat.get("type") not in SUPPORTED_BEAT_TYPES:
		return {"ok": false, "error_code": "UNSUPPORTED_BEAT_TYPE"}
	var resolved := _resolve_thread(beat.get("participant_ids", []))
	if not resolved["ok"]:
		return resolved
	var authored_thread_id := str(beat.get("content", {}).get("thread_id", ""))
	if authored_thread_id != str(resolved["thread"].get("thread_id", "")):
		return {"ok": false, "error_code": "THREAD_ID_MISMATCH"}
	return {"ok": true, "error_code": null, "thread": resolved["thread"]}


func _validate_beat_projection(beat: Dictionary, thread: Dictionary) -> Dictionary:
	var thread_id := str(thread.get("thread_id", ""))
	if beat.get("type") == "CHOICE":
		if not _metadata["characters"].has(PLAYER_ID) or not _thread_accepts_author(thread_id, PLAYER_ID):
			return {"ok": false, "error_code": "UNRESOLVED_PLAYER_METADATA"}
		return {"ok": true, "error_code": null}
	for authored_message in beat.get("content", {}).get("messages", []):
		var message_id := str(authored_message.get("message_id", ""))
		var author_id := str(authored_message.get("author_id", ""))
		if (
			message_id.is_empty()
			or _message_id_exists_anywhere(message_id)
			or not _metadata["characters"].has(author_id)
			or not _thread_accepts_author(thread_id, author_id)
		):
			return {"ok": false, "error_code": "UNRESOLVED_MESSAGE_METADATA"}
	return {"ok": true, "error_code": null}


func _apply_opened_projection(
	request: Dictionary, port_result: Dictionary, thread: Dictionary
) -> Dictionary:
	if request.is_empty() or not bool(port_result.get("accepted", false)):
		return {"ok": false, "error_code": "INVALID_OPEN_RESULT"}
	var payload: Dictionary = port_result.get("payload", {})
	var beat_type := str(payload.get("beat_type", ""))
	var thread_id := str(thread.get("thread_id", ""))
	var presentation_id := str(port_result.get("presentation_id", ""))
	_active = {
		"request": request.duplicate(true),
		"presentation_id": presentation_id,
		"instance_id": request["instance_id"],
		"sequence_id": request["sequence_id"],
		"authored_version": request["authored_version"],
		"beat_id": request["beat_id"],
		"beat_type": beat_type,
		"thread_id": thread_id,
		"message_ids": [],
		"choice_ids": [],
		"notification_message_id": "",
		"projection_closed": false,
		"selected_choice_id": "",
		"player_bubble_id": "",
	}
	_notification_presented = false
	_notification_dismissed = false
	_progression_ack_sent = false
	_progression_command_sent = false
	if beat_type == "MESSAGE":
		return _project_messages(payload.get("content", {}), thread_id)
	return _project_choices(payload.get("content", {}), thread_id)


func _project_messages(content: Dictionary, thread_id: String) -> Dictionary:
	var projected: Array[Dictionary] = []
	var existing: Array = _source["messages_by_thread"].get(thread_id, [])
	for authored_message in content.get("messages", []):
		var message_id := str(authored_message.get("message_id", ""))
		var author_id := str(authored_message.get("author_id", ""))
		if (
			message_id.is_empty()
			or _message_id_exists_anywhere(message_id)
			or not _metadata["characters"].has(author_id)
			or not _thread_accepts_author(thread_id, author_id)
		):
			return {"ok": false, "error_code": "UNRESOLVED_MESSAGE_METADATA"}
		var diegetic_at := str(authored_message.get("diegetic_at", ""))
		var message := {
			"message_id": message_id,
			"author_id": author_id,
			"timestamp": _timestamp_for_diegetic(diegetic_at),
			"content_type": "TEXT",
			"text": str(authored_message.get("text", "")),
			"media_ref": "",
			"is_player": author_id == PLAYER_ID,
			"is_read": author_id == PLAYER_ID,
			"diegetic_at": diegetic_at,
			"relative_order": authored_message.get("relative_order"),
			"sequence_id": _active["sequence_id"],
			"beat_id": _active["beat_id"],
			"presentation_id": _active["presentation_id"],
		}
		projected.append(message)
		_active["message_ids"].append(message_id)
		if author_id != PLAYER_ID:
			_active["notification_message_id"] = message_id
	for message in projected:
		existing.append(message.duplicate(true))
	_source["messages_by_thread"][thread_id] = existing
	if not projected.is_empty():
		_update_thread_tail(thread_id, projected[-1])
	var unread_count := 0
	for message in existing:
		if not bool(message.get("is_player", false)) and not bool(message.get("is_read", false)):
			unread_count += 1
	_update_thread_unread(thread_id, unread_count)
	return {"ok": true, "error_code": null}


func _project_choices(content: Dictionary, thread_id: String) -> Dictionary:
	if not _metadata["characters"].has(PLAYER_ID) or not _thread_accepts_author(thread_id, PLAYER_ID):
		return {"ok": false, "error_code": "UNRESOLVED_PLAYER_METADATA"}
	var projected: Array[Dictionary] = []
	for authored_choice in content.get("choices", []):
		var choice_id := str(authored_choice.get("choice_id", ""))
		if choice_id.is_empty() or choice_id in _active["choice_ids"]:
			return {"ok": false, "error_code": "INVALID_CHOICE_PRESENTATION"}
		projected.append({
			"choice_id": choice_id,
			"text": str(authored_choice.get("text", "")),
			"enabled": true,
			"sequence_id": _active["sequence_id"],
			"beat_id": _active["beat_id"],
			"presentation_id": _active["presentation_id"],
		})
		_active["choice_ids"].append(choice_id)
	_source["choices_by_thread"][thread_id] = projected
	return {"ok": true, "error_code": null}


func _open_next_supported_projection() -> void:
	if _executor == null:
		return
	var execution: Dictionary = _executor.execution_state()
	if execution.get("execution_status") not in ["ACTIVE", "RESOLVED_RETURN_PENDING"]:
		return
	var beat: Dictionary = _executor.current_beat()
	if beat.get("projection_target") != "MESSAGES":
		_last_result = _result(false, "UNSUPPORTED_TARGET")
		return
	if beat.get("type") in ["AFTERCARE", "RETURN"]:
		_last_result = _result(false, "UNRESOLVED_CONTENT_REF")
		return
	if beat.get("type") not in SUPPORTED_BEAT_TYPES:
		_last_result = _result(false, "UNSUPPORTED_BEAT_TYPE")
		return
	open_current_projection()


func _refresh_attached_screen() -> void:
	if _messages_screen == null:
		return
	if _messages_screen.is_node_ready():
		_messages_screen.call("refresh_from_runtime", presentation_source())
		on_messages_ui_ready()


func _acknowledge_presentation(kind: String, subject_id: String) -> Dictionary:
	if _active.is_empty() or bool(_active.get("projection_closed", false)):
		return _publish_result(false, "PROJECTION_NOT_OPEN")
	return acknowledge_presentation(_receipt(kind, subject_id))


func _receipt(kind: String, subject_id: String) -> Dictionary:
	var request: Dictionary = _active["request"]
	return {
		"presentation_id": _active["presentation_id"],
		"instance_id": request["instance_id"],
		"sequence_id": request["sequence_id"],
		"authored_version": request["authored_version"],
		"beat_id": request["beat_id"],
		"beat_type": request["beat_type"],
		"projection_target": request["projection_target"],
		"kind": kind,
		"subject_id": subject_id,
	}


func _command(kind: String, choice_id) -> Dictionary:
	var command_identity := "%s|%s|%s|%s" % [
		_active["instance_id"], _active["beat_id"], kind, str(choice_id)
	]
	return {
		"command_id": "messages_ui_" + command_identity.sha256_text(),
		"instance_id": _active["instance_id"],
		"beat_id": _active["beat_id"],
		"kind": kind,
		"choice_id": choice_id,
	}


func _resolve_thread(participant_ids) -> Dictionary:
	if not participant_ids is Array:
		return {"ok": false, "error_code": "UNRESOLVED_PARTICIPANT", "thread": {}}
	var expected := _normalized_participants(participant_ids)
	for participant_id in expected:
		if not _metadata["characters"].has(participant_id):
			return {"ok": false, "error_code": "UNRESOLVED_PARTICIPANT", "thread": {}}
	var candidates: Array[Dictionary] = []
	for thread in _metadata["threads"]:
		if _normalized_participants(thread.get("participant_ids", [])) == expected:
			candidates.append(thread.duplicate(true))
	if candidates.is_empty():
		return {"ok": false, "error_code": "THREAD_NOT_FOUND", "thread": {}}
	if candidates.size() != 1:
		return {"ok": false, "error_code": "AMBIGUOUS_THREAD", "thread": {}}
	return {"ok": true, "error_code": null, "thread": candidates[0]}


func _normalized_participants(value) -> Array:
	var result: Array = []
	if value is Array:
		for raw_id in value:
			var participant_id := str(raw_id)
			if participant_id != PLAYER_ID and participant_id not in result:
				result.append(participant_id)
	result.sort()
	return result


func _empty_source() -> Dictionary:
	var messages_by_thread := {}
	var choices_by_thread := {}
	for thread in _metadata["threads"]:
		var thread_id := str(thread.get("thread_id", ""))
		messages_by_thread[thread_id] = []
		choices_by_thread[thread_id] = []
	var result := {
		"characters": _metadata["characters"].duplicate(true),
		"threads": _metadata["threads"].duplicate(true),
		"messages_by_thread": messages_by_thread,
		"choices_by_thread": choices_by_thread,
	}
	for optional_field in ["narrative_day_short", "narrative_time"]:
		if _metadata.has(optional_field):
			result[optional_field] = _metadata[optional_field]
	return result


func _validate_notification_callback(notification: Dictionary) -> String:
	if _active.is_empty() or bool(_active.get("projection_closed", false)):
		return "PROJECTION_NOT_OPEN"
	if _active.get("beat_type") != "MESSAGE":
		return "FOREIGN_NOTIFICATION"
	var expected_notification_id := "%s::%s" % [
		_active.get("thread_id", ""), _active.get("notification_message_id", "")
	]
	if (
		str(notification.get("thread_id", "")) != str(_active.get("thread_id", ""))
		or str(notification.get("message_id", "")) != str(_active.get("notification_message_id", ""))
		or str(notification.get("notification_id", "")) != expected_notification_id
	):
		return "STALE_NOTIFICATION"
	return ""


func _receipt_subject_is_local(kind: String, subject_id: String) -> bool:
	if kind == "READ":
		return _active.get("beat_type") == "MESSAGE" and subject_id in _active.get("message_ids", [])
	if _active.get("beat_type") == "CHOICE":
		return kind == "PRESENTED" and subject_id in _active.get("choice_ids", [])
	if kind == "PRESENTED":
		return (
			subject_id in _active.get("message_ids", [])
			or subject_id.begins_with("%s::" % _active.get("thread_id", ""))
		)
	if kind == "DISMISSED":
		return subject_id.begins_with("%s::" % _active.get("thread_id", ""))
	return false


func _record_presented_message(thread_id: String, message_id: String) -> void:
	var ids: Array = _presented_message_ids_by_thread.get(thread_id, []).duplicate()
	if message_id not in ids:
		ids.append(message_id)
	_presented_message_ids_by_thread[thread_id] = ids


func _mark_source_thread_read(thread_id: String) -> void:
	var messages: Array = _source["messages_by_thread"].get(thread_id, [])
	for message in messages:
		message["is_read"] = true
	_source["messages_by_thread"][thread_id] = messages
	_update_thread_unread(thread_id, 0)


func _update_thread_unread(thread_id: String, unread_count: int) -> void:
	for thread in _source["threads"]:
		if str(thread.get("thread_id", "")) == thread_id:
			thread["unread_count"] = unread_count
			thread["has_unread_content"] = unread_count > 0
			return


func _update_thread_tail(thread_id: String, message: Dictionary) -> void:
	for thread in _source["threads"]:
		if str(thread.get("thread_id", "")) == thread_id:
			thread["last_preview"] = str(message.get("text", ""))
			thread["last_timestamp"] = str(message.get("timestamp", ""))
			return


func _thread_accepts_author(thread_id: String, author_id: String) -> bool:
	for thread in _metadata["threads"]:
		if str(thread.get("thread_id", "")) == thread_id:
			var participants = thread.get("participant_ids", [])
			return participants is Array and author_id in participants
	return false


func _choice_by_id(choice_id: String) -> Dictionary:
	var beat: Dictionary = _executor.current_beat()
	for choice in beat.get("content", {}).get("choices", []):
		if str(choice.get("choice_id", "")) == choice_id:
			return choice.duplicate(true)
	return {}


func _player_bubble_id(choice_id: String) -> String:
	return "%s__choice__%s__player" % [_active["presentation_id"], choice_id]


func _timestamp_for_diegetic(diegetic_at: String) -> String:
	var separator := diegetic_at.find("T")
	if separator < 0 or diegetic_at.length() < separator + 6:
		return ""
	return diegetic_at.substr(separator + 1, 5)


func _message_id_exists(messages: Array, message_id: String) -> bool:
	for message in messages:
		if str(message.get("message_id", "")) == message_id:
			return true
	return false


func _message_id_exists_anywhere(message_id: String) -> bool:
	for thread_id in _source["messages_by_thread"]:
		if _message_id_exists(_source["messages_by_thread"][thread_id], message_id):
			return true
	return false


func _source_matches_metadata(candidate: Dictionary) -> bool:
	var required := ["characters", "threads", "messages_by_thread", "choices_by_thread"]
	for field in required:
		if not candidate.has(field):
			return false
	return (
		candidate["characters"] == _metadata["characters"]
		and candidate["threads"] is Array
		and candidate["messages_by_thread"] is Dictionary
		and candidate["choices_by_thread"] is Dictionary
	)


func _active_matches_execution(candidate: Dictionary) -> bool:
	var execution: Dictionary = _executor.execution_state()
	var request = candidate.get("request")
	if (
		typeof(request) != TYPE_DICTIONARY
		or not ProjectionContracts.validate_projection_request(request)["valid"]
		or candidate.get("presentation_id") != ProjectionContracts.presentation_id_for(request)
		or candidate.get("instance_id") != execution.get("instance_id")
		or candidate.get("beat_id") != execution.get("current_beat_id")
		or request.get("instance_id") != candidate.get("instance_id")
		or request.get("beat_id") != candidate.get("beat_id")
		or request.get("beat_type") != candidate.get("beat_type")
		or request.get("projection_target") != "MESSAGES"
	):
		return false
	var port_snapshot: Dictionary = _projection_port.snapshot()
	if not bool(port_snapshot.get("accepted", false)):
		return false
	var open_requests = port_snapshot.get("snapshot", {}).get("open_requests", [])
	if not open_requests is Array:
		return false
	if bool(candidate.get("projection_closed", false)):
		return open_requests.is_empty() and execution.get("execution_status") in [
			"ACTIVE", "RESOLUTION_READY", "RESOLVED_RETURN_PENDING"
		]
	return (
		open_requests == [request]
		and execution.get("execution_status") in [
			"WAITING_FOR_PROJECTION_ACK", "WAITING_FOR_PLAYER"
		]
	)


static func _validate_dependencies(executor, projection_port, metadata) -> String:
	if executor == null or typeof(executor) != TYPE_OBJECT:
		return "INVALID_EXECUTOR"
	for method_name in EXECUTOR_METHODS:
		if not executor.has_method(method_name):
			return "INVALID_EXECUTOR"
	if projection_port == null or typeof(projection_port) != TYPE_OBJECT:
		return "INVALID_PROJECTION_PORT"
	for method_name in PORT_METHODS:
		if not projection_port.has_method(method_name):
			return "INVALID_PROJECTION_PORT"
	if typeof(metadata) != TYPE_DICTIONARY:
		return "INVALID_PRESENTATION_METADATA"
	if typeof(metadata.get("characters")) != TYPE_DICTIONARY or not metadata.get("threads") is Array:
		return "INVALID_PRESENTATION_METADATA"
	var thread_ids: Array = []
	for thread in metadata["threads"]:
		if typeof(thread) != TYPE_DICTIONARY:
			return "INVALID_PRESENTATION_METADATA"
		var thread_id := str(thread.get("thread_id", ""))
		if thread_id.is_empty() or thread_id in thread_ids or not thread.get("participant_ids") is Array:
			return "INVALID_PRESENTATION_METADATA"
		thread_ids.append(thread_id)
	return ""


func _publish_result(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	_last_result = _result(ok, error_code, idempotent)
	return _last_result.duplicate(true)


static func _result(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	return {"ok": ok, "error_code": error_code, "idempotent": idempotent}
