extends RefCounted

class_name Season1State

const SNAPSHOT_VERSION := 25
const J12_LAVERRIERE_EXPLICIT_SUBJECTS := ["Marie", "Player", "Pauline", "Bastien", "Élodie"]
const J17_COUPLE_STATES := ["SEPARATION", "FRACTURE", "DOUBLE_LIFE_FRAGILE", "PROVISIONAL_AGREEMENT", "RECONQUEST_ACTIVE", "RECONFIGURATION_NEGOTIATION"]
const J17_GUARD_FACT_IDS := ["fact_mathilde_physical_event_occurred", "aftercare_mathilde_j11", "fact_witness_saw_limited_trace", "j14_inform_trace_controller", "fact_trace_controller_not_informed", "fact_trace_controller_informed_of_audience_breach", "fact_player_explanation_to_witness", "fact_j15_obligation_resolution", "j16_priority_consequence_payment", "j16_consequence_payment_record_01", "choice_j11_mathilde_m_b2_hold", "choice_j11_mathilde_m_b3_accept", "choice_j11_raphaelle_meeting_accept"]
const J17_CONSTRUCTIVE_CONDITION_IDS := ["J17_REPEATED_MARIE_ACTS_PROVEN", "J17_SUFFICIENT_TRUTH_PROVEN", "J17_NO_ACTIVE_VIOLATION", "J17_CONCRETE_RULE_PROVEN", "J17_EXTERNAL_DESIRE_ACKNOWLEDGED", "J17_AUDIENCES_SAFE_OR_REPAIRED", "J17_EXTERNAL_PROGRESSION_PAUSE_ACCEPTED", "J17_MARIE_FULL_REFUSAL_RIGHT_EXPLICITLY_ACKNOWLEDGED"]

var current_day := "J01"
var day_status := "ACTIVE"
var couple_state := "BASELINE_SHARED_LIFE"
var sandra_state := "DISTANT_FRIEND"
var promises: Dictionary = {}
var obligations: Dictionary = {}
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
var marie_j09_presence_choice := "UNESTABLISHED"
var marie_j09_presence_outcome := "UNESTABLISHED"
var marie_j09_dinner_outcome := "UNESTABLISHED"
var j10_pivot := ""
var j10_pivot_reason := ""
var j10_pivot_outcome := ""
var marie_j10_dinner_resolution := "UNESTABLISHED"
var nico_j10_morning_confirmation := "UNESTABLISHED"
var j11_pivot := ""
var j11_pivot_reason := ""
var j11_pivot_outcome := ""
var j11_physical_level := "NONE"
var mathilde_j11_state := "UNESTABLISHED"
var mathilde_has_independent_sleep_option := false
var mathilde_can_leave_safely := false
var marie_absence_not_engineered := false
var j12_presence_choice := "UNESTABLISHED"
var j12_private_outcome := "UNESTABLISHED"
var j12_annexe_choice := "UNESTABLISHED"
var j12_priority_route := "UNESTABLISHED"
var j12_failed_aftercare_processed := false
var j13_pivot := ""
var j13_outcome := "UNESTABLISHED"
var j13_j14_trace_id := ""
var j14_variant := ""
var j14_outcome := "UNESTABLISHED"
var j14_witness := ""
var j14_witness_presence_evidence: Dictionary = {}
var j14_discovery_mode := ""
var j14_visible_fields: Array = []
var j14_visible_values: Dictionary = {}
var j14_source_trace_id := ""
var j14_secondary_trace_id := ""
var j14_player_initial_reaction := ""
var j14_player_explanation := ""
var j14_j15_obligation_id := ""
var j14_controller_notified := false
var j15_mode := "UNESTABLISHED"
var j15_outcome := "UNESTABLISHED"
var j15_urgent_consequence_remaining := false
var j16_priority := "UNESTABLISHED"
var j16_consequence_outcome := "UNESTABLISHED"
var j16_departure_state := "UNESTABLISHED"
var j16_j17_outcome := "UNESTABLISHED"
var j17_departure_outcome := "UNESTABLISHED"
var j17_couple_outcome := "UNESTABLISHED"
var j18_sandra_outcome := "UNESTABLISHED"
var j19_pivot := ""
var j19_pauline_outcome := "UNESTABLISHED"
var j19_raphaelle_outcome := "UNESTABLISHED"
var j19_raphaelle_invitation_pending := false
var j20_context := "UNESTABLISHED"
var j20_nico_position := "UNESTABLISHED"
var j20_meeting_outcome := "UNESTABLISHED"
var final_trace_id := ""
var final_trace_state := ""
var final_trace_controller := ""
var final_trace_audience: Array = []
var existing_contradiction_id := ""
var final_posture_options: Array = []
var final_posture := "UNESTABLISHED"
var j21_morning_outcome := "UNESTABLISHED"
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
	obligations = {}
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
	marie_j09_presence_choice = "UNESTABLISHED"
	marie_j09_presence_outcome = "UNESTABLISHED"
	marie_j09_dinner_outcome = "UNESTABLISHED"
	j10_pivot = ""
	j10_pivot_reason = ""
	j10_pivot_outcome = ""
	marie_j10_dinner_resolution = "UNESTABLISHED"
	nico_j10_morning_confirmation = "UNESTABLISHED"
	j11_pivot = ""
	j11_pivot_reason = ""
	j11_pivot_outcome = ""
	j11_physical_level = "NONE"
	mathilde_j11_state = "UNESTABLISHED"
	mathilde_has_independent_sleep_option = false
	mathilde_can_leave_safely = false
	marie_absence_not_engineered = false
	j12_presence_choice = "UNESTABLISHED"
	j12_private_outcome = "UNESTABLISHED"
	j12_annexe_choice = "UNESTABLISHED"
	j12_priority_route = "UNESTABLISHED"
	j12_failed_aftercare_processed = false
	j13_pivot = ""
	j13_outcome = "UNESTABLISHED"
	j13_j14_trace_id = ""
	j14_variant = ""
	j14_outcome = "UNESTABLISHED"
	j14_witness = ""
	j14_witness_presence_evidence = {}
	j14_discovery_mode = ""
	j14_visible_fields = []
	j14_visible_values = {}
	j14_source_trace_id = ""
	j14_secondary_trace_id = ""
	j14_player_initial_reaction = ""
	j14_player_explanation = ""
	j14_j15_obligation_id = ""
	j14_controller_notified = false
	j15_mode = "UNESTABLISHED"
	j15_outcome = "UNESTABLISHED"
	j15_urgent_consequence_remaining = false
	j16_priority = "UNESTABLISHED"
	j16_consequence_outcome = "UNESTABLISHED"
	j16_departure_state = "UNESTABLISHED"
	j16_j17_outcome = "UNESTABLISHED"
	j17_departure_outcome = "UNESTABLISHED"
	j17_couple_outcome = "UNESTABLISHED"
	j18_sandra_outcome = "UNESTABLISHED"
	j19_pivot = ""
	j19_pauline_outcome = "UNESTABLISHED"
	j19_raphaelle_outcome = "UNESTABLISHED"
	j19_raphaelle_invitation_pending = false
	j20_context = "UNESTABLISHED"
	j20_nico_position = "UNESTABLISHED"
	j20_meeting_outcome = "UNESTABLISHED"
	final_trace_id = ""
	final_trace_state = ""
	final_trace_controller = ""
	final_trace_audience = []
	existing_contradiction_id = ""
	final_posture_options = []
	final_posture = "UNESTABLISHED"
	j21_morning_outcome = "UNESTABLISHED"
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

func begin_j09() -> bool:
	if current_day != "J08" or day_status != "COMPLETE" or not _j08_records_consistent(snapshot()):
		return false
	var p05: Dictionary = promises.get("raphaelle_j07_mobile_review", {})
	if str(p05.get("status", "")) == "AMENDED":
		if str(p05.get("due_at", "")) != "J09 09:00":
			return false
		p05["status"] = "PAID"
		p05["paid_or_closed_at"] = "J09 09:00"
		p05["paid_or_closed_by"] = "Player"
		promises["raphaelle_j07_mobile_review"] = p05
	current_day = "J09"
	day_status = "ACTIVE"
	return true

func apply_j09_presence_choice(choice_id: String) -> bool:
	if current_day != "J09" or day_status != "ACTIVE" or marie_j09_presence_choice != "UNESTABLISHED":
		return false
	if choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	match choice_id:
		"choice_j09_presence_early":
			marie_j09_presence_choice = "EARLY"
		"choice_j09_presence_late":
			marie_j09_presence_choice = "LATE"
		"choice_j09_presence_absent":
			marie_j09_presence_choice = "ABSENCE_HONEST"
			marie_j09_presence_outcome = "absence_honest"
		_:
			return false
	selected_choice_ids.append(choice_id)
	return true

func establish_j09_black_dress_trace() -> bool:
	if current_day != "J09" or marie_j09_presence_choice == "UNESTABLISHED":
		return false
	if traces.has("j09_marie_black_dress_private_01") or knowledge.has("fact_player_received_marie_black_dress_image"):
		return false
	traces["j09_marie_black_dress_private_01"] = {
		"trace_id": "j09_marie_black_dress_private_01",
		"trace_type": "PHOTO",
		"source_day": "J09",
		"source_scene": "préparation avant La Verrière",
		"creator": "Marie",
		"subjects": ["Marie"],
		"owner": "Marie",
		"initial_audience": ["Marie", "Player"],
		"current_audience": ["Marie", "Player"],
		"storage_location": "fil couple",
		"saving_rule": "IN_THREAD_ONLY",
		"transfer_rule": "FORBIDDEN",
		"current_state": "PRIVATE_ACTIVE",
		"knowledge_created": "fact_player_received_marie_black_dress_image",
		"eligible_for_j14": true,
		"eligible_for_j21": true,
	}
	knowledge["fact_player_received_marie_black_dress_image"] = {
		"fact_id": "fact_player_received_marie_black_dress_image",
		"source_type": "PRIVATE_TRACE",
		"source_ref": "j09_marie_black_dress_private_01",
		"initial_knowers": ["Marie", "Player"],
		"certainty": "OBSERVED",
		"shareability": "PRIVATE_DO_NOT_SHARE",
		"source_day": "J09",
	}
	return true

func apply_j09_presence_quality(choice_id: String) -> bool:
	if current_day != "J09" or day_status != "ACTIVE" or marie_j09_presence_outcome != "UNESTABLISHED":
		return false
	if choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	var outcome := ""
	if marie_j09_presence_choice == "EARLY":
		outcome = {
			"choice_j09_quality_active": "presence_active",
			"choice_j09_quality_playful_useful": "presence_playful_useful",
			"choice_j09_quality_distracted": "presence_distracted",
		}.get(choice_id, "")
	elif marie_j09_presence_choice == "LATE":
		outcome = {
			"choice_j09_quality_late_active": "presence_late_active",
			"choice_j09_quality_spectator": "presence_spectator",
			"choice_j09_quality_bounded": "presence_bounded_reliable",
		}.get(choice_id, "")
	if outcome == "":
		return false
	selected_choice_ids.append(choice_id)
	marie_j09_presence_outcome = outcome
	if outcome == "presence_distracted":
		couple_state = "STRAIN_VISIBLE"
	return true

func establish_j09_public_trace() -> bool:
	if current_day != "J09" or marie_j09_presence_outcome == "UNESTABLISHED":
		return false
	if traces.has("j09_marie_laverriere_public_01") or knowledge.has("fact_marie_public_professional_version_visible"):
		return false
	traces["j09_marie_laverriere_public_01"] = {
		"trace_id": "j09_marie_laverriere_public_01",
		"trace_type": "PHOTO",
		"source_day": "J09",
		"source_scene": "événement La Verrière",
		"creator": "Élodie",
		"subjects": ["Marie", "participants visibles"],
		"owner": "La Verrière",
		"initial_audience": "groupe photographié / canal La Verrière nommé",
		"current_audience": "groupe photographié / canal La Verrière nommé",
		"storage_location": "dossier La Verrière / fil social",
		"saving_rule": "PUBLIC_SOURCE_RULES",
		"transfer_rule": "PUBLIC_SOURCE_RULES",
		"current_state": "PUBLIC_ACTIVE",
		"knowledge_created": "fact_marie_public_professional_version_visible",
		"eligible_for_j14": true,
		"eligible_for_j21": true,
	}
	knowledge["fact_marie_public_professional_version_visible"] = {
		"fact_id": "fact_marie_public_professional_version_visible",
		"source_type": "PUBLIC_TRACE",
		"source_ref": "j09_marie_laverriere_public_01",
		"initial_knowers": "audience sociale de la trace",
		"certainty": "OBSERVED",
		"shareability": "PUBLIC_SOURCE_RULES",
		"source_day": "J09",
	}
	return true

func establish_j09_after_trace() -> bool:
	if current_day != "J09" or not traces.has("j09_marie_laverriere_public_01"):
		return false
	if traces.has("j09_marie_laverriere_after_01") or knowledge.has("fact_marie_recontextualized_evening_for_player"):
		return false
	traces["j09_marie_laverriere_after_01"] = {
		"trace_id": "j09_marie_laverriere_after_01",
		"trace_type": "PHOTO",
		"source_day": "J09",
		"source_scene": "fermeture ou fin de soirée",
		"creator": "Élodie",
		"subjects": ["Marie"],
		"owner": "Marie ou Élodie selon accord final",
		"initial_audience": ["Marie", "groupe autorisé"],
		"current_audience": ["Marie", "Player"],
		"storage_location": "fil Marie / Player après relais",
		"saving_rule": "IN_THREAD_ONLY",
		"transfer_rule": "FORBIDDEN hors audience",
		"current_state": "PRIVATE_ACTIVE",
		"knowledge_created": "fact_marie_recontextualized_evening_for_player",
		"eligible_for_j14": true,
		"eligible_for_j21": true,
	}
	knowledge["fact_marie_recontextualized_evening_for_player"] = {
		"fact_id": "fact_marie_recontextualized_evening_for_player",
		"source_type": "PRIVATE_TRACE",
		"source_ref": "j09_marie_laverriere_after_01",
		"initial_knowers": ["Marie", "Player"],
		"certainty": "OBSERVED",
		"shareability": "PRIVATE_DO_NOT_SHARE",
		"source_day": "J09",
	}
	return true

func apply_j09_dinner_choice(choice_id: String) -> bool:
	if current_day != "J09" or day_status != "ACTIVE" or marie_j09_dinner_outcome != "UNESTABLISHED":
		return false
	if marie_j09_presence_outcome not in ["presence_active", "presence_playful_useful", "presence_late_active", "presence_bounded_reliable", "absence_honest"]:
		return false
	if choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	match choice_id:
		"choice_j09_dinner_j10":
			marie_j09_dinner_outcome = "J10_ACCEPTED"
			promises["marie_j09_dinner_j10_2030"] = {
				"promise_id": "marie_j09_dinner_j10_2030",
				"promise_type": "MEETING",
				"created_at": "J09 23:09",
				"created_by": "Marie",
				"proposed_to": "Player",
				"accepted_at": "J09 23:10",
				"accepted_by_player": true,
				"action_due": "Manger ensemble",
				"due_at": "J10 20:30",
				"confirmation_deadline": "J10 09:30",
				"status": "ACTIVE",
				"related_scene": "J09 after separation / J10 priorité couple",
				"related_trace_ids": ["j09_marie_laverriere_after_01"],
			}
		"choice_j09_dinner_friday":
			marie_j09_dinner_outcome = "FRIDAY_ACCEPTED"
			promises["marie_j09_dinner_friday_2030"] = {
				"promise_id": "marie_j09_dinner_friday_2030",
				"promise_type": "MEETING",
				"created_at": "J09 23:10",
				"created_by": "Player",
				"proposed_to": "Marie",
				"accepted_at": "J09 23:10",
				"accepted_by_player": true,
				"action_due": "Manger ensemble",
				"due_at": "J11 20:30",
				"confirmation_deadline": "J11 18:00",
				"status": "ACTIVE",
				"related_scene": "conséquence couple J11",
				"related_trace_ids": [],
			}
		"choice_j09_dinner_refuse":
			marie_j09_dinner_outcome = "REFUSED"
			promises["marie_j09_dinner_j10_2030"] = {
				"promise_id": "marie_j09_dinner_j10_2030",
				"promise_type": "MEETING",
				"created_at": "J09 23:09",
				"created_by": "Marie",
				"proposed_to": "Player",
				"accepted_at": "",
				"accepted_by_player": false,
				"action_due": "Manger ensemble",
				"due_at": "",
				"confirmation_deadline": "J10 09:30",
				"status": "REFUSED",
				"paid_or_closed_at": "J09 23:10",
				"paid_or_closed_by": "Player",
				"related_scene": "J09 after separation / J10 priorité couple",
				"related_trace_ids": ["j09_marie_laverriere_after_01"],
			}
		_:
			return false
	selected_choice_ids.append(choice_id)
	return true

func close_j09_without_dinner_offer() -> bool:
	if current_day != "J09" or marie_j09_dinner_outcome != "UNESTABLISHED":
		return false
	if marie_j09_presence_outcome not in ["presence_distracted", "presence_spectator"]:
		return false
	marie_j09_dinner_outcome = "NOT_OFFERED"
	return true

func complete_j09() -> bool:
	if current_day != "J09" or day_status != "ACTIVE":
		return false
	if marie_j09_presence_choice == "UNESTABLISHED" or marie_j09_presence_outcome == "UNESTABLISHED":
		return false
	if marie_j09_dinner_outcome == "UNESTABLISHED" or not _j09_records_consistent(snapshot()):
		return false
	if not complete_conversation("chapter_09_marie_laverriere", "marie", "pivot"):
		return false
	return complete_day()

func begin_j10() -> bool:
	if current_day != "J09" or day_status != "COMPLETE" or not _j09_records_consistent(snapshot()):
		return false
	current_day = "J10"
	day_status = "ACTIVE"
	j10_pivot = ""
	j10_pivot_reason = ""
	j10_pivot_outcome = ""
	nico_j10_morning_confirmation = "UNESTABLISHED"
	var p09: Dictionary = promises.get("marie_j09_dinner_j10_2030", {})
	var p10: Dictionary = promises.get("marie_j09_dinner_friday_2030", {})
	if str(p09.get("status", "")) == "ACTIVE":
		marie_j10_dinner_resolution = "THURSDAY_DUE"
	elif str(p10.get("status", "")) == "ACTIVE":
		marie_j10_dinner_resolution = "UNESTABLISHED"
	else:
		marie_j10_dinner_resolution = "NOT_DUE"
	var p07: Dictionary = promises.get("nico_j07_thursday_conditional", {})
	if str(p07.get("status", "")) != "CONDITIONAL":
		nico_j10_morning_confirmation = "NOT_DUE"
	return true

func apply_j10_marie_morning_choice(choice_id: String) -> bool:
	if current_day != "J10" or day_status != "ACTIVE" or choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	var p09: Dictionary = promises.get("marie_j09_dinner_j10_2030", {})
	var p10: Dictionary = promises.get("marie_j09_dinner_friday_2030", {})
	if choice_id == "choice_j10_marie_friday_confirm_guided":
		if not p09.is_empty() or str(p10.get("status", "")) != "ACTIVE" or str(p10.get("due_at", "")) != "J11 20:30":
			return false
		selected_choice_ids.append(choice_id)
		marie_j10_dinner_resolution = "FRIDAY_RECONFIRMED"
		return true
	if str(p09.get("status", "")) != "ACTIVE" or not p10.is_empty():
		return false
	match choice_id:
		"choice_j10_marie_keep_thursday":
			if str(p09.get("due_at", "")) != "J10 20:30":
				return false
			marie_j10_dinner_resolution = "THURSDAY_DUE"
		"choice_j10_marie_amend_friday":
			p09["status"] = "AMENDED"
			p09["paid_or_closed_at"] = "J10 08:22"
			p09["paid_or_closed_by"] = "Player"
			promises["marie_j09_dinner_j10_2030"] = p09
			promises["marie_j09_dinner_friday_2030"] = {
				"promise_id": "marie_j09_dinner_friday_2030",
				"promise_type": "MEETING",
				"created_at": "J10 08:22",
				"created_by": "Player",
				"proposed_to": "Marie",
				"accepted_at": "J10 08:22",
				"accepted_by_player": true,
				"action_due": "Manger ensemble",
				"due_at": "J11 20:30",
				"confirmation_deadline": "J11 18:00",
				"status": "ACTIVE",
				"amends": "marie_j09_dinner_j10_2030",
				"related_scene": "conséquence couple J11",
				"related_trace_ids": [],
			}
			marie_j10_dinner_resolution = "THURSDAY_AMENDED_TO_FRIDAY"
		"choice_j10_marie_cancel_morning":
			p09["status"] = "CANCELLED"
			p09["paid_or_closed_at"] = "J10 08:22"
			p09["paid_or_closed_by"] = "Player"
			promises["marie_j09_dinner_j10_2030"] = p09
			marie_j10_dinner_resolution = "THURSDAY_CANCELLED"
		_:
			return false
	selected_choice_ids.append(choice_id)
	return true

func apply_j10_nico_morning_choice(choice_id: String) -> bool:
	if current_day != "J10" or day_status != "ACTIVE" or choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	var p07: Dictionary = promises.get("nico_j07_thursday_conditional", {})
	if str(p07.get("status", "")) != "CONDITIONAL" or str(p07.get("confirmation_deadline", "")) != "J10 12:00":
		return false
	match choice_id:
		"choice_j10_nico_morning_confirm":
			p07["status"] = "ACTIVE"
			p07["activated_at"] = "J10 11:43"
			p07["accepted_at"] = "J10 11:43"
			p07["accepted_by_player"] = true
			p07["due_at"] = "J10 18:20"
			nico_j10_morning_confirmation = "CONFIRMED_ACTIVE"
		"choice_j10_nico_morning_refuse":
			p07["status"] = "REFUSED"
			p07["paid_or_closed_at"] = "J10 11:43"
			p07["paid_or_closed_by"] = "Player"
			p07["due_at"] = ""
			nico_j10_morning_confirmation = "REFUSED"
		_:
			return false
	promises["nico_j07_thursday_conditional"] = p07
	selected_choice_ids.append(choice_id)
	return true

func expire_j10_nico_morning_confirmation() -> bool:
	if current_day != "J10" or day_status != "ACTIVE":
		return false
	var p07: Dictionary = promises.get("nico_j07_thursday_conditional", {})
	if str(p07.get("status", "")) != "CONDITIONAL" or str(p07.get("confirmation_deadline", "")) != "J10 12:00":
		return false
	p07["status"] = "EXPIRED"
	p07["paid_or_closed_at"] = "J10 12:00"
	p07["paid_or_closed_by"] = "confirmation_deadline"
	p07["due_at"] = ""
	promises["nico_j07_thursday_conditional"] = p07
	nico_j10_morning_confirmation = "EXPIRED"
	return true

func set_j10_pivot_selection(pivot: String, reason: String) -> bool:
	if current_day != "J10" or day_status != "ACTIVE" or j10_pivot != "" or j10_pivot_reason != "":
		return false
	if pivot not in ["SANDRA", "MATHILDE", "RAPHAELLE", "NICO", "NONE"]:
		return false
	if reason not in ["DUE_PROMISE_P07", "MARIE_CONSEQUENCE_PRIORITY", "LEAST_RECENT_FOREGROUND", "AUTHORED_ORDER", "NO_ELIGIBLE_PIVOT", "ALL_ACCESS_CLOSED"]:
		return false
	j10_pivot = pivot
	j10_pivot_reason = reason
	return true

func record_j10_choice(choice_id: String, allowed_choice_ids: Array) -> bool:
	if current_day != "J10" or day_status != "ACTIVE" or choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	if not allowed_choice_ids.has(choice_id):
		return false
	selected_choice_ids.append(choice_id)
	return true

func apply_j10_sandra_outcome(choice_id: String) -> bool:
	if j10_pivot != "SANDRA" or j10_pivot_outcome != "":
		return false
	var outcome: String = str({
		"choice_j10_sandra_calm_presence": "CAFE_HELD_CALM_PRESENCE",
		"choice_j10_sandra_missing_named": "CAFE_HELD_MISSING_NAMED",
		"choice_j10_sandra_friendship_bounded": "CAFE_HELD_FRIENDSHIP_BOUNDED",
		"choice_j10_sandra_saturday": "CAFE_SATURDAY_CONDITIONAL",
		"choice_j10_sandra_close": "CAFE_OPPORTUNITY_CLOSED",
	}.get(choice_id, ""))
	if outcome == "":
		return false
	if outcome == "CAFE_SATURDAY_CONDITIONAL" and promises.has("sandra_cafe_saturday_1100"):
		return false
	if not record_j10_choice(choice_id, [choice_id]):
		return false
	if outcome == "CAFE_SATURDAY_CONDITIONAL":
		promises["sandra_cafe_saturday_1100"] = {
			"promise_id": "sandra_cafe_saturday_1100",
			"promise_type": "MEETING",
			"created_at": "J10 12:24",
			"created_by": "Player",
			"proposed_to": "Sandra",
			"accepted_at": "", "accepted_by_player": false,
			"counterparty_confirmed_at": "", "counterparty_confirmed_by": "",
			"action_due": "Café au même endroit samedi si double confirmation",
			"due_at": "J12 11:00",
			"confirmation_deadline": "Sandra J11 18:00 puis Player J12 09:30",
			"counterparty_confirmation_deadline": "J11 18:00",
			"player_confirmation_deadline": "J12 09:30",
			"status": "CONDITIONAL",
			"paid_or_closed_at": "", "paid_or_closed_by": "", "outcome": "PENDING_DOUBLE_CONFIRMATION",
			"related_scene": "J12_PRELUDE_SANDRA_CAFE_CONFIRMED",
			"related_trace_ids": ["j01_sandra_lunch_memory_soft"],
		}
	j10_pivot_outcome = outcome
	return true

func establish_j10_mathilde_records() -> bool:
	if j10_pivot != "MATHILDE" or traces.has("j10_mathilde_outfit_choice_01") or knowledge.has("fact_mathilde_chose_player_as_outfit_audience"):
		return false
	traces["j10_mathilde_outfit_choice_01"] = {
		"trace_id": "j10_mathilde_outfit_choice_01",
		"trace_type": "PHOTO",
		"source_day": "J10",
		"source_scene": "Mathilde choisit l’effet de sa tenue",
		"creator": "Mathilde",
		"subjects": ["Mathilde"],
		"owner": "Mathilde",
		"initial_audience": ["Mathilde", "Player"],
		"current_audience": ["Mathilde", "Player"],
		"storage_location": "fil Player / Mathilde",
		"saving_rule": "IN_THREAD_ONLY",
		"transfer_rule": "FORBIDDEN",
		"current_state": "PRIVATE_ACTIVE",
		"knowledge_created": "fact_mathilde_chose_player_as_outfit_audience",
		"eligible_for_j14": true,
		"eligible_for_j21": true,
	}
	knowledge["fact_mathilde_chose_player_as_outfit_audience"] = {
		"fact_id": "fact_mathilde_chose_player_as_outfit_audience",
		"source_type": "PRIVATE_TRACE",
		"source_ref": "j10_mathilde_outfit_choice_01",
		"initial_knowers": ["Mathilde", "Player"],
		"certainty": "CONFIRMED",
		"shareability": "PRIVATE_DO_NOT_SHARE",
		"source_day": "J10",
	}
	return true

func apply_j10_mathilde_outcome(choice_id: String) -> bool:
	if j10_pivot != "MATHILDE" or j10_pivot_outcome != "":
		return false
	var outcome: String = str({
		"choice_j10_mathilde_precise": "OUTFIT_PRECISE_NON_APPROPRIATIVE",
		"choice_j10_mathilde_effect": "OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED",
		"choice_j10_mathilde_weather": "OUTFIT_PRACTICAL_WEATHER",
	}.get(choice_id, ""))
	if outcome == "" or not record_j10_choice(choice_id, [choice_id]):
		return false
	if not traces.has("j10_mathilde_outfit_choice_01") or not knowledge.has("fact_mathilde_chose_player_as_outfit_audience"):
		return false
	j10_pivot_outcome = outcome
	if outcome in ["OUTFIT_PRECISE_NON_APPROPRIATIVE", "OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED"]:
		mathilde_state = "INTENT_OPEN"
	return true

func apply_j10_raphaelle_outcome(choice_id: String) -> bool:
	if j10_pivot != "RAPHAELLE" or j10_pivot_outcome != "":
		return false
	var outcome: String = str({
		"choice_j10_raphaelle_visit": "PROCESS_HELPED_VISIT_BOUNDED",
		"choice_j10_raphaelle_remote": "PROCESS_HELPED_REMOTE",
		"choice_j10_raphaelle_result": "RESULT_ONLY",
		"choice_j10_raphaelle_boundary": "PROFESSIONAL_BOUNDARY",
	}.get(choice_id, ""))
	if outcome == "" or not record_j10_choice(choice_id, [choice_id]):
		return false
	j10_pivot_outcome = outcome
	if outcome == "PROCESS_HELPED_VISIT_BOUNDED":
		raphaelle_state = "CREATIVE_ACCESS"
	return true

func apply_j10_nico_1812_choice(choice_id: String) -> bool:
	if j10_pivot != "NICO" or choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	var p07: Dictionary = promises.get("nico_j07_thursday_conditional", {})
	if str(p07.get("status", "")) != "ACTIVE" or str(p07.get("due_at", "")) != "J10 18:20":
		return false
	match choice_id:
		"choice_j10_nico_1812_keep":
			pass
		"choice_j10_nico_1812_cancel":
			p07["status"] = "CANCELLED"
			p07["paid_or_closed_at"] = "J10 18:12"
			p07["paid_or_closed_by"] = "Player"
			promises["nico_j07_thursday_conditional"] = p07
			j10_pivot_outcome = "THURSDAY_MEETING_CANCELLED"
		_:
			return false
	selected_choice_ids.append(choice_id)
	return true

func pay_j10_nico_meeting() -> bool:
	var p07: Dictionary = promises.get("nico_j07_thursday_conditional", {})
	if j10_pivot != "NICO" or str(p07.get("status", "")) != "ACTIVE" or str(p07.get("due_at", "")) != "J10 18:20":
		return false
	p07["status"] = "PAID"
	p07["paid_or_closed_at"] = "J10 18:30"
	p07["paid_or_closed_by"] = "Player et Nico hors téléphone"
	promises["nico_j07_thursday_conditional"] = p07
	return true

func apply_j10_nico_outcome(choice_id: String) -> bool:
	if j10_pivot != "NICO" or j10_pivot_outcome != "":
		return false
	var outcome: String = str({
		"choice_j10_nico_difference": "DIFFERENCE_ACKNOWLEDGED_NO_IMAGE",
		"choice_j10_nico_observation": "NICO_OBSERVATION_REQUESTED",
		"choice_j10_nico_close": "COMPARISON_CLOSED",
	}.get(choice_id, ""))
	if outcome == "" or not record_j10_choice(choice_id, [choice_id]):
		return false
	j10_pivot_outcome = outcome
	return true

func apply_j10_evening_choice(choice_id: String) -> bool:
	if current_day != "J10" or j10_pivot == "" or choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	var p09: Dictionary = promises.get("marie_j09_dinner_j10_2030", {})
	var fallback_outcome := ""
	match choice_id:
		"choice_j10_dinner_pay":
			if str(p09.get("status", "")) != "ACTIVE":
				return false
			p09["status"] = "PAID"
			p09["paid_or_closed_at"] = "J10 20:30"
			p09["paid_or_closed_by"] = "Player et Marie hors téléphone"
			promises["marie_j09_dinner_j10_2030"] = p09
			marie_j10_dinner_resolution = "THURSDAY_PAID"
			fallback_outcome = "DUE_DINNER_PAID"
		"choice_j10_dinner_late":
			if str(p09.get("status", "")) != "ACTIVE":
				return false
			p09["status"] = "FAILED"
			p09["paid_or_closed_at"] = "J10 19:52"
			p09["paid_or_closed_by"] = "Marie mange avec Mathilde"
			promises["marie_j09_dinner_j10_2030"] = p09
			marie_j10_dinner_resolution = "THURSDAY_FAILED_LATE"
			fallback_outcome = "DUE_DINNER_FAILED_LATE"
		"choice_j10_dinner_cancel":
			if str(p09.get("status", "")) != "ACTIVE":
				return false
			p09["status"] = "CANCELLED"
			p09["paid_or_closed_at"] = "J10 19:52"
			p09["paid_or_closed_by"] = "Player"
			promises["marie_j09_dinner_j10_2030"] = p09
			marie_j10_dinner_resolution = "THURSDAY_CANCELLED"
			fallback_outcome = "DUE_DINNER_CANCELLED"
		"choice_j10_fallback_join":
			if str(p09.get("status", "")) == "ACTIVE":
				return false
			fallback_outcome = "ORDINARY_MEAL_JOINED"
		"choice_j10_fallback_late":
			if str(p09.get("status", "")) == "ACTIVE":
				return false
			fallback_outcome = "LATE_RETURN_SEPARATE"
		"choice_j10_fallback_absent":
			if str(p09.get("status", "")) == "ACTIVE":
				return false
			fallback_outcome = "ABSENCE_ANNOUNCED"
		_:
			return false
	selected_choice_ids.append(choice_id)
	if j10_pivot == "NONE":
		if j10_pivot_outcome != "":
			return false
		j10_pivot_outcome = fallback_outcome
	return true

func complete_j10() -> bool:
	if current_day != "J10" or day_status != "ACTIVE" or j10_pivot == "" or j10_pivot_reason == "" or j10_pivot_outcome == "":
		return false
	if marie_j10_dinner_resolution in ["UNESTABLISHED", "THURSDAY_DUE"]:
		return false
	if nico_j10_morning_confirmation == "UNESTABLISHED":
		return false
	var p09: Dictionary = promises.get("marie_j09_dinner_j10_2030", {})
	var p10: Dictionary = promises.get("marie_j09_dinner_friday_2030", {})
	if str(p09.get("status", "")) == "ACTIVE":
		return false
	if str(p09.get("status", "")) == "ACTIVE" and str(p10.get("status", "")) == "ACTIVE":
		return false
	var has_t10 := traces.has("j10_mathilde_outfit_choice_01")
	var has_f13 := knowledge.has("fact_mathilde_chose_player_as_outfit_audience")
	if has_t10 != has_f13 or (j10_pivot == "MATHILDE") != has_t10:
		return false
	var conversation_id: String = str({
		"SANDRA": "chapter_10_sandra_cafe",
		"MATHILDE": "chapter_10_mathilde_outfit",
		"RAPHAELLE": "chapter_10_raphaelle_process",
		"NICO": "chapter_10_nico_observation",
		"NONE": "chapter_10_marie_obligations",
	}.get(j10_pivot, ""))
	var character_id: String = str({
		"SANDRA": "sandra",
		"MATHILDE": "mathilde",
		"RAPHAELLE": "raphaelle",
		"NICO": "nico",
		"NONE": "marie",
	}.get(j10_pivot, ""))
	if not _j10_records_consistent(snapshot()):
		return false
	if not complete_conversation(conversation_id, character_id, "pivot" if j10_pivot != "NONE" else "consequence_or_respiration"):
		return false
	return complete_day()

func begin_j11() -> bool:
	if current_day != "J10" or day_status != "COMPLETE" or not _j10_records_consistent(snapshot()):
		return false
	current_day = "J11"
	day_status = "ACTIVE"
	j11_pivot = ""
	j11_pivot_reason = ""
	j11_pivot_outcome = ""
	j11_physical_level = "NONE"
	mathilde_j11_state = "UNESTABLISHED"
	mathilde_has_independent_sleep_option = false
	mathilde_can_leave_safely = false
	marie_absence_not_engineered = false
	return true

func set_j11_continuation(pivot: String, reason: String) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or j11_pivot != "" or j11_pivot_reason != "":
		return false
	if pivot not in ["SANDRA", "MATHILDE", "RAPHAELLE", "NICO", "MARIE", "RESPIRATION"]:
		return false
	if reason not in ["J10_CONTINUATION", "J10_LIMIT_CONSEQUENCE", "P10_COUPLE_PRIORITY", "J10_NONE_MARIE_FALLBACK", "EXTERNAL_CLOSED_MARIE_CONSEQUENCE", "J10_NO_LEGITIMATE_CONTINUATION"]:
		return false
	if not _j11_selection_matches_j10(pivot, reason, j10_pivot, j10_pivot_outcome):
		return false
	j11_pivot = pivot
	j11_pivot_reason = reason
	return true

func record_j11_choice(choice_id: String, allowed_choice_ids: Array) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	if not allowed_choice_ids.has(choice_id):
		return false
	selected_choice_ids.append(choice_id)
	return true

func set_j11_semantic_outcome(outcome: String) -> bool:
	if current_day != "J11" or day_status != "ACTIVE":
		return false
	var allowed_by_pivot := {
		"SANDRA": ["SANDRA_RULE_CLARIFIED", "SANDRA_DESIRE_BOUNDED", "SANDRA_IMAGE_REMOVED"],
		"MARIE": ["MARIE_ADULT_RECONQUEST", "MARIE_NON_ADULT_RECONNECTION", "MARIE_SEX_NOT_USED_AS_BANDAGE", "MARIE_HONEST_REFUSAL", "MARIE_NO_RECONQUEST"],
		"MATHILDE": ["MATHILDE_LOOK_ONLY", "MATHILDE_M_B1", "MATHILDE_M_B2", "MATHILDE_M_B3", "MATHILDE_CLEAN_STOP", "MATHILDE_DISTANCE_RESTORED"],
		"NICO": ["NICO_GUARDRAIL_HELD", "NICO_RIVALRY_MAINTAINED", "NICO_CLEAN_CLOSE"],
	}
	if outcome not in allowed_by_pivot.get(j11_pivot, []):
		return false
	if j11_pivot_outcome != "" and not (j11_pivot == "MATHILDE" and j11_pivot_outcome == "MATHILDE_M_B1" and outcome in ["MATHILDE_M_B2", "MATHILDE_M_B3", "MATHILDE_CLEAN_STOP"]):
		return false
	j11_pivot_outcome = outcome
	return true

func apply_j11_p10_choice(choice_id: String) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	var p10: Dictionary = promises.get("marie_j09_dinner_friday_2030", {})
	if str(p10.get("status", "")) != "ACTIVE" or str(p10.get("due_at", "")) != "J11 20:30" or p10.has("j11_resolution"):
		return false
	match choice_id:
		"choice_j11_p10_maintain":
			p10["j11_resolution"] = "MAINTAINED"
			p10["maintained_at"] = "J11 17:33"
			p10["maintained_by"] = "Player"
		"choice_j11_p10_cancel":
			p10["j11_resolution"] = "CANCELLED"
			p10["status"] = "CANCELLED"
			p10["paid_or_closed_at"] = "J11 17:33"
			p10["paid_or_closed_by"] = "Player"
		"choice_j11_p10_late":
			p10["j11_resolution"] = "LATE_INCOMPATIBLE"
			p10["incompatible_arrival_at"] = "J11 21:00"
		_:
			return false
	promises["marie_j09_dinner_friday_2030"] = p10
	selected_choice_ids.append(choice_id)
	return true

func pay_j11_p10() -> bool:
	if current_day != "J11" or day_status != "ACTIVE":
		return false
	var p10: Dictionary = promises.get("marie_j09_dinner_friday_2030", {})
	if str(p10.get("status", "")) != "ACTIVE" or str(p10.get("due_at", "")) != "J11 20:30":
		return false
	match str(p10.get("j11_resolution", "")):
		"MAINTAINED":
			p10["status"] = "PAID"
			p10["paid_or_closed_by"] = "Player et Marie hors téléphone"
		"LATE_INCOMPATIBLE":
			p10["status"] = "FAILED"
			p10["paid_or_closed_by"] = "retard incompatible annoncé par Player"
		_:
			return false
	p10["paid_or_closed_at"] = "J11 20:30"
	promises["marie_j09_dinner_friday_2030"] = p10
	return true

func confirm_or_expire_j11_p11_counterparty(confirmed: bool) -> bool:
	if current_day != "J11" or day_status != "ACTIVE":
		return false
	var p11: Dictionary = promises.get("sandra_cafe_saturday_1100", {})
	if str(p11.get("status", "")) != "CONDITIONAL" or str(p11.get("counterparty_confirmed_at", "")) != "" or str(p11.get("counterparty_confirmed_by", "")) != "":
		return false
	if confirmed:
		p11["counterparty_confirmed_at"] = "J11 17:44"
		p11["counterparty_confirmed_by"] = "Sandra"
		p11["outcome"] = "COUNTERPARTY_CONFIRMED"
	else:
		p11["status"] = "EXPIRED"
		p11["paid_or_closed_at"] = "J11 18:00"
		p11["paid_or_closed_by"] = "counterparty_confirmation_deadline"
		p11["outcome"] = "EXPIRED_COUNTERPARTY_NOT_CONFIRMED"
	promises["sandra_cafe_saturday_1100"] = p11
	return true

func configure_j11_mathilde_safety(independent_sleep: bool, can_leave: bool, absence_not_engineered: bool) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or j11_pivot != "MATHILDE" or mathilde_j11_state != "UNESTABLISHED":
		return false
	mathilde_has_independent_sleep_option = independent_sleep
	mathilde_can_leave_safely = can_leave
	marie_absence_not_engineered = absence_not_engineered
	return true

func set_j11_mathilde_proximity(state_value: String) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or j11_pivot != "MATHILDE" or mathilde_j11_state != "UNESTABLISHED":
		return false
	if state_value not in ["PROXIMITY_CONSENTED", "DISTANCE"]:
		return false
	mathilde_j11_state = state_value
	mathilde_state = state_value
	j11_physical_level = "PROXIMITY_ONLY" if state_value == "PROXIMITY_CONSENTED" else "NONE"
	j11_pivot_outcome = "MATHILDE_M_B1" if state_value == "PROXIMITY_CONSENTED" else "MATHILDE_DISTANCE_RESTORED"
	return true

func establish_j11_mathilde_physical_event(level: String, consent_current: bool) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or j11_pivot != "MATHILDE" or mathilde_j11_state not in ["UNESTABLISHED", "PROXIMITY_CONSENTED"]:
		return false
	if level not in ["MATHILDE_M_B2", "MATHILDE_M_B3"] or not consent_current:
		return false
	if _j11_p10_blocks_external_physical() or _has_due_obligation():
		return false
	if not mathilde_has_independent_sleep_option or not mathilde_can_leave_safely or not marie_absence_not_engineered:
		return false
	if traces.has("j11_mathilde_physical_aftercare_01") or knowledge.has("fact_mathilde_physical_event_occurred") or obligations.has("aftercare_mathilde_j11"):
		return false
	traces["j11_mathilde_physical_aftercare_01"] = {
		"trace_id": "j11_mathilde_physical_aftercare_01", "trace_type": "TEXT_MESSAGE",
		"source_day": "J11", "source_scene": "aftercare Mathilde J11",
		"creator": "Mathilde", "subjects": ["Mathilde", "Player"],
		"owner": "Mathilde", "initial_audience": ["Mathilde", "Player"],
		"current_audience": ["Mathilde", "Player"], "storage_location": "fil Player / Mathilde",
		"saving_rule": "IN_THREAD_ONLY", "transfer_rule": "FORBIDDEN",
		"current_state": "PRIVATE_ACTIVE", "knowledge_created": "fact_mathilde_physical_event_occurred",
	}
	knowledge["fact_mathilde_physical_event_occurred"] = {
		"fact_id": "fact_mathilde_physical_event_occurred", "source_type": "PRIVATE_TRACE",
		"source_ref": "j11_mathilde_physical_aftercare_01", "initial_knowers": ["Mathilde", "Player"],
		"certainty": "CONFIRMED", "shareability": "PRIVATE_DO_NOT_SHARE", "source_day": "J11",
		"physical_level": level,
	}
	if not _create_j11_aftercare("aftercare_mathilde_j11", ["Mathilde", "Player"], "avant toute nouvelle progression et convergence J12", "fermeture physique Mathilde et préambule prioritaire J12"):
		traces.erase("j11_mathilde_physical_aftercare_01")
		knowledge.erase("fact_mathilde_physical_event_occurred")
		return false
	mathilde_j11_state = "PHYSICAL_SECRET"
	mathilde_state = "PHYSICAL_SECRET"
	j11_physical_level = level
	j11_pivot_outcome = level
	return true

func establish_j11_sandra_private_image(access_mode: String) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or j11_pivot != "SANDRA" or access_mode not in ["view_only", "in_thread_allowed", "removed"]:
		return false
	if traces.has("j11_sandra_chosen_image_01") or knowledge.has("fact_sandra_chose_private_image_for_player"):
		return false
	var trace_state := "REMOVED" if access_mode == "removed" else "PRIVATE_ACTIVE"
	traces["j11_sandra_chosen_image_01"] = {
		"trace_id": "j11_sandra_chosen_image_01", "trace_type": "PHOTO", "source_day": "J11",
		"source_scene": "Sandra choisit une image privée pour Player", "creator": "Sandra",
		"subjects": ["Sandra"], "owner": "Sandra", "initial_audience": ["Sandra", "Player"],
		"current_audience": ["Sandra", "Player"] if access_mode != "removed" else ["Sandra"],
		"storage_location": "voir seulement" if access_mode == "view_only" else "fil Player / Sandra",
		"saving_rule": "VIEW_ONLY" if access_mode == "view_only" else "IN_THREAD_ONLY",
		"transfer_rule": "FORBIDDEN", "current_state": trace_state,
		"knowledge_created": "fact_sandra_chose_private_image_for_player",
	}
	knowledge["fact_sandra_chose_private_image_for_player"] = {
		"fact_id": "fact_sandra_chose_private_image_for_player", "source_type": "PRIVATE_TRACE",
		"source_ref": "j11_sandra_chosen_image_01", "initial_knowers": ["Sandra", "Player"],
		"certainty": "CONFIRMED", "shareability": "PRIVATE_DO_NOT_SHARE", "source_day": "J11",
		"access_mode": access_mode,
	}
	return true

func update_j11_sandra_image_access(access_mode: String) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or j11_pivot != "SANDRA" or access_mode not in ["view_only", "in_thread_allowed", "removed"]:
		return false
	var trace: Dictionary = traces.get("j11_sandra_chosen_image_01", {})
	var fact: Dictionary = knowledge.get("fact_sandra_chose_private_image_for_player", {})
	if trace.is_empty() or fact.is_empty():
		return false
	trace["current_state"] = "REMOVED" if access_mode == "removed" else "PRIVATE_ACTIVE"
	trace["current_audience"] = ["Sandra"] if access_mode == "removed" else ["Sandra", "Player"]
	trace["storage_location"] = "voir seulement" if access_mode == "view_only" else "fil Player / Sandra"
	trace["saving_rule"] = "VIEW_ONLY" if access_mode == "view_only" else "IN_THREAD_ONLY"
	fact["access_mode"] = access_mode
	traces["j11_sandra_chosen_image_01"] = trace
	knowledge["fact_sandra_chose_private_image_for_player"] = fact
	return true

func establish_j11_raphaelle_result() -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or j11_pivot != "RAPHAELLE":
		return false
	if j10_pivot_outcome == "PROFESSIONAL_BOUNDARY" or traces.has("j11_raphaelle_chosen_result_01") or knowledge.has("fact_raphaelle_chose_player_for_result_image"):
		return false
	traces["j11_raphaelle_chosen_result_01"] = {
		"trace_id": "j11_raphaelle_chosen_result_01", "trace_type": "PHOTO", "source_day": "J11",
		"source_scene": "Raphaëlle choisit le résultat pour Player", "creator": "Maud",
		"selected_by": "Raphaëlle", "controller": "Raphaëlle", "subjects": ["Raphaëlle"],
		"owner": "Raphaëlle", "initial_audience": ["Raphaëlle", "Maud"],
		"current_audience": ["Raphaëlle", "Maud", "Player"], "storage_location": "fil Player / Raphaëlle",
		"saving_rule": "IN_THREAD_ONLY", "transfer_rule": "FORBIDDEN", "current_state": "PRIVATE_ACTIVE",
		"knowledge_created": "fact_raphaelle_chose_player_for_result_image",
	}
	knowledge["fact_raphaelle_chose_player_for_result_image"] = {
		"fact_id": "fact_raphaelle_chose_player_for_result_image", "source_type": "PRIVATE_TRACE",
		"source_ref": "j11_raphaelle_chosen_result_01", "initial_knowers": ["Raphaëlle", "Maud", "Player"],
		"certainty": "CONFIRMED", "shareability": "PRIVATE_DO_NOT_SHARE", "source_day": "J11",
	}
	return true

func remove_j11_raphaelle_result() -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or j11_pivot != "RAPHAELLE":
		return false
	var trace: Dictionary = traces.get("j11_raphaelle_chosen_result_01", {})
	if trace.is_empty() or str(trace.get("current_state", "")) != "PRIVATE_ACTIVE":
		return false
	trace["current_state"] = "REMOVED"
	trace["current_audience"] = ["Raphaëlle", "Maud"]
	traces["j11_raphaelle_chosen_result_01"] = trace
	return true

func set_j11_raphaelle_outcome(outcome: String, attraction_named := false, reciprocal_consent := false, distinct_meeting := false) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or j11_pivot != "RAPHAELLE" or j11_pivot_outcome != "":
		return false
	if outcome not in ["FIRST_KISS", "KISS_DECLINED", "RESULT_SENT_ATTRACTION_NAMED", "RESULT_SENT_BOUNDARY_HELD"]:
		return false
	if not traces.has("j11_raphaelle_chosen_result_01") or not knowledge.has("fact_raphaelle_chose_player_for_result_image"):
		return false
	if outcome == "FIRST_KISS":
		if j10_pivot_outcome != "PROCESS_HELPED_VISIT_BOUNDED" or not attraction_named or not reciprocal_consent or not distinct_meeting:
			return false
		if _j11_p10_blocks_external_physical() or _has_due_obligation():
			return false
	j11_pivot_outcome = outcome
	j11_physical_level = "RAPHAELLE_FIRST_KISS" if outcome == "FIRST_KISS" else "NONE"
	return true

func establish_j11_marie_adult_event(reconquest_built: bool, consent_current: bool) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or j11_pivot != "MARIE" or j11_physical_level != "NONE":
		return false
	if not reconquest_built or not consent_current or j10_pivot != "NONE" or j10_pivot_outcome not in ["DUE_DINNER_PAID", "ORDINARY_MEAL_JOINED"]:
		return false
	var p10: Dictionary = promises.get("marie_j09_dinner_friday_2030", {})
	if not p10.is_empty() and str(p10.get("status", "")) != "PAID":
		return false
	if _has_due_obligation():
		return false
	j11_physical_level = "MARIE_ADULT_RECONQUEST"
	j11_pivot_outcome = "MARIE_ADULT_RECONQUEST"
	if not _create_j11_aftercare("aftercare_marie_j11", ["Marie", "Player"], "avant route extérieure ou convergence J12", "progression extérieure et convergence normale fermées"):
		j11_physical_level = "NONE"
		j11_pivot_outcome = ""
		return false
	return true

func resolve_j11_aftercare(obligation_id: String, resolution: String, paid_by: String) -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or obligation_id not in ["aftercare_mathilde_j11", "aftercare_marie_j11"]:
		return false
	if resolution not in ["PAID", "FAILED"]:
		return false
	var obligation: Dictionary = obligations.get(obligation_id, {})
	if str(obligation.get("status", "")) != "DUE":
		return false
	obligation["status"] = resolution
	obligation["paid_by"] = paid_by
	obligations[obligation_id] = obligation
	return true

func pay_j12_marie_aftercare() -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or j11_pivot_outcome != "MARIE_ADULT_RECONQUEST" or j11_physical_level != "MARIE_ADULT_RECONQUEST":
		return false
	var obligation: Dictionary = obligations.get("aftercare_marie_j11", {})
	if str(obligation.get("status", "")) != "DUE":
		return false
	obligation["status"] = "PAID"
	obligation["paid_by"] = "Marie et Player — aftercare matinal J12 présenté"
	obligation["paid_at"] = "J12 08:24"
	obligations["aftercare_marie_j11"] = obligation
	return true

func _create_j11_aftercare(obligation_id: String, people: Array, due_before: String, failure_effect: String) -> bool:
	if obligations.has(obligation_id):
		return false
	obligations[obligation_id] = {
		"obligation_id": obligation_id, "obligation_type": "AFTERCARE", "created_at": "J11",
		"concerned_people": people.duplicate(), "due_before": due_before, "status": "DUE",
		"paid_by": "", "failure_effect": failure_effect,
	}
	return true

func _has_due_obligation() -> bool:
	for obligation in obligations.values():
		if str(obligation.get("status", "")) == "DUE":
			return true
	return false

func _j11_p10_blocks_external_physical() -> bool:
	var p10: Dictionary = promises.get("marie_j09_dinner_friday_2030", {})
	return str(p10.get("status", "")) == "ACTIVE" or str(p10.get("j11_resolution", "")) == "MAINTAINED"

func _j11_selection_matches_j10(pivot: String, reason: String, source_pivot: String, source_outcome: String) -> bool:
	var mapping := {
		"SANDRA": {
			"CAFE_HELD_CALM_PRESENCE": ["RESPIRATION", "J10_NO_LEGITIMATE_CONTINUATION"],
			"CAFE_HELD_MISSING_NAMED": ["SANDRA", "J10_CONTINUATION"],
			"CAFE_HELD_FRIENDSHIP_BOUNDED": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE"],
			"CAFE_SATURDAY_CONDITIONAL": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE"],
			"CAFE_OPPORTUNITY_CLOSED": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE"],
		},
		"MATHILDE": {
			"OUTFIT_PRECISE_NON_APPROPRIATIVE": ["MATHILDE", "J10_CONTINUATION"],
			"OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED": ["MATHILDE", "J10_CONTINUATION"],
			"OUTFIT_PRACTICAL_WEATHER": ["RESPIRATION", "J10_NO_LEGITIMATE_CONTINUATION"],
		},
		"RAPHAELLE": {
			"PROCESS_HELPED_VISIT_BOUNDED": ["RAPHAELLE", "J10_CONTINUATION"],
			"PROCESS_HELPED_REMOTE": ["RAPHAELLE", "J10_CONTINUATION"],
			"RESULT_ONLY": ["RAPHAELLE", "J10_CONTINUATION"],
			"PROFESSIONAL_BOUNDARY": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE"],
		},
		"NICO": {
			"DIFFERENCE_ACKNOWLEDGED_NO_IMAGE": ["NICO", "J10_CONTINUATION"],
			"NICO_OBSERVATION_REQUESTED": ["NICO", "J10_CONTINUATION"],
			"COMPARISON_CLOSED": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE"],
			"THURSDAY_MEETING_CANCELLED": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE"],
		},
		"NONE": {
			"DUE_DINNER_PAID": ["MARIE", "J10_NONE_MARIE_FALLBACK"],
			"DUE_DINNER_FAILED_LATE": ["MARIE", "J10_NONE_MARIE_FALLBACK"],
			"DUE_DINNER_CANCELLED": ["MARIE", "J10_NONE_MARIE_FALLBACK"],
			"ORDINARY_MEAL_JOINED": ["MARIE", "J10_NONE_MARIE_FALLBACK"],
			"LATE_RETURN_SEPARATE": ["MARIE", "J10_NONE_MARIE_FALLBACK"],
			"ABSENCE_ANNOUNCED": ["MARIE", "J10_NONE_MARIE_FALLBACK"],
		},
	}
	return mapping.get(source_pivot, {}).get(source_outcome, []) == [pivot, reason]

func complete_j11() -> bool:
	if current_day != "J11" or day_status != "ACTIVE" or not _j11_records_consistent(snapshot()):
		return false
	if j11_pivot != "RESPIRATION" and j11_pivot_outcome == "":
		return false
	var mathilde_aftercare: Dictionary = obligations.get("aftercare_mathilde_j11", {})
	if not mathilde_aftercare.is_empty() and str(mathilde_aftercare.get("status", "")) not in ["PAID", "FAILED"]:
		return false
	var marie_aftercare: Dictionary = obligations.get("aftercare_marie_j11", {})
	if not marie_aftercare.is_empty() and str(marie_aftercare.get("status", "")) != "DUE":
		return false
	var p10: Dictionary = promises.get("marie_j09_dinner_friday_2030", {})
	if str(p10.get("status", "")) == "ACTIVE":
		return false
	var p11: Dictionary = promises.get("sandra_cafe_saturday_1100", {})
	if str(p11.get("status", "")) == "CONDITIONAL" and str(p11.get("counterparty_confirmed_at", "")) == "":
		return false
	var conversation_by_pivot := {
		"SANDRA": ["chapter_11_sandra_image", "sandra"],
		"MATHILDE": ["chapter_11_mathilde_return", "mathilde"],
		"RAPHAELLE": ["chapter_11_raphaelle_result", "raphaelle"],
		"NICO": ["chapter_11_nico_guardrail", "nico"],
		"MARIE": ["chapter_11_marie_return", "marie"],
	}
	if j11_pivot == "RESPIRATION":
		return complete_day()
	var completion: Array = conversation_by_pivot.get(j11_pivot, [])
	if completion.size() != 2 or not complete_conversation(str(completion[0]), str(completion[1]), "pivot"):
		return false
	return complete_day()

func begin_j12() -> bool:
	if current_day != "J11" or day_status != "COMPLETE" or not _j11_records_consistent(snapshot()):
		return false
	current_day = "J12"
	day_status = "ACTIVE"
	j12_presence_choice = "UNESTABLISHED"
	j12_private_outcome = "UNESTABLISHED"
	j12_annexe_choice = "UNESTABLISHED"
	j12_priority_route = "UNESTABLISHED"
	j12_failed_aftercare_processed = false
	return true

func mark_j12_failed_aftercare_processed() -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or j12_failed_aftercare_processed:
		return false
	var obligation: Dictionary = obligations.get("aftercare_mathilde_j11", {})
	if str(obligation.get("status", "")) != "FAILED":
		return false
	j12_failed_aftercare_processed = true
	mathilde_state = "TRUST_BROKEN"
	return true

func apply_j12_choice(choice_id: String) -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or choice_id == "" or selected_choice_ids.has(choice_id):
		return false
	if choice_id in ["choice_j12_p11_confirm", "choice_j12_p11_refuse"]:
		var p11: Dictionary = promises.get("sandra_cafe_saturday_1100", {})
		if str(p11.get("status", "")) != "CONDITIONAL" or str(p11.get("counterparty_confirmed_by", "")) != "Sandra":
			return false
		if choice_id == "choice_j12_p11_confirm":
			p11["status"] = "ACTIVE"
			p11["accepted_at"] = "J12 09:19"
			p11["accepted_by_player"] = true
			p11["outcome"] = "ACCEPTED_BY_PLAYER"
		else:
			p11["status"] = "REFUSED"
			p11["paid_or_closed_at"] = "J12 09:19"
			p11["paid_or_closed_by"] = "Player"
			p11["outcome"] = "REFUSED_BY_PLAYER"
		promises["sandra_cafe_saturday_1100"] = p11
	elif choice_id.begins_with("choice_j12_presence_"):
		if j12_presence_choice != "UNESTABLISHED": return false
		j12_presence_choice = {"choice_j12_presence_la":"L-A","choice_j12_presence_lb":"L-B","choice_j12_presence_lc":"L-C"}.get(choice_id, "")
		if j12_presence_choice == "": return false
		var presence_due_at := str({"L-A":"J12 17:45","L-B":"J12 19:15","L-C":"J12 20:15–21:15"}[j12_presence_choice])
		promises["marie_j12_laverriere_presence"] = {"promise_id":"marie_j12_laverriere_presence","promise_type":"PRESENCE","created_at":"J12 14:42","created_by":"Marie","proposed_to":"Player","accepted_at":"J12 14:45","accepted_by_player":true,"due_at":presence_due_at,"confirmation_deadline":"avant l’heure d’arrivée","status":"ACTIVE","paid_or_closed_at":"","paid_or_closed_by":"","outcome":j12_presence_choice,"related_scene":"S23 La Verrière puis L’Annexe","related_trace_ids":["j12_laverriere_public_group_set_01"]}
	elif choice_id.begins_with("choice_j12_sandra_") or choice_id.begins_with("choice_j12_mathilde_") or choice_id.begins_with("choice_j12_raphaelle_") or choice_id.begins_with("choice_j12_marie_"):
		if j12_private_outcome != "UNESTABLISHED": return false
		var private_outcome := str({
			"choice_j12_sandra_clear": "SANDRA_RESPONSE_CLEAR",
			"choice_j12_sandra_delay": "SANDRA_RESPONSE_DELAYED",
			"choice_j12_sandra_exit": "SANDRA_EXIT_CLEAN",
			"choice_j12_raphaelle_declined_hold": "RAPHAELLE_PUBLIC",
			"choice_j12_raphaelle_boundary_hold": "RAPHAELLE_PUBLIC",
		}.get(choice_id, choice_id.trim_prefix("choice_j12_").to_upper()))
		if choice_id == "choice_j12_sandra_exit" and knowledge.has("fact_j12_unusual_behavior_observed"): return false
		if choice_id.begins_with("choice_j12_sandra_") and not traces.has("j12_sandra_public_context_view_01") and not establish_j12_sandra_public_context_view(): return false
		if choice_id == "choice_j12_sandra_exit" and not establish_j12_unusual_behavior("PLAYER_LEFT_ROOM_AT_LAVERRIERE_PUBLICATION", ["Marie"], choice_id): return false
		j12_private_outcome = private_outcome
	elif choice_id.begins_with("choice_j12_annexe_"):
		if j12_annexe_choice != "UNESTABLISHED": return false
		j12_annexe_choice = choice_id.trim_prefix("choice_j12_annexe_").to_upper()
		var annexe_accepted := j12_annexe_choice != "C12"
		promises["j12_annexe_continuation"] = {"promise_id":"j12_annexe_continuation","promise_type":"PRESENCE","created_at":"J12 22:22","created_by":"groupe La Verrière / Nico","proposed_to":"Player","accepted_at":"J12 22:22" if annexe_accepted else "","accepted_by_player":annexe_accepted,"due_at":"J12 22:50","confirmation_deadline":"avant le déplacement du groupe","status":"ACTIVE" if annexe_accepted else "REFUSED","paid_or_closed_at":"" if annexe_accepted else "J12 22:22","paid_or_closed_by":"" if annexe_accepted else "Player","outcome":j12_annexe_choice,"action_due":"rester jusqu’à minuit" if j12_annexe_choice == "A12" else ("rester jusqu’à 23:15" if j12_annexe_choice == "B12" else "refus explicite"),"related_scene":"continuation L’Annexe","related_trace_ids":["j12_annexe_public_group_set_01"]}
	elif choice_id.begins_with("choice_j12_nico_"):
		if j12_private_outcome != "UNESTABLISHED": return false
		if j11_pivot_outcome == "NICO_RIVALRY_MAINTAINED":
			if knowledge.has("fact_j12_unusual_behavior_observed"): return false
			if not establish_j12_unusual_behavior("PLAYER_WATCHED_NICO_TALK_TO_MARIE", ["Nico"], choice_id): return false
		j12_private_outcome = choice_id.trim_prefix("choice_j12_").to_upper()
	else:
		return false
	selected_choice_ids.append(choice_id)
	return true

func pay_j12_p11() -> bool:
	if current_day != "J12" or day_status != "ACTIVE": return false
	var p11: Dictionary = promises.get("sandra_cafe_saturday_1100", {})
	if str(p11.get("status", "")) != "ACTIVE": return false
	p11["status"] = "PAID"
	p11["paid_or_closed_at"] = "J12 11:30"
	p11["paid_or_closed_by"] = "Player et Sandra hors téléphone"
	p11["outcome"] = "CAFE_HELD"
	promises["sandra_cafe_saturday_1100"] = p11
	return true

func expire_j12_p11_player_confirmation() -> bool:
	if current_day != "J12" or day_status != "ACTIVE": return false
	var p11: Dictionary = promises.get("sandra_cafe_saturday_1100", {})
	if str(p11.get("status", "")) != "CONDITIONAL" or str(p11.get("counterparty_confirmed_by", "")) != "Sandra" or bool(p11.get("accepted_by_player", false)): return false
	p11["status"] = "EXPIRED"; p11["paid_or_closed_at"] = "J12 09:30"; p11["paid_or_closed_by"] = "player_confirmation_deadline"; p11["outcome"] = "EXPIRED_PLAYER_NOT_CONFIRMED"
	promises["sandra_cafe_saturday_1100"] = p11
	return true

func pay_j12_laverriere_presence() -> bool:
	if current_day != "J12" or day_status != "ACTIVE": return false
	var presence: Dictionary = promises.get("marie_j12_laverriere_presence", {})
	if str(presence.get("status", "")) != "ACTIVE" or str(presence.get("outcome", "")) != j12_presence_choice: return false
	presence["status"] = "PAID"; presence["paid_or_closed_at"] = "J12 21:15" if j12_presence_choice == "L-C" else "J12 22:15"; presence["paid_or_closed_by"] = "arrivée et durée réelles de Player"
	promises["marie_j12_laverriere_presence"] = presence
	return true

func pay_j12_annexe_continuation() -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or j12_annexe_choice not in ["A12", "B12"]: return false
	var annexe: Dictionary = promises.get("j12_annexe_continuation", {})
	if str(annexe.get("status", "")) != "ACTIVE" or str(annexe.get("outcome", "")) != j12_annexe_choice: return false
	annexe["status"] = "PAID"; annexe["paid_or_closed_at"] = "J12 22:50"; annexe["paid_or_closed_by"] = "arrivée de Player avec le groupe"
	promises["j12_annexe_continuation"] = annexe
	return true

func establish_j12_laverriere_public_trace() -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or j12_presence_choice == "UNESTABLISHED" or traces.has("j12_laverriere_public_group_set_01") or knowledge.has("fact_j12_laverriere_participants"):
		return false
	var subjects := _j12_laverriere_subjects()
	traces["j12_laverriere_public_group_set_01"] = {"trace_id":"j12_laverriere_public_group_set_01","trace_type":"PHOTO_SET","source_day":"J12","source_scene":"convergence La Verrière","creator":"Élodie","subjects":subjects.duplicate(),"owner":"La Verrière","initial_audience":subjects.duplicate(),"current_audience":subjects.duplicate(),"storage_location":"canal La Verrière nommé","saving_rule":"PUBLIC_SOURCE_RULES","transfer_rule":"PUBLIC_SOURCE_RULES","current_state":"PUBLIC_ACTIVE","knowledge_created":"fact_j12_laverriere_participants","eligible_for_j14":true,"eligible_for_j21":true,"player_present":true,"player_photographed":true}
	knowledge["fact_j12_laverriere_participants"] = {"fact_id":"fact_j12_laverriere_participants","source_type":"PUBLIC_TRACE","source_ref":"j12_laverriere_public_group_set_01","initial_knowers":subjects.duplicate(),"current_knowers":subjects.duplicate(),"certainty":"OBSERVED","shareability":"PUBLIC","participants":subjects.duplicate(),"source_day":"J12"}
	return true

func establish_j12_annexe_public_trace() -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or j12_annexe_choice == "UNESTABLISHED" or traces.has("j12_annexe_public_group_set_01") or knowledge.has("fact_j12_annexe_participants"):
		return false
	var records := _j12_annexe_public_records()
	if records.is_empty(): return false
	traces["j12_annexe_public_group_set_01"] = records["trace"]
	knowledge["fact_j12_annexe_participants"] = records["fact"]
	return true

func pay_and_establish_j12_annexe_arrival() -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or j12_annexe_choice not in ["A12", "B12"]: return false
	if traces.has("j12_annexe_public_group_set_01") or knowledge.has("fact_j12_annexe_participants"): return false
	var annexe: Dictionary = promises.get("j12_annexe_continuation", {})
	if str(annexe.get("status", "")) != "ACTIVE" or str(annexe.get("outcome", "")) != j12_annexe_choice: return false
	var records := _j12_annexe_public_records()
	if records.is_empty(): return false
	var paid_annexe := annexe.duplicate(true)
	paid_annexe["status"] = "PAID"; paid_annexe["paid_or_closed_at"] = "J12 22:50"; paid_annexe["paid_or_closed_by"] = "arrivée de Player avec le groupe"
	promises["j12_annexe_continuation"] = paid_annexe
	traces["j12_annexe_public_group_set_01"] = records["trace"]
	knowledge["fact_j12_annexe_participants"] = records["fact"]
	return true

func _j12_annexe_public_records() -> Dictionary:
	if j12_annexe_choice not in ["A12", "B12", "C12"]: return {}
	var subjects: Array = ["Marie", "Pauline", "Bastien", "Nico"]
	if j12_annexe_choice in ["A12", "B12"]: subjects.append("Player")
	var current_audience := subjects.duplicate()
	if j12_annexe_choice == "C12": current_audience.append("Player")
	return {
		"trace":{"trace_id":"j12_annexe_public_group_set_01","trace_type":"PHOTO_SET","source_day":"J12","source_scene":"continuation sociale à L’Annexe","creator":"Sophie","subjects":subjects.duplicate(),"owner":"Sophie","initial_audience":subjects.duplicate(),"current_audience":current_audience.duplicate(),"storage_location":"fil social / dossier L’Annexe","saving_rule":"PUBLIC_SOURCE_RULES","transfer_rule":"PUBLIC_SOURCE_RULES","current_state":"PUBLIC_ACTIVE","knowledge_created":"fact_j12_annexe_participants","eligible_for_j14":true,"eligible_for_j21":true,"player_present":j12_annexe_choice != "C12","player_photographed":j12_annexe_choice != "C12","player_received_trace":true},
		"fact":{"fact_id":"fact_j12_annexe_participants","source_type":"PUBLIC_TRACE","source_ref":"j12_annexe_public_group_set_01","initial_knowers":subjects.duplicate(),"current_knowers":current_audience.duplicate(),"certainty":"OBSERVED","shareability":"SAME_AUDIENCE_ONLY","participants":subjects.duplicate(),"source_day":"J12","player_present":j12_annexe_choice != "C12","player_received_trace":true},
	}

func establish_j12_sandra_public_context_view() -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or j11_pivot != "SANDRA" or j11_pivot_outcome not in ["SANDRA_RULE_CLARIFIED", "SANDRA_DESIRE_BOUNDED"]: return false
	if traces.has("j12_sandra_public_context_view_01") or knowledge.has("fact_sandra_saw_public_j12_context"): return false
	var public_trace: Dictionary = traces.get("j12_laverriere_public_group_set_01", {})
	var private_trace: Dictionary = traces.get("j11_sandra_chosen_image_01", {})
	if public_trace.is_empty() or str(public_trace.get("current_state", "")) != "PUBLIC_ACTIVE" or str(private_trace.get("current_state", "")) == "REMOVED": return false
	var subjects: Array = public_trace.get("subjects", []).duplicate()
	var audience: Array = public_trace.get("current_audience", []).duplicate()
	if not audience.has("Sandra"): audience.append("Sandra")
	traces["j12_sandra_public_context_view_01"] = {"trace_id":"j12_sandra_public_context_view_01","trace_type":"NOTIFICATION","source_day":"J12","source_scene":"Sandra absente voyant la publication La Verrière","creator":"canal public La Verrière","subjects":subjects,"owner":"source publique","initial_audience":audience.duplicate(),"current_audience":audience.duplicate(),"storage_location":"source publique La Verrière","saving_rule":"PUBLIC_SOURCE_RULES","transfer_rule":"PUBLIC_SOURCE_RULES","current_state":"ACTIVE","knowledge_created":"fact_sandra_saw_public_j12_context","eligible_for_j14":false,"eligible_for_j21":false,"player_present":subjects.has("Player")}
	knowledge["fact_sandra_saw_public_j12_context"] = {"fact_id":"fact_sandra_saw_public_j12_context","source_type":"PUBLIC_TRACE","source_ref":"j12_sandra_public_context_view_01","initial_knowers":["Sandra"],"current_knowers":["Sandra"],"certainty":"OBSERVED","shareability":"PUBLIC_SOURCE_RULES","source_day":"J12"}
	return true

func establish_j12_unusual_behavior(observed_value: String, knowers: Array, source_event_id: String) -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or observed_value == "" or knowers.is_empty() or source_event_id == "" or knowledge.has("fact_j12_unusual_behavior_observed"): return false
	knowledge["fact_j12_unusual_behavior_observed"] = {"fact_id":"fact_j12_unusual_behavior_observed","source_type":"DIRECT_OBSERVATION","source_ref":observed_value,"source_event_id":source_event_id,"value":observed_value,"initial_knowers":knowers.duplicate(),"current_knowers":knowers.duplicate(),"certainty":"OBSERVED","meaning_certainty":"INFERRED","shareability":"FACTUAL_ONLY","source_day":"J12"}
	return true

func _j12_laverriere_subjects() -> Array:
	return J12_LAVERRIERE_EXPLICIT_SUBJECTS.duplicate()

func establish_j12_priority_consequence(route: String) -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or route not in ["SANDRA","MATHILDE","RAPHAELLE","NICO","MARIE","NETWORK"] or j12_priority_route != "UNESTABLISHED" or obligations.has("j12_priority_consequence_j13"):
		return false
	var priority_contract := _j12_priority_contract(route, obligations)
	if priority_contract.is_empty(): return false
	j12_priority_route = route
	priority_contract["status"] = "DUE"; priority_contract["paid_by"] = ""; priority_contract["paid_or_closed_at"] = ""
	obligations["j12_priority_consequence_j13"] = priority_contract
	return true

func complete_j12() -> bool:
	if current_day != "J12" or day_status != "ACTIVE" or not _j12_records_consistent(snapshot()): return false
	var presence: Dictionary = promises.get("marie_j12_laverriere_presence", {})
	if str(presence.get("status", "")) != "PAID": return false
	var annexe: Dictionary = promises.get("j12_annexe_continuation", {})
	if str(annexe.get("status", "")) not in ["PAID", "REFUSED"]: return false
	var p11: Dictionary = promises.get("sandra_cafe_saturday_1100", {})
	if not p11.is_empty() and str(p11.get("status", "")) not in ["PAID", "REFUSED", "EXPIRED"]: return false
	if not complete_conversation("chapter_12_laverriere", "marie", "network_pivot"): return false
	return complete_day()

func begin_j13() -> bool:
	if current_day != "J12" or day_status != "COMPLETE" or not _j12_records_consistent(snapshot()): return false
	current_day = "J13"; day_status = "ACTIVE"; j13_pivot = ""; j13_outcome = "UNESTABLISHED"; j13_j14_trace_id = ""
	return true

func set_j13_priority(pivot: String) -> bool:
	if current_day != "J13" or day_status != "ACTIVE" or j13_pivot != "" or pivot not in ["PAULINE","RAPHAELLE","NICO","SANDRA","MATHILDE","MARIE","RESPIRATION"]: return false
	var obligation: Dictionary = obligations.get("j12_priority_consequence_j13", {})
	var expected_route := "NETWORK" if pivot in ["PAULINE", "RESPIRATION"] else pivot
	if str(obligation.get("status", "")) != "DUE" or str(obligation.get("route", "")) != expected_route or expected_route != j12_priority_route: return false
	if pivot == "SANDRA" and j11_pivot_outcome == "SANDRA_IMAGE_REMOVED": return false
	if pivot == "NICO" and j11_pivot_outcome == "NICO_CLEAN_CLOSE": return false
	if pivot == "PAULINE" and not j13_pauline_eligible(): return false
	if pivot == "RESPIRATION" and j13_pauline_eligible(): return false
	j13_pivot = pivot
	return true

func j13_pauline_eligible() -> bool:
	if j11_pivot != "RESPIRATION" or j11_pivot_outcome != "" or j12_private_outcome != "UNESTABLISHED" or j12_annexe_choice not in ["A12", "B12"]: return false
	if not completed_conversation_ids.has("chapter_12_laverriere"): return false
	for obligation_id in obligations:
		if obligation_id == "j12_priority_consequence_j13": continue
		if str(obligations[obligation_id].get("status", "")) in ["DUE", "FAILED"]: return false
	var laverriere: Dictionary = traces.get("j12_laverriere_public_group_set_01", {})
	var annexe: Dictionary = traces.get("j12_annexe_public_group_set_01", {})
	if str(laverriere.get("current_state", "")) != "PUBLIC_ACTIVE" or str(annexe.get("current_state", "")) != "PUBLIC_ACTIVE": return false
	for person in ["Player", "Pauline", "Bastien"]:
		if not laverriere.get("subjects", []).has(person) or not laverriere.get("current_audience", []).has(person): return false
		if not annexe.get("subjects", []).has(person) or not annexe.get("current_audience", []).has(person): return false
	return bool(annexe.get("player_present", false)) and bool(annexe.get("player_received_trace", false))

func j13_raphaelle_standard_image_eligible() -> bool:
	return _j13_raphaelle_standard_eligible_in(snapshot())

func _j13_raphaelle_standard_eligible_in(value: Dictionary) -> bool:
	if str(value.get("j11_pivot_outcome", "")) not in ["FIRST_KISS", "RESULT_SENT_ATTRACTION_NAMED"] or str(value.get("j12_private_outcome", "")) not in ["RAPHAELLE_PUBLIC", "RAPHAELLE_DELAY"]: return false
	var source: Dictionary = value.get("traces", {}).get("j11_raphaelle_chosen_result_01", {})
	return str(source.get("creator", "")) == "Maud" and str(source.get("selected_by", "")) == "Raphaëlle" and str(source.get("current_state", "")) == "PRIVATE_ACTIVE" and source.get("current_audience", []).has("Player")

func deliver_j13_priority(pivot: String, segment_id: String) -> bool:
	if current_day != "J13" or day_status != "ACTIVE" or pivot != j13_pivot or j13_outcome != "UNESTABLISHED": return false
	if pivot == "PAULINE":
		if segment_id != "j13_pauline" or not j13_pauline_eligible() or traces.has("j13_pauline_private_version_01") or knowledge.has("fact_pauline_created_private_double_address"): return false
		traces["j13_pauline_private_version_01"] = {"trace_id":"j13_pauline_private_version_01","trace_type":"PHOTO","asset_id":"S1_A4_J13_DPH_PAULINE_PRIVATE_VERSION_01","source_day":"J13","source_scene":"S24 Les deux versions","parent_content_id":"C12-03","parent_asset_id":"S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01","creator":"Pauline","selected_by":"Pauline","subjects":["Pauline"],"owner":"Pauline","initial_audience":["Pauline"],"current_audience":["Pauline","Player"],"storage_location":"fil Player / Pauline","saving_rule":"IN_THREAD_ONLY","transfer_rule":"FORBIDDEN","current_state":"PRIVATE_ACTIVE","knowledge_created":"fact_pauline_created_private_double_address","eligible_for_j14":true}
		knowledge["fact_pauline_created_private_double_address"] = {"fact_id":"fact_pauline_created_private_double_address","source_type":"PRIVATE_TRACE","source_ref":"j13_pauline_private_version_01","initial_knowers":["Pauline","Player"],"current_knowers":["Pauline","Player"],"certainty":"CONFIRMED","shareability":"PRIVATE_DO_NOT_SHARE","source_day":"J13"}
		return true
	if pivot == "RAPHAELLE" and segment_id == "j13_raphaelle":
		if not j13_raphaelle_standard_image_eligible() or traces.has("j13_raphaelle_masked_version_01") or knowledge.has("fact_raphaelle_chose_player_for_masked_posture_image"): return false
		traces["j13_raphaelle_masked_version_01"] = {"trace_id":"j13_raphaelle_masked_version_01","trace_type":"PHOTO","asset_id":"S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01","source_day":"J13","source_scene":"S25 Le masque change la posture","creator":"Maud","selected_by":"Raphaëlle","subjects":["Raphaëlle"],"owner":"Raphaëlle","initial_audience":["Raphaëlle","Maud"],"current_audience":["Raphaëlle","Maud","Player"],"storage_location":"fil Player / Raphaëlle","saving_rule":"IN_THREAD_ONLY","transfer_rule":"FORBIDDEN","current_state":"PRIVATE_ACTIVE","knowledge_created":"fact_raphaelle_chose_player_for_masked_posture_image","eligible_for_j14":true}
		knowledge["fact_raphaelle_chose_player_for_masked_posture_image"] = {"fact_id":"fact_raphaelle_chose_player_for_masked_posture_image","source_type":"PRIVATE_TRACE","source_ref":"j13_raphaelle_masked_version_01","initial_knowers":["Raphaëlle","Maud","Player"],"current_knowers":["Raphaëlle","Maud","Player"],"certainty":"CONFIRMED","shareability":"PRIVATE_DO_NOT_SHARE","source_day":"J13"}
		return true
	var allowed_segments := {
		"SANDRA":["j13_sandra_clear","j13_sandra_delayed","j13_sandra_exit"],
		"MATHILDE":["j13_mathilde_look","j13_mathilde_m_b1","j13_mathilde_m_b2","j13_mathilde_m_b3","j13_mathilde_clean_stop","j13_mathilde_distance","j13_mathilde_failed"],
		"RAPHAELLE":["j13_raphaelle_boundary","j13_raphaelle_pressed"],
		"NICO":["j13_nico_guardrail","j13_nico_rivalry"],
		"MARIE":["j13_marie_close","j13_marie_non_adult","j13_marie_no_bandage","j13_marie_distance"],
		"RESPIRATION":["j13_respiration"],
	}
	return allowed_segments.get(pivot, []).has(segment_id)

func apply_j13_choice(choice_id: String, pivot: String) -> bool:
	if current_day != "J13" or day_status != "ACTIVE" or pivot != j13_pivot or j13_outcome != "UNESTABLISHED" or choice_id == "" or selected_choice_ids.has(choice_id): return false
	var prefix: String = str({"PAULINE":"choice_j13_pauline_","RAPHAELLE":"choice_j13_raphaelle_","NICO":"choice_j13_nico_","SANDRA":"choice_j13_sandra_","MATHILDE":"choice_j13_mathilde_","MARIE":"choice_j13_marie_","RESPIRATION":"choice_j13_respiration_"}.get(pivot, ""))
	if not choice_id.begins_with(str(prefix)): return false
	var obligation: Dictionary = obligations.get("j12_priority_consequence_j13", {})
	var expected_route := "NETWORK" if pivot in ["PAULINE", "RESPIRATION"] else pivot
	if str(obligation.get("status", "")) != "DUE" or str(obligation.get("route", "")) != expected_route: return false
	var resolution := _j13_resolution_for_choice(choice_id)
	if resolution == "" or not _j13_choice_allowed_for_snapshot(choice_id, pivot, snapshot()): return false
	if pivot == "PAULINE" and not traces.has("j13_pauline_private_version_01"): return false
	if pivot == "RAPHAELLE" and j13_raphaelle_standard_image_eligible() and choice_id in ["choice_j13_raphaelle_process", "choice_j13_raphaelle_effect", "choice_j13_raphaelle_product"] and not traces.has("j13_raphaelle_masked_version_01"): return false
	if pivot == "NICO" and (traces.has("j13_nico_alibi_or_hour_message_01") or knowledge.has("fact_nico_knows_specific_hour_or_alibi_request")): return false
	j13_outcome = choice_id.trim_prefix("choice_j13_").to_upper(); selected_choice_ids.append(choice_id)
	obligation["status"] = resolution; obligation["paid_by"] = "Player"; obligation["paid_or_closed_at"] = "J13 priority response"; obligations["j12_priority_consequence_j13"] = obligation
	if choice_id == "choice_j13_pauline_refuse": _close_j13_trace("j13_pauline_private_version_01")
	if choice_id == "choice_j13_raphaelle_product": _close_j13_trace("j13_raphaelle_masked_version_01")
	if choice_id in ["choice_j13_sandra_clear_more", "choice_j13_sandra_delayed_more", "choice_j13_sandra_exit_more"]:
		var sandra_trace: Dictionary = traces.get("j11_sandra_chosen_image_01", {}); var sandra_fact: Dictionary = knowledge.get("fact_sandra_chose_private_image_for_player", {})
		if not sandra_trace.is_empty(): sandra_trace["current_state"] = "REMOVED"; sandra_trace["current_audience"] = ["Sandra"]; traces["j11_sandra_chosen_image_01"] = sandra_trace
		if not sandra_fact.is_empty(): sandra_fact["access_mode"] = "removed"; knowledge["fact_sandra_chose_private_image_for_player"] = sandra_fact
	if pivot == "NICO":
		var nico_subjects := ["Nico","Player"]
		if choice_id.begins_with("choice_j13_nico_rivalry_"): nico_subjects.append("Marie")
		var request_or_boundary := "ALIBI_REQUEST" if choice_id.ends_with("_alibi") else ("COVERAGE_CLOSED" if choice_id.ends_with("_close") else "TRUTH_LIMIT")
		traces["j13_nico_alibi_or_hour_message_01"] = {"trace_id":"j13_nico_alibi_or_hour_message_01","trace_type":"TEXT_MESSAGE","source_day":"J13","source_scene":"S26 Nico borne la vérité, l’alibi ou la couverture","creator":"Player et Nico","subjects":nico_subjects,"owner":"Nico","initial_audience":["Nico","Player"],"current_audience":["Nico","Player"],"storage_location":"fil Player / Nico","saving_rule":"IN_THREAD_ONLY","transfer_rule":"FORBIDDEN","current_state":"ACTIVE","knowledge_created":"fact_nico_knows_specific_hour_or_alibi_request","eligible_for_j14":true,"choice_source":choice_id}
		knowledge["fact_nico_knows_specific_hour_or_alibi_request"] = {"fact_id":"fact_nico_knows_specific_hour_or_alibi_request","source_type":"DIRECT_MESSAGE","source_ref":"j13_nico_alibi_or_hour_message_01","initial_knowers":["Nico","Player"],"current_knowers":["Nico","Player"],"certainty":"TOLD_DIRECTLY","shareability":"FACTUAL_ONLY","source_day":"J13","source_choice_id":choice_id,"request_or_boundary":request_or_boundary}
	_j13_select_j14_trace()
	return true

func _j13_resolution_for_choice(choice_id: String) -> String:
	var closed := ["choice_j13_pauline_refuse", "choice_j13_nico_guardrail_close", "choice_j13_nico_rivalry_close", "choice_j13_sandra_exit_ack", "choice_j13_mathilde_look_distance", "choice_j13_mathilde_m_b1_distance", "choice_j13_mathilde_clean_stop_ack", "choice_j13_mathilde_distance_ack", "choice_j13_marie_distance_space", "choice_j13_raphaelle_boundary_work"]
	var failed := ["choice_j13_raphaelle_product", "choice_j13_raphaelle_insist_pressure", "choice_j13_raphaelle_boundary_pressure", "choice_j13_nico_guardrail_alibi", "choice_j13_nico_rivalry_alibi", "choice_j13_sandra_clear_more", "choice_j13_sandra_delayed_more", "choice_j13_sandra_exit_more", "choice_j13_mathilde_look_minimize", "choice_j13_mathilde_m_b1_minimize", "choice_j13_mathilde_m_b2_minimize", "choice_j13_mathilde_m_b3_minimize", "choice_j13_mathilde_clean_stop_reopen", "choice_j13_mathilde_distance_reopen", "choice_j13_mathilde_failed_explain", "choice_j13_mathilde_failed_contest", "choice_j13_marie_close_proof", "choice_j13_marie_non_adult_proof", "choice_j13_marie_no_bandage_proof", "choice_j13_marie_distance_proof"]
	var paid := ["choice_j13_pauline_rule", "choice_j13_pauline_address", "choice_j13_raphaelle_process", "choice_j13_raphaelle_effect", "choice_j13_raphaelle_ack_pressure", "choice_j13_raphaelle_explain_pressure", "choice_j13_raphaelle_boundary_ack", "choice_j13_nico_guardrail_truth", "choice_j13_nico_rivalry_truth", "choice_j13_sandra_clear_confirm", "choice_j13_sandra_clear_withdraw", "choice_j13_sandra_delayed_confirm", "choice_j13_sandra_delayed_withdraw", "choice_j13_sandra_exit_rule", "choice_j13_mathilde_look_rule", "choice_j13_mathilde_m_b1_rule", "choice_j13_mathilde_m_b2_rule", "choice_j13_mathilde_m_b2_debt", "choice_j13_mathilde_m_b3_rule", "choice_j13_mathilde_m_b3_debt", "choice_j13_mathilde_clean_stop_ordinary", "choice_j13_mathilde_distance_ordinary", "choice_j13_mathilde_failed_accept", "choice_j13_marie_close_truth", "choice_j13_marie_close_walk", "choice_j13_marie_non_adult_truth", "choice_j13_marie_non_adult_walk", "choice_j13_marie_no_bandage_truth", "choice_j13_marie_no_bandage_ordinary", "choice_j13_marie_distance_truth", "choice_j13_respiration_bread", "choice_j13_respiration_walk", "choice_j13_respiration_alone"]
	if choice_id in closed: return "CLOSED"
	if choice_id in failed: return "FAILED"
	if choice_id in paid: return "PAID"
	return ""

func _j13_choice_allowed_for_snapshot(choice_id: String, pivot: String, value: Dictionary) -> bool:
	var private_outcome := str(value.get("j12_private_outcome", "")); var j11_outcome := str(value.get("j11_pivot_outcome", "")); var obligation: Dictionary = value.get("obligations", {}).get("j12_priority_consequence_j13", {})
	match pivot:
		"PAULINE": return choice_id.begins_with("choice_j13_pauline_")
		"RESPIRATION": return choice_id.begins_with("choice_j13_respiration_")
		"SANDRA":
			var sandra_prefix := str({"SANDRA_RESPONSE_CLEAR":"choice_j13_sandra_clear_", "SANDRA_RESPONSE_DELAYED":"choice_j13_sandra_delayed_", "SANDRA_EXIT_CLEAN":"choice_j13_sandra_exit_"}.get(private_outcome, ""))
			return sandra_prefix != "" and choice_id.begins_with(sandra_prefix)
		"MATHILDE":
			var mathilde_variant := "failed" if str(obligation.get("origin", "")) == "MATHILDE_HOUSEHOLD_AFTERCARE" else str({"MATHILDE_LOOK_ONLY":"look", "MATHILDE_M_B1":"m_b1", "MATHILDE_M_B2":"m_b2", "MATHILDE_M_B3":"m_b3", "MATHILDE_CLEAN_STOP":"clean_stop", "MATHILDE_DISTANCE_RESTORED":"distance"}.get(j11_outcome, ""))
			return mathilde_variant != "" and choice_id.begins_with("choice_j13_mathilde_" + mathilde_variant + "_")
		"RAPHAELLE":
			if private_outcome == "RAPHAELLE_NOW": return choice_id in ["choice_j13_raphaelle_ack_pressure", "choice_j13_raphaelle_explain_pressure", "choice_j13_raphaelle_insist_pressure"]
			if j11_outcome in ["KISS_DECLINED", "RESULT_SENT_BOUNDARY_HELD"] or not _j13_raphaelle_standard_eligible_in(value): return choice_id in ["choice_j13_raphaelle_boundary_ack", "choice_j13_raphaelle_boundary_work", "choice_j13_raphaelle_boundary_pressure"]
			return choice_id in ["choice_j13_raphaelle_process", "choice_j13_raphaelle_effect", "choice_j13_raphaelle_product"]
		"NICO":
			var nico_variant := str({"NICO_GUARDRAIL_HELD":"guardrail", "NICO_RIVALRY_MAINTAINED":"rivalry"}.get(j11_outcome, ""))
			return nico_variant != "" and choice_id.begins_with("choice_j13_nico_" + nico_variant + "_")
		"MARIE":
			var marie_variant := str({"MARIE_ADULT_RECONQUEST":"close", "MARIE_NON_ADULT_RECONNECTION":"non_adult", "MARIE_SEX_NOT_USED_AS_BANDAGE":"no_bandage", "MARIE_HONEST_REFUSAL":"distance", "MARIE_NO_RECONQUEST":"distance"}.get(j11_outcome, ""))
			return marie_variant != "" and choice_id.begins_with("choice_j13_marie_" + marie_variant + "_")
	return false

func _close_j13_trace(trace_id: String) -> void:
	var trace: Dictionary = traces.get(trace_id, {})
	if not trace.is_empty(): trace["current_state"] = "REMOVED"; trace["current_audience"] = [trace.get("owner", "")]; traces[trace_id] = trace

func _j13_select_j14_trace() -> void:
	var public_trace_id := "j12_laverriere_public_group_set_01"
	match j13_pivot:
		"PAULINE": j13_j14_trace_id = "j13_pauline_private_version_01" if _j13_trace_accessible_for_j14("j13_pauline_private_version_01") else public_trace_id
		"RAPHAELLE": j13_j14_trace_id = "j13_raphaelle_masked_version_01" if _j13_trace_accessible_for_j14("j13_raphaelle_masked_version_01") else public_trace_id
		"NICO": j13_j14_trace_id = "j13_nico_alibi_or_hour_message_01" if _j13_trace_accessible_for_j14("j13_nico_alibi_or_hour_message_01") else public_trace_id
		"SANDRA": j13_j14_trace_id = "j11_sandra_chosen_image_01" if _j13_trace_accessible_for_j14("j11_sandra_chosen_image_01") else public_trace_id
		"MATHILDE": j13_j14_trace_id = "j11_mathilde_physical_aftercare_01" if _j13_trace_accessible_for_j14("j11_mathilde_physical_aftercare_01") else public_trace_id
		_: j13_j14_trace_id = public_trace_id
	if not _j13_trace_accessible_for_j14(j13_j14_trace_id): j13_j14_trace_id = ""

func _j13_trace_accessible_for_j14(trace_id: String) -> bool:
	var trace: Dictionary = traces.get(trace_id, {})
	if trace.is_empty() or str(trace.get("current_state", "")) in ["REMOVED", "INACCESSIBLE", "NOT_CREATED"]: return false
	var canonical_legacy := trace_id in ["j11_sandra_chosen_image_01", "j11_mathilde_physical_aftercare_01"]
	if not bool(trace.get("eligible_for_j14", canonical_legacy)): return false
	return str(trace.get("current_state", "")) == "PUBLIC_ACTIVE" or trace.get("current_audience", []).has("Player")

func complete_j13() -> bool:
	if current_day != "J13" or day_status != "ACTIVE" or j13_pivot == "" or j13_outcome == "UNESTABLISHED" or j13_j14_trace_id == "" or not _j13_trace_accessible_for_j14(j13_j14_trace_id): return false
	if not complete_conversation("chapter_13_priority", str({"PAULINE":"pauline","RAPHAELLE":"raphaelle","NICO":"nico","SANDRA":"sandra","MATHILDE":"mathilde","MARIE":"marie","RESPIRATION":"marie"}.get(j13_pivot, "marie")), "priority_consequence"): return false
	return complete_day()

func begin_j14() -> bool:
	if current_day != "J13" or day_status != "COMPLETE" or j13_j14_trace_id == "" or not _j13_records_consistent(snapshot()) or not _j13_trace_accessible_for_j14(j13_j14_trace_id): return false
	current_day = "J14"; day_status = "ACTIVE"; j14_variant = ""; j14_outcome = "UNESTABLISHED"; j14_witness = ""; j14_witness_presence_evidence = {}; j14_discovery_mode = ""; j14_visible_fields = []; j14_visible_values = {}; j14_source_trace_id = ""; j14_secondary_trace_id = ""; j14_player_initial_reaction = ""; j14_player_explanation = ""; j14_j15_obligation_id = ""; j14_controller_notified = false
	return true

func j14_presence_contract() -> Dictionary:
	if current_day != "J14" or day_status != "ACTIVE" or j14_variant != "": return {}
	return _j14_presence_contract_for_source(j13_j14_trace_id).duplicate(true)

func _j14_presence_contract_for_source(trace_id: String) -> Dictionary:
	return {
		"j13_pauline_private_version_01":{"person_id":"Marie","reason_near_screen":"SEARCHING_OFFICIAL_GROUP_VERSION","shared_context":"SHARED_PHONE_SEARCH"},
		"j11_sandra_chosen_image_01":{"person_id":"Mathilde","reason_near_screen":"PLAYER_HANDS_DEVICE_FOR_PUBLIC_PHOTO_OR_PRACTICAL_INFO","shared_context":"SHARED_HOUSEHOLD_PHONE_TASK"},
		"j11_mathilde_physical_aftercare_01":{"person_id":"Marie","reason_near_screen":"PHONE_ON_SHARED_ENTRY_OR_KITCHEN_SURFACE","shared_context":"SHARED_HOUSEHOLD_TASK"},
		"j13_raphaelle_masked_version_01":{"person_id":"Marie","reason_near_screen":"SHARED_DOCUMENT_OR_WORK_ITEM_SEARCH","shared_context":"SHARED_SCREEN_SEARCH"},
		"j13_nico_alibi_or_hour_message_01":{"person_id":"Marie","reason_near_screen":"SHARED_SCHEDULE_OR_CALENDAR_TASK","shared_context":"SHARED_TIME_PLANNING"},
	}.get(trace_id, {})

func record_j14_presence_evidence(evidence: Dictionary) -> bool:
	if current_day != "J14" or day_status != "ACTIVE" or j14_variant != "" or not j14_witness_presence_evidence.is_empty(): return false
	var expected := _j14_presence_contract_for_source(j13_j14_trace_id)
	if expected.is_empty() or evidence.get("person_id", "") != expected.get("person_id", "") or evidence.get("reason_near_screen", "") != expected.get("reason_near_screen", "") or evidence.get("shared_context", "") != expected.get("shared_context", ""): return false
	if str(evidence.get("evidence_id", "")) == "" or str(evidence.get("recorded_at", "")) == "" or str(evidence.get("source_day", "")) != "J14" or not bool(evidence.get("physically_present", false)) or not bool(evidence.get("presented_before_selection", false)): return false
	j14_witness_presence_evidence = evidence.duplicate(true)
	return true

func _j14_presence_evidence_admissible(evidence: Dictionary, expected: Dictionary) -> bool:
	return not evidence.is_empty() and evidence.get("person_id", "") == expected.get("person_id", "") and evidence.get("reason_near_screen", "") == expected.get("reason_near_screen", "") and evidence.get("shared_context", "") == expected.get("shared_context", "") and str(evidence.get("source_day", "")) == "J14" and str(evidence.get("recorded_at", "")) != "" and bool(evidence.get("physically_present", false)) and bool(evidence.get("presented_before_selection", false))

func select_j14_variant() -> String:
	if current_day != "J14" or day_status != "ACTIVE" or j14_variant != "" or not _j13_trace_accessible_for_j14(j13_j14_trace_id): return ""
	var variant := str({
		"j13_pauline_private_version_01":"PAULINE",
		"j11_sandra_chosen_image_01":"SANDRA",
		"j11_mathilde_physical_aftercare_01":"MATHILDE",
		"j13_raphaelle_masked_version_01":"RAPHAELLE",
		"j13_nico_alibi_or_hour_message_01":"NICO",
		"j12_laverriere_public_group_set_01":"S27_MUTATION_NO_DISCOVERY",
	}.get(j13_j14_trace_id, ""))
	if variant == "": return ""
	if variant == "S27_MUTATION_NO_DISCOVERY":
		_set_j14_no_discovery_mutation()
		return j14_variant
	var contract := _j14_contract_for_variant(variant)
	var presence_contract := _j14_presence_contract_for_source(j13_j14_trace_id)
	if contract.is_empty() or not _j14_presence_evidence_admissible(j14_witness_presence_evidence, presence_contract):
		_set_j14_no_discovery_mutation()
		return j14_variant
	j14_variant = variant; j14_witness = str(contract["witness_id"])
	j14_discovery_mode = str(contract["discovery_mode"]); j14_visible_fields = contract["visible_fields"].duplicate(); j14_visible_values = contract["visible_values"].duplicate(true); j14_source_trace_id = j13_j14_trace_id; j14_secondary_trace_id = ""; j14_player_initial_reaction = str(contract["player_reaction"])
	return variant

func _set_j14_no_discovery_mutation() -> void:
	j14_variant = "S27_MUTATION_NO_DISCOVERY"; j14_outcome = "S27_MUTATION_NO_DISCOVERY"; j14_witness = ""; j14_witness_presence_evidence = {}; j14_discovery_mode = ""; j14_visible_fields = []; j14_visible_values = {}; j14_source_trace_id = j13_j14_trace_id; j14_secondary_trace_id = ""; j14_player_initial_reaction = ""; j14_player_explanation = ""; j14_j15_obligation_id = ""; j14_controller_notified = false

func _j14_contract_for_variant(variant: String, _witness_override := "", state_value: Dictionary = {}) -> Dictionary:
	var effective_knowledge: Dictionary = state_value.get("knowledge", knowledge)
	var nico_boundary := str(effective_knowledge.get("fact_nico_knows_specific_hour_or_alibi_request", {}).get("request_or_boundary", ""))
	var nico_line := str({"ALIBI_REQUEST":"Mon nom ne sera pas dans ton mensonge.","COVERAGE_CLOSED":"Je ne change pas une heure pour la protéger.","TRUTH_LIMIT":"La règle a tenu. Tu n’as pas parlé pour elles."}.get(nico_boundary, ""))
	return {
		"PAULINE":{"witness_id":"Marie","discovery_mode":"OPEN_CONVERSATION","visible_fields":["thread_name","thumbnail"],"visible_values":{"thread_name":"Pauline","thumbnail":"une autre version de Pauline, même soirée, pas la photo du groupe"},"player_reaction":"SCREEN_CLOSED"},
		"SANDRA":{"witness_id":"Mathilde","discovery_mode":"OPEN_CONVERSATION","visible_fields":["thread_name","thumbnail"],"visible_values":{"thread_name":"Sandra","thumbnail":"une image choisie de Sandra, hors du groupe de déjeuner"},"player_reaction":"SCREEN_CLOSED"},
		"MATHILDE":{"witness_id":"Marie","discovery_mode":"TEXT_NOTIFICATION","visible_fields":["sender_name","first_line","received_at"],"visible_values":{"sender_name":"Mathilde","first_line":"Aujourd’hui, rien ne se répète.","received_at":"19:02"},"player_reaction":"PREVIEW_DISMISSED"},
		"RAPHAELLE":{"witness_id":"Marie","discovery_mode":"OPEN_GALLERY_OR_SELECTION","visible_fields":["thumbnail","thread_name"],"visible_values":{"thumbnail":"l’image choisie par Raphaëlle après le travail","thread_name":"Raphaëlle"},"player_reaction":"SCREEN_CLOSED"},
		"NICO":{"witness_id":"Marie","discovery_mode":"TEXT_NOTIFICATION","visible_fields":["sender_name","first_line","received_at"],"visible_values":{"sender_name":"Nico","first_line":nico_line,"received_at":"18:27"},"player_reaction":"PREVIEW_DISMISSED"},
	}.get(variant, {})

func establish_j14_discovery(variant: String) -> bool:
	if current_day != "J14" or day_status != "ACTIVE" or variant != j14_variant or variant not in ["PAULINE","SANDRA","MATHILDE","RAPHAELLE","NICO"]: return false
	var contract := _j14_contract_for_variant(variant); var presence_contract := _j14_presence_contract_for_source(j14_source_trace_id)
	if j14_source_trace_id != j13_j14_trace_id or not _j13_trace_accessible_for_j14(j14_source_trace_id) or contract.is_empty() or not _j14_presence_evidence_admissible(j14_witness_presence_evidence, presence_contract): return false
	if traces.has("j14_discovery_event_01") or knowledge.has("fact_witness_saw_limited_trace"): return false
	var source_before: Dictionary = traces[j14_source_trace_id].duplicate(true)
	var controller := _j14_controller_for_source(j14_source_trace_id)
	if controller == "" or j14_visible_values.keys().size() != j14_visible_fields.size(): return false
	for field in j14_visible_fields:
		if not j14_visible_values.has(field) or str(j14_visible_values[field]) == "": return false
	var discovery := {"trace_id":"j14_discovery_event_01","trace_type":"FACT_RECORD","source_day":"J14","source_scene":"S27 photo au mauvais écran","creator":"système narratif à partir d’une trace existante","subjects":[j14_witness,"Player",controller],"owner":"état narratif","initial_audience":"NOT_APPLICABLE","current_audience":"NOT_APPLICABLE","storage_location":"registre de connaissances","saving_rule":"NONE","transfer_rule":"FORBIDDEN","discovered_trace_id":j14_source_trace_id,"secondary_trace_id":"","replaces_or_derives_from":[j14_source_trace_id],"witness_id":j14_witness,"discovery_mode":j14_discovery_mode,"visible_fields":j14_visible_fields.duplicate(),"visible_values":j14_visible_values.duplicate(true),"visible_duration":"BRIEF_GLANCE","witness_presence_evidence":j14_witness_presence_evidence.duplicate(true),"player_reaction":j14_player_initial_reaction,"player_explanation":"","source_trace_unchanged":true,"knowledge_created":"fact_witness_saw_limited_trace","eligible_for_j14":false,"eligible_for_j21":true,"legacy_alias":null,"current_state":"ACTIVE"}
	var discovery_fact := {"fact_id":"fact_witness_saw_limited_trace","source_type":"DIRECT_OBSERVATION","source_ref":"j14_discovery_event_01","initial_knowers":[j14_witness,"Player"],"current_knowers":[j14_witness,"Player"],"certainty":"OBSERVED","context_certainty":"INCOMPLETE","shareability":"FACTUAL_ONLY","source_day":"J14","witness_id":j14_witness,"discovered_trace_id":j14_source_trace_id,"visible_fields":j14_visible_fields.duplicate(),"visible_values":j14_visible_values.duplicate(true),"visible_duration":"BRIEF_GLANCE","player_reaction":j14_player_initial_reaction}
	if traces.get(j14_source_trace_id, {}) != source_before: return false
	traces["j14_discovery_event_01"] = discovery; knowledge["fact_witness_saw_limited_trace"] = discovery_fact
	if _j14_private_audience_compromised(): _create_j14_controller_notice()
	return true

func apply_j14_choice(choice_id: String, variant: String) -> bool:
	if current_day != "J14" or day_status != "ACTIVE" or variant != j14_variant or j14_outcome != "UNESTABLISHED" or choice_id == "" or selected_choice_ids.has(choice_id): return false
	if not choice_id.begins_with("choice_j14_" + variant.to_lower() + "_"): return false
	var posture := _j14_posture_for_choice(choice_id, variant)
	if posture == "": return false
	var discovery: Dictionary = traces.get("j14_discovery_event_01", {})
	if discovery.is_empty(): return false
	j14_outcome = posture; j14_player_explanation = posture; selected_choice_ids.append(choice_id)
	var lie_detail := str({"PAULINE":"PRIVATE_IMAGE_CALLED_PUBLIC_GROUP_VERSION","SANDRA":"PRIVATE_CHOSEN_IMAGE_DENIED","MATHILDE":"HOUSEHOLD_BOUNDARY_NOTIFICATION_DENIED","RAPHAELLE":"PRIVATE_SELECTED_IMAGE_CALLED_WORK_FILE","NICO":"REAL_HOUR_MESSAGE_CALLED_OUT_OF_CONTEXT"}.get(variant, "")) if posture == "MINIMIZE_OR_LIE" else ""
	knowledge["fact_player_explanation_to_witness"] = {"fact_id":"fact_player_explanation_to_witness","source_type":"DIRECT_STATEMENT","source_ref":choice_id,"initial_knowers":[j14_witness,"Player"],"current_knowers":[j14_witness,"Player"],"certainty":"CONFIRMED","context_certainty":"BOUNDED_BY_STATEMENT","shareability":"WITNESS_BOUNDED","source_day":"J14","witness_id":j14_witness,"discovered_trace_id":j14_source_trace_id,"player_explanation":posture,"lie_or_minimization":lie_detail}
	discovery["player_explanation"] = posture; traces["j14_discovery_event_01"] = discovery
	var notice: Dictionary = promises.get("j14_inform_trace_controller", {})
	if not notice.is_empty(): notice["player_declaration"] = _j14_player_statement_for_choice(choice_id); notice["source_choice_id"] = choice_id; promises["j14_inform_trace_controller"] = notice
	if posture == "PROTECT_AND_DEFER": _create_j14_witness_clarification(choice_id, variant)
	return true

func _j14_posture_for_choice(choice_id: String, variant: String) -> String:
	if variant == "NICO" and choice_id == "choice_j14_nico_defer": return "PROTECT_AND_ANSWER_NOW"
	if choice_id.ends_with("_truth"): return "TRUTH_LIMITED"
	if choice_id.ends_with("_lie"): return "MINIMIZE_OR_LIE"
	if choice_id.ends_with("_defer"): return "PROTECT_AND_DEFER"
	return ""

func _j14_player_statement_for_choice(choice_id: String) -> String:
	return {
		"choice_j14_pauline_truth":"Pauline me l’a envoyée après le tri. Elle reste dans notre fil et je n’ai rien demandé de plus", "choice_j14_pauline_lie":"c’était juste une autre version du groupe", "choice_j14_pauline_defer":"je préviens Pauline que tu as vu la miniature. je te réponds à 21 h 30 sur ce que j’ai accepté",
		"choice_j14_sandra_truth":"non. elle l’avait destinée à notre fil seulement. je vais la prévenir", "choice_j14_sandra_lie":"ce n’était rien de privé", "choice_j14_sandra_defer":"je protège sa photo et je préviens Sandra. demain à 19 h, je te réponds sur la règle du foyer et ce qui concerne Marie",
		"choice_j14_mathilde_truth":"oui. il y a une règle de distance et elle passe avant ce que je veux garder privé", "choice_j14_mathilde_lie":"tu as mal compris. il n’y a rien", "choice_j14_mathilde_defer":"je protège ce qui est à elle. à 20 h 30, je te donne la règle utile au foyer sans parler à sa place",
		"choice_j14_raphaelle_truth":"elle l’a choisie après le travail. Maud l’a faite et elle reste dans notre fil", "choice_j14_raphaelle_lie":"c’était seulement un fichier de travail", "choice_j14_raphaelle_defer":"je préviens Raphaëlle que tu as vu l’image. à 22 h, je te réponds sur ma place dans cette histoire",
		"choice_j14_nico_truth":"oui. et s’il y a un écart, il est à moi, pas à Nico", "choice_j14_nico_lie":"tu sors la phrase de son contexte", "choice_j14_nico_defer":"je protège sa confidence, mais je te réponds maintenant sur l’heure",
	}.get(choice_id, "")

func _create_j14_witness_clarification(choice_id: String, variant: String) -> void:
	var due_at := str({"PAULINE":"J14 21:30","SANDRA":"J15 19:00","MATHILDE":"J14 20:30","RAPHAELLE":"J14 22:00"}.get(variant, ""))
	if due_at == "": return
	var sandra_action := "répondre à Mathilde sur la règle du foyer et ce qui concerne Marie" if j14_witness == "Mathilde" else "répondre à Marie sur la règle du foyer et ce qui la concerne"
	var sandra_failure := "la règle du foyer reste due et Mathilde refuse de couvrir" if j14_witness == "Mathilde" else "la règle du foyer et la contradiction du couple restent dues en J15"
	var action_due := str({"PAULINE":"répondre à Marie sur ce que Player a accepté avec Pauline","SANDRA":sandra_action,"MATHILDE":"donner à Marie la règle utile au foyer sans parler à la place de Mathilde","RAPHAELLE":"répondre à Marie sur la place réelle de Player dans le processus Raphaëlle"}[variant])
	var failure_effect := str({"PAULINE":"la contradiction couple reste active en J15","SANDRA":sandra_failure,"MATHILDE":"la sécurité et la distance du foyer restent prioritaires","RAPHAELLE":"la clarification couple reste due sans créer une seconde obligation professionnelle"}[variant])
	promises["j14_witness_clarification"] = {"promise_id":"j14_witness_clarification","promise_type":"CLARIFICATION","status":"ACTIVE","created_at":"J14 18:38","created_by":"Player","proposed_to":j14_witness,"accepted_at":"J14 18:38","accepted_by_player":true,"witness_id":j14_witness,"action_due":action_due,"due_at":due_at,"confirmation_deadline":"IMMEDIATE","paid_or_closed_at":null,"paid_or_closed_by":null,"source_choice_id":choice_id,"source_signed_ref":choice_id,"failure_effect":failure_effect,"related_scene":"S27 photo au mauvais écran","related_trace_ids":["j14_discovery_event_01"]}
	j14_j15_obligation_id = "j14_witness_clarification"

func _j14_private_audience_compromised() -> bool:
	var source: Dictionary = traces.get(j14_source_trace_id, {})
	return not source.is_empty() and str(source.get("current_state", "")) != "PUBLIC_ACTIVE" and not source.get("current_audience", []).has(j14_witness)

func _j14_controller_for_source(trace_id: String) -> String:
	return {"j13_pauline_private_version_01":"Pauline","j13_raphaelle_masked_version_01":"Raphaëlle","j13_nico_alibi_or_hour_message_01":"Nico","j11_sandra_chosen_image_01":"Sandra","j11_mathilde_physical_aftercare_01":"Mathilde","j10_mathilde_outfit_choice_01":"Mathilde","j09_marie_black_dress_private_01":"Marie"}.get(trace_id, "")

func _create_j14_controller_notice() -> void:
	var controller := _j14_controller_for_source(j14_source_trace_id)
	if controller == "" or promises.has("j14_inform_trace_controller"): return
	promises["j14_inform_trace_controller"] = {"promise_id":"j14_inform_trace_controller","promise_type":"CLARIFICATION","status":"ACTIVE","created_at":"J14 18:36","created_by":"responsabilité narrative","proposed_to":"Player","accepted_at":"J14 18:36","accepted_by_player":true,"due_at":"J14 20:14","confirmation_deadline":"avant toute nouvelle progression et avant J15","paid_or_closed_at":null,"paid_or_closed_by":null,"controller":controller,"witness_id":j14_witness,"visible_fields":j14_visible_fields.duplicate(),"visible_values":j14_visible_values.duplicate(true),"player_reaction":j14_player_initial_reaction,"player_declaration":"","source_choice_id":"","related_scene":"conséquence audience J14","related_trace_ids":[j14_source_trace_id]}

func j14_controller_notice_pending() -> bool:
	return str(promises.get("j14_inform_trace_controller", {}).get("status", "")) == "ACTIVE"

func resolve_j14_controller_informed(presented_at := "J14 20:15") -> bool:
	var promise: Dictionary = promises.get("j14_inform_trace_controller", {})
	if current_day != "J14" or str(promise.get("status", "")) != "ACTIVE" or not _j14_private_audience_compromised() or str(promise.get("player_declaration", "")) == "" or str(presented_at) == "": return false
	promise["status"] = "PAID"; promise["paid_or_closed_at"] = str(presented_at); promise["paid_or_closed_by"] = "Player"; promises["j14_inform_trace_controller"] = promise
	j14_controller_notified = true
	knowledge["fact_trace_controller_informed_of_audience_breach"] = {"fact_id":"fact_trace_controller_informed_of_audience_breach","source_type":"DIRECT_MESSAGE","source_ref":"j14_inform_trace_controller","initial_knowers":[str(promise.get("controller", "")),"Player"],"current_knowers":[str(promise.get("controller", "")),"Player"],"certainty":"CONFIRMED","context_certainty":"BOUNDED_NOTICE_ONLY","shareability":"PRIVATE_DO_NOT_SHARE","source_day":"J14","witness_id":j14_witness,"discovered_trace_id":j14_source_trace_id,"visible_fields":j14_visible_fields.duplicate(),"visible_values":j14_visible_values.duplicate(true),"player_reaction":j14_player_initial_reaction,"player_declaration":str(promise.get("player_declaration", ""))}
	return true

func fail_j14_controller_notice(reason: String, actor := "Player", presented_at := "J14 20:14") -> bool:
	var promise: Dictionary = promises.get("j14_inform_trace_controller", {})
	if current_day != "J14" or str(promise.get("status", "")) != "ACTIVE" or reason not in ["REFUSED","OMITTED"] or actor != "Player" or str(presented_at) == "": return false
	promise["status"] = "FAILED"; promise["failure_reason"] = reason; promise["paid_or_closed_at"] = str(presented_at); promise["paid_or_closed_by"] = actor; promises["j14_inform_trace_controller"] = promise; j14_controller_notified = false
	knowledge["fact_trace_controller_not_informed"] = {"fact_id":"fact_trace_controller_not_informed","source_type":"DIRECT_OBSERVATION","source_ref":"j14_inform_trace_controller","initial_knowers":["Player"],"current_knowers":["Player"],"certainty":"CONFIRMED","source_day":"J14","failure_reason":reason,"failed_by":actor,"failed_at":presented_at}
	return true

func resolve_j14_witness_clarification(status: String, actor: String, presented_at: String) -> bool:
	var promise: Dictionary = promises.get("j14_witness_clarification", {})
	if current_day != "J14" or str(promise.get("status", "")) != "ACTIVE" or status not in ["PAID","AMENDED","FAILED","CANCELLED"] or presented_at == "": return false
	if status in ["PAID","FAILED"] and actor != "Player": return false
	if status in ["AMENDED","CANCELLED"] and actor != j14_witness: return false
	promise["status"] = status; promise["paid_or_closed_at"] = presented_at; promise["paid_or_closed_by"] = actor; promises["j14_witness_clarification"] = promise
	return true

func j14_clarification_due_on_j14() -> bool:
	var promise: Dictionary = promises.get("j14_witness_clarification", {})
	return str(promise.get("status", "")) == "ACTIVE" and str(promise.get("due_at", "")).begins_with("J14 ")

func complete_j14() -> bool:
	if current_day != "J14" or day_status != "ACTIVE" or j14_variant == "" or j14_outcome == "UNESTABLISHED": return false
	if j14_variant == "S27_MUTATION_NO_DISCOVERY": return complete_day()
	var notice: Dictionary = promises.get("j14_inform_trace_controller", {})
	if not notice.is_empty() and str(notice.get("status", "")) not in ["PAID","FAILED"]: return false
	if str(notice.get("status", "")) == "PAID" and not j14_controller_notified: return false
	var clarification: Dictionary = promises.get("j14_witness_clarification", {})
	if not clarification.is_empty() and str(clarification.get("due_at", "")).begins_with("J14 ") and str(clarification.get("status", "")) == "ACTIVE": return false
	if not complete_conversation("chapter_14_discovery", "mathilde" if j14_witness == "Mathilde" else "marie", "witness_discovery"): return false
	return complete_day()

func begin_j15() -> bool:
	if current_day != "J14" or day_status != "COMPLETE" or not _j14_records_consistent(snapshot()): return false
	var clarification: Dictionary = promises.get("j14_witness_clarification", {})
	if str(clarification.get("status", "")) == "ACTIVE" and not str(clarification.get("due_at", "")).begins_with("J15 "): return false
	current_day = "J15"; day_status = "ACTIVE"; j15_mode = "UNESTABLISHED"; j15_outcome = "UNESTABLISHED"; j15_urgent_consequence_remaining = false
	return true

func select_j15_mode() -> String:
	var clarification: Dictionary = promises.get("j14_witness_clarification", {})
	if str(clarification.get("status", "")) == "ACTIVE" and str(clarification.get("due_at", "")).begins_with("J15 "): return "ACTIVE_CLARIFICATION"
	if j14_outcome == "PROTECT_AND_ANSWER_NOW": return "NO_OBLIGATION"
	if j14_outcome == "MINIMIZE_OR_LIE": return "REPAIR"
	if j14_outcome == "PROTECT_AND_DEFER" and j14_variant != "NICO": return "OPEN_CLARIFICATION"
	return "NO_OBLIGATION"

func establish_j15_mode(mode: String) -> bool:
	if current_day != "J15" or day_status != "ACTIVE" or j15_mode != "UNESTABLISHED" or mode != select_j15_mode(): return false
	j15_mode = mode
	return true

func apply_j15_choice(choice_id: String) -> bool:
	if current_day != "J15" or day_status != "ACTIVE" or j15_mode == "UNESTABLISHED" or j15_outcome != "UNESTABLISHED" or selected_choice_ids.has(choice_id): return false
	var action_id := choice_id.trim_suffix("_marie").trim_suffix("_mathilde")
	var allowed: Array = {
		"ACTIVE_CLARIFICATION":["choice_j15_due_pay","choice_j15_due_cancel","choice_j15_due_fail"],
		"REPAIR":["choice_j15_repair_truth","choice_j15_repair_lie"],
		"OPEN_CLARIFICATION":["choice_j15_open_answer","choice_j15_open_refuse","choice_j15_open_lie"],
		"NO_OBLIGATION":["choice_j15_clean_acknowledge"],
	}.get(j15_mode, [])
	if action_id not in allowed: return false
	selected_choice_ids.append(choice_id); j15_outcome = action_id.trim_prefix("choice_j15_").to_upper()
	var clarification: Dictionary = promises.get("j14_witness_clarification", {})
	var selected_promise_ids: Array[String] = []
	var amended_ids: Array[String] = []; var failed_ids: Array[String] = []; var closed_ids: Array[String] = []
	if j15_mode == "ACTIVE_CLARIFICATION":
		selected_promise_ids.append("j14_witness_clarification")
		if action_id == "choice_j15_due_pay": clarification["status"] = "PAID"
		elif action_id == "choice_j15_due_cancel": clarification["status"] = "CANCELLED"; closed_ids.append("j14_witness_clarification")
		else: clarification["status"] = "FAILED"; failed_ids.append("j14_witness_clarification"); j15_urgent_consequence_remaining = true
		var presented_at := str(clarification.get("due_at", "")) if action_id == "choice_j15_due_fail" else "J15 18:34"
		clarification["paid_or_closed_at"] = presented_at; clarification["paid_or_closed_by"] = "Player"; promises["j14_witness_clarification"] = clarification
	elif action_id in ["choice_j15_repair_lie","choice_j15_open_lie"]:
		j15_urgent_consequence_remaining = true
	if j15_mode != "NO_OBLIGATION":
		traces["j15_obligation_collision_record_01"] = {"trace_id":"j15_obligation_collision_record_01","record_type":"FACT_RECORD","source_day":"J15","collision_mode":"NO_COLLISION","eligible_active_promise_ids":selected_promise_ids,"selected_promise_id":selected_promise_ids[0] if not selected_promise_ids.is_empty() else "","chosen_priority":"BOUNDED_CLARIFICATION","amended_promise_ids":amended_ids,"failed_promise_ids":failed_ids,"closed_promise_ids":closed_ids,"promise_outcome":j15_outcome,"incompatible_windows_proven":false,"second_signed_obligation_present":false,"urgent_consequence_remaining":j15_urgent_consequence_remaining,"current_state":"ACTIVE","visual_asset":"none"}
		knowledge["fact_j15_obligation_resolution"] = {"fact_id":"fact_j15_obligation_resolution","source_type":"INFERENCE","source_ref":"j15_obligation_collision_record_01","initial_knowers":[j14_witness,"Player"],"certainty":"CONFIRMED","shareability":"WITNESS_BOUNDED","source_day":"J15"}
	if j15_urgent_consequence_remaining:
		promises["j16_priority_consequence_payment"] = {"promise_id":"j16_priority_consequence_payment","promise_type":"REPAIR","status":"ACTIVE","created_at":"J15 20:00","accepted_by_player":true,"source_signed_ref":choice_id,"concerned_person":j14_witness,"action_due":"payer la clarification ou le mensonge précis laissé par J15","due_at":"J16","related_trace_ids":["j15_obligation_collision_record_01"]}
	return true

func complete_j15() -> bool:
	if current_day != "J15" or day_status != "ACTIVE" or j15_mode == "UNESTABLISHED" or j15_outcome == "UNESTABLISHED": return false
	if not complete_conversation("chapter_15_obligation_mutation", str(j14_witness).to_lower(), "obligation_mutation"): return false
	return complete_day()

func begin_j16() -> bool:
	if current_day != "J15" or day_status != "COMPLETE": return false
	current_day = "J16"; day_status = "ACTIVE"; j16_priority = "UNESTABLISHED"; j16_consequence_outcome = "UNESTABLISHED"; j16_departure_state = "UNESTABLISHED"; j16_j17_outcome = "UNESTABLISHED"
	return true

func select_j16_priority() -> String:
	if str(promises.get("j16_priority_consequence_payment", {}).get("status", "")) == "ACTIVE": return "MATHILDE" if j14_witness == "Mathilde" else "MARIE"
	return "FALLBACK"

func establish_j16_priority(priority: String) -> bool:
	if current_day != "J16" or day_status != "ACTIVE" or j16_priority != "UNESTABLISHED" or priority != select_j16_priority(): return false
	j16_priority = priority; return true

func apply_j16_consequence_choice(choice_id: String) -> bool:
	if current_day != "J16" or day_status != "ACTIVE" or j16_priority == "UNESTABLISHED" or j16_consequence_outcome != "UNESTABLISHED" or selected_choice_ids.has(choice_id): return false
	var allowed := (["choice_j16_mathilde_restitute","choice_j16_mathilde_practical","choice_j16_mathilde_contest"] if j16_priority == "MATHILDE" else ["choice_j16_marie_restitute","choice_j16_marie_practical","choice_j16_marie_contest"]) if j16_priority != "FALLBACK" else ["choice_j16_fallback_confirm"]
	if choice_id not in allowed: return false
	selected_choice_ids.append(choice_id); j16_consequence_outcome = choice_id.trim_prefix("choice_j16_").to_upper()
	var consequence: Dictionary = promises.get("j16_priority_consequence_payment", {})
	if j16_priority != "FALLBACK":
		consequence["status"] = "FAILED" if choice_id.ends_with("_contest") else "PAID"; consequence["paid_or_closed_at"] = "J16 10:12"; consequence["paid_or_closed_by"] = "Player"; promises["j16_priority_consequence_payment"] = consequence
	traces["j16_consequence_payment_record_01"] = {"trace_id":"j16_consequence_payment_record_01","record_type":"FACT_RECORD","source_day":"J16","source_t21_id":"j15_obligation_collision_record_01" if traces.has("j15_obligation_collision_record_01") else "","source_collision_mode":str(traces.get("j15_obligation_collision_record_01", {}).get("collision_mode", "NO_COLLISION")),"source_promise_ids":["j16_priority_consequence_payment"] if j16_priority != "FALLBACK" else [],"p17_created":j16_priority != "FALLBACK","consequence_outcome":"CONSEQUENCE_FAILED" if choice_id.ends_with("_contest") else ("CONSEQUENCE_PAID" if j16_priority != "FALLBACK" else "DIRECT_TO_MATHILDE_MARIE_J17_PREPARATION"),"urgent_consequence_remaining":false,"next_priority":8,"current_state":"ACTIVE","visual_asset":"none"}
	return true

func establish_j16_departure() -> bool:
	if current_day != "J16" or j16_consequence_outcome == "UNESTABLISHED" or j16_departure_state != "UNESTABLISHED": return false
	j16_departure_state = "DISTANCE" if mathilde_state in ["DISTANCE","TRUST_BROKEN","SECRET_SUSPENDED"] or j16_consequence_outcome.ends_with("CONTEST") else "ORDINARY"
	knowledge["fact_mathilde_departure_planned_j17"] = {"fact_id":"fact_mathilde_departure_planned_j17","source_type":"DIRECT_MESSAGE","source_ref":"chapter_16_priority_payment","initial_knowers":["Mathilde","Marie","Player"],"certainty":"CONFIRMED","shareability":"HOUSEHOLD","source_day":"J16","departure_at":"J17 17:30","player_presence":false if j16_departure_state == "DISTANCE" else "UNDECIDED"}
	return true

func apply_j16_j17_choice(choice_id: String) -> bool:
	if current_day != "J16" or j16_departure_state == "UNESTABLISHED" or j16_j17_outcome != "UNESTABLISHED" or choice_id not in ["choice_j16_j17_accept","choice_j16_j17_refuse","choice_j16_j17_alternative"] or selected_choice_ids.has(choice_id): return false
	selected_choice_ids.append(choice_id); j16_j17_outcome = choice_id.trim_prefix("choice_j16_j17_").to_upper()
	if choice_id == "choice_j16_j17_accept": promises["marie_j16_couple_conversation_j17"] = {"promise_id":"marie_j16_couple_conversation_j17","promise_type":"COUPLE_REVIEW","status":"ACTIVE","created_at":"J16 19:19","accepted_at":"J16 19:19","accepted_by_player":true,"source_signed_ref":choice_id,"concerned_person":"Marie","action_due":"discussion de couple après le départ de Mathilde","due_at":"J17 20:30–21:30"}
	return true

func complete_j16() -> bool:
	if current_day != "J16" or day_status != "ACTIVE" or j16_consequence_outcome == "UNESTABLISHED" or j16_departure_state == "UNESTABLISHED" or j16_j17_outcome == "UNESTABLISHED": return false
	if not complete_conversation("chapter_16_priority_payment", "marie", "priority_payment_and_j17_preparation"): return false
	return complete_day()

func begin_j17() -> bool:
	if current_day != "J16" or day_status != "COMPLETE": return false
	current_day="J17"; day_status="ACTIVE"; j17_departure_outcome="UNESTABLISHED"; j17_couple_outcome="UNESTABLISHED"; return true
func apply_j17_departure_choice(choice_id:String)->bool:
	if current_day!="J17" or j17_departure_outcome!="UNESTABLISHED" or choice_id not in ["choice_j17_help","choice_j17_distance"]: return false
	if j16_departure_state=="DISTANCE" and choice_id!="choice_j17_distance": return false
	selected_choice_ids.append(choice_id); j17_departure_outcome=choice_id.trim_prefix("choice_j17_").to_upper(); mathilde_state="DISTANCE" if choice_id.ends_with("distance") else "FAMILY_RELATION_PRESERVED"
	knowledge["fact_mathilde_left_household"]={"fact_id":"fact_mathilde_left_household","source_type":"DIRECT_OBSERVATION","source_ref":choice_id,"initial_knowers":["Mathilde","Marie","Player"],"certainty":"CONFIRMED","shareability":"HOUSEHOLD","source_day":"J17"}; return true
func apply_j17_couple_choice(choice_id:String,resolved_at:String="",mathilde_micro_return_delivered:bool=false)->bool:
	if current_day!="J17" or day_status!="ACTIVE" or j17_departure_outcome=="UNESTABLISHED" or j17_couple_outcome!="UNESTABLISHED" or resolved_at=="" or not resolved_at.begins_with("J17 ") or not mathilde_micro_return_delivered:return false
	var input:=snapshot();var resolution:=_resolve_j17_couple_state(input,choice_id)
	if not bool(resolution.get("accepted",false)):return false
	var due:=bool(resolution["discussion_was_due"]);var discussion:Dictionary=promises.get("marie_j16_couple_conversation_j17",{})
	selected_choice_ids.append(choice_id);j17_couple_outcome=choice_id.trim_prefix("choice_j17_").to_upper()
	if due:discussion["status"]="PAID";discussion["paid_or_closed_at"]="J17 21:30";discussion["paid_or_closed_by"]="Player et Marie";promises["marie_j16_couple_conversation_j17"]=discussion
	couple_state=str(resolution["couple_state"])
	traces["j17_couple_definition_record_01"]={"trace_id":"j17_couple_definition_record_01","record_type":"FACT_RECORD","source_day":"J17","choice_id":choice_id,"couple_state":couple_state,"discussion_was_due":due,"triggered_guard_fact_ids":resolution["triggered_guard_fact_ids"],"satisfied_constructive_condition_ids":resolution["satisfied_constructive_condition_ids"],"mathilde_micro_return_delivered":true,"marie_micro_return_delivered":false,"temporal_projection":{"day_id":"J17","departure_at":"J17 17:30","couple_discussion_due_at":"J17 20:30–21:30" if due else "","resolved_at":resolved_at},"current_state":"ACTIVE","visual_asset":"none"}
	knowledge["fact_couple_state_defined"]={"fact_id":"fact_couple_state_defined","source_type":"DIRECT_STATEMENT","source_ref":"j17_couple_definition_record_01","initial_knowers":["Marie","Player"],"certainty":"CONFIRMED","shareability":"PRIVATE","source_day":"J17"};return true
func mark_j17_marie_micro_return_delivered()->bool:
	var record:Dictionary=traces.get("j17_couple_definition_record_01",{})
	if record.is_empty() or bool(record.get("marie_micro_return_delivered",false)):return false
	record["marie_micro_return_delivered"]=true;traces["j17_couple_definition_record_01"]=record;return true
func j17_sufficient_truth_proven()->bool:return _j17_sufficient_truth_proven(snapshot())
func j17_no_active_violation()->bool:return _j17_no_active_violation(snapshot())
func _resolve_j17_couple_state(value:Dictionary,choice_id:String)->Dictionary:
	if not _j17_structural_input_valid(value):return {"accepted":false}
	var discussion_state:=_j17_discussion_state(value)
	if choice_id not in ["choice_j17_reconquest","choice_j17_provisional","choice_j17_separation","choice_j17_refused_acknowledge"]:return {"accepted":false}
	if choice_id=="choice_j17_refused_acknowledge" and discussion_state!="NOT_DUE":return {"accepted":false}
	if choice_id!="choice_j17_refused_acknowledge" and discussion_state!="DUE":return {"accepted":false}
	var severe:=_j17_marie_known_severe_violation_unrepaired(value);var material:=_j17_material_fact_hidden(value);var incompatible:=_j17_incompatible_version_active(value);var resolved_state:=""
	# Rule 1: explicit separation.
	if choice_id=="choice_j17_separation":resolved_state="SEPARATION"
	# Rule 2: refused or not-due discussion.
	elif choice_id=="choice_j17_refused_acknowledge":resolved_state="FRACTURE"
	# Rule 3: known severe violation, unrepaired.
	elif severe:resolved_state="FRACTURE"
	# Rule 4: hidden material fact or active incompatible version.
	elif material or incompatible:resolved_state="DOUBLE_LIFE_FRAGILE"
	# Rule 5: reconquest with every closed constructive condition.
	elif choice_id=="choice_j17_reconquest" and _j17_repeated_marie_acts_proven(value) and _j17_sufficient_truth_proven(value) and _j17_no_active_violation(value) and _j17_concrete_rule_proven(value,choice_id):resolved_state="RECONQUEST_ACTIVE"
	# Rule 6: reconquest fallback.
	elif choice_id=="choice_j17_reconquest":resolved_state="PROVISIONAL_AGREEMENT"
	# Rule 7: reconfiguration with every closed constructive condition.
	elif choice_id=="choice_j17_provisional" and _j17_external_desire_acknowledged(value,choice_id) and _j17_audiences_safe_or_repaired(value) and _j17_external_progression_pause_accepted(value,choice_id) and _j17_marie_full_refusal_right_explicitly_acknowledged(value,choice_id):resolved_state="RECONFIGURATION_NEGOTIATION"
	# Rule 8: provisional fallback.
	elif choice_id=="choice_j17_provisional":resolved_state="PROVISIONAL_AGREEMENT"
	if resolved_state=="":return {"accepted":false}
	return {"accepted":true,"couple_state":resolved_state,"discussion_was_due":discussion_state=="DUE","triggered_guard_fact_ids":_j17_triggered_guard_fact_ids(value,resolved_state,choice_id),"satisfied_constructive_condition_ids":_j17_satisfied_constructive_condition_ids(value,choice_id)}
func _j17_structural_input_valid(value:Dictionary)->bool:
	if str(value.get("current_day","")) not in ["J17","J18","J19","J20","J21"] or str(value.get("j17_departure_outcome","UNESTABLISHED")) not in ["HELP","DISTANCE"]:return false
	if str(value.get("j14_variant","")) not in ["PAULINE","SANDRA","MATHILDE","RAPHAELLE","NICO","S27_MUTATION_NO_DISCOVERY"] or str(value.get("j14_outcome","UNESTABLISHED")) not in ["TRUTH_LIMITED","MINIMIZE_OR_LIE","PROTECT_AND_DEFER","PROTECT_AND_ANSWER_NOW","S27_MUTATION_NO_DISCOVERY"]:return false
	if str(value.get("j15_outcome","UNESTABLISHED")) not in ["DUE_PAY","DUE_CANCEL","DUE_FAIL","REPAIR_TRUTH","REPAIR_LIE","OPEN_ANSWER","OPEN_REFUSE","OPEN_LIE","CLEAN_ACKNOWLEDGE"]:return false
	if str(value.get("j16_priority","UNESTABLISHED")) not in ["MARIE","MATHILDE","FALLBACK"] or str(value.get("j16_consequence_outcome","UNESTABLISHED")) not in ["MARIE_RESTITUTE","MARIE_PRACTICAL","MARIE_CONTEST","MATHILDE_RESTITUTE","MATHILDE_PRACTICAL","MATHILDE_CONTEST","FALLBACK_CONFIRM"] or str(value.get("j16_departure_state","UNESTABLISHED")) not in ["ORDINARY","DISTANCE"]:return false
	if _j17_discussion_state(value)=="INVALID":return false
	var restored_knowledge:Dictionary=value.get("knowledge",{});var restored_obligations:Dictionary=value.get("obligations",{});var restored_promises:Dictionary=value.get("promises",{});var restored_traces:Dictionary=value.get("traces",{});var choices:Array=value.get("selected_choice_ids",[])
	if str(value.get("j14_variant",""))=="S27_MUTATION_NO_DISCOVERY":
		if str(value.get("j14_outcome",""))!="S27_MUTATION_NO_DISCOVERY" or str(value.get("j14_witness",""))!="" or restored_knowledge.has("fact_witness_saw_limited_trace") or restored_traces.has("j14_discovery_event_01"):return false
	elif not _j17_witness_fact_coherent(value):return false
	if restored_knowledge.has("fact_witness_saw_limited_trace") and not _j17_witness_fact_coherent(value):return false
	var notice:Dictionary=restored_promises.get("j14_inform_trace_controller",{});var notice_status:=str(notice.get("status",""));var notice_paid_fact:=restored_knowledge.has("fact_trace_controller_informed_of_audience_breach");var notice_failed_fact:=restored_knowledge.has("fact_trace_controller_not_informed")
	if not notice.is_empty() and notice_status not in ["PAID","FAILED"]:return false
	if notice_status=="PAID" and (not bool(value.get("j14_controller_notified",false)) or not notice_paid_fact or notice_failed_fact):return false
	if notice_status=="FAILED" and (bool(value.get("j14_controller_notified",false)) or notice_paid_fact or not notice_failed_fact):return false
	if notice.is_empty() and (notice_paid_fact or notice_failed_fact):return false
	var physical:=str(value.get("j11_physical_level","NONE"));var physical_fact:Dictionary=restored_knowledge.get("fact_mathilde_physical_event_occurred",{});var aftercare:Dictionary=restored_obligations.get("aftercare_mathilde_j11",{})
	if physical in ["MATHILDE_M_B2","MATHILDE_M_B3"]:
		if str(physical_fact.get("physical_level",""))!=physical or str(aftercare.get("status","")) not in ["PAID","FAILED"]:return false
		if (physical=="MATHILDE_M_B2" and not choices.has("choice_j11_mathilde_m_b2_hold")) or (physical=="MATHILDE_M_B3" and not choices.has("choice_j11_mathilde_m_b3_accept")):return false
	elif not physical_fact.is_empty() or not aftercare.is_empty():return false
	if physical=="RAPHAELLE_FIRST_KISS" and (str(value.get("j11_pivot",""))!="RAPHAELLE" or str(value.get("j11_pivot_outcome",""))!="FIRST_KISS" or not choices.has("choice_j11_raphaelle_meeting_accept")):return false
	var priority:=str(value.get("j16_priority",""));var consequence:=str(value.get("j16_consequence_outcome",""));var payment:Dictionary=restored_promises.get("j16_priority_consequence_payment",{});var payment_record:Dictionary=restored_traces.get("j16_consequence_payment_record_01",{})
	if payment_record.is_empty():return false
	if priority=="FALLBACK":
		if consequence!="FALLBACK_CONFIRM" or not payment.is_empty() or str(payment_record.get("consequence_outcome",""))!="DIRECT_TO_MATHILDE_MARIE_J17_PREPARATION":return false
	else:
		var contested:=consequence.ends_with("_CONTEST")
		if not consequence.begins_with(priority+"_") or str(payment.get("status",""))!=("FAILED" if contested else "PAID") or str(payment_record.get("consequence_outcome",""))!=("CONSEQUENCE_FAILED" if contested else "CONSEQUENCE_PAID"):return false
	return true
func _j17_discussion_state(value:Dictionary)->String:
	var outcome:=str(value.get("j16_j17_outcome","UNESTABLISHED"));var restored_promises:Dictionary=value.get("promises",{});var has_promise:=restored_promises.has("marie_j16_couple_conversation_j17");var status:=str(restored_promises.get("marie_j16_couple_conversation_j17",{}).get("status",""));var resolved:=str(value.get("j17_couple_outcome","UNESTABLISHED"))!="UNESTABLISHED"
	if outcome=="ACCEPT" and has_promise and status==("PAID" if resolved else "ACTIVE"):return "DUE"
	if outcome in ["REFUSE","ALTERNATIVE"] and not has_promise:return "NOT_DUE"
	return "INVALID"
func _j17_witness_fact_coherent(value:Dictionary)->bool:
	var restored_knowledge:Dictionary=value.get("knowledge",{});var restored_traces:Dictionary=value.get("traces",{});var fact:Dictionary=restored_knowledge.get("fact_witness_saw_limited_trace",{});var discovery:Dictionary=restored_traces.get("j14_discovery_event_01",{});var witness:=str(value.get("j14_witness",""));var trace_id:=str(fact.get("discovered_trace_id",""))
	return not fact.is_empty() and not discovery.is_empty() and witness!="" and str(fact.get("source_ref",""))=="j14_discovery_event_01" and str(fact.get("witness_id",""))==witness and fact.get("current_knowers",[]).has(witness) and trace_id!="" and str(discovery.get("discovered_trace_id",""))==trace_id
func _j17_d1_aftercare_failed_and_known(value:Dictionary)->bool:
	var restored_knowledge:Dictionary=value.get("knowledge",{});var restored_obligations:Dictionary=value.get("obligations",{});var fact:Dictionary=restored_knowledge.get("fact_witness_saw_limited_trace",{})
	return str(value.get("j11_physical_level","")) in ["MATHILDE_M_B2","MATHILDE_M_B3"] and str(restored_obligations.get("aftercare_mathilde_j11",{}).get("status",""))=="FAILED" and str(value.get("j14_variant",""))=="MATHILDE" and str(value.get("j14_witness",""))=="Marie" and str(fact.get("discovered_trace_id",""))=="j11_mathilde_physical_aftercare_01" and fact.get("current_knowers",[]).has("Marie")
func _j17_d1_audience_breach_notice_failed(value:Dictionary)->bool:
	var restored_knowledge:Dictionary=value.get("knowledge",{});var restored_promises:Dictionary=value.get("promises",{});var witness_fact:Dictionary=restored_knowledge.get("fact_witness_saw_limited_trace",{});var failure:Dictionary=restored_knowledge.get("fact_trace_controller_not_informed",{})
	return str(value.get("j14_witness",""))=="Marie" and witness_fact.get("current_knowers",[]).has("Marie") and str(restored_promises.get("j14_inform_trace_controller",{}).get("status",""))=="FAILED" and str(failure.get("source_ref",""))=="j14_inform_trace_controller"
func _j17_d1_repeated_deception_then_contested(value:Dictionary)->bool:
	var restored_promises:Dictionary=value.get("promises",{});var restored_traces:Dictionary=value.get("traces",{})
	return str(value.get("j14_witness",""))=="Marie" and str(value.get("j15_outcome","")) in ["DUE_FAIL","REPAIR_LIE","OPEN_LIE"] and str(value.get("j16_priority",""))=="MARIE" and str(value.get("j16_consequence_outcome",""))=="MARIE_CONTEST" and str(restored_promises.get("j16_priority_consequence_payment",{}).get("status",""))=="FAILED" and str(restored_traces.get("j16_consequence_payment_record_01",{}).get("consequence_outcome",""))=="CONSEQUENCE_FAILED"
func _j17_marie_known_severe_violation_unrepaired(value:Dictionary)->bool:return _j17_d1_aftercare_failed_and_known(value) or _j17_d1_audience_breach_notice_failed(value) or _j17_d1_repeated_deception_then_contested(value)
func _j17_material_fact_hidden(value:Dictionary)->bool:
	var restored_knowledge:Dictionary=value.get("knowledge",{});var physical:=str(restored_knowledge.get("fact_mathilde_physical_event_occurred",{}).get("physical_level",""))
	return physical in ["MATHILDE_M_B2","MATHILDE_M_B3"] or (str(value.get("j11_pivot",""))=="RAPHAELLE" and str(value.get("j11_pivot_outcome",""))=="FIRST_KISS" and str(value.get("j11_physical_level",""))=="RAPHAELLE_FIRST_KISS")
func _j17_incompatible_version_active(value:Dictionary)->bool:
	var restored_promises:Dictionary=value.get("promises",{});var restored_traces:Dictionary=value.get("traces",{})
	return str(value.get("j15_outcome","")) in ["DUE_FAIL","REPAIR_LIE","OPEN_LIE"] and str(value.get("j16_priority","")) in ["MARIE","MATHILDE"] and str(value.get("j16_consequence_outcome","")) in ["MARIE_CONTEST","MATHILDE_CONTEST"] and str(restored_promises.get("j16_priority_consequence_payment",{}).get("status",""))=="FAILED" and str(restored_traces.get("j16_consequence_payment_record_01",{}).get("consequence_outcome",""))=="CONSEQUENCE_FAILED"
func _j17_repeated_marie_acts_proven(value:Dictionary)->bool:
	var restored_promises:Dictionary=value.get("promises",{});var shared_evening:=str(restored_promises.get("marie_j01_shared_evening",{}).get("status",""))=="PAID" and str(value.get("marie_j08_household_resolution",""))=="PAID" and str(restored_promises.get("marie_j07_household_request",{}).get("status",""))=="PAID"
	var shared_meal:=str(value.get("marie_j03_return_outcome","")) in ["ACTIVE","BOUNDED"] and (str(restored_promises.get("marie_j09_dinner_j10_2030",{}).get("status",""))=="PAID" or str(restored_promises.get("marie_j09_dinner_friday_2030",{}).get("status",""))=="PAID")
	var shared_hour:=str(value.get("marie_j05_shared_hour_resolution",""))=="PAID" and str(restored_promises.get("marie_j05_shared_hour",{}).get("status",""))=="PAID" and str(restored_promises.get("marie_j12_laverriere_presence",{}).get("status",""))=="PAID"
	var reconnection:=str(value.get("marie_j09_presence_outcome","")) in ["presence_active","presence_playful_useful","presence_late_active","presence_bounded_reliable","absence_honest"] and str(value.get("j11_pivot",""))=="MARIE" and str(value.get("j11_pivot_outcome","")) in ["MARIE_ADULT_RECONQUEST","MARIE_NON_ADULT_RECONNECTION","MARIE_SEX_NOT_USED_AS_BANDAGE","MARIE_HONEST_REFUSAL"]
	return shared_evening or shared_meal or shared_hour or reconnection
func _j17_sufficient_truth_proven(value:Dictionary)->bool:return _j17_structural_input_valid(value) and not _j17_material_fact_hidden(value) and not _j17_incompatible_version_active(value)
func _j17_no_active_violation(value:Dictionary)->bool:return not _j17_marie_known_severe_violation_unrepaired(value) and not _j17_material_fact_hidden(value) and not _j17_incompatible_version_active(value)
func _j17_concrete_rule_proven(value:Dictionary,choice_id:String)->bool:return _j17_structural_input_valid(value) and choice_id=="choice_j17_reconquest"
func _j17_external_desire_acknowledged(value:Dictionary,choice_id:String)->bool:
	var source_present:=(str(value.get("j11_pivot",""))=="SANDRA" and str(value.get("j11_pivot_outcome",""))=="SANDRA_DESIRE_BOUNDED") or (str(value.get("j11_pivot",""))=="RAPHAELLE" and str(value.get("j11_pivot_outcome",""))=="RESULT_SENT_ATTRACTION_NAMED")
	return _j17_structural_input_valid(value) and source_present and choice_id=="choice_j17_provisional"
func _j17_audiences_safe_or_repaired(value:Dictionary)->bool:
	if not _j17_structural_input_valid(value):return false
	if str(value.get("j14_variant",""))=="S27_MUTATION_NO_DISCOVERY":return true
	var restored_promises:Dictionary=value.get("promises",{});var restored_knowledge:Dictionary=value.get("knowledge",{})
	return _j17_witness_fact_coherent(value) and str(restored_promises.get("j14_inform_trace_controller",{}).get("status",""))=="PAID" and bool(value.get("j14_controller_notified",false)) and restored_knowledge.has("fact_trace_controller_informed_of_audience_breach") and not restored_knowledge.has("fact_trace_controller_not_informed")
func _j17_external_progression_pause_accepted(value:Dictionary,choice_id:String)->bool:return _j17_structural_input_valid(value) and choice_id=="choice_j17_provisional"
func _j17_marie_full_refusal_right_explicitly_acknowledged(value:Dictionary,choice_id:String)->bool:return _j17_structural_input_valid(value) and choice_id=="choice_j17_provisional"
func _j17_satisfied_constructive_condition_ids(value:Dictionary,choice_id:String)->Array[String]:
	var ids:Array[String]=[]
	if _j17_repeated_marie_acts_proven(value):ids.append("J17_REPEATED_MARIE_ACTS_PROVEN")
	if _j17_sufficient_truth_proven(value):ids.append("J17_SUFFICIENT_TRUTH_PROVEN")
	if _j17_no_active_violation(value):ids.append("J17_NO_ACTIVE_VIOLATION")
	if _j17_concrete_rule_proven(value,choice_id):ids.append("J17_CONCRETE_RULE_PROVEN")
	if _j17_external_desire_acknowledged(value,choice_id):ids.append("J17_EXTERNAL_DESIRE_ACKNOWLEDGED")
	if _j17_audiences_safe_or_repaired(value):ids.append("J17_AUDIENCES_SAFE_OR_REPAIRED")
	if _j17_external_progression_pause_accepted(value,choice_id):ids.append("J17_EXTERNAL_PROGRESSION_PAUSE_ACCEPTED")
	if _j17_marie_full_refusal_right_explicitly_acknowledged(value,choice_id):ids.append("J17_MARIE_FULL_REFUSAL_RIGHT_EXPLICITLY_ACKNOWLEDGED")
	return ids
func _j17_guard_reference_exists(value:Dictionary,id:String)->bool:
	if id.begins_with("choice_"):return value.get("selected_choice_ids",[]).has(id)
	if id in ["aftercare_mathilde_j11"]:return value.get("obligations",{}).has(id)
	if id in ["j14_inform_trace_controller","j16_priority_consequence_payment"]:return value.get("promises",{}).has(id)
	if id in ["j16_consequence_payment_record_01"]:return value.get("traces",{}).has(id)
	return value.get("knowledge",{}).has(id)
func _j17_add_guard_reference(value:Dictionary,ids:Array[String],id:String)->void:
	if J17_GUARD_FACT_IDS.has(id) and _j17_guard_reference_exists(value,id) and not ids.has(id):ids.append(id)
func _j17_triggered_guard_fact_ids(value:Dictionary,resolved_state:String,choice_id:String)->Array[String]:
	var ids:Array[String]=[]
	if choice_id in ["choice_j17_separation","choice_j17_refused_acknowledge"]:return ids
	if resolved_state=="FRACTURE":
		if _j17_d1_aftercare_failed_and_known(value):
			for id in ["fact_mathilde_physical_event_occurred","aftercare_mathilde_j11","fact_witness_saw_limited_trace","choice_j11_mathilde_m_b2_hold","choice_j11_mathilde_m_b3_accept"]:_j17_add_guard_reference(value,ids,id)
		if _j17_d1_audience_breach_notice_failed(value):
			for id in ["fact_witness_saw_limited_trace","j14_inform_trace_controller","fact_trace_controller_not_informed"]:_j17_add_guard_reference(value,ids,id)
		if _j17_d1_repeated_deception_then_contested(value):
			for id in ["fact_player_explanation_to_witness","fact_j15_obligation_resolution","j16_priority_consequence_payment","j16_consequence_payment_record_01"]:_j17_add_guard_reference(value,ids,id)
	elif resolved_state=="DOUBLE_LIFE_FRAGILE":
		if _j17_material_fact_hidden(value):
			for id in ["fact_mathilde_physical_event_occurred","choice_j11_mathilde_m_b2_hold","choice_j11_mathilde_m_b3_accept","choice_j11_raphaelle_meeting_accept"]:_j17_add_guard_reference(value,ids,id)
		if _j17_incompatible_version_active(value):
			for id in ["fact_player_explanation_to_witness","fact_j15_obligation_resolution","j16_priority_consequence_payment","j16_consequence_payment_record_01"]:_j17_add_guard_reference(value,ids,id)
	return ids
func complete_j17()->bool:
	if current_day!="J17" or j17_departure_outcome=="UNESTABLISHED" or j17_couple_outcome=="UNESTABLISHED":return false
	if not complete_conversation("chapter_17_departure_and_couple","marie","departure_and_couple_definition"):return false
	return complete_day()
func begin_j18()->bool:
	if current_day!="J17" or day_status!="COMPLETE":return false
	current_day="J18";day_status="ACTIVE";j18_sandra_outcome="UNESTABLISHED";return true
func apply_j18_choice(choice_id:String)->bool:
	var allowed:=["choice_j18_recognize","choice_j18_future","choice_j18_minimize","choice_j18_recognize_removed","choice_j18_future_removed","choice_j18_minimize_removed","choice_j18_recognize_compromised","choice_j18_future_compromised","choice_j18_minimize_compromised","choice_j18_recognize_simple","choice_j18_future_simple","choice_j18_minimize_simple"]
	if current_day!="J18" or j18_sandra_outcome!="UNESTABLISHED" or choice_id not in allowed:return false
	selected_choice_ids.append(choice_id);var source:Dictionary=traces.get("j11_sandra_chosen_image_01",{});var compromised:=knowledge.has("fact_witness_saw_limited_trace") and j14_variant=="SANDRA";var removed:=str(source.get("current_state",""))=="REMOVED"
	if choice_id.begins_with("choice_j18_minimize"):j18_sandra_outcome="TRUST_BROKEN" if compromised else "PROTECTIVE_DISTANCE"
	elif choice_id.begins_with("choice_j18_future") and not compromised and not removed:j18_sandra_outcome="PRIVILEGED_CONFIDENCE"
	elif removed or compromised:j18_sandra_outcome="PROTECTIVE_DISTANCE"
	else:j18_sandra_outcome="FRIENDSHIP_RESTORED"
	traces["j18_sandra_lunch_print_01"]={"trace_id":"j18_sandra_lunch_print_01","trace_type":"PHYSICAL_PRINT","source_day":"J18","source_scene":"Sandra choisit ce qu’elle garde","creator":"Sandra","subjects":["Sandra"],"owner":"Sandra","initial_audience":["Sandra"],"current_audience":["Sandra"],"storage_location":"archive physique Sandra","saving_rule":"OWNER_ONLY","transfer_rule":"OWNER_CONFIRMATION_REQUIRED","current_state":"ACTIVE","replaces_or_derives_from":"j01_sandra_lunch_memory_soft","knowledge_created":"fact_sandra_kept_physical_lunch_trace","eligible_for_j21":true}
	knowledge["fact_sandra_kept_physical_lunch_trace"]={"fact_id":"fact_sandra_kept_physical_lunch_trace","source_type":"PRIVATE_TRACE","source_ref":"j18_sandra_lunch_print_01","initial_knowers":["Sandra"],"certainty":"CONFIRMED","shareability":"OWNER_ONLY","source_day":"J18"};return true
func complete_j18()->bool:
	if current_day!="J18" or j18_sandra_outcome=="UNESTABLISHED":return false
	if not complete_conversation("chapter_18_sandra_resolution","sandra","owner_control_resolution"):return false
	return complete_day()
func begin_j19()->bool:
	if current_day!="J18" or day_status!="COMPLETE":return false
	current_day="J19";day_status="ACTIVE";j19_pivot=select_j19_pivot();j19_pauline_outcome="UNESTABLISHED";j19_raphaelle_outcome="UNESTABLISHED";j19_raphaelle_invitation_pending=false;return true
func select_j19_pivot()->String:
	if j14_variant=="PAULINE":return "PAULINE"
	if j14_variant=="RAPHAELLE" or j11_physical_level=="RAPHAELLE_FIRST_KISS":return "RAPHAELLE"
	if traces.has("j13_pauline_private_version_01"):return "PAULINE"
	if j19_raphaelle_has_creative_access():return "RAPHAELLE"
	return "FALLBACK"
func j19_pauline_has_private_compartment()->bool:
	return traces.has("j13_pauline_private_version_01") and str(traces["j13_pauline_private_version_01"].get("current_state","")) not in ["REMOVED","INACCESSIBLE","NOT_CREATED"]
func j19_raphaelle_has_creative_access()->bool:
	return raphaelle_state=="CREATIVE_ACCESS" or (traces.has("j13_raphaelle_masked_version_01") and str(traces["j13_raphaelle_masked_version_01"].get("current_state",""))=="PRIVATE_ACTIVE") or (traces.has("j11_raphaelle_chosen_result_01") and str(traces["j11_raphaelle_chosen_result_01"].get("current_state",""))=="PRIVATE_ACTIVE")
func apply_j19_secondary()->bool:
	if current_day!="J19":return false
	if j19_pivot in ["PAULINE","FALLBACK"]:
		if j19_raphaelle_outcome!="UNESTABLISHED":return false
		j19_raphaelle_outcome="CREATIVE_CONFIDENCE" if j19_raphaelle_has_creative_access() else "COLLEAGUE_ONLY";_record_j19_raphaelle_access();return true
	if j19_pivot=="RAPHAELLE" and j19_pauline_outcome=="UNESTABLISHED":
		j19_pauline_outcome="COMPARTMENT_PROTECTED" if j19_pauline_has_private_compartment() else "SURFACE_RESTORED";_record_j19_pauline_state();return true
	return false
func apply_j19_foreground_choice(choice_id:String)->bool:
	if current_day!="J19":return false
	if j19_pivot=="PAULINE" and j19_pauline_outcome=="UNESTABLISHED" and choice_id in ["choice_j19_pauline_close","choice_j19_pauline_protect","choice_j19_pauline_pressure"]:
		selected_choice_ids.append(choice_id);j19_pauline_outcome={"choice_j19_pauline_close":"SURFACE_RESTORED","choice_j19_pauline_protect":"COMPARTMENT_PROTECTED","choice_j19_pauline_pressure":"COMPARTMENT_CLOSED"}[choice_id];_record_j19_pauline_state();return true
	if j19_pivot=="RAPHAELLE" and j19_raphaelle_outcome=="UNESTABLISHED" and choice_id in ["choice_j19_raphaelle_process","choice_j19_raphaelle_future","choice_j19_raphaelle_reduce"]:
		selected_choice_ids.append(choice_id)
		if choice_id=="choice_j19_raphaelle_future":j19_raphaelle_invitation_pending=true;return true
		j19_raphaelle_outcome="CREATIVE_CONFIDENCE" if choice_id=="choice_j19_raphaelle_process" else "BOUNDARY_REINFORCED";_record_j19_raphaelle_access();return true
	return false
func apply_j19_invitation_choice(choice_id:String)->bool:
	if current_day!="J19" or j19_pivot!="RAPHAELLE" or not j19_raphaelle_invitation_pending or choice_id not in ["choice_j19_invitation_accept","choice_j19_invitation_refuse"]:return false
	selected_choice_ids.append(choice_id);j19_raphaelle_invitation_pending=false;j19_raphaelle_outcome="FUTURE_INVITATION" if choice_id=="choice_j19_invitation_accept" else "CREATIVE_CONFIDENCE"
	promises["raphaelle_future_atelier_saturday_1500"]={"promise_id":"raphaelle_future_atelier_saturday_1500","promise_type":"MEETING","created_at":"J19","created_by":"Raphaëlle","proposed_to":"Player","accepted_at":"J19_PLAYER_CHOICE" if choice_id=="choice_j19_invitation_accept" else "","due_at":"samedi suivant, 15 h–17 h","confirmation_deadline":"avant le vendredi précédent","status":"ACTIVE" if choice_id=="choice_j19_invitation_accept" else "REFUSED"}
	_record_j19_raphaelle_access();return true
func apply_j19_fallback_choice(choice_id:String)->bool:
	if current_day!="J19" or j19_pivot!="FALLBACK" or j19_pauline_outcome!="UNESTABLISHED" or choice_id!="choice_j19_pauline_fallback_ack":return false
	selected_choice_ids.append(choice_id);j19_pauline_outcome="SURFACE_RESTORED";_record_j19_pauline_state();return true
func _record_j19_pauline_state()->void:
	knowledge["fact_pauline_private_state_defined"]={"fact_id":"fact_pauline_private_state_defined","source_type":"DIRECT_MESSAGE","source_ref":"J19","initial_knowers":["Pauline","Player"],"certainty":"CONFIRMED","shareability":"PRIVATE_DO_NOT_SHARE","outcome":j19_pauline_outcome}
func _record_j19_raphaelle_access()->void:
	var current_state:="ACTIVE" if j19_raphaelle_outcome in ["CREATIVE_CONFIDENCE","FUTURE_INVITATION"] else ("NOT_CREATED" if j19_raphaelle_outcome=="COLLEAGUE_ONLY" else "REMOVED");traces["j19_raphaelle_creative_access_01"]={"trace_id":"j19_raphaelle_creative_access_01","trace_type":"ACCESS_GRANT" if current_state=="ACTIVE" else "ACCESS_REVOCATION","source_day":"J19","source_scene":"après le rôle","creator":"Raphaëlle","subjects":["Raphaëlle","Player","processus créatif"],"owner":"Raphaëlle","initial_audience":["Raphaëlle","Player"],"current_audience":["Raphaëlle","Player"] if current_state=="ACTIVE" else (["Raphaëlle"] if current_state=="REMOVED" else []),"storage_location":"compte créatif / dossier fabrication","saving_rule":"OWNER_ONLY","transfer_rule":"FORBIDDEN","current_state":current_state,"knowledge_created":"fact_raphaelle_access_state_defined","eligible_for_j21":true};knowledge["fact_raphaelle_access_state_defined"]={"fact_id":"fact_raphaelle_access_state_defined","source_type":"DIRECT_MESSAGE","source_ref":"j19_raphaelle_creative_access_01","initial_knowers":["Raphaëlle","Player"],"certainty":"CONFIRMED","shareability":"PRIVATE_DO_NOT_SHARE","outcome":j19_raphaelle_outcome}
func complete_j19()->bool:
	if current_day!="J19" or j19_pauline_outcome=="UNESTABLISHED" or j19_raphaelle_outcome=="UNESTABLISHED" or j19_raphaelle_invitation_pending:return false
	if not complete_conversation("chapter_19_private_versions","network","private_versions_defined"):return false
	return complete_day()
func begin_j20()->bool:
	if current_day!="J19" or day_status!="COMPLETE":return false
	current_day="J20";day_status="ACTIVE";j20_context=select_j20_context();j20_nico_position="UNESTABLISHED";j20_meeting_outcome="UNESTABLISHED";return true
func select_j20_context()->String:
	if traces.has("j13_nico_alibi_or_hour_message_01"):return "ALIBI"
	if traces.has("j07_nico_confidence_01") or nico_state=="CONFIDENCE_ACTIVE":return "CONFIDENCE"
	return "ORDINARY"
func apply_j20_position_choice(choice_id:String)->bool:
	var allowed:=["choice_j20_truth_alibi","choice_j20_limit_alibi","choice_j20_cover_alibi","choice_j20_truth_confidence","choice_j20_limit_confidence","choice_j20_cover_confidence","choice_j20_ordinary"]
	if current_day!="J20" or j20_nico_position!="UNESTABLISHED" or choice_id not in allowed:return false
	selected_choice_ids.append(choice_id)
	if choice_id=="choice_j20_ordinary":j20_nico_position="ORDINARY_FRIEND"
	elif choice_id.begins_with("choice_j20_cover"):j20_nico_position="DISTANCE"
	elif choice_id.begins_with("choice_j20_truth"):j20_nico_position="GUARDRAIL" if j20_context=="ALIBI" else "LIMITED_CONFIDANT"
	else:j20_nico_position="LIMITED_CONFIDANT" if j20_context=="CONFIDENCE" else "GUARDRAIL"
	if j20_context=="ALIBI" and traces.has("j13_nico_alibi_or_hour_message_01"):
		var alibi_trace:Dictionary=traces["j13_nico_alibi_or_hour_message_01"];alibi_trace["current_state"]="RESTRICTED";traces["j13_nico_alibi_or_hour_message_01"]=alibi_trace
	knowledge["fact_nico_friendship_position_defined"]={"fact_id":"fact_nico_friendship_position_defined","source_type":"DIRECT_MESSAGE","source_ref":"J20","initial_knowers":["Nico","Player"],"certainty":"CONFIRMED","shareability":"PRIVATE_DO_NOT_SHARE sauf faits précis","position":j20_nico_position};return true
func apply_j20_meeting_choice(choice_id:String)->bool:
	if current_day!="J20" or j20_nico_position in ["UNESTABLISHED","DISTANCE"] or j20_meeting_outcome!="UNESTABLISHED" or choice_id not in ["choice_j20_meeting_accept","choice_j20_meeting_refuse"]:return false
	selected_choice_ids.append(choice_id);j20_meeting_outcome="ACTIVE" if choice_id=="choice_j20_meeting_accept" else "REFUSED";promises["nico_j20_lannexe_2120"]={"promise_id":"nico_j20_lannexe_2120","promise_type":"MEETING","created_at":"J20 18 h 57","created_by":"Nico","proposed_to":"Player","accepted_at":"choix Player" if choice_id=="choice_j20_meeting_accept" else "","due_at":"J20 21 h 20","confirmation_deadline":"avant fermeture de L’Annexe","status":j20_meeting_outcome,"paid_or_closed_by":"rencontre hors téléphone ou refus","related_scene":"résolution Nico","related_trace_ids":["j20_nico_exact_hour_record_01"]};return true
func pay_j20_meeting()->bool:
	if current_day!="J20" or j20_meeting_outcome!="ACTIVE":return false
	var promise:Dictionary=promises.get("nico_j20_lannexe_2120",{});if str(promise.get("status",""))!="ACTIVE":return false
	promise.status="PAID";promise["resolved_at"]="J20 21 h 20";promises["nico_j20_lannexe_2120"]=promise;j20_meeting_outcome="PAID";return true
func close_j20_without_meeting()->bool:
	if current_day!="J20" or j20_nico_position!="DISTANCE" or j20_meeting_outcome!="UNESTABLISHED":return false
	j20_meeting_outcome="NOT_OFFERED";return true
func select_final_trace_after_j20()->bool:
	if current_day!="J20" or j20_nico_position=="UNESTABLISHED":return false
	var candidates:Array=[]
	for trace_id in ["j20_nico_unauthorized_copy_deleted_01","j20_nico_exact_hour_record_01","j13_nico_alibi_or_hour_message_01"]:
		if traces.has(trace_id):candidates.append(trace_id)
	if j19_pivot=="PAULINE" and traces.has("j13_pauline_private_version_01"):candidates.append("j13_pauline_private_version_01")
	if j19_pivot=="RAPHAELLE" and traces.has("j19_raphaelle_creative_access_01") and str(traces["j19_raphaelle_creative_access_01"].get("current_state","")) not in ["REMOVED","NOT_CREATED"]:candidates.append("j19_raphaelle_creative_access_01")
	for trace_id in ["j18_sandra_lunch_print_01","j17_couple_definition_record_01","j12_laverriere_public_group_set_01","j11_sandra_chosen_image_01"]:
		if traces.has(trace_id):candidates.append(trace_id)
	if candidates.is_empty():return false
	final_trace_id=str(candidates[0]);var trace:Dictionary=traces[final_trace_id];final_trace_state=str(trace.get("current_state","ACTIVE"));final_trace_controller=str(trace.get("owner",trace.get("creator","état de connaissance")));final_trace_audience.assign(trace.get("current_audience",trace.get("initial_audience",[])));knowledge["fact_final_trace_selected"]={"fact_id":"fact_final_trace_selected","source_type":"INFERENCE","source_ref":final_trace_id,"initial_knowers":["Player"],"certainty":"CONFIRMED","shareability":"SAME_AUDIENCE_ONLY"};return true
func complete_j20()->bool:
	if current_day!="J20" or j20_nico_position=="UNESTABLISHED" or j20_meeting_outcome not in ["PAID","REFUSED","NOT_OFFERED"]:return false
	if final_trace_id=="" and not select_final_trace_after_j20():return false
	if not complete_conversation("chapter_20_nico_position","nico","friendship_position_defined"):return false
	return complete_day()

func begin_j21()->bool:
	if current_day!="J20" or day_status!="COMPLETE" or final_trace_id=="" or not traces.has(final_trace_id):return false
	current_day="J21";day_status="ACTIVE";j21_morning_outcome="UNESTABLISHED";final_posture="UNESTABLISHED";existing_contradiction_id=_existing_contradiction_before_j21();final_posture_options=["RULE_ACTED","LOSS_ACKNOWLEDGED"]
	if existing_contradiction_id!="":final_posture_options.append("EXISTING_CONTRADICTION_MAINTAINED")
	return true
func _existing_contradiction_before_j21()->String:
	if couple_state=="DOUBLE_LIFE_FRAGILE":return "COUPLE_DOUBLE_LIFE"
	if j19_pauline_outcome=="COMPARTMENT_PROTECTED":return "PAULINE_COMPARTMENT"
	return ""
func apply_j21_morning_choice(choice_id:String)->bool:
	if current_day!="J21" or day_status!="ACTIVE" or j21_morning_outcome!="UNESTABLISHED":return false
	var allowed:Dictionary={
		"RECONQUEST_ACTIVE":["choice_j21_morning_1930","choice_j21_morning_absent"],
		"PROVISIONAL_AGREEMENT":["choice_j21_morning_agree"],
		"RECONFIGURATION_NEGOTIATION":["choice_j21_morning_understood"],
		"DOUBLE_LIFE_FRAGILE":["choice_j21_morning_real_hour","choice_j21_morning_vague","choice_j21_morning_false_hour"],
		"FRACTURE":["choice_j21_morning_received"],
		"SEPARATION":["choice_j21_boxes_accept","choice_j21_boxes_refuse"],
	}
	if choice_id not in allowed.get(couple_state,[]):return false
	selected_choice_ids.append(choice_id);j21_morning_outcome={"choice_j21_morning_1930":"PRESENCE_1930","choice_j21_morning_absent":"HONEST_ABSENCE","choice_j21_morning_agree":"PROVISIONAL_RULE_ACKNOWLEDGED","choice_j21_morning_understood":"RECONFIGURATION_RULE_ACKNOWLEDGED","choice_j21_morning_real_hour":"REAL_HOUR_2015","choice_j21_morning_vague":"IMPRECISE_HOUR","choice_j21_morning_false_hour":"FALSE_HOUR_MAINTAINED","choice_j21_morning_received":"PRACTICAL_REQUEST_ACKNOWLEDGED","choice_j21_boxes_accept":"BOXES_ACTIVE","choice_j21_boxes_refuse":"BOXES_REFUSED"}[choice_id]
	if couple_state=="SEPARATION":
		var status:="ACTIVE" if choice_id=="choice_j21_boxes_accept" else "REFUSED";promises["marie_player_boxes_wednesday_1830"]={"promise_id":"marie_player_boxes_wednesday_1830","promise_type":"MEETING","created_at":"J21 07 h 44","created_by":"Marie","proposed_to":"Player","accepted_at":"choix Player" if status=="ACTIVE" else "","due_at":"mercredi après J21 18 h 30","confirmation_deadline":"mardi soir","status":status,"paid_or_closed_by":"récupération des cartons ou refus","related_scene":"matin de séparation","related_trace_ids":[]}
	return true
func apply_j21_final_posture(choice_id:String)->bool:
	if current_day!="J21" or j21_morning_outcome=="UNESTABLISHED" or final_posture!="UNESTABLISHED":return false
	var posture:String=str({"choice_j21_rule":"RULE_ACTED","choice_j21_loss":"LOSS_ACKNOWLEDGED","choice_j21_contradiction":"EXISTING_CONTRADICTION_MAINTAINED"}.get(choice_id,""))
	if posture=="" or posture not in final_posture_options:return false
	selected_choice_ids.append(choice_id);final_posture=posture;knowledge["fact_final_posture"]={"fact_id":"fact_final_posture","source_type":"DIRECT_MESSAGE","source_ref":"J21","initial_knowers":["Player",final_trace_controller],"certainty":"CONFIRMED","shareability":"SAME_AUDIENCE_ONLY","posture":final_posture}
	if final_posture=="EXISTING_CONTRADICTION_MAINTAINED":knowledge["fact_existing_contradiction_maintained"]={"fact_id":"fact_existing_contradiction_maintained","source_type":"INFERENCE","source_ref":existing_contradiction_id,"initial_knowers":["Player"],"certainty":"CONFIRMED","shareability":"PRIVATE_DO_NOT_SHARE"}
	return true
func complete_j21()->bool:
	if current_day!="J21" or j21_morning_outcome=="UNESTABLISHED" or final_posture=="UNESTABLISHED" or final_trace_id=="" or not traces.has(final_trace_id):return false
	if not complete_conversation("chapter_21_final_trace","network","trace_recontextualized"):return false
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
		"obligations": obligations.duplicate(true),
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
		"marie_j09_presence_choice": marie_j09_presence_choice,
		"marie_j09_presence_outcome": marie_j09_presence_outcome,
		"marie_j09_dinner_outcome": marie_j09_dinner_outcome,
		"j10_pivot": j10_pivot,
		"j10_pivot_reason": j10_pivot_reason,
		"j10_pivot_outcome": j10_pivot_outcome,
		"marie_j10_dinner_resolution": marie_j10_dinner_resolution,
		"nico_j10_morning_confirmation": nico_j10_morning_confirmation,
		"j11_pivot": j11_pivot,
		"j11_pivot_reason": j11_pivot_reason,
		"j11_pivot_outcome": j11_pivot_outcome,
		"j11_physical_level": j11_physical_level,
		"mathilde_j11_state": mathilde_j11_state,
		"mathilde_has_independent_sleep_option": mathilde_has_independent_sleep_option,
		"mathilde_can_leave_safely": mathilde_can_leave_safely,
		"marie_absence_not_engineered": marie_absence_not_engineered,
		"j12_presence_choice": j12_presence_choice,
		"j12_private_outcome": j12_private_outcome,
		"j12_annexe_choice": j12_annexe_choice,
		"j12_priority_route": j12_priority_route,
		"j12_failed_aftercare_processed": j12_failed_aftercare_processed,
		"j13_pivot": j13_pivot,
		"j13_outcome": j13_outcome,
		"j13_j14_trace_id": j13_j14_trace_id,
		"j14_variant": j14_variant,
		"j14_outcome": j14_outcome,
		"j14_witness": j14_witness,
		"j14_witness_presence_evidence": j14_witness_presence_evidence,
		"j14_discovery_mode": j14_discovery_mode,
		"j14_visible_fields": j14_visible_fields.duplicate(),
		"j14_visible_values": j14_visible_values.duplicate(true),
		"j14_source_trace_id": j14_source_trace_id,
		"j14_secondary_trace_id": j14_secondary_trace_id,
		"j14_player_initial_reaction": j14_player_initial_reaction,
		"j14_player_explanation": j14_player_explanation,
		"j14_j15_obligation_id": j14_j15_obligation_id,
		"j14_controller_notified": j14_controller_notified,
		"j15_mode": j15_mode,
		"j15_outcome": j15_outcome,
		"j15_urgent_consequence_remaining": j15_urgent_consequence_remaining,
		"j16_priority": j16_priority,
		"j16_consequence_outcome": j16_consequence_outcome,
		"j16_departure_state": j16_departure_state,
		"j16_j17_outcome": j16_j17_outcome,
		"j17_departure_outcome": j17_departure_outcome,
		"j17_couple_outcome": j17_couple_outcome,
		"j18_sandra_outcome": j18_sandra_outcome,
		"j19_pivot": j19_pivot,
		"j19_pauline_outcome": j19_pauline_outcome,
		"j19_raphaelle_outcome": j19_raphaelle_outcome,
		"j19_raphaelle_invitation_pending": j19_raphaelle_invitation_pending,
		"j20_context": j20_context,
		"j20_nico_position": j20_nico_position,
		"j20_meeting_outcome": j20_meeting_outcome,
		"final_trace_id": final_trace_id,
		"final_trace_state": final_trace_state,
		"final_trace_controller": final_trace_controller,
		"final_trace_audience": final_trace_audience.duplicate(true),
		"existing_contradiction_id": existing_contradiction_id,
		"final_posture_options": final_posture_options.duplicate(),
		"final_posture": final_posture,
		"j21_morning_outcome": j21_morning_outcome,
		"resolved_visual_variant_by_asset": resolved_visual_variant_by_asset.duplicate(true),
	}

func restore_snapshot(value: Dictionary) -> bool:
	var version := int(value.get("version", -1))
	if version != SNAPSHOT_VERSION:
		return false
	if str(value.get("current_day", "")) not in ["J01", "J02", "J03", "J04", "J05", "J06", "J07", "J08", "J09", "J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"]:
		return false
	if not _snapshot_ledgers_have_dictionary_records(value):
		return false
	if str(value.get("day_status", "")) not in ["ACTIVE", "COMPLETE"]:
		return false
	if str(value.get("couple_state", "")) not in ["BASELINE_SHARED_LIFE", "STRAIN_VISIBLE", "RECONQUEST_ACTIVE", "PROVISIONAL_AGREEMENT", "RECONFIGURATION_NEGOTIATION", "DOUBLE_LIFE_FRAGILE", "FRACTURE", "SEPARATION"]:
		return false
	if str(value.get("sandra_state", "")) not in ["DISTANT_FRIEND", "RECONNECTION_OPEN"]:
		return false
	if str(value.get("raphaelle_state", "")) not in ["UN" + "ESTAB" + "LISHED", "PROFESSIONAL_ONLY", "CREATIVE_ACCESS"]: return false
	if str(value.get("raphaelle_work_outcome", "")) not in ["", "ACCOUNTABLE", "DRY_HUMOR", "DELAYED"]: return false
	if str(value.get("sandra_j03_echo_outcome", "")) not in ["", "UNAVAILABLE", "EXPIRED", "RESPONDED"]: return false
	if str(value.get("marie_j03_return_outcome", "")) not in ["", "ACTIVE", "BOUNDED", "DRIFT"]: return false
	if str(value.get("mathilde_state", "FAMILY_GUEST" if value.get("knowledge", {}).has("fact_mathilde_stay_started") else "UNESTABLISHED")) not in ["UNESTABLISHED", "FAMILY_GUEST", "DOMESTIC_FAMILIARITY", "LOOK_ACKNOWLEDGED", "INTENT_OPEN", "PROXIMITY_CONSENTED", "PHYSICAL_SECRET", "SECRET_SUSPENDED", "FAMILY_RELATION_PRESERVED", "DISTANCE", "TRUST_BROKEN"]: return false
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
	if str(value.get("marie_j09_presence_choice", "UNESTABLISHED")) not in ["UNESTABLISHED", "EARLY", "LATE", "ABSENCE_HONEST"]: return false
	if str(value.get("marie_j09_presence_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "presence_active", "presence_playful_useful", "presence_distracted", "presence_late_active", "presence_spectator", "presence_bounded_reliable", "absence_honest"]: return false
	if str(value.get("marie_j09_dinner_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "J10_ACCEPTED", "FRIDAY_ACCEPTED", "REFUSED", "NOT_OFFERED"]: return false
	if str(value.get("j10_pivot", "")) not in ["", "SANDRA", "MATHILDE", "RAPHAELLE", "NICO", "NONE"]: return false
	if str(value.get("j10_pivot_reason", "")) not in ["", "DUE_PROMISE_P07", "MARIE_CONSEQUENCE_PRIORITY", "LEAST_RECENT_FOREGROUND", "AUTHORED_ORDER", "NO_ELIGIBLE_PIVOT", "ALL_ACCESS_CLOSED"]: return false
	if str(value.get("marie_j10_dinner_resolution", "UNESTABLISHED")) not in ["UNESTABLISHED", "THURSDAY_DUE", "THURSDAY_PAID", "THURSDAY_AMENDED_TO_FRIDAY", "THURSDAY_FAILED_LATE", "THURSDAY_CANCELLED", "FRIDAY_RECONFIRMED", "NOT_DUE"]: return false
	if str(value.get("nico_j10_morning_confirmation", "UNESTABLISHED")) not in ["UNESTABLISHED", "NOT_DUE", "CONFIRMED_ACTIVE", "REFUSED", "EXPIRED"]: return false
	if str(value.get("j11_pivot", "")) not in ["", "SANDRA", "MATHILDE", "RAPHAELLE", "NICO", "MARIE", "RESPIRATION"]: return false
	if str(value.get("j11_pivot_reason", "")) not in ["", "J10_CONTINUATION", "J10_LIMIT_CONSEQUENCE", "P10_COUPLE_PRIORITY", "J10_NONE_MARIE_FALLBACK", "EXTERNAL_CLOSED_MARIE_CONSEQUENCE", "J10_NO_LEGITIMATE_CONTINUATION"]: return false
	if str(value.get("j11_pivot_outcome", "")) not in ["", "SANDRA_RULE_CLARIFIED", "SANDRA_DESIRE_BOUNDED", "SANDRA_IMAGE_REMOVED", "FIRST_KISS", "KISS_DECLINED", "RESULT_SENT_ATTRACTION_NAMED", "RESULT_SENT_BOUNDARY_HELD", "NICO_GUARDRAIL_HELD", "NICO_RIVALRY_MAINTAINED", "NICO_CLEAN_CLOSE", "MARIE_ADULT_RECONQUEST", "MARIE_NON_ADULT_RECONNECTION", "MARIE_SEX_NOT_USED_AS_BANDAGE", "MARIE_HONEST_REFUSAL", "MARIE_NO_RECONQUEST", "MATHILDE_LOOK_ONLY", "MATHILDE_M_B1", "MATHILDE_M_B2", "MATHILDE_M_B3", "MATHILDE_CLEAN_STOP", "MATHILDE_DISTANCE_RESTORED"]: return false
	if str(value.get("j11_physical_level", "NONE")) not in ["NONE", "PROXIMITY_ONLY", "MATHILDE_M_B2", "MATHILDE_M_B3", "MARIE_ADULT_RECONQUEST", "RAPHAELLE_FIRST_KISS"]: return false
	if str(value.get("mathilde_j11_state", "UNESTABLISHED")) not in ["UNESTABLISHED", "PROXIMITY_CONSENTED", "PHYSICAL_SECRET", "DISTANCE"]: return false
	if str(value.get("j12_presence_choice", "UNESTABLISHED")) not in ["UNESTABLISHED", "L-A", "L-B", "L-C"]: return false
	if str(value.get("j12_annexe_choice", "UNESTABLISHED")) not in ["UNESTABLISHED", "A12", "B12", "C12"]: return false
	if str(value.get("j12_priority_route", "UNESTABLISHED")) not in ["UNESTABLISHED", "SANDRA", "MATHILDE", "RAPHAELLE", "NICO", "MARIE", "NETWORK"]: return false
	if str(value.get("j13_pivot", "")) not in ["", "PAULINE", "RAPHAELLE", "NICO", "SANDRA", "MATHILDE", "MARIE", "RESPIRATION"]: return false
	if str(value.get("j14_variant", "")) not in ["", "PAULINE", "SANDRA", "MATHILDE", "RAPHAELLE", "NICO", "S27_MUTATION_NO_DISCOVERY"]: return false
	if str(value.get("j14_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "TRUTH_LIMITED", "MINIMIZE_OR_LIE", "PROTECT_AND_DEFER", "PROTECT_AND_ANSWER_NOW", "S27_MUTATION_NO_DISCOVERY"]: return false
	if str(value.get("j14_player_explanation", "")) not in ["", "TRUTH_LIMITED", "MINIMIZE_OR_LIE", "PROTECT_AND_DEFER", "PROTECT_AND_ANSWER_NOW"]: return false
	if typeof(value.get("j14_witness_presence_evidence", {})) != TYPE_DICTIONARY: return false
	if typeof(value.get("j14_visible_fields", [])) != TYPE_ARRAY: return false
	if typeof(value.get("j14_visible_values", {})) != TYPE_DICTIONARY: return false
	if str(value.get("j14_discovery_mode", "")) not in ["", "LOCK_SCREEN_PREVIEW", "OPEN_CONVERSATION", "OPEN_GALLERY_OR_SELECTION", "TEXT_NOTIFICATION", "COMPOSITE_PUBLIC_PLUS_PRIVATE_NOTIFICATION", "PUBLIC_ONLY"]: return false
	if str(value.get("j14_player_initial_reaction", "")) not in ["", "SCREEN_CLOSED", "TRACE_LEFT_VISIBLE", "PREVIEW_DISMISSED", "PUBLIC_CONTENT_LEFT_OPEN"]: return false
	if str(value.get("j15_mode", "UNESTABLISHED")) not in ["UNESTABLISHED", "ACTIVE_CLARIFICATION", "REPAIR", "OPEN_CLARIFICATION", "NO_OBLIGATION"]: return false
	if str(value.get("j16_priority", "UNESTABLISHED")) not in ["UNESTABLISHED", "MARIE", "MATHILDE", "FALLBACK"]: return false
	if str(value.get("j18_sandra_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "PRIVILEGED_CONFIDENCE", "FRIENDSHIP_RESTORED", "PROTECTIVE_DISTANCE", "TRUST_BROKEN"]: return false
	if str(value.get("j19_pivot", "")) not in ["", "PAULINE", "RAPHAELLE", "FALLBACK"]: return false
	if str(value.get("j19_pauline_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "SURFACE_RESTORED", "COMPARTMENT_PROTECTED", "COMPARTMENT_CLOSED"]: return false
	if str(value.get("j19_raphaelle_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "CREATIVE_CONFIDENCE", "FUTURE_INVITATION", "BOUNDARY_REINFORCED", "COLLEAGUE_ONLY"]: return false
	if str(value.get("j20_context", "UNESTABLISHED")) not in ["UNESTABLISHED", "ALIBI", "CONFIDENCE", "ORDINARY"]: return false
	if str(value.get("j20_nico_position", "UNESTABLISHED")) not in ["UNESTABLISHED", "ORDINARY_FRIEND", "GUARDRAIL", "LIMITED_CONFIDANT", "DISTANCE"]: return false
	if str(value.get("j20_meeting_outcome", "UNESTABLISHED")) not in ["UNESTABLISHED", "ACTIVE", "PAID", "REFUSED", "NOT_OFFERED"]: return false
	if typeof(value.get("final_trace_audience", [])) != TYPE_ARRAY: return false
	if str(value.get("existing_contradiction_id", "")) not in ["", "COUPLE_FALSE_HOUR", "COUPLE_FALSE_PLACE", "COUPLE_DOUBLE_LIFE", "SANDRA_COPY_RETAINED_SECRETLY", "PAULINE_COMPARTMENT", "PAULINE_RECIPROCAL_TRACE", "RAPHAELLE_CLEAR_SECRET", "NICO_SHARED_ALIBI", "NICO_ACCOMPLICE_DEBT"]: return false
	if typeof(value.get("final_posture_options", [])) != TYPE_ARRAY: return false
	if str(value.get("final_posture", "UNESTABLISHED")) not in ["UNESTABLISHED", "RULE_ACTED", "LOSS_ACKNOWLEDGED", "EXISTING_CONTRADICTION_MAINTAINED"]: return false
	if typeof(value.get("resolved_visual_variant_by_asset", {})) != TYPE_DICTIONARY: return false
	for key in ["promises", "traces", "knowledge"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY:
			return false
	if typeof(value.get("obligations")) != TYPE_DICTIONARY:
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
	if not _j09_records_consistent(value):
		return false
	if not _j10_records_consistent(value):
		return false
	if not _j11_records_consistent(value):
		return false
	if not _j12_records_consistent(value):
		return false
	if not _j13_records_consistent(value):
		return false
	if not _j14_records_consistent(value):
		return false
	if not _j15_records_consistent(value):
		return false
	if not _j16_records_consistent(value):
		return false
	if not _j17_records_consistent(value): return false
	if not _j18_records_consistent(value): return false
	if not _j19_records_consistent(value): return false
	if not _j20_records_consistent(value): return false
	if not _j21_records_consistent(value): return false
	current_day = str(value["current_day"])
	day_status = str(value["day_status"])
	couple_state = str(value["couple_state"])
	sandra_state = str(value["sandra_state"])
	promises = value["promises"].duplicate(true)
	obligations = value.get("obligations", {}).duplicate(true)
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
	marie_j09_presence_choice = str(value.get("marie_j09_presence_choice", "UNESTABLISHED"))
	marie_j09_presence_outcome = str(value.get("marie_j09_presence_outcome", "UNESTABLISHED"))
	marie_j09_dinner_outcome = str(value.get("marie_j09_dinner_outcome", "UNESTABLISHED"))
	j10_pivot = str(value.get("j10_pivot", ""))
	j10_pivot_reason = str(value.get("j10_pivot_reason", ""))
	j10_pivot_outcome = str(value.get("j10_pivot_outcome", ""))
	marie_j10_dinner_resolution = str(value.get("marie_j10_dinner_resolution", "UNESTABLISHED"))
	nico_j10_morning_confirmation = str(value.get("nico_j10_morning_confirmation", "UNESTABLISHED"))
	j11_pivot = str(value.get("j11_pivot", ""))
	j11_pivot_reason = str(value.get("j11_pivot_reason", ""))
	j11_pivot_outcome = str(value.get("j11_pivot_outcome", ""))
	j11_physical_level = str(value.get("j11_physical_level", "NONE"))
	mathilde_j11_state = str(value.get("mathilde_j11_state", "UNESTABLISHED"))
	mathilde_has_independent_sleep_option = bool(value.get("mathilde_has_independent_sleep_option", false))
	mathilde_can_leave_safely = bool(value.get("mathilde_can_leave_safely", false))
	marie_absence_not_engineered = bool(value.get("marie_absence_not_engineered", false))
	j12_presence_choice = str(value.get("j12_presence_choice", "UNESTABLISHED"))
	j12_private_outcome = str(value.get("j12_private_outcome", "UNESTABLISHED"))
	j12_annexe_choice = str(value.get("j12_annexe_choice", "UNESTABLISHED"))
	j12_priority_route = str(value.get("j12_priority_route", "UNESTABLISHED"))
	j12_failed_aftercare_processed = bool(value.get("j12_failed_aftercare_processed", false))
	j13_pivot = str(value.get("j13_pivot", ""))
	j13_outcome = str(value.get("j13_outcome", "UNESTABLISHED"))
	j13_j14_trace_id = str(value.get("j13_j14_trace_id", ""))
	j14_variant = str(value.get("j14_variant", ""))
	j14_outcome = str(value.get("j14_outcome", "UNESTABLISHED"))
	j14_witness = str(value.get("j14_witness", ""))
	j14_witness_presence_evidence = value.get("j14_witness_presence_evidence", {}).duplicate(true)
	j14_discovery_mode = str(value.get("j14_discovery_mode", ""))
	j14_visible_fields = value.get("j14_visible_fields", []).duplicate()
	j14_visible_values = value.get("j14_visible_values", {}).duplicate(true)
	j14_source_trace_id = str(value.get("j14_source_trace_id", ""))
	j14_secondary_trace_id = str(value.get("j14_secondary_trace_id", ""))
	j14_player_initial_reaction = str(value.get("j14_player_initial_reaction", ""))
	j14_player_explanation = str(value.get("j14_player_explanation", ""))
	j14_j15_obligation_id = str(value.get("j14_j15_obligation_id", ""))
	j14_controller_notified = bool(value.get("j14_controller_notified", false))
	j15_mode = str(value.get("j15_mode", "UNESTABLISHED"))
	j15_outcome = str(value.get("j15_outcome", "UNESTABLISHED"))
	j15_urgent_consequence_remaining = bool(value.get("j15_urgent_consequence_remaining", false))
	j16_priority = str(value.get("j16_priority", "UNESTABLISHED"))
	j16_consequence_outcome = str(value.get("j16_consequence_outcome", "UNESTABLISHED"))
	j16_departure_state = str(value.get("j16_departure_state", "UNESTABLISHED"))
	j16_j17_outcome = str(value.get("j16_j17_outcome", "UNESTABLISHED"))
	j17_departure_outcome = str(value.get("j17_departure_outcome", "UNESTABLISHED"))
	j17_couple_outcome = str(value.get("j17_couple_outcome", "UNESTABLISHED"))
	j18_sandra_outcome = str(value.get("j18_sandra_outcome", "UNESTABLISHED"))
	j19_pivot = str(value.get("j19_pivot", ""))
	j19_pauline_outcome = str(value.get("j19_pauline_outcome", "UNESTABLISHED"))
	j19_raphaelle_outcome = str(value.get("j19_raphaelle_outcome", "UNESTABLISHED"))
	j19_raphaelle_invitation_pending = bool(value.get("j19_raphaelle_invitation_pending", false))
	j20_context = str(value.get("j20_context", "UNESTABLISHED"))
	j20_nico_position = str(value.get("j20_nico_position", "UNESTABLISHED"))
	j20_meeting_outcome = str(value.get("j20_meeting_outcome", "UNESTABLISHED"))
	final_trace_id = str(value.get("final_trace_id", ""))
	final_trace_state = str(value.get("final_trace_state", ""))
	final_trace_controller = str(value.get("final_trace_controller", ""))
	final_trace_audience.assign(value.get("final_trace_audience", []))
	existing_contradiction_id = str(value.get("existing_contradiction_id", ""))
	final_posture_options.assign(value.get("final_posture_options", []))
	final_posture = str(value.get("final_posture", "UNESTABLISHED"))
	j21_morning_outcome = str(value.get("j21_morning_outcome", "UNESTABLISHED"))
	resolved_visual_variant_by_asset = value.get("resolved_visual_variant_by_asset", {}).duplicate(true)
	return true

func _snapshot_ledgers_have_dictionary_records(value: Dictionary) -> bool:
	for ledger_key in ["promises", "obligations", "traces", "knowledge"]:
		if not value.has(ledger_key): continue
		if typeof(value[ledger_key]) != TYPE_DICTIONARY: return false
		for record in value[ledger_key].values():
			if typeof(record) != TYPE_DICTIONARY: return false
	return true

func _expected_j12_f20(value: Dictionary) -> Dictionary:
	var choices: Array = value.get("selected_choice_ids", [])
	var observed_value := ""; var knowers: Array = []; var source_event_id := ""
	if choices.has("choice_j12_sandra_exit"):
		observed_value = "PLAYER_LEFT_ROOM_AT_LAVERRIERE_PUBLICATION"; knowers = ["Marie"]; source_event_id = "choice_j12_sandra_exit"
	elif str(value.get("j11_pivot_outcome", "")) == "NICO_RIVALRY_MAINTAINED" and str(value.get("j12_private_outcome", "")).begins_with("NICO_"):
		for choice_id in ["choice_j12_nico_rivalry_leave", "choice_j12_nico_rivalry_joke", "choice_j12_nico_rivalry_exit"]:
			if choices.has(choice_id):
				if source_event_id != "": return {"invalid":true}
				observed_value = "PLAYER_WATCHED_NICO_TALK_TO_MARIE"; knowers = ["Nico"]; source_event_id = choice_id
	if observed_value == "": return {}
	return {"fact_id":"fact_j12_unusual_behavior_observed","source_type":"DIRECT_OBSERVATION","source_ref":observed_value,"source_event_id":source_event_id,"value":observed_value,"initial_knowers":knowers.duplicate(),"current_knowers":knowers.duplicate(),"certainty":"OBSERVED","meaning_certainty":"INFERRED","shareability":"FACTUAL_ONLY","source_day":"J12"}

func _j12_priority_contract(route: String, restored_obligations: Dictionary) -> Dictionary:
	if route not in ["SANDRA", "MATHILDE", "RAPHAELLE", "NICO", "MARIE", "NETWORK"]: return {}
	var counterparty := str({"SANDRA":"Sandra", "MATHILDE":"Mathilde", "RAPHAELLE":"Raphaëlle", "NICO":"Nico", "MARIE":"Marie", "NETWORK":"Marie"}[route])
	var origin := "MATHILDE_HOUSEHOLD_AFTERCARE" if route == "MATHILDE" and str(restored_obligations.get("aftercare_mathilde_j11", {}).get("status", "")) == "FAILED" else "%s_J11_CONSEQUENCE" % route
	var failure_effect := str({"SANDRA":"la confiance d’audience reste à réparer", "MATHILDE":"la règle du foyer reste prioritaire et la confiance demeure rompue", "RAPHAELLE":"l’accès privé reste refroidi ou fermé", "NICO":"le garde-fou ou la rivalité reste à clarifier sans utiliser Marie", "MARIE":"la conversation privée du couple reste due", "NETWORK":"l’image publique ne remplace pas la réponse vécue"}[route])
	return {"obligation_id":"j12_priority_consequence_j13","obligation_type":"PRIORITY_CONSEQUENCE","created_at":"J12 00:28","concerned_people":["Player", counterparty],"due_before":"toute nouvelle opportunité J13","due_at":"J13 avant toute nouvelle opportunité","failure_effect":failure_effect,"origin":origin,"route":route}

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
	if str(value.get("current_day", "")) in ["J08", "J09", "J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"]:
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
	if current not in ["J08", "J09", "J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"]:
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
			if current == "J08":
				if str(p05.get("status", "")) != "AMENDED" or str(p05.get("due_at", "")) != "J09 09:00":
					return false
			elif str(p05.get("status", "")) != "PAID" or str(p05.get("paid_or_closed_at", "")) != "J09 09:00" or str(p05.get("paid_or_closed_by", "")) != "Player":
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

func _j09_records_consistent(value: Dictionary) -> bool:
	var current := str(value.get("current_day", ""))
	var presence_choice := str(value.get("marie_j09_presence_choice", "UNESTABLISHED"))
	var presence_outcome := str(value.get("marie_j09_presence_outcome", "UNESTABLISHED"))
	var dinner_outcome := str(value.get("marie_j09_dinner_outcome", "UNESTABLISHED"))
	var restored_traces: Dictionary = value.get("traces", {})
	var restored_knowledge: Dictionary = value.get("knowledge", {})
	var restored_promises: Dictionary = value.get("promises", {})
	var has_private := restored_traces.has("j09_marie_black_dress_private_01")
	var has_public := restored_traces.has("j09_marie_laverriere_public_01")
	var has_after := restored_traces.has("j09_marie_laverriere_after_01")
	var has_f11 := restored_knowledge.has("fact_player_received_marie_black_dress_image")
	var has_f12 := restored_knowledge.has("fact_marie_public_professional_version_visible")
	var has_f13 := restored_knowledge.has("fact_marie_recontextualized_evening_for_player")
	if current not in ["J09", "J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"]:
		return presence_choice == "UNESTABLISHED" and presence_outcome == "UNESTABLISHED" and dinner_outcome == "UNESTABLISHED" and not has_private and not has_public and not has_after and not has_f11 and not has_f12 and not has_f13
	if has_private != has_f11 or has_public != has_f12 or has_after != has_f13:
		return false
	if has_f13:
		var f13: Dictionary = restored_knowledge["fact_marie_recontextualized_evening_for_player"]
		if str(f13.get("source_ref", "")) != "j09_marie_laverriere_after_01" or str(f13.get("source_type", "")) != "PRIVATE_TRACE" or f13.get("initial_knowers", []) != ["Marie", "Player"]:
			return false
	if has_after and not has_public:
		return false
	if presence_choice == "UNESTABLISHED":
		return presence_outcome == "UNESTABLISHED" and dinner_outcome == "UNESTABLISHED" and not has_private and not has_public and not has_after
	if presence_choice == "ABSENCE_HONEST" and presence_outcome != "absence_honest":
		return false
	if presence_choice == "EARLY" and presence_outcome not in ["UNESTABLISHED", "presence_active", "presence_playful_useful", "presence_distracted"]:
		return false
	if presence_choice == "LATE" and presence_outcome not in ["UNESTABLISHED", "presence_late_active", "presence_spectator", "presence_bounded_reliable"]:
		return false
	if presence_outcome == "presence_distracted" and str(value.get("couple_state", "")) != "STRAIN_VISIBLE":
		return false
	var has_j10 := restored_promises.has("marie_j09_dinner_j10_2030")
	var has_friday := restored_promises.has("marie_j09_dinner_friday_2030")
	match dinner_outcome:
		"UNESTABLISHED":
			if has_j10 or has_friday:
				return false
		"J10_ACCEPTED":
			if not has_j10:
				return false
			var p09: Dictionary = restored_promises["marie_j09_dinner_j10_2030"]
			if str(p09.get("due_at", "")) != "J10 20:30" or not bool(p09.get("accepted_by_player", false)):
				return false
			if current == "J09":
				if str(p09.get("status", "")) != "ACTIVE" or has_friday:
					return false
			else:
				if str(p09.get("status", "")) not in ["ACTIVE", "AMENDED", "PAID", "FAILED", "CANCELLED"]:
					return false
				if (str(p09.get("status", "")) == "AMENDED") != has_friday:
					return false
				if has_friday:
					var amended_p10: Dictionary = restored_promises["marie_j09_dinner_friday_2030"]
					var amended_statuses := ["ACTIVE"] if current != "J11" else ["ACTIVE", "CANCELLED", "PAID", "FAILED"]
					if str(amended_p10.get("status", "")) not in amended_statuses or str(amended_p10.get("due_at", "")) != "J11 20:30" or str(amended_p10.get("amends", "")) != "marie_j09_dinner_j10_2030":
						return false
		"FRIDAY_ACCEPTED":
			if has_j10 or not has_friday:
				return false
			var p10: Dictionary = restored_promises["marie_j09_dinner_friday_2030"]
			var p10_statuses := ["ACTIVE"] if current != "J11" else ["ACTIVE", "CANCELLED", "PAID", "FAILED"]
			if str(p10.get("status", "")) not in p10_statuses or str(p10.get("due_at", "")) != "J11 20:30" or not bool(p10.get("accepted_by_player", false)):
				return false
		"REFUSED":
			if not has_j10 or has_friday:
				return false
			var refused: Dictionary = restored_promises["marie_j09_dinner_j10_2030"]
			if str(refused.get("status", "")) != "REFUSED" or bool(refused.get("accepted_by_player", false)) or str(refused.get("due_at", "")) != "":
				return false
		"NOT_OFFERED":
			if has_j10 or has_friday or presence_outcome not in ["presence_distracted", "presence_spectator"]:
				return false
	if str(value.get("day_status", "")) == "COMPLETE":
		if not has_private or not has_public or not has_after or dinner_outcome == "UNESTABLISHED":
			return false
	return true

func _j10_records_consistent(value: Dictionary) -> bool:
	var current := str(value.get("current_day", ""))
	var pivot := str(value.get("j10_pivot", ""))
	var reason := str(value.get("j10_pivot_reason", ""))
	var outcome := str(value.get("j10_pivot_outcome", ""))
	var dinner := str(value.get("marie_j10_dinner_resolution", "UNESTABLISHED"))
	var confirmation := str(value.get("nico_j10_morning_confirmation", "UNESTABLISHED"))
	var restored_traces: Dictionary = value.get("traces", {})
	var restored_knowledge: Dictionary = value.get("knowledge", {})
	var restored_promises: Dictionary = value.get("promises", {})
	var has_t10 := restored_traces.has("j10_mathilde_outfit_choice_01")
	var has_mathilde_fact := restored_knowledge.has("fact_mathilde_chose_player_as_outfit_audience")
	if current not in ["J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"]:
		return pivot == "" and reason == "" and outcome == "" and dinner == "UNESTABLISHED" and confirmation == "UNESTABLISHED" and not has_t10 and not has_mathilde_fact
	if (pivot == "") != (reason == ""):
		return false
	match reason:
		"":
			if pivot != "":
				return false
		"DUE_PROMISE_P07":
			if pivot != "NICO":
				return false
		"MARIE_CONSEQUENCE_PRIORITY", "NO_ELIGIBLE_PIVOT", "ALL_ACCESS_CLOSED":
			if pivot != "NONE":
				return false
		"LEAST_RECENT_FOREGROUND", "AUTHORED_ORDER":
			if pivot not in ["SANDRA", "MATHILDE", "RAPHAELLE", "NICO"]:
				return false
	if has_t10 != has_mathilde_fact:
		return false
	if has_t10:
		if pivot != "MATHILDE":
			return false
		var t10: Dictionary = restored_traces["j10_mathilde_outfit_choice_01"]
		var mathilde_fact: Dictionary = restored_knowledge["fact_mathilde_chose_player_as_outfit_audience"]
		if str(t10.get("source_day", "")) != "J10" or str(t10.get("knowledge_created", "")) != "fact_mathilde_chose_player_as_outfit_audience":
			return false
		if t10.get("current_audience", []) != ["Mathilde", "Player"] or str(t10.get("current_state", "")) != "PRIVATE_ACTIVE":
			return false
		if str(mathilde_fact.get("source_ref", "")) != "j10_mathilde_outfit_choice_01" or str(mathilde_fact.get("source_type", "")) != "PRIVATE_TRACE":
			return false
		if mathilde_fact.get("initial_knowers", []) != ["Mathilde", "Player"] or str(mathilde_fact.get("source_day", "")) != "J10":
			return false
	var allowed_outcomes := {
		"SANDRA": ["CAFE_HELD_CALM_PRESENCE", "CAFE_HELD_MISSING_NAMED", "CAFE_HELD_FRIENDSHIP_BOUNDED", "CAFE_SATURDAY_CONDITIONAL", "CAFE_OPPORTUNITY_CLOSED"],
		"MATHILDE": ["OUTFIT_PRECISE_NON_APPROPRIATIVE", "OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED", "OUTFIT_PRACTICAL_WEATHER"],
		"RAPHAELLE": ["PROCESS_HELPED_VISIT_BOUNDED", "PROCESS_HELPED_REMOTE", "RESULT_ONLY", "PROFESSIONAL_BOUNDARY"],
		"NICO": ["DIFFERENCE_ACKNOWLEDGED_NO_IMAGE", "NICO_OBSERVATION_REQUESTED", "COMPARISON_CLOSED", "THURSDAY_MEETING_CANCELLED"],
		"NONE": ["DUE_DINNER_PAID", "DUE_DINNER_FAILED_LATE", "DUE_DINNER_CANCELLED", "ORDINARY_MEAL_JOINED", "LATE_RETURN_SEPARATE", "ABSENCE_ANNOUNCED"],
	}
	if outcome != "" and (not allowed_outcomes.has(pivot) or outcome not in allowed_outcomes[pivot]):
		return false
	var p09: Dictionary = restored_promises.get("marie_j09_dinner_j10_2030", {})
	var p10: Dictionary = restored_promises.get("marie_j09_dinner_friday_2030", {})
	if str(p09.get("status", "")) == "ACTIVE" and str(p10.get("status", "")) == "ACTIVE":
		return false
	match dinner:
		"UNESTABLISHED":
			if not p09.is_empty() and str(p09.get("status", "")) == "ACTIVE":
				return false
		"THURSDAY_DUE":
			if str(p09.get("status", "")) != "ACTIVE" or str(p09.get("due_at", "")) != "J10 20:30" or not p10.is_empty():
				return false
		"THURSDAY_PAID":
			if str(p09.get("status", "")) != "PAID":
				return false
		"THURSDAY_AMENDED_TO_FRIDAY":
			var amended_p10_statuses := ["ACTIVE"] if current == "J10" else ["ACTIVE", "CANCELLED", "PAID", "FAILED"]
			if str(p09.get("status", "")) != "AMENDED" or str(p10.get("status", "")) not in amended_p10_statuses or str(p10.get("amends", "")) != "marie_j09_dinner_j10_2030":
				return false
		"THURSDAY_FAILED_LATE":
			if str(p09.get("status", "")) != "FAILED":
				return false
		"THURSDAY_CANCELLED":
			if str(p09.get("status", "")) != "CANCELLED":
				return false
		"FRIDAY_RECONFIRMED":
			var allowed_p10_statuses := ["ACTIVE"] if current == "J10" else ["ACTIVE", "CANCELLED", "PAID", "FAILED"]
			if not p09.is_empty() or str(p10.get("status", "")) not in allowed_p10_statuses or str(p10.get("due_at", "")) != "J11 20:30":
				return false
		"NOT_DUE":
			if str(p09.get("status", "")) == "ACTIVE" or str(p10.get("status", "")) == "ACTIVE":
				return false
	var p07: Dictionary = restored_promises.get("nico_j07_thursday_conditional", {})
	if p07.is_empty():
		if confirmation != "NOT_DUE":
			return false
	else:
		match str(p07.get("status", "")):
			"CONDITIONAL":
				if confirmation != "UNESTABLISHED":
					return false
			"ACTIVE", "PAID", "CANCELLED":
				if confirmation != "CONFIRMED_ACTIVE":
					return false
			"REFUSED":
				if confirmation != "REFUSED":
					return false
			"EXPIRED":
				if confirmation != "EXPIRED":
					return false
			_:
				if confirmation != "NOT_DUE":
					return false
	if current == "J11" or str(value.get("day_status", "")) == "COMPLETE":
		if pivot == "" or reason == "" or outcome == "" or dinner in ["UNESTABLISHED", "THURSDAY_DUE"] or confirmation == "UNESTABLISHED":
			return false
		var expected_conversation: String = str({
			"SANDRA": "chapter_10_sandra_cafe",
			"MATHILDE": "chapter_10_mathilde_outfit",
			"RAPHAELLE": "chapter_10_raphaelle_process",
			"NICO": "chapter_10_nico_observation",
			"NONE": "chapter_10_marie_obligations",
		}.get(pivot, ""))
		if expected_conversation not in value.get("completed_conversation_ids", []):
			return false
	return true

func _j11_records_consistent(value: Dictionary) -> bool:
	var current := str(value.get("current_day", ""))
	var pivot := str(value.get("j11_pivot", ""))
	var reason := str(value.get("j11_pivot_reason", ""))
	var outcome := str(value.get("j11_pivot_outcome", ""))
	var physical_level := str(value.get("j11_physical_level", "NONE"))
	var mathilde_state_value := str(value.get("mathilde_j11_state", "UNESTABLISHED"))
	var restored_traces: Dictionary = value.get("traces", {})
	var restored_knowledge: Dictionary = value.get("knowledge", {})
	var restored_obligations: Dictionary = value.get("obligations", {})
	var restored_promises: Dictionary = value.get("promises", {})
	var restored_choices: Array = value.get("selected_choice_ids", [])
	var has_sandra_trace := restored_traces.has("j11_sandra_chosen_image_01")
	var has_sandra_fact := restored_knowledge.has("fact_sandra_chose_private_image_for_player")
	var has_raphaelle_trace := restored_traces.has("j11_raphaelle_chosen_result_01")
	var has_raphaelle_fact := restored_knowledge.has("fact_raphaelle_chose_player_for_result_image")
	var has_mathilde_trace := restored_traces.has("j11_mathilde_physical_aftercare_01")
	var has_mathilde_fact := restored_knowledge.has("fact_mathilde_physical_event_occurred")
	if current not in ["J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"]:
		return (
			pivot == "" and reason == "" and outcome == "" and physical_level == "NONE"
			and mathilde_state_value == "UNESTABLISHED"
			and not bool(value.get("mathilde_has_independent_sleep_option", false))
			and not bool(value.get("mathilde_can_leave_safely", false))
			and not bool(value.get("marie_absence_not_engineered", false))
			and restored_obligations.is_empty()
			and not has_sandra_trace and not has_sandra_fact
			and not has_raphaelle_trace and not has_raphaelle_fact
			and not has_mathilde_trace and not has_mathilde_fact
		)
	if (pivot == "") != (reason == ""):
		return false
	if pivot != "" and not _j11_selection_matches_j10(pivot, reason, str(value.get("j10_pivot", "")), str(value.get("j10_pivot_outcome", ""))):
		return false
	var semantic_outcomes := {
		"SANDRA": ["", "SANDRA_RULE_CLARIFIED", "SANDRA_DESIRE_BOUNDED", "SANDRA_IMAGE_REMOVED"],
		"MARIE": ["", "MARIE_ADULT_RECONQUEST", "MARIE_NON_ADULT_RECONNECTION", "MARIE_SEX_NOT_USED_AS_BANDAGE", "MARIE_HONEST_REFUSAL", "MARIE_NO_RECONQUEST"],
		"MATHILDE": ["", "MATHILDE_LOOK_ONLY", "MATHILDE_M_B1", "MATHILDE_M_B2", "MATHILDE_M_B3", "MATHILDE_CLEAN_STOP", "MATHILDE_DISTANCE_RESTORED"],
		"RAPHAELLE": ["", "FIRST_KISS", "KISS_DECLINED", "RESULT_SENT_ATTRACTION_NAMED", "RESULT_SENT_BOUNDARY_HELD"],
		"NICO": ["", "NICO_GUARDRAIL_HELD", "NICO_RIVALRY_MAINTAINED", "NICO_CLEAN_CLOSE"],
		"RESPIRATION": [""], "": [""],
	}
	if outcome not in semantic_outcomes.get(pivot, []):
		return false
	if str(value.get("day_status", "")) == "COMPLETE" and pivot != "RESPIRATION" and outcome == "":
		return false
	var has_j11_obligation := restored_obligations.has("aftercare_mathilde_j11") or restored_obligations.has("aftercare_marie_j11")
	if pivot == "RESPIRATION" and (outcome != "" or physical_level != "NONE" or has_j11_obligation or has_sandra_trace or has_raphaelle_trace or has_mathilde_trace):
		return false
	if has_sandra_trace != has_sandra_fact or has_raphaelle_trace != has_raphaelle_fact or has_mathilde_trace != has_mathilde_fact:
		return false
	if has_sandra_trace:
		if pivot != "SANDRA": return false
		var sandra_trace: Dictionary = restored_traces["j11_sandra_chosen_image_01"]
		var sandra_fact: Dictionary = restored_knowledge["fact_sandra_chose_private_image_for_player"]
		if str(sandra_trace.get("knowledge_created", "")) != "fact_sandra_chose_private_image_for_player" or str(sandra_fact.get("source_ref", "")) != "j11_sandra_chosen_image_01": return false
		if str(sandra_trace.get("current_state", "")) not in ["PRIVATE_ACTIVE", "REMOVED"] or str(sandra_fact.get("access_mode", "")) not in ["view_only", "in_thread_allowed", "removed"]: return false
		var sandra_removed := str(sandra_trace.get("current_state", "")) == "REMOVED" and str(sandra_fact.get("access_mode", "")) == "removed"
		var removed_by_j13 := current in ["J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"] and (restored_choices.has("choice_j13_sandra_clear_more") or restored_choices.has("choice_j13_sandra_delayed_more") or restored_choices.has("choice_j13_sandra_exit_more"))
		if sandra_removed != (outcome == "SANDRA_IMAGE_REMOVED" or removed_by_j13): return false
		if not sandra_removed and outcome not in ["", "SANDRA_RULE_CLARIFIED", "SANDRA_DESIRE_BOUNDED"]: return false
		var expected_sandra_choice := str({"SANDRA_RULE_CLARIFIED":"choice_j11_sandra_rule","SANDRA_DESIRE_BOUNDED":"choice_j11_sandra_desire","SANDRA_IMAGE_REMOVED":"choice_j11_sandra_more"}.get(outcome, ""))
		if expected_sandra_choice != "" and not restored_choices.has(expected_sandra_choice): return false
	if has_raphaelle_trace:
		if pivot != "RAPHAELLE": return false
		var raphaelle_trace: Dictionary = restored_traces["j11_raphaelle_chosen_result_01"]
		var raphaelle_fact: Dictionary = restored_knowledge["fact_raphaelle_chose_player_for_result_image"]
		if str(raphaelle_trace.get("creator", "")) != "Maud" or str(raphaelle_trace.get("selected_by", "")) != "Raphaëlle" or str(raphaelle_trace.get("controller", "")) != "Raphaëlle": return false
		if str(raphaelle_fact.get("source_ref", "")) != "j11_raphaelle_chosen_result_01": return false
		if str(raphaelle_trace.get("current_state", "")) not in ["PRIVATE_ACTIVE", "REMOVED"]: return false
		var direct_boundary: bool = value.get("selected_choice_ids", []).has("choice_j11_raphaelle_boundary")
		if (str(raphaelle_trace.get("current_state", "")) == "REMOVED") != direct_boundary: return false
		match outcome:
			"FIRST_KISS":
				if not restored_choices.has("choice_j11_raphaelle_meeting_accept"): return false
			"KISS_DECLINED":
				if not restored_choices.has("choice_j11_raphaelle_meeting_decline"): return false
			"RESULT_SENT_ATTRACTION_NAMED":
				if not restored_choices.has("choice_j11_raphaelle_attractive") and not restored_choices.has("choice_j11_raphaelle_attraction_yes"): return false
			"RESULT_SENT_BOUNDARY_HELD":
				if not restored_choices.has("choice_j11_raphaelle_boundary") and not restored_choices.has("choice_j11_raphaelle_attraction_no"): return false
	if has_mathilde_trace:
		if pivot != "MATHILDE" or mathilde_state_value != "PHYSICAL_SECRET" or physical_level not in ["MATHILDE_M_B2", "MATHILDE_M_B3"]: return false
		if not bool(value.get("mathilde_has_independent_sleep_option", false)) or not bool(value.get("mathilde_can_leave_safely", false)) or not bool(value.get("marie_absence_not_engineered", false)): return false
		var mathilde_trace: Dictionary = restored_traces["j11_mathilde_physical_aftercare_01"]
		var mathilde_fact: Dictionary = restored_knowledge["fact_mathilde_physical_event_occurred"]
		if str(mathilde_trace.get("trace_type", "")) != "TEXT_MESSAGE" or str(mathilde_fact.get("source_ref", "")) != "j11_mathilde_physical_aftercare_01": return false
		if str(mathilde_fact.get("physical_level", "")) != physical_level or not restored_obligations.has("aftercare_mathilde_j11"): return false
	if mathilde_state_value == "PROXIMITY_CONSENTED" and physical_level != "PROXIMITY_ONLY": return false
	if mathilde_state_value == "DISTANCE" and physical_level != "NONE": return false
	if physical_level in ["MATHILDE_M_B2", "MATHILDE_M_B3"] and not has_mathilde_trace: return false
	match outcome:
		"MATHILDE_LOOK_ONLY":
			if mathilde_state_value != "UNESTABLISHED" or physical_level != "NONE" or has_mathilde_trace: return false
		"MATHILDE_M_B1", "MATHILDE_CLEAN_STOP":
			if mathilde_state_value != "PROXIMITY_CONSENTED" or physical_level != "PROXIMITY_ONLY" or has_mathilde_trace: return false
		"MATHILDE_M_B2", "MATHILDE_M_B3":
			if mathilde_state_value != "PHYSICAL_SECRET" or physical_level != outcome or not has_mathilde_trace: return false
		"MATHILDE_DISTANCE_RESTORED":
			if mathilde_state_value != "DISTANCE" or physical_level != "NONE" or has_mathilde_trace: return false
	if physical_level == "MARIE_ADULT_RECONQUEST" and (pivot != "MARIE" or not restored_obligations.has("aftercare_marie_j11")): return false
	if restored_obligations.has("aftercare_marie_j11") and (pivot != "MARIE" or physical_level != "MARIE_ADULT_RECONQUEST"): return false
	if outcome == "MARIE_ADULT_RECONQUEST" and physical_level != "MARIE_ADULT_RECONQUEST": return false
	if outcome in ["MARIE_NON_ADULT_RECONNECTION", "MARIE_SEX_NOT_USED_AS_BANDAGE", "MARIE_HONEST_REFUSAL", "MARIE_NO_RECONQUEST"] and (physical_level != "NONE" or restored_obligations.has("aftercare_marie_j11")): return false
	if physical_level == "RAPHAELLE_FIRST_KISS" and (pivot != "RAPHAELLE" or outcome != "FIRST_KISS"): return false
	var p10: Dictionary = restored_promises.get("marie_j09_dinner_friday_2030", {})
	match str(p10.get("j11_resolution", "")):
		"":
			pass
		"MAINTAINED":
			if str(p10.get("status", "")) not in ["ACTIVE", "PAID"]: return false
		"CANCELLED":
			if str(p10.get("status", "")) != "CANCELLED": return false
		"LATE_INCOMPATIBLE":
			if str(p10.get("status", "")) not in ["ACTIVE", "FAILED"]: return false
		_:
			return false
	var p11: Dictionary = restored_promises.get("sandra_cafe_saturday_1100", {})
	var p11_confirmed_at := str(p11.get("counterparty_confirmed_at", ""))
	var p11_confirmed_by := str(p11.get("counterparty_confirmed_by", ""))
	if (p11_confirmed_at == "") != (p11_confirmed_by == ""): return false
	if p11_confirmed_at != "" and (p11_confirmed_at != "J11 17:44" or p11_confirmed_by != "Sandra"): return false
	if current == "J11" and p11_confirmed_at != "" and str(p11.get("status", "")) != "CONDITIONAL": return false
	if current == "J12" and p11_confirmed_at != "" and str(p11.get("status", "")) not in ["CONDITIONAL", "ACTIVE", "PAID", "REFUSED", "EXPIRED"]: return false
	for obligation_id in restored_obligations:
		var obligation: Dictionary = restored_obligations[obligation_id]
		if current in ["J12", "J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"] and obligation_id == "j12_priority_consequence_j13":
			continue
		if obligation_id not in ["aftercare_mathilde_j11", "aftercare_marie_j11"]: return false
		if str(obligation.get("obligation_id", "")) != obligation_id or str(obligation.get("obligation_type", "")) != "AFTERCARE": return false
		if str(obligation.get("status", "")) not in ["DUE", "PAID", "REFUSED", "FAILED", "CLOSED"]: return false
		for required_key in ["created_at", "concerned_people", "due_before", "paid_by", "failure_effect"]:
			if not obligation.has(required_key): return false
	if outcome in ["FIRST_KISS", "KISS_DECLINED", "RESULT_SENT_ATTRACTION_NAMED", "RESULT_SENT_BOUNDARY_HELD"]:
		if pivot != "RAPHAELLE" or not has_raphaelle_trace: return false
	if outcome == "FIRST_KISS" and physical_level != "RAPHAELLE_FIRST_KISS": return false
	var expected_nico_choice := str({"NICO_GUARDRAIL_HELD":"choice_j11_nico_guardrail","NICO_RIVALRY_MAINTAINED":"choice_j11_nico_rivalry","NICO_CLEAN_CLOSE":"choice_j11_nico_close"}.get(outcome, ""))
	if expected_nico_choice != "" and (pivot != "NICO" or not restored_choices.has(expected_nico_choice)): return false
	return true

func _j12_records_consistent(value: Dictionary) -> bool:
	var day := str(value.get("current_day", ""))
	var presence := str(value.get("j12_presence_choice", "UNESTABLISHED"))
	var private_outcome := str(value.get("j12_private_outcome", "UNESTABLISHED"))
	var annexe := str(value.get("j12_annexe_choice", "UNESTABLISHED"))
	var priority := str(value.get("j12_priority_route", "UNESTABLISHED"))
	var processed := bool(value.get("j12_failed_aftercare_processed", false))
	var restored_promises: Dictionary = value.get("promises", {})
	var restored_obligations: Dictionary = value.get("obligations", {})
	var restored_traces: Dictionary = value.get("traces", {})
	var restored_knowledge: Dictionary = value.get("knowledge", {})
	if day not in ["J12", "J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"]:
		return presence == "UNESTABLISHED" and private_outcome == "UNESTABLISHED" and annexe == "UNESTABLISHED" and priority == "UNESTABLISHED" and not processed and not restored_traces.has("j12_laverriere_public_group_set_01") and not restored_traces.has("j12_annexe_public_group_set_01")
	if processed and str(restored_obligations.get("aftercare_mathilde_j11", {}).get("status", "")) != "FAILED": return false
	var j11_pivot_value := str(value.get("j11_pivot", ""))
	var j11_outcome := str(value.get("j11_pivot_outcome", ""))
	var r5b_private_outcomes := {
		"SANDRA_RULE_CLARIFIED": ["UNESTABLISHED", "SANDRA_RESPONSE_CLEAR", "SANDRA_RESPONSE_DELAYED", "SANDRA_EXIT_CLEAN"],
		"SANDRA_DESIRE_BOUNDED": ["UNESTABLISHED", "SANDRA_RESPONSE_CLEAR", "SANDRA_RESPONSE_DELAYED", "SANDRA_EXIT_CLEAN"],
		"SANDRA_IMAGE_REMOVED": ["UNESTABLISHED"],
		"FIRST_KISS": ["UNESTABLISHED", "RAPHAELLE_PUBLIC", "RAPHAELLE_DELAY", "RAPHAELLE_NOW"],
		"KISS_DECLINED": ["UNESTABLISHED", "RAPHAELLE_PUBLIC"],
		"RESULT_SENT_ATTRACTION_NAMED": ["UNESTABLISHED", "RAPHAELLE_PUBLIC", "RAPHAELLE_DELAY", "RAPHAELLE_NOW"],
		"RESULT_SENT_BOUNDARY_HELD": ["UNESTABLISHED", "RAPHAELLE_PUBLIC"],
		"NICO_GUARDRAIL_HELD": ["UNESTABLISHED", "NICO_ACCEPT", "NICO_OBSERVE", "NICO_REFUSE"],
		"NICO_RIVALRY_MAINTAINED": ["UNESTABLISHED", "NICO_RIVALRY_LEAVE", "NICO_RIVALRY_JOKE", "NICO_RIVALRY_EXIT"],
		"NICO_CLEAN_CLOSE": ["UNESTABLISHED"],
	}
	if r5b_private_outcomes.has(j11_outcome) and private_outcome not in r5b_private_outcomes[j11_outcome]: return false
	var j12_resolved := day != "J12" or str(value.get("day_status", "")) == "COMPLETE"
	if j12_resolved and j11_pivot_value in ["SANDRA", "RAPHAELLE", "NICO"]:
		var silence_outcome := j11_outcome in ["SANDRA_IMAGE_REMOVED", "NICO_CLEAN_CLOSE"]
		if silence_outcome != (private_outcome == "UNESTABLISHED"): return false
	var lav_trace: Dictionary = restored_traces.get("j12_laverriere_public_group_set_01", {})
	var lav_fact: Dictionary = restored_knowledge.get("fact_j12_laverriere_participants", {})
	if lav_trace.is_empty() != lav_fact.is_empty(): return false
	if not lav_trace.is_empty():
		if presence == "UNESTABLISHED" or str(lav_fact.get("source_ref", "")) != "j12_laverriere_public_group_set_01": return false
		if str(lav_trace.get("creator", "")) != "Élodie" or str(lav_trace.get("owner", "")) != "La Verrière" or str(lav_trace.get("current_state", "")) != "PUBLIC_ACTIVE": return false
		var lav_subjects: Array = lav_trace.get("subjects", [])
		if lav_subjects != J12_LAVERRIERE_EXPLICIT_SUBJECTS: return false
		if str(lav_trace.get("saving_rule", "")) != "PUBLIC_SOURCE_RULES" or str(lav_trace.get("transfer_rule", "")) != "PUBLIC_SOURCE_RULES" or not bool(lav_trace.get("eligible_for_j14", false)) or not bool(lav_trace.get("eligible_for_j21", false)): return false
		if lav_trace.get("initial_audience", []) != lav_subjects or lav_trace.get("current_audience", []) != lav_subjects or lav_fact.get("participants", []) != lav_subjects: return false
		if str(lav_fact.get("source_type", "")) != "PUBLIC_TRACE" or lav_fact.get("initial_knowers", []) != lav_subjects or lav_fact.get("current_knowers", []) != lav_subjects or str(lav_fact.get("certainty", "")) != "OBSERVED" or str(lav_fact.get("shareability", "")) != "PUBLIC": return false
	var annexe_trace: Dictionary = restored_traces.get("j12_annexe_public_group_set_01", {})
	var annexe_fact: Dictionary = restored_knowledge.get("fact_j12_annexe_participants", {})
	if annexe_trace.is_empty() != annexe_fact.is_empty(): return false
	if not annexe_trace.is_empty():
		if annexe == "UNESTABLISHED" or str(annexe_fact.get("source_ref", "")) != "j12_annexe_public_group_set_01": return false
		var expected_annexe_subjects: Array = ["Marie", "Pauline", "Bastien", "Nico"]
		if annexe in ["A12", "B12"]: expected_annexe_subjects.append("Player")
		var expected_annexe_audience := expected_annexe_subjects.duplicate()
		if annexe == "C12": expected_annexe_audience.append("Player")
		if str(annexe_trace.get("creator", "")) != "Sophie" or str(annexe_trace.get("owner", "")) != "Sophie" or str(annexe_trace.get("current_state", "")) != "PUBLIC_ACTIVE": return false
		if str(annexe_trace.get("saving_rule", "")) != "PUBLIC_SOURCE_RULES" or str(annexe_trace.get("transfer_rule", "")) != "PUBLIC_SOURCE_RULES" or not bool(annexe_trace.get("eligible_for_j14", false)) or not bool(annexe_trace.get("eligible_for_j21", false)) or annexe_trace.get("subjects", []) != expected_annexe_subjects: return false
		if annexe_trace.get("initial_audience", []) != expected_annexe_subjects or annexe_trace.get("current_audience", []) != expected_annexe_audience or annexe_fact.get("participants", []) != expected_annexe_subjects: return false
		if str(annexe_fact.get("source_type", "")) != "PUBLIC_TRACE" or annexe_fact.get("initial_knowers", []) != expected_annexe_subjects or annexe_fact.get("current_knowers", []) != expected_annexe_audience or str(annexe_fact.get("certainty", "")) != "OBSERVED" or str(annexe_fact.get("shareability", "")) != "SAME_AUDIENCE_ONLY": return false
		if bool(annexe_trace.get("player_present", false)) != (annexe != "C12") or bool(annexe_trace.get("player_photographed", false)) != (annexe != "C12") or not bool(annexe_trace.get("player_received_trace", false)): return false
	var presence_promise: Dictionary = restored_promises.get("marie_j12_laverriere_presence", {})
	if presence == "UNESTABLISHED" and not presence_promise.is_empty(): return false
	if presence != "UNESTABLISHED":
		if presence_promise.is_empty() or str(presence_promise.get("outcome", "")) != presence or str(presence_promise.get("created_at", "")) != "J12 14:42" or str(presence_promise.get("created_by", "")) != "Marie" or not bool(presence_promise.get("accepted_by_player", false)): return false
		if str(presence_promise.get("due_at", "")) != str({"L-A":"J12 17:45", "L-B":"J12 19:15", "L-C":"J12 20:15–21:15"}[presence]) or str(presence_promise.get("status", "")) not in ["ACTIVE", "PAID", "FAILED"]: return false
		var presence_status := str(presence_promise.get("status", ""))
		if presence_status == "ACTIVE" and (str(presence_promise.get("paid_or_closed_at", "")) != "" or str(presence_promise.get("paid_or_closed_by", "")) != ""): return false
		if presence_status == "PAID" and (str(presence_promise.get("paid_or_closed_at", "")) != ("J12 21:15" if presence == "L-C" else "J12 22:15") or str(presence_promise.get("paid_or_closed_by", "")) != "arrivée et durée réelles de Player"): return false
		if presence_status == "FAILED" and (str(presence_promise.get("paid_or_closed_at", "")) == "" or str(presence_promise.get("paid_or_closed_by", "")) == ""): return false
	var annexe_promise: Dictionary = restored_promises.get("j12_annexe_continuation", {})
	if annexe == "UNESTABLISHED" and not annexe_promise.is_empty(): return false
	if annexe != "UNESTABLISHED":
		if annexe_promise.is_empty() or str(annexe_promise.get("outcome", "")) != annexe or str(annexe_promise.get("created_at", "")) != "J12 22:22" or str(annexe_promise.get("due_at", "")) != "J12 22:50": return false
		if (annexe == "C12") != (str(annexe_promise.get("status", "")) == "REFUSED") or bool(annexe_promise.get("accepted_by_player", false)) != (annexe != "C12"): return false
		var annexe_status := str(annexe_promise.get("status", ""))
		if annexe_status not in ["ACTIVE", "PAID", "REFUSED", "FAILED"]: return false
		if annexe_status == "ACTIVE" and (str(annexe_promise.get("paid_or_closed_at", "")) != "" or str(annexe_promise.get("paid_or_closed_by", "")) != ""): return false
		if annexe_status == "PAID" and str(annexe_promise.get("paid_or_closed_at", "")) not in (["J12 22:50", "J13 00:00"] if annexe == "A12" else ["J12 22:50", "J12 23:15"]): return false
		if annexe_status in ["PAID", "FAILED"] and str(annexe_promise.get("paid_or_closed_by", "")) == "": return false
		if annexe_status == "REFUSED" and (str(annexe_promise.get("paid_or_closed_at", "")) != "J12 22:22" or str(annexe_promise.get("paid_or_closed_by", "")) != "Player"): return false
	var p11: Dictionary = restored_promises.get("sandra_cafe_saturday_1100", {})
	if not p11.is_empty():
		if str(p11.get("due_at", "")) != "J12 11:00" or str(p11.get("confirmation_deadline", "")) != "Sandra J11 18:00 puis Player J12 09:30": return false
		var p11_status := str(p11.get("status", ""))
		var p11_confirm_choice: bool = value.get("selected_choice_ids", []).has("choice_j12_p11_confirm")
		var p11_refuse_choice: bool = value.get("selected_choice_ids", []).has("choice_j12_p11_refuse")
		if p11_status not in ["CONDITIONAL", "ACTIVE", "PAID", "REFUSED", "EXPIRED"] or (p11_confirm_choice and p11_refuse_choice): return false
		if (p11_status in ["ACTIVE", "PAID"]) != p11_confirm_choice or (p11_status == "REFUSED") != p11_refuse_choice: return false
		if bool(p11.get("accepted_by_player", false)) != (p11_status in ["ACTIVE", "PAID"]): return false
		if p11_status == "PAID" and (str(p11.get("paid_or_closed_at", "")) != "J12 11:30" or str(p11.get("paid_or_closed_by", "")) != "Player et Sandra hors téléphone" or str(p11.get("outcome", "")) != "CAFE_HELD"): return false
		if p11_status == "REFUSED" and (str(p11.get("paid_or_closed_at", "")) != "J12 09:19" or str(p11.get("outcome", "")) != "REFUSED_BY_PLAYER"): return false
		if p11_status == "EXPIRED" and (str(p11.get("paid_or_closed_at", "")) not in ["J11 18:00", "J12 09:30"] or str(p11.get("paid_or_closed_by", "")) not in ["counterparty_confirmation_deadline", "player_confirmation_deadline"]): return false
	var t16: Dictionary = restored_traces.get("j12_sandra_public_context_view_01", {})
	var f21: Dictionary = restored_knowledge.get("fact_sandra_saw_public_j12_context", {})
	if t16.is_empty() != f21.is_empty(): return false
	var t16_required := private_outcome in ["SANDRA_RESPONSE_CLEAR", "SANDRA_RESPONSE_DELAYED", "SANDRA_EXIT_CLEAN"]
	var t16_allowed_before_choice := day == "J12" and str(value.get("day_status", "")) == "ACTIVE" and private_outcome == "UNESTABLISHED" and j11_pivot_value == "SANDRA" and j11_outcome in ["SANDRA_RULE_CLARIFIED", "SANDRA_DESIRE_BOUNDED"] and not lav_trace.is_empty()
	if t16_required and t16.is_empty(): return false
	if not t16_required and not t16_allowed_before_choice and not t16.is_empty(): return false
	if not t16.is_empty():
		if str(t16.get("current_state", "")) != "ACTIVE" or str(t16.get("creator", "")) != "canal public La Verrière" or str(t16.get("owner", "")) != "source publique" or str(f21.get("source_ref", "")) != "j12_sandra_public_context_view_01": return false
		if t16.get("subjects", []) != lav_trace.get("subjects", []) or t16.get("initial_audience", []) != t16.get("current_audience", []) or not t16.get("current_audience", []).has("Sandra") or bool(t16.get("eligible_for_j14", true)) or bool(t16.get("eligible_for_j21", true)): return false
		if f21.get("initial_knowers", []) != ["Sandra"] or f21.get("current_knowers", []) != ["Sandra"] or str(f21.get("certainty", "")) != "OBSERVED" or str(f21.get("shareability", "")) != "PUBLIC_SOURCE_RULES": return false
	var f20: Dictionary = restored_knowledge.get("fact_j12_unusual_behavior_observed", {})
	var expected_f20 := _expected_j12_f20(value)
	if expected_f20.is_empty() != f20.is_empty(): return false
	if not f20.is_empty():
		for f20_key in expected_f20:
			if f20.get(f20_key) != expected_f20[f20_key]: return false
	var priority_obligation: Dictionary = restored_obligations.get("j12_priority_consequence_j13", {})
	if priority == "UNESTABLISHED" and not priority_obligation.is_empty(): return false
	if priority != "UNESTABLISHED" and priority_obligation.is_empty(): return false
	if priority != "UNESTABLISHED":
		var expected_priority := _j12_priority_contract(priority, restored_obligations)
		for priority_key in expected_priority:
			if priority_obligation.get(priority_key) != expected_priority[priority_key]: return false
	if processed and (priority not in ["UNESTABLISHED", "MATHILDE"] or (priority == "MATHILDE" and (priority_obligation.get("concerned_people", []) != ["Player", "Mathilde"] or str(priority_obligation.get("origin", "")) != "MATHILDE_HOUSEHOLD_AFTERCARE"))): return false
	if day == "J12" and priority != "UNESTABLISHED" and str(priority_obligation.get("status", "")) != "DUE": return false
	if day in ["J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"] and priority != "UNESTABLISHED" and str(priority_obligation.get("status", "")) not in ["DUE", "PAID", "REFUSED", "FAILED", "CLOSED"]: return false
	if priority != "UNESTABLISHED" and str(priority_obligation.get("status", "")) in ["PAID", "REFUSED", "FAILED", "CLOSED"] and (str(priority_obligation.get("paid_by", "")) == "" or str(priority_obligation.get("paid_or_closed_at", "")) == ""): return false
	if day == "J12" and str(value.get("day_status", "")) == "COMPLETE":
		return presence != "UNESTABLISHED" and str(presence_promise.get("status", "")) == "PAID" and annexe != "UNESTABLISHED" and str(annexe_promise.get("status", "")) in ["PAID", "REFUSED"] and priority != "UNESTABLISHED" and not lav_trace.is_empty() and not annexe_trace.is_empty() and (p11.is_empty() or str(p11.get("status", "")) in ["PAID", "REFUSED", "EXPIRED"])
	return true

func _j13_records_consistent(value: Dictionary) -> bool:
	var day := str(value.get("current_day", "")); var pivot := str(value.get("j13_pivot", "")); var outcome := str(value.get("j13_outcome", "UNESTABLISHED")); var trace_id := str(value.get("j13_j14_trace_id", "")); var restored_traces: Dictionary = value.get("traces", {}); var restored_knowledge: Dictionary = value.get("knowledge", {}); var restored_obligations: Dictionary = value.get("obligations", {})
	if not _j13_trace_knowledge_contracts_consistent(restored_traces, restored_knowledge, value.get("selected_choice_ids", [])): return false
	if day not in ["J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"]: return pivot == "" and outcome == "UNESTABLISHED" and trace_id == "" and not restored_traces.has("j13_pauline_private_version_01") and not restored_traces.has("j13_raphaelle_masked_version_01") and not restored_traces.has("j13_nico_alibi_or_hour_message_01")
	if pivot == "": return outcome == "UNESTABLISHED" and trace_id == ""
	if pivot not in ["PAULINE", "RAPHAELLE", "NICO", "SANDRA", "MATHILDE", "MARIE", "RESPIRATION"]: return false
	var obligation: Dictionary = restored_obligations.get("j12_priority_consequence_j13", {})
	var expected_route := "NETWORK" if pivot in ["PAULINE", "RESPIRATION"] else pivot
	if str(obligation.get("route", "")) != expected_route or str(value.get("j12_priority_route", "")) != expected_route: return false
	if pivot == "SANDRA" and str(value.get("j11_pivot_outcome", "")) == "SANDRA_IMAGE_REMOVED": return false
	if pivot == "NICO" and str(value.get("j11_pivot_outcome", "")) == "NICO_CLEAN_CLOSE": return false
	if restored_traces.has("j13_pauline_private_version_01") and pivot != "PAULINE": return false
	if restored_traces.has("j13_raphaelle_masked_version_01") and pivot != "RAPHAELLE": return false
	if restored_traces.has("j13_nico_alibi_or_hour_message_01") and pivot != "NICO": return false
	if outcome == "UNESTABLISHED": return trace_id == "" and str(obligation.get("status", "")) == "DUE" and not restored_traces.has("j13_nico_alibi_or_hour_message_01")
	var choice_id := "choice_j13_" + outcome.to_lower()
	if not value.get("selected_choice_ids", []).has(choice_id): return false
	var expected_resolution := _j13_resolution_for_choice(choice_id)
	if expected_resolution == "" or not _j13_choice_allowed_for_snapshot(choice_id, pivot, value) or str(obligation.get("status", "")) != expected_resolution or str(obligation.get("paid_by", "")) == "" or str(obligation.get("paid_or_closed_at", "")) == "": return false
	if pivot == "PAULINE" and not restored_traces.has("j13_pauline_private_version_01"): return false
	if pivot == "RAPHAELLE" and _j13_raphaelle_standard_eligible_in(value) != restored_traces.has("j13_raphaelle_masked_version_01"): return false
	if pivot == "NICO" and not restored_traces.has("j13_nico_alibi_or_hour_message_01"): return false
	var expected_trace_id := _j13_expected_snapshot_handoff(pivot, restored_traces)
	if trace_id == "" or trace_id != expected_trace_id or not _j13_snapshot_trace_accessible(restored_traces, trace_id): return false
	if str(value.get("day_status", "")) == "COMPLETE": return outcome != "UNESTABLISHED" and trace_id != ""
	return true

func _j13_trace_knowledge_contracts_consistent(restored_traces: Dictionary, restored_knowledge: Dictionary, restored_choices: Array) -> bool:
	var pauline_trace: Dictionary = restored_traces.get("j13_pauline_private_version_01", {}); var pauline_fact: Dictionary = restored_knowledge.get("fact_pauline_created_private_double_address", {})
	if pauline_trace.is_empty() != pauline_fact.is_empty(): return false
	if not pauline_trace.is_empty():
		if str(pauline_trace.get("knowledge_created", "")) != "fact_pauline_created_private_double_address" or str(pauline_trace.get("saving_rule", "")) != "IN_THREAD_ONLY" or str(pauline_trace.get("transfer_rule", "")) != "FORBIDDEN": return false
		if str(pauline_trace.get("asset_id", "")) != "S1_A4_J13_DPH_PAULINE_PRIVATE_VERSION_01" or str(pauline_trace.get("parent_content_id", "")) != "C12-03" or str(pauline_trace.get("parent_asset_id", "")) != "S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01": return false
		if pauline_trace.get("initial_audience", []) != ["Pauline"] or str(pauline_trace.get("current_state", "")) not in ["PRIVATE_ACTIVE", "REMOVED", "INACCESSIBLE"]: return false
		if str(pauline_trace.get("current_state", "")) == "PRIVATE_ACTIVE" and pauline_trace.get("current_audience", []) != ["Pauline","Player"]: return false
		if str(pauline_trace.get("current_state", "")) == "REMOVED" and pauline_trace.get("current_audience", []) != ["Pauline"]: return false
		if str(pauline_fact.get("fact_id", "")) != "fact_pauline_created_private_double_address" or str(pauline_fact.get("source_type", "")) != "PRIVATE_TRACE" or str(pauline_fact.get("source_ref", "")) != "j13_pauline_private_version_01": return false
		if pauline_fact.get("initial_knowers", []) != ["Pauline","Player"] or pauline_fact.get("current_knowers", []) != ["Pauline","Player"] or str(pauline_fact.get("certainty", "")) != "CONFIRMED" or str(pauline_fact.get("shareability", "")) != "PRIVATE_DO_NOT_SHARE" or str(pauline_fact.get("source_day", "")) != "J13": return false
	var raphaelle_trace: Dictionary = restored_traces.get("j13_raphaelle_masked_version_01", {}); var raphaelle_fact: Dictionary = restored_knowledge.get("fact_raphaelle_chose_player_for_masked_posture_image", {})
	if raphaelle_trace.is_empty() != raphaelle_fact.is_empty(): return false
	if not raphaelle_trace.is_empty():
		if str(raphaelle_trace.get("knowledge_created", "")) != "fact_raphaelle_chose_player_for_masked_posture_image" or str(raphaelle_trace.get("creator", "")) != "Maud" or str(raphaelle_trace.get("selected_by", "")) != "Raphaëlle": return false
		if str(raphaelle_trace.get("asset_id", "")) != "S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01": return false
		if str(raphaelle_trace.get("saving_rule", "")) != "IN_THREAD_ONLY" or str(raphaelle_trace.get("transfer_rule", "")) != "FORBIDDEN" or raphaelle_trace.get("initial_audience", []) != ["Raphaëlle","Maud"] or str(raphaelle_trace.get("current_state", "")) not in ["PRIVATE_ACTIVE", "REMOVED", "INACCESSIBLE"]: return false
		if str(raphaelle_trace.get("current_state", "")) == "PRIVATE_ACTIVE" and raphaelle_trace.get("current_audience", []) != ["Raphaëlle","Maud","Player"]: return false
		if str(raphaelle_trace.get("current_state", "")) == "REMOVED" and raphaelle_trace.get("current_audience", []) != ["Raphaëlle"]: return false
		if str(raphaelle_fact.get("fact_id", "")) != "fact_raphaelle_chose_player_for_masked_posture_image" or str(raphaelle_fact.get("source_type", "")) != "PRIVATE_TRACE" or str(raphaelle_fact.get("source_ref", "")) != "j13_raphaelle_masked_version_01": return false
		if raphaelle_fact.get("initial_knowers", []) != ["Raphaëlle","Maud","Player"] or raphaelle_fact.get("current_knowers", []) != ["Raphaëlle","Maud","Player"] or str(raphaelle_fact.get("certainty", "")) != "CONFIRMED" or str(raphaelle_fact.get("shareability", "")) != "PRIVATE_DO_NOT_SHARE" or str(raphaelle_fact.get("source_day", "")) != "J13": return false
	var nico_trace: Dictionary = restored_traces.get("j13_nico_alibi_or_hour_message_01", {}); var nico_fact: Dictionary = restored_knowledge.get("fact_nico_knows_specific_hour_or_alibi_request", {})
	if nico_trace.is_empty() != nico_fact.is_empty(): return false
	if not nico_trace.is_empty():
		var source_choice_id := str(nico_fact.get("source_choice_id", "")); var expected_boundary := "ALIBI_REQUEST" if source_choice_id.ends_with("_alibi") else ("COVERAGE_CLOSED" if source_choice_id.ends_with("_close") else ("TRUTH_LIMIT" if source_choice_id.ends_with("_truth") else ""))
		var expected_subjects := ["Nico","Player","Marie"] if source_choice_id.begins_with("choice_j13_nico_rivalry_") else ["Nico","Player"]
		if expected_boundary == "" or not restored_choices.has(source_choice_id) or nico_trace.get("subjects", []) != expected_subjects: return false
		if str(nico_trace.get("knowledge_created", "")) != "fact_nico_knows_specific_hour_or_alibi_request" or str(nico_trace.get("choice_source", "")) != source_choice_id or str(nico_trace.get("saving_rule", "")) != "IN_THREAD_ONLY" or str(nico_trace.get("transfer_rule", "")) != "FORBIDDEN": return false
		if nico_trace.get("initial_audience", []) != ["Nico","Player"] or nico_trace.get("current_audience", []) != ["Nico","Player"] or str(nico_trace.get("current_state", "")) not in ["ACTIVE", "RESTRICTED", "INACCESSIBLE"]: return false
		if str(nico_fact.get("fact_id", "")) != "fact_nico_knows_specific_hour_or_alibi_request" or str(nico_fact.get("source_type", "")) != "DIRECT_MESSAGE" or str(nico_fact.get("source_ref", "")) != "j13_nico_alibi_or_hour_message_01": return false
		if nico_fact.get("initial_knowers", []) != ["Nico","Player"] or nico_fact.get("current_knowers", []) != ["Nico","Player"] or str(nico_fact.get("certainty", "")) != "TOLD_DIRECTLY" or str(nico_fact.get("shareability", "")) != "FACTUAL_ONLY" or str(nico_fact.get("source_day", "")) != "J13" or str(nico_fact.get("request_or_boundary", "")) != expected_boundary: return false
	return true

func _j13_snapshot_trace_accessible(restored_traces: Dictionary, trace_id: String) -> bool:
	var trace: Dictionary = restored_traces.get(trace_id, {})
	if trace.is_empty() or str(trace.get("current_state", "")) in ["REMOVED", "INACCESSIBLE", "NOT_CREATED"]: return false
	var canonical_legacy := trace_id in ["j11_sandra_chosen_image_01", "j11_mathilde_physical_aftercare_01"]
	if not bool(trace.get("eligible_for_j14", canonical_legacy)): return false
	return str(trace.get("current_state", "")) == "PUBLIC_ACTIVE" or trace.get("current_audience", []).has("Player")

func _j13_expected_snapshot_handoff(pivot: String, restored_traces: Dictionary) -> String:
	var preferred := str({"PAULINE":"j13_pauline_private_version_01", "RAPHAELLE":"j13_raphaelle_masked_version_01", "NICO":"j13_nico_alibi_or_hour_message_01", "SANDRA":"j11_sandra_chosen_image_01", "MATHILDE":"j11_mathilde_physical_aftercare_01"}.get(pivot, "j12_laverriere_public_group_set_01"))
	if _j13_snapshot_trace_accessible(restored_traces, preferred): return preferred
	return "j12_laverriere_public_group_set_01" if _j13_snapshot_trace_accessible(restored_traces, "j12_laverriere_public_group_set_01") else ""

func _j14_records_consistent(value: Dictionary) -> bool:
	if typeof(value.get("j14_witness_presence_evidence", {})) != TYPE_DICTIONARY or typeof(value.get("j14_visible_fields", [])) != TYPE_ARRAY or typeof(value.get("j14_visible_values", {})) != TYPE_DICTIONARY: return false
	var day := str(value.get("current_day", "")); var variant := str(value.get("j14_variant", "")); var outcome := str(value.get("j14_outcome", "UNESTABLISHED")); var witness := str(value.get("j14_witness", "")); var source_id := str(value.get("j14_source_trace_id", ""))
	var restored_traces: Dictionary = value.get("traces", {}); var restored_knowledge: Dictionary = value.get("knowledge", {}); var restored_promises: Dictionary = value.get("promises", {})
	var discovery: Dictionary = restored_traces.get("j14_discovery_event_01", {}); var discovery_fact: Dictionary = restored_knowledge.get("fact_witness_saw_limited_trace", {}); var explanation: Dictionary = restored_knowledge.get("fact_player_explanation_to_witness", {}); var notice: Dictionary = restored_promises.get("j14_inform_trace_controller", {}); var clarification: Dictionary = restored_promises.get("j14_witness_clarification", {}); var notice_failure: Dictionary = restored_knowledge.get("fact_trace_controller_not_informed", {})
	if day not in ["J14","J15","J16","J17","J18","J19","J20","J21"]:
		return variant == "" and outcome == "UNESTABLISHED" and witness == "" and source_id == "" and value.get("j14_witness_presence_evidence", {}).is_empty() and value.get("j14_visible_fields", []).is_empty() and value.get("j14_visible_values", {}).is_empty() and discovery.is_empty() and discovery_fact.is_empty() and explanation.is_empty() and notice.is_empty() and clarification.is_empty() and notice_failure.is_empty()
	if variant == "":
		return day == "J14" and str(value.get("day_status", "")) == "ACTIVE" and outcome == "UNESTABLISHED" and witness == "" and source_id == "" and value.get("j14_witness_presence_evidence", {}).is_empty() and value.get("j14_visible_fields", []).is_empty() and value.get("j14_visible_values", {}).is_empty() and discovery.is_empty() and discovery_fact.is_empty() and explanation.is_empty() and notice.is_empty() and clarification.is_empty() and notice_failure.is_empty()
	if source_id != str(value.get("j13_j14_trace_id", "")) or not _j13_snapshot_trace_accessible(restored_traces, source_id): return false
	if variant == "S27_MUTATION_NO_DISCOVERY":
		return outcome == "S27_MUTATION_NO_DISCOVERY" and witness == "" and value.get("j14_witness_presence_evidence", {}).is_empty() and str(value.get("j14_discovery_mode", "")) == "" and value.get("j14_visible_fields", []).is_empty() and value.get("j14_visible_values", {}).is_empty() and str(value.get("j14_secondary_trace_id", "")) == "" and str(value.get("j14_player_initial_reaction", "")) == "" and str(value.get("j14_player_explanation", "")) == "" and str(value.get("j14_j15_obligation_id", "")) == "" and not bool(value.get("j14_controller_notified", false)) and discovery.is_empty() and discovery_fact.is_empty() and explanation.is_empty() and notice.is_empty() and clarification.is_empty() and notice_failure.is_empty()
	if variant not in ["PAULINE","SANDRA","MATHILDE","RAPHAELLE","NICO"]: return false
	var contract := _j14_contract_for_variant(variant, "", value); var presence_contract := _j14_presence_contract_for_source(source_id); var evidence: Dictionary = value.get("j14_witness_presence_evidence", {})
	if contract.is_empty() or presence_contract.is_empty() or witness != str(contract["witness_id"]) or not _j14_presence_evidence_admissible(evidence, presence_contract): return false
	var selected_nico_defer: bool = value.get("selected_choice_ids", []).has("choice_j14_nico_defer")
	if variant == "NICO" and (outcome == "PROTECT_AND_DEFER" or (selected_nico_defer and outcome not in ["UNESTABLISHED","PROTECT_AND_ANSWER_NOW"])): return false
	if str(value.get("j14_secondary_trace_id", "")) != "" or str(value.get("j14_discovery_mode", "")) != str(contract["discovery_mode"]) or value.get("j14_visible_fields", []) != contract["visible_fields"] or value.get("j14_visible_values", {}) != contract["visible_values"] or str(value.get("j14_player_initial_reaction", "")) != str(contract["player_reaction"]): return false
	if discovery.is_empty() != discovery_fact.is_empty(): return false
	if discovery.is_empty():
		return outcome == "UNESTABLISHED" and explanation.is_empty() and notice.is_empty() and clarification.is_empty() and str(value.get("j14_player_explanation", "")) == "" and not bool(value.get("j14_controller_notified", false))
	var controller := _j14_controller_for_source(source_id); var expected_subjects := [witness,"Player",controller]
	if controller == "" or str(discovery.get("trace_id", "")) != "j14_discovery_event_01" or str(discovery.get("trace_type", "")) != "FACT_RECORD" or str(discovery.get("source_day", "")) != "J14" or str(discovery.get("source_scene", "")) != "S27 photo au mauvais écran": return false
	if str(discovery.get("creator", "")) != "système narratif à partir d’une trace existante" or discovery.get("subjects", []) != expected_subjects or str(discovery.get("owner", "")) != "état narratif" or discovery.get("initial_audience") != "NOT_APPLICABLE" or discovery.get("current_audience") != "NOT_APPLICABLE": return false
	if str(discovery.get("storage_location", "")) != "registre de connaissances" or str(discovery.get("saving_rule", "")) != "NONE" or str(discovery.get("transfer_rule", "")) != "FORBIDDEN" or discovery.get("replaces_or_derives_from", []) != [source_id] or str(discovery.get("discovered_trace_id", "")) != source_id or str(discovery.get("secondary_trace_id", "")) != "": return false
	if str(discovery.get("witness_id", "")) != witness or str(discovery.get("discovery_mode", "")) != str(contract["discovery_mode"]) or discovery.get("visible_fields", []) != contract["visible_fields"] or discovery.get("visible_values", {}) != contract["visible_values"] or str(discovery.get("visible_duration", "")) != "BRIEF_GLANCE" or discovery.get("witness_presence_evidence", {}) != evidence or str(discovery.get("player_reaction", "")) != str(contract["player_reaction"]): return false
	if not bool(discovery.get("source_trace_unchanged", false)) or str(discovery.get("knowledge_created", "")) != "fact_witness_saw_limited_trace" or bool(discovery.get("eligible_for_j14", true)) or not bool(discovery.get("eligible_for_j21", false)) or discovery.get("legacy_alias", "INVALID") != null or str(discovery.get("current_state", "")) != "ACTIVE": return false
	if str(discovery_fact.get("fact_id", "")) != "fact_witness_saw_limited_trace" or str(discovery_fact.get("source_type", "")) != "DIRECT_OBSERVATION" or str(discovery_fact.get("source_ref", "")) != "j14_discovery_event_01" or discovery_fact.get("initial_knowers", []) != [witness,"Player"] or discovery_fact.get("current_knowers", []) != [witness,"Player"]: return false
	if str(discovery_fact.get("certainty", "")) != "OBSERVED" or str(discovery_fact.get("context_certainty", "")) != "INCOMPLETE" or str(discovery_fact.get("shareability", "")) != "FACTUAL_ONLY" or str(discovery_fact.get("source_day", "")) != "J14" or str(discovery_fact.get("witness_id", "")) != witness or str(discovery_fact.get("discovered_trace_id", "")) != source_id or discovery_fact.get("visible_fields", []) != contract["visible_fields"] or discovery_fact.get("visible_values", {}) != contract["visible_values"] or str(discovery_fact.get("visible_duration", "")) != "BRIEF_GLANCE" or str(discovery_fact.get("player_reaction", "")) != str(contract["player_reaction"]): return false
	if notice.is_empty() or str(notice.get("promise_id", "")) != "j14_inform_trace_controller" or str(notice.get("status", "")) not in ["ACTIVE","PAID","FAILED"] or str(notice.get("controller", "")) != controller or str(notice.get("witness_id", "")) != witness or notice.get("visible_fields", []) != contract["visible_fields"] or notice.get("visible_values", {}) != contract["visible_values"] or str(notice.get("player_reaction", "")) != str(contract["player_reaction"]): return false
	if outcome == "UNESTABLISHED":
		if not explanation.is_empty() or str(value.get("j14_player_explanation", "")) != "" or str(notice.get("player_declaration", "")) != "" or str(notice.get("source_choice_id", "")) != "" or not clarification.is_empty(): return false
	else:
		if outcome not in ["TRUTH_LIMITED","MINIMIZE_OR_LIE","PROTECT_AND_DEFER","PROTECT_AND_ANSWER_NOW"] or explanation.is_empty() or str(value.get("j14_player_explanation", "")) != outcome or str(explanation.get("player_explanation", "")) != outcome or str(explanation.get("witness_id", "")) != witness or str(explanation.get("discovered_trace_id", "")) != source_id or str(discovery.get("player_explanation", "")) != outcome: return false
		var source_choice_id := str(notice.get("source_choice_id", "")); if source_choice_id == "" or not value.get("selected_choice_ids", []).has(source_choice_id) or str(notice.get("player_declaration", "")) != _j14_player_statement_for_choice(source_choice_id): return false
	if clarification.is_empty():
		if outcome == "PROTECT_AND_DEFER" and variant != "NICO": return false
		if outcome == "PROTECT_AND_ANSWER_NOW" and variant != "NICO": return false
		if str(value.get("j14_j15_obligation_id", "")) != "": return false
	else:
		if outcome != "PROTECT_AND_DEFER" or variant == "NICO" or str(value.get("j14_j15_obligation_id", "")) != "j14_witness_clarification" or str(clarification.get("promise_id", "")) != "j14_witness_clarification" or str(clarification.get("witness_id", "")) != witness or not bool(clarification.get("accepted_by_player", false)) or str(clarification.get("accepted_at", "")) == "" or str(clarification.get("source_choice_id", "")) == "" or str(clarification.get("due_at", "")) == "" or str(clarification.get("status", "")) not in ["ACTIVE","PAID","AMENDED","FAILED","CANCELLED"]: return false
		if str(clarification.get("due_at", "")).begins_with("J14 ") and str(value.get("day_status", "")) == "COMPLETE" and str(clarification.get("status", "")) == "ACTIVE": return false
	var notice_status := str(notice.get("status", "")); var notified := bool(value.get("j14_controller_notified", false)); var notice_fact: Dictionary = restored_knowledge.get("fact_trace_controller_informed_of_audience_breach", {})
	if notice_status == "PAID":
		if not notified or notice_fact.is_empty() or str(notice_fact.get("source_ref", "")) != "j14_inform_trace_controller" or notice_fact.get("visible_values", {}) != contract["visible_values"] or str(notice_fact.get("player_declaration", "")) != str(notice.get("player_declaration", "")): return false
	elif notice_status == "FAILED":
		if notified or not notice_fact.is_empty() or notice_failure.is_empty() or str(notice_failure.get("source_ref", "")) != "j14_inform_trace_controller" or str(notice_failure.get("failure_reason", "")) not in ["REFUSED","OMITTED"] or str(notice_failure.get("failed_by", "")) != "Player": return false
	elif notified or not notice_fact.is_empty() or not notice_failure.is_empty(): return false
	if str(value.get("day_status", "")) == "COMPLETE" and notice_status not in ["PAID","FAILED"]: return false
	return true

func _j15_records_consistent(value: Dictionary) -> bool:
	var day := str(value.get("current_day", "")); var mode := str(value.get("j15_mode", "UNESTABLISHED")); var outcome := str(value.get("j15_outcome", "UNESTABLISHED")); var urgent := bool(value.get("j15_urgent_consequence_remaining", false)); var restored_traces: Dictionary = value.get("traces", {}); var restored_promises: Dictionary = value.get("promises", {}); var restored_knowledge: Dictionary = value.get("knowledge", {})
	if str(value.get("j14_variant", "")) == "NICO" and str(value.get("j14_outcome", "")) == "PROTECT_AND_ANSWER_NOW" and mode in ["ACTIVE_CLARIFICATION","OPEN_CLARIFICATION"]: return false
	if day not in ["J15", "J16", "J17", "J18", "J19", "J20", "J21"]: return mode == "UNESTABLISHED" and outcome == "UNESTABLISHED" and not urgent and not restored_traces.has("j15_obligation_collision_record_01") and not restored_promises.has("j16_priority_consequence_payment") and not restored_knowledge.has("fact_j15_obligation_resolution")
	if mode == "UNESTABLISHED": return outcome == "UNESTABLISHED" and not urgent and not restored_traces.has("j15_obligation_collision_record_01") and not restored_knowledge.has("fact_j15_obligation_resolution") and not restored_promises.has("j16_priority_consequence_payment")
	if mode not in ["ACTIVE_CLARIFICATION","REPAIR","OPEN_CLARIFICATION","NO_OBLIGATION"]: return false
	if outcome == "UNESTABLISHED": return not urgent and not restored_traces.has("j15_obligation_collision_record_01") and not restored_knowledge.has("fact_j15_obligation_resolution") and not restored_promises.has("j16_priority_consequence_payment")
	var selected_j15_choices: Array[String] = []
	for choice_id in value.get("selected_choice_ids", []):
		if str(choice_id).begins_with("choice_j15_"): selected_j15_choices.append(str(choice_id))
	if selected_j15_choices.size() != 1: return false
	var selected_choice_id := selected_j15_choices[0]; var action_id := selected_choice_id.trim_suffix("_marie").trim_suffix("_mathilde")
	if outcome != action_id.trim_prefix("choice_j15_").to_upper(): return false
	var record: Dictionary = restored_traces.get("j15_obligation_collision_record_01", {})
	if mode == "NO_OBLIGATION":
		if action_id != "choice_j15_clean_acknowledge" or not record.is_empty() or restored_knowledge.has("fact_j15_obligation_resolution") or urgent: return false
	else:
		if record.is_empty() or str(record.get("trace_id", "")) != "j15_obligation_collision_record_01" or str(record.get("record_type", "")) != "FACT_RECORD" or str(record.get("source_day", "")) != "J15" or str(record.get("collision_mode", "")) != "NO_COLLISION" or bool(record.get("incompatible_windows_proven", true)) or bool(record.get("second_signed_obligation_present", true)): return false
		if str(record.get("chosen_priority", "")) != "BOUNDED_CLARIFICATION" or str(record.get("promise_outcome", "")) != outcome or bool(record.get("urgent_consequence_remaining", false)) != urgent or str(record.get("current_state", "")) != "ACTIVE" or str(record.get("visual_asset", "")) != "none": return false
		var resolution_fact: Dictionary = restored_knowledge.get("fact_j15_obligation_resolution", {})
		if str(resolution_fact.get("fact_id", "")) != "fact_j15_obligation_resolution" or str(resolution_fact.get("source_type", "")) != "INFERENCE" or str(resolution_fact.get("source_ref", "")) != "j15_obligation_collision_record_01" or resolution_fact.get("initial_knowers", []) != [str(value.get("j14_witness", "")),"Player"] or str(resolution_fact.get("certainty", "")) != "CONFIRMED" or str(resolution_fact.get("shareability", "")) != "WITNESS_BOUNDED" or str(resolution_fact.get("source_day", "")) != "J15": return false
		if mode == "ACTIVE_CLARIFICATION":
			var clarification: Dictionary = restored_promises.get("j14_witness_clarification", {}); var expected_status: String = str({"choice_j15_due_pay":"PAID","choice_j15_due_cancel":"CANCELLED","choice_j15_due_fail":"FAILED"}.get(action_id, ""))
			if expected_status == "" or str(clarification.get("status", "")) != expected_status or record.get("eligible_active_promise_ids", []) != ["j14_witness_clarification"] or str(record.get("selected_promise_id", "")) != "j14_witness_clarification": return false
			if record.get("amended_promise_ids", []) != [] or record.get("failed_promise_ids", []) != (["j14_witness_clarification"] if expected_status == "FAILED" else []) or record.get("closed_promise_ids", []) != (["j14_witness_clarification"] if expected_status == "CANCELLED" else []): return false
			var expected_at := str(clarification.get("due_at", "")) if expected_status == "FAILED" else "J15 18:34"
			if str(clarification.get("paid_or_closed_at", "")) != expected_at or str(clarification.get("paid_or_closed_by", "")) != "Player": return false
		else:
			if not record.get("eligible_active_promise_ids", []).is_empty() or str(record.get("selected_promise_id", "")) != "" or not record.get("amended_promise_ids", []).is_empty() or not record.get("failed_promise_ids", []).is_empty() or not record.get("closed_promise_ids", []).is_empty(): return false
	var consequence: Dictionary = restored_promises.get("j16_priority_consequence_payment", {})
	if urgent != not consequence.is_empty(): return false
	if urgent and (str(consequence.get("status", "")) != "ACTIVE" or str(consequence.get("source_signed_ref", "")) != selected_choice_id or str(consequence.get("concerned_person", "")) != str(value.get("j14_witness", "")) or str(consequence.get("due_at", "")) != "J16"): return false
	if str(value.get("day_status", "")) == "COMPLETE": return outcome != "UNESTABLISHED"
	return true

func _j16_records_consistent(value: Dictionary) -> bool:
	var day := str(value.get("current_day", "")); var priority := str(value.get("j16_priority", "UNESTABLISHED")); var outcome := str(value.get("j16_consequence_outcome", "UNESTABLISHED")); var departure := str(value.get("j16_departure_state", "UNESTABLISHED")); var j17 := str(value.get("j16_j17_outcome", "UNESTABLISHED")); var restored_traces: Dictionary = value.get("traces", {}); var restored_promises: Dictionary = value.get("promises", {}); var restored_knowledge: Dictionary = value.get("knowledge", {})
	if day not in ["J16", "J17", "J18", "J19", "J20", "J21"]: return priority == "UNESTABLISHED" and outcome == "UNESTABLISHED" and departure == "UNESTABLISHED" and j17 == "UNESTABLISHED" and not restored_traces.has("j16_consequence_payment_record_01") and not restored_knowledge.has("fact_mathilde_departure_planned_j17") and not restored_promises.has("marie_j16_couple_conversation_j17")
	if priority == "UNESTABLISHED": return outcome == "UNESTABLISHED"
	if outcome == "UNESTABLISHED": return not restored_traces.has("j16_consequence_payment_record_01")
	var record: Dictionary = restored_traces.get("j16_consequence_payment_record_01", {})
	if record.is_empty() or bool(record.get("urgent_consequence_remaining", true)) or int(record.get("next_priority", 0)) != 8: return false
	if departure == "UNESTABLISHED": return not restored_knowledge.has("fact_mathilde_departure_planned_j17")
	if str(restored_knowledge.get("fact_mathilde_departure_planned_j17", {}).get("departure_at", "")) != "J17 17:30": return false
	if j17 == "UNESTABLISHED": return not restored_promises.has("marie_j16_couple_conversation_j17")
	if (j17 == "ACCEPT") != restored_promises.has("marie_j16_couple_conversation_j17"): return false
	if str(value.get("day_status", "")) == "COMPLETE": return j17 != "UNESTABLISHED"
	return true

func _j17_records_consistent(value:Dictionary)->bool:
	var day:=str(value.get("current_day",""));var departure:=str(value.get("j17_departure_outcome","UNESTABLISHED"));var couple:=str(value.get("j17_couple_outcome","UNESTABLISHED"));var restored_traces:Dictionary=value.get("traces",{});var restored_knowledge:Dictionary=value.get("knowledge",{})
	if day not in ["J17","J18","J19","J20","J21"]:return departure=="UNESTABLISHED" and couple=="UNESTABLISHED" and not restored_traces.has("j17_couple_definition_record_01") and not restored_knowledge.has("fact_mathilde_left_household") and not restored_knowledge.has("fact_couple_state_defined")
	if departure=="UNESTABLISHED":return couple=="UNESTABLISHED" and not restored_traces.has("j17_couple_definition_record_01")
	if departure not in ["HELP","DISTANCE"] or not restored_knowledge.has("fact_mathilde_left_household"):return false
	if couple=="UNESTABLISHED":return not restored_traces.has("j17_couple_definition_record_01") and not restored_knowledge.has("fact_couple_state_defined")
	if couple not in ["RECONQUEST","PROVISIONAL","SEPARATION","REFUSED_ACKNOWLEDGE"] or str(restored_knowledge.get("fact_couple_state_defined",{}).get("source_ref",""))!="j17_couple_definition_record_01":return false
	var record:Dictionary=restored_traces.get("j17_couple_definition_record_01",{});var required_keys:=["trace_id","record_type","source_day","choice_id","couple_state","discussion_was_due","triggered_guard_fact_ids","satisfied_constructive_condition_ids","mathilde_micro_return_delivered","marie_micro_return_delivered","temporal_projection","current_state","visual_asset"]
	if record.size()!=required_keys.size():return false
	for key in required_keys:
		if not record.has(key):return false
	var choice_id:=str(record.get("choice_id",""));var expected_choice:="choice_j17_"+couple.to_lower()
	if str(record.get("trace_id",""))!="j17_couple_definition_record_01" or str(record.get("record_type",""))!="FACT_RECORD" or str(record.get("source_day",""))!="J17" or choice_id!=expected_choice or not value.get("selected_choice_ids",[]).has(choice_id):return false
	if str(record.get("current_state",""))!="ACTIVE" or str(record.get("visual_asset",""))!="none" or typeof(record.get("discussion_was_due"))!=TYPE_BOOL or typeof(record.get("mathilde_micro_return_delivered"))!=TYPE_BOOL or typeof(record.get("marie_micro_return_delivered"))!=TYPE_BOOL:return false
	if not bool(record.get("mathilde_micro_return_delivered",false)):return false
	if str(value.get("day_status",""))=="COMPLETE" and not bool(record.get("marie_micro_return_delivered",false)):return false
	var temporal:Dictionary=record.get("temporal_projection",{})
	if temporal.size()!=4 or str(temporal.get("day_id",""))!="J17" or str(temporal.get("departure_at",""))!="J17 17:30" or not str(temporal.get("resolved_at","")).begins_with("J17 "):return false
	var due:=_j17_discussion_state(value)=="DUE"
	if bool(record.get("discussion_was_due",not due))!=due or str(temporal.get("couple_discussion_due_at",""))!=("J17 20:30–21:30" if due else ""):return false
	var expected:=_resolve_j17_couple_state(value,choice_id)
	if not bool(expected.get("accepted",false)) or str(record.get("couple_state",""))!=str(value.get("couple_state","")) or str(record.get("couple_state",""))!=str(expected.get("couple_state","")) or str(record.get("couple_state","")) not in J17_COUPLE_STATES:return false
	if typeof(record.get("triggered_guard_fact_ids"))!=TYPE_ARRAY or typeof(record.get("satisfied_constructive_condition_ids"))!=TYPE_ARRAY:return false
	var guard_ids:Array=record.get("triggered_guard_fact_ids",[]);var constructive_ids:Array=record.get("satisfied_constructive_condition_ids",[])
	if guard_ids!=expected.get("triggered_guard_fact_ids",[]) or constructive_ids!=expected.get("satisfied_constructive_condition_ids",[]):return false
	var seen_ids:Array=[]
	for id in guard_ids:
		if seen_ids.has(id) or id not in J17_GUARD_FACT_IDS or not _j17_guard_reference_exists(value,str(id)):return false
		seen_ids.append(id)
	for id in constructive_ids:
		if seen_ids.has(id) or id not in J17_CONSTRUCTIVE_CONDITION_IDS:return false
		seen_ids.append(id)
	return true

func _j18_records_consistent(value:Dictionary)->bool:
	var day:=str(value.get("current_day",""));var outcome:=str(value.get("j18_sandra_outcome","UNESTABLISHED"));var restored_traces:Dictionary=value.get("traces",{});var restored_knowledge:Dictionary=value.get("knowledge",{})
	if day not in ["J18","J19","J20","J21"]:return outcome=="UNESTABLISHED" and not restored_traces.has("j18_sandra_lunch_print_01") and not restored_knowledge.has("fact_sandra_kept_physical_lunch_trace")
	if outcome=="UNESTABLISHED":return not restored_traces.has("j18_sandra_lunch_print_01") and not restored_knowledge.has("fact_sandra_kept_physical_lunch_trace")
	var trace:Dictionary=restored_traces.get("j18_sandra_lunch_print_01",{})
	if trace.is_empty() or str(trace.get("owner",""))!="Sandra" or trace.get("current_audience",[])!=["Sandra"] or str(trace.get("saving_rule",""))!="OWNER_ONLY" or not bool(trace.get("eligible_for_j21",false)):return false
	return str(restored_knowledge.get("fact_sandra_kept_physical_lunch_trace",{}).get("source_ref",""))=="j18_sandra_lunch_print_01"

func _j19_records_consistent(value:Dictionary)->bool:
	var day:=str(value.get("current_day",""));var pivot:=str(value.get("j19_pivot",""));var pauline:=str(value.get("j19_pauline_outcome","UNESTABLISHED"));var raphaelle:=str(value.get("j19_raphaelle_outcome","UNESTABLISHED"));var pending:=bool(value.get("j19_raphaelle_invitation_pending",false));var restored_traces:Dictionary=value.get("traces",{});var restored_knowledge:Dictionary=value.get("knowledge",{});var restored_promises:Dictionary=value.get("promises",{})
	if day not in ["J19","J20","J21"]:return pivot=="" and pauline=="UNESTABLISHED" and raphaelle=="UNESTABLISHED" and not pending and not restored_traces.has("j19_raphaelle_creative_access_01") and not restored_knowledge.has("fact_pauline_private_state_defined") and not restored_knowledge.has("fact_raphaelle_access_state_defined") and not restored_promises.has("raphaelle_future_atelier_saturday_1500")
	if pivot=="":return false
	if (pauline!="UNESTABLISHED")!=restored_knowledge.has("fact_pauline_private_state_defined"):return false
	if (raphaelle!="UNESTABLISHED")!=restored_knowledge.has("fact_raphaelle_access_state_defined") or (raphaelle!="UNESTABLISHED")!=restored_traces.has("j19_raphaelle_creative_access_01"):return false
	if raphaelle!="UNESTABLISHED":
		var access_state:=str(restored_traces["j19_raphaelle_creative_access_01"].get("current_state",""));var expected:="ACTIVE" if raphaelle in ["CREATIVE_CONFIDENCE","FUTURE_INVITATION"] else ("NOT_CREATED" if raphaelle=="COLLEAGUE_ONLY" else "REMOVED")
		if access_state!=expected:return false
	if pending and (pivot!="RAPHAELLE" or raphaelle!="UNESTABLISHED" or pauline=="UNESTABLISHED"):return false
	if restored_promises.has("raphaelle_future_atelier_saturday_1500"):
		var promise:Dictionary=restored_promises["raphaelle_future_atelier_saturday_1500"]
		if str(promise.get("status","")) not in ["ACTIVE","REFUSED"] or str(promise.get("due_at",""))!="samedi suivant, 15 h–17 h":return false
		if (str(promise.get("status",""))=="ACTIVE")!=(raphaelle=="FUTURE_INVITATION"):return false
	elif raphaelle=="FUTURE_INVITATION":return false
	if str(value.get("day_status",""))=="COMPLETE":return pauline!="UNESTABLISHED" and raphaelle!="UNESTABLISHED" and not pending
	return true

func _j20_records_consistent(value:Dictionary)->bool:
	var day:=str(value.get("current_day",""));var context:=str(value.get("j20_context","UNESTABLISHED"));var position:=str(value.get("j20_nico_position","UNESTABLISHED"));var meeting:=str(value.get("j20_meeting_outcome","UNESTABLISHED"));var selected_trace:=str(value.get("final_trace_id",""));var restored_traces:Dictionary=value.get("traces",{});var restored_knowledge:Dictionary=value.get("knowledge",{});var restored_promises:Dictionary=value.get("promises",{})
	if day not in ["J20","J21"]:return context=="UNESTABLISHED" and position=="UNESTABLISHED" and meeting=="UNESTABLISHED" and selected_trace=="" and not restored_knowledge.has("fact_nico_friendship_position_defined") and not restored_knowledge.has("fact_final_trace_selected") and not restored_promises.has("nico_j20_lannexe_2120")
	if context=="UNESTABLISHED":return false
	if (position!="UNESTABLISHED")!=restored_knowledge.has("fact_nico_friendship_position_defined"):return false
	var promise:Dictionary=restored_promises.get("nico_j20_lannexe_2120",{})
	if meeting in ["ACTIVE","PAID","REFUSED"]:
		if promise.is_empty() or str(promise.get("status",""))!=meeting:return false
	elif not promise.is_empty():return false
	if meeting=="NOT_OFFERED" and position!="DISTANCE":return false
	if selected_trace=="":
		if str(value.get("final_trace_state",""))!="" or str(value.get("final_trace_controller",""))!="" or not value.get("final_trace_audience",[]).is_empty() or restored_knowledge.has("fact_final_trace_selected"):return false
	else:
		if not restored_traces.has(selected_trace) or str(restored_knowledge.get("fact_final_trace_selected",{}).get("source_ref",""))!=selected_trace:return false
		var trace:Dictionary=restored_traces[selected_trace]
		if str(value.get("final_trace_state",""))!=str(trace.get("current_state","ACTIVE")) or str(value.get("final_trace_controller",""))!=str(trace.get("owner",trace.get("creator","état de connaissance"))):return false
		if value.get("final_trace_audience",[])!=trace.get("current_audience",trace.get("initial_audience",[])):return false
	if str(value.get("day_status",""))=="COMPLETE":return position!="UNESTABLISHED" and meeting in ["PAID","REFUSED","NOT_OFFERED"] and selected_trace!=""
	return true

func _j21_records_consistent(value:Dictionary)->bool:
	var day:=str(value.get("current_day",""));var morning:=str(value.get("j21_morning_outcome","UNESTABLISHED"));var contradiction:=str(value.get("existing_contradiction_id",""));var options:Array=value.get("final_posture_options",[]);var posture:=str(value.get("final_posture","UNESTABLISHED"));var restored_knowledge:Dictionary=value.get("knowledge",{});var restored_promises:Dictionary=value.get("promises",{})
	if morning not in ["UNESTABLISHED","PRESENCE_1930","HONEST_ABSENCE","PROVISIONAL_RULE_ACKNOWLEDGED","RECONFIGURATION_RULE_ACKNOWLEDGED","REAL_HOUR_2015","IMPRECISE_HOUR","FALSE_HOUR_MAINTAINED","PRACTICAL_REQUEST_ACKNOWLEDGED","BOXES_ACTIVE","BOXES_REFUSED"]:return false
	if day!="J21":return morning=="UNESTABLISHED" and contradiction=="" and options.is_empty() and posture=="UNESTABLISHED" and not restored_knowledge.has("fact_final_posture") and not restored_knowledge.has("fact_existing_contradiction_maintained") and not restored_promises.has("marie_player_boxes_wednesday_1830")
	var expected_options:Array=["RULE_ACTED","LOSS_ACKNOWLEDGED"]
	if contradiction!="":expected_options.append("EXISTING_CONTRADICTION_MAINTAINED")
	if options!=expected_options:return false
	if contradiction!=_existing_contradiction_from_snapshot(value):return false
	if posture=="EXISTING_CONTRADICTION_MAINTAINED" and contradiction=="":return false
	if (posture!="UNESTABLISHED")!=restored_knowledge.has("fact_final_posture"):return false
	if restored_knowledge.has("fact_existing_contradiction_maintained")!=(posture=="EXISTING_CONTRADICTION_MAINTAINED"):return false
	var boxes:Dictionary=restored_promises.get("marie_player_boxes_wednesday_1830",{})
	if morning in ["BOXES_ACTIVE","BOXES_REFUSED"]:
		if boxes.is_empty() or str(boxes.get("status",""))!=("ACTIVE" if morning=="BOXES_ACTIVE" else "REFUSED"):return false
	elif not boxes.is_empty():return false
	if str(value.get("day_status",""))=="COMPLETE":return morning!="UNESTABLISHED" and posture!="UNESTABLISHED"
	return true
func _existing_contradiction_from_snapshot(value:Dictionary)->String:
	if str(value.get("couple_state",""))=="DOUBLE_LIFE_FRAGILE":return "COUPLE_DOUBLE_LIFE"
	if str(value.get("j19_pauline_outcome",""))=="COMPARTMENT_PROTECTED":return "PAULINE_COMPARTMENT"
	return ""
