extends Node

signal state_changed

var initial_state: Dictionary = {}
var current_state: Dictionary = {}
var context: Dictionary = {
	"day": null,
	"conversation_id": "",
	"segment_id": "",
	"last_choice": "",
	"last_effects": {},
	"unknown_effects": []
}

func _ready() -> void:
	reset_state()

func reset_state() -> void:
	if DataLoader and DataLoader.initial_state.size() > 0:
		initial_state = DataLoader.initial_state.duplicate(true)
	else:
		initial_state = {}
	current_state = initial_state.duplicate(true)
	context = {
		"day": null,
		"conversation_id": "",
		"segment_id": "",
		"last_choice": "",
		"last_effects": {},
		"unknown_effects": []
	}
	state_changed.emit()

func set_context(day_value, conversation_id: String, segment_id: String = "") -> void:
	context["day"] = day_value
	context["conversation_id"] = conversation_id
	context["segment_id"] = segment_id
	state_changed.emit()

func remember_choice(choice: Dictionary, unknown_effects: Array = []) -> void:
	context["last_choice"] = str(choice.get("id", choice.get("text", "")))
	context["last_effects"] = choice.get("effects", {})
	context["unknown_effects"] = unknown_effects
	state_changed.emit()

func add_unlocked_content(content_id: String) -> void:
	if content_id == "":
		return
	var unlocked: Array = current_state.get("unlocked_content", [])
	if not unlocked.has(content_id):
		unlocked.append(content_id)
		unlocked.sort()
	current_state["unlocked_content"] = unlocked
	state_changed.emit()
