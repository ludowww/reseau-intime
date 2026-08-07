extends RefCounted

class_name R8CUnifiedSeasonRunner

signal active_session_changed(previous_session, active_session)
signal season_state_changed(state: Dictionary)
signal runtime_failed(error_code: String)

const CatalogLoader := preload(
	"res://scripts/unified_runtime/application/AuthoredSequenceCatalogLoader.gd"
)
const CompositionRoot := preload(
	"res://scripts/unified_runtime/bootstrap/UnifiedPlayerRuntimeCompositionRoot.gd"
)
const SaveStore := preload(
	"res://scripts/unified_runtime/application/UnifiedPlayerRuntimeSaveStore.gd"
)
const SessionSaveStore := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonSessionSaveStore.gd"
)
const SeasonSnapshot := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonSnapshotV1.gd"
)
const RuntimeSnapshotV2 := preload(
	"res://scripts/unified_runtime/application/UnifiedRuntimeSnapshotV2.gd"
)
const PersistentMessages := preload(
	"res://scripts/unified_runtime/application/PersistentMessagesStateV1.gd"
)
const DurableGallery := preload(
	"res://scripts/unified_runtime/projection/DurableGalleryProjection.gd"
)
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)

const ACTIVE_SEQUENCE := "ACTIVE_SEQUENCE"
const OPPORTUNITY_AVAILABLE := "OPPORTUNITY_AVAILABLE"
const IDLE_NO_ELIGIBLE_SEQUENCE := "IDLE_NO_ELIGIBLE_SEQUENCE"
const PRODUCTION_CATALOG_PATH := "res://data/unified_runtime/catalogs/season_1_v1.json"
const PRODUCTION_CATALOG_ID := "season_1_v1"
const PRODUCTION_SEASON_ID := "season_1"

var catalog: Dictionary = {}
var completed_sequence_ids: Array = []
var active_sequence_id := ""
var active_session

var _portrait_shell
var _save_store
var _persistent_messages_state: Dictionary = {}
var _opportunity: Dictionary = {}
var _status := IDLE_NO_ELIGIBLE_SEQUENCE
var _last_result := _result(false, "NOT_INITIALIZED")


static func create(
	portrait_shell,
	save_path_override := "",
) -> Dictionary:
	return _create_from_catalog(
		PRODUCTION_CATALOG_PATH,
		portrait_shell,
		save_path_override,
		PRODUCTION_CATALOG_ID,
		PRODUCTION_SEASON_ID,
	)


static func create_for_test(
	catalog_path: String,
	portrait_shell,
	save_path_override := "",
) -> Dictionary:
	return _create_from_catalog(catalog_path, portrait_shell, save_path_override, "", "")


static func _create_from_catalog(
	catalog_path: String,
	portrait_shell,
	save_path_override: String,
	expected_catalog_id: String,
	expected_season_id: String,
) -> Dictionary:
	if portrait_shell == null:
		return _creation_failure("PORTRAIT_SHELL_NOT_READY")
	var loaded := CatalogLoader.load_catalog(
		catalog_path, expected_catalog_id, expected_season_id
	)
	if not loaded["ok"]:
		return _creation_failure(str(loaded["error_code"]))
	var store_result := SaveStore.create(save_path_override)
	if not store_result["ok"]:
		return _creation_failure(str(store_result["error_code"]))
	var graph := CompositionRoot._new_catalog_domain_graph(loaded["catalog"])
	if graph.is_empty():
		return _creation_failure("A6_A10_GRAPH_REFUSED")
	var runner := new()
	runner.catalog = loaded["catalog"]
	runner.catalog["facade"] = graph["facade"]
	runner._portrait_shell = portrait_shell
	runner._save_store = store_result["store"]
	runner._persistent_messages_state = PersistentMessages.empty(
		runner.catalog["messages_metadata"]
	)
	var restored_snapshot = null
	var restored_persistent_messages: Dictionary = {}
	var restored_save := false
	if runner._save_store.exists():
		restored_save = true
		var loaded_save: Dictionary = runner._save_store.load_snapshot()
		if not loaded_save["ok"]:
			return _creation_failure(str(loaded_save["error_code"]))
		var restored := runner._restore_or_migrate(loaded_save["snapshot"])
		if not restored["ok"]:
			return _creation_failure(str(restored["error_code"]))
		restored_snapshot = restored.get("active_runtime_snapshot")
		restored_persistent_messages = restored.get("persistent_messages_state", {}).duplicate(true)
	if runner.active_sequence_id.is_empty() and not restored_save:
		var selected := runner._select_and_compose_next(null)
		if not selected["ok"]:
			return _creation_failure(str(selected["error_code"]))
	elif runner.active_sequence_id.is_empty():
		if not runner._eligible_packages().is_empty():
			return _creation_failure("UNRESTORABLE_INCOMPLETE_HANDOFF_SAVE")
		runner._status = IDLE_NO_ELIGIBLE_SEQUENCE
	elif restored_snapshot != null:
		var package: Dictionary = runner.catalog["package_by_sequence_id"][runner.active_sequence_id]
		if restored_snapshot.get("execution", {}).get("execution_status") == "COMPLETE":
			var completed := runner._transition_restored_complete(
				restored_snapshot, restored_persistent_messages
			)
			if not completed["ok"]:
				return _creation_failure(str(completed["error_code"]))
		else:
			var composed := runner._compose_active_package(package, restored_snapshot)
			if not composed["ok"]:
				return _creation_failure(str(composed["error_code"]))
	else:
		return _creation_failure("ACTIVE_SEQUENCE_WITHOUT_RUNTIME_SNAPSHOT")
	runner._last_result = _result(true)
	return {"ok": true, "error_code": null, "runner": runner}


func begin() -> Dictionary:
	if active_session == null:
		if _status not in [OPPORTUNITY_AVAILABLE, IDLE_NO_ELIGIBLE_SEQUENCE]:
			_status = IDLE_NO_ELIGIBLE_SEQUENCE
		return _publish(true)
	var begun: Dictionary = active_session.begin()
	if not begun["ok"]:
		return _publish(false, str(begun["error_code"]))
	return _publish(true)


func status() -> String:
	return _status


func presentation_source() -> Dictionary:
	var source: Dictionary
	if active_session != null:
		source = active_session.presentation_source()
	else:
		source = _persistent_messages_state.get("source", {}).duplicate(true)
	if _status == OPPORTUNITY_AVAILABLE and not _opportunity.is_empty():
		for thread in source.get("threads", []):
			if str(thread.get("thread_id", "")) != str(_opportunity.get("thread_id", "")):
				continue
			thread["availability_state"] = OPPORTUNITY_AVAILABLE
			thread["opportunity_action_label"] = _opportunity["action_label"]
			thread["last_preview"] = "Nouveau moment disponible"
			thread["unread_count"] = 0
			thread["has_unread_content"] = false
	return source


func presented_message_ids_by_thread() -> Dictionary:
	if active_session != null:
		return active_session.presented_message_ids_by_thread()
	return _persistent_messages_state.get("presented_message_ids_by_thread", {}).duplicate(true)


func gallery_source() -> Dictionary:
	if active_session != null:
		return active_session.gallery_source()
	var domain: Dictionary = catalog["facade"].save_state()
	var registry = domain.get("narrative_state", {}).get("livraison_medias")
	if typeof(registry) != TYPE_DICTIONARY:
		return {}
	var created := DurableGallery.create_catalog(registry, catalog["media_resolver"])
	if not created["ok"]:
		return {}
	var source: Dictionary = created["projection"].content_source()
	return source["source"].duplicate(true) if source["ok"] else {}


func describe_state() -> Dictionary:
	return {
		"catalog_id": catalog.get("catalog_id"),
		"catalog_fingerprint": catalog.get("fingerprint"),
		"season_id": catalog.get("season_id"),
		"status": _status,
		"completed_sequence_ids": completed_sequence_ids.duplicate(),
		"active_sequence_id": active_sequence_id if not active_sequence_id.is_empty() else null,
		"active_session_count": 1 if active_session != null else 0,
		"active_session": active_session.describe_state() if active_session != null else {},
		"opportunity": (
			{
				"sequence_id": _opportunity.get("sequence_id"),
				"thread_id": _opportunity.get("thread_id"),
				"action_label": _opportunity.get("action_label"),
			}
			if not _opportunity.is_empty() else {}
		),
		"last_result": _last_result.duplicate(true),
	}


func activate_opportunity(thread_id: String) -> Dictionary:
	if (
		_status != OPPORTUNITY_AVAILABLE
		or active_session != null
		or _opportunity.is_empty()
		or thread_id != str(_opportunity.get("thread_id", ""))
	):
		return _publish(false, "OPPORTUNITY_ACTIVATION_REFUSED")
	var sequence_id := str(_opportunity.get("sequence_id", ""))
	if not catalog.get("package_by_sequence_id", {}).has(sequence_id):
		return _publish(false, "OPPORTUNITY_PACKAGE_NOT_FOUND")
	var package: Dictionary = catalog["package_by_sequence_id"][sequence_id]
	var checkpoint_sequence_id := (
		str(completed_sequence_ids[-1]) if not completed_sequence_ids.is_empty() else ""
	)
	var domain_before: Dictionary = catalog["facade"].save_state().duplicate(true)
	var checkpoint_before := _capture_opportunity_checkpoint(
		checkpoint_sequence_id, domain_before
	)
	if not checkpoint_before["ok"]:
		return _publish(false, "OPPORTUNITY_CHECKPOINT_REFUSED")
	var activated := CompositionRoot.activate_prepared_sequence(
		catalog["facade"],
		{
			"ok": true,
			"prepared_plan": _opportunity["prepared_plan"],
			"option_id": _opportunity["option_id"],
			"activation_context": _opportunity["activation_context"],
		},
	)
	if not activated.get("ok", false):
		return _rollback_opportunity_activation(
			domain_before, str(activated.get("error_code", "OPPORTUNITY_REVALIDATION_REFUSED"))
		)
	var composed := _compose_active_package(package, null, activated)
	if not composed["ok"]:
		return _rollback_opportunity_activation(domain_before, str(composed["error_code"]))
	_opportunity = {}
	active_session_changed.emit(null, active_session)
	season_state_changed.emit(describe_state())
	var begun: Dictionary = active_session.begin()
	if not begun["ok"]:
		return _rollback_opportunity_activation(
			domain_before, str(begun["error_code"]), checkpoint_before["snapshot"]
		)
	return _publish(true)


func store_active_runtime_snapshot(runtime_snapshot: Dictionary) -> Dictionary:
	if (
		active_session == null
		or active_sequence_id.is_empty()
		or runtime_snapshot.get("sequence_id") != active_sequence_id
	):
		return _publish(false, "FOREIGN_ACTIVE_RUNTIME_SNAPSHOT")
	var package: Dictionary = catalog["package_by_sequence_id"][active_sequence_id]
	if not RuntimeSnapshotV2.validate(runtime_snapshot, package["sequence"])["valid"]:
		return _publish(false, "INVALID_ACTIVE_RUNTIME_SNAPSHOT")
	var merged := PersistentMessages.merge_with_active(
		_persistent_messages_state,
		runtime_snapshot["messages_adapter"]["source"],
		runtime_snapshot["messages_adapter"]["presented_message_ids_by_thread"],
		catalog["messages_metadata"],
	)
	if not merged["ok"]:
		return _publish(false, str(merged["error_code"]))
	var snapshot_messages_state: Dictionary = PersistentMessages.without_active_choices(
		merged["state"]
	)
	var built := SeasonSnapshot.create(
		catalog,
		active_sequence_id,
		completed_sequence_ids,
		runtime_snapshot,
		snapshot_messages_state,
	)
	if not built["ok"]:
		return _publish(false, str(built["error_code"]))
	var stored: Dictionary = _save_store.save_snapshot(built["snapshot"])
	return _publish(bool(stored["ok"]), stored.get("error_code"))


func _restore_or_migrate(saved: Dictionary) -> Dictionary:
	var season_snapshot: Dictionary
	if saved.get("schema_id") == SeasonSnapshot.SCHEMA_ID:
		var validation := SeasonSnapshot.validate(saved, catalog)
		if not validation["valid"]:
			return {"ok": false, "error_code": "INVALID_SEASON_SAVE"}
		season_snapshot = saved.duplicate(true)
	else:
		var migration := SeasonSnapshot.migrate_n17_v2(saved, catalog)
		if not migration["ok"]:
			return {"ok": false, "error_code": migration["error_code"]}
		season_snapshot = migration["snapshot"]
		var stored: Dictionary = _save_store.save_snapshot(season_snapshot)
		if not stored["ok"]:
			return {"ok": false, "error_code": stored["error_code"]}
	completed_sequence_ids = season_snapshot["completed_sequence_ids"].duplicate()
	active_sequence_id = (
		str(season_snapshot["active_sequence_id"])
		if season_snapshot["active_sequence_id"] != null else ""
	)
	_persistent_messages_state = PersistentMessages.without_sequence(
		season_snapshot["persistent_messages_state"], str(season_snapshot["active_sequence_id"])
	)
	return {
		"ok": true,
		"error_code": null,
		"active_runtime_snapshot": season_snapshot["active_runtime_snapshot"],
		"persistent_messages_state": season_snapshot["persistent_messages_state"].duplicate(true),
	}


func _eligible_packages() -> Array:
	var eligible: Array = []
	for package in catalog["packages"]:
		var sequence: Dictionary = package["sequence"]
		if sequence["sequence_id"] in completed_sequence_ids:
			continue
		var candidates: Dictionary = catalog["facade"].find_candidates(
			CompositionRoot._activation_context(sequence)
		)
		if not candidates.get("ok", false):
			continue
		for candidate in candidates["candidats"]:
			var key := CatalogLoader.candidate_key(
				candidate["scene_definition_id"], candidate["variant_id"]
			)
			if key == package["candidate_key"]:
				eligible.append(package)
				break
	return eligible


func _select_and_compose_next(previous_session) -> Dictionary:
	if active_session != null:
		return _publish(false, "SECOND_ACTIVE_SEQUENCE_REFUSED")
	_opportunity = {}
	var eligible := _eligible_packages()
	if eligible.is_empty():
		active_sequence_id = ""
		_status = IDLE_NO_ELIGIBLE_SEQUENCE
		active_session_changed.emit(previous_session, null)
		season_state_changed.emit(describe_state())
		return _publish(true)
	var package: Dictionary = eligible[0]
	active_sequence_id = package["sequence"]["sequence_id"]
	var composed := _compose_active_package(package, null)
	if not composed["ok"]:
		active_sequence_id = ""
		return composed
	_status = ACTIVE_SEQUENCE
	active_session_changed.emit(previous_session, active_session)
	season_state_changed.emit(describe_state())
	return _publish(true)


func _compose_active_package(package: Dictionary, runtime_snapshot, activation_receipt = null) -> Dictionary:
	if active_session != null:
		return _publish(false, "SECOND_ACTIVE_SEQUENCE_REFUSED")
	var bridge_result := SessionSaveStore.create(self, _save_store.path())
	if not bridge_result["ok"]:
		return _publish(false, str(bridge_result["error_code"]))
	var composed := CompositionRoot.compose_package(
		package,
		_portrait_shell,
		catalog["facade"],
		bridge_result["store"],
		runtime_snapshot,
		_persistent_messages_state,
		catalog["messages_metadata"],
		catalog["media_resolver"],
		activation_receipt,
	)
	if not composed["ok"]:
		bridge_result["store"].release()
		return _publish(false, str(composed["error_code"]))
	active_session = composed["session"]
	active_sequence_id = package["sequence"]["sequence_id"]
	_status = ACTIVE_SEQUENCE
	active_session.sequence_completed.connect(_on_active_sequence_completed)
	return _publish(true)


func _on_active_sequence_completed(completed_session) -> void:
	var completed := _transition_completed_session(completed_session, true)
	if not completed["ok"]:
		_publish(false, str(completed["error_code"]))


func _transition_completed_session(completed_session, emit_signals: bool) -> Dictionary:
	if (
		completed_session == null
		or completed_session != active_session
		or active_sequence_id.is_empty()
		or completed_session.execution_state().get("execution_status") != "COMPLETE"
	):
		return _result(false, "INVALID_COMPLETED_SESSION")
	if active_sequence_id in completed_sequence_ids:
		return _result(true, null, true)
	var completed_id := active_sequence_id
	var persistent: Dictionary = completed_session.persistent_messages_state()
	if persistent.is_empty():
		return _result(false, "PERSISTENT_MESSAGES_CAPTURE_REFUSED")
	var checkpoint := _verify_complete_checkpoint(completed_session, completed_id, persistent)
	if not checkpoint["ok"]:
		return _result(false, "SEASON_HANDOFF_COMPLETE_CHECKPOINT_REFUSED")
	completed_sequence_ids.append(completed_id)
	_persistent_messages_state = persistent
	var previous_session = active_session
	if previous_session.sequence_completed.is_connected(_on_active_sequence_completed):
		previous_session.sequence_completed.disconnect(_on_active_sequence_completed)
	previous_session.detach()
	active_session = null
	active_sequence_id = ""
	var prepared := _prepare_next_opportunity()
	if emit_signals:
		active_session_changed.emit(previous_session, null)
		season_state_changed.emit(describe_state())
	return prepared


func _transition_restored_complete(
	runtime_snapshot: Dictionary, persistent_messages_state: Dictionary
) -> Dictionary:
	if (
		active_session != null
		or active_sequence_id.is_empty()
		or runtime_snapshot.get("sequence_id") != active_sequence_id
		or runtime_snapshot.get("execution", {}).get("execution_status") != "COMPLETE"
		or active_sequence_id in completed_sequence_ids
		or persistent_messages_state.is_empty()
	):
		return _result(false, "INVALID_RESTORED_COMPLETE_CHECKPOINT")
	var package: Dictionary = catalog["package_by_sequence_id"][active_sequence_id]
	if not RuntimeSnapshotV2.validate(runtime_snapshot, package["sequence"])["valid"]:
		return _result(false, "INVALID_RESTORED_COMPLETE_CHECKPOINT")
	var merged := PersistentMessages.merge_with_active(
		_persistent_messages_state,
		runtime_snapshot["messages_adapter"]["source"],
		runtime_snapshot["messages_adapter"]["presented_message_ids_by_thread"],
		catalog["messages_metadata"],
	)
	if (
		not merged["ok"]
		or JsonNormalizer.normalize(PersistentMessages.without_active_choices(merged["state"]))
		!= JsonNormalizer.normalize(persistent_messages_state)
	):
		return _result(false, "RESTORED_COMPLETE_MESSAGES_MISMATCH")
	var restored = catalog["facade"].restore_state(runtime_snapshot["domain"].duplicate(true))
	if typeof(restored) != TYPE_DICTIONARY or not restored.get("ok", false):
		return _result(false, "RESTORED_COMPLETE_DOMAIN_REFUSED")
	completed_sequence_ids.append(active_sequence_id)
	_persistent_messages_state = persistent_messages_state.duplicate(true)
	active_sequence_id = ""
	return _prepare_next_opportunity()


func _prepare_next_opportunity() -> Dictionary:
	if active_session != null:
		return _result(false, "SECOND_ACTIVE_SEQUENCE_REFUSED")
	_opportunity = {}
	var eligible := _eligible_packages()
	if eligible.is_empty():
		_status = IDLE_NO_ELIGIBLE_SEQUENCE
		return _result(true)
	var package: Dictionary = eligible[0]
	var prepared := CompositionRoot.prepare_sequence(catalog["facade"], package["sequence"])
	if not prepared["ok"]:
		_status = IDLE_NO_ELIGIBLE_SEQUENCE
		return _result(false, str(prepared["error_code"]))
	var threads: Array = package.get("messages_catalog", {}).get(
		"presentation_metadata", {}
	).get("threads", [])
	if threads.size() != 1:
		_status = IDLE_NO_ELIGIBLE_SEQUENCE
		return _result(false, "OPPORTUNITY_THREAD_METADATA_REFUSED")
	var thread: Dictionary = threads[0]
	var title := str(thread.get("title", ""))
	var thread_id := str(thread.get("thread_id", ""))
	if title.is_empty() or thread_id.is_empty():
		_status = IDLE_NO_ELIGIBLE_SEQUENCE
		return _result(false, "OPPORTUNITY_THREAD_METADATA_REFUSED")
	_opportunity = {
		"sequence_id": package["sequence"]["sequence_id"],
		"package_id": package["manifest"]["package_id"],
		"thread_id": thread_id,
		"title": title,
		"action_label": "Continuer avec " + title,
		"prepared_plan": prepared["prepared_plan"].duplicate(true),
		"option_id": prepared["option_id"],
		"activation_context": prepared["activation_context"].duplicate(true),
	}
	_status = OPPORTUNITY_AVAILABLE
	return _result(true)


func _verify_complete_checkpoint(
	completed_session, completed_id: String, persistent: Dictionary
) -> Dictionary:
	var loaded: Dictionary = _save_store.load_snapshot()
	if not loaded["ok"]:
		return _result(false, "CHECKPOINT_LOAD_REFUSED")
	var snapshot = loaded.get("snapshot")
	if typeof(snapshot) != TYPE_DICTIONARY or not SeasonSnapshot.validate(snapshot, catalog)["valid"]:
		return _result(false, "CHECKPOINT_VALIDATION_REFUSED")
	var runtime = snapshot.get("active_runtime_snapshot")
	if (
		snapshot.get("active_sequence_id") != completed_id
		or snapshot.get("completed_sequence_ids") != completed_sequence_ids
		or typeof(runtime) != TYPE_DICTIONARY
		or runtime.get("sequence_id") != completed_id
		or runtime.get("execution", {}).get("execution_status") != "COMPLETE"
		or JsonNormalizer.normalize(runtime.get("domain"))
		!= JsonNormalizer.normalize(completed_session.durable_state())
		or JsonNormalizer.normalize(snapshot.get("persistent_messages_state"))
		!= JsonNormalizer.normalize(persistent)
	):
		return _result(false, "CHECKPOINT_CONTENT_MISMATCH")
	return _result(true)


func _capture_opportunity_checkpoint(
	sequence_id: String, expected_domain: Dictionary
) -> Dictionary:
	var loaded: Dictionary = _save_store.load_snapshot()
	if not loaded["ok"]:
		return {"ok": false, "snapshot": {}}
	var snapshot = loaded.get("snapshot")
	if typeof(snapshot) != TYPE_DICTIONARY or not SeasonSnapshot.validate(snapshot, catalog)["valid"]:
		return {"ok": false, "snapshot": {}}
	var runtime = snapshot.get("active_runtime_snapshot")
	if (
		sequence_id.is_empty()
		or typeof(runtime) != TYPE_DICTIONARY
		or snapshot.get("active_sequence_id") != sequence_id
		or runtime.get("sequence_id") != sequence_id
		or runtime.get("execution", {}).get("execution_status") != "COMPLETE"
		or JsonNormalizer.normalize(runtime.get("domain"))
		!= JsonNormalizer.normalize(expected_domain)
		or JsonNormalizer.normalize(snapshot.get("persistent_messages_state"))
		!= JsonNormalizer.normalize(_persistent_messages_state)
	):
		return {"ok": false, "snapshot": {}}
	return {"ok": true, "snapshot": snapshot.duplicate(true)}


func _checkpoint_is_unchanged(expected_snapshot: Dictionary) -> Dictionary:
	var loaded: Dictionary = _save_store.load_snapshot()
	if not loaded["ok"]:
		return _result(false, "CHECKPOINT_LOAD_REFUSED")
	var snapshot = loaded.get("snapshot")
	return _result(
		typeof(snapshot) == TYPE_DICTIONARY
		and SeasonSnapshot.validate(snapshot, catalog)["valid"]
		and JsonNormalizer.normalize(snapshot) == JsonNormalizer.normalize(expected_snapshot),
		"CHECKPOINT_CONTENT_MISMATCH",
	)


func _rollback_opportunity_activation(
	domain_before: Dictionary, error_code: String, checkpoint_before: Dictionary = {}
) -> Dictionary:
	var failed_session = active_session
	if failed_session != null:
		if failed_session.sequence_completed.is_connected(_on_active_sequence_completed):
			failed_session.sequence_completed.disconnect(_on_active_sequence_completed)
		failed_session.detach()
	active_session = null
	active_sequence_id = ""
	var restored = catalog["facade"].restore_state(domain_before.duplicate(true))
	if typeof(restored) != TYPE_DICTIONARY or not restored.get("ok", false):
		_status = IDLE_NO_ELIGIBLE_SEQUENCE
		_opportunity = {}
		if failed_session != null:
			active_session_changed.emit(failed_session, null)
		season_state_changed.emit(describe_state())
		return _publish(false, "OPPORTUNITY_DOMAIN_ROLLBACK_REFUSED")
	if (
		not checkpoint_before.is_empty()
		and not _checkpoint_is_unchanged(checkpoint_before)["ok"]
	):
		var restored_checkpoint: Dictionary = _save_store.save_snapshot(checkpoint_before)
		if (
			not restored_checkpoint["ok"]
			or not _checkpoint_is_unchanged(checkpoint_before)["ok"]
		):
			_status = IDLE_NO_ELIGIBLE_SEQUENCE
			_opportunity = {}
			if failed_session != null:
				active_session_changed.emit(failed_session, null)
			season_state_changed.emit(describe_state())
			return _publish(false, "OPPORTUNITY_CHECKPOINT_ROLLBACK_REFUSED")
	var prepared := _prepare_next_opportunity()
	if failed_session != null:
		active_session_changed.emit(failed_session, null)
	season_state_changed.emit(describe_state())
	if not prepared["ok"]:
		return _publish(false, str(prepared["error_code"]))
	return _publish(false, error_code)


func _publish(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	_last_result = _result(ok, error_code, idempotent)
	if not ok:
		runtime_failed.emit(str(error_code))
	return _last_result.duplicate(true)


static func _result(ok: bool, error_code = null, idempotent := false) -> Dictionary:
	return {"ok": ok, "error_code": error_code, "idempotent": idempotent}


static func _creation_failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "runner": null}
