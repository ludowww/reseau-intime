extends Node

const AuthoredContract := preload("res://scripts/unified_runtime/contracts/AuthoredSequenceV1.gd")
const AuthoredValidator := preload("res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd")
const SequenceExecution := preload("res://scripts/unified_runtime/contracts/SequenceExecutionV1.gd")
const ProjectionContracts := preload("res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd")
const ProjectionPort := preload("res://scripts/unified_runtime/contracts/PlayerProjectionPort.gd")

const VALID_FIXTURE_PATH := "res://tests/fixtures/unified_runtime/authored_sequence_v1_minimal_valid.json"
const INVALID_FIXTURE_PATH := "res://tests/fixtures/unified_runtime/authored_sequence_v1_invalid_cases.json"

var failures: Array[String] = []
var controls := 0


class FakeProjectionPort extends ProjectionPort:
	var open_requests: Array = []
	var receipts: Array = []

	func supports_projection(projection_target: String) -> Dictionary:
		return {
			"supported": projection_target in AuthoredContract.PROJECTION_TARGETS,
			"error_code": null if projection_target in AuthoredContract.PROJECTION_TARGETS else "UNSUPPORTED_PROJECTION",
		}

	func open(request: Dictionary) -> Dictionary:
		var validation: Dictionary = ProjectionContracts.validate_projection_request(request)
		if not validation["valid"]:
			return _error_result(request.get("projection_target", "NONE"), "INVALID_REQUEST")
		var presentation_id := ProjectionContracts.presentation_id_for(request)
		for existing in open_requests:
			if ProjectionContracts.presentation_id_for(existing) == presentation_id:
				return _accepted_result(request["projection_target"], presentation_id, true)
		open_requests.append(request.duplicate(true))
		return _accepted_result(request["projection_target"], presentation_id, false)

	func submit(command: Dictionary) -> Dictionary:
		var validation: Dictionary = ProjectionContracts.validate_projection_command(command)
		if not validation["valid"]:
			return _error_result("NONE", "INVALID_COMMAND")
		for request in open_requests:
			if request["instance_id"] == command["instance_id"] and request["beat_id"] == command["beat_id"]:
				return _accepted_result(
					request["projection_target"], ProjectionContracts.presentation_id_for(request), false
				)
		return _error_result("NONE", "PROJECTION_NOT_OPEN")

	func acknowledge(receipt: Dictionary) -> Dictionary:
		var validation: Dictionary = ProjectionContracts.validate_presentation_receipt(receipt)
		if not validation["valid"]:
			return _error_result("NONE", "INVALID_RECEIPT")
		var request := _request_for_presentation(receipt["presentation_id"])
		if request.is_empty():
			return _error_result("NONE", "RECEIPT_WITHOUT_OPEN")
		for existing in receipts:
			if existing == receipt:
				return _accepted_result(request["projection_target"], receipt["presentation_id"], true)
		receipts.append(receipt.duplicate(true))
		return _accepted_result(request["projection_target"], receipt["presentation_id"], false)

	func snapshot() -> Dictionary:
		var data := {
			"snapshot_version": 1,
			"open_requests": open_requests.duplicate(true),
			"receipts": receipts.duplicate(true),
		}
		return {"accepted": true, "snapshot": data, "error_code": null}

	func restore(snapshot_data: Dictionary) -> Dictionary:
		var validation: Dictionary = ProjectionContracts.validate_port_snapshot(snapshot_data)
		if not validation["valid"]:
			return {"accepted": false, "error_code": "INVALID_SNAPSHOT"}
		open_requests = snapshot_data["open_requests"].duplicate(true)
		receipts = snapshot_data["receipts"].duplicate(true)
		return {"accepted": true, "error_code": null}

	func close(presentation_id: String) -> Dictionary:
		for index in open_requests.size():
			var request: Dictionary = open_requests[index]
			if ProjectionContracts.presentation_id_for(request) == presentation_id:
				open_requests.remove_at(index)
				return _accepted_result(request["projection_target"], presentation_id, false)
		return _error_result("NONE", "PROJECTION_NOT_OPEN")

	func _request_for_presentation(presentation_id: String) -> Dictionary:
		for request in open_requests:
			if ProjectionContracts.presentation_id_for(request) == presentation_id:
				return request
		return {}

	func _accepted_result(projection_target: String, presentation_id: String, idempotent: bool) -> Dictionary:
		return {
			"accepted": true,
			"idempotent": idempotent,
			"projection_target": projection_target,
			"presentation_id": presentation_id,
			"payload": {},
			"next_command_kinds": ["CONTINUE"],
			"error_code": null,
		}

	func _error_result(projection_target: String, error_code: String) -> Dictionary:
		return {
			"accepted": false,
			"idempotent": false,
			"projection_target": projection_target,
			"presentation_id": null,
			"payload": {},
			"next_command_kinds": [],
			"error_code": error_code,
		}


func _ready() -> void:
	var valid_sequence := _load_dictionary(VALID_FIXTURE_PATH)
	var invalid_cases := _load_dictionary(INVALID_FIXTURE_PATH)
	_expect(not valid_sequence.is_empty(), "01 valid fixture loaded")
	_expect(not invalid_cases.is_empty(), "02 invalid fixture loaded")
	if valid_sequence.is_empty() or invalid_cases.is_empty():
		_finish()
		return

	var valid_result: Dictionary = AuthoredValidator.validate(valid_sequence)
	_expect(valid_result["valid"], "03 valid authored fixture: %s" % [valid_result["errors"]])
	_expect(valid_result["errors"].is_empty(), "04 valid fixture has no errors")
	_test_invalid_cases(valid_sequence, invalid_cases)
	var execution := _valid_execution(valid_sequence)
	_test_execution_contract(execution, valid_sequence)
	_test_projection_contracts_and_port(valid_sequence)
	_finish()


func _test_invalid_cases(valid_sequence: Dictionary, invalid_cases: Dictionary) -> void:
	for case in invalid_cases["cases"]:
		if case["target"] != "authored_sequence":
			continue
		var candidate: Dictionary = valid_sequence.duplicate(true)
		_apply_authored_mutation(candidate, case["mutation"])
		var first: Dictionary = AuthoredValidator.validate(candidate)
		var second: Dictionary = AuthoredValidator.validate(candidate)
		_expect(not first["valid"], "invalid case rejected: %s" % case["case_id"])
		_expect(
			_contains_error(first["errors"], case["expected_error"]),
			"expected error for %s: %s" % [case["case_id"], first["errors"]],
		)
		_expect(first["errors"] == second["errors"], "deterministic errors: %s" % case["case_id"])
		_expect(_is_sorted(first["errors"]), "sorted errors: %s" % case["case_id"])


func _apply_authored_mutation(candidate: Dictionary, mutation: String) -> void:
	match mutation:
		"add_root_unknown_key":
			candidate["unexpected"] = true
		"remove_entry_beat_id":
			candidate.erase("entry_beat_id")
		"set_forbidden_beat_type":
			candidate["beats"][0]["type"] = "SCRIPT"
		"duplicate_beat_id":
			candidate["beats"][1]["beat_id"] = candidate["beats"][0]["beat_id"]
		"set_unknown_direct_target":
			candidate["beats"][0]["next"]["beat_id"] = "missing_beat"
		"set_unknown_choice_resolution":
			candidate["beats"][6]["content"]["choices"][0]["resolution_id"] = "missing_resolution"
		"set_unknown_media_reference":
			candidate["beats"][4]["content"]["media_id"] = "missing_media"
		"set_unknown_terminal_checkpoint":
			candidate["resolutions"]["resolution_complete"]["terminal_checkpoint_id"] = "missing_checkpoint"
		"create_return_cycle":
			candidate["beats"][7]["next"] = {"mode": "DIRECT", "beat_id": "beat_message"}
		"set_day_based_sequence_id":
			candidate["sequence_id"] = "chapter_12_synthetic"
		"set_invalid_authored_version":
			candidate["authored_version"] = "1.0"
		"set_invalid_canonical_status":
			candidate["canonical_status"] = "DRAFT"
		"add_legacy_current_day":
			candidate["current_day"] = 12


func _test_execution_contract(execution: Dictionary, valid_sequence: Dictionary) -> void:
	var valid_result: Dictionary = SequenceExecution.validate(execution, valid_sequence)
	_expect(valid_result["valid"], "execution fixture valid: %s" % [valid_result["errors"]])

	var receipt_without_open: Dictionary = execution.duplicate(true)
	receipt_without_open["opened_projection_ids"] = []
	_expect(
		_contains_error(
			SequenceExecution.validate(receipt_without_open, valid_sequence)["errors"],
			"receipt_without_open",
		),
		"execution rejects receipt before open",
	)
	var wrong_version: Dictionary = execution.duplicate(true)
	wrong_version["authored_version"] = "2.0.0"
	_expect(
		_contains_error(SequenceExecution.validate(wrong_version, valid_sequence)["errors"], "authored_version_mismatch"),
		"execution rejects authored version mismatch",
	)
	var unknown_beat: Dictionary = execution.duplicate(true)
	unknown_beat["current_beat_id"] = "missing_beat"
	_expect(
		_contains_error(SequenceExecution.validate(unknown_beat, valid_sequence)["errors"], "unknown_reference"),
		"execution rejects unknown beat",
	)
	var duplicate_choice: Dictionary = execution.duplicate(true)
	duplicate_choice["consumed_choice_ids"] = ["choice_start", "choice_start"]
	_expect(
		_contains_error(SequenceExecution.validate(duplicate_choice, valid_sequence)["errors"], "duplicate"),
		"execution rejects duplicate choice",
	)
	var impossible_complete: Dictionary = execution.duplicate(true)
	impossible_complete["execution_status"] = "COMPLETE"
	_expect(
		_contains_error(SequenceExecution.validate(impossible_complete, valid_sequence)["errors"], "must_be_null_when_complete"),
		"execution rejects impossible complete state",
	)


func _test_projection_contracts_and_port(valid_sequence: Dictionary) -> void:
	var request := {
		"instance_id": "synthetic_instance",
		"sequence_id": valid_sequence["sequence_id"],
		"authored_version": valid_sequence["authored_version"],
		"beat_id": "beat_message",
		"beat_type": "MESSAGE",
		"projection_target": "MESSAGES",
		"presentation_state": {},
	}
	var command := {
		"command_id": "synthetic_command",
		"instance_id": "synthetic_instance",
		"beat_id": "beat_message",
		"kind": "CONTINUE",
		"choice_id": null,
	}
	var presentation_id := ProjectionContracts.presentation_id_for(request)
	var receipt := {
		"presentation_id": presentation_id,
		"instance_id": "synthetic_instance",
		"beat_id": "beat_message",
		"kind": "PRESENTED",
		"subject_id": "synthetic_message",
	}
	_expect(ProjectionContracts.validate_projection_request(request)["valid"], "projection request valid")
	_expect(ProjectionContracts.validate_projection_command(command)["valid"], "projection command valid")
	_expect(ProjectionContracts.validate_presentation_receipt(receipt)["valid"], "presentation receipt valid")

	var abstract_port = ProjectionPort.new()
	var abstract_result: Dictionary = abstract_port.open(request)
	_expect(not abstract_result["accepted"] and abstract_result["error_code"] == "NOT_IMPLEMENTED", "abstract port is explicit")

	var fake_port = FakeProjectionPort.new()
	_expect(fake_port.supports_projection("MESSAGES")["supported"], "fake port supports messages")
	var opened: Dictionary = fake_port.open(request)
	_expect(opened["accepted"] and not opened["idempotent"], "fake port opens projection")
	_expect(fake_port.open(request)["idempotent"], "fake port open is idempotent")
	_expect(fake_port.submit(command)["accepted"], "fake port accepts command")
	_expect(fake_port.acknowledge(receipt)["accepted"], "fake port acknowledges presentation")
	var saved: Dictionary = fake_port.snapshot()
	_expect(saved["accepted"] and ProjectionContracts.validate_port_snapshot(saved["snapshot"])["valid"], "fake port snapshot valid")
	_expect(fake_port.close(presentation_id)["accepted"], "fake port closes projection")
	_expect(fake_port.restore(saved["snapshot"])["accepted"], "fake port restores snapshot")
	_expect(fake_port.snapshot()["snapshot"] == saved["snapshot"], "fake port restoration exact")


func _valid_execution(valid_sequence: Dictionary) -> Dictionary:
	var presentation_id := "synthetic_instance__beat_message__MESSAGES"
	return {
		"instance_id": "synthetic_instance",
		"sequence_id": valid_sequence["sequence_id"],
		"authored_version": valid_sequence["authored_version"],
		"execution_status": "WAITING_FOR_PLAYER",
		"checkpoint_id": "checkpoint_root_choice",
		"current_beat_id": "beat_root_choice",
		"consumed_choice_ids": [],
		"reached_checkpoint_ids": ["checkpoint_message_presented", "checkpoint_root_choice"],
		"opened_projection_ids": [presentation_id],
		"projection_receipts": {presentation_id: "PRESENTED"},
		"pending_player_input": {
			"kind": "SELECT_CHOICE",
			"beat_id": "beat_root_choice",
			"allowed_choice_ids": ["choice_start"],
		},
		"scheduled_returns": [],
		"selected_resolution_id": null,
		"durable_commit_status": "NOT_REQUESTED",
	}


func _load_dictionary(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed if typeof(parsed) == TYPE_DICTIONARY else {}


func _contains_error(errors: Array, expected: String) -> bool:
	for error in errors:
		if expected in str(error):
			return true
	return false


func _is_sorted(values: Array) -> bool:
	var sorted_values: Array = values.duplicate()
	sorted_values.sort()
	return sorted_values == values


func _expect(condition: bool, message: String) -> void:
	controls += 1
	if not condition:
		failures.append(message)


func _finish() -> void:
	if failures.is_empty():
		print("R8C_N12_UNIFIED_CONTENT_CONTRACT: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)
