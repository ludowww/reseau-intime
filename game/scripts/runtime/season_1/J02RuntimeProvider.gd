extends RefCounted

class_name J02RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j02_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
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

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array) -> bool:
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
	segment_index_by_thread = {"thread_marie_private": 0, "thread_mathilde_private": 0}
	pending_choice_ids_by_thread = {}
	initialized = true
	return true

func day_start_presentation() -> Dictionary:
	return runtime_map.get("day_start", {}).duplicate(true)

func presentation_source() -> Dictionary:
	var threads: Array[Dictionary] = []
	for id in unlocked_thread_ids: threads.append(_thread_presentation(id))
	var choices: Dictionary = {}
	var transcripts: Dictionary = {}
	for id in unlocked_thread_ids:
		choices[id] = choices_for(id)
		transcripts[id] = transcript_for(id)
	return {
		"characters": {
			"marie": _character("marie", "Marie", "#4F8BFF", "M"),
			"sandra": _character("sandra", "Sandra", "#20C7C9", "S"),
			"mathilde": _character("mathilde", "Mathilde", "#E070A8", "M"),
			"player": _character("player", "Player", "#8D63E6", ""),
		},
		"threads": threads, "messages_by_thread": transcripts, "choices_by_thread": choices,
		"narrative_time": current_narrative_time_text(), "narrative_time_minutes": current_time_minutes,
	}

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
	current_time_minutes = candidate
	return candidate >= 0
func commit_narrative_time(minutes: int) -> bool:
	if minutes < current_time_minutes or NARRATIVE_TIME.format_narrative_time(minutes) == "": return false
	current_time_minutes = minutes; return true

func gallery_source() -> Dictionary:
	var fixtures := {
		"marie": _gallery_character("marie", "Marie", "#4F8BFF", "M"),
		"sandra": _gallery_character("sandra", "Sandra", "#20C7C9", "S"),
		"mathilde": _gallery_character("mathilde", "Mathilde", "#E070A8", "M"),
	}
	for asset in runtime_map.get("gallery_presentations", []):
		if not gallery_asset_ids.has(str(asset.get("asset_id", ""))): continue
		for character_id in asset.get("character_ids", []):
			var character: Dictionary = fixtures.get(str(character_id), {})
			if character.is_empty(): continue
			var items: Array = character["items"]
			items.append(_gallery_item(asset, str(character_id), items.size()))
			character["items"] = items
	return {"fixtures": fixtures, "character_order": ["marie", "sandra", "mathilde"], "empty_label": "Aucun visuel disponible."}

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
	state.begin_j02()
	phase = "marie_make_room"
	_enter_current_segment("thread_marie_private")
	return {"accepted": true, "destination": "list", "focus_thread_id": "thread_marie_private"}

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id): return {"accepted": false}
	var segment := _current_segment(thread_id)
	var selected: Dictionary = {}
	for choice in segment.get("choices", []):
		if str(choice.get("id", "")) == choice_id: selected = choice; break
	if selected.is_empty() or not state.apply_j02_choice(choice_id): return {"accepted": false}
	pending_choice_ids_by_thread[thread_id] = []
	var before := transcript_for(thread_id).size()
	_append(thread_id, {"message_id": choice_id + "_player", "author_id": "player", "timestamp": "maintenant", "content_type": "TEXT", "text": str(selected.get("text", "")), "media_ref": "", "is_player": true, "is_read": true, "source_day": 2})
	_append_messages(thread_id, selected.get("next_messages", []))
	segment_index_by_thread[thread_id] = int(segment_index_by_thread.get(thread_id, 0)) + 1
	if int(segment_index_by_thread[thread_id]) < _segments(thread_id).size():
		_enter_current_segment(thread_id)
	elif thread_id == "thread_marie_private":
		state.complete_conversation("chapter_02_marie_make_room", "marie")
		phase = "transition_1818"
		pending_transition = _clock_transition(runtime_map["phase_transitions"]["18:18"])
	else:
		phase = "mathilde_offline"
		pending_transition = {"kind": "offline", "thread_id": thread_id}
	return {"accepted": true, "new_messages": transcript_for(thread_id).slice(before), "choices": choices_for(thread_id), "transition": pending_transition.duplicate(true)}

func confirm_day_transition() -> Dictionary:
	if phase == "day_start_pending": return start_day()
	if pending_transition.is_empty() or str(pending_transition.get("kind", "")) != "day_transition": return {"accepted": false}
	pending_transition = {}
	if phase == "transition_1818":
		phase = "arrival_trace_read"
		_append_arrival_trace()
		state.complete_conversation("chapter_02_marie_arrival_trace", "marie")
		return {"accepted": true, "destination": "conversation", "thread_id": "thread_marie_private"}
	if phase == "transition_1822":
		phase = "mathilde_welcome"
		if not unlocked_thread_ids.has("thread_mathilde_private"): unlocked_thread_ids.append("thread_mathilde_private")
		_enter_current_segment("thread_mathilde_private")
		return {"accepted": true, "destination": "list", "focus_thread_id": "thread_mathilde_private"}
	return {"accepted": false}

func on_thread_returned(thread_id: String) -> Dictionary:
	if phase != "arrival_trace_read" or thread_id != "thread_marie_private" or not pending_transition.is_empty(): return {}
	phase = "transition_1822"
	pending_transition = _clock_transition(runtime_map["phase_transitions"]["18:22"])
	return pending_transition.duplicate(true)

func confirm_transition() -> Dictionary:
	if phase != "mathilde_offline" or str(pending_transition.get("kind", "")) != "offline": return {"accepted": false}
	pending_transition = {}
	state.complete_conversation("chapter_02_mathilde_arrival", "mathilde")
	state.install_mathilde()
	for asset in runtime_map.get("gallery_presentations", []):
		var id := str(asset.get("asset_id", ""))
		if not gallery_asset_ids.has(id): gallery_asset_ids.append(id)
	state.complete_day()
	if TimelineState != null: TimelineState.mark_day_complete(2)
	phase = "complete"
	return {"accepted": true, "destination": "day_end", "day_end": runtime_map.get("day_end", {}).duplicate(true)}

func snapshot() -> Dictionary:
	return {"version": SNAPSHOT_VERSION, "phase": phase, "transcripts_by_thread": transcripts_by_thread.duplicate(true), "produced_message_ids": produced_message_ids.duplicate(true), "unlocked_thread_ids": unlocked_thread_ids.duplicate(), "segment_index_by_thread": segment_index_by_thread.duplicate(true), "pending_choice_ids_by_thread": pending_choice_ids_by_thread.duplicate(true), "pending_transition": pending_transition.duplicate(true), "gallery_asset_ids": gallery_asset_ids.duplicate(), "current_time_minutes": current_time_minutes, "presented_time_message_ids": presented_time_message_ids.duplicate(true)}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION: return false
	for key in ["transcripts_by_thread", "produced_message_ids", "segment_index_by_thread", "pending_choice_ids_by_thread", "pending_transition", "presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids", "gallery_asset_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY: return false
	phase = str(value.get("phase", "")); transcripts_by_thread = value["transcripts_by_thread"].duplicate(true); produced_message_ids = value["produced_message_ids"].duplicate(true)
	unlocked_thread_ids.assign(value["unlocked_thread_ids"]); segment_index_by_thread = value["segment_index_by_thread"].duplicate(true); pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true)
	pending_transition = value["pending_transition"].duplicate(true); gallery_asset_ids.assign(value["gallery_asset_ids"])
	var restored_time := int(value.get("current_time_minutes", -1)); if NARRATIVE_TIME.format_narrative_time(restored_time) == "": return false
	current_time_minutes = restored_time; presented_time_message_ids = value["presented_time_message_ids"].duplicate(true)
	return true

func _clock_transition(presentation: Dictionary) -> Dictionary:
	return {"kind": "day_transition", "transition_mode": str(presentation.get("transition_mode", "")), "from_time": current_narrative_time_text(), "to_time": str(presentation.get("to_time", "")), "duration_seconds": float(presentation.get("duration_seconds", 4.0)), "presentation": presentation.duplicate(true)}

func presentation_count_by_id(id: String) -> int:
	var count := 0
	for thread in transcripts_by_thread:
		for item in transcripts_by_thread[thread]:
			if str(item.get("message_id", "")) == id: count += 1
	return count

func _enter_current_segment(thread_id: String) -> void:
	var segment := _current_segment(thread_id)
	_append_messages(thread_id, segment.get("messages", []))
	var ids: Array[String] = []
	for choice in segment.get("choices", []): ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids
	if str(segment.get("id", "")) == "segment_wednesday_marie_make_room_choice": state.open_j02_make_room_choice()

func _append_arrival_trace() -> void:
	var conversation: Dictionary = conversations["chapter_02_marie_arrival_trace"]
	_append_messages("thread_marie_private", conversation["segments"][0].get("messages", []))

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var id := str(message.get("id", ""))
		if runtime_map.get("excluded_message_ids", []).has(id): continue
		var presentation := str(message.get("presentation", ""))
		var type := "SYSTEM_DAY_DIVIDER" if presentation == "time_separator" else ("OFF_PHONE_TRANSITION" if presentation == "offline_beat" else "TEXT")
		_append(thread_id, {"message_id": id, "author_id": str(message.get("sender", "system")), "timestamp": str(message.get("time_label", "")), "content_type": type, "text": str(message.get("text", "")), "media_ref": "", "is_player": false, "is_read": true, "source_day": 2})

func _append(thread_id: String, item: Dictionary) -> bool:
	var id := str(item.get("message_id", ""))
	if id == "" or produced_message_ids.has(id): return false
	var transcript: Array = transcripts_by_thread.get(thread_id, [])
	transcript.append(item.duplicate(true)); transcripts_by_thread[thread_id] = transcript; produced_message_ids[id] = true
	return true

func _segments(thread_id: String) -> Array:
	if thread_id == "thread_marie_private": return conversations["chapter_02_marie_make_room"].get("segments", [])
	var result: Array = []
	for segment in conversations["chapter_02_mathilde_arrival"].get("segments", []):
		if not runtime_map.get("excluded_segment_ids", []).has(str(segment.get("id", ""))): result.append(segment)
	return result
func _current_segment(thread_id: String) -> Dictionary:
	var segments := _segments(thread_id); var index := int(segment_index_by_thread.get(thread_id, 0))
	return segments[index] if index >= 0 and index < segments.size() else {}

func _thread_presentation(id: String) -> Dictionary:
	var title := "Mathilde" if id == "thread_mathilde_private" else ("Sandra" if id == "thread_sandra_private" else "Marie")
	var character := title.to_lower(); var transcript := transcript_for(id); var last: Dictionary = {}
	for item in transcript:
		if str(item.get("content_type", "")) not in ["OFF_PHONE_TRANSITION", "SYSTEM_DAY_DIVIDER"]: last = item
	return {"thread_id": id, "title": title, "participant_ids": [character, "player"], "last_preview": str(last.get("text", "")), "last_timestamp": "18:22" if id == "thread_mathilde_private" else str(last.get("timestamp", "")), "unread_count": 0, "availability_state": "AVAILABLE", "is_group": false, "is_archived": false, "avatar_ref": title.left(1), "accent_color": "#E070A8" if id == "thread_mathilde_private" else ("#20C7C9" if id == "thread_sandra_private" else "#4F8BFF")}
func _character(id: String, title: String, accent: String, avatar: String) -> Dictionary: return {"character_id": id, "display_name": title, "accent_color": accent, "avatar_ref": avatar, "gallery_enabled": false}
func _gallery_character(id: String, title: String, accent: String, avatar: String) -> Dictionary: return {"character_id": id, "display_name": title, "accent_color": Color.from_string(accent, Color.WHITE), "avatar_ref": avatar, "items": []}
func _gallery_item(asset: Dictionary, character_id: String, index: int) -> Dictionary:
	return {"item_id": str(asset.get("asset_id", "")), "asset_id": str(asset.get("asset_id", "")), "character_id": character_id, "state": "UNLOCKED", "is_new": true, "sort_key": index, "thumbnail_ref": "", "full_ref": "", "thumbnail_label": str(asset.get("placeholder_label", "Visuel non produit")), "placeholder_label": str(asset.get("placeholder_label", "Visuel non produit")), "source_kind": "gallery", "content_type": "SCENE_IMAGE", "can_share": false, "transfer_rule": "FORBIDDEN", "is_diegetic": false}
func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary: result.append(item.duplicate(true))
	return result
