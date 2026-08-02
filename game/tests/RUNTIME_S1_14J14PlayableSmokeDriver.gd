extends Node

const STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const PROVIDER := preload("res://scripts/runtime/season_1/J14RuntimeProvider.gd")
const TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const J13_SMOKE := preload("res://tests/RUNTIME_S1_13J13PlayableSmokeDriver.gd")
const J12_SMOKE := preload("res://tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd")
var failures: Array[String] = []
var j13_helper

func _ready() -> void:
	j13_helper = J13_SMOKE.new(); j13_helper.j12_helper = J12_SMOKE.new()
	j13_helper.j12_helper.marie_j11_base_snapshot = j13_helper.j12_helper._build_real_j11_base_snapshot("MARIE")
	j13_helper.j12_helper.mathilde_j11_base_snapshot = j13_helper.j12_helper._build_real_j11_base_snapshot("MATHILDE")
	_exercise_private_discovery("choice_j14_pauline_truth", "TRUTH_LIMITED", false)
	_exercise_private_discovery("choice_j14_pauline_lie", "MINIMIZE_OR_LIE", false)
	_exercise_private_discovery("choice_j14_pauline_defer", "PROTECT_AND_DEFER", true)
	_exercise_public_fallback()
	_exercise_source_selection_matrix()
	_exercise_sandra_marie_presentation()
	_exercise_fail_closed_and_phase_snapshots()
	for failure in j13_helper.failures: failures.append("J13 helper: " + failure)
	for failure in j13_helper.j12_helper.failures: failures.append("J12 helper: " + failure)
	j13_helper.j12_helper.free(); j13_helper.free()
	if failures.is_empty(): print("RUNTIME_S1_14_J14_PLAYABLE: OK"); get_tree().quit(0); return
	for failure in failures: push_error(failure)
	get_tree().quit(1)

func _exercise_private_discovery(choice_id: String, expected_outcome: String, expects_clarification: bool) -> void:
	var state = _completed_j13_state("PAULINE")
	var source_before: Dictionary = state.traces[state.j13_j14_trace_id].duplicate(true)
	var provider = _new_provider(state)
	_expect(bool(provider.start_day().get("accepted", false)) and provider.selected_pivot == "PAULINE", choice_id + " selects the real Pauline trace and Marie")
	_expect(not state.traces.has("j14_discovery_event_01") and not state.knowledge.has("fact_witness_saw_limited_trace"), choice_id + " creates nothing before discovery presentation")
	_expect_state_round_trip(state, choice_id + " selected state")
	_expect_round_trip(provider, choice_id + " to-discovery provider")
	_confirm(provider)
	_expect(state.traces.has("j14_discovery_event_01") and state.knowledge.has("fact_witness_saw_limited_trace"), choice_id + " atomically creates discovery and bounded knowledge")
	_expect(state.traces[state.j13_j14_trace_id] == source_before, choice_id + " never mutates the source trace")
	var discovery: Dictionary = state.traces["j14_discovery_event_01"]
	var fact: Dictionary = state.knowledge["fact_witness_saw_limited_trace"]
	_expect(discovery.get("visible_fields", []) == ["thread_name", "thumbnail"] and str(discovery.get("discovery_mode", "")) == "OPEN_CONVERSATION", choice_id + " records only exact visible fields")
	_expect(str(fact.get("certainty", "")) == "OBSERVED" and str(fact.get("context_certainty", "")) == "INCOMPLETE", choice_id + " does not make Marie omniscient")
	_expect(str(state.promises.get("j14_inform_trace_controller", {}).get("status", "")) == "ACTIVE", choice_id + " creates an unpaid controller notice after exposure")
	_present(provider, "thread_marie_private")
	_expect_round_trip(provider, choice_id + " witness choice")
	_expect(bool(provider.apply_choice("thread_marie_private", choice_id).get("accepted", false)), choice_id + " applies")
	_expect(state.j14_outcome == expected_outcome and state.j14_player_explanation == expected_outcome, choice_id + " stores a stable semantic explanation")
	_expect(state.promises.has("j14_witness_clarification") == expects_clarification, choice_id + " creates only its canonical clarification debt")
	if expects_clarification:
		_expect(str(state.promises["j14_witness_clarification"].get("due_at", "")) == "J14 21:30", choice_id + " records Pauline's precise hour")
	_expect_state_round_trip(state, choice_id + " post-choice state")
	_confirm(provider)
	_expect(provider.phase == "echo_incoming" and str(state.promises["j14_inform_trace_controller"].get("status", "")) == "ACTIVE", choice_id + " does not pay controller before presentation")
	_expect_round_trip(provider, choice_id + " controller incoming")
	_present(provider, "thread_pauline_private")
	_expect(str(state.promises["j14_inform_trace_controller"].get("status", "")) == "PAID" and state.j14_controller_notified, choice_id + " pays controller only after specific message presentation")
	_expect_round_trip(provider, choice_id + " day-close provider")
	_confirm(provider)
	_expect(provider.phase == "complete" and state._j14_records_consistent(state.snapshot()), choice_id + " completes with consistent J15 handoff")
	_expect_state_round_trip(state, choice_id + " completed state")

func _exercise_public_fallback() -> void:
	var state = _completed_j13_state("RESPIRATION")
	var source_before: Dictionary = state.traces[state.j13_j14_trace_id].duplicate(true)
	var provider = _new_provider(state)
	_expect(bool(provider.start_day().get("accepted", false)) and provider.selected_pivot == "FALLBACK", "public-only T14 selects fallback")
	_expect(not state.traces.has("j14_discovery_event_01"), "fallback creates no private discovery before presentation")
	_confirm(provider); _present(provider, "thread_marie_private")
	_expect(bool(provider.apply_choice("thread_marie_private", "choice_j14_fallback_close").get("accepted", false)), "fallback choice applies")
	_expect(provider.phase == "day_close", "fallback schedules no controller")
	_confirm(provider)
	_expect(provider.phase == "complete", "fallback closes cleanly")
	_expect(state.traces[state.j13_j14_trace_id] == source_before, "fallback leaves T14 unchanged")
	_expect(not state.traces.has("j14_discovery_event_01") and not state.knowledge.has("fact_witness_saw_limited_trace") and not state.knowledge.has("fact_player_explanation_to_witness"), "fallback invents no private observation or explanation fact")
	_expect(not state.promises.has("j14_inform_trace_controller") and not state.promises.has("j14_witness_clarification") and state.j14_j15_obligation_id == "", "fallback creates no artificial debt")

func _exercise_fail_closed_and_phase_snapshots() -> void:
	var state = _completed_j13_state("PAULINE")
	_expect_state_round_trip(state, "end J13 before begin J14")
	var legacy_state_snapshot: Dictionary = state.snapshot(); legacy_state_snapshot["version"] = 23
	for key in ["j14_witness_presence_evidence", "j14_discovery_mode", "j14_visible_fields", "j14_source_trace_id", "j14_secondary_trace_id", "j14_player_initial_reaction", "j14_player_explanation", "j14_j15_obligation_id", "j14_controller_notified"]: legacy_state_snapshot.erase(key)
	var migrated_state = STATE.new(); _expect(migrated_state.restore_snapshot(legacy_state_snapshot) and int(migrated_state.snapshot().get("version", -1)) == 24, "R6B end-J13 state migrates to R7A")
	_expect(state.begin_j14(), "phase fixture begins J14")
	_expect_state_round_trip(state, "after begin J14 before selection")
	state.j13_j14_trace_id = "missing_or_inaccessible_trace"
	_expect(state.select_j14_variant() == "", "missing source fails closed")
	var composite = _completed_j13_state("RESPIRATION")
	composite.begin_j14(); composite.j13_j14_trace_id = "j12_laverriere_public_group_set_01"
	_expect(composite.select_j14_variant() == "FALLBACK" and composite.j14_secondary_trace_id == "", "T14 alone cannot fabricate COMPOSITE")
	var legacy_timing_state = _completed_j13_state("PAULINE"); var legacy_provider = _new_provider(legacy_timing_state)
	legacy_provider.start_day(); var legacy_provider_snapshot: Dictionary = legacy_provider.snapshot(); legacy_provider_snapshot["version"] = 2
	_expect(legacy_timing_state.establish_j14_discovery("PAULINE"), "legacy timing fixture contains the old early discovery")
	var migrated_provider = PROVIDER.new(); _expect(migrated_provider.initialize(legacy_timing_state, {}, {}, [], []) and migrated_provider.restore_snapshot(legacy_provider_snapshot), "R6B J14 provider snapshot migrates")
	_expect(not legacy_timing_state.traces.has("j14_discovery_event_01") and not legacy_timing_state.knowledge.has("fact_witness_saw_limited_trace") and not legacy_timing_state.promises.has("j14_inform_trace_controller"), "R6B to-discovery migration rolls back unpresented records")

func _exercise_source_selection_matrix() -> void:
	var pauline_removed = _finish_j13(j13_helper._completed_network_state(true), "PAULINE", "j13_pauline", "choice_j13_pauline_refuse")
	_expect_variant(pauline_removed, "FALLBACK", "Marie", "PUBLIC_ONLY", ["public_image"], "Pauline removed")
	var raphaelle_active = _finish_j13(j13_helper._completed_r5b_j12("FIRST_KISS", "RAPHAELLE", "choice_j12_raphaelle_public", "C12"), "RAPHAELLE", "j13_raphaelle", "choice_j13_raphaelle_process")
	_expect_variant(raphaelle_active, "RAPHAELLE", "Marie", "OPEN_GALLERY_OR_SELECTION", ["thumbnail", "thread_name"], "Raphaëlle active")
	var raphaelle_removed = _finish_j13(j13_helper._completed_r5b_j12("FIRST_KISS", "RAPHAELLE", "choice_j12_raphaelle_public", "C12"), "RAPHAELLE", "j13_raphaelle", "choice_j13_raphaelle_product")
	_expect_variant(raphaelle_removed, "FALLBACK", "Marie", "PUBLIC_ONLY", ["public_image"], "Raphaëlle removed")
	var sandra_active = _finish_j13(j13_helper._completed_r5b_j12("SANDRA_RULE_CLARIFIED", "SANDRA", "choice_j12_sandra_clear", "C12"), "SANDRA", "j13_sandra_clear", "choice_j13_sandra_clear_confirm")
	_expect_variant(sandra_active, "SANDRA", "Marie", "OPEN_CONVERSATION", ["thread_name", "thumbnail"], "Sandra active")
	var sandra_removed = _finish_j13(j13_helper._completed_r5b_j12("SANDRA_RULE_CLARIFIED", "SANDRA", "choice_j12_sandra_clear", "C12"), "SANDRA", "j13_sandra_clear", "choice_j13_sandra_clear_more")
	_expect_variant(sandra_removed, "FALLBACK", "Marie", "PUBLIC_ONLY", ["public_image"], "Sandra removed")
	var mathilde_active = _finish_j13(j13_helper._completed_semantic_j12("MATHILDE_M_B2", "choice_j12_mathilde_m_b2_ack", false), "MATHILDE", "j13_mathilde_m_b2", "choice_j13_mathilde_m_b2_debt")
	_expect_variant(mathilde_active, "MATHILDE", "Marie", "TEXT_NOTIFICATION", ["sender_name", "first_line", "received_at"], "Mathilde physical")
	var mathilde_without_physical = _finish_j13(j13_helper._completed_semantic_j12("MATHILDE_M_B1", "choice_j12_mathilde_m_b1_ack", false), "MATHILDE", "j13_mathilde_m_b1", "choice_j13_mathilde_m_b1_rule")
	_expect_variant(mathilde_without_physical, "FALLBACK", "Marie", "PUBLIC_ONLY", ["public_image"], "Mathilde without physical trace")
	var nico_active = _finish_j13(j13_helper._completed_r5b_j12("NICO_GUARDRAIL_HELD", "NICO", "choice_j12_nico_accept", "B12"), "NICO", "j13_nico_guardrail", "choice_j13_nico_guardrail_truth")
	_expect_variant(nico_active, "NICO", "Marie", "TEXT_NOTIFICATION", ["sender_name", "first_line", "received_at"], "Nico exact message")

func _exercise_sandra_marie_presentation() -> void:
	var state = _finish_j13(j13_helper._completed_r5b_j12("SANDRA_RULE_CLARIFIED", "SANDRA", "choice_j12_sandra_clear", "C12"), "SANDRA", "j13_sandra_clear", "choice_j13_sandra_clear_confirm")
	var provider = _new_provider(state); provider.start_day(); _confirm(provider)
	var witness_messages: Array = provider.transcript_for("thread_marie_private").filter(func(message): return int(message.get("source_day", 0)) == 14 and not bool(message.get("is_player", false)))
	_expect(not witness_messages.is_empty() and str(witness_messages[0].get("author_id", "")) == "marie", "Sandra route presents to the proved Marie witness")
	_present(provider, "thread_marie_private"); provider.apply_choice("thread_marie_private", "choice_j14_sandra_defer")
	_expect(str(state.promises["j14_witness_clarification"].get("witness_id", "")) == "Marie" and str(state.promises["j14_witness_clarification"].get("action_due", "")).contains("répondre à Marie"), "Sandra defer addresses its actual witness")
	_confirm(provider)
	var controller_notice: Dictionary = {}
	for message in provider.transcript_for("thread_sandra_private"):
		if str(message.get("message_id", "")) == "msg_j14_controller_sandra_001": controller_notice = message
	_expect(str(controller_notice.get("text", "")).contains("Marie") and not str(controller_notice.get("text", "")).contains("Mathilde"), "Sandra controller notice names the actual witness")
	_present(provider, "thread_sandra_private"); _confirm(provider)
	_expect(provider.phase == "complete", "Sandra Marie route completes after specific notice")

func _finish_j13(state, pivot: String, segment_id: String, choice_id: String):
	_expect(state.begin_j13() and state.set_j13_priority(pivot) and state.deliver_j13_priority(pivot, segment_id) and state.apply_j13_choice(choice_id, pivot) and state.complete_j13(), pivot + " route completes J13")
	return state

func _expect_variant(state, variant: String, witness: String, mode: String, fields: Array, label: String) -> void:
	_expect(state.begin_j14(), label + " begins J14")
	_expect(state.select_j14_variant() == variant, label + " selects " + variant)
	_expect(state.j14_witness == witness and state.j14_witness_presence_evidence != "", label + " proves exact witness presence")
	_expect(state.j14_discovery_mode == mode and state.j14_visible_fields == fields, label + " records exact bounded visibility")
	_expect(state.j14_variant == "FALLBACK" or state.j14_witness != "", label + " never has an empty private witness")
	_expect_state_round_trip(state, label + " selected state")
	if variant == "FALLBACK": return
	var source_before: Dictionary = state.traces[state.j14_source_trace_id].duplicate(true)
	_expect(state.establish_j14_discovery(variant), label + " presents one atomic discovery")
	_expect(state.traces[state.j14_source_trace_id] == source_before, label + " preserves its source")
	var discovered_snapshot: Dictionary = state.snapshot()
	var expected_controller := str({"PAULINE":"Pauline", "SANDRA":"Sandra", "MATHILDE":"Mathilde", "RAPHAELLE":"Raphaëlle", "NICO":"Nico"}[variant])
	for posture in [{"suffix":"truth", "outcome":"TRUTH_LIMITED"}, {"suffix":"lie", "outcome":"MINIMIZE_OR_LIE"}, {"suffix":"defer", "outcome":"PROTECT_AND_DEFER"}]:
		var branch = STATE.new(); _expect(branch.restore_snapshot(discovered_snapshot), label + " " + posture.outcome + " restores discovery")
		var choice_id := "choice_j14_" + variant.to_lower() + "_" + str(posture.suffix)
		_expect(branch.apply_j14_choice(choice_id, variant), label + " " + posture.outcome + " applies")
		_expect(branch.j14_outcome == posture.outcome and branch.j14_player_explanation == posture.outcome, label + " stores " + posture.outcome)
		_expect(str(branch.promises["j14_inform_trace_controller"].get("controller", "")) == expected_controller and str(branch.promises["j14_inform_trace_controller"].get("status", "")) == "ACTIVE", label + " addresses the exact unpaid controller")
		var expects_debt: bool = str(posture.outcome) == "PROTECT_AND_DEFER" and variant != "NICO"
		_expect(branch.promises.has("j14_witness_clarification") == expects_debt, label + " creates only the exact clarification debt")
		if posture.outcome == "MINIMIZE_OR_LIE": _expect(str(branch.knowledge["fact_player_explanation_to_witness"].get("lie_or_minimization", "")) != "", label + " records a precise lie or minimization")
		_expect(branch.resolve_j14_controller_informed() and branch.complete_j14(), label + " " + posture.outcome + " closes after controller presentation")
		_expect(branch.traces[branch.j14_source_trace_id] == source_before and branch._j14_records_consistent(branch.snapshot()), label + " " + posture.outcome + " keeps consistent immutable records")

func _completed_j13_state(pivot: String):
	var state = j13_helper._completed_network_state(pivot == "PAULINE")
	_expect(state.begin_j13(), "fixture enters J13"); _expect(state.set_j13_priority(pivot), "fixture selects J13 pivot")
	var choice := "choice_j13_pauline_rule" if pivot == "PAULINE" else "choice_j13_respiration_bread"
	_expect(state.deliver_j13_priority(pivot, "j13_pauline" if pivot == "PAULINE" else "j13_respiration"), "fixture delivers J13 consequence")
	_expect(state.apply_j13_choice(choice, pivot), "fixture resolves J13 pivot"); _expect(state.complete_j13(), "fixture completes J13")
	return state

func _new_provider(state):
	var provider = PROVIDER.new(); _expect(provider.initialize(state, {}, {}, [], []), "J14 provider initializes"); return provider
func _present(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 14 and not bool(message.get("is_player", false)) and not provider.presented_time_message_ids.has(str(message.get("message_id", ""))): provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "batch presents for " + thread_id)
func _confirm(provider) -> void:
	var target_text := str(provider.pending_transition.get("to_time", ""))
	if target_text != "":
		var target := TIME.parse_narrative_time(target_text)
		if target >= provider.current_narrative_time_minutes(): provider.commit_narrative_time(target)
	_expect(bool(provider.confirm_transition().get("accepted", false)), "transition confirms")
func _expect_round_trip(provider, label: String) -> void:
	var snap: Dictionary = provider.snapshot(); var restored = PROVIDER.new(); _expect(restored.initialize(provider.state, {}, {}, [], []), label + " initializes"); _expect(restored.restore_snapshot(snap), label + " restores"); _expect(restored.snapshot() == snap, label + " is exact")
func _expect_state_round_trip(state, label: String) -> void:
	var snap: Dictionary = state.snapshot(); var restored = STATE.new(); var accepted := restored.restore_snapshot(snap)
	if not accepted:
		var checks: Array[String] = ["_j05_snapshot_consistent", "_j06_snapshot_consistent", "_j07_records_consistent", "_j08_records_consistent", "_j09_records_consistent", "_j10_records_consistent", "_j11_records_consistent", "_j12_records_consistent", "_j13_records_consistent", "_j14_records_consistent", "_j15_records_consistent", "_j16_records_consistent", "_j17_records_consistent", "_j18_records_consistent", "_j19_records_consistent", "_j20_records_consistent", "_j21_records_consistent"]
		var failed_checks: Array[String] = []
		for check in checks:
			if not bool(state.call(check, snap)): failed_checks.append(check)
		failures.append(label + " failed consistency: " + str(failed_checks))
	_expect(accepted, label + " restores"); _expect(accepted and restored.snapshot() == snap, label + " is exact")
func _expect(condition: bool, label: String) -> void:
	if not condition: failures.append(label)
