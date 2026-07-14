extends Node

const DAY := 9
const LEDGER_ID := "named_boundaries_wave"
const Driver = preload("res://scripts/ui/PhonePrototypeV096.gd")
const NamedBoundariesSelector = preload("res://scripts/narrative/NamedBoundariesSelector.gd")
const VisualDayContract = preload("res://scripts/narrative/VisualDayContract.gd")

const SOCIAL_IDS := [
	"marie_wednesday_lannexe_social_01",
	"pauline_wednesday_green_dress_02",
	"marie_pauline_wednesday_duo_03",
]
const ROUTE_IDS := [
	"mathilde_wednesday_deliberate_pose_03",
	"mathilde_wednesday_deliberate_pose_cold_alt_03",
	"sandra_wednesday_private_extra_03",
	"sandra_wednesday_composed_close_alt_03",
]

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	_ensure_loaded()
	match _scenario():
		"A": _scenario_a()
		"B": _scenario_b()
		"C": _scenario_c()
		"D": _scenario_d()
		"E": _scenario_e()
		"F": _scenario_f()
		"G": _scenario_g()
		"H": _scenario_h()
		"I": _scenario_i()
		_:
			failures.append("Unknown scenario: %s" % _scenario())
	await get_tree().process_frame
	if failures.is_empty():
		print("V0.96 runtime smoke %s: OK" % _scenario())
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("V0.96 runtime smoke %s: FAILED (%d)" % [_scenario(), failures.size()])
	get_tree().quit(1)

func _ensure_loaded() -> void:
	DataLoader.load_all()
	var phone = Driver.new()
	phone._ensure_v096_content_loaded()
	GameState.reset_state()
	GameState.ensure_story_ledger(LEDGER_ID, {
		"primary_carryover_source": "",
		"primary_visual_route": "",
		"scene_status": {},
		"obligations": {},
		"social_hub_status": "",
	})

func _scenario() -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--scenario="):
			return arg.trim_prefix("--scenario=")
	return ""

func _reset() -> void:
	GameState.reset_state()
	GameState.ensure_story_ledger(LEDGER_ID, {
		"primary_carryover_source": "",
		"primary_visual_route": "",
		"scene_status": {},
		"obligations": {},
		"social_hub_status": "",
	})

func _visual_contract_result(unlocked: Array) -> Dictionary:
	var contract: Dictionary = DataLoader.get_index_for_day(DAY).get("daily_visual_contract", {})
	return VisualDayContract.evaluate(contract, unlocked, DataLoader.visual_content_by_id)

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _scenario_a() -> void:
	_reset()
	var selection: Dictionary = NamedBoundariesSelector.select_carryover(GameState.get_story_ledger("first_repetition"), [])
	_expect(str(selection.get("selected_character", "")) == "none", "A: carryover should be none")
	var contract := _visual_contract_result(SOCIAL_IDS)
	_expect(bool(contract.get("satisfied", false)), "A: guaranteed social contract should pass")
	_expect(contract.get("counted_content_ids", []) == SOCIAL_IDS, "A: social contract counted ids wrong")

func _scenario_b() -> void:
	_reset()
	GameState.set_story_ledger_value("first_repetition", "charged_access_owner", "mathilde")
	GameState.set_story_ledger_value("first_repetition", "scene_status", {"mathilde_wednesday_visual_boundary_01": "RESOLVED"})
	var selection: Dictionary = NamedBoundariesSelector.select_carryover(GameState.get_story_ledger("first_repetition"), [])
	_expect(str(selection.get("selected_character", "")) == "mathilde", "B: owner mathilde should select mathilde")

func _scenario_c() -> void:
	_reset()
	GameState.set_story_ledger_value("first_repetition", "scene_status", {
		"mathilde_wednesday_visual_boundary_01": "RESOLVED",
		"sandra_wednesday_visual_boundary_01": "RESOLVED",
	})
	GameState.record_external_foreground("first_repetition", "mathilde_wednesday_visual_boundary_01", "mathilde")
	GameState.record_external_foreground("first_repetition", "sandra_wednesday_visual_boundary_01", "sandra")
	var selection: Dictionary = NamedBoundariesSelector.select_carryover(GameState.get_story_ledger("first_repetition"), [])
	_expect(str(selection.get("selected_character", "")) == "sandra", "C: latest resolved foreground should select sandra")

func _scenario_d() -> void:
	_reset()
	GameState.set_story_ledger_value("first_repetition", "charged_access_owner", "mathilde")
	GameState.set_story_ledger_value("first_repetition", "scene_status", {
		"mathilde_wednesday_visual_boundary_01": "RESOLVED",
		"sandra_wednesday_visual_boundary_01": "RESOLVED",
	})
	GameState.record_external_foreground("first_repetition", "sandra_wednesday_visual_boundary_01", "sandra")
	var selection: Dictionary = NamedBoundariesSelector.select_carryover(GameState.get_story_ledger("first_repetition"), [])
	_expect(str(selection.get("selected_character", "")) == "mathilde", "D: owner mathilde must win over recent sandra")

func _scenario_e() -> void:
	_reset()
	var phone := Driver.new()
	GameState.current_state["flags"] = ["mathilde_deliberate_visual"]
	phone._record_named_boundaries_visual_route("chapter_09_mathilde_visual_boundary")
	var ledger := GameState.get_story_ledger(LEDGER_ID)
	_expect(str(ledger.get("primary_visual_route", "")) == "mathilde_deliberate_visual", "E: mathilde route not recorded")

func _scenario_f() -> void:
	_reset()
	var phone := Driver.new()
	GameState.current_state["flags"] = ["sandra_chosen_exposure"]
	phone._record_named_boundaries_visual_route("chapter_09_sandra_visual_boundary")
	var ledger := GameState.get_story_ledger(LEDGER_ID)
	_expect(str(ledger.get("primary_visual_route", "")) == "sandra_chosen_exposure", "F: sandra route not recorded")

func _scenario_g() -> void:
	_reset()
	var phone := Driver.new()
	GameState.set_story_ledger_value(LEDGER_ID, "primary_visual_route", "mathilde_deliberate_visual")
	GameState.current_state["flags"] = ["sandra_chosen_exposure"]
	phone._record_named_boundaries_visual_route("chapter_09_sandra_visual_boundary")
	var ledger := GameState.get_story_ledger(LEDGER_ID)
	_expect(str(ledger.get("primary_visual_route", "")) == "mathilde_deliberate_visual", "G: existing route must not be overwritten")

func _scenario_h() -> void:
	_reset()
	for content_id in SOCIAL_IDS + ROUTE_IDS:
		GameState.add_unlocked_content(content_id)
	var contract := _visual_contract_result(GameState.current_state.get("unlocked_content", []))
	_expect(bool(contract.get("satisfied", false)), "H: social contract should ignore route images")
	_expect(contract.get("counted_content_ids", []) == SOCIAL_IDS, "H: route images altered the social contract")

func _scenario_i() -> void:
	_reset()
	var before := JSON.stringify(GameState.get_story_ledger("first_repetition"))
	var phone := Driver.new()
	GameState.current_state["flags"] = ["mathilde_deliberate_visual"]
	phone._record_named_boundaries_visual_route("chapter_09_mathilde_visual_boundary")
	phone._apply_named_boundaries_social_set_outcome()
	var after := JSON.stringify(GameState.get_story_ledger("first_repetition"))
	_expect(before == after, "I: first_repetition must stay identical")
