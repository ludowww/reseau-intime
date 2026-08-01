extends "res://scripts/runtime/season_1/J20RuntimeProvider.gd"
class_name J21RuntimeProvider
const J21_MAP:="res://data/runtime/season_1/j21_runtime_map.json"
func initialize(shared_state,a:Dictionary,b:Dictionary,c:Array,d:Array)->bool:
	if not super.initialize(shared_state,a,b,c,d):return false
	runtime_map=DataLoader.load_json(J21_MAP);segments_by_id={};var q:Dictionary=DataLoader.load_json("res://data/conversations/chapter_21_final_trace.json")
	for s in q.get("segments",[]):segments_by_id[str(s.get("id",""))]=s
	current_time_minutes=NARRATIVE_TIME.parse_narrative_time(str(runtime_map.initial_time));selected_pivot="";phase="day_start_pending";return not q.is_empty()
func start_day()->Dictionary:
	if phase!="day_start_pending" or not state.begin_j21():return {"accepted":false}
	selected_pivot=state.final_trace_id;_schedule_transition("to_morning");return _transition_result()
func confirm_transition()->Dictionary:
	if pending_transition.is_empty():return {"accepted":false}
	var kind:=str(pending_transition.get("kind",""));pending_transition={}
	match kind:
		"to_morning":_enter_segment("thread_marie_private",_morning_segment(),"morning_incoming");return _incoming_result("thread_marie_private")
		"to_trace":
			var thread:=_trace_thread();_enter_segment(thread,_trace_segment(),"trace_incoming");return _incoming_result(thread)
		"to_final_choice":
			var thread:=_trace_thread();_enter_segment(thread,"j21_final_choices","final_choice");var ids:Array=["choice_j21_rule","choice_j21_loss"]
			if state.final_posture_options.has("EXISTING_CONTRADICTION_MAINTAINED"):ids.append("choice_j21_contradiction")
			pending_choice_ids_by_thread[thread]=ids;return {"accepted":true,"destination":"conversation","thread_id":thread}
		"day_close":
			if not state.complete_j21():return {"accepted":false}
			if TimelineState!=null:TimelineState.mark_day_complete(21)
			phase="complete";return {"accepted":true,"destination":"day_end","day_end":runtime_map.day_end.duplicate(true)}
	return {"accepted":false}
func apply_choice(thread_id:String,choice_id:String)->Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id,[]).has(choice_id):return {"accepted":false}
	var selected:=_choice_by_id(choice_id);if selected.is_empty():return {"accepted":false}
	var accepted:=false;var next_transition:="to_trace";var extra:Array=[]
	if phase=="morning_choice":accepted=state.apply_j21_morning_choice(choice_id)
	elif phase=="final_choice":
		accepted=state.apply_j21_final_posture(choice_id);next_transition="day_close"
		if accepted:extra=segments_by_id.get(_response_segment(),{}).get("messages",[])
	if not accepted:return {"accepted":false}
	pending_choice_ids_by_thread[thread_id]=[];var before:=transcript_for(thread_id).size();_append(thread_id,{"message_id":choice_id+"_player","author_id":"player","timestamp":current_narrative_time_text(),"content_type":"TEXT","text":str(selected.get("text","")),"media_ref":"","is_player":true,"is_read":true,"source_day":21});_append_messages(thread_id,selected.get("next_messages",[]));_append_messages(thread_id,extra);_schedule_transition(next_transition);return {"accepted":true,"new_messages":transcript_for(thread_id).slice(before),"choices":[],"transition":pending_transition.duplicate(true)}
func mark_thread_batch_presented(thread_id:String)->bool:
	if phase not in ["morning_incoming","trace_incoming"] or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id),presented_time_message_ids,21):return false
	if phase=="morning_incoming":phase="morning_choice"
	else:_schedule_transition("to_final_choice")
	return true
func _append_messages(thread_id:String,messages:Array)->void:
	for m in messages:
		var author:=str(m.get("sender","system"));_append(thread_id,{"message_id":str(m.get("id","")),"author_id":author,"timestamp":str(m.get("time_label","")),"content_type":"TEXT","text":str(m.get("text","")),"media_ref":"","is_player":author=="player","is_read":author=="player","source_day":21})
func _morning_segment()->String:
	return {"RECONQUEST_ACTIVE":"j21_morning_reconquest","PROVISIONAL_AGREEMENT":"j21_morning_provisional","RECONFIGURATION_NEGOTIATION":"j21_morning_reconfiguration","DOUBLE_LIFE_FRAGILE":"j21_morning_double","FRACTURE":"j21_morning_fracture","SEPARATION":"j21_morning_separation"}.get(state.couple_state,"")
func _trace_thread()->String:
	var controller:=str(state.final_trace_controller).to_lower()
	if controller.contains("sandra"):return "thread_sandra_private"
	if controller.contains("pauline"):return "thread_pauline_private"
	if controller.contains("rapha"):return "thread_raphaelle_private"
	if controller.contains("nico"):return "thread_nico_private"
	return "thread_marie_private"
func _trace_segment()->String:
	if selected_pivot=="j18_sandra_lunch_print_01":
		if state.j18_sandra_outcome=="PROTECTIVE_DISTANCE":return "j21_trace_sandra_protective"
		if state.j18_sandra_outcome=="TRUST_BROKEN":return "j21_trace_sandra_broken"
		return "j21_trace_sandra_kept"
	if selected_pivot=="j13_pauline_private_version_01":return {"SURFACE_RESTORED":"j21_trace_pauline_surface","COMPARTMENT_PROTECTED":"j21_trace_pauline_protected"}.get(state.j19_pauline_outcome,"j21_trace_pauline_closed")
	if selected_pivot=="j19_raphaelle_creative_access_01":return "j21_trace_raphaelle_active"
	if selected_pivot in ["j20_nico_unauthorized_copy_deleted_01","j20_nico_exact_hour_record_01","j13_nico_alibi_or_hour_message_01"]:return "j21_trace_nico"
	return "j21_trace_sandra_kept"
func _response_segment()->String:
	if state.final_posture=="EXISTING_CONTRADICTION_MAINTAINED":return "j21_response_contradiction"
	var prefix:="j21_response_rule_" if state.final_posture=="RULE_ACTED" else "j21_response_loss_";var controller:=str(state.final_trace_controller).to_lower()
	if controller.contains("sandra"):return prefix+"sandra"
	if controller.contains("pauline"):return prefix+"pauline"
	if controller.contains("rapha"):return prefix+"raphaelle"
	if controller.contains("nico"):return prefix+"nico"
	return prefix+"marie"
func restore_snapshot(value:Dictionary)->bool:
	if int(value.get("version",-1))!=SNAPSHOT_VERSION or str(value.get("phase","")) not in ["day_start_pending","to_morning","morning_incoming","morning_choice","to_trace","trace_incoming","to_final_choice","final_choice","day_close","complete"]:return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key))!=TYPE_DICTIONARY:return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(value.get(key))!=TYPE_ARRAY:return false
	phase=str(value.phase);selected_pivot=str(value.selected_pivot);transcripts_by_thread=value.transcripts_by_thread.duplicate(true);produced_message_ids=value.produced_message_ids.duplicate(true);unlocked_thread_ids.assign(value.unlocked_thread_ids);gallery_asset_ids.assign(value.gallery_asset_ids);served_visual_beat_ids.assign(value.served_visual_beat_ids);pending_choice_ids_by_thread=value.pending_choice_ids_by_thread.duplicate(true);pending_transition=value.pending_transition.duplicate(true);presented_time_message_ids=value.presented_time_message_ids.duplicate(true);current_time_minutes=int(value.current_time_minutes);return _restored_phase_consistent()
func _restored_phase_consistent()->bool:
	if phase=="day_start_pending":return state.current_day=="J20" and state.day_status=="COMPLETE" and pending_transition.is_empty()
	if state.current_day!="J21" or (selected_pivot!="" and selected_pivot!=state.final_trace_id):return false
	if phase=="complete":return state.day_status=="COMPLETE" and pending_transition.is_empty()
	if state.day_status!="ACTIVE":return false
	return not pending_transition.is_empty() if phase in ["to_morning","to_trace","to_final_choice","day_close"] else pending_transition.is_empty()
func _thread_presentation(id:String)->Dictionary:
	var source:Dictionary=super._thread_presentation(id);var unread:=RUNTIME_UNREAD.incoming_unread_count(transcript_for(id),presented_time_message_ids,21);source.unread_count=unread;source.has_unread_content=unread>0
	if unread>0:source.last_preview="Nouveau message !"
	return source
