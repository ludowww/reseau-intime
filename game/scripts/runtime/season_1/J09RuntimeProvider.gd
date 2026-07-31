extends RefCounted

class_name J09RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j09_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const RUNTIME_UNREAD := preload("res://scripts/runtime/season_1/RuntimeUnread.gd")
const SNAPSHOT_VERSION := 1
const MARIE_THREAD := "thread_marie_private"
const INSTALLATION_ASSET := "S1_A3_J09_SCN_LAVERRIERE_INSTALLATION_01"
const PRIVATE_ASSET := "S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01"
const PUBLIC_ASSET := "S1_A3_J09_DPH_MARIE_LAVERRIERE_PUBLIC_01"
const AFTER_ASSET := "S1_A3_J09_DPH_MARIE_LAVERRIERE_AFTER_01"

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
	if phase != "day_start_pending" or not state.begin_j09():
		return {"accepted": false}
	_unlock_thread(MARIE_THREAD)
	_append_segment_messages(MARIE_THREAD, _entry_segment_id())
	_enter_segment(MARIE_THREAD, "j09_marie_invitation", "entry_incoming")
	return _incoming_result(MARIE_THREAD)

func transcript_for(thread_id: String) -> Array[Dictionary]:
	return _dictionary_array(transcripts_by_thread.get(thread_id, []))

func choices_for(thread_id: String) -> Array[Dictionary]:
	if thread_id != MARIE_THREAD:
		return []
	if phase == "early_quality_choice":
		return _dictionary_array(runtime_map.get("early_quality_choices", []))
	if phase == "late_quality_choice":
		return _dictionary_array(runtime_map.get("late_quality_choices", []))
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
	if thread_id != MARIE_THREAD or not pending_transition.is_empty():
		return {"accepted": false}
	if phase in ["early_quality_choice", "late_quality_choice"]:
		return _apply_quality_choice(choice_id)
	if not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id):
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
	_advance_after_choice(choice_id)
	return {
		"accepted": true,
		"new_messages": transcript_for(thread_id).slice(before),
		"choices": choices_for(thread_id),
		"transition": pending_transition.duplicate(true),
	}

func confirm_day_transition() -> Dictionary:
	return start_day() if phase == "day_start_pending" else {"accepted": false}

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty():
		return {"accepted": false}
	var old_phase := phase
	pending_transition = {}
	match old_phase:
		"to_black_dress":
			if not state.establish_j09_black_dress_trace():
				return {"accepted": false}
			_unlock_visual(INSTALLATION_ASSET)
			_unlock_visual(PRIVATE_ASSET)
			_enter_segment(MARIE_THREAD, "j09_black_dress", "black_dress_incoming")
			return _incoming_result(MARIE_THREAD)
		"to_early_action":
			phase = "early_quality_choice"
			return _incoming_result(MARIE_THREAD)
		"to_late_orientation":
			_enter_segment(MARIE_THREAD, "j09_late_orientation", "late_orientation_incoming")
			return _incoming_result(MARIE_THREAD)
		"to_absence_share":
			if not state.establish_j09_public_trace():
				return {"accepted": false}
			_unlock_visual(PUBLIC_ASSET)
			_enter_segment(MARIE_THREAD, "j09_absence_public_share", "absence_share_incoming")
			return _incoming_result(MARIE_THREAD)
		"early_off_phone", "late_off_phone":
			if not state.establish_j09_public_trace():
				return {"accepted": false}
			_unlock_visual(PUBLIC_ASSET)
			return _enter_after_trace()
		"absence_to_after":
			return _enter_after_trace()
		"to_return":
			_enter_segment(MARIE_THREAD, _return_segment_id(), "return_incoming")
			return _incoming_result(MARIE_THREAD)
		"day_close":
			if not state.complete_j09():
				return {"accepted": false}
			if TimelineState != null:
				TimelineState.mark_day_complete(9)
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
	if thread_id != MARIE_THREAD or not _phase_accepts_batch():
		return false
	if not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 9):
		return false
	match phase:
		"entry_incoming":
			phase = "entry_choice"
		"black_dress_incoming":
			phase = "black_dress_choice"
		"late_orientation_incoming":
			phase = "late_orientation_choice"
		"absence_share_incoming":
			phase = "absence_share_choice"
		"after_incoming":
			phase = "to_return"
			pending_transition = _transition("to_return")
		"return_incoming":
			phase = "return_guided_choice"
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
	for day in range(2, 10):
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
	}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION:
		return false
	var allowed_phases := [
		"day_start_pending", "entry_incoming", "entry_choice", "presence_choice", "to_black_dress",
		"black_dress_incoming", "black_dress_choice", "to_early_action", "early_quality_choice",
		"to_late_orientation", "late_orientation_incoming", "late_orientation_choice", "late_quality_choice",
		"to_absence_share", "absence_share_incoming", "absence_share_choice", "early_off_phone",
		"late_off_phone", "absence_to_after", "after_incoming", "to_return", "return_incoming",
		"return_guided_choice", "dinner_choice", "day_close", "complete",
	]
	if str(value.get("phase", "")) not in allowed_phases:
		return false
	for key in ["transcripts_by_thread", "produced_message_ids", "pending_choice_ids_by_thread", "pending_transition", "presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY:
			return false
	for key in ["unlocked_thread_ids", "gallery_asset_ids", "served_visual_beat_ids"]:
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
	return _restored_phase_consistent()

func presentation_count_by_id(id: String) -> int:
	var count := 0
	for thread in transcripts_by_thread:
		for item in transcripts_by_thread[thread]:
			if str(item.get("message_id", "")) == id:
				count += 1
	return count

func _apply_quality_choice(choice_id: String) -> Dictionary:
	var valid_ids: Array = []
	if phase == "early_quality_choice":
		valid_ids = runtime_map.get("early_quality_choices", [])
	else:
		valid_ids = runtime_map.get("late_quality_choices", [])
	var found := false
	for choice in valid_ids:
		if str(choice.get("choice_id", "")) == choice_id:
			found = true
			break
	if not found or not state.apply_j09_presence_quality(choice_id):
		return {"accepted": false}
	phase = "early_off_phone" if state.marie_j09_presence_choice == "EARLY" else "late_off_phone"
	pending_transition = _transition(phase)
	return {
		"accepted": true,
		"new_messages": [],
		"choices": [],
		"transition": pending_transition.duplicate(true),
	}

func _apply_state_choice(choice_id: String) -> bool:
	if choice_id == "choice_j09_extension_guided":
		return true
	if choice_id.begins_with("choice_j09_presence_"):
		return state.apply_j09_presence_choice(choice_id)
	if choice_id in ["choice_j09_black_dress_guided", "choice_j09_late_orientation_guided", "choice_j09_absence_public_guided"]:
		return true
	if choice_id.begins_with("choice_j09_return_"):
		return true
	if choice_id.begins_with("choice_j09_dinner_"):
		return state.apply_j09_dinner_choice(choice_id)
	return false

func _advance_after_choice(choice_id: String) -> void:
	if choice_id == "choice_j09_extension_guided":
		_set_pending_segment_choices("j09_presence_choice")
		phase = "presence_choice"
	elif choice_id.begins_with("choice_j09_presence_"):
		phase = "to_black_dress"
		pending_transition = _transition("to_black_dress")
	elif choice_id == "choice_j09_black_dress_guided":
		match state.marie_j09_presence_choice:
			"EARLY":
				phase = "to_early_action"
				pending_transition = _transition("to_early_action")
			"LATE":
				phase = "to_late_orientation"
				pending_transition = _transition("to_late_orientation")
			"ABSENCE_HONEST":
				phase = "to_absence_share"
				pending_transition = _transition("to_absence_share")
	elif choice_id == "choice_j09_late_orientation_guided":
		phase = "late_quality_choice"
	elif choice_id == "choice_j09_absence_public_guided":
		phase = "absence_to_after"
		pending_transition = _transition("absence_to_after")
	elif choice_id.begins_with("choice_j09_return_"):
		if state.marie_j09_presence_outcome in ["presence_distracted", "presence_spectator"]:
			state.close_j09_without_dinner_offer()
			phase = "day_close"
			pending_transition = _transition("day_close")
		else:
			_set_pending_segment_choices("j09_dinner_choice")
			phase = "dinner_choice"
	elif choice_id.begins_with("choice_j09_dinner_"):
		phase = "day_close"
		pending_transition = _transition("day_close")

func _enter_after_trace() -> Dictionary:
	if not state.establish_j09_after_trace():
		return {"accepted": false}
	_unlock_visual(AFTER_ASSET)
	_enter_segment(MARIE_THREAD, "j09_after_trace", "after_incoming")
	return _incoming_result(MARIE_THREAD)

func _entry_segment_id() -> String:
	return {
		"CLEAR_HOURS": "j09_entry_clear_hours",
		"HONEST_REFUSAL": "j09_entry_honest_refusal",
		"VAGUE_OR_MISSED": "j09_entry_vague_or_missed",
	}.get(state.marie_j08_echo_outcome, "")

func _return_segment_id() -> String:
	return {
		"presence_active": "j09_return_active",
		"presence_playful_useful": "j09_return_active",
		"presence_distracted": "j09_return_distracted",
		"presence_late_active": "j09_return_late_active",
		"presence_spectator": "j09_return_spectator",
		"presence_bounded_reliable": "j09_return_bounded",
		"absence_honest": "j09_return_absence",
	}.get(state.marie_j09_presence_outcome, "")

func _phase_accepts_batch() -> bool:
	return phase in ["entry_incoming", "black_dress_incoming", "late_orientation_incoming", "absence_share_incoming", "after_incoming", "return_incoming"]

func _enter_segment(thread_id: String, segment_id: String, incoming_phase: String) -> void:
	_unlock_thread(thread_id)
	var segment: Dictionary = segments_by_id.get(segment_id, {})
	_append_messages(thread_id, segment.get("messages", []))
	var ids: Array[String] = []
	for choice in segment.get("choices", []):
		ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids
	phase = incoming_phase

func _set_pending_segment_choices(segment_id: String) -> void:
	var ids: Array[String] = []
	for choice in segments_by_id.get(segment_id, {}).get("choices", []):
		ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[MARIE_THREAD] = ids

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
		"source_day": 9,
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
			"source_day": 9,
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

func _unlock_visual(id: String) -> void:
	if not gallery_asset_ids.has(id):
		gallery_asset_ids.append(id)
	if not served_visual_beat_ids.has(id):
		served_visual_beat_ids.append(id)

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending":
		return state.current_day == "J08" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if phase == "complete":
		return state.current_day in ["J09", "J10"] and (state.day_status == "COMPLETE" or state.current_day == "J10") and pending_transition.is_empty() and served_visual_beat_ids == [INSTALLATION_ASSET, PRIVATE_ASSET, PUBLIC_ASSET, AFTER_ASSET]
	if state.current_day != "J09":
		return false
	if state.day_status != "ACTIVE":
		return false
	var transition_phases := ["to_black_dress", "to_early_action", "to_late_orientation", "to_absence_share", "early_off_phone", "late_off_phone", "absence_to_after", "to_return", "day_close"]
	return not pending_transition.is_empty() if phase in transition_phases else pending_transition.is_empty()

func _thread_presentation(id: String) -> Dictionary:
	var titles := {MARIE_THREAD: "Marie", "thread_sandra_private": "Sandra", "thread_mathilde_private": "Mathilde", "thread_raphaelle_private": "Raphaëlle", "thread_pauline_private": "Pauline", "thread_nico_private": "Nico"}
	var participants := {MARIE_THREAD: "marie", "thread_sandra_private": "sandra", "thread_mathilde_private": "mathilde", "thread_raphaelle_private": "raphaelle", "thread_pauline_private": "pauline", "thread_nico_private": "nico"}
	var colors := {MARIE_THREAD: "#4F8BFF", "thread_sandra_private": "#20C7C9", "thread_mathilde_private": "#E070A8", "thread_raphaelle_private": "#D69A42", "thread_pauline_private": "#E6B84A", "thread_nico_private": "#65B87A"}
	var transcript := transcript_for(id)
	var last: Dictionary = {}
	var unread := RUNTIME_UNREAD.incoming_unread_count(transcript, presented_time_message_ids, 9)
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
