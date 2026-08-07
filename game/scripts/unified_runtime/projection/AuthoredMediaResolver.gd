extends RefCounted

class_name R8CAuthoredMediaResolver

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const CATALOG_FIELDS := ["sequence_id", "authored_version", "entries"]
const ENTRY_FIELDS := [
	"media_id", "visual_ref", "display_name", "context_label", "caption", "placeholder_label",
]
const DISPLAY_LOADED := "LOADED"
const DISPLAY_NOT_DELIVERED := "NOT_DELIVERED"
const NOT_DELIVERED_LABEL := "Visuel non livré"

var _sequence_id := ""
var _authored_version := ""
var _media_by_id: Dictionary = {}
var _entries_by_id: Dictionary = {}


static func create(authored_sequence, presentation_catalog_or_assets) -> Dictionary:
	if (
		typeof(authored_sequence) != TYPE_DICTIONARY
		or not AuthoredValidator.validate(authored_sequence)["valid"]
	):
		return _creation_failure("INVALID_AUTHORED_SEQUENCE")
	var catalog_error := _validate_catalog(presentation_catalog_or_assets)
	if not catalog_error.is_empty():
		return _creation_failure(catalog_error)
	if presentation_catalog_or_assets["sequence_id"] != authored_sequence["sequence_id"]:
		return _creation_failure("SEQUENCE_ID_MISMATCH")
	if presentation_catalog_or_assets["authored_version"] != authored_sequence["authored_version"]:
		return _creation_failure("AUTHORED_VERSION_MISMATCH")
	var resolver := new()
	resolver._sequence_id = authored_sequence["sequence_id"]
	resolver._authored_version = authored_sequence["authored_version"]
	resolver._media_by_id = authored_sequence["media"].duplicate(true)
	for entry in presentation_catalog_or_assets["entries"]:
		if not resolver._media_by_id.has(entry["media_id"]):
			return _creation_failure("UNKNOWN_CATALOG_MEDIA")
		resolver._entries_by_id[entry["media_id"]] = entry.duplicate(true)
	return {"ok": true, "error_code": null, "resolver": resolver}


func resolve(media_id: String) -> Dictionary:
	return _resolve(media_id, false)


func resolve_thumbnail(media_id: String, accessible_child_ids: Array = []) -> Dictionary:
	if not _media_by_id.has(media_id):
		return _resolution_failure("UNKNOWN_MEDIA")
	var media: Dictionary = _media_by_id[media_id]
	match media["thumbnail_policy"]:
		"SELF":
			return _resolve(media_id, true)
		"REUSE_MEDIA":
			var thumbnail_id = media["thumbnail_media_id"]
			if typeof(thumbnail_id) != TYPE_STRING or thumbnail_id.is_empty():
				return _resolution_failure("INVALID_THUMBNAIL_REFERENCE")
			return _resolve(thumbnail_id, true)
		"DERIVE_FIRST_ACCESSIBLE_CHILD":
			for child_id in accessible_child_ids:
				if not _media_by_id.has(child_id):
					return _resolution_failure("INVALID_THUMBNAIL_REFERENCE")
				if _media_by_id[child_id]["parent_media_id"] == media_id:
					return _resolve(child_id, true)
			return _resolution_failure("UNRESOLVED_THUMBNAIL")
		_:
			return _resolution_failure("INVALID_THUMBNAIL_POLICY")


func media_definition(media_id: String) -> Dictionary:
	return _media_by_id[media_id].duplicate(true) if _media_by_id.has(media_id) else {}


func media_ids() -> Array:
	var ids: Array = _media_by_id.keys()
	ids.sort()
	return ids


func catalog_identity() -> Dictionary:
	return {"sequence_id": _sequence_id, "authored_version": _authored_version}


func _resolve(media_id: String, allow_derived: bool) -> Dictionary:
	if not _media_by_id.has(media_id):
		return _resolution_failure("UNKNOWN_MEDIA")
	var media: Dictionary = _media_by_id[media_id]
	var production_status := str(media["production_status"])
	if production_status == "DERIVED_OR_REUSED_NOT_SEPARATELY_PRODUCED" and not allow_derived:
		return _resolution_failure("MEDIA_NOT_AUTONOMOUS")
	if production_status == "SPECIFIED_NOT_PRODUCED":
		return _resolution_success(media, {}, null, DISPLAY_NOT_DELIVERED)
	if production_status not in ["PRODUCED", "VALIDATED", "DERIVED_OR_REUSED_NOT_SEPARATELY_PRODUCED"]:
		return _resolution_failure("INVALID_PRODUCTION_STATUS")
	if not _entries_by_id.has(media_id):
		return _resolution_failure("MISSING_PRESENTATION_ASSET")
	var entry: Dictionary = _entries_by_id[media_id]
	if entry["media_id"] != media_id:
		return _resolution_failure("MEDIA_IDENTITY_MISMATCH")
	var visual_ref := str(entry["visual_ref"])
	if not visual_ref.begins_with("res://") or not ResourceLoader.exists(visual_ref, "Texture2D"):
		return _resolution_failure("INVALID_PRESENTATION_ASSET")
	var texture = ResourceLoader.load(visual_ref, "Texture2D")
	if not texture is Texture2D:
		return _resolution_failure("INVALID_PRESENTATION_ASSET")
	return _resolution_success(media, entry, texture, DISPLAY_LOADED)


func _resolution_success(
	media: Dictionary,
	entry: Dictionary,
	texture,
	display_status: String,
) -> Dictionary:
	var media_id := str(media["media_id"])
	return {
		"ok": true,
		"error_code": null,
		"presentation": {
			"media_id": media_id,
			"production_status": media["production_status"],
			"visual_ref": str(entry.get("visual_ref", "")),
			"texture": texture,
			"display_status": display_status,
			"status_label": NOT_DELIVERED_LABEL if display_status == DISPLAY_NOT_DELIVERED else "",
			"visual_level": media["visual_level"],
			"diegesis": media["diegesis"],
			"display_name": str(entry.get("display_name", media_id)),
			"context_label": str(entry.get("context_label", "")),
			"caption": str(entry.get("caption", "")),
			"placeholder_label": str(entry.get("placeholder_label", NOT_DELIVERED_LABEL)),
		},
	}


static func _validate_catalog(value) -> String:
	if typeof(value) != TYPE_DICTIONARY or not _has_exact_fields(value, CATALOG_FIELDS):
		return "INVALID_PRESENTATION_CATALOG"
	if (
		typeof(value["sequence_id"]) != TYPE_STRING
		or value["sequence_id"].is_empty()
		or typeof(value["authored_version"]) != TYPE_STRING
		or value["authored_version"].is_empty()
		or typeof(value["entries"]) != TYPE_ARRAY
	):
		return "INVALID_PRESENTATION_CATALOG"
	var seen := {}
	for entry in value["entries"]:
		if typeof(entry) != TYPE_DICTIONARY or not _has_exact_fields(entry, ENTRY_FIELDS):
			return "INVALID_PRESENTATION_CATALOG"
		for field in ENTRY_FIELDS:
			if typeof(entry[field]) != TYPE_STRING:
				return "INVALID_PRESENTATION_CATALOG"
		var media_id: String = entry["media_id"]
		if media_id.is_empty() or seen.has(media_id):
			return "INVALID_PRESENTATION_CATALOG"
		seen[media_id] = true
	return ""


static func _has_exact_fields(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _creation_failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "resolver": null}


func _resolution_failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "presentation": {}}
