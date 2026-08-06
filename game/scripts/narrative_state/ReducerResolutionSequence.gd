extends RefCounted

class_name ReducerResolutionSequence

const Codec := preload("res://scripts/narrative_scene/A5NarrativeStateCodec.gd")
const Definition := preload("res://scripts/narrative_scene/SceneDefinition.gd")
const Facts := preload("res://scripts/narrative_state/ReducerRelation.gd")
const Knowledge := preload("res://scripts/narrative_state/ReducerConnaissance.gd")
const Traces := preload("res://scripts/narrative_state/ReducerTraceNarrative.gd")
const Promises := preload("res://scripts/narrative_state/ReducerPromesse.gd")
const Obligations := preload("res://scripts/narrative_state/ReducerObligation.gd")
const Media := preload("res://scripts/narrative_state/ReducerLivraisonMedia.gd")

const ROOTS := ["facts", "knowledge", "traces", "promises", "obligations", "media_deliveries"]
const BUSINESS_ID_FIELDS := {
	"facts": "fait_id",
	"knowledge": "knowledge_id",
	"traces": "trace_id",
	"promises": "promise_id",
	"obligations": "obligation_id",
	"media_deliveries": "media_id",
}
const PROVENANCE := [
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
const MAX_STRING_LENGTH := 512


static func preparer(etat_source, payload, provenance) -> Dictionary:
	if not _strict_v2_state(etat_source):
		return _reject("etat source v2 strict invalide")
	if not Codec.valider(etat_source):
		return _reject("etat source invalide")
	var payload_error := _validate_payload(payload)
	if not payload_error.is_empty():
		return _reject(payload_error)
	if not _valid_provenance(provenance):
		return _reject("provenance invalide")

	var candidate: Dictionary = etat_source.duplicate(true)
	var status := "IDEMPOTENT"
	var result := Facts.preparer_faits(candidate, payload["facts"], provenance)
	if not result["ok"]:
		return _reject(result["erreur"])
	if result["statut"] == "APPLIQUE":
		status = "APPLIQUE"

	result = Knowledge.preparer_mutations(candidate, payload["knowledge"], provenance)
	if not result["ok"]:
		return _reject(result["erreur"])
	if result["statut"] == "APPLIQUE":
		status = "APPLIQUE"

	result = Traces.preparer_mutations(candidate, payload["traces"], provenance)
	if not result["ok"]:
		return _reject(result["erreur"])
	if result["statut"] == "APPLIQUE":
		status = "APPLIQUE"

	result = Promises.preparer_mutations(candidate, payload["promises"], provenance)
	if not result["ok"]:
		return _reject(result["erreur"])
	if result["statut"] == "APPLIQUE":
		status = "APPLIQUE"

	result = Obligations.preparer_mutations(candidate, payload["obligations"], provenance)
	if not result["ok"]:
		return _reject(result["erreur"])
	if result["statut"] == "APPLIQUE":
		status = "APPLIQUE"

	result = Media.preparer_mutations(candidate, payload["media_deliveries"], provenance)
	if not result["ok"]:
		return _reject(result["erreur"])
	if result["statut"] == "APPLIQUE":
		status = "APPLIQUE"

	if not Codec.valider(candidate):
		return _reject("candidat durable invalide")
	return {"ok": true, "statut": status, "erreur": "", "candidat": candidate.duplicate(true)}


static func _strict_v2_state(state) -> bool:
	return (
		typeof(state) == TYPE_DICTIONARY
		and _exact(state, Codec.CHAMPS_ETAT)
		and typeof(state.get("format_version")) == TYPE_INT
		and state["format_version"] == 2
	)


static func _validate_payload(payload) -> String:
	if typeof(payload) != TYPE_DICTIONARY or not _exact(payload, ROOTS):
		return "payload durable invalide"
	var event_keys := {}
	var total_effects := 0
	for category in ROOTS:
		var effects = payload[category]
		if typeof(effects) != TYPE_ARRAY:
			return "categorie durable invalide: %s" % category
		total_effects += effects.size()
		var business_ids := {}
		for item in effects:
			if typeof(item) != TYPE_DICTIONARY:
				return "effet durable invalide: %s" % category
			var event_key = item.get("event_key")
			if not _valid_string(event_key):
				return "event_key invalide"
			if event_keys.has(event_key):
				return "event_key duplique: %s" % event_key
			event_keys[event_key] = true
			var business_id = _business_id(category, item)
			if not _valid_string(business_id):
				return "identifiant metier invalide: %s" % category
			if business_ids.has(business_id):
				return "identifiant metier duplique: %s" % business_id
			business_ids[business_id] = true
	if total_effects == 0:
		return "payload durable vide"
	return ""


static func _business_id(category: String, item: Dictionary):
	if category == "facts":
		var fact = item.get("fact")
		if typeof(fact) != TYPE_DICTIONARY:
			return null
		return fact.get(BUSINESS_ID_FIELDS[category])
	return item.get(BUSINESS_ID_FIELDS[category])


static func _valid_provenance(value) -> bool:
	if typeof(value) != TYPE_DICTIONARY or not _exact(value, PROVENANCE):
		return false
	for field in PROVENANCE:
		if not _valid_string(value[field]):
			return false
	return (
		_strict_semver(value["source_authored_version"])
		and Definition.moment_normalise_valide(value["moment_diegetique"])
	)


static func _strict_semver(value: String) -> bool:
	var parts := value.split(".", false)
	if parts.size() != 3:
		return false
	for part in parts:
		if part.is_empty() or (part.length() > 1 and part.begins_with("0")):
			return false
		for index in part.length():
			if part.substr(index, 1) not in "0123456789":
				return false
	return true


static func _valid_string(value) -> bool:
	return (
		typeof(value) == TYPE_STRING
		and not value.is_empty()
		and value == value.strip_edges()
		and value.length() <= MAX_STRING_LENGTH
	)


static func _exact(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _reject(message: String) -> Dictionary:
	return {"ok": false, "statut": "REJETE", "erreur": message, "candidat": {}}
