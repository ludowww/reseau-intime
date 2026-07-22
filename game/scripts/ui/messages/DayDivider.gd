extends HBoxContainer

class_name DayDivider

var text_label: Label

func configure(value: String, portrait_theme) -> void:
	name = "DayDivider"
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	custom_minimum_size = Vector2(0, 36)
	add_theme_constant_override("separation", 12)

	var left_space := Control.new()
	left_space.focus_mode = Control.FOCUS_NONE
	left_space.mouse_filter = Control.MOUSE_FILTER_IGNORE
	left_space.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(left_space)

	var left_line := HSeparator.new()
	left_line.focus_mode = Control.FOCUS_NONE
	left_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	left_line.custom_minimum_size = Vector2(56, 0)
	left_line.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	left_line.add_theme_color_override("separator", portrait_theme.BORDER)
	add_child(left_line)

	text_label = Label.new()
	text_label.name = "DayDividerLabel"
	text_label.text = value
	text_label.focus_mode = Control.FOCUS_NONE
	text_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text_label.add_theme_font_size_override("font_size", 16)
	text_label.add_theme_color_override("font_color", portrait_theme.TEXT_SECONDARY)
	add_child(text_label)

	var right_line := HSeparator.new()
	right_line.focus_mode = Control.FOCUS_NONE
	right_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	right_line.custom_minimum_size = Vector2(56, 0)
	right_line.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	right_line.add_theme_color_override("separator", portrait_theme.BORDER)
	add_child(right_line)

	var right_space := Control.new()
	right_space.focus_mode = Control.FOCUS_NONE
	right_space.mouse_filter = Control.MOUSE_FILTER_IGNORE
	right_space.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(right_space)

func display_text() -> String:
	return text_label.text if text_label != null else ""

func has_horizontal_crop() -> bool:
	return text_label != null and text_label.size.x > 0.0 and text_label.get_minimum_size().x > text_label.size.x + 1.0
