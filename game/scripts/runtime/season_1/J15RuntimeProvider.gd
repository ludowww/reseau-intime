extends "res://scripts/runtime/season_1/J14RuntimeProvider.gd"

class_name J15RuntimeProvider

const J15_MAP_PATH := "res://data/runtime/season_1/j15_runtime_map.json"
const J15_SNAPSHOT_VERSION := 5
const J15_LEGACY_SNAPSHOT_VERSIONS := [SNAPSHOT_VERSION, 4]

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

func snapshot() -> Dictionary:
	var value: Dictionary = super.snapshot(); value["version"] = J15_SNAPSHOT_VERSION; return value

func restore_snapshot(value: Dictionary) -> bool:
	var version := int(value.get("version", -1))
	if version not in J15_LEGACY_SNAPSHOT_VERSIONS and version != J15_SNAPSHOT_VERSION: return false
	var restored_value := value
	if version != J15_SNAPSHOT_VERSION:
		restored_value = value.duplicate(true)
		if not _migrate_legacy_snapshot_to_v5(restored_value, version): return false
	if str(restored_value.get("phase", "")) not in ["day_start_pending","to_resolution","priority_incoming","priority_choice","day_close","complete"]: return false
	if str(restored_value.get("selected_pivot", "")) not in ["","ACTIVE_CLARIFICATION","REPAIR","OPEN_CLARIFICATION","NO_OBLIGATION"]: return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(restored_value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(restored_value.get(key)) != TYPE_ARRAY: return false
	phase = str(restored_value["phase"]); selected_pivot = str(restored_value["selected_pivot"]); transcripts_by_thread = restored_value["transcripts_by_thread"].duplicate(true); produced_message_ids = restored_value["produced_message_ids"].duplicate(true); unlocked_thread_ids.assign(restored_value["unlocked_thread_ids"]); gallery_asset_ids.assign(restored_value["gallery_asset_ids"]); served_visual_beat_ids.assign(restored_value["served_visual_beat_ids"]); pending_choice_ids_by_thread = restored_value["pending_choice_ids_by_thread"].duplicate(true); pending_transition = restored_value["pending_transition"].duplicate(true); presented_time_message_ids = restored_value["presented_time_message_ids"].duplicate(true); current_time_minutes = int(restored_value.get("current_time_minutes", -1))
	return _restored_phase_consistent()

func _migrate_legacy_snapshot_to_v5(value: Dictionary, legacy_version: int) -> bool:
	if legacy_version not in J15_LEGACY_SNAPSHOT_VERSIONS: return false
	# V2 and V4 used the same provider payload. V5 changes no narrative data: it
	# makes the state/phase/thread invariants below mandatory at restore time.
	value["version"] = J15_SNAPSHOT_VERSION
	return true

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var author := str(message.get("sender", "system")); _append(thread_id, {"message_id":str(message.get("id", "")),"author_id":author,"timestamp":str(message.get("time_label", "")),"content_type":str(message.get("content_type", "TEXT")),"text":str(message.get("text", "")),"media_ref":"","is_player":author == "player","is_read":author == "player","source_day":15})

func _witness_thread() -> String: return "thread_mathilde_private" if state.j14_witness == "Mathilde" else "thread_marie_private"
func _mode_segment() -> String: return {"ACTIVE_CLARIFICATION":"due","REPAIR":"repair","OPEN_CLARIFICATION":"open","NO_OBLIGATION":"clean"}.get(selected_pivot, "clean")

func _restored_phase_consistent() -> bool:
	if state == null or current_time_minutes < 0: return false
	if phase == "day_start_pending":
		return state.current_day == "J14" and state.day_status == "COMPLETE" and selected_pivot == "" and pending_transition.is_empty() and _j15_thread_state_consistent(false, false)
	if state.current_day != "J15" or selected_pivot == "" or selected_pivot != state.j15_mode: return false
	if not state._j15_records_consistent(state.snapshot()): return false
	if phase == "complete":
		return state.day_status == "COMPLETE" and state.j15_outcome != "UNESTABLISHED" and pending_transition.is_empty() and _j15_thread_state_consistent(true, true)
	if state.day_status != "ACTIVE": return false
	if phase == "to_resolution":
		return state.j15_outcome == "UNESTABLISHED" and _transition_consistent("to_resolution") and _j15_thread_state_consistent(false, false)
	if phase in ["priority_incoming", "priority_choice"]:
		if state.j15_outcome != "UNESTABLISHED" or not pending_transition.is_empty() or not _j15_thread_state_consistent(true, false): return false
		return phase != "priority_choice" or RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(_witness_thread()), presented_time_message_ids, 15)
	if phase == "day_close":
		return state.j15_outcome != "UNESTABLISHED" and _transition_consistent("day_close") and _j15_thread_state_consistent(true, true)
	return false

func _transition_consistent(kind: String) -> bool:
	if str(pending_transition.get("kind", "")) != kind: return false
	var authored: Dictionary = runtime_map.get(kind, {})
	for key in ["transition_id", "mode", "to_time"]:
		if str(pending_transition.get(key, "")) != str(authored.get(key, "")): return false
	return true

func _j15_thread_state_consistent(segment_present: bool, choice_applied: bool) -> bool:
	var witness_thread := _witness_thread()
	var expected_segment_id := "j15_" + _mode_segment() + "_" + ("mathilde" if state.j14_witness == "Mathilde" else "marie")
	var segment: Dictionary = segments_by_id.get(expected_segment_id, {})
	if segment_present and segment.is_empty(): return false
	var expected_message_ids: Array[String] = []
	var expected_choice_ids: Array[String] = []
	if segment_present:
		for message in segment.get("messages", []): expected_message_ids.append(str(message.get("id", "")))
		for choice in segment.get("choices", []): expected_choice_ids.append(str(choice.get("id", "")))
	var seen_message_ids: Array[String] = []
	var seen_choice_ids: Array[String] = []
	for thread_id in transcripts_by_thread:
		if typeof(transcripts_by_thread[thread_id]) != TYPE_ARRAY: return false
		for item in transcripts_by_thread[thread_id]:
			if typeof(item) != TYPE_DICTIONARY: return false
			if int(item.get("source_day", 0)) != 15: continue
			if str(thread_id) != witness_thread: return false
			var message_id := str(item.get("message_id", ""))
			if message_id == "" or seen_message_ids.has(message_id): return false
			seen_message_ids.append(message_id)
			if message_id.begins_with("choice_j15_") and message_id.ends_with("_player"):
				seen_choice_ids.append(message_id.trim_suffix("_player"))
	for message_id in expected_message_ids:
		if seen_message_ids.count(message_id) != 1 or not bool(produced_message_ids.get(message_id, false)): return false
	if not segment_present and not seen_message_ids.is_empty(): return false
	if segment_present and not unlocked_thread_ids.has(witness_thread): return false
	for thread_id in pending_choice_ids_by_thread:
		if typeof(pending_choice_ids_by_thread[thread_id]) != TYPE_ARRAY: return false
		if str(thread_id) != witness_thread and not pending_choice_ids_by_thread[thread_id].is_empty(): return false
	var pending_ids = pending_choice_ids_by_thread.get(witness_thread, [])
	if typeof(pending_ids) != TYPE_ARRAY: return false
	if choice_applied:
		if not pending_ids.is_empty() or seen_choice_ids.size() != 1 or not expected_choice_ids.has(seen_choice_ids[0]) or not state.selected_choice_ids.has(seen_choice_ids[0]): return false
		if not bool(produced_message_ids.get(seen_choice_ids[0] + "_player", false)): return false
		var selected_choice: Dictionary = _choice_by_id(seen_choice_ids[0])
		if selected_choice.is_empty(): return false
		expected_message_ids.append(seen_choice_ids[0] + "_player")
		for response in selected_choice.get("next_messages", []): expected_message_ids.append(str(response.get("id", "")))
	else:
		if not seen_choice_ids.is_empty(): return false
		if segment_present and pending_ids != expected_choice_ids: return false
		if not segment_present and not pending_ids.is_empty(): return false
	if seen_message_ids.size() != expected_message_ids.size(): return false
	for message_id in expected_message_ids:
		if seen_message_ids.count(message_id) != 1 or not bool(produced_message_ids.get(message_id, false)): return false
	for produced_id in produced_message_ids:
		var id := str(produced_id)
		if (id.begins_with("msg_j15_") or id.begins_with("choice_j15_")) and not seen_message_ids.has(id): return false
	return true

func _thread_presentation(id: String) -> Dictionary:
	var source: Dictionary = super._thread_presentation(id); source["unread_count"] = RUNTIME_UNREAD.incoming_unread_count(transcript_for(id), presented_time_message_ids, 15); source["has_unread_content"] = int(source["unread_count"]) > 0
	if bool(source["has_unread_content"]): source["last_preview"] = "Nouveau message !"
	return source
