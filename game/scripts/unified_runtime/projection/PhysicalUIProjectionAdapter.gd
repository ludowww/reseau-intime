extends RefCounted

class_name R8CPhysicalUIProjectionAdapter

signal projection_completed(result: Dictionary)

const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)

const EXECUTOR_METHODS := [
	"current_beat", "execution_state", "open_current_projection", "receive_ack", "receive_command",
]
const PORT_METHODS := ["snapshot"]
const RESOLVER_METHODS := ["resolve_physical_beat"]
const SCREEN_METHODS := [
	"dismiss", "present_physical_beat", "present_transition", "presentation_data",
]

var _executor
var _projection_port
var _resolver
var _screen
var _active: Dictionary = {}
var _last_result := _result(false, "NOT_INITIALIZED")
var _detached := false


static func create(executor, projection_port, resolver, screen) -> Dictionary:
	var error_code := _validate_dependencies(executor, projection_port, resolver, screen)
	if not error_code.is_empty():
		return {"ok": false, "error_code": error_code, "adapter": null}
	var adapter := new()
	adapter._executor = executor
	adapter._projection_port = projection_port
	adapter._resolver = resolver
	adapter._screen = screen
	adapter._screen.continue_requested.connect(adapter._on_continue_requested)
	adapter._screen.withdraw_requested.connect(adapter._on_withdraw_requested)
	adapter._screen.presentation_ready.connect(adapter._on_presentation_ready)
	adapter._last_result = _result(true)
	return {"ok": true, "error_code": null, "adapter": adapter}


func physical_screen():
	return _screen


func detach() -> void:
	if _detached:
		return
	_detached = true
	if _screen != null and is_instance_valid(_screen):
		if _screen.continue_requested.is_connected(_on_continue_requested):
			_screen.continue_requested.disconnect(_on_continue_requested)
		if _screen.withdraw_requested.is_connected(_on_withdraw_requested):
			_screen.withdraw_requested.disconnect(_on_withdraw_requested)
		if _screen.presentation_ready.is_connected(_on_presentation_ready):
			_screen.presentation_ready.disconnect(_on_presentation_ready)
		_screen.dismiss()
		_screen.queue_free()
	_active = {}
	_executor = null
	_projection_port = null


func execution_state() -> Dictionary:
	return _executor.execution_state() if _executor != null else {}


func current_beat() -> Dictionary:
	return _executor.current_beat() if _executor != null else {}


func active_projection() -> Dictionary:
	return _active.duplicate(true)


func last_result() -> Dictionary:
	return _last_result.duplicate(true)


func open_current_projection() -> Dictionary:
	if _detached:
		return _publish_result(false, "ADAPTER_DETACHED")
	if _executor == null:
		return _publish_result(false, "NOT_INITIALIZED")
	if not _screen.is_inside_tree() or not _screen.is_node_ready():
		return _publish_result(false, "PHYSICAL_SCREEN_NOT_READY")
	var execution: Dictionary = _executor.execution_state()
	if execution.get("execution_status") not in ["ACTIVE", "RESOLVED_RETURN_PENDING"]:
		return _publish_result(false, "EXECUTION_NOT_READY_FOR_PROJECTION")
	var beat: Dictionary = _executor.current_beat()
	var prepared := _prepare_beat(beat)
	if not prepared["ok"]:
		return _publish_result(false, prepared["error_code"])
	var opened: Dictionary = _executor.open_current_projection()
	if not bool(opened.get("ok", false)):
		return _publish_result(false, str(opened.get("error_code", "PROJECTION_OPEN_REFUSED")))
	var request = opened.get("payload", {}).get("request")
	var port_result = opened.get("payload", {}).get("port_result")
	if typeof(request) != TYPE_DICTIONARY or typeof(port_result) != TYPE_DICTIONARY:
		return _publish_result(false, "INVALID_OPEN_RESULT")
	var applied := _apply_opened_projection(request, port_result, prepared)
	if not applied["ok"]:
		return _publish_result(false, applied["error_code"])
	return _publish_result(true, null, bool(opened.get("idempotent", false)))


func resume_from_execution() -> Dictionary:
	if _executor == null:
		return _publish_result(false, "NOT_INITIALIZED")
	if not _screen.is_inside_tree() or not _screen.is_node_ready():
		return _publish_result(false, "PHYSICAL_SCREEN_NOT_READY")
	var execution: Dictionary = _executor.execution_state()
	var status := str(execution.get("execution_status", ""))
	if status not in ["WAITING_FOR_PROJECTION_ACK", "WAITING_FOR_PLAYER"]:
		return _publish_result(false, "EXECUTION_NOT_RESUMABLE")
	var beat: Dictionary = _executor.current_beat()
	var prepared := _prepare_beat(beat)
	if not prepared["ok"]:
		return _publish_result(false, prepared["error_code"])
	var expected_request := _request_for(beat, execution)
	var expected_presentation_id := ProjectionContracts.presentation_id_for(expected_request)
	var port_state: Dictionary = _projection_port.snapshot()
	if not bool(port_state.get("accepted", false)):
		return _publish_result(false, "PORT_SNAPSHOT_REFUSED")
	var snapshot = port_state.get("snapshot")
	if typeof(snapshot) != TYPE_DICTIONARY:
		return _publish_result(false, "RESUME_STATE_MISMATCH")
	var open_requests = snapshot.get("open_requests")
	var receipts = snapshot.get("receipts")
	if (
		typeof(open_requests) != TYPE_ARRAY
		or open_requests.size() != 1
		or open_requests[0] != expected_request
		or typeof(receipts) != TYPE_ARRAY
	):
		return _publish_result(false, "RESUME_STATE_MISMATCH")
	var expected_receipt := _receipt_for(
		expected_request,
		expected_presentation_id,
		"PRESENTED",
		prepared["subject_id"],
	)
	if status == "WAITING_FOR_PROJECTION_ACK":
		if not receipts.is_empty() or execution.get("projection_receipts", {}).has(expected_presentation_id):
			return _publish_result(false, "RESUME_STATE_MISMATCH")
	else:
		if receipts != [expected_receipt]:
			return _publish_result(false, "RESUME_STATE_MISMATCH")
		if execution.get("projection_receipts", {}).get(expected_presentation_id) != "PRESENTED":
			return _publish_result(false, "RESUME_STATE_MISMATCH")
		if not _pending_input_matches(execution.get("pending_player_input"), beat, prepared):
			return _publish_result(false, "RESUME_STATE_MISMATCH")
	var resumed_port_result := {
		"accepted": true,
		"presentation_id": expected_presentation_id,
	}
	var applied := _apply_opened_projection(expected_request, resumed_port_result, prepared)
	if not applied["ok"]:
		return _publish_result(false, applied["error_code"])
	if status == "WAITING_FOR_PLAYER":
		_active["progression_ack_sent"] = true
	return _publish_result(true)


func continue_current_projection() -> Dictionary:
	return _submit_command("CONTINUE", null)


func withdraw(choice_id: String) -> Dictionary:
	if (
		_active.is_empty()
		or _active.get("beat_type") != "PHYSICAL_BEAT"
		or choice_id not in _active.get("withdrawal_choice_ids", [])
	):
		return _publish_result(false, "WITHDRAWAL_CHOICE_NOT_ALLOWED")
	return _submit_command("WITHDRAW", choice_id)


func _prepare_beat(beat: Dictionary) -> Dictionary:
	if beat.is_empty():
		return {"ok": false, "error_code": "NO_CURRENT_BEAT"}
	if beat.get("projection_target") != "PHYSICAL":
		return {"ok": false, "error_code": "UNSUPPORTED_TARGET"}
	if beat.get("type") == "TRANSITION":
		var content = beat.get("content")
		if typeof(content) != TYPE_DICTIONARY:
			return {"ok": false, "error_code": "INVALID_TRANSITION"}
		var transition_id = content.get("transition_id")
		var continuation_label = content.get("continuation_label")
		if (
			typeof(transition_id) != TYPE_STRING
			or transition_id.is_empty()
			or typeof(continuation_label) != TYPE_STRING
			or continuation_label.is_empty()
		):
			return {"ok": false, "error_code": "INVALID_TRANSITION"}
		return {
			"ok": true,
			"error_code": null,
			"beat_type": "TRANSITION",
			"subject_id": transition_id,
			"presentation": {
				"transition_id": transition_id,
				"continuation_label": continuation_label,
			},
			"withdrawal_choice_ids": [],
		}
	if beat.get("type") != "PHYSICAL_BEAT":
		return {"ok": false, "error_code": "UNSUPPORTED_BEAT_TYPE"}
	var resolved: Dictionary = _resolver.resolve_physical_beat(beat)
	if not bool(resolved.get("ok", false)):
		return {
			"ok": false,
			"error_code": str(resolved.get("error_code", "PHYSICAL_CONTENT_RESOLUTION_FAILED")),
		}
	var presentation: Dictionary = resolved["presentation"]
	var withdrawal_choice_ids: Array = []
	for action in presentation["withdrawal_actions"]:
		withdrawal_choice_ids.append(action["choice_id"])
	return {
		"ok": true,
		"error_code": null,
		"beat_type": "PHYSICAL_BEAT",
		"subject_id": presentation["physical_beat_id"],
		"presentation": presentation.duplicate(true),
		"withdrawal_choice_ids": withdrawal_choice_ids,
	}


func _apply_opened_projection(
	request: Dictionary,
	port_result: Dictionary,
	prepared: Dictionary,
) -> Dictionary:
	if not bool(port_result.get("accepted", false)):
		return {"ok": false, "error_code": "INVALID_OPEN_RESULT"}
	var presentation_id := str(port_result.get("presentation_id", ""))
	if presentation_id != ProjectionContracts.presentation_id_for(request):
		return {"ok": false, "error_code": "INVALID_OPEN_RESULT"}
	_active = {
		"request": request.duplicate(true),
		"presentation_id": presentation_id,
		"beat_type": prepared["beat_type"],
		"subject_id": prepared["subject_id"],
		"withdrawal_choice_ids": prepared["withdrawal_choice_ids"].duplicate(),
		"progression_ack_sent": false,
		"progression_command_sent": false,
	}
	var presented := false
	if prepared["beat_type"] == "TRANSITION":
		presented = _screen.present_transition(prepared["presentation"])
	else:
		presented = _screen.present_physical_beat(prepared["presentation"])
	if not presented:
		_active = {}
		return {"ok": false, "error_code": "SCREEN_PRESENTATION_REFUSED"}
	return {"ok": true, "error_code": null}


func _on_presentation_ready() -> void:
	if _active.is_empty() or bool(_active.get("progression_ack_sent", false)):
		return
	var execution: Dictionary = _executor.execution_state()
	if execution.get("execution_status") != "WAITING_FOR_PROJECTION_ACK":
		_publish_result(false, "ACK_STATE_MISMATCH")
		return
	var request: Dictionary = _active["request"]
	var receipt := _receipt_for(
		request,
		_active["presentation_id"],
		"PRESENTED",
		_active["subject_id"],
	)
	var acknowledged: Dictionary = _executor.receive_ack(receipt)
	if not bool(acknowledged.get("ok", false)):
		_publish_result(false, str(acknowledged.get("error_code", "ACK_REFUSED")))
		return
	_active["progression_ack_sent"] = true
	_publish_result(true, null, bool(acknowledged.get("idempotent", false)))


func _on_continue_requested() -> void:
	continue_current_projection()


func _on_withdraw_requested(choice_id: String) -> void:
	withdraw(choice_id)


func _submit_command(kind: String, choice_id) -> Dictionary:
	if _active.is_empty():
		return _publish_result(false, "PROJECTION_NOT_OPEN")
	if bool(_active.get("progression_command_sent", false)):
		return _publish_result(false, "COMMAND_ALREADY_SENT")
	if not bool(_active.get("progression_ack_sent", false)):
		return _publish_result(false, "PROJECTION_NOT_PRESENTED")
	var execution: Dictionary = _executor.execution_state()
	if execution.get("execution_status") != "WAITING_FOR_PLAYER":
		return _publish_result(false, "EXECUTION_NOT_WAITING_FOR_COMMAND")
	var request: Dictionary = _active["request"]
	var command := _command_for(request, kind, choice_id)
	var received: Dictionary = _executor.receive_command(command)
	if not bool(received.get("ok", false)):
		return _publish_result(false, str(received.get("error_code", "COMMAND_REFUSED")))
	_active["progression_command_sent"] = true
	_screen.dismiss()
	var completed := _publish_result(true, null, bool(received.get("idempotent", false)))
	_active = {}
	projection_completed.emit(completed.duplicate(true))
	return completed


func _pending_input_matches(value, beat: Dictionary, prepared: Dictionary) -> bool:
	if typeof(value) != TYPE_DICTIONARY:
		return false
	var expected_choices: Array = prepared["withdrawal_choice_ids"] if beat["type"] == "PHYSICAL_BEAT" else []
	return (
		value.get("kind") == "CONTINUE"
		and value.get("beat_id") == beat["beat_id"]
		and value.get("allowed_choice_ids") == expected_choices
	)


func _request_for(beat: Dictionary, execution: Dictionary) -> Dictionary:
	return {
		"instance_id": execution["instance_id"],
		"sequence_id": execution["sequence_id"],
		"authored_version": execution["authored_version"],
		"beat_id": beat["beat_id"],
		"beat_type": beat["type"],
		"projection_target": beat["projection_target"],
		"presentation_state": [],
	}


func _receipt_for(
	request: Dictionary,
	presentation_id: String,
	kind: String,
	subject_id: String,
) -> Dictionary:
	return {
		"presentation_id": presentation_id,
		"instance_id": request["instance_id"],
		"sequence_id": request["sequence_id"],
		"authored_version": request["authored_version"],
		"beat_id": request["beat_id"],
		"beat_type": request["beat_type"],
		"projection_target": request["projection_target"],
		"kind": kind,
		"subject_id": subject_id,
	}


func _command_for(request: Dictionary, kind: String, choice_id) -> Dictionary:
	var identity := "%s|%s|%s|%s" % [
		request["instance_id"], request["beat_id"], kind, str(choice_id),
	]
	return {
		"command_id": "physical_ui_" + identity.sha256_text(),
		"instance_id": request["instance_id"],
		"beat_id": request["beat_id"],
		"kind": kind,
		"choice_id": choice_id,
	}


static func _validate_dependencies(executor, projection_port, resolver, screen) -> String:
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
	if resolver == null or typeof(resolver) != TYPE_OBJECT:
		return "INVALID_RESOLVER"
	for method_name in RESOLVER_METHODS:
		if not resolver.has_method(method_name):
			return "INVALID_RESOLVER"
	if screen == null or typeof(screen) != TYPE_OBJECT:
		return "INVALID_PHYSICAL_SCREEN"
	for method_name in SCREEN_METHODS:
		if not screen.has_method(method_name):
			return "INVALID_PHYSICAL_SCREEN"
	for signal_name in ["continue_requested", "withdraw_requested", "presentation_ready"]:
		if not screen.has_signal(signal_name):
			return "INVALID_PHYSICAL_SCREEN"
	return ""


func _publish_result(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	_last_result = _result(ok, error_code, idempotent)
	return _last_result.duplicate(true)


static func _result(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	return {"ok": ok, "error_code": error_code, "idempotent": idempotent}
