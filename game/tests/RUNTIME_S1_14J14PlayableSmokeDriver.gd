extends Node

const STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const PROVIDER := preload("res://scripts/runtime/season_1/J14RuntimeProvider.gd")
const TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
var failures: Array[String] = []

func _ready() -> void:
	_exercise_pauline_discovery_and_notice()
	_exercise_public_fallback()
	if failures.is_empty(): print("RUNTIME_S1_14_J14_PLAYABLE: OK"); get_tree().quit(0); return
	for failure in failures: push_error(failure)
	get_tree().quit(1)

func _exercise_pauline_discovery_and_notice() -> void:
	var state = _completed_j13_state("PAULINE"); var source_before: Dictionary = state.traces[state.j13_j14_trace_id].duplicate(true); var provider = _new_provider(state)
	_expect(bool(provider.start_day().get("accepted", false)) and provider.selected_pivot == "PAULINE", "private Pauline trace selects bounded Marie witness route")
	_expect(state.traces[state.j13_j14_trace_id] == source_before, "discovery does not mutate the source trace")
	_expect(state.knowledge.has("fact_witness_saw_limited_trace"), "discovery creates bounded witness knowledge")
	_confirm(provider); _present(provider, "thread_marie_private")
	_expect_round_trip(provider, "J14 witness choice")
	provider.apply_choice("thread_marie_private", "choice_j14_pauline_defer"); _confirm(provider); _present(provider, "thread_pauline_private"); _confirm(provider)
	_expect(provider.phase == "complete", "J14 completes after controller notice")
	_expect(str(state.promises["j14_inform_trace_controller"].get("status", "")) == "PAID", "controller notice is paid before close")
	_expect(not state.promises.has("j14_witness_clarification"), "a defer without an accepted precise hour creates no promise")
	_expect(state.knowledge.has("fact_trace_controller_informed_of_audience_breach"), "controller notice records canonical fact")
	_expect(state._j14_records_consistent(state.snapshot()), "completed J14 records remain internally consistent")

func _exercise_public_fallback() -> void:
	var state = _completed_j13_state("RESPIRATION"); var provider = _new_provider(state)
	provider.start_day(); _expect(provider.selected_pivot == "FALLBACK", "public-only trace uses no-private-discovery fallback")
	_confirm(provider); _present(provider, "thread_marie_private"); provider.apply_choice("thread_marie_private", "choice_j14_fallback_close"); _confirm(provider)
	_expect(provider.phase == "complete", "fallback closes without controller notice")
	_expect(not state.traces.has("j14_discovery_event_01") and not state.promises.has("j14_inform_trace_controller"), "fallback invents no private discovery or notice")

func _completed_j13_state(pivot: String):
	var state = STATE.new(); state.current_day = "J10"; state.day_status = "COMPLETE"; state.j10_pivot = "SANDRA"; state.j10_pivot_reason = "AUTHORED_ORDER"; state.j10_pivot_outcome = "CAFE_HELD_CALM_PRESENCE"; state.marie_j10_dinner_resolution = "NOT_DUE"; state.nico_j10_morning_confirmation = "NOT_DUE"; state.completed_conversation_ids.append("chapter_10_sandra_cafe")
	_expect(state.begin_j11(), "fixture enters J11"); _expect(state.set_j11_continuation("RESPIRATION", "J10_NO_LEGITIMATE_CONTINUATION"), "fixture selects respiration"); _expect(state.complete_j11(), "fixture completes J11")
	_expect(state.begin_j12(), "fixture enters J12"); _expect(state.apply_j12_choice("choice_j12_presence_la") and state.establish_j12_laverriere_public_trace() and state.pay_j12_laverriere_presence(), "fixture establishes and pays T14")
	var pauline_eligible := pivot == "PAULINE"; _expect(state.apply_j12_choice("choice_j12_annexe_a12" if pauline_eligible else "choice_j12_annexe_c12"), "fixture chooses exact P13")
	_expect(state.pay_and_establish_j12_annexe_arrival() if pauline_eligible else state.establish_j12_annexe_public_trace(), "fixture establishes and settles T15")
	_expect(state.establish_j12_priority_consequence("NETWORK"), "fixture establishes NETWORK consequence"); _expect(state.complete_j12(), "fixture completes J12")
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
func _expect(condition: bool, label: String) -> void:
	if not condition: failures.append(label)
