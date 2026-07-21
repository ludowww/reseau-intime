extends HBoxContainer

class_name TypingIndicator

const PHASES: Array[String] = [".", "..", "..."]
const PHASE_SECONDS := 0.36

var PORTRAIT_THEME
var phase_index := 0
var phase_timer: Timer
var dots_label: Label
var avatar_label: Label
var group_mode := false
var author_accent := Color.WHITE

func configure(author: Dictionary, group_conversation: bool, portrait_theme, reduced_motion: bool) -> void:
	PORTRAIT_THEME = portrait_theme
	group_mode = group_conversation
	author_accent = Color.from_string(str(author.get("accent_color", "#8D63E6")), PORTRAIT_THEME.PLAYER_ACCENT)
	_build(author)
	phase_index = 0
	if reduced_motion:
		dots_label.text = "…"
	else:
		dots_label.text = PHASES[0]
		phase_timer.start(PHASE_SECONDS)

func stop_animation() -> void:
	if phase_timer != null:
		phase_timer.stop()

func animation_running() -> bool:
	return phase_timer != null and not phase_timer.is_stopped()

func advance_typing_phase() -> void:
	if animation_running():
		_advance_visual_phase()

func indicator_text() -> String:
	return dots_label.text if dots_label != null else ""

func avatar_text() -> String:
	return avatar_label.text if avatar_label != null and avatar_label.visible else ""

func accent_is_visible() -> bool:
	return group_mode and avatar_label != null and avatar_label.visible

func has_time_label() -> bool:
	return false

func _exit_tree() -> void:
	stop_animation()

func _build(author: Dictionary) -> void:
	stop_animation()
	for child in get_children():
		remove_child(child)
		child.queue_free()
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

	dots_label = Label.new()
	dots_label.name = "TypingDots"
	dots_label.text = "…"
	dots_label.custom_minimum_size = Vector2(52, 26)
	dots_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dots_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	dots_label.focus_mode = Control.FOCUS_NONE
	dots_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dots_label.add_theme_font_size_override("font_size", 18)
	dots_label.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	bubble.add_child(dots_label)

	var spacer := Control.new()
	spacer.focus_mode = Control.FOCUS_NONE
	spacer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(spacer)

	phase_timer = Timer.new()
	phase_timer.name = "VisualPhaseTimer"
	phase_timer.one_shot = false
	phase_timer.wait_time = PHASE_SECONDS
	phase_timer.timeout.connect(_advance_visual_phase)
	add_child(phase_timer)

func _advance_visual_phase() -> void:
	phase_index = (phase_index + 1) % PHASES.size()
	if dots_label != null:
		dots_label.text = PHASES[phase_index]
