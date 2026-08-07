extends RefCounted

class_name R8CMessagesPhysicalUIProjectionCoordinator

const REQUIRED_MESSAGES_METHODS := [
	"apply_choice",
	"attach_messages_screen",
	"mark_message_presented",
	"mark_thread_batch_presented",
	"on_choices_presented",
	"on_messages_delivery_completed",
	"on_messages_ui_ready",
	"on_notification_dismissed",
	"on_notification_presented",
	"on_thread_read",
	"open_current_projection",
	"presentation_source",
	"presented_message_ids_by_thread",
]
const REQUIRED_PHYSICAL_METHODS := [
	"current_beat", "execution_state", "open_current_projection", "physical_screen",
	"resume_from_execution",
]

var _messages_adapter
var _physical_adapter
var _messages_screen
var _physical_screen
var _last_result := _result(false, "NOT_INITIALIZED")
var _route_pending := false


static func create(messages_adapter, physical_adapter) -> Dictionary:
	var error_code := _validate_dependencies(messages_adapter, physical_adapter)
	if not error_code.is_empty():
		return {"ok": false, "error_code": error_code, "coordinator": null}
	var coordinator := new()
	coordinator._messages_adapter = messages_adapter
	coordinator._physical_adapter = physical_adapter
	coordinator._physical_screen = physical_adapter.physical_screen()
	coordinator._physical_adapter.projection_completed.connect(
		coordinator._on_physical_projection_completed
	)
	coordinator._last_result = _result(true)
	return {"ok": true, "error_code": null, "coordinator": coordinator}


func attach_messages_screen(screen) -> void:
	_messages_screen = screen
	_messages_adapter.attach_messages_screen(screen)
	if screen.is_node_ready():
		_mount_physical_screen()
	elif not screen.ready.is_connected(_mount_physical_screen):
		screen.ready.connect(_mount_physical_screen, CONNECT_ONE_SHOT)


func _mount_physical_screen() -> void:
	if _messages_screen == null or not is_instance_valid(_messages_screen):
		_last_result = _result(false, "MESSAGES_SCREEN_NOT_AVAILABLE")
		return
	if _physical_screen.get_parent() == null:
		_messages_screen.add_child(_physical_screen)
	elif _physical_screen.get_parent() != _messages_screen:
		_last_result = _result(false, "PHYSICAL_SCREEN_ALREADY_MOUNTED")
		return
	_physical_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_physical_screen.z_index = 1000
	_physical_screen.visible = false


func presentation_source() -> Dictionary:
	return _messages_adapter.presentation_source()


func presented_message_ids_by_thread() -> Dictionary:
	return _messages_adapter.presented_message_ids_by_thread()


func on_messages_ui_ready() -> void:
	_messages_adapter.on_messages_ui_ready()


func mark_message_presented(message_id: String) -> bool:
	return _messages_adapter.mark_message_presented(message_id)


func mark_thread_batch_presented(thread_id: String) -> bool:
	return _messages_adapter.mark_thread_batch_presented(thread_id)


func on_messages_delivery_completed(thread_id: String) -> void:
	_messages_adapter.on_messages_delivery_completed(thread_id)


func on_notification_presented(notification: Dictionary) -> Dictionary:
	return _messages_adapter.on_notification_presented(notification)


func on_notification_dismissed(notification: Dictionary) -> Dictionary:
	return _messages_adapter.on_notification_dismissed(notification)


func on_thread_read(thread_id: String, subject_id: String) -> Dictionary:
	var result: Dictionary = _messages_adapter.on_thread_read(thread_id, subject_id)
	if result.get("ok", false):
		_queue_route()
	return result


func on_choices_presented(thread_id: String, choice_ids: Array) -> Dictionary:
	return _messages_adapter.on_choices_presented(thread_id, choice_ids)


func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	var result: Dictionary = _messages_adapter.apply_choice(thread_id, choice_id)
	if result.get("accepted", false):
		_queue_route()
	return result


func open_current_projection() -> Dictionary:
	return _route_current_projection()


func resume_from_execution() -> Dictionary:
	var execution: Dictionary = _physical_adapter.execution_state()
	var status := str(execution.get("execution_status", ""))
	if status in ["RESOLUTION_READY", "COMPLETE"]:
		return _publish_result(true)
	var beat: Dictionary = _physical_adapter.current_beat()
	match str(beat.get("projection_target", "")):
		"PHYSICAL":
			return _publish_from(_physical_adapter.resume_from_execution())
		"MESSAGES":
			return _publish_result(false, "MESSAGES_RESUME_REQUIRES_N15_2_STATE")
		_:
			return _publish_result(false, "UNSUPPORTED_PROJECTION_TARGET")


func physical_screen():
	return _physical_screen


func last_result() -> Dictionary:
	return _last_result.duplicate(true)


func _on_physical_projection_completed(_result: Dictionary) -> void:
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
	var execution: Dictionary = _physical_adapter.execution_state()
	var status := str(execution.get("execution_status", ""))
	if status in ["RESOLUTION_READY", "COMPLETE"]:
		return _publish_result(true)
	if status not in ["ACTIVE", "RESOLVED_RETURN_PENDING"]:
		return _publish_result(false, "EXECUTION_NOT_READY_FOR_ROUTING")
	var beat: Dictionary = _physical_adapter.current_beat()
	match str(beat.get("projection_target", "")):
		"MESSAGES":
			return _publish_from(_messages_adapter.open_current_projection())
		"PHYSICAL":
			return _publish_from(_physical_adapter.open_current_projection())
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


static func _validate_dependencies(messages_adapter, physical_adapter) -> String:
	if messages_adapter == null or typeof(messages_adapter) != TYPE_OBJECT:
		return "INVALID_MESSAGES_ADAPTER"
	for method_name in REQUIRED_MESSAGES_METHODS:
		if not messages_adapter.has_method(method_name):
			return "INVALID_MESSAGES_ADAPTER"
	if physical_adapter == null or typeof(physical_adapter) != TYPE_OBJECT:
		return "INVALID_PHYSICAL_ADAPTER"
	for method_name in REQUIRED_PHYSICAL_METHODS:
		if not physical_adapter.has_method(method_name):
			return "INVALID_PHYSICAL_ADAPTER"
	if not physical_adapter.has_signal("projection_completed"):
		return "INVALID_PHYSICAL_ADAPTER"
	return ""
