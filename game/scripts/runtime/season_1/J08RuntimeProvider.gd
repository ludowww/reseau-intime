extends RefCounted

class_name J08RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j08_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const RUNTIME_UNREAD := preload("res://scripts/runtime/season_1/RuntimeUnread.gd")
const SNAPSHOT_VERSION := 1
const RAPHAELLE_THREAD := "thread_raphaelle_private"
const NICO_THREAD := "thread_nico_private"
const MARIE_THREAD := "thread_marie_private"
const RAPHAELLE_ASSET := "S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01"
const NICO_ASSET := "S1_A2_J08_SCN_NICO_CHAIR_STATE_01"
const HOUSEHOLD_ASSET := "S1_A2_J08_SCN_HOUSEHOLD_STATE_01"

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
var collision_pending_threads: Array[String] = []
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
	collision_pending_threads = []
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
	if phase != "day_start_pending" or not state.begin_j08():
		return {"accepted": false}
	_unlock_thread(MARIE_THREAD)
	_enter_segment(MARIE_THREAD, _entry_segment_id(), "marie_entry_incoming")
	return {
		"accepted": true,
		"destination": "list",
		"focus_thread_id": MARIE_THREAD,
		"notification": {"body": "Nouveau message !"},
	}

func transcript_for(thread_id: String) -> Array[Dictionary]:
	return _dictionary_array(transcripts_by_thread.get(thread_id, []))

func choices_for(thread_id: String) -> Array[Dictionary]:
	if phase == "priority_choice" and _priority_threads().has(thread_id):
		return _dictionary_array(runtime_map.get("priority_choices", []))
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
	if not pending_transition.is_empty():
		return {"accepted": false}
	if phase == "priority_choice":
		return _apply_priority_choice(thread_id, choice_id)
	if not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id):
		return {"accepted": false}
	var selected := _choice_by_id(choice_id)
	if selected.is_empty() or not _apply_standard_state_choice(choice_id):
		return {"accepted": false}
	pending_choice_ids_by_thread[thread_id] = []
	var before := transcript_for(thread_id).size()
	var response_messages: Array = selected.get("next_messages", [])
	var choice_timestamp := current_narrative_time_text()
	if not response_messages.is_empty():
		choice_timestamp = str(response_messages[0].get("time_label", choice_timestamp))
	_append_player_choice(thread_id, choice_id, str(selected.get("text", "")), choice_timestamp)
	if choice_id == "choice_j08_raphaelle_anticipate_now":
		var next_messages: Array = selected.get("next_messages", [])
		_append_messages(thread_id, next_messages.slice(0, 2))
		phase = "raphaelle_r1_off_phone"
		pending_transition = _transition("raphaelle_r1_off_phone")
	else:
		_append_messages(thread_id, selected.get("next_messages", []))
		_advance_after_standard_choice(choice_id)
	return {
		"accepted": true,
		"new_messages": transcript_for(thread_id).slice(before),
		"choices": choices_for(thread_id),
		"transition": pending_transition.duplicate(true),
	}

func confirm_day_transition() -> Dictionary:
	if phase == "day_start_pending":
		return start_day()
	return {"accepted": false}

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty():
		return {"accepted": false}
	var old_phase := phase
	pending_transition = {}
	match old_phase:
		"to_raphaelle":
			_unlock_thread(RAPHAELLE_THREAD)
			_enter_segment(RAPHAELLE_THREAD, "j08_raphaelle_preparation", "raphaelle_preparation_incoming")
			return _incoming_result(RAPHAELLE_THREAD)
		"raphaelle_r1_off_phone":
			var choice := _choice_by_id("choice_j08_raphaelle_anticipate_now")
			var messages: Array = choice.get("next_messages", [])
			_append_messages(RAPHAELLE_THREAD, messages.slice(2))
			phase = "raphaelle_r1_result_incoming"
			return _incoming_result(RAPHAELLE_THREAD)
		"to_nico":
			if state.is_j08_nico_due():
				_unlock_thread(NICO_THREAD)
				_enter_segment(NICO_THREAD, "j08_nico_reminder", "nico_reminder_incoming")
				return _incoming_result(NICO_THREAD)
			return _continue_after_nico()
		"to_state_b_household":
			_enter_segment(MARIE_THREAD, "j08_marie_state_b_early", "state_b_household_incoming")
			return _incoming_result(MARIE_THREAD)
		"state_b_off_phone":
			if not state.resolve_j08_state_b_household():
				return {"accepted": false}
			phase = "to_collision_after_household"
			pending_transition = _transition("to_collision_after_household")
			return {"accepted": true, "destination": "day_transition", "transition": pending_transition.duplicate(true)}
		"to_collision", "to_collision_after_household":
			_enter_collision()
			return _incoming_result(RAPHAELLE_THREAD)
		"to_household_return":
			_enter_household_return()
			return _incoming_result(MARIE_THREAD)
		"to_raphaelle_return":
			_enter_raphaelle_return()
			return _incoming_result(RAPHAELLE_THREAD)
		"to_nico_return":
			_enter_segment(NICO_THREAD, "j08_nico_return_paid", "nico_return_incoming")
			return _incoming_result(NICO_THREAD)
		"to_marie_close":
			_enter_marie_close()
			return _incoming_result(MARIE_THREAD)
		"day_close":
			if not state.complete_j08():
				return {"accepted": false}
			_unlock_final_visuals()
			if TimelineState != null:
				TimelineState.mark_day_complete(8)
			phase = "complete"
			return {"accepted": true, "destination": "day_end", "day_end": runtime_map["day_end"].duplicate(true)}
	return {"accepted": false}

func on_thread_returned(_thread_id: String) -> Dictionary:
	if not pending_transition.is_empty():
		return pending_transition.duplicate(true)
	return {}

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
	if not _phase_accepts_batch(thread_id):
		return false
	if not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 8):
		return false
	match phase:
		"marie_entry_incoming":
			phase = "marie_entry_choice"
		"raphaelle_preparation_incoming":
			phase = "raphaelle_preparation_choice"
		"raphaelle_r1_result_incoming":
			_begin_to_nico()
		"nico_reminder_incoming":
			phase = "nico_reminder_choice"
		"state_b_household_incoming":
			phase = "state_b_household_choice"
		"collision_incoming":
			collision_pending_threads.erase(thread_id)
			if collision_pending_threads.is_empty():
				_finish_collision_presentation()
		"fallback_resolution_incoming":
			_begin_to_household_return()
		"household_return_incoming":
			if pending_choice_ids_by_thread.get(MARIE_THREAD, []).is_empty():
				_continue_after_household_return()
			else:
				phase = "household_return_choice"
		"raphaelle_return_incoming":
			if pending_choice_ids_by_thread.get(RAPHAELLE_THREAD, []).is_empty():
				_continue_after_raphaelle_return()
			else:
				phase = "raphaelle_return_choice"
		"nico_return_incoming":
			phase = "nico_return_choice"
		"marie_close_incoming":
			phase = "marie_close_choice"
	return true

func commit_narrative_time(minutes: int) -> bool:
	if minutes < current_time_minutes or NARRATIVE_TIME.format_narrative_time(minutes) == "":
		return false
	current_time_minutes = minutes
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
	for day in range(2, 9):
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
		"collision_pending_threads": collision_pending_threads.duplicate(),
	}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION:
		return false
	var allowed_phases := [
		"day_start_pending", "marie_entry_incoming", "marie_entry_choice", "to_raphaelle",
		"raphaelle_preparation_incoming", "raphaelle_preparation_choice", "raphaelle_r1_off_phone",
		"raphaelle_r1_result_incoming", "to_nico", "nico_reminder_incoming", "nico_reminder_choice",
		"to_state_b_household", "state_b_household_incoming", "state_b_household_choice",
		"state_b_off_phone", "to_collision", "to_collision_after_household", "collision_incoming",
		"priority_choice", "fallback_resolution_incoming", "to_household_return",
		"household_return_incoming", "household_return_choice", "to_raphaelle_return",
		"raphaelle_return_incoming", "raphaelle_return_choice", "to_nico_return",
		"nico_return_incoming", "nico_return_choice", "to_marie_close", "marie_close_incoming",
		"marie_close_choice", "day_close", "complete",
	]
	if str(value.get("phase", "")) not in allowed_phases:
		return false
	for key in ["transcripts_by_thread", "produced_message_ids", "pending_choice_ids_by_thread", "pending_transition", "presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY:
			return false
	for key in ["unlocked_thread_ids", "gallery_asset_ids", "served_visual_beat_ids", "collision_pending_threads"]:
		if typeof(value.get(key)) != TYPE_ARRAY:
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
	collision_pending_threads.assign(value["collision_pending_threads"])
	return _restored_phase_consistent()

func presentation_count_by_id(id: String) -> int:
	var count := 0
	for thread in transcripts_by_thread:
		for item in transcripts_by_thread[thread]:
			if str(item.get("message_id", "")) == id:
				count += 1
	return count

func _apply_priority_choice(thread_id: String, choice_id: String) -> Dictionary:
	var concerned_threads := _priority_threads()
	var nico_was_due: bool = state.is_j08_nico_due()
	if not concerned_threads.has(thread_id):
		return {"accepted": false}
	var valid_ids := ["choice_j08_priority_oldest", "choice_j08_priority_immediate", "choice_j08_priority_vague"]
	var before := transcript_for(thread_id).size()
	if choice_id not in valid_ids or not state.apply_j08_priority_choice(choice_id):
		return {"accepted": false}
	for id in concerned_threads:
		pending_choice_ids_by_thread[id] = []
	_append_priority_resolution(choice_id, nico_was_due)
	_begin_to_household_return()
	return {
		"accepted": true,
		"new_messages": transcript_for(thread_id).slice(before),
		"choices": [],
		"transition": pending_transition.duplicate(true),
	}

func _apply_standard_state_choice(choice_id: String) -> bool:
	if choice_id.begins_with("choice_j08_marie_entry_"):
		return true
	if choice_id.begins_with("choice_j08_raphaelle_") and choice_id in [
		"choice_j08_raphaelle_anticipate_now",
		"choice_j08_raphaelle_schedule_1820",
		"choice_j08_raphaelle_vague",
	]:
		return state.apply_j08_raphaelle_preparation(choice_id)
	return choice_id in [
		"choice_j08_nico_reminder_guided",
		"choice_j08_marie_state_b_go_guided",
		"choice_j08_marie_return_paid_guided",
		"choice_j08_raphaelle_return_transfer_guided",
		"choice_j08_nico_return_paid_guided",
		"choice_j08_marie_bridge_warm_guided",
		"choice_j08_marie_bridge_cold_guided",
	]

func _advance_after_standard_choice(choice_id: String) -> void:
	if choice_id.begins_with("choice_j08_marie_entry_"):
		phase = "to_raphaelle"
		pending_transition = _transition("to_raphaelle")
	elif choice_id in ["choice_j08_raphaelle_schedule_1820", "choice_j08_raphaelle_vague"]:
		_begin_to_nico()
	elif choice_id == "choice_j08_nico_reminder_guided":
		_continue_after_nico()
	elif choice_id == "choice_j08_marie_state_b_go_guided":
		phase = "state_b_off_phone"
		pending_transition = _transition("state_b_off_phone")
	elif choice_id == "choice_j08_marie_return_paid_guided":
		_continue_after_household_return()
	elif choice_id == "choice_j08_raphaelle_return_transfer_guided":
		_continue_after_raphaelle_return()
	elif choice_id == "choice_j08_nico_return_paid_guided":
		_begin_to_marie_close()
	elif choice_id in ["choice_j08_marie_bridge_warm_guided", "choice_j08_marie_bridge_cold_guided"]:
		phase = "day_close"
		pending_transition = _transition("day_close")

func _continue_after_nico() -> Dictionary:
	if state.marie_j08_entry_outcome == "STATE_B":
		phase = "to_state_b_household"
		pending_transition = _transition("to_state_b_household")
	else:
		phase = "to_collision"
		pending_transition = _transition("to_collision")
	return {"accepted": true, "destination": "day_transition", "transition": pending_transition.duplicate(true)}

func _begin_to_nico() -> void:
	phase = "to_nico"
	pending_transition = _transition("to_nico")

func _enter_collision() -> void:
	var raph_segment := "j08_raphaelle_collision_anticipated" if state.raphaelle_j08_preparation_outcome == "ANTICIPATED" else "j08_raphaelle_collision_due"
	_append_segment_messages(RAPHAELLE_THREAD, raph_segment)
	collision_pending_threads = [RAPHAELLE_THREAD]
	if state.marie_j08_entry_outcome == "STATE_A":
		_append_segment_messages(MARIE_THREAD, "j08_marie_collision_state_a")
		collision_pending_threads.append(MARIE_THREAD)
	phase = "collision_incoming"

func _finish_collision_presentation() -> void:
	if state.j08_active_obligation_ids().size() >= 2:
		phase = "priority_choice"
		for id in _priority_threads():
			pending_choice_ids_by_thread[id] = [
				"choice_j08_priority_oldest",
				"choice_j08_priority_immediate",
				"choice_j08_priority_vague",
			]
		return
	if not state.resolve_j08_single_obligation():
		return
	var segment_id := "j08_raphaelle_priority_oldest_r1" if state.raphaelle_j08_preparation_outcome == "ANTICIPATED" else "j08_raphaelle_priority_oldest_due"
	_append_segment_messages(RAPHAELLE_THREAD, segment_id)
	_append_segment_messages(RAPHAELLE_THREAD, "j08_raphaelle_paid_on_time")
	phase = "fallback_resolution_incoming"

func _append_priority_resolution(choice_id: String, nico_was_due: bool) -> void:
	if choice_id == "choice_j08_priority_oldest":
		_append_segment_messages(RAPHAELLE_THREAD, "j08_raphaelle_priority_oldest_r1" if state.raphaelle_j08_preparation_outcome == "ANTICIPATED" else "j08_raphaelle_priority_oldest_due")
		_append_segment_messages(RAPHAELLE_THREAD, "j08_raphaelle_paid_late" if state.raphaelle_j08_work_resolution == "PAID_LATE" else "j08_raphaelle_paid_on_time")
		if nico_was_due:
			_append_segment_messages(NICO_THREAD, "j08_nico_cancel_oldest")
		if state.marie_j08_entry_outcome == "STATE_A":
			_append_segment_messages(MARIE_THREAD, "j08_marie_priority_oldest_state_a")
			if state.marie_j08_household_resolution == "FAILED_LATE_AMENDMENT":
				_append_segment_messages(MARIE_THREAD, "j08_marie_priority_oldest_state_a_late")
	elif choice_id == "choice_j08_priority_immediate":
		_append_segment_messages(RAPHAELLE_THREAD, "j08_raphaelle_priority_immediate_" + state.marie_j08_entry_outcome.to_lower().trim_prefix("state_"))
		if state.marie_j08_entry_outcome == "STATE_A":
			_append_segment_messages(MARIE_THREAD, "j08_marie_priority_immediate_state_a")
			if nico_was_due:
				_append_segment_messages(NICO_THREAD, "j08_nico_cancel_household")
		elif nico_was_due:
			_append_segment_messages(NICO_THREAD, "j08_nico_immediate_state_b" if state.marie_j08_entry_outcome == "STATE_B" else "j08_nico_immediate_state_c")
	else:
		_append_segment_messages(RAPHAELLE_THREAD, "j08_raphaelle_priority_vague")
		if nico_was_due:
			_append_segment_messages(NICO_THREAD, "j08_nico_priority_vague")
		if state.marie_j08_entry_outcome == "STATE_A":
			_append_segment_messages(MARIE_THREAD, "j08_marie_priority_vague_state_a")

func _begin_to_household_return() -> void:
	phase = "to_household_return"
	pending_transition = _transition("to_household_return")
	if state.nico_j08_meeting_resolution == "PAID_SHORT":
		pending_transition["flow_phases"] = ["OFF_PHONE", "CLOCK"]
		pending_transition["text"] = "Player rejoint Nico avant le service. Aucun dialogue oral n’est montré."

func _enter_household_return() -> void:
	var segment_id := "j08_marie_household_return_paid"
	if state.marie_j08_household_resolution in ["FAILED_LATE_AMENDMENT", "FAILED_VAGUE"]:
		segment_id = "j08_marie_household_return_failed"
	elif state.marie_j08_household_resolution == "REFUSAL_ABSORBED":
		segment_id = "j08_marie_household_return_refused"
	_enter_segment(MARIE_THREAD, segment_id, "household_return_incoming")

func _continue_after_household_return() -> void:
	if state.raphaelle_j08_work_resolution in ["TRANSFERRED_HONESTLY", "ABANDONED_VAGUELY"]:
		phase = "to_raphaelle_return"
		pending_transition = _transition("to_raphaelle_return")
	elif state.nico_j08_meeting_resolution == "PAID_SHORT":
		phase = "to_nico_return"
		pending_transition = _transition("to_nico_return")
	else:
		_begin_to_marie_close()

func _enter_raphaelle_return() -> void:
	var segment_id := "j08_raphaelle_return_transferred" if state.raphaelle_j08_work_resolution == "TRANSFERRED_HONESTLY" else "j08_raphaelle_return_abandoned"
	_enter_segment(RAPHAELLE_THREAD, segment_id, "raphaelle_return_incoming")

func _continue_after_raphaelle_return() -> void:
	if state.nico_j08_meeting_resolution == "PAID_SHORT":
		phase = "to_nico_return"
		pending_transition = _transition("to_nico_return")
	else:
		_begin_to_marie_close()

func _begin_to_marie_close() -> void:
	phase = "to_marie_close"
	pending_transition = _transition("to_marie_close")

func _enter_marie_close() -> void:
	var segment_id := "j08_marie_j09_bridge_cold" if state.marie_j08_echo_outcome == "VAGUE_OR_MISSED" else "j08_marie_j09_bridge_warm"
	_enter_segment(MARIE_THREAD, segment_id, "marie_close_incoming")

func _entry_segment_id() -> String:
	return {
		"STATE_A": "j08_marie_entry_state_a",
		"STATE_B": "j08_marie_entry_state_b",
		"STATE_C": "j08_marie_entry_state_c",
	}.get(state.marie_j08_entry_outcome, "")

func _priority_threads() -> Array[String]:
	var result: Array[String] = []
	if state.marie_j08_entry_outcome == "STATE_A":
		result.assign([RAPHAELLE_THREAD, MARIE_THREAD])
	elif state.is_j08_nico_due():
		result.assign([RAPHAELLE_THREAD, NICO_THREAD])
	return result

func _phase_accepts_batch(thread_id: String) -> bool:
	var expected := {
		"marie_entry_incoming": MARIE_THREAD,
		"raphaelle_preparation_incoming": RAPHAELLE_THREAD,
		"raphaelle_r1_result_incoming": RAPHAELLE_THREAD,
		"nico_reminder_incoming": NICO_THREAD,
		"state_b_household_incoming": MARIE_THREAD,
		"fallback_resolution_incoming": RAPHAELLE_THREAD,
		"household_return_incoming": MARIE_THREAD,
		"raphaelle_return_incoming": RAPHAELLE_THREAD,
		"nico_return_incoming": NICO_THREAD,
		"marie_close_incoming": MARIE_THREAD,
	}
	if phase == "collision_incoming":
		return collision_pending_threads.has(thread_id)
	return str(expected.get(phase, "")) == thread_id

func _enter_segment(thread_id: String, segment_id: String, incoming_phase: String) -> void:
	_unlock_thread(thread_id)
	var segment: Dictionary = segments_by_id.get(segment_id, {})
	_append_messages(thread_id, segment.get("messages", []))
	var ids: Array[String] = []
	for choice in segment.get("choices", []):
		ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids
	phase = incoming_phase

func _append_segment_messages(thread_id: String, segment_id: String) -> void:
	_append_messages(thread_id, segments_by_id.get(segment_id, {}).get("messages", []))

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
		"source_day": 8,
	})

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var author := str(message.get("sender", "system"))
		_append(thread_id, {
			"message_id": str(message.get("id", "")),
			"author_id": author,
			"timestamp": str(message.get("time_label", "")),
			"content_type": "TEXT",
			"text": str(message.get("text", "")),
			"media_ref": "",
			"is_player": author == "player",
			"is_read": author == "player",
			"source_day": 8,
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

func _transition(key: String) -> Dictionary:
	var result: Dictionary = runtime_map.get(key, {}).duplicate(true)
	result["kind"] = key
	result["from_time"] = current_narrative_time_text()
	return result

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

func _unlock_final_visuals() -> void:
	for id in [RAPHAELLE_ASSET, NICO_ASSET, HOUSEHOLD_ASSET]:
		if not gallery_asset_ids.has(id):
			gallery_asset_ids.append(id)
		if not served_visual_beat_ids.has(id):
			served_visual_beat_ids.append(id)

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending":
		return state.current_day == "J07" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.current_day != "J08":
		return false
	if phase == "complete":
		return state.day_status == "COMPLETE" and pending_transition.is_empty() and served_visual_beat_ids == [RAPHAELLE_ASSET, NICO_ASSET, HOUSEHOLD_ASSET]
	if state.day_status != "ACTIVE":
		return false
	var transition_phases := [
		"to_raphaelle", "raphaelle_r1_off_phone", "to_nico", "to_state_b_household",
		"state_b_off_phone", "to_collision", "to_collision_after_household", "to_household_return",
		"to_raphaelle_return", "to_nico_return", "to_marie_close", "day_close",
	]
	return not pending_transition.is_empty() if phase in transition_phases else pending_transition.is_empty()

func _thread_presentation(id: String) -> Dictionary:
	var titles := {MARIE_THREAD: "Marie", "thread_sandra_private": "Sandra", "thread_mathilde_private": "Mathilde", RAPHAELLE_THREAD: "Raphaëlle", "thread_pauline_private": "Pauline", NICO_THREAD: "Nico"}
	var participants := {MARIE_THREAD: "marie", "thread_sandra_private": "sandra", "thread_mathilde_private": "mathilde", RAPHAELLE_THREAD: "raphaelle", "thread_pauline_private": "pauline", NICO_THREAD: "nico"}
	var colors := {MARIE_THREAD: "#4F8BFF", "thread_sandra_private": "#20C7C9", "thread_mathilde_private": "#E070A8", RAPHAELLE_THREAD: "#D69A42", "thread_pauline_private": "#E6B84A", NICO_THREAD: "#65B87A"}
	var transcript := transcript_for(id)
	var last: Dictionary = {}
	var unread := RUNTIME_UNREAD.incoming_unread_count(transcript, presented_time_message_ids, 8)
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
		"content_type": str(asset.get("content_type", "SCENE_IMAGE")),
		"can_share": bool(asset.get("can_share", false)),
		"transfer_rule": str(asset.get("transfer_rule", "FORBIDDEN")),
		"is_diegetic": bool(asset.get("is_diegetic", false)),
	}

func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append(item.duplicate(true))
	return result
