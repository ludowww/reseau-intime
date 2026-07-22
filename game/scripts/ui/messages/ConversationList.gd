extends VBoxContainer

class_name ConversationList

signal thread_selected(thread_id: String)

var PORTRAIT_THEME
var characters: Dictionary = {}
var threads: Array[Dictionary] = []
var cards: Array[Button] = []
var card_views: Dictionary = {}
var wrapped_labels: Array[Label] = []
var list_box: VBoxContainer

func configure(thread_presentations: Array[Dictionary], character_presentations: Dictionary, portrait_theme) -> void:
	threads = thread_presentations
	characters = character_presentations
	PORTRAIT_THEME = portrait_theme
	_build()

func update_thread_presentation(thread: Dictionary) -> void:
	var thread_id := str(thread.get("thread_id", ""))
	if thread_id == "" or not card_views.has(thread_id):
		return
	for index in range(threads.size()):
		if str(threads[index].get("thread_id", "")) == thread_id:
			threads[index] = thread.duplicate(true)
			break
	var view: Dictionary = card_views[thread_id]
	var preview: Label = view.get("preview")
	var timestamp: Label = view.get("timestamp")
	var unread: Label = view.get("unread")
	preview.text = str(thread.get("last_preview", ""))
	timestamp.text = str(thread.get("last_timestamp", ""))
	var unread_count := int(thread.get("unread_count", 0))
	unread.text = str(unread_count)
	unread.visible = unread_count > 0

func focus_first_card() -> void:
	if not cards.is_empty():
		cards[0].grab_focus()

func focus_thread(thread_id: String) -> void:
	for index in range(threads.size()):
		if str(threads[index].get("thread_id", "")) == thread_id and index < cards.size():
			cards[index].grab_focus()
			return
	focus_first_card()

func focused_thread_id() -> String:
	for index in range(cards.size()):
		if cards[index].has_focus() and index < threads.size():
			return str(threads[index].get("thread_id", ""))
	return ""

func first_card_has_focus() -> bool:
	return not cards.is_empty() and cards[0].has_focus()

func has_horizontal_crop() -> bool:
	for label in wrapped_labels:
		if label.size.x > 0.0 and label.get_minimum_size().x > label.size.x + 1.0:
			return true
	return false

func _build() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	cards.clear()
	card_views.clear()
	wrapped_labels.clear()
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 12)
	var title := _label("Messages", 30, PORTRAIT_THEME.TEXT_PRIMARY)
	add_child(title)
	var subtitle := _label("Démonstration hors récit", 14, PORTRAIT_THEME.TEXT_MUTED)
	add_child(subtitle)
	var scroll := ScrollContainer.new()
	scroll.name = "ConversationScroll"
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)
	list_box = VBoxContainer.new()
	list_box.name = "ConversationCards"
	list_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_box.add_theme_constant_override("separation", 10)
	scroll.add_child(list_box)
	for thread in threads:
		list_box.add_child(_build_conversation_card(thread))

# ConversationCard is a semantic panel with one focusable action and complete metadata.
func _build_conversation_card(thread: Dictionary) -> PanelContainer:
	var thread_id := str(thread.get("thread_id", "demo"))
	var card := PanelContainer.new()
	card.name = "ConversationCard_%s" % thread_id
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", PORTRAIT_THEME.item_style(Color(0.08, 0.10, 0.17)))
	var button := Button.new()
	button.name = "OpenConversation"
	button.flat = true
	button.focus_mode = Control.FOCUS_ALL
	button.custom_minimum_size = Vector2(0, 108)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	button.pressed.connect(func(): thread_selected.emit(thread_id))
	card.add_child(button)
	cards.append(button)
	var row := HBoxContainer.new()
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT, Control.PRESET_MODE_MINSIZE, 12)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 12)
	button.add_child(row)
	var accent := Color.from_string(str(thread.get("accent_color", "#8D63E6")), PORTRAIT_THEME.PLAYER_ACCENT)
	var avatar := Label.new()
	avatar.name = "Avatar"
	avatar.text = str(thread.get("avatar_ref", "?"))
	avatar.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	avatar.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	avatar.custom_minimum_size = Vector2(54, 54)
	avatar.add_theme_font_size_override("font_size", 22)
	avatar.add_theme_color_override("font_color", accent)
	avatar.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.06, 0.08, 0.14), accent, 27))
	row.add_child(avatar)
	var text_column := VBoxContainer.new()
	text_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_column.add_theme_constant_override("separation", 4)
	row.add_child(text_column)
	var display_name := _label(str(thread.get("title", "Conversation")), 19, PORTRAIT_THEME.TEXT_PRIMARY)
	display_name.name = "DisplayName"
	text_column.add_child(display_name)
	var last_preview := _label(str(thread.get("last_preview", "")), 15, PORTRAIT_THEME.TEXT_SECONDARY)
	last_preview.name = "LastPreview"
	last_preview.max_lines_visible = 3
	text_column.add_child(last_preview)
	var metadata := VBoxContainer.new()
	metadata.custom_minimum_size = Vector2(72, 0)
	metadata.add_theme_constant_override("separation", 8)
	row.add_child(metadata)
	var last_timestamp := _label(str(thread.get("last_timestamp", "")), 14, PORTRAIT_THEME.TEXT_MUTED)
	last_timestamp.name = "LastTimestamp"
	last_timestamp.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	metadata.add_child(last_timestamp)
	var unread_count := int(thread.get("unread_count", 0))
	var unread := _label(str(unread_count), 14, PORTRAIT_THEME.TEXT_PRIMARY)
	unread.name = "UnreadCount"
	unread.visible = unread_count > 0
	unread.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	unread.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(accent.darkened(0.45), accent, 14))
	metadata.add_child(unread)
	card_views[thread_id] = {
		"button": button,
		"preview": last_preview,
		"timestamp": last_timestamp,
		"unread": unread,
	}
	return card

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	wrapped_labels.append(label)
	return label
