extends Control

class_name PortraitMain

const UnifiedCompositionRoot := preload(
	"res://scripts/unified_runtime/bootstrap/UnifiedPlayerRuntimeCompositionRoot.gd"
)

@export var unified_save_path_override := ""

@onready var shell := get_node_or_null("PortraitShell")

var runtime_session
var unified_runtime_result: Dictionary = {}

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	if shell != null:
		shell.set_anchors_preset(Control.PRESET_FULL_RECT)
		if shell.content_mode == "unified":
			unified_runtime_result = UnifiedCompositionRoot.compose(
				shell, unified_save_path_override
			)
			if not unified_runtime_result.get("ok", false):
				push_error(
					"Unified player runtime refused: %s"
					% str(unified_runtime_result.get("error_code", "UNKNOWN"))
				)
				return
			runtime_session = unified_runtime_result["session"]
			if not shell.configure_unified_runtime(runtime_session):
				push_error("Unified player runtime shell configuration refused")
				runtime_session = null
				return
			var begun: Dictionary = runtime_session.begin()
			if not begun.get("ok", false):
				push_error(
					"Unified player runtime start refused: %s"
					% str(begun.get("error_code", "UNKNOWN"))
				)
				shell.clear_unified_runtime()
				runtime_session = null
				return

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
	state["unified_runtime_active"] = runtime_session != null
	state["unified_runtime"] = runtime_session.describe_state() if runtime_session != null else {}
	return state
