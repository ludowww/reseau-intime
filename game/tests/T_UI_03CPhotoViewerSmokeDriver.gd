extends Node

const DEMO_SCENE := preload("res://scenes/portrait/PortraitShellDemo.tscn")
var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var demo = DEMO_SCENE.instantiate()
	add_child(demo)
	await _frames(3)
	var shell = demo.shell
	_expect(shell != null, "shell missing")
	if shell == null:
		_finish()
		return
	var resolution := _parse_size(_arg("--demo-size", "720x1280"))
	shell.set_safe_area_preset(_arg("--safe-area", "none"))
	shell.set_reduced_motion_enabled(_arg("--reduced-motion", "true") == "true")
	await _frames(3)
	_expect(shell.get_window().size == resolution, "scenario resolution mismatch")
	var messages = shell.messages_screen
	var gallery = shell.gallery_screen
	var private_id := str(messages.describe_state().get("private_thread_id", ""))
	messages.open_thread(private_id)
	await _frames(3)
	var invalid_before := _snapshot(messages, gallery)
	var valid_message: Dictionary = {}
	for candidate in messages.transcripts.get(private_id, []):
		if str(candidate.get("content_type", "")) == "IMAGE":
			valid_message = candidate
			break
	var valid_presentation := {
		"photo_id": "bounded_test", "visual_ref": "bounded_ref", "access_state": "UNLOCKED", "source_kind": "gallery",
		"character_id": "marie", "display_name": "Marie", "accent_color": Color.WHITE,
		"context_label": "Galerie", "timestamp": "", "caption": "",
	}
	var one_valid: Array[Dictionary] = [valid_presentation]
	var empty_sequence: Array[Dictionary] = []
	shell._on_gallery_photo_requested("marie_01")
	_expect(not shell.is_photo_viewer_active() and _snapshot(messages, gallery) == invalid_before, "hidden gallery request must be rejected")
	if shell.is_photo_viewer_active():
		shell._close_photo_viewer()
	shell.activate_gallery(false)
	shell._open_photo_viewer(empty_sequence, 0, {"source_kind": "gallery"})
	shell._open_photo_viewer(one_valid, -1, {"source_kind": "gallery"})
	shell._open_photo_viewer(one_valid, 1, {"source_kind": "gallery"})
	var missing_photo: Array[Dictionary] = [valid_presentation.duplicate(true)]
	missing_photo[0].erase("photo_id")
	shell._open_photo_viewer(missing_photo, 0, {"source_kind": "gallery"})
	shell._open_photo_viewer(one_valid, 0, {"source_kind": "unknown"})
	var locked_presentation := valid_presentation.duplicate(true)
	locked_presentation["access_state"] = "LOCKED"
	var locked_sequence: Array[Dictionary] = [locked_presentation]
	shell._open_photo_viewer(locked_sequence, 0, {"source_kind": "gallery"})
	_expect(not shell.is_photo_viewer_active(), "viewer must reject non-UNLOCKED presentation")
	shell.activate_messages(false)
	messages._on_image_requested(str(valid_message.get("message_id", "")), "wrong_media_ref")
	messages._on_image_requested("demo_image_group_marie_01", "demo_media_group_marie_01")
	var player_image := valid_message.duplicate(true)
	player_image["message_id"] = "bounded_player_image"
	player_image["is_player"] = true
	messages.transcripts[private_id].append(player_image)
	messages._on_image_requested("bounded_player_image", str(player_image.get("media_ref", "")))
	messages.transcripts[private_id].pop_back()
	messages.off_phone_state = {"active": true}
	messages._on_image_requested(str(valid_message.get("message_id", "")), str(valid_message.get("media_ref", "")))
	messages.off_phone_state = {}
	messages.day_transition_state = {"active": true}
	messages._on_image_requested(str(valid_message.get("message_id", "")), str(valid_message.get("media_ref", "")))
	messages.day_transition_state = {}
	var unknown_thread_id := "bounded_unknown_thread"
	var unknown_message := valid_message.duplicate(true)
	unknown_message["message_id"] = "bounded_unknown_image"
	messages.transcripts[unknown_thread_id] = [unknown_message]
	var unknown_transcripts_before: Dictionary = messages.transcripts.duplicate(true)
	var unknown_state_before := _snapshot(messages, gallery)
	messages.active_thread_id = unknown_thread_id
	messages._on_image_requested("bounded_unknown_image", str(unknown_message.get("media_ref", "")))
	_expect(not shell.is_photo_viewer_active() and messages.transcripts == unknown_transcripts_before and _snapshot(messages, gallery) == unknown_state_before, "unknown active thread must reject injected transcript")
	if shell.is_photo_viewer_active():
		shell._close_photo_viewer()
	messages.transcripts.erase(unknown_thread_id)
	messages.active_thread_id = private_id
	shell.activate_gallery(false)
	messages._on_image_requested(str(valid_message.get("message_id", "")), str(valid_message.get("media_ref", "")))
	_expect(not shell.is_photo_viewer_active() and _snapshot(messages, gallery) == invalid_before, "hidden messages request must be rejected")
	if shell.is_photo_viewer_active():
		shell._close_photo_viewer()
	shell.activate_messages(false)
	_expect(not shell.is_photo_viewer_active() and _snapshot(messages, gallery) == invalid_before, "invalid viewer requests must not mutate state")
	messages.start_typing(private_id, "marie")
	await _frames(2)
	var bar: VScrollBar = messages.conversation_screen.timeline.get_v_scroll_bar()
	var saved_scroll := maxi(0, int((bar.max_value - bar.page) / 2.0))
	messages.conversation_screen.timeline.set_reading_position(saved_scroll)
	messages.conversation_screen.timeline.focus_first_image()
	await _frames(1)
	var private_before_viewer := _snapshot(messages, gallery)
	messages.conversation_screen.timeline.activate_first_image()
	await _frames(2)
	var opened: Dictionary = shell.describe_layout()
	var viewer_global_rect: Rect2 = shell.photo_viewer.viewer_global_rect()
	var visual_global_rect: Rect2 = shell.photo_viewer.visual_global_rect()
	var visible_bounds := Rect2(shell.safe_area_container.get_visible_bounds())
	var actual_visual_ratio := visual_global_rect.size.x / visual_global_rect.size.y
	_expect(_rect_within(viewer_global_rect, visible_bounds), "viewer global rect must remain inside safe bounds")
	_expect(_rect_within(visual_global_rect, visible_bounds), "visual global rect must remain inside safe bounds")
	_expect(not shell.photo_viewer.has_horizontal_crop() and not shell.photo_viewer.has_vertical_crop(), "viewer must have no horizontal or vertical overflow")
	_expect(absf(actual_visual_ratio - 0.75) < 0.01, "actual visual ratio must be 3:4")
	_expect(bool(opened.get("photo_viewer_visible", false)), "message photo must open viewer")
	_expect(str(opened.get("photo_viewer_source", "")) == "messages", "message source mismatch")
	_expect(str(opened.get("photo_viewer_current_id", "")) == "demo_image_private_marie_01", "private photo mismatch")
	_expect(shell.photo_viewer.displayed_name() == "Marie", "private author must be Marie")
	_expect(shell.photo_viewer.displayed_context() == "Conversation · 21:16", "private context mismatch")
	_expect(shell.photo_viewer.displayed_caption() == "Une photo de démonstration envoyée dans ce fil.", "private caption mismatch")
	_expect(shell.photo_viewer.displayed_access_state() == "Accessible", "private access label mismatch")
	_expect(absf(float(opened.get("photo_viewer_ratio", 0.0)) - 0.75) < 0.01, "viewer ratio mismatch")
	_expect(not bool(opened.get("shell_column_visible", true)), "shell column must hide")
	_expect(not bool(opened.get("header_visible", true)), "header must hide")
	_expect(not bool(opened.get("bottom_navigation_visible", true)), "bottom navigation must hide")
	_expect(bool(opened.get("photo_viewer_back_focus", false)), "Retour must own focus")
	_expect(not bool(opened.get("photo_viewer_previous_visible", true)), "message previous must hide")
	_expect(not bool(opened.get("photo_viewer_next_visible", true)), "message next must hide")
	_expect(int(opened.get("photo_viewer_action_count", 0)) == 1, "message viewer must expose one action")
	_expect(not bool(opened.get("photo_viewer_has_horizontal_crop", true)), "message viewer must not crop")
	_expect(not messages.conversation_screen.typing_visible(), "typing visual must hide")
	_expect(messages.is_thread_typing(private_id), "typing state must survive")
	var active_before: String = shell.active_tab
	shell.activate_gallery()
	shell.activate_messages()
	shell.gallery_button.emit_signal("pressed")
	_expect(shell.active_tab == active_before and shell.is_photo_viewer_active(), "tabs must be no-op in viewer")
	shell.set_reduced_motion_enabled(not shell.reduced_motion_enabled)
	_expect(shell.is_photo_viewer_active() and shell.photo_viewer.back_has_focus(), "reduced motion must preserve viewer focus")
	messages.conversation_screen.timeline.activate_first_image()
	_expect(shell.is_photo_viewer_active(), "duplicate opening must be ignored")
	var message_photo_id: String = shell.photo_viewer.current_photo_id()
	_expect(not shell.photo_viewer.handle_navigation_event(_key(KEY_LEFT)) and not shell.photo_viewer.handle_navigation_event(_key(KEY_RIGHT)) and shell.photo_viewer.current_photo_id() == message_photo_id, "message arrows must be no-op")
	var typing_restore_events := [0]
	messages.conversation_screen.timeline.message_box.child_entered_tree.connect(func(_child): typing_restore_events[0] += 1)
	shell.photo_viewer.back_button.emit_signal("pressed")
	await _frames(5)
	_expect(not shell.is_photo_viewer_active(), "message viewer must close")
	_expect(messages.active_thread_id == private_id, "private thread must restore")
	_expect(messages.conversation_screen.get_reading_position() == saved_scroll, "private scroll must restore exactly")
	_expect(messages.conversation_screen.timeline.focused_image_message_id() == "demo_image_private_marie_01", "private image focus must restore")
	_expect(messages.is_thread_typing(private_id) and messages.conversation_screen.typing_visible(), "typing must restore once")
	_expect(messages.conversation_screen.typing_instance_count() == 1, "typing must have exactly one visual instance")
	_expect(typing_restore_events[0] == 1, "typing visual must be restored exactly once")
	_expect(_snapshot(messages, gallery) == private_before_viewer, "private viewer must not mutate presentation state")

	messages.stop_typing(private_id)
	messages.return_to_list()
	await _frames(2)
	var group_id := str(messages.describe_state().get("group_thread_id", ""))
	messages.open_thread(group_id)
	await _frames(3)
	var group_before_viewer := _snapshot(messages, gallery)
	messages.conversation_screen.timeline.focus_first_image()
	messages.conversation_screen.timeline.activate_first_image()
	await _frames(2)
	_expect(shell.photo_viewer.displayed_name() == "Marie", "group image author must be Marie")
	_expect(shell.photo_viewer.displayed_context() == "Conversation · 20:46", "group context mismatch")
	_expect(shell.photo_viewer.displayed_caption() == "", "group caption must be absent")
	_expect(shell.photo_viewer.displayed_access_state() == "Accessible", "group access label mismatch")
	_expect(shell.photo_viewer.caption_label != null and not shell.photo_viewer.caption_label.visible, "group caption must reserve no visible space")
	shell._close_photo_viewer()
	await _frames(4)
	_expect(messages.active_thread_id == group_id and messages.conversation_screen.timeline.focused_image_message_id() == "demo_image_group_marie_01", "group provenance must restore")
	_expect(_snapshot(messages, gallery) == group_before_viewer, "group viewer must not mutate presentation state")

	shell.activate_gallery(false)
	await _frames(2)
	gallery.select_character("marie")
	await _frames(2)
	gallery.grid.custom_minimum_size.y = maxf(gallery.grid.size.y, 1300.0)
	await _frames(2)
	var gallery_bar: VScrollBar = gallery.grid_scroll.get_v_scroll_bar()
	var unchanged_scroll := maxi(0, int((gallery_bar.max_value - gallery_bar.page) / 2.0))
	gallery.grid_scroll.scroll_vertical = unchanged_scroll
	gallery.focus_item("marie_04", false)
	var gallery_before_viewer := _snapshot(messages, gallery)
	gallery.tile_buttons[3].emit_signal("pressed")
	await _frames(2)
	opened = shell.describe_layout()
	_expect(str(opened.get("photo_viewer_source", "")) == "gallery", "gallery source mismatch")
	_expect(shell.photo_viewer.presentations.size() == 6, "Marie sequence must contain six accessible photos")
	_expect(_viewer_ids(shell.photo_viewer) == ["marie_01", "marie_02", "marie_04", "marie_05", "marie_06", "marie_07"], "Marie LOCKED photo must be filtered and order preserved")
	_expect(shell.photo_viewer.displayed_context() == "Galerie · Photo démo 04", "gallery context mismatch")
	_expect(shell.photo_viewer.displayed_access_state() == "Accessible", "gallery access label mismatch")
	shell._close_photo_viewer()
	await _frames(5)
	_expect(gallery.grid_scroll.scroll_vertical == unchanged_scroll, "gallery unchanged scroll must restore exactly")
	_expect(str(gallery.describe_state().get("focused_tile_id", "")) == "marie_04", "unchanged gallery photo must receive focus")

	var changed_origin := maxi(1, int(gallery_bar.max_value - gallery_bar.page))
	gallery.grid_scroll.scroll_vertical = changed_origin
	await _frames(2)
	changed_origin = gallery.grid_scroll.scroll_vertical
	var expected_changed_scroll := _minimal_scroll_for_tile(changed_origin, gallery.tile_buttons[3], gallery.grid_scroll, gallery_bar)
	_expect(changed_origin > 0 and expected_changed_scroll > 0, "gallery scroll fixture must exercise a non-top restoration")
	gallery.tile_buttons[6].emit_signal("pressed")
	await _frames(2)
	shell.photo_viewer.previous_button.grab_focus()
	while shell.photo_viewer.previous_enabled():
		shell.photo_viewer.show_previous()
	_expect(shell.photo_viewer.current_photo_id() == "marie_01", "first photo mismatch")
	_expect(not shell.photo_viewer.previous_enabled() and shell.photo_viewer.next_button.has_focus(), "focus must transfer when previous becomes disabled")
	shell.photo_viewer.show_previous()
	_expect(shell.photo_viewer.current_photo_id() == "marie_01", "navigation must not loop")
	while shell.photo_viewer.current_photo_id() != "marie_04" and shell.photo_viewer.next_enabled():
		shell.photo_viewer.show_next()
	_expect(shell.photo_viewer.current_photo_id() == "marie_04", "changed close photo mismatch")
	shell._close_photo_viewer()
	await _frames(5)
	_expect(shell.active_tab == shell.TAG_GALLERY and gallery.selected_character_id == "marie", "gallery provenance must restore")
	_expect(gallery.last_photo_restore_origin_scroll == changed_origin, "gallery navigation must restore origin scroll first")
	_expect(gallery.grid_scroll.scroll_vertical == expected_changed_scroll and gallery.grid_scroll.scroll_vertical > 0, "gallery changed scroll must use minimal movement and not jump to top")
	_expect(str(gallery.describe_state().get("focused_tile_id", "")) == "marie_04", "current gallery tile must receive focus")
	_expect(_snapshot(messages, gallery) == gallery_before_viewer, "gallery navigation must not mutate presentation state")

	gallery.tile_buttons[0].emit_signal("pressed")
	await _frames(2)
	var cancel := InputEventAction.new()
	cancel.action = "ui_cancel"
	cancel.pressed = true
	Input.parse_input_event(cancel)
	await _frames(4)
	_expect(not shell.is_photo_viewer_active(), "InputEventAction ui_cancel must close viewer")
	_expect(shell.active_tab == shell.TAG_GALLERY and gallery.selected_character_id == "marie" and str(gallery.describe_state().get("focused_tile_id", "")) == "marie_01", "InputEventAction ui_cancel must restore gallery provenance")
	_expect(_snapshot(messages, gallery) == gallery_before_viewer, "InputEventAction ui_cancel viewer must not mutate messages or gallery fixtures")

	var capture := _arg("--capture", "")
	if capture != "":
		var capture_kind := _arg("--capture-kind", "gallery")
		if capture_kind == "messages":
			shell.activate_messages(false)
			if messages.screen_mode == "conversation":
				messages.return_to_list()
			await _frames(2)
			messages.open_thread(private_id)
			await _frames(3)
			messages.conversation_screen.timeline.activate_first_image()
		else:
			shell.activate_gallery(false)
			await _frames(2)
			gallery.select_character("marie")
			await _frames(2)
			gallery.tile_buttons[1].emit_signal("pressed")
			await _frames(2)
			shell.photo_viewer.show_next()
		await _frames(2)
		await RenderingServer.frame_post_draw
		_expect(get_viewport().get_texture().get_image().save_png(capture) == OK, "capture must save_png")
	_finish()

func _snapshot(messages, gallery) -> Dictionary:
	return {
		"presentations": messages.total_presentation_count(),
		"players": messages.thread_player_message_count("demo_private_marie") + messages.thread_player_message_count("demo_group_verriere"),
		"choices": messages.thread_choice_count("demo_private_marie") + messages.thread_choice_count("demo_group_verriere"),
		"unread": messages.thread_unread_count("demo_private_marie") + messages.thread_unread_count("demo_group_verriere"),
		"unread_divider_visual_count": messages.conversation_screen.timeline.unread_divider_count(),
		"previews": [messages.thread_preview("demo_private_marie"), messages.thread_preview("demo_group_verriere")],
		"timestamps": [messages.thread_timestamp("demo_private_marie"), messages.thread_timestamp("demo_group_verriere")],
		"typing": messages.typing_states_by_thread.duplicate(true),
		"day": messages.current_demo_day(),
		"off_phone": messages.is_off_phone_transition_active(),
		"day_transition": messages.is_day_transition_active(),
		"day_dividers_private": _content_count(messages.transcripts.get("demo_private_marie", []), "SYSTEM_DAY_DIVIDER"),
		"day_dividers_group": _content_count(messages.transcripts.get("demo_group_verriere", []), "SYSTEM_DAY_DIVIDER"),
		"selected_character": gallery.selected_character_id,
		"gallery_counter": gallery.count_label.text,
		"gallery_fixtures_immutable": _gallery_immutable_snapshot(gallery),
	}

func _viewer_ids(viewer) -> Array[String]:
	var result: Array[String] = []
	for presentation in viewer.presentations:
		result.append(str(presentation.get("photo_id", "")))
	return result

func _gallery_immutable_snapshot(gallery) -> Dictionary:
	var result: Dictionary = gallery.fixtures.duplicate(true)
	for character_id in result:
		for item in result[character_id].get("items", []):
			item.erase("is_new")
	return result

func _content_count(items: Array, content_type: String) -> int:
	var count := 0
	for item in items:
		if item is Dictionary and str(item.get("content_type", "")) == content_type:
			count += 1
	return count

func _frames(count: int) -> void:
	for index in range(count):
		await get_tree().process_frame

func _key(keycode: Key) -> InputEventKey:
	var event := InputEventKey.new()
	event.pressed = true
	event.keycode = keycode
	return event

func _rect_within(inner: Rect2, outer: Rect2) -> bool:
	return inner.position.x >= outer.position.x - 1.0 and inner.position.y >= outer.position.y - 1.0 and inner.end.x <= outer.end.x + 1.0 and inner.end.y <= outer.end.y + 1.0

func _minimal_scroll_for_tile(origin: int, tile: Control, scroll: ScrollContainer, bar: VScrollBar) -> int:
	var tile_rect := tile.get_global_rect()
	var bounds := scroll.get_global_rect()
	var target := origin
	if tile_rect.position.y < bounds.position.y:
		target += int(round(tile_rect.position.y - bounds.position.y))
	elif tile_rect.end.y > bounds.end.y:
		target += int(round(tile_rect.end.y - bounds.end.y))
	return clampi(target, 0, maxi(0, int(bar.max_value - bar.page)))

func _arg(prefix: String, fallback: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="):
			return arg.trim_prefix(prefix + "=")
	return fallback

func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x")
	return Vector2i(int(parts[0]), int(parts[1])) if parts.size() == 2 else Vector2i.ZERO

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _finish() -> void:
	if failures.is_empty():
		print("T-UI-03C PhotoViewer smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-03C PhotoViewer smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
