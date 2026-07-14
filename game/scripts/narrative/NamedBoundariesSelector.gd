extends RefCounted

static func select_carryover(first_repetition_ledger: Dictionary, flags: Array) -> Dictionary:
	var blocking_reasons: Array[String] = []
	var owner := str(first_repetition_ledger.get("charged_access_owner", ""))
	if owner == "mathilde":
		blocking_reasons.append("charged_access_owner=mathilde")
		return {
			"selected_character": "mathilde",
			"selected_scene_id": _latest_resolved_scene_for_character(first_repetition_ledger, "mathilde"),
			"blocking_reasons": blocking_reasons,
		}

	var recent := _latest_resolved_foreground(first_repetition_ledger)
	if not recent.is_empty():
		return recent

	var mathilde_scene_id := _latest_resolved_scene_for_character(first_repetition_ledger, "mathilde")
	if mathilde_scene_id != "":
		blocking_reasons.append("scene_status=mathilde:RESOLVED")
		return {
			"selected_character": "mathilde",
			"selected_scene_id": mathilde_scene_id,
			"blocking_reasons": blocking_reasons,
		}

	blocking_reasons.append("no_carryover_source")
	if flags.size() > 0:
		blocking_reasons.append("flags_checked=%d" % flags.size())
	return {
		"selected_character": "none",
		"selected_scene_id": "",
		"blocking_reasons": blocking_reasons,
	}

static func _latest_resolved_foreground(first_repetition_ledger: Dictionary) -> Dictionary:
	var scene_ids: Array = first_repetition_ledger.get("external_foreground_scene_ids", [])
	var character_ids: Array = first_repetition_ledger.get("external_foreground_character_ids", [])
	var count := mini(scene_ids.size(), character_ids.size())
	for index in range(count - 1, -1, -1):
		var scene_id := str(scene_ids[index])
		var character_id := str(character_ids[index])
		if character_id not in ["mathilde", "sandra"]:
			continue
		if str(first_repetition_ledger.get("scene_status", {}).get(scene_id, "")) != "RESOLVED":
			continue
		return {
			"selected_character": character_id,
			"selected_scene_id": scene_id,
			"blocking_reasons": ["foreground_history_resolved=%s" % character_id],
		}
	return {}

static func _latest_resolved_scene_for_character(first_repetition_ledger: Dictionary, character_id: String) -> String:
	if character_id == "":
		return ""
	var scene_status: Dictionary = first_repetition_ledger.get("scene_status", {})
	for raw_scene_id in scene_status.keys():
		var scene_id := str(raw_scene_id)
		if str(scene_status[raw_scene_id]) != "RESOLVED":
			continue
		if character_id == "mathilde" and scene_id.findn("mathilde") != -1:
			return scene_id
		if character_id == "sandra" and scene_id.findn("sandra") != -1:
			return scene_id
	return ""
