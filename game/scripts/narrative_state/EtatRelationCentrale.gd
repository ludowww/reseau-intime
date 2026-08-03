extends RefCounted

class_name EtatRelationCentrale

const STATUTS_COUPLE := ["ENSEMBLE", "SEPARES", "EN_CLARIFICATION"]
const CONTRATS_COUPLE := ["EXCLUSIF", "OUVERT", "LIBERTIN", "PROVISOIRE"]
const ETATS_DIVULGATION := ["HONNETE", "PARTIEL", "ASYMETRIQUE", "MENSONGER_COMPROMIS", "REVELE"]
const RELATIONS_APRES_SEPARATION := ["BONS_TERMES", "BLESSEE", "HOSTILE", "SANS_CONTACT"]

const CHAMPS_MUTABLES := [
	"statut_couple",
	"contrat_couple",
	"etat_divulgation",
	"etat_foyer",
	"relation_apres_separation",
	"dernier_evenement_majeur_id",
	"faits",
	"cadre_provisoire",
]


static func creer_synthetique(initiale: Dictionary) -> Dictionary:
	var relation := {
		"statut_couple": null,
		"contrat_couple": null,
		"etat_divulgation": null,
		"etat_foyer": null,
		"relation_apres_separation": null,
		"dernier_evenement_majeur_id": null,
		"faits": [],
		"cadre_provisoire": null,
	}
	for champ in CHAMPS_MUTABLES:
		if initiale.has(champ):
			relation[champ] = _copier(initiale[champ])
	return relation


static func valider(relation: Dictionary) -> String:
	for champ in CHAMPS_MUTABLES:
		if not relation.has(champ):
			return "relation_centrale: champ manquant: %s" % champ
	var statut = relation["statut_couple"]
	if typeof(statut) != TYPE_STRING or statut not in STATUTS_COUPLE:
		return "relation_centrale: statut_couple invalide"
	var contrat = relation["contrat_couple"]
	if contrat != null and (typeof(contrat) != TYPE_STRING or contrat not in CONTRATS_COUPLE):
		return "relation_centrale: contrat_couple invalide"
	var divulgation = relation["etat_divulgation"]
	if divulgation != null and (typeof(divulgation) != TYPE_STRING or divulgation not in ETATS_DIVULGATION):
		return "relation_centrale: etat_divulgation invalide"
	var apres_separation = relation["relation_apres_separation"]
	if apres_separation != null and (
		typeof(apres_separation) != TYPE_STRING
		or apres_separation not in RELATIONS_APRES_SEPARATION
	):
		return "relation_centrale: relation_apres_separation invalide"
	var dernier_evenement = relation["dernier_evenement_majeur_id"]
	if dernier_evenement != null and (
		typeof(dernier_evenement) != TYPE_STRING
		or dernier_evenement.strip_edges().is_empty()
	):
		return "relation_centrale: dernier_evenement_majeur_id invalide"
	if typeof(relation["faits"]) != TYPE_ARRAY:
		return "relation_centrale: faits doit etre un tableau"
	if statut == "ENSEMBLE":
		if contrat == null:
			return "relation_centrale: ENSEMBLE exige un contrat"
		if apres_separation != null:
			return "relation_centrale: ENSEMBLE interdit une relation apres separation"
	elif statut == "SEPARES":
		if contrat != null:
			return "relation_centrale: SEPARES interdit un contrat actif"
		if apres_separation == null:
			return "relation_centrale: SEPARES exige une relation apres separation"
	if contrat == "PROVISOIRE":
		return _valider_cadre_provisoire(relation["cadre_provisoire"])
	var cadre = relation["cadre_provisoire"]
	if cadre != null and typeof(cadre) != TYPE_DICTIONARY:
		return "relation_centrale: cadre_provisoire doit etre null ou un dictionnaire"
	return ""


static func _valider_cadre_provisoire(cadre) -> String:
	if typeof(cadre) != TYPE_DICTIONARY:
		return "relation_centrale: PROVISOIRE exige un cadre_provisoire"
	if not _chaine_non_vide(cadre.get("regle")):
		return "relation_centrale: cadre provisoire sans regle"
	var limites = cadre.get("limites")
	if typeof(limites) != TYPE_ARRAY or limites.is_empty():
		return "relation_centrale: cadre provisoire sans limites"
	for limite in limites:
		if not _chaine_non_vide(limite):
			return "relation_centrale: limite provisoire invalide"
	var reevaluation = cadre.get("reevaluation")
	if typeof(reevaluation) != TYPE_DICTIONARY:
		return "relation_centrale: reevaluation provisoire invalide"
	if not _chaine_non_vide(reevaluation.get("echeance")) and not _chaine_non_vide(reevaluation.get("condition")):
		return "relation_centrale: reevaluation sans echeance ni condition"
	var obligation_ids = cadre.get("obligation_ids")
	if typeof(obligation_ids) != TYPE_ARRAY or obligation_ids.is_empty():
		return "relation_centrale: cadre provisoire sans obligation"
	for obligation_id in obligation_ids:
		if not _chaine_non_vide(obligation_id):
			return "relation_centrale: obligation provisoire invalide"
	return ""


static func _chaine_non_vide(valeur) -> bool:
	return typeof(valeur) == TYPE_STRING and not valeur.strip_edges().is_empty()


static func _copier(valeur):
	if typeof(valeur) in [TYPE_ARRAY, TYPE_DICTIONARY]:
		return valeur.duplicate(true)
	return valeur
