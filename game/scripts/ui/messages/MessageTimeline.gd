extends ScrollContainer

class_name MessageTimeline

const UNREAD_DIVIDER_SCRIPT := preload("res://scripts/ui/messages/UnreadDivider.gd")
const TYPING_INDICATOR_SCRIPT := preload("res://scripts/ui/messages/TypingIndicator.gd")

var PORTRAIT_THEME
var characters: Dictionary = {}
var is_group := false
var messages: Array[Dictionary] = []
var first_unread_message_id := ""
var message_box: VBoxContainer
var wrapped_labels: Array[Label] = []
var group_author_labels: Array[Label] = []
var group_author_avatars: Array[Label] = []
var incoming_accents: Array[Color] = []
var divider_count := 0
var typing_indicator
var reading_position_restore_pending := false
var reading_restore_request_id := 0
var typing_follow_request_id := 0

func configure(message_presentations: Array[Dictionary], character_presentations: Dictionary, group_conversation: bool, portrait_theme, reading_position := -1, first_unread_id := "") -> void:
	messages = message_presentations
	characters = character_presentations
	is_group = group_conversation
	PORTRAIT_THEME = portrait_theme
	first_unread_message_id = first_unread_id
	reading_restore_request_id += 1
	typing_follow_request_id += 1
	reading_position_restore_pending = reading_position >= 0
	_build()
	if reading_position >= 0:
		_restore_reading_position_after_layout(reading_position, reading_restore_request_id)
	else:
		reading_position_restore_pending = false
		call_deferred("scroll_to_last_message")

func _restore_reading_position_after_layout(value: int, request_id: int) -> void:
	await get_tree().process_frame
	if request_id != reading_restore_request_id or not is_inside_tree():
		return
	if message_box == null or not is_instance_valid(message_box):
		return
	set_reading_position(value)
	reading_position_restore_pending = false

func append_player_choice(choice: Dictionary) -> void:
	messages.append({
		"message_id": "demo_player_%d" % messages.size(),
		"author_id": "player",
		"timestamp": "maintenant",
		"content_type": "TEXT",
		"text": str(choice.get("text", "")),
		"media_ref": "",
		"is_player": true,
		"is_read": true,
		"source_day": 0,
	})
	message_box.add_child(_build_message_bubble(messages[-1]))
	call_deferred("scroll_to_last_message")

func append_incoming_message(message: Dictionary) -> void:
	messages.append(message.duplicate(true))
	message_box.add_child(_build_message_bubble(messages[-1]))
	if typing_indicator != null and is_instance_valid(typing_indicator):
		message_box.move_child(typing_indicator, message_box.get_child_count() - 1)
	call_deferred("scroll_to_last_message")

func show_typing(author: Dictionary, reduced_motion: bool) -> void:
	var should_follow_bottom := not reading_position_restore_pending and is_last_message_visible()
	typing_follow_request_id += 1
	var request_id := typing_follow_request_id
	if typing_indicator == null or not is_instance_valid(typing_indicator):
		typing_indicator = TYPING_INDICATOR_SCRIPT.new()
		message_box.add_child(typing_indicator)
	typing_indicator.configure(author, is_group, PORTRAIT_THEME, reduced_motion)
	message_box.move_child(typing_indicator, message_box.get_child_count() - 1)
	_follow_typing_after_layout(should_follow_bottom, request_id, typing_indicator)

func _follow_typing_after_layout(should_follow_bottom: bool, request_id: int, expected_indicator) -> void:
	await get_tree().process_frame
	if not should_follow_bottom or reading_position_restore_pending:
		return
	if request_id != typing_follow_request_id or not is_inside_tree():
		return
	if message_box == null or not is_instance_valid(message_box):
		return
	if expected_indicator != typing_indicator or not is_instance_valid(expected_indicator):
		return
	if expected_indicator.get_parent() != message_box:
		return
	scroll_to_last_message()

func hide_typing() -> void:
	typing_follow_request_id += 1
	if typing_indicator == null or not is_instance_valid(typing_indicator):
		typing_indicator = null
		return
	typing_indicator.stop_animation()
	if typing_indicator.get_parent() != null:
		typing_indicator.get_parent().remove_child(typing_indicator)
	typing_indicator.queue_free()
	typing_indicator = null

func typing_visible() -> bool:
	return typing_indicator != null and is_instance_valid(typing_indicator) and typing_indicator.is_visible_in_tree()

func typing_instance_count() -> int:
	if message_box == null:
		return 0
	var count := 0
	for child in message_box.get_children():
		if child == typing_indicator:
			count += 1
	return count

func typing_animation_running() -> bool:
	return typing_indicator != null and is_instance_valid(typing_indicator) and bool(typing_indicator.animation_running())

func advance_typing_phase() -> void:
	if typing_indicator != null and is_instance_valid(typing_indicator):
		typing_indicator.advance_typing_phase()

func typing_text() -> String:
	return str(typing_indicator.indicator_text()) if typing_indicator != null and is_instance_valid(typing_indicator) else ""

func typing_avatar() -> String:
	return str(typing_indicator.avatar_text()) if typing_indicator != null and is_instance_valid(typing_indicator) else ""

func typing_accent_visible() -> bool:
	return typing_indicator != null and is_instance_valid(typing_indicator) and bool(typing_indicator.accent_is_visible())

func typing_has_timestamp() -> bool:
	return typing_indicator != null and is_instance_valid(typing_indicator) and bool(typing_indicator.has_time_label())

func typing_is_last_item() -> bool:
	return typing_indicator != null and is_instance_valid(typing_indicator) and typing_indicator.get_index() == message_box.get_child_count() - 1

func player_message_count() -> int:
	var count := 0
	for message in messages:
		if bool(message.get("is_player", false)):
			count += 1
	return count

func message_count() -> int:
	return messages.size()

func unread_divider_count() -> int:
	return divider_count

func get_reading_position() -> int:
	return scroll_vertical

func set_reading_position(value: int) -> void:
	scroll_vertical = clampi(value, 0, int(get_v_scroll_bar().max_value))

func scroll_to_last_message() -> void:
	scroll_vertical = int(get_v_scroll_bar().max_value)

func is_last_message_visible() -> bool:
	var bar := get_v_scroll_bar()
	return bar.max_value <= bar.page + 1.0 or scroll_vertical + bar.page >= bar.max_value - 2.0

func reading_position_coherent() -> bool:
	return scroll_vertical >= 0 and scroll_vertical <= int(get_v_scroll_bar().max_value)

func group_author_visible() -> bool:
	return is_group and not group_author_labels.is_empty() and group_author_labels.all(func(label: Label): return label.visible and label.text != "")

func group_author_avatar_visible() -> bool:
	return is_group and not group_author_avatars.is_empty() and group_author_avatars.all(func(label: Label): return label.visible and label.text != "")

func group_author_accent_visible() -> bool:
	return is_group and incoming_accents.size() >= 2 and incoming_accents[0] != incoming_accents[1]

func has_horizontal_crop() -> bool:
	for label in wrapped_labels:
		if label.size.x > 0.0 and label.get_minimum_size().x > label.size.x + 1.0:
			return true
	return false

func _build() -> void:
	if typing_indicator != null and is_instance_valid(typing_indicator):
		typing_indicator.stop_animation()
	typing_indicator = null
	for child in get_children():
		child.queue_free()
	wrapped_labels.clear()
	group_author_labels.clear()
	group_author_avatars.clear()
	incoming_accents.clear()
	divider_count = 0
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	message_box = VBoxContainer.new()
	message_box.name = "MessageBubbles"
	message_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	message_box.add_theme_constant_override("separation", 10)
	add_child(message_box)
	for message in messages:
		if divider_count == 0 and first_unread_message_id != "" and str(message.get("message_id", "")) == first_unread_message_id:
			var divider = UNREAD_DIVIDER_SCRIPT.new()
			divider.configure(PORTRAIT_THEME)
			message_box.add_child(divider)
			divider_count = 1
		message_box.add_child(_build_message_bubble(message))

# MessageBubble keeps Player on the right and interlocutors on the left.
func _build_message_bubble(message: Dictionary) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "MessageBubble"
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var is_player := bool(message.get("is_player", false))
	var author_id := str(message.get("author_id", ""))
	var author: Dictionary = characters.get(author_id, {})
	var accent: Color = PORTRAIT_THEME.PLAYER_ACCENT if is_player else Color.from_string(str(author.get("accent_color", "#8D63E6")), PORTRAIT_THEME.PLAYER_ACCENT)
	if not is_player:
		incoming_accents.append(accent)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spacer.size_flags_stretch_ratio = 0.28
	var bubble := PanelContainer.new()
	bubble.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bubble.size_flags_stretch_ratio = 0.72
	bubble.add_theme_stylebox_override("panel", PORTRAIT_THEME.button_style(Color(0.12, 0.14, 0.23) if not is_player else Color(0.18, 0.13, 0.30), accent, 18))
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 4)
	bubble.add_child(column)
	var author_name := str(author.get("display_name", "Player" if is_player else "Contact"))
	var author_label := _label(author_name, 14, accent)
	author_label.name = "Author"
	author_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT if is_player else HORIZONTAL_ALIGNMENT_LEFT
	author_label.visible = is_player or is_group
	if is_group and not is_player:
		group_author_labels.append(author_label)
	if is_group:
		var author_row := HBoxContainer.new()
		author_row.add_theme_constant_override("separation", 6)
		var author_avatar := _label(str(author.get("avatar_ref", "?")), 12, accent)
		author_avatar.name = "GroupAuthorAvatar"
		author_avatar.custom_minimum_size = Vector2(28, 28)
		author_avatar.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		author_avatar.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		author_avatar.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.06, 0.08, 0.14), accent, 14))
		group_author_avatars.append(author_avatar)
		author_row.add_child(author_avatar)
		author_row.add_child(author_label)
		column.add_child(author_row)
	else:
		column.add_child(author_label)
	var body := _label(str(message.get("text", "")), 18, PORTRAIT_THEME.TEXT_PRIMARY)
	body.name = "Body"
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT if is_player else HORIZONTAL_ALIGNMENT_LEFT
	column.add_child(body)
	var timestamp := _label(str(message.get("timestamp", "")), 13, PORTRAIT_THEME.TEXT_MUTED)
	timestamp.name = "Timestamp"
	timestamp.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT if is_player else HORIZONTAL_ALIGNMENT_LEFT
	column.add_child(timestamp)
	if is_player:
		row.add_child(spacer)
		row.add_child(bubble)
	else:
		row.add_child(bubble)
		row.add_child(spacer)
	return row

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	wrapped_labels.append(label)
	return label
