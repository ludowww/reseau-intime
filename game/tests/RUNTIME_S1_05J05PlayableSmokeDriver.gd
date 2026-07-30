extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const SEASON_PROVIDER := preload("res://scripts/runtime/season_1/Season1RuntimeProvider.gd")
const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J05_PROVIDER := preload("res://scripts/runtime/season_1/J05RuntimeProvider.gd")

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var requested_size := _parse_size(_arg("--runtime-size", "720x1280"))
	get_window().size = requested_size
	_exercise_bounded_state_paths()
	_exercise_provider_paths()
	await _exercise_real_portrait_path()
	_finish(requested_size)

func _exercise_bounded_state_paths() -> void:
	var join = _eligible_j05_state()
	_expect(not join.promises.has("marie_j05_shared_hour"), "JOIN_NOW: P03 absent before choice")
	_expect(join.apply_j05_marie_choice("choice_sat_marie_join_now"), "JOIN_NOW accepted")
	var join_promise: Dictionary = join.promises.get("marie_j05_shared_hour", {})
	_expect(str(join_promise.get("status", "")) == "ACTIVE" and str(join_promise.get("due_at", "")) == "J05 09:48", "JOIN_NOW: P03 ACTIVE at J05 09:48")
	_expect(join.resolve_j05_marie_hour() and str(join.promises["marie_j05_shared_hour"]["status"]) == "PAID", "JOIN_NOW: P03 PAID after off-phone hour")
	_expect(join.is_sandra_j05_eligible(), "JOIN_NOW: Sandra eligible after paid hour")
	_expect(join.apply_j05_sandra_choice("choice_sat_sandra_keep") and join.sandra_j05_outcome == "THREAD_MAINTAINED", "JOIN_NOW: safe Sandra outcome")

	var alternative = _eligible_j05_state()
	_expect(alternative.apply_j05_marie_choice("choice_sat_marie_bounded_alternative"), "PRECISE_ALTERNATIVE accepted")
	var amended: Dictionary = alternative.promises.get("marie_j05_shared_hour", {})
	_expect(str(amended.get("status", "")) == "AMENDED" and str(amended.get("due_at", "")) == "J05 12:30", "PRECISE_ALTERNATIVE: one AMENDED P03 at J05 12:30")
	_expect(alternative.promises.size() == 2, "PRECISE_ALTERNATIVE: no second promise id")
	_expect(alternative.resolve_j05_marie_hour() and str(alternative.promises["marie_j05_shared_hour"]["status"]) == "PAID", "PRECISE_ALTERNATIVE: P03 PAID")

	var refused = _eligible_j05_state()
	var couple_before: String = str(refused.couple_state)
	_expect(refused.apply_j05_marie_choice("choice_sat_marie_moves_independently"), "REFUSED accepted")
	_expect(not refused.promises.has("marie_j05_shared_hour"), "REFUSED: no P03")
	_expect(refused.resolve_j05_marie_hour() and refused.marie_j05_shared_hour_resolution == "NO_PROMISE", "REFUSED: NO_PROMISE")
	_expect(not refused.is_sandra_j05_eligible(), "REFUSED: no Sandra")
	_expect(refused.record_sandra_j05_unavailable() and refused.sandra_j05_outcome == "UNAVAILABLE", "REFUSED: Marie fallback")
	_expect(refused.couple_state == couple_before, "REFUSED: couple_state unchanged")

	var unavailable = SEASON_STATE.new()
	unavailable.begin_j05()
	unavailable.activate_sandra_trace()
	_expect(unavailable.apply_j05_marie_choice("choice_sat_marie_join_now") and unavailable.resolve_j05_marie_hour(), "UNAVAILABLE fixture resolves Marie")
	_expect(not unavailable.is_sandra_j05_eligible(), "UNAVAILABLE: DISTANT_FRIEND blocks Sandra")
	_expect(unavailable.record_sandra_j05_unavailable(), "UNAVAILABLE recorded without replacement")

	var cooled = _paid_eligible_j05_state()
	_expect(cooled.apply_j05_sandra_choice("choice_sat_sandra_more"), "pressure opens second segment")
	_expect(cooled.apply_j05_sandra_choice("choice_sat_sandra_back_down") and cooled.sandra_j05_outcome == "CONTINUITY_COOLED", "pressure then D'accord. cools continuity")

	var closed = _paid_eligible_j05_state()
	_expect(closed.apply_j05_sandra_choice("choice_sat_sandra_more"), "insistence fixture opens second segment")
	_expect(closed.apply_j05_sandra_choice("choice_sat_sandra_insist") and closed.sandra_j05_outcome == "CONTINUITY_CLOSED", "pressure then insist closes continuity")

	var snapshot: Dictionary = alternative.snapshot()
	var restored = SEASON_STATE.new()
	_expect(restored.restore_snapshot(snapshot) and restored.snapshot() == snapshot, "J05 state snapshot round trip")

func _eligible_j05_state():
	var result = SEASON_STATE.new()
	result.sandra_state = "RECONNECTION_OPEN"
	result.activate_sandra_trace()
	result.begin_j05()
	return result

func _paid_eligible_j05_state():
	var result = _eligible_j05_state()
	result.apply_j05_marie_choice("choice_sat_marie_join_now")
	result.resolve_j05_marie_hour()
	return result

func _exercise_provider_paths() -> void:
	var alternative = _new_j05_provider(true)
	alternative.start_day()
	_expect(bool(alternative.apply_choice("thread_marie_private", "choice_sat_marie_bounded_alternative").get("accepted", false)), "provider PRECISE_ALTERNATIVE accepted")
	var alternative_incoming: Dictionary = alternative.confirm_transition()
	_expect(alternative.state.promises.size() == 2 and str(alternative.state.promises["marie_j05_shared_hour"]["status"]) == "PAID", "provider PRECISE_ALTERNATIVE keeps one PAID P03")
	_expect(str(alternative.state.promises["marie_j05_shared_hour"]["due_at"]) == "J05 12:30", "provider PRECISE_ALTERNATIVE due_at")
	_expect(str(alternative_incoming.get("unlocked_thread_id", "")) == "thread_sandra_private" and str(alternative_incoming.get("notification", {}).get("body", "")) == "Nouveau message !", "provider PRECISE_ALTERNATIVE notifies Sandra")
	_present_sandra_opening(alternative)
	alternative.apply_choice("thread_sandra_private", "choice_sat_sandra_autonomy")
	alternative.confirm_transition()
	_expect(alternative.phase == "complete" and alternative.state.sandra_j05_outcome == "BOUNDARY_RESPECTED", "provider PRECISE_ALTERNATIVE reaches CONTENT_END")

	var refused = _new_j05_provider(true)
	refused.start_day()
	refused.apply_choice("thread_marie_private", "choice_sat_marie_moves_independently")
	var refused_result: Dictionary = refused.confirm_transition()
	_expect(refused.state.marie_j05_shared_hour_resolution == "NO_PROMISE" and not refused.state.promises.has("marie_j05_shared_hour"), "provider REFUSED stores NO_PROMISE without P03")
	_expect(refused.state.sandra_j05_outcome == "UNAVAILABLE" and not refused_result.has("unlocked_thread_id"), "provider REFUSED produces no Sandra notification")
	_expect(refused.gallery_asset_ids.has("S1_A2_J05_SCN_MARIE_SATURDAY_CONTINUES_01"), "provider REFUSED unlocks Marie fallback")
	refused.confirm_transition()
	_expect(refused.phase == "complete", "provider REFUSED reaches CONTENT_END")

	var unavailable = _new_j05_provider(false)
	unavailable.start_day()
	unavailable.apply_choice("thread_marie_private", "choice_sat_marie_join_now")
	var unavailable_result: Dictionary = unavailable.confirm_transition()
	_expect(unavailable.state.sandra_j05_outcome == "UNAVAILABLE" and not unavailable_result.has("notification"), "provider Sandra unavailable has no exterior notification")
	_expect(unavailable.gallery_asset_ids.has("S1_A2_J05_SCN_MARIE_SATURDAY_CONTINUES_01"), "provider Sandra unavailable serves Marie fallback")
	unavailable.confirm_transition()
	_expect(unavailable.phase == "complete", "provider Sandra unavailable reaches CONTENT_END")

	var cooled = _provider_at_sandra_exchange()
	cooled.apply_choice("thread_sandra_private", "choice_sat_sandra_more")
	_expect(cooled.phase == "sandra_limit_followup", "provider pressure opens second segment")
	cooled.apply_choice("thread_sandra_private", "choice_sat_sandra_back_down")
	cooled.confirm_transition()
	_expect(cooled.phase == "complete" and cooled.state.sandra_j05_outcome == "CONTINUITY_COOLED", "provider pressure then D'accord. reaches CONTENT_END")

	var closed = _provider_at_sandra_exchange()
	closed.apply_choice("thread_sandra_private", "choice_sat_sandra_more")
	closed.apply_choice("thread_sandra_private", "choice_sat_sandra_insist")
	closed.confirm_transition()
	_expect(closed.phase == "complete" and closed.state.sandra_j05_outcome == "CONTINUITY_CLOSED", "provider pressure then insist reaches CONTENT_END")
	_expect(closed.presentation_count_by_id("msg_sat_sandra_insist_003") == 1, "provider Bonne nuit. appears exactly once")

func _new_j05_provider(sandra_open: bool):
	var shared_state = SEASON_STATE.new()
	shared_state.sandra_state = "RECONNECTION_OPEN" if sandra_open else "DISTANT_FRIEND"
	shared_state.activate_sandra_trace()
	var provider = J05_PROVIDER.new()
	var t01 := {
		"message_id": "j01_sandra_lunch_memory_soft",
		"author_id": "sandra",
		"timestamp": "12:19",
		"content_type": "IMAGE",
		"text": "",
		"media_ref": "S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01",
		"trace_id": "j01_sandra_lunch_memory_soft",
		"is_player": false,
		"is_read": true,
		"source_day": 1,
	}
	var transcripts := {"thread_marie_private": [], "thread_sandra_private": [t01]}
	var ids := {"j01_sandra_lunch_memory_soft": true}
	_expect(provider.initialize(shared_state, transcripts, ids, ["thread_marie_private", "thread_sandra_private"], []), "direct J05 provider initializes")
	return provider

func _provider_at_sandra_exchange():
	var provider = _new_j05_provider(true)
	provider.start_day()
	provider.apply_choice("thread_marie_private", "choice_sat_marie_join_now")
	provider.confirm_transition()
	_present_sandra_opening(provider)
	return provider

func _present_sandra_opening(provider) -> void:
	for message in provider.transcript_for("thread_sandra_private"):
		if int(message.get("source_day", 0)) == 5:
			provider.mark_message_presented(str(message.get("message_id", "")))
	provider.mark_thread_batch_presented("thread_sandra_private")

func _exercise_real_portrait_path() -> void:
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

	var completed_j04 = _season_at_completed_j04()
	_expect(provider.restore_snapshot(completed_j04.snapshot()), "mounted provider restores completed J04")
	_reset_messages_to_authority(messages, provider)
	await _frames(4)
	var handoff_phases: Array[String] = []
	messages.time_passage_overlay.phase_changed.connect(func(phase: String): handoff_phases.append(phase))
	messages.call_deferred("_resume_authoritative_transition_flow")
	await _wait_until(func(): return provider.active_day == "J05" and provider.j05_provider.phase == "marie_shared_hour" and not messages.transition_flow_active, 300, "J04 to J05 UI handoff timed out")
	_expect(handoff_phases.has("NEW_DAY"), "J04 to J05 presents NEW_DAY")
	_expect(provider.current_narrative_time_text() == "09:35", "J05 starts at 09:35")
	_expect(messages.screen_mode == "list", "J05 starts on conversation list")
	_expect(messages.thread_has_unread_content("thread_marie_private"), "Marie is unread at J05 start")
	_expect(_card_is_strong_unread(messages, "thread_marie_private"), "Marie unread card is strongly emphasized without badge")

	await _press_thread_card(messages, "thread_marie_private", "opens Marie J05")
	await _wait_delivery(messages, "Marie opening delivery")
	_expect(not messages.thread_has_unread_content("thread_marie_private"), "Marie real preview restored after full batch")
	_expect(_card_is_restored_read(messages, "thread_marie_private"), "Marie card restores real preview")
	await _press_choice(messages, "choice_sat_marie_join_now")
	await _wait_until(func(): return provider.j05_provider.phase == "sandra_incoming" and not messages.transition_flow_active, 360, "Marie hour did not resolve to Sandra incoming")
	_expect(provider.state.marie_j05_shared_hour_outcome == "JOIN_NOW" and provider.state.marie_j05_shared_hour_resolution == "PAID", "real path records JOIN_NOW + PAID")
	_expect(str(provider.state.promises["marie_j05_shared_hour"]["due_at"]) == "J05 09:48", "real path keeps exact P03 due_at")
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == "thread_marie_private", "Sandra notification does not force navigation away from Marie")
	_expect(messages.thread_has_unread_content("thread_sandra_private"), "Sandra injected as unread")
	await _wait_until(func(): return messages._notification_visible(), 90, "Sandra notification missing")
	_expect(str(messages.active_notification.get("thread_id", "")) == "thread_sandra_private", "notification targets Sandra")
	_expect(str(messages.active_notification.get("title", "")) == "Sandra" and str(messages.active_notification.get("preview", "")) == "Nouveau message !", "Sandra notification is neutral")

	_activate_notification(messages)
	await _wait_until(func(): return messages.screen_mode == "conversation" and messages.active_thread_id == "thread_sandra_private", 90, "Sandra notification click did not open Sandra")
	await _wait_delivery(messages, "Sandra opening delivery")
	_expect(provider.j05_provider.phase == "sandra_exchange", "Sandra opening reaches bounded exchange")
	_expect(not messages.thread_has_unread_content("thread_sandra_private"), "Sandra becomes read after full presentation")
	_expect(provider.presentation_count_by_id("j01_sandra_lunch_memory_soft") == 1, "T01 is not duplicated")
	_expect(messages.presentation_count_by_content_type("thread_sandra_private", "IMAGE") == 1, "Sandra thread keeps only the existing T01 IMAGE")
	await _press_choice(messages, "choice_sat_sandra_keep")
	await _wait_until(func(): return provider.j05_provider.phase == "complete" and messages.is_day_transition_active(), 360, "J05 CONTENT_END timed out")
	_expect(provider.state.sandra_j05_outcome == "THREAD_MAINTAINED", "safe Sandra choice records THREAD_MAINTAINED")
	_expect(str(provider.content_end().get("transition_mode", "")) == "CONTENT_END", "CONTENT_END exists only after J05")
	_expect(str(messages.day_transition.display_title()) == "J05 terminé", "J05 terminal card is visible")
	_expect(not bool(shell.describe_layout().get("has_vertical_crop", true)) and not bool(messages.describe_state().get("has_horizontal_crop", true)), "responsive J05 has no crop")
	_expect(_unique_provider_message_ids(provider.j05_provider), "J05 produced message ids are unique")
	_expect(provider.presentation_count_by_id("msg_sat_sandra_insist_003") == 0, "Bonne nuit. is absent on safe branch")

	var snapshot: Dictionary = provider.snapshot()
	var restored = SEASON_PROVIDER.new()
	_expect(restored.initialize() and restored.restore_snapshot(snapshot) and restored.snapshot() == snapshot, "J05 provider snapshot round trip")
	messages._clear_notification_state(false)
	main.queue_free()
	await _frames(8)

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

func _unique_provider_message_ids(provider) -> bool:
	var ids := {}
	for thread_id in provider.transcripts_by_thread:
		for message in provider.transcripts_by_thread[thread_id]:
			var id := str(message.get("message_id", ""))
			if id == "" or ids.has(id):
				return false
			ids[id] = true
	return true

func _card_is_strong_unread(messages, thread_id: String) -> bool:
	var view: Dictionary = messages.conversation_list.card_views.get(thread_id, {})
	if view.is_empty():
		return false
	var name: Label = view.get("display_name")
	var preview: Label = view.get("preview")
	var name_font: Font = name.get_theme_font("font")
	var preview_font: Font = preview.get_theme_font("font")
	return preview.text == "Nouveau message !" and name_font is FontVariation and preview_font is FontVariation and is_equal_approx(name_font.variation_embolden, 1.5) and is_equal_approx(preview_font.variation_embolden, 1.5)

func _card_is_restored_read(messages, thread_id: String) -> bool:
	var view: Dictionary = messages.conversation_list.card_views.get(thread_id, {})
	var thread: Dictionary = messages._thread_for(thread_id)
	if view.is_empty() or thread.is_empty():
		return false
	var preview: Label = view.get("preview")
	return preview.text == str(thread.get("last_preview", "")) and not preview.has_theme_font_override("font")

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
		print("RUNTIME-S1-05 J05 real PortraitMain smoke %dx%d: OK" % [size.x, size.y])
		get_tree().call_deferred("quit", 0)
		return
	for failure in failures:
		push_error(failure)
	print("RUNTIME-S1-05 J05 real PortraitMain smoke: FAILED (%d)" % failures.size())
	get_tree().call_deferred("quit", 1)
