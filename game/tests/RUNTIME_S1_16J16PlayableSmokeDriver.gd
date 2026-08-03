extends Node
const STATE:=preload("res://scripts/runtime/season_1/Season1State.gd")
const PROVIDER:=preload("res://scripts/runtime/season_1/J16RuntimeProvider.gd")
const TIME:=preload("res://scripts/runtime/season_1/NarrativeTime.gd")
var failures:Array[String]=[]
func _ready()->void:
	_exercise_priority(); _exercise_fallback()
	if failures.is_empty(): print("RUNTIME_S1_16_J16_PLAYABLE: OK"); get_tree().quit(0); return
	for failure in failures: push_error(failure)
	get_tree().quit(1)
func _exercise_priority()->void:
	var state=_completed_j15(true); var provider=_new_provider(state); _expect(provider.start_day().get("accepted",false) and provider.selected_pivot=="MARIE","urgent lie selects Marie")
	_confirm(provider); _present(provider,"thread_marie_private"); _round_trip(provider); provider.apply_choice("thread_marie_private","choice_j16_marie_restitute"); _confirm(provider); _present(provider,"thread_mathilde_private"); _confirm(provider); _present(provider,"thread_marie_private"); provider.apply_choice("thread_marie_private","choice_j16_j17_accept"); _confirm(provider)
	_expect(provider.phase=="complete","J16 completes"); _expect(str(state.promises["j16_priority_consequence_payment"].get("status",""))=="PAID","P17 paid"); _expect(state.promises.has("marie_j16_couple_conversation_j17"),"J17 discussion explicitly accepted"); _expect(not bool(state.traces["j16_consequence_payment_record_01"].get("urgent_consequence_remaining",true)),"T22 closes urgency")
func _exercise_fallback()->void:
	var state=_completed_j15(false); var provider=_new_provider(state); provider.start_day(); _expect(provider.selected_pivot=="FALLBACK","clean J15 selects priority 8"); _confirm(provider); _present(provider,"thread_marie_private"); provider.apply_choice("thread_marie_private","choice_j16_fallback_confirm"); _confirm(provider); _present(provider,"thread_mathilde_private"); _confirm(provider); _present(provider,"thread_marie_private"); provider.apply_choice("thread_marie_private","choice_j16_j17_refuse"); _confirm(provider)
	_expect(provider.phase=="complete" and not state.promises.has("marie_j16_couple_conversation_j17"),"fallback closes without invented J17 promise")
func _completed_j15(urgent:bool):
	var state=STATE.new(); state.current_day="J15"; state.day_status="ACTIVE"; state.j14_witness="Marie"; state.j15_mode="REPAIR" if urgent else "NO_OBLIGATION"
	_expect(state.apply_j15_choice("choice_j15_repair_lie_marie" if urgent else "choice_j15_clean_acknowledge_marie"),"fixture applies current J15 choice"); _expect(state.complete_j15(),"fixture completes J15"); return state
func _new_provider(state): var p=PROVIDER.new(); _expect(p.initialize(state,{}, {},[],[]),"provider initializes"); return p
func _present(p,thread:String)->void:
	for m in p.transcript_for(thread):
		if int(m.get("source_day",0))==16 and not bool(m.get("is_player",false)) and not p.presented_time_message_ids.has(str(m.get("message_id",""))): p.mark_message_presented(str(m.get("message_id","")))
	_expect(p.mark_thread_batch_presented(thread),"batch "+thread)
func _confirm(p)->void:
	var target=TIME.parse_narrative_time(str(p.pending_transition.get("to_time",""))); if target>=p.current_narrative_time_minutes(): p.commit_narrative_time(target)
	_expect(p.confirm_transition().get("accepted",false),"transition")
func _round_trip(p)->void: var snap=p.snapshot(); var restored=PROVIDER.new(); restored.initialize(p.state,{}, {},[],[]); _expect(restored.restore_snapshot(snap) and restored.snapshot()==snap,"snapshot round trip")
func _expect(ok:bool,label:String)->void:
	if not ok: failures.append(label)
