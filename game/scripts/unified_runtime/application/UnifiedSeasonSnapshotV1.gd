extends RefCounted

class_name R8CUnifiedSeasonSnapshotV1

const RuntimeSnapshotV2 := preload(
	"res://scripts/unified_runtime/application/UnifiedRuntimeSnapshotV2.gd"
)
const PersistentMessages := preload(
	"res://scripts/unified_runtime/application/PersistentMessagesStateV1.gd"
)

const SCHEMA_ID := "reseau_intime.unified_season"
const SCHEMA_VERSION := 1
const FIELDS := [
	"schema_id", "schema_version", "catalog_id", "catalog_fingerprint", "season_id",
	"active_sequence_id", "completed_sequence_ids", "active_runtime_snapshot",
	"persistent_messages_state",
]


static func create(
	catalog: Dictionary,
	active_sequence_id: String,
	completed_sequence_ids: Array,
	active_runtime_snapshot,
	persistent_messages_state: Dictionary,
) -> Dictionary:
	var snapshot := {
		"schema_id": SCHEMA_ID,
		"schema_version": SCHEMA_VERSION,
		"catalog_id": catalog.get("catalog_id"),
		"catalog_fingerprint": catalog.get("fingerprint"),
		"season_id": catalog.get("season_id"),
		"active_sequence_id": active_sequence_id if not active_sequence_id.is_empty() else null,
		"completed_sequence_ids": completed_sequence_ids.duplicate(),
		"active_runtime_snapshot": (
			active_runtime_snapshot.duplicate(true)
			if typeof(active_runtime_snapshot) == TYPE_DICTIONARY else null
		),
		"persistent_messages_state": persistent_messages_state.duplicate(true),
	}
	var validation := validate(snapshot, catalog)
	if not validation["valid"]:
		return _failure("INVALID_SEASON_SNAPSHOT", validation["errors"])
	return {"ok": true, "error_code": null, "errors": [], "snapshot": snapshot}


static func validate(value, catalog: Dictionary) -> Dictionary:
	var errors: Array[String] = []
	if typeof(value) != TYPE_DICTIONARY or not _exact(value, FIELDS):
		return _result(["season_snapshot:unexpected_fields"])
	if value["schema_id"] != SCHEMA_ID:
		errors.append("season_snapshot.schema_id:unknown_namespace")
	if value["schema_version"] != SCHEMA_VERSION:
		errors.append("season_snapshot.schema_version:unsupported_version")
	if value["catalog_id"] != catalog.get("catalog_id"):
		errors.append("season_snapshot.catalog_id:catalog_mismatch")
	if value["catalog_fingerprint"] != catalog.get("fingerprint"):
		errors.append("season_snapshot.catalog_fingerprint:catalog_mismatch")
	if value["season_id"] != catalog.get("season_id"):
		errors.append("season_snapshot.season_id:season_mismatch")
	var completed = value["completed_sequence_ids"]
	if typeof(completed) != TYPE_ARRAY:
		errors.append("season_snapshot.completed_sequence_ids:expected_array")
		completed = []
	var seen := {}
	for sequence_id in completed:
		if (
			typeof(sequence_id) != TYPE_STRING
			or not catalog.get("package_by_sequence_id", {}).has(sequence_id)
			or seen.has(sequence_id)
		):
			errors.append("season_snapshot.completed_sequence_ids:invalid_or_duplicate")
			continue
		seen[sequence_id] = true
	var active_sequence_id = value["active_sequence_id"]
	var active_snapshot = value["active_runtime_snapshot"]
	if active_sequence_id == null:
		if active_snapshot != null:
			errors.append("season_snapshot.active_runtime_snapshot:unexpected_without_active_sequence")
	elif (
		typeof(active_sequence_id) != TYPE_STRING
		or not catalog.get("package_by_sequence_id", {}).has(active_sequence_id)
		or active_sequence_id in completed
	):
		errors.append("season_snapshot.active_sequence_id:invalid")
	elif typeof(active_snapshot) != TYPE_DICTIONARY:
		errors.append("season_snapshot.active_runtime_snapshot:expected_dictionary")
	else:
		var package: Dictionary = catalog["package_by_sequence_id"][active_sequence_id]
		var runtime_validation := RuntimeSnapshotV2.validate(active_snapshot, package["sequence"])
		if not runtime_validation["valid"]:
			errors.append("season_snapshot.active_runtime_snapshot:invalid_v2_snapshot")
	var messages_validation := PersistentMessages.validate(
		value["persistent_messages_state"], catalog.get("messages_metadata", {}), catalog
	)
	for error in messages_validation["errors"]:
		errors.append("season_snapshot." + str(error))
	return _result(errors)


static func migrate_n17_v2(value, catalog: Dictionary) -> Dictionary:
	if typeof(value) != TYPE_DICTIONARY:
		return _failure("INVALID_N17_V2_SNAPSHOT")
	var sequence_id := str(value.get("sequence_id", ""))
	if not catalog.get("package_by_sequence_id", {}).has(sequence_id):
		return _failure("N17_SEQUENCE_NOT_IN_CATALOG")
	var package: Dictionary = catalog["package_by_sequence_id"][sequence_id]
	if value.get("authored_version") != package["manifest"]["authored_version"]:
		return _failure("N17_AUTHORED_VERSION_MISMATCH")
	var validation := RuntimeSnapshotV2.validate(value, package["sequence"])
	if not validation["valid"]:
		return _failure("INVALID_N17_V2_SNAPSHOT", validation["errors"])
	var persistent := PersistentMessages.empty(catalog["messages_metadata"])
	var merged := PersistentMessages.merge_with_active(
		persistent,
		value["messages_adapter"]["source"],
		value["messages_adapter"]["presented_message_ids_by_thread"],
		catalog["messages_metadata"],
	)
	if not merged["ok"]:
		return _failure(str(merged["error_code"]))
	var created := create(catalog, sequence_id, [], value, merged["state"])
	if not created["ok"]:
		return created
	created["migrated"] = true
	return created


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
