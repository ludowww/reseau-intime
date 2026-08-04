extends Node

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
		print("R8C_A5_PERSISTENT_SCENE_REGISTRY: OK (%s controles)" % controles)
		get_tree().quit(0)
	else:
		print("R8C_A5_PERSISTENT_SCENE_REGISTRY: FAILED " + str(failures))
		get_tree().quit(1)


func _expect(condition: bool, label: String) -> void:
	controles += 1
	if not condition:
		failures.append(label)


func _executer() -> void:
	_test_round_trip_des_quatre_statuts()
	_test_unique_reconstruite_et_repetable_reutilisable()
	_test_transaction_reprise_et_resolution_differente()
	_test_portees_locale_et_temporaire()
	_test_snapshots_invalides_sans_mutation_partielle()
	_test_invariants_a1_apres_rechargement()
	_test_durcissement_du_format_persistant()
	_test_terminaison_bornee_avant_mutation()


func _test_round_trip_des_quatre_statuts() -> void:
	var proposee := _signature_proposee("a5-proposed")
	var proposee_rechargee := _recharger(proposee["moteur"], proposee["etat"])
	_expect(
		proposee_rechargee["ok"]
		and proposee_rechargee["moteur"].obtenir_instance("a5-proposed").obtenir_statut() == InstanceModele.PROPOSED,
		"01 round-trip PROPOSED",
	)

	var resolue := _signature_proposee("a5-resolved")
	var resolution: Dictionary = resolue["moteur"].resoudre(
		resolue["instance"], definitions["signature_sandra"], "sobre", "resolution_commune",
		resolue["etat"], resolue["contexte"]
	)
	var resolue_rechargee := _recharger(resolue["moteur"], resolue["etat"])
	_expect(
		resolution["ok"] and resolue_rechargee["ok"]
		and resolue_rechargee["moteur"].obtenir_instance("a5-resolved").obtenir_statut() == InstanceModele.RESOLVED,
		"02 round-trip RESOLVED",
	)

	var manquee := _signature_proposee("a5-missed")
	var resultat_manque: Dictionary = manquee["moteur"].manquer(
		manquee["instance"], definitions["signature_sandra"], manquee["etat"],
		_contexte("a5-missed", "2030-04-08T22:01:00+02:00", "sandra")
	)
	var manquee_rechargee := _recharger(manquee["moteur"], manquee["etat"])
	_expect(
		resultat_manque["ok"] and manquee_rechargee["ok"]
		and manquee_rechargee["moteur"].obtenir_instance("a5-missed").obtenir_statut() == InstanceModele.MISSED,
		"03 round-trip MISSED",
	)

	var annulee := _signature_proposee("a5-cancelled")
	var resultat_annulation: Dictionary = annulee["moteur"].annuler(
		annulee["instance"], "ANNULATION_A5", "2030-04-08T19:02:00+02:00"
	)
	var annulee_rechargee := _recharger(annulee["moteur"], annulee["etat"])
	_expect(
		resultat_annulation["ok"] and annulee_rechargee["ok"]
		and annulee_rechargee["moteur"].obtenir_instance("a5-cancelled").obtenir_statut() == InstanceModele.CANCELLED,
		"04 round-trip CANCELLED",
	)


func _test_unique_reconstruite_et_repetable_reutilisable() -> void:
	var unique := _signature_proposee("a5-unique")
	unique["moteur"].resoudre(
		unique["instance"], definitions["signature_sandra"], "sobre", "resolution_commune",
		unique["etat"], unique["contexte"]
	)
	var unique_rechargee := _recharger(unique["moteur"], unique["etat"])
	var contexte_unique := _contexte("a5-unique-bis", "2030-04-08T19:10:00+02:00", "sandra")
	var diagnostic_unique: Dictionary = unique_rechargee["moteur"].evaluer_definition(
		definitions["signature_sandra"], unique_rechargee["etat"], contexte_unique
	)
	var instance_unique = unique_rechargee["moteur"].creer_instance(
		definitions["signature_sandra"], diagnostic_unique, contexte_unique
	)
	_expect(
		not diagnostic_unique["eligible"] and instance_unique == null
		and unique_rechargee["moteur"].obtenir_derniere_erreur_instance() == "SCENE_UNIQUE_DEJA_INSTANCIEE",
		"05 unicite UNIQUE reconstruite apres reload",
	)

	var repetable := _repetable_proposee("a5-repeatable")
	repetable["moteur"].resoudre(
		repetable["instance"], definitions["module_distance_sandra"], "sobre", "echo_sandra_local",
		repetable["etat"], repetable["contexte"]
	)
	var repetable_rechargee := _recharger(repetable["moteur"], repetable["etat"])
	var contexte_repetable := _contexte("a5-repeatable-bis", "2030-04-09T10:20:00+02:00", "sandra")
	var diagnostic_repetable: Dictionary = repetable_rechargee["moteur"].evaluer_definition(
		definitions["module_distance_sandra"], repetable_rechargee["etat"], contexte_repetable
	)
	var instance_repetable = repetable_rechargee["moteur"].creer_instance(
		definitions["module_distance_sandra"], diagnostic_repetable, contexte_repetable
	)
	_expect(diagnostic_repetable["eligible"] and instance_repetable != null, "06 scene REPETABLE reutilisable apres reload")


func _test_transaction_reprise_et_resolution_differente() -> void:
	var paquet := _signature_proposee("a5-idempotent")
	paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu",
		paquet["etat"], paquet["contexte"]
	)
	var transaction_id: String = str(paquet["instance"].obtenir_terminaison()["transaction_id"])
	var recharge := _recharger(paquet["moteur"], paquet["etat"])
	var instance = recharge["moteur"].obtenir_instance("a5-idempotent")
	var terminaison: Dictionary = instance.obtenir_terminaison()
	var reprise: Dictionary = recharge["moteur"].resoudre(
		instance, definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu",
		recharge["etat"], paquet["contexte"]
	)
	var avant: Dictionary = recharge["moteur"].obtenir_snapshot(recharge["etat"])
	var differente: Dictionary = recharge["moteur"].resoudre(
		instance, definitions["signature_sandra"], "audacieuse", "limite_audace_explicite",
		recharge["etat"], paquet["contexte"]
	)
	_expect(terminaison["transaction_id"] == transaction_id, "07 transaction_id conserve")
	_expect(reprise["ok"] and reprise["transaction"]["statut"] == "IDEMPOTENT", "08 reprise identique idempotente apres reload")
	_expect(
		not differente["ok"] and differente["erreur"] == "RESOLUTION_TERMINALE_DIFFERENTE"
		and recharge["moteur"].obtenir_snapshot(recharge["etat"]) == avant,
		"09 seconde resolution differente refusee apres reload",
	)


func _test_portees_locale_et_temporaire() -> void:
	var locale := _signature_proposee("a5-local-absent")
	locale["moteur"].resoudre(
		locale["instance"], definitions["signature_sandra"], "sobre", "resolution_commune",
		locale["etat"], locale["contexte"]
	)
	var snapshot_local: Dictionary = locale["moteur"].obtenir_snapshot(locale["etat"])
	var serialise := JSON.stringify(snapshot_local)
	_expect(serialise.find("LOCALE") == -1 and serialise.find('"LOCAL"') == -1, "10 effet LOCAL absent du snapshot")

	var temporaire := _repetable_proposee("a5-temporary")
	var ajout: Dictionary = temporaire["moteur"].declarer_reprise_temporaire(
		temporaire["instance"], definitions["module_distance_sandra"], "echo_sandra_local",
		"a5-trace-active", "sequence_courte_a_reprendre",
		"2030-04-09T10:11:00+02:00"
	)
	var snapshot_actif: Dictionary = temporaire["moteur"].obtenir_snapshot(temporaire["etat"])
	var resultat_recharge: Dictionary = MoteurModele.creer_depuis_snapshot(snapshot_actif)
	var recharge := {
		"ok": resultat_recharge["ok"],
		"moteur": resultat_recharge["moteur"],
		"etat": resultat_recharge["etat_narratif"],
	}
	var instance_rechargee = recharge["moteur"].obtenir_instance("a5-temporary")
	_expect(
		ajout["ok"] and recharge["ok"] and snapshot_actif["scene_registry"][0]["temporary_traces"].has("a5-trace-active")
		and instance_rechargee.obtenir_snapshot()["traces_temporaires"].has("a5-trace-active"),
		"11 TEMPORAIRE conservee pour instance active",
	)
	var cloture: Dictionary = recharge["moteur"].resoudre(
		instance_rechargee, definitions["module_distance_sandra"], "sobre", "echo_sandra_local",
		recharge["etat"], _contexte("a5-temporary", "2030-04-09T10:11:00+02:00", "sandra")
	)
	var snapshot_clos: Dictionary = recharge["moteur"].obtenir_snapshot(recharge["etat"])
	_expect(
		cloture["ok"] and instance_rechargee.obtenir_snapshot()["traces_temporaires"].is_empty()
		and snapshot_clos["scene_registry"][0]["temporary_traces"].is_empty(),
		"12 TEMPORAIRE nettoyee a la cloture",
	)


func _test_snapshots_invalides_sans_mutation_partielle() -> void:
	var cible := _signature_proposee("a5-atomic-target")
	var avant: Dictionary = cible["moteur"].obtenir_snapshot(cible["etat"])
	var ancien: Dictionary = avant.duplicate(true)
	ancien["version"] = 0
	var rejet_ancien: Dictionary = MoteurModele.creer_depuis_snapshot(ancien)
	_expect(
		not rejet_ancien["ok"] and rejet_ancien["erreur"] == "SNAPSHOT_A5_VERSION_INCOMPATIBLE"
		and cible["moteur"].obtenir_snapshot(cible["etat"]) == avant,
		"13 snapshot ancien refuse sans mutation",
	)
	var corrompu: Dictionary = avant.duplicate(true)
	corrompu["scene_registry"][0]["state"] = "ETAT_INCONNU"
	var rejet_corrompu: Dictionary = MoteurModele.creer_depuis_snapshot(corrompu)
	_expect(
		not rejet_corrompu["ok"] and rejet_corrompu["erreur"] == "REGISTRE_SCENES_INVALIDE"
		and cible["moteur"].obtenir_snapshot(cible["etat"]) == avant,
		"14 registre invalide refuse sans mutation partielle",
	)
	var etat_corrompu: Dictionary = avant.duplicate(true)
	etat_corrompu["narrative_state"]["racine_inattendue"] = {}
	var rejet_etat: Dictionary = MoteurModele.creer_depuis_snapshot(etat_corrompu)
	_expect(
		not rejet_etat["ok"] and rejet_etat["erreur"] == "ETAT_NARRATIF_INVALIDE"
		and cible["moteur"].obtenir_snapshot(cible["etat"]) == avant,
		"15 etat A1 invalide refuse sans mutation partielle",
	)


func _test_invariants_a1_apres_rechargement() -> void:
	var paquet := _signature_proposee("a5-a1-invariants")
	paquet["moteur"].resoudre(
		paquet["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu",
		paquet["etat"], paquet["contexte"]
	)
	var recharge := _recharger(paquet["moteur"], paquet["etat"])
	var snapshot: Dictionary = recharge["etat"].obtenir_snapshot()
	_expect(snapshot["relations"].size() == 6 and not snapshot["relations"].has("player"), "16 six relations A1 conservees")
	_expect(snapshot.keys() == paquet["etat"].obtenir_snapshot().keys(), "17 racines A1 conservees")
	_expect(snapshot["evenements"] == paquet["etat"].obtenir_snapshot()["evenements"], "18 evenements A1 conserves")


func _test_durcissement_du_format_persistant() -> void:
	var annulation_manquee := _signature_proposee("a5-missed-cancelled")
	var definition_annulation: Dictionary = definitions["signature_sandra"].duplicate(true)
	definition_annulation["politique_non_resolution"]["proposition_expire"] = InstanceModele.CANCELLED
	var resultat_manque: Dictionary = annulation_manquee["moteur"].manquer(
		annulation_manquee["instance"], definition_annulation, annulation_manquee["etat"],
		_contexte("a5-missed-cancelled", "2030-04-08T22:01:00+02:00", "sandra")
	)
	var recharge_manquee := _recharger(annulation_manquee["moteur"], annulation_manquee["etat"])
	var reprise_manquee: Dictionary = recharge_manquee["moteur"].manquer(
		recharge_manquee["moteur"].obtenir_instance("a5-missed-cancelled"),
		definition_annulation,
		recharge_manquee["etat"],
		_contexte("a5-missed-cancelled", "2030-04-08T22:01:00+02:00", "sandra")
	)
	_expect(
		resultat_manque["ok"] and recharge_manquee["ok"] and reprise_manquee["ok"]
		and reprise_manquee["transaction"]["statut"] == "IDEMPOTENT",
		"19 CANCELLED par opportunite manquee rechargee et idempotente",
	)

	var unique := _signature_proposee("a5-policy-tamper")
	var snapshot_unique: Dictionary = unique["moteur"].obtenir_snapshot(unique["etat"])
	snapshot_unique["scene_registry"][0]["uniqueness_policy"] = "REPETABLE"
	var recharge_unique: Dictionary = MoteurModele.creer_depuis_snapshot(snapshot_unique)
	var diagnostic_unique: Dictionary = recharge_unique["moteur"].evaluer_definition(
		definitions["signature_sandra"], recharge_unique["etat_narratif"],
		_contexte("a5-policy-tamper-bis", "2030-04-08T19:10:00+02:00", "sandra")
	)
	var lien_falsifie: Dictionary = recharge_unique["moteur"].resoudre(
		recharge_unique["moteur"].obtenir_instance("a5-policy-tamper"), definitions["signature_sandra"],
		"sobre", "resolution_commune", recharge_unique["etat_narratif"], unique["contexte"]
	)
	_expect(
		recharge_unique["ok"] and not diagnostic_unique["eligible"]
		and lien_falsifie["erreur"] == "POLITIQUE_UNICITE_INCOHERENTE",
		"20 politique falsifiee ne contourne pas UNIQUE",
	)

	var horodatage_invalide: Dictionary = unique["moteur"].obtenir_snapshot(unique["etat"])
	horodatage_invalide["scene_registry"][0]["last_transition_at"] = "2030-99-99T99:99"
	_expect(
		not MoteurModele.creer_depuis_snapshot(horodatage_invalide)["ok"],
		"21 horodatage persistant invalide refuse",
	)

	var durable := _signature_proposee("a5-forged-durable")
	durable["moteur"].resoudre(
		durable["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu",
		durable["etat"], durable["contexte"]
	)
	var snapshot_durable: Dictionary = durable["moteur"].obtenir_snapshot(durable["etat"])
	var transaction_id: String = snapshot_durable["scene_registry"][0]["transaction_id"]
	snapshot_durable["narrative_state"]["evenements"].erase(transaction_id)
	var recharge_durable: Dictionary = MoteurModele.creer_depuis_snapshot(snapshot_durable)
	var reprise_durable: Dictionary = recharge_durable["moteur"].resoudre(
		recharge_durable["moteur"].obtenir_instance("a5-forged-durable"), definitions["signature_sandra"],
		"chaleureuse", "signal_chaleureux_recu", recharge_durable["etat_narratif"], durable["contexte"]
	)
	_expect(
		recharge_durable["ok"] and not reprise_durable["ok"]
		and reprise_durable["erreur"] == "TERMINAISON_PERSISTEE_INCOHERENTE",
		"22 terminaison durable sans evenement A1 refusee",
	)
	var evenement_falsifie: Dictionary = durable["moteur"].obtenir_snapshot(durable["etat"])
	evenement_falsifie["narrative_state"]["evenements"][transaction_id]["provenance"]["source_signal_emis"] = "SIGNAL_FALSIFIE"
	var recharge_falsifiee: Dictionary = MoteurModele.creer_depuis_snapshot(evenement_falsifie)
	var reprise_falsifiee: Dictionary = recharge_falsifiee["moteur"].resoudre(
		recharge_falsifiee["moteur"].obtenir_instance("a5-forged-durable"), definitions["signature_sandra"],
		"chaleureuse", "signal_chaleureux_recu", recharge_falsifiee["etat_narratif"], durable["contexte"]
	)
	_expect(
		recharge_falsifiee["ok"] and not reprise_falsifiee["ok"]
		and reprise_falsifiee["erreur"] == "TERMINAISON_PERSISTEE_INCOHERENTE",
		"23 evenement durable falsifie refuse a la reprise",
	)

	_expect(
		not MoteurModele.creer_depuis_snapshot([])["ok"],
		"24 racine de snapshot non dictionnaire refusee proprement",
	)

	var trace_locale: Dictionary = unique["moteur"].obtenir_snapshot(unique["etat"])
	trace_locale["scene_registry"][0]["temporary_traces"] = {
		"a5-local-injection": {
			"trace_id": "a5-local-injection",
			"scope": "LOCAL",
			"content": "ne_doit_pas_survivre",
			"source_scene_instance_id": "a5-policy-tamper",
			"source_resolution_id": "resolution_commune",
			"created_at": "2030-04-08T19:00:00+02:00",
		},
	}
	_expect(
		not MoteurModele.creer_depuis_snapshot(trace_locale)["ok"],
		"25 injection LOCAL dans les traces temporaires refusee",
	)
	var declaration_locale: Dictionary = unique["moteur"].declarer_reprise_temporaire(
		unique["instance"], definitions["signature_sandra"], "resolution_commune",
		"a5-local-declaration", "contenu_local", "2030-04-08T19:01:00+02:00"
	)
	_expect(
		not declaration_locale["ok"] and declaration_locale["erreur"] == "RESOLUTION_NON_TEMPORAIRE",
		"26 resolution LOCALE refusee comme reprise temporaire",
	)

	var instant_negatif: Dictionary = unique["moteur"].obtenir_snapshot(unique["etat"])
	instant_negatif["scene_registry"][0]["last_transition_at"] = "2030-04-08T19:00:-1+02:00"
	_expect(
		not MoteurModele.creer_depuis_snapshot(instant_negatif)["ok"],
		"27 composante temporelle negative refusee",
	)

	var historique := _signature_proposee("a5-historical-retry")
	historique["moteur"].resoudre(
		historique["instance"], definitions["signature_sandra"], "chaleureuse", "signal_chaleureux_recu",
		historique["etat"], historique["contexte"]
	)
	var faits_apres: Array = historique["etat"].obtenir_snapshot()["relations"]["sandra"]["faits"].duplicate(true)
	faits_apres.append({"fait_id": "fait_posterieur", "nature": "PRECONDITION_SYNTHETIQUE"})
	historique["etat"].traiter_evenement({
		"event_id": "a5-evenement-posterieur",
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "a5_historical_retry"},
		"payload": {"personnage_id": "sandra", "changements": {"faits": faits_apres}},
	})
	var recharge_historique := _recharger(historique["moteur"], historique["etat"])
	var reprise_historique: Dictionary = recharge_historique["moteur"].resoudre(
		recharge_historique["moteur"].obtenir_instance("a5-historical-retry"), definitions["signature_sandra"],
		"chaleureuse", "signal_chaleureux_recu", recharge_historique["etat"], historique["contexte"]
	)
	_expect(
		reprise_historique["ok"] and reprise_historique["transaction"]["statut"] == "IDEMPOTENT",
		"28 ancienne transaction durable reste reprenable apres evenement ulterieur",
	)

	var etat_fait_chaine = _nouvel_etat()
	etat_fait_chaine.traiter_evenement({
		"event_id": "a5-fait-chaine",
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "a5_fait_chaine"},
		"payload": {"personnage_id": "sandra", "changements": {"faits": ["preuve-synthetique"]}},
	})
	var recharge_fait_chaine := _recharger(MoteurModele.new(), etat_fait_chaine)
	_expect(
		recharge_fait_chaine["ok"]
		and recharge_fait_chaine["etat"].obtenir_snapshot()["relations"]["sandra"]["faits"] == ["preuve-synthetique"],
		"29 fait chaine A1 legal reste compatible avec le codec A5",
	)
	var etat_fait_minimal = _nouvel_etat()
	etat_fait_minimal.traiter_evenement({
		"event_id": "a5-fait-minimal",
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "a5_fait_minimal"},
		"payload": {"personnage_id": "sandra", "changements": {"faits": [{"fait_id": "fait-synthetique"}]}},
	})
	var recharge_fait_minimal := _recharger(MoteurModele.new(), etat_fait_minimal)
	_expect(
		recharge_fait_minimal["ok"]
		and recharge_fait_minimal["etat"].obtenir_snapshot()["relations"]["sandra"]["faits"] == [{"fait_id": "fait-synthetique"}],
		"30 fait dictionnaire minimal A1 reste compatible avec le codec A5",
	)


func _test_terminaison_bornee_avant_mutation() -> void:
	var instance_id := "i".repeat(500)
	var paquet := _signature_proposee(instance_id)
	var avant_etat: Dictionary = paquet["etat"].obtenir_snapshot()
	var avant_instance: Dictionary = paquet["instance"].obtenir_snapshot()
	var annulation: Dictionary = paquet["moteur"].annuler(
		paquet["instance"], "r".repeat(500), "2030-04-08T19:01:00+02:00"
	)
	var snapshot: Dictionary = paquet["moteur"].obtenir_snapshot(paquet["etat"])
	var recharge: Dictionary = MoteurModele.creer_depuis_snapshot(snapshot)
	_expect(
		not annulation["ok"] and annulation["erreur"] == "donnees terminales invalides"
		and paquet["etat"].obtenir_snapshot() == avant_etat
		and paquet["instance"].obtenir_snapshot() == avant_instance
		and recharge["ok"],
		"31 terminaison hors borne refusee avant mutation et snapshot toujours rechargeable",
	)


func _recharger(moteur, etat) -> Dictionary:
	var snapshot: Dictionary = moteur.obtenir_snapshot(etat)
	var resultat: Dictionary = MoteurModele.creer_depuis_snapshot(snapshot)
	return {
		"ok": resultat["ok"],
		"erreur": resultat["erreur"],
		"moteur": resultat["moteur"],
		"etat": resultat["etat_narratif"],
	}


func _signature_proposee(instance_id: String) -> Dictionary:
	var etat = _etat_avec_evenement("r8c-a3-sandra-relation-ready", "sandra", "relation_sandra_prete")
	var moteur := MoteurModele.new()
	var contexte := _contexte(instance_id, "2030-04-08T19:00:00+02:00", "sandra")
	var instance = _creer_et_proposer(moteur, definitions["signature_sandra"], etat, contexte)
	return {"etat": etat, "moteur": moteur, "contexte": contexte, "instance": instance}


func _repetable_proposee(instance_id: String) -> Dictionary:
	var etat = _etat_avec_evenement("r8c-a3-sandra-away", "sandra", "sandra_absente")
	var moteur := MoteurModele.new()
	var contexte := _contexte(instance_id, "2030-04-09T10:10:00+02:00", "sandra")
	var instance = _creer_et_proposer(moteur, definitions["module_distance_sandra"], etat, contexte)
	return {"etat": etat, "moteur": moteur, "contexte": contexte, "instance": instance}


func _creer_et_proposer(moteur, definition: Dictionary, etat, contexte: Dictionary):
	var diagnostic: Dictionary = moteur.evaluer_definition(definition, etat, contexte)
	var instance = moteur.creer_instance(definition, diagnostic, contexte)
	if instance != null:
		moteur.proposer(instance, definition, etat, contexte)
	return instance


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
	var faits: Array = etat.obtenir_snapshot()["relations"][personnage_id]["faits"].duplicate(true)
	faits.append({"fait_id": fait_id, "nature": "PRECONDITION_SYNTHETIQUE"})
	etat.traiter_evenement({
		"event_id": event_id,
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {"type": "TEST_SYNTHETIQUE", "id": "r8c_a5_smoke"},
		"payload": {"personnage_id": personnage_id, "changements": {"faits": faits}},
	})
	return etat


func _contexte(instance_id: String, moment: String, personnage_disponible: String) -> Dictionary:
	return {
		"instance_id": instance_id,
		"acte_courant": "ACTE_SYNTHETIQUE_A3",
		"moment_diegetique": moment,
		"participants_disponibles": {personnage_disponible: true},
		"opportunite_valide": true,
	}


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
