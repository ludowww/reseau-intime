extends RefCounted

class_name Season1State

const SNAPSHOT_VERSION := 6

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
var marie_j06_return_resolution := "UNESTABLISHED"
var raphaelle_j07_mobile_review_outcome := "UNESTABLISHED"
var nico_j07_confidence_outcome := "UNESTABLISHED"
var nico_j07_continuation_outcome := "UNESTABLISHED"
var marie_j07_household_outcome := "UNESTABLISHED"
var marie_j08_entry_outcome := "UNESTABLISHED"
var raphaelle_j08_preparation_outcome := "UNESTABLISHED"
var j08_priority_outcome := "UNESTABLISHED"
var raphaelle_j08_work_resolution := "UNESTABLISHED"
var nico_j08_meeting_resolution := "UNESTABLISHED"
var marie_j08_household_resolution := "UNESTABLISHED"
var mathilde_j08_household_resolution := "UNESTABLISHED"
var marie_j08_echo_outcome := "UNESTABLISHED"
var resolved_visual_variant_by_asset: Dictionary = {}

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
	marie_j06_return_resolution = "UNESTABLISHED"
	raphaelle_j07_mobile_review_outcome = "UNESTABLISHED"
	nico_j07_confidence_outcome = "UNESTABLISHED"
	nico_j07_continuation_outcome = "UNESTABLISHED"
	marie_j07_household_outcome = "UNESTABLISHED"
	marie_j08_entry_outcome = "UNESTABLISHED"
	raphaelle_j08_preparation_outcome = "UNESTABLISHED"
	j08_priority_outcome = "UNESTABLISHED"
	raphaelle_j08_work_resolution = "UNESTABLISHED"
	nico_j08_meeting_resolution = "UNESTABLISHED"
	marie_j08_household_resolution = "UNESTABLISHED"
	mathilde_j08_household_resolution = "UNESTABLISHED"
	marie_j08_echo_outcome = "UNESTABLISHED"
	resolved_visual_variant_by_asset = {}

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

func begin_j07() -> void:
	current_day = "J07"
	day_status = "ACTIVE"

func begin_j08() -> bool:
	if current_day != "J07" or day_status != "COMPLETE" or not _j07_records_consistent(snapshot()):
		return false
	var p05: Dictionary = promises.get("raphaelle_j07_mobile_review", {})
	var p08: Dictionary = promises.get("marie_j07_household_request", {})
	if str(p05.get("status", "")) != "ACTIVE" or str(p05.get("due_at", "")) != "J08 19:00":
		return false
	match str(p08.get("status", "")):
		"ACTIVE":
			if str(p08.get("due_at", "")) != "J08 19:15":
				return false
			marie_j08_entry_outcome = "STATE_A"
		"AMENDED":
			if str(p08.get("due_at", "")) != "J08 18:30":
				return false
			marie_j08_entry_outcome = "STATE_B"
		"REFUSED":
			if str(p08.get("due_at", "")) != "":
				return false
			marie_j08_entry_outcome = "STATE_C"
			marie_j08_household_resolution = "REFUSAL_ABSORBED"
			mathilde_j08_household_resolution = "RESCHEDULED_WEDNESDAY"
		_:
			return false
	current_day = "J08"
	day_status = "ACTIVE"
	if not is_j08_nico_due():
		nico_j08_meeting_resolution = "NOT_DUE"
	return true

func is_j08_nico_due() -> bool:
	var p06: Dictionary = promises.get("nico_j07_tuesday_1845", {})
	return str(p06.get("status", "")) == "ACTIVE" and str(p06.get("due_at", "")) == "J08 18:45"

func j08_active_obligation_ids() -> Array[String]:
	var result: Array[String] = []
	for promise_id in ["raphaelle_j07_mobile_review", "nico_j07_tuesday_1845", "marie_j07_household_request"]:
		var promise: Dictionary = promises.get(promise_id, {})
		if str(promise.get("status", "")) == "ACTIVE":
			result.append(promise_id)
	return result

func apply_j08_raphaelle_preparation(choice_id: String) -> bool:
	if current_day != "J08" or day_status != "ACTIVE" or raphaelle_j08_preparation_outcome != "UNESTABLISHED":
		return false
	if choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	match choice_id:
		"choice_j08_raphaelle_anticipate_now":
			raphaelle_j08_preparation_outcome = "ANTICIPATED"
		"choice_j08_raphaelle_schedule_1820":
			raphaelle_j08_preparation_outcome = "SCHEDULED_1820"
		"choice_j08_raphaelle_vague":
			raphaelle_j08_preparation_outcome = "VAGUE"
		_:
			return false
	selected_choice_ids.append(choice_id)
	return true

func resolve_j08_state_b_household() -> bool:
	if current_day != "J08" or marie_j08_entry_outcome != "STATE_B":
		return false
	if marie_j08_household_resolution != "UNESTABLISHED":
		return false
	var p08: Dictionary = promises.get("marie_j07_household_request", {})
	if str(p08.get("status", "")) != "AMENDED" or str(p08.get("due_at", "")) != "J08 18:30":
		return false
	p08["status"] = "PAID"
	p08["paid_or_closed_at"] = "J08 18:46"
	p08["paid_or_closed_by"] = "Player"
	promises["marie_j07_household_request"] = p08
	marie_j08_household_resolution = "PAID"
	mathilde_j08_household_resolution = "AIDED_BY_PLAYER"
	return true

func resolve_j08_single_obligation() -> bool:
	if current_day != "J08" or raphaelle_j08_preparation_outcome == "UNESTABLISHED":
		return false
	if j08_priority_outcome != "UNESTABLISHED" or j08_active_obligation_ids() != ["raphaelle_j07_mobile_review"]:
		return false
	j08_priority_outcome = "AUTO_P05_ONLY"
	_set_j08_promise_resolution("raphaelle_j07_mobile_review", "PAID", "J08 18:56", "Player")
	raphaelle_j08_work_resolution = "PAID_ON_TIME"
	_finalize_j08_household_echo()
	return true

func apply_j08_priority_choice(choice_id: String) -> bool:
	if current_day != "J08" or day_status != "ACTIVE" or raphaelle_j08_preparation_outcome == "UNESTABLISHED":
		return false
	if choice_id == "" or selected_choice_ids.has(choice_id) or j08_priority_outcome != "UNESTABLISHED":
		return false
	if j08_active_obligation_ids().size() < 2:
		return false
	match choice_id:
		"choice_j08_priority_oldest":
			j08_priority_outcome = "OLDEST_COMMITMENT"
			_resolve_j08_oldest()
		"choice_j08_priority_immediate":
			j08_priority_outcome = "IMMEDIATE_PRESENCE"
			_resolve_j08_immediate()
		"choice_j08_priority_vague":
			j08_priority_outcome = "UNCLEAR"
			_resolve_j08_vague()
		_:
			return false
	selected_choice_ids.append(choice_id)
	_finalize_j08_household_echo()
	return true

func _resolve_j08_oldest() -> void:
	var late := raphaelle_j08_preparation_outcome == "VAGUE"
	_set_j08_promise_resolution("raphaelle_j07_mobile_review", "PAID", "J08 19:06" if late else "J08 18:56", "Player")
	raphaelle_j08_work_resolution = "PAID_LATE" if late else "PAID_ON_TIME"
	if is_j08_nico_due():
		_set_j08_promise_resolution("nico_j07_tuesday_1845", "CANCELLED", "J08 18:31", "Player")
		nico_j08_meeting_resolution = "CANCELLED_HONESTLY"
	if marie_j08_entry_outcome == "STATE_A":
		if late:
			_set_j08_promise_resolution("marie_j07_household_request", "FAILED", "J08 18:51", "Mathilde et la voisine")
			marie_j08_household_resolution = "FAILED_LATE_AMENDMENT"
			mathilde_j08_household_resolution = "HANDLED_WITH_NEIGHBOR"
		else:
			_set_j08_promise_resolution("marie_j07_household_request", "PAID", "J08 19:20", "Player")
			marie_j08_household_resolution = "PAID"
			mathilde_j08_household_resolution = "AIDED_BY_PLAYER"

func _resolve_j08_immediate() -> void:
	_set_j08_promise_resolution("raphaelle_j07_mobile_review", "AMENDED", "", "Player")
	var p05: Dictionary = promises["raphaelle_j07_mobile_review"]
	p05["action_due"] = "Responsabilité professionnelle du point client"
	p05["due_at"] = "J09 09:00"
	promises["raphaelle_j07_mobile_review"] = p05
	raphaelle_j08_work_resolution = "TRANSFERRED_HONESTLY"
	if marie_j08_entry_outcome == "STATE_A":
		_set_j08_promise_resolution("marie_j07_household_request", "PAID", "J08 19:20", "Player")
		marie_j08_household_resolution = "PAID"
		mathilde_j08_household_resolution = "AIDED_BY_PLAYER"
		if is_j08_nico_due():
			_set_j08_promise_resolution("nico_j07_tuesday_1845", "CANCELLED", "J08 18:31", "Player")
			nico_j08_meeting_resolution = "CANCELLED_HONESTLY"
	elif is_j08_nico_due():
		_set_j08_promise_resolution("nico_j07_tuesday_1845", "PAID", "J08 18:58", "Player")
		nico_j08_meeting_resolution = "PAID_SHORT"

func _resolve_j08_vague() -> void:
	_set_j08_promise_resolution("raphaelle_j07_mobile_review", "FAILED", "J08 18:52", "Raphaëlle reprend sans réponse claire")
	raphaelle_j08_work_resolution = "ABANDONED_VAGUELY"
	if is_j08_nico_due():
		_set_j08_promise_resolution("nico_j07_tuesday_1845", "FAILED", "J08 18:51", "Nico")
		nico_j08_meeting_resolution = "FAILED_VAGUE"
	if marie_j08_entry_outcome == "STATE_A":
		_set_j08_promise_resolution("marie_j07_household_request", "FAILED", "J08 19:08", "Mathilde et la voisine")
		marie_j08_household_resolution = "FAILED_VAGUE"
		mathilde_j08_household_resolution = "HANDLED_WITH_NEIGHBOR"

func _set_j08_promise_resolution(promise_id: String, status: String, closed_at: String, closed_by: String) -> void:
	var promise: Dictionary = promises.get(promise_id, {})
	promise["status"] = status
	if closed_at != "":
		promise["paid_or_closed_at"] = closed_at
	else:
		promise.erase("paid_or_closed_at")
	if closed_by != "":
		promise["paid_or_closed_by"] = closed_by
	else:
		promise.erase("paid_or_closed_by")
	promises[promise_id] = promise

func _finalize_j08_household_echo() -> void:
	match marie_j08_household_resolution:
		"PAID":
			marie_j08_echo_outcome = "CLEAR_HOURS"
		"REFUSAL_ABSORBED":
			marie_j08_echo_outcome = "HONEST_REFUSAL"
		"FAILED_LATE_AMENDMENT", "FAILED_VAGUE":
			marie_j08_echo_outcome = "VAGUE_OR_MISSED"

func complete_j08() -> bool:
	if current_day != "J08" or day_status != "ACTIVE":
		return false
	if raphaelle_j08_preparation_outcome == "UNESTABLISHED" or j08_priority_outcome == "UNESTABLISHED":
		return false
	if raphaelle_j08_work_resolution == "UNESTABLISHED" or nico_j08_meeting_resolution == "UNESTABLISHED":
		return false
	if marie_j08_household_resolution == "UNESTABLISHED" or mathilde_j08_household_resolution == "UNESTABLISHED":
		return false
	if marie_j08_echo_outcome == "UNESTABLISHED" or not _j08_records_consistent(snapshot()):
		return false
	resolved_visual_variant_by_asset = {
		"S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01": "S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_PAID" if raphaelle_j08_work_resolution in ["PAID_ON_TIME", "PAID_LATE"] else "S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_TAKEN_OVER",
		"S1_A2_J08_SCN_NICO_CHAIR_STATE_01": "S1_A2_J08_SCN_NICO_CHAIR_STATE_01_PAID" if nico_j08_meeting_resolution == "PAID_SHORT" else "S1_A2_J08_SCN_NICO_CHAIR_STATE_01_NO_WAIT",
		"S1_A2_J08_SCN_HOUSEHOLD_STATE_01": "S1_A2_J08_SCN_HOUSEHOLD_STATE_01_PAID" if marie_j08_household_resolution == "PAID" else "S1_A2_J08_SCN_HOUSEHOLD_STATE_01_AUTONOMOUS",
	}
	return complete_day()

func resolve_j07_morning_consequence() -> bool:
	if current_day != "J07" or day_status != "ACTIVE" or marie_j06_return_resolution != "UNESTABLISHED":
		return false
	if marie_j06_return_outcome == "BOUNDED_NEXT_ACT" and marie_j06_return_due_at == "J07 09:30":
		marie_j06_return_resolution = "PAID"
	else:
		marie_j06_return_resolution = "NOT_DUE"
	return true

func apply_j07_raphaelle_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id) or current_day != "J07" or day_status != "ACTIVE":
		return false
	if choice_id == "choice_j07_raphaelle_acknowledge_guided":
		selected_choice_ids.append(choice_id)
		return true
	if choice_id != "choice_j07_raphaelle_understood_guided" or not selected_choice_ids.has("choice_j07_raphaelle_acknowledge_guided"):
		return false
	if raphaelle_j07_mobile_review_outcome != "UNESTABLISHED" or promises.has("raphaelle_j07_mobile_review"):
		return false
	selected_choice_ids.append(choice_id)
	raphaelle_j07_mobile_review_outcome = "RESPONSIBILITY_ACKNOWLEDGED"
	raphaelle_state = "PROFESSIONAL_ONLY"
	promises["raphaelle_j07_mobile_review"] = {
		"promise_id": "raphaelle_j07_mobile_review",
		"promise_type": "TASK",
		"created_at": "J07 11:04",
		"created_by": "Raphaëlle",
		"proposed_to": "Player",
		"accepted_at": "J07 11:06",
		"accepted_by_player": true,
		"action_due": "Relire la version mobile",
		"due_at": "J08 19:00",
		"confirmation_deadline": "J08 17:00",
		"status": "ACTIVE",
		"related_scene": "j07_raphaelle_mobile_review_obligation",
		"related_trace_ids": [],
	}
	return true

func apply_j07_nico_guided_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id) or current_day != "J07" or day_status != "ACTIVE":
		return false
	if choice_id not in ["choice_j07_nico_topic_guided", "choice_j07_nico_what_mean_guided", "choice_j07_nico_at_least_said_guided"]:
		return false
	selected_choice_ids.append(choice_id)
	return true

func apply_j07_nico_main_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id) or nico_j07_confidence_outcome != "UNESTABLISHED":
		return false
	if not selected_choice_ids.has("choice_j07_nico_what_mean_guided"):
		return false
	var outcome := ""
	var scope: Array[String] = []
	match choice_id:
		"choice_j07_nico_acknowledge_contradiction":
			outcome = "CONTRADICTION_ACKNOWLEDGED"
			scope = [
				"Player se dit bien avec Marie",
				"Player aime recevoir ailleurs une attention spéciale",
				"aucune relation extérieure précise nommée",
				"aucune permission demandée",
			]
		"choice_j07_nico_request_social_view":
			outcome = "SOCIAL_VIEW_REQUESTED"
			scope = [
				"Player demande le regard social de Nico",
				"aucun fait privé confirmé",
				"ampleur de l’interprétation contestée",
				"discussion continuée",
			]
		"choice_j07_nico_stay_vague":
			outcome = "CONFIDENCE_DECLINED"
			scope = [
				"Player refuse de parler ce soir",
				"Player ne nie pas être traversé par quelque chose",
				"aucun alibi demandé",
				"continuation encore à décider",
			]
		_:
			return false
	if traces.has("j07_nico_confidence_01") or knowledge.has("fact_nico_received_player_confidence"):
		return false
	selected_choice_ids.append(choice_id)
	nico_j07_confidence_outcome = outcome
	nico_state = "CONFIDENCE_ACTIVE"
	traces["j07_nico_confidence_01"] = {
		"trace_id": "j07_nico_confidence_01",
		"trace_type": "TEXT_MESSAGE",
		"source_day": "J07",
		"source_scene": "confidence calme Nico",
		"creator": "Player et Nico",
		"subjects": ["Player", "Nico"],
		"owner": "fil Player / Nico",
		"initial_audience": ["Player", "Nico"],
		"current_audience": ["Player", "Nico"],
		"storage_location": "fil Player / Nico",
		"saving_rule": "IN_THREAD_ONLY",
		"transfer_rule": "FORBIDDEN",
		"current_state": "ACTIVE",
		"eligible_for_j14": true,
		"eligible_for_j21": false,
	}
	knowledge["fact_nico_received_player_confidence"] = {
		"fact_id": "fact_nico_received_player_confidence",
		"source_type": "DIRECT_MESSAGE",
		"source_ref": "j07_nico_confidence_01",
		"initial_knowers": ["Nico", "Player"],
		"certainty": "TOLD_DIRECTLY",
		"shareability": "PRIVATE_DO_NOT_SHARE",
		"branch_outcome": outcome,
		"scope": scope,
	}
	return true

func apply_j07_nico_continuation(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id) or nico_j07_continuation_outcome != "UNESTABLISHED":
		return false
	if nico_j07_confidence_outcome == "UNESTABLISHED" or not selected_choice_ids.has("choice_j07_nico_at_least_said_guided"):
		return false
	match choice_id:
		"choice_j07_nico_tuesday_accepted":
			if promises.has("nico_j07_tuesday_1845") or promises.has("nico_j07_thursday_conditional"):
				return false
			nico_j07_continuation_outcome = "TUESDAY_ACCEPTED"
			promises["nico_j07_tuesday_1845"] = {
				"promise_id": "nico_j07_tuesday_1845",
				"promise_type": "MEETING",
				"created_at": "J07 23:00",
				"created_by": "Nico",
				"proposed_to": "Player",
				"accepted_at": "J07 23:01",
				"accepted_by_player": true,
				"action_due": "Continuer la discussion avant le service",
				"due_at": "J08 18:45",
				"status": "ACTIVE",
				"related_scene": "j07_nico_quiet_confidence",
				"related_trace_ids": ["j07_nico_confidence_01"],
			}
		"choice_j07_nico_thursday_conditional":
			if promises.has("nico_j07_tuesday_1845") or promises.has("nico_j07_thursday_conditional"):
				return false
			nico_j07_continuation_outcome = "THURSDAY_CONDITIONAL"
			promises["nico_j07_thursday_conditional"] = {
				"promise_id": "nico_j07_thursday_conditional",
				"promise_type": "MEETING",
				"created_at": "J07 23:01",
				"created_by": "Player",
				"proposed_to": "Nico",
				"accepted_at": "J07 23:01",
				"accepted_by_player": true,
				"action_due": "Confirmer jeudi avant le service",
				"due_at": "",
				"confirmation_deadline": "J10 12:00",
				"status": "CONDITIONAL",
				"related_scene": "j07_nico_quiet_confidence",
				"related_trace_ids": ["j07_nico_confidence_01"],
			}
		"choice_j07_nico_continuation_closed":
			if promises.has("nico_j07_tuesday_1845") or promises.has("nico_j07_thursday_conditional"):
				return false
			nico_j07_continuation_outcome = "CONTINUATION_CLOSED"
			promises["nico_j07_tuesday_1845"] = {
				"promise_id": "nico_j07_tuesday_1845",
				"promise_type": "MEETING",
				"created_at": "J07 23:00",
				"created_by": "Nico",
				"proposed_to": "Player",
				"accepted_at": "",
				"accepted_by_player": false,
				"action_due": "Aucune continuation",
				"due_at": "",
				"paid_or_closed_at": "J07 23:01",
				"paid_or_closed_by": "Player",
				"status": "REFUSED",
				"related_scene": "j07_nico_quiet_confidence",
				"related_trace_ids": ["j07_nico_confidence_01"],
			}
		_:
			return false
	selected_choice_ids.append(choice_id)
	var fact: Dictionary = knowledge.get("fact_nico_received_player_confidence", {})
	if not fact.is_empty() and nico_j07_confidence_outcome == "CONFIDENCE_DECLINED":
		var scope: Array = fact.get("scope", [])
		scope[3] = "continuation " + nico_j07_continuation_outcome.to_lower()
		fact["scope"] = scope
		knowledge["fact_nico_received_player_confidence"] = fact
	return true

func apply_j07_marie_choice(choice_id: String) -> bool:
	if choice_id == "" or selected_choice_ids.has(choice_id) or marie_j07_household_outcome != "UNESTABLISHED":
		return false
	if promises.has("marie_j07_household_request"):
		return false
	var status := ""
	var accepted := false
	var due_at := ""
	match choice_id:
		"choice_j07_marie_presence_confirmed":
			marie_j07_household_outcome = "PRESENCE_CONFIRMED"
			status = "ACTIVE"
			accepted = true
			due_at = "J08 19:15"
		"choice_j07_marie_precise_alternative":
			marie_j07_household_outcome = "PRECISE_ALTERNATIVE"
			status = "AMENDED"
			accepted = true
			due_at = "J08 18:30"
		"choice_j07_marie_honest_refusal":
			marie_j07_household_outcome = "HONEST_REFUSAL"
			status = "REFUSED"
		_:
			return false
	selected_choice_ids.append(choice_id)
	promises["marie_j07_household_request"] = {
		"promise_id": "marie_j07_household_request",
		"promise_type": "PRESENCE",
		"created_at": "J07 23:16",
		"created_by": "Marie",
		"proposed_to": "Player",
		"accepted_at": "J07 23:18",
		"accepted_by_player": accepted,
		"action_due": "Être présent pour le constat" if accepted else "Aucune présence mardi maintenue",
		"due_at": due_at,
		"due_condition": "sous réserve de la réponse du propriétaire" if status == "AMENDED" else "",
		"status": status,
		"related_scene": "j07_marie_household_request",
		"related_trace_ids": [],
	}
	return true

func complete_j07() -> bool:
	if current_day != "J07" or day_status != "ACTIVE":
		return false
	if marie_j06_return_resolution not in ["PAID", "NOT_DUE"]:
		return false
	if raphaelle_j07_mobile_review_outcome != "RESPONSIBILITY_ACKNOWLEDGED":
		return false
	if nico_j07_confidence_outcome == "UNESTABLISHED" or nico_j07_continuation_outcome == "UNESTABLISHED":
		return false
	if marie_j07_household_outcome == "UNESTABLISHED" or not _j07_records_consistent(snapshot()):
		return false
	return complete_day()

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

func complete_conversation(conversation_id: String, character_id: String, narrative_function := "foreground") -> bool:
	if conversation_id == "" or completed_conversation_ids.has(conversation_id):
		return false
	completed_conversation_ids.append(conversation_id)
	foreground_history.append({"day_id": current_day, "character_id": character_id, "function": narrative_function})
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
		"marie_j06_return_resolution": marie_j06_return_resolution,
		"raphaelle_j07_mobile_review_outcome": raphaelle_j07_mobile_review_outcome,
		"nico_j07_confidence_outcome": nico_j07_confidence_outcome,
		"nico_j07_continuation_outcome": nico_j07_continuation_outcome,
		"marie_j07_household_outcome": marie_j07_household_outcome,
		"marie_j08_entry_outcome": marie_j08_entry_outcome,
		"raphaelle_j08_preparation_outcome": raphaelle_j08_preparation_outcome,
		"j08_priority_outcome": j08_priority_outcome,
		"raphaelle_j08_work_resolution": raphaelle_j08_work_resolution,
		"nico_j08_meeting_resolution": nico_j08_meeting_resolution,
		"marie_j08_household_resolution": marie_j08_household_resolution,
		"mathilde_j08_household_resolution": mathilde_j08_household_resolution,
		"marie_j08_echo_outcome": marie_j08_echo_outcome,
		"resolved_visual_variant_by_asset": resolved_visual_variant_by_asset.duplicate(true),
	}

func restore_snapshot(value: Dictionary) -> bool:
	var version := int(value.get("version", -1))
	if version not in [1, 2, 3, 4, 5, SNAPSHOT_VERSION]:
		return false
	if str(value.get("current_day", "")) not in ["J01", "J02", "J03", "J04", "J05", "J06", "J07", "J08"]:
		return false
	if version < 4 and str(value.get("current_day", "")) == "J06":
		return false
	if version < 5 and str(value.get("current_day", "")) == "J07":
		return false
	if version < SNAPSHOT_VERSION and str(value.get("current_day", "")) == "J08":
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
	if str(value.get("nico_state", "UNESTABLISHED")) not in ["UNESTABLISHED", "ORDINARY_FRIEND", "CONFIDENCE_ACTIVE"]: return false
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
	if str(value.get("marie_j06_return_resolution", "UNESTABLISHED")) not in ["UNESTABLISHED", "PAID", "NOT_DUE"]: return false
	if str(value.get("raphaelle_j07_mobile_review_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "RESPONSIBILITY_ACKNOWLEDGED"]: return false
	if str(value.get("nico_j07_confidence_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "CONTRADICTION_ACKNOWLEDGED", "SOCIAL_VIEW_REQUESTED", "CONFIDENCE_DECLINED"]: return false
	if str(value.get("nico_j07_continuation_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "TUESDAY_ACCEPTED", "THURSDAY_CONDITIONAL", "CONTINUATION_CLOSED"]: return false
	if str(value.get("marie_j07_household_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "PRESENCE_CONFIRMED", "PRECISE_ALTERNATIVE", "HONEST_REFUSAL"]: return false
	if str(value.get("marie_j08_entry_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "STATE_A", "STATE_B", "STATE_C"]: return false
	if str(value.get("raphaelle_j08_preparation_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "ANTICIPATED", "SCHEDULED_1820", "VAGUE"]: return false
	if str(value.get("j08_priority_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "OLDEST_COMMITMENT", "IMMEDIATE_PRESENCE", "UNCLEAR", "AUTO_P05_ONLY"]: return false
	if str(value.get("raphaelle_j08_work_resolution", "UNESTABLISHED")) not in ["UNESTABLISHED", "PAID_ON_TIME", "PAID_LATE", "TRANSFERRED_HONESTLY", "ABANDONED_VAGUELY"]: return false
	if str(value.get("nico_j08_meeting_resolution", "UNESTABLISHED")) not in ["UNESTABLISHED", "PAID_SHORT", "CANCELLED_HONESTLY", "FAILED_VAGUE", "NOT_DUE"]: return false
	if str(value.get("marie_j08_household_resolution", "UNESTABLISHED")) not in ["UNESTABLISHED", "PAID", "FAILED_LATE_AMENDMENT", "FAILED_VAGUE", "REFUSAL_ABSORBED"]: return false
	if str(value.get("mathilde_j08_household_resolution", "UNESTABLISHED")) not in ["UNESTABLISHED", "AIDED_BY_PLAYER", "HANDLED_WITH_NEIGHBOR", "RESCHEDULED_WEDNESDAY"]: return false
	if str(value.get("marie_j08_echo_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "CLEAR_HOURS", "HONEST_REFUSAL", "VAGUE_OR_MISSED"]: return false
	if typeof(value.get("resolved_visual_variant_by_asset", {})) != TYPE_DICTIONARY: return false
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
	if not _j07_records_consistent(value):
		return false
	if not _j08_records_consistent(value):
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
	marie_j06_return_resolution = str(value.get("marie_j06_return_resolution", "UNESTABLISHED"))
	raphaelle_j07_mobile_review_outcome = str(value.get("raphaelle_j07_mobile_review_outcome", "UNESTABLISHED"))
	nico_j07_confidence_outcome = str(value.get("nico_j07_confidence_outcome", "UNESTABLISHED"))
	nico_j07_continuation_outcome = str(value.get("nico_j07_continuation_outcome", "UNESTABLISHED"))
	marie_j07_household_outcome = str(value.get("marie_j07_household_outcome", "UNESTABLISHED"))
	marie_j08_entry_outcome = str(value.get("marie_j08_entry_outcome", "UNESTABLISHED"))
	raphaelle_j08_preparation_outcome = str(value.get("raphaelle_j08_preparation_outcome", "UNESTABLISHED"))
	j08_priority_outcome = str(value.get("j08_priority_outcome", "UNESTABLISHED"))
	raphaelle_j08_work_resolution = str(value.get("raphaelle_j08_work_resolution", "UNESTABLISHED"))
	nico_j08_meeting_resolution = str(value.get("nico_j08_meeting_resolution", "UNESTABLISHED"))
	marie_j08_household_resolution = str(value.get("marie_j08_household_resolution", "UNESTABLISHED"))
	mathilde_j08_household_resolution = str(value.get("mathilde_j08_household_resolution", "UNESTABLISHED"))
	marie_j08_echo_outcome = str(value.get("marie_j08_echo_outcome", "UNESTABLISHED"))
	resolved_visual_variant_by_asset = value.get("resolved_visual_variant_by_asset", {}).duplicate(true)
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

func _j07_records_consistent(value: Dictionary) -> bool:
	if str(value.get("current_day", "")) == "J08":
		return _j08_source_records_consistent(value)
	var raphaelle_outcome := str(value.get("raphaelle_j07_mobile_review_outcome", "UNESTABLISHED"))
	var nico_outcome := str(value.get("nico_j07_confidence_outcome", "UNESTABLISHED"))
	var continuation := str(value.get("nico_j07_continuation_outcome", "UNESTABLISHED"))
	var marie_outcome := str(value.get("marie_j07_household_outcome", "UNESTABLISHED"))
	var restored_promises: Dictionary = value.get("promises", {})
	var restored_traces: Dictionary = value.get("traces", {})
	var restored_knowledge: Dictionary = value.get("knowledge", {})
	if (raphaelle_outcome != "UNESTABLISHED") != restored_promises.has("raphaelle_j07_mobile_review"):
		return false
	if raphaelle_outcome != "UNESTABLISHED":
		var p05: Dictionary = restored_promises["raphaelle_j07_mobile_review"]
		if str(p05.get("status", "")) != "ACTIVE" or str(p05.get("due_at", "")) != "J08 19:00" or not bool(p05.get("accepted_by_player", false)):
			return false
	var has_t06 := restored_traces.has("j07_nico_confidence_01")
	var has_f10 := restored_knowledge.has("fact_nico_received_player_confidence")
	if (nico_outcome != "UNESTABLISHED") != has_t06 or has_t06 != has_f10:
		return false
	if has_f10 and str(restored_knowledge["fact_nico_received_player_confidence"].get("branch_outcome", "")) != nico_outcome:
		return false
	var has_p06 := restored_promises.has("nico_j07_tuesday_1845")
	var has_p07 := restored_promises.has("nico_j07_thursday_conditional")
	var p06: Dictionary = restored_promises.get("nico_j07_tuesday_1845", {})
	var p07: Dictionary = restored_promises.get("nico_j07_thursday_conditional", {})
	match continuation:
		"UNESTABLISHED":
			if has_p06 or has_p07:
				return false
		"TUESDAY_ACCEPTED":
			if not has_p06 or has_p07:
				return false
			if str(p06.get("status", "")) != "ACTIVE" or not bool(p06.get("accepted_by_player", false)):
				return false
			if str(p06.get("accepted_at", "")) != "J07 23:01" or str(p06.get("due_at", "")) != "J08 18:45":
				return false
			if str(p06.get("paid_or_closed_at", "")) != "":
				return false
		"THURSDAY_CONDITIONAL":
			if has_p06 or not has_p07:
				return false
			if str(p07.get("status", "")) != "CONDITIONAL" or str(p07.get("due_at", "")) != "":
				return false
			if str(p07.get("confirmation_deadline", "")) != "J10 12:00":
				return false
		"CONTINUATION_CLOSED":
			if not has_p06 or has_p07:
				return false
			if str(p06.get("status", "")) != "REFUSED" or bool(p06.get("accepted_by_player", false)):
				return false
			if str(p06.get("accepted_at", "")) != "" or str(p06.get("due_at", "")) != "":
				return false
			if str(p06.get("paid_or_closed_at", "")) != "J07 23:01" or str(p06.get("paid_or_closed_by", "")) != "Player":
				return false
	var has_p08 := restored_promises.has("marie_j07_household_request")
	if (marie_outcome != "UNESTABLISHED") != has_p08:
		return false
	if has_p08:
		var expected_status: String = str({"PRESENCE_CONFIRMED": "ACTIVE", "PRECISE_ALTERNATIVE": "AMENDED", "HONEST_REFUSAL": "REFUSED"}.get(marie_outcome, ""))
		if str(restored_promises["marie_j07_household_request"].get("status", "")) != expected_status:
			return false
	return true

func _j08_source_records_consistent(value: Dictionary) -> bool:
	if str(value.get("raphaelle_j07_mobile_review_outcome", "")) != "RESPONSIBILITY_ACKNOWLEDGED":
		return false
	if str(value.get("nico_j07_confidence_outcome", "UNESTABLISHED")) == "UNESTABLISHED":
		return false
	if str(value.get("nico_j07_continuation_outcome", "UNESTABLISHED")) == "UNESTABLISHED":
		return false
	if str(value.get("marie_j07_household_outcome", "UNESTABLISHED")) == "UNESTABLISHED":
		return false
	var restored_promises: Dictionary = value.get("promises", {})
	var restored_traces: Dictionary = value.get("traces", {})
	var restored_knowledge: Dictionary = value.get("knowledge", {})
	for promise_id in ["raphaelle_j07_mobile_review", "marie_j07_household_request"]:
		if not restored_promises.has(promise_id):
			return false
	if not restored_traces.has("j07_nico_confidence_01") or not restored_knowledge.has("fact_nico_received_player_confidence"):
		return false
	var p05: Dictionary = restored_promises["raphaelle_j07_mobile_review"]
	if str(p05.get("promise_type", "")) != "TASK" or str(p05.get("created_at", "")) != "J07 11:04":
		return false
	var continuation := str(value.get("nico_j07_continuation_outcome", ""))
	if continuation == "TUESDAY_ACCEPTED" and not restored_promises.has("nico_j07_tuesday_1845"):
		return false
	if continuation == "THURSDAY_CONDITIONAL" and not restored_promises.has("nico_j07_thursday_conditional"):
		return false
	if continuation == "CONTINUATION_CLOSED":
		var refused: Dictionary = restored_promises.get("nico_j07_tuesday_1845", {})
		if str(refused.get("status", "")) != "REFUSED":
			return false
	return true

func _j08_records_consistent(value: Dictionary) -> bool:
	var current := str(value.get("current_day", ""))
	var entry := str(value.get("marie_j08_entry_outcome", "UNESTABLISHED"))
	var preparation := str(value.get("raphaelle_j08_preparation_outcome", "UNESTABLISHED"))
	var priority := str(value.get("j08_priority_outcome", "UNESTABLISHED"))
	var work := str(value.get("raphaelle_j08_work_resolution", "UNESTABLISHED"))
	var nico := str(value.get("nico_j08_meeting_resolution", "UNESTABLISHED"))
	var household := str(value.get("marie_j08_household_resolution", "UNESTABLISHED"))
	var mathilde := str(value.get("mathilde_j08_household_resolution", "UNESTABLISHED"))
	var echo := str(value.get("marie_j08_echo_outcome", "UNESTABLISHED"))
	var variants: Dictionary = value.get("resolved_visual_variant_by_asset", {})
	if current != "J08":
		return entry == "UNESTABLISHED" and preparation == "UNESTABLISHED" and priority == "UNESTABLISHED" and work == "UNESTABLISHED" and nico == "UNESTABLISHED" and household == "UNESTABLISHED" and mathilde == "UNESTABLISHED" and echo == "UNESTABLISHED" and variants.is_empty()
	if entry == "UNESTABLISHED":
		return false
	var restored_promises: Dictionary = value.get("promises", {})
	var p05: Dictionary = restored_promises.get("raphaelle_j07_mobile_review", {})
	var p06: Dictionary = restored_promises.get("nico_j07_tuesday_1845", {})
	var p08: Dictionary = restored_promises.get("marie_j07_household_request", {})
	if p05.is_empty() or p08.is_empty():
		return false
	match entry:
		"STATE_A":
			if str(p08.get("due_at", "")) != "J08 19:15" or str(p08.get("status", "")) not in ["ACTIVE", "PAID", "FAILED"]:
				return false
		"STATE_B":
			if str(p08.get("due_at", "")) != "J08 18:30" or str(p08.get("status", "")) not in ["AMENDED", "PAID"]:
				return false
		"STATE_C":
			if str(p08.get("status", "")) != "REFUSED" or str(p08.get("due_at", "")) != "":
				return false
	if preparation == "UNESTABLISHED" and priority != "UNESTABLISHED":
		return false
	match work:
		"UNESTABLISHED":
			if str(p05.get("status", "")) != "ACTIVE":
				return false
		"PAID_ON_TIME", "PAID_LATE":
			if str(p05.get("status", "")) != "PAID" or str(p05.get("paid_or_closed_by", "")) != "Player":
				return false
		"TRANSFERRED_HONESTLY":
			if str(p05.get("status", "")) != "AMENDED" or str(p05.get("due_at", "")) != "J09 09:00":
				return false
			if str(p05.get("action_due", "")) != "Responsabilité professionnelle du point client":
				return false
		"ABANDONED_VAGUELY":
			if str(p05.get("status", "")) != "FAILED" or str(p05.get("paid_or_closed_by", "")) != "Raphaëlle reprend sans réponse claire":
				return false
	var p06_was_accepted := not p06.is_empty() and bool(p06.get("accepted_by_player", false))
	match nico:
		"UNESTABLISHED":
			if not p06_was_accepted or str(p06.get("status", "")) != "ACTIVE":
				return false
		"PAID_SHORT":
			if str(p06.get("status", "")) != "PAID":
				return false
		"CANCELLED_HONESTLY":
			if str(p06.get("status", "")) != "CANCELLED":
				return false
		"FAILED_VAGUE":
			if str(p06.get("status", "")) != "FAILED":
				return false
		"NOT_DUE":
			if p06_was_accepted and str(p06.get("status", "")) == "ACTIVE":
				return false
	match household:
		"UNESTABLISHED":
			if entry == "STATE_C" or str(p08.get("status", "")) not in ["ACTIVE", "AMENDED"]:
				return false
		"PAID":
			if str(p08.get("status", "")) != "PAID" or mathilde != "AIDED_BY_PLAYER":
				return false
		"FAILED_LATE_AMENDMENT", "FAILED_VAGUE":
			if str(p08.get("status", "")) != "FAILED" or str(p08.get("paid_or_closed_by", "")) != "Mathilde et la voisine" or mathilde != "HANDLED_WITH_NEIGHBOR":
				return false
		"REFUSAL_ABSORBED":
			if entry != "STATE_C" or str(p08.get("status", "")) != "REFUSED" or mathilde != "RESCHEDULED_WEDNESDAY":
				return false
	if echo != "UNESTABLISHED":
		var expected_echo: String = {
			"PAID": "CLEAR_HOURS",
			"REFUSAL_ABSORBED": "HONEST_REFUSAL",
			"FAILED_LATE_AMENDMENT": "VAGUE_OR_MISSED",
			"FAILED_VAGUE": "VAGUE_OR_MISSED",
		}.get(household, "")
		if echo != expected_echo:
			return false
	for record in value.get("traces", {}).values():
		if str(record.get("source_day", "")) == "J08":
			return false
	for record in value.get("knowledge", {}).values():
		if str(record.get("source_day", "")) == "J08":
			return false
	if not variants.is_empty():
		if variants.size() != 3:
			return false
		var expected_raphaelle := "S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_PAID" if work in ["PAID_ON_TIME", "PAID_LATE"] else "S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01_TAKEN_OVER"
		var expected_nico := "S1_A2_J08_SCN_NICO_CHAIR_STATE_01_PAID" if nico == "PAID_SHORT" else "S1_A2_J08_SCN_NICO_CHAIR_STATE_01_NO_WAIT"
		var expected_household := "S1_A2_J08_SCN_HOUSEHOLD_STATE_01_PAID" if household == "PAID" else "S1_A2_J08_SCN_HOUSEHOLD_STATE_01_AUTONOMOUS"
		if str(variants.get("S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01", "")) != expected_raphaelle:
			return false
		if str(variants.get("S1_A2_J08_SCN_NICO_CHAIR_STATE_01", "")) != expected_nico:
			return false
		if str(variants.get("S1_A2_J08_SCN_HOUSEHOLD_STATE_01", "")) != expected_household:
			return false
	return true
