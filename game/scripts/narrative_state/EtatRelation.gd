extends RefCounted

class_name EtatRelation

const CHAMPS_MUTABLES := [
	"etat_arc",
	"statut_relation",
	"confiance",
	"desir",
	"intimite",
	"secret",
	"dernier_evenement_majeur_id",
	"faits",
]

const CHAMPS_QUALITATIFS := [
	"etat_arc",
	"statut_relation",
	"confiance",
	"desir",
	"intimite",
	"secret",
	"dernier_evenement_majeur_id",
]


static func creer_synthetique(personnage_id: String) -> Dictionary:
	var relation := {
		"personnage_id": personnage_id,
		"etat_arc": null,
		"statut_relation": null,
		"confiance": null,
		"desir": null,
		"intimite": null,
		"secret": null,
		"dernier_evenement_majeur_id": null,
		"faits": [],
	}
	if personnage_id == "nico":
		relation["desir"] = "NONE"
	return relation


static func valider(relation: Dictionary, personnage_id_attendu: String = "") -> String:
	var champs_requis := ["personnage_id"] + CHAMPS_MUTABLES
	for champ in champs_requis:
		if not relation.has(champ):
			return "relation: champ manquant: %s" % champ
	var personnage_id = relation["personnage_id"]
	if typeof(personnage_id) != TYPE_STRING or personnage_id.strip_edges().is_empty():
		return "relation: personnage_id doit etre une chaine non vide"
	if not personnage_id_attendu.is_empty() and personnage_id != personnage_id_attendu:
		return "relation: personnage_id incoherent"
	for champ in CHAMPS_QUALITATIFS:
		var valeur = relation[champ]
		if valeur != null and (typeof(valeur) != TYPE_STRING or valeur.strip_edges().is_empty()):
			return "relation: %s doit etre null ou une chaine non vide" % champ
	if typeof(relation["faits"]) != TYPE_ARRAY:
		return "relation: faits doit etre un tableau"
	if personnage_id == "nico" and relation["desir"] != "NONE":
		return "relation: le desir de nico doit rester NONE"
	return ""
