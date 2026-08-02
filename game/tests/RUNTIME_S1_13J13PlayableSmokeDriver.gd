extends Node

const STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const PROVIDER := preload("res://scripts/runtime/season_1/J13RuntimeProvider.gd")
const TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const J12_SMOKE := preload("res://tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd")

const PUBLIC_TRACE := "j12_laverriere_public_group_set_01"
const PAULINE_TRACE := "j13_pauline_private_version_01"
const RAPHAELLE_TRACE := "j13_raphaelle_masked_version_01"
const NICO_TRACE := "j13_nico_alibi_or_hour_message_01"

var failures: Array[String] = []
var j12_helper


func _ready() -> void:
	j12_helper = J12_SMOKE.new()
	j12_helper.marie_j11_base_snapshot = j12_helper._build_real_j11_base_snapshot("MARIE")
	j12_helper.mathilde_j11_base_snapshot = j12_helper._build_real_j11_base_snapshot("MATHILDE")
	_exercise_network_routes()
	_exercise_sandra_matrix()
	_exercise_mathilde_matrix()
	_exercise_raphaelle_matrix()
	_exercise_nico_matrix()
	_exercise_marie_matrix()
	_exercise_invalid_obligations_fail_closed()
	for failure in j12_helper.failures:
		failures.append("J12 helper: " + failure)
	j12_helper.free()
	if failures.is_empty():
		print("RUNTIME_S1_13_J13_PLAYABLE: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)


func _exercise_network_routes() -> void:
	var pauline = _completed_network_state(true)
	_exercise_case("Pauline eligible", pauline, "PAULINE", "msg_j13_pauline_001", "choice_j13_pauline_rule", "PAID", "NETWORK_J11_CONSEQUENCE", PAULINE_TRACE)
	var refused = _completed_network_state(true)
	_exercise_case("Pauline clean refusal", refused, "PAULINE", "msg_j13_pauline_001", "choice_j13_pauline_refuse", "CLOSED", "NETWORK_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(str(refused.traces[PAULINE_TRACE].get("current_state", "")) == "REMOVED" and refused.knowledge.has("fact_pauline_sent_private_j12_version"), "Pauline refusal removes access but preserves sourced history")
	var respiration = _completed_network_state(false)
	_exercise_case("NETWORK respiration", respiration, "RESPIRATION", "msg_j13_respiration_001", "choice_j13_respiration_bread", "PAID", "NETWORK_J11_CONSEQUENCE", PUBLIC_TRACE)
	var impossible: Dictionary = pauline.snapshot(); impossible["traces"].erase(PAULINE_TRACE); impossible["knowledge"].erase("fact_pauline_sent_private_j12_version")
	_expect(not STATE.new().restore_snapshot(impossible), "a completed Pauline snapshot without its delivered trace fails closed")


func _exercise_sandra_matrix() -> void:
	var cases := [
		{"outcome":"SANDRA_RULE_CLARIFIED", "j12_choice":"choice_j12_sandra_clear", "message":"msg_j13_sandra_clear_001", "choice":"choice_j13_sandra_clear_confirm", "status":"PAID"},
		{"outcome":"SANDRA_DESIRE_BOUNDED", "j12_choice":"choice_j12_sandra_delay", "message":"msg_j13_sandra_delayed_001", "choice":"choice_j13_sandra_delayed_withdraw", "status":"PAID"},
		{"outcome":"SANDRA_DESIRE_BOUNDED", "j12_choice":"choice_j12_sandra_exit", "message":"msg_j13_sandra_exit_001", "choice":"choice_j13_sandra_exit_ack", "status":"CLOSED"},
	]
	for test_case in cases:
		var state = _completed_r5b_j12(str(test_case.outcome), "SANDRA", str(test_case.j12_choice), "C12")
		_exercise_case("Sandra " + str(test_case.j12_choice), state, "SANDRA", str(test_case.message), str(test_case.choice), str(test_case.status), "SANDRA_J11_CONSEQUENCE", "j11_sandra_chosen_image_01")
	var overreach = _completed_r5b_j12("SANDRA_RULE_CLARIFIED", "SANDRA", "choice_j12_sandra_clear", "C12")
	_exercise_case("Sandra extra request", overreach, "SANDRA", "msg_j13_sandra_clear_001", "choice_j13_sandra_clear_more", "FAILED", "SANDRA_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(str(overreach.traces["j11_sandra_chosen_image_01"].get("current_state", "")) == "REMOVED" and str(overreach.knowledge["fact_sandra_chose_private_image_for_player"].get("access_mode", "")) == "removed", "Sandra extra request removes file access but preserves historical knowledge")
	var removed = _completed_r5b_j12("SANDRA_IMAGE_REMOVED", "NETWORK", "", "C12")
	_exercise_case("Sandra removed stays silent", removed, "RESPIRATION", "msg_j13_respiration_001", "choice_j13_respiration_walk", "PAID", "NETWORK_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(not removed.traces.has("j11_sandra_chosen_image_01") or str(removed.traces["j11_sandra_chosen_image_01"].get("current_state", "")) == "REMOVED", "Sandra removed never reopens the private image")


func _exercise_mathilde_matrix() -> void:
	var cases := [
		{"outcome":"MATHILDE_M_B1", "private":"choice_j12_mathilde_m_b1_ack", "message":"msg_j13_mathilde_m_b1_001", "choice":"choice_j13_mathilde_m_b1_rule", "trace":PUBLIC_TRACE},
		{"outcome":"MATHILDE_M_B2", "private":"choice_j12_mathilde_m_b2_ack", "message":"msg_j13_mathilde_m_b2_001", "choice":"choice_j13_mathilde_m_b2_debt", "trace":"j11_mathilde_physical_aftercare_01"},
		{"outcome":"MATHILDE_M_B3", "private":"choice_j12_mathilde_m_b3_exit", "message":"msg_j13_mathilde_m_b3_001", "choice":"choice_j13_mathilde_m_b3_rule", "trace":"j11_mathilde_physical_aftercare_01"},
		{"outcome":"MATHILDE_DISTANCE_RESTORED", "private":"", "message":"msg_j13_mathilde_distance_001", "choice":"choice_j13_mathilde_distance_ack", "status":"CLOSED", "trace":PUBLIC_TRACE},
	]
	for test_case in cases:
		var state = _completed_semantic_j12(str(test_case.outcome), str(test_case.private), false)
		_exercise_case("Mathilde " + str(test_case.outcome), state, "MATHILDE", str(test_case.message), str(test_case.choice), str(test_case.get("status", "PAID")), "MATHILDE_J11_CONSEQUENCE", str(test_case.trace))
	var failed = _completed_semantic_j12("MATHILDE_M_B2", "choice_j12_mathilde_m_b2_ack", true)
	_exercise_case("Mathilde failed aftercare", failed, "MATHILDE", "msg_j13_mathilde_failed_001", "choice_j13_mathilde_failed_accept", "PAID", "MATHILDE_HOUSEHOLD_AFTERCARE", "j11_mathilde_physical_aftercare_01")


func _exercise_raphaelle_matrix() -> void:
	var standard = _completed_r5b_j12("FIRST_KISS", "RAPHAELLE", "choice_j12_raphaelle_public", "C12")
	_exercise_case("Raphaelle standard", standard, "RAPHAELLE", "msg_j13_raphaelle_001", "choice_j13_raphaelle_process", "PAID", "RAPHAELLE_J11_CONSEQUENCE", RAPHAELLE_TRACE)
	var boundary = _completed_r5b_j12("KISS_DECLINED", "RAPHAELLE", "choice_j12_raphaelle_declined_hold", "C12")
	_exercise_case("Raphaelle boundary", boundary, "RAPHAELLE", "msg_j13_raphaelle_boundary_001", "choice_j13_raphaelle_boundary_work", "CLOSED", "RAPHAELLE_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(not boundary.traces.has(RAPHAELLE_TRACE), "a declined kiss creates no masked private image")
	var pressed = _completed_r5b_j12("RESULT_SENT_ATTRACTION_NAMED", "RAPHAELLE", "choice_j12_raphaelle_now", "C12")
	_exercise_case("Raphaelle pressed", pressed, "RAPHAELLE", "msg_j13_raphaelle_pressed_001", "choice_j13_raphaelle_insist_pressure", "FAILED", "RAPHAELLE_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(not pressed.traces.has(RAPHAELLE_TRACE), "RAPHAELLE_NOW creates no masked private image")


func _exercise_nico_matrix() -> void:
	var guardrail = _completed_r5b_j12("NICO_GUARDRAIL_HELD", "NICO", "choice_j12_nico_accept", "B12")
	_exercise_case("Nico guardrail", guardrail, "NICO", "msg_j13_nico_guardrail_001", "choice_j13_nico_guardrail_truth", "PAID", "NICO_J11_CONSEQUENCE", NICO_TRACE)
	var rivalry = _completed_r5b_j12("NICO_RIVALRY_MAINTAINED", "NICO", "choice_j12_nico_rivalry_leave", "B12")
	_exercise_case("Nico rivalry", rivalry, "NICO", "msg_j13_nico_rivalry_001", "choice_j13_nico_rivalry_alibi", "FAILED", "NICO_J11_CONSEQUENCE", NICO_TRACE)
	var closed = _completed_r5b_j12("NICO_CLEAN_CLOSE", "NETWORK", "", "C12")
	_exercise_case("Nico clean close stays silent", closed, "RESPIRATION", "msg_j13_respiration_001", "choice_j13_respiration_alone", "PAID", "NETWORK_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(not closed.traces.has(NICO_TRACE), "NICO_CLEAN_CLOSE creates no Nico consequence trace")


func _exercise_marie_matrix() -> void:
	var close = _completed_semantic_j12("MARIE_ADULT_RECONQUEST", "choice_j12_marie_join", false)
	_exercise_case("Marie close", close, "MARIE", "msg_j13_marie_close_001", "choice_j13_marie_close_truth", "PAID", "MARIE_J11_CONSEQUENCE", PUBLIC_TRACE)
	var distant = _completed_semantic_j12("MARIE_HONEST_REFUSAL", "", false)
	_exercise_case("Marie distant", distant, "MARIE", "msg_j13_marie_distance_001", "choice_j13_marie_distance_space", "CLOSED", "MARIE_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(close.completed_conversation_ids.count("chapter_13_priority") == 1 and distant.completed_conversation_ids.count("chapter_13_priority") == 1, "Marie variants complete once without a duplicate echo")


func _exercise_invalid_obligations_fail_closed() -> void:
	for mode in ["missing", "paid", "contradictory", "unknown"]:
		var state = _completed_network_state(false)
		if mode == "missing":
			state.obligations.erase("j12_priority_consequence_j13")
		elif mode == "paid":
			state.obligations["j12_priority_consequence_j13"]["status"] = "PAID"
		elif mode == "contradictory":
			state.obligations["j12_priority_consequence_j13"]["route"] = "MARIE"
		else:
			state.obligations["j12_priority_consequence_j13"]["route"] = "UNKNOWN"
		var provider = _new_provider(state)
		_expect(not bool(provider.start_day().get("accepted", false)), "invalid obligation fails closed: " + mode)
		_expect(state.current_day == "J12" and state.day_status == "COMPLETE" and provider.selected_pivot == "", "invalid obligation cannot mutate the J12 handoff: " + mode)


func _exercise_case(label: String, state, expected_pivot: String, first_message_id: String, choice_id: String, expected_status: String, expected_origin: String, expected_trace: String) -> void:
	var obligation: Dictionary = state.obligations.get("j12_priority_consequence_j13", {})
	_expect(str(obligation.get("status", "")) == "DUE" and str(obligation.get("origin", "")) == expected_origin, label + " starts from the exact due obligation")
	var provider = _new_provider(state)
	_expect_round_trip(provider, label + " end J12")
	_expect(bool(provider.start_day().get("accepted", false)) and provider.selected_pivot == expected_pivot, label + " selects the exact foreground")
	_expect(not state.traces.has(PAULINE_TRACE) and not state.traces.has(RAPHAELLE_TRACE), label + " creates no private J13 trace during selection")
	_expect_round_trip(provider, label + " before delivery")
	_confirm(provider)
	_expect(provider.presentation_count_by_id(first_message_id) == 1, label + " delivers only the exact variant")
	if expected_trace == PAULINE_TRACE or expected_trace == RAPHAELLE_TRACE:
		_expect(state.traces.has(expected_trace), label + " creates its private trace at delivery")
	_expect_round_trip(provider, label + " after delivery")
	var thread_id := str(PROVIDER.THREADS.get(expected_pivot, "thread_marie_private"))
	_present(provider, thread_id)
	_expect_round_trip(provider, label + " before choice")
	_expect(bool(provider.apply_choice(thread_id, choice_id).get("accepted", false)), label + " applies its authored choice")
	_expect(str(state.obligations["j12_priority_consequence_j13"].get("status", "")) == expected_status, label + " settles the debt exactly")
	_expect(str(state.obligations["j12_priority_consequence_j13"].get("paid_by", "")) == "Player" and str(state.obligations["j12_priority_consequence_j13"].get("paid_or_closed_at", "")) != "", label + " preserves settlement attribution")
	_expect(not bool(provider.apply_choice(thread_id, choice_id).get("accepted", false)), label + " cannot settle twice")
	_expect(state.j13_j14_trace_id == expected_trace, label + " hands J14 the exact accessible trace")
	_expect_round_trip(provider, label + " after choice")
	if expected_pivot not in ["MARIE", "RESPIRATION"]:
		_confirm(provider)
		_present(provider, "thread_marie_private")
		_expect(provider.presentation_count_by_id("msg_j13_marie_echo_001") == 1, label + " presents exactly one Marie echo")
		_expect_round_trip(provider, label + " after Marie echo")
	else:
		_expect(provider.presentation_count_by_id("msg_j13_marie_echo_001") == 0, label + " never duplicates Marie as echo")
	_confirm(provider)
	_expect(provider.phase == "complete" and state.day_status == "COMPLETE", label + " completes J13")
	_expect_round_trip(provider, label + " end J13")
	_expect_state_round_trip(state, label + " state end J13")
	var j13_threads: Dictionary = {}
	for candidate_thread in provider.transcripts_by_thread:
		for message in provider.transcripts_by_thread[candidate_thread]:
			if int(message.get("source_day", 0)) == 13:
				j13_threads[candidate_thread] = true
	_expect(j13_threads.size() <= (1 if expected_pivot in ["MARIE", "RESPIRATION"] else 2), label + " unlocks no compensation thread")


func _completed_network_state(pauline_eligible: bool):
	var state = STATE.new()
	_expect(state.restore_snapshot(j12_helper.marie_j11_base_snapshot), "NETWORK fixture clones a real J10 to J11 handoff")
	state.j10_pivot = "SANDRA"; state.j10_pivot_reason = "AUTHORED_ORDER"; state.j10_pivot_outcome = "CAFE_HELD_CALM_PRESENCE"
	state.completed_conversation_ids.erase("chapter_10_marie_obligations"); state.completed_conversation_ids.append("chapter_10_sandra_cafe")
	state.j11_pivot = "RESPIRATION"; state.j11_pivot_reason = "J10_NO_LEGITIMATE_CONTINUATION"; state.j11_pivot_outcome = ""; state.j11_physical_level = "NONE"
	_expect(state.complete_j11(), "NETWORK fixture completes J11")
	_expect(state.begin_j12(), "NETWORK fixture enters J12")
	_expect(state.apply_j12_choice("choice_j12_presence_la") and state.establish_j12_laverriere_public_trace() and state.pay_j12_laverriere_presence(), "NETWORK fixture establishes T14")
	var annexe_choice := "choice_j12_annexe_a12" if pauline_eligible else "choice_j12_annexe_c12"
	_expect(state.apply_j12_choice(annexe_choice), "NETWORK fixture chooses P13")
	_expect(state.pay_and_establish_j12_annexe_arrival() if pauline_eligible else state.establish_j12_annexe_public_trace(), "NETWORK fixture establishes T15")
	_expect(state.establish_j12_priority_consequence("NETWORK") and state.complete_j12(), "NETWORK fixture completes J12")
	return state


func _completed_r5b_j12(outcome: String, route: String, private_choice: String, annexe: String):
	var state = j12_helper._completed_r5b_j11_state(outcome)
	return _complete_j12(state, route, private_choice, annexe, false)


func _completed_semantic_j12(outcome: String, private_choice: String, failed_aftercare: bool):
	var state = j12_helper._completed_semantic_j11_state(outcome, "FAILED" if failed_aftercare else "PAID")
	return _complete_j12(state, "MATHILDE" if outcome.begins_with("MATHILDE_") else "MARIE", private_choice, "C12", failed_aftercare)


func _complete_j12(state, route: String, private_choice: String, annexe: String, failed_aftercare: bool):
	_expect(state.begin_j12(), route + " fixture enters J12")
	if failed_aftercare:
		_expect(state.mark_j12_failed_aftercare_processed(), route + " fixture preserves failed aftercare priority")
	_expect(state.apply_j12_choice("choice_j12_presence_la") and state.establish_j12_laverriere_public_trace() and state.pay_j12_laverriere_presence(), route + " fixture establishes and pays T14")
	if private_choice != "":
		_expect(state.apply_j12_choice(private_choice), route + " fixture records exact J12 private consequence")
	_expect(state.apply_j12_choice("choice_j12_annexe_" + annexe.to_lower()), route + " fixture chooses " + annexe)
	_expect(state.pay_and_establish_j12_annexe_arrival() if annexe in ["A12", "B12"] else state.establish_j12_annexe_public_trace(), route + " fixture establishes and settles T15")
	_expect(state.establish_j12_priority_consequence(route), route + " fixture creates exact J13 obligation")
	_expect(state.complete_j12(), route + " fixture completes J12")
	return state


func _new_provider(state):
	var provider = PROVIDER.new()
	_expect(provider.initialize(state, {}, {}, [], []), "J13 provider initializes")
	return provider


func _present(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 13 and not bool(message.get("is_player", false)) and not provider.presented_time_message_ids.has(str(message.get("message_id", ""))):
			provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "batch presents for " + thread_id)


func _confirm(provider) -> void:
	var target_text := str(provider.pending_transition.get("to_time", ""))
	if target_text != "":
		var target := TIME.parse_narrative_time(target_text)
		if target >= provider.current_narrative_time_minutes():
			provider.commit_narrative_time(target)
	_expect(bool(provider.confirm_transition().get("accepted", false)), "transition confirms")


func _expect_round_trip(provider, label: String) -> void:
	var snap: Dictionary = provider.snapshot()
	var restored = PROVIDER.new()
	_expect(restored.initialize(provider.state, {}, {}, [], []), label + " initializes")
	_expect(restored.restore_snapshot(snap), label + " restores")
	_expect(restored.snapshot() == snap, label + " is exact")


func _expect_state_round_trip(state, label: String) -> void:
	var snap: Dictionary = state.snapshot()
	_expect(state._j12_records_consistent(snap), label + " preserves J12 records")
	_expect(state._j13_records_consistent(snap), label + " preserves J13 records")
	var restored = STATE.new()
	_expect(restored.restore_snapshot(snap), label + " restores")
	_expect(restored.snapshot() == snap, label + " is exact")


func _expect(condition: bool, label: String) -> void:
	if not condition:
		failures.append(label)
