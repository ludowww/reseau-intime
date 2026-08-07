extends RefCounted

class_name R8CReferencedMessagesContentResolver

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const SceneDefinition := preload("res://scripts/narrative_scene/SceneDefinition.gd")

const SCHEMA_ID := "reseau_intime.referenced_messages_catalog"
const SCHEMA_VERSION := 1
const ROOT_FIELDS := [
	"schema_id", "schema_version", "sequence_id", "authored_version",
	"presentation_metadata", "entries",
]
const ENTRY_FIELDS := ["content_ref", "beat_type", "thread_id", "messages"]
const MESSAGE_FIELDS := ["message_id", "author_id", "text", "diegetic_at", "relative_order"]
const REFERENCED_TYPES := ["AFTERCARE", "RETURN"]

var _authored_sequence: Dictionary = {}
var _catalog: Dictionary = {}
var _entries_by_ref: Dictionary = {}


static func create(authored_sequence, catalog, allow_chained_returns := false) -> Dictionary:
	var validation := validate_catalog(authored_sequence, catalog, allow_chained_returns)
	if not validation["valid"]:
		return {
			"ok": false,
			"error_code": "INVALID_REFERENCED_MESSAGES_CATALOG",
			"errors": validation["errors"],
			"resolver": null,
		}
	var resolver := new()
	resolver._authored_sequence = authored_sequence.duplicate(true)
	resolver._catalog = catalog.duplicate(true)
	for entry in catalog["entries"]:
		resolver._entries_by_ref[entry["content_ref"]] = entry.duplicate(true)
	return {"ok": true, "error_code": null, "errors": [], "resolver": resolver}


static func validate_catalog(authored_sequence, catalog, allow_chained_returns := false) -> Dictionary:
	var errors: Array[String] = []
	if (
		typeof(authored_sequence) != TYPE_DICTIONARY
		or not AuthoredValidator.validate(authored_sequence, allow_chained_returns)["valid"]
	):
		return _result(["catalog:invalid_authored_sequence"])
	if typeof(catalog) != TYPE_DICTIONARY:
		return _result(["catalog:expected_dictionary"])
	if not _exact(catalog, ROOT_FIELDS):
		return _result(["catalog:unexpected_fields"])
	if catalog["schema_id"] != SCHEMA_ID:
		errors.append("catalog.schema_id:unknown_namespace")
	if catalog["schema_version"] != SCHEMA_VERSION:
		errors.append("catalog.schema_version:unsupported_version")
	if catalog["sequence_id"] != authored_sequence["sequence_id"]:
		errors.append("catalog.sequence_id:authored_identity_mismatch")
	if catalog["authored_version"] != authored_sequence["authored_version"]:
		errors.append("catalog.authored_version:authored_version_mismatch")
	if typeof(catalog["presentation_metadata"]) != TYPE_DICTIONARY:
		errors.append("catalog.presentation_metadata:expected_dictionary")
	if typeof(catalog["entries"]) != TYPE_ARRAY:
		errors.append("catalog.entries:expected_array")
		return _result(errors)
	var authored_by_ref := {}
	var seen_messages := {}
	for beat in authored_sequence["beats"]:
		if beat["type"] in REFERENCED_TYPES:
			authored_by_ref[beat["content"]["content_ref"]] = beat
		elif beat["type"] == "MESSAGE":
			for message in beat["content"]["messages"]:
				seen_messages[message["message_id"]] = true
	var allowed_author_ids := {}
	for participant_id in authored_sequence["participants"]["present_character_ids"]:
		allowed_author_ids[participant_id] = true
	for participant_id in authored_sequence["participants"]["concerned_absent_character_ids"]:
		allowed_author_ids[participant_id] = true
	allowed_author_ids["player"] = true
	var seen_refs := {}
	for index in catalog["entries"].size():
		var path := "catalog.entries[%d]" % index
		var entry = catalog["entries"][index]
		if typeof(entry) != TYPE_DICTIONARY or not _exact(entry, ENTRY_FIELDS):
			errors.append(path + ":unexpected_fields")
			continue
		var content_ref = entry["content_ref"]
		if not _identifier(content_ref) or seen_refs.has(content_ref):
			errors.append(path + ".content_ref:invalid_or_duplicate")
			continue
		seen_refs[content_ref] = true
		if not authored_by_ref.has(content_ref):
			errors.append(path + ".content_ref:not_authored")
			continue
		if entry["beat_type"] != authored_by_ref[content_ref]["type"]:
			errors.append(path + ".beat_type:authored_type_mismatch")
		if not _identifier(entry["thread_id"]):
			errors.append(path + ".thread_id:expected_identifier")
		if typeof(entry["messages"]) != TYPE_ARRAY or entry["messages"].is_empty():
			errors.append(path + ".messages:expected_non_empty_array")
			continue
		for message_index in entry["messages"].size():
			var message_path := path + ".messages[%d]" % message_index
			var message = entry["messages"][message_index]
			if typeof(message) != TYPE_DICTIONARY or not _exact(message, MESSAGE_FIELDS):
				errors.append(message_path + ":unexpected_fields")
				continue
			var message_id = message["message_id"]
			if not _identifier(message_id) or seen_messages.has(message_id):
				errors.append(message_path + ".message_id:invalid_or_duplicate")
			else:
				seen_messages[message_id] = true
			if not _identifier(message["author_id"]):
				errors.append(message_path + ".author_id:expected_identifier")
			elif not allowed_author_ids.has(message["author_id"]):
				errors.append(message_path + ".author_id:unknown_participant")
			if typeof(message["text"]) != TYPE_STRING or message["text"].is_empty():
				errors.append(message_path + ".text:expected_non_empty_string")
			if not SceneDefinition.moment_normalise_valide(message["diegetic_at"]):
				errors.append(message_path + ".diegetic_at:invalid_normalized_moment")
			if message["relative_order"] != message_index:
				errors.append(message_path + ".relative_order:expected_contiguous_order")
	for content_ref in authored_by_ref:
		if not seen_refs.has(content_ref):
			errors.append("catalog.entries:missing_authored_content_ref:" + content_ref)
	return _result(errors)


func presentation_metadata() -> Dictionary:
	return _catalog["presentation_metadata"].duplicate(true)


func resolve(beat) -> Dictionary:
	if typeof(beat) != TYPE_DICTIONARY or beat.get("type") not in REFERENCED_TYPES:
		return _failure("UNSUPPORTED_BEAT_TYPE")
	var content_ref = beat.get("content", {}).get("content_ref")
	if not _entries_by_ref.has(content_ref):
		return _failure("UNRESOLVED_CONTENT_REF")
	var entry: Dictionary = _entries_by_ref[content_ref]
	if entry["beat_type"] != beat["type"]:
		return _failure("CONTENT_TYPE_MISMATCH")
	return {
		"ok": true,
		"error_code": null,
		"content": {
			"thread_id": entry["thread_id"],
			"messages": entry["messages"].duplicate(true),
		},
	}


static func _exact(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _identifier(value) -> bool:
	return typeof(value) == TYPE_STRING and not value.is_empty() and value == value.strip_edges()


static func _result(errors: Array) -> Dictionary:
	return {"valid": errors.is_empty(), "errors": errors.duplicate()}


static func _failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "content": {}}
