extends Node

const INITIAL_STATE_PATH := "res://data/state/initial_state.json"

# Canonically active runtime slices. Legacy indexes remain listed below for
# rollback/history but are not loaded into the current phone navigation.
const CHAPTER_INDEX_PATHS := [
	"res://data/conversations/chapter_01_modular_index.json",
	"res://data/conversations/chapter_02_modular_index.json",
	"res://data/conversations/chapter_03_modular_index.json",
	"res://data/conversations/chapter_04_modular_index.json",
]
const LEGACY_CHAPTER_INDEX_PATHS := [
	"res://data/conversations/chapter_01_index.json",
	"res://data/conversations/chapter_02_index.json",
	"res://data/conversations/chapter_03_index.json",
	"res://data/conversations/chapter_04_index.json",
	"res://data/conversations/chapter_05_index.json",
	"res://data/conversations/chapter_06_index.json",
	"res://data/conversations/chapter_07_index.json",
	"res://data/conversations/chapter_09_index.json",
]

const VISUAL_CONTENT_PATHS := [
	"res://data/visual_content/placeholders.json",
	"res://data/visual_content/chapter_01_proofs.json",
	"res://data/visual_content/chapter_02_proofs.json",
	"res://data/visual_content/chapter_03_proofs.json",
	"res://data/visual_content/chapter_04_opening_proofs.json",
]
const LEGACY_VISUAL_CONTENT_PATHS := [
	"res://data/visual_content/chapter_04_proofs.json",
	"res://data/visual_content/chapter_05_proofs.json",
	"res://data/visual_content/chapter_06_proofs.json",
	"res://data/visual_content/chapter_07_proofs.json",
	"res://data/visual_content/chapter_09_proofs.json",
]

var initial_state: Dictionary = {}
var chapter_indexes: Array[Dictionary] = []
var conversations_by_id: Dictionary = {}
var conversations_by_day: Dictionary = {}
var visual_content_by_id: Dictionary = {}
var load_errors: Array[String] = []

func _ready() -> void:
	load_all()

func load_all() -> void:
	load_errors.clear()
	initial_state = load_json(INITIAL_STATE_PATH)
	chapter_indexes.clear()
	conversations_by_id.clear()
	conversations_by_day.clear()
	visual_content_by_id.clear()
	for path in CHAPTER_INDEX_PATHS:
		var index := load_json(path)
		if index.is_empty():
			continue
		chapter_indexes.append(index)
		_load_index_conversations(index)
	for path in VISUAL_CONTENT_PATHS:
		_load_visual_content(path)

func load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		load_errors.append("Missing JSON: %s" % path)
		return {}
	var text := FileAccess.get_file_as_string(path)
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		load_errors.append("Invalid JSON object: %s" % path)
		return {}
	return parsed

func _day_key(day_value) -> String:
	if day_value == null:
		return ""
	var value_type := typeof(day_value)
	if value_type == TYPE_INT or value_type == TYPE_FLOAT:
		return str(int(day_value))
	var text := str(day_value)
	if text.is_valid_float():
		return str(int(float(text)))
	return text

func _load_index_conversations(index: Dictionary) -> void:
	var day_key := _day_key(index.get("day", index.get("chapter", "?")))
	if not conversations_by_day.has(day_key):
		conversations_by_day[day_key] = []
	var filters: Dictionary = index.get("conversation_filters", {})
	for file_path in index.get("conversation_files", []):
		var convo := load_json(str(file_path))
		if convo.is_empty():
			continue
		var convo_id := str(convo.get("id", file_path))
		if filters.has(convo_id) and typeof(filters[convo_id]) == TYPE_DICTIONARY:
			convo = _apply_conversation_filter(convo, filters[convo_id])
		convo["_source_path"] = str(file_path)
		convo["day"] = index.get("day", index.get("chapter", ""))
		convo["_index_title"] = index.get("title", "")
		convo["_index_calendar_label"] = index.get("calendar_label", "")
		convo["_index_display_label"] = index.get("display_label", "")
		conversations_by_id[convo_id] = convo
		conversations_by_day[day_key].append(convo)

func _apply_conversation_filter(conversation: Dictionary, filter: Dictionary) -> Dictionary:
	var excluded_ids: Array = filter.get("exclude_item_ids", [])
	var excluded_content_ids: Array = filter.get("exclude_content_ids", [])
	var filtered = _filter_value(conversation, excluded_ids, excluded_content_ids)
	if typeof(filtered) == TYPE_DICTIONARY:
		return filtered
	return conversation

func _filter_value(value, excluded_ids: Array, excluded_content_ids: Array):
	if typeof(value) == TYPE_ARRAY:
		var filtered_array: Array = []
		for child in value:
			if typeof(child) == TYPE_DICTIONARY and _dictionary_is_excluded(child, excluded_ids, excluded_content_ids):
				continue
			filtered_array.append(_filter_value(child, excluded_ids, excluded_content_ids))
		return filtered_array
	if typeof(value) == TYPE_DICTIONARY:
		var filtered_dictionary: Dictionary = {}
		for key in value.keys():
			var child = value[key]
			if str(key) in ["unlocks_content", "initial_visual_anchors"] and typeof(child) == TYPE_ARRAY:
				var filtered_ids: Array = []
				for content_id in child:
					if not excluded_content_ids.has(str(content_id)):
						filtered_ids.append(content_id)
				filtered_dictionary[key] = filtered_ids
			else:
				filtered_dictionary[key] = _filter_value(child, excluded_ids, excluded_content_ids)
		return filtered_dictionary
	return value

func _dictionary_is_excluded(value: Dictionary, excluded_ids: Array, excluded_content_ids: Array) -> bool:
	var item_id := str(value.get("id", ""))
	if item_id != "" and excluded_ids.has(item_id):
		return true
	var content_id := str(value.get("content_id", ""))
	return content_id != "" and excluded_content_ids.has(content_id)

func _load_visual_content(path: String) -> void:
	var bundle := load_json(path)
	for item in bundle.get("items", []):
		if typeof(item) == TYPE_DICTIONARY:
			visual_content_by_id[str(item.get("id", ""))] = item
	for item in bundle.get("proofs", []):
		if typeof(item) == TYPE_DICTIONARY:
			visual_content_by_id[str(item.get("id", ""))] = item

func get_day_labels() -> Array[String]:
	var labels: Array[String] = []
	for index in chapter_indexes:
		var configured_label := str(index.get("display_label", ""))
		if configured_label == "":
			labels.append("Jour %s" % _day_key(index.get("day", index.get("chapter", "?"))))
		else:
			labels.append(configured_label)
	return labels

func get_day_display_label(day_value) -> String:
	var index := get_index_for_day(day_value)
	var configured_label := str(index.get("display_label", ""))
	if configured_label != "":
		return configured_label
	return "Jour %s" % _day_key(day_value)

func get_day_calendar_label(day_value) -> String:
	var index := get_index_for_day(day_value)
	var configured_label := str(index.get("calendar_label", ""))
	if configured_label != "":
		return configured_label
	return "Jour %s" % _day_key(day_value)

func get_day_start_time(day_value) -> String:
	return str(get_index_for_day(day_value).get("day_start_time", "--:--"))

func get_conversations_for_day(day_value) -> Array:
	return _group_segmented_conversations(conversations_by_day.get(_day_key(day_value), []))

func get_index_for_day(day_value) -> Dictionary:
	for index in chapter_indexes:
		if _day_key(index.get("day", index.get("chapter", ""))) == _day_key(day_value):
			return index
	return {}

func get_moments_for_day(day_value) -> Array:
	return get_index_for_day(day_value).get("moment_flow", [])

func get_timeline_flow(day_value) -> Dictionary:
	return get_index_for_day(day_value).get("timeline_flow", {})

func get_timeline_phases(day_value) -> Array:
	return get_timeline_flow(day_value).get("phases", [])

func get_timeline_initial_phase_id(day_value) -> String:
	var flow := get_timeline_flow(day_value)
	var configured := str(flow.get("initial_phase_id", ""))
	if configured != "":
		return configured
	var phases := get_timeline_phases(day_value)
	if not phases.is_empty() and typeof(phases[0]) == TYPE_DICTIONARY:
		return str(phases[0].get("id", ""))
	return ""

func get_timeline_phase(day_value, phase_id: String) -> Dictionary:
	for phase in get_timeline_phases(day_value):
		if typeof(phase) == TYPE_DICTIONARY and str(phase.get("id", "")) == phase_id:
			return phase
	return {}

func get_timeline_phase_for_conversation(day_value, conversation_id: String) -> Dictionary:
	for phase in get_timeline_phases(day_value):
		if typeof(phase) != TYPE_DICTIONARY:
			continue
		if _timeline_phase_conversation_ids(phase).has(conversation_id):
			return phase
	return {}

func get_timeline_next_day(day_value):
	return get_timeline_flow(day_value).get("next_day", null)

func get_timeline_day_start_card(day_value) -> Dictionary:
	return get_timeline_flow(day_value).get("day_start_card", {})

func get_timeline_day_end_card(day_value) -> Dictionary:
	return get_timeline_flow(day_value).get("day_end_card", {})

func _timeline_phase_conversation_ids(phase: Dictionary) -> Array:
	var ids: Array = []
	for key in ["required_conversation_ids", "optional_conversation_ids", "required_any_conversation_ids"]:
		for conversation_id in phase.get(key, []):
			var value := str(conversation_id)
			if value != "" and not ids.has(value):
				ids.append(value)
	return ids

func get_conversations_for_moment(day_value, moment: Dictionary) -> Array:
	var source: Array = []
	for conversation_id in moment.get("conversation_ids", []):
		if conversations_by_id.has(str(conversation_id)):
			var conversation: Dictionary = conversations_by_id[str(conversation_id)].duplicate(true)
			conversation["moment_label"] = moment.get("moment_label", conversation.get("moment_label", ""))
			conversation["time_label"] = moment.get("time_label", conversation.get("time_label", ""))
			conversation["transition_text"] = moment.get("transition_text", conversation.get("transition_text", ""))
			source.append(conversation)
	if source.is_empty():
		return get_conversations_for_day(day_value)
	return _group_segmented_conversations(source)

func _group_segmented_conversations(conversations: Array) -> Array:
	return _group_conversations_by_thread(conversations)

func _group_conversations_by_thread(conversations: Array) -> Array:
	var grouped: Dictionary = {}
	var ordered_keys: Array[String] = []
	for conversation in conversations:
		if typeof(conversation) != TYPE_DICTIONARY:
			continue
		var key := _thread_key(conversation)
		if not grouped.has(key):
			grouped[key] = get_segmented_conversation_entry(conversation)
			ordered_keys.append(key)
		else:
			_merge_episode_into_thread(grouped[key], conversation)
	var entries: Array = []
	for key in ordered_keys:
		entries.append(grouped[key])
	return entries

func get_segmented_conversation_entry(conversation: Dictionary) -> Dictionary:
	var entry: Dictionary = conversation.duplicate(true)
	var conversation_id := str(entry.get("id", ""))
	var thread_id := _thread_key(entry)
	var segments: Array = []
	for segment in entry.get("segments", []):
		if typeof(segment) == TYPE_DICTIONARY:
			var segment_copy: Dictionary = segment.duplicate(true)
			segment_copy["_source_conversation_id"] = conversation_id
			segments.append(segment_copy)
	entry["segments"] = segments
	entry["_episode_ids"] = [conversation_id]
	entry["thread_id"] = thread_id
	entry["_segment_count"] = segments.size()
	entry["_parent_conversation_id"] = thread_id
	entry["id"] = thread_id
	entry["_current_segment_index"] = 0
	entry["_current_segment_id"] = _segment_id(entry, 0)
	return entry

func _merge_episode_into_thread(thread_entry: Dictionary, conversation: Dictionary) -> void:
	var conversation_id := str(conversation.get("id", ""))
	var episode_ids: Array = thread_entry.get("_episode_ids", [])
	if not episode_ids.has(conversation_id):
		episode_ids.append(conversation_id)
	thread_entry["_episode_ids"] = episode_ids
	var segments: Array = thread_entry.get("segments", [])
	for segment in conversation.get("segments", []):
		if typeof(segment) == TYPE_DICTIONARY:
			var segment_copy: Dictionary = segment.duplicate(true)
			segment_copy["_source_conversation_id"] = conversation_id
			segments.append(segment_copy)
	thread_entry["segments"] = segments
	thread_entry["_segment_count"] = segments.size()
	thread_entry["_current_segment_id"] = _segment_id(thread_entry, int(thread_entry.get("_current_segment_index", 0)))

func _thread_key(conversation: Dictionary) -> String:
	if str(conversation.get("thread_id", "")) != "":
		return str(conversation.get("thread_id"))
	var thread = conversation.get("thread", {})
	if typeof(thread) == TYPE_DICTIONARY and str(thread.get("id", "")) != "":
		return str(thread.get("id"))
	return str(conversation.get("id", "conversation"))

func _segment_id(conversation: Dictionary, index: int) -> String:
	var segments: Array = conversation.get("segments", [])
	if index >= 0 and index < segments.size() and typeof(segments[index]) == TYPE_DICTIONARY:
		var source_id := str(segments[index].get("_source_conversation_id", ""))
		if source_id != "":
			return "%s__segment_%d" % [source_id, index + 1]
	return "%s__segment_%d" % [conversation.get("id", "conversation"), index + 1]

func get_visual_content(content_id: String) -> Dictionary:
	return visual_content_by_id.get(content_id, {})
