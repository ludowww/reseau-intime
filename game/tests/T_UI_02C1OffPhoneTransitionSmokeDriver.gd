extends Node

const DEMO_SCENE := preload("res://scenes/portrait/PortraitShellDemo.tscn")

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var demo = DEMO_SCENE.instantiate()
	add_child(demo)
	await get_tree().process_frame
	await get_tree().process_frame
	var shell = demo.shell
	_expect(shell != null, "portrait shell is missing")
	if shell == null:
		_finish()
		return
	var messages = shell.messages_screen
	_expect(messages != null, "MessagesScreen is missing")
	if messages == null:
		_finish()
		return

	var expected_size := _parse_size(_read_cmdline_value("--demo-size", ""))
	var expected_safe_area := _read_cmdline_value("--safe-area", "none")
	var expected_reduced_motion := _read_cmdline_value("--reduced-motion", "true") != "false"
	var capture_path := _read_cmdline_value("--capture", "")
	var shell_state: Dictionary = demo.describe_state()
	_expect(Vector2i(demo.get_window().size) == expected_size, "window must match requested portrait size")
	_expect(str(shell_state.get("safe_area_preset", "")) == expected_safe_area, "safe area preset must match")
	_expect(bool(shell_state.get("reduced_motion_enabled", not expected_reduced_motion)) == expected_reduced_motion, "reduced motion override must match")

	var initial: Dictionary = messages.describe_state()
	var private_id := str(initial.get("private_thread_id", ""))
	var group_id := str(initial.get("group_thread_id", ""))
	_expect(private_id != "" and group_id != "", "fixtures must expose private and group threads")
	_expect(_off_phone_presentations(messages, private_id).size() == 1, "private fixture must contain one off-phone presentation")
	_expect(_off_phone_presentations(messages, group_id).is_empty(), "group fixture must not contain a transition")
	var transition_data: Dictionary = _off_phone_presentations(messages, private_id)[0] if _off_phone_presentations(messages, private_id).size() == 1 else {}
	_expect(str(transition_data.get("author_id", "")) == "system", "transition author must be system")
	_expect(str(transition_data.get("timestamp", "x")) == "", "transition timestamp must be empty")
	_expect(bool(transition_data.get("is_read", false)), "transition presentation must remain read")
	_expect(not bool(transition_data.get("is_player", true)), "transition presentation must not be Player")

	# Create a foreign banner, then enter the private thread: it must survive the transition data-wise.
	messages.simulate_incoming_message(group_id)
	await get_tree().process_frame
	_expect(str(messages.describe_state().get("notification_thread_id", "")) == group_id, "foreign notification fixture must exist")
	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(str(messages.describe_state().get("notification_thread_id", "")) == group_id, "opening private must preserve foreign notification")
	_expect(int(messages.describe_state().get("off_phone_presentation_count", 0)) == 1, "off-phone data must remain ordered in transcript data")
	_expect(int(messages.describe_state().get("message_bubble_count", -1)) == messages.thread_message_count(private_id) - 3, "off-phone and day presentations must not render as bubbles")

	messages.conversation_screen.timeline.scroll_to_last_message()
	await get_tree().process_frame
	var bottom: int = messages.conversation_screen.get_reading_position()
	messages.conversation_screen.timeline.set_reading_position(maxi(1, bottom / 2))
	await get_tree().process_frame
	var before_position: int = messages.conversation_screen.get_reading_position()
	_expect(before_position > 0 and before_position < bottom, "fixture must expose an exact intermediate reading position")
	var before_message_count: int = messages.thread_message_count(private_id)
	var before_player_count: int = messages.thread_player_message_count(private_id)
	var before_unread: int = messages.thread_unread_count(private_id)
	var before_choices: int = messages.thread_choice_count(private_id)
	var before_day_count := int(messages.describe_state().get("day_divider_count", -1))
	var before_day_labels: Variant = messages.describe_state().get("day_divider_labels", [])
	var before_focus = get_viewport().gui_get_focus_owner()

	messages.start_typing(private_id, "marie")
	await get_tree().process_frame
	_expect(messages.is_thread_typing(private_id), "typing state must start before co-presence")
	messages.start_off_phone_transition("missing_demo_thread")
	_expect(not messages.is_off_phone_transition_active(), "missing thread must be ignored")
	messages.start_off_phone_transition(private_id)
	await get_tree().process_frame
	var active: Dictionary = messages.describe_state()
	_expect(messages.is_off_phone_transition_active(), "off-phone state must activate")
	_expect(str(active.get("off_phone_thread_id", "")) == private_id, "transition must retain the same private thread")
	_expect(bool(active.get("off_phone_visible", false)), "one off-phone surface must be visible")
	_expect(int(active.get("off_phone_surface_count", 0)) == 1, "surface must not duplicate")
	_expect(int(active.get("off_phone_action_count", 0)) == 1, "surface must expose exactly one resume action")
	_expect(not bool(active.get("list_visible", true)) and not bool(active.get("conversation_visible", true)), "list and conversation must be hidden")
	_expect(not bool(active.get("notification_visible", true)), "no notification may overlay co-presence")
	_expect(int(active.get("typing_instance_count", 0)) == 0, "typing visual must be suspended")
	_expect(messages.is_thread_typing(private_id), "typing state must be retained locally")
	_expect(bool(active.get("off_phone_action_focus", false)), "resume action must receive focus")
	_expect(float(active.get("off_phone_action_height", 0.0)) >= 48.0, "resume action touch target must be at least 48")
	_expect(not shell.gallery_button.disabled == false, "Gallery button must be disabled during co-presence")
	if expected_reduced_motion:
		_expect(not bool(active.get("off_phone_animation_running", true)), "reduced motion must be instant")
	else:
		_expect(bool(active.get("off_phone_animation_running", false)), "standard motion must begin a short fade")

	# Every mutable/navigation action must be a deterministic no-op.
	messages.start_off_phone_transition(private_id)
	messages.start_off_phone_transition(group_id)
	messages.simulate_incoming_message(private_id)
	messages.start_typing(private_id, "sandra")
	messages.stop_typing(private_id)
	messages.activate_first_choice()
	messages.open_thread(group_id)
	messages.return_to_list()
	await get_tree().process_frame
	_expect(int(messages.describe_state().get("off_phone_surface_count", 0)) == 1, "double or foreign start must not duplicate")
	_expect(messages.thread_message_count(private_id) == before_message_count, "co-presence must add no incoming message")
	_expect(messages.thread_player_message_count(private_id) == before_player_count, "co-presence must add no Player message")
	_expect(messages.thread_unread_count(private_id) == before_unread, "co-presence must add no unread")
	_expect(messages.thread_choice_count(private_id) == before_choices, "co-presence must consume no choice")
	_expect(str(messages.describe_state().get("off_phone_thread_id", "")) == private_id, "co-presence must not switch thread")

	# Direct shell navigation is neutralized and returns immediately to Messages.
	shell.activate_gallery(false)
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(str(shell.describe_layout().get("active_tab", "")) == "messages", "Gallery navigation must be neutralized while active")
	_expect(messages.is_off_phone_transition_active(), "neutralized Gallery must preserve transition")

	if capture_path != "":
		await _save_capture(capture_path)

	# Explicit demo action ends locally and restores exact state.
	messages.off_phone_transition.resume_button.emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame
	var resumed: Dictionary = messages.describe_state()
	var after_focus = get_viewport().gui_get_focus_owner()
	_expect(not messages.is_off_phone_transition_active(), "resume action must finish transition")
	_expect(str(resumed.get("active_thread_id", "")) == private_id, "resume must restore same thread")
	_expect(bool(resumed.get("conversation_visible", false)) and not bool(resumed.get("list_visible", true)), "conversation alone must return")
	_expect(messages.thread_message_count(private_id) == before_message_count, "transcript count must be identical")
	_expect(messages.thread_player_message_count(private_id) == before_player_count, "Player count must be identical")
	_expect(messages.thread_unread_count(private_id) == before_unread, "unread count must be identical")
	_expect(messages.thread_choice_count(private_id) == before_choices, "choices must be identical")
	_expect(int(resumed.get("day_divider_count", -1)) == before_day_count, "day dividers must be identical")
	_expect(resumed.get("day_divider_labels", []) == before_day_labels, "day labels must be identical")
	_expect(messages.conversation_screen.get_reading_position() == before_position, "reading position must restore exactly")
	_expect(messages.is_thread_typing(private_id), "typing state must restore")
	_expect(int(resumed.get("typing_instance_count", 0)) == 1, "typing visual must restore once")
	_expect(str(resumed.get("notification_thread_id", "")) == group_id, "foreign notification must be restored")
	_expect(after_focus == before_focus or bool(resumed.get("choice_has_focus", false)) or (messages.conversation_screen.back_button != null and messages.conversation_screen.back_button.has_focus()), "focus must restore or use coherent fallback")
	_expect(not shell.gallery_button.disabled, "Gallery must be re-enabled after resume")

	# A second complete cycle on the same thread must rebuild one bounded surface only.
	messages.start_off_phone_transition(private_id)
	await get_tree().process_frame
	var second_active: Dictionary = messages.describe_state()
	_expect(messages.is_off_phone_transition_active(), "second cycle must activate")
	_expect(int(second_active.get("off_phone_surface_count", 0)) == 1, "second cycle must keep one surface")
	_expect(int(second_active.get("off_phone_action_count", 0)) == 1, "second cycle must keep one resume action")
	_expect(str(second_active.get("off_phone_thread_id", "")) == private_id, "second cycle must retain the same thread")
	messages.finish_off_phone_transition()
	await get_tree().process_frame
	await get_tree().process_frame
	var second_resumed: Dictionary = messages.describe_state()
	_expect(not messages.is_off_phone_transition_active(), "second cycle must finish")
	_expect(str(second_resumed.get("active_thread_id", "")) == private_id, "second cycle must restore the same thread")
	_expect(messages.thread_message_count(private_id) == before_message_count, "second cycle must preserve transcript count")
	_expect(messages.thread_player_message_count(private_id) == before_player_count, "second cycle must preserve Player count")
	_expect(messages.thread_unread_count(private_id) == before_unread, "second cycle must preserve unread count")
	_expect(messages.thread_choice_count(private_id) == before_choices, "second cycle must preserve choices")
	_expect(int(second_resumed.get("day_divider_count", -1)) == before_day_count, "second cycle must preserve day dividers")
	_expect(second_resumed.get("day_divider_labels", []) == before_day_labels, "second cycle must preserve day labels")
	_expect(messages.conversation_screen.get_reading_position() == before_position, "second cycle must restore exact reading position")
	messages.finish_off_phone_transition()
	_expect(not messages.is_off_phone_transition_active(), "finish after second cycle must be a no-op")

	# Gallery remains unchanged and usable only after reprise.
	shell.activate_gallery(false)
	await get_tree().process_frame
	_expect(str(shell.describe_layout().get("active_tab", "")) == "gallery", "Gallery must work after reprise")
	shell.activate_messages(false)
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(str(messages.describe_state().get("active_thread_id", "")) == private_id, "Gallery round trip must preserve thread")
	_expect(messages.thread_message_count(private_id) == before_message_count, "Gallery round trip must preserve transcript")

	var useful_bounds: Rect2i = shell.safe_area_container.get_visible_bounds()
	var surface_rect: Rect2 = messages.off_phone_transition.get_global_rect()
	_expect(surface_rect.size.x > 0.0 and surface_rect.size.y > 0.0, "off-phone surface bounds must remain measurable")
	_expect(surface_rect.position.x >= useful_bounds.position.x and surface_rect.end.x <= useful_bounds.end.x, "surface must remain inside safe width")
	_expect(not bool(messages.describe_state().get("has_horizontal_crop", true)), "Messages UI must not crop horizontally")

	print("T-UI-02C1 state: messages=%d player=%d unread=%d choices=%d position=%d" % [before_message_count, before_player_count, before_unread, before_choices, before_position])
	_finish()

func _off_phone_presentations(messages, thread_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var values: Variant = messages.transcripts.get(thread_id, [])
	if values is Array:
		for value in values:
			if value is Dictionary and str(value.get("content_type", "")) == "OFF_PHONE_TRANSITION":
				result.append(value)
	return result

func _save_capture(path: String) -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var save_error := image.save_png(path)
	_expect(save_error == OK, "visual capture must save successfully")
	print("T-UI-02C1 capture: %s" % path)

func _read_cmdline_value(prefix: String, default_value: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="):
			return arg.trim_prefix(prefix + "=")
	return default_value

func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x")
	if parts.size() != 2:
		return Vector2i.ZERO
	return Vector2i(int(parts[0]), int(parts[1]))

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _finish() -> void:
	if failures.is_empty():
		print("T-UI-02C1 off-phone transition smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-02C1 off-phone transition smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
