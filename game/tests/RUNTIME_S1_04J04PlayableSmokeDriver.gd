extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const SEASON_PROVIDER := preload("res://scripts/runtime/season_1/Season1RuntimeProvider.gd")
const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")

var failures: Array[String] = []
var tested_mains: Array[Node] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var requested_size := _parse_size(_arg("--runtime-size", "720x1280"))
	get_window().size = requested_size
	_exercise_pauline_outcome_snapshot_contracts()
	await _exercise_real_portrait_path("Marie then Mathilde", ["thread_marie_private", "thread_mathilde_private"], true)
	await _exercise_real_portrait_path("Mathilde then Marie", ["thread_mathilde_private", "thread_marie_private"], false)
	_finish(requested_size)

func _exercise_pauline_outcome_snapshot_contracts() -> void:
	var cases: Array[Dictionary] = [
		{"choice": "choice_friday_pauline_practical", "outcome": "FRAME_02_SELECTED", "retained": "FRAME_02"},
		{"choice": "choice_friday_pauline_dry", "outcome": "FRAME_03_REQUESTED", "retained": "FRAME_02"},
		{"choice": "choice_friday_pauline_defer", "outcome": "DEFERRED_TO_MARIE", "retained": "UNESTABLISHED"},
	]
	for test_case in cases:
		var source = SEASON_STATE.new()
		_expect(source.apply_j04_choice(str(test_case["choice"])), "Pauline outcome choice accepted: " + str(test_case["choice"]))
		_expect(source.pauline_public_selection_outcome == str(test_case["outcome"]), "Pauline bounded outcome: " + str(test_case["choice"]))
		_expect(source.pauline_retained_frame == str(test_case["retained"]), "Pauline retained frame: " + str(test_case["choice"]))
		var legacy_snapshot: Dictionary = source.snapshot()
		legacy_snapshot.erase("pauline_retained_frame")
		var restored = SEASON_STATE.new()
		_expect(restored.restore_snapshot(legacy_snapshot), "Pauline previous snapshot restores: " + str(test_case["choice"]))
		_expect(restored.pauline_retained_frame == str(test_case["retained"]), "Pauline retained frame derives from previous snapshot: " + str(test_case["choice"]))
		var contradictory_snapshot: Dictionary = source.snapshot()
		contradictory_snapshot["pauline_retained_frame"] = "UNESTABLISHED" if str(test_case["retained"]) == "FRAME_02" else "FRAME_02"
		var rejected = SEASON_STATE.new()
		_expect(not rejected.restore_snapshot(contradictory_snapshot), "Pauline contradictory snapshot rejected: " + str(test_case["choice"]))

func _exercise_real_portrait_path(label: String, echo_order: Array, exercise_photo: bool) -> void:
	var main = MAIN_SCENE.instantiate()
	main.get_node("PortraitShell").content_mode = "runtime_s1"
	tested_mains.append(main)
	add_child(main)
	await _frames(6)
	var shell = main.shell
	var messages = shell.messages_screen
	var provider = shell.runtime_provider
	var household_final_delivery_phases: Array[String] = []
	messages.runtime_message_delivered.connect(func(_thread_id: String, message_id: String):
		if message_id in ["msg_friday_marie_household_003", "msg_friday_mathilde_household_003"]:
			household_final_delivery_phases.append(str(provider.j04_provider.phase))
	)
	shell.set_safe_area_preset("none")
	# Reduced motion shortens only presentation animations; provider durations remain canonical.
	shell.set_reduced_motion_enabled(true)
	messages.runtime_delivery_time_scale = 0.01
	messages.reading_speed_multiplier = 8.0

	# Fixture setup ends at the real J03 boundary, then the mounted PortraitMain owns the handoff.
	var completed_j03 = _season_at_completed_j03()
	_expect(provider.restore_snapshot(completed_j03.snapshot()), label + " restores completed J03 into mounted provider")
	_reset_messages_to_authority(messages, provider)
	await _frames(4)
	var handoff_phases: Array[String] = []
	messages.time_passage_overlay.phase_changed.connect(func(phase: String): handoff_phases.append(phase))
	messages.call_deferred("_resume_authoritative_transition_flow")
	await _wait_until(func(): return provider.active_day == "J04" and provider.j04_provider.phase == "pauline_public_relay" and not messages.transition_flow_active, 240, label + " J03 to J04 UI handoff timed out")
	_expect(handoff_phases.count("NEW_DAY") == 1, label + " presents NEW_DAY exactly once")
	_expect(not handoff_phases.has("NIGHT"), label + " does not replay J03 NIGHT at restored handoff boundary")
	_expect(provider.current_narrative_time_text() == "08:35", label + " starts J04 at 08:35")
	_expect(messages.screen_mode == "list", label + " handoff returns to real conversation list")
	_expect(messages.thread_has_unread_content("thread_pauline_private"), label + " Pauline is unread on the J04 list")
	_expect(_card_is_strong_unread(messages, "thread_pauline_private"), label + " Pauline card uses strong primary unread styling")

	# Pauline: open a real card, let delivery signals present the provider suffix, use real choice buttons.
	await _press_thread_card(messages, "thread_pauline_private", label + " opens Pauline card")
	_expect(messages.thread_has_unread_content("thread_pauline_private"), label + " Pauline remains unread before her lot is fully presented")
	await _wait_delivery(messages, label + " Pauline initial delivery")
	_expect(not messages.thread_has_unread_content("thread_pauline_private"), label + " Pauline becomes read after full presentation")
	_expect(_card_is_restored_read(messages, "thread_pauline_private"), label + " Pauline card restores its real secondary preview")
	_expect(messages.active_thread_id == "thread_pauline_private", label + " Pauline is first active J04 thread")
	_expect(messages.presentation_count_by_content_type("thread_pauline_private", "IMAGE") == 1, label + " Pauline PHOTO_SET uses one IMAGE parent")
	var photo_set: Dictionary = _message_by_id(messages, "thread_pauline_private", "visual_friday_pauline_group_set")
	_expect(str(photo_set.get("placeholder_label", "")) == "Set de 3 photos non produit", label + " Pauline PHOTO_SET uses the neutral set placeholder")
	_expect(photo_set.get("photo_set_children", []).size() == 3, label + " Pauline PHOTO_SET exposes exactly three child frames")
	_expect(messages.conversation_screen.timeline.day_divider_labels().count("Vendredi") == 1, label + " Pauline has one Vendredi divider")
	if exercise_photo:
		await _exercise_photo_viewer(shell, messages, label)
	await _press_choice(messages, "choice_friday_pauline_contract_guided", label)
	await _press_choice(messages, "choice_friday_pauline_dry", label)

	# The final Pauline delivery launches the actual clock_only overlay and notification.
	await _wait_until(func(): return provider.active_day == "J04" and provider.j04_provider.phase == "nico_saved_seat" and not messages.transition_flow_active, 360, label + " 14:05 clock_only timed out")
	_expect(provider.current_narrative_time_text() == "14:05", label + " clock_only commits 14:05")
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == "thread_pauline_private", label + " 14:05 keeps Pauline open")
	_expect(provider.state.pauline_public_selection_outcome == "FRAME_03_REQUESTED" and provider.state.pauline_retained_frame == "FRAME_02" and provider.state.pauline_state == "PUBLIC_ONLY", label + " dry request keeps Pauline's frame 2 selection")
	_expect(provider.state.traces.has("j04_pauline_bastien_public_set_01") and provider.state.knowledge.has("fact_pauline_bastien_couple_public"), label + " Pauline establishes T04 and F03")
	await _wait_until(func(): return messages._notification_visible(), 60, label + " Nico notification missing")
	_expect(str(messages.active_notification.get("thread_id", "")) == "thread_nico_private", label + " visible notification targets Nico only")
	_expect(str(messages.active_notification.get("title", "")) == "Nico" and str(messages.active_notification.get("preview", "")) == "Nouveau message !", label + " Nico notification is neutral")
	_activate_notification(messages)
	await _wait_until(func(): return messages.active_thread_id == "thread_nico_private" and messages.screen_mode == "conversation", 60, label + " Nico notification did not open thread")
	_expect(messages.thread_has_unread_content("thread_nico_private"), label + " Nico remains unread while his lot is being presented")
	await _wait_delivery(messages, label + " Nico initial delivery")
	_expect(not messages.thread_has_unread_content("thread_nico_private"), label + " Nico becomes read after full presentation")

	await _press_choice(messages, "choice_friday_nico_reservation_guided", label)
	await _press_choice(messages, "choice_friday_nico_honest", label)
	await _press_choice(messages, "choice_friday_nico_mathilde_guided", label)
	await _wait_until(func(): return provider.j04_provider.phase == "household_echoes" and not messages.transition_flow_active, 360, label + " 18:05 clock_only timed out")
	_expect(provider.current_narrative_time_text() == "18:05", label + " clock_only commits 18:05")
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == "thread_nico_private", label + " 18:05 keeps Nico open")
	_expect(provider.state.nico_state == "ORDINARY_FRIEND" and provider.state.nico_friendship_outcome == "HONEST", label + " real Nico choices set bounded outcome")
	_expect(provider.state.knowledge.has("fact_nico_friendship_exists"), label + " Nico establishes F06")
	var f02: Dictionary = provider.state.knowledge.get("fact_mathilde_stay_started", {})
	_expect(f02.get("current_knowers", []).has("Nico") and f02.get("knowledge_acquisitions", {}).get("Nico", {}).get("source", "") == "Marie", label + " Nico learns F02 from Marie")
	await _wait_until(func(): return messages._notification_visible(), 60, label + " Marie notification missing")
	_expect(str(messages.active_notification.get("thread_id", "")) == "thread_marie_private" and messages._visible_notification_count() == 1, label + " Marie is the sole visible notification")
	_expect(str(messages.active_notification.get("title", "")) == "Marie" and str(messages.active_notification.get("preview", "")) == "Nouveau message !", label + " Marie notification is neutral")
	_expect(messages.thread_has_unread_content("thread_marie_private"), label + " Marie is pending/unread")
	_expect(messages.thread_has_unread_content("thread_mathilde_private"), label + " Mathilde remains pending/unread without notification")
	_expect(_card_is_strong_unread(messages, "thread_marie_private"), label + " Marie card uses strong primary unread styling")
	_expect(_card_is_strong_unread(messages, "thread_mathilde_private"), label + " Mathilde card independently uses strong primary unread styling")

	# Open both real conversations in the requested order. The second completion alone may arm final.
	for index in range(2):
		var thread_id: String = str(echo_order[index])
		if thread_id == "thread_marie_private" and messages._notification_visible() and str(messages.active_notification.get("thread_id", "")) == thread_id:
			_activate_notification(messages)
			await _wait_until(func(): return messages.active_thread_id == thread_id, 60, label + " Marie notification open failed")
		else:
			if messages.screen_mode == "conversation":
				messages.conversation_screen.back_button.emit_signal("pressed")
				await _wait_until(func(): return messages.screen_mode == "list", 60, label + " return to list failed")
				await _frames(3) # allow the deferred notification host transfer to finish
			await _press_thread_card(messages, thread_id, label + " opens household card")
		_expect(messages.thread_has_unread_content(thread_id), label + " selected household lot stays unread before full presentation")
		await _wait_delivery(messages, label + " household delivery " + thread_id)
		_expect(not messages.thread_has_unread_content(thread_id), label + " selected household lot becomes read after full presentation")
		_expect(messages.active_thread_id == thread_id, label + " active household thread " + thread_id)
		_expect(messages.conversation_screen.timeline.day_divider_labels().count("Vendredi") == 1, label + " one Vendredi divider in " + thread_id)
		if index == 0:
			var other_thread_id := "thread_mathilde_private" if thread_id == "thread_marie_private" else "thread_marie_private"
			_expect(messages.thread_has_unread_content(other_thread_id), label + " opening one household thread does not read the other")
			_expect(provider.j04_provider.phase == "household_echoes", label + " final waits after first real presentation")
			_expect(not messages.is_time_passage_active() and provider.content_end().is_empty(), label + " no final surface after first echo")
		else:
			_expect(provider.j04_provider.phase == "household_close", label + " final arms only after both real presentations")
	_expect(household_final_delivery_phases == ["household_echoes", "household_echoes"], label + " household close waits for post-layout batch acknowledgement")

	# Real Back signal invokes on_thread_returned and starts the final J04 flow into J05.
	messages.conversation_screen.back_button.emit_signal("pressed")
	await _wait_until(func(): return provider.active_day == "J05" and provider.j05_provider.phase == "marie_shared_hour" and not messages.transition_flow_active, 480, label + " 18:25 J04 to J05 flow timed out")
	_expect(provider.current_narrative_time_text() == "09:35", label + " J05 starts at 09:35 (got %s)" % provider.current_narrative_time_text())
	_expect(handoff_phases.count("CLOCK") == 3 and handoff_phases.count("OFF_PHONE") == 1 and handoff_phases.has("NIGHT") and handoff_phases.count("NEW_DAY") == 2, label + " real signals present J04 clocks, night and one J05 handoff")
	_expect(provider.state.opening_band_complete and provider.state.household_rhythm_confirmed, label + " final canonical flags")
	_expect(provider.content_end().is_empty() and messages.screen_mode == "list" and messages.thread_has_unread_content("thread_marie_private"), label + " J04 has no CONTENT_END and J05 Marie is unread")
	_expect(not bool(shell.describe_layout().get("has_vertical_crop", true)) and not bool(messages.describe_state().get("has_horizontal_crop", true)), label + " no crop at final")
	_expect(_unique_provider_message_ids(provider), label + " no duplicated provider message")

	# Existing provider snapshot API is exercised; no invented UI persistence is introduced.
	var snapshot: Dictionary = provider.snapshot()
	var restored = SEASON_PROVIDER.new()
	_expect(restored.initialize() and restored.restore_snapshot(snapshot) and restored.snapshot() == snapshot, label + " provider snapshot round trip")
	await _dispose_main(main)

func _exercise_photo_viewer(shell, messages, label: String) -> void:
	var timeline = messages.conversation_screen.timeline
	var image_button: Button = null
	for image_message in timeline.image_messages:
		if str(image_message.message_id) == "visual_friday_pauline_group_set":
			image_button = image_message.image_button
			break
	_expect(image_button != null, label + " real Pauline IMAGE control exists")
	if image_button == null:
		return
	image_button.grab_focus()
	image_button.emit_signal("pressed")
	await _wait_until(func(): return shell.is_photo_viewer_active(), 60, label + " PhotoViewer did not open")
	var layout: Dictionary = shell.describe_layout()
	_expect(layout.get("photo_viewer_source", "") == "messages" and layout.get("photo_viewer_current_id", "") == "visual_friday_pauline_group_set", label + " PhotoViewer opens from Messages IMAGE")
	_expect(not bool(layout.get("photo_viewer_has_horizontal_crop", true)) and not bool(layout.get("photo_viewer_has_vertical_crop", true)), label + " PhotoViewer has no crop")
	_expect(bool(layout.get("photo_viewer_back_focus", false)), label + " PhotoViewer Back receives focus")
	shell.photo_viewer.back_button.emit_signal("pressed")
	await _wait_until(func(): return not shell.is_photo_viewer_active(), 60, label + " PhotoViewer did not close")
	await _frames(5)
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == "thread_pauline_private", label + " PhotoViewer returns to Pauline thread")
	_expect(image_button.has_focus(), label + " PhotoViewer restores IMAGE focus")

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
	# This fixture enters at the J03 boundary: prior transcripts were already presented
	# by the continuous portrait runtime and must not be replayed as J04 deliveries.
	for raw_thread_id in source.get("messages_by_thread", {}):
		var thread_id := str(raw_thread_id)
		var historical: Array[Dictionary] = messages._dictionary_array(source["messages_by_thread"][raw_thread_id])
		messages.transcripts[thread_id] = historical
		var ids: Array = []
		for message in historical: ids.append(str(message.get("message_id", "")))
		messages.runtime_presented_message_ids_by_thread[thread_id] = ids
	messages._reconcile_runtime_source(source)
	messages._build()
	messages.runtime_delivery_cancelled = false

func _season_at_completed_j03():
	var season = SEASON_PROVIDER.new()
	_expect(season.initialize(), "fixture provider initializes")
	for id in ["choice_j1_marie_optimism_guided", "choice_j1_marie_crisis_guided", "choice_j1_marie_present", "choice_j1_marie_laverriere_guided", "choice_j1_marie_mathilde_guided"]: season.apply_choice("thread_marie_private", id)
	season.confirm_transition()
	for id in ["choice_j1_sandra_what_guided", "choice_j1_sandra_art_guided", "choice_j1_sandra_cautious", "choice_j1_sandra_thanks_guided", "choice_j1_sandra_goodnight_guided"]: season.apply_choice("thread_sandra_private", id)
	season.confirm_transition(); season.confirm_day_transition(); season.confirm_day_transition()
	season.apply_choice("thread_marie_private", "choice_wed_marie_emergency_guided"); season.apply_choice("thread_marie_private", "choice_wed_make_room_proactive")
	season.confirm_day_transition(); season.on_thread_returned("thread_marie_private"); season.confirm_day_transition()
	season.apply_choice("thread_mathilde_private", "choice_wed_mathilde_practical"); season.confirm_transition()
	season.confirm_day_transition(); season.confirm_day_transition()
	season.apply_choice("thread_raphaelle_private", "choice_thu_raph_method_guided"); season.apply_choice("thread_raphaelle_private", "choice_thu_raph_accountable"); season.confirm_transition()
	season.confirm_day_transition(); season.apply_choice("thread_marie_private", "choice_j3_marie_evening_why_guided"); season.apply_choice("thread_marie_private", "choice_j3_marie_return_active"); season.confirm_transition()
	_expect(season.active_day == "J03" and season.j03_provider.phase == "complete", "fixture reaches completed J03")
	return season

func _press_thread_card(messages, thread_id: String, failure: String) -> void:
	var card = _thread_card(messages, thread_id)
	_expect(card != null, failure)
	if card != null:
		card.emit_signal("pressed")
		await _wait_until(func(): return messages.screen_mode == "conversation" and messages.active_thread_id == thread_id, 60, failure + " did not activate")

func _thread_card(messages, thread_id: String):
	for index in range(messages.conversation_list.threads.size()):
		if str(messages.conversation_list.threads[index].get("thread_id", "")) == thread_id:
			return messages.conversation_list.cards[index]
	return null

func _press_choice(messages, choice_id: String, label: String) -> void:
	await _wait_delivery(messages, label + " before choice " + choice_id)
	var button = _choice_button(messages, choice_id)
	_expect(button != null, label + " real choice button " + choice_id)
	if button != null:
		button.emit_signal("pressed")
		await _wait_delivery(messages, label + " delivery after " + choice_id)

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
	# open_thread/apply choice schedules delivery on the next frame.
	await get_tree().process_frame
	await _wait_until(func(): return not messages.runtime_delivery_active and messages.runtime_delivery_queue.is_empty() and not messages.conversation_screen.typing_visible(), 900, label + " timed out")

func _wait_until(predicate: Callable, frames: int, failure: String) -> void:
	for _index in range(frames):
		if predicate.call():
			return
		await get_tree().process_frame
	_expect(false, failure)

func _message_by_id(messages, thread_id: String, message_id: String) -> Dictionary:
	for message in messages._dictionary_array(messages.transcripts.get(thread_id, [])):
		if str(message.get("message_id", "")) == message_id:
			return message
	return {}

func _unique_provider_message_ids(provider) -> bool:
	var ids := {}
	for thread_id in provider.j04_provider.transcripts_by_thread:
		for message in provider.j04_provider.transcripts_by_thread[thread_id]:
			var id := str(message.get("message_id", ""))
			if id == "" or ids.has(id): return false
			ids[id] = true
	return true

func _card_is_strong_unread(messages, thread_id: String) -> bool:
	var view: Dictionary = messages.conversation_list.card_views.get(thread_id, {})
	if view.is_empty(): return false
	var name: Label = view.get("display_name")
	var preview: Label = view.get("preview")
	var name_font: Font = name.get_theme_font("font")
	var preview_font: Font = preview.get_theme_font("font")
	return preview.text == "Nouveau message !" and name.get_theme_color("font_color") == messages.PORTRAIT_THEME.TEXT_PRIMARY and preview.get_theme_color("font_color") == messages.PORTRAIT_THEME.TEXT_PRIMARY and name_font is FontVariation and preview_font is FontVariation and is_equal_approx(name_font.variation_embolden, 1.5) and is_equal_approx(preview_font.variation_embolden, 1.5)

func _card_is_restored_read(messages, thread_id: String) -> bool:
	var view: Dictionary = messages.conversation_list.card_views.get(thread_id, {})
	var thread: Dictionary = messages._thread_for(thread_id)
	if view.is_empty() or thread.is_empty(): return false
	var name: Label = view.get("display_name")
	var preview: Label = view.get("preview")
	return preview.text == str(thread.get("last_preview", "")) and preview.get_theme_color("font_color") == messages.PORTRAIT_THEME.TEXT_SECONDARY and not name.has_theme_font_override("font") and not preview.has_theme_font_override("font")

func _dispose_main(main: Node) -> void:
	if not is_instance_valid(main): return
	var messages = main.shell.messages_screen
	messages._clear_notification_state(false)
	messages.runtime_delivery_cancelled = true
	messages.runtime_delivery_active = false
	messages.runtime_delivery_request_id += 1
	messages.transition_flow_active = false
	messages.transition_flow_request_id += 1
	messages.time_passage_overlay.cancel_flow()
	main.queue_free()
	await _frames(8)

func _frames(count: int) -> void:
	for _index in range(count): await get_tree().process_frame

func _arg(prefix: String, fallback: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="): return arg.trim_prefix(prefix + "=")
	return fallback

func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x")
	return Vector2i(int(parts[0]), int(parts[1])) if parts.size() == 2 else Vector2i.ZERO

func _expect(condition: bool, message: String) -> void:
	if not condition: failures.append(message)

func _finish(size: Vector2i) -> void:
	if failures.is_empty():
		print("RUNTIME-S1-04 J04 real PortraitMain smoke %dx%d: OK" % [size.x, size.y])
		get_tree().call_deferred("quit", 0)
		return
	for failure in failures: push_error(failure)
	print("RUNTIME-S1-04 J04 real PortraitMain smoke: FAILED (%d)" % failures.size())
	get_tree().call_deferred("quit", 1)
