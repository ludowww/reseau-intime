extends "res://scripts/ui/PhonePrototypeV086A.gd"

const FirstRepetitionSelector = preload("res://scripts/narrative/FirstRepetitionSelector.gd")

const LEDGER_ID := "first_repetition"
const MATHILDE_SCENE_ID := "mathilde_morning_kitchen_afterglow_01"
const MATHILDE_CONVERSATION_ID := "chapter_06_mathilde_morning_afterglow"
const MARIE_RETURN_CONVERSATION_ID := "chapter_06_marie_concrete_return"
const SUNDAY_CANDIDATE_PHASE_ID := "sunday_household_candidate"
const SUNDAY_MARIE_RETURN_PHASE_ID := "sunday_marie_return"
const SATURDAY_RESOLUTION_PHASE_ID := "saturday_shared_hour_resolution"

const POSITIVE_MATHILDE_HISTORY_FLAGS := [
	"opening_make_room_proactive",
	"opening_make_room_playful",
	"mathilde_arrival_practical",
	"mathilde_arrival_playful",
	"household_participation_positive",
	"mathilde_home_help",
	"mathilde_home_playful_help",
]

func _activate_phase(day_value, phase: Dictionary, show_transition: bool) -> void:
	_ensure_first_repetition_ledger()
	if _phase_has_candidate_pool(phase):
		await _activate_candidate_phase(day_value, phase, show_transition)
		return
	if str(phase.get("id", "")) == SUNDAY_MARIE_RETURN_PHASE_ID:
		_mark_sunday_obligations_due()
	await super._activate_phase(day_value, phase, show_transition)

func _activate_candidate_phase(day_value, phase: Dictionary, show_transition: bool) -> void:
	if phase.is_empty():
		return
	transition_in_progress = true
	var phase_id := str(phase.get("id", ""))
	var pool: Dictionary = phase.get("candidate_pool", {})
	var ledger := _ensure_first_repetition_ledger()
	var ordinal := int(ledger.get("opportunity_window_ordinal", 0)) + 1
	GameState.set_story_ledger_value(LEDGER_ID, "opportunity_window_ordinal", ordinal)
	ledger = _ensure_first_repetition_ledger()
	var flags: Array = GameState.current_state.get("flags", [])
	var candidate: Dictionary = FirstRepetitionSelector.select_candidate(
		pool,
		flags,
		ledger,
		day_value,
		phase_id
	)
	if candidate.is_empty():
		await _defer_candidate_phase(day_value, phase)
		return

	var scene_id := str(candidate.get("scene_id", ""))
	GameState.set_scene_status(LEDGER_ID, scene_id, "ELIGIBLE")
	var selected_phase := phase.duplicate(true)
	selected_phase["optional_conversation_ids"] = [str(candidate.get("conversation_id", ""))]
	transition_in_progress = false
	await super._activate_phase(day_value, selected_phase, show_transition)
	GameState.set_scene_status(LEDGER_ID, scene_id, "OFFERED")

func _defer_candidate_phase(day_value, phase: Dictionary) -> void:
	var phase_id := str(phase.get("id", ""))
	var descriptor := _first_candidate_descriptor(phase)
	var scene_id := str(descriptor.get("scene_id", ""))
	var conversation_id := str(descriptor.get("conversation_id", ""))
	if scene_id != "":
		var ledger := _ensure_first_repetition_ledger()
		var status := str(ledger.get("scene_status", {}).get(scene_id, "DORMANT"))
		if status in ["DORMANT", "ELIGIBLE"]:
			GameState.set_scene_status(LEDGER_ID, scene_id, "DEFERRED")
	TimelineState.set_current_phase(day_value, phase_id)
	if conversation_id != "":
		_clear_pending_for_episode(day_value, conversation_id)
	TimelineState.skip_phase(day_value, phase_id)
	transition_in_progress = false
	_render_active_day(day_value)
	_render_days_buttons_only()
	await _advance_after_phase(day_value, phase_id)

func _open_conversation(day_value, conversation: Dictionary) -> void:
	var opens_mathilde := _conversation_episode_ids(conversation).has(MATHILDE_CONVERSATION_ID)
	super._open_conversation(day_value, conversation)
	if opens_mathilde:
		GameState.set_scene_status(LEDGER_ID, MATHILDE_SCENE_ID, "SEEN")

func _advance_optional_phase(day_value, phase_id: String) -> void:
	var phase := DataLoader.get_timeline_phase(day_value, phase_id)
	if _phase_has_candidate_pool(phase):
		var completed := TimelineState.is_episode_completed(day_value, MATHILDE_CONVERSATION_ID)
		var opened := TimelineState.is_optional_opened(day_value, MATHILDE_CONVERSATION_ID)
		if not completed and not opened:
			GameState.set_scene_status(LEDGER_ID, MATHILDE_SCENE_ID, "EXPIRED")
	await super._advance_optional_phase(day_value, phase_id)

func _on_conversation_completed(day_value, conversation_id: String) -> void:
	if conversation_id == MATHILDE_CONVERSATION_ID:
		_complete_mathilde_candidate()
	elif conversation_id == MARIE_RETURN_CONVERSATION_ID:
		_apply_marie_return_outcome()
	await super._on_conversation_completed(day_value, conversation_id)

func _complete_mathilde_candidate() -> void:
	var ledger := _ensure_first_repetition_ledger()
	var ordinal := int(ledger.get("opportunity_window_ordinal", 0))
	GameState.set_scene_status(LEDGER_ID, MATHILDE_SCENE_ID, "RESOLVED")
	GameState.record_external_foreground(LEDGER_ID, MATHILDE_SCENE_ID, "mathilde")
	var descriptor := _mathilde_candidate_descriptor()
	var cooldown_windows := int(descriptor.get("cooldown_windows", 2))
	GameState.set_scene_cooldown(LEDGER_ID, MATHILDE_SCENE_ID, ordinal + cooldown_windows + 1)
	_evaluate_mathilde_r2_gate()
	GameState.set_obligation_status(LEDGER_ID, "marie_return_after_external", {
		"status": "SCHEDULED",
		"owner": "player",
		"expected_by": SUNDAY_MARIE_RETURN_PHASE_ID,
		"created_by": MATHILDE_SCENE_ID,
		"resolved_by": "",
		"result": "",
	})

func _evaluate_mathilde_r2_gate() -> void:
	var flags: Array = GameState.current_state.get("flags", [])
	var gaze_is_acknowledged := (
		flags.has("mathilde_gaze_acknowledged_soft")
		or flags.has("mathilde_gaze_playful_soft")
	)
	if not gaze_is_acknowledged:
		return
	if not _any_flag_present(POSITIVE_MATHILDE_HISTORY_FLAGS, flags):
		return
	if flags.has("mathilde_boundary_broken") or flags.has("mathilde_route_closed"):
		return
	if _has_due_obligation(_ensure_first_repetition_ledger()):
		return
	if GameState.claim_charged_access_owner(LEDGER_ID, "mathilde"):
		EffectApplier.apply_flags(["mathilde_r2_charged_access"])

func _activate_authored_beat_silently(day_value, phase: Dictionary) -> void:
	if str(phase.get("id", "")) == SATURDAY_RESOLUTION_PHASE_ID:
		_record_saturday_resolution_obligation()
	await super._activate_authored_beat_silently(day_value, phase)

func _record_saturday_resolution_obligation() -> void:
	var flags: Array = GameState.current_state.get("flags", [])
	if flags.has("marie_shared_hour_joined"):
		GameState.set_obligation_status(LEDGER_ID, "marie_shared_hour", {
			"status": "PAID",
			"owner": "player",
			"expected_by": SATURDAY_RESOLUTION_PHASE_ID,
			"created_by": "marie_saturday_shared_hour_01",
			"resolved_by": SATURDAY_RESOLUTION_PHASE_ID,
			"result": "joined",
		})
	elif flags.has("marie_shared_hour_rescheduled"):
		GameState.set_obligation_status(LEDGER_ID, "marie_shared_time", {
			"status": "PAID",
			"owner": "player",
			"expected_by": SATURDAY_RESOLUTION_PHASE_ID,
			"created_by": "marie_saturday_shared_hour_01",
			"resolved_by": SATURDAY_RESOLUTION_PHASE_ID,
			"result": "bounded_alternative_paid",
		})
	elif flags.has("marie_moves_without_player"):
		GameState.set_obligation_status(LEDGER_ID, "marie_weekend_return", {
			"status": "SCHEDULED",
			"owner": "player",
			"expected_by": SUNDAY_MARIE_RETURN_PHASE_ID,
			"created_by": "marie_saturday_shared_hour_01",
			"resolved_by": "",
			"result": "",
		})

func _mark_sunday_obligations_due() -> void:
	var ledger := _ensure_first_repetition_ledger()
	var raw_obligations = ledger.get("obligations", {})
	if typeof(raw_obligations) != TYPE_DICTIONARY:
		return
	var obligations: Dictionary = raw_obligations
	for raw_id in obligations.keys():
		var obligation_id := str(raw_id)
		var raw_entry = obligations[raw_id]
		if typeof(raw_entry) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = raw_entry.duplicate(true)
		if str(entry.get("expected_by", "")) != SUNDAY_MARIE_RETURN_PHASE_ID:
			continue
		if str(entry.get("status", "")) != "SCHEDULED":
			continue
		entry["status"] = "DUE"
		GameState.set_obligation_status(LEDGER_ID, obligation_id, entry)

func _apply_marie_return_outcome() -> void:
	var flags: Array = GameState.current_state.get("flags", [])
	if flags.has("marie_return_paid"):
		_resolve_due_obligations("PAID", "immediate_act")
		return
	if flags.has("marie_next_morning_obligation_scheduled"):
		_resolve_due_obligations("CARRIED", "monday_morning")
		GameState.set_obligation_status(LEDGER_ID, "marie_monday_morning", {
			"status": "CARRIED",
			"owner": "player",
			"expected_by": "monday_morning",
			"created_by": MARIE_RETURN_CONVERSATION_ID,
			"resolved_by": "",
			"result": "",
		})
		return
	if flags.has("marie_return_honest_drift"):
		_resolve_due_obligations("FAILED", "honest_non_repair")
		return
	if flags.has("marie_shared_hour_paid") or flags.has("marie_shared_time_paid"):
		EffectApplier.apply_flags(["marie_return_paid"])

func _resolve_due_obligations(status: String, result: String) -> void:
	var ledger := _ensure_first_repetition_ledger()
	var raw_obligations = ledger.get("obligations", {})
	if typeof(raw_obligations) != TYPE_DICTIONARY:
		return
	var obligations: Dictionary = raw_obligations
	for raw_id in obligations.keys():
		var obligation_id := str(raw_id)
		var raw_entry = obligations[raw_id]
		if typeof(raw_entry) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = raw_entry.duplicate(true)
		if str(entry.get("status", "")) != "DUE":
			continue
		entry["status"] = status
		entry["resolved_by"] = MARIE_RETURN_CONVERSATION_ID
		entry["result"] = result
		GameState.set_obligation_status(LEDGER_ID, obligation_id, entry)

func _complete_day(day_value) -> void:
	var next_day = DataLoader.get_timeline_next_day(day_value)
	if next_day == null:
		await super._complete_day(day_value)
		return
	var initial_phase := DataLoader.get_timeline_phase(
		next_day,
		DataLoader.get_timeline_initial_phase_id(next_day)
	)
	if not _phase_has_candidate_pool(initial_phase):
		await super._complete_day(day_value)
		return

	_hide_notification()
	_clear_pending_for_day(day_value)
	TimelineState.mark_day_complete(day_value)
	TimelineState.unlock_day(next_day)
	TimelineState.set_current_day(next_day)
	current_day_value = next_day
	viewing_archived_day = false
	transition_in_progress = false
	time_passage_in_progress = false
	await _activate_phase(next_day, initial_phase, false)
	_sync_conversation_phone_status()

func _ensure_first_repetition_ledger() -> Dictionary:
	return GameState.ensure_story_ledger(LEDGER_ID, GameState.first_repetition_ledger_defaults())

func _phase_has_candidate_pool(phase: Dictionary) -> bool:
	var raw_pool = phase.get("candidate_pool", {})
	return typeof(raw_pool) == TYPE_DICTIONARY and not raw_pool.is_empty()

func _first_candidate_descriptor(phase: Dictionary) -> Dictionary:
	var raw_pool = phase.get("candidate_pool", {})
	if typeof(raw_pool) != TYPE_DICTIONARY:
		return {}
	for raw_candidate in raw_pool.get("ordered_candidates", []):
		if typeof(raw_candidate) == TYPE_DICTIONARY:
			return raw_candidate
	return {}

func _mathilde_candidate_descriptor() -> Dictionary:
	var phase := DataLoader.get_timeline_phase(6, SUNDAY_CANDIDATE_PHASE_ID)
	for raw_candidate in phase.get("candidate_pool", {}).get("ordered_candidates", []):
		if typeof(raw_candidate) != TYPE_DICTIONARY:
			continue
		if str(raw_candidate.get("scene_id", "")) == MATHILDE_SCENE_ID:
			return raw_candidate
	return {}

func _has_due_obligation(ledger: Dictionary) -> bool:
	var raw_obligations = ledger.get("obligations", {})
	if typeof(raw_obligations) != TYPE_DICTIONARY:
		return false
	for raw_entry in raw_obligations.values():
		if typeof(raw_entry) == TYPE_DICTIONARY and str(raw_entry.get("status", "")) == "DUE":
			return true
	return false

func _any_flag_present(candidates: Array, flags: Array) -> bool:
	for raw_flag in candidates:
		if flags.has(str(raw_flag)):
			return true
	return false
