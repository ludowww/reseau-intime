extends "res://scripts/unified_runtime/contracts/PlayerProjectionPort.gd"

class_name R8CCompositePlayerProjectionPort

const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)
const REQUIRED_METHODS := [
	"supports_projection", "open", "submit", "acknowledge", "snapshot", "restore", "close",
]

var _messages_physical_port
var _media_port


static func create(messages_physical_port, media_port) -> Dictionary:
	if not _is_port(messages_physical_port):
		return _creation_failure("INVALID_MESSAGES_PHYSICAL_PORT")
	if not _is_port(media_port):
		return _creation_failure("INVALID_MEDIA_PORT")
	var composite := new()
	composite._messages_physical_port = messages_physical_port
	composite._media_port = media_port
	return {"ok": true, "error_code": null, "port": composite}


func supports_projection(projection_target: String) -> Dictionary:
	var delegate = _delegate_for_target(projection_target)
	if delegate == null:
		return {"supported": false, "error_code": "UNSUPPORTED_PROJECTION"}
	return delegate.supports_projection(projection_target)


func open(request: Dictionary) -> Dictionary:
	if not ProjectionContracts.validate_projection_request(request)["valid"]:
		return _error_result(request.get("projection_target", "NONE"), "INVALID_REQUEST")
	var delegate = _delegate_for_target(request["projection_target"])
	if delegate == null:
		return _error_result(request["projection_target"], "UNSUPPORTED_PROJECTION")
	var state := snapshot()
	if not state["accepted"]:
		return _error_result(request["projection_target"], "PORT_SNAPSHOT_REFUSED")
	var open_requests: Array = state["snapshot"]["open_requests"]
	if not open_requests.is_empty():
		var current: Dictionary = open_requests[0]
		if ProjectionContracts.presentation_id_for(current) != ProjectionContracts.presentation_id_for(request):
			return _error_result(request["projection_target"], "PROJECTION_ALREADY_OPEN")
	return delegate.open(request)


func submit(command: Dictionary) -> Dictionary:
	if not ProjectionContracts.validate_projection_command(command)["valid"]:
		return _error_result("NONE", "INVALID_COMMAND")
	var request := _request_for_command(command)
	if request.is_empty():
		return _error_result("NONE", "PROJECTION_NOT_OPEN")
	return _delegate_for_target(request["projection_target"]).submit(command)


func acknowledge(receipt: Dictionary) -> Dictionary:
	if not ProjectionContracts.validate_presentation_receipt(receipt)["valid"]:
		return _error_result("NONE", "INVALID_RECEIPT")
	var request := _request_for_presentation(receipt["presentation_id"])
	if request.is_empty() or request["projection_target"] != receipt["projection_target"]:
		return _error_result("NONE", "RECEIPT_WITHOUT_OPEN")
	return _delegate_for_target(request["projection_target"]).acknowledge(receipt)


func snapshot() -> Dictionary:
	var combined := {"snapshot_version": 1, "open_requests": [], "receipts": []}
	for delegate in [_messages_physical_port, _media_port]:
		var result: Dictionary = delegate.snapshot()
		if not bool(result.get("accepted", false)):
			return {"accepted": false, "snapshot": {}, "error_code": "DELEGATE_SNAPSHOT_REFUSED"}
		var value = result.get("snapshot")
		if typeof(value) != TYPE_DICTIONARY:
			return {"accepted": false, "snapshot": {}, "error_code": "INVALID_DELEGATE_SNAPSHOT"}
		combined["open_requests"].append_array(value.get("open_requests", []))
		combined["receipts"].append_array(value.get("receipts", []))
	if combined["open_requests"].size() > 1 or not ProjectionContracts.validate_port_snapshot(combined)["valid"]:
		return {"accepted": false, "snapshot": {}, "error_code": "INVALID_COMPOSITE_STATE"}
	return {"accepted": true, "snapshot": combined.duplicate(true), "error_code": null}


func restore(snapshot_data: Dictionary) -> Dictionary:
	if (
		not ProjectionContracts.validate_port_snapshot(snapshot_data)["valid"]
		or snapshot_data["open_requests"].size() > 1
	):
		return {"accepted": false, "error_code": "INVALID_SNAPSHOT"}
	var split := {
		"messages_physical": {"snapshot_version": 1, "open_requests": [], "receipts": []},
		"media": {"snapshot_version": 1, "open_requests": [], "receipts": []},
	}
	for request in snapshot_data["open_requests"]:
		var key := _key_for_target(request["projection_target"])
		if key.is_empty():
			return {"accepted": false, "error_code": "INVALID_SNAPSHOT"}
		split[key]["open_requests"].append(request.duplicate(true))
	for receipt in snapshot_data["receipts"]:
		var key := _key_for_target(receipt["projection_target"])
		if key.is_empty():
			return {"accepted": false, "error_code": "INVALID_SNAPSHOT"}
		split[key]["receipts"].append(receipt.duplicate(true))
	var before_messages: Dictionary = _messages_physical_port.snapshot()
	var before_media: Dictionary = _media_port.snapshot()
	if not before_messages.get("accepted", false) or not before_media.get("accepted", false):
		return {"accepted": false, "error_code": "DELEGATE_SNAPSHOT_REFUSED"}
	var first: Dictionary = _messages_physical_port.restore(split["messages_physical"])
	if not bool(first.get("accepted", false)):
		return {"accepted": false, "error_code": "DELEGATE_RESTORE_REFUSED"}
	var second: Dictionary = _media_port.restore(split["media"])
	if not bool(second.get("accepted", false)):
		_messages_physical_port.restore(before_messages["snapshot"])
		_media_port.restore(before_media["snapshot"])
		return {"accepted": false, "error_code": "DELEGATE_RESTORE_REFUSED"}
	return {"accepted": true, "error_code": null}


func close(presentation_id: String) -> Dictionary:
	var request := _request_for_presentation(presentation_id)
	if request.is_empty():
		return _error_result("NONE", "PROJECTION_NOT_OPEN")
	return _delegate_for_target(request["projection_target"]).close(presentation_id)


func _request_for_command(command: Dictionary) -> Dictionary:
	var state := snapshot()
	if not state.get("accepted", false):
		return {}
	for request in state["snapshot"]["open_requests"]:
		if request["instance_id"] == command["instance_id"] and request["beat_id"] == command["beat_id"]:
			return request
	return {}


func _request_for_presentation(presentation_id: String) -> Dictionary:
	var state := snapshot()
	if not state.get("accepted", false):
		return {}
	for request in state["snapshot"]["open_requests"]:
		if ProjectionContracts.presentation_id_for(request) == presentation_id:
			return request
	return {}


func _delegate_for_target(projection_target: String):
	match projection_target:
		"MESSAGES", "PHYSICAL":
			return _messages_physical_port
		"MEDIA":
			return _media_port
		_:
			return null


func _key_for_target(projection_target: String) -> String:
	match projection_target:
		"MESSAGES", "PHYSICAL":
			return "messages_physical"
		"MEDIA":
			return "media"
		_:
			return ""


static func _is_port(value) -> bool:
	if value == null or typeof(value) != TYPE_OBJECT:
		return false
	for method_name in REQUIRED_METHODS:
		if not value.has_method(method_name):
			return false
	return true


static func _creation_failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "port": null}


func _error_result(projection_target: String, error_code: String) -> Dictionary:
	var target := projection_target if projection_target in ["MESSAGES", "PHYSICAL", "MEDIA"] else "NONE"
	return {
		"accepted": false,
		"idempotent": false,
		"projection_target": target,
		"presentation_id": null,
		"payload": {},
		"next_command_kinds": [],
		"error_code": error_code,
	}
