extends Node

const FacadeModele := preload("res://scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
const BibliothequeModele := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const MoteurModele := preload("res://scripts/narrative_scene/MinimalSceneEngine.gd")
const CoordinateurA7Modele := preload(
	"res://scripts/narrative_scene/CandidateReservationProposalCoordinator.gd"
)
const CoordinateurA8Modele := preload(
	"res://scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd"
)
const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")

const BUNDLE_PATH := "res://data/narrative_scenes/r8c_n5_sandra_blue_chairs_staged.json"
const SCENE_ID := "sandra_blue_chairs_definition"
const VARIANT_ID := "sandra_blue_chairs_canonical"
const CONTROL_SCENE_ID := "n5_smoke_control_definition"
const CONTROL_VARIANT_ID := "n5_smoke_control"
const TRACE_ID := "sandra_recontact_importance_received_understood"
const COMMON_TRACE_EVENT_ID := "r8c-n5:sandra-blue-chairs:common-resolution-trace"
const REQUIRED_EVENTS := [
	"sandra_recontact_reactivated",
	"sandra_first_complicity_restored",
	"sandra_shared_lunch_memory_available",
	"sandra_short_pause_after_recontact_elapsed",
]

var failures: Array[String] = []
var checks := 0


func _ready() -> void:
	_test_explicit_staged_bundle()
	_test_complete_a10_resolution_chain()
	_test_close_silently_before_proposal_and_j05_rule()
	_test_a9_hard_boundary_and_atomic_refusals()
	_test_prerequisite_and_incompatibility_refusals()
	if failures.is_empty():
		print("R8C-N5 Sandra blue chairs staged projection: OK (%d controles)" % checks)
		get_tree().quit(0)
	else:
		for failure in failures:
			push_error(failure)
		get_tree().quit(1)


func _test_explicit_staged_bundle() -> void:
	var loaded: Dictionary = BibliothequeModele.charger_depuis_json(BUNDLE_PATH)
	_expect(loaded.get("ok", false), "bundle staged charge par chemin explicite")
	if not loaded.get("ok", false):
		return
	var library = loaded["bibliotheque"]
	_expect(library.obtenir_ids_tries() == [SCENE_ID], "une seule definition staged")
	var definition: Dictionary = library.obtenir_definition(SCENE_ID)
	_expect(definition.get("scene_id") == SCENE_ID, "identite A6 stable")
	_expect(definition.get("nature") == "MODULAIRE", "nature A6 MODULAIRE")
	_expect(definition.get("politique_unicite") == "UNIQUE", "occurrence UNIQUE")
	_expect(
		definition["participants_requis"].map(
			func(participant): return participant["personnage_id"]
		) == ["player", "sandra"],
		"participants Player et Sandra",
	)
	_expect(
		definition["conditions_dures"]["evenements_requis"] == REQUIRED_EVENTS,
		"quatre prerequis A1 A3 discrets",
	)
	_expect(definition["choix"].size() == 2, "deux choix canoniques")
	_expect(
		definition["resolutions"].values().all(
			func(resolution): return resolution["portee_micro_signal"] == "LOCALE"
		),
		"deux signaux optionnels LOCALE",
	)
	_expect(
		definition["resolutions"].values().all(
			func(resolution): return (
				resolution["reception"] == "NON_PERSISTANTE"
				and resolution["faits_relationnels"].is_empty()
			)
		),
		"aucun evenement A1 durable specifique aux choix",
	)
	_expect(
		definition["choix"].map(func(choice): return choice["formulation"]) == [
			"Que ça m’avait manqué.",
			"Que nos agendas sont nuls.",
		],
		"formulations N2 exactes",
	)
	_expect(not definition.has("media") and not definition.has("messages"), "A6 sans metadata non representee")
	_expect(not definition.has("politique_non_resolution"), "aucune politique MISSED ou consequence manquee")


func _test_complete_a10_resolution_chain() -> void:
	var env := _environment()
	_expect(not env.is_empty(), "environnement staged A1 A6 A10 cree")
	if env.is_empty():
		return
	var context := _context("2030-04-12T16:30:00+02:00")
	var search: Dictionary = env["facade"].find_candidates(context)
	_expect(search.get("ok", false), "candidats trouves via facade")
	_expect(_candidate(search["candidats"], SCENE_ID).get("variant_id") == VARIANT_ID, "variante canonique trouvee")
	var composition: Dictionary = env["facade"].compose_slot(
		_slot_request(context, "n5_complete", search["candidats"], 90, "18:04")
	)
	_expect(composition.get("ok", false), "A8 A9 compose a 16:30")
	if not composition.get("ok", false):
		return
	_expect(
		composition["plan"]["windows"][0]["starts_at"] == "2030-04-12T16:30:00+02:00",
		"A9 commence a l ouverture",
	)
	_expect(
		composition["plan"]["windows"][0]["ends_at"] == "2030-04-12T18:00:00+02:00",
		"A9 finit avant 18:05",
	)
	var before_activation: Dictionary = env["facade"].save_state()
	_expect(not _has_fact(before_activation, TRACE_ID), "aucune trace a l eligibilite ou composition")
	var forged: Dictionary = composition["plan"].duplicate(true)
	forged["fingerprint"] = "0".repeat(64)
	var action := {"intention": "PROPOSE", "context": context.duplicate(true)}
	_expect(
		not env["facade"].activate_option(forged, "blue_chairs_option", action)["ok"],
		"plan falsifie refuse",
	)
	_expect(env["facade"].save_state() == before_activation, "plan falsifie sans mutation")
	var stale_action := {"intention": "PROPOSE", "context": context.duplicate(true)}
	stale_action["context"]["participants_disponibles"]["sandra"] = false
	_expect(
		not env["facade"].activate_option(
			composition["plan"], "blue_chairs_option", stale_action
		)["ok"],
		"contexte perime refuse",
	)
	_expect(env["facade"].save_state() == before_activation, "contexte perime sans mutation")
	var activation: Dictionary = env["facade"].activate_option(
		composition["plan"], "blue_chairs_option", action
	)
	_expect(activation.get("ok", false), "A10 propose N2")
	_expect(activation.get("scene_state") == "PROPOSED", "A5 prouve la proposition")
	_expect(
		_option_state(activation["window"], "control_option") == "NOT_SELECTED",
		"alternative de controle fermee silencieusement",
	)
	var after_proposal: Dictionary = env["facade"].save_state()
	_expect(not _has_fact(after_proposal, TRACE_ID), "aucune trace a la proposition")
	_expect(not _has_state(after_proposal, "MISSED"), "aucun MISSED apres proposition")
	_expect(not _j05_evaluable(after_proposal), "J05 ineligible apres proposition N2")
	var early_trace: Dictionary = _record_common_trace_after_resolution(
		env, "n5_complete_blue_chairs_instance"
	)
	_expect(not early_trace.get("ok", false), "trace commune refusee avant resolution complete")
	_expect(not _has_fact(env["facade"].save_state(), TRACE_ID), "refus precoce sans trace A1")
	var resolution_context := _context("2030-04-12T18:10:00+02:00")
	var resolution: Dictionary = env["facade"].resolve_scene(
		"n5_complete_blue_chairs_instance",
		"careful_warmth",
		"careful_warmth_received",
		resolution_context,
	)
	_expect(resolution.get("ok", false), "resolution complete apres fermeture de fenetre")
	_expect(resolution.get("state") == "RESOLVED", "instance A5 RESOLVED")
	_expect(resolution.get("transaction_status") == "NON_PERSISTE", "attitude locale non persistee")
	var resolved_without_trace: Dictionary = env["facade"].save_state()
	_expect(not _j05_evaluable(resolved_without_trace), "J05 ineligible apres resolution N2")
	_expect(not _has_fact(resolved_without_trace, TRACE_ID), "aucune trace par la resolution locale")
	_expect(
		not resolved_without_trace["narrative_state"]["evenements"].has(
			"r8c-a3:n5_complete_blue_chairs_instance:resolution:careful_warmth_received"
		),
		"aucun evenement A1 durable specifique au choix A",
	)
	var common_trace: Dictionary = _record_common_trace_after_resolution(
		env, "n5_complete_blue_chairs_instance"
	)
	_expect(common_trace.get("statut") == "APPLIQUE", "trace A1 commune appliquee apres RESOLVED")
	var resolved: Dictionary = env["facade"].save_state()
	_expect(_fact_count(resolved, TRACE_ID) == 1, "trace durable commune creee une fois")
	var provenance: Dictionary = resolved["narrative_state"]["evenements"][COMMON_TRACE_EVENT_ID]["provenance"]
	_expect(
		provenance.keys().size() == 2 and not provenance.has("source_choix_id") and not provenance.has("source_signal_emis"),
		"trace commune sans provenance de choix ou signal",
	)
	var replay: Dictionary = env["facade"].resolve_scene(
		"n5_complete_blue_chairs_instance",
		"careful_warmth",
		"careful_warmth_received",
		resolution_context,
	)
	_expect(replay.get("ok", false) and replay.get("idempotent", false), "resolution idempotente")
	var trace_replay: Dictionary = _record_common_trace_after_resolution(
		env, "n5_complete_blue_chairs_instance"
	)
	_expect(trace_replay.get("statut") == "IDEMPOTENT", "trace commune idempotente")
	_expect(env["facade"].save_state() == resolved, "replay sans seconde trace")


func _test_close_silently_before_proposal_and_j05_rule() -> void:
	var env := _coordinator_environment()
	_expect(not env.is_empty(), "environnement A8 direct cree")
	if env.is_empty():
		return
	var context := _context("2030-04-12T16:30:00+02:00")
	var before: Dictionary = env["motor"].obtenir_snapshot(env["state"])
	var opening: Dictionary = env["a8"].ouvrir_fenetre(
		_window_specification("n5_silent_window"), env["state"], context
	)
	_expect(opening.get("ok", false), "fenetre A8 ouverte sans instance")
	_expect(env["motor"].obtenir_snapshot(env["state"]) == before, "ouverture sans mutation A1 A5")
	var control: Dictionary = env["a8"].agir_sur_option(
		"n5_silent_window",
		"control_option",
		env["state"],
		context,
		CoordinateurA7Modele.PROPOSE,
	)
	_expect(control.get("ok", false), "option de controle proposee")
	var closed: Dictionary = env["a8"].fermer_conflit_exclusif(
		"n5_silent_window", "control_option", env["state"], context
	)
	_expect(closed.get("ok", false), "conflit ferme")
	_expect(
		_option_state(closed["window"], "blue_chairs_option") == "NOT_SELECTED",
		"N2 candidate fermee silencieusement",
	)
	_expect(
		env["motor"].obtenir_instance("n5_silent_blue_chairs_instance") == null,
		"fermeture silencieuse sans instance N2",
	)
	var snapshot: Dictionary = env["motor"].obtenir_snapshot(env["state"])
	_expect(not _has_fact(snapshot, TRACE_ID), "fermeture silencieuse sans trace")
	_expect(not _has_state(snapshot, "MISSED"), "aucun MISSED avant proposition")
	_expect(_j05_evaluable(snapshot), "J05 reste evaluable si N2 jamais proposee")
	var at_close := _context("2030-04-12T18:05:00+02:00")
	_expect(
		not env["a8"].agir_sur_option(
			"n5_silent_window",
			"blue_chairs_option",
			env["state"],
			at_close,
			CoordinateurA7Modele.PROPOSE,
		)["ok"],
		"aucune proposition a 18:05",
	)


func _test_a9_hard_boundary_and_atomic_refusals() -> void:
	var env := _environment()
	var context := _context("2030-04-12T16:30:00+02:00")
	var candidates: Array = env["facade"].find_candidates(context)["candidats"]
	var before: Dictionary = env["facade"].save_state()
	var overrun := _slot_request(context, "n5_overrun", candidates, 95, "18:04")
	overrun["ends_at"] = "2030-04-12T18:05:00+02:00"
	_expect(not env["facade"].compose_slot(overrun)["ok"], "A9 refuse une fin a 18:05")
	_expect(env["facade"].save_state() == before, "refus 18:05 atomique")
	var early_context := _context("2030-04-12T16:29:00+02:00")
	var early_search: Dictionary = env["facade"].find_candidates(early_context)
	_expect(_candidate(early_search["candidats"], SCENE_ID).is_empty(), "A3 refuse avant 16:30")
	var close_context := _context("2030-04-12T18:05:00+02:00")
	var close_search: Dictionary = env["facade"].find_candidates(close_context)
	_expect(_candidate(close_search["candidats"], SCENE_ID).is_empty(), "A3 refuse a 18:05")
	_expect(env["facade"].save_state() == before, "bornes refusees sans MISSED")


func _test_prerequisite_and_incompatibility_refusals() -> void:
	var missing := _environment("sandra_first_complicity_restored")
	var context := _context("2030-04-12T16:30:00+02:00")
	var missing_search: Dictionary = missing["facade"].find_candidates(context)
	_expect(_candidate(missing_search["candidats"], SCENE_ID).is_empty(), "prerequis absent refuse")
	_expect(not _has_fact(missing["facade"].save_state(), TRACE_ID), "prerequis absent sans trace")
	var incompatible := _environment("", "sandra_conflict_active")
	var incompatible_search: Dictionary = incompatible["facade"].find_candidates(context)
	_expect(_candidate(incompatible_search["candidats"], SCENE_ID).is_empty(), "incompatibilite active refuse")
	_expect(not _has_fact(incompatible["facade"].save_state(), TRACE_ID), "incompatibilite sans trace")


func _environment(missing_event: String = "", forbidden_event: String = "") -> Dictionary:
	var loaded: Dictionary = BibliothequeModele.charger_depuis_bundle(_harness_bundle())
	if not loaded.get("ok", false):
		return {}
	var state = _new_state()
	if not _prepare_events(state, missing_event, forbidden_event):
		return {}
	var facade = FacadeModele.create(loaded["bibliotheque"], state)
	if facade == null:
		return {}
	return {"facade": facade, "library": loaded["bibliotheque"], "state": state}


func _coordinator_environment() -> Dictionary:
	var loaded: Dictionary = BibliothequeModele.charger_depuis_bundle(_harness_bundle())
	if not loaded.get("ok", false):
		return {}
	var state = _new_state()
	if not _prepare_events(state):
		return {}
	var motor := MoteurModele.new()
	var a7 = CoordinateurA7Modele.creer(loaded["bibliotheque"], motor)
	var a8 = CoordinateurA8Modele.creer(loaded["bibliotheque"], motor, a7)
	if a7 == null or a8 == null:
		return {}
	return {"library": loaded["bibliotheque"], "state": state, "motor": motor, "a8": a8}


func _harness_bundle() -> Dictionary:
	var staged = JSON.parse_string(FileAccess.get_file_as_string(BUNDLE_PATH))
	if typeof(staged) != TYPE_DICTIONARY:
		return {}
	var blue_entry: Dictionary = staged["definitions"][0].duplicate(true)
	var control_entry: Dictionary = blue_entry.duplicate(true)
	control_entry["scene_definition_id"] = CONTROL_SCENE_ID
	control_entry["variant_id"] = CONTROL_VARIANT_ID
	control_entry["definition"]["scene_id"] = CONTROL_SCENE_ID
	control_entry["definition"]["version_contrat"] = "1.0.0-n5-smoke-control"
	control_entry["definition"]["titre_interne"] = "N5 smoke control"
	control_entry["definition"]["structure_id"] = "n5_smoke_control"
	return {
		"format": "R8C_A6_SCENE_LIBRARY",
		"version": 1,
		"definitions": [blue_entry, control_entry],
	}


func _slot_request(
	context: Dictionary,
	prefix: String,
	candidates: Array,
	duration_minutes: int,
	not_after_time: String
) -> Dictionary:
	return {
		"slot_id": prefix + "_slot",
		"narrative_date": "2030-04-12",
		"starts_at": "2030-04-12T16:30:00+02:00",
		"ends_at": "2030-04-12T18:04:00+02:00",
		"context": context.duplicate(true),
		"window": {
			"window_id": prefix + "_window",
			"opens_at": "2030-04-12T16:30:00+02:00",
			"closes_at": "2030-04-12T18:05:00+02:00",
			"duration_minutes": duration_minutes,
			"not_before": "2030-04-12T16:30:00+02:00",
			"not_after": "2030-04-12T%s:00+02:00" % not_after_time,
			"options": [
				{
					"option_id": "blue_chairs_option",
					"candidate": _candidate(candidates, SCENE_ID),
					"instance_id": prefix + "_blue_chairs_instance",
					"conflict_policy": "CLOSE_SILENTLY",
				},
				{
					"option_id": "control_option",
					"candidate": _candidate(candidates, CONTROL_SCENE_ID),
					"instance_id": prefix + "_control_instance",
					"conflict_policy": "CLOSE_SILENTLY",
				},
			],
		},
	}


func _window_specification(window_id: String) -> Dictionary:
	return {
		"window_id": window_id,
		"opens_at": "2030-04-12T16:30:00+02:00",
		"closes_at": "2030-04-12T18:05:00+02:00",
		"context": {
			"acte_courant": "SANDRA_REOPENING_SEQUENCE",
			"participants_disponibles": {"player": true, "sandra": true},
			"opportunite_valide": true,
		},
		"options": [
			{
				"option_id": "blue_chairs_option",
				"scene_definition_id": SCENE_ID,
				"variant_id": VARIANT_ID,
				"instance_id": "n5_silent_blue_chairs_instance",
				"conflict_policy": "CLOSE_SILENTLY",
			},
			{
				"option_id": "control_option",
				"scene_definition_id": CONTROL_SCENE_ID,
				"variant_id": CONTROL_VARIANT_ID,
				"instance_id": "n5_silent_control_instance",
				"conflict_policy": "CLOSE_SILENTLY",
			},
		],
	}


func _context(moment: String) -> Dictionary:
	return {
		"acte_courant": "SANDRA_REOPENING_SEQUENCE",
		"moment_diegetique": moment,
		"participants_disponibles": {"player": true, "sandra": true},
		"opportunite_valide": true,
	}


func _prepare_events(state, missing_event: String = "", forbidden_event: String = "") -> bool:
	for event_id in REQUIRED_EVENTS:
		if event_id != missing_event and not _add_event(state, event_id):
			return false
	if not forbidden_event.is_empty() and not _add_event(state, forbidden_event):
		return false
	return true


func _add_event(state, event_id: String) -> bool:
	var facts: Array = state.obtenir_snapshot()["relations"]["sandra"]["faits"].duplicate(true)
	facts.append({"fait_id": event_id, "nature": "PRECONDITION_DISCRETE_SOURCED"})
	var result: Dictionary = state.traiter_evenement({
		"event_id": event_id,
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {"type": "R8C_N5_STAGED_SEASON_PROJECTION", "id": event_id},
		"payload": {"personnage_id": "sandra", "changements": {"faits": facts}},
	})
	return result.get("ok", false)


func _record_common_trace_after_resolution(env: Dictionary, instance_id: String) -> Dictionary:
	var snapshot: Dictionary = env["facade"].save_state()
	var resolved := false
	for instance in snapshot.get("scene_registry", []):
		if instance.get("instance_id") == instance_id and instance.get("state") == "RESOLVED":
			resolved = true
			break
	if not resolved:
		return {"ok": false, "statut": "REFUSE", "erreur": "INSTANCE_NON_RESOLUE"}
	var state = env["state"]
	var facts: Array = state.obtenir_snapshot()["relations"]["sandra"]["faits"].duplicate(true)
	if not facts.any(func(fact): return typeof(fact) == TYPE_DICTIONARY and fact.get("fait_id") == TRACE_ID):
		facts.append({
			"fait_id": TRACE_ID,
			"nature": "SIGNAL_RECU_ET_INTERPRETE",
			"recu_par": "sandra",
			"permission_future": false,
		})
	return state.traiter_evenement({
		"event_id": COMMON_TRACE_EVENT_ID,
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {
			"type": "R8C_N5_STAGED_COMMON_RESOLUTION_TRACE",
			"id": COMMON_TRACE_EVENT_ID,
		},
		"payload": {"personnage_id": "sandra", "changements": {"faits": facts}},
	})


func _new_state():
	return EtatNarratifModele.creer_synthetique({
		"statut_couple": "EN_CLARIFICATION",
		"contrat_couple": null,
		"etat_divulgation": "PARTIEL",
		"etat_foyer": null,
		"relation_apres_separation": null,
		"dernier_evenement_majeur_id": null,
		"faits": [],
		"cadre_provisoire": null,
	})


func _candidate(candidates: Array, scene_definition_id: String) -> Dictionary:
	for candidate in candidates:
		if candidate.get("scene_definition_id") == scene_definition_id:
			return candidate.duplicate(true)
	return {}


func _option_state(window: Dictionary, option_id: String) -> String:
	for option in window.get("options", []):
		if option.get("option_id") == option_id:
			return option.get("state", "")
	return ""


func _fact_count(snapshot: Dictionary, fact_id: String) -> int:
	var count := 0
	for fact in snapshot["narrative_state"]["relations"]["sandra"]["faits"]:
		if typeof(fact) == TYPE_DICTIONARY and fact.get("fait_id") == fact_id:
			count += 1
	return count


func _has_fact(snapshot: Dictionary, fact_id: String) -> bool:
	return _fact_count(snapshot, fact_id) > 0


func _has_state(snapshot: Dictionary, state: String) -> bool:
	for instance in snapshot.get("scene_registry", []):
		if instance.get("state") == state:
			return true
	return false


func _j05_evaluable(snapshot: Dictionary) -> bool:
	for instance in snapshot.get("scene_registry", []):
		if (
			instance.get("scene_definition_id") == SCENE_ID
			and instance.get("state") in ["PROPOSED", "RESOLVED"]
		):
			return false
	return true


func _expect(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures.append(message)
