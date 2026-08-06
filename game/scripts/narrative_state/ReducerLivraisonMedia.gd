extends RefCounted
class_name ReducerLivraisonMedia

const CREATE_FIELDS := ["event_key", "effect", "media_id", "fictional_audience_ids"]
const GRANT_FIELDS := ["event_key", "effect", "media_id", "diegetic_status", "fictional_audience_ids", "gallery_status"]
const SIMPLE_FIELDS := ["event_key", "effect", "media_id"]

static func preparer_mutations(etat_candidat: Dictionary, effets, p: Dictionary) -> Dictionary:
	if typeof(effets) != TYPE_ARRAY: return _reject("media_deliveries doit etre un tableau")
	var c := etat_candidat.duplicate(true); var s := "IDEMPOTENT"
	for item in effets:
		var r := _one(c, item, p)
		if not r.ok: return r
		if r.statut == "APPLIQUE": s = "APPLIQUE"
	etat_candidat.clear(); etat_candidat.merge(c, true); return _ok(s)

static func _one(c: Dictionary, item, p: Dictionary) -> Dictionary:
	if typeof(item) != TYPE_DICTIONARY: return _reject("forme media invalide")
	var id = item.media_id; if not _id(id): return _reject("media_id invalide")
	var effect: String = item.effect
	if effect == "CREATE_DIEGETIC":
		if not _exact(item, CREATE_FIELDS) or not _ids(item.fictional_audience_ids): return _reject("creation media invalide")
		var rec := {"media_id":id,"diegetic_status":"CREATED","fictional_audience_ids":item.fictional_audience_ids.duplicate(true),"access_status":"LOCKED","gallery_status":"HIDDEN","withdrawal_status":"ACTIVE","provenance":p.duplicate(true)}
		if c.livraison_medias.has(id): return _same(c.livraison_medias[id], rec)
		c.livraison_medias[id] = rec; return _ok("APPLIQUE")
	if effect == "GRANT_ACCESS":
		if not _exact(item, GRANT_FIELDS) or not _ids(item.fictional_audience_ids) or item.diegetic_status not in ["CREATED", "NOT_APPLICABLE"]: return _reject("grant media invalide")
		if not c.livraison_medias.has(id):
			if item.gallery_status == "AVAILABLE":
				c.livraison_medias[id] = {"media_id":id,"diegetic_status":item.diegetic_status,"fictional_audience_ids":item.fictional_audience_ids.duplicate(true),"access_status":"ACCESSIBLE","gallery_status":"AVAILABLE","withdrawal_status":"ACTIVE","provenance":p.duplicate(true)}
			else:
				c.livraison_medias[id] = {"media_id":id,"diegetic_status":item.diegetic_status,"fictional_audience_ids":item.fictional_audience_ids.duplicate(true),"access_status":"ACCESSIBLE","gallery_status":"HIDDEN","withdrawal_status":"ACTIVE","provenance":p.duplicate(true)}
			return _ok("APPLIQUE")
		var rec: Dictionary = c.livraison_medias[id]
		if rec.withdrawal_status != "ACTIVE" or rec.diegetic_status != item.diegetic_status or rec.fictional_audience_ids != item.fictional_audience_ids: return _reject("grant divergent ou retrait")
		if item.gallery_status == "AVAILABLE" and rec.access_status != "ACCESSIBLE": rec.access_status = "ACCESSIBLE"
		elif item.gallery_status not in ["HIDDEN", "AVAILABLE"]: return _reject("gallery_status invalide")
		rec.access_status = "ACCESSIBLE"; rec.gallery_status = item.gallery_status; c.livraison_medias[id] = rec; return _ok("APPLIQUE")
	if effect == "REVOKE_ACCESS":
		if not _exact(item, SIMPLE_FIELDS): return _reject("forme revoke media invalide")
		if not c.livraison_medias.has(id): return _reject("media absent")
		var rec: Dictionary = c.livraison_medias[id]
		if rec.withdrawal_status != "ACTIVE": return _reject("media retire")
		if rec.access_status == "REVOKED" and rec.gallery_status == "HIDDEN": return _ok("IDEMPOTENT")
		rec.access_status = "REVOKED"; rec.gallery_status = "HIDDEN"; c.livraison_medias[id] = rec; return _ok("APPLIQUE")
	if effect == "WITHDRAW":
		if not _exact(item, SIMPLE_FIELDS): return _reject("forme withdraw media invalide")
		if not c.livraison_medias.has(id): return _reject("media absent")
		var rec: Dictionary = c.livraison_medias[id]
		if rec.withdrawal_status == "WITHDRAWN" and rec.gallery_status == "HIDDEN" and rec.access_status != "ACCESSIBLE": return _ok("IDEMPOTENT")
		if rec.withdrawal_status != "ACTIVE": return _reject("retrait media divergent")
		rec.withdrawal_status = "WITHDRAWN"; rec.gallery_status = "HIDDEN"; if rec.access_status == "ACCESSIBLE": rec.access_status = "REVOKED"
		c.livraison_medias[id] = rec; return _ok("APPLIQUE")
	return _reject("effet media inconnu")

static func _id(v) -> bool: return typeof(v) == TYPE_STRING and not v.strip_edges().is_empty() and v.length() <= 512
static func _ids(v) -> bool:
	if typeof(v) != TYPE_ARRAY or v.is_empty(): return false
	var seen := {}; for x in v:
		if not _id(x) or seen.has(x): return false
		seen[x] = true
	return true
static func _exact(d: Dictionary, fields: Array) -> bool:
	if d.size() != fields.size(): return false
	for f in fields:
		if not d.has(f): return false
	return true
static func _same(a, b) -> Dictionary: return _ok("IDEMPOTENT") if a == b else _reject("media_id deja utilise avec contenu different")
static func _ok(s: String) -> Dictionary: return {"ok":true,"statut":s,"erreur":""}
static func _reject(e: String) -> Dictionary: return {"ok":false,"statut":"REJETE","erreur":e}
