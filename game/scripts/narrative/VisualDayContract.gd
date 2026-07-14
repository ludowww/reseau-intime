extends RefCounted

static func evaluate(contract: Dictionary, unlocked_content: Array, visual_by_id: Dictionary) -> Dictionary:
	var satisfied_slot_ids: Array[String] = []
	var missing_slot_ids: Array[String] = []
	var counted_content_ids: Array[String] = []
	var blocking_reasons: Array[String] = []
	var seen_counted: Dictionary = {}

	var minimum_unlocks := int(contract.get("minimum_unlocks", 0))
	var slots = contract.get("slots", [])
	if typeof(slots) != TYPE_ARRAY:
		slots = []
		blocking_reasons.append("daily_visual_contract.slots is not an array")

	for raw_slot in slots:
		if typeof(raw_slot) != TYPE_DICTIONARY:
			blocking_reasons.append("daily_visual_contract contains a non-dictionary slot")
			continue
		var slot: Dictionary = raw_slot
		var slot_id := str(slot.get("id", ""))
		if slot_id == "":
			slot_id = "unnamed_slot_%d" % (satisfied_slot_ids.size() + missing_slot_ids.size() + 1)
		var candidates = slot.get("any_content_ids", [])
		if typeof(candidates) != TYPE_ARRAY or candidates.is_empty():
			missing_slot_ids.append(slot_id)
			blocking_reasons.append("%s has no candidate content IDs" % slot_id)
			continue

		var valid_candidates: Array[String] = []
		for raw_content_id in candidates:
			var content_id := str(raw_content_id)
			if content_id == "":
				continue
			if not visual_by_id.has(content_id):
				blocking_reasons.append("%s references unknown content %s" % [slot_id, content_id])
				continue
			var item = visual_by_id.get(content_id, {})
			if typeof(item) != TYPE_DICTIONARY or str(item.get("type", "")) != "photo":
				blocking_reasons.append("%s references non-photo content %s" % [slot_id, content_id])
				continue
			valid_candidates.append(content_id)

		var selected := ""
		for content_id in valid_candidates:
			if unlocked_content.has(content_id) and not bool(seen_counted.get(content_id, false)):
				selected = content_id
				break
		if selected == "":
			missing_slot_ids.append(slot_id)
			continue
		seen_counted[selected] = true
		counted_content_ids.append(selected)
		satisfied_slot_ids.append(slot_id)

	if satisfied_slot_ids.size() < minimum_unlocks:
		blocking_reasons.append(
			"visual minimum not met: %d/%d slots" % [satisfied_slot_ids.size(), minimum_unlocks]
		)

	return {
		"satisfied": blocking_reasons.is_empty() and satisfied_slot_ids.size() >= minimum_unlocks,
		"satisfied_slot_ids": satisfied_slot_ids,
		"missing_slot_ids": missing_slot_ids,
		"counted_content_ids": counted_content_ids,
		"blocking_reasons": blocking_reasons,
	}
