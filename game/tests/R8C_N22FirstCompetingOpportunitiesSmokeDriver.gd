extends "res://tests/R8C_N21VisibleSingleCandidateOpportunitySmokeDriver.gd"

const NICO_N22_ID := "nico_saved_seat_01"
const MARIE_N22_ID := "marie_household_report_01"
const N22CatalogLoader := preload(
	"res://scripts/unified_runtime/application/AuthoredSequenceCatalogLoader.gd"
)
const N22AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const N22SeasonSnapshot := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonSnapshotV2.gd"
)
func _run() -> void:
	var catalog_probe := N22CatalogLoader.load_catalog(
		"res://data/unified_runtime/catalogs/season_1_v1.json", "season_1_v1", "season_1"
	)
	if not catalog_probe["ok"]:
		for error in catalog_probe.get("errors", []):
			push_error(str(error))
		for path in [
			"res://data/unified_runtime/sequences/nico_saved_seat_01.json",
			"res://data/unified_runtime/sequences/marie_household_report_01.json",
		]:
			var sequence = JsonNormalizer.normalize(
				JSON.parse_string(FileAccess.get_file_as_string(path))
			)
			for error in N22AuthoredValidator.validate(sequence, true)["errors"]:
				push_error(path + ":" + str(error))
	_remove_save(SAVE_PATH)
	var main = await _reach_pair()
	if main == null:
		_finish()
		return
	var runner = main.season_runner
	var pair_state: Dictionary = runner.describe_state()
	var pair_source: Dictionary = runner.presentation_source()
	_expect(
		pair_state["opportunities"] == [
			{"sequence_id": NICO_N22_ID, "thread_id": "nico_thread", "action_label": "Continuer avec Nico"},
			{"sequence_id": MARIE_N22_ID, "thread_id": "marie_thread", "action_label": "Continuer avec Marie"},
		]
		and _offered_thread(pair_source, "nico_thread", "Continuer avec Nico")
		and _offered_thread(pair_source, "marie_thread", "Continuer avec Marie"),
		"paire N22 expose exactement Nico et Marie avec les CTA attendus",
	)
	_expect(
		_instance_count(runner, NICO_N22_ID) == 0
		and _instance_count(runner, MARIE_N22_ID) == 0
		and _texts(pair_source, "nico_thread").is_empty(),
		"paire N22 ne matérialise aucune A5 et Nico reste sans faux message",
	)
	var photo_viewer = main.shell.photo_viewer
	main.shell.photo_viewer = null
	var refused_before_save: Dictionary = runner.activate_opportunity("marie_thread")
	main.shell.photo_viewer = photo_viewer
	_expect(
		not refused_before_save["ok"]
		and runner.describe_state()["opportunities"].size() == 2
		and runner.not_selected_sequence_ids.is_empty()
		and _instance_count(runner, MARIE_N22_ID) == 0,
		"rollback pair pré-save restaure domaine, exclusion et deux CTA",
	)
	runner._test_fail_after_opportunity_first_save = true
	runner.active_session_changed.disconnect(main._on_active_session_changed)
	var refused_after_save: Dictionary = runner.activate_opportunity("marie_thread")
	runner.active_session_changed.connect(main._on_active_session_changed)
	main.shell.clear_unified_runtime(
		runner.presentation_source(), runner.gallery_source(), runner
	)
	_expect(
		not refused_after_save["ok"]
		and refused_after_save["error_code"] == "TEST_POST_FIRST_SAVE_FAILURE"
		and runner.describe_state()["opportunities"].size() == 2
		and runner.not_selected_sequence_ids.is_empty()
		and _instance_count(runner, MARIE_N22_ID) == 0,
		"rollback pair post-premier-save réinstalle checkpoint, domaine et deux CTA",
	)
	main.shell.messages_screen.open_thread("marie_thread")
	await _frames(4)
	var activated := {"ok": runner.active_sequence_id == MARIE_N22_ID}
	_expect(
		activated["ok"]
		and runner.not_selected_sequence_ids == [NICO_N22_ID]
		and _instance_count(runner, NICO_N22_ID) == 0
		and _instance_count(runner, MARIE_N22_ID) == 1,
		"Marie-first matérialise Marie seule et ferme Nico au niveau Saison",
	)
	main.queue_free()
	await get_tree().process_frame
	main = await _new_main(true)
	if main == null:
		_finish()
		return
	runner = main.season_runner
	_expect(
		runner.active_sequence_id == MARIE_N22_ID
		and runner.not_selected_sequence_ids == [NICO_N22_ID],
		"reload Marie-first conserve active Marie et Nico not-selected",
	)
	var marie_session = main.runtime_session
	var narrative_before: Dictionary = runner.catalog["facade"].save_state()["narrative_state"].duplicate(true)
	_cancel_ui_delivery(main.shell.messages_screen)
	marie_session._messages_adapter.attach_messages_screen(null)
	_expect(await _complete_current_messages(marie_session), "Marie automatique est réellement lue puis complétée")
	await _frames(5)
	var marie_instance := _instance_snapshot(runner, MARIE_N22_ID)
	_expect(
		marie_instance.get("state") == "RESOLVED"
		and marie_instance.get("operation") == "COMPLETE_AUTOMATIC"
		and marie_instance.get("choice_id") == ""
		and marie_instance.get("resolution_id") == ""
		and marie_session.execution_state().get("durable_commit_status") == "AUTOMATIC_COMPLETION_APPLIED"
		and runner.catalog["facade"].save_state()["narrative_state"] == narrative_before,
		"Marie ferme A5 PROPOSED vers RESOLVED sans delta A1",
	)
	_expect(
		runner.status() == SeasonRunner.IDLE_NO_ELIGIBLE_SEQUENCE
		and runner.completed_sequence_ids.has(MARIE_N22_ID)
		and runner.not_selected_sequence_ids == [NICO_N22_ID],
		"branche Marie-first converge vers IDLE sans résurrection Nico",
	)
	main.queue_free()
	await get_tree().process_frame
	main = await _new_main(false)
	if main == null:
		_finish()
		return
	_expect(
		main.season_runner.status() == SeasonRunner.IDLE_NO_ELIGIBLE_SEQUENCE
		and main.season_runner.not_selected_sequence_ids == [NICO_N22_ID]
		and main.season_runner.active_session == null,
		"restore V2 COMPLETE automatique effectue le handoff sans replay",
	)
	main.queue_free()
	await get_tree().process_frame

	_remove_save(SAVE_PATH)
	main = await _reach_pair()
	if main == null:
		_finish()
		return
	runner = main.season_runner
	main.shell.messages_screen.open_thread("nico_thread")
	await _frames(4)
	activated = {"ok": runner.active_sequence_id == NICO_N22_ID}
	_expect(
		activated["ok"]
		and runner.not_selected_sequence_ids.is_empty()
		and _instance_count(runner, NICO_N22_ID) == 1
		and _instance_count(runner, MARIE_N22_ID) == 0,
		"Nico-first matérialise Nico seul et garde Marie différée éphémère",
	)
	main.queue_free()
	await get_tree().process_frame
	main = await _new_main(true)
	if main == null:
		_finish()
		return
	runner = main.season_runner
	_expect(
		runner.active_sequence_id == NICO_N22_ID
		and runner.not_selected_sequence_ids.is_empty(),
		"reload pendant Nico conserve Nico actif et Marie rééligible",
	)
	var nico_session = main.runtime_session
	_cancel_ui_delivery(main.shell.messages_screen)
	nico_session._messages_adapter.attach_messages_screen(null)
	_expect(await _complete_nico(nico_session), "dialogue Nico source complet reste exécutable")
	await _frames(5)
	_expect(
		_opportunity_is(runner, MARIE_N22_ID, "marie_thread", "Continuer avec Marie")
		and runner.describe_state()["opportunities"].size() == 1
		and runner.not_selected_sequence_ids.is_empty(),
		"après Nico COMPLETE Marie revient comme opportunité mono-candidate",
	)
	main.queue_free()
	await get_tree().process_frame
	main = await _new_main(false)
	if main == null:
		_finish()
		return
	runner = main.season_runner
	_expect(
		_opportunity_is(runner, MARIE_N22_ID, "marie_thread", "Continuer avec Marie"),
		"reload après Nico conserve l'offre Marie seule",
	)
	main.shell.messages_screen.open_thread("marie_thread")
	await _frames(4)
	_expect(runner.active_sequence_id == MARIE_N22_ID, "activation Marie différée réussit")
	marie_session = main.runtime_session
	_cancel_ui_delivery(main.shell.messages_screen)
	marie_session._messages_adapter.attach_messages_screen(null)
	_expect(await _complete_current_messages(marie_session), "Marie différée suit la même completion automatique")
	await _frames(5)
	_expect(
		runner.status() == SeasonRunner.IDLE_NO_ELIGIBLE_SEQUENCE
		and runner.completed_sequence_ids.has(NICO_N22_ID)
		and runner.completed_sequence_ids.has(MARIE_N22_ID)
		and runner.not_selected_sequence_ids.is_empty(),
		"branche Nico-first puis Marie converge vers IDLE",
	)
	main.queue_free()
	await get_tree().process_frame
	_finish()


func _reach_pair():
	var main = await _new_main(true)
	if main == null:
		return null
	_expect(_n21_checkpoint_migrates(main.season_runner, MATHILDE_ID), "migration save Mathilde actif")
	if not await _complete_mathilde(main):
		failures.append("préfixe Mathilde refusé")
		return null
	await _frames(5)
	if not main.season_runner.activate_opportunity("sandra_thread")["ok"]:
		failures.append("activation Sandra refusée")
		return null
	await _frames(4)
	_expect(_n21_checkpoint_migrates(main.season_runner, SANDRA_ID), "migration save Sandra actif")
	_cancel_ui_delivery(main.shell.messages_screen)
	main.runtime_session._messages_adapter.attach_messages_screen(null)
	if not await _complete_sandra(main.runtime_session):
		failures.append("préfixe Sandra refusé")
		return null
	await _frames(5)
	if not main.season_runner.activate_opportunity("marie_thread")["ok"]:
		failures.append("activation Marie J03 refusée")
		return null
	await _frames(4)
	_expect(_n21_checkpoint_migrates(main.season_runner, MARIE_ID), "migration save Marie J03 actif")
	_cancel_ui_delivery(main.shell.messages_screen)
	main.runtime_session._messages_adapter.attach_messages_screen(null)
	if not await _complete_marie(main):
		failures.append("préfixe Marie J03 refusé")
		return null
	await _frames(5)
	_expect(_n21_checkpoint_migrates(main.season_runner, MARIE_ID), "migration checkpoint COMPLETE N21")
	return main


func _complete_nico(session) -> bool:
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "nico_thread", "choice_friday_nico_reservation_guided")).get("accepted", false):
		return false
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "nico_thread", "choice_friday_nico_honest")).get("accepted", false):
		return false
	if not await _complete_current_messages(session):
		return false
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "nico_thread", "choice_friday_nico_mathilde_guided")).get("accepted", false):
		return false
	return await _complete_current_messages(session)


func _instance_snapshot(runner, sequence_id: String) -> Dictionary:
	var expected := "unified_player_" + sequence_id
	for instance in runner.catalog["facade"].save_state().get("scene_registry", []):
		if str(instance.get("instance_id", "")) == expected:
			return instance
	return {}


func _n21_checkpoint_migrates(runner, expected_sequence_id: String) -> bool:
	var created := SaveStore.create(SAVE_PATH)
	if not created.get("ok", false):
		return false
	var loaded: Dictionary = created["store"].load_snapshot()
	if not loaded.get("ok", false):
		return false
	var legacy: Dictionary = loaded["snapshot"].duplicate(true)
	if legacy.get("active_sequence_id") != expected_sequence_id:
		return false
	legacy["schema_version"] = 1
	legacy["catalog_fingerprint"] = N22SeasonSnapshot.N21_CATALOG_FINGERPRINT
	legacy.erase("not_selected_sequence_ids")
	var source: Dictionary = legacy["persistent_messages_state"]["source"]
	source["characters"].erase("nico")
	var old_threads: Array = []
	for thread in source["threads"]:
		if thread.get("thread_id") != "nico_thread":
			old_threads.append(thread)
	source["threads"] = old_threads
	for field in ["messages_by_thread", "choices_by_thread"]:
		source[field].erase("nico_thread")
	legacy["persistent_messages_state"]["presented_message_ids_by_thread"].erase("nico_thread")
	var migrated := N22SeasonSnapshot.migrate_n21_v1(legacy, runner.catalog)
	if not migrated.get("ok", false):
		return false
	var snapshot: Dictionary = migrated["snapshot"]
	var nico_messages = snapshot["persistent_messages_state"]["source"]["messages_by_thread"].get("nico_thread")
	var unknown: Dictionary = legacy.duplicate(true)
	unknown["catalog_fingerprint"] = "unknown_old_fingerprint"
	return (
		snapshot["schema_version"] == 2
		and snapshot["not_selected_sequence_ids"].is_empty()
		and typeof(nico_messages) == TYPE_ARRAY
		and nico_messages.is_empty()
		and not N22SeasonSnapshot.migrate_n21_v1(unknown, runner.catalog)["ok"]
	)


func _finish() -> void:
	_remove_save(SAVE_PATH)
	if failures.is_empty():
		print("R8C_N22_FIRST_COMPETING_OPPORTUNITIES: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)
