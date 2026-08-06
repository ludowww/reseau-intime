extends Node

const EtatNarratifModel := preload("res://scripts/narrative_state/EtatNarratif.gd")
const Codec := preload("res://scripts/narrative_scene/A5NarrativeStateCodec.gd")
const Reducer := preload("res://scripts/narrative_state/ReducerResolutionSequence.gd")

func _ready() -> void:
	var source := EtatNarratifModel.creer_synthetique({"statut_couple":"SEPARES","relation_apres_separation":"BONS_TERMES","faits": []})
	if source == null:
		_fail("source")
		return
	var provenance := {"event_id":"synthetic_n14_1b_event","source_scene_id":"synthetic_scene","source_scene_instance_id":"synthetic_instance","source_a10_choice_id":"synthetic_choice","source_a10_resolution_id":"synthetic_resolution","source_sequence_id":"synthetic_sequence","source_authored_version":"1.0.0","source_resolution_id":"synthetic_resolution_id","moment_diegetique":"2032-03-04T10:30:00+01:00"}
	var payload := {"facts": [{"event_key":"synthetic_fact","scope":"RELATION_CENTRALE","fact":{"fait_id":"synthetic_fact","nature":"OBSERVATION","recu_par":"synthetic_holder","permission_future":true,"formulee_par":"synthetic_author"}}], "knowledge": [{"event_key":"synthetic_knowledge","effect":"ACQUIRE","knowledge_id":"synthetic_knowledge","subject_id":"synthetic_subject","holder_ids":["synthetic_holder"]}], "traces": [], "promises": [], "obligations": [], "media_deliveries": []}
	var before := source.obtenir_snapshot()
	var result := Reducer.preparer(before, payload, provenance)
	if not result.ok or result.statut != "APPLIQUE" or not Codec.valider(result.candidat) or before != source.obtenir_snapshot():
		_fail("empty candidate")
		return
	var replay := Reducer.preparer(result.candidat, payload, provenance)
	if not replay.ok or replay.statut != "IDEMPOTENT":
		_fail("idempotence")
		return
	var bad := payload.duplicate(true); bad["unknown"] = []
	if Reducer.preparer(before, bad, provenance).ok:
		_fail("closed payload")
		return
	print("R8C_N14_1B_DURABLE_REDUCERS: OK (candidate, order, closure, idempotence)")
	get_tree().quit(0)

func _fail(reason: String) -> void:
	push_error("R8C_N14_1B_DURABLE_REDUCERS: KO (%s)" % reason)
	get_tree().quit(1)
