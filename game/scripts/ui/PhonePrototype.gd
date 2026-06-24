extends Control

var day_list: VBoxContainer
var conversation_list: VBoxContainer
var conversation_view: VBoxContainer
var debug_panel: VBoxContainer
var debug_scroll: ScrollContainer

func _ready() -> void:
	if DataLoader.chapter_indexes.is_empty():
		DataLoader.load_all()
	GameState.reset_state()
	_build_layout()
	_render_days()

func _build_layout() -> void:
	for child in get_children():
		child.queue_free()
	var root := HBoxContainer.new()
	root.anchor_right = 1.0
	root.anchor_bottom = 1.0
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 12)
	add_child(root)

	day_list = VBoxContainer.new()
	day_list.custom_minimum_size = Vector2(160, 0)
	day_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(day_list)

	conversation_list = VBoxContainer.new()
	conversation_list.custom_minimum_size = Vector2(220, 0)
	conversation_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(conversation_list)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(600, 0)
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(scroll)
	conversation_view = preload("res://scenes/smartphone/ConversationView.tscn").instantiate()
	conversation_view.custom_minimum_size = Vector2(600, 0)
	conversation_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	conversation_view.choice_selected.connect(_on_choice_selected)
	scroll.add_child(conversation_view)

	debug_scroll = ScrollContainer.new()
	debug_scroll.custom_minimum_size = Vector2(260, 0)
	debug_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	debug_scroll.visible = false
	root.add_child(debug_scroll)
	debug_panel = preload("res://scenes/smartphone/DebugPanel.tscn").instantiate()
	debug_scroll.add_child(debug_panel)

func _render_days() -> void:
	_clear(day_list)
	_add_label(day_list, "Réseau Intime\nPrototype", 18)
	for index in DataLoader.chapter_indexes:
		var day_value = index.get("day", index.get("chapter", 0))
		var button := _add_button(day_list, _format_day_label(day_value))
		button.tooltip_text = str(index.get("title", ""))
		button.pressed.connect(func(): _render_conversations(day_value))
	var debug_button := _add_button(day_list, "Afficher debug")
	debug_button.pressed.connect(func(): _toggle_debug(debug_button))
	var reset_button := _add_button(day_list, "Reset state")
	reset_button.pressed.connect(func(): GameState.reset_state(); debug_panel.refresh())

func _render_conversations(day_value) -> void:
	_clear(conversation_list)
	_add_label(conversation_list, _format_day_label(day_value), 18)
	var moments := DataLoader.get_moments_for_day(day_value)
	if moments.is_empty():
		_render_conversation_buttons(day_value, DataLoader.get_conversations_for_day(day_value))
		return
	for moment in moments:
		var button := _add_button(conversation_list, "%s — %s" % [moment.get("moment_label", "moment"), moment.get("time_label", "")])
		button.tooltip_text = str(moment.get("transition_text", ""))
		button.pressed.connect(func(): _render_moment_conversations(day_value, moment))

func _render_moment_conversations(day_value, moment: Dictionary) -> void:
	_clear(conversation_list)
	_add_label(conversation_list, "%s\n%s" % [moment.get("moment_label", "moment"), moment.get("time_label", "")], 18)
	if moment.has("transition_text"):
		_add_label(conversation_list, str(moment["transition_text"]), 12)
	_render_conversation_buttons(day_value, DataLoader.get_conversations_for_moment(day_value, moment))

func _render_conversation_buttons(day_value, conversations: Array) -> void:
	for conversation in conversations:
		var button := _add_button(conversation_list, _conversation_label(conversation))
		button.pressed.connect(func(): _open_conversation(day_value, conversation))

func _open_conversation(day_value, conversation: Dictionary) -> void:
	GameState.set_context(day_value, str(conversation.get("_parent_conversation_id", conversation.get("id", ""))), str(conversation.get("id", "")))
	conversation_view.show_conversation(conversation)
	debug_panel.refresh()

func _on_choice_selected(choice: Dictionary) -> void:
	EffectApplier.apply_choice(choice)
	conversation_view.append_choice_result(choice)
	debug_panel.refresh()

func _toggle_debug(button: Button) -> void:
	debug_scroll.visible = not debug_scroll.visible
	button.text = "Masquer debug" if debug_scroll.visible else "Afficher debug"
	if debug_scroll.visible:
		debug_panel.refresh()

func _format_day_label(day_value) -> String:
	return "Jour %d" % int(day_value)

func _conversation_label(conversation: Dictionary) -> String:
	var label := str(conversation.get("title", conversation.get("id", "Conversation")))
	var meta: Array[String] = []
	if str(conversation.get("moment_label", "")) != "":
		meta.append(str(conversation.get("moment_label")))
	if str(conversation.get("time_label", "")) != "":
		meta.append(str(conversation.get("time_label")))
	if not meta.is_empty():
		label = "%s\n%s" % [label, " — ".join(meta)]
	return label

func _add_label(parent: Node, text: String, size: int = 14) -> void:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(label)

func _add_button(parent: Node, text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.custom_minimum_size = Vector2(0, 44)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(button)
	return button

func _clear(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
