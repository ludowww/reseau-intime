extends "res://scripts/ui/PhonePrototypeV095.gd"

const NamedBoundariesSelector = preload("res://scripts/narrative/NamedBoundariesSelector.gd")
const DAY_NINE := 9
const DAY_NINE_INDEX_PATH := "res://data/conversations/chapter_09_modular_index.json"
const DAY_NINE_VISUAL_PATH := "res://data/visual_content/chapter_09_named_boundaries_visuals.json"
const DAY_NINE_ROUTE_CONVERSATIONS := [
	"chapter_09_mathilde_visual_boundary",
	"chapter_09_sandra_visual_boundary",
]
const DAY_NINE_SOCIAL_CONVERSATION_ID := "chapter_09_marie_pauline_social_set"

func _ready() -> void:
	_ensure_v096_content_loaded()
	super._ready()
	_ensure_named_boundaries_ledger()

func _ensure_v096_content_loaded() -> void:
	if DataLoader.chapter_indexes.is_empty():
		DataLoader.load_all()
	if DataLoader.get_index_for_day(DAY_NINE).is_empty():
		var index := DataLoader.load_json(DAY_NINE_INDEX_PATH)
		if not index.is_empty():
			DataLoader.chapter_indexes.append(index)
			DataLoader._load_index_conversations(index)
	if not DataLoader.visual_content_by_id.has("marie_wednesday_lannexe_social_01"):
		DataLoader._load_visual_content(DAY_NINE_VISUAL_PATH)

func _named_boundaries_defaults() -> Dictionary:
	return {
		"primary_carryover_source": "",
		"primary_visual_route": "",
		"scene_status": {},
		"obligations": {},
		"social_hub_status": "",
	}

func _ensure_named_boundaries_ledger() -> Dictionary:
	return GameState.ensure_story_ledger(NAMED_LEDGER_ID, _named_boundaries_defaults())

func _activate_candidate_phase(day_value, phase: Dictionary, show_transition: bool) -> void:
	if str(phase.get("id", "")) != "wednesday_carryover_route":
		await super._activate_candidate_phase(day_value, phase, show_transition)
		return
	if phase.is_empty():
		return
	transition_in_progress = true
	var selection := NamedBoundariesSelector.select_carryover(GameState.get_story_ledger("first_repetition"), GameState.current_state.get("flags", []))
	var selected_character := str(selection.get("selected_character", "none"))
	GameState.set_story_ledger_value(NAMED_LEDGER_ID, "primary_carryover_source", selected_character)
	if selected_character == "none":
		await _defer_named_boundaries_phase(day_value, phase)
		return
	var selected_phase := phase.duplicate(true)
	selected_phase.erase("candidate_pool")
	var candidate := _named_boundaries_candidate_for(selection, phase)
	if candidate.is_empty():
		await _defer_named_boundaries_phase(day_value, phase)
		return
	selected_phase["optional_conversation_ids"] = [str(candidate.get("conversation_id", ""))]
	transition_in_progress = false
	await super._activate_phase(day_value, selected_phase, show_transition)

func _defer_named_boundaries_phase(day_value, phase: Dictionary) -> void:
	var phase_id := str(phase.get("id", ""))
	TimelineState.set_current_phase(day_value, phase_id)
	TimelineState.skip_phase(day_value, phase_id)
	transition_in_progress = false
	_render_active_day(day_value)
	_render_days_buttons_only()
	await _advance_after_phase(day_value, phase_id)

func _named_boundaries_candidate_for(selection: Dictionary, phase: Dictionary) -> Dictionary:
	var selected_character := str(selection.get("selected_character", ""))
	var selected_scene_id := str(selection.get("selected_scene_id", ""))
	var pool: Dictionary = phase.get("candidate_pool", {})
	for raw_candidate in pool.get("ordered_candidates", []):
		if typeof(raw_candidate) != TYPE_DICTIONARY:
			continue
		var candidate: Dictionary = raw_candidate
		if str(candidate.get("character_id", "")) != selected_character:
			continue
		if selected_scene_id != "" and str(candidate.get("scene_id", "")) != selected_scene_id:
			continue
		return candidate.duplicate(true)
	return {}

func _on_conversation_completed(day_value, conversation_id: String) -> void:
	if int(day_value) == DAY_NINE and DAY_NINE_ROUTE_CONVERSATIONS.has(conversation_id):
		_record_named_boundaries_visual_route(conversation_id)
	elif int(day_value) == DAY_NINE and conversation_id == DAY_NINE_SOCIAL_CONVERSATION_ID:
		_apply_named_boundaries_social_set_outcome()
	await super._on_conversation_completed(day_value, conversation_id)

func _record_named_boundaries_visual_route(conversation_id: String) -> void:
	var ledger := _ensure_named_boundaries_ledger()
	if str(ledger.get("primary_visual_route", "")) != "":
		return
	if conversation_id == "chapter_09_mathilde_visual_boundary" and GameState.current_state.get("flags", []).has("mathilde_deliberate_visual"):
		GameState.set_story_ledger_value(NAMED_LEDGER_ID, "primary_visual_route", "mathilde_deliberate_visual")
	elif conversation_id == "chapter_09_sandra_visual_boundary" and GameState.current_state.get("flags", []).has("sandra_chosen_exposure"):
		GameState.set_story_ledger_value(NAMED_LEDGER_ID, "primary_visual_route", "sandra_chosen_exposure")

func _apply_named_boundaries_social_set_outcome() -> void:
	var flags: Array = GameState.current_state.get("flags", [])
	GameState.set_story_ledger_value(NAMED_LEDGER_ID, "social_hub_status", "RESOLVED")
	if flags.has("marie_m4_join_movement"):
		GameState.set_obligation_status(NAMED_LEDGER_ID, "marie_wednesday_join_movement", {
			"status": "PAID",
			"owner": "player",
			"expected_by": "wednesday_social_set",
			"created_by": "chapter_08_marie_black_dress",
			"resolved_by": DAY_NINE_SOCIAL_CONVERSATION_ID,
			"result": "joined_and_left_together",
		})
	elif flags.has("marie_m4_take_lannexe_table"):
		GameState.set_obligation_status(NAMED_LEDGER_ID, "marie_wednesday_lannexe_table", {
			"status": "PAID",
			"owner": "player",
			"expected_by": "wednesday_social_set",
			"created_by": "chapter_08_marie_black_dress",
			"resolved_by": DAY_NINE_SOCIAL_CONVERSATION_ID,
			"result": "table_held_to_2045",
		})
	elif flags.has("marie_m4_private_thursday"):
		GameState.set_obligation_status(NAMED_LEDGER_ID, "marie_thursday_private_continuation", {
			"status": "SCHEDULED",
			"owner": "player",
			"expected_by": "thursday_private_continuation",
			"created_by": "chapter_08_marie_black_dress",
			"resolved_by": "",
			"result": "",
		})

func _activate_authored_beat_silently(day_value, phase: Dictionary) -> void:
	if str(phase.get("id", "")) != "wednesday_visual_contract_close":
		await super._activate_authored_beat_silently(day_value, phase)
		return
	transition_in_progress = true
	var phase_id := str(phase.get("id", ""))
	TimelineState.set_current_phase(day_value, phase_id)
	var contract: Dictionary = DataLoader.get_index_for_day(DAY_NINE).get("daily_visual_contract", {})
	var result: Dictionary = VisualDayContract.evaluate(contract, GameState.current_state.get("unlocked_content", []), DataLoader.visual_content_by_id)
	if not bool(result.get("satisfied", false)):
		push_error("Day 9 visual contract blocked: %s" % str(result.get("blocking_reasons", [])))
		transition_in_progress = false
		_render_active_day(day_value)
		_render_days_buttons_only()
		return
	TimelineState.complete_phase(day_value, phase_id)
	transition_in_progress = false
	_render_active_day(day_value)
	_render_days_buttons_only()
	await _advance_after_phase(day_value, phase_id)
