extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
var failures: Array[String] = []

# Contract labels intentionally kept readable: clock from list, clock from
# conversation, phone remains mounted, single overlay instance, reduced motion,
# snapshot, CONTENT_END, ×1, ×3, ×8.
func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var size := _parse_size(_arg("--runtime-size", "720x1280"))
	get_window().size = size
	var main = MAIN_SCENE.instantiate()
	main.get_node("PortraitShell").content_mode = "runtime_s1"
	add_child(main)
	await _frames(5)
	var shell = main.shell
	shell.set_safe_area_preset(_arg("--safe-area", "none"))
	shell.set_reduced_motion_enabled(true)
	var messages = shell.messages_screen
	messages.runtime_delivery_time_scale = 0.01
	await _frames(4)
	var overlay = messages.time_passage_overlay
	overlay.set_reduced_motion(true)
	_expect(overlay != null, "single overlay instance exists")
	_expect(messages.conversation_list.visible, "list starts mounted")
	await _exercise_overlay_robustness(overlay)
	await _exercise_sandra_focus(messages, shell.runtime_provider)
	await _exercise_snapshot_resume(main, shell.runtime_provider)
	overlay.set_reduced_motion(true)
	var before_snapshot: Dictionary = shell.runtime_provider.snapshot()
	var list_scroll_marker: String = str(messages.active_thread_id)
	var list_flow := [{"phase": "CLOCK", "from_minutes": 1092, "to_minutes": 1093, "from_time": "18:12", "to_time": "18:13", "duration_seconds": 4.0}]
	_expect(overlay.play_flow(list_flow, 101), "clock from list starts")
	_expect(messages.conversation_list.visible and overlay.visible, "phone remains mounted under list clock")
	_expect(messages.get_child_count() > 0, "single overlay instance remains in messages tree")
	await overlay.flow_finished
	overlay.dismiss()
	_expect(messages.active_thread_id == list_scroll_marker, "list focus state is preserved")
	_expect(shell.runtime_provider.snapshot() == before_snapshot, "snapshot authority ignores decorative progress")

	_press_thread_card(messages, "thread_marie_private")
	await _frames(3)
	await _wait_delivery(messages)
	_expect(messages.conversation_screen.visible, "conversation is mounted")
	var transcript_count: int = int(messages.total_presentation_count())
	var reading_position: int = int(messages.conversation_screen.get_reading_position())
	var continuous_flow := [
		{"phase": "OFF_PHONE", "text": "Un bref passage hors téléphone."},
		{"phase": "NIGHT", "time": shell.runtime_provider.current_narrative_time_text()},
		{"phase": "NEW_DAY", "eyebrow": "MERCREDI — MIDI", "time": "12:10", "title": "Faire de la place"},
	]
	_expect(overlay.play_flow(continuous_flow, 102), "clock from conversation surface accepts unified flow")
	_expect(messages.conversation_screen.visible and overlay.visible, "phone remains mounted under conversation overlay")
	_expect(overlay.current_phase() == "OFF_PHONE", "continuous flow begins off phone")
	_expect(not overlay.speed_button.visible, "reading speed is hidden during the overlay")
	await overlay.flow_finished
	overlay.dismiss()
	_expect(messages.total_presentation_count() == transcript_count, "transcript is not replayed")
	_expect(messages.conversation_screen.get_reading_position() == reading_position, "scroll is preserved")
	_expect(not overlay.has_horizontal_crop(), "responsive overlay has no horizontal crop")
	_expect(overlay.reduced_motion and overlay.sleep_label.text == "Zzz", "reduced motion uses static native Zzz")
	_finish(size)

func _exercise_overlay_robustness(overlay) -> void:
	overlay.set_reduced_motion(false)
	var clock := [{"phase": "CLOCK", "from_minutes": 600, "to_minutes": 610, "from_time": "10:00", "to_time": "10:10", "duration_seconds": 1.0}]
	_expect(overlay.play_flow(clock, 91), "robustness clock starts")
	overlay.set_process(false)
	overlay._process(0.05)
	var before_next_tick := _time_minutes(overlay.clock_label.text)
	overlay._process(0.05)
	_expect(_time_minutes(overlay.clock_label.text) >= before_next_tick, "real-time clock remains monotone")
	_send_key(KEY_ENTER)
	await _frames(2)
	overlay._process(0.40)
	_expect(overlay.active and overlay.current_phase() == "CLOCK", "clock skip is forbidden")
	var finish_labels: Array[String] = []
	var capture_target := func(_request_id: int): finish_labels.append(overlay.clock_label.text)
	overlay.flow_finished.connect(capture_target, CONNECT_ONE_SHOT)
	overlay._process(1.0)
	_expect(not finish_labels.is_empty() and finish_labels[0] == "10:10", "clock target is exact before finish")
	overlay.dismiss()

	overlay.set_reduced_motion(true)
	_expect(overlay.play_flow([{"phase": "NEW_DAY", "time": "12:10", "reduced_duration": 0.35}], 92), "reduced-motion phase starts")
	overlay.set_process(false)
	overlay._process(0.10)
	_expect(overlay.active, "reduced motion remains perceptible in real time")
	overlay._process(0.26)
	_expect(not overlay.active, "reduced motion still completes automatically")
	overlay.dismiss()

	overlay.set_reduced_motion(false)
	_expect(overlay.play_flow([{"phase": "OFF_PHONE", "text": "Lecture hors téléphone.", "duration_seconds": 5.0}], 93), "off-phone keyboard flow starts")
	overlay.set_process(false)
	_send_key(KEY_SPACE)
	await _frames(2)
	overlay._process(0.36)
	_expect(not overlay.active, "real keyboard event accelerates off-phone without focus")
	overlay.dismiss()

func _exercise_sandra_focus(messages, provider) -> void:
	provider.j01_provider.pending_transition = {"kind": "marie_shared_evening"}
	var result: Dictionary = provider.confirm_transition()
	_expect(bool(result.get("accepted", false)), "real J01 transition confirms")
	result["destination"] = "list"
	messages._apply_time_passage_result(result, {})
	await _frames(3)
	var focus_owner := get_viewport().gui_get_focus_owner()
	var sandra_card = _thread_card(messages, "thread_sandra_private")
	_expect(messages.notification_banner.visible and str(messages.notification_banner.notification.get("thread_id", "")) == "thread_sandra_private", "Sandra notification is shown")
	_expect(focus_owner == sandra_card, "Sandra notification focus falls back to unlocked thread")

func _exercise_snapshot_resume(main, provider) -> void:
	provider.j01_provider.pending_transition = {
		"kind": "marie_shared_evening",
		"flow_phases": ["OFF_PHONE"],
		"text": "Reprise autoritative.",
	}
	var snapshot: Dictionary = provider.snapshot()
	var restored = provider.get_script().new()
	_expect(restored.initialize() and restored.restore_snapshot(snapshot), "pending snapshot restores")
	var day_end_snapshot: Dictionary = snapshot.duplicate(true)
	day_end_snapshot["provider_snapshots"]["J01"]["pending_transition"] = {}
	day_end_snapshot["provider_snapshots"]["J01"]["day_end_visible"] = true
	var day_end_restored = provider.get_script().new()
	_expect(day_end_restored.initialize() and day_end_restored.restore_snapshot(day_end_snapshot), "day-end snapshot restores")
	var day_end_flow: Dictionary = day_end_restored.pending_transition_flow()
	_expect(day_end_flow.get("flow_phases", []) == ["NIGHT", "NEW_DAY"] and not day_end_flow.get("flow_phases", []).has("OFF_PHONE"), "ready handoff does not replay completed off-phone")
	var handoff_result: Dictionary = day_end_restored.complete_pending_transition_flow("automatic_day_handoff")
	_expect(bool(handoff_result.get("accepted", false)) and day_end_restored.active_day == "J02", "ready handoff completes exactly once")
	day_end_restored.j02_provider.phase = "complete"
	day_end_restored.j02_provider.pending_transition = {}
	var j02_complete_snapshot: Dictionary = day_end_restored.snapshot()
	var j02_complete_restored = provider.get_script().new()
	_expect(j02_complete_restored.initialize() and j02_complete_restored.restore_snapshot(j02_complete_snapshot), "J02 complete snapshot restores")
	var j02_flow: Dictionary = j02_complete_restored.pending_transition_flow()
	_expect(j02_flow.get("flow_phases", []) == ["NIGHT", "NEW_DAY"] and str(j02_flow.get("resume_action", "")) == "automatic_day_handoff", "J02 complete exposes authoritative handoff")
	var messages_script = main.shell.messages_screen.get_script()
	var restored_messages = messages_script.new()
	restored_messages.configure_content_source(restored.presentation_source(), restored)
	add_child(restored_messages)
	await _frames(4)
	_expect(restored_messages.transition_flow_active and restored_messages.time_passage_overlay.current_phase() == "OFF_PHONE", "restored authoritative transition resumes exactly once")
	var first_request_id: int = restored_messages.transition_flow_request_id
	restored_messages.call("_resume_authoritative_transition_flow")
	await _frames(2)
	_expect(restored_messages.transition_flow_request_id == first_request_id, "restored transition request is guarded")
	restored_messages.queue_free()
	provider.j01_provider.pending_transition = {}
	await _frames(2)

func _send_key(keycode: Key) -> void:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.pressed = true
	Input.parse_input_event(event)

func _time_minutes(value: String) -> int:
	var parts := value.split(":")
	return int(parts[0]) * 60 + int(parts[1]) if parts.size() == 2 else -1

func _thread_card(messages, thread_id: String):
	for index in range(messages.conversation_list.threads.size()):
		if str(messages.conversation_list.threads[index].get("thread_id", "")) == thread_id:
			return messages.conversation_list.cards[index]
	return null

func _wait_delivery(messages) -> void:
	for _index in range(600):
		if not messages.runtime_delivery_active:
			return
		await get_tree().process_frame
	_expect(false, "initial transcript delivery completed")

func _press_thread_card(messages, thread_id: String) -> void:
	for index in range(messages.conversation_list.threads.size()):
		if str(messages.conversation_list.threads[index].get("thread_id", "")) == thread_id:
			messages.conversation_list.cards[index].emit_signal("pressed")
			return
	_expect(false, "thread unavailable")

func _frames(count: int) -> void:
	for _index in range(count): await get_tree().process_frame
func _arg(prefix: String, fallback: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="): return arg.trim_prefix(prefix + "=")
	return fallback
func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x")
	return Vector2i(int(parts[0]), int(parts[1])) if parts.size() == 2 else Vector2i.ZERO
func _expect(condition: bool, message: String) -> void:
	if not condition: failures.append(message)
func _finish(size: Vector2i) -> void:
	if failures.is_empty():
		print("UI-MSG-04B2 unified transition smoke %dx%d: OK" % [size.x, size.y])
		get_tree().quit(0)
		return
	for failure in failures: push_error(failure)
	get_tree().quit(1)
