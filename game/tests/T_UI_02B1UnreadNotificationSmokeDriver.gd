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
	_expect(actual_window == expected_size, "window must match requested portrait size")
	_expect(str(shell_state.get("safe_area_preset", "")) == expected_safe_area, "safe area preset must match")
	_expect(bool(shell_state.get("reduced_motion_enabled", not expected_reduced_motion)) == expected_reduced_motion, "reduced motion override must match")

	messages.focus_first_conversation()
	await get_tree().process_frame
	var initial: Dictionary = messages.describe_state()
	var unread_id := str(initial.get("unread_thread_id", ""))
	var other_id := str(initial.get("read_thread_id", ""))
	_expect(str(initial.get("screen", "")) == "list", "launch must show list")
	_expect(unread_id != "" and other_id != "", "fixtures must expose unread and read threads")
	_expect(messages.thread_unread_count(unread_id) >= 2, "initial unread badge must show exact positive count")
	_expect(messages.thread_unread_count(other_id) == 0, "second fixture thread must start read")
	var initial_focus: String = str(messages.conversation_list.focused_thread_id())
	_expect(initial_focus == unread_id, "unread fixture card must initially own focus")

	messages.open_thread(unread_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var opened: Dictionary = messages.describe_state()
	_expect(int(opened.get("unread_divider_count", 0)) == 1, "divider must appear exactly once before first unread")
	_expect(messages.thread_unread_count(unread_id) == 0, "opening must clear selected thread unread count")
	_expect(messages.all_messages_read(unread_id), "opening must mark selected thread messages read")
	_expect(messages.thread_unread_count(other_id) == 0, "other thread must remain unchanged")

	messages.return_to_list()
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(messages.conversation_list.focused_thread_id() == unread_id, "return must restore the same card focus")
	messages.open_thread(unread_id)
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(int(messages.describe_state().get("unread_divider_count", -1)) == 0, "divider must not reappear after thread is read")
	messages.return_to_list()
	await get_tree().process_frame
	await get_tree().process_frame

	messages.conversation_list.focus_thread(unread_id)
	await get_tree().process_frame
	var focus_before_banner := get_viewport().gui_get_focus_owner()
	var other_messages_before: int = int(messages.thread_message_count(other_id))
	var other_unread_before: int = int(messages.thread_unread_count(other_id))
	var other_player_before: int = int(messages.thread_player_message_count(other_id))
	var other_choices_before: int = int(messages.thread_choice_count(other_id))
	var old_preview: String = str(messages.thread_preview(other_id))
	var old_timestamp: String = str(messages.thread_timestamp(other_id))
	messages.simulate_incoming_message("missing_demo_thread")
	_expect(messages.thread_message_count(other_id) == other_messages_before, "invalid thread id must be ignored")
	messages.simulate_incoming_message(other_id)
	var transition_started: bool = bool(messages.notification_banner.is_transition_running())
	await get_tree().process_frame
	await get_tree().process_frame
	var notified: Dictionary = messages.describe_state()
	_expect(messages.thread_message_count(other_id) == other_messages_before + 1, "simulation must add exactly one incoming message")
	_expect(messages.thread_unread_count(other_id) == other_unread_before + 1, "simulation must increment unread by exactly one")
	_expect(messages.thread_player_message_count(other_id) == other_player_before, "simulation must not add Player messages")
	_expect(messages.thread_choice_count(other_id) == other_choices_before, "simulation must not generate choices")
	_expect(messages.thread_preview(other_id) != old_preview, "simulation must update preview")
	_expect(messages.thread_timestamp(other_id) != old_timestamp, "simulation must update timestamp")
	_expect(bool(notified.get("notification_visible", false)), "notification banner must be visible")
	_expect(str(notified.get("notification_thread_id", "")) == other_id, "notification must target updated thread")
	_expect(get_viewport().gui_get_focus_owner() == focus_before_banner, "banner must not steal focus")
	_expect(messages.notification_banner_count() == 1, "only one banner instance may exist")
	_expect(messages.notification_banner.focus_mode == Control.FOCUS_NONE, "banner container must remain outside keyboard focus")
	_expect(messages.notification_banner.open_button.focus_mode == Control.FOCUS_ALL, "OpenNotification must accept keyboard focus")
	_expect(messages.notification_banner.close_button.focus_mode == Control.FOCUS_ALL, "CloseNotification must accept keyboard focus")
	_expect(messages.notification_banner.open_button.custom_minimum_size.y >= 48.0, "OpenNotification touch target must be at least 48 high")
	_expect(messages.notification_banner.close_button.custom_minimum_size.x >= 48.0 and messages.notification_banner.close_button.custom_minimum_size.y >= 48.0, "CloseNotification touch target must be at least 48 by 48")
	_expect(messages.notification_banner.open_button.has_theme_stylebox_override("focus"), "OpenNotification must expose a visible focus style")
	_expect(messages.notification_banner.close_button.has_theme_stylebox_override("focus"), "CloseNotification must expose a visible focus style")
	_expect(messages.conversation_list.offset_top > 0.0 and messages.conversation_screen.offset_top > 0.0, "visible banner must reserve content space")
	var banner_rect: Rect2 = messages.notification_banner.get_global_rect()
	var list_rect: Rect2 = messages.conversation_list.get_global_rect()
	var messages_surface: Rect2 = messages.get_global_rect()
	var useful_bounds_for_banner: Rect2i = shell.safe_area_container.get_visible_bounds()
	_expect(banner_rect.size.x > 0.0 and banner_rect.size.y > 0.0, "banner bounds must be positive")
	_expect(banner_rect.position.x >= messages_surface.position.x and banner_rect.position.y >= messages_surface.position.y, "banner must start inside Messages surface")
	_expect(banner_rect.end.x <= messages_surface.end.x and banner_rect.end.y <= messages_surface.end.y, "banner must end inside Messages surface")
	_expect(banner_rect.position.x >= float(useful_bounds_for_banner.position.x) and banner_rect.position.y >= float(useful_bounds_for_banner.position.y), "banner must start inside useful safe bounds")
	_expect(banner_rect.end.x <= float(useful_bounds_for_banner.end.x) and banner_rect.end.y <= float(useful_bounds_for_banner.end.y), "banner must end inside useful safe bounds")
	_expect(list_rect.position.y >= banner_rect.end.y and not banner_rect.intersects(list_rect), "list content must begin below the banner without overlap")
	if expected_reduced_motion:
		_expect(not transition_started, "reduced motion must disable banner animation")
	else:
		_expect(transition_started, "standard motion must start a short banner transition")
		await get_tree().create_timer(0.25).timeout
		_expect(not messages.notification_banner.is_transition_running(), "banner transition must terminate quickly")

	messages.notification_banner.close_button.grab_focus()
	await get_tree().process_frame
	_expect(messages.notification_banner.close_button.has_focus(), "CloseNotification must receive intentional focus")
	messages.notification_banner.close_button.emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(not messages.notification_banner.visible, "CloseNotification activation must hide the banner")
	_expect(get_viewport().gui_get_focus_owner() == focus_before_banner, "dismiss must restore the useful previous focus")
	_expect(messages.conversation_list.offset_top == 0.0, "list offset must reset after dismiss")
	_expect(messages.conversation_screen.offset_top == 0.0, "conversation offset must reset after dismiss")

	# A foreign banner must survive a direct open and an incoming message in thread B.
	messages.simulate_incoming_message(other_id)
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(str(messages.describe_state().get("notification_thread_id", "")) == other_id, "foreign scenario must start with banner A")
	messages.open_thread(unread_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var open_foreign_messages_before: int = int(messages.thread_message_count(unread_id))
	messages.simulate_incoming_message(unread_id)
	await get_tree().process_frame
	_expect(messages.thread_message_count(unread_id) == open_foreign_messages_before + 1, "open thread B must receive exactly one message")
	_expect(messages.thread_unread_count(unread_id) == 0, "open thread B incoming message must remain read")
	_expect(bool(messages.describe_state().get("notification_visible", false)), "banner A must remain visible while B is open")
	_expect(str(messages.describe_state().get("notification_thread_id", "")) == other_id, "foreign banner target A must remain unchanged")
	_expect(messages.notification_banner_count() == 1, "foreign scenario must keep a single banner instance")
	messages.return_to_list()
	await get_tree().process_frame
	await get_tree().process_frame

	messages.simulate_incoming_message(unread_id)
	await get_tree().process_frame
	_expect(str(messages.describe_state().get("notification_thread_id", "")) == unread_id, "a newer notification must replace the previous target")
	_expect(messages.notification_banner_count() == 1, "replacement must keep exactly one banner")
	messages.simulate_incoming_message(other_id)
	await get_tree().process_frame
	_expect(str(messages.describe_state().get("notification_thread_id", "")) == other_id, "latest notification must become the banner target")
	_expect(messages.notification_banner_count() == 1, "latest replacement must not duplicate the banner")
	_expect(get_viewport().gui_get_focus_owner() == focus_before_banner, "notification replacement must preserve focus")

	messages.notification_banner.activate_open_action()
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(str(messages.describe_state().get("active_thread_id", "")) == other_id, "banner action must open the correct thread")
	_expect(messages.thread_unread_count(other_id) == 0, "banner-opened thread must be marked read")
	_expect(messages.conversation_list.offset_top == 0.0, "list offset must reset after banner open")
	_expect(messages.conversation_screen.offset_top == 0.0, "conversation offset must reset after banner open")
	var open_messages_before: int = int(messages.thread_message_count(other_id))
	var open_player_before: int = int(messages.thread_player_message_count(other_id))
	var open_dividers_before := int(messages.describe_state().get("unread_divider_count", -1))
	messages.simulate_incoming_message(other_id)
	await get_tree().process_frame
	_expect(messages.thread_message_count(other_id) == open_messages_before + 1, "open thread simulation must append one incoming message")
	_expect(messages.thread_player_message_count(other_id) == open_player_before, "open thread simulation must not append Player")
	_expect(messages.thread_unread_count(other_id) == 0, "open thread simulation must remain read")
	_expect(int(messages.describe_state().get("unread_divider_count", -1)) == open_dividers_before, "open thread simulation must not add unread divider")
	_expect(not bool(messages.describe_state().get("notification_visible", true)), "open thread simulation must not show banner")
	_expect(not bool(messages.describe_state().get("has_horizontal_crop", true)), "messages UI must not crop horizontally")

	var preserved_count: int = int(messages.thread_message_count(other_id))
	shell.gallery_button.emit_signal("pressed")
	await get_tree().process_frame
	_expect(shell.gallery_panel.visible, "Galerie must remain reachable")
	shell.messages_button.emit_signal("pressed")
	await get_tree().process_frame
	_expect(shell.messages_panel.visible, "Messages must remain reachable")
	_expect(messages.thread_message_count(other_id) == preserved_count, "local unread state must survive tab navigation")
	_expect(str(messages.describe_state().get("active_thread_id", "")) == other_id, "active thread must survive tab navigation")

	var useful_bounds: Rect2i = shell.safe_area_container.get_visible_bounds()
	var messages_rect: Rect2 = shell.messages_panel.get_global_rect()
	_expect(messages_rect.position.x >= float(useful_bounds.position.x) and messages_rect.position.y >= float(useful_bounds.position.y), "Messages must stay inside safe bounds")
	_expect(messages_rect.end.x <= float(useful_bounds.end.x) and messages_rect.end.y <= float(useful_bounds.end.y), "Messages must not crop beyond safe bounds")
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
		print("T-UI-02B1 unread notification smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-02B1 unread notification smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
