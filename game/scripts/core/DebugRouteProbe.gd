extends Node

func get_route_debug() -> Dictionary:
	var state := GameState.current_state
	var characters: Dictionary = state.get("characters", {})
	var passive: Dictionary = state.get("passive_signals", {})
	var scores := {
		"marie": int(characters.get("marie", {}).get("trust", 0)) + int(passive.get("marie_attention_score", 0)) - int(passive.get("marie_neglect_score", 0)),
		"mathilde": int(characters.get("mathilde", {}).get("desire", 0)) + int(passive.get("mathilde_attention_score", 0)),
		"sandra": int(characters.get("sandra", {}).get("attachment", 0)) + int(passive.get("sandra_priority_score", 0)),
		"raphaelle": int(characters.get("raphaelle", {}).get("attachment", 0)) + int(passive.get("raphaelle_clarity_score", 0)),
		"pauline": int(characters.get("pauline", {}).get("interest", 0)) + int(passive.get("pauline_risk_score", 0)),
		"nico_marie": int(characters.get("nico", {}).get("desire_for_marie", 0)) + int(passive.get("nico_surveillance_score", 0)),
	}
	var best_route := "none"
	var best_score := -999999
	for route in scores.keys():
		if scores[route] > best_score:
			best_route = route
			best_score = scores[route]
	var threat := "none"
	if scores["nico_marie"] >= 65:
		threat = "nico_marie"
	elif scores["pauline"] >= 35:
		threat = "pauline_social"
	return {"scores": scores, "probable_route": best_route if best_score >= 35 else "undecided", "probable_threat": threat}
