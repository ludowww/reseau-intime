extends RefCounted

class_name R8CUnifiedRuntimeSnapshotV1

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const SequenceExecution := preload(
	"res://scripts/unified_runtime/contracts/SequenceExecutionV1.gd"
)
const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)

const SCHEMA_ID := "reseau_intime.unified_runtime"
const SCHEMA_VERSION := 1
const FIELDS := [
	"schema_id",
	"schema_version",
	"sequence_id",
	"authored_version",
	"domain",
	"execution",
	"projection_port",
]
const DOMAIN_FIELDS := ["version", "narrative_state", "scene_registry"]


static func create(facade, projection_port, authored_sequence, execution) -> Dictionary:
	if not _facade_usable(facade) or not _port_usable(projection_port):
		return _failure("INVALID_RUNTIME_DEPENDENCY")
	var port_result = projection_port.snapshot()
	if (
		typeof(port_result) != TYPE_DICTIONARY
		or not port_result.get("accepted", false)
		or typeof(port_result.get("snapshot")) != TYPE_DICTIONARY
	):
		return _failure("PORT_SNAPSHOT_REFUSED")
	var snapshot := {
		"schema_id": SCHEMA_ID,
		"schema_version": SCHEMA_VERSION,
		"sequence_id": authored_sequence.get("sequence_id") if typeof(authored_sequence) == TYPE_DICTIONARY else null,
		"authored_version": authored_sequence.get("authored_version") if typeof(authored_sequence) == TYPE_DICTIONARY else null,
		"domain": facade.save_state(),
		"execution": execution.duplicate(true) if typeof(execution) == TYPE_DICTIONARY else execution,
		"projection_port": port_result["snapshot"].duplicate(true),
	}
	var validation := validate(snapshot, authored_sequence)
	if not validation["valid"]:
		return _failure("INVALID_RUNTIME_SNAPSHOT", validation["errors"])
	return {"ok": true, "error_code": null, "errors": [], "snapshot": snapshot}


static func validate(value, authored_sequence) -> Dictionary:
	var errors: Array[String] = []
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, "snapshot", "expected_dictionary")
		return _result(errors)
	var snapshot: Dictionary = value
	_validate_exact_fields(snapshot, FIELDS, "snapshot", errors)
	if not _has_fields(snapshot, FIELDS):
		return _result(errors)
	if snapshot["schema_id"] != SCHEMA_ID:
		_add_error(errors, "snapshot.schema_id", "unknown_namespace")
	if typeof(snapshot["schema_version"]) != TYPE_INT or snapshot["schema_version"] != SCHEMA_VERSION:
		_add_error(errors, "snapshot.schema_version", "unsupported_version")
	if typeof(snapshot["sequence_id"]) != TYPE_STRING:
		_add_error(errors, "snapshot.sequence_id", "expected_identifier")
	if typeof(snapshot["authored_version"]) != TYPE_STRING:
		_add_error(errors, "snapshot.authored_version", "expected_semver")

	var authored_validation := AuthoredValidator.validate(authored_sequence)
	if not authored_validation["valid"]:
		_add_error(errors, "authored_sequence", "invalid_contract")
		return _result(errors)
	if snapshot["sequence_id"] != authored_sequence["sequence_id"]:
		_add_error(errors, "snapshot.sequence_id", "authored_identity_mismatch")
	if snapshot["authored_version"] != authored_sequence["authored_version"]:
		_add_error(errors, "snapshot.authored_version", "authored_version_mismatch")

	var execution_validation := SequenceExecution.validate(snapshot["execution"], authored_sequence)
	for error in execution_validation["errors"]:
		_add_error(errors, "snapshot.execution", error)
	var port_validation := ProjectionContracts.validate_port_snapshot(snapshot["projection_port"])
	for error in port_validation["errors"]:
		_add_error(errors, "snapshot.projection_port", error)
	_validate_domain(snapshot["domain"], snapshot["execution"], authored_sequence, errors)
	if execution_validation["valid"] and port_validation["valid"]:
		_validate_port_identity(snapshot["projection_port"], snapshot["execution"], authored_sequence, errors)
	return _result(errors)


static func restore_into(facade, projection_port, authored_sequence, snapshot) -> Dictionary:
	if not _facade_usable(facade) or not _port_usable(projection_port):
		return _failure("INVALID_RUNTIME_DEPENDENCY")
	var validation := validate(snapshot, authored_sequence)
	if not validation["valid"]:
		return _failure("INVALID_RUNTIME_SNAPSHOT", validation["errors"])
	var initial_state := _capture_initial_state(facade, projection_port)
	if not initial_state["ok"]:
		return _failure(initial_state["error_code"], initial_state["errors"])
	var domain_restore = facade.restore_state(snapshot["domain"].duplicate(true))
	if typeof(domain_restore) != TYPE_DICTIONARY or not domain_restore.get("ok", false):
		return _restore_failure_with_rollback(
			"DOMAIN_RESTORE_REFUSED", facade, projection_port, initial_state
		)
	var port_restore = projection_port.restore(snapshot["projection_port"].duplicate(true))
	if typeof(port_restore) != TYPE_DICTIONARY or not port_restore.get("accepted", false):
		return _restore_failure_with_rollback(
			"PORT_RESTORE_REFUSED", facade, projection_port, initial_state
		)
	return {
		"ok": true,
		"error_code": null,
		"errors": [],
		"execution": snapshot["execution"].duplicate(true),
	}


static func _capture_initial_state(facade, projection_port) -> Dictionary:
	var initial_domain = facade.save_state()
	if not _domain_snapshot_shape_valid(initial_domain):
		return _failure("DOMAIN_SNAPSHOT_REFUSED")
	var initial_port_result = projection_port.snapshot()
	if (
		typeof(initial_port_result) != TYPE_DICTIONARY
		or not initial_port_result.get("accepted", false)
		or typeof(initial_port_result.get("snapshot")) != TYPE_DICTIONARY
		or not ProjectionContracts.validate_port_snapshot(initial_port_result["snapshot"])["valid"]
	):
		return _failure("PORT_SNAPSHOT_REFUSED")
	return {
		"ok": true,
		"error_code": null,
		"errors": [],
		"domain": initial_domain.duplicate(true),
		"projection_port": initial_port_result["snapshot"].duplicate(true),
	}


static func _restore_failure_with_rollback(
	failure_code: String, facade, projection_port, initial_state: Dictionary
) -> Dictionary:
	var rollback := _rollback_initial_state(facade, projection_port, initial_state)
	if rollback["ok"]:
		return _failure(failure_code)
	var errors: Array = [failure_code]
	errors.append_array(rollback["errors"])
	return _failure("RESTORE_ROLLBACK_FAILED", errors)


static func _rollback_initial_state(facade, projection_port, initial_state: Dictionary) -> Dictionary:
	var errors: Array[String] = []
	var domain_rollback = facade.restore_state(initial_state["domain"].duplicate(true))
	if typeof(domain_rollback) != TYPE_DICTIONARY or not domain_rollback.get("ok", false):
		errors.append("domain_rollback_refused")
	var port_rollback = projection_port.restore(initial_state["projection_port"].duplicate(true))
	if typeof(port_rollback) != TYPE_DICTIONARY or not port_rollback.get("accepted", false):
		errors.append("port_rollback_refused")

	var current_domain = facade.save_state()
	if not _domain_snapshot_shape_valid(current_domain):
		errors.append("domain_rollback_snapshot_refused")
	elif current_domain != initial_state["domain"]:
		errors.append("domain_rollback_mismatch")
	var current_port_result = projection_port.snapshot()
	if (
		typeof(current_port_result) != TYPE_DICTIONARY
		or not current_port_result.get("accepted", false)
		or typeof(current_port_result.get("snapshot")) != TYPE_DICTIONARY
	):
		errors.append("port_rollback_snapshot_refused")
	else:
		var current_port: Dictionary = current_port_result["snapshot"]
		if not ProjectionContracts.validate_port_snapshot(current_port)["valid"]:
			errors.append("port_rollback_snapshot_invalid")
		elif current_port != initial_state["projection_port"]:
			errors.append("port_rollback_mismatch")
	return {"ok": errors.is_empty(), "errors": errors}


static func _domain_snapshot_shape_valid(value) -> bool:
	if typeof(value) != TYPE_DICTIONARY:
		return false
	var domain: Dictionary = value
	var keys: Array = domain.keys()
	keys.sort()
	var expected: Array = DOMAIN_FIELDS.duplicate()
	expected.sort()
	return (
		keys == expected
		and typeof(domain["version"]) == TYPE_INT
		and domain["version"] == 1
		and typeof(domain["narrative_state"]) == TYPE_DICTIONARY
		and typeof(domain["scene_registry"]) == TYPE_ARRAY
	)


static func _validate_domain(
	value, execution, authored_sequence: Dictionary, errors: Array[String]
) -> void:
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, "snapshot.domain", "expected_dictionary")
		return
	var domain: Dictionary = value
	_validate_exact_fields(domain, DOMAIN_FIELDS, "snapshot.domain", errors)
	if not _has_fields(domain, DOMAIN_FIELDS):
		return
	if typeof(domain["version"]) != TYPE_INT or domain["version"] != 1:
		_add_error(errors, "snapshot.domain.version", "unsupported_version")
	if typeof(domain["narrative_state"]) != TYPE_DICTIONARY:
		_add_error(errors, "snapshot.domain.narrative_state", "expected_dictionary")
	if typeof(domain["scene_registry"]) != TYPE_ARRAY:
		_add_error(errors, "snapshot.domain.scene_registry", "expected_array")
		return
	if typeof(execution) != TYPE_DICTIONARY:
		return
	var matching_instances: Array = []
	for instance in domain["scene_registry"]:
		if typeof(instance) == TYPE_DICTIONARY and instance.get("instance_id") == execution.get("instance_id"):
			matching_instances.append(instance)
	if matching_instances.size() != 1:
		_add_error(errors, "snapshot.domain.scene_registry", "active_instance_mismatch")
		return
	var instance: Dictionary = matching_instances[0]
	var a6_entry: Dictionary = authored_sequence["orchestration"]["a6_entry"]
	if instance.get("scene_definition_id") != a6_entry["scene_definition_id"]:
		_add_error(errors, "snapshot.domain.scene_registry", "scene_definition_mismatch")
	if instance.get("definition_version") != a6_entry["definition"]["version_contrat"]:
		_add_error(errors, "snapshot.domain.scene_registry", "scene_version_mismatch")
	var committed: bool = execution.get("durable_commit_status") in ["APPLIED", "IDEMPOTENT"]
	if committed:
		if instance.get("state") != "RESOLVED":
			_add_error(errors, "snapshot.domain.scene_registry", "committed_instance_not_resolved")
		var resolution = authored_sequence["resolutions"].get(execution.get("selected_resolution_id"), {})
		if (
			typeof(resolution) != TYPE_DICTIONARY
			or instance.get("choice_id") != resolution.get("a10_choice_id")
			or instance.get("resolution_id") != resolution.get("a10_resolution_id")
		):
			_add_error(errors, "snapshot.domain.scene_registry", "committed_resolution_mismatch")
	elif instance.get("state") != "PROPOSED":
		_add_error(errors, "snapshot.domain.scene_registry", "active_instance_not_proposed")


static func _validate_port_identity(
	port_snapshot: Dictionary,
	execution: Dictionary,
	authored_sequence: Dictionary,
	errors: Array[String]
) -> void:
	if port_snapshot["open_requests"].size() > 1:
		_add_error(errors, "snapshot.projection_port.open_requests", "multiple_open_projections")
	for request in port_snapshot["open_requests"]:
		if (
			request["instance_id"] != execution["instance_id"]
			or request["sequence_id"] != authored_sequence["sequence_id"]
			or request["authored_version"] != authored_sequence["authored_version"]
			or request["beat_id"] != execution["current_beat_id"]
		):
			_add_error(errors, "snapshot.projection_port.open_requests", "execution_identity_mismatch")
		var presentation_id := ProjectionContracts.presentation_id_for(request)
		if presentation_id not in execution["opened_projection_ids"]:
			_add_error(errors, "snapshot.projection_port.open_requests", "execution_projection_missing")
	if execution["execution_status"] in ["WAITING_FOR_PLAYER", "WAITING_FOR_PROJECTION_ACK"]:
		if port_snapshot["open_requests"].size() != 1:
			_add_error(errors, "snapshot.projection_port.open_requests", "waiting_projection_missing")
	elif not port_snapshot["open_requests"].is_empty():
		_add_error(errors, "snapshot.projection_port.open_requests", "unexpected_open_projection")


static func _facade_usable(value) -> bool:
	return (
		value != null
		and typeof(value) == TYPE_OBJECT
		and value.has_method("save_state")
		and value.has_method("restore_state")
	)


static func _port_usable(value) -> bool:
	if value == null or typeof(value) != TYPE_OBJECT:
		return false
	for method_name in ["snapshot", "restore"]:
		if not value.has_method(method_name):
			return false
	return true


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
	}
