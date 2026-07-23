extends Button

class_name GalleryTile

signal photo_requested(item_id: String)
signal navigation_requested(tile_index: int, horizontal_step: int, vertical_step: int)

var item_id := ""
var tile_index := -1

func configure(item: Dictionary, accent: Color, portrait_theme, index: int) -> void:
	item_id = str(item.get("item_id", ""))
	tile_index = index
	name = "GalleryTile_%s" % item_id
	text = str(item.get("thumbnail_label", "Photo démo"))
	tooltip_text = text
	focus_mode = Control.FOCUS_ALL
	custom_minimum_size = Vector2(96, 128)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_font_size_override("font_size", 15)
	add_theme_color_override("font_color", portrait_theme.TEXT_PRIMARY)
	add_theme_color_override("font_focus_color", portrait_theme.TEXT_PRIMARY)
	add_theme_stylebox_override("normal", _tile_style(Color(0.08, 0.11, 0.18), accent))
	add_theme_stylebox_override("hover", _tile_style(Color(0.12, 0.16, 0.24), accent))
	add_theme_stylebox_override("pressed", _tile_style(Color(0.16, 0.21, 0.30), accent))
	add_theme_stylebox_override("focus", portrait_theme.focus_style())
	if not pressed.is_connected(_emit_photo_requested):
		pressed.connect(_emit_photo_requested)
	if not gui_input.is_connected(_on_gui_input):
		gui_input.connect(_on_gui_input)

func set_tile_width(width: float) -> void:
	custom_minimum_size = Vector2(max(48.0, width), max(64.0, width / 0.75))

func _emit_photo_requested() -> void:
	photo_requested.emit(item_id)

func _on_gui_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.keycode == KEY_LEFT:
		navigation_requested.emit(tile_index, -1, 0)
		accept_event()
	elif event.keycode == KEY_RIGHT:
		navigation_requested.emit(tile_index, 1, 0)
		accept_event()
	elif event.keycode == KEY_UP:
		navigation_requested.emit(tile_index, 0, -1)
		accept_event()
	elif event.keycode == KEY_DOWN:
		navigation_requested.emit(tile_index, 0, 1)
		accept_event()

func _tile_style(fill: Color, accent: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = accent
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_left = 14
	style.corner_radius_bottom_right = 14
	style.content_margin_left = 10
	style.content_margin_top = 10
	style.content_margin_right = 10
	style.content_margin_bottom = 10
	return style
