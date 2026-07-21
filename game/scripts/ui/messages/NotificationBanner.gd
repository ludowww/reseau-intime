extends PanelContainer

class_name NotificationBanner

signal open_requested(thread_id: String)
signal dismiss_requested

var PORTRAIT_THEME
var notification: Dictionary = {}
var open_button: Button
var close_button: Button
var current_tween: Tween

func configure(notification_presentation: Dictionary, portrait_theme, reduced_motion: bool) -> void:
	notification = notification_presentation.duplicate(true)
	PORTRAIT_THEME = portrait_theme
	_build()
	visible = true
	if current_tween != null and current_tween.is_running():
		current_tween.kill()
	current_tween = null
	modulate.a = 1.0
	if not reduced_motion:
		modulate.a = 0.0
		current_tween = create_tween()
		current_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		current_tween.tween_property(self, "modulate:a", 1.0, 0.16)

func dismiss() -> void:
	if current_tween != null and current_tween.is_running():
		current_tween.kill()
	current_tween = null
	visible = false
	modulate.a = 1.0

func activate_open_action() -> void:
	if visible and open_button != null:
		open_button.emit_signal("pressed")

func is_transition_running() -> bool:
	return current_tween != null and current_tween.is_running()

func _build() -> void:
	for child in get_children():
		child.queue_free()
	name = "NotificationBanner"
	focus_mode = Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(0, 88)
	add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE_RAISED, 1, 18))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	add_child(row)
	var avatar := Label.new()
	avatar.name = "NotificationAvatar"
	avatar.text = str(notification.get("avatar_ref", "?"))
	avatar.custom_minimum_size = Vector2(44, 44)
	avatar.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	avatar.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	avatar.add_theme_font_size_override("font_size", 18)
	var accent := Color.from_string(str(notification.get("accent_color", "#8D63E6")), PORTRAIT_THEME.PLAYER_ACCENT)
	avatar.add_theme_color_override("font_color", accent)
	avatar.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.06, 0.08, 0.14), accent, 22))
	row.add_child(avatar)
	var copy := VBoxContainer.new()
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.add_theme_constant_override("separation", 2)
	row.add_child(copy)
	var title := _label(str(notification.get("title", "Conversation")), 16, PORTRAIT_THEME.TEXT_PRIMARY)
	title.name = "NotificationTitle"
	copy.add_child(title)
	var preview := _label(str(notification.get("preview", "Nouveau message")), 14, PORTRAIT_THEME.TEXT_SECONDARY)
	preview.name = "NotificationPreview"
	preview.max_lines_visible = 2
	copy.add_child(preview)
	var timestamp := _label(str(notification.get("timestamp", "")), 13, PORTRAIT_THEME.TEXT_SECONDARY)
	timestamp.name = "NotificationTimestamp"
	timestamp.custom_minimum_size = Vector2(48, 0)
	timestamp.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(timestamp)
	open_button = Button.new()
	open_button.name = "OpenNotification"
	open_button.text = "Ouvrir"
	open_button.custom_minimum_size = Vector2(72, 48)
	open_button.focus_mode = Control.FOCUS_ALL
	open_button.tooltip_text = "Ouvrir cette conversation"
	open_button.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	open_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.10, 0.12, 0.20), PORTRAIT_THEME.BORDER, 12))
	open_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	open_button.pressed.connect(func(): open_requested.emit(str(notification.get("thread_id", ""))))
	row.add_child(open_button)
	close_button = Button.new()
	close_button.name = "CloseNotification"
	close_button.text = "×"
	close_button.custom_minimum_size = Vector2(48, 48)
	close_button.focus_mode = Control.FOCUS_ALL
	close_button.tooltip_text = "Fermer la notification"
	close_button.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	close_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.10, 0.12, 0.20), PORTRAIT_THEME.BORDER, 12))
	close_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	close_button.pressed.connect(_on_close_pressed)
	row.add_child(close_button)

func _on_close_pressed() -> void:
	dismiss()
	dismiss_requested.emit()

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label
