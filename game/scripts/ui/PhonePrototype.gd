extends Control

const APP_BACKGROUND_COLOR := Color(0.025, 0.028, 0.04)
const PHONE_BACKGROUND_COLOR := Color(0.045, 0.05, 0.075)
const PHONE_FRAME_COLOR := Color(0.015, 0.016, 0.022)
const PHONE_PANEL_COLOR := Color(0.075, 0.082, 0.12)
const CARD_COLOR := Color(0.095, 0.105, 0.15)
const CARD_HOVER_COLOR := Color(0.13, 0.145, 0.20)
const ACCENT_COLOR := Color(0.35, 0.48, 0.70)
const MUTED_TEXT_COLOR := Color(0.66, 0.69, 0.76)

var day_list: VBoxContainer
var conversation_list: VBoxContainer
var conversation_cards: VBoxContainer
var conversation_view: VBoxContainer
var debug_panel: VBoxContainer
var debug_scroll: ScrollContainer
var current_day_value = null

func _ready() -> void:
	if DataLoader.chapter_indexes.is_empty():
		DataLoader.load_all()
	GameState.reset_state()
	_build_layout()
	_render_days()

func _build_layout() -> void:
	for child in get_children():
		child.queue_free()

	var background := PanelContainer.new()
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	background.add_theme_stylebox_override("panel", _panel_style(APP_BACKGROUND_COLOR, 0))
	add_child(background)

	var root := HBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 16)
	background.add_child(root)

	_build_phone_shell(root)

	conversation_view = preload("res://scenes/smartphone/ConversationView.tscn").instantiate()
	conversation_view.custom_minimum_size = Vector2(600, 0)
	conversation_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	conversation_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	conversation_view.choice_selected.connect(_on_choice_selected)
	conversation_view.segment_changed.connect(_on_segment_changed)
	root.add_child(conversation_view)

	debug_scroll = ScrollContainer.new()
	debug_scroll.custom_minimum_size = Vector2(260, 0)
	debug_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	debug_scroll.visible = false
	root.add_child(debug_scroll)
	debug_panel = preload("res://scenes/smartphone/DebugPanel.tscn").instantiate()
	debug_scroll.add_child(debug_panel)

func _build_phone_shell(root: Node) -> void:
	var phone_frame := PanelContainer.new()
	phone_frame.custom_minimum_size = Vector2(420, 680)
	phone_frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	phone_frame.add_theme_stylebox_override("panel", _panel_style(PHONE_FRAME_COLOR, 28))
	root.add_child(phone_frame)

	var phone_body := VBoxContainer.new()
	phone_body.add_theme_constant_override("separation", 12)
	phone_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	phone_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	phone_frame.add_child(phone_body)

	var phone_screen := PanelContainer.new()
	phone_screen.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	phone_screen.size_flags_vertical = Control.SIZE_EXPAND_FILL
	phone_screen.add_theme_stylebox_override("panel", _panel_style(PHONE_BACKGROUND_COLOR, 22))
	phone_body.add_child(phone_screen)

	var screen_column := VBoxContainer.new()
	screen_column.add_theme_constant_override("separation", 10)
	screen_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	screen_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	phone_screen.add_child(screen_column)

	_add_status_bar(screen_column)
	_add_home_navigation(screen_column)

	day_list = VBoxContainer.new()
	day_list.custom_minimum_size = Vector2(160, 0)
	day_list.add_theme_constant_override("separation", 8)
	day_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	screen_column.add_child(day_list)

	var list_scroll := ScrollContainer.new()
	list_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_column.add_child(list_scroll)

	conversation_list = VBoxContainer.new()
	conversation_list.add_theme_constant_override("separation", 8)
	conversation_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_scroll.add_child(conversation_list)
	conversation_cards = conversation_list

func _add_status_bar(parent: Node) -> void:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 8)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(bar)
	_add_label(bar, "09:41", 13)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(spacer)
	_add_label(bar, "▮▮  Wi‑Fi  82%", 12)

func _add_home_navigation(parent: Node) -> void:
	var title := Label.new()
	title.text = "Réseau Intime"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.92, 0.93, 0.98))
	parent.add_child(title)

	var nav := HBoxContainer.new()
	nav.add_theme_constant_override("separation", 8)
	nav.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(nav)
	var messages_button := _add_button(nav, "Messages")
	messages_button.pressed.connect(func(): _focus_messages())
	var debug_button := _add_button(nav, "Debug")
	debug_button.pressed.connect(func(): _toggle_debug(debug_button))
	var reset_button := _add_button(nav, "Reset")
	reset_button.pressed.connect(func(): GameState.reset_state(); debug_panel.refresh())

func _render_days() -> void:
	_clear(day_list)
	_add_label(day_list, "Jours", 15)
	var first_day = null
	for index in DataLoader.chapter_indexes:
		var day_value = index.get("day", index.get("chapter", 0))
		if first_day == null:
			first_day = day_value
		var button := _add_button(day_list, _format_day_label(day_value))
		button.tooltip_text = str(index.get("title", ""))
		button.pressed.connect(func(): _render_conversations(day_value))
	if first_day != null:
		_render_conversations(first_day)

func _focus_messages() -> void:
	if current_day_value != null:
		_render_conversations(current_day_value)

func _render_conversations(day_value) -> void:
	current_day_value = day_value
	_clear(conversation_list)
	_add_label(conversation_list, "%s — Discussions" % _format_day_label(day_value), 18)
	var moments := DataLoader.get_moments_for_day(day_value)
	if moments.is_empty():
		_render_conversation_buttons(day_value, DataLoader.get_conversations_for_day(day_value))
		return
	for moment in moments:
		_add_moment_card(day_value, moment)

func _render_moment_conversations(day_value, moment: Dictionary) -> void:
	_clear(conversation_list)
	_add_label(conversation_list, "%s\n%s" % [moment.get("moment_label", "moment"), moment.get("time_label", "")], 18)
	if moment.has("transition_text"):
		_add_muted_label(conversation_list, str(moment["transition_text"]), 12)
	_render_conversation_buttons(day_value, DataLoader.get_conversations_for_moment(day_value, moment))

func _render_conversation_buttons(day_value, conversations: Array) -> void:
	for conversation in conversations:
		_add_conversation_card(day_value, conversation)

func _add_moment_card(day_value, moment: Dictionary) -> void:
	var card := _make_card()
	conversation_cards.add_child(card)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	card.add_child(row)
	_add_avatar(row, str(moment.get("moment_label", "M")).substr(0, 1).to_upper())
	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text_box)
	_add_label(text_box, str(moment.get("moment_label", "Moment")), 15)
	_add_muted_label(text_box, str(moment.get("transition_text", moment.get("time_label", ""))), 12)
	_add_muted_label(row, str(moment.get("time_label", "")), 11)
	card.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_render_moment_conversations(day_value, moment)
	)

func _add_conversation_card(day_value, conversation: Dictionary) -> void:
	var card := _make_card()
	conversation_cards.add_child(card)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_child(row)

	_add_avatar(row, _avatar_initial(conversation))

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text_box)
	_add_label(text_box, _conversation_name(conversation), 15)
	_add_muted_label(text_box, _conversation_subtitle(conversation), 12)

	var status_box := VBoxContainer.new()
	status_box.custom_minimum_size = Vector2(64, 0)
	row.add_child(status_box)
	_add_muted_label(status_box, _conversation_status_text(conversation), 11)
	if _conversation_has_activity_badge(conversation):
		var badge := Label.new()
		badge.name = "badge"
		badge.text = "•"
		badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		badge.add_theme_font_size_override("font_size", 24)
		badge.add_theme_color_override("font_color", ACCENT_COLOR)
		status_box.add_child(badge)

	card.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_open_conversation(day_value, conversation)
	)

func _make_card() -> PanelContainer:
	var card := PanelContainer.new()
	card.mouse_filter = Control.MOUSE_FILTER_STOP
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", _card_style(CARD_COLOR))
	return card

func _add_avatar(parent: Node, text: String) -> void:
	var avatar := PanelContainer.new()
	avatar.name = "avatar_placeholder"
	avatar.custom_minimum_size = Vector2(44, 44)
	avatar.add_theme_stylebox_override("panel", _panel_style(Color(0.22, 0.20, 0.30), 22))
	parent.add_child(avatar)
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 17)
	avatar.add_child(label)

func _open_conversation(day_value, conversation: Dictionary) -> void:
	var conversation_id := str(conversation.get("_parent_conversation_id", conversation.get("id", "")))
	var segment_id := str(conversation.get("_current_segment_id", conversation.get("id", "")))
	GameState.set_context(day_value, conversation_id, segment_id)
	conversation_view.show_conversation(conversation)
	debug_panel.refresh()

func _on_segment_changed(day_value, conversation_id: String, segment_id: String) -> void:
	GameState.set_context(day_value, conversation_id, segment_id)
	debug_panel.refresh()

func _on_choice_selected(choice: Dictionary) -> void:
	EffectApplier.apply_choice(choice)
	conversation_view.append_choice_result(choice)
	debug_panel.refresh()

func _toggle_debug(button: Button) -> void:
	debug_scroll.visible = not debug_scroll.visible
	button.text = "Debug ✓" if debug_scroll.visible else "Debug"
	if debug_scroll.visible:
		debug_panel.refresh()

func _format_day_label(day_value) -> String:
	return "Jour %d" % int(day_value)

func _conversation_name(conversation: Dictionary) -> String:
	var thread = conversation.get("thread", {})
	if typeof(thread) == TYPE_DICTIONARY and str(thread.get("display_name", "")) != "":
		return str(thread.get("display_name"))
	return str(conversation.get("title", conversation.get("id", "Conversation")))

func _conversation_subtitle(conversation: Dictionary) -> String:
	var last_text := _last_message_text(conversation)
	if last_text != "":
		return last_text
	if str(conversation.get("description", "")) != "":
		return str(conversation.get("description"))
	return "Conversation disponible"

func _conversation_status_text(conversation: Dictionary) -> String:
	if str(conversation.get("time_label", "")) != "":
		return str(conversation.get("time_label"))
	if str(conversation.get("moment_label", "")) != "":
		return str(conversation.get("moment_label"))
	return "actif"

func _conversation_has_activity_badge(conversation: Dictionary) -> bool:
	if bool(conversation.get("unread", false)) or bool(conversation.get("active", false)):
		return true
	return not _collect_choices(conversation).is_empty()

func _last_message_text(conversation: Dictionary) -> String:
	var messages := _collect_messages(conversation)
	if messages.is_empty():
		return ""
	var message: Dictionary = messages.back()
	var sender := str(message.get("sender", message.get("author", "")))
	var body := str(message.get("text", message.get("body", message.get("reaction", ""))))
	if body.length() > 58:
		body = body.substr(0, 55) + "..."
	if sender != "":
		return "%s : %s" % [sender.capitalize(), body]
	return body

func _collect_messages(conversation: Dictionary) -> Array:
	var messages: Array = []
	for key in ["messages", "beats", "segments", "social_items", "incoming_notifications", "conditional_aftershocks", "conditional_proofs", "conditional_closers"]:
		for entry in conversation.get(key, []):
			if typeof(entry) == TYPE_DICTIONARY:
				if entry.has("messages"):
					for message in entry.get("messages", []):
						if typeof(message) == TYPE_DICTIONARY:
							messages.append(message)
				elif entry.has("text") or entry.has("body") or entry.has("reaction"):
					messages.append(entry)
	for key in ["default_aftershock", "default_proof", "default_closer"]:
		var entry = conversation.get(key, null)
		if typeof(entry) == TYPE_DICTIONARY:
			if entry.has("messages"):
				for message in entry.get("messages", []):
					if typeof(message) == TYPE_DICTIONARY:
						messages.append(message)
			elif entry.has("text") or entry.has("body") or entry.has("reaction"):
				messages.append(entry)
	return messages

func _collect_choices(conversation: Dictionary) -> Array:
	var choices: Array = []
	for key in ["choices", "priority_choices"]:
		choices.append_array(conversation.get(key, []))
	for container_key in ["beats", "segments"]:
		for entry in conversation.get(container_key, []):
			if typeof(entry) == TYPE_DICTIONARY:
				choices.append_array(entry.get("choices", []))
				choices.append_array(entry.get("priority_choices", []))
	return choices

func _avatar_initial(conversation: Dictionary) -> String:
	var name := _conversation_name(conversation)
	if name == "":
		return "?"
	return name.substr(0, 1).to_upper()

func _add_label(parent: Node, text: String, size: int = 14) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color(0.90, 0.91, 0.96))
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(label)
	return label

func _add_muted_label(parent: Node, text: String, size: int = 12) -> Label:
	var label := _add_label(parent, text, size)
	label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	return label

func _add_button(parent: Node, text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.custom_minimum_size = Vector2(0, 42)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_stylebox_override("normal", _panel_style(PHONE_PANEL_COLOR, 16))
	button.add_theme_stylebox_override("hover", _panel_style(CARD_HOVER_COLOR, 16))
	button.add_theme_stylebox_override("pressed", _panel_style(ACCENT_COLOR, 16))
	parent.add_child(button)
	return button

func _card_style(color: Color) -> StyleBoxFlat:
	var style := _panel_style(color, 18)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.18, 0.20, 0.28)
	return style

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

func _clear(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
