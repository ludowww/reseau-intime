extends Node

const STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const PROVIDERS := [
	preload("res://scripts/runtime/season_1/J16RuntimeProvider.gd"),
	preload("res://scripts/runtime/season_1/J17RuntimeProvider.gd"),
	preload("res://scripts/runtime/season_1/J18RuntimeProvider.gd"),
	preload("res://scripts/runtime/season_1/J19RuntimeProvider.gd"),
	preload("res://scripts/runtime/season_1/J20RuntimeProvider.gd"),
	preload("res://scripts/runtime/season_1/J21RuntimeProvider.gd"),
]
const DAYS := ["J16", "J17", "J18", "J19", "J20", "J21"]
const PREVIOUS_DAYS := ["J15", "J16", "J17", "J18", "J19", "J20"]
const EXPECTED_SNAPSHOT_VERSION := 5

var failures: Array[String] = []

func _ready() -> void:
	for index in range(PROVIDERS.size()):
		_round_trip(index)
	if failures.is_empty():
		print("RUNTIME_S1_J16_J21_PROVIDER_SNAPSHOTS: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)

func _round_trip(index: int) -> void:
	var state = STATE.new()
	state.current_day = PREVIOUS_DAYS[index]
	state.day_status = "COMPLETE"
	var source = PROVIDERS[index].new()
	if not source.initialize(state, {}, {}, [], []):
		failures.append(DAYS[index] + " source initialization")
		return
	var saved: Dictionary = source.snapshot()
	if int(saved.get("version", -1)) != EXPECTED_SNAPSHOT_VERSION:
		failures.append(DAYS[index] + " snapshot version")
		return
	var restored = PROVIDERS[index].new()
	if not restored.initialize(state, {}, {}, [], []):
		failures.append(DAYS[index] + " restored initialization")
		return
	if not restored.restore_snapshot(saved):
		failures.append(DAYS[index] + " restore_snapshot")
		return
	if restored.snapshot() != saved:
		failures.append(DAYS[index] + " exact round trip")
