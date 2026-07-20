extends Control

class_name PortraitShell

var PORTRAIT_THEME = preload("res://scripts/ui/PortraitShellTheme.gd").new()
const SAFE_AREA_SCRIPT := preload("res://scripts/ui/SafeAreaContainer.gd")
const MESSAGES_SCREEN_SCENE := preload("res://scenes/portrait/messages/MessagesScreen.tscn")
const TAG_MESSAGES := "messages"
const TAG_GALLERY := "gallery"

var safe_area_container
var header_label: Label
var header_subtitle: Label
var mode_label: Label
var messages_panel: PanelContainer
var messages_screen
var gallery_panel: PanelContainer
var messages_button: Button
var gallery_button: Button
var reduced_motion_enabled := true
var active_tab := TAG_MESSAGES
var current_tween: Tween

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	active_tab = ""
	_build_shell()
	activate_messages(false)

func set_reduced_motion_enabled(enabled: bool) -> void:
	reduced_motion_enabled = enabled
	if reduced_motion_enabled:
		if current_tween != null and current_tween.is_running():
			current_tween.kill()
			current_tween = null
		if active_tab != "":
			_set_active_tab(active_tab, false)

func set_safe_area_preset(preset: String) -> void:
	if safe_area_container != null:
		safe_area_container.set_test_safe_area_preset(preset)

func set_safe_area_override(rect: Rect2i) -> void:
	if safe_area_container != null:
		safe_area_container.set_test_safe_area_override(rect)

func activate_messages(use_animation := true) -> void:
	_set_active_tab(TAG_MESSAGES, use_animation)

func activate_gallery(use_animation := true) -> void:
	_set_active_tab(TAG_GALLERY, use_animation)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_RIGHT:
			activate_gallery()
		elif event.keycode == KEY_LEFT:
			activate_messages()

func describe_layout() -> Dictionary:
	return {
		"active_tab": active_tab,
		"messages_visible": messages_panel.visible,
		"gallery_visible": gallery_panel.visible,
		"messages_button_pressed": messages_button.button_pressed,
		"gallery_button_pressed": gallery_button.button_pressed,
		"messages_alpha": messages_panel.modulate.a,
		"gallery_alpha": gallery_panel.modulate.a,
		"transition_running": current_tween != null and current_tween.is_running(),
		"messages_has_focus": messages_button.has_focus(),
		"gallery_has_focus": gallery_button.has_focus(),
		"safe_padding": safe_area_container.get_safe_padding(),
		"visible_bounds": safe_area_container.get_visible_bounds(),
		"messages_button_rect": messages_button.get_global_rect(),
		"gallery_button_rect": gallery_button.get_global_rect(),
		"viewport_size": Vector2i(int(round(get_viewport_rect().size.x)), int(round(get_viewport_rect().size.y))),
	}

func _build_shell() -> void:
	for child in get_children():
		child.queue_free()
	var background := PanelContainer.new()
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	background.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.BACKGROUND_DEEP, 0, 0))
	add_child(background)

	safe_area_container = SAFE_AREA_SCRIPT.new()
	safe_area_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	safe_area_container.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.BACKGROUND, 1, 30))
	background.add_child(safe_area_container)

	var shell_column := VBoxContainer.new()
	shell_column.set_anchors_preset(Control.PRESET_FULL_RECT)
	shell_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	shell_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	shell_column.add_theme_constant_override("separation", 14)
	safe_area_container.add_child(shell_column)

	var header := PanelContainer.new()
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE_RAISED, 1, 22))
	shell_column.add_child(header)

	var header_box := VBoxContainer.new()
	header_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_box.add_theme_constant_override("separation", 6)
	header.add_child(header_box)

	header_label = _make_label("Réseau Intime", 30, PORTRAIT_THEME.TEXT_PRIMARY)
	header_box.add_child(header_label)

	header_subtitle = _make_label("Coque portrait additive — Messages / Galerie", 16, PORTRAIT_THEME.TEXT_SECONDARY)
	header_box.add_child(header_subtitle)

	mode_label = _make_label("Messages actif", 14, PORTRAIT_THEME.TEXT_MUTED)
	header_box.add_child(mode_label)

	var content := PanelContainer.new()
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE, 1, 22))
	shell_column.add_child(content)

	var content_stack := Control.new()
	content_stack.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	content_stack.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_stack.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(content_stack)

	messages_panel = _build_messages_panel()
	content_stack.add_child(messages_panel)

	gallery_panel = _build_gallery_panel()
	content_stack.add_child(gallery_panel)

	var bottom_nav := HBoxContainer.new()
	bottom_nav.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_nav.add_theme_constant_override("separation", 12)
	shell_column.add_child(bottom_nav)

	messages_button = _make_nav_button("Messages", PORTRAIT_THEME.MESSAGE_ACCENT)
	messages_button.pressed.connect(func(): activate_messages())
	bottom_nav.add_child(messages_button)

	gallery_button = _make_nav_button("Galerie", PORTRAIT_THEME.GALLERY_ACCENT)
	gallery_button.pressed.connect(func(): activate_gallery())
	bottom_nav.add_child(gallery_button)

	var flex := Control.new()
	flex.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_nav.add_child(flex)

	var reduced_motion_tag := _make_label("Animations réduites", 13, PORTRAIT_THEME.TEXT_MUTED)
	reduced_motion_tag.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	reduced_motion_tag.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_nav.add_child(reduced_motion_tag)

func _make_label(text: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label

func _make_button(text: String, accent: Color, active := false) -> Button:
	var button := Button.new()
	button.text = text
	button.toggle_mode = true
	button.button_pressed = active
	button.focus_mode = Control.FOCUS_ALL
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	button.add_theme_color_override("font_hover_color", PORTRAIT_THEME.TEXT_PRIMARY)
	button.add_theme_color_override("font_pressed_color", PORTRAIT_THEME.TEXT_PRIMARY)
	button.add_theme_color_override("font_focus_color", PORTRAIT_THEME.TEXT_PRIMARY)
	button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.09, 0.11, 0.18), accent))
	button.add_theme_stylebox_override("hover", PORTRAIT_THEME.button_style(Color(0.13, 0.16, 0.24), accent))
	button.add_theme_stylebox_override("pressed", PORTRAIT_THEME.button_style(Color(0.17, 0.20, 0.30), accent))
	button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	return button

func _make_nav_button(text: String, _accent: Color) -> Button:
	var button := _make_button(text, _accent, false)
	button.add_theme_stylebox_override("normal", PORTRAIT_THEME.nav_style(false))
	button.add_theme_stylebox_override("hover", PORTRAIT_THEME.nav_style(false))
	button.add_theme_stylebox_override("pressed", PORTRAIT_THEME.nav_style(true))
	button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	return button

func _build_messages_panel() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = "MessagesPanel"
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE_RAISED, 1, 18))
	messages_screen = MESSAGES_SCREEN_SCENE.instantiate()
	messages_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.add_child(messages_screen)
	return panel

func _build_gallery_panel() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.name = "GalleryPanel"
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE_RAISED, 1, 18))
	var box := VBoxContainer.new()
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)
	box.add_child(_make_label("Galerie", 22, PORTRAIT_THEME.GALLERY_ACCENT))
	box.add_child(_make_label("Maquette factice : onglets personnages et grille sans asset narratif.", 16, PORTRAIT_THEME.TEXT_SECONDARY))
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 8)
	box.add_child(tabs)
	for tab_name in ["Marie", "Sandra", "Mathilde"]:
		var chip := _make_button(tab_name, PORTRAIT_THEME.GALLERY_ACCENT, false)
		chip.add_theme_font_size_override("font_size", 14)
		chip.focus_mode = Control.FOCUS_NONE
		tabs.add_child(chip)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	box.add_child(grid)
	for i in range(6):
		var tile := PanelContainer.new()
		tile.custom_minimum_size = Vector2(0, 104)
		tile.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tile.add_theme_stylebox_override("panel", PORTRAIT_THEME.item_style(Color(0.11, 0.14, 0.22)))
		var tile_box := VBoxContainer.new()
		tile_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tile_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tile_box.add_theme_constant_override("separation", 4)
		tile.add_child(tile_box)
		tile_box.add_child(_make_label("Photo %d" % (i + 1), 15, PORTRAIT_THEME.TEXT_PRIMARY))
		tile_box.add_child(_make_label("placeholder", 13, PORTRAIT_THEME.TEXT_MUTED))
		grid.add_child(tile)
	return panel

func _set_active_tab(tab: String, use_animation := true) -> void:
	active_tab = tab
	_refresh_nav_button_styles()
	mode_label.text = "%s actif" % ("Messages" if active_tab == TAG_MESSAGES else "Galerie")
	if active_tab == TAG_MESSAGES:
		messages_button.grab_focus()
	else:
		gallery_button.grab_focus()
	if reduced_motion_enabled or not use_animation:
		_messages_set_visible(active_tab == TAG_MESSAGES)
		_gallery_set_visible(active_tab == TAG_GALLERY)
		return
	if current_tween != null and current_tween.is_running():
		current_tween.kill()
		current_tween = null
	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_SINE)
	current_tween.set_ease(Tween.EASE_OUT)
	var shown_panel: Control = messages_panel if active_tab == TAG_MESSAGES else gallery_panel
	var hidden_panel: Control = gallery_panel if active_tab == TAG_MESSAGES else messages_panel
	shown_panel.visible = true
	shown_panel.modulate.a = 0.0
	current_tween.tween_property(hidden_panel, "modulate:a", 0.0, 0.12)
	current_tween.parallel().tween_property(shown_panel, "modulate:a", 1.0, 0.12)
	current_tween.finished.connect(func(): _messages_set_visible(active_tab == TAG_MESSAGES); _gallery_set_visible(active_tab == TAG_GALLERY))

func _refresh_nav_button_styles() -> void:
	if messages_button == null or gallery_button == null:
		return
	messages_button.button_pressed = active_tab == TAG_MESSAGES
	gallery_button.button_pressed = active_tab == TAG_GALLERY
	messages_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.nav_style(false))
	messages_button.add_theme_stylebox_override("hover", PORTRAIT_THEME.nav_style(false))
	messages_button.add_theme_stylebox_override("pressed", PORTRAIT_THEME.nav_style(true))
	messages_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	gallery_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.nav_style(false))
	gallery_button.add_theme_stylebox_override("hover", PORTRAIT_THEME.nav_style(false))
	gallery_button.add_theme_stylebox_override("pressed", PORTRAIT_THEME.nav_style(true))
	gallery_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())

func _messages_set_visible(value: bool) -> void:
	messages_panel.visible = value
	messages_panel.modulate.a = 1.0 if value else 0.0

func _gallery_set_visible(value: bool) -> void:
	gallery_panel.visible = value
	gallery_panel.modulate.a = 1.0 if value else 0.0
