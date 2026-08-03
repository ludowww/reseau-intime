extends "res://scripts/runtime/season_1/J18RuntimeProvider.gd"
class_name J19RuntimeProvider
const J19_MAP:="res://data/runtime/season_1/j19_runtime_map.json"
func initialize(shared_state,a:Dictionary,b:Dictionary,c:Array,d:Array)->bool:
	if not super.initialize(shared_state,a,b,c,d):return false
	runtime_map=DataLoader.load_json(J19_MAP);segments_by_id={};var q:Dictionary=DataLoader.load_json("res://data/conversations/chapter_19_private_versions.json")
	for s in q.get("segments",[]):segments_by_id[str(s.get("id",""))]=s
	current_time_minutes=NARRATIVE_TIME.parse_narrative_time(str(runtime_map.initial_time));selected_pivot="";phase="day_start_pending";return not q.is_empty()
func start_day()->Dictionary:
	if phase!="day_start_pending" or not state.begin_j19():return {"accepted":false}
	selected_pivot=state.j19_pivot;_schedule_transition("to_secondary");return _transition_result()
func confirm_transition()->Dictionary:
	if pending_transition.is_empty():return {"accepted":false}
	var kind:=str(pending_transition.get("kind",""));pending_transition={}
	match kind:
		"to_secondary":
			var thread:=_secondary_thread();_enter_segment(thread,_secondary_segment(),"secondary_incoming");return _incoming_result(thread)
		"to_foreground":
			var thread:=_foreground_thread();_enter_segment(thread,_foreground_segment(),"foreground_incoming");return _incoming_result(thread)
		"to_invitation":_enter_segment("thread_raphaelle_private","j19_raphaelle_invitation","invitation_incoming");return _incoming_result("thread_raphaelle_private")
		"day_close":
			if not state.complete_j19():return {"accepted":false}
			if TimelineState!=null:TimelineState.mark_day_complete(19)
			phase="complete";return {"accepted":true,"destination":"day_end","day_end":runtime_map.day_end.duplicate(true)}
	return {"accepted":false}
func apply_choice(thread_id:String,choice_id:String)->Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id,[]).has(choice_id):return {"accepted":false}
	var selected:=_choice_by_id(choice_id);if selected.is_empty():return {"accepted":false}
	var accepted:=false;var next_transition:="day_close"
	if phase=="secondary_choice":accepted=state.apply_j19_secondary();next_transition="to_foreground"
	elif phase=="invitation_choice":accepted=state.apply_j19_invitation_choice(choice_id)
	elif selected_pivot=="FALLBACK":accepted=state.apply_j19_fallback_choice(choice_id)
	else:
		accepted=state.apply_j19_foreground_choice(choice_id)
		if choice_id=="choice_j19_raphaelle_future":next_transition="to_invitation"
	if not accepted:return {"accepted":false}
	pending_choice_ids_by_thread[thread_id]=[];var before:=transcript_for(thread_id).size();_append(thread_id,{"message_id":choice_id+"_player","author_id":"player","timestamp":current_narrative_time_text(),"content_type":"TEXT","text":str(selected.get("text","")),"media_ref":"","is_player":true,"is_read":true,"source_day":19});_append_messages(thread_id,selected.get("next_messages",[]));_schedule_transition(next_transition);return {"accepted":true,"new_messages":transcript_for(thread_id).slice(before),"choices":[],"transition":pending_transition.duplicate(true)}
func mark_thread_batch_presented(thread_id:String)->bool:
	if phase not in ["secondary_incoming","foreground_incoming","invitation_incoming"] or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id),presented_time_message_ids,19):return false
	phase={"secondary_incoming":"secondary_choice","foreground_incoming":"foreground_choice","invitation_incoming":"invitation_choice"}[phase];return true
func _append_messages(thread_id:String,messages:Array)->void:
	for m in messages:
		var author:=str(m.get("sender","system"));_append(thread_id,{"message_id":str(m.get("id","")),"author_id":author,"timestamp":str(m.get("time_label","")),"content_type":"TEXT","text":str(m.get("text","")),"media_ref":"","is_player":false,"is_read":false,"source_day":19})
func _secondary_thread()->String:return "thread_raphaelle_private" if selected_pivot in ["PAULINE","FALLBACK"] else "thread_pauline_private"
func _foreground_thread()->String:return "thread_raphaelle_private" if selected_pivot=="RAPHAELLE" else "thread_pauline_private"
func _secondary_segment()->String:
	if selected_pivot in ["PAULINE","FALLBACK"]:return "j19_secondary_raphaelle_creative" if state.j19_raphaelle_has_creative_access() else "j19_secondary_raphaelle_professional"
	return "j19_secondary_pauline_active" if state.j19_pauline_has_private_compartment() else "j19_secondary_pauline_surface"
func _foreground_segment()->String:
	if selected_pivot=="RAPHAELLE":return "j19_raphaelle_foreground"
	return "j19_pauline_fallback" if selected_pivot=="FALLBACK" else "j19_pauline_foreground"
func restore_snapshot(value:Dictionary)->bool:
	if int(value.get("version",-1))!=J15_SNAPSHOT_VERSION or str(value.get("phase","")) not in ["day_start_pending","to_secondary","secondary_incoming","secondary_choice","to_foreground","foreground_incoming","foreground_choice","to_invitation","invitation_incoming","invitation_choice","day_close","complete"]:return false
	if str(value.get("selected_pivot","")) not in ["","PAULINE","RAPHAELLE","FALLBACK"]:return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key))!=TYPE_DICTIONARY:return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(value.get(key))!=TYPE_ARRAY:return false
	phase=str(value.phase);selected_pivot=str(value.selected_pivot);transcripts_by_thread=value.transcripts_by_thread.duplicate(true);produced_message_ids=value.produced_message_ids.duplicate(true);unlocked_thread_ids.assign(value.unlocked_thread_ids);gallery_asset_ids.assign(value.gallery_asset_ids);served_visual_beat_ids.assign(value.served_visual_beat_ids);pending_choice_ids_by_thread=value.pending_choice_ids_by_thread.duplicate(true);pending_transition=value.pending_transition.duplicate(true);presented_time_message_ids=value.presented_time_message_ids.duplicate(true);current_time_minutes=int(value.current_time_minutes);return _restored_phase_consistent()
func _restored_phase_consistent()->bool:
	if phase=="day_start_pending":return state.current_day=="J18" and state.day_status=="COMPLETE" and pending_transition.is_empty()
	if state.current_day!="J19" or (selected_pivot!="" and selected_pivot!=state.j19_pivot):return false
	if phase=="complete":return state.day_status=="COMPLETE" and pending_transition.is_empty()
	if state.day_status!="ACTIVE":return false
	return not pending_transition.is_empty() if phase in ["to_secondary","to_foreground","to_invitation","day_close"] else pending_transition.is_empty()
func _thread_presentation(id:String)->Dictionary:
	var source:Dictionary=super._thread_presentation(id);var unread:=RUNTIME_UNREAD.incoming_unread_count(transcript_for(id),presented_time_message_ids,19);source.unread_count=unread;source.has_unread_content=unread>0
	if unread>0:source.last_preview="Nouveau message !"
	return source
