extends Control

class_name LegacyMain

const LEGACY_SIZE := Vector2i(1280, 720)

@onready var main := get_node_or_null("Main") as Control
var legacy_failures: Array[String] = []

func _enter_tree() -> void:
	_apply_legacy_canvas()

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	if main != null:
		main.set_anchors_preset(Control.PRESET_FULL_RECT)
	if _legacy_smoke_requested():
		call_deferred("_run_legacy_smoke")

func _apply_legacy_canvas() -> void:
	var root := get_tree().root
	if root == null:
		return
	root.content_scale_size = Vector2i(1280, 720)
	root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
	var window := get_window()
	if window != null:
		window.size = LEGACY_SIZE

func _legacy_smoke_requested() -> bool:
	for arg in OS.get_cmdline_user_args():
		if str(arg) == "--t-ui-01b-legacy-smoke":
			return true
	return false

func _run_legacy_smoke() -> void:
	await get_tree().process_frame
	var window_size := Vector2i.ZERO
	var configured_scale_size := Vector2i.ZERO
	var actual_viewport_size := Vector2i.ZERO
	var root := get_tree().root
	if get_window() != null:
		window_size = Vector2i(int(round(get_window().size.x)), int(round(get_window().size.y)))
	if root != null:
		configured_scale_size = Vector2i(root.content_scale_size)
		actual_viewport_size = Vector2i(
			int(round(root.get_visible_rect().size.x)),
			int(round(root.get_visible_rect().size.y))
		)
	print("window size: %dx%d" % [window_size.x, window_size.y])
	print("configured scale: %dx%d" % [configured_scale_size.x, configured_scale_size.y])
	print("actual viewport: %dx%d" % [actual_viewport_size.x, actual_viewport_size.y])
	_expect(window_size == LEGACY_SIZE, "window size must match 1280x720")
	_expect(configured_scale_size == LEGACY_SIZE, "configured content scale must match 1280x720")
	_expect(actual_viewport_size == LEGACY_SIZE, "actual legacy viewport must match 1280x720")
	_expect(main != null, "Main.tscn must be instanced")
	_expect(get_tree().root.find_child("PortraitShell", true, false) == null, "PortraitShell must not be instanced in legacy entry")
	if legacy_failures.is_empty():
		print("Main.tscn instanced: yes")
		print("PortraitShell absent: yes")
		print("T-UI-01B legacy smoke: OK")
		get_tree().quit(0)
		return
	for failure in legacy_failures:
		push_error(failure)
	print("Main.tscn instanced: no")
	print("PortraitShell absent: no")
	print("T-UI-01B legacy smoke: FAILED (%d)" % legacy_failures.size())
	get_tree().quit(1)

func _expect(condition: bool, message: String) -> void:
	if not condition:
		legacy_failures.append(message)
