extends VBoxContainer

class_name ImageMessage

signal image_requested(message_id: String, media_ref: String)

const MEDIA_RESOLVER := preload("res://scripts/ui/media/VisualMediaResolver.gd")
const IMAGE_RATIO := 0.75
const IMAGE_WIDTH := 240.0
const IMAGE_HEIGHT := IMAGE_WIDTH / IMAGE_RATIO

var message_id := ""
var media_ref := ""
var caption := ""
var accent := Color.WHITE
var image_button: Button
var caption_label: Label
var placeholder_label := "Photo de démonstration"
var media_status := ""

func configure(p_message_id: String, p_media_ref: String, p_caption: String, p_accent: Color, portrait_theme, p_placeholder_label := "Photo de démonstration") -> void:
	message_id = p_message_id
	media_ref = p_media_ref
	caption = p_caption
	accent = p_accent
	placeholder_label = p_placeholder_label
	_build(portrait_theme)

func focus_image() -> void:
	if image_button != null:
		image_button.grab_focus()

func image_has_focus() -> bool:
	return image_button != null and image_button.has_focus()

func has_caption() -> bool:
	return caption_label != null and caption_label.visible and caption_label.text != ""

func displayed_caption() -> String:
	return caption_label.text if caption_label != null else ""

func image_ratio() -> float:
	return IMAGE_RATIO

func minimum_target() -> Vector2:
	return image_button.custom_minimum_size if image_button != null else Vector2.ZERO

func has_horizontal_crop() -> bool:
	if image_button != null and image_button.size.x > 0.0 and image_button.get_minimum_size().x > image_button.size.x + 1.0:
		return true
	return caption_label != null and caption_label.size.x > 0.0 and caption_label.get_minimum_size().x > caption_label.size.x + 1.0

func animation_running() -> bool:
	return false

func has_loaded_texture() -> bool:
	return image_button != null and image_button.icon != null and media_status == MEDIA_RESOLVER.STATUS_LOADED

func displayed_media_status() -> String:
	return media_status

func _build(portrait_theme) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	caption_label = null
	size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	add_theme_constant_override("separation", 8)
	image_button = Button.new()
	image_button.name = "ImageButton"
	var resolved := MEDIA_RESOLVER.resolve(media_ref)
	media_status = str(resolved.get("status", MEDIA_RESOLVER.STATUS_LOAD_FAILED))
	if media_status == MEDIA_RESOLVER.STATUS_LOADED:
		image_button.icon = resolved.get("texture")
		image_button.text = ""
		image_button.tooltip_text = "Activer la photo"
	else:
		image_button.icon = null
		image_button.text = MEDIA_RESOLVER.NOT_DELIVERED_LABEL
		image_button.tooltip_text = MEDIA_RESOLVER.NOT_DELIVERED_LABEL
	image_button.expand_icon = true
	image_button.custom_minimum_size = Vector2(IMAGE_WIDTH, IMAGE_HEIGHT)
	image_button.focus_mode = Control.FOCUS_ALL
	image_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	image_button.add_theme_font_size_override("font_size", 18)
	image_button.add_theme_color_override("font_color", portrait_theme.TEXT_PRIMARY)
	image_button.add_theme_stylebox_override("normal", portrait_theme.button_style(Color(0.055, 0.07, 0.13), accent, 14))
	image_button.add_theme_stylebox_override("hover", portrait_theme.button_style(Color(0.075, 0.10, 0.18), accent.lightened(0.12), 14))
	image_button.add_theme_stylebox_override("pressed", portrait_theme.button_style(Color(0.04, 0.05, 0.10), accent, 14))
	image_button.add_theme_stylebox_override("focus", portrait_theme.focus_style())
	image_button.pressed.connect(func(): image_requested.emit(message_id, media_ref))
	add_child(image_button)
	if caption != "":
		caption_label = Label.new()
		caption_label.name = "Caption"
		caption_label.text = caption
		caption_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		caption_label.custom_minimum_size.x = IMAGE_WIDTH
		caption_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		caption_label.add_theme_font_size_override("font_size", 16)
		caption_label.add_theme_color_override("font_color", portrait_theme.TEXT_PRIMARY)
		add_child(caption_label)
