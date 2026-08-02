extends Node

const STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const PROVIDER := preload("res://scripts/runtime/season_1/J15RuntimeProvider.gd")
const J14_PROVIDER := preload("res://scripts/runtime/season_1/J14RuntimeProvider.gd")
const TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const J13_SMOKE := preload("res://tests/RUNTIME_S1_13J13PlayableSmokeDriver.gd")
const J12_SMOKE := preload("res://tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd")
var failures: Array[String] = []
var j13_helper

func _ready() -> void:
	j13_helper = J13_SMOKE.new(); j13_helper.j12_helper = J12_SMOKE.new()
	j13_helper.j12_helper.marie_j11_base_snapshot = j13_helper.j12_helper._build_real_j11_base_snapshot("MARIE")
	j13_helper.j12_helper.mathilde_j11_base_snapshot = j13_helper.j12_helper._build_real_j11_base_snapshot("MATHILDE")
	_exercise_lie_mutation()
	_exercise_clean_no_obligation()
	_exercise_legacy_and_corrupt_snapshots()
	for failure in j13_helper.failures: failures.append("J13 helper: " + failure)
	for failure in j13_helper.j12_helper.failures: failures.append("J12 helper: " + failure)
	j13_helper.j12_helper.free(); j13_helper.free()
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

func _exercise_legacy_and_corrupt_snapshots() -> void:
	var state = _completed_j14_state("choice_j14_pauline_truth"); var provider = _new_provider(state); var fixtures: Array[Dictionary] = []
	_append_legacy_fixture(fixtures, provider, state, 2)
	provider.start_day(); _append_legacy_fixture(fixtures, provider, state, 4)
	_confirm(provider); _append_legacy_fixture(fixtures, provider, state, 2)
	_present(provider, "thread_marie_private"); _append_legacy_fixture(fixtures, provider, state, 4)
	provider.apply_choice("thread_marie_private", "choice_j15_clean_acknowledge_marie"); _append_legacy_fixture(fixtures, provider, state, 2)
	_confirm(provider); _append_legacy_fixture(fixtures, provider, state, 4)
	for fixture in fixtures:
		var restored_state = STATE.new(); var restored = PROVIDER.new(); var label := str(fixture.provider.get("phase", "")) + " v" + str(fixture.provider.get("version", -1))
		_expect(restored_state.restore_snapshot(fixture.state) and restored.initialize(restored_state, {}, {}, [], []) and restored.restore_snapshot(fixture.provider), "J15 legacy " + label + " migrates")
	var incoming_fixture: Dictionary = fixtures[2]; var corruptions: Array[Dictionary] = []
	var bad_pivot: Dictionary = incoming_fixture.provider.duplicate(true); bad_pivot["version"] = 5; bad_pivot["selected_pivot"] = "REPAIR"; corruptions.append(bad_pivot)
	var bad_choices: Dictionary = incoming_fixture.provider.duplicate(true); bad_choices["version"] = 5; bad_choices["pending_choice_ids_by_thread"]["thread_marie_private"] = ["choice_j15_repair_lie_marie"]; corruptions.append(bad_choices)
	var bad_thread: Dictionary = incoming_fixture.provider.duplicate(true); bad_thread["version"] = 5; bad_thread["transcripts_by_thread"]["thread_wrong"] = bad_thread["transcripts_by_thread"].get("thread_marie_private", []); bad_thread["transcripts_by_thread"]["thread_marie_private"] = []; corruptions.append(bad_thread)
	for corrupted in corruptions:
		var corrupted_state = STATE.new(); var rejected = PROVIDER.new(); _expect(corrupted_state.restore_snapshot(incoming_fixture.state) and rejected.initialize(corrupted_state, {}, {}, [], []) and not rejected.restore_snapshot(corrupted), "J15 corrupted snapshot fails closed")

func _append_legacy_fixture(fixtures: Array[Dictionary], provider, state, version: int) -> void:
	var provider_snapshot: Dictionary = provider.snapshot(); provider_snapshot["version"] = version; fixtures.append({"provider":provider_snapshot,"state":state.snapshot()})

func _completed_j14_state(j14_choice: String):
	var state = j13_helper._completed_network_state(true)
	_expect(state.begin_j13() and state.set_j13_priority("PAULINE") and state.deliver_j13_priority("PAULINE", "j13_pauline") and state.apply_j13_choice("choice_j13_pauline_rule", "PAULINE") and state.complete_j13(), "fixture completes J13 with T17")
	var j14 = J14_PROVIDER.new(); _expect(j14.initialize(state, {}, {}, [], []), "fixture initializes J14")
	_expect(bool(j14.start_day().get("accepted", false)), "fixture starts J14"); _confirm_any(j14); _confirm_any(j14)
	_present_day(j14, "thread_marie_private", 14)
	_expect(bool(j14.apply_choice("thread_marie_private", j14_choice).get("accepted", false)), "fixture applies J14 choice")
	_confirm_any(j14); _present_day(j14, "thread_pauline_private", 14); _confirm_any(j14)
	_expect(j14.phase == "complete" and state.day_status == "COMPLETE", "fixture completes J14 after presented controller notice")
	return state

func _new_provider(state):
	var provider = PROVIDER.new(); _expect(provider.initialize(state, {}, {}, [], []), "J15 provider initializes"); return provider
func _present(provider, thread_id: String) -> void:
	_present_day(provider, thread_id, 15)
func _present_day(provider, thread_id: String, source_day: int) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == source_day and not bool(message.get("is_player", false)) and not provider.presented_time_message_ids.has(str(message.get("message_id", ""))): provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "batch presents for " + thread_id + " on J" + str(source_day))
func _confirm(provider) -> void:
	_confirm_any(provider)
func _confirm_any(provider) -> void:
	var target_text := str(provider.pending_transition.get("to_time", ""))
	if target_text != "":
		var target := TIME.parse_narrative_time(target_text)
		if target >= provider.current_narrative_time_minutes(): provider.commit_narrative_time(target)
	_expect(bool(provider.confirm_transition().get("accepted", false)), "transition confirms")
func _expect_round_trip(provider, label: String) -> void:
	var snap: Dictionary = provider.snapshot(); var restored = PROVIDER.new(); _expect(restored.initialize(provider.state, {}, {}, [], []), label + " initializes"); _expect(restored.restore_snapshot(snap), label + " restores"); _expect(restored.snapshot() == snap, label + " is exact")
func _expect(condition: bool, label: String) -> void:
	if not condition: failures.append(label)
