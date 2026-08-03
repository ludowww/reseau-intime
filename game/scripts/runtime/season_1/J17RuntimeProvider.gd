extends "res://scripts/runtime/season_1/J16RuntimeProvider.gd"
class_name J17RuntimeProvider
const J17_MAP_PATH:="res://data/runtime/season_1/j17_runtime_map.json"
func initialize(shared_state,cumulative_transcripts:Dictionary,cumulative_ids:Dictionary,cumulative_threads:Array,cumulative_gallery_ids:Array)->bool:
	if not super.initialize(shared_state,cumulative_transcripts,cumulative_ids,cumulative_threads,cumulative_gallery_ids):return false
	runtime_map=DataLoader.load_json(J17_MAP_PATH); segments_by_id={}; var c:Dictionary=DataLoader.load_json(str(runtime_map.get("conversation_paths",{}).get("chapter_17_departure_and_couple","")))
	for segment in c.get("segments",[]): segments_by_id[str(segment.get("id",""))]=segment
	current_time_minutes=NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get("initial_time",""))); selected_pivot=""; phase="day_start_pending"; return not c.is_empty()
func start_day()->Dictionary:
	if phase!="day_start_pending" or not state.begin_j17():return {"accepted":false}
	selected_pivot=state.j16_departure_state; _schedule_transition("to_departure"); return _transition_result()
func apply_choice(thread_id:String,choice_id:String)->Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id,[]).has(choice_id):return {"accepted":false}
	var selected:=_choice_by_id(choice_id); var accepted:bool=state.apply_j17_couple_choice(choice_id) if phase=="couple_choice" else state.apply_j17_departure_choice(choice_id.trim_suffix("_required"))
	if selected.is_empty() or not accepted:return {"accepted":false}
	pending_choice_ids_by_thread[thread_id]=[]; var before:=transcript_for(thread_id).size(); _append(thread_id,{"message_id":choice_id+"_player","author_id":"player","timestamp":current_narrative_time_text(),"content_type":"TEXT","text":str(selected.get("text","")),"media_ref":"","is_player":true,"is_read":true,"source_day":17}); _append_messages(thread_id,selected.get("next_messages",[])); _schedule_transition("day_close" if phase=="couple_choice" else "to_couple"); return {"accepted":true,"new_messages":transcript_for(thread_id).slice(before),"choices":[],"transition":pending_transition.duplicate(true)}
func confirm_transition()->Dictionary:
	if pending_transition.is_empty():return {"accepted":false}
	var kind:=str(pending_transition.get("kind","")); pending_transition={}
	match kind:
		"to_departure": _enter_segment("thread_mathilde_private","j17_departure_distance" if selected_pivot=="DISTANCE" else "j17_departure_ordinary","departure_incoming"); return _incoming_result("thread_mathilde_private")
		"to_couple": _enter_segment("thread_marie_private","j17_couple_due" if str(state.promises.get("marie_j16_couple_conversation_j17",{}).get("status",""))=="ACTIVE" else "j17_couple_refused","couple_incoming"); return _incoming_result("thread_marie_private")
		"day_close":
			if not state.complete_j17():return {"accepted":false}
			if TimelineState!=null:TimelineState.mark_day_complete(17)
			phase="complete"; return {"accepted":true,"destination":"day_end","day_end":runtime_map["day_end"].duplicate(true)}
	return {"accepted":false}
func mark_thread_batch_presented(thread_id:String)->bool:
	if phase not in ["departure_incoming","couple_incoming"] or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id),presented_time_message_ids,17):return false
	phase="departure_choice" if phase=="departure_incoming" else "couple_choice"; return true
func _append_messages(thread_id:String,messages:Array)->void:
	for m in messages:
		var a:=str(m.get("sender","system")); _append(thread_id,{"message_id":str(m.get("id","")),"author_id":a,"timestamp":str(m.get("time_label","")),"content_type":"TEXT","text":str(m.get("text","")),"media_ref":"","is_player":false,"is_read":false,"source_day":17})
func restore_snapshot(value:Dictionary)->bool:
	if int(value.get("version",-1))!=J15_SNAPSHOT_VERSION or str(value.get("phase","")) not in ["day_start_pending","to_departure","departure_incoming","departure_choice","to_couple","couple_incoming","couple_choice","day_close","complete"]:return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key))!=TYPE_DICTIONARY:return false
	phase=str(value.phase); selected_pivot=str(value.selected_pivot); transcripts_by_thread=value.transcripts_by_thread.duplicate(true); produced_message_ids=value.produced_message_ids.duplicate(true); unlocked_thread_ids.assign(value.unlocked_thread_ids); gallery_asset_ids.assign(value.gallery_asset_ids); served_visual_beat_ids.assign(value.served_visual_beat_ids); pending_choice_ids_by_thread=value.pending_choice_ids_by_thread.duplicate(true); pending_transition=value.pending_transition.duplicate(true); presented_time_message_ids=value.presented_time_message_ids.duplicate(true); current_time_minutes=int(value.current_time_minutes); return _restored_phase_consistent()
func _restored_phase_consistent()->bool:
	if phase=="day_start_pending":return state.current_day=="J16" and state.day_status=="COMPLETE"
	if state.current_day!="J17":return false
	return state.day_status=="COMPLETE" if phase=="complete" else state.day_status=="ACTIVE"
func _thread_presentation(id:String)->Dictionary:
	var s:Dictionary=super._thread_presentation(id)
	var u:=RUNTIME_UNREAD.incoming_unread_count(transcript_for(id),presented_time_message_ids,17)
	s.unread_count=u; s.has_unread_content=u>0
	if u>0:s.last_preview="Nouveau message !"
	return s
