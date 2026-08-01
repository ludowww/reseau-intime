extends Node
const S:=preload("res://scripts/runtime/season_1/Season1State.gd")
const P:=preload("res://scripts/runtime/season_1/J18RuntimeProvider.gd")
func _ready():
	var s=S.new();s.current_day="J17";s.day_status="COMPLETE";var p=P.new();if not p.initialize(s,{}, {},[],[]):get_tree().quit(1);return
	p.start_day();p.commit_narrative_time(1127);p.confirm_transition()
	var restored=P.new();if not restored.initialize(s,p.transcripts_by_thread,p.produced_message_ids,p.unlocked_thread_ids,p.gallery_asset_ids) or not restored.restore_snapshot(p.snapshot()):get_tree().quit(1);return
	for m in restored.transcript_for("thread_sandra_private"):restored.mark_message_presented(str(m.message_id))
	restored.mark_thread_batch_presented("thread_sandra_private");restored.apply_choice("thread_sandra_private","choice_j18_recognize_simple");restored.commit_narrative_time(1240);restored.confirm_transition()
	if restored.phase=="complete" and s.traces.has("j18_sandra_lunch_print_01") and s.knowledge.has("fact_sandra_kept_physical_lunch_trace"):print("RUNTIME_S1_18_J18_PLAYABLE: OK");get_tree().quit(0);return
	get_tree().quit(1)
