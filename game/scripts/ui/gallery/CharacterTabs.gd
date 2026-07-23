extends ScrollContainer

class_name CharacterTabs

signal character_selected(character_id: String)
signal focus_grid_requested

var tab_row: HBoxContainer
var tab_buttons: Array[Button] = []
var character_ids: Array[String] = []
var selected_character_id := ""
var portrait_theme
var presentations: Dictionary = {}

func configure(source: Dictionary, order: Array[String], theme) -> void:
	presentations = source.duplicate(true)
	character_ids = order.duplicate()
	portrait_theme = theme
	horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	custom_minimum_size = Vector2(0, 58)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_build()

func select_character(character_id: String, emit_selection := false) -> void:
	if not character_ids.has(character_id):
		return
	selected_character_id = character_id
	_refresh_styles()
	if emit_selection:
		character_selected.emit(character_id)

func focus_selected_tab() -> void:
	var index := character_ids.find(selected_character_id)
	if index >= 0 and index < tab_buttons.size():
		tab_buttons[index].grab_focus()

func selected_tab_has_focus() -> bool:
	var index := character_ids.find(selected_character_id)
	return index >= 0 and index < tab_buttons.size() and tab_buttons[index].has_focus()

func tab_count() -> int:
	return tab_buttons.size()

func tab_bounds() -> Rect2:
	return get_global_rect()

func tab_minimum_height() -> float:
	var result := 0.0
	for button in tab_buttons:
		result = max(result, button.custom_minimum_size.y)
	return result

func _build() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	tab_buttons.clear()
	tab_row = HBoxContainer.new()
	tab_row.name = "CharacterTabRow"
	tab_row.add_theme_constant_override("separation", 8)
	tab_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(tab_row)
	for character_id in character_ids:
		var presentation: Dictionary = presentations.get(character_id, {})
		var button := Button.new()
		button.name = "CharacterTab_%s" % character_id
		button.text = "%s  %s" % [str(presentation.get("avatar_ref", "•")), str(presentation.get("display_name", ""))]
		button.tooltip_text = str(presentation.get("display_name", ""))
		button.focus_mode = Control.FOCUS_ALL
		button.custom_minimum_size = Vector2(0, 48)
		button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		button.add_theme_font_size_override("font_size", 16)
		button.pressed.connect(_on_tab_pressed.bind(character_id))
		button.gui_input.connect(_on_tab_gui_input.bind(character_id))
		tab_row.add_child(button)
		tab_buttons.append(button)
	_refresh_styles()

func _on_tab_pressed(character_id: String) -> void:
	select_character(character_id, true)

func _on_tab_gui_input(event: InputEvent, character_id: String) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	var index := character_ids.find(character_id)
	if event.keycode == KEY_LEFT:
		_move_selection(index - 1)
		accept_event()
	elif event.keycode == KEY_RIGHT:
		_move_selection(index + 1)
		accept_event()
	elif event.keycode == KEY_DOWN:
		focus_grid_requested.emit()
		accept_event()

func _move_selection(index: int) -> void:
	if index < 0 or index >= character_ids.size():
		return
	var character_id := character_ids[index]
	select_character(character_id, true)
	tab_buttons[index].grab_focus()
	ensure_control_visible(tab_buttons[index])

func _refresh_styles() -> void:
	if portrait_theme == null:
		return
	for index in range(tab_buttons.size()):
		var button := tab_buttons[index]
		var character_id := character_ids[index]
		var presentation: Dictionary = presentations.get(character_id, {})
		var accent: Color = presentation.get("accent_color", portrait_theme.GALLERY_ACCENT)
		var is_active := character_id == selected_character_id
		button.button_pressed = is_active
		button.add_theme_color_override("font_color", portrait_theme.TEXT_PRIMARY)
		button.add_theme_color_override("font_focus_color", portrait_theme.TEXT_PRIMARY)
		button.add_theme_stylebox_override("normal", portrait_theme.button_style(Color(0.09, 0.11, 0.18), accent if is_active else portrait_theme.BORDER))
		button.add_theme_stylebox_override("hover", portrait_theme.button_style(Color(0.13, 0.16, 0.24), accent))
		button.add_theme_stylebox_override("pressed", portrait_theme.button_style(Color(0.17, 0.20, 0.30), accent))
		button.add_theme_stylebox_override("focus", portrait_theme.focus_style())
