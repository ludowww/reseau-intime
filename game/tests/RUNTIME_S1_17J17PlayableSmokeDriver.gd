extends Node
const S:=preload("res://scripts/runtime/season_1/Season1State.gd")
const P:=preload("res://scripts/runtime/season_1/J17RuntimeProvider.gd")
const T:=preload("res://scripts/runtime/season_1/NarrativeTime.gd")
var f:Array[String]=[]
func _ready():
	var s=S.new();s.current_day="J16";s.day_status="COMPLETE";s.j16_departure_state="ORDINARY";s.j16_consequence_outcome="FALLBACK_CONFIRM";s.j16_j17_outcome="ACCEPT";s.promises["marie_j16_couple_conversation_j17"]={"status":"ACTIVE"};var p=P.new();_e(p.initialize(s,{}, {},[],[]),"init");p.start_day();_c(p);_present(p,"thread_mathilde_private");p.apply_choice("thread_mathilde_private","choice_j17_help");_c(p);_present(p,"thread_marie_private");p.apply_choice("thread_marie_private","choice_j17_provisional");_c(p);_e(p.phase=="complete","complete");_e(s.couple_state=="PROVISIONAL_AGREEMENT","couple");_e(s.knowledge.has("fact_mathilde_left_household"),"departure")
	if f.is_empty():print("RUNTIME_S1_17_J17_PLAYABLE: OK");get_tree().quit(0);return
	for x in f:push_error(x)
	get_tree().quit(1)
func _present(p,thread):
	for m in p.transcript_for(thread):
		if int(m.get("source_day",0))==17 and not m.get("is_player",false):p.mark_message_presented(str(m.message_id))
	_e(p.mark_thread_batch_presented(thread),"present")
func _c(p):var t=T.parse_narrative_time(str(p.pending_transition.get("to_time","")));if t>=p.current_narrative_time_minutes():p.commit_narrative_time(t);_e(p.confirm_transition().get("accepted",false),"transition")
func _e(v,label):
	if not v:f.append(label)
