extends "res://scripts/runtime/season_1/J13RuntimeProvider.gd"

class_name J14RuntimeProvider

const J14_MAP_PATH := "res://data/runtime/season_1/j14_runtime_map.json"
const J14_SNAPSHOT_VERSION := 4
const J14_PHASES := ["day_start_pending","to_presence_context","to_discovery","priority_incoming","priority_choice","to_controller","echo_incoming","to_clarification","clarification_incoming","day_close","complete"]

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
	if state.j14_presence_contract().is_empty():
		selected_pivot = state.select_j14_variant()
		if selected_pivot != "S27_MUTATION_NO_DISCOVERY": return {"accepted":false}
		_schedule_transition("day_close")
	else:
		_schedule_transition("to_presence_context")
		pending_transition.merge(state.j14_presence_contract(), true)
	return _transition_result()

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not pending_transition.is_empty() or phase != "priority_choice" or not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id): return {"accepted":false}
	var selected := _choice_by_id(choice_id)
	if selected.is_empty() or not state.apply_j14_choice(choice_id, selected_pivot): return {"accepted":false}
	pending_choice_ids_by_thread[thread_id] = []; var before := transcript_for(thread_id).size(); var responses: Array = selected.get("next_messages", []); var timestamp := current_narrative_time_text()
	if not responses.is_empty(): timestamp = str(responses[0].get("time_label", timestamp))
	_append(thread_id, {"message_id":choice_id + "_player","author_id":"player","timestamp":timestamp,"content_type":"TEXT","text":str(selected.get("text", "")),"media_ref":"","is_player":true,"is_read":true,"source_day":14}); _append_messages(thread_id, responses)
	if state.j14_controller_notice_pending(): _schedule_transition("to_controller")
	elif state.j14_clarification_due_on_j14(): _schedule_j14_clarification()
	else: _schedule_transition("day_close")
	return {"accepted":true,"new_messages":transcript_for(thread_id).slice(before),"choices":[],"transition":pending_transition.duplicate(true)}

func fail_controller_notice(reason: String) -> Dictionary:
	if phase != "to_controller" or pending_transition.is_empty() or reason not in ["REFUSED","OMITTED"] or not state.fail_j14_controller_notice(reason, "Player", "J14 20:14"): return {"accepted":false}
	pending_transition = {}
	if state.j14_clarification_due_on_j14(): _schedule_j14_clarification()
	else: _schedule_transition("day_close")
	return {"accepted":true,"transition":pending_transition.duplicate(true)}

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty(): return {"accepted":false}
	var kind := str(pending_transition.get("kind", ""))
	match kind:
		"to_presence_context":
			var expected_contract: Dictionary = state.j14_presence_contract(); var contract := {"person_id":str(pending_transition.get("person_id", "")),"reason_near_screen":str(pending_transition.get("reason_near_screen", "")),"shared_context":str(pending_transition.get("shared_context", ""))}
			if expected_contract.is_empty() or contract != expected_contract: return {"accepted":false}
			var evidence := contract.duplicate(true); evidence.merge({"evidence_id":"j14_presence_context_" + str(contract.get("person_id", "")).to_lower(),"source_day":"J14","recorded_at":"J14 18:34","physically_present":true,"presented_before_selection":true}, true)
			if not state.record_j14_presence_evidence(evidence): return {"accepted":false}
			selected_pivot = state.select_j14_variant()
			pending_transition = {}
			if selected_pivot == "S27_MUTATION_NO_DISCOVERY": _schedule_transition("day_close")
			else: _schedule_transition("to_discovery")
			return _transition_result()
		"to_discovery":
			if selected_pivot not in ["PAULINE","SANDRA","MATHILDE","RAPHAELLE","NICO"]: return {"accepted":false}
			pending_transition = {}
			var thread_id := "thread_mathilde_private" if state.j14_witness == "Mathilde" else "thread_marie_private"
			var segment_id := _j14_discovery_segment_id(); if segment_id == "": return {"accepted":false}
			_enter_segment(thread_id, segment_id, "priority_incoming"); return _incoming_result(thread_id)
		"to_controller":
			if not state.j14_controller_notice_pending(): return {"accepted":false}
			pending_transition = {}; _enter_segment(_controller_thread(), "j14_controller_" + selected_pivot.to_lower(), "echo_incoming"); return _incoming_result(_controller_thread())
		"to_clarification":
			if not state.j14_clarification_due_on_j14(): return {"accepted":false}
			pending_transition = {}; var witness_thread := "thread_mathilde_private" if state.j14_witness == "Mathilde" else "thread_marie_private"; _append_j14_clarification_messages(witness_thread); phase = "clarification_incoming"; return _incoming_result(witness_thread)
		"day_close":
			if not state.complete_j14(): return {"accepted":false}
			pending_transition = {}
			if TimelineState != null: TimelineState.mark_day_complete(14)
			phase = "complete"; return {"accepted":true,"destination":"day_end","day_end":runtime_map["day_end"].duplicate(true)}
	return {"accepted":false}

func mark_thread_batch_presented(thread_id: String) -> bool:
	if phase not in ["priority_incoming","echo_incoming","clarification_incoming"] or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 14): return false
	if phase == "priority_incoming":
		if not state.establish_j14_discovery(selected_pivot): return false
		phase = "priority_choice"
	elif phase == "echo_incoming":
		if not state.resolve_j14_controller_informed("J14 20:15"): return false
		if state.j14_clarification_due_on_j14(): _schedule_j14_clarification()
		else: _schedule_transition("day_close")
	else:
		var promise: Dictionary = state.promises.get("j14_witness_clarification", {})
		if not state.resolve_j14_witness_clarification("PAID", "Player", str(promise.get("due_at", ""))): return false
		_schedule_transition("day_close")
	return true

func snapshot() -> Dictionary:
	var value: Dictionary = super.snapshot(); value["version"] = J14_SNAPSHOT_VERSION; return value

func restore_snapshot(value: Dictionary) -> bool:
	var restored_phase := str(value.get("phase", ""))
	if int(value.get("version", -1)) != J14_SNAPSHOT_VERSION or restored_phase not in J14_PHASES: return false
	if str(value.get("selected_pivot", "")) not in ["","PAULINE","SANDRA","MATHILDE","RAPHAELLE","NICO","S27_MUTATION_NO_DISCOVERY"]: return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY: return false
	phase = restored_phase; selected_pivot = str(value["selected_pivot"]); transcripts_by_thread = value["transcripts_by_thread"].duplicate(true); produced_message_ids = value["produced_message_ids"].duplicate(true); unlocked_thread_ids.assign(value["unlocked_thread_ids"]); gallery_asset_ids.assign(value["gallery_asset_ids"]); served_visual_beat_ids.assign(value["served_visual_beat_ids"]); pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true); pending_transition = value["pending_transition"].duplicate(true); presented_time_message_ids = value["presented_time_message_ids"].duplicate(true); current_time_minutes = int(value.get("current_time_minutes", -1))
	return _restored_phase_consistent()

func _append_j14_clarification_messages(thread_id: String) -> void:
	var promise: Dictionary = state.promises.get("j14_witness_clarification", {}); var due_at := str(promise.get("due_at", "")); var clock := due_at.trim_prefix("J14 ")
	_append(thread_id, {"message_id":"msg_j14_clarification_paid_player","author_id":"player","timestamp":clock,"content_type":"TEXT","text":str(promise.get("action_due", "")),"media_ref":"","is_player":true,"is_read":true,"source_day":14})
	_append(thread_id, {"message_id":"msg_j14_clarification_paid_witness","author_id":state.j14_witness.to_lower(),"timestamp":clock,"content_type":"TEXT","text":"D’accord. L’heure précise a été tenue.","media_ref":"","is_player":false,"is_read":false,"source_day":14})

func _j14_discovery_segment_id() -> String:
	return {"PAULINE":"j14_pauline","SANDRA":"j14_sandra","MATHILDE":"j14_mathilde","RAPHAELLE":"j14_raphaelle","NICO":"j14_nico"}.get(selected_pivot, "")

func _schedule_j14_clarification() -> void:
	_schedule_transition("to_clarification")
	var due_at := str(state.promises.get("j14_witness_clarification", {}).get("due_at", ""))
	pending_transition["to_time"] = due_at.trim_prefix("J14 ")

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var author := str(message.get("sender", "system")); var message_text := str(message.get("text", ""))
		if author == "player" and str(message.get("id", "")).begins_with("msg_j14_controller_"): message_text = _canonical_controller_notice_text()
		_append(thread_id, {"message_id":str(message.get("id", "")),"author_id":author,"timestamp":str(message.get("time_label", "")),"content_type":str(message.get("content_type", "TEXT")),"text":message_text,"media_ref":str(message.get("media_ref", "")),"placeholder_label":str(message.get("placeholder_label", "Photo de démonstration")),"is_player":author == "player","is_read":author == "player","source_day":14})

func _canonical_controller_notice_text(pivot_override := "") -> String:
	var notice: Dictionary = state.promises.get("j14_inform_trace_controller", {}); var values: Dictionary = notice.get("visible_values", {}); var declaration := str(notice.get("player_declaration", ""))
	var pivot := str(pivot_override) if str(pivot_override) != "" else selected_pivot
	match pivot:
		"PAULINE": return "Marie a vu seulement « %s » dans le fil Pauline. Elle n’a pas parcouru la conversation ni reçu de copie. Je lui ai déclaré exactement : « %s »." % [str(values.get("thumbnail", "")), declaration]
		"SANDRA": return "Mathilde a vu « %s » dans le fil %s quelques secondes, sans historique ni copie. Je lui ai déclaré exactement : « %s »." % [str(values.get("thumbnail", "")), str(values.get("thread_name", "")), declaration]
		"MATHILDE": return "Marie a vu exactement %s — « %s » — %s. Elle n’a pas ouvert notre fil. Je lui ai déclaré exactement : « %s »." % [str(values.get("sender_name", "")), str(values.get("first_line", "")), str(values.get("received_at", "")), declaration]
		"RAPHAELLE": return "Marie a vu « %s » dans le fil %s, sans autre fichier. Je lui ai déclaré exactement : « %s »." % [str(values.get("thumbnail", "")), str(values.get("thread_name", "")), declaration]
		"NICO": return "Marie a vu exactement %s — « %s » — %s, sans ouvrir notre conversation. Je lui ai déclaré exactement : « %s »." % [str(values.get("sender_name", "")), str(values.get("first_line", "")), str(values.get("received_at", "")), declaration]
	return ""

func _controller_thread() -> String:
	var controller := str(state.promises.get("j14_inform_trace_controller", {}).get("controller", ""))
	return {"Pauline":"thread_pauline_private","Sandra":"thread_sandra_private","Mathilde":"thread_mathilde_private","Raphaëlle":"thread_raphaelle_private","Nico":"thread_nico_private","Marie":"thread_marie_private"}.get(controller, "")

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending": return state.current_day == "J13" and state.day_status == "COMPLETE" and selected_pivot == "" and pending_transition.is_empty() and _j14_thread_state_consistent()
	if state.current_day != "J14": return false
	if phase == "to_presence_context": return state.day_status == "ACTIVE" and selected_pivot == "" and state.j14_variant == "" and not pending_transition.is_empty() and str(pending_transition.get("kind", "")) == phase and str(pending_transition.get("person_id", "")) == str(state.j14_presence_contract().get("person_id", "")) and str(pending_transition.get("reason_near_screen", "")) == str(state.j14_presence_contract().get("reason_near_screen", "")) and str(pending_transition.get("shared_context", "")) == str(state.j14_presence_contract().get("shared_context", "")) and _j14_thread_state_consistent()
	if selected_pivot == "" or selected_pivot != state.j14_variant or not state._j14_records_consistent(state.snapshot()): return false
	if not _j14_thread_state_consistent(): return false
	if phase == "complete": return state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.day_status != "ACTIVE": return false
	var has_discovery: bool = state.traces.has("j14_discovery_event_01")
	if phase == "to_discovery": return not pending_transition.is_empty() and str(pending_transition.get("kind", "")) == phase and not has_discovery and state.j14_outcome == "UNESTABLISHED"
	if phase == "priority_incoming": return pending_transition.is_empty() and not has_discovery and state.j14_outcome == "UNESTABLISHED"
	if phase == "priority_choice": return pending_transition.is_empty() and has_discovery and state.j14_outcome == "UNESTABLISHED"
	if phase == "to_controller": return not pending_transition.is_empty() and str(pending_transition.get("kind", "")) == phase and state.j14_outcome != "UNESTABLISHED" and state.j14_controller_notice_pending()
	if phase == "echo_incoming": return pending_transition.is_empty() and state.j14_outcome != "UNESTABLISHED" and state.j14_controller_notice_pending()
	if phase == "to_clarification": return not pending_transition.is_empty() and str(pending_transition.get("kind", "")) == phase and state.j14_clarification_due_on_j14()
	if phase == "clarification_incoming": return pending_transition.is_empty() and state.j14_clarification_due_on_j14()
	if phase == "day_close": return not pending_transition.is_empty() and str(pending_transition.get("kind", "")) == phase and (selected_pivot == "S27_MUTATION_NO_DISCOVERY" or state.j14_outcome != "UNESTABLISHED")
	return false

func _j14_thread_state_consistent() -> bool:
	var seen: Array[String] = []; var expected: Array[String] = []; var witness_thread := "thread_mathilde_private" if state.j14_witness == "Mathilde" else "thread_marie_private"
	for thread_id in transcripts_by_thread:
		if typeof(transcripts_by_thread[thread_id]) != TYPE_ARRAY: return false
		for item in transcripts_by_thread[thread_id]:
			if typeof(item) != TYPE_DICTIONARY: return false
			if int(item.get("source_day", 0)) != 14: continue
			var message_id := str(item.get("message_id", "")); if message_id == "" or seen.has(message_id) or not bool(produced_message_ids.get(message_id, false)): return false
			if message_id.begins_with("msg_j14_controller_") and str(thread_id) != _controller_thread(): return false
			if message_id.begins_with("msg_j14_controller_") and bool(item.get("is_player", false)) and str(item.get("text", "")) != _canonical_controller_notice_text(): return false
			if not message_id.begins_with("msg_j14_controller_") and str(thread_id) != witness_thread: return false
			seen.append(message_id)
	if selected_pivot in ["","S27_MUTATION_NO_DISCOVERY"]: return seen.is_empty() and _j14_pending_choices_consistent([], witness_thread)
	var discovery_segment: Dictionary = segments_by_id.get(_j14_discovery_segment_id(), {}); if discovery_segment.is_empty(): return false
	var discovery_present := phase in ["priority_incoming","priority_choice","to_controller","echo_incoming","to_clarification","clarification_incoming","day_close","complete"]
	if discovery_present:
		for message in discovery_segment.get("messages", []): expected.append(str(message.get("id", "")))
	var choice_id := str(state.promises.get("j14_inform_trace_controller", {}).get("source_choice_id", ""))
	if choice_id != "":
		expected.append(choice_id + "_player"); var selected_choice := _choice_by_id(choice_id); if selected_choice.is_empty(): return false
		for response in selected_choice.get("next_messages", []): expected.append(str(response.get("id", "")))
	var notice_status := str(state.promises.get("j14_inform_trace_controller", {}).get("status", ""))
	var controller_present := phase == "echo_incoming" or (phase in ["to_clarification","clarification_incoming","day_close","complete"] and notice_status == "PAID")
	if controller_present:
		var controller_segment: Dictionary = segments_by_id.get("j14_controller_" + selected_pivot.to_lower(), {}); if controller_segment.is_empty(): return false
		for message in controller_segment.get("messages", []): expected.append(str(message.get("id", "")))
	var clarification: Dictionary = state.promises.get("j14_witness_clarification", {})
	if phase in ["clarification_incoming","day_close","complete"] and str(clarification.get("due_at", "")).begins_with("J14 ") and str(clarification.get("status", "")) != "ACTIVE": expected.append("msg_j14_clarification_paid_player"); expected.append("msg_j14_clarification_paid_witness")
	if seen.size() != expected.size(): return false
	for message_id in expected:
		if seen.count(message_id) != 1: return false
	for produced_id in produced_message_ids:
		var id := str(produced_id)
		if (id.begins_with("msg_j14_") or id.begins_with("choice_j14_")) and not seen.has(id): return false
	var pending_expected: Array[String] = []
	if phase in ["priority_incoming","priority_choice"]:
		for choice in discovery_segment.get("choices", []): pending_expected.append(str(choice.get("id", "")))
	return _j14_pending_choices_consistent(pending_expected, witness_thread)

func _j14_pending_choices_consistent(expected: Array[String], witness_thread: String) -> bool:
	for thread_id in pending_choice_ids_by_thread:
		if typeof(pending_choice_ids_by_thread[thread_id]) != TYPE_ARRAY: return false
		if str(thread_id) != witness_thread and not pending_choice_ids_by_thread[thread_id].is_empty(): return false
	return pending_choice_ids_by_thread.get(witness_thread, []) == expected

func _thread_presentation(id: String) -> Dictionary:
	var source: Dictionary = super._thread_presentation(id); source["unread_count"] = RUNTIME_UNREAD.incoming_unread_count(transcript_for(id), presented_time_message_ids, 14); source["has_unread_content"] = int(source["unread_count"]) > 0
	if bool(source["has_unread_content"]): source["last_preview"] = "Nouveau message !"
	return source
