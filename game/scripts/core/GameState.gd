extends Node

signal state_changed

const FIRST_REPETITION_LEDGER_ID := "first_repetition"

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
	_ensure_story_ledger_internal(FIRST_REPETITION_LEDGER_ID, first_repetition_ledger_defaults())
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

func first_repetition_ledger_defaults() -> Dictionary:
	return {
		"opportunity_window_ordinal": 0,
		"external_foreground_scene_ids": [],
		"external_foreground_character_ids": [],
		"charged_access_owner": "",
		"scene_status": {},
		"cooldown_until_ordinal": {},
		"obligations": {},
	}

func ensure_story_ledger(ledger_id: String, defaults: Dictionary) -> Dictionary:
	var changed := _ensure_story_ledger_internal(ledger_id, defaults)
	if changed:
		state_changed.emit()
	return get_story_ledger(ledger_id)

func get_story_ledger(ledger_id: String) -> Dictionary:
	var raw_ledgers = current_state.get("story_ledgers", {})
	if typeof(raw_ledgers) != TYPE_DICTIONARY:
		return {}
	var raw_ledger = raw_ledgers.get(ledger_id, {})
	if typeof(raw_ledger) != TYPE_DICTIONARY:
		return {}
	return raw_ledger.duplicate(true)

func set_story_ledger_value(ledger_id: String, key: String, value) -> bool:
	var defaults := first_repetition_ledger_defaults() if ledger_id == FIRST_REPETITION_LEDGER_ID else {}
	var changed := _ensure_story_ledger_internal(ledger_id, defaults)
	var ledgers: Dictionary = current_state.get("story_ledgers", {})
	var ledger: Dictionary = ledgers.get(ledger_id, {})
	if ledger.has(key) and ledger[key] == value:
		if changed:
			state_changed.emit()
		return false
	ledger[key] = _duplicate_value(value)
	ledgers[ledger_id] = ledger
	current_state["story_ledgers"] = ledgers
	state_changed.emit()
	return true

func record_external_foreground(ledger_id: String, scene_id: String, character_id: String) -> bool:
	if scene_id == "" or character_id == "":
		return false
	var defaults := first_repetition_ledger_defaults() if ledger_id == FIRST_REPETITION_LEDGER_ID else {}
	var changed := _ensure_story_ledger_internal(ledger_id, defaults)
	var ledgers: Dictionary = current_state.get("story_ledgers", {})
	var ledger: Dictionary = ledgers.get(ledger_id, {})
	var raw_scene_ids = ledger.get("external_foreground_scene_ids", [])
	var raw_character_ids = ledger.get("external_foreground_character_ids", [])
	var scene_ids: Array = raw_scene_ids if typeof(raw_scene_ids) == TYPE_ARRAY else []
	var character_ids: Array = raw_character_ids if typeof(raw_character_ids) == TYPE_ARRAY else []
	if scene_ids.has(scene_id):
		if changed:
			state_changed.emit()
		return true
	if scene_ids.size() >= 2 or character_ids.has(character_id):
		if changed:
			state_changed.emit()
		return false
	scene_ids.append(scene_id)
	character_ids.append(character_id)
	ledger["external_foreground_scene_ids"] = scene_ids
	ledger["external_foreground_character_ids"] = character_ids
	ledgers[ledger_id] = ledger
	current_state["story_ledgers"] = ledgers
	state_changed.emit()
	return true

func claim_charged_access_owner(ledger_id: String, character_id: String) -> bool:
	if character_id == "":
		return false
	var defaults := first_repetition_ledger_defaults() if ledger_id == FIRST_REPETITION_LEDGER_ID else {}
	var changed := _ensure_story_ledger_internal(ledger_id, defaults)
	var ledgers: Dictionary = current_state.get("story_ledgers", {})
	var ledger: Dictionary = ledgers.get(ledger_id, {})
	var owner := str(ledger.get("charged_access_owner", ""))
	if owner == character_id:
		if changed:
			state_changed.emit()
		return true
	if owner != "":
		if changed:
			state_changed.emit()
		return false
	ledger["charged_access_owner"] = character_id
	ledgers[ledger_id] = ledger
	current_state["story_ledgers"] = ledgers
	state_changed.emit()
	return true

func set_scene_status(ledger_id: String, scene_id: String, status: String) -> bool:
	if scene_id == "" or status == "":
		return false
	var defaults := first_repetition_ledger_defaults() if ledger_id == FIRST_REPETITION_LEDGER_ID else {}
	var changed := _ensure_story_ledger_internal(ledger_id, defaults)
	var ledgers: Dictionary = current_state.get("story_ledgers", {})
	var ledger: Dictionary = ledgers.get(ledger_id, {})
	var raw_statuses = ledger.get("scene_status", {})
	var statuses: Dictionary = raw_statuses if typeof(raw_statuses) == TYPE_DICTIONARY else {}
	if str(statuses.get(scene_id, "")) == status:
		if changed:
			state_changed.emit()
		return false
	statuses[scene_id] = status
	ledger["scene_status"] = statuses
	ledgers[ledger_id] = ledger
	current_state["story_ledgers"] = ledgers
	state_changed.emit()
	return true

func set_scene_cooldown(ledger_id: String, scene_id: String, until_ordinal: int) -> bool:
	if scene_id == "":
		return false
	var defaults := first_repetition_ledger_defaults() if ledger_id == FIRST_REPETITION_LEDGER_ID else {}
	var changed := _ensure_story_ledger_internal(ledger_id, defaults)
	var ledgers: Dictionary = current_state.get("story_ledgers", {})
	var ledger: Dictionary = ledgers.get(ledger_id, {})
	var raw_cooldowns = ledger.get("cooldown_until_ordinal", {})
	var cooldowns: Dictionary = raw_cooldowns if typeof(raw_cooldowns) == TYPE_DICTIONARY else {}
	if int(cooldowns.get(scene_id, 0)) == until_ordinal:
		if changed:
			state_changed.emit()
		return false
	cooldowns[scene_id] = until_ordinal
	ledger["cooldown_until_ordinal"] = cooldowns
	ledgers[ledger_id] = ledger
	current_state["story_ledgers"] = ledgers
	state_changed.emit()
	return true

func set_obligation_status(ledger_id: String, obligation_id: String, entry: Dictionary) -> bool:
	if obligation_id == "":
		return false
	var defaults := first_repetition_ledger_defaults() if ledger_id == FIRST_REPETITION_LEDGER_ID else {}
	var changed := _ensure_story_ledger_internal(ledger_id, defaults)
	var ledgers: Dictionary = current_state.get("story_ledgers", {})
	var ledger: Dictionary = ledgers.get(ledger_id, {})
	var raw_obligations = ledger.get("obligations", {})
	var obligations: Dictionary = raw_obligations if typeof(raw_obligations) == TYPE_DICTIONARY else {}
	var next_entry := entry.duplicate(true)
	if obligations.has(obligation_id) and obligations[obligation_id] == next_entry:
		if changed:
			state_changed.emit()
		return false
	obligations[obligation_id] = next_entry
	ledger["obligations"] = obligations
	ledgers[ledger_id] = ledger
	current_state["story_ledgers"] = ledgers
	state_changed.emit()
	return true

func get_obligation_status(ledger_id: String, obligation_id: String) -> Dictionary:
	var ledger := get_story_ledger(ledger_id)
	var raw_obligations = ledger.get("obligations", {})
	if typeof(raw_obligations) != TYPE_DICTIONARY:
		return {}
	var raw_entry = raw_obligations.get(obligation_id, {})
	if typeof(raw_entry) != TYPE_DICTIONARY:
		return {}
	return raw_entry.duplicate(true)

func _ensure_story_ledger_internal(ledger_id: String, defaults: Dictionary) -> bool:
	if ledger_id == "":
		return false
	var changed := false
	var raw_ledgers = current_state.get("story_ledgers", {})
	var ledgers: Dictionary = raw_ledgers if typeof(raw_ledgers) == TYPE_DICTIONARY else {}
	if typeof(raw_ledgers) != TYPE_DICTIONARY:
		changed = true
	var raw_ledger = ledgers.get(ledger_id, {})
	var ledger: Dictionary = raw_ledger if typeof(raw_ledger) == TYPE_DICTIONARY else {}
	if typeof(raw_ledger) != TYPE_DICTIONARY:
		changed = true
	for key in defaults.keys():
		if ledger.has(key):
			continue
		ledger[key] = _duplicate_value(defaults[key])
		changed = true
	if not ledgers.has(ledger_id) or changed:
		ledgers[ledger_id] = ledger
		current_state["story_ledgers"] = ledgers
	return changed

func _duplicate_value(value):
	if typeof(value) == TYPE_DICTIONARY or typeof(value) == TYPE_ARRAY:
		return value.duplicate(true)
	return value
