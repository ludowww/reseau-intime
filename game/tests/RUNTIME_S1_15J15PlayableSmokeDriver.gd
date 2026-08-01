extends Node

const STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const PROVIDER := preload("res://scripts/runtime/season_1/J15RuntimeProvider.gd")
const TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
var failures: Array[String] = []

func _ready() -> void:
	_exercise_lie_mutation()
	_exercise_clean_no_obligation()
	if failures.is_empty(): print("RUNTIME_S1_15_J15_PLAYABLE: OK"); get_tree().quit(0); return
	for failure in failures: push_error(failure)
	get_tree().quit(1)

func _exercise_lie_mutation() -> void:
	var state = _completed_j14_state("choice_j14_pauline_lie"); var provider = _new_provider(state)
	_expect(bool(provider.start_day().get("accepted", false)) and provider.selected_pivot == "REPAIR", "a J14 lie selects bounded repair without invented promise")
	_confirm(provider); _present(provider, "thread_marie_private"); _expect_round_trip(provider, "J15 repair choice")
	provider.apply_choice("thread_marie_private", "choice_j15_repair_lie_marie"); _confirm(provider)
	_expect(provider.phase == "complete", "J15 lie mutation completes")
	_expect(str(state.traces["j15_obligation_collision_record_01"].get("collision_mode", "")) == "NO_COLLISION", "T21 records no collision")
	_expect(not bool(state.traces["j15_obligation_collision_record_01"].get("second_signed_obligation_present", true)), "T21 proves no second signed obligation")
	_expect(state.promises.has("j16_priority_consequence_payment"), "a maintained lie creates one precise J16 consequence")

func _exercise_clean_no_obligation() -> void:
	var state = _completed_j14_state("choice_j14_pauline_truth"); var provider = _new_provider(state)
	provider.start_day(); _expect(provider.selected_pivot == "NO_OBLIGATION", "truth with no precise deferred hour selects clean mutation")
	_confirm(provider); _present(provider, "thread_marie_private"); provider.apply_choice("thread_marie_private", "choice_j15_clean_acknowledge_marie"); _confirm(provider)
	_expect(provider.phase == "complete", "clean J15 closes")
	_expect(not state.traces.has("j15_obligation_collision_record_01"), "no obligation creates no T21 record")
	_expect(not state.promises.has("j16_priority_consequence_payment"), "clean closure creates no J16 debt")

func _completed_j14_state(j14_choice: String):
	var state = STATE.new(); state.current_day = "J10"; state.day_status = "COMPLETE"; state.j10_pivot = "SANDRA"; state.j10_pivot_reason = "AUTHORED_ORDER"; state.j10_pivot_outcome = "CAFE_HELD_CALM_PRESENCE"; state.marie_j10_dinner_resolution = "NOT_DUE"; state.nico_j10_morning_confirmation = "NOT_DUE"; state.completed_conversation_ids.append("chapter_10_sandra_cafe")
	state.begin_j11(); state.set_j11_continuation("RESPIRATION", "J10_NO_LEGITIMATE_CONTINUATION"); state.complete_j11()
	state.begin_j12(); state.apply_j12_choice("choice_j12_presence_la"); state.establish_j12_laverriere_public_trace(); state.apply_j12_choice("choice_j12_annexe_a12"); state.establish_j12_annexe_public_trace(); state.establish_j12_priority_consequence("NETWORK"); state.complete_j12()
	state.begin_j13(); state.set_j13_priority("PAULINE"); state.apply_j13_choice("choice_j13_pauline_rule", "PAULINE"); state.complete_j13()
	state.begin_j14(); state.establish_j14_discovery("PAULINE"); state.apply_j14_choice(j14_choice, "PAULINE"); state.resolve_j14_controller_informed(); _expect(state.complete_j14(), "fixture completes J14")
	return state

func _new_provider(state):
	var provider = PROVIDER.new(); _expect(provider.initialize(state, {}, {}, [], []), "J15 provider initializes"); return provider
func _present(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 15 and not bool(message.get("is_player", false)) and not provider.presented_time_message_ids.has(str(message.get("message_id", ""))): provider.mark_message_presented(str(message.get("message_id", "")))
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
