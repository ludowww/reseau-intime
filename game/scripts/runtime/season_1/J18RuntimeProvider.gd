extends "res://scripts/runtime/season_1/J17RuntimeProvider.gd"
class_name J18RuntimeProvider
const MAP:="res://data/runtime/season_1/j18_runtime_map.json"
func initialize(shared_state,a:Dictionary,b:Dictionary,c:Array,d:Array)->bool:
	if not super.initialize(shared_state,a,b,c,d):return false
	runtime_map=DataLoader.load_json(MAP);segments_by_id={};var q=DataLoader.load_json("res://data/conversations/chapter_18_sandra_resolution.json");for s in q.get("segments",[]):segments_by_id[str(s.id)]=s
	current_time_minutes=NARRATIVE_TIME.parse_narrative_time(str(runtime_map.initial_time));phase="day_start_pending";return true
func start_day()->Dictionary:
	if phase!="day_start_pending" or not state.begin_j18():return {"accepted":false}
	_schedule_transition("to_resolution");return _transition_result()
func confirm_transition()->Dictionary:
	if pending_transition.is_empty():return {"accepted":false}
	var k=str(pending_transition.kind);pending_transition={}
	if k=="to_resolution":_enter_segment("thread_sandra_private",_opening_segment(),"priority_incoming");return _incoming_result("thread_sandra_private")
	if k=="day_close":
		if not state.complete_j18():return {"accepted":false}
		if TimelineState!=null:TimelineState.mark_day_complete(18)
		phase="complete";return {"accepted":true,"destination":"day_end","day_end":runtime_map.day_end.duplicate(true)}
	return {"accepted":false}
func apply_choice(thread_id:String,choice_id:String)->Dictionary:
	if not pending_transition.is_empty() or not pending_choice_ids_by_thread.get(thread_id,[]).has(choice_id):return {"accepted":false}
	var s=_choice_for_opening(choice_id);if s.is_empty() or not state.apply_j18_choice(choice_id):return {"accepted":false}
	pending_choice_ids_by_thread[thread_id]=[];_append(thread_id,{"message_id":choice_id+"_player","author_id":"player","timestamp":current_narrative_time_text(),"content_type":"TEXT","text":str(s.text),"is_player":true,"is_read":true,"source_day":18});_append_messages(thread_id,segments_by_id.get(_outcome_segment(),{}).get("messages",[]));_schedule_transition("day_close");return {"accepted":true,"transition":pending_transition.duplicate(true)}
func mark_thread_batch_presented(thread_id:String)->bool:
	if phase!="priority_incoming" or not RUNTIME_UNREAD.incoming_batch_fully_presented(transcript_for(thread_id),presented_time_message_ids,18):return false
	phase="priority_choice";return true
func _append_messages(thread_id:String,messages:Array)->void:
	for m in messages:_append(thread_id,{"message_id":str(m.id),"author_id":str(m.sender),"timestamp":str(m.time_label),"content_type":"TEXT","text":str(m.text),"is_player":false,"is_read":false,"source_day":18})
func _opening_segment()->String:
	var source:Dictionary=state.traces.get("j11_sandra_chosen_image_01",{})
	if state.knowledge.has("fact_witness_saw_limited_trace") and state.j14_variant=="SANDRA":return "j18_resolution_compromised"
	if str(source.get("current_state",""))=="REMOVED":return "j18_resolution_removed"
	if source.is_empty() or state.sandra_state=="DISTANT_FRIEND":return "j18_resolution_simple"
	return "j18_resolution_intact"
func _outcome_segment()->String:
	return {"FRIENDSHIP_RESTORED":"j18_outcome_friendship","PRIVILEGED_CONFIDENCE":"j18_outcome_confidence","PROTECTIVE_DISTANCE":"j18_outcome_protective","TRUST_BROKEN":"j18_outcome_broken"}.get(state.j18_sandra_outcome,"j18_outcome_protective")
func _choice_for_opening(choice_id:String)->Dictionary:
	for choice in segments_by_id.get(_opening_segment(),{}).get("choices",[]):
		if str(choice.get("id",""))==choice_id:return choice
	return {}
func restore_snapshot(value:Dictionary)->bool:
	if int(value.get("version",-1))!=J15_SNAPSHOT_VERSION or str(value.get("phase","")) not in ["day_start_pending","to_resolution","priority_incoming","priority_choice","day_close","complete"]:return false
	for key in ["transcripts_by_thread","produced_message_ids","pending_choice_ids_by_thread","pending_transition","presented_time_message_ids"]:
		if typeof(value.get(key))!=TYPE_DICTIONARY:return false
	for key in ["unlocked_thread_ids","gallery_asset_ids","served_visual_beat_ids"]:
		if typeof(value.get(key))!=TYPE_ARRAY:return false
	phase=str(value.phase);selected_pivot=str(value.get("selected_pivot",""));transcripts_by_thread=value.transcripts_by_thread.duplicate(true);produced_message_ids=value.produced_message_ids.duplicate(true);unlocked_thread_ids.assign(value.unlocked_thread_ids);gallery_asset_ids.assign(value.gallery_asset_ids);served_visual_beat_ids.assign(value.served_visual_beat_ids);pending_choice_ids_by_thread=value.pending_choice_ids_by_thread.duplicate(true);pending_transition=value.pending_transition.duplicate(true);presented_time_message_ids=value.presented_time_message_ids.duplicate(true);current_time_minutes=int(value.current_time_minutes);return _restored_phase_consistent()
func _restored_phase_consistent()->bool:
	if phase=="day_start_pending":return state.current_day=="J17" and state.day_status=="COMPLETE" and pending_transition.is_empty()
	if state.current_day!="J18":return false
	if phase=="complete":return state.day_status=="COMPLETE" and pending_transition.is_empty()
	if state.day_status!="ACTIVE":return false
	return not pending_transition.is_empty() if phase in ["to_resolution","day_close"] else pending_transition.is_empty()
func _thread_presentation(id:String)->Dictionary:
	var s:Dictionary=super._thread_presentation(id);var u:=RUNTIME_UNREAD.incoming_unread_count(transcript_for(id),presented_time_message_ids,18);s.unread_count=u;s.has_unread_content=u>0
	if u>0:s.last_preview="Nouveau message !"
	return s
