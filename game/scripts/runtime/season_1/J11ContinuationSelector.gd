extends RefCounted

class_name J11ContinuationSelector

const CONTINUATIONS := {
	"SANDRA": {
		"CAFE_HELD_CALM_PRESENCE": ["RESPIRATION", "J10_NO_LEGITIMATE_CONTINUATION", "NONE", true],
		"CAFE_HELD_MISSING_NAMED": ["SANDRA", "J10_CONTINUATION", "NORMAL", false],
		"CAFE_HELD_FRIENDSHIP_BOUNDED": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE", "NONE", true],
		"CAFE_SATURDAY_CONDITIONAL": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE", "NONE", true],
		"CAFE_OPPORTUNITY_CLOSED": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE", "NONE", true],
	},
	"MATHILDE": {
		"OUTFIT_PRECISE_NON_APPROPRIATIVE": ["MATHILDE", "J10_CONTINUATION", "PHYSICAL_IF_ALL_GATES", false],
		"OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED": ["MATHILDE", "J10_CONTINUATION", "PHYSICAL_IF_ALL_GATES", false],
		"OUTFIT_PRACTICAL_WEATHER": ["RESPIRATION", "J10_NO_LEGITIMATE_CONTINUATION", "NONE", true],
	},
	"RAPHAELLE": {
		"PROCESS_HELPED_VISIT_BOUNDED": ["RAPHAELLE", "J10_CONTINUATION", "FIRST_KISS_IF_SEQUENCE_PROVEN", false],
		"PROCESS_HELPED_REMOTE": ["RAPHAELLE", "J10_CONTINUATION", "ATTRACTION_ONLY", false],
		"RESULT_ONLY": ["RAPHAELLE", "J10_CONTINUATION", "RESULT_SEND_REQUIRED", false],
		"PROFESSIONAL_BOUNDARY": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE", "NONE", true],
	},
	"NICO": {
		"DIFFERENCE_ACKNOWLEDGED_NO_IMAGE": ["NICO", "J10_CONTINUATION", "NON_ROMANTIC", false],
		"NICO_OBSERVATION_REQUESTED": ["NICO", "J10_CONTINUATION", "NON_ROMANTIC", false],
		"COMPARISON_CLOSED": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE", "NONE", true],
		"THURSDAY_MEETING_CANCELLED": ["RESPIRATION", "J10_LIMIT_CONSEQUENCE", "NONE", true],
	},
	"NONE": {
		"DUE_DINNER_PAID": ["MARIE", "J10_NONE_MARIE_FALLBACK", "ADULT_IF_ALL_GATES", false],
		"DUE_DINNER_FAILED_LATE": ["MARIE", "J10_NONE_MARIE_FALLBACK", "NON_ADULT", false],
		"DUE_DINNER_CANCELLED": ["MARIE", "J10_NONE_MARIE_FALLBACK", "NON_ADULT", false],
		"ORDINARY_MEAL_JOINED": ["MARIE", "J10_NONE_MARIE_FALLBACK", "ADULT_IF_ALL_GATES", false],
		"LATE_RETURN_SEPARATE": ["MARIE", "J10_NONE_MARIE_FALLBACK", "NON_ADULT", false],
		"ABSENCE_ANNOUNCED": ["MARIE", "J10_NONE_MARIE_FALLBACK", "NON_ADULT", false],
	},
}

func select(state_snapshot: Dictionary) -> Dictionary:
	var source_pivot := str(state_snapshot.get("j10_pivot", ""))
	var source_outcome := str(state_snapshot.get("j10_pivot_outcome", ""))
	var by_outcome: Dictionary = CONTINUATIONS.get(source_pivot, {})
	var rule: Array = by_outcome.get(source_outcome, [])
	if rule.size() != 4:
		return {}
	var obligations: Dictionary = state_snapshot.get("obligations", {})
	var blocking_obligation_ids: Array[String] = []
	for obligation_id in obligations:
		if str(obligations[obligation_id].get("status", "")) == "DUE":
			blocking_obligation_ids.append(str(obligation_id))
	blocking_obligation_ids.sort()
	var blocking_promise_ids: Array[String] = []
	var p10: Dictionary = state_snapshot.get("promises", {}).get("marie_j09_dinner_friday_2030", {})
	if str(p10.get("status", "")) == "ACTIVE":
		blocking_promise_ids.append("marie_j09_dinner_friday_2030")
	return {
		"pivot": str(rule[0]),
		"reason": str(rule[1]),
		"normal_eligible": str(rule[0]) != "RESPIRATION",
		"advanced_ceiling": str(rule[2]),
		"closure": bool(rule[3]),
		"blocking_obligation_ids": blocking_obligation_ids,
		"blocking_promise_ids": blocking_promise_ids,
		"evidence": {
			"j10_pivot": source_pivot,
			"j10_pivot_outcome": source_outcome,
		},
	}
