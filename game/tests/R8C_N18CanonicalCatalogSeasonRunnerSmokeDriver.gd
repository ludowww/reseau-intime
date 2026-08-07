extends Node

const PortraitMainScene := preload("res://scenes/portrait/PortraitMain.tscn")
const PortraitShellScene := preload("res://scenes/portrait/PortraitShell.tscn")
const CatalogLoader := preload(
	"res://scripts/unified_runtime/application/AuthoredSequenceCatalogLoader.gd"
)
const CatalogContract := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceCatalogV1.gd"
)
const CatalogValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceCatalogValidator.gd"
)
const SeasonRunner := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonRunner.gd"
)
const SeasonSnapshot := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonSnapshotV1.gd"
)
const PersistentMessages := preload(
	"res://scripts/unified_runtime/application/PersistentMessagesStateV1.gd"
)
const SaveStore := preload(
	"res://scripts/unified_runtime/application/UnifiedPlayerRuntimeSaveStore.gd"
)
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)

const CATALOG_ALPHA_BETA := "res://tests/fixtures/unified_runtime/n18_catalog_alpha_beta.json"
const CATALOG_BETA_ALPHA := "res://tests/fixtures/unified_runtime/n18_catalog_beta_alpha.json"
const CATALOG_DUPLICATE_SEQUENCE := (
	"res://tests/fixtures/unified_runtime/n18_catalog_duplicate_sequence_id.json"
)
const CATALOG_DUPLICATE_CHOICE := (
	"res://tests/fixtures/unified_runtime/n18_catalog_duplicate_choice_id.json"
)
const SAVE_ROOT := "user://r8c_n18_smoke/"

class TestRuntimeHost:
	var shell
	var season_runner
	var runtime_session

	func queue_free() -> void:
		if shell != null:
			shell.queue_free()

var failures: Array[String] = []
var controls := 0


func _ready() -> void:
	_test_catalog_contract_and_fingerprint()
	_test_global_identity_collisions()
	await _test_production_catalog_boundary()
	await _test_authored_order_override()
	await _test_handoff_save_restore_and_idle()
	await _test_n17_v2_migration()
	if failures.is_empty():
		print("R8C_N18_CANONICAL_CATALOG_SEASON_RUNNER: OK (%d controls)" % controls)
		get_tree().quit(0)
	else:
		for failure in failures:
			push_error(failure)
		get_tree().quit(1)


func _test_catalog_contract_and_fingerprint() -> void:
	var loaded_ab := CatalogLoader.load_catalog(CATALOG_ALPHA_BETA)
	var loaded_ba := CatalogLoader.load_catalog(CATALOG_BETA_ALPHA)
	_expect(loaded_ab["ok"] and loaded_ba["ok"], "les deux catalogues TEST_ONLY sont valides")
	if not loaded_ab["ok"] or not loaded_ba["ok"]:
		return
	_expect(
		loaded_ab["catalog"]["fingerprint"] != loaded_ba["catalog"]["fingerprint"],
		"l’ordre authored explicite change l’empreinte",
	)
	var manifest: Dictionary = _load(CATALOG_ALPHA_BETA)
	_expect(
		CatalogContract.fingerprint(manifest) == CatalogContract.fingerprint(manifest.duplicate(true)),
		"la même logique de manifeste produit la même empreinte",
	)
	var added: Dictionary = manifest.duplicate(true)
	added["packages"].append(manifest["packages"][0].duplicate(true))
	added["packages"][-1]["package_id"] = "added_package"
	added["packages"][-1]["sequence_id"] = "added_sequence"
	_expect(
		CatalogContract.fingerprint(added) != CatalogContract.fingerprint(manifest),
		"un package ajouté change l’empreinte",
	)
	for mutation in ["authored_version", "sequence_path"]:
		var changed: Dictionary = manifest.duplicate(true)
		changed["packages"][0][mutation] = (
			"2.0.0" if mutation == "authored_version" else "res://tests/fixtures/unified_runtime/changed.json"
		)
		_expect(
			CatalogContract.fingerprint(changed) != CatalogContract.fingerprint(manifest),
			"la mutation %s change l’empreinte" % mutation,
		)
	var legacy: Dictionary = manifest.duplicate(true)
	legacy["packages"][0]["sequence_path"] = "res://data/runtime/season_1/j01_runtime_map.json"
	_expect(
		not CatalogValidator.validate(legacy)["valid"],
		"le catalogue refuse une source métier Saison 1 legacy",
	)
	var unknown_root: Dictionary = manifest.duplicate(true)
	unknown_root["unexpected"] = true
	_expect(not CatalogValidator.validate(unknown_root)["valid"], "la racine catalogue est fermée")
	var incomplete: Dictionary = manifest.duplicate(true)
	incomplete["packages"][0].erase("media_path")
	_expect(not CatalogValidator.validate(incomplete)["valid"], "un package incomplet est refusé")
	var duplicated: Dictionary = manifest.duplicate(true)
	duplicated["packages"].append(duplicated["packages"][0].duplicate(true))
	_expect(
		not CatalogValidator.validate(duplicated)["valid"],
		"les identités package et séquence-version dupliquées sont refusées",
	)
	var traversal: Dictionary = manifest.duplicate(true)
	traversal["packages"][0]["media_path"] = "res://tests/../data/forbidden.json"
	_expect(not CatalogValidator.validate(traversal)["valid"], "la traversée de chemin est refusée")
	var collisions: Dictionary = manifest.duplicate(true)
	for field in ["sequence_path", "messages_path", "physical_path", "media_path"]:
		collisions["packages"][1][field] = collisions["packages"][0][field]
	var collision_errors: Array = CatalogValidator.validate(collisions)["errors"]
	_expect(
		collision_errors.any(func(error): return "duplicate_global_message_id" in str(error))
		and collision_errors.any(func(error): return "duplicate_global_media_id" in str(error)),
		"les collisions globales Messages et Media ferment le catalogue",
	)
	var catalog: Dictionary = loaded_ab["catalog"]
	var season_save: Dictionary = SeasonSnapshot.create(
		catalog, "", [], null, PersistentMessages.empty(catalog["messages_metadata"])
	)["snapshot"]
	_expect(
		SeasonSnapshot.validate(season_save, catalog)["valid"],
		"le catalogue logique identique accepte son enveloppe Saison",
	)
	var fingerprint_mutations: Array = []
	var package_added: Dictionary = manifest.duplicate(true)
	package_added["packages"].append(package_added["packages"][0].duplicate(true))
	package_added["packages"][-1]["package_id"] = "added_package"
	package_added["packages"][-1]["sequence_id"] = "added_sequence"
	fingerprint_mutations.append(package_added)
	for field in ["sequence_path", "authored_version"]:
		var mutated: Dictionary = manifest.duplicate(true)
		mutated["packages"][0][field] = (
			"res://tests/fixtures/unified_runtime/n18_test_sequence_beta.json"
			if field == "sequence_path" else "2.0.0"
		)
		fingerprint_mutations.append(mutated)
	for mutated_manifest in fingerprint_mutations:
		var changed_catalog: Dictionary = catalog.duplicate(false)
		changed_catalog["fingerprint"] = CatalogContract.fingerprint(mutated_manifest)
		_expect(
			not SeasonSnapshot.validate(season_save, changed_catalog)["valid"],
			"un manifeste ajouté, repointé ou reversionné refuse l’ancien save",
		)


func _test_global_identity_collisions() -> void:
	var duplicate_sequence: Dictionary = _load(CATALOG_DUPLICATE_SEQUENCE)
	var sequence_validation: Dictionary = CatalogValidator.validate(duplicate_sequence)
	_expect(
		not sequence_validation["valid"]
		and sequence_validation["errors"].any(
			func(error): return ".sequence_id:duplicate" in str(error)
		),
		"sequence_id reste globalement unique même entre versions authored distinctes",
	)
	_expect(
		not CatalogLoader.load_catalog(CATALOG_DUPLICATE_SEQUENCE)["ok"],
		"le loader refuse le catalogue à sequence_id dupliquée sans index partiel",
	)
	_expect(
		not SeasonRunner.create_for_test(CATALOG_DUPLICATE_SEQUENCE, self)["ok"],
		"aucun runner TEST_ONLY n’est créé depuis une sequence_id ambiguë",
	)
	var duplicate_choice: Dictionary = _load(CATALOG_DUPLICATE_CHOICE)
	for package in duplicate_choice["packages"]:
		var single_package: Dictionary = duplicate_choice.duplicate(true)
		single_package["catalog_id"] = "n18_single_" + package["package_id"]
		single_package["packages"] = [package.duplicate(true)]
		_expect(
			CatalogValidator.validate(single_package)["valid"],
			"chaque package shared_choice reste valide isolément",
		)
	var choice_validation: Dictionary = CatalogValidator.validate(duplicate_choice)
	_expect(
		not choice_validation["valid"]
		and choice_validation["errors"].any(
			func(error): return "duplicate_global_choice_id:shared_choice" in str(error)
		),
		"choice_id est globalement unique entre packages",
	)
	_expect(
		not CatalogLoader.load_catalog(CATALOG_DUPLICATE_CHOICE)["ok"],
		"le loader refuse le catalogue à choice_id dupliqué sans overwrite",
	)
	_expect(
		not SeasonRunner.create_for_test(CATALOG_DUPLICATE_CHOICE, self)["ok"],
		"aucun runner TEST_ONLY n’est créé depuis un choice_id ambigu",
	)


func _test_production_catalog_boundary() -> void:
	var save_path := SAVE_ROOT + "production_boundary.json"
	_remove_save(save_path)
	var main = await _new_production_main(save_path)
	if main == null:
		return
	var property_names: Array = main.get_property_list().map(func(property): return property["name"])
	_expect(
		"unified_catalog_path_override" not in property_names,
		"le vrai PortraitMain n’expose aucune propriété d’injection catalogue",
	)
	_expect(
		main.season_runner.catalog["catalog_id"] == "season_1_v1"
		and main.season_runner.catalog["season_id"] == "season_1"
		and main.season_runner.catalog["manifest"]["packages"].size() == 3
		and main.season_runner.active_sequence_id == "mathilde_returns_with_chosen_intent_01",
		"le vrai PortraitMain reste lié au catalogue canonique et démarre Mathilde",
	)
	main.queue_free()
	await get_tree().process_frame
	_remove_save(save_path)


func _test_authored_order_override() -> void:
	var save_path := SAVE_ROOT + "beta_alpha.json"
	_remove_save(save_path)
	var main = await _new_test_runtime(CATALOG_BETA_ALPHA, save_path)
	if main == null:
		return
	_expect(
		main.season_runner.active_sequence_id == "test_sequence_beta",
		"beta est sélectionnée avant alpha selon l’ordre catalogue, sans tri alphabétique",
	)
	_expect(
		main.season_runner.describe_state()["active_session_count"] == 1,
		"un seul executor player-facing est actif",
	)
	main.queue_free()
	await get_tree().process_frame
	_remove_save(save_path)


func _test_handoff_save_restore_and_idle() -> void:
	var save_path := SAVE_ROOT + "alpha_beta.json"
	_remove_save(save_path)
	var main = await _new_test_runtime(CATALOG_ALPHA_BETA, save_path)
	if main == null:
		return
	var runner = main.season_runner
	_expect(runner.active_sequence_id == "test_sequence_alpha", "alpha démarre en premier")
	var alpha_session = runner.active_session
	_expect(
		await _wait_for_status(alpha_session, "WAITING_FOR_PROJECTION_ACK"),
		"alpha expose sa première projection avant save",
	)
	var alpha_messages: Array = alpha_session.presentation_source()["messages_by_thread"]["alpha_thread"]
	_expect(
		alpha_session.mark_message_presented(alpha_messages[0]["message_id"]),
		"alpha progresse avant reload",
	)
	var alpha_execution: Dictionary = alpha_session.execution_state()
	var alpha_source: Dictionary = alpha_session.presentation_source()
	var alpha_presented: Dictionary = alpha_session.presented_message_ids_by_thread()
	main.queue_free()
	await get_tree().process_frame
	main = await _new_test_runtime(CATALOG_ALPHA_BETA, save_path)
	if main == null:
		return
	runner = main.season_runner
	_expect(
		runner.completed_sequence_ids.is_empty()
		and runner.active_sequence_id == "test_sequence_alpha"
		and runner.active_session.execution_state() == alpha_execution
		and runner.active_session.presentation_source() == alpha_source
		and runner.active_session.presented_message_ids_by_thread() == alpha_presented,
		"save/reload pendant alpha conserve active, transcript et exécution exacts",
	)
	alpha_session = runner.active_session
	_expect(await _complete_sequence(main, "alpha_thread", "alpha_finish"), "alpha atteint COMPLETE")
	await _frames(4)
	_expect(
		runner.completed_sequence_ids == ["test_sequence_alpha"]
		and runner.active_sequence_id == "test_sequence_beta"
		and runner.active_session != alpha_session
		and runner.describe_state()["active_session_count"] == 1,
		"handoff alpha vers beta est déterministe et mono-actif",
	)
	var post_alpha_domain: Dictionary = runner.catalog["facade"].save_state()
	runner._on_active_sequence_completed(alpha_session)
	_expect(
		runner.completed_sequence_ids == ["test_sequence_alpha"]
		and runner.catalog["facade"].save_state() == post_alpha_domain,
		"replay du handoff alpha est idempotent sans second A10",
	)
	var beta_source: Dictionary = runner.active_session.presentation_source()
	_expect(
		_message_ids(beta_source).count("alpha_message_01") == 1
		and _message_ids(beta_source).count("alpha_return_01") == 1,
		"le transcript alpha persiste sans duplication pendant beta",
	)
	_expect(
		runner.active_session.gallery_source().get("fixtures", {}).has("alpha_actor"),
		"la Galerie alpha durable reste résolue pendant beta",
	)
	var beta_saved: Dictionary = SaveStore.create(save_path)["store"].load_snapshot()
	_expect(
		beta_saved.get("ok", false)
		and SeasonSnapshot.validate(beta_saved.get("snapshot", {}), runner.catalog)["valid"],
		"le snapshot Saison reste valide pendant le handoff Alpha vers Beta",
	)
	var beta_execution: Dictionary = runner.active_session.execution_state()
	main.queue_free()
	await get_tree().process_frame
	main = await _new_test_runtime(CATALOG_ALPHA_BETA, save_path)
	if main == null:
		return
	runner = main.season_runner
	_expect(
		runner.completed_sequence_ids == ["test_sequence_alpha"]
		and runner.active_sequence_id == "test_sequence_beta"
		and runner.active_session.execution_state() == beta_execution,
		"reload pendant beta conserve completed, active et exécution exacts",
	)
	_expect(await _complete_sequence(main, "beta_thread", "beta_finish"), "beta atteint COMPLETE")
	await _frames(4)
	_expect(
		runner.completed_sequence_ids == ["test_sequence_alpha", "test_sequence_beta"]
		and runner.active_session == null
		and runner.status() == SeasonRunner.IDLE_NO_ELIGIBLE_SEQUENCE,
		"fin de catalogue devient IDLE_NO_ELIGIBLE_SEQUENCE",
	)
	var ids := _message_ids(runner.presentation_source())
	_expect(
		ids.size() == _unique_count(ids),
		"les identités Messages restent globalement uniques",
	)
	_expect(
		runner.gallery_source().get("fixtures", {}).has("alpha_actor")
		and runner.gallery_source().get("fixtures", {}).has("beta_actor"),
		"la Galerie catalogue-wide expose les médias durables des deux séquences",
	)
	main.queue_free()
	await get_tree().process_frame
	main = await _new_test_runtime(CATALOG_ALPHA_BETA, save_path)
	if main == null:
		return
	_expect(
		main.season_runner.status() == SeasonRunner.IDLE_NO_ELIGIBLE_SEQUENCE
		and main.season_runner.completed_sequence_ids == ["test_sequence_alpha", "test_sequence_beta"]
		and main.runtime_session == null,
		"reload après toutes les séquences reste idle et mono-actif",
	)
	main.queue_free()
	await get_tree().process_frame
	_remove_save(save_path)


func _test_n17_v2_migration() -> void:
	var save_path := SAVE_ROOT + "n17_mathilde_migration.json"
	_remove_save(save_path)
	var main = await _new_production_main(save_path)
	if main == null:
		return
	var session = main.season_runner.active_session
	var migration_ready := await _wait_for_status(session, "WAITING_FOR_PROJECTION_ACK")
	var opening_messages: Array = session.presentation_source().get("messages_by_thread", {}).get(
		"mathilde_thread", []
	)
	if migration_ready:
		for index in mini(8, opening_messages.size()):
			migration_ready = session.mark_message_presented(opening_messages[index]["message_id"])
			if not migration_ready:
				break
	_expect(
		migration_ready,
		"un vrai runtime Mathilde N17 atteint une frontière sauvegardable",
	)
	var expected_execution: Dictionary = session.execution_state()
	var expected_messages: Dictionary = session.presentation_source()
	var expected_presented: Dictionary = session.presented_message_ids_by_thread()
	var expected_durable: Dictionary = session.durable_state()
	_expect(session.save_now()["ok"], "le runtime Mathilde produit son snapshot V2 exact")
	var store = SaveStore.create(save_path)["store"]
	var outer: Dictionary = store.load_snapshot()
	var n17_v2: Dictionary = (
		outer.get("snapshot", {}).get("active_runtime_snapshot", {}).duplicate(true)
		if outer.get("ok", false) else {}
	)
	_expect(
		n17_v2.get("schema_id") == "reseau_intime.unified_player_runtime"
		and n17_v2.get("schema_version") == 2,
		"la fixture de migration est un snapshot N17 V2 réel",
	)
	_expect(store.save_snapshot(n17_v2)["ok"], "la sauvegarde brute N17 V2 est installée")
	main.queue_free()
	await get_tree().process_frame
	main = await _new_production_main(save_path)
	if main == null:
		return
	session = main.season_runner.active_session
	_expect(
		main.season_runner.active_sequence_id == "mathilde_returns_with_chosen_intent_01"
		and main.season_runner.completed_sequence_ids.is_empty(),
		"migration N17 vers Saison V1 maintient Mathilde active sans ambiguïté",
	)
	_expect(
		session.execution_state() == expected_execution
		and session.presentation_source() == expected_messages
		and session.presented_message_ids_by_thread() == expected_presented
		and session.durable_state() == expected_durable,
		"migration conserve transcript, exécution et état durable exacts",
	)
	var migrated: Dictionary = store.load_snapshot()
	_expect(
		migrated.get("ok", false)
		and migrated.get("snapshot", {}).get("schema_id") == "reseau_intime.unified_season"
		and migrated["snapshot"].get("active_runtime_snapshot") == n17_v2,
		"la migration est persistée une fois sous l’enveloppe Saison V1",
	)
	main.queue_free()
	await get_tree().process_frame
	_remove_save(save_path)


func _complete_sequence(main, thread_id: String, choice_id: String) -> bool:
	var session = main.season_runner.active_session
	if not await _complete_current_messages(session):
		return false
	if not await _continue_physical(main, session):
		return false
	if not await _continue_media(main, session):
		return false
	if not await _select_choice(session, thread_id, choice_id):
		return false
	var completed := await _complete_current_messages(session)
	return completed


func _complete_current_messages(session) -> bool:
	if not await _wait_for_status(session, "WAITING_FOR_PROJECTION_ACK"):
		return false
	var beat_id: String = session.execution_state()["current_beat_id"]
	var source: Dictionary = session.presentation_source()
	var thread_id := ""
	var active_messages: Array = []
	for candidate_thread_id in source.get("messages_by_thread", {}):
		for message in source["messages_by_thread"][candidate_thread_id]:
			if message.get("beat_id") == beat_id:
				thread_id = str(candidate_thread_id)
				active_messages.append(message)
	if active_messages.is_empty():
		return false
	var presented: Array = session.presented_message_ids_by_thread().get(thread_id, [])
	for message in active_messages:
		if message["message_id"] not in presented and not session.mark_message_presented(message["message_id"]):
			return false
	var read: Dictionary = session.on_thread_read(thread_id, active_messages[-1]["message_id"])
	await _frames(4)
	return read.get("ok", false)


func _continue_physical(main, session) -> bool:
	if not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	var button = main.shell.messages_screen.find_child("PhysicalContinue", true, false)
	if button == null or not button.visible:
		return false
	button.emit_signal("pressed")
	await _frames(4)
	return true


func _continue_media(main, session) -> bool:
	if not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	var viewer = main.shell.photo_viewer
	if viewer == null or not viewer.visible:
		return false
	viewer.back_button.emit_signal("pressed")
	await _frames(4)
	return true


func _select_choice(session, thread_id: String, choice_id: String) -> bool:
	if not await _wait_for_status(session, "WAITING_FOR_PROJECTION_ACK"):
		return false
	var choices: Array = session.presentation_source()["choices_by_thread"].get(thread_id, [])
	var ids: Array = choices.map(func(choice): return choice["choice_id"])
	if not session.on_choices_presented(thread_id, ids).get("ok", false):
		return false
	var selected: Dictionary = session.apply_choice(thread_id, choice_id)
	if not selected.get("accepted", false):
		return false
	for bubble in selected.get("new_messages", []):
		session.mark_message_presented(bubble["message_id"])
	session.mark_thread_batch_presented(thread_id)
	await _frames(4)
	return true


func _new_production_main(save_path: String):
	var main = PortraitMainScene.instantiate()
	main.unified_save_path_override = save_path
	add_child(main)
	await _frames(4)
	_expect(main.season_runner != null, "PortraitMain compose UnifiedSeasonRunner")
	if main.season_runner == null:
		main.queue_free()
		await get_tree().process_frame
		return null
	main.shell.messages_screen.runtime_delivery_time_scale = 0.001
	return main


func _new_test_runtime(catalog_path: String, save_path: String):
	var host := TestRuntimeHost.new()
	host.shell = PortraitShellScene.instantiate()
	host.shell.content_mode = "unified"
	add_child(host.shell)
	await _frames(3)
	var created: Dictionary = SeasonRunner.create_for_test(catalog_path, host.shell, save_path)
	_expect(created["ok"], "la factory TEST_ONLY compose le catalogue synthétique")
	if not created["ok"]:
		host.queue_free()
		await get_tree().process_frame
		return null
	host.season_runner = created["runner"]
	host.runtime_session = host.season_runner.active_session
	host.season_runner.active_session_changed.connect(
		_on_test_active_session_changed.bind(host)
	)
	if host.runtime_session != null and not host.shell.configure_unified_runtime(host.runtime_session):
		_expect(false, "le shell TEST_ONLY accepte la session synthétique")
		host.queue_free()
		await get_tree().process_frame
		return null
	var begun: Dictionary = host.season_runner.begin()
	_expect(begun["ok"], "le runner TEST_ONLY démarre")
	if not begun["ok"]:
		host.queue_free()
		await get_tree().process_frame
		return null
	host.shell.messages_screen.runtime_delivery_time_scale = 0.001
	return host


func _on_test_active_session_changed(_previous_session, next_session, host: TestRuntimeHost) -> void:
	host.runtime_session = next_session
	if next_session == null:
		host.shell.clear_unified_runtime(
			host.season_runner.presentation_source(),
			host.season_runner.gallery_source(),
			host.season_runner,
		)
		return
	host.shell.clear_unified_runtime(
		host.season_runner.presentation_source(),
		host.season_runner.gallery_source(),
		host.season_runner,
	)
	_expect(
		host.shell.configure_unified_runtime(next_session),
		"le handoff TEST_ONLY injecte uniquement la nouvelle session",
	)


func _wait_for_status(session, expected: String, max_frames := 40) -> bool:
	for _index in range(max_frames):
		if session.execution_state().get("execution_status") == expected:
			return true
		await get_tree().process_frame
	return false


func _message_ids(source: Dictionary) -> Array:
	var ids: Array = []
	for thread_id in source.get("messages_by_thread", {}):
		for message in source["messages_by_thread"][thread_id]:
			ids.append(message.get("message_id"))
	return ids


func _unique_count(values: Array) -> int:
	var unique := {}
	for value in values:
		unique[value] = true
	return unique.size()


func _load(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return JsonNormalizer.normalize(parsed) if typeof(parsed) == TYPE_DICTIONARY else {}


func _expect(condition: bool, message: String) -> void:
	controls += 1
	if not condition:
		failures.append(message)


func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame


func _remove_save(save_path: String) -> void:
	for suffix in ["", ".tmp", ".previous", ".corrupt"]:
		var path: String = save_path + suffix
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
