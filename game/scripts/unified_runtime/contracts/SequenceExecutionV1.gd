extends RefCounted

class_name R8CSequenceExecutionV1

const AuthoredContract := preload("res://scripts/unified_runtime/contracts/AuthoredSequenceV1.gd")
const AuthoredValidator := preload("res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd")

const FIELDS := [
	"instance_id",
	"sequence_id",
	"authored_version",
	"execution_status",
	"checkpoint_id",
	"current_beat_id",
	"consumed_choice_ids",
	"reached_checkpoint_ids",
	"opened_projection_ids",
	"projection_receipts",
	"pending_player_input",
	"scheduled_returns",
	"selected_resolution_id",
	"durable_commit_status",
]
const EXECUTION_STATUSES := [
	"ACTIVE",
	"WAITING_FOR_PLAYER",
	"WAITING_FOR_PROJECTION_ACK",
	"RESOLUTION_READY",
	"RESOLVED_RETURN_PENDING",
	"COMPLETE",
]
const RECEIPT_KINDS := ["PRESENTED", "READ", "DISMISSED", "VIEWED"]
const PLAYER_INPUT_KINDS := ["CONTINUE", "SELECT_CHOICE", "WITHDRAW"]
const DURABLE_COMMIT_STATUSES := ["NOT_REQUESTED", "PENDING", "APPLIED", "IDEMPOTENT"]
const PENDING_PLAYER_INPUT_FIELDS := ["kind", "beat_id", "allowed_choice_ids"]
const SCHEDULED_RETURN_FIELDS := ["beat_id", "resolution_id", "presentation_id"]


static func validate(value, authored_sequence) -> Dictionary:
	var errors: Array[String] = []
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, "execution", "expected_dictionary")
		return _result(errors)
	if typeof(authored_sequence) != TYPE_DICTIONARY:
		_add_error(errors, "authored_sequence", "expected_dictionary")
		return _result(errors)
	var authored_result: Dictionary = AuthoredValidator.validate(authored_sequence)
	if not authored_result["valid"]:
		_add_error(errors, "authored_sequence", "invalid_contract")
		return _result(errors)
	var execution: Dictionary = value
	_validate_exact_fields(execution, FIELDS, "execution", errors)
	if not _has_fields(execution, FIELDS):
		return _result(errors)

	var index := _build_authored_index(authored_sequence)
	_validate_identifier(execution["instance_id"], "execution.instance_id", errors)
	if execution["sequence_id"] != authored_sequence["sequence_id"]:
		_add_error(errors, "execution.sequence_id", "authored_identity_mismatch")
	if execution["authored_version"] != authored_sequence["authored_version"]:
		_add_error(errors, "execution.authored_version", "authored_version_mismatch")
	if execution["execution_status"] not in EXECUTION_STATUSES:
		_add_error(errors, "execution.execution_status", "unknown_value")
	_validate_nullable_reference(execution["checkpoint_id"], index["checkpoints"], "execution.checkpoint_id", errors)
	_validate_nullable_reference(execution["current_beat_id"], index["beats"], "execution.current_beat_id", errors)

	var consumed_choices := _validate_reference_array(
		execution["consumed_choice_ids"], index["choices"], "execution.consumed_choice_ids", errors
	)
	var reached_checkpoints := _validate_reference_array(
		execution["reached_checkpoint_ids"], index["checkpoints"], "execution.reached_checkpoint_ids", errors
	)
	if execution["checkpoint_id"] != null and execution["checkpoint_id"] not in reached_checkpoints:
		_add_error(errors, "execution.checkpoint_id", "not_reached")

	var opened_projection_ids := _validate_projection_ids(
		execution["opened_projection_ids"], execution, index, errors
	)
	_validate_projection_receipts(
		execution["projection_receipts"], opened_projection_ids, "execution.projection_receipts", errors
	)
	_validate_pending_input(execution["pending_player_input"], execution, index, consumed_choices, errors)
	_validate_scheduled_returns(execution["scheduled_returns"], index, errors)
	_validate_nullable_reference(
		execution["selected_resolution_id"],
		index["resolutions"],
		"execution.selected_resolution_id",
		errors,
	)
	if execution["durable_commit_status"] not in DURABLE_COMMIT_STATUSES:
		_add_error(errors, "execution.durable_commit_status", "unknown_value")
	_validate_state_combinations(execution, errors)
	return _result(errors)


static func _build_authored_index(authored_sequence: Dictionary) -> Dictionary:
	var index := {
		"beats": {},
		"choices": {},
		"checkpoints": {},
		"resolutions": {},
		"beat_targets": {},
	}
	for beat in authored_sequence["beats"]:
		index["beats"][beat["beat_id"]] = beat
		index["beat_targets"][beat["beat_id"]] = beat["projection_target"]
		for checkpoint_field in ["checkpoint_before", "checkpoint_after"]:
			if beat[checkpoint_field] != null:
				index["checkpoints"][beat[checkpoint_field]] = true
		if beat["type"] == "CHOICE":
			for choice in beat["content"]["choices"]:
				index["choices"][choice["choice_id"]] = true
	for resolution_id in authored_sequence["resolutions"]:
		index["resolutions"][resolution_id] = true
	return index


static func _validate_projection_ids(
	value,
	execution: Dictionary,
	index: Dictionary,
	errors: Array[String]
) -> Array:
	var result: Array = []
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, "execution.opened_projection_ids", "expected_array")
		return result
	var seen := {}
	for item_index in value.size():
		var presentation_id = value[item_index]
		var path := "execution.opened_projection_ids[%d]" % item_index
		if typeof(presentation_id) != TYPE_STRING or presentation_id.is_empty():
			_add_error(errors, path, "invalid_presentation_id")
			continue
		if seen.has(presentation_id):
			_add_error(errors, path, "duplicate")
		else:
			seen[presentation_id] = true
			result.append(presentation_id)
		var parts: PackedStringArray = presentation_id.split("__", false)
		if parts.size() != 3:
			_add_error(errors, path, "invalid_presentation_id")
			continue
		if parts[0] != execution["instance_id"]:
			_add_error(errors, path, "instance_mismatch")
		if not index["beats"].has(parts[1]):
			_add_error(errors, path, "unknown_beat")
		elif index["beat_targets"][parts[1]] != parts[2]:
			_add_error(errors, path, "projection_target_mismatch")
	return result


static func _validate_projection_receipts(
	value,
	opened_projection_ids: Array,
	path: String,
	errors: Array[String]
) -> void:
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, path, "expected_dictionary")
		return
	var presentation_ids: Array = value.keys()
	presentation_ids.sort()
	for presentation_id in presentation_ids:
		if presentation_id not in opened_projection_ids:
			_add_error(errors, path + "." + str(presentation_id), "receipt_without_open")
		if value[presentation_id] not in RECEIPT_KINDS:
			_add_error(errors, path + "." + str(presentation_id), "unknown_receipt_kind")


static func _validate_pending_input(
	value,
	execution: Dictionary,
	index: Dictionary,
	consumed_choices: Array,
	errors: Array[String]
) -> void:
	if value == null:
		if execution["execution_status"] == "WAITING_FOR_PLAYER":
			_add_error(errors, "execution.pending_player_input", "required_while_waiting_for_player")
		return
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, "execution.pending_player_input", "expected_dictionary_or_null")
		return
	_validate_exact_fields(value, PENDING_PLAYER_INPUT_FIELDS, "execution.pending_player_input", errors)
	if not _has_fields(value, PENDING_PLAYER_INPUT_FIELDS):
		return
	if execution["execution_status"] != "WAITING_FOR_PLAYER":
		_add_error(errors, "execution.pending_player_input", "unexpected_for_execution_status")
	if value["kind"] not in PLAYER_INPUT_KINDS:
		_add_error(errors, "execution.pending_player_input.kind", "unknown_value")
	_validate_reference(value["beat_id"], index["beats"], "execution.pending_player_input.beat_id", errors)
	if value["beat_id"] != execution["current_beat_id"]:
		_add_error(errors, "execution.pending_player_input.beat_id", "current_beat_mismatch")
	var allowed := _validate_reference_array(
		value["allowed_choice_ids"],
		index["choices"],
		"execution.pending_player_input.allowed_choice_ids",
		errors,
	)
	for choice_id in allowed:
		if choice_id in consumed_choices:
			_add_error(errors, "execution.pending_player_input.allowed_choice_ids", "already_consumed_%s" % choice_id)


static func _validate_scheduled_returns(
	value,
	index: Dictionary,
	errors: Array[String]
) -> void:
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, "execution.scheduled_returns", "expected_array")
		return
	var presentation_ids := {}
	for item_index in value.size():
		var path := "execution.scheduled_returns[%d]" % item_index
		var item = value[item_index]
		if typeof(item) != TYPE_DICTIONARY:
			_add_error(errors, path, "expected_dictionary")
			continue
		_validate_exact_fields(item, SCHEDULED_RETURN_FIELDS, path, errors)
		if not _has_fields(item, SCHEDULED_RETURN_FIELDS):
			continue
		_validate_reference(item["beat_id"], index["beats"], path + ".beat_id", errors)
		_validate_reference(item["resolution_id"], index["resolutions"], path + ".resolution_id", errors)
		if index["beats"].has(item["beat_id"]):
			var authored_beat: Dictionary = index["beats"][item["beat_id"]]
			if authored_beat["type"] != "RETURN":
				_add_error(errors, path + ".beat_id", "expected_return_beat")
		if typeof(item["presentation_id"]) != TYPE_STRING or item["presentation_id"].is_empty():
			_add_error(errors, path + ".presentation_id", "invalid_presentation_id")
		elif presentation_ids.has(item["presentation_id"]):
			_add_error(errors, path + ".presentation_id", "duplicate")
		presentation_ids[item["presentation_id"]] = true


static func _validate_state_combinations(execution: Dictionary, errors: Array[String]) -> void:
	if execution["execution_status"] == "COMPLETE":
		if execution["current_beat_id"] != null:
			_add_error(errors, "execution.current_beat_id", "must_be_null_when_complete")
		if execution["pending_player_input"] != null:
			_add_error(errors, "execution.pending_player_input", "must_be_null_when_complete")
		if typeof(execution["scheduled_returns"]) == TYPE_ARRAY and not execution["scheduled_returns"].is_empty():
			_add_error(errors, "execution.scheduled_returns", "must_be_empty_when_complete")
		if execution["durable_commit_status"] not in ["APPLIED", "IDEMPOTENT"]:
			_add_error(errors, "execution.durable_commit_status", "complete_requires_durable_commit")
	elif execution["current_beat_id"] == null:
		_add_error(errors, "execution.current_beat_id", "required_unless_complete")
	if execution["execution_status"] == "RESOLUTION_READY" and execution["selected_resolution_id"] == null:
		_add_error(errors, "execution.selected_resolution_id", "required_when_resolution_ready")
	if execution["execution_status"] == "RESOLVED_RETURN_PENDING":
		if execution["selected_resolution_id"] == null:
			_add_error(errors, "execution.selected_resolution_id", "required_when_return_pending")
		if typeof(execution["scheduled_returns"]) == TYPE_ARRAY and execution["scheduled_returns"].is_empty():
			_add_error(errors, "execution.scheduled_returns", "required_when_return_pending")
		if execution["durable_commit_status"] not in ["APPLIED", "IDEMPOTENT"]:
			_add_error(errors, "execution.durable_commit_status", "return_pending_requires_durable_commit")


static func _validate_reference_array(value, allowed: Dictionary, path: String, errors: Array[String]) -> Array:
	var result: Array = []
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, path, "expected_array")
		return result
	var seen := {}
	for index in value.size():
		var item = value[index]
		_validate_reference(item, allowed, path + "[%d]" % index, errors)
		if seen.has(item):
			_add_error(errors, path + "[%d]" % index, "duplicate")
		else:
			seen[item] = true
			result.append(item)
	return result


static func _validate_nullable_reference(value, allowed: Dictionary, path: String, errors: Array[String]) -> void:
	if value != null:
		_validate_reference(value, allowed, path, errors)


static func _validate_reference(value, allowed: Dictionary, path: String, errors: Array[String]) -> void:
	_validate_identifier(value, path, errors)
	if typeof(value) == TYPE_STRING and not allowed.has(value):
		_add_error(errors, path, "unknown_reference")


static func _validate_identifier(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_STRING or value.is_empty() or value.length() > 96 or value != value.strip_edges():
		_add_error(errors, path, "invalid_identifier")
		return
	for index in value.length():
		if value.substr(index, 1) not in "abcdefghijklmnopqrstuvwxyz0123456789_":
			_add_error(errors, path, "invalid_identifier")
			return


static func _validate_exact_fields(value: Dictionary, fields: Array, path: String, errors: Array[String]) -> void:
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


static func _add_error(errors: Array[String], path: String, code: String) -> void:
	errors.append("%s: %s" % [path, code])


static func _result(errors: Array[String]) -> Dictionary:
	errors.sort()
	return {"valid": errors.is_empty(), "errors": errors.duplicate()}
