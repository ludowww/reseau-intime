extends RefCounted

class_name R8CUnifiedRuntimeSnapshotV2

const V1Snapshot := preload(
	"res://scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd"
)
const SequenceExecution := preload(
	"res://scripts/unified_runtime/application/SequenceExecutionV2.gd"
)
const Moment := preload("res://scripts/unified_runtime/application/NarrativeMoment.gd")

const SCHEMA_ID := "reseau_intime.unified_player_runtime"
const SCHEMA_VERSION := 2
const FIELDS := [
	"schema_id", "schema_version", "sequence_id", "authored_version", "narrative_time",
	"domain", "execution", "projection_port", "messages_adapter",
]
const MESSAGES_ADAPTER_FIELDS := [
	"active", "notification_dismissed", "notification_presented",
	"presented_message_ids_by_thread", "progression_ack_sent",
	"progression_command_sent", "snapshot_version", "source",
]


static func create(
	facade,
	projection_port,
	authored_sequence,
	execution,
	messages_adapter_snapshot,
	narrative_time,
) -> Dictionary:
	if facade == null or not facade.has_method("save_state"):
		return _failure("INVALID_A10_FACADE")
	if projection_port == null or not projection_port.has_method("snapshot"):
		return _failure("INVALID_PROJECTION_PORT")
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
		"sequence_id": authored_sequence.get("sequence_id"),
		"authored_version": authored_sequence.get("authored_version"),
		"narrative_time": narrative_time,
		"domain": facade.save_state(),
		"execution": execution.duplicate(true) if typeof(execution) == TYPE_DICTIONARY else execution,
		"projection_port": port_result["snapshot"].duplicate(true),
		"messages_adapter": (
			messages_adapter_snapshot.duplicate(true)
			if typeof(messages_adapter_snapshot) == TYPE_DICTIONARY else messages_adapter_snapshot
		),
	}
	var validation := validate(snapshot, authored_sequence)
	if not validation["valid"]:
		return _failure("INVALID_V2_SNAPSHOT", validation["errors"])
	return {"ok": true, "error_code": null, "errors": [], "snapshot": snapshot}


static func validate(value, authored_sequence) -> Dictionary:
	var errors: Array[String] = []
	if typeof(value) != TYPE_DICTIONARY:
		return _result(["snapshot:expected_dictionary"])
	var snapshot: Dictionary = value
	if not _exact(snapshot, FIELDS):
		return _result(["snapshot:unexpected_fields"])
	if snapshot["schema_id"] != SCHEMA_ID:
		errors.append("snapshot.schema_id:unknown_namespace")
	if snapshot["schema_version"] != SCHEMA_VERSION:
		errors.append("snapshot.schema_version:unsupported_version")
	if typeof(authored_sequence) != TYPE_DICTIONARY:
		errors.append("snapshot:invalid_authored_sequence")
	else:
		if snapshot["sequence_id"] != authored_sequence.get("sequence_id"):
			errors.append("snapshot.sequence_id:authored_identity_mismatch")
		if snapshot["authored_version"] != authored_sequence.get("authored_version"):
			errors.append("snapshot.authored_version:authored_version_mismatch")
	if not Moment.validate(snapshot["narrative_time"]):
		errors.append("snapshot.narrative_time:invalid_normalized_moment")
	if typeof(snapshot["messages_adapter"]) != TYPE_DICTIONARY:
		errors.append("snapshot.messages_adapter:expected_dictionary")
	else:
		_validate_messages_adapter_boundary(
			snapshot["messages_adapter"], snapshot["execution"], errors
		)
	var execution_validation := SequenceExecution.validate(snapshot["execution"], authored_sequence)
	for error in execution_validation.get("errors", []):
		errors.append("snapshot.execution." + str(error))
	var proxy_validation := V1Snapshot.validate(_v1_proxy(snapshot), authored_sequence)
	for error in proxy_validation.get("errors", []):
		errors.append("snapshot.v1_core." + str(error))
	return _result(errors)


static func restore_core_into(facade, projection_port, authored_sequence, snapshot) -> Dictionary:
	var validation := validate(snapshot, authored_sequence)
	if not validation["valid"]:
		return _failure("INVALID_V2_SNAPSHOT", validation["errors"])
	var restored := V1Snapshot.restore_into(
		facade, projection_port, authored_sequence, _v1_proxy(snapshot)
	)
	if not restored.get("ok", false):
		return _failure(str(restored.get("error_code", "V2_CORE_RESTORE_REFUSED")))
	return {
		"ok": true,
		"error_code": null,
		"errors": [],
		"execution": snapshot["execution"].duplicate(true),
		"messages_adapter": snapshot["messages_adapter"].duplicate(true),
		"narrative_time": snapshot["narrative_time"],
	}


static func migrate_v1(
	v1_snapshot,
	authored_sequence,
	narrative_time,
	messages_adapter_snapshot,
) -> Dictionary:
	var v1_validation := V1Snapshot.validate(v1_snapshot, authored_sequence)
	if not v1_validation["valid"]:
		return _failure("INVALID_V1_SNAPSHOT", v1_validation["errors"])
	if not v1_snapshot["execution"].get("scheduled_returns", []).is_empty():
		return _failure("UNSUPPORTED_V1_DEFERRED_RETURN_STATE")
	var migrated_execution := SequenceExecution.migrate_v1_execution(
		v1_snapshot["execution"], authored_sequence, narrative_time
	)
	if not migrated_execution["ok"]:
		return _failure(str(migrated_execution["error_code"]))
	var migrated := {
		"schema_id": SCHEMA_ID,
		"schema_version": SCHEMA_VERSION,
		"sequence_id": v1_snapshot["sequence_id"],
		"authored_version": v1_snapshot["authored_version"],
		"narrative_time": narrative_time,
		"domain": v1_snapshot["domain"].duplicate(true),
		"execution": migrated_execution["execution"].duplicate(true),
		"projection_port": v1_snapshot["projection_port"].duplicate(true),
		"messages_adapter": messages_adapter_snapshot.duplicate(true),
	}
	var validation := validate(migrated, authored_sequence)
	if not validation["valid"]:
		return _failure("INVALID_V2_SNAPSHOT", validation["errors"])
	return {"ok": true, "error_code": null, "errors": [], "snapshot": migrated}


static func _v1_proxy(snapshot: Dictionary) -> Dictionary:
	return {
		"schema_id": V1Snapshot.SCHEMA_ID,
		"schema_version": V1Snapshot.SCHEMA_VERSION,
		"sequence_id": snapshot.get("sequence_id"),
		"authored_version": snapshot.get("authored_version"),
		"domain": snapshot.get("domain"),
		"execution": SequenceExecution.to_v1_shape(snapshot.get("execution")),
		"projection_port": snapshot.get("projection_port"),
	}


static func _validate_messages_adapter_boundary(
	adapter: Dictionary, execution, errors: Array[String]
) -> void:
	if not _exact(adapter, MESSAGES_ADAPTER_FIELDS) or adapter.get("snapshot_version") != 1:
		errors.append("snapshot.messages_adapter:unexpected_fields")
		return
	for field in ["active", "presented_message_ids_by_thread", "source"]:
		if typeof(adapter.get(field)) != TYPE_DICTIONARY:
			errors.append("snapshot.messages_adapter.%s:expected_dictionary" % field)
	for field in [
		"notification_dismissed", "notification_presented", "progression_ack_sent",
		"progression_command_sent",
	]:
		if typeof(adapter.get(field)) != TYPE_BOOL:
			errors.append("snapshot.messages_adapter.%s:expected_boolean" % field)
	var active = adapter.get("active")
	if (
		typeof(execution) == TYPE_DICTIONARY
		and typeof(active) == TYPE_DICTIONARY
		and execution.get("execution_status") in ["RESOLVED_RETURN_PENDING", "COMPLETE"]
		and (
			not active.is_empty()
			or adapter.get("notification_dismissed") == true
			or adapter.get("notification_presented") == true
			or adapter.get("progression_ack_sent") == true
			or adapter.get("progression_command_sent") == true
		)
	):
		errors.append("snapshot.messages_adapter:stale_durable_boundary")


static func _exact(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _result(errors: Array) -> Dictionary:
	return {"valid": errors.is_empty(), "errors": errors.duplicate()}


static func _failure(error_code: String, errors: Array = []) -> Dictionary:
	return {"ok": false, "error_code": error_code, "errors": errors.duplicate(), "snapshot": {}}
