extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const J12_PROVIDER := preload("res://scripts/runtime/season_1/J12RuntimeProvider.gd")
const J21_PROVIDER := preload("res://scripts/runtime/season_1/J21RuntimeProvider.gd")
const J12_SMOKE := preload("res://tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd")
const J13_SMOKE := preload("res://tests/RUNTIME_S1_13J13PlayableSmokeDriver.gd")
const J15_SMOKE := preload("res://tests/RUNTIME_S1_15J15PlayableSmokeDriver.gd")

const GALLERY_ASSET_IDS := [
	"S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01",
	"S1_A3_J09_DPH_MARIE_LAVERRIERE_PUBLIC_01",
]

var failures: Array[String] = []
var main
var shell
var messages
var season


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	get_window().size = Vector2i(720, 1280)
	main = MAIN_SCENE.instantiate()
	add_child(main)
	await _frames(6)
	shell = main.shell
	messages = shell.messages_screen
	season = shell.runtime_provider
	shell.set_safe_area_preset("none")
	shell.set_reduced_motion_enabled(true)
	messages.runtime_delivery_time_scale = 0.01
	messages.reading_speed_multiplier = 8.0
	_expect(messages.visible and messages.screen_mode == "list", "PortraitMain starts on Messages list")
	await _exercise_j12()
	await _exercise_j15()
	await _exercise_j21()
	_expect(not bool(shell.describe_layout().get("has_vertical_crop", true)), "PortraitShell has no vertical crop")
	_expect(not bool(messages.describe_state().get("has_horizontal_crop", true)), "Messages has no horizontal crop")
	_finish()


func _exercise_j12() -> void:
	var helper = J12_SMOKE.new()
	helper.marie_j11_base_snapshot = helper._build_real_j11_base_snapshot("MARIE")
	helper.mathilde_j11_base_snapshot = helper._build_real_j11_base_snapshot("MATHILDE")
	var state = helper._completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	state.promises["sandra_cafe_saturday_1100"] = helper._canonical_p11(true)
	var provider = J12_PROVIDER.new()
	_expect(provider.initialize(state, {}, {}, [], GALLERY_ASSET_IDS), "J12 UX provider initializes")
	_expect(bool(provider.start_day().get("accepted", false)), "J12 UX day starts")
	_expect(_thread_unread_count(provider, "thread_sandra_private") > 0, "J12 publishes an incoming notification state")
	helper._present_batch(provider, "thread_sandra_private")
	await _exercise_day_surface("J12", provider, "thread_sandra_private", "choice_j12_p11_confirm", "p11_choice")
	for failure in helper.failures:
		failures.append("J12 helper: " + failure)
	helper.free()


func _exercise_j15() -> void:
	var helper = J15_SMOKE.new()
	helper.j13_helper = J13_SMOKE.new()
	helper.j13_helper.j12_helper = J12_SMOKE.new()
	helper.j13_helper.j12_helper.marie_j11_base_snapshot = helper.j13_helper.j12_helper._build_real_j11_base_snapshot("MARIE")
	helper.j13_helper.j12_helper.mathilde_j11_base_snapshot = helper.j13_helper.j12_helper._build_real_j11_base_snapshot("MATHILDE")
	var state = helper._completed_j14_state("choice_j14_pauline_truth")
	var provider = helper._new_provider(state)
	provider.gallery_asset_ids.assign(GALLERY_ASSET_IDS)
	_expect(bool(provider.start_day().get("accepted", false)), "J15 UX day starts")
	helper._confirm(provider)
	_expect(_thread_unread_count(provider, "thread_marie_private") > 0, "J15 publishes an incoming notification state")
	helper._present(provider, "thread_marie_private")
	await _exercise_day_surface("J15", provider, "thread_marie_private", "choice_j15_clean_acknowledge_marie", "priority_choice")
	for failure in helper.failures:
		failures.append("J15 helper: " + failure)
	for failure in helper.j13_helper.failures:
		failures.append("J13 helper: " + failure)
	for failure in helper.j13_helper.j12_helper.failures:
		failures.append("J12 helper: " + failure)
	helper.j13_helper.j12_helper.free()
	helper.j13_helper.free()
	helper.free()


func _exercise_j21() -> void:
	var state = _j21_fixture()
	var provider = J21_PROVIDER.new()
	_expect(provider.initialize(state, {}, {}, [], GALLERY_ASSET_IDS), "J21 UX provider initializes")
	_expect(bool(provider.start_day().get("accepted", false)), "J21 UX day starts")
	provider.commit_narrative_time(462)
	_expect(bool(provider.confirm_transition().get("accepted", false)), "J21 morning transition confirms")
	_expect(_thread_unread_count(provider, "thread_marie_private") > 0, "J21 publishes an incoming notification state")
	_present_day_messages(provider, "thread_marie_private", 21)
	await _exercise_day_surface("J21", provider, "thread_marie_private", "choice_j21_morning_1930", "morning_choice")


func _exercise_day_surface(day: String, provider, thread_id: String, choice_id: String, expected_choice_phase: String) -> void:
	_mount_provider(day, provider)
	await _frames(4)
	_expect(shell.active_tab == "messages" and messages.visible, day + " arrives on Messages")
	_expect(messages.screen_mode == "list", day + " starts from conversation list")
	_expect(not messages._thread_for(thread_id).is_empty(), day + " exposes its authored conversation in the list")
	_expect(messages.notification_banner != null, day + " keeps the list notification surface mounted")
	messages.open_thread(thread_id)
	await _frames(3)
	_expect(messages.screen_mode == "conversation" and messages.active_thread_id == thread_id, day + " opens its authored thread")
	_expect(messages.conversation_screen.header_notification != null, day + " keeps the header notification surface mounted")
	_expect(messages.thread_message_count(thread_id) > 0, day + " renders authored messages")
	_expect(provider.phase == expected_choice_phase, day + " reaches the authored choice phase")
	_expect(messages.thread_choice_count(thread_id) > 0, day + " renders Player choices")
	var transition_count_before := int(messages.describe_state().get("time_passage_surface_count", 0))
	await _choose(choice_id)
	_expect(transition_count_before == 1 and int(messages.describe_state().get("time_passage_surface_count", 0)) == 1, day + " reuses the unified time transition surface")
	_expect(not messages.is_time_passage_active(), day + " completes its applicable time transition")
	messages.conversation_screen.back_button.emit_signal("pressed")
	await _frames(3)
	_expect(messages.screen_mode == "list", day + " returns to the conversation list")
	await _exercise_gallery(day)


func _exercise_gallery(day: String) -> void:
	shell.gallery_screen.refresh_content_source(season.gallery_source())
	shell.activate_gallery(false)
	await _frames(3)
	var gallery = shell.gallery_screen
	gallery.select_character("marie")
	_expect(shell.active_tab == "gallery" and gallery.visible, day + " opens Gallery")
	_expect(gallery.unlocked_item_count("marie") >= 2, day + " retains cumulative gallery contents")
	gallery.activate_first_tile()
	await _frames(3)
	_expect(shell.is_photo_viewer_active(), day + " opens PhotoViewer")
	_expect(not shell.photo_viewer.has_loaded_texture(), day + " displays the missing-media placeholder")
	_expect(shell.photo_viewer.visual_label.text == "Visuel non livré", day + " uses the canonical placeholder copy")
	_expect(shell.photo_viewer.previous_visible() and shell.photo_viewer.next_visible(), day + " exposes sequence navigation")
	_expect(not shell.photo_viewer.previous_enabled() and shell.photo_viewer.next_enabled(), day + " starts at the first sequence item")
	var first_photo_id: String = shell.photo_viewer.current_photo_id()
	shell.photo_viewer.next_button.emit_signal("pressed")
	await _frames(2)
	_expect(shell.photo_viewer.current_photo_id() != first_photo_id and shell.photo_viewer.previous_enabled(), day + " navigates to the next gallery item")
	shell.photo_viewer.back_button.emit_signal("pressed")
	await _frames(3)
	_expect(not shell.is_photo_viewer_active() and shell.active_tab == "gallery", day + " returns from PhotoViewer to Gallery")
	shell.activate_messages(false)
	await _frames(2)
	_expect(messages.visible and messages.screen_mode == "list", day + " returns from Gallery to Messages list")


func _mount_provider(day: String, provider) -> void:
	season.state = provider.state
	season.active_day = day
	season.active_provider = provider
	season.set(day.to_lower() + "_provider", provider)
	messages.day_transition.reset_surface()
	messages.day_transition_state = {}
	messages._set_gallery_navigation_blocked(false)
	messages.runtime_delivery_cancelled = true
	messages.runtime_delivery_active = false
	messages.runtime_delivery_request_id += 1
	messages.transition_flow_active = false
	messages.transition_flow_request_id += 1
	messages.time_passage_overlay.cancel_flow()
	messages.active_thread_id = ""
	messages.screen_mode = "list"
	messages.runtime_provider_transcript_by_thread.clear()
	messages.runtime_presented_message_ids_by_thread.clear()
	messages.runtime_pending_messages_by_thread.clear()
	messages.runtime_pending_choices_by_thread.clear()
	messages.runtime_pending_transition_by_thread.clear()
	var source: Dictionary = season.presentation_source()
	messages._initialize_runtime_source(source)
	for raw_thread_id in source.get("messages_by_thread", {}):
		var thread_id: String = str(raw_thread_id)
		var historical: Array[Dictionary] = messages._dictionary_array(source["messages_by_thread"][raw_thread_id])
		messages.transcripts[thread_id] = historical
		var ids: Array = []
		for message in historical:
			ids.append(str(message.get("message_id", "")))
		messages.runtime_presented_message_ids_by_thread[thread_id] = ids
	messages._reconcile_runtime_source(source)
	messages._build()
	messages.runtime_delivery_cancelled = false
	shell.gallery_screen.refresh_content_source(season.gallery_source())
	shell.activate_messages(false)


func _thread_unread_count(provider, thread_id: String) -> int:
	for thread in provider.presentation_source().get("threads", []):
		if str(thread.get("thread_id", "")) == thread_id:
			return int(thread.get("unread_count", 0))
	return 0


func _present_day_messages(provider, thread_id: String, source_day: int) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == source_day and not bool(message.get("is_player", false)):
			provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "incoming batch presents for " + thread_id)


func _choose(choice_id: String) -> void:
	var button: Button = null
	var choices: Array = messages.available_choices.get(messages.active_thread_id, [])
	for index in range(choices.size()):
		if str(choices[index].get("choice_id", "")) == choice_id:
			button = messages.conversation_screen.choice_bar.buttons[index]
			break
	_expect(button != null, "choice unavailable: " + choice_id)
	if button != null:
		button.emit_signal("pressed")
		await _wait_runtime_delivery_complete()
		await _wait_time_passage_complete()


func _wait_runtime_delivery_complete() -> void:
	for _index in range(800):
		if not messages.runtime_delivery_active and messages.runtime_delivery_queue.is_empty() and not messages.conversation_screen.typing_visible():
			await _frames(2)
			return
		await get_tree().create_timer(0.01).timeout
	_expect(false, "runtime delivery timed out")


func _wait_time_passage_complete() -> void:
	for _index in range(800):
		if not messages.is_time_passage_active() and not messages.transition_flow_active:
			await _frames(3)
			return
		await get_tree().process_frame
	_expect(false, "time passage timed out")


func _j21_fixture():
	var state = preload("res://scripts/runtime/season_1/Season1State.gd").new()
	state.current_day = "J20"
	state.day_status = "COMPLETE"
	state.couple_state = "RECONQUEST_ACTIVE"
	state.traces["j18_sandra_lunch_print_01"] = {"trace_id":"j18_sandra_lunch_print_01","current_state":"ACTIVE","owner":"Sandra","current_audience":["Sandra"]}
	state.final_trace_id = "j18_sandra_lunch_print_01"
	state.final_trace_state = "ACTIVE"
	state.final_trace_controller = "Sandra"
	state.final_trace_audience = ["Sandra"]
	state.j18_sandra_outcome = "FRIENDSHIP_RESTORED"
	state.knowledge["fact_final_trace_selected"] = {"source_ref":"j18_sandra_lunch_print_01"}
	return state


func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)


func _finish() -> void:
	if failures.is_empty():
		print("R8C_A4_FINAL_PORTRAIT_UX J12/J15/J21: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("R8C_A4_FINAL_PORTRAIT_UX: FAILED (%d)" % failures.size())
	get_tree().quit(1)
