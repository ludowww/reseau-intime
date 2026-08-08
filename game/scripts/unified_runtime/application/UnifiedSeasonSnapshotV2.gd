extends RefCounted

class_name R8CUnifiedSeasonSnapshotV2

const SeasonSnapshotV1 := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonSnapshotV1.gd"
)
const RuntimeSnapshotV2 := preload(
	"res://scripts/unified_runtime/application/UnifiedRuntimeSnapshotV2.gd"
)
const PersistentMessages := preload(
	"res://scripts/unified_runtime/application/PersistentMessagesStateV1.gd"
)

const SCHEMA_ID := "reseau_intime.unified_season"
const SCHEMA_VERSION := 2
const N21_CATALOG_FINGERPRINT := "ec869bd0eb4d0ce7c16ad41b08f70f24e0a08367a039f9f1306ddd58c7673beb"
const N21_SEQUENCE_IDS := [
	"mathilde_returns_with_chosen_intent_01",
	"sandra_sentrycore_button_echo_01",
	"marie_evening_return_01",
]
const FIELDS := [
	"schema_id", "schema_version", "catalog_id", "catalog_fingerprint", "season_id",
	"active_sequence_id", "completed_sequence_ids", "not_selected_sequence_ids",
	"active_runtime_snapshot", "persistent_messages_state",
]


static func create(
	catalog: Dictionary,
	active_sequence_id: String,
	completed_sequence_ids: Array,
	not_selected_sequence_ids: Array,
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
		"not_selected_sequence_ids": not_selected_sequence_ids.duplicate(),
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
	var completed := _validate_sequence_ids(
		value["completed_sequence_ids"], "completed_sequence_ids", catalog, errors
	)
	var not_selected := _validate_sequence_ids(
		value["not_selected_sequence_ids"], "not_selected_sequence_ids", catalog, errors
	)
	for sequence_id in not_selected:
		if sequence_id in completed:
			errors.append("season_snapshot.not_selected_sequence_ids:not_disjoint")
	var active_sequence_id = value["active_sequence_id"]
	var active_snapshot = value["active_runtime_snapshot"]
	if active_sequence_id == null:
		if active_snapshot != null:
			errors.append("season_snapshot.active_runtime_snapshot:unexpected_without_active_sequence")
	elif (
		typeof(active_sequence_id) != TYPE_STRING
		or not catalog.get("package_by_sequence_id", {}).has(active_sequence_id)
		or active_sequence_id in completed
		or active_sequence_id in not_selected
	):
		errors.append("season_snapshot.active_sequence_id:invalid")
	elif typeof(active_snapshot) != TYPE_DICTIONARY:
		errors.append("season_snapshot.active_runtime_snapshot:expected_dictionary")
	else:
		var package: Dictionary = catalog["package_by_sequence_id"][active_sequence_id]
		if not RuntimeSnapshotV2.validate(active_snapshot, package["sequence"])["valid"]:
			errors.append("season_snapshot.active_runtime_snapshot:invalid_v2_snapshot")
	var messages_validation := PersistentMessages.validate(
		value["persistent_messages_state"], catalog.get("messages_metadata", {}), catalog
	)
	for error in messages_validation["errors"]:
		errors.append("season_snapshot." + str(error))
	return _result(errors)


static func migrate_n21_v1(value, catalog: Dictionary) -> Dictionary:
	if (
		typeof(value) != TYPE_DICTIONARY
		or value.get("schema_id") != SCHEMA_ID
		or value.get("schema_version") != 1
		or value.get("catalog_id") != "season_1_v1"
		or value.get("season_id") != "season_1"
		or value.get("catalog_fingerprint") != N21_CATALOG_FINGERPRINT
	):
		return _failure("UNSUPPORTED_N21_SEASON_SNAPSHOT")
	var legacy_catalog := _n21_catalog_view(catalog)
	var legacy_validation := SeasonSnapshotV1.validate(value, legacy_catalog)
	if not legacy_validation["valid"]:
		return _failure("INVALID_N21_SEASON_SNAPSHOT", legacy_validation["errors"])
	var upgraded := _upgrade_n21_messages(value["persistent_messages_state"], catalog, legacy_catalog)
	if not upgraded["ok"]:
		return upgraded
	var created := create(
		catalog,
		str(value["active_sequence_id"]) if value["active_sequence_id"] != null else "",
		value["completed_sequence_ids"],
		[],
		value["active_runtime_snapshot"],
		upgraded["state"],
	)
	if created["ok"]:
		created["migrated"] = true
	return created


static func migrate_n17_v2(value, catalog: Dictionary) -> Dictionary:
	var migrated_v1 := SeasonSnapshotV1.migrate_n17_v2(value, catalog)
	if not migrated_v1["ok"]:
		return migrated_v1
	var snapshot: Dictionary = migrated_v1["snapshot"]
	var created := create(
		catalog,
		str(snapshot["active_sequence_id"]),
		snapshot["completed_sequence_ids"],
		[],
		snapshot["active_runtime_snapshot"],
		snapshot["persistent_messages_state"],
	)
	if created["ok"]:
		created["migrated"] = true
	return created


static func _upgrade_n21_messages(
	state: Dictionary, catalog: Dictionary, legacy_catalog: Dictionary
) -> Dictionary:
	var legacy_validation := PersistentMessages.validate(
		state, legacy_catalog["messages_metadata"], legacy_catalog
	)
	if not legacy_validation["valid"]:
		return _failure("INVALID_N21_PERSISTENT_MESSAGES", legacy_validation["errors"])
	var upgraded: Dictionary = state.duplicate(true)
	var metadata: Dictionary = catalog["messages_metadata"]
	upgraded["source"]["characters"] = metadata["characters"].duplicate(true)
	var old_threads := {}
	for thread in upgraded["source"]["threads"]:
		old_threads[str(thread["thread_id"])] = thread.duplicate(true)
	var threads: Array = []
	for expected in metadata["threads"]:
		var thread_id := str(expected["thread_id"])
		if old_threads.has(thread_id):
			threads.append(old_threads[thread_id])
		else:
			threads.append(expected.duplicate(true))
			upgraded["source"]["messages_by_thread"][thread_id] = []
			upgraded["source"]["choices_by_thread"][thread_id] = []
			upgraded["presented_message_ids_by_thread"][thread_id] = []
	upgraded["source"]["threads"] = threads
	var validation := PersistentMessages.validate(upgraded, metadata, catalog)
	if not validation["valid"]:
		return _failure("N22_PERSISTENT_MESSAGES_UPGRADE_REFUSED", validation["errors"])
	return {"ok": true, "error_code": null, "errors": [], "state": upgraded}


static func _n21_catalog_view(catalog: Dictionary) -> Dictionary:
	var legacy: Dictionary = catalog.duplicate(true)
	legacy["fingerprint"] = N21_CATALOG_FINGERPRINT
	legacy["packages"] = []
	legacy["package_by_sequence_id"] = {}
	for package in catalog.get("packages", []):
		var sequence_id := str(package.get("sequence", {}).get("sequence_id", ""))
		if sequence_id in N21_SEQUENCE_IDS:
			legacy["packages"].append(package)
			legacy["package_by_sequence_id"][sequence_id] = package
	for field in ["message_definitions", "choice_definitions"]:
		legacy[field] = {}
		for key in catalog.get(field, {}):
			if catalog[field][key].get("sequence_id") in N21_SEQUENCE_IDS:
				legacy[field][key] = catalog[field][key]
	var metadata: Dictionary = catalog["messages_metadata"].duplicate(true)
	metadata["characters"].erase("nico")
	var threads: Array = []
	for thread in metadata["threads"]:
		if str(thread.get("thread_id", "")) != "nico_thread":
			threads.append(thread)
	metadata["threads"] = threads
	legacy["messages_metadata"] = metadata
	return legacy


static func _validate_sequence_ids(
	value, field: String, catalog: Dictionary, errors: Array[String]
) -> Array:
	var result: Array = []
	if typeof(value) != TYPE_ARRAY:
		errors.append("season_snapshot.%s:expected_array" % field)
		return result
	var seen := {}
	for sequence_id in value:
		if (
			typeof(sequence_id) != TYPE_STRING
			or not catalog.get("package_by_sequence_id", {}).has(sequence_id)
			or seen.has(sequence_id)
		):
			errors.append("season_snapshot.%s:invalid_or_duplicate" % field)
			continue
		seen[sequence_id] = true
		result.append(sequence_id)
	return result


static func _exact(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _result(errors: Array) -> Dictionary:
	errors.sort()
	return {"valid": errors.is_empty(), "errors": errors.duplicate()}


static func _failure(error_code: String, errors: Array = []) -> Dictionary:
	return {
		"ok": false, "error_code": error_code, "errors": errors.duplicate(),
		"snapshot": {}, "state": {},
	}
