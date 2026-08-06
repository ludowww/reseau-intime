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
const FACT_RELATION_FIELDS := ["event_key", "scope", "personnage_id", "fact"]
const FACT_CENTRAL_FIELDS := ["event_key", "scope", "fact"]
const KNOWLEDGE_FIELDS := ["event_key", "effect", "knowledge_id", "subject_id", "holder_ids"]
const TRACE_CREATE_FIELDS := [
	"event_key", "effect", "trace_id", "creator_id", "audience_ids", "controller_ids", "accessible_to_ids",
]
const TRACE_ACCESS_FIELDS := ["event_key", "effect", "trace_id", "accessible_to_ids"]
const TRACE_TERMINAL_FIELDS := ["event_key", "effect", "trace_id"]
const PROMISE_CREATE_FIELDS := [
	"event_key", "effect", "promise_id", "author_id", "beneficiary_ids", "content_ref",
]
const PROMISE_TERMINAL_FIELDS := ["event_key", "effect", "promise_id"]
const OBLIGATION_CREATE_FIELDS := [
	"event_key", "effect", "obligation_id", "debtor_id", "beneficiary_ids", "kind",
]
const OBLIGATION_TERMINAL_FIELDS := ["event_key", "effect", "obligation_id"]
const MEDIA_CREATE_FIELDS := ["event_key", "effect", "media_id", "fictional_audience_ids"]
const MEDIA_GRANT_FIELDS := [
	"event_key", "effect", "media_id", "diegetic_status", "fictional_audience_ids", "gallery_status",
]
const MEDIA_TERMINAL_FIELDS := ["event_key", "effect", "media_id"]
const FACT_FIELDS := ["fait_id", "nature", "recu_par", "permission_future", "formulee_par"]
const MAX_DURABLE_IDENTIFIER_LENGTH := 96
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
	if not _structural_value(payload):
		return false
	for category in PAYLOAD_FIELDS:
		if typeof(payload[category]) != TYPE_ARRAY:
			return false
	var seen_event_keys := {}
	return (
		_validate_facts(payload["facts"], seen_event_keys)
		and _validate_knowledge(payload["knowledge"], seen_event_keys)
		and _validate_traces(payload["traces"], seen_event_keys)
		and _validate_promises(payload["promises"], seen_event_keys)
		and _validate_obligations(payload["obligations"], seen_event_keys)
		and _validate_media_deliveries(payload["media_deliveries"], seen_event_keys)
	)


static func event_keys(event: Dictionary) -> Array:
	var keys: Array = []
	if not validate(event):
		return keys
	for category in PAYLOAD_FIELDS:
		for effect in event["payload"][category]:
			keys.append(effect["event_key"])
	return keys


static func _validate_facts(entries: Array, seen_event_keys: Dictionary) -> bool:
	var seen_business_ids := {}
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			return false
		var entry: Dictionary = value
		var fields: Array = []
		if entry.get("scope") == "RELATION":
			fields = FACT_RELATION_FIELDS
		elif entry.get("scope") == "RELATION_CENTRALE":
			fields = FACT_CENTRAL_FIELDS
		if fields.is_empty() or not _exact(entry, fields):
			return false
		var fact = entry["fact"]
		if typeof(fact) != TYPE_DICTIONARY:
			return false
		if not fact.has("fait_id") or not _allowed(fact, FACT_FIELDS):
			return false
		if not _register_identifiers(
			entry["event_key"], fact["fait_id"], seen_event_keys, seen_business_ids
		):
			return false
		if entry["scope"] == "RELATION" and not _valid_durable_identifier(entry["personnage_id"]):
			return false
		for field in fact:
			if field == "permission_future":
				if typeof(fact[field]) != TYPE_BOOL:
					return false
			elif field == "fait_id":
				if not _valid_durable_identifier(fact[field]):
					return false
			elif not _valid_durable_string(fact[field]):
				return false
	return true


static func _validate_knowledge(entries: Array, seen_event_keys: Dictionary) -> bool:
	var seen_business_ids := {}
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			return false
		var entry: Dictionary = value
		if entry.get("effect") != "ACQUIRE" or not _exact(entry, KNOWLEDGE_FIELDS):
			return false
		if not _register_identifiers(
			entry["event_key"], entry["knowledge_id"], seen_event_keys, seen_business_ids
		):
			return false
		if (
			not _valid_durable_identifier(entry["subject_id"])
			or not _valid_identifier_array(entry["holder_ids"], true)
		):
			return false
	return true


static func _validate_traces(entries: Array, seen_event_keys: Dictionary) -> bool:
	var seen_business_ids := {}
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			return false
		var entry: Dictionary = value
		var effect = entry.get("effect")
		var fields: Array = []
		if effect == "CREATE":
			fields = TRACE_CREATE_FIELDS
		elif effect in ["GRANT_ACCESS", "REVOKE_ACCESS"]:
			fields = TRACE_ACCESS_FIELDS
		elif effect == "WITHDRAW":
			fields = TRACE_TERMINAL_FIELDS
		if fields.is_empty() or not _exact(entry, fields):
			return false
		if not _register_identifiers(
			entry["event_key"], entry["trace_id"], seen_event_keys, seen_business_ids
		):
			return false
		if effect == "CREATE":
			if not _valid_durable_identifier(entry["creator_id"]):
				return false
			for field in ["audience_ids", "controller_ids", "accessible_to_ids"]:
				if not _valid_identifier_array(entry[field], false):
					return false
		elif effect in ["GRANT_ACCESS", "REVOKE_ACCESS"]:
			if not _valid_identifier_array(entry["accessible_to_ids"], true):
				return false
	return true


static func _validate_promises(entries: Array, seen_event_keys: Dictionary) -> bool:
	var seen_business_ids := {}
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			return false
		var entry: Dictionary = value
		var effect = entry.get("effect")
		var fields: Array = []
		if effect == "CREATE":
			fields = PROMISE_CREATE_FIELDS
		elif effect in ["PAY", "FAIL"]:
			fields = PROMISE_TERMINAL_FIELDS
		if fields.is_empty() or not _exact(entry, fields):
			return false
		if not _register_identifiers(
			entry["event_key"], entry["promise_id"], seen_event_keys, seen_business_ids
		):
			return false
		if effect == "CREATE" and (
			not _valid_durable_identifier(entry["author_id"])
			or not _valid_identifier_array(entry["beneficiary_ids"], true)
			or not _valid_durable_string(entry["content_ref"])
		):
			return false
	return true


static func _validate_obligations(entries: Array, seen_event_keys: Dictionary) -> bool:
	var seen_business_ids := {}
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			return false
		var entry: Dictionary = value
		var effect = entry.get("effect")
		var fields: Array = []
		if effect == "CREATE_DUE":
			fields = OBLIGATION_CREATE_FIELDS
		elif effect in ["PAY", "FAIL"]:
			fields = OBLIGATION_TERMINAL_FIELDS
		if fields.is_empty() or not _exact(entry, fields):
			return false
		if not _register_identifiers(
			entry["event_key"], entry["obligation_id"], seen_event_keys, seen_business_ids
		):
			return false
		if effect == "CREATE_DUE" and (
			not _valid_durable_identifier(entry["debtor_id"])
			or not _valid_identifier_array(entry["beneficiary_ids"], true)
			or not _valid_durable_string(entry["kind"])
		):
			return false
	return true


static func _validate_media_deliveries(entries: Array, seen_event_keys: Dictionary) -> bool:
	var seen_business_ids := {}
	for value in entries:
		if typeof(value) != TYPE_DICTIONARY:
			return false
		var entry: Dictionary = value
		var effect = entry.get("effect")
		var fields: Array = []
		if effect == "CREATE_DIEGETIC":
			fields = MEDIA_CREATE_FIELDS
		elif effect == "GRANT_ACCESS":
			fields = MEDIA_GRANT_FIELDS
		elif effect in ["REVOKE_ACCESS", "WITHDRAW"]:
			fields = MEDIA_TERMINAL_FIELDS
		if fields.is_empty() or not _exact(entry, fields):
			return false
		if not _register_identifiers(
			entry["event_key"], entry["media_id"], seen_event_keys, seen_business_ids
		):
			return false
		if effect in ["CREATE_DIEGETIC", "GRANT_ACCESS"] and not _valid_identifier_array(
			entry["fictional_audience_ids"], false
		):
			return false
		if effect == "GRANT_ACCESS" and (
			entry["diegetic_status"] not in ["CREATED", "NOT_APPLICABLE"]
			or entry["gallery_status"] not in ["HIDDEN", "AVAILABLE"]
		):
			return false
	return true


static func _register_identifiers(
	event_key,
	business_id,
	seen_event_keys: Dictionary,
	seen_business_ids: Dictionary
) -> bool:
	if (
		not _valid_durable_identifier(event_key)
		or seen_event_keys.has(event_key)
		or not _valid_durable_identifier(business_id)
		or seen_business_ids.has(business_id)
	):
		return false
	seen_event_keys[event_key] = true
	seen_business_ids[business_id] = true
	return true


static func _valid_identifier_array(value, require_non_empty: bool) -> bool:
	if typeof(value) != TYPE_ARRAY or (require_non_empty and value.is_empty()):
		return false
	var seen := {}
	for identifier in value:
		if not _valid_durable_identifier(identifier) or seen.has(identifier):
			return false
		seen[identifier] = true
	return true


static func _valid_durable_identifier(value) -> bool:
	if (
		typeof(value) != TYPE_STRING
		or value.is_empty()
		or value.length() > MAX_DURABLE_IDENTIFIER_LENGTH
		or value != value.strip_edges()
	):
		return false
	for index in value.length():
		if value.substr(index, 1) not in "abcdefghijklmnopqrstuvwxyz0123456789_":
			return false
	var parts: PackedStringArray = value.to_lower().split("_", false)
	for index in parts.size():
		var part: String = parts[index]
		if part.length() == 3 and part.begins_with("j") and part.substr(1, 2).is_valid_int():
			return false
		if part == "chapter" and index + 1 < parts.size():
			var number: String = parts[index + 1]
			if number.length() == 2 and number.is_valid_int():
				return false
	return true


static func _valid_durable_string(value) -> bool:
	return (
		typeof(value) == TYPE_STRING
		and not value.is_empty()
		and value == value.strip_edges()
		and value.length() <= MAX_STRING_LENGTH
	)


static func _allowed(value: Dictionary, fields: Array) -> bool:
	for field in value:
		if field not in fields:
			return false
	return true


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
