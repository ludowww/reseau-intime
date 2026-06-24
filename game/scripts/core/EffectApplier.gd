extends Node

func apply_choice(choice: Dictionary) -> Array:
	var unknown_effects := apply_effects(choice.get("effects", {}))
	apply_flags(choice.get("sets_flags", []))
	for content_id in choice.get("unlocks_content", []):
		GameState.add_unlocked_content(str(content_id))
	GameState.remember_choice(choice, unknown_effects)
	return unknown_effects

func apply_effects(effects: Dictionary) -> Array:
	var unknown_effects: Array = []
	for raw_key in effects.keys():
		var key := str(raw_key)
		var delta = effects[raw_key]
		if typeof(delta) != TYPE_INT and typeof(delta) != TYPE_FLOAT:
			unknown_effects.append("%s = non numeric" % key)
			continue
		if not _apply_single_effect(key, delta):
			unknown_effects.append(key)
	GameState.context["unknown_effects"] = unknown_effects
	GameState.state_changed.emit()
	return unknown_effects

func _apply_single_effect(key: String, delta) -> bool:
	var state := GameState.current_state
	if key.contains("."):
		var parts := key.split(".", false, 1)
		if parts.size() == 2 and state.has("characters"):
			var characters: Dictionary = state["characters"]
			var character_id := parts[0]
			var stat := parts[1]
			if characters.has(character_id) and characters[character_id].has(stat):
				characters[character_id][stat] += delta
				return true
	if state.has("global") and state["global"].has(key):
		state["global"][key] += delta
		return true
	if state.has("passive_signals") and state["passive_signals"].has(key):
		state["passive_signals"][key] += delta
		return true
	push_warning("Unknown narrative effect: %s" % key)
	return false

func apply_flags(flags: Array) -> void:
	var active_flags: Array = GameState.current_state.get("flags", [])
	for flag in flags:
		var flag_id := str(flag)
		if flag_id != "" and not active_flags.has(flag_id):
			active_flags.append(flag_id)
	active_flags.sort()
	GameState.current_state["flags"] = active_flags
	GameState.state_changed.emit()

func condition_is_met(condition) -> bool:
	if condition == null or str(condition).strip_edges() == "":
		return true
	var text := str(condition).strip_edges()
	if text.contains(" OR "):
		for part in text.split(" OR "):
			if condition_is_met(part):
				return true
		return false
	for op in [">=", "<=", ">", "<", "=="]:
		if text.contains(op):
			return _compare_condition(text, op)
	return GameState.current_state.get("flags", []).has(text)

func _compare_condition(text: String, op: String) -> bool:
	var parts := text.split(op, false, 1)
	if parts.size() != 2:
		return false
	var current = _read_value(parts[0].strip_edges())
	var expected := float(parts[1].strip_edges())
	match op:
		">=": return current >= expected
		"<=": return current <= expected
		">": return current > expected
		"<": return current < expected
		"==": return current == expected
	return false

func _read_value(key: String) -> float:
	var state := GameState.current_state
	if key.contains("."):
		var parts := key.split(".", false, 1)
		return float(state.get("characters", {}).get(parts[0], {}).get(parts[1], 0))
	if state.get("global", {}).has(key):
		return float(state["global"][key])
	return float(state.get("passive_signals", {}).get(key, 0))
