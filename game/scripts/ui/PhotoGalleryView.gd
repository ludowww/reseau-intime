extends VBoxContainer

signal back_requested

const BACKGROUND_COLOR := Color(0.05, 0.055, 0.08)
const CARD_COLOR := Color(0.10, 0.105, 0.15)
const LOCKED_COLOR := Color(0.075, 0.08, 0.11)

var photo_grid: GridContainer
var detail_panel: VBoxContainer
var detail_title: Label
var detail_meta: Label
var detail_image: TextureRect
var empty_label: Label
var selected_content_id := ""

func _ready() -> void:
	name = "PhotoGalleryView"
	custom_minimum_size = Vector2(600, 0)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 10)
	_build_ui()
	var callback := Callable(self, "refresh")
	if not GameState.is_connected("state_changed", callback):
		GameState.connect("state_changed", callback)
	refresh()

func _build_ui() -> void:
	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	add_child(header)

	var back := Button.new()
	back.text = "← Messages"
	back.focus_mode = Control.FOCUS_ALL
	back.pressed.connect(func(): back_requested.emit())
	header.add_child(back)

	var title := Label.new()
	title.text = "Galerie"
	title.add_theme_font_size_override("font_size", 22)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(title)

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(scroll)

	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 14)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(content)

	empty_label = Label.new()
	empty_label.text = "Aucune photo déverrouillée."
	empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(empty_label)

	photo_grid = GridContainer.new()
	photo_grid.columns = 3
	photo_grid.add_theme_constant_override("h_separation", 10)
	photo_grid.add_theme_constant_override("v_separation", 10)
	photo_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(photo_grid)

	var progress_title := Label.new()
	progress_title.text = "Marie — progression"
	progress_title.add_theme_font_size_override("font_size", 17)
	content.add_child(progress_title)

	var progress := HBoxContainer.new()
	progress.add_theme_constant_override("separation", 8)
	content.add_child(progress)
	for label in ["Robe noire", "Suite privée", "Lingerie", "Reconnexion adulte"]:
		var card := PanelContainer.new()
		card.custom_minimum_size = Vector2(125, 70)
		card.add_theme_stylebox_override("panel", _panel_style(LOCKED_COLOR, 12))
		progress.add_child(card)
		var text := Label.new()
		text.text = label if label == "Robe noire" else "🔒 %s" % label
		text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		card.add_child(text)

	detail_panel = VBoxContainer.new()
	detail_panel.add_theme_constant_override("separation", 8)
	detail_panel.visible = false
	content.add_child(detail_panel)

	detail_title = Label.new()
	detail_title.add_theme_font_size_override("font_size", 19)
	detail_panel.add_child(detail_title)

	detail_image = TextureRect.new()
	detail_image.custom_minimum_size = Vector2(420, 520)
	detail_image.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	detail_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	detail_panel.add_child(detail_image)

	detail_meta = Label.new()
	detail_meta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_panel.add_child(detail_meta)

func refresh() -> void:
	if not is_instance_valid(photo_grid):
		return
	for child in photo_grid.get_children():
		child.queue_free()
	var ids := unlocked_photo_ids()
	empty_label.visible = ids.is_empty()
	for content_id in ids:
		photo_grid.add_child(_photo_button(content_id))
	if selected_content_id != "" and ids.has(selected_content_id):
		show_content(selected_content_id)
	elif not ids.is_empty():
		show_content(str(ids[0]))
	else:
		detail_panel.visible = false

func unlocked_photo_ids() -> Array[String]:
	var result: Array[String] = []
	for raw_id in GameState.current_state.get("unlocked_content", []):
		var content_id := str(raw_id)
		var item := DataLoader.get_visual_content(content_id)
		if item.is_empty() or str(item.get("type", "")) != "photo":
			continue
		var asset_path := str(item.get("asset_path", ""))
		if asset_path == "" or not ResourceLoader.exists(asset_path):
			continue
		result.append(content_id)
	result.sort_custom(func(a, b):
		var left := DataLoader.get_visual_content(a)
		var right := DataLoader.get_visual_content(b)
		return int(left.get("gallery_order", 9999)) < int(right.get("gallery_order", 9999))
	)
	return result

func show_content(content_id: String) -> void:
	var item := DataLoader.get_visual_content(content_id)
	var asset_path := str(item.get("asset_path", ""))
	if item.is_empty() or asset_path == "" or not ResourceLoader.exists(asset_path):
		return
	var loaded = load(asset_path)
	if not loaded is Texture2D:
		return
	selected_content_id = content_id
	detail_panel.visible = true
	detail_title.text = str(item.get("caption", content_id))
	detail_image.texture = loaded
	var labels: Array[String] = []
	labels.append(str(item.get("character", "")).capitalize())
	var intensity := _intensity_label(str(item.get("intensity_tier", "")))
	var visibility := _visibility_label(str(item.get("visibility", "")))
	if intensity != "":
		labels.append(intensity)
	if visibility != "":
		labels.append(visibility)
	detail_meta.text = " · ".join(labels)

func _photo_button(content_id: String) -> Button:
	var item := DataLoader.get_visual_content(content_id)
	var button := Button.new()
	button.name = "GalleryPhoto_%s" % content_id
	button.custom_minimum_size = Vector2(150, 210)
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.text = str(item.get("caption", content_id))
	var asset_path := str(item.get("asset_path", ""))
	if asset_path != "" and ResourceLoader.exists(asset_path):
		var loaded = load(asset_path)
		if loaded is Texture2D:
			button.icon = loaded
			button.expand_icon = true
			button.pressed.connect(func(): show_content(content_id))
	return button

func _intensity_label(value: String) -> String:
	match value:
		"V1_ELEGANT": return "Élégante"
		"V2_SEXY": return "Sexy"
		"V3_PROVOCATIVE": return "Provocante"
		"V4_EROTIC": return "Érotique"
		"V5_PORNOGRAPHIC": return "Pornographique"
	return ""

func _visibility_label(value: String) -> String:
	match value:
		"PUBLIC": return "Publique"
		"PRIVATE": return "Privée"
		"SECRET": return "Secrète"
		"SHARED": return "Partagée"
		"RISK_RECONTEXTUALIZED": return "À risque"
	return ""

func _panel_style(color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style
