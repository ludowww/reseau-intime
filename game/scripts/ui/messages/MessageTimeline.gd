extends ScrollContainer

class_name MessageTimeline

signal image_requested(message_id: String, media_ref: String)

const UNREAD_DIVIDER_SCRIPT := preload("res://scripts/ui/messages/UnreadDivider.gd")
const TYPING_INDICATOR_SCRIPT := preload("res://scripts/ui/messages/TypingIndicator.gd")
const DAY_DIVIDER_SCRIPT := preload("res://scripts/ui/messages/DayDivider.gd")
const IMAGE_MESSAGE_SCRIPT := preload("res://scripts/ui/messages/ImageMessage.gd")

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
var image_messages: Array = []
var image_request_total := 0
var last_requested_message_id := ""
var last_requested_media_ref := ""
var divider_count := 0
var typing_indicator
var reading_position_restore_pending := false
var reading_restore_request_id := 0
var typing_follow_request_id := 0
var layout_follow_request_id := 0
var replacement_spacer: Control
var replacement_spacer_request_id := 0
var replacement_layout_anchor_request_id := 0
var replacement_spacer_created_total := 0
var replacement_spacer_removed_total := 0

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

func append_incoming_message(message: Dictionary, force_follow := false) -> void:
	messages.append(message.duplicate(true))
	message_box.add_child(_build_message_bubble(messages[-1]))
	if typing_indicator != null and is_instance_valid(typing_indicator):
		message_box.move_child(typing_indicator, message_box.get_child_count() - 1)
	if force_follow:
		scroll_to_last_message_after_layout(true)
	else:
		call_deferred("scroll_to_last_message")

func replace_typing_with_message(message: Dictionary, force_follow := true) -> void:
	# Atomic exchange: no await occurs between inserting the bubble and removing typing.
	if typing_indicator == null or not is_instance_valid(typing_indicator):
		append_incoming_message(message, force_follow)
		return
	typing_follow_request_id += 1
	var typing_index: int = typing_indicator.get_index()
	var outgoing_indicator: Control = typing_indicator
	var outgoing_height: float = outgoing_indicator.size.y
	outgoing_indicator.stop_animation()
	var stored_message := message.duplicate(true)
	var message_bubble := _build_message_bubble(stored_message)
	var message_height: float = message_bubble.get_combined_minimum_size().y
	var preserve_first_layout: bool = force_follow and is_last_message_visible() and outgoing_height > message_height
	if force_follow:
		replacement_layout_anchor_request_id += 1
		var anchor_request_id := replacement_layout_anchor_request_id
		get_v_scroll_bar().changed.connect(_anchor_atomic_replacement_layout.bind(anchor_request_id), CONNECT_ONE_SHOT)
	message_box.add_child(message_bubble)
	message_box.move_child(message_bubble, typing_index)
	messages.append(stored_message)
	if preserve_first_layout:
		_create_replacement_spacer(outgoing_height, typing_index + 1)
	if outgoing_indicator.get_parent() == message_box:
		message_box.remove_child(outgoing_indicator)
	outgoing_indicator.queue_free()
	typing_indicator = null
	if force_follow:
		scroll_to_last_message()

func _anchor_atomic_replacement_layout(request_id: int) -> void:
	if request_id != replacement_layout_anchor_request_id or reading_position_restore_pending or not is_inside_tree():
		return
	scroll_to_last_message()

func _create_replacement_spacer(outgoing_height: float, insert_index: int) -> void:
	_remove_replacement_spacer()
	replacement_spacer_request_id += 1
	var request_id := replacement_spacer_request_id
	replacement_spacer = Control.new()
	replacement_spacer.name = "ReplacementSpacer"
	replacement_spacer.custom_minimum_size = Vector2(0.0, outgoing_height)
	replacement_spacer.focus_mode = Control.FOCUS_NONE
	replacement_spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	replacement_spacer_created_total += 1
	message_box.add_child(replacement_spacer)
	message_box.move_child(replacement_spacer, mini(insert_index, message_box.get_child_count() - 1))
	_remove_replacement_spacer_after_stable_layout(request_id, replacement_spacer)

func _remove_replacement_spacer_after_stable_layout(request_id: int, expected_spacer: Control) -> void:
	await get_tree().process_frame
	if request_id != replacement_spacer_request_id or expected_spacer != replacement_spacer:
		return
	await get_tree().process_frame
	if request_id != replacement_spacer_request_id or expected_spacer != replacement_spacer:
		return
	_remove_replacement_spacer()

func _remove_replacement_spacer() -> void:
	if replacement_spacer == null or not is_instance_valid(replacement_spacer):
		replacement_spacer = null
		return
	if replacement_spacer.get_parent() != null:
		replacement_spacer.get_parent().remove_child(replacement_spacer)
	replacement_spacer.queue_free()
	replacement_spacer = null
	replacement_spacer_removed_total += 1

func replacement_spacer_active() -> bool:
	return replacement_spacer != null and is_instance_valid(replacement_spacer)

func replacement_spacer_count() -> int:
	return 1 if replacement_spacer_active() else 0

func replacement_spacer_height() -> float:
	return replacement_spacer.custom_minimum_size.y if replacement_spacer_active() else 0.0

func replacement_spacer_created_count() -> int:
	return replacement_spacer_created_total

func replacement_spacer_removed_count() -> int:
	return replacement_spacer_removed_total

func show_typing(author: Dictionary, reduced_motion: bool, force_follow := false, speed_multiplier := 1.0) -> void:
	var should_follow_bottom := force_follow or (not reading_position_restore_pending and is_last_message_visible())
	typing_follow_request_id += 1
	var request_id := typing_follow_request_id
	if typing_indicator == null or not is_instance_valid(typing_indicator):
		typing_indicator = TYPING_INDICATOR_SCRIPT.new()
		message_box.add_child(typing_indicator)
	typing_indicator.configure(author, is_group, PORTRAIT_THEME, reduced_motion, speed_multiplier)
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

func day_divider_count() -> int:
	var count := 0
	if message_box == null:
		return count
	for child in message_box.get_children():
		if _is_day_divider(child):
			count += 1
	return count

func day_divider_labels() -> Array[String]:
	var labels: Array[String] = []
	if message_box == null:
		return labels
	for child in message_box.get_children():
		if _is_day_divider(child):
			labels.append(str(child.display_text()))
	return labels

func message_bubble_count() -> int:
	var count := 0
	if message_box == null:
		return count
	for child in message_box.get_children():
		if _is_message_bubble(child):
			count += 1
	return count

func image_message_count() -> int:
	return image_messages.size()

func image_message_ids() -> Array[String]:
	var ids: Array[String] = []
	for image_message in image_messages:
		ids.append(str(image_message.message_id))
	return ids

func image_message_with_caption_count() -> int:
	var count := 0
	for image_message in image_messages:
		if bool(image_message.has_caption()):
			count += 1
	return count

func image_message_without_caption_count() -> int:
	return image_message_count() - image_message_with_caption_count()

func focused_image_message_id() -> String:
	for image_message in image_messages:
		if bool(image_message.image_has_focus()):
			return str(image_message.message_id)
	return ""

func image_request_count() -> int:
	return image_request_total

func focus_first_image() -> void:
	if not image_messages.is_empty():
		image_messages[0].focus_image()

func focus_image_message(message_id: String) -> bool:
	for image_message in image_messages:
		if str(image_message.message_id) == message_id:
			image_message.focus_image()
			return true
	return false

func activate_first_image() -> void:
	if not image_messages.is_empty():
		image_messages[0].image_button.emit_signal("pressed")

func image_ratio() -> float:
	return float(image_messages[0].image_ratio()) if not image_messages.is_empty() else 0.0

func minimum_image_target() -> Vector2:
	return Vector2(image_messages[0].minimum_target()) if not image_messages.is_empty() else Vector2.ZERO

func image_has_caption() -> bool:
	return not image_messages.is_empty() and bool(image_messages[0].has_caption())

func image_caption() -> String:
	return str(image_messages[0].displayed_caption()) if not image_messages.is_empty() else ""

func image_animation_running() -> bool:
	return image_messages.any(func(image_message): return bool(image_message.animation_running()))

func last_image_request() -> Dictionary:
	return {
		"message_id": last_requested_message_id,
		"media_ref": last_requested_media_ref,
	}

func day_divider_has_timestamp() -> bool:
	return _day_divider_has_named_descendant("Timestamp")

func day_divider_has_author() -> bool:
	return _day_divider_has_named_descendant("Author")

func day_divider_precedes_unread_divider() -> bool:
	if message_box == null:
		return false
	var children := message_box.get_children()
	for index in range(children.size()):
		if children[index].get_script() == UNREAD_DIVIDER_SCRIPT:
			return (
				index > 0
				and index + 1 < children.size()
				and _is_day_divider(children[index - 1])
				and _is_message_bubble(children[index + 1])
			)
	return false

func unread_divider_count() -> int:
	return divider_count

func get_reading_position() -> int:
	return scroll_vertical

func set_reading_position(value: int) -> void:
	scroll_vertical = clampi(value, 0, int(get_v_scroll_bar().max_value))

func scroll_to_last_message() -> void:
	scroll_vertical = int(get_v_scroll_bar().max_value)

func scroll_to_last_message_after_layout(force_follow := true) -> bool:
	layout_follow_request_id += 1
	return await _follow_last_message_after_layout(layout_follow_request_id, force_follow)

func _follow_last_message_after_layout(request_id: int, force_follow: bool) -> bool:
	if not force_follow or reading_position_restore_pending:
		return false
	await get_tree().process_frame
	if request_id != layout_follow_request_id or not is_inside_tree():
		return false
	var first_max := get_v_scroll_bar().max_value
	await get_tree().process_frame
	if request_id != layout_follow_request_id or not is_inside_tree():
		return false
	var second_max := get_v_scroll_bar().max_value
	if not is_equal_approx(first_max, second_max):
		await get_tree().process_frame
		if request_id != layout_follow_request_id or not is_inside_tree():
			return false
	scroll_to_last_message()
	if not is_last_message_visible():
		scroll_to_last_message()
	return is_last_message_visible()

func is_last_message_visible() -> bool:
	var bar := get_v_scroll_bar()
	return bar.max_value <= bar.page + 1.0 or scroll_vertical + bar.page >= bar.max_value - 2.0

func bottom_gap() -> float:
	var bar := get_v_scroll_bar()
	return maxf(0.0, bar.max_value - bar.page - float(scroll_vertical))

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
	for image_message in image_messages:
		if bool(image_message.has_horizontal_crop()):
			return true
	if message_box != null:
		for child in message_box.get_children():
			if _is_day_divider(child) and bool(child.has_horizontal_crop()):
				return true
	return false

func _day_divider_has_named_descendant(node_name: String) -> bool:
	if message_box == null:
		return false
	for child in message_box.get_children():
		if _is_day_divider(child) and child.find_child(node_name, true, false) != null:
			return true
	return false

func _is_day_divider(node: Node) -> bool:
	return node.get_script() == DAY_DIVIDER_SCRIPT

func _is_message_bubble(node: Node) -> bool:
	return bool(node.get_meta("message_bubble", false))

func _build() -> void:
	replacement_spacer_request_id += 1
	_remove_replacement_spacer()
	if typing_indicator != null and is_instance_valid(typing_indicator):
		typing_indicator.stop_animation()
	typing_indicator = null
	for child in get_children():
		child.queue_free()
	wrapped_labels.clear()
	group_author_labels.clear()
	group_author_avatars.clear()
	incoming_accents.clear()
	image_messages.clear()
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
		if str(message.get("content_type", "")) == "SYSTEM_DAY_DIVIDER":
			var day_divider = DAY_DIVIDER_SCRIPT.new()
			day_divider.configure(str(message.get("text", "")), PORTRAIT_THEME)
			message_box.add_child(day_divider)
			continue
		if str(message.get("content_type", "")) == "OFF_PHONE_TRANSITION":
			continue
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
	row.set_meta("message_bubble", true)
	row.set_meta("message_id", str(message.get("message_id", "")))
	row.set_meta("content_type", str(message.get("content_type", "")))
	row.set_meta("is_player", bool(message.get("is_player", false)))
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var content_type := str(message.get("content_type", ""))
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
	author_label.visible = is_group and not is_player
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
	if content_type == "IMAGE":
		var image_message = IMAGE_MESSAGE_SCRIPT.new()
		image_message.name = "ImageMessage"
		image_message.configure(
			str(message.get("message_id", "")),
			str(message.get("media_ref", "")),
			str(message.get("text", "")),
			accent,
			PORTRAIT_THEME,
			str(message.get("placeholder_label", "Photo de démonstration")),
		)
		image_message.image_requested.connect(func(requested_message_id: String, requested_media_ref: String):
			image_request_total += 1
			last_requested_message_id = requested_message_id
			last_requested_media_ref = requested_media_ref
			image_requested.emit(requested_message_id, requested_media_ref)
		)
		image_messages.append(image_message)
		column.add_child(image_message)
	else:
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

func visible_player_author_count() -> int:
	var count := 0
	for row in message_box.get_children():
		if not row.has_meta("message_bubble"):
			continue
		if not bool(row.get_meta("is_player", false)):
			continue
		var author_label := row.find_child("Author", true, false)
		if author_label != null and author_label.visible:
			count += 1
	return count

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	wrapped_labels.append(label)
	return label
