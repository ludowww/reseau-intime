extends "res://scripts/ui/ConversationViewV081.gd"

# V0.82 appends unseen episodes from later days into an existing contact state.
# This preserves one continuous contact history without duplicating previous-day
# files inside every new day index.
func _merge_updated_conversation(conversation: Dictionary) -> void:
	var stored: Dictionary = active_state.get("conversation", {})
	if stored.is_empty():
		active_state["conversation"] = conversation.duplicate(true)
		return
	var merged: Dictionary = stored.duplicate(true)
	var merged_segments: Array = merged.get("segments", []).duplicate(true)
	var known_segments: Dictionary = {}
	for segment in merged_segments:
		if typeof(segment) == TYPE_DICTIONARY:
			known_segments[_segment_merge_key(segment)] = true
	for segment in conversation.get("segments", []):
		if typeof(segment) != TYPE_DICTIONARY:
			continue
		var key := _segment_merge_key(segment)
		if known_segments.has(key):
			continue
		merged_segments.append(segment.duplicate(true))
		known_segments[key] = true
	merged["segments"] = merged_segments
	merged["_segment_count"] = merged_segments.size()
	var episode_ids: Array = merged.get("_episode_ids", []).duplicate()
	for episode_id in conversation.get("_episode_ids", []):
		if not episode_ids.has(episode_id):
			episode_ids.append(episode_id)
	merged["_episode_ids"] = episode_ids
	for metadata_key in [
		"thread",
		"thread_id",
		"title",
		"app",
		"day",
		"chapter",
		"_index_title",
		"_index_calendar_label",
		"_index_display_label"
	]:
		if conversation.has(metadata_key):
			merged[metadata_key] = conversation[metadata_key]
	active_state["conversation"] = merged

func _segment_merge_key(segment: Dictionary) -> String:
	return "%s::%s" % [
		str(segment.get("_source_conversation_id", "")),
		str(segment.get("id", "")),
	]

func _render_message_with_typing(message: Dictionary, conversation_id: String, token: int) -> void:
	if not _entry_conditions_are_met(message):
		return
	await super._render_message_with_typing(message, conversation_id, token)

func _collect_choices(conversation: Dictionary) -> Array:
	var filtered: Array = []
	for choice in super._collect_choices(conversation):
		if typeof(choice) == TYPE_DICTIONARY and _entry_conditions_are_met(choice):
			filtered.append(choice)
	return filtered

func _show_choices_for_segment(data: Dictionary, show_empty_hint := true, persist_state := true) -> bool:
	var suppress_hint := bool(data.get("suppress_empty_hint", current_conversation.get("suppress_empty_hint", false)))
	return super._show_choices_for_segment(data, show_empty_hint and not suppress_hint, persist_state)

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
