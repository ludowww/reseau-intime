extends RefCounted

class_name R8CAuthoredSequenceCatalogValidator

const Contract := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceCatalogV1.gd"
)
const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const MessagesResolver := preload(
	"res://scripts/unified_runtime/application/ReferencedMessagesContentResolver.gd"
)
const PhysicalCatalog := preload(
	"res://scripts/unified_runtime/contracts/PhysicalPresentationContentV1.gd"
)
const MediaResolver := preload(
	"res://scripts/unified_runtime/projection/AuthoredMediaResolver.gd"
)
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)

const FORBIDDEN_PREFIXES := [
	"res://data/runtime/season_1/",
	"res://data/conversations/",
	"res://scripts/runtime/season_1/",
]


static func validate(value, expected_catalog_id := "", expected_season_id := "") -> Dictionary:
	var errors: Array[String] = []
	var loaded_packages: Array = []
	if typeof(value) != TYPE_DICTIONARY:
		return _result(["catalog:expected_dictionary"], loaded_packages)
	var catalog: Dictionary = value
	if not _exact(catalog, Contract.ROOT_FIELDS):
		return _result(["catalog:unexpected_fields"], loaded_packages)
	if catalog["schema_id"] != Contract.SCHEMA_ID:
		errors.append("catalog.schema_id:unknown_namespace")
	if catalog["schema_version"] != Contract.SCHEMA_VERSION:
		errors.append("catalog.schema_version:unsupported_version")
	_validate_identifier(catalog["catalog_id"], "catalog.catalog_id", errors)
	_validate_identifier(catalog["season_id"], "catalog.season_id", errors)
	if not str(expected_catalog_id).is_empty() and catalog["catalog_id"] != expected_catalog_id:
		errors.append("catalog.catalog_id:identity_mismatch")
	if not str(expected_season_id).is_empty() and catalog["season_id"] != expected_season_id:
		errors.append("catalog.season_id:identity_mismatch")
	if typeof(catalog["packages"]) != TYPE_ARRAY or catalog["packages"].is_empty():
		errors.append("catalog.packages:expected_non_empty_array")
		return _result(errors, loaded_packages)

	var package_ids := {}
	var sequence_versions := {}
	var candidate_keys := {}
	var message_ids := {}
	var content_refs := {}
	var thread_definitions := {}
	var media_ids := {}
	for index in catalog["packages"].size():
		var path := "catalog.packages[%d]" % index
		var package = catalog["packages"][index]
		if typeof(package) != TYPE_DICTIONARY or not _exact(package, Contract.PACKAGE_FIELDS):
			errors.append(path + ":unexpected_fields")
			continue
		for field in ["package_id", "sequence_id"]:
			_validate_identifier(package[field], path + "." + field, errors)
		if not _is_semver(package["authored_version"]):
			errors.append(path + ".authored_version:expected_major_minor_patch")
		var package_id := str(package["package_id"])
		if package_ids.has(package_id):
			errors.append(path + ".package_id:duplicate")
		package_ids[package_id] = true
		var sequence_version := "%s@%s" % [package["sequence_id"], package["authored_version"]]
		if sequence_versions.has(sequence_version):
			errors.append(path + ":duplicate_sequence_version")
		sequence_versions[sequence_version] = true
		var files := {}
		for field in Contract.PATH_FIELDS:
			var authored_path := str(package[field])
			if not _valid_resource_json_path(authored_path):
				errors.append(path + "." + field + ":invalid_explicit_resource_path")
				continue
			var loaded := _load_json(authored_path)
			if not loaded["ok"]:
				errors.append(path + "." + field + ":" + loaded["error_code"])
				continue
			files[field] = loaded["value"]
		if files.size() != Contract.PATH_FIELDS.size():
			continue
		_validate_loaded_package(
			catalog, package, files, path, errors, candidate_keys, message_ids,
			content_refs, thread_definitions, media_ids
		)
		loaded_packages.append({
			"manifest": package.duplicate(true),
			"sequence": files["sequence_path"].duplicate(true),
			"messages_catalog": files["messages_path"].duplicate(true),
			"physical_catalog": files["physical_path"].duplicate(true),
			"media_catalog": files["media_path"].duplicate(true),
		})
	return _result(errors, loaded_packages, Contract.fingerprint(catalog))


static func _validate_loaded_package(
	catalog: Dictionary,
	package: Dictionary,
	files: Dictionary,
	path: String,
	errors: Array[String],
	candidate_keys: Dictionary,
	message_ids: Dictionary,
	content_refs: Dictionary,
	thread_definitions: Dictionary,
	media_ids: Dictionary,
) -> void:
	var sequence: Dictionary = files["sequence_path"]
	var messages: Dictionary = files["messages_path"]
	var physical: Dictionary = files["physical_path"]
	var media: Dictionary = files["media_path"]
	var authored := AuthoredValidator.validate(sequence, true)
	if not authored["valid"]:
		errors.append(path + ".sequence_path:invalid_authored_sequence")
		return
	for field in ["sequence_id", "authored_version"]:
		if sequence.get(field) != package[field]:
			errors.append(path + "." + field + ":authored_identity_mismatch")
	if sequence.get("season_id") != catalog["season_id"]:
		errors.append(path + ".sequence_path:season_identity_mismatch")
	var messages_validation := MessagesResolver.validate_catalog(sequence, messages, true)
	if not messages_validation["valid"]:
		errors.append(path + ".messages_path:invalid_messages_catalog")
	var physical_validation := PhysicalCatalog.validate(physical)
	if not physical_validation["valid"]:
		errors.append(path + ".physical_path:invalid_physical_catalog")
	elif (
		physical.get("sequence_id") != package["sequence_id"]
		or physical.get("authored_version") != package["authored_version"]
	):
		errors.append(path + ".physical_path:authored_identity_mismatch")
	var media_result := MediaResolver.create(sequence, media, true)
	if not media_result.get("ok", false):
		errors.append(path + ".media_path:invalid_media_catalog")
	var a6: Dictionary = sequence["orchestration"]["a6_entry"]
	var candidate_key := "%s::%s" % [a6["scene_definition_id"], a6["variant_id"]]
	if candidate_keys.has(candidate_key):
		errors.append(path + ".sequence_path:duplicate_a6_identity")
	candidate_keys[candidate_key] = true
	_register_global_message_identities(sequence, messages, path, errors, message_ids, content_refs)
	_register_global_threads(messages, path, errors, thread_definitions)
	for media_id in sequence["media"]:
		if media_ids.has(media_id):
			errors.append(path + ".media_path:duplicate_global_media_id:" + str(media_id))
		media_ids[media_id] = package["package_id"]


static func _register_global_message_identities(
	sequence: Dictionary,
	messages: Dictionary,
	path: String,
	errors: Array[String],
	message_ids: Dictionary,
	content_refs: Dictionary,
) -> void:
	for beat in sequence["beats"]:
		if beat["type"] == "MESSAGE":
			for message in beat["content"]["messages"]:
				_register_unique(message_ids, message["message_id"], path + ".messages_path", "message_id", errors)
	for entry in messages["entries"]:
		_register_unique(content_refs, entry["content_ref"], path + ".messages_path", "content_ref", errors)
		for message in entry["messages"]:
			_register_unique(message_ids, message["message_id"], path + ".messages_path", "message_id", errors)


static func _register_global_threads(
	messages: Dictionary,
	path: String,
	errors: Array[String],
	thread_definitions: Dictionary,
) -> void:
	var metadata = messages.get("presentation_metadata", {})
	if typeof(metadata) != TYPE_DICTIONARY or typeof(metadata.get("threads")) != TYPE_ARRAY:
		return
	for thread in metadata["threads"]:
		if typeof(thread) != TYPE_DICTIONARY:
			continue
		var thread_id := str(thread.get("thread_id", ""))
		if thread_definitions.has(thread_id) and thread_definitions[thread_id] != thread:
			errors.append(path + ".messages_path:conflicting_global_thread_id:" + thread_id)
		else:
			thread_definitions[thread_id] = thread.duplicate(true)


static func _register_unique(
	registry: Dictionary, identifier, path: String, kind: String, errors: Array[String]
) -> void:
	var key := str(identifier)
	if registry.has(key):
		errors.append("%s:duplicate_global_%s:%s" % [path, kind, key])
	registry[key] = true


static func _valid_resource_json_path(path: String) -> bool:
	if not path.begins_with("res://") or not path.ends_with(".json") or path.contains("\\"):
		return false
	for prefix in FORBIDDEN_PREFIXES:
		if path.begins_with(prefix):
			return false
	var relative := path.trim_prefix("res://")
	if relative.is_empty():
		return false
	for segment in relative.split("/"):
		if segment.is_empty() or segment in [".", ".."]:
			return false
	return path.simplify_path() == path and FileAccess.file_exists(path)


static func _load_json(path: String) -> Dictionary:
	var text := FileAccess.get_file_as_string(path)
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return {"ok": false, "error_code": "invalid_json", "value": {}}
	return {"ok": true, "error_code": null, "value": JsonNormalizer.normalize(parsed)}


static func _exact(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _validate_identifier(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_STRING or value.is_empty() or value.length() > 96 or value != value.strip_edges():
		errors.append(path + ":invalid_identifier")
		return
	for index in value.length():
		if value.substr(index, 1) not in "abcdefghijklmnopqrstuvwxyz0123456789_":
			errors.append(path + ":invalid_identifier")
			return


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


static func _result(errors: Array, packages: Array, fingerprint := "") -> Dictionary:
	var sorted_errors: Array = errors.duplicate()
	sorted_errors.sort()
	return {
		"valid": sorted_errors.is_empty(),
		"errors": sorted_errors,
		"packages": packages.duplicate(true),
		"fingerprint": fingerprint,
	}
