extends Node
const S:=preload("res://scripts/runtime/season_1/Season1State.gd")
const P:=preload("res://scripts/runtime/season_1/J21RuntimeProvider.gd")
func _ready():
	if _run_rule_path() and _run_existing_contradiction_path():print("RUNTIME_S1_21_J21_PLAYABLE: OK");get_tree().quit(0);return
	get_tree().quit(1)
func _fixture(trace_id:String,owner:String)->RefCounted:
	var s=S.new();s.current_day="J20";s.day_status="COMPLETE";s.couple_state="RECONQUEST_ACTIVE";s.traces[trace_id]={"trace_id":trace_id,"current_state":"ACTIVE","owner":owner,"current_audience":[owner]};s.final_trace_id=trace_id;s.final_trace_state="ACTIVE";s.final_trace_controller=owner;s.final_trace_audience=[owner];s.knowledge["fact_final_trace_selected"]={"source_ref":trace_id};return s
func _present(provider,thread:String)->void:
	for message in provider.transcript_for(thread):
		if int(message.get("source_day",0))==21:provider.mark_message_presented(str(message.message_id))
	provider.mark_thread_batch_presented(thread)
func _run_rule_path()->bool:
	var s=_fixture("j18_sandra_lunch_print_01","Sandra");s.j18_sandra_outcome="FRIENDSHIP_RESTORED";var p=P.new();if not p.initialize(s,{}, {},[],[]):return false
	p.start_day();p.commit_narrative_time(462);p.confirm_transition();_present(p,"thread_marie_private");p.apply_choice("thread_marie_private","choice_j21_morning_1930")
	var restored=P.new();if not restored.initialize(s,p.transcripts_by_thread,p.produced_message_ids,p.unlocked_thread_ids,p.gallery_asset_ids) or not restored.restore_snapshot(p.snapshot()):return false
	restored.commit_narrative_time(727);restored.confirm_transition();_present(restored,"thread_sandra_private");restored.commit_narrative_time(1128);restored.confirm_transition()
	if restored.choices_for("thread_sandra_private").size()!=2:return false
	restored.apply_choice("thread_sandra_private","choice_j21_rule");restored.commit_narrative_time(1272);restored.confirm_transition()
	return restored.phase=="complete" and s.final_posture=="RULE_ACTED" and s.j21_morning_outcome=="PRESENCE_1930" and s.existing_contradiction_id==""
func _run_existing_contradiction_path()->bool:
	var s=_fixture("j13_pauline_private_version_01","Pauline");s.j19_pauline_outcome="COMPARTMENT_PROTECTED";var p=P.new();if not p.initialize(s,{}, {},[],[]):return false
	p.start_day();p.commit_narrative_time(462);p.confirm_transition();_present(p,"thread_marie_private");p.apply_choice("thread_marie_private","choice_j21_morning_absent");p.commit_narrative_time(796);p.confirm_transition();_present(p,"thread_pauline_private");p.commit_narrative_time(1128);p.confirm_transition()
	if p.choices_for("thread_pauline_private").size()!=3:return false
	p.apply_choice("thread_pauline_private","choice_j21_contradiction");p.commit_narrative_time(1272);p.confirm_transition()
	return p.phase=="complete" and s.final_posture=="EXISTING_CONTRADICTION_MAINTAINED" and s.existing_contradiction_id=="PAULINE_COMPARTMENT" and s.knowledge.has("fact_existing_contradiction_maintained")
