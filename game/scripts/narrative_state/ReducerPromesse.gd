extends RefCounted

class_name ReducerPromesse

const CREATE_FIELDS := ["event_key", "effect", "promise_id", "author_id", "beneficiary_ids", "content_ref"]
const TERMINAL_FIELDS := ["event_key", "effect", "promise_id"]


static func preparer_mutations(etat_candidat: Dictionary, effets, provenance: Dictionary) -> Dictionary:
	if typeof(effets) != TYPE_ARRAY:
		return _rejet("promises doit etre un tableau")
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
	if typeof(effet) != TYPE_DICTIONARY:
		return _rejet("effet promesse invalide")
	var operation = effet.get("effect")
	if operation == "CREATE":
		return _creer(candidat, effet, provenance)
	if operation in ["PAY", "FAIL"]:
		return _terminaliser(candidat, effet, provenance)
	return _rejet("effet promesse inconnu")


static func _creer(candidat: Dictionary, effet: Dictionary, provenance: Dictionary) -> Dictionary:
	if not _champs_exacts(effet, CREATE_FIELDS):
		return _rejet("forme CREATE promesse invalide")
	if (
		not _identifiant_valide(effet["event_key"])
		or not _identifiant_valide(effet["promise_id"])
		or not _identifiant_valide(effet["author_id"])
	):
		return _rejet("identifiant promesse invalide")
	if not _ids_valides(effet["beneficiary_ids"], true) or not _identifiant_valide(effet["content_ref"]):
		return _rejet("contenu promesse invalide")
	var record := {
		"promise_id": effet["promise_id"],
		"author_id": effet["author_id"],
		"beneficiary_ids": effet["beneficiary_ids"].duplicate(true),
		"content_ref": effet["content_ref"],
		"status": "ACTIVE",
		"provenance": provenance.duplicate(true),
		"resolved_at": null,
	}
	var registre: Dictionary = candidat["promesses"]
	if registre.has(record["promise_id"]):
		if _structures_identiques(registre[record["promise_id"]], record):
			return _succes("IDEMPOTENT")
		return _rejet("promise_id deja utilise avec un contenu different")
	registre[record["promise_id"]] = record
	candidat["promesses"] = registre
	return _succes("APPLIQUE")


static func _terminaliser(candidat: Dictionary, effet: Dictionary, provenance: Dictionary) -> Dictionary:
	if (
		not _champs_exacts(effet, TERMINAL_FIELDS)
		or not _identifiant_valide(effet["event_key"])
		or not _identifiant_valide(effet["promise_id"])
	):
		return _rejet("forme terminale promesse invalide")
	var registre: Dictionary = candidat["promesses"]
	if not registre.has(effet["promise_id"]):
		return _rejet("promesse absente")
	var record: Dictionary = registre[effet["promise_id"]]
	var statut_demande := "PAID" if effet["effect"] == "PAY" else "FAILED"
	if record["status"] == statut_demande and record["resolved_at"] == provenance["moment_diegetique"]:
		return _succes("IDEMPOTENT")
	if record["status"] != "ACTIVE":
		return _rejet("promesse deja terminale ou transition interdite")
	record["status"] = statut_demande
	record["resolved_at"] = provenance["moment_diegetique"]
	registre[effet["promise_id"]] = record
	candidat["promesses"] = registre
	return _succes("APPLIQUE")


static func _champs_exacts(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _identifiant_valide(value) -> bool:
	return (
		typeof(value) == TYPE_STRING
		and not value.is_empty()
		and value == value.strip_edges()
		and value.length() <= 512
	)


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
