extends Node

const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J11_PROVIDER := preload("res://scripts/runtime/season_1/J11RuntimeProvider.gd")
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")

const MARIE_THREAD := "thread_marie_private"
const SANDRA_THREAD := "thread_sandra_private"
const MATHILDE_THREAD := "thread_mathilde_private"
const RAPHAELLE_THREAD := "thread_raphaelle_private"
const NICO_THREAD := "thread_nico_private"

var failures: Array[String] = []

func _ready() -> void:
	_exercise_p10_p11_priority_and_round_trip()
	_exercise_sandra_removal()
	_exercise_mathilde_physical_aftercare()
	_exercise_raphaelle_kiss()
	_exercise_nico_guardrail()
	_exercise_marie_adult_reconquest()
	_exercise_respiration()
	if failures.is_empty():
		print("RUNTIME_S1_11_J11_PLAYABLE: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)

func _exercise_p10_p11_priority_and_round_trip() -> void:
	var state = _completed_j10_state("SANDRA", "CAFE_HELD_MISSING_NAMED")
	state.marie_j10_dinner_resolution = "FRIDAY_RECONFIRMED"
	state.promises["marie_j09_dinner_friday_2030"] = {
		"status": "ACTIVE", "due_at": "J11 20:30", "accepted_by_player": true,
	}
	state.promises["sandra_cafe_saturday_1100"] = {"status": "CONDITIONAL"}
	var provider = _new_provider(state)
	var started: Dictionary = provider.start_day()
	_expect(bool(started.get("accepted", false)) and provider.phase == "p10_incoming", "P10 is delivered before the selected pivot")
	_present_batch(provider, MARIE_THREAD)
	_expect(bool(provider.apply_choice(MARIE_THREAD, "choice_j11_p10_cancel").get("accepted", false)), "P10 clean cancellation applies")
	_expect(provider.phase == "to_p11", "P11 is scheduled after P10")
	_confirm_transition(provider)
	_present_batch(provider, SANDRA_THREAD)
	_expect(str(state.promises["sandra_cafe_saturday_1100"].get("counterparty_confirmed_by", "")) == "Sandra", "P11 stores Sandra confirmation")
	_expect(provider.phase == "to_sandra", "selected pivot resumes after P11")
	_expect_round_trip(provider, "P10/P11 checkpoint")

func _exercise_sandra_removal() -> void:
	var provider = _new_provider(_completed_j10_state("SANDRA", "CAFE_HELD_MISSING_NAMED"))
	provider.start_day()
	_confirm_transition(provider)
	_present_batch(provider, SANDRA_THREAD)
	_expect(bool(provider.apply_choice(SANDRA_THREAD, "choice_j11_sandra_more").get("accepted", false)), "Sandra removal choice applies")
	var trace: Dictionary = provider.state.traces.get("j11_sandra_chosen_image_01", {})
	_expect(str(trace.get("current_state", "")) == "REMOVED", "Sandra image becomes inaccessible")
	_expect(_media_count(provider, "S1_A3_J11_DPH_SANDRA_CHOSEN_IMAGE_01") == 0, "removed Sandra image no longer exposes media")
	_confirm_transition(provider)
	_expect(provider.phase == "complete", "Sandra route completes J11")

func _exercise_mathilde_physical_aftercare() -> void:
	var provider = _new_provider(_completed_j10_state("MATHILDE", "OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED"))
	provider.start_day()
	_confirm_transition(provider)
	_present_batch(provider, MATHILDE_THREAD)
	_expect(bool(provider.apply_choice(MATHILDE_THREAD, "choice_j11_mathilde_proximity").get("accepted", false)), "Mathilde conditional proximity applies")
	_expect(provider.state.j11_physical_level == "MATHILDE_M_B2", "eligible Mathilde route reaches only the bounded M-B2 ceiling")
	_expect(provider.gallery_asset_ids.has("S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01"), "Mathilde physical event unlocks the existing parent sequence")
	_confirm_transition(provider)
	_present_batch(provider, MATHILDE_THREAD)
	_expect(bool(provider.apply_choice(MATHILDE_THREAD, "choice_j11_mathilde_after_no_definition").get("accepted", false)), "Mathilde aftercare can be paid without demanding a definition")
	_expect(str(provider.state.obligations["aftercare_mathilde_j11"].get("status", "")) == "PAID", "Mathilde aftercare is paid")
	_confirm_transition(provider)
	_expect(provider.phase == "complete", "Mathilde route completes J11")

func _exercise_raphaelle_kiss() -> void:
	var provider = _new_provider(_completed_j10_state("RAPHAELLE", "PROCESS_HELPED_VISIT_BOUNDED"))
	provider.start_day()
	_confirm_transition(provider)
	_present_batch(provider, RAPHAELLE_THREAD)
	provider.apply_choice(RAPHAELLE_THREAD, "choice_j11_raphaelle_work_person")
	_present_batch(provider, RAPHAELLE_THREAD)
	provider.apply_choice(RAPHAELLE_THREAD, "choice_j11_raphaelle_attraction_yes")
	_present_batch(provider, RAPHAELLE_THREAD)
	_expect(bool(provider.apply_choice(RAPHAELLE_THREAD, "choice_j11_raphaelle_meeting_accept").get("accepted", false)), "Raphaëlle distinct meeting accepts explicit reversibility")
	_confirm_transition(provider)
	_present_batch(provider, RAPHAELLE_THREAD)
	_confirm_transition(provider)
	_expect(provider.state.j11_pivot_outcome == "FIRST_KISS", "Raphaëlle first kiss records the signed outcome")
	_expect(provider.state.j11_physical_level == "RAPHAELLE_FIRST_KISS", "Raphaëlle never exceeds the first-kiss ceiling")
	_expect(provider.phase == "complete", "Raphaëlle route completes J11")

func _exercise_nico_guardrail() -> void:
	var provider = _new_provider(_completed_j10_state("NICO", "DIFFERENCE_ACKNOWLEDGED_NO_IMAGE"))
	provider.start_day()
	_confirm_transition(provider)
	_present_batch(provider, NICO_THREAD)
	_expect(bool(provider.apply_choice(NICO_THREAD, "choice_j11_nico_guardrail").get("accepted", false)), "Nico reciprocal guardrail applies")
	_confirm_transition(provider)
	_expect(provider.state.selected_choice_ids.has("choice_j11_nico_guardrail"), "Nico role is preserved without an image or permission")
	_expect(provider.phase == "complete", "Nico route completes J11")

func _exercise_marie_adult_reconquest() -> void:
	var state = _completed_j10_state("NONE", "ORDINARY_MEAL_JOINED")
	state.marie_j09_presence_outcome = "presence_active"
	state.couple_state = "BASELINE_SHARED_LIFE"
	var provider = _new_provider(state)
	provider.start_day()
	_confirm_transition(provider)
	_present_batch(provider, MARIE_THREAD)
	var reconquest_choice := _choice_containing(provider, MARIE_THREAD, "reconquest")
	_expect(reconquest_choice != "", "Marie reconquest choice is visible")
	var reconquest_result: Dictionary = provider.apply_choice(MARIE_THREAD, reconquest_choice)
	_expect(bool(reconquest_result.get("accepted", false)), "Marie reconquest choice applies: %s / %s / %s" % [reconquest_choice, provider.phase, str(provider.choices_for(MARIE_THREAD))])
	_expect(provider.state.j11_physical_level == "MARIE_ADULT_RECONQUEST", "Marie adult event requires the exact constructed predicate")
	_expect(provider.gallery_asset_ids.has("S1_A3_J11_SCN_MARIE_COUPLE_STATE_01"), "Marie adult event unlocks the existing parent sequence")
	_confirm_transition(provider)
	_confirm_transition(provider)
	_expect(provider.phase == "complete", "Marie route completes J11")

func _exercise_respiration() -> void:
	var provider = _new_provider(_completed_j10_state("SANDRA", "CAFE_HELD_CALM_PRESENCE"))
	var started: Dictionary = provider.start_day()
	_expect(bool(started.get("accepted", false)) and provider.state.j11_pivot == "RESPIRATION", "closed J10 outcome selects respiration")
	_expect(provider.transcripts_by_thread.is_empty(), "respiration invents no replacement conversation")
	_confirm_transition(provider)
	_expect(provider.phase == "complete" and provider.state.day_status == "COMPLETE", "respiration completes without route or trace")

func _completed_j10_state(pivot: String, outcome: String):
	var state = SEASON_STATE.new()
	state.current_day = "J10"
	state.day_status = "COMPLETE"
	state.j10_pivot = pivot
	state.j10_pivot_reason = "NO_ELIGIBLE_PIVOT" if pivot == "NONE" else "AUTHORED_ORDER"
	state.j10_pivot_outcome = outcome
	state.marie_j10_dinner_resolution = "NOT_DUE"
	state.nico_j10_morning_confirmation = "NOT_DUE"
	state.completed_conversation_ids.append({
		"SANDRA": "chapter_10_sandra_cafe",
		"MATHILDE": "chapter_10_mathilde_outfit",
		"RAPHAELLE": "chapter_10_raphaelle_process",
		"NICO": "chapter_10_nico_observation",
		"NONE": "chapter_10_marie_obligations",
	}[pivot])
	return state

func _new_provider(state):
	var provider = J11_PROVIDER.new()
	_expect(provider.initialize(state, {}, {}, [], []), "J11 provider initializes")
	return provider

func _present_batch(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 11 and not bool(message.get("is_player", false)) and not provider.presented_time_message_ids.has(str(message.get("message_id", ""))):
			provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "batch presents for %s in %s" % [thread_id, provider.phase])

func _confirm_transition(provider) -> Dictionary:
	var transition: Dictionary = provider.pending_transition.duplicate(true)
	var target_text := str(transition.get("to_time", ""))
	if target_text != "":
		var target := NARRATIVE_TIME.parse_narrative_time(target_text)
		_expect(target >= provider.current_narrative_time_minutes(), "transition time is monotonic for " + str(transition.get("kind", "")))
		if target >= provider.current_narrative_time_minutes():
			provider.commit_narrative_time(target)
	var result: Dictionary = provider.confirm_transition()
	_expect(bool(result.get("accepted", false)), "transition confirms for " + str(transition.get("kind", "")))
	return result

func _choice_containing(provider, thread_id: String, token: String) -> String:
	for choice in provider.choices_for(thread_id):
		var choice_id := str(choice.get("choice_id", ""))
		if choice_id.contains(token):
			return choice_id
	return ""

func _media_count(provider, media_ref: String) -> int:
	var count := 0
	for thread_id in provider.transcripts_by_thread:
		for message in provider.transcripts_by_thread[thread_id]:
			if str(message.get("media_ref", "")) == media_ref:
				count += 1
	return count

func _expect_round_trip(provider, label: String) -> void:
	var provider_snapshot: Dictionary = provider.snapshot()
	var restored = J11_PROVIDER.new()
	_expect(restored.initialize(provider.state, {}, {}, [], []), label + " provider initialize")
	_expect(restored.restore_snapshot(provider_snapshot), label + " provider restore")
	_expect(restored.snapshot() == provider_snapshot, label + " exact provider round trip")

func _expect(condition: bool, label: String) -> void:
	if not condition:
		failures.append(label)
