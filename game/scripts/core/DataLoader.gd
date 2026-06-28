extends Node

const INITIAL_STATE_PATH := "res://data/state/initial_state.json"
const CHAPTER_INDEX_PATHS := [
	"res://data/conversations/chapter_01_index.json",
	"res://data/conversations/chapter_02_index.json",
	"res://data/conversations/chapter_03_index.json",
	"res://data/conversations/chapter_04_index.json",
]
const VISUAL_CONTENT_PATHS := [
	"res://data/visual_content/placeholders.json",
	"res://data/visual_content/chapter_04_proofs.json",
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

func _load_index_conversations(index: Dictionary) -> void:
	var day_key := str(index.get("day", index.get("chapter", "?")))
	if not conversations_by_day.has(day_key):
		conversations_by_day[day_key] = []
	for file_path in index.get("conversation_files", []):
		var convo := load_json(str(file_path))
		if convo.is_empty():
			continue
		convo["_source_path"] = str(file_path)
		convo["day"] = index.get("day", index.get("chapter", ""))
		convo["_index_title"] = index.get("title", "")
		var convo_id := str(convo.get("id", file_path))
		conversations_by_id[convo_id] = convo
		conversations_by_day[day_key].append(convo)

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
		labels.append("Jour %s" % str(index.get("day", index.get("chapter", "?"))))
	return labels

func get_conversations_for_day(day_value) -> Array:
	return _group_segmented_conversations(conversations_by_day.get(str(day_value), []))

func get_index_for_day(day_value) -> Dictionary:
	for index in chapter_indexes:
		if str(index.get("day", index.get("chapter", ""))) == str(day_value):
			return index
	return {}

func get_moments_for_day(day_value) -> Array:
	return get_index_for_day(day_value).get("moment_flow", [])

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
