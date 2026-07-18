extends Control

class_name PortraitMain

@onready var shell := get_node_or_null("PortraitShell")

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	if shell != null:
		shell.set_anchors_preset(Control.PRESET_FULL_RECT)

func set_safe_area_preset(preset: String) -> void:
	if shell != null:
		shell.set_safe_area_preset(preset)

func set_safe_area_override(rect: Rect2i) -> void:
	if shell != null:
		shell.set_safe_area_override(rect)

func set_reduced_motion_enabled(enabled: bool) -> void:
	if shell != null:
		shell.set_reduced_motion_enabled(enabled)

func describe_state() -> Dictionary:
	if shell == null:
		return {}
	var state: Dictionary = shell.describe_layout()
	state["safe_area_mode"] = shell.safe_area_container.safe_area_mode
	state["safe_area_preset"] = shell.safe_area_container.test_safe_area_preset
	state["reduced_motion_enabled"] = shell.reduced_motion_enabled
	return state
