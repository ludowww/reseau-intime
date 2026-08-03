extends RefCounted

class_name ReducerRelation

const EtatRelationModele := preload("res://scripts/narrative_state/EtatRelation.gd")
const EtatRelationCentraleModele := preload("res://scripts/narrative_state/EtatRelationCentrale.gd")

const TYPE_RELATION_CENTRALE := "R8C_A1_RELATION_CENTRALE_SYNTHETIQUE"
const TYPE_RELATION := "R8C_A1_RELATION_SYNTHETIQUE"


static func preparer_mutations(etat_candidat: Dictionary, evenement: Dictionary) -> Dictionary:
	match evenement["event_type"]:
		TYPE_RELATION_CENTRALE:
			return _appliquer_relation_centrale(etat_candidat, evenement["payload"])
		TYPE_RELATION:
			return _appliquer_relation(etat_candidat, evenement["payload"])
		_:
			return _rejet("type d'evenement non supporte par le reducer")


static func _appliquer_relation_centrale(etat_candidat: Dictionary, payload: Dictionary) -> Dictionary:
	var resultat := _extraire_changements(payload, EtatRelationCentraleModele.CHAMPS_MUTABLES)
	if not resultat["ok"]:
		return resultat
	var relation_centrale: Dictionary = etat_candidat["relation_centrale"]
	for champ in resultat["changements"]:
		relation_centrale[champ] = _copier(resultat["changements"][champ])
	etat_candidat["relation_centrale"] = relation_centrale
	return _succes()


static func _appliquer_relation(etat_candidat: Dictionary, payload: Dictionary) -> Dictionary:
	var personnage_id = payload.get("personnage_id")
	if typeof(personnage_id) != TYPE_STRING or personnage_id.strip_edges().is_empty():
		return _rejet("payload relationnel sans personnage_id valide")
	var relations: Dictionary = etat_candidat["relations"]
	if not relations.has(personnage_id):
		return _rejet("relation inconnue: %s" % personnage_id)
	var resultat := _extraire_changements(payload, EtatRelationModele.CHAMPS_MUTABLES)
	if not resultat["ok"]:
		return resultat
	var relation: Dictionary = relations[personnage_id]
	for champ in resultat["changements"]:
		relation[champ] = _copier(resultat["changements"][champ])
	relations[personnage_id] = relation
	etat_candidat["relations"] = relations
	return _succes()


static func _extraire_changements(payload: Dictionary, champs_autorises: Array) -> Dictionary:
	var changements = payload.get("changements")
	if typeof(changements) != TYPE_DICTIONARY or changements.is_empty():
		return _rejet("payload sans changements relationnels")
	for champ in changements:
		if typeof(champ) != TYPE_STRING or champ not in champs_autorises:
			return _rejet("champ relationnel non autorise: %s" % str(champ))
	return {"ok": true, "erreur": "", "changements": changements}


static func _copier(valeur):
	if typeof(valeur) in [TYPE_ARRAY, TYPE_DICTIONARY]:
		return valeur.duplicate(true)
	return valeur


static func _succes() -> Dictionary:
	return {"ok": true, "erreur": ""}


static func _rejet(erreur: String) -> Dictionary:
	return {"ok": false, "erreur": erreur}
