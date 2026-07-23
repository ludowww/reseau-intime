extends Button

class_name GalleryTile

signal photo_requested(item_id: String)
signal navigation_requested(tile_index: int, horizontal_step: int, vertical_step: int)

var item_id := ""
var tile_index := -1
var _access_state := "UNLOCKED"
var _is_new := false
var _thumbnail_label := ""
var new_badge: Label

func configure(item: Dictionary, accent: Color, portrait_theme, index: int) -> void:
	item_id = str(item.get("item_id", ""))
	tile_index = index
	_access_state = "LOCKED" if str(item.get("state", "")) == "LOCKED" else "UNLOCKED"
	_is_new = _access_state == "UNLOCKED" and bool(item.get("is_new", false))
	_thumbnail_label = "" if is_locked() else str(item.get("thumbnail_label", ""))
	name = "GalleryTile_%s" % item_id
	focus_mode = Control.FOCUS_ALL
	custom_minimum_size = Vector2(96, 128)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_font_size_override("font_size", 15)
	add_theme_color_override("font_color", portrait_theme.TEXT_PRIMARY)
	add_theme_color_override("font_focus_color", portrait_theme.TEXT_PRIMARY)
	add_theme_stylebox_override("focus", portrait_theme.focus_style())
	_build_badge(portrait_theme)
	_refresh_presentation(accent, portrait_theme)
	if not pressed.is_connected(_emit_photo_requested):
		pressed.connect(_emit_photo_requested)
	if not gui_input.is_connected(_on_gui_input):
		gui_input.connect(_on_gui_input)

func display_state() -> String:
	if is_locked():
		return "LOCKED"
	return "NEW" if _is_new else "VIEWED"

func is_locked() -> bool:
	return _access_state == "LOCKED"

func is_new() -> bool:
	return not is_locked() and _is_new

func mark_viewed() -> bool:
	if not is_new():
		return false
	_is_new = false
	if new_badge != null:
		new_badge.visible = false
	return true

func new_badge_visible() -> bool:
	return new_badge != null and new_badge.visible

func locked_copy_visible() -> bool:
	return is_locked() and text == "🔒\nPhoto verrouillée"

func displayed_primary_text() -> String:
	return text

func set_tile_width(width: float) -> void:
	custom_minimum_size = Vector2(max(48.0, width), max(64.0, width / 0.75))

func _build_badge(portrait_theme) -> void:
	if new_badge != null and is_instance_valid(new_badge):
		remove_child(new_badge)
		new_badge.queue_free()
	new_badge = Label.new()
	new_badge.name = "NewBadge"
	new_badge.text = "Nouveau"
	new_badge.focus_mode = Control.FOCUS_NONE
	new_badge.mouse_filter = Control.MOUSE_FILTER_IGNORE
	new_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	new_badge.add_theme_font_size_override("font_size", 13)
	new_badge.add_theme_color_override("font_color", portrait_theme.TEXT_PRIMARY)
	new_badge.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	new_badge.offset_left = 8.0
	new_badge.offset_top = -32.0
	new_badge.offset_right = -8.0
	new_badge.offset_bottom = -8.0
	add_child(new_badge)

func _refresh_presentation(accent: Color, portrait_theme) -> void:
	if is_locked():
		text = "🔒\nPhoto verrouillée"
		tooltip_text = ""
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		var neutral: Color = portrait_theme.BORDER
		var locked_fill: Color = Color(0.075, 0.085, 0.12)
		add_theme_stylebox_override("normal", _tile_style(locked_fill, neutral))
		add_theme_stylebox_override("hover", _tile_style(locked_fill, neutral))
		add_theme_stylebox_override("pressed", _tile_style(locked_fill, neutral))
	else:
		text = _thumbnail_label
		tooltip_text = _thumbnail_label
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		add_theme_stylebox_override("normal", _tile_style(Color(0.08, 0.11, 0.18), accent))
		add_theme_stylebox_override("hover", _tile_style(Color(0.12, 0.16, 0.24), accent))
		add_theme_stylebox_override("pressed", _tile_style(Color(0.16, 0.21, 0.30), accent))
	new_badge.visible = is_new()

func _emit_photo_requested() -> void:
	if is_locked():
		return
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
