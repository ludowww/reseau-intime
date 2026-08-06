extends RefCounted

class_name R8CSequenceResolutionEnvelopeV1

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const SequenceExecution := preload(
	"res://scripts/unified_runtime/contracts/SequenceExecutionV1.gd"
)

const FIELDS := [
	"instance_id",
	"sequence_id",
	"authored_version",
	"choice_id",
	"resolution_id",
	"a10_choice_id",
	"a10_resolution_id",
	"terminal_checkpoint_id",
	"event_keys",
]


static func create(authored_sequence, execution) -> Dictionary:
	if typeof(execution) != TYPE_DICTIONARY:
		return _failure("INVALID_EXECUTION")
	var resolution_id = execution.get("selected_resolution_id")
	if (
		typeof(authored_sequence) != TYPE_DICTIONARY
		or typeof(resolution_id) != TYPE_STRING
		or not authored_sequence.get("resolutions", {}).has(resolution_id)
	):
		return _failure("RESOLUTION_NOT_SELECTED")
	var resolution: Dictionary = authored_sequence["resolutions"][resolution_id]
	var event_keys: Array = []
	for event_ref in resolution["event_refs"]:
		event_keys.append(event_ref["event_key"])
	var envelope := {
		"instance_id": execution["instance_id"],
		"sequence_id": authored_sequence["sequence_id"],
		"authored_version": authored_sequence["authored_version"],
		"choice_id": resolution["choice_id"],
		"resolution_id": resolution["resolution_id"],
		"a10_choice_id": resolution["a10_choice_id"],
		"a10_resolution_id": resolution["a10_resolution_id"],
		"terminal_checkpoint_id": resolution["terminal_checkpoint_id"],
		"event_keys": event_keys,
	}
	var validation := validate(envelope, authored_sequence, execution)
	if not validation["valid"]:
		return _failure("INVALID_ENVELOPE", validation["errors"])
	return {"ok": true, "error_code": null, "errors": [], "envelope": envelope}


static func validate(value, authored_sequence, execution) -> Dictionary:
	var errors: Array[String] = []
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, "envelope", "expected_dictionary")
		return _result(errors)
	var envelope: Dictionary = value
	_validate_exact_fields(envelope, FIELDS, "envelope", errors)
	if not _has_fields(envelope, FIELDS):
		return _result(errors)
	for field in [
		"instance_id",
		"sequence_id",
		"choice_id",
		"resolution_id",
		"a10_choice_id",
		"a10_resolution_id",
		"terminal_checkpoint_id",
	]:
		_validate_identifier(envelope[field], "envelope." + field, errors)
	if not _is_semver(envelope["authored_version"]):
		_add_error(errors, "envelope.authored_version", "expected_major_minor_patch")
	_validate_identifier_array(envelope["event_keys"], "envelope.event_keys", errors)
	if not errors.is_empty():
		return _result(errors)

	var authored_validation := AuthoredValidator.validate(authored_sequence)
	if not authored_validation["valid"]:
		_add_error(errors, "authored_sequence", "invalid_contract")
		return _result(errors)
	var execution_validation := SequenceExecution.validate(execution, authored_sequence)
	if not execution_validation["valid"]:
		_add_error(errors, "execution", "invalid_contract")
		return _result(errors)

	if envelope["instance_id"] != execution["instance_id"]:
		_add_error(errors, "envelope.instance_id", "execution_identity_mismatch")
	if envelope["sequence_id"] != authored_sequence["sequence_id"]:
		_add_error(errors, "envelope.sequence_id", "authored_identity_mismatch")
	if envelope["authored_version"] != authored_sequence["authored_version"]:
		_add_error(errors, "envelope.authored_version", "authored_version_mismatch")
	if execution["selected_resolution_id"] != envelope["resolution_id"]:
		_add_error(errors, "envelope.resolution_id", "execution_resolution_mismatch")
	if execution["execution_status"] != "RESOLUTION_READY":
		_add_error(errors, "execution.execution_status", "resolution_not_ready")
	if not authored_sequence["resolutions"].has(envelope["resolution_id"]):
		_add_error(errors, "envelope.resolution_id", "unknown_authored_resolution")
		return _result(errors)

	var resolution: Dictionary = authored_sequence["resolutions"][envelope["resolution_id"]]
	for field in [
		"choice_id",
		"resolution_id",
		"a10_choice_id",
		"a10_resolution_id",
		"terminal_checkpoint_id",
	]:
		if envelope[field] != resolution[field]:
			_add_error(errors, "envelope." + field, "authored_resolution_mismatch")
	if envelope["choice_id"] not in execution["consumed_choice_ids"]:
		_add_error(errors, "envelope.choice_id", "choice_not_consumed")
	if execution["checkpoint_id"] != envelope["terminal_checkpoint_id"]:
		_add_error(errors, "envelope.terminal_checkpoint_id", "checkpoint_mismatch")

	var expected_event_keys: Array = []
	for event_ref in resolution["event_refs"]:
		expected_event_keys.append(event_ref["event_key"])
	if envelope["event_keys"] != expected_event_keys:
		_add_error(errors, "envelope.event_keys", "authored_event_keys_mismatch")

	var definition: Dictionary = authored_sequence["orchestration"]["a6_entry"]["definition"]
	if not definition["resolutions"].has(envelope["a10_resolution_id"]):
		_add_error(errors, "envelope.a10_resolution_id", "unknown_a6_resolution")
	else:
		var a10_resolution: Dictionary = definition["resolutions"][envelope["a10_resolution_id"]]
		if a10_resolution["portee_micro_signal"] != "DURABLE":
			_add_error(errors, "envelope.a10_resolution_id", "a10_resolution_not_durable")
	var mapped_choice := {}
	for choice in definition["choix"]:
		if choice["choix_id"] == envelope["a10_choice_id"]:
			mapped_choice = choice
			break
	if mapped_choice.is_empty():
		_add_error(errors, "envelope.a10_choice_id", "unknown_a6_choice")
	elif envelope["a10_resolution_id"] not in mapped_choice["resolution_ids"]:
		_add_error(errors, "envelope.a10_resolution_id", "a10_resolution_choice_mismatch")
	return _result(errors)


static func _validate_exact_fields(
	value: Dictionary, fields: Array, path: String, errors: Array[String]
) -> void:
	for field in fields:
		if not value.has(field):
			_add_error(errors, path + "." + field, "missing_required_field")
	var actual: Array = value.keys()
	actual.sort()
	for field in actual:
		if field not in fields:
			_add_error(errors, path + "." + str(field), "unknown_field")


static func _has_fields(value: Dictionary, fields: Array) -> bool:
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _validate_identifier_array(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, path, "expected_array")
		return
	var seen := {}
	for index in value.size():
		_validate_identifier(value[index], path + "[%d]" % index, errors)
		if seen.has(value[index]):
			_add_error(errors, path + "[%d]" % index, "duplicate")
		seen[value[index]] = true


static func _validate_identifier(value, path: String, errors: Array[String]) -> void:
	if (
		typeof(value) != TYPE_STRING
		or value.is_empty()
		or value.length() > 96
		or value != value.strip_edges()
	):
		_add_error(errors, path, "invalid_identifier")
		return
	for index in value.length():
		if value.substr(index, 1) not in "abcdefghijklmnopqrstuvwxyz0123456789_":
			_add_error(errors, path, "invalid_identifier")
			return


static func _is_semver(value) -> bool:
	if typeof(value) != TYPE_STRING:
		return false
	var parts: PackedStringArray = value.split(".", false)
	if parts.size() != 3:
		return false
	for part in parts:
		if (
			not part.is_valid_int()
			or int(part) < 0
			or (part.length() > 1 and part.begins_with("0"))
		):
			return false
	return true


static func _add_error(errors: Array[String], path: String, code: String) -> void:
	errors.append("%s: %s" % [path, code])


static func _result(errors: Array[String]) -> Dictionary:
	errors.sort()
	return {"valid": errors.is_empty(), "errors": errors.duplicate()}


static func _failure(error_code: String, errors: Array = []) -> Dictionary:
	return {
		"ok": false,
		"error_code": error_code,
		"errors": errors.duplicate(),
		"envelope": {},
	}
