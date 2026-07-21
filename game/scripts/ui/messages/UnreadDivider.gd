extends HBoxContainer

class_name UnreadDivider

func configure(portrait_theme) -> void:
	name = "UnreadDivider"
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_theme_constant_override("separation", 10)
	var left_line := HSeparator.new()
	left_line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_line.add_theme_color_override("separator", portrait_theme.FOCUS)
	add_child(left_line)
	var label := Label.new()
	label.name = "UnreadDividerLabel"
	label.text = "Nouveaux messages"
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", portrait_theme.TEXT_SECONDARY)
	add_child(label)
	var right_line := HSeparator.new()
	right_line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_line.add_theme_color_override("separator", portrait_theme.FOCUS)
	add_child(right_line)
