extends PanelContainer

class_name NotificationBanner

signal open_requested(thread_id: String)
signal dismiss_requested

const AUTO_DISMISS_SECONDS := 3.5

var PORTRAIT_THEME
var notification: Dictionary = {}
var open_button: Button
var close_button: Button
var current_tween: Tween
var auto_dismiss_timer: Timer
var compact_mode := false
var reduced_motion_enabled := false

func configure(notification_presentation: Dictionary, portrait_theme, reduced_motion: bool, compact := false, auto_dismiss_seconds := 0.0) -> void:
	notification = notification_presentation.duplicate(true)
	PORTRAIT_THEME = portrait_theme
	compact_mode = compact
	reduced_motion_enabled = reduced_motion
	_stop_transients()
	_build()
	visible = true
	modulate.a = 1.0
	position.y = 0.0
	if not reduced_motion:
		current_tween = create_tween()
		current_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		if compact_mode:
			position.y = -maxf(size.y, 64.0)
			current_tween.tween_property(self, "position:y", 0.0, 0.20)
		else:
			modulate.a = 0.0
			current_tween.tween_property(self, "modulate:a", 1.0, 0.16)
	if auto_dismiss_seconds > 0.0:
		auto_dismiss_timer = Timer.new()
		auto_dismiss_timer.name = "AutoDismissTimer"
		auto_dismiss_timer.one_shot = true
		auto_dismiss_timer.wait_time = auto_dismiss_seconds
		auto_dismiss_timer.timeout.connect(_on_auto_dismiss_timeout)
		add_child(auto_dismiss_timer)
		auto_dismiss_timer.start()

func dismiss() -> void:
	_stop_transients()
	visible = false
	modulate.a = 1.0
	position.y = 0.0

func activate_open_action() -> void:
	if not visible:
		return
	if compact_mode:
		_emit_open_requested()
	elif open_button != null:
		open_button.emit_signal("pressed")

func is_transition_running() -> bool:
	return current_tween != null and current_tween.is_running()

func _build() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	open_button = null
	close_button = null
	name = "HeaderNotification" if compact_mode else "NotificationBanner"
	focus_mode = Control.FOCUS_ALL if compact_mode else Control.FOCUS_NONE
	mouse_filter = Control.MOUSE_FILTER_STOP
	custom_minimum_size = Vector2(0, 0 if compact_mode else 88)
	tooltip_text = "Ouvrir la conversation" if compact_mode else ""
	var accent := Color.from_string(str(notification.get("accent_color", "#8D63E6")), PORTRAIT_THEME.PLAYER_ACCENT)
	if compact_mode:
		add_theme_stylebox_override("panel", PORTRAIT_THEME.button_style(Color(0.012, 0.02, 0.04, 0.98), accent, 12))
		add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	else:
		add_theme_stylebox_override("panel", PORTRAIT_THEME.panel_style(PORTRAIT_THEME.SURFACE_RAISED, 1, 18))
	if not gui_input.is_connected(_on_gui_input):
		gui_input.connect(_on_gui_input)
	var row := HBoxContainer.new()
	row.name = "NotificationRow"
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 8 if compact_mode else 10)
	add_child(row)
	var avatar := Label.new()
	avatar.name = "NotificationAvatar"
	avatar.text = str(notification.get("avatar_ref", "?"))
	avatar.custom_minimum_size = Vector2(40 if compact_mode else 44, 40 if compact_mode else 44)
	avatar.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	avatar.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	avatar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	avatar.add_theme_font_size_override("font_size", 17 if compact_mode else 18)
	avatar.add_theme_color_override("font_color", accent)
	avatar.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.025, 0.04, 0.07), accent, 20))
	row.add_child(avatar)
	var copy := VBoxContainer.new()
	copy.name = "NotificationCopy"
	copy.mouse_filter = Control.MOUSE_FILTER_IGNORE
	copy.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	copy.add_theme_constant_override("separation", 0 if compact_mode else 2)
	row.add_child(copy)
	var title := _label(str(notification.get("title", "Conversation")), 16, PORTRAIT_THEME.TEXT_PRIMARY)
	title.name = "NotificationTitle"
	title.autowrap_mode = TextServer.AUTOWRAP_OFF
	title.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	copy.add_child(title)
	var preview := _label(str(notification.get("preview", "Nouveau message")), 14, PORTRAIT_THEME.TEXT_PRIMARY if compact_mode else PORTRAIT_THEME.TEXT_SECONDARY)
	preview.name = "NotificationPreview"
	preview.max_lines_visible = 1 if compact_mode else 2
	preview.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	copy.add_child(preview)
	var timestamp := _label(str(notification.get("timestamp", "")), 13, PORTRAIT_THEME.TEXT_SECONDARY)
	timestamp.name = "NotificationTimestamp"
	timestamp.custom_minimum_size = Vector2(44 if compact_mode else 48, 0)
	timestamp.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	timestamp.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(timestamp)
	if compact_mode:
		return
	open_button = Button.new()
	open_button.name = "OpenNotification"
	open_button.text = "Ouvrir"
	open_button.custom_minimum_size = Vector2(72, 48)
	open_button.focus_mode = Control.FOCUS_ALL
	open_button.tooltip_text = "Ouvrir cette conversation"
	open_button.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	open_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.10, 0.12, 0.20), PORTRAIT_THEME.BORDER, 12))
	open_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	open_button.pressed.connect(_emit_open_requested)
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

func _on_gui_input(event: InputEvent) -> void:
	if not compact_mode or not visible:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_emit_open_requested()
		accept_event()
	elif event.is_action_pressed("ui_accept"):
		_emit_open_requested()
		accept_event()

func _emit_open_requested() -> void:
	if visible:
		open_requested.emit(str(notification.get("thread_id", "")))

func _on_close_pressed() -> void:
	dismiss()
	dismiss_requested.emit()

func _on_auto_dismiss_timeout() -> void:
	dismiss()
	dismiss_requested.emit()

func _stop_transients() -> void:
	if current_tween != null and current_tween.is_running():
		current_tween.kill()
	current_tween = null
	if auto_dismiss_timer != null and is_instance_valid(auto_dismiss_timer):
		auto_dismiss_timer.stop()
		if auto_dismiss_timer.get_parent() == self:
			remove_child(auto_dismiss_timer)
		auto_dismiss_timer.queue_free()
	auto_dismiss_timer = null

func _label(value: String, font_size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	return label
