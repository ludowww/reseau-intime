extends "res://scripts/ui/ConversationView.gd"

signal narrative_time_changed(time_label: String)

const AUTHORED_PRESENTATIONS := ["time_separator", "offline_beat"]

# V0.81 gives authored temporal/offline items an explicit semantic path.
# They reuse the proven centered history renderer, never show a typing bubble,
# and never pretend to come from a character.
func _render_message_with_typing(message: Dictionary, conversation_id: String, token: int) -> void:
	var time_label := str(message.get("time_label", ""))
	if time_label != "":
		narrative_time_changed.emit(time_label)
	var presentation := str(message.get("presentation", ""))
	if AUTHORED_PRESENTATIONS.has(presentation):
		if not _is_render_current(conversation_id, token):
			return
		var text := _format_message_text(message)
		if text != "":
			_add_system_note(text)
		return
	await super._render_message_with_typing(message, conversation_id, token)
