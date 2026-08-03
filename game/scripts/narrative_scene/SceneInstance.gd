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
	if not diagnostic.get("eligible", false):
		return null
	for champ in ["instance_id", "moment_diegetique"]:
		var valeur = contexte.get(champ)
		if typeof(valeur) != TYPE_STRING or valeur.strip_edges().is_empty():
			return null
	var instance := new()
	instance._donnees = {
		"instance_id": contexte["instance_id"],
		"scene_id": definition["scene_id"],
		"version_contrat": definition["version_contrat"],
		"date_diegetique_effective": contexte["moment_diegetique"].substr(0, 10),
		"creneau": {
			"debut": contexte["moment_diegetique"],
			"duree_minutes": definition["contrat_temporel"]["duree_minutes"],
		},
		"participants": definition["participants_requis"].duplicate(true),
		"statut": ELIGIBLE,
		"reference_etat": {
			"acte_courant": contexte.get("acte_courant"),
			"event_ids_observes": diagnostic.get("event_ids_observes", []).duplicate(true),
			"derniere_revalidation": diagnostic.get("revalidation_requise_a"),
		},
		"transitions": [{
			"instant_diegetique": contexte["moment_diegetique"],
			"etat_precedent": null,
			"etat_suivant": ELIGIBLE,
			"code_raison": "INTENTION_DE_PROPOSITION",
			"source_decision": "R8C_A3_MOTEUR_MINIMAL",
		}],
	}
	return instance


func obtenir_snapshot() -> Dictionary:
	return _donnees.duplicate(true)


func obtenir_statut() -> String:
	return _donnees.get("statut", INELIGIBLE)


func transitionner(nouveau_statut: String, code_raison: String, instant_diegetique: String) -> Dictionary:
	var statut_courant := obtenir_statut()
	if nouveau_statut not in STATUTS:
		return _rejet("statut de scene inconnu")
	if statut_courant in STATUTS_TERMINAUX:
		return _rejet("instance deja terminale")
	var autorise := (
		(statut_courant == ELIGIBLE and nouveau_statut in [PROPOSED, CANCELLED])
		or (statut_courant == PROPOSED and nouveau_statut in [RESOLVED, MISSED, CANCELLED])
	)
	if not autorise:
		return _rejet("transition de scene interdite: %s -> %s" % [statut_courant, nouveau_statut])
	if code_raison.strip_edges().is_empty() or instant_diegetique.strip_edges().is_empty():
		return _rejet("transition de scene sans raison ou instant")
	_donnees["statut"] = nouveau_statut
	_donnees["transitions"].append({
		"instant_diegetique": instant_diegetique,
		"etat_precedent": statut_courant,
		"etat_suivant": nouveau_statut,
		"code_raison": code_raison,
		"source_decision": "R8C_A3_MOTEUR_MINIMAL",
	})
	return {"ok": true, "erreur": "", "statut": nouveau_statut}


func _rejet(erreur: String) -> Dictionary:
	return {"ok": false, "erreur": erreur, "statut": obtenir_statut()}
