extends RefCounted

class_name J13RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j13_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const RUNTIME_UNREAD := preload("res://scripts/runtime/season_1/RuntimeUnread.gd")
const SNAPSHOT_VERSION := 1

const THREADS := {"PAULINE":"thread_pauline_private","RAPHAELLE":"thread_raphaelle_private","NICO":"thread_nico_private","SANDRA":"thread_sandra_private","MATHILDE":"thread_mathilde_private","MARIE":"thread_marie_private","RESPIRATION":"thread_marie_private"}
var state
var runtime_map: Dictionary = {}
var segments_by_id: Dictionary = {}
var transcripts_by_thread: Dictionary = {}
var produced_message_ids: Dictionary = {}
var unlocked_thread_ids: Array[String] = []
var gallery_asset_ids: Array[String] = []
var served_visual_beat_ids: Array[String] = []
var pending_choice_ids_by_thread: Dictionary = {}
var pending_transition: Dictionary = {}
var presented_time_message_ids: Dictionary = {}
var phase := "day_start_pending"
var current_time_minutes := -1
var selected_pivot := ""

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	state = shared_state; runtime_map = DataLoader.load_json(RUNTIME_MAP_PATH)
	if runtime_map.is_empty() or str(runtime_map.get("implementation_status", "")) != "PLAYABLE": return false
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get("initial_time", "")))
	var conversation: Dictionary = DataLoader.load_json(str(runtime_map.get("conversation_paths", {}).get("chapter_13_priority", "")))
	if conversation.is_empty() or current_time_minutes < 0: return false
	for segment in conversation.get("segments", []):
		var id := str(segment.get("id", "")); if id == "" or segments_by_id.has(id): return false
		segments_by_id[id] = segment
	transcripts_by_thread = cumulative_transcripts.duplicate(true); produced_message_ids = cumulative_ids.duplicate(true); unlocked_thread_ids.assign(cumulative_threads); gallery_asset_ids.assign(cumulative_gallery_ids)
	served_visual_beat_ids = []; pending_choice_ids_by_thread = {}; pending_transition = {}; presented_time_message_ids = {}; phase = "day_start_pending"; selected_pivot = ""
	return true

func day_start_presentation() -> Dictionary: return runtime_map.get("day_start", {}).duplicate(true)
func current_narrative_day_short() -> String: return str(runtime_map.get("narrative_day_short", ""))
func current_narrative_time_minutes() -> int: return current_time_minutes
func current_narrative_time_text() -> String: return NARRATIVE_TIME.format_narrative_time(current_time_minutes)
func confirm_day_transition() -> Dictionary: return start_day() if phase == "day_start_pending" else {"accepted":false}
func transcript_for(thread_id: String) -> Array[Dictionary]: return _dictionary_array(transcripts_by_thread.get(thread_id, []))
func gallery_source() -> Dictionary: return _gallery_source()

func presentation_source() -> Dictionary:
	var threads: Array[Dictionary] = []; var choices := {}; var transcripts := {}
	for thread_id in unlocked_thread_ids: threads.append(_thread_presentation(thread_id)); choices[thread_id] = choices_for(thread_id); transcripts[thread_id] = transcript_for(thread_id)
	return {"characters":_characters(),"threads":threads,"messages_by_thread":transcripts,"choices_by_thread":choices,"narrative_day_short":current_narrative_day_short(),"narrative_time":current_narrative_time_text(),"narrative_time_minutes":current_time_minutes,"implementation_status":"PLAYABLE"}

func start_day() -> Dictionary:
	selected_pivot = _select_pivot()
	var segment_id := _priority_segment_id()
	if phase != "day_start_pending" or selected_pivot == "" or segment_id == "" or not segments_by_id.has(segment_id) or not state.begin_j13() or not state.set_j13_priority(selected_pivot):
		selected_pivot = ""
		return {"accepted":false}
	_schedule_transition("to_priority")
	var segment: Dictionary = segments_by_id.get(segment_id, {})
	var messages: Array = segment.get("messages", [])
	if not messages.is_empty(): pending_transition["to_time"] = str(messages[0].get("time_label", pending_transition.get("to_time", "")))
	return _transition_result()

func choices_for(thread_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []; var ids: Array = pending_choice_ids_by_thread.get(thread_id, [])
	for segment in segments_by_id.values():
		for choice in segment.get("choices", []):
			if ids.has(str(choice.get("id", ""))): result.append({"choice_id":str(choice.get("id", "")),"text":str(choice.get("text", "")),"enabled":true,"confirmation_required":false})
	return result

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id): return {"accepted":false}
	var selected := _choice_by_id(choice_id)
	if selected.is_empty() or not state.apply_j13_choice(choice_id, selected_pivot): return {"accepted":false}
	pending_choice_ids_by_thread[thread_id] = []
	var before := transcript_for(thread_id).size(); var responses: Array = selected.get("next_messages", []); var timestamp := current_narrative_time_text()
	if not responses.is_empty(): timestamp = str(responses[0].get("time_label", timestamp))
	_append(thread_id, {"message_id":choice_id + "_player","author_id":"player","timestamp":timestamp,"content_type":"TEXT","text":str(selected.get("text", "")),"media_ref":"","is_player":true,"is_read":true,"source_day":13}); _append_messages(thread_id, responses)
	if selected_pivot == "MARIE" or selected_pivot == "RESPIRATION": _schedule_transition("day_close")
	else: _schedule_transition("to_marie_echo")
	return {"accepted":true,"new_messages":transcript_for(thread_id).slice(before),"choices":[],"transition":pending_transition.duplicate(true)}

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty(): return {"accepted":false}
	var kind := str(pending_transition.get("kind", ""))
	match kind:
		"to_priority":
			var thread_id := str(THREADS.get(selected_pivot, "thread_marie_private")); var segment_id := _priority_segment_id()
			if segment_id == "" or not state.deliver_j13_priority(selected_pivot, segment_id): return {"accepted":false}
			pending_transition = {}
			_enter_segment(thread_id, segment_id, "priority_incoming"); return _incoming_result(thread_id)
		"to_marie_echo": pending_transition = {}; _enter_segment("thread_marie_private", "j13_marie_echo", "echo_incoming"); return _incoming_result("thread_marie_private")
		"day_close":
			if not state.complete_j13(): return {"accepted":false}
			pending_transition = {}
			if TimelineState != null: TimelineState.mark_day_complete(13)
			phase = "complete"; return {"accepted":true,"destination":"day_end","day_end":runtime_map["day_end"].duplicate(true)}
	return {"accepted":false}

func mark_message_presented(message_id: String) -> bool:
	if message_id == "" or presented_time_message_ids.has(message_id): return false
	var timestamp := ""
	for thread_id in transcripts_by_thread:
		for message in transcripts_by_thread[thread_id]:
			if str(message.get("message_id", "")) == message_id: timestamp = str(message.get("timestamp", "")); break
		if timestamp != "": break
	presented_time_message_ids[message_id] = true; var candidate := NARRATIVE_TIME.parse_narrative_time(timestamp); if candidate >= current_time_minutes: current_time_minutes = candidate
	return true

func mark_thread_batch_presented(thread_id: String) -> bool:
	if phase not in ["priority_incoming","echo_incoming"] or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 13): return false
	if phase == "priority_incoming": phase = "priority_choice"
	else: _schedule_transition("day_close")
	return true

func commit_narrative_time(minutes: int) -> bool:
	if minutes < current_time_minutes or NARRATIVE_TIME.format_narrative_time(minutes) == "": return false
	current_time_minutes = minutes; return true
func on_thread_returned(_thread_id: String) -> Dictionary: return pending_transition.duplicate(true) if not pending_transition.is_empty() else {}

func snapshot() -> Dictionary: return {"version":SNAPSHOT_VERSION,"phase":phase,"selected_pivot":selected_pivot,"transcripts_by_thread":transcripts_by_thread.duplicate(true),"produced_message_ids":produced_message_ids.duplicate(true),"unlocked_thread_ids":unlocked_thread_ids.duplicate(),"gallery_asset_ids":gallery_asset_ids.duplicate(),"served_visual_beat_ids":served_visual_beat_ids.duplicate(),"pending_choice_ids_by_thread":pending_choice_ids_by_thread.duplicate(true),"pending_transition":pending_transition.duplicate(true),"presented_time_message_ids":presented_time_message_ids.duplicate(true),"current_time_minutes":current_time_minutes}
func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION or str(value.get("phase", "")) not in ["day_start_pending","to_priority","priority_incoming","priority_choice","to_marie_echo","echo_incoming","day_close","complete"]: return false
	if str(value.get("selected_pivot", "")) not in ["","PAULINE","RAPHAELLE","NICO","SANDRA","MATHILDE","MARIE","RESPIRATION"]: return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY: return false
	phase = str(value["phase"]); selected_pivot = str(value["selected_pivot"]); transcripts_by_thread = value["transcripts_by_thread"].duplicate(true); produced_message_ids = value["produced_message_ids"].duplicate(true); unlocked_thread_ids.assign(value["unlocked_thread_ids"]); gallery_asset_ids.assign(value["gallery_asset_ids"]); served_visual_beat_ids.assign(value["served_visual_beat_ids"]); pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true); pending_transition = value["pending_transition"].duplicate(true); presented_time_message_ids = value["presented_time_message_ids"].duplicate(true); current_time_minutes = int(value.get("current_time_minutes", -1))
	return _restored_phase_consistent()

func presentation_count_by_id(id: String) -> int:
	var count := 0
	for thread_id in transcripts_by_thread:
		for item in transcripts_by_thread[thread_id]:
			if str(item.get("message_id", "")) == id: count += 1
	return count

func _select_pivot() -> String:
	var obligation: Dictionary = state.obligations.get("j12_priority_consequence_j13", {})
	for key in ["status", "route", "origin", "concerned_people", "due_at", "failure_effect"]:
		if not obligation.has(key): return ""
	if str(obligation.get("status", "")) != "DUE": return ""
	var route := str(obligation.get("route", ""))
	if route != state.j12_priority_route: return ""
	match route:
		"SANDRA": return "SANDRA"
		"MATHILDE": return "MATHILDE"
		"RAPHAELLE": return "RAPHAELLE"
		"NICO": return "" if state.j11_pivot_outcome == "NICO_CLEAN_CLOSE" else "NICO"
		"MARIE": return "MARIE"
		"NETWORK": return "PAULINE" if _pauline_eligible() else "RESPIRATION"
	return ""

func _pauline_eligible() -> bool:
	return state.j13_pauline_eligible()

func _priority_segment_id() -> String:
	match selected_pivot:
		"PAULINE": return "j13_pauline"
		"SANDRA": return str({"SANDRA_RESPONSE_CLEAR":"j13_sandra_clear", "SANDRA_RESPONSE_DELAYED":"j13_sandra_delayed", "SANDRA_EXIT_CLEAN":"j13_sandra_exit"}.get(state.j12_private_outcome, ""))
		"MATHILDE":
			if str(state.obligations.get("j12_priority_consequence_j13", {}).get("origin", "")) == "MATHILDE_HOUSEHOLD_AFTERCARE": return "j13_mathilde_failed"
			return str({"MATHILDE_LOOK_ONLY":"j13_mathilde_look", "MATHILDE_M_B1":"j13_mathilde_m_b1", "MATHILDE_M_B2":"j13_mathilde_m_b2", "MATHILDE_M_B3":"j13_mathilde_m_b3", "MATHILDE_CLEAN_STOP":"j13_mathilde_clean_stop", "MATHILDE_DISTANCE_RESTORED":"j13_mathilde_distance"}.get(state.j11_pivot_outcome, ""))
		"RAPHAELLE":
			if state.j12_private_outcome == "RAPHAELLE_NOW": return "j13_raphaelle_pressed"
			if state.j11_pivot_outcome in ["KISS_DECLINED", "RESULT_SENT_BOUNDARY_HELD"]: return "j13_raphaelle_boundary"
			return "j13_raphaelle" if state.j13_raphaelle_standard_image_eligible() else "j13_raphaelle_boundary"
		"NICO": return str({"NICO_GUARDRAIL_HELD":"j13_nico_guardrail", "NICO_RIVALRY_MAINTAINED":"j13_nico_rivalry"}.get(state.j11_pivot_outcome, ""))
		"MARIE": return str({"MARIE_ADULT_RECONQUEST":"j13_marie_close", "MARIE_NON_ADULT_RECONNECTION":"j13_marie_non_adult", "MARIE_SEX_NOT_USED_AS_BANDAGE":"j13_marie_no_bandage", "MARIE_HONEST_REFUSAL":"j13_marie_distance", "MARIE_NO_RECONQUEST":"j13_marie_distance"}.get(state.j11_pivot_outcome, ""))
		"RESPIRATION": return "j13_respiration"
	return ""

func _enter_segment(thread_id: String, segment_id: String, incoming_phase: String) -> void:
	if not unlocked_thread_ids.has(thread_id): unlocked_thread_ids.append(thread_id)
	var segment: Dictionary = segments_by_id.get(segment_id, {}); _append_messages(thread_id, segment.get("messages", [])); var ids: Array[String] = []
	for choice in segment.get("choices", []): ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids; phase = incoming_phase
func _choice_by_id(choice_id: String) -> Dictionary:
	for segment in segments_by_id.values():
		for choice in segment.get("choices", []):
			if str(choice.get("id", "")) == choice_id: return choice
	return {}
func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var author := str(message.get("sender", "system")); _append(thread_id, {"message_id":str(message.get("id", "")),"author_id":author,"timestamp":str(message.get("time_label", "")),"content_type":str(message.get("content_type", "TEXT")),"text":str(message.get("text", "")),"media_ref":str(message.get("media_ref", "")),"placeholder_label":str(message.get("placeholder_label", "Photo de démonstration")),"is_player":author == "player","is_read":author == "player","source_day":13})
func _append(thread_id: String, item: Dictionary) -> bool:
	var id := str(item.get("message_id", "")); if id == "" or produced_message_ids.has(id): return false
	var transcript: Array = transcripts_by_thread.get(thread_id, []); transcript.append(item.duplicate(true)); transcripts_by_thread[thread_id] = transcript; produced_message_ids[id] = true; return true
func _schedule_transition(key: String) -> void: phase = key; pending_transition = runtime_map.get(key, {}).duplicate(true); pending_transition["kind"] = key; pending_transition["from_time"] = current_narrative_time_text()
func _transition_result() -> Dictionary: return {"accepted":true,"destination":"timeline","transition":pending_transition.duplicate(true)}
func _incoming_result(thread_id: String) -> Dictionary: return {"accepted":true,"destination":"conversation","thread_id":thread_id,"notification":{"body":"Nouveau message !"}}
func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending": return state.current_day == "J12" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.current_day != "J13": return false
	if selected_pivot == "" or selected_pivot != state.j13_pivot: return false
	var obligation: Dictionary = state.obligations.get("j12_priority_consequence_j13", {})
	var expected_route := "NETWORK" if selected_pivot in ["PAULINE", "RESPIRATION"] else selected_pivot
	if str(obligation.get("route", "")) != expected_route: return false
	var private_trace_id := "j13_pauline_private_version_01" if selected_pivot == "PAULINE" else ("j13_raphaelle_masked_version_01" if selected_pivot == "RAPHAELLE" and _priority_segment_id() == "j13_raphaelle" else "")
	if phase == "to_priority" and (state.traces.has("j13_pauline_private_version_01") or state.traces.has("j13_raphaelle_masked_version_01")): return false
	if private_trace_id != "" and phase not in ["to_priority"] and not state.traces.has(private_trace_id): return false
	if phase in ["to_priority", "priority_incoming", "priority_choice"] and str(obligation.get("status", "")) != "DUE": return false
	if phase in ["to_marie_echo", "echo_incoming", "day_close", "complete"] and str(obligation.get("status", "")) == "DUE": return false
	if phase == "complete": return state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.day_status != "ACTIVE": return false
	return not pending_transition.is_empty() if phase in ["to_priority","to_marie_echo","day_close"] else pending_transition.is_empty()

func _thread_presentation(id: String) -> Dictionary:
	var titles := {"thread_marie_private":"Marie","thread_sandra_private":"Sandra","thread_mathilde_private":"Mathilde","thread_raphaelle_private":"Raphaëlle","thread_nico_private":"Nico","thread_pauline_private":"Pauline"}; var transcript := transcript_for(id); var last: Dictionary = {}; var unread := RUNTIME_UNREAD.incoming_unread_count(transcript, presented_time_message_ids, 13)
	for item in transcript:
		if str(item.get("content_type", "")) != "OFF_PHONE_TRANSITION": last = item
	var title := str(titles.get(id, id)); return {"thread_id":id,"title":title,"participant_ids":[id.trim_prefix("thread_").trim_suffix("_private"),"player"],"last_preview":"Nouveau message !" if unread > 0 else str(last.get("text", "")),"last_timestamp":str(last.get("timestamp", "")),"unread_count":unread,"has_unread_content":unread > 0,"availability_state":"AVAILABLE","is_group":false,"is_archived":false,"avatar_ref":title.left(1),"accent_color":"#8D63E6"}
func _characters() -> Dictionary:
	var result := {}; for entry in [["marie","Marie"],["sandra","Sandra"],["mathilde","Mathilde"],["raphaelle","Raphaëlle"],["pauline","Pauline"],["nico","Nico"],["player","Player"]]: result[entry[0]] = {"character_id":entry[0],"display_name":entry[1],"accent_color":"#8D63E6","avatar_ref":str(entry[1]).left(1),"gallery_enabled":false}
	return result
func _gallery_source() -> Dictionary:
	var previous = preload("res://scripts/runtime/season_1/J12RuntimeProvider.gd").new(); previous.gallery_asset_ids.assign(gallery_asset_ids); return previous.gallery_source()
func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []; if value is Array:
		for item in value:
			if item is Dictionary: result.append(item.duplicate(true))
	return result
