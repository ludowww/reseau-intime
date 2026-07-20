extends VBoxContainer

class_name ChoiceBar

signal choice_selected(choice: Dictionary)

var PORTRAIT_THEME
var choices: Array[Dictionary] = []
var buttons: Array[Button] = []

func configure(choice_presentations: Array[Dictionary], portrait_theme) -> void:
	PORTRAIT_THEME = portrait_theme
	set_choices(choice_presentations)

func set_choices(choice_presentations: Array[Dictionary]) -> void:
	choices = choice_presentations
	if choices.size() < 1 or choices.size() > 3:
		clear_choices()
		return
	_build()

func clear_choices() -> void:
	choices.clear()
	buttons.clear()
	for child in get_children():
		child.queue_free()
	visible = false

func focus_first_choice() -> void:
	var button := _first_enabled_button()
	if button != null:
		button.grab_focus()

func first_choice_has_focus() -> bool:
	var button := _first_enabled_button()
	return button != null and button.has_focus()

func activate_first_choice() -> void:
	var button := _first_enabled_button()
	if button != null:
		button.emit_signal("pressed")

func choice_count() -> int:
	return choices.size()

func has_horizontal_crop() -> bool:
	for button in buttons:
		if button.size.x > 0.0 and button.get_minimum_size().x > button.size.x + 1.0:
			return true
	return false

func _build() -> void:
	for child in get_children():
		child.queue_free()
	buttons.clear()
	name = "ChoiceBar"
	visible = true
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 8)
	for choice in choices:
		add_child(_build_choice_button(choice))
	call_deferred("focus_first_choice")

# ChoiceButton remains fully wrapped and keyboard focusable.
func _build_choice_button(choice: Dictionary) -> Button:
	var button := Button.new()
	button.name = "ChoiceButton"
	button.text = str(choice.get("text", ""))
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.custom_minimum_size = Vector2(0, 50)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.focus_mode = Control.FOCUS_ALL
	button.disabled = not bool(choice.get("enabled", true))
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.12, 0.09, 0.21), PORTRAIT_THEME.PLAYER_ACCENT))
	button.add_theme_stylebox_override("hover", PORTRAIT_THEME.button_style(Color(0.17, 0.12, 0.28), PORTRAIT_THEME.FOCUS))
	button.add_theme_stylebox_override("pressed", PORTRAIT_THEME.button_style(Color(0.21, 0.15, 0.34), PORTRAIT_THEME.PLAYER_ACCENT))
	button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	button.pressed.connect(func(): choice_selected.emit(choice))
	buttons.append(button)
	return button

func _first_enabled_button() -> Button:
	for button in buttons:
		if not button.disabled:
			return button
	return null
