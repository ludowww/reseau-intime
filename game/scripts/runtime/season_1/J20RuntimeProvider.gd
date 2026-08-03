extends "res://scripts/runtime/season_1/J19RuntimeProvider.gd"
class_name J20RuntimeProvider
const J20_MAP:="res://data/runtime/season_1/j20_runtime_map.json"
func initialize(shared_state,a:Dictionary,b:Dictionary,c:Array,d:Array)->bool:
	if not super.initialize(shared_state,a,b,c,d):return false
	runtime_map=DataLoader.load_json(J20_MAP);segments_by_id={};var q:Dictionary=DataLoader.load_json("res://data/conversations/chapter_20_nico_position.json")
	for s in q.get("segments",[]):segments_by_id[str(s.get("id",""))]=s
	current_time_minutes=NARRATIVE_TIME.parse_narrative_time(str(runtime_map.initial_time));selected_pivot="";phase="day_start_pending";return not q.is_empty()
func start_day()->Dictionary:
	if phase!="day_start_pending" or not state.begin_j20():return {"accepted":false}
	selected_pivot=state.j20_context;_schedule_transition("to_resolution");return _transition_result()
func confirm_transition()->Dictionary:
	if pending_transition.is_empty():return {"accepted":false}
	var kind:=str(pending_transition.get("kind",""));pending_transition={}
	match kind:
		"to_resolution":_enter_segment("thread_nico_private",_opening_segment(),"resolution_incoming");return _incoming_result("thread_nico_private")
		"to_invitation":_enter_segment("thread_nico_private","j20_invitation","invitation_incoming");return _incoming_result("thread_nico_private")
		"to_meeting":
			if not state.pay_j20_meeting():return {"accepted":false}
			_enter_segment("thread_nico_private","j20_return_guardrail","return_incoming");return _incoming_result("thread_nico_private")
		"day_close":
			if not state.complete_j20():return {"accepted":false}
			if TimelineState!=null:TimelineState.mark_day_complete(20)
			phase="complete";return {"accepted":true,"destination":"day_end","day_end":runtime_map.day_end.duplicate(true)}
	return {"accepted":false}
func apply_choice(thread_id:String,choice_id:String)->Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id,[]).has(choice_id):return {"accepted":false}
	var selected:=_choice_by_id(choice_id);if selected.is_empty():return {"accepted":false}
	var accepted:=false;var next_transition:="day_close";var extra:Array=[]
	if phase=="resolution_choice":
		accepted=state.apply_j20_position_choice(choice_id)
		if not accepted:return {"accepted":false}
		extra=segments_by_id.get(_outcome_segment(),{}).get("messages",[])
		if state.j20_nico_position=="DISTANCE":accepted=state.close_j20_without_meeting()
		else:next_transition="to_invitation"
	elif phase=="invitation_choice":
		accepted=state.apply_j20_meeting_choice(choice_id);next_transition="to_meeting" if choice_id=="choice_j20_meeting_accept" else "day_close"
	if not accepted:return {"accepted":false}
	pending_choice_ids_by_thread[thread_id]=[];var before:=transcript_for(thread_id).size();_append(thread_id,{"message_id":choice_id+"_player","author_id":"player","timestamp":current_narrative_time_text(),"content_type":"TEXT","text":str(selected.get("text","")),"media_ref":"","is_player":true,"is_read":true,"source_day":20});_append_messages(thread_id,selected.get("next_messages",[]));_append_messages(thread_id,extra);_schedule_transition(next_transition);return {"accepted":true,"new_messages":transcript_for(thread_id).slice(before),"choices":[],"transition":pending_transition.duplicate(true)}
func mark_thread_batch_presented(thread_id:String)->bool:
	if phase not in ["resolution_incoming","invitation_incoming","return_incoming"] or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id),presented_time_message_ids,20):return false
	if phase=="return_incoming":phase="return_presented";_schedule_transition("day_close");return true
	phase="resolution_choice" if phase=="resolution_incoming" else "invitation_choice";return true
func _append_messages(thread_id:String,messages:Array)->void:
	for m in messages:
		var author:=str(m.get("sender","system"));_append(thread_id,{"message_id":str(m.get("id","")),"author_id":author,"timestamp":str(m.get("time_label","")),"content_type":"TEXT","text":str(m.get("text","")),"media_ref":"","is_player":false,"is_read":false,"source_day":20})
func _opening_segment()->String:return {"ALIBI":"j20_open_alibi","CONFIDENCE":"j20_open_confidence","ORDINARY":"j20_open_ordinary"}.get(selected_pivot,"j20_open_ordinary")
func _outcome_segment()->String:return {"GUARDRAIL":"j20_outcome_guardrail","LIMITED_CONFIDANT":"j20_outcome_confidant","DISTANCE":"j20_outcome_distance"}.get(state.j20_nico_position,"")
func restore_snapshot(value:Dictionary)->bool:
	if int(value.get("version",-1))!=J15_SNAPSHOT_VERSION or str(value.get("phase","")) not in ["day_start_pending","to_resolution","resolution_incoming","resolution_choice","to_invitation","invitation_incoming","invitation_choice","to_meeting","return_incoming","return_presented","day_close","complete"]:return false
	if str(value.get("selected_pivot","")) not in ["","ALIBI","CONFIDENCE","ORDINARY"]:return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key))!=TYPE_DICTIONARY:return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(value.get(key))!=TYPE_ARRAY:return false
	phase=str(value.phase);selected_pivot=str(value.selected_pivot);transcripts_by_thread=value.transcripts_by_thread.duplicate(true);produced_message_ids=value.produced_message_ids.duplicate(true);unlocked_thread_ids.assign(value.unlocked_thread_ids);gallery_asset_ids.assign(value.gallery_asset_ids);served_visual_beat_ids.assign(value.served_visual_beat_ids);pending_choice_ids_by_thread=value.pending_choice_ids_by_thread.duplicate(true);pending_transition=value.pending_transition.duplicate(true);presented_time_message_ids=value.presented_time_message_ids.duplicate(true);current_time_minutes=int(value.current_time_minutes);return _restored_phase_consistent()
func _restored_phase_consistent()->bool:
	if phase=="day_start_pending":return state.current_day=="J19" and state.day_status=="COMPLETE" and pending_transition.is_empty()
	if state.current_day!="J20" or (selected_pivot!="" and selected_pivot!=state.j20_context):return false
	if phase=="complete":return state.day_status=="COMPLETE" and pending_transition.is_empty()
	if state.day_status!="ACTIVE":return false
	return not pending_transition.is_empty() if phase in ["to_resolution","to_invitation","to_meeting","day_close"] else pending_transition.is_empty()
func _thread_presentation(id:String)->Dictionary:
	var source:Dictionary=super._thread_presentation(id);var unread:=RUNTIME_UNREAD.incoming_unread_count(transcript_for(id),presented_time_message_ids,20);source.unread_count=unread;source.has_unread_content=unread>0
	if unread>0:source.last_preview="Nouveau message !"
	return source
