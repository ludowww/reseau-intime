extends "res://scripts/ui/ConversationViewV082.gd"

# V0.84 annotates every rendered history entry with its source episode. This
# allows an archived Tuesday to remain readable without leaking Wednesday or
# Thursday episodes from the same persistent contact thread.
var archive_rendering := false

func _record_history_entry(entry: Dictionary) -> void:
	var annotated := entry.duplicate(true)
	annotated["_source_conversation_id"] = _current_history_source_id()
	super._record_history_entry(annotated)

func show_archive_conversation(conversation: Dictionary) -> void:
	current_render_token += 1
	archive_rendering = true
	var thread_id := _conversation_key(conversation)
	var allowed_episode_ids: Array = conversation.get("_episode_ids", []).duplicate()
	if allowed_episode_ids.is_empty():
		allowed_episode_ids.append(str(conversation.get("id", "")))
	var stored_state: Dictionary = conversation_states.get(thread_id, {})
	var archived_history: Array = []
	for entry in stored_state.get("history", []):
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var source_id := str(entry.get("_source_conversation_id", ""))
		if source_id != "" and allowed_episode_ids.has(source_id):
			archived_history.append(entry)
	active_conversation_id = "archive::%s::%s" % [str(conversation.get("day", "")), thread_id]
	active_state = {}
	current_conversation = conversation.duplicate(true)
	current_segment_index = 0
	choice_buttons.clear()
	choice_was_applied = true
	_clear()
	custom_minimum_size = Vector2(600, 0)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	_build_chat_shell()
	_add_chat_header(current_conversation)
	if archived_history.is_empty():
		_add_system_note("Aucun échange archivé pour cette journée.", false)
	else:
		for entry in archived_history:
			_render_archive_history_entry(entry)
	_clear_node(choice_area)
	_add_choice_hint("Historique en lecture seule.")
	archive_rendering = false

func _render_archive_history_entry(entry: Dictionary) -> void:
	match str(entry.get("type", "")):
		"message":
			var message: Dictionary = entry.get("message", {})
			_render_chat_bubble(message, false)
		"placeholder":
			_add_placeholder_card(str(entry.get("content_id", "")), bool(entry.get("is_ludo", false)), false)
		"system":
			_add_system_note(str(entry.get("text", "")), false)

func _add_placeholder_card(content_id: String, is_ludo := false, record_history := true) -> void:
	if not archive_rendering:
		super._add_placeholder_card(content_id, is_ludo, record_history)
		return
	var item := DataLoader.get_visual_content(content_id)
	var context := str(item.get("context", "Image archivée")) if not item.is_empty() else "Image archivée"
	_add_system_note("[Image archivée] %s\n%s" % [content_id, context], false)

func _current_history_source_id() -> String:
	var data := _current_segment_data()
	var source_id := str(data.get("_source_conversation_id", ""))
	if source_id != "":
		return source_id
	return _parent_conversation_id()
