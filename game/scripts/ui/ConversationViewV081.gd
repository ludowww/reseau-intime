extends "res://scripts/ui/ConversationView.gd"

signal narrative_time_changed(time_label: String)

const AUTHORED_PRESENTATIONS := ["time_separator", "offline_beat"]

# V0.81 gives authored temporal/offline items an explicit semantic path.
# They reuse the proven centered history renderer, never show a typing bubble,
# and never pretend to come from a character.
func _render_message_with_typing(message: Dictionary, conversation_id: String, token: int) -> void:
	var presentation := str(message.get("presentation", ""))
	if AUTHORED_PRESENTATIONS.has(presentation):
		if not _is_render_current(conversation_id, token):
			return
		if _history_contains_authored_item(message):
			return
		var text := _format_message_text(message)
		if text == "":
			return
		_record_authored_history_key(message)
		var time_label := str(message.get("time_label", ""))
		if time_label != "":
			narrative_time_changed.emit(time_label)
		_add_system_note(text)
		return
	await super._render_message_with_typing(message, conversation_id, token)

func _history_contains_authored_item(message: Dictionary) -> bool:
	var rendered_keys: Dictionary = active_state.get("rendered_authored_keys", {})
	return rendered_keys.has(_authored_history_key(message))

func _record_authored_history_key(message: Dictionary) -> void:
	var rendered_keys: Dictionary = active_state.get("rendered_authored_keys", {})
	rendered_keys[_authored_history_key(message)] = true
	active_state["rendered_authored_keys"] = rendered_keys

func _authored_history_key(message: Dictionary) -> String:
	var item_id := str(message.get("id", ""))
	if item_id != "":
		return item_id
	return "%s|%s|%s" % [
		str(message.get("presentation", "")),
		str(message.get("time_label", "")),
		_format_message_text(message),
	]
