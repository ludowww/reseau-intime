extends PanelContainer

class_name DayTransition

signal continue_requested

var PORTRAIT_THEME
var continue_button: Button
var current_tween: Tween
var title_text := "La journée se termine"
var subtitle_text := ""
var body_text := "Une nouvelle journée commence dans cette démonstration locale."

func configure(title: String, subtitle: String, body: String, portrait_theme, reduced_motion: bool) -> void:
	PORTRAIT_THEME = portrait_theme
	title_text = title
	subtitle_text = subtitle
	body_text = body
	_build()
	visible = true
	if reduced_motion:
		modulate.a = 1.0
	else:
		modulate.a = 0.0
		current_tween = create_tween()
		current_tween.set_trans(Tween.TRANS_SINE)
		current_tween.set_ease(Tween.EASE_OUT)
		current_tween.tween_property(self, "modulate:a", 1.0, 0.20)
	continue_button.call_deferred("grab_focus")

func dismiss() -> void:
	if current_tween != null and current_tween.is_running():
		current_tween.kill()
	current_tween = null
	modulate.a = 1.0
	visible = false

func reset_surface() -> void:
	dismiss()
	title_text = "La journée se termine"
	subtitle_text = ""
	body_text = ""

func animation_running() -> bool:
	return current_tween != null and current_tween.is_running()

func action_has_focus() -> bool:
	return continue_button != null and continue_button.has_focus()

func action_count() -> int:
	return find_children("ContinueDay", "Button", true, false).size()

func action_height() -> float:
	return continue_button.custom_minimum_size.y if continue_button != null else 0.0

func display_title() -> String:
	return title_text

func display_subtitle() -> String:
	return subtitle_text

func has_horizontal_crop() -> bool:
	for child in find_children("*", "Label", true, false):
		if child is Label and child.size.x > 0.0 and child.get_minimum_size().x > child.size.x + 1.0:
			return true
	return false

func _exit_tree() -> void:
	if current_tween != null and current_tween.is_running():
		current_tween.kill()

func _build() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	name = "DayTransition"
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.BACKGROUND_DEEP, 1, 28))

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(center)

	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(380, 0)
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.add_theme_constant_override("separation", 22)
	center.add_child(column)

	var marker := HSeparator.new()
	marker.name = "DayTransitionMarker"
	marker.custom_minimum_size = Vector2(0, 2)
	marker.add_theme_color_override("separator", PORTRAIT_THEME.FOCUS)
	column.add_child(marker)

	var eyebrow := _label("NOUVELLE JOURNÉE", 14, PORTRAIT_THEME.TEXT_MUTED)
	eyebrow.name = "DayTransitionEyebrow"
	eyebrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(eyebrow)

	var title := _label(title_text, 30, PORTRAIT_THEME.TEXT_PRIMARY)
	title.name = "DayTransitionTitle"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(title)

	var subtitle := _label(subtitle_text, 24, PORTRAIT_THEME.FOCUS)
	subtitle.name = "DayTransitionSubtitle"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(subtitle)

	var body := _label(body_text, 18, PORTRAIT_THEME.TEXT_SECONDARY)
	body.name = "DayTransitionBody"
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(body)

	continue_button = Button.new()
	continue_button.name = "ContinueDay"
	continue_button.text = "Continuer"
	continue_button.tooltip_text = "Afficher la nouvelle journée de démonstration"
	continue_button.custom_minimum_size = Vector2(0, 48)
	continue_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	continue_button.focus_mode = Control.FOCUS_ALL
	continue_button.add_theme_font_size_override("font_size", 18)
	continue_button.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	continue_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.18, 0.13, 0.30), PORTRAIT_THEME.PLAYER_ACCENT, 16))
	continue_button.add_theme_stylebox_override("hover", PORTRAIT_THEME.button_style(Color(0.22, 0.16, 0.36), PORTRAIT_THEME.FOCUS, 16))
	continue_button.add_theme_stylebox_override("pressed", PORTRAIT_THEME.button_style(Color(0.12, 0.09, 0.22), PORTRAIT_THEME.PLAYER_ACCENT, 16))
	continue_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	continue_button.pressed.connect(func(): continue_requested.emit())
	column.add_child(continue_button)

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label
