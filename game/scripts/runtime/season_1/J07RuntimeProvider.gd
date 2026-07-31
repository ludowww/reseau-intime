extends RefCounted

class_name J07RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j07_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const RUNTIME_UNREAD := preload("res://scripts/runtime/season_1/RuntimeUnread.gd")
const SNAPSHOT_VERSION := 1
const RAPHAELLE_THREAD := "thread_raphaelle_private"
const NICO_THREAD := "thread_nico_private"
const MARIE_THREAD := "thread_marie_private"
const RAPHAELLE_ASSET := "S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01"
const NICO_ASSET := "S1_A2_J07_SCN_NICO_AFTER_SERVICE_CONFIDENCE_01"
const MARIE_ASSET := "S1_A2_J07_SCN_MARIE_HOUSEHOLD_REQUEST_01"

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
	transcripts_by_thread = cumulative_transcripts.duplicate(true)
	produced_message_ids = cumulative_ids.duplicate(true)
	unlocked_thread_ids.assign(cumulative_threads)
	gallery_asset_ids.assign(cumulative_gallery_ids)
	served_visual_beat_ids = []
	segment_index_by_thread = {RAPHAELLE_THREAD: 0, NICO_THREAD: 0, MARIE_THREAD: 0}
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
	state.begin_j07()
	if not state.resolve_j07_morning_consequence():
		return {"accepted": false}
	phase = "morning_consequence"
	pending_transition = runtime_map.get("morning_consequence", {}).duplicate(true)
	pending_transition["kind"] = "morning_consequence"
	pending_transition["from_time"] = current_narrative_time_text()
	pending_transition["text"] = str(pending_transition.get("text_due" if state.marie_j06_return_resolution == "PAID" else "text_not_due", ""))
	pending_transition.erase("text_due")
	pending_transition.erase("text_not_due")
	return {"accepted": true, "destination": "day_transition", "transition": pending_transition.duplicate(true)}

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
	if selected.is_empty() or not _apply_state_choice(thread_id, choice_id):
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
		"source_day": 7,
	})
	_append_messages(thread_id, selected.get("next_messages", []))
	_advance_after_choice(thread_id, choice_id)
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
	if old_phase == "morning_consequence":
		_enter_incoming(RAPHAELLE_THREAD, "raphaelle_incoming")
		return {
			"accepted": true,
			"destination": "list",
			"focus_thread_id": RAPHAELLE_THREAD,
			"notification": {"body": "Nouveau message !"},
		}
	if old_phase == "to_nico":
		_enter_incoming(NICO_THREAD, "nico_incoming")
		return {
			"accepted": true,
			"destination": "conversation",
			"thread_id": RAPHAELLE_THREAD,
			"unlocked_thread_id": NICO_THREAD,
			"notification": {"body": "Nouveau message !"},
		}
	if old_phase == "to_marie":
		_enter_incoming(MARIE_THREAD, "marie_incoming")
		return {
			"accepted": true,
			"destination": "conversation",
			"thread_id": NICO_THREAD,
			"unlocked_thread_id": MARIE_THREAD,
			"notification": {"body": "Nouveau message !"},
		}
	if old_phase == "day_close":
		if not state.complete_j07():
			return {"accepted": false}
		if TimelineState != null:
			TimelineState.mark_day_complete(7)
		phase = "complete"
		return {"accepted": true, "destination": "day_end", "day_end": runtime_map["day_end"].duplicate(true)}
	return {"accepted": false}

func on_thread_returned(_thread_id: String) -> Dictionary:
	if phase in ["to_nico", "to_marie", "day_close"] and not pending_transition.is_empty():
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
	var expected := {
		"raphaelle_incoming": RAPHAELLE_THREAD,
		"nico_incoming": NICO_THREAD,
		"marie_incoming": MARIE_THREAD,
	}
	if not expected.has(phase) or str(expected[phase]) != thread_id:
		return false
	if not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 7):
		return false
	phase = {
		"raphaelle_incoming": "raphaelle_exchange",
		"nico_incoming": "nico_exchange",
		"marie_incoming": "marie_choice",
	}[phase]
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
	for day in range(2, 8):
		all_assets.append_array(DataLoader.load_json("res://data/runtime/season_1/j%02d_runtime_map.json" % day).get("gallery_presentations", []))
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
	if restored_phase not in ["day_start_pending", "morning_consequence", "raphaelle_incoming", "raphaelle_exchange", "to_nico", "nico_incoming", "nico_exchange", "nico_main_choice", "nico_continuation_choice", "to_marie", "marie_incoming", "marie_choice", "day_close", "complete"]:
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

func _apply_state_choice(thread_id: String, choice_id: String) -> bool:
	if thread_id == RAPHAELLE_THREAD:
		return state.apply_j07_raphaelle_choice(choice_id)
	if thread_id == NICO_THREAD:
		if choice_id in ["choice_j07_nico_topic_guided", "choice_j07_nico_what_mean_guided", "choice_j07_nico_at_least_said_guided"]:
			return state.apply_j07_nico_guided_choice(choice_id)
		if choice_id in ["choice_j07_nico_acknowledge_contradiction", "choice_j07_nico_request_social_view", "choice_j07_nico_stay_vague"]:
			return state.apply_j07_nico_main_choice(choice_id)
		return state.apply_j07_nico_continuation(choice_id)
	if thread_id == MARIE_THREAD:
		return state.apply_j07_marie_choice(choice_id)
	return false

func _advance_after_choice(thread_id: String, choice_id: String) -> void:
	if thread_id == RAPHAELLE_THREAD:
		if choice_id == "choice_j07_raphaelle_acknowledge_guided":
			segment_index_by_thread[thread_id] = 1
			_enter_current_segment(thread_id)
			return
		state.complete_conversation("chapter_07_raphaelle_mobile_review_obligation", "raphaelle", "professional_secondary")
		_unlock_gallery_asset(RAPHAELLE_ASSET)
		_record_visual_beat(RAPHAELLE_ASSET)
		phase = "to_nico"
		pending_transition = _transition("to_nico")
		return
	if thread_id == NICO_THREAD:
		match choice_id:
			"choice_j07_nico_topic_guided":
				segment_index_by_thread[thread_id] = 1
				_enter_current_segment(thread_id)
			"choice_j07_nico_what_mean_guided":
				segment_index_by_thread[thread_id] = 2
				phase = "nico_main_choice"
				_enter_current_segment(thread_id)
			"choice_j07_nico_acknowledge_contradiction", "choice_j07_nico_request_social_view", "choice_j07_nico_stay_vague":
				segment_index_by_thread[thread_id] = 3
				phase = "nico_exchange"
				_enter_current_segment(thread_id)
			"choice_j07_nico_at_least_said_guided":
				segment_index_by_thread[thread_id] = 4
				phase = "nico_continuation_choice"
				_enter_current_segment(thread_id)
			_:
				state.complete_conversation("chapter_07_nico_quiet_confidence", "nico", "major_pivot")
				_unlock_gallery_asset(NICO_ASSET)
				_record_visual_beat(NICO_ASSET)
				phase = "to_marie"
				pending_transition = _transition("to_marie")
		return
	state.complete_conversation("chapter_07_marie_household_request", "marie", "household_return")
	_unlock_gallery_asset(MARIE_ASSET)
	_record_visual_beat(MARIE_ASSET)
	phase = "day_close"
	pending_transition = _transition("day_close")

func _enter_incoming(thread_id: String, incoming_phase: String) -> void:
	if not unlocked_thread_ids.has(thread_id):
		unlocked_thread_ids.append(thread_id)
	segment_index_by_thread[thread_id] = 0
	_enter_current_segment(thread_id)
	phase = incoming_phase

func _transition(key: String) -> Dictionary:
	var result: Dictionary = runtime_map.get(key, {}).duplicate(true)
	result["kind"] = key
	result["from_time"] = current_narrative_time_text()
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
		if not _message_variant_allowed(message):
			continue
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
			"source_day": 7,
		})

func _message_variant_allowed(message: Dictionary) -> bool:
	var variant := str(message.get("variant", ""))
	if variant == "":
		return true
	if variant in ["normal", "delayed"]:
		return variant == ("delayed" if state.raphaelle_work_outcome == "DELAYED" else "normal")
	if variant in ["marie_well_asked", "chair_return"]:
		return variant == _nico_opening_variant()
	return false

func _nico_opening_variant() -> String:
	# The playable J04 baseline never records a question about whether Marie looked well.
	# Keep the signed alternate line data-driven without inventing that missing fact.
	return "chair_return"

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
	if thread_id == RAPHAELLE_THREAD:
		return conversations["chapter_07_raphaelle_mobile_review_obligation"].get("segments", [])
	if thread_id == NICO_THREAD:
		return conversations["chapter_07_nico_quiet_confidence"].get("segments", [])
	return conversations["chapter_07_marie_household_request"].get("segments", [])

func _current_segment(thread_id: String) -> Dictionary:
	var segments := _segments(thread_id)
	var index := int(segment_index_by_thread.get(thread_id, 0))
	return segments[index] if index >= 0 and index < segments.size() else {}

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending":
		return state.current_day == "J06" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if phase == "complete":
		return state.current_day in ["J07", "J08", "J09", "J10"] and (state.day_status == "COMPLETE" or state.current_day != "J07") and pending_transition.is_empty() and served_visual_beat_ids == [RAPHAELLE_ASSET, NICO_ASSET, MARIE_ASSET]
	if state.current_day != "J07":
		return false
	if state.day_status != "ACTIVE":
		return false
	if phase in ["morning_consequence", "to_nico", "to_marie", "day_close"]:
		return not pending_transition.is_empty()
	return pending_transition.is_empty()

func _thread_presentation(id: String) -> Dictionary:
	var titles := {MARIE_THREAD: "Marie", "thread_sandra_private": "Sandra", "thread_mathilde_private": "Mathilde", RAPHAELLE_THREAD: "Raphaëlle", "thread_pauline_private": "Pauline", NICO_THREAD: "Nico"}
	var participants := {MARIE_THREAD: "marie", "thread_sandra_private": "sandra", "thread_mathilde_private": "mathilde", RAPHAELLE_THREAD: "raphaelle", "thread_pauline_private": "pauline", NICO_THREAD: "nico"}
	var colors := {MARIE_THREAD: "#4F8BFF", "thread_sandra_private": "#20C7C9", "thread_mathilde_private": "#E070A8", RAPHAELLE_THREAD: "#D69A42", "thread_pauline_private": "#E6B84A", NICO_THREAD: "#65B87A"}
	var transcript := transcript_for(id)
	var last: Dictionary = {}
	var unread := RUNTIME_UNREAD.incoming_unread_count(transcript, presented_time_message_ids, 7)
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
