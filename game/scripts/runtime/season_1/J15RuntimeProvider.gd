extends "res://scripts/runtime/season_1/J14RuntimeProvider.gd"

class_name J15RuntimeProvider

const J15_MAP_PATH := "res://data/runtime/season_1/j15_runtime_map.json"

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	if not super.initialize(shared_state, cumulative_transcripts, cumulative_ids, cumulative_threads, cumulative_gallery_ids): return false
	runtime_map = DataLoader.load_json(J15_MAP_PATH); segments_by_id = {}
	var conversation: Dictionary = DataLoader.load_json(str(runtime_map.get("conversation_paths", {}).get("chapter_15_obligation_mutation", "")))
	if conversation.is_empty(): return false
	for segment in conversation.get("segments", []):
		var id := str(segment.get("id", "")); if id == "" or segments_by_id.has(id): return false
		segments_by_id[id] = segment
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get("initial_time", ""))); selected_pivot = ""; phase = "day_start_pending"
	return current_time_minutes >= 0

func start_day() -> Dictionary:
	if phase != "day_start_pending" or not state.begin_j15(): return {"accepted":false}
	selected_pivot = state.select_j15_mode()
	if not state.establish_j15_mode(selected_pivot): return {"accepted":false}
	_schedule_transition("to_resolution"); return _transition_result()

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id): return {"accepted":false}
	var selected := _choice_by_id(choice_id)
	if selected.is_empty() or not state.apply_j15_choice(choice_id): return {"accepted":false}
	pending_choice_ids_by_thread[thread_id] = []; var before := transcript_for(thread_id).size(); var responses: Array = selected.get("next_messages", []); var timestamp := current_narrative_time_text()
	if not responses.is_empty(): timestamp = str(responses[0].get("time_label", timestamp))
	_append(thread_id, {"message_id":choice_id + "_player","author_id":"player","timestamp":timestamp,"content_type":"TEXT","text":str(selected.get("text", "")),"media_ref":"","is_player":true,"is_read":true,"source_day":15}); _append_messages(thread_id, responses)
	_schedule_transition("day_close")
	return {"accepted":true,"new_messages":transcript_for(thread_id).slice(before),"choices":[],"transition":pending_transition.duplicate(true)}

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty(): return {"accepted":false}
	var kind := str(pending_transition.get("kind", "")); pending_transition = {}
	match kind:
		"to_resolution":
			var thread_id := _witness_thread(); var segment_id := "j15_" + _mode_segment() + "_" + ("mathilde" if state.j14_witness == "Mathilde" else "marie")
			_enter_segment(thread_id, segment_id, "priority_incoming"); return _incoming_result(thread_id)
		"day_close":
			if not state.complete_j15(): return {"accepted":false}
			if TimelineState != null: TimelineState.mark_day_complete(15)
			phase = "complete"; return {"accepted":true,"destination":"day_end","day_end":runtime_map["day_end"].duplicate(true)}
	return {"accepted":false}

func mark_thread_batch_presented(thread_id: String) -> bool:
	if phase != "priority_incoming" or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 15): return false
	phase = "priority_choice"; return true

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION or str(value.get("phase", "")) not in ["day_start_pending","to_resolution","priority_incoming","priority_choice","day_close","complete"]: return false
	if str(value.get("selected_pivot", "")) not in ["","ACTIVE_CLARIFICATION","REPAIR","OPEN_CLARIFICATION","NO_OBLIGATION"]: return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY: return false
	phase = str(value["phase"]); selected_pivot = str(value["selected_pivot"]); transcripts_by_thread = value["transcripts_by_thread"].duplicate(true); produced_message_ids = value["produced_message_ids"].duplicate(true); unlocked_thread_ids.assign(value["unlocked_thread_ids"]); gallery_asset_ids.assign(value["gallery_asset_ids"]); served_visual_beat_ids.assign(value["served_visual_beat_ids"]); pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true); pending_transition = value["pending_transition"].duplicate(true); presented_time_message_ids = value["presented_time_message_ids"].duplicate(true); current_time_minutes = int(value.get("current_time_minutes", -1))
	return _restored_phase_consistent()

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var author := str(message.get("sender", "system")); _append(thread_id, {"message_id":str(message.get("id", "")),"author_id":author,"timestamp":str(message.get("time_label", "")),"content_type":str(message.get("content_type", "TEXT")),"text":str(message.get("text", "")),"media_ref":"","is_player":author == "player","is_read":author == "player","source_day":15})

func _witness_thread() -> String: return "thread_mathilde_private" if state.j14_witness == "Mathilde" else "thread_marie_private"
func _mode_segment() -> String: return {"ACTIVE_CLARIFICATION":"due","REPAIR":"repair","OPEN_CLARIFICATION":"open","NO_OBLIGATION":"clean"}.get(selected_pivot, "clean")

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending": return state.current_day == "J14" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.current_day != "J15": return false
	if phase == "complete": return state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.day_status != "ACTIVE": return false
	return not pending_transition.is_empty() if phase in ["to_resolution","day_close"] else pending_transition.is_empty()

func _thread_presentation(id: String) -> Dictionary:
	var source: Dictionary = super._thread_presentation(id); source["unread_count"] = RUNTIME_UNREAD.incoming_unread_count(transcript_for(id), presented_time_message_ids, 15); source["has_unread_content"] = int(source["unread_count"]) > 0
	if bool(source["has_unread_content"]): source["last_preview"] = "Nouveau message !"
	return source
