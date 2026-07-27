extends HBoxContainer

class_name TypingIndicator

const DOT_COUNT := 3
const DOT_DIAMETER := 8.0
const WAVE_CYCLE_NORMAL := 1.05
const WAVE_CYCLE_X3 := 0.70
const WAVE_CYCLE_X8 := 0.45
const DOT_PHASE_OFFSET_SECONDS := 0.16

class TypingDot extends Control:
	var dot_color := Color.WHITE

	func _init(color := Color.WHITE) -> void:
		dot_color = color
		custom_minimum_size = Vector2(DOT_DIAMETER, DOT_DIAMETER + 6.0)
		focus_mode = Control.FOCUS_NONE
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _draw() -> void:
		draw_circle(Vector2(size.x * 0.5, size.y * 0.5), DOT_DIAMETER * 0.5, dot_color)

var PORTRAIT_THEME
var animation_elapsed := 0.0
var typing_dots: Array[Control] = []
var avatar_label: Label
var group_mode := false
var author_accent := Color.WHITE
var reduced_motion_enabled := false
var reading_speed_multiplier := 1.0
var wave_cycle_seconds := WAVE_CYCLE_NORMAL

func configure(author: Dictionary, group_conversation: bool, portrait_theme, reduced_motion: bool, speed_multiplier := 1.0) -> void:
	PORTRAIT_THEME = portrait_theme
	group_mode = group_conversation
	reduced_motion_enabled = reduced_motion
	reading_speed_multiplier = speed_multiplier
	wave_cycle_seconds = WAVE_CYCLE_X8 if reading_speed_multiplier >= 8.0 else (WAVE_CYCLE_X3 if reading_speed_multiplier >= 3.0 else WAVE_CYCLE_NORMAL)
	author_accent = Color.from_string(str(author.get("accent_color", "#8D63E6")), PORTRAIT_THEME.PLAYER_ACCENT)
	_build(author)
	animation_elapsed = 0.0
	set_process(not reduced_motion_enabled)
	_apply_visual_wave()

func stop_animation() -> void:
	set_process(false)
	_reset_dots()

func animation_running() -> bool:
	return is_processing() and not reduced_motion_enabled

func advance_typing_phase() -> void:
	if animation_running():
		animation_elapsed = fmod(animation_elapsed + DOT_PHASE_OFFSET_SECONDS, wave_cycle_seconds)
		_apply_visual_wave()

func _process(delta: float) -> void:
	animation_elapsed = fmod(animation_elapsed + delta, wave_cycle_seconds)
	_apply_visual_wave()

func indicator_text() -> String:
	return ""

func avatar_text() -> String:
	return avatar_label.text if avatar_label != null and avatar_label.visible else ""

func accent_is_visible() -> bool:
	return group_mode and avatar_label != null and avatar_label.visible

func has_time_label() -> bool:
	return false

func dot_count() -> int:
	return typing_dots.size()

func graphic_dot_count() -> int:
	return typing_dots.filter(func(dot): return dot is Control and not dot is Label).size()

func has_dot_label() -> bool:
	return find_child("TypingDots", true, false) is Label

func dots_are_static() -> bool:
	return not animation_running() and typing_dots.all(func(dot): return is_equal_approx(dot.position.y, 0.0) and is_equal_approx(dot.scale.x, 1.0) and is_equal_approx(dot.modulate.a, 1.0))

func dot_visual_phases() -> Array:
	var phases: Array = []
	for dot in typing_dots:
		phases.append(Vector3(dot.position.y, dot.scale.x, dot.modulate.a))
	return phases

func has_staggered_phases() -> bool:
	var phases := dot_visual_phases()
	return phases.size() == DOT_COUNT and (phases[0] != phases[1] or phases[1] != phases[2])

func _exit_tree() -> void:
	stop_animation()

func _build(author: Dictionary) -> void:
	stop_animation()
	for child in get_children():
		remove_child(child)
		child.queue_free()
	typing_dots.clear()
	name = "TypingIndicator"
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 8)

	avatar_label = Label.new()
	avatar_label.name = "TypingAuthorAvatar"
	avatar_label.text = str(author.get("avatar_ref", "?"))
	avatar_label.visible = group_mode
	avatar_label.custom_minimum_size = Vector2(32, 32)
	avatar_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	avatar_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	avatar_label.focus_mode = Control.FOCUS_NONE
	avatar_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	avatar_label.add_theme_font_size_override("font_size", 14)
	avatar_label.add_theme_color_override("font_color", author_accent)
	avatar_label.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.06, 0.08, 0.14), author_accent, 16))
	add_child(avatar_label)

	var bubble := PanelContainer.new()
	bubble.name = "TypingBubble"
	bubble.custom_minimum_size = Vector2(76, 42)
	bubble.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	bubble.focus_mode = Control.FOCUS_NONE
	bubble.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bubble.add_theme_stylebox_override("panel", PORTRAIT_THEME.button_style(Color(0.12, 0.14, 0.23), author_accent, 18))
	add_child(bubble)

	var center := CenterContainer.new()
	center.focus_mode = Control.FOCUS_NONE
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bubble.add_child(center)
	var dots_row := HBoxContainer.new()
	dots_row.name = "TypingGraphicDots"
	dots_row.add_theme_constant_override("separation", 7)
	dots_row.focus_mode = Control.FOCUS_NONE
	dots_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	center.add_child(dots_row)
	var dot_color: Color = author_accent.lerp(PORTRAIT_THEME.TEXT_PRIMARY, 0.45)
	for index in range(DOT_COUNT):
		var dot := TypingDot.new(dot_color)
		dot.name = "TypingDot%d" % (index + 1)
		dots_row.add_child(dot)
		typing_dots.append(dot)

	var spacer := Control.new()
	spacer.focus_mode = Control.FOCUS_NONE
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(spacer)

func _apply_visual_wave() -> void:
	for index in range(typing_dots.size()):
		var dot := typing_dots[index]
		if reduced_motion_enabled:
			dot.position.y = 0.0
			dot.scale = Vector2.ONE
			dot.modulate.a = 1.0
		else:
			var local_time := fposmod(animation_elapsed - float(index) * DOT_PHASE_OFFSET_SECONDS, wave_cycle_seconds)
			var angle := local_time / wave_cycle_seconds * TAU
			var pulse := 0.5 + 0.5 * sin(angle)
			dot.position.y = -3.0 * pulse
			var dot_scale := 1.0 + 0.15 * pulse
			dot.scale = Vector2(dot_scale, dot_scale)
			dot.modulate.a = 0.65 + 0.35 * pulse

func _reset_dots() -> void:
	for dot in typing_dots:
		if is_instance_valid(dot):
			dot.position.y = 0.0
			dot.scale = Vector2.ONE
			dot.modulate.a = 1.0
