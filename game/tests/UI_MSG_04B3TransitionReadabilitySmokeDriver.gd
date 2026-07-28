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
	_expect(shell.runtime_provider.current_narrative_day_short() == "Mar.", "J01 provider exposes Mar.")
	_expect(str(DataLoader.load_json("res://data/runtime/season_1/j02_runtime_map.json").get("narrative_day_short", "")) == "Mer.", "J02 runtime exposes Mer.")
	_expect(str(DataLoader.load_json("res://data/runtime/season_1/j03_runtime_map.json").get("narrative_day_short", "")) == "Jeu.", "J03 runtime exposes Jeu.")
	var overlay = messages.time_passage_overlay
	await _exercise_overlay(overlay)
	await _exercise_resume_and_header_notification(messages, shell.runtime_provider)
	_finish(requested_size)

func _exercise_overlay(overlay) -> void:
	overlay.set_process(false)
	overlay.set_reduced_motion(false)
	var clock := [{
		"phase": "CLOCK", "from_minutes": 1092, "to_minutes": 1098,
		"from_time": "18:12", "to_time": "18:18", "duration_seconds": 4.0,
		"eyebrow": "MERCREDI — FIN DE JOURNÉE", "title": "Carte interdite", "body": "Corps interdit",
	}]
	_expect(overlay.play_flow(clock, 401), "CLOCK starts")
	_expect(overlay.dimmer.color.a >= 0.95, "CLOCK is opaque")
	_expect(overlay.clock_label.visible, "CLOCK hour is visible")
	_expect(not overlay.eyebrow_label.visible and not overlay.title_label.visible and not overlay.body_label.visible, "CLOCK hides map card copy")
	_expect(overlay.eyebrow_label.text == "" and overlay.title_label.text == "" and overlay.body_label.text == "", "CLOCK ignores FIN DE JOURNEE copy")
	overlay._process(0.50)
	_expect(overlay.active and overlay.clock_label.text != "18:18", "CLOCK remains active after 0.5 real seconds")
	overlay._process(3.50)
	_expect(not overlay.active and overlay.clock_label.text == "18:18", "CLOCK completes after 4 real seconds")
	overlay.dismiss()

	var night := [{"phase": "NIGHT", "duration_seconds": 2.6}]
	_expect(overlay.play_flow(night, 402), "NIGHT starts")
	_expect(is_equal_approx(overlay.dimmer.color.a, 1.0), "NIGHT is opaque")
	overlay._process(0.80)
	var first_y: float = overlay.sleep_z.position.y
	overlay._process(0.80)
	_expect(overlay.sleep_z.position.y <= first_y, "sleep movement is monotone upward")
	_expect(overlay.active, "NIGHT at x8 still uses real time")
	overlay._process(0.90)
	_expect(overlay.active, "NIGHT remains active before 2.6 real seconds")
	overlay._process(0.11)
	_expect(not overlay.active, "NIGHT completes after 2.6 real seconds")
	overlay.dismiss()

	overlay.set_reduced_motion(true)
	_expect(overlay.play_flow(night, 403), "reduced NIGHT starts")
	_expect(not overlay.sleep_z.visible and not overlay.sleep_zz.visible and overlay.sleep_zzz.visible, "reduced motion shows static Zzz only")
	var reduced_y: float = overlay.sleep_zzz.position.y
	overlay._process(0.10)
	_expect(is_equal_approx(overlay.sleep_zzz.position.y, reduced_y), "reduced Zzz does not translate")
	overlay.dismiss()

	overlay.set_reduced_motion(false)
	_expect(overlay.play_flow([{"phase": "OFF_PHONE", "text": "Texte hors téléphone lisible.", "duration_seconds": 3.0}], 404), "OFF_PHONE starts")
	_expect(overlay.dimmer.color.a >= 0.95 and overlay.body_label.visible, "OFF_PHONE is opaque and readable")
	overlay.dismiss()

func _exercise_resume_and_header_notification(messages, provider) -> void:
	_press_thread_card(messages, "thread_marie_private")
	await _frames(3)
	await _wait_delivery(messages)
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == "thread_marie_private", "Marie conversation is active")
	_expect(messages.conversation_screen.narrative_time_label.text.begins_with("Mar. · "), "J01 header shows Mar. and narrative time")
	var scroll_before: int = messages.conversation_screen.get_reading_position()
	var timeline_rect_before: Rect2 = messages.conversation_screen.timeline.get_global_rect()
	var conversation_offset_before: float = messages.conversation_screen.offset_top
	var transcript_before: int = messages.total_presentation_count()
	provider.j01_provider.pending_transition = {"kind": "marie_shared_evening"}
	var result: Dictionary = provider.confirm_transition()
	_expect(str(result.get("resume_destination", "")) == "conversation", "resume destination is authoritative")
	_expect(str(result.get("resume_thread_id", "")) == "thread_marie_private", "resume thread is Marie")
	_expect(str(result.get("unlocked_thread_id", "")) == "thread_sandra_private", "Sandra unlock is explicit")
	messages._apply_time_passage_result(result, {})
	await _frames(20)
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == "thread_marie_private", "Marie conversation resumes without list")
	_expect(messages.conversation_list.visible == false, "Messages list stays absent")
	_expect(messages.conversation_screen.get_reading_position() == scroll_before, "Marie scroll is preserved")
	_expect(messages.total_presentation_count() == transcript_before, "Marie transcript is not replayed")
	_expect(not messages.notification_banner.visible, "global notification is absent")
	_expect(messages.conversation_screen.header_notification_visible(), "Sandra notification is hosted in header")
	_expect(is_equal_approx(messages.conversation_screen.offset_top, conversation_offset_before), "conversation offset is unchanged")
	_expect(messages.conversation_screen.timeline.get_global_rect().is_equal_approx(timeline_rect_before), "timeline geometry is unchanged")
	var state: Dictionary = messages.conversation_screen.describe_state()
	var notification_rect: Rect2 = state.get("header_notification_rect", Rect2())
	var header_rect: Rect2 = state.get("conversation_header_rect", Rect2())
	_expect(notification_rect.size.x > 0.0 and header_rect.encloses(notification_rect), "header notification remains inside conversation header")
	_expect(str(messages.conversation_screen.header_notification.notification.get("preview", "")) == "J’ai retrouvé une photo.", "Sandra preview is exact")
	_expect(messages.conversation_screen.header_notification.auto_dismiss_timer != null, "real-time auto-dismiss timer exists")
	_expect(is_equal_approx(messages.conversation_screen.header_notification.auto_dismiss_timer.wait_time, 3.5), "auto-dismiss is 3.5 seconds")
	messages.reading_speed_multiplier = 8.0
	messages.update_active_typing_speed()
	var thread_before_dismiss: String = messages.active_thread_id
	messages.conversation_screen.header_notification._on_auto_dismiss_timeout()
	await get_tree().create_timer(0.20, true, false, true).timeout
	await _frames(2)
	_expect(not messages.conversation_screen.header_notification_visible(), "auto-dismiss hides notification")
	_expect(messages.active_thread_id == thread_before_dismiss, "auto-dismiss does not change thread")

	var sandra_thread: Dictionary = messages._thread_for("thread_sandra_private")
	messages._show_notification(sandra_thread, "J’ai retrouvé une photo.", provider.current_narrative_time_text())
	await _frames(2)
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	messages.conversation_screen.header_notification.emit_signal("gui_input", click)
	await _frames(4)
	_expect(messages.active_thread_id == "thread_sandra_private" and messages.screen_mode == "conversation", "full banner click opens Sandra")
	_expect(not messages.conversation_screen.header_notification_visible(), "click dismisses header notification")

func _press_thread_card(messages, thread_id: String) -> void:
	for index in range(messages.conversation_list.threads.size()):
		if str(messages.conversation_list.threads[index].get("thread_id", "")) == thread_id:
			messages.conversation_list.cards[index].emit_signal("pressed")
			return
	_expect(false, "requested thread is available")

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
		print("UI-MSG-04B3 transition readability smoke %dx%d: OK" % [size.x, size.y])
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)
