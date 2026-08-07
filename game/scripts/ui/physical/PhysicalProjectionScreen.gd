extends Control

class_name R8CPhysicalProjectionScreen

signal continue_requested
signal withdraw_requested(choice_id: String)
signal presentation_ready

const MODE_NONE := "NONE"
const MODE_TRANSITION := "TRANSITION"
const MODE_PHYSICAL_BEAT := "PHYSICAL_BEAT"

var _mode := MODE_NONE
var _presentation: Dictionary = {}
var _generation := 0
var _reduced_motion := false
var _safe_area_override := Rect2i()
var _safe_area_override_enabled := false
var _content_margin: MarginContainer
var _content_column: VBoxContainer
var _continue_button: Button
var _withdraw_buttons: Array[Button] = []
var _fade_tween: Tween


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_NONE
	z_index = 1000
	visible = false
	_build_surface()


func set_reduced_motion(enabled: bool) -> void:
	_reduced_motion = enabled


func reduced_motion_enabled() -> bool:
	return _reduced_motion


func set_safe_area_override(rect: Rect2i) -> void:
	_safe_area_override = rect
	_safe_area_override_enabled = true
	_apply_safe_area()


func clear_safe_area_override() -> void:
	_safe_area_override_enabled = false
	_safe_area_override = Rect2i()
	_apply_safe_area()


func present_transition(presentation: Dictionary) -> bool:
	if not _has_exact_keys(presentation, ["continuation_label", "transition_id"]):
		return false
	if not _non_empty_string(presentation["transition_id"]):
		return false
	if not _non_empty_string(presentation["continuation_label"]):
		return false
	_mode = MODE_TRANSITION
	_presentation = presentation.duplicate(true)
	_rebuild_content()
	_show_surface()
	return true


func present_physical_beat(presentation: Dictionary) -> bool:
	var expected := [
		"body", "content_ref", "continue_label", "physical_beat_id", "steps", "title",
		"withdrawal_actions",
	]
	if not _has_exact_keys(presentation, expected):
		return false
	for field in ["body", "content_ref", "continue_label", "physical_beat_id", "title"]:
		if not _non_empty_string(presentation[field]):
			return false
	if typeof(presentation["steps"]) != TYPE_ARRAY or presentation["steps"].is_empty():
		return false
	if typeof(presentation["withdrawal_actions"]) != TYPE_ARRAY:
		return false
	for step in presentation["steps"]:
		if not _non_empty_string(step):
			return false
	for action in presentation["withdrawal_actions"]:
		if (
			typeof(action) != TYPE_DICTIONARY
			or not _has_exact_keys(action, ["choice_id", "text"])
			or not _non_empty_string(action["choice_id"])
			or not _non_empty_string(action["text"])
		):
			return false
	_mode = MODE_PHYSICAL_BEAT
	_presentation = presentation.duplicate(true)
	_rebuild_content()
	_show_surface()
	return true


func dismiss() -> void:
	_generation += 1
	if _fade_tween != null and _fade_tween.is_running():
		_fade_tween.kill()
	_fade_tween = null
	modulate.a = 1.0
	visible = false
	_mode = MODE_NONE
	_presentation = {}
	_withdraw_buttons.clear()


func presentation_mode() -> String:
	return _mode


func presentation_data() -> Dictionary:
	return _presentation.duplicate(true)


func withdrawal_choice_ids() -> Array:
	var result: Array = []
	for action in _presentation.get("withdrawal_actions", []):
		result.append(action["choice_id"])
	return result


func withdrawal_texts() -> Array:
	var result: Array = []
	for action in _presentation.get("withdrawal_actions", []):
		result.append(action["text"])
	return result


func action_has_focus() -> bool:
	return _continue_button != null and _continue_button.has_focus()


func action_count() -> int:
	return (1 if _continue_button != null else 0) + _withdraw_buttons.size()


func is_input_blocking() -> bool:
	return visible and mouse_filter == Control.MOUSE_FILTER_STOP


func surface_rect() -> Rect2:
	return get_global_rect() if visible else Rect2()


func has_horizontal_crop() -> bool:
	if not visible:
		return false
	for label in find_children("*", "Label", true, false):
		if label is Label and label.size.x > 0.0 and label.get_minimum_size().x > label.size.x + 1.0:
			return true
	for button in find_children("*", "Button", true, false):
		if button is Button and button.size.x > 0.0 and button.get_minimum_size().x > button.size.x + 1.0:
			return true
	return false


func _show_surface() -> void:
	_generation += 1
	var generation := _generation
	_apply_safe_area()
	visible = true
	move_to_front()
	if _fade_tween != null and _fade_tween.is_running():
		_fade_tween.kill()
	if _reduced_motion:
		modulate.a = 1.0
	else:
		modulate.a = 0.0
		_fade_tween = create_tween()
		_fade_tween.set_trans(Tween.TRANS_SINE)
		_fade_tween.set_ease(Tween.EASE_OUT)
		_fade_tween.tween_property(self, "modulate:a", 1.0, 0.18)
	call_deferred("_focus_continue", generation)
	call_deferred("_emit_presentation_ready", generation)


func _focus_continue(generation: int) -> void:
	if (
		generation == _generation
		and visible
		and is_inside_tree()
		and _continue_button != null
		and is_instance_valid(_continue_button)
	):
		_continue_button.grab_focus()


func _emit_presentation_ready(generation: int) -> void:
	if generation != _generation or not visible or _mode == MODE_NONE:
		return
	presentation_ready.emit()


func _build_surface() -> void:
	var background := PanelContainer.new()
	background.name = "PhysicalBackground"
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_STOP
	var style := StyleBoxFlat.new()
	style.bg_color = Color("101018")
	background.add_theme_stylebox_override("panel", style)
	add_child(background)

	_content_margin = MarginContainer.new()
	_content_margin.name = "PhysicalSafeArea"
	_content_margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.add_child(_content_margin)

	var scroll := ScrollContainer.new()
	scroll.name = "PhysicalScroll"
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_content_margin.add_child(scroll)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.add_child(center)

	var card := PanelContainer.new()
	card.name = "PhysicalCard"
	card.custom_minimum_size = Vector2(320, 0)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color("1b1b29")
	card_style.border_color = Color("7771e8")
	card_style.set_border_width_all(1)
	card_style.set_corner_radius_all(24)
	card_style.content_margin_left = 28
	card_style.content_margin_top = 28
	card_style.content_margin_right = 28
	card_style.content_margin_bottom = 28
	card.add_theme_stylebox_override("panel", card_style)
	center.add_child(card)

	_content_column = VBoxContainer.new()
	_content_column.name = "PhysicalContent"
	_content_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content_column.add_theme_constant_override("separation", 16)
	card.add_child(_content_column)
	_apply_safe_area()


func _rebuild_content() -> void:
	for child in _content_column.get_children():
		_content_column.remove_child(child)
		child.queue_free()
	_withdraw_buttons.clear()
	if _mode == MODE_PHYSICAL_BEAT:
		var title := _label(_presentation["title"], 28, Color("f6f4ff"))
		title.name = "PhysicalTitle"
		_content_column.add_child(title)
		var body := _label(_presentation["body"], 19, Color("dedbea"))
		body.name = "PhysicalBody"
		_content_column.add_child(body)
		var steps_container := VBoxContainer.new()
		steps_container.name = "PhysicalSteps"
		steps_container.add_theme_constant_override("separation", 10)
		_content_column.add_child(steps_container)
		for index in _presentation["steps"].size():
			var step := _label("%d. %s" % [index + 1, _presentation["steps"][index]], 17, Color("f6f4ff"))
			step.name = "PhysicalStep%d" % (index + 1)
			steps_container.add_child(step)
	_continue_button = _button(
		_presentation["continuation_label"] if _mode == MODE_TRANSITION else _presentation["continue_label"],
		true,
	)
	_continue_button.name = "PhysicalContinue"
	_continue_button.pressed.connect(func(): continue_requested.emit())
	_content_column.add_child(_continue_button)
	if _mode == MODE_PHYSICAL_BEAT:
		for action in _presentation["withdrawal_actions"]:
			var choice_id: String = action["choice_id"]
			var withdraw_button := _button(action["text"], false)
			withdraw_button.name = "PhysicalWithdraw_" + choice_id
			withdraw_button.set_meta("choice_id", choice_id)
			withdraw_button.pressed.connect(func(): withdraw_requested.emit(choice_id))
			_content_column.add_child(withdraw_button)
			_withdraw_buttons.append(withdraw_button)


func _apply_safe_area() -> void:
	if _content_margin == null:
		return
	var viewport_size := Vector2i(get_viewport_rect().size)
	var safe_area := Rect2i(Vector2i.ZERO, viewport_size)
	if _safe_area_override_enabled:
		safe_area = _safe_area_override.intersection(Rect2i(Vector2i.ZERO, viewport_size))
	var left: int = maxi(20, safe_area.position.x + 20)
	var top: int = maxi(20, safe_area.position.y + 20)
	var right: int = maxi(20, viewport_size.x - safe_area.end.x + 20)
	var bottom: int = maxi(20, viewport_size.y - safe_area.end.y + 20)
	_content_margin.add_theme_constant_override("margin_left", left)
	_content_margin.add_theme_constant_override("margin_top", top)
	_content_margin.add_theme_constant_override("margin_right", right)
	_content_margin.add_theme_constant_override("margin_bottom", bottom)


func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label


func _button(value: String, primary: bool) -> Button:
	var button := Button.new()
	button.text = value
	button.custom_minimum_size = Vector2(0, 52)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.focus_mode = Control.FOCUS_ALL
	button.add_theme_font_size_override("font_size", 17)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("49439e") if primary else Color("29283a")
	normal.border_color = Color("918cff") if primary else Color("77738f")
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(16)
	button.add_theme_stylebox_override("normal", normal)
	var focus := normal.duplicate()
	focus.border_color = Color("d2cfff")
	focus.set_border_width_all(3)
	button.add_theme_stylebox_override("focus", focus)
	return button


func _exit_tree() -> void:
	if _fade_tween != null and _fade_tween.is_running():
		_fade_tween.kill()


func _has_exact_keys(value: Dictionary, expected: Array) -> bool:
	var actual: Array = value.keys()
	actual.sort()
	var sorted_expected := expected.duplicate()
	sorted_expected.sort()
	return actual == sorted_expected


func _non_empty_string(value) -> bool:
	return typeof(value) == TYPE_STRING and not value.is_empty() and value == value.strip_edges()
