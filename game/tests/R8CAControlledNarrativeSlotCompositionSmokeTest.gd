extends Node

const BibliothequeModele := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const CoordinateurA7Modele := preload("res://scripts/narrative_scene/CandidateReservationProposalCoordinator.gd")
const CoordinateurA8Modele := preload("res://scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd")
const CoordinateurA9Modele := preload("res://scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd")
const MoteurModele := preload("res://scripts/narrative_scene/MinimalSceneEngine.gd")
const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")
const BUNDLE_PATH := "res://data/narrative_scenes/r8c_a6_prototype_library.json"

var failures: Array[String] = []
var controles := 0


func _ready() -> void:
	_executer()
	if controles != 66:
		failures.append("nombre de controles inattendu: %d/66" % controles)
	if failures.is_empty():
		print("R8C_A9_CONTROLLED_NARRATIVE_SLOT_COMPOSITION: OK (%d controles)" % controles)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)


func _executer() -> void:
	_test_composition_valide_ordre_et_determinisme()
	_test_aucun_reordonnancement_et_refus_atomique()
	_test_entrees_invalides_et_depassements()
	_test_empreintes_liees_aux_entrees()
	_test_revalidation_obsolescence_et_absence_de_mutation()
	_test_surface_runtime_et_frontieres()


func _test_composition_valide_ordre_et_determinisme() -> void:
	var env := _environnement()
	_expect(not env.is_empty(), "01 environnement A9 charge")
	_ouvrir_fenetres(env, ["alpha", "beta", "gamma"])
	var avant_a1: Dictionary = env["etat"].obtenir_snapshot()
	var avant_a5: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var specification := _specification(
		"slot_valide",
		[
			_description("beta", 15, "2030-04-09T13:00:00+02:00", "2030-04-09T14:30:00+02:00"),
			_description("alpha", 20, "2030-04-09T13:10:00+02:00", "2030-04-09T14:30:00+02:00"),
		],
		["alpha", "beta"],
	)
	var premier: Dictionary = env["a9"].composer(specification, env["etat"])
	_expect(premier["ok"], "02 composition valide de plusieurs fenetres dans un creneau")
	var plan: Dictionary = premier["plan"]
	_expect(plan["format"] == CoordinateurA9Modele.FORMAT_PLAN, "03 format de plan A9 ferme")
	_expect(plan["windows"].size() == 2, "04 deux fenetres explicitement planifiees")
	_expect(plan["author_order"] == ["alpha", "beta"], "05 ordre auteur respecte exactement")
	_expect(plan["windows"][0]["window_id"] == "alpha" and plan["windows"][1]["window_id"] == "beta", "06 implantation conserve l ordre auteur")
	_expect(plan["windows"][0]["starts_at"] == "2030-04-09T13:10:00+02:00", "07 earliest-fit prend la premiere borne compatible")
	_expect(plan["windows"][0]["ends_at"] == "2030-04-09T13:30:00+02:00", "08 duree estimee implantee exactement")
	_expect(plan["windows"][1]["starts_at"] == "2030-04-09T13:30:00+02:00", "09 fenetre suivante commence au plus tot sans chevauchement")
	_expect(plan["windows"][1]["ends_at"] == "2030-04-09T13:45:00+02:00", "10 programme temporel borne")
	var replay: Dictionary = env["a9"].composer(specification.duplicate(true), env["etat"])
	_expect(replay["ok"] and replay["plan"] == plan, "11 plan deterministe et idempotent pour la meme entree")
	_expect(replay["plan"]["fingerprint"] == plan["fingerprint"], "12 empreinte deterministe au rejeu")
	_expect(env["etat"].obtenir_snapshot() == avant_a1, "13 composition sans mutation A1")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant_a5, "14 plan ephemere aucun snapshot A5 modifie")
	_expect(env["moteur"].obtenir_snapshot(env["etat"])["scene_registry"].is_empty(), "15 aucune instance reservation proposition ou absence creee")


func _test_aucun_reordonnancement_et_refus_atomique() -> void:
	var env := _environnement()
	_ouvrir_fenetres(env, ["longue", "etroite"])
	var descriptions := [
		_description("longue", 40, "2030-04-09T13:00:00+02:00", "2030-04-09T14:00:00+02:00"),
		_description("etroite", 20, "2030-04-09T13:00:00+02:00", "2030-04-09T13:30:00+02:00"),
	]
	var avant: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var impossible: Dictionary = env["a9"].composer_dev(
		_specification("slot_ordre_impossible", descriptions, ["longue", "etroite"]),
		env["etat"],
	)
	_expect(not impossible["ok"] and impossible["diagnostic"]["code"] == "ORDRE_AUTEUR_IMPOSSIBLE", "16 ordre auteur qui ne tient pas refuse")
	_expect(impossible["diagnostic"]["window_id"] == "etroite", "17 diagnostic borne identifie la fenetre impossible")
	_expect(impossible["plan"].is_empty(), "18 aucun plan partiel retourne")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant, "19 chevauchement ou depassement refuse atomiquement")
	var inverse: Dictionary = env["a9"].composer(
		_specification("slot_ordre_inverse", descriptions, ["etroite", "longue"]),
		env["etat"],
	)
	_expect(inverse["ok"], "20 ordre inverse tient sans recherche implicite")
	_expect(inverse["plan"]["author_order"] == ["etroite", "longue"], "21 caller reste seul auteur de l ordre")
	_expect(inverse["plan"]["windows"][0]["window_id"] == "etroite", "22 aucune tentative de reordonnancement automatique")


func _test_entrees_invalides_et_depassements() -> void:
	var env := _environnement()
	_ouvrir_fenetres(env, ["valide"])
	var base := _specification(
		"slot_invalides",
		[_description("valide", 20, "2030-04-09T13:00:00+02:00", "2030-04-09T14:00:00+02:00")],
		["valide"],
	)
	var avant: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var doublon := base.duplicate(true)
	doublon["windows"].append(doublon["windows"][0].duplicate(true))
	doublon["author_order"].append("valide")
	_expect(not env["a9"].composer_dev(doublon, env["etat"])["ok"], "23 doublon de fenetre refuse")
	var ordre_duplique := base.duplicate(true)
	ordre_duplique["author_order"] = ["valide", "valide"]
	_expect(not env["a9"].composer(ordre_duplique, env["etat"])["ok"], "24 doublon dans ordre auteur refuse")
	var duree_nulle := base.duplicate(true)
	duree_nulle["windows"][0]["duration_minutes"] = 0
	_expect(not env["a9"].composer(duree_nulle, env["etat"])["ok"], "25 duree nulle refusee")
	var duree_negative := base.duplicate(true)
	duree_negative["windows"][0]["duration_minutes"] = -1
	_expect(not env["a9"].composer(duree_negative, env["etat"])["ok"], "26 duree negative refusee")
	var date_invalide := base.duplicate(true)
	date_invalide["narrative_date"] = "2030-02-30"
	_expect(not env["a9"].composer(date_invalide, env["etat"])["ok"], "27 date narrative invalide refusee")
	var heure_invalide := base.duplicate(true)
	heure_invalide["starts_at"] = "2030-04-09T25:00:00+02:00"
	_expect(not env["a9"].composer(heure_invalide, env["etat"])["ok"], "28 heure invalide refusee")
	var type_heure_invalide := base.duplicate(true)
	type_heure_invalide["starts_at"] = 1300
	_expect(not env["a9"].composer(type_heure_invalide, env["etat"])["ok"], "28b type heure invalide refuse sans erreur GDScript")
	var hors_borne := base.duplicate(true)
	hors_borne["windows"][0]["not_before"] = "2030-04-09T12:50:00+02:00"
	_expect(not env["a9"].composer(hors_borne, env["etat"])["ok"], "29 fenetre hors borne du creneau refusee")
	var inconnue := base.duplicate(true)
	inconnue["windows"][0]["window_id"] = "inconnue"
	inconnue["author_order"] = ["inconnue"]
	_expect(not env["a9"].composer(inconnue, env["etat"])["ok"], "30 fenetre A8 inconnue refusee")
	var depasse := base.duplicate(true)
	depasse["windows"][0]["duration_minutes"] = 70
	_expect(not env["a9"].composer(depasse, env["etat"])["ok"], "31 depassement du creneau refuse")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant, "32 entrees invalides sans aucune mutation")


func _test_empreintes_liees_aux_entrees() -> void:
	var env := _environnement()
	_ouvrir_fenetres(env, ["un", "deux", "trois"])
	var descriptions := [
		_description("un", 15, "2030-04-09T13:00:00+02:00", "2030-04-09T14:30:00+02:00"),
		_description("deux", 15, "2030-04-09T13:00:00+02:00", "2030-04-09T14:30:00+02:00"),
	]
	var plan_base: Dictionary = env["a9"].composer(
		_specification("slot_empreinte", descriptions, ["un", "deux"]), env["etat"]
	)["plan"]
	var plan_ordre: Dictionary = env["a9"].composer(
		_specification("slot_empreinte", descriptions, ["deux", "un"]), env["etat"]
	)["plan"]
	_expect(plan_base["fingerprint"] != plan_ordre["fingerprint"], "33 empreinte de plan change si ordre change")
	var fenetres_changees := [
		descriptions[0].duplicate(true),
		_description("trois", 15, "2030-04-09T13:00:00+02:00", "2030-04-09T14:30:00+02:00"),
	]
	var plan_fenetres: Dictionary = env["a9"].composer(
		_specification("slot_empreinte", fenetres_changees, ["un", "trois"]), env["etat"]
	)["plan"]
	_expect(plan_base["fingerprint"] != plan_fenetres["fingerprint"], "34 empreinte de plan change si fenetres changent")
	var autre := _environnement()
	var contexte_autre := _contexte("2030-04-09T12:00:00+02:00", {"raphaelle": true, "sandra": true, "marie": true})
	_ouvrir_fenetres(autre, ["un", "deux"], contexte_autre)
	var specification_autre := _specification("slot_empreinte", descriptions, ["un", "deux"])
	specification_autre["context"] = contexte_autre
	var plan_contexte: Dictionary = autre["a9"].composer(specification_autre, autre["etat"])["plan"]
	_expect(plan_base["fingerprint"] != plan_contexte["fingerprint"], "35 empreinte de plan change si contexte change")
	_expect(plan_base["windows"][0]["window_fingerprint"].length() == 64, "36 empreinte liee a l identite A8")
	_expect(plan_base["fingerprint"].length() == 64, "37 empreinte SHA-256 bornee")


func _test_revalidation_obsolescence_et_absence_de_mutation() -> void:
	var env := _environnement()
	_ouvrir_fenetres(env, ["revalide_a", "revalide_b"])
	var specification := _specification(
		"slot_revalidation",
		[
			_description("revalide_a", 20, "2030-04-09T13:00:00+02:00", "2030-04-09T14:30:00+02:00"),
			_description("revalide_b", 20, "2030-04-09T13:00:00+02:00", "2030-04-09T14:30:00+02:00"),
		],
		["revalide_a", "revalide_b"],
	)
	var plan: Dictionary = env["a9"].composer(specification, env["etat"])["plan"]
	var avant: Dictionary = env["moteur"].obtenir_snapshot(env["etat"])
	var courant := _contexte("2030-04-09T12:30:00+02:00")
	var revalide: Dictionary = env["a9"].revalider_plan(plan, env["etat"], courant)
	_expect(revalide["ok"] and revalide["valid"], "38 plan revalide avant utilisation")
	_expect(revalide["fingerprint"] == plan["fingerprint"], "39 revalidation conserve empreinte")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant, "40 revalidation valide sans mutation")
	var change := _contexte("2030-04-09T12:31:00+02:00", {"raphaelle": true, "sandra": false})
	var refuse_change: Dictionary = env["a9"].revalider_plan_dev(plan, env["etat"], change)
	_expect(not refuse_change["ok"] and refuse_change["diagnostic"]["code"] == "CONTEXTE_PLAN_CHANGE", "41 contexte change rend plan obsolete")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant, "42 contexte change sans mutation")
	var expire := _contexte("2030-04-09T14:30:00+02:00")
	var refuse_expire: Dictionary = env["a9"].revalider_plan_dev(plan, env["etat"], expire)
	_expect(not refuse_expire["ok"] and refuse_expire["diagnostic"]["code"] == "FENETRE_EXPIREE", "43 fenetre expiree rend plan obsolete")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant, "44 fenetre expiree sans mutation")
	var depasse := _contexte("2030-04-09T13:10:00+02:00")
	var refuse_depasse: Dictionary = env["a9"].revalider_plan_dev(plan, env["etat"], depasse)
	_expect(not refuse_depasse["ok"] and refuse_depasse["diagnostic"]["code"] == "INSTANT_PLANIFIE_DEPASSE", "44b implantation deja depassee refusee")
	var falsifie := plan.duplicate(true)
	falsifie["fingerprint"] = "0".repeat(64)
	_expect(not env["a9"].revalider_plan_dev(falsifie, env["etat"], courant)["ok"], "45 empreinte falsifiee refusee")
	var chevauche := plan.duplicate(true)
	chevauche["windows"][1]["starts_at"] = "2030-04-09T13:10:00+02:00"
	chevauche["windows"][1]["ends_at"] = "2030-04-09T13:30:00+02:00"
	var refuse_chevauche: Dictionary = env["a9"].revalider_plan_dev(chevauche, env["etat"], courant)
	_expect(not refuse_chevauche["ok"] and refuse_chevauche["diagnostic"]["code"] == "CHEVAUCHEMENT_PLAN", "46 chevauchement detecte avant utilisation")
	_expect(env["moteur"].obtenir_snapshot(env["etat"]) == avant, "47 plans invalides refuses sans mutation")
	var decale := plan.duplicate(true)
	decale["windows"][0]["starts_at"] = "2030-04-09T13:10:00+02:00"
	decale["windows"][0]["ends_at"] = "2030-04-09T13:30:00+02:00"
	decale["windows"][1]["starts_at"] = "2030-04-09T13:30:00+02:00"
	decale["windows"][1]["ends_at"] = "2030-04-09T13:50:00+02:00"
	_recalculer_empreinte(decale)
	var refuse_decale: Dictionary = env["a9"].revalider_plan_dev(decale, env["etat"], courant)
	_expect(not refuse_decale["ok"] and refuse_decale["diagnostic"]["code"] == "IMPLANTATION_NON_CANONIQUE", "47b plan decale reempreinte refuse car non canonique")
	var contraintes_hors_slot := plan.duplicate(true)
	contraintes_hors_slot["windows"][0]["not_before"] = "2030-04-09T12:50:00+02:00"
	_recalculer_empreinte(contraintes_hors_slot)
	var refuse_contraintes: Dictionary = env["a9"].revalider_plan_dev(
		contraintes_hors_slot, env["etat"], courant
	)
	_expect(not refuse_contraintes["ok"] and refuse_contraintes["diagnostic"]["code"] == "FENETRE_PLAN_HORS_CRENEAU", "47c contraintes de plan hors creneau refusees")


func _test_surface_runtime_et_frontieres() -> void:
	var env := _environnement()
	_ouvrir_fenetres(env, ["frontiere"])
	var specification := _specification(
		"slot_frontiere",
		[_description("frontiere", 20, "2030-04-09T13:00:00+02:00", "2030-04-09T14:00:00+02:00")],
		["frontiere"],
	)
	var avant_a1: Dictionary = env["etat"].obtenir_snapshot()
	var runtime: Dictionary = env["a9"].composer(specification, env["etat"])
	_expect(runtime["ok"] and not runtime.has("diagnostic"), "48 surface runtime assainie")
	_expect("preuve_provenance" not in str(runtime), "49 provenance A8 fermee")
	var dev: Dictionary = env["a9"].composer_dev(specification, env["etat"])
	_expect(dev["ok"] and dev["diagnostic"]["code"] == "PLAN_CRENEAU_COMPOSE", "50 diagnostics dev complets")
	_expect(dev["diagnostic"]["strategie"] == "EARLIEST_FIT_ORDRE_AUTEUR", "51 strategie explicite seulement en diagnostic dev")
	var erreur_runtime: Dictionary = env["a9"].composer({}, env["etat"])
	_expect(not erreur_runtime["ok"] and not erreur_runtime.has("diagnostic"), "52 echec runtime assaini")
	_expect(env["a8"].obtenir_fenetre("frontiere")["selected_option_id"].is_empty(), "53 A9 ne choisit aucune option A8")
	_expect(env["a8"].obtenir_fenetre("frontiere")["state"] == CoordinateurA8Modele.OPEN, "54 A9 ne ferme aucune fenetre A8")
	_expect(env["moteur"].obtenir_instance("a9_frontiere_raphaelle") == null, "55 aucune instance A5 creee")
	_expect(env["moteur"].obtenir_instance("a9_frontiere_sandra") == null, "56 aucune reservation ou proposition creee")
	_expect(env["etat"].obtenir_snapshot() == avant_a1, "57 aucun evenement A1 cree")
	_expect(env["moteur"].obtenir_snapshot(env["etat"])["scene_registry"].is_empty(), "58 aucun statut MISSED cree")
	var revalidation: Dictionary = env["a9"].revalider_plan_dev(
		runtime["plan"], env["etat"], _contexte("2030-04-09T12:20:00+02:00")
	)
	_expect(revalidation["ok"] and revalidation["diagnostic"]["fenetres_revalidees"] == 1, "59 execution reelle reste deleguee apres revalidation")
	_expect(not runtime["plan"].has("snapshot"), "60 plan ephemere sans forme persistante")
	_expect(runtime["plan"]["windows"][0]["author_position"] == 0, "61 ordre auteur stable et borne")
	_expect(env["moteur"].obtenir_snapshot(env["etat"])["scene_registry"].is_empty() and env["etat"].obtenir_snapshot() == avant_a1, "62 invariants A1 A3 A5 A6 A7 A8 conserves")


func _environnement() -> Dictionary:
	var charge: Dictionary = BibliothequeModele.charger_depuis_json(BUNDLE_PATH)
	if not charge["ok"]:
		return {}
	var moteur := MoteurModele.new()
	var a7 = CoordinateurA7Modele.creer(charge["bibliotheque"], moteur)
	var a8 = CoordinateurA8Modele.creer(charge["bibliotheque"], moteur, a7)
	var a9 = CoordinateurA9Modele.creer(a8)
	if a7 == null or a8 == null or a9 == null:
		return {}
	var etat = _nouvel_etat()
	_ajouter_evenement(etat, "r8c-a6-sandra-away", "sandra")
	_ajouter_evenement(etat, "r8c-a6-raphaelle-away", "raphaelle")
	return {"bibliotheque": charge["bibliotheque"], "moteur": moteur, "a7": a7, "a8": a8, "a9": a9, "etat": etat}


func _ouvrir_fenetres(
	env: Dictionary,
	window_ids: Array,
	contexte: Dictionary = {}
) -> void:
	var contexte_effectif := (
		_contexte("2030-04-09T12:00:00+02:00") if contexte.is_empty() else contexte
	)
	for window_id in window_ids:
		var options := [
			_option(
				window_id + "_raphaelle",
				"r8c_a6_distance_raphaelle_definition",
				"raphaelle_distance",
				"a9_" + window_id + "_raphaelle"
			),
			_option(
				window_id + "_sandra",
				"r8c_a6_distance_sandra_definition",
				"sandra_distance",
				"a9_" + window_id + "_sandra"
			),
		]
		var specification := {
			"window_id": window_id,
			"opens_at": "2030-04-09T12:00:00+02:00",
			"closes_at": "2030-04-09T14:30:00+02:00",
			"context": {
				"acte_courant": contexte_effectif["acte_courant"],
				"participants_disponibles": contexte_effectif["participants_disponibles"].duplicate(true),
				"opportunite_valide": contexte_effectif["opportunite_valide"],
			},
			"options": options,
		}
		var ouverture: Dictionary = env["a8"].ouvrir_fenetre_dev(
			specification, env["etat"], contexte_effectif
		)
		if not ouverture["ok"]:
			failures.append(
				"ouverture A8 echouee: %s (%s)" % [
					window_id,
					ouverture.get("diagnostic", {}).get("code", ouverture["erreur"]),
				]
			)


func _specification(slot_id: String, windows: Array, author_order: Array) -> Dictionary:
	return {
		"slot_id": slot_id,
		"narrative_date": "2030-04-09",
		"starts_at": "2030-04-09T13:00:00+02:00",
		"ends_at": "2030-04-09T14:30:00+02:00",
		"context": _contexte("2030-04-09T12:00:00+02:00"),
		"windows": windows,
		"author_order": author_order,
	}


func _description(
	window_id: String,
	duration_minutes: int,
	not_before: String,
	not_after: String
) -> Dictionary:
	return {
		"window_id": window_id,
		"duration_minutes": duration_minutes,
		"not_before": not_before,
		"not_after": not_after,
	}


func _option(
	option_id: String,
	scene_definition_id: String,
	variant_id: String,
	instance_id: String
) -> Dictionary:
	return {
		"option_id": option_id,
		"scene_definition_id": scene_definition_id,
		"variant_id": variant_id,
		"instance_id": instance_id,
		"conflict_policy": CoordinateurA8Modele.CLOSE_SILENTLY,
	}


static func _contexte(
	moment: String,
	disponibilites: Dictionary = {}
) -> Dictionary:
	var participants := (
		{"raphaelle": true, "sandra": true}
		if disponibilites.is_empty()
		else disponibilites
	)
	return {
		"acte_courant": "ACTE_SYNTHETIQUE_A6",
		"moment_diegetique": moment,
		"participants_disponibles": participants,
		"opportunite_valide": true,
	}


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
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "r8c_a9_smoke"},
		"payload": {"personnage_id": personnage_id, "changements": {"faits": faits}},
	})
	return resultat["ok"]


static func _recalculer_empreinte(plan: Dictionary) -> void:
	var contenu := plan.duplicate(true)
	contenu.erase("fingerprint")
	plan["fingerprint"] = JSON.stringify(contenu, "", true, true).sha256_text()


func _expect(condition: bool, message: String) -> void:
	controles += 1
	if not condition:
		failures.append(message)
