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
	var capture_state := _read_cmdline_value("--capture-state", "typing")
	var shell_state: Dictionary = demo.describe_state()
	_expect(Vector2i(demo.get_window().size) == expected_size, "window must match requested portrait size")
	_expect(str(shell_state.get("safe_area_preset", "")) == expected_safe_area, "safe area preset must match")
	_expect(bool(shell_state.get("reduced_motion_enabled", not expected_reduced_motion)) == expected_reduced_motion, "reduced motion override must match")

	var initial: Dictionary = messages.describe_state()
	var private_id := str(initial.get("private_thread_id", ""))
	var group_id := str(initial.get("group_thread_id", ""))
	_expect(private_id != "" and group_id != "", "fixtures must expose private and group threads")
	var private_data_count: int = messages.thread_message_count(private_id)

	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var private_initial: Dictionary = messages.describe_state()
	_expect(int(private_initial.get("day_divider_count", 0)) == 2, "private thread must render two day dividers")
	_expect(private_initial.get("day_divider_labels", []) == ["Mardi", "Plus tard ce soir"], "private day labels must stay player-facing")
	_expect(not bool(private_initial.get("day_divider_has_timestamp", true)), "day dividers must have no timestamp")
	_expect(not bool(private_initial.get("day_divider_has_author", true)), "day dividers must have no author")
	_expect(int(private_initial.get("message_count", -1)) == private_data_count, "render must preserve message_count")
	_expect(int(private_initial.get("message_bubble_count", -1)) == private_data_count - 2, "visual bubbles must exclude day dividers")
	_expect(int(private_initial.get("unread_divider_count", 0)) == 1, "first open must render exactly one unread divider")
	_expect(bool(private_initial.get("day_divider_precedes_unread", false)), "order must be DayDivider then UnreadDivider then unread MessageBubble")
	_expect(messages.all_messages_read(private_id), "opening must mark all private presentations read")
	_expect(_system_presentations_are_read(messages, private_id), "system day presentations must remain read")
	if capture_path != "" and capture_state == "unread":
		_align_second_day_divider(messages.conversation_screen.timeline)
		await get_tree().process_frame
		await _save_capture(capture_path)

	# Day markers survive read state and reopening without recreating unread UI.
	messages.return_to_list()
	await get_tree().process_frame
	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var reopened: Dictionary = messages.describe_state()
	_expect(int(reopened.get("day_divider_count", 0)) == 2, "reopening must preserve day dividers")
	_expect(int(reopened.get("unread_divider_count", -1)) == 0, "reopening a read thread must not recreate unread divider")

	# Exact reading position restoration must not be perturbed by day markers.
	messages.conversation_screen.timeline.scroll_to_last_message()
	await get_tree().process_frame
	var bottom: int = messages.conversation_screen.get_reading_position()
	var requested_intermediate := maxi(1, bottom / 2)
	messages.conversation_screen.timeline.set_reading_position(requested_intermediate)
	await get_tree().process_frame
	var saved_position: int = messages.conversation_screen.get_reading_position()
	_expect(saved_position > 0 and saved_position < bottom, "fixture must expose an intermediate reading position")
	messages.return_to_list()
	await get_tree().process_frame
	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var restored_position: int = messages.conversation_screen.get_reading_position()
	_expect(restored_position == saved_position, "day dividers must preserve exact reading position")

	# Typing remains last and never changes or duplicates day markers.
	var day_labels_before_typing: Variant = messages.describe_state().get("day_divider_labels", [])
	messages.start_typing(private_id, "marie")
	await get_tree().process_frame
	await get_tree().process_frame
	var typing_state: Dictionary = messages.describe_state()
	_expect(int(typing_state.get("day_divider_count", 0)) == 2, "typing must preserve day divider count")
	_expect(typing_state.get("day_divider_labels", []) == day_labels_before_typing, "typing must preserve day labels")
	_expect(bool(typing_state.get("typing_last_item", false)), "typing indicator must remain the last rendered item")
	messages.stop_typing(private_id)
	await get_tree().process_frame
	_expect(int(messages.describe_state().get("day_divider_count", 0)) == 2, "stopping typing must preserve day dividers")

	# One incoming message changes only the message/bubble counts.
	var before_incoming: int = messages.thread_message_count(private_id)
	messages.start_typing(private_id, "marie")
	messages.simulate_incoming_message(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var after_incoming: Dictionary = messages.describe_state()
	_expect(messages.thread_message_count(private_id) == before_incoming + 1, "incoming simulation must add exactly one message")
	_expect(int(after_incoming.get("day_divider_count", 0)) == 2, "incoming message must preserve day dividers")
	_expect(after_incoming.get("day_divider_labels", []) == day_labels_before_typing, "incoming message must preserve day labels")
	_expect(int(after_incoming.get("message_bubble_count", -1)) == int(after_incoming.get("message_count", 0)) - 2, "incoming text must add one bubble only")

	# Group fixture keeps its one day marker and existing authors.
	messages.return_to_list()
	await get_tree().process_frame
	messages.open_thread(group_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var group_state: Dictionary = messages.describe_state()
	_expect(int(group_state.get("day_divider_count", 0)) == 1, "group must render one day divider")
	_expect(group_state.get("day_divider_labels", []) == ["Mercredi"], "group label must be deterministic")
	_expect(bool(group_state.get("group_author_visible", false)), "group author names must remain visible")
	_expect(bool(group_state.get("group_author_avatar_visible", false)), "group author avatars must remain visible")
	_expect(bool(group_state.get("group_author_accent_visible", false)), "group author accents must remain distinct")

	# Gallery round trip preserves state without duplication.
	shell.gallery_button.emit_signal("pressed")
	await get_tree().create_timer(0.2).timeout
	_expect(shell.gallery_panel.visible, "Gallery must remain available")
	shell.messages_button.emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame
	var after_gallery: Dictionary = messages.describe_state()
	_expect(int(after_gallery.get("day_divider_count", 0)) == 1, "Gallery round trip must not duplicate day divider")
	_expect(after_gallery.get("day_divider_labels", []) == ["Mercredi"], "Gallery round trip must preserve group divider")
	_expect(not bool(after_gallery.get("has_horizontal_crop", true)), "Messages UI must not crop horizontally")

	var useful_bounds: Rect2i = shell.safe_area_container.get_visible_bounds()
	var timeline_rect: Rect2 = messages.conversation_screen.timeline.get_global_rect()
	var choice_rect: Rect2 = messages.conversation_screen.choice_bar.get_global_rect()
	_expect(timeline_rect.size.x > 0.0 and timeline_rect.size.y > 0.0, "timeline bounds must be positive")
	_expect(not timeline_rect.intersects(choice_rect), "timeline must not overlap fixed choices")
	_expect(timeline_rect.position.x >= useful_bounds.position.x and timeline_rect.end.x <= useful_bounds.end.x, "timeline must remain inside safe width")

	# Leave a representative private state for the optional visual capture.
	messages.return_to_list()
	await get_tree().process_frame
	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	messages.start_typing(private_id, "marie")
	await get_tree().process_frame
	await get_tree().process_frame
	if capture_path != "" and capture_state != "unread":
		_align_second_day_divider(messages.conversation_screen.timeline)
		await get_tree().process_frame
		await _save_capture(capture_path)

	print("T-UI-02B3 counts: private_data=%d private_dividers=2 group_dividers=1 restored=%d" % [private_data_count, restored_position])
	_finish()

func _system_presentations_are_read(messages, thread_id: String) -> bool:
	var presentations: Variant = messages.transcripts.get(thread_id, [])
	if not presentations is Array:
		return false
	for presentation in presentations:
		if presentation is Dictionary and str(presentation.get("content_type", "")) == "SYSTEM_DAY_DIVIDER":
			if not bool(presentation.get("is_read", false)):
				return false
	return true

func _align_second_day_divider(timeline) -> void:
	var seen := 0
	for child in timeline.message_box.get_children():
		if child.has_method("display_text"):
			seen += 1
			if seen == 2:
				timeline.set_reading_position(int(child.position.y))
				return
	timeline.scroll_to_last_message()

func _save_capture(path: String) -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var save_error := image.save_png(path)
	_expect(save_error == OK, "visual capture must save successfully")
	print("T-UI-02B3 capture: %s" % path)

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
		print("T-UI-02B3 day divider smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-02B3 day divider smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
