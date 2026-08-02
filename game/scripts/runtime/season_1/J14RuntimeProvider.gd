extends "res://scripts/runtime/season_1/J13RuntimeProvider.gd"

class_name J14RuntimeProvider

const J14_MAP_PATH := "res://data/runtime/season_1/j14_runtime_map.json"
const J14_SNAPSHOT_VERSION := 3

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	if not super.initialize(shared_state, cumulative_transcripts, cumulative_ids, cumulative_threads, cumulative_gallery_ids): return false
	runtime_map = DataLoader.load_json(J14_MAP_PATH); segments_by_id = {}
	var conversation: Dictionary = DataLoader.load_json(str(runtime_map.get("conversation_paths", {}).get("chapter_14_discovery", "")))
	if conversation.is_empty(): return false
	for segment in conversation.get("segments", []):
		var id := str(segment.get("id", "")); if id == "" or segments_by_id.has(id): return false
		segments_by_id[id] = segment
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get("initial_time", ""))); selected_pivot = ""; phase = "day_start_pending"
	return current_time_minutes >= 0

func start_day() -> Dictionary:
	if phase != "day_start_pending" or not state.begin_j14(): return {"accepted":false}
	selected_pivot = state.select_j14_variant()
	if selected_pivot == "": return {"accepted":false}
	_schedule_transition("to_discovery"); return _transition_result()

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id): return {"accepted":false}
	var selected := _choice_by_id(choice_id)
	if selected.is_empty() or not state.apply_j14_choice(choice_id, selected_pivot): return {"accepted":false}
	pending_choice_ids_by_thread[thread_id] = []; var before := transcript_for(thread_id).size(); var responses: Array = selected.get("next_messages", []); var timestamp := current_narrative_time_text()
	if not responses.is_empty(): timestamp = str(responses[0].get("time_label", timestamp))
	_append(thread_id, {"message_id":choice_id + "_player","author_id":"player","timestamp":timestamp,"content_type":"TEXT","text":str(selected.get("text", "")),"media_ref":"","is_player":true,"is_read":true,"source_day":14}); _append_messages(thread_id, responses)
	if state.j14_controller_notice_pending(): _schedule_transition("to_controller")
	else: _schedule_transition("day_close")
	return {"accepted":true,"new_messages":transcript_for(thread_id).slice(before),"choices":[],"transition":pending_transition.duplicate(true)}

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty(): return {"accepted":false}
	var kind := str(pending_transition.get("kind", ""))
	match kind:
		"to_discovery":
			if not state.establish_j14_discovery(selected_pivot): return {"accepted":false}
			pending_transition = {}
			var thread_id := "thread_mathilde_private" if state.j14_witness == "Mathilde" else "thread_marie_private"; _enter_segment(thread_id, "j14_" + selected_pivot.to_lower(), "priority_incoming"); return _incoming_result(thread_id)
		"to_controller":
			if not state.j14_controller_notice_pending(): return {"accepted":false}
			pending_transition = {}; _enter_segment(_controller_thread(), "j14_controller_" + selected_pivot.to_lower(), "echo_incoming"); return _incoming_result(_controller_thread())
		"day_close":
			if not state.complete_j14(): return {"accepted":false}
			pending_transition = {}
			if TimelineState != null: TimelineState.mark_day_complete(14)
			phase = "complete"; return {"accepted":true,"destination":"day_end","day_end":runtime_map["day_end"].duplicate(true)}
	return {"accepted":false}

func mark_thread_batch_presented(thread_id: String) -> bool:
	if phase not in ["priority_incoming","echo_incoming"] or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 14): return false
	if phase == "priority_incoming": phase = "priority_choice"
	else:
		if not state.resolve_j14_controller_informed(): return false
		_schedule_transition("day_close")
	return true

func snapshot() -> Dictionary:
	var value: Dictionary = super.snapshot(); value["version"] = J14_SNAPSHOT_VERSION; return value

func restore_snapshot(value: Dictionary) -> bool:
	var version := int(value.get("version", -1)); var restored_phase := str(value.get("phase", ""))
	if version not in [SNAPSHOT_VERSION,J14_SNAPSHOT_VERSION] or restored_phase not in ["day_start_pending","to_discovery","priority_incoming","priority_choice","to_controller","echo_incoming","day_close","complete"]: return false
	if str(value.get("selected_pivot", "")) not in ["","PAULINE","SANDRA","MATHILDE","RAPHAELLE","NICO","COMPOSITE","FALLBACK"]: return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY: return false
	if version == SNAPSHOT_VERSION and restored_phase == "to_discovery" and state.traces.has("j14_discovery_event_01") and not state.rollback_unpresented_legacy_j14_discovery(): return false
	phase = str(value["phase"]); selected_pivot = str(value["selected_pivot"]); transcripts_by_thread = value["transcripts_by_thread"].duplicate(true); produced_message_ids = value["produced_message_ids"].duplicate(true); unlocked_thread_ids.assign(value["unlocked_thread_ids"]); gallery_asset_ids.assign(value["gallery_asset_ids"]); served_visual_beat_ids.assign(value["served_visual_beat_ids"]); pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true); pending_transition = value["pending_transition"].duplicate(true); presented_time_message_ids = value["presented_time_message_ids"].duplicate(true); current_time_minutes = int(value.get("current_time_minutes", -1))
	return _restored_phase_consistent()

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var author := str(message.get("sender", "system"))
		if selected_pivot == "SANDRA" and state.j14_witness == "Marie" and author == "mathilde": author = "marie"
		var message_text := str(message.get("text", ""))
		if selected_pivot == "SANDRA" and state.j14_witness == "Marie" and str(message.get("id", "")) == "msg_j14_controller_sandra_001": message_text = message_text.replace("Mathilde", "Marie")
		_append(thread_id, {"message_id":str(message.get("id", "")),"author_id":author,"timestamp":str(message.get("time_label", "")),"content_type":str(message.get("content_type", "TEXT")),"text":message_text,"media_ref":str(message.get("media_ref", "")),"placeholder_label":str(message.get("placeholder_label", "Photo de démonstration")),"is_player":author == "player","is_read":author == "player","source_day":14})

func _controller_thread() -> String:
	var controller := str(state.promises.get("j14_inform_trace_controller", {}).get("controller", ""))
	return {"Pauline":"thread_pauline_private","Sandra":"thread_sandra_private","Mathilde":"thread_mathilde_private","Raphaëlle":"thread_raphaelle_private","Nico":"thread_nico_private","Marie":"thread_marie_private"}.get(controller, "")

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending": return state.current_day == "J13" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.current_day != "J14" or selected_pivot != state.j14_variant: return false
	if phase == "complete": return state.day_status == "COMPLETE" and pending_transition.is_empty() and state._j14_records_consistent(state.snapshot())
	if state.day_status != "ACTIVE" or not state._j14_records_consistent(state.snapshot()): return false
	var has_discovery: bool = state.traces.has("j14_discovery_event_01")
	if phase == "to_discovery": return not pending_transition.is_empty() and not has_discovery and state.j14_outcome == "UNESTABLISHED"
	if phase in ["priority_incoming","priority_choice"]: return pending_transition.is_empty() and has_discovery == (selected_pivot != "FALLBACK") and state.j14_outcome == "UNESTABLISHED"
	if phase == "to_controller": return not pending_transition.is_empty() and state.j14_outcome != "UNESTABLISHED" and state.j14_controller_notice_pending()
	if phase == "echo_incoming": return pending_transition.is_empty() and state.j14_outcome != "UNESTABLISHED" and state.j14_controller_notice_pending()
	if phase == "day_close": return not pending_transition.is_empty() and state.j14_outcome != "UNESTABLISHED" and (selected_pivot == "FALLBACK" or state.j14_controller_notified)
	return false

func _thread_presentation(id: String) -> Dictionary:
	var source: Dictionary = super._thread_presentation(id); source["unread_count"] = RUNTIME_UNREAD.incoming_unread_count(transcript_for(id), presented_time_message_ids, 14); source["has_unread_content"] = int(source["unread_count"]) > 0
	if bool(source["has_unread_content"]): source["last_preview"] = "Nouveau message !"
	return source
