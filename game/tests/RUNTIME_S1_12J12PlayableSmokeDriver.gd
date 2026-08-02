extends Node

const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J09_PROVIDER := preload("res://scripts/runtime/season_1/J09RuntimeProvider.gd")
const J10_PROVIDER := preload("res://scripts/runtime/season_1/J10RuntimeProvider.gd")
const J11_PROVIDER := preload("res://scripts/runtime/season_1/J11RuntimeProvider.gd")
const J12_PROVIDER := preload("res://scripts/runtime/season_1/J12RuntimeProvider.gd")
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const J09_SMOKE := preload("res://tests/RUNTIME_S1_09J09PlayableSmokeDriver.gd")
const J10_SMOKE := preload("res://tests/RUNTIME_S1_10J10PlayableSmokeDriver.gd")

const MARIE_THREAD := "thread_marie_private"
const SANDRA_THREAD := "thread_sandra_private"
const MATHILDE_THREAD := "thread_mathilde_private"
const RAPHAELLE_THREAD := "thread_raphaelle_private"
const NICO_THREAD := "thread_nico_private"
const LAVERRIERE_THREAD := "thread_laverriere_group"
const ANNEXE_THREAD := "thread_annexe_group"

var failures: Array[String] = []
var marie_j11_base_snapshot: Dictionary = {}
var mathilde_j11_base_snapshot: Dictionary = {}

func _ready() -> void:
	marie_j11_base_snapshot = _build_real_j11_base_snapshot("MARIE")
	mathilde_j11_base_snapshot = _build_real_j11_base_snapshot("MATHILDE")
	_exercise_p11_deadlines_and_round_trips()
	_exercise_sandra_p11_and_public_audience()
	_exercise_public_trace_presence_matrix()
	_exercise_r5b_semantic_matrix()
	_exercise_failed_mathilde_aftercare_precedes_convergence("MATHILDE_M_B2")
	_exercise_failed_mathilde_aftercare_precedes_convergence("MATHILDE_M_B3")
	_exercise_nico_annexe_guardrail()
	_exercise_marie_mathilde_semantic_matrix()
	_exercise_r5a_snapshot_migration()
	_exercise_r5b_snapshot_migration()
	_exercise_r5c_snapshot_migration()
	if failures.is_empty():
		print("RUNTIME_S1_12_J12_PLAYABLE: OK")
		get_tree().quit(0)
		return
	for failure in failures: push_error(failure)
	get_tree().quit(1)

func _exercise_sandra_p11_and_public_audience() -> void:
	var state = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	state.promises["sandra_cafe_saturday_1100"] = _canonical_p11(true)
	var provider = _new_provider(state)
	_expect(bool(provider.start_day().get("accepted", false)) and provider.phase == "p11_incoming", "P11 confirmation opens before convergence")
	_expect_round_trip(provider, "P11 before incoming confirmation is presented")
	_present_batch(provider, SANDRA_THREAD)
	_expect_round_trip(provider, "P11 before Player choice")
	_expect(bool(provider.apply_choice(SANDRA_THREAD, "choice_j12_p11_confirm").get("accepted", false)), "P11 accepts only after Player confirmation")
	_expect(str(state.promises["sandra_cafe_saturday_1100"].get("status", "")) == "ACTIVE", "P11 remains unpaid during the off-phone transition")
	_expect_round_trip(provider, "P11 during off-phone transition")
	_confirm_transition(provider)
	_expect(str(state.promises["sandra_cafe_saturday_1100"].get("status", "")) == "PAID" and not state.pay_j12_p11(), "P11 is paid exactly once by the off-phone meeting")
	_expect_state_round_trip(state, "P11 after payment")
	_present_batch(provider, SANDRA_THREAD)
	_confirm_transition(provider)
	_present_batch(provider, MARIE_THREAD)
	_expect_round_trip(provider, "J12 plan choice")
	provider.apply_choice(MARIE_THREAD, "choice_j12_presence_la")
	_expect(str(state.promises["marie_j12_laverriere_presence"].get("due_at", "")) == "J12 17:45" and str(state.promises["marie_j12_laverriere_presence"].get("status", "")) == "ACTIVE", "P12 L-A is active with its exact due time")
	_confirm_transition(provider)
	_expect(str(state.promises["marie_j12_laverriere_presence"].get("status", "")) == "ACTIVE", "P12 is not paid merely by publishing T14")
	_present_batch(provider, LAVERRIERE_THREAD)
	var t16: Dictionary = state.traces.get("j12_sandra_public_context_view_01", {})
	_expect(not t16.is_empty() and t16.get("subjects", []).has("Player") and t16.get("current_audience", []).has("Sandra"), "T16 records Sandra's public view while Player remains a photographed La Verrière subject")
	_present_batch(provider, SANDRA_THREAD)
	provider.apply_choice(SANDRA_THREAD, "choice_j12_sandra_clear")
	_confirm_transition(provider)
	_expect(str(state.promises["marie_j12_laverriere_presence"].get("status", "")) == "PAID", "P12 is paid only when the La Verrière presence is completed")
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j12_annexe_a12")
	_expect(str(state.promises["j12_annexe_continuation"].get("status", "")) == "ACTIVE" and str(state.promises["j12_annexe_continuation"].get("due_at", "")) == "J12 22:50", "P13 A12 stays active before the group reaches L’Annexe")
	_confirm_transition(provider)
	_expect(str(state.promises["j12_annexe_continuation"].get("status", "")) == "PAID", "P13 A12 is paid by the actual group arrival")
	_present_batch(provider, ANNEXE_THREAD)
	_confirm_transition(provider)
	_present_batch(provider, SANDRA_THREAD)
	_confirm_transition(provider)
	_expect(provider.phase == "complete", "Sandra path completes J12")
	_expect(str(state.promises["sandra_cafe_saturday_1100"].get("status", "")) == "PAID", "P11 is paid after the off-phone meeting")
	_expect(state.traces.has("j12_laverriere_public_group_set_01") and state.traces.has("j12_annexe_public_group_set_01"), "both canonical public traces persist")
	_expect(state.j12_priority_route == "SANDRA", "only Sandra consequence is foreground for J13")
	_expect(not state.knowledge.has("fact_j12_unusual_behavior_observed"), "F20 is absent when Sandra receives a clear response without unusual observable behavior")

func _exercise_p11_deadlines_and_round_trips() -> void:
	var real_confirm = SEASON_STATE.new()
	real_confirm.current_day = "J10"; real_confirm.day_status = "ACTIVE"; real_confirm.j10_pivot = "SANDRA"
	_expect(real_confirm.apply_j10_sandra_outcome("choice_j10_sandra_saturday"), "real J10 flow creates conditional P11")
	real_confirm.current_day = "J11"; real_confirm.day_status = "ACTIVE"
	_expect(real_confirm.confirm_or_expire_j11_p11_counterparty(true), "real J11 flow records Sandra confirmation on the predeclared empty fields")
	_expect(str(real_confirm.promises["sandra_cafe_saturday_1100"].get("status", "")) == "CONDITIONAL" and str(real_confirm.promises["sandra_cafe_saturday_1100"].get("counterparty_confirmed_by", "")) == "Sandra", "Sandra confirmation alone keeps P11 conditional")
	var real_expire = SEASON_STATE.new()
	real_expire.current_day = "J10"; real_expire.day_status = "ACTIVE"; real_expire.j10_pivot = "SANDRA"
	real_expire.apply_j10_sandra_outcome("choice_j10_sandra_saturday"); real_expire.current_day = "J11"; real_expire.day_status = "ACTIVE"
	_expect(real_expire.confirm_or_expire_j11_p11_counterparty(false) and str(real_expire.promises["sandra_cafe_saturday_1100"].get("status", "")) == "EXPIRED", "real J11 flow expires an unconfirmed P11")
	var before_confirmation = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	before_confirmation.promises["sandra_cafe_saturday_1100"] = _canonical_p11(false)
	_expect_state_round_trip(before_confirmation, "P11 before Sandra confirmation")
	var absent = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	absent.promises["sandra_cafe_saturday_1100"] = _expired_p11()
	var absent_provider = _new_provider(absent)
	absent_provider.start_day()
	_expect(absent_provider.phase == "to_laverriere_plan" and str(absent.promises["sandra_cafe_saturday_1100"].get("status", "")) == "EXPIRED", "missing Sandra confirmation remains expired and never opens P11")
	_expect(not absent.pay_j12_p11(), "expired P11 cannot be paid")
	var deadline = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	deadline.promises["sandra_cafe_saturday_1100"] = _canonical_p11(true)
	var deadline_provider = _new_provider(deadline)
	deadline_provider.start_day(); _present_batch(deadline_provider, SANDRA_THREAD)
	_expect(deadline_provider.commit_narrative_time(570), "P11 Player deadline advances to 09:30")
	_expect(deadline_provider.phase == "to_laverriere_plan" and str(deadline.promises["sandra_cafe_saturday_1100"].get("status", "")) == "EXPIRED", "P11 expires when Player does not confirm by 09:30")
	_expect(not deadline.pay_j12_p11() and not deadline.expire_j12_p11_player_confirmation(), "expired Player deadline cannot pay or expire twice")
	_expect_state_round_trip(deadline, "P11 after Player deadline expiration")
	_expect_round_trip(deadline_provider, "P11 after Player deadline expiration")
	var legacy_deadline = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	legacy_deadline.promises["sandra_cafe_saturday_1100"] = _canonical_p11(true)
	var legacy_provider = _new_provider(legacy_deadline)
	legacy_provider.start_day(); _present_batch(legacy_provider, SANDRA_THREAD)
	var overdue_snapshot: Dictionary = legacy_provider.snapshot(); overdue_snapshot["current_time_minutes"] = 571
	var overdue_restored = _new_provider(legacy_deadline)
	_expect(overdue_restored.restore_snapshot(overdue_snapshot), "legacy P11 choice snapshot at 09:31 normalizes on restore")
	_expect(overdue_restored.phase == "to_laverriere_plan" and str(legacy_deadline.promises["sandra_cafe_saturday_1100"].get("status", "")) == "EXPIRED", "restored overdue P11 cannot be accepted after its deadline")
	var refused = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	refused.promises["sandra_cafe_saturday_1100"] = _canonical_p11(true)
	var refused_provider = _new_provider(refused)
	refused_provider.start_day(); _present_batch(refused_provider, SANDRA_THREAD)
	_expect(bool(refused_provider.apply_choice(SANDRA_THREAD, "choice_j12_p11_refuse").get("accepted", false)), "Player can explicitly refuse P11")
	_expect(str(refused.promises["sandra_cafe_saturday_1100"].get("status", "")) == "REFUSED" and not refused.pay_j12_p11(), "refused P11 remains closed and unpaid")
	_expect_state_round_trip(refused, "P11 after Player refusal")

func _exercise_public_trace_presence_matrix() -> void:
	var cases := [
		{"presence":"choice_j12_presence_la", "annexe":"choice_j12_annexe_a12", "player_at_annexe":true},
		{"presence":"choice_j12_presence_lb", "annexe":"choice_j12_annexe_b12", "player_at_annexe":true},
		{"presence":"choice_j12_presence_lc", "annexe":"choice_j12_annexe_c12", "player_at_annexe":false},
	]
	for test_case in cases:
		var state = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
		_expect(state.begin_j12(), "trace matrix begins J12")
		_expect(state.apply_j12_choice(str(test_case["presence"])) and state.establish_j12_laverriere_public_trace(), "trace matrix creates T14 from exact presence")
		_expect(state.establish_j12_sandra_public_context_view(), "trace matrix creates T16 from Sandra's exact public view")
		var t14: Dictionary = state.traces["j12_laverriere_public_group_set_01"]
		var t16: Dictionary = state.traces["j12_sandra_public_context_view_01"]
		var fixed_subjects: Array = ["Marie", "Player", "Pauline", "Bastien", "Élodie"]
		_expect(t14.get("subjects", []) == fixed_subjects and bool(t14.get("player_present", false)) and bool(t14.get("player_photographed", false)), "T14 contains exactly the five explicitly present La Verrière subjects for " + str(test_case["presence"]))
		_expect(not t14.get("subjects", []).has("Sandra") and t16.get("subjects", []) == fixed_subjects and t16.get("current_audience", []).has("Sandra"), "T16 keeps Sandra's view separate from T14 subjects")
		_expect(state.knowledge["fact_sandra_saw_public_j12_context"].get("current_knowers", []) == ["Sandra"], "F21 names Sandra as its sole current knower")
		_expect(state.apply_j12_choice(str(test_case["annexe"])) and state.establish_j12_annexe_public_trace(), "trace matrix creates T15 from exact L’Annexe branch")
		var t15: Dictionary = state.traces["j12_annexe_public_group_set_01"]
		var expected_presence := bool(test_case["player_at_annexe"])
		_expect(bool(t15.get("player_present", false)) == expected_presence and t15.get("subjects", []).has("Player") == expected_presence, "T15 distinguishes Player presence and photographed subject for " + str(test_case["annexe"]))
		_expect(bool(t15.get("player_received_trace", false)) and t15.get("current_audience", []).has("Player"), "T15 records explicit Player receipt independently of presence")
		_expect_state_round_trip(state, "public trace matrix " + str(test_case["presence"]) + "/" + str(test_case["annexe"]))

func _exercise_failed_mathilde_aftercare_precedes_convergence(physical_level: String) -> void:
	var state = _completed_semantic_j11_state(physical_level, "FAILED")
	var provider = _new_provider(state)
	_expect_state_round_trip(state, "%s FAILED state before handoff" % physical_level)
	_expect_round_trip(provider, "%s FAILED provider before handoff" % physical_level)
	provider.start_day()
	_expect(state.j11_physical_level == physical_level and provider.phase == "mathilde_failed_incoming", "%s failed Mathilde aftercare precedes normal J12" % physical_level)
	_expect_round_trip(provider, "%s FAILED exact priority phase" % physical_level)
	_present_batch(provider, MATHILDE_THREAD)
	_confirm_transition(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j12_presence_lc")
	_confirm_transition(provider)
	_present_batch(provider, LAVERRIERE_THREAD)
	_expect(provider.phase == "to_laverriere_close", "failed aftercare excludes the normal Mathilde module")
	_confirm_transition(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j12_annexe_c12")
	_present_batch(provider, ANNEXE_THREAD)
	_confirm_transition(provider)
	_expect(provider.phase == "day_close", "failed aftercare is not replayed as a normal after-separation module")
	_confirm_transition(provider)
	_expect(provider.phase == "complete" and state.mathilde_state == "TRUST_BROKEN", "failed aftercare remains a consequence, never retroactive payment")
	_expect(state.j12_priority_route == "MATHILDE", "failed aftercare keeps its Mathilde origin")
	var debt: Dictionary = state.obligations.get("j12_priority_consequence_j13", {})
	_expect(debt.get("concerned_people", []) == ["Player", "Mathilde"] and str(debt.get("origin", "")) == "MATHILDE_HOUSEHOLD_AFTERCARE", "failed aftercare debt remains attributed to Mathilde and the household")
	_expect_state_round_trip(state, "%s FAILED state after handoff" % physical_level)
	_expect_round_trip(provider, "%s FAILED provider after handoff" % physical_level)

func _exercise_nico_annexe_guardrail() -> void:
	var state = _completed_j11_state("NICO")
	var provider = _new_provider(state)
	provider.start_day(); _confirm_transition(provider); _present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j12_presence_lb"); _confirm_transition(provider); _present_batch(provider, LAVERRIERE_THREAD); _confirm_transition(provider); _present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j12_annexe_b12"); _confirm_transition(provider); _present_batch(provider, ANNEXE_THREAD)
	_expect(provider.phase == "nico_incoming", "Nico module occurs only in his own place")
	_present_batch(provider, NICO_THREAD)
	provider.apply_choice(NICO_THREAD, "choice_j12_nico_accept"); _confirm_transition(provider); _present_batch(provider, NICO_THREAD); _confirm_transition(provider)
	_expect(provider.phase == "complete" and state.j12_priority_route == "NICO", "Nico guardrail persists as the single priority consequence")

func _exercise_r5b_semantic_matrix() -> void:
	var cases := [
		{"outcome":"SANDRA_RULE_CLARIFIED","choice":"choice_j12_sandra_clear","context":"msg_j12_sandra_module_001","after":"msg_j12_sandra_after_clear_001","private":"SANDRA_RESPONSE_CLEAR"},
		{"outcome":"SANDRA_DESIRE_BOUNDED","choice":"choice_j12_sandra_delay","context":"msg_j12_sandra_desire_context_001","after":"msg_j12_sandra_after_delayed_001","private":"SANDRA_RESPONSE_DELAYED"},
		{"outcome":"SANDRA_DESIRE_BOUNDED","choice":"choice_j12_sandra_exit","context":"msg_j12_sandra_desire_context_001","after":"msg_j12_sandra_after_exit_001","private":"SANDRA_EXIT_CLEAN"},
		{"outcome":"SANDRA_IMAGE_REMOVED","choice":"","context":"","after":"","private":"UNESTABLISHED"},
		{"outcome":"FIRST_KISS","choice":"choice_j12_raphaelle_public","context":"msg_j12_raphaelle_001","after":"msg_j12_raphaelle_after_kiss_001","private":"RAPHAELLE_PUBLIC"},
		{"outcome":"RESULT_SENT_ATTRACTION_NAMED","choice":"choice_j12_raphaelle_public","context":"msg_j12_raphaelle_attraction_context_001","after":"msg_j12_raphaelle_after_attraction_001","private":"RAPHAELLE_PUBLIC"},
		{"outcome":"KISS_DECLINED","choice":"choice_j12_raphaelle_declined_hold","context":"msg_j12_raphaelle_declined_context_001","after":"msg_j12_raphaelle_after_declined_001","private":"RAPHAELLE_PUBLIC"},
		{"outcome":"RESULT_SENT_BOUNDARY_HELD","choice":"choice_j12_raphaelle_boundary_hold","context":"msg_j12_raphaelle_boundary_context_001","after":"msg_j12_raphaelle_after_boundary_001","private":"RAPHAELLE_PUBLIC"},
		{"outcome":"NICO_GUARDRAIL_HELD","choice":"choice_j12_nico_accept","context":"msg_j12_nico_private_001","after":"msg_j12_nico_after_guardrail_001","private":"NICO_ACCEPT"},
		{"outcome":"NICO_RIVALRY_MAINTAINED","choice":"choice_j12_nico_rivalry_leave","context":"msg_j12_nico_rivalry_module_001","after":"msg_j12_nico_after_rivalry_respected_001","private":"NICO_RIVALRY_LEAVE"},
		{"outcome":"NICO_CLEAN_CLOSE","choice":"","context":"","after":"","private":"UNESTABLISHED"},
	]
	for test_case in cases:
		_exercise_r5b_path(test_case)

func _exercise_r5b_path(test_case: Dictionary) -> void:
	var outcome := str(test_case["outcome"])
	var state = _completed_r5b_j11_state(outcome)
	var provider = _new_provider(state)
	_expect_state_round_trip(state, outcome + " state before J12")
	_expect(bool(provider.start_day().get("accepted", false)), outcome + " starts J12")
	_confirm_transition(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j12_presence_lb")
	_confirm_transition(provider)
	_present_batch(provider, LAVERRIERE_THREAD)
	if outcome == "FIRST_KISS":
		var raphaelle_t14: Dictionary = state.traces.get("j12_laverriere_public_group_set_01", {})
		_expect(raphaelle_t14.get("subjects", []) == ["Marie", "Player", "Pauline", "Bastien", "Élodie"] and not raphaelle_t14.get("subjects", []).has("Raphaëlle"), "FIRST_KISS does not infer Raphaëlle as a T14 subject")
		_expect(state.knowledge["fact_j12_laverriere_participants"].get("participants", []) == ["Marie", "Player", "Pauline", "Bastien", "Élodie"], "FIRST_KISS does not infer Raphaëlle as an F18 participant")
		_expect_state_round_trip(state, "FIRST_KISS T14 explicit subjects")
	var route_thread := SANDRA_THREAD if outcome.begins_with("SANDRA_") else (RAPHAELLE_THREAD if outcome in ["FIRST_KISS","KISS_DECLINED","RESULT_SENT_ATTRACTION_NAMED","RESULT_SENT_BOUNDARY_HELD"] else NICO_THREAD)
	var context_message := str(test_case["context"])
	var choice_id := str(test_case["choice"])
	if outcome.begins_with("NICO_"):
		_expect(provider.phase == "to_laverriere_close", outcome + " waits for Nico's own place")
	else:
		if context_message == "":
			_expect(provider.phase == "to_laverriere_close", outcome + " preserves public silence")
		else:
			_expect(provider.phase == "route_incoming" and provider.presentation_count_by_id(context_message) == 1, outcome + " selects its exact public module")
			_present_batch(provider, route_thread)
			_expect(bool(provider.apply_choice(route_thread, choice_id).get("accepted", false)), outcome + " public response applies")
	_confirm_transition(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j12_annexe_b12" if outcome.begins_with("NICO_") else "choice_j12_annexe_c12")
	if outcome.begins_with("NICO_"):
		_confirm_transition(provider)
		_present_batch(provider, ANNEXE_THREAD)
		if context_message == "":
			_expect(provider.phase == "to_after_separation", outcome + " creates no Nico aparté")
		else:
			_expect(provider.phase == "nico_incoming" and provider.presentation_count_by_id(context_message) == 1, outcome + " selects its exact Nico module")
			_present_batch(provider, NICO_THREAD)
			_expect(bool(provider.apply_choice(NICO_THREAD, choice_id).get("accepted", false)), outcome + " Nico response applies")
	else:
		_present_batch(provider, ANNEXE_THREAD)
	_confirm_transition(provider)
	var after_message := str(test_case["after"])
	if after_message == "":
		_expect(provider.phase == "day_close", outcome + " represents canonical silence by no segment")
		_expect(provider.presentation_count_by_id("msg_j12_marie_network_001") == 0, outcome + " receives no substitute route")
		if outcome == "SANDRA_IMAGE_REMOVED":
			_expect(provider.transcript_for(SANDRA_THREAD).is_empty(), "removed Sandra image creates no Sandra segment")
			_expect(state.j12_priority_route == "NETWORK", "removed Sandra image returns priority to the network")
			var debt: Dictionary = state.obligations.get("j12_priority_consequence_j13", {})
			_expect(str(debt.get("origin", "")) == "NETWORK_J11_CONSEQUENCE", "removed Sandra image creates only the network J13 obligation")
			var state_snapshot: Dictionary = state.snapshot()
			var restored_state = SEASON_STATE.new()
			_expect(restored_state.restore_snapshot(state_snapshot), "removed Sandra network consequence restores after save")
			var restored_debt: Dictionary = restored_state.obligations.get("j12_priority_consequence_j13", {})
			_expect(restored_state.j12_priority_route == "NETWORK" and str(restored_debt.get("origin", "")) == "NETWORK_J11_CONSEQUENCE", "removed Sandra network consequence survives save and reload")
	else:
		_expect(provider.phase == "after_incoming" and provider.presentation_count_by_id(after_message) == 1, outcome + " selects its exact after-separation consequence")
		_present_batch(provider, route_thread)
	_expect(state.j12_private_outcome == str(test_case["private"]), outcome + " stores the exact J12 private outcome")
	var f20: Dictionary = state.knowledge.get("fact_j12_unusual_behavior_observed", {})
	var expected_f20 := ""
	var expected_knowers: Array = []
	if outcome == "SANDRA_DESIRE_BOUNDED" and str(test_case["private"]) == "SANDRA_EXIT_CLEAN": expected_f20 = "PLAYER_LEFT_ROOM_AT_LAVERRIERE_PUBLICATION"; expected_knowers = ["Marie"]
	elif outcome == "NICO_RIVALRY_MAINTAINED": expected_f20 = "PLAYER_WATCHED_NICO_TALK_TO_MARIE"; expected_knowers = ["Nico"]
	if expected_f20 == "":
		_expect(f20.is_empty(), outcome + " creates no unobserved F20")
	else:
		_expect(str(f20.get("source_ref", "")) == expected_f20 and f20.get("initial_knowers", []) == expected_knowers, outcome + " creates F20 with exact source and knowers")
		_expect(str(f20.get("certainty", "")) == "OBSERVED" and str(f20.get("meaning_certainty", "")) == "INFERRED" and str(f20.get("shareability", "")) == "FACTUAL_ONLY", outcome + " preserves F20 epistemic qualifiers")
	_expect_round_trip(provider, outcome + " provider after consequence")
	_confirm_transition(provider)
	_expect(provider.phase == "complete", outcome + " completes J12")
	var route_debt: Dictionary = state.obligations.get("j12_priority_consequence_j13", {})
	_expect(str(route_debt.get("route", "")) == state.j12_priority_route and str(route_debt.get("status", "")) == "DUE", outcome + " hands off one exact due J13 route")
	_expect(not state.establish_j12_priority_consequence(state.j12_priority_route), outcome + " cannot duplicate the J13 priority obligation")
	_expect_state_round_trip(state, outcome + " state after J12")
	var transcript := JSON.stringify(provider.transcript_for(route_thread))
	if outcome == "RESULT_SENT_BOUNDARY_HELD":
		_expect(not transcript.contains("version privée") and not transcript.contains("Demain 18 h"), "professional boundary promises no future private version")
	if outcome == "KISS_DECLINED":
		_expect(not transcript.contains("Hier n’était pas le rôle") and transcript.contains("travailler normalement"), "declined kiss is respected without physical opening")
	if outcome == "NICO_RIVALRY_MAINTAINED":
		_expect(not transcript.contains("La règle a tenu"), "Nico rivalry never receives guardrail praise")

func _completed_r5b_j11_state(outcome: String):
	var state = SEASON_STATE.new()
	_expect(state.restore_snapshot(marie_j11_base_snapshot), outcome + " clones a real J10→J11 handoff")
	var pivot := "SANDRA" if outcome.begins_with("SANDRA_") else ("RAPHAELLE" if outcome in ["FIRST_KISS","KISS_DECLINED","RESULT_SENT_ATTRACTION_NAMED","RESULT_SENT_BOUNDARY_HELD"] else "NICO")
	var source_outcome: String = str({"SANDRA":"CAFE_HELD_MISSING_NAMED","RAPHAELLE":"PROCESS_HELPED_VISIT_BOUNDED","NICO":"DIFFERENCE_ACKNOWLEDGED_NO_IMAGE"}[pivot])
	state.j10_pivot = pivot; state.j10_pivot_reason = "AUTHORED_ORDER"; state.j10_pivot_outcome = source_outcome
	state.marie_j10_dinner_resolution = "NOT_DUE"; state.nico_j10_morning_confirmation = "NOT_DUE"
	state.completed_conversation_ids.erase("chapter_10_marie_obligations")
	state.completed_conversation_ids.append({"SANDRA":"chapter_10_sandra_cafe","RAPHAELLE":"chapter_10_raphaelle_process","NICO":"chapter_10_nico_observation"}[pivot])
	state.j11_pivot = pivot; state.j11_pivot_reason = "J10_CONTINUATION"; state.j11_pivot_outcome = ""; state.j11_physical_level = "NONE"
	if pivot == "SANDRA":
		var removed := outcome == "SANDRA_IMAGE_REMOVED"
		state.establish_j11_sandra_private_image("removed" if removed else "view_only")
		state.set_j11_semantic_outcome(outcome)
		var choice_id: String = str({"SANDRA_RULE_CLARIFIED":"choice_j11_sandra_rule","SANDRA_DESIRE_BOUNDED":"choice_j11_sandra_desire","SANDRA_IMAGE_REMOVED":"choice_j11_sandra_more"}[outcome])
		state.record_j11_choice(choice_id, [choice_id])
	elif pivot == "RAPHAELLE":
		state.establish_j11_raphaelle_result()
		state.set_j11_raphaelle_outcome(outcome, outcome == "FIRST_KISS", outcome == "FIRST_KISS", outcome == "FIRST_KISS")
		var choice_id: String = str({"FIRST_KISS":"choice_j11_raphaelle_meeting_accept","KISS_DECLINED":"choice_j11_raphaelle_meeting_decline","RESULT_SENT_ATTRACTION_NAMED":"choice_j11_raphaelle_attractive","RESULT_SENT_BOUNDARY_HELD":"choice_j11_raphaelle_boundary"}[outcome])
		state.record_j11_choice(choice_id, [choice_id])
		if outcome == "RESULT_SENT_BOUNDARY_HELD":
			state.traces["j11_raphaelle_chosen_result_01"]["current_state"] = "REMOVED"
			state.traces["j11_raphaelle_chosen_result_01"]["current_audience"] = ["Raphaëlle", "Maud"]
	else:
		state.set_j11_semantic_outcome(outcome)
		var choice_id: String = str({"NICO_GUARDRAIL_HELD":"choice_j11_nico_guardrail","NICO_RIVALRY_MAINTAINED":"choice_j11_nico_rivalry","NICO_CLEAN_CLOSE":"choice_j11_nico_close"}[outcome])
		state.record_j11_choice(choice_id, [choice_id])
	_expect(state.complete_j11(), outcome + " fixture completes J11")
	return state

func _exercise_marie_mathilde_semantic_matrix() -> void:
	var cases := [
		{"outcome":"MARIE_ADULT_RECONQUEST","module_message":"msg_j12_marie_module_001","after_message":"msg_j12_marie_after_001","morning":true},
		{"outcome":"MARIE_NON_ADULT_RECONNECTION","module_message":"msg_j12_marie_non_adult_module_001","after_message":"msg_j12_marie_non_adult_after_001"},
		{"outcome":"MARIE_SEX_NOT_USED_AS_BANDAGE","module_message":"msg_j12_marie_no_bandage_module_001","after_message":"msg_j12_marie_no_bandage_after_001"},
		{"outcome":"MARIE_HONEST_REFUSAL","module_message":"","after_message":"msg_j12_marie_distance_after_001"},
		{"outcome":"MARIE_NO_RECONQUEST","module_message":"","after_message":"msg_j12_marie_distance_after_001"},
		{"outcome":"MATHILDE_LOOK_ONLY","module_message":"msg_j12_mathilde_look_module_001","after_message":"msg_j12_mathilde_look_after_001"},
		{"outcome":"MATHILDE_M_B1","module_message":"msg_j12_mathilde_m_b1_module_001","after_message":"msg_j12_mathilde_m_b1_after_001"},
		{"outcome":"MATHILDE_M_B2","module_message":"msg_j12_mathilde_m_b2_module_001","after_message":"msg_j12_mathilde_m_b2_after_001"},
		{"outcome":"MATHILDE_M_B3","module_message":"msg_j12_mathilde_m_b3_module_001","after_message":"msg_j12_mathilde_after_001"},
		{"outcome":"MATHILDE_CLEAN_STOP","module_message":"","after_message":"msg_j12_mathilde_clean_stop_after_001"},
		{"outcome":"MATHILDE_DISTANCE_RESTORED","module_message":"","after_message":""},
	]
	for test_case in cases:
		_exercise_semantic_path(test_case)

func _exercise_semantic_path(test_case: Dictionary) -> void:
	var outcome := str(test_case["outcome"])
	var state = _completed_semantic_j11_state(outcome)
	var provider = _new_provider(state)
	_expect_state_round_trip(state, outcome + " state before handoff")
	_expect_round_trip(provider, outcome + " provider before handoff")
	var started: Dictionary = provider.start_day()
	_expect(bool(started.get("accepted", false)), outcome + " starts J12")
	if bool(test_case.get("morning", false)):
		_expect(provider.phase == "marie_aftercare_incoming" and str(state.obligations["aftercare_marie_j11"].get("status", "")) == "DUE", "Marie A5 serves 08:24 while aftercare remains due")
		_present_batch(provider, MARIE_THREAD)
		_expect(str(state.obligations["aftercare_marie_j11"].get("status", "")) == "PAID", "Marie A5 pays aftercare only after the 08:24 segment")
		_expect(provider.presentation_count_by_id("msg_j12_marie_aftercare_001") == 1, "Marie 08:24 is presented exactly once")
		_expect_round_trip(provider, "Marie post-aftercare exact phase")
	else:
		_expect(provider.phase != "marie_aftercare_incoming", outcome + " never receives Marie physical aftercare")
	_confirm_transition(provider)
	_present_batch(provider, MARIE_THREAD)
	_expect(bool(provider.apply_choice(MARIE_THREAD, "choice_j12_presence_la").get("accepted", false)), outcome + " chooses public presence")
	_confirm_transition(provider)
	_present_batch(provider, LAVERRIERE_THREAD)
	if outcome == "MATHILDE_M_B2":
		var mathilde_t14: Dictionary = state.traces.get("j12_laverriere_public_group_set_01", {})
		_expect(mathilde_t14.get("subjects", []) == ["Marie", "Player", "Pauline", "Bastien", "Élodie"] and not mathilde_t14.get("subjects", []).has("Mathilde"), "M-B2 does not infer Mathilde as a T14 subject")
		_expect(state.knowledge["fact_j12_laverriere_participants"].get("participants", []) == ["Marie", "Player", "Pauline", "Bastien", "Élodie"], "M-B2 does not infer Mathilde as an F18 participant")
		_expect_state_round_trip(state, "M-B2 T14 explicit subjects")
	var module_message := str(test_case.get("module_message", ""))
	var route_thread := MARIE_THREAD if outcome.begins_with("MARIE_") else MATHILDE_THREAD
	if module_message != "":
		_expect(provider.phase == "route_incoming" and provider.presentation_count_by_id(module_message) == 1, outcome + " selects only its exact J12 module")
		_present_batch(provider, route_thread)
		var choices: Array[Dictionary] = provider.choices_for(route_thread)
		_expect(not choices.is_empty(), outcome + " exact module remains playable")
		if not choices.is_empty():
			var choice_index := choices.size() - 1 if outcome == "MATHILDE_M_B3" else 0
			_expect(bool(provider.apply_choice(route_thread, str(choices[choice_index].get("choice_id", ""))).get("accepted", false)), outcome + " module choice applies")
	else:
		_expect(provider.phase == "to_laverriere_close", outcome + " preserves the required public silence")
	_confirm_transition(provider)
	_present_batch(provider, MARIE_THREAD)
	_expect(bool(provider.apply_choice(MARIE_THREAD, "choice_j12_annexe_c12").get("accepted", false)), outcome + " can refuse L’Annexe without punishment")
	_present_batch(provider, ANNEXE_THREAD)
	_confirm_transition(provider)
	var after_message := str(test_case.get("after_message", ""))
	if after_message != "":
		_expect(provider.phase == "after_incoming" and provider.presentation_count_by_id(after_message) == 1, outcome + " selects the exact after-separation consequence")
		_present_batch(provider, route_thread)
	else:
		_expect(provider.phase == "day_close", outcome + " creates no invented private aftercare")
	_expect_round_trip(provider, outcome + " provider after handoff")
	_confirm_transition(provider)
	_expect(provider.phase == "complete" and state.j12_priority_route == ("MARIE" if outcome.begins_with("MARIE_") else "MATHILDE"), outcome + " completes with correctly attributed debt")
	var transcript := JSON.stringify(provider.transcript_for(route_thread))
	if outcome in ["MARIE_HONEST_REFUSAL", "MARIE_NO_RECONQUEST"]:
		_expect(not transcript.contains("Viens près de moi"), outcome + " receives no close-couple text")
	if outcome in ["MATHILDE_LOOK_ONLY", "MATHILDE_DISTANCE_RESTORED"]:
		_expect(not transcript.contains("quelque chose à ne pas savoir") and not transcript.contains("contact sexuel"), outcome + " receives no physical-secret implication")
	var f20: Dictionary = state.knowledge.get("fact_j12_unusual_behavior_observed", {})
	_expect(f20.is_empty(), outcome + " does not infer F20 from a private Mathilde/Marie choice")
	if outcome == "MATHILDE_M_B2":
		_expect(not transcript.contains("On a décidé hier. Pas aujourd’hui."), "M-B2 never opens the M-B3 consequence")
	if outcome == "MATHILDE_M_B3":
		_expect(transcript.contains("On a décidé hier. Pas aujourd’hui.") and transcript.contains("deuxième scène"), "M-B3 remains distinct without new J12 sexuality")

func _completed_semantic_j11_state(outcome: String, mathilde_aftercare_resolution := "PAID"):
	var state = SEASON_STATE.new()
	var base_snapshot: Dictionary = marie_j11_base_snapshot if outcome.begins_with("MARIE_") else mathilde_j11_base_snapshot
	_expect(state.restore_snapshot(base_snapshot), outcome + " clones a real J10→J11 handoff")
	if outcome.begins_with("MARIE_"):
		if outcome == "MARIE_ADULT_RECONQUEST":
			_expect(state.establish_j11_marie_adult_event(true, true), "Marie A5 fixture establishes")
			state.record_j11_choice("choice_j11_marie_reconquest", ["choice_j11_marie_reconquest"])
		else:
			_expect(state.set_j11_semantic_outcome(outcome), outcome + " fixture establishes")
			var choice_id := str({"MARIE_NON_ADULT_RECONNECTION":"choice_j11_marie_reconquest","MARIE_SEX_NOT_USED_AS_BANDAGE":"choice_j11_marie_no_pansement","MARIE_HONEST_REFUSAL":"choice_j11_marie_refuse"}.get(outcome, ""))
			if choice_id != "": state.record_j11_choice(choice_id, [choice_id])
	else:
		state.configure_j11_mathilde_safety(true, true, true)
		match outcome:
			"MATHILDE_LOOK_ONLY": state.set_j11_semantic_outcome(outcome); state.record_j11_choice("choice_j11_mathilde_look", ["choice_j11_mathilde_look"])
			"MATHILDE_M_B1": state.set_j11_mathilde_proximity("PROXIMITY_CONSENTED"); state.record_j11_choice("choice_j11_mathilde_proximity", ["choice_j11_mathilde_proximity"])
			"MATHILDE_M_B2", "MATHILDE_M_B3": state.establish_j11_mathilde_physical_event(outcome, true); state.resolve_j11_aftercare("aftercare_mathilde_j11", mathilde_aftercare_resolution, "Player"); state.record_j11_choice("choice_j11_mathilde_after_repeat" if mathilde_aftercare_resolution == "FAILED" else ("choice_j11_mathilde_m_b2_hold" if outcome == "MATHILDE_M_B2" else "choice_j11_mathilde_m_b3_accept"), ["choice_j11_mathilde_after_repeat" if mathilde_aftercare_resolution == "FAILED" else ("choice_j11_mathilde_m_b2_hold" if outcome == "MATHILDE_M_B2" else "choice_j11_mathilde_m_b3_accept")])
			"MATHILDE_CLEAN_STOP": state.set_j11_mathilde_proximity("PROXIMITY_CONSENTED"); state.set_j11_semantic_outcome(outcome); state.record_j11_choice("choice_j11_mathilde_proximity", ["choice_j11_mathilde_proximity"]); state.record_j11_choice("choice_j11_mathilde_physical_stop", ["choice_j11_mathilde_physical_stop"])
			"MATHILDE_DISTANCE_RESTORED": state.set_j11_mathilde_proximity("DISTANCE"); state.record_j11_choice("choice_j11_mathilde_distance", ["choice_j11_mathilde_distance"])
	_expect(state.complete_j11(), "fixture completes J11 for " + outcome)
	return state

func _build_real_j11_base_snapshot(pivot: String) -> Dictionary:
	var j09_helper = J09_SMOKE.new()
	var j10_helper = J10_SMOKE.new()
	var j09 = j10_helper._completed_j09_provider(j09_helper, "choice_j09_dinner_refuse")
	var state = j09.state
	if pivot == "MATHILDE":
		state.sandra_state = "DISTANT_FRIEND"; state.raphaelle_state = "UNESTABLISHED"; state.nico_state = "ORDINARY_FRIEND"; state.mathilde_state = "LOOK_ACKNOWLEDGED"
		state.mathilde_j06_outcome = "ACKNOWLEDGED_RESPECTFUL"; state.j06_external_continuity_resolution = "NO_PROMISE"
		state.traces["j02_mathilde_arrival_room_01"] = {"current_state":"ACTIVE"}; state.traces["j06_mathilde_look_acknowledged_01"] = {"current_state":"ACTIVE","current_audience":["Mathilde","Player"]}
		state.knowledge["fact_mathilde_stay_started"] = {"current_knowers":["Marie","Player","Mathilde"]}; state.knowledge["fact_mathilde_knows_player_noticed_her"] = {"initial_knowers":["Mathilde","Player"]}
	var j10 = J10_PROVIDER.new()
	_expect(j10.initialize(state, j09.transcripts_by_thread, j09.produced_message_ids, j09.unlocked_thread_ids, j09.gallery_asset_ids), pivot + " real J10 initializes")
	j10.start_day()
	if pivot == "MARIE":
		j10_helper._confirm_transition_monotonic(j10); j10_helper._present_batch(j10, MARIE_THREAD); j10.apply_choice(MARIE_THREAD, "choice_j10_fallback_join"); j10_helper._confirm_transition_monotonic(j10)
	else:
		j10_helper._confirm_transition_monotonic(j10); j10_helper._present_batch(j10, MATHILDE_THREAD); j10.apply_choice(MATHILDE_THREAD, "choice_j10_mathilde_effect"); j10_helper._confirm_transition_monotonic(j10)
		j10_helper._present_batch(j10, MARIE_THREAD); j10.apply_choice(MARIE_THREAD, "choice_j10_fallback_join"); j10_helper._confirm_transition_monotonic(j10)
		j10_helper._present_batch(j10, MATHILDE_THREAD); j10.apply_choice(MATHILDE_THREAD, "choice_j10_mathilde_after_effect_guided"); j10_helper._confirm_transition_monotonic(j10)
	_expect(j10.phase == "complete", pivot + " real J10 completes")
	var j11 = J11_PROVIDER.new()
	_expect(j11.initialize(j10.state, j10.transcripts_by_thread, j10.produced_message_ids, j10.unlocked_thread_ids, j10.gallery_asset_ids), pivot + " real J11 initializes")
	_expect(bool(j11.start_day().get("accepted", false)) and j11.state.j11_pivot == pivot, pivot + " real J11 handoff selects exact pivot")
	for failure in j09_helper.failures: failures.append("J09 helper: " + failure)
	for failure in j10_helper.failures: failures.append("J10 helper: " + failure)
	var result: Dictionary = j11.state.snapshot()
	j09_helper.free(); j10_helper.free()
	return result

func _exercise_r5a_snapshot_migration() -> void:
	var adult = _completed_semantic_j11_state("MARIE_ADULT_RECONQUEST")
	for legacy_version in [9, 19]:
		var legacy_adult: Dictionary = adult.snapshot(); legacy_adult["version"] = legacy_version; legacy_adult["j11_pivot_outcome"] = ""; legacy_adult["obligations"]["aftercare_marie_j11"]["status"] = "PAID"; legacy_adult["obligations"]["aftercare_marie_j11"]["paid_by"] = "legacy auto-payment"
		var restored_adult = SEASON_STATE.new()
		_expect(restored_adult.restore_snapshot(legacy_adult), "legacy v%d Marie snapshot migrates explicitly" % legacy_version)
		_expect(restored_adult.j11_pivot_outcome == "MARIE_ADULT_RECONQUEST" and str(restored_adult.obligations["aftercare_marie_j11"].get("status", "")) == "DUE", "legacy v%d Marie auto-payment migrates back to due before J12" % legacy_version)
	var b3 = _completed_semantic_j11_state("MATHILDE_M_B3")
	var legacy_b3: Dictionary = b3.snapshot(); legacy_b3["version"] = 19; legacy_b3["j11_pivot_outcome"] = ""
	var restored_b3 = SEASON_STATE.new()
	_expect(restored_b3.restore_snapshot(legacy_b3) and restored_b3.j11_pivot_outcome == "MATHILDE_M_B3", "legacy exact physical level migrates to M-B3")
	var ambiguous = _completed_semantic_j11_state("MATHILDE_LOOK_ONLY").snapshot(); ambiguous["version"] = 19; ambiguous["j11_pivot_outcome"] = ""; ambiguous["selected_choice_ids"] = []
	_expect(not SEASON_STATE.new().restore_snapshot(ambiguous), "ambiguous legacy Mathilde snapshot fails closed")

func _exercise_r5b_snapshot_migration() -> void:
	for outcome in ["SANDRA_RULE_CLARIFIED","SANDRA_DESIRE_BOUNDED","SANDRA_IMAGE_REMOVED","FIRST_KISS","KISS_DECLINED","RESULT_SENT_ATTRACTION_NAMED","RESULT_SENT_BOUNDARY_HELD","NICO_GUARDRAIL_HELD","NICO_RIVALRY_MAINTAINED","NICO_CLEAN_CLOSE"]:
		var legacy: Dictionary = _completed_r5b_j11_state(outcome).snapshot()
		legacy["version"] = 20
		legacy["j11_pivot_outcome"] = ""
		var restored = SEASON_STATE.new()
		_expect(restored.restore_snapshot(legacy), outcome + " legacy v20 snapshot migrates from exact choice evidence")
		_expect(restored.j11_pivot_outcome == outcome, outcome + " migration preserves the exact semantic outcome")
	var ambiguous_sandra: Dictionary = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED").snapshot()
	ambiguous_sandra["version"] = 20; ambiguous_sandra["j11_pivot_outcome"] = ""; ambiguous_sandra["selected_choice_ids"].erase("choice_j11_sandra_rule")
	_expect(not SEASON_STATE.new().restore_snapshot(ambiguous_sandra), "ambiguous legacy Sandra snapshot fails closed")
	var ambiguous_nico: Dictionary = _completed_r5b_j11_state("NICO_GUARDRAIL_HELD").snapshot()
	ambiguous_nico["version"] = 20; ambiguous_nico["j11_pivot_outcome"] = ""; ambiguous_nico["selected_choice_ids"].erase("choice_j11_nico_guardrail")
	_expect(not SEASON_STATE.new().restore_snapshot(ambiguous_nico), "ambiguous legacy Nico snapshot fails closed")

func _exercise_r5c_snapshot_migration() -> void:
	var state = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	_expect(state.begin_j12(), "R5C migration fixture begins J12")
	_expect(state.apply_j12_choice("choice_j12_presence_la"), "R5C migration fixture selects L-A")
	_expect(state.pay_j12_laverriere_presence() and state.establish_j12_laverriere_public_trace(), "R5C migration fixture pays P12 and creates T14")
	_expect(state.establish_j12_sandra_public_context_view() and state.apply_j12_choice("choice_j12_sandra_exit"), "R5C migration fixture creates exact T16/F20 evidence")
	_expect(state.apply_j12_choice("choice_j12_annexe_c12") and state.establish_j12_annexe_public_trace(), "R5C migration fixture refuses P13 and receives T15")
	_expect(state.establish_j12_priority_consequence("SANDRA") and state.complete_j12(), "R5C migration fixture completes J12")
	var legacy: Dictionary = state.snapshot()
	legacy["version"] = 21
	legacy["promises"]["marie_j12_laverriere_presence"] = {"promise_id":"marie_j12_laverriere_presence", "status":"PAID", "outcome":"L-A", "due_at":"J12 22:15"}
	legacy["promises"]["j12_annexe_continuation"] = {"promise_id":"j12_annexe_continuation", "status":"REFUSED", "accepted_by_player":false, "outcome":"C12", "due_at":"J12 00:00"}
	legacy["traces"].erase("j12_sandra_public_context_view_01")
	legacy["knowledge"].erase("fact_sandra_saw_public_j12_context")
	legacy["knowledge"].erase("fact_j12_unusual_behavior_observed")
	legacy["traces"]["j12_laverriere_public_group_set_01"]["subjects"].append_array(["Mathilde", "Raphaëlle"])
	legacy["traces"]["j12_laverriere_public_group_set_01"]["initial_audience"].append_array(["Mathilde", "Raphaëlle"])
	legacy["traces"]["j12_laverriere_public_group_set_01"]["current_audience"].append_array(["Mathilde", "Raphaëlle"])
	legacy["knowledge"]["fact_j12_laverriere_participants"]["participants"].append_array(["Mathilde", "Raphaëlle"])
	var restored = SEASON_STATE.new()
	var restored_ok := restored.restore_snapshot(legacy)
	_expect(restored_ok, "legacy v21 J12 snapshot migrates from exact choices")
	if restored_ok:
		_expect(int(restored.snapshot().get("version", -1)) == 23, "R5C migration advances through the current state contract")
		_expect(str(restored.promises["marie_j12_laverriere_presence"].get("due_at", "")) == "J12 17:45" and str(restored.promises["j12_annexe_continuation"].get("due_at", "")) == "J12 22:50", "R5C migration canonicalizes P12/P13 due times")
		_expect(restored.traces["j12_laverriere_public_group_set_01"].get("subjects", []) == ["Marie", "Player", "Pauline", "Bastien", "Élodie"], "v21 migration removes route-derived Mathilde and Raphaëlle from T14")
		_expect(restored.knowledge["fact_j12_laverriere_participants"].get("participants", []) == ["Marie", "Player", "Pauline", "Bastien", "Élodie"], "v21 migration normalizes F18 to explicit T14 participants")
		_expect(restored.traces.has("j12_sandra_public_context_view_01") and restored.knowledge.has("fact_j12_unusual_behavior_observed"), "R5C migration reconstructs T16/F20 only from exact selected-choice evidence")
		_expect_state_round_trip(restored, "R5C migrated completed J12")
	var pre_event = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	pre_event.begin_j12(); pre_event.apply_j12_choice("choice_j12_presence_lb"); pre_event.establish_j12_laverriere_public_trace()
	var pre_event_legacy: Dictionary = pre_event.snapshot(); pre_event_legacy["version"] = 21
	var pre_event_restored = SEASON_STATE.new()
	_expect(pre_event_restored.restore_snapshot(pre_event_legacy), "legacy v21 snapshot before Sandra's view resumes")
	_expect(not pre_event_restored.traces.has("j12_sandra_public_context_view_01") and not pre_event_restored.knowledge.has("fact_j12_unusual_behavior_observed"), "migration creates neither T16 nor F20 before an exact source event")
	var malformed: Dictionary = pre_event.snapshot(); malformed["version"] = 21; malformed["promises"]["marie_j12_laverriere_presence"] = 1
	_expect(not SEASON_STATE.new().restore_snapshot(malformed), "R5C migration rejects non-dictionary nested ledger records without crashing")
	var contradictory = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	contradictory.begin_j12(); contradictory.apply_j12_choice("choice_j12_presence_la"); contradictory.apply_j12_choice("choice_j12_annexe_a12")
	var contradictory_snapshot: Dictionary = contradictory.snapshot(); contradictory_snapshot["version"] = 21; contradictory_snapshot["promises"]["j12_annexe_continuation"]["status"] = "REFUSED"
	_expect(not SEASON_STATE.new().restore_snapshot(contradictory_snapshot), "R5C migration rejects contradictory A12 refusal evidence")
	var late_presence = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	late_presence.begin_j12(); late_presence.apply_j12_choice("choice_j12_presence_lb"); late_presence.establish_j12_laverriere_public_trace()
	var late_presence_provider = _new_provider(late_presence)
	var close_snapshot: Dictionary = late_presence_provider.snapshot()
	close_snapshot["phase"] = "close_incoming"; close_snapshot["current_time_minutes"] = 1335
	_expect(late_presence_provider.restore_snapshot(close_snapshot), "provider resumes an old post-La Verrière payment phase")
	_expect(str(late_presence.promises["marie_j12_laverriere_presence"].get("status", "")) == "PAID", "post-close phase is exact evidence that P12 was paid")
	var late_annexe = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	late_annexe.begin_j12(); late_annexe.apply_j12_choice("choice_j12_presence_lb"); late_annexe.pay_j12_laverriere_presence(); late_annexe.establish_j12_laverriere_public_trace(); late_annexe.apply_j12_choice("choice_j12_annexe_a12"); late_annexe.establish_j12_annexe_public_trace()
	var late_annexe_provider = _new_provider(late_annexe)
	var annexe_snapshot: Dictionary = late_annexe_provider.snapshot()
	annexe_snapshot["phase"] = "annexe_incoming"; annexe_snapshot["current_time_minutes"] = 1398
	_expect(late_annexe_provider.restore_snapshot(annexe_snapshot), "provider resumes an old post-arrival P13 phase")
	_expect(str(late_annexe.promises["j12_annexe_continuation"].get("status", "")) == "PAID", "post-arrival phase is exact evidence that P13 was paid")
	var atomic_state = _completed_r5b_j11_state("SANDRA_RULE_CLARIFIED")
	atomic_state.begin_j12(); atomic_state.apply_j12_choice("choice_j12_presence_lb"); atomic_state.pay_j12_laverriere_presence(); atomic_state.establish_j12_laverriere_public_trace(); atomic_state.apply_j12_choice("choice_j12_annexe_a12"); atomic_state.establish_j12_annexe_public_trace()
	var atomic_provider = _new_provider(atomic_state)
	var atomic_snapshot: Dictionary = atomic_provider.snapshot()
	atomic_snapshot["phase"] = "to_annexe"; atomic_snapshot["pending_transition"] = {"kind":"to_annexe"}; atomic_snapshot["current_time_minutes"] = 1362
	_expect(atomic_provider.restore_snapshot(atomic_snapshot), "atomic arrival failure fixture restores")
	_expect(not bool(atomic_provider.confirm_transition().get("accepted", false)), "duplicate T15 makes the atomic arrival transition fail")
	_expect(str(atomic_state.promises["j12_annexe_continuation"].get("status", "")) == "ACTIVE" and not atomic_provider.pending_transition.is_empty(), "failed arrival leaves P13 and its transition untouched")

func _completed_j11_state(pivot: String):
	var state = SEASON_STATE.new()
	state.current_day = "J11"; state.day_status = "ACTIVE"
	var source: Array = {"SANDRA":["SANDRA","CAFE_HELD_MISSING_NAMED"],"MATHILDE":["MATHILDE","OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED"],"NICO":["NICO","DIFFERENCE_ACKNOWLEDGED_NO_IMAGE"]}[pivot]
	state.j10_pivot = source[0]; state.j10_pivot_reason = "AUTHORED_ORDER"; state.j10_pivot_outcome = source[1]
	state.marie_j10_dinner_resolution = "NOT_DUE"; state.nico_j10_morning_confirmation = "NOT_DUE"
	state.completed_conversation_ids.append({"SANDRA":"chapter_10_sandra_cafe","MATHILDE":"chapter_10_mathilde_outfit","NICO":"chapter_10_nico_observation"}[pivot])
	state.j11_pivot = pivot; state.j11_pivot_reason = "J10_CONTINUATION"
	if pivot == "SANDRA":
		state.establish_j11_sandra_private_image("view_only"); state.set_j11_semantic_outcome("SANDRA_RULE_CLARIFIED"); state.record_j11_choice("choice_j11_sandra_rule", ["choice_j11_sandra_rule"])
	elif pivot == "MATHILDE":
		state.configure_j11_mathilde_safety(true, true, true); state.establish_j11_mathilde_physical_event("MATHILDE_M_B2", true); state.resolve_j11_aftercare("aftercare_mathilde_j11", "PAID", "Player"); state.record_j11_choice("choice_j11_mathilde_after_no_definition", ["choice_j11_mathilde_after_no_definition"])
	else:
		state.set_j11_semantic_outcome("NICO_GUARDRAIL_HELD"); state.record_j11_choice("choice_j11_nico_guardrail", ["choice_j11_nico_guardrail"])
	_expect(state.complete_j11(), "fixture completes J11 for " + pivot)
	return state

func _new_provider(state):
	var provider = J12_PROVIDER.new(); _expect(provider.initialize(state, {}, {}, [], []), "J12 provider initializes"); return provider

func _canonical_p11(counterparty_confirmed: bool) -> Dictionary:
	return {
		"promise_id":"sandra_cafe_saturday_1100", "promise_type":"MEETING", "created_at":"J10 12:24", "created_by":"Player", "proposed_to":"Sandra",
		"accepted_at":"", "accepted_by_player":false, "counterparty_confirmed_at":"J11 17:44" if counterparty_confirmed else "", "counterparty_confirmed_by":"Sandra" if counterparty_confirmed else "",
		"action_due":"Café au même endroit samedi si double confirmation", "due_at":"J12 11:00", "confirmation_deadline":"Sandra J11 18:00 puis Player J12 09:30",
		"counterparty_confirmation_deadline":"J11 18:00", "player_confirmation_deadline":"J12 09:30", "status":"CONDITIONAL",
		"paid_or_closed_at":"", "paid_or_closed_by":"", "outcome":"COUNTERPARTY_CONFIRMED" if counterparty_confirmed else "PENDING_DOUBLE_CONFIRMATION",
		"related_scene":"J12_PRELUDE_SANDRA_CAFE_CONFIRMED", "related_trace_ids":["j01_sandra_lunch_memory_soft"],
	}

func _expired_p11() -> Dictionary:
	var p11 := _canonical_p11(false)
	p11["status"] = "EXPIRED"; p11["paid_or_closed_at"] = "J11 18:00"; p11["paid_or_closed_by"] = "counterparty_confirmation_deadline"; p11["outcome"] = "EXPIRED_COUNTERPARTY_NOT_CONFIRMED"
	return p11

func _present_batch(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 12 and not bool(message.get("is_player", false)) and not provider.presented_time_message_ids.has(str(message.get("message_id", ""))): provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "batch presents for %s in %s" % [thread_id, provider.phase])

func _confirm_transition(provider) -> Dictionary:
	var transition: Dictionary = provider.pending_transition.duplicate(true); var target_text := str(transition.get("to_time", ""))
	if target_text != "":
		var target := NARRATIVE_TIME.parse_narrative_time(target_text)
		if target >= provider.current_narrative_time_minutes(): provider.commit_narrative_time(target)
	var result: Dictionary = provider.confirm_transition(); _expect(bool(result.get("accepted", false)), "transition confirms for " + str(transition.get("kind", ""))); return result

func _expect_round_trip(provider, label: String) -> void:
	var provider_snapshot: Dictionary = provider.snapshot(); var restored = J12_PROVIDER.new()
	_expect(restored.initialize(provider.state, {}, {}, [], []), label + " provider initialize"); _expect(restored.restore_snapshot(provider_snapshot), label + " provider restore"); _expect(restored.snapshot() == provider_snapshot, label + " exact provider round trip")

func _expect_state_round_trip(state, label: String) -> void:
	var state_snapshot: Dictionary = state.snapshot(); var restored = SEASON_STATE.new()
	var restored_ok := restored.restore_snapshot(state_snapshot)
	_expect(restored_ok, label + " state restore")
	_expect(restored.snapshot() == state_snapshot, label + " exact state round trip")

func _expect(condition: bool, label: String) -> void:
	if not condition: failures.append(label)
