extends VBoxContainer

class_name PortraitConversationScreen

signal back_requested
signal choice_selected(choice: Dictionary)
signal image_requested(message_id: String, media_ref: String)
signal reading_speed_requested
signal header_notification_open_requested(thread_id: String)
signal header_notification_dismiss_requested

const TIMELINE_SCRIPT := preload("res://scripts/ui/messages/MessageTimeline.gd")
const CHOICE_BAR_SCRIPT := preload("res://scripts/ui/messages/ChoiceBar.gd")
const NOTIFICATION_BANNER_SCRIPT := preload("res://scripts/ui/messages/NotificationBanner.gd")

var PORTRAIT_THEME
var thread: Dictionary = {}
var characters: Dictionary = {}
var timeline
var choice_bar
var conversation_header: PanelContainer
var title_label: Label
var narrative_time_label: Label
var narrative_day_short := ""
var narrative_time := ""
var avatar_label: Label
var back_button: Button
var reading_speed_button: Button
var compact_height_mode := false
var reading_speed_label := "×1"
var reading_speed_tooltip := ""
var header_notification_host: Control
var header_notification

func configure(thread_presentation: Dictionary, message_presentations: Array[Dictionary], choice_presentations: Array[Dictionary], character_presentations: Dictionary, portrait_theme, reading_position := -1, first_unread_message_id := "") -> void:
	thread = thread_presentation
	characters = character_presentations
	PORTRAIT_THEME = portrait_theme
	_build(message_presentations, choice_presentations, reading_position, first_unread_message_id)

func set_reading_speed_state(label: String, tooltip: String) -> void:
	reading_speed_label = label
	reading_speed_tooltip = tooltip
	if reading_speed_button != null:
		reading_speed_button.text = reading_speed_label
		reading_speed_button.tooltip_text = reading_speed_tooltip

func set_narrative_time(value: String) -> void:
	narrative_time = value if _is_valid_narrative_time(value) else ""
	_update_narrative_context()

func set_narrative_day_short(value: String) -> void:
	narrative_day_short = value if value in ["Mar.", "Mer.", "Jeu."] else ""
	_update_narrative_context()

func show_header_notification(notification: Dictionary, reduced_motion: bool) -> void:
	if header_notification == null:
		return
	header_notification_host.visible = true
	header_notification.configure(notification, PORTRAIT_THEME, reduced_motion, true, header_notification.AUTO_DISMISS_SECONDS)

func hide_header_notification() -> void:
	if header_notification != null:
		header_notification.dismiss()
	if header_notification_host != null:
		header_notification_host.visible = false

func header_notification_visible() -> bool:
	return header_notification_host != null and header_notification_host.visible and header_notification != null and header_notification.visible

func set_compact_height_mode(enabled: bool) -> void:
	compact_height_mode = enabled
	add_theme_constant_override("separation", 6 if enabled else 10)
	if conversation_header != null:
		conversation_header.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE_RAISED, 1, 12 if enabled else 18))

func append_player_choice(choice: Dictionary) -> void:
	timeline.append_player_choice(choice)
	choice_bar.clear_choices()
	back_button.call_deferred("grab_focus")

func append_incoming_message(message: Dictionary, force_follow := false) -> void:
	timeline.append_incoming_message(message, force_follow)

func append_messages(message_presentations: Array[Dictionary]) -> void:
	for message in message_presentations:
		timeline.append_incoming_message(message)

func replace_choices(choice_presentations: Array[Dictionary]) -> void:
	choice_bar.set_choices(choice_presentations)

func show_typing(author: Dictionary, reduced_motion: bool, force_follow := false, speed_multiplier := 1.0) -> void:
	timeline.show_typing(author, reduced_motion, force_follow, speed_multiplier)

func hide_typing() -> void:
	if timeline != null:
		timeline.hide_typing()

func typing_visible() -> bool:
	return timeline != null and timeline.typing_visible()

func typing_instance_count() -> int:
	return timeline.typing_instance_count() if timeline != null else 0

func typing_animation_running() -> bool:
	return timeline != null and timeline.typing_animation_running()

func advance_typing_phase() -> void:
	if timeline != null:
		timeline.advance_typing_phase()

func activate_first_choice() -> void:
	choice_bar.activate_first_choice()

func player_message_count() -> int:
	return timeline.player_message_count()

func message_count() -> int:
	return timeline.message_count()

func choice_count() -> int:
	return choice_bar.choice_count()

func get_reading_position() -> int:
	return timeline.get_reading_position()

func focus_image_message(message_id: String) -> bool:
	return timeline.focus_image_message(message_id)

func describe_state() -> Dictionary:
	return {
		"conversation_title": title_label.text,
		"is_group": bool(thread.get("is_group", false)),
		"message_count": message_count(),
		"player_message_count": player_message_count(),
		"choice_count": choice_count(),
		"unread_divider_count": timeline.unread_divider_count(),
		"day_divider_count": timeline.day_divider_count(),
		"day_divider_labels": timeline.day_divider_labels(),
		"message_bubble_count": timeline.message_bubble_count(),
		"image_message_count": timeline.image_message_count(),
		"image_message_ids": timeline.image_message_ids(),
		"image_with_caption_count": timeline.image_message_with_caption_count(),
		"image_without_caption_count": timeline.image_message_without_caption_count(),
		"focused_image_message_id": timeline.focused_image_message_id(),
		"image_request_count": timeline.image_request_count(),
		"image_last_request": timeline.last_image_request(),
		"image_ratio": timeline.image_ratio(),
		"minimum_image_target": timeline.minimum_image_target(),
		"image_has_caption": timeline.image_has_caption(),
		"image_caption": timeline.image_caption(),
		"image_animation_running": timeline.image_animation_running(),
		"day_divider_has_timestamp": timeline.day_divider_has_timestamp(),
		"day_divider_has_author": timeline.day_divider_has_author(),
		"day_divider_precedes_unread": timeline.day_divider_precedes_unread_divider(),
		"last_message_visible": timeline.is_last_message_visible(),
		"reading_position_coherent": timeline.reading_position_coherent(),
		"group_author_visible": timeline.group_author_visible(),
		"group_author_avatar_visible": timeline.group_author_avatar_visible(),
		"group_author_accent_visible": timeline.group_author_accent_visible(),
		"choice_has_focus": choice_bar.first_choice_has_focus(),
		"typing_visible": timeline.typing_visible(),
		"typing_instance_count": timeline.typing_instance_count(),
		"typing_animation_running": timeline.typing_animation_running(),
		"typing_text": timeline.typing_text(),
		"typing_avatar": timeline.typing_avatar(),
		"typing_accent_visible": timeline.typing_accent_visible(),
		"typing_has_timestamp": timeline.typing_has_timestamp(),
		"typing_last_item": timeline.typing_is_last_item(),
		"conversation_header_visible": conversation_header != null and conversation_header.is_visible_in_tree(),
		"reading_speed_visible": reading_speed_button != null and reading_speed_button.is_visible_in_tree(),
		"reading_speed_label": reading_speed_button.text if reading_speed_button != null else reading_speed_label,
		"narrative_time_visible": narrative_time_label != null and narrative_time_label.visible,
		"narrative_time_text": narrative_time_label.text if narrative_time_label != null else "",
		"header_notification_visible": header_notification_visible(),
		"header_notification_rect": header_notification.get_global_rect() if header_notification_visible() else Rect2(),
		"header_notification_host_rect": header_notification_host.get_global_rect() if header_notification_host != null else Rect2(),
		"conversation_header_rect": conversation_header.get_global_rect() if conversation_header != null else Rect2(),
		"timeline_rect": timeline.get_global_rect() if timeline != null else Rect2(),
		"choice_bar_rect": choice_bar.get_global_rect() if choice_bar != null and choice_bar.visible else Rect2(),
		"has_horizontal_crop": timeline.has_horizontal_crop() or choice_bar.has_horizontal_crop(),
	}

func _build(message_presentations: Array[Dictionary], choice_presentations: Array[Dictionary], reading_position: int, first_unread_message_id: String) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 6 if compact_height_mode else 10)
	conversation_header = PanelContainer.new()
	conversation_header.name = "ConversationHeader"
	conversation_header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	conversation_header.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE_RAISED, 1, 12 if compact_height_mode else 18))
	add_child(conversation_header)
	var header_row := HBoxContainer.new()
	header_row.name = "HeaderRow"
	header_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_row.add_theme_constant_override("separation", 8)
	conversation_header.add_child(header_row)
	back_button = Button.new()
	back_button.name = "Back"
	back_button.text = "←"
	back_button.tooltip_text = "Retour aux conversations"
	back_button.custom_minimum_size = Vector2(48, 48)
	back_button.focus_mode = Control.FOCUS_ALL
	back_button.add_theme_font_size_override("font_size", 22)
	back_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.08, 0.10, 0.17), PORTRAIT_THEME.BORDER, 16))
	back_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	back_button.pressed.connect(func(): back_requested.emit())
	header_row.add_child(back_button)
	var accent := Color.from_string(str(thread.get("accent_color", "#8D63E6")), PORTRAIT_THEME.PLAYER_ACCENT)
	avatar_label = _label(str(thread.get("avatar_ref", "?")), 20, accent)
	avatar_label.name = "Avatar"
	avatar_label.custom_minimum_size = Vector2(48, 48)
	avatar_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	avatar_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	avatar_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	avatar_label.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.06, 0.08, 0.14), accent, 23))
	header_row.add_child(avatar_label)
	var identity_column := VBoxContainer.new()
	identity_column.name = "IdentityColumn"
	identity_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	identity_column.add_theme_constant_override("separation", 0)
	header_row.add_child(identity_column)
	title_label = _label(str(thread.get("title", "Conversation")), 23, PORTRAIT_THEME.TEXT_PRIMARY)
	title_label.name = "ConversationName"
	title_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	title_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	identity_column.add_child(title_label)
	narrative_time_label = _label("", 14, PORTRAIT_THEME.TEXT_SECONDARY)
	narrative_time_label.name = "NarrativeTime"
	narrative_time_label.visible = false
	identity_column.add_child(narrative_time_label)
	reading_speed_button = Button.new()
	reading_speed_button.name = "ReadingSpeed"
	reading_speed_button.text = reading_speed_label
	reading_speed_button.tooltip_text = reading_speed_tooltip
	reading_speed_button.custom_minimum_size = Vector2(44, 44)
	reading_speed_button.focus_mode = Control.FOCUS_ALL
	reading_speed_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	reading_speed_button.add_theme_font_size_override("font_size", 17)
	reading_speed_button.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	reading_speed_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.09, 0.11, 0.18), PORTRAIT_THEME.MESSAGE_ACCENT, 16))
	reading_speed_button.add_theme_stylebox_override("hover", PORTRAIT_THEME.button_style(Color(0.13, 0.16, 0.24), PORTRAIT_THEME.MESSAGE_ACCENT, 16))
	reading_speed_button.add_theme_stylebox_override("pressed", PORTRAIT_THEME.button_style(Color(0.17, 0.20, 0.30), PORTRAIT_THEME.MESSAGE_ACCENT, 16))
	reading_speed_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	reading_speed_button.pressed.connect(func(): reading_speed_requested.emit())
	header_row.add_child(reading_speed_button)
	header_notification_host = Control.new()
	header_notification_host.name = "HeaderNotificationHost"
	header_notification_host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	header_notification_host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header_notification_host.clip_contents = true
	header_notification_host.z_index = 5
	header_notification_host.visible = false
	conversation_header.add_child(header_notification_host)
	header_notification = NOTIFICATION_BANNER_SCRIPT.new()
	header_notification.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	header_notification.open_requested.connect(func(thread_id: String): header_notification_open_requested.emit(thread_id))
	header_notification.dismiss_requested.connect(_on_header_notification_dismiss_requested)
	header_notification_host.add_child(header_notification)
	timeline = TIMELINE_SCRIPT.new()
	timeline.name = "MessageTimeline"
	add_child(timeline)
	timeline.image_requested.connect(func(message_id: String, media_ref: String): image_requested.emit(message_id, media_ref))
	timeline.configure(message_presentations, characters, bool(thread.get("is_group", false)), PORTRAIT_THEME, reading_position, first_unread_message_id)
	choice_bar = CHOICE_BAR_SCRIPT.new()
	choice_bar.name = "ChoiceBar"
	add_child(choice_bar)
	choice_bar.choice_selected.connect(func(choice: Dictionary): choice_selected.emit(choice))
	choice_bar.configure(choice_presentations, PORTRAIT_THEME)

func _is_valid_narrative_time(value: String) -> bool:
	if value.length() != 5 or value[2] != ":":
		return false
	if not value.substr(0, 2).is_valid_int() or not value.substr(3, 2).is_valid_int():
		return false
	var hour := int(value.substr(0, 2))
	var minute := int(value.substr(3, 2))
	return hour >= 0 and hour <= 23 and minute >= 0 and minute <= 59

func _update_narrative_context() -> void:
	if narrative_time_label == null:
		return
	narrative_time_label.text = narrative_day_short + " · " + narrative_time if narrative_day_short != "" and narrative_time != "" else narrative_time
	narrative_time_label.visible = narrative_time != ""

func _on_header_notification_dismiss_requested() -> void:
	header_notification_host.visible = false
	header_notification_dismiss_requested.emit()

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label
