extends "res://scripts/ui/ConversationViewV084.gd"

signal thread_notification_pressed

const PHONE_STATUS_CONNECTIVITY := "▮▮  Wi‑Fi  82%"
const NOTIFICATION_PREVIEW_CHARACTERS := 10

var phone_status_panel: PanelContainer
var phone_status_time_label: Label
var phone_status_connectivity_label: Label
var phone_status_time_text: String = "--:--"
var phone_status_connectivity_text: String = PHONE_STATUS_CONNECTIVITY
var thread_notification_panel: PanelContainer
var thread_notification_label: Label
var thread_notification_tween: Tween

func _add_chat_header(conversation: Dictionary) -> void:
	super._add_chat_header(conversation)
	_build_phone_status_bar()
	_build_thread_notification_banner()

func _build_phone_status_bar() -> void:
	phone_status_panel = PanelContainer.new()
	phone_status_panel.name = "ConversationPhoneStatusBar"
	phone_status_panel.custom_minimum_size = Vector2(0, 34)
	phone_status_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	phone_status_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	phone_status_panel.add_theme_stylebox_override(
		"panel",
		_panel_style(Color(0.045, 0.05, 0.075), 12)
	)
	chat_shell.add_child(phone_status_panel)
	chat_shell.move_child(phone_status_panel, 0)

	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	phone_status_panel.add_child(row)

	phone_status_time_label = Label.new()
	phone_status_time_label.name = "ConversationPhoneClock"
	phone_status_time_label.text = phone_status_time_text
	phone_status_time_label.add_theme_font_size_override("font_size", 13)
	phone_status_time_label.add_theme_color_override("font_color", Color(0.91, 0.93, 0.98))
	row.add_child(phone_status_time_label)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(spacer)

	phone_status_connectivity_label = Label.new()
	phone_status_connectivity_label.name = "ConversationPhoneConnectivity"
	phone_status_connectivity_label.text = phone_status_connectivity_text
	phone_status_connectivity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	phone_status_connectivity_label.add_theme_font_size_override("font_size", 12)
	phone_status_connectivity_label.add_theme_color_override("font_color", Color(0.78, 0.81, 0.88))
	row.add_child(phone_status_connectivity_label)

func set_phone_status(time_label: String, connectivity_text: String = PHONE_STATUS_CONNECTIVITY) -> void:
	if time_label != "":
		phone_status_time_text = time_label
	if connectivity_text != "":
		phone_status_connectivity_text = connectivity_text
	if is_instance_valid(phone_status_time_label):
		phone_status_time_label.text = phone_status_time_text
	if is_instance_valid(phone_status_connectivity_label):
		phone_status_connectivity_label.text = phone_status_connectivity_text

func set_phone_clock_emphasis(active: bool) -> void:
	if not is_instance_valid(phone_status_time_label):
		return
	phone_status_time_label.add_theme_font_size_override("font_size", 17 if active else 13)
	phone_status_time_label.add_theme_color_override(
		"font_color",
		Color(1.0, 1.0, 1.0) if active else Color(0.91, 0.93, 0.98)
	)

func _build_thread_notification_banner() -> void:
	thread_notification_panel = PanelContainer.new()
	thread_notification_panel.name = "ThreadNotificationShortcut"
	thread_notification_panel.visible = false
	thread_notification_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	thread_notification_panel.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	thread_notification_panel.focus_mode = Control.FOCUS_ALL
	thread_notification_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	thread_notification_panel.add_theme_stylebox_override(
		"panel",
		_panel_style(Color(0.11, 0.17, 0.25), 12)
	)
	thread_notification_panel.gui_input.connect(_on_thread_notification_input)
	chat_shell.add_child(thread_notification_panel)
	chat_shell.move_child(thread_notification_panel, 2)

	thread_notification_label = Label.new()
	thread_notification_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	thread_notification_label.add_theme_font_size_override("font_size", 12)
	thread_notification_label.add_theme_color_override("font_color", Color(0.92, 0.96, 1.0))
	thread_notification_panel.add_child(thread_notification_label)

func show_thread_notification(contact_name: String, preview: String, time_label: String = "") -> void:
	if not is_instance_valid(thread_notification_panel) or not is_instance_valid(thread_notification_label):
		return
	var header: String = "Nouveau message · %s" % contact_name
	if time_label != "":
		header += " · %s" % time_label
	var compact_preview: String = _compact_notification_preview(preview)
	thread_notification_label.text = header if compact_preview == "" else "%s\n%s" % [header, compact_preview]
	thread_notification_panel.visible = true
	_play_thread_notification_arrival()
	_scroll_to_bottom.call_deferred()

func hide_thread_notification() -> void:
	if thread_notification_tween != null:
		thread_notification_tween.kill()
		thread_notification_tween = null
	if is_instance_valid(thread_notification_panel):
		thread_notification_panel.visible = false
		thread_notification_panel.modulate = Color(1.0, 1.0, 1.0, 1.0)
	if is_instance_valid(thread_notification_label):
		thread_notification_label.text = ""

func _compact_notification_preview(preview: String) -> String:
	var normalized: String = preview.replace("\r", " ").replace("\n", " ").strip_edges()
	while normalized.contains("  "):
		normalized = normalized.replace("  ", " ")
	if normalized.length() <= NOTIFICATION_PREVIEW_CHARACTERS:
		return normalized
	return "%s..." % normalized.substr(0, NOTIFICATION_PREVIEW_CHARACTERS)

func _play_thread_notification_arrival() -> void:
	if not is_instance_valid(thread_notification_panel):
		return
	if thread_notification_tween != null:
		thread_notification_tween.kill()
	thread_notification_panel.modulate = Color(0.72, 0.86, 1.0, 0.0)
	thread_notification_tween = create_tween()
	thread_notification_tween.set_trans(Tween.TRANS_QUAD)
	thread_notification_tween.set_ease(Tween.EASE_OUT)
	thread_notification_tween.tween_property(
		thread_notification_panel,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		0.16
	)
	thread_notification_tween.tween_property(
		thread_notification_panel,
		"modulate",
		Color(0.80, 0.91, 1.0, 1.0),
		0.10
	)
	thread_notification_tween.tween_property(
		thread_notification_panel,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		0.24
	)

func _show_choices_for_segment(data: Dictionary, _show_empty_hint := true, persist_state := true) -> bool:
	return super._show_choices_for_segment(data, false, persist_state)

func show_contact_offline(marker_id: String = "") -> void:
	if current_conversation.is_empty() or active_state.is_empty():
		return
	var contact_name: String = _conversation_name(current_conversation)
	if contact_name == "":
		return
	var markers: Dictionary = active_state.get("v086a_offline_markers", {})
	var key: String = marker_id if marker_id != "" else active_conversation_id
	if bool(markers.get(key, false)):
		return
	markers[key] = true
	active_state["v086a_offline_markers"] = markers
	_add_system_note("%s est hors ligne" % contact_name, false)

func continue_active_thread(conversation: Dictionary) -> void:
	if current_conversation.is_empty() or active_state.is_empty():
		return
	if _conversation_key(conversation) != active_conversation_id:
		return
	var appended: bool = _append_unseen_thread_segments(conversation)
	if not appended or bool(active_state.get("sequence_in_progress", false)):
		return
	if bool(active_state.get("sequence_complete", false)) and _has_next_segment():
		active_state["sequence_complete"] = false
		_resume_active_thread.call_deferred(active_conversation_id, current_render_token)

func _append_unseen_thread_segments(conversation: Dictionary) -> bool:
	var merged: Dictionary = active_state.get("conversation", {}).duplicate(true)
	var merged_segments: Array = merged.get("segments", []).duplicate(true)
	var seen_keys: Dictionary = {}
	for raw_segment in merged_segments:
		if typeof(raw_segment) == TYPE_DICTIONARY:
			seen_keys[_continuation_segment_key(raw_segment)] = true
	var appended := false
	for raw_segment in conversation.get("segments", []):
		if typeof(raw_segment) != TYPE_DICTIONARY:
			continue
		var segment: Dictionary = raw_segment
		var key: String = _continuation_segment_key(segment)
		if bool(seen_keys.get(key, false)):
			continue
		merged_segments.append(segment.duplicate(true))
		seen_keys[key] = true
		appended = true
	var episode_ids: Array = merged.get("_episode_ids", []).duplicate()
	for raw_episode_id in conversation.get("_episode_ids", []):
		var episode_id: String = str(raw_episode_id)
		if not episode_ids.has(episode_id):
			episode_ids.append(episode_id)
	merged["segments"] = merged_segments
	merged["_episode_ids"] = episode_ids
	merged["_segment_count"] = merged_segments.size()
	for metadata_key in [
		"day",
		"chapter",
		"title",
		"thread",
		"thread_id",
		"_parent_conversation_id",
		"_index_title",
		"_index_calendar_label",
		"_index_display_label",
	]:
		if conversation.has(metadata_key):
			merged[metadata_key] = conversation.get(metadata_key)
	active_state["conversation"] = merged
	current_conversation = merged
	return appended

func _continuation_segment_key(segment: Dictionary) -> String:
	return "%s|%s" % [
		str(segment.get("_source_conversation_id", "")),
		str(segment.get("id", "")),
	]

func _resume_active_thread(conversation_id: String, token: int) -> void:
	if not _is_render_current(conversation_id, token):
		return
	await _auto_advance_segments_until_choice(conversation_id, token)

func _render_message_with_typing(message: Dictionary, conversation_id: String, token: int) -> void:
	if str(message.get("presentation", "")) == "offline_beat":
		if not _is_render_current(conversation_id, token):
			return
		if _history_contains_authored_item(message):
			return
		_record_authored_history_key(message)
		return
	await super._render_message_with_typing(message, conversation_id, token)

func current_last_message_time() -> String:
	if active_state.is_empty():
		return ""
	var history: Array = active_state.get("history", [])
	for index in range(history.size() - 1, -1, -1):
		var raw_entry = history[index]
		if typeof(raw_entry) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = raw_entry
		if str(entry.get("type", "")) != "message":
			continue
		var raw_message = entry.get("message", {})
		if typeof(raw_message) != TYPE_DICTIONARY:
			continue
		var time_label: String = str((raw_message as Dictionary).get("time_label", ""))
		if time_label != "":
			return time_label
	return ""

func current_contact_name() -> String:
	if current_conversation.is_empty():
		return ""
	return _conversation_name(current_conversation)

func current_thread_id() -> String:
	return active_conversation_id

func _on_thread_notification_input(event: InputEvent) -> void:
	var activated: bool = false
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		activated = true
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]:
		activated = true
	if activated:
		thread_notification_pressed.emit()
