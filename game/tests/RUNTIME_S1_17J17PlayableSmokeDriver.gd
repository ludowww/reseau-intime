extends Node

const S := preload("res://scripts/runtime/season_1/Season1State.gd")
const P := preload("res://scripts/runtime/season_1/J17RuntimeProvider.gd")
const T := preload("res://scripts/runtime/season_1/NarrativeTime.gd")

var failures: Array[String] = []

func _ready() -> void:
	_test_eight_rules_and_six_states()
	_test_invalid_inputs_do_not_mutate()
	_test_derived_formulas_and_guard_priority()
	_test_record_and_idempotence()
	_test_provider_micro_returns_and_round_trip()
	if failures.is_empty():
		print("RUNTIME_S1_17_J17_PLAYABLE: OK")
		get_tree().quit(0)
		return
	for failure in failures: push_error(failure)
	get_tree().quit(1)

func _test_eight_rules_and_six_states() -> void:
	_expect_state(_base_state(true), "choice_j17_separation", "SEPARATION", "rule 1 separation")
	_expect_state(_base_state(false), "choice_j17_refused_acknowledge", "FRACTURE", "rule 2 refused")
	var refused_with_history: RefCounted = _severe_violation_state("choice_j17_refused_acknowledge")
	refused_with_history.j16_j17_outcome = "REFUSE"
	refused_with_history.promises.erase("marie_j16_couple_conversation_j17")
	_expect_state(refused_with_history, "choice_j17_refused_acknowledge", "FRACTURE", "rule 2 precedes guards")
	_expect(refused_with_history.traces["j17_couple_definition_record_01"].triggered_guard_fact_ids.is_empty(), "rule 2 has no triggered guard facts")
	_expect_state(_severe_violation_state("choice_j17_reconquest"), "choice_j17_reconquest", "FRACTURE", "rule 3 reconquest severe")
	_expect_state(_severe_violation_state("choice_j17_provisional"), "choice_j17_provisional", "FRACTURE", "rule 3 provisional severe")
	var hidden: RefCounted = _hidden_material_state()
	_expect_state(hidden, "choice_j17_reconquest", "DOUBLE_LIFE_FRAGILE", "rule 4 hidden material")
	var incompatible: RefCounted = _incompatible_version_state()
	_expect_state(incompatible, "choice_j17_provisional", "DOUBLE_LIFE_FRAGILE", "rule 4 incompatible version")
	var reconquest: RefCounted = _base_state(true)
	_add_repeated_marie_acts(reconquest)
	_expect_state(reconquest, "choice_j17_reconquest", "RECONQUEST_ACTIVE", "rule 5 reconquest")
	_expect_state(_base_state(true), "choice_j17_reconquest", "PROVISIONAL_AGREEMENT", "rule 6 reconquest fallback")
	var reconfiguration: RefCounted = _base_state(true)
	reconfiguration.j11_pivot = "SANDRA"
	reconfiguration.j11_pivot_outcome = "SANDRA_DESIRE_BOUNDED"
	_expect_state(reconfiguration, "choice_j17_provisional", "RECONFIGURATION_NEGOTIATION", "rule 7 reconfiguration")
	_expect_state(_base_state(true), "choice_j17_provisional", "PROVISIONAL_AGREEMENT", "rule 8 provisional fallback")

func _test_invalid_inputs_do_not_mutate() -> void:
	var due: RefCounted = _base_state(true)
	var before: Dictionary = due.snapshot()
	_expect(not due.apply_j17_couple_choice("choice_j17_unknown", "J17 20:30", true), "unknown choice rejected")
	_expect(due.snapshot() == before, "unknown choice no mutation")
	_expect(not due.apply_j17_couple_choice("choice_j17_refused_acknowledge", "J17 20:30", true), "refused choice rejected when due")
	_expect(due.snapshot() == before, "invalid refused no mutation")
	var not_due: RefCounted = _base_state(false)
	before = not_due.snapshot()
	_expect(not not_due.apply_j17_couple_choice("choice_j17_reconquest", "J17 20:30", true), "due-only choice rejected")
	_expect(not_due.snapshot() == before, "due-only choice no mutation")
	var incomplete: RefCounted = _base_state(true)
	incomplete.j15_outcome = "UNESTABLISHED"
	before = incomplete.snapshot()
	_expect(not incomplete.apply_j17_couple_choice("choice_j17_provisional", "J17 20:30", true), "unestablished input rejected")
	_expect(incomplete.snapshot() == before, "unestablished input no mutation")

func _test_derived_formulas_and_guard_priority() -> void:
	var clean: RefCounted = _base_state(true)
	_expect(clean.j17_sufficient_truth_proven(), "sufficient truth true")
	_expect(clean.j17_no_active_violation(), "no active violation true")
	var severe: RefCounted = _severe_violation_state("choice_j17_reconquest")
	_expect(severe.j17_sufficient_truth_proven(), "severe violation does not falsify sufficient truth alone")
	_expect(not severe.j17_no_active_violation(), "severe violation falsifies no-active-violation")
	_add_repeated_marie_acts(severe)
	_expect_state(severe, "choice_j17_reconquest", "FRACTURE", "severe guard beats constructive conditions")
	var hidden: RefCounted = _hidden_material_state()
	_add_repeated_marie_acts(hidden)
	_expect(not hidden.j17_sufficient_truth_proven(), "hidden fact falsifies sufficient truth")
	_expect(not hidden.j17_no_active_violation(), "hidden fact falsifies no-active-violation")
	_expect_state(hidden, "choice_j17_reconquest", "DOUBLE_LIFE_FRAGILE", "hidden guard beats constructive conditions")
	var incompatible: RefCounted = _incompatible_version_state()
	incompatible.j11_pivot = "SANDRA"
	incompatible.j11_pivot_outcome = "SANDRA_DESIRE_BOUNDED"
	_expect(not incompatible.j17_sufficient_truth_proven(), "incompatible version falsifies sufficient truth")
	_expect(not incompatible.j17_no_active_violation(), "incompatible version falsifies no-active-violation")
	_expect_state(incompatible, "choice_j17_provisional", "DOUBLE_LIFE_FRAGILE", "incompatible guard beats constructive conditions")

func _test_record_and_idempotence() -> void:
	var state: RefCounted = _hidden_material_state()
	_expect(state.apply_j17_couple_choice("choice_j17_reconquest", "J17 20:30", true), "record resolution accepted")
	var record: Dictionary = state.traces.get("j17_couple_definition_record_01", {})
	var expected_keys := ["trace_id", "record_type", "source_day", "choice_id", "couple_state", "discussion_was_due", "triggered_guard_fact_ids", "satisfied_constructive_condition_ids", "mathilde_micro_return_delivered", "marie_micro_return_delivered", "temporal_projection", "current_state", "visual_asset"]
	_expect(record.size() == expected_keys.size(), "record closed key count")
	for key in expected_keys: _expect(record.has(key), "record key " + key)
	_expect(record.choice_id == "choice_j17_reconquest", "record exact choice")
	_expect(record.couple_state == "DOUBLE_LIFE_FRAGILE", "record derived state")
	_expect(record.triggered_guard_fact_ids == ["fact_mathilde_physical_event_occurred", "choice_j11_mathilde_m_b2_hold"], "record decisive facts")
	_expect(record.satisfied_constructive_condition_ids.has("J17_CONCRETE_RULE_PROVEN"), "record constructive proof")
	_expect(record.temporal_projection == {"day_id":"J17", "departure_at":"J17 17:30", "couple_discussion_due_at":"J17 20:30–21:30", "resolved_at":"J17 20:30"}, "record temporal projection")
	_expect(not record.has("route_points") and not record.has("consent_score") and not record.has("relationship_score"), "record has no score")
	_expect(state._j17_records_consistent(state.snapshot()), "record validator accepts closed record")
	var stable: Dictionary = state.snapshot()
	_expect(not state.apply_j17_couple_choice("choice_j17_reconquest", "J17 20:30", true), "repeated resolution rejected")
	_expect(state.snapshot() == stable, "repeated resolution stable")
	_expect(state.mark_j17_marie_micro_return_delivered(), "marie marker first delivery")
	stable = state.snapshot()
	_expect(not state.mark_j17_marie_micro_return_delivered(), "marie marker second delivery rejected")
	_expect(state.snapshot() == stable, "marie marker stable")

func _test_provider_micro_returns_and_round_trip() -> void:
	var state: RefCounted = _base_state(true)
	state.current_day = "J16"
	state.day_status = "COMPLETE"
	state.j17_departure_outcome = "UNESTABLISHED"
	state.knowledge.erase("fact_mathilde_left_household")
	var provider := P.new()
	_expect(provider.initialize(state, {}, {}, [], []), "provider init")
	_expect(provider.start_day().get("accepted", false), "provider start")
	_confirm_transition(provider, "departure transition")
	_present(provider, "thread_mathilde_private")
	var departure: Dictionary = provider.apply_choice("thread_mathilde_private", "choice_j17_help")
	_expect(departure.get("accepted", false), "provider departure choice")
	_expect(_count_prefix(provider.transcript_for("thread_mathilde_private"), "msg_j17_mathilde_micro_") == 1, "mathilde micro once")
	_confirm_transition(provider, "couple transition")
	_present(provider, "thread_marie_private")
	var couple: Dictionary = provider.apply_choice("thread_marie_private", "choice_j17_provisional")
	_expect(couple.get("accepted", false), "provider couple choice")
	_expect(state.couple_state == "PROVISIONAL_AGREEMENT", "provider derived state")
	_expect(_count_prefix(provider.transcript_for("thread_marie_private"), "msg_j17_marie_micro_") == 1, "marie micro once")
	var record: Dictionary = state.traces.get("j17_couple_definition_record_01", {})
	_expect(record.get("mathilde_micro_return_delivered", false), "mathilde marker recorded")
	_expect(record.get("marie_micro_return_delivered", false), "marie marker recorded")
	var mathilde_index := _first_prefix_index(provider.transcript_for("thread_mathilde_private"), "msg_j17_mathilde_micro_")
	var marie_index := _first_prefix_index(provider.transcript_for("thread_marie_private"), "msg_j17_marie_micro_")
	_expect(mathilde_index >= 0 and marie_index >= 0, "micro returns present in existing threads")
	var saved: Dictionary = provider.snapshot()
	var record_saved: Dictionary = record.duplicate(true)
	var restored := P.new()
	_expect(restored.initialize(state, {}, {}, [], []), "provider restore init")
	_expect(restored.restore_snapshot(saved), "provider restore")
	_expect(restored.snapshot() == saved, "provider exact round trip")
	_expect(state.traces.get("j17_couple_definition_record_01", {}) == record_saved, "record stable through provider round trip")
	_expect(_count_prefix(restored.transcript_for("thread_mathilde_private"), "msg_j17_mathilde_micro_") == 1, "mathilde micro stable after restore")
	_expect(_count_prefix(restored.transcript_for("thread_marie_private"), "msg_j17_marie_micro_") == 1, "marie micro stable after restore")
	_confirm_transition(restored, "day close transition")
	_expect(restored.phase == "complete" and state.day_status == "COMPLETE", "provider complete")
	_expect(state.couple_state == "PROVISIONAL_AGREEMENT", "micro returns do not recalculate state")
	_expect(state._j17_records_consistent(state.snapshot()), "completed provider record consistent")

func _base_state(discussion_due: bool) -> RefCounted:
	var state: RefCounted = S.new()
	state.current_day = "J17"
	state.day_status = "ACTIVE"
	state.couple_state = "STRAIN_VISIBLE"
	state.j14_variant = "S27_MUTATION_NO_DISCOVERY"
	state.j14_outcome = "S27_MUTATION_NO_DISCOVERY"
	state.j15_mode = "NO_OBLIGATION"
	state.j15_outcome = "CLEAN_ACKNOWLEDGE"
	state.j16_priority = "FALLBACK"
	state.j16_consequence_outcome = "FALLBACK_CONFIRM"
	state.j16_departure_state = "ORDINARY"
	state.j16_j17_outcome = "ACCEPT" if discussion_due else "REFUSE"
	state.j17_departure_outcome = "HELP"
	state.j17_couple_outcome = "UNESTABLISHED"
	state.knowledge["fact_mathilde_left_household"] = {"fact_id":"fact_mathilde_left_household", "source_ref":"choice_j17_help"}
	state.traces["j16_consequence_payment_record_01"] = {"consequence_outcome":"DIRECT_TO_MATHILDE_MARIE_J17_PREPARATION"}
	if discussion_due: state.promises["marie_j16_couple_conversation_j17"] = {"status":"ACTIVE"}
	else: state.promises.erase("marie_j16_couple_conversation_j17")
	return state

func _severe_violation_state(_choice_id: String) -> RefCounted:
	var state: RefCounted = _base_state(true)
	state.j14_variant = "MATHILDE"
	state.j14_outcome = "TRUTH_LIMITED"
	state.j14_witness = "Marie"
	state.traces["j14_discovery_event_01"] = {"discovered_trace_id":"j11_mathilde_physical_aftercare_01"}
	state.knowledge["fact_witness_saw_limited_trace"] = {"source_ref":"j14_discovery_event_01", "witness_id":"Marie", "current_knowers":["Marie", "Player"], "discovered_trace_id":"j11_mathilde_physical_aftercare_01"}
	state.promises["j14_inform_trace_controller"] = {"status":"FAILED"}
	state.knowledge["fact_trace_controller_not_informed"] = {"source_ref":"j14_inform_trace_controller"}
	return state

func _hidden_material_state() -> RefCounted:
	var state: RefCounted = _base_state(true)
	state.j11_pivot = "MATHILDE"
	state.j11_pivot_outcome = "MATHILDE_M_B2"
	state.j11_physical_level = "MATHILDE_M_B2"
	state.selected_choice_ids.append("choice_j11_mathilde_m_b2_hold")
	state.knowledge["fact_mathilde_physical_event_occurred"] = {"physical_level":"MATHILDE_M_B2"}
	state.obligations["aftercare_mathilde_j11"] = {"status":"PAID"}
	return state

func _incompatible_version_state() -> RefCounted:
	var state: RefCounted = _base_state(true)
	state.j15_mode = "OPEN_CLARIFICATION"
	state.j15_outcome = "OPEN_LIE"
	state.j16_priority = "MATHILDE"
	state.j16_consequence_outcome = "MATHILDE_CONTEST"
	state.promises["j16_priority_consequence_payment"] = {"status":"FAILED"}
	state.traces["j16_consequence_payment_record_01"] = {"consequence_outcome":"CONSEQUENCE_FAILED"}
	return state

func _add_repeated_marie_acts(state: RefCounted) -> void:
	state.promises["marie_j01_shared_evening"] = {"status":"PAID"}
	state.marie_j08_household_resolution = "PAID"
	state.promises["marie_j07_household_request"] = {"status":"PAID"}

func _expect_state(state: RefCounted, choice_id: String, expected_state: String, label: String) -> void:
	_expect(state.apply_j17_couple_choice(choice_id, "J17 20:30", true), label + " accepted")
	_expect(state.couple_state == expected_state, label + " state")
	var record: Dictionary = state.traces.get("j17_couple_definition_record_01", {})
	_expect(record.get("couple_state", "") == expected_state, label + " record")

func _present(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 17 and not message.get("is_player", false): provider.mark_message_presented(str(message.message_id))
	_expect(provider.mark_thread_batch_presented(thread_id), "present " + thread_id)

func _confirm_transition(provider, label: String) -> void:
	var target := T.parse_narrative_time(str(provider.pending_transition.get("to_time", "")))
	if target >= provider.current_narrative_time_minutes(): provider.commit_narrative_time(target)
	_expect(provider.confirm_transition().get("accepted", false), label)

func _count_prefix(transcript: Array, prefix: String) -> int:
	var count := 0
	for message in transcript:
		if str(message.get("message_id", "")).begins_with(prefix): count += 1
	return count

func _first_prefix_index(transcript: Array, prefix: String) -> int:
	for index in range(transcript.size()):
		if str(transcript[index].get("message_id", "")).begins_with(prefix): return index
	return -1

func _expect(value: bool, label: String) -> void:
	if not value: failures.append(label)
