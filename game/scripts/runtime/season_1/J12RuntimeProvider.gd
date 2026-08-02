extends RefCounted

class_name J12RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j12_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const RUNTIME_UNREAD := preload("res://scripts/runtime/season_1/RuntimeUnread.gd")
const SNAPSHOT_VERSION := 2

const MARIE_THREAD := "thread_marie_private"
const SANDRA_THREAD := "thread_sandra_private"
const MATHILDE_THREAD := "thread_mathilde_private"
const RAPHAELLE_THREAD := "thread_raphaelle_private"
const NICO_THREAD := "thread_nico_private"
const LAVERRIERE_THREAD := "thread_laverriere_group"
const ANNEXE_THREAD := "thread_annexe_group"

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
var presented_time_message_ids: Dictionary = {}
var phase := "day_start_pending"
var current_time_minutes := -1

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	state = shared_state
	runtime_map = DataLoader.load_json(RUNTIME_MAP_PATH)
	if runtime_map.is_empty() or str(runtime_map.get("implementation_status", "")) != "PLAYABLE":
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
	phase = "day_start_pending"
	return true

func day_start_presentation() -> Dictionary: return runtime_map.get("day_start", {}).duplicate(true)
func current_narrative_day_short() -> String: return str(runtime_map.get("narrative_day_short", ""))
func current_narrative_time_minutes() -> int: return current_time_minutes
func current_narrative_time_text() -> String: return NARRATIVE_TIME.format_narrative_time(current_time_minutes)

func presentation_source() -> Dictionary:
	var threads: Array[Dictionary] = []
	var choices: Dictionary = {}
	var transcripts: Dictionary = {}
	for thread_id in unlocked_thread_ids:
		threads.append(_thread_presentation(thread_id))
		choices[thread_id] = choices_for(thread_id)
		transcripts[thread_id] = transcript_for(thread_id)
	return {"characters":_characters(),"threads":threads,"messages_by_thread":transcripts,"choices_by_thread":choices,"narrative_day_short":current_narrative_day_short(),"narrative_time":current_narrative_time_text(),"narrative_time_minutes":current_time_minutes,"implementation_status":"PLAYABLE"}

func start_day() -> Dictionary:
	if phase != "day_start_pending" or not state.begin_j12():
		return {"accepted":false}
	var mathilde_aftercare: Dictionary = state.obligations.get("aftercare_mathilde_j11", {})
	if str(mathilde_aftercare.get("status", "")) == "FAILED":
		if not state.mark_j12_failed_aftercare_processed():
			return {"accepted":false}
		_enter_segment(MATHILDE_THREAD, "j12_mathilde_failed_aftercare", "mathilde_failed_incoming")
		return _incoming_result(MATHILDE_THREAD)
	if state.j11_pivot_outcome == "MARIE_ADULT_RECONQUEST":
		var marie_aftercare: Dictionary = state.obligations.get("aftercare_marie_j11", {})
		if state.j11_physical_level != "MARIE_ADULT_RECONQUEST" or str(marie_aftercare.get("status", "")) != "DUE":
			return {"accepted":false}
		_enter_segment(MARIE_THREAD, "j12_marie_morning_aftercare", "marie_aftercare_incoming")
		return _incoming_result(MARIE_THREAD)
	return _continue_morning()

func confirm_day_transition() -> Dictionary: return start_day() if phase == "day_start_pending" else {"accepted":false}
func transcript_for(thread_id: String) -> Array[Dictionary]: return _dictionary_array(transcripts_by_thread.get(thread_id, []))

func choices_for(thread_id: String) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var ids: Array = pending_choice_ids_by_thread.get(thread_id, [])
	for segment in segments_by_id.values():
		for choice in segment.get("choices", []):
			if ids.has(str(choice.get("id", ""))):
				result.append({"choice_id":str(choice.get("id", "")),"text":str(choice.get("text", "")),"enabled":true,"confirmation_required":false})
	return result

func apply_choice(thread_id: String, choice_id: String) -> Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id, []).has(choice_id):
		return {"accepted":false}
	var selected := _choice_by_id(choice_id)
	if selected.is_empty() or not state.apply_j12_choice(choice_id):
		return {"accepted":false}
	pending_choice_ids_by_thread[thread_id] = []
	var before := transcript_for(thread_id).size()
	var response_messages: Array = selected.get("next_messages", [])
	var choice_timestamp := current_narrative_time_text()
	if not response_messages.is_empty(): choice_timestamp = str(response_messages[0].get("time_label", choice_timestamp))
	_append_player_choice(thread_id, choice_id, str(selected.get("text", "")), choice_timestamp)
	_append_messages(thread_id, response_messages)
	var direct_result := _advance_after_choice(choice_id)
	var result := {"accepted":true,"new_messages":transcript_for(thread_id).slice(before),"choices":choices_for(thread_id),"transition":pending_transition.duplicate(true)}
	for key in direct_result: result[key] = direct_result[key]
	return result

func confirm_transition() -> Dictionary:
	if pending_transition.is_empty(): return {"accepted":false}
	var kind := str(pending_transition.get("kind", ""))
	pending_transition = {}
	match kind:
		"sandra_cafe_off_phone":
			if not state.pay_j12_p11(): return {"accepted":false}
			_enter_segment(SANDRA_THREAD, "j12_sandra_cafe_after", "p11_after_incoming")
			return _incoming_result(SANDRA_THREAD)
		"to_laverriere_plan":
			_enter_segment(MARIE_THREAD, "j12_laverriere_plan", "plan_incoming")
			return _incoming_result(MARIE_THREAD)
		"to_laverriere_public":
			if not state.establish_j12_laverriere_public_trace(): return {"accepted":false}
			_enter_segment(LAVERRIERE_THREAD, "j12_laverriere_public", "public_incoming")
			return _incoming_result(LAVERRIERE_THREAD)
		"to_laverriere_close":
			_enter_segment(MARIE_THREAD, "j12_laverriere_close", "close_incoming")
			return _incoming_result(MARIE_THREAD)
		"to_annexe":
			if not state.establish_j12_annexe_public_trace(): return {"accepted":false}
			_enter_segment(ANNEXE_THREAD, "j12_annexe_public", "annexe_incoming")
			return _incoming_result(ANNEXE_THREAD)
		"to_after_separation":
			if not state.establish_j12_priority_consequence(_priority_route()): return {"accepted":false}
			var route := _priority_route()
			var segment_id := _after_segment_for_route(route)
			if segment_id == "":
				_schedule_transition("day_close")
				return _transition_result()
			var thread_id := _thread_for_route(route)
			_enter_segment(thread_id, segment_id, "after_incoming")
			return _incoming_result(thread_id)
		"day_close":
			if not state.complete_j12(): return {"accepted":false}
			if TimelineState != null: TimelineState.mark_day_complete(12)
			phase = "complete"
			return {"accepted":true,"destination":"day_end","day_end":runtime_map["day_end"].duplicate(true)}
	return {"accepted":false}

func on_thread_returned(_thread_id: String) -> Dictionary: return pending_transition.duplicate(true) if not pending_transition.is_empty() else {}

func mark_message_presented(message_id: String) -> bool:
	if message_id == "" or presented_time_message_ids.has(message_id): return false
	var timestamp := ""
	for thread_id in transcripts_by_thread:
		for message in transcripts_by_thread[thread_id]:
			if str(message.get("message_id", "")) == message_id:
				timestamp = str(message.get("timestamp", "")); break
		if timestamp != "": break
	presented_time_message_ids[message_id] = true
	var candidate := NARRATIVE_TIME.parse_narrative_time(timestamp)
	if candidate >= current_time_minutes: current_time_minutes = candidate
	return true

func mark_thread_batch_presented(thread_id: String) -> bool:
	if not _phase_accepts_batch() or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id), presented_time_message_ids, 12): return false
	match phase:
		"mathilde_failed_incoming": return not _continue_morning().is_empty()
		"marie_aftercare_incoming":
			if not state.pay_j12_marie_aftercare(): return false
			return not _continue_morning().is_empty()
		"p11_incoming": phase = "p11_choice"
		"p11_after_incoming": _schedule_transition("to_laverriere_plan")
		"plan_incoming": phase = "plan_choice"
		"public_incoming": _continue_after_public()
		"route_incoming": phase = "route_choice"
		"close_incoming": phase = "close_choice"
		"annexe_incoming": _continue_after_annexe()
		"remote_incoming": _schedule_transition("to_after_separation")
		"nico_incoming": phase = "nico_choice"
		"after_incoming": _schedule_transition("day_close")
	return true

func commit_narrative_time(minutes: int) -> bool:
	if minutes < current_time_minutes or NARRATIVE_TIME.format_narrative_time(minutes) == "": return false
	current_time_minutes = minutes
	return true

func snapshot() -> Dictionary:
	return {"version":SNAPSHOT_VERSION,"phase":phase,"transcripts_by_thread":transcripts_by_thread.duplicate(true),"produced_message_ids":produced_message_ids.duplicate(true),"unlocked_thread_ids":unlocked_thread_ids.duplicate(),"gallery_asset_ids":gallery_asset_ids.duplicate(),"served_visual_beat_ids":served_visual_beat_ids.duplicate(),"pending_choice_ids_by_thread":pending_choice_ids_by_thread.duplicate(true),"pending_transition":pending_transition.duplicate(true),"presented_time_message_ids":presented_time_message_ids.duplicate(true),"current_time_minutes":current_time_minutes}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) not in [1, SNAPSHOT_VERSION]: return false
	var allowed := ["day_start_pending","mathilde_failed_incoming","marie_aftercare_incoming","p11_incoming","p11_choice","sandra_cafe_off_phone","p11_after_incoming","to_laverriere_plan","plan_incoming","plan_choice","to_laverriere_public","public_incoming","route_incoming","route_choice","to_laverriere_close","close_incoming","close_choice","to_annexe","annexe_incoming","remote_incoming","nico_incoming","nico_choice","to_after_separation","after_incoming","day_close","complete"]
	if str(value.get("phase", "")) not in allowed: return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY: return false
	var restored_time := int(value.get("current_time_minutes", -1))
	if NARRATIVE_TIME.format_narrative_time(restored_time) == "": return false
	phase = str(value["phase"]); transcripts_by_thread = value["transcripts_by_thread"].duplicate(true); produced_message_ids = value["produced_message_ids"].duplicate(true)
	unlocked_thread_ids.assign(value["unlocked_thread_ids"]); gallery_asset_ids.assign(value["gallery_asset_ids"]); served_visual_beat_ids.assign(value["served_visual_beat_ids"])
	pending_choice_ids_by_thread = value["pending_choice_ids_by_thread"].duplicate(true); pending_transition = value["pending_transition"].duplicate(true); presented_time_message_ids = value["presented_time_message_ids"].duplicate(true); current_time_minutes = restored_time
	return _restored_phase_consistent()

func presentation_count_by_id(id: String) -> int:
	var count := 0
	for thread_id in transcripts_by_thread:
		for item in transcripts_by_thread[thread_id]:
			if str(item.get("message_id", "")) == id: count += 1
	return count

func _continue_morning() -> Dictionary:
	var p11: Dictionary = state.promises.get("sandra_cafe_saturday_1100", {})
	if str(p11.get("status", "")) == "CONDITIONAL" and str(p11.get("counterparty_confirmed_by", "")) == "Sandra":
		_enter_segment(SANDRA_THREAD, "j12_sandra_cafe_confirmation", "p11_incoming")
		return _incoming_result(SANDRA_THREAD)
	_schedule_transition("to_laverriere_plan")
	return _transition_result()

func _advance_after_choice(choice_id: String) -> Dictionary:
	if choice_id == "choice_j12_p11_confirm": _schedule_transition("sandra_cafe_off_phone")
	elif choice_id == "choice_j12_p11_refuse": _schedule_transition("to_laverriere_plan")
	elif choice_id.begins_with("choice_j12_presence_"): _schedule_transition("to_laverriere_public")
	elif choice_id.begins_with("choice_j12_sandra_") or choice_id.begins_with("choice_j12_mathilde_") or choice_id.begins_with("choice_j12_raphaelle_") or choice_id.begins_with("choice_j12_marie_"): _schedule_transition("to_laverriere_close")
	elif choice_id in ["choice_j12_annexe_a12","choice_j12_annexe_b12"]: _schedule_transition("to_annexe")
	elif choice_id == "choice_j12_annexe_c12":
		if not state.establish_j12_annexe_public_trace(): return {"accepted":false}
		_enter_segment(ANNEXE_THREAD, "j12_annexe_remote_traces", "remote_incoming")
		return _incoming_result(ANNEXE_THREAD)
	elif choice_id.begins_with("choice_j12_nico_"): _schedule_transition("to_after_separation")
	return _transition_result() if not pending_transition.is_empty() else {}

func _continue_after_public() -> void:
	var segment_id := ""
	var thread_id := ""
	match state.j11_pivot:
		"SANDRA":
			var trace: Dictionary = state.traces.get("j11_sandra_chosen_image_01", {})
			if str(trace.get("current_state", "")) != "REMOVED" and state.j11_pivot_outcome in ["SANDRA_RULE_CLARIFIED", "SANDRA_DESIRE_BOUNDED"]:
				_append_context_messages(SANDRA_THREAD, "j12_sandra_rule_context" if state.j11_pivot_outcome == "SANDRA_RULE_CLARIFIED" else "j12_sandra_desire_context")
				segment_id = "j12_sandra_module"; thread_id = SANDRA_THREAD
		"MATHILDE":
			var aftercare: Dictionary = state.obligations.get("aftercare_mathilde_j11", {})
			if str(aftercare.get("status", "")) != "FAILED":
				match state.j11_pivot_outcome:
					"MATHILDE_LOOK_ONLY": segment_id = "j12_mathilde_look_module"
					"MATHILDE_M_B1": segment_id = "j12_mathilde_m_b1_module"
					"MATHILDE_M_B2":
						if state.j11_physical_level == "MATHILDE_M_B2" and str(aftercare.get("status", "")) == "PAID": segment_id = "j12_mathilde_m_b2_module"
					"MATHILDE_M_B3":
						if state.j11_physical_level == "MATHILDE_M_B3" and str(aftercare.get("status", "")) == "PAID": segment_id = "j12_mathilde_m_b3_module"
				if segment_id != "": thread_id = MATHILDE_THREAD
		"RAPHAELLE":
			var context_segment := str({
				"FIRST_KISS": "j12_raphaelle_first_kiss_context",
				"KISS_DECLINED": "j12_raphaelle_kiss_declined_context",
				"RESULT_SENT_ATTRACTION_NAMED": "j12_raphaelle_attraction_context",
				"RESULT_SENT_BOUNDARY_HELD": "j12_raphaelle_boundary_context",
			}.get(state.j11_pivot_outcome, ""))
			if context_segment != "":
				_append_context_messages(RAPHAELLE_THREAD, context_segment)
				segment_id = "j12_raphaelle_module"; thread_id = RAPHAELLE_THREAD
		"MARIE":
			match state.j11_pivot_outcome:
				"MARIE_ADULT_RECONQUEST":
					if state.j11_physical_level == "MARIE_ADULT_RECONQUEST" and str(state.obligations.get("aftercare_marie_j11", {}).get("status", "")) == "PAID": segment_id = "j12_marie_module"
				"MARIE_NON_ADULT_RECONNECTION": segment_id = "j12_marie_non_adult_module"
				"MARIE_SEX_NOT_USED_AS_BANDAGE": segment_id = "j12_marie_no_bandage_module"
			if segment_id != "": thread_id = MARIE_THREAD
	if segment_id == "": _schedule_transition("to_laverriere_close")
	else:
		_enter_segment(thread_id, segment_id, "route_incoming")
		if state.j11_pivot_outcome == "KISS_DECLINED": pending_choice_ids_by_thread[RAPHAELLE_THREAD] = ["choice_j12_raphaelle_declined_hold"]
		elif state.j11_pivot_outcome == "RESULT_SENT_BOUNDARY_HELD": pending_choice_ids_by_thread[RAPHAELLE_THREAD] = ["choice_j12_raphaelle_boundary_hold"]

func _continue_after_annexe() -> void:
	if state.j11_pivot != "NICO":
		_schedule_transition("to_after_separation")
		return
	match state.j11_pivot_outcome:
		"NICO_GUARDRAIL_HELD": _enter_segment(NICO_THREAD, "j12_nico_guardrail_module", "nico_incoming")
		"NICO_RIVALRY_MAINTAINED": _enter_segment(NICO_THREAD, "j12_nico_rivalry_module", "nico_incoming")
		"NICO_CLEAN_CLOSE": _schedule_transition("to_after_separation")
		_: _schedule_transition("to_after_separation")

func _priority_route() -> String:
	var failed: Dictionary = state.obligations.get("aftercare_mathilde_j11", {})
	if str(failed.get("status", "")) == "FAILED": return "MATHILDE"
	if state.j11_pivot == "SANDRA":
		if state.j11_pivot_outcome == "SANDRA_IMAGE_REMOVED": return "NETWORK"
		return "SANDRA" if state.j11_pivot_outcome in ["SANDRA_RULE_CLARIFIED", "SANDRA_DESIRE_BOUNDED"] else "NETWORK"
	if state.j11_pivot == "MATHILDE":
		if state.j11_pivot_outcome in ["MATHILDE_LOOK_ONLY","MATHILDE_M_B1","MATHILDE_CLEAN_STOP","MATHILDE_DISTANCE_RESTORED"]: return "MATHILDE"
		if state.j11_pivot_outcome in ["MATHILDE_M_B2","MATHILDE_M_B3"] and state.j11_physical_level == state.j11_pivot_outcome and str(failed.get("status", "")) == "PAID": return "MATHILDE"
		return "NETWORK"
	if state.j11_pivot == "MARIE":
		if state.j11_pivot_outcome == "MARIE_ADULT_RECONQUEST" and state.j11_physical_level == "MARIE_ADULT_RECONQUEST" and str(state.obligations.get("aftercare_marie_j11", {}).get("status", "")) == "PAID": return "MARIE"
		if state.j11_pivot_outcome in ["MARIE_NON_ADULT_RECONNECTION","MARIE_SEX_NOT_USED_AS_BANDAGE","MARIE_HONEST_REFUSAL","MARIE_NO_RECONQUEST"]: return "MARIE"
		return "NETWORK"
	if state.j11_pivot == "RAPHAELLE" and state.j11_pivot_outcome in ["FIRST_KISS", "KISS_DECLINED", "RESULT_SENT_ATTRACTION_NAMED", "RESULT_SENT_BOUNDARY_HELD"]: return "RAPHAELLE"
	if state.j11_pivot == "NICO" and state.j11_pivot_outcome in ["NICO_GUARDRAIL_HELD", "NICO_RIVALRY_MAINTAINED", "NICO_CLEAN_CLOSE"]: return "NICO"
	return "NETWORK"

func _after_segment_for_route(route: String) -> String:
	if state.j11_pivot == "SANDRA" and state.j11_pivot_outcome == "SANDRA_IMAGE_REMOVED": return ""
	if route == "SANDRA":
		return str({
			"SANDRA_RESPONSE_CLEAR": "j12_after_sandra_clear",
			"SANDRA_RESPONSE_DELAYED": "j12_after_sandra_delayed",
			"SANDRA_EXIT_CLEAN": "j12_after_sandra_exit",
		}.get(state.j12_private_outcome, ""))
	if route == "RAPHAELLE":
		if state.j11_pivot_outcome == "KISS_DECLINED": return "j12_after_raphaelle_kiss_declined"
		if state.j11_pivot_outcome == "RESULT_SENT_BOUNDARY_HELD": return "j12_after_raphaelle_boundary"
		if state.j12_private_outcome == "RAPHAELLE_NOW": return "j12_after_raphaelle_pressure"
		return "j12_after_raphaelle_first_kiss" if state.j11_pivot_outcome == "FIRST_KISS" else "j12_after_raphaelle_attraction"
	if route == "NICO":
		match state.j11_pivot_outcome:
			"NICO_CLEAN_CLOSE": return ""
			"NICO_RIVALRY_MAINTAINED": return "j12_after_nico_rivalry_respected" if state.j12_private_outcome == "NICO_RIVALRY_LEAVE" else "j12_after_nico_rivalry"
			"NICO_GUARDRAIL_HELD": return "j12_after_nico_guardrail_closed" if state.j12_private_outcome == "NICO_REFUSE" else "j12_after_nico_guardrail"
		return ""
	if route == "MATHILDE":
		if str(state.obligations.get("aftercare_mathilde_j11", {}).get("status", "")) == "FAILED": return ""
		return str({
			"MATHILDE_LOOK_ONLY":"j12_after_mathilde_look",
			"MATHILDE_M_B1":"j12_after_mathilde_m_b1",
			"MATHILDE_M_B2":"j12_after_mathilde_m_b2",
			"MATHILDE_M_B3":"j12_after_mathilde",
			"MATHILDE_CLEAN_STOP":"j12_after_mathilde_clean_stop",
			"MATHILDE_DISTANCE_RESTORED":"",
		}.get(state.j11_pivot_outcome, ""))
	if route == "MARIE":
		return str({
			"MARIE_ADULT_RECONQUEST":"j12_after_marie",
			"MARIE_NON_ADULT_RECONNECTION":"j12_after_marie_non_adult",
			"MARIE_SEX_NOT_USED_AS_BANDAGE":"j12_after_marie_no_bandage",
			"MARIE_HONEST_REFUSAL":"j12_after_marie_distance",
			"MARIE_NO_RECONQUEST":"j12_after_marie_distance",
		}.get(state.j11_pivot_outcome, ""))
	return "j12_after_%s" % route.to_lower()

func _thread_for_route(route: String) -> String:
	return {"SANDRA":SANDRA_THREAD,"MATHILDE":MATHILDE_THREAD,"RAPHAELLE":RAPHAELLE_THREAD,"NICO":NICO_THREAD,"MARIE":MARIE_THREAD,"NETWORK":MARIE_THREAD}.get(route, MARIE_THREAD)

func _phase_accepts_batch() -> bool: return phase in ["mathilde_failed_incoming","marie_aftercare_incoming","p11_incoming","p11_after_incoming","plan_incoming","public_incoming","route_incoming","close_incoming","annexe_incoming","remote_incoming","nico_incoming","after_incoming"]
func _schedule_transition(key: String) -> void: phase = key; pending_transition = _transition(key)
func _transition(key: String) -> Dictionary:
	var result: Dictionary = runtime_map.get(key, {}).duplicate(true); result["kind"] = key; result["from_time"] = current_narrative_time_text(); return result
func _transition_result() -> Dictionary: return {"accepted":true,"destination":"timeline","transition":pending_transition.duplicate(true)}
func _incoming_result(thread_id: String) -> Dictionary: return {"accepted":true,"destination":"conversation","thread_id":thread_id,"notification":{"body":"Nouveau message !"}}

func _enter_segment(thread_id: String, segment_id: String, incoming_phase: String) -> void:
	_unlock_thread(thread_id)
	var segment: Dictionary = segments_by_id.get(segment_id, {})
	_append_messages(thread_id, segment.get("messages", []))
	var ids: Array[String] = []
	for choice in segment.get("choices", []): ids.append(str(choice.get("id", "")))
	pending_choice_ids_by_thread[thread_id] = ids
	phase = incoming_phase

func _append_context_messages(thread_id: String, segment_id: String) -> void:
	_unlock_thread(thread_id)
	_append_messages(thread_id, segments_by_id.get(segment_id, {}).get("messages", []))

func _choice_by_id(choice_id: String) -> Dictionary:
	for segment in segments_by_id.values():
		for choice in segment.get("choices", []):
			if str(choice.get("id", "")) == choice_id: return choice
	return {}

func _append_player_choice(thread_id: String, choice_id: String, choice_text: String, timestamp: String) -> void:
	_append(thread_id, {"message_id":choice_id + "_player","author_id":"player","timestamp":timestamp,"content_type":"TEXT","text":choice_text,"media_ref":"","is_player":true,"is_read":true,"source_day":12})

func _append_messages(thread_id: String, messages: Array) -> void:
	for message in messages:
		var author := str(message.get("sender", "system"))
		_append(thread_id, {"message_id":str(message.get("id", "")),"author_id":author,"timestamp":str(message.get("time_label", "")),"content_type":str(message.get("content_type", "TEXT")),"text":str(message.get("text", "")),"media_ref":str(message.get("media_ref", "")),"placeholder_label":str(message.get("placeholder_label", "Photo de démonstration")),"is_player":author == "player","is_read":author == "player","source_day":12})

func _append(thread_id: String, item: Dictionary) -> bool:
	var id := str(item.get("message_id", ""))
	if id == "" or produced_message_ids.has(id): return false
	var transcript: Array = transcripts_by_thread.get(thread_id, []); transcript.append(item.duplicate(true)); transcripts_by_thread[thread_id] = transcript; produced_message_ids[id] = true; return true

func _unlock_thread(id: String) -> void:
	if not unlocked_thread_ids.has(id): unlocked_thread_ids.append(id)

func _restored_phase_consistent() -> bool:
	if phase == "day_start_pending": return state.current_day == "J11" and state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.current_day != "J12": return false
	if phase == "complete": return state.day_status == "COMPLETE" and pending_transition.is_empty()
	if state.day_status != "ACTIVE": return false
	var transition_phases := ["sandra_cafe_off_phone","to_laverriere_plan","to_laverriere_public","to_laverriere_close","to_annexe","to_after_separation","day_close"]
	return not pending_transition.is_empty() if phase in transition_phases else pending_transition.is_empty()

func _thread_presentation(id: String) -> Dictionary:
	var titles := {MARIE_THREAD:"Marie",SANDRA_THREAD:"Sandra",MATHILDE_THREAD:"Mathilde",RAPHAELLE_THREAD:"Raphaëlle",NICO_THREAD:"Nico",LAVERRIERE_THREAD:"La Verrière",ANNEXE_THREAD:"L’Annexe","thread_pauline_private":"Pauline"}
	var participants := {MARIE_THREAD:["marie","player"],SANDRA_THREAD:["sandra","player"],MATHILDE_THREAD:["mathilde","player"],RAPHAELLE_THREAD:["raphaelle","player"],NICO_THREAD:["nico","player"],LAVERRIERE_THREAD:["marie","pauline","player"],ANNEXE_THREAD:["nico","marie","pauline","player"],"thread_pauline_private":["pauline","player"]}
	var transcript := transcript_for(id); var last: Dictionary = {}; var unread := RUNTIME_UNREAD.incoming_unread_count(transcript, presented_time_message_ids, 12)
	for item in transcript:
		if str(item.get("content_type", "")) != "OFF_PHONE_TRANSITION": last = item
	var title := str(titles.get(id, id)); var is_group := id in [LAVERRIERE_THREAD, ANNEXE_THREAD]
	return {"thread_id":id,"title":title,"participant_ids":participants.get(id,["player"]),"last_preview":"Nouveau message !" if unread > 0 else str(last.get("text", "")),"last_timestamp":str(last.get("timestamp", "")),"unread_count":unread,"has_unread_content":unread > 0,"availability_state":"AVAILABLE","is_group":is_group,"is_archived":false,"avatar_ref":title.left(1),"accent_color":"#8D63E6"}

func _characters() -> Dictionary:
	return {"marie":_character("marie","Marie","#4F8BFF","M"),"sandra":_character("sandra","Sandra","#20C7C9","S"),"mathilde":_character("mathilde","Mathilde","#E070A8","M"),"raphaelle":_character("raphaelle","Raphaëlle","#D69A42","R"),"pauline":_character("pauline","Pauline","#E6B84A","P"),"nico":_character("nico","Nico","#65B87A","N"),"bastien":_character("bastien","Bastien","#88909A","B"),"elodie":_character("elodie","Élodie","#A979D1","É"),"sophie":_character("sophie","Sophie","#C48A6A","S"),"player":_character("player","Player","#8D63E6","")}
func _character(id: String, title: String, accent: String, avatar: String) -> Dictionary: return {"character_id":id,"display_name":title,"accent_color":accent,"avatar_ref":avatar,"gallery_enabled":false}

func gallery_source() -> Dictionary:
	var fixtures := {"marie":_gallery_character("marie","Marie","#4F8BFF","M"),"sandra":_gallery_character("sandra","Sandra","#20C7C9","S"),"mathilde":_gallery_character("mathilde","Mathilde","#E070A8","M"),"raphaelle":_gallery_character("raphaelle","Raphaëlle","#D69A42","R"),"pauline":_gallery_character("pauline","Pauline","#E6B84A","P"),"nico":_gallery_character("nico","Nico","#65B87A","N")}
	var all_assets: Array = []; var all_children: Dictionary = {}
	for day in range(2, 13):
		var day_map: Dictionary = DataLoader.load_json("res://data/runtime/season_1/j%02d_runtime_map.json" % day); all_assets.append_array(day_map.get("gallery_presentations", []))
		for raw_child in day_map.get("gallery_children", []):
			if raw_child is Dictionary and str(raw_child.get("asset_id", "")) != "": all_children[str(raw_child.get("asset_id", ""))] = raw_child.duplicate(true)
	var included_children: Dictionary = {}; var added: Dictionary = {}
	for raw_asset in all_assets:
		if not raw_asset is Dictionary: continue
		var asset: Dictionary = raw_asset; var asset_id := str(asset.get("asset_id", ""))
		if asset_id == "" or not gallery_asset_ids.has(asset_id): continue
		for raw_character_id in asset.get("character_ids", []):
			var character_id := str(raw_character_id); var character: Dictionary = fixtures.get(character_id, {}); var item_key := "%s::%s" % [character_id, asset_id]
			if character.is_empty() or added.has(item_key): continue
			var items: Array = character["items"]; items.append(_gallery_item(asset, character_id, items.size())); character["items"] = items; added[item_key] = true
		for raw_child_id in asset.get("sequence_child_ids", []):
			var child_id := str(raw_child_id)
			if all_children.has(child_id): included_children[child_id] = all_children[child_id].duplicate(true)
	return {"fixtures":fixtures,"character_order":["marie","sandra","mathilde","raphaelle","pauline","nico"],"children_by_id":included_children,"empty_label":"Aucun visuel disponible."}

func _gallery_character(id: String, title: String, accent: String, avatar: String) -> Dictionary: return {"character_id":id,"display_name":title,"accent_color":Color.from_string(accent, Color.WHITE),"avatar_ref":avatar,"items":[]}
func _gallery_item(asset: Dictionary, character_id: String, index: int) -> Dictionary:
	var item := {"item_id":str(asset.get("asset_id", "")),"asset_id":str(asset.get("asset_id", "")),"character_id":character_id,"state":"UNLOCKED","is_new":true,"sort_key":index,"thumbnail_ref":"","full_ref":"","thumbnail_label":str(asset.get("placeholder_label", "Visuel non produit")),"placeholder_label":str(asset.get("placeholder_label", "Visuel non produit")),"source_kind":str(asset.get("source_kind", "gallery")),"content_type":str(asset.get("content_type", "PHOTO")),"can_share":bool(asset.get("can_share", false)),"transfer_rule":str(asset.get("transfer_rule", "FORBIDDEN")),"is_diegetic":bool(asset.get("is_diegetic", true))}
	if asset.has("sequence_child_ids"): item["sequence_child_ids"] = asset.get("sequence_child_ids")
	return item

func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary: result.append(item.duplicate(true))
	return result
