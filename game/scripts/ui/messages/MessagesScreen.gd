extends Control

class_name MessagesScreen

signal photo_requested(presentation: Dictionary, provenance: Dictionary)
signal runtime_typing_started(thread_id: String, message_id: String, author_id: String)
signal runtime_message_delivered(thread_id: String, message_id: String)
signal screen_mode_changed(mode: String)
signal reading_speed_requested

const DEMO_DATA := preload("res://scripts/ui/messages/MessagesDemoData.gd")
const CONVERSATION_LIST_SCRIPT := preload("res://scripts/ui/messages/ConversationList.gd")
const CONVERSATION_SCREEN_SCENE := preload("res://scenes/portrait/messages/PortraitConversationScreen.tscn")
const NOTIFICATION_BANNER_SCRIPT := preload("res://scripts/ui/messages/NotificationBanner.gd")
const OFF_PHONE_TRANSITION_SCRIPT := preload("res://scripts/ui/messages/OffPhoneTransition.gd")
const DAY_TRANSITION_SCRIPT := preload("res://scripts/ui/messages/DayTransition.gd")
const NARRATIVE_TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const INTER_MESSAGE_PAUSE_SECONDS := 0.30
const IMAGE_TYPING_DURATION_SECONDS := 1.50
const MIN_TYPING_SECONDS_X3 := 0.35
const MIN_TYPING_SECONDS_X8 := 0.22
const MIN_PAUSE_SECONDS := 0.04
const REDUCED_MOTION_CLOCK_DELAY_SECONDS := 0.15

var PORTRAIT_THEME = preload("res://scripts/ui/PortraitShellTheme.gd").new()
var characters: Dictionary = {}
var threads: Array[Dictionary] = []
var transcripts: Dictionary = {}
var available_choices: Dictionary = {}
var reading_positions: Dictionary = {}
var incoming_by_thread: Dictionary = {}
var incoming_sequence_by_thread: Dictionary = {}
var typing_states_by_thread: Dictionary = {}
var off_phone_state: Dictionary = {}
var day_transition_state: Dictionary = {}
var applied_demo_day_transitions: Dictionary = {}
var day_transition_deltas: Dictionary = {}
var current_demo_day_value := 0
var conversation_list
var conversation_screen
var notification_banner
var off_phone_transition
var day_transition
var notification_focus_origin: Control
var active_thread_id := ""
var screen_mode := "list"
var content_source: Dictionary = {}
var runtime_provider
var runtime_delivery_active := false
var runtime_delivery_thread_id := ""
var runtime_delivery_request_id := 0
var runtime_delivery_queue: Array[Dictionary] = []
var runtime_delivery_pending_choices: Array[Dictionary] = []
var runtime_delivery_pending_transition: Dictionary = {}
var runtime_delivery_time_scale := 1.0
var runtime_delivery_cancelled := false
var runtime_delivery_shell_unhandled_before := true
var reading_speed_multiplier := 1.0
var narrative_clock_animation_active := false
var narrative_clock_request_id := 0
var narrative_clock_from_minutes := -1
var narrative_clock_to_minutes := -1
var narrative_clock_base_duration := 4.0
var narrative_clock_progress := 0.0
var narrative_clock_pending_transition: Dictionary = {}
var narrative_clock_completion_result: Dictionary = {}
var compact_height_mode := false
# Provider transcript, visually presented IDs, and pending suffixes stay separate per thread.
var runtime_provider_transcript_by_thread: Dictionary = {}
var runtime_presented_message_ids_by_thread: Dictionary = {}
var runtime_pending_messages_by_thread: Dictionary = {}
var runtime_pending_choices_by_thread: Dictionary = {}
var runtime_pending_transition_by_thread: Dictionary = {}

func configure_content_source(source: Dictionary, provider = null) -> void:
	content_source = source.duplicate(true)
	runtime_provider = provider

func _set_screen_mode(mode: String) -> void:
	if screen_mode == mode:
		return
	screen_mode = mode
	screen_mode_changed.emit(screen_mode)

func set_compact_height_mode(enabled: bool) -> void:
	if compact_height_mode == enabled:
		return
	compact_height_mode = enabled
	if conversation_screen != null:
		conversation_screen.set_compact_height_mode(enabled)
	if off_phone_transition != null:
		off_phone_transition.set_compact_height_mode(enabled)
	if day_transition != null:
		day_transition.set_compact_height_mode(enabled)

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	if content_source.is_empty():
		_load_demo_data()
	elif runtime_provider != null:
		_initialize_runtime_source(content_source)
	else:
		_apply_content_source(content_source)
	_build()
	visibility_changed.connect(_on_visibility_changed)

func focus_first_conversation() -> void:
	if conversation_list != null and screen_mode == "list":
		conversation_list.focus_first_card()

func open_thread(thread_id: String) -> void:
	if runtime_delivery_active or is_off_phone_transition_active() or is_day_transition_active():
		return
	var selected := _thread_for(thread_id)
	if selected.is_empty():
		return
	_save_reading_position()
	var first_unread_message_id := _first_unread_message_id(thread_id)
	_mark_thread_read(thread_id)
	active_thread_id = thread_id
	conversation_list.visible = false
	conversation_screen.visible = true
	if notification_banner != null and str(notification_banner.notification.get("thread_id", "")) == thread_id:
		_hide_notification()
	var messages := _dictionary_array(transcripts.get(thread_id, []))
	var choices := _dictionary_array(available_choices.get(thread_id, []))
	var position := int(reading_positions.get(thread_id, -1))
	conversation_screen.configure(selected, messages, choices, characters, PORTRAIT_THEME, position, first_unread_message_id)
	conversation_screen.set_narrative_time(_authoritative_narrative_time_text())
	conversation_screen.set_compact_height_mode(compact_height_mode)
	_set_screen_mode("conversation")
	_sync_active_typing()
	if runtime_provider != null:
		call_deferred("_start_pending_delivery_for_thread", thread_id)

func return_to_list() -> void:
	if runtime_delivery_active or is_off_phone_transition_active() or is_day_transition_active():
		return
	_save_reading_position()
	conversation_screen.hide_typing()
	_set_screen_mode("list")
	conversation_screen.visible = false
	conversation_list.visible = true
	conversation_list.call_deferred("focus_thread", active_thread_id)
	if runtime_provider != null:
		var transition: Dictionary = runtime_provider.on_thread_returned(active_thread_id)
		if not transition.is_empty():
			call_deferred("_start_narrative_clock_transition", transition)

func activate_first_choice() -> void:
	if runtime_delivery_active or is_off_phone_transition_active() or is_day_transition_active():
		return
	if screen_mode == "conversation":
		conversation_screen.activate_first_choice()

func start_typing(thread_id: String, author_id: String) -> void:
	if is_off_phone_transition_active() or is_day_transition_active():
		return
	var thread := _thread_for(thread_id)
	if thread.is_empty():
		return
	var author: Dictionary = characters.get(author_id, {})
	if author.is_empty():
		return
	if author_id.to_lower() == "player" or not _thread_accepts_author(thread, author_id):
		return
	typing_states_by_thread[thread_id] = {
		"thread_id": thread_id,
		"author_id": author_id,
		"active": true,
	}
	if screen_mode == "conversation" and active_thread_id == thread_id and is_visible_in_tree():
		conversation_screen.show_typing(author, _reduced_motion_enabled(), runtime_delivery_active and runtime_delivery_thread_id == thread_id, reading_speed_multiplier)

func update_active_typing_speed() -> void:
	if not runtime_delivery_active or not is_thread_typing(runtime_delivery_thread_id):
		return
	var state: Dictionary = typing_states_by_thread.get(runtime_delivery_thread_id, {})
	var author: Dictionary = characters.get(str(state.get("author_id", "")), {})
	if not author.is_empty() and conversation_screen != null:
		conversation_screen.show_typing(author, _reduced_motion_enabled(), true, reading_speed_multiplier)

func reconfigure_active_typing() -> void:
	_sync_active_typing()

func stop_typing(thread_id: String) -> void:
	if is_off_phone_transition_active() or is_day_transition_active():
		return
	if not typing_states_by_thread.has(thread_id):
		return
	typing_states_by_thread.erase(thread_id)
	if screen_mode == "conversation" and active_thread_id == thread_id:
		conversation_screen.hide_typing()

func is_thread_typing(thread_id: String) -> bool:
	var state: Dictionary = typing_states_by_thread.get(thread_id, {})
	return bool(state.get("active", false))

func simulate_incoming_message(thread_id: String) -> void:
	if is_off_phone_transition_active() or is_day_transition_active():
		return
	var thread := _thread_for(thread_id)
	if thread.is_empty():
		return
	var source: Dictionary = incoming_by_thread.get(thread_id, {})
	if source.is_empty():
		return
	stop_typing(thread_id)
	var sequence := int(incoming_sequence_by_thread.get(thread_id, 0)) + 1
	incoming_sequence_by_thread[thread_id] = sequence
	var timestamp := _simulation_timestamp(source, sequence)
	var is_open := screen_mode == "conversation" and active_thread_id == thread_id
	var base_text := str(source.get("text", "Nouveau message factice."))
	var preview := "%s %d" % [base_text, sequence]
	var message := {
		"message_id": "demo_incoming_%s_%d" % [thread_id, sequence],
		"author_id": str(source.get("author_id", "")),
		"timestamp": timestamp,
		"content_type": "TEXT",
		"text": preview,
		"media_ref": "",
		"is_player": false,
		"is_read": is_open,
		"source_day": 0,
	}
	var thread_messages := _dictionary_array(transcripts.get(thread_id, []))
	thread_messages.append(message.duplicate(true))
	transcripts[thread_id] = thread_messages
	thread["last_preview"] = preview
	thread["last_timestamp"] = timestamp
	if is_open:
		thread["unread_count"] = 0
		conversation_screen.append_incoming_message(message)
		reading_positions[thread_id] = conversation_screen.get_reading_position()
		if _notification_targets(thread_id):
			_hide_notification()
	else:
		thread["unread_count"] = int(thread.get("unread_count", 0)) + 1
		_show_notification(thread, preview, timestamp)
	conversation_list.update_thread_presentation(thread)

func start_off_phone_transition(thread_id: String) -> void:
	if is_day_transition_active():
		return
	if is_off_phone_transition_active():
		return
	var thread := _thread_for(thread_id)
	if thread.is_empty():
		return
	if screen_mode != "conversation" or active_thread_id != thread_id:
		return
	var presentation := _off_phone_presentation_for(thread_id)
	if presentation.is_empty():
		return
	_save_reading_position()
	var focus_owner := get_viewport().gui_get_focus_owner()
	var shell: Node = _portrait_shell()
	off_phone_state = {
		"active": true,
		"thread_id": thread_id,
		"transition_message_id": str(presentation.get("message_id", "")),
		"label": str(presentation.get("text", "")),
		"resume_focus_target": focus_owner if focus_owner is Control else null,
		"reading_position": int(reading_positions.get(thread_id, 0)),
		"typing_was_active": is_thread_typing(thread_id),
		"notification_was_visible": notification_banner != null and notification_banner.visible,
		"notification_thread_id": str(notification_banner.notification.get("thread_id", "")) if notification_banner != null else "",
		"shell_was_processing_unhandled_input": shell.is_processing_unhandled_input() if shell != null else false,
	}
	conversation_screen.hide_typing()
	conversation_screen.visible = false
	conversation_list.visible = false
	if notification_banner != null:
		notification_banner.visible = false
	_set_content_banner_spacing(false)
	_set_screen_mode("off_phone")
	_set_gallery_navigation_blocked(true)
	off_phone_transition.configure(str(off_phone_state.get("label", "")), PORTRAIT_THEME, _reduced_motion_enabled())

func finish_off_phone_transition() -> void:
	if is_day_transition_active():
		return
	if not is_off_phone_transition_active():
		return
	if runtime_provider != null:
		_finish_runtime_off_phone_transition()
		return
	var saved_state := off_phone_state.duplicate(false)
	var thread_id := str(saved_state.get("thread_id", ""))
	off_phone_transition.dismiss()
	_set_screen_mode("conversation")
	active_thread_id = thread_id
	conversation_list.visible = false
	conversation_screen.visible = true
	reading_positions[thread_id] = int(saved_state.get("reading_position", 0))
	conversation_screen.timeline.set_reading_position(int(saved_state.get("reading_position", 0)))
	if bool(saved_state.get("notification_was_visible", false)) and notification_banner != null:
		notification_banner.visible = true
		_set_content_banner_spacing(true)
	off_phone_state = {}
	_set_gallery_navigation_blocked(false, bool(saved_state.get("shell_was_processing_unhandled_input", false)))
	if bool(saved_state.get("typing_was_active", false)):
		_sync_active_typing()
	call_deferred("_restore_off_phone_focus", saved_state.get("resume_focus_target"))
	call_deferred("_restore_off_phone_reading_position", thread_id, int(saved_state.get("reading_position", 0)))

func is_off_phone_transition_active() -> bool:
	return bool(off_phone_state.get("active", false))

func start_day_transition(from_day: int, to_day: int) -> void:
	if from_day <= 0 or to_day <= from_day:
		return
	if is_day_transition_active() or is_off_phone_transition_active():
		return
	var delta: Dictionary = day_transition_deltas.get(to_day, {})
	if delta.is_empty():
		return
	_save_reading_position()
	var focus_owner := get_viewport().gui_get_focus_owner()
	var shell: Node = _portrait_shell()
	var notification_snapshot := {
		"visible": notification_banner != null and notification_banner.visible,
		"presentation": notification_banner.notification.duplicate(true) if notification_banner != null else {},
	}
	day_transition_state = {
		"active": true,
		"from_day": from_day,
		"to_day": to_day,
		"title": str(delta.get("title", "La journée se termine")),
		"subtitle": str(delta.get("subtitle", "")),
		"previous_screen": screen_mode,
		"previous_thread_id": active_thread_id,
		"resume_focus_target": focus_owner if focus_owner is Control else null,
		"typing_snapshot": typing_states_by_thread.duplicate(true),
		"notification_snapshot": notification_snapshot,
		"updated_thread_id": str(delta.get("thread_id", "")),
		"shell_was_processing_unhandled_input": shell.is_processing_unhandled_input() if shell != null else false,
	}
	conversation_screen.hide_typing()
	conversation_screen.visible = false
	conversation_list.visible = false
	if notification_banner != null:
		notification_banner.visible = false
	_set_content_banner_spacing(false)
	off_phone_transition.visible = false
	_set_screen_mode("day_transition")
	_set_gallery_navigation_blocked(true)
	day_transition.configure(
		str(day_transition_state.get("title", "La journée se termine")),
		str(day_transition_state.get("subtitle", "")),
		str(delta.get("body", "")),
		PORTRAIT_THEME,
		_reduced_motion_enabled(),
	)

func finish_day_transition() -> void:
	if not is_day_transition_active():
		return
	if runtime_provider != null:
		_finish_runtime_day_transition()
		return
	var saved_state := day_transition_state.duplicate(false)
	var to_day := int(saved_state.get("to_day", current_demo_day_value))
	var previous_thread_id := str(saved_state.get("previous_thread_id", ""))
	day_transition.reset_surface()
	var updated_thread_id := _apply_demo_day_delta(to_day)
	current_demo_day_value = to_day
	if previous_thread_id != "":
		typing_states_by_thread.erase(previous_thread_id)
	_hide_notification()
	_set_screen_mode("list")
	conversation_screen.visible = false
	conversation_list.visible = true
	conversation_list.configure(threads, characters, PORTRAIT_THEME, runtime_provider == null)
	day_transition_state = {}
	_set_gallery_navigation_blocked(false, bool(saved_state.get("shell_was_processing_unhandled_input", false)))
	var focus_thread_id := updated_thread_id if updated_thread_id != "" else previous_thread_id
	conversation_list.call_deferred("focus_thread", focus_thread_id)

func finish_secondary_day_transition() -> void:
	if not is_day_transition_active() or runtime_provider == null:
		return
	var result: Dictionary = runtime_provider.confirm_secondary_day_transition()
	if not bool(result.get("accepted", false)):
		return
	day_transition.reset_surface()
	day_transition_state = {}
	_start_narrative_clock_transition(result.get("transition", {}))

func _finish_runtime_day_transition() -> void:
	var result: Dictionary = runtime_provider.confirm_day_transition()
	if not bool(result.get("accepted", false)):
		day_transition.reset_surface()
		day_transition_state = {}
		_set_screen_mode("day_complete")
		conversation_screen.visible = false
		conversation_list.visible = false
		_set_gallery_navigation_blocked(false)
		return
	var destination := str(result.get("destination", ""))
	if destination == "day_transition":
		day_transition_state = {"active": true, "runtime": true}
		day_transition.configure_presentation(result.get("presentation", {}), PORTRAIT_THEME, _reduced_motion_enabled())
		return
	day_transition.reset_surface()
	day_transition_state = {}
	refresh_from_runtime()
	_refresh_runtime_gallery()
	_set_gallery_navigation_blocked(false)
	if destination == "conversation":
		_set_screen_mode("list")
		conversation_screen.visible = false
		conversation_list.visible = true
		open_thread(str(result.get("thread_id", "")))
		return
	_set_screen_mode("list")
	conversation_screen.visible = false
	conversation_list.visible = true
	conversation_list.call_deferred("focus_thread", str(result.get("focus_thread_id", "")))

func is_day_transition_active() -> bool:
	return bool(day_transition_state.get("active", false))

func _restore_off_phone_reading_position(thread_id: String, value: int) -> void:
	if is_off_phone_transition_active() or active_thread_id != thread_id or conversation_screen == null:
		return
	conversation_screen.timeline.set_reading_position(value)
	reading_positions[thread_id] = conversation_screen.get_reading_position()

func _restore_off_phone_focus(previous_focus: Variant) -> void:
	if is_off_phone_transition_active() or screen_mode != "conversation":
		return
	if previous_focus is Control and is_instance_valid(previous_focus) and previous_focus.is_visible_in_tree() and previous_focus.focus_mode != Control.FOCUS_NONE:
		previous_focus.grab_focus()
		return
	if conversation_screen.choice_bar != null and conversation_screen.choice_bar.choice_count() > 0:
		conversation_screen.choice_bar.focus_first_choice()
		return
	if conversation_screen.back_button != null:
		conversation_screen.back_button.grab_focus()

func describe_state() -> Dictionary:
	var state := {
		"screen": screen_mode,
		"screen_mode": screen_mode,
		"compact_height_mode": compact_height_mode,
		"active_thread_id": active_thread_id,
		"thread_count": threads.size(),
		"list_visible": conversation_list != null and conversation_list.visible,
		"conversation_visible": conversation_screen != null and conversation_screen.visible,
		"list_has_focus": conversation_list != null and conversation_list.first_card_has_focus(),
		"private_thread_id": _first_thread_id(false),
		"group_thread_id": _first_thread_id(true),
		"unread_thread_id": _first_thread_by_unread(true),
		"read_thread_id": _first_thread_by_unread(false),
		"notification_visible": notification_banner != null and notification_banner.visible,
		"notification_thread_id": str(notification_banner.notification.get("thread_id", "")) if notification_banner != null and notification_banner.visible else "",
		"off_phone_visible": off_phone_transition != null and off_phone_transition.visible,
		"off_phone_surface_count": 1 if off_phone_transition != null and is_instance_valid(off_phone_transition) else 0,
		"off_phone_thread_id": str(off_phone_state.get("thread_id", "")),
		"off_phone_action_focus": off_phone_transition != null and off_phone_transition.action_has_focus(),
		"off_phone_action_count": off_phone_transition.action_count() if off_phone_transition != null else 0,
		"off_phone_action_height": off_phone_transition.action_height() if off_phone_transition != null else 0.0,
		"off_phone_animation_running": off_phone_transition != null and off_phone_transition.animation_running(),
		"off_phone_presentation_count": _off_phone_presentation_count(active_thread_id),
		"day_transition_visible": day_transition != null and day_transition.visible,
		"day_transition_surface_count": day_transition_surface_count(),
		"day_transition_action_count": day_transition_action_count(),
		"day_transition_action_focus": day_transition != null and day_transition.action_has_focus(),
		"day_transition_action_height": day_transition.action_height() if day_transition != null else 0.0,
		"day_transition_animation_running": day_transition != null and day_transition.animation_running(),
		"day_transition_title": day_transition.display_title() if day_transition != null else "",
		"narrative_clock_animation_active": narrative_clock_animation_active,
		"narrative_clock_from_minutes": narrative_clock_from_minutes,
		"narrative_clock_to_minutes": narrative_clock_to_minutes,
		"day_transition_subtitle": day_transition.display_subtitle() if day_transition != null else "",
		"off_phone_transition_rect": off_phone_transition.surface_rect() if off_phone_transition != null else Rect2(),
		"day_transition_rect": day_transition.surface_rect() if day_transition != null else Rect2(),
		"typing_instance_count": conversation_screen.typing_instance_count() if conversation_screen != null else 0,
		"has_horizontal_crop": (conversation_list != null and conversation_list.has_horizontal_crop()) or (off_phone_transition != null and off_phone_transition.has_horizontal_crop()) or (day_transition != null and day_transition.has_horizontal_crop()),
	}
	if conversation_screen != null and screen_mode == "conversation":
		state.merge(conversation_screen.describe_state(), true)
	return state

func thread_unread_count(thread_id: String) -> int:
	var thread := _thread_for(thread_id)
	return int(thread.get("unread_count", 0)) if not thread.is_empty() else 0

func thread_message_count(thread_id: String) -> int:
	return _dictionary_array(transcripts.get(thread_id, [])).size()

func thread_player_message_count(thread_id: String) -> int:
	var count := 0
	for message in _dictionary_array(transcripts.get(thread_id, [])):
		if bool(message.get("is_player", false)):
			count += 1
	return count

func thread_choice_count(thread_id: String) -> int:
	return _dictionary_array(available_choices.get(thread_id, [])).size()

func thread_preview(thread_id: String) -> String:
	return str(_thread_for(thread_id).get("last_preview", ""))

func thread_timestamp(thread_id: String) -> String:
	return str(_thread_for(thread_id).get("last_timestamp", ""))

func all_messages_read(thread_id: String) -> bool:
	for message in _dictionary_array(transcripts.get(thread_id, [])):
		if not bool(message.get("is_read", false)):
			return false
	return true

func notification_banner_count() -> int:
	return 1 if notification_banner != null and is_instance_valid(notification_banner) else 0

func current_demo_day() -> int:
	return current_demo_day_value

func day_transition_surface_count() -> int:
	return 1 if day_transition != null and is_instance_valid(day_transition) else 0

func day_transition_action_count() -> int:
	return day_transition.action_count() if day_transition != null else 0

func day_transition_applied_count(to_day: int) -> int:
	return int(applied_demo_day_transitions.get(to_day, 0))

func presentation_count_by_id(message_id: String) -> int:
	var count := 0
	for thread_id in transcripts:
		for message in _dictionary_array(transcripts[thread_id]):
			if str(message.get("message_id", "")) == message_id:
				count += 1
	return count

func presentation_count_by_content_type(thread_id: String, content_type: String) -> int:
	var count := 0
	for message in _dictionary_array(transcripts.get(thread_id, [])):
		if str(message.get("content_type", "")) == content_type:
			count += 1
	return count

func total_presentation_count() -> int:
	var count := 0
	for thread_id in transcripts:
		count += _dictionary_array(transcripts[thread_id]).size()
	return count

func refresh_from_runtime(source: Dictionary = {}) -> void:
	if runtime_provider == null or runtime_delivery_active:
		return
	var next_source: Dictionary = runtime_provider.presentation_source() if source.is_empty() else source
	_reconcile_runtime_source(next_source)
	if conversation_list != null:
		conversation_list.configure(threads, characters, PORTRAIT_THEME, runtime_provider == null)
	if screen_mode == "conversation":
		_start_pending_delivery_for_thread(active_thread_id)

func _initialize_runtime_source(source: Dictionary) -> void:
	content_source = source.duplicate(true)
	characters = source.get("characters", {}).duplicate(true)
	threads = _dictionary_array(source.get("threads", []))
	transcripts.clear()
	available_choices.clear()
	for raw_thread_id in source.get("messages_by_thread", {}):
		var thread_id := str(raw_thread_id)
		transcripts[thread_id] = []
		runtime_presented_message_ids_by_thread[thread_id] = []
	_reconcile_runtime_source(source)

func _reconcile_runtime_source(source: Dictionary) -> bool:
	content_source = source.duplicate(true)
	characters = source.get("characters", {}).duplicate(true)
	threads = _dictionary_array(source.get("threads", []))
	var provider_by_thread: Dictionary = source.get("messages_by_thread", {})
	var choices_by_thread: Dictionary = source.get("choices_by_thread", {})
	for raw_thread_id in provider_by_thread:
		var thread_id := str(raw_thread_id)
		var provider_messages := _dictionary_array(provider_by_thread[raw_thread_id])
		if not _runtime_transcript_has_unique_ids(provider_messages, "provider"):
			return false
		var visual_messages := _dictionary_array(transcripts.get(thread_id, []))
		if not _runtime_transcript_has_unique_ids(visual_messages, "visual"):
			return false
		if not _runtime_presented_ids_match_visual_sequence(thread_id, visual_messages):
			push_error("Runtime presented message ID sequence does not match visual transcript")
			return false
		if visual_messages.size() > provider_messages.size():
			push_error("Runtime visual transcript is not a provider prefix")
			return false
		var normalized_visual := _normalized_runtime_transcript(visual_messages)
		var normalized_provider := _normalized_runtime_transcript(provider_messages)
		var normalized_provider_prefix := _normalized_runtime_transcript(provider_messages.slice(0, visual_messages.size()))
		if normalized_visual != normalized_provider_prefix:
			push_error("Runtime provider delta is not a strict normalized ordered suffix")
			return false
		var pending: Array[Dictionary] = []
		for index in range(visual_messages.size(), provider_messages.size()):
			pending.append(provider_messages[index].duplicate(true))
		runtime_provider_transcript_by_thread[thread_id] = provider_messages
		runtime_pending_messages_by_thread[thread_id] = pending
		if pending.is_empty() and normalized_visual != normalized_provider:
			push_error("Runtime transcript without pending messages must strictly equal provider")
			return false
		var pending_choices := _dictionary_array(choices_by_thread.get(raw_thread_id, choices_by_thread.get(thread_id, [])))
		runtime_pending_choices_by_thread[thread_id] = pending_choices
		available_choices[thread_id] = pending_choices if pending.is_empty() else []
		if not transcripts.has(thread_id):
			transcripts[thread_id] = []
	return true

func _runtime_presented_ids_match_visual_sequence(thread_id: String, visual_messages: Array[Dictionary]) -> bool:
	var visual_ids: Array = []
	for message in visual_messages:
		visual_ids.append(str(message.get("message_id", "")))
	var presented_ids: Array = runtime_presented_message_ids_by_thread.get(thread_id, [])
	return presented_ids == visual_ids

func _start_pending_delivery_for_thread(thread_id: String) -> void:
	if runtime_provider == null or runtime_delivery_active or screen_mode != "conversation" or active_thread_id != thread_id:
		return
	var pending := _dictionary_array(runtime_pending_messages_by_thread.get(thread_id, []))
	if pending.is_empty():
		replace_runtime_choices(_dictionary_array(runtime_pending_choices_by_thread.get(thread_id, [])))
		return
	runtime_delivery_request_id += 1
	runtime_delivery_active = true
	runtime_delivery_cancelled = false
	runtime_delivery_thread_id = thread_id
	runtime_delivery_queue = pending
	runtime_delivery_pending_choices = _dictionary_array(runtime_pending_choices_by_thread.get(thread_id, []))
	runtime_delivery_pending_transition = runtime_pending_transition_by_thread.get(thread_id, {}).duplicate(true)
	_hide_runtime_choices_for_delivery()
	_set_runtime_delivery_interactions_blocked(true)
	conversation_screen.timeline.reading_position_restore_pending = false
	_run_runtime_delivery(runtime_delivery_request_id, thread_id)

func append_runtime_messages(message_presentations: Array[Dictionary]) -> void:
	if active_thread_id == "" or conversation_screen == null:
		return
	conversation_screen.append_messages(message_presentations)
	transcripts[active_thread_id] = conversation_screen.timeline.messages.duplicate(true)
	reading_positions[active_thread_id] = conversation_screen.get_reading_position()

func replace_runtime_choices(choice_presentations: Array[Dictionary]) -> void:
	available_choices[active_thread_id] = choice_presentations.duplicate(true)
	if conversation_screen != null:
		conversation_screen.replace_choices(choice_presentations)

func unlock_runtime_thread(_thread_id: String) -> void:
	refresh_from_runtime()

func apply_runtime_choice(choice_id: String) -> bool:
	if runtime_provider == null or runtime_delivery_active:
		return false
	var thread_id := active_thread_id
	var previous_choices := _dictionary_array(available_choices.get(thread_id, []))
	_hide_runtime_choices_for_delivery()
	var result: Dictionary = runtime_provider.apply_choice(active_thread_id, choice_id)
	if not bool(result.get("accepted", false)):
		replace_runtime_choices(previous_choices)
		return false
	runtime_delivery_request_id += 1
	runtime_delivery_active = true
	runtime_delivery_cancelled = false
	runtime_delivery_thread_id = thread_id
	runtime_delivery_pending_choices = _dictionary_array(result.get("choices", []))
	runtime_delivery_pending_transition = result.get("transition", {}).duplicate(true)
	runtime_delivery_queue.clear()
	var new_messages := _dictionary_array(result.get("new_messages", []))
	var player_delivered := false
	for message in new_messages:
		if bool(message.get("is_player", false)) and not player_delivered:
			_append_runtime_delivery_message(message)
			player_delivered = true
		else:
			runtime_delivery_queue.append(message.duplicate(true))
	runtime_pending_messages_by_thread[thread_id] = runtime_delivery_queue.duplicate(true)
	runtime_pending_choices_by_thread[thread_id] = runtime_delivery_pending_choices.duplicate(true)
	runtime_pending_transition_by_thread[thread_id] = runtime_delivery_pending_transition.duplicate(true)
	_set_runtime_delivery_interactions_blocked(true)
	_continue_runtime_delivery_after_player(runtime_delivery_request_id, thread_id)
	return true

func _continue_runtime_delivery_after_player(request_id: int, thread_id: String) -> void:
	await get_tree().process_frame
	if not _runtime_delivery_request_is_current(request_id, thread_id):
		return
	if not await _follow_runtime_delivery_after_layout(request_id, thread_id):
		return
	if not _runtime_delivery_request_is_current(request_id, thread_id):
		return
	await _run_runtime_delivery(request_id, thread_id)

func _hide_runtime_choices_for_delivery() -> void:
	if active_thread_id != "":
		available_choices[active_thread_id] = []
	if conversation_screen != null and conversation_screen.choice_bar != null:
		var focus_owner := get_viewport().gui_get_focus_owner()
		if focus_owner != null:
			focus_owner.release_focus()
		conversation_screen.choice_bar.clear_choices()

func _run_runtime_delivery(request_id: int, thread_id: String) -> void:
	while not runtime_delivery_queue.is_empty():
		if not _runtime_delivery_request_is_current(request_id, thread_id):
			return
		var message: Dictionary = runtime_delivery_queue.pop_front()
		runtime_pending_messages_by_thread[thread_id] = runtime_delivery_queue.duplicate(true)
		var content_type := str(message.get("content_type", ""))
		if not bool(message.get("is_player", false)) and (content_type == "TEXT" or content_type == "IMAGE"):
			var author_id := str(message.get("author_id", ""))
			start_typing(thread_id, author_id)
			runtime_typing_started.emit(thread_id, str(message.get("message_id", "")), author_id)
			if not await _follow_runtime_delivery_after_layout(request_id, thread_id):
				return
			if not _runtime_delivery_request_is_current(request_id, thread_id):
				return
			await _runtime_delivery_delay(_typing_duration_seconds(message), true)
			if not _runtime_delivery_request_is_current(request_id, thread_id):
				return
			_replace_runtime_typing_with_message(message)
		else:
			_append_runtime_delivery_message(message)
		if not await _follow_runtime_delivery_after_layout(request_id, thread_id):
			return
		if not _runtime_delivery_request_is_current(request_id, thread_id):
			return
		if not runtime_delivery_queue.is_empty():
			await _runtime_delivery_delay(INTER_MESSAGE_PAUSE_SECONDS, false)
			if not _runtime_delivery_request_is_current(request_id, thread_id):
				return
	await _finish_runtime_delivery(request_id, thread_id)

func _typing_duration_seconds(message: Dictionary) -> float:
	if str(message.get("content_type", "")) == "IMAGE":
		return IMAGE_TYPING_DURATION_SECONDS
	var text := str(message.get("text", ""))
	return clampf(0.90 + float(text.length()) * 0.024, 1.20, 5.20)

func _runtime_delivery_delay(seconds: float, typing_delay := false) -> void:
	var elapsed := 0.0
	var progress := 0.0
	while true:
		await get_tree().process_frame
		var delta := get_process_delta_time()
		elapsed += delta
		progress += delta * reading_speed_multiplier / maxf(runtime_delivery_time_scale, 0.001)
		var minimum := 0.0
		if typing_delay:
			minimum = MIN_TYPING_SECONDS_X8 if reading_speed_multiplier >= 8.0 else (MIN_TYPING_SECONDS_X3 if reading_speed_multiplier >= 3.0 else 0.0)
		else:
			minimum = MIN_PAUSE_SECONDS
		if progress >= seconds and elapsed >= minimum * maxf(runtime_delivery_time_scale, 0.001):
			return

func _replace_runtime_typing_with_message(message: Dictionary) -> void:
	if conversation_screen == null:
		return
	typing_states_by_thread.erase(runtime_delivery_thread_id)
	var visual_message := _runtime_message_for_visual_insertion(message, runtime_delivery_thread_id)
	conversation_screen.timeline.replace_typing_with_message(visual_message, true)
	transcripts[runtime_delivery_thread_id] = conversation_screen.timeline.messages.duplicate(true)
	_mark_runtime_message_presented(runtime_delivery_thread_id, visual_message)

func _runtime_message_for_visual_insertion(message: Dictionary, thread_id: String) -> Dictionary:
	var visual_message := message.duplicate(true)
	if screen_mode == "conversation" and active_thread_id == thread_id:
		visual_message["is_read"] = true
	return visual_message

func _mark_runtime_message_presented(thread_id: String, message: Dictionary) -> void:
	var ids: Array = runtime_presented_message_ids_by_thread.get(thread_id, []).duplicate()
	var message_id := str(message.get("message_id", ""))
	if message_id != "" and not ids.has(message_id):
		ids.append(message_id)
	runtime_presented_message_ids_by_thread[thread_id] = ids
	if runtime_provider != null:
		runtime_provider.mark_message_presented(message_id)
		if conversation_screen != null:
			conversation_screen.set_narrative_time(runtime_provider.current_narrative_time_text())
	runtime_message_delivered.emit(thread_id, message_id)

func _append_runtime_delivery_message(message: Dictionary) -> void:
	if conversation_screen == null:
		return
	var visual_message := _runtime_message_for_visual_insertion(message, runtime_delivery_thread_id)
	if str(visual_message.get("content_type", "")) == "OFF_PHONE_TRANSITION":
		conversation_screen.timeline.messages.append(visual_message)
	else:
		conversation_screen.append_incoming_message(visual_message, false)
	transcripts[runtime_delivery_thread_id] = conversation_screen.timeline.messages.duplicate(true)
	_mark_runtime_message_presented(runtime_delivery_thread_id, visual_message)

func _follow_runtime_delivery_after_layout(request_id: int, thread_id: String) -> bool:
	if not _runtime_delivery_request_is_current(request_id, thread_id) or conversation_screen == null:
		return false
	var followed: bool = await conversation_screen.timeline.scroll_to_last_message_after_layout(true)
	if not _runtime_delivery_request_is_current(request_id, thread_id) or conversation_screen == null:
		return false
	if not followed or not conversation_screen.timeline.is_last_message_visible():
		return false
	reading_positions[thread_id] = conversation_screen.get_reading_position()
	return true

func _finish_runtime_delivery(request_id: int, thread_id: String) -> void:
	if not _runtime_delivery_request_is_current(request_id, thread_id):
		return
	if not await _follow_runtime_delivery_after_layout(request_id, thread_id):
		return
	if not _runtime_delivery_request_is_current(request_id, thread_id):
		return
	if not _sync_runtime_delivery_provider(thread_id):
		return
	var pending_choices := runtime_delivery_pending_choices.duplicate(true)
	var pending_transition := runtime_delivery_pending_transition.duplicate(true)
	if not pending_transition.is_empty():
		if not await _start_runtime_transition_after_layout(request_id, thread_id, pending_transition):
			return
		runtime_pending_transition_by_thread[thread_id] = {}
		_complete_runtime_delivery(false)
		if str(pending_transition.get("transition_mode", "")) == "clock_only" and not narrative_clock_completion_result.is_empty():
			var clock_result := narrative_clock_completion_result.duplicate(true)
			narrative_clock_completion_result = {}
			_refresh_after_clock_only(clock_result)
		return
	replace_runtime_choices(pending_choices)
	if not await _follow_runtime_delivery_after_layout(request_id, thread_id):
		return
	if not _runtime_delivery_request_is_current(request_id, thread_id):
		return
	if conversation_screen.choice_bar.choice_count() > 0:
		conversation_screen.choice_bar.focus_first_choice()
	_complete_runtime_delivery(true)

func _complete_runtime_delivery(unblock_navigation: bool) -> void:
	runtime_delivery_active = false
	runtime_delivery_thread_id = ""
	runtime_delivery_queue.clear()
	runtime_delivery_pending_choices.clear()
	runtime_delivery_pending_transition.clear()
	runtime_delivery_cancelled = false
	if unblock_navigation:
		_set_runtime_delivery_interactions_blocked(false)
	elif conversation_screen != null and conversation_screen.back_button != null:
		conversation_screen.back_button.disabled = false

func _runtime_delivery_request_is_current(request_id: int, thread_id: String) -> bool:
	return is_inside_tree() and not runtime_delivery_cancelled and runtime_delivery_active and request_id == runtime_delivery_request_id and thread_id == runtime_delivery_thread_id and active_thread_id == thread_id

func _sync_runtime_delivery_provider(thread_id: String) -> bool:
	var source: Dictionary = runtime_provider.presentation_source()
	var provider_messages := _normalized_runtime_transcript(_dictionary_array(source.get("messages_by_thread", {}).get(thread_id, [])))
	var visual_messages := _normalized_runtime_transcript(conversation_screen.timeline.messages.duplicate(true))
	if not _runtime_transcript_has_unique_ids(provider_messages, "provider"):
		return false
	if not _runtime_transcript_has_unique_ids(visual_messages, "visual"):
		return false
	if provider_messages != visual_messages:
		push_error("Runtime visual transcript does not strictly match normalized provider transcript")
		return false
	transcripts[thread_id] = conversation_screen.timeline.messages.duplicate(true)
	available_choices[thread_id] = runtime_delivery_pending_choices.duplicate(true)
	for source_thread in _dictionary_array(source.get("threads", [])):
		var local_thread := _thread_for(str(source_thread.get("thread_id", "")))
		if local_thread.is_empty():
			continue
		local_thread["last_preview"] = source_thread.get("last_preview", "")
		local_thread["last_timestamp"] = source_thread.get("last_timestamp", "")
		conversation_list.update_thread_presentation(local_thread)
	return true

func _normalized_runtime_transcript(messages: Array[Dictionary]) -> Array[Dictionary]:
	var normalized: Array[Dictionary] = []
	for message in messages:
		var item := message.duplicate(true)
		# Read state is local presentation state; every narrative/presentation field remains strict.
		item.erase("is_read")
		normalized.append(item)
	return normalized

func _runtime_transcript_has_unique_ids(messages: Array[Dictionary], side: String) -> bool:
	var ids: Dictionary = {}
	for message in messages:
		var message_id := str(message.get("message_id", ""))
		if message_id == "" or ids.has(message_id):
			push_error("Runtime %s transcript has a missing or duplicate message ID: %s" % [side, message_id])
			return false
		ids[message_id] = true
	return true

func _set_runtime_delivery_interactions_blocked(blocked: bool) -> void:
	if conversation_screen != null and conversation_screen.back_button != null:
		conversation_screen.back_button.disabled = blocked
	var shell: Node = _portrait_shell()
	if shell != null and blocked:
		runtime_delivery_shell_unhandled_before = shell.is_processing_unhandled_input()
	_set_gallery_navigation_blocked(blocked, runtime_delivery_shell_unhandled_before)

func _exit_tree() -> void:
	runtime_delivery_cancelled = true
	runtime_delivery_active = false
	runtime_delivery_request_id += 1
	narrative_clock_animation_active = false
	narrative_clock_request_id += 1
	narrative_clock_pending_transition = {}
	narrative_clock_completion_result = {}
	if conversation_screen != null:
		conversation_screen.hide_typing()

func _start_runtime_transition_after_layout(request_id: int, thread_id: String, transition: Dictionary) -> bool:
	await get_tree().process_frame
	if not _runtime_delivery_request_is_current(request_id, thread_id) or runtime_provider == null:
		return false
	if str(transition.get("transition_mode", "")) in ["clock_only", "clock_then_card"]:
		await _start_narrative_clock_transition(transition)
	elif str(transition.get("kind", "")) == "day_transition":
		_start_runtime_day_card(transition.get("presentation", {}))
	else:
		start_off_phone_transition(thread_id)
	await get_tree().process_frame
	if not _runtime_delivery_request_is_current(request_id, thread_id):
		return false
	return is_day_transition_active() or is_off_phone_transition_active() or str(transition.get("transition_mode", "")) == "clock_only"

func _start_narrative_clock_transition(transition: Dictionary) -> void:
	if runtime_provider == null or narrative_clock_animation_active or transition.is_empty():
		return
	var mode: String = str(transition.get("transition_mode", ""))
	if mode not in ["clock_only", "clock_then_card"]:
		_start_runtime_day_card(transition.get("presentation", {}))
		return
	var target: int = NARRATIVE_TIME.parse_narrative_time(str(transition.get("to_time", "")))
	var authoritative_from: int = int(runtime_provider.current_narrative_time_minutes())
	if target < authoritative_from:
		return
	narrative_clock_request_id += 1
	var request_id := narrative_clock_request_id
	narrative_clock_animation_active = true
	narrative_clock_from_minutes = authoritative_from
	narrative_clock_to_minutes = target
	narrative_clock_base_duration = maxf(float(transition.get("duration_seconds", 4.0)), 0.01)
	narrative_clock_progress = 0.0
	narrative_clock_pending_transition = transition.duplicate(true)
	narrative_clock_completion_result = {}
	_set_clock_interactions_blocked(true)
	if conversation_screen != null:
		conversation_screen.hide_typing()
		conversation_screen.set_narrative_time(NARRATIVE_TIME.format_narrative_time(authoritative_from))
	await _run_narrative_clock(request_id)

func _run_narrative_clock(request_id: int) -> void:
	var reduced_delay := REDUCED_MOTION_CLOCK_DELAY_SECONDS
	while narrative_clock_animation_active and request_id == narrative_clock_request_id:
		await get_tree().process_frame
		if not is_inside_tree() or request_id != narrative_clock_request_id:
			return
		var delta := get_process_delta_time()
		if _reduced_motion_enabled():
			narrative_clock_progress += delta * reading_speed_multiplier / maxf(runtime_delivery_time_scale, 0.001)
			if narrative_clock_progress < maxf(reduced_delay, 0.05): continue
		else:
			narrative_clock_progress += delta * reading_speed_multiplier / maxf(runtime_delivery_time_scale, 0.001)
			var ratio := clampf(narrative_clock_progress / narrative_clock_base_duration, 0.0, 1.0)
			var display_minutes := mini(narrative_clock_to_minutes, narrative_clock_from_minutes + int(floor(float(narrative_clock_to_minutes - narrative_clock_from_minutes) * ratio)))
			if conversation_screen != null: conversation_screen.set_narrative_time(NARRATIVE_TIME.format_narrative_time(display_minutes))
		if (_reduced_motion_enabled() and narrative_clock_progress >= maxf(reduced_delay, 0.05)) or narrative_clock_progress >= narrative_clock_base_duration:
			break
	if request_id != narrative_clock_request_id or not narrative_clock_animation_active:
		return
	var transition := narrative_clock_pending_transition.duplicate(true)
	runtime_provider.commit_narrative_time(narrative_clock_to_minutes)
	if conversation_screen != null: conversation_screen.set_narrative_time(runtime_provider.current_narrative_time_text())
	narrative_clock_animation_active = false
	narrative_clock_pending_transition = {}
	_set_clock_interactions_blocked(false)
	if str(transition.get("transition_mode", "")) == "clock_then_card":
		_start_runtime_day_card(transition.get("presentation", {}))
		return
	var result: Dictionary = runtime_provider.confirm_day_transition()
	if bool(result.get("accepted", false)):
		narrative_clock_completion_result = result.duplicate(true)
		if not runtime_delivery_active:
			var immediate_result := narrative_clock_completion_result.duplicate(true)
			narrative_clock_completion_result = {}
			_refresh_after_clock_only(immediate_result)

func _refresh_after_clock_only(result: Dictionary) -> void:
	if narrative_clock_animation_active or runtime_provider == null:
		return
	refresh_from_runtime()
	var destination := str(result.get("destination", ""))
	if destination == "conversation":
		if screen_mode != "conversation" or active_thread_id != str(result.get("thread_id", "")):
			open_thread(str(result.get("thread_id", "")))
		return
	if destination == "list":
		_set_screen_mode("list")
		conversation_screen.visible = false
		conversation_list.visible = true
		conversation_list.call_deferred("focus_thread", str(result.get("focus_thread_id", "")))

func _set_clock_interactions_blocked(blocked: bool) -> void:
	_set_runtime_delivery_interactions_blocked(blocked)
	if conversation_screen != null and conversation_screen.choice_bar != null:
		conversation_screen.choice_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE if blocked else Control.MOUSE_FILTER_STOP
	var shell: Node = _portrait_shell()
	if shell != null:
		if shell.messages_button != null: shell.messages_button.disabled = blocked
		if shell.gallery_button != null: shell.gallery_button.disabled = blocked

func _authoritative_narrative_time_text() -> String:
	if runtime_provider != null:
		return runtime_provider.current_narrative_time_text()
	return str(content_source.get("narrative_time", ""))

func _start_runtime_day_card(presentation: Dictionary) -> void:
	if presentation.is_empty() or is_day_transition_active():
		return
	_save_reading_position()
	_set_screen_mode("day_transition")
	conversation_screen.visible = false
	conversation_list.visible = false
	day_transition_state = {"active": true, "runtime": true}
	_set_gallery_navigation_blocked(true)
	day_transition.configure_presentation(presentation, PORTRAIT_THEME, _reduced_motion_enabled())

func _apply_content_source(source: Dictionary) -> void:
	characters = source.get("characters", {}).duplicate(true)
	threads = _dictionary_array(source.get("threads", []))
	transcripts.clear()
	for thread_id in source.get("messages_by_thread", {}):
		transcripts[str(thread_id)] = _dictionary_array(source["messages_by_thread"][thread_id])
	available_choices.clear()
	for thread_id in source.get("choices_by_thread", {}):
		available_choices[str(thread_id)] = _dictionary_array(source["choices_by_thread"][thread_id])

func _finish_runtime_off_phone_transition() -> void:
	var result: Dictionary = runtime_provider.confirm_transition()
	if not bool(result.get("accepted", false)):
		return
	off_phone_transition.dismiss()
	off_phone_state = {}
	_set_gallery_navigation_blocked(false)
	refresh_from_runtime()
	_refresh_runtime_gallery()
	if str(result.get("destination", "")) == "list":
		_set_screen_mode("list")
		conversation_screen.visible = false
		conversation_list.visible = true
		var unlocked_id := str(result.get("unlocked_thread_id", ""))
		var notification: Dictionary = result.get("notification", {})
		var unlocked_thread := _thread_for(unlocked_id)
		if not unlocked_thread.is_empty():
			_show_notification(unlocked_thread, str(notification.get("body", "")), "22:57")
		conversation_list.call_deferred("focus_thread", unlocked_id)
		return
	if str(result.get("destination", "")) == "day_transition":
		_start_narrative_clock_transition(result.get("transition", {}))
		return
	_start_runtime_day_end(result.get("day_end", {}))

func _start_runtime_day_end(presentation: Dictionary) -> void:
	_set_screen_mode("day_transition")
	conversation_screen.visible = false
	conversation_list.visible = false
	day_transition_state = {"active": true, "runtime": true}
	_set_gallery_navigation_blocked(true)
	day_transition.configure_presentation(presentation, PORTRAIT_THEME, _reduced_motion_enabled())

func _load_demo_data() -> void:
	var demo: Dictionary = DEMO_DATA.build()
	characters = demo.get("characters", {}).duplicate(true)
	threads = _dictionary_array(demo.get("threads", []))
	var source_transcripts: Dictionary = demo.get("messages_by_thread", {})
	for thread_id in source_transcripts:
		transcripts[str(thread_id)] = _dictionary_array(source_transcripts[thread_id]).duplicate(true)
	var source_choices: Dictionary = demo.get("choices_by_thread", {})
	for thread_id in source_choices:
		available_choices[str(thread_id)] = _dictionary_array(source_choices[thread_id]).duplicate(true)
	incoming_by_thread = demo.get("incoming_by_thread", {}).duplicate(true)
	current_demo_day_value = int(demo.get("current_demo_day", 2))
	day_transition_deltas = demo.get("day_transition_deltas", {}).duplicate(true)

func _apply_demo_day_delta(to_day: int) -> String:
	var delta: Dictionary = day_transition_deltas.get(to_day, {})
	if delta.is_empty():
		return ""
	var thread_id := str(delta.get("thread_id", ""))
	if applied_demo_day_transitions.has(to_day):
		return thread_id
	var thread := _thread_for(thread_id)
	var divider: Dictionary = delta.get("divider", {})
	var message: Dictionary = delta.get("message", {})
	if thread.is_empty() or divider.is_empty() or message.is_empty():
		return ""
	var thread_messages := _dictionary_array(transcripts.get(thread_id, []))
	thread_messages.append(divider.duplicate(true))
	thread_messages.append(message.duplicate(true))
	transcripts[thread_id] = thread_messages
	thread["last_preview"] = str(message.get("text", ""))
	thread["last_timestamp"] = str(message.get("timestamp", ""))
	thread["unread_count"] = int(thread.get("unread_count", 0)) + 1
	applied_demo_day_transitions[to_day] = 1
	return thread_id

func _build() -> void:
	for child in get_children():
		child.queue_free()
	conversation_list = CONVERSATION_LIST_SCRIPT.new()
	conversation_list.name = "ConversationList"
	conversation_list.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	conversation_list.thread_selected.connect(open_thread)
	add_child(conversation_list)
	conversation_list.configure(threads, characters, PORTRAIT_THEME, runtime_provider == null)
	conversation_screen = CONVERSATION_SCREEN_SCENE.instantiate()
	conversation_screen.name = "PortraitConversationScreen"
	conversation_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	conversation_screen.visible = false
	conversation_screen.back_requested.connect(return_to_list)
	conversation_screen.choice_selected.connect(_on_choice_selected)
	conversation_screen.image_requested.connect(_on_image_requested)
	conversation_screen.reading_speed_requested.connect(func(): reading_speed_requested.emit())
	add_child(conversation_screen)
	off_phone_transition = OFF_PHONE_TRANSITION_SCRIPT.new()
	off_phone_transition.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	off_phone_transition.visible = false
	off_phone_transition.z_index = 5
	off_phone_transition.resume_requested.connect(finish_off_phone_transition)
	add_child(off_phone_transition)
	day_transition = DAY_TRANSITION_SCRIPT.new()
	day_transition.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	day_transition.visible = false
	day_transition.z_index = 6
	day_transition.continue_requested.connect(finish_day_transition)
	day_transition.secondary_requested.connect(finish_secondary_day_transition)
	add_child(day_transition)
	notification_banner = NOTIFICATION_BANNER_SCRIPT.new()
	notification_banner.set_anchors_preset(Control.PRESET_TOP_WIDE)
	notification_banner.offset_left = 12.0
	notification_banner.offset_top = 0.0
	notification_banner.offset_right = -12.0
	notification_banner.offset_bottom = 96.0
	notification_banner.z_index = 10
	notification_banner.visible = false
	notification_banner.open_requested.connect(_on_notification_open_requested)
	notification_banner.dismiss_requested.connect(_on_notification_dismiss_requested)
	add_child(notification_banner)

func _on_image_requested(message_id: String, media_ref: String) -> void:
	if runtime_delivery_active or screen_mode != "conversation" or is_off_phone_transition_active() or is_day_transition_active():
		return
	if active_thread_id == "" or media_ref == "" or _thread_for(active_thread_id).is_empty():
		return
	var accepted: Dictionary = {}
	for message in _dictionary_array(transcripts.get(active_thread_id, [])):
		if str(message.get("message_id", "")) == message_id:
			accepted = message
			break
	if accepted.is_empty() or str(accepted.get("content_type", "")) != "IMAGE":
		return
	if str(accepted.get("media_ref", "")) != media_ref or bool(accepted.get("is_player", false)):
		return
	var author: Dictionary = characters.get(str(accepted.get("author_id", "")), {})
	if author.is_empty():
		return
	var presentation := {
		"photo_id": message_id,
		"visual_ref": media_ref,
		"access_state": "UNLOCKED",
		"source_kind": "messages",
		"character_id": str(accepted.get("author_id", "")),
		"display_name": str(author.get("display_name", "")),
		"accent_color": Color.from_string(str(author.get("accent_color", "#8D63E6")), PORTRAIT_THEME.MESSAGE_ACCENT),
		"context_label": "Conversation",
		"timestamp": str(accepted.get("timestamp", "")),
		"caption": str(accepted.get("text", "")),
		"placeholder_label": str(accepted.get("placeholder_label", "Photo de démonstration")),
	}
	var provenance := {
		"source_kind": "messages",
		"thread_id": active_thread_id,
		"message_id": message_id,
		"reading_position": conversation_screen.get_reading_position(),
	}
	photo_requested.emit(presentation, provenance)

func restore_after_photo_viewer(provenance: Dictionary, focus_target: Variant) -> void:
	var thread_id := str(provenance.get("thread_id", ""))
	if screen_mode != "conversation" or active_thread_id != thread_id:
		return
	await get_tree().process_frame
	await get_tree().process_frame
	var value := int(provenance.get("reading_position", 0))
	conversation_screen.timeline.set_reading_position(value)
	reading_positions[thread_id] = conversation_screen.get_reading_position()
	if is_instance_valid(focus_target) and focus_target is Control and focus_target.is_visible_in_tree() and focus_target.focus_mode != Control.FOCUS_NONE and (not focus_target is BaseButton or not focus_target.disabled):
		focus_target.grab_focus()
	elif not conversation_screen.focus_image_message(str(provenance.get("message_id", ""))):
		conversation_screen.back_button.grab_focus()
	call_deferred("_restore_photo_reading_position", thread_id, value)

func _restore_photo_reading_position(thread_id: String, value: int) -> void:
	if screen_mode != "conversation" or active_thread_id != thread_id:
		return
	conversation_screen.timeline.set_reading_position(value)
	reading_positions[thread_id] = conversation_screen.get_reading_position()

func _on_choice_selected(choice: Dictionary) -> void:
	if runtime_delivery_active or is_off_phone_transition_active() or is_day_transition_active():
		return
	if active_thread_id == "" or screen_mode != "conversation":
		return
	var choice_id := str(choice.get("choice_id", ""))
	if choice_id == "":
		return
	var accepted_choice: Dictionary = {}
	for available_choice in _dictionary_array(available_choices.get(active_thread_id, [])):
		if str(available_choice.get("choice_id", "")) == choice_id and bool(available_choice.get("enabled", true)):
			accepted_choice = available_choice
			break
	if accepted_choice.is_empty():
		return
	if runtime_provider != null:
		apply_runtime_choice(choice_id)
		return
	available_choices[active_thread_id] = []
	var before: int = int(conversation_screen.player_message_count())
	conversation_screen.append_player_choice(accepted_choice)
	var after: int = int(conversation_screen.player_message_count())
	if after != before + 1:
		push_error("A demo choice must append exactly one Player message")
	transcripts[active_thread_id] = conversation_screen.timeline.messages.duplicate(true)
	reading_positions[active_thread_id] = conversation_screen.get_reading_position()

func _on_notification_open_requested(thread_id: String) -> void:
	if is_day_transition_active():
		return
	_hide_notification()
	open_thread(thread_id)

func _on_notification_dismiss_requested() -> void:
	_set_content_banner_spacing(false)
	call_deferred("_restore_notification_focus")

func _show_notification(thread: Dictionary, preview: String, timestamp: String) -> void:
	if notification_banner != null and not notification_banner.visible:
		var focus_owner := get_viewport().gui_get_focus_owner()
		notification_focus_origin = focus_owner if focus_owner is Control else null
	var notification := {
		"thread_id": str(thread.get("thread_id", "")),
		"title": str(thread.get("title", "Conversation")),
		"preview": preview,
		"timestamp": timestamp,
		"avatar_ref": str(thread.get("avatar_ref", "?")),
		"accent_color": str(thread.get("accent_color", "#8D63E6")),
	}
	_set_content_banner_spacing(true)
	notification_banner.configure(notification, PORTRAIT_THEME, _reduced_motion_enabled())

func _hide_notification() -> void:
	if notification_banner != null:
		notification_banner.dismiss()
	_set_content_banner_spacing(false)
	notification_focus_origin = null

func _notification_targets(thread_id: String) -> bool:
	return (
		notification_banner != null
		and notification_banner.visible
		and str(notification_banner.notification.get("thread_id", "")) == thread_id
	)

func _restore_notification_focus() -> void:
	var previous_focus := notification_focus_origin
	notification_focus_origin = null
	if (
		previous_focus != null
		and is_instance_valid(previous_focus)
		and previous_focus.is_visible_in_tree()
		and previous_focus.focus_mode != Control.FOCUS_NONE
	):
		previous_focus.grab_focus()
		return
	if screen_mode == "list" and conversation_list != null:
		conversation_list.focus_thread(active_thread_id)
		return
	if screen_mode == "conversation" and conversation_screen != null:
		if conversation_screen.choice_bar != null and conversation_screen.choice_bar.choice_count() > 0:
			conversation_screen.choice_bar.focus_first_choice()
			return
		if conversation_screen.back_button != null:
			conversation_screen.back_button.grab_focus()

func _set_content_banner_spacing(banner_visible: bool) -> void:
	var top_offset := 120.0 if banner_visible else 0.0
	if conversation_list != null:
		conversation_list.offset_top = top_offset
	if conversation_screen != null:
		conversation_screen.offset_top = top_offset

func _reduced_motion_enabled() -> bool:
	var ancestor := get_parent()
	while ancestor != null:
		if ancestor.has_method("set_reduced_motion_enabled"):
			return bool(ancestor.get("reduced_motion_enabled"))
		ancestor = ancestor.get_parent()
	return false

func _sync_active_typing() -> void:
	if conversation_screen == null or screen_mode != "conversation" or not is_visible_in_tree():
		return
	var state: Dictionary = typing_states_by_thread.get(active_thread_id, {})
	if not bool(state.get("active", false)):
		conversation_screen.hide_typing()
		return
	var author: Dictionary = characters.get(str(state.get("author_id", "")), {})
	if author.is_empty():
		conversation_screen.hide_typing()
		return
	conversation_screen.show_typing(author, _reduced_motion_enabled(), false, reading_speed_multiplier)

func _on_visibility_changed() -> void:
	if conversation_screen == null:
		return
	if not is_visible_in_tree():
		conversation_screen.hide_typing()
		if is_off_phone_transition_active() or is_day_transition_active():
			call_deferred("_restore_messages_tab_during_off_phone")
	else:
		_sync_active_typing()

func _restore_messages_tab_during_off_phone() -> void:
	if (not is_off_phone_transition_active() and not is_day_transition_active()) or is_visible_in_tree():
		return
	var shell: Node = _portrait_shell()
	if shell != null:
		shell.call("activate_messages", false)
		if is_day_transition_active() and day_transition != null and day_transition.continue_button != null:
			day_transition.continue_button.call_deferred("grab_focus")

func _set_gallery_navigation_blocked(blocked: bool, restore_unhandled := true) -> void:
	var shell: Node = _portrait_shell()
	if shell == null:
		return
	var gallery_control: Variant = shell.get("gallery_button")
	if gallery_control is Button:
		gallery_control.disabled = blocked
	if blocked:
		shell.set_process_unhandled_input(false)
	else:
		shell.set_process_unhandled_input(restore_unhandled)

func _portrait_shell():
	var ancestor := get_parent()
	while ancestor != null:
		if ancestor.has_method("activate_gallery") and ancestor.has_method("activate_messages"):
			return ancestor
		ancestor = ancestor.get_parent()
	return null

func _refresh_runtime_gallery() -> void:
	if runtime_provider == null:
		return
	var shell = _portrait_shell()
	if shell != null and shell.gallery_screen != null:
		shell.gallery_screen.refresh_content_source(runtime_provider.gallery_source())

func _off_phone_presentation_for(thread_id: String) -> Dictionary:
	var thread_transcript := _dictionary_array(transcripts.get(thread_id, []))
	for index in range(thread_transcript.size() - 1, -1, -1):
		var message: Dictionary = thread_transcript[index]
		if str(message.get("content_type", "")) == "OFF_PHONE_TRANSITION":
			return message
	return {}

func _off_phone_presentation_count(thread_id: String) -> int:
	var count := 0
	for message in _dictionary_array(transcripts.get(thread_id, [])):
		if str(message.get("content_type", "")) == "OFF_PHONE_TRANSITION":
			count += 1
	return count

func _thread_accepts_author(thread: Dictionary, author_id: String) -> bool:
	var participants: Variant = thread.get("participant_ids", [])
	return participants is Array and participants.has(author_id)

func _simulation_timestamp(source: Dictionary, sequence: int) -> String:
	var hour := int(source.get("hour", 22))
	var minute := int(source.get("minute", 0)) + sequence - 1
	hour += minute / 60
	minute %= 60
	return "%02d:%02d" % [hour % 24, minute]

func _first_unread_message_id(thread_id: String) -> String:
	for message in _dictionary_array(transcripts.get(thread_id, [])):
		if not bool(message.get("is_player", false)) and not bool(message.get("is_read", true)):
			return str(message.get("message_id", ""))
	return ""

func _mark_thread_read(thread_id: String) -> void:
	var updated_messages := _dictionary_array(transcripts.get(thread_id, []))
	for message in updated_messages:
		message["is_read"] = true
	transcripts[thread_id] = updated_messages
	var thread := _thread_for(thread_id)
	if not thread.is_empty():
		thread["unread_count"] = 0
		conversation_list.update_thread_presentation(thread)

func _save_reading_position() -> void:
	if active_thread_id != "" and conversation_screen != null and screen_mode == "conversation" and conversation_screen.timeline != null:
		reading_positions[active_thread_id] = conversation_screen.get_reading_position()

func _thread_for(thread_id: String) -> Dictionary:
	for thread in threads:
		if str(thread.get("thread_id", "")) == thread_id:
			return thread
	return {}

func _first_thread_id(group: bool) -> String:
	for thread in threads:
		if bool(thread.get("is_group", false)) == group:
			return str(thread.get("thread_id", ""))
	return ""

func _first_thread_by_unread(has_unread: bool) -> String:
	for thread in threads:
		if (int(thread.get("unread_count", 0)) > 0) == has_unread:
			return str(thread.get("thread_id", ""))
	return ""

func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append(item.duplicate(true))
	return result
