extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const SEASON_PROVIDER := preload("res://scripts/runtime/season_1/Season1RuntimeProvider.gd")
const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J06_PROVIDER := preload("res://scripts/runtime/season_1/J06RuntimeProvider.gd")

var failures: Array[String] = []
var capture_dir := ""

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var requested_size := _parse_size(_arg("--runtime-size", "720x1280"))
	capture_dir = _arg("--capture-dir", OS.get_environment("CAPTURE_DIR"))
	get_window().size = requested_size
	_exercise_bounded_state_paths()
	_exercise_provider_paths()
	await _exercise_real_portrait_path(requested_size)
	_finish(requested_size)

func _exercise_bounded_state_paths() -> void:
	var respectful = _prepared_j05_state(true, true)
	respectful.begin_j06()
	_expect(respectful.is_mathilde_j06_eligible(), "Mathilde respectful fixture eligible")
	_expect(respectful.apply_j06_mathilde_choice("choice_sun_mathilde_what_guided"), "Mathilde guided reply is manual")
	_expect(respectful.apply_j06_mathilde_choice("choice_sun_mathilde_acknowledge_gaze"), "Mathilde respectful choice accepted")
	_expect(respectful.mathilde_j06_outcome == "ACKNOWLEDGED_RESPECTFUL", "ACKNOWLEDGED_RESPECTFUL is distinct")
	_expect(respectful.mathilde_state == "LOOK_ACKNOWLEDGED", "respectful path reaches LOOK_ACKNOWLEDGED only")
	_expect(respectful.j06_external_continuity_resolution == "NO_PROMISE", "respectful path records NO_PROMISE")
	_expect(not respectful.promises.has("j06_external_continuity_window"), "respectful gaze does not invent P04")
	_expect(respectful.traces.has("j06_mathilde_look_acknowledged_01"), "respectful path creates T05")
	_expect(respectful.knowledge.has("fact_mathilde_knows_player_noticed_her"), "respectful path creates F09")

	var playful = _prepared_j05_state(true, true)
	playful.begin_j06()
	playful.apply_j06_mathilde_choice("choice_sun_mathilde_what_guided")
	_expect(playful.apply_j06_mathilde_choice("choice_sun_mathilde_playful_gaze"), "Mathilde playful choice accepted")
	_expect(playful.mathilde_j06_outcome == "ACKNOWLEDGED_PLAYFUL" and playful.mathilde_state == "LOOK_ACKNOWLEDGED", "ACKNOWLEDGED_PLAYFUL stays at LOOK_ACKNOWLEDGED")

	var distance = _prepared_j05_state(true, true)
	distance.begin_j06()
	var family_before := str(distance.mathilde_state)
	distance.apply_j06_mathilde_choice("choice_sun_mathilde_what_guided")
	_expect(distance.apply_j06_mathilde_choice("choice_sun_mathilde_restore_distance"), "Mathilde distance choice accepted")
	_expect(distance.mathilde_j06_outcome == "DISTANCE_RESTORED", "DISTANCE_RESTORED is distinct")
	_expect(distance.mathilde_state == family_before, "restore distance keeps FAMILY_GUEST rather than global DISTANCE")
	_expect(distance.traces.has("j06_mathilde_look_acknowledged_01") and distance.knowledge.has("fact_mathilde_knows_player_noticed_her"), "distance path keeps coherent T05/F09")

	var unavailable = _prepared_j05_state(true, false)
	unavailable.begin_j06()
	_expect(not unavailable.is_mathilde_j06_eligible(), "explicit DISTANCE blocks Mathilde J06")
	_expect(unavailable.record_j06_mathilde_unavailable(), "Mathilde unavailable recorded")
	_expect(unavailable.mathilde_j06_outcome == "UNAVAILABLE" and unavailable.j06_external_continuity_resolution == "UNAVAILABLE", "UNAVAILABLE state is bounded")
	_expect(not unavailable.traces.has("j06_mathilde_look_acknowledged_01") and not unavailable.knowledge.has("fact_mathilde_knows_player_noticed_her"), "unavailable path creates no T05/F09")
	_expect(unavailable.apply_j06_marie_choice("choice_sun_marie_warm_echo_guided"), "paid J05 without Mathilde uses warm guided echo")
	_expect(unavailable.marie_j06_return_outcome == "WARM_ECHO", "warm echo outcome stored")

	var refused = _prepared_j05_state(false, false)
	refused.begin_j06()
	refused.record_j06_mathilde_unavailable()
	var couple_before := str(refused.couple_state)
	_expect(refused.apply_j06_marie_choice("choice_sun_marie_return_honest_drift"), "independent path accepts honest drift")
	_expect(refused.marie_j06_return_outcome == "HONEST_DRIFT" and refused.couple_state == couple_before, "HONEST_DRIFT does not improve couple_state")

	var bounded = _prepared_j05_state(false, false)
	bounded.begin_j06()
	bounded.record_j06_mathilde_unavailable()
	_expect(bounded.apply_j06_marie_choice("choice_sun_marie_return_bounded"), "bounded Marie choice accepted")
	_expect(bounded.marie_j06_return_outcome == "BOUNDED_NEXT_ACT" and bounded.marie_j06_return_due_at == "J07 09:30", "bounded Marie choice stores J07 09:30 without promise id")
	_expect(not bounded.promises.has("j06_external_continuity_window"), "bounded Marie does not invent P04")

func _exercise_provider_paths() -> void:
	for test_case in [
		{"choice": "choice_sun_mathilde_acknowledge_gaze", "outcome": "ACKNOWLEDGED_RESPECTFUL"},
		{"choice": "choice_sun_mathilde_playful_gaze", "outcome": "ACKNOWLEDGED_PLAYFUL"},
		{"choice": "choice_sun_mathilde_restore_distance", "outcome": "DISTANCE_RESTORED"},
	]:
		var provider = _new_j06_provider(true, true)
		provider.start_day()
		_expect_provider_round_trip(provider, "snapshot before Mathilde opening")
		provider.apply_choice("thread_mathilde_private", "choice_sun_mathilde_what_guided")
		_expect_provider_round_trip(provider, "snapshot after Mathilde guided reply")
		provider.apply_choice("thread_mathilde_private", str(test_case["choice"]))
		_expect(provider.state.mathilde_j06_outcome == str(test_case["outcome"]), "provider stores " + str(test_case["outcome"]))
		_expect(provider.served_visual_beat_ids == ["S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01"], "Mathilde branch starts with J06-N01")
		_expect_provider_round_trip(provider, "snapshot after Mathilde final choice")
		var marie_notification: Dictionary = provider.confirm_transition()
		_expect(str(marie_notification.get("unlocked_thread_id", "")) == "thread_marie_private", "Marie is injected after household beat")
		_expect(str(marie_notification.get("notification", {}).get("body", "")) == "Nouveau message !", "Marie notification is neutral")
		_expect_provider_round_trip(provider, "snapshot before Marie")
		provider.apply_choice("thread_marie_private", "choice_sun_marie_return_bounded")
		_expect(provider.state.marie_j06_return_outcome == "BOUNDED_NEXT_ACT", "Marie bounded outcome stored after Mathilde")
		_expect_provider_round_trip(provider, "snapshot before CONTENT_END")
		provider.confirm_transition()
		_expect(provider.phase == "complete", "Mathilde path reaches CONTENT_END")
		_expect(provider.served_visual_beat_ids == [
			"S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01",
			"S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01",
			"S1_A2_J06_SCN_MARIE_CONCRETE_RETURN_01",
		], "Mathilde path serves exactly three ordered beats")
		_expect(provider.presentation_count_by_id("msg_sun_mathilde_afterglow_001") == 1, "Mathilde opening is not duplicated")
		_expect(not provider.state.promises.has("j06_external_continuity_window"), "provider never creates artificial P04")

	var unavailable = _new_j06_provider(true, false)
	unavailable.start_day()
	_expect(unavailable.phase == "marie_incoming", "unavailable Mathilde goes directly to Marie")
	_expect(unavailable.state.mathilde_j06_outcome == "UNAVAILABLE", "provider records unavailable Mathilde")
	_expect(unavailable.served_visual_beat_ids == [
		"S1_A2_J06_SCN_SUNDAY_WITHOUT_EXTERNAL_PROGRESS_01",
		"S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01",
	], "unavailable path serves J06-N02 then household beat")
	_expect(unavailable.choices_for("thread_marie_private")[0]["choice_id"] == "choice_sun_marie_warm_echo_guided", "paid J05 without Mathilde selects exact warm segment")
	unavailable.apply_choice("thread_marie_private", "choice_sun_marie_warm_echo_guided")
	unavailable.confirm_transition()
	_expect(unavailable.phase == "complete" and unavailable.state.marie_j06_return_outcome == "WARM_ECHO", "warm path completes J06")
	_expect(unavailable.served_visual_beat_ids.size() == 3, "unavailable path has exactly three beats")

	var independent = _new_j06_provider(false, false)
	independent.start_day()
	var choice_ids: Array[String] = []
	for choice in independent.choices_for("thread_marie_private"):
		choice_ids.append(str(choice.get("choice_id", "")))
	_expect(choice_ids == ["choice_sun_marie_return_immediate", "choice_sun_marie_return_bounded", "choice_sun_marie_return_honest_drift"], "refused J05 without Mathilde selects exact M3")
	independent.apply_choice("thread_marie_private", "choice_sun_marie_return_immediate")
	_expect(independent.state.marie_j06_return_outcome == "IMMEDIATE_ACT", "IMMEDIATE_ACT stored")
	independent.confirm_transition()
	independent.confirm_transition()
	_expect(independent.phase == "complete", "immediate path pays off-phone then reaches CONTENT_END")

func _prepared_j05_state(paid: bool, mathilde_available: bool):
	var result = SEASON_STATE.new()
	result.install_mathilde()
	result.complete_j04_household()
	if not mathilde_available:
		result.mathilde_state = "DISTANCE"
	result.begin_j05()
	if paid:
		result.apply_j05_marie_choice("choice_sat_marie_join_now")
	else:
		result.apply_j05_marie_choice("choice_sat_marie_moves_independently")
	result.resolve_j05_marie_hour()
	result.complete_day()
	return result

func _new_j06_provider(paid: bool, mathilde_available: bool):
	var shared_state = _prepared_j05_state(paid, mathilde_available)
	var provider = J06_PROVIDER.new()
	var threads := ["thread_marie_private", "thread_mathilde_private"]
	_expect(provider.initialize(shared_state, {}, {}, threads, ["S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01"]), "direct J06 provider initializes")
	return provider

func _expect_provider_round_trip(provider, label: String) -> void:
	var snapshot: Dictionary = provider.snapshot()
	var state_snapshot: Dictionary = provider.state.snapshot()
	var restored_state = SEASON_STATE.new()
	var restored = J06_PROVIDER.new()
	_expect(restored_state.restore_snapshot(state_snapshot), label + " state restore")
	_expect(restored.initialize(restored_state, {}, {}, [], []), label + " provider init")
	_expect(restored.restore_snapshot(snapshot), label + " provider restore_snapshot(snapshot)")
	_expect(restored.snapshot() == snapshot, label + " provider.snapshot() exact round trip")

func _exercise_real_portrait_path(size: Vector2i) -> void:
	var main = MAIN_SCENE.instantiate()
	add_child(main)
	await _frames(6)
	var shell = main.shell
	var messages = shell.messages_screen
	var provider = shell.runtime_provider
	shell.set_safe_area_preset("none")
	shell.set_reduced_motion_enabled(true)
	messages.runtime_delivery_time_scale = 0.01
	messages.reading_speed_multiplier = 8.0

	var completed_j05 = _season_at_completed_j05()
	_expect(provider.restore_snapshot(completed_j05.snapshot()), "mounted provider restores completed J05")
	_reset_messages_to_authority(messages, provider)
	await _frames(4)
	messages._start_runtime_day_card(provider.next_day_presentation())
	await _frames(3)
	await _capture("new_day", size)
	messages.day_transition.reset_surface()
	messages.day_transition_state = {}
	messages._set_screen_mode("list")
	messages.conversation_screen.visible = false
	messages.conversation_list.visible = true
	messages._set_gallery_navigation_blocked(false)
	var handoff_phases: Array[String] = []
	messages.time_passage_overlay.phase_changed.connect(func(phase_name: String): handoff_phases.append(phase_name))
	messages.call_deferred("_resume_authoritative_transition_flow")
	await _wait_until(func(): return provider.active_day == "J06" and provider.j06_provider.phase == "mathilde_incoming" and not messages.transition_flow_active, 480, "J05 to J06 UI handoff timed out")
	_expect(handoff_phases.has("NEW_DAY"), "J05 to J06 presents NEW_DAY")
	_expect(messages.screen_mode == "list", "J06 starts on conversation list")
	_expect(messages.thread_has_unread_content("thread_mathilde_private"), "Mathilde is unread at J06 start")
	_expect(_card_is_strong_unread(messages, "thread_mathilde_private"), "Mathilde unread preview is neutral and strongly emphasized")
	await _capture("mathilde_unread", size)

	await _press_thread_card(messages, "thread_mathilde_private", "opens Mathilde J06")
	await _wait_delivery(messages, "Mathilde opening delivery")
	_expect(not messages.thread_has_unread_content("thread_mathilde_private"), "Mathilde real preview restored after presentation")
	await _press_choice(messages, "choice_sun_mathilde_what_guided")
	await _wait_delivery(messages, "Mathilde guided reply")
	_expect(messages.conversation_screen.choice_bar.choice_count() == 3, "three Mathilde posture choices visible")
	await _capture("mathilde_choices", size)
	await _press_choice(messages, "choice_sun_mathilde_acknowledge_gaze")
	await _wait_until(func(): return provider.j06_provider.phase == "marie_incoming" and not messages.transition_flow_active, 480, "household beat did not inject Marie")
	_expect(messages.active_thread_id == "thread_mathilde_private", "Marie injection does not force navigation")
	_expect(messages.thread_has_unread_content("thread_marie_private"), "Marie stays unread after injection")
	await _wait_until(func(): return messages._notification_visible(), 90, "Marie notification missing")
	_expect(str(messages.active_notification.get("thread_id", "")) == "thread_marie_private", "notification targets Marie")
	_expect(str(messages.active_notification.get("preview", "")) == "Nouveau message !", "Marie notification body is neutral")
	await _capture("marie_notification", size)

	_activate_notification(messages)
	await _wait_until(func(): return messages.active_thread_id == "thread_marie_private", 90, "Marie notification did not open Marie")
	await _wait_delivery(messages, "Marie return delivery")
	_expect(messages.conversation_screen.choice_bar.choice_count() == 3, "three M3 choices visible")
	await _capture("marie_choices", size)
	await _press_choice(messages, "choice_sun_marie_return_bounded")
	await _wait_until(func(): return provider.j06_provider.phase == "complete" and messages.is_day_transition_active(), 480, "J06 CONTENT_END timed out")
	_expect(str(provider.content_end().get("transition_mode", "")) == "CONTENT_END", "CONTENT_END exists only after J06")
	_expect(str(messages.day_transition.display_title()) == "J06 terminé", "J06 terminal card visible")
	_expect(provider.j06_provider.served_visual_beat_ids.size() == 3, "real UI path serves exactly three beats")
	_expect(not bool(shell.describe_layout().get("has_vertical_crop", true)) and not bool(messages.describe_state().get("has_horizontal_crop", true)), "responsive J06 has no crop")
	await _capture("content_end", size)

	var snapshot: Dictionary = provider.snapshot()
	var restored = SEASON_PROVIDER.new()
	_expect(restored.initialize() and restored.restore_snapshot(snapshot) and restored.snapshot() == snapshot, "J06 season snapshot round trip")
	main.queue_free()
	await _frames(8)

func _season_at_completed_j05():
	var season = _season_at_completed_j04()
	_expect(bool(season.automatic_day_handoff().get("accepted", false)), "fixture starts J05")
	season.apply_choice("thread_marie_private", "choice_sat_marie_join_now")
	season.confirm_transition()
	season.apply_choice("thread_sandra_private", "choice_sat_sandra_autonomy")
	season.confirm_transition()
	_expect(season.active_day == "J05" and season.j05_provider.phase == "complete", "fixture reaches completed J05")
	return season

func _season_at_completed_j04():
	var season = _season_at_completed_j03()
	_expect(bool(season.automatic_day_handoff().get("accepted", false)), "fixture starts J04")
	season.apply_choice("thread_pauline_private", "choice_friday_pauline_contract_guided")
	season.apply_choice("thread_pauline_private", "choice_friday_pauline_dry")
	season.commit_narrative_time(14 * 60 + 5)
	season.confirm_transition()
	season.apply_choice("thread_nico_private", "choice_friday_nico_reservation_guided")
	season.apply_choice("thread_nico_private", "choice_friday_nico_honest")
	season.apply_choice("thread_nico_private", "choice_friday_nico_mathilde_guided")
	season.commit_narrative_time(18 * 60 + 5)
	season.confirm_transition()
	for thread_id in season.j04_provider.transcripts_by_thread:
		for message in season.j04_provider.transcripts_by_thread[thread_id]:
			if int(message.get("source_day", 0)) == 4:
				season.mark_message_presented(str(message.get("message_id", "")))
	season.mark_thread_batch_presented("thread_marie_private")
	season.commit_narrative_time(18 * 60 + 25)
	season.confirm_transition()
	_expect(season.active_day == "J04" and season.j04_provider.phase == "complete", "fixture reaches completed J04")
	return season

func _season_at_completed_j03():
	var season = SEASON_PROVIDER.new()
	_expect(season.initialize(), "fixture provider initializes")
	for id in ["choice_j1_marie_optimism_guided", "choice_j1_marie_crisis_guided", "choice_j1_marie_present", "choice_j1_marie_laverriere_guided", "choice_j1_marie_mathilde_guided"]:
		season.apply_choice("thread_marie_private", id)
	season.confirm_transition()
	for id in ["choice_j1_sandra_what_guided", "choice_j1_sandra_art_guided", "choice_j1_sandra_safe_warmth", "choice_j1_sandra_thanks_guided", "choice_j1_sandra_goodnight_guided"]:
		season.apply_choice("thread_sandra_private", id)
	season.confirm_transition()
	season.confirm_day_transition()
	season.confirm_day_transition()
	season.apply_choice("thread_marie_private", "choice_wed_marie_emergency_guided")
	season.apply_choice("thread_marie_private", "choice_wed_make_room_proactive")
	season.confirm_day_transition()
	season.on_thread_returned("thread_marie_private")
	season.confirm_day_transition()
	season.apply_choice("thread_mathilde_private", "choice_wed_mathilde_practical")
	season.confirm_transition()
	season.confirm_day_transition()
	season.confirm_day_transition()
	season.apply_choice("thread_raphaelle_private", "choice_thu_raph_method_guided")
	season.apply_choice("thread_raphaelle_private", "choice_thu_raph_accountable")
	season.confirm_transition()
	if season.j03_provider.phase == "sandra_offer":
		season.confirm_secondary_day_transition()
	season.confirm_day_transition()
	season.apply_choice("thread_marie_private", "choice_j3_marie_evening_why_guided")
	season.apply_choice("thread_marie_private", "choice_j3_marie_return_active")
	season.confirm_transition()
	_expect(season.active_day == "J03" and season.j03_provider.phase == "complete", "fixture reaches completed J03")
	return season

func _reset_messages_to_authority(messages, provider) -> void:
	messages.runtime_delivery_cancelled = true
	messages.runtime_delivery_active = false
	messages.runtime_delivery_request_id += 1
	messages.transition_flow_active = false
	messages.transition_flow_request_id += 1
	messages.time_passage_overlay.cancel_flow()
	messages.active_thread_id = ""
	messages.screen_mode = "list"
	messages.runtime_provider_transcript_by_thread.clear()
	messages.runtime_presented_message_ids_by_thread.clear()
	messages.runtime_pending_messages_by_thread.clear()
	messages.runtime_pending_choices_by_thread.clear()
	messages.runtime_pending_transition_by_thread.clear()
	var source: Dictionary = provider.presentation_source()
	messages._initialize_runtime_source(source)
	for raw_thread_id in source.get("messages_by_thread", {}):
		var thread_id := str(raw_thread_id)
		var historical: Array[Dictionary] = messages._dictionary_array(source["messages_by_thread"][raw_thread_id])
		messages.transcripts[thread_id] = historical
		var ids: Array = []
		for message in historical:
			ids.append(str(message.get("message_id", "")))
		messages.runtime_presented_message_ids_by_thread[thread_id] = ids
	messages._reconcile_runtime_source(source)
	messages._build()
	messages.runtime_delivery_cancelled = false

func _press_thread_card(messages, thread_id: String, failure: String) -> void:
	var card = _thread_card(messages, thread_id)
	_expect(card != null, failure)
	if card != null:
		card.emit_signal("pressed")
		await _wait_until(func(): return messages.screen_mode == "conversation" and messages.active_thread_id == thread_id, 90, failure + " did not activate")

func _thread_card(messages, thread_id: String):
	for index in range(messages.conversation_list.threads.size()):
		if str(messages.conversation_list.threads[index].get("thread_id", "")) == thread_id:
			return messages.conversation_list.cards[index]
	return null

func _press_choice(messages, choice_id: String) -> void:
	await _wait_delivery(messages, "before choice " + choice_id)
	var button = _choice_button(messages, choice_id)
	_expect(button != null, "real choice button " + choice_id)
	if button != null:
		button.emit_signal("pressed")
		await _wait_delivery(messages, "delivery after " + choice_id)

func _choice_button(messages, choice_id: String):
	for index in range(messages.conversation_screen.choice_bar.choices.size()):
		if str(messages.conversation_screen.choice_bar.choices[index].get("choice_id", "")) == choice_id:
			return messages.conversation_screen.choice_bar.buttons[index]
	return null

func _activate_notification(messages) -> void:
	var event := InputEventAction.new()
	event.action = "ui_accept"
	event.pressed = true
	if messages.screen_mode == "list":
		messages.notification_banner.emit_signal("gui_input", event)
	else:
		messages.conversation_screen.header_notification.emit_signal("gui_input", event)

func _wait_delivery(messages, label: String) -> void:
	await get_tree().process_frame
	await _wait_until(func(): return not messages.runtime_delivery_active and messages.runtime_delivery_queue.is_empty() and not messages.conversation_screen.typing_visible(), 900, label + " timed out")

func _wait_until(predicate: Callable, frames: int, failure: String) -> void:
	for _index in range(frames):
		if predicate.call():
			return
		await get_tree().process_frame
	_expect(false, failure)

func _card_is_strong_unread(messages, thread_id: String) -> bool:
	var view: Dictionary = messages.conversation_list.card_views.get(thread_id, {})
	if view.is_empty():
		return false
	var name: Label = view.get("display_name")
	var preview: Label = view.get("preview")
	var name_font: Font = name.get_theme_font("font")
	var preview_font: Font = preview.get_theme_font("font")
	return preview.text == "Nouveau message !" and name_font is FontVariation and preview_font is FontVariation and is_equal_approx(name_font.variation_embolden, 1.5) and is_equal_approx(preview_font.variation_embolden, 1.5)

func _capture(label: String, size: Vector2i) -> void:
	if capture_dir == "" or DisplayServer.get_name() == "headless":
		return
	DirAccess.make_dir_recursive_absolute(capture_dir)
	await get_tree().process_frame
	var path := capture_dir.path_join("%dx%d_%s.png" % [size.x, size.y, label])
	var image := get_viewport().get_texture().get_image()
	if image.get_size() != size:
		image.convert(Image.FORMAT_RGBA8)
		var canvas := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
		canvas.fill(Color("#02040C"))
		canvas.blit_rect(image, Rect2i(Vector2i.ZERO, image.get_size()), Vector2i((size.x - image.get_width()) / 2, (size.y - image.get_height()) / 2))
		image = canvas
	var error := image.save_png(path)
	_expect(error == OK, "capture failed: " + path)

func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame

func _arg(prefix: String, fallback: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="):
			return arg.trim_prefix(prefix + "=")
	return fallback

func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x")
	return Vector2i(int(parts[0]), int(parts[1])) if parts.size() == 2 else Vector2i.ZERO

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _finish(size: Vector2i) -> void:
	if failures.is_empty():
		print("RUNTIME-S1-06 J06 real PortraitMain smoke %dx%d: OK" % [size.x, size.y])
		get_tree().call_deferred("quit", 0)
		return
	for failure in failures:
		push_error(failure)
	print("RUNTIME-S1-06 J06 real PortraitMain smoke: FAILED (%d)" % failures.size())
	get_tree().call_deferred("quit", 1)
