extends RefCounted
class_name ReducerObligation

const CREATE_FIELDS := ["event_key", "effect", "obligation_id", "debtor_id", "beneficiary_ids", "kind"]
const TERMINAL_FIELDS := ["event_key", "effect", "obligation_id"]

static func preparer_mutations(etat_candidat: Dictionary, effets, provenance: Dictionary) -> Dictionary:
	if typeof(effets) != TYPE_ARRAY: return _reject("obligations doit etre un tableau")
	var candidat := etat_candidat.duplicate(true); var status := "IDEMPOTENT"
	for item in effets:
		var r := _one(candidat, item, provenance)
		if not r.ok: return r
		if r.statut == "APPLIQUE": status = "APPLIQUE"
	etat_candidat.clear(); etat_candidat.merge(candidat, true)
	return _ok(status)

static func _one(c: Dictionary, item, p: Dictionary) -> Dictionary:
	if typeof(item) != TYPE_DICTIONARY:
		return _reject("forme obligation invalide")
	var effect = item.get("effect")
	if effect in ["CREATE_DUE", "CREATE_PAID", "CREATE_FAILED"]:
		if not _exact(item, CREATE_FIELDS):
			return _reject("forme creation obligation invalide")
		if (
			not _id(item["event_key"])
			or not _id(item["obligation_id"])
			or not _id(item["debtor_id"])
			or not _ids(item["beneficiary_ids"])
			or not _id(item["kind"])
		):
			return _reject("obligation invalide")
		var terminal_status := "PAID" if effect == "CREATE_PAID" else "FAILED"
		var rec := {
			"obligation_id": item["obligation_id"],
			"debtor_id": item["debtor_id"],
			"beneficiary_ids": item["beneficiary_ids"].duplicate(true),
			"kind": item["kind"],
			"status": "DUE" if effect == "CREATE_DUE" else terminal_status,
			"provenance": p.duplicate(true),
			"resolved_at": null if effect == "CREATE_DUE" else p["moment_diegetique"],
		}
		if c["obligations"].has(item["obligation_id"]):
			return _same_or_reject(c["obligations"][item["obligation_id"]], rec)
		c["obligations"][item["obligation_id"]] = rec
		return _ok("APPLIQUE")
	if effect not in ["PAY", "FAIL"]:
		return _reject("effet obligation inconnu")
	if not _exact(item, TERMINAL_FIELDS):
		return _reject("forme terminale obligation invalide")
	if (
		not _id(item["event_key"])
		or not _id(item["obligation_id"])
		or not c["obligations"].has(item["obligation_id"])
	):
		return _reject("obligation absente")
	var rec: Dictionary = c["obligations"][item["obligation_id"]]
	var target := "PAID" if effect == "PAY" else "FAILED"
	if rec["status"] == target and rec["resolved_at"] == p["moment_diegetique"]:
		if rec["resolved_at"] == rec["provenance"]["moment_diegetique"]:
			return _reject("transition obligation impossible")
		return _ok("IDEMPOTENT")
	if rec["status"] != "DUE":
		return _reject("transition obligation impossible")
	rec["status"] = target
	rec["resolved_at"] = p["moment_diegetique"]
	c["obligations"][item["obligation_id"]] = rec
	return _ok("APPLIQUE")

static func _id(v) -> bool:
	return (
		typeof(v) == TYPE_STRING
		and not v.is_empty()
		and v == v.strip_edges()
		and v.length() <= 512
	)
static func _ids(v) -> bool:
	if typeof(v) != TYPE_ARRAY or v.is_empty(): return false
	var seen := {}
	for x in v:
		if not _id(x) or seen.has(x): return false
		seen[x] = true
	return true
static func _exact(d: Dictionary, fields: Array) -> bool:
	if d.size() != fields.size(): return false
	for f in fields:
		if not d.has(f): return false
	return true
static func _same_or_reject(a, b) -> Dictionary:
	if a == b: return _ok("IDEMPOTENT")
	return _reject("obligation_id deja utilise avec contenu different")
static func _ok(s: String) -> Dictionary: return {"ok":true,"statut":s,"erreur":""}
static func _reject(e: String) -> Dictionary: return {"ok":false,"statut":"REJETE","erreur":e}
