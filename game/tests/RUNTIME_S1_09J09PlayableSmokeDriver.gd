extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const SEASON_PROVIDER := preload("res://scripts/runtime/season_1/Season1RuntimeProvider.gd")
const SEASON_STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const J09_PROVIDER := preload("res://scripts/runtime/season_1/J09RuntimeProvider.gd")
const J07_SMOKE := preload("res://tests/RUNTIME_S1_07J07PlayableSmokeDriver.gd")
const J08_SMOKE := preload("res://tests/RUNTIME_S1_08J08PlayableSmokeDriver.gd")

const MARIE_THREAD := "thread_marie_private"
const TRACE_IDS := [
	"j09_marie_black_dress_private_01",
	"j09_marie_laverriere_public_01",
	"j09_marie_laverriere_after_01",
]
const KNOWLEDGE_BY_TRACE := {
	"j09_marie_black_dress_private_01": "fact_player_received_marie_black_dress_image",
	"j09_marie_laverriere_public_01": "fact_marie_public_professional_version_visible",
	"j09_marie_laverriere_after_01": "fact_marie_recontextualized_evening_for_player",
}
const ASSET_IDS := [
	"S1_A3_J09_SCN_LAVERRIERE_INSTALLATION_01",
	"S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01",
	"S1_A3_J09_DPH_MARIE_LAVERRIERE_PUBLIC_01",
	"S1_A3_J09_DPH_MARIE_LAVERRIERE_AFTER_01",
]
const PATHS := [
	{"presence": "choice_j09_presence_early", "quality": "choice_j09_quality_active", "outcome": "presence_active", "dinner": true},
	{"presence": "choice_j09_presence_early", "quality": "choice_j09_quality_playful_useful", "outcome": "presence_playful_useful", "dinner": true},
	{"presence": "choice_j09_presence_early", "quality": "choice_j09_quality_distracted", "outcome": "presence_distracted", "dinner": false},
	{"presence": "choice_j09_presence_late", "quality": "choice_j09_quality_late_active", "outcome": "presence_late_active", "dinner": true},
	{"presence": "choice_j09_presence_late", "quality": "choice_j09_quality_spectator", "outcome": "presence_spectator", "dinner": false},
	{"presence": "choice_j09_presence_late", "quality": "choice_j09_quality_bounded", "outcome": "presence_bounded_reliable", "dinner": true},
	{"presence": "choice_j09_presence_absent", "quality": "", "outcome": "absence_honest", "dinner": true},
]
const DINNERS := [
	"choice_j09_dinner_j10",
	"choice_j09_dinner_friday",
	"choice_j09_dinner_refuse",
]

var failures: Array[String] = []
var capture_dir := ""

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var requested_size: Vector2i = _parse_size(_arg("--runtime-size", "720x1280"))
	capture_dir = _arg("--capture-dir", OS.get_environment("CAPTURE_DIR"))
	get_window().size = requested_size
	_exercise_all_paths()
	_exercise_j08_handoff_and_legacy_restore()
	await _exercise_real_surfaces(requested_size)
	_finish(requested_size)

func _exercise_all_paths() -> void:
	var path_index: int = 0
	for path in PATHS:
		var dinners: Array = DINNERS if bool(path["dinner"]) else [""]
		for dinner in dinners:
			var echo: String = ["CLEAR_HOURS", "HONEST_REFUSAL", "VAGUE_OR_MISSED"][path_index % 3]
			var j08 = _completed_j08_provider(echo)
			var relationships_before: Dictionary = _relationship_snapshot(j08.state)
			var cumulative_message_count: int = j08.produced_message_ids.size()
			var cumulative_gallery_count: int = j08.gallery_asset_ids.size()
			var provider = J09_PROVIDER.new()
			_expect(provider.initialize(j08.state, j08.transcripts_by_thread, j08.produced_message_ids, j08.unlocked_thread_ids, j08.gallery_asset_ids), "J09 initializes for " + str(path))
			var label: String = "%s/%s/%s" % [echo, str(path["outcome"]), dinner if dinner != "" else "no_dinner"]
			_advance_to_complete(provider, str(path["presence"]), str(path["quality"]), dinner)
			_expect(provider.phase == "complete" and provider.state.day_status == "COMPLETE", label + " completes")
			_expect(provider.state.marie_j09_presence_outcome == str(path["outcome"]), label + " stores exact presence outcome")
			_expect(provider.served_visual_beat_ids == ASSET_IDS, label + " serves four canonical visual parents once")
			_expect(provider.gallery_asset_ids.size() == cumulative_gallery_count + 4, label + " adds exactly four Marie gallery contents")
			for trace_id in TRACE_IDS:
				_expect(provider.state.traces.has(trace_id), label + " stores " + trace_id)
				_expect(not provider.gallery_asset_ids.has(trace_id), label + " never uses trace as gallery parent " + trace_id)
				var fact_id: String = str(KNOWLEDGE_BY_TRACE[trace_id])
				_expect(provider.state.knowledge.has(fact_id), label + " stores corresponding knowledge " + fact_id)
				_expect(str(provider.state.traces[trace_id].get("knowledge_created", "")) == fact_id, label + " pairs trace with " + fact_id)
				_expect(str(provider.state.knowledge[fact_id].get("source_ref", "")) == trace_id, label + " pairs knowledge with " + trace_id)
			for asset_id in ASSET_IDS:
				_expect(provider.gallery_asset_ids.count(asset_id) == 1, label + " gallery deduplicates " + asset_id)
				_expect(not provider.state.traces.has(asset_id), label + " never creates asset as narrative trace " + asset_id)
				_expect(not provider.state.resolved_visual_variant_by_asset.has(asset_id), label + " creates no visual variant for " + asset_id)
			var j09_trace_count: int = 0
			for trace_id in provider.state.traces:
				if TRACE_IDS.has(trace_id):
					j09_trace_count += 1
			_expect(j09_trace_count == 3, label + " creates exactly three J09 traces")
			var j09_knowledge_count: int = 0
			for fact_id in provider.state.knowledge:
				if KNOWLEDGE_BY_TRACE.values().has(fact_id):
					j09_knowledge_count += 1
			_expect(j09_knowledge_count == 3, label + " creates exactly three corresponding J09 knowledge entries")
			var f13: Dictionary = provider.state.knowledge.get("fact_marie_recontextualized_evening_for_player", {})
			_expect(str(f13.get("source_type", "")) == "PRIVATE_TRACE", label + " stores T09 knowledge as PRIVATE_TRACE")
			_expect(f13.get("initial_knowers", []) == ["Marie", "Player"], label + " stores exact T09 initial knowers")
			var gallery: Dictionary = provider.gallery_source()
			var marie_items: Array = gallery["fixtures"]["marie"]["items"]
			var j09_marie_items: Array = []
			for item in marie_items:
				if ASSET_IDS.has(str(item.get("asset_id", ""))):
					j09_marie_items.append(item)
			_expect(j09_marie_items.size() == 4, label + " exposes a four-content J09 delta under Marie")
			_expect(provider.state.knowledge.has("fact_player_received_marie_black_dress_image"), label + " stores F11")
			_expect(provider.state.knowledge.has("fact_marie_public_professional_version_visible"), label + " stores F12")
			_expect(provider.state.knowledge.has("fact_marie_recontextualized_evening_for_player"), label + " stores F13")
			_expect(provider.produced_message_ids.size() > cumulative_message_count, label + " preserves cumulative produced ids")
			_assert_unique_message_ids(provider, label)
			_assert_dinner(provider.state, dinner, label)
			var after_relationships: Dictionary = _relationship_snapshot(provider.state)
			if str(path["outcome"]) == "presence_distracted":
				_expect(after_relationships["couple"] == "STRAIN_VISIBLE", label + " activates the bounded couple consequence")
				after_relationships["couple"] = relationships_before["couple"]
			_expect(after_relationships == relationships_before, label + " preserves unrelated relationship states")
			_expect_round_trip(provider, label + " complete snapshot")
			path_index += 1

func _exercise_j08_handoff_and_legacy_restore() -> void:
	var j07_helper = J07_SMOKE.new()
	var j08_helper = J08_SMOKE.new()
	var season = j07_helper._season_at_completed_j06()
	season.automatic_day_handoff()
	season.confirm_transition()
	season.apply_choice("thread_raphaelle_private", "choice_j07_raphaelle_acknowledge_guided")
	season.apply_choice("thread_raphaelle_private", "choice_j07_raphaelle_understood_guided")
	season.confirm_transition()
	season.apply_choice("thread_nico_private", "choice_j07_nico_topic_guided")
	season.apply_choice("thread_nico_private", "choice_j07_nico_what_mean_guided")
	season.apply_choice("thread_nico_private", "choice_j07_nico_acknowledge_contradiction")
	season.apply_choice("thread_nico_private", "choice_j07_nico_at_least_said_guided")
	season.apply_choice("thread_nico_private", "choice_j07_nico_continuation_closed")
	season.confirm_transition()
	season.apply_choice(MARIE_THREAD, "choice_j07_marie_honest_refusal")
	season.confirm_transition()
	_expect(season.active_day == "J07" and season.j07_provider.phase == "complete", "full fixture completes J07")
	_expect(bool(season.confirm_day_transition().get("accepted", false)), "J07 hands off to pending J08")
	j08_helper._advance_to_collision(season.j08_provider, "choice_j08_raphaelle_schedule_1820")
	_present_batch(season.j08_provider, "thread_raphaelle_private", 8)
	j08_helper._finish_day(season.j08_provider)
	_collect_helper_failures(j08_helper)
	_expect(season.active_day == "J08" and season.j08_provider.phase == "complete", "full fixture completes J08")
	_expect(season.content_end().is_empty(), "J08 is no longer CONTENT_END")
	_expect(str(season.next_day_presentation().get("title", "")) == "Dans son élément", "J08 exposes J09 presentation")
	var legacy_snapshot: Dictionary = season.snapshot()
	legacy_snapshot["version"] = 7
	legacy_snapshot["provider_snapshots"].erase("J09")
	legacy_snapshot["state"]["version"] = 6
	for key in ["marie_j09_presence_choice", "marie_j09_presence_outcome", "marie_j09_dinner_outcome"]:
		legacy_snapshot["state"].erase(key)
	var restored = SEASON_PROVIDER.new()
	_expect(restored.initialize(), "legacy J08 restore target initializes")
	_expect(restored.restore_snapshot(legacy_snapshot), "season v7 active J08 with state v6 restores")
	_expect(restored.state_restore_count == 1, "legacy J08 restores shared Season1State once")
	_expect(restored.active_day == "J08" and restored.j08_provider.phase == "complete", "legacy restore remains at complete J08")
	_expect(restored.content_end().is_empty(), "legacy-restored J08 is handoff only")
	var handoff: Dictionary = restored.automatic_day_handoff()
	_expect(bool(handoff.get("accepted", false)), "legacy-restored J08 hands off to J09")
	_expect(restored.active_day == "J09" and restored.j09_provider.phase == "entry_incoming", "handoff starts canonical J09")
	_expect(restored.state.current_day == "J09" and restored.state.day_status == "ACTIVE", "handoff starts one shared state")
	var legacy_j09_snapshot: Dictionary = restored.snapshot()
	legacy_j09_snapshot["version"] = 8
	legacy_j09_snapshot["provider_snapshots"].erase("J10")
	legacy_j09_snapshot["state"]["version"] = 7
	for key in ["j10_pivot", "j10_pivot_reason", "j10_pivot_outcome", "marie_j10_dinner_resolution", "nico_j10_morning_confirmation"]:
		legacy_j09_snapshot["state"].erase(key)
	var restored_j09 = SEASON_PROVIDER.new()
	_expect(restored_j09.initialize(), "legacy J09 restore target initializes")
	_expect(restored_j09.restore_snapshot(legacy_j09_snapshot), "season v8 active J09 with state v7 restores")
	_expect(restored_j09.state_restore_count == 1, "legacy J09 restores shared Season1State once")
	_expect(restored_j09.active_day == "J09" and restored_j09.j09_provider.phase == "entry_incoming", "legacy J09 restore preserves its exact active phase")
	j07_helper.free()
	j08_helper.free()

func _completed_j08_provider(echo: String):
	var helper = J08_SMOKE.new()
	var household: String = "STATE_A"
	var preparation: String = "choice_j08_raphaelle_schedule_1820"
	var priority: String = "choice_j08_priority_immediate"
	if echo == "HONEST_REFUSAL":
		household = "STATE_C"
		priority = ""
	elif echo == "VAGUE_OR_MISSED":
		priority = "choice_j08_priority_vague"
	var state = helper._completed_j07_state(household, false)
	var provider = helper._new_j08_provider(state)
	helper._advance_to_collision(provider, preparation)
	if priority == "":
		_present_batch(provider, "thread_raphaelle_private", 8)
	else:
		provider.apply_choice("thread_raphaelle_private", priority)
	helper._finish_day(provider)
	_collect_helper_failures(helper)
	_expect(provider.state.marie_j08_echo_outcome == echo, "J08 fixture produces " + echo)
	helper.free()
	return provider

func _advance_to_complete(provider, presence_choice: String, quality_choice: String, dinner_choice: String) -> void:
	_expect(bool(provider.start_day().get("accepted", false)), "J09 starts")
	_present_batch(provider, MARIE_THREAD, 9)
	_expect(bool(provider.apply_choice(MARIE_THREAD, "choice_j09_extension_guided").get("accepted", false)), "extension guided choice applies")
	_expect(provider.phase == "presence_choice", "presence choice opens")
	_expect(bool(provider.apply_choice(MARIE_THREAD, presence_choice).get("accepted", false)), "presence choice applies")
	_expect(bool(provider.confirm_transition().get("accepted", false)), "black dress transition completes")
	_present_batch(provider, MARIE_THREAD, 9)
	_expect(bool(provider.apply_choice(MARIE_THREAD, "choice_j09_black_dress_guided").get("accepted", false)), "black dress guided choice applies")
	if presence_choice == "choice_j09_presence_early":
		provider.confirm_transition()
		_expect(provider.phase == "early_quality_choice", "early quality opens before co-presence")
		_expect(bool(provider.apply_choice(MARIE_THREAD, quality_choice).get("accepted", false)), "early quality applies without transcript")
		provider.confirm_transition()
	elif presence_choice == "choice_j09_presence_late":
		provider.confirm_transition()
		_present_batch(provider, MARIE_THREAD, 9)
		provider.apply_choice(MARIE_THREAD, "choice_j09_late_orientation_guided")
		_expect(provider.phase == "late_quality_choice", "late quality opens before co-presence")
		_expect(bool(provider.apply_choice(MARIE_THREAD, quality_choice).get("accepted", false)), "late quality applies without transcript")
		provider.confirm_transition()
	else:
		provider.confirm_transition()
		_present_batch(provider, MARIE_THREAD, 9)
		provider.apply_choice(MARIE_THREAD, "choice_j09_absence_public_guided")
		provider.confirm_transition()
	_expect(provider.phase == "after_incoming", "23:05 trace arrives only after separation or distinct places")
	_present_batch(provider, MARIE_THREAD, 9)
	_expect(provider.phase == "to_return", "23:07 return transition opens")
	provider.confirm_transition()
	_present_batch(provider, MARIE_THREAD, 9)
	var return_choice: String = {
		"presence_active": "choice_j09_return_active_guided",
		"presence_playful_useful": "choice_j09_return_active_guided",
		"presence_distracted": "choice_j09_return_distracted_guided",
		"presence_late_active": "choice_j09_return_late_active_guided",
		"presence_spectator": "choice_j09_return_spectator_guided",
		"presence_bounded_reliable": "choice_j09_return_bounded_guided",
		"absence_honest": "choice_j09_return_absence_guided",
	}[provider.state.marie_j09_presence_outcome]
	provider.apply_choice(MARIE_THREAD, return_choice)
	if dinner_choice != "":
		_expect(provider.phase == "dinner_choice", "real dinner choice opens")
		provider.apply_choice(MARIE_THREAD, dinner_choice)
	else:
		_expect(provider.phase == "day_close" and provider.state.marie_j09_dinner_outcome == "NOT_OFFERED", "no dinner is manufactured")
	_expect(provider.phase == "day_close", "J09 reaches day close")
	provider.confirm_transition()

func _assert_dinner(state, dinner_choice: String, label: String) -> void:
	var p09: Dictionary = state.promises.get("marie_j09_dinner_j10_2030", {})
	var p10: Dictionary = state.promises.get("marie_j09_dinner_friday_2030", {})
	match dinner_choice:
		"choice_j09_dinner_j10":
			_expect(str(p09.get("status", "")) == "ACTIVE" and str(p09.get("due_at", "")) == "J10 20:30", label + " creates only active P09")
			_expect(p10.is_empty(), label + " does not create P10")
		"choice_j09_dinner_friday":
			_expect(p09.is_empty(), label + " does not keep Thursday")
			_expect(str(p10.get("status", "")) == "ACTIVE" and str(p10.get("due_at", "")) == "J11 20:30", label + " creates active P10")
		"choice_j09_dinner_refuse":
			_expect(str(p09.get("status", "")) == "REFUSED" and str(p09.get("due_at", "")) == "", label + " closes P09")
			_expect(p10.is_empty(), label + " does not create P10")
		_:
			_expect(p09.is_empty() and p10.is_empty(), label + " creates no automatic dinner")

func _expect_round_trip(provider, label: String) -> void:
	var state_snapshot: Dictionary = provider.state.snapshot()
	var provider_snapshot: Dictionary = provider.snapshot()
	var restored_state = SEASON_STATE.new()
	var restored = J09_PROVIDER.new()
	_expect(restored_state.restore_snapshot(state_snapshot), label + " state restore")
	_expect(restored.initialize(restored_state, {}, {}, [], []), label + " provider init")
	_expect(restored.restore_snapshot(provider_snapshot), label + " provider restore")
	_expect(restored.snapshot() == provider_snapshot, label + " exact provider round trip")
	_expect(restored_state.snapshot() == state_snapshot, label + " exact state round trip")

func _assert_unique_message_ids(provider, label: String) -> void:
	var seen: Dictionary = {}
	for thread_id in provider.transcripts_by_thread:
		for message in provider.transcripts_by_thread[thread_id]:
			var id: String = str(message.get("message_id", ""))
			_expect(id != "" and not seen.has(id), label + " has no duplicate message " + id)
			seen[id] = true
	_expect(seen.size() == provider.produced_message_ids.size(), label + " produced ids exactly match transcripts")

func _present_batch(provider, thread_id: String, day: int) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == day and not bool(message.get("is_player", false)):
			provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "batch presented for %s in %s" % [thread_id, provider.phase])

func _relationship_snapshot(state) -> Dictionary:
	return {
		"couple": state.couple_state,
		"sandra": state.sandra_state,
		"raphaelle": state.raphaelle_state,
		"mathilde": state.mathilde_state,
		"pauline": state.pauline_state,
		"nico": state.nico_state,
	}

func _collect_helper_failures(helper) -> void:
	for failure in helper.failures:
		failures.append("J08 helper: " + failure)
	helper.failures.clear()

func _exercise_real_surfaces(size: Vector2i) -> void:
	var main = MAIN_SCENE.instantiate()
	add_child(main)
	await _frames(6)
	var shell = main.shell
	var messages = shell.messages_screen
	shell.set_safe_area_preset("none")
	shell.set_reduced_motion_enabled(true)
	messages.runtime_delivery_time_scale = 0.01
	messages.reading_speed_multiplier = 8.0

	var j08 = _completed_j08_provider("CLEAR_HOURS")
	messages._start_runtime_day_card(j08.runtime_map["day_end"]["next_day_presentation"])
	await _frames(3)
	await _capture("j08_to_j09_handoff", size)

	var provider = J09_PROVIDER.new()
	provider.initialize(j08.state, j08.transcripts_by_thread, j08.produced_message_ids, j08.unlocked_thread_ids, j08.gallery_asset_ids)
	provider.start_day()
	_present_batch(provider, MARIE_THREAD, 9)
	provider.apply_choice(MARIE_THREAD, "choice_j09_extension_guided")
	_mount_direct(messages, shell.runtime_provider, provider)
	messages.open_thread(MARIE_THREAD)
	await _frames(3)
	await _capture("presence_choice_j09", size)

	provider.apply_choice(MARIE_THREAD, "choice_j09_presence_early")
	provider.confirm_transition()
	_present_batch(provider, MARIE_THREAD, 9)
	_mount_direct(messages, shell.runtime_provider, provider)
	messages.open_thread(MARIE_THREAD)
	await _frames(3)
	await _capture("main_scene_j09", size)

	provider.apply_choice(MARIE_THREAD, "choice_j09_black_dress_guided")
	provider.confirm_transition()
	_mount_direct(messages, shell.runtime_provider, provider)
	messages.open_thread(MARIE_THREAD)
	await _frames(3)
	_expect(provider.phase == "early_quality_choice" and provider.choices_for(MARIE_THREAD).size() == 3, "major quality choice is visible before off-phone")
	provider.apply_choice(MARIE_THREAD, "choice_j09_quality_active")
	provider.confirm_transition()
	_present_batch(provider, MARIE_THREAD, 9)
	provider.confirm_transition()
	_present_batch(provider, MARIE_THREAD, 9)
	provider.apply_choice(MARIE_THREAD, "choice_j09_return_active_guided")
	provider.apply_choice(MARIE_THREAD, "choice_j09_dinner_j10")
	provider.confirm_transition()
	_mount_direct(messages, shell.runtime_provider, provider)
	shell.gallery_screen.refresh_content_source(shell.runtime_provider.gallery_source())
	shell.activate_gallery(false)
	await _frames(3)
	await _capture("gallery_j09", size)
	shell.activate_messages(false)
	messages._start_runtime_day_card(provider.runtime_map["day_end"])
	await _frames(3)
	await _capture("content_end_j09", size)
	_expect(not bool(shell.describe_layout().get("has_vertical_crop", true)), "PortraitShell has no vertical crop")
	_expect(not bool(messages.describe_state().get("has_horizontal_crop", true)), "Messages has no horizontal crop")
	main.queue_free()
	await _frames(6)

func _mount_direct(messages, season, provider) -> void:
	season.state = provider.state
	season.j09_provider = provider
	season.active_day = "J09"
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
		var thread_id: String = str(raw_thread_id)
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
	var path: String = capture_dir.path_join("%dx%d_%s.png" % [size.x, size.y, label])
	var image: Image = get_viewport().get_texture().get_image()
	if image.get_size() != size:
		image.convert(Image.FORMAT_RGBA8)
		var canvas: Image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
		canvas.fill(Color("#02040C"))
		canvas.blit_rect(image, Rect2i(Vector2i.ZERO, image.get_size()), Vector2i((size.x - image.get_width()) / 2, (size.y - image.get_height()) / 2))
		image = canvas
	_expect(image.save_png(path) == OK, "capture failed: " + path)

func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame

func _arg(prefix: String, fallback: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="):
			return arg.trim_prefix(prefix + "=")
	return fallback

func _parse_size(value: String) -> Vector2i:
	var parts: PackedStringArray = value.split("x")
	return Vector2i(int(parts[0]), int(parts[1])) if parts.size() == 2 else Vector2i.ZERO

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _finish(size: Vector2i) -> void:
	if failures.is_empty():
		print("RUNTIME-S1-09 J09 real PortraitMain smoke %dx%d: OK" % [size.x, size.y])
		get_tree().call_deferred("quit", 0)
		return
	for failure in failures:
		push_error(failure)
	print("RUNTIME-S1-09 J09 real PortraitMain smoke: FAILED (%d)" % failures.size())
	get_tree().call_deferred("quit", 1)
