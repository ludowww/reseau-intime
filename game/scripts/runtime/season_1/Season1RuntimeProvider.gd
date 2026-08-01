extends RefCounted

class_name Season1RuntimeProvider

const STATE_SCRIPT := preload("res://scripts/runtime/season_1/Season1State.gd")
const J01_SCRIPT := preload("res://scripts/runtime/season_1/J01RuntimeProvider.gd")
const J02_SCRIPT := preload("res://scripts/runtime/season_1/J02RuntimeProvider.gd")
const J03_SCRIPT := preload("res://scripts/runtime/season_1/J03RuntimeProvider.gd")
const J04_SCRIPT := preload("res://scripts/runtime/season_1/J04RuntimeProvider.gd")
const J05_SCRIPT := preload("res://scripts/runtime/season_1/J05RuntimeProvider.gd")
const J06_SCRIPT := preload("res://scripts/runtime/season_1/J06RuntimeProvider.gd")
const J07_SCRIPT := preload("res://scripts/runtime/season_1/J07RuntimeProvider.gd")
const J08_SCRIPT := preload("res://scripts/runtime/season_1/J08RuntimeProvider.gd")
const J09_SCRIPT := preload("res://scripts/runtime/season_1/J09RuntimeProvider.gd")
const J10_SCRIPT := preload("res://scripts/runtime/season_1/J10RuntimeProvider.gd")
const J11_SCRIPT := preload("res://scripts/runtime/season_1/J11RuntimeProvider.gd")
const J12_SCRIPT := preload("res://scripts/runtime/season_1/J12RuntimeProvider.gd")
const J13_SCRIPT := preload("res://scripts/runtime/season_1/J13RuntimeProvider.gd")
const J14_SCRIPT := preload("res://scripts/runtime/season_1/J14RuntimeProvider.gd")
const J15_SCRIPT := preload("res://scripts/runtime/season_1/J15RuntimeProvider.gd")
const J16_SCRIPT := preload("res://scripts/runtime/season_1/J16RuntimeProvider.gd")
const J17_SCRIPT := preload("res://scripts/runtime/season_1/J17RuntimeProvider.gd")
const J18_SCRIPT := preload("res://scripts/runtime/season_1/J18RuntimeProvider.gd")
const SNAPSHOT_VERSION := 18

var state
var j01_provider
var j02_provider
var j03_provider
var j04_provider
var j05_provider
var j06_provider
var j07_provider
var j08_provider
var j09_provider
var j10_provider
var j11_provider
var j12_provider
var j13_provider
var j14_provider
var j15_provider
var j16_provider
var j17_provider
var j18_provider
var active_provider
var active_day := "J01"
var j01_snapshot: Dictionary = {}
var j02_snapshot: Dictionary = {}
var j03_snapshot: Dictionary = {}
var j04_snapshot: Dictionary = {}
var j05_snapshot: Dictionary = {}
var j06_snapshot: Dictionary = {}
var j07_snapshot: Dictionary = {}
var j08_snapshot: Dictionary = {}
var j09_snapshot: Dictionary = {}
var j10_snapshot: Dictionary = {}
var j11_snapshot: Dictionary = {}
var j12_snapshot: Dictionary = {}
var j13_snapshot: Dictionary = {}
var j14_snapshot: Dictionary = {}
var j15_snapshot: Dictionary = {}
var j16_snapshot: Dictionary = {}
var j17_snapshot: Dictionary = {}
var state_restore_count := 0

func initialize() -> bool:
	state_restore_count = 0
	state = STATE_SCRIPT.new()
	j01_provider = J01_SCRIPT.new()
	if not j01_provider.initialize(state): return false
	active_provider = j01_provider
	active_day = "J01"
	return true

func presentation_source() -> Dictionary:
	var source: Dictionary = active_provider.presentation_source()
	source["pending_transition_flow"] = pending_transition_flow()
	return source
func current_narrative_day_short() -> String: return active_provider.current_narrative_day_short()
func current_narrative_time_minutes() -> int: return active_provider.current_narrative_time_minutes()
func current_narrative_time_text() -> String: return active_provider.current_narrative_time_text()
func mark_message_presented(message_id: String) -> bool: return active_provider.mark_message_presented(message_id)
func mark_thread_batch_presented(thread_id: String) -> bool:
	return active_provider.mark_thread_batch_presented(thread_id) if active_provider.has_method("mark_thread_batch_presented") else false
func commit_narrative_time(minutes: int) -> bool: return active_provider.commit_narrative_time(minutes)
func gallery_source() -> Dictionary: return active_provider.gallery_source()
func apply_choice(thread_id: String, choice_id: String) -> Dictionary: return active_provider.apply_choice(thread_id, choice_id)
func confirm_transition() -> Dictionary: return active_provider.confirm_transition()
func mark_photo_opened() -> bool: return active_provider.mark_photo_opened() if active_day == "J01" else false
func on_thread_returned(thread_id: String) -> Dictionary: return active_provider.on_thread_returned(thread_id) if active_day in ["J02", "J03", "J04", "J05", "J06", "J07", "J08", "J09", "J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18"] else {}
func presentation_count_by_id(id: String) -> int: return active_provider.presentation_count_by_id(id) if active_day in ["J02", "J03", "J04", "J05", "J06", "J07", "J08", "J09", "J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18"] else _count_j01(id)

func confirm_day_transition() -> Dictionary:
	if active_day == "J01":
		if not j01_provider.day_end_visible: return {"accepted": false}
		_handoff_to_j02()
		return {"accepted": true, "destination": "day_transition", "presentation": j02_provider.day_start_presentation()}
	if active_day == "J02" and j02_provider.phase == "complete":
		if not _handoff_to_j03(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j03_provider.day_start_presentation()}
	if active_day == "J03" and j03_provider.phase == "complete":
		if not _handoff_to_j04(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j04_provider.day_start_presentation()}
	if active_day == "J04" and j04_provider.phase == "complete":
		if not _handoff_to_j05(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j05_provider.day_start_presentation()}
	if active_day == "J05" and j05_provider.phase == "complete":
		if not _handoff_to_j06(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j06_provider.day_start_presentation()}
	if active_day == "J06" and j06_provider.phase == "complete":
		if not _handoff_to_j07(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j07_provider.day_start_presentation()}
	if active_day == "J07" and j07_provider.phase == "complete":
		if not _handoff_to_j08(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j08_provider.day_start_presentation()}
	if active_day == "J08" and j08_provider.phase == "complete":
		if not _handoff_to_j09(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j09_provider.day_start_presentation()}
	if active_day == "J09" and j09_provider.phase == "complete":
		if not _handoff_to_j10(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j10_provider.day_start_presentation()}
	if active_day == "J10" and j10_provider.phase == "complete":
		if not _handoff_to_j11(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j11_provider.day_start_presentation()}
	if active_day == "J11" and j11_provider.phase == "complete":
		if not _handoff_to_j12(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j12_provider.day_start_presentation()}
	if active_day == "J12" and j12_provider.phase == "complete":
		if not _handoff_to_j13(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j13_provider.day_start_presentation()}
	if active_day == "J13" and j13_provider.phase == "complete":
		if not _handoff_to_j14(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j14_provider.day_start_presentation()}
	if active_day == "J14" and j14_provider.phase == "complete":
		if not _handoff_to_j15(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j15_provider.day_start_presentation()}
	if active_day == "J15" and j15_provider.phase == "complete":
		if not _handoff_to_j16(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j16_provider.day_start_presentation()}
	if active_day == "J16" and j16_provider.phase == "complete":
		if not _handoff_to_j17(): return {"accepted": false}
		return {"accepted": true, "destination": "day_transition", "presentation": j17_provider.day_start_presentation()}
	if active_day=="J17" and j17_provider.phase=="complete":
		if not _handoff_to_j18():return {"accepted":false}
		return {"accepted":true,"destination":"day_transition","presentation":j18_provider.day_start_presentation()}
	return active_provider.confirm_day_transition()

func confirm_secondary_day_transition() -> Dictionary:
	return j03_provider.confirm_secondary_day_transition() if active_day == "J03" else {"accepted": false}

func automatic_day_handoff() -> Dictionary:
	if active_day == "J01" and j01_provider.day_end_visible:
		_handoff_to_j02()
		var result: Dictionary = j02_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j02_provider.day_start_presentation()
		return result
	if active_day == "J02" and j02_provider.phase == "complete":
		if not _handoff_to_j03(): return {"accepted": false}
		var result: Dictionary = j03_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j03_provider.day_start_presentation()
		return result
	if active_day == "J03" and j03_provider.phase == "complete":
		if not _handoff_to_j04(): return {"accepted": false}
		var result: Dictionary = j04_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j04_provider.day_start_presentation()
		return result
	if active_day == "J04" and j04_provider.phase == "complete":
		if not _handoff_to_j05(): return {"accepted": false}
		var result: Dictionary = j05_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j05_provider.day_start_presentation()
		return result
	if active_day == "J05" and j05_provider.phase == "complete":
		if not _handoff_to_j06(): return {"accepted": false}
		var result: Dictionary = j06_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j06_provider.day_start_presentation()
		return result
	if active_day == "J06" and j06_provider.phase == "complete":
		if not _handoff_to_j07(): return {"accepted": false}
		var result: Dictionary = j07_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j07_provider.day_start_presentation()
		return result
	if active_day == "J07" and j07_provider.phase == "complete":
		if not _handoff_to_j08(): return {"accepted": false}
		var result: Dictionary = j08_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j08_provider.day_start_presentation()
		return result
	if active_day == "J08" and j08_provider.phase == "complete":
		if not _handoff_to_j09(): return {"accepted": false}
		var result: Dictionary = j09_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j09_provider.day_start_presentation()
		return result
	if active_day == "J09" and j09_provider.phase == "complete":
		if not _handoff_to_j10(): return {"accepted": false}
		var result: Dictionary = j10_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j10_provider.day_start_presentation()
		return result
	if active_day == "J10" and j10_provider.phase == "complete":
		if not _handoff_to_j11(): return {"accepted": false}
		var result: Dictionary = j11_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j11_provider.day_start_presentation()
		return result
	if active_day == "J11" and j11_provider.phase == "complete":
		if not _handoff_to_j12(): return {"accepted": false}
		var result: Dictionary = j12_provider.start_day()
		result["automatic_day_handoff"] = true; result["next_day_presentation"] = j12_provider.day_start_presentation()
		return result
	if active_day == "J12" and j12_provider.phase == "complete":
		if not _handoff_to_j13(): return {"accepted": false}
		var result: Dictionary = j13_provider.start_day(); result["automatic_day_handoff"] = true; result["next_day_presentation"] = j13_provider.day_start_presentation(); return result
	if active_day == "J13" and j13_provider.phase == "complete":
		if not _handoff_to_j14(): return {"accepted": false}
		var result: Dictionary = j14_provider.start_day(); result["automatic_day_handoff"] = true; result["next_day_presentation"] = j14_provider.day_start_presentation(); return result
	if active_day == "J14" and j14_provider.phase == "complete":
		if not _handoff_to_j15(): return {"accepted": false}
		var result: Dictionary = j15_provider.start_day(); result["automatic_day_handoff"] = true; result["next_day_presentation"] = j15_provider.day_start_presentation(); return result
	if active_day == "J15" and j15_provider.phase == "complete":
		if not _handoff_to_j16(): return {"accepted": false}
		var result: Dictionary = j16_provider.start_day(); result["automatic_day_handoff"] = true; result["next_day_presentation"] = j16_provider.day_start_presentation(); return result
	if active_day == "J16" and j16_provider.phase == "complete":
		if not _handoff_to_j17(): return {"accepted": false}
		var result: Dictionary = j17_provider.start_day(); result["automatic_day_handoff"] = true; result["next_day_presentation"] = j17_provider.day_start_presentation(); return result
	if active_day=="J17" and j17_provider.phase=="complete":
		if not _handoff_to_j18():return {"accepted":false}
		var result:Dictionary=j18_provider.start_day();result.automatic_day_handoff=true;result.next_day_presentation=j18_provider.day_start_presentation();return result
	return {"accepted": false}

func next_day_presentation() -> Dictionary:
	if active_day == "J01": return j01_provider.runtime_map.get("transitions", {}).get("sandra", {}).get("next_day_presentation", {}).duplicate(true)
	if active_day == "J02": return j02_provider.runtime_map.get("day_end", {}).get("next_day_presentation", {}).duplicate(true)
	if active_day == "J03": return j03_provider.runtime_map.get("day_end", {}).get("next_day_presentation", {}).duplicate(true)
	if active_day == "J04": return j04_provider.runtime_map.get("day_end", {}).get("next_day_presentation", {}).duplicate(true)
	if active_day == "J05": return j05_provider.runtime_map.get("day_end", {}).get("next_day_presentation", {}).duplicate(true)
	if active_day == "J06": return j06_provider.runtime_map.get("day_end", {}).get("next_day_presentation", {}).duplicate(true)
	if active_day == "J07": return j07_provider.runtime_map.get("day_end", {}).get("next_day_presentation", {}).duplicate(true)
	if active_day == "J08": return j08_provider.runtime_map.get("day_end", {}).get("next_day_presentation", {}).duplicate(true)
	if active_day == "J09": return j09_provider.runtime_map.get("day_end", {}).get("next_day_presentation", {}).duplicate(true)
	if active_day == "J10": return j11_provider.day_start_presentation() if j11_provider != null else DataLoader.load_json("res://data/runtime/season_1/j11_runtime_map.json").get("day_start", {}).duplicate(true)
	if active_day == "J11": return j12_provider.day_start_presentation() if j12_provider != null else DataLoader.load_json("res://data/runtime/season_1/j12_runtime_map.json").get("day_start", {}).duplicate(true)
	if active_day == "J12": return j13_provider.day_start_presentation() if j13_provider != null else DataLoader.load_json("res://data/runtime/season_1/j13_runtime_map.json").get("day_start", {}).duplicate(true)
	if active_day == "J13": return j14_provider.day_start_presentation() if j14_provider != null else DataLoader.load_json("res://data/runtime/season_1/j14_runtime_map.json").get("day_start", {}).duplicate(true)
	if active_day == "J14": return j15_provider.day_start_presentation() if j15_provider != null else DataLoader.load_json("res://data/runtime/season_1/j15_runtime_map.json").get("day_start", {}).duplicate(true)
	if active_day == "J15": return j16_provider.day_start_presentation() if j16_provider != null else DataLoader.load_json("res://data/runtime/season_1/j16_runtime_map.json").get("day_start", {}).duplicate(true)
	if active_day == "J16": return j17_provider.day_start_presentation() if j17_provider != null else DataLoader.load_json("res://data/runtime/season_1/j17_runtime_map.json").get("day_start", {}).duplicate(true)
	if active_day=="J17":return DataLoader.load_json("res://data/runtime/season_1/j18_runtime_map.json").day_start.duplicate(true)
	return {}

func content_end() -> Dictionary:
	if active_day == "J18" and j18_provider.phase == "complete": return j18_provider.runtime_map.get("day_end", {}).duplicate(true)
	return {}

func begin_j11_foundation_handoff() -> Dictionary:
	if active_day != "J10" or j10_provider == null or j10_provider.phase != "complete":
		return {"accepted": false}
	if not _handoff_to_j11():
		return {"accepted": false}
	var result: Dictionary = j11_provider.start_day()
	result["playable_handoff"] = true
	return result

func pending_transition_flow() -> Dictionary:
	if active_day == "J01":
		if not j01_provider.pending_transition.is_empty(): return j01_provider.pending_transition.duplicate(true)
		if j01_provider.day_end_visible: return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J02":
		if not j02_provider.pending_transition.is_empty(): return j02_provider.pending_transition.duplicate(true)
		if j02_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
		if j02_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j02_provider.day_start_presentation(), "resume_action": "start_day"}
	if active_day == "J03":
		if not j03_provider.pending_transition.is_empty(): return j03_provider.pending_transition.duplicate(true)
		if j03_provider.phase == "complete": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
		if j03_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j03_provider.day_start_presentation(), "resume_action": "start_day"}
	if active_day == "J04":
		if not j04_provider.pending_transition.is_empty(): return j04_provider.pending_transition.duplicate(true)
		if j04_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j04_provider.day_start_presentation(), "resume_action": "start_day"}
		if j04_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J05":
		if not j05_provider.pending_transition.is_empty(): return j05_provider.pending_transition.duplicate(true)
		if j05_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j05_provider.day_start_presentation(), "resume_action": "start_day"}
		if j05_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J06":
		if not j06_provider.pending_transition.is_empty(): return j06_provider.pending_transition.duplicate(true)
		if j06_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j06_provider.day_start_presentation(), "resume_action": "start_day"}
		if j06_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J07":
		if not j07_provider.pending_transition.is_empty(): return j07_provider.pending_transition.duplicate(true)
		if j07_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j07_provider.day_start_presentation(), "resume_action": "start_day"}
		if j07_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J08":
		if not j08_provider.pending_transition.is_empty(): return j08_provider.pending_transition.duplicate(true)
		if j08_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j08_provider.day_start_presentation(), "resume_action": "start_day"}
		if j08_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J09":
		if not j09_provider.pending_transition.is_empty(): return j09_provider.pending_transition.duplicate(true)
		if j09_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j09_provider.day_start_presentation(), "resume_action": "start_day"}
		if j09_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J10":
		if not j10_provider.pending_transition.is_empty(): return j10_provider.pending_transition.duplicate(true)
		if j10_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j10_provider.day_start_presentation(), "resume_action": "start_day"}
		if j10_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J11":
		if not j11_provider.pending_transition.is_empty(): return j11_provider.pending_transition.duplicate(true)
		if j11_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j11_provider.day_start_presentation(), "resume_action": "start_day"}
		if j11_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J12":
		if not j12_provider.pending_transition.is_empty(): return j12_provider.pending_transition.duplicate(true)
		if j12_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j12_provider.day_start_presentation(), "resume_action": "start_day"}
		if j12_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J13":
		if not j13_provider.pending_transition.is_empty(): return j13_provider.pending_transition.duplicate(true)
		if j13_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j13_provider.day_start_presentation(), "resume_action": "start_day"}
		if j13_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J14":
		if not j14_provider.pending_transition.is_empty(): return j14_provider.pending_transition.duplicate(true)
		if j14_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j14_provider.day_start_presentation(), "resume_action": "start_day"}
		if j14_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J15":
		if not j15_provider.pending_transition.is_empty(): return j15_provider.pending_transition.duplicate(true)
		if j15_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j15_provider.day_start_presentation(), "resume_action": "start_day"}
		if j15_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J16":
		if not j16_provider.pending_transition.is_empty(): return j16_provider.pending_transition.duplicate(true)
		if j16_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j16_provider.day_start_presentation(), "resume_action": "start_day"}
		if j16_provider.phase == "complete": return {"flow_phases": ["NIGHT", "NEW_DAY"], "next_day_presentation": next_day_presentation(), "resume_action": "automatic_day_handoff"}
	if active_day == "J17":
		if not j17_provider.pending_transition.is_empty(): return j17_provider.pending_transition.duplicate(true)
		if j17_provider.phase == "day_start_pending": return {"flow_phases": ["NEW_DAY"], "next_day_presentation": j17_provider.day_start_presentation(), "resume_action": "start_day"}
		if j17_provider.phase=="complete":return {"flow_phases":["NIGHT","NEW_DAY"],"next_day_presentation":next_day_presentation(),"resume_action":"automatic_day_handoff"}
	if active_day=="J18":
		if not j18_provider.pending_transition.is_empty():return j18_provider.pending_transition.duplicate(true)
		if j18_provider.phase=="day_start_pending":return {"flow_phases":["NEW_DAY"],"next_day_presentation":j18_provider.day_start_presentation(),"resume_action":"start_day"}
	return {}

func complete_pending_transition_flow(resume_action: String) -> Dictionary:
	if resume_action == "automatic_day_handoff": return automatic_day_handoff()
	if resume_action == "start_day" and active_day in ["J02", "J03", "J04", "J05", "J06", "J07", "J08", "J09", "J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18"] and active_provider.phase == "day_start_pending": return active_provider.start_day()
	return {"accepted": false}

func _handoff_to_j02() -> void:
	j01_snapshot = j01_provider.progress_snapshot()
	j02_provider = J02_SCRIPT.new()
	j02_provider.initialize(state, j01_provider.transcripts_by_thread, j01_provider.produced_message_ids, j01_provider.unlocked_thread_ids)
	active_day = "J02"; active_provider = j02_provider

func _handoff_to_j03() -> bool:
	var candidate = J03_SCRIPT.new()
	if not candidate.initialize(state, j02_provider.transcripts_by_thread, j02_provider.produced_message_ids, j02_provider.unlocked_thread_ids, j02_provider.gallery_asset_ids): return false
	j02_snapshot = j02_provider.snapshot(); j03_provider = candidate
	active_day = "J03"; active_provider = j03_provider
	return true

func _handoff_to_j04() -> bool:
	var candidate = J04_SCRIPT.new()
	if not candidate.initialize(state, j03_provider.transcripts_by_thread, j03_provider.produced_message_ids, j03_provider.unlocked_thread_ids, j03_provider.gallery_asset_ids): return false
	j03_snapshot = j03_provider.snapshot(); j04_provider = candidate
	active_day = "J04"; active_provider = j04_provider
	return true

func _handoff_to_j05() -> bool:
	var candidate = J05_SCRIPT.new()
	if not candidate.initialize(state, j04_provider.transcripts_by_thread, j04_provider.produced_message_ids, j04_provider.unlocked_thread_ids, j04_provider.gallery_asset_ids): return false
	j04_snapshot = j04_provider.snapshot(); j05_provider = candidate
	active_day = "J05"; active_provider = j05_provider
	return true

func _handoff_to_j06() -> bool:
	var candidate = J06_SCRIPT.new()
	if not candidate.initialize(state, j05_provider.transcripts_by_thread, j05_provider.produced_message_ids, j05_provider.unlocked_thread_ids, j05_provider.gallery_asset_ids): return false
	j05_snapshot = j05_provider.snapshot(); j06_provider = candidate
	active_day = "J06"; active_provider = j06_provider
	return true

func _handoff_to_j07() -> bool:
	var candidate = J07_SCRIPT.new()
	if not candidate.initialize(state, j06_provider.transcripts_by_thread, j06_provider.produced_message_ids, j06_provider.unlocked_thread_ids, j06_provider.gallery_asset_ids): return false
	j06_snapshot = j06_provider.snapshot(); j07_provider = candidate
	active_day = "J07"; active_provider = j07_provider
	return true

func _handoff_to_j08() -> bool:
	var candidate = J08_SCRIPT.new()
	if not candidate.initialize(state, j07_provider.transcripts_by_thread, j07_provider.produced_message_ids, j07_provider.unlocked_thread_ids, j07_provider.gallery_asset_ids): return false
	j07_snapshot = j07_provider.snapshot(); j08_provider = candidate
	active_day = "J08"; active_provider = j08_provider
	return true

func _handoff_to_j09() -> bool:
	var candidate = J09_SCRIPT.new()
	if not candidate.initialize(state, j08_provider.transcripts_by_thread, j08_provider.produced_message_ids, j08_provider.unlocked_thread_ids, j08_provider.gallery_asset_ids): return false
	j08_snapshot = j08_provider.snapshot(); j09_provider = candidate
	active_day = "J09"; active_provider = j09_provider
	return true

func _handoff_to_j10() -> bool:
	var candidate = J10_SCRIPT.new()
	if not candidate.initialize(state, j09_provider.transcripts_by_thread, j09_provider.produced_message_ids, j09_provider.unlocked_thread_ids, j09_provider.gallery_asset_ids): return false
	j09_snapshot = j09_provider.snapshot(); j10_provider = candidate
	active_day = "J10"; active_provider = j10_provider
	return true

func _handoff_to_j11() -> bool:
	var candidate = J11_SCRIPT.new()
	if not candidate.initialize(state, j10_provider.transcripts_by_thread, j10_provider.produced_message_ids, j10_provider.unlocked_thread_ids, j10_provider.gallery_asset_ids): return false
	j10_snapshot = j10_provider.snapshot(); j11_provider = candidate
	active_day = "J11"; active_provider = j11_provider
	return true

func _handoff_to_j12() -> bool:
	var candidate = J12_SCRIPT.new()
	if not candidate.initialize(state, j11_provider.transcripts_by_thread, j11_provider.produced_message_ids, j11_provider.unlocked_thread_ids, j11_provider.gallery_asset_ids): return false
	j11_snapshot = j11_provider.snapshot(); j12_provider = candidate
	active_day = "J12"; active_provider = j12_provider
	return true

func _handoff_to_j13() -> bool:
	var candidate = J13_SCRIPT.new()
	if not candidate.initialize(state, j12_provider.transcripts_by_thread, j12_provider.produced_message_ids, j12_provider.unlocked_thread_ids, j12_provider.gallery_asset_ids): return false
	j12_snapshot = j12_provider.snapshot(); j13_provider = candidate; active_day = "J13"; active_provider = j13_provider; return true

func _handoff_to_j14() -> bool:
	var candidate = J14_SCRIPT.new()
	if not candidate.initialize(state, j13_provider.transcripts_by_thread, j13_provider.produced_message_ids, j13_provider.unlocked_thread_ids, j13_provider.gallery_asset_ids): return false
	j13_snapshot = j13_provider.snapshot(); j14_provider = candidate; active_day = "J14"; active_provider = j14_provider; return true

func _handoff_to_j15() -> bool:
	var candidate = J15_SCRIPT.new()
	if not candidate.initialize(state, j14_provider.transcripts_by_thread, j14_provider.produced_message_ids, j14_provider.unlocked_thread_ids, j14_provider.gallery_asset_ids): return false
	j14_snapshot = j14_provider.snapshot(); j15_provider = candidate; active_day = "J15"; active_provider = j15_provider; return true

func _handoff_to_j16() -> bool:
	var candidate = J16_SCRIPT.new()
	if not candidate.initialize(state, j15_provider.transcripts_by_thread, j15_provider.produced_message_ids, j15_provider.unlocked_thread_ids, j15_provider.gallery_asset_ids): return false
	j15_snapshot = j15_provider.snapshot(); j16_provider = candidate; active_day = "J16"; active_provider = j16_provider; return true

func _handoff_to_j17() -> bool:
	var candidate=J17_SCRIPT.new()
	if not candidate.initialize(state,j16_provider.transcripts_by_thread,j16_provider.produced_message_ids,j16_provider.unlocked_thread_ids,j16_provider.gallery_asset_ids):return false
	j16_snapshot=j16_provider.snapshot(); j17_provider=candidate; active_day="J17"; active_provider=j17_provider; return true

func _handoff_to_j18()->bool:
	var candidate=J18_SCRIPT.new();if not candidate.initialize(state,j17_provider.transcripts_by_thread,j17_provider.produced_message_ids,j17_provider.unlocked_thread_ids,j17_provider.gallery_asset_ids):return false
	j18_provider=candidate;active_day="J18";active_provider=candidate;return true

func snapshot() -> Dictionary:
	return {"version": SNAPSHOT_VERSION, "active_day": active_day, "state": state.snapshot(), "provider_snapshots": {
		"J01": j01_provider.progress_snapshot(), "J02": j02_provider.snapshot() if j02_provider != null else {},
		"J03": j03_provider.snapshot() if j03_provider != null else {}, "J04": j04_provider.snapshot() if j04_provider != null else {},
		"J05": j05_provider.snapshot() if j05_provider != null else {},
		"J06": j06_provider.snapshot() if j06_provider != null else {},
		"J07": j07_provider.snapshot() if j07_provider != null else {},
		"J08": j08_provider.snapshot() if j08_provider != null else {},
		"J09": j09_provider.snapshot() if j09_provider != null else {},
		"J10": j10_provider.snapshot() if j10_provider != null else {},
		"J11": j11_provider.snapshot() if j11_provider != null else {},
		"J12": j12_provider.snapshot() if j12_provider != null else {},
		"J13": j13_provider.snapshot() if j13_provider != null else {},
		"J14": j14_provider.snapshot() if j14_provider != null else {},
		"J15": j15_provider.snapshot() if j15_provider != null else {},
		"J16": j16_provider.snapshot() if j16_provider != null else {},
		"J17": j17_provider.snapshot() if j17_provider != null else {},
		"J18": j18_provider.snapshot() if j18_provider != null else {},
	}}

func restore_snapshot(value: Dictionary) -> bool:
	var version := int(value.get("version", -1))
	if version not in [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,SNAPSHOT_VERSION] or str(value.get("active_day","")) not in ["J01","J02","J03","J04","J05","J06","J07","J08","J09","J10","J11","J12","J13","J14","J15","J16","J17","J18"]:return false
	if version < 4 and str(value.get("active_day", "")) == "J05": return false
	if version < 5 and str(value.get("active_day", "")) == "J06": return false
	if version < 6 and str(value.get("active_day", "")) == "J07": return false
	if version < 7 and str(value.get("active_day", "")) == "J08": return false
	if version < 8 and str(value.get("active_day", "")) == "J09": return false
	if version < 9 and str(value.get("active_day", "")) == "J10": return false
	if version < 11 and str(value.get("active_day", "")) == "J11": return false
	if version < 12 and str(value.get("active_day", "")) == "J12": return false
	if version < 13 and str(value.get("active_day", "")) == "J13": return false
	if version < 14 and str(value.get("active_day", "")) == "J14": return false
	if version < 15 and str(value.get("active_day", "")) == "J15": return false
	if version < 16 and str(value.get("active_day", "")) == "J16": return false
	if version < 17 and str(value.get("active_day", "")) == "J17": return false
	if version<SNAPSHOT_VERSION and str(value.get("active_day",""))=="J18":return false
	if typeof(value.get("state")) != TYPE_DICTIONARY or typeof(value.get("provider_snapshots")) != TYPE_DICTIONARY: return false
	var providers: Dictionary = value["provider_snapshots"]
	for id in ["J01", "J02", "J03"]:
		if typeof(providers.get(id)) != TYPE_DICTIONARY: return false
	if version >= 3 and typeof(providers.get("J04")) != TYPE_DICTIONARY: return false
	if version >= 4 and typeof(providers.get("J05")) != TYPE_DICTIONARY: return false
	if version >= 5 and typeof(providers.get("J06")) != TYPE_DICTIONARY: return false
	if version >= 6 and typeof(providers.get("J07")) != TYPE_DICTIONARY: return false
	if version >= 7 and typeof(providers.get("J08")) != TYPE_DICTIONARY: return false
	if version >= 8 and typeof(providers.get("J09")) != TYPE_DICTIONARY: return false
	if version >= 9 and typeof(providers.get("J10")) != TYPE_DICTIONARY: return false
	if version >= 11 and typeof(providers.get("J11")) != TYPE_DICTIONARY: return false
	if version >= 12 and typeof(providers.get("J12")) != TYPE_DICTIONARY: return false
	if version >= 13 and typeof(providers.get("J13")) != TYPE_DICTIONARY: return false
	if version >= 14 and typeof(providers.get("J14")) != TYPE_DICTIONARY: return false
	if version >= 15 and typeof(providers.get("J15")) != TYPE_DICTIONARY: return false
	if version >= 16 and typeof(providers.get("J16")) != TYPE_DICTIONARY: return false
	if version >= 17 and typeof(providers.get("J17")) != TYPE_DICTIONARY: return false
	if version==SNAPSHOT_VERSION and typeof(providers.get("J18"))!=TYPE_DICTIONARY:return false
	state_restore_count += 1
	if not state.restore_snapshot(value["state"]): return false
	if not j01_provider.restore_progress_snapshot(providers["J01"]): return false
	j01_snapshot = providers["J01"].duplicate(true); active_day = str(value["active_day"])
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
	if active_day == "J03": active_provider = j03_provider; return true
	j04_provider = J04_SCRIPT.new()
	if not j04_provider.initialize(state, j03_provider.transcripts_by_thread, j03_provider.produced_message_ids, j03_provider.unlocked_thread_ids, j03_provider.gallery_asset_ids): return false
	if not j04_provider.restore_snapshot(providers.get("J04", {})): return false
	j04_snapshot = providers["J04"].duplicate(true)
	if active_day == "J04":
		active_provider = j04_provider
		return true
	j05_provider = J05_SCRIPT.new()
	if not j05_provider.initialize(state, j04_provider.transcripts_by_thread, j04_provider.produced_message_ids, j04_provider.unlocked_thread_ids, j04_provider.gallery_asset_ids): return false
	if not j05_provider.restore_snapshot(providers.get("J05", {})): return false
	j05_snapshot = providers["J05"].duplicate(true)
	if active_day == "J05":
		active_provider = j05_provider
		return true
	j06_provider = J06_SCRIPT.new()
	if not j06_provider.initialize(state, j05_provider.transcripts_by_thread, j05_provider.produced_message_ids, j05_provider.unlocked_thread_ids, j05_provider.gallery_asset_ids): return false
	if not j06_provider.restore_snapshot(providers.get("J06", {})): return false
	j06_snapshot = providers["J06"].duplicate(true)
	if active_day == "J06":
		active_provider = j06_provider
		return true
	j07_provider = J07_SCRIPT.new()
	if not j07_provider.initialize(state, j06_provider.transcripts_by_thread, j06_provider.produced_message_ids, j06_provider.unlocked_thread_ids, j06_provider.gallery_asset_ids): return false
	if not j07_provider.restore_snapshot(providers.get("J07", {})): return false
	j07_snapshot = providers["J07"].duplicate(true)
	if active_day == "J07":
		active_provider = j07_provider
		return true
	j08_provider = J08_SCRIPT.new()
	if not j08_provider.initialize(state, j07_provider.transcripts_by_thread, j07_provider.produced_message_ids, j07_provider.unlocked_thread_ids, j07_provider.gallery_asset_ids): return false
	if not j08_provider.restore_snapshot(providers.get("J08", {})): return false
	j08_snapshot = providers["J08"].duplicate(true)
	if active_day == "J08":
		active_provider = j08_provider
		return true
	j09_provider = J09_SCRIPT.new()
	if not j09_provider.initialize(state, j08_provider.transcripts_by_thread, j08_provider.produced_message_ids, j08_provider.unlocked_thread_ids, j08_provider.gallery_asset_ids): return false
	if not j09_provider.restore_snapshot(providers.get("J09", {})): return false
	j09_snapshot = providers["J09"].duplicate(true)
	if active_day == "J09":
		active_provider = j09_provider
		return true
	j10_provider = J10_SCRIPT.new()
	if not j10_provider.initialize(state, j09_provider.transcripts_by_thread, j09_provider.produced_message_ids, j09_provider.unlocked_thread_ids, j09_provider.gallery_asset_ids): return false
	if not j10_provider.restore_snapshot(providers.get("J10", {})): return false
	j10_snapshot = providers["J10"].duplicate(true)
	if active_day == "J10":
		active_provider = j10_provider
		return true
	j11_provider = J11_SCRIPT.new()
	if not j11_provider.initialize(state, j10_provider.transcripts_by_thread, j10_provider.produced_message_ids, j10_provider.unlocked_thread_ids, j10_provider.gallery_asset_ids): return false
	if not j11_provider.restore_snapshot(providers.get("J11", {})): return false
	j11_snapshot = providers["J11"].duplicate(true); active_provider = j11_provider
	if active_day == "J11": return true
	j12_provider = J12_SCRIPT.new()
	if not j12_provider.initialize(state, j11_provider.transcripts_by_thread, j11_provider.produced_message_ids, j11_provider.unlocked_thread_ids, j11_provider.gallery_asset_ids): return false
	if not j12_provider.restore_snapshot(providers.get("J12", {})): return false
	j12_snapshot = providers["J12"].duplicate(true); active_provider = j12_provider
	if active_day == "J12": return true
	j13_provider = J13_SCRIPT.new()
	if not j13_provider.initialize(state, j12_provider.transcripts_by_thread, j12_provider.produced_message_ids, j12_provider.unlocked_thread_ids, j12_provider.gallery_asset_ids): return false
	if not j13_provider.restore_snapshot(providers.get("J13", {})): return false
	j13_snapshot = providers["J13"].duplicate(true); active_provider = j13_provider
	if active_day == "J13": return true
	j14_provider = J14_SCRIPT.new()
	if not j14_provider.initialize(state, j13_provider.transcripts_by_thread, j13_provider.produced_message_ids, j13_provider.unlocked_thread_ids, j13_provider.gallery_asset_ids): return false
	if not j14_provider.restore_snapshot(providers.get("J14", {})): return false
	j14_snapshot = providers["J14"].duplicate(true); active_provider = j14_provider
	if active_day == "J14": return true
	j15_provider = J15_SCRIPT.new()
	if not j15_provider.initialize(state, j14_provider.transcripts_by_thread, j14_provider.produced_message_ids, j14_provider.unlocked_thread_ids, j14_provider.gallery_asset_ids): return false
	if not j15_provider.restore_snapshot(providers.get("J15", {})): return false
	j15_snapshot = providers["J15"].duplicate(true); active_provider = j15_provider
	if active_day == "J15": return true
	j16_provider = J16_SCRIPT.new()
	if not j16_provider.initialize(state, j15_provider.transcripts_by_thread, j15_provider.produced_message_ids, j15_provider.unlocked_thread_ids, j15_provider.gallery_asset_ids): return false
	if not j16_provider.restore_snapshot(providers.get("J16", {})): return false
	j16_snapshot = providers["J16"].duplicate(true); active_provider = j16_provider
	if active_day == "J16":return true
	j17_provider=J17_SCRIPT.new()
	if not j17_provider.initialize(state,j16_provider.transcripts_by_thread,j16_provider.produced_message_ids,j16_provider.unlocked_thread_ids,j16_provider.gallery_asset_ids):return false
	if not j17_provider.restore_snapshot(providers.get("J17",{})):return false
	j17_snapshot=providers["J17"].duplicate(true);active_provider=j17_provider
	if active_day=="J17":return true
	j18_provider=J18_SCRIPT.new();if not j18_provider.initialize(state,j17_provider.transcripts_by_thread,j17_provider.produced_message_ids,j17_provider.unlocked_thread_ids,j17_provider.gallery_asset_ids):return false
	if not j18_provider.restore_snapshot(providers.get("J18",{})):return false
	active_provider=j18_provider;return true

func _count_j01(id: String) -> int:
	var count := 0
	for thread in j01_provider.transcripts_by_thread:
		for item in j01_provider.transcripts_by_thread[thread]:
			if str(item.get("message_id", "")) == id: count += 1
	return count
