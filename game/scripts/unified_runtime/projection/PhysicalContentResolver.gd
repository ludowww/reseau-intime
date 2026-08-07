extends RefCounted

class_name R8CPhysicalContentResolver

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const PhysicalCatalog := preload(
	"res://scripts/unified_runtime/contracts/PhysicalPresentationContentV1.gd"
)

var _sequence_id := ""
var _authored_version := ""
var _entries_by_ref: Dictionary = {}
var _choices_by_id: Dictionary = {}


static func create(authored_sequence, physical_catalog) -> Dictionary:
	if typeof(authored_sequence) != TYPE_DICTIONARY:
		return _creation_failure("INVALID_AUTHORED_SEQUENCE")
	if not AuthoredValidator.validate(authored_sequence)["valid"]:
		return _creation_failure("INVALID_AUTHORED_SEQUENCE")
	if typeof(physical_catalog) != TYPE_DICTIONARY:
		return _creation_failure("INVALID_PHYSICAL_CATALOG")
	if not PhysicalCatalog.validate(physical_catalog)["valid"]:
		return _creation_failure("INVALID_PHYSICAL_CATALOG")
	if physical_catalog["sequence_id"] != authored_sequence["sequence_id"]:
		return _creation_failure("SEQUENCE_ID_MISMATCH")
	if physical_catalog["authored_version"] != authored_sequence["authored_version"]:
		return _creation_failure("AUTHORED_VERSION_MISMATCH")
	var resolver := new()
	resolver._sequence_id = authored_sequence["sequence_id"]
	resolver._authored_version = authored_sequence["authored_version"]
	for entry in physical_catalog["entries"]:
		resolver._entries_by_ref[entry["content_ref"]] = entry.duplicate(true)
	for beat in authored_sequence["beats"]:
		if beat["type"] != "CHOICE":
			continue
		for choice in beat["content"]["choices"]:
			resolver._choices_by_id[choice["choice_id"]] = choice.duplicate(true)
	return {"ok": true, "error_code": null, "resolver": resolver}


func resolve_physical_beat(beat) -> Dictionary:
	if typeof(beat) != TYPE_DICTIONARY:
		return _resolution_failure("INVALID_PHYSICAL_BEAT")
	if beat.get("type") != "PHYSICAL_BEAT" or beat.get("projection_target") != "PHYSICAL":
		return _resolution_failure("INVALID_PHYSICAL_BEAT")
	var content = beat.get("content")
	if typeof(content) != TYPE_DICTIONARY:
		return _resolution_failure("INVALID_PHYSICAL_BEAT")
	var physical_beat_id = content.get("physical_beat_id")
	var content_ref = content.get("content_ref")
	var withdrawal_choice_ids = content.get("withdrawal_choice_ids")
	if (
		typeof(physical_beat_id) != TYPE_STRING
		or physical_beat_id.is_empty()
		or typeof(content_ref) != TYPE_STRING
		or content_ref.is_empty()
		or typeof(withdrawal_choice_ids) != TYPE_ARRAY
	):
		return _resolution_failure("INVALID_PHYSICAL_BEAT")
	if not _entries_by_ref.has(content_ref):
		return _resolution_failure("UNRESOLVED_CONTENT_REF")
	var seen := {}
	var withdrawal_actions: Array[Dictionary] = []
	for choice_id in withdrawal_choice_ids:
		if typeof(choice_id) != TYPE_STRING or choice_id.is_empty():
			return _resolution_failure("UNKNOWN_WITHDRAWAL_CHOICE")
		if seen.has(choice_id):
			return _resolution_failure("DUPLICATE_WITHDRAWAL_CHOICE")
		seen[choice_id] = true
		if not _choices_by_id.has(choice_id):
			return _resolution_failure("UNKNOWN_WITHDRAWAL_CHOICE")
		withdrawal_actions.append({
			"choice_id": choice_id,
			"text": _choices_by_id[choice_id]["text"],
		})
	var entry: Dictionary = _entries_by_ref[content_ref]
	return {
		"ok": true,
		"error_code": null,
		"presentation": {
			"physical_beat_id": physical_beat_id,
			"content_ref": content_ref,
			"title": entry["title"],
			"body": entry["body"],
			"steps": entry["steps"].duplicate(),
			"continue_label": entry["continue_label"],
			"withdrawal_actions": withdrawal_actions.duplicate(true),
		},
	}


func catalog_identity() -> Dictionary:
	return {"sequence_id": _sequence_id, "authored_version": _authored_version}


static func _creation_failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "resolver": null}


func _resolution_failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "presentation": {}}
