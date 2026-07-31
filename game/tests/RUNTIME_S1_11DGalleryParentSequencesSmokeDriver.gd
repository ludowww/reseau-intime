extends Node

const DEMO_SCENE := preload("res://scenes/portrait/PortraitShellDemo.tscn")
const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J11_PROVIDER := preload("res://scripts/runtime/season_1/J11RuntimeProvider.gd")

const SIMPLE_MATHILDE := "S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01"
const MATHILDE_PARENT := "S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01"
const MARIE_PARENT := "S1_A3_J11_SCN_MARIE_COUPLE_STATE_01"
const MATHILDE_CHILDREN := [
	"S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY",
	"S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01",
	"S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01",
]
const MARIE_CHILDREN := [
	"S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_RECONNECTION",
	"S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01",
	"S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01",
]

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var state = SEASON_STATE.new()
	state.current_day = "J10"
	state.day_status = "COMPLETE"
	var provider = J11_PROVIDER.new()
	var unlocked := [SIMPLE_MATHILDE, MATHILDE_PARENT, MARIE_PARENT, MATHILDE_PARENT, MARIE_PARENT]
	_expect(provider.initialize(state, {}, {}, [], unlocked), "J11 provider initializes with pre-existing gallery unlocks")
	var source: Dictionary = provider.gallery_source()
	var provider_snapshot: Dictionary = provider.snapshot()
	var narrative_snapshot: Dictionary = state.snapshot()
	_expect(source.get("children_by_id", {}).size() == 6, "only six internal J11 children are addressable")
	_expect(_fixture_item_ids(source, "mathilde") == [SIMPLE_MATHILDE, MATHILDE_PARENT], "Mathilde grid has one simple tile and one deduplicated parent")
	_expect(_fixture_item_ids(source, "marie") == [MARIE_PARENT], "Marie grid has one deduplicated parent")
	for child_id in MATHILDE_CHILDREN + MARIE_CHILDREN:
		_expect(not _all_grid_item_ids(source).has(child_id), "child leaked into grid: " + child_id)

	var restored_state = SEASON_STATE.new()
	restored_state.current_day = "J10"
	restored_state.day_status = "COMPLETE"
	var restored = J11_PROVIDER.new()
	_expect(restored.initialize(restored_state, {}, {}, [], []), "restored provider initializes")
	_expect(restored.restore_snapshot(provider_snapshot), "provider snapshot restores")
	_expect(restored.snapshot() == provider_snapshot, "gallery unlock snapshot round trip is exact")
	_expect(restored.gallery_source() == source, "restored gallery source is deterministic")

	var demo = DEMO_SCENE.instantiate()
	add_child(demo)
	await _frames(3)
	var shell = demo.shell
	var gallery = shell.gallery_screen
	gallery.refresh_content_source(source)
	shell.activate_gallery(false)
	gallery.select_character("mathilde")
	await _frames(3)
	_expect(gallery.describe_state().get("tile_count", -1) == 2, "Mathilde renders exactly two visible tiles")
	_expect(gallery.display_state_for_item(MATHILDE_PARENT) == "NEW", "Mathilde parent owns NEW state")
	for child_id in MATHILDE_CHILDREN:
		_expect(gallery.display_state_for_item(child_id) == "", "Mathilde child has no independent display state")
	var simple_sequence: Array[Dictionary] = gallery.viewer_sequence_for_item(SIMPLE_MATHILDE)
	_expect(_photo_ids(simple_sequence) == [SIMPLE_MATHILDE], "legacy simple entry remains independently openable")
	var mathilde_sequence: Array[Dictionary] = gallery.viewer_sequence_for_item(MATHILDE_PARENT)
	_expect(_photo_ids(mathilde_sequence) == MATHILDE_CHILDREN, "Mathilde parent exposes its exact ordered triplet")
	_expect(not _photo_ids(mathilde_sequence).has(MARIE_CHILDREN[0]), "Marie child contaminates Mathilde sequence")

	gallery.select_character("mathilde")
	gallery.select_character("mathilde")
	await _frames(2)
	var rebuilt_ids := _visible_tile_ids(gallery)
	_expect(rebuilt_ids.size() == 2 and _unique_count(rebuilt_ids) == 2, "gallery rebuild creates no duplicate tile")
	gallery.focus_item(MATHILDE_PARENT, true)
	shell._on_gallery_photo_requested(MATHILDE_PARENT)
	await _frames(2)
	_expect(shell.is_photo_viewer_active(), "Mathilde parent opens viewer")
	_expect(shell.photo_viewer.presentations.size() == 3 and shell.photo_viewer.current_photo_id() == MATHILDE_CHILDREN[0], "Mathilde viewer starts on declared first child")
	_expect(gallery.display_state_for_item(MATHILDE_PARENT) == "VIEWED", "opening Mathilde marks parent viewed")
	shell.photo_viewer.show_next()
	shell.photo_viewer.show_next()
	shell.photo_viewer.show_next()
	_expect(shell.photo_viewer.current_photo_id() == MATHILDE_CHILDREN[2], "Mathilde next is bounded to three children")
	shell.photo_viewer.show_previous()
	_expect(shell.photo_viewer.current_photo_id() == MATHILDE_CHILDREN[1], "Mathilde previous stays inside parent sequence")
	shell._close_photo_viewer()
	await _frames(3)
	_expect(gallery.describe_state().get("focused_tile_id", "") == MATHILDE_PARENT, "closing grouped viewer restores parent tile focus")
	shell._on_gallery_photo_requested(MATHILDE_PARENT)
	await _frames(2)
	_expect(shell.photo_viewer.current_photo_id() == MATHILDE_CHILDREN[0], "reopening Mathilde deterministically starts at first child")
	shell._close_photo_viewer()

	gallery.select_character("marie")
	await _frames(2)
	_expect(gallery.describe_state().get("tile_count", -1) == 1, "Marie renders one parent tile")
	var marie_sequence: Array[Dictionary] = gallery.viewer_sequence_for_item(MARIE_PARENT)
	_expect(_photo_ids(marie_sequence) == MARIE_CHILDREN, "Marie parent exposes its exact ordered triplet")
	_expect(not _photo_ids(marie_sequence).has(MATHILDE_CHILDREN[0]), "Mathilde child contaminates Marie sequence")
	shell._on_gallery_photo_requested(MARIE_PARENT)
	await _frames(2)
	_expect(shell.is_photo_viewer_active() and shell.photo_viewer.presentations.size() == 3, "Marie parent opens exactly three children")
	_expect(shell.photo_viewer.current_photo_id() == MARIE_CHILDREN[0], "Marie viewer starts on declared first child")
	_expect(gallery.display_state_for_item(MARIE_PARENT) == "VIEWED", "opening Marie marks parent viewed")
	shell._close_photo_viewer()

	var broken_source: Dictionary = source.duplicate(true)
	broken_source["children_by_id"].erase(MATHILDE_CHILDREN[1])
	gallery.refresh_content_source(broken_source)
	gallery.select_character("mathilde")
	await _frames(2)
	_expect(gallery.viewer_sequence_for_item(MATHILDE_PARENT).is_empty(), "missing child fails parent sequence closed")
	shell._on_gallery_photo_requested(MATHILDE_PARENT)
	_expect(not shell.is_photo_viewer_active(), "invalid parent sequence cannot open viewer")
	_expect(gallery.display_state_for_item(MATHILDE_PARENT) == "NEW", "failed open does not mark parent viewed")

	_expect(state.snapshot() == narrative_snapshot, "gallery consultation does not mutate narrative state")
	_expect(provider.snapshot() == provider_snapshot, "gallery consultation does not mutate provider ledger state")
	demo.queue_free()
	_finish()

func _fixture_item_ids(source: Dictionary, character_id: String) -> Array:
	var result: Array = []
	for item in source.get("fixtures", {}).get(character_id, {}).get("items", []):
		result.append(str(item.get("item_id", "")))
	return result

func _all_grid_item_ids(source: Dictionary) -> Array:
	var result: Array = []
	for character in source.get("fixtures", {}).values():
		for item in character.get("items", []):
			result.append(str(item.get("item_id", "")))
	return result

func _visible_tile_ids(gallery) -> Array:
	var result: Array = []
	for tile in gallery.tile_buttons:
		result.append(str(tile.item_id))
	return result

func _photo_ids(sequence: Array[Dictionary]) -> Array:
	var result: Array = []
	for presentation in sequence:
		result.append(str(presentation.get("photo_id", "")))
	return result

func _unique_count(values: Array) -> int:
	var unique: Dictionary = {}
	for value in values:
		unique[value] = true
	return unique.size()

func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame

func _expect(condition: bool, label: String) -> void:
	if not condition:
		failures.append(label)

func _finish() -> void:
	if failures.is_empty():
		print("RUNTIME_S1_11D_GALLERY_PARENT_SEQUENCES: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)
