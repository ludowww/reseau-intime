extends "res://scripts/ui/ConversationViewV096A.gd"

func show_conversation(conversation: Dictionary) -> void:
	super.show_conversation(conversation)
	call_deferred("_restore_completion_controls_if_needed")

func _emit_conversation_completed_once() -> void:
	super._emit_conversation_completed_once()
	_show_completion_controls_if_needed()

func _restore_completion_controls_if_needed() -> void:
	_show_completion_controls_if_needed()

func _show_completion_controls_if_needed() -> void:
	if active_conversation_id.begins_with("archive::"):
		return
	if active_state.is_empty() or not bool(active_state.get("sequence_complete", false)):
		return
	_show_completion_controls()

func _show_completion_controls() -> void:
	if not is_instance_valid(choice_area):
		return
	_clear_node(choice_area)
	_add_choice_hint("Conversation terminée.")
	var button := Button.new()
	button.name = "CompletedReturnToContactsButton"
	button.text = "Retour aux contacts"
	button.focus_mode = Control.FOCUS_ALL
	button.custom_minimum_size = Vector2(0, 48)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_stylebox_override("normal", _panel_style(CHOICE_COLOR, 18))
	button.add_theme_stylebox_override("hover", _panel_style(Color(0.18, 0.21, 0.28), 18))
	button.add_theme_stylebox_override("pressed", _panel_style(Color(0.20, 0.29, 0.38), 18))
	button.pressed.connect(func(): contacts_requested.emit())
	choice_area.add_child(button)
	_scroll_to_bottom.call_deferred()
