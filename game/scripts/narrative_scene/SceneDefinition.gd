extends RefCounted

class_name R8CSceneDefinition

const NATURES := ["SIGNATURE", "MODULAIRE"]
const FONCTIONS := ["RELATION", "OPPORTUNITE", "ECHO", "RESPIRATION"]
const POLITIQUES_UNICITE := ["UNIQUE", "REPETABLE"]
const PORTEES_MICRO_SIGNAL := ["LOCALE", "TEMPORAIRE", "DURABLE"]
const RECEPTIONS := ["NON_PERSISTANTE", "RECUE_INTERPRETEE", "LIMITE_EXPLICITE"]
const POLITIQUES_REVALIDATION := ["AVANT_PROPOSITION", "AVANT_PROPOSITION_ET_RESOLUTION"]

const CHAMPS_REQUIS := [
	"scene_id",
	"version_contrat",
	"nature",
	"fonction_principale",
	"participants_requis",
	"conditions_dures",
	"exclusions_dures",
	"contrat_temporel",
	"politique_unicite",
	"resolutions",
]
const CHAMPS_OPTIONNELS := [
	"titre_interne",
	"relation_ou_question_focale",
	"noyau_stable",
	"structure_id",
	"choix",
	"politique_non_resolution",
]
const CHAMPS_AUTORISES := CHAMPS_REQUIS + CHAMPS_OPTIONNELS
const CHAMPS_PARTICIPANT := ["personnage_id", "role"]
const CHAMPS_CONDITIONS := ["actes_compatibles", "evenements_requis"]
const CHAMPS_EXCLUSIONS := ["evenements_interdits"]
const CHAMPS_CONTRAT_TEMPOREL := [
	"date_debut",
	"date_fin",
	"heure_ouverture",
	"heure_fermeture",
	"duree_minutes",
	"revalidation",
]
const CHAMPS_CHOIX := ["choix_id", "formulation", "signal_emis", "resolution_ids"]
const CHAMPS_RESOLUTION := [
	"personnage_id",
	"portee_micro_signal",
	"signal_recu",
	"reception",
	"interpretation",
	"faits_relationnels",
	"convergence",
	"trace_temporaire",
]
const CHAMPS_TRACE_TEMPORAIRE := ["trace_id", "contenu"]
const CHAMPS_FAIT_RELATIONNEL := [
	"fait_id",
	"nature",
	"recu_par",
	"permission_future",
	"formulee_par",
]
const CHAMPS_POLITIQUE_NON_RESOLUTION := ["proposition_expire", "consequence_manquee"]
const CHAMPS_CONSEQUENCE_MANQUEE := ["personnage_id", "fait_relationnel"]


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
	for champ in ["scene_id", "version_contrat"]:
		if not _chaine_non_vide(definition[champ]):
			return "definition de scene: %s doit etre une chaine non vide" % champ
	for champ in ["titre_interne", "relation_ou_question_focale", "noyau_stable", "structure_id"]:
		if definition.has(champ) and not _chaine_non_vide(definition[champ]):
			return "definition de scene: %s optionnel doit etre une chaine non vide" % champ
	if definition["nature"] not in NATURES:
		return "definition de scene: nature invalide"
	if definition["fonction_principale"] not in FONCTIONS:
		return "definition de scene: fonction principale hors prototype"
	if definition["politique_unicite"] not in POLITIQUES_UNICITE:
		return "definition de scene: politique d'unicite invalide"
	var erreur_participants := _valider_participants(definition["participants_requis"])
	if not erreur_participants.is_empty():
		return erreur_participants
	var erreur_conditions := _valider_conditions(definition)
	if not erreur_conditions.is_empty():
		return erreur_conditions
	var erreur_temps := _valider_contrat_temporel(definition["contrat_temporel"])
	if not erreur_temps.is_empty():
		return erreur_temps
	var erreur_resolutions := _valider_resolutions(definition)
	if not erreur_resolutions.is_empty():
		return erreur_resolutions
	var erreur_choix := _valider_choix(definition)
	if not erreur_choix.is_empty():
		return erreur_choix
	return _valider_politique_non_resolution(definition)


static func valider_fermee(definition: Dictionary) -> String:
	var erreur_champs := _valider_champs_fermes(definition)
	if not erreur_champs.is_empty():
		return erreur_champs
	return valider(definition)


static func _valider_champs_fermes(definition: Dictionary) -> String:
	var erreur := _refuser_champs_inconnus(definition, CHAMPS_AUTORISES, "definition")
	if not erreur.is_empty():
		return erreur
	var participants = definition.get("participants_requis")
	if typeof(participants) == TYPE_ARRAY:
		for participant in participants:
			if typeof(participant) == TYPE_DICTIONARY:
				erreur = _refuser_champs_inconnus(participant, CHAMPS_PARTICIPANT, "participant")
				if not erreur.is_empty():
					return erreur
	for bloc in [
		[definition.get("conditions_dures"), CHAMPS_CONDITIONS, "conditions_dures"],
		[definition.get("exclusions_dures"), CHAMPS_EXCLUSIONS, "exclusions_dures"],
		[definition.get("contrat_temporel"), CHAMPS_CONTRAT_TEMPOREL, "contrat_temporel"],
	]:
		if typeof(bloc[0]) == TYPE_DICTIONARY:
			erreur = _refuser_champs_inconnus(bloc[0], bloc[1], bloc[2])
			if not erreur.is_empty():
				return erreur
	var choix = definition.get("choix", [])
	if typeof(choix) == TYPE_ARRAY:
		for option in choix:
			if typeof(option) == TYPE_DICTIONARY:
				erreur = _refuser_champs_inconnus(option, CHAMPS_CHOIX, "choix")
				if not erreur.is_empty():
					return erreur
	var resolutions = definition.get("resolutions")
	if typeof(resolutions) == TYPE_DICTIONARY:
		for resolution in resolutions.values():
			if typeof(resolution) != TYPE_DICTIONARY:
				continue
			erreur = _refuser_champs_inconnus(resolution, CHAMPS_RESOLUTION, "resolution")
			if not erreur.is_empty():
				return erreur
			var trace = resolution.get("trace_temporaire")
			if typeof(trace) == TYPE_DICTIONARY:
				erreur = _refuser_champs_inconnus(trace, CHAMPS_TRACE_TEMPORAIRE, "trace_temporaire")
				if not erreur.is_empty():
					return erreur
			var faits = resolution.get("faits_relationnels", [])
			if typeof(faits) == TYPE_ARRAY:
				for fait in faits:
					if typeof(fait) == TYPE_DICTIONARY:
						erreur = _refuser_champs_inconnus(fait, CHAMPS_FAIT_RELATIONNEL, "fait_relationnel")
						if not erreur.is_empty():
							return erreur
	var politique = definition.get("politique_non_resolution")
	if typeof(politique) == TYPE_DICTIONARY:
		erreur = _refuser_champs_inconnus(
			politique, CHAMPS_POLITIQUE_NON_RESOLUTION, "politique_non_resolution"
		)
		if not erreur.is_empty():
			return erreur
		var consequence = politique.get("consequence_manquee")
		if typeof(consequence) == TYPE_DICTIONARY:
			erreur = _refuser_champs_inconnus(
				consequence, CHAMPS_CONSEQUENCE_MANQUEE, "consequence_manquee"
			)
			if not erreur.is_empty():
				return erreur
			var fait_manque = consequence.get("fait_relationnel")
			if typeof(fait_manque) == TYPE_DICTIONARY:
				erreur = _refuser_champs_inconnus(
					fait_manque, CHAMPS_FAIT_RELATIONNEL, "fait_relationnel"
				)
				if not erreur.is_empty():
					return erreur
	return ""


static func _refuser_champs_inconnus(value: Dictionary, autorises: Array, contexte: String) -> String:
	for champ in value:
		if champ not in autorises:
			return "definition de scene: %s contient un champ inconnu: %s" % [contexte, champ]
	return ""


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
		if typeof(conditions.get(champ)) != TYPE_ARRAY:
			return "definition de scene: condition borne manquante: %s" % champ
	if conditions["actes_compatibles"].is_empty():
		return "definition de scene: au moins un acte compatible est requis"
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
	for champ in ["date_debut", "date_fin", "heure_ouverture", "heure_fermeture"]:
		if not _chaine_non_vide(contrat.get(champ)):
			return "definition de scene: contrat temporel incomplet: %s" % champ
	if not _date_valide(contrat["date_debut"]) or not _date_valide(contrat["date_fin"]):
		return "definition de scene: date temporelle invalide"
	var ouverture := heure_en_minutes(contrat["heure_ouverture"])
	var fermeture := heure_en_minutes(contrat["heure_fermeture"])
	if ouverture < 0 or fermeture < 0:
		return "definition de scene: heure temporelle invalide"
	if contrat["date_debut"] > contrat["date_fin"] or ouverture >= fermeture:
		return "definition de scene: fenetre temporelle incoherente"
	var duree = contrat.get("duree_minutes")
	if typeof(duree) not in [TYPE_INT, TYPE_FLOAT] or duree <= 0 or float(duree) != floor(float(duree)):
		return "definition de scene: duree_minutes doit etre un entier positif"
	if contrat.get("revalidation") not in POLITIQUES_REVALIDATION:
		return "definition de scene: politique de revalidation invalide"
	return ""


static func _valider_resolutions(definition: Dictionary) -> String:
	var resolutions = definition["resolutions"]
	if typeof(resolutions) != TYPE_DICTIONARY:
		return "definition de scene: resolutions doit etre un dictionnaire"
	var participants := _identifiants_participants(definition["participants_requis"])
	for resolution_id in resolutions:
		if not _chaine_non_vide(resolution_id):
			return "definition de scene: resolution sans identifiant"
		var resolution = resolutions[resolution_id]
		if typeof(resolution) != TYPE_DICTIONARY:
			return "definition de scene: resolution invalide"
		if resolution.get("personnage_id") not in participants:
			return "definition de scene: consequence hors participants"
		var portee = resolution.get("portee_micro_signal")
		if portee not in PORTEES_MICRO_SIGNAL:
			return "definition de scene: portee de micro-signal invalide"
		var reception = resolution.get("reception")
		if reception not in RECEPTIONS:
			return "definition de scene: reception de micro-signal invalide"
		if not _chaine_non_vide(resolution.get("signal_recu")):
			return "definition de scene: signal recu manquant"
		if not _chaine_non_vide(resolution.get("interpretation")):
			return "definition de scene: interpretation manquante"
		if resolution.get("convergence") != "RETOUR_NOYAU_COMMUN":
			return "definition de scene: micro-branche non convergente"
		var faits = resolution.get("faits_relationnels", [])
		if typeof(faits) != TYPE_ARRAY:
			return "definition de scene: faits_relationnels doit etre un tableau"
		for fait in faits:
			if typeof(fait) != TYPE_DICTIONARY or not _chaine_non_vide(fait.get("fait_id")):
				return "definition de scene: fait relationnel invalide"
		if portee == "LOCALE" and reception != "NON_PERSISTANTE":
			return "definition de scene: signal local doit rester non persistant"
		if portee == "LOCALE" and not faits.is_empty():
			return "definition de scene: signal local ne peut pas ecrire de fait durable"
		if portee == "TEMPORAIRE":
			var trace = resolution.get("trace_temporaire")
			if typeof(trace) != TYPE_DICTIONARY or not _chaine_non_vide(trace.get("trace_id")):
				return "definition de scene: trace temporaire explicite requise"
			if not faits.is_empty():
				return "definition de scene: signal temporaire ne peut pas ecrire de fait durable"
		if portee == "DURABLE":
			if reception == "NON_PERSISTANTE" or faits.is_empty():
				return "definition de scene: durable exige reception, interpretation et fait explicites"
	return ""


static func _valider_choix(definition: Dictionary) -> String:
	var choix = definition.get("choix", [])
	if typeof(choix) != TYPE_ARRAY or choix.size() > 3:
		return "definition de scene: zero a trois choix ecrits sont autorises"
	if choix.is_empty() and not definition["resolutions"].is_empty():
		return "definition de scene: resolutions orphelines sans choix"
	var choix_ids := {}
	var resolutions_referencees := {}
	for option in choix:
		if typeof(option) != TYPE_DICTIONARY:
			return "definition de scene: choix invalide"
		var choix_id = option.get("choix_id")
		if not _chaine_non_vide(choix_id) or not _chaine_non_vide(option.get("formulation")):
			return "definition de scene: choix incomplet"
		if not _chaine_non_vide(option.get("signal_emis")):
			return "definition de scene: choix sans signal emis"
		if choix_ids.has(choix_id):
			return "definition de scene: choix duplique"
		choix_ids[choix_id] = true
		var resolution_ids = option.get("resolution_ids")
		if typeof(resolution_ids) != TYPE_ARRAY or resolution_ids.is_empty():
			return "definition de scene: choix sans resolution"
		for resolution_id in resolution_ids:
			if not definition["resolutions"].has(resolution_id):
				return "definition de scene: choix vers resolution inconnue"
			if definition["resolutions"][resolution_id].get("signal_recu") != option["signal_emis"]:
				return "definition de scene: signal emis et signal recu incoherents"
			resolutions_referencees[resolution_id] = true
	if resolutions_referencees.size() != definition["resolutions"].size():
		return "definition de scene: resolution orpheline non consommee"
	return ""


static func _valider_politique_non_resolution(definition: Dictionary) -> String:
	if not definition.has("politique_non_resolution"):
		return ""
	var politique = definition["politique_non_resolution"]
	if typeof(politique) != TYPE_DICTIONARY:
		return "definition de scene: politique_non_resolution doit etre un dictionnaire"
	for champ in politique:
		if champ not in ["proposition_expire", "consequence_manquee"]:
			return "definition de scene: politique_non_resolution contient un champ non consomme"
	if politique.get("proposition_expire") not in ["MISSED", "CANCELLED"]:
		return "definition de scene: statut d'expiration invalide"
	var consequence = politique.get("consequence_manquee")
	if consequence != null:
		if typeof(consequence) != TYPE_DICTIONARY:
			return "definition de scene: consequence manquee invalide"
		if consequence.get("personnage_id") not in _identifiants_participants(definition["participants_requis"]):
			return "definition de scene: consequence manquee hors participants"
		var fait = consequence.get("fait_relationnel")
		if typeof(fait) != TYPE_DICTIONARY or not _chaine_non_vide(fait.get("fait_id")):
			return "definition de scene: fait manque invalide"
	return ""


static func heure_en_minutes(heure) -> int:
	if typeof(heure) != TYPE_STRING:
		return -1
	var morceaux: PackedStringArray = heure.split(":")
	if morceaux.size() != 2 or morceaux[0].length() != 2 or morceaux[1].length() != 2:
		return -1
	if not morceaux[0].is_valid_int() or not morceaux[1].is_valid_int():
		return -1
	var heures := int(morceaux[0])
	var minutes := int(morceaux[1])
	if heures < 0 or heures > 23 or minutes < 0 or minutes > 59:
		return -1
	return heures * 60 + minutes


static func moment_valide(moment) -> bool:
	return (
		typeof(moment) == TYPE_STRING
		and moment.length() >= 16
		and moment.substr(10, 1) == "T"
		and _date_valide(moment.substr(0, 10))
		and heure_en_minutes(moment.substr(11, 5)) >= 0
	)


static func moment_normalise_valide(moment) -> bool:
	if typeof(moment) != TYPE_STRING or moment.length() != 25 or not moment_valide(moment):
		return false
	if moment.substr(16, 1) != ":" or moment.substr(19, 1) not in ["+", "-"] or moment.substr(22, 1) != ":":
		return false
	var secondes: String = moment.substr(17, 2)
	var heures_offset: String = moment.substr(20, 2)
	var minutes_offset: String = moment.substr(23, 2)
	if not secondes.is_valid_int() or not heures_offset.is_valid_int() or not minutes_offset.is_valid_int():
		return false
	var secondes_nombre := int(secondes)
	var heures_offset_nombre := int(heures_offset)
	var minutes_offset_nombre := int(minutes_offset)
	return (
		secondes_nombre >= 0 and secondes_nombre <= 59
		and heures_offset_nombre >= 0 and heures_offset_nombre <= 14
		and minutes_offset_nombre >= 0 and minutes_offset_nombre <= 59
		and (heures_offset_nombre < 14 or minutes_offset_nombre == 0)
	)


static func meme_offset(premier: String, second: String) -> bool:
	return moment_normalise_valide(premier) and moment_normalise_valide(second) and premier.substr(19, 6) == second.substr(19, 6)


static func _date_valide(date) -> bool:
	if typeof(date) != TYPE_STRING or date.length() != 10:
		return false
	var morceaux: PackedStringArray = date.split("-")
	if morceaux.size() != 3 or morceaux[0].length() != 4 or morceaux[1].length() != 2 or morceaux[2].length() != 2:
		return false
	for morceau in morceaux:
		if not morceau.is_valid_int():
			return false
	var annee := int(morceaux[0])
	var mois := int(morceaux[1])
	var jour := int(morceaux[2])
	if annee < 1 or mois < 1 or mois > 12:
		return false
	var jours := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if mois == 2 and (annee % 400 == 0 or (annee % 4 == 0 and annee % 100 != 0)):
		jours[1] = 29
	return jour >= 1 and jour <= jours[mois - 1]


static func _identifiants_participants(participants: Array) -> Array:
	var identifiants := []
	for participant in participants:
		identifiants.append(participant["personnage_id"])
	return identifiants


static func _chaine_non_vide(valeur) -> bool:
	return typeof(valeur) == TYPE_STRING and not valeur.strip_edges().is_empty()
