extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const SEASON_PROVIDER := preload("res://scripts/runtime/season_1/Season1RuntimeProvider.gd")
const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J07_PROVIDER := preload("res://scripts/runtime/season_1/J07RuntimeProvider.gd")

var failures: Array[String] = []
var capture_dir := ""

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var requested_size := _parse_size(_arg("--runtime-size", "720x1280"))
	capture_dir = _arg("--capture-dir", OS.get_environment("CAPTURE_DIR"))
	get_window().size = requested_size
	_exercise_state_and_provider_paths()
	await _exercise_real_portrait_path(requested_size)
	_finish(requested_size)

func _exercise_state_and_provider_paths() -> void:
	var due = _prepared_j06_state(true, false)
	var provider = _new_j07_provider(due)
	var promises_before_morning: int = due.promises.size()
	var start: Dictionary = provider.start_day()
	_expect(bool(start.get("accepted", false)), "J07 starts from complete J06")
	_expect(due.marie_j06_return_resolution == "PAID", "due J06 consequence is paid at J07 09:30")
	_expect(due.promises.size() == promises_before_morning, "morning consequence creates no promise")
	_expect(provider.served_visual_beat_ids.is_empty(), "morning consequence creates no visual beat")
	_expect(provider.confirm_transition().get("focus_thread_id", "") == "thread_raphaelle_private", "morning transitions to Raphaëlle")
	_expect(provider.phase == "raphaelle_incoming", "Raphaëlle incoming phase")
	_expect_provider_round_trip(provider, "snapshot at Raphaëlle incoming")
	provider.apply_choice("thread_raphaelle_private", "choice_j07_raphaelle_acknowledge_guided")
	provider.apply_choice("thread_raphaelle_private", "choice_j07_raphaelle_understood_guided")
	_expect(due.raphaelle_j07_mobile_review_outcome == "RESPONSIBILITY_ACKNOWLEDGED", "P05 acknowledgement stored")
	_expect(str(due.promises.get("raphaelle_j07_mobile_review", {}).get("status", "")) == "ACTIVE", "P05 is ACTIVE")
	_expect(str(due.raphaelle_state) == "PROFESSIONAL_ONLY", "Raphaëlle stays professional only")
	_expect(provider.served_visual_beat_ids == ["S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01"], "Raphaëlle is first visual beat")

	var no_due = _prepared_j06_state(false, true)
	var no_due_provider = _new_j07_provider(no_due)
	no_due_provider.start_day()
	_expect(no_due.marie_j06_return_resolution == "NOT_DUE", "ordinary morning records NOT_DUE")
	_expect(no_due_provider.served_visual_beat_ids.is_empty(), "ordinary morning has no filler beat")
	no_due_provider.confirm_transition()
	_expect(no_due_provider.presentation_count_by_id("msg_j07_raphaelle_mobile_003_delayed") == 1, "DELAYED J03 uses exact Raphaëlle variant")
	_expect(no_due_provider.presentation_count_by_id("msg_j07_raphaelle_mobile_003_normal") == 0, "DELAYED J03 excludes normal line")

	var main_cases := {
		"choice_j07_nico_acknowledge_contradiction": "CONTRADICTION_ACKNOWLEDGED",
		"choice_j07_nico_request_social_view": "SOCIAL_VIEW_REQUESTED",
		"choice_j07_nico_stay_vague": "CONFIDENCE_DECLINED",
	}
	var continuation_cases := {
		"choice_j07_nico_tuesday_accepted": "TUESDAY_ACCEPTED",
		"choice_j07_nico_thursday_conditional": "THURSDAY_CONDITIONAL",
		"choice_j07_nico_continuation_closed": "CONTINUATION_CLOSED",
	}
	for main_choice in main_cases:
		for continuation_choice in continuation_cases:
			var combo = _new_j07_provider(_prepared_j06_state(false, false))
			_advance_to_nico(combo)
			combo.apply_choice("thread_nico_private", "choice_j07_nico_topic_guided")
			combo.apply_choice("thread_nico_private", "choice_j07_nico_what_mean_guided")
			combo.apply_choice("thread_nico_private", main_choice)
			_expect(combo.state.nico_j07_confidence_outcome == main_cases[main_choice], "Nico main outcome " + str(main_cases[main_choice]))
			_expect(combo.state.nico_state == "CONFIDENCE_ACTIVE", "Nico reaches CONFIDENCE_ACTIVE only")
			_expect(combo.state.traces.has("j07_nico_confidence_01"), "T06 created once")
			_expect(combo.state.knowledge.has("fact_nico_received_player_confidence"), "F10 created once")
			var f10: Dictionary = combo.state.knowledge["fact_nico_received_player_confidence"]
			_expect(str(f10.get("branch_outcome", "")) == main_cases[main_choice] and f10.get("scope", []).size() == 4, "F10 scope matches main branch")
			combo.apply_choice("thread_nico_private", "choice_j07_nico_at_least_said_guided")
			combo.apply_choice("thread_nico_private", continuation_choice)
			_expect(combo.state.nico_j07_continuation_outcome == continuation_cases[continuation_choice], "Nico continuation " + str(continuation_cases[continuation_choice]))
			_assert_nico_promise(combo.state, continuation_cases[continuation_choice])
			_expect(combo.state.traces.size() >= 1 and combo.state.knowledge.size() >= 3, "prior records are preserved")
			_expect_provider_round_trip(combo, "snapshot after Nico " + str(main_cases[main_choice]) + "/" + str(continuation_cases[continuation_choice]))

	var marie_cases := {
		"choice_j07_marie_presence_confirmed": ["PRESENCE_CONFIRMED", "ACTIVE", "J08 19:15"],
		"choice_j07_marie_precise_alternative": ["PRECISE_ALTERNATIVE", "AMENDED", "J08 18:30"],
		"choice_j07_marie_honest_refusal": ["HONEST_REFUSAL", "REFUSED", ""],
	}
	for marie_choice in marie_cases:
		var path = _new_j07_provider(_prepared_j06_state(false, false))
		_advance_to_marie(path)
		var mathilde_before := str(path.state.mathilde_state)
		var couple_before := str(path.state.couple_state)
		path.apply_choice("thread_marie_private", marie_choice)
		var expected: Array = marie_cases[marie_choice]
		var p08: Dictionary = path.state.promises.get("marie_j07_household_request", {})
		_expect(path.state.marie_j07_household_outcome == expected[0], "Marie outcome " + str(expected[0]))
		_expect(str(p08.get("status", "")) == expected[1] and str(p08.get("due_at", "")) == expected[2], "P08 exact state for " + str(expected[0]))
		_expect(path.state.mathilde_state == mathilde_before and path.state.couple_state == couple_before, "Marie choice preserves Mathilde and couple states")
		path.confirm_transition()
		_expect(path.phase == "complete", "Marie path reaches CONTENT_END")
		_expect(path.served_visual_beat_ids == [
			"S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01",
			"S1_A2_J07_SCN_NICO_AFTER_SERVICE_CONFIDENCE_01",
			"S1_A2_J07_SCN_MARIE_HOUSEHOLD_REQUEST_01",
		], "every J07 path serves exactly three ordered beats")
		_expect(path.state.foreground_history.slice(-3) == [
			{"day_id": "J07", "character_id": "raphaelle", "function": "professional_secondary"},
			{"day_id": "J07", "character_id": "nico", "function": "major_pivot"},
			{"day_id": "J07", "character_id": "marie", "function": "household_return"},
		], "foreground functions distinguish pivot, secondary and return")

func _assert_nico_promise(state, outcome: String) -> void:
	var has_p06: bool = state.promises.has("nico_j07_tuesday_1845")
	var has_p07: bool = state.promises.has("nico_j07_thursday_conditional")
	if outcome == "TUESDAY_ACCEPTED":
		_expect(has_p06 and not has_p07, "N1 creates only P06")
		var p06_active: Dictionary = state.promises["nico_j07_tuesday_1845"]
		_expect(p06_active["status"] == "ACTIVE" and p06_active["accepted_by_player"] == true, "N1 creates a genuinely accepted P06 ACTIVE")
		_expect(p06_active["accepted_at"] == "J07 23:01" and p06_active["due_at"] == "J08 18:45", "N1 keeps exact acceptance and due times")
		_expect(str(p06_active.get("paid_or_closed_at", "")) == "", "N1 has no closure timestamp")
	elif outcome == "THURSDAY_CONDITIONAL":
		_expect(not has_p06 and has_p07 and state.promises["nico_j07_thursday_conditional"]["status"] == "CONDITIONAL", "N2 creates only P07 CONDITIONAL")
		_expect(state.promises["nico_j07_thursday_conditional"]["due_at"] == "" and state.promises["nico_j07_thursday_conditional"]["confirmation_deadline"] == "J10 12:00", "P07 keeps no activated due_at and exact deadline")
	else:
		_expect(has_p06 and not has_p07, "N3 creates P06 and keeps P07 absent")
		var p06_refused: Dictionary = state.promises["nico_j07_tuesday_1845"]
		_expect(p06_refused["status"] == "REFUSED" and p06_refused["accepted_by_player"] == false, "N3 creates P06 REFUSED without player acceptance")
		_expect(p06_refused["accepted_at"] == "" and p06_refused["due_at"] == "", "N3 has no acceptance or due time")
		_expect(p06_refused["paid_or_closed_at"] == "J07 23:01" and p06_refused["paid_or_closed_by"] == "Player", "N3 records an attributable closure")

func _advance_to_nico(provider) -> void:
	provider.start_day()
	provider.confirm_transition()
	provider.apply_choice("thread_raphaelle_private", "choice_j07_raphaelle_acknowledge_guided")
	provider.apply_choice("thread_raphaelle_private", "choice_j07_raphaelle_understood_guided")
	provider.confirm_transition()

func _advance_to_marie(provider) -> void:
	_advance_to_nico(provider)
	provider.apply_choice("thread_nico_private", "choice_j07_nico_topic_guided")
	provider.apply_choice("thread_nico_private", "choice_j07_nico_what_mean_guided")
	provider.apply_choice("thread_nico_private", "choice_j07_nico_acknowledge_contradiction")
	provider.apply_choice("thread_nico_private", "choice_j07_nico_at_least_said_guided")
	provider.apply_choice("thread_nico_private", "choice_j07_nico_tuesday_accepted")
	provider.confirm_transition()

func _prepared_j06_state(due: bool, delayed: bool):
	var result = SEASON_STATE.new()
	result.current_day = "J06"
	result.day_status = "COMPLETE"
	result.raphaelle_state = "PROFESSIONAL_ONLY"
	result.raphaelle_work_outcome = "DELAYED" if delayed else "ACCOUNTABLE"
	result.mathilde_state = "FAMILY_GUEST"
	result.pauline_state = "PUBLIC_ONLY"
	result.nico_state = "ORDINARY_FRIEND"
	result.mathilde_j06_outcome = "UNAVAILABLE"
	result.j06_external_continuity_resolution = "UNAVAILABLE"
	result.marie_j06_return_outcome = "BOUNDED_NEXT_ACT" if due else "HONEST_DRIFT"
	result.marie_j06_return_due_at = "J07 09:30" if due else ""
	return result

func _new_j07_provider(shared_state):
	var provider = J07_PROVIDER.new()
	var threads := ["thread_marie_private", "thread_sandra_private", "thread_mathilde_private", "thread_raphaelle_private", "thread_pauline_private", "thread_nico_private"]
	_expect(provider.initialize(shared_state, {}, {}, threads, []), "direct J07 provider initializes")
	return provider

func _expect_provider_round_trip(provider, label: String) -> void:
	var snapshot: Dictionary = provider.snapshot()
	var state_snapshot: Dictionary = provider.state.snapshot()
	var restored_state = SEASON_STATE.new()
	var restored = J07_PROVIDER.new()
	_expect(restored_state.restore_snapshot(state_snapshot), label + " state restore")
	_expect(restored.initialize(restored_state, {}, {}, [], []), label + " provider init")
	_expect(restored.restore_snapshot(snapshot), label + " provider restore_snapshot(snapshot)")
	_expect(restored.snapshot() == snapshot, label + " exact round trip")
	if restored_state.nico_j07_continuation_outcome != "UNESTABLISHED":
		_assert_nico_promise(restored_state, restored_state.nico_j07_continuation_outcome)

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

	var completed_j06 = _season_at_completed_j06()
	_expect(provider.restore_snapshot(completed_j06.snapshot()), "mounted provider restores completed J06")
	_reset_messages_to_authority(messages, provider)
	await _frames(4)
	messages._start_runtime_day_card(provider.next_day_presentation())
	await _frames(3)
	await _capture("j07_handoff", size)
	messages.day_transition.reset_surface()
	messages.day_transition_state = {}
	messages._set_screen_mode("list")
	messages.conversation_screen.visible = false
	messages.conversation_list.visible = true
	messages._set_gallery_navigation_blocked(false)
	messages.call_deferred("_resume_authoritative_transition_flow")
	await _wait_until(func(): return provider.active_day == "J07" and provider.j07_provider.phase == "raphaelle_incoming" and not messages.transition_flow_active, 600, "J06 to J07 handoff timed out")
	_expect(messages.screen_mode == "list", "J07 starts on list")
	_expect(messages.thread_has_unread_content("thread_raphaelle_private"), "Raphaëlle batch is unread")
	_expect(_card_is_strong_unread(messages, "thread_raphaelle_private"), "Raphaëlle unread preview is neutral and bold")
	await _capture("raphaelle_unread", size)

	await _press_thread_card(messages, "thread_raphaelle_private", "opens Raphaëlle J07")
	await _wait_delivery(messages, "Raphaëlle opening")
	_expect(not messages.thread_has_unread_content("thread_raphaelle_private"), "Raphaëlle preview restored after presentation")
	await _capture("raphaelle_conversation", size)
	await _press_choice(messages, "choice_j07_raphaelle_acknowledge_guided")
	await _press_choice(messages, "choice_j07_raphaelle_understood_guided")
	await _wait_until(func(): return provider.j07_provider.phase == "nico_incoming" and not messages.transition_flow_active, 600, "Nico injection timed out")
	_expect(messages.active_thread_id == "thread_raphaelle_private", "Nico injection does not force navigation")
	_expect(messages.thread_has_unread_content("thread_nico_private"), "Nico remains unread")
	await _activate_notification(messages, "thread_nico_private")
	await _wait_delivery(messages, "Nico opening")
	await _press_choice(messages, "choice_j07_nico_topic_guided")
	await _press_choice(messages, "choice_j07_nico_what_mean_guided")
	_expect(messages.conversation_screen.choice_bar.choice_count() == 3, "three Nico main choices visible")
	await _capture("nico_main_choices", size)
	await _press_choice(messages, "choice_j07_nico_acknowledge_contradiction")
	await _press_choice(messages, "choice_j07_nico_at_least_said_guided")
	_expect(messages.conversation_screen.choice_bar.choice_count() == 3, "three Nico continuation choices visible")
	await _capture("nico_continuation_choices", size)
	await _press_choice(messages, "choice_j07_nico_tuesday_accepted")
	await _wait_until(func(): return provider.j07_provider.phase == "marie_incoming" and not messages.transition_flow_active, 600, "Marie injection timed out")
	_expect(messages.active_thread_id == "thread_nico_private", "Marie injection does not force navigation")
	_expect(messages.thread_has_unread_content("thread_marie_private"), "Marie remains unread")
	await _activate_notification(messages, "thread_marie_private")
	await _capture("marie_conversation", size)
	await _wait_delivery(messages, "Marie opening")
	_expect(messages.conversation_screen.choice_bar.choice_count() == 3, "three Marie choices visible")
	await _capture("marie_choices", size)
	await _press_choice(messages, "choice_j07_marie_presence_confirmed")
	await _wait_until(func(): return provider.j07_provider.phase == "complete" and not messages.transition_flow_active, 600, "J07 completion timed out")
	_expect(provider.content_end().is_empty(), "J07 is no longer CONTENT_END")
	_expect(str(provider.j07_provider.runtime_map["day_end"]["next_day_presentation"].get("title", "")) == "Ce qui ne tient pas ensemble", "J07 exposes the J08 handoff")
	_expect(provider.j07_provider.served_visual_beat_ids.size() == 3, "real UI path serves exactly three beats")
	messages.call_deferred("_resume_authoritative_transition_flow")
	await _wait_until(func(): return provider.active_day == "J08" and provider.j08_provider.phase == "marie_entry_incoming" and not messages.transition_flow_active, 600, "J07 to J08 handoff timed out")
	_expect(provider.j07_provider.phase == "complete", "J07 remains complete after handoff")
	_expect(not bool(shell.describe_layout().get("has_vertical_crop", true)) and not bool(messages.describe_state().get("has_horizontal_crop", true)), "responsive J07 has no crop")
	await _capture("j08_handoff", size)

	messages.day_transition.reset_surface()
	messages.day_transition_state = {}
	messages._set_gallery_navigation_blocked(false)
	shell.gallery_screen.refresh_content_source(provider.gallery_source())
	shell.activate_gallery(false)
	await _frames(4)
	_expect(_gallery_has_j07_assets(shell.gallery_screen), "Gallery contains all three J07 placeholders once")
	await _capture("gallery_j07", size)

	var snapshot: Dictionary = provider.snapshot()
	var restored = SEASON_PROVIDER.new()
	var restore_initialized: bool = restored.initialize()
	var restore_accepted: bool = restore_initialized and restored.restore_snapshot(snapshot)
	var restore_exact: bool = restore_accepted and restored.snapshot() == snapshot
	_expect(restore_initialized, "J07 season snapshot initializes")
	_expect(restore_accepted, "J07 season snapshot restores")
	_expect(restore_exact, "J07 season snapshot round trip")
	main.queue_free()
	await _frames(8)

func _gallery_has_j07_assets(gallery) -> bool:
	var source: Dictionary = gallery.fixtures
	var count := 0
	for character_id in source:
		for item in source[character_id].get("items", []):
			if str(item.get("asset_id", "")).begins_with("S1_A2_J07_"):
				count += 1
	return count == 3

func _season_at_completed_j06():
	var season = _season_at_completed_j05()
	_expect(bool(season.automatic_day_handoff().get("accepted", false)), "fixture starts J06")
	season.apply_choice("thread_mathilde_private", "choice_sun_mathilde_what_guided")
	season.apply_choice("thread_mathilde_private", "choice_sun_mathilde_acknowledge_gaze")
	season.confirm_transition()
	season.apply_choice("thread_marie_private", "choice_sun_marie_return_bounded")
	season.confirm_transition()
	_expect(season.active_day == "J06" and season.j06_provider.phase == "complete", "fixture reaches completed J06")
	return season

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

func _activate_notification(messages, expected_thread_id: String) -> void:
	await _wait_until(func(): return messages._notification_visible(), 90, "notification missing for " + expected_thread_id)
	_expect(str(messages.active_notification.get("thread_id", "")) == expected_thread_id, "notification targets " + expected_thread_id)
	_expect(str(messages.active_notification.get("preview", "")) == "Nouveau message !", "notification is neutral")
	var event := InputEventAction.new()
	event.action = "ui_accept"
	event.pressed = true
	if messages.screen_mode == "list":
		messages.notification_banner.emit_signal("gui_input", event)
	else:
		messages.conversation_screen.header_notification.emit_signal("gui_input", event)
	await _wait_until(func(): return messages.active_thread_id == expected_thread_id, 90, "notification did not open " + expected_thread_id)

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
		print("RUNTIME-S1-07 J07 real PortraitMain smoke %dx%d: OK" % [size.x, size.y])
		get_tree().call_deferred("quit", 0)
		return
	for failure in failures:
		push_error(failure)
	print("RUNTIME-S1-07 J07 real PortraitMain smoke: FAILED (%d)" % failures.size())
	get_tree().call_deferred("quit", 1)
