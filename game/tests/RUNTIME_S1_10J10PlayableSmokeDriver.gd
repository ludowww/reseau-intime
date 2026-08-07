extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J09_PROVIDER := preload("res://scripts/runtime/season_1/J09RuntimeProvider.gd")
const J10_PROVIDER := preload("res://scripts/runtime/season_1/J10RuntimeProvider.gd")
const PIVOT_SELECTOR := preload("res://scripts/runtime/season_1/J10PivotSelector.gd")
const J09_SMOKE := preload("res://tests/RUNTIME_S1_09J09PlayableSmokeDriver.gd")
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")

const MARIE_THREAD := "thread_marie_private"
const SANDRA_THREAD := "thread_sandra_private"
const MATHILDE_THREAD := "thread_mathilde_private"
const RAPHAELLE_THREAD := "thread_raphaelle_private"
const NICO_THREAD := "thread_nico_private"
const NEW_ASSETS := [
	"S1_A3_J10_SCN_SANDRA_CAFE_HELD_01",
	"S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01",
	"S1_A3_J10_SCN_MATHILDE_SOCIAL_RESULT_01",
	"S1_A3_J10_DPH_RAPHAELLE_PROCESS_DETAIL_01",
	"S1_A3_J10_DPH_RAPHAELLE_PROCESS_COMPARISON_02",
	"S1_A3_J10_DPH_ANNEXE_MARIE_PUBLIC_01",
	"S1_A3_J10_DPH_ANNEXE_MATHILDE_PUBLIC_01",
]

var failures: Array[String] = []
var capture_dir := ""

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var requested_size := _parse_size(_arg("--runtime-size", "720x1280"))
	capture_dir = _arg("--capture-dir", OS.get_environment("CAPTURE_DIR"))
	get_window().size = requested_size
	_exercise_selector_matrix()
	print("J10_SMOKE selector complete")
	_exercise_state_outcomes_and_promises()
	print("J10_SMOKE state matrix complete")
	_exercise_fallback_provider_and_round_trip()
	print("J10_SMOKE fallback round trip complete")
	_exercise_provider_pivot_paths()
	print("J10_SMOKE provider pivot paths complete")
	await _exercise_real_surfaces(requested_size)
	print("J10_SMOKE real surfaces complete")
	_finish(requested_size)

func _exercise_selector_matrix() -> void:
	var selector = PIVOT_SELECTOR.new()
	var all := _all_eligible_snapshot()
	var before: Dictionary = all.duplicate(true)
	var tied: Dictionary = selector.select(all)
	_expect(tied == selector.select(all), "selector is deterministic")
	_expect(all == before, "selector performs no write")
	_expect(str(tied.get("pivot", "")) == "SANDRA" and str(tied.get("reason", "")) == "AUTHORED_ORDER", "authored tie selects Sandra")
	all["foreground_history"] = [
		{"character_id": "sandra", "function": "pivot"},
		{"character_id": "mathilde", "function": "pivot"},
		{"character_id": "raphaelle", "function": "pivot"},
	]
	var least: Dictionary = selector.select(all)
	_expect(str(least.get("pivot", "")) == "NICO" and str(least.get("reason", "")) == "LEAST_RECENT_FOREGROUND", "least recent foreground selects Nico")
	all["promises"]["nico_j07_thursday_conditional"] = {"status": "ACTIVE", "due_at": "J10 18:20"}
	var p07: Dictionary = selector.select(all)
	_expect(str(p07.get("pivot", "")) == "NICO" and str(p07.get("reason", "")) == "DUE_PROMISE_P07", "active due P07 has absolute priority")
	all["marie_j09_dinner_outcome"] = "NOT_OFFERED"
	_expect(str(selector.select(all).get("pivot", "")) == "NICO", "P07 priority remains above Marie consequence")
	all["promises"]["nico_j07_thursday_conditional"] = {"status": "REFUSED", "due_at": ""}
	var marie: Dictionary = selector.select(all)
	_expect(str(marie.get("pivot", "")) == "NONE" and str(marie.get("reason", "")) == "MARIE_CONSEQUENCE_PRIORITY", "Marie consequence overrides ordinary candidates")
	var closed := _all_eligible_snapshot()
	closed["traces"]["j01_sandra_lunch_memory_soft"]["current_state"] = "INACCESSIBLE"
	closed["traces"]["j06_mathilde_look_acknowledged_01"]["current_state"] = "INACCESSIBLE"
	closed["knowledge"].erase("fact_raphaelle_professional_relationship_exists")
	closed["traces"]["j07_nico_confidence_01"]["current_state"] = "INACCESSIBLE"
	var closed_result: Dictionary = selector.select(closed)
	_expect(str(closed_result.get("pivot", "")) == "NONE" and str(closed_result.get("reason", "")) == "ALL_ACCESS_CLOSED", "closed access yields bounded fallback")
	var none := SEASON_STATE.new().snapshot()
	none["current_day"] = "J10"
	none["marie_j09_dinner_outcome"] = "REFUSED"
	var none_result: Dictionary = selector.select(none)
	_expect(str(none_result.get("pivot", "")) == "NONE" and str(none_result.get("reason", "")) == "NO_ELIGIBLE_PIVOT", "structurally ineligible routes yield ordinary fallback")

func _exercise_state_outcomes_and_promises() -> void:
	_exercise_p07_transitions()
	_exercise_marie_transitions()
	var sandra_choices := [
		"choice_j10_sandra_calm_presence",
		"choice_j10_sandra_missing_named",
		"choice_j10_sandra_friendship_bounded",
		"choice_j10_sandra_saturday",
		"choice_j10_sandra_close",
	]
	for choice_id in sandra_choices:
		var state = _active_j10_state("SANDRA")
		_expect(state.apply_j10_sandra_outcome(choice_id), "Sandra outcome applies: " + choice_id)
		_expect(state.sandra_state == "RECONNECTION_OPEN", "Sandra state is not changed immediately")
		_expect(state.promises.has("sandra_cafe_saturday_1100") == (choice_id == "choice_j10_sandra_saturday"), "P11 exists only for Saturday")
	var mathilde_choices := ["choice_j10_mathilde_precise", "choice_j10_mathilde_effect", "choice_j10_mathilde_weather"]
	for choice_id in mathilde_choices:
		var state = _active_j10_state("MATHILDE")
		state.mathilde_state = "LOOK_ACKNOWLEDGED"
		_expect(state.establish_j10_mathilde_records(), "Mathilde T10/F13 establish")
		_expect(state.apply_j10_mathilde_outcome(choice_id), "Mathilde outcome applies: " + choice_id)
		_expect(state.traces.has("j10_mathilde_outfit_choice_01") == state.knowledge.has("fact_mathilde_chose_player_as_outfit_audience"), "T10 iff F13")
		var should_open: bool = choice_id != "choice_j10_mathilde_weather"
		_expect((state.mathilde_state == "INTENT_OPEN") == should_open, "Mathilde state evolves only on authored readings")
	var raphaelle_choices := ["choice_j10_raphaelle_visit", "choice_j10_raphaelle_remote", "choice_j10_raphaelle_result", "choice_j10_raphaelle_boundary"]
	for choice_id in raphaelle_choices:
		var state = _active_j10_state("RAPHAELLE")
		state.raphaelle_state = "PROFESSIONAL_ONLY"
		_expect(state.apply_j10_raphaelle_outcome(choice_id), "Raphaelle outcome applies: " + choice_id)
		_expect((state.raphaelle_state == "CREATIVE_ACCESS") == (choice_id == "choice_j10_raphaelle_visit"), "Raphaelle access opens only after bounded visit")
	var nico_choices := ["choice_j10_nico_difference", "choice_j10_nico_observation", "choice_j10_nico_close"]
	for choice_id in nico_choices:
		var state = _active_j10_state("NICO")
		_expect(state.apply_j10_nico_outcome(choice_id), "Nico outcome applies: " + choice_id)
		_expect(state.nico_state == "CONFIDENCE_ACTIVE", "Nico state stays bounded")
	var cancellation = _active_j10_state("NICO")
	cancellation.promises["nico_j07_thursday_conditional"] = {"status": "ACTIVE", "due_at": "J10 18:20"}
	_expect(cancellation.apply_j10_nico_1812_choice("choice_j10_nico_1812_cancel"), "18:12 cancellation applies only to active P07")
	_expect(cancellation.j10_pivot_outcome == "THURSDAY_MEETING_CANCELLED", "18:12 cancellation closes the selected Nico pivot")
	var paid_meeting = _active_j10_state("NICO")
	paid_meeting.promises["nico_j07_thursday_conditional"] = {"status": "ACTIVE", "due_at": "J10 18:20"}
	_expect(paid_meeting.apply_j10_nico_1812_choice("choice_j10_nico_1812_keep"), "18:12 maintains an already active P07")
	_expect(paid_meeting.pay_j10_nico_meeting(), "maintained P07 becomes PAID only after the off-phone meeting")
	_expect(str(paid_meeting.promises["nico_j07_thursday_conditional"].get("status", "")) == "PAID", "P07 payment is stored")
	var dinner_choices := [
		"choice_j10_dinner_pay", "choice_j10_dinner_late", "choice_j10_dinner_cancel",
		"choice_j10_fallback_join", "choice_j10_fallback_late", "choice_j10_fallback_absent",
	]
	for choice_id in dinner_choices:
		var state = _active_j10_state("NONE")
		if choice_id.begins_with("choice_j10_dinner_"):
			state.promises["marie_j09_dinner_j10_2030"] = {"status": "ACTIVE", "due_at": "J10 20:30"}
			state.marie_j10_dinner_resolution = "THURSDAY_DUE"
		else:
			state.marie_j10_dinner_resolution = "NOT_DUE"
		_expect(state.apply_j10_evening_choice(choice_id), "fallback outcome applies: " + choice_id)
		_expect(state.j10_pivot_outcome != "", "fallback stores a bounded outcome")

func _exercise_p07_transitions() -> void:
	for choice_id in ["choice_j10_nico_morning_confirm", "choice_j10_nico_morning_refuse"]:
		var state = _active_j10_state("")
		state.promises["nico_j07_thursday_conditional"] = {"status": "CONDITIONAL", "confirmation_deadline": "J10 12:00", "due_at": ""}
		_expect(state.apply_j10_nico_morning_choice(choice_id), "P07 morning choice applies: " + choice_id)
		var p07: Dictionary = state.promises["nico_j07_thursday_conditional"]
		if choice_id.ends_with("confirm"):
			_expect(str(p07.get("status", "")) == "ACTIVE" and str(p07.get("due_at", "")) == "J10 18:20", "confirmed P07 becomes due")
			_expect(str(p07.get("activated_at", "")) == "J10 11:43" and str(p07.get("accepted_at", "")) == "J10 11:43", "confirmed P07 stores signed times")
		else:
			_expect(str(p07.get("status", "")) == "REFUSED" and str(p07.get("due_at", "")) == "", "refused P07 stays undated")
	var expired = _active_j10_state("")
	expired.promises["nico_j07_thursday_conditional"] = {"status": "CONDITIONAL", "confirmation_deadline": "J10 12:00", "due_at": ""}
	_expect(expired.expire_j10_nico_morning_confirmation(), "P07 deadline expires")
	_expect(str(expired.promises["nico_j07_thursday_conditional"].get("status", "")) == "EXPIRED", "P07 is EXPIRED at noon")

func _exercise_marie_transitions() -> void:
	for choice_id in ["choice_j10_marie_keep_thursday", "choice_j10_marie_amend_friday", "choice_j10_marie_cancel_morning"]:
		var state = _active_j10_state("")
		state.promises["marie_j09_dinner_j10_2030"] = {"status": "ACTIVE", "due_at": "J10 20:30"}
		_expect(state.apply_j10_marie_morning_choice(choice_id), "P09 morning choice applies: " + choice_id)
		var p09: Dictionary = state.promises["marie_j09_dinner_j10_2030"]
		if choice_id.ends_with("keep_thursday"):
			_expect(str(p09.get("status", "")) == "ACTIVE" and not state.promises.has("marie_j09_dinner_friday_2030"), "Thursday is maintained alone")
		elif choice_id.ends_with("amend_friday"):
			var p10: Dictionary = state.promises.get("marie_j09_dinner_friday_2030", {})
			_expect(str(p09.get("status", "")) == "AMENDED" and str(p10.get("status", "")) == "ACTIVE", "P09 amends to one active P10")
		else:
			_expect(str(p09.get("status", "")) == "CANCELLED", "P09 morning cancellation closes")
	var friday = _active_j10_state("")
	friday.promises["marie_j09_dinner_friday_2030"] = {"status": "ACTIVE", "due_at": "J11 20:30"}
	var promise_count_before: int = friday.promises.size()
	_expect(friday.apply_j10_marie_morning_choice("choice_j10_marie_friday_confirm_guided"), "P10 guided confirmation applies")
	_expect(friday.promises.size() == promise_count_before and str(friday.promises["marie_j09_dinner_friday_2030"].get("status", "")) == "ACTIVE", "guided P10 confirmation creates nothing")

func _exercise_fallback_provider_and_round_trip() -> void:
	var helper = J09_SMOKE.new()
	var j09 = _completed_j09_provider(helper, "choice_j09_dinner_refuse")
	var provider = J10_PROVIDER.new()
	_expect(provider.initialize(j09.state, j09.transcripts_by_thread, j09.produced_message_ids, j09.unlocked_thread_ids, j09.gallery_asset_ids), "J10 fallback provider initializes")
	var start: Dictionary = provider.start_day()
	_expect(bool(start.get("accepted", false)) and provider.state.j10_pivot == "NONE", "fallback J10 starts through invisible selector")
	_expect_round_trip(provider, "fallback intermediate round trip")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j10_fallback_join")
	_confirm_transition_monotonic(provider)
	_expect(provider.phase == "complete" and provider.state.day_status == "COMPLETE", "fallback J10 reaches content end")
	_expect(provider.served_visual_beat_ids.is_empty(), "fallback serves no new J10 asset")
	_expect(_new_j10_gallery_delta(provider).is_empty(), "fallback unlocks no new J10 gallery parent")
	_expect_round_trip(provider, "fallback complete round trip")
	_collect_helper_failures(helper)
	helper.free()

func _exercise_provider_pivot_paths() -> void:
	var helper = J09_SMOKE.new()
	var j09 = _completed_j09_provider(helper, "choice_j09_dinner_refuse")
	var obsolete_snapshot: Dictionary = j09.state.snapshot()
	obsolete_snapshot["version"] = 7
	var obsolete_state = SEASON_STATE.new()
	_expect(not obsolete_state.restore_snapshot(obsolete_snapshot), "obsolete state v7 at completed J09 is rejected")
	_exercise_mathilde_provider(_clone_j09_state(j09.state))
	_exercise_raphaelle_provider(_clone_j09_state(j09.state))
	_exercise_nico_paid_provider(_clone_j09_state(j09.state))
	_exercise_p07_cancel_provider(_clone_j09_state(j09.state))
	_exercise_p07_expire_provider(_clone_j09_state(j09.state))
	_exercise_due_fallback_provider(_clone_j09_state(j09.state))
	_collect_helper_failures(helper)
	helper.free()

func _exercise_mathilde_provider(state) -> void:
	state.sandra_state = "DISTANT_FRIEND"
	state.raphaelle_state = "UNESTABLISHED"
	state.nico_state = "ORDINARY_FRIEND"
	state.mathilde_state = "LOOK_ACKNOWLEDGED"
	state.mathilde_j06_outcome = "ACKNOWLEDGED_RESPECTFUL"
	state.j06_external_continuity_resolution = "NO_PROMISE"
	state.traces["j02_mathilde_arrival_room_01"] = {"current_state": "ACTIVE"}
	state.traces["j06_mathilde_look_acknowledged_01"] = {"current_state": "ACTIVE", "current_audience": ["Mathilde", "Player"]}
	state.knowledge["fact_mathilde_stay_started"] = {"current_knowers": ["Marie", "Player", "Mathilde"]}
	state.knowledge["fact_mathilde_knows_player_noticed_her"] = {"initial_knowers": ["Mathilde", "Player"]}
	var provider = _new_j10_provider(state)
	provider.start_day()
	_expect(provider.state.j10_pivot == "MATHILDE", "Mathilde can be the sole eligible pivot")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, MATHILDE_THREAD)
	provider.apply_choice(MATHILDE_THREAD, "choice_j10_mathilde_effect")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j10_fallback_join")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, MATHILDE_THREAD)
	provider.apply_choice(MATHILDE_THREAD, "choice_j10_mathilde_after_effect_guided")
	_confirm_transition_monotonic(provider)
	_expect(provider.phase == "complete", "Mathilde provider path completes")
	_expect(provider.served_visual_beat_ids == ["S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01", "S1_A3_J10_SCN_MATHILDE_SOCIAL_RESULT_01"], "Mathilde serves exactly C10-02 and C10-03")
	_expect(provider.state.traces.has("j10_mathilde_outfit_choice_01") and provider.state.knowledge.has("fact_mathilde_chose_player_as_outfit_audience"), "Mathilde provider stores T10/F13 together")

func _exercise_raphaelle_provider(state) -> void:
	state.sandra_state = "DISTANT_FRIEND"
	state.mathilde_state = "FAMILY_GUEST"
	state.nico_state = "ORDINARY_FRIEND"
	state.raphaelle_state = "PROFESSIONAL_ONLY"
	state.raphaelle_j07_mobile_review_outcome = "RESPONSIBILITY_ACKNOWLEDGED"
	state.raphaelle_j08_work_resolution = "PAID_ON_TIME"
	state.promises["raphaelle_j07_mobile_review"]["status"] = "PAID"
	state.knowledge["fact_raphaelle_professional_relationship_exists"] = {"initial_knowers": ["Player"]}
	var provider = _new_j10_provider(state)
	provider.start_day()
	_expect(provider.state.j10_pivot == "RAPHAELLE", "Raphaelle can be the sole eligible pivot")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, RAPHAELLE_THREAD)
	provider.apply_choice(RAPHAELLE_THREAD, "choice_j10_raphaelle_process")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, RAPHAELLE_THREAD)
	provider.apply_choice(RAPHAELLE_THREAD, "choice_j10_raphaelle_comparison_guided")
	provider.apply_choice(RAPHAELLE_THREAD, "choice_j10_raphaelle_visit")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, RAPHAELLE_THREAD)
	_confirm_transition_monotonic(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j10_fallback_join")
	_confirm_transition_monotonic(provider)
	_expect(provider.phase == "complete", "Raphaelle R-A provider path completes")
	_expect(provider.served_visual_beat_ids == ["S1_A3_J10_DPH_RAPHAELLE_PROCESS_DETAIL_01", "S1_A3_J10_DPH_RAPHAELLE_PROCESS_COMPARISON_02"], "Raphaelle R-A serves exactly C10-04 and C10-05")

func _exercise_nico_paid_provider(state) -> void:
	state.sandra_state = "DISTANT_FRIEND"
	state.mathilde_state = "FAMILY_GUEST"
	state.raphaelle_state = "UNESTABLISHED"
	state.nico_state = "CONFIDENCE_ACTIVE"
	state.nico_j08_meeting_resolution = "PAID_SHORT"
	state.promises["nico_j07_tuesday_1845"] = {"status": "PAID"}
	state.promises.erase("nico_j07_thursday_conditional")
	state.traces["j07_nico_confidence_01"] = {"current_state": "ACTIVE", "current_audience": ["Player", "Nico"]}
	state.knowledge["fact_nico_received_player_confidence"] = {"initial_knowers": ["Nico", "Player"]}
	var provider = _new_j10_provider(state)
	provider.start_day()
	_expect(provider.state.j10_pivot == "NICO", "paid J08 Nico can be the sole eligible pivot")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j10_fallback_join")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, NICO_THREAD)
	provider.apply_choice(NICO_THREAD, "choice_j10_nico_core_guided")
	provider.apply_choice(NICO_THREAD, "choice_j10_nico_observation")
	_confirm_transition_monotonic(provider)
	_expect(provider.phase == "complete", "paid J08 Nico provider path completes")
	_expect(provider.served_visual_beat_ids == ["S1_A3_J10_DPH_ANNEXE_MARIE_PUBLIC_01", "S1_A3_J10_DPH_ANNEXE_MATHILDE_PUBLIC_01"], "Nico serves only the two public Annexe parents")

func _exercise_p07_cancel_provider(state) -> void:
	_configure_conditional_p07(state)
	var provider = _new_j10_provider(state)
	provider.start_day()
	_confirm_transition_monotonic(provider)
	_present_batch(provider, NICO_THREAD)
	provider.apply_choice(NICO_THREAD, "choice_j10_nico_morning_confirm")
	_expect(provider.state.j10_pivot == "NICO" and provider.state.j10_pivot_reason == "DUE_PROMISE_P07", "P07 confirmation selects Nico before all other pivots")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, NICO_THREAD)
	provider.apply_choice(NICO_THREAD, "choice_j10_nico_1812_cancel")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j10_fallback_join")
	_confirm_transition_monotonic(provider)
	_expect(provider.phase == "complete" and provider.state.j10_pivot_outcome == "THURSDAY_MEETING_CANCELLED", "18:12 cancellation closes without pivot replacement")
	_expect(provider.served_visual_beat_ids.is_empty(), "cancelled P07 serves no Annexe asset")

func _exercise_p07_expire_provider(state) -> void:
	_configure_conditional_p07(state)
	var provider = _new_j10_provider(state)
	provider.start_day()
	_confirm_transition_monotonic(provider)
	_present_batch(provider, NICO_THREAD)
	_expect(provider.commit_narrative_time(12 * 60), "provider advances the unanswered P07 confirmation to noon")
	var p07: Dictionary = provider.state.promises["nico_j07_thursday_conditional"]
	_expect(str(p07.get("status", "")) == "EXPIRED" and provider.state.nico_j10_morning_confirmation == "EXPIRED", "unanswered conditional P07 expires exactly at noon")
	_expect(provider.state.j10_pivot == "NONE", "expired P07 cannot activate Nico at 18:12")

func _configure_conditional_p07(state) -> void:
	state.sandra_state = "DISTANT_FRIEND"
	state.mathilde_state = "FAMILY_GUEST"
	state.raphaelle_state = "UNESTABLISHED"
	state.nico_state = "CONFIDENCE_ACTIVE"
	state.nico_j07_continuation_outcome = "THURSDAY_CONDITIONAL"
	state.promises.erase("nico_j07_tuesday_1845")
	state.promises["nico_j07_thursday_conditional"] = {"status": "CONDITIONAL", "confirmation_deadline": "J10 12:00", "due_at": ""}
	state.traces["j07_nico_confidence_01"] = {"current_state": "ACTIVE", "current_audience": ["Player", "Nico"]}
	state.knowledge["fact_nico_received_player_confidence"] = {"initial_knowers": ["Nico", "Player"]}

func _exercise_due_fallback_provider(state) -> void:
	state.sandra_state = "DISTANT_FRIEND"
	state.mathilde_state = "FAMILY_GUEST"
	state.raphaelle_state = "UNESTABLISHED"
	state.nico_state = "ORDINARY_FRIEND"
	state.marie_j09_dinner_outcome = "J10_ACCEPTED"
	var p09: Dictionary = state.promises.get("marie_j09_dinner_j10_2030", {})
	p09["status"] = "ACTIVE"
	p09["due_at"] = "J10 20:30"
	p09["accepted_by_player"] = true
	state.promises["marie_j09_dinner_j10_2030"] = p09
	var provider = _new_j10_provider(state)
	provider.start_day()
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j10_marie_keep_thursday")
	_expect(provider.state.j10_pivot == "NONE", "due dinner can remain the fallback when no exterior pivot is eligible")
	_confirm_transition_monotonic(provider)
	_present_batch(provider, MARIE_THREAD)
	provider.apply_choice(MARIE_THREAD, "choice_j10_dinner_pay")
	_confirm_transition_monotonic(provider)
	_confirm_transition_monotonic(provider)
	_expect(provider.phase == "complete" and provider.state.j10_pivot_outcome == "DUE_DINNER_PAID", "due fallback pays P09 and completes")
	_expect(provider.served_visual_beat_ids.is_empty(), "fallback due dinner serves no new asset")

func _new_j10_provider(state):
	var provider = J10_PROVIDER.new()
	_expect(provider.initialize(state, {}, {}, [MARIE_THREAD, SANDRA_THREAD, MATHILDE_THREAD, RAPHAELLE_THREAD, NICO_THREAD], []), "J10 provider fixture initializes")
	return provider

func _clone_j09_state(source):
	var clone = SEASON_STATE.new()
	_expect(clone.restore_snapshot(source.snapshot()), "completed J09 fixture clones through state snapshot")
	return clone

func _completed_j09_provider(helper, dinner_choice: String):
	var j08 = helper._completed_j08_provider("CLEAR_HOURS")
	var provider = J09_PROVIDER.new()
	_expect(provider.initialize(j08.state, j08.transcripts_by_thread, j08.produced_message_ids, j08.unlocked_thread_ids, j08.gallery_asset_ids), "J09 fixture initializes")
	helper._advance_to_complete(provider, "choice_j09_presence_early", "choice_j09_quality_active", dinner_choice)
	_collect_helper_failures(helper)
	_expect(provider.phase == "complete", "J09 fixture completes")
	return provider

func _exercise_real_surfaces(size: Vector2i) -> void:
	print("J10_SMOKE real surfaces start")
	var main = MAIN_SCENE.instantiate()
	main.get_node("PortraitShell").content_mode = "runtime_s1"
	add_child(main)
	await _frames(6)
	var shell = main.shell
	var messages = shell.messages_screen
	shell.set_safe_area_preset("none")
	shell.set_reduced_motion_enabled(true)
	messages.runtime_delivery_time_scale = 0.01
	messages.reading_speed_multiplier = 8.0
	var helper = J09_SMOKE.new()
	var j09 = _completed_j09_provider(helper, "choice_j09_dinner_j10")
	messages._start_runtime_day_card(j09.runtime_map["day_end"]["next_day_presentation"])
	await _frames(3)
	await _capture("j09_to_j10_handoff", size)
	print("J10_SMOKE handoff captured")
	_make_sandra_eligible(j09.state)
	var provider = J10_PROVIDER.new()
	_expect(provider.initialize(j09.state, j09.transcripts_by_thread, j09.produced_message_ids, j09.unlocked_thread_ids, j09.gallery_asset_ids), "UI J10 initializes")
	provider.start_day()
	_present_batch(provider, MARIE_THREAD)
	_mount_direct(messages, shell.runtime_provider, provider)
	messages.open_thread(MARIE_THREAD)
	await _frames(3)
	await _capture("marie_morning_j10", size)
	print("J10_SMOKE morning captured")
	_expect(messages.apply_runtime_choice("choice_j10_marie_keep_thursday"), "real MessagesScreen accepts the P09 maintenance choice")
	await _wait_until(
		func(): return not messages.runtime_delivery_active and not messages.transition_flow_active,
		900,
		"P09 maintenance UI delivery timed out",
	)
	if provider.phase == "sandra_open_incoming":
		_present_batch(provider, SANDRA_THREAD)
	_mount_direct(messages, shell.runtime_provider, provider)
	messages.open_thread(SANDRA_THREAD)
	await _frames(3)
	await _capture("pivot_choice_j10", size)
	print("J10_SMOKE pivot captured")
	_expect(messages.apply_runtime_choice("choice_j10_sandra_accept_now"), "real MessagesScreen accepts the Sandra availability choice")
	await _wait_until(
		func(): return not messages.runtime_delivery_active and not messages.transition_flow_active,
		900,
		"Sandra cafe UI delivery timed out",
	)
	if provider.phase == "sandra_after_incoming":
		_present_batch(provider, SANDRA_THREAD)
	_mount_direct(messages, shell.runtime_provider, provider)
	messages.open_thread(SANDRA_THREAD)
	_expect(messages.apply_runtime_choice("choice_j10_sandra_calm_presence"), "real MessagesScreen accepts the Sandra afterglow choice")
	await _wait_until(
		func(): return not messages.runtime_delivery_active and not messages.transition_flow_active,
		900,
		"Sandra afterglow UI delivery timed out",
	)
	if provider.phase == "evening_incoming":
		_present_batch(provider, MARIE_THREAD)
	_mount_direct(messages, shell.runtime_provider, provider)
	messages.open_thread(MARIE_THREAD)
	_expect(messages.apply_runtime_choice("choice_j10_dinner_pay"), "real MessagesScreen accepts the due dinner payment")
	await _wait_until(
		func(): return not messages.runtime_delivery_active and not messages.transition_flow_active,
		900,
		"dinner UI delivery timed out",
	)
	for _index in range(3):
		if provider.phase == "complete" or provider.pending_transition.is_empty():
			break
		messages._resume_authoritative_transition_flow()
		await get_tree().process_frame
		await get_tree().process_frame
		await _wait_until(
			func(): return not messages.runtime_delivery_active and not messages.transition_flow_active,
			900,
			"chained J10 UI transition timed out",
		)
	_expect(provider.phase == "complete", "MessagesScreen completes the chained dinner and J10 content-end transitions")
	_expect(provider.phase == "complete", "UI Sandra route completes J10")
	_expect(provider.served_visual_beat_ids == ["S1_A3_J10_SCN_SANDRA_CAFE_HELD_01"], "Sandra held route serves only C10-01")
	_mount_direct(messages, shell.runtime_provider, provider)
	shell.gallery_screen.refresh_content_source(shell.runtime_provider.gallery_source())
	shell.activate_gallery(false)
	shell.gallery_screen.select_character("sandra")
	await _frames(3)
	await _capture("gallery_j10", size)
	print("J10_SMOKE gallery captured")
	shell.activate_messages(false)
	messages._start_runtime_day_card(provider.runtime_map["day_end"])
	await _frames(3)
	await _capture("content_end_j10", size)
	print("J10_SMOKE content end captured")
	_expect(not bool(shell.describe_layout().get("has_vertical_crop", true)), "PortraitShell has no vertical crop")
	_expect(not bool(messages.describe_state().get("has_horizontal_crop", true)), "Messages has no horizontal crop")
	_collect_helper_failures(helper)
	helper.free()
	main.queue_free()
	await _frames(6)

func _make_sandra_eligible(state) -> void:
	state.sandra_state = "RECONNECTION_OPEN"
	state.sandra_j03_echo_outcome = "RESPONDED"
	state.sandra_j05_outcome = "THREAD_MAINTAINED"
	state.traces["j01_sandra_lunch_memory_soft"] = {
		"current_state": "ACTIVE",
		"current_audience": ["Sandra", "Player"],
	}
	state.knowledge["fact_player_saw_sandra_lunch_photo"] = {
		"initial_knowers": ["Player"],
	}

func _all_eligible_snapshot() -> Dictionary:
	return {
		"sandra_state": "RECONNECTION_OPEN",
		"sandra_j03_echo_outcome": "RESPONDED",
		"sandra_j05_outcome": "THREAD_MAINTAINED",
		"mathilde_state": "LOOK_ACKNOWLEDGED",
		"mathilde_j06_outcome": "ACKNOWLEDGED_RESPECTFUL",
		"j06_external_continuity_resolution": "NO_PROMISE",
		"raphaelle_state": "PROFESSIONAL_ONLY",
		"raphaelle_j07_mobile_review_outcome": "RESPONSIBILITY_ACKNOWLEDGED",
		"raphaelle_j08_work_resolution": "PAID_ON_TIME",
		"nico_state": "CONFIDENCE_ACTIVE",
		"nico_j08_meeting_resolution": "PAID_SHORT",
		"marie_j09_dinner_outcome": "REFUSED",
		"foreground_history": [],
		"promises": {
			"raphaelle_j07_mobile_review": {"status": "PAID"},
			"nico_j07_tuesday_1845": {"status": "PAID"},
		},
		"traces": {
			"j01_sandra_lunch_memory_soft": {"current_state": "ACTIVE", "current_audience": ["Sandra", "Player"]},
			"j02_mathilde_arrival_room_01": {"current_state": "ACTIVE"},
			"j06_mathilde_look_acknowledged_01": {"current_state": "ACTIVE", "current_audience": ["Mathilde", "Player"]},
			"j07_nico_confidence_01": {"current_state": "ACTIVE", "current_audience": ["Player", "Nico"]},
		},
		"knowledge": {
			"fact_player_saw_sandra_lunch_photo": {"initial_knowers": ["Player"]},
			"fact_mathilde_stay_started": {"current_knowers": ["Marie", "Player", "Mathilde"]},
			"fact_mathilde_knows_player_noticed_her": {"initial_knowers": ["Mathilde", "Player"]},
			"fact_raphaelle_professional_relationship_exists": {"initial_knowers": ["Player"]},
			"fact_nico_received_player_confidence": {"initial_knowers": ["Nico", "Player"]},
		},
	}

func _active_j10_state(pivot: String):
	var state = SEASON_STATE.new()
	state.current_day = "J10"
	state.day_status = "ACTIVE"
	state.j10_pivot = pivot
	state.j10_pivot_reason = "AUTHORED_ORDER" if pivot not in ["", "NONE"] else ("NO_ELIGIBLE_PIVOT" if pivot == "NONE" else "")
	state.marie_j10_dinner_resolution = "NOT_DUE"
	state.nico_j10_morning_confirmation = "NOT_DUE"
	state.sandra_state = "RECONNECTION_OPEN"
	state.mathilde_state = "LOOK_ACKNOWLEDGED"
	state.raphaelle_state = "PROFESSIONAL_ONLY"
	state.nico_state = "CONFIDENCE_ACTIVE"
	return state

func _confirm_transition_monotonic(provider) -> Dictionary:
	var before: int = int(provider.current_narrative_time_minutes())
	var transition: Dictionary = provider.pending_transition.duplicate(true)
	var target_text := str(transition.get("to_time", ""))
	if target_text != "":
		var target: int = NARRATIVE_TIME.parse_narrative_time(target_text)
		_expect(target >= before, "narrative time never regresses from %s to %s on %s" % [NARRATIVE_TIME.format_narrative_time(before), target_text, str(transition.get("kind", ""))])
		if target >= before:
			_expect(provider.commit_narrative_time(target), "transition time commits for " + str(transition.get("kind", "")))
	var result: Dictionary = provider.confirm_transition()
	_expect(bool(result.get("accepted", false)), "transition confirms for " + str(transition.get("kind", "")))
	_expect(provider.current_narrative_time_minutes() >= before, "confirmed transition preserves monotonic narrative time")
	return result

func _expect_round_trip(provider, label: String) -> void:
	var state_snapshot: Dictionary = provider.state.snapshot()
	var provider_snapshot: Dictionary = provider.snapshot()
	var restored_state = SEASON_STATE.new()
	var restored = J10_PROVIDER.new()
	_expect(restored_state.restore_snapshot(state_snapshot), label + " state restore")
	_expect(restored.initialize(restored_state, {}, {}, [], []), label + " provider initialize")
	_expect(restored.restore_snapshot(provider_snapshot), label + " provider restore")
	_expect(restored.snapshot() == provider_snapshot, label + " provider snapshot is exact")
	_expect(restored_state.snapshot() == state_snapshot, label + " state snapshot is exact")

func _new_j10_gallery_delta(provider) -> Array:
	var result: Array = []
	for asset_id in provider.gallery_asset_ids:
		if asset_id in NEW_ASSETS:
			result.append(asset_id)
	return result

func _present_batch(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 10 and not bool(message.get("is_player", false)):
			provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "batch presented for %s in %s" % [thread_id, provider.phase])

func _mount_direct(messages, season, provider) -> void:
	season.state = provider.state
	season.j10_provider = provider
	season.active_day = "J10"
	season.active_provider = provider
	messages.day_transition.reset_surface()
	messages.day_transition_state = {}
	messages._set_gallery_navigation_blocked(false)
	_reset_messages_to_authority(messages, season)

func _reset_messages_to_authority(messages, provider) -> void:
	messages.runtime_delivery_cancelled = true
	messages.runtime_delivery_active = false
	messages.runtime_delivery_request_id += 1
	messages.transition_flow_active = false
	messages.transition_flow_request_id += 1
	messages.time_passage_overlay.cancel_flow()
	messages.active_thread_id = ""
	messages.screen_mode = "list"
	messages.runtime_provider_transcript_by_thread.clear()
	messages.runtime_presented_message_ids_by_thread.clear()
	messages.runtime_pending_messages_by_thread.clear()
	messages.runtime_pending_choices_by_thread.clear()
	messages.runtime_pending_transition_by_thread.clear()
	var source: Dictionary = provider.presentation_source()
	messages._initialize_runtime_source(source)
	for raw_thread_id in source.get("messages_by_thread", {}):
		var thread_id := str(raw_thread_id)
		var historical: Array[Dictionary] = messages._dictionary_array(source["messages_by_thread"][raw_thread_id])
		messages.transcripts[thread_id] = historical
		var ids: Array = []
		for message in historical:
			ids.append(str(message.get("message_id", "")))
		messages.runtime_presented_message_ids_by_thread[thread_id] = ids
	messages._reconcile_runtime_source(source)
	messages._build()
	messages.runtime_delivery_cancelled = false

func _capture(label: String, size: Vector2i) -> void:
	if capture_dir == "" or DisplayServer.get_name() == "headless":
		return
	DirAccess.make_dir_recursive_absolute(capture_dir)
	await get_tree().process_frame
	var path := capture_dir.path_join("%dx%d_%s.png" % [size.x, size.y, label])
	var image: Image = get_viewport().get_texture().get_image()
	if image.get_size() != size:
		image.convert(Image.FORMAT_RGBA8)
		var canvas := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
		canvas.fill(Color("#02040C"))
		canvas.blit_rect(image, Rect2i(Vector2i.ZERO, image.get_size()), Vector2i((size.x - image.get_width()) / 2, (size.y - image.get_height()) / 2))
		image = canvas
	_expect(image.save_png(path) == OK, "capture failed: " + path)

func _collect_helper_failures(helper) -> void:
	for failure in helper.failures:
		failures.append("J09 helper: " + failure)
	helper.failures.clear()

func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame

func _wait_until(predicate: Callable, frames: int, failure: String) -> void:
	for _index in range(frames):
		if predicate.call():
			return
		await get_tree().process_frame
	_expect(false, failure)

func _arg(prefix: String, fallback: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="):
			return arg.trim_prefix(prefix + "=")
	return fallback

func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x")
	return Vector2i(int(parts[0]), int(parts[1])) if parts.size() == 2 else Vector2i.ZERO

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _finish(size: Vector2i) -> void:
	if failures.is_empty():
		print("RUNTIME-S1-10 J10 real PortraitMain smoke %dx%d: OK" % [size.x, size.y])
		get_tree().call_deferred("quit", 0)
		return
	for failure in failures:
		push_error(failure)
	print("RUNTIME-S1-10 J10 real PortraitMain smoke: FAILED (%d)" % failures.size())
	get_tree().call_deferred("quit", 1)
