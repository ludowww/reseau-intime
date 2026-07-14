extends "res://scripts/ui/ConversationViewV095.gd"

signal contacts_requested

func _add_chat_header(conversation: Dictionary) -> void:
	super._add_chat_header(conversation)
	if not is_instance_valid(header_panel):
		return
	if header_panel.get_child_count() == 0:
		return
	var header := header_panel.get_child(0)
	if not (header is HBoxContainer):
		return
	var back_button := Button.new()
	back_button.name = "ContactsBackButton"
	back_button.text = "←"
	back_button.focus_mode = Control.FOCUS_ALL
	back_button.custom_minimum_size = Vector2(44, 44)
	back_button.tooltip_text = "Retour aux contacts"
	back_button.pressed.connect(func(): contacts_requested.emit())
	header.add_child(back_button)
	header.move_child(back_button, 0)
