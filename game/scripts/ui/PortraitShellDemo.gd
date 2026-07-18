extends Control

class_name PortraitShellDemo

const SHELL_SCENE := preload("res://scenes/portrait/PortraitShell.tscn")

var shell

func _ready() -> void:
	call_deferred("_build_demo")

func _build_demo() -> void:
	_apply_window_size()
	for child in get_children():
		if child != shell:
			child.queue_free()
	shell = SHELL_SCENE.instantiate()
	shell.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(shell)
	call_deferred("_apply_cmdline_overrides")

func _apply_window_size() -> void:
	var demo_size := _read_cmdline_value("--demo-size", "")
	if demo_size == "":
		return
	var parsed_size := _parse_size(demo_size)
	if parsed_size.x > 0 and parsed_size.y > 0:
		var window := get_window()
		if window != null:
			window.size = parsed_size

func _apply_cmdline_overrides() -> void:
	if shell == null:
		return
	var safe_area := _read_cmdline_value("--safe-area", "platform")
	shell.set_safe_area_preset(safe_area)
	var reduced_motion := _read_cmdline_value("--reduced-motion", "true")
	shell.set_reduced_motion_enabled(reduced_motion != "false" and reduced_motion != "0")

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

func describe_state() -> Dictionary:
	if shell == null:
		return {}
	var state: Dictionary = shell.describe_layout()
	state["safe_area_mode"] = shell.safe_area_container.safe_area_mode
	state["safe_area_preset"] = shell.safe_area_container.test_safe_area_preset
	state["reduced_motion_enabled"] = shell.reduced_motion_enabled
	return state
