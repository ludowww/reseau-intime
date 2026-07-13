extends RefCounted

static func select_candidate(
	candidate_pool: Dictionary,
	flags: Array,
	ledger: Dictionary,
	day_value,
	phase_id: String = ""
) -> Dictionary:
	if _has_due_obligation(ledger):
		return {}

	var external_limit := int(candidate_pool.get("external_ticket_limit", 2))
	var foreground_scenes: Array = ledger.get("external_foreground_scene_ids", [])
	if foreground_scenes.size() >= external_limit:
		return {}

	var foreground_characters: Array = ledger.get("external_foreground_character_ids", [])
	var scene_status: Dictionary = ledger.get("scene_status", {})
	var cooldown_until: Dictionary = ledger.get("cooldown_until_ordinal", {})
	var ordinal := int(ledger.get("opportunity_window_ordinal", 0))

	for raw_candidate in candidate_pool.get("ordered_candidates", []):
		if typeof(raw_candidate) != TYPE_DICTIONARY:
			continue
		var candidate: Dictionary = raw_candidate
		var scene_id := str(candidate.get("scene_id", ""))
		var conversation_id := str(candidate.get("conversation_id", ""))
		var character_id := str(candidate.get("character_id", ""))
		if scene_id == "" or conversation_id == "" or character_id == "":
			continue
		if foreground_characters.has(character_id):
			continue
		if not _all_flags_present(candidate.get("requires_all_flags", []), flags):
			continue
		if _any_flag_present(candidate.get("excludes_any_flags", []), flags):
			continue
		var status := str(scene_status.get(scene_id, "DORMANT"))
		if status in ["OFFERED", "SEEN", "DEFERRED", "EXPIRED", "RESOLVED"]:
			continue
		if ordinal < int(cooldown_until.get(scene_id, 0)):
			continue
		if not _day_is_compatible(candidate.get("compatible_days", []), day_value):
			continue
		if not _phase_is_compatible(candidate.get("compatible_phase_ids", []), phase_id):
			continue
		return candidate.duplicate(true)

	return {}

static func _has_due_obligation(ledger: Dictionary) -> bool:
	var obligations = ledger.get("obligations", {})
	if typeof(obligations) != TYPE_DICTIONARY:
		return false
	for raw_entry in obligations.values():
		if typeof(raw_entry) == TYPE_DICTIONARY and str(raw_entry.get("status", "")) == "DUE":
			return true
	return false

static func _all_flags_present(required_flags, flags: Array) -> bool:
	for raw_flag in required_flags:
		if not flags.has(str(raw_flag)):
			return false
	return true

static func _any_flag_present(excluded_flags, flags: Array) -> bool:
	for raw_flag in excluded_flags:
		if flags.has(str(raw_flag)):
			return true
	return false

static func _day_is_compatible(raw_days, day_value) -> bool:
	if typeof(raw_days) != TYPE_ARRAY or raw_days.is_empty():
		return true
	for raw_day in raw_days:
		if str(raw_day) == str(day_value):
			return true
	return false

static func _phase_is_compatible(raw_phase_ids, phase_id: String) -> bool:
	if typeof(raw_phase_ids) != TYPE_ARRAY or raw_phase_ids.is_empty():
		return true
	for raw_phase_id in raw_phase_ids:
		if str(raw_phase_id) == phase_id:
			return true
	return false
