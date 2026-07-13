extends Node

const MAIN_SCENE := preload("res://scenes/Main.tscn")
const DAY := 7
const LEDGER_ID := "first_repetition"
const MORNING_PHASE_ID := "monday_morning_commitment"
const SANDRA_PHASE_ID := "monday_sandra_end_shift_candidate"
const MARIE_PHASE_ID := "monday_marie_return"
const SANDRA_SCENE_ID := "sandra_end_of_shift_twenty_minutes_01"
const SANDRA_CONVERSATION_ID := "chapter_07_sandra_end_of_shift"
const MARIE_CONVERSATION_ID := "chapter_07_marie_monday_return"
const DEBUG_SPEED := 20.0
const DEFAULT_TIMEOUT_SECONDS := 5.0

var failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await _scenario_a_carried_morning_promise()
	await _scenario_b_ordinary_morning()
	await _scenario_c_sandra_lunch()
	await _scenario_d_sandra_soft_boundary()
	await _scenario_e_sandra_expiry()
	await _scenario_f_sandra_defer()
	await _scenario_g_marie_active_return()
	await _scenario_h_marie_bounded_return()
	await _scenario_i_honest_distance_preserves_mathilde_owner()

	if failures.is_empty():
		print("V0.90 runtime smoke: OK (A-I)")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("V0.90 runtime smoke: FAILED (%d)" % failures.size())
	get_tree().quit(1)


func _scenario_a_carried_morning_promise() -> void:
	var context := await _new_phone_context()
	var phone = context["phone"]
	EffectApplier.apply_flags([
		"first_repetition_slice_01_complete",
		"j1_sandra_trace_complete",
		"marie_next_morning_obligation_scheduled",
	])
	GameState.set_obligation_status(LEDGER_ID, "marie_monday_morning", {
		"status": "CARRIED",
		"owner": "player",
		"expected_by": "monday_morning",
		"created_by": "chapter_06_marie_concrete_return",
		"resolved_by": "",
		"result": "monday_morning",
	})
	await phone._activate_phase(DAY, DataLoader.get_timeline_phase(DAY, MORNING_PHASE_ID), false)
	var obligation := GameState.get_obligation_status(LEDGER_ID, "marie_monday_morning")
	_expect(str(obligation.get("status", "")) == "PAID", "A: carried obligation was not paid")
	_expect(str(obligation.get("resolved_by", "")) == MORNING_PHASE_ID, "A: resolved_by mismatch")
	_expect(str(obligation.get("result", "")) == "promised_coffee_paid", "A: result mismatch")
	_expect(_has_flag("marie_monday_morning_paid"), "A: marie_monday_morning_paid missing")
	_expect(TimelineState.current_phase_id(DAY) == SANDRA_PHASE_ID, "A: Sandra was not evaluated after morning payment")
	await _dispose_context(context)


func _scenario_b_ordinary_morning() -> void:
	var context := await _new_phone_context()
	var phone = context["phone"]
	EffectApplier.apply_flags([
		"first_repetition_slice_01_complete",
		"j1_sandra_trace_complete",
	])
	await phone._activate_phase(DAY, DataLoader.get_timeline_phase(DAY, MORNING_PHASE_ID), false)
	_expect(_has_flag("monday_day_started"), "B: monday_day_started missing")
	_expect(TimelineState.current_phase_id(DAY) == SANDRA_PHASE_ID, "B: Sandra was not evaluated after ordinary morning")
	await _dispose_context(context)


func _scenario_c_sandra_lunch() -> void:
	var context := await _new_phone_context()
	var phone = context["phone"]
	_prepare_sandra_eligibility()
	await _activate_and_play_sandra(phone, 1)
	var ledger := _ledger()
	_expect(_scene_status(ledger) == "RESOLVED", "C: Sandra scene did not resolve")
	_expect(ledger.get("external_foreground_character_ids", []).has("sandra"), "C: Sandra foreground missing")
	for flag_id in [
		"sandra_lunch_rescheduled",
		"sandra_next_lunch_scheduled",
		"sandra_lunch_plan_recorded",
		"sandra_r1_repeat_complete",
	]:
		_expect(_has_flag(flag_id), "C: missing flag %s" % flag_id)
	var obligation := GameState.get_obligation_status(LEDGER_ID, "marie_return_after_sandra")
	_expect(str(obligation.get("status", "")) in ["SCHEDULED", "DUE"], "C: Marie return obligation missing")
	await _dispose_context(context)


func _scenario_d_sandra_soft_boundary() -> void:
	var context := await _new_phone_context()
	var phone = context["phone"]
	_prepare_sandra_eligibility()
	await _activate_and_play_sandra(phone, 2)
	_expect(_scene_status(_ledger()) == "RESOLVED", "D: Sandra scene did not resolve")
	for flag_id in [
		"sandra_boundary_respected_soft",
		"sandra_soft_boundary_kept",
		"sandra_r1_repeat_complete",
	]:
		_expect(_has_flag(flag_id), "D: missing flag %s" % flag_id)
	await _dispose_context(context)


func _scenario_e_sandra_expiry() -> void:
	var context := await _new_phone_context()
	var phone = context["phone"]
	_prepare_sandra_eligibility()
	await phone._activate_phase(DAY, DataLoader.get_timeline_phase(DAY, SANDRA_PHASE_ID), false)
	var expired := await _wait_until(func(): return _scene_status(_ledger()) == "EXPIRED", 3.0)
	_expect(expired, "E: Sandra optional window did not expire")
	var ledger := _ledger()
	_expect(TimelineState.is_conversation_expired(DAY, SANDRA_CONVERSATION_ID), "E: conversation not marked expired")
	_expect(not ledger.get("external_foreground_character_ids", []).has("sandra"), "E: expiry consumed Sandra foreground")
	var silent := await _wait_until(func(): return _has_flag("sandra_second_window_silent"), 3.0)
	_expect(silent, "E: silent resolution flag missing")
	await _dispose_context(context)


func _scenario_f_sandra_defer() -> void:
	var context := await _new_phone_context()
	var phone = context["phone"]
	EffectApplier.apply_flags(["first_repetition_slice_01_complete"])
	await phone._activate_phase(DAY, DataLoader.get_timeline_phase(DAY, SANDRA_PHASE_ID), false)
	var ledger := _ledger()
	_expect(_scene_status(ledger) == "DEFERRED", "F: ineligible Sandra was not deferred")
	_expect(not ledger.get("external_foreground_character_ids", []).has("sandra"), "F: defer consumed Sandra foreground")
	_expect(_has_flag("sandra_second_window_silent"), "F: silent defer resolution missing")
	_expect(TimelineState.current_phase_id(DAY) == MARIE_PHASE_ID, "F: Marie phase not reached after defer")
	await _dispose_context(context)


func _scenario_g_marie_active_return() -> void:
	await _run_marie_outcome_scenario(
		"G",
		0,
		"PAID",
		"active_return",
		"marie_monday_return_realized",
		false
	)


func _scenario_h_marie_bounded_return() -> void:
	await _run_marie_outcome_scenario(
		"H",
		1,
		"PAID",
		"bounded_return",
		"marie_monday_bounded_time_paid",
		false
	)


func _scenario_i_honest_distance_preserves_mathilde_owner() -> void:
	await _run_marie_outcome_scenario(
		"I",
		2,
		"FAILED",
		"honest_distance",
		"marie_monday_evening_separate",
		true
	)


func _run_marie_outcome_scenario(
	label: String,
	marie_choice_index: int,
	expected_status: String,
	expected_result: String,
	expected_flag: String,
	preserve_mathilde_owner: bool
) -> void:
	var context := await _new_phone_context()
	var phone = context["phone"]
	_prepare_sandra_eligibility()
	if preserve_mathilde_owner:
		GameState.set_story_ledger_value(LEDGER_ID, "charged_access_owner", "mathilde")
	await _activate_and_play_sandra(phone, 0)
	var due := await _wait_until(
		func(): return str(GameState.get_obligation_status(LEDGER_ID, "marie_return_after_sandra").get("status", "")) == "DUE",
		DEFAULT_TIMEOUT_SECONDS
	)
	_expect(due, "%s: Marie obligation never became DUE" % label)
	_expect(TimelineState.current_phase_id(DAY) == MARIE_PHASE_ID, "%s: Marie phase not active" % label)
	await _open_and_play(phone, MARIE_CONVERSATION_ID, [marie_choice_index])
	var resolved := await _wait_until(
		func(): return str(GameState.get_obligation_status(LEDGER_ID, "marie_return_after_sandra").get("status", "")) == expected_status,
		DEFAULT_TIMEOUT_SECONDS
	)
	_expect(resolved, "%s: Marie obligation did not resolve" % label)
	var obligation := GameState.get_obligation_status(LEDGER_ID, "marie_return_after_sandra")
	_expect(str(obligation.get("resolved_by", "")) == MARIE_CONVERSATION_ID, "%s: resolved_by mismatch" % label)
	_expect(str(obligation.get("result", "")) == expected_result, "%s: result mismatch" % label)
	_expect(_has_flag(expected_flag), "%s: missing flag %s" % [label, expected_flag])
	var closed := await _wait_until(func(): return _has_flag("first_repetition_slice_02_complete"), DEFAULT_TIMEOUT_SECONDS)
	_expect(closed, "%s: slice close flag missing" % label)
	_expect(not _has_flag("first_repetition_wave_complete"), "%s: wave completed too early" % label)
	if preserve_mathilde_owner:
		_expect(str(_ledger().get("charged_access_owner", "")) == "mathilde", "I: charged access owner changed")
		_expect(not _any_flag_starts_with("sandra_r2"), "I: Sandra R2 flag appeared")
	await _dispose_context(context)


func _new_phone_context() -> Dictionary:
	var main := MAIN_SCENE.instantiate()
	get_tree().root.add_child(main)
	await get_tree().process_frame
	await get_tree().process_frame
	var phone = main.get_node("PhonePrototype")
	phone.conversation_view.set_debug_speed_multiplier(DEBUG_SPEED)
	GameState.reset_state()
	TimelineState.reset_timeline()
	TimelineState.unlock_day(DAY)
	TimelineState.set_current_day(DAY)
	phone.current_day_value = DAY
	phone.viewing_archived_day = false
	phone.transition_in_progress = false
	phone.time_passage_in_progress = false
	phone.conversation_view.reset_ui_state()
	return {"main": main, "phone": phone}


func _dispose_context(context: Dictionary) -> void:
	var phone = context.get("phone")
	if is_instance_valid(phone):
		phone.optional_window_token += 1
		phone.time_passage_token += 1
		phone.time_passage_in_progress = false
		phone.transition_in_progress = false
		phone.conversation_view.reset_ui_state()
	var main: Node = context.get("main")
	if is_instance_valid(main):
		main.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame


func _prepare_sandra_eligibility() -> void:
	EffectApplier.apply_flags([
		"first_repetition_slice_01_complete",
		"j1_sandra_trace_complete",
	])


func _activate_and_play_sandra(phone, main_choice_index: int) -> void:
	await phone._activate_phase(DAY, DataLoader.get_timeline_phase(DAY, SANDRA_PHASE_ID), false)
	await _open_and_play(phone, SANDRA_CONVERSATION_ID, [0, main_choice_index])
	var resolved := await _wait_until(func(): return _scene_status(_ledger()) == "RESOLVED", DEFAULT_TIMEOUT_SECONDS)
	_expect(resolved, "Sandra conversation did not reach RESOLVED")


func _open_and_play(phone, episode_id: String, choice_indexes: Array) -> void:
	var conversation := _conversation_for_episode(episode_id)
	_expect(not conversation.is_empty(), "Missing conversation for %s" % episode_id)
	if conversation.is_empty():
		return
	phone._open_conversation(DAY, conversation)
	var view = phone.conversation_view
	for raw_index in choice_indexes:
		var choice_index := int(raw_index)
		var choices_ready := await _wait_until(
			func(): return bool(view.active_state.get("waiting_choices", false)) and view.choice_buttons.size() > choice_index,
			DEFAULT_TIMEOUT_SECONDS
		)
		_expect(choices_ready, "Choices not ready for %s index %d" % [episode_id, choice_index])
		if not choices_ready:
			return
		var button: Button = view.choice_buttons[choice_index]
		button.emit_signal("pressed")
		await get_tree().process_frame
	var completed := await _wait_until(func(): return TimelineState.is_episode_completed(DAY, episode_id), DEFAULT_TIMEOUT_SECONDS)
	_expect(completed, "Conversation did not complete: %s" % episode_id)


func _conversation_for_episode(episode_id: String) -> Dictionary:
	for raw_conversation in DataLoader.get_conversations_for_day(DAY):
		if typeof(raw_conversation) != TYPE_DICTIONARY:
			continue
		var conversation: Dictionary = raw_conversation
		if conversation.get("_episode_ids", []).has(episode_id):
			return conversation
	return {}


func _wait_until(predicate: Callable, timeout_seconds: float) -> bool:
	var deadline := Time.get_ticks_msec() + int(timeout_seconds * 1000.0)
	while Time.get_ticks_msec() < deadline:
		if bool(predicate.call()):
			return true
		await get_tree().process_frame
	return bool(predicate.call())


func _ledger() -> Dictionary:
	return GameState.get_story_ledger(LEDGER_ID)


func _scene_status(ledger: Dictionary) -> String:
	return str(ledger.get("scene_status", {}).get(SANDRA_SCENE_ID, ""))


func _has_flag(flag_id: String) -> bool:
	return GameState.current_state.get("flags", []).has(flag_id)


func _any_flag_starts_with(prefix: String) -> bool:
	for raw_flag in GameState.current_state.get("flags", []):
		if str(raw_flag).begins_with(prefix):
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	failures.append(message)
