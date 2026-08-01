extends RefCounted

class_name J11RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j11_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const RUNTIME_UNREAD := preload("res://scripts/runtime/season_1/RuntimeUnread.gd")
const CONTINUATION_SELECTOR := preload("res://scripts/runtime/season_1/J11ContinuationSelector.gd")
const SNAPSHOT_VERSION := 2

const MARIE_THREAD := "thread_marie_private"
const SANDRA_THREAD := "thread_sandra_private"
const MATHILDE_THREAD := "thread_mathilde_private"
const RAPHAELLE_THREAD := "thread_raphaelle_private"
const NICO_THREAD := "thread_nico_private"

const SANDRA_IMAGE_REF := "S1_A3_J11_DPH_SANDRA_CHOSEN_IMAGE_01"
const RAPHAELLE_RESULT_REF := "S1_A3_J11_DPH_RAPHAELLE_CHOSEN_RESULT_01"
const MATHILDE_PARENT_ASSET := "S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01"
const MARIE_PARENT_ASSET := "S1_A3_J11_SCN_MARIE_COUPLE_STATE_01"
const MATHILDE_A5_ASSETS := [
	"S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY",
	"S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01",
	"S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01",
]
const MARIE_A5_ASSETS := [
	"S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_RECONNECTION",
	"S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01",
	"S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01",
]

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
var selection_audit: Dictionary = {}
var presented_time_message_ids: Dictionary = {}
var pending_scene_asset_ids: Array[String] = []
var pending_scene_character_id := ""
var phase := "day_start_pending"
var current_time_minutes := -1
var resume_after_transition := ""

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	state = shared_state
	runtime_map = DataLoader.load_json(RUNTIME_MAP_PATH)
	if runtime_map.is_empty() or str(runtime_map.get("implementation_status", "")) != "PLAYABLE":
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
	selection_audit = {}
	presented_time_message_ids = {}
	pending_scene_asset_ids = []
	pending_scene_character_id = ""
	phase = "day_start_pending"
	resume_after_transition = ""
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
	for thread_id in unlocked_thread_ids:
		threads.append(_thread_presentation(thread_id))
		choices[thread_id] = choices_for(thread_id)
		transcripts[thread_id] = transcript_for(thread_id)
	return {
		"characters": _characters(),
		"threads": threads,
		"messages_by_thread": transcripts,
		"choices_by_thread": choices,
		"narrative_day_short": current_narrative_day_short(),
		"narrative_time": current_narrative_time_text(),
		"narrative_time_minutes": current_time_minutes,
		"implementation_status": "PLAYABLE",
		"pending_scene_sequence": pending_scene_sequence(),
	}

func pending_scene_sequence() -> Dictionary:
	if phase not in ["mathilde_scene_pending", "marie_scene_pending"]:
		return {}
	var sequence := _scene_presentations(pending_scene_asset_ids, pending_scene_character_id)
	if sequence.size() != 3:
		return {}
	return {
		"sequence": sequence,
		"provenance": {
			"source_kind": "scene",
			"scene_phase": phase,
			"character_id": pending_scene_character_id,
		},
	}

func start_day() -> Dictionary:
	if phase != "day_start_pending" or not state.begin_j11():
		return {"accepted": false}
	selection_audit = CONTINUATION_SELECTOR.new().select(state.snapshot())
	if selection_audit.is_empty() or not state.set_j11_continuation(str(selection_audit.get("pivot", "")), str(selection_audit.get("reason", ""))):
		return {"accepted": false}
	var p10: Dictionary = state.promises.get("marie_j09_dinner_friday_2030", {})
	if str(p10.get("status", "")) == "ACTIVE":
		_enter_segment(MARIE_THREAD, "j11_p10_dinner_confirmation", "p10_incoming")
		return _incoming_result(MARIE_THREAD)
	return _continue_after_p10()

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
	for key in direct_result:
		result[key] = direct_result[key]
	return result

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty():
		return {"accepted": false}
	var kind := str(pending_transition.get("kind", ""))
	pending_transition = {}
	match kind:
		"to_p11":
			_enter_segment(SANDRA_THREAD, "j11_p11_sandra_confirmation", "p11_incoming")
			return _incoming_result(SANDRA_THREAD)
		"to_sandra":
			if not state.establish_j11_sandra_private_image("view_only"):
				return {"accepted": false}
			_enter_segment(SANDRA_THREAD, "j11_sandra_opening", "sandra_incoming")
			return _incoming_result(SANDRA_THREAD)
		"to_mathilde":
			if not state.configure_j11_mathilde_safety(true, true, true):
				return {"accepted": false}
			_enter_segment(MATHILDE_THREAD, "j11_mathilde_opening", "mathilde_incoming")
			return _incoming_result(MATHILDE_THREAD)
		"mathilde_off_phone":
			return _resume_mathilde_after()
		"mathilde_physical_off_phone":
			if resume_after_transition == "mathilde_a5_scene":
				resume_after_transition = ""
				return _begin_scene_sequence("mathilde", MATHILDE_A5_ASSETS)
			return _resume_mathilde_after()
		"to_raphaelle":
			if not state.establish_j11_raphaelle_result():
				return {"accepted": false}
			_enter_segment(RAPHAELLE_THREAD, "j11_raphaelle_opening", "raphaelle_incoming")
			return _incoming_result(RAPHAELLE_THREAD)
		"raphaelle_meeting_off_phone":
			_enter_segment(RAPHAELLE_THREAD, "j11_raphaelle_after_kiss", "raphaelle_after_incoming")
			return _incoming_result(RAPHAELLE_THREAD)
		"to_nico":
			_enter_segment(NICO_THREAD, "j11_nico_opening", "nico_incoming")
			return _incoming_result(NICO_THREAD)
		"to_marie":
			_settle_p10_if_due()
			var p10: Dictionary = state.promises.get("marie_j09_dinner_friday_2030", {})
			var segment_id := "j11_marie_post_dinner_opening" if str(p10.get("j11_resolution", "")) == "MAINTAINED" and str(p10.get("status", "")) == "PAID" else "j11_marie_return_opening"
			_enter_segment(MARIE_THREAD, segment_id, "marie_incoming")
			return _incoming_result(MARIE_THREAD)
		"marie_off_phone":
			if resume_after_transition == "marie_a5_scene":
				resume_after_transition = ""
				return _begin_scene_sequence("marie", MARIE_A5_ASSETS)
			if resume_after_transition == "marie_non_adult_after":
				resume_after_transition = ""
				_enter_segment(MARIE_THREAD, "j11_marie_non_adult_after", "marie_after_incoming")
				return _incoming_result(MARIE_THREAD)
			resume_after_transition = ""
			_schedule_day_close()
			return _transition_result()
		"day_close":
			_settle_p10_if_due()
			if not state.complete_j11():
				return {"accepted": false}
			if TimelineState != null:
				TimelineState.mark_day_complete(11)
			phase = "complete"
			return {"accepted": true, "destination": "day_end", "day_end": runtime_map["day_end"].duplicate(true)}
	return {"accepted": false}

func confirm_scene_sequence() -> Dictionary:
	if phase == "mathilde_scene_pending" and pending_scene_character_id == "mathilde" and pending_scene_asset_ids == MATHILDE_A5_ASSETS:
		_complete_scene_sequence(MATHILDE_PARENT_ASSET)
		_enter_segment(MATHILDE_THREAD, "j11_mathilde_physical_after", "mathilde_after_incoming")
		return _incoming_result(MATHILDE_THREAD)
	if phase == "marie_scene_pending" and pending_scene_character_id == "marie" and pending_scene_asset_ids == MARIE_A5_ASSETS:
		if not state.resolve_j11_aftercare("aftercare_marie_j11", "PAID", "Marie et Player"):
			return {"accepted": false}
		_complete_scene_sequence(MARIE_PARENT_ASSET)
		_schedule_day_close()
		return _transition_result()
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
	if not _phase_accepts_batch() or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 11):
		return false
	match phase:
		"p10_incoming":
			phase = "p10_choice"
		"p11_incoming":
			if not state.confirm_or_expire_j11_p11_counterparty(true):
				return false
			_schedule_pivot()
		"sandra_incoming":
			phase = "sandra_choice"
		"mathilde_incoming":
			phase = "mathilde_choice"
		"mathilde_ceiling_incoming":
			phase = "mathilde_ceiling_choice"
		"mathilde_after_incoming":
			if pending_choice_ids_by_thread.get(MATHILDE_THREAD, []).is_empty():
				_schedule_day_close()
			else:
				phase = "mathilde_after_choice"
		"raphaelle_incoming":
			phase = "raphaelle_choice"
		"raphaelle_attraction_incoming":
			phase = "raphaelle_attraction_choice"
		"raphaelle_meeting_incoming":
			phase = "raphaelle_meeting_choice"
		"raphaelle_after_incoming", "marie_after_incoming":
			_schedule_day_close()
		"nico_incoming":
			phase = "nico_choice"
		"marie_incoming":
			phase = "marie_choice"
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
	var all_children: Dictionary = {}
	for day in range(2, 12):
		var day_map: Dictionary = DataLoader.load_json("res://data/runtime/season_1/j%02d_runtime_map.json" % day)
		all_assets.append_array(day_map.get("gallery_presentations", []))
		for raw_child in day_map.get("gallery_children", []):
			if not raw_child is Dictionary:
				continue
			var child_id := str(raw_child.get("asset_id", ""))
			if child_id != "" and not all_children.has(child_id):
				all_children[child_id] = raw_child.duplicate(true)
	var included_children: Dictionary = {}
	var added_item_keys: Dictionary = {}
	for raw_asset in all_assets:
		if not raw_asset is Dictionary:
			continue
		var asset: Dictionary = raw_asset
		var asset_id := str(asset.get("asset_id", ""))
		if asset_id == "" or not gallery_asset_ids.has(asset_id):
			continue
		for raw_character_id in asset.get("character_ids", []):
			var character_id := str(raw_character_id)
			var character: Dictionary = fixtures.get(character_id, {})
			var item_key := "%s::%s" % [character_id, asset_id]
			if character.is_empty() or added_item_keys.has(item_key):
				continue
			var items: Array = character["items"]
			items.append(_gallery_item(asset, character_id, items.size()))
			character["items"] = items
			added_item_keys[item_key] = true
		var raw_child_ids: Variant = asset.get("sequence_child_ids", [])
		if raw_child_ids is Array:
			for raw_child_id in raw_child_ids:
				var child_id := str(raw_child_id)
				if all_children.has(child_id):
					included_children[child_id] = all_children[child_id].duplicate(true)
	return {
		"fixtures": fixtures,
		"character_order": ["marie", "sandra", "mathilde", "raphaelle", "pauline", "nico"],
		"children_by_id": included_children,
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
		"selection_audit": selection_audit.duplicate(true),
		"presented_time_message_ids": presented_time_message_ids.duplicate(true),
		"current_time_minutes": current_time_minutes,
		"resume_after_transition": resume_after_transition,
		"pending_scene_asset_ids": pending_scene_asset_ids.duplicate(),
		"pending_scene_character_id": pending_scene_character_id,
	}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION:
		return false
	var allowed_phases := [
		"day_start_pending", "p10_incoming", "p10_choice", "to_p11", "p11_incoming",
		"to_sandra", "sandra_incoming", "sandra_choice", "to_mathilde", "mathilde_incoming",
		"mathilde_choice", "mathilde_ceiling_incoming", "mathilde_ceiling_choice", "mathilde_off_phone",
		"mathilde_physical_off_phone", "mathilde_scene_pending", "mathilde_after_incoming",
		"mathilde_after_choice", "to_raphaelle", "raphaelle_incoming", "raphaelle_choice",
		"raphaelle_attraction_incoming", "raphaelle_attraction_choice", "raphaelle_meeting_incoming",
		"raphaelle_meeting_choice", "raphaelle_meeting_off_phone", "raphaelle_after_incoming",
		"to_nico", "nico_incoming", "nico_choice", "to_marie", "marie_incoming", "marie_choice",
		"marie_off_phone", "marie_scene_pending", "marie_after_incoming", "day_close", "complete",
	]
	if str(value.get("phase", "")) not in allowed_phases:
		return false
	for key in ["transcripts_by_thread", "produced_message_ids", "pending_choice_ids_by_thread", "pending_transition", "selection_audit", "presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY:
			return false
	for key in ["unlocked_thread_ids", "gallery_asset_ids", "served_visual_beat_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY:
			return false
	if typeof(value.get("pending_scene_asset_ids", [])) != TYPE_ARRAY:
		return false
	if str(value.get("resume_after_transition", "")) not in ["", "mathilde_look_after", "mathilde_proximity_after", "mathilde_physical_after", "mathilde_a5_scene", "marie_a5_scene", "marie_non_adult_after", "day_close"]:
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
	selection_audit = value["selection_audit"].duplicate(true)
	presented_time_message_ids = value["presented_time_message_ids"].duplicate(true)
	current_time_minutes = restored_time
	resume_after_transition = str(value["resume_after_transition"])
	pending_scene_asset_ids.assign(value.get("pending_scene_asset_ids", []))
	pending_scene_character_id = str(value.get("pending_scene_character_id", ""))
	return _restored_phase_consistent()

func presentation_count_by_id(id: String) -> int:
	var count := 0
	for thread_id in transcripts_by_thread:
		for item in transcripts_by_thread[thread_id]:
			if str(item.get("message_id", "")) == id:
				count += 1
	return count

func _apply_state_choice(choice_id: String) -> bool:
	if choice_id.begins_with("choice_j11_p10_"):
		return state.apply_j11_p10_choice(choice_id)
	if choice_id in ["choice_j11_sandra_rule", "choice_j11_sandra_desire"]:
		return state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_sandra_more":
		return state.update_j11_sandra_image_access("removed") and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_mathilde_look":
		return state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_mathilde_distance":
		return state.set_j11_mathilde_proximity("DISTANCE") and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_mathilde_proximity":
		return state.set_j11_mathilde_proximity("PROXIMITY_CONSENTED") and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_mathilde_m_b3_accept":
		return _mathilde_physical_eligible() and state.establish_j11_mathilde_physical_event("MATHILDE_M_B3", true) and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_mathilde_m_b2_hold":
		return _mathilde_physical_eligible() and state.establish_j11_mathilde_physical_event("MATHILDE_M_B2", true) and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_mathilde_physical_stop":
		return state.record_j11_choice(choice_id, [choice_id])
	if choice_id in ["choice_j11_mathilde_after_no_definition", "choice_j11_mathilde_after_marie", "choice_j11_mathilde_after_repeat"]:
		var resolution := "FAILED" if choice_id == "choice_j11_mathilde_after_repeat" else "PAID"
		return state.resolve_j11_aftercare("aftercare_mathilde_j11", resolution, "Player") and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_raphaelle_work_person":
		return state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_raphaelle_attractive":
		return state.set_j11_raphaelle_outcome("RESULT_SENT_ATTRACTION_NAMED") and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_raphaelle_boundary":
		return state.set_j11_raphaelle_outcome("RESULT_SENT_BOUNDARY_HELD") and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_raphaelle_attraction_yes":
		if _raphaelle_kiss_eligible():
			return state.record_j11_choice(choice_id, [choice_id])
		return state.set_j11_raphaelle_outcome("RESULT_SENT_ATTRACTION_NAMED") and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_raphaelle_attraction_no":
		return state.set_j11_raphaelle_outcome("RESULT_SENT_BOUNDARY_HELD") and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_raphaelle_meeting_accept":
		return state.set_j11_raphaelle_outcome("FIRST_KISS", true, true, true) and state.record_j11_choice(choice_id, [choice_id])
	if choice_id == "choice_j11_raphaelle_meeting_decline":
		return state.set_j11_raphaelle_outcome("KISS_DECLINED") and state.record_j11_choice(choice_id, [choice_id])
	if choice_id.begins_with("choice_j11_nico_"):
		return state.record_j11_choice(choice_id, [choice_id])
	if choice_id.ends_with("reconquest"):
		var established: bool = state.establish_j11_marie_adult_event(true, true) if _marie_adult_eligible() else true
		return established and state.record_j11_choice(choice_id, [choice_id])
	if choice_id.ends_with("no_pansement") or choice_id.ends_with("refuse"):
		return state.record_j11_choice(choice_id, [choice_id])
	return false

func _advance_after_choice(choice_id: String) -> Dictionary:
	if choice_id.begins_with("choice_j11_p10_"):
		return _continue_after_p10()
	if choice_id in ["choice_j11_sandra_rule", "choice_j11_sandra_desire", "choice_j11_sandra_more"]:
		if choice_id == "choice_j11_sandra_more":
			_mark_media_removed(SANDRA_IMAGE_REF)
		_schedule_day_close()
	elif choice_id == "choice_j11_mathilde_look":
		resume_after_transition = "mathilde_look_after"
		_schedule_transition("mathilde_off_phone")
	elif choice_id == "choice_j11_mathilde_proximity":
		if _mathilde_physical_eligible():
			_enter_segment(MATHILDE_THREAD, "j11_mathilde_physical_entry", "mathilde_ceiling_incoming")
		else:
			_append_segment_messages(MATHILDE_THREAD, "j11_mathilde_proximity_entry")
			resume_after_transition = "mathilde_proximity_after"
			_schedule_transition("mathilde_off_phone")
	elif choice_id == "choice_j11_mathilde_m_b3_accept":
		resume_after_transition = "mathilde_a5_scene"
		_schedule_transition("mathilde_physical_off_phone")
	elif choice_id == "choice_j11_mathilde_m_b2_hold":
		resume_after_transition = "mathilde_physical_after"
		_schedule_transition("mathilde_physical_off_phone")
	elif choice_id == "choice_j11_mathilde_physical_stop":
		_schedule_day_close()
	elif choice_id == "choice_j11_mathilde_distance" or choice_id.begins_with("choice_j11_mathilde_after_"):
		_schedule_day_close()
	elif choice_id == "choice_j11_raphaelle_work_person":
		_enter_segment(RAPHAELLE_THREAD, "j11_raphaelle_attraction_choice", "raphaelle_attraction_incoming")
	elif choice_id == "choice_j11_raphaelle_attraction_yes" and state.j11_pivot_outcome == "":
		_enter_segment(RAPHAELLE_THREAD, "j11_raphaelle_meeting_choice", "raphaelle_meeting_incoming")
	elif choice_id in ["choice_j11_raphaelle_attractive", "choice_j11_raphaelle_boundary", "choice_j11_raphaelle_attraction_yes", "choice_j11_raphaelle_attraction_no", "choice_j11_raphaelle_meeting_decline"]:
		if choice_id == "choice_j11_raphaelle_boundary":
			_mark_media_removed(RAPHAELLE_RESULT_REF)
		_schedule_day_close()
	elif choice_id == "choice_j11_raphaelle_meeting_accept":
		_schedule_transition("raphaelle_meeting_off_phone")
	elif choice_id.begins_with("choice_j11_nico_"):
		_schedule_day_close()
	elif choice_id.ends_with("reconquest"):
		if state.j11_physical_level == "MARIE_ADULT_RECONQUEST":
			_append_segment_messages(MARIE_THREAD, "j11_marie_reconquest_adult")
			resume_after_transition = "marie_a5_scene"
		else:
			_append_segment_messages(MARIE_THREAD, "j11_marie_reconquest_non_adult")
			resume_after_transition = "marie_non_adult_after"
		_schedule_transition("marie_off_phone")
	elif choice_id.ends_with("no_pansement") or choice_id.ends_with("refuse"):
		_schedule_day_close()
	return {}

func _continue_after_p10() -> Dictionary:
	var p11: Dictionary = state.promises.get("sandra_cafe_saturday_1100", {})
	if str(p11.get("status", "")) == "CONDITIONAL" and str(p11.get("counterparty_confirmed_at", "")) == "":
		_schedule_transition("to_p11")
		return _transition_result()
	return _schedule_pivot()

func _schedule_pivot() -> Dictionary:
	match state.j11_pivot:
		"SANDRA": _schedule_transition("to_sandra")
		"MATHILDE": _schedule_transition("to_mathilde")
		"RAPHAELLE": _schedule_transition("to_raphaelle")
		"NICO": _schedule_transition("to_nico")
		"MARIE": _schedule_transition("to_marie")
		"RESPIRATION": _schedule_day_close()
		_: return {"accepted": false}
	return _transition_result()

func _resume_mathilde_after() -> Dictionary:
	var segment_id: String = str({
		"mathilde_look_after": "j11_mathilde_look_after",
		"mathilde_proximity_after": "j11_mathilde_proximity_after",
		"mathilde_physical_after": "j11_mathilde_physical_after",
	}.get(resume_after_transition, ""))
	resume_after_transition = ""
	if segment_id == "":
		return {"accepted": false}
	_enter_segment(MATHILDE_THREAD, segment_id, "mathilde_after_incoming")
	return _incoming_result(MATHILDE_THREAD)

func _begin_scene_sequence(character_id: String, asset_ids: Array) -> Dictionary:
	var sequence := _scene_presentations(asset_ids, character_id)
	if sequence.size() != 3:
		return {"accepted": false}
	pending_scene_asset_ids.assign(asset_ids)
	pending_scene_character_id = character_id
	phase = "%s_scene_pending" % character_id
	return {
		"accepted": true,
		"destination": "scene_sequence",
		"sequence": sequence,
		"provenance": {
			"source_kind": "scene",
			"scene_phase": phase,
			"character_id": character_id,
		},
	}

func _complete_scene_sequence(parent_asset_id: String) -> void:
	for asset_id in pending_scene_asset_ids:
		if not served_visual_beat_ids.has(asset_id):
			served_visual_beat_ids.append(asset_id)
	if not gallery_asset_ids.has(parent_asset_id):
		gallery_asset_ids.append(parent_asset_id)
	pending_scene_asset_ids = []
	pending_scene_character_id = ""

func _scene_presentations(asset_ids: Array, character_id: String) -> Array[Dictionary]:
	var expected_name := ""
	var expected_accent := ""
	match character_id:
		"mathilde":
			expected_name = "Mathilde"
			expected_accent = "#E070A8"
		"marie":
			expected_name = "Marie"
			expected_accent = "#4F8BFF"
	if expected_name == "" or asset_ids.size() != 3:
		return []
	var children: Dictionary = {}
	for raw_child in runtime_map.get("gallery_children", []):
		if raw_child is Dictionary:
			children[str(raw_child.get("asset_id", ""))] = raw_child
	var result: Array[Dictionary] = []
	var captions := ["Entrée", "Centre", "Après-coup"]
	for index in range(asset_ids.size()):
		var asset_id := str(asset_ids[index])
		var child: Dictionary = children.get(asset_id, {})
		if child.is_empty() or str(child.get("character_id", "")) != character_id or str(child.get("source_kind", "")) != "gallery":
			return []
		result.append({
			"photo_id": asset_id,
			"visual_ref": asset_id,
			"access_state": "UNLOCKED",
			"source_kind": "scene",
			"character_id": character_id,
			"display_name": expected_name,
			"accent_color": Color.from_string(expected_accent, Color.WHITE),
			"context_label": "Scène vécue · %d/3" % (index + 1),
			"timestamp": "",
			"caption": captions[index],
			"placeholder_label": str(child.get("placeholder_label", "Visuel canonique non produit")),
		})
	return result

func _mathilde_physical_eligible() -> bool:
	if str(selection_audit.get("advanced_ceiling", "")) != "PHYSICAL_IF_ALL_GATES":
		return false
	if state.j10_pivot_outcome not in ["OUTFIT_PRECISE_NON_APPROPRIATIVE", "OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED"]:
		return false
	if _has_blocking_obligation():
		return false
	var p10: Dictionary = state.promises.get("marie_j09_dinner_friday_2030", {})
	return str(p10.get("status", "")) != "ACTIVE" and str(p10.get("j11_resolution", "")) != "MAINTAINED"

func _raphaelle_kiss_eligible() -> bool:
	if str(selection_audit.get("advanced_ceiling", "")) != "FIRST_KISS_IF_SEQUENCE_PROVEN" or state.j10_pivot_outcome != "PROCESS_HELPED_VISIT_BOUNDED":
		return false
	if _has_blocking_obligation():
		return false
	var p10: Dictionary = state.promises.get("marie_j09_dinner_friday_2030", {})
	return str(p10.get("status", "")) != "ACTIVE" and str(p10.get("j11_resolution", "")) != "MAINTAINED"

func _marie_adult_eligible() -> bool:
	if state.j11_pivot != "MARIE" or state.j10_pivot != "NONE" or state.j10_pivot_outcome not in ["DUE_DINNER_PAID", "ORDINARY_MEAL_JOINED"]:
		return false
	if state.marie_j09_presence_outcome not in ["presence_active", "presence_playful_useful", "presence_late_active", "presence_bounded_reliable"]:
		return false
	if state.couple_state not in ["BASELINE_SHARED_LIFE", "STRAIN_VISIBLE"] or _has_blocking_obligation():
		return false
	var p10: Dictionary = state.promises.get("marie_j09_dinner_friday_2030", {})
	if not p10.is_empty() and str(p10.get("status", "")) != "PAID":
		return false
	var p09: Dictionary = state.promises.get("marie_j09_dinner_j10_2030", {})
	if p09.is_empty():
		return true
	if str(p09.get("status", "")) in ["PAID", "CANCELLED", "REFUSED", "FAILED", "CLOSED"]:
		return true
	return str(p09.get("status", "")) == "AMENDED" and str(p09.get("amended_to", "")) == "marie_j09_dinner_friday_2030" and str(p10.get("status", "")) == "PAID"

func _has_blocking_obligation() -> bool:
	for obligation in state.obligations.values():
		if str(obligation.get("status", "")) in ["DUE", "FAILED"]:
			return true
	return false

func _settle_p10_if_due() -> void:
	var p10: Dictionary = state.promises.get("marie_j09_dinner_friday_2030", {})
	if str(p10.get("status", "")) == "ACTIVE" and str(p10.get("j11_resolution", "")) in ["MAINTAINED", "LATE_INCOMPATIBLE"]:
		state.pay_j11_p10()

func _schedule_day_close() -> void:
	_schedule_transition("day_close")

func _phase_accepts_batch() -> bool:
	return phase in [
		"p10_incoming", "p11_incoming", "sandra_incoming", "mathilde_incoming", "mathilde_ceiling_incoming", "mathilde_after_incoming",
		"raphaelle_incoming", "raphaelle_attraction_incoming", "raphaelle_meeting_incoming", "raphaelle_after_incoming",
		"nico_incoming", "marie_incoming", "marie_after_incoming",
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
		"source_day": 11,
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
			"placeholder_label": str(message.get("placeholder_label", "Photo de démonstration")),
			"is_player": author == "player",
			"is_read": author == "player",
			"source_day": 11,
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

func _mark_media_removed(media_ref: String) -> void:
	for thread_id in transcripts_by_thread:
		var transcript: Array = transcripts_by_thread[thread_id]
		for index in range(transcript.size()):
			if str(transcript[index].get("media_ref", "")) == media_ref:
				transcript[index]["content_type"] = "TEXT"
				transcript[index]["text"] = "Contenu retiré"
				transcript[index]["media_ref"] = ""
				transcript[index]["placeholder_label"] = "Contenu retiré"
		transcripts_by_thread[thread_id] = transcript

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

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending":
		return state.current_day == "J10" and state.day_status == "COMPLETE" and pending_transition.is_empty() and pending_scene_asset_ids.is_empty() and pending_scene_character_id == ""
	if state.current_day != "J11":
		return false
	if phase == "complete":
		return state.day_status == "COMPLETE" and pending_transition.is_empty() and pending_scene_asset_ids.is_empty() and pending_scene_character_id == ""
	if state.day_status != "ACTIVE":
		return false
	if phase == "mathilde_scene_pending":
		return pending_transition.is_empty() and pending_scene_character_id == "mathilde" and pending_scene_asset_ids == MATHILDE_A5_ASSETS
	if phase == "marie_scene_pending":
		return pending_transition.is_empty() and pending_scene_character_id == "marie" and pending_scene_asset_ids == MARIE_A5_ASSETS
	if not pending_scene_asset_ids.is_empty() or pending_scene_character_id != "":
		return false
	var transition_phases := ["to_p11", "to_sandra", "to_mathilde", "mathilde_off_phone", "mathilde_physical_off_phone", "to_raphaelle", "raphaelle_meeting_off_phone", "to_nico", "to_marie", "marie_off_phone", "day_close"]
	return not pending_transition.is_empty() if phase in transition_phases else pending_transition.is_empty()

func _thread_presentation(id: String) -> Dictionary:
	var titles := {MARIE_THREAD: "Marie", SANDRA_THREAD: "Sandra", MATHILDE_THREAD: "Mathilde", RAPHAELLE_THREAD: "Raphaëlle", NICO_THREAD: "Nico", "thread_pauline_private": "Pauline"}
	var participants := {MARIE_THREAD: "marie", SANDRA_THREAD: "sandra", MATHILDE_THREAD: "mathilde", RAPHAELLE_THREAD: "raphaelle", NICO_THREAD: "nico", "thread_pauline_private": "pauline"}
	var colors := {MARIE_THREAD: "#4F8BFF", SANDRA_THREAD: "#20C7C9", MATHILDE_THREAD: "#E070A8", RAPHAELLE_THREAD: "#D69A42", NICO_THREAD: "#65B87A", "thread_pauline_private": "#E6B84A"}
	var transcript := transcript_for(id)
	var last: Dictionary = {}
	var unread := RUNTIME_UNREAD.incoming_unread_count(transcript, presented_time_message_ids, 11)
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
	var item := {
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
	if asset.has("sequence_child_ids"):
		item["sequence_child_ids"] = asset.get("sequence_child_ids")
	return item

func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append(item.duplicate(true))
	return result
