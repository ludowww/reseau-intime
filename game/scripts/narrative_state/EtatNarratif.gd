extends RefCounted

class_name EtatNarratif

const EtatRelationModele := preload("res://scripts/narrative_state/EtatRelation.gd")
const EtatRelationCentraleModele := preload("res://scripts/narrative_state/EtatRelationCentrale.gd")
const ReducerRelationModele := preload("res://scripts/narrative_state/ReducerRelation.gd")

const PERSONNAGES := ["marie", "sandra", "mathilde", "pauline", "raphaelle", "nico"]
const TYPE_RELATION_CENTRALE := "R8C_A1_RELATION_CENTRALE_SYNTHETIQUE"
const TYPE_RELATION := "R8C_A1_RELATION_SYNTHETIQUE"
const TYPES_EVENEMENTS := [TYPE_RELATION_CENTRALE, TYPE_RELATION]

var _etat: Dictionary = {}


static func creer_synthetique(relation_centrale_initiale: Dictionary) -> EtatNarratif:
	var relation_centrale := EtatRelationCentraleModele.creer_synthetique(relation_centrale_initiale)
	var erreur_centrale := EtatRelationCentraleModele.valider(relation_centrale)
	if not erreur_centrale.is_empty():
		push_error("EtatNarratif.creer_synthetique: %s" % erreur_centrale)
		return null
	var relations: Dictionary = {}
	for personnage_id in PERSONNAGES:
		relations[personnage_id] = EtatRelationModele.creer_synthetique(personnage_id)
	var instance := EtatNarratif.new()
	instance._etat = {
		"progression_saison": {
			"acte_courant": null,
			"evenements_structurants": [],
			"conditions_sortie": [],
			"obligations_recentrage": [],
			"historique_transitions": [],
		},
		"relation_centrale": relation_centrale,
		"relations": relations,
		"evenements": {},
		"promesses": {},
		"obligations": {},
		"traces_narratives": {},
		"connaissances": {},
		"livraison_medias": {},
	}
	var erreur_etat := instance._valider_etat_complet(instance._etat)
	if not erreur_etat.is_empty():
		push_error("EtatNarratif.creer_synthetique: %s" % erreur_etat)
		return null
	return instance


func traiter_evenement(evenement: Dictionary) -> Dictionary:
	var copie_evenement: Dictionary = evenement.duplicate(true)
	var erreur_evenement := _valider_evenement(copie_evenement)
	if not erreur_evenement.is_empty():
		return _resultat(false, "REJETE", erreur_evenement)
	var event_id: String = copie_evenement["event_id"]
	var evenements: Dictionary = _etat["evenements"]
	if evenements.has(event_id):
		if _structures_identiques(evenements[event_id], copie_evenement):
			return _resultat(true, "IDEMPOTENT", "")
		return _resultat(false, "REJETE", "event_id deja utilise avec un contenu different")
	var candidat: Dictionary = _etat.duplicate(true)
	var reduction := ReducerRelationModele.preparer_mutations(candidat, copie_evenement)
	if not reduction["ok"]:
		return _resultat(false, "REJETE", reduction["erreur"])
	var erreur_candidat := _valider_etat_complet(candidat)
	if not erreur_candidat.is_empty():
		return _resultat(false, "REJETE", erreur_candidat)
	candidat["evenements"][event_id] = copie_evenement.duplicate(true)
	_etat = candidat
	return _resultat(true, "APPLIQUE", "")


func obtenir_snapshot() -> Dictionary:
	return _etat.duplicate(true)


func _valider_evenement(evenement: Dictionary) -> String:
	var event_id = evenement.get("event_id")
	if typeof(event_id) != TYPE_STRING or event_id.strip_edges().is_empty():
		return "event_id doit etre une chaine opaque non vide"
	var event_type = evenement.get("event_type")
	if typeof(event_type) != TYPE_STRING or event_type not in TYPES_EVENEMENTS:
		return "event_type synthetique non autorise"
	var provenance = evenement.get("provenance")
	if typeof(provenance) != TYPE_DICTIONARY:
		return "provenance doit etre un dictionnaire"
	for champ in ["type", "id"]:
		var valeur = provenance.get(champ)
		if typeof(valeur) != TYPE_STRING or valeur.strip_edges().is_empty():
			return "provenance.%s doit etre une chaine non vide" % champ
	var payload = evenement.get("payload")
	if typeof(payload) != TYPE_DICTIONARY:
		return "payload doit etre un dictionnaire"
	if not _valeur_evenement_supportee(_copie_sure(evenement)):
		return "evenement contient une valeur non structurelle"
	return ""


func _valider_etat_complet(etat: Dictionary) -> String:
	var racines := [
		"progression_saison",
		"relation_centrale",
		"relations",
		"evenements",
		"promesses",
		"obligations",
		"traces_narratives",
		"connaissances",
		"livraison_medias",
	]
	for racine in racines:
		if not etat.has(racine) or typeof(etat[racine]) != TYPE_DICTIONARY:
			return "etat narratif: racine invalide: %s" % racine
	var erreur_centrale := EtatRelationCentraleModele.valider(etat["relation_centrale"])
	if not erreur_centrale.is_empty():
		return erreur_centrale
	var relations: Dictionary = etat["relations"]
	if relations.size() != PERSONNAGES.size():
		return "etat narratif: exactement six relations sont requises"
	for personnage_id in PERSONNAGES:
		if not relations.has(personnage_id) or typeof(relations[personnage_id]) != TYPE_DICTIONARY:
			return "etat narratif: relation manquante: %s" % personnage_id
		var erreur_relation := EtatRelationModele.valider(relations[personnage_id], personnage_id)
		if not erreur_relation.is_empty():
			return erreur_relation
	for event_id in etat["evenements"]:
		var evenement = etat["evenements"][event_id]
		if typeof(event_id) != TYPE_STRING or typeof(evenement) != TYPE_DICTIONARY:
			return "etat narratif: registre d'evenements invalide"
		if evenement.get("event_id") != event_id:
			return "etat narratif: cle d'evenement incoherente"
		var erreur_evenement := _valider_evenement(evenement)
		if not erreur_evenement.is_empty():
			return erreur_evenement
	return ""


func _valeur_evenement_supportee(valeur) -> bool:
	match typeof(valeur):
		TYPE_NIL, TYPE_BOOL, TYPE_INT, TYPE_FLOAT, TYPE_STRING:
			return true
		TYPE_ARRAY:
			for element in valeur:
				if not _valeur_evenement_supportee(element):
					return false
			return true
		TYPE_DICTIONARY:
			for cle in valeur:
				if typeof(cle) != TYPE_STRING or not _valeur_evenement_supportee(valeur[cle]):
					return false
			return true
		_:
			return false


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


func _copie_sure(valeur):
	if typeof(valeur) in [TYPE_ARRAY, TYPE_DICTIONARY]:
		return valeur.duplicate(true)
	return valeur


func _resultat(ok: bool, statut: String, erreur: String) -> Dictionary:
	return {"ok": ok, "statut": statut, "erreur": erreur}
