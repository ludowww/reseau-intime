extends "res://scripts/ui/PhonePrototypeV089.gd"

const MONDAY_INDEX_PATH := "res://data/conversations/chapter_07_modular_index.json"
const SANDRA_SCENE_ID := "sandra_end_of_shift_twenty_minutes_01"
const SANDRA_CONVERSATION_ID := "chapter_07_sandra_end_of_shift"
const MONDAY_MARIE_RETURN_CONVERSATION_ID := "chapter_07_marie_monday_return"
const MONDAY_MORNING_PHASE_ID := "monday_morning_commitment"
const MONDAY_SANDRA_PHASE_ID := "monday_sandra_end_shift_candidate"
const MONDAY_MARIE_RETURN_PHASE_ID := "monday_marie_return"
const MONDAY_MORNING_EXPECTED_BY := "monday_morning"

func _ready() -> void:
	_ensure_v090_chapter_loaded()
	super._ready()

func _ensure_v090_chapter_loaded() -> void:
	if DataLoader.chapter_indexes.is_empty():
		DataLoader.load_all()
	if not DataLoader.get_index_for_day(7).is_empty():
		return
	var index := DataLoader.load_json(MONDAY_INDEX_PATH)
	if index.is_empty():
		return
	DataLoader.chapter_indexes.append(index)
	DataLoader._load_index_conversations(index)

func _complete_day(day_value) -> void:
	var next_day = DataLoader.get_timeline_next_day(day_value)
	if str(next_day) != "7":
		await super._complete_day(day_value)
		return
	var initial_phase := DataLoader.get_timeline_phase(
		next_day,
		DataLoader.get_timeline_initial_phase_id(next_day)
	)
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

func _activate_phase(day_value, phase: Dictionary, show_transition: bool) -> void:
	if str(phase.get("id", "")) == MONDAY_MARIE_RETURN_PHASE_ID:
		_mark_monday_obligations_due()
	await super._activate_phase(day_value, phase, show_transition)

func _activate_authored_beat_silently(day_value, phase: Dictionary) -> void:
	if str(phase.get("id", "")) == MONDAY_MORNING_PHASE_ID:
		_pay_monday_morning_obligations()
	await super._activate_authored_beat_silently(day_value, phase)

func _open_conversation(day_value, conversation: Dictionary) -> void:
	if time_passage_in_progress:
		return
	var opens_sandra := _conversation_episode_ids(conversation).has(SANDRA_CONVERSATION_ID)
	super._open_conversation(day_value, conversation)
	if opens_sandra:
		GameState.set_scene_status(LEDGER_ID, SANDRA_SCENE_ID, "SEEN")

func _advance_optional_phase(day_value, phase_id: String) -> void:
	if phase_id != MONDAY_SANDRA_PHASE_ID:
		await super._advance_optional_phase(day_value, phase_id)
		return
	if transition_in_progress or phase_id != TimelineState.current_phase_id(day_value):
		return
	var phase := DataLoader.get_timeline_phase(day_value, phase_id)
	var completed := TimelineState.is_episode_completed(day_value, SANDRA_CONVERSATION_ID)
	var opened := TimelineState.is_optional_opened(day_value, SANDRA_CONVERSATION_ID)
	if opened and not completed:
		return
	if completed:
		TimelineState.complete_phase(day_value, phase_id)
	else:
		GameState.set_scene_status(LEDGER_ID, SANDRA_SCENE_ID, "EXPIRED")
		TimelineState.expire_conversation(day_value, SANDRA_CONVERSATION_ID)
		_clear_pending_for_episode(day_value, SANDRA_CONVERSATION_ID)
		EffectApplier.apply_flags(phase.get("skip_sets_flags", []))
		TimelineState.skip_phase(day_value, phase_id)
	await _advance_after_phase(day_value, phase_id)

func _on_conversation_completed(day_value, conversation_id: String) -> void:
	if conversation_id == SANDRA_CONVERSATION_ID:
		_complete_sandra_candidate()
	elif conversation_id == MONDAY_MARIE_RETURN_CONVERSATION_ID:
		_apply_monday_marie_return_outcome()
	await super._on_conversation_completed(day_value, conversation_id)

func _complete_sandra_candidate() -> void:
	var ledger := _ensure_first_repetition_ledger()
	var ordinal := int(ledger.get("opportunity_window_ordinal", 0))
	GameState.set_scene_status(LEDGER_ID, SANDRA_SCENE_ID, "RESOLVED")
	GameState.record_external_foreground(LEDGER_ID, SANDRA_SCENE_ID, "sandra")
	var descriptor := _sandra_candidate_descriptor()
	var cooldown_windows := int(descriptor.get("cooldown_windows", 2))
	GameState.set_scene_cooldown(LEDGER_ID, SANDRA_SCENE_ID, ordinal + cooldown_windows + 1)
	GameState.set_obligation_status(LEDGER_ID, "marie_return_after_sandra", {
		"status": "SCHEDULED",
		"owner": "player",
		"expected_by": MONDAY_MARIE_RETURN_PHASE_ID,
		"created_by": SANDRA_SCENE_ID,
		"resolved_by": "",
		"result": "",
	})

func _pay_monday_morning_obligations() -> void:
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
		var status := str(entry.get("status", ""))
		var expected_by := str(entry.get("expected_by", ""))
		var result := str(entry.get("result", ""))
		var is_monday_carry := expected_by == MONDAY_MORNING_EXPECTED_BY or (status == "CARRIED" and result == "monday_morning")
		if not is_monday_carry:
			continue
		if status not in ["CARRIED", "SCHEDULED", "DUE"]:
			continue
		entry["status"] = "PAID"
		entry["resolved_by"] = MONDAY_MORNING_PHASE_ID
		entry["result"] = "promised_coffee_paid"
		GameState.set_obligation_status(LEDGER_ID, obligation_id, entry)

func _mark_monday_obligations_due() -> void:
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
		if str(entry.get("expected_by", "")) != MONDAY_MARIE_RETURN_PHASE_ID:
			continue
		if str(entry.get("status", "")) != "SCHEDULED":
			continue
		entry["status"] = "DUE"
		GameState.set_obligation_status(LEDGER_ID, obligation_id, entry)

func _apply_monday_marie_return_outcome() -> void:
	var flags: Array = GameState.current_state.get("flags", [])
	if flags.has("marie_monday_return_active"):
		_resolve_monday_due_obligations("PAID", "active_return")
		return
	if flags.has("marie_monday_return_bounded"):
		_resolve_monday_due_obligations("PAID", "bounded_return")
		return
	if flags.has("marie_monday_return_honest_distance"):
		_resolve_monday_due_obligations("FAILED", "honest_distance")

func _resolve_monday_due_obligations(status: String, result: String) -> void:
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
		if str(entry.get("expected_by", "")) != MONDAY_MARIE_RETURN_PHASE_ID:
			continue
		entry["status"] = status
		entry["resolved_by"] = MONDAY_MARIE_RETURN_CONVERSATION_ID
		entry["result"] = result
		GameState.set_obligation_status(LEDGER_ID, obligation_id, entry)

func _sandra_candidate_descriptor() -> Dictionary:
	var phase := DataLoader.get_timeline_phase(7, MONDAY_SANDRA_PHASE_ID)
	var raw_pool = phase.get("candidate_pool", {})
	if typeof(raw_pool) != TYPE_DICTIONARY:
		return {}
	for raw_candidate in raw_pool.get("ordered_candidates", []):
		if typeof(raw_candidate) != TYPE_DICTIONARY:
			continue
		var candidate: Dictionary = raw_candidate
		if str(candidate.get("scene_id", "")) == SANDRA_SCENE_ID:
			return candidate
	return {}
