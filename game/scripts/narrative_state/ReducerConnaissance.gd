extends RefCounted

class_name ReducerConnaissance

const EFFECT_FIELDS := ["event_key", "effect", "knowledge_id", "subject_id", "holder_ids"]


static func preparer_mutations(etat_candidat: Dictionary, effets, provenance: Dictionary) -> Dictionary:
	if typeof(effets) != TYPE_ARRAY:
		return _rejet("knowledge doit etre un tableau")
	var candidat: Dictionary = etat_candidat.duplicate(true)
	var statut := "IDEMPOTENT"
	for effet in effets:
		var resultat := _preparer_effet(candidat, effet, provenance)
		if not resultat["ok"]:
			return resultat
		if resultat["statut"] == "APPLIQUE":
			statut = "APPLIQUE"
	etat_candidat.clear()
	etat_candidat.merge(candidat, true)
	return _succes(statut)


static func _preparer_effet(candidat: Dictionary, effet, provenance: Dictionary) -> Dictionary:
	if typeof(effet) != TYPE_DICTIONARY or not _champs_exacts(effet, EFFECT_FIELDS):
		return _rejet("forme connaissance invalide")
	if effet["effect"] != "ACQUIRE":
		return _rejet("effet connaissance inconnu")
	if not _identifiant_valide(effet["knowledge_id"]) or not _identifiant_valide(effet["subject_id"]):
		return _rejet("identifiant connaissance invalide")
	if not _ids_valides(effet["holder_ids"], true):
		return _rejet("holder_ids invalides")
	var record := {
		"knowledge_id": effet["knowledge_id"],
		"subject_id": effet["subject_id"],
		"holder_ids": effet["holder_ids"].duplicate(true),
		"status": "KNOWN",
		"provenance": provenance.duplicate(true),
	}
	var registre: Dictionary = candidat["connaissances"]
	if registre.has(record["knowledge_id"]):
		if _structures_identiques(registre[record["knowledge_id"]], record):
			return _succes("IDEMPOTENT")
		return _rejet("knowledge_id deja utilise avec un contenu different")
	registre[record["knowledge_id"]] = record
	candidat["connaissances"] = registre
	return _succes("APPLIQUE")


static func _champs_exacts(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _identifiant_valide(value) -> bool:
	return typeof(value) == TYPE_STRING and not value.strip_edges().is_empty() and value.length() <= 512


static func _ids_valides(value, require_non_empty: bool) -> bool:
	if typeof(value) != TYPE_ARRAY or (require_non_empty and value.is_empty()):
		return false
	var seen := {}
	for item in value:
		if not _identifiant_valide(item) or seen.has(item):
			return false
		seen[item] = true
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


static func _succes(statut: String) -> Dictionary:
	return {"ok": true, "statut": statut, "erreur": ""}


static func _rejet(erreur: String) -> Dictionary:
	return {"ok": false, "statut": "REJETE", "erreur": erreur}
