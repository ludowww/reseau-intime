extends Node

signal timeline_changed
signal day_changed(day_value)
signal phase_changed(day_value, phase_id: String)

var unlocked_day_keys: Dictionary = {}
var completed_day_keys: Dictionary = {}
var current_day_key := ""
var current_phase_id_by_day: Dictionary = {}
var completed_phase_ids_by_day: Dictionary = {}
var skipped_phase_ids_by_day: Dictionary = {}
var expired_conversation_ids_by_day: Dictionary = {}
var completed_episode_ids_by_day: Dictionary = {}
var opened_optional_conversation_ids_by_day: Dictionary = {}
var day_log_entries_by_day: Dictionary = {}

func reset_timeline() -> void:
	unlocked_day_keys.clear()
	completed_day_keys.clear()
	current_day_key = ""
	current_phase_id_by_day.clear()
	completed_phase_ids_by_day.clear()
	skipped_phase_ids_by_day.clear()
	expired_conversation_ids_by_day.clear()
	completed_episode_ids_by_day.clear()
	opened_optional_conversation_ids_by_day.clear()
	day_log_entries_by_day.clear()
	if DataLoader.chapter_indexes.is_empty():
		timeline_changed.emit()
		return
	var first_index: Dictionary = DataLoader.chapter_indexes[0]
	var first_day = first_index.get("day", first_index.get("chapter", 1))
	var first_key := day_key(first_day)
	unlocked_day_keys[first_key] = true
	current_day_key = first_key
	var initial_phase := DataLoader.get_timeline_initial_phase_id(first_day)
	if initial_phase != "":
		current_phase_id_by_day[first_key] = initial_phase
	timeline_changed.emit()
	day_changed.emit(first_day)
	if initial_phase != "":
		phase_changed.emit(first_day, initial_phase)

func ensure_initialized() -> void:
	if current_day_key == "":
		reset_timeline()

func day_key(day_value) -> String:
	if day_value == null:
		return ""
	var value_type := typeof(day_value)
	if value_type == TYPE_INT or value_type == TYPE_FLOAT:
		return str(int(day_value))
	var text := str(day_value)
	if text.is_valid_float():
		return str(int(float(text)))
	return text

func is_day_unlocked(day_value) -> bool:
	return bool(unlocked_day_keys.get(day_key(day_value), false))

func is_day_completed(day_value) -> bool:
	return bool(completed_day_keys.get(day_key(day_value), false))

func is_day_archived(day_value) -> bool:
	var key := day_key(day_value)
	return bool(completed_day_keys.get(key, false)) and key != current_day_key

func is_current_day(day_value) -> bool:
	return day_key(day_value) == current_day_key

func unlock_day(day_value) -> void:
	var key := day_key(day_value)
	if key == "":
		return
	unlocked_day_keys[key] = true
	timeline_changed.emit()

func set_current_day(day_value) -> void:
	var key := day_key(day_value)
	if key == "":
		return
	unlocked_day_keys[key] = true
	current_day_key = key
	var initial_phase := DataLoader.get_timeline_initial_phase_id(day_value)
	if initial_phase != "" and str(current_phase_id_by_day.get(key, "")) == "":
		current_phase_id_by_day[key] = initial_phase
	timeline_changed.emit()
	day_changed.emit(day_value)
	if str(current_phase_id_by_day.get(key, "")) != "":
		phase_changed.emit(day_value, str(current_phase_id_by_day[key]))

func mark_day_complete(day_value) -> void:
	var key := day_key(day_value)
	if key == "":
		return
	completed_day_keys[key] = true
	timeline_changed.emit()

func current_phase_id(day_value) -> String:
	return str(current_phase_id_by_day.get(day_key(day_value), ""))

func set_current_phase(day_value, phase_id: String) -> void:
	var key := day_key(day_value)
	if key == "" or phase_id == "":
		return
	current_phase_id_by_day[key] = phase_id
	timeline_changed.emit()
	phase_changed.emit(day_value, phase_id)

func complete_phase(day_value, phase_id: String) -> void:
	var bucket := _bucket(completed_phase_ids_by_day, day_value)
	bucket[phase_id] = true
	completed_phase_ids_by_day[day_key(day_value)] = bucket
	timeline_changed.emit()

func skip_phase(day_value, phase_id: String) -> void:
	var bucket := _bucket(skipped_phase_ids_by_day, day_value)
	bucket[phase_id] = true
	skipped_phase_ids_by_day[day_key(day_value)] = bucket
	timeline_changed.emit()

func is_phase_complete(day_value, phase_id: String) -> bool:
	return bool(_bucket(completed_phase_ids_by_day, day_value).get(phase_id, false))

func is_phase_skipped(day_value, phase_id: String) -> bool:
	return bool(_bucket(skipped_phase_ids_by_day, day_value).get(phase_id, false))

func record_episode_completed(day_value, episode_id: String) -> void:
	if episode_id == "":
		return
	var bucket := _bucket(completed_episode_ids_by_day, day_value)
	bucket[episode_id] = true
	completed_episode_ids_by_day[day_key(day_value)] = bucket
	timeline_changed.emit()

func is_episode_completed(day_value, episode_id: String) -> bool:
	return bool(_bucket(completed_episode_ids_by_day, day_value).get(episode_id, false))

func mark_optional_opened(day_value, conversation_id: String) -> void:
	if conversation_id == "":
		return
	var bucket := _bucket(opened_optional_conversation_ids_by_day, day_value)
	bucket[conversation_id] = true
	opened_optional_conversation_ids_by_day[day_key(day_value)] = bucket
	timeline_changed.emit()

func is_optional_opened(day_value, conversation_id: String) -> bool:
	return bool(_bucket(opened_optional_conversation_ids_by_day, day_value).get(conversation_id, false))

func expire_conversation(day_value, conversation_id: String) -> void:
	if conversation_id == "":
		return
	var bucket := _bucket(expired_conversation_ids_by_day, day_value)
	bucket[conversation_id] = true
	expired_conversation_ids_by_day[day_key(day_value)] = bucket
	timeline_changed.emit()

func is_conversation_expired(day_value, conversation_id: String) -> bool:
	return bool(_bucket(expired_conversation_ids_by_day, day_value).get(conversation_id, false))

func record_day_log_entry(day_value, entry: Dictionary) -> void:
	var entry_id := str(entry.get("id", ""))
	if entry_id == "":
		return
	var key := day_key(day_value)
	var raw_entries = day_log_entries_by_day.get(key, [])
	var entries: Array = raw_entries if typeof(raw_entries) == TYPE_ARRAY else []
	for raw_entry in entries:
		if typeof(raw_entry) == TYPE_DICTIONARY and str(raw_entry.get("id", "")) == entry_id:
			return
	entries.append(entry.duplicate(true))
	day_log_entries_by_day[key] = entries
	timeline_changed.emit()

func get_day_log_entries(day_value) -> Array:
	var raw_entries = day_log_entries_by_day.get(day_key(day_value), [])
	if typeof(raw_entries) != TYPE_ARRAY:
		return []
	return raw_entries.duplicate(true)

func _bucket(source: Dictionary, day_value) -> Dictionary:
	var value = source.get(day_key(day_value), {})
	return value if typeof(value) == TYPE_DICTIONARY else {}
