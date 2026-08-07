extends RefCounted

class_name R8CMessagesUIProjectionAdapter

const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)

const SNAPSHOT_VERSION := 1
const PLAYER_ID := "player"
const SUPPORTED_BEAT_TYPES := ["MESSAGE", "CHOICE"]
const MUTABLE_THREAD_FIELDS := [
	"has_unread_content", "last_preview", "last_timestamp", "unread_count",
]
const ACTIVE_FIELDS := [
	"authored_version",
	"beat_id",
	"beat_type",
	"choice_ids",
	"instance_id",
	"message_ids",
	"notification_message_id",
	"player_bubble_id",
	"presentation_id",
	"projection_closed",
	"request",
	"selected_choice_id",
	"sequence_id",
	"thread_id",
]
const AUTHORED_MESSAGE_FIELDS := [
	"author_id",
	"beat_id",
	"content_type",
	"diegetic_at",
	"is_player",
	"is_read",
	"media_ref",
	"message_id",
	"presentation_id",
	"relative_order",
	"sequence_id",
	"text",
	"timestamp",
]
const PLAYER_BUBBLE_FIELDS := [
	"author_id",
	"beat_id",
	"choice_id",
	"content_type",
	"is_player",
	"is_read",
	"media_ref",
	"message_id",
	"presentation_id",
	"sequence_id",
	"text",
	"timestamp",
]
const CHOICE_FIELDS := [
	"beat_id", "choice_id", "enabled", "presentation_id", "sequence_id", "text",
]
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
	var adapter := new()
	var error_code := adapter._initialize(executor, projection_port, presentation_metadata)
	if not error_code.is_empty():
		return {"ok": false, "error_code": error_code, "adapter": null}
	return {"ok": true, "error_code": null, "adapter": adapter}


func _initialize(executor, projection_port, presentation_metadata) -> String:
	var error_code := _validate_dependencies(executor, projection_port, presentation_metadata)
	if not error_code.is_empty():
		return error_code
	_executor = executor
	_projection_port = projection_port
	_metadata = presentation_metadata.duplicate(true)
	_source = _empty_source()
	_presented_message_ids_by_thread = _empty_presented_message_ids()
	_last_result = _result(true)
	return ""


func attach_messages_screen(screen) -> void:
	_messages_screen = screen


func on_messages_ui_ready() -> void:
	if _messages_screen == null or _active.is_empty():
		return
	if _is_message_beat_type(_active.get("beat_type")) and not _notification_dismissed:
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
	var projection_validation := _validate_beat_projection(
		beat, prepared["content"], prepared["thread"]
	)
	if not projection_validation["ok"]:
		return _publish_result(false, projection_validation["error_code"])
	var opened: Dictionary = _executor.open_current_projection()
	if not bool(opened.get("ok", false)):
		return _publish_result(false, str(opened.get("error_code", "PROJECTION_OPEN_REFUSED")))
	var payload: Dictionary = opened.get("payload", {})
	var request: Dictionary = payload.get("request", {})
	var port_result: Dictionary = payload.get("port_result", {})
	var applied := _apply_opened_projection(
		request, port_result, prepared["thread"], prepared["content"]
	)
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
		_notification_presented = false
		_notification_dismissed = false
		_progression_ack_sent = false
		_progression_command_sent = false
		if _should_automatically_open_next_projection():
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
		or not _is_message_beat_type(_active.get("beat_type"))
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
	if _should_automatically_open_next_projection():
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
	var bubble := _player_bubble_dto(selected_choice, _active)
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
	var candidate_source: Dictionary = snapshot_data["source"].duplicate(true)
	if not _source_matches_metadata(candidate_source):
		return _publish_result(false, "INVALID_SNAPSHOT")
	var candidate_presented: Dictionary = snapshot_data["presented_message_ids_by_thread"].duplicate(true)
	if not _presented_ids_match_source(candidate_presented, candidate_source):
		return _publish_result(false, "INVALID_SNAPSHOT")
	var candidate_active: Dictionary = snapshot_data["active"].duplicate(true)
	if not _active_matches_execution(
		candidate_active,
		candidate_source,
		candidate_presented,
		bool(snapshot_data["notification_presented"]),
		bool(snapshot_data["notification_dismissed"]),
		bool(snapshot_data["progression_ack_sent"]),
		bool(snapshot_data["progression_command_sent"]),
	):
		return _publish_result(false, "INVALID_SNAPSHOT")
	_source = candidate_source.duplicate(true)
	_active = candidate_active.duplicate(true)
	_presented_message_ids_by_thread = candidate_presented.duplicate(true)
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
	var content: Dictionary = beat.get("content", {}).duplicate(true)
	var resolved := _resolve_thread(beat.get("participant_ids", []))
	if not resolved["ok"]:
		return resolved
	var authored_thread_id := str(content.get("thread_id", ""))
	if authored_thread_id != str(resolved["thread"].get("thread_id", "")):
		return {"ok": false, "error_code": "THREAD_ID_MISMATCH"}
	return {
		"ok": true,
		"error_code": null,
		"thread": resolved["thread"],
		"content": content,
	}


func _validate_beat_projection(
	beat: Dictionary, content: Dictionary, thread: Dictionary
) -> Dictionary:
	var thread_id := str(thread.get("thread_id", ""))
	if beat.get("type") == "CHOICE":
		if not _metadata["characters"].has(PLAYER_ID) or not _thread_accepts_author(thread_id, PLAYER_ID):
			return {"ok": false, "error_code": "UNRESOLVED_PLAYER_METADATA"}
		return {"ok": true, "error_code": null}
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
	return {"ok": true, "error_code": null}


func _apply_opened_projection(
	request: Dictionary, port_result: Dictionary, thread: Dictionary, resolved_content: Dictionary
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
	if _is_message_beat_type(beat_type):
		return _project_messages(resolved_content, thread_id)
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
		var message := _authored_message_dto(authored_message, _active)
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
		projected.append(_choice_dto(authored_choice, _active))
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
	var prepared := _prepare_beat(beat)
	if not prepared.get("ok", false):
		_last_result = _result(false, prepared.get("error_code", "PROJECTION_PREFLIGHT_REFUSED"))
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


func _empty_presented_message_ids() -> Dictionary:
	var result := {}
	for thread in _metadata["threads"]:
		result[str(thread.get("thread_id", ""))] = []
	return result


func _validate_notification_callback(notification: Dictionary) -> String:
	if _active.is_empty() or bool(_active.get("projection_closed", false)):
		return "PROJECTION_NOT_OPEN"
	if not _is_message_beat_type(_active.get("beat_type")):
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
		return (
			_is_message_beat_type(_active.get("beat_type"))
			and subject_id in _active.get("message_ids", [])
		)
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


func _authored_message_dto(authored_message: Dictionary, active: Dictionary) -> Dictionary:
	var author_id := str(authored_message.get("author_id", ""))
	var diegetic_at := str(authored_message.get("diegetic_at", ""))
	return {
		"message_id": str(authored_message.get("message_id", "")),
		"author_id": author_id,
		"timestamp": _timestamp_for_diegetic(diegetic_at),
		"content_type": "TEXT",
		"text": str(authored_message.get("text", "")),
		"media_ref": "",
		"is_player": author_id == PLAYER_ID,
		"is_read": author_id == PLAYER_ID,
		"diegetic_at": diegetic_at,
		"relative_order": authored_message.get("relative_order"),
		"sequence_id": active["sequence_id"],
		"beat_id": active["beat_id"],
		"presentation_id": active["presentation_id"],
	}


func _choice_dto(authored_choice: Dictionary, active: Dictionary) -> Dictionary:
	return {
		"choice_id": str(authored_choice.get("choice_id", "")),
		"text": str(authored_choice.get("text", "")),
		"enabled": true,
		"sequence_id": active["sequence_id"],
		"beat_id": active["beat_id"],
		"presentation_id": active["presentation_id"],
	}


func _player_bubble_dto(authored_choice: Dictionary, active: Dictionary) -> Dictionary:
	var choice_id := str(authored_choice.get("choice_id", ""))
	return {
		"message_id": "%s__choice__%s__player" % [active["presentation_id"], choice_id],
		"author_id": PLAYER_ID,
		"timestamp": "",
		"content_type": "TEXT",
		"text": str(authored_choice.get("text", "")),
		"media_ref": "",
		"is_player": true,
		"is_read": true,
		"sequence_id": active["sequence_id"],
		"beat_id": active["beat_id"],
		"presentation_id": active["presentation_id"],
		"choice_id": choice_id,
	}


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
	var expected_source := _empty_source()
	if (
		not _has_exact_keys(candidate, expected_source.keys())
		or candidate.get("characters") != _metadata["characters"]
		or typeof(candidate.get("threads")) != TYPE_ARRAY
		or typeof(candidate.get("messages_by_thread")) != TYPE_DICTIONARY
		or typeof(candidate.get("choices_by_thread")) != TYPE_DICTIONARY
	):
		return false
	for optional_field in ["narrative_day_short", "narrative_time"]:
		if _metadata.has(optional_field) and candidate.get(optional_field) != _metadata[optional_field]:
			return false
	var thread_ids: Array = []
	for expected_thread in _metadata["threads"]:
		thread_ids.append(str(expected_thread.get("thread_id", "")))
	if (
		not _has_exact_keys(candidate["messages_by_thread"], thread_ids)
		or not _has_exact_keys(candidate["choices_by_thread"], thread_ids)
		or candidate["threads"].size() != _metadata["threads"].size()
	):
		return false
	var execution: Dictionary = _executor.execution_state()
	var seen_message_ids := {}
	var seen_choice_ids := {}
	for index in range(_metadata["threads"].size()):
		var expected_thread: Dictionary = _metadata["threads"][index]
		var candidate_thread = candidate["threads"][index]
		if typeof(candidate_thread) != TYPE_DICTIONARY or not _thread_snapshot_matches_catalog(
			candidate_thread, expected_thread
		):
			return false
		var thread_id := str(expected_thread["thread_id"])
		var messages = candidate["messages_by_thread"][thread_id]
		var choices = candidate["choices_by_thread"][thread_id]
		if typeof(messages) != TYPE_ARRAY or typeof(choices) != TYPE_ARRAY:
			return false
		if not _messages_are_closed(messages, thread_id, execution, seen_message_ids, seen_choice_ids):
			return false
		if not _choices_are_closed(choices, thread_id, execution, seen_choice_ids):
			return false
		if not _thread_mutable_fields_match_messages(candidate_thread, expected_thread, messages):
			return false
	return true


func _thread_snapshot_matches_catalog(candidate: Dictionary, expected: Dictionary) -> bool:
	if not _has_exact_keys(candidate, expected.keys()):
		return false
	for field in expected:
		if field not in MUTABLE_THREAD_FIELDS and candidate[field] != expected[field]:
			return false
	return (
		typeof(candidate.get("last_preview")) == TYPE_STRING
		and typeof(candidate.get("last_timestamp")) == TYPE_STRING
		and typeof(candidate.get("unread_count")) == TYPE_INT
		and int(candidate.get("unread_count")) >= 0
		and typeof(candidate.get("has_unread_content")) == TYPE_BOOL
	)


func _thread_mutable_fields_match_messages(
	candidate: Dictionary, expected: Dictionary, messages: Array
) -> bool:
	var unread_count := 0
	for message in messages:
		if not bool(message.get("is_player", false)) and not bool(message.get("is_read", false)):
			unread_count += 1
	if (
		candidate.get("unread_count") != unread_count
		or candidate.get("has_unread_content") != (unread_count > 0)
	):
		return false
	if messages.is_empty():
		return (
			candidate.get("last_preview") == expected.get("last_preview")
			and candidate.get("last_timestamp") == expected.get("last_timestamp")
		)
	var tail: Dictionary = messages[-1]
	return (
		candidate.get("last_preview") == tail.get("text")
		and candidate.get("last_timestamp") == tail.get("timestamp")
	)


func _messages_are_closed(
	messages: Array,
	thread_id: String,
	execution: Dictionary,
	seen_message_ids: Dictionary,
	seen_choice_ids: Dictionary,
) -> bool:
	for value in messages:
		if typeof(value) != TYPE_DICTIONARY:
			return false
		var message: Dictionary = value
		var message_id := str(message.get("message_id", ""))
		var author_id := str(message.get("author_id", ""))
		var beat_id := str(message.get("beat_id", ""))
		var presentation_id := str(message.get("presentation_id", ""))
		if (
			message_id.is_empty()
			or seen_message_ids.has(message_id)
			or not _metadata["characters"].has(author_id)
			or not _thread_accepts_author(thread_id, author_id)
			or str(message.get("sequence_id", "")) != str(execution.get("sequence_id", ""))
			or beat_id.is_empty()
			or presentation_id != "%s__%s__MESSAGES" % [execution.get("instance_id", ""), beat_id]
			or presentation_id not in execution.get("opened_projection_ids", [])
			or typeof(message.get("text")) != TYPE_STRING
			or typeof(message.get("timestamp")) != TYPE_STRING
			or message.get("content_type") != "TEXT"
			or message.get("media_ref") != ""
			or typeof(message.get("is_player")) != TYPE_BOOL
			or typeof(message.get("is_read")) != TYPE_BOOL
			or bool(message.get("is_player")) != (author_id == PLAYER_ID)
		):
			return false
		if message.has("choice_id"):
			var choice_id := str(message.get("choice_id", ""))
			if (
				not _has_exact_keys(message, PLAYER_BUBBLE_FIELDS)
				or author_id != PLAYER_ID
				or not bool(message.get("is_read"))
				or message.get("timestamp") != ""
				or choice_id.is_empty()
				or seen_choice_ids.has(choice_id)
				or choice_id not in execution.get("consumed_choice_ids", [])
				or message_id != "%s__choice__%s__player" % [presentation_id, choice_id]
			):
				return false
			seen_choice_ids[choice_id] = true
		else:
			if (
				not _has_exact_keys(message, AUTHORED_MESSAGE_FIELDS)
				or typeof(message.get("diegetic_at")) != TYPE_STRING
				or typeof(message.get("relative_order")) != TYPE_INT
				or message.get("timestamp") != _timestamp_for_diegetic(message.get("diegetic_at"))
			):
				return false
		seen_message_ids[message_id] = true
	return true


func _choices_are_closed(
	choices: Array, thread_id: String, execution: Dictionary, seen_choice_ids: Dictionary
) -> bool:
	if not _thread_accepts_author(thread_id, PLAYER_ID):
		return choices.is_empty()
	for value in choices:
		if typeof(value) != TYPE_DICTIONARY:
			return false
		var choice: Dictionary = value
		var choice_id := str(choice.get("choice_id", ""))
		var beat_id := str(choice.get("beat_id", ""))
		var presentation_id := str(choice.get("presentation_id", ""))
		if (
			not _has_exact_keys(choice, CHOICE_FIELDS)
			or choice_id.is_empty()
			or seen_choice_ids.has(choice_id)
			or typeof(choice.get("text")) != TYPE_STRING
			or choice.get("enabled") != true
			or str(choice.get("sequence_id", "")) != str(execution.get("sequence_id", ""))
			or beat_id.is_empty()
			or presentation_id != "%s__%s__MESSAGES" % [execution.get("instance_id", ""), beat_id]
			or presentation_id not in execution.get("opened_projection_ids", [])
		):
			return false
		seen_choice_ids[choice_id] = true
	return true


func _presented_ids_match_source(candidate: Dictionary, source: Dictionary) -> bool:
	var thread_ids: Array = source["messages_by_thread"].keys()
	if not _has_exact_keys(candidate, thread_ids):
		return false
	for thread_id in thread_ids:
		var presented = candidate[thread_id]
		if typeof(presented) != TYPE_ARRAY:
			return false
		var source_ids: Array = []
		for message in source["messages_by_thread"][thread_id]:
			source_ids.append(str(message.get("message_id", "")))
		var seen := {}
		for message_id in presented:
			if typeof(message_id) != TYPE_STRING or message_id.is_empty() or seen.has(message_id):
				return false
			seen[message_id] = true
		if presented.size() > source_ids.size() or presented != source_ids.slice(0, presented.size()):
			return false
	return true


func _active_matches_execution(
	candidate: Dictionary,
	source: Dictionary,
	presented: Dictionary,
	notification_presented: bool,
	notification_dismissed: bool,
	progression_ack_sent: bool,
	progression_command_sent: bool,
) -> bool:
	var execution: Dictionary = _executor.execution_state()
	var port_snapshot: Dictionary = _projection_port.snapshot()
	if not bool(port_snapshot.get("accepted", false)):
		return false
	var port_data = port_snapshot.get("snapshot")
	if (
		typeof(port_data) != TYPE_DICTIONARY
		or typeof(port_data.get("open_requests")) != TYPE_ARRAY
		or typeof(port_data.get("receipts")) != TYPE_ARRAY
	):
		return false
	if candidate.is_empty():
		return (
			port_data["open_requests"].is_empty()
			and port_data["receipts"].is_empty()
			and _all_choices_empty(source)
			and not notification_presented
			and not notification_dismissed
			and not progression_ack_sent
			and not progression_command_sent
			and execution.get("execution_status") in [
				"ACTIVE", "COMPLETE", "RESOLUTION_READY", "RESOLVED_RETURN_PENDING"
			]
		)
	if not _has_exact_keys(candidate, ACTIVE_FIELDS):
		return false
	var beat: Dictionary = _executor.current_beat()
	var prepared := _prepare_beat(beat)
	if not prepared.get("ok", false):
		return false
	var request = candidate.get("request")
	var expected_request := {
		"instance_id": execution.get("instance_id"),
		"sequence_id": execution.get("sequence_id"),
		"authored_version": execution.get("authored_version"),
		"beat_id": beat.get("beat_id"),
		"beat_type": beat.get("type"),
		"projection_target": "MESSAGES",
		"presentation_state": [],
	}
	var presentation_id := ProjectionContracts.presentation_id_for(expected_request)
	var thread_id := str(prepared["thread"].get("thread_id", ""))
	if (
		typeof(request) != TYPE_DICTIONARY
		or request != expected_request
		or not ProjectionContracts.validate_projection_request(request)["valid"]
		or candidate.get("presentation_id") != presentation_id
		or candidate.get("instance_id") != execution.get("instance_id")
		or candidate.get("sequence_id") != execution.get("sequence_id")
		or candidate.get("authored_version") != execution.get("authored_version")
		or candidate.get("beat_id") != beat.get("beat_id")
		or candidate.get("beat_type") != beat.get("type")
		or candidate.get("thread_id") != thread_id
		or typeof(candidate.get("message_ids")) != TYPE_ARRAY
		or typeof(candidate.get("choice_ids")) != TYPE_ARRAY
		or typeof(candidate.get("projection_closed")) != TYPE_BOOL
		or typeof(candidate.get("notification_message_id")) != TYPE_STRING
		or typeof(candidate.get("selected_choice_id")) != TYPE_STRING
		or typeof(candidate.get("player_bubble_id")) != TYPE_STRING
	):
		return false
	if _is_message_beat_type(beat.get("type")):
		return _active_message_matches(
			candidate,
			beat,
			prepared["content"],
			source,
			presented,
			port_data,
			notification_presented,
			notification_dismissed,
			progression_ack_sent,
			progression_command_sent,
		)
	return _active_choice_matches(
		candidate,
		beat,
		source,
		port_data,
		execution,
		notification_presented,
		notification_dismissed,
		progression_ack_sent,
		progression_command_sent,
	)


func _active_message_matches(
	candidate: Dictionary,
	beat: Dictionary,
	content: Dictionary,
	source: Dictionary,
	presented: Dictionary,
	port_data: Dictionary,
	notification_presented: bool,
	notification_dismissed: bool,
	progression_ack_sent: bool,
	progression_command_sent: bool,
) -> bool:
	var expected_messages: Array = []
	var expected_ids: Array = []
	var notification_message_id := ""
	for authored_message in content.get("messages", []):
		expected_messages.append(_authored_message_dto(authored_message, candidate))
		expected_ids.append(str(authored_message.get("message_id", "")))
		if str(authored_message.get("author_id", "")) != PLAYER_ID:
			notification_message_id = str(authored_message.get("message_id", ""))
	var current_messages := _messages_for_presentation(source, candidate["presentation_id"])
	if (
		candidate["message_ids"] != expected_ids
		or not candidate["choice_ids"].is_empty()
		or candidate["notification_message_id"] != notification_message_id
		or bool(candidate["projection_closed"])
		or candidate["selected_choice_id"] != ""
		or candidate["player_bubble_id"] != ""
		or progression_ack_sent
		or progression_command_sent
		or notification_dismissed and not notification_presented
		or current_messages != expected_messages
		or not _all_choices_empty(source)
		or port_data["open_requests"] != [candidate["request"]]
		or _executor.execution_state().get("execution_status") != "WAITING_FOR_PROJECTION_ACK"
	):
		return false
	var notification_subject := "%s::%s" % [candidate["thread_id"], notification_message_id]
	if notification_presented != _port_has_receipt(port_data, "PRESENTED", notification_subject):
		return false
	if notification_dismissed != _port_has_receipt(port_data, "DISMISSED", notification_subject):
		return false
	for message_id in expected_ids:
		var is_presented: bool = message_id in presented[candidate["thread_id"]]
		if is_presented != _port_has_receipt(port_data, "PRESENTED", message_id):
			return false
	return true


func _active_choice_matches(
	candidate: Dictionary,
	beat: Dictionary,
	source: Dictionary,
	port_data: Dictionary,
	execution: Dictionary,
	notification_presented: bool,
	notification_dismissed: bool,
	progression_ack_sent: bool,
	progression_command_sent: bool,
) -> bool:
	var expected_choices: Array = []
	var expected_ids: Array = []
	for authored_choice in beat.get("content", {}).get("choices", []):
		expected_choices.append(_choice_dto(authored_choice, candidate))
		expected_ids.append(str(authored_choice.get("choice_id", "")))
	if (
		candidate["choice_ids"] != expected_ids
		or not candidate["message_ids"].is_empty()
		or candidate["notification_message_id"] != ""
		or notification_presented
		or notification_dismissed
	):
		return false
	var closed := bool(candidate["projection_closed"])
	if not closed:
		var executor_ack: bool = (
			execution.get("projection_receipts", {}).get(candidate["presentation_id"]) == "PRESENTED"
		)
		return (
			candidate["selected_choice_id"] == ""
			and candidate["player_bubble_id"] == ""
			and not progression_command_sent
			and progression_ack_sent == executor_ack
			and progression_ack_sent == _port_has_receipt(
				port_data, "PRESENTED", expected_ids[0] if not expected_ids.is_empty() else candidate["beat_id"]
			)
			and source["choices_by_thread"][candidate["thread_id"]] == expected_choices
			and _messages_for_presentation(source, candidate["presentation_id"]).is_empty()
			and port_data["open_requests"] == [candidate["request"]]
			and execution.get("execution_status") == (
				"WAITING_FOR_PLAYER" if progression_ack_sent else "WAITING_FOR_PROJECTION_ACK"
			)
		)
	var selected_choice_id := str(candidate["selected_choice_id"])
	var authored_choice := _authored_choice_by_id(beat, selected_choice_id)
	if authored_choice.is_empty():
		return false
	var expected_bubble := _player_bubble_dto(authored_choice, candidate)
	return (
		progression_ack_sent
		and progression_command_sent
		and selected_choice_id in execution.get("consumed_choice_ids", [])
		and candidate["player_bubble_id"] == expected_bubble["message_id"]
		and source["choices_by_thread"][candidate["thread_id"]].is_empty()
		and _messages_for_presentation(source, candidate["presentation_id"]) == [expected_bubble]
		and port_data["open_requests"].is_empty()
		and port_data["receipts"].is_empty()
		and execution.get("execution_status") == "RESOLUTION_READY"
		and execution.get("pending_player_input") == null
	)


func _messages_for_presentation(source: Dictionary, presentation_id: String) -> Array:
	var result: Array = []
	for thread_id in source["messages_by_thread"]:
		for message in source["messages_by_thread"][thread_id]:
			if str(message.get("presentation_id", "")) == presentation_id:
				result.append(message)
	return result


func _authored_choice_by_id(beat: Dictionary, choice_id: String) -> Dictionary:
	for choice in beat.get("content", {}).get("choices", []):
		if str(choice.get("choice_id", "")) == choice_id:
			return choice
	return {}


func _all_choices_empty(source: Dictionary) -> bool:
	for thread_id in source["choices_by_thread"]:
		if not source["choices_by_thread"][thread_id].is_empty():
			return false
	return true


func _port_has_receipt(port_data: Dictionary, kind: String, subject_id: String) -> bool:
	for receipt in port_data["receipts"]:
		if receipt.get("kind") == kind and receipt.get("subject_id") == subject_id:
			return true
	return false


func _has_exact_keys(value: Dictionary, expected_keys: Array) -> bool:
	var actual: Array = value.keys()
	var expected: Array = expected_keys.duplicate()
	actual.sort()
	expected.sort()
	return actual == expected


func _is_message_beat_type(beat_type) -> bool:
	return beat_type == "MESSAGE"


func _should_automatically_open_next_projection() -> bool:
	return true


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
