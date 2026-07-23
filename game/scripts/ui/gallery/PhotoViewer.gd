extends Control

class_name PhotoViewer

signal close_requested
signal current_photo_changed(photo_id: String)

const IMAGE_RATIO := 0.75
const MAX_VISUAL_WIDTH := 480.0

var presentations: Array[Dictionary] = []
var current_index := -1
var PORTRAIT_THEME
var column: VBoxContainer
var back_button: Button
var visual_center: CenterContainer
var visual_panel: PanelContainer
var visual_label: Label
var name_label: Label
var context_label: Label
var access_label: Label
var caption_label: Label
var actions: HBoxContainer
var previous_button: Button
var next_button: Button

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	resized.connect(_update_visual_size)

func configure(sequence: Array[Dictionary], start_index: int, portrait_theme) -> bool:
	if sequence.is_empty() or start_index < 0 or start_index >= sequence.size():
		return false
	var expected_source := str(sequence[start_index].get("source_kind", ""))
	var expected_character := str(sequence[start_index].get("character_id", ""))
	if expected_source != "messages" and expected_source != "gallery":
		return false
	for presentation in sequence:
		var photo_id := str(presentation.get("photo_id", ""))
		var source := str(presentation.get("source_kind", ""))
		if photo_id == "" or source != expected_source:
			return false
		if str(presentation.get("access_state", "")) != "UNLOCKED":
			return false
		if expected_source == "gallery" and str(presentation.get("character_id", "")) != expected_character:
			return false
	if expected_source == "messages" and sequence.size() != 1:
		return false
	presentations.clear()
	for presentation in sequence:
		presentations.append(presentation.duplicate(true))
	current_index = start_index
	PORTRAIT_THEME = portrait_theme
	_build()
	_refresh()
	return true

func reset_viewer() -> void:
	presentations.clear()
	current_index = -1
	for child in get_children():
		remove_child(child)
		child.queue_free()
	back_button = null
	access_label = null
	previous_button = null
	next_button = null

func show_previous() -> void:
	if source_kind() != "gallery" or current_index <= 0:
		return
	current_index = current_index - 1
	_refresh()
	current_photo_changed.emit(current_photo_id())

func show_next() -> void:
	if source_kind() != "gallery" or current_index >= presentations.size() - 1:
		return
	current_index = current_index + 1
	_refresh()
	current_photo_changed.emit(current_photo_id())

func current_presentation() -> Dictionary:
	return presentations[current_index].duplicate(true) if current_index >= 0 and current_index < presentations.size() else {}

func current_photo_id() -> String:
	return str(current_presentation().get("photo_id", ""))

func source_kind() -> String:
	return str(current_presentation().get("source_kind", ""))

func back_has_focus() -> bool:
	return back_button != null and back_button.has_focus()

func previous_visible() -> bool:
	return previous_button != null and previous_button.visible

func next_visible() -> bool:
	return next_button != null and next_button.visible

func previous_enabled() -> bool:
	return previous_visible() and not previous_button.disabled

func next_enabled() -> bool:
	return next_visible() and not next_button.disabled

func action_count() -> int:
	return 1 if source_kind() == "messages" else 3 if source_kind() == "gallery" else 0

func visual_ratio() -> float:
	var rect := visual_global_rect()
	return rect.size.x / rect.size.y if rect.size.y > 0.0 else 0.0

func viewer_global_rect() -> Rect2:
	return get_global_rect()

func visual_global_rect() -> Rect2:
	return visual_panel.get_global_rect() if visual_panel != null and is_instance_valid(visual_panel) else Rect2()

func has_vertical_crop() -> bool:
	var bounds := viewer_global_rect()
	var visual := visual_global_rect()
	return visual.position.y < bounds.position.y - 1.0 or visual.end.y > bounds.end.y + 1.0

func minimum_action_height() -> float:
	return min(back_button.custom_minimum_size.y, previous_button.custom_minimum_size.y, next_button.custom_minimum_size.y) if back_button != null else 0.0

func has_horizontal_crop() -> bool:
	if visual_panel == null or size.x <= 0.0:
		return false
	var bounds := viewer_global_rect()
	var visual := visual_global_rect()
	return visual.position.x < bounds.position.x - 1.0 or visual.end.x > bounds.end.x + 1.0

func displayed_name() -> String:
	return name_label.text if name_label != null else ""

func displayed_context() -> String:
	return context_label.text if context_label != null else ""

func displayed_caption() -> String:
	return caption_label.text if caption_label != null else ""

func displayed_access_state() -> String:
	return access_label.text if access_label != null else ""

func focus_back() -> void:
	if back_button != null:
		back_button.grab_focus()

func handle_navigation_event(event: InputEvent) -> bool:
	if not visible:
		return false
	if event.is_action_pressed("ui_cancel"):
		close_requested.emit()
		return true
	if not event is InputEventKey or not event.pressed or event.echo:
		return false
	if source_kind() == "gallery" and event.keycode == KEY_LEFT:
		show_previous()
		return true
	if source_kind() == "gallery" and event.keycode == KEY_RIGHT:
		show_next()
		return true
	return false

func _unhandled_input(event: InputEvent) -> void:
	if handle_navigation_event(event):
		get_viewport().set_input_as_handled()

func _build() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	column = VBoxContainer.new()
	column.name = "PhotoViewerColumn"
	column.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	column.add_theme_constant_override("separation", 10)
	add_child(column)
	back_button = _button("Retour")
	back_button.name = "Back"
	back_button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	back_button.pressed.connect(func(): close_requested.emit())
	column.add_child(back_button)
	name_label = _label("", 25, PORTRAIT_THEME.TEXT_PRIMARY)
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(name_label)
	context_label = _label("", 16, PORTRAIT_THEME.TEXT_SECONDARY)
	context_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(context_label)
	access_label = _label("Accessible", 14, PORTRAIT_THEME.TEXT_SECONDARY)
	access_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(access_label)
	visual_center = CenterContainer.new()
	visual_center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	visual_center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	column.add_child(visual_center)
	visual_panel = PanelContainer.new()
	visual_panel.name = "GeneratedPhoto"
	visual_center.add_child(visual_panel)
	visual_label = _label("◇\nPhoto de démonstration\n╱╲", 24, PORTRAIT_THEME.TEXT_PRIMARY)
	visual_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	visual_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	visual_panel.add_child(visual_label)
	caption_label = _label("", 17, PORTRAIT_THEME.TEXT_PRIMARY)
	caption_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(caption_label)
	actions = HBoxContainer.new()
	actions.alignment = BoxContainer.ALIGNMENT_CENTER
	actions.add_theme_constant_override("separation", 10)
	column.add_child(actions)
	previous_button = _button("Précédente")
	previous_button.pressed.connect(show_previous)
	actions.add_child(previous_button)
	next_button = _button("Suivante")
	next_button.pressed.connect(show_next)
	actions.add_child(next_button)

func _refresh() -> void:
	var presentation := current_presentation()
	var accent: Color = presentation.get("accent_color", PORTRAIT_THEME.GALLERY_ACCENT)
	name_label.text = str(presentation.get("display_name", ""))
	var context := str(presentation.get("context_label", ""))
	var timestamp := str(presentation.get("timestamp", ""))
	context_label.text = context + (" · " + timestamp if timestamp != "" else "")
	caption_label.text = str(presentation.get("caption", ""))
	caption_label.visible = caption_label.text != ""
	access_label.text = "Accessible"
	visual_panel.add_theme_stylebox_override("panel", PORTRAIT_THEME.button_style(Color(0.045, 0.06, 0.12), accent, 18))
	var gallery_source := source_kind() == "gallery"
	previous_button.visible = gallery_source
	next_button.visible = gallery_source
	previous_button.focus_mode = Control.FOCUS_ALL if gallery_source else Control.FOCUS_NONE
	next_button.focus_mode = Control.FOCUS_ALL if gallery_source else Control.FOCUS_NONE
	var previous_had_focus := previous_button.has_focus()
	var next_had_focus := next_button.has_focus()
	previous_button.disabled = current_index <= 0
	next_button.disabled = current_index >= presentations.size() - 1
	if previous_button.disabled and previous_had_focus:
		(next_button if not next_button.disabled else back_button).grab_focus()
	if next_button.disabled and next_had_focus:
		(previous_button if not previous_button.disabled else back_button).grab_focus()
	call_deferred("_update_visual_size")

func _update_visual_size() -> void:
	if visual_panel == null or not is_instance_valid(visual_panel):
		return
	var available_width := maxf(180.0, size.x - 32.0)
	var available_height := maxf(240.0, size.y - 280.0)
	var width := minf(MAX_VISUAL_WIDTH, minf(available_width, available_height * IMAGE_RATIO))
	visual_panel.custom_minimum_size = Vector2(width, width / IMAGE_RATIO)

func _button(value: String) -> Button:
	var button := Button.new()
	button.text = value
	button.custom_minimum_size = Vector2(0, 52)
	button.focus_mode = Control.FOCUS_ALL
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.08, 0.10, 0.17), PORTRAIT_THEME.BORDER, 16))
	button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	return button

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label
