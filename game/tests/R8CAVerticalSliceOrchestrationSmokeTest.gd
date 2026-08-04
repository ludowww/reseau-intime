extends Node

const FacadeModele := preload("res://scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
const BibliothequeModele := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")

const FIXTURE_PATH := "res://tests/fixtures/r8c_a3_minimal_scene_definitions.json"

var failures: Array[String] = []
var controles := 0


func _ready() -> void:
	_executer()
	if controles != 50:
		failures.append("nombre de controles inattendu: %d" % controles)
	if failures.is_empty():
		print("R8C-A10 vertical slice orchestration: 50 controles OK")
		get_tree().quit(0)
	else:
		for failure in failures:
			push_error(failure)
		get_tree().quit(1)


func _executer() -> void:
	_test_vertical_slice_complete()
	_test_plan_refuse_sans_mutation()
	_test_echec_composition_recupere()
	_test_surface_runtime_assainie()


func _test_vertical_slice_complete() -> void:
	var env := _environnement()
	_expect(not env.is_empty(), "environnement synthetique A1 A6 A10 cree")
	if env.is_empty():
		return
	var contexte := _contexte("2030-04-08T18:30:00+02:00")
	var recherche: Dictionary = env["facade"].find_candidates(contexte)
	_expect(recherche["ok"], "recherche A6 via facade")
	_expect(recherche["candidats"].size() == 2, "deux opportunites concurrentes eligibles")
	_expect(
		recherche["candidats"][0]["scene_definition_id"]
		== "r8c_a3_module_distance_raphaelle",
		"ordre A6 conserve sans classement automatique",
	)
	_expect(
		recherche["candidats"][1]["scene_definition_id"]
		== "r8c_a3_signature_sandra_presence_distance",
		"scene signature conservee dans l ordre A6",
	)
	var composition: Dictionary = env["facade"].compose_slot(
		_slot_request(contexte, "a10_main", recherche["candidats"])
	)
	_expect(composition["ok"], "creation fenetre A8 et composition A9 via facade")
	_expect(composition["window"]["options"].size() == 2, "deux options A8 dans un seul creneau")
	_expect(
		composition["plan"]["author_order"] == ["a10_main_window"],
		"aucune selection automatique ni reordonnancement",
	)
	_expect(
		composition["plan"]["windows"][0]["starts_at"]
		== "2030-04-08T18:30:00+02:00",
		"implantation earliest fit A9 conservee",
	)
	var avant_activation: Dictionary = env["facade"].save_state()
	var action := {"intention": "PROPOSE", "context": contexte.duplicate(true)}
	var activation: Dictionary = env["facade"].activate_option(
		composition["plan"],
		"signature_option",
		action,
	)
	_expect(activation["ok"], "activation controlee A9 A8 A7 A5")
	_expect(activation["activation_state"] == "PROPOSED", "option retenue activee PROPOSED")
	_expect(activation["scene_state"] == "PROPOSED", "instance A5 materialisee PROPOSED")
	_expect(
		_etat_option(activation["window"], "module_option") == "NOT_SELECTED",
		"CLOSE_SILENTLY ferme l alternative jamais proposee",
	)
	_expect(
		not _option_materialisee(activation["window"], "module_option"),
		"alternative silencieuse sans instance A5",
	)
	_expect(
		env["facade"].save_state()["narrative_state"] == avant_activation["narrative_state"],
		"activation et fermeture silencieuse sans consequence A1",
	)
	var replay_activation: Dictionary = env["facade"].activate_option(
		composition["plan"],
		"signature_option",
		action,
	)
	_expect(replay_activation["ok"] and replay_activation["idempotent"], "activation idempotente")
	_expect(env["facade"].save_state()["scene_registry"].size() == 1, "une seule instance A5 creee")
	var resolution: Dictionary = env["facade"].resolve_scene(
		"a10_main_signature_instance",
		"chaleureuse",
		"signal_chaleureux_recu",
		_contexte("2030-04-08T18:40:00+02:00"),
	)
	_expect(resolution["ok"], "resolution A3 via facade")
	_expect(resolution["state"] == "RESOLVED", "instance A5 resolue")
	_expect(resolution["transaction_status"] == "APPLIQUE", "transaction durable A1 appliquee")
	var snapshot: Dictionary = env["facade"].save_state()
	_expect(snapshot["scene_registry"].size() == 1, "snapshot A5 contient seulement l option retenue")
	_expect(snapshot["scene_registry"][0]["state"] == "RESOLVED", "snapshot conserve instance resolue")
	_expect(
		snapshot["narrative_state"]["evenements"].size()
		== avant_activation["narrative_state"]["evenements"].size() + 1,
		"une consequence A1 durable ajoutee",
	)
	_expect(
		_a_fait(snapshot, "sandra", "sandra_attention_chaleureuse_reconnue"),
		"consequence relationnelle A1 verifiee",
	)
	_expect(not _a_evenement_module(snapshot), "aucune consequence pour alternative jamais proposee")
	var replay_activation_resolue: Dictionary = env["facade"].activate_option(
		composition["plan"],
		"signature_option",
		action,
	)
	_expect(
		replay_activation_resolue["idempotent"]
		and replay_activation_resolue["activation_state"] == "PROPOSED"
		and replay_activation_resolue["scene_state"] == "RESOLVED",
		"replay activation distingue activation historique et etat A5 courant",
	)
	_expect(env["facade"].save_state() == snapshot, "replay activation apres resolution sans mutation")
	var restauration: Dictionary = env["facade"].restore_state(snapshot)
	_expect(restauration["ok"], "snapshot recharge via facade A5")
	_expect(env["facade"].save_state() == snapshot, "reload conserve instance et transaction durable")
	var replay_resolution: Dictionary = env["facade"].resolve_scene(
		"a10_main_signature_instance",
		"chaleureuse",
		"signal_chaleureux_recu",
		_contexte("2030-04-08T18:40:00+02:00"),
	)
	_expect(replay_resolution["ok"] and replay_resolution["idempotent"], "resolution idempotente apres reload")
	_expect(env["facade"].save_state() == snapshot, "replay resolution sans seconde mutation")


func _test_plan_refuse_sans_mutation() -> void:
	var env := _environnement()
	var contexte := _contexte("2030-04-08T18:30:00+02:00")
	var candidats: Array = env["facade"].find_candidates(contexte)["candidats"]
	var composition: Dictionary = env["facade"].compose_slot(
		_slot_request(contexte, "a10_guard", candidats)
	)
	_expect(composition["ok"], "plan de garde compose")
	var avant: Dictionary = env["facade"].save_state()
	var reserve := {"intention": "RESERVE", "context": contexte.duplicate(true)}
	_expect(
		not env["facade"].activate_option(composition["plan"], "signature_option", reserve)["ok"],
		"RESERVE refuse par la facade avant mutation",
	)
	_expect(env["facade"].save_state() == avant, "RESERVE refuse laisse A1 A5 intacts")
	var falsifie: Dictionary = composition["plan"].duplicate(true)
	falsifie["fingerprint"] = "0".repeat(64)
	var action := {"intention": "PROPOSE", "context": contexte.duplicate(true)}
	_expect(
		not env["facade"].activate_option(falsifie, "signature_option", action)["ok"],
		"plan A9 falsifie refuse sans mutation",
	)
	_expect(env["facade"].save_state() == avant, "plan falsifie laisse A1 A5 intacts")
	var contexte_change: Dictionary = contexte.duplicate(true)
	contexte_change["participants_disponibles"]["raphaelle"] = false
	var action_changee := {"intention": "PROPOSE", "context": contexte_change}
	_expect(
		not env["facade"].activate_option(
			composition["plan"],
			"signature_option",
			action_changee,
		)["ok"],
		"contexte change refuse avant activation",
	)
	_expect(env["facade"].save_state() == avant, "contexte change laisse A1 A5 intacts")


func _test_echec_composition_recupere() -> void:
	var env := _environnement()
	var contexte := _contexte("2030-04-08T18:30:00+02:00")
	var candidats: Array = env["facade"].find_candidates(contexte)["candidats"]
	var invalide: Dictionary = _slot_request(contexte, "a10_rollback", candidats)
	invalide["ends_at"] = "2030-04-08T18:35:00+02:00"
	var avant: Dictionary = env["facade"].save_state()
	_expect(not env["facade"].compose_slot(invalide)["ok"], "echec A9 apres ouverture A8 detecte")
	_expect(env["facade"].save_state() == avant, "echec composition sans mutation A1 A5")
	var corrige: Dictionary = _slot_request(contexte, "a10_rollback", candidats)
	_expect(env["facade"].compose_slot(corrige)["ok"], "rollback A8 libere le meme window_id")
	_expect(env["facade"].save_state()["scene_registry"].is_empty(), "rollback sans instance A5 cachee")


func _test_surface_runtime_assainie() -> void:
	var env := _environnement()
	var contexte := _contexte("2030-04-08T18:30:00+02:00")
	var recherche: Dictionary = env["facade"].find_candidates(contexte)
	var composition: Dictionary = env["facade"].compose_slot(
		_slot_request(contexte, "a10_surface", recherche["candidats"])
	)
	var action := {"intention": "PROPOSE", "context": contexte.duplicate(true)}
	var activation: Dictionary = env["facade"].activate_option(
		composition["plan"], "signature_option", action
	)
	_expect(activation["ok"], "activation disponible pour audit de surface")
	var resolution: Dictionary = env["facade"].resolve_scene(
		"a10_surface_signature_instance",
		"chaleureuse",
		"signal_chaleureux_recu",
		_contexte("2030-04-08T18:40:00+02:00"),
	)
	_expect(resolution["ok"], "resolution disponible pour audit de surface")
	var refus: Dictionary = env["facade"].resolve_scene(
		"instance_inconnue", "choix_inconnu", "resolution_inconnue", contexte
	)
	var sorties_runtime := [recherche, composition, activation, resolution, refus]
	_expect(
		not _contient_cle_interdite(sorties_runtime, "preuve_provenance"),
		"preuve A6 masquee sur toute la facade",
	)
	_expect(
		not _contient_diagnostic(sorties_runtime),
		"facade n expose aucun diagnostic dev sur succes ou refus",
	)
	_expect(
		not _contient_cle_interdite(sorties_runtime, "definition_version"),
		"identites runtime reduites au necessaire",
	)
	var snapshot: Dictionary = env["facade"].save_state()
	_expect(not _contient_cle_interdite(snapshot, "preuve_provenance"), "snapshot sans preuve A6")
	_expect(not _contient_diagnostic(snapshot), "snapshot sans diagnostic dev")
	_expect(env["facade"].restore_state(snapshot)["ok"], "resultat restore assaini et valide")


func _environnement() -> Dictionary:
	var charge: Dictionary = BibliothequeModele.charger_depuis_bundle(_bundle_synthetique())
	if not charge.get("ok", false):
		return {}
	var etat = _nouvel_etat()
	if (
		not _ajouter_evenement(etat, "r8c-a3-sandra-relation-ready", "sandra")
		or not _ajouter_evenement(etat, "r8c-a3-raphaelle-away", "raphaelle")
	):
		return {}
	var facade = FacadeModele.create(charge["bibliotheque"], etat)
	if facade == null:
		return {}
	return {"facade": facade}


func _bundle_synthetique() -> Dictionary:
	var texte := FileAccess.get_file_as_string(FIXTURE_PATH)
	var fixture = JSON.parse_string(texte)
	if typeof(fixture) != TYPE_DICTIONARY:
		return {}
	var signature: Dictionary = fixture["definitions"]["signature_sandra"].duplicate(true)
	var module: Dictionary = fixture["definitions"]["module_distance_raphaelle"].duplicate(true)
	module["contrat_temporel"]["date_debut"] = "2030-04-08"
	module["contrat_temporel"]["date_fin"] = "2030-04-08"
	module["contrat_temporel"]["heure_ouverture"] = "18:00"
	module["contrat_temporel"]["heure_fermeture"] = "22:00"
	return {
		"format": "R8C_A6_SCENE_LIBRARY",
		"version": 1,
		"definitions": [
			{
				"scene_definition_id": signature["scene_id"],
				"variant_id": "a10_signature_sandra",
				"definition": signature,
			},
			{
				"scene_definition_id": module["scene_id"],
				"variant_id": "a10_module_raphaelle",
				"definition": module,
			},
		],
	}


func _slot_request(contexte: Dictionary, prefixe: String, candidats: Array) -> Dictionary:
	var signature: Dictionary = _candidat(
		candidats, "r8c_a3_signature_sandra_presence_distance"
	)
	var module: Dictionary = _candidat(candidats, "r8c_a3_module_distance_raphaelle")
	return {
		"slot_id": prefixe + "_slot",
		"narrative_date": "2030-04-08",
		"starts_at": "2030-04-08T18:30:00+02:00",
		"ends_at": "2030-04-08T19:30:00+02:00",
		"context": contexte.duplicate(true),
		"window": {
			"window_id": prefixe + "_window",
			"opens_at": "2030-04-08T18:00:00+02:00",
			"closes_at": "2030-04-08T21:00:00+02:00",
			"duration_minutes": 20,
			"not_before": "2030-04-08T18:30:00+02:00",
			"not_after": "2030-04-08T19:30:00+02:00",
			"options": [
				{
					"option_id": "signature_option",
					"candidate": signature,
					"instance_id": prefixe + "_signature_instance",
					"conflict_policy": "CLOSE_SILENTLY",
				},
				{
					"option_id": "module_option",
					"candidate": module,
					"instance_id": prefixe + "_module_instance",
					"conflict_policy": "CLOSE_SILENTLY",
				},
			],
		},
	}


func _contexte(moment: String) -> Dictionary:
	return {
		"acte_courant": "ACTE_SYNTHETIQUE_A3",
		"moment_diegetique": moment,
		"participants_disponibles": {"raphaelle": true, "sandra": true},
		"opportunite_valide": true,
	}


func _candidat(candidats: Array, scene_definition_id: String) -> Dictionary:
	for candidat in candidats:
		if candidat.get("scene_definition_id") == scene_definition_id:
			return candidat.duplicate(true)
	return {}


func _nouvel_etat():
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


func _ajouter_evenement(etat, event_id: String, personnage_id: String) -> bool:
	var faits: Array = etat.obtenir_snapshot()["relations"][personnage_id]["faits"].duplicate(true)
	faits.append({"fait_id": event_id + "_fait", "nature": "PRECONDITION_SYNTHETIQUE"})
	var resultat: Dictionary = etat.traiter_evenement({
		"event_id": event_id,
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "r8c_a10_smoke"},
		"payload": {"personnage_id": personnage_id, "changements": {"faits": faits}},
	})
	return resultat["ok"]


func _etat_option(window: Dictionary, option_id: String) -> String:
	for option in window["options"]:
		if option["option_id"] == option_id:
			return option["state"]
	return ""


func _option_materialisee(window: Dictionary, option_id: String) -> bool:
	for option in window["options"]:
		if option["option_id"] == option_id:
			return option["materialized"]
	return false


func _a_fait(snapshot: Dictionary, personnage_id: String, fait_id: String) -> bool:
	for fait in snapshot["narrative_state"]["relations"][personnage_id]["faits"]:
		if typeof(fait) == TYPE_DICTIONARY and fait.get("fait_id") == fait_id:
			return true
	return false


func _a_evenement_module(snapshot: Dictionary) -> bool:
	for evenement in snapshot["narrative_state"]["evenements"].values():
		if evenement.get("provenance", {}).get("scene_definition_id") == "r8c_a3_module_distance_raphaelle":
			return true
	return false


func _contient_cle_interdite(value, cle_interdite: String) -> bool:
	if typeof(value) == TYPE_DICTIONARY:
		for cle in value:
			if str(cle) == cle_interdite or _contient_cle_interdite(value[cle], cle_interdite):
				return true
	elif typeof(value) == TYPE_ARRAY:
		for element in value:
			if _contient_cle_interdite(element, cle_interdite):
				return true
	return false


func _contient_diagnostic(value) -> bool:
	if typeof(value) == TYPE_DICTIONARY:
		for cle in value:
			var nom := str(cle)
			if nom.begins_with("diagnostic") or nom.ends_with("_dev") or _contient_diagnostic(value[cle]):
				return true
	elif typeof(value) == TYPE_ARRAY:
		for element in value:
			if _contient_diagnostic(element):
				return true
	return false


func _expect(condition: bool, message: String) -> void:
	controles += 1
	if not condition:
		failures.append(message)
