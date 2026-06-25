extends VBoxContainer

signal choice_selected(choice: Dictionary)
signal segment_changed(day_value, conversation_id: String, segment_id: String)

const BACKGROUND_COLOR := Color(0.05, 0.06, 0.09)
const HEADER_COLOR := Color(0.09, 0.10, 0.14)
const INCOMING_BUBBLE_COLOR := Color(0.16, 0.16, 0.21)
const LUDO_BUBBLE_COLOR := Color(0.20, 0.29, 0.38)
const CHOICE_COLOR := Color(0.13, 0.15, 0.20)
const PLACEHOLDER_COLOR := Color(0.12, 0.10, 0.15)
const CHARACTER_BUBBLE_COLORS := {
	"ludo": Color(0.20, 0.29, 0.38),
	"marie": Color(0.42, 0.25, 0.36),
	"mathilde": Color(0.34, 0.18, 0.31),
	"sandra": Color(0.22, 0.22, 0.34),
	"raphaelle": Color(0.20, 0.38, 0.42),
	"raphaëlle": Color(0.20, 0.38, 0.42),
	"pauline": Color(0.42, 0.12, 0.22),
	"nico": Color(0.32, 0.36, 0.20),
	"groupe amis": Color(0.30, 0.25, 0.18),
}

var choice_buttons: Array[Button] = []
var choice_was_applied := false
var current_conversation: Dictionary = {}
var current_segment_index := 0
var message_thread: VBoxContainer
var choice_area: VBoxContainer
var chat_shell: VBoxContainer

func show_conversation(conversation: Dictionary) -> void:
	_clear()
	current_conversation = conversation.duplicate(true)
	current_segment_index = int(current_conversation.get("_current_segment_index", 0))
	custom_minimum_size = Vector2(600, 0)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build_chat_shell()
	_add_chat_header(current_conversation)
	_render_current_segment()

func _build_chat_shell() -> void:
	var background := PanelContainer.new()
	background.add_theme_stylebox_override("panel", _panel_style(BACKGROUND_COLOR, 18))
	background.custom_minimum_size = Vector2(600, 680)
	background.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	background.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(background)

	chat_shell = VBoxContainer.new()
	chat_shell.add_theme_constant_override("separation", 10)
	chat_shell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chat_shell.size_flags_vertical = Control.SIZE_EXPAND_FILL
	background.add_child(chat_shell)

	message_thread = VBoxContainer.new()
	message_thread.add_theme_constant_override("separation", 8)
	message_thread.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	message_thread.size_flags_vertical = Control.SIZE_EXPAND_FILL
	chat_shell.add_child(message_thread)

	choice_area = VBoxContainer.new()
	choice_area.add_theme_constant_override("separation", 8)
	choice_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chat_shell.add_child(choice_area)

func _add_chat_header(conversation: Dictionary) -> void:
	var header_panel := PanelContainer.new()
	header_panel.add_theme_stylebox_override("panel", _panel_style(HEADER_COLOR, 16))
	header_panel.custom_minimum_size = Vector2(0, 68)
	header_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chat_shell.add_child(header_panel)
	chat_shell.move_child(header_panel, 0)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 10)
	header_panel.add_child(header)

	var avatar_card := PanelContainer.new()
	avatar_card.custom_minimum_size = Vector2(48, 48)
	avatar_card.add_theme_stylebox_override("panel", _panel_style(Color(0.24, 0.20, 0.30), 24))
	header.add_child(avatar_card)
	var avatar_placeholder := Label.new()
	avatar_placeholder.text = _avatar_initial(conversation)
	avatar_placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	avatar_placeholder.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	avatar_placeholder.add_theme_font_size_override("font_size", 18)
	avatar_card.add_child(avatar_placeholder)

	var title_box := VBoxContainer.new()
	title_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title_box)

	var name := Label.new()
	name.text = _conversation_name(conversation)
	name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	name.add_theme_font_size_override("font_size", 18)
	title_box.add_child(name)

	var status := Label.new()
	status.text = _conversation_status(conversation)
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	status.add_theme_font_size_override("font_size", 12)
	status.add_theme_color_override("font_color", Color(0.72, 0.75, 0.82))
	title_box.add_child(status)

func _render_current_segment() -> void:
	choice_buttons.clear()
	choice_was_applied = false
	_clear_node(choice_area)
	var data := _current_segment_data()
	for item in _flatten_content(data):
		_render_item(item)
	_show_choices_for_segment(data)

func _show_choices_for_segment(data: Dictionary, show_empty_hint := true) -> bool:
	choice_buttons.clear()
	choice_was_applied = false
	_clear_node(choice_area)
	var choices := _collect_choices(data)
	if choices.is_empty():
		if show_empty_hint:
			_add_choice_hint("Aucun choix direct dans cette conversation.")
		return false
	var is_guided_reply := choices.size() == 1
	_add_choice_heading("Réponse" if is_guided_reply else "Choix disponibles")
	for choice in choices:
		if is_guided_reply:
			choice["_guided_reply"] = true
		var button := Button.new()
		button.text = str(choice.get("text", choice.get("id", "Choix")))
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.custom_minimum_size = Vector2(0, 48)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.add_theme_stylebox_override("normal", _panel_style(CHOICE_COLOR, 18))
		button.add_theme_stylebox_override("hover", _panel_style(Color(0.18, 0.21, 0.28), 18))
		button.add_theme_stylebox_override("pressed", _panel_style(Color(0.20, 0.29, 0.38), 18))
		button.pressed.connect(func(): _select_choice(choice, button))
		choice_buttons.append(button)
		choice_area.add_child(button)
	return true

func append_choice_result(choice: Dictionary) -> void:
	_append_ludo_reply(choice)
	_clear_node(choice_area)
	await _play_followup_sequence(choice)
	await _auto_advance_segments_until_choice()

func _play_followup_sequence(choice: Dictionary) -> void:
	for key in ["next_messages", "next_items", "automatic_followup"]:
		for entry in choice.get(key, []):
			await _render_item_with_typing(entry)

func _auto_advance_segments_until_choice() -> void:
	while _has_next_segment():
		current_segment_index += 1
		_add_timeline_separator()
		segment_changed.emit(current_conversation.get("day", current_conversation.get("chapter", null)), _parent_conversation_id(), _segment_id_for_current_index())
		var data := _current_segment_data()
		await _render_segment_messages_with_typing(data)
		var has_more_segments := _has_next_segment()
		if _show_choices_for_segment(data, not has_more_segments):
			return

func _render_segment_messages_with_typing(data: Dictionary) -> void:
	_clear_node(choice_area)
	for item in _flatten_content(data):
		await _render_item_with_typing(item)

func _current_segment_data() -> Dictionary:
	var segments: Array = current_conversation.get("segments", [])
	if segments.is_empty():
		return current_conversation
	var index = clamp(current_segment_index, 0, segments.size() - 1)
	var segment: Dictionary = segments[index].duplicate(true)
	segment["title"] = current_conversation.get("title", current_conversation.get("id", "Conversation"))
	return segment

func _has_next_segment() -> bool:
	var segments: Array = current_conversation.get("segments", [])
	return current_segment_index + 1 < segments.size()

func _parent_conversation_id() -> String:
	return str(current_conversation.get("_parent_conversation_id", current_conversation.get("id", "")))

func _segment_id_for_current_index() -> String:
	return "%s__segment_%d" % [_parent_conversation_id(), current_segment_index + 1]

func _append_ludo_reply(choice: Dictionary) -> void:
	_render_chat_bubble({"sender": "ludo", "text": choice.get("text", choice.get("id", ""))})

func _is_guided_reply(choice: Dictionary) -> bool:
	return bool(choice.get("_guided_reply", false))

func _select_choice(choice: Dictionary, selected_button: Button) -> void:
	if choice_was_applied:
		return
	choice_was_applied = true
	for button in choice_buttons:
		button.disabled = true
	_clear_node(choice_area)
	choice_selected.emit(choice)

func _render_item_with_typing(item) -> void:
	if typeof(item) != TYPE_DICTIONARY:
		return
	if item.has("messages"):
		for message in item.get("messages", []):
			await _render_message_with_typing(message)
	if item.has("social_items"):
		for social_item in item.get("social_items", []):
			await _render_item_with_typing(social_item)
	if item.has("incoming_notifications"):
		for notification in item.get("incoming_notifications", []):
			await _render_item_with_typing(notification)
	if item.has("automatic_followup"):
		for followup in item.get("automatic_followup", []):
			await _render_item_with_typing(followup)
	if item.has("text") or item.has("body") or item.has("content_id") or item.has("reaction"):
		await _render_message_with_typing(item)
	elif not item.has("messages") and not item.has("social_items"):
		_add_system_note("[debug item] %s" % str(item.get("id", item.keys())))

func _render_message_with_typing(message: Dictionary) -> void:
	if not _is_ludo_sender(message):
		var typing_indicator := _show_typing_indicator(message)
		await get_tree().create_timer(_typing_delay_for_message(message)).timeout
		if is_instance_valid(typing_indicator):
			typing_indicator.queue_free()
	_render_message(message)

func _show_typing_indicator(message: Dictionary) -> Node:
	var typing_message := message.duplicate(true)
	typing_message["text"] = "..."
	return _render_chat_bubble(typing_message)

func _typing_delay_for_message(message: Dictionary) -> float:
	var char_count := _format_message_text(message).length()
	var delay := 0.35 + char_count * 0.018
	return clamp(delay, 0.45, 2.4)

func _flatten_content(conversation: Dictionary) -> Array:
	var items: Array = []
	for key in ["messages", "segments", "beats", "social_items", "incoming_notifications", "conditional_aftershocks", "conditional_proofs", "conditional_closers"]:
		for entry in conversation.get(key, []):
			items.append(entry)
	for key in ["default_aftershock", "default_proof", "default_closer"]:
		if conversation.has(key):
			items.append(conversation[key])
	return items

func _collect_choices(conversation: Dictionary) -> Array:
	var choices: Array = []
	for key in ["choices", "priority_choices"]:
		choices.append_array(conversation.get(key, []))
	for container_key in ["beats", "segments"]:
		for entry in conversation.get(container_key, []):
			if typeof(entry) == TYPE_DICTIONARY:
				choices.append_array(entry.get("choices", []))
				choices.append_array(entry.get("priority_choices", []))
	if typeof(conversation.get("branches", {})) == TYPE_DICTIONARY:
		for branch in conversation.get("branches", {}).values():
			if typeof(branch) == TYPE_DICTIONARY:
				choices.append_array(branch.get("choices", []))
				choices.append_array(branch.get("priority_choices", []))
	return choices

func _render_item(item) -> void:
	if typeof(item) != TYPE_DICTIONARY:
		return
	if item.has("messages"):
		for message in item.get("messages", []):
			_render_message(message)
	if item.has("social_items"):
		for social_item in item.get("social_items", []):
			_render_item(social_item)
	if item.has("incoming_notifications"):
		for notification in item.get("incoming_notifications", []):
			_render_item(notification)
	if item.has("automatic_followup"):
		for followup in item.get("automatic_followup", []):
			_render_item(followup)
	if item.has("text") or item.has("body") or item.has("content_id") or item.has("reaction"):
		_render_message(item)
	elif not item.has("messages") and not item.has("social_items"):
		_add_system_note("[debug item] %s" % str(item.get("id", item.keys())))

func _render_message(message: Dictionary) -> void:
	var text := _format_message_text(message)
	if text != "":
		_render_chat_bubble(message)
	if message.has("content_id"):
		_add_placeholder_card(str(message["content_id"]), _is_ludo_sender(message))

func _render_chat_bubble(message: Dictionary) -> Node:
	var is_ludo := _is_ludo_sender(message)
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.alignment = BoxContainer.ALIGNMENT_END if is_ludo else BoxContainer.ALIGNMENT_BEGIN
	message_thread.add_child(row)

	var bubble := PanelContainer.new()
	bubble.custom_minimum_size = Vector2(180, 0)
	bubble.size_flags_horizontal = Control.SIZE_SHRINK_END if is_ludo else Control.SIZE_SHRINK_BEGIN
	bubble.add_theme_stylebox_override("panel", _bubble_style(_bubble_color_for_sender(message), is_ludo))
	row.add_child(bubble)

	var text_box := VBoxContainer.new()
	text_box.add_theme_constant_override("separation", 4)
	bubble.add_child(text_box)

	var sender := str(message.get("sender", message.get("author", "")))
	if sender != "" and not is_ludo:
		var sender_label := Label.new()
		sender_label.text = sender.capitalize()
		sender_label.add_theme_font_size_override("font_size", 11)
		sender_label.add_theme_color_override("font_color", Color(0.77, 0.72, 0.90))
		text_box.add_child(sender_label)

	var label := Label.new()
	label.text = _format_message_text(message)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(160, 0)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 15)
	text_box.add_child(label)
	return row

func _format_message_text(message: Dictionary) -> String:
	var text := str(message.get("text", message.get("body", message.get("reaction", ""))))
	if text == "":
		return ""
	if message.has("time_label"):
		return "[%s] %s" % [message["time_label"], text]
	return text

func _is_ludo_sender(message: Dictionary) -> bool:
	var sender := str(message.get("sender", message.get("author", ""))).to_lower()
	return sender == "ludo" or sender == "player" or sender == "joueur"

func _bubble_color_for_sender(message: Dictionary) -> Color:
	var sender := _sender_display_name(message).to_lower()
	if sender == "":
		sender = _conversation_name(current_conversation).to_lower()
	if CHARACTER_BUBBLE_COLORS.has(sender):
		return CHARACTER_BUBBLE_COLORS[sender]
	if sender.contains("groupe") or sender.contains("amis"):
		return CHARACTER_BUBBLE_COLORS["groupe amis"]
	return LUDO_BUBBLE_COLOR if _is_ludo_sender(message) else INCOMING_BUBBLE_COLOR

func _sender_display_name(message: Dictionary) -> String:
	return str(message.get("sender", message.get("author", "")))

func _add_placeholder_card(content_id: String, is_ludo := false) -> void:
	var item := DataLoader.get_visual_content(content_id)
	var tags := ", ".join(item.get("tags", [])) if not item.is_empty() else "unknown"
	var risk := str(item.get("risk_level", "?")) if not item.is_empty() else "?"
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.alignment = BoxContainer.ALIGNMENT_END if is_ludo else BoxContainer.ALIGNMENT_BEGIN
	message_thread.add_child(row)

	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(300, 120)
	card.add_theme_stylebox_override("panel", _bubble_style(PLACEHOLDER_COLOR, is_ludo))
	row.add_child(card)

	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 6)
	card.add_child(body)
	_add_label_to(body, "[Image placeholder]", 14)
	_add_label_to(body, "ID : %s" % content_id, 12)
	_add_label_to(body, "Tags : %s" % tags, 12)
	_add_label_to(body, "Risque : %s" % risk, 12)
	GameState.add_unlocked_content(content_id)

func _add_choice_heading(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color(0.86, 0.88, 0.94))
	choice_area.add_child(label)

func _add_choice_hint(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.65, 0.67, 0.72))
	choice_area.add_child(label)

func _add_system_note(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.62, 0.64, 0.70))
	message_thread.add_child(label)

func _add_timeline_separator() -> void:
	_add_system_note("—")

func _conversation_name(conversation: Dictionary) -> String:
	var thread = conversation.get("thread", {})
	if typeof(thread) == TYPE_DICTIONARY and str(thread.get("display_name", "")) != "":
		return str(thread.get("display_name"))
	return str(conversation.get("title", conversation.get("id", "Conversation")))

func _conversation_status(conversation: Dictionary) -> String:
	var parts: Array[String] = []
	if str(conversation.get("moment_label", "")) != "":
		parts.append(str(conversation.get("moment_label")))
	if str(conversation.get("time_label", "")) != "":
		parts.append(str(conversation.get("time_label")))
	if parts.is_empty():
		parts.append("En ligne")
	return " / ".join(parts)

func _avatar_initial(conversation: Dictionary) -> String:
	var name := _conversation_name(conversation)
	if name == "":
		return "?"
	return name.substr(0, 1).to_upper()

func _panel_style(color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style

func _bubble_style(color: Color, is_ludo: bool) -> StyleBoxFlat:
	var style := _panel_style(color, 18)
	if is_ludo:
		style.corner_radius_bottom_right = 6
	else:
		style.corner_radius_bottom_left = 6
	return style

func _add_label_to(parent: Node, text: String, size: int = 14) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(label)

func _clear() -> void:
	for child in get_children():
		child.queue_free()

func _clear_node(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
