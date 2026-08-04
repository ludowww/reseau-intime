extends Node

const BibliothequeModele := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const CoordinateurModele := preload("res://scripts/narrative_scene/CandidateReservationProposalCoordinator.gd")
const MoteurModele := preload("res://scripts/narrative_scene/MinimalSceneEngine.gd")
const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")
const BUNDLE_PATH := "res://data/narrative_scenes/r8c_a6_prototype_library.json"

var failures: Array[String] = []
var controles := 0


func _ready() -> void:
	_executer()
	if controles != 38:
		failures.append("nombre de controles inattendu: %d/38" % controles)
	if failures.is_empty():
		print("R8C_A7_CANDIDATE_RESERVATION_PROPOSAL: OK (%d controles)" % controles)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)


func _executer() -> void:
	_test_query_seule_et_reservation()
	_test_proposition_et_absence()
	_test_revalidation_et_provenance()
	_test_idempotence_et_unicite()
	_test_repetable_et_diagnostics()


func _test_query_seule_et_reservation() -> void:
	var env := _environnement()
	_expect(not env.is_empty(), "01 environnement A7 charge")
	var contexte := _contexte("a7-reservation", "2030-04-08T19:00:00+02:00", {"sandra": true})
	_expect(_ajouter_evenement(env["etat"], "r8c-a6-sandra-ready", "sandra"), "02 precondition explicite")
	var avant_etat: Dictionary = env["etat"].obtenir_snapshot()
	var avant_moteur: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var candidat := _candidat(env, contexte, "sandra_signature")
	_expect(not candidat.is_empty(), "03 candidat A6 ephemere disponible")
	_expect(env["etat"].obtenir_snapshot() == avant_etat, "04 query seule sans mutation A1")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant_moteur, "05 query seule ne cree rien A5")
	var reserve: Dictionary = env["coordinateur"].executer(
		candidat, env["etat"], contexte, CoordinateurModele.RESERVE
	)
	_expect(reserve["ok"] and reserve["state"] == "ELIGIBLE", "06 reservation cree exactement une instance ELIGIBLE")
	_expect(env["moteur"].obtenir_snapshot(env["etat"])["scene_registry"].size() == 1, "07 une instance A5 reservee")
	_expect(env["etat"].obtenir_snapshot() == avant_etat, "08 reservation sans evenement A1 ni absence")
	var instance = env["moteur"].obtenir_instance("a7-reservation")
	var definition: Dictionary = env["bibliotheque"].obtenir_definition(reserve["scene_definition_id"])
	var manque: Dictionary = env["moteur"].manquer(
		instance,
		definition,
		env["etat"],
		_contexte("a7-reservation", "2030-04-08T23:00:00+02:00", {"sandra": true}),
	)
	_expect(not manque["ok"] and instance.obtenir_statut() == "ELIGIBLE", "09 seule une proposition peut devenir MISSED")
	var annulation: Dictionary = env["moteur"].annuler(instance, "RESERVATION_ANNULEE", "2030-04-08T19:05:00+02:00")
	_expect(annulation["ok"] and instance.obtenir_statut() == "CANCELLED", "10 reservation annulee proprement")
	_expect(env["etat"].obtenir_snapshot() == avant_etat, "11 annulation sans consequence relationnelle implicite")


func _test_proposition_et_absence() -> void:
	var env := _environnement()
	_expect(_ajouter_evenement(env["etat"], "r8c-a6-raphaelle-away", "raphaelle"), "12 precondition proposition")
	var contexte := _contexte("a7-proposition", "2030-04-09T13:00:00+02:00", {"raphaelle": true})
	var candidat := _candidat(env, contexte, "raphaelle_distance")
	var avant_etat: Dictionary = env["etat"].obtenir_snapshot()
	var propose: Dictionary = env["coordinateur"].executer(
		candidat, env["etat"], contexte, CoordinateurModele.PROPOSE
	)
	_expect(propose["ok"] and propose["state"] == "PROPOSED", "13 proposition cree exactement une instance PROPOSED")
	_expect(env["moteur"].obtenir_snapshot(env["etat"])["scene_registry"].size() == 1, "14 proposition atomique unique")
	_expect(env["etat"].obtenir_snapshot() == avant_etat, "15 proposition sans mutation A1 implicite")
	var instance = env["moteur"].obtenir_instance("a7-proposition")
	var definition: Dictionary = env["bibliotheque"].obtenir_definition(propose["scene_definition_id"])
	var manque: Dictionary = env["moteur"].manquer(
		instance,
		definition,
		env["etat"],
		_contexte("a7-proposition", "2030-04-11T00:01:00+02:00", {"raphaelle": true}),
	)
	_expect(manque["ok"] and instance.obtenir_statut() == "MISSED", "16 proposition effectivement manquable")
	_expect(env["etat"].obtenir_snapshot() == avant_etat, "17 MISSED sans consequence non authored")


func _test_revalidation_et_provenance() -> void:
	var env := _environnement()
	_expect(_ajouter_evenement(env["etat"], "r8c-a6-sandra-away", "sandra"), "18 precondition revalidation")
	var contexte := _contexte("a7-stale", "2030-04-09T13:00:00+02:00", {"sandra": true})
	var candidat := _candidat(env, contexte, "sandra_distance")
	var change: Dictionary = contexte.duplicate(true)
	change["participants_disponibles"]["sandra"] = false
	var avant: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var stale: Dictionary = env["coordinateur"].executer(candidat, env["etat"], change, CoordinateurModele.RESERVE)
	_expect(not stale["ok"], "19 contexte change refuse")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant, "20 contexte change sans mutation")
	var contexte_ferme := contexte.duplicate(true)
	_expect(_ajouter_evenement(env["etat"], "r8c-a6-sandra-returned", "sandra"), "21 fermeture disponibilite authored")
	var avant_refus: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var refuse: Dictionary = env["coordinateur"].executer_dev(candidat, env["etat"], contexte_ferme, CoordinateurModele.PROPOSE)
	_expect(not refuse["ok"] and refuse["diagnostic"]["code"] == "REVALIDATION_INELIGIBLE", "22 revalidation A3 echouee")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant_refus, "23 revalidation echouee atomique")
	var fabrique := {
		"scene_definition_id": candidat["scene_definition_id"],
		"definition_version": candidat["definition_version"],
		"variant_id": candidat["variant_id"],
		"revalidation_requise_avant": candidat["revalidation_requise_avant"],
		"preuve_provenance": "preuve_fabriquee",
	}
	var forge: Dictionary = env["coordinateur"].executer_dev(fabrique, env["etat"], contexte, CoordinateurModele.RESERVE)
	_expect(not forge["ok"] and forge["diagnostic"]["code"] == "CANDIDAT_PERIME_OU_CONTEXTE_CHANGE", "24 candidat fabrique refuse")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant_refus, "25 candidat falsifie sans mutation")


func _test_idempotence_et_unicite() -> void:
	var env := _environnement()
	_expect(_ajouter_evenement(env["etat"], "r8c-a6-sandra-ready", "sandra"), "26 precondition unicite")
	var contexte_a := _contexte("a7-unique-a", "2030-04-08T19:00:00+02:00", {"sandra": true})
	var contexte_b := _contexte("a7-unique-b", "2030-04-08T19:00:00+02:00", {"sandra": true})
	var candidat_a := _candidat(env, contexte_a, "sandra_signature")
	var candidat_b := _candidat(env, contexte_b, "sandra_signature")
	var premier: Dictionary = env["coordinateur"].executer(candidat_a, env["etat"], contexte_a, CoordinateurModele.RESERVE)
	var snapshot: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var replay: Dictionary = env["coordinateur"].executer(candidat_a, env["etat"], contexte_a, CoordinateurModele.RESERVE)
	_expect(premier["ok"] and replay["ok"] and replay["idempotent"], "27 meme demande rejouee idempotente")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == snapshot, "28 replay ne cree ni ne mute")
	var conflit: Dictionary = env["coordinateur"].executer_dev(candidat_b, env["etat"], contexte_b, CoordinateurModele.RESERVE)
	_expect(not conflit["ok"] and conflit["diagnostic"]["code"] == "REVALIDATION_INELIGIBLE", "29 demande differente meme UNIQUE refusee")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == snapshot, "30 conflit UNIQUE atomique")


func _test_repetable_et_diagnostics() -> void:
	var env := _environnement()
	_expect(_ajouter_evenement(env["etat"], "r8c-a6-sandra-away", "sandra"), "31 precondition repetable")
	var contexte_a := _contexte("a7-repeat-a", "2030-04-09T13:00:00+02:00", {"sandra": true})
	var contexte_b := _contexte("a7-repeat-b", "2030-04-09T14:00:00+02:00", {"sandra": true})
	var candidat_a := _candidat(env, contexte_a, "sandra_distance")
	var candidat_b := _candidat(env, contexte_b, "sandra_distance")
	var reserve: Dictionary = env["coordinateur"].executer(candidat_a, env["etat"], contexte_a, CoordinateurModele.RESERVE)
	var propose: Dictionary = env["coordinateur"].executer(candidat_b, env["etat"], contexte_b, CoordinateurModele.PROPOSE)
	_expect(reserve["ok"] and propose["ok"], "32 REPETABLE accepte deux demandes deterministes")
	_expect(env["moteur"].obtenir_snapshot(env["etat"])["scene_registry"].size() == 2, "33 REPETABLE cree deux instances distinctes")
	_expect(reserve["variant_id"] == propose["variant_id"] and reserve["instance_id"] != propose["instance_id"], "34 identites scene variante instance stables")
	_expect(not reserve.has("diagnostic"), "35 resultat runtime assaini")
	var contexte_c := _contexte("a7-repeat-c", "2030-04-09T15:00:00+02:00", {"sandra": true})
	var candidat_c := _candidat(env, contexte_c, "sandra_distance")
	var dev: Dictionary = env["coordinateur"].executer_dev(candidat_c, env["etat"], contexte_c, CoordinateurModele.RESERVE)
	_expect(dev["ok"] and dev.has("diagnostic") and dev["diagnostic"].has("revalidation_a3"), "36 diagnostics dev complets")
	_expect(env["etat"].obtenir_snapshot()["evenements"].size() == 1, "37 aucune mutation A1 hors evenement explicite")
	_expect(env["moteur"].obtenir_snapshot(env["etat"])["scene_registry"].size() == 3, "38 UNIQUE et REPETABLE restent bornes au registre A5")


func _environnement() -> Dictionary:
	var charge: Dictionary = BibliothequeModele.charger_depuis_json(BUNDLE_PATH)
	if not charge["ok"]:
		return {}
	var moteur := MoteurModele.new()
	var coordinateur = CoordinateurModele.creer(charge["bibliotheque"], moteur)
	if coordinateur == null:
		return {}
	return {
		"bibliotheque": charge["bibliotheque"],
		"moteur": moteur,
		"coordinateur": coordinateur,
		"etat": _nouvel_etat(),
	}


func _candidat(env: Dictionary, contexte: Dictionary, variant_id: String) -> Dictionary:
	var resultat: Dictionary = env["bibliotheque"].query_candidates(
		env["moteur"], env["etat"], contexte
	)
	if not resultat["ok"]:
		return {}
	for candidat in resultat["candidats"]:
		if candidat["variant_id"] == variant_id:
			return candidat
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
	faits.append({"fait_id": event_id + "-fait", "nature": "PRECONDITION_SYNTHETIQUE"})
	var resultat: Dictionary = etat.traiter_evenement({
		"event_id": event_id,
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "r8c_a7_smoke"},
		"payload": {"personnage_id": personnage_id, "changements": {"faits": faits}},
	})
	return resultat["ok"]


func _contexte(instance_id: String, moment: String, disponibilites: Dictionary) -> Dictionary:
	return {
		"instance_id": instance_id,
		"acte_courant": "ACTE_SYNTHETIQUE_A6",
		"moment_diegetique": moment,
		"participants_disponibles": disponibilites,
		"opportunite_valide": true,
	}


func _expect(condition: bool, message: String) -> void:
	controles += 1
	if not condition:
		failures.append(message)
