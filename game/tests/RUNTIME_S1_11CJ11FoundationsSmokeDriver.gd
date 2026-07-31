extends Node

const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J09_PROVIDER := preload("res://scripts/runtime/season_1/J09RuntimeProvider.gd")
const J10_PROVIDER := preload("res://scripts/runtime/season_1/J10RuntimeProvider.gd")
const J11_PROVIDER := preload("res://scripts/runtime/season_1/J11RuntimeProvider.gd")
const J11_SELECTOR := preload("res://scripts/runtime/season_1/J11ContinuationSelector.gd")
const J09_SMOKE := preload("res://tests/RUNTIME_S1_09J09PlayableSmokeDriver.gd")
const J10_SMOKE := preload("res://tests/RUNTIME_S1_10J10PlayableSmokeDriver.gd")

var failures: Array[String] = []

func _ready() -> void:
	_exercise_selector_22_of_22()
	_exercise_p10_p11_and_aftercare()
	_exercise_real_j10_to_j11_foundation_round_trip()
	if failures.is_empty():
		print("RUNTIME_S1_11C_FOUNDATIONS: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)

func _exercise_selector_22_of_22() -> void:
	var expected := {
		"SANDRA": {
			"CAFE_HELD_CALM_PRESENCE": "RESPIRATION", "CAFE_HELD_MISSING_NAMED": "SANDRA",
			"CAFE_HELD_FRIENDSHIP_BOUNDED": "RESPIRATION", "CAFE_SATURDAY_CONDITIONAL": "RESPIRATION",
			"CAFE_OPPORTUNITY_CLOSED": "RESPIRATION",
		},
		"MATHILDE": {
			"OUTFIT_PRECISE_NON_APPROPRIATIVE": "MATHILDE", "OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED": "MATHILDE",
			"OUTFIT_PRACTICAL_WEATHER": "RESPIRATION",
		},
		"RAPHAELLE": {
			"PROCESS_HELPED_VISIT_BOUNDED": "RAPHAELLE", "PROCESS_HELPED_REMOTE": "RAPHAELLE",
			"RESULT_ONLY": "RAPHAELLE", "PROFESSIONAL_BOUNDARY": "RESPIRATION",
		},
		"NICO": {
			"DIFFERENCE_ACKNOWLEDGED_NO_IMAGE": "NICO", "NICO_OBSERVATION_REQUESTED": "NICO",
			"COMPARISON_CLOSED": "RESPIRATION", "THURSDAY_MEETING_CANCELLED": "RESPIRATION",
		},
		"NONE": {
			"DUE_DINNER_PAID": "MARIE", "DUE_DINNER_FAILED_LATE": "MARIE", "DUE_DINNER_CANCELLED": "MARIE",
			"ORDINARY_MEAL_JOINED": "MARIE", "LATE_RETURN_SEPARATE": "MARIE", "ABSENCE_ANNOUNCED": "MARIE",
		},
	}
	var selector = J11_SELECTOR.new()
	var count := 0
	for source_pivot in expected:
		for source_outcome in expected[source_pivot]:
			var fixture := {"j10_pivot": source_pivot, "j10_pivot_outcome": source_outcome, "obligations": {}}
			var before: Dictionary = fixture.duplicate(true)
			var first: Dictionary = selector.select(fixture)
			_expect(fixture == before, "selector mutated " + source_pivot + "/" + source_outcome)
			_expect(first == selector.select(fixture), "selector is not deterministic for " + source_pivot + "/" + source_outcome)
			_expect(str(first.get("pivot", "")) == str(expected[source_pivot][source_outcome]), "wrong continuation for " + source_pivot + "/" + source_outcome)
			count += 1
	_expect(count == 22, "selector matrix does not contain 22 outcomes")
	_expect(selector.select({"j10_pivot": "NONE", "j10_pivot_outcome": "UNKNOWN"}).is_empty(), "unknown outcome must fail closed")

func _exercise_p10_p11_and_aftercare() -> void:
	var p10 = SEASON_STATE.new()
	p10.current_day = "J11"; p10.day_status = "ACTIVE"
	p10.promises["marie_j09_dinner_friday_2030"] = {"status": "ACTIVE", "due_at": "J11 20:30"}
	_expect(p10.apply_j11_p10_choice("choice_j11_p10_maintain"), "P10 maintain applies")
	_expect(str(p10.promises["marie_j09_dinner_friday_2030"].get("status", "")) == "ACTIVE", "maintained P10 stays active")
	_expect(p10.pay_j11_p10(), "maintained P10 pays")
	_expect(str(p10.promises["marie_j09_dinner_friday_2030"].get("status", "")) == "PAID", "maintained P10 becomes PAID")
	var late = SEASON_STATE.new()
	late.current_day = "J11"; late.day_status = "ACTIVE"
	late.promises["marie_j09_dinner_friday_2030"] = {"status": "ACTIVE", "due_at": "J11 20:30"}
	_expect(late.apply_j11_p10_choice("choice_j11_p10_late") and late.pay_j11_p10(), "late P10 resolves")
	_expect(str(late.promises["marie_j09_dinner_friday_2030"].get("status", "")) == "FAILED", "late P10 becomes FAILED")
	var p11 = SEASON_STATE.new()
	p11.current_day = "J11"; p11.day_status = "ACTIVE"
	p11.promises["sandra_cafe_saturday_1100"] = {"status": "CONDITIONAL"}
	_expect(p11.confirm_or_expire_j11_p11_counterparty(true), "Sandra counterparty confirmation applies")
	_expect(str(p11.promises["sandra_cafe_saturday_1100"].get("status", "")) == "CONDITIONAL", "P11 remains CONDITIONAL in J11")
	_expect(str(p11.promises["sandra_cafe_saturday_1100"].get("counterparty_confirmed_by", "")) == "Sandra", "P11 stores Sandra confirmation")
	var mathilde = SEASON_STATE.new()
	mathilde.current_day = "J11"; mathilde.day_status = "ACTIVE"; mathilde.j11_pivot = "MATHILDE"
	_expect(mathilde.configure_j11_mathilde_safety(true, true, true), "Mathilde safety proofs store")
	_expect(mathilde.establish_j11_mathilde_physical_event("MATHILDE_M_B3", true), "Mathilde M-B3 establishes")
	_expect(mathilde.traces.has("j11_mathilde_physical_aftercare_01") and mathilde.knowledge.has("fact_mathilde_physical_event_occurred"), "Mathilde trace/fact pair is atomic")
	_expect(str(mathilde.obligations.get("aftercare_mathilde_j11", {}).get("status", "")) == "DUE", "Mathilde aftercare is DUE")
	_expect(mathilde.resolve_j11_aftercare("aftercare_mathilde_j11", "FAILED", "Player"), "Mathilde failed aftercare resolves")
	var raphaelle = SEASON_STATE.new()
	raphaelle.current_day = "J11"; raphaelle.day_status = "ACTIVE"; raphaelle.j11_pivot = "RAPHAELLE"
	raphaelle.j10_pivot_outcome = "PROCESS_HELPED_VISIT_BOUNDED"
	_expect(raphaelle.establish_j11_raphaelle_result(), "Raphaelle result trace/fact establishes after real send")
	_expect(not raphaelle.set_j11_raphaelle_outcome("FIRST_KISS"), "Raphaelle kiss fails closed without ordered proofs")
	_expect(raphaelle.set_j11_raphaelle_outcome("FIRST_KISS", true, true, true), "Raphaelle kiss accepts ordered attraction, consent and meeting proofs")
	var blocked_raphaelle = SEASON_STATE.new()
	blocked_raphaelle.current_day = "J11"; blocked_raphaelle.day_status = "ACTIVE"; blocked_raphaelle.j11_pivot = "RAPHAELLE"
	blocked_raphaelle.j10_pivot_outcome = "PROCESS_HELPED_VISIT_BOUNDED"
	blocked_raphaelle.promises["marie_j09_dinner_friday_2030"] = {"status": "PAID", "j11_resolution": "MAINTAINED"}
	blocked_raphaelle.establish_j11_raphaelle_result()
	_expect(not blocked_raphaelle.set_j11_raphaelle_outcome("FIRST_KISS", true, true, true), "maintained P10 closes external physical branch")
	var marie = SEASON_STATE.new()
	marie.current_day = "J11"; marie.day_status = "ACTIVE"; marie.j11_pivot = "MARIE"
	marie.j10_pivot = "NONE"; marie.j10_pivot_outcome = "ORDINARY_MEAL_JOINED"
	_expect(marie.establish_j11_marie_adult_event(true, true), "Marie adult event establishes only after current reconquest and consent")
	_expect(str(marie.obligations.get("aftercare_marie_j11", {}).get("status", "")) == "DUE", "Marie aftercare is DUE")
	_expect(not marie.traces.has("j11_marie_adult_event"), "Marie adult event creates no diegetic trace")

func _exercise_real_j10_to_j11_foundation_round_trip() -> void:
	var j09_helper = J09_SMOKE.new()
	var j10_helper = J10_SMOKE.new()
	var j09 = j10_helper._completed_j09_provider(j09_helper, "choice_j09_dinner_refuse")
	var j10 = J10_PROVIDER.new()
	_expect(j10.initialize(j09.state, j09.transcripts_by_thread, j09.produced_message_ids, j09.unlocked_thread_ids, j09.gallery_asset_ids), "real J10 fixture initializes")
	j10.start_day()
	j10_helper._confirm_transition_monotonic(j10)
	j10_helper._present_batch(j10, "thread_marie_private")
	j10.apply_choice("thread_marie_private", "choice_j10_fallback_join")
	j10_helper._confirm_transition_monotonic(j10)
	_expect(j10.phase == "complete" and j10.state.day_status == "COMPLETE", "real J10 fixture completes")
	var j11 = J11_PROVIDER.new()
	_expect(j11.initialize(j10.state, j10.transcripts_by_thread, j10.produced_message_ids, j10.unlocked_thread_ids, j10.gallery_asset_ids), "J11 foundation initializes")
	var start: Dictionary = j11.start_day()
	_expect(bool(start.get("accepted", false)), "J10 hands off to J11 foundation")
	_expect(j11.state.current_day == "J11" and j11.state.j11_pivot == "MARIE", "J11 selects Marie from ordinary meal")
	var state_snapshot: Dictionary = j11.state.snapshot()
	var provider_snapshot: Dictionary = j11.snapshot()
	var restored_state = SEASON_STATE.new()
	_expect(restored_state.restore_snapshot(state_snapshot), "J11 state snapshot restores")
	var restored = J11_PROVIDER.new()
	_expect(restored.initialize(restored_state, {}, {}, [], []), "restored J11 provider initializes")
	_expect(restored.restore_snapshot(provider_snapshot), "J11 provider snapshot restores")
	_expect(restored_state.snapshot() == state_snapshot and restored.snapshot() == provider_snapshot, "J11 state/provider round trip is exact")
	for failure in j09_helper.failures:
		failures.append("J09 helper: " + failure)
	for failure in j10_helper.failures:
		failures.append("J10 helper: " + failure)
	j09_helper.free(); j10_helper.free()

func _expect(condition: bool, label: String) -> void:
	if not condition:
		failures.append(label)
