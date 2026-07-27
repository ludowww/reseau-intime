extends RefCounted

class_name Season1RuntimeProvider

const STATE_SCRIPT := preload("res://scripts/runtime/season_1/Season1State.gd")
const J01_SCRIPT := preload("res://scripts/runtime/season_1/J01RuntimeProvider.gd")
const J02_SCRIPT := preload("res://scripts/runtime/season_1/J02RuntimeProvider.gd")
const SNAPSHOT_VERSION := 1

var state
var j01_provider
var j02_provider
var active_provider
var active_day := "J01"
var j01_snapshot: Dictionary = {}
var j02_snapshot: Dictionary = {}

func initialize() -> bool:
	state = STATE_SCRIPT.new()
	j01_provider = J01_SCRIPT.new()
	if not j01_provider.initialize(state): return false
	active_provider = j01_provider
	active_day = "J01"
	return true

func presentation_source() -> Dictionary: return active_provider.presentation_source()
func gallery_source() -> Dictionary: return active_provider.gallery_source()
func apply_choice(thread_id: String, choice_id: String) -> Dictionary: return active_provider.apply_choice(thread_id, choice_id)
func confirm_transition() -> Dictionary: return active_provider.confirm_transition()
func mark_photo_opened() -> bool: return active_provider.mark_photo_opened() if active_day == "J01" else false
func on_thread_returned(thread_id: String) -> Dictionary: return active_provider.on_thread_returned(thread_id) if active_day == "J02" else {}
func presentation_count_by_id(id: String) -> int: return active_provider.presentation_count_by_id(id) if active_day == "J02" else _count_j01(id)

func confirm_day_transition() -> Dictionary:
	if active_day == "J01":
		if not j01_provider.day_end_visible: return {"accepted": false}
		_handoff_to_j02()
		return {"accepted": true, "destination": "day_transition", "presentation": j02_provider.day_start_presentation()}
	return j02_provider.confirm_day_transition()

func _handoff_to_j02() -> void:
	j01_snapshot = j01_provider.snapshot()
	j02_provider = J02_SCRIPT.new()
	j02_provider.initialize(state, j01_provider.transcripts_by_thread, j01_provider.produced_message_ids, j01_provider.unlocked_thread_ids)
	active_day = "J02"
	active_provider = j02_provider

func snapshot() -> Dictionary:
	return {
		"version": SNAPSHOT_VERSION,
		"active_day": active_day,
		"Season1State": state.snapshot(),
		"provider_active": active_day,
		"j01_snapshot": j01_provider.snapshot(),
		"j02_snapshot": j02_provider.snapshot() if j02_provider != null else {},
	}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION or str(value.get("active_day", "")) not in ["J01", "J02"]: return false
	if typeof(value.get("Season1State")) != TYPE_DICTIONARY or typeof(value.get("j01_snapshot")) != TYPE_DICTIONARY or typeof(value.get("j02_snapshot")) != TYPE_DICTIONARY: return false
	if not state.restore_snapshot(value["Season1State"]): return false
	if not j01_provider.restore_snapshot(value["j01_snapshot"]): return false
	j01_snapshot = value["j01_snapshot"].duplicate(true)
	active_day = str(value["active_day"])
	if active_day == "J01":
		active_provider = j01_provider
		return true
	j02_provider = J02_SCRIPT.new()
	if not j02_provider.initialize(state, j01_provider.transcripts_by_thread, j01_provider.produced_message_ids, j01_provider.unlocked_thread_ids): return false
	if not j02_provider.restore_snapshot(value["j02_snapshot"]): return false
	j02_snapshot = value["j02_snapshot"].duplicate(true)
	active_provider = j02_provider
	return true

func _count_j01(id: String) -> int:
	var count := 0
	for thread in j01_provider.transcripts_by_thread:
		for item in j01_provider.transcripts_by_thread[thread]:
			if str(item.get("message_id", "")) == id: count += 1
	return count
