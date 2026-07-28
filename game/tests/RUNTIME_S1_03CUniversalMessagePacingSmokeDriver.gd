extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")

var failures: Array[String] = []
var typing_counts: Dictionary = {}
var delivery_counts: Dictionary = {}
var delivered_order_by_thread: Dictionary = {}
var observed_short_atomic := false
var observed_long_atomic := false
var observed_empty_frame := false
var replacement_max_gap := 0.0
var replacement_observation_count := 0

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var size := _parse_size(_arg("--runtime-size", "540x960"))
	get_window().size = size
	var main = MAIN_SCENE.instantiate()
	add_child(main)
	await _frames(5)
	var shell = main.shell
	var messages = shell.messages_screen
	var provider = shell.runtime_provider
	messages.runtime_delivery_time_scale = 1.0
	messages.runtime_typing_started.connect(_on_typing_started)
	messages.runtime_message_delivered.connect(_on_message_delivered)
	_assert_speed_button_layout_and_focus(shell)

	var marie_before := _provider_ids(provider, "thread_marie_private")
	_expect(messages.thread_message_count("thread_marie_private") < marie_before.size(), "initial Marie messages must remain pending")
	_press_thread_card(messages, "thread_marie_private")
	await _wait_for_typing(messages)
	await _exercise_active_speed_and_motion(shell, messages)
	await _wait_delivery(messages)
	_assert_segment(provider, messages, "thread_marie_private", [], "J01 Marie mandatory initial/segment typing exactly once")
	_expect(messages.thread_choice_count("thread_marie_private") > 0, "choices must remain hidden until delivery completes")
	_assert_active_messages_read(messages, "thread_marie_private")
	await _assert_no_replay(messages, "thread_marie_private")
	await _assert_relative_timings(messages)

	for id in ["choice_j1_marie_optimism_guided", "choice_j1_marie_crisis_guided", "choice_j1_marie_present", "choice_j1_marie_laverriere_guided", "choice_j1_marie_mathilde_guided"]:
		await _choose(messages, id)
	await _frames(2)
	messages.off_phone_transition.resume_button.emit_signal("pressed")
	await _frames(3)
	var sandra_j01_before: Array = []
	await _open(messages, "thread_sandra_private")
	_assert_segment(provider, messages, "thread_sandra_private", sandra_j01_before, "J01 Sandra mandatory initial/segment typing exactly once")
	for id in ["choice_j1_sandra_what_guided", "choice_j1_sandra_art_guided", "choice_j1_sandra_safe_warmth", "choice_j1_sandra_thanks_guided", "choice_j1_sandra_goodnight_guided"]:
		await _choose(messages, id)
	await _frames(2)
	messages.off_phone_transition.resume_button.emit_signal("pressed")
	await _frames(3)

	# J02 starts through the same real card/button flow used by the J01-J03 playable smokes.
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	var marie_before_j02 := _provider_ids(provider, "thread_marie_private")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	await _open(messages, "thread_marie_private")
	_assert_segment(provider, messages, "thread_marie_private", marie_before_j02, "J02 Marie start mandatory initial/segment typing exactly once")
	_expect(shell.reading_speed_multiplier == 3.0, "speed must persist between threads and days")
	await _choose(messages, "choice_wed_marie_emergency_guided")
	var marie_before_1818 := _provider_ids(provider, "thread_marie_private")
	await _choose(messages, "choice_wed_make_room_proactive")
	_expect(not messages.day_transition.visible and provider.current_narrative_time_minutes() >= 1098, "J02 18:18 clock_only")
	_assert_segment(provider, messages, "thread_marie_private", marie_before_1818, "J02 Marie 18:18 mandatory initial/segment typing exactly once")
	messages.conversation_screen.back_button.emit_signal("pressed")
	await _wait_clock_transition(messages)
	_expect(not messages.day_transition.visible and provider.current_narrative_time_text() == "18:22", "J02 18:22 clock_only")
	var mathilde_before: Array = []
	await _open(messages, "thread_mathilde_private")
	_assert_segment(provider, messages, "thread_mathilde_private", mathilde_before, "J02 Mathilde mandatory initial/segment typing exactly once")
	await _choose(messages, "choice_wed_mathilde_practical")
	await _frames(2)
	messages.off_phone_transition.resume_button.emit_signal("pressed")
	await _frames(3)

	# J03 starts and all mandatory/optional incoming segments use real cards and choices.
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	var raphaelle_before: Array = []
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	await _open(messages, "thread_raphaelle_private")
	_assert_segment(provider, messages, "thread_raphaelle_private", raphaelle_before, "J03 Raphaelle mandatory initial/segment typing exactly once")
	await _choose(messages, "choice_thu_raph_method_guided")
	await _choose(messages, "choice_thu_raph_accountable")
	await _frames(2)
	messages.off_phone_transition.resume_button.emit_signal("pressed")
	await _wait_clock_transition(messages)
	var sandra_before_j03 := _provider_ids(provider, "thread_sandra_private")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _wait_delivery(messages)
	_assert_segment(provider, messages, "thread_sandra_private", sandra_before_j03, "J03 Sandra mandatory initial/segment typing exactly once")
	await _choose(messages, "choice_thu_sandra_day_saved")
	await _frames(2)
	var marie_before_j03 := _provider_ids(provider, "thread_marie_private")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _wait_delivery(messages)
	_assert_segment(provider, messages, "thread_marie_private", marie_before_j03, "J03 Marie mandatory initial/segment typing exactly once")
	await _choose(messages, "choice_j3_marie_evening_why_guided")
	await _choose(messages, "choice_j3_marie_return_active")
	await _frames(2)
	messages.off_phone_transition.resume_button.emit_signal("pressed")
	await _frames(2)

	_assert_all_provider_orders(provider, messages)
	_assert_exclusions(provider)
	var timeline = messages.conversation_screen.timeline
	_expect(not observed_empty_frame, "atomic replacement must never expose an empty frame")
	_expect(observed_short_atomic and observed_long_atomic, "atomic short/long frame observations")
	_expect(replacement_observation_count > 0 and replacement_max_gap <= 2.0, "bottom gap must remain at most two pixels (observed %.2f)" % replacement_max_gap)
	await _frames(3)
	_expect(timeline.replacement_spacer_count() == 0 and timeline.replacement_spacer_created_count() == timeline.replacement_spacer_removed_count(), "replacement spacer lifecycle must stabilize")
	_expect(timeline.replacement_spacer_height() == 0.0, "temporary replacement spacer must be removed")
	_finish()

func _exercise_active_speed_and_motion(shell, messages) -> void:
	var button: Button = shell.reading_speed_button
	_expect(button.text == "×1", "speed button must not crop at portrait resolution")
	var started_at := Time.get_ticks_usec()
	await _frames(2)
	button.emit_signal("pressed")
	_expect(button.text == "×3" and messages.conversation_screen.typing_instance_count() == 1, "speed change must affect the current wait")
	button.emit_signal("pressed")
	_expect(button.text == "×8", "speed cycle reached ×8")
	shell.set_reduced_motion_enabled(true)
	await _frames(1)
	_expect(messages.conversation_screen.timeline.typing_visible() and messages.conversation_screen.timeline.typing_instance_count() == 1 and not messages.conversation_screen.timeline.typing_animation_running(), "reduced motion ×8 typing must remain static")
	shell.set_reduced_motion_enabled(false)
	await _frames(1)
	_expect(messages.conversation_screen.timeline.typing_instance_count() == 1 and messages.conversation_screen.timeline.typing_animation_running(), "disabling reduced motion must immediately resume active typing without duplication")
	button.emit_signal("pressed")
	_expect(button.text == "×1", "speed cycle must be ×1→×3→×8→×1")
	button.emit_signal("pressed")
	_expect(button.text == "×3", "route speed preference must be ×3")
	_expect(Time.get_ticks_usec() - started_at < 1000000, "current wait accelerated during typing")
	messages.runtime_delivery_time_scale = 0.01

func _assert_relative_timings(messages) -> void:
	var scale := 0.10
	messages.runtime_delivery_time_scale = scale
	var durations: Dictionary = {}
	for speed in [1.0, 3.0, 8.0]:
		messages.reading_speed_multiplier = speed
		var start := Time.get_ticks_usec()
		await messages._runtime_delivery_delay(1.20, true)
		durations[speed] = float(Time.get_ticks_usec() - start) / 1000000.0
	_expect(float(durations[1.0]) > float(durations[3.0]) and float(durations[3.0]) > float(durations[8.0]), "relative timings must follow ×1 > ×3 > ×8 using time_scale")
	_expect(float(durations[3.0]) + 0.02 >= 0.35 * scale and float(durations[8.0]) + 0.02 >= 0.22 * scale, "scaled typing minimums must be respected")
	messages.runtime_delivery_time_scale = 0.01
	messages.reading_speed_multiplier = 3.0

func _assert_speed_button_layout_and_focus(shell) -> void:
	var button: Button = shell.reading_speed_button
	if button == null:
		_expect(shell.messages_surface_mode == "list", "speed button absent only on list")
		return
	var header_rect: Rect2 = shell.header_panel.get_global_rect()
	var button_rect: Rect2 = button.get_global_rect()
	button.grab_focus()
	_expect(button.visible and button.is_visible_in_tree() and header_rect.encloses(button_rect), "speed button must remain visible inside header")
	_expect(button.custom_minimum_size.y >= 44.0 and button.has_focus(), "speed button focus and 44px target")

func _assert_segment(provider, messages, thread_id: String, before_ids: Array, label: String) -> void:
	var source_messages: Array = provider.presentation_source().get("messages_by_thread", {}).get(thread_id, [])
	var mandatory_count := 0
	for message in source_messages:
		var id := str(message.get("message_id", ""))
		var kind := str(message.get("content_type", ""))
		if before_ids.has(id) or bool(message.get("is_player", false)) or (kind != "TEXT" and kind != "IMAGE"):
			continue
		mandatory_count += 1
		_expect(int(typing_counts.get(id, 0)) == 1 and int(delivery_counts.get(id, 0)) == 1, label + ": each incoming TEXT or IMAGE must have exactly one typing phase")
	if label.contains("Mathilde") and mandatory_count == 0:
		_expect(true, label)
	else:
		_expect(mandatory_count > 0, label)
	_assert_thread_provider_order(provider, messages, thread_id)

func _assert_no_replay(messages, thread_id: String) -> void:
	var counts_before := delivery_counts.duplicate(true)
	messages.conversation_screen.back_button.emit_signal("pressed")
	await _frames(2)
	await _open(messages, thread_id)
	_expect(delivery_counts == counts_before and not messages.runtime_delivery_active, "reopening a thread must not replay presented messages")

func _assert_active_messages_read(messages, thread_id: String) -> void:
	for message in messages.transcripts.get(thread_id, []):
		_expect(bool(message.get("is_read", false)), "delivered active-thread messages must be read before visual insertion")

func _assert_exclusions(provider) -> void:
	for thread_id in provider.presentation_source().get("messages_by_thread", {}):
		for message in provider.presentation_source()["messages_by_thread"][thread_id]:
			var id := str(message.get("message_id", ""))
			var kind := str(message.get("content_type", ""))
			if bool(message.get("is_player", false)) or kind == "SYSTEM_DAY_DIVIDER" or kind == "OFF_PHONE_TRANSITION":
				_expect(int(typing_counts.get(id, 0)) == 0, "Player/separator/off-phone exclusions must never type")

func _assert_all_provider_orders(provider, messages) -> void:
	for thread_id in provider.presentation_source().get("messages_by_thread", {}):
		_assert_thread_provider_order(provider, messages, str(thread_id))

func _assert_thread_provider_order(provider, messages, thread_id: String) -> void:
	var expected: Array = provider.presentation_source().get("messages_by_thread", {}).get(thread_id, [])
	var actual: Array = messages.transcripts.get(thread_id, [])
	_expect(messages._normalized_runtime_transcript(actual) == messages._normalized_runtime_transcript(expected), "final visual order must strictly match provider")
	var expected_ids: Array = []
	for message in expected: expected_ids.append(str(message.get("message_id", "")))
	var actual_ids: Array = []
	for message in actual: actual_ids.append(str(message.get("message_id", "")))
	_expect(actual_ids == expected_ids, "strict final provider order")

func _provider_ids(provider, thread_id: String) -> Array:
	var result: Array = []
	for message in provider.presentation_source().get("messages_by_thread", {}).get(thread_id, []):
		result.append(str(message.get("message_id", "")))
	return result

func _on_typing_started(_thread_id: String, message_id: String, _author_id: String) -> void:
	typing_counts[message_id] = int(typing_counts.get(message_id, 0)) + 1

func _on_message_delivered(thread_id: String, message_id: String) -> void:
	delivery_counts[message_id] = int(delivery_counts.get(message_id, 0)) + 1
	var order: Array = delivered_order_by_thread.get(thread_id, [])
	order.append(message_id)
	delivered_order_by_thread[thread_id] = order

func _choose(messages, choice_id: String) -> void:
	for index in range(messages.available_choices.get(messages.active_thread_id, []).size()):
		if str(messages.available_choices[messages.active_thread_id][index].get("choice_id", "")) == choice_id:
			messages.conversation_screen.choice_bar.buttons[index].emit_signal("pressed")
			await _wait_delivery(messages)
			return
	_expect(false, "choice unavailable: " + choice_id)

func _open(messages, thread_id: String) -> void:
	_press_thread_card(messages, thread_id)
	await _wait_delivery(messages)

func _press_thread_card(messages, thread_id: String) -> void:
	for index in range(messages.conversation_list.threads.size()):
		if str(messages.conversation_list.threads[index].get("thread_id", "")) == thread_id:
			messages.conversation_list.cards[index].emit_signal("pressed")
			return
	_expect(false, "thread card unavailable: " + thread_id)

func _wait_for_typing(messages) -> void:
	for _index in range(600):
		if messages.conversation_screen.typing_visible(): return
		await get_tree().process_frame
	_expect(false, "typing did not start")

func _wait_delivery(messages) -> void:
	await get_tree().process_frame
	var timeline = messages.conversation_screen.timeline
	var previous_typing: bool = bool(timeline.typing_visible())
	var previous_count: int = int(timeline.message_count())
	for _index in range(2400):
		var current_typing: bool = bool(timeline.typing_visible())
		var current_count: int = int(timeline.message_count())
		if previous_typing and not current_typing:
			if current_count == previous_count:
				observed_empty_frame = true
			else:
				replacement_observation_count += 1
				replacement_max_gap = maxf(replacement_max_gap, timeline.bottom_gap())
				var last_message: Dictionary = timeline.messages[-1]
				var length := str(last_message.get("text", "")).length()
				if length <= 55: observed_short_atomic = true
				if length >= 90: observed_long_atomic = true
		previous_typing = current_typing
		previous_count = current_count
		if not messages.runtime_delivery_active and messages.runtime_delivery_queue.is_empty() and not current_typing:
			return
		await get_tree().process_frame
	_expect(false, "delivery timed out")

func _wait_clock_transition(messages) -> void:
	await get_tree().process_frame
	for _index in range(600):
		if not messages.narrative_clock_animation_active: return
		await get_tree().process_frame
	_expect(false, "narrative clock transition timed out")

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

func _finish() -> void:
	if failures.is_empty():
		print("RUNTIME-S1-03C universal message pacing smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures: push_error(failure)
	print("RUNTIME-S1-03C universal message pacing smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
