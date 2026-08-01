extends Node
const S:=preload("res://scripts/runtime/season_1/Season1State.gd")
const P:=preload("res://scripts/runtime/season_1/J20RuntimeProvider.gd")
func _ready():
	if _run_ordinary_meeting() and _run_alibi_distance():print("RUNTIME_S1_20_J20_PLAYABLE: OK");get_tree().quit(0);return
	get_tree().quit(1)
func _fixture():
	var s=S.new();s.current_day="J19";s.day_status="COMPLETE";s.traces["j18_sandra_lunch_print_01"]={"current_state":"ACTIVE","owner":"Sandra","current_audience":["Sandra"]};return s
func _present(provider)->void:
	for message in provider.transcript_for("thread_nico_private"):provider.mark_message_presented(str(message.message_id))
	provider.mark_thread_batch_presented("thread_nico_private")
func _run_ordinary_meeting()->bool:
	var s=_fixture();var p=P.new();if not p.initialize(s,{}, {},[],[]):return false
	p.start_day();p.commit_narrative_time(686);p.confirm_transition();_present(p);p.apply_choice("thread_nico_private","choice_j20_ordinary")
	var restored=P.new();if not restored.initialize(s,p.transcripts_by_thread,p.produced_message_ids,p.unlocked_thread_ids,p.gallery_asset_ids) or not restored.restore_snapshot(p.snapshot()):return false
	restored.commit_narrative_time(1137);restored.confirm_transition();_present(restored);restored.apply_choice("thread_nico_private","choice_j20_meeting_accept");restored.commit_narrative_time(1354);restored.confirm_transition();_present(restored);restored.commit_narrative_time(1360);restored.confirm_transition()
	return restored.phase=="complete" and s.j20_nico_position=="ORDINARY_FRIEND" and s.j20_meeting_outcome=="PAID" and s.final_trace_id=="j18_sandra_lunch_print_01"
func _run_alibi_distance()->bool:
	var s=_fixture();s.traces["j13_nico_alibi_or_hour_message_01"]={"current_state":"PRIVATE_ACTIVE","owner":"Nico","current_audience":["Nico","Player"]};var p=P.new();if not p.initialize(s,{}, {},[],[]):return false
	p.start_day();p.commit_narrative_time(686);p.confirm_transition();_present(p);p.apply_choice("thread_nico_private","choice_j20_cover_alibi");p.commit_narrative_time(1360);p.confirm_transition()
	return p.phase=="complete" and s.j20_nico_position=="DISTANCE" and s.j20_meeting_outcome=="NOT_OFFERED" and s.final_trace_id=="j13_nico_alibi_or_hour_message_01" and s.final_trace_state=="RESTRICTED"
