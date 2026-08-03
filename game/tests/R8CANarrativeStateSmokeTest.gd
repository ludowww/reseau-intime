extends Node

const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")

var failures: Array[String] = []


func _ready() -> void:
	_executer()
	if failures.is_empty():
		print("R8C_A1_NARRATIVE_STATE: OK")
		get_tree().quit(0)
	else:
		print("R8C_A1_NARRATIVE_STATE: FAILED " + str(failures))
		get_tree().quit(1)


func _expect(condition: bool, label: String) -> void:
	if not condition:
		failures.append(label)


func _executer() -> void:
	_test_construction_et_registres()
	_test_invariants_relation_centrale()
	_test_cadre_provisoire()
	_test_transactions_atomiques()
	_test_rejet_sans_mutation()
	_test_idempotence()
	_test_encapsulation_entree()
	_test_encapsulation_sortie()


func _test_construction_et_registres() -> void:
	var etat = _nouvel_etat()
	_expect(etat != null, "01 construction valide")
	if etat == null:
		return
	var snapshot: Dictionary = etat.obtenir_snapshot()
	_expect(snapshot["relations"].size() == 6, "02 exactement six relations")
	_expect(not snapshot["relations"].has("player"), "03 aucune relation player")
	_expect(snapshot["relations"]["nico"]["desir"] == "NONE", "04 nico desir NONE")
	var registres_vides := true
	for registre in ["evenements", "promesses", "obligations", "traces_narratives", "connaissances", "livraison_medias"]:
		registres_vides = registres_vides and snapshot[registre].is_empty()
	var progression: Dictionary = snapshot["progression_saison"]
	_expect(registres_vides and progression["acte_courant"] == null, "05 registres initiaux vides ou minimaux")


func _test_invariants_relation_centrale() -> void:
	var etat = _nouvel_etat()
	var resultat: Dictionary = etat.traiter_evenement(_evenement_central("central-ensemble-sans-contrat", {
		"statut_couple": "ENSEMBLE",
		"contrat_couple": null,
		"relation_apres_separation": null,
	}))
	_expect(resultat["statut"] == "REJETE", "06 rejet ENSEMBLE sans contrat")

	etat = _nouvel_etat()
	resultat = etat.traiter_evenement(_evenement_central("central-ensemble-apres-separation", {
		"statut_couple": "ENSEMBLE",
		"contrat_couple": "EXCLUSIF",
		"relation_apres_separation": "BLESSEE",
	}))
	_expect(resultat["statut"] == "REJETE", "07 rejet ENSEMBLE avec relation post-separation")

	etat = _nouvel_etat()
	resultat = etat.traiter_evenement(_evenement_central("central-separes-contrat", {
		"statut_couple": "SEPARES",
		"contrat_couple": "OUVERT",
		"relation_apres_separation": "BONS_TERMES",
	}))
	_expect(resultat["statut"] == "REJETE", "08 rejet SEPARES avec contrat")

	etat = _nouvel_etat()
	resultat = etat.traiter_evenement(_evenement_central("central-separes-sans-suite", {
		"statut_couple": "SEPARES",
		"contrat_couple": null,
		"relation_apres_separation": null,
	}))
	_expect(resultat["statut"] == "REJETE", "09 rejet SEPARES sans relation post-separation")

	etat = _nouvel_etat()
	resultat = etat.traiter_evenement(_evenement_central("central-clarification-sans-contrat", {
		"statut_couple": "EN_CLARIFICATION",
		"contrat_couple": null,
		"relation_apres_separation": null,
	}))
	_expect(resultat["statut"] == "APPLIQUE", "10 acceptation EN_CLARIFICATION sans contrat")

	etat = _nouvel_etat()
	resultat = etat.traiter_evenement(_evenement_central("central-clarification-avec-contrat", {
		"statut_couple": "EN_CLARIFICATION",
		"contrat_couple": "LIBERTIN",
		"relation_apres_separation": null,
	}))
	_expect(resultat["statut"] == "APPLIQUE", "11 acceptation EN_CLARIFICATION avec contrat")


func _test_cadre_provisoire() -> void:
	var etat = _nouvel_etat()
	var resultat: Dictionary = etat.traiter_evenement(_evenement_central("central-provisoire-incomplet", {
		"statut_couple": "ENSEMBLE",
		"contrat_couple": "PROVISOIRE",
		"relation_apres_separation": null,
		"cadre_provisoire": {
			"regle": "clarifier ensemble",
			"limites": [],
			"reevaluation": {},
			"obligation_ids": [],
		},
	}))
	_expect(resultat["statut"] == "REJETE", "12 rejet PROVISOIRE incomplet")

	etat = _nouvel_etat()
	resultat = etat.traiter_evenement(_evenement_central("central-provisoire-complet", {
		"statut_couple": "ENSEMBLE",
		"contrat_couple": "PROVISOIRE",
		"relation_apres_separation": null,
		"cadre_provisoire": {
			"regle": "clarifier ensemble",
			"limites": ["aucune permission implicite"],
			"reevaluation": {"condition": "apres la prochaine conversation"},
			"obligation_ids": ["obligation-synthetique-1"],
		},
	}))
	_expect(resultat["statut"] == "APPLIQUE", "13 acceptation PROVISOIRE complet")


func _test_transactions_atomiques() -> void:
	var etat = _nouvel_etat()
	var resultat: Dictionary = etat.traiter_evenement(_evenement_central("central-atomique", {
		"statut_couple": "ENSEMBLE",
		"contrat_couple": "EXCLUSIF",
		"relation_apres_separation": null,
		"etat_divulgation": "HONNETE",
	}))
	var centrale: Dictionary = etat.obtenir_snapshot()["relation_centrale"]
	_expect(
		resultat["statut"] == "APPLIQUE"
		and centrale["statut_couple"] == "ENSEMBLE"
		and centrale["contrat_couple"] == "EXCLUSIF"
		and centrale["etat_divulgation"] == "HONNETE",
		"14 application atomique centrale",
	)

	etat = _nouvel_etat()
	resultat = etat.traiter_evenement(_evenement_relation("relation-sandra-atomique", "sandra", {
		"etat_arc": "LIEN_SYNTHETIQUE",
		"confiance": "STABLE",
		"faits": [{"fait_id": "fait-synthetique"}],
	}))
	var sandra: Dictionary = etat.obtenir_snapshot()["relations"]["sandra"]
	_expect(
		resultat["statut"] == "APPLIQUE"
		and sandra["etat_arc"] == "LIEN_SYNTHETIQUE"
		and sandra["confiance"] == "STABLE"
		and sandra["faits"].size() == 1,
		"15 application atomique individuelle",
	)


func _test_rejet_sans_mutation() -> void:
	var etat = _nouvel_etat()
	var avant: Dictionary = etat.obtenir_snapshot()
	var resultat: Dictionary = etat.traiter_evenement(_evenement_central("central-rejet-atomique", {
		"statut_couple": "SEPARES",
		"contrat_couple": "EXCLUSIF",
		"relation_apres_separation": null,
	}))
	_expect(
		resultat["statut"] == "REJETE" and etat.obtenir_snapshot() == avant,
		"16 rejet sans mutation du snapshot",
	)


func _test_idempotence() -> void:
	var etat = _nouvel_etat()
	var evenement := _evenement_relation("relation-replay", "sandra", {
		"etat_arc": "LIEN_SYNTHETIQUE",
		"faits": ["preuve-synthetique"],
	})
	var premier: Dictionary = etat.traiter_evenement(evenement)
	var replay := {
		"payload": {
			"changements": {"faits": ["preuve-synthetique"], "etat_arc": "LIEN_SYNTHETIQUE"},
			"personnage_id": "sandra",
		},
		"provenance": {"id": "r8c_a1_smoke", "type": "TEST_SYNTHETIQUE"},
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"event_id": "relation-replay",
	}
	var second: Dictionary = etat.traiter_evenement(replay)
	_expect(premier["statut"] == "APPLIQUE" and second["statut"] == "IDEMPOTENT", "17 replay identique idempotent")

	var conflit := replay.duplicate(true)
	conflit["payload"]["changements"]["etat_arc"] = "AUTRE_CONTENU"
	var resultat_conflit: Dictionary = etat.traiter_evenement(conflit)
	_expect(resultat_conflit["statut"] == "REJETE", "18 meme identifiant contenu different rejete")


func _test_encapsulation_entree() -> void:
	var etat = _nouvel_etat()
	var evenement := _evenement_relation("relation-entree-protegee", "sandra", {
		"faits": [{"fait_id": "original"}],
	})
	var resultat: Dictionary = etat.traiter_evenement(evenement)
	evenement["payload"]["changements"]["faits"][0]["fait_id"] = "modifie"
	evenement["provenance"]["id"] = "modifie"
	var stocke: Dictionary = etat.obtenir_snapshot()["evenements"]["relation-entree-protegee"]
	_expect(
		resultat["statut"] == "APPLIQUE"
		and stocke["payload"]["changements"]["faits"][0]["fait_id"] == "original"
		and stocke["provenance"]["id"] == "r8c_a1_smoke",
		"19 protection contre mutation de l'evenement entrant",
	)


func _test_encapsulation_sortie() -> void:
	var etat = _nouvel_etat()
	etat.traiter_evenement(_evenement_relation("relation-sortie-protegee", "sandra", {
		"faits": [{"fait_id": "interne"}],
	}))
	var snapshot: Dictionary = etat.obtenir_snapshot()
	snapshot["relations"]["sandra"]["faits"][0]["fait_id"] = "externe"
	snapshot["evenements"]["relation-sortie-protegee"]["payload"]["changements"]["faits"].clear()
	var suivant: Dictionary = etat.obtenir_snapshot()
	_expect(
		suivant["relations"]["sandra"]["faits"][0]["fait_id"] == "interne"
		and suivant["evenements"]["relation-sortie-protegee"]["payload"]["changements"]["faits"].size() == 1,
		"20 protection contre mutation du snapshot sortant",
	)


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


func _evenement_central(event_id: String, changements: Dictionary) -> Dictionary:
	return {
		"event_id": event_id,
		"event_type": EtatNarratifModele.TYPE_RELATION_CENTRALE,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "r8c_a1_smoke"},
		"payload": {"changements": changements},
	}


func _evenement_relation(event_id: String, personnage_id: String, changements: Dictionary) -> Dictionary:
	return {
		"event_id": event_id,
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "r8c_a1_smoke"},
		"payload": {"personnage_id": personnage_id, "changements": changements},
	}
