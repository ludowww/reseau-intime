extends RefCounted

class_name ReducerRelation

const EtatRelationModele := preload("res://scripts/narrative_state/EtatRelation.gd")
const EtatRelationCentraleModele := preload("res://scripts/narrative_state/EtatRelationCentrale.gd")

const TYPE_RELATION_CENTRALE := "R8C_A1_RELATION_CENTRALE_SYNTHETIQUE"
const TYPE_RELATION := "R8C_A1_RELATION_SYNTHETIQUE"
const FACT_FIELDS := ["fait_id", "nature", "recu_par", "permission_future", "formulee_par"]
const RELATION_FACT_FIELDS := ["event_key", "scope", "personnage_id", "fact"]
const CENTRAL_FACT_FIELDS := ["event_key", "scope", "fact"]
const FACT_PROVENANCE_FIELDS := [
	"source_scene_id", "source_scene_instance_id", "source_resolution_id", "moment_diegetique",
]


static func preparer_mutations(etat_candidat: Dictionary, evenement: Dictionary) -> Dictionary:
	match evenement["event_type"]:
		TYPE_RELATION_CENTRALE:
			return _appliquer_relation_centrale(etat_candidat, evenement["payload"])
		TYPE_RELATION:
			return _appliquer_relation(etat_candidat, evenement["payload"])
		_:
			return _rejet("type d'evenement non supporte par le reducer")


static func preparer_faits(etat_candidat: Dictionary, payload, provenance: Dictionary) -> Dictionary:
	if typeof(payload) != TYPE_ARRAY:
		return _rejet_durable("facts doit etre un tableau")
	var candidat: Dictionary = etat_candidat.duplicate(true)
	var statut := "IDEMPOTENT"
	for fait_payload in payload:
		var resultat := _preparer_fait(candidat, fait_payload, provenance)
		if not resultat["ok"]:
			return resultat
		if resultat["statut"] == "APPLIQUE":
			statut = "APPLIQUE"
	etat_candidat.clear()
	etat_candidat.merge(candidat, true)
	return _succes_durable(statut)


static func _preparer_fait(candidat: Dictionary, payload, provenance: Dictionary) -> Dictionary:
	if typeof(payload) != TYPE_DICTIONARY:
		return _rejet_durable("fait doit etre un dictionnaire")
	var scope = payload.get("scope")
	var attendu := RELATION_FACT_FIELDS if scope == "RELATION" else CENTRAL_FACT_FIELDS if scope == "RELATION_CENTRALE" else []
	if attendu.is_empty() or not _champs_exacts(payload, attendu):
		return _rejet_durable("forme de fait durable invalide")
	var fact = payload.get("fact")
	if typeof(fact) != TYPE_DICTIONARY or not _champs_exacts(fact, FACT_FIELDS):
		return _rejet_durable("fact authored invalide")
	if typeof(fact["fait_id"]) != TYPE_STRING or fact["fait_id"].strip_edges().is_empty():
		return _rejet_durable("fait_id invalide")
	if typeof(fact["nature"]) != TYPE_STRING or fact["nature"].strip_edges().is_empty():
		return _rejet_durable("nature invalide")
	for field in ["recu_par", "formulee_par"]:
		if typeof(fact[field]) != TYPE_STRING or fact[field].strip_edges().is_empty():
			return _rejet_durable("champ de fait invalide: %s" % field)
	if typeof(fact["permission_future"]) != TYPE_BOOL:
		return _rejet_durable("permission_future invalide")
	var relation: Dictionary
	if scope == "RELATION":
		var personnage_id = payload.get("personnage_id")
		if typeof(personnage_id) != TYPE_STRING or personnage_id.strip_edges().is_empty():
			return _rejet_durable("RELATION exige un personnage_id")
		if not candidat["relations"].has(personnage_id):
			return _rejet_durable("relation inconnue: %s" % personnage_id)
		relation = candidat["relations"][personnage_id]
	else:
		if payload.has("personnage_id"):
			return _rejet_durable("RELATION_CENTRALE interdit personnage_id")
		relation = candidat["relation_centrale"]
	var record: Dictionary = fact.duplicate(true)
	for field in FACT_PROVENANCE_FIELDS:
		record[field] = provenance[field]
	for existing in relation["faits"]:
		if typeof(existing) != TYPE_DICTIONARY or existing.get("fait_id") != record["fait_id"]:
			continue
		if _structures_identiques(existing, record):
			return _succes_durable("IDEMPOTENT")
		return _rejet_durable("fait_id deja utilise avec un contenu different")
	relation["faits"].append(record)
	if scope == "RELATION":
		candidat["relations"][payload["personnage_id"]] = relation
	else:
		candidat["relation_centrale"] = relation
	return _succes_durable("APPLIQUE")


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


static func _champs_exacts(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _structures_identiques(left, right) -> bool:
	if typeof(left) != typeof(right):
		return false
	if typeof(left) == TYPE_DICTIONARY:
		if left.size() != right.size():
			return false
		for key in left:
			if not right.has(key) or not _structures_identiques(left[key], right[key]):
				return false
		return true
	if typeof(left) == TYPE_ARRAY:
		if left.size() != right.size():
			return false
		for index in left.size():
			if not _structures_identiques(left[index], right[index]):
				return false
		return true
	return left == right


static func _succes_durable(statut: String) -> Dictionary:
	return {"ok": true, "statut": statut, "erreur": ""}


static func _rejet_durable(erreur: String) -> Dictionary:
	return {"ok": false, "statut": "REJETE", "erreur": erreur}
