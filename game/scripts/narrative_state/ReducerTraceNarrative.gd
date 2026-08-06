extends RefCounted

class_name ReducerTraceNarrative

const CREATE_FIELDS := [
	"event_key", "effect", "trace_id", "creator_id", "audience_ids", "controller_ids", "accessible_to_ids",
]
const ACCESS_FIELDS := ["event_key", "effect", "trace_id", "accessible_to_ids"]
const WITHDRAW_FIELDS := ["event_key", "effect", "trace_id"]


static func preparer_mutations(etat_candidat: Dictionary, effets, provenance: Dictionary) -> Dictionary:
	if typeof(effets) != TYPE_ARRAY:
		return _rejet("traces doit etre un tableau")
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
		return _rejet("effet trace invalide")
	var operation = effet.get("effect")
	if operation == "CREATE":
		return _creer(candidat, effet, provenance)
	if operation in ["GRANT_ACCESS", "REVOKE_ACCESS"]:
		return _acces(candidat, effet)
	if operation == "WITHDRAW":
		return _retirer(candidat, effet, provenance)
	return _rejet("effet trace inconnu")


static func _creer(candidat: Dictionary, effet: Dictionary, provenance: Dictionary) -> Dictionary:
	if not _champs_exacts(effet, CREATE_FIELDS):
		return _rejet("forme CREATE trace invalide")
	if (
		not _identifiant_valide(effet["event_key"])
		or not _identifiant_valide(effet["trace_id"])
		or not _identifiant_valide(effet["creator_id"])
	):
		return _rejet("identifiant trace invalide")
	for field in ["audience_ids", "controller_ids", "accessible_to_ids"]:
		if not _ids_valides(effet[field], false):
			return _rejet("liste trace invalide: %s" % field)
	var record := {
		"trace_id": effet["trace_id"],
		"creator_id": effet["creator_id"],
		"audience_ids": effet["audience_ids"].duplicate(true),
		"controller_ids": effet["controller_ids"].duplicate(true),
		"accessible_to_ids": effet["accessible_to_ids"].duplicate(true),
		"status": "ACTIVE",
		"provenance": provenance.duplicate(true),
		"withdrawn_at": null,
	}
	var registre: Dictionary = candidat["traces_narratives"]
	if registre.has(record["trace_id"]):
		if _structures_identiques(registre[record["trace_id"]], record):
			return _succes("IDEMPOTENT")
		return _rejet("trace_id deja utilise avec un contenu different")
	registre[record["trace_id"]] = record
	candidat["traces_narratives"] = registre
	return _succes("APPLIQUE")


static func _acces(candidat: Dictionary, effet: Dictionary) -> Dictionary:
	if not _champs_exacts(effet, ACCESS_FIELDS):
		return _rejet("forme acces trace invalide")
	if (
		not _identifiant_valide(effet["event_key"])
		or not _identifiant_valide(effet["trace_id"])
		or not _ids_valides(effet["accessible_to_ids"], true)
	):
		return _rejet("acces trace invalide")
	var registre: Dictionary = candidat["traces_narratives"]
	if not registre.has(effet["trace_id"]):
		return _rejet("trace absente")
	var record: Dictionary = registre[effet["trace_id"]]
	if record["status"] != "ACTIVE":
		return _rejet("acces interdit sur trace retiree")
	var current: Array = record["accessible_to_ids"]
	var changed := false
	if effet["effect"] == "GRANT_ACCESS":
		for identifier in effet["accessible_to_ids"]:
			if not current.has(identifier):
				current.append(identifier)
				changed = true
	else:
		var kept: Array = []
		for identifier in current:
			if identifier not in effet["accessible_to_ids"]:
				kept.append(identifier)
			else:
				changed = true
		current = kept
	if not changed:
		return _succes("IDEMPOTENT")
	record["accessible_to_ids"] = current
	registre[effet["trace_id"]] = record
	candidat["traces_narratives"] = registre
	return _succes("APPLIQUE")


static func _retirer(candidat: Dictionary, effet: Dictionary, provenance: Dictionary) -> Dictionary:
	if (
		not _champs_exacts(effet, WITHDRAW_FIELDS)
		or not _identifiant_valide(effet["event_key"])
		or not _identifiant_valide(effet["trace_id"])
	):
		return _rejet("forme retrait trace invalide")
	var registre: Dictionary = candidat["traces_narratives"]
	if not registre.has(effet["trace_id"]):
		return _rejet("trace absente")
	var record: Dictionary = registre[effet["trace_id"]]
	if record["status"] == "WITHDRAWN":
		if record["withdrawn_at"] == provenance["moment_diegetique"]:
			return _succes("IDEMPOTENT")
		return _rejet("retrait trace divergent")
	if record["status"] != "ACTIVE":
		return _rejet("transition retrait trace impossible")
	record["status"] = "WITHDRAWN"
	record["withdrawn_at"] = provenance["moment_diegetique"]
	registre[effet["trace_id"]] = record
	candidat["traces_narratives"] = registre
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
