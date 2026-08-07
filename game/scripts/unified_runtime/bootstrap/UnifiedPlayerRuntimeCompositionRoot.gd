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
const CatalogLoader := preload(
	"res://scripts/unified_runtime/application/AuthoredSequenceCatalogLoader.gd"
)
const PersistentMessages := preload(
	"res://scripts/unified_runtime/application/PersistentMessagesStateV1.gd"
)
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)
const Moment := preload("res://scripts/unified_runtime/application/NarrativeMoment.gd")
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

const PRODUCTION_CATALOG_PATH := "res://data/unified_runtime/catalogs/season_1_v1.json"


static func compose(portrait_shell, save_path_override := "") -> Dictionary:
	var loaded := CatalogLoader.load_catalog(PRODUCTION_CATALOG_PATH, "season_1_v1", "season_1")
	if not loaded["ok"]:
		return _failure(str(loaded["error_code"]))
	var catalog: Dictionary = loaded["catalog"]
	var store_result := SaveStore.create(save_path_override)
	if not store_result.get("ok", false):
		return _failure(str(store_result.get("error_code", "SAVE_STORE_REFUSED")))
	var graph := _new_catalog_domain_graph(catalog)
	if graph.is_empty():
		return _failure("A6_A10_GRAPH_REFUSED")
	var store = store_result["store"]
	var runtime_snapshot = null
	if store.exists():
		var loaded_save: Dictionary = store.load_snapshot()
		if not loaded_save.get("ok", false):
			return _failure(str(loaded_save.get("error_code", "SAVE_LOAD_REFUSED")))
		runtime_snapshot = loaded_save["snapshot"]
	var package: Dictionary = catalog["packages"][0]
	var persistent := PersistentMessages.empty(catalog["messages_metadata"])
	return compose_package(
		package, portrait_shell, graph["facade"], store, runtime_snapshot,
		persistent, catalog["messages_metadata"], catalog["media_resolver"]
	)


static func compose_package(
	package: Dictionary,
	portrait_shell,
	facade,
	save_store,
	runtime_snapshot = null,
	persistent_messages_state: Dictionary = {},
	catalog_messages_metadata: Dictionary = {},
	catalog_media_resolver = null,
	activation_receipt = null,
) -> Dictionary:
	if portrait_shell == null or portrait_shell.photo_viewer == null:
		return _failure("PORTRAIT_SHELL_NOT_READY")
	if facade == null or save_store == null or typeof(package) != TYPE_DICTIONARY:
		return _failure("INVALID_PACKAGE_COMPOSITION_DEPENDENCY")
	var sequence: Dictionary = package.get("sequence", {})
	if not AuthoredValidator.validate(sequence, true)["valid"]:
		return _failure("INVALID_AUTHORED_SEQUENCE")
	var initial_narrative_time := _initial_narrative_time(sequence)
	if not Moment.validate(initial_narrative_time):
		return _failure("INVALID_INITIAL_NARRATIVE_TIME")
	var messages_resolver = package.get("messages_resolver")
	var physical_resolver = package.get("physical_resolver")
	var media_resolver = package.get("media_resolver")
	if messages_resolver == null or physical_resolver == null or media_resolver == null:
		return _failure("PACKAGE_RESOLVER_REFUSED")
	var messages_port = MessagesPort.new(sequence, true)
	var media_port = MediaPort.new(sequence, true)
	var composite_result := CompositePort.create(messages_port, media_port)
	if not composite_result.get("ok", false):
		return _failure("COMPOSITE_PORT_REFUSED")
	var projection_port = composite_result["port"]
	var restored := runtime_snapshot != null
	var narrative_time := initial_narrative_time
	var executor
	var restored_messages_snapshot: Dictionary = {}
	if restored:
		if typeof(runtime_snapshot) != TYPE_DICTIONARY or not RuntimeSnapshotV2.validate(runtime_snapshot, sequence)["valid"]:
			return _failure("INVALID_PLAYER_RUNTIME_SAVE")
		var restored_executor := ExecutorV2.restore(
			facade, projection_port, sequence, runtime_snapshot
		)
		if not restored_executor.get("ok", false):
			return _failure(str(restored_executor.get("error_code", "EXECUTOR_RESTORE_REFUSED")))
		executor = restored_executor["executor"]
		restored_messages_snapshot = restored_executor["messages_adapter"]
		narrative_time = restored_executor["narrative_time"]
	else:
		var activation = activation_receipt
		if activation == null:
			activation = _activate_sequence(facade, sequence)
		if typeof(activation) != TYPE_DICTIONARY:
			return _failure("INVALID_ACTIVATION_RECEIPT")
		if not activation.get("ok", false):
			return _failure(str(activation.get("error_code", "A6_ACTIVATION_REFUSED")))
		var created_executor := ExecutorV2.create(facade, projection_port, sequence, activation)
		if not created_executor.get("ok", false):
			return _failure(str(created_executor.get("error_code", "EXECUTOR_CREATE_REFUSED")))
		executor = created_executor["executor"]
	var messages_adapter_result := MessagesAdapter.create(
		executor,
		projection_port,
		{
			"presentation_metadata": messages_resolver.presentation_metadata(),
			"referenced_content_resolver": messages_resolver,
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
		executor, projection_port, physical_resolver, physical_screen
	)
	if not physical_adapter_result.get("ok", false):
		return _failure("PHYSICAL_ADAPTER_REFUSED")
	var media_adapter_result := MediaAdapter.create(
		executor,
		projection_port,
		media_resolver,
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
		"facade": facade,
		"executor": executor,
		"projection_coordinator": unified_result["coordinator"],
		"messages_adapter": messages_adapter,
		"physical_adapter": physical_adapter_result["adapter"],
		"media_adapter": media_adapter_result["adapter"],
		"media_resolver": media_resolver,
		"gallery_media_resolver": (
			catalog_media_resolver if catalog_media_resolver != null else media_resolver
		),
		"save_store": save_store,
		"authored_sequence": sequence,
		"resolution_context": _resolution_context(sequence, narrative_time),
		"narrative_time": narrative_time,
		"restored": restored,
		"persistent_messages_state": persistent_messages_state,
		"catalog_messages_metadata": catalog_messages_metadata,
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
	return _new_domain_graph_from_library(loaded["bibliotheque"])


static func _new_catalog_domain_graph(catalog: Dictionary) -> Dictionary:
	if catalog.get("library") == null:
		return {}
	return _new_domain_graph_from_library(catalog["library"])


static func _new_domain_graph_from_library(library) -> Dictionary:
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
	var facade = FacadeModel.create(library, state)
	return {"facade": facade} if facade != null else {}


static func prepare_sequence(facade, sequence: Dictionary) -> Dictionary:
	if facade == null or not facade.has_method("find_candidates") or not facade.has_method("compose_slot"):
		return _preparation_failure("INVALID_PREPARATION_DEPENDENCY")
	var context := _activation_context(sequence)
	var candidates: Dictionary = facade.find_candidates(context)
	if not candidates.get("ok", false):
		return _preparation_failure("A6_CANDIDATE_QUERY_REFUSED")
	var entry: Dictionary = sequence["orchestration"]["a6_entry"]
	var candidate := {}
	for candidate_value in candidates.get("candidats", []):
		if (
			candidate_value.get("scene_definition_id") == entry["scene_definition_id"]
			and candidate_value.get("variant_id") == entry["variant_id"]
		):
			candidate = candidate_value.duplicate(true)
			break
	if candidate.is_empty():
		return _preparation_failure("A6_PACKAGE_NOT_ELIGIBLE")
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
			],
		},
	})
	if not composition.get("ok", false):
		return _preparation_failure(
			"A9_COMPOSITION_REFUSED:%s"
			% str(composition.get("erreur", composition.get("error_code", "UNKNOWN")))
		)
	if composition.get("window", {}).get("options", []).size() != 1:
		return _preparation_failure("SINGLE_OPTION_WINDOW_REFUSED")
	return {
		"ok": true,
		"error_code": null,
		"sequence_id": sequence["sequence_id"],
		"prepared_plan": composition["plan"].duplicate(true),
		"option_id": "primary_option",
		"activation_context": context.duplicate(true),
		"window": composition["window"].duplicate(true),
	}


static func activate_prepared_sequence(facade, prepared: Dictionary) -> Dictionary:
	if (
		facade == null
		or not facade.has_method("activate_option")
		or not prepared.get("ok", false)
		or prepared.get("option_id") != "primary_option"
		or typeof(prepared.get("prepared_plan")) != TYPE_DICTIONARY
		or typeof(prepared.get("activation_context")) != TYPE_DICTIONARY
	):
		return {"ok": false, "error_code": "INVALID_PREPARED_SEQUENCE"}
	var activated: Dictionary = facade.activate_option(
		prepared["prepared_plan"],
		prepared["option_id"],
		{"intention": "PROPOSE", "context": prepared["activation_context"]},
	)
	if not activated.get("ok", false):
		return {"ok": false, "error_code": "A7_A8_A9_ACTIVATION_REFUSED"}
	return activated


static func _activate_sequence(facade, sequence: Dictionary) -> Dictionary:
	var prepared := prepare_sequence(facade, sequence)
	if not prepared["ok"]:
		return prepared
	return activate_prepared_sequence(facade, prepared)


static func _resolution_context(sequence: Dictionary, narrative_time: String) -> Dictionary:
	var definition: Dictionary = sequence["orchestration"]["a6_entry"]["definition"]
	var participants := {}
	for participant_id in sequence["participants"]["present_character_ids"]:
		participants[participant_id] = true
	return {
		"acte_courant": definition["conditions_dures"]["actes_compatibles"][0],
		"moment_diegetique": narrative_time,
		"participants_disponibles": participants,
		"opportunite_valide": true,
	}


static func _activation_context(sequence: Dictionary) -> Dictionary:
	var activation_time: String = sequence["temporal_projection"]["resolved_window"]["opens_at"]
	var context := _resolution_context(sequence, activation_time)
	return context


static func _initial_narrative_time(sequence: Dictionary) -> String:
	var entry_beat_id := str(sequence.get("entry_beat_id", ""))
	for beat in sequence.get("beats", []):
		if str(beat.get("beat_id", "")) != entry_beat_id:
			continue
		var messages = beat.get("content", {}).get("messages")
		if typeof(messages) != TYPE_ARRAY or messages.is_empty():
			return ""
		var first: Dictionary = messages[0]
		return str(first.get("diegetic_at", ""))
	return ""


static func _load_json(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return JsonNormalizer.normalize(parsed) if typeof(parsed) == TYPE_DICTIONARY else {}


static func _failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "session": null, "sequence": {}, "restored": false}


static func _preparation_failure(error_code: String) -> Dictionary:
	return {
		"ok": false,
		"error_code": error_code,
		"sequence_id": "",
		"prepared_plan": {},
		"option_id": "",
		"activation_context": {},
		"window": {},
	}
