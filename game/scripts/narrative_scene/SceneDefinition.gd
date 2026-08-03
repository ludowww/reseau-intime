extends RefCounted

class_name R8CSceneDefinition

const NATURES := ["SIGNATURE", "MODULAIRE"]
const FONCTIONS := ["RELATION", "OPPORTUNITE", "ECHO", "RESPIRATION"]
const PORTEES_MICRO_SIGNAL := ["LOCALE", "DURABLE"]
const RECEPTIONS := ["NON_PERSISTANTE", "RECUE_INTERPRETEE", "LIMITE_EXPLICITE"]

const CHAMPS_REQUIS := [
	"scene_id",
	"version_contrat",
	"titre_interne",
	"nature",
	"fonction_principale",
	"participants_requis",
	"relation_ou_question_focale",
	"noyau_stable",
	"conditions_dures",
	"exclusions_dures",
	"lectures_etat",
	"contrat_temporel",
	"resolutions",
	"politique_non_resolution",
	"sortie",
	"observabilite",
]


static func declarer(donnees: Dictionary) -> Dictionary:
	var definition: Dictionary = donnees.duplicate(true)
	var erreur := valider(definition)
	return {
		"ok": erreur.is_empty(),
		"erreur": erreur,
		"definition": definition if erreur.is_empty() else {},
	}


static func valider(definition: Dictionary) -> String:
	for champ in CHAMPS_REQUIS:
		if not definition.has(champ):
			return "definition de scene: champ manquant: %s" % champ
	for champ in [
		"scene_id",
		"version_contrat",
		"titre_interne",
		"relation_ou_question_focale",
		"noyau_stable",
	]:
		if not _chaine_non_vide(definition[champ]):
			return "definition de scene: %s doit etre une chaine non vide" % champ
	if definition["nature"] not in NATURES:
		return "definition de scene: nature invalide"
	if definition["fonction_principale"] not in FONCTIONS:
		return "definition de scene: fonction principale hors prototype"
	var erreur_participants := _valider_participants(definition["participants_requis"])
	if not erreur_participants.is_empty():
		return erreur_participants
	var erreur_conditions := _valider_conditions(definition)
	if not erreur_conditions.is_empty():
		return erreur_conditions
	var erreur_temps := _valider_contrat_temporel(definition["contrat_temporel"])
	if not erreur_temps.is_empty():
		return erreur_temps
	for champ in ["lectures_etat", "politique_non_resolution", "sortie", "observabilite"]:
		if typeof(definition[champ]) != TYPE_DICTIONARY:
			return "definition de scene: %s doit etre un dictionnaire" % champ
	var erreur_resolutions := _valider_resolutions(definition)
	if not erreur_resolutions.is_empty():
		return erreur_resolutions
	return _valider_choix(definition)


static func _valider_participants(participants) -> String:
	if typeof(participants) != TYPE_ARRAY or participants.is_empty():
		return "definition de scene: participants_requis doit etre un tableau non vide"
	var identifiants := {}
	for participant in participants:
		if typeof(participant) != TYPE_DICTIONARY:
			return "definition de scene: participant invalide"
		var personnage_id = participant.get("personnage_id")
		if not _chaine_non_vide(personnage_id) or not _chaine_non_vide(participant.get("role")):
			return "definition de scene: participant incomplet"
		if identifiants.has(personnage_id):
			return "definition de scene: participant duplique"
		identifiants[personnage_id] = true
	return ""


static func _valider_conditions(definition: Dictionary) -> String:
	var conditions = definition["conditions_dures"]
	if typeof(conditions) != TYPE_DICTIONARY:
		return "definition de scene: conditions_dures doit etre un dictionnaire"
	for champ in ["actes_compatibles", "evenements_requis"]:
		if typeof(conditions.get(champ)) != TYPE_ARRAY or conditions[champ].is_empty():
			return "definition de scene: condition borne manquante: %s" % champ
	for valeur in conditions["actes_compatibles"] + conditions["evenements_requis"]:
		if not _chaine_non_vide(valeur):
			return "definition de scene: condition vide"
	var exclusions = definition["exclusions_dures"]
	if typeof(exclusions) != TYPE_DICTIONARY:
		return "definition de scene: exclusions_dures doit etre un dictionnaire"
	var interdits = exclusions.get("evenements_interdits")
	if typeof(interdits) != TYPE_ARRAY:
		return "definition de scene: evenements_interdits doit etre un tableau"
	for event_id in interdits:
		if not _chaine_non_vide(event_id):
			return "definition de scene: evenement interdit vide"
	return ""


static func _valider_contrat_temporel(contrat) -> String:
	if typeof(contrat) != TYPE_DICTIONARY:
		return "definition de scene: contrat_temporel doit etre un dictionnaire"
	for champ in ["date_debut", "date_fin", "heure_ouverture", "heure_fermeture", "referentiel_calendrier"]:
		if not _chaine_non_vide(contrat.get(champ)):
			return "definition de scene: contrat temporel incomplet: %s" % champ
	var duree = contrat.get("duree_minutes")
	if typeof(duree) not in [TYPE_INT, TYPE_FLOAT] or duree <= 0 or float(duree) != floor(float(duree)):
		return "definition de scene: duree_minutes doit etre positive"
	if contrat["date_debut"] > contrat["date_fin"] or contrat["heure_ouverture"] >= contrat["heure_fermeture"]:
		return "definition de scene: fenetre temporelle incoherente"
	return ""


static func _valider_resolutions(definition: Dictionary) -> String:
	var resolutions = definition["resolutions"]
	if typeof(resolutions) != TYPE_DICTIONARY or resolutions.is_empty():
		return "definition de scene: resolutions doit etre un dictionnaire non vide"
	var participants := _identifiants_participants(definition["participants_requis"])
	for resolution_id in resolutions:
		if not _chaine_non_vide(resolution_id):
			return "definition de scene: resolution sans identifiant"
		var resolution = resolutions[resolution_id]
		if typeof(resolution) != TYPE_DICTIONARY:
			return "definition de scene: resolution invalide"
		if resolution.get("personnage_id") not in participants:
			return "definition de scene: consequence hors participants"
		if resolution.get("portee_micro_signal") not in PORTEES_MICRO_SIGNAL:
			return "definition de scene: portee de micro-signal invalide"
		if resolution.get("reception") not in RECEPTIONS:
			return "definition de scene: reception de micro-signal invalide"
		if not _chaine_non_vide(resolution.get("interpretation")):
			return "definition de scene: interpretation manquante"
		if resolution.get("convergence") != "RETOUR_NOYAU_COMMUN":
			return "definition de scene: micro-branche non convergente"
		var faits = resolution.get("faits_relationnels")
		if typeof(faits) != TYPE_ARRAY or faits.is_empty():
			return "definition de scene: resolution sans consequence qualitative"
		for fait in faits:
			if typeof(fait) != TYPE_DICTIONARY or not _chaine_non_vide(fait.get("fait_id")):
				return "definition de scene: fait relationnel invalide"
		if resolution["portee_micro_signal"] == "LOCALE" and resolution["reception"] != "NON_PERSISTANTE":
			return "definition de scene: signal local ne peut pas etre recu durablement"
	return ""


static func _valider_choix(definition: Dictionary) -> String:
	var choix = definition.get("choix", [])
	if typeof(choix) != TYPE_ARRAY or choix.is_empty() or choix.size() > 3:
		return "definition de scene: un a trois choix ecrits sont requis"
	var choix_ids := {}
	for option in choix:
		if typeof(option) != TYPE_DICTIONARY:
			return "definition de scene: choix invalide"
		var choix_id = option.get("choix_id")
		if not _chaine_non_vide(choix_id) or not _chaine_non_vide(option.get("formulation")):
			return "definition de scene: choix incomplet"
		if choix_ids.has(choix_id):
			return "definition de scene: choix duplique"
		choix_ids[choix_id] = true
		var resolution_ids = option.get("resolution_ids")
		if typeof(resolution_ids) != TYPE_ARRAY or resolution_ids.is_empty():
			return "definition de scene: choix sans resolution"
		for resolution_id in resolution_ids:
			if not definition["resolutions"].has(resolution_id):
				return "definition de scene: choix vers resolution inconnue"
	return ""


static func _identifiants_participants(participants: Array) -> Array:
	var identifiants := []
	for participant in participants:
		identifiants.append(participant["personnage_id"])
	return identifiants


static func _chaine_non_vide(valeur) -> bool:
	return typeof(valeur) == TYPE_STRING and not valeur.strip_edges().is_empty()
