extends RefCounted

class_name R8CAuthoredSequenceCatalogLoader

const CatalogValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceCatalogValidator.gd"
)
const MessagesResolver := preload(
	"res://scripts/unified_runtime/application/ReferencedMessagesContentResolver.gd"
)
const PhysicalResolver := preload(
	"res://scripts/unified_runtime/projection/PhysicalContentResolver.gd"
)
const MediaResolver := preload(
	"res://scripts/unified_runtime/projection/AuthoredMediaResolver.gd"
)
const CatalogMediaResolver := preload(
	"res://scripts/unified_runtime/application/CatalogMediaResolver.gd"
)
const LibraryModel := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)


static func load_catalog(path: String, expected_catalog_id := "", expected_season_id := "") -> Dictionary:
	if not _valid_manifest_path(path):
		return _failure("INVALID_CATALOG_PATH")
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	if typeof(parsed) != TYPE_DICTIONARY:
		return _failure("INVALID_CATALOG_JSON")
	var manifest: Dictionary = JsonNormalizer.normalize(parsed)
	var validation := CatalogValidator.validate(manifest, expected_catalog_id, expected_season_id)
	if not validation["valid"]:
		return _failure("INVALID_AUTHORED_SEQUENCE_CATALOG", validation["errors"])
	var packages: Array = []
	var package_by_id := {}
	var package_by_sequence_id := {}
	var package_by_candidate_key := {}
	var definitions: Array = []
	var messages_metadata := {"characters": {}, "threads": []}
	var thread_ids := {}
	var message_definitions := {}
	var choice_definitions := {}
	for loaded in validation["packages"]:
		var package: Dictionary = loaded.duplicate(true)
		var sequence: Dictionary = package["sequence"]
		var messages_result := MessagesResolver.create(sequence, package["messages_catalog"], true)
		var physical_result := PhysicalResolver.create(sequence, package["physical_catalog"], true)
		var media_result := MediaResolver.create(sequence, package["media_catalog"], true)
		if not messages_result["ok"] or not physical_result["ok"] or not media_result["ok"]:
			return _failure("PACKAGE_RESOLVER_REFUSED")
		package["messages_resolver"] = messages_result["resolver"]
		package["physical_resolver"] = physical_result["resolver"]
		package["media_resolver"] = media_result["resolver"]
		var a6: Dictionary = sequence["orchestration"]["a6_entry"]
		var candidate_identity := candidate_key(a6["scene_definition_id"], a6["variant_id"])
		package["candidate_key"] = candidate_identity
		var package_id: String = package["manifest"]["package_id"]
		var sequence_id: String = sequence["sequence_id"]
		if package_by_sequence_id.has(sequence_id):
			return _failure("DUPLICATE_SEQUENCE_ID")
		packages.append(package)
		package_by_id[package_id] = package
		package_by_sequence_id[sequence_id] = package
		package_by_candidate_key[candidate_identity] = package
		definitions.append(a6.duplicate(true))
		var merged_metadata := _merge_messages_metadata(
			messages_metadata, package["messages_catalog"]["presentation_metadata"], thread_ids
		)
		if not merged_metadata["ok"]:
			return _failure(str(merged_metadata["error_code"]))
		var indexed := _index_messages(package, message_definitions, choice_definitions)
		if not indexed["ok"]:
			return _failure(str(indexed["error_code"]))
	var library_result := LibraryModel.charger_depuis_bundle({
		"format": "R8C_A6_SCENE_LIBRARY",
		"version": 1,
		"definitions": definitions,
	})
	if not library_result.get("ok", false):
		return _failure("A6_LIBRARY_REFUSED")
	var global_media := CatalogMediaResolver.create(
		manifest["catalog_id"], validation["fingerprint"], packages
	)
	if not global_media["ok"]:
		return _failure(str(global_media["error_code"]))
	var catalog := {
		"manifest": manifest.duplicate(true),
		"catalog_id": manifest["catalog_id"],
		"season_id": manifest["season_id"],
		"fingerprint": validation["fingerprint"],
		"packages": packages,
		"package_by_id": package_by_id,
		"package_by_sequence_id": package_by_sequence_id,
		"package_by_candidate_key": package_by_candidate_key,
		"library": library_result["bibliotheque"],
		"media_resolver": global_media["resolver"],
		"messages_metadata": messages_metadata,
		"message_definitions": message_definitions,
		"choice_definitions": choice_definitions,
	}
	return {"ok": true, "error_code": null, "errors": [], "catalog": catalog}


static func candidate_key(scene_definition_id: String, variant_id: String) -> String:
	return "%s::%s" % [scene_definition_id, variant_id]


static func _merge_messages_metadata(
	target: Dictionary, incoming: Dictionary, seen_threads: Dictionary
) -> Dictionary:
	for character_id in incoming.get("characters", {}):
		var definition = incoming["characters"][character_id]
		if target["characters"].has(character_id) and target["characters"][character_id] != definition:
			return {"ok": false, "error_code": "CONFLICTING_GLOBAL_CHARACTER_ID"}
		target["characters"][character_id] = definition.duplicate(true)
	for thread in incoming.get("threads", []):
		var thread_id := str(thread.get("thread_id", ""))
		if seen_threads.has(thread_id):
			if seen_threads[thread_id] != thread:
				return {"ok": false, "error_code": "CONFLICTING_GLOBAL_THREAD_ID"}
			continue
		seen_threads[thread_id] = thread.duplicate(true)
		target["threads"].append(thread.duplicate(true))
	return {"ok": true, "error_code": null}


static func _index_messages(
	package: Dictionary, message_definitions: Dictionary, choice_definitions: Dictionary
) -> Dictionary:
	var sequence: Dictionary = package["sequence"]
	var sequence_id: String = sequence["sequence_id"]
	var referenced_by_ref := {}
	for entry in package["messages_catalog"]["entries"]:
		referenced_by_ref[entry["content_ref"]] = entry
	for beat in sequence["beats"]:
		var thread_id := str(beat.get("content", {}).get("thread_id", ""))
		var messages: Array = []
		if beat["type"] == "MESSAGE":
			messages = beat["content"]["messages"]
		elif beat["type"] in ["AFTERCARE", "RETURN"]:
			var entry = referenced_by_ref.get(beat["content"]["content_ref"], {})
			thread_id = str(entry.get("thread_id", ""))
			messages = entry.get("messages", [])
		for message in messages:
			var definition: Dictionary = message.duplicate(true)
			definition["sequence_id"] = sequence_id
			definition["beat_id"] = beat["beat_id"]
			definition["thread_id"] = thread_id
			message_definitions[message["message_id"]] = definition
		if beat["type"] == "CHOICE":
			for choice in beat["content"]["choices"]:
				var choice_id: String = choice["choice_id"]
				if choice_definitions.has(choice_id):
					return {"ok": false, "error_code": "DUPLICATE_GLOBAL_CHOICE_ID"}
				choice_definitions[choice_id] = {
					"choice_id": choice_id,
					"text": choice["text"],
					"sequence_id": sequence_id,
					"beat_id": beat["beat_id"],
					"thread_id": thread_id,
				}
	return {"ok": true, "error_code": null}


static func _valid_manifest_path(path: String) -> bool:
	if not path.begins_with("res://") or not path.ends_with(".json") or path.contains("\\"):
		return false
	for segment in path.trim_prefix("res://").split("/"):
		if segment.is_empty() or segment in [".", ".."]:
			return false
	return FileAccess.file_exists(path)


static func _failure(error_code: String, errors: Array = []) -> Dictionary:
	return {"ok": false, "error_code": error_code, "errors": errors.duplicate(), "catalog": {}}
