extends MarginContainer

class_name SafeAreaContainer

signal safe_area_updated(safe_padding: Rect2i)

var visual_padding_left := 24
var visual_padding_top := 32
var visual_padding_right := 24
var visual_padding_bottom := 48
var test_safe_area_preset := "none"
var safe_area_mode := "platform"
var safe_area_override_enabled := false
var safe_area_override := Rect2i()
var current_safe_padding := Rect2i()

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	call_deferred("refresh_safe_area")

func set_visual_padding(left: int, top: int, right: int, bottom: int) -> void:
	visual_padding_left = max(0, left)
	visual_padding_top = max(0, top)
	visual_padding_right = max(0, right)
	visual_padding_bottom = max(0, bottom)
	refresh_safe_area()

func set_test_safe_area_override(rect: Rect2i) -> void:
	safe_area_mode = "custom_override"
	safe_area_override_enabled = true
	safe_area_override = rect
	refresh_safe_area()

func clear_test_safe_area_override() -> void:
	safe_area_mode = "platform"
	safe_area_override_enabled = false
	safe_area_override = Rect2i()
	refresh_safe_area()

func set_test_safe_area_preset(preset: String) -> void:
	test_safe_area_preset = preset
	if preset == "platform":
		safe_area_mode = "platform"
		safe_area_override_enabled = false
		safe_area_override = Rect2i()
		refresh_safe_area()
		return
	safe_area_mode = "preset"
	safe_area_override_enabled = false
	refresh_safe_area()

func refresh_safe_area() -> void:
	var viewport_size := _viewport_size()
	var safe_area := _active_safe_area(viewport_size)
	current_safe_padding = _safe_padding_for(viewport_size, safe_area)
	add_theme_constant_override("margin_left", current_safe_padding.position.x + visual_padding_left)
	add_theme_constant_override("margin_top", current_safe_padding.position.y + visual_padding_top)
	add_theme_constant_override("margin_right", current_safe_padding.size.x + visual_padding_right)
	add_theme_constant_override("margin_bottom", current_safe_padding.size.y + visual_padding_bottom)
	safe_area_updated.emit(current_safe_padding)

func get_safe_padding() -> Rect2i:
	return current_safe_padding

func get_visible_bounds() -> Rect2i:
	var viewport_size: Vector2i = _viewport_size()
	var left: int = current_safe_padding.position.x + visual_padding_left
	var top: int = current_safe_padding.position.y + visual_padding_top
	var right: int = current_safe_padding.size.x + visual_padding_right
	var bottom: int = current_safe_padding.size.y + visual_padding_bottom
	return Rect2i(Vector2i(left, top), Vector2i(max(0, viewport_size.x - left - right), max(0, viewport_size.y - top - bottom)))

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		refresh_safe_area()

func _viewport_size() -> Vector2i:
	var rect := get_viewport_rect().size
	return Vector2i(max(1, int(round(rect.x))), max(1, int(round(rect.y))))

func _active_safe_area(viewport_size: Vector2i) -> Rect2i:
	if safe_area_mode == "custom_override":
		return _normalized_safe_area(safe_area_override, viewport_size)
	if safe_area_mode == "preset":
		return _normalized_safe_area(_preset_safe_area_for(viewport_size, test_safe_area_preset), viewport_size)
	return _platform_safe_area(viewport_size)

func _preset_safe_area_for(viewport_size: Vector2i, preset: String) -> Rect2i:
	match preset:
		"none":
			return Rect2i(Vector2i.ZERO, viewport_size)
		"top-notch":
			return Rect2i(Vector2i(0, 72), Vector2i(viewport_size.x, max(0, viewport_size.y - 72)))
		"bottom-reserved":
			return Rect2i(Vector2i.ZERO, Vector2i(viewport_size.x, max(0, viewport_size.y - 96)))
		"tall-portrait":
			return Rect2i(Vector2i(0, 48), Vector2i(viewport_size.x, max(0, viewport_size.y - 136)))
		_:
			return Rect2i(Vector2i.ZERO, viewport_size)

func _platform_safe_area(viewport_size: Vector2i) -> Rect2i:
	if not OS.has_feature("mobile"):
		return Rect2i(Vector2i.ZERO, viewport_size)
	if not DisplayServer.has_method("get_display_safe_area"):
		return Rect2i(Vector2i.ZERO, viewport_size)
	var raw: Variant = DisplayServer.call("get_display_safe_area")
	var display_rect := Rect2i()
	if raw is Rect2i:
		display_rect = raw
	elif raw is Rect2:
		var raw_rect: Rect2 = raw
		display_rect = Rect2i(Vector2i(int(round(raw_rect.position.x)), int(round(raw_rect.position.y))), Vector2i(int(round(raw_rect.size.x)), int(round(raw_rect.size.y))))
	else:
		return Rect2i(Vector2i.ZERO, viewport_size)
	var window := get_window()
	if window == null:
		return Rect2i(Vector2i.ZERO, viewport_size)
	var window_rect := Rect2i(Vector2i(int(window.position.x), int(window.position.y)), Vector2i(max(1, int(window.size.x)), max(1, int(window.size.y))))
	var inter_left: int = max(display_rect.position.x, window_rect.position.x)
	var inter_top: int = max(display_rect.position.y, window_rect.position.y)
	var inter_right: int = min(display_rect.end.x, window_rect.end.x)
	var inter_bottom: int = min(display_rect.end.y, window_rect.end.y)
	if inter_right <= inter_left or inter_bottom <= inter_top:
		return Rect2i(Vector2i.ZERO, viewport_size)
	var local_rect := Rect2i(Vector2i(inter_left - window_rect.position.x, inter_top - window_rect.position.y), Vector2i(inter_right - inter_left, inter_bottom - inter_top))
	var scale_x := float(viewport_size.x) / float(max(1, window_rect.size.x))
	var scale_y := float(viewport_size.y) / float(max(1, window_rect.size.y))
	var scaled := Rect2i(
		Vector2i(int(round(local_rect.position.x * scale_x)), int(round(local_rect.position.y * scale_y))),
		Vector2i(int(round(local_rect.size.x * scale_x)), int(round(local_rect.size.y * scale_y)))
	)
	return _normalized_safe_area(scaled, viewport_size)

func _normalized_safe_area(rect: Rect2i, viewport_size: Vector2i) -> Rect2i:
	var origin := Vector2i(clampi(rect.position.x, 0, viewport_size.x), clampi(rect.position.y, 0, viewport_size.y))
	var end_x := clampi(rect.end.x, 0, viewport_size.x)
	var end_y := clampi(rect.end.y, 0, viewport_size.y)
	if end_x < origin.x:
		end_x = origin.x
	if end_y < origin.y:
		end_y = origin.y
	return Rect2i(origin, Vector2i(end_x - origin.x, end_y - origin.y))

func _safe_padding_for(viewport_size: Vector2i, safe_area: Rect2i) -> Rect2i:
	var left := clampi(max(0, safe_area.position.x), 0, viewport_size.x)
	var top := clampi(max(0, safe_area.position.y), 0, viewport_size.y)
	var right := clampi(max(0, viewport_size.x - safe_area.end.x), 0, viewport_size.x)
	var bottom := clampi(max(0, viewport_size.y - safe_area.end.y), 0, viewport_size.y)
	return Rect2i(Vector2i(left, top), Vector2i(right, bottom))
