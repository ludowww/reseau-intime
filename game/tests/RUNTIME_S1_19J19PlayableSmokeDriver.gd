extends Node
const S:=preload("res://scripts/runtime/season_1/Season1State.gd")
const P:=preload("res://scripts/runtime/season_1/J19RuntimeProvider.gd")
func _ready():
	if _run_fallback() and _run_pauline() and _run_raphaelle():print("RUNTIME_S1_19_J19_PLAYABLE: OK");get_tree().quit(0);return
	get_tree().quit(1)
func _present(provider,thread_id:String)->void:
	for message in provider.transcript_for(thread_id):provider.mark_message_presented(str(message.message_id))
	provider.mark_thread_batch_presented(thread_id)
func _run_fallback()->bool:
	var s=S.new();s.current_day="J18";s.day_status="COMPLETE";var p=P.new();if not p.initialize(s,{}, {},[],[]):return false
	p.start_day();p.commit_narrative_time(614);p.confirm_transition();_present(p,"thread_raphaelle_private");p.apply_choice("thread_raphaelle_private","choice_j19_secondary_raphaelle_professional_ack")
	var restored=P.new();if not restored.initialize(s,p.transcripts_by_thread,p.produced_message_ids,p.unlocked_thread_ids,p.gallery_asset_ids) or not restored.restore_snapshot(p.snapshot()):return false
	restored.commit_narrative_time(981);restored.confirm_transition();_present(restored,"thread_pauline_private");restored.apply_choice("thread_pauline_private","choice_j19_pauline_fallback_ack");restored.commit_narrative_time(1200);restored.confirm_transition()
	return restored.phase=="complete" and s.j19_pauline_outcome=="SURFACE_RESTORED" and s.j19_raphaelle_outcome=="COLLEAGUE_ONLY"
func _run_pauline()->bool:
	var s=S.new();s.current_day="J18";s.day_status="COMPLETE";s.traces["j13_pauline_private_version_01"]={"current_state":"PRIVATE_ACTIVE"};var p=P.new();if not p.initialize(s,{}, {},[],[]):return false
	p.start_day();p.commit_narrative_time(614);p.confirm_transition();_present(p,"thread_raphaelle_private");p.apply_choice("thread_raphaelle_private","choice_j19_secondary_raphaelle_professional_ack");p.commit_narrative_time(998);p.confirm_transition();_present(p,"thread_pauline_private");p.apply_choice("thread_pauline_private","choice_j19_pauline_protect");p.commit_narrative_time(1200);p.confirm_transition()
	return p.phase=="complete" and s.j19_pivot=="PAULINE" and s.j19_pauline_outcome=="COMPARTMENT_PROTECTED"
func _run_raphaelle()->bool:
	var s=S.new();s.current_day="J18";s.day_status="COMPLETE";s.raphaelle_state="CREATIVE_ACCESS";var p=P.new();if not p.initialize(s,{}, {},[],[]):return false
	p.start_day();p.commit_narrative_time(614);p.confirm_transition();_present(p,"thread_pauline_private");p.apply_choice("thread_pauline_private","choice_j19_secondary_pauline_ack");p.commit_narrative_time(981);p.confirm_transition();_present(p,"thread_raphaelle_private");p.apply_choice("thread_raphaelle_private","choice_j19_raphaelle_future");p.commit_narrative_time(995);p.confirm_transition();_present(p,"thread_raphaelle_private");p.apply_choice("thread_raphaelle_private","choice_j19_invitation_accept");p.commit_narrative_time(1200);p.confirm_transition()
	return p.phase=="complete" and s.j19_pivot=="RAPHAELLE" and s.j19_raphaelle_outcome=="FUTURE_INVITATION" and str(s.promises.get("raphaelle_future_atelier_saturday_1500",{}).get("status",""))=="ACTIVE"
