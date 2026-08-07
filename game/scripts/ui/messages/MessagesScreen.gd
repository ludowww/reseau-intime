extends Control

class_name MessagesScreen

signal photo_requested(presentation: Dictionary, provenance: Dictionary)
signal scene_sequence_requested(sequence: Array[Dictionary], provenance: Dictionary)
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
const TIME_PASSAGE_OVERLAY_SCENE := preload("res://scenes/portrait/messages/TimePassageOverlay.tscn")
const NARRATIVE_TIME := preload("res://scripts/shared/NarrativeTime.gd")
const INTER_MESSAGE_PAUSE_SECONDS := 0.30
const IMAGE_TYPING_DURATION_SECONDS := 1.50
const MIN_TYPING_SECONDS_X3 := 0.35
const MIN_TYPING_SECONDS_X8 := 0.22
const MIN_PAUSE_SECONDS := 0.04
const REDUCED_MOTION_CLOCK_DELAY_SECONDS := 0.15
const TRANSITION_CARD_DECISION := "DECISION"
const TRANSITION_CARD_CONTENT_END := "CONTENT_END"

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
var list_notification_host: Control
var notification_banner
# Bounded presentation-only notification state; never serialized into providers.
var active_notification: Dictionary = {}
var active_notification_generation := 0
var pending_notification: Dictionary = {}
var notification_focus_origin: Control
var notification_photo_viewer_blocked := false
var off_phone_transition
var day_transition
var time_passage_overlay
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
# Bounded, non-serialized presentation state. Providers remain authoritative.
var transition_flow_active := false
var transition_flow_request_id := 0
var transition_flow_phase := ""
var transition_flow_presentation: Dictionary = {}
var transition_flow_progress := 0.0
var transition_flow_from_minutes := -1
var transition_flow_to_minutes := -1
var transition_flow_pending_result: Dictionary = {}
var transition_flow_next_day_presentation: Dictionary = {}
var authoritative_resume_request_id := 0
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
	if _runtime_has("attach_messages_screen"):
		runtime_provider.call("attach_messages_screen", self)


func activate_runtime_content_source(source: Dictionary, provider) -> void:
	configure_content_source(source, provider)
	_initialize_runtime_source(source)
	if conversation_list != null:
		conversation_list.configure(threads, characters, PORTRAIT_THEME, false)
	if conversation_screen != null:
		conversation_screen.visible = false
	if conversation_list != null:
		conversation_list.visible = true
	_set_screen_mode("list")
	call_deferred("_present_notification", false)

func _runtime_has(capability: String) -> bool:
	return runtime_provider != null and runtime_provider.has_method(capability)

func _runtime_messages_enabled() -> bool:
	return _runtime_has("presentation_source")

func _runtime_has_all(capabilities: Array) -> bool:
	for capability in capabilities:
		if not _runtime_has(str(capability)):
			return false
	return true

func _runtime_time_flow_enabled() -> bool:
	return _runtime_has_all([
		"current_narrative_time_minutes",
		"current_narrative_time_text",
		"commit_narrative_time",
		"complete_pending_transition_flow",
		"confirm_day_transition",
		"confirm_transition",
		"automatic_day_handoff",
		"content_end",
	])

func _runtime_notify(capability: String, arguments: Array = []):
	if not _runtime_has(capability):
		return null
	return runtime_provider.callv(capability, arguments)

func _set_screen_mode(mode: String) -> void:
	if screen_mode == mode:
		return
	screen_mode = mode
	screen_mode_changed.emit(screen_mode)
	call_deferred("_present_notification", false)

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
	if time_passage_overlay != null:
		time_passage_overlay.set_compact_height_mode(enabled)

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	if content_source.is_empty():
		_load_demo_data()
	elif _runtime_messages_enabled():
		_initialize_runtime_source(content_source)
	else:
		_apply_content_source(content_source)
	_build()
	visibility_changed.connect(_on_visibility_changed)
	_runtime_notify("on_messages_ui_ready")
	if _runtime_has("pending_transition_flow"):
		call_deferred("_resume_authoritative_transition_flow")
	if _runtime_has("pending_scene_sequence"):
		call_deferred("_resume_authoritative_scene_sequence")

func focus_first_conversation() -> void:
	if conversation_list != null and screen_mode == "list":
		conversation_list.focus_first_card()

func open_thread(thread_id: String) -> void:
	if runtime_delivery_active or is_off_phone_transition_active() or is_day_transition_active() or is_time_passage_active():
		return
	var selected := _thread_for(thread_id)
	if selected.is_empty():
		return
	_save_reading_position()
	var first_unread_message_id := _first_unread_message_id(thread_id)
	active_thread_id = thread_id
	conversation_list.visible = false
	conversation_screen.visible = true
	if _notification_targets(thread_id):
		_hide_notification()
	var messages := _dictionary_array(transcripts.get(thread_id, []))
	var choices := _dictionary_array(available_choices.get(thread_id, []))
	var position := int(reading_positions.get(thread_id, -1))
	conversation_screen.configure(selected, messages, choices, characters, PORTRAIT_THEME, position, first_unread_message_id)
	_notify_runtime_choices_presented(thread_id, choices)
	conversation_screen.set_narrative_day_short(_authoritative_narrative_day_short())
	conversation_screen.set_narrative_time(_authoritative_narrative_time_text())
	conversation_screen.set_compact_height_mode(compact_height_mode)
	_set_screen_mode("conversation")
	_sync_active_typing()
	if not _runtime_messages_enabled() or _dictionary_array(runtime_pending_messages_by_thread.get(thread_id, [])).is_empty():
		_mark_thread_read(thread_id)
	if _runtime_messages_enabled():
		call_deferred("_start_pending_delivery_for_thread", thread_id)

func return_to_list() -> void:
	if runtime_delivery_active or is_off_phone_transition_active() or is_day_transition_active() or is_time_passage_active():
		return
	_save_reading_position()
	conversation_screen.hide_typing()
	_set_screen_mode("list")
	conversation_screen.visible = false
	conversation_list.visible = true
	conversation_list.call_deferred("focus_thread", active_thread_id)
	if _runtime_has("on_thread_returned"):
		var transition: Dictionary = runtime_provider.on_thread_returned(active_thread_id)
		if not transition.is_empty():
			call_deferred("_start_narrative_clock_transition", transition)

func activate_first_choice() -> void:
	if runtime_delivery_active or is_off_phone_transition_active() or is_day_transition_active() or is_time_passage_active():
		return
	if screen_mode == "conversation":
		conversation_screen.activate_first_choice()

func start_typing(thread_id: String, author_id: String) -> void:
	if is_off_phone_transition_active() or is_day_transition_active() or is_time_passage_active():
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
	if is_off_phone_transition_active() or is_day_transition_active() or is_time_passage_active():
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
	if is_off_phone_transition_active() or is_day_transition_active() or is_time_passage_active():
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
		thread["has_unread_content"] = false
		reading_positions[thread_id] = conversation_screen.get_reading_position()
		if _notification_targets(thread_id):
			_hide_notification()
	else:
		thread["unread_count"] = int(thread.get("unread_count", 0)) + 1
		thread["has_unread_content"] = true
		_show_notification(thread, preview, timestamp, str(message.get("message_id", "")))
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
		"shell_was_processing_unhandled_input": shell.is_processing_unhandled_input() if shell != null else false,
	}
	conversation_screen.hide_typing()
	conversation_screen.visible = false
	conversation_list.visible = false
	_defer_active_notification()
	_set_screen_mode("off_phone")
	_set_gallery_navigation_blocked(true)
	off_phone_transition.configure(str(off_phone_state.get("label", "")), PORTRAIT_THEME, _reduced_motion_enabled())

func finish_off_phone_transition() -> void:
	if is_day_transition_active():
		return
	if not is_off_phone_transition_active():
		return
	if _runtime_has("confirm_transition"):
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
	off_phone_state = {}
	_resume_pending_notification()
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
		"updated_thread_id": str(delta.get("thread_id", "")),
		"shell_was_processing_unhandled_input": shell.is_processing_unhandled_input() if shell != null else false,
	}
	conversation_screen.hide_typing()
	conversation_screen.visible = false
	conversation_list.visible = false
	_defer_active_notification()
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
	if _runtime_has("confirm_day_transition"):
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
	_set_screen_mode("list")
	conversation_screen.visible = false
	conversation_list.visible = true
	conversation_list.configure(threads, characters, PORTRAIT_THEME, runtime_provider == null)
	day_transition_state = {}
	_resume_pending_notification()
	_set_gallery_navigation_blocked(false, bool(saved_state.get("shell_was_processing_unhandled_input", false)))
	var focus_thread_id := updated_thread_id if updated_thread_id != "" else previous_thread_id
	conversation_list.call_deferred("focus_thread", focus_thread_id)

func finish_secondary_day_transition() -> void:
	if not is_day_transition_active() or not _runtime_has("confirm_secondary_day_transition"):
		return
	var result: Dictionary = runtime_provider.confirm_secondary_day_transition()
	if not bool(result.get("accepted", false)):
		return
	day_transition.reset_surface()
	day_transition_state = {}
	_start_narrative_clock_transition(result.get("transition", {}))

func _finish_runtime_day_transition() -> void:
	if not _runtime_has("confirm_day_transition"):
		return
	var result: Dictionary = runtime_provider.confirm_day_transition()
	if not bool(result.get("accepted", false)):
		day_transition.reset_surface()
		day_transition_state = {}
		_clear_notification_state(false)
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
		_resume_pending_notification()
		return
	_set_screen_mode("list")
	conversation_screen.visible = false
	conversation_list.visible = true
	_resume_pending_notification()
	conversation_list.call_deferred("focus_thread", str(result.get("focus_thread_id", "")))

func is_day_transition_active() -> bool:
	return bool(day_transition_state.get("active", false))

func is_time_passage_active() -> bool:
	return transition_flow_active and time_passage_overlay != null and time_passage_overlay.visible

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
		"notification_visible": _notification_visible(),
		"notification_thread_id": str(active_notification.get("thread_id", "")) if not active_notification.is_empty() else "",
		"notification_id": str(active_notification.get("notification_id", "")) if not active_notification.is_empty() else "",
		"notification_generation": active_notification_generation,
		"notification_pending": not pending_notification.is_empty(),
		"notification_pending_thread_id": str(pending_notification.get("thread_id", "")) if not pending_notification.is_empty() else "",
		"list_notification_host_visible": list_notification_host != null and list_notification_host.visible,
		"list_notification_rect": notification_banner.get_global_rect() if notification_banner != null and notification_banner.visible else Rect2(),
		"visible_notification_count": _visible_notification_count(),
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
		"transition_flow_active": transition_flow_active,
		"transition_flow_phase": transition_flow_phase,
		"time_passage_visible": time_passage_overlay != null and time_passage_overlay.visible,
		"time_passage_surface_count": 1 if time_passage_overlay != null and is_instance_valid(time_passage_overlay) else 0,
		"phone_underlay_visible": (conversation_screen != null and conversation_screen.visible) or (conversation_list != null and conversation_list.visible),
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

func thread_has_unread_content(thread_id: String) -> bool:
	var thread := _thread_for(thread_id)
	return bool(thread.get("has_unread_content", false)) if not thread.is_empty() else false

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

func _visible_notification_count() -> int:
	var count := 0
	if notification_banner != null and notification_banner.visible:
		count += 1
	if conversation_screen != null and conversation_screen.header_notification_visible():
		count += 1
	return count

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
	if not _runtime_messages_enabled() or runtime_delivery_active:
		return
	var next_source: Dictionary = runtime_provider.presentation_source() if source.is_empty() else source
	_reconcile_runtime_source(next_source)
	if conversation_list != null:
		conversation_list.configure(threads, characters, PORTRAIT_THEME, runtime_provider == null)
	if screen_mode == "conversation":
		conversation_screen.set_narrative_day_short(_authoritative_narrative_day_short())
		conversation_screen.set_narrative_time(_authoritative_narrative_time_text())
		_start_pending_delivery_for_thread(active_thread_id)

func _initialize_runtime_source(source: Dictionary) -> void:
	content_source = source.duplicate(true)
	characters = source.get("characters", {}).duplicate(true)
	threads = _dictionary_array(source.get("threads", []))
	_normalize_threads_unread_state()
	transcripts.clear()
	available_choices.clear()
	var seeded_ids_by_thread: Dictionary = {}
	if _runtime_has("presented_message_ids_by_thread"):
		var raw_seeded_ids = runtime_provider.call("presented_message_ids_by_thread")
		if raw_seeded_ids is Dictionary:
			seeded_ids_by_thread = raw_seeded_ids
	for raw_thread_id in source.get("messages_by_thread", {}):
		var thread_id := str(raw_thread_id)
		var provider_messages := _dictionary_array(source["messages_by_thread"][raw_thread_id])
		var seeded_ids: Array = seeded_ids_by_thread.get(thread_id, [])
		var seeded_messages: Array[Dictionary] = []
		var valid_seed := seeded_ids.size() <= provider_messages.size()
		for index in range(seeded_ids.size()):
			if str(provider_messages[index].get("message_id", "")) != str(seeded_ids[index]):
				valid_seed = false
				break
			seeded_messages.append(provider_messages[index].duplicate(true))
		if not valid_seed:
			push_error("Runtime presented message IDs are not a provider prefix")
			seeded_ids = []
			seeded_messages = []
		transcripts[thread_id] = seeded_messages
		runtime_presented_message_ids_by_thread[thread_id] = seeded_ids.duplicate()
	_reconcile_runtime_source(source)

func _reconcile_runtime_source(source: Dictionary) -> bool:
	content_source = source.duplicate(true)
	characters = source.get("characters", {}).duplicate(true)
	threads = _dictionary_array(source.get("threads", []))
	_normalize_threads_unread_state()
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
	if not _runtime_messages_enabled() or runtime_delivery_active or screen_mode != "conversation" or active_thread_id != thread_id:
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
	_notify_runtime_choices_presented(active_thread_id, choice_presentations)

func unlock_runtime_thread(_thread_id: String) -> void:
	refresh_from_runtime()

func apply_runtime_choice(choice_id: String) -> bool:
	if not _runtime_has("apply_choice") or runtime_delivery_active:
		return false
	var thread_id := active_thread_id
	var previous_choices := _dictionary_array(available_choices.get(thread_id, []))
	_hide_runtime_choices_for_delivery()
	var result: Dictionary = runtime_provider.apply_choice(active_thread_id, choice_id)
	if not bool(result.get("accepted", false)):
		replace_runtime_choices(previous_choices)
		return false
	if not _apply_runtime_message_updates(thread_id, _dictionary_array(result.get("updated_messages", []))):
		push_error("Runtime message update could not be applied to the active transcript")
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

func _apply_runtime_message_updates(thread_id: String, updates: Array[Dictionary]) -> bool:
	if updates.is_empty(): return true
	if thread_id == "" or thread_id != active_thread_id or conversation_screen == null: return false
	for update in updates:
		var message_id := str(update.get("message_id", "")); var current := {}
		for message in conversation_screen.timeline.messages:
			if str(message.get("message_id", "")) == message_id: current = message; break
		if current.is_empty(): return false
		for immutable_key in ["message_id","author_id","timestamp","source_day","is_player"]:
			if update.get(immutable_key) != current.get(immutable_key): return false
		if not conversation_screen.timeline.replace_message(update): return false
	transcripts[thread_id] = conversation_screen.timeline.messages.duplicate(true)
	reading_positions[thread_id] = conversation_screen.get_reading_position()
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

func _runtime_message_for_visual_insertion(message: Dictionary, _thread_id: String) -> Dictionary:
	return message.duplicate(true)

func _mark_runtime_message_presented(thread_id: String, message: Dictionary) -> void:
	var ids: Array = runtime_presented_message_ids_by_thread.get(thread_id, []).duplicate()
	var message_id := str(message.get("message_id", ""))
	if message_id != "" and not ids.has(message_id):
		ids.append(message_id)
	runtime_presented_message_ids_by_thread[thread_id] = ids
	if _runtime_has("mark_message_presented"):
		runtime_provider.mark_message_presented(message_id)
		if conversation_screen != null and _runtime_has("current_narrative_time_text"):
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
	if _runtime_has("mark_thread_batch_presented"):
		runtime_provider.mark_thread_batch_presented(thread_id)
	if not _sync_runtime_delivery_provider(thread_id):
		return
	_mark_thread_read(thread_id)
	var pending_choices := runtime_delivery_pending_choices.duplicate(true)
	var pending_transition := runtime_delivery_pending_transition.duplicate(true)
	if not pending_transition.is_empty():
		if not await _start_runtime_transition_after_layout(request_id, thread_id, pending_transition):
			return
		runtime_pending_transition_by_thread[thread_id] = {}
		_complete_runtime_delivery(false)
		if not transition_flow_pending_result.is_empty():
			var flow_result := transition_flow_pending_result.duplicate(true)
			transition_flow_pending_result = {}
			_apply_time_passage_result(flow_result, pending_transition)
		elif str(pending_transition.get("transition_mode", "")) == "clock_only" and not narrative_clock_completion_result.is_empty():
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
	var completed_thread_id := runtime_delivery_thread_id
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
	_runtime_notify("on_messages_delivery_completed", [completed_thread_id])

func _runtime_delivery_request_is_current(request_id: int, thread_id: String) -> bool:
	return is_inside_tree() and not runtime_delivery_cancelled and runtime_delivery_active and request_id == runtime_delivery_request_id and thread_id == runtime_delivery_thread_id and active_thread_id == thread_id

func _sync_runtime_delivery_provider(thread_id: String) -> bool:
	if not _runtime_messages_enabled():
		return false
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
		local_thread["unread_count"] = int(source_thread.get("unread_count", 0))
		local_thread["has_unread_content"] = bool(source_thread.get("has_unread_content", false))
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
	transition_flow_active = false
	transition_flow_request_id += 1
	authoritative_resume_request_id += 1
	transition_flow_pending_result = {}
	if time_passage_overlay != null:
		time_passage_overlay.cancel_flow()
	if conversation_screen != null:
		conversation_screen.hide_typing()

func _start_runtime_transition_after_layout(request_id: int, thread_id: String, transition: Dictionary) -> bool:
	await get_tree().process_frame
	if not _runtime_delivery_request_is_current(request_id, thread_id) or not _runtime_time_flow_enabled():
		return false
	await _start_time_passage_flow(transition)
	await get_tree().process_frame
	if not _runtime_delivery_request_is_current(request_id, thread_id):
		return false
	return is_day_transition_active() or not transition_flow_pending_result.is_empty() or not transition.is_empty()

func _start_narrative_clock_transition(transition: Dictionary) -> void:
	await _start_time_passage_flow(transition)

func _resume_authoritative_transition_flow() -> void:
	if not _runtime_has("pending_transition_flow") or transition_flow_active or not is_inside_tree():
		return
	authoritative_resume_request_id += 1
	var request_id := authoritative_resume_request_id
	await get_tree().process_frame
	if request_id != authoritative_resume_request_id or transition_flow_active or not is_inside_tree():
		return
	var pending: Dictionary = runtime_provider.pending_transition_flow()
	if not pending.is_empty():
		await _start_time_passage_flow(pending)

func _run_narrative_clock(_request_id: int) -> void:
	# Compatibility shim: CLOCK is now rendered by TimePassageOverlay.
	await get_tree().process_frame

func _start_time_passage_flow(transition: Dictionary) -> void:
	if not _runtime_time_flow_enabled() or transition_flow_active or transition.is_empty():
		return
	transition_flow_request_id += 1
	var request_id := transition_flow_request_id
	transition_flow_active = true
	transition_flow_presentation = transition.duplicate(true)
	transition_flow_pending_result = {}
	transition_flow_next_day_presentation = transition.get("next_day_presentation", {}).duplicate(true)
	transition_flow_from_minutes = int(runtime_provider.current_narrative_time_minutes())
	transition_flow_to_minutes = NARRATIVE_TIME.parse_narrative_time(str(transition.get("to_time", "")))
	narrative_clock_animation_active = str(transition.get("transition_mode", "")) in ["clock_only", "clock_then_card"] or transition.get("flow_phases", []).has("CLOCK")
	narrative_clock_request_id = request_id
	narrative_clock_from_minutes = transition_flow_from_minutes
	narrative_clock_to_minutes = transition_flow_to_minutes
	narrative_clock_pending_transition = transition.duplicate(true)
	_save_reading_position()
	if conversation_screen != null: conversation_screen.hide_typing()
	_defer_active_notification()
	_set_clock_interactions_blocked(true)
	var phases := _time_passage_phases(transition)
	time_passage_overlay.z_index = 8
	time_passage_overlay.set_reduced_motion(_reduced_motion_enabled())
	time_passage_overlay.set_compact_height_mode(compact_height_mode)
	if not time_passage_overlay.play_flow(phases, request_id):
		transition_flow_active = false
		_set_clock_interactions_blocked(false)
		_resume_pending_notification()
		return
	var completed_request_id: int = await time_passage_overlay.flow_finished
	_on_time_passage_flow_finished(completed_request_id)

func _time_passage_phases(transition: Dictionary) -> Array[Dictionary]:
	var requested: Array = transition.get("flow_phases", [])
	if requested.is_empty():
		requested = ["CLOCK"] if str(transition.get("transition_mode", "")) in ["clock_only", "clock_then_card"] else ["OFF_PHONE"]
	var result: Array[Dictionary] = []
	for phase_name in requested:
		var phase := {"phase": str(phase_name)}
		if str(phase_name) == "CLOCK":
			phase.merge({"from_minutes": transition_flow_from_minutes, "to_minutes": transition_flow_to_minutes, "from_time": runtime_provider.current_narrative_time_text(), "to_time": str(transition.get("to_time", "")), "duration_seconds": float(transition.get("duration_seconds", 4.0))})
		elif str(phase_name) == "OFF_PHONE":
			phase["text"] = str(transition.get("text", _off_phone_presentation_for(active_thread_id).get("text", "")))
		elif str(phase_name) == "NIGHT":
			phase["time"] = runtime_provider.current_narrative_time_text()
		elif str(phase_name) == "NEW_DAY":
			var next_day: Dictionary = transition_flow_next_day_presentation
			phase.merge({"eyebrow": str(next_day.get("eyebrow", "")), "title": str(next_day.get("title", "")), "time": str(next_day.get("subtitle", "")), "body": str(next_day.get("body", ""))})
		result.append(phase)
	return result

func _on_time_passage_flow_finished(request_id: int) -> void:
	if not transition_flow_active or request_id != transition_flow_request_id or not is_inside_tree():
		return
	var transition := transition_flow_presentation.duplicate(true)
	if transition_flow_to_minutes >= transition_flow_from_minutes:
		runtime_provider.commit_narrative_time(transition_flow_to_minutes)
	transition_flow_active = false
	transition_flow_phase = ""
	narrative_clock_animation_active = false
	narrative_clock_pending_transition = {}
	_set_clock_interactions_blocked(false)
	if str(transition.get("transition_mode", "")) == "clock_then_card":
		time_passage_overlay.dismiss()
		_start_runtime_day_card(transition.get("presentation", {}))
		return
	var result: Dictionary
	var resume_action := str(transition.get("resume_action", ""))
	if resume_action != "":
		result = runtime_provider.complete_pending_transition_flow(resume_action)
	elif str(transition.get("transition_mode", "")) == "clock_only":
		result = runtime_provider.confirm_day_transition()
	else:
		result = runtime_provider.confirm_transition()
	transition_flow_pending_result = result.duplicate(true)
	if str(result.get("destination", "")) == "day_end" and transition.get("flow_phases", []).has("NEW_DAY"):
		result = runtime_provider.automatic_day_handoff()
		transition_flow_pending_result = result.duplicate(true)
	time_passage_overlay.dismiss()
	if runtime_delivery_active:
		return
	_apply_time_passage_result(result, transition)

func _apply_time_passage_result(result: Dictionary, transition: Dictionary) -> void:
	if not bool(result.get("accepted", false)):
		_resume_pending_notification()
		return
	refresh_from_runtime()
	_refresh_runtime_gallery()
	var destination := str(result.get("destination", ""))
	if destination == "scene_sequence":
		var sequence := _dictionary_array(result.get("sequence", []))
		var provenance: Dictionary = result.get("provenance", {})
		if not sequence.is_empty() and str(provenance.get("source_kind", "")) == "scene":
			scene_sequence_requested.emit(sequence, provenance)
		return
	if destination == "day_transition" and result.has("transition"):
		call_deferred("_start_time_passage_flow", result.get("transition", {}))
		return
	if destination == "day_end":
		var final_presentation: Dictionary = result.get("day_end", runtime_provider.content_end())
		if str(final_presentation.get("transition_mode", "")) == "CONTENT_END" or bool(transition.get("content_end", false)):
			_start_runtime_day_end(final_presentation)
		return
	_refresh_after_clock_only(result)
	_resume_pending_notification()
	if result.has("unlocked_thread_id"):
		var unlocked_id := str(result.get("unlocked_thread_id", ""))
		var notification: Dictionary = result.get("notification", {})
		var unlocked_thread := _thread_for(unlocked_id)
		if not unlocked_thread.is_empty():
			_show_notification(unlocked_thread, str(notification.get("body", "")), runtime_provider.current_narrative_time_text())

func complete_runtime_scene_sequence() -> bool:
	if not _runtime_has("confirm_scene_sequence"):
		return false
	var result: Dictionary = runtime_provider.confirm_scene_sequence()
	if not bool(result.get("accepted", false)):
		return false
	refresh_from_runtime()
	_refresh_runtime_gallery()
	if result.has("transition"):
		call_deferred("_start_time_passage_flow", result.get("transition", {}))
	else:
		_refresh_after_clock_only(result)
	return true

func _resume_authoritative_scene_sequence() -> void:
	if not _runtime_has("pending_scene_sequence"):
		return
	var pending: Dictionary = runtime_provider.pending_scene_sequence()
	var sequence := _dictionary_array(pending.get("sequence", []))
	var provenance: Dictionary = pending.get("provenance", {})
	if sequence.size() == 3 and str(provenance.get("source_kind", "")) == "scene":
		scene_sequence_requested.emit(sequence, provenance)

func _refresh_after_clock_only(result: Dictionary) -> void:
	if narrative_clock_animation_active or not _runtime_messages_enabled():
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
		var focus_thread_id := str(result.get("focus_thread_id", result.get("unlocked_thread_id", "")))
		conversation_list.call_deferred("focus_thread", focus_thread_id)

func _set_clock_interactions_blocked(blocked: bool) -> void:
	_set_runtime_delivery_interactions_blocked(blocked)
	if conversation_screen != null and conversation_screen.choice_bar != null:
		conversation_screen.choice_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE if blocked else Control.MOUSE_FILTER_STOP
	var shell: Node = _portrait_shell()
	if shell != null:
		if shell.messages_button != null: shell.messages_button.disabled = blocked
		if shell.gallery_button != null: shell.gallery_button.disabled = blocked

func _authoritative_narrative_day_short() -> String:
	if _runtime_has("current_narrative_day_short"):
		return runtime_provider.current_narrative_day_short()
	return str(content_source.get("narrative_day_short", ""))

func _authoritative_narrative_time_text() -> String:
	if _runtime_has("current_narrative_time_text"):
		return runtime_provider.current_narrative_time_text()
	return str(content_source.get("narrative_time", ""))

func _start_runtime_day_card(presentation: Dictionary) -> void:
	if presentation.is_empty() or is_day_transition_active():
		return
	_save_reading_position()
	_defer_active_notification()
	_set_screen_mode("day_transition")
	conversation_screen.visible = false
	conversation_list.visible = false
	day_transition_state = {"active": true, "runtime": true}
	_set_gallery_navigation_blocked(true)
	day_transition.configure_presentation(presentation, PORTRAIT_THEME, _reduced_motion_enabled())

func _apply_content_source(source: Dictionary) -> void:
	characters = source.get("characters", {}).duplicate(true)
	threads = _dictionary_array(source.get("threads", []))
	_normalize_threads_unread_state()
	transcripts.clear()
	for thread_id in source.get("messages_by_thread", {}):
		transcripts[str(thread_id)] = _dictionary_array(source["messages_by_thread"][thread_id])
	available_choices.clear()
	for thread_id in source.get("choices_by_thread", {}):
		available_choices[str(thread_id)] = _dictionary_array(source["choices_by_thread"][thread_id])

func _finish_runtime_off_phone_transition() -> void:
	if not _runtime_has("confirm_transition"):
		return
	var result: Dictionary = runtime_provider.confirm_transition()
	if not bool(result.get("accepted", false)):
		return
	off_phone_transition.dismiss()
	off_phone_state = {}
	_set_gallery_navigation_blocked(false)
	refresh_from_runtime()
	_refresh_runtime_gallery()
	if str(result.get("destination", "")) == "scene_sequence":
		var sequence := _dictionary_array(result.get("sequence", []))
		var provenance: Dictionary = result.get("provenance", {})
		if sequence.size() == 3 and str(provenance.get("source_kind", "")) == "scene":
			scene_sequence_requested.emit(sequence, provenance)
		return
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
	if str(presentation.get("transition_mode", "")) == TRANSITION_CARD_CONTENT_END:
		_clear_notification_state(false)
	else:
		_defer_active_notification()
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
	_normalize_threads_unread_state()
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
	thread["has_unread_content"] = true
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
	list_notification_host = Control.new()
	list_notification_host.name = "ListNotificationHost"
	list_notification_host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	list_notification_host.mouse_filter = Control.MOUSE_FILTER_IGNORE
	list_notification_host.z_index = 4
	list_notification_host.visible = false
	add_child(list_notification_host)
	conversation_screen = CONVERSATION_SCREEN_SCENE.instantiate()
	conversation_screen.name = "PortraitConversationScreen"
	conversation_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	conversation_screen.visible = false
	conversation_screen.back_requested.connect(return_to_list)
	conversation_screen.choice_selected.connect(_on_choice_selected)
	conversation_screen.image_requested.connect(_on_image_requested)
	conversation_screen.reading_speed_requested.connect(func(): reading_speed_requested.emit())
	conversation_screen.header_notification_open_requested.connect(_on_notification_open_requested)
	conversation_screen.header_notification_dismiss_requested.connect(_on_notification_dismiss_requested)
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
	time_passage_overlay = TIME_PASSAGE_OVERLAY_SCENE.instantiate()
	time_passage_overlay.name = "TimePassageOverlay"
	time_passage_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	time_passage_overlay.z_index = 8
	time_passage_overlay.visible = false
	time_passage_overlay.phase_changed.connect(func(phase: String): transition_flow_phase = phase)
	add_child(time_passage_overlay)
	notification_banner = NOTIFICATION_BANNER_SCRIPT.new()
	notification_banner.set_anchors_preset(Control.PRESET_TOP_WIDE)
	notification_banner.offset_left = 12.0
	notification_banner.offset_top = 16.0
	notification_banner.offset_right = -12.0
	notification_banner.offset_bottom = 88.0
	notification_banner.resting_position_y = 16.0
	notification_banner.resting_position_initialized = true
	notification_banner.z_index = 1
	notification_banner.visible = false
	notification_banner.open_requested.connect(_on_notification_open_requested)
	notification_banner.dismiss_requested.connect(_on_notification_dismiss_requested)
	list_notification_host.add_child(notification_banner)

func _on_image_requested(message_id: String, media_ref: String) -> void:
	if runtime_delivery_active or screen_mode != "conversation" or is_off_phone_transition_active() or is_day_transition_active() or is_time_passage_active():
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
	if not bool(accepted.get("viewer_enabled", true)):
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
	if runtime_delivery_active or is_off_phone_transition_active() or is_day_transition_active() or is_time_passage_active():
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
	if _runtime_has("apply_choice"):
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

func _notify_runtime_choices_presented(thread_id: String, choices: Array[Dictionary]) -> void:
	if choices.is_empty() or not _runtime_has("on_choices_presented"):
		return
	if (
		conversation_screen == null
		or screen_mode != "conversation"
		or active_thread_id != thread_id
		or conversation_screen.choice_bar == null
		or not conversation_screen.choice_bar.is_visible_in_tree()
		or conversation_screen.choice_bar.choice_count() != choices.size()
	):
		return
	var choice_ids: Array = []
	for choice in choices:
		choice_ids.append(str(choice.get("choice_id", "")))
	_runtime_notify("on_choices_presented", [thread_id, choice_ids])

func present_runtime_notification(thread_id: String, message_id: String) -> bool:
	if not _runtime_messages_enabled() or thread_id.is_empty() or message_id.is_empty():
		return false
	var thread := _thread_for(thread_id)
	if thread.is_empty() or not thread_has_unread_content(thread_id):
		return false
	var provider_messages := _dictionary_array(runtime_provider_transcript_by_thread.get(thread_id, []))
	for message in provider_messages:
		if str(message.get("message_id", "")) != message_id or bool(message.get("is_read", false)):
			continue
		_show_notification(
			thread,
			str(message.get("text", "")),
			str(message.get("timestamp", "")),
			message_id,
		)
		return _notification_targets(thread_id)
	return false

func _on_notification_open_requested(thread_id: String, generation: int) -> void:
	if _notification_presentation_blocked() or active_notification.is_empty():
		return
	if int(active_notification.get("_generation", -1)) != generation:
		return
	if str(active_notification.get("thread_id", "")) != thread_id:
		return
	_clear_notification_state(false)
	open_thread(thread_id)

func _on_notification_dismiss_requested(generation: int) -> void:
	if active_notification.is_empty():
		return
	if int(active_notification.get("_generation", -1)) != generation:
		return
	var dismissed_notification := active_notification.duplicate(true)
	active_notification_generation += 1
	active_notification = {}
	_hide_notification_presenters()
	_runtime_notify("on_notification_dismissed", [dismissed_notification])
	call_deferred("_restore_notification_focus")

func _show_notification(thread: Dictionary, _preview: String, timestamp: String, message_id := "") -> void:
	var thread_id := str(thread.get("thread_id", ""))
	if thread_id == "":
		return
	var notification := {
		"notification_id": _notification_key(thread_id, message_id, timestamp, "Nouveau message !"),
		"thread_id": thread_id,
		"message_id": message_id,
		"title": str(thread.get("title", "Conversation")),
		"preview": "Nouveau message !",
		"timestamp": timestamp,
		"avatar_ref": str(thread.get("avatar_ref", "?")),
		"accent_color": str(thread.get("accent_color", "#8D63E6")),
	}
	_queue_notification(notification)

func _queue_notification(notification: Dictionary) -> void:
	var thread_id := str(notification.get("thread_id", ""))
	if _thread_for(thread_id).is_empty():
		return
	if screen_mode == "conversation" and active_thread_id == thread_id:
		if _notification_targets(thread_id):
			_clear_notification_state(false)
		return
	if active_notification.is_empty() and pending_notification.is_empty():
		var focus_owner := get_viewport().gui_get_focus_owner()
		notification_focus_origin = focus_owner if focus_owner is Control else null
	active_notification_generation += 1
	var next_notification := notification.duplicate(true)
	next_notification["_generation"] = active_notification_generation
	next_notification["_deadline_msec"] = 0
	if _notification_presentation_blocked():
		# latest pending wins; no queue is maintained.
		pending_notification = next_notification
		active_notification = {}
		_hide_notification_presenters()
		return
	active_notification = next_notification
	pending_notification = {}
	_present_notification(true)

func _present_notification(restart_timer := false) -> void:
	_hide_notification_presenters()
	if active_notification.is_empty():
		return
	if _notification_presentation_blocked():
		_defer_active_notification()
		return
	var thread_id := str(active_notification.get("thread_id", ""))
	if _thread_for(thread_id).is_empty() or (screen_mode == "conversation" and active_thread_id == thread_id):
		_clear_notification_state(false)
		return
	var now_msec := Time.get_ticks_msec()
	var deadline_msec := int(active_notification.get("_deadline_msec", 0))
	if restart_timer or deadline_msec <= now_msec:
		deadline_msec = now_msec + int(NOTIFICATION_BANNER_SCRIPT.AUTO_DISMISS_SECONDS * 1000.0)
		active_notification["_deadline_msec"] = deadline_msec
	var remaining_seconds := maxf(0.01, float(deadline_msec - now_msec) / 1000.0)
	var generation := int(active_notification.get("_generation", active_notification_generation))
	if screen_mode == "conversation" and conversation_screen != null and conversation_screen.visible:
		conversation_screen.show_header_notification(active_notification, _reduced_motion_enabled(), remaining_seconds, generation)
		if _notification_visible():
			_runtime_notify("on_notification_presented", [active_notification.duplicate(true)])
		return
	if screen_mode == "list" and list_notification_host != null and conversation_list != null and conversation_list.visible:
		list_notification_host.visible = true
		notification_banner.configure(active_notification, PORTRAIT_THEME, _reduced_motion_enabled(), true, remaining_seconds, generation)
		if _notification_visible():
			_runtime_notify("on_notification_presented", [active_notification.duplicate(true)])

func _defer_active_notification() -> void:
	if not active_notification.is_empty():
		# latest pending wins when a blocking surface starts.
		pending_notification = active_notification.duplicate(true)
		pending_notification["_deadline_msec"] = 0
		active_notification = {}
	_hide_notification_presenters()

func _resume_pending_notification() -> void:
	if pending_notification.is_empty() or _notification_presentation_blocked():
		return
	var thread_id := str(pending_notification.get("thread_id", ""))
	if _thread_for(thread_id).is_empty() or (screen_mode == "conversation" and active_thread_id == thread_id) or not thread_has_unread_content(thread_id):
		pending_notification = {}
		return
	active_notification_generation += 1
	active_notification = pending_notification.duplicate(true)
	active_notification["_generation"] = active_notification_generation
	active_notification["_deadline_msec"] = 0
	pending_notification = {}
	_present_notification(true)

func _notification_presentation_blocked() -> bool:
	return (
		notification_photo_viewer_blocked
		or screen_mode not in ["list", "conversation"]
		or transition_flow_active
		or is_time_passage_active()
		or is_off_phone_transition_active()
		or is_day_transition_active()
	)

func set_notification_photo_viewer_blocked(blocked: bool) -> void:
	if notification_photo_viewer_blocked == blocked:
		return
	notification_photo_viewer_blocked = blocked
	if blocked:
		_defer_active_notification()
	else:
		_resume_pending_notification()

func _clear_notification_state(restore_focus: bool) -> void:
	active_notification_generation += 1
	active_notification = {}
	pending_notification = {}
	_hide_notification_presenters()
	if restore_focus:
		call_deferred("_restore_notification_focus")
	else:
		notification_focus_origin = null

func _hide_notification() -> void:
	_clear_notification_state(false)

func _hide_notification_presenters() -> void:
	if notification_banner != null:
		notification_banner.dismiss()
	if list_notification_host != null:
		list_notification_host.visible = false
	if conversation_screen != null:
		conversation_screen.hide_header_notification()

func _notification_visible() -> bool:
	return (
		(notification_banner != null and notification_banner.visible)
		or (conversation_screen != null and conversation_screen.header_notification_visible())
	)

func _notification_targets(thread_id: String) -> bool:
	return (
		(not active_notification.is_empty() and str(active_notification.get("thread_id", "")) == thread_id)
		or (not pending_notification.is_empty() and str(pending_notification.get("thread_id", "")) == thread_id)
	)

func _notification_key(thread_id: String, message_id: String, timestamp: String, preview: String) -> String:
	if message_id != "":
		return "%s::%s" % [thread_id, message_id]
	return "%s::%s::%s" % [thread_id, timestamp, preview]

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
		if is_off_phone_transition_active() or is_day_transition_active() or is_time_passage_active():
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
	if not _runtime_has("gallery_source"):
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
	var last_read_message_id := ""
	for message in updated_messages:
		if not bool(message.get("is_player", false)) and not bool(message.get("is_read", true)):
			last_read_message_id = str(message.get("message_id", ""))
		message["is_read"] = true
	transcripts[thread_id] = updated_messages
	if conversation_screen != null and active_thread_id == thread_id:
		conversation_screen.timeline.messages = updated_messages.duplicate(true)
	var thread := _thread_for(thread_id)
	if not thread.is_empty():
		thread["unread_count"] = 0
		thread["has_unread_content"] = false
		conversation_list.update_thread_presentation(thread)
	if last_read_message_id != "":
		_runtime_notify("on_thread_read", [thread_id, last_read_message_id])

func _save_reading_position() -> void:
	if active_thread_id != "" and conversation_screen != null and screen_mode == "conversation" and conversation_screen.timeline != null:
		reading_positions[active_thread_id] = conversation_screen.get_reading_position()

func _normalize_threads_unread_state() -> void:
	for thread in threads:
		if not thread.has("has_unread_content"):
			thread["has_unread_content"] = int(thread.get("unread_count", 0)) > 0

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
		if bool(thread.get("has_unread_content", false)) == has_unread:
			return str(thread.get("thread_id", ""))
	return ""

func _dictionary_array(value: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if value is Array:
		for item in value:
			if item is Dictionary:
				result.append(item.duplicate(true))
	return result
