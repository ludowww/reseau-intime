extends RefCounted

class_name R8CUnifiedPlayerRuntimeCompositionRoot

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const FacadeModel := preload("res://scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
const LibraryModel := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const NarrativeStateModel := preload("res://scripts/narrative_state/EtatNarratif.gd")
const ExecutorV2 := preload(
	"res://scripts/unified_runtime/application/SequenceExecutorV2.gd"
)
const RuntimeSnapshotV2 := preload(
	"res://scripts/unified_runtime/application/UnifiedRuntimeSnapshotV2.gd"
)
const SaveStore := preload(
	"res://scripts/unified_runtime/application/UnifiedPlayerRuntimeSaveStore.gd"
)
const RuntimeSession := preload(
	"res://scripts/unified_runtime/application/UnifiedPlayerRuntimeSession.gd"
)
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)
const ReferencedMessagesResolver := preload(
	"res://scripts/unified_runtime/application/ReferencedMessagesContentResolver.gd"
)
const MessagesPort := preload(
	"res://scripts/unified_runtime/projection/MessagesPhysicalProjectionPort.gd"
)
const MediaPort := preload("res://scripts/unified_runtime/projection/MediaProjectionPort.gd")
const CompositePort := preload(
	"res://scripts/unified_runtime/projection/CompositePlayerProjectionPort.gd"
)
const MessagesAdapter := preload(
	"res://scripts/unified_runtime/application/ReferencedMessagesUIProjectionAdapter.gd"
)
const PhysicalResolver := preload(
	"res://scripts/unified_runtime/projection/PhysicalContentResolver.gd"
)
const PhysicalAdapter := preload(
	"res://scripts/unified_runtime/projection/PhysicalUIProjectionAdapter.gd"
)
const MediaResolver := preload(
	"res://scripts/unified_runtime/projection/AuthoredMediaResolver.gd"
)
const MediaAdapter := preload(
	"res://scripts/unified_runtime/projection/MediaUIProjectionAdapter.gd"
)
const MessagesPhysicalCoordinator := preload(
	"res://scripts/unified_runtime/projection/MessagesPhysicalUIProjectionCoordinator.gd"
)
const UnifiedCoordinator := preload(
	"res://scripts/unified_runtime/projection/UnifiedPlayerProjectionCoordinator.gd"
)
const PhysicalScreenScene := preload(
	"res://scenes/portrait/physical/PhysicalProjectionScreen.tscn"
)

const SEQUENCE_PATH := "res://data/unified_runtime/sequences/mathilde_returns_with_chosen_intent_01.json"
const MESSAGES_PATH := "res://data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_messages.json"
const PHYSICAL_PATH := "res://data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_physical.json"
const MEDIA_PATH := "res://data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_media.json"
const INITIAL_NARRATIVE_TIME := "2032-03-04T21:52:00+01:00"


static func compose(portrait_shell, save_path_override := "") -> Dictionary:
	if portrait_shell == null or portrait_shell.photo_viewer == null:
		return _failure("PORTRAIT_SHELL_NOT_READY")
	var sequence := _load_json(SEQUENCE_PATH)
	var messages_catalog := _load_json(MESSAGES_PATH)
	var physical_catalog := _load_json(PHYSICAL_PATH)
	var media_catalog := _load_json(MEDIA_PATH)
	if not AuthoredValidator.validate(sequence)["valid"]:
		return _failure("INVALID_AUTHORED_SEQUENCE")
	var messages_resolver_result := ReferencedMessagesResolver.create(sequence, messages_catalog)
	var physical_resolver_result := PhysicalResolver.create(sequence, physical_catalog)
	var media_resolver_result := MediaResolver.create(sequence, media_catalog)
	if not messages_resolver_result.get("ok", false):
		return _failure("REFERENCED_MESSAGES_RESOLVER_REFUSED")
	if not physical_resolver_result.get("ok", false):
		return _failure("PHYSICAL_RESOLVER_REFUSED")
	if not media_resolver_result.get("ok", false):
		return _failure("MEDIA_RESOLVER_REFUSED")
	var store_result := SaveStore.create(save_path_override)
	if not store_result.get("ok", false):
		return _failure(str(store_result.get("error_code", "SAVE_STORE_REFUSED")))
	var graph := _new_domain_graph(sequence)
	if graph.is_empty():
		return _failure("A6_A10_GRAPH_REFUSED")
	var messages_port = MessagesPort.new(sequence)
	var media_port = MediaPort.new(sequence)
	var composite_result := CompositePort.create(messages_port, media_port)
	if not composite_result.get("ok", false):
		return _failure("COMPOSITE_PORT_REFUSED")
	var projection_port = composite_result["port"]
	var store = store_result["store"]
	var restored := false
	var narrative_time := INITIAL_NARRATIVE_TIME
	var executor
	var restored_messages_snapshot: Dictionary = {}
	if store.exists():
		var loaded_save: Dictionary = store.load_snapshot()
		if not loaded_save.get("ok", false):
			return _failure(str(loaded_save.get("error_code", "SAVE_LOAD_REFUSED")))
		var snapshot: Dictionary = loaded_save["snapshot"]
		if not RuntimeSnapshotV2.validate(snapshot, sequence)["valid"]:
			return _failure("INVALID_PLAYER_RUNTIME_SAVE")
		var restored_executor := ExecutorV2.restore(
			graph["facade"], projection_port, sequence, snapshot
		)
		if not restored_executor.get("ok", false):
			return _failure(str(restored_executor.get("error_code", "EXECUTOR_RESTORE_REFUSED")))
		executor = restored_executor["executor"]
		restored_messages_snapshot = restored_executor["messages_adapter"]
		narrative_time = restored_executor["narrative_time"]
		restored = true
	else:
		var activation := _activate_sequence(graph["facade"], sequence)
		if not activation.get("ok", false):
			return _failure(str(activation.get("error_code", "A6_ACTIVATION_REFUSED")))
		var created_executor := ExecutorV2.create(
			graph["facade"], projection_port, sequence, activation
		)
		if not created_executor.get("ok", false):
			return _failure(str(created_executor.get("error_code", "EXECUTOR_CREATE_REFUSED")))
		executor = created_executor["executor"]
	var messages_adapter_result := MessagesAdapter.create(
		executor,
		projection_port,
		{
			"presentation_metadata": messages_resolver_result["resolver"].presentation_metadata(),
			"referenced_content_resolver": messages_resolver_result["resolver"],
		},
	)
	if not messages_adapter_result.get("ok", false):
		return _failure("MESSAGES_ADAPTER_REFUSED")
	var messages_adapter = messages_adapter_result["adapter"]
	if restored:
		var messages_restore: Dictionary = messages_adapter.restore(restored_messages_snapshot)
		if not messages_restore.get("ok", false):
			return _failure("MESSAGES_ADAPTER_RESTORE_REFUSED")
	var physical_screen = PhysicalScreenScene.instantiate()
	var physical_adapter_result := PhysicalAdapter.create(
		executor, projection_port, physical_resolver_result["resolver"], physical_screen
	)
	if not physical_adapter_result.get("ok", false):
		return _failure("PHYSICAL_ADAPTER_REFUSED")
	var media_adapter_result := MediaAdapter.create(
		executor,
		projection_port,
		media_resolver_result["resolver"],
		portrait_shell.photo_viewer,
		portrait_shell.PORTRAIT_THEME,
	)
	if not media_adapter_result.get("ok", false):
		return _failure("MEDIA_ADAPTER_REFUSED")
	var messages_physical_result := MessagesPhysicalCoordinator.create(
		messages_adapter, physical_adapter_result["adapter"]
	)
	if not messages_physical_result.get("ok", false):
		return _failure("MESSAGES_PHYSICAL_COORDINATOR_REFUSED")
	var unified_result := UnifiedCoordinator.create(
		messages_physical_result["coordinator"], media_adapter_result["adapter"]
	)
	if not unified_result.get("ok", false):
		return _failure("UNIFIED_COORDINATOR_REFUSED")
	var session_result := RuntimeSession.create({
		"facade": graph["facade"],
		"executor": executor,
		"projection_coordinator": unified_result["coordinator"],
		"messages_adapter": messages_adapter,
		"physical_adapter": physical_adapter_result["adapter"],
		"media_adapter": media_adapter_result["adapter"],
		"media_resolver": media_resolver_result["resolver"],
		"save_store": store,
		"authored_sequence": sequence,
		"resolution_context": _resolution_context(sequence),
		"narrative_time": narrative_time,
		"restored": restored,
	})
	if not session_result.get("ok", false):
		return _failure(str(session_result.get("error_code", "SESSION_REFUSED")))
	return {
		"ok": true,
		"error_code": null,
		"session": session_result["session"],
		"sequence": sequence.duplicate(true),
		"restored": restored,
	}


static func _new_domain_graph(sequence: Dictionary) -> Dictionary:
	var entry: Dictionary = sequence["orchestration"]["a6_entry"]
	var loaded := LibraryModel.charger_depuis_bundle({
		"format": "R8C_A6_SCENE_LIBRARY",
		"version": 1,
		"definitions": [entry.duplicate(true)],
	})
	if not loaded.get("ok", false):
		return {}
	var state = NarrativeStateModel.creer_synthetique({
		"statut_couple": "EN_CLARIFICATION",
		"contrat_couple": null,
		"etat_divulgation": "PARTIEL",
		"etat_foyer": null,
		"relation_apres_separation": null,
		"dernier_evenement_majeur_id": null,
		"faits": [],
		"cadre_provisoire": null,
	})
	var facade = FacadeModel.create(loaded["bibliotheque"], state)
	return {"facade": facade} if facade != null else {}


static func _activate_sequence(facade, sequence: Dictionary) -> Dictionary:
	var context := _activation_context(sequence)
	var candidates: Dictionary = facade.find_candidates(context)
	if not candidates.get("ok", false) or candidates.get("candidats", []).size() != 1:
		return {"ok": false, "error_code": "A6_CANDIDATE_NOT_UNIQUE"}
	var candidate: Dictionary = candidates["candidats"][0]
	var temporal: Dictionary = sequence["temporal_projection"]["resolved_window"]
	var composition: Dictionary = facade.compose_slot({
		"slot_id": sequence["orchestration"]["a9_slot"]["slot_role"],
		"narrative_date": str(temporal["opens_at"]).substr(0, 10),
		"starts_at": temporal["opens_at"],
		"ends_at": temporal["closes_at"],
		"context": context,
		"window": {
			"window_id": sequence["orchestration"]["a8_window"]["window_id"],
			"opens_at": temporal["opens_at"],
			"closes_at": temporal["closes_at"],
			"duration_minutes": sequence["orchestration"]["a9_slot"]["duration_minutes"],
			"not_before": temporal["opens_at"],
			"not_after": temporal["closes_at"],
			"options": [
				{
					"option_id": "primary_option",
					"candidate": candidate.duplicate(true),
					"instance_id": "unified_player_" + sequence["sequence_id"],
					"conflict_policy": sequence["orchestration"]["a8_window"]["conflict_policy"],
				},
				{
					"option_id": "alternative_option",
					"candidate": candidate.duplicate(true),
					"instance_id": "unified_player_alternative_" + sequence["sequence_id"],
					"conflict_policy": sequence["orchestration"]["a8_window"]["conflict_policy"],
				},
			],
		},
	})
	if not composition.get("ok", false):
		return {
			"ok": false,
			"error_code": "A9_COMPOSITION_REFUSED:%s"
			% str(composition.get("erreur", composition.get("error_code", "UNKNOWN"))),
		}
	return facade.activate_option(
		composition["plan"],
		"primary_option",
		{"intention": "PROPOSE", "context": context},
	)


static func _resolution_context(sequence: Dictionary) -> Dictionary:
	var definition: Dictionary = sequence["orchestration"]["a6_entry"]["definition"]
	var participants := {}
	for participant_id in sequence["participants"]["present_character_ids"]:
		participants[participant_id] = true
	return {
		"acte_courant": definition["conditions_dures"]["actes_compatibles"][0],
		"moment_diegetique": INITIAL_NARRATIVE_TIME,
		"participants_disponibles": participants,
		"opportunite_valide": true,
	}


static func _activation_context(sequence: Dictionary) -> Dictionary:
	var context := _resolution_context(sequence)
	context["moment_diegetique"] = sequence["temporal_projection"]["resolved_window"]["opens_at"]
	return context


static func _load_json(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return JsonNormalizer.normalize(parsed) if typeof(parsed) == TYPE_DICTIONARY else {}


static func _failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "session": null, "sequence": {}, "restored": false}
