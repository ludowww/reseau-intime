extends Node

const DEMO_SCENE := preload("res://scenes/portrait/PortraitShellDemo.tscn")

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var demo = DEMO_SCENE.instantiate()
	add_child(demo)
	await get_tree().process_frame
	await get_tree().process_frame
	var shell = demo.shell
	_expect(shell != null, "demo shell is missing")
	if shell == null:
		_finish()
		return
	var expected_size := _parse_size(_arg("--demo-size", "720x1280"))
	var safe_area := _arg("--safe-area", "none")
	var reduced_motion := _arg("--reduced-motion", "true") == "true"
	shell.set_safe_area_preset(safe_area)
	shell.set_reduced_motion_enabled(reduced_motion)
	await get_tree().process_frame
	await get_tree().process_frame
	var messages = shell.messages_screen
	var gallery = shell.gallery_screen
	var baseline := _messages_snapshot(messages)
	var initial: Dictionary = shell.describe_layout()
	_expect(shell.get_window().size == expected_size, "window size must match the scenario")
	_expect(str(initial.get("active_tab", "")) == "messages", "launch must start on Messages")
	_expect(bool(initial.get("messages_visible", false)), "Messages must be visible on launch")
	_expect(not bool(initial.get("gallery_visible", true)), "Galerie must be hidden on launch")
	_expect(shell.messages_button.has_focus(), "Messages navigation must own launch focus")

	var right := _key(KEY_RIGHT)
	Input.parse_input_event(right)
	await _settle(reduced_motion)
	var opened: Dictionary = shell.describe_layout()
	_expect(str(opened.get("active_tab", "")) == "gallery", "right from Messages navigation must open Galerie")
	_expect(bool(opened.get("gallery_visible", false)), "Galerie must be visible after opening")
	_expect(not bool(opened.get("messages_visible", true)), "Messages must hide after opening Galerie")
	_expect(bool(opened.get("gallery_button_pressed", false)), "Galerie navigation must be active")
	_expect(shell.gallery_button.has_focus(), "Galerie navigation must keep focus on opening")
	_expect(_visible_diegetic_surface_count(shell) == 1, "exactly one diegetic surface must be visible")

	var state: Dictionary = gallery.describe_state()
	_expect(str(state.get("selected_character_id", "")) == "marie", "Marie must be selected initially")
	_expect(int(state.get("tab_count", 0)) == 5, "Galerie must expose five character tabs")
	_expect(int(state.get("tile_count", 0)) == 7, "Marie must expose seven tiles")
	_expect(str(state.get("counter_text", "")) == "7 photos", "Marie counter must read 7 photos")
	_expect(int(state.get("column_count", 0)) == 3, "normal portrait width must use three columns")
	_expect(not bool(state.get("empty_state_visible", true)), "Marie must not show the empty state")
	_expect(bool(state.get("grid_visible", false)), "Marie grid must be visible")
	_expect(not bool(state.get("has_horizontal_crop", true)), "Galerie must have no horizontal crop")
	_expect(bool(state.get("tile_ratios_consistent", false)), "tile ratios must remain coherent")
	_expect(float(state.get("minimum_tile_target", 0.0)) >= 48.0, "tile targets must be at least 48 units")
	_expect(float(state.get("tab_minimum_height", 0.0)) >= 48.0, "tab targets must be at least 48 units")
	_expect(gallery.column_count_for_width(420.0) == 2, "narrow useful width must use two columns")
	_validate_bounds(shell, state)

	gallery.focus_selected_tab()
	await get_tree().process_frame
	_expect(bool(gallery.describe_state().get("selected_tab_has_focus", false)), "selected tab must show keyboard focus")
	gallery.character_tabs._on_tab_gui_input(_key(KEY_RIGHT), "marie")
	await get_tree().process_frame
	_expect(str(gallery.describe_state().get("selected_character_id", "")) == "sandra", "right must move between character tabs")
	_expect(shell.active_tab == shell.TAG_GALLERY, "internal tab navigation must not change the main surface")
	gallery.character_tabs._on_tab_gui_input(_key(KEY_LEFT), "sandra")
	await get_tree().process_frame
	_expect(str(gallery.describe_state().get("selected_character_id", "")) == "marie", "left must return to Marie")

	gallery.focus_first_tile()
	await get_tree().process_frame
	var first_tile_id := str(gallery.describe_state().get("focused_tile_id", ""))
	_expect(first_tile_id == "marie_01", "first tile must be keyboard focusable")
	gallery.tile_buttons[0]._on_gui_input(_key(KEY_RIGHT))
	await get_tree().process_frame
	_expect(str(gallery.describe_state().get("focused_tile_id", "")) == "marie_02", "right must move between tiles")
	shell._unhandled_input(_key(KEY_LEFT))
	_expect(shell.active_tab == shell.TAG_GALLERY, "shell left/right must stay local when a Gallery tile owns focus")

	gallery.select_character("pauline")
	await get_tree().process_frame
	var pauline: Dictionary = gallery.describe_state()
	_expect(int(pauline.get("tile_count", -1)) == 0, "Pauline must expose no tile")
	_expect(bool(pauline.get("empty_state_visible", false)), "Pauline must show the empty state")
	_expect(not bool(pauline.get("grid_visible", true)), "Pauline must hide the grid")
	_expect(str(pauline.get("counter_text", "")) == "0 photos", "Pauline counter must remain discrete")

	gallery.select_character("marie")
	await get_tree().process_frame
	_expect(int(gallery.describe_state().get("tile_count", 0)) == 7, "returning to Marie must restore seven tiles")
	gallery.select_character("raphaelle")
	await get_tree().process_frame
	_expect(int(gallery.describe_state().get("tile_count", 0)) == 2, "Raphaëlle must expose two tiles")

	shell.messages_button.emit_signal("pressed")
	await _settle(reduced_motion)
	_expect(shell.active_tab == shell.TAG_MESSAGES, "Messages navigation must close Galerie")
	_expect(shell.messages_button.has_focus(), "Messages navigation must recover focus")
	_expect(not _gallery_hidden_control_has_focus(shell), "hidden Gallery controls must not keep focus")
	shell.gallery_button.emit_signal("pressed")
	await _settle(reduced_motion)
	_expect(str(gallery.describe_state().get("selected_character_id", "")) == "raphaelle", "Galerie must retain Raphaëlle across round trips")

	var surface_count_before := _visible_diegetic_surface_count(shell)
	var requests_before := int(gallery.describe_state().get("photo_request_count", 0))
	gallery.activate_first_tile()
	await get_tree().process_frame
	var after_request: Dictionary = gallery.describe_state()
	_expect(int(after_request.get("photo_request_count", 0)) == requests_before + 1, "one tile activation must emit exactly one local request")
	_expect(shell.is_photo_viewer_active(), "tile activation must open the unique PhotoViewer")
	_expect(shell.photo_viewer.source_kind() == "gallery", "tile activation must preserve Gallery provenance")
	_expect(_visible_diegetic_surface_count(shell) == surface_count_before, "PhotoViewer must not duplicate tab surfaces")
	shell._close_photo_viewer()
	for frame in range(5):
		await get_tree().process_frame
	_expect(not shell.is_photo_viewer_active(), "Retour must close PhotoViewer")
	_expect(shell.active_tab == shell.TAG_GALLERY, "Retour must restore Galerie")
	_expect(str(gallery.describe_state().get("focused_tile_id", "")) == "raphaelle_01", "Retour must focus the opened tile")
	_expect(_messages_snapshot(messages) == baseline, "Gallery interactions must not mutate Messages, unread, typing, or day state")

	var capture_path := _arg("--capture", "")
	if capture_path != "":
		var capture_character := _arg("--capture-character", "marie")
		gallery.select_character(capture_character)
		await get_tree().process_frame
		await get_tree().process_frame
		if gallery.tile_buttons.is_empty():
			gallery.focus_selected_tab()
		else:
			gallery.focus_first_tile()
		await RenderingServer.frame_post_draw
		var image := get_viewport().get_texture().get_image()
		var save_error := image.save_png(capture_path)
		_expect(save_error == OK, "capture must be written")

	_finish()

func _validate_bounds(shell, state: Dictionary) -> void:
	var visible: Rect2 = Rect2(shell.safe_area_container.get_visible_bounds())
	var content: Rect2 = state.get("content_bounds", Rect2())
	var tabs: Rect2 = state.get("tab_bounds", Rect2())
	var grid_bounds: Rect2 = state.get("grid_bounds", Rect2())
	var nav_top: float = min(shell.messages_button.get_global_rect().position.y, shell.gallery_button.get_global_rect().position.y)
	_expect(visible.encloses(content), "Gallery content must remain inside the useful safe area: visible=%s content=%s" % [visible, content])
	_expect(_rect_encloses_with_tolerance(content, tabs), "character tabs must remain inside Gallery content: content=%s tabs=%s" % [content, tabs])
	_expect(_rect_encloses_with_tolerance(content, grid_bounds), "grid must remain inside Gallery content: content=%s grid=%s" % [content, grid_bounds])
	_expect(grid_bounds.end.y <= nav_top + 1.0, "grid must not overlap bottom navigation")

func _rect_encloses_with_tolerance(outer: Rect2, inner: Rect2) -> bool:
	return inner.position.x >= outer.position.x - 1.0 and inner.position.y >= outer.position.y - 1.0 and inner.end.x <= outer.end.x + 1.0 and inner.end.y <= outer.end.y + 1.0

func _messages_snapshot(messages) -> Dictionary:
	var unread := 0
	var message_count := 0
	for thread in messages.threads:
		var thread_id := str(thread.get("thread_id", ""))
		unread += messages.thread_unread_count(thread_id)
		message_count += messages.thread_message_count(thread_id)
	return {
		"unread": unread,
		"message_count": message_count,
		"typing": messages.typing_states_by_thread.duplicate(true),
		"day": messages.current_demo_day(),
		"thread_count": messages.threads.size(),
	}

func _visible_diegetic_surface_count(shell) -> int:
	return int(shell.messages_panel.visible) + int(shell.gallery_panel.visible)

func _gallery_hidden_control_has_focus(shell) -> bool:
	var owner := get_viewport().gui_get_focus_owner()
	return owner != null and shell.gallery_panel.is_ancestor_of(owner)

func _settle(reduced_motion: bool) -> void:
	await get_tree().process_frame
	if not reduced_motion:
		await get_tree().create_timer(0.16).timeout
	await get_tree().process_frame

func _key(code: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.pressed = true
	event.keycode = code
	return event

func _arg(prefix: String, default_value: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="):
			return arg.trim_prefix(prefix + "=")
	return default_value

func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x")
	if parts.size() != 2:
		return Vector2i.ZERO
	return Vector2i(int(parts[0]), int(parts[1]))

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _finish() -> void:
	if failures.is_empty():
		print("T-UI-03A Gallery Core smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-03A Gallery Core smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
