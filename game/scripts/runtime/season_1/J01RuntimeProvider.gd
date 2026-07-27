extends RefCounted

class_name J01RuntimeProvider

const STATE_SCRIPT := preload("res://scripts/runtime/season_1/Season1State.gd")
const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j01_runtime_map.json"
const SNAPSHOT_VERSION := 1

var state
var runtime_map: Dictionary = {}
var conversations: Dictionary = {}
var segment_index_by_thread: Dictionary = {}
var pending_choice_ids_by_thread: Dictionary = {}
var transcripts_by_thread: Dictionary = {}
var produced_message_ids: Dictionary = {}
var unlocked_thread_ids: Array[String] = []
var pending_transition: Dictionary = {}
var day_end_visible := false
var initialized := false

func initialize(shared_state = null) -> bool:
	state = shared_state if shared_state != null else STATE_SCRIPT.new()
	runtime_map = DataLoader.load_json(RUNTIME_MAP_PATH)
	if runtime_map.is_empty():
		return false
	conversations.clear()
	for conversation_id in runtime_map.get("conversation_paths", {}):
		var conversation: Dictionary = DataLoader.load_json(str(runtime_map["conversation_paths"][conversation_id]))
		if conversation.is_empty():
			return false
		conversations[str(conversation_id)] = conversation
	segment_index_by_thread = {
		"thread_marie_private": 0,
		"thread_sandra_private": 0,
	}
	pending_choice_ids_by_thread = {}
	transcripts_by_thread = {
		"thread_marie_private": [],
		"thread_sandra_private": [],
	}
	produced_message_ids = {}
	unlocked_thread_ids.assign(runtime_map.get("initial_unlocked_threads", []))
	pending_transition = {}
	day_end_visible = false
	initialized = true
	_enter_current_segment("thread_marie_private")
	return true

func presentation_source() -> Dictionary:
	var source_threads: Array[Dictionary] = []
	for thread_id in unlocked_thread_ids:
		source_threads.append(_thread_presentation(thread_id))
	var source_transcripts: Dictionary = {}
	var source_choices: Dictionary = {}
	for thread_id in unlocked_thread_ids:
		source_transcripts[thread_id] = transcript_for(thread_id)
		source_choices[thread_id] = choices_for(thread_id)
	return {
		"characters": {
			"marie": _character("marie", "Marie", "#4F8BFF", "M"),
			"sandra": _character("sandra", "Sandra", "#20C7C9", "S"),
			"player": _character("player", "Player", "#8D63E6", ""),
		},
		"threads": source_threads,
		"messages_by_thread": source_transcripts,
		"choices_by_thread": source_choices,
	}

func gallery_source() -> Dictionary:
	return {
		"fixtures": {
			"marie": _gallery_character("marie", "Marie", "#4F8BFF", "M"),
			"sandra": _gallery_character("sandra", "Sandra", "#20C7C9", "S"),
		},
		"character_order": ["marie", "sandra"],
		"empty_label": "Aucun visuel disponible.",
	}

func transcript_for(thread_id: String) -> Array[Dictionary]:
	return _dictionary_array(transcripts_by_thread.get(thread_id, []))

func choices_for(thread_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var segment := _current_segment(thread_id)
	if segment.is_empty():
		return result
	for choice in segment.get("choices", []):
		if not pending_choice_ids_by_thread.get(thread_id, []).has(str(choice.get("id", ""))):
			continue
		result.append({
			"choice_id": str(choice.get("id", "")),
			"text": str(choice.get("text", "")),
			"enabled": true,
			"confirmation_required": false,
		})
	return result

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not initialized or not unlocked_thread_ids.has(thread_id) or not pending_transition.is_empty():
		return {"accepted": false}
	var pending: Array = pending_choice_ids_by_thread.get(thread_id, [])
	if not pending.has(choice_id):
		return {"accepted": false}
	var segment := _current_segment(thread_id)
	var selected: Dictionary = {}
	for choice in segment.get("choices", []):
		if str(choice.get("id", "")) == choice_id:
			selected = choice
			break
	if selected.is_empty() or not state.apply_choice(choice_id):
		return {"accepted": false}
	pending_choice_ids_by_thread[thread_id] = []
	var before_count := transcript_for(thread_id).size()
	_append_presentation(thread_id, {
		"message_id": "%s_player" % choice_id,
		"author_id": "player",
		"timestamp": "maintenant",
		"content_type": "TEXT",
		"text": str(selected.get("text", "")),
		"media_ref": "",
		"is_player": true,
		"is_read": true,
		"source_day": 1,
	})
	_append_authored_messages(thread_id, selected.get("next_messages", []))
	segment_index_by_thread[thread_id] = int(segment_index_by_thread.get(thread_id, 0)) + 1
	if int(segment_index_by_thread[thread_id]) < _segments(thread_id).size():
		_enter_current_segment(thread_id)
	else:
		_request_transition(thread_id)
	var complete_transcript := transcript_for(thread_id)
	return {
		"accepted": true,
		"new_messages": complete_transcript.slice(before_count),
		"choices": choices_for(thread_id),
		"transition": pending_transition.duplicate(true),
	}

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty():
		return {"accepted": false}
	var kind := str(pending_transition.get("kind", ""))
	pending_transition = {}
	if kind == "marie_shared_evening":
		state.pay_marie_promise()
		state.complete_conversation("chapter_01_marie_opening", "marie")
		if not unlocked_thread_ids.has("thread_sandra_private"):
			unlocked_thread_ids.append("thread_sandra_private")
			_enter_current_segment("thread_sandra_private")
		return {
			"accepted": true,
			"destination": "list",
			"unlocked_thread_id": "thread_sandra_private",
			"notification": runtime_map.get("sandra_notification", {}).duplicate(true),
		}
	if kind == "sandra_final_return":
		state.complete_conversation("chapter_01_sandra_trace", "sandra")
		state.complete_day()
		day_end_visible = true
		if TimelineState != null:
			TimelineState.mark_day_complete(1)
		return {
			"accepted": true,
			"destination": "day_end",
			"day_end": runtime_map.get("day_end", {}).duplicate(true),
		}
	return {"accepted": false}

func mark_photo_opened() -> bool:
	return state.observe_sandra_photo()

func progress_snapshot() -> Dictionary:
	return {
		"version": SNAPSHOT_VERSION,
		"segment_index_by_thread": segment_index_by_thread.duplicate(true),
		"pending_choice_ids_by_thread": pending_choice_ids_by_thread.duplicate(true),
		"transcripts_by_thread": transcripts_by_thread.duplicate(true),
		"produced_message_ids": produced_message_ids.duplicate(true),
		"unlocked_thread_ids": unlocked_thread_ids.duplicate(),
		"pending_transition": pending_transition.duplicate(true),
		"day_end_visible": day_end_visible,
	}

func snapshot() -> Dictionary:
	var value := progress_snapshot()
	value["state"] = state.snapshot()
	return value

func restore_progress_snapshot(value: Dictionary) -> bool:
	if not initialized or int(value.get("version", -1)) != SNAPSHOT_VERSION:
		return false
	for key in ["segment_index_by_thread", "pending_choice_ids_by_thread", "transcripts_by_thread", "produced_message_ids", "pending_transition"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	if typeof(value.get("unlocked_thread_ids")) != TYPE_ARRAY: return false
	segment_index_by_thread = value["segment_index_by_thread"].duplicate(true)
	pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true)
	transcripts_by_thread = value["transcripts_by_thread"].duplicate(true)
	produced_message_ids = value["produced_message_ids"].duplicate(true)
	unlocked_thread_ids.assign(value["unlocked_thread_ids"])
	pending_transition = value["pending_transition"].duplicate(true)
	day_end_visible = bool(value.get("day_end_visible", false))
	return true

func restore_snapshot(value: Dictionary) -> bool:
	if typeof(value.get("state")) != TYPE_DICTIONARY or not state.restore_snapshot(value["state"]):
		return false
	return restore_progress_snapshot(value)

func _enter_current_segment(thread_id: String) -> void:
	var segment := _current_segment(thread_id)
	if segment.is_empty():
		pending_choice_ids_by_thread[thread_id] = []
		return
	_append_authored_messages(thread_id, segment.get("messages", []))
	var ids: Array[String] = []
	for choice in segment.get("choices", []):
		ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids

func _append_authored_messages(thread_id: String, authored: Array) -> void:
	for message in authored:
		if not message is Dictionary or not _conditions_met(message):
			continue
		var message_id := str(message.get("id", ""))
		_append_presentation(thread_id, {
			"message_id": message_id,
			"author_id": str(message.get("sender", "")),
			"timestamp": str(message.get("time_label", "")),
			"content_type": "TEXT",
			"text": str(message.get("text", "")),
			"media_ref": "",
			"is_player": false,
			"is_read": true,
			"source_day": 1,
		})
		if message_id == str(runtime_map.get("sandra_image", {}).get("after_message_id", "")):
			_append_sandra_image(thread_id)

func _append_sandra_image(thread_id: String) -> void:
	var image: Dictionary = runtime_map.get("sandra_image", {}).duplicate(true)
	var presentation := {
		"message_id": str(image.get("message_id", "")),
		"author_id": str(image.get("author_id", "")),
		"timestamp": str(image.get("timestamp", "")),
		"content_type": "IMAGE",
		"text": str(image.get("text", "")),
		"media_ref": str(image.get("media_ref", "")),
		"trace_id": str(image.get("trace_id", "")),
		"source_kind": "messages",
		"access_state": "UNLOCKED",
		"placeholder_label": str(image.get("placeholder_label", "Visuel non produit")),
		"is_player": false,
		"is_read": true,
		"source_day": 1,
	}
	if _append_presentation(thread_id, presentation):
		state.activate_sandra_trace()

func _append_presentation(thread_id: String, presentation: Dictionary) -> bool:
	var message_id := str(presentation.get("message_id", ""))
	if message_id == "" or produced_message_ids.has(message_id):
		return false
	var transcript: Array = transcripts_by_thread.get(thread_id, [])
	transcript.append(presentation.duplicate(true))
	transcripts_by_thread[thread_id] = transcript
	produced_message_ids[message_id] = true
	return true

func _request_transition(thread_id: String) -> void:
	if thread_id == "thread_marie_private":
		var transition: Dictionary = runtime_map.get("transitions", {}).get("marie", {})
		var delayed := str(state.promises["marie_j01_shared_evening"].get("outcome", "")) == "DELAYED"
		pending_transition = {
			"kind": "marie_shared_evening",
			"thread_id": thread_id,
			"message_id": str(transition.get("message_id", "")),
			"text": str(transition.get("delayed" if delayed else "present", "")),
		}
	else:
		var transition: Dictionary = runtime_map.get("transitions", {}).get("sandra", {})
		pending_transition = {
			"kind": "sandra_final_return",
			"thread_id": thread_id,
			"message_id": str(transition.get("message_id", "")),
			"text": str(transition.get("text", "")),
		}
	_append_presentation(thread_id, {
		"message_id": str(pending_transition.get("message_id", "")),
		"author_id": "system",
		"timestamp": "",
		"content_type": "OFF_PHONE_TRANSITION",
		"text": str(pending_transition.get("text", "")),
		"media_ref": "",
		"is_player": false,
		"is_read": true,
		"source_day": 1,
	})

func _conditions_met(message: Dictionary) -> bool:
	if str(message.get("id", "")) == "msg_j1_sandra_trace_017_precise" and not state.selected_choice_ids.has("choice_j1_sandra_precise_observation"):
		return false
	for condition in message.get("conditions", []):
		if str(condition) == "j1_sandra_precise_observation" and not state.selected_choice_ids.has("choice_j1_sandra_precise_observation"):
			return false
	return true

func _current_segment(thread_id: String) -> Dictionary:
	var segments := _segments(thread_id)
	var index := int(segment_index_by_thread.get(thread_id, 0))
	return segments[index] if index >= 0 and index < segments.size() else {}

func _segments(thread_id: String) -> Array:
	var conversation: Dictionary = conversations.get(_conversation_id(thread_id), {})
	return conversation.get("segments", []) if conversation is Dictionary else []

func _conversation_id(thread_id: String) -> String:
	return "chapter_01_marie_opening" if thread_id == "thread_marie_private" else "chapter_01_sandra_trace"

func _thread_presentation(thread_id: String) -> Dictionary:
	var is_sandra := thread_id == "thread_sandra_private"
	var transcript := transcript_for(thread_id)
	var last_visible: Dictionary = {}
	for message in transcript:
		if str(message.get("content_type", "")) != "OFF_PHONE_TRANSITION":
			last_visible = message
	return {
		"thread_id": thread_id,
		"title": "Sandra" if is_sandra else "Marie",
		"participant_ids": ["sandra" if is_sandra else "marie", "player"],
		"last_preview": str(last_visible.get("text", "")),
		"last_timestamp": str(last_visible.get("timestamp", "")),
		"unread_count": 1 if is_sandra and not state.completed_conversation_ids.has("chapter_01_sandra_trace") else 0,
		"availability_state": "AVAILABLE",
		"is_group": false,
		"is_archived": false,
		"avatar_ref": "S" if is_sandra else "M",
		"accent_color": "#20C7C9" if is_sandra else "#4F8BFF",
	}

func _character(character_id: String, display_name: String, accent: String, avatar: String) -> Dictionary:
	return {"character_id": character_id, "display_name": display_name, "accent_color": accent, "avatar_ref": avatar, "gallery_enabled": false}

func _gallery_character(character_id: String, display_name: String, accent: String, avatar: String) -> Dictionary:
	return {"character_id": character_id, "display_name": display_name, "accent_color": Color.from_string(accent, Color.WHITE), "avatar_ref": avatar, "items": []}

func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append(item.duplicate(true))
	return result
