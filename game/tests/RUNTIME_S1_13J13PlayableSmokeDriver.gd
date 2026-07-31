extends Node

const STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const PROVIDER := preload("res://scripts/runtime/season_1/J13RuntimeProvider.gd")
const TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
var failures: Array[String] = []

func _ready() -> void:
	_exercise_pauline_priority_and_echo()
	_exercise_marie_priority_without_duplicate_echo()
	if failures.is_empty(): print("RUNTIME_S1_13_J13_PLAYABLE: OK"); get_tree().quit(0); return
	for failure in failures: push_error(failure)
	get_tree().quit(1)

func _exercise_pauline_priority_and_echo() -> void:
	var state = _completed_j12_state("NETWORK"); var provider = _new_provider(state)
	_expect(bool(provider.start_day().get("accepted", false)) and provider.selected_pivot == "PAULINE", "network visibility selects Pauline without a higher debt")
	_confirm(provider); _present(provider, "thread_pauline_private")
	_expect_round_trip(provider, "Pauline opening")
	provider.apply_choice("thread_pauline_private", "choice_j13_pauline_rule"); _confirm(provider); _present(provider, "thread_marie_private"); _confirm(provider)
	_expect(provider.phase == "complete", "Pauline priority completes after one Marie echo")
	_expect(state.j13_j14_trace_id == "j13_pauline_private_version_01", "only the accessible Pauline trace is handed to J14")
	_expect(str(state.obligations["j12_priority_consequence_j13"].get("status", "")) == "PAID", "priority consequence is paid")

func _exercise_marie_priority_without_duplicate_echo() -> void:
	var state = _completed_j12_state("MARIE"); var provider = _new_provider(state)
	provider.start_day(); _confirm(provider); _present(provider, "thread_marie_private"); provider.apply_choice("thread_marie_private", "choice_j13_marie_truth"); _confirm(provider)
	_expect(provider.phase == "complete" and provider.presentation_count_by_id("msg_j13_marie_echo_001") == 0, "Marie pivot does not duplicate its own echo")

func _completed_j12_state(priority: String):
	var state = STATE.new(); state.current_day = "J10"; state.day_status = "COMPLETE"; state.j10_pivot = "SANDRA"; state.j10_pivot_reason = "AUTHORED_ORDER"; state.j10_pivot_outcome = "CAFE_HELD_CALM_PRESENCE"; state.marie_j10_dinner_resolution = "NOT_DUE"; state.nico_j10_morning_confirmation = "NOT_DUE"; state.completed_conversation_ids.append("chapter_10_sandra_cafe")
	_expect(state.begin_j11(), "fixture enters J11"); _expect(state.set_j11_continuation("RESPIRATION", "J10_NO_LEGITIMATE_CONTINUATION"), "fixture selects respiration"); _expect(state.complete_j11(), "fixture completes J11")
	_expect(state.begin_j12(), "fixture enters J12"); state.apply_j12_choice("choice_j12_presence_la"); state.establish_j12_laverriere_public_trace(); state.apply_j12_choice("choice_j12_annexe_a12"); state.establish_j12_annexe_public_trace(); state.establish_j12_priority_consequence(priority); _expect(state.complete_j12(), "fixture completes J12")
	return state

func _new_provider(state):
	var provider = PROVIDER.new(); _expect(provider.initialize(state, {}, {}, [], []), "J13 provider initializes"); return provider
func _present(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 13 and not bool(message.get("is_player", false)) and not provider.presented_time_message_ids.has(str(message.get("message_id", ""))): provider.mark_message_presented(str(message.get("message_id", "")))
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
