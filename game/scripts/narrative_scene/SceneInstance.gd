extends RefCounted

class_name R8CSceneInstance

const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")

const INELIGIBLE := "INELIGIBLE"
const ELIGIBLE := "ELIGIBLE"
const PROPOSED := "PROPOSED"
const RESOLVED := "RESOLVED"
const MISSED := "MISSED"
const CANCELLED := "CANCELLED"
const STATUTS := [INELIGIBLE, ELIGIBLE, PROPOSED, RESOLVED, MISSED, CANCELLED]
const STATUTS_TERMINAUX := [RESOLVED, MISSED, CANCELLED]
const POLITIQUES_UNICITE := ["UNIQUE", "REPETABLE"]
const CHAMPS_SNAPSHOT_PERSISTANT := [
	"instance_id",
	"scene_definition_id",
	"definition_version",
	"uniqueness_policy",
	"state",
	"created_at",
	"last_transition_at",
	"operation",
	"choice_id",
	"resolution_id",
	"transaction_id",
	"temporary_traces",
]
const CHAMPS_TRACE_TEMPORAIRE := [
	"trace_id",
	"scope",
	"content",
	"source_scene_instance_id",
	"source_resolution_id",
	"created_at",
]
const MAX_TRACES_TEMPORAIRES := 16
const MAX_LONGUEUR_CHAINE := 512

var _donnees: Dictionary = {}


static func creer(definition: Dictionary, diagnostic: Dictionary, contexte: Dictionary) -> R8CSceneInstance:
	for champ in ["instance_id", "moment_diegetique"]:
		var valeur = contexte.get(champ)
		if not _chaine_non_vide(valeur):
			return null
	for champ in ["scene_id", "version_contrat"]:
		if not _chaine_non_vide(definition.get(champ)):
			return null
	if not _moment_normalise_valide(contexte["moment_diegetique"]):
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
		"statut": statut_initial,
		"created_at": contexte["moment_diegetique"],
		"last_transition_at": contexte["moment_diegetique"],
		"traces_temporaires": {},
		"terminaison": {},
	}
	return instance


static func creer_depuis_snapshot_persistant(snapshot: Dictionary) -> R8CSceneInstance:
	if not _champs_exacts(snapshot, CHAMPS_SNAPSHOT_PERSISTANT):
		return null
	for champ in ["instance_id", "scene_definition_id", "definition_version", "created_at", "last_transition_at"]:
		if not _chaine_non_vide(snapshot.get(champ)):
			return null
	if not _moment_normalise_valide(snapshot["created_at"]) or not _moment_normalise_valide(snapshot["last_transition_at"]):
		return null
	if not _meme_offset(snapshot["created_at"], snapshot["last_transition_at"]) or snapshot["last_transition_at"] < snapshot["created_at"]:
		return null
	if snapshot["uniqueness_policy"] not in POLITIQUES_UNICITE or snapshot["state"] not in STATUTS:
		return null
	for champ in ["operation", "choice_id", "resolution_id", "transaction_id"]:
		if typeof(snapshot.get(champ)) != TYPE_STRING:
			return null
		if not snapshot[champ].is_empty() and not _chaine_non_vide(snapshot[champ]):
			return null
	var statut: String = snapshot["state"]
	var operation: String = snapshot["operation"]
	var choix_id: String = snapshot["choice_id"]
	var resolution_id: String = snapshot["resolution_id"]
	var transaction_id: String = snapshot["transaction_id"]
	if not _terminaison_valide(statut, operation, choix_id, resolution_id, transaction_id, snapshot["instance_id"]):
		return null
	var traces = snapshot["temporary_traces"]
	if typeof(traces) != TYPE_DICTIONARY or not _traces_temporaires_valides(
		traces, snapshot["instance_id"], snapshot["created_at"], snapshot["last_transition_at"]
	):
		return null
	if (statut != PROPOSED and not traces.is_empty()) or statut in STATUTS_TERMINAUX and not traces.is_empty():
		return null
	var terminaison := {}
	if statut in STATUTS_TERMINAUX:
		terminaison = {
			"operation": operation,
			"transaction_id": transaction_id,
			"choix_id": choix_id,
			"resolution_id": resolution_id,
		}
	var instance := new()
	instance._donnees = {
		"instance_id": snapshot["instance_id"],
		"scene_id": snapshot["scene_definition_id"],
		"version_contrat": snapshot["definition_version"],
		"politique_unicite": snapshot["uniqueness_policy"],
		"statut": statut,
		"created_at": snapshot["created_at"],
		"last_transition_at": snapshot["last_transition_at"],
		"traces_temporaires": traces.duplicate(true),
		"terminaison": terminaison,
	}
	return instance


func obtenir_snapshot() -> Dictionary:
	return _donnees.duplicate(true)


func obtenir_snapshot_persistant() -> Dictionary:
	var terminaison: Dictionary = _donnees.get("terminaison", {})
	var traces := {}
	if obtenir_statut() == PROPOSED:
		traces = _donnees.get("traces_temporaires", {}).duplicate(true)
	return {
		"instance_id": obtenir_instance_id(),
		"scene_definition_id": obtenir_scene_definition_id(),
		"definition_version": _donnees["version_contrat"],
		"uniqueness_policy": obtenir_politique_unicite(),
		"state": obtenir_statut(),
		"created_at": _donnees["created_at"],
		"last_transition_at": _donnees["last_transition_at"],
		"operation": str(terminaison.get("operation", "")),
		"choice_id": str(terminaison.get("choix_id", "")),
		"resolution_id": str(terminaison.get("resolution_id", "")),
		"transaction_id": str(terminaison.get("transaction_id", "")),
		"temporary_traces": traces,
	}


func obtenir_instance_id() -> String:
	return _donnees.get("instance_id", "")


func obtenir_scene_definition_id() -> String:
	return _donnees.get("scene_id", "")


func obtenir_politique_unicite() -> String:
	return _donnees.get("politique_unicite", "")


func obtenir_dernier_instant() -> String:
	return _donnees.get("last_transition_at", "")


func obtenir_statut() -> String:
	return _donnees.get("statut", INELIGIBLE)


func obtenir_terminaison() -> Dictionary:
	return _donnees.get("terminaison", {}).duplicate(true)


func preparer_transition(
	nouveau_statut: String,
	code_raison: String,
	instant_diegetique: String,
	terminaison: Dictionary = {}
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
	if not _chaine_non_vide(code_raison) or not _moment_normalise_valide(instant_diegetique):
		return _rejet("transition de scene sans raison ou instant valide")
	if not _meme_offset(_donnees["created_at"], instant_diegetique) or instant_diegetique < _donnees["last_transition_at"]:
		return _rejet("transition de scene anterieure au dernier instant")
	if nouveau_statut in STATUTS_TERMINAUX:
		if terminaison.is_empty() or not _donnees["terminaison"].is_empty():
			return _rejet("transition terminale sans terminaison preparee ou deja presente")
	elif not terminaison.is_empty():
		return _rejet("donnees terminales sur transition non terminale")
	return {
		"ok": true,
		"erreur": "",
		"statut": nouveau_statut,
		"instant_diegetique": instant_diegetique,
		"terminaison": terminaison.duplicate(true),
	}


func appliquer_transition_preparee(preparation: Dictionary) -> void:
	_donnees["statut"] = preparation["statut"]
	_donnees["last_transition_at"] = preparation["instant_diegetique"]
	if not preparation["terminaison"].is_empty():
		_donnees["terminaison"] = preparation["terminaison"].duplicate(true)
	if preparation["statut"] in STATUTS_TERMINAUX:
		_donnees["traces_temporaires"].clear()


func transitionner(nouveau_statut: String, code_raison: String, instant_diegetique: String) -> Dictionary:
	if nouveau_statut in [RESOLVED, MISSED]:
		return _rejet("transition terminale transactionnelle exige preparation explicite")
	var terminaison := {}
	if nouveau_statut == CANCELLED:
		terminaison = {
			"operation": "ANNULATION",
			"transaction_id": "r8c-a3:%s:annulation:%s" % [obtenir_instance_id(), code_raison],
			"choix_id": "",
			"resolution_id": "",
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


func _declarer_reprise_temporaire_validee(
	trace_id: String,
	contenu: String,
	resolution_source_id: String,
	instant_diegetique: String
) -> Dictionary:
	if obtenir_statut() != PROPOSED:
		return _rejet("reprise temporaire reservee a une instance proposee")
	if (
		not _chaine_non_vide(trace_id)
		or not _chaine_non_vide(contenu)
		or not _chaine_non_vide(resolution_source_id)
		or not _moment_normalise_valide(instant_diegetique)
		or not _meme_offset(_donnees["created_at"], instant_diegetique)
		or instant_diegetique < _donnees["last_transition_at"]
		or _donnees["traces_temporaires"].size() >= MAX_TRACES_TEMPORAIRES
		or _donnees["traces_temporaires"].has(trace_id)
	):
		return _rejet("reprise temporaire invalide")
	_donnees["traces_temporaires"][trace_id] = {
		"trace_id": trace_id,
		"scope": "TEMPORAIRE",
		"content": contenu,
		"source_scene_instance_id": obtenir_instance_id(),
		"source_resolution_id": resolution_source_id,
		"created_at": instant_diegetique,
	}
	_donnees["last_transition_at"] = instant_diegetique
	return {"ok": true, "erreur": "", "statut": obtenir_statut()}


static func _terminaison_valide(
	statut: String,
	operation: String,
	choix_id: String,
	resolution_id: String,
	transaction_id: String,
	instance_id: String
) -> bool:
	if statut not in STATUTS_TERMINAUX:
		return operation.is_empty() and choix_id.is_empty() and resolution_id.is_empty() and transaction_id.is_empty()
	if not _chaine_non_vide(transaction_id):
		return false
	if operation == "RESOLUTION":
		return (
			statut == RESOLVED and not choix_id.is_empty() and not resolution_id.is_empty()
			and transaction_id == "r8c-a3:%s:resolution:%s" % [instance_id, resolution_id]
		)
	if operation == "MANQUEE":
		return (
			statut in [MISSED, CANCELLED] and choix_id.is_empty() and resolution_id == "opportunite_manquee"
			and transaction_id == "r8c-a3:%s:missed" % instance_id
		)
	if operation == "ANNULATION":
		return (
			statut == CANCELLED and choix_id.is_empty() and resolution_id.is_empty()
			and transaction_id.begins_with("r8c-a3:%s:annulation:" % instance_id)
			and transaction_id.length() > ("r8c-a3:%s:annulation:" % instance_id).length()
		)
	return false


static func _champs_exacts(valeur: Dictionary, attendus: Array) -> bool:
	if valeur.size() != attendus.size():
		return false
	for champ in attendus:
		if not valeur.has(champ):
			return false
	return true


static func _chaine_non_vide(valeur) -> bool:
	return (
		typeof(valeur) == TYPE_STRING
		and not valeur.strip_edges().is_empty()
		and valeur.length() <= MAX_LONGUEUR_CHAINE
	)


static func _traces_temporaires_valides(
	traces: Dictionary,
	instance_id: String,
	created_at: String,
	last_transition_at: String
) -> bool:
	if traces.size() > MAX_TRACES_TEMPORAIRES:
		return false
	for trace_id in traces:
		if not _chaine_non_vide(trace_id) or typeof(traces[trace_id]) != TYPE_DICTIONARY:
			return false
		var trace: Dictionary = traces[trace_id]
		if not _champs_exacts(trace, CHAMPS_TRACE_TEMPORAIRE):
			return false
		if (
			trace.get("trace_id") != trace_id
			or trace.get("scope") != "TEMPORAIRE"
			or trace.get("source_scene_instance_id") != instance_id
			or not _chaine_non_vide(trace.get("content"))
			or not _chaine_non_vide(trace.get("source_resolution_id"))
			or not _moment_normalise_valide(trace.get("created_at"))
			or not _meme_offset(created_at, trace.get("created_at"))
			or trace.get("created_at") < created_at
			or trace.get("created_at") > last_transition_at
		):
			return false
	return true


static func _moment_normalise_valide(moment) -> bool:
	if typeof(moment) != TYPE_STRING or moment.length() != 25 or not DefinitionModele.moment_valide(moment):
		return false
	if moment.substr(16, 1) != ":" or moment.substr(19, 1) not in ["+", "-"] or moment.substr(22, 1) != ":":
		return false
	var secondes: String = moment.substr(17, 2)
	var heures_offset: String = moment.substr(20, 2)
	var minutes_offset: String = moment.substr(23, 2)
	if not secondes.is_valid_int() or not heures_offset.is_valid_int() or not minutes_offset.is_valid_int():
		return false
	var secondes_nombre := int(secondes)
	var heures_offset_nombre := int(heures_offset)
	var minutes_offset_nombre := int(minutes_offset)
	return (
		secondes_nombre >= 0 and secondes_nombre <= 59
		and heures_offset_nombre >= 0 and heures_offset_nombre <= 14
		and minutes_offset_nombre >= 0 and minutes_offset_nombre <= 59
		and (heures_offset_nombre < 14 or minutes_offset_nombre == 0)
	)


static func _meme_offset(premier: String, second: String) -> bool:
	return premier.substr(19, 6) == second.substr(19, 6)


func _rejet(erreur: String) -> Dictionary:
	return {"ok": false, "erreur": erreur, "statut": obtenir_statut()}
