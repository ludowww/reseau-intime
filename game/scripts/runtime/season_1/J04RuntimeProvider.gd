extends RefCounted

class_name J04RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j04_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const SNAPSHOT_VERSION := 1
const PAULINE_THREAD := "thread_pauline_private"
const NICO_THREAD := "thread_nico_private"
const MARIE_THREAD := "thread_marie_private"
const MATHILDE_THREAD := "thread_mathilde_private"

var state
var runtime_map: Dictionary = {}
var conversations: Dictionary = {}
var transcripts_by_thread: Dictionary = {}
var produced_message_ids: Dictionary = {}
var unlocked_thread_ids: Array[String] = []
var gallery_asset_ids: Array[String] = []
var segment_index_by_thread: Dictionary = {}
var pending_choice_ids_by_thread: Dictionary = {}
var pending_transition: Dictionary = {}
var phase := "day_start_pending"
var current_time_minutes := -1
var presented_time_message_ids: Dictionary = {}
var marie_household_echo_presented := false
var mathilde_household_echo_presented := false
var initialized := false

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	state = shared_state
	runtime_map = DataLoader.load_json(RUNTIME_MAP_PATH)
	if state == null or runtime_map.is_empty(): return false
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get("initial_time", "")))
	if current_time_minutes < 0: return false
	for conversation_id in runtime_map.get("conversation_paths", {}):
		var conversation: Dictionary = DataLoader.load_json(str(runtime_map["conversation_paths"][conversation_id]))
		if conversation.is_empty(): return false
		conversations[str(conversation_id)] = conversation
	transcripts_by_thread = cumulative_transcripts.duplicate(true)
	produced_message_ids = cumulative_ids.duplicate(true)
	unlocked_thread_ids.assign(cumulative_threads)
	gallery_asset_ids.assign(cumulative_gallery_ids)
	segment_index_by_thread = {PAULINE_THREAD: 0, NICO_THREAD: 0, MARIE_THREAD: 0, MATHILDE_THREAD: 0}
	pending_choice_ids_by_thread = {}
	pending_transition = {}
	presented_time_message_ids = {}
	initialized = true
	return true

func day_start_presentation() -> Dictionary: return runtime_map.get("day_start", {}).duplicate(true)
func current_narrative_day_short() -> String: return str(runtime_map.get("narrative_day_short", ""))
func current_narrative_time_minutes() -> int: return current_time_minutes
func current_narrative_time_text() -> String: return NARRATIVE_TIME.format_narrative_time(current_time_minutes)

func presentation_source() -> Dictionary:
	var threads: Array[Dictionary] = []
	var choices: Dictionary = {}
	var transcripts: Dictionary = {}
	for id in unlocked_thread_ids:
		threads.append(_thread_presentation(id))
		choices[id] = choices_for(id)
		transcripts[id] = transcript_for(id)
	return {
		"characters": _characters(), "threads": threads,
		"messages_by_thread": transcripts, "choices_by_thread": choices,
		"narrative_day_short": current_narrative_day_short(),
		"narrative_time": current_narrative_time_text(), "narrative_time_minutes": current_time_minutes,
	}

func start_day() -> Dictionary:
	if phase != "day_start_pending": return {"accepted": false}
	state.begin_j04()
	if not unlocked_thread_ids.has(PAULINE_THREAD): unlocked_thread_ids.append(PAULINE_THREAD)
	phase = "pauline_public_relay"
	_enter_current_segment(PAULINE_THREAD)
	return {"accepted": true, "destination": "list", "focus_thread_id": PAULINE_THREAD}

func transcript_for(thread_id: String) -> Array[Dictionary]: return _dictionary_array(transcripts_by_thread.get(thread_id, []))
func choices_for(thread_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var segment := _current_segment(thread_id)
	for choice in segment.get("choices", []):
		if pending_choice_ids_by_thread.get(thread_id, []).has(str(choice.get("id", ""))):
			result.append({"choice_id": str(choice.get("id", "")), "text": str(choice.get("text", "")), "enabled": true, "confirmation_required": false})
	return result

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id): return {"accepted": false}
	var segment := _current_segment(thread_id)
	var selected: Dictionary = {}
	for choice in segment.get("choices", []):
		if str(choice.get("id", "")) == choice_id: selected = choice; break
	if selected.is_empty() or not state.apply_j04_choice(choice_id): return {"accepted": false}
	pending_choice_ids_by_thread[thread_id] = []
	var before := transcript_for(thread_id).size()
	_append(thread_id, {"message_id": choice_id + "_player", "author_id": "player", "timestamp": current_narrative_time_text(), "content_type": "TEXT", "text": str(selected.get("text", "")), "media_ref": "", "is_player": true, "is_read": true, "source_day": 4})
	_append_messages(thread_id, selected.get("next_messages", []))
	segment_index_by_thread[thread_id] = int(segment_index_by_thread.get(thread_id, 0)) + 1
	if int(segment_index_by_thread[thread_id]) < _segments(thread_id).size():
		_enter_current_segment(thread_id)
	elif thread_id == PAULINE_THREAD:
		state.establish_j04_pauline_records()
		state.complete_conversation("chapter_04_pauline_public_photo_relay", "pauline")
		_unlock_gallery_asset("S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01")
		_unlock_gallery_asset("S1_A1_J04_SCN_MARIE_SOCIAL_MOTION_01")
		phase = "transition_1405"
		pending_transition = _clock_transition(runtime_map["nico_transition"])
	elif thread_id == NICO_THREAD:
		state.establish_j04_nico_records()
		state.complete_conversation("chapter_04_nico_saved_seat_followup", "nico")
		_unlock_gallery_asset("S1_A1_J04_SCN_NICO_SAVED_SEAT_01")
		phase = "transition_1805"
		pending_transition = _clock_transition(runtime_map["household_transition"])
	return {"accepted": true, "new_messages": transcript_for(thread_id).slice(before), "choices": choices_for(thread_id), "transition": pending_transition.duplicate(true)}

func confirm_day_transition() -> Dictionary:
	if phase == "day_start_pending": return start_day()
	if phase in ["transition_1405", "transition_1805"] and str(pending_transition.get("kind", "")) == "day_transition":
		return confirm_transition()
	return {"accepted": false}

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty(): return {"accepted": false}
	var old_phase := phase
	pending_transition = {}
	if old_phase == "transition_1405":
		if not unlocked_thread_ids.has(NICO_THREAD): unlocked_thread_ids.append(NICO_THREAD)
		phase = "nico_saved_seat"
		_enter_current_segment(NICO_THREAD)
		return {"accepted": true, "destination": "list", "focus_thread_id": NICO_THREAD, "unlocked_thread_id": NICO_THREAD, "notification": {"body": "La chaise qui ne penche pas est encore libre."}}
	if old_phase == "transition_1805":
		phase = "household_echoes"
		_enter_automatic_echo(MARIE_THREAD)
		_enter_automatic_echo(MATHILDE_THREAD)
		return {"accepted": true, "destination": "list", "focus_thread_id": MARIE_THREAD, "unlocked_thread_id": MARIE_THREAD, "notification": {"body": "Rapport du foyer."}}
	if old_phase == "household_close":
		state.complete_j04_household()
		_unlock_gallery_asset("S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01")
		state.complete_day()
		if TimelineState != null: TimelineState.mark_day_complete(4)
		phase = "complete"
		return {"accepted": true, "destination": "day_end", "day_end": runtime_map["day_end"].duplicate(true)}
	return {"accepted": false}

func on_thread_returned(_thread_id: String) -> Dictionary:
	if phase == "household_close" and not pending_transition.is_empty(): return pending_transition.duplicate(true)
	return {}

func mark_message_presented(message_id: String) -> bool:
	if message_id == "" or presented_time_message_ids.has(message_id): return false
	var timestamp := ""
	for thread_id in transcripts_by_thread:
		for message in transcripts_by_thread[thread_id]:
			if str(message.get("message_id", "")) == message_id: timestamp = str(message.get("timestamp", "")); break
		if timestamp != "": break
	presented_time_message_ids[message_id] = true
	var candidate := NARRATIVE_TIME.parse_narrative_time(timestamp)
	if candidate >= current_time_minutes: current_time_minutes = candidate
	if message_id == "msg_friday_marie_household_003": marie_household_echo_presented = true
	if message_id == "msg_friday_mathilde_household_003": mathilde_household_echo_presented = true
	if phase == "household_echoes" and marie_household_echo_presented and mathilde_household_echo_presented:
		state.complete_conversation("chapter_04_marie_household_report", "marie")
		state.complete_conversation("chapter_04_mathilde_bathroom_correction", "mathilde")
		phase = "household_close"
		pending_transition = runtime_map["household_close"].duplicate(true)
		pending_transition["kind"] = "offline"
	return true

func commit_narrative_time(minutes: int) -> bool:
	if minutes < current_time_minutes or NARRATIVE_TIME.format_narrative_time(minutes) == "": return false
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
	var all_assets: Array = DataLoader.load_json("res://data/runtime/season_1/j02_runtime_map.json").get("gallery_presentations", []).duplicate(true)
	all_assets.append_array(DataLoader.load_json("res://data/runtime/season_1/j03_runtime_map.json").get("gallery_presentations", []))
	all_assets.append_array(runtime_map.get("gallery_presentations", []))
	for asset in all_assets:
		if not gallery_asset_ids.has(str(asset.get("asset_id", ""))): continue
		for character_id in asset.get("character_ids", []):
			var character: Dictionary = fixtures.get(str(character_id), {})
			if character.is_empty(): continue
			var items: Array = character["items"]
			items.append(_gallery_item(asset, str(character_id), items.size()))
			character["items"] = items
	return {"fixtures": fixtures, "character_order": ["marie", "sandra", "mathilde", "raphaelle", "pauline", "nico"], "empty_label": "Aucun visuel disponible."}

func snapshot() -> Dictionary:
	return {"version": SNAPSHOT_VERSION, "phase": phase, "transcripts_by_thread": transcripts_by_thread.duplicate(true), "produced_message_ids": produced_message_ids.duplicate(true), "unlocked_thread_ids": unlocked_thread_ids.duplicate(), "gallery_asset_ids": gallery_asset_ids.duplicate(), "segment_index_by_thread": segment_index_by_thread.duplicate(true), "pending_choice_ids_by_thread": pending_choice_ids_by_thread.duplicate(true), "pending_transition": pending_transition.duplicate(true), "current_time_minutes": current_time_minutes, "presented_time_message_ids": presented_time_message_ids.duplicate(true), "marie_household_echo_presented": marie_household_echo_presented, "mathilde_household_echo_presented": mathilde_household_echo_presented}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION: return false
	var restored_phase := str(value.get("phase", ""))
	if restored_phase not in ["day_start_pending", "pauline_public_relay", "transition_1405", "nico_saved_seat", "transition_1805", "household_echoes", "household_close", "complete"]: return false
	for key in ["transcripts_by_thread", "produced_message_ids", "segment_index_by_thread", "pending_choice_ids_by_thread", "pending_transition", "presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids", "gallery_asset_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY: return false
	var restored_time := int(value.get("current_time_minutes", -1))
	if NARRATIVE_TIME.format_narrative_time(restored_time) == "": return false
	phase = restored_phase
	transcripts_by_thread = value["transcripts_by_thread"].duplicate(true)
	produced_message_ids = value["produced_message_ids"].duplicate(true)
	unlocked_thread_ids.assign(value["unlocked_thread_ids"])
	gallery_asset_ids.assign(value["gallery_asset_ids"])
	segment_index_by_thread = value["segment_index_by_thread"].duplicate(true)
	pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true)
	pending_transition = value["pending_transition"].duplicate(true)
	current_time_minutes = restored_time
	presented_time_message_ids = value["presented_time_message_ids"].duplicate(true)
	marie_household_echo_presented = bool(value.get("marie_household_echo_presented", false))
	mathilde_household_echo_presented = bool(value.get("mathilde_household_echo_presented", false))
	return _restored_phase_consistent()

func presentation_count_by_id(id: String) -> int:
	var count := 0
	for thread in transcripts_by_thread:
		for item in transcripts_by_thread[thread]:
			if str(item.get("message_id", "")) == id: count += 1
	return count

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending": return state.current_day == "J03" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.current_day != "J04": return false
	if phase == "complete": return state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.day_status != "ACTIVE": return false
	if phase in ["transition_1405", "transition_1805", "household_close"]: return not pending_transition.is_empty()
	return pending_transition.is_empty()

func _clock_transition(value: Dictionary) -> Dictionary:
	var result := value.duplicate(true)
	result["kind"] = "day_transition"
	result["from_time"] = current_narrative_time_text()
	return result

func _enter_current_segment(thread_id: String) -> void:
	var segment := _current_segment(thread_id)
	_append_messages(thread_id, segment.get("messages", []))
	var ids: Array[String] = []
	for choice in segment.get("choices", []): ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids

func _enter_automatic_echo(thread_id: String) -> void:
	_append_messages(thread_id, _current_segment(thread_id).get("messages", []))
	pending_choice_ids_by_thread[thread_id] = []

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var id := str(message.get("id", ""))
		if id == "visual_friday_pauline_group_set":
			var photo: Dictionary = runtime_map["photo_set"]
			_append(thread_id, {"message_id": id, "author_id": str(message.get("sender", "")), "timestamp": str(message.get("time_label", "")), "content_type": "IMAGE", "text": "", "media_ref": str(photo["asset_id"]), "asset_id": str(photo["asset_id"]), "trace_id": str(photo["trace_id"]), "source_kind": "messages", "access_state": "UNLOCKED", "placeholder_label": str(photo["placeholder_label"]), "photo_set_children": photo["children"].duplicate(), "is_player": false, "is_read": false, "source_day": 4})
		else:
			_append(thread_id, {"message_id": id, "author_id": str(message.get("sender", "system")), "timestamp": str(message.get("time_label", "")), "content_type": "TEXT", "text": str(message.get("text", "")), "media_ref": "", "is_player": false, "is_read": false, "source_day": 4})

func _append(thread_id: String, item: Dictionary) -> bool:
	var id := str(item.get("message_id", ""))
	if id == "" or produced_message_ids.has(id): return false
	var transcript: Array = transcripts_by_thread.get(thread_id, [])
	transcript.append(item.duplicate(true))
	transcripts_by_thread[thread_id] = transcript
	produced_message_ids[id] = true
	return true

func _segments(thread_id: String) -> Array:
	if thread_id == PAULINE_THREAD: return conversations["chapter_04_pauline_public_photo_relay"].get("segments", [])
	if thread_id == NICO_THREAD: return conversations["chapter_04_nico_saved_seat_followup"].get("segments", [])
	if thread_id == MARIE_THREAD: return conversations["chapter_04_marie_household_report"].get("segments", [])
	return conversations["chapter_04_mathilde_bathroom_correction"].get("segments", [])

func _current_segment(thread_id: String) -> Dictionary:
	var segments := _segments(thread_id)
	var index := int(segment_index_by_thread.get(thread_id, 0))
	return segments[index] if index >= 0 and index < segments.size() else {}

func _thread_presentation(id: String) -> Dictionary:
	var titles := {MARIE_THREAD: "Marie", "thread_sandra_private": "Sandra", MATHILDE_THREAD: "Mathilde", "thread_raphaelle_private": "Raphaëlle", PAULINE_THREAD: "Pauline", NICO_THREAD: "Nico"}
	var participants := {MARIE_THREAD: "marie", "thread_sandra_private": "sandra", MATHILDE_THREAD: "mathilde", "thread_raphaelle_private": "raphaelle", PAULINE_THREAD: "pauline", NICO_THREAD: "nico"}
	var colors := {MARIE_THREAD: "#4F8BFF", "thread_sandra_private": "#20C7C9", MATHILDE_THREAD: "#E070A8", "thread_raphaelle_private": "#D69A42", PAULINE_THREAD: "#E6B84A", NICO_THREAD: "#65B87A"}
	var transcript := transcript_for(id)
	var last: Dictionary = {}
	var unread := 0
	for item in transcript:
		if str(item.get("content_type", "")) != "OFF_PHONE_TRANSITION": last = item
		if not bool(item.get("is_read", true)) and not presented_time_message_ids.has(str(item.get("message_id", ""))): unread += 1
	var title := str(titles.get(id, ""))
	return {"thread_id": id, "title": title, "participant_ids": [str(participants.get(id, "")), "player"], "last_preview": str(last.get("text", "Photo" if str(last.get("content_type", "")) == "IMAGE" else "")), "last_timestamp": str(last.get("timestamp", "")), "unread_count": unread, "availability_state": "AVAILABLE", "is_group": false, "is_archived": false, "avatar_ref": title.left(1), "accent_color": str(colors.get(id, "#8D63E6"))}

func _characters() -> Dictionary:
	return {"marie": _character("marie", "Marie", "#4F8BFF", "M"), "sandra": _character("sandra", "Sandra", "#20C7C9", "S"), "mathilde": _character("mathilde", "Mathilde", "#E070A8", "M"), "raphaelle": _character("raphaelle", "Raphaëlle", "#D69A42", "R"), "pauline": _character("pauline", "Pauline", "#E6B84A", "P"), "nico": _character("nico", "Nico", "#65B87A", "N"), "player": _character("player", "Player", "#8D63E6", "")}
func _character(id: String, title: String, accent: String, avatar: String) -> Dictionary: return {"character_id": id, "display_name": title, "accent_color": accent, "avatar_ref": avatar, "gallery_enabled": false}
func _gallery_character(id: String, title: String, accent: String, avatar: String) -> Dictionary: return {"character_id": id, "display_name": title, "accent_color": Color.from_string(accent, Color.WHITE), "avatar_ref": avatar, "items": []}
func _gallery_item(asset: Dictionary, character_id: String, index: int) -> Dictionary: return {"item_id": str(asset.get("asset_id", "")), "asset_id": str(asset.get("asset_id", "")), "character_id": character_id, "state": "UNLOCKED", "is_new": true, "sort_key": index, "thumbnail_ref": "", "full_ref": "", "thumbnail_label": str(asset.get("placeholder_label", "Visuel non produit")), "placeholder_label": str(asset.get("placeholder_label", "Visuel non produit")), "source_kind": str(asset.get("source_kind", "gallery")), "content_type": str(asset.get("content_type", "SCENE_IMAGE")), "can_share": bool(asset.get("can_share", false)), "transfer_rule": str(asset.get("transfer_rule", "FORBIDDEN")), "is_diegetic": bool(asset.get("is_diegetic", false))}
func _unlock_gallery_asset(id: String) -> void:
	if not gallery_asset_ids.has(id): gallery_asset_ids.append(id)
func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary: result.append(item.duplicate(true))
	return result
