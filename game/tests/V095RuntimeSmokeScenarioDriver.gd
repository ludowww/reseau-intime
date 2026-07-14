extends Node

const VisualDayContract = preload("res://scripts/narrative/VisualDayContract.gd")
const DAY := 8
const LEDGER_ID := "named_boundaries_wave"
const IMAGE_IDS := [
	"marie_tuesday_black_dress_mirror_01",
	"marie_tuesday_black_dress_turn_02",
	"marie_tuesday_black_dress_close_03",
]

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	_ensure_v095_loaded()
	var scenario := _requested_scenario()
	match scenario:
		"A": _scenario_choice("choice_d8_m4_join_movement", "marie_wednesday_join_movement")
		"B": _scenario_choice("choice_d8_m4_take_table", "marie_wednesday_lannexe_table")
		"C": _scenario_choice("choice_d8_m4_private_thursday", "marie_thursday_private_continuation")
		"D": await _scenario_gallery()
		"E": _scenario_missing_slot()
		"F": _scenario_duplicate_does_not_count()
		"G": _scenario_asset_fallback_contract()
		"H": _scenario_reset()
		"I": _scenario_first_repetition_immutable()
		_: failures.append("Unknown V0.95 scenario: %s" % scenario)
	await get_tree().process_frame
	if failures.is_empty():
		print("V0.95 runtime smoke %s: OK" % scenario)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("V0.95 runtime smoke %s: FAILED (%d)" % [scenario, failures.size()])
	get_tree().quit(1)

func _ensure_v095_loaded() -> void:
	DataLoader.load_all()
	var index := DataLoader.load_json("res://data/conversations/chapter_08_modular_index.json")
	if DataLoader.get_index_for_day(DAY).is_empty() and not index.is_empty():
		DataLoader.chapter_indexes.append(index)
		DataLoader._load_index_conversations(index)
	DataLoader._load_visual_content("res://data/visual_content/chapter_08_named_boundaries_visuals.json")
	GameState.reset_state()
	GameState.ensure_story_ledger(LEDGER_ID, _defaults())

func _scenario_choice(choice_id: String, obligation_id: String) -> void:
	var choice := _find_choice(choice_id)
	_expect(not choice.is_empty(), "missing choice %s" % choice_id)
	if choice.is_empty():
		return
	EffectApplier.apply_choice(choice)
	for content_id in IMAGE_IDS:
		GameState.add_unlocked_content(content_id)
	var phone = load("res://scripts/ui/PhonePrototypeV095.gd").new()
	phone._record_m4_obligation()
	var obligation := GameState.get_obligation_status(LEDGER_ID, obligation_id)
	_expect(str(obligation.get("status", "")) == "SCHEDULED", "obligation not scheduled")
	var result := _contract_result(GameState.current_state.get("unlocked_content", []))
	_expect(bool(result.get("satisfied", false)), "three images did not satisfy contract")

func _scenario_gallery() -> void:
	for content_id in IMAGE_IDS:
		GameState.add_unlocked_content(content_id)
	var gallery = preload("res://scenes/smartphone/PhotoGalleryView.tscn").instantiate()
	add_child(gallery)
	await get_tree().process_frame
	gallery.refresh()
	_expect(gallery.unlocked_photo_ids() == IMAGE_IDS, "gallery does not contain exactly Tuesday images")
	gallery.queue_free()

func _scenario_missing_slot() -> void:
	var result := _contract_result(IMAGE_IDS.slice(0, 2))
	_expect(not bool(result.get("satisfied", true)), "missing slot was accepted")
	_expect(result.get("missing_slot_ids", []).size() == 1, "missing slot not identified")

func _scenario_duplicate_does_not_count() -> void:
	var repeated := [IMAGE_IDS[0], IMAGE_IDS[0], IMAGE_IDS[1]]
	var result := _contract_result(repeated)
	_expect(not bool(result.get("satisfied", true)), "duplicate image counted twice")
	_expect(result.get("counted_content_ids", []).size() == 2, "duplicate count is wrong")

func _scenario_asset_fallback_contract() -> void:
	for content_id in IMAGE_IDS:
		var item := DataLoader.get_visual_content(content_id)
		var asset_path := str(item.get("asset_path", ""))
		_expect(FileAccess.file_exists(ProjectSettings.globalize_path(asset_path)), "prototype asset missing: %s" % content_id)
	_expect(not FileAccess.file_exists(ProjectSettings.globalize_path("res://assets/visual_content/v0_95/does_not_exist.png")), "known missing asset unexpectedly exists")

func _scenario_reset() -> void:
	for content_id in IMAGE_IDS:
		GameState.add_unlocked_content(content_id)
	GameState.set_story_ledger_value(LEDGER_ID, "primary_visual_route", "marie_reconquest")
	GameState.reset_state()
	var ledger := GameState.ensure_story_ledger(LEDGER_ID, _defaults())
	for content_id in IMAGE_IDS:
		_expect(not GameState.current_state.get("unlocked_content", []).has(content_id), "reset kept Tuesday image")
	_expect(str(ledger.get("primary_visual_route", "")) == "", "reset kept named-boundaries route")

func _scenario_first_repetition_immutable() -> void:
	var before := GameState.get_story_ledger("first_repetition")
	GameState.ensure_story_ledger(LEDGER_ID, _defaults())
	GameState.set_story_ledger_value(LEDGER_ID, "primary_carryover_source", "marie_m4")
	_expect(GameState.get_story_ledger("first_repetition") == before, "first-repetition ledger changed")

func _contract_result(unlocked: Array) -> Dictionary:
	var contract: Dictionary = DataLoader.get_index_for_day(DAY).get("daily_visual_contract", {})
	return VisualDayContract.evaluate(contract, unlocked, DataLoader.visual_content_by_id)

func _find_choice(choice_id: String) -> Dictionary:
	var convo := DataLoader.load_json("res://data/conversations/chapter_08_marie_black_dress.json")
	for segment in convo.get("segments", []):
		for choice in segment.get("choices", []):
			if str(choice.get("id", "")) == choice_id:
				return choice
	return {}

func _defaults() -> Dictionary:
	return {
		"window_ordinal": 0,
		"primary_carryover_source": "",
		"primary_visual_route": "",
		"secondary_risk_seed": "",
		"scene_status": {},
		"obligations": {},
		"social_hub_status": "",
		"nico_cycle_status": "",
	}

func _requested_scenario() -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--scenario="):
			return arg.trim_prefix("--scenario=")
	return ""

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
