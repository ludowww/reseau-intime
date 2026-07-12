extends "res://scripts/ui/PhonePrototypeV085.gd"

# Small UX layer: intra-day time stays readable through the status bar and
# contact timestamps. Time passage is acknowledged from the open thread before
# the next phase, while full-screen cards wait for an explicit click.
var day_finish_ready: Dictionary = {}
var timeline_prompt_action := ""
var timeline_prompt_day = null
var timeline_prompt_phase_id := ""

func _build_layout() -> void:
	super._build_layout()
	if not is_instance_valid(conversation_view):
		return
	if conversation_view.has_signal("thread_notification_pressed"):
		var thread_callback := Callable(self, "_open_notification_target")
		if not conversation_view.is_connected("thread_notification_pressed", thread_callback):
			conversation_view.connect("thread_notification_pressed", thread_callback)
	if conversation_view.has_signal("timeline_prompt_pressed"):
		var timeline_callback := Callable(self, "_on_timeline_prompt_pressed")
		if not conversation_view.is_connected("timeline_prompt_pressed", timeline_callback):
			conversation_view.connect("timeline_prompt_pressed", timeline_callback)

func _render_active_day(day_value) -> void:
	super._render_active_day(day_value)
	if bool(day_finish_ready.get(str(day_value), false)) and not TimelineState.is_day_completed(day_value):
		_add_muted_label(conversation_list, "Tous les échanges requis de la journée sont terminés.", 12)
		var finish_button := _add_button(conversation_list, "Finir la journée")
		finish_button.name = "FinishDayButton"
		finish_button.pressed.connect(func(): _finish_day_requested(day_value))
	_refresh_timeline_prompt(day_value)

func _advance_after_phase(day_value, phase_id: String) -> void:
	if transition_in_progress:
		return
	var phases := DataLoader.get_timeline_phases(day_value)
	var current_index := -1
	for index in range(phases.size()):
		if typeof(phases[index]) == TYPE_DICTIONARY and str(phases[index].get("id", "")) == phase_id:
			current_index = index
			break
	if current_index >= 0 and current_index + 1 < phases.size():
		_queue_phase_activation(day_value, phases[current_index + 1])
		transition_in_progress = false
		_render_active_day(day_value)
		_render_days_buttons_only()
	else:
		day_finish_ready[str(day_value)] = true
		transition_in_progress = false
		_clear_timeline_prompt()
		_render_active_day(day_value)
		_render_days_buttons_only()

func _activate_phase(day_value, phase: Dictionary, show_transition: bool) -> void:
	if _phase_has_authored_beat(phase):
		await super._activate_phase(day_value, phase, show_transition)
		return
	if phase.is_empty():
		return
	transition_in_progress = true
	_hide_notification()
	var phase_id := str(phase.get("id", ""))
	TimelineState.set_current_phase(day_value, phase_id)
	var notifications: Array = _unlock_phase_conversations(day_value, phase)
	transition_in_progress = false
	_render_active_day(day_value)
	_render_days_buttons_only()
	for notification in notifications:
		_show_conversation_notification(
			day_value,
			str(notification.get("thread_id", "")),
			str(notification.get("title", "")),
			str(notification.get("body", ""))
		)

func _add_phase_advance_control(_day_value) -> void:
	# V0.86a removes the scheduler-like left-column button. Optional phases are
	# advanced from a contextual time-passage shortcut in the open conversation.
	return

func _queue_phase_activation(day_value, phase: Dictionary) -> void:
	timeline_prompt_action = "activate_phase"
	timeline_prompt_day = day_value
	timeline_prompt_phase_id = str(phase.get("id", ""))

func _refresh_timeline_prompt(day_value) -> void:
	if transition_in_progress or TimelineState.is_day_completed(day_value) or not is_instance_valid(conversation_view):
		return
	if timeline_prompt_action == "activate_phase" and str(timeline_prompt_day) == str(day_value):
		var queued_phase := DataLoader.get_timeline_phase(day_value, timeline_prompt_phase_id)
		_show_timeline_prompt_for_phase(day_value, queued_phase)
		return
	var current_phase := DataLoader.get_timeline_phase(day_value, TimelineState.current_phase_id(day_value))
	var optional_ids: Array = current_phase.get("optional_conversation_ids", [])
	if optional_ids.is_empty():
		return
	for raw_id in optional_ids:
		var conversation_id := str(raw_id)
		if TimelineState.is_optional_opened(day_value, conversation_id) and not TimelineState.is_episode_completed(day_value, conversation_id):
			conversation_view.call("hide_thread_notification")
			return
	timeline_prompt_action = "advance_optional"
	timeline_prompt_day = day_value
	timeline_prompt_phase_id = str(current_phase.get("id", ""))
	var next_phase := _next_phase_after(day_value, timeline_prompt_phase_id)
	_show_timeline_prompt_for_phase(day_value, next_phase)

func _show_timeline_prompt_for_phase(day_value, phase: Dictionary) -> void:
	if phase.is_empty() or not conversation_view.has_method("show_timeline_prompt"):
		return
	var time_label := str(phase.get("time_label", ""))
	var title := "Le temps passe"
	if time_label != "":
		title += " · %s" % time_label
	var preview := _phase_notification_preview(day_value, phase)
	if preview == "":
		preview = "Cliquer pour voir la suite."
	conversation_view.call("show_timeline_prompt", title, preview)

func _phase_notification_preview(day_value, phase: Dictionary) -> String:
	for raw_id in _phase_conversation_ids(phase):
		var rule := _unlock_rule_for_target(day_value, str(raw_id))
		var notification = rule.get("notification", {})
		if typeof(notification) == TYPE_DICTIONARY:
			var title := str(notification.get("title", ""))
			var body := str(notification.get("body", ""))
			if title != "" and body != "":
				return "Nouveau message de %s : %s" % [title, body]
			if body != "":
				return body
	return ""

func _next_phase_after(day_value, phase_id: String) -> Dictionary:
	var phases := DataLoader.get_timeline_phases(day_value)
	for index in range(phases.size()):
		if typeof(phases[index]) == TYPE_DICTIONARY and str(phases[index].get("id", "")) == phase_id:
			if index + 1 < phases.size() and typeof(phases[index + 1]) == TYPE_DICTIONARY:
				return phases[index + 1]
			break
	return {}

func _on_timeline_prompt_pressed() -> void:
	if timeline_prompt_action == "" or timeline_prompt_day == null:
		return
	var action := timeline_prompt_action
	var day_value = timeline_prompt_day
	var phase_id := timeline_prompt_phase_id
	_clear_timeline_prompt()
	if action == "advance_optional":
		await _advance_optional_phase(day_value, phase_id)
		return
	var phase := DataLoader.get_timeline_phase(day_value, phase_id)
	if phase.is_empty():
		return
	if not _phase_has_authored_beat(phase):
		var card := _transition_card_for_phase(day_value, phase)
		if not card.is_empty():
			await timeline_transition_view.show_moment_transition(card)
	await _activate_phase(day_value, phase, false)

func _clear_timeline_prompt() -> void:
	timeline_prompt_action = ""
	timeline_prompt_day = null
	timeline_prompt_phase_id = ""
	if is_instance_valid(conversation_view) and conversation_view.has_method("hide_thread_notification"):
		conversation_view.call("hide_thread_notification")

func _finish_day_requested(day_value) -> void:
	if transition_in_progress or not bool(day_finish_ready.get(str(day_value), false)):
		return
	day_finish_ready.erase(str(day_value))
	_clear_timeline_prompt()
	await _complete_day(day_value)

func _show_conversation_notification(day_value, conversation_id: String, title: String, body: String) -> void:
	notification_target_day_value = day_value
	notification_target_conversation_id = conversation_id
	var has_open_thread: bool = is_instance_valid(conversation_view) and not conversation_view.current_conversation.is_empty()
	var current_thread: String = ""
	if has_open_thread:
		current_thread = str(conversation_view.active_conversation_id)
	if has_open_thread and current_thread != conversation_id and conversation_view.has_method("show_thread_notification"):
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
	var opening_id := _conversation_id(conversation)
	var target_before := notification_target_conversation_id
	super._open_conversation(day_value, conversation)
	if opening_id == target_before:
		_hide_notification()
	_refresh_timeline_prompt(day_value)

func _open_notification_target() -> void:
	if timeline_prompt_action != "":
		_on_timeline_prompt_pressed()
		return
	super._open_notification_target()

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
		day_finish_ready.clear()
		_clear_timeline_prompt()
	super._on_game_state_changed()
