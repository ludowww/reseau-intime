extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")

var failures: Array[String] = []
var transition_visible_count := 0

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var size := _parse_size(_arg("--runtime-size", "720x1280"))
	get_window().size = size
	var main = MAIN_SCENE.instantiate()
	add_child(main)
	await _frames(4)
	var shell = main.shell
	var messages = shell.messages_screen
	var provider = shell.runtime_provider
	_expect(Vector2i(get_window().size) == size, "window must use requested portrait size")
	_expect(not shell.reduced_motion_enabled, "production must start with standard motion")
	messages.runtime_delivery_time_scale = 0.08
	_expect(is_equal_approx(messages._typing_duration_seconds({"content_type": "TEXT", "text": "x".repeat(1000)}), 5.2), "long text typing duration must be capped at 5.2 seconds")

	# Reach Marie's first runtime choice through the production card and button.
	messages.conversation_list.cards[0].emit_signal("pressed")
	await _wait_runtime_delivery_complete(messages)
	await _frames(3)
	var thread_id: String = messages.active_thread_id
	var before: Array = messages.transcripts[thread_id].duplicate(true)
	var before_count: int = before.size()
	var before_players: int = int(messages.thread_player_message_count(thread_id))
	var other_threads_before: Dictionary = provider.presentation_source().get("messages_by_thread", {}).duplicate(true)
	other_threads_before.erase(thread_id)
	var original_button: Button = messages.conversation_screen.choice_bar.buttons[0]
	original_button.emit_signal("pressed")
	original_button.emit_signal("pressed")
	var expected: Array = provider.presentation_source().get("messages_by_thread", {}).get(thread_id, []).duplicate(true)
	var expected_incoming: Array = []
	for index in range(before_count + 1, expected.size()):
		expected_incoming.append(expected[index])

	# Immediate state and duplicate activation.
	_expect(messages.runtime_delivery_active, "delivery must become active immediately")
	_expect(messages.thread_choice_count(thread_id) == 0 and messages.conversation_screen.choice_count() == 0, "old choices must be hidden immediately")
	_expect(messages.thread_player_message_count(thread_id) == before_players + 1, "one Player bubble must be immediate")
	_expect(messages.thread_message_count(thread_id) == before_count + 1, "incoming messages must not be injected immediately")
	_expect(messages.presentation_count_by_id(str(expected[before_count].get("message_id", ""))) == 1, "double activation must not duplicate the Player bubble")
	_expect(expected_incoming.size() >= 2, "fixture must deliver at least two incoming messages")
	_expect(not messages.is_off_phone_transition_active() and not messages.is_day_transition_active(), "transition must not start before final delivery")

	await _wait_until(func(): return messages.conversation_screen.typing_visible(), 180, "first typing phase did not appear")
	var typing = messages.conversation_screen.timeline.typing_indicator
	var typing_rect: Rect2 = typing.get_global_rect()
	var timeline_rect: Rect2 = messages.conversation_screen.timeline.get_global_rect()
	_expect(typing != null and messages.conversation_screen.timeline.typing_instance_count() == 1, "exactly one typing bubble must be visible")
	_expect(typing.dot_count() == 3 and typing.graphic_dot_count() == 3 and not typing.has_dot_label(), "typing must contain three persistent graphic controls")
	_expect(typing.indicator_text() == "" and typing.avatar_text() == "" and not typing.has_time_label(), "private typing must expose no text, author, or time")
	_expect(typing.animation_running() and typing.has_staggered_phases(), "standard typing must use staggered graphic phases")
	var dot_instances: Array = typing.typing_dots.duplicate()
	await _frames(4)
	_expect(typing.typing_dots == dot_instances and typing.dot_count() == 3, "continuous animation must not recreate dots")
	_expect(typing_rect.position.x < timeline_rect.get_center().x, "typing bubble must be aligned to the incoming left side")
	_expect(messages.conversation_screen.timeline.is_last_message_visible(), "timeline must follow typing")
	_expect(messages.conversation_screen.back_button.disabled and shell.gallery_button.disabled, "Back and Gallery must be blocked")
	var screen_before_blocked_actions: String = messages.screen_mode
	messages.return_to_list()
	_expect(messages.screen_mode == screen_before_blocked_actions and shell.active_tab == "messages", "blocked Back/Gallery actions must not leave Messages")
	_expect(get_viewport().gui_get_focus_owner() == null or get_viewport().gui_get_focus_owner() != typing, "typing and auto-scroll must not steal focus")

	# Observe first incoming alone, the pause, then the second typing phase.
	await _wait_until(func(): return messages.thread_message_count(thread_id) == before_count + 2, 240, "first incoming message did not arrive alone")
	_expect(str(messages.transcripts[thread_id][-1].get("message_id", "")) == str(expected_incoming[0].get("message_id", "")), "first incoming order must match provider")
	_expect(messages.thread_message_count(thread_id) == before_count + 2, "first incoming message must arrive alone")
	_expect(not _contains_message_id(messages.transcripts[thread_id], str(expected_incoming[1].get("message_id", ""))), "second incoming message must still be absent after the first")
	_expect(messages.thread_choice_count(thread_id) == 0, "choices must stay absent before delivery completion")
	_expect(messages.conversation_screen.timeline.is_last_message_visible(), "timeline must follow the first incoming message")
	var saw_pause_without_typing: bool = not bool(messages.conversation_screen.typing_visible())
	for _index in range(30):
		if not messages.conversation_screen.typing_visible() and messages.thread_message_count(thread_id) == before_count + 2:
			saw_pause_without_typing = true
		if messages.conversation_screen.typing_visible() and messages.thread_message_count(thread_id) == before_count + 2:
			break
		await get_tree().process_frame
	_expect(saw_pause_without_typing, "inter-message pause must be observable after first delivery")
	_expect(messages.conversation_screen.typing_visible(), "second typing phase must appear after the pause")
	_expect(not _contains_message_id(messages.transcripts[thread_id], str(expected_incoming[1].get("message_id", ""))), "second message must remain absent during second typing")
	_expect(messages.thread_choice_count(thread_id) == 0, "new choices must remain absent during second typing")

	await _wait_runtime_delivery_complete(messages)
	_expect(messages.transcripts[thread_id].size() == expected.size(), "final visual transcript size must match provider")
	_expect(messages._normalized_runtime_transcript(messages.transcripts[thread_id]) == messages._normalized_runtime_transcript(expected), "provider and visual transcripts must match exactly")
	_expect(_ids_unique(messages.transcripts[thread_id]), "final visual transcript IDs must be unique")
	_expect(_ids_unique(expected), "provider transcript IDs must be unique")
	_expect(provider.presentation_source().get("messages_by_thread", {}).duplicate(true).get(thread_id, []) == expected, "provider transcript order/content must remain stable")
	var other_threads_after: Dictionary = provider.presentation_source().get("messages_by_thread", {}).duplicate(true)
	other_threads_after.erase(thread_id)
	_expect(other_threads_after == other_threads_before, "other thread transcript must remain unchanged")
	_expect(messages.thread_choice_count(thread_id) > 0, "new choices must appear only after final delivery")
	_expect(messages.conversation_screen.choice_bar.buttons[0].has_focus(), "first new choice must receive focus")
	_expect(not messages.conversation_screen.back_button.disabled and not shell.gallery_button.disabled, "navigation must be restored after choices")
	_expect(messages.conversation_screen.timeline.is_last_message_visible(), "timeline must end at bottom")

	# A real reduced-motion delivery keeps the delay but runs no tween/loop.
	shell.set_reduced_motion_enabled(true)
	var reduced_button: Button = messages.conversation_screen.choice_bar.buttons[0]
	var reduced_started_ms := Time.get_ticks_msec()
	reduced_button.emit_signal("pressed")
	await _wait_until(func(): return messages.conversation_screen.typing_visible(), 180, "reduced-motion typing did not appear")
	typing = messages.conversation_screen.timeline.typing_indicator
	_expect(typing.dot_count() == 3 and typing.graphic_dot_count() == 3, "reduced motion must retain three circles")
	_expect(not typing.animation_running() and typing.dots_are_static() and not typing.is_processing(), "reduced motion must have no animation loop or tween")
	await _wait_runtime_delivery_complete(messages)
	_expect(Time.get_ticks_msec() - reduced_started_ms >= 50, "reduced-motion delivery must retain a real typing delay")
	shell.set_reduced_motion_enabled(false)

	# Continue with real choices to the first transition and observe its single, late surface.
	await _choose_id(messages, "choice_j1_marie_present")
	await _choose_id(messages, "choice_j1_marie_laverriere_guided")
	transition_visible_count = 0
	messages.off_phone_transition.visibility_changed.connect(func():
		if messages.off_phone_transition.visible:
			transition_visible_count += 1
	)
	var final_button: Variant = _choice_button(messages, "choice_j1_marie_mathilde_guided")
	_expect(final_button != null, "final transition choice must be reachable")
	if final_button != null:
		final_button.emit_signal("pressed")
		_expect(messages.runtime_delivery_active, "final delivery lock must engage immediately")
		_expect(not messages.is_off_phone_transition_active(), "transition must not be premature")
		await _wait_runtime_delivery_complete(messages)
		_expect(messages.is_off_phone_transition_active(), "transition must appear after final message layout")
		_expect(transition_visible_count == 1, "transition surface must be configured exactly once")
		_expect(messages.presentation_count_by_content_type(thread_id, "OFF_PHONE_TRANSITION") == 1, "OFF_PHONE transition marker must be preserved once")
		_expect(_bubble_count_by_content_type(messages.conversation_screen.timeline, "OFF_PHONE_TRANSITION") == 0, "OFF_PHONE_TRANSITION must never render as a bubble")

	# Real rect/crop checks execute independently at both runner resolutions.
	var bounds: Rect2 = messages.get_global_rect()
	timeline_rect = messages.conversation_screen.timeline.get_global_rect()
	_expect(not bool(messages.describe_state().get("has_horizontal_crop", true)), "portrait layout must not crop")
	_expect(bounds.encloses(timeline_rect) or messages.is_off_phone_transition_active(), "timeline rect must remain inside Messages bounds")
	if messages.is_off_phone_transition_active():
		var transition_rect: Rect2 = messages.off_phone_transition.get_global_rect()
		_expect(bounds.encloses(transition_rect) and transition_rect.size.x > 0.0 and transition_rect.size.y > 0.0, "transition rect must remain inside Messages bounds")
	_finish()

func _choose_id(messages, choice_id: String) -> void:
	var button = _choice_button(messages, choice_id)
	_expect(button != null, "choice %s must be reachable" % choice_id)
	if button != null:
		button.emit_signal("pressed")
		await _wait_runtime_delivery_complete(messages)

func _choice_button(messages, choice_id: String):
	for index in range(messages.conversation_screen.choice_bar.choices.size()):
		if str(messages.conversation_screen.choice_bar.choices[index].get("choice_id", "")) == choice_id:
			return messages.conversation_screen.choice_bar.buttons[index]
	return null

func _wait_runtime_delivery_complete(messages) -> void:
	await get_tree().process_frame
	for _index in range(900):
		if not messages.runtime_delivery_active and messages.runtime_delivery_queue.is_empty() and not messages.conversation_screen.typing_visible():
			return
		await get_tree().process_frame
	_expect(false, "runtime delivery timed out")

func _wait_until(predicate: Callable, frames: int, failure: String) -> void:
	for _index in range(frames):
		if predicate.call():
			return
		await get_tree().process_frame
	_expect(false, failure)

func _contains_message_id(transcript: Array, message_id: String) -> bool:
	return transcript.any(func(message): return str(message.get("message_id", "")) == message_id)

func _ids_unique(transcript: Array) -> bool:
	var ids: Dictionary = {}
	for message in transcript:
		var message_id := str(message.get("message_id", ""))
		if message_id == "" or ids.has(message_id):
			return false
		ids[message_id] = true
	return true

func _bubble_count_by_content_type(timeline, content_type: String) -> int:
	var count := 0
	for child in timeline.message_box.get_children():
		if bool(child.get_meta("message_bubble", false)) and str(child.get_meta("content_type", "")) == content_type:
			count += 1
	return count

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

func _finish() -> void:
	if failures.is_empty():
		print("RUNTIME-S1-03B message delivery smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("RUNTIME-S1-03B message delivery smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
