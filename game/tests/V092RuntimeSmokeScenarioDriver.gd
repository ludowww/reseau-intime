extends "res://tests/V090RuntimeSmokeScenarioDriver.gd"

const FirstRepetitionClosure = preload("res://scripts/narrative/FirstRepetitionClosure.gd")
const CLOSE_PHASE_ID := "monday_first_repetition_wave_close"
const WAVE_COMPLETE_FLAG := "first_repetition_wave_complete"
const MATHILDE_SCENE_ID := "mathilde_morning_kitchen_afterglow_01"

func _run() -> void:
	_ensure_monday_loaded()
	var scenario := _requested_scenario()
	match scenario:
		"A": await _scenario_a_no_foreground()
		"B": await _scenario_b_one_foreground()
		"C": await _scenario_c_two_foregrounds()
		"D": await _scenario_d_mathilde_owner_preserved()
		"E": await _scenario_e_honest_distance_closes()
		"F": await _scenario_f_mixed_evidence_preserved()
		"G": _scenario_g_unresolved_obligation_blocks()
		"H": _scenario_h_non_terminal_candidate_blocks()
		"I": await _scenario_i_idempotent_close()
		_:
			failures.append("Unknown or missing V0.92 smoke scenario: %s" % scenario)

	await get_tree().process_frame
	await get_tree().process_frame
	if failures.is_empty():
		print("V0.92 runtime smoke %s: OK" % scenario)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("V0.92 runtime smoke %s: FAILED (%d)" % [scenario, failures.size()])
	get_tree().quit(1)

func _scenario_a_no_foreground() -> void:
	var context := await _new_phone_context()
	_prepare_terminal_state("active", "DEFERRED", "EXPIRED", [], [], "", {})
	await _activate_close(context["phone"])
	_expect(_has_flag(WAVE_COMPLETE_FLAG), "A: wave did not close")
	_expect(_ledger().get("external_foreground_character_ids", []).is_empty(), "A: foreground was manufactured")
	_expect(str(_ledger().get("charged_access_owner", "")) == "", "A: charged owner was manufactured")
	await _dispose_context(context)

func _scenario_b_one_foreground() -> void:
	var context := await _new_phone_context()
	_prepare_terminal_state(
		"bounded",
		"RESOLVED",
		"EXPIRED",
		[MATHILDE_SCENE_ID],
		["mathilde"],
		"",
		{"marie_return_after_external": _terminal_obligation("PAID", "bounded_return")}
	)
	await _activate_close(context["phone"])
	_expect(_has_flag(WAVE_COMPLETE_FLAG), "B: wave did not close")
	_expect(_ledger().get("external_foreground_character_ids", []) == ["mathilde"], "B: one foreground was not preserved")
	await _dispose_context(context)

func _scenario_c_two_foregrounds() -> void:
	var context := await _new_phone_context()
	_prepare_terminal_state(
		"active",
		"RESOLVED",
		"RESOLVED",
		[MATHILDE_SCENE_ID, SANDRA_SCENE_ID],
		["mathilde", "sandra"],
		"",
		{"marie_return_after_sandra": _terminal_obligation("PAID", "active_return")}
	)
	await _activate_close(context["phone"])
	_expect(_has_flag(WAVE_COMPLETE_FLAG), "C: wave did not close")
	_expect(_ledger().get("external_foreground_character_ids", []) == ["mathilde", "sandra"], "C: foreground history order changed")
	await _dispose_context(context)

func _scenario_d_mathilde_owner_preserved() -> void:
	var context := await _new_phone_context()
	_prepare_terminal_state(
		"bounded",
		"RESOLVED",
		"DEFERRED",
		[MATHILDE_SCENE_ID],
		["mathilde"],
		"mathilde",
		{}
	)
	await _activate_close(context["phone"])
	_expect(_has_flag(WAVE_COMPLETE_FLAG), "D: wave did not close")
	_expect(str(_ledger().get("charged_access_owner", "")) == "mathilde", "D: Mathilde owner was cleared or transferred")
	_expect(not _any_flag_starts_with("sandra_r2"), "D: Sandra was promoted")
	await _dispose_context(context)

func _scenario_e_honest_distance_closes() -> void:
	var context := await _new_phone_context()
	_prepare_terminal_state(
		"honest",
		"DEFERRED",
		"RESOLVED",
		[SANDRA_SCENE_ID],
		["sandra"],
		"",
		{"marie_return_after_sandra": _terminal_obligation("FAILED", "honest_distance")}
	)
	await _activate_close(context["phone"])
	_expect(_has_flag(WAVE_COMPLETE_FLAG), "E: honest distance did not close the wave")
	_expect(_has_flag("marie_monday_evening_separate"), "E: honest-distance resolution was lost")
	await _dispose_context(context)

func _scenario_f_mixed_evidence_preserved() -> void:
	var context := await _new_phone_context()
	_prepare_terminal_state("active", "EXPIRED", "DEFERRED", [], [], "", {})
	EffectApplier.apply_flags(["active_reconnection_evidence", "parallel_drift_evidence_soft"])
	await _activate_close(context["phone"])
	_expect(_has_flag(WAVE_COMPLETE_FLAG), "F: wave did not close")
	_expect(_has_flag("active_reconnection_evidence"), "F: active evidence was removed")
	_expect(_has_flag("parallel_drift_evidence_soft"), "F: drift evidence was removed")
	await _dispose_context(context)

func _scenario_g_unresolved_obligation_blocks() -> void:
	GameState.reset_state()
	_prepare_terminal_state(
		"active",
		"DEFERRED",
		"EXPIRED",
		[],
		[],
		"",
		{"future_act": _terminal_obligation("DUE", "")}
	)
	var result := FirstRepetitionClosure.evaluate(GameState.current_state.get("flags", []), _ledger())
	_expect(not bool(result.get("closable", true)), "G: unresolved obligation was accepted")
	_expect(str(result.get("blocking_reasons", [])).contains("future_act"), "G: blocking reason does not identify obligation")
	_expect(not _has_flag(WAVE_COMPLETE_FLAG), "G: wave flag was written by pure evaluation")

func _scenario_h_non_terminal_candidate_blocks() -> void:
	GameState.reset_state()
	_prepare_terminal_state("active", "DEFERRED", "OFFERED", [], [], "", {})
	var result := FirstRepetitionClosure.evaluate(GameState.current_state.get("flags", []), _ledger())
	_expect(not bool(result.get("closable", true)), "H: OFFERED candidate was accepted")
	_expect(str(result.get("blocking_reasons", [])).contains(SANDRA_SCENE_ID), "H: blocking reason does not identify candidate")
	_expect(str(_ledger().get("scene_status", {}).get(SANDRA_SCENE_ID, "")) == "OFFERED", "H: pure helper mutated lifecycle")

func _scenario_i_idempotent_close() -> void:
	var context := await _new_phone_context()
	_prepare_terminal_state(
		"active",
		"RESOLVED",
		"EXPIRED",
		[MATHILDE_SCENE_ID],
		["mathilde"],
		"mathilde",
		{}
	)
	var phone = context["phone"]
	var phase := DataLoader.get_timeline_phase(DAY, CLOSE_PHASE_ID)
	var ledger_before := _ledger()
	var logs_before := TimelineState.get_day_log_entries(DAY)
	await phone._activate_phase(DAY, phase, false)
	var first_flag_count: int = GameState.current_state.get("flags", []).count(WAVE_COMPLETE_FLAG)
	await phone._activate_first_repetition_wave_close(DAY, phase)
	_expect(GameState.current_state.get("flags", []).count(WAVE_COMPLETE_FLAG) == first_flag_count, "I: duplicate wave flag")
	_expect(_ledger() == ledger_before, "I: ledger changed during idempotent close")
	_expect(TimelineState.get_day_log_entries(DAY) == logs_before, "I: closure created a day-log entry")
	await _dispose_context(context)

func _prepare_terminal_state(
	marie_outcome: String,
	mathilde_status: String,
	sandra_status: String,
	foreground_scenes: Array,
	foreground_characters: Array,
	charged_owner: String,
	obligations: Dictionary
) -> void:
	var flags: Array = ["first_repetition_slice_01_complete", "first_repetition_slice_02_complete"]
	match marie_outcome:
		"active": flags.append_array(["marie_monday_return_active", "marie_monday_return_realized"])
		"bounded": flags.append_array(["marie_monday_return_bounded", "marie_monday_bounded_time_paid"])
		"honest": flags.append_array(["marie_monday_return_honest_distance", "marie_monday_evening_separate"])
	EffectApplier.apply_flags(flags)
	var statuses := {
		MATHILDE_SCENE_ID: mathilde_status,
		SANDRA_SCENE_ID: sandra_status,
	}
	GameState.set_story_ledger_value(LEDGER_ID, "scene_status", statuses)
	GameState.set_story_ledger_value(LEDGER_ID, "external_foreground_scene_ids", foreground_scenes)
	GameState.set_story_ledger_value(LEDGER_ID, "external_foreground_character_ids", foreground_characters)
	GameState.set_story_ledger_value(LEDGER_ID, "charged_access_owner", charged_owner)
	GameState.set_story_ledger_value(LEDGER_ID, "obligations", obligations)

func _terminal_obligation(status: String, result: String) -> Dictionary:
	return {
		"status": status,
		"owner": "player",
		"expected_by": MARIE_PHASE_ID,
		"created_by": "v092_smoke",
		"resolved_by": MARIE_CONVERSATION_ID if status in ["PAID", "FAILED"] else "",
		"result": result,
	}

func _activate_close(phone) -> void:
	var phase := DataLoader.get_timeline_phase(DAY, CLOSE_PHASE_ID)
	_expect(not phase.is_empty(), "Missing V0.92 closure phase")
	if phase.is_empty():
		return
	await phone._activate_phase(DAY, phase, false)
	await _wait_until(func(): return _has_flag(WAVE_COMPLETE_FLAG), DEFAULT_TIMEOUT_SECONDS)
