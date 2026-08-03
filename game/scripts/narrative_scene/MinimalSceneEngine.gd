extends RefCounted

class_name R8CMinimalSceneEngine

const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")
const InstanceModele := preload("res://scripts/narrative_scene/SceneInstance.gd")
const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")


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
	_evaluer_unicite(definition, snapshot, satisfaites, echecs, details)
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
		"preferences_applicables": [],
		"conflits": [],
		"revalidation_requise_a": contexte.get("moment_diegetique"),
		"event_ids_observes": event_ids,
	}


func creer_instance(definition: Dictionary, diagnostic: Dictionary, contexte: Dictionary):
	return InstanceModele.creer(definition, diagnostic, contexte)


func proposer(instance, definition: Dictionary, etat_narratif, contexte: Dictionary) -> Dictionary:
	if instance == null or instance.obtenir_statut() != InstanceModele.ELIGIBLE:
		return _resultat_operation(false, "INSTANCE_NON_ELIGIBLE", {}, {})
	var erreur_lien := _valider_lien_instance(instance, definition)
	if not erreur_lien.is_empty():
		return _resultat_operation(false, erreur_lien, {}, {})
	var diagnostic := evaluer_definition(definition, etat_narratif, contexte)
	if not diagnostic["eligible"]:
		var annulation: Dictionary = instance.transitionner(
			InstanceModele.CANCELLED,
			"REVALIDATION_INELIGIBLE",
			contexte.get("moment_diegetique", "INSTANT_INCONNU"),
		)
		return _resultat_operation(false, "REVALIDATION_INELIGIBLE", annulation, diagnostic)
	var transition: Dictionary = instance.transitionner(
		InstanceModele.PROPOSED,
		"OPPORTUNITE_RENDUE_PERCEPTIBLE",
		contexte["moment_diegetique"],
	)
	return _resultat_operation(transition["ok"], transition["erreur"], transition, diagnostic)


func resoudre(
	instance,
	definition: Dictionary,
	resolution_id: String,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	if instance == null or instance.obtenir_statut() != InstanceModele.PROPOSED:
		return _resultat_transaction(false, "INSTANCE_NON_PROPOSEE", {}, {}, {})
	var erreur_lien := _valider_lien_instance(instance, definition)
	if not erreur_lien.is_empty():
		return _resultat_transaction(false, erreur_lien, {}, {}, {})
	var erreur_definition := DefinitionModele.valider(definition)
	if not erreur_definition.is_empty():
		return _resultat_transaction(false, erreur_definition, {}, {}, {})
	if not definition["resolutions"].has(resolution_id):
		return _resultat_transaction(false, "RESOLUTION_INCONNUE", {}, {}, {})
	var resolution: Dictionary = definition["resolutions"][resolution_id]
	var evenement := _construire_evenement_resolution(instance, definition, resolution_id, resolution, etat_narratif, contexte)
	if evenement.is_empty():
		return _resultat_transaction(false, "CONSEQUENCE_NON_APPLICABLE", {}, {}, {})
	var transaction: Dictionary = etat_narratif.traiter_evenement(evenement)
	if transaction["statut"] not in ["APPLIQUE", "IDEMPOTENT"]:
		return _resultat_transaction(false, "TRANSACTION_REJETEE", transaction, evenement, {
			"portee_micro_signal": resolution["portee_micro_signal"],
			"reception": resolution["reception"],
			"interpretation": resolution["interpretation"],
		})
	var transition: Dictionary = instance.transitionner(
		InstanceModele.RESOLVED,
		"RESOLUTION_TRANSACTIONNELLE_VALIDEE",
		contexte["moment_diegetique"],
	)
	return _resultat_transaction(transition["ok"], transition["erreur"], transaction, evenement, {
		"portee_micro_signal": resolution["portee_micro_signal"],
		"reception": resolution["reception"],
		"interpretation": resolution["interpretation"],
		"convergence": resolution["convergence"],
	})


func manquer(instance, definition: Dictionary, etat_narratif, contexte: Dictionary) -> Dictionary:
	if instance == null or instance.obtenir_statut() != InstanceModele.PROPOSED:
		return _resultat_transaction(false, "INSTANCE_NON_PROPOSEE", {}, {}, {})
	var erreur_lien := _valider_lien_instance(instance, definition)
	if not erreur_lien.is_empty():
		return _resultat_transaction(false, erreur_lien, {}, {}, {})
	var politique: Dictionary = definition["politique_non_resolution"]
	if politique.get("proposition_expire") != InstanceModele.MISSED:
		return _resultat_transaction(false, "POLITIQUE_SANS_ABSENCE_NARRATIVE", {}, {}, {})
	if not _fenetre_depassee(definition["contrat_temporel"], contexte.get("moment_diegetique", "")):
		return _resultat_transaction(false, "ECHEANCE_NON_FRANCHIE", {}, {}, {})
	var consequence = politique.get("consequence_manquee")
	if typeof(consequence) != TYPE_DICTIONARY:
		return _resultat_transaction(false, "CONSEQUENCE_MANQUEE_ABSENTE", {}, {}, {})
	var evenement := _construire_evenement_manque(instance, definition, consequence, etat_narratif, contexte)
	if evenement.is_empty():
		return _resultat_transaction(false, "CONSEQUENCE_NON_APPLICABLE", {}, {}, {})
	var transaction: Dictionary = etat_narratif.traiter_evenement(evenement)
	if transaction["statut"] not in ["APPLIQUE", "IDEMPOTENT"]:
		return _resultat_transaction(false, "TRANSACTION_REJETEE", transaction, evenement, {})
	var transition: Dictionary = instance.transitionner(
		InstanceModele.MISSED,
		"PROPOSITION_VISIBLE_EXPIREE",
		contexte["moment_diegetique"],
	)
	return _resultat_transaction(transition["ok"], transition["erreur"], transaction, evenement, {})


func annuler(instance, code_raison: String, moment_diegetique: String) -> Dictionary:
	if instance == null:
		return {"ok": false, "erreur": "INSTANCE_ABSENTE", "statut": InstanceModele.INELIGIBLE}
	return instance.transitionner(InstanceModele.CANCELLED, code_raison, moment_diegetique)


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
	satisfaites: Array,
	echecs: Array,
	details: Array
) -> void:
	var non_resolue := true
	for evenement in snapshot["evenements"].values():
		var provenance = evenement.get("provenance", {})
		if (
			typeof(provenance) == TYPE_DICTIONARY
			and provenance.get("source_scene_id") == definition["scene_id"]
			and provenance.get("scene_status") == InstanceModele.RESOLVED
		):
			non_resolue = false
			break
	_ajouter_condition(
		"SCENE_NON_RESOLUE",
		non_resolue,
		"CONDITION_SCENE_NON_RESOLUE" if non_resolue else "SCENE_DEJA_RESOLUE",
		satisfaites,
		echecs,
		details,
	)


func _evaluer_fenetre(
	definition: Dictionary,
	contexte: Dictionary,
	satisfaites: Array,
	echecs: Array,
	details: Array
) -> void:
	var moment = contexte.get("moment_diegetique")
	var ouverte := _fenetre_ouverte(definition["contrat_temporel"], moment)
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
	if typeof(moment) != TYPE_STRING or moment.length() < 16:
		return false
	var date: String = moment.substr(0, 10)
	var heure: String = moment.substr(11, 5)
	return (
		date >= contrat["date_debut"]
		and date <= contrat["date_fin"]
		and heure >= contrat["heure_ouverture"]
		and heure < contrat["heure_fermeture"]
	)


func _fenetre_depassee(contrat: Dictionary, moment) -> bool:
	if typeof(moment) != TYPE_STRING or moment.length() < 16:
		return false
	var borne := "%sT%s" % [contrat["date_fin"], contrat["heure_fermeture"]]
	return moment.substr(0, 16) >= borne


func _construire_evenement_resolution(
	instance,
	definition: Dictionary,
	resolution_id: String,
	resolution: Dictionary,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	var personnage_id: String = resolution["personnage_id"]
	var snapshot: Dictionary = etat_narratif.obtenir_snapshot()
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
		"event_id": "r8c-a3:%s:%s" % [instance_snapshot["instance_id"], resolution_id],
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {
			"type": "R8C_A3_SCENE_SYNTHETIQUE",
			"id": instance_snapshot["instance_id"],
			"source_scene_id": definition["scene_id"],
			"source_scene_instance_id": instance_snapshot["instance_id"],
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
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	var personnage_id = consequence.get("personnage_id")
	var snapshot: Dictionary = etat_narratif.obtenir_snapshot()
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
		"event_id": "r8c-a3:%s:missed" % instance_snapshot["instance_id"],
		"event_type": EtatNarratifModele.TYPE_RELATION,
		"provenance": {
			"type": "R8C_A3_SCENE_SYNTHETIQUE",
			"id": instance_snapshot["instance_id"],
			"source_scene_id": definition["scene_id"],
			"source_scene_instance_id": instance_snapshot["instance_id"],
			"source_resolution_id": "opportunite_manquee",
			"scene_status": InstanceModele.MISSED,
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
		"preferences_applicables": [],
		"conflits": [],
		"revalidation_requise_a": contexte.get("moment_diegetique"),
		"event_ids_observes": [],
	}


func _resultat_operation(
	ok: bool,
	erreur: String,
	transition: Dictionary,
	diagnostic: Dictionary
) -> Dictionary:
	return {"ok": ok, "erreur": erreur, "transition": transition, "diagnostic": diagnostic}


func _resultat_transaction(
	ok: bool,
	erreur: String,
	transaction: Dictionary,
	evenement_candidat: Dictionary,
	diagnostic_signal: Dictionary
) -> Dictionary:
	return {
		"ok": ok,
		"erreur": erreur,
		"transaction": transaction,
		"evenement_candidat": evenement_candidat.duplicate(true),
		"diagnostic_signal": diagnostic_signal,
	}
