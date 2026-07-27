extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const SEASON_PROVIDER := preload("res://scripts/runtime/season_1/Season1RuntimeProvider.gd")
var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var size := _parse_size(_arg("--runtime-size", "720x1280"))
	get_window().size = size
	var main = MAIN_SCENE.instantiate()
	add_child(main)
	await _frames(4)
	var shell = main.shell
	var messages = shell.messages_screen
	messages.runtime_delivery_time_scale = 0.01
	var provider = shell.runtime_provider
	_expect(shell.content_mode == "runtime_s1", "production must use runtime_s1")
	_expect(provider.active_day == "J01", "J02 must not start before J01 completion")
	_expect(messages._thread_for("thread_mathilde_private").is_empty(), "Mathilde must be absent in J01")
	await _play_j01(messages)
	_expect(messages.runtime_pending_transition_by_thread.get("thread_marie_private", {}).is_empty(), "consumed J01 Marie transition must not leak into J02")
	_expect(messages.day_transition.display_title() == "J01 terminé", "J01 end missing")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	_expect(messages.day_transition.display_title() == "Faire de la place", "Terminer J01 must open J02 card")
	_expect(provider.active_day == "J02", "handoff must select J02")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	_expect(messages.screen_mode == "list", "Commencer must open cumulative list")
	_expect(not messages._thread_for("thread_sandra_private").is_empty(), "Sandra must persist")
	await _open(messages, "thread_marie_private")
	await _choose(messages, "choice_wed_marie_emergency_guided")
	_expect(messages.thread_choice_count("thread_marie_private") == 3, "Marie exact three choices unavailable")
	await _choose_twice(messages, "choice_wed_make_room_proactive")
	await _frames(2)
	_expect(messages.day_transition.display_title() == "18:18", "18:18 transition missing")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _wait_runtime_delivery_complete(messages)
	await _frames(2)
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == "thread_marie_private", "18:18 must remain in Marie")
	_expect(messages.presentation_count_by_id("msg_wed_marie_arrival_002") == 0, "removed photo message present")
	_expect(messages.presentation_count_by_content_type("thread_marie_private", "IMAGE") == 0, "J02 Marie image present")
	messages.conversation_screen.back_button.emit_signal("pressed")
	await _frames(2)
	_expect(messages.day_transition.display_title() == "18:22", "18:22 transition missing after read/return")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	_expect(not messages._thread_for("thread_mathilde_private").is_empty(), "Mathilde did not unlock")
	_expect(not messages.notification_banner.visible, "photo notification forbidden")
	await _open(messages, "thread_mathilde_private")
	_expect(messages.thread_choice_count("thread_mathilde_private") == 3, "Mathilde must start with exact three choices")
	await _choose(messages, "choice_wed_mathilde_practical")
	await _frames(2)
	_expect(messages.is_off_phone_transition_active(), "Mathilde offline beat missing")
	_expect(messages.off_phone_transition.display_label.begins_with("18:46"), "practical offline beat mismatch")
	_expect(provider.presentation_count_by_id("offline_wednesday_mathilde_settling_practical") == 1, "practical offline id mismatch")
	messages.off_phone_transition.resume_button.emit_signal("pressed")
	await _frames(2)
	_expect(provider.state.promises.get("mathilde_j02_arrival_help", {}).get("status", "") == "PAID", "P02 practical must be PAID")
	_expect(provider.state.traces.get("j02_mathilde_arrival_room_01", {}).get("trace_type", "") == "FACT_RECORD", "T02 type mismatch")
	_expect(provider.state.knowledge.get("fact_mathilde_stay_started", {}).get("initial_knowers", []) == ["Marie", "Player", "Mathilde"], "F02 knowers mismatch")
	_expect(messages.day_transition.display_title() == "J02 terminé", "J02 end missing")
	_expect(not messages.describe_state().get("has_horizontal_crop", true), "portrait crop")
	_expect(_j02_image_count(messages) == 0, "J02 must contain no IMAGE presentation")
	_expect(provider.active_day == "J02", "J03 must remain inaccessible before J02 Terminer")
	_expect(messages._thread_for("thread_raphaelle_private").is_empty(), "J03 thread visible before J02 Terminer")
	_expect(provider.gallery_source().get("character_order") == ["marie", "sandra", "mathilde"], "J02 gallery tabs changed before handoff")
	_expect(_gallery_asset_count(provider.gallery_source(), "S1_A1_J02_SCN_FIRST_SHARED_EVENING_01") == 2, "shared J02 gallery asset changed before handoff")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	_expect(provider.active_day == "J03", "J02 Terminer must hand off to J03")
	_expect(messages.day_transition.display_title() == "Les vies qui existent ailleurs", "J02 Terminer must show J03 card")
	_expect(messages.day_transition.continue_button.text == "Commencer", "J03 handoff action mismatch")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	_expect(provider.state.current_day == "J03" and provider.state.day_status == "ACTIVE", "J03 must start only after Commencer")
	shell.gallery_button.emit_signal("pressed")
	await _frames(2)
	_expect(shell.gallery_screen.character_order == ["marie", "sandra", "mathilde", "raphaelle"], "cumulative J03 gallery tabs mismatch")
	_expect(shell.gallery_screen.unlocked_item_count("marie") == 2, "Marie gallery distribution mismatch")
	_expect(shell.gallery_screen.unlocked_item_count("mathilde") == 2, "Mathilde gallery distribution mismatch")
	_expect(_gallery_asset_count(provider.gallery_source(), "S1_A1_J02_SCN_FIRST_SHARED_EVENING_01") == 2, "shared gallery asset must remain one id cross-referenced twice")
	main.queue_free()
	await _frames(2)
	await _run_ui_outcome("choice_wed_make_room_playful", "choice_wed_mathilde_distant", "FAILED")
	await _run_ui_outcome("choice_wed_make_room_passive", "choice_wed_mathilde_distant", "REFUSED")
	await _run_ui_outcome("choice_wed_make_room_passive", "choice_wed_mathilde_playful", "PAID")
	_test_snapshots()
	_finish()

func _play_j01(messages) -> void:
	await _open(messages, "thread_marie_private")
	for choice in ["choice_j1_marie_optimism_guided", "choice_j1_marie_crisis_guided", "choice_j1_marie_present", "choice_j1_marie_laverriere_guided", "choice_j1_marie_mathilde_guided"]:
		await _choose(messages, choice)
	await _frames(2)
	messages.off_phone_transition.resume_button.emit_signal("pressed")
	await _frames(2)
	await _open(messages, "thread_sandra_private")
	for choice in ["choice_j1_sandra_what_guided", "choice_j1_sandra_art_guided", "choice_j1_sandra_cautious", "choice_j1_sandra_thanks_guided", "choice_j1_sandra_goodnight_guided"]:
		await _choose(messages, choice)
	await _frames(2)
	messages.off_phone_transition.resume_button.emit_signal("pressed")
	await _frames(2)

func _run_ui_outcome(marie_choice: String, mathilde_choice: String, expected_status: String) -> void:
	var alternate_main = MAIN_SCENE.instantiate()
	add_child(alternate_main)
	await _frames(4)
	var messages = alternate_main.shell.messages_screen
	messages.runtime_delivery_time_scale = 0.01
	var provider = alternate_main.shell.runtime_provider
	await _play_j01(messages)
	_expect(provider.active_day == "J01", "alternate UI left J01 before Terminer")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	_expect(provider.active_day == "J02", "alternate UI did not legitimately complete J01")
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	await _open(messages, "thread_marie_private")
	await _choose(messages, "choice_wed_marie_emergency_guided")
	_expect(_choice_text(messages, marie_choice) == _expected_choice_text(marie_choice), "Marie source choice text mismatch: %s" % marie_choice)
	await _choose(messages, marie_choice)
	await _frames(2)
	_expect(_branch_response_present(messages, marie_choice), "Marie branch response mismatch: %s" % marie_choice)
	messages.day_transition.continue_button.emit_signal("pressed")
	await _wait_runtime_delivery_complete(messages)
	await _frames(2)
	_expect(not messages.runtime_delivery_active and messages.screen_mode == "conversation" and messages.active_thread_id == "thread_marie_private", "18:18 Marie arrival must settle before return")
	messages.conversation_screen.back_button.emit_signal("pressed")
	await _frames(2)
	messages.day_transition.continue_button.emit_signal("pressed")
	await _frames(2)
	await _open(messages, "thread_mathilde_private")
	_expect(_choice_text(messages, mathilde_choice) == _expected_choice_text(mathilde_choice), "Mathilde source choice text mismatch: %s" % mathilde_choice)
	await _choose(messages, mathilde_choice)
	await _frames(2)
	_expect(messages.is_off_phone_transition_active(), "alternate UI offline beat missing")
	var offline_id := "offline_wednesday_mathilde_settling_playful" if mathilde_choice == "choice_wed_mathilde_playful" else "offline_wednesday_mathilde_settling_distant"
	var offline_text := "18:50 — Player rejoint la chambre d'appoint. Le portant, les cartons et la suite de l'installation se règlent face à face." if mathilde_choice == "choice_wed_mathilde_playful" else "19:15 — Player rentre plus tard. Mathilde est déjà installée ; les dernières règles pratiques se règlent face à face avec Marie et elle."
	_expect(messages.off_phone_transition.display_label == offline_text, "exact branch offline beat text mismatch: %s" % mathilde_choice)
	_expect(provider.presentation_count_by_id(offline_id) == 1, "branch offline beat id mismatch: %s" % offline_id)
	if mathilde_choice == "choice_wed_mathilde_playful":
		_expect(_message_text(messages, "thread_mathilde_private", "msg_wed_mathilde_009b") == "Mais tu peux quand même m'aider avec le portant.", "playful response text mismatch")
	else:
		_expect(_message_text(messages, "thread_mathilde_private", "msg_wed_mathilde_009c") == "Je vais essayer de ne pas déclarer le bureau territoire indépendant avant ton retour.", "distant response text mismatch")
	messages.off_phone_transition.resume_button.emit_signal("pressed")
	await _frames(2)
	_expect(provider.state.promises["mathilde_j02_arrival_help"]["status"] == expected_status, "alternate UI P02 mismatch %s" % expected_status)
	alternate_main.queue_free()
	await _frames(2)
func _test_snapshots() -> void:
	var season = _season_after_completed_j01()
	season.confirm_day_transition()
	season.apply_choice("thread_marie_private", "choice_wed_marie_emergency_guided")
	var midday: Dictionary = season.snapshot()
	var restored = SEASON_PROVIDER.new()
	restored.initialize()
	_expect(restored.restore_snapshot(midday), "midday snapshot restore")
	_expect(restored.snapshot() == midday, "midday snapshot round trip")
	restored.apply_choice("thread_marie_private", "choice_wed_make_room_proactive")
	var after_1818: Dictionary = restored.snapshot()
	var restored_1818 = SEASON_PROVIDER.new()
	restored_1818.initialize()
	_expect(restored_1818.restore_snapshot(after_1818), "18:18 snapshot restore")
	_expect(restored_1818.snapshot() == after_1818, "18:18 snapshot round trip")
	restored_1818.confirm_day_transition()
	restored_1818.on_thread_returned("thread_marie_private")
	restored_1818.confirm_day_transition()
	var before_mathilde: Dictionary = restored_1818.snapshot()
	var restored_mathilde = SEASON_PROVIDER.new()
	restored_mathilde.initialize()
	_expect(restored_mathilde.restore_snapshot(before_mathilde), "Mathilde snapshot restore")
	_expect(restored_mathilde.snapshot() == before_mathilde, "pre-Mathilde snapshot round trip")
	_expect(restored_mathilde.presentation_count_by_id("msg_wed_marie_arrival_001") == 1, "snapshot replayed arrival")
	restored_mathilde.apply_choice("thread_mathilde_private", "choice_wed_mathilde_playful")
	_expect(restored_mathilde.presentation_count_by_id("choice_wed_mathilde_playful_player") == 1, "restored Mathilde choice duplicated Player bubble")
	_expect(restored_mathilde.presentation_count_by_id("offline_wednesday_mathilde_settling_playful") == 1, "restored continuation lost playful offline beat")
	restored_mathilde.confirm_transition()
	_expect(restored_mathilde.state.traces.size() == 2 and restored_mathilde.state.traces.has("j02_mathilde_arrival_room_01"), "restored continuation duplicated or lost T02")
	_expect(restored_mathilde.state.knowledge.has("fact_mathilde_stay_started"), "restored continuation lost F02")
	_expect(restored_mathilde.j02_provider.gallery_asset_ids.size() == 3, "restored continuation duplicated gallery assets")
	_expect(restored_mathilde.state.day_status == "COMPLETE" and restored_mathilde.state.current_day == "J02", "restored continuation did not complete J02")
	var completed: Dictionary = restored_mathilde.snapshot()
	var restored_complete = SEASON_PROVIDER.new()
	restored_complete.initialize()
	_expect(restored_complete.restore_snapshot(completed), "completed snapshot restore")
	_expect(restored_complete.snapshot() == completed, "completed snapshot round trip")
	_expect(restored_complete.presentation_count_by_id("msg_wed_marie_arrival_001") == 1, "completed snapshot replayed arrival")
	_expect(restored_complete.presentation_count_by_id("offline_wednesday_mathilde_settling_playful") == 1, "completed snapshot duplicated offline beat")
	_expect(restored_complete.j02_provider.gallery_asset_ids.size() == 3, "completed snapshot duplicated gallery")

func _season_after_completed_j01():
	var season = SEASON_PROVIDER.new()
	_expect(season.initialize(), "season init before legitimate J01 completion")
	for choice_id in [
		"choice_j1_marie_optimism_guided", "choice_j1_marie_crisis_guided", "choice_j1_marie_present",
		"choice_j1_marie_laverriere_guided", "choice_j1_marie_mathilde_guided",
	]:
		_expect(bool(season.apply_choice("thread_marie_private", choice_id).get("accepted", false)), "J01 provider rejected %s" % choice_id)
	_expect(bool(season.confirm_transition().get("accepted", false)), "J01 Marie transition rejected")
	for choice_id in [
		"choice_j1_sandra_what_guided", "choice_j1_sandra_art_guided", "choice_j1_sandra_cautious",
		"choice_j1_sandra_thanks_guided", "choice_j1_sandra_goodnight_guided",
	]:
		_expect(bool(season.apply_choice("thread_sandra_private", choice_id).get("accepted", false)), "J01 provider rejected %s" % choice_id)
	_expect(bool(season.confirm_transition().get("accepted", false)), "J01 Sandra transition rejected")
	_expect(season.active_day == "J01" and season.j01_provider.day_end_visible, "J01 provider did not reach legitimate day end")
	_expect(bool(season.confirm_day_transition().get("accepted", false)), "legitimate J01 Terminer handoff rejected")
	_expect(season.active_day == "J02", "legitimate provider handoff did not select J02")
	return season

func _choice_text(messages, choice_id: String) -> String:
	for choice in messages.available_choices.get(messages.active_thread_id, []):
		if str(choice.get("choice_id", "")) == choice_id:
			return str(choice.get("text", ""))
	return ""

func _expected_choice_text(choice_id: String) -> String:
	match choice_id:
		"choice_wed_make_room_playful": return "Oui, mais elle a droit à une valise, pas à une annexion complète du bureau."
		"choice_wed_make_room_passive": return "Si tu penses que c'est le mieux."
		"choice_wed_mathilde_playful": return "J'ai compté quatre paires de chaussures. L'enquête continue."
		"choice_wed_mathilde_distant": return "Installe-toi. Je rentrerai plus tard."
	return ""

func _branch_response_present(messages, choice_id: String) -> bool:
	if choice_id == "choice_wed_make_room_playful":
		return _message_text(messages, "thread_marie_private", "msg_wed_marie_014b") == "Très juridique. Elle va adorer."
	if choice_id == "choice_wed_make_room_passive":
		return _message_text(messages, "thread_marie_private", "msg_wed_marie_013c") == "Essaie juste de ne pas avoir l'air surpris quand elle arrive avec trois fois trop d'affaires."
	return false

func _message_text(messages, thread_id: String, message_id: String) -> String:
	for item in messages.transcripts.get(thread_id, []):
		if str(item.get("message_id", "")) == message_id:
			return str(item.get("text", ""))
	return ""

func _j02_image_count(messages) -> int:
	var count := 0
	for thread_id in messages.transcripts:
		for item in messages.transcripts[thread_id]:
			if int(item.get("source_day", 0)) == 2 and str(item.get("content_type", "")) == "IMAGE": count += 1
	return count

func _gallery_asset_count(source: Dictionary, asset_id: String) -> int:
	var count := 0
	for character_id in source.get("fixtures", {}):
		for item in source["fixtures"][character_id].get("items", []):
			if str(item.get("asset_id", "")) == asset_id: count += 1
	return count

func _choose(messages, id: String) -> void:
	for index in range(messages.available_choices.get(messages.active_thread_id, []).size()):
		if messages.available_choices[messages.active_thread_id][index].get("choice_id", "") == id:
			if index >= messages.conversation_screen.choice_bar.buttons.size():
				_expect(false, "choice model/render mismatch: %s" % id)
				return
			messages.conversation_screen.choice_bar.buttons[index].emit_signal("pressed")
			await _wait_runtime_delivery_complete(messages)
			return
	_expect(false, "choice unavailable: %s" % id)

func _choose_twice(messages, id: String) -> void:
	var before: int = int(messages.thread_player_message_count(messages.active_thread_id))
	for index in range(messages.available_choices.get(messages.active_thread_id, []).size()):
		if messages.available_choices[messages.active_thread_id][index].get("choice_id", "") == id:
			var button = messages.conversation_screen.choice_bar.buttons[index]
			button.emit_signal("pressed")
			button.emit_signal("pressed")
			break
	_expect(messages.thread_player_message_count(messages.active_thread_id) == before + 1, "double activation duplicated Player bubble")
	await _wait_runtime_delivery_complete(messages)

func _wait_runtime_delivery_complete(messages) -> void:
	await get_tree().process_frame
	for _index in range(600):
		if not messages.runtime_delivery_active and messages.runtime_delivery_queue.is_empty() and not messages.conversation_screen.typing_visible():
			return
		await get_tree().create_timer(0.01).timeout
	print("DELIVERY TIMEOUT state=", messages.runtime_delivery_active, " thread=", messages.runtime_delivery_thread_id, " active=", messages.active_thread_id, " queue=", messages.runtime_delivery_queue.size(), " typing=", messages.conversation_screen.typing_visible(), " visual=", messages.thread_message_count(messages.active_thread_id), " provider=", messages.runtime_provider.presentation_source().get("messages_by_thread", {}).get(messages.active_thread_id, []).size())
	_expect(false, "runtime delivery timed out")

func _open(messages, id: String) -> void:
	for index in range(messages.conversation_list.threads.size()):
		if messages.conversation_list.threads[index].get("thread_id", "") == id:
			messages.conversation_list.cards[index].emit_signal("pressed")
			await _wait_runtime_delivery_complete(messages)
			return
	_expect(false, "thread unavailable: %s" % id)

func _frames(count: int) -> void:
	for _index in range(count): await get_tree().process_frame
func _arg(prefix: String, fallback: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="): return arg.trim_prefix(prefix + "=")
	return fallback
func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x")
	return Vector2i(int(parts[0]), int(parts[1]))
func _expect(value: bool, message: String) -> void:
	if not value: failures.append(message)
func _finish() -> void:
	if failures.is_empty():
		print("RUNTIME-S1-02 J02 playable smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures: push_error(failure)
	print("RUNTIME-S1-02 J02 playable smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)
