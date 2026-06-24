extends VBoxContainer

signal choice_selected(choice: Dictionary)

func show_conversation(conversation: Dictionary) -> void:
	_clear()
	_add_label(conversation.get("title", conversation.get("id", "Conversation")), 20)
	_add_meta(conversation)
	for item in _flatten_content(conversation):
		_render_item(item)
	var choices := _collect_choices(conversation)
	if choices.is_empty():
		_add_label("Aucun choix direct dans cette conversation.")
	else:
		_add_label("Choix disponibles", 16)
		for choice in choices:
			var button := Button.new()
			button.text = str(choice.get("text", choice.get("id", "Choix")))
			button.pressed.connect(func(): choice_selected.emit(choice))
			add_child(button)

func append_choice_result(choice: Dictionary) -> void:
	_add_label("Réponse choisie : %s" % choice.get("text", choice.get("id", "")), 16)
	for key in ["next_messages", "next_items", "automatic_followup"]:
		for entry in choice.get(key, []):
			_render_item(entry)

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
	_add_meta(item)
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
		_add_label("[debug item] %s" % str(item.get("id", item.keys())))

func _render_message(message: Dictionary) -> void:
	var prefix := ""
	if message.has("time_label"):
		prefix = "[%s] " % message["time_label"]
	var sender := str(message.get("sender", message.get("author", message.get("title", "system"))))
	var text := str(message.get("text", message.get("body", message.get("reaction", ""))))
	if text != "":
		_add_label("%s%s: %s" % [prefix, sender, text])
	if message.has("content_id"):
		_add_placeholder(str(message["content_id"]))

func _add_placeholder(content_id: String) -> void:
	var item := DataLoader.get_visual_content(content_id)
	var tags := ", ".join(item.get("tags", [])) if not item.is_empty() else "unknown"
	var risk := str(item.get("risk_level", "?")) if not item.is_empty() else "?"
	_add_label("[Image placeholder]
ID: %s
Tags: %s
Risk: %s" % [content_id, tags, risk])
	GameState.add_unlocked_content(content_id)

func _add_meta(data: Dictionary) -> void:
	var meta: Array[String] = []
	for key in ["moment_label", "time_label", "transition_text", "availability_state"]:
		if data.has(key):
			meta.append("%s: %s" % [key, data[key]])
	if not meta.is_empty():
		_add_label(" | ".join(meta), 12)

func _add_label(text: String, size: int = 14) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	add_child(label)

func _clear() -> void:
	for child in get_children():
		child.queue_free()
