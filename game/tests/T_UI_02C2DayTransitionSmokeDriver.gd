extends Node

const DEMO_SCENE := preload("res://scenes/portrait/PortraitShellDemo.tscn")
const NEXT_MESSAGE_ID := "demo_day3_marie_01"
const NEXT_DIVIDER_ID := "demo_day_private_03"

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
	var capture_after_path := _read_cmdline_value("--capture-after", "")
	var shell_state: Dictionary = demo.describe_state()
	_expect(Vector2i(demo.get_window().size) == expected_size, "window must match requested portrait size")
	_expect(str(shell_state.get("safe_area_preset", "")) == expected_safe_area, "safe area preset must match")
	_expect(bool(shell_state.get("reduced_motion_enabled", not expected_reduced_motion)) == expected_reduced_motion, "reduced motion override must match")

	var initial: Dictionary = messages.describe_state()
	var private_id := str(initial.get("private_thread_id", ""))
	_expect(private_id != "", "fixture must expose the private Marie thread")
	_expect(messages.current_demo_day() == 2, "local demo must begin on day 2")
	_expect(messages.presentation_count_by_id(NEXT_MESSAGE_ID) == 0, "next-day message must not exist initially")
	_expect(messages.presentation_count_by_id(NEXT_DIVIDER_ID) == 0, "next-day divider must not exist initially")

	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var before_focus = get_viewport().gui_get_focus_owner()
	var before_total: int = messages.total_presentation_count()
	var before_messages: int = messages.thread_message_count(private_id)
	var before_player: int = messages.thread_player_message_count(private_id)
	var before_unread: int = messages.thread_unread_count(private_id)
	var before_choices: int = messages.thread_choice_count(private_id)
	var before_dividers: int = messages.presentation_count_by_content_type(private_id, "SYSTEM_DAY_DIVIDER")
	var before_preview: String = messages.thread_preview(private_id)

	messages.start_typing(private_id, "marie")
	await get_tree().process_frame
	_expect(messages.is_thread_typing(private_id), "typing must be locally active before transition")
	_expect(bool(messages.describe_state().get("typing_visible", false)), "typing must be visible before transition")

	messages.start_day_transition(0, 3)
	messages.start_day_transition(2, 2)
	messages.start_day_transition(3, 2)
	_expect(not messages.is_day_transition_active(), "invalid day ranges must be ignored")
	messages.start_day_transition(2, 3)
	await get_tree().process_frame
	var active: Dictionary = messages.describe_state()
	_expect(messages.is_day_transition_active(), "day transition must activate")
	_expect(int(active.get("day_transition_surface_count", 0)) == 1, "one day transition surface must exist")
	_expect(int(active.get("day_transition_action_count", 0)) == 1, "surface must expose one action")
	_expect(str(active.get("day_transition_title", "")) == "La journée se termine", "title must be player-facing")
	_expect(str(active.get("day_transition_subtitle", "")) == "Mercredi", "next day must be player-facing")
	_expect(bool(active.get("day_transition_visible", false)), "day transition must be visible")
	_expect(not bool(active.get("list_visible", true)) and not bool(active.get("conversation_visible", true)), "list and conversation must be hidden")
	_expect(not bool(active.get("off_phone_visible", true)), "off-phone surface must remain hidden")
	_expect(not bool(active.get("notification_visible", true)), "notification must be hidden")
	_expect(int(active.get("typing_instance_count", -1)) == 0, "typing visual must be removed")
	_expect(messages.is_thread_typing(private_id), "typing snapshot must remain local until validation")
	_expect(bool(active.get("day_transition_action_focus", false)), "Continue must receive focus")
	_expect(float(active.get("day_transition_action_height", 0.0)) >= 48.0, "Continue touch target must be at least 48")
	_expect(shell.gallery_button.disabled, "Gallery must be disabled")
	_expect(messages.current_demo_day() == 2, "day must not change before validation")
	_expect(messages.total_presentation_count() == before_total, "no presentation may change before validation")
	_expect(messages.thread_unread_count(private_id) == before_unread, "unread must not change before validation")
	_expect(messages.thread_preview(private_id) == before_preview, "preview must not change before validation")
	_expect(messages.presentation_count_by_id(NEXT_MESSAGE_ID) == 0, "next message must wait for validation")
	_expect(messages.presentation_count_by_id(NEXT_DIVIDER_ID) == 0, "next divider must wait for validation")
	if expected_reduced_motion:
		_expect(not bool(active.get("day_transition_animation_running", true)), "reduced motion must be instant")
	else:
		_expect(bool(active.get("day_transition_animation_running", false)), "standard motion must begin a short fade")

	# All Messages mutations and navigation remain deterministic no-ops.
	var choice: Dictionary = messages.available_choices.get(private_id, [])[0]
	messages.open_thread(private_id)
	messages.return_to_list()
	messages.activate_first_choice()
	messages.start_typing(private_id, "marie")
	messages.stop_typing(private_id)
	messages.simulate_incoming_message(private_id)
	messages.start_off_phone_transition(private_id)
	messages.finish_off_phone_transition()
	messages.start_day_transition(2, 3)
	messages._on_choice_selected(choice)
	await get_tree().process_frame
	_expect(messages.total_presentation_count() == before_total, "blocked calls must add no presentation")
	_expect(messages.thread_player_message_count(private_id) == before_player, "blocked calls must add no Player message")
	_expect(messages.thread_unread_count(private_id) == before_unread, "blocked calls must add no unread")
	_expect(messages.thread_choice_count(private_id) == before_choices, "blocked calls must consume no choice")
	_expect(not messages.is_off_phone_transition_active(), "co-presence must not begin during day transition")
	_expect(messages.day_transition_surface_count() == 1 and messages.day_transition_action_count() == 1, "duplicate start must keep one surface and one action")

	shell.activate_gallery(false)
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(str(shell.describe_layout().get("active_tab", "")) == "messages", "direct Gallery navigation must be neutralized")
	_expect(messages.is_day_transition_active(), "neutralized Gallery must preserve transition")
	_expect(messages.day_transition.action_has_focus(), "neutralized Gallery must restore focus to Continue")

	var useful_bounds: Rect2i = shell.safe_area_container.get_visible_bounds()
	var surface_rect: Rect2 = messages.day_transition.get_global_rect()
	var nav_rect: Rect2 = shell.gallery_button.get_global_rect()
	_expect(surface_rect.size.x > 0.0 and surface_rect.size.y > 0.0, "surface bounds must be positive")
	_expect(surface_rect.position.x >= useful_bounds.position.x and surface_rect.end.x <= useful_bounds.end.x, "surface must remain inside safe width")
	_expect(not surface_rect.intersects(nav_rect), "surface must not overlap bottom navigation")
	_expect(not bool(active.get("has_horizontal_crop", true)), "transition must not crop horizontally")
	if capture_path != "":
		await _save_capture(capture_path)

	messages.day_transition.continue_button.emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame
	var after: Dictionary = messages.describe_state()
	_expect(not messages.is_day_transition_active(), "Continue must finish transition")
	_expect(messages.current_demo_day() == 3, "local day must become 3")
	_expect(str(after.get("screen", "")) == "list", "transition must return to list")
	_expect(bool(after.get("list_visible", false)) and not bool(after.get("conversation_visible", true)), "only list must return")
	_expect(not shell.gallery_button.disabled, "Gallery must be re-enabled")
	_expect(str(messages.conversation_list.focused_thread_id()) == private_id, "updated Marie card must receive focus")
	_expect(messages.total_presentation_count() == before_total + 2, "one divider and one message must be added")
	_expect(messages.thread_message_count(private_id) == before_messages + 2, "private transcript must gain exactly two presentations")
	_expect(messages.thread_player_message_count(private_id) == before_player, "no Player message may be added")
	_expect(messages.thread_choice_count(private_id) == before_choices, "choices must remain unchanged")
	_expect(messages.presentation_count_by_content_type(private_id, "SYSTEM_DAY_DIVIDER") == before_dividers + 1, "one day divider must be added")
	_expect(messages.presentation_count_by_id(NEXT_DIVIDER_ID) == 1, "new day divider must be unique")
	_expect(messages.presentation_count_by_id(NEXT_MESSAGE_ID) == 1, "new Marie message must be unique")
	_expect(messages.thread_unread_count(private_id) == before_unread + 1, "unread must increase exactly once")
	_expect(messages.day_transition_applied_count(3) == 1, "day delta must be applied once")
	_expect(not bool(after.get("notification_visible", true)), "no notification banner may appear automatically")
	_expect(not messages.is_thread_typing(private_id), "old active-thread typing state must be cleaned")
	_expect(int(after.get("typing_instance_count", 0)) == 0, "typing visual must not restart")
	if capture_after_path != "":
		await _save_capture(capture_after_path)

	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	var opened: Dictionary = messages.describe_state()
	_expect(int(opened.get("day_divider_count", 0)) == before_dividers + 1, "new divider must render")
	_expect(int(opened.get("unread_divider_count", 0)) == 1, "first open must render one unread divider")
	_expect(bool(opened.get("day_divider_precedes_unread", false)), "order must be DayDivider then UnreadDivider then new message")
	_expect(messages.thread_unread_count(private_id) == 0, "opening must mark new message read")
	messages.return_to_list()
	await get_tree().process_frame

	# A second local cycle may display, but must never duplicate its delta.
	var once_total: int = messages.total_presentation_count()
	messages.start_day_transition(2, 3)
	await get_tree().process_frame
	_expect(messages.is_day_transition_active(), "same target may display again for idempotence smoke")
	_expect(messages.day_transition_action_count() == 1, "second cycle must still expose one action")
	messages.finish_day_transition()
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(messages.total_presentation_count() == once_total, "second finish must not duplicate presentations")
	_expect(messages.presentation_count_by_id(NEXT_DIVIDER_ID) == 1, "divider must remain unique")
	_expect(messages.presentation_count_by_id(NEXT_MESSAGE_ID) == 1, "message must remain unique")
	_expect(messages.thread_unread_count(private_id) == 0, "second finish must not increase unread")
	_expect(messages.day_transition_applied_count(3) == 1, "applied proof must remain one")
	messages.finish_day_transition()
	_expect(not messages.is_day_transition_active(), "finish without active transition must be a no-op")

	# Mutual exclusion is also proven from an active co-presence surface.
	messages.open_thread(private_id)
	await get_tree().process_frame
	await get_tree().process_frame
	messages.start_off_phone_transition(private_id)
	await get_tree().process_frame
	_expect(messages.is_off_phone_transition_active(), "co-presence fixture must activate")
	messages.start_day_transition(3, 4)
	_expect(not messages.is_day_transition_active(), "day transition must be refused during co-presence")
	messages.finish_off_phone_transition()
	await get_tree().process_frame
	await get_tree().process_frame

	shell.activate_gallery(false)
	await get_tree().process_frame
	_expect(str(shell.describe_layout().get("active_tab", "")) == "gallery", "Gallery must work after transition")
	shell.activate_messages(false)
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(messages.current_demo_day() == 3, "Gallery round trip must preserve local day")
	_expect(messages.presentation_count_by_id(NEXT_MESSAGE_ID) == 1, "Gallery round trip must preserve unique delta")

	print("T-UI-02C2 state: day=2->%d messages=%d->%d unread=%d->%d applied=%d" % [messages.current_demo_day(), before_messages, messages.thread_message_count(private_id), before_unread, messages.thread_unread_count(private_id), messages.day_transition_applied_count(3)])
	_finish()

func _save_capture(path: String) -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	var save_error := image.save_png(path)
	_expect(save_error == OK, "visual capture must save successfully")
	print("T-UI-02C2 capture: %s" % path)

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
		print("T-UI-02C2 day transition smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-02C2 day transition smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
