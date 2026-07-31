extends RefCounted

class_name J10PivotSelector

const AUTHORED_ORDER := ["SANDRA", "MATHILDE", "RAPHAELLE", "NICO"]

func select(state_snapshot: Dictionary) -> Dictionary:
	var predicates := {
		"SANDRA": _sandra_predicate(state_snapshot),
		"MATHILDE": _mathilde_predicate(state_snapshot),
		"RAPHAELLE": _raphaelle_predicate(state_snapshot),
		"NICO": _nico_predicate(state_snapshot),
	}
	var p07: Dictionary = state_snapshot.get("promises", {}).get("nico_j07_thursday_conditional", {})
	if str(p07.get("status", "")) == "ACTIVE" and str(p07.get("due_at", "")) == "J10 18:20":
		return _result("NICO", "DUE_PROMISE_P07", predicates)
	if str(state_snapshot.get("marie_j09_dinner_outcome", "")) == "NOT_OFFERED":
		return _result("NONE", "MARIE_CONSEQUENCE_PRIORITY", predicates)
	var eligible: Array[String] = []
	for pivot in AUTHORED_ORDER:
		if bool(predicates[pivot].get("eligible", false)):
			eligible.append(pivot)
	if eligible.is_empty():
		var access_closed := false
		for pivot in AUTHORED_ORDER:
			if bool(predicates[pivot].get("base_eligible", false)) and not bool(predicates[pivot].get("access_open", false)):
				access_closed = true
				break
		return _result("NONE", "ALL_ACCESS_CLOSED" if access_closed else "NO_ELIGIBLE_PIVOT", predicates)
	var least_recent_index := 2147483647
	var least_recent: Array[String] = []
	for pivot in eligible:
		var last_index := _last_foreground_index(state_snapshot.get("foreground_history", []), pivot)
		if last_index < least_recent_index:
			least_recent_index = last_index
			least_recent = [pivot]
		elif last_index == least_recent_index:
			least_recent.append(pivot)
	var selected := ""
	for authored_pivot in AUTHORED_ORDER:
		if authored_pivot in least_recent:
			selected = authored_pivot
			break
	return _result(selected, "AUTHORED_ORDER" if least_recent.size() > 1 else "LEAST_RECENT_FOREGROUND", predicates)

func _sandra_predicate(value: Dictionary) -> Dictionary:
	var base_eligible := (
		str(value.get("sandra_state", "")) == "RECONNECTION_OPEN"
		and str(value.get("sandra_j03_echo_outcome", "")) == "RESPONDED"
		and str(value.get("sandra_j05_outcome", "")) in ["THREAD_MAINTAINED", "GAP_ACKNOWLEDGED", "BOUNDARY_RESPECTED"]
	)
	var access_open := _trace_accessible(value, "j01_sandra_lunch_memory_soft", ["ACTIVE", "RESTRICTED"]) and _knowledge_accessible(value, "fact_player_saw_sandra_lunch_photo")
	return {"eligible": base_eligible and access_open, "base_eligible": base_eligible, "access_open": access_open}

func _mathilde_predicate(value: Dictionary) -> Dictionary:
	var stay: Dictionary = value.get("knowledge", {}).get("fact_mathilde_stay_started", {})
	var household_real: bool = (
		not stay.is_empty()
		and _trace_accessible(value, "j02_mathilde_arrival_room_01", ["ACTIVE"])
		and ("Player" in stay.get("current_knowers", stay.get("initial_knowers", [])))
	)
	var base_eligible: bool = (
		str(value.get("mathilde_state", "")) == "LOOK_ACKNOWLEDGED"
		and str(value.get("mathilde_j06_outcome", "")) in ["ACKNOWLEDGED_RESPECTFUL", "ACKNOWLEDGED_PLAYFUL"]
		and str(value.get("j06_external_continuity_resolution", "")) == "NO_PROMISE"
		and household_real
	)
	var access_open := _trace_accessible(value, "j06_mathilde_look_acknowledged_01", ["ACTIVE"]) and _knowledge_accessible(value, "fact_mathilde_knows_player_noticed_her")
	return {"eligible": base_eligible and access_open, "base_eligible": base_eligible, "access_open": access_open}

func _raphaelle_predicate(value: Dictionary) -> Dictionary:
	var p05: Dictionary = value.get("promises", {}).get("raphaelle_j07_mobile_review", {})
	var base_eligible := (
		str(value.get("raphaelle_state", "")) == "PROFESSIONAL_ONLY"
		and str(value.get("raphaelle_j07_mobile_review_outcome", "")) == "RESPONSIBILITY_ACKNOWLEDGED"
		and str(value.get("raphaelle_j08_work_resolution", "")) in ["PAID_ON_TIME", "PAID_LATE", "TRANSFERRED_HONESTLY"]
		and str(p05.get("status", "")) == "PAID"
	)
	var access_open := _knowledge_accessible(value, "fact_raphaelle_professional_relationship_exists")
	return {"eligible": base_eligible and access_open, "base_eligible": base_eligible, "access_open": access_open}

func _nico_predicate(value: Dictionary) -> Dictionary:
	var promises: Dictionary = value.get("promises", {})
	var p06: Dictionary = promises.get("nico_j07_tuesday_1845", {})
	var p07: Dictionary = promises.get("nico_j07_thursday_conditional", {})
	var continuation_open := (
		(str(p07.get("status", "")) == "ACTIVE" and str(p07.get("due_at", "")) == "J10 18:20")
		or (str(p06.get("status", "")) == "PAID" and str(value.get("nico_j08_meeting_resolution", "")) == "PAID_SHORT")
	)
	var base_eligible := str(value.get("nico_state", "")) == "CONFIDENCE_ACTIVE" and continuation_open
	var access_open := _trace_accessible(value, "j07_nico_confidence_01", ["ACTIVE", "RESTRICTED"]) and _knowledge_accessible(value, "fact_nico_received_player_confidence")
	return {"eligible": base_eligible and access_open, "base_eligible": base_eligible, "access_open": access_open}

func _trace_accessible(value: Dictionary, trace_id: String, allowed_states: Array) -> bool:
	var trace: Dictionary = value.get("traces", {}).get(trace_id, {})
	if trace.is_empty() or str(trace.get("current_state", "")) not in allowed_states:
		return false
	var audience: Array = trace.get("current_audience", trace.get("initial_audience", []))
	return audience.is_empty() or "Player" in audience

func _knowledge_accessible(value: Dictionary, fact_id: String) -> bool:
	var fact: Dictionary = value.get("knowledge", {}).get(fact_id, {})
	if fact.is_empty():
		return false
	var knowers: Array = fact.get("current_knowers", fact.get("initial_knowers", []))
	return knowers.is_empty() or "Player" in knowers

func _last_foreground_index(history: Array, pivot: String) -> int:
	var character_id := pivot.to_lower()
	for index in range(history.size() - 1, -1, -1):
		var record: Dictionary = history[index]
		if str(record.get("character_id", "")).to_lower() == character_id and str(record.get("function", "foreground")) in ["foreground", "pivot"]:
			return index
	return -1

func _result(pivot: String, reason: String, predicates: Dictionary) -> Dictionary:
	return {"pivot": pivot, "reason": reason, "predicates": predicates.duplicate(true)}
