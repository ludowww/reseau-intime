extends Control

signal transition_finished

const OVERLAY_COLOR := Color(0.025, 0.028, 0.04, 0.98)
const CARD_COLOR := Color(0.075, 0.082, 0.12, 0.96)
const TEXT_COLOR := Color(0.94, 0.95, 0.99)
const MUTED_COLOR := Color(0.68, 0.72, 0.82)

var card_panel: PanelContainer
var eyebrow_label: Label
var title_label: Label
var subtitle_label: Label
var hint_label: Label
var sequence_token := 0
var can_skip := false
var skip_requested := false

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_ALL
	visible = false
	_build_layout()

func show_moment_transition(card: Dictionary) -> void:
	await _play_cards([card])

func show_day_transition(end_card: Dictionary, start_card: Dictionary) -> void:
	var cards: Array = []
	if not end_card.is_empty():
		cards.append(end_card)
	if not start_card.is_empty():
		cards.append(start_card)
	await _play_cards(cards)

func clear_transition() -> void:
	sequence_token += 1
	can_skip = false
	skip_requested = false
	visible = false

func _play_cards(cards: Array) -> void:
	if cards.is_empty():
		transition_finished.emit()
		return
	sequence_token += 1
	var token := sequence_token
	var last_card: Dictionary = {}
	visible = true
	move_to_front()
	grab_focus()
	for raw_card in cards:
		if token != sequence_token:
			return
		var card: Dictionary = raw_card if typeof(raw_card) == TYPE_DICTIONARY else {}
		last_card = card
		_apply_card(card)
		await _wait_for_card(card, token)
	visible = false
	can_skip = false
	skip_requested = false
	release_focus()
	_show_timeline_landing(last_card)
	transition_finished.emit()

func _wait_for_card(card: Dictionary, token: int) -> void:
	var minimum: float = maxf(float(card.get("min_time", 0.35)), 0.0)
	var duration: float = maxf(float(card.get("duration", 1.0)), minimum)
	var elapsed: float = 0.0
	can_skip = false
	skip_requested = false
	while elapsed < duration and token == sequence_token:
		var step: float = minf(0.05, duration - elapsed)
		await get_tree().create_timer(step).timeout
		elapsed += step
		if elapsed >= minimum:
			can_skip = true
			if skip_requested:
				break
	can_skip = false
	skip_requested = false

func _gui_input(event: InputEvent) -> void:
	if not visible or not can_skip:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		skip_requested = true
		accept_event()
	elif event is InputEventKey and event.pressed and not event.echo:
		skip_requested = true
		accept_event()

func _show_timeline_landing(card: Dictionary) -> void:
	if card.is_empty() or not bool(card.get("show_landing", true)):
		return
	var conversation = get_parent().find_child("ConversationView", true, false)
	if conversation == null or not conversation.has_method("show_timeline_landing"):
		return
	var details: Array[String] = []
	for key in ["title", "subtitle"]:
		var value := str(card.get(key, ""))
		if value != "" and not details.has(value):
			details.append(value)
	conversation.call("show_timeline_landing", str(card.get("eyebrow", "")), " · ".join(details))

func _build_layout() -> void:
	var background := PanelContainer.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.add_theme_stylebox_override("panel", _panel_style(OVERLAY_COLOR, 0))
	add_child(background)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background.add_child(center)

	card_panel = PanelContainer.new()
	card_panel.custom_minimum_size = Vector2(480, 230)
	card_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_panel.add_theme_stylebox_override("panel", _panel_style(CARD_COLOR, 24))
	center.add_child(card_panel)

	var column := VBoxContainer.new()
	column.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_theme_constant_override("separation", 14)
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	card_panel.add_child(column)

	eyebrow_label = _make_label(18, MUTED_COLOR)
	title_label = _make_label(30, TEXT_COLOR)
	subtitle_label = _make_label(17, MUTED_COLOR)
	hint_label = _make_label(11, MUTED_COLOR)
	hint_label.text = "Cliquer pour continuer"

	column.add_child(eyebrow_label)
	column.add_child(title_label)
	column.add_child(subtitle_label)
	column.add_child(hint_label)

func _apply_card(card: Dictionary) -> void:
	_set_label(eyebrow_label, str(card.get("eyebrow", "")))
	_set_label(title_label, str(card.get("title", "")))
	_set_label(subtitle_label, str(card.get("subtitle", "")))
	hint_label.visible = bool(card.get("show_skip_hint", true))

func _set_label(label: Label, text: String) -> void:
	label.text = text
	label.visible = text != ""

func _make_label(size: int, color: Color) -> Label:
	var label := Label.new()
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label

func _panel_style(color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 30
	style.content_margin_right = 30
	style.content_margin_top = 26
	style.content_margin_bottom = 26
	return style
