extends RefCounted

class_name R8CMinimalSceneEngine

const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")
const InstanceModele := preload("res://scripts/narrative_scene/SceneInstance.gd")
const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")

var _instances_par_id: Dictionary = {}
var _scenes_uniques_resolues: Dictionary = {}
var _derniere_erreur_instance := ""


func evaluer_definition(definition: Dictionary, etat_narratif, contexte: Dictionary) -> Dictionary:
	var erreur_definition := DefinitionModele.valider(definition)
	if not erreur_definition.is_empty():
		return _diagnostic_invalide("DEFINITION_INVALIDE", erreur_definition, contexte)
	if etat_narratif == null:
		return _diagnostic_invalide("ETAT_NARRATIF_ABSENT", "etat narratif absent", contexte)
	var snapshot: Dictionary = etat_narratif.obtenir_snapshot()
	var satisfaites := []
	var echecs := []
	var details := []
	_evaluer_acte(definition, contexte, satisfaites, echecs, details)
	_evaluer_evenements(definition, snapshot, satisfaites, echecs, details)
	_evaluer_participants(definition, contexte, satisfaites, echecs, details)
	_evaluer_unicite(definition, snapshot, contexte, satisfaites, echecs, details)
	_evaluer_fenetre(definition, contexte, satisfaites, echecs, details)
	_evaluer_opportunite(contexte, satisfaites, echecs, details)
	var event_ids: Array = snapshot["evenements"].keys()
	event_ids.sort()
	return {
		"eligible": echecs.is_empty(),
		"statut": InstanceModele.ELIGIBLE if echecs.is_empty() else InstanceModele.INELIGIBLE,
		"raisons_conditions_satisfaites": satisfaites,
		"raisons_ineligibilite": echecs,
		"conditions_evaluees": details,
		"revalidation_requise_avant": _echeance_revalidation(definition),
		"event_ids_observes": event_ids,
	}


func creer_instance(definition: Dictionary, diagnostic: Dictionary, contexte: Dictionary):
	_derniere_erreur_instance = ""
	var erreur_definition := DefinitionModele.valider(definition)
	if not erreur_definition.is_empty():
		_derniere_erreur_instance = "DEFINITION_INVALIDE"
		return null
	var instance_id = contexte.get("instance_id")
	if typeof(instance_id) != TYPE_STRING or instance_id.strip_edges().is_empty():
		_derniere_erreur_instance = "INSTANCE_ID_INVALIDE"
		return null
	if _instances_par_id.has(instance_id):
		_derniere_erreur_instance = "INSTANCE_ID_DUPLIQUE"
		return null
	if definition["politique_unicite"] == "UNIQUE" and _scene_unique_concurrente(definition["scene_id"], ""):
		_derniere_erreur_instance = "SCENE_UNIQUE_DEJA_INSTANCIEE"
		return null
	var instance = InstanceModele.creer(definition, diagnostic, contexte)
	if instance == null:
		_derniere_erreur_instance = "INSTANCE_INVALIDE"
		return null
	_instances_par_id[instance_id] = instance
	return instance


func obtenir_derniere_erreur_instance() -> String:
	return _derniere_erreur_instance


func reevaluer_instance(instance, definition: Dictionary, etat_narratif, contexte: Dictionary) -> Dictionary:
	if instance == null or instance.obtenir_statut() not in [InstanceModele.INELIGIBLE, InstanceModele.ELIGIBLE]:
		return _resultat_operation(false, "INSTANCE_NON_REEVALUABLE", {}, {})
	var erreur_lien := _valider_lien_instance(instance, definition)
	if not erreur_lien.is_empty():
		return _resultat_operation(false, erreur_lien, {}, {})
	var diagnostic := evaluer_definition(definition, etat_narratif, contexte)
	var cible: String = diagnostic["statut"]
	if cible == instance.obtenir_statut():
		return _resultat_operation(true, "", {"ok": true, "statut": cible, "inchange": true}, diagnostic)
	var transition: Dictionary = instance.transitionner(
		cible,
		"REEVALUATION_CONTEXTE_COURANT",
		contexte.get("moment_diegetique", "INSTANT_INCONNU"),
	)
	return _resultat_operation(transition["ok"], transition["erreur"], transition, diagnostic)


func proposer(instance, definition: Dictionary, etat_narratif, contexte: Dictionary) -> Dictionary:
	if instance == null or instance.obtenir_statut() != InstanceModele.ELIGIBLE:
		return _resultat_operation(false, "INSTANCE_NON_ELIGIBLE", {}, {})
	var erreur_lien := _valider_lien_instance(instance, definition)
	if not erreur_lien.is_empty():
		return _resultat_operation(false, erreur_lien, {}, {})
	var diagnostic := evaluer_definition(definition, etat_narratif, contexte)
	if not diagnostic["eligible"]:
		var preparation: Dictionary = instance.preparer_transition(
			InstanceModele.INELIGIBLE,
			"REVALIDATION_INELIGIBLE",
			contexte.get("moment_diegetique", "INSTANT_INCONNU"),
		)
		if preparation["ok"]:
			instance.appliquer_transition_preparee(preparation)
		return _resultat_operation(false, "REVALIDATION_INELIGIBLE", preparation, diagnostic)
	var transition: Dictionary = instance.transitionner(
		InstanceModele.PROPOSED,
		"OPPORTUNITE_RENDUE_PERCEPTIBLE",
		contexte["moment_diegetique"],
	)
	return _resultat_operation(transition["ok"], transition["erreur"], transition, diagnostic)


func resoudre(
	instance,
	definition: Dictionary,
	choix_id: String,
	resolution_id: String,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	if instance == null:
		return _resultat_transaction(false, "INSTANCE_ABSENTE", {}, {}, {}, {})
	var erreur_lien := _valider_lien_instance(instance, definition)
	if not erreur_lien.is_empty():
		return _resultat_transaction(false, erreur_lien, {}, {}, {}, {})
	var erreur_definition := DefinitionModele.valider(definition)
	if not erreur_definition.is_empty():
		return _resultat_transaction(false, erreur_definition, {}, {}, {}, {})
	var transaction_id := _transaction_id_resolution(instance, resolution_id)
	var reprise := _verifier_reprise(instance, "RESOLUTION", transaction_id, choix_id, resolution_id)
	if not reprise.is_empty():
		return reprise
	if instance.obtenir_statut() != InstanceModele.PROPOSED:
		return _resultat_transaction(false, "INSTANCE_NON_PROPOSEE", {}, {}, {}, {})
	if etat_narratif == null:
		return _resultat_transaction(false, "ETAT_NARRATIF_ABSENT", {}, {}, {}, {})
	var choix := _chercher_choix(definition, choix_id)
	if choix.is_empty():
		return _resultat_transaction(false, "CHOIX_INCONNU", {}, {}, {}, {})
	if resolution_id not in choix["resolution_ids"]:
		return _resultat_transaction(false, "RESOLUTION_INCOMPATIBLE_AVEC_CHOIX", {}, {}, {}, {})
	var resolution: Dictionary = definition["resolutions"][resolution_id]
	if choix["signal_emis"] != resolution["signal_recu"]:
		return _resultat_transaction(false, "CHAINE_SIGNAL_INCOHERENTE", {}, {}, {}, {})
	var diagnostic_revalidation := {}
	if definition["contrat_temporel"]["revalidation"] == "AVANT_PROPOSITION_ET_RESOLUTION":
		var contexte_revalidation: Dictionary = contexte.duplicate(true)
		contexte_revalidation["_transaction_id_reprise"] = transaction_id
		diagnostic_revalidation = evaluer_definition(definition, etat_narratif, contexte_revalidation)
		if not diagnostic_revalidation["eligible"]:
			return _resultat_transaction(
				false,
				"REVALIDATION_RESOLUTION_INELIGIBLE",
				{},
				{},
				{},
				diagnostic_revalidation,
			)
	var diagnostic_signal := {
		"choix_id": choix_id,
		"signal_emis": choix["signal_emis"],
		"signal_recu": resolution["signal_recu"],
		"portee_micro_signal": resolution["portee_micro_signal"],
		"reception": resolution["reception"],
		"interpretation": resolution["interpretation"],
		"convergence": resolution["convergence"],
	}
	var terminaison := {
		"operation": "RESOLUTION",
		"transaction_id": transaction_id,
		"choix_id": choix_id,
		"resolution_id": resolution_id,
		"portee_micro_signal": resolution["portee_micro_signal"],
	}
	var trace_temporaire := {}
	if resolution["portee_micro_signal"] == "TEMPORAIRE":
		trace_temporaire = resolution["trace_temporaire"].duplicate(true)
		trace_temporaire["source_scene_instance_id"] = instance.obtenir_snapshot()["instance_id"]
		trace_temporaire["source_resolution_id"] = resolution_id
		trace_temporaire["moment_diegetique"] = contexte["moment_diegetique"]
	var preparation: Dictionary = instance.preparer_transition(
		InstanceModele.RESOLVED,
		"RESOLUTION_PREPAREE_AVANT_TRANSACTION",
		contexte["moment_diegetique"],
		terminaison,
		trace_temporaire,
	)
	if not preparation["ok"]:
		return _resultat_transaction(false, "TRANSITION_NON_PREPARABLE", {}, {}, diagnostic_signal, diagnostic_revalidation)
	var evenement := {}
	if resolution["portee_micro_signal"] == "DURABLE":
		evenement = _construire_evenement_resolution(
			instance,
			definition,
			choix_id,
			resolution_id,
			resolution,
			transaction_id,
			etat_narratif,
			contexte,
		)
		if evenement.is_empty():
			return _resultat_transaction(false, "CONSEQUENCE_NON_APPLICABLE", {}, {}, diagnostic_signal, diagnostic_revalidation)
	return _finaliser(
		instance,
		definition,
		preparation,
		etat_narratif,
		evenement,
		diagnostic_signal,
		diagnostic_revalidation,
	)


func manquer(instance, definition: Dictionary, etat_narratif, contexte: Dictionary) -> Dictionary:
	if instance == null:
		return _resultat_transaction(false, "INSTANCE_ABSENTE", {}, {}, {}, {})
	var erreur_lien := _valider_lien_instance(instance, definition)
	if not erreur_lien.is_empty():
		return _resultat_transaction(false, erreur_lien, {}, {}, {}, {})
	var erreur_definition := DefinitionModele.valider(definition)
	if not erreur_definition.is_empty():
		return _resultat_transaction(false, erreur_definition, {}, {}, {}, {})
	if etat_narratif == null:
		return _resultat_transaction(false, "ETAT_NARRATIF_ABSENT", {}, {}, {}, {})
	var instance_id: String = instance.obtenir_snapshot()["instance_id"]
	var transaction_id := "r8c-a3:%s:missed" % instance_id
	var reprise := _verifier_reprise(instance, "MANQUEE", transaction_id, "", "opportunite_manquee")
	if not reprise.is_empty():
		return reprise
	if instance.obtenir_statut() != InstanceModele.PROPOSED:
		return _resultat_transaction(false, "INSTANCE_NON_PROPOSEE", {}, {}, {}, {})
	var politique = definition.get("politique_non_resolution")
	if typeof(politique) != TYPE_DICTIONARY:
		return _resultat_transaction(false, "POLITIQUE_NON_RESOLUTION_ABSENTE", {}, {}, {}, {})
	var statut_cible: String = politique["proposition_expire"]
	if not _fenetre_depassee(definition["contrat_temporel"], contexte.get("moment_diegetique", "")):
		return _resultat_transaction(false, "ECHEANCE_NON_FRANCHIE", {}, {}, {}, {})
	var terminaison := {
		"operation": "MANQUEE",
		"transaction_id": transaction_id,
		"choix_id": "",
		"resolution_id": "opportunite_manquee",
		"portee_micro_signal": "DURABLE" if politique.has("consequence_manquee") else "LOCALE",
	}
	var preparation: Dictionary = instance.preparer_transition(
		statut_cible,
		"PROPOSITION_VISIBLE_EXPIREE",
		contexte["moment_diegetique"],
		terminaison,
	)
	if not preparation["ok"]:
		return _resultat_transaction(false, "TRANSITION_NON_PREPARABLE", {}, {}, {}, {})
	var evenement := {}
	if politique.has("consequence_manquee"):
		evenement = _construire_evenement_manque(
			instance,
			definition,
			politique["consequence_manquee"],
			statut_cible,
			transaction_id,
			etat_narratif,
			contexte,
		)
		if evenement.is_empty():
			return _resultat_transaction(false, "CONSEQUENCE_NON_APPLICABLE", {}, {}, {}, {})
	return _finaliser(instance, definition, preparation, etat_narratif, evenement, {}, {})


func annuler(instance, code_raison: String, moment_diegetique: String) -> Dictionary:
	if instance == null:
		return {"ok": false, "erreur": "INSTANCE_ABSENTE", "statut": InstanceModele.INELIGIBLE}
	return instance.transitionner(InstanceModele.CANCELLED, code_raison, moment_diegetique)


func _finaliser(
	instance,
	definition: Dictionary,
	preparation: Dictionary,
	etat_narratif,
	evenement: Dictionary,
	diagnostic_signal: Dictionary,
	diagnostic_revalidation: Dictionary
) -> Dictionary:
	var transaction := {"ok": true, "statut": "NON_PERSISTE", "erreur": ""}
	if not evenement.is_empty():
		transaction = etat_narratif.traiter_evenement(evenement)
		if transaction["statut"] not in ["APPLIQUE", "IDEMPOTENT"]:
			return _resultat_transaction(
				false,
				"TRANSACTION_REJETEE",
				transaction,
				evenement,
				diagnostic_signal,
				diagnostic_revalidation,
			)
	instance.appliquer_transition_preparee(preparation)
	if definition["politique_unicite"] == "UNIQUE" and preparation["statut"] == InstanceModele.RESOLVED:
		_scenes_uniques_resolues[definition["scene_id"]] = true
	return _resultat_transaction(
		true,
		"",
		transaction,
		evenement,
		diagnostic_signal,
		diagnostic_revalidation,
	)


func _verifier_reprise(
	instance,
	operation: String,
	transaction_id: String,
	choix_id: String,
	resolution_id: String
) -> Dictionary:
	var terminaison: Dictionary = instance.obtenir_terminaison()
	if terminaison.is_empty():
		return {}
	if (
		terminaison.get("operation") == operation
		and terminaison.get("transaction_id") == transaction_id
		and terminaison.get("choix_id", "") == choix_id
		and terminaison.get("resolution_id") == resolution_id
	):
		return _resultat_transaction(
			true,
			"",
			{"ok": true, "statut": "IDEMPOTENT", "erreur": ""},
			{},
			{"reprise_transaction_id": transaction_id},
			{},
		)
	return _resultat_transaction(false, "RESOLUTION_TERMINALE_DIFFERENTE", {}, {}, {}, {})


func _evaluer_acte(
	definition: Dictionary,
	contexte: Dictionary,
	satisfaites: Array,
	echecs: Array,
	details: Array
) -> void:
	var acte = contexte.get("acte_courant")
	var compatible: bool = acte in definition["conditions_dures"]["actes_compatibles"]
	_ajouter_condition(
		"ACTE_COMPATIBLE",
		compatible,
		"CONDITION_ACTE_COMPATIBLE" if compatible else "ACTE_INCOMPATIBLE",
		satisfaites,
		echecs,
		details,
	)


func _evaluer_evenements(
	definition: Dictionary,
	snapshot: Dictionary,
	satisfaites: Array,
	echecs: Array,
	details: Array
) -> void:
	var evenements: Dictionary = snapshot["evenements"]
	for event_id in definition["conditions_dures"]["evenements_requis"]:
		var present := evenements.has(event_id)
		_ajouter_condition(
			"EVENEMENT_PRESENT:%s" % event_id,
			present,
			"CONDITION_EVENEMENT_PRESENT:%s" % event_id if present else "EVENEMENT_REQUIS_ABSENT:%s" % event_id,
			satisfaites,
			echecs,
			details,
		)
	for event_id in definition["exclusions_dures"]["evenements_interdits"]:
		var absent := not evenements.has(event_id)
		_ajouter_condition(
			"EVENEMENT_ABSENT:%s" % event_id,
			absent,
			"CONDITION_EVENEMENT_ABSENT:%s" % event_id if absent else "EVENEMENT_INTERDIT_PRESENT:%s" % event_id,
			satisfaites,
			echecs,
			details,
		)


func _evaluer_participants(
	definition: Dictionary,
	contexte: Dictionary,
	satisfaites: Array,
	echecs: Array,
	details: Array
) -> void:
	var disponibilites = contexte.get("participants_disponibles", {})
	for participant in definition["participants_requis"]:
		var personnage_id: String = participant["personnage_id"]
		var disponible: bool = typeof(disponibilites) == TYPE_DICTIONARY and disponibilites.get(personnage_id, false) == true
		_ajouter_condition(
			"PARTICIPANT_DISPONIBLE:%s" % personnage_id,
			disponible,
			"CONDITION_PARTICIPANT_DISPONIBLE:%s" % personnage_id if disponible else "PARTICIPANT_INDISPONIBLE:%s" % personnage_id,
			satisfaites,
			echecs,
			details,
		)


func _evaluer_unicite(
	definition: Dictionary,
	snapshot: Dictionary,
	contexte: Dictionary,
	satisfaites: Array,
	echecs: Array,
	details: Array
) -> void:
	if definition["politique_unicite"] == "REPETABLE":
		_ajouter_condition("SCENE_REPETABLE", true, "CONDITION_SCENE_REPETABLE", satisfaites, echecs, details)
		return
	var scene_id: String = definition["scene_id"]
	var instance_id: String = contexte.get("instance_id", "")
	var transaction_id_reprise: String = contexte.get("_transaction_id_reprise", "")
	var disponible := not _scenes_uniques_resolues.has(scene_id)
	if disponible:
		for evenement in snapshot["evenements"].values():
			var provenance = evenement.get("provenance", {})
			var reprise_courante: bool = (
				transaction_id_reprise != ""
				and evenement.get("event_id") == transaction_id_reprise
				and provenance.get("source_scene_instance_id") == instance_id
			)
			if (
				typeof(provenance) == TYPE_DICTIONARY
				and not reprise_courante
				and provenance.get("source_scene_id") == scene_id
				and provenance.get("scene_status") == InstanceModele.RESOLVED
			):
				disponible = false
				break
	if disponible and _scene_unique_concurrente(scene_id, instance_id):
		disponible = false
	_ajouter_condition(
		"SCENE_UNIQUE_DISPONIBLE",
		disponible,
		"CONDITION_SCENE_UNIQUE_DISPONIBLE" if disponible else "SCENE_DEJA_RESOLUE_OU_INSTANCIEE",
		satisfaites,
		echecs,
		details,
	)


func _scene_unique_concurrente(scene_id: String, instance_id_ignore: String) -> bool:
	for id in _instances_par_id:
		if id == instance_id_ignore:
			continue
		var autre = _instances_par_id[id]
		var snapshot: Dictionary = autre.obtenir_snapshot()
		if snapshot["scene_id"] == scene_id and snapshot["statut"] not in InstanceModele.STATUTS_TERMINAUX:
			return true
	return false


func _evaluer_fenetre(
	definition: Dictionary,
	contexte: Dictionary,
	satisfaites: Array,
	echecs: Array,
	details: Array
) -> void:
	var ouverte := _fenetre_ouverte(definition["contrat_temporel"], contexte.get("moment_diegetique"))
	_ajouter_condition(
		"FENETRE_HORAIRE_OUVERTE",
		ouverte,
		"CONDITION_FENETRE_OUVERTE" if ouverte else "FENETRE_FERMEE",
		satisfaites,
		echecs,
		details,
	)


func _evaluer_opportunite(contexte: Dictionary, satisfaites: Array, echecs: Array, details: Array) -> void:
	var valide: bool = contexte.get("opportunite_valide", false) == true
	_ajouter_condition(
		"OPPORTUNITE_ENCORE_VALIDE",
		valide,
		"CONDITION_OPPORTUNITE_VALIDE" if valide else "OPPORTUNITE_INVALIDE",
		satisfaites,
		echecs,
		details,
	)


func _ajouter_condition(
	nom: String,
	satisfaite: bool,
	code: String,
	satisfaites: Array,
	echecs: Array,
	details: Array
) -> void:
	details.append({"condition": nom, "satisfaite": satisfaite, "code_raison": code})
	if satisfaite:
		satisfaites.append(code)
	else:
		echecs.append(code)


func _fenetre_ouverte(contrat: Dictionary, moment) -> bool:
	if not DefinitionModele.moment_valide(moment):
		return false
	var date: String = moment.substr(0, 10)
	var minutes := DefinitionModele.heure_en_minutes(moment.substr(11, 5))
	var ouverture := DefinitionModele.heure_en_minutes(contrat["heure_ouverture"])
	var fermeture := DefinitionModele.heure_en_minutes(contrat["heure_fermeture"])
	return date >= contrat["date_debut"] and date <= contrat["date_fin"] and minutes >= ouverture and minutes < fermeture


func _fenetre_depassee(contrat: Dictionary, moment) -> bool:
	if not DefinitionModele.moment_valide(moment):
		return false
	var date: String = moment.substr(0, 10)
	if date > contrat["date_fin"]:
		return true
	if date < contrat["date_fin"]:
		return false
	return DefinitionModele.heure_en_minutes(moment.substr(11, 5)) >= DefinitionModele.heure_en_minutes(contrat["heure_fermeture"])


func _echeance_revalidation(definition: Dictionary) -> String:
	var contrat: Dictionary = definition["contrat_temporel"]
	return "%sT%s" % [contrat["date_fin"], contrat["heure_fermeture"]]


func _construire_evenement_resolution(
	instance,
	definition: Dictionary,
	choix_id: String,
	resolution_id: String,
	resolution: Dictionary,
	transaction_id: String,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	var snapshot: Dictionary = etat_narratif.obtenir_snapshot()
	if snapshot["evenements"].has(transaction_id):
		var existant: Dictionary = snapshot["evenements"][transaction_id]
		var provenance: Dictionary = existant.get("provenance", {})
		var payload: Dictionary = existant.get("payload", {})
		var changements = payload.get("changements", {})
		var faits_existants: Array = changements.get("faits", []) if typeof(changements) == TYPE_DICTIONARY else []
		if (
			existant.get("event_type") == EtatNarratifModele.TYPE_RELATION
			and provenance.get("source_scene_id") == definition["scene_id"]
			and provenance.get("source_scene_instance_id") == instance.obtenir_snapshot()["instance_id"]
			and provenance.get("source_resolution_id") == resolution_id
			and provenance.get("source_choix_id") == choix_id
			and provenance.get("source_signal_emis") == resolution["signal_recu"]
			and provenance.get("scene_status") == InstanceModele.RESOLVED
			and payload.get("personnage_id") == resolution["personnage_id"]
			and _faits_sources_presents(
				faits_existants,
				resolution["faits_relationnels"],
				definition["scene_id"],
				instance.obtenir_snapshot()["instance_id"],
				resolution_id,
				contexte["moment_diegetique"],
			)
		):
			return existant.duplicate(true)
	var personnage_id: String = resolution["personnage_id"]
	if not snapshot["relations"].has(personnage_id):
		return {}
	var instance_snapshot: Dictionary = instance.obtenir_snapshot()
	var faits: Array = snapshot["relations"][personnage_id]["faits"].duplicate(true)
	faits.append_array(_faits_sources(
		resolution["faits_relationnels"],
		definition["scene_id"],
		instance_snapshot["instance_id"],
		resolution_id,
		contexte["moment_diegetique"],
	))
	return {
		"event_id": transaction_id,
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {
			"type": "R8C_A3_SCENE_SYNTHETIQUE",
			"id": transaction_id,
			"source_scene_id": definition["scene_id"],
			"source_scene_instance_id": instance_snapshot["instance_id"],
			"source_choix_id": choix_id,
			"source_signal_emis": resolution["signal_recu"],
			"source_resolution_id": resolution_id,
			"scene_status": InstanceModele.RESOLVED,
		},
		"payload": {
			"personnage_id": personnage_id,
			"changements": {"faits": faits},
		},
	}


func _construire_evenement_manque(
	instance,
	definition: Dictionary,
	consequence: Dictionary,
	statut_cible: String,
	transaction_id: String,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	var snapshot: Dictionary = etat_narratif.obtenir_snapshot()
	if snapshot["evenements"].has(transaction_id):
		var existant: Dictionary = snapshot["evenements"][transaction_id]
		var provenance: Dictionary = existant.get("provenance", {})
		var payload: Dictionary = existant.get("payload", {})
		var changements = payload.get("changements", {})
		var faits_existants: Array = changements.get("faits", []) if typeof(changements) == TYPE_DICTIONARY else []
		if (
			existant.get("event_type") == EtatNarratifModele.TYPE_RELATION
			and provenance.get("source_scene_id") == definition["scene_id"]
			and provenance.get("source_scene_instance_id") == instance.obtenir_snapshot()["instance_id"]
			and provenance.get("source_resolution_id") == "opportunite_manquee"
			and provenance.get("scene_status") == statut_cible
			and payload.get("personnage_id") == consequence["personnage_id"]
			and _faits_sources_presents(
				faits_existants,
				[consequence["fait_relationnel"]],
				definition["scene_id"],
				instance.obtenir_snapshot()["instance_id"],
				"opportunite_manquee",
				contexte["moment_diegetique"],
			)
		):
			return existant.duplicate(true)
	var personnage_id = consequence.get("personnage_id")
	if typeof(personnage_id) != TYPE_STRING or not snapshot["relations"].has(personnage_id):
		return {}
	var fait = consequence.get("fait_relationnel")
	if typeof(fait) != TYPE_DICTIONARY:
		return {}
	var instance_snapshot: Dictionary = instance.obtenir_snapshot()
	var faits: Array = snapshot["relations"][personnage_id]["faits"].duplicate(true)
	faits.append_array(_faits_sources(
		[fait],
		definition["scene_id"],
		instance_snapshot["instance_id"],
		"opportunite_manquee",
		contexte["moment_diegetique"],
	))
	return {
		"event_id": transaction_id,
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {
			"type": "R8C_A3_SCENE_SYNTHETIQUE",
			"id": transaction_id,
			"source_scene_id": definition["scene_id"],
			"source_scene_instance_id": instance_snapshot["instance_id"],
			"source_resolution_id": "opportunite_manquee",
			"scene_status": statut_cible,
		},
		"payload": {
			"personnage_id": personnage_id,
			"changements": {"faits": faits},
		},
	}


func _faits_sources(
	modeles: Array,
	scene_id: String,
	instance_id: String,
	resolution_id: String,
	moment_diegetique: String
) -> Array:
	var faits := []
	for modele in modeles:
		var fait: Dictionary = modele.duplicate(true)
		fait["source_scene_id"] = scene_id
		fait["source_scene_instance_id"] = instance_id
		fait["source_resolution_id"] = resolution_id
		fait["moment_diegetique"] = moment_diegetique
		faits.append(fait)
	return faits


func _faits_sources_presents(
	faits_existants: Array,
	modeles: Array,
	scene_id: String,
	instance_id: String,
	resolution_id: String,
	moment_diegetique: String
) -> bool:
	var attendus := _faits_sources(modeles, scene_id, instance_id, resolution_id, moment_diegetique)
	for attendu in attendus:
		var present := false
		for existant in faits_existants:
			if _structures_identiques(existant, attendu):
				present = true
				break
		if not present:
			return false
	return true


func _structures_identiques(gauche, droite) -> bool:
	if typeof(gauche) != typeof(droite):
		return false
	if typeof(gauche) == TYPE_DICTIONARY:
		if gauche.size() != droite.size():
			return false
		for cle in gauche:
			if not droite.has(cle) or not _structures_identiques(gauche[cle], droite[cle]):
				return false
		return true
	if typeof(gauche) == TYPE_ARRAY:
		if gauche.size() != droite.size():
			return false
		for index in range(gauche.size()):
			if not _structures_identiques(gauche[index], droite[index]):
				return false
		return true
	return gauche == droite


func _chercher_choix(definition: Dictionary, choix_id: String) -> Dictionary:
	for choix in definition.get("choix", []):
		if choix.get("choix_id") == choix_id:
			return choix
	return {}


func _transaction_id_resolution(instance, resolution_id: String) -> String:
	return "r8c-a3:%s:resolution:%s" % [instance.obtenir_snapshot()["instance_id"], resolution_id]


func _valider_lien_instance(instance, definition: Dictionary) -> String:
	var snapshot: Dictionary = instance.obtenir_snapshot()
	if snapshot.get("scene_id") != definition.get("scene_id"):
		return "DEFINITION_NON_INTERCHANGEABLE"
	if snapshot.get("version_contrat") != definition.get("version_contrat"):
		return "VERSION_DEFINITION_INCOHERENTE"
	return ""


func _diagnostic_invalide(code: String, erreur: String, contexte: Dictionary) -> Dictionary:
	return {
		"eligible": false,
		"statut": InstanceModele.INELIGIBLE,
		"raisons_conditions_satisfaites": [],
		"raisons_ineligibilite": [code],
		"conditions_evaluees": [{"condition": code, "satisfaite": false, "code_raison": erreur}],
		"revalidation_requise_avant": contexte.get("moment_diegetique"),
		"event_ids_observes": [],
	}


func _resultat_operation(ok: bool, erreur: String, transition: Dictionary, diagnostic: Dictionary) -> Dictionary:
	return {"ok": ok, "erreur": erreur, "transition": transition, "diagnostic": diagnostic}


func _resultat_transaction(
	ok: bool,
	erreur: String,
	transaction: Dictionary,
	evenement_candidat: Dictionary,
	diagnostic_signal: Dictionary,
	diagnostic_revalidation: Dictionary
) -> Dictionary:
	return {
		"ok": ok,
		"erreur": erreur,
		"transaction": transaction,
		"evenement_candidat": evenement_candidat.duplicate(true),
		"diagnostic_signal": diagnostic_signal,
		"diagnostic_revalidation": diagnostic_revalidation,
	}
