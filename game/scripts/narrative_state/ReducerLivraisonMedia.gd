extends RefCounted

class_name ReducerLivraisonMedia

const CREATE_FIELDS := ["event_key", "effect", "media_id", "fictional_audience_ids"]
const GRANT_FIELDS := [
	"event_key", "effect", "media_id", "diegetic_status", "fictional_audience_ids", "gallery_status",
]
const SIMPLE_FIELDS := ["event_key", "effect", "media_id"]
const GALLERY_STATUSES := ["HIDDEN", "AVAILABLE"]
const DIEGETIC_STATUSES := ["CREATED", "NOT_APPLICABLE"]


static func preparer_mutations(etat_candidat: Dictionary, effets, provenance: Dictionary) -> Dictionary:
	if typeof(effets) != TYPE_ARRAY:
		return _reject("media_deliveries doit etre un tableau")
	var candidat := etat_candidat.duplicate(true)
	var statut := "IDEMPOTENT"
	for item in effets:
		var resultat := _preparer_effet(candidat, item, provenance)
		if not resultat["ok"]:
			return resultat
		if resultat["statut"] == "APPLIQUE":
			statut = "APPLIQUE"
	etat_candidat.clear()
	etat_candidat.merge(candidat, true)
	return _ok(statut)


static func _preparer_effet(candidat: Dictionary, item, provenance: Dictionary) -> Dictionary:
	if typeof(item) != TYPE_DICTIONARY:
		return _reject("forme media invalide")
	var effect = item.get("effect")
	if effect == "CREATE_DIEGETIC":
		return _create(candidat, item, provenance)
	if effect == "GRANT_ACCESS":
		return _grant(candidat, item, provenance)
	if effect == "REVOKE_ACCESS":
		return _revoke(candidat, item)
	if effect == "WITHDRAW":
		return _withdraw(candidat, item)
	return _reject("effet media inconnu")


static func _create(candidat: Dictionary, item: Dictionary, provenance: Dictionary) -> Dictionary:
	if not _exact(item, CREATE_FIELDS):
		return _reject("forme creation media invalide")
	if (
		not _id(item["event_key"])
		or not _id(item["media_id"])
		or not _ids(item["fictional_audience_ids"], false)
	):
		return _reject("creation media invalide")
	var record := {
		"media_id": item["media_id"],
		"diegetic_status": "CREATED",
		"fictional_audience_ids": item["fictional_audience_ids"].duplicate(true),
		"access_status": "LOCKED",
		"gallery_status": "HIDDEN",
		"withdrawal_status": "ACTIVE",
		"provenance": provenance.duplicate(true),
	}
	var registry: Dictionary = candidat["livraison_medias"]
	if registry.has(item["media_id"]):
		return _same_or_reject(registry[item["media_id"]], record)
	registry[item["media_id"]] = record
	candidat["livraison_medias"] = registry
	return _ok("APPLIQUE")


static func _grant(candidat: Dictionary, item: Dictionary, provenance: Dictionary) -> Dictionary:
	if not _exact(item, GRANT_FIELDS):
		return _reject("forme grant media invalide")
	if (
		not _id(item["event_key"])
		or not _id(item["media_id"])
		or not _ids(item["fictional_audience_ids"], false)
		or item["diegetic_status"] not in DIEGETIC_STATUSES
		or item["gallery_status"] not in GALLERY_STATUSES
	):
		return _reject("grant media invalide")
	var registry: Dictionary = candidat["livraison_medias"]
	if not registry.has(item["media_id"]):
		registry[item["media_id"]] = {
			"media_id": item["media_id"],
			"diegetic_status": item["diegetic_status"],
			"fictional_audience_ids": item["fictional_audience_ids"].duplicate(true),
			"access_status": "ACCESSIBLE",
			"gallery_status": item["gallery_status"],
			"withdrawal_status": "ACTIVE",
			"provenance": provenance.duplicate(true),
		}
		candidat["livraison_medias"] = registry
		return _ok("APPLIQUE")
	var record: Dictionary = registry[item["media_id"]]
	if record["withdrawal_status"] != "ACTIVE":
		return _reject("acces interdit sur media retire")
	if record["diegetic_status"] != item["diegetic_status"]:
		return _reject("diegetic_status divergent")
	if record["fictional_audience_ids"] != item["fictional_audience_ids"]:
		return _reject("audience media divergente")
	if record["gallery_status"] == "AVAILABLE" and item["gallery_status"] == "HIDDEN":
		return _reject("baisse galerie interdite")
	if record["access_status"] == "ACCESSIBLE" and record["gallery_status"] == item["gallery_status"]:
		return _ok("IDEMPOTENT")
	record["access_status"] = "ACCESSIBLE"
	record["gallery_status"] = item["gallery_status"]
	registry[item["media_id"]] = record
	candidat["livraison_medias"] = registry
	return _ok("APPLIQUE")


static func _revoke(candidat: Dictionary, item: Dictionary) -> Dictionary:
	if not _exact(item, SIMPLE_FIELDS):
		return _reject("forme revoke media invalide")
	if not _id(item["event_key"]) or not _id(item["media_id"]):
		return _reject("revoke media invalide")
	var registry: Dictionary = candidat["livraison_medias"]
	if not registry.has(item["media_id"]):
		return _reject("media absent")
	var record: Dictionary = registry[item["media_id"]]
	if record["withdrawal_status"] != "ACTIVE":
		return _reject("media retire")
	if record["access_status"] == "REVOKED" and record["gallery_status"] == "HIDDEN":
		return _ok("IDEMPOTENT")
	record["access_status"] = "REVOKED"
	record["gallery_status"] = "HIDDEN"
	registry[item["media_id"]] = record
	candidat["livraison_medias"] = registry
	return _ok("APPLIQUE")


static func _withdraw(candidat: Dictionary, item: Dictionary) -> Dictionary:
	if not _exact(item, SIMPLE_FIELDS):
		return _reject("forme withdraw media invalide")
	if not _id(item["event_key"]) or not _id(item["media_id"]):
		return _reject("withdraw media invalide")
	var registry: Dictionary = candidat["livraison_medias"]
	if not registry.has(item["media_id"]):
		return _reject("media absent")
	var record: Dictionary = registry[item["media_id"]]
	if record["withdrawal_status"] == "WITHDRAWN":
		if record["gallery_status"] == "HIDDEN" and record["access_status"] != "ACCESSIBLE":
			return _ok("IDEMPOTENT")
		return _reject("retrait media divergent")
	if record["withdrawal_status"] != "ACTIVE":
		return _reject("transition retrait media impossible")
	record["withdrawal_status"] = "WITHDRAWN"
	record["gallery_status"] = "HIDDEN"
	if record["access_status"] == "ACCESSIBLE":
		record["access_status"] = "REVOKED"
	registry[item["media_id"]] = record
	candidat["livraison_medias"] = registry
	return _ok("APPLIQUE")


static func _id(value) -> bool:
	return (
		typeof(value) == TYPE_STRING
		and not value.is_empty()
		and value == value.strip_edges()
		and value.length() <= 512
	)


static func _ids(value, require_non_empty: bool) -> bool:
	if typeof(value) != TYPE_ARRAY or (require_non_empty and value.is_empty()):
		return false
	var seen := {}
	for identifier in value:
		if not _id(identifier) or seen.has(identifier):
			return false
		seen[identifier] = true
	return true


static func _exact(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _same_or_reject(left, right) -> Dictionary:
	if left == right:
		return _ok("IDEMPOTENT")
	return _reject("media_id deja utilise avec contenu different")


static func _ok(status: String) -> Dictionary:
	return {"ok": true, "statut": status, "erreur": ""}


static func _reject(error: String) -> Dictionary:
	return {"ok": false, "statut": "REJETE", "erreur": error}
