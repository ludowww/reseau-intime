extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var size := _parse_size(_arg("--runtime-size", "540x960"))
	var safe_area := _arg("--safe-area", "none")
	get_window().size = size
	var main = MAIN_SCENE.instantiate()
	add_child(main)
	await _frames(5)
	var shell = main.shell
	shell.set_reduced_motion_enabled(true)
	shell.set_safe_area_preset(safe_area)
	var messages = shell.messages_screen
	messages.runtime_delivery_time_scale = 0.01
	await _frames(5)

	var list_layout: Dictionary = shell.describe_layout()
	_expect(list_layout.header_visible, "list global header visible")
	_expect(shell.header_label.text == "Réseau Intime" and shell.header_label.is_visible_in_tree(), "list Réseau Intime visible")
	_expect(_visible_speed_buttons(shell).is_empty(), "list speed button absent")
	_expect(not messages.conversation_screen.visible, "list conversation header absent")
	_expect(list_layout.bottom_navigation_visible, "list bottom navigation visible")
	var list_content_top: float = list_layout.content_rect.position.y

	_press_thread_card(messages, "thread_marie_private")
	await _frames(4)
	var conversation_layout: Dictionary = shell.describe_layout()
	var conversation = messages.conversation_screen
	_expect(not conversation_layout.header_visible, "conversation global header hidden")
	_expect(conversation_layout.content_rect.position.y < list_content_top, "conversation has no residual global header space")
	_expect(conversation.conversation_header.is_visible_in_tree(), "conversation header visible")
	_expect(conversation.back_button.is_visible_in_tree() and conversation.back_button.custom_minimum_size.y >= 44.0, "back remains accessible")
	_expect(conversation.avatar_label.is_visible_in_tree() and conversation.avatar_label.custom_minimum_size.y >= 44.0, "avatar remains visible")
	_expect(conversation.title_label.text.contains("Marie"), "Marie identity visible")
	_expect(_visible_speed_buttons(shell).size() == 1, "one speed button visible")
	_expect(conversation.reading_speed_button == shell.reading_speed_button, "shell owns the single speed visual state")
	_expect(shell.reading_speed_button.text == "×1" and messages.reading_speed_multiplier == 1.0, "initial speed synchronized")
	_press_speed(shell, "×3", 3.0)
	_press_speed(shell, "×8", 8.0)
	_press_speed(shell, "×1", 1.0)
	_press_speed(shell, "×3", 3.0)
	_expect(conversation.timeline.size_flags_vertical == Control.SIZE_EXPAND_FILL, "timeline keeps remaining scrollable space")
	conversation.set_narrative_time("")
	_expect(not conversation.narrative_time_label.visible and conversation.narrative_time_label.custom_minimum_size.y == 0.0, "empty narrative time has no residual height")
	conversation.set_narrative_time("18:20")
	_expect(conversation.narrative_time_label.visible and conversation.narrative_time_label.text == "18:20", "narrative time displays exactly 18:20")
	conversation.set_narrative_time("")
	await _wait_delivery(messages)
	_expect(conversation.choice_bar.visible and conversation.choice_bar.choice_count() > 0, "choices remain accessible")
	_expect(conversation.timeline.reading_position_coherent(), "reading position remains coherent")

	var marie_count: int = messages.thread_message_count("thread_marie_private")
	conversation.back_button.emit_signal("pressed")
	await _frames(4)
	_expect(shell.header_panel.is_visible_in_tree(), "return restores global header")
	_expect(_visible_speed_buttons(shell).is_empty(), "return removes speed from visible surface")
	_expect(not conversation.visible and messages.conversation_list.visible, "return restores list")
	_expect(messages.conversation_list.first_card_has_focus(), "return restores card focus")
	var next_thread_id: String = _another_thread_id(messages, "thread_marie_private")
	_press_thread_card(messages, next_thread_id)
	await _wait_delivery(messages)
	_expect(shell.reading_speed_multiplier == 3.0 and messages.conversation_screen.reading_speed_button.text == "×3", "speed persists across threads")
	_expect(next_thread_id != "" and messages.conversation_screen.title_label.text != "", "new thread updates identity")
	_expect(messages.thread_message_count("thread_marie_private") == marie_count, "thread change does not replay or duplicate Marie transcript")

	await _assert_transition_layout(shell, messages)
	messages._set_screen_mode("conversation")
	messages.conversation_screen.visible = true
	messages.conversation_screen.back_button.disabled = false
	messages._set_gallery_navigation_blocked(false)
	await _frames(2)
	messages.conversation_screen.back_button.emit_signal("pressed")
	await _frames(3)
	shell.activate_gallery(false)
	await _frames(3)
	_expect(shell.header_panel.is_visible_in_tree() and shell.header_label.text == "Réseau Intime", "gallery keeps global header")
	_expect(_visible_speed_buttons(shell).is_empty(), "gallery speed button absent")
	_expect(shell.gallery_screen != null and shell.gallery_panel.visible, "gallery behavior remains available")

	shell.activate_messages(false)
	await _frames(3)
	var final_layout: Dictionary = shell.describe_layout()
	_expect(not final_layout.has_vertical_crop, "no vertical crop")
	_expect(not bool(messages.describe_state().get("has_horizontal_crop", false)), "no horizontal crop")
	_expect(_encloses(Rect2(shell.safe_area_container.get_visible_bounds()), shell.bottom_navigation.get_global_rect()), "bottom navigation inside visible bounds")
	_expect(final_layout.compact_height_mode == (shell.safe_area_container.get_visible_bounds().size.y < 900), "compact mode follows visible bounds")
	_finish(size, safe_area)

func _assert_transition_layout(shell, messages) -> void:
	var bounds := Rect2(shell.safe_area_container.get_visible_bounds())
	messages.conversation_screen.visible = false
	messages._set_screen_mode("off_phone")
	messages._set_gallery_navigation_blocked(true)
	messages.off_phone_transition.configure("Un moment hors téléphone.", messages.PORTRAIT_THEME, true)
	await _frames(3)
	_expect(_encloses(bounds, messages.off_phone_transition.surface_rect()), "off-phone transition contained")
	_expect(messages.off_phone_transition.resume_button.is_visible_in_tree() and messages.off_phone_transition.action_height() >= 44.0, "off-phone action accessible")
	_expect(not shell.describe_layout().has_vertical_crop, "off-phone has no vertical crop")
	messages.off_phone_transition.dismiss()
	messages._set_screen_mode("day_transition")
	messages.day_transition.configure("La journée se termine", "18:20", "Une nouvelle journée commence.", messages.PORTRAIT_THEME, true)
	await _frames(3)
	_expect(_encloses(bounds, messages.day_transition.surface_rect()), "day transition contained")
	_expect(messages.day_transition.continue_button.is_visible_in_tree() and messages.day_transition.action_height() >= 44.0, "day transition action accessible")
	_expect(not shell.describe_layout().has_vertical_crop, "day transition has no vertical crop")
	messages.day_transition.reset_surface()

func _press_speed(shell, expected_label: String, expected_multiplier: float) -> void:
	var button: Button = shell.reading_speed_button
	button.grab_focus()
	button.emit_signal("pressed")
	_expect(button.text == expected_label, "speed cycle reaches " + expected_label)
	_expect(shell.reading_speed_multiplier == expected_multiplier and shell.messages_screen.reading_speed_multiplier == expected_multiplier, "speed multiplier synchronized at " + expected_label)
	_expect(button.custom_minimum_size.x >= 44.0 and button.custom_minimum_size.y >= 44.0 and button.has_focus(), "speed keyboard focus and 44px target")

func _visible_speed_buttons(shell) -> Array:
	var result: Array = []
	for node in shell.find_children("ReadingSpeed", "Button", true, false):
		if node.is_visible_in_tree():
			result.append(node)
	return result

func _press_thread_card(messages, thread_id: String) -> void:
	for index in range(messages.conversation_list.threads.size()):
		if str(messages.conversation_list.threads[index].get("thread_id", "")) == thread_id:
			messages.conversation_list.cards[index].emit_signal("pressed")
			return
	_expect(false, "thread card unavailable: " + thread_id)

func _another_thread_id(messages, excluded_id: String) -> String:
	for thread in messages.conversation_list.threads:
		var thread_id := str(thread.get("thread_id", ""))
		if thread_id != excluded_id:
			return thread_id
	return excluded_id

func _wait_delivery(messages) -> void:
	for _index in range(2400):
		if not messages.runtime_delivery_active:
			await _frames(2)
			return
		await get_tree().process_frame
	_expect(false, "runtime delivery timed out")

func _encloses(outer: Rect2, inner: Rect2) -> bool:
	return inner.size != Vector2.ZERO and outer.grow(1.0).encloses(inner)

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

func _finish(size: Vector2i, safe_area: String) -> void:
	if failures.is_empty():
		print("UI-MSG-04A conversation header responsive smoke %dx%d %s: OK" % [size.x, size.y, safe_area])
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("UI-MSG-04A conversation header responsive smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
