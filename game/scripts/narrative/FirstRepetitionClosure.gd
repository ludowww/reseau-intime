extends RefCounted

const MATHILDE_SCENE_ID := "mathilde_morning_kitchen_afterglow_01"
const SANDRA_SCENE_ID := "sandra_end_of_shift_twenty_minutes_01"

const TERMINAL_OBLIGATION_STATUSES := ["PAID", "FAILED"]
const TERMINAL_SCENE_STATUSES := ["RESOLVED", "EXPIRED", "DEFERRED"]
const SUPPORTED_SCENE_CHARACTERS := {
	MATHILDE_SCENE_ID: "mathilde",
	SANDRA_SCENE_ID: "sandra",
}

const MARIE_FINAL_PAIRS := [
	["marie_monday_return_active", "marie_monday_return_realized"],
	["marie_monday_return_bounded", "marie_monday_bounded_time_paid"],
	["marie_monday_return_honest_distance", "marie_monday_evening_separate"],
]

static func evaluate(flags: Array, ledger: Dictionary) -> Dictionary:
	var blocking_reasons: Array[String] = []
	_require_flag(flags, "first_repetition_slice_01_complete", blocking_reasons)
	_require_flag(flags, "first_repetition_slice_02_complete", blocking_reasons)
	_validate_marie_anchor(flags, blocking_reasons)
	_validate_obligations(ledger, blocking_reasons)
	_validate_candidate_lifecycle(ledger, blocking_reasons)
	var foregrounds := _validate_foregrounds(ledger, blocking_reasons)
	_validate_charged_owner(ledger, foregrounds.get("characters", []), blocking_reasons)
	return {
		"closable": blocking_reasons.is_empty(),
		"blocking_reasons": blocking_reasons,
	}

static func _require_flag(flags: Array, flag_id: String, blocking_reasons: Array[String]) -> void:
	if not flags.has(flag_id):
		blocking_reasons.append("missing flag: %s" % flag_id)

static func _validate_marie_anchor(flags: Array, blocking_reasons: Array[String]) -> void:
	for pair in MARIE_FINAL_PAIRS:
		if flags.has(pair[0]) and flags.has(pair[1]):
			return
	blocking_reasons.append("Monday Marie return is not completed and resolved")

static func _validate_obligations(ledger: Dictionary, blocking_reasons: Array[String]) -> void:
	var raw_obligations = ledger.get("obligations", {})
	if typeof(raw_obligations) != TYPE_DICTIONARY:
		blocking_reasons.append("obligations is not a dictionary")
		return
	var obligations: Dictionary = raw_obligations
	for raw_id in obligations.keys():
		var obligation_id := str(raw_id)
		var raw_entry = obligations[raw_id]
		if typeof(raw_entry) != TYPE_DICTIONARY:
			blocking_reasons.append("malformed obligation: %s" % obligation_id)
			continue
		var status := str(raw_entry.get("status", ""))
		if status not in TERMINAL_OBLIGATION_STATUSES:
			blocking_reasons.append("non-terminal obligation %s: %s" % [obligation_id, status])

static func _validate_candidate_lifecycle(ledger: Dictionary, blocking_reasons: Array[String]) -> void:
	var raw_statuses = ledger.get("scene_status", {})
	if typeof(raw_statuses) != TYPE_DICTIONARY:
		blocking_reasons.append("scene_status is not a dictionary")
		return
	var statuses: Dictionary = raw_statuses
	for scene_id in [MATHILDE_SCENE_ID, SANDRA_SCENE_ID]:
		if not statuses.has(scene_id):
			continue
		var status := str(statuses.get(scene_id, ""))
		if status not in TERMINAL_SCENE_STATUSES:
			blocking_reasons.append("non-terminal scene %s: %s" % [scene_id, status])

static func _validate_foregrounds(ledger: Dictionary, blocking_reasons: Array[String]) -> Dictionary:
	var scenes := _string_array(ledger.get("external_foreground_scene_ids", []), "external_foreground_scene_ids", blocking_reasons)
	var characters := _string_array(ledger.get("external_foreground_character_ids", []), "external_foreground_character_ids", blocking_reasons)
	if scenes.size() > 2:
		blocking_reasons.append("external foreground scene limit exceeded")
	if characters.size() > 2:
		blocking_reasons.append("external foreground character limit exceeded")
	if scenes.size() != characters.size():
		blocking_reasons.append("external foreground arrays have different sizes")
	if _has_duplicates(scenes):
		blocking_reasons.append("duplicate external foreground scene")
	if _has_duplicates(characters):
		blocking_reasons.append("duplicate external foreground character")
	for index in range(mini(scenes.size(), characters.size())):
		var scene_id := str(scenes[index])
		var character_id := str(characters[index])
		if not SUPPORTED_SCENE_CHARACTERS.has(scene_id):
			blocking_reasons.append("unsupported external foreground scene: %s" % scene_id)
			continue
		if str(SUPPORTED_SCENE_CHARACTERS[scene_id]) != character_id:
			blocking_reasons.append("foreground scene/character mismatch: %s / %s" % [scene_id, character_id])
	return {"scenes": scenes, "characters": characters}

static func _validate_charged_owner(ledger: Dictionary, foreground_characters: Array, blocking_reasons: Array[String]) -> void:
	var owner := str(ledger.get("charged_access_owner", ""))
	if owner == "":
		return
	if owner != "mathilde":
		blocking_reasons.append("unsupported charged access owner: %s" % owner)
		return
	if not foreground_characters.has(owner):
		blocking_reasons.append("charged access owner is not an external foreground")

static func _string_array(raw_value, field_name: String, blocking_reasons: Array[String]) -> Array:
	if typeof(raw_value) != TYPE_ARRAY:
		blocking_reasons.append("%s is not an array" % field_name)
		return []
	var values: Array = []
	for raw_entry in raw_value:
		var value := str(raw_entry)
		if value == "":
			blocking_reasons.append("%s contains an empty value" % field_name)
		values.append(value)
	return values

static func _has_duplicates(values: Array) -> bool:
	var seen: Dictionary = {}
	for value in values:
		if seen.has(value):
			return true
		seen[value] = true
	return false
