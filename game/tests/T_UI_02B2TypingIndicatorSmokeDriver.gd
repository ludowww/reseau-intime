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
	_expect(Vector2i(demo.get_window().size) == expected_size, "window must match requested portrait size")
	_expect(str(shell_state.get("safe_area_preset", "")) == expected_safe_area, "safe area preset must match")
	_expect(bool(shell_state.get("reduced_motion_enabled", not expected_reduced_motion)) == expected_reduced_motion, "reduced motion override must match")

	messages.focus_first_conversation()
	await get_tree().process_frame
	var initial: Dictionary = messages.describe_state()
	var private_id := str(initial.get("private_thread_id", ""))
	var group_id := str(initial.get("group_thread_id", ""))
	_expect(private_id != "" and group_id != "", "fixtures must expose private and group threads")

	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame

	# A pending explicit restoration must win over a typing indicator added while closed.
	messages.conversation_screen.timeline.scroll_to_last_message()
	await get_tree().process_frame
	var private_bottom_before_restore: int = messages.conversation_screen.get_reading_position()
	var requested_intermediate := maxi(1, private_bottom_before_restore / 2)
	messages.conversation_screen.timeline.set_reading_position(requested_intermediate)
	await get_tree().process_frame
	var saved_intermediate: int = messages.conversation_screen.get_reading_position()
	_expect(saved_intermediate > 0 and saved_intermediate < private_bottom_before_restore, "fixture must expose an intermediate reading position")
	messages.return_to_list()
	await get_tree().process_frame
	messages.start_typing(private_id, "marie")
	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var restored_intermediate: int = messages.conversation_screen.get_reading_position()
	_expect(restored_intermediate == saved_intermediate, "typing must preserve the exact restored reading position")
	_expect(int(messages.describe_state().get("typing_instance_count", 0)) == 1, "restored thread must still show one indicator")
	_expect(bool(messages.describe_state().get("typing_last_item", false)), "restored indicator must remain after messages")
	_expect(not bool(messages.describe_state().get("last_message_visible", true)), "restored intermediate position must not jump to bottom")
	print("T-UI-02B2 reading position: saved=%d restored=%d bottom=%d" % [saved_intermediate, restored_intermediate, private_bottom_before_restore])

	# A transcript already following the bottom must continue following it.
	messages.conversation_screen.timeline.scroll_to_last_message()
	await get_tree().process_frame
	_expect(bool(messages.describe_state().get("last_message_visible", false)), "fixture must reach bottom before typing replacement")
	messages.start_typing(private_id, "marie")
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(bool(messages.describe_state().get("last_message_visible", false)), "typing replacement must keep following an existing bottom")
	messages.stop_typing(private_id)
	await get_tree().process_frame

	var message_before: int = messages.thread_message_count(private_id)
	var player_before: int = messages.thread_player_message_count(private_id)
	var choices_before: int = messages.thread_choice_count(private_id)
	var unread_before: int = messages.thread_unread_count(private_id)
	var divider_before: int = int(messages.describe_state().get("unread_divider_count", -1))
	var focus_before = get_viewport().gui_get_focus_owner()

	messages.start_typing(private_id, "marie")
	await get_tree().process_frame
	await get_tree().process_frame
	var private_typing: Dictionary = messages.describe_state()
	_expect(messages.is_thread_typing(private_id), "private typing state must be active")
	_expect(int(private_typing.get("typing_instance_count", 0)) == 1, "private thread must show exactly one indicator")
	_expect(bool(private_typing.get("typing_visible", false)), "private indicator must be visible")
	_expect(messages.thread_message_count(private_id) == message_before, "typing must not change message count")
	_expect(messages.thread_player_message_count(private_id) == player_before, "typing must not change Player count")
	_expect(messages.thread_choice_count(private_id) == choices_before, "typing must not change choices")
	_expect(messages.thread_unread_count(private_id) == unread_before, "typing must not change unread")
	_expect(int(private_typing.get("unread_divider_count", -1)) == divider_before, "typing must not affect unread divider")
	_expect(get_viewport().gui_get_focus_owner() == focus_before, "start typing must preserve focus")
	_expect(str(private_typing.get("typing_avatar", "")) == "", "private indicator must not repeat author identity")
	_expect(not bool(private_typing.get("typing_has_timestamp", true)), "typing must have no timestamp")
	_expect(bool(private_typing.get("typing_last_item", false)), "indicator must be after the last message")
	_expect(bool(private_typing.get("last_message_visible", false)), "typing must remain reachable at timeline bottom")

	messages.start_typing(private_id, "marie")
	await get_tree().process_frame
	_expect(int(messages.describe_state().get("typing_instance_count", 0)) == 1, "starting twice must not duplicate indicator")
	_expect(get_viewport().gui_get_focus_owner() == focus_before, "repeated start must preserve focus")
	if expected_reduced_motion:
		_expect(str(messages.describe_state().get("typing_text", "")) == "…", "reduced motion must show a static ellipsis")
		_expect(not bool(messages.describe_state().get("typing_animation_running", true)), "reduced motion must not animate")
	else:
		_expect(bool(messages.describe_state().get("typing_animation_running", false)), "standard motion must animate points")
		var phase_one := str(messages.describe_state().get("typing_text", ""))
		messages.conversation_screen.advance_typing_phase()
		var phase_two := str(messages.describe_state().get("typing_text", ""))
		messages.conversation_screen.advance_typing_phase()
		var phase_three := str(messages.describe_state().get("typing_text", ""))
		_expect(phase_one != phase_two and phase_two != phase_three, "typing phases must evolve")
		_expect(get_viewport().gui_get_focus_owner() == focus_before, "phase changes must preserve focus")

	messages.stop_typing(private_id)
	await get_tree().process_frame
	_expect(not messages.is_thread_typing(private_id), "stop must clear private state")
	_expect(int(messages.describe_state().get("typing_instance_count", -1)) == 0, "stop must remove indicator")
	_expect(messages.thread_message_count(private_id) == message_before, "stop must not change messages")
	_expect(get_viewport().gui_get_focus_owner() == focus_before, "stop must preserve focus")
	messages.stop_typing(private_id)
	messages.start_typing("missing_demo_thread", "marie")
	messages.start_typing(private_id, "missing_author")
	messages.start_typing(private_id, "player")
	_expect(not messages.is_thread_typing(private_id), "invalid thread, author, and Player must be ignored")

	messages.start_typing(group_id, "sandra")
	_expect(messages.is_thread_typing(group_id), "closed group typing state must be remembered")
	_expect(not bool(messages.describe_state().get("typing_visible", false)), "closed thread typing must not leak into private thread")
	messages.return_to_list()
	await get_tree().process_frame
	messages.open_thread(group_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var group_state: Dictionary = messages.describe_state()
	_expect(bool(group_state.get("typing_visible", false)), "group typing must appear when group opens")
	_expect(int(group_state.get("typing_instance_count", 0)) == 1, "group must show one indicator")
	_expect(str(group_state.get("typing_avatar", "")) == "S", "group indicator must identify Sandra with compact avatar")
	_expect(bool(group_state.get("typing_accent_visible", false)), "group indicator must expose author accent")
	_expect(not bool(group_state.get("typing_has_timestamp", true)), "group typing must have no timestamp")
	_expect(get_viewport().gui_get_focus_owner() != null, "group typing must not clear focus")
	var group_focus_before_replace = get_viewport().gui_get_focus_owner()
	if expected_reduced_motion:
		messages.start_typing(group_id, "marie")
		_expect(str(messages.describe_state().get("typing_text", "")) == "…", "reduced replacement must remain a static ellipsis")
	else:
		messages.start_typing(group_id, "sandra")
		_expect(str(messages.describe_state().get("typing_text", "")) == ".", "Sandra cycle must restart at one point")
		messages.conversation_screen.advance_typing_phase()
		messages.conversation_screen.advance_typing_phase()
		_expect(str(messages.describe_state().get("typing_text", "")) == "...", "Sandra cycle must reach three points")
		messages.start_typing(group_id, "marie")
		_expect(str(messages.describe_state().get("typing_text", "")) == ".", "Marie replacement must restart at one point")
		messages.conversation_screen.advance_typing_phase()
		_expect(str(messages.describe_state().get("typing_text", "")) == "..", "Marie cycle second phase must show two points")
		messages.conversation_screen.advance_typing_phase()
		_expect(str(messages.describe_state().get("typing_text", "")) == "...", "Marie cycle third phase must show three points")
	await get_tree().process_frame
	_expect(int(messages.describe_state().get("typing_instance_count", 0)) == 1, "author replacement must keep one indicator")
	_expect(str(messages.describe_state().get("typing_avatar", "")) == "M", "author replacement must update compact identity")
	_expect(get_viewport().gui_get_focus_owner() == group_focus_before_replace, "author replacement must preserve focus")
	messages.start_typing(group_id, "sandra")
	if not expected_reduced_motion:
		_expect(str(messages.describe_state().get("typing_text", "")) == ".", "restored Sandra cycle must restart at one point")
	await get_tree().process_frame
	_expect(int(messages.describe_state().get("typing_instance_count", 0)) == 1, "restoring author must not duplicate indicator")
	_expect(str(messages.describe_state().get("typing_avatar", "")) == "S", "restored author identity must be visible")

	messages.return_to_list()
	await get_tree().process_frame
	messages.open_thread(private_id)
	await get_tree().process_frame
	_expect(not bool(messages.describe_state().get("typing_visible", false)), "group typing must not appear in private thread")
	messages.return_to_list()
	await get_tree().process_frame
	messages.open_thread(group_id)
	await get_tree().process_frame
	_expect(int(messages.describe_state().get("typing_instance_count", 0)) == 1, "group typing must restore once")

	shell.gallery_button.emit_signal("pressed")
	await get_tree().create_timer(0.2).timeout
	_expect(messages.is_thread_typing(group_id), "typing state must survive Gallery")
	_expect(not messages.conversation_screen.typing_animation_running(), "hidden Messages must stop typing animation")
	shell.messages_button.emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(int(messages.describe_state().get("typing_instance_count", 0)) == 1, "return from Gallery must not duplicate indicator")
	if not expected_reduced_motion:
		_expect(messages.conversation_screen.typing_animation_running(), "visible Messages must resume one animation")

	var private_count_before: int = messages.thread_message_count(private_id)
	messages.simulate_incoming_message(private_id)
	await get_tree().process_frame
	_expect(messages.thread_message_count(private_id) == private_count_before + 1, "other thread must receive exactly one message")
	_expect(messages.is_thread_typing(group_id), "message in private thread must not stop group typing")
	_expect(int(messages.describe_state().get("typing_instance_count", 0)) == 1, "foreign message must preserve visible group indicator")

	var group_messages_before: int = messages.thread_message_count(group_id)
	var group_player_before: int = messages.thread_player_message_count(group_id)
	var group_choices_before: int = messages.thread_choice_count(group_id)
	var group_focus_before = get_viewport().gui_get_focus_owner()
	messages.simulate_incoming_message(group_id)
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(not messages.is_thread_typing(group_id), "incoming group message must stop its typing")
	_expect(int(messages.describe_state().get("typing_instance_count", -1)) == 0, "incoming message must remove indicator")
	_expect(messages.thread_message_count(group_id) == group_messages_before + 1, "incoming group message must add exactly one message")
	_expect(messages.thread_player_message_count(group_id) == group_player_before, "incoming group message must not add Player")
	_expect(messages.thread_choice_count(group_id) == group_choices_before, "incoming group message must not add choices")
	_expect(get_viewport().gui_get_focus_owner() == group_focus_before, "incoming message must preserve focus")
	_expect(not bool(messages.describe_state().get("has_horizontal_crop", true)), "Messages UI must not crop horizontally")

	var useful_bounds: Rect2i = shell.safe_area_container.get_visible_bounds()
	var timeline_rect: Rect2 = messages.conversation_screen.timeline.get_global_rect()
	var choice_rect: Rect2 = messages.conversation_screen.choice_bar.get_global_rect()
	_expect(timeline_rect.size.x > 0.0 and timeline_rect.size.y > 0.0, "timeline bounds must be positive")
	_expect(not timeline_rect.intersects(choice_rect), "timeline must not overlap fixed choices")
	_expect(timeline_rect.position.x >= useful_bounds.position.x and timeline_rect.end.x <= useful_bounds.end.x, "timeline must remain inside safe width")
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
		print("T-UI-02B2 typing indicator smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-02B2 typing indicator smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
