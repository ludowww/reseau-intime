extends "res://scripts/ui/PhonePrototypeV092.gd"

const VisualDayContract = preload("res://scripts/narrative/VisualDayContract.gd")
const DAY_EIGHT := 8
const DAY_SEVEN := 7
const TUESDAY_INDEX_PATH := "res://data/conversations/chapter_08_modular_index.json"
const TUESDAY_VISUAL_PATH := "res://data/visual_content/chapter_08_named_boundaries_visuals.json"
const TUESDAY_CONVERSATION_ID := "chapter_08_marie_black_dress"
const VISUAL_CONTRACT_PHASE_ID := "tuesday_visual_contract_close"
const NAMED_LEDGER_ID := "named_boundaries_wave"

var photo_gallery_view
var gallery_button: Button

func _ready() -> void:
	_ensure_v095_content_loaded()
	super._ready()
	_ensure_named_boundaries_ledger()

func _ensure_v095_content_loaded() -> void:
	if DataLoader.chapter_indexes.is_empty():
		DataLoader.load_all()
	if DataLoader.get_index_for_day(DAY_EIGHT).is_empty():
		var index := DataLoader.load_json(TUESDAY_INDEX_PATH)
		if not index.is_empty():
			DataLoader.chapter_indexes.append(index)
			DataLoader._load_index_conversations(index)
	if not DataLoader.visual_content_by_id.has("marie_tuesday_black_dress_mirror_01"):
		DataLoader._load_visual_content(TUESDAY_VISUAL_PATH)

func _named_boundaries_defaults() -> Dictionary:
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

func _ensure_named_boundaries_ledger() -> Dictionary:
	return GameState.ensure_story_ledger(NAMED_LEDGER_ID, _named_boundaries_defaults())

func _add_home_navigation(parent: Node) -> void:
	var title := Label.new()
	title.text = "Réseau Intime"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.92, 0.93, 0.98))
	parent.add_child(title)

	var primary_nav := HBoxContainer.new()
	primary_nav.add_theme_constant_override("separation", 8)
	primary_nav.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(primary_nav)
	var messages_button := _add_button(primary_nav, "Messages")
	messages_button.pressed.connect(func(): _focus_messages())
	gallery_button = _add_button(primary_nav, "Galerie")
	gallery_button.pressed.connect(func(): _show_gallery())

	var technical_nav := HBoxContainer.new()
	technical_nav.add_theme_constant_override("separation", 8)
	technical_nav.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(technical_nav)
	var debug_button := _add_button(technical_nav, "Debug")
	debug_button.pressed.connect(func(): _toggle_debug(debug_button))
	debug_speed_button = _add_button(technical_nav, _debug_speed_label())
	debug_speed_button.pressed.connect(func(): _cycle_debug_speed())
	var reset_button := _add_button(technical_nav, "Reset")
	reset_button.pressed.connect(func(): GameState.reset_state(); conversation_view.reset_ui_state(); pending_conversation_ids.clear(); pending_thread_ids.clear(); unlocked_conversation_ids_by_day.clear(); unlocked_thread_ids_by_day.clear(); initialized_pending_days.clear(); _hide_notification(); _set_debug_speed_index(0); _render_conversations(current_day_value); debug_panel.refresh())

func _build_layout() -> void:
	super._build_layout()
	if not is_instance_valid(conversation_view):
		return
	var root := conversation_view.get_parent()
	photo_gallery_view = preload("res://scenes/smartphone/PhotoGalleryView.tscn").instantiate()
	photo_gallery_view.visible = false
	photo_gallery_view.custom_minimum_size = Vector2(600, 0)
	photo_gallery_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	photo_gallery_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(photo_gallery_view)
	if is_instance_valid(debug_scroll):
		root.move_child(photo_gallery_view, debug_scroll.get_index())
	if photo_gallery_view.has_signal("back_requested"):
		photo_gallery_view.connect("back_requested", Callable(self, "_focus_messages"))
	if conversation_view.has_signal("visual_open_requested"):
		conversation_view.connect("visual_open_requested", Callable(self, "_on_visual_open_requested"))

func _focus_messages() -> void:
	if is_instance_valid(photo_gallery_view):
		photo_gallery_view.visible = false
	if is_instance_valid(conversation_view):
		conversation_view.visible = true
	super._focus_messages()

func _show_gallery(content_id: String = "") -> void:
	if not is_instance_valid(photo_gallery_view):
		return
	if is_instance_valid(conversation_view):
		conversation_view.visible = false
	photo_gallery_view.visible = true
	photo_gallery_view.refresh()
	if content_id != "":
		photo_gallery_view.show_content(content_id)

func _on_visual_open_requested(content_id: String) -> void:
	_show_gallery(content_id)

func _on_conversation_completed(day_value, conversation_id: String) -> void:
	if int(day_value) == DAY_EIGHT and conversation_id == TUESDAY_CONVERSATION_ID:
		_record_m4_obligation()
	await super._on_conversation_completed(day_value, conversation_id)

func _record_m4_obligation() -> void:
	var flags: Array = GameState.current_state.get("flags", [])
	var obligation_id := ""
	var expected_by := ""
	var result := ""
	if flags.has("marie_m4_join_movement"):
		obligation_id = "marie_wednesday_join_movement"
		expected_by = "wednesday_laverriere_close"
		result = "join_and_leave_together"
	elif flags.has("marie_m4_take_lannexe_table"):
		obligation_id = "marie_wednesday_lannexe_table"
		expected_by = "wednesday_lannexe_2045"
		result = "take_table_and_arrive"
	elif flags.has("marie_m4_private_thursday"):
		obligation_id = "marie_thursday_private_continuation"
		expected_by = "thursday_couple_time"
		result = "reserve_private_continuation"
	if obligation_id == "":
		return
	_ensure_named_boundaries_ledger()
	GameState.set_story_ledger_value(NAMED_LEDGER_ID, "primary_carryover_source", "marie_m4")
	GameState.set_obligation_status(NAMED_LEDGER_ID, obligation_id, {
		"status": "SCHEDULED",
		"owner": "player",
		"expected_by": expected_by,
		"created_by": TUESDAY_CONVERSATION_ID,
		"resolved_by": "",
		"result": result,
	})

func _activate_authored_beat_silently(day_value, phase: Dictionary) -> void:
	if int(day_value) != DAY_EIGHT or str(phase.get("id", "")) != VISUAL_CONTRACT_PHASE_ID:
		await super._activate_authored_beat_silently(day_value, phase)
		return
	await _activate_tuesday_visual_contract(day_value, phase)

func _activate_tuesday_visual_contract(day_value, phase: Dictionary) -> void:
	transition_in_progress = true
	var phase_id := str(phase.get("id", ""))
	TimelineState.set_current_phase(day_value, phase_id)
	var result := _evaluate_tuesday_visual_contract()
	if not bool(result.get("satisfied", false)):
		push_error("Tuesday visual contract blocked: %s" % str(result.get("blocking_reasons", [])))
		transition_in_progress = false
		_render_active_day(day_value)
		_render_days_buttons_only()
		return
	EffectApplier.apply_flags(["tuesday_visual_contract_complete"])
	TimelineState.complete_phase(day_value, phase_id)
	transition_in_progress = false
	_render_active_day(day_value)
	_render_days_buttons_only()
	await _advance_after_phase(day_value, phase_id)

func _evaluate_tuesday_visual_contract() -> Dictionary:
	var contract: Dictionary = DataLoader.get_index_for_day(DAY_EIGHT).get("daily_visual_contract", {})
	return VisualDayContract.evaluate(
		contract,
		GameState.current_state.get("unlocked_content", []),
		DataLoader.visual_content_by_id
	)

func _complete_day(day_value) -> void:
	if int(day_value) == DAY_SEVEN and GameState.current_state.get("flags", []).has("first_repetition_wave_complete"):
		await _handoff_to_day_eight(day_value)
		return
	if int(day_value) == DAY_EIGHT:
		var result := _evaluate_tuesday_visual_contract()
		if not bool(result.get("satisfied", false)):
			push_error("Day 8 completion blocked by visual contract: %s" % str(result.get("blocking_reasons", [])))
			transition_in_progress = false
			time_passage_in_progress = false
			_render_active_day(day_value)
			_render_days_buttons_only()
			return
	await super._complete_day(day_value)

func _handoff_to_day_eight(day_value) -> void:
	transition_in_progress = true
	_hide_notification()
	_clear_pending_for_day(day_value)
	TimelineState.mark_day_complete(day_value)
	var end_card := DataLoader.get_timeline_day_end_card(day_value)
	var start_card := DataLoader.get_timeline_day_start_card(DAY_EIGHT)
	if is_instance_valid(timeline_transition_view):
		await timeline_transition_view.show_day_transition(end_card, start_card)
	TimelineState.unlock_day(DAY_EIGHT)
	TimelineState.set_current_day(DAY_EIGHT)
	current_day_value = DAY_EIGHT
	viewing_archived_day = false
	transition_in_progress = false
	time_passage_in_progress = false
	var initial_phase := DataLoader.get_timeline_phase(
		DAY_EIGHT,
		DataLoader.get_timeline_initial_phase_id(DAY_EIGHT)
	)
	await _activate_phase(DAY_EIGHT, initial_phase, false)
	_sync_conversation_phone_status()

func _on_game_state_changed() -> void:
	super._on_game_state_changed()
	if GameState.context.get("day", null) == null and str(GameState.context.get("last_choice", "")) == "":
		_ensure_named_boundaries_ledger()
	if is_instance_valid(photo_gallery_view):
		photo_gallery_view.refresh.call_deferred()
