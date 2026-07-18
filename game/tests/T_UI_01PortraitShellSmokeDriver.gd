extends Node

const DEMO_SCENE := preload("res://scenes/portrait/PortraitShellDemo.tscn")

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var demo := DEMO_SCENE.instantiate()
	add_child(demo)
	await get_tree().process_frame
	await get_tree().process_frame
	var shell = demo.shell
	_expect(shell != null, "demo shell is missing")
	if shell == null:
		_finish()
		return
	var expected_demo_size: Vector2i = _parse_size(_read_cmdline_value("--demo-size", ""))
	var expected_safe_area_preset: String = _read_cmdline_value("--safe-area", "platform")
	var state: Dictionary = demo.describe_state()
	_expect(Vector2i(state.get("viewport_size", Vector2i.ZERO)) == expected_demo_size, "viewport size must match --demo-size")
	_expect(str(state.get("safe_area_mode", "")) in ["platform", "preset", "custom_override"], "safe area mode must be explicit")
	_expect(str(state.get("safe_area_preset", "")) == expected_safe_area_preset, "safe area preset must match the run preset")
	_expect(str(state.get("active_tab", "")) == "messages", "launch must default to Messages")
	_expect(bool(state.get("messages_visible", false)), "Messages panel must be visible on launch")
	_expect(not bool(state.get("gallery_visible", true)), "Galerie panel must be hidden on launch")
	_expect(bool(state.get("reduced_motion_enabled", false)), "Reduced motion must default to enabled")
	_expect(bool(state.get("messages_button_pressed", false)), "Messages button must be visually active on launch")
	_expect(not bool(state.get("gallery_button_pressed", true)), "Galerie button must be visually inactive on launch")
	_expect(shell.messages_button.has_focus(), "Messages button must own focus on launch")
	_validate_layout(shell, expected_demo_size, _expected_safe_padding(expected_safe_area_preset))
	var custom_override := Rect2i(Vector2i(11, 17), Vector2i(max(0, expected_demo_size.x - 34), max(0, expected_demo_size.y - 46)))
	shell.set_safe_area_override(custom_override)
	await get_tree().process_frame
	var custom_state: Dictionary = demo.describe_state()
	_expect(str(custom_state.get("safe_area_mode", "")) == "custom_override", "safe area mode must switch to custom_override")
	var custom_safe_padding: Rect2i = custom_state.get("safe_padding", Rect2i())
	_expect(custom_safe_padding == Rect2i(Vector2i(11, 17), Vector2i(23, 29)), "custom override safe padding must match the explicit margins")
	_validate_layout(shell, expected_demo_size, Rect2i(Vector2i(11, 17), Vector2i(23, 29)))
	shell.set_safe_area_preset("platform")
	await get_tree().process_frame
	var platform_state: Dictionary = demo.describe_state()
	_expect(str(platform_state.get("safe_area_mode", "")) == "platform", "safe area mode must return to platform")
	var platform_safe_padding: Rect2i = platform_state.get("safe_padding", Rect2i())
	_expect(platform_safe_padding == Rect2i(Vector2i.ZERO, Vector2i.ZERO), "platform safe padding must be zero on desktop/headless")
	_validate_layout(shell, expected_demo_size, Rect2i(Vector2i.ZERO, Vector2i.ZERO))
	shell.set_safe_area_preset(expected_safe_area_preset)
	await get_tree().process_frame
	var preset_state: Dictionary = demo.describe_state()
	_expect(str(preset_state.get("safe_area_mode", "")) == "preset", "safe area mode must return to preset")
	_expect(str(preset_state.get("safe_area_preset", "")) == expected_safe_area_preset, "safe area preset must be restored")
	var preset_safe_padding: Rect2i = preset_state.get("safe_padding", Rect2i())
	_expect(preset_safe_padding == _expected_safe_padding(expected_safe_area_preset), "preset safe padding must match the run preset")
	_validate_layout(shell, expected_demo_size, _expected_safe_padding(expected_safe_area_preset))
	var right_key := InputEventKey.new()
	right_key.pressed = true
	right_key.keycode = KEY_RIGHT
	shell._unhandled_input(right_key)
	await get_tree().process_frame
	await get_tree().process_frame
	var after_keyboard: Dictionary = demo.describe_state()
	_expect(str(after_keyboard.get("active_tab", "")) == "gallery", "Keyboard activation must reach Galerie")
	_expect(not bool(after_keyboard.get("messages_button_pressed", true)), "Messages button must become visually inactive in Galerie")
	_expect(bool(after_keyboard.get("gallery_button_pressed", false)), "Galerie button must become visually active in Galerie")
	_expect(shell.gallery_button.has_focus(), "Galerie button must own focus after keyboard activation")
	_expect(bool(after_keyboard.get("gallery_visible", false)), "Galerie panel must become visible")
	_expect(not bool(after_keyboard.get("messages_visible", true)), "Messages panel must hide when Galerie opens")
	_validate_layout(shell, expected_demo_size, _expected_safe_padding(expected_safe_area_preset))
	shell.gallery_button.emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame
	var after_mouse: Dictionary = demo.describe_state()
	_expect(str(after_mouse.get("active_tab", "")) == "gallery", "Mouse press should keep Galerie active")
	_expect(not bool(after_mouse.get("messages_button_pressed", true)), "Messages button must stay visually inactive in Galerie")
	_expect(bool(after_mouse.get("gallery_button_pressed", false)), "Galerie button must stay visually active in Galerie")
	shell.messages_button.emit_signal("pressed")
	await get_tree().process_frame
	await get_tree().process_frame
	var after_return: Dictionary = demo.describe_state()
	_expect(str(after_return.get("active_tab", "")) == "messages", "Mouse press must return to Messages")
	_expect(bool(after_return.get("messages_button_pressed", false)), "Messages button must recover visual activity")
	_expect(not bool(after_return.get("gallery_button_pressed", true)), "Galerie button must become visually inactive after return")
	_expect(shell.messages_button.has_focus(), "Messages button must recover focus after return")
	_validate_layout(shell, expected_demo_size, _expected_safe_padding(expected_safe_area_preset))
	shell.set_reduced_motion_enabled(false)
	var animated_state: Dictionary = demo.describe_state()
	_expect(not bool(animated_state.get("reduced_motion_enabled", true)), "Reduced motion must be disableable for transition testing")
	shell.activate_gallery(true)
	var immediate_transition_state: Dictionary = demo.describe_state()
	_expect(bool(immediate_transition_state.get("transition_running", false)), "Animated transition must run immediately after activate_gallery(true)")
	shell.set_reduced_motion_enabled(true)
	await get_tree().process_frame
	var after_reduced_motion: Dictionary = demo.describe_state()
	_expect(bool(after_reduced_motion.get("gallery_visible", false)), "Gallery must remain visible after reduced motion interruption")
	_expect(not bool(after_reduced_motion.get("messages_visible", true)), "Messages must remain hidden after reduced motion interruption")
	_expect(not bool(after_reduced_motion.get("transition_running", true)), "Tween must stop after reduced motion is enabled")
	_expect(float(after_reduced_motion.get("messages_alpha", -1.0)) == 0.0, "Messages alpha must snap to the final value")
	_expect(float(after_reduced_motion.get("gallery_alpha", -1.0)) == 1.0, "Gallery alpha must snap to the final value")
	_expect(not bool(after_reduced_motion.get("messages_button_pressed", true)), "Only one tab may remain visually active after reduced motion")
	_expect(bool(after_reduced_motion.get("gallery_button_pressed", false)), "Only Galerie may remain visually active after reduced motion")
	_validate_layout(shell, expected_demo_size, _expected_safe_padding(expected_safe_area_preset))
	if failures.is_empty():
		print("T-UI-01A portrait shell smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-01A portrait shell smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)

func _validate_layout(shell, expected_demo_size: Vector2i, expected_safe_padding: Rect2i) -> void:
	var state: Dictionary = shell.describe_layout()
	var safe_padding: Rect2i = state.get("safe_padding", Rect2i())
	var visible_bounds: Rect2i = state.get("visible_bounds", Rect2i())
	var messages_rect: Rect2 = state.get("messages_button_rect", Rect2())
	var gallery_rect: Rect2 = state.get("gallery_button_rect", Rect2())
	var viewport_size: Vector2i = state.get("viewport_size", Vector2i.ZERO)
	_expect(viewport_size == expected_demo_size, "Viewport size must follow the demo size for each run")
	_expect(safe_padding == expected_safe_padding, "Safe padding must match the selected preset")
	var visual_left: int = int(shell.safe_area_container.visual_padding_left)
	var visual_top: int = int(shell.safe_area_container.visual_padding_top)
	var visual_right: int = int(shell.safe_area_container.visual_padding_right)
	var visual_bottom: int = int(shell.safe_area_container.visual_padding_bottom)
	var visible_left: int = safe_padding.position.x + visual_left
	var visible_top: int = safe_padding.position.y + visual_top
	var visible_right: int = viewport_size.x - safe_padding.size.x - visual_right
	var visible_bottom: int = viewport_size.y - safe_padding.size.y - visual_bottom
	var expected_bounds := Rect2i(Vector2i(visible_left, visible_top), Vector2i(max(0, viewport_size.x - visible_left - (safe_padding.size.x + visual_right)), max(0, viewport_size.y - visible_top - (safe_padding.size.y + visual_bottom))))
	_expect(messages_rect.position.x >= visible_left, "Messages button must stay inside safe area on the left")
	_expect(messages_rect.position.y >= visible_top, "Messages button must stay inside safe area on the top")
	_expect(messages_rect.end.x <= visible_right, "Messages button must stay inside safe area on the right")
	_expect(messages_rect.end.y <= visible_bottom, "Messages button must stay inside safe area on the bottom")
	_expect(gallery_rect.position.x >= visible_left, "Galerie button must stay inside safe area on the left")
	_expect(gallery_rect.position.y >= visible_top, "Galerie button must stay inside safe area on the top")
	_expect(gallery_rect.end.x <= visible_right, "Galerie button must stay inside safe area on the right")
	_expect(gallery_rect.end.y <= visible_bottom, "Galerie button must stay inside safe area on the bottom")
	_expect(visible_bounds.size.x > 0 and visible_bounds.size.y > 0, "Visible bounds must stay positive")
	_expect(visible_bounds == expected_bounds, "Visible bounds must equal viewport minus safe padding and visual padding")
	_expect(visible_bounds.position.x >= 0 and visible_bounds.position.y >= 0, "Visible bounds must not be negative")
	_expect(visible_bounds.end.x <= viewport_size.x and visible_bounds.end.y <= viewport_size.y, "Visible bounds must not exceed viewport")

func _expected_safe_padding(preset: String) -> Rect2i:
	match preset:
		"none":
			return Rect2i(Vector2i.ZERO, Vector2i.ZERO)
		"top-notch":
			return Rect2i(Vector2i(0, 72), Vector2i(0, 0))
		"bottom-reserved":
			return Rect2i(Vector2i.ZERO, Vector2i(0, 96))
		"tall-portrait":
			return Rect2i(Vector2i(0, 48), Vector2i(0, 88))
		_:
			return Rect2i(Vector2i.ZERO, Vector2i.ZERO)

func _read_cmdline_value(prefix: String, default_value: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="):
			return arg.trim_prefix(prefix + "=")
	return default_value

func _parse_size(text: String) -> Vector2i:
	var parts := text.split("x")
	if parts.size() != 2:
		return Vector2i.ZERO
	return Vector2i(max(0, int(parts[0])), max(0, int(parts[1])))

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _finish() -> void:
	if failures.is_empty():
		print("T-UI-01A portrait shell smoke: OK")
		get_tree().quit(0)
	else:
		for failure in failures:
			push_error(failure)
		print("T-UI-01A portrait shell smoke: FAILED (%d)" % failures.size())
		get_tree().quit(1)
