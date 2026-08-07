extends RefCounted

class_name R8CDurableGalleryProjection

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const RECORD_FIELDS := [
	"media_id", "diegetic_status", "fictional_audience_ids", "access_status", "gallery_status",
	"withdrawal_status", "provenance",
]
const RESOLVER_METHODS := [
	"catalog_identity", "media_definition", "media_ids", "resolve", "resolve_thumbnail",
]
const DEFAULT_ACCENT := Color(0.78, 0.38, 0.72)

var _authored_sequence: Dictionary = {}
var _livraison_medias: Dictionary = {}
var _resolver


static func create(authored_sequence, livraison_medias, resolver) -> Dictionary:
	if (
		typeof(authored_sequence) != TYPE_DICTIONARY
		or not AuthoredValidator.validate(authored_sequence)["valid"]
	):
		return _creation_failure("INVALID_AUTHORED_SEQUENCE")
	if typeof(livraison_medias) != TYPE_DICTIONARY:
		return _creation_failure("INVALID_DURABLE_MEDIA_REGISTRY")
	if resolver == null or typeof(resolver) != TYPE_OBJECT:
		return _creation_failure("INVALID_MEDIA_RESOLVER")
	for method_name in RESOLVER_METHODS:
		if not resolver.has_method(method_name):
			return _creation_failure("INVALID_MEDIA_RESOLVER")
	var identity: Dictionary = resolver.catalog_identity()
	if (
		identity.get("sequence_id") != authored_sequence["sequence_id"]
		or identity.get("authored_version") != authored_sequence["authored_version"]
	):
		return _creation_failure("RESOLVER_IDENTITY_MISMATCH")
	for media_id in livraison_medias:
		if not _valid_record(media_id, livraison_medias[media_id]):
			return _creation_failure("INVALID_DURABLE_MEDIA_REGISTRY")
	var projection := new()
	projection._authored_sequence = authored_sequence.duplicate(true)
	projection._livraison_medias = livraison_medias.duplicate(true)
	projection._resolver = resolver
	return {"ok": true, "error_code": null, "projection": projection}


func content_source() -> Dictionary:
	var fixtures := {}
	var character_order: Array[String] = []
	var children_by_id := {}
	var accessible_ids: Array = []
	for media_id in _livraison_medias:
		var record: Dictionary = _livraison_medias[media_id]
		if _is_gallery_accessible(record):
			accessible_ids.append(media_id)
	accessible_ids = _ordered_media_ids(accessible_ids)
	var root_ids: Array = []
	for media_id in accessible_ids:
		var candidate_definition: Dictionary = _resolver.media_definition(media_id)
		if candidate_definition.is_empty():
			return _source_failure("UNKNOWN_AUTHORED_MEDIA")
		if candidate_definition.get("parent_media_id") == null:
			root_ids.append(media_id)
	for media_id in accessible_ids:
		var candidate_definition: Dictionary = _resolver.media_definition(media_id)
		if candidate_definition.get("parent_media_id") != null and candidate_definition["parent_media_id"] not in root_ids:
			return _source_failure("ORPHAN_ACCESSIBLE_MEDIA")
	for index in root_ids.size():
		var media_id: String = root_ids[index]
		var definition: Dictionary = _resolver.media_definition(media_id)
		if definition.is_empty():
			return _source_failure("UNKNOWN_AUTHORED_MEDIA")
		if definition["gallery_policy"] == "NEVER":
			return _source_failure("AVAILABLE_MEDIA_FORBIDDEN_BY_GALLERY_POLICY")
		var full: Dictionary = _resolver.resolve(media_id)
		if not bool(full.get("ok", false)):
			return _source_failure(str(full.get("error_code", "MEDIA_RESOLUTION_FAILED")))
		var full_presentation: Dictionary = full["presentation"]
		var gallery_character_ids: Array = full_presentation["gallery_character_ids"]
		if gallery_character_ids.is_empty():
			return _source_failure("MISSING_GALLERY_CHARACTER_IDS")
		var child_ids: Array = []
		for candidate_id in accessible_ids:
			var candidate: Dictionary = _resolver.media_definition(candidate_id)
			if candidate.get("parent_media_id") == media_id:
				if candidate.get("gallery_policy") == "NEVER":
					return _source_failure("AVAILABLE_MEDIA_FORBIDDEN_BY_GALLERY_POLICY")
				child_ids.append(candidate_id)
		if not child_ids.is_empty() and gallery_character_ids.size() != 1:
			return _source_failure("SEQUENCED_MEDIA_REQUIRES_SINGLE_GALLERY_CHARACTER")
		var thumbnail: Dictionary = _resolver.resolve_thumbnail(media_id, child_ids)
		if not bool(thumbnail.get("ok", false)):
			return _source_failure(str(thumbnail.get("error_code", "THUMBNAIL_RESOLUTION_FAILED")))
		var thumbnail_presentation: Dictionary = thumbnail["presentation"]
		for character_id in gallery_character_ids:
			if not fixtures.has(character_id):
				fixtures[character_id] = {
					"display_name": _display_name_for(character_id),
					"accent_color": DEFAULT_ACCENT,
					"items": [],
				}
				character_order.append(character_id)
			var item := {
				"item_id": media_id,
				"asset_id": media_id,
				"character_id": character_id,
				"state": "UNLOCKED",
				"is_new": true,
				"thumbnail_label": full_presentation["display_name"],
				"thumbnail_ref": thumbnail_presentation["visual_ref"],
				"full_ref": full_presentation["visual_ref"],
				"sort_key": index,
				"placeholder_label": full_presentation["placeholder_label"],
				"resolved_thumbnail": _viewer_resolution(thumbnail_presentation),
				"resolved_media": _viewer_resolution(full_presentation),
			}
			if not child_ids.is_empty():
				var sequence_child_ids: Array = [media_id]
				sequence_child_ids.append_array(child_ids)
				item["sequence_child_ids"] = sequence_child_ids
				for sequence_child_id in sequence_child_ids:
					var child_result: Dictionary = _resolver.resolve(sequence_child_id)
					if not bool(child_result.get("ok", false)):
						return _source_failure(str(child_result.get("error_code", "MEDIA_RESOLUTION_FAILED")))
					var child_presentation: Dictionary = child_result["presentation"]
					children_by_id[sequence_child_id] = {
						"asset_id": sequence_child_id,
						"parent_asset_id": media_id,
						"character_id": character_id,
						"source_kind": "gallery",
						"full_ref": child_presentation["visual_ref"],
						"placeholder_label": child_presentation["placeholder_label"],
						"resolved_media": _viewer_resolution(child_presentation),
					}
			fixtures[character_id]["items"].append(item)
	character_order.sort()
	return {
		"ok": true,
		"error_code": null,
		"source": {
			"fixtures": fixtures,
			"character_order": character_order,
			"children_by_id": children_by_id,
			"empty_label": "Aucun média accessible",
		},
	}


func durable_registry_snapshot() -> Dictionary:
	return _livraison_medias.duplicate(true)


func _ordered_media_ids(accessible_ids: Array) -> Array:
	var authored_order := {}
	var index := 0
	for beat in _authored_sequence["beats"]:
		if beat.get("type") == "MEDIA_REVEAL":
			authored_order[beat["content"]["media_id"]] = index
			index += 1
	var result: Array = accessible_ids.duplicate()
	result.sort_custom(func(left, right):
		var left_order := int(authored_order.get(left, 1000000))
		var right_order := int(authored_order.get(right, 1000000))
		return left_order < right_order if left_order != right_order else str(left) < str(right)
	)
	return result


static func _is_gallery_accessible(record: Dictionary) -> bool:
	return (
		record["access_status"] == "ACCESSIBLE"
		and record["gallery_status"] == "AVAILABLE"
		and record["withdrawal_status"] == "ACTIVE"
	)


static func _valid_record(media_id, record) -> bool:
	if typeof(media_id) != TYPE_STRING or media_id.is_empty() or typeof(record) != TYPE_DICTIONARY:
		return false
	if record.size() != RECORD_FIELDS.size():
		return false
	for field in RECORD_FIELDS:
		if not record.has(field):
			return false
	if record["media_id"] != media_id:
		return false
	if record["diegetic_status"] not in ["NOT_APPLICABLE", "CREATED"]:
		return false
	if typeof(record["fictional_audience_ids"]) != TYPE_ARRAY:
		return false
	if record["access_status"] not in ["LOCKED", "ACCESSIBLE", "REVOKED"]:
		return false
	if record["gallery_status"] not in ["HIDDEN", "AVAILABLE"]:
		return false
	if record["withdrawal_status"] not in ["ACTIVE", "WITHDRAWN"]:
		return false
	if typeof(record["provenance"]) != TYPE_DICTIONARY:
		return false
	if record["gallery_status"] == "AVAILABLE" and record["access_status"] != "ACCESSIBLE":
		return false
	if record["withdrawal_status"] == "WITHDRAWN" and (
		record["gallery_status"] != "HIDDEN" or record["access_status"] == "ACCESSIBLE"
	):
		return false
	return true


static func _viewer_resolution(presentation: Dictionary) -> Dictionary:
	return {
		"status": presentation["display_status"],
		"status_label": presentation["status_label"],
		"texture": presentation["texture"],
	}


static func _display_name_for(identifier: String) -> String:
	return identifier.replace("_", " ").capitalize()


static func _creation_failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "projection": null}


func _source_failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "source": {}}
