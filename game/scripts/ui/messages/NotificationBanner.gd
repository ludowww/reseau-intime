extends PanelContainer

class_name NotificationBanner

signal open_requested(thread_id: String, generation: int)
signal dismiss_requested(generation: int)

const AUTO_DISMISS_SECONDS := 3.5
const EXIT_SECONDS := 0.16

var PORTRAIT_THEME
var notification: Dictionary = {}
var open_button: Button
var close_button: Button
var current_tween: Tween
var auto_dismiss_timer: Timer
var compact_mode := false
var reduced_motion_enabled := false
var presentation_generation := 0
var dismissed := false
var resting_position_y := 0.0
var resting_position_initialized := false

func configure(notification_presentation: Dictionary, portrait_theme, reduced_motion: bool, compact := false, auto_dismiss_seconds := 0.0, generation := 0) -> void:
	if not resting_position_initialized:
		resting_position_y = position.y
		resting_position_initialized = true
	notification = notification_presentation.duplicate(true)
	PORTRAIT_THEME = portrait_theme
	compact_mode = compact
	reduced_motion_enabled = reduced_motion
	presentation_generation = generation
	dismissed = false
	_stop_transients()
	_build()
	visible = true
	modulate.a = 1.0
	position.y = resting_position_y
	if not reduced_motion:
		current_tween = create_tween()
		current_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		if compact_mode:
			position.y = resting_position_y - 4.0
			current_tween.tween_property(self, "position:y", resting_position_y, 0.20)
		else:
			modulate.a = 0.0
			current_tween.tween_property(self, "modulate:a", 1.0, 0.16)
	if auto_dismiss_seconds > 0.0:
		auto_dismiss_timer = Timer.new()
		auto_dismiss_timer.name = "AutoDismissTimer"
		auto_dismiss_timer.one_shot = true
		auto_dismiss_timer.ignore_time_scale = true
		auto_dismiss_timer.process_callback = Timer.TIMER_PROCESS_IDLE
		auto_dismiss_timer.wait_time = auto_dismiss_seconds
		auto_dismiss_timer.timeout.connect(_on_auto_dismiss_timeout.bind(presentation_generation))
		add_child(auto_dismiss_timer)
		auto_dismiss_timer.start()

func dismiss() -> void:
	dismissed = true
	presentation_generation += 1
	_stop_transients()
	visible = false
	modulate.a = 1.0
	position.y = resting_position_y

func activate_open_action() -> void:
	if visible:
		_emit_open_requested(presentation_generation)

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
	var title_text := str(notification.get("title", "Conversation"))
	tooltip_text = "Ouvrir la conversation avec %s" % title_text if compact_mode else ""
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
	var title := _label(title_text, 16, PORTRAIT_THEME.TEXT_PRIMARY)
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
	# Historical wide-mode compatibility; normal runtime always uses compact mode.
	open_button = Button.new()
	open_button.name = "OpenNotification"
	open_button.text = "Ouvrir"
	open_button.custom_minimum_size = Vector2(72, 48)
	open_button.focus_mode = Control.FOCUS_ALL
	open_button.tooltip_text = "Ouvrir cette conversation"
	open_button.add_theme_color_override("font_color", PORTRAIT_THEME.TEXT_PRIMARY)
	open_button.add_theme_stylebox_override("normal", PORTRAIT_THEME.button_style(Color(0.10, 0.12, 0.20), PORTRAIT_THEME.BORDER, 12))
	open_button.add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())
	open_button.pressed.connect(func(): _emit_open_requested(presentation_generation))
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
	close_button.pressed.connect(func(): _on_close_pressed(presentation_generation))
	row.add_child(close_button)

func _on_gui_input(event: InputEvent) -> void:
	if not compact_mode or not visible or dismissed:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_emit_open_requested(presentation_generation)
		accept_event()
	elif event.is_action_pressed("ui_accept"):
		_emit_open_requested(presentation_generation)
		accept_event()

func _emit_open_requested(generation: int) -> void:
	if visible and not dismissed and generation == presentation_generation:
		open_requested.emit(str(notification.get("thread_id", "")), generation)

func _on_close_pressed(generation: int) -> void:
	if generation != presentation_generation or dismissed:
		return
	dismiss()
	dismiss_requested.emit(generation)

func _on_auto_dismiss_timeout(generation: int = presentation_generation) -> void:
	if generation != presentation_generation or dismissed or not visible:
		return
	dismissed = true
	_stop_transients()
	if reduced_motion_enabled:
		visible = false
		dismiss_requested.emit(generation)
		return
	current_tween = create_tween()
	current_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	current_tween.parallel().tween_property(self, "position:y", resting_position_y - 12.0, EXIT_SECONDS)
	current_tween.parallel().tween_property(self, "modulate:a", 0.0, EXIT_SECONDS)
	current_tween.finished.connect(_finish_auto_dismiss.bind(generation))

func _finish_auto_dismiss(generation: int) -> void:
	if generation != presentation_generation:
		return
	visible = false
	modulate.a = 1.0
	position.y = resting_position_y
	current_tween = null
	dismiss_requested.emit(generation)

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
