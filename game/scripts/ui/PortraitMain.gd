extends Control

class_name PortraitMain

const UnifiedSeasonRunner := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonRunner.gd"
)
const PRODUCTION_CATALOG_PATH := "res://data/unified_runtime/catalogs/season_1_v1.json"

@export var unified_save_path_override := ""
@export var unified_catalog_path_override := ""

@onready var shell := get_node_or_null("PortraitShell")

var runtime_session
var season_runner
var unified_runtime_result: Dictionary = {}

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	if shell != null:
		shell.set_anchors_preset(Control.PRESET_FULL_RECT)
		if shell.content_mode == "unified":
			var catalog_path := (
				PRODUCTION_CATALOG_PATH
				if unified_catalog_path_override.is_empty() else unified_catalog_path_override
			)
			unified_runtime_result = UnifiedSeasonRunner.create(
				catalog_path,
				shell,
				unified_save_path_override,
				"season_1_v1" if unified_catalog_path_override.is_empty() else "",
				"season_1" if unified_catalog_path_override.is_empty() else "",
			)
			if not unified_runtime_result.get("ok", false):
				push_error(
					"Unified player runtime refused: %s"
					% str(unified_runtime_result.get("error_code", "UNKNOWN"))
				)
				return
			season_runner = unified_runtime_result["runner"]
			season_runner.active_session_changed.connect(_on_active_session_changed)
			runtime_session = season_runner.active_session
			if runtime_session != null and not shell.configure_unified_runtime(runtime_session):
				push_error("Unified player runtime shell configuration refused")
				runtime_session = null
				return
			if runtime_session == null:
				shell.clear_unified_runtime(
					season_runner.presentation_source(), season_runner.gallery_source(), season_runner
				)
			var begun: Dictionary = season_runner.begin()
			if not begun.get("ok", false):
				push_error(
					"Unified player runtime start refused: %s"
					% str(begun.get("error_code", "UNKNOWN"))
				)
				shell.clear_unified_runtime()
				runtime_session = null
				return


func _on_active_session_changed(_previous_session, next_session) -> void:
	if shell == null:
		return
	runtime_session = next_session
	if next_session == null:
		shell.clear_unified_runtime(
			season_runner.presentation_source(), season_runner.gallery_source(), season_runner
		)
		return
	shell.clear_unified_runtime(
		season_runner.presentation_source(), season_runner.gallery_source(), season_runner
	)
	if not shell.configure_unified_runtime(next_session):
		push_error("Unified player runtime shell handoff refused")
		runtime_session = null

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
	state["unified_runtime_active"] = season_runner != null
	state["unified_runtime"] = season_runner.describe_state() if season_runner != null else {}
	return state
