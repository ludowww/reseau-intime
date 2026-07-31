extends RefCounted

class_name J10RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j10_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const RUNTIME_UNREAD := preload("res://scripts/runtime/season_1/RuntimeUnread.gd")
const PIVOT_SELECTOR := preload("res://scripts/runtime/season_1/J10PivotSelector.gd")
const SNAPSHOT_VERSION := 1

const MARIE_THREAD := "thread_marie_private"
const SANDRA_THREAD := "thread_sandra_private"
const MATHILDE_THREAD := "thread_mathilde_private"
const RAPHAELLE_THREAD := "thread_raphaelle_private"
const NICO_THREAD := "thread_nico_private"

const SANDRA_CAFE_ASSET := "S1_A3_J10_SCN_SANDRA_CAFE_HELD_01"
const MATHILDE_OUTFIT_ASSET := "S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01"
const MATHILDE_RESULT_ASSET := "S1_A3_J10_SCN_MATHILDE_SOCIAL_RESULT_01"
const RAPHAELLE_DETAIL_ASSET := "S1_A3_J10_DPH_RAPHAELLE_PROCESS_DETAIL_01"
const RAPHAELLE_COMPARISON_ASSET := "S1_A3_J10_DPH_RAPHAELLE_PROCESS_COMPARISON_02"
const ANNEXE_MARIE_ASSET := "S1_A3_J10_DPH_ANNEXE_MARIE_PUBLIC_01"
const ANNEXE_MATHILDE_ASSET := "S1_A3_J10_DPH_ANNEXE_MATHILDE_PUBLIC_01"

var state
var runtime_map: Dictionary = {}
var conversations: Dictionary = {}
var segments_by_id: Dictionary = {}
var transcripts_by_thread: Dictionary = {}
var produced_message_ids: Dictionary = {}
var unlocked_thread_ids: Array[String] = []
var gallery_asset_ids: Array[String] = []
var served_visual_beat_ids: Array[String] = []
var pending_choice_ids_by_thread: Dictionary = {}
var pending_transition: Dictionary = {}
var phase := "day_start_pending"
var current_time_minutes := -1
var presented_time_message_ids: Dictionary = {}
var selection_audit: Dictionary = {}
var resume_after_evening := ""
var initialized := false

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	state = shared_state
	runtime_map = DataLoader.load_json(RUNTIME_MAP_PATH)
	if runtime_map.is_empty():
		return false
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get("initial_time", "")))
	if current_time_minutes < 0:
		return false
	for conversation_id in runtime_map.get("conversation_paths", {}):
		var conversation: Dictionary = DataLoader.load_json(str(runtime_map["conversation_paths"][conversation_id]))
		if conversation.is_empty():
			return false
		conversations[str(conversation_id)] = conversation
		for segment in conversation.get("segments", []):
			var segment_id := str(segment.get("id", ""))
			if segment_id == "" or segments_by_id.has(segment_id):
				return false
			segments_by_id[segment_id] = segment
	transcripts_by_thread = cumulative_transcripts.duplicate(true)
	produced_message_ids = cumulative_ids.duplicate(true)
	unlocked_thread_ids.assign(cumulative_threads)
	gallery_asset_ids.assign(cumulative_gallery_ids)
	served_visual_beat_ids = []
	pending_choice_ids_by_thread = {}
	pending_transition = {}
	presented_time_message_ids = {}
	selection_audit = {}
	resume_after_evening = ""
	initialized = true
	return true

func day_start_presentation() -> Dictionary:
	return runtime_map.get("day_start", {}).duplicate(true)

func current_narrative_day_short() -> String:
	return str(runtime_map.get("narrative_day_short", ""))

func current_narrative_time_minutes() -> int:
	return current_time_minutes

func current_narrative_time_text() -> String:
	return NARRATIVE_TIME.format_narrative_time(current_time_minutes)

func presentation_source() -> Dictionary:
	var threads: Array[Dictionary] = []
	var choices: Dictionary = {}
	var transcripts: Dictionary = {}
	for id in unlocked_thread_ids:
		threads.append(_thread_presentation(id))
		choices[id] = choices_for(id)
		transcripts[id] = transcript_for(id)
	return {
		"characters": _characters(),
		"threads": threads,
		"messages_by_thread": transcripts,
		"choices_by_thread": choices,
		"narrative_day_short": current_narrative_day_short(),
		"narrative_time": current_narrative_time_text(),
		"narrative_time_minutes": current_time_minutes,
	}

func start_day() -> Dictionary:
	if phase != "day_start_pending" or not state.begin_j10():
		return {"accepted": false}
	var p09: Dictionary = state.promises.get("marie_j09_dinner_j10_2030", {})
	var p10: Dictionary = state.promises.get("marie_j09_dinner_friday_2030", {})
	if str(p09.get("status", "")) == "ACTIVE":
		_enter_segment(MARIE_THREAD, "j10_marie_thursday_morning", "marie_morning_incoming")
		return _incoming_result(MARIE_THREAD)
	if str(p10.get("status", "")) == "ACTIVE":
		_enter_segment(MARIE_THREAD, "j10_marie_friday_morning", "marie_morning_incoming")
		return _incoming_result(MARIE_THREAD)
	return _continue_after_marie_morning()

func confirm_day_transition() -> Dictionary:
	return start_day() if phase == "day_start_pending" else {"accepted": false}

func transcript_for(thread_id: String) -> Array[Dictionary]:
	return _dictionary_array(transcripts_by_thread.get(thread_id, []))

func choices_for(thread_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var ids: Array = pending_choice_ids_by_thread.get(thread_id, [])
	for segment in segments_by_id.values():
		for choice in segment.get("choices", []):
			if ids.has(str(choice.get("id", ""))):
				result.append({
					"choice_id": str(choice.get("id", "")),
					"text": str(choice.get("text", "")),
					"enabled": true,
					"confirmation_required": false,
				})
	return result

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id):
		return {"accepted": false}
	var selected := _choice_by_id(choice_id)
	if selected.is_empty() or not _apply_state_choice(choice_id):
		return {"accepted": false}
	pending_choice_ids_by_thread[thread_id] = []
	var before := transcript_for(thread_id).size()
	var response_messages: Array = selected.get("next_messages", [])
	var choice_timestamp := current_narrative_time_text()
	if not response_messages.is_empty():
		choice_timestamp = str(response_messages[0].get("time_label", choice_timestamp))
	_append_player_choice(thread_id, choice_id, str(selected.get("text", "")), choice_timestamp)
	_append_messages(thread_id, response_messages)
	var direct_result := _advance_after_choice(choice_id)
	var result := {
		"accepted": true,
		"new_messages": transcript_for(thread_id).slice(before),
		"choices": choices_for(thread_id),
		"transition": pending_transition.duplicate(true),
	}
	if not direct_result.is_empty():
		for key in direct_result:
			result[key] = direct_result[key]
	return result

func expire_nico_morning_confirmation() -> Dictionary:
	if phase != "nico_morning_choice" or not pending_transition.is_empty() or not state.expire_j10_nico_morning_confirmation():
		return {"accepted": false}
	pending_choice_ids_by_thread[NICO_THREAD] = []
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time("12:00")
	return _select_and_schedule_pivot()

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty():
		return {"accepted": false}
	var kind := str(pending_transition.get("kind", ""))
	pending_transition = {}
	match kind:
		"to_nico_morning":
			_enter_segment(NICO_THREAD, "j10_nico_morning_confirmation", "nico_morning_incoming")
			return _incoming_result(NICO_THREAD)
		"to_sandra":
			_enter_segment(SANDRA_THREAD, "j10_sandra_opening", "sandra_open_incoming")
			return _incoming_result(SANDRA_THREAD)
		"to_mathilde":
			if not state.establish_j10_mathilde_records():
				return {"accepted": false}
			_unlock_visual(MATHILDE_OUTFIT_ASSET)
			_enter_segment(MATHILDE_THREAD, "j10_mathilde_opening", "mathilde_open_incoming")
			return _incoming_result(MATHILDE_THREAD)
		"to_raphaelle":
			_enter_segment(RAPHAELLE_THREAD, "j10_raphaelle_opening", "raphaelle_open_incoming")
			return _incoming_result(RAPHAELLE_THREAD)
		"to_nico_1812":
			_enter_segment(NICO_THREAD, "j10_nico_1812", "nico_1812_incoming")
			return _incoming_result(NICO_THREAD)
		"to_nico_common":
			return _enter_nico_common(false)
		"sandra_cafe_off_phone":
			_unlock_visual(SANDRA_CAFE_ASSET)
			_enter_segment(SANDRA_THREAD, "j10_sandra_after_cafe", "sandra_after_incoming")
			return _incoming_result(SANDRA_THREAD)
		"raphaelle_comparison":
			_unlock_visual(RAPHAELLE_DETAIL_ASSET)
			_unlock_visual(RAPHAELLE_COMPARISON_ASSET)
			_enter_segment(RAPHAELLE_THREAD, "j10_raphaelle_comparison", "raphaelle_compare_incoming")
			return _incoming_result(RAPHAELLE_THREAD)
		"raphaelle_visit_off_phone":
			_enter_segment(RAPHAELLE_THREAD, "j10_raphaelle_visit_after", "raphaelle_visit_after_incoming")
			return _incoming_result(RAPHAELLE_THREAD)
		"nico_meeting_off_phone":
			if not state.pay_j10_nico_meeting():
				return {"accepted": false}
			return _enter_nico_common(true)
		"to_ordinary_evening":
			return _enter_evening(false)
		"to_due_dinner":
			return _enter_evening(true)
		"dinner_off_phone":
			return _resume_after_evening()
		"to_mathilde_after":
			_enter_segment(MATHILDE_THREAD, _mathilde_after_segment(), "mathilde_after_incoming")
			return _incoming_result(MATHILDE_THREAD)
		"day_close":
			if not state.complete_j10():
				return {"accepted": false}
			if TimelineState != null:
				TimelineState.mark_day_complete(10)
			phase = "complete"
			return {"accepted": true, "destination": "day_end", "day_end": runtime_map["day_end"].duplicate(true)}
	return {"accepted": false}

func on_thread_returned(_thread_id: String) -> Dictionary:
	return pending_transition.duplicate(true) if not pending_transition.is_empty() else {}

func mark_message_presented(message_id: String) -> bool:
	if message_id == "" or presented_time_message_ids.has(message_id):
		return false
	var timestamp := ""
	for thread_id in transcripts_by_thread:
		for message in transcripts_by_thread[thread_id]:
			if str(message.get("message_id", "")) == message_id:
				timestamp = str(message.get("timestamp", ""))
				break
		if timestamp != "":
			break
	presented_time_message_ids[message_id] = true
	var candidate := NARRATIVE_TIME.parse_narrative_time(timestamp)
	if candidate >= current_time_minutes:
		current_time_minutes = candidate
	return true

func mark_thread_batch_presented(thread_id: String) -> bool:
	if not _phase_accepts_batch() or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 10):
		return false
	match phase:
		"marie_morning_incoming":
			phase = "marie_morning_choice"
		"nico_morning_incoming":
			phase = "nico_morning_choice"
		"sandra_open_incoming":
			phase = "sandra_open_choice"
		"sandra_after_incoming":
			phase = "sandra_after_choice"
		"mathilde_open_incoming":
			phase = "mathilde_open_choice"
		"mathilde_after_incoming":
			phase = "mathilde_after_choice"
		"raphaelle_open_incoming":
			phase = "raphaelle_open_choice"
		"raphaelle_compare_incoming":
			phase = "raphaelle_compare_choice"
		"raphaelle_visit_after_incoming":
			_after_external_pivot()
		"nico_1812_incoming":
			phase = "nico_1812_choice"
		"nico_common_incoming":
			phase = "nico_guided_choice"
		"evening_incoming":
			phase = "evening_choice"
	return true

func commit_narrative_time(minutes: int) -> bool:
	if minutes < current_time_minutes or NARRATIVE_TIME.format_narrative_time(minutes) == "":
		return false
	current_time_minutes = minutes
	if phase == "nico_morning_choice" and minutes >= NARRATIVE_TIME.parse_narrative_time("12:00"):
		if not state.expire_j10_nico_morning_confirmation():
			return false
		pending_choice_ids_by_thread[NICO_THREAD] = []
		return bool(_select_and_schedule_pivot().get("accepted", false))
	return true

func gallery_source() -> Dictionary:
	var fixtures := {
		"marie": _gallery_character("marie", "Marie", "#4F8BFF", "M"),
		"sandra": _gallery_character("sandra", "Sandra", "#20C7C9", "S"),
		"mathilde": _gallery_character("mathilde", "Mathilde", "#E070A8", "M"),
		"raphaelle": _gallery_character("raphaelle", "Raphaëlle", "#D69A42", "R"),
		"pauline": _gallery_character("pauline", "Pauline", "#E6B84A", "P"),
		"nico": _gallery_character("nico", "Nico", "#65B87A", "N"),
	}
	var all_assets: Array = []
	for day in range(2, 11):
		all_assets.append_array(DataLoader.load_json("res://data/runtime/season_1/j%02d_runtime_map.json" % day).get("gallery_presentations", []))
	for asset in all_assets:
		if not gallery_asset_ids.has(str(asset.get("asset_id", ""))):
			continue
		for character_id in asset.get("character_ids", []):
			var character: Dictionary = fixtures.get(str(character_id), {})
			if character.is_empty():
				continue
			var items: Array = character["items"]
			var item := _gallery_item(asset, str(character_id), items.size())
			item["resolved_variant_id"] = str(state.resolved_visual_variant_by_asset.get(str(asset.get("asset_id", "")), ""))
			items.append(item)
			character["items"] = items
	return {
		"fixtures": fixtures,
		"character_order": ["marie", "sandra", "mathilde", "raphaelle", "pauline", "nico"],
		"empty_label": "Aucun visuel disponible.",
	}

func snapshot() -> Dictionary:
	return {
		"version": SNAPSHOT_VERSION,
		"phase": phase,
		"transcripts_by_thread": transcripts_by_thread.duplicate(true),
		"produced_message_ids": produced_message_ids.duplicate(true),
		"unlocked_thread_ids": unlocked_thread_ids.duplicate(),
		"gallery_asset_ids": gallery_asset_ids.duplicate(),
		"served_visual_beat_ids": served_visual_beat_ids.duplicate(),
		"pending_choice_ids_by_thread": pending_choice_ids_by_thread.duplicate(true),
		"pending_transition": pending_transition.duplicate(true),
		"current_time_minutes": current_time_minutes,
		"presented_time_message_ids": presented_time_message_ids.duplicate(true),
		"selection_audit": selection_audit.duplicate(true),
		"resume_after_evening": resume_after_evening,
	}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION:
		return false
	var allowed_phases := [
		"day_start_pending", "marie_morning_incoming", "marie_morning_choice", "to_nico_morning",
		"nico_morning_incoming", "nico_morning_choice", "to_sandra", "sandra_open_incoming",
		"sandra_open_choice", "sandra_cafe_off_phone", "sandra_after_incoming", "sandra_after_choice",
		"to_mathilde", "mathilde_open_incoming", "mathilde_open_choice", "to_mathilde_after",
		"mathilde_after_incoming", "mathilde_after_choice", "to_raphaelle", "raphaelle_open_incoming", "raphaelle_open_choice",
		"raphaelle_comparison", "raphaelle_compare_incoming", "raphaelle_compare_choice",
		"raphaelle_visit_choice",
		"raphaelle_visit_off_phone", "raphaelle_visit_after_incoming", "to_nico_1812",
		"nico_1812_incoming", "nico_1812_choice", "nico_meeting_off_phone", "to_nico_common",
		"nico_common_incoming", "nico_guided_choice", "nico_main_choice", "to_ordinary_evening", "to_due_dinner",
		"evening_incoming", "evening_choice", "dinner_off_phone", "day_close", "complete",
	]
	if str(value.get("phase", "")) not in allowed_phases:
		return false
	for key in ["transcripts_by_thread", "produced_message_ids", "pending_choice_ids_by_thread", "pending_transition", "presented_time_message_ids", "selection_audit"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY:
			return false
	for key in ["unlocked_thread_ids", "gallery_asset_ids", "served_visual_beat_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY:
			return false
	if str(value.get("resume_after_evening", "")) not in ["", "day_close", "mathilde_after", "nico_common"]:
		return false
	var restored_time := int(value.get("current_time_minutes", -1))
	if NARRATIVE_TIME.format_narrative_time(restored_time) == "":
		return false
	phase = str(value["phase"])
	transcripts_by_thread = value["transcripts_by_thread"].duplicate(true)
	produced_message_ids = value["produced_message_ids"].duplicate(true)
	unlocked_thread_ids.assign(value["unlocked_thread_ids"])
	gallery_asset_ids.assign(value["gallery_asset_ids"])
	served_visual_beat_ids.assign(value["served_visual_beat_ids"])
	pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true)
	pending_transition = value["pending_transition"].duplicate(true)
	current_time_minutes = restored_time
	presented_time_message_ids = value["presented_time_message_ids"].duplicate(true)
	selection_audit = value["selection_audit"].duplicate(true)
	resume_after_evening = str(value["resume_after_evening"])
	return _restored_phase_consistent()

func presentation_count_by_id(id: String) -> int:
	var count := 0
	for thread in transcripts_by_thread:
		for item in transcripts_by_thread[thread]:
			if str(item.get("message_id", "")) == id:
				count += 1
	return count

func _apply_state_choice(choice_id: String) -> bool:
	if choice_id.begins_with("choice_j10_marie_"):
		return state.apply_j10_marie_morning_choice(choice_id)
	if choice_id.begins_with("choice_j10_nico_morning_"):
		return state.apply_j10_nico_morning_choice(choice_id)
	if choice_id == "choice_j10_sandra_accept_now":
		return state.record_j10_choice(choice_id, [choice_id])
	if choice_id in ["choice_j10_sandra_saturday", "choice_j10_sandra_close", "choice_j10_sandra_calm_presence", "choice_j10_sandra_missing_named", "choice_j10_sandra_friendship_bounded"]:
		return state.apply_j10_sandra_outcome(choice_id)
	if choice_id in ["choice_j10_mathilde_after_precise_guided", "choice_j10_mathilde_after_effect_guided", "choice_j10_mathilde_after_weather_guided"]:
		return state.record_j10_choice(choice_id, [choice_id])
	if choice_id.begins_with("choice_j10_mathilde_"):
		return state.apply_j10_mathilde_outcome(choice_id)
	if choice_id == "choice_j10_raphaelle_process":
		return state.record_j10_choice(choice_id, [choice_id])
	if choice_id == "choice_j10_raphaelle_comparison_guided":
		return state.record_j10_choice(choice_id, [choice_id])
	if choice_id in ["choice_j10_raphaelle_result", "choice_j10_raphaelle_boundary", "choice_j10_raphaelle_visit", "choice_j10_raphaelle_remote"]:
		return state.apply_j10_raphaelle_outcome(choice_id)
	if choice_id.begins_with("choice_j10_nico_1812_"):
		return state.apply_j10_nico_1812_choice(choice_id)
	if choice_id in ["choice_j10_nico_core_guided", "choice_j10_nico_core_guided_after_meeting"]:
		return state.record_j10_choice(choice_id, [choice_id])
	if choice_id in ["choice_j10_nico_difference", "choice_j10_nico_observation", "choice_j10_nico_close"]:
		return state.apply_j10_nico_outcome(choice_id)
	if choice_id.begins_with("choice_j10_dinner_") or choice_id.begins_with("choice_j10_fallback_"):
		return state.apply_j10_evening_choice(choice_id)
	return false

func _advance_after_choice(choice_id: String) -> Dictionary:
	if choice_id.begins_with("choice_j10_marie_"):
		return _continue_after_marie_morning()
	if choice_id.begins_with("choice_j10_nico_morning_"):
		return _select_and_schedule_pivot()
	if choice_id == "choice_j10_sandra_accept_now":
		_schedule_transition("sandra_cafe_off_phone")
	elif choice_id in ["choice_j10_sandra_saturday", "choice_j10_sandra_close"]:
		_after_external_pivot()
	elif choice_id in ["choice_j10_sandra_calm_presence", "choice_j10_sandra_missing_named", "choice_j10_sandra_friendship_bounded"]:
		_after_external_pivot()
	elif choice_id in ["choice_j10_mathilde_after_precise_guided", "choice_j10_mathilde_after_effect_guided", "choice_j10_mathilde_after_weather_guided"]:
		_schedule_day_close()
	elif choice_id.begins_with("choice_j10_mathilde_"):
		_unlock_visual(MATHILDE_RESULT_ASSET)
		_schedule_evening("mathilde_after")
	elif choice_id == "choice_j10_raphaelle_process":
		_schedule_transition("raphaelle_comparison")
	elif choice_id == "choice_j10_raphaelle_comparison_guided":
		_set_pending_segment_choices("j10_raphaelle_visit_choice", RAPHAELLE_THREAD)
		phase = "raphaelle_visit_choice"
	elif choice_id in ["choice_j10_raphaelle_result", "choice_j10_raphaelle_boundary", "choice_j10_raphaelle_remote"]:
		_after_external_pivot()
	elif choice_id == "choice_j10_raphaelle_visit":
		_schedule_transition("raphaelle_visit_off_phone")
	elif choice_id == "choice_j10_nico_1812_keep":
		_schedule_transition("nico_meeting_off_phone")
	elif choice_id == "choice_j10_nico_1812_cancel":
		_after_external_pivot()
	elif choice_id in ["choice_j10_nico_core_guided", "choice_j10_nico_core_guided_after_meeting"]:
		_set_pending_segment_choices("j10_nico_main_choice", NICO_THREAD)
		phase = "nico_main_choice"
	elif choice_id in ["choice_j10_nico_difference", "choice_j10_nico_observation", "choice_j10_nico_close"]:
		_after_external_pivot()
	elif choice_id.begins_with("choice_j10_dinner_"):
		_schedule_transition("dinner_off_phone")
	elif choice_id.begins_with("choice_j10_fallback_"):
		return _resume_after_evening()
	return {}

func _continue_after_marie_morning() -> Dictionary:
	var p07: Dictionary = state.promises.get("nico_j07_thursday_conditional", {})
	if str(p07.get("status", "")) == "CONDITIONAL":
		_schedule_transition("to_nico_morning")
		return _transition_result()
	return _select_and_schedule_pivot()

func _select_and_schedule_pivot() -> Dictionary:
	var selector = PIVOT_SELECTOR.new()
	selection_audit = selector.select(state.snapshot())
	if selection_audit.is_empty() or not state.set_j10_pivot_selection(str(selection_audit.get("pivot", "")), str(selection_audit.get("reason", ""))):
		return {"accepted": false}
	match state.j10_pivot:
		"SANDRA":
			_schedule_transition("to_sandra")
		"MATHILDE":
			_schedule_transition("to_mathilde")
		"RAPHAELLE":
			_schedule_transition("to_raphaelle")
		"NICO":
			var p07: Dictionary = state.promises.get("nico_j07_thursday_conditional", {})
			if str(p07.get("status", "")) == "ACTIVE" and str(p07.get("due_at", "")) == "J10 18:20":
				_schedule_transition("to_nico_1812")
			else:
				_schedule_evening("nico_common")
		"NONE":
			_schedule_evening("day_close")
	return _transition_result()

func _enter_nico_common(after_meeting: bool) -> Dictionary:
	_unlock_visual(ANNEXE_MARIE_ASSET)
	_unlock_visual(ANNEXE_MATHILDE_ASSET)
	_enter_segment(NICO_THREAD, "j10_nico_common_after_meeting" if after_meeting else "j10_nico_common", "nico_common_incoming")
	return _incoming_result(NICO_THREAD)

func _enter_evening(dinner_due: bool) -> Dictionary:
	var segment_id := "j10_marie_due_dinner" if dinner_due else "j10_marie_ordinary_meal"
	_enter_segment(MARIE_THREAD, segment_id, "evening_incoming")
	return _incoming_result(MARIE_THREAD)

func _resume_after_evening() -> Dictionary:
	var resume := resume_after_evening
	resume_after_evening = ""
	match resume:
		"mathilde_after":
			_schedule_transition("to_mathilde_after")
		"nico_common":
			_schedule_transition("to_nico_common")
		"day_close":
			_schedule_day_close()
		_:
			return {"accepted": false}
	return _transition_result()

func _after_external_pivot() -> void:
	_schedule_evening("day_close")

func _schedule_evening(resume: String) -> void:
	resume_after_evening = resume
	var transition_key := "to_due_dinner" if _thursday_dinner_due() else "to_ordinary_evening"
	var target_minutes := NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get(transition_key, {}).get("to_time", "")))
	if target_minutes < current_time_minutes:
		_resume_after_evening()
		return
	_schedule_transition(transition_key)

func _schedule_day_close() -> void:
	_schedule_transition("day_close")

func _thursday_dinner_due() -> bool:
	return str(state.promises.get("marie_j09_dinner_j10_2030", {}).get("status", "")) == "ACTIVE"

func _mathilde_after_segment() -> String:
	return {
		"OUTFIT_PRECISE_NON_APPROPRIATIVE": "j10_mathilde_after_precise",
		"OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED": "j10_mathilde_after_effect",
		"OUTFIT_PRACTICAL_WEATHER": "j10_mathilde_after_weather",
	}.get(state.j10_pivot_outcome, "")

func _phase_accepts_batch() -> bool:
	return phase in [
		"marie_morning_incoming", "nico_morning_incoming", "sandra_open_incoming",
		"sandra_after_incoming", "mathilde_open_incoming", "mathilde_after_incoming",
		"raphaelle_open_incoming", "raphaelle_compare_incoming", "raphaelle_visit_after_incoming",
		"nico_1812_incoming", "nico_common_incoming", "evening_incoming",
	]

func _enter_segment(thread_id: String, segment_id: String, incoming_phase: String) -> void:
	_unlock_thread(thread_id)
	var segment: Dictionary = segments_by_id.get(segment_id, {})
	_append_messages(thread_id, segment.get("messages", []))
	var ids: Array[String] = []
	for choice in segment.get("choices", []):
		ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids
	phase = incoming_phase

func _set_pending_segment_choices(segment_id: String, thread_id: String) -> void:
	var ids: Array[String] = []
	for choice in segments_by_id.get(segment_id, {}).get("choices", []):
		ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids

func _choice_by_id(choice_id: String) -> Dictionary:
	for segment in segments_by_id.values():
		for choice in segment.get("choices", []):
			if str(choice.get("id", "")) == choice_id:
				return choice
	return {}

func _append_player_choice(thread_id: String, choice_id: String, text: String, timestamp: String) -> void:
	_append(thread_id, {
		"message_id": choice_id + "_player",
		"author_id": "player",
		"timestamp": timestamp,
		"content_type": "TEXT",
		"text": text,
		"media_ref": "",
		"is_player": true,
		"is_read": true,
		"source_day": 10,
	})

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var author := str(message.get("sender", "system"))
		_append(thread_id, {
			"message_id": str(message.get("id", "")),
			"author_id": author,
			"timestamp": str(message.get("time_label", "")),
			"content_type": str(message.get("content_type", "TEXT")),
			"text": str(message.get("text", "")),
			"media_ref": str(message.get("media_ref", "")),
			"is_player": author == "player",
			"is_read": author == "player",
			"source_day": 10,
		})

func _append(thread_id: String, item: Dictionary) -> bool:
	var id := str(item.get("message_id", ""))
	if id == "" or produced_message_ids.has(id):
		return false
	var transcript: Array = transcripts_by_thread.get(thread_id, [])
	transcript.append(item.duplicate(true))
	transcripts_by_thread[thread_id] = transcript
	produced_message_ids[id] = true
	return true

func _schedule_transition(key: String) -> void:
	phase = key
	pending_transition = _transition(key)

func _transition(key: String) -> Dictionary:
	var result: Dictionary = runtime_map.get(key, {}).duplicate(true)
	result["kind"] = key
	result["from_time"] = current_narrative_time_text()
	return result

func _transition_result() -> Dictionary:
	return {"accepted": true, "destination": "timeline", "transition": pending_transition.duplicate(true)}

func _incoming_result(thread_id: String) -> Dictionary:
	return {
		"accepted": true,
		"destination": "conversation",
		"thread_id": thread_id,
		"notification": {"body": "Nouveau message !"},
	}

func _unlock_thread(id: String) -> void:
	if not unlocked_thread_ids.has(id):
		unlocked_thread_ids.append(id)

func _unlock_visual(id: String) -> void:
	if not gallery_asset_ids.has(id):
		gallery_asset_ids.append(id)
	if not served_visual_beat_ids.has(id):
		served_visual_beat_ids.append(id)

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending":
		return state.current_day == "J09" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.current_day != "J10":
		return false
	if phase == "complete":
		return state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.day_status != "ACTIVE":
		return false
	var transition_phases := [
		"to_nico_morning", "to_sandra", "sandra_cafe_off_phone", "to_mathilde",
		"to_mathilde_after", "to_raphaelle", "raphaelle_comparison", "raphaelle_visit_off_phone",
		"to_nico_1812", "nico_meeting_off_phone", "to_nico_common", "to_ordinary_evening", "to_due_dinner",
		"dinner_off_phone", "day_close",
	]
	return not pending_transition.is_empty() if phase in transition_phases else pending_transition.is_empty()

func _thread_presentation(id: String) -> Dictionary:
	var titles := {MARIE_THREAD: "Marie", SANDRA_THREAD: "Sandra", MATHILDE_THREAD: "Mathilde", RAPHAELLE_THREAD: "Raphaëlle", NICO_THREAD: "Nico", "thread_pauline_private": "Pauline"}
	var participants := {MARIE_THREAD: "marie", SANDRA_THREAD: "sandra", MATHILDE_THREAD: "mathilde", RAPHAELLE_THREAD: "raphaelle", NICO_THREAD: "nico", "thread_pauline_private": "pauline"}
	var colors := {MARIE_THREAD: "#4F8BFF", SANDRA_THREAD: "#20C7C9", MATHILDE_THREAD: "#E070A8", RAPHAELLE_THREAD: "#D69A42", NICO_THREAD: "#65B87A", "thread_pauline_private": "#E6B84A"}
	var transcript := transcript_for(id)
	var last: Dictionary = {}
	var unread := RUNTIME_UNREAD.incoming_unread_count(transcript, presented_time_message_ids, 10)
	for item in transcript:
		if str(item.get("content_type", "")) != "OFF_PHONE_TRANSITION":
			last = item
	var title := str(titles.get(id, ""))
	return {
		"thread_id": id,
		"title": title,
		"participant_ids": [str(participants.get(id, "")), "player"],
		"last_preview": "Nouveau message !" if unread > 0 else str(last.get("text", "")),
		"last_timestamp": str(last.get("timestamp", "")),
		"unread_count": unread,
		"has_unread_content": unread > 0,
		"availability_state": "AVAILABLE",
		"is_group": false,
		"is_archived": false,
		"avatar_ref": title.left(1),
		"accent_color": str(colors.get(id, "#8D63E6")),
	}

func _characters() -> Dictionary:
	return {
		"marie": _character("marie", "Marie", "#4F8BFF", "M"),
		"sandra": _character("sandra", "Sandra", "#20C7C9", "S"),
		"mathilde": _character("mathilde", "Mathilde", "#E070A8", "M"),
		"raphaelle": _character("raphaelle", "Raphaëlle", "#D69A42", "R"),
		"pauline": _character("pauline", "Pauline", "#E6B84A", "P"),
		"nico": _character("nico", "Nico", "#65B87A", "N"),
		"player": _character("player", "Player", "#8D63E6", ""),
	}

func _character(id: String, title: String, accent: String, avatar: String) -> Dictionary:
	return {"character_id": id, "display_name": title, "accent_color": accent, "avatar_ref": avatar, "gallery_enabled": false}

func _gallery_character(id: String, title: String, accent: String, avatar: String) -> Dictionary:
	return {"character_id": id, "display_name": title, "accent_color": Color.from_string(accent, Color.WHITE), "avatar_ref": avatar, "items": []}

func _gallery_item(asset: Dictionary, character_id: String, index: int) -> Dictionary:
	return {
		"item_id": str(asset.get("asset_id", "")),
		"asset_id": str(asset.get("asset_id", "")),
		"character_id": character_id,
		"state": "UNLOCKED",
		"is_new": true,
		"sort_key": index,
		"thumbnail_ref": "",
		"full_ref": "",
		"thumbnail_label": str(asset.get("placeholder_label", "Visuel non produit")),
		"placeholder_label": str(asset.get("placeholder_label", "Visuel non produit")),
		"source_kind": str(asset.get("source_kind", "gallery")),
		"content_type": str(asset.get("content_type", "PHOTO")),
		"can_share": bool(asset.get("can_share", false)),
		"transfer_rule": str(asset.get("transfer_rule", "FORBIDDEN")),
		"is_diegetic": bool(asset.get("is_diegetic", true)),
	}

func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append(item.duplicate(true))
	return result
