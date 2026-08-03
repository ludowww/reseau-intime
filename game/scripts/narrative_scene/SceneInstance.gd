extends RefCounted

class_name R8CSceneInstance

const INELIGIBLE := "INELIGIBLE"
const ELIGIBLE := "ELIGIBLE"
const PROPOSED := "PROPOSED"
const RESOLVED := "RESOLVED"
const MISSED := "MISSED"
const CANCELLED := "CANCELLED"
const STATUTS := [INELIGIBLE, ELIGIBLE, PROPOSED, RESOLVED, MISSED, CANCELLED]
const STATUTS_TERMINAUX := [RESOLVED, MISSED, CANCELLED]

var _donnees: Dictionary = {}


static func creer(definition: Dictionary, diagnostic: Dictionary, contexte: Dictionary) -> R8CSceneInstance:
	for champ in ["instance_id", "moment_diegetique"]:
		var valeur = contexte.get(champ)
		if typeof(valeur) != TYPE_STRING or valeur.strip_edges().is_empty():
			return null
	var statut_initial: String = diagnostic.get("statut", INELIGIBLE)
	if statut_initial not in [INELIGIBLE, ELIGIBLE]:
		return null
	var instance := new()
	instance._donnees = {
		"instance_id": contexte["instance_id"],
		"scene_id": definition["scene_id"],
		"version_contrat": definition["version_contrat"],
		"politique_unicite": definition["politique_unicite"],
		"date_diegetique_effective": contexte["moment_diegetique"].substr(0, 10),
		"creneau": {
			"debut": contexte["moment_diegetique"],
			"duree_minutes": definition["contrat_temporel"]["duree_minutes"],
		},
		"participants": definition["participants_requis"].duplicate(true),
		"statut": statut_initial,
		"reference_etat": {
			"acte_courant": contexte.get("acte_courant"),
			"event_ids_observes": diagnostic.get("event_ids_observes", []).duplicate(true),
			"revalidation_requise_avant": diagnostic.get("revalidation_requise_avant"),
		},
		"traces_temporaires": {},
		"terminaison": {},
		"transitions": [{
			"instant_diegetique": contexte["moment_diegetique"],
			"etat_precedent": null,
			"etat_suivant": statut_initial,
			"code_raison": "EVALUATION_INITIALE",
			"source_decision": "R8C_A3_MOTEUR_MINIMAL",
		}],
	}
	return instance


func obtenir_snapshot() -> Dictionary:
	return _donnees.duplicate(true)


func obtenir_statut() -> String:
	return _donnees.get("statut", INELIGIBLE)


func obtenir_terminaison() -> Dictionary:
	return _donnees.get("terminaison", {}).duplicate(true)


func preparer_transition(
	nouveau_statut: String,
	code_raison: String,
	instant_diegetique: String,
	terminaison: Dictionary = {},
	trace_temporaire: Dictionary = {}
) -> Dictionary:
	var statut_courant := obtenir_statut()
	if nouveau_statut not in STATUTS:
		return _rejet("statut de scene inconnu")
	if statut_courant in STATUTS_TERMINAUX:
		return _rejet("instance deja terminale")
	var autorise := (
		(statut_courant == INELIGIBLE and nouveau_statut in [ELIGIBLE, CANCELLED])
		or (statut_courant == ELIGIBLE and nouveau_statut in [INELIGIBLE, PROPOSED, CANCELLED])
		or (statut_courant == PROPOSED and nouveau_statut in [RESOLVED, MISSED, CANCELLED])
	)
	if not autorise:
		return _rejet("transition de scene interdite: %s -> %s" % [statut_courant, nouveau_statut])
	if code_raison.strip_edges().is_empty() or instant_diegetique.strip_edges().is_empty():
		return _rejet("transition de scene sans raison ou instant")
	if nouveau_statut in STATUTS_TERMINAUX:
		if terminaison.is_empty() or not _donnees["terminaison"].is_empty():
			return _rejet("transition terminale sans terminaison preparee ou deja presente")
	elif not terminaison.is_empty() or not trace_temporaire.is_empty():
		return _rejet("donnees terminales sur transition non terminale")
	var trace_preparee := {}
	if not trace_temporaire.is_empty():
		var trace_id = trace_temporaire.get("trace_id")
		if typeof(trace_id) != TYPE_STRING or trace_id.strip_edges().is_empty():
			return _rejet("trace temporaire sans identifiant")
		trace_preparee = trace_temporaire.duplicate(true)
	return {
		"ok": true,
		"erreur": "",
		"statut": nouveau_statut,
		"transition": {
			"instant_diegetique": instant_diegetique,
			"etat_precedent": statut_courant,
			"etat_suivant": nouveau_statut,
			"code_raison": code_raison,
			"source_decision": "R8C_A3_MOTEUR_MINIMAL",
		},
		"terminaison": terminaison.duplicate(true),
		"trace_temporaire": trace_preparee,
	}


func appliquer_transition_preparee(preparation: Dictionary) -> void:
	_donnees["statut"] = preparation["statut"]
	_donnees["transitions"].append(preparation["transition"].duplicate(true))
	if not preparation["terminaison"].is_empty():
		_donnees["terminaison"] = preparation["terminaison"].duplicate(true)
	var trace: Dictionary = preparation["trace_temporaire"]
	if not trace.is_empty():
		_donnees["traces_temporaires"][trace["trace_id"]] = trace.duplicate(true)


func transitionner(nouveau_statut: String, code_raison: String, instant_diegetique: String) -> Dictionary:
	if nouveau_statut in [RESOLVED, MISSED]:
		return _rejet("transition terminale transactionnelle exige preparation explicite")
	var terminaison := {}
	if nouveau_statut == CANCELLED:
		terminaison = {
			"operation": "ANNULATION",
			"transaction_id": "r8c-a3:%s:annulation:%s" % [_donnees["instance_id"], code_raison],
		}
	var preparation := preparer_transition(nouveau_statut, code_raison, instant_diegetique, terminaison)
	if not preparation["ok"]:
		return preparation
	appliquer_transition_preparee(preparation)
	return {"ok": true, "erreur": "", "statut": nouveau_statut}


func nettoyer_traces_temporaires() -> int:
	var nombre: int = _donnees["traces_temporaires"].size()
	_donnees["traces_temporaires"].clear()
	return nombre


func _rejet(erreur: String) -> Dictionary:
	return {"ok": false, "erreur": erreur, "statut": obtenir_statut()}
