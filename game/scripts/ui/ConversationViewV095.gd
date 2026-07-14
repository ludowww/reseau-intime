extends "res://scripts/ui/ConversationViewV086A.gd"

signal visual_open_requested(content_id: String)

const IMAGE_MIN_WIDTH := 300
const IMAGE_MAX_WIDTH := 520
const IMAGE_MAX_HEIGHT := 420

func _add_placeholder_card(content_id: String, is_ludo := false, record_history := true) -> void:
	var item := DataLoader.get_visual_content(content_id)
	var asset_path := str(item.get("asset_path", ""))
	var texture := _load_texture(asset_path)
	if texture == null:
		super._add_placeholder_card(content_id, is_ludo, record_history)
		return

	if record_history:
		_record_history_entry({
			"type": "placeholder",
			"content_id": content_id,
			"is_ludo": is_ludo,
		})

	var row := HBoxContainer.new()
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.alignment = BoxContainer.ALIGNMENT_END if is_ludo else BoxContainer.ALIGNMENT_BEGIN
	message_thread.add_child(row)

	var card := PanelContainer.new()
	card.name = "VisualCard_%s" % content_id
	card.custom_minimum_size = Vector2(IMAGE_MIN_WIDTH, 0)
	card.size_flags_horizontal = Control.SIZE_SHRINK_END if is_ludo else Control.SIZE_SHRINK_BEGIN
	card.mouse_filter = Control.MOUSE_FILTER_STOP
	card.focus_mode = Control.FOCUS_ALL
	card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	card.add_theme_stylebox_override("panel", _bubble_style(PLACEHOLDER_COLOR, is_ludo))
	row.add_child(card)

	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 6)
	card.add_child(body)

	var image := TextureRect.new()
	image.name = "VisualTexture"
	image.texture = texture
	image.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	image.custom_minimum_size = Vector2(IMAGE_MIN_WIDTH, minf(IMAGE_MAX_HEIGHT, 360.0))
	image.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(image)

	var caption := str(item.get("caption", item.get("context", "")))
	if caption != "":
		_add_label_to(body, caption, 13)
	var labels: Array[String] = []
	var intensity := _player_intensity_label(str(item.get("intensity_tier", "")))
	var visibility := _player_visibility_label(str(item.get("visibility", "")))
	if intensity != "":
		labels.append(intensity)
	if visibility != "":
		labels.append(visibility)
	if not labels.is_empty():
		_add_label_to(body, " · ".join(labels), 11)

	card.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			visual_open_requested.emit(content_id)
		elif event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]:
			visual_open_requested.emit(content_id)
	)

	GameState.add_unlocked_content(content_id)
	_scroll_to_bottom.call_deferred()

func _player_intensity_label(value: String) -> String:
	match value:
		"V1_ELEGANT": return "Élégante"
		"V2_SEXY": return "Sexy"
		"V3_PROVOCATIVE": return "Provocante"
		"V4_EROTIC": return "Érotique"
		"V5_PORNOGRAPHIC": return "Pornographique"
	return ""

func _player_visibility_label(value: String) -> String:
	match value:
		"PUBLIC": return "Publique"
		"PRIVATE": return "Privée"
		"SECRET": return "Secrète"
		"SHARED": return "Partagée"
		"RISK_RECONTEXTUALIZED": return "À risque"
	return ""

func _load_texture(asset_path: String) -> Texture2D:
	if asset_path == "":
		return null
	var global_path := ProjectSettings.globalize_path(asset_path)
	if not FileAccess.file_exists(global_path):
		return null
	var image := Image.load_from_file(global_path)
	if image == null:
		return null
	return ImageTexture.create_from_image(image)
