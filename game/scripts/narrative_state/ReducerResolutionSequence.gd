extends RefCounted
class_name ReducerResolutionSequence

const Codec := preload("res://scripts/narrative_scene/A5NarrativeStateCodec.gd")
const Facts := preload("res://scripts/narrative_state/ReducerRelation.gd")
const Knowledge := preload("res://scripts/narrative_state/ReducerConnaissance.gd")
const Traces := preload("res://scripts/narrative_state/ReducerTraceNarrative.gd")
const Promises := preload("res://scripts/narrative_state/ReducerPromesse.gd")
const Obligations := preload("res://scripts/narrative_state/ReducerObligation.gd")
const Media := preload("res://scripts/narrative_state/ReducerLivraisonMedia.gd")
const ROOTS := ["facts", "knowledge", "traces", "promises", "obligations", "media_deliveries"]
const PROVENANCE := ["event_id", "source_scene_id", "source_scene_instance_id", "source_a10_choice_id", "source_a10_resolution_id", "source_sequence_id", "source_authored_version", "source_resolution_id", "moment_diegetique"]

static func preparer(etat_source, payload, provenance) -> Dictionary:
	if not Codec.valider(etat_source): return _reject("etat source invalide")
	if typeof(payload) != TYPE_DICTIONARY or not _exact(payload, ROOTS): return _reject("payload durable invalide")
	if not _valid_provenance(provenance): return _reject("provenance invalide")
	var c: Dictionary = etat_source.duplicate(true); var status := "IDEMPOTENT"
	var steps := [Facts.preparer_faits(c, payload.facts, provenance), Knowledge.preparer_mutations(c, payload.knowledge, provenance), Traces.preparer_mutations(c, payload.traces, provenance), Promises.preparer_mutations(c, payload.promises, provenance), Obligations.preparer_mutations(c, payload.obligations, provenance), Media.preparer_mutations(c, payload.media_deliveries, provenance)]
	for r in steps:
		if not r.ok: return _reject(r.erreur)
		if r.statut == "APPLIQUE": status = "APPLIQUE"
	if not Codec.valider(c): return _reject("candidat durable invalide")
	return {"ok":true,"statut":status,"erreur":"","candidat":c.duplicate(true)}

static func _valid_provenance(p) -> bool:
	if typeof(p) != TYPE_DICTIONARY or not _exact(p, PROVENANCE): return false
	for key in PROVENANCE:
		if typeof(p[key]) != TYPE_STRING or p[key].strip_edges().is_empty() or p[key].length() > 512: return false
	return true

static func _exact(d: Dictionary, keys: Array) -> bool:
	if d.size() != keys.size(): return false
	for key in keys:
		if not d.has(key): return false
	return true

static func _reject(message: String) -> Dictionary:
	return {"ok":false,"statut":"REJETE","erreur":message,"candidat":{}}
