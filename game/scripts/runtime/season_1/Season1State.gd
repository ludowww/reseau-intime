extends RefCounted

class_name Season1State

const SNAPSHOT_VERSION := 4

var current_day := "J01"
var day_status := "ACTIVE"
var couple_state := "BASELINE_SHARED_LIFE"
var sandra_state := "DISTANT_FRIEND"
var promises: Dictionary = {}
var traces: Dictionary = {}
var knowledge: Dictionary = {}
var completed_conversation_ids: Array[String] = []
var selected_choice_ids: Array[String] = []
var foreground_history: Array[Dictionary] = []
var marie_make_room_outcome := ""
var mathilde_welcome_outcome := ""
var raphaelle_state := "UN" + "ESTAB" + "LISHED"
var raphaelle_work_outcome := ""
var sandra_j03_echo_outcome := ""
var marie_j03_return_outcome := ""
var mathilde_state := "UNESTABLISHED"
var pauline_state := "UNESTABLISHED"
var nico_state := "UNESTABLISHED"
var pauline_public_selection_outcome := "UNESTABLISHED"
var pauline_retained_frame := "UNESTABLISHED"
var nico_friendship_outcome := "UNESTABLISHED"
var opening_band_complete := false
var household_rhythm_confirmed := false
var marie_j05_shared_hour_outcome := "UNESTABLISHED"
var marie_j05_shared_hour_resolution := "UNESTABLISHED"
var sandra_j05_outcome := "UNESTABLISHED"
var mathilde_j06_outcome := "UNESTABLISHED"
var j06_external_continuity_resolution := "UNESTABLISHED"
var marie_j06_return_outcome := "UNESTABLISHED"
var marie_j06_return_due_at := ""

func _init() -> void:
	reset()

func reset() -> void:
	current_day = "J01"
	day_status = "ACTIVE"
	couple_state = "BASELINE_SHARED_LIFE"
	sandra_state = "DISTANT_FRIEND"
	promises = {
		"marie_j01_shared_evening": {
			"promise_id": "marie_j01_shared_evening",
			"promise_type": "PRESENCE",
			"status": "PROPOSED",
			"accepted_by_player": false,
			"outcome": "",
		},
	}
	traces = {}
	knowledge = {
		"fact_marie_player_couple_exists": {
			"fact_id": "fact_marie_player_couple_exists",
			"certainty": "CONFIRMED",
		},
		"fact_sandra_preexisting_friendship": {
			"fact_id": "fact_sandra_preexisting_friendship",
			"certainty": "CONFIRMED",
		},
	}
	completed_conversation_ids = []
	selected_choice_ids = []
	foreground_history = []
	marie_make_room_outcome = ""
	mathilde_welcome_outcome = ""
	raphaelle_state = "UN" + "ESTAB" + "LISHED"
	raphaelle_work_outcome = ""
	sandra_j03_echo_outcome = ""
	marie_j03_return_outcome = ""
	mathilde_state = "UNESTABLISHED"
	pauline_state = "UNESTABLISHED"
	nico_state = "UNESTABLISHED"
	pauline_public_selection_outcome = "UNESTABLISHED"
	pauline_retained_frame = "UNESTABLISHED"
	nico_friendship_outcome = "UNESTABLISHED"
	opening_band_complete = false
	household_rhythm_confirmed = false
	marie_j05_shared_hour_outcome = "UNESTABLISHED"
	marie_j05_shared_hour_resolution = "UNESTABLISHED"
	sandra_j05_outcome = "UNESTABLISHED"
	mathilde_j06_outcome = "UNESTABLISHED"
	j06_external_continuity_resolution = "UNESTABLISHED"
	marie_j06_return_outcome = "UNESTABLISHED"
	marie_j06_return_due_at = ""

func apply_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	selected_choice_ids.append(choice_id)
	var promise: Dictionary = promises["marie_j01_shared_evening"]
	match choice_id:
		"choice_j1_marie_present":
			promise["status"] = "ACTIVE"
			promise["accepted_by_player"] = true
			promise["outcome"] = "PRESENT"
		"choice_j1_marie_playful_present":
			promise["status"] = "ACTIVE"
			promise["accepted_by_player"] = true
			promise["outcome"] = "PLAYFUL_PRESENT"
		"choice_j1_marie_delayed_flat":
			promise["status"] = "AMENDED"
			promise["accepted_by_player"] = true
			promise["outcome"] = "DELAYED"
		"choice_j1_sandra_safe_warmth", "choice_j1_sandra_precise_observation":
			sandra_state = "RECONNECTION_OPEN"
		"choice_j1_sandra_cautious":
			sandra_state = "DISTANT_FRIEND"
	promises["marie_j01_shared_evening"] = promise
	return true

func open_j02_make_room_choice() -> bool:
	if promises.has("mathilde_j02_arrival_help"):
		return false
	promises["mathilde_j02_arrival_help"] = {
		"promise_id": "mathilde_j02_arrival_help", "promise_type": "DEPARTURE_SUPPORT",
		"created_by": "Marie", "proposed_to": "Player", "status": "PROPOSED",
		"accepted_by_player": false, "outcome": "",
	}
	return true

func apply_j02_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	selected_choice_ids.append(choice_id)
	if choice_id == "choice_wed_marie_emergency_guided":
		return true
	var promise: Dictionary = promises.get("mathilde_j02_arrival_help", {})
	match choice_id:
		"choice_wed_make_room_proactive":
			marie_make_room_outcome = "PROACTIVE"
			promise["status"] = "ACTIVE"; promise["accepted_by_player"] = true; promise["outcome"] = "PROACTIVE"
		"choice_wed_make_room_playful":
			marie_make_room_outcome = "BOUNDED"
			promise["status"] = "ACTIVE"; promise["accepted_by_player"] = true; promise["outcome"] = "BOUNDED"
		"choice_wed_make_room_passive":
			marie_make_room_outcome = "PASSIVE_ASSENT"
			promise["accepted_by_player"] = false; promise["outcome"] = "PASSIVE_ASSENT"
		"choice_wed_mathilde_practical":
			mathilde_welcome_outcome = "PRACTICAL"; _settle_j02_promise(promise, false)
		"choice_wed_mathilde_playful":
			mathilde_welcome_outcome = "PLAYFUL"; _settle_j02_promise(promise, false)
		"choice_wed_mathilde_distant":
			mathilde_welcome_outcome = "DISTANT"; _settle_j02_promise(promise, true)
	promises["mathilde_j02_arrival_help"] = promise
	return true

func _settle_j02_promise(promise: Dictionary, distant: bool) -> void:
	var status := str(promise.get("status", ""))
	if status in ["PAID", "FAILED", "REFUSED"]:
		return
	if distant:
		promise["status"] = "FAILED" if status == "ACTIVE" else "REFUSED"
		return
	if status == "PROPOSED":
		promise["status"] = "ACTIVE"
		promise["accepted_by_player"] = true
	promise["status"] = "PAID"

func begin_j02() -> void:
	current_day = "J02"
	day_status = "ACTIVE"

func begin_j03() -> void:
	current_day = "J03"
	day_status = "ACTIVE"

func begin_j04() -> void:
	current_day = "J04"
	day_status = "ACTIVE"

func begin_j05() -> void:
	current_day = "J05"
	day_status = "ACTIVE"

func begin_j06() -> void:
	current_day = "J06"
	day_status = "ACTIVE"

func is_mathilde_j06_eligible() -> bool:
	if current_day not in ["J05", "J06"] or day_status == "COMPLETE" and current_day == "J06":
		return false
	if mathilde_j06_outcome != "UNESTABLISHED" or j06_external_continuity_resolution != "UNESTABLISHED":
		return false
	if mathilde_state not in ["FAMILY_GUEST", "DOMESTIC_FAMILIARITY"]:
		return false
	var stay: Dictionary = knowledge.get("fact_mathilde_stay_started", {})
	if stay.is_empty() or str(stay.get("certainty", "")) != "CONFIRMED":
		return false
	var installation: Dictionary = traces.get("j02_mathilde_arrival_room_01", {})
	return not installation.is_empty() and str(installation.get("current_state", "")) == "ACTIVE"

func apply_j06_mathilde_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id) or not is_mathilde_j06_eligible():
		return false
	if choice_id == "choice_sun_mathilde_what_guided":
		selected_choice_ids.append(choice_id)
		return true
	var outcome := ""
	match choice_id:
		"choice_sun_mathilde_acknowledge_gaze":
			outcome = "ACKNOWLEDGED_RESPECTFUL"
		"choice_sun_mathilde_playful_gaze":
			outcome = "ACKNOWLEDGED_PLAYFUL"
		"choice_sun_mathilde_restore_distance":
			outcome = "DISTANCE_RESTORED"
		_:
			return false
	if not selected_choice_ids.has("choice_sun_mathilde_what_guided"):
		return false
	if traces.has("j06_mathilde_look_acknowledged_01") or knowledge.has("fact_mathilde_knows_player_noticed_her"):
		return false
	selected_choice_ids.append(choice_id)
	mathilde_j06_outcome = outcome
	j06_external_continuity_resolution = "NO_PROMISE"
	if outcome in ["ACKNOWLEDGED_RESPECTFUL", "ACKNOWLEDGED_PLAYFUL"]:
		mathilde_state = "LOOK_ACKNOWLEDGED"
	_establish_j06_mathilde_records()
	return true

func _establish_j06_mathilde_records() -> void:
	traces["j06_mathilde_look_acknowledged_01"] = {
		"trace_id": "j06_mathilde_look_acknowledged_01",
		"trace_type": "TEXT_MESSAGE",
		"source_day": "J06",
		"source_scene": "tenue domestique ordinaire / regard remarqué",
		"creator": "Mathilde et Player par messages",
		"subjects": ["Mathilde", "Player"],
		"owner": "fil Player / Mathilde",
		"initial_audience": ["Mathilde", "Player"],
		"current_audience": ["Mathilde", "Player"],
		"storage_location": "fil Player / Mathilde",
		"saving_rule": "IN_THREAD_ONLY",
		"transfer_rule": "FORBIDDEN",
		"current_state": "ACTIVE",
		"eligible_for_j14": true,
		"eligible_for_j21": false,
	}
	knowledge["fact_mathilde_knows_player_noticed_her"] = {
		"fact_id": "fact_mathilde_knows_player_noticed_her",
		"source_type": "DIRECT_MESSAGE",
		"source_ref": "j06_mathilde_look_acknowledged_01",
		"initial_knowers": ["Mathilde", "Player"],
		"certainty": "CONFIRMED",
		"shareability": "PRIVATE_DO_NOT_SHARE",
	}

func record_j06_mathilde_unavailable() -> bool:
	if mathilde_j06_outcome != "UNESTABLISHED" or is_mathilde_j06_eligible():
		return false
	mathilde_j06_outcome = "UNAVAILABLE"
	j06_external_continuity_resolution = "UNAVAILABLE"
	return true

func record_j06_mathilde_expired() -> bool:
	if mathilde_j06_outcome != "UNESTABLISHED" or not is_mathilde_j06_eligible():
		return false
	mathilde_j06_outcome = "EXPIRED"
	j06_external_continuity_resolution = "EXPIRED"
	return true

func apply_j06_marie_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id) or marie_j06_return_outcome != "UNESTABLISHED":
		return false
	var outcome := ""
	var due_at := ""
	match choice_id:
		"choice_sun_marie_warm_echo_guided":
			if marie_j05_shared_hour_resolution != "PAID" or mathilde_j06_outcome not in ["UNAVAILABLE", "EXPIRED"]:
				return false
			outcome = "WARM_ECHO"
		"choice_sun_marie_return_immediate":
			outcome = "IMMEDIATE_ACT"
		"choice_sun_marie_return_bounded":
			outcome = "BOUNDED_NEXT_ACT"
			due_at = "J07 09:30"
		"choice_sun_marie_return_honest_drift":
			outcome = "HONEST_DRIFT"
		_:
			return false
	if outcome != "WARM_ECHO" and mathilde_j06_outcome in ["UNAVAILABLE", "EXPIRED"] and marie_j05_shared_hour_resolution == "PAID":
		return false
	selected_choice_ids.append(choice_id)
	marie_j06_return_outcome = outcome
	marie_j06_return_due_at = due_at
	return true

func complete_j06() -> bool:
	if current_day != "J06" or day_status != "ACTIVE":
		return false
	if mathilde_j06_outcome == "UNESTABLISHED" or j06_external_continuity_resolution == "UNESTABLISHED":
		return false
	if marie_j06_return_outcome == "UNESTABLISHED":
		return false
	return complete_day()

func apply_j05_marie_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id) or marie_j05_shared_hour_outcome != "UNESTABLISHED":
		return false
	var outcome := ""
	var status := ""
	var due_at := ""
	match choice_id:
		"choice_sat_marie_join_now":
			outcome = "JOIN_NOW"
			status = "ACTIVE"
			due_at = "J05 09:48"
		"choice_sat_marie_bounded_alternative":
			outcome = "PRECISE_ALTERNATIVE"
			status = "AMENDED"
			due_at = "J05 12:30"
		"choice_sat_marie_moves_independently":
			outcome = "REFUSED"
		_:
			return false
	selected_choice_ids.append(choice_id)
	marie_j05_shared_hour_outcome = outcome
	if outcome != "REFUSED":
		promises["marie_j05_shared_hour"] = {
			"promise_id": "marie_j05_shared_hour",
			"promise_type": "MEETING",
			"created_at": "J05 09:36",
			"created_by": "Marie",
			"proposed_to": "Player",
			"accepted_at": "J05 09:36",
			"accepted_by_player": true,
			"due_at": due_at,
			"status": status,
			"outcome": outcome,
			"related_trace_ids": [],
		}
	return true

func resolve_j05_marie_hour() -> bool:
	if marie_j05_shared_hour_outcome == "UNESTABLISHED" or marie_j05_shared_hour_resolution != "UNESTABLISHED":
		return false
	if marie_j05_shared_hour_outcome == "REFUSED":
		if promises.has("marie_j05_shared_hour"):
			return false
		marie_j05_shared_hour_resolution = "NO_PROMISE"
		return true
	var promise: Dictionary = promises.get("marie_j05_shared_hour", {})
	if promise.is_empty() or str(promise.get("status", "")) not in ["ACTIVE", "AMENDED"]:
		return false
	promise["status"] = "PAID"
	promises["marie_j05_shared_hour"] = promise
	marie_j05_shared_hour_resolution = "PAID"
	return true

func is_sandra_j05_eligible() -> bool:
	if marie_j05_shared_hour_outcome not in ["JOIN_NOW", "PRECISE_ALTERNATIVE"]:
		return false
	if marie_j05_shared_hour_resolution != "PAID" or sandra_state != "RECONNECTION_OPEN":
		return false
	if sandra_j05_outcome != "UNESTABLISHED":
		return false
	var trace: Dictionary = traces.get("j01_sandra_lunch_memory_soft", {})
	return not trace.is_empty() and str(trace.get("current_state", "")) == "ACTIVE"

func apply_j05_sandra_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id) or sandra_j05_outcome != "UNESTABLISHED":
		return false
	if not is_sandra_j05_eligible():
		return false
	var is_followup := choice_id in ["choice_sat_sandra_back_down", "choice_sat_sandra_insist"]
	if is_followup != selected_choice_ids.has("choice_sat_sandra_more"):
		return false
	var outcome := ""
	match choice_id:
		"choice_sat_sandra_keep":
			outcome = "THREAD_MAINTAINED"
		"choice_sat_sandra_gap":
			outcome = "GAP_ACKNOWLEDGED"
		"choice_sat_sandra_autonomy":
			outcome = "BOUNDARY_RESPECTED"
		"choice_sat_sandra_more":
			selected_choice_ids.append(choice_id)
			return true
		"choice_sat_sandra_back_down":
			outcome = "CONTINUITY_COOLED"
		"choice_sat_sandra_insist":
			outcome = "CONTINUITY_CLOSED"
		_:
			return false
	selected_choice_ids.append(choice_id)
	sandra_j05_outcome = outcome
	return true

func record_sandra_j05_unavailable() -> bool:
	if sandra_j05_outcome != "UNESTABLISHED" or marie_j05_shared_hour_resolution == "UNESTABLISHED":
		return false
	if is_sandra_j05_eligible():
		return false
	sandra_j05_outcome = "UNAVAILABLE"
	return true

func apply_j04_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id): return false
	match choice_id:
		"choice_friday_pauline_contract_guided", "choice_friday_nico_reservation_guided", "choice_friday_nico_mathilde_guided": pass
		"choice_friday_pauline_practical": pauline_public_selection_outcome = "FRAME_02_SELECTED"; pauline_retained_frame = "FRAME_02"
		"choice_friday_pauline_dry": pauline_public_selection_outcome = "FRAME_03_REQUESTED"; pauline_retained_frame = "FRAME_02"
		"choice_friday_pauline_defer": pauline_public_selection_outcome = "DEFERRED_TO_MARIE"; pauline_retained_frame = "UNESTABLISHED"
		"choice_friday_nico_playful": nico_friendship_outcome = "PLAYFUL"
		"choice_friday_nico_honest": nico_friendship_outcome = "HONEST"
		"choice_friday_nico_home": nico_friendship_outcome = "RETURN_TO_MARIE"
		_: return false
	selected_choice_ids.append(choice_id)
	return true

func establish_j04_pauline_records() -> bool:
	if traces.has("j04_pauline_bastien_public_set_01"): return false
	pauline_state = "PUBLIC_ONLY"
	traces["j04_pauline_bastien_public_set_01"] = {
		"trace_id": "j04_pauline_bastien_public_set_01", "trace_type": "PHOTO_SET", "source_day": "J04",
		"creator": "Pauline via retardateur", "subjects": ["Pauline", "Bastien", "Marie"], "owner": "Pauline",
		"initial_audience": ["Pauline", "Bastien", "Marie", "Player"], "current_audience": ["Pauline", "Bastien", "Marie", "Player"],
		"saving_rule": "PUBLIC_SOURCE_RULES", "transfer_rule": "PUBLIC_SOURCE_RULES", "current_state": "PUBLIC_ACTIVE",
		"eligible_for_j14": false, "eligible_for_j21": true,
	}
	knowledge["fact_pauline_bastien_couple_public"] = {"fact_id": "fact_pauline_bastien_couple_public", "source_type": "PUBLIC_TRACE", "source_ref": "j04_pauline_bastien_public_set_01", "certainty": "CONFIRMED", "initial_knowers": ["Pauline", "Bastien", "Marie", "Player"]}
	return true

func establish_j04_nico_records() -> bool:
	if knowledge.has("fact_nico_friendship_exists"): return false
	nico_state = "ORDINARY_FRIEND"
	knowledge["fact_nico_friendship_exists"] = {"fact_id": "fact_nico_friendship_exists", "source_type": "DIRECT_MESSAGE", "source_ref": "chapter_04_nico_saved_seat_followup", "certainty": "CONFIRMED", "initial_knowers": ["Nico", "Player"]}
	var stay: Dictionary = knowledge.get("fact_mathilde_stay_started", {})
	var current_knowers: Array = stay.get("current_knowers", stay.get("initial_knowers", [])).duplicate()
	if not current_knowers.has("Nico"): current_knowers.append("Nico")
	stay["current_knowers"] = current_knowers
	var acquisitions: Dictionary = stay.get("knowledge_acquisitions", {}).duplicate(true)
	acquisitions["Nico"] = {"source": "Marie", "source_day": "J04", "source_ref": "msg_friday_nico_mathilde_001"}
	stay["knowledge_acquisitions"] = acquisitions
	knowledge["fact_mathilde_stay_started"] = stay
	return true

func complete_j04_household() -> void:
	mathilde_state = "FAMILY_GUEST"
	opening_band_complete = true
	household_rhythm_confirmed = true

func apply_j03_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	selected_choice_ids.append(choice_id)
	match choice_id:
		"choice_thu_raph_method_guided", "choice_j3_marie_evening_why_guided": pass
		"choice_thu_raph_accountable": raphaelle_state = "PROFESSIONAL_ONLY"; raphaelle_work_outcome = "ACCOUNTABLE"
		"choice_thu_raph_playful": raphaelle_state = "PROFESSIONAL_ONLY"; raphaelle_work_outcome = "DRY_HUMOR"
		"choice_thu_raph_delay": raphaelle_state = "PROFESSIONAL_ONLY"; raphaelle_work_outcome = "DELAYED"
		"choice_thu_sandra_day_saved": sandra_j03_echo_outcome = "RESPONDED"
		"choice_j3_marie_return_active": marie_j03_return_outcome = "ACTIVE"
		"choice_j3_marie_return_bounded": marie_j03_return_outcome = "BOUNDED"
		"choice_j3_marie_return_drift": marie_j03_return_outcome = "DRIFT"
		_:
			selected_choice_ids.erase(choice_id)
			return false
	return true

func establish_raphaelle_fact() -> bool:
	if knowledge.has("fact_raphaelle_professional_relationship_exists"): return false
	knowledge["fact_raphaelle_professional_relationship_exists"] = {
		"fact_id": "fact_raphaelle_professional_relationship_exists", "source_type": "DIRECT_OBSERVATION",
		"source_ref": "chapter_03_raphaelle_blue_folder", "certainty": "CONFIRMED", "initial_knowers": ["Player", "Raphaëlle"],
	}
	return true

func set_sandra_j03_echo_outcome(value: String) -> bool:
	if value not in ["UNAVAILABLE", "EXPIRED"] or sandra_j03_echo_outcome != "": return false
	sandra_j03_echo_outcome = value
	return true

func establish_marie_j03_records() -> bool:
	if traces.has("j03_marie_laverriere_setup_01"): return false
	traces["j03_marie_laverriere_setup_01"] = {
		"trace_id": "j03_marie_laverriere_setup_01", "trace_type": "FACT_RECORD", "source_day": "J03",
		"source_scene": "vie professionnelle Marie établie", "creator": "none", "subjects": ["Marie"],
		"owner": "état narratif La Verrière", "saving_rule": "NONE", "transfer_rule": "FORBIDDEN", "current_state": "ACTIVE",
	}
	knowledge["fact_marie_laverriere_world_exists"] = {
		"fact_id": "fact_marie_laverriere_world_exists", "source_type": "DIRECT_OBSERVATION",
		"source_ref": "j03_marie_laverriere_setup_01", "certainty": "CONFIRMED", "initial_knowers": ["Marie", "Player"],
	}
	return true

func install_mathilde() -> bool:
	if traces.has("j02_mathilde_arrival_room_01"):
		return false
	traces["j02_mathilde_arrival_room_01"] = {
		"trace_id": "j02_mathilde_arrival_room_01", "trace_type": "FACT_RECORD", "source_day": "J02",
		"source_scene": "installation de Mathilde", "creator": "none", "subjects": ["Mathilde", "foyer"],
		"owner": "état narratif du foyer", "saving_rule": "NONE", "transfer_rule": "FORBIDDEN", "current_state": "ACTIVE",
	}
	knowledge["fact_mathilde_stay_started"] = {
		"fact_id": "fact_mathilde_stay_started", "source_ref": "j02_mathilde_arrival_room_01",
		"certainty": "CONFIRMED", "initial_knowers": ["Marie", "Player", "Mathilde"],
		"current_knowers": ["Marie", "Player", "Mathilde"], "knowledge_acquisitions": {},
	}
	mathilde_state = "FAMILY_GUEST"
	return true

func activate_sandra_trace() -> bool:
	if traces.has("j01_sandra_lunch_memory_soft"):
		return false
	traces["j01_sandra_lunch_memory_soft"] = {
		"trace_id": "j01_sandra_lunch_memory_soft",
		"trace_type": "PHOTO",
		"owner": "Sandra",
		"initial_audience": ["Sandra", "Player"],
		"current_audience": ["Sandra", "Player"],
		"saving_rule": "IN_THREAD_ONLY",
		"transfer_rule": "FORBIDDEN",
		"current_state": "ACTIVE",
	}
	return true

func observe_sandra_photo() -> bool:
	if knowledge.has("fact_player_saw_sandra_lunch_photo"):
		return false
	var trace: Dictionary = traces.get("j01_sandra_lunch_memory_soft", {})
	if trace.is_empty() or str(trace.get("current_state", "")) != "ACTIVE":
		return false
	knowledge["fact_player_saw_sandra_lunch_photo"] = {
		"fact_id": "fact_player_saw_sandra_lunch_photo",
		"source_type": "PRIVATE_TRACE",
		"source_ref": "j01_sandra_lunch_memory_soft",
		"certainty": "OBSERVED",
		"shareability": "PRIVATE_DO_NOT_SHARE",
	}
	return true

func pay_marie_promise() -> bool:
	var promise: Dictionary = promises.get("marie_j01_shared_evening", {})
	if promise.is_empty() or str(promise.get("status", "")) not in ["ACTIVE", "AMENDED"]:
		return false
	promise["status"] = "PAID"
	promises["marie_j01_shared_evening"] = promise
	return true

func complete_conversation(conversation_id: String, character_id: String) -> bool:
	if conversation_id == "" or completed_conversation_ids.has(conversation_id):
		return false
	completed_conversation_ids.append(conversation_id)
	foreground_history.append({"day_id": current_day, "character_id": character_id, "function": "foreground"})
	return true

func complete_day() -> bool:
	if day_status == "COMPLETE":
		return false
	day_status = "COMPLETE"
	return true

func snapshot() -> Dictionary:
	return {
		"version": SNAPSHOT_VERSION,
		"current_day": current_day,
		"day_status": day_status,
		"couple_state": couple_state,
		"sandra_state": sandra_state,
		"promises": promises.duplicate(true),
		"traces": traces.duplicate(true),
		"knowledge": knowledge.duplicate(true),
		"completed_conversation_ids": completed_conversation_ids.duplicate(),
		"selected_choice_ids": selected_choice_ids.duplicate(),
		"foreground_history": foreground_history.duplicate(true),
		"marie_make_room_outcome": marie_make_room_outcome,
		"mathilde_welcome_outcome": mathilde_welcome_outcome,
		"raphaelle_state": raphaelle_state,
		"raphaelle_work_outcome": raphaelle_work_outcome,
		"sandra_j03_echo_outcome": sandra_j03_echo_outcome,
		"marie_j03_return_outcome": marie_j03_return_outcome,
		"mathilde_state": mathilde_state,
		"pauline_state": pauline_state,
		"nico_state": nico_state,
		"pauline_public_selection_outcome": pauline_public_selection_outcome,
		"pauline_retained_frame": pauline_retained_frame,
		"nico_friendship_outcome": nico_friendship_outcome,
		"opening_band_complete": opening_band_complete,
		"household_rhythm_confirmed": household_rhythm_confirmed,
		"marie_j05_shared_hour_outcome": marie_j05_shared_hour_outcome,
		"marie_j05_shared_hour_resolution": marie_j05_shared_hour_resolution,
		"sandra_j05_outcome": sandra_j05_outcome,
		"mathilde_j06_outcome": mathilde_j06_outcome,
		"j06_external_continuity_resolution": j06_external_continuity_resolution,
		"marie_j06_return_outcome": marie_j06_return_outcome,
		"marie_j06_return_due_at": marie_j06_return_due_at,
	}

func restore_snapshot(value: Dictionary) -> bool:
	var version := int(value.get("version", -1))
	if version not in [1, 2, 3, SNAPSHOT_VERSION]:
		return false
	if str(value.get("current_day", "")) not in ["J01", "J02", "J03", "J04", "J05", "J06"]:
		return false
	if version < SNAPSHOT_VERSION and str(value.get("current_day", "")) == "J06":
		return false
	if str(value.get("day_status", "")) not in ["ACTIVE", "COMPLETE"]:
		return false
	if str(value.get("couple_state", "")) != "BASELINE_SHARED_LIFE":
		return false
	if str(value.get("sandra_state", "")) not in ["DISTANT_FRIEND", "RECONNECTION_OPEN"]:
		return false
	if str(value.get("raphaelle_state", "")) not in ["UN" + "ESTAB" + "LISHED", "PROFESSIONAL_ONLY"]: return false
	if str(value.get("raphaelle_work_outcome", "")) not in ["", "ACCOUNTABLE", "DRY_HUMOR", "DELAYED"]: return false
	if str(value.get("sandra_j03_echo_outcome", "")) not in ["", "UNAVAILABLE", "EXPIRED", "RESPONDED"]: return false
	if str(value.get("marie_j03_return_outcome", "")) not in ["", "ACTIVE", "BOUNDED", "DRIFT"]: return false
	if str(value.get("mathilde_state", "FAMILY_GUEST" if value.get("knowledge", {}).has("fact_mathilde_stay_started") else "UNESTABLISHED")) not in ["UNESTABLISHED", "FAMILY_GUEST", "DOMESTIC_FAMILIARITY", "LOOK_ACKNOWLEDGED", "DISTANCE", "TRUST_BROKEN"]: return false
	if str(value.get("pauline_state", "UNESTABLISHED")) not in ["UNESTABLISHED", "PUBLIC_ONLY"]: return false
	if str(value.get("nico_state", "UNESTABLISHED")) not in ["UNESTABLISHED", "ORDINARY_FRIEND"]: return false
	var pauline_outcome := str(value.get("pauline_public_selection_outcome", "UNESTABLISHED"))
	if pauline_outcome not in ["UNESTABLISHED", "FRAME_02_SELECTED", "FRAME_03_REQUESTED", "DEFERRED_TO_MARIE"]: return false
	if str(value.get("pauline_retained_frame", _default_pauline_retained_frame(pauline_outcome))) != _default_pauline_retained_frame(pauline_outcome): return false
	if str(value.get("nico_friendship_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "PLAYFUL", "HONEST", "RETURN_TO_MARIE"]: return false
	if str(value.get("marie_j05_shared_hour_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "JOIN_NOW", "PRECISE_ALTERNATIVE", "REFUSED"]: return false
	if str(value.get("marie_j05_shared_hour_resolution", "UNESTABLISHED")) not in ["UNESTABLISHED", "PAID", "NO_PROMISE"]: return false
	if str(value.get("sandra_j05_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "UNAVAILABLE", "THREAD_MAINTAINED", "GAP_ACKNOWLEDGED", "BOUNDARY_RESPECTED", "CONTINUITY_COOLED", "CONTINUITY_CLOSED"]: return false
	if str(value.get("mathilde_j06_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "UNAVAILABLE", "ACKNOWLEDGED_RESPECTFUL", "ACKNOWLEDGED_PLAYFUL", "DISTANCE_RESTORED", "EXPIRED"]: return false
	if str(value.get("j06_external_continuity_resolution", "UNESTABLISHED")) not in ["UNESTABLISHED", "PAID", "REFUSED", "EXPIRED", "UNAVAILABLE", "NO_PROMISE"]: return false
	if str(value.get("marie_j06_return_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "WARM_ECHO", "IMMEDIATE_ACT", "BOUNDED_NEXT_ACT", "HONEST_DRIFT"]: return false
	if str(value.get("marie_j06_return_due_at", "")) not in ["", "J07 09:30"]: return false
	for key in ["promises", "traces", "knowledge"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY:
			return false
	for key in ["completed_conversation_ids", "selected_choice_ids", "foreground_history"]:
		if typeof(value.get(key)) != TYPE_ARRAY:
			return false
	if not _j05_snapshot_consistent(value):
		return false
	if not _j06_snapshot_consistent(value):
		return false
	current_day = str(value["current_day"])
	day_status = str(value["day_status"])
	couple_state = str(value["couple_state"])
	sandra_state = str(value["sandra_state"])
	promises = value["promises"].duplicate(true)
	traces = value["traces"].duplicate(true)
	knowledge = value["knowledge"].duplicate(true)
	completed_conversation_ids.assign(value["completed_conversation_ids"])
	selected_choice_ids.assign(value["selected_choice_ids"])
	foreground_history.assign(value["foreground_history"])
	marie_make_room_outcome = str(value.get("marie_make_room_outcome", ""))
	mathilde_welcome_outcome = str(value.get("mathilde_welcome_outcome", ""))
	raphaelle_state = str(value.get("raphaelle_state", "UN" + "ESTAB" + "LISHED"))
	raphaelle_work_outcome = str(value.get("raphaelle_work_outcome", ""))
	sandra_j03_echo_outcome = str(value.get("sandra_j03_echo_outcome", ""))
	marie_j03_return_outcome = str(value.get("marie_j03_return_outcome", ""))
	mathilde_state = str(value.get("mathilde_state", "FAMILY_GUEST" if knowledge.has("fact_mathilde_stay_started") else "UNESTABLISHED"))
	pauline_state = str(value.get("pauline_state", "UNESTABLISHED"))
	nico_state = str(value.get("nico_state", "UNESTABLISHED"))
	pauline_public_selection_outcome = str(value.get("pauline_public_selection_outcome", "UNESTABLISHED"))
	pauline_retained_frame = str(value.get("pauline_retained_frame", _default_pauline_retained_frame(pauline_public_selection_outcome)))
	nico_friendship_outcome = str(value.get("nico_friendship_outcome", "UNESTABLISHED"))
	opening_band_complete = bool(value.get("opening_band_complete", false))
	household_rhythm_confirmed = bool(value.get("household_rhythm_confirmed", false))
	marie_j05_shared_hour_outcome = str(value.get("marie_j05_shared_hour_outcome", "UNESTABLISHED"))
	marie_j05_shared_hour_resolution = str(value.get("marie_j05_shared_hour_resolution", "UNESTABLISHED"))
	sandra_j05_outcome = str(value.get("sandra_j05_outcome", "UNESTABLISHED"))
	mathilde_j06_outcome = str(value.get("mathilde_j06_outcome", "UNESTABLISHED"))
	j06_external_continuity_resolution = str(value.get("j06_external_continuity_resolution", "UNESTABLISHED"))
	marie_j06_return_outcome = str(value.get("marie_j06_return_outcome", "UNESTABLISHED"))
	marie_j06_return_due_at = str(value.get("marie_j06_return_due_at", ""))
	return true

func _default_pauline_retained_frame(outcome: String) -> String:
	return "FRAME_02" if outcome in ["FRAME_02_SELECTED", "FRAME_03_REQUESTED"] else "UNESTABLISHED"

func _j05_snapshot_consistent(value: Dictionary) -> bool:
	var outcome := str(value.get("marie_j05_shared_hour_outcome", "UNESTABLISHED"))
	var resolution := str(value.get("marie_j05_shared_hour_resolution", "UNESTABLISHED"))
	var sandra_outcome := str(value.get("sandra_j05_outcome", "UNESTABLISHED"))
	var restored_promises: Dictionary = value.get("promises", {})
	var promise: Dictionary = restored_promises.get("marie_j05_shared_hour", {})
	if outcome == "UNESTABLISHED":
		return resolution == "UNESTABLISHED" and promise.is_empty() and sandra_outcome == "UNESTABLISHED"
	if outcome == "REFUSED":
		if not promise.is_empty() or resolution not in ["UNESTABLISHED", "NO_PROMISE"]:
			return false
	else:
		if promise.is_empty() or not bool(promise.get("accepted_by_player", false)):
			return false
		var expected_due := "J05 09:48" if outcome == "JOIN_NOW" else "J05 12:30"
		if str(promise.get("due_at", "")) != expected_due:
			return false
		var expected_status := "ACTIVE" if outcome == "JOIN_NOW" else "AMENDED"
		if resolution == "UNESTABLISHED" and str(promise.get("status", "")) != expected_status:
			return false
		if resolution == "PAID" and str(promise.get("status", "")) != "PAID":
			return false
		if resolution not in ["UNESTABLISHED", "PAID"]:
			return false
	if sandra_outcome not in ["UNESTABLISHED", "UNAVAILABLE"] and resolution != "PAID":
		return false
	if sandra_outcome == "UNAVAILABLE" and resolution == "UNESTABLISHED":
		return false
	return true

func _j06_snapshot_consistent(value: Dictionary) -> bool:
	var outcome := str(value.get("mathilde_j06_outcome", "UNESTABLISHED"))
	var resolution := str(value.get("j06_external_continuity_resolution", "UNESTABLISHED"))
	var marie_outcome := str(value.get("marie_j06_return_outcome", "UNESTABLISHED"))
	var due_at := str(value.get("marie_j06_return_due_at", ""))
	var restored_traces: Dictionary = value.get("traces", {})
	var restored_knowledge: Dictionary = value.get("knowledge", {})
	var restored_promises: Dictionary = value.get("promises", {})
	if restored_promises.has("j06_external_continuity_window"):
		return false
	var exchange_served := outcome in ["ACKNOWLEDGED_RESPECTFUL", "ACKNOWLEDGED_PLAYFUL", "DISTANCE_RESTORED"]
	if exchange_served != restored_traces.has("j06_mathilde_look_acknowledged_01"):
		return false
	if exchange_served != restored_knowledge.has("fact_mathilde_knows_player_noticed_her"):
		return false
	if outcome == "UNESTABLISHED" and resolution != "UNESTABLISHED":
		return false
	if exchange_served and resolution != "NO_PROMISE":
		return false
	if outcome in ["UNAVAILABLE", "EXPIRED"] and resolution != outcome:
		return false
	if marie_outcome == "BOUNDED_NEXT_ACT":
		return due_at == "J07 09:30"
	return due_at == ""
