extends RefCounted

class_name R8CUnifiedPlayerRuntimeSession

signal gallery_source_changed(source: Dictionary)
signal runtime_failed(error_code: String)

const ReturnGate := preload(
	"res://scripts/unified_runtime/application/DeferredReturnGate.gd"
)
const Moment := preload("res://scripts/unified_runtime/application/NarrativeMoment.gd")
const DurableGallery := preload(
	"res://scripts/unified_runtime/projection/DurableGalleryProjection.gd"
)

var _facade
var _executor
var _projection_coordinator
var _messages_adapter
var _physical_adapter
var _media_adapter
var _media_resolver
var _save_store
var _authored_sequence: Dictionary = {}
var _resolution_context: Dictionary = {}
var _narrative_time := ""
var _restored := false
var _initial_save_pending := false
var _durable_boundary_pending := false
var _gallery_source: Dictionary = {}
var _last_result := _result(false, "NOT_INITIALIZED")


static func create(dependencies: Dictionary) -> Dictionary:
	var required := [
		"facade", "executor", "projection_coordinator", "messages_adapter",
		"physical_adapter", "media_adapter", "media_resolver", "save_store",
		"authored_sequence", "resolution_context", "narrative_time", "restored",
	]
	for field in required:
		if not dependencies.has(field):
			return {"ok": false, "error_code": "MISSING_SESSION_DEPENDENCY", "session": null}
	if not Moment.validate(dependencies["narrative_time"]):
		return {"ok": false, "error_code": "INVALID_NARRATIVE_TIME", "session": null}
	var session := new()
	session._facade = dependencies["facade"]
	session._executor = dependencies["executor"]
	session._projection_coordinator = dependencies["projection_coordinator"]
	session._messages_adapter = dependencies["messages_adapter"]
	session._physical_adapter = dependencies["physical_adapter"]
	session._media_adapter = dependencies["media_adapter"]
	session._media_resolver = dependencies["media_resolver"]
	session._save_store = dependencies["save_store"]
	session._authored_sequence = dependencies["authored_sequence"].duplicate(true)
	session._resolution_context = dependencies["resolution_context"].duplicate(true)
	session._narrative_time = dependencies["narrative_time"]
	session._restored = dependencies["restored"]
	session._physical_adapter.projection_completed.connect(session._on_projection_completed)
	session._media_adapter.projection_completed.connect(session._on_projection_completed)
	var gallery := session._refresh_gallery(false)
	if not gallery["ok"]:
		return {"ok": false, "error_code": gallery["error_code"], "session": null}
	session._last_result = _result(true)
	return {"ok": true, "error_code": null, "session": session}


func begin() -> Dictionary:
	if not _restored:
		var started: Dictionary = _executor.start()
		if not started.get("ok", false):
			return _publish(false, str(started.get("error_code", "START_REFUSED")))
		_restored = true
		_initial_save_pending = true
	if _initial_save_pending:
		var saved := save_now()
		if not saved["ok"]:
			return saved
		_initial_save_pending = false
	return _route_current()


func advance_narrative_time(explicit_moment: String) -> Dictionary:
	if (
		execution_state().get("execution_status") != "RESOLVED_RETURN_PENDING"
		or
		not Moment.validate(explicit_moment)
		or not Moment.same_offset(_narrative_time, explicit_moment)
		or Moment.compare(explicit_moment, _narrative_time) < 0
	):
		return _publish(false, "INVALID_NARRATIVE_TIME_ADVANCE")
	_narrative_time = explicit_moment
	var saved := save_now()
	if not saved["ok"]:
		return saved
	return _route_current()


func save_now(messages_snapshot_override = null) -> Dictionary:
	var adapter_state = messages_snapshot_override
	if adapter_state == null:
		var adapter_snapshot: Dictionary = _messages_adapter.snapshot()
		if not adapter_snapshot.get("accepted", false):
			return _publish(false, "MESSAGES_SNAPSHOT_REFUSED")
		adapter_state = adapter_snapshot["snapshot"]
	var built: Dictionary = _executor.snapshot(adapter_state, _narrative_time)
	if not built.get("ok", false):
		return _publish(false, str(built.get("error_code", "SNAPSHOT_REFUSED")))
	var stored: Dictionary = _save_store.save_snapshot(built["payload"]["snapshot"])
	if not stored.get("ok", false):
		return _publish(false, str(stored.get("error_code", "SAVE_REFUSED")))
	return _publish(true)


func gallery_source() -> Dictionary:
	return _gallery_source.duplicate(true)


func narrative_time() -> String:
	return _narrative_time


func execution_state() -> Dictionary:
	return _executor.execution_state()


func durable_state() -> Dictionary:
	return _facade.save_state()


func describe_state() -> Dictionary:
	return {
		"execution": execution_state(),
		"narrative_time": _narrative_time,
		"gallery_source": gallery_source(),
		"save_path": _save_store.path(),
		"last_result": _last_result.duplicate(true),
	}


func attach_messages_screen(screen) -> void:
	_projection_coordinator.attach_messages_screen(screen)


func presentation_source() -> Dictionary:
	return _messages_adapter.presentation_source()


func presented_message_ids_by_thread() -> Dictionary:
	return _messages_adapter.presented_message_ids_by_thread()


func on_messages_ui_ready() -> void:
	_messages_adapter.on_messages_ui_ready()


func mark_message_presented(message_id: String) -> bool:
	var accepted: bool = bool(_messages_adapter.mark_message_presented(message_id))
	if accepted:
		return bool(save_now()["ok"])
	return accepted


func mark_thread_batch_presented(thread_id: String) -> bool:
	var accepted: bool = bool(_messages_adapter.mark_thread_batch_presented(thread_id))
	if accepted or execution_state().get("execution_status") == "RESOLVED_RETURN_PENDING":
		call_deferred("_settle_after_messages_progress")
	return accepted


func on_messages_delivery_completed(thread_id: String) -> void:
	_messages_adapter.on_messages_delivery_completed(thread_id)


func on_notification_presented(notification: Dictionary) -> Dictionary:
	var result: Dictionary = _messages_adapter.on_notification_presented(notification)
	if result.get("ok", false):
		var saved := save_now()
		if not saved["ok"]:
			return saved
	return result


func on_notification_dismissed(notification: Dictionary) -> Dictionary:
	var result: Dictionary = _messages_adapter.on_notification_dismissed(notification)
	if result.get("ok", false):
		var saved := save_now()
		if not saved["ok"]:
			return saved
	return result


func on_thread_read(thread_id: String, subject_id: String) -> Dictionary:
	var result: Dictionary = _messages_adapter.on_thread_read(thread_id, subject_id)
	if result.get("ok", false):
		call_deferred("_settle_after_messages_progress")
	return result


func on_choices_presented(thread_id: String, choice_ids: Array) -> Dictionary:
	var result: Dictionary = _messages_adapter.on_choices_presented(thread_id, choice_ids)
	if result.get("ok", false):
		var saved := save_now()
		if not saved["ok"]:
			return saved
	return result


func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if _durable_boundary_pending:
		var retried := _settle_durable_boundary()
		return {
			"accepted": bool(retried["ok"]),
			"error_code": retried.get("error_code"),
			"idempotent": bool(retried["ok"]),
		}
	var result: Dictionary = _messages_adapter.apply_choice(thread_id, choice_id)
	if not result.get("accepted", false):
		return result
	var committed := _commit_if_ready()
	if not committed["ok"]:
		result["accepted"] = false
		result["error_code"] = committed["error_code"]
	return result


func _commit_if_ready() -> Dictionary:
	if _durable_boundary_pending:
		return _settle_durable_boundary()
	if execution_state().get("execution_status") != "RESOLUTION_READY":
		return _publish(true)
	var context: Dictionary = _resolution_context.duplicate(true)
	context["moment_diegetique"] = _narrative_time
	var committed: Dictionary = _executor.commit_resolution(context)
	if not committed.get("ok", false):
		return _publish(false, str(committed.get("error_code", "A10_COMMIT_REFUSED")))
	_durable_boundary_pending = true
	return _settle_durable_boundary()


func _settle_durable_boundary() -> Dictionary:
	var gallery := _gallery_source_from_domain()
	if not gallery["ok"]:
		return gallery
	var adapter_boundary: Dictionary = _messages_adapter.settle_durable_boundary()
	if not adapter_boundary.get("accepted", false):
		return _publish(false, str(adapter_boundary.get("error_code", "MESSAGES_BOUNDARY_REFUSED")))
	var saved := save_now()
	if not saved["ok"]:
		return saved
	_gallery_source = gallery["source"].duplicate(true)
	_durable_boundary_pending = false
	gallery_source_changed.emit(_gallery_source.duplicate(true))
	return _publish(true)


func _refresh_gallery(emit_change: bool) -> Dictionary:
	var gallery := _gallery_source_from_domain()
	if not gallery["ok"]:
		return gallery
	_gallery_source = gallery["source"].duplicate(true)
	if emit_change:
		gallery_source_changed.emit(_gallery_source.duplicate(true))
	return _publish(true)


func _gallery_source_from_domain() -> Dictionary:
	var domain: Dictionary = _facade.save_state()
	var registry = domain.get("narrative_state", {}).get("livraison_medias")
	if typeof(registry) != TYPE_DICTIONARY:
		return _publish(false, "INVALID_DURABLE_MEDIA_REGISTRY")
	var created := DurableGallery.create(_authored_sequence, registry, _media_resolver)
	if not created.get("ok", false):
		return _publish(false, str(created.get("error_code", "GALLERY_PROJECTION_REFUSED")))
	var source_result: Dictionary = created["projection"].content_source()
	if not source_result.get("ok", false):
		return _publish(false, str(source_result.get("error_code", "GALLERY_SOURCE_REFUSED")))
	return {"ok": true, "error_code": null, "source": source_result["source"].duplicate(true)}


func _settle_after_messages_progress() -> void:
	var requires_boundary: bool = (
		_durable_boundary_pending
		or execution_state().get("execution_status") == "RESOLUTION_READY"
	)
	var committed := _commit_if_ready()
	if not committed["ok"]:
		return
	if not requires_boundary:
		var saved := save_now()
		if not saved["ok"]:
			return
	_route_current()


func _on_projection_completed(_result: Dictionary) -> void:
	call_deferred("_settle_after_non_messages_progress")


func _settle_after_non_messages_progress() -> void:
	var requires_boundary: bool = (
		_durable_boundary_pending
		or execution_state().get("execution_status") == "RESOLUTION_READY"
	)
	var committed := _commit_if_ready()
	if not committed["ok"]:
		return
	if not requires_boundary:
		var saved := save_now()
		if not saved["ok"]:
			return
	if execution_state().get("execution_status") in ["ACTIVE", "RESOLVED_RETURN_PENDING"]:
		_route_current()


func _route_current() -> Dictionary:
	var execution := execution_state()
	match str(execution.get("execution_status", "")):
		"RESOLUTION_READY":
			var committed := _commit_if_ready()
			if not committed["ok"]:
				return committed
			return _route_current()
		"RESOLVED_RETURN_PENDING":
			if _messages_have_unpresented_content():
				return _publish(true)
			var gate := ReturnGate.evaluate(execution, _narrative_time, _facade.save_state())
			if not gate.get("ok", false):
				return _publish(false, str(gate.get("error_code", "RETURN_GATE_REFUSED")))
			if gate["status"] == ReturnGate.NOT_ELIGIBLE:
				return _publish(true)
			return _publish_from(_projection_coordinator.open_current_projection())
		"ACTIVE":
			return _publish_from(_projection_coordinator.open_current_projection())
		"WAITING_FOR_PROJECTION_ACK", "WAITING_FOR_PLAYER":
			if _executor.current_beat().get("projection_target") == "MESSAGES":
				return _publish(true)
			return _publish_from(_projection_coordinator.resume_from_execution())
		"COMPLETE":
			return _publish(true)
		_:
			return _publish(false, "UNSUPPORTED_EXECUTION_STATUS")


func _messages_have_unpresented_content() -> bool:
	var source: Dictionary = _messages_adapter.presentation_source()
	var presented: Dictionary = _messages_adapter.presented_message_ids_by_thread()
	for thread_id in source.get("messages_by_thread", {}):
		var messages: Array = source["messages_by_thread"][thread_id]
		if presented.get(thread_id, []).size() < messages.size():
			return true
	return false


func _publish_from(value: Dictionary) -> Dictionary:
	return _publish(
		bool(value.get("ok", false)),
		value.get("error_code"),
		bool(value.get("idempotent", false)),
	)


func _publish(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	_last_result = _result(ok, error_code, idempotent)
	if not ok:
		runtime_failed.emit(str(error_code))
	return _last_result.duplicate(true)


static func _result(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	return {"ok": ok, "error_code": error_code, "idempotent": idempotent}
