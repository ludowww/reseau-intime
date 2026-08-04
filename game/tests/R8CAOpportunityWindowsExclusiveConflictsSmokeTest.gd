extends Node

const BibliothequeModele := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const CoordinateurA7Modele := preload("res://scripts/narrative_scene/CandidateReservationProposalCoordinator.gd")
const CoordinateurA8Modele := preload("res://scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd")
const MoteurModele := preload("res://scripts/narrative_scene/MinimalSceneEngine.gd")
const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")
const BUNDLE_PATH := "res://data/narrative_scenes/r8c_a6_prototype_library.json"

var failures: Array[String] = []
var controles := 0


func _ready() -> void:
	_executer()
	if controles != 68:
		failures.append("nombre de controles inattendu: %d/68" % controles)
	if failures.is_empty():
		print("R8C_A8_OPPORTUNITY_WINDOWS_EXCLUSIVE_CONFLICTS: OK (%d controles)" % controles)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)


func _executer() -> void:
	_test_creation_reservation_proposition_et_fermeture_silencieuse()
	_test_mark_missed_if_proposed()
	_test_defer_ephemere_reevaluable()
	_test_rejeu_idempotent()
	_test_expiration_et_contexte_change_atomiques()
	_test_unique_repetable_provenance_et_diagnostics()
	_test_politiques_incompatibles_atomiques()


func _test_creation_reservation_proposition_et_fermeture_silencieuse() -> void:
	var env := _environnement()
	_expect(not env.is_empty(), "01 environnement A8 charge")
	_preparer_distance(env)
	var contexte := _contexte("2030-04-09T13:00:00+02:00", {"raphaelle": true, "sandra": true})
	var options := [
		_option("raphaelle_visible", "r8c_a6_distance_raphaelle_definition", "raphaelle_distance", "a8_base_raphaelle", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra_reservee", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_base_sandra_reservee", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra_non_retenue", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_base_sandra_non_retenue", CoordinateurA8Modele.CLOSE_SILENTLY),
	]
	var avant_a1: Dictionary = env["etat"].obtenir_snapshot()
	var ouverture: Dictionary = env["a8"].ouvrir_fenetre(
		_fenetre("a8_window_base", options), env["etat"], contexte
	)
	_expect(ouverture["ok"] and ouverture["window"]["options"].size() == 3, "02 creation fenetre valide avec plusieurs candidats")
	_expect(env["moteur"].obtenir_snapshot(env["etat"])["scene_registry"].is_empty(), "03 fenetre et candidats ephemeres non persistes")
	_expect(env["etat"].obtenir_snapshot() == avant_a1, "04 creation fenetre sans mutation A1")
	var reserve: Dictionary = env["a8"].agir_sur_option(
		"a8_window_base", "sandra_reservee", env["etat"], contexte, CoordinateurA7Modele.RESERVE
	)
	_expect(reserve["ok"] and reserve["state"] == CoordinateurA8Modele.RESERVED, "05 reservation option via A7")
	_expect(env["moteur"].obtenir_instance("a8_base_sandra_reservee").obtenir_statut() == "ELIGIBLE", "06 reservation garde etat A5 ELIGIBLE")
	_expect(env["etat"].obtenir_snapshot() == avant_a1, "07 reservation sans proposition ni absence")
	var propose: Dictionary = env["a8"].agir_sur_option(
		"a8_window_base", "raphaelle_visible", env["etat"], contexte, CoordinateurA7Modele.PROPOSE
	)
	_expect(propose["ok"] and propose["state"] == CoordinateurA8Modele.PROPOSED, "08 proposition option via A7")
	_expect(env["moteur"].obtenir_instance("a8_base_raphaelle").obtenir_statut() == "PROPOSED", "09 proposition cree instance PROPOSED")
	var fermeture: Dictionary = env["a8"].fermer_conflit_exclusif(
		"a8_window_base", "raphaelle_visible", env["etat"], contexte
	)
	_expect(fermeture["ok"] and fermeture["window"]["state"] == CoordinateurA8Modele.CLOSED, "10 conflit explicite ferme")
	_expect(_etat_option(fermeture["window"], "sandra_non_retenue") == CoordinateurA8Modele.NOT_SELECTED, "11 candidat non retenu ferme silencieusement")
	_expect(env["moteur"].obtenir_instance("a8_base_sandra_non_retenue") == null, "12 candidat non retenu sans instance ni absence")
	_expect(_etat_option(fermeture["window"], "sandra_reservee") == CoordinateurA8Modele.CANCELLED, "13 reservation interne annulee distincte")
	_expect(env["moteur"].obtenir_instance("a8_base_sandra_reservee").obtenir_statut() == "CANCELLED", "14 reservation annulee dans A5")
	_expect(env["etat"].obtenir_snapshot() == avant_a1, "15 CLOSE_SILENTLY sans consequence relationnelle")


func _test_mark_missed_if_proposed() -> void:
	var env := _environnement()
	_preparer_distance(env)
	var contexte := _contexte("2030-04-09T13:10:00+02:00", {"raphaelle": true, "sandra": true})
	var options := [
		_option("raphaelle_retenue", "r8c_a6_distance_raphaelle_definition", "raphaelle_distance", "a8_missed_raphaelle", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra_visible", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_missed_sandra_visible", CoordinateurA8Modele.MARK_MISSED_IF_PROPOSED),
		_option("sandra_jamais_visible", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_missed_sandra_silent", CoordinateurA8Modele.MARK_MISSED_IF_PROPOSED),
	]
	_expect(env["a8"].ouvrir_fenetre(_fenetre("a8_window_missed", options), env["etat"], contexte)["ok"], "16 fenetre MARK_MISSED ouverte")
	_expect(env["a8"].agir_sur_option("a8_window_missed", "raphaelle_retenue", env["etat"], contexte, CoordinateurA7Modele.PROPOSE)["ok"], "17 option retenue proposee")
	_expect(env["a8"].agir_sur_option("a8_window_missed", "sandra_visible", env["etat"], contexte, CoordinateurA7Modele.PROPOSE)["ok"], "18 alternative rendue reellement visible")
	var avant_a1: Dictionary = env["etat"].obtenir_snapshot()
	var ferme: Dictionary = env["a8"].fermer_conflit_exclusif(
		"a8_window_missed", "raphaelle_retenue", env["etat"], contexte
	)
	_expect(ferme["ok"], "19 conflit MARK_MISSED applique")
	_expect(_etat_option(ferme["window"], "sandra_visible") == CoordinateurA8Modele.MISSED, "20 seule alternative proposee devient MISSED")
	_expect(env["moteur"].obtenir_instance("a8_missed_sandra_visible").obtenir_statut() == "MISSED", "21 manque materialise via A5")
	_expect(_etat_option(ferme["window"], "sandra_jamais_visible") == CoordinateurA8Modele.NOT_SELECTED, "22 alternative jamais proposee reste non retenue")
	_expect(env["moteur"].obtenir_instance("a8_missed_sandra_silent") == null, "23 jamais proposee ne devient jamais absence")
	_expect(env["etat"].obtenir_snapshot() == avant_a1, "24 MISSED sans consequence non authored")


func _test_defer_ephemere_reevaluable() -> void:
	var env := _environnement()
	_preparer_distance(env)
	var contexte := _contexte("2030-04-09T13:20:00+02:00", {"raphaelle": true, "sandra": true})
	var options := [
		_option("raphaelle_retenue", "r8c_a6_distance_raphaelle_definition", "raphaelle_distance", "a8_defer_raphaelle", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra_differee", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_defer_sandra", CoordinateurA8Modele.DEFER),
	]
	env["a8"].ouvrir_fenetre(_fenetre("a8_window_defer", options), env["etat"], contexte)
	env["a8"].agir_sur_option("a8_window_defer", "raphaelle_retenue", env["etat"], contexte, CoordinateurA7Modele.RESERVE)
	var ferme: Dictionary = env["a8"].fermer_conflit_exclusif(
		"a8_window_defer", "raphaelle_retenue", env["etat"], contexte
	)
	_expect(ferme["ok"] and _etat_option(ferme["window"], "sandra_differee") == CoordinateurA8Modele.DEFERRED, "25 DEFER laisse candidat ephemere")
	_expect(env["moteur"].obtenir_instance("a8_defer_sandra") == null, "26 DEFER sans persistance implicite")
	var plus_tard := _contexte("2030-04-09T13:25:00+02:00", {"raphaelle": true, "sandra": true})
	var reevalue: Dictionary = env["a8"].reevaluer_option_differee(
		"a8_window_defer", "sandra_differee", env["etat"], plus_tard
	)
	_expect(reevalue["ok"] and reevalue["reevaluable"] and reevalue["eligible"] and reevalue.has("descriptor") and not reevalue["materialized"], "27 candidat differe reeligible et transferable plus tard")
	_expect(env["moteur"].obtenir_instance("a8_defer_sandra") == null, "28 reevaluation DEFER reste lecture seule")


func _test_rejeu_idempotent() -> void:
	var env := _environnement()
	_preparer_distance(env)
	var contexte := _contexte("2030-04-09T13:30:00+02:00", {"raphaelle": true, "sandra": true})
	var specification := _fenetre("a8_window_replay", [
		_option("raphaelle_retenue", "r8c_a6_distance_raphaelle_definition", "raphaelle_distance", "a8_replay_raphaelle", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra_non_retenue", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_replay_sandra", CoordinateurA8Modele.CLOSE_SILENTLY),
	])
	var premier: Dictionary = env["a8"].ouvrir_fenetre(specification, env["etat"], contexte)
	var replay_ouverture: Dictionary = env["a8"].ouvrir_fenetre(specification, env["etat"], contexte)
	_expect(premier["ok"] and replay_ouverture["ok"] and replay_ouverture["idempotent"], "29 ouverture rejouee idempotente")
	var action: Dictionary = env["a8"].agir_sur_option("a8_window_replay", "raphaelle_retenue", env["etat"], contexte, CoordinateurA7Modele.RESERVE)
	var snapshot_action: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var replay_action: Dictionary = env["a8"].agir_sur_option("a8_window_replay", "raphaelle_retenue", env["etat"], contexte, CoordinateurA7Modele.RESERVE)
	_expect(action["ok"] and replay_action["ok"] and replay_action["idempotent"], "30 action A7 rejouee idempotente")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == snapshot_action, "31 replay action sans mutation")
	var ferme: Dictionary = env["a8"].fermer_conflit_exclusif("a8_window_replay", "raphaelle_retenue", env["etat"], contexte)
	var snapshot_ferme: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var replay_ferme: Dictionary = env["a8"].fermer_conflit_exclusif("a8_window_replay", "raphaelle_retenue", env["etat"], contexte)
	_expect(ferme["ok"] and replay_ferme["ok"] and replay_ferme["idempotent"], "32 conflit rejoue idempotent")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == snapshot_ferme, "33 replay conflit sans mutation")
	_expect(not env["a8"].fermer_conflit_exclusif("a8_window_replay", "sandra_non_retenue", env["etat"], contexte)["ok"], "34 replay conflictuel refuse")


func _test_expiration_et_contexte_change_atomiques() -> void:
	var env := _environnement()
	_preparer_distance(env)
	var contexte := _contexte("2030-04-09T13:40:00+02:00", {"raphaelle": true, "sandra": true})
	var specification := _fenetre("a8_window_atomic", [
		_option("raphaelle", "r8c_a6_distance_raphaelle_definition", "raphaelle_distance", "a8_atomic_raphaelle", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_atomic_sandra", CoordinateurA8Modele.CLOSE_SILENTLY),
	], "2030-04-09T14:00:00+02:00")
	_expect(env["a8"].ouvrir_fenetre(specification, env["etat"], contexte)["ok"], "35 fenetre atomique ouverte")
	var avant: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var change := _contexte("2030-04-09T13:41:00+02:00", {"raphaelle": true, "sandra": false})
	var refuse_change: Dictionary = env["a8"].agir_sur_option_dev("a8_window_atomic", "raphaelle", env["etat"], change, CoordinateurA7Modele.PROPOSE)
	_expect(not refuse_change["ok"] and refuse_change["diagnostic"]["code"] == "CONTEXTE_FENETRE_CHANGE", "36 contexte change refuse avant A7")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant, "37 contexte change sans mutation partielle")
	var expire := _contexte("2030-04-09T14:00:00+02:00", {"raphaelle": true, "sandra": true})
	var refuse_expire: Dictionary = env["a8"].agir_sur_option_dev("a8_window_atomic", "raphaelle", env["etat"], expire, CoordinateurA7Modele.PROPOSE)
	_expect(not refuse_expire["ok"] and refuse_expire["diagnostic"]["code"] == "FENETRE_EXPIREE_OU_NON_OUVERTE", "38 fenetre expiree refusee")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant, "39 fenetre expiree sans mutation partielle")
	_expect(env["a8"].obtenir_fenetre("a8_window_atomic")["state"] == CoordinateurA8Modele.OPEN, "40 refus ne ferme pas la fenetre")


func _test_unique_repetable_provenance_et_diagnostics() -> void:
	var unique := _environnement()
	_preparer_distance(unique)
	var contexte := _contexte("2030-04-09T13:50:00+02:00", {"raphaelle": true, "sandra": true})
	var unique_options := [
		_option("raphaelle_a", "r8c_a6_distance_raphaelle_definition", "raphaelle_distance", "a8_unique_a", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("raphaelle_b", "r8c_a6_distance_raphaelle_definition", "raphaelle_distance", "a8_unique_b", CoordinateurA8Modele.CLOSE_SILENTLY),
	]
	_expect(unique["a8"].ouvrir_fenetre(_fenetre("a8_window_unique", unique_options), unique["etat"], contexte)["ok"], "41 deux candidats UNIQUE ephemeres associes avant choix")
	_expect(unique["a8"].agir_sur_option("a8_window_unique", "raphaelle_a", unique["etat"], contexte, CoordinateurA7Modele.RESERVE)["ok"], "42 premier UNIQUE reserve")
	var avant_unique: Dictionary = unique["moteur"].obtenir_snapshot(unique["etat"])
	_expect(not unique["a8"].agir_sur_option("a8_window_unique", "raphaelle_b", unique["etat"], contexte, CoordinateurA7Modele.RESERVE)["ok"], "43 second UNIQUE refuse a la revalidation")
	_expect(unique["moteur"].obtenir_snapshot(unique["etat"]) == avant_unique, "44 UNIQUE preserve sans mutation partielle")
	var unique_ferme: Dictionary = unique["a8"].fermer_conflit_exclusif(
		"a8_window_unique", "raphaelle_a", unique["etat"], contexte
	)
	_expect(unique_ferme["ok"], "alternative UNIQUE perdante fermable apres choix")
	_expect(_etat_option(unique_ferme["window"], "raphaelle_b") == CoordinateurA8Modele.NOT_SELECTED, "alternative UNIQUE perdante non retenue silencieusement")

	var repeat := _environnement()
	_preparer_distance(repeat)
	var repeat_options := [
		_option("sandra_a", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_repeat_a", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra_b", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_repeat_b", CoordinateurA8Modele.CLOSE_SILENTLY),
	]
	var ouverture_dev: Dictionary = repeat["a8"].ouvrir_fenetre_dev(_fenetre("a8_window_repeat", repeat_options), repeat["etat"], contexte)
	_expect(ouverture_dev["ok"] and ouverture_dev.has("diagnostic"), "45 diagnostics dev complets")
	var runtime: Dictionary = repeat["a8"].obtenir_fenetre("a8_window_repeat")
	_expect(not runtime.has("diagnostic") and "preuve_provenance" not in str(runtime), "46 surface runtime assainie sans preuve A6")
	var repeat_a: Dictionary = repeat["a8"].agir_sur_option("a8_window_repeat", "sandra_a", repeat["etat"], contexte, CoordinateurA7Modele.RESERVE)
	var repeat_b: Dictionary = repeat["a8"].agir_sur_option("a8_window_repeat", "sandra_b", repeat["etat"], contexte, CoordinateurA7Modele.PROPOSE)
	_expect(repeat_a["ok"] and repeat_b["ok"], "47 REPETABLE preserve deux materialisations")
	_expect(repeat["moteur"].obtenir_snapshot(repeat["etat"])["scene_registry"].size() == 2, "48 seules instances A5 materialisees persistees")
	_expect(repeat_a["instance_id"] != repeat_b["instance_id"], "49 identites options et instances stables distinctes")
	_expect(repeat["etat"].obtenir_snapshot()["evenements"].size() == 2, "50 aucune mutation A1 hors preconditions explicites")
	var forge_spec := _fenetre("a8_window_forge", repeat_options)
	forge_spec["options"][0]["variant_id"] = "variante_fabriquee"
	forge_spec["options"][0]["instance_id"] = "a8_forge_a"
	forge_spec["options"][1]["instance_id"] = "a8_forge_b"
	var avant_forge: Dictionary = repeat["moteur"].obtenir_snapshot(repeat["etat"])
	var forge: Dictionary = repeat["a8"].ouvrir_fenetre_dev(forge_spec, repeat["etat"], contexte)
	_expect(not forge["ok"] and forge["diagnostic"]["code"] == "OPTION_A6_INELIGIBLE", "51 identite A6 fabriquee refusee")
	_expect(repeat["moteur"].obtenir_snapshot(repeat["etat"]) == avant_forge, "52 provenance A6 A7 fermee sans mutation")
	var invalide := _fenetre("a8_window_policy", repeat_options)
	invalide["options"][0]["conflict_policy"] = "POLITIQUE_INVENTEE"
	_expect(not repeat["a8"].ouvrir_fenetre(invalide, repeat["etat"], contexte)["ok"], "53 politiques limitees aux trois autorisees")
	_expect(not repeat["a8"].agir_sur_option("a8_window_repeat", "sandra_a", repeat["etat"], contexte, "AUTO_SELECT")["ok"], "54 aucune intention de selection automatique")
	_expect(runtime["options"].size() == 2 and runtime["selected_option_id"].is_empty(), "55 aucune option choisie a l ouverture")
	_expect(repeat["moteur"].obtenir_snapshot(repeat["etat"])["scene_registry"].size() == 2, "56 echec politique sans instance supplementaire")
	_expect(repeat["etat"].obtenir_snapshot()["evenements"].size() == 2, "57 aucune regression A1 A3 A5 A6 A7")
	var reuse_spec := _fenetre("a8_window_reuse", [
		_option("sandra_reuse", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_repeat_a", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra_new", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_owner_new", CoordinateurA8Modele.CLOSE_SILENTLY),
	])
	var avant_reuse: Dictionary = repeat["moteur"].obtenir_snapshot(repeat["etat"])
	var reuse: Dictionary = repeat["a8"].ouvrir_fenetre_dev(reuse_spec, repeat["etat"], contexte)
	_expect(not reuse["ok"] and reuse["diagnostic"]["code"] == "INSTANCE_ID_DEJA_ASSOCIE", "instance A5 non partageable entre fenetres")
	_expect(repeat["moteur"].obtenir_snapshot(repeat["etat"]) == avant_reuse, "ownership inter fenetres sans mutation")
	var temps_invalide := _fenetre("a8_window_bad_time", [
		_option("sandra_time_a", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_time_a", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra_time_b", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_time_b", CoordinateurA8Modele.CLOSE_SILENTLY),
	])
	temps_invalide["opens_at"] = "2030-04-09T12:00:99+02:00"
	_expect(not repeat["a8"].ouvrir_fenetre(temps_invalide, repeat["etat"], contexte)["ok"], "instant A8 strictement normalise comme A5")


func _test_politiques_incompatibles_atomiques() -> void:
	var env := _environnement()
	_preparer_distance(env)
	var contexte := _contexte("2030-04-09T14:10:00+02:00", {"raphaelle": true, "sandra": true})
	var options := [
		_option("raphaelle_close", "r8c_a6_distance_raphaelle_definition", "raphaelle_distance", "a8_close_visible_a", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra_close", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_close_visible_b", CoordinateurA8Modele.CLOSE_SILENTLY),
	]
	env["a8"].ouvrir_fenetre(_fenetre("a8_window_close_visible", options), env["etat"], contexte)
	env["a8"].agir_sur_option("a8_window_close_visible", "raphaelle_close", env["etat"], contexte, CoordinateurA7Modele.PROPOSE)
	env["a8"].agir_sur_option("a8_window_close_visible", "sandra_close", env["etat"], contexte, CoordinateurA7Modele.PROPOSE)
	var avant_close: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var close_refuse: Dictionary = env["a8"].fermer_conflit_exclusif_dev(
		"a8_window_close_visible", "raphaelle_close", env["etat"], contexte
	)
	_expect(not close_refuse["ok"] and close_refuse["diagnostic"]["code"] == "POLITIQUE_INCOMPATIBLE_AVEC_ETAT", "CLOSE_SILENTLY refuse alternative visible")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant_close, "politique incompatible sans commit partiel")
	_expect(env["moteur"].obtenir_instance("a8_close_visible_b").obtenir_statut() == "PROPOSED", "alternative visible intacte apres refus")

	var bundle = JSON.parse_string(FileAccess.get_file_as_string(BUNDLE_PATH))
	bundle["definitions"][1]["definition"]["politique_non_resolution"]["proposition_expire"] = "CANCELLED"
	var cancelled := _environnement_depuis_bundle(bundle)
	_preparer_distance(cancelled)
	var cancelled_options := [
		_option("sandra_keep", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_cancelled_keep", CoordinateurA8Modele.CLOSE_SILENTLY),
		_option("sandra_mark", "r8c_a6_distance_sandra_definition", "sandra_distance", "a8_cancelled_mark", CoordinateurA8Modele.MARK_MISSED_IF_PROPOSED),
	]
	cancelled["a8"].ouvrir_fenetre(_fenetre("a8_window_cancelled_policy", cancelled_options), cancelled["etat"], contexte)
	cancelled["a8"].agir_sur_option("a8_window_cancelled_policy", "sandra_keep", cancelled["etat"], contexte, CoordinateurA7Modele.PROPOSE)
	cancelled["a8"].agir_sur_option("a8_window_cancelled_policy", "sandra_mark", cancelled["etat"], contexte, CoordinateurA7Modele.PROPOSE)
	var avant_cancelled: Dictionary = cancelled["moteur"].obtenir_snapshot(cancelled["etat"])
	var mismatch: Dictionary = cancelled["a8"].fermer_conflit_exclusif_dev(
		"a8_window_cancelled_policy", "sandra_keep", cancelled["etat"], contexte
	)
	_expect(not mismatch["ok"] and mismatch["diagnostic"]["code"] == "POLITIQUE_A5_INCOMPATIBLE_AVEC_MISSED", "MARK_MISSED refuse cible A5 CANCELLED")
	_expect(cancelled["moteur"].obtenir_snapshot(cancelled["etat"]) == avant_cancelled, "mismatch MISSED CANCELLED sans mutation partielle")
	_expect(cancelled["moteur"].obtenir_instance("a8_cancelled_mark").obtenir_statut() == "PROPOSED", "A8 et A5 restent coherents apres mismatch")


func _environnement() -> Dictionary:
	var charge: Dictionary = BibliothequeModele.charger_depuis_json(BUNDLE_PATH)
	return _environnement_depuis_charge(charge)


func _environnement_depuis_bundle(bundle) -> Dictionary:
	return _environnement_depuis_charge(BibliothequeModele.charger_depuis_bundle(bundle))


func _environnement_depuis_charge(charge: Dictionary) -> Dictionary:
	if not charge["ok"]:
		return {}
	var moteur := MoteurModele.new()
	var a7 = CoordinateurA7Modele.creer(charge["bibliotheque"], moteur)
	var a8 = CoordinateurA8Modele.creer(charge["bibliotheque"], moteur, a7)
	if a7 == null or a8 == null:
		return {}
	return {
		"bibliotheque": charge["bibliotheque"],
		"moteur": moteur,
		"a7": a7,
		"a8": a8,
		"etat": _nouvel_etat(),
	}


func _preparer_distance(env: Dictionary) -> void:
	_ajouter_evenement(env["etat"], "r8c-a6-sandra-away", "sandra")
	_ajouter_evenement(env["etat"], "r8c-a6-raphaelle-away", "raphaelle")


func _fenetre(window_id: String, options: Array, closes_at: String = "2030-04-09T18:00:00+02:00") -> Dictionary:
	return {
		"window_id": window_id,
		"opens_at": "2030-04-09T12:00:00+02:00",
		"closes_at": closes_at,
		"context": {
			"acte_courant": "ACTE_SYNTHETIQUE_A6",
			"participants_disponibles": {"raphaelle": true, "sandra": true},
			"opportunite_valide": true,
		},
		"options": options,
	}


func _option(
	option_id: String,
	scene_definition_id: String,
	variant_id: String,
	instance_id: String,
	conflict_policy: String
) -> Dictionary:
	return {
		"option_id": option_id,
		"scene_definition_id": scene_definition_id,
		"variant_id": variant_id,
		"instance_id": instance_id,
		"conflict_policy": conflict_policy,
	}


func _contexte(moment: String, disponibilites: Dictionary) -> Dictionary:
	return {
		"acte_courant": "ACTE_SYNTHETIQUE_A6",
		"moment_diegetique": moment,
		"participants_disponibles": disponibilites,
		"opportunite_valide": true,
	}


func _etat_option(fenetre: Dictionary, option_id: String) -> String:
	for option in fenetre["options"]:
		if option["option_id"] == option_id:
			return option["state"]
	return ""


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
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "r8c_a8_smoke"},
		"payload": {"personnage_id": personnage_id, "changements": {"faits": faits}},
	})
	return resultat["ok"]


func _expect(condition: bool, message: String) -> void:
	controles += 1
	if not condition:
		failures.append(message)
