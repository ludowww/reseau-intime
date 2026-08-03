extends Node

signal timeline_changed

var completed_day_keys: Dictionary = {}


func reset_timeline() -> void:
	completed_day_keys.clear()
	timeline_changed.emit()


func mark_day_complete(day_value) -> void:
	var key := str(day_value)
	if key == "":
		return
	completed_day_keys[key] = true
	timeline_changed.emit()


func is_day_completed(day_value) -> bool:
	return bool(completed_day_keys.get(str(day_value), false))
