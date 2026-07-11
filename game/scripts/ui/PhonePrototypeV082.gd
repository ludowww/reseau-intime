extends "res://scripts/ui/PhonePrototypeV081.gd"

# V0.82 keeps the V0.81 time/thread foundation and adds only the conditions
# required by the Thursday O3-O6 topology.
func _unlock_conversations_after_completion(day_value, completed_conversation_id: String) -> void:
	var availability := _conversation_availability_for_day(day_value)
	var unlocks: Dictionary = availability.get("progression", availability.get("unlocks", {}))
	for target_id in unlocks.keys():
		var raw_rule = unlocks[target_id]
		if typeof(raw_rule) != TYPE_DICTIONARY:
			continue
		var rule: Dictionary = raw_rule
		if not _rule_completion_matches(rule, completed_conversation_id):
			continue
		if not _conditions_are_met(rule.get("conditions", [])):
			continue
		if _unlock_conversation(day_value, str(target_id)):
			var thread_id := _thread_id_for_conversation_id(day_value, str(target_id))
			pending_thread_ids[thread_id] = true
			pending_conversation_ids[thread_id] = true
			if bool(rule.get("notify", true)):
				var notification: Dictionary = rule.get("notification", {})
				_show_conversation_notification(
					day_value,
					thread_id,
					str(notification.get("title", target_id)),
					str(notification.get("body", "Nouveau message de %s" % target_id))
				)
	if current_day_value != null and str(current_day_value) == str(day_value):
		_render_conversations(day_value)

func _rule_completion_matches(rule: Dictionary, completed_conversation_id: String) -> bool:
	var expected := str(rule.get("after_conversation_completed", ""))
	if expected != "":
		return expected == completed_conversation_id
	for candidate in rule.get("after_any_conversation_completed", []):
		if str(candidate) == completed_conversation_id:
			return true
	return false

func _conditions_are_met(raw_conditions) -> bool:
	if raw_conditions == null:
		return true
	var conditions: Array = []
	if typeof(raw_conditions) == TYPE_ARRAY:
		conditions = raw_conditions
	else:
		conditions.append(raw_conditions)
	for condition in conditions:
		if not EffectApplier.condition_is_met(condition):
			return false
	return true

func _entry_conditions_are_met(entry: Dictionary) -> bool:
	if not _conditions_are_met(entry.get("conditions", [])):
		return false
	var exclusions: Array = []
	var raw_exclusions = entry.get("unless_conditions", [])
	if typeof(raw_exclusions) == TYPE_ARRAY:
		exclusions = raw_exclusions
	else:
		exclusions.append(raw_exclusions)
	for condition in exclusions:
		if condition != null and str(condition).strip_edges() != "" and EffectApplier.condition_is_met(condition):
			return false
	return true

func _collect_messages(conversation: Dictionary) -> Array:
	var filtered: Array = []
	for message in super._collect_messages(conversation):
		if typeof(message) == TYPE_DICTIONARY and _entry_conditions_are_met(message):
			filtered.append(message)
	return filtered

func _collect_choices(conversation: Dictionary) -> Array:
	var filtered: Array = []
	for choice in super._collect_choices(conversation):
		if typeof(choice) == TYPE_DICTIONARY and _entry_conditions_are_met(choice):
			filtered.append(choice)
	return filtered
