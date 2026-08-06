extends RefCounted

class_name R8CSequenceResolutionEventV1

const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")

const EVENT_TYPE := "R8C_A1_SEQUENCE_RESOLUTION_V1"
const FIELDS := ["event_id", "event_type", "provenance", "payload"]
const PROVENANCE_FIELDS := [
	"event_id",
	"source_scene_id",
	"source_scene_instance_id",
	"source_a10_choice_id",
	"source_a10_resolution_id",
	"source_sequence_id",
	"source_authored_version",
	"source_resolution_id",
	"moment_diegetique",
]
const PAYLOAD_FIELDS := [
	"facts",
	"knowledge",
	"traces",
	"promises",
	"obligations",
	"media_deliveries",
]
const MAX_STRING_LENGTH := 512


static func build(
	instance_snapshot: Dictionary,
	definition: Dictionary,
	envelope: Dictionary,
	moment_diegetique: String
) -> Dictionary:
	var manifest: Dictionary = definition["resolutions"][envelope["a10_resolution_id"]]["durable_manifest"]
	var binding: Dictionary = manifest["binding"]
	var event_id := event_id_for(instance_snapshot["instance_id"], envelope["a10_resolution_id"])
	var payload := {}
	for category in PAYLOAD_FIELDS:
		payload[category] = manifest[category].duplicate(true)
	var event := {
		"event_id": event_id,
		"event_type": EVENT_TYPE,
		"provenance": {
			"event_id": event_id,
			"source_scene_id": definition["scene_id"],
			"source_scene_instance_id": instance_snapshot["instance_id"],
			"source_a10_choice_id": envelope["a10_choice_id"],
			"source_a10_resolution_id": envelope["a10_resolution_id"],
			"source_sequence_id": binding["sequence_id"],
			"source_authored_version": binding["authored_version"],
			"source_resolution_id": binding["resolution_id"],
			"moment_diegetique": moment_diegetique,
		},
		"payload": payload,
	}
	return event if validate(event) else {}


static func event_id_for(scene_instance_id: String, a10_resolution_id: String) -> String:
	return "r8c-a1:%s:sequence-resolution:%s" % [scene_instance_id, a10_resolution_id]


static func validate(value) -> bool:
	if typeof(value) != TYPE_DICTIONARY or not _exact(value, FIELDS):
		return false
	var event: Dictionary = value
	if event["event_type"] != EVENT_TYPE or not _valid_string(event["event_id"]):
		return false
	var provenance = event["provenance"]
	if typeof(provenance) != TYPE_DICTIONARY or not _exact(provenance, PROVENANCE_FIELDS):
		return false
	for field in PROVENANCE_FIELDS:
		if not _valid_string(provenance[field]):
			return false
	if (
		provenance["event_id"] != event["event_id"]
		or event["event_id"] != event_id_for(
			provenance["source_scene_instance_id"], provenance["source_a10_resolution_id"]
		)
		or not _strict_semver(provenance["source_authored_version"])
		or not DefinitionModele.moment_normalise_valide(provenance["moment_diegetique"])
	):
		return false
	var payload = event["payload"]
	if typeof(payload) != TYPE_DICTIONARY or not _exact(payload, PAYLOAD_FIELDS):
		return false
	for category in PAYLOAD_FIELDS:
		if typeof(payload[category]) != TYPE_ARRAY or not _structural_value(payload[category]):
			return false
	return true


static func event_keys(event: Dictionary) -> Array:
	var keys: Array = []
	for category in PAYLOAD_FIELDS:
		for effect in event["payload"][category]:
			keys.append(effect.get("event_key"))
	return keys


static func structures_identical(left, right) -> bool:
	if typeof(left) != typeof(right):
		return false
	if typeof(left) == TYPE_DICTIONARY:
		if left.size() != right.size():
			return false
		for key in left:
			if not right.has(key) or not structures_identical(left[key], right[key]):
				return false
		return true
	if typeof(left) == TYPE_ARRAY:
		if left.size() != right.size():
			return false
		for index in left.size():
			if not structures_identical(left[index], right[index]):
				return false
		return true
	return left == right


static func _exact(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _valid_string(value) -> bool:
	return (
		typeof(value) == TYPE_STRING
		and not value.is_empty()
		and value == value.strip_edges()
		and value.length() <= MAX_STRING_LENGTH
	)


static func _strict_semver(value: String) -> bool:
	var parts := value.split(".", false)
	if parts.size() != 3:
		return false
	for part in parts:
		if not part.is_valid_int() or int(part) < 0 or (part.length() > 1 and part.begins_with("0")):
			return false
	return true


static func _structural_value(value) -> bool:
	match typeof(value):
		TYPE_NIL, TYPE_BOOL, TYPE_INT, TYPE_FLOAT, TYPE_STRING:
			return true
		TYPE_ARRAY:
			for item in value:
				if not _structural_value(item):
					return false
			return true
		TYPE_DICTIONARY:
			for key in value:
				if typeof(key) != TYPE_STRING or not _structural_value(value[key]):
					return false
			return true
		_:
			return false
