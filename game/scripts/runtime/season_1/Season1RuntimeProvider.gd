extends RefCounted

class_name Season1RuntimeProvider

const STATE_SCRIPT := preload("res://scripts/runtime/season_1/Season1State.gd")
const J01_SCRIPT := preload("res://scripts/runtime/season_1/J01RuntimeProvider.gd")
const J02_SCRIPT := preload("res://scripts/runtime/season_1/J02RuntimeProvider.gd")
const J03_SCRIPT := preload("res://scripts/runtime/season_1/J03RuntimeProvider.gd")
const SNAPSHOT_VERSION := 2

var state
var j01_provider
var j02_provider
var j03_provider
var active_provider
var active_day := "J01"
# Kept as local handoff caches for compatibility; v2 serializes provider_snapshots.
var j01_snapshot: Dictionary = {}
var j02_snapshot: Dictionary = {}
var j03_snapshot: Dictionary = {}
var state_restore_count := 0

func initialize() -> bool:
	state_restore_count = 0
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
func on_thread_returned(thread_id: String) -> Dictionary: return active_provider.on_thread_returned(thread_id) if active_day in ["J02", "J03"] else {}
func presentation_count_by_id(id: String) -> int: return active_provider.presentation_count_by_id(id) if active_day in ["J02", "J03"] else _count_j01(id)

func confirm_day_transition() -> Dictionary:
	if active_day == "J01":
		if not j01_provider.day_end_visible: return {"accepted": false}
		_handoff_to_j02()
		return {"accepted": true, "destination": "day_transition", "presentation": j02_provider.day_start_presentation()}
	if active_day == "J02" and j02_provider.phase == "complete":
		if not _handoff_to_j03(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j03_provider.day_start_presentation()}
	return active_provider.confirm_day_transition()

func confirm_secondary_day_transition() -> Dictionary:
	return j03_provider.confirm_secondary_day_transition() if active_day == "J03" else {"accepted": false}

func _handoff_to_j02() -> void:
	j01_snapshot = j01_provider.progress_snapshot()
	j02_provider = J02_SCRIPT.new()
	j02_provider.initialize(state, j01_provider.transcripts_by_thread, j01_provider.produced_message_ids, j01_provider.unlocked_thread_ids)
	active_day = "J02"; active_provider = j02_provider

func _handoff_to_j03() -> bool:
	var candidate = J03_SCRIPT.new()
	if not candidate.initialize(state, j02_provider.transcripts_by_thread, j02_provider.produced_message_ids, j02_provider.unlocked_thread_ids, j02_provider.gallery_asset_ids):
		return false
	j02_snapshot = j02_provider.snapshot()
	j03_provider = candidate
	active_day = "J03"; active_provider = j03_provider
	return true

func snapshot() -> Dictionary:
	return {
		"version": SNAPSHOT_VERSION,
		"active_day": active_day,
		"state": state.snapshot(),
		"provider_snapshots": {
			"J01": j01_provider.progress_snapshot(),
			"J02": j02_provider.snapshot() if j02_provider != null else {},
			"J03": j03_provider.snapshot() if j03_provider != null else {},
		},
	}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION or str(value.get("active_day", "")) not in ["J01", "J02", "J03"]: return false
	if typeof(value.get("state")) != TYPE_DICTIONARY or typeof(value.get("provider_snapshots")) != TYPE_DICTIONARY: return false
	var providers: Dictionary = value["provider_snapshots"]
	for id in ["J01", "J02", "J03"]:
		if typeof(providers.get(id)) != TYPE_DICTIONARY: return false
	# The shared Season1State is restored exactly once here.
	state_restore_count += 1
	if not state.restore_snapshot(value["state"]): return false
	if not j01_provider.restore_progress_snapshot(providers["J01"]): return false
	j01_snapshot = providers["J01"].duplicate(true)
	active_day = str(value["active_day"])
	if active_day == "J01": active_provider = j01_provider; return true
	j02_provider = J02_SCRIPT.new()
	if not j02_provider.initialize(state, j01_provider.transcripts_by_thread, j01_provider.produced_message_ids, j01_provider.unlocked_thread_ids): return false
	if not j02_provider.restore_snapshot(providers["J02"]): return false
	j02_snapshot = providers["J02"].duplicate(true)
	if active_day == "J02": active_provider = j02_provider; return true
	j03_provider = J03_SCRIPT.new()
	if not j03_provider.initialize(state, j02_provider.transcripts_by_thread, j02_provider.produced_message_ids, j02_provider.unlocked_thread_ids, j02_provider.gallery_asset_ids): return false
	if not j03_provider.restore_snapshot(providers["J03"]): return false
	j03_snapshot = providers["J03"].duplicate(true)
	active_provider = j03_provider
	return true

func _count_j01(id: String) -> int:
	var count := 0
	for thread in j01_provider.transcripts_by_thread:
		for item in j01_provider.transcripts_by_thread[thread]:
			if str(item.get("message_id", "")) == id: count += 1
	return count
