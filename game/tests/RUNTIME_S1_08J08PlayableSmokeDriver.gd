extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const SEASON_PROVIDER := preload("res://scripts/runtime/season_1/Season1RuntimeProvider.gd")
const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J07_PROVIDER := preload("res://scripts/runtime/season_1/J07RuntimeProvider.gd")
const J08_PROVIDER := preload("res://scripts/runtime/season_1/J08RuntimeProvider.gd")
const J07_SMOKE := preload("res://tests/RUNTIME_S1_07J07PlayableSmokeDriver.gd")

const PREPARATIONS := [
	"choice_j08_raphaelle_anticipate_now",
	"choice_j08_raphaelle_schedule_1820",
	"choice_j08_raphaelle_vague",
]
const PRIORITIES := [
	"choice_j08_priority_oldest",
	"choice_j08_priority_immediate",
	"choice_j08_priority_vague",
]
const THREADS := [
	"thread_marie_private",
	"thread_sandra_private",
	"thread_mathilde_private",
	"thread_raphaelle_private",
	"thread_pauline_private",
	"thread_nico_private",
]

var failures: Array[String] = []
var capture_dir := ""

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var requested_size := _parse_size(_arg("--runtime-size", "720x1280"))
	capture_dir = _arg("--capture-dir", OS.get_environment("CAPTURE_DIR"))
	get_window().size = requested_size
	_exercise_all_admissible_paths()
	_exercise_backward_compatibility()
	await _exercise_real_portrait_surfaces(requested_size)
	_finish(requested_size)

func _exercise_all_admissible_paths() -> void:
	for household_state in ["STATE_A", "STATE_B", "STATE_C"]:
		for p06_active in [false, true]:
			for preparation in PREPARATIONS:
				var priorities: Array = PRIORITIES if household_state == "STATE_A" or p06_active else [""]
				for priority in priorities:
					var state = _completed_j07_state(household_state, p06_active)
					var traces_before: Dictionary = state.traces.duplicate(true)
					var knowledge_before: Dictionary = state.knowledge.duplicate(true)
					var relationships_before := _relationship_snapshot(state)
					var provider = _new_j08_provider(state)
					_advance_to_collision(provider, preparation)
					var label := "%s/P06=%s/%s/%s" % [household_state, p06_active, preparation, priority if priority != "" else "fallback"]
					if household_state == "STATE_B":
						_expect(state.marie_j08_household_resolution == "PAID", label + " pays P08 before collision")
					if household_state == "STATE_C":
						_expect(state.marie_j08_household_resolution == "REFUSAL_ABSORBED", label + " keeps the J07 refusal")
					if priority == "":
						_expect(provider.phase == "fallback_resolution_incoming", label + " has no global priority")
						_expect(provider.choices_for("thread_raphaelle_private").is_empty(), label + " exposes no fallback choices")
						_present_batch(provider, "thread_raphaelle_private")
					else:
						_expect(provider.phase == "priority_choice", label + " reaches the global choice")
						var concerned := ["thread_raphaelle_private", "thread_marie_private"] if household_state == "STATE_A" else ["thread_raphaelle_private", "thread_nico_private"]
						for thread_id in concerned:
							_expect(provider.choices_for(thread_id).size() == 3, label + " exposes priority in " + thread_id)
						_expect(bool(provider.apply_choice(concerned[0], priority).get("accepted", false)), label + " applies global choice once")
						for thread_id in concerned:
							_expect(provider.choices_for(thread_id).is_empty(), label + " clears priority in " + thread_id)
						_expect(not bool(provider.apply_choice(concerned[-1], priority).get("accepted", false)), label + " rejects duplicate priority")
					_assert_no_priority_labels_in_transcripts(provider, label)
					_expect_provider_round_trip(provider, label + " intermediate snapshot")
					_finish_day(provider)
					_assert_path_outcomes(provider, household_state, p06_active, preparation, priority, label)
					_expect(state.traces == traces_before, label + " creates no trace")
					_expect(state.knowledge == knowledge_before, label + " creates no knowledge")
					_expect(_relationship_snapshot(state) == relationships_before, label + " preserves every relationship state")
					_expect_provider_round_trip(provider, label + " complete snapshot")

func _exercise_backward_compatibility() -> void:
	var helper = J07_SMOKE.new()
	var season = helper._season_at_completed_j06()
	season.automatic_day_handoff()
	season.confirm_transition()
	season.apply_choice("thread_raphaelle_private", "choice_j07_raphaelle_acknowledge_guided")
	season.apply_choice("thread_raphaelle_private", "choice_j07_raphaelle_understood_guided")
	season.confirm_transition()
	season.apply_choice("thread_nico_private", "choice_j07_nico_topic_guided")
	season.apply_choice("thread_nico_private", "choice_j07_nico_what_mean_guided")
	season.apply_choice("thread_nico_private", "choice_j07_nico_acknowledge_contradiction")
	season.apply_choice("thread_nico_private", "choice_j07_nico_at_least_said_guided")
	season.apply_choice("thread_nico_private", "choice_j07_nico_tuesday_accepted")
	season.confirm_transition()
	var old_snapshot: Dictionary = season.snapshot()
	old_snapshot["version"] = 6
	old_snapshot["provider_snapshots"].erase("J08")
	old_snapshot["state"]["version"] = 5
	for key in [
		"marie_j08_entry_outcome", "raphaelle_j08_preparation_outcome", "j08_priority_outcome",
		"raphaelle_j08_work_resolution", "nico_j08_meeting_resolution",
		"marie_j08_household_resolution", "mathilde_j08_household_resolution",
		"marie_j08_echo_outcome", "resolved_visual_variant_by_asset",
	]:
		old_snapshot["state"].erase(key)
	var restored = SEASON_PROVIDER.new()
	_expect(restored.initialize(), "legacy J07 season provider initializes")
	_expect(restored.restore_snapshot(old_snapshot), "season v6 active J07 with state v5 restores")
	_expect(restored.state_restore_count == 1, "legacy restore restores shared state once")
	_expect(restored.active_day == "J07", "legacy restore remains on J07")
	restored.apply_choice("thread_marie_private", "choice_j07_marie_presence_confirmed")
	restored.confirm_transition()
	_expect(restored.j07_provider.phase == "complete", "legacy-restored J07 can complete")
	var completed_old_snapshot: Dictionary = restored.snapshot()
	completed_old_snapshot["version"] = 6
	completed_old_snapshot["provider_snapshots"].erase("J08")
	completed_old_snapshot["state"]["version"] = 5
	for key in [
		"marie_j08_entry_outcome", "raphaelle_j08_preparation_outcome", "j08_priority_outcome",
		"raphaelle_j08_work_resolution", "nico_j08_meeting_resolution",
		"marie_j08_household_resolution", "mathilde_j08_household_resolution",
		"marie_j08_echo_outcome", "resolved_visual_variant_by_asset",
	]:
		completed_old_snapshot["state"].erase(key)
	var completed_restored = SEASON_PROVIDER.new()
	_expect(completed_restored.initialize(), "completed legacy J07 provider initializes")
	_expect(completed_restored.restore_snapshot(completed_old_snapshot), "completed season v6 J07 restores")
	_expect(completed_restored.content_end().is_empty(), "completed J07 is not CONTENT_END")
	_expect(str(completed_restored.next_day_presentation().get("title", "")) == "Ce qui ne tient pas ensemble", "completed J07 exposes J08")
	_expect(bool(completed_restored.automatic_day_handoff().get("accepted", false)), "completed legacy J07 hands off")
	_expect(completed_restored.active_day == "J08" and completed_restored.j08_provider.phase == "marie_entry_incoming", "handoff starts canonical J08")
	helper.free()

func _advance_to_collision(provider, preparation: String) -> void:
	_expect(bool(provider.start_day().get("accepted", false)), "J08 starts")
	_present_batch(provider, "thread_marie_private")
	var entry_choice: String = {
		"STATE_A": "choice_j08_marie_entry_a_guided",
		"STATE_B": "choice_j08_marie_entry_b_guided",
		"STATE_C": "choice_j08_marie_entry_c_guided",
	}[provider.state.marie_j08_entry_outcome]
	provider.apply_choice("thread_marie_private", entry_choice)
	provider.confirm_transition()
	_present_batch(provider, "thread_raphaelle_private")
	provider.apply_choice("thread_raphaelle_private", preparation)
	if preparation == "choice_j08_raphaelle_anticipate_now":
		provider.confirm_transition()
		_present_batch(provider, "thread_raphaelle_private")
	provider.confirm_transition()
	if provider.phase == "nico_reminder_incoming":
		_present_batch(provider, "thread_nico_private")
		provider.apply_choice("thread_nico_private", "choice_j08_nico_reminder_guided")
	if provider.phase == "to_nico":
		provider.confirm_transition()
	if provider.phase == "nico_reminder_incoming":
		_present_batch(provider, "thread_nico_private")
		provider.apply_choice("thread_nico_private", "choice_j08_nico_reminder_guided")
	if provider.phase in ["to_state_b_household", "to_collision"]:
		provider.confirm_transition()
	if provider.phase == "state_b_household_incoming":
		_present_batch(provider, "thread_marie_private")
		provider.apply_choice("thread_marie_private", "choice_j08_marie_state_b_go_guided")
		provider.confirm_transition()
		provider.confirm_transition()
	if provider.phase in ["to_collision", "to_collision_after_household"]:
		provider.confirm_transition()
	_expect(provider.phase == "collision_incoming", "collision incoming reached")
	_present_batch(provider, "thread_raphaelle_private")
	if provider.state.marie_j08_entry_outcome == "STATE_A":
		_present_batch(provider, "thread_marie_private")

func _finish_day(provider) -> void:
	for _step in range(30):
		if provider.phase == "complete":
			return
		if not provider.pending_transition.is_empty():
			provider.confirm_transition()
			continue
		match provider.phase:
			"household_return_incoming":
				_present_batch(provider, "thread_marie_private")
			"household_return_choice":
				provider.apply_choice("thread_marie_private", "choice_j08_marie_return_paid_guided")
			"raphaelle_return_incoming":
				_present_batch(provider, "thread_raphaelle_private")
			"raphaelle_return_choice":
				provider.apply_choice("thread_raphaelle_private", "choice_j08_raphaelle_return_transfer_guided")
			"nico_return_incoming":
				_present_batch(provider, "thread_nico_private")
			"nico_return_choice":
				provider.apply_choice("thread_nico_private", "choice_j08_nico_return_paid_guided")
			"marie_close_incoming":
				_present_batch(provider, "thread_marie_private")
			"marie_close_choice":
				var close_choice := "choice_j08_marie_bridge_cold_guided" if provider.state.marie_j08_echo_outcome == "VAGUE_OR_MISSED" else "choice_j08_marie_bridge_warm_guided"
				provider.apply_choice("thread_marie_private", close_choice)
			_:
				_expect(false, "unexpected finish phase " + provider.phase)
				return
	_expect(false, "J08 did not complete")

func _assert_path_outcomes(provider, household_state: String, p06_active: bool, preparation: String, priority: String, label: String) -> void:
	var state = provider.state
	_expect(provider.phase == "complete" and state.day_status == "COMPLETE", label + " completes")
	var p05: Dictionary = state.promises["raphaelle_j07_mobile_review"]
	var p08: Dictionary = state.promises["marie_j07_household_request"]
	var p06: Dictionary = state.promises.get("nico_j07_tuesday_1845", {})
	if priority == "" or priority == "choice_j08_priority_oldest":
		_expect(str(p05.get("status", "")) == "PAID", label + " pays P05")
	elif priority == "choice_j08_priority_immediate":
		_expect(str(p05.get("status", "")) == "AMENDED" and str(p05.get("due_at", "")) == "J09 09:00", label + " amends P05")
	else:
		_expect(str(p05.get("status", "")) == "FAILED", label + " fails P05")
	if household_state == "STATE_A":
		var expected_p08 := "FAILED" if priority == "choice_j08_priority_vague" or priority == "choice_j08_priority_oldest" and preparation == "choice_j08_raphaelle_vague" else "PAID"
		_expect(str(p08.get("status", "")) == expected_p08, label + " resolves P08")
	elif household_state == "STATE_B":
		_expect(str(p08.get("status", "")) == "PAID", label + " keeps P08 paid")
	else:
		_expect(str(p08.get("status", "")) == "REFUSED", label + " keeps P08 refused")
	if p06_active:
		var expected_p06 := "CANCELLED"
		if household_state != "STATE_A" and priority == "choice_j08_priority_immediate":
			expected_p06 = "PAID"
		elif priority == "choice_j08_priority_vague":
			expected_p06 = "FAILED"
		_expect(str(p06.get("status", "")) == expected_p06, label + " resolves P06")
	else:
		_expect(str(p06.get("status", "")) == "REFUSED", label + " leaves inactive P06 refused")
		_expect(_source_day_messages(provider, "thread_nico_private", 8).is_empty(), label + " emits no Nico J08 message")
	var expected_variants := {
		"S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01": "S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_PAID" if str(p05.get("status", "")) == "PAID" else "S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_TAKEN_OVER",
		"S1_A2_J08_SCN_NICO_CHAIR_STATE_01": "S1_A2_J08_SCN_NICO_CHAIR_STATE_01_PAID" if state.nico_j08_meeting_resolution == "PAID_SHORT" else "S1_A2_J08_SCN_NICO_CHAIR_STATE_01_NO_WAIT",
		"S1_A2_J08_SCN_HOUSEHOLD_STATE_01": "S1_A2_J08_SCN_HOUSEHOLD_STATE_01_PAID" if str(p08.get("status", "")) == "PAID" else "S1_A2_J08_SCN_HOUSEHOLD_STATE_01_AUTONOMOUS",
	}
	_expect(state.resolved_visual_variant_by_asset == expected_variants, label + " stores exact visual variants")
	_expect(provider.served_visual_beat_ids == expected_variants.keys(), label + " serves exactly three visual parents")
	_expect(str(provider.runtime_map["day_end"]["transition_mode"]) == "day_handoff", label + " ends at the J09 handoff")

func _completed_j07_state(household_state: String, p06_active: bool):
	var state = SEASON_STATE.new()
	state.current_day = "J06"
	state.day_status = "COMPLETE"
	state.raphaelle_state = "PROFESSIONAL_ONLY"
	state.raphaelle_work_outcome = "ACCOUNTABLE"
	state.mathilde_state = "FAMILY_GUEST"
	state.pauline_state = "PUBLIC_ONLY"
	state.nico_state = "ORDINARY_FRIEND"
	state.mathilde_j06_outcome = "UNAVAILABLE"
	state.j06_external_continuity_resolution = "UNAVAILABLE"
	state.marie_j06_return_outcome = "HONEST_DRIFT"
	var j07 = J07_PROVIDER.new()
	_expect(j07.initialize(state, {}, {}, THREADS, []), "J07 fixture initializes")
	j07.start_day()
	j07.confirm_transition()
	j07.apply_choice("thread_raphaelle_private", "choice_j07_raphaelle_acknowledge_guided")
	j07.apply_choice("thread_raphaelle_private", "choice_j07_raphaelle_understood_guided")
	j07.confirm_transition()
	j07.apply_choice("thread_nico_private", "choice_j07_nico_topic_guided")
	j07.apply_choice("thread_nico_private", "choice_j07_nico_what_mean_guided")
	j07.apply_choice("thread_nico_private", "choice_j07_nico_acknowledge_contradiction")
	j07.apply_choice("thread_nico_private", "choice_j07_nico_at_least_said_guided")
	j07.apply_choice("thread_nico_private", "choice_j07_nico_tuesday_accepted" if p06_active else "choice_j07_nico_continuation_closed")
	j07.confirm_transition()
	var marie_choice: String = {
		"STATE_A": "choice_j07_marie_presence_confirmed",
		"STATE_B": "choice_j07_marie_precise_alternative",
		"STATE_C": "choice_j07_marie_honest_refusal",
	}[household_state]
	j07.apply_choice("thread_marie_private", marie_choice)
	j07.confirm_transition()
	_expect(j07.phase == "complete", "J07 fixture completes")
	return state

func _new_j08_provider(state):
	var provider = J08_PROVIDER.new()
	_expect(provider.initialize(state, {}, {}, THREADS, []), "J08 provider initializes")
	return provider

func _present_batch(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 8 and not bool(message.get("is_player", false)):
			provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "batch presented for " + thread_id + " in " + provider.phase)

func _expect_provider_round_trip(provider, label: String) -> void:
	var provider_snapshot: Dictionary = provider.snapshot()
	var state_snapshot: Dictionary = provider.state.snapshot()
	var restored_state = SEASON_STATE.new()
	var restored = J08_PROVIDER.new()
	_expect(restored_state.restore_snapshot(state_snapshot), label + " state restore")
	_expect(restored.initialize(restored_state, {}, {}, [], []), label + " provider init")
	_expect(restored.restore_snapshot(provider_snapshot), label + " provider restore")
	_expect(restored.snapshot() == provider_snapshot, label + " exact round trip")

func _assert_no_priority_labels_in_transcripts(provider, label: String) -> void:
	var labels := [
		"Payer l’engagement le plus ancien",
		"Payer la présence physique la plus immédiate",
		"Ne pas choisir clairement",
	]
	for thread_id in provider.transcripts_by_thread:
		for message in provider.transcripts_by_thread[thread_id]:
			_expect(str(message.get("text", "")) not in labels, label + " keeps priority label out of transcript")

func _relationship_snapshot(state) -> Dictionary:
	return {
		"couple": state.couple_state,
		"sandra": state.sandra_state,
		"raphaelle": state.raphaelle_state,
		"mathilde": state.mathilde_state,
		"pauline": state.pauline_state,
		"nico": state.nico_state,
	}

func _source_day_messages(provider, thread_id: String, day: int) -> Array:
	var result: Array = []
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == day:
			result.append(message)
	return result

func _ui_has_global_priority(messages, thread_id: String) -> bool:
	for choice in messages._dictionary_array(messages.available_choices.get(thread_id, [])):
		if str(choice.get("choice_id", "")).begins_with("choice_j08_priority_"):
			return true
	return false

func _ui_thread_matches_provider_with_pending(messages, provider, thread_id: String) -> bool:
	var combined: Array[Dictionary] = messages._dictionary_array(messages.transcripts.get(thread_id, []))
	combined.append_array(messages._dictionary_array(messages.runtime_pending_messages_by_thread.get(thread_id, [])))
	return (
		messages._normalized_runtime_transcript(combined)
		== messages._normalized_runtime_transcript(provider.transcript_for(thread_id))
	)

func _exercise_real_portrait_surfaces(size: Vector2i) -> void:
	var main = MAIN_SCENE.instantiate()
	add_child(main)
	await _frames(6)
	var shell = main.shell
	var messages = shell.messages_screen
	shell.set_safe_area_preset("none")
	shell.set_reduced_motion_enabled(true)
	messages.runtime_delivery_time_scale = 0.01
	messages.reading_speed_multiplier = 8.0

	var j07_state = _completed_j07_state("STATE_A", true)
	var j07 = J07_PROVIDER.new()
	j07.initialize(j07_state, {}, {}, THREADS, [])
	var season = shell.runtime_provider
	season.state = j07_state
	season.j07_provider = j07
	season.active_day = "J07"
	season.active_provider = j07
	messages._start_runtime_day_card(j07.runtime_map["day_end"]["next_day_presentation"])
	await _frames(3)
	await _capture("j07_to_j08_handoff", size)

	var provider = _new_j08_provider(_completed_j07_state("STATE_A", true))
	_advance_to_preparation(provider)
	_mount_direct_j08(messages, season, provider)
	messages.open_thread("thread_raphaelle_private")
	await _frames(3)
	await _capture("raphaelle_preparation", size)

	provider.apply_choice("thread_raphaelle_private", "choice_j08_raphaelle_vague")
	provider.confirm_transition()
	_present_batch(provider, "thread_nico_private")
	provider.apply_choice("thread_nico_private", "choice_j08_nico_reminder_guided")
	provider.confirm_transition()
	_mount_direct_j08(messages, season, provider)
	await _capture("triple_overlap", size)
	_present_batch(provider, "thread_raphaelle_private")
	_present_batch(provider, "thread_marie_private")
	_mount_direct_j08(messages, season, provider)
	messages.open_thread("thread_raphaelle_private")
	await _frames(3)
	await _capture("global_priority", size)
	_expect(messages.apply_runtime_choice("choice_j08_priority_vague"), "real MessagesScreen accepts global vague choice")
	await _wait_until(
		func(): return not messages.runtime_delivery_active and not messages.transition_flow_active,
		900,
		"global priority UI delivery timed out",
	)
	_expect(not messages.runtime_delivery_active, "global priority UI delivery completes")
	_expect(
		provider.phase in ["household_return_incoming", "household_return_choice", "to_raphaelle_return"],
		"global priority reaches household return (phase " + provider.phase + ")",
	)
	_expect(
		provider.presentation_count_by_id("msg_j08_marie_return_failed_001") == 1,
		"household return batch is reached through the UI transition",
	)
	_expect(
		messages._normalized_runtime_transcript(messages._dictionary_array(messages.transcripts.get("thread_raphaelle_private", [])))
		== messages._normalized_runtime_transcript(provider.transcript_for("thread_raphaelle_private")),
		"active visual transcript strictly matches provider after global choice",
	)
	for thread_id in ["thread_raphaelle_private", "thread_marie_private", "thread_nico_private"]:
		_expect(
			provider.choices_for(thread_id).is_empty()
			or provider.phase == "household_return_choice" and thread_id == "thread_marie_private",
			"global choices disappear from provider " + thread_id,
		)
		_expect(not _ui_has_global_priority(messages, thread_id), "global choices disappear from UI " + thread_id)
	for thread_id in ["thread_marie_private", "thread_nico_private"]:
		_expect(_ui_thread_matches_provider_with_pending(messages, provider, thread_id), "other-thread messages remain available after resync: " + thread_id)
	_assert_no_priority_labels_in_transcripts(provider, "real MessagesScreen global vague choice")
	await _capture("household_return", size)
	_finish_day(provider)
	_mount_direct_j08(messages, season, provider)
	shell.gallery_screen.refresh_content_source(season.gallery_source())
	shell.activate_gallery(false)
	await _frames(3)
	await _capture("gallery_j08", size)
	shell.activate_messages(false)
	messages._start_runtime_day_card(provider.runtime_map["day_end"])
	await _frames(3)
	await _capture("day_end_j08_handoff", size)
	_expect(not bool(shell.describe_layout().get("has_vertical_crop", true)), "PortraitShell has no vertical crop")
	_expect(not bool(messages.describe_state().get("has_horizontal_crop", true)), "Messages has no horizontal crop")
	main.queue_free()
	await _frames(6)

func _advance_to_preparation(provider) -> void:
	provider.start_day()
	_present_batch(provider, "thread_marie_private")
	provider.apply_choice("thread_marie_private", "choice_j08_marie_entry_a_guided")
	provider.confirm_transition()
	_present_batch(provider, "thread_raphaelle_private")

func _mount_direct_j08(messages, season, provider) -> void:
	season.state = provider.state
	season.j08_provider = provider
	season.active_day = "J08"
	season.active_provider = provider
	messages.day_transition.reset_surface()
	messages.day_transition_state = {}
	messages._set_gallery_navigation_blocked(false)
	_reset_messages_to_authority(messages, season)

func _reset_messages_to_authority(messages, provider) -> void:
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
	var source: Dictionary = provider.presentation_source()
	messages._initialize_runtime_source(source)
	for raw_thread_id in source.get("messages_by_thread", {}):
		var thread_id := str(raw_thread_id)
		var historical: Array[Dictionary] = messages._dictionary_array(source["messages_by_thread"][raw_thread_id])
		messages.transcripts[thread_id] = historical
		var ids: Array = []
		for message in historical:
			ids.append(str(message.get("message_id", "")))
		messages.runtime_presented_message_ids_by_thread[thread_id] = ids
	messages._reconcile_runtime_source(source)
	messages._build()
	messages.runtime_delivery_cancelled = false

func _capture(label: String, size: Vector2i) -> void:
	if capture_dir == "" or DisplayServer.get_name() == "headless":
		return
	DirAccess.make_dir_recursive_absolute(capture_dir)
	await get_tree().process_frame
	var path := capture_dir.path_join("%dx%d_%s.png" % [size.x, size.y, label])
	var image := get_viewport().get_texture().get_image()
	if image.get_size() != size:
		image.convert(Image.FORMAT_RGBA8)
		var canvas := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
		canvas.fill(Color("#02040C"))
		canvas.blit_rect(image, Rect2i(Vector2i.ZERO, image.get_size()), Vector2i((size.x - image.get_width()) / 2, (size.y - image.get_height()) / 2))
		image = canvas
	var error := image.save_png(path)
	_expect(error == OK, "capture failed: " + path)

func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame

func _wait_until(predicate: Callable, frames: int, failure: String) -> void:
	for _index in range(frames):
		if predicate.call():
			return
		await get_tree().process_frame
	_expect(false, failure)

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

func _finish(size: Vector2i) -> void:
	if failures.is_empty():
		print("RUNTIME-S1-08 J08 real PortraitMain smoke %dx%d: OK" % [size.x, size.y])
		get_tree().call_deferred("quit", 0)
		return
	for failure in failures:
		push_error(failure)
	print("RUNTIME-S1-08 J08 real PortraitMain smoke: FAILED (%d)" % failures.size())
	get_tree().call_deferred("quit", 1)
