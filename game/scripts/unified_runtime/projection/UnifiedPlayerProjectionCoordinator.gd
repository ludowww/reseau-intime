extends RefCounted

class_name R8CUnifiedPlayerProjectionCoordinator

const BASE_METHODS := [
	"apply_choice", "attach_messages_screen", "mark_message_presented", "mark_thread_batch_presented",
	"on_choices_presented", "on_messages_delivery_completed", "on_messages_ui_ready",
	"on_notification_dismissed", "on_notification_presented", "on_thread_read", "open_current_projection",
	"physical_screen", "presentation_source", "presented_message_ids_by_thread", "resume_from_execution",
]
const MEDIA_METHODS := [
	"current_beat", "execution_state", "open_current_projection", "photo_viewer", "resume_from_execution",
]

var _messages_physical_coordinator
var _media_adapter
var _last_result := _result(false, "NOT_INITIALIZED")
var _route_pending := false


static func create(messages_physical_coordinator, media_adapter) -> Dictionary:
	var error_code := _validate_dependencies(messages_physical_coordinator, media_adapter)
	if not error_code.is_empty():
		return {"ok": false, "error_code": error_code, "coordinator": null}
	var coordinator := new()
	coordinator._messages_physical_coordinator = messages_physical_coordinator
	coordinator._media_adapter = media_adapter
	coordinator._media_adapter.projection_completed.connect(coordinator._on_media_projection_completed)
	coordinator._last_result = _result(true)
	return {"ok": true, "error_code": null, "coordinator": coordinator}


func attach_messages_screen(screen) -> void:
	_messages_physical_coordinator.attach_messages_screen(screen)


func presentation_source() -> Dictionary:
	return _messages_physical_coordinator.presentation_source()


func presented_message_ids_by_thread() -> Dictionary:
	return _messages_physical_coordinator.presented_message_ids_by_thread()


func on_messages_ui_ready() -> void:
	_messages_physical_coordinator.on_messages_ui_ready()


func mark_message_presented(message_id: String) -> bool:
	return _messages_physical_coordinator.mark_message_presented(message_id)


func mark_thread_batch_presented(thread_id: String) -> bool:
	return _messages_physical_coordinator.mark_thread_batch_presented(thread_id)


func on_messages_delivery_completed(thread_id: String) -> void:
	_messages_physical_coordinator.on_messages_delivery_completed(thread_id)


func on_notification_presented(notification: Dictionary) -> Dictionary:
	return _messages_physical_coordinator.on_notification_presented(notification)


func on_notification_dismissed(notification: Dictionary) -> Dictionary:
	return _messages_physical_coordinator.on_notification_dismissed(notification)


func on_thread_read(thread_id: String, subject_id: String) -> Dictionary:
	var result: Dictionary = _messages_physical_coordinator.on_thread_read(thread_id, subject_id)
	if result.get("ok", false):
		_queue_route()
	return result


func on_choices_presented(thread_id: String, choice_ids: Array) -> Dictionary:
	return _messages_physical_coordinator.on_choices_presented(thread_id, choice_ids)


func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	var result: Dictionary = _messages_physical_coordinator.apply_choice(thread_id, choice_id)
	if result.get("accepted", false):
		_queue_route()
	return result


func open_current_projection() -> Dictionary:
	return _route_current_projection()


func resume_from_execution() -> Dictionary:
	var status := str(_media_adapter.execution_state().get("execution_status", ""))
	if status in ["RESOLUTION_READY", "COMPLETE"]:
		return _publish_result(true)
	match str(_media_adapter.current_beat().get("projection_target", "")):
		"MESSAGES", "PHYSICAL":
			return _publish_from(_messages_physical_coordinator.resume_from_execution())
		"MEDIA":
			return _publish_from(_media_adapter.resume_from_execution())
		_:
			return _publish_result(false, "UNSUPPORTED_PROJECTION_TARGET")


func physical_screen():
	return _messages_physical_coordinator.physical_screen()


func photo_viewer():
	return _media_adapter.photo_viewer()


func last_result() -> Dictionary:
	return _last_result.duplicate(true)


func _on_media_projection_completed(_result: Dictionary) -> void:
	_route_current_projection()


func _queue_route() -> void:
	if _route_pending:
		return
	_route_pending = true
	call_deferred("_run_queued_route")


func _run_queued_route() -> void:
	_route_pending = false
	_route_current_projection()


func _route_current_projection() -> Dictionary:
	var status := str(_media_adapter.execution_state().get("execution_status", ""))
	if status in ["RESOLUTION_READY", "COMPLETE"]:
		return _publish_result(true)
	if status not in ["ACTIVE", "RESOLVED_RETURN_PENDING"]:
		return _publish_result(false, "EXECUTION_NOT_READY_FOR_ROUTING")
	match str(_media_adapter.current_beat().get("projection_target", "")):
		"MESSAGES", "PHYSICAL":
			return _publish_from(_messages_physical_coordinator.open_current_projection())
		"MEDIA":
			return _publish_from(_media_adapter.open_current_projection())
		_:
			return _publish_result(false, "UNSUPPORTED_PROJECTION_TARGET")


func _publish_from(value: Dictionary) -> Dictionary:
	return _publish_result(
		bool(value.get("ok", false)),
		value.get("error_code"),
		bool(value.get("idempotent", false)),
	)


func _publish_result(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	_last_result = _result(ok, error_code, idempotent)
	return _last_result.duplicate(true)


static func _result(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	return {"ok": ok, "error_code": error_code, "idempotent": idempotent}


static func _validate_dependencies(messages_physical_coordinator, media_adapter) -> String:
	if messages_physical_coordinator == null or typeof(messages_physical_coordinator) != TYPE_OBJECT:
		return "INVALID_MESSAGES_PHYSICAL_COORDINATOR"
	for method_name in BASE_METHODS:
		if not messages_physical_coordinator.has_method(method_name):
			return "INVALID_MESSAGES_PHYSICAL_COORDINATOR"
	if media_adapter == null or typeof(media_adapter) != TYPE_OBJECT:
		return "INVALID_MEDIA_ADAPTER"
	for method_name in MEDIA_METHODS:
		if not media_adapter.has_method(method_name):
			return "INVALID_MEDIA_ADAPTER"
	if not media_adapter.has_signal("projection_completed"):
		return "INVALID_MEDIA_ADAPTER"
	return ""
