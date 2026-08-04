extends RefCounted

class_name R8CCandidateReservationProposalCoordinator

const InstanceModele := preload("res://scripts/narrative_scene/SceneInstance.gd")

const RESERVE := "RESERVE"
const PROPOSE := "PROPOSE"
const INTENTIONS := [RESERVE, PROPOSE]

var _bibliotheque
var _moteur


static func creer(bibliotheque, moteur):
	if (
		bibliotheque == null
		or typeof(bibliotheque) != TYPE_OBJECT
		or not bibliotheque.has_method("verifier_candidat_action")
		or moteur == null
		or typeof(moteur) != TYPE_OBJECT
		or not moteur.has_method("evaluer_definition")
		or not moteur.has_method("creer_instance")
		or not moteur.has_method("creer_instance_proposee_apres_revalidation")
		or not moteur.has_method("obtenir_instance")
	):
		return null
	var coordinateur := new()
	coordinateur._bibliotheque = bibliotheque
	coordinateur._moteur = moteur
	return coordinateur


func executer(candidat, etat_narratif, contexte: Dictionary, intention: String) -> Dictionary:
	return _executer(candidat, etat_narratif, contexte, intention, false)


func executer_dev(candidat, etat_narratif, contexte: Dictionary, intention: String) -> Dictionary:
	if not _diagnostics_detailles_autorises():
		return {"ok": false, "erreur": "DIAGNOSTICS_INDISPONIBLES"}
	return _executer(candidat, etat_narratif, contexte, intention, true)


func _executer(
	candidat,
	etat_narratif,
	contexte: Dictionary,
	intention: String,
	inclure_diagnostics: bool
) -> Dictionary:
	if intention not in INTENTIONS:
		return _echec("INTENTION_INVALIDE", {}, inclure_diagnostics)
	if (
		etat_narratif == null
		or typeof(etat_narratif) != TYPE_OBJECT
		or not etat_narratif.has_method("obtenir_snapshot")
	):
		return _echec("ETAT_NARRATIF_ABSENT", {}, inclure_diagnostics)
	var verification: Dictionary = _bibliotheque.verifier_candidat_action(candidat, contexte)
	if not verification["ok"]:
		return _echec(verification["erreur"], {}, inclure_diagnostics)
	var definition: Dictionary = verification["definition"]
	var diagnostic: Dictionary = _moteur.evaluer_definition(definition, etat_narratif, contexte)
	if not diagnostic.get("eligible", false):
		return _echec("REVALIDATION_INELIGIBLE", diagnostic, inclure_diagnostics)

	var instance_id = contexte.get("instance_id")
	if typeof(instance_id) != TYPE_STRING or instance_id.strip_edges().is_empty():
		return _echec("INSTANCE_ID_INVALIDE", diagnostic, inclure_diagnostics)
	var existante = _moteur.obtenir_instance(instance_id)
	if existante != null:
		var statut_attendu := InstanceModele.ELIGIBLE if intention == RESERVE else InstanceModele.PROPOSED
		if (
			existante.obtenir_scene_definition_id() == verification["scene_definition_id"]
			and existante.obtenir_statut() == statut_attendu
		):
			return _succes(verification, existante, intention, true, diagnostic, inclure_diagnostics)
		return _echec("INSTANCE_ID_DEJA_UTILISE", diagnostic, inclure_diagnostics)

	var instance
	if intention == RESERVE:
		instance = _moteur.creer_instance(definition, diagnostic, contexte)
	else:
		instance = _moteur.creer_instance_proposee_apres_revalidation(
			definition, diagnostic, contexte
		)
	if instance == null:
		return _echec(
			_moteur.obtenir_derniere_erreur_instance(), diagnostic, inclure_diagnostics
		)
	return _succes(verification, instance, intention, false, diagnostic, inclure_diagnostics)


func _succes(
	verification: Dictionary,
	instance,
	intention: String,
	idempotente: bool,
	diagnostic: Dictionary,
	inclure_diagnostics: bool
) -> Dictionary:
	var resultat := {
		"ok": true,
		"erreur": "",
		"scene_definition_id": verification["scene_definition_id"],
		"variant_id": verification["variant_id"],
		"instance_id": instance.obtenir_instance_id(),
		"intention": intention,
		"state": instance.obtenir_statut(),
		"idempotent": idempotente,
	}
	if inclure_diagnostics:
		resultat["diagnostic"] = {
			"code": "ACTION_CANDIDAT_ACCEPTEE",
			"revalidation_a3": diagnostic.duplicate(true),
		}
	return resultat


func _echec(code: String, diagnostic: Dictionary, inclure_diagnostics: bool) -> Dictionary:
	var resultat := {"ok": false, "erreur": "ACTION_CANDIDAT_REFUSEE"}
	if inclure_diagnostics:
		resultat["diagnostic"] = {
			"code": code if not code.is_empty() else "MATERIALISATION_REFUSEE",
			"revalidation_a3": diagnostic.duplicate(true),
		}
	return resultat


static func _diagnostics_detailles_autorises() -> bool:
	return OS.is_debug_build() or Engine.is_editor_hint()
