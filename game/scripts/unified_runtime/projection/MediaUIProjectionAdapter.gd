extends RefCounted

class_name R8CMediaUIProjectionAdapter

signal projection_completed(result: Dictionary)

const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)
const EXECUTOR_METHODS := [
	"current_beat", "execution_state", "open_current_projection", "receive_ack", "receive_command",
]
const PORT_METHODS := ["snapshot"]
const RESOLVER_METHODS := ["resolve"]
const VIEWER_METHODS := ["configure", "focus_back", "reset_viewer"]

var _executor
var _projection_port
var _resolver
var _viewer
var _portrait_theme
var _active: Dictionary = {}
var _last_result := _result(false, "NOT_INITIALIZED")


static func create(executor, projection_port, resolver, viewer, portrait_theme) -> Dictionary:
	var error_code := _validate_dependencies(executor, projection_port, resolver, viewer, portrait_theme)
	if not error_code.is_empty():
		return {"ok": false, "error_code": error_code, "adapter": null}
	var adapter := new()
	adapter._executor = executor
	adapter._projection_port = projection_port
	adapter._resolver = resolver
	adapter._viewer = viewer
	adapter._portrait_theme = portrait_theme
	adapter._viewer.media_presented.connect(adapter._on_media_presented)
	adapter._viewer.close_requested.connect(adapter._on_close_requested)
	adapter._last_result = _result(true)
	return {"ok": true, "error_code": null, "adapter": adapter}


func photo_viewer():
	return _viewer


func execution_state() -> Dictionary:
	return _executor.execution_state() if _executor != null else {}


func current_beat() -> Dictionary:
	return _executor.current_beat() if _executor != null else {}


func active_projection() -> Dictionary:
	return _active.duplicate(true)


func last_result() -> Dictionary:
	return _last_result.duplicate(true)


func open_current_projection() -> Dictionary:
	if _executor == null:
		return _publish_result(false, "NOT_INITIALIZED")
	if not _viewer.is_inside_tree() or not _viewer.is_node_ready():
		return _publish_result(false, "PHOTO_VIEWER_NOT_READY")
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
	if not _viewer.is_inside_tree() or not _viewer.is_node_ready():
		return _publish_result(false, "PHOTO_VIEWER_NOT_READY")
	var execution: Dictionary = _executor.execution_state()
	var status := str(execution.get("execution_status", ""))
	if status not in ["WAITING_FOR_PROJECTION_ACK", "WAITING_FOR_PLAYER"]:
		return _publish_result(false, "EXECUTION_NOT_RESUMABLE")
	var beat: Dictionary = _executor.current_beat()
	var prepared := _prepare_beat(beat)
	if not prepared["ok"]:
		return _publish_result(false, prepared["error_code"])
	var expected_request := _request_for(beat, execution)
	var presentation_id := ProjectionContracts.presentation_id_for(expected_request)
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
	var expected_kind := "VIEWED" if prepared["requires_ack"] else "PRESENTED"
	var expected_receipt := _receipt_for(expected_request, presentation_id, expected_kind, prepared["media_id"])
	if status == "WAITING_FOR_PROJECTION_ACK":
		if not receipts.is_empty() or execution.get("projection_receipts", {}).has(presentation_id):
			return _publish_result(false, "RESUME_STATE_MISMATCH")
	else:
		if receipts != [expected_receipt]:
			return _publish_result(false, "RESUME_STATE_MISMATCH")
		if execution.get("projection_receipts", {}).get(presentation_id) != expected_kind:
			return _publish_result(false, "RESUME_STATE_MISMATCH")
		if not _pending_input_matches(execution.get("pending_player_input"), beat):
			return _publish_result(false, "RESUME_STATE_MISMATCH")
	var applied := _apply_opened_projection(
		expected_request,
		{"accepted": true, "presentation_id": presentation_id},
		prepared,
	)
	if not applied["ok"]:
		return _publish_result(false, applied["error_code"])
	if status == "WAITING_FOR_PLAYER":
		_active["progression_ack_sent"] = true
	return _publish_result(true)


func continue_current_projection() -> Dictionary:
	if _active.is_empty():
		return _publish_result(false, "PROJECTION_NOT_OPEN")
	if bool(_active.get("progression_command_sent", false)):
		return _publish_result(false, "COMMAND_ALREADY_SENT")
	if not bool(_active.get("progression_ack_sent", false)):
		return _publish_result(false, "PROJECTION_NOT_PRESENTED")
	if _executor.execution_state().get("execution_status") != "WAITING_FOR_PLAYER":
		return _publish_result(false, "EXECUTION_NOT_WAITING_FOR_COMMAND")
	var request: Dictionary = _active["request"]
	var command := _command_for(request)
	var received: Dictionary = _executor.receive_command(command)
	if not bool(received.get("ok", false)):
		return _publish_result(false, str(received.get("error_code", "COMMAND_REFUSED")))
	_active["progression_command_sent"] = true
	_dismiss_viewer()
	var completed := _publish_result(true, null, bool(received.get("idempotent", false)))
	_active = {}
	projection_completed.emit(completed.duplicate(true))
	return completed


func _prepare_beat(beat: Dictionary) -> Dictionary:
	if beat.is_empty():
		return {"ok": false, "error_code": "NO_CURRENT_BEAT"}
	if beat.get("projection_target") != "MEDIA":
		return {"ok": false, "error_code": "UNSUPPORTED_TARGET"}
	if beat.get("type") != "MEDIA_REVEAL":
		return {"ok": false, "error_code": "UNSUPPORTED_BEAT_TYPE"}
	var content = beat.get("content")
	if typeof(content) != TYPE_DICTIONARY:
		return {"ok": false, "error_code": "INVALID_MEDIA_REVEAL"}
	var media_id = content.get("media_id")
	var requires_ack = content.get("requires_ack")
	if typeof(media_id) != TYPE_STRING or media_id.is_empty() or typeof(requires_ack) != TYPE_BOOL:
		return {"ok": false, "error_code": "INVALID_MEDIA_REVEAL"}
	var resolved: Dictionary = _resolver.resolve(media_id)
	if not bool(resolved.get("ok", false)):
		return {"ok": false, "error_code": str(resolved.get("error_code", "MEDIA_RESOLUTION_FAILED"))}
	var presentation = resolved.get("presentation")
	if typeof(presentation) != TYPE_DICTIONARY or presentation.get("media_id") != media_id:
		return {"ok": false, "error_code": "MEDIA_IDENTITY_MISMATCH"}
	return {
		"ok": true,
		"error_code": null,
		"media_id": media_id,
		"requires_ack": requires_ack,
		"presentation": presentation.duplicate(true),
	}


func _apply_opened_projection(request: Dictionary, port_result: Dictionary, prepared: Dictionary) -> Dictionary:
	if not bool(port_result.get("accepted", false)):
		return {"ok": false, "error_code": "INVALID_OPEN_RESULT"}
	var presentation_id := str(port_result.get("presentation_id", ""))
	if presentation_id != ProjectionContracts.presentation_id_for(request):
		return {"ok": false, "error_code": "INVALID_OPEN_RESULT"}
	var media_presentation: Dictionary = prepared["presentation"]
	var viewer_presentation := {
		"photo_id": prepared["media_id"],
		"visual_ref": media_presentation["visual_ref"],
		"resolved_media": {
			"status": media_presentation["display_status"],
			"status_label": media_presentation["status_label"],
			"texture": media_presentation["texture"],
		},
		"access_state": "UNLOCKED",
		"source_kind": "media",
		"character_id": "",
		"display_name": media_presentation["display_name"],
		"context_label": media_presentation["context_label"],
		"timestamp": "",
		"caption": media_presentation["caption"],
		"placeholder_label": media_presentation["placeholder_label"],
	}
	_active = {
		"request": request.duplicate(true),
		"presentation_id": presentation_id,
		"media_id": prepared["media_id"],
		"requires_ack": prepared["requires_ack"],
		"progression_ack_sent": false,
		"progression_command_sent": false,
	}
	var sequence: Array[Dictionary] = [viewer_presentation]
	if not _viewer.configure(sequence, 0, _portrait_theme):
		_active = {}
		return {"ok": false, "error_code": "PHOTO_VIEWER_PRESENTATION_REFUSED"}
	_viewer.visible = true
	_viewer.focus_back()
	return {"ok": true, "error_code": null}


func _on_media_presented(media_id: String, _display_status: String) -> void:
	if (
		_active.is_empty()
		or bool(_active.get("progression_ack_sent", false))
		or media_id != _active.get("media_id")
	):
		return
	if _executor.execution_state().get("execution_status") != "WAITING_FOR_PROJECTION_ACK":
		_publish_result(false, "ACK_STATE_MISMATCH")
		return
	var request: Dictionary = _active["request"]
	var kind := "VIEWED" if _active["requires_ack"] else "PRESENTED"
	var receipt := _receipt_for(request, _active["presentation_id"], kind, media_id)
	var acknowledged: Dictionary = _executor.receive_ack(receipt)
	if not bool(acknowledged.get("ok", false)):
		_publish_result(false, str(acknowledged.get("error_code", "ACK_REFUSED")))
		return
	_active["progression_ack_sent"] = true
	_publish_result(true, null, bool(acknowledged.get("idempotent", false)))


func _on_close_requested() -> void:
	if _active.is_empty() or not bool(_active.get("progression_ack_sent", false)):
		return
	continue_current_projection()


func _dismiss_viewer() -> void:
	_viewer.visible = false
	_viewer.reset_viewer()


func _pending_input_matches(value, beat: Dictionary) -> bool:
	return (
		typeof(value) == TYPE_DICTIONARY
		and value.get("kind") == "CONTINUE"
		and value.get("beat_id") == beat["beat_id"]
		and value.get("allowed_choice_ids") == []
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


func _receipt_for(request: Dictionary, presentation_id: String, kind: String, subject_id: String) -> Dictionary:
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


func _command_for(request: Dictionary) -> Dictionary:
	var identity := "%s|%s|CONTINUE|null" % [request["instance_id"], request["beat_id"]]
	return {
		"command_id": "media_ui_" + identity.sha256_text(),
		"instance_id": request["instance_id"],
		"beat_id": request["beat_id"],
		"kind": "CONTINUE",
		"choice_id": null,
	}


static func _validate_dependencies(executor, projection_port, resolver, viewer, portrait_theme) -> String:
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
	if viewer == null or typeof(viewer) != TYPE_OBJECT:
		return "INVALID_PHOTO_VIEWER"
	for method_name in VIEWER_METHODS:
		if not viewer.has_method(method_name):
			return "INVALID_PHOTO_VIEWER"
	for signal_name in ["close_requested", "media_presented"]:
		if not viewer.has_signal(signal_name):
			return "INVALID_PHOTO_VIEWER"
	if portrait_theme == null or typeof(portrait_theme) != TYPE_OBJECT:
		return "INVALID_PORTRAIT_THEME"
	return ""


func _publish_result(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	_last_result = _result(ok, error_code, idempotent)
	return _last_result.duplicate(true)


static func _result(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	return {"ok": ok, "error_code": error_code, "idempotent": idempotent}
