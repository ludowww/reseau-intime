extends VBoxContainer

class_name PortraitConversationScreen

signal back_requested
signal choice_selected(choice: Dictionary)

const TIMELINE_SCRIPT := preload("res://scripts/ui/messages/MessageTimeline.gd")
const CHOICE_BAR_SCRIPT := preload("res://scripts/ui/messages/ChoiceBar.gd")

var PORTRAIT_THEME
var thread: Dictionary = {}
var characters: Dictionary = {}
var timeline
var choice_bar
var title_label: Label
var avatar_label: Label
var back_button: Button

func configure(thread_presentation: Dictionary, message_presentations: Array[Dictionary], choice_presentations: Array[Dictionary], character_presentations: Dictionary, portrait_theme, reading_position := -1, first_unread_message_id := "") -> void:
	thread = thread_presentation
	characters = character_presentations
	PORTRAIT_THEME = portrait_theme
	_build(message_presentations, choice_presentations, reading_position, first_unread_message_id)

func append_player_choice(choice: Dictionary) -> void:
	timeline.append_player_choice(choice)
	choice_bar.clear_choices()
	back_button.call_deferred("grab_focus")

func append_incoming_message(message: Dictionary) -> void:
	timeline.append_incoming_message(message)

func show_typing(author: Dictionary, reduced_motion: bool) -> void:
	timeline.show_typing(author, reduced_motion)

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
		"has_horizontal_crop": timeline.has_horizontal_crop() or choice_bar.has_horizontal_crop(),
	}

func _build(message_presentations: Array[Dictionary], choice_presentations: Array[Dictionary], reading_position: int, first_unread_message_id: String) -> void:
	for child in get_children():
		child.queue_free()
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 10)
	var header := PanelContainer.new()
	header.name = "ConversationHeader"
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE_RAISED, 1, 18))
	add_child(header)
	var header_row := HBoxContainer.new()
	header_row.add_theme_constant_override("separation", 10)
	header.add_child(header_row)
	back_button = Button.new()
	back_button.name = "Back"
	back_button.text = "←"
	back_button.tooltip_text = "Retour aux conversations"
	back_button.custom_minimum_size = Vector2(52, 52)
	back_button.focus_mode = Control.FOCUS_ALL
	back_button.add_theme_font_size_override("font_size", 22)
	back_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.08, 0.10, 0.17), PORTRAIT_THEME.BORDER, 18))
	back_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	back_button.pressed.connect(func(): back_requested.emit())
	header_row.add_child(back_button)
	var accent := Color.from_string(str(thread.get("accent_color", "#8D63E6")), PORTRAIT_THEME.PLAYER_ACCENT)
	avatar_label = _label(str(thread.get("avatar_ref", "?")), 20, accent)
	avatar_label.name = "Avatar"
	avatar_label.custom_minimum_size = Vector2(46, 46)
	avatar_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	avatar_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	avatar_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	avatar_label.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.06, 0.08, 0.14), accent, 23))
	header_row.add_child(avatar_label)
	title_label = _label(str(thread.get("title", "Conversation")), 23, PORTRAIT_THEME.TEXT_PRIMARY)
	title_label.name = "ConversationName"
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	header_row.add_child(title_label)
	timeline = TIMELINE_SCRIPT.new()
	timeline.name = "MessageTimeline"
	add_child(timeline)
	timeline.configure(message_presentations, characters, bool(thread.get("is_group", false)), PORTRAIT_THEME, reading_position, first_unread_message_id)
	choice_bar = CHOICE_BAR_SCRIPT.new()
	choice_bar.name = "ChoiceBar"
	add_child(choice_bar)
	choice_bar.choice_selected.connect(func(choice: Dictionary): choice_selected.emit(choice))
	choice_bar.configure(choice_presentations, PORTRAIT_THEME)

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label
