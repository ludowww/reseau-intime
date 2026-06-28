extends VBoxContainer

signal choice_selected(choice: Dictionary)
signal segment_changed(day_value, conversation_id: String, segment_id: String)
signal conversation_completed(day_value, conversation_id: String)

const BACKGROUND_COLOR := Color(0.05, 0.06, 0.09)
const HEADER_COLOR := Color(0.09, 0.10, 0.14)
const INCOMING_BUBBLE_COLOR := Color(0.16, 0.16, 0.21)
const LUDO_BUBBLE_COLOR := Color(0.20, 0.29, 0.38)
const CHOICE_COLOR := Color(0.13, 0.15, 0.20)
const PLACEHOLDER_COLOR := Color(0.12, 0.10, 0.15)
const BUBBLE_MIN_WIDTH := 180
const BUBBLE_MAX_WIDTH := 520
const BUBBLE_CHAR_WIDTH := 7.2
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
var header_panel: PanelContainer
var message_scroll: ScrollContainer
var message_thread: VBoxContainer
var choice_area: VBoxContainer
var chat_shell: VBoxContainer
var conversation_states: Dictionary = {}
var active_conversation_id := ""
var current_render_token := 0
var active_state: Dictionary = {}
var restoring_state := false

func reset_ui_state() -> void:
	current_render_token += 1
	conversation_states.clear()
	active_conversation_id = ""
	active_state = {}
	current_conversation = {}
	current_segment_index = 0
	choice_buttons.clear()
	choice_was_applied = false
	_clear()

func show_conversation(conversation: Dictionary) -> void:
	current_render_token += 1
	var token := current_render_token
	var conversation_id := _conversation_key(conversation)
	active_conversation_id = conversation_id
	if not conversation_states.has(conversation_id):
		conversation_states[conversation_id] = _new_conversation_state(conversation)
	active_state = conversation_states[conversation_id]
	_merge_updated_conversation(conversation)
	current_conversation = active_state["conversation"]
	current_segment_index = int(active_state.get("current_segment_index", 0))
	choice_was_applied = bool(active_state.get("choice_was_applied", false))
	_clear()
	custom_minimum_size = Vector2(600, 0)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build_chat_shell()
	_add_chat_header(current_conversation)
	if bool(active_state.get("initialized", false)) and active_state.get("history", []).is_empty() and not bool(active_state.get("waiting_choices", false)) and not bool(active_state.get("choice_was_applied", false)):
		active_state["initialized"] = false
	if bool(active_state.get("initialized", false)):
		_restore_state_to_view(active_state)
		if bool(active_state.get("waiting_choices", false)):
			return
		if bool(active_state.get("sequence_complete", false)) and _has_next_segment():
			active_state["sequence_complete"] = false
			_auto_advance_segments_until_choice(conversation_id, token)
			return
		if bool(active_state.get("sequence_complete", false)):
			return
		if bool(active_state.get("sequence_in_progress", false)):
			_resume_incomplete_sequence(conversation_id, token)
			return
		return
	active_state["initialized"] = true
	_render_current_segment(conversation_id, token)

func _new_conversation_state(conversation: Dictionary) -> Dictionary:
	var segment_index := int(conversation.get("_current_segment_index", 0))
	return {
		"conversation": conversation.duplicate(true),
		"history": [],
		"rendered_message_keys": {},
		"current_segment_index": segment_index,
		"segment_index": segment_index,
		"segment_id": str(conversation.get("_current_segment_id", "%s__segment_%d" % [_conversation_key(conversation), segment_index + 1])),
		"message_index": 0,
		"followup_index": 0,
		"pending_followup_choice": {},
		"ludo_reply_recorded": false,
		"choice_was_applied": false,
		"waiting_choices": false,
		"choice_data": {},
		"show_empty_hint": true,
		"sequence_in_progress": false,
		"sequence_complete": false,
		"completion_emitted": false,
		"completion_emitted_ids": {},
		"render_phase": "segment",
		"initialized": false,
	}

func _merge_updated_conversation(conversation: Dictionary) -> void:
	var stored: Dictionary = active_state.get("conversation", {})
	var updated: Dictionary = conversation.duplicate(true)
	var stored_segments: Array = stored.get("segments", [])
	var updated_segments: Array = updated.get("segments", [])
	if updated_segments.size() >= stored_segments.size():
		active_state["conversation"] = updated
	else:
		active_state["conversation"] = stored

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

	message_scroll = ScrollContainer.new()
	message_scroll.follow_focus = true
	message_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	message_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	chat_shell.add_child(message_scroll)

	message_thread = VBoxContainer.new()
	message_thread.add_theme_constant_override("separation", 8)
	message_thread.custom_minimum_size = Vector2(BUBBLE_MAX_WIDTH + 48, 0)
	message_thread.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	message_thread.size_flags_vertical = Control.SIZE_EXPAND_FILL
	message_scroll.add_child(message_thread)

	choice_area = VBoxContainer.new()
	choice_area.add_theme_constant_override("separation", 8)
	choice_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	chat_shell.add_child(choice_area)

func _add_chat_header(conversation: Dictionary) -> void:
	header_panel = PanelContainer.new()
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

func _render_current_segment(conversation_id: String, token: int) -> void:
	choice_buttons.clear()
	choice_was_applied = false
	active_state["choice_was_applied"] = false
	active_state["waiting_choices"] = false
	active_state["sequence_complete"] = false
	active_state["sequence_in_progress"] = true
	active_state["render_phase"] = "segment"
	active_state["message_index"] = int(active_state.get("message_index", 0))
	_clear_node(choice_area)
	var data := _current_segment_data()
	await _render_segment_messages_with_typing(data, conversation_id, token)
	if not _is_render_current(conversation_id, token):
		return
	active_state["sequence_in_progress"] = false
	if not _show_choices_for_segment(data):
		active_state["sequence_complete"] = true
		_emit_conversation_completed_once()

func _show_choices_for_segment(data: Dictionary, show_empty_hint := true, persist_state := true) -> bool:
	choice_buttons.clear()
	if persist_state:
		choice_was_applied = false
		active_state["choice_was_applied"] = false
	_clear_node(choice_area)
	var choices := _collect_choices(data)
	if choices.is_empty():
		if show_empty_hint:
			_add_choice_hint("Aucun choix direct dans cette conversation.")
		if persist_state:
			active_state["waiting_choices"] = false
		return false
	if persist_state:
		active_state["waiting_choices"] = true
		active_state["choice_data"] = data.duplicate(true)
		active_state["show_empty_hint"] = show_empty_hint
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
	_scroll_to_bottom.call_deferred()
	return true

func append_choice_result(choice: Dictionary) -> void:
	var conversation_id := active_conversation_id
	var token := current_render_token
	active_state["pending_followup_choice"] = choice.duplicate(true)
	active_state["render_phase"] = "followup"
	active_state["sequence_in_progress"] = true
	active_state["sequence_complete"] = false
	if not bool(active_state.get("ludo_reply_recorded", false)):
		_append_ludo_reply(choice)
		active_state["ludo_reply_recorded"] = true
	active_state["waiting_choices"] = false
	_clear_node(choice_area)
	await _play_followup_sequence(choice, conversation_id, token)
	if not _is_render_current(conversation_id, token):
		return
	active_state["followup_index"] = 0
	active_state["pending_followup_choice"] = {}
	active_state["ludo_reply_recorded"] = false
	await _auto_advance_segments_until_choice(conversation_id, token)

func _play_followup_sequence(choice: Dictionary, conversation_id: String, token: int) -> void:
	var queue := _flatten_choice_followup_queue(choice)
	var start_index := int(active_state.get("followup_index", 0))
	for index in range(start_index, queue.size()):
		if not _is_render_current(conversation_id, token):
			return
		active_state["followup_index"] = index
		await _render_message_with_typing(queue[index], conversation_id, token)
		if not _is_render_current(conversation_id, token):
			return
		active_state["followup_index"] = index + 1

func _auto_advance_segments_until_choice(conversation_id: String, token: int) -> void:
	active_state["render_phase"] = "auto"
	while _has_next_segment():
		if not _is_render_current(conversation_id, token):
			return
		current_segment_index += 1
		active_state["current_segment_index"] = current_segment_index
		active_state["segment_index"] = current_segment_index
		active_state["segment_id"] = _segment_id_for_current_index()
		active_state["message_index"] = 0
		active_state["sequence_in_progress"] = true
		segment_changed.emit(current_conversation.get("day", current_conversation.get("chapter", null)), _parent_conversation_id(), _segment_id_for_current_index())
		var data := _current_segment_data()
		await _render_segment_messages_with_typing(data, conversation_id, token)
		if not _is_render_current(conversation_id, token):
			return
		active_state["sequence_in_progress"] = false
		var has_more_segments := _has_next_segment()
		if _show_choices_for_segment(data, not has_more_segments):
			return
	active_state["sequence_in_progress"] = false
	active_state["sequence_complete"] = true
	_emit_conversation_completed_once()

func _render_segment_messages_with_typing(data: Dictionary, conversation_id: String, token: int) -> void:
	_clear_node(choice_area)
	var queue := _flatten_render_queue(data)
	var start_index := int(active_state.get("message_index", 0))
	for index in range(start_index, queue.size()):
		if not _is_render_current(conversation_id, token):
			return
		active_state["message_index"] = index
		await _render_message_with_typing(queue[index], conversation_id, token)
		if not _is_render_current(conversation_id, token):
			return
		active_state["message_index"] = index + 1

func _resume_incomplete_sequence(conversation_id: String, token: int) -> void:
	var phase := str(active_state.get("render_phase", "segment"))
	if phase == "followup":
		var choice: Dictionary = active_state.get("pending_followup_choice", {})
		await _play_followup_sequence(choice, conversation_id, token)
		if not _is_render_current(conversation_id, token):
			return
		active_state["followup_index"] = 0
		active_state["pending_followup_choice"] = {}
		active_state["ludo_reply_recorded"] = false
		await _auto_advance_segments_until_choice(conversation_id, token)
		return
	var data := _current_segment_data()
	await _render_segment_messages_with_typing(data, conversation_id, token)
	if not _is_render_current(conversation_id, token):
		return
	active_state["sequence_in_progress"] = false
	if _show_choices_for_segment(data, not _has_next_segment()):
		return
	if phase == "auto":
		await _auto_advance_segments_until_choice(conversation_id, token)
	else:
		active_state["sequence_complete"] = true
		_emit_conversation_completed_once()

func _emit_conversation_completed_once() -> void:
	var completion_id := _completion_id_for_current_segment()
	var emitted_ids: Dictionary = active_state.get("completion_emitted_ids", {})
	if bool(emitted_ids.get(completion_id, false)):
		return
	emitted_ids[completion_id] = true
	active_state["completion_emitted_ids"] = emitted_ids
	active_state["completion_emitted"] = true
	conversation_completed.emit(current_conversation.get("day", current_conversation.get("chapter", null)), completion_id)

func _completion_id_for_current_segment() -> String:
	var data := _current_segment_data()
	var source_id := str(data.get("_source_conversation_id", ""))
	if source_id != "":
		return source_id
	return _parent_conversation_id()

func _flatten_choice_followup_queue(choice: Dictionary) -> Array:
	var queue: Array = []
	for key in ["next_messages", "next_items", "automatic_followup"]:
		for entry in choice.get(key, []):
			_flatten_render_entry(entry, queue)
	return queue

func _flatten_render_queue(conversation: Dictionary) -> Array:
	var queue: Array = []
	for item in _flatten_content(conversation):
		_flatten_render_entry(item, queue)
	return queue

func _flatten_render_entry(item, queue: Array) -> void:
	if typeof(item) != TYPE_DICTIONARY:
		return
	if item.has("messages"):
		for message in item.get("messages", []):
			_flatten_render_entry(message, queue)
	if item.has("social_items"):
		for social_item in item.get("social_items", []):
			_flatten_render_entry(social_item, queue)
	if item.has("incoming_notifications"):
		for notification in item.get("incoming_notifications", []):
			_flatten_render_entry(notification, queue)
	if _has_direct_choices(item):
		if item.has("text") or item.has("body") or item.has("content_id") or item.has("reaction"):
			queue.append(item)
		return
	if item.has("automatic_followup"):
		for followup in item.get("automatic_followup", []):
			_flatten_render_entry(followup, queue)
	if item.has("text") or item.has("body") or item.has("content_id") or item.has("reaction"):
		queue.append(item)
	elif not item.has("messages") and not item.has("social_items"):
		queue.append({"text": "[debug item] %s" % str(item.get("id", item.keys())), "_system_note": true})

func _has_direct_choices(item: Dictionary) -> bool:
	return not item.get("choices", []).is_empty() or not item.get("priority_choices", []).is_empty()

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
	active_state["choice_was_applied"] = true
	active_state["waiting_choices"] = false
	for button in choice_buttons:
		button.disabled = true
	_clear_node(choice_area)
	choice_selected.emit(choice)

func _render_item_with_typing(item, conversation_id: String, token: int) -> void:
	if typeof(item) != TYPE_DICTIONARY:
		return
	if item.has("messages"):
		for message in item.get("messages", []):
			if not _is_render_current(conversation_id, token):
				return
			await _render_message_with_typing(message, conversation_id, token)
	if item.has("social_items"):
		for social_item in item.get("social_items", []):
			await _render_item_with_typing(social_item, conversation_id, token)
	if item.has("incoming_notifications"):
		for notification in item.get("incoming_notifications", []):
			await _render_item_with_typing(notification, conversation_id, token)
	if item.has("automatic_followup"):
		for followup in item.get("automatic_followup", []):
			await _render_item_with_typing(followup, conversation_id, token)
	if item.has("text") or item.has("body") or item.has("content_id") or item.has("reaction"):
		await _render_message_with_typing(item, conversation_id, token)
	elif not item.has("messages") and not item.has("social_items"):
		if _is_render_current(conversation_id, token):
			_add_system_note("[debug item] %s" % str(item.get("id", item.keys())))

func _render_message_with_typing(message: Dictionary, conversation_id: String, token: int) -> void:
	if not _is_render_current(conversation_id, token):
		return
	if _history_contains_message(message):
		return
	if bool(message.get("_system_note", false)):
		_add_system_note(_format_message_text(message))
		return
	if not _is_ludo_sender(message):
		var typing_indicator := _show_typing_indicator(message)
		await _animate_typing_indicator(typing_indicator, _typing_delay_for_message(message), conversation_id, token)
		if is_instance_valid(typing_indicator):
			typing_indicator.queue_free()
		if not _is_render_current(conversation_id, token):
			return
	_render_message(message)

func _show_typing_indicator(message: Dictionary) -> Node:
	var typing_message := message.duplicate(true)
	typing_message.erase("sender")
	typing_message.erase("author")
	typing_message.erase("time_label")
	typing_message["text"] = "..."
	return _render_chat_bubble(typing_message, false)

func _animate_typing_indicator(typing_indicator: Node, delay: float, conversation_id: String, token: int) -> void:
	var states := [".", "..", "..."]
	var elapsed := 0.0
	var index := 0
	while elapsed < delay and is_instance_valid(typing_indicator):
		if not _is_render_current(conversation_id, token):
			return
		_set_typing_indicator_text(typing_indicator, states[index % states.size()])
		var step = min(0.22, delay - elapsed)
		await get_tree().create_timer(step).timeout
		elapsed += step
		index += 1

func _set_typing_indicator_text(typing_indicator: Node, text: String) -> void:
	var labels := typing_indicator.find_children("", "Label", true, false)
	if not labels.is_empty():
		(labels.back() as Label).text = text

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

func _render_message(message: Dictionary, record_history := true) -> void:
	var text := _format_message_text(message)
	if text != "":
		_render_chat_bubble(message, record_history)
	if message.has("content_id"):
		_add_placeholder_card(str(message["content_id"]), _is_ludo_sender(message), record_history)

func _render_chat_bubble(message: Dictionary, record_history := true) -> Node:
	if record_history:
		_record_history_entry({"type": "message", "message": message.duplicate(true)})
	var is_ludo := _is_ludo_sender(message)
	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.alignment = BoxContainer.ALIGNMENT_END if is_ludo else BoxContainer.ALIGNMENT_BEGIN
	message_thread.add_child(row)

	var text_width := _bubble_text_width(message)
	var bubble := PanelContainer.new()
	bubble.custom_minimum_size = Vector2(text_width, 0)
	bubble.size_flags_horizontal = Control.SIZE_SHRINK_END if is_ludo else Control.SIZE_SHRINK_BEGIN
	bubble.add_theme_stylebox_override("panel", _bubble_style(_bubble_color_for_sender(message), is_ludo))
	row.add_child(bubble)

	var text_box := VBoxContainer.new()
	text_box.add_theme_constant_override("separation", 4)
	bubble.add_child(text_box)

	var sender := str(message.get("sender", message.get("author", "")))
	var time_text := _message_time_text(message)
	if (sender != "" and not is_ludo) or time_text != "":
		var meta_row := HBoxContainer.new()
		meta_row.add_theme_constant_override("separation", 8)
		meta_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		text_box.add_child(meta_row)
	if sender != "" and not is_ludo:
		var sender_label := Label.new()
		sender_label.text = sender.capitalize()
		sender_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sender_label.add_theme_font_size_override("font_size", 11)
		sender_label.add_theme_color_override("font_color", Color(0.77, 0.72, 0.90))
		(text_box.get_child(text_box.get_child_count() - 1) as HBoxContainer).add_child(sender_label)
	elif time_text != "":
		var spacer := Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		(text_box.get_child(text_box.get_child_count() - 1) as HBoxContainer).add_child(spacer)
	if time_text != "":
		var time_label := Label.new()
		time_label.text = time_text
		time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		time_label.add_theme_font_size_override("font_size", 10)
		time_label.add_theme_color_override("font_color", Color(0.67, 0.70, 0.78))
		(text_box.get_child(text_box.get_child_count() - 1) as HBoxContainer).add_child(time_label)

	var label := Label.new()
	label.text = _format_message_text(message)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(text_width, 0)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 15)
	text_box.add_child(label)
	_scroll_to_bottom.call_deferred()
	return row

func _format_message_text(message: Dictionary) -> String:
	var text := str(message.get("text", message.get("body", message.get("reaction", ""))))
	if text == "":
		return ""
	return text

func _message_time_text(message: Dictionary) -> String:
	return str(message.get("time_label", ""))

func _bubble_text_width(message: Dictionary) -> int:
	var text := _format_message_text(message)
	var estimated := int(float(text.length()) * BUBBLE_CHAR_WIDTH) + 32
	return int(clamp(float(estimated), float(BUBBLE_MIN_WIDTH), float(BUBBLE_MAX_WIDTH)))

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

func _add_placeholder_card(content_id: String, is_ludo := false, record_history := true) -> void:
	if record_history:
		_record_history_entry({"type": "placeholder", "content_id": content_id, "is_ludo": is_ludo})
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
	_scroll_to_bottom.call_deferred()

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

func _add_system_note(text: String, record_history := true) -> void:
	if record_history:
		_record_history_entry({"type": "system", "text": text})
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color(0.62, 0.64, 0.70))
	message_thread.add_child(label)
	_scroll_to_bottom.call_deferred()

func _conversation_key(conversation: Dictionary) -> String:
	return str(conversation.get("_parent_conversation_id", conversation.get("id", "")))

func _is_render_current(conversation_id: String, token: int) -> bool:
	return conversation_id == active_conversation_id and token == current_render_token

func _record_history_entry(entry: Dictionary) -> void:
	if restoring_state or active_state.is_empty():
		return
	if str(entry.get("type", "")) == "message":
		var message: Dictionary = entry.get("message", {})
		var key := _message_history_key(message)
		var rendered_message_keys: Dictionary = active_state.get("rendered_message_keys", {})
		if rendered_message_keys.has(key):
			return
		rendered_message_keys[key] = true
		active_state["rendered_message_keys"] = rendered_message_keys
	var history: Array = active_state.get("history", [])
	history.append(entry.duplicate(true))
	active_state["history"] = history

func _history_contains_message(message: Dictionary) -> bool:
	var rendered_message_keys: Dictionary = active_state.get("rendered_message_keys", {})
	return rendered_message_keys.has(_message_history_key(message))

func _message_history_key(message: Dictionary) -> String:
	var parts: Array[String] = []
	for key in ["id", "sender", "author", "time_label", "text", "body", "reaction", "content_id"]:
		if message.has(key):
			parts.append("%s=%s" % [key, str(message.get(key))])
	return "|".join(parts)

func _restore_state_to_view(state: Dictionary) -> void:
	restoring_state = true
	for entry in state.get("history", []):
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		match str(entry.get("type", "")):
			"message":
				_render_message(entry.get("message", {}), false)
			"placeholder":
				_add_placeholder_card(str(entry.get("content_id", "")), bool(entry.get("is_ludo", false)), false)
			"system":
				_add_system_note(str(entry.get("text", "")), false)
	restoring_state = false
	choice_was_applied = bool(state.get("choice_was_applied", false))
	if bool(state.get("waiting_choices", false)) and not choice_was_applied:
		_show_choices_for_segment(state.get("choice_data", {}), bool(state.get("show_empty_hint", true)), false)
	else:
		_clear_node(choice_area)

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

func _scroll_to_bottom() -> void:
	if message_scroll == null:
		return
	await get_tree().process_frame
	message_scroll.scroll_vertical = int(message_scroll.get_v_scroll_bar().max_value)
