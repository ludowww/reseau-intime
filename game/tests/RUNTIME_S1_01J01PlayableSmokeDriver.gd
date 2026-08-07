extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const PROVIDER_SCRIPT := preload("res://scripts/runtime/season_1/J01RuntimeProvider.gd")

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	_test_initial_contract_guards()
	var expected_size := _parse_size(_arg("--runtime-size", "720x1280"))
	get_window().size = expected_size
	var main = MAIN_SCENE.instantiate()
	main.get_node("PortraitShell").content_mode = "runtime_s1"
	add_child(main)
	await _frames(4)
	var shell = main.shell
	shell.set_reduced_motion_enabled(true)
	_expect(shell != null, "production shell missing")
	if shell == null:
		_finish()
		return
	_expect(Vector2i(main.get_window().size) == expected_size, "runtime resolution mismatch")
	_expect(shell.content_mode == "runtime_s1", "main must use runtime_s1")
	var messages = shell.messages_screen
	messages.runtime_delivery_time_scale = 0.01
	var gallery = shell.gallery_screen
	var provider = shell.runtime_provider
	_expect(messages.screen_mode == "list" and messages.visible, "Messages list must start visible")
	_expect(messages.threads.size() == 1, "only Marie must be available initially")
	_expect(messages._thread_for("thread_marie_private").get("title", "") == "Marie", "Marie thread missing")
	_expect(messages._thread_for("thread_sandra_private").is_empty(), "Sandra must be locked")
	_expect(messages.describe_state().get("group_thread_id", "") == "", "no group thread allowed")
	_expect(gallery.character_order == ["marie", "sandra"], "production gallery contacts mismatch")
	_expect(gallery.unlocked_item_count("marie") == 0 and gallery.unlocked_item_count("sandra") == 0, "production gallery must be empty")
	_expect(gallery.empty_state_text() == "Aucun visuel disponible.", "gallery empty copy mismatch")
	_expect(not _visible_text_exists(shell, "Démonstration hors récit"), "production must hide demo subtitle")
	_expect(not _visible_text_exists(shell, "Coque portrait additive — Messages / Galerie"), "production must hide prototype shell subtitle")
	_expect(not _visible_text_exists(shell, "Animations réduites"), "production must hide debug motion label")

	await _open_thread_from_card(messages, "thread_marie_private")
	await _frames(2)
	_expect(messages.thread_choice_count("thread_marie_private") == 1, "guided Marie reply must wait for click")
	_expect(messages.thread_player_message_count("thread_marie_private") == 0, "Marie choice must not auto-click")
	await _choose_twice_and_expect_single(messages, "choice_j1_marie_optimism_guided")
	_expect(messages.conversation_screen.timeline.visible_player_author_count() == 0, "Player must have no visible author label")
	await _choose(messages, "choice_j1_marie_crisis_guided")
	_expect(messages.thread_choice_count("thread_marie_private") == 3, "Marie three-choice node unreachable")
	await _choose(messages, "choice_j1_marie_present")
	_expect(provider.state.promises["marie_j01_shared_evening"]["status"] == "ACTIVE", "Marie present must activate promise")
	await _choose(messages, "choice_j1_marie_laverriere_guided")
	await _choose(messages, "choice_j1_marie_mathilde_guided")
	await _frames(2)
	var marie_scroll_before_transition: int = messages.conversation_screen.get_reading_position()
	_expect(messages.describe_state().get("time_passage_surface_count", 0) == 1, "unified overlay must remain a single instance")
	await _wait_time_passage(messages)
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == "thread_marie_private", "first transition must resume Marie conversation")
	_expect(messages.conversation_screen.get_reading_position() == marie_scroll_before_transition, "Marie transition must preserve scroll")
	_expect(provider.state.promises["marie_j01_shared_evening"]["status"] == "PAID", "Marie promise must be paid")
	_expect(not provider.state.pay_marie_promise(), "paid Marie promise must reject a second payment")
	_expect(provider.state.promises["marie_j01_shared_evening"]["status"] == "PAID", "rejected Marie payment must preserve PAID")
	_expect(not messages._thread_for("thread_sandra_private").is_empty(), "Sandra must unlock")
	_expect(messages.thread_unread_count("thread_sandra_private") > 0, "Sandra must be unread")
	_expect(not messages.notification_banner.visible, "global Sandra notification must remain hidden")
	_expect(messages.conversation_screen.header_notification_visible() and messages.conversation_screen.header_notification.notification.get("title", "") == "Sandra", "Sandra header notification missing")
	var marie_count: int = messages.thread_message_count("thread_marie_private")
	messages.conversation_screen.header_notification.activate_open_action()
	await _wait_runtime_delivery_complete(messages)
	_expect(messages.active_thread_id == "thread_sandra_private", "Sandra header notification must open Sandra")
	_expect(messages.thread_message_count("thread_marie_private") == marie_count, "Marie transcript duplicated after notification open")

	await _frames(2)
	await _choose(messages, "choice_j1_sandra_what_guided")
	_expect(messages.presentation_count_by_content_type("thread_sandra_private", "IMAGE") == 1, "Sandra image must be inserted once")
	_expect(messages.presentation_count_by_id("msg_j1_sandra_trace_004") == 1, "Sandra anchor message duplicated")
	var image = _message(messages, "thread_sandra_private", "j01_sandra_lunch_memory_soft")
	_expect(image.get("media_ref", "") == "S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01", "Sandra media_ref mismatch")
	_expect(image.get("placeholder_label", "") == "Visuel non produit", "Sandra placeholder mismatch")
	_expect(provider.state.traces.has("j01_sandra_lunch_memory_soft"), "Sandra trace must activate")
	var photo_position: int = messages.conversation_screen.get_reading_position()
	messages.conversation_screen.timeline.activate_first_image()
	await _frames(2)
	_expect(shell.is_photo_viewer_active(), "Sandra photo viewer must open")
	_expect(not shell.photo_viewer.has_loaded_texture(), "undelivered Sandra asset must not load a substitute")
	_expect(shell.photo_viewer.visual_label.text == "Visuel non livré", "viewer delivery fallback mismatch")
	_expect(not shell.photo_viewer.previous_visible() and not shell.photo_viewer.next_visible(), "message photo must have no previous/next")
	_expect(provider.state.knowledge.has("fact_player_saw_sandra_lunch_photo"), "F08 knowledge missing")
	var knowledge_count: int = provider.state.knowledge.size()
	shell.photo_viewer.back_button.emit_signal("pressed")
	await _frames(3)
	_expect(messages.conversation_screen.get_reading_position() == photo_position, "photo return must restore reading position")
	messages.conversation_screen.timeline.activate_first_image()
	await _frames(1)
	_expect(provider.state.knowledge.size() == knowledge_count, "F08 must be idempotent")
	shell.photo_viewer.back_button.emit_signal("pressed")
	await _frames(2)
	await _choose(messages, "choice_j1_sandra_art_guided")
	await _choose(messages, "choice_j1_sandra_precise_observation")
	_expect(provider.state.sandra_state == "RECONNECTION_OPEN", "precise Sandra choice state mismatch")
	await _choose(messages, "choice_j1_sandra_thanks_guided")
	await _choose(messages, "choice_j1_sandra_goodnight_guided")
	await _frames(2)
	_expect(messages.presentation_count_by_id("msg_j1_sandra_trace_017_precise") == 1, "precise conditional message missing")
	_expect(messages.describe_state().get("time_passage_surface_count", 0) == 1, "J01 end must reuse the unified overlay")
	await _wait_time_passage(messages)
	_expect(provider.j01_provider.day_end_visible, "J01 must complete")
	_expect(provider.active_day == "J02", "J01 must hand off automatically to J02")
	_expect(not messages.is_day_transition_active(), "no J01/J02 informational cards may remain")

	_test_alternate_states()
	_test_snapshot_round_trip()
	_finish()

func _test_initial_contract_guards() -> void:
	var fresh = PROVIDER_SCRIPT.new()
	_expect(fresh.initialize(), "fresh provider init failed")
	_expect(not fresh.mark_photo_opened(), "Sandra photo must reject opening before trace activation")
	_expect(not fresh.state.knowledge.has("fact_player_saw_sandra_lunch_photo"), "F08 must remain absent before trace activation")
	_expect(fresh.state.activate_sandra_trace(), "fresh Sandra trace activation failed")
	_expect(fresh.mark_photo_opened(), "active Sandra photo must create F08")
	var knowledge_count: int = fresh.state.knowledge.size()
	_expect(not fresh.mark_photo_opened(), "repeated Sandra photo opening must be rejected")
	_expect(fresh.state.knowledge.size() == knowledge_count, "repeated Sandra photo opening must not duplicate F08")
	_expect(not fresh.state.pay_marie_promise(), "PROPOSED Marie promise must reject payment")
	_expect(fresh.state.promises["marie_j01_shared_evening"]["status"] == "PROPOSED", "rejected Marie payment must preserve PROPOSED")

func _test_alternate_states() -> void:
	var delayed = PROVIDER_SCRIPT.new()
	_expect(delayed.initialize(), "delayed provider init failed")
	_walk_provider(delayed, "thread_marie_private", [
		"choice_j1_marie_optimism_guided", "choice_j1_marie_crisis_guided",
		"choice_j1_marie_delayed_flat", "choice_j1_marie_laverriere_guided", "choice_j1_marie_mathilde_guided",
	])
	_expect(delayed.state.promises["marie_j01_shared_evening"]["status"] == "AMENDED", "delayed choice must amend promise")
	delayed.confirm_transition()
	_expect(delayed.state.promises["marie_j01_shared_evening"]["status"] == "PAID", "amended promise must become paid")
	var cautious = PROVIDER_SCRIPT.new()
	_expect(cautious.initialize(), "cautious provider init failed")
	_walk_provider(cautious, "thread_marie_private", [
		"choice_j1_marie_optimism_guided", "choice_j1_marie_crisis_guided", "choice_j1_marie_present",
		"choice_j1_marie_laverriere_guided", "choice_j1_marie_mathilde_guided",
	])
	cautious.confirm_transition()
	_walk_provider(cautious, "thread_sandra_private", [
		"choice_j1_sandra_what_guided", "choice_j1_sandra_art_guided", "choice_j1_sandra_cautious",
	])
	_expect(cautious.state.sandra_state == "DISTANT_FRIEND", "cautious Sandra choice must remain distant")

func _test_snapshot_round_trip() -> void:
	var source = PROVIDER_SCRIPT.new()
	_expect(source.initialize(), "snapshot source init failed")
	source.apply_choice("thread_marie_private", "choice_j1_marie_optimism_guided")
	var saved: Dictionary = source.snapshot()
	var restored = PROVIDER_SCRIPT.new()
	_expect(restored.initialize(), "snapshot target init failed")
	_expect(restored.restore_snapshot(saved), "snapshot restore failed")
	_expect(restored.snapshot() == saved, "snapshot round trip mismatch")
	var count_before := restored.transcript_for("thread_marie_private").size()
	restored.apply_choice("thread_marie_private", "choice_j1_marie_crisis_guided")
	_expect(restored.transcript_for("thread_marie_private").size() > count_before, "restored provider cannot continue")
	_expect(_id_count(restored.transcript_for("thread_marie_private"), "msg_j1_marie_opening_003") == 1, "restored transcript replayed messages")

func _choose(messages, choice_id: String) -> void:
	var found_index := -1
	var choices: Array = messages.available_choices.get(messages.active_thread_id, [])
	for index in range(choices.size()):
		var choice: Dictionary = choices[index]
		if str(choice.get("choice_id", "")) == choice_id:
			found_index = index
			break
	_expect(found_index >= 0, "choice unavailable: %s" % choice_id)
	if found_index >= 0 and found_index < messages.conversation_screen.choice_bar.buttons.size():
		messages.conversation_screen.choice_bar.buttons[found_index].emit_signal("pressed")
		await _wait_runtime_delivery_complete(messages)

func _choose_twice_and_expect_single(messages, choice_id: String) -> void:
	var before: int = messages.thread_player_message_count(messages.active_thread_id)
	var target_button: Button = null
	var choices: Array = messages.available_choices.get(messages.active_thread_id, [])
	for index in range(choices.size()):
		if str(choices[index].get("choice_id", "")) == choice_id:
			target_button = messages.conversation_screen.choice_bar.buttons[index]
			break
	_expect(target_button != null, "choice unavailable for double click: %s" % choice_id)
	if target_button != null:
		target_button.emit_signal("pressed")
		target_button.emit_signal("pressed")
	_expect(messages.thread_player_message_count(messages.active_thread_id) == before + 1, "double click must create exactly one Player bubble")
	await _wait_runtime_delivery_complete(messages)

func _wait_runtime_delivery_complete(messages) -> void:
	await get_tree().process_frame
	for _index in range(600):
		if not messages.runtime_delivery_active and messages.runtime_delivery_queue.is_empty() and not messages.conversation_screen.typing_visible():
			return
		await get_tree().create_timer(0.01).timeout
	_expect(false, "runtime delivery timed out")

func _open_thread_from_card(messages, thread_id: String) -> void:
	for index in range(messages.conversation_list.threads.size()):
		if str(messages.conversation_list.threads[index].get("thread_id", "")) == thread_id:
			messages.conversation_list.cards[index].emit_signal("pressed")
			await _wait_runtime_delivery_complete(messages)
			return
	_expect(false, "thread card unavailable: %s" % thread_id)

func _visible_text_exists(root: Node, value: String) -> bool:
	for child in root.find_children("*", "Label", true, false):
		if child.visible and child.text == value:
			return true
	return false

func _transition_is_bounded(messages) -> bool:
	var surface: Rect2 = messages.off_phone_transition.get_global_rect()
	var bounds: Rect2 = messages.get_global_rect()
	return messages.off_phone_transition.visible and surface.size.x > 0.0 and surface.size.y > 0.0 and bounds.encloses(surface)

func _walk_provider(provider, thread_id: String, ids: Array) -> void:
	for choice_id in ids:
		var result: Dictionary = provider.apply_choice(thread_id, str(choice_id))
		_expect(bool(result.get("accepted", false)), "provider rejected %s" % choice_id)

func _message(messages, thread_id: String, message_id: String) -> Dictionary:
	for item in messages.transcripts.get(thread_id, []):
		if str(item.get("message_id", "")) == message_id:
			return item
	return {}

func _id_count(items: Array, message_id: String) -> int:
	var count := 0
	for item in items:
		if item is Dictionary and str(item.get("message_id", "")) == message_id:
			count += 1
	return count

func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame

func _wait_time_passage(messages) -> void:
	for _index in range(240):
		if not messages.is_time_passage_active():
			await _frames(3)
			return
		await get_tree().process_frame
	_expect(false, "time passage did not finish")

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
		print("RUNTIME-S1-01 J01 playable smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("RUNTIME-S1-01 J01 playable smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
