extends RefCounted

class_name R8CSequenceResolutionCommitCoordinator

const Codec := preload("res://scripts/narrative_scene/A5NarrativeStateCodec.gd")
const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")
const InstanceModele := preload("res://scripts/narrative_scene/SceneInstance.gd")
const Reducer := preload("res://scripts/narrative_state/ReducerResolutionSequence.gd")
const ResolutionEvent := preload("res://scripts/narrative_state/SequenceResolutionEventV1.gd")

const ENVELOPE_FIELDS := [
	"instance_id",
	"sequence_id",
	"authored_version",
	"choice_id",
	"resolution_id",
	"a10_choice_id",
	"a10_resolution_id",
	"terminal_checkpoint_id",
	"event_keys",
]
const RECEIPT_FIELDS := [
	"operation",
	"transaction_id",
	"event_id",
	"choice_id",
	"resolution_id",
	"a10_choice_id",
	"a10_resolution_id",
	"sequence_id",
	"authored_version",
	"authored_resolution_id",
	"terminal_checkpoint_id",
	"event_keys",
]
const ERROR_TERMINAL_DIFFERENT := "RESOLUTION_TERMINALE_DIFFERENTE"
const ERROR_PERSISTED_INCONSISTENT := "TERMINAISON_PERSISTEE_INCOHERENTE"
const ERROR_ATOMIC_PUBLICATION := "N14_1_BLOCKED_ATOMIC_PUBLICATION"

var _publication_en_cours := false


func resolve(
	moteur,
	etat_narratif,
	instance,
	definition: Dictionary,
	choice_id: String,
	resolution_id: String,
	context: Dictionary
) -> Dictionary:
	if _publication_en_cours:
		return _failure(instance, ERROR_ATOMIC_PUBLICATION)
	var prepared := _prepare_expected(
		instance, definition, choice_id, resolution_id, context
	)
	if not prepared["ok"]:
		return _failure(instance, prepared["erreur"])
	var expected_event: Dictionary = prepared["event"]
	var expected_receipt: Dictionary = prepared["receipt"]
	var event_id: String = expected_event["event_id"]
	var state_snapshot: Dictionary = etat_narratif.obtenir_snapshot()
	var existing_event = state_snapshot["evenements"].get(event_id)
	var existing_receipt: Dictionary = instance.obtenir_recu_resolution()

	if instance.obtenir_statut() == InstanceModele.RESOLVED:
		if existing_receipt.is_empty() or not _exact(existing_receipt, RECEIPT_FIELDS):
			return _failure(instance, ERROR_PERSISTED_INCONSISTENT)
		if not ResolutionEvent.structures_identical(existing_receipt, expected_receipt):
			return _failure(instance, ERROR_TERMINAL_DIFFERENT)
		if (
			typeof(existing_event) != TYPE_DICTIONARY
			or not ResolutionEvent.structures_identical(existing_event, expected_event)
		):
			return _failure(instance, ERROR_PERSISTED_INCONSISTENT)
		return _success(instance, "IDEMPOTENT")

	if not existing_receipt.is_empty():
		return _failure(instance, ERROR_PERSISTED_INCONSISTENT)
	if typeof(existing_event) == TYPE_DICTIONARY:
		if ResolutionEvent.structures_identical(existing_event, expected_event):
			return _failure(instance, ERROR_PERSISTED_INCONSISTENT)
		return _failure(instance, "RESOLUTION_REFUSEE")
	if instance.obtenir_statut() != InstanceModele.PROPOSED:
		return _failure(instance, "INSTANCE_NON_PROPOSEE")

	var reduction: Dictionary = Reducer.preparer(
		state_snapshot,
		expected_event["payload"],
		expected_event["provenance"],
	)
	if not reduction["ok"]:
		return _failure(instance, "RESOLUTION_REFUSEE")
	var candidate_a1: Dictionary = reduction["candidat"]
	if candidate_a1["evenements"].has(event_id):
		return _failure(instance, "RESOLUTION_REFUSEE")
	candidate_a1["evenements"][event_id] = expected_event.duplicate(true)
	if not Codec.valider(candidate_a1):
		return _failure(instance, "RESOLUTION_REFUSEE")

	var candidate_a5: Dictionary = moteur.preparer_registre_resolution_sequence(
		instance.obtenir_instance_id(),
		prepared["moment_diegetique"],
		expected_receipt,
	)
	if not candidate_a5["ok"]:
		return _failure(instance, "RESOLUTION_REFUSEE")

	_publish(etat_narratif, candidate_a1, moteur, candidate_a5["registre"])
	return _success(moteur.obtenir_instance(prepared["instance_id"]), "APPLIQUE")


func _prepare_expected(
	instance,
	definition: Dictionary,
	choice_id: String,
	resolution_id: String,
	context: Dictionary
) -> Dictionary:
	if instance == null or typeof(context) != TYPE_DICTIONARY:
		return _preparation_failure("RESOLUTION_REFUSEE")
	var envelope = context.get("sequence_resolution")
	if typeof(envelope) != TYPE_DICTIONARY or not _exact(envelope, ENVELOPE_FIELDS):
		return _preparation_failure("RESOLUTION_REFUSEE")
	var instance_snapshot: Dictionary = instance.obtenir_snapshot()
	if (
		envelope["instance_id"] != instance.obtenir_instance_id()
		or instance_snapshot.get("scene_id") != definition.get("scene_id")
		or instance_snapshot.get("version_contrat") != definition.get("version_contrat")
		or envelope["a10_choice_id"] != choice_id
		or envelope["a10_resolution_id"] != resolution_id
	):
		return _preparation_failure("RESOLUTION_REFUSEE")
	if not DefinitionModele.valider(definition).is_empty():
		return _preparation_failure("RESOLUTION_REFUSEE")
	var choice := _find_choice(definition, choice_id)
	if choice.is_empty() or resolution_id not in choice["resolution_ids"]:
		return _preparation_failure("RESOLUTION_REFUSEE")
	var resolution = definition["resolutions"].get(resolution_id)
	if typeof(resolution) != TYPE_DICTIONARY or resolution.get("portee_micro_signal") != "DURABLE":
		return _preparation_failure("RESOLUTION_REFUSEE")
	var manifest = resolution.get("durable_manifest")
	if typeof(manifest) != TYPE_DICTIONARY:
		return _preparation_failure("RESOLUTION_REFUSEE")
	var binding = manifest.get("binding")
	if (
		typeof(binding) != TYPE_DICTIONARY
		or not _exact(binding, ["sequence_id", "authored_version", "resolution_id"])
		or binding["sequence_id"] != envelope["sequence_id"]
		or binding["authored_version"] != envelope["authored_version"]
		or binding["resolution_id"] != envelope["resolution_id"]
	):
		return _preparation_failure("RESOLUTION_REFUSEE")
	for field in ENVELOPE_FIELDS.slice(0, 8):
		if not _valid_string(envelope[field]):
			return _preparation_failure("RESOLUTION_REFUSEE")
	var expected_event_keys := _manifest_event_keys(manifest)
	if envelope["event_keys"] != expected_event_keys:
		return _preparation_failure("RESOLUTION_REFUSEE")
	var moment = context.get("moment_diegetique")
	if not DefinitionModele.moment_normalise_valide(moment):
		return _preparation_failure("RESOLUTION_REFUSEE")
	var event := ResolutionEvent.build(instance_snapshot, definition, envelope, moment)
	if event.is_empty() or ResolutionEvent.event_keys(event) != envelope["event_keys"]:
		return _preparation_failure("RESOLUTION_REFUSEE")
	var receipt := {
		"operation": "RESOLVE_SCENE",
		"transaction_id": event["event_id"],
		"event_id": event["event_id"],
		"choice_id": envelope["choice_id"],
		"resolution_id": resolution_id,
		"a10_choice_id": envelope["a10_choice_id"],
		"a10_resolution_id": envelope["a10_resolution_id"],
		"sequence_id": binding["sequence_id"],
		"authored_version": binding["authored_version"],
		"authored_resolution_id": binding["resolution_id"],
		"terminal_checkpoint_id": envelope["terminal_checkpoint_id"],
		"event_keys": envelope["event_keys"].duplicate(true),
	}
	return {
		"ok": true,
		"erreur": "",
		"instance_id": instance.obtenir_instance_id(),
		"moment_diegetique": moment,
		"event": event,
		"receipt": receipt,
	}


func _publish(etat_narratif, candidate_a1: Dictionary, moteur, candidate_a5) -> void:
	_publication_en_cours = true
	etat_narratif._publier_candidat_prepare(candidate_a1)
	moteur._publier_registre_prepare(candidate_a5)
	_publication_en_cours = false


static func _manifest_event_keys(manifest: Dictionary) -> Array:
	var event_keys: Array = []
	for category in ResolutionEvent.PAYLOAD_FIELDS:
		for effect in manifest[category]:
			event_keys.append(effect["event_key"])
	return event_keys


static func _find_choice(definition: Dictionary, choice_id: String) -> Dictionary:
	for choice in definition.get("choix", []):
		if choice.get("choix_id") == choice_id:
			return choice
	return {}


static func _exact(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _valid_string(value) -> bool:
	return typeof(value) == TYPE_STRING and not value.is_empty() and value == value.strip_edges()


static func _preparation_failure(error: String) -> Dictionary:
	return {"ok": false, "erreur": error, "event": {}, "receipt": {}}


static func _failure(instance, error: String) -> Dictionary:
	return {
		"ok": false,
		"erreur": error,
		"statut": "REJETE",
		"state": instance.obtenir_statut() if instance != null else "",
		"transaction_status": "REJETE",
		"idempotent": false,
	}


static func _success(instance, transaction_status: String) -> Dictionary:
	return {
		"ok": true,
		"erreur": "",
		"statut": "IDEMPOTENT" if transaction_status == "IDEMPOTENT" else "RESOLVED",
		"state": instance.obtenir_statut(),
		"transaction_status": transaction_status,
		"idempotent": transaction_status == "IDEMPOTENT",
	}
