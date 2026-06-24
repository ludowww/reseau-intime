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
	var entries: Array = []
	for conversation in conversations_by_day.get(str(day_value), []):
		var segments: Array = conversation.get("segments", [])
		if segments.is_empty():
			entries.append(conversation)
			continue
		for index in range(segments.size()):
			var segment: Dictionary = segments[index].duplicate(true)
			segment["id"] = "%s__segment_%d" % [conversation.get("id", "conversation"), index + 1]
			segment["title"] = conversation.get("title", conversation.get("id", "Conversation"))
			segment["_parent_conversation_id"] = conversation.get("id", "")
			segment["_source_path"] = conversation.get("_source_path", "")
func get_conversations_for_day(day_value) -> Array:
	return conversations_by_day.get(str(day_value), [])

func get_index_for_day(day_value) -> Dictionary:
	for index in chapter_indexes:
		if str(index.get("day", index.get("chapter", ""))) == str(day_value):
			return index
	return {}

func get_moments_for_day(day_value) -> Array:
	return get_index_for_day(day_value).get("moment_flow", [])

func get_conversations_for_moment(day_value, moment: Dictionary) -> Array:
	var result: Array = []
	for conversation_id in moment.get("conversation_ids", []):
		if conversations_by_id.has(str(conversation_id)):
			var conversation: Dictionary = conversations_by_id[str(conversation_id)].duplicate(true)
			conversation["moment_label"] = moment.get("moment_label", conversation.get("moment_label", ""))
			conversation["time_label"] = moment.get("time_label", conversation.get("time_label", ""))
			conversation["transition_text"] = moment.get("transition_text", conversation.get("transition_text", ""))
			result.append(conversation)
	if result.is_empty():
		return get_conversations_for_day(day_value)
	return result

func get_visual_content(content_id: String) -> Dictionary:
	return visual_content_by_id.get(content_id, {})
