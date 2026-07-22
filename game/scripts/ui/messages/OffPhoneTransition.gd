extends PanelContainer

class_name OffPhoneTransition

signal resume_requested

var PORTRAIT_THEME
var resume_button: Button
var current_tween: Tween
var display_label := ""

func configure(label: String, portrait_theme, reduced_motion: bool) -> void:
	PORTRAIT_THEME = portrait_theme
	display_label = label
	_build()
	visible = true
	if reduced_motion:
		modulate.a = 1.0
	else:
		modulate.a = 0.0
		current_tween = create_tween()
		current_tween.set_trans(Tween.TRANS_SINE)
		current_tween.set_ease(Tween.EASE_OUT)
		current_tween.tween_property(self, "modulate:a", 1.0, 0.2)
	resume_button.call_deferred("grab_focus")

func dismiss() -> void:
	if current_tween != null and current_tween.is_running():
		current_tween.kill()
	current_tween = null
	modulate.a = 1.0
	visible = false

func animation_running() -> bool:
	return current_tween != null and current_tween.is_running()

func action_has_focus() -> bool:
	return resume_button != null and resume_button.has_focus()

func action_count() -> int:
	return find_children("ResumeThread", "Button", true, false).size()

func action_height() -> float:
	return resume_button.custom_minimum_size.y if resume_button != null else 0.0

func has_horizontal_crop() -> bool:
	if resume_button == null:
		return false
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
	name = "OffPhoneTransition"
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.BACKGROUND_DEEP, 1, 24))

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(center)

	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(420, 330)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE_RAISED, 1, 24))
	center.add_child(card)

	var column := VBoxContainer.new()
	column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.add_theme_constant_override("separation", 18)
	card.add_child(column)

	var icon := _label("◌", 38, PORTRAIT_THEME.FOCUS)
	icon.name = "OffPhoneIcon"
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(icon)

	var title := _label("Présence hors téléphone", 26, PORTRAIT_THEME.TEXT_PRIMARY)
	title.name = "OffPhoneTitle"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(title)

	var body := _label(display_label, 19, PORTRAIT_THEME.TEXT_PRIMARY)
	body.name = "OffPhoneLabel"
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(body)

	var explanation := _label("La messagerie reste en pause pendant ce moment partagé.", 16, PORTRAIT_THEME.TEXT_SECONDARY)
	explanation.name = "OffPhoneExplanation"
	explanation.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(explanation)

	resume_button = Button.new()
	resume_button.name = "ResumeThread"
	resume_button.text = "Reprendre le fil"
	resume_button.tooltip_text = "Revenir à la conversation de démonstration"
	resume_button.custom_minimum_size = Vector2(0, 48)
	resume_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	resume_button.focus_mode = Control.FOCUS_ALL
	resume_button.add_theme_font_size_override("font_size", 18)
	resume_button.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	resume_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.17, 0.12, 0.28), PORTRAIT_THEME.PLAYER_ACCENT, 16))
	resume_button.add_theme_stylebox_override("hover", PORTRAIT_THEME.button_style(Color(0.21, 0.15, 0.34), PORTRAIT_THEME.FOCUS, 16))
	resume_button.add_theme_stylebox_override("pressed", PORTRAIT_THEME.button_style(Color(0.12, 0.09, 0.22), PORTRAIT_THEME.PLAYER_ACCENT, 16))
	resume_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	resume_button.pressed.connect(func(): resume_requested.emit())
	column.add_child(resume_button)

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label
