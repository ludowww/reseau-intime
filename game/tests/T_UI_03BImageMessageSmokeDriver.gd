extends Node

const DEMO_SCENE := preload("res://scenes/portrait/PortraitShellDemo.tscn")

var failures: Array[String] = []
var forwarded_requests := 0
var forwarded_message_id := ""
var forwarded_media_ref := ""

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
	var expected_size := _parse_size(_arg("--demo-size", "720x1280"))
	var safe_area := _arg("--safe-area", "none")
	var reduced_motion := _arg("--reduced-motion", "true") == "true"
	shell.set_safe_area_preset(safe_area)
	shell.set_reduced_motion_enabled(reduced_motion)
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(shell.get_window().size == expected_size, "window size must match scenario")
	var messages = shell.messages_screen
	var initial: Dictionary = messages.describe_state()
	var private_id := str(initial.get("private_thread_id", ""))
	var group_id := str(initial.get("group_thread_id", ""))
	_expect(private_id != "" and group_id != "", "private and group fixtures must exist")

	messages.open_thread(private_id)
	await _settle(false)
	messages.conversation_screen.image_requested.connect(_on_forwarded_image_requested)
	var private_state: Dictionary = messages.describe_state()
	_expect(int(private_state.get("image_message_count", 0)) == 1, "private thread must contain exactly one image")
	_expect(private_state.get("image_message_ids", []) == ["demo_image_private_marie_01"], "private image id must match fixture")
	_expect(bool(private_state.get("image_has_caption", false)), "private image caption must be visible")
	_expect(str(private_state.get("image_caption", "")) == "Une photo de démonstration envoyée dans ce fil.", "private caption must match")
	_expect(int(private_state.get("image_with_caption_count", 0)) == 1, "private caption count must be one")
	_expect(int(private_state.get("image_without_caption_count", -1)) == 0, "private no-caption count must be zero")
	_validate_image_geometry(messages)
	_validate_image_bubble(messages, "demo_image_private_marie_01", "21:16", "", "")
	_expect(int(private_state.get("message_count", 0)) == messages.thread_message_count(private_id), "private image must remain a normal presentation")
	_expect(int(private_state.get("message_bubble_count", 0)) == int(private_state.get("message_count", 0)) - int(private_state.get("day_divider_count", 0)) - 1, "private image must count as one bubble while off-phone data stays non-visual")

	var private_before := _state_snapshot(messages, shell)
	messages.conversation_screen.timeline.focus_first_image()
	await get_tree().process_frame
	_expect(str(messages.describe_state().get("focused_image_message_id", "")) == "demo_image_private_marie_01", "private image must receive focus")
	var scroll_before_activation: int = int(messages.conversation_screen.get_reading_position())
	var requests_before := int(messages.describe_state().get("image_request_count", 0))
	messages.conversation_screen.timeline.activate_first_image()
	await get_tree().process_frame
	var private_after: Dictionary = messages.describe_state()
	_expect(int(private_after.get("image_request_count", 0)) == requests_before + 1, "private activation must emit once at timeline")
	_expect(forwarded_requests == 1, "private activation must forward once through conversation")
	_expect(forwarded_message_id == "demo_image_private_marie_01" and forwarded_media_ref == "demo_private_marie_photo", "private signal must preserve internal identifiers")
	_expect(messages.conversation_screen.get_reading_position() == scroll_before_activation, "activation must not change reading position")
	_expect(_state_snapshot(messages, shell) == private_before, "private activation must not mutate messages, choices, unread, typing, day, or surfaces")
	_expect(not bool(private_after.get("image_animation_running", true)), "ImageMessage must never animate")
	_expect(shell.is_photo_viewer_active(), "private activation must open the unique PhotoViewer")
	_expect(shell.photo_viewer.current_photo_id() == "demo_image_private_marie_01", "private viewer must preserve the photo id")
	_expect(shell.photo_viewer.source_kind() == "messages", "private viewer must use Messages source")
	_expect(shell.photo_viewer.displayed_access_state() == "Accessible", "private viewer must display Accessible")
	shell._close_photo_viewer()
	await _settle(false)
	_expect(messages.conversation_screen.timeline.focused_image_message_id() == "demo_image_private_marie_01", "private viewer return must restore image focus")

	var bar: VScrollBar = messages.conversation_screen.timeline.get_v_scroll_bar()
	var scroll_limit := int(bar.max_value - bar.page)
	_expect(scroll_limit > 4, "private transcript must remain scrollable")
	var saved_position := maxi(1, scroll_limit / 2)
	messages.conversation_screen.timeline.set_reading_position(saved_position)
	await get_tree().process_frame
	saved_position = messages.conversation_screen.get_reading_position()
	messages.return_to_list()
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(messages.conversation_list.cards[0].has_focus(), "return must restore private thread card focus")
	_expect(str(messages.conversation_screen.timeline.focused_image_message_id()) == "", "hidden private image must release focus")
	messages.open_thread(private_id)
	await _settle(false)
	_expect(messages.conversation_screen.get_reading_position() == saved_position, "reopening must restore exact reading position")
	messages.conversation_screen.timeline.focus_first_image()
	await get_tree().process_frame
	var requests_before_tab: int = int(messages.describe_state().get("image_request_count", 0))
	shell.gallery_button.emit_signal("pressed")
	await _settle(reduced_motion)
	_expect(shell.gallery_button.has_focus(), "Galerie navigation must receive focus")
	_expect(not messages.conversation_screen.timeline.image_messages[0].image_has_focus(), "hidden image must not keep focus in Galerie")
	_expect(messages.conversation_screen.get_reading_position() == saved_position, "Galerie round trip must preserve scroll while hidden")
	shell.messages_button.emit_signal("pressed")
	await _settle(reduced_motion)
	_expect(str(messages.describe_state().get("active_thread_id", "")) == private_id, "Messages must return to the same thread")
	_expect(messages.conversation_screen.get_reading_position() == saved_position, "Messages return must preserve exact scroll")
	_expect(int(messages.describe_state().get("image_request_count", 0)) == requests_before_tab, "tab return must not auto-activate image")

	messages.return_to_list()
	await get_tree().process_frame
	messages.open_thread(group_id)
	await _settle(false)
	var group_state: Dictionary = messages.describe_state()
	_expect(int(group_state.get("image_message_count", 0)) == 1, "group thread must contain exactly one image")
	_expect(group_state.get("image_message_ids", []) == ["demo_image_group_marie_01"], "group image id must match fixture")
	_expect(not bool(group_state.get("image_has_caption", true)), "group image must have no caption")
	_expect(str(group_state.get("image_caption", "x")) == "", "group caption text must be absent")
	_expect(int(group_state.get("image_with_caption_count", -1)) == 0 and int(group_state.get("image_without_caption_count", 0)) == 1, "group caption counts must prove no ghost caption")
	_expect(messages.conversation_screen.timeline.image_messages[0].get_child_count() == 1, "group image must not create an empty caption label or gap")
	_validate_image_geometry(messages)
	_validate_image_bubble(messages, "demo_image_group_marie_01", "20:46", "Marie", "M")
	_expect(int(group_state.get("message_count", 0)) == messages.thread_message_count(group_id), "group image must remain a normal presentation")
	_expect(int(group_state.get("message_bubble_count", 0)) == int(group_state.get("message_count", 0)) - int(group_state.get("day_divider_count", 0)), "group image must count as one bubble")
	var group_before := _state_snapshot(messages, shell)
	var group_requests_before := int(group_state.get("image_request_count", 0))
	messages.conversation_screen.timeline.focus_first_image()
	await get_tree().process_frame
	messages.conversation_screen.timeline.activate_first_image()
	await get_tree().process_frame
	var group_after: Dictionary = messages.describe_state()
	_expect(int(group_after.get("image_request_count", 0)) == group_requests_before + 1, "group activation must emit exactly once")
	_expect(forwarded_requests == 2, "group activation must forward once")
	_expect(forwarded_message_id == "demo_image_group_marie_01" and forwarded_media_ref == "demo_group_photo", "group signal must preserve internal identifiers")
	_expect(_state_snapshot(messages, shell) == group_before, "group activation must not mutate runtime state")
	_expect(not bool(group_after.get("image_animation_running", true)), "reduced-motion mode must not alter image structure")
	_expect(shell.is_photo_viewer_active(), "group activation must open the unique PhotoViewer")
	_expect(shell.photo_viewer.current_photo_id() == "demo_image_group_marie_01", "group viewer must preserve the photo id")
	_expect(shell.photo_viewer.displayed_access_state() == "Accessible", "group viewer must display Accessible")
	shell._close_photo_viewer()
	await _settle(false)
	_expect(messages.conversation_screen.timeline.focused_image_message_id() == "demo_image_group_marie_01", "group viewer return must restore image focus")

	var capture_path := _arg("--capture", "")
	if capture_path != "":
		var capture_thread := _arg("--capture-thread", "private")
		if capture_thread == "private":
			messages.return_to_list()
			await get_tree().process_frame
			messages.open_thread(private_id)
			await _settle(false)
		var capture_message_id := "demo_image_private_marie_01" if capture_thread == "private" else "demo_image_group_marie_01"
		var capture_row: Control
		for child in messages.conversation_screen.timeline.message_box.get_children():
			if str(child.get_meta("message_id", "")) == capture_message_id:
				capture_row = child
				break
		if capture_row != null:
			messages.conversation_screen.timeline.set_reading_position(maxi(0, int(capture_row.position.y) - 8))
		await get_tree().process_frame
		messages.conversation_screen.timeline.focus_first_image()
		await get_tree().process_frame
		await RenderingServer.frame_post_draw
		var image := get_viewport().get_texture().get_image()
		_expect(image.save_png(capture_path) == OK, "capture must be written")

	_finish()

func _validate_image_geometry(messages) -> void:
	var state: Dictionary = messages.describe_state()
	var target: Vector2 = state.get("minimum_image_target", Vector2.ZERO)
	_expect(absf(float(state.get("image_ratio", 0.0)) - 0.75) < 0.01, "image ratio must be 3:4")
	_expect(target.x >= 240.0 and target.x <= 260.0, "image width must remain within target range")
	_expect(target.y > 48.0, "image touch target must exceed 48 units")
	_expect(not bool(state.get("has_horizontal_crop", true)), "image and conversation must not crop horizontally")
	var image_rect: Rect2 = messages.conversation_screen.timeline.image_messages[0].get_global_rect()
	var choice_rect: Rect2 = messages.conversation_screen.choice_bar.get_global_rect()
	_expect(not image_rect.intersects(choice_rect), "image must not overlap fixed choices")

func _validate_image_bubble(messages, message_id: String, timestamp: String, author_name: String, avatar: String) -> void:
	var row: Control
	for child in messages.conversation_screen.timeline.message_box.get_children():
		if str(child.get_meta("message_id", "")) == message_id:
			row = child
			break
	_expect(row != null, "image bubble row must exist")
	if row == null:
		return
	_expect(str(row.get_meta("content_type", "")) == "IMAGE", "image row must retain IMAGE content type")
	_expect(row.get_child(0) is PanelContainer, "incoming image bubble must align left")
	var time_label = row.find_child("Timestamp", true, false)
	_expect(time_label != null and time_label.text == timestamp and time_label.visible, "image timestamp must remain visible")
	if author_name != "":
		var author_label = row.find_child("Author", true, false)
		var avatar_label = row.find_child("GroupAuthorAvatar", true, false)
		_expect(author_label != null and author_label.text == author_name and author_label.visible, "group image author must be visible")
		_expect(avatar_label != null and avatar_label.text == avatar and avatar_label.visible, "group image avatar must be visible")
		var expected_accent := Color.from_string("#4F8BFF", Color.WHITE)
		_expect(messages.conversation_screen.timeline.image_messages[0].accent.is_equal_approx(expected_accent), "group image must preserve Marie accent")

func _state_snapshot(messages, shell) -> Dictionary:
	return {
		"thread_messages": messages.total_presentation_count(),
		"player_private": messages.thread_player_message_count("demo_private_marie"),
		"player_group": messages.thread_player_message_count("demo_group_verriere"),
		"choice_private": messages.thread_choice_count("demo_private_marie"),
		"choice_group": messages.thread_choice_count("demo_group_verriere"),
		"unread_private": messages.thread_unread_count("demo_private_marie"),
		"unread_group": messages.thread_unread_count("demo_group_verriere"),
		"typing": messages.typing_states_by_thread.duplicate(true),
		"day": messages.current_demo_day(),
		"surfaces": int(shell.messages_panel.visible) + int(shell.gallery_panel.visible),
		"gallery_fixtures": shell.gallery_screen.fixtures.duplicate(true),
	}

func _on_forwarded_image_requested(message_id: String, media_ref: String) -> void:
	forwarded_requests += 1
	forwarded_message_id = message_id
	forwarded_media_ref = media_ref

func _settle(reduced_motion: bool) -> void:
	await get_tree().process_frame
	if not reduced_motion:
		await get_tree().create_timer(0.16).timeout
	await get_tree().process_frame

func _arg(prefix: String, default_value: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="):
			return arg.trim_prefix(prefix + "=")
	return default_value

func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x")
	return Vector2i(int(parts[0]), int(parts[1])) if parts.size() == 2 else Vector2i.ZERO

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _finish() -> void:
	if failures.is_empty():
		print("T-UI-03B ImageMessage smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-03B ImageMessage smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
