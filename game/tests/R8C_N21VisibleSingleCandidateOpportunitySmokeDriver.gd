extends Node

const PortraitMainScene := preload("res://scenes/portrait/PortraitMain.tscn")
const SaveStore := preload(
	"res://scripts/unified_runtime/application/UnifiedPlayerRuntimeSaveStore.gd"
)
const SeasonRunner := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonRunner.gd"
)
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)

const MATHILDE_ID := "mathilde_returns_with_chosen_intent_01"
const SANDRA_ID := "sandra_sentrycore_button_echo_01"
const MARIE_ID := "marie_evening_return_01"
const SAVE_PATH := "user://r8c_n21_smoke/production.json"

var failures: Array[String] = []
var controls := 0


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_remove_save(SAVE_PATH)
	var main = await _new_main(true)
	if main == null:
		_finish()
		return
	var runner = main.season_runner
	_expect(
		runner.active_sequence_id == MATHILDE_ID
		and runner.status() == SeasonRunner.ACTIVE_SEQUENCE
		and _visible_threads(main) == ["mathilde_thread"],
		"Mathilde active au bootstrap, Sandra et Marie invisibles",
	)
	_expect(await _complete_mathilde(main), "flow Mathilde N17 reste complet")
	await _frames(5)
	runner = main.season_runner
	var sandra_source: Dictionary = runner.presentation_source()
	var mathilde_domain: Dictionary = runner.catalog["facade"].save_state()
	var mathilde_gallery: Dictionary = runner.gallery_source()
	_expect(
		_opportunity_is(runner, SANDRA_ID, "sandra_thread", "Continuer avec Sandra")
		and runner.completed_sequence_ids == [MATHILDE_ID]
		and _visible_threads(main) == ["mathilde_thread", "sandra_thread"],
		"Mathilde COMPLETE expose uniquement l opportunité Sandra",
	)
	_expect(
		_texts(sandra_source, "mathilde_thread").size() > 0
		and _texts(sandra_source, "sandra_thread").is_empty()
		and _texts(sandra_source, "marie_thread").is_empty()
		and _offered_thread(sandra_source, "sandra_thread", "Continuer avec Sandra"),
		"offre Sandra est un CTA sans faux message ni unread",
	)
	_expect(
		_window_option_count(runner, SANDRA_ID) == 1
		and _instance_count(runner, SANDRA_ID) == 0,
		"fenêtre Sandra contient une option et zéro A5 avant clic",
	)
	_expect(
		_checkpoint_matches(MATHILDE_ID, mathilde_domain),
		"checkpoint disque Mathilde COMPLETE conserve le domaine",
	)
	var photo_viewer = main.shell.photo_viewer
	main.shell.photo_viewer = null
	var refused_activation: Dictionary = runner.activate_opportunity("sandra_thread")
	main.shell.photo_viewer = photo_viewer
	_expect(
		not refused_activation["ok"]
		and runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
		and runner.active_session == null
		and _instance_count(runner, SANDRA_ID) == 0
		and _checkpoint_matches(MATHILDE_ID, mathilde_domain),
		"échec de composition après PROPOSE rollback A5 et conserve le checkpoint",
	)
	main.queue_free()
	await get_tree().process_frame
	main = await _new_main(false)
	if main == null:
		_finish()
		return
	runner = main.season_runner
	_expect(
		_opportunity_is(runner, SANDRA_ID, "sandra_thread", "Continuer avec Sandra")
		and runner.catalog["facade"].save_state() == mathilde_domain
		and runner.gallery_source() == mathilde_gallery
		and runner.presentation_source() == sandra_source
		and _instance_count(runner, SANDRA_ID) == 0,
		"reload reconstruit Sandra sans session, A5 ni perte Mathilde",
	)
	main.shell.messages_screen.runtime_delivery_time_scale = 1000.0
	main.shell.messages_screen.open_thread("sandra_thread")
	await _frames(1)
	var session = main.runtime_session
	_expect(
		session != null
		and runner.active_sequence_id == SANDRA_ID
		and runner.describe_state()["active_session_count"] == 1
		and main.shell.messages_screen.active_thread_id == "sandra_thread"
		and main.shell.messages_screen.conversation_screen.visible,
		"clic carte ouvre Sandra avec exactement une session",
	)
	_expect(
		_instance_count(runner, SANDRA_ID) == 1,
		"clic Sandra crée exactement une matérialisation A5",
	)
	if session == null:
		_finish()
		return
	_cancel_ui_delivery(main.shell.messages_screen)
	session._messages_adapter.attach_messages_screen(null)
	_expect(await _complete_sandra(session), "flow Sandra N19 reste complet")
	await _frames(5)
	runner = main.season_runner
	var marie_source: Dictionary = runner.presentation_source()
	var sandra_domain: Dictionary = runner.catalog["facade"].save_state()
	_expect(
		_opportunity_is(runner, MARIE_ID, "marie_thread", "Continuer avec Marie")
		and runner.completed_sequence_ids == [MATHILDE_ID, SANDRA_ID]
		and _visible_threads(main) == ["mathilde_thread", "sandra_thread", "marie_thread"],
		"Sandra COMPLETE expose uniquement l opportunité Marie",
	)
	_expect(
		_texts(marie_source, "sandra_thread").size() == 5
		and _texts(marie_source, "marie_thread").is_empty()
		and runner.gallery_source() == mathilde_gallery
		and _window_option_count(runner, MARIE_ID) == 1
		and _instance_count(runner, MARIE_ID) == 0,
		"offre Marie préserve transcripts et Galerie avec zéro A5 avant clic",
	)
	_expect(
		_checkpoint_matches(SANDRA_ID, sandra_domain),
		"checkpoint disque Sandra COMPLETE conserve le domaine",
	)
	main.queue_free()
	await get_tree().process_frame
	main = await _new_main(false)
	if main == null:
		_finish()
		return
	runner = main.season_runner
	_expect(
		_opportunity_is(runner, MARIE_ID, "marie_thread", "Continuer avec Marie")
		and runner.catalog["facade"].save_state() == sandra_domain
		and runner.gallery_source() == mathilde_gallery
		and runner.presentation_source() == marie_source
		and _instance_count(runner, MARIE_ID) == 0,
		"reload reconstruit Marie sans session, A5 ni perte Sandra",
	)
	main.shell.messages_screen.runtime_delivery_time_scale = 1000.0
	main.shell.messages_screen.open_thread("marie_thread")
	await _frames(1)
	session = main.runtime_session
	_expect(
		session != null
		and runner.active_sequence_id == MARIE_ID
		and runner.describe_state()["active_session_count"] == 1
		and main.shell.messages_screen.active_thread_id == "marie_thread"
		and _instance_count(runner, MARIE_ID) == 1,
		"clic carte ouvre Marie avec une session et une matérialisation A5",
	)
	if session == null:
		_finish()
		return
	_cancel_ui_delivery(main.shell.messages_screen)
	session._messages_adapter.attach_messages_screen(null)
	_expect(await _complete_marie(main), "flow Marie N20 reste complet")
	await _frames(5)
	runner = main.season_runner
	_expect(
		runner.completed_sequence_ids == [MATHILDE_ID, SANDRA_ID, MARIE_ID]
		and runner.active_session == null
		and runner.active_sequence_id.is_empty()
		and runner.status() == SeasonRunner.IDLE_NO_ELIGIBLE_SEQUENCE
		and runner.describe_state()["opportunity"].is_empty(),
		"Marie COMPLETE converge vers IDLE sans opportunité",
	)
	_expect(
		_checkpoint_matches(MARIE_ID, runner.catalog["facade"].save_state()),
		"checkpoint disque final reste Marie COMPLETE",
	)
	main.queue_free()
	await get_tree().process_frame
	main = await _new_main(false)
	if main != null:
		_expect(
			main.season_runner.completed_sequence_ids == [MATHILDE_ID, SANDRA_ID, MARIE_ID]
			and main.season_runner.active_session == null
			and main.season_runner.status() == SeasonRunner.IDLE_NO_ELIGIBLE_SEQUENCE,
			"reload final converge avant rendu vers le même IDLE",
		)
		main.queue_free()
		await get_tree().process_frame
	_finish()


func _complete_mathilde(main) -> bool:
	var session = main.runtime_session
	if not (
		await _complete_current_messages(session)
		and await _continue_physical(main)
		and await _continue_physical(main)
	):
		return false
	for _index in range(3):
		if not await _continue_media(main):
			return false
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "mathilde_thread", "mathilde_mb3_ma1")).get("accepted", false):
		return false
	return await _complete_current_messages(session)


func _complete_sandra(session) -> bool:
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "sandra_thread", "sandra_button_echo_reply")).get("accepted", false):
		return false
	return await _complete_current_messages(session)


func _complete_marie(main) -> bool:
	var session = main.runtime_session
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "marie_thread", "marie_evening_guided_reply")).get("accepted", false):
		return false
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "marie_thread", "marie_evening_active")).get("accepted", false):
		return false
	if not await _complete_current_messages(session):
		return false
	return await _continue_physical(main)


func _new_main(expect_active: bool):
	var main = PortraitMainScene.instantiate()
	main.unified_save_path_override = SAVE_PATH
	add_child(main)
	await _frames(6)
	_expect(main.season_runner != null, "PortraitMain compose le catalogue production N21")
	if main.season_runner == null:
		main.queue_free()
		await get_tree().process_frame
		return null
	if expect_active:
		_expect(main.runtime_session != null, "une session active est attendue")
		if main.runtime_session == null:
			main.queue_free()
			await get_tree().process_frame
			return null
	else:
		_expect(main.runtime_session == null, "aucune session active pendant offre ou idle")
	main.shell.messages_screen.runtime_delivery_time_scale = 0.001
	return main


func _opportunity_is(runner, sequence_id: String, thread_id: String, action_label: String) -> bool:
	var state: Dictionary = runner.describe_state()
	return (
		runner.active_session == null
		and runner.active_sequence_id.is_empty()
		and runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
		and state.get("opportunity") == {
			"sequence_id": sequence_id,
			"thread_id": thread_id,
			"action_label": action_label,
		}
	)


func _offered_thread(source: Dictionary, thread_id: String, action_label: String) -> bool:
	for thread in source.get("threads", []):
		if str(thread.get("thread_id", "")) == thread_id:
			return (
				thread.get("availability_state") == SeasonRunner.OPPORTUNITY_AVAILABLE
				and thread.get("opportunity_action_label") == action_label
				and thread.get("last_preview") == "Nouveau moment disponible"
				and thread.get("unread_count") == 0
				and not thread.get("has_unread_content", true)
			)
	return false


func _window_option_count(runner, sequence_id: String) -> int:
	var package: Dictionary = runner.catalog["package_by_sequence_id"].get(sequence_id, {})
	if package.is_empty():
		return -1
	var window_id: String = package["sequence"]["orchestration"]["a8_window"]["window_id"]
	var window: Dictionary = runner.catalog["facade"]._coordinateur_a8.obtenir_fenetre(window_id)
	return window.get("options", []).size()


func _instance_count(runner, sequence_id: String) -> int:
	var expected := "unified_player_" + sequence_id
	var count := 0
	for instance in runner.catalog["facade"].save_state().get("scene_registry", []):
		if str(instance.get("instance_id", "")) == expected:
			count += 1
	return count


func _checkpoint_matches(sequence_id: String, domain: Dictionary) -> bool:
	var created := SaveStore.create(SAVE_PATH)
	if not created.get("ok", false):
		return false
	var loaded: Dictionary = created["store"].load_snapshot()
	if not loaded.get("ok", false):
		return false
	var snapshot: Dictionary = loaded["snapshot"]
	var runtime = snapshot.get("active_runtime_snapshot")
	return (
		snapshot.get("active_sequence_id") == sequence_id
		and typeof(runtime) == TYPE_DICTIONARY
		and runtime.get("execution", {}).get("execution_status") == "COMPLETE"
		and JsonNormalizer.normalize(runtime.get("domain")) == JsonNormalizer.normalize(domain)
	)


func _visible_threads(main) -> Array:
	return main.shell.messages_screen.conversation_list.threads.map(
		func(thread): return str(thread.get("thread_id", ""))
	)


func _cancel_ui_delivery(messages) -> void:
	messages.runtime_delivery_cancelled = true
	messages.runtime_delivery_active = false
	messages.runtime_delivery_request_id += 1
	messages.runtime_delivery_thread_id = ""
	messages.runtime_delivery_queue.clear()
	messages.runtime_delivery_pending_choices.clear()
	messages.runtime_delivery_pending_transition.clear()
	messages._set_runtime_delivery_interactions_blocked(false)


func _texts(source: Dictionary, thread_id: String) -> Array:
	return source.get("messages_by_thread", {}).get(thread_id, []).map(
		func(message): return message.get("text")
	)


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
		if message["message_id"] not in presented:
			if not session.mark_message_presented(str(message["message_id"])):
				return false
	var read: Dictionary = session.on_thread_read(thread_id, str(active_messages[-1]["message_id"]))
	await _frames(4)
	return read.get("ok", false)


func _select_choice(session, thread_id: String, choice_id: String) -> Dictionary:
	if not await _wait_for_status(session, "WAITING_FOR_PROJECTION_ACK"):
		return {"accepted": false, "error_code": "CHOICE_NOT_READY"}
	var choices: Array = session.presentation_source()["choices_by_thread"].get(thread_id, [])
	var ids: Array = choices.map(func(choice): return choice["choice_id"])
	if not session.on_choices_presented(thread_id, ids).get("ok", false):
		return {"accepted": false, "error_code": "CHOICE_PRESENTATION_REFUSED"}
	var selected: Dictionary = session.apply_choice(thread_id, choice_id)
	if not selected.get("accepted", false):
		return selected
	for bubble in selected.get("new_messages", []):
		session.mark_message_presented(str(bubble["message_id"]))
	session.mark_thread_batch_presented(thread_id)
	await _frames(4)
	return selected


func _continue_physical(main) -> bool:
	var session = main.runtime_session
	if not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	var prior_beat_id = session.execution_state().get("current_beat_id")
	var button = main.shell.messages_screen.find_child("PhysicalContinue", true, false)
	if button == null or not button.visible:
		return false
	button.emit_signal("pressed")
	await _frames(4)
	return session.execution_state().get("current_beat_id") != prior_beat_id


func _continue_media(main) -> bool:
	var session = main.runtime_session
	if not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	var prior_beat_id = session.execution_state().get("current_beat_id")
	var viewer = main.shell.photo_viewer
	if viewer == null or not viewer.visible or viewer.back_button == null:
		return false
	viewer.back_button.emit_signal("pressed")
	await _frames(4)
	return session.execution_state().get("current_beat_id") != prior_beat_id


func _wait_for_status(session, expected: String, max_frames := 90) -> bool:
	for _index in range(max_frames):
		if session != null and session.execution_state().get("execution_status") == expected:
			return true
		await get_tree().process_frame
	return false


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


func _finish() -> void:
	_remove_save(SAVE_PATH)
	if failures.is_empty():
		print("R8C_N21_VISIBLE_SINGLE_CANDIDATE_OPPORTUNITY: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)
