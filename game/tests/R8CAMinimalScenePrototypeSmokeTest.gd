extends Node

const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")
const InstanceModele := preload("res://scripts/narrative_scene/SceneInstance.gd")
const MoteurModele := preload("res://scripts/narrative_scene/MinimalSceneEngine.gd")
const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")

const FIXTURE_PATH := "res://tests/fixtures/r8c_a3_minimal_scene_definitions.json"

var failures: Array[String] = []
var definitions: Dictionary = {}


func _ready() -> void:
	definitions = _charger_definitions()
	_executer()
	if failures.is_empty():
		print("R8C_A3_MINIMAL_SCENE_PROTOTYPE: OK")
		get_tree().quit(0)
	else:
		print("R8C_A3_MINIMAL_SCENE_PROTOTYPE: FAILED " + str(failures))
		get_tree().quit(1)


func _expect(condition: bool, label: String) -> void:
	if not condition:
		failures.append(label)


func _executer() -> void:
	_test_declaration_instance_et_diagnostic()
	_test_ineligibilite_expliquee()
	_test_non_selection_sans_consequence()
	_test_proposition_reellement_manquee()
	_test_micro_signal_local_non_persiste()
	_test_signal_recu_et_interprete()
	_test_limite_explicite()
	_test_transaction_rejetee_sans_resolution()
	_test_variantes_non_interchangeables()
	_test_unicite_et_annulation()


func _test_declaration_instance_et_diagnostic() -> void:
	var declaration: Dictionary = DefinitionModele.declarer(definitions["signature_sandra"])
	_expect(declaration["ok"], "01 definition declarable")
	var etat = _etat_avec_evenement("r8c-a3-sandra-relation-ready", "sandra", "relation_sandra_prete")
	var moteur := MoteurModele.new()
	var contexte := _contexte("instance-declaration", "2030-04-08T19:00:00+02:00", "sandra")
	var diagnostic: Dictionary = moteur.evaluer_definition(declaration["definition"], etat, contexte)
	_expect(
		diagnostic["eligible"]
		and diagnostic["statut"] == InstanceModele.ELIGIBLE
		and diagnostic["raisons_ineligibilite"].is_empty(),
		"02 eligibilite expliquee",
	)
	var instance = moteur.creer_instance(declaration["definition"], diagnostic, contexte)
	_expect(instance != null and instance.obtenir_statut() == InstanceModele.ELIGIBLE, "03 instance liee creee")
	if instance != null:
		var reference: Dictionary = instance.obtenir_snapshot()["reference_etat"]
		_expect(
			reference["acte_courant"] == "ACTE_SYNTHETIQUE_A3"
			and "r8c-a3-sandra-relation-ready" in reference["event_ids_observes"],
			"04 instance reference etat courant",
		)


func _test_ineligibilite_expliquee() -> void:
	var etat = _etat_avec_evenement("r8c-a3-sandra-signature-blocked", "sandra", "signature_sandra_bloquee")
	var contexte := _contexte("instance-ineligible", "2030-04-08T23:00:00+02:00", "sandra")
	contexte["acte_courant"] = "ACTE_INCOMPATIBLE"
	contexte["participants_disponibles"]["sandra"] = false
	contexte["opportunite_valide"] = false
	var diagnostic: Dictionary = MoteurModele.new().evaluer_definition(definitions["signature_sandra"], etat, contexte)
	var raisons: Array = diagnostic["raisons_ineligibilite"]
	_expect(not diagnostic["eligible"] and diagnostic["statut"] == InstanceModele.INELIGIBLE, "05 scene ineligible")
	_expect("ACTE_INCOMPATIBLE" in raisons, "06 diagnostic acte incompatible")
	_expect("EVENEMENT_REQUIS_ABSENT:r8c-a3-sandra-relation-ready" in raisons, "07 diagnostic evenement absent")
	_expect("PARTICIPANT_INDISPONIBLE:sandra" in raisons, "08 diagnostic participant indisponible")
	_expect(
		"EVENEMENT_INTERDIT_PRESENT:r8c-a3-sandra-signature-blocked" in raisons
		and "FENETRE_FERMEE" in raisons
		and "OPPORTUNITE_INVALIDE" in raisons,
		"09 diagnostic exclusion temps et opportunite",
	)


func _test_non_selection_sans_consequence() -> void:
	var etat = _etat_avec_evenement("r8c-a3-sandra-relation-ready", "sandra", "relation_sandra_prete")
	var avant: Dictionary = etat.obtenir_snapshot()
	var moteur := MoteurModele.new()
	var eligible: Dictionary = moteur.evaluer_definition(
		definitions["signature_sandra"],
		etat,
		_contexte("instance-non-selectionnee", "2030-04-08T19:00:00+02:00", "sandra"),
	)
	var apres_fenetre: Dictionary = moteur.evaluer_definition(
		definitions["signature_sandra"],
		etat,
		_contexte("instance-non-selectionnee", "2030-04-08T23:00:00+02:00", "sandra"),
	)
	_expect(eligible["eligible"] and not apres_fenetre["eligible"], "10 definition reevaluee sans instance")
	_expect(etat.obtenir_snapshot() == avant, "11 non selection sans absence ni consequence")


func _test_proposition_reellement_manquee() -> void:
	var etat = _etat_avec_evenement("r8c-a3-sandra-relation-ready", "sandra", "relation_sandra_prete")
	var moteur := MoteurModele.new()
	var contexte := _contexte("instance-manquee", "2030-04-08T19:00:00+02:00", "sandra")
	var diagnostic: Dictionary = moteur.evaluer_definition(definitions["signature_sandra"], etat, contexte)
	var instance = moteur.creer_instance(definitions["signature_sandra"], diagnostic, contexte)
	var proposition: Dictionary = moteur.proposer(instance, definitions["signature_sandra"], etat, contexte)
	_expect(proposition["ok"] and instance.obtenir_statut() == InstanceModele.PROPOSED, "12 opportunite proposee")
	var resultat: Dictionary = moteur.manquer(
		instance,
		definitions["signature_sandra"],
		etat,
		_contexte("instance-manquee", "2030-04-08T22:01:00+02:00", "sandra"),
	)
	_expect(resultat["ok"] and instance.obtenir_statut() == InstanceModele.MISSED, "13 proposition expiree manquee")
	_expect(
		_resultat_a_fait(etat, "sandra", "sandra_proposition_visible_restee_sans_reponse"),
		"14 absence narrative ecrite",
	)
	_expect(
		resultat["evenement_candidat"]["provenance"]["scene_status"] == InstanceModele.MISSED,
		"15 provenance occasion manquee",
	)


func _test_micro_signal_local_non_persiste() -> void:
	var paquet := _instance_proposee("instance-locale")
	var moteur = paquet["moteur"]
	var etat = paquet["etat"]
	var instance = paquet["instance"]
	var resultat: Dictionary = moteur.resoudre(
		instance,
		definitions["signature_sandra"],
		"resolution_commune",
		etat,
		_contexte("instance-locale", "2030-04-08T19:05:00+02:00", "sandra"),
	)
	_expect(resultat["ok"] and instance.obtenir_statut() == InstanceModele.RESOLVED, "16 resolution locale transactionnelle")
	_expect(resultat["diagnostic_signal"]["portee_micro_signal"] == "LOCALE", "17 portee locale explicite")
	var persistance := JSON.stringify(etat.obtenir_snapshot())
	_expect(
		not persistance.contains("sobre")
		and not persistance.contains("Je suis là. Raconte-moi."),
		"18 formulation locale non persistee",
	)


func _test_signal_recu_et_interprete() -> void:
	var paquet := _instance_proposee("instance-chaleureuse")
	var resultat: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"],
		definitions["signature_sandra"],
		"signal_chaleureux_recu",
		paquet["etat"],
		_contexte("instance-chaleureuse", "2030-04-08T19:10:00+02:00", "sandra"),
	)
	_expect(resultat["ok"] and resultat["transaction"]["statut"] == "APPLIQUE", "19 signal recu applique")
	_expect(
		resultat["diagnostic_signal"]["reception"] == "RECUE_INTERPRETEE"
		and resultat["diagnostic_signal"]["interpretation"] == "ATTENTION_CLAIREMENT_RECONNUE_PAR_SANDRA",
		"20 reception et interpretation lisibles",
	)
	_expect(
		_resultat_a_fait(paquet["etat"], "sandra", "sandra_attention_chaleureuse_reconnue"),
		"21 evenement relationnel durable",
	)


func _test_limite_explicite() -> void:
	var paquet := _instance_proposee("instance-limite")
	var resultat: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"],
		definitions["signature_sandra"],
		"limite_audace_explicite",
		paquet["etat"],
		_contexte("instance-limite", "2030-04-08T19:15:00+02:00", "sandra"),
	)
	_expect(resultat["ok"] and resultat["diagnostic_signal"]["reception"] == "LIMITE_EXPLICITE", "22 limite interpretee")
	_expect(
		_resultat_a_fait(paquet["etat"], "sandra", "sandra_limite_registre_audacieux_formulee"),
		"23 limite explicite persistee",
	)
	_expect(resultat["diagnostic_signal"]["convergence"] == "RETOUR_NOYAU_COMMUN", "24 branche audacieuse convergente")


func _test_transaction_rejetee_sans_resolution() -> void:
	var paquet := _instance_proposee("instance-conflit")
	var etat = paquet["etat"]
	var event_id := "r8c-a3:instance-conflit:signal_chaleureux_recu"
	var conflit: Dictionary = _ajouter_evenement(etat, event_id, "sandra", "contenu_en_conflit")
	_expect(conflit["statut"] == "APPLIQUE", "25 precondition conflit idempotence")
	var avant: Dictionary = etat.obtenir_snapshot()
	var resultat: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"],
		definitions["signature_sandra"],
		"signal_chaleureux_recu",
		etat,
		_contexte("instance-conflit", "2030-04-08T19:20:00+02:00", "sandra"),
	)
	_expect(
		not resultat["ok"]
		and resultat["transaction"]["statut"] == "REJETE"
		and paquet["instance"].obtenir_statut() == InstanceModele.PROPOSED,
		"26 transaction rejetee ne resout pas instance",
	)
	_expect(etat.obtenir_snapshot() == avant, "27 transaction rejetee atomique")


func _test_variantes_non_interchangeables() -> void:
	var sandra: Dictionary = definitions["module_distance_sandra"]
	var raphaelle: Dictionary = definitions["module_distance_raphaelle"]
	_expect(
		DefinitionModele.declarer(sandra)["ok"] and DefinitionModele.declarer(raphaelle)["ok"],
		"28 variantes modulaires declarables",
	)
	_expect(
		sandra["structure_id"] == raphaelle["structure_id"]
		and sandra["scene_id"] != raphaelle["scene_id"],
		"29 structure partagee identites distinctes",
	)
	_expect(
		sandra["participants_requis"] != raphaelle["participants_requis"]
		and sandra["conditions_dures"] != raphaelle["conditions_dures"]
		and sandra["resolutions"] != raphaelle["resolutions"],
		"30 conditions reactions consequences non interchangeables",
	)
	var etat = _etat_avec_evenement("r8c-a3-sandra-away", "sandra", "sandra_absente")
	var moteur := MoteurModele.new()
	var contexte := _contexte("instance-module-sandra", "2030-04-09T10:00:00+02:00", "sandra")
	var diagnostic: Dictionary = moteur.evaluer_definition(sandra, etat, contexte)
	var instance = moteur.creer_instance(sandra, diagnostic, contexte)
	var resultat: Dictionary = moteur.proposer(instance, raphaelle, etat, contexte)
	_expect(not resultat["ok"] and resultat["erreur"] == "DEFINITION_NON_INTERCHANGEABLE", "31 variante refusee sur autre instance")


func _test_unicite_et_annulation() -> void:
	var paquet := _instance_proposee("instance-unicite")
	var resultat: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"],
		definitions["signature_sandra"],
		"resolution_commune",
		paquet["etat"],
		_contexte("instance-unicite", "2030-04-08T19:25:00+02:00", "sandra"),
	)
	var diagnostic: Dictionary = paquet["moteur"].evaluer_definition(
		definitions["signature_sandra"],
		paquet["etat"],
		_contexte("instance-unicite-suivante", "2030-04-08T19:30:00+02:00", "sandra"),
	)
	_expect(resultat["ok"] and "SCENE_DEJA_RESOLUE" in diagnostic["raisons_ineligibilite"], "32 unicite apres resolution")
	var autre := _instance_eligible("instance-annulee")
	var annulation: Dictionary = autre["moteur"].annuler(autre["instance"], "CONFLIT_SYSTEME_SOURCE", "2030-04-08T19:01:00+02:00")
	_expect(annulation["ok"] and autre["instance"].obtenir_statut() == InstanceModele.CANCELLED, "33 annulation explicite distincte")


func _charger_definitions() -> Dictionary:
	var fichier := FileAccess.open(FIXTURE_PATH, FileAccess.READ)
	if fichier == null:
		failures.append("00 fixture inaccessible")
		return {}
	var parsed = JSON.parse_string(fichier.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY or typeof(parsed.get("definitions")) != TYPE_DICTIONARY:
		failures.append("00 fixture invalide")
		return {}
	return parsed["definitions"]


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


func _etat_avec_evenement(event_id: String, personnage_id: String, fait_id: String):
	var etat = _nouvel_etat()
	_ajouter_evenement(etat, event_id, personnage_id, fait_id)
	return etat


func _ajouter_evenement(etat, event_id: String, personnage_id: String, fait_id: String) -> Dictionary:
	var faits: Array = etat.obtenir_snapshot()["relations"][personnage_id]["faits"].duplicate(true)
	faits.append({"fait_id": fait_id, "nature": "PRECONDITION_SYNTHETIQUE"})
	return etat.traiter_evenement({
		"event_id": event_id,
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "r8c_a3_smoke"},
		"payload": {
			"personnage_id": personnage_id,
			"changements": {"faits": faits},
		},
	})


func _contexte(instance_id: String, moment: String, personnage_disponible: String) -> Dictionary:
	return {
		"instance_id": instance_id,
		"acte_courant": "ACTE_SYNTHETIQUE_A3",
		"moment_diegetique": moment,
		"participants_disponibles": {personnage_disponible: true},
		"opportunite_valide": true,
	}


func _instance_eligible(instance_id: String) -> Dictionary:
	var etat = _etat_avec_evenement("r8c-a3-sandra-relation-ready", "sandra", "relation_sandra_prete")
	var moteur := MoteurModele.new()
	var contexte := _contexte(instance_id, "2030-04-08T19:00:00+02:00", "sandra")
	var diagnostic: Dictionary = moteur.evaluer_definition(definitions["signature_sandra"], etat, contexte)
	return {
		"etat": etat,
		"moteur": moteur,
		"contexte": contexte,
		"instance": moteur.creer_instance(definitions["signature_sandra"], diagnostic, contexte),
	}


func _instance_proposee(instance_id: String) -> Dictionary:
	var paquet := _instance_eligible(instance_id)
	paquet["moteur"].proposer(paquet["instance"], definitions["signature_sandra"], paquet["etat"], paquet["contexte"])
	return paquet


func _resultat_a_fait(etat, personnage_id: String, fait_id: String) -> bool:
	for fait in etat.obtenir_snapshot()["relations"][personnage_id]["faits"]:
		if typeof(fait) == TYPE_DICTIONARY and fait.get("fait_id") == fait_id:
			return true
	return false
