extends RefCounted

class_name R8CPlayerProjectionContracts

const AuthoredContract := preload("res://scripts/unified_runtime/contracts/AuthoredSequenceV1.gd")

const PROJECTION_REQUEST_FIELDS := [
	"instance_id",
	"sequence_id",
	"authored_version",
	"beat_id",
	"beat_type",
	"projection_target",
	"presentation_state",
]
const PROJECTION_COMMAND_FIELDS := ["command_id", "instance_id", "beat_id", "kind", "choice_id"]
const PRESENTATION_RECEIPT_FIELDS := [
	"presentation_id",
	"instance_id",
	"sequence_id",
	"authored_version",
	"beat_id",
	"beat_type",
	"projection_target",
	"kind",
	"subject_id",
]
const PROJECTION_RESULT_FIELDS := [
	"accepted",
	"idempotent",
	"projection_target",
	"presentation_id",
	"payload",
	"next_command_kinds",
	"error_code",
]
const PORT_SNAPSHOT_FIELDS := ["snapshot_version", "open_requests", "receipts"]
const COMMAND_KINDS := ["CONTINUE", "SELECT_CHOICE", "WITHDRAW", "OPEN_GALLERY", "OPEN_MEDIA", "CLOSE"]
const RECEIPT_KINDS := ["PRESENTED", "READ", "DISMISSED", "VIEWED"]


static func validate_projection_request(value) -> Dictionary:
	var errors: Array[String] = []
	if not _validate_dictionary(value, PROJECTION_REQUEST_FIELDS, "projection_request", errors):
		return _result(errors)
	_validate_identifier(value["instance_id"], "projection_request.instance_id", errors)
	_validate_identifier(value["sequence_id"], "projection_request.sequence_id", errors)
	if not _is_semver(value["authored_version"]):
		_add_error(errors, "projection_request.authored_version", "expected_major_minor_patch")
	_validate_identifier(value["beat_id"], "projection_request.beat_id", errors)
	if value["beat_type"] not in AuthoredContract.BEAT_TYPES:
		_add_error(errors, "projection_request.beat_type", "unknown_value")
	if value["projection_target"] not in AuthoredContract.PROJECTION_TARGETS:
		_add_error(errors, "projection_request.projection_target", "unknown_value")
	_validate_presentation_state(value["presentation_state"], value, errors)
	return _result(errors)


static func validate_projection_command(value) -> Dictionary:
	var errors: Array[String] = []
	if not _validate_dictionary(value, PROJECTION_COMMAND_FIELDS, "projection_command", errors):
		return _result(errors)
	for field in ["command_id", "instance_id", "beat_id"]:
		_validate_identifier(value[field], "projection_command." + field, errors)
	if value["kind"] not in COMMAND_KINDS:
		_add_error(errors, "projection_command.kind", "unknown_value")
	if value["kind"] in ["SELECT_CHOICE", "WITHDRAW"]:
		_validate_identifier(value["choice_id"], "projection_command.choice_id", errors)
	elif value["choice_id"] != null:
		_add_error(errors, "projection_command.choice_id", "expected_null_for_command_kind")
	return _result(errors)


static func validate_presentation_receipt(value) -> Dictionary:
	var errors: Array[String] = []
	if not _validate_dictionary(value, PRESENTATION_RECEIPT_FIELDS, "presentation_receipt", errors):
		return _result(errors)
	_validate_non_empty_string(value["presentation_id"], "presentation_receipt.presentation_id", errors)
	_validate_identifier(value["instance_id"], "presentation_receipt.instance_id", errors)
	_validate_identifier(value["sequence_id"], "presentation_receipt.sequence_id", errors)
	if not _is_semver(value["authored_version"]):
		_add_error(errors, "presentation_receipt.authored_version", "expected_major_minor_patch")
	_validate_identifier(value["beat_id"], "presentation_receipt.beat_id", errors)
	if value["beat_type"] not in AuthoredContract.BEAT_TYPES:
		_add_error(errors, "presentation_receipt.beat_type", "unknown_value")
	if value["projection_target"] not in AuthoredContract.PROJECTION_TARGETS:
		_add_error(errors, "presentation_receipt.projection_target", "unknown_value")
	if value["kind"] not in RECEIPT_KINDS:
		_add_error(errors, "presentation_receipt.kind", "unknown_value")
	_validate_non_empty_string(value["subject_id"], "presentation_receipt.subject_id", errors)
	return _result(errors)


static func validate_receipt_against_request(receipt, request) -> Dictionary:
	var errors: Array[String] = []
	var receipt_result := validate_presentation_receipt(receipt)
	for error in receipt_result["errors"]:
		_add_error(errors, "receipt", error)
	var request_result := validate_projection_request(request)
	for error in request_result["errors"]:
		_add_error(errors, "request", error)
	if receipt_result["valid"] and request_result["valid"]:
		_validate_receipt_identity(receipt, request, "receipt", errors)
	return _result(errors)


static func validate_projection_result(value) -> Dictionary:
	var errors: Array[String] = []
	if not _validate_dictionary(value, PROJECTION_RESULT_FIELDS, "projection_result", errors):
		return _result(errors)
	for field in ["accepted", "idempotent"]:
		if typeof(value[field]) != TYPE_BOOL:
			_add_error(errors, "projection_result." + field, "expected_boolean")
	if value["projection_target"] not in AuthoredContract.PROJECTION_TARGETS:
		_add_error(errors, "projection_result.projection_target", "unknown_value")
	if value["presentation_id"] != null:
		_validate_non_empty_string(value["presentation_id"], "projection_result.presentation_id", errors)
	if typeof(value["payload"]) != TYPE_DICTIONARY:
		_add_error(errors, "projection_result.payload", "expected_dictionary")
	_validate_enum_array(
		value["next_command_kinds"], COMMAND_KINDS, "projection_result.next_command_kinds", errors
	)
	if value["accepted"] == true and value["error_code"] != null:
		_add_error(errors, "projection_result.error_code", "expected_null_when_accepted")
	elif value["accepted"] == false:
		_validate_non_empty_string(value["error_code"], "projection_result.error_code", errors)
	return _result(errors)


static func validate_port_snapshot(value) -> Dictionary:
	var errors: Array[String] = []
	if not _validate_dictionary(value, PORT_SNAPSHOT_FIELDS, "port_snapshot", errors):
		return _result(errors)
	if typeof(value["snapshot_version"]) != TYPE_INT or value["snapshot_version"] != 1:
		_add_error(errors, "port_snapshot.snapshot_version", "expected_integer_1")
	var open_ids := {}
	var open_requests := {}
	if typeof(value["open_requests"]) != TYPE_ARRAY:
		_add_error(errors, "port_snapshot.open_requests", "expected_array")
	else:
		for index in value["open_requests"].size():
			var request = value["open_requests"][index]
			var validation := validate_projection_request(request)
			for error in validation["errors"]:
				_add_error(errors, "port_snapshot.open_requests[%d]" % index, error)
			if validation["valid"]:
				var presentation_id := presentation_id_for(request)
				if open_ids.has(presentation_id):
					_add_error(errors, "port_snapshot.open_requests[%d]" % index, "duplicate_projection")
				open_ids[presentation_id] = true
				open_requests[presentation_id] = request
	if typeof(value["receipts"]) == TYPE_ARRAY:
		var receipt_signatures := {}
		for index in value["receipts"].size():
			var receipt = value["receipts"][index]
			var receipt_validation := validate_presentation_receipt(receipt)
			for error in receipt_validation["errors"]:
				_add_error(errors, "port_snapshot.receipts[%d]" % index, error)
			if receipt_validation["valid"]:
				var receipt_path := "port_snapshot.receipts[%d]" % index
				if not open_ids.has(receipt["presentation_id"]):
					_add_error(errors, receipt_path, "receipt_without_open")
				else:
					_validate_receipt_identity(
						receipt, open_requests[receipt["presentation_id"]], receipt_path, errors
					)
				var signature := JSON.stringify(receipt)
				if receipt_signatures.has(signature):
					_add_error(errors, receipt_path, "duplicate_receipt")
				receipt_signatures[signature] = true
	else:
		_add_error(errors, "port_snapshot.receipts", "expected_array")
	return _result(errors)


static func presentation_id_for(request: Dictionary) -> String:
	if not validate_projection_request(request)["valid"]:
		return ""
	return _presentation_id_unchecked(request)


static func _presentation_id_unchecked(request: Dictionary) -> String:
	return "%s__%s__%s" % [request["instance_id"], request["beat_id"], request["projection_target"]]


static func not_implemented_result(projection_target := "NONE") -> Dictionary:
	var target = projection_target if projection_target in AuthoredContract.PROJECTION_TARGETS else "NONE"
	return {
		"accepted": false,
		"idempotent": false,
		"projection_target": target,
		"presentation_id": null,
		"payload": {},
		"next_command_kinds": [],
		"error_code": "NOT_IMPLEMENTED",
	}


static func _validate_presentation_state(
	value,
	request: Dictionary,
	errors: Array[String]
) -> void:
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, "projection_request.presentation_state", "expected_array")
		return
	var signatures := {}
	for index in value.size():
		var path := "projection_request.presentation_state[%d]" % index
		var receipt = value[index]
		var validation := validate_presentation_receipt(receipt)
		for error in validation["errors"]:
			_add_error(errors, path, error)
		if not validation["valid"]:
			continue
		_validate_receipt_identity(receipt, request, path, errors)
		var signature := JSON.stringify(receipt)
		if signatures.has(signature):
			_add_error(errors, path, "duplicate_receipt")
		signatures[signature] = true


static func _validate_receipt_identity(
	receipt: Dictionary,
	request: Dictionary,
	path: String,
	errors: Array[String]
) -> void:
	if receipt["presentation_id"] != _presentation_id_unchecked(request):
		_add_error(errors, path + ".presentation_id", "request_identity_mismatch")
	for field in [
		"instance_id", "sequence_id", "authored_version", "beat_id", "beat_type", "projection_target",
	]:
		if receipt[field] != request[field]:
			_add_error(errors, path + "." + field, "request_identity_mismatch")


static func _validate_enum_array(value, allowed: Array, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, path, "expected_array")
		return
	var seen := {}
	for index in value.size():
		if value[index] not in allowed:
			_add_error(errors, path + "[%d]" % index, "unknown_value")
		if seen.has(value[index]):
			_add_error(errors, path + "[%d]" % index, "duplicate")
		seen[value[index]] = true


static func _validate_dictionary(value, fields: Array, path: String, errors: Array[String]) -> bool:
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, path, "expected_dictionary")
		return false
	for field in fields:
		if not value.has(field):
			_add_error(errors, path + "." + field, "missing_required_field")
	var actual: Array = value.keys()
	actual.sort()
	for field in actual:
		if field not in fields:
			_add_error(errors, path + "." + str(field), "unknown_field")
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _validate_identifier(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_STRING or value.is_empty() or value.length() > 96 or value != value.strip_edges():
		_add_error(errors, path, "invalid_identifier")
		return
	for index in value.length():
		if value.substr(index, 1) not in "abcdefghijklmnopqrstuvwxyz0123456789_":
			_add_error(errors, path, "invalid_identifier")
			return


static func _validate_non_empty_string(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_STRING or value.is_empty() or value != value.strip_edges():
		_add_error(errors, path, "expected_non_empty_string")


static func _is_semver(value) -> bool:
	if typeof(value) != TYPE_STRING:
		return false
	var parts: PackedStringArray = value.split(".", false)
	if parts.size() != 3:
		return false
	for part in parts:
		if not part.is_valid_int() or int(part) < 0 or (part.length() > 1 and part.begins_with("0")):
			return false
	return true


static func _add_error(errors: Array[String], path: String, code: String) -> void:
	errors.append("%s: %s" % [path, code])


static func _result(errors: Array[String]) -> Dictionary:
	errors.sort()
	return {"valid": errors.is_empty(), "errors": errors.duplicate()}
