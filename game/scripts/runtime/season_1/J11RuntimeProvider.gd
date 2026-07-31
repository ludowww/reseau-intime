extends RefCounted

class_name J11RuntimeProvider

const RUNTIME_MAP_PATH := "res://data/runtime/season_1/j11_runtime_map.json"
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const CONTINUATION_SELECTOR := preload("res://scripts/runtime/season_1/J11ContinuationSelector.gd")
const SNAPSHOT_VERSION := 1

var state
var runtime_map: Dictionary = {}
var transcripts_by_thread: Dictionary = {}
var produced_message_ids: Dictionary = {}
var unlocked_thread_ids: Array[String] = []
var gallery_asset_ids: Array[String] = []
var selection_audit: Dictionary = {}
var phase := "day_start_pending"
var current_time_minutes := -1

func initialize(shared_state, cumulative_transcripts: Dictionary, cumulative_ids: Dictionary, cumulative_threads: Array, cumulative_gallery_ids: Array) -> bool:
	state = shared_state
	runtime_map = DataLoader.load_json(RUNTIME_MAP_PATH)
	if runtime_map.is_empty() or str(runtime_map.get("implementation_status", "")) != "FOUNDATION_ONLY":
		return false
	current_time_minutes = NARRATIVE_TIME.parse_narrative_time(str(runtime_map.get("initial_time", "")))
	if current_time_minutes < 0:
		return false
	transcripts_by_thread = cumulative_transcripts.duplicate(true)
	produced_message_ids = cumulative_ids.duplicate(true)
	unlocked_thread_ids.assign(cumulative_threads)
	gallery_asset_ids.assign(cumulative_gallery_ids)
	selection_audit = {}
	phase = "day_start_pending"
	return true

func day_start_presentation() -> Dictionary:
	return runtime_map.get("day_start", {}).duplicate(true)

func start_day() -> Dictionary:
	if phase != "day_start_pending" or not state.begin_j11():
		return {"accepted": false}
	selection_audit = CONTINUATION_SELECTOR.new().select(state.snapshot())
	if selection_audit.is_empty() or not state.set_j11_continuation(str(selection_audit.get("pivot", "")), str(selection_audit.get("reason", ""))):
		return {"accepted": false}
	phase = "foundation_ready"
	return {"accepted": true, "destination": "foundation_ready", "selection": selection_audit.duplicate(true)}

func confirm_day_transition() -> Dictionary:
	return start_day() if phase == "day_start_pending" else {"accepted": false}

func presentation_source() -> Dictionary:
	return {
		"characters": {}, "threads": [], "messages_by_thread": transcripts_by_thread.duplicate(true),
		"choices_by_thread": {}, "narrative_day_short": current_narrative_day_short(),
		"narrative_time": current_narrative_time_text(), "narrative_time_minutes": current_time_minutes,
		"implementation_status": "FOUNDATION_ONLY",
	}

func current_narrative_day_short() -> String:
	return str(runtime_map.get("narrative_day_short", ""))

func current_narrative_time_minutes() -> int:
	return current_time_minutes

func current_narrative_time_text() -> String:
	return NARRATIVE_TIME.format_narrative_time(current_time_minutes)

func mark_message_presented(_message_id: String) -> bool: return false
func mark_thread_batch_presented(_thread_id: String) -> bool: return false
func commit_narrative_time(_minutes: int) -> bool: return false
func gallery_source() -> Dictionary:
	var fixtures := {
		"marie": _gallery_character("marie", "Marie", "#4F8BFF", "M"),
		"sandra": _gallery_character("sandra", "Sandra", "#20C7C9", "S"),
		"mathilde": _gallery_character("mathilde", "Mathilde", "#E070A8", "M"),
		"raphaelle": _gallery_character("raphaelle", "Raphaëlle", "#D69A42", "R"),
		"pauline": _gallery_character("pauline", "Pauline", "#E6B84A", "P"),
		"nico": _gallery_character("nico", "Nico", "#65B87A", "N"),
	}
	var all_assets: Array = []
	var all_children: Dictionary = {}
	for day in range(2, 12):
		var day_map: Dictionary = DataLoader.load_json("res://data/runtime/season_1/j%02d_runtime_map.json" % day)
		all_assets.append_array(day_map.get("gallery_presentations", []))
		for raw_child in day_map.get("gallery_children", []):
			if not raw_child is Dictionary:
				continue
			var child_id := str(raw_child.get("asset_id", ""))
			if child_id != "" and not all_children.has(child_id):
				all_children[child_id] = raw_child.duplicate(true)
	var included_children: Dictionary = {}
	var added_item_keys: Dictionary = {}
	for raw_asset in all_assets:
		if not raw_asset is Dictionary:
			continue
		var asset: Dictionary = raw_asset
		var asset_id := str(asset.get("asset_id", ""))
		if asset_id == "" or not gallery_asset_ids.has(asset_id):
			continue
		for raw_character_id in asset.get("character_ids", []):
			var character_id := str(raw_character_id)
			var character: Dictionary = fixtures.get(character_id, {})
			var item_key := "%s::%s" % [character_id, asset_id]
			if character.is_empty() or added_item_keys.has(item_key):
				continue
			var items: Array = character["items"]
			items.append(_gallery_item(asset, character_id, items.size()))
			character["items"] = items
			added_item_keys[item_key] = true
		var raw_child_ids: Variant = asset.get("sequence_child_ids", [])
		if raw_child_ids is Array:
			for raw_child_id in raw_child_ids:
				var child_id := str(raw_child_id)
				if all_children.has(child_id):
					included_children[child_id] = all_children[child_id].duplicate(true)
	return {
		"fixtures": fixtures,
		"character_order": ["marie", "sandra", "mathilde", "raphaelle", "pauline", "nico"],
		"children_by_id": included_children,
		"empty_label": "Aucun visuel disponible.",
	}
func apply_choice(_thread_id: String, _choice_id: String) -> Dictionary: return {"accepted": false}
func confirm_transition() -> Dictionary: return {"accepted": false}
func on_thread_returned(_thread_id: String) -> Dictionary: return {}
func presentation_count_by_id(_id: String) -> int: return 0

func _gallery_character(id: String, title: String, accent: String, avatar: String) -> Dictionary:
	return {"character_id": id, "display_name": title, "accent_color": Color.from_string(accent, Color.WHITE), "avatar_ref": avatar, "items": []}

func _gallery_item(asset: Dictionary, character_id: String, index: int) -> Dictionary:
	var item := {
		"item_id": str(asset.get("asset_id", "")),
		"asset_id": str(asset.get("asset_id", "")),
		"character_id": character_id,
		"state": "UNLOCKED",
		"is_new": true,
		"sort_key": index,
		"thumbnail_ref": "",
		"full_ref": "",
		"thumbnail_label": str(asset.get("placeholder_label", "Visuel non produit")),
		"placeholder_label": str(asset.get("placeholder_label", "Visuel non produit")),
		"source_kind": str(asset.get("source_kind", "gallery")),
		"content_type": str(asset.get("content_type", "PHOTO")),
		"can_share": bool(asset.get("can_share", false)),
		"transfer_rule": str(asset.get("transfer_rule", "FORBIDDEN")),
		"is_diegetic": bool(asset.get("is_diegetic", true)),
	}
	if asset.has("sequence_child_ids"):
		item["sequence_child_ids"] = asset.get("sequence_child_ids")
	return item

func snapshot() -> Dictionary:
	return {
		"version": SNAPSHOT_VERSION, "phase": phase,
		"transcripts_by_thread": transcripts_by_thread.duplicate(true),
		"produced_message_ids": produced_message_ids.duplicate(true),
		"unlocked_thread_ids": unlocked_thread_ids.duplicate(),
		"gallery_asset_ids": gallery_asset_ids.duplicate(),
		"selection_audit": selection_audit.duplicate(true),
		"current_time_minutes": current_time_minutes,
	}

func restore_snapshot(value: Dictionary) -> bool:
	if int(value.get("version", -1)) != SNAPSHOT_VERSION or str(value.get("phase", "")) not in ["day_start_pending", "foundation_ready"]:
		return false
	for key in ["transcripts_by_thread", "produced_message_ids", "selection_audit"]:
		if typeof(value.get(key)) != TYPE_DICTIONARY: return false
	for key in ["unlocked_thread_ids", "gallery_asset_ids"]:
		if typeof(value.get(key)) != TYPE_ARRAY: return false
	var restored_time := int(value.get("current_time_minutes", -1))
	if NARRATIVE_TIME.format_narrative_time(restored_time) == "": return false
	phase = str(value["phase"])
	transcripts_by_thread = value["transcripts_by_thread"].duplicate(true)
	produced_message_ids = value["produced_message_ids"].duplicate(true)
	unlocked_thread_ids.assign(value["unlocked_thread_ids"])
	gallery_asset_ids.assign(value["gallery_asset_ids"])
	selection_audit = value["selection_audit"].duplicate(true)
	current_time_minutes = restored_time
	if phase == "day_start_pending":
		return state.current_day == "J10" and state.day_status == "COMPLETE" and selection_audit.is_empty()
	return state.current_day == "J11" and state.day_status == "ACTIVE" and not selection_audit.is_empty()
