extends "res://scripts/unified_runtime/contracts/PlayerProjectionPort.gd"

class_name R8CMessagesPhysicalProjectionPort

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)

const SUPPORTED_TARGETS := ["MESSAGES", "PHYSICAL"]
const COMMANDS_BY_BEAT_TYPE := {
	"MESSAGE": ["CONTINUE"],
	"CHOICE": ["SELECT_CHOICE"],
	"TRANSITION": ["CONTINUE"],
	"PHYSICAL_BEAT": ["CONTINUE", "WITHDRAW"],
	"AFTERCARE": ["CONTINUE"],
	"RETURN": ["CONTINUE"],
}

var _authored_sequence: Dictionary = {}
var _open_requests: Array = []
var _receipts: Array = []


func _init(authored_sequence = {}) -> void:
	if (
		typeof(authored_sequence) == TYPE_DICTIONARY
		and AuthoredValidator.validate(authored_sequence)["valid"]
	):
		_authored_sequence = authored_sequence.duplicate(true)


func supports_projection(projection_target: String) -> Dictionary:
	var supported := projection_target in SUPPORTED_TARGETS
	return {
		"supported": supported,
		"error_code": null if supported else "UNSUPPORTED_PROJECTION",
	}


func open(request: Dictionary) -> Dictionary:
	if not ProjectionContracts.validate_projection_request(request)["valid"]:
		return _error_result(request.get("projection_target", "NONE"), "INVALID_REQUEST")
	if request["projection_target"] not in SUPPORTED_TARGETS:
		return _error_result(request["projection_target"], "UNSUPPORTED_PROJECTION")
	var beat := _beat_for_request(request)
	if beat.is_empty():
		return _error_result(request["projection_target"], "AUTHORED_BEAT_MISMATCH")
	if not COMMANDS_BY_BEAT_TYPE.has(beat["type"]):
		return _error_result(request["projection_target"], "UNSUPPORTED_BEAT_TYPE")
	var presentation_id := ProjectionContracts.presentation_id_for(request)
	for existing in _open_requests:
		if ProjectionContracts.presentation_id_for(existing) != presentation_id:
			continue
		if existing != request:
			return _error_result(request["projection_target"], "DIVERGENT_REQUEST")
		return _accepted_result(request, beat, true)
	if not _open_requests.is_empty():
		return _error_result(request["projection_target"], "PROJECTION_ALREADY_OPEN")
	_open_requests.append(request.duplicate(true))
	return _accepted_result(request, beat, false)


func submit(command: Dictionary) -> Dictionary:
	if not ProjectionContracts.validate_projection_command(command)["valid"]:
		return _error_result("NONE", "INVALID_COMMAND")
	var request := _request_for_command(command)
	if request.is_empty():
		return _error_result("NONE", "PROJECTION_NOT_OPEN")
	var beat := _beat_for_request(request)
	var allowed_commands: Array = COMMANDS_BY_BEAT_TYPE.get(beat.get("type"), [])
	if command["kind"] not in allowed_commands:
		return _error_result(request["projection_target"], "COMMAND_NOT_ALLOWED")
	if command["kind"] == "SELECT_CHOICE" and not _beat_has_choice(beat, command["choice_id"]):
		return _error_result(request["projection_target"], "UNKNOWN_CHOICE")
	if (
		command["kind"] == "WITHDRAW"
		and command["choice_id"] not in beat["content"]["withdrawal_choice_ids"]
	):
		return _error_result(request["projection_target"], "WITHDRAWAL_CHOICE_NOT_ALLOWED")
	return _accepted_result(request, beat, false)


func acknowledge(receipt: Dictionary) -> Dictionary:
	if not ProjectionContracts.validate_presentation_receipt(receipt)["valid"]:
		return _error_result("NONE", "INVALID_RECEIPT")
	var request := _request_for_presentation(receipt["presentation_id"])
	if request.is_empty():
		return _error_result("NONE", "RECEIPT_WITHOUT_OPEN")
	if not ProjectionContracts.validate_receipt_against_request(receipt, request)["valid"]:
		return _error_result(request["projection_target"], "RECEIPT_IDENTITY_MISMATCH")
	for existing in _receipts:
		if existing == receipt:
			return _accepted_result(request, _beat_for_request(request), true)
	_receipts.append(receipt.duplicate(true))
	return _accepted_result(request, _beat_for_request(request), false)


func snapshot() -> Dictionary:
	var data := {
		"snapshot_version": 1,
		"open_requests": _open_requests.duplicate(true),
		"receipts": _receipts.duplicate(true),
	}
	return {"accepted": true, "snapshot": data, "error_code": null}


func restore(snapshot_data: Dictionary) -> Dictionary:
	if not ProjectionContracts.validate_port_snapshot(snapshot_data)["valid"]:
		return {"accepted": false, "error_code": "INVALID_SNAPSHOT"}
	if snapshot_data["open_requests"].size() > 1:
		return {"accepted": false, "error_code": "INVALID_SNAPSHOT"}
	for request in snapshot_data["open_requests"]:
		if (
			request["projection_target"] not in SUPPORTED_TARGETS
			or _beat_for_request(request).is_empty()
			or not COMMANDS_BY_BEAT_TYPE.has(request["beat_type"])
		):
			return {"accepted": false, "error_code": "INVALID_SNAPSHOT"}
	_open_requests = snapshot_data["open_requests"].duplicate(true)
	_receipts = snapshot_data["receipts"].duplicate(true)
	return {"accepted": true, "error_code": null}


func close(presentation_id: String) -> Dictionary:
	var request := _request_for_presentation(presentation_id)
	if request.is_empty():
		return _error_result("NONE", "PROJECTION_NOT_OPEN")
	for index in range(_open_requests.size() - 1, -1, -1):
		if ProjectionContracts.presentation_id_for(_open_requests[index]) == presentation_id:
			_open_requests.remove_at(index)
	for index in range(_receipts.size() - 1, -1, -1):
		if _receipts[index]["presentation_id"] == presentation_id:
			_receipts.remove_at(index)
	return {
		"accepted": true,
		"idempotent": false,
		"projection_target": request["projection_target"],
		"presentation_id": presentation_id,
		"payload": {},
		"next_command_kinds": [],
		"error_code": null,
	}


func _accepted_result(request: Dictionary, beat: Dictionary, idempotent: bool) -> Dictionary:
	return {
		"accepted": true,
		"idempotent": idempotent,
		"projection_target": request["projection_target"],
		"presentation_id": ProjectionContracts.presentation_id_for(request),
		"payload": {
			"beat_type": beat["type"],
			"participant_ids": beat["participant_ids"].duplicate(true),
			"content": beat["content"].duplicate(true),
		},
		"next_command_kinds": COMMANDS_BY_BEAT_TYPE[beat["type"]].duplicate(),
		"error_code": null,
	}


func _error_result(projection_target: String, error_code: String) -> Dictionary:
	return {
		"accepted": false,
		"idempotent": false,
		"projection_target": (
			projection_target
			if projection_target in ["MESSAGES", "PHYSICAL", "MEDIA", "GALLERY", "PHOTO_VIEWER", "NONE"]
			else "NONE"
		),
		"presentation_id": null,
		"payload": {},
		"next_command_kinds": [],
		"error_code": error_code,
	}


func _beat_for_request(request: Dictionary) -> Dictionary:
	if (
		_authored_sequence.is_empty()
		or request["sequence_id"] != _authored_sequence["sequence_id"]
		or request["authored_version"] != _authored_sequence["authored_version"]
	):
		return {}
	for beat in _authored_sequence["beats"]:
		if beat["beat_id"] != request["beat_id"]:
			continue
		if (
			beat["type"] != request["beat_type"]
			or beat["projection_target"] != request["projection_target"]
		):
			return {}
		return beat
	return {}


func _request_for_command(command: Dictionary) -> Dictionary:
	for request in _open_requests:
		if (
			request["instance_id"] == command["instance_id"]
			and request["beat_id"] == command["beat_id"]
		):
			return request
	return {}


func _request_for_presentation(presentation_id: String) -> Dictionary:
	for request in _open_requests:
		if ProjectionContracts.presentation_id_for(request) == presentation_id:
			return request
	return {}


func _beat_has_choice(beat: Dictionary, choice_id: String) -> bool:
	if beat.get("type") != "CHOICE":
		return false
	for choice in beat["content"]["choices"]:
		if choice["choice_id"] == choice_id:
			return true
	return false
