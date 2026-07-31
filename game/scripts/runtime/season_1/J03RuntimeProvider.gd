extends RefCounted

class_name J03RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j03_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const RUNTIME_UNREAD := preload("res://scripts/runtime/season_1/RuntimeUnread.gd")
const SNAPSHOT_VERSION := 1

var state
var runtime_map: Dictionary = {}
var conversations: Dictionary = {}
var transcripts_by_thread: Dictionary = {}
var produced_message_ids: Dictionary = {}
var unlocked_thread_ids: Array[String] = []
var segment_index_by_thread: Dictionary = {}
var pending_choice_ids_by_thread: Dictionary = {}
var pending_transition: Dictionary = {}
var phase := "day_start_pending"
var gallery_asset_ids: Array[String] = []
var initialized := false
var current_time_minutes := -1
var presented_time_message_ids: Dictionary = {}

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	state = shared_state
	runtime_map = DataLoader.load_json(RUNTIME_MAP_PATH)
	if state == null or runtime_map.is_empty(): return false
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get("initial_time", "")))
	if current_time_minutes < 0: return false
	presented_time_message_ids = {}
	for conversation_id in runtime_map.get("conversation_paths", {}):
		var value: Dictionary = DataLoader.load_json(str(runtime_map["conversation_paths"][conversation_id]))
		if value.is_empty(): return false
		conversations[str(conversation_id)] = value
	transcripts_by_thread = cumulative_transcripts.duplicate(true)
	produced_message_ids = cumulative_ids.duplicate(true)
	unlocked_thread_ids.assign(cumulative_threads)
	gallery_asset_ids.assign(cumulative_gallery_ids)
	segment_index_by_thread = {"thread_raphaelle_private": 0, "thread_sandra_private": 0, "thread_marie_private": 0}
	initialized = true
	return true

func day_start_presentation() -> Dictionary: return runtime_map.get("day_start", {}).duplicate(true)

func presentation_source() -> Dictionary:
	var threads: Array[Dictionary] = []
	var choices: Dictionary = {}
	var transcripts: Dictionary = {}
	for id in unlocked_thread_ids:
		threads.append(_thread_presentation(id)); choices[id] = choices_for(id); transcripts[id] = transcript_for(id)
	return {
		"characters": {
			"marie": _character("marie", "Marie", "#4F8BFF", "M"),
			"sandra": _character("sandra", "Sandra", "#20C7C9", "S"),
			"mathilde": _character("mathilde", "Mathilde", "#E070A8", "M"),
			"raphaelle": _character("raphaelle", "Raphaëlle", "#D69A42", "R"),
			"player": _character("player", "Player", "#8D63E6", ""),
		},
		"threads": threads, "messages_by_thread": transcripts, "choices_by_thread": choices,
		"narrative_day_short": current_narrative_day_short(),
		"narrative_time": current_narrative_time_text(), "narrative_time_minutes": current_time_minutes,
	}

func current_narrative_day_short() -> String: return str(runtime_map.get("narrative_day_short", ""))
func current_narrative_time_minutes() -> int: return current_time_minutes
func current_narrative_time_text() -> String: return NARRATIVE_TIME.format_narrative_time(current_time_minutes)
func mark_message_presented(message_id: String) -> bool:
	if message_id == "" or presented_time_message_ids.has(message_id): return false
	var timestamp := ""
	for thread_id in transcripts_by_thread:
		for message in transcripts_by_thread[thread_id]:
			if str(message.get("message_id", "")) == message_id: timestamp = str(message.get("timestamp", "")); break
		if timestamp != "": break
	presented_time_message_ids[message_id] = true
	var candidate := NARRATIVE_TIME.parse_narrative_time(timestamp)
	if candidate < current_time_minutes: return false
	current_time_minutes = candidate; return candidate >= 0
func commit_narrative_time(minutes: int) -> bool:
	if minutes < current_time_minutes or NARRATIVE_TIME.format_narrative_time(minutes) == "": return false
	current_time_minutes = minutes; return true

func gallery_source() -> Dictionary:
	var fixtures := {
		"marie": _gallery_character("marie", "Marie", "#4F8BFF", "M"),
		"sandra": _gallery_character("sandra", "Sandra", "#20C7C9", "S"),
		"mathilde": _gallery_character("mathilde", "Mathilde", "#E070A8", "M"),
		"raphaelle": _gallery_character("raphaelle", "Raphaëlle", "#D69A42", "R"),
	}
	# Rebuild the cumulative J02 presentations from its bounded runtime map.
	var j02_map: Dictionary = DataLoader.load_json("res://data/runtime/season_1/j02_runtime_map.json")
	var all_assets: Array = j02_map.get("gallery_presentations", []).duplicate(true)
	all_assets.append_array(runtime_map.get("gallery_presentations", []))
	for asset in all_assets:
		if not gallery_asset_ids.has(str(asset.get("asset_id", ""))): continue
		for character_id in asset.get("character_ids", []):
			var character: Dictionary = fixtures.get(str(character_id), {})
			if character.is_empty(): continue
			var items: Array = character["items"]
			items.append(_gallery_item(asset, str(character_id), items.size())); character["items"] = items
	return {"fixtures": fixtures, "character_order": ["marie", "sandra", "mathilde", "raphaelle"], "empty_label": "Aucun visuel disponible."}

func transcript_for(thread_id: String) -> Array[Dictionary]: return _dictionary_array(transcripts_by_thread.get(thread_id, []))
func choices_for(thread_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var segment := _current_segment(thread_id)
	for choice in segment.get("choices", []):
		if pending_choice_ids_by_thread.get(thread_id, []).has(str(choice.get("id", ""))):
			result.append({"choice_id": str(choice.get("id", "")), "text": str(choice.get("text", "")), "enabled": true, "confirmation_required": false})
	return result

func start_day() -> Dictionary:
	if phase != "day_start_pending": return {"accepted": false}
	state.begin_j03()
	if not unlocked_thread_ids.has("thread_raphaelle_private"): unlocked_thread_ids.append("thread_raphaelle_private")
	phase = "raphaelle_work"
	_enter_current_segment("thread_raphaelle_private")
	return {"accepted": true, "destination": "list", "focus_thread_id": "thread_raphaelle_private"}

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id): return {"accepted": false}
	var segment := _current_segment(thread_id)
	var selected: Dictionary = {}
	for choice in segment.get("choices", []):
		if str(choice.get("id", "")) == choice_id: selected = choice; break
	if selected.is_empty() or not state.apply_j03_choice(choice_id): return {"accepted": false}
	pending_choice_ids_by_thread[thread_id] = []
	var before := transcript_for(thread_id).size()
	# Capture the provider's authoritative narrative time at acceptance.
	_append(thread_id, {"message_id": choice_id + "_player", "author_id": "player", "timestamp": current_narrative_time_text(), "content_type": "TEXT", "text": str(selected.get("text", "")), "media_ref": "", "is_player": true, "is_read": true, "source_day": 3})
	_append_messages(thread_id, selected.get("next_messages", []))
	segment_index_by_thread[thread_id] = int(segment_index_by_thread.get(thread_id, 0)) + 1
	if int(segment_index_by_thread[thread_id]) < _segments(thread_id).size():
		_enter_current_segment(thread_id)
	elif thread_id == "thread_raphaelle_private":
		state.establish_raphaelle_fact()
		phase = "raphaelle_offline"
		var offline: Dictionary = runtime_map["raphaelle_offline"]
		_append_offline(thread_id, offline)
		pending_transition = {"kind": "offline", "thread_id": thread_id}
	elif thread_id == "thread_sandra_private":
		state.complete_conversation("chapter_03_sandra_continuity", "sandra")
		phase = "marie_time_card"
		pending_transition = _clock_transition(runtime_map["marie_time_card"])
	else:
		phase = "marie_offline"
		var offline: Dictionary = runtime_map["marie_offline"].get(state.marie_j03_return_outcome, {})
		_append_offline(thread_id, offline)
		pending_transition = {
			"kind": "offline", "thread_id": thread_id,
			"to_time": str(offline.get("time", "")),
			"flow_phases": offline.get("flow_phases", ["CLOCK", "OFF_PHONE", "NIGHT"]).duplicate(),
			"content_end": false,
			"next_day_presentation": runtime_map.get("day_end", {}).get("next_day_presentation", {}).duplicate(true),
		}
		pending_transition["flow_phases"].append("NEW_DAY")
	return {"accepted": true, "new_messages": transcript_for(thread_id).slice(before), "choices": choices_for(thread_id), "transition": pending_transition.duplicate(true)}

func confirm_day_transition() -> Dictionary:
	if phase == "day_start_pending": return start_day()
	if pending_transition.is_empty() or str(pending_transition.get("kind", "")) != "day_transition": return {"accepted": false}
	pending_transition = {}
	if phase == "sandra_offer":
		phase = "sandra_echo"
		segment_index_by_thread["thread_sandra_private"] = 0
		_enter_current_segment("thread_sandra_private")
		return {"accepted": true, "destination": "conversation", "thread_id": "thread_sandra_private"}
	if phase == "marie_time_card":
		phase = "marie_return"
		segment_index_by_thread["thread_marie_private"] = 0
		_enter_current_segment("thread_marie_private")
		return {"accepted": true, "destination": "conversation", "thread_id": "thread_marie_private"}
	return {"accepted": false}

func confirm_secondary_day_transition() -> Dictionary:
	if phase != "sandra_offer" or str(pending_transition.get("kind", "")) != "day_transition": return {"accepted": false}
	state.set_sandra_j03_echo_outcome("EXPIRED")
	phase = "marie_time_card"
	pending_transition = _clock_transition(runtime_map["marie_time_card"])
	return {"accepted": true, "destination": "day_transition", "presentation": pending_transition["presentation"], "transition": pending_transition.duplicate(true)}

func confirm_transition() -> Dictionary:
	if str(pending_transition.get("kind", "")) != "offline": return {"accepted": false}
	pending_transition = {}
	if phase == "raphaelle_offline":
		state.complete_conversation("chapter_03_raphaelle_blue_folder", "raphaelle")
		_unlock_gallery_for("raphaelle")
		if _sandra_available():
			phase = "sandra_offer"
			pending_transition = _clock_transition(runtime_map["sandra_offer"])
		else:
			state.set_sandra_j03_echo_outcome("UNAVAILABLE")
			phase = "marie_time_card"
			pending_transition = _clock_transition(runtime_map["marie_time_card"])
		return {"accepted": true, "destination": "day_transition", "presentation": pending_transition["presentation"], "transition": pending_transition.duplicate(true)}
	if phase == "marie_offline":
		state.complete_conversation("chapter_03_marie_evening_return", "marie")
		state.establish_marie_j03_records()
		_unlock_gallery_for("marie")
		state.complete_day()
		if TimelineState != null: TimelineState.mark_day_complete(3)
		phase = "complete"
		return {"accepted": true, "destination": "day_end", "day_end": runtime_map["day_end"].duplicate(true)}
	return {"accepted": false}

func on_thread_returned(_thread_id: String) -> Dictionary: return {}

func snapshot() -> Dictionary:
	return {"version": SNAPSHOT_VERSION, "phase": phase, "transcripts_by_thread": transcripts_by_thread.duplicate(true), "produced_message_ids": produced_message_ids.duplicate(true), "unlocked_thread_ids": unlocked_thread_ids.duplicate(), "segment_index_by_thread": segment_index_by_thread.duplicate(true), "pending_choice_ids_by_thread": pending_choice_ids_by_thread.duplicate(true), "pending_transition": pending_transition.duplicate(true), "gallery_asset_ids": gallery_asset_ids.duplicate(), "current_time_minutes": current_time_minutes, "presented_time_message_ids": presented_time_message_ids.duplicate(true)}
func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION: return false
	var restored_phase := str(value.get("phase", ""))
	if restored_phase not in ["day_start_pending", "raphaelle_work", "raphaelle_offline", "sandra_offer", "sandra_echo", "marie_time_card", "marie_return", "marie_offline", "complete"]: return false
	for key in ["transcripts_by_thread", "produced_message_ids", "segment_index_by_thread", "pending_choice_ids_by_thread", "pending_transition", "presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids", "gallery_asset_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY: return false
	if not _restored_phase_is_consistent(restored_phase, value["pending_transition"]): return false
	phase = restored_phase; transcripts_by_thread = value["transcripts_by_thread"].duplicate(true); produced_message_ids = value["produced_message_ids"].duplicate(true)
	unlocked_thread_ids.assign(value["unlocked_thread_ids"]); segment_index_by_thread = value["segment_index_by_thread"].duplicate(true); pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true)
	pending_transition = value["pending_transition"].duplicate(true); gallery_asset_ids.assign(value["gallery_asset_ids"])
	var restored_time := int(value.get("current_time_minutes", -1)); if NARRATIVE_TIME.format_narrative_time(restored_time) == "": return false
	current_time_minutes = restored_time; presented_time_message_ids = value["presented_time_message_ids"].duplicate(true)
	return true

func _clock_transition(presentation: Dictionary) -> Dictionary:
	return {"kind": "day_transition", "transition_mode": str(presentation.get("transition_mode", "")), "from_time": current_narrative_time_text(), "to_time": str(presentation.get("to_time", "")), "duration_seconds": float(presentation.get("duration_seconds", 4.0)), "presentation": presentation.duplicate(true)}

func _restored_phase_is_consistent(restored_phase: String, transition: Dictionary) -> bool:
	var transition_kind := str(transition.get("kind", ""))
	if restored_phase == "day_start_pending":
		return state.current_day == "J02" and state.day_status == "COMPLETE" and transition.is_empty()
	if restored_phase == "complete":
		return ((state.current_day == "J03" and state.day_status == "COMPLETE") or state.current_day in ["J04", "J05", "J06", "J07", "J08", "J09", "J10"]) and transition.is_empty()
	if state.current_day != "J03": return false
	if state.day_status != "ACTIVE": return false
	if restored_phase in ["raphaelle_offline", "marie_offline"]: return transition_kind == "offline"
	if restored_phase in ["sandra_offer", "marie_time_card"]: return transition_kind == "day_transition"
	return transition.is_empty()
func presentation_count_by_id(id: String) -> int:
	var count := 0
	for thread in transcripts_by_thread:
		for item in transcripts_by_thread[thread]:
			if str(item.get("message_id", "")) == id: count += 1
	return count

func _sandra_available() -> bool:
	var trace: Dictionary = state.traces.get("j01_sandra_lunch_memory_soft", {})
	return state.sandra_state == "RECONNECTION_OPEN" and str(trace.get("current_state", "")) in ["ACTIVE", "RESTRICTED"]
func _unlock_gallery_for(character_id: String) -> void:
	for asset in runtime_map.get("gallery_presentations", []):
		if not asset.get("character_ids", []).has(character_id): continue
		var id := str(asset.get("asset_id", "")); if not gallery_asset_ids.has(id): gallery_asset_ids.append(id)
func _enter_current_segment(thread_id: String) -> void:
	var segment := _current_segment(thread_id); _append_messages(thread_id, segment.get("messages", []))
	var ids: Array[String] = []
	for choice in segment.get("choices", []): ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids
func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		_append(thread_id, {"message_id": str(message.get("id", "")), "author_id": str(message.get("sender", "system")), "timestamp": str(message.get("time_label", "")), "content_type": "TEXT", "text": str(message.get("text", "")), "media_ref": "", "is_player": false, "is_read": false, "source_day": 3})
func _append_offline(thread_id: String, offline: Dictionary) -> void:
	_append(thread_id, {"message_id": str(offline.get("message_id", "")), "author_id": "system", "timestamp": "", "content_type": "OFF_PHONE_TRANSITION", "text": str(offline.get("text", "")), "media_ref": "", "is_player": false, "is_read": true, "source_day": 3})
func _append(thread_id: String, item: Dictionary) -> bool:
	var id := str(item.get("message_id", "")); if id == "" or produced_message_ids.has(id): return false
	var transcript: Array = transcripts_by_thread.get(thread_id, []); transcript.append(item.duplicate(true)); transcripts_by_thread[thread_id] = transcript; produced_message_ids[id] = true; return true
func _segments(thread_id: String) -> Array:
	if thread_id == "thread_raphaelle_private": return conversations["chapter_03_raphaelle_blue_folder"].get("segments", [])
	if thread_id == "thread_sandra_private": return conversations["chapter_03_sandra_continuity"].get("segments", [])
	return conversations["chapter_03_marie_evening_return"].get("segments", [])
func _current_segment(thread_id: String) -> Dictionary:
	var segments := _segments(thread_id); var index := int(segment_index_by_thread.get(thread_id, 0)); return segments[index] if index >= 0 and index < segments.size() else {}
func _thread_presentation(id: String) -> Dictionary:
	var titles := {"thread_marie_private": "Marie", "thread_sandra_private": "Sandra", "thread_mathilde_private": "Mathilde", "thread_raphaelle_private": "Raphaëlle"}
	var participant_ids := {"thread_marie_private": "marie", "thread_sandra_private": "sandra", "thread_mathilde_private": "mathilde", "thread_raphaelle_private": "raphaelle"}
	var colors := {"thread_marie_private": "#4F8BFF", "thread_sandra_private": "#20C7C9", "thread_mathilde_private": "#E070A8", "thread_raphaelle_private": "#D69A42"}
	var title := str(titles.get(id, "")); var participant_id := str(participant_ids.get(id, "")); var transcript := transcript_for(id); var last: Dictionary = {}
	for item in transcript:
		if str(item.get("content_type", "")) not in ["OFF_PHONE_TRANSITION", "SYSTEM_DAY_DIVIDER"]: last = item
	var unread := RUNTIME_UNREAD.incoming_unread_count(transcript, presented_time_message_ids, 3)
	return {"thread_id": id, "title": title, "participant_ids": [participant_id, "player"], "last_preview": str(last.get("text", "")), "last_timestamp": str(last.get("timestamp", "")), "unread_count": unread, "has_unread_content": unread > 0, "availability_state": "AVAILABLE", "is_group": false, "is_archived": false, "avatar_ref": title.left(1), "accent_color": str(colors.get(id, "#8D63E6"))}
func _character(id: String, title: String, accent: String, avatar: String) -> Dictionary: return {"character_id": id, "display_name": title, "accent_color": accent, "avatar_ref": avatar, "gallery_enabled": false}
func _gallery_character(id: String, title: String, accent: String, avatar: String) -> Dictionary: return {"character_id": id, "display_name": title, "accent_color": Color.from_string(accent, Color.WHITE), "avatar_ref": avatar, "items": []}
func _gallery_item(asset: Dictionary, character_id: String, index: int) -> Dictionary: return {"item_id": str(asset.get("asset_id", "")), "asset_id": str(asset.get("asset_id", "")), "character_id": character_id, "state": "UNLOCKED", "is_new": true, "sort_key": index, "thumbnail_ref": "", "full_ref": "", "thumbnail_label": str(asset.get("placeholder_label", "Visuel non produit")), "placeholder_label": str(asset.get("placeholder_label", "Visuel non produit")), "source_kind": "gallery", "content_type": "SCENE_IMAGE", "can_share": false, "transfer_rule": "FORBIDDEN", "is_diegetic": false}
func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary: result.append(item.duplicate(true))
	return result
