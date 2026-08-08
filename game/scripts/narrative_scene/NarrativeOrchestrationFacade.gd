extends RefCounted

class_name R8CNarrativeOrchestrationFacade

const MoteurModele := preload("res://scripts/narrative_scene/MinimalSceneEngine.gd")
const CoordinateurA7Modele := preload(
	"res://scripts/narrative_scene/CandidateReservationProposalCoordinator.gd"
)
const CoordinateurA8Modele := preload(
	"res://scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd"
)
const CoordinateurA9Modele := preload(
	"res://scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd"
)
const CoordinateurResolutionModele := preload(
	"res://scripts/narrative_scene/SequenceResolutionCommitCoordinator.gd"
)

var _bibliotheque
var _moteur
var _etat_narratif
var _coordinateur_a8
var _coordinateur_a9
var _coordinateur_resolution
var _reprises_activation: Dictionary = {}


static func create(bibliotheque, etat_narratif):
	if (
		bibliotheque == null
		or typeof(bibliotheque) != TYPE_OBJECT
		or not bibliotheque.has_method("query_candidates")
		or not bibliotheque.has_method("obtenir_definition")
		or etat_narratif == null
		or typeof(etat_narratif) != TYPE_OBJECT
		or not etat_narratif.has_method("obtenir_snapshot")
	):
		return null
	var facade := new()
	facade._bibliotheque = bibliotheque
	if not facade._installer_dependances(MoteurModele.new(), etat_narratif):
		return null
	return facade


func find_candidates(context: Dictionary) -> Dictionary:
	var requete: Dictionary = _bibliotheque.query_candidates(
		_moteur,
		_etat_narratif,
		context,
	)
	if not requete.get("ok", false):
		return {"ok": false, "erreur": requete.get("erreur", "RECHERCHE_REFUSEE"), "candidats": []}
	var candidats: Array = []
	for candidat in requete["candidats"]:
		candidats.append({
			"scene_definition_id": candidat["scene_definition_id"],
			"variant_id": candidat["variant_id"],
		})
	return {"ok": true, "erreur": "", "candidats": candidats}


func compose_slot(slot_request) -> Dictionary:
	if typeof(slot_request) != TYPE_DICTIONARY:
		return _echec_composition()
	var window_request = slot_request.get("window")
	var context = slot_request.get("context")
	if typeof(window_request) != TYPE_DICTIONARY or typeof(context) != TYPE_DICTIONARY:
		return _echec_composition()
	var window_specification := {
		"window_id": window_request.get("window_id"),
		"opens_at": window_request.get("opens_at"),
		"closes_at": window_request.get("closes_at"),
		"context": _contexte_stable(context),
		"options": _options_a8(window_request.get("options")),
	}
	var ouverture: Dictionary = _coordinateur_a8.ouvrir_fenetre(
		window_specification,
		_etat_narratif,
		context,
	)
	if not ouverture.get("ok", false):
		return _echec_composition()
	var window_id = window_request.get("window_id")
	var specification_a9 := {
		"slot_id": slot_request.get("slot_id"),
		"narrative_date": slot_request.get("narrative_date"),
		"starts_at": slot_request.get("starts_at"),
		"ends_at": slot_request.get("ends_at"),
		"context": context.duplicate(true),
		"windows": [{
			"window_id": window_id,
			"duration_minutes": window_request.get("duration_minutes"),
			"not_before": window_request.get("not_before"),
			"not_after": window_request.get("not_after"),
		}],
		"author_order": [window_id],
	}
	var composition: Dictionary = _coordinateur_a9.composer(specification_a9, _etat_narratif)
	if not composition.get("ok", false):
		if not ouverture.get("idempotent", false):
			_coordinateur_a8.abandonner_fenetre_non_materialisee(window_id)
		return _echec_composition()
	return {
		"ok": true,
		"erreur": "",
		"plan": composition["plan"].duplicate(true),
		"window": ouverture["window"].duplicate(true),
	}


func activate_option(plan, option_id: String, action) -> Dictionary:
	if typeof(plan) != TYPE_DICTIONARY or typeof(action) != TYPE_DICTIONARY:
		return _echec_activation()
	var fingerprint = plan.get("fingerprint")
	if typeof(fingerprint) == TYPE_STRING and _reprises_activation.has(fingerprint):
		var reprise: Dictionary = _reprises_activation[fingerprint]
		if (
			reprise["plan"] == plan
			and reprise["option_id"] == option_id
			and reprise["action"] == action
		):
			return _resultat_activation(plan, option_id, true)
		return _echec_activation()
	var context = action.get("context")
	var intention = action.get("intention")
	if (
		typeof(context) != TYPE_DICTIONARY
		or typeof(intention) != TYPE_STRING
		or intention != CoordinateurA7Modele.PROPOSE
	):
		return _echec_activation()
	var revalidation: Dictionary = _coordinateur_a9.revalider_plan(
		plan,
		_etat_narratif,
		context,
	)
	if not revalidation.get("ok", false):
		return _echec_activation()
	var windows = plan.get("windows")
	if typeof(windows) != TYPE_ARRAY or windows.size() != 1:
		return _echec_activation()
	var window_id = windows[0].get("window_id")
	if typeof(window_id) != TYPE_STRING:
		return _echec_activation()
	var activation: Dictionary = _coordinateur_a8.agir_sur_option(
		window_id,
		option_id,
		_etat_narratif,
		context,
		intention,
	)
	if not activation.get("ok", false):
		return _echec_activation()
	var fermeture: Dictionary = _coordinateur_a8.fermer_conflit_exclusif(
		window_id,
		option_id,
		_etat_narratif,
		context,
	)
	if not fermeture.get("ok", false):
		return _echec_activation()
	_reprises_activation[fingerprint] = {
		"plan": plan.duplicate(true),
		"option_id": option_id,
		"action": action.duplicate(true),
	}
	return _resultat_activation(plan, option_id, false)


func resolve_scene(
	instance_id: String,
	choice_id: String,
	resolution_id: String,
	context: Dictionary
) -> Dictionary:
	var instance = _moteur.obtenir_instance(instance_id)
	if instance == null:
		return _echec_resolution(instance_id)
	var definition: Dictionary = _bibliotheque.obtenir_definition(
		instance.obtenir_scene_definition_id()
	)
	if definition.is_empty():
		return _echec_resolution(instance_id)
	if context.has("sequence_resolution"):
		var resolution_sequence: Dictionary = _coordinateur_resolution.resolve(
			_moteur,
			_etat_narratif,
			instance,
			definition,
			choice_id,
			resolution_id,
			context,
		)
		return {
			"ok": resolution_sequence["ok"],
			"erreur": resolution_sequence["erreur"],
			"instance_id": instance_id,
			"state": resolution_sequence["state"],
			"transaction_status": resolution_sequence["transaction_status"],
			"idempotent": resolution_sequence["idempotent"],
			"statut": resolution_sequence["statut"],
		}
	var contexte_resolution: Dictionary = context.duplicate(true)
	contexte_resolution["instance_id"] = instance_id
	var resolution: Dictionary = _moteur.resoudre(
		instance,
		definition,
		choice_id,
		resolution_id,
		_etat_narratif,
		contexte_resolution,
	)
	var transaction_status: String = resolution.get("transaction", {}).get("statut", "")
	return {
		"ok": resolution.get("ok", false),
		"erreur": resolution.get("erreur", "RESOLUTION_REFUSEE"),
		"instance_id": instance_id,
		"state": instance.obtenir_statut(),
		"transaction_status": transaction_status,
		"idempotent": transaction_status == "IDEMPOTENT",
	}


func _prepare_automatic_scene_completion_internal(
	instance_id: String,
	sequence_id: String,
	terminal_beat_id: String,
	moment_diegetique: String
) -> Dictionary:
	return _moteur.preparer_completion_automatique(
		instance_id, sequence_id, terminal_beat_id, moment_diegetique
	)


func _publish_automatic_scene_completion_internal(preparation: Dictionary) -> Dictionary:
	return _moteur._publier_completion_automatique_preparee(preparation)


func save_state() -> Dictionary:
	return _moteur.obtenir_snapshot(_etat_narratif)


func restore_state(snapshot) -> Dictionary:
	var restauration: Dictionary = MoteurModele.creer_depuis_snapshot(snapshot)
	if not restauration.get("ok", false):
		return {"ok": false, "erreur": "RESTAURATION_REFUSEE"}
	if not _installer_dependances(restauration["moteur"], restauration["etat_narratif"]):
		return {"ok": false, "erreur": "RESTAURATION_REFUSEE"}
	_reprises_activation.clear()
	return {"ok": true, "erreur": ""}


func _installer_dependances(moteur, etat_narratif) -> bool:
	var coordinateur_a7 = CoordinateurA7Modele.creer(_bibliotheque, moteur)
	var coordinateur_a8 = CoordinateurA8Modele.creer(_bibliotheque, moteur, coordinateur_a7)
	var coordinateur_a9 = CoordinateurA9Modele.creer(coordinateur_a8)
	var coordinateur_resolution = CoordinateurResolutionModele.new()
	if coordinateur_a7 == null or coordinateur_a8 == null or coordinateur_a9 == null:
		return false
	_moteur = moteur
	_etat_narratif = etat_narratif
	_coordinateur_a8 = coordinateur_a8
	_coordinateur_a9 = coordinateur_a9
	_coordinateur_resolution = coordinateur_resolution
	return true


static func _contexte_stable(context: Dictionary) -> Dictionary:
	return {
		"acte_courant": context.get("acte_courant"),
		"participants_disponibles": _copie_si_collection(
			context.get("participants_disponibles")
		),
		"opportunite_valide": context.get("opportunite_valide"),
	}


static func _options_a8(options_request):
	if typeof(options_request) != TYPE_ARRAY:
		return options_request
	var options: Array = []
	for option_request in options_request:
		if typeof(option_request) != TYPE_DICTIONARY:
			options.append(option_request)
			continue
		var candidat = option_request.get("candidate")
		if typeof(candidat) != TYPE_DICTIONARY:
			candidat = {}
		options.append({
			"option_id": option_request.get("option_id"),
			"scene_definition_id": candidat.get("scene_definition_id"),
			"variant_id": candidat.get("variant_id"),
			"instance_id": option_request.get("instance_id"),
			"conflict_policy": option_request.get("conflict_policy"),
		})
	return options


static func _copie_si_collection(value):
	if typeof(value) in [TYPE_ARRAY, TYPE_DICTIONARY]:
		return value.duplicate(true)
	return value


func _resultat_activation(plan: Dictionary, option_id: String, idempotent: bool) -> Dictionary:
	var windows = plan.get("windows", [])
	if windows.size() != 1:
		return _echec_activation()
	var window_id: String = windows[0].get("window_id", "")
	var window: Dictionary = _coordinateur_a8.obtenir_fenetre(window_id)
	if (
		window.get("state") != CoordinateurA8Modele.CLOSED
		or window.get("selected_option_id") != option_id
	):
		return _echec_activation()
	for option in window.get("options", []):
		if option.get("option_id") != option_id:
			continue
		var instance = _moteur.obtenir_instance(option.get("instance_id", ""))
		if instance == null or not option.get("materialized", false):
			return _echec_activation()
		return {
			"ok": true,
			"erreur": "",
			"slot_id": plan.get("slot_id", ""),
			"window_id": window_id,
			"option_id": option_id,
			"instance_id": option["instance_id"],
			"activation_state": option["state"],
			"scene_state": instance.obtenir_statut(),
			"window": window.duplicate(true),
			"idempotent": idempotent,
		}
	return _echec_activation()


static func _echec_composition() -> Dictionary:
	return {"ok": false, "erreur": "COMPOSITION_REFUSEE", "plan": {}, "window": {}}


static func _echec_activation() -> Dictionary:
	return {"ok": false, "erreur": "ACTIVATION_REFUSEE", "idempotent": false}


static func _echec_resolution(instance_id: String) -> Dictionary:
	return {
		"ok": false,
		"erreur": "RESOLUTION_REFUSEE",
		"instance_id": instance_id,
		"state": "",
		"transaction_status": "",
		"idempotent": false,
	}
