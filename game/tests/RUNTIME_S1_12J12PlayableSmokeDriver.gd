extends Node

const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J12_PROVIDER := preload("res://scripts/runtime/season_1/J12RuntimeProvider.gd")
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")

const MARIE_THREAD := "thread_marie_private"
const SANDRA_THREAD := "thread_sandra_private"
const MATHILDE_THREAD := "thread_mathilde_private"
const NICO_THREAD := "thread_nico_private"
const LAVERRIERE_THREAD := "thread_laverriere_group"
const ANNEXE_THREAD := "thread_annexe_group"

var failures: Array[String] = []

func _ready() -> void:
	_exercise_sandra_p11_and_public_audience()
	_exercise_failed_mathilde_aftercare_precedes_convergence()
	_exercise_nico_annexe_guardrail()
	if failures.is_empty():
		print("RUNTIME_S1_12_J12_PLAYABLE: OK")
		get_tree().quit(0)
		return
	for failure in failures: push_error(failure)
	get_tree().quit(1)

func _exercise_sandra_p11_and_public_audience() -> void:
	var state = _completed_j11_state("SANDRA")
	state.promises["sandra_cafe_saturday_1100"] = {"promise_id":"sandra_cafe_saturday_1100","status":"CONDITIONAL","counterparty_confirmed_at":"J11 17:44","counterparty_confirmed_by":"Sandra"}
	var provider = _new_provider(state)
	_expect(bool(provider.start_day().get("accepted", false)) and provider.phase == "p11_incoming", "P11 confirmation opens before convergence")
	_present_batch(provider, SANDRA_THREAD)
	_expect(bool(provider.apply_choice(SANDRA_THREAD, "choice_j12_p11_confirm").get("accepted", false)), "P11 accepts only after Player confirmation")
	_confirm_transition(provider)
	_present_batch(provider, SANDRA_THREAD)
	_confirm_transition(provider)
	_present_batch(provider, MARIE_THREAD)
	_expect_round_trip(provider, "J12 plan choice")
	provider.apply_choice(MARIE_THREAD, "choice_j12_presence_la")
	_confirm_transition(provider)
	_present_batch(provider, LAVERRIERE_THREAD)
	_present_batch(provider, SANDRA_THREAD)
	provider.apply_choice(SANDRA_THREAD, "choice_j12_sandra_clear")
	_confirm_transition(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j12_annexe_a12")
	_confirm_transition(provider)
	_present_batch(provider, ANNEXE_THREAD)
	_confirm_transition(provider)
	_present_batch(provider, SANDRA_THREAD)
	_confirm_transition(provider)
	_expect(provider.phase == "complete", "Sandra path completes J12")
	_expect(str(state.promises["sandra_cafe_saturday_1100"].get("status", "")) == "PAID", "P11 is paid after the off-phone meeting")
	_expect(state.traces.has("j12_laverriere_public_group_set_01") and state.traces.has("j12_annexe_public_group_set_01"), "both canonical public traces persist")
	_expect(state.j12_priority_route == "SANDRA", "only Sandra consequence is foreground for J13")

func _exercise_failed_mathilde_aftercare_precedes_convergence() -> void:
	var state = _completed_j11_state("MATHILDE", true)
	var provider = _new_provider(state)
	provider.start_day()
	_expect(provider.phase == "mathilde_failed_incoming", "failed Mathilde aftercare precedes normal J12")
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
	_present_batch(provider, MARIE_THREAD)
	_confirm_transition(provider)
	_expect(provider.phase == "complete" and state.mathilde_state == "TRUST_BROKEN", "failed aftercare remains a consequence, never retroactive payment")
	_expect(state.j12_priority_route == "NETWORK", "no replacement relationship substitutes for failed aftercare")

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

func _completed_j11_state(pivot: String, fail_mathilde := false):
	var state = SEASON_STATE.new()
	state.current_day = "J11"; state.day_status = "ACTIVE"
	var source: Array = {"SANDRA":["SANDRA","CAFE_HELD_MISSING_NAMED"],"MATHILDE":["MATHILDE","OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED"],"NICO":["NICO","DIFFERENCE_ACKNOWLEDGED_NO_IMAGE"]}[pivot]
	state.j10_pivot = source[0]; state.j10_pivot_reason = "AUTHORED_ORDER"; state.j10_pivot_outcome = source[1]
	state.marie_j10_dinner_resolution = "NOT_DUE"; state.nico_j10_morning_confirmation = "NOT_DUE"
	state.completed_conversation_ids.append({"SANDRA":"chapter_10_sandra_cafe","MATHILDE":"chapter_10_mathilde_outfit","NICO":"chapter_10_nico_observation"}[pivot])
	state.j11_pivot = pivot; state.j11_pivot_reason = "J10_CONTINUATION"
	if pivot == "SANDRA":
		state.establish_j11_sandra_private_image("view_only"); state.record_j11_choice("choice_j11_sandra_rule", ["choice_j11_sandra_rule"])
	elif pivot == "MATHILDE":
		state.configure_j11_mathilde_safety(true, true, true); state.establish_j11_mathilde_physical_event("MATHILDE_M_B2", true); state.resolve_j11_aftercare("aftercare_mathilde_j11", "FAILED" if fail_mathilde else "PAID", "Player"); state.record_j11_choice("choice_j11_mathilde_after_repeat" if fail_mathilde else "choice_j11_mathilde_after_no_definition", ["choice_j11_mathilde_after_repeat" if fail_mathilde else "choice_j11_mathilde_after_no_definition"])
	else:
		state.record_j11_choice("choice_j11_nico_guardrail", ["choice_j11_nico_guardrail"])
	_expect(state.complete_j11(), "fixture completes J11 for " + pivot)
	return state

func _new_provider(state):
	var provider = J12_PROVIDER.new(); _expect(provider.initialize(state, {}, {}, [], []), "J12 provider initializes"); return provider

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

func _expect(condition: bool, label: String) -> void:
	if not condition: failures.append(label)
