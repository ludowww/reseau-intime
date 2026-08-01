extends "res://scripts/runtime/season_1/J15RuntimeProvider.gd"

class_name J16RuntimeProvider

const J16_MAP_PATH := "res://data/runtime/season_1/j16_runtime_map.json"

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	if not super.initialize(shared_state, cumulative_transcripts, cumulative_ids, cumulative_threads, cumulative_gallery_ids): return false
	runtime_map = DataLoader.load_json(J16_MAP_PATH); segments_by_id = {}
	var conversation: Dictionary = DataLoader.load_json(str(runtime_map.get("conversation_paths", {}).get("chapter_16_priority_payment", "")))
	if conversation.is_empty(): return false
	for segment in conversation.get("segments", []):
		var id := str(segment.get("id", "")); if id == "" or segments_by_id.has(id): return false
		segments_by_id[id] = segment
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get("initial_time", ""))); selected_pivot = ""; phase = "day_start_pending"
	return current_time_minutes >= 0

func start_day() -> Dictionary:
	if phase != "day_start_pending" or not state.begin_j16(): return {"accepted":false}
	selected_pivot = state.select_j16_priority()
	if not state.establish_j16_priority(selected_pivot): return {"accepted":false}
	_schedule_transition("to_priority"); return _transition_result()

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id): return {"accepted":false}
	var selected := _choice_by_id(choice_id); var accepted: bool = state.apply_j16_j17_choice(choice_id) if phase == "j17_choice" else state.apply_j16_consequence_choice(choice_id)
	if selected.is_empty() or not accepted: return {"accepted":false}
	pending_choice_ids_by_thread[thread_id] = []; var before := transcript_for(thread_id).size(); var responses: Array = selected.get("next_messages", []); var timestamp := current_narrative_time_text()
	if not responses.is_empty(): timestamp = str(responses[0].get("time_label", timestamp))
	_append(thread_id, {"message_id":choice_id + "_player","author_id":"player","timestamp":timestamp,"content_type":"TEXT","text":str(selected.get("text", "")),"media_ref":"","is_player":true,"is_read":true,"source_day":16}); _append_messages(thread_id, responses)
	_schedule_transition("day_close" if phase == "j17_choice" else "to_departure")
	return {"accepted":true,"new_messages":transcript_for(thread_id).slice(before),"choices":[],"transition":pending_transition.duplicate(true)}

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty(): return {"accepted":false}
	var kind := str(pending_transition.get("kind", "")); pending_transition = {}
	match kind:
		"to_priority":
			var thread_id := "thread_mathilde_private" if selected_pivot == "MATHILDE" else "thread_marie_private"; var segment_id := "j16_priority_" + selected_pivot.to_lower() if selected_pivot != "FALLBACK" else "j16_fallback"
			_enter_segment(thread_id, segment_id, "priority_incoming"); return _incoming_result(thread_id)
		"to_departure":
			if not state.establish_j16_departure(): return {"accepted":false}
			_enter_segment("thread_mathilde_private", "j16_departure_" + state.j16_departure_state.to_lower(), "departure_incoming"); return _incoming_result("thread_mathilde_private")
		"to_j17": _enter_segment("thread_marie_private", "j16_j17_proposal", "j17_incoming"); return _incoming_result("thread_marie_private")
		"day_close":
			if not state.complete_j16(): return {"accepted":false}
			if TimelineState != null: TimelineState.mark_day_complete(16)
			phase = "complete"; return {"accepted":true,"destination":"day_end","day_end":runtime_map["day_end"].duplicate(true)}
	return {"accepted":false}

func mark_thread_batch_presented(thread_id: String) -> bool:
	if phase not in ["priority_incoming","departure_incoming","j17_incoming"] or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 16): return false
	if phase == "priority_incoming": phase = "priority_choice"
	elif phase == "departure_incoming": _schedule_transition("to_j17")
	else: phase = "j17_choice"
	return true

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION or str(value.get("phase", "")) not in ["day_start_pending","to_priority","priority_incoming","priority_choice","to_departure","departure_incoming","to_j17","j17_incoming","j17_choice","day_close","complete"]: return false
	if str(value.get("selected_pivot", "")) not in ["","MARIE","MATHILDE","FALLBACK"]: return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY: return false
	phase = str(value["phase"]); selected_pivot = str(value["selected_pivot"]); transcripts_by_thread = value["transcripts_by_thread"].duplicate(true); produced_message_ids = value["produced_message_ids"].duplicate(true); unlocked_thread_ids.assign(value["unlocked_thread_ids"]); gallery_asset_ids.assign(value["gallery_asset_ids"]); served_visual_beat_ids.assign(value["served_visual_beat_ids"]); pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true); pending_transition = value["pending_transition"].duplicate(true); presented_time_message_ids = value["presented_time_message_ids"].duplicate(true); current_time_minutes = int(value.get("current_time_minutes", -1))
	return _restored_phase_consistent()

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var author := str(message.get("sender", "system")); _append(thread_id, {"message_id":str(message.get("id", "")),"author_id":author,"timestamp":str(message.get("time_label", "")),"content_type":"TEXT","text":str(message.get("text", "")),"media_ref":"","is_player":author == "player","is_read":author == "player","source_day":16})

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending": return state.current_day == "J15" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.current_day != "J16": return false
	if phase == "complete": return state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.day_status != "ACTIVE": return false
	return not pending_transition.is_empty() if phase in ["to_priority","to_departure","to_j17","day_close"] else pending_transition.is_empty()

func _thread_presentation(id: String) -> Dictionary:
	var source: Dictionary = super._thread_presentation(id); source["unread_count"] = RUNTIME_UNREAD.incoming_unread_count(transcript_for(id), presented_time_message_ids, 16); source["has_unread_content"] = int(source["unread_count"]) > 0
	if bool(source["has_unread_content"]): source["last_preview"] = "Nouveau message !"
	return source
