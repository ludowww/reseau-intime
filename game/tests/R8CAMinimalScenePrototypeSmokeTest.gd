extends Node

const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")
const InstanceModele := preload("res://scripts/narrative_scene/SceneInstance.gd")
const MoteurModele := preload("res://scripts/narrative_scene/MinimalSceneEngine.gd")
const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")

const FIXTURE_PATH := "res://tests/fixtures/r8c_a3_minimal_scene_definitions.json"

var failures: Array[String] = []
var definitions: Dictionary = {}
var controles := 0


func _ready() -> void:
	definitions = _charger_definitions()
	_executer()
	if failures.is_empty():
		print("R8C_A3_MINIMAL_SCENE_PROTOTYPE: OK (%s controles)" % controles)
		get_tree().quit(0)
	else:
		print("R8C_A3_MINIMAL_SCENE_PROTOTYPE: FAILED " + str(failures))
		get_tree().quit(1)


func _expect(condition: bool, label: String) -> void:
	controles += 1
	if not condition:
		failures.append(label)


func _executer() -> void:
	_test_schema_borne_et_temps_valides()
	_test_cycle_ineligible_eligible_et_transitions_invalides()
	_test_non_selection_sans_consequence()
	_test_resolution_incompatible_avec_choix()
	_test_revalidation_acte_avant_mutation()
	_test_fenetre_fermee_apres_proposition()
	_test_participant_devenu_indisponible()
	_test_unicite_instances_et_resolution_concurrente()
	_test_scene_repetable_plusieurs_instances()
	_test_transition_non_preparable_preserve_a1()
	_test_reprise_idempotente_et_seconde_resolution_refusee()
	_test_reprise_apres_commit_a1_avant_transition_instance()
	_test_effet_local_non_persiste()
	_test_trace_temporaire_creee_puis_nettoyee()
	_test_durable_exige_reception_interpretation()
	_test_limite_uniquement_depuis_choix_audacieux()
	_test_scene_sans_choix_et_sans_evenement_durable()
	_test_proposition_reellement_manquee()
	_test_transaction_a1_rejetee_sans_transition()
	_test_variantes_non_interchangeables()
	_test_invariants_a1_conserves()


func _test_schema_borne_et_temps_valides() -> void:
	for nom in definitions:
		_expect(DefinitionModele.declarer(definitions[nom])["ok"], "01 definition declarable: %s" % nom)
	var invalide: Dictionary = definitions["signature_sandra"].duplicate(true)
	invalide["contrat_temporel"]["heure_ouverture"] = "9:7"
	_expect(not DefinitionModele.declarer(invalide)["ok"], "02 heure non normalisee refusee")
	invalide = definitions["signature_sandra"].duplicate(true)
	invalide["contrat_temporel"]["date_fin"] = "2030-02-30"
	_expect(not DefinitionModele.declarer(invalide)["ok"], "03 date impossible refusee")


func _test_cycle_ineligible_eligible_et_transitions_invalides() -> void:
	var etat = _nouvel_etat()
	var moteur := MoteurModele.new()
	var contexte := _contexte("instance-cycle", "2030-04-08T19:00:00+02:00", "sandra")
	var diagnostic: Dictionary = moteur.evaluer_definition(definitions["signature_sandra"], etat, contexte)
	var instance = moteur.creer_instance(definitions["signature_sandra"], diagnostic, contexte)
	_expect(instance != null and instance.obtenir_statut() == InstanceModele.INELIGIBLE, "04 instance ineligible creee")
	_ajouter_evenement(etat, "r8c-a3-sandra-relation-ready", "sandra", "relation_sandra_prete")
	var reevaluation: Dictionary = moteur.reevaluer_instance(instance, definitions["signature_sandra"], etat, contexte)
	_expect(reevaluation["ok"] and instance.obtenir_statut() == InstanceModele.ELIGIBLE, "05 ineligible vers eligible")
	contexte["acte_courant"] = "ACTE_INCOMPATIBLE"
	reevaluation = moteur.reevaluer_instance(instance, definitions["signature_sandra"], etat, contexte)
	_expect(reevaluation["ok"] and instance.obtenir_statut() == InstanceModele.INELIGIBLE, "06 eligible vers ineligible")
	var invalide: Dictionary = instance.transitionner(InstanceModele.RESOLVED, "SAUT_INTERDIT", contexte["moment_diegetique"])
	_expect(not invalide["ok"] and instance.obtenir_statut() == InstanceModele.INELIGIBLE, "07 transition invalide refusee")
	contexte["acte_courant"] = "ACTE_SYNTHETIQUE_A3"
	moteur.reevaluer_instance(instance, definitions["signature_sandra"], etat, contexte)
	var annulation: Dictionary = moteur.annuler(instance, "ANNULATION_EXPLICITE", "2030-04-08T19:01:00+02:00")
	_expect(annulation["ok"] and instance.obtenir_statut() == InstanceModele.CANCELLED, "08 cancelled terminal explicite")
	var apres_terminal: Dictionary = instance.transitionner(InstanceModele.ELIGIBLE, "REOUVERTURE_INTERDITE", "2030-04-08T19:02:00+02:00")
	_expect(not apres_terminal["ok"] and instance.obtenir_statut() == InstanceModele.CANCELLED, "09 terminal immutable")


func _test_non_selection_sans_consequence() -> void:
	var etat = _etat_avec_evenement("r8c-a3-sandra-relation-ready", "sandra", "relation_sandra_prete")
	var avant: Dictionary = etat.obtenir_snapshot()
	var moteur := MoteurModele.new()
	var ouvert: Dictionary = moteur.evaluer_definition(
		definitions["signature_sandra"], etat, _contexte("non-selection", "2030-04-08T19:00:00+02:00", "sandra")
	)
	var ferme: Dictionary = moteur.evaluer_definition(
		definitions["signature_sandra"], etat, _contexte("non-selection", "2030-04-08T23:00:00+02:00", "sandra")
	)
	_expect(ouvert["eligible"] and not ferme["eligible"], "10 reevaluation sans selection")
	_expect(etat.obtenir_snapshot() == avant, "11 non selection silencieuse")


func _test_resolution_incompatible_avec_choix() -> void:
	var paquet := _signature_proposee("incompatible")
	var avant: Dictionary = paquet["etat"].obtenir_snapshot()
	var resultat: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "sobre", "signal_chaleureux_recu",
		paquet["etat"], _contexte("incompatible", "2030-04-08T19:05:00+02:00", "sandra")
	)
	_expect(not resultat["ok"] and resultat["erreur"] == "RESOLUTION_INCOMPATIBLE_AVEC_CHOIX", "12 resolution incompatible refusee")
	_expect(paquet["instance"].obtenir_statut() == InstanceModele.PROPOSED and paquet["etat"].obtenir_snapshot() == avant, "13 incompatible sans mutation")


func _test_revalidation_acte_avant_mutation() -> void:
	var paquet := _signature_proposee("revalidation-acte")
	var contexte := _contexte("revalidation-acte", "2030-04-08T19:06:00+02:00", "sandra")
	contexte["acte_courant"] = "ACTE_INCOMPATIBLE"
	_assert_revalidation_sans_mutation(paquet, contexte, "14 acte revalide avant mutation", "ACTE_INCOMPATIBLE")


func _test_fenetre_fermee_apres_proposition() -> void:
	var paquet := _signature_proposee("fenetre-fermee")
	_assert_revalidation_sans_mutation(
		paquet,
		_contexte("fenetre-fermee", "2030-04-08T22:01:00+02:00", "sandra"),
		"15 fenetre fermee apres proposition",
		"FENETRE_FERMEE",
	)


func _test_participant_devenu_indisponible() -> void:
	var paquet := _signature_proposee("participant-indisponible")
	var contexte := _contexte("participant-indisponible", "2030-04-08T19:07:00+02:00", "sandra")
	contexte["participants_disponibles"]["sandra"] = false
	_assert_revalidation_sans_mutation(paquet, contexte, "16 participant indisponible avant mutation", "PARTICIPANT_INDISPONIBLE:sandra")


func _assert_revalidation_sans_mutation(paquet: Dictionary, contexte: Dictionary, label: String, raison: String) -> void:
	var etat_avant: Dictionary = paquet["etat"].obtenir_snapshot()
	var instance_avant: Dictionary = paquet["instance"].obtenir_snapshot()
	var resultat: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu",
		paquet["etat"], contexte
	)
	_expect(
		not resultat["ok"]
		and resultat["erreur"] == "REVALIDATION_RESOLUTION_INELIGIBLE"
		and raison in resultat["diagnostic_revalidation"]["raisons_ineligibilite"]
		and paquet["etat"].obtenir_snapshot() == etat_avant
		and paquet["instance"].obtenir_snapshot() == instance_avant,
		label,
	)


func _test_unicite_instances_et_resolution_concurrente() -> void:
	var etat = _etat_avec_evenement("r8c-a3-sandra-relation-ready", "sandra", "relation_sandra_prete")
	var moteur := MoteurModele.new()
	var contexte_un := _contexte("unique-un", "2030-04-08T19:00:00+02:00", "sandra")
	var diagnostic_un: Dictionary = moteur.evaluer_definition(definitions["signature_sandra"], etat, contexte_un)
	var instance_un = moteur.creer_instance(definitions["signature_sandra"], diagnostic_un, contexte_un)
	var doublon = moteur.creer_instance(definitions["signature_sandra"], diagnostic_un, contexte_un)
	_expect(doublon == null and moteur.obtenir_derniere_erreur_instance() == "INSTANCE_ID_DUPLIQUE", "17 instance_id duplique refuse")
	var contexte_deux := _contexte("unique-deux", "2030-04-08T19:01:00+02:00", "sandra")
	var diagnostic_deux: Dictionary = moteur.evaluer_definition(definitions["signature_sandra"], etat, contexte_deux)
	var concurrente = moteur.creer_instance(definitions["signature_sandra"], diagnostic_deux, contexte_deux)
	_expect(instance_un != null and not diagnostic_deux["eligible"] and concurrente == null, "18 deux instances UNIQUE concurrentes refusees")

	var moteur_a := MoteurModele.new()
	var moteur_b := MoteurModele.new()
	var contexte_a := _contexte("course-a", "2030-04-08T19:02:00+02:00", "sandra")
	var contexte_b := _contexte("course-b", "2030-04-08T19:03:00+02:00", "sandra")
	var instance_a = _creer_et_proposer(moteur_a, definitions["signature_sandra"], etat, contexte_a)
	var instance_b = _creer_et_proposer(moteur_b, definitions["signature_sandra"], etat, contexte_b)
	var premier: Dictionary = moteur_a.resoudre(
		instance_a, definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu", etat, contexte_a
	)
	var apres_premier: Dictionary = etat.obtenir_snapshot()
	var second: Dictionary = moteur_b.resoudre(
		instance_b, definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu", etat, contexte_b
	)
	_expect(premier["ok"] and not second["ok"] and second["erreur"] == "REVALIDATION_RESOLUTION_INELIGIBLE", "19 resolution UNIQUE concurrente refusee")
	_expect(instance_b.obtenir_statut() == InstanceModele.PROPOSED and etat.obtenir_snapshot() == apres_premier, "20 course unique sans seconde mutation")


func _test_scene_repetable_plusieurs_instances() -> void:
	var definition: Dictionary = definitions["module_distance_sandra"]
	var etat = _etat_avec_evenement("r8c-a3-sandra-away", "sandra", "sandra_absente")
	var moteur := MoteurModele.new()
	for index in range(2):
		var instance_id := "repetable-%s" % index
		var contexte := _contexte(instance_id, "2030-04-09T10:0%s:00+02:00" % index, "sandra")
		var instance = _creer_et_proposer(moteur, definition, etat, contexte)
		var resultat: Dictionary = moteur.resoudre(instance, definition, "sobre", "echo_sandra_local", etat, contexte)
		_expect(resultat["ok"] and instance.obtenir_statut() == InstanceModele.RESOLVED, "21 REPETABLE utilisation %s" % index)
	_expect(etat.obtenir_snapshot()["evenements"].size() == 1, "22 repetitions temporaires sans evenement durable")


func _test_transition_non_preparable_preserve_a1() -> void:
	var paquet := _signature_proposee("preparation-refusee")
	var avant: Dictionary = paquet["etat"].obtenir_snapshot()
	var preparation: Dictionary = paquet["instance"].preparer_transition(
		InstanceModele.ELIGIBLE, "RETOUR_INTERDIT", "2030-04-08T19:08:00+02:00"
	)
	_expect(not preparation["ok"] and paquet["etat"].obtenir_snapshot() == avant, "23 transition non preparable laisse A1 intact")
	var contournement: Dictionary = paquet["instance"].transitionner(
		InstanceModele.RESOLVED, "CONTOURNEMENT_INTERDIT", "2030-04-08T19:08:00+02:00"
	)
	_expect(not contournement["ok"] and paquet["instance"].obtenir_statut() == InstanceModele.PROPOSED, "23b resolution directe hors transaction refusee")


func _test_reprise_idempotente_et_seconde_resolution_refusee() -> void:
	var paquet := _signature_proposee("idempotence")
	var contexte := _contexte("idempotence", "2030-04-08T19:09:00+02:00", "sandra")
	var premier: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu", paquet["etat"], contexte
	)
	var apres: Dictionary = paquet["etat"].obtenir_snapshot()
	var reprise: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu", paquet["etat"], contexte
	)
	var differente: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "audacieuse", "limite_audace_explicite", paquet["etat"], contexte
	)
	_expect(premier["ok"] and reprise["ok"] and reprise["transaction"]["statut"] == "IDEMPOTENT", "24 reprise identique idempotente")
	_expect(not differente["ok"] and differente["erreur"] == "RESOLUTION_TERMINALE_DIFFERENTE" and paquet["etat"].obtenir_snapshot() == apres, "25 seconde resolution differente refusee")


func _test_reprise_apres_commit_a1_avant_transition_instance() -> void:
	var paquet := _signature_proposee("reprise-apres-a1")
	var contexte := _contexte("reprise-apres-a1", "2030-04-08T19:09:30+02:00", "sandra")
	var resolution: Dictionary = definitions["signature_sandra"]["resolutions"]["signal_chaleureux_recu"]
	var transaction_id := "r8c-a3:reprise-apres-a1:resolution:signal_chaleureux_recu"
	var evenement: Dictionary = paquet["moteur"]._construire_evenement_resolution(
		paquet["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu",
		resolution, transaction_id, paquet["etat"], contexte
	)
	var commit_a1: Dictionary = paquet["etat"].traiter_evenement(evenement)
	_expect(commit_a1["statut"] == "APPLIQUE" and paquet["instance"].obtenir_statut() == InstanceModele.PROPOSED, "25b precondition commit A1 sans transition instance")
	var reprise: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu", paquet["etat"], contexte
	)
	_expect(
		reprise["ok"] and reprise["transaction"]["statut"] == "IDEMPOTENT"
		and paquet["instance"].obtenir_statut() == InstanceModele.RESOLVED,
		"25c reprise apres commit A1 finalise instance",
	)


func _test_effet_local_non_persiste() -> void:
	var paquet := _signature_proposee("locale")
	var avant: Dictionary = paquet["etat"].obtenir_snapshot()
	var resultat: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "sobre", "resolution_commune", paquet["etat"],
		_contexte("locale", "2030-04-08T19:10:00+02:00", "sandra")
	)
	_expect(resultat["ok"] and resultat["transaction"]["statut"] == "NON_PERSISTE", "26 resolution locale acceptee sans A1")
	_expect(paquet["etat"].obtenir_snapshot() == avant and resultat["evenement_candidat"].is_empty(), "27 effet LOCAL non persiste")


func _test_trace_temporaire_creee_puis_nettoyee() -> void:
	var definition: Dictionary = definitions["module_distance_sandra"]
	var etat = _etat_avec_evenement("r8c-a3-sandra-away", "sandra", "sandra_absente")
	var moteur := MoteurModele.new()
	var contexte := _contexte("temporaire", "2030-04-09T10:10:00+02:00", "sandra")
	var instance = _creer_et_proposer(moteur, definition, etat, contexte)
	var avant: Dictionary = etat.obtenir_snapshot()
	var resultat: Dictionary = moteur.resoudre(instance, definition, "sobre", "echo_sandra_local", etat, contexte)
	var traces: Dictionary = instance.obtenir_snapshot()["traces_temporaires"]
	_expect(
		resultat["ok"] and resultat["diagnostic_signal"]["portee_micro_signal"] == "TEMPORAIRE"
		and traces.is_empty() and etat.obtenir_snapshot() == avant,
		"28 trace TEMPORAIRE nettoyee a la cloture",
	)
	var nettoyees: int = instance.nettoyer_traces_temporaires()
	_expect(nettoyees == 0 and instance.obtenir_snapshot()["traces_temporaires"].is_empty(), "29 nettoyage terminal idempotent")


func _test_durable_exige_reception_interpretation() -> void:
	var invalide: Dictionary = definitions["signature_sandra"].duplicate(true)
	invalide["resolutions"]["signal_chaleureux_recu"]["reception"] = "NON_PERSISTANTE"
	_expect(not DefinitionModele.declarer(invalide)["ok"], "30 DURABLE plus NON_PERSISTANTE interdit")
	invalide = definitions["signature_sandra"].duplicate(true)
	invalide["resolutions"]["signal_chaleureux_recu"]["interpretation"] = ""
	_expect(not DefinitionModele.declarer(invalide)["ok"], "31 DURABLE sans interpretation interdit")


func _test_limite_uniquement_depuis_choix_audacieux() -> void:
	var paquet := _signature_proposee("limite")
	var contexte := _contexte("limite", "2030-04-08T19:11:00+02:00", "sandra")
	var refusee: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "sobre", "limite_audace_explicite", paquet["etat"], contexte
	)
	var acceptee: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "audacieuse", "limite_audace_explicite", paquet["etat"], contexte
	)
	_expect(not refusee["ok"] and acceptee["ok"], "32 limite durable seulement depuis choix audacieux")
	_expect(
		acceptee["diagnostic_signal"]["signal_emis"] == "AUDACE_SITUEE"
		and _resultat_a_fait(paquet["etat"], "sandra", "sandra_limite_registre_audacieux_formulee"),
		"33 chaine audace reception limite persistante",
	)


func _test_scene_sans_choix_et_sans_evenement_durable() -> void:
	var sans_choix: Dictionary = definitions["module_distance_sandra"].duplicate(true)
	sans_choix["scene_id"] = "r8c_a3_sans_choix_synthetique"
	sans_choix["choix"] = []
	sans_choix["resolutions"] = {}
	_expect(DefinitionModele.declarer(sans_choix)["ok"], "34 scene sans choix valide")
	_expect(DefinitionModele.declarer(definitions["module_distance_sandra"])["ok"], "35 scene sans evenement durable valide")


func _test_proposition_reellement_manquee() -> void:
	var paquet := _signature_proposee("manquee")
	var resultat: Dictionary = paquet["moteur"].manquer(
		paquet["instance"], definitions["signature_sandra"], paquet["etat"],
		_contexte("manquee", "2030-04-08T22:01:00+02:00", "sandra")
	)
	_expect(resultat["ok"] and paquet["instance"].obtenir_statut() == InstanceModele.MISSED, "36 proposition expiree vers MISSED")
	_expect(_resultat_a_fait(paquet["etat"], "sandra", "sandra_proposition_visible_restee_sans_reponse"), "37 occasion manquee durable explicite")


func _test_transaction_a1_rejetee_sans_transition() -> void:
	var paquet := _signature_proposee("conflit")
	var event_id := "r8c-a3:conflit:resolution:signal_chaleureux_recu"
	_ajouter_evenement(paquet["etat"], event_id, "sandra", "contenu_en_conflit")
	var avant: Dictionary = paquet["etat"].obtenir_snapshot()
	var resultat: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu", paquet["etat"],
		_contexte("conflit", "2030-04-08T19:12:00+02:00", "sandra")
	)
	_expect(not resultat["ok"] and resultat["transaction"]["statut"] == "REJETE", "38 conflit A1 rejete")
	_expect(paquet["instance"].obtenir_statut() == InstanceModele.PROPOSED and paquet["etat"].obtenir_snapshot() == avant, "39 rejet A1 sans transition instance")


func _test_variantes_non_interchangeables() -> void:
	var sandra: Dictionary = definitions["module_distance_sandra"]
	var raphaelle: Dictionary = definitions["module_distance_raphaelle"]
	_expect(
		sandra["structure_id"] == raphaelle["structure_id"]
		and sandra["scene_id"] != raphaelle["scene_id"]
		and sandra["participants_requis"] != raphaelle["participants_requis"]
		and sandra["resolutions"] != raphaelle["resolutions"],
		"40 variantes Sandra Raphaelle non interchangeables",
	)
	var etat = _etat_avec_evenement("r8c-a3-sandra-away", "sandra", "sandra_absente")
	var moteur := MoteurModele.new()
	var contexte := _contexte("variante", "2030-04-09T10:00:00+02:00", "sandra")
	var diagnostic: Dictionary = moteur.evaluer_definition(sandra, etat, contexte)
	var instance = moteur.creer_instance(sandra, diagnostic, contexte)
	var resultat: Dictionary = moteur.proposer(instance, raphaelle, etat, contexte)
	_expect(not resultat["ok"] and resultat["erreur"] == "DEFINITION_NON_INTERCHANGEABLE", "41 variante refusee sur autre instance")


func _test_invariants_a1_conserves() -> void:
	var paquet := _signature_proposee("invariants-a1")
	var avant: Dictionary = paquet["etat"].obtenir_snapshot()
	var resultat: Dictionary = paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu", paquet["etat"],
		_contexte("invariants-a1", "2030-04-08T19:13:00+02:00", "sandra")
	)
	var apres: Dictionary = paquet["etat"].obtenir_snapshot()
	_expect(resultat["ok"] and apres["relation_centrale"] == avant["relation_centrale"], "42 relation centrale A1 inchangee")
	_expect(apres.keys() == avant.keys() and apres["relations"].size() == 6, "43 racines et six relations A1 conservees")
	_expect(apres["evenements"].size() == avant["evenements"].size() + 1, "44 exactement un evenement A1 durable")


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
		"payload": {"personnage_id": personnage_id, "changements": {"faits": faits}},
	})


func _contexte(instance_id: String, moment: String, personnage_disponible: String) -> Dictionary:
	return {
		"instance_id": instance_id,
		"acte_courant": "ACTE_SYNTHETIQUE_A3",
		"moment_diegetique": moment,
		"participants_disponibles": {personnage_disponible: true},
		"opportunite_valide": true,
	}


func _signature_proposee(instance_id: String) -> Dictionary:
	var etat = _etat_avec_evenement("r8c-a3-sandra-relation-ready", "sandra", "relation_sandra_prete")
	var moteur := MoteurModele.new()
	var contexte := _contexte(instance_id, "2030-04-08T19:00:00+02:00", "sandra")
	var instance = _creer_et_proposer(moteur, definitions["signature_sandra"], etat, contexte)
	return {"etat": etat, "moteur": moteur, "contexte": contexte, "instance": instance}


func _creer_et_proposer(moteur, definition: Dictionary, etat, contexte: Dictionary):
	var diagnostic: Dictionary = moteur.evaluer_definition(definition, etat, contexte)
	var instance = moteur.creer_instance(definition, diagnostic, contexte)
	if instance != null:
		moteur.proposer(instance, definition, etat, contexte)
	return instance


func _resultat_a_fait(etat, personnage_id: String, fait_id: String) -> bool:
	for fait in etat.obtenir_snapshot()["relations"][personnage_id]["faits"]:
		if typeof(fait) == TYPE_DICTIONARY and fait.get("fait_id") == fait_id:
			return true
	return false
