extends "res://scripts/ui/PhonePrototypeV085.gd"

# V0.86a keeps the conversation visible while narrative time advances through
# the smartphone status clock. No blank moment-of-day card is used in the
# active flow.
const TIME_PASSAGE_DELAY_SECONDS := 2.0
const CLOCK_ANIMATION_SECONDS := 5.0
const OPTIONAL_WINDOW_SECONDS := 8.0
const CLOCK_STEP_SECONDS := 0.05

var time_passage_in_progress := false
var time_passage_token := 0
var optional_window_token := 0

func _build_layout() -> void:
	super._build_layout()
	if not is_instance_valid(conversation_view):
		return
	if conversation_view.has_signal("thread_notification_pressed"):
		var callback := Callable(self, "_open_notification_target")
		if not conversation_view.is_connected("thread_notification_pressed", callback):
			conversation_view.connect("thread_notification_pressed", callback)

func _render_active_day(day_value) -> void:
	super._render_active_day(day_value)

func _add_phase_advance_control(_day_value) -> void:
	# No scheduler-like control is shown in the contact list. Optional windows
	# advance naturally if they are left unopened.
	return

func _on_conversation_completed(day_value, conversation_id: String) -> void:
	if is_instance_valid(conversation_view) and conversation_view.has_method("show_contact_offline"):
		conversation_view.call("show_contact_offline", conversation_id)
	var phase := DataLoader.get_timeline_phase_for_conversation(day_value, conversation_id)
	if (
		not phase.is_empty()
		and str(phase.get("id", "")) == TimelineState.current_phase_id(day_value)
		and _phase_is_optional(phase)
	):
		TimelineState.record_episode_completed(day_value, conversation_id)
		TimelineState.complete_phase(day_value, str(phase.get("id", "")))
		optional_window_token += 1
		debug_panel.refresh()
		await _advance_after_phase(day_value, str(phase.get("id", "")))
		return
	await super._on_conversation_completed(day_value, conversation_id)

func _advance_after_phase(day_value, phase_id: String) -> void:
	if time_passage_in_progress:
		return
	var phases: Array = DataLoader.get_timeline_phases(day_value)
	var current_index: int = -1
	for index in range(phases.size()):
		if typeof(phases[index]) == TYPE_DICTIONARY and str(phases[index].get("id", "")) == phase_id:
			current_index = index
			break
	if current_index >= 0 and current_index + 1 < phases.size():
		var raw_next = phases[current_index + 1]
		if typeof(raw_next) == TYPE_DICTIONARY:
			var next_phase: Dictionary = raw_next
			await _pass_time_then_activate_phase(day_value, next_phase)
		return
	await _pass_time_then_complete_day(day_value)

func _pass_time_then_activate_phase(day_value, phase: Dictionary) -> void:
	var target_time := _target_time_for_phase(day_value, phase)
	await _run_clock_passage(day_value, target_time, false)
	await _activate_phase(day_value, phase, false)

func _pass_time_then_complete_day(day_value) -> void:
	var next_day = DataLoader.get_timeline_next_day(day_value)
	if next_day != null:
		await _run_clock_passage(day_value, DataLoader.get_day_start_time(next_day), true)
	else:
		await _wait_scaled(TIME_PASSAGE_DELAY_SECONDS)
	await _complete_day(day_value)

func _run_clock_passage(day_value, target_time: String, crosses_midnight: bool) -> void:
	if time_passage_in_progress:
		return
	time_passage_in_progress = true
	transition_in_progress = true
	optional_window_token += 1
	time_passage_token += 1
	var token: int = time_passage_token
	_hide_notification()
	await _wait_scaled(TIME_PASSAGE_DELAY_SECONDS)
	if token != time_passage_token:
		return
	var start_time := _current_clock_time()
	await _animate_status_clock(start_time, target_time, crosses_midnight, token)
	if token != time_passage_token:
		return
	if not crosses_midnight and target_time != "":
		_on_narrative_time_changed(target_time)
	time_passage_in_progress = false
	transition_in_progress = false

func _current_clock_time() -> String:
	var current_time := status_time_label.text if is_instance_valid(status_time_label) else ""
	if is_instance_valid(conversation_view) and conversation_view.has_method("current_last_message_time"):
		var last_message_time := str(conversation_view.call("current_last_message_time"))
		current_time = _later_time(current_time, last_message_time)
	if is_instance_valid(status_time_label) and current_time != "":
		status_time_label.text = current_time
	return current_time

func _animate_status_clock(start_time: String, target_time: String, crosses_midnight: bool, token: int) -> void:
	if not is_instance_valid(status_time_label) or target_time == "":
		return
	var start_minutes: int = _time_to_minutes(start_time)
	var target_minutes: int = _time_to_minutes(target_time)
	if target_minutes < 0:
		return
	if start_minutes < 0:
		start_minutes = target_minutes
	var target_total: int = target_minutes
	if crosses_midnight or target_total < start_minutes:
		target_total += 24 * 60
	var duration: float = _scaled_seconds(CLOCK_ANIMATION_SECONDS)
	if duration <= 0.0 or target_total == start_minutes:
		status_time_label.text = target_time
		return
	status_time_label.add_theme_font_size_override("font_size", 17)
	var elapsed: float = 0.0
	while elapsed < duration and token == time_passage_token:
		var ratio: float = clampf(elapsed / duration, 0.0, 1.0)
		var shown_minutes: int = roundi(lerpf(float(start_minutes), float(target_total), ratio))
		status_time_label.text = _minutes_to_clock(shown_minutes)
		var step: float = minf(CLOCK_STEP_SECONDS, duration - elapsed)
		await get_tree().create_timer(step).timeout
		elapsed += step
	if token == time_passage_token:
		status_time_label.text = target_time
	status_time_label.add_theme_font_size_override("font_size", 13)

func _minutes_to_clock(total_minutes: int) -> String:
	var normalized: int = total_minutes % (24 * 60)
	if normalized < 0:
		normalized += 24 * 60
	return "%02d:%02d" % [normalized / 60, normalized % 60]

func _scaled_seconds(seconds: float) -> float:
	var speed: float = 1.0
	if is_instance_valid(conversation_view):
		speed = maxf(float(conversation_view.get("debug_speed_multiplier")), 1.0)
	return seconds / speed

func _wait_scaled(seconds: float) -> void:
	await get_tree().create_timer(maxf(_scaled_seconds(seconds), 0.01)).timeout

func _target_time_for_phase(day_value, phase: Dictionary) -> String:
	if _phase_has_authored_beat(phase):
		var beat := _authored_beat_for_phase(phase)
		var beat_time := str(beat.get("time_label", phase.get("time_label", "")))
		if _time_to_minutes(beat_time) >= 0:
			return beat_time
	var direct_time := str(phase.get("time_label", ""))
	if _time_to_minutes(direct_time) >= 0:
		return direct_time
	var card := _transition_card_for_phase(day_value, phase)
	for key in ["title", "subtitle"]:
		var candidate := str(card.get(key, ""))
		if _time_to_minutes(candidate) >= 0:
			return candidate
	return ""

func _activate_phase(day_value, phase: Dictionary, _show_transition: bool) -> void:
	if _phase_has_authored_beat(phase):
		await _activate_authored_beat_inline(day_value, phase)
		return
	if phase.is_empty():
		return
	transition_in_progress = true
	var phase_id := str(phase.get("id", ""))
	TimelineState.set_current_phase(day_value, phase_id)
	var notifications: Array = _unlock_phase_conversations(day_value, phase)
	transition_in_progress = false
	_render_active_day(day_value)
	_render_days_buttons_only()
	var notification := _primary_notification_for_phase(day_value, phase, notifications)
	if not notification.is_empty():
		_show_conversation_notification(
			day_value,
			str(notification.get("thread_id", "")),
			str(notification.get("title", "")),
			str(notification.get("body", ""))
		)
	if _phase_is_optional(phase):
		_schedule_optional_expiry(day_value, phase)

func _activate_authored_beat_inline(day_value, phase: Dictionary) -> void:
	if phase.is_empty():
		return
	transition_in_progress = true
	var phase_id := str(phase.get("id", ""))
	TimelineState.set_current_phase(day_value, phase_id)
	var beat := _authored_beat_for_phase(phase)
	if beat.is_empty():
		push_error("No authored beat variant matched timeline phase: %s" % phase_id)
		transition_in_progress = false
		return
	var time_label := str(beat.get("time_label", phase.get("time_label", "")))
	if time_label != "":
		_on_narrative_time_changed(time_label)
	if is_instance_valid(conversation_view) and conversation_view.has_method("show_offline_beat"):
		conversation_view.call(
			"show_offline_beat",
			str(beat.get("id", phase_id)),
			str(beat.get("title", "")),
			str(beat.get("text", beat.get("subtitle", "")))
		)
	TimelineState.record_day_log_entry(day_value, {
		"id": str(beat.get("id", phase_id)),
		"phase_id": phase_id,
		"time_label": time_label,
		"title": str(beat.get("title", "")),
		"text": str(beat.get("text", beat.get("subtitle", ""))),
	})
	EffectApplier.apply_flags(beat.get("sets_flags", []))
	TimelineState.complete_phase(day_value, phase_id)
	transition_in_progress = false
	_render_active_day(day_value)
	_render_days_buttons_only()
	await _advance_after_phase(day_value, phase_id)

func _schedule_optional_expiry(day_value, phase: Dictionary) -> void:
	optional_window_token += 1
	var token: int = optional_window_token
	var phase_id := str(phase.get("id", ""))
	await get_tree().create_timer(OPTIONAL_WINDOW_SECONDS).timeout
	if token != optional_window_token or time_passage_in_progress:
		return
	if phase_id != TimelineState.current_phase_id(day_value):
		return
	for raw_id in phase.get("optional_conversation_ids", []):
		var conversation_id := str(raw_id)
		if TimelineState.is_optional_opened(day_value, conversation_id) or TimelineState.is_episode_completed(day_value, conversation_id):
			return
	await _advance_optional_phase(day_value, phase_id)

func _primary_notification_for_phase(day_value, phase: Dictionary, notifications: Array) -> Dictionary:
	if not notifications.is_empty() and typeof(notifications[0]) == TYPE_DICTIONARY:
		return notifications[0]
	for raw_id in _phase_conversation_ids(phase):
		var conversation_id := str(raw_id)
		if not _is_episode_available(day_value, conversation_id):
			continue
		var raw_conversation = DataLoader.conversations_by_id.get(conversation_id, {})
		if typeof(raw_conversation) != TYPE_DICTIONARY:
			continue
		var conversation: Dictionary = raw_conversation
		var thread = conversation.get("thread", {})
		var title := str(thread.get("display_name", conversation.get("title", conversation_id))) if typeof(thread) == TYPE_DICTIONARY else str(conversation.get("title", conversation_id))
		var body := "Nouveau message"
		for message in _collect_messages(conversation):
			if typeof(message) != TYPE_DICTIONARY or bool(message.get("_system_note", false)):
				continue
			var candidate := str(message.get("text", message.get("body", "")))
			if candidate != "":
				body = candidate
				break
		return {
			"thread_id": _thread_id_for_conversation_id(day_value, conversation_id),
			"title": title,
			"body": body,
		}
	return {}

func _complete_day(day_value) -> void:
	_hide_notification()
	_clear_pending_for_day(day_value)
	TimelineState.mark_day_complete(day_value)
	var next_day = DataLoader.get_timeline_next_day(day_value)
	if next_day != null:
		TimelineState.unlock_day(next_day)
		TimelineState.set_current_day(next_day)
		current_day_value = next_day
		viewing_archived_day = false
		_render_days()
		var initial_phase := DataLoader.get_timeline_phase(next_day, TimelineState.current_phase_id(next_day))
		var notification := _primary_notification_for_phase(next_day, initial_phase, [])
		if not notification.is_empty():
			_show_conversation_notification(
				next_day,
				str(notification.get("thread_id", "")),
				str(notification.get("title", "")),
				str(notification.get("body", ""))
			)
	else:
		_render_days_buttons_only()
	transition_in_progress = false
	time_passage_in_progress = false

func _show_conversation_notification(day_value, conversation_id: String, title: String, body: String) -> void:
	notification_target_day_value = day_value
	notification_target_conversation_id = conversation_id
	var has_open_thread: bool = is_instance_valid(conversation_view) and not conversation_view.current_conversation.is_empty()
	if has_open_thread and conversation_view.has_method("show_thread_notification"):
		conversation_view.call(
			"show_thread_notification",
			title,
			body,
			_notification_time_for_thread(day_value, conversation_id)
		)
		return
	_show_notification("%s — %s" % [title, body])

func _notification_time_for_thread(day_value, conversation_id: String) -> String:
	var metadata := _moment_metadata_by_conversation_id(day_value)
	var bucket = metadata.get(conversation_id, {})
	if typeof(bucket) == TYPE_DICTIONARY:
		var times: Array = bucket.get("times", [])
		if not times.is_empty():
			return str(times[-1])
	if is_instance_valid(status_time_label):
		return status_time_label.text
	return ""

func _open_conversation(day_value, conversation: Dictionary) -> void:
	if time_passage_in_progress:
		return
	var phase := DataLoader.get_timeline_phase(day_value, TimelineState.current_phase_id(day_value))
	if _phase_is_optional(phase):
		for optional_id in phase.get("optional_conversation_ids", []):
			if _conversation_episode_ids(conversation).has(str(optional_id)):
				optional_window_token += 1
				break
	var opening_id := _conversation_id(conversation)
	var target_before := notification_target_conversation_id
	super._open_conversation(day_value, conversation)
	if opening_id == target_before:
		_hide_notification()

func _hide_notification() -> void:
	super._hide_notification()
	if is_instance_valid(conversation_view) and conversation_view.has_method("hide_thread_notification"):
		conversation_view.call("hide_thread_notification")

func _add_conversation_card(day_value, conversation: Dictionary) -> void:
	var is_pending := _is_conversation_pending(conversation)
	var is_active := (
		str(GameState.context.get("day", "")) == str(day_value)
		and str(GameState.context.get("conversation_id", "")) == _conversation_id(conversation)
	)
	var card := _make_card(is_pending)
	card.name = "UnreadContactCard" if is_pending else ("ActiveContactCard" if is_active else "ReadContactCard")
	if is_active and not is_pending:
		card.add_theme_stylebox_override("panel", _card_style(CARD_HOVER_COLOR, true))
	conversation_cards.add_child(card)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_child(row)
	_add_avatar(row, _avatar_initial(conversation))

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text_box)
	var name_label := _add_label(text_box, _conversation_name(conversation), 16 if is_pending else 15)
	var preview_label := _add_muted_label(text_box, _conversation_subtitle(conversation), 13 if is_pending else 12)
	if is_pending:
		name_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		name_label.add_theme_constant_override("outline_size", 1)
		preview_label.add_theme_color_override("font_color", Color(0.90, 0.94, 1.0))
		preview_label.add_theme_constant_override("outline_size", 1)

	var status_box := VBoxContainer.new()
	status_box.custom_minimum_size = Vector2(76, 0)
	row.add_child(status_box)
	_add_muted_label(status_box, _conversation_status_text(conversation), 11)
	if _conversation_has_activity_badge(conversation):
		var badge := Label.new()
		badge.name = "badge"
		badge.text = "●"
		badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		badge.add_theme_font_size_override("font_size", 19 if is_pending else 15)
		badge.add_theme_color_override("font_color", PENDING_COLOR if is_pending else ACCENT_COLOR)
		status_box.add_child(badge)
		if is_pending:
			var unread := _add_label(status_box, "NON LU", 10)
			unread.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			unread.add_theme_color_override("font_color", Color(0.88, 0.94, 1.0))
		elif is_active:
			_add_muted_label(status_box, "ouvert", 10)

	card.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_open_conversation(day_value, conversation)
	)

func _on_game_state_changed() -> void:
	var resetting := GameState.context.get("day", null) == null and str(GameState.context.get("last_choice", "")) == ""
	if resetting:
		time_passage_token += 1
		optional_window_token += 1
		time_passage_in_progress = false
	super._on_game_state_changed()
