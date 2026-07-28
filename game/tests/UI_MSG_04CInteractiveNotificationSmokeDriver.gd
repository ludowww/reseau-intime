extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var requested_size := _parse_size(_arg("--runtime-size", "720x1280"))
	get_window().size = requested_size
	var main = MAIN_SCENE.instantiate()
	add_child(main)
	await _frames(6)
	var shell = main.shell
	shell.set_safe_area_preset(_arg("--safe-area", "none"))
	shell.set_reduced_motion_enabled(false)
	var messages = shell.messages_screen
	messages.runtime_delivery_time_scale = 0.01
	await _exercise_list_overlay(messages, shell)
	await _exercise_j01_header_and_auto_dismiss(messages, shell.runtime_provider)
	await _exercise_replacement_deferral_and_content_end(messages)
	_finish(requested_size)

func _exercise_list_overlay(messages, shell) -> void:
	var marie: Dictionary = messages._thread_for("thread_marie_private")
	_expect(not marie.is_empty(), "J01 Marie thread exists")
	var transcript_before: int = messages.total_presentation_count()
	var list_scroll_before: int = messages.conversation_list.get_reading_position() if messages.conversation_list.has_method("get_reading_position") else 0
	marie["unread_count"] = 1
	messages.conversation_list.update_thread_presentation(marie)
	messages.focus_first_conversation()
	await _frames(2)
	var focus_before = get_viewport().gui_get_focus_owner()
	messages._show_notification(marie, "Message de contrôle.", "18:12", "ui_msg_04c_list")
	await _frames(2)
	var state: Dictionary = messages.describe_state()
	var rect: Rect2 = state.get("list_notification_rect", Rect2())
	var surface: Rect2 = messages.get_global_rect()
	_expect(bool(state.get("list_notification_host_visible", false)), "list notification uses ListNotificationHost")
	_expect(bool(state.get("notification_visible", false)), "list notification is visible")
	_expect(int(state.get("visible_notification_count", 0)) == 1, "only one notification presenter is visible")
	_expect(not messages.conversation_screen.header_notification_visible(), "list notification does not mount in header")
	_expect(messages.notification_banner.compact_mode, "normal list path uses compact mode")
	_expect(messages.notification_banner.focus_mode == Control.FOCUS_ALL, "whole compact list banner is focusable")
	_expect(messages.notification_banner.mouse_filter == Control.MOUSE_FILTER_STOP, "list banner blocks click-through")
	_expect(messages.notification_banner.open_button == null and messages.notification_banner.close_button == null, "compact runtime banner has no separate actions")
	_expect(get_viewport().gui_get_focus_owner() == focus_before, "list banner does not steal focus")
	_expect(messages.notification_banner.auto_dismiss_timer != null, "list banner has auto-dismiss timer")
	_expect(is_equal_approx(messages.notification_banner.auto_dismiss_timer.wait_time, 3.5), "list auto-dismiss is 3.5 seconds")
	_expect(messages.notification_banner.auto_dismiss_timer.ignore_time_scale, "auto-dismiss ignores engine time scale")
	_expect(messages.notification_banner.tooltip_text == "Ouvrir la conversation avec Marie", "accessible list tooltip names target")
	_expect(rect.size.x > 0.0 and rect.size.y >= 48.0 and surface.encloses(rect), "list toast stays visible inside Messages surface")
	_expect(messages.conversation_list.offset_top == 0.0 and messages.conversation_screen.offset_top == 0.0, "list toast never changes content offsets")
	_expect(messages.total_presentation_count() == transcript_before, "notification does not alter transcript")
	if messages.conversation_list.has_method("get_reading_position"):
		_expect(messages.conversation_list.get_reading_position() == list_scroll_before, "list scroll is unchanged")
	messages.notification_banner.grab_focus()
	await _frames(1)
	var accept := InputEventAction.new()
	accept.action = "ui_accept"
	accept.pressed = true
	messages.notification_banner.emit_signal("gui_input", accept)
	await _frames(4)
	await _wait_delivery(messages)
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == "thread_marie_private", "ui_accept opens list notification target")
	_expect(messages.thread_unread_count("thread_marie_private") == 0, "notification click marks opened target read")
	_expect(not messages._notification_visible(), "opening target clears active notification")
	_expect(messages.total_presentation_count() >= transcript_before, "opening target preserves the authoritative transcript")
	messages._show_notification(marie, "Déjà ouvert.", "18:13", "ui_msg_04c_same_open")
	await _frames(2)
	_expect(not messages._notification_visible() and messages.thread_unread_count("thread_marie_private") == 0, "open thread receives no notification and stays read")

func _exercise_j01_header_and_auto_dismiss(messages, provider) -> void:
	var scroll_before: int = messages.conversation_screen.get_reading_position()
	var timeline_before: Rect2 = messages.conversation_screen.timeline.get_global_rect()
	var transcript_before: int = messages.total_presentation_count()
	provider.j01_provider.pending_transition = {"kind": "marie_shared_evening"}
	var result: Dictionary = provider.confirm_transition()
	messages._apply_time_passage_result(result, {})
	await _frames(20)
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == "thread_marie_private", "J01 resumes Marie")
	_expect(messages.conversation_screen.header_notification_visible(), "Sandra notification uses HeaderNotificationHost")
	_expect(not messages.list_notification_host.visible, "header notification leaves list host hidden")
	_expect(messages._visible_notification_count() == 1, "header has the sole visible banner")
	_expect(str(messages.active_notification.get("thread_id", "")) == "thread_sandra_private", "Sandra is the active target")
	_expect(str(messages.active_notification.get("preview", "")) == "J’ai retrouvé une photo.", "J01 Sandra text is unchanged")
	_expect(messages.conversation_screen.header_notification.tooltip_text == "Ouvrir la conversation avec Sandra", "header tooltip names Sandra")
	_expect(messages.conversation_screen.offset_top == 0.0 and messages.conversation_list.offset_top == 0.0, "header toast changes no offsets")
	_expect(messages.conversation_screen.timeline.get_global_rect().is_equal_approx(timeline_before), "header toast changes no timeline geometry")
	_expect(messages.conversation_screen.get_reading_position() == scroll_before, "header toast changes no scroll")
	_expect(messages.total_presentation_count() == transcript_before, "J01 notification replays no transcript")
	var unread_before: int = messages.thread_unread_count("thread_sandra_private")
	messages.reading_speed_multiplier = 8.0
	messages.update_active_typing_speed()
	var started_msec := Time.get_ticks_msec()
	while messages._notification_visible() and Time.get_ticks_msec() - started_msec < 5000:
		await get_tree().process_frame
	var elapsed := float(Time.get_ticks_msec() - started_msec) / 1000.0
	_expect(not messages._notification_visible(), "header notification auto-dismisses")
	_expect(elapsed >= 3.45 and elapsed <= 4.25, "auto-dismiss uses approximately 3.5 real seconds")
	_expect(messages.active_thread_id == "thread_marie_private", "auto-dismiss keeps Marie open")
	_expect(messages.thread_unread_count("thread_sandra_private") == unread_before and unread_before > 0, "auto-dismiss keeps Sandra unread")

func _exercise_replacement_deferral_and_content_end(messages) -> void:
	var sandra: Dictionary = messages._thread_for("thread_sandra_private")
	var marie: Dictionary = messages._thread_for("thread_marie_private")
	sandra["unread_count"] = maxi(1, int(sandra.get("unread_count", 0)))
	messages._show_notification(sandra, "Première version.", "22:57", "same-message")
	var same_id := str(messages.active_notification.get("notification_id", ""))
	var first_generation: int = messages.active_notification_generation
	messages._show_notification(sandra, "Version mise à jour.", "22:58", "same-message")
	await _frames(2)
	_expect(str(messages.active_notification.get("notification_id", "")) == same_id, "same-message replacement keeps deterministic id")
	_expect(str(messages.active_notification.get("preview", "")) == "Version mise à jour.", "same-thread replacement updates preview")
	_expect(messages.active_notification_generation > first_generation and messages._visible_notification_count() == 1, "same-thread replacement invalidates old generation")
	messages._on_notification_dismiss_requested(first_generation)
	_expect(str(messages.active_notification.get("preview", "")) == "Version mise à jour.", "stale dismiss cannot clear replacement")
	var deadline_before_transfer := int(messages.active_notification.get("_deadline_msec", 0))
	messages.return_to_list()
	await _frames(4)
	_expect(int(messages.active_notification.get("_deadline_msec", -1)) == deadline_before_transfer, "host transfer preserves remaining auto-dismiss time")
	_expect(messages.list_notification_host.visible and not messages.conversation_screen.header_notification_visible(), "conversation to list transfer keeps one presenter")
	marie["unread_count"] = 1
	messages._show_notification(marie, "Marie récente.", "22:59", "other-message")
	await _frames(2)
	_expect(str(messages.active_notification.get("thread_id", "")) == "thread_marie_private", "latest different thread wins visually")
	_expect(messages.thread_unread_count("thread_sandra_private") > 0, "replaced Sandra remains unread")
	messages.set_notification_photo_viewer_blocked(true)
	messages._show_notification(sandra, "Différée.", "23:00", "pending-sandra")
	await _frames(2)
	_expect(not messages._notification_visible() and messages.active_notification.is_empty(), "blocking surface hides active presenter")
	_expect(str(messages.pending_notification.get("thread_id", "")) == "thread_sandra_private", "latest blocked request is pending")
	messages.set_notification_photo_viewer_blocked(false)
	await _frames(3)
	_expect(str(messages.active_notification.get("thread_id", "")) == "thread_sandra_private" and messages.list_notification_host.visible, "stable list resumes pending notification")
	messages._defer_active_notification()
	messages._apply_time_passage_result({"accepted": false}, {})
	await _frames(2)
	_expect(str(messages.active_notification.get("thread_id", "")) == "thread_sandra_private", "rejected transition resumes pending notification on stable screen")
	messages.set_notification_photo_viewer_blocked(true)
	messages._show_notification(sandra, "Obsolète.", "23:01", "pending-obsolete")
	messages.open_thread("thread_sandra_private")
	await _frames(3)
	messages.set_notification_photo_viewer_blocked(false)
	await _frames(3)
	_expect(messages.active_thread_id == "thread_sandra_private" and not messages._notification_visible(), "opening pending target cancels deferred notification")
	_expect(messages.thread_unread_count("thread_sandra_private") == 0, "manual target opening marks only Sandra read")
	messages.return_to_list()
	await _frames(3)
	sandra["unread_count"] = 1
	messages._show_notification(sandra, "Fin.", "23:02", "content-end")
	messages._start_runtime_day_end({"transition_mode": "CONTENT_END", "title": "Fin du contenu disponible", "subtitle": "", "body": ""})
	await _frames(2)
	_expect(messages.active_notification.is_empty() and messages.pending_notification.is_empty(), "CONTENT_END clears active and pending notifications")
	_expect(not messages._notification_visible(), "CONTENT_END has no notification overlay")

func _wait_delivery(messages) -> void:
	for _index in range(800):
		if not messages.runtime_delivery_active:
			return
		await get_tree().process_frame
	_expect(false, "runtime delivery completes")

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

func _finish(size: Vector2i) -> void:
	if failures.is_empty():
		print("UI-MSG-04C interactive notification smoke %dx%d: OK" % [size.x, size.y])
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)
