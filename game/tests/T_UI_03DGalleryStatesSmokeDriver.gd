extends Node

const DEMO_SCENE := preload("res://scenes/portrait/PortraitShellDemo.tscn")

var failures: Array[String] = []
var current_photo_changed_count := 0

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
	var safe_area := _arg("--safe-area", "none")
	var reduced_motion := _arg("--reduced-motion", "true") == "true"
	shell.set_safe_area_preset(safe_area)
	shell.set_reduced_motion_enabled(reduced_motion)
	await _frames(3)
	_expect(shell.get_window().size == resolution, "scenario resolution mismatch")
	var gallery = shell.gallery_screen
	var messages = shell.messages_screen
	shell.activate_gallery(false)
	await _frames(3)

	await _expect_character_counts(gallery, "marie", 7, 6, 2, 1)
	await _expect_character_counts(gallery, "sandra", 4, 3, 1, 1)
	await _expect_character_counts(gallery, "mathilde", 3, 2, 1, 1)
	await _expect_character_counts(gallery, "pauline", 0, 0, 0, 0)
	await _expect_character_counts(gallery, "raphaelle", 2, 1, 0, 1)
	gallery.select_character("marie")
	await _frames(2)
	var initial: Dictionary = gallery.describe_state()
	_expect(gallery.display_state_for_item("marie_01") == "VIEWED", "marie_01 initial VIEWED mismatch")
	_expect(gallery.display_state_for_item("marie_02") == "NEW", "marie_02 initial NEW mismatch")
	_expect(gallery.display_state_for_item("marie_03") == "LOCKED", "marie_03 initial LOCKED mismatch")
	_expect(gallery.display_state_for_item("marie_06") == "NEW", "marie_06 initial NEW mismatch")
	_expect(str(initial.get("counter_text", "")) == "7 photos", "counter must include LOCKED slots")
	_expect(int(initial.get("visible_new_badge_count", -1)) == 2, "Marie must show two Nouveau badges")
	_expect(int(initial.get("visible_locked_tile_count", -1)) == 1, "Marie must show one LOCKED tile")
	_expect(float(initial.get("minimum_tile_target", 0.0)) >= 48.0, "tile target too small")
	_expect(not bool(initial.get("has_horizontal_crop", true)), "gallery horizontal crop")

	var locked_tile = _tile_for(gallery, "marie_03")
	_expect(locked_tile != null, "marie_03 tile missing")
	if locked_tile != null:
		_expect(locked_tile.focus_mode == Control.FOCUS_ALL, "LOCKED tile must be focusable")
		_expect(locked_tile.displayed_primary_text() == "🔒\nPhoto verrouillée", "LOCKED copy mismatch")
		_expect(locked_tile.locked_copy_visible(), "LOCKED copy must be visible")
		_expect(not locked_tile.new_badge_visible(), "LOCKED cannot show Nouveau")
		_expect(not locked_tile.text.contains("marie_03"), "LOCKED reveals item id")
		_expect(locked_tile.tooltip_text == "", "LOCKED must not add a tooltip")
		gallery.focus_item("marie_03", false)
		await _frames(1)
		var locked_scroll: int = gallery.grid_scroll.scroll_vertical
		var locked_requests: int = gallery.photo_request_count
		var fixtures_before_locked: Dictionary = gallery.fixtures.duplicate(true)
		var messages_before_locked: Dictionary = _messages_snapshot(messages)
		locked_tile.emit_signal("pressed")
		await _frames(2)
		_expect(not shell.is_photo_viewer_active(), "LOCKED opened viewer")
		_expect(gallery.photo_request_count == locked_requests, "LOCKED incremented request count")
		_expect(gallery.fixtures == fixtures_before_locked, "LOCKED mutated fixtures")
		_expect(_messages_snapshot(messages) == messages_before_locked, "LOCKED mutated Messages")
		_expect(gallery.grid_scroll.scroll_vertical == locked_scroll, "LOCKED changed scroll")
		_expect(locked_tile.has_focus(), "LOCKED lost focus")

	var marie_02 = _tile_for(gallery, "marie_02")
	_expect(marie_02 != null and marie_02.new_badge_visible(), "marie_02 Nouveau badge missing")
	gallery.focus_item("marie_02", false)
	await _frames(1)
	var first_origin_scroll: int = gallery.grid_scroll.scroll_vertical
	var before_first: Dictionary = _is_new_map(gallery)
	marie_02.emit_signal("pressed")
	await _frames(3)
	_expect(shell.is_photo_viewer_active(), "NEW photo did not open")
	_expect(shell.photo_viewer.source_kind() == "gallery", "NEW viewer source mismatch")
	_expect(shell.photo_viewer.current_photo_id() == "marie_02", "NEW viewer photo mismatch")
	_expect(shell.photo_viewer.displayed_access_state() == "Accessible", "Accessible label missing")
	_expect(_viewer_ids(shell.photo_viewer) == ["marie_01", "marie_02", "marie_04", "marie_05", "marie_06", "marie_07"], "LOCKED filter/order mismatch")
	_expect(gallery.display_state_for_item("marie_02") == "VIEWED", "opened NEW did not become VIEWED")
	_expect(gallery.new_item_count("marie") == 1, "Marie NEW count should be one")
	_expect(_only_is_new_change(before_first, _is_new_map(gallery), "marie_02"), "unexpected first mutation")
	_validate_viewer_geometry(shell)
	shell._close_photo_viewer()
	await _frames(5)
	_expect(gallery.grid_scroll.scroll_vertical == first_origin_scroll, "unchanged close did not restore exact scroll")
	_expect(str(gallery.describe_state().get("focused_tile_id", "")) == "marie_02", "marie_02 focus not restored")
	_expect(not _tile_for(gallery, "marie_02").new_badge_visible(), "marie_02 badge still visible")

	var second_before: Dictionary = gallery.fixtures.duplicate(true)
	_tile_for(gallery, "marie_02").emit_signal("pressed")
	await _frames(3)
	_expect(gallery.fixtures == second_before, "second VIEWED opening mutated fixtures")
	shell.photo_viewer.current_photo_changed.connect(_count_photo_change)
	var before_navigation_count := current_photo_changed_count
	var before_navigation: Dictionary = _is_new_map(gallery)
	shell.photo_viewer.show_next()
	shell.photo_viewer.show_next()
	shell.photo_viewer.show_next()
	await _frames(2)
	_expect(shell.photo_viewer.current_photo_id() == "marie_06", "navigation did not reach marie_06")
	_expect(current_photo_changed_count == before_navigation_count + 3, "current_photo_changed count mismatch")
	_expect(gallery.display_state_for_item("marie_06") == "VIEWED", "navigation did not mark marie_06 VIEWED")
	_expect(gallery.new_item_count("marie") == 0, "Marie NEW count should be zero")
	_expect(_only_is_new_change(before_navigation, _is_new_map(gallery), "marie_06"), "unexpected navigation mutation")
	var boundary_count := current_photo_changed_count
	shell.photo_viewer.show_next()
	shell.photo_viewer.show_next()
	_expect(shell.photo_viewer.current_photo_id() == "marie_07", "next boundary looped")
	_expect(current_photo_changed_count == boundary_count + 1, "boundary emitted extra signal")
	shell.photo_viewer.show_previous()
	shell._close_photo_viewer()
	await _frames(5)
	_expect(str(gallery.describe_state().get("focused_tile_id", "")) == "marie_06", "changed close focus mismatch")

	gallery.select_character("sandra")
	await _frames(2)
	_expect(gallery.display_state_for_item("sandra_02") == "NEW", "Sandra NEW was mutated")
	gallery.select_character("marie")
	await _frames(2)
	_expect(gallery.display_state_for_item("marie_02") == "VIEWED", "Marie state lost on character switch")
	_expect(gallery.display_state_for_item("marie_06") == "VIEWED", "Marie navigation state lost")
	shell.activate_messages(false)
	await _frames(2)
	shell.activate_gallery(false)
	await _frames(2)
	_expect(gallery.new_item_count("marie") == 0, "state lost on tab round trip")

	var gallery_before_message: Dictionary = gallery.fixtures.duplicate(true)
	shell.activate_messages(false)
	await _frames(2)
	var private_id := str(messages.describe_state().get("private_thread_id", ""))
	messages.open_thread(private_id)
	await _frames(3)
	messages.conversation_screen.timeline.focus_first_image()
	messages.conversation_screen.timeline.activate_first_image()
	await _frames(3)
	_expect(shell.is_photo_viewer_active(), "Messages image did not open")
	_expect(shell.photo_viewer.source_kind() == "messages", "Messages source mismatch")
	_expect(shell.photo_viewer.displayed_access_state() == "Accessible", "Messages Accessible label missing")
	_expect(gallery.fixtures == gallery_before_message, "Messages opening mutated Gallery")
	shell._close_photo_viewer()
	await _frames(5)
	_expect(messages.active_thread_id == private_id, "Messages provenance not restored")
	_expect(messages.conversation_screen.timeline.focused_image_message_id() == "demo_image_private_marie_01", "Messages focus not restored")
	_expect(gallery.fixtures == gallery_before_message, "Messages close mutated Gallery")

	var reset_demo = DEMO_SCENE.instantiate()
	add_child(reset_demo)
	await _frames(3)
	var reset_gallery = reset_demo.shell.gallery_screen
	_expect(reset_gallery.display_state_for_item("marie_02") == "NEW", "new shell did not reset marie_02")
	_expect(reset_gallery.display_state_for_item("marie_06") == "NEW", "new shell did not reset marie_06")
	_expect(reset_gallery.new_item_count("marie") == 2, "new shell Marie NEW count mismatch")
	reset_demo.queue_free()

	var capture := _arg("--capture", "")
	if capture != "":
		var capture_demo = DEMO_SCENE.instantiate()
		add_child(capture_demo)
		await _frames(3)
		var capture_shell = capture_demo.shell
		var capture_gallery = capture_shell.gallery_screen
		capture_shell.set_safe_area_preset(safe_area)
		capture_shell.set_reduced_motion_enabled(reduced_motion)
		capture_shell.activate_gallery(false)
		capture_gallery.select_character(_arg("--capture-character", "marie"))
		await _frames(3)
		if _arg("--capture-kind", "states") == "viewer":
			var target = _tile_for(capture_gallery, "marie_01")
			if target != null:
				target.emit_signal("pressed")
				await _frames(3)
		else:
			capture_gallery.focus_item("marie_03", false)
		await RenderingServer.frame_post_draw
		_expect(get_viewport().get_texture().get_image().save_png(capture) == OK, "capture save_png failed")
		capture_demo.queue_free()
	_finish()

func _expect_character_counts(gallery, character_id: String, total: int, unlocked: int, new_count: int, locked: int) -> void:
	gallery.select_character(character_id)
	await _frames(2)
	var state: Dictionary = gallery.describe_state()
	_expect(int(state.get("tile_count", -1)) == total, "%s total mismatch" % character_id)
	_expect(int(state.get("unlocked_item_count", -1)) == unlocked, "%s unlocked mismatch" % character_id)
	_expect(int(state.get("new_item_count", -1)) == new_count, "%s NEW mismatch" % character_id)
	_expect(int(state.get("locked_item_count", -1)) == locked, "%s LOCKED mismatch" % character_id)

func _validate_viewer_geometry(shell) -> void:
	var viewer_rect: Rect2 = shell.photo_viewer.viewer_global_rect()
	var visual_rect: Rect2 = shell.photo_viewer.visual_global_rect()
	var visible := Rect2(shell.safe_area_container.get_visible_bounds())
	_expect(_rect_within(viewer_rect, visible), "viewer outside safe area")
	_expect(_rect_within(visual_rect, visible), "visual outside safe area")
	_expect(not shell.photo_viewer.has_horizontal_crop(), "viewer horizontal crop")
	_expect(not shell.photo_viewer.has_vertical_crop(), "viewer vertical crop")
	_expect(absf(shell.photo_viewer.visual_ratio() - 0.75) < 0.01, "viewer ratio mismatch")

func _count_photo_change(_photo_id: String) -> void:
	current_photo_changed_count += 1

func _tile_for(gallery, item_id: String):
	for tile in gallery.tile_buttons:
		if str(tile.item_id) == item_id:
			return tile
	return null

func _viewer_ids(viewer) -> Array[String]:
	var result: Array[String] = []
	for presentation in viewer.presentations:
		result.append(str(presentation.get("photo_id", "")))
	return result

func _is_new_map(gallery) -> Dictionary:
	var result := {}
	for character_id in gallery.fixtures:
		for item in gallery.fixtures[character_id].get("items", []):
			result[str(item.get("item_id", ""))] = bool(item.get("is_new", false))
	return result

func _only_is_new_change(before: Dictionary, after: Dictionary, expected_id: String) -> bool:
	if before.keys().size() != after.keys().size():
		return false
	var changed: Array[String] = []
	for item_id in before:
		if not after.has(item_id):
			return false
		if before[item_id] != after[item_id]:
			changed.append(str(item_id))
	return changed == [expected_id] and bool(before.get(expected_id, false)) and not bool(after.get(expected_id, true))

func _messages_snapshot(messages) -> Dictionary:
	return {
		"presentations": messages.total_presentation_count(),
		"unread_private": messages.thread_unread_count("demo_private_marie"),
		"unread_group": messages.thread_unread_count("demo_group_verriere"),
		"typing": messages.typing_states_by_thread.duplicate(true),
		"day": messages.current_demo_day(),
	}

func _rect_within(inner: Rect2, outer: Rect2) -> bool:
	return inner.position.x >= outer.position.x - 1.0 and inner.position.y >= outer.position.y - 1.0 and inner.end.x <= outer.end.x + 1.0 and inner.end.y <= outer.end.y + 1.0

func _frames(count: int) -> void:
	for index in range(count):
		await get_tree().process_frame

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
		print("T-UI-03D Gallery States smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("T-UI-03D Gallery States smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
