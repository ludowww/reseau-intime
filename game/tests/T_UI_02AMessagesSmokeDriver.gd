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
	var shell_state: Dictionary = demo.describe_state()
	var actual_window := Vector2i(int(demo.get_window().size.x), int(demo.get_window().size.y))
	var actual_viewport := Vector2i(shell_state.get("viewport_size", Vector2i.ZERO))
	_expect(actual_window == expected_size, "window must match the requested portrait size: expected %s, got %s" % [expected_size, actual_window])
	_expect(actual_viewport.x > 0 and actual_viewport.y > actual_viewport.x, "internal design viewport must remain a valid portrait surface")
	_expect(str(shell_state.get("safe_area_preset", "")) == expected_safe_area, "safe area preset must match")
	_expect(bool(shell_state.get("reduced_motion_enabled", not expected_reduced_motion)) == expected_reduced_motion, "reduced motion override must match")
	messages.focus_first_conversation()
	await get_tree().process_frame
	var initial: Dictionary = messages.describe_state()
	_expect(str(initial.get("screen", "")) == "list", "launch must show the conversation list")
	_expect(int(initial.get("thread_count", 0)) >= 2, "conversation list must contain private and group threads")
	_expect(bool(initial.get("list_visible", false)), "conversation list must be visible")
	_expect(bool(initial.get("list_has_focus", false)), "first conversation must receive keyboard focus")
	_expect(not bool(initial.get("has_horizontal_crop", true)), "list text must not crop horizontally")

	var private_id := str(initial.get("private_thread_id", ""))
	messages.conversation_list.cards[0].emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame
	var opened: Dictionary = messages.describe_state()
	_expect(str(opened.get("screen", "")) == "conversation", "private thread must open")
	_expect(str(opened.get("active_thread_id", "")) == private_id, "private thread id must stay active")
	_expect(str(opened.get("conversation_title", "")) != "", "conversation header must show a name")
	_expect(messages.conversation_screen.avatar_label.size.x <= 64.0, "conversation avatar must remain compact")
	var timeline_width: float = messages.conversation_screen.timeline.size.x
	var message_box_width: float = messages.conversation_screen.timeline.message_box.size.x
	var scrollbar_width: float = messages.conversation_screen.timeline.get_v_scroll_bar().size.x
	_expect(message_box_width <= timeline_width - scrollbar_width, "message bubbles must reserve clearance for the vertical scrollbar")
	_expect(int(opened.get("choice_count", 0)) >= 1 and int(opened.get("choice_count", 0)) <= 3, "ChoiceBar must expose one to three choices")
	_expect(bool(opened.get("last_message_visible", false)), "last message must remain visible above choices")
	_expect(not bool(opened.get("has_horizontal_crop", true)), "long message and choice must wrap without horizontal crop")
	_expect(bool(opened.get("choice_has_focus", false)), "first choice must receive keyboard focus")
	var test_choices: Array[Dictionary] = messages.available_choices[private_id].duplicate(true)
	test_choices[0]["enabled"] = false
	messages.conversation_screen.choice_bar.set_choices(test_choices)
	await get_tree().process_frame
	_expect(messages.conversation_screen.choice_bar.buttons[1].has_focus(), "first enabled choice must receive keyboard focus")
	var selected_choice: Dictionary = test_choices[1]
	var before_player := int(opened.get("player_message_count", -1))
	var before_total := int(opened.get("message_count", -1))
	messages.activate_first_choice()
	await get_tree().process_frame
	await get_tree().process_frame
	var after_choice: Dictionary = messages.describe_state()
	_expect(int(after_choice.get("player_message_count", -1)) == before_player + 1, "one choice must append exactly one Player bubble")
	_expect(int(after_choice.get("message_count", -1)) == before_total + 1, "one choice must append exactly one total bubble")
	_expect(int(after_choice.get("choice_count", -1)) == 0, "ChoiceBar must close after selection")
	_expect(messages.conversation_screen.back_button.has_focus(), "keyboard focus must move to Back after a choice closes")
	messages._on_choice_selected(selected_choice)
	await get_tree().process_frame
	var after_stale_choice: Dictionary = messages.describe_state()
	_expect(int(after_stale_choice.get("player_message_count", -1)) == before_player + 1, "a consumed choice signal must not append a second Player bubble")
	_expect(int(after_stale_choice.get("message_count", -1)) == before_total + 1, "a consumed choice signal must not append a second total bubble")
	var private_bar: VScrollBar = messages.conversation_screen.timeline.get_v_scroll_bar()
	var private_scroll_limit := int(private_bar.max_value - private_bar.page)
	_expect(private_scroll_limit > 4, "private demo transcript must be long enough to exercise vertical scrolling")
	var saved_reading_position := maxi(1, private_scroll_limit / 2)
	messages.conversation_screen.timeline.set_reading_position(saved_reading_position)
	await get_tree().process_frame
	saved_reading_position = messages.conversation_screen.get_reading_position()

	messages.conversation_screen.back_button.emit_signal("pressed")
	await get_tree().process_frame
	var list_again: Dictionary = messages.describe_state()
	_expect(str(list_again.get("group_thread_id", "")) != "", "group thread must remain listed")
	messages.conversation_list.cards[1].emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame
	var group_state: Dictionary = messages.describe_state()
	_expect(bool(group_state.get("is_group", false)), "group thread must identify itself as a group")
	_expect(bool(group_state.get("group_author_visible", false)), "group bubbles must show author name")
	_expect(bool(group_state.get("group_author_avatar_visible", false)), "group bubbles must show author avatar or initial")
	_expect(bool(group_state.get("group_author_accent_visible", false)), "group author accent must be visible")

	messages.conversation_screen.back_button.emit_signal("pressed")
	await get_tree().process_frame
	_expect(messages.conversation_list.cards[1].has_focus(), "return must restore focus to the conversation card that was left")
	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var reopened: Dictionary = messages.describe_state()
	_expect(int(reopened.get("player_message_count", -1)) == before_player + 1, "private transcript must survive reopening during the session")
	_expect(int(reopened.get("message_count", -1)) == before_total + 1, "full transcript must survive reopening")
	_expect(bool(reopened.get("reading_position_coherent", false)), "reading position must return coherently")
	_expect(messages.conversation_screen.get_reading_position() == saved_reading_position, "reopening must restore the exact reading position")

	shell.gallery_button.emit_signal("pressed")
	await get_tree().process_frame
	_expect(shell.gallery_panel.visible, "Galerie placeholder must remain reachable")
	var gallery_rect: Rect2 = shell.gallery_panel.get_global_rect()
	var messages_rect: Rect2 = shell.messages_panel.get_global_rect()
	var useful_bounds: Rect2i = shell.safe_area_container.get_visible_bounds()
	_expect(gallery_rect.size.x > 0.0 and gallery_rect.size.y > 0.0, "Galerie surface must have positive width and height")
	_expect(gallery_rect.position.is_equal_approx(messages_rect.position) and gallery_rect.size.is_equal_approx(messages_rect.size), "Galerie must occupy the same content surface as Messages")
	_expect(gallery_rect.position.x >= float(useful_bounds.position.x) and gallery_rect.position.y >= float(useful_bounds.position.y), "Galerie surface must stay inside the useful shell bounds at top-left")
	_expect(gallery_rect.end.x <= float(useful_bounds.end.x) and gallery_rect.end.y <= float(useful_bounds.end.y), "Galerie surface must stay inside the useful shell bounds at bottom-right")
	shell.messages_button.emit_signal("pressed")
	await get_tree().process_frame
	_expect(shell.messages_panel.visible, "Messages must remain reachable after Galerie")
	_expect(str(messages.describe_state().get("active_thread_id", "")) == private_id, "Messages state must survive tab navigation")
	_finish()

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
		print("T-UI-02A Messages smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-02A Messages smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
