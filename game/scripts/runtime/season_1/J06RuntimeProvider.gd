extends RefCounted

class_name J06RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j06_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const RUNTIME_UNREAD := preload("res://scripts/runtime/season_1/RuntimeUnread.gd")
const SNAPSHOT_VERSION := 1
const MARIE_THREAD := "thread_marie_private"
const MATHILDE_THREAD := "thread_mathilde_private"
const HOUSEHOLD_ASSET := "S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01"
const MATHILDE_ASSET := "S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01"
const NO_EXTERNAL_ASSET := "S1_A2_J06_SCN_SUNDAY_WITHOUT_EXTERNAL_PROGRESS_01"
const MARIE_ASSET := "S1_A2_J06_SCN_MARIE_CONCRETE_RETURN_01"

var state
var runtime_map: Dictionary = {}
var conversations: Dictionary = {}
var transcripts_by_thread: Dictionary = {}
var produced_message_ids: Dictionary = {}
var unlocked_thread_ids: Array[String] = []
var gallery_asset_ids: Array[String] = []
var served_visual_beat_ids: Array[String] = []
var segment_index_by_thread: Dictionary = {}
var pending_choice_ids_by_thread: Dictionary = {}
var pending_transition: Dictionary = {}
var phase := "day_start_pending"
var current_time_minutes := -1
var presented_time_message_ids: Dictionary = {}
var initialized := false

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	state = shared_state
	runtime_map = DataLoader.load_json(RUNTIME_MAP_PATH)
	if state == null or runtime_map.is_empty():
		return false
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get("initial_time", "")))
	if current_time_minutes < 0:
		return false
	for conversation_id in runtime_map.get("conversation_paths", {}):
		var conversation: Dictionary = DataLoader.load_json(str(runtime_map["conversation_paths"][conversation_id]))
		if conversation.is_empty():
			return false
		conversations[str(conversation_id)] = conversation
	transcripts_by_thread = cumulative_transcripts.duplicate(true)
	produced_message_ids = cumulative_ids.duplicate(true)
	unlocked_thread_ids.assign(cumulative_threads)
	gallery_asset_ids.assign(cumulative_gallery_ids)
	served_visual_beat_ids = []
	segment_index_by_thread = {MATHILDE_THREAD: 0, MARIE_THREAD: 0}
	pending_choice_ids_by_thread = {}
	pending_transition = {}
	presented_time_message_ids = {}
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
	if phase != "day_start_pending":
		return {"accepted": false}
	state.begin_j06()
	if state.is_mathilde_j06_eligible():
		if not unlocked_thread_ids.has(MATHILDE_THREAD):
			unlocked_thread_ids.append(MATHILDE_THREAD)
		phase = "mathilde_incoming"
		segment_index_by_thread[MATHILDE_THREAD] = 0
		_enter_current_segment(MATHILDE_THREAD)
		return {"accepted": true, "destination": "list", "focus_thread_id": MATHILDE_THREAD}
	if not state.record_j06_mathilde_unavailable():
		return {"accepted": false}
	_unlock_gallery_asset(NO_EXTERNAL_ASSET)
	_record_visual_beat(NO_EXTERNAL_ASSET)
	_record_visual_beat(HOUSEHOLD_ASSET)
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time("18:35")
	_enter_marie_return()
	return {"accepted": true, "destination": "list", "focus_thread_id": MARIE_THREAD}

func transcript_for(thread_id: String) -> Array[Dictionary]:
	return _dictionary_array(transcripts_by_thread.get(thread_id, []))

func choices_for(thread_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var segment := _current_segment(thread_id)
	for choice in segment.get("choices", []):
		if pending_choice_ids_by_thread.get(thread_id, []).has(str(choice.get("id", ""))):
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
	var segment := _current_segment(thread_id)
	var selected: Dictionary = {}
	for choice in segment.get("choices", []):
		if str(choice.get("id", "")) == choice_id:
			selected = choice
			break
	if selected.is_empty():
		return {"accepted": false}
	if thread_id == MATHILDE_THREAD:
		if not state.apply_j06_mathilde_choice(choice_id):
			return {"accepted": false}
	elif thread_id == MARIE_THREAD:
		if not state.apply_j06_marie_choice(choice_id):
			return {"accepted": false}
	else:
		return {"accepted": false}
	pending_choice_ids_by_thread[thread_id] = []
	var before := transcript_for(thread_id).size()
	_append(thread_id, {
		"message_id": choice_id + "_player",
		"author_id": "player",
		"timestamp": current_narrative_time_text(),
		"content_type": "TEXT",
		"text": str(selected.get("text", "")),
		"media_ref": "",
		"is_player": true,
		"is_read": true,
		"source_day": 6,
	})
	_append_messages(thread_id, selected.get("next_messages", []))
	if thread_id == MATHILDE_THREAD:
		segment_index_by_thread[thread_id] = int(segment_index_by_thread.get(thread_id, 0)) + 1
		if choice_id == "choice_sun_mathilde_what_guided":
			phase = "mathilde_exchange"
			_enter_current_segment(MATHILDE_THREAD)
		else:
			state.complete_conversation("chapter_06_mathilde_morning_afterglow", "mathilde")
			_unlock_gallery_asset(MATHILDE_ASSET)
			_record_visual_beat(MATHILDE_ASSET)
			phase = "household_beat"
			pending_transition = runtime_map.get("household_beat", {}).duplicate(true)
			pending_transition["kind"] = "household_beat"
			pending_transition["from_time"] = current_narrative_time_text()
	else:
		state.complete_conversation("chapter_06_marie_concrete_return", "marie")
		_unlock_gallery_asset(MARIE_ASSET)
		_record_visual_beat(MARIE_ASSET)
		if state.marie_j06_return_outcome == "IMMEDIATE_ACT":
			phase = "marie_resolution"
			pending_transition = runtime_map.get("marie_immediate_resolution", {}).duplicate(true)
			pending_transition["kind"] = "marie_resolution"
			pending_transition["from_time"] = current_narrative_time_text()
		else:
			phase = "day_close"
			pending_transition = _day_close_transition()
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
	if old_phase == "household_beat":
		_record_visual_beat(HOUSEHOLD_ASSET)
		_enter_marie_return()
		return {
			"accepted": true,
			"destination": "conversation",
			"thread_id": MATHILDE_THREAD,
			"unlocked_thread_id": MARIE_THREAD,
			"notification": {"body": "Nouveau message !"},
		}
	if old_phase == "marie_resolution":
		phase = "day_close"
		pending_transition = _day_close_transition()
		return {"accepted": true, "destination": "day_transition", "transition": pending_transition.duplicate(true)}
	if old_phase == "day_close":
		if not state.complete_j06():
			return {"accepted": false}
		if TimelineState != null:
			TimelineState.mark_day_complete(6)
		phase = "complete"
		return {"accepted": true, "destination": "day_end", "day_end": runtime_map["day_end"].duplicate(true)}
	return {"accepted": false}

func on_thread_returned(_thread_id: String) -> Dictionary:
	if phase in ["household_beat", "day_close"] and not pending_transition.is_empty():
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
	if phase == "mathilde_incoming" and thread_id == MATHILDE_THREAD:
		if not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(MATHILDE_THREAD), presented_time_message_ids, 6):
			return false
		phase = "mathilde_exchange"
		return true
	if phase == "marie_incoming" and thread_id == MARIE_THREAD:
		if not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(MARIE_THREAD), presented_time_message_ids, 6):
			return false
		phase = "marie_return"
		return true
	return false

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
	var all_assets: Array = DataLoader.load_json("res://data/runtime/season_1/j02_runtime_map.json").get("gallery_presentations", []).duplicate(true)
	all_assets.append_array(DataLoader.load_json("res://data/runtime/season_1/j03_runtime_map.json").get("gallery_presentations", []))
	all_assets.append_array(DataLoader.load_json("res://data/runtime/season_1/j04_runtime_map.json").get("gallery_presentations", []))
	all_assets.append_array(DataLoader.load_json("res://data/runtime/season_1/j05_runtime_map.json").get("gallery_presentations", []))
	all_assets.append_array(runtime_map.get("gallery_presentations", []))
	for asset in all_assets:
		if not gallery_asset_ids.has(str(asset.get("asset_id", ""))):
			continue
		for character_id in asset.get("character_ids", []):
			var character: Dictionary = fixtures.get(str(character_id), {})
			if character.is_empty():
				continue
			var items: Array = character["items"]
			items.append(_gallery_item(asset, str(character_id), items.size()))
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
		"segment_index_by_thread": segment_index_by_thread.duplicate(true),
		"pending_choice_ids_by_thread": pending_choice_ids_by_thread.duplicate(true),
		"pending_transition": pending_transition.duplicate(true),
		"current_time_minutes": current_time_minutes,
		"presented_time_message_ids": presented_time_message_ids.duplicate(true),
	}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION:
		return false
	var restored_phase := str(value.get("phase", ""))
	if restored_phase not in ["day_start_pending", "mathilde_incoming", "mathilde_exchange", "no_external_continuity", "household_beat", "marie_incoming", "marie_return", "marie_resolution", "day_close", "complete"]:
		return false
	for key in ["transcripts_by_thread", "produced_message_ids", "segment_index_by_thread", "pending_choice_ids_by_thread", "pending_transition", "presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY:
			return false
	for key in ["unlocked_thread_ids", "gallery_asset_ids", "served_visual_beat_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY:
			return false
	var restored_time := int(value.get("current_time_minutes", -1))
	if NARRATIVE_TIME.format_narrative_time(restored_time) == "":
		return false
	phase = restored_phase
	transcripts_by_thread = value["transcripts_by_thread"].duplicate(true)
	produced_message_ids = value["produced_message_ids"].duplicate(true)
	unlocked_thread_ids.assign(value["unlocked_thread_ids"])
	gallery_asset_ids.assign(value["gallery_asset_ids"])
	served_visual_beat_ids.assign(value["served_visual_beat_ids"])
	segment_index_by_thread = value["segment_index_by_thread"].duplicate(true)
	pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true)
	pending_transition = value["pending_transition"].duplicate(true)
	current_time_minutes = restored_time
	presented_time_message_ids = value["presented_time_message_ids"].duplicate(true)
	return _restored_phase_consistent()

func presentation_count_by_id(id: String) -> int:
	var count := 0
	for thread in transcripts_by_thread:
		for item in transcripts_by_thread[thread]:
			if str(item.get("message_id", "")) == id:
				count += 1
	return count

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending":
		return state.current_day == "J05" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.current_day != "J06":
		return false
	if phase == "complete":
		return state.day_status == "COMPLETE" and pending_transition.is_empty() and served_visual_beat_ids.size() == 3
	if state.day_status != "ACTIVE":
		return false
	if phase in ["household_beat", "marie_resolution", "day_close"]:
		return not pending_transition.is_empty()
	return pending_transition.is_empty()

func _enter_marie_return() -> void:
	if not unlocked_thread_ids.has(MARIE_THREAD):
		unlocked_thread_ids.append(MARIE_THREAD)
	var mathilde_served: bool = state.mathilde_j06_outcome in ["ACKNOWLEDGED_RESPECTFUL", "ACKNOWLEDGED_PLAYFUL", "DISTANCE_RESTORED"]
	if state.marie_j05_shared_hour_resolution == "PAID" and not mathilde_served:
		segment_index_by_thread[MARIE_THREAD] = 0
		_enter_current_segment(MARIE_THREAD)
	else:
		segment_index_by_thread[MARIE_THREAD] = 1 if mathilde_served else 2
		_append_messages(MARIE_THREAD, _current_segment(MARIE_THREAD).get("messages", []))
		segment_index_by_thread[MARIE_THREAD] = 3
		_set_pending_choices(MARIE_THREAD, _current_segment(MARIE_THREAD))
	phase = "marie_incoming"

func _day_close_transition() -> Dictionary:
	var result: Dictionary = runtime_map.get("day_close", {}).duplicate(true)
	result["kind"] = "day_close"
	return result

func _enter_current_segment(thread_id: String) -> void:
	var segment := _current_segment(thread_id)
	_append_messages(thread_id, segment.get("messages", []))
	_set_pending_choices(thread_id, segment)

func _set_pending_choices(thread_id: String, segment: Dictionary) -> void:
	var ids: Array[String] = []
	for choice in segment.get("choices", []):
		ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		_append(thread_id, {
			"message_id": str(message.get("id", "")),
			"author_id": str(message.get("sender", "system")),
			"timestamp": str(message.get("time_label", "")),
			"content_type": "TEXT",
			"text": str(message.get("text", "")),
			"media_ref": "",
			"is_player": str(message.get("sender", "")) == "player",
			"is_read": false,
			"source_day": 6,
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

func _segments(thread_id: String) -> Array:
	if thread_id == MATHILDE_THREAD:
		return conversations["chapter_06_mathilde_morning_afterglow"].get("segments", [])
	return conversations["chapter_06_marie_concrete_return"].get("segments", [])

func _current_segment(thread_id: String) -> Dictionary:
	var segments := _segments(thread_id)
	var index := int(segment_index_by_thread.get(thread_id, 0))
	return segments[index] if index >= 0 and index < segments.size() else {}

func _thread_presentation(id: String) -> Dictionary:
	var titles := {MARIE_THREAD: "Marie", "thread_sandra_private": "Sandra", MATHILDE_THREAD: "Mathilde", "thread_raphaelle_private": "Raphaëlle", "thread_pauline_private": "Pauline", "thread_nico_private": "Nico"}
	var participants := {MARIE_THREAD: "marie", "thread_sandra_private": "sandra", MATHILDE_THREAD: "mathilde", "thread_raphaelle_private": "raphaelle", "thread_pauline_private": "pauline", "thread_nico_private": "nico"}
	var colors := {MARIE_THREAD: "#4F8BFF", "thread_sandra_private": "#20C7C9", MATHILDE_THREAD: "#E070A8", "thread_raphaelle_private": "#D69A42", "thread_pauline_private": "#E6B84A", "thread_nico_private": "#65B87A"}
	var transcript := transcript_for(id)
	var last: Dictionary = {}
	var unread := RUNTIME_UNREAD.incoming_unread_count(transcript, presented_time_message_ids, 6)
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

func _unlock_gallery_asset(id: String) -> void:
	if not gallery_asset_ids.has(id):
		gallery_asset_ids.append(id)

func _record_visual_beat(id: String) -> void:
	if not served_visual_beat_ids.has(id):
		served_visual_beat_ids.append(id)

func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append(item.duplicate(true))
	return result
