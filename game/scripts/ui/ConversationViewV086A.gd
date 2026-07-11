extends "res://scripts/ui/ConversationViewV084.gd"

signal thread_notification_pressed

var thread_notification_panel: PanelContainer
var thread_notification_label: Label

func _add_chat_header(conversation: Dictionary) -> void:
	super._add_chat_header(conversation)
	_build_thread_notification_banner()

func _build_thread_notification_banner() -> void:
	thread_notification_panel = PanelContainer.new()
	thread_notification_panel.name = "ThreadNotificationShortcut"
	thread_notification_panel.visible = false
	thread_notification_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	thread_notification_panel.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	thread_notification_panel.focus_mode = Control.FOCUS_ALL
	thread_notification_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	thread_notification_panel.add_theme_stylebox_override(
		"panel",
		_panel_style(Color(0.11, 0.17, 0.25), 12)
	)
	thread_notification_panel.gui_input.connect(_on_thread_notification_input)
	chat_shell.add_child(thread_notification_panel)
	chat_shell.move_child(thread_notification_panel, 1)

	thread_notification_label = Label.new()
	thread_notification_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	thread_notification_label.add_theme_font_size_override("font_size", 12)
	thread_notification_label.add_theme_color_override("font_color", Color(0.92, 0.96, 1.0))
	thread_notification_panel.add_child(thread_notification_label)

func show_thread_notification(contact_name: String, preview: String, time_label: String = "") -> void:
	if not is_instance_valid(thread_notification_panel) or not is_instance_valid(thread_notification_label):
		return
	var header := "Nouveau message · %s" % contact_name
	if time_label != "":
		header += " · %s" % time_label
	thread_notification_label.text = "%s\n%s" % [header, preview]
	thread_notification_panel.visible = true

func hide_thread_notification() -> void:
	if is_instance_valid(thread_notification_panel):
		thread_notification_panel.visible = false
	if is_instance_valid(thread_notification_label):
		thread_notification_label.text = ""

func _on_thread_notification_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		thread_notification_pressed.emit()
	elif event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]:
		thread_notification_pressed.emit()
