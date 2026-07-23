extends Control

class_name MessagesScreen

signal photo_requested(presentation: Dictionary, provenance: Dictionary)

const DEMO_DATA := preload("res://scripts/ui/messages/MessagesDemoData.gd")
const CONVERSATION_LIST_SCRIPT := preload("res://scripts/ui/messages/ConversationList.gd")
const CONVERSATION_SCREEN_SCENE := preload("res://scenes/portrait/messages/PortraitConversationScreen.tscn")
const NOTIFICATION_BANNER_SCRIPT := preload("res://scripts/ui/messages/NotificationBanner.gd")
const OFF_PHONE_TRANSITION_SCRIPT := preload("res://scripts/ui/messages/OffPhoneTransition.gd")
const DAY_TRANSITION_SCRIPT := preload("res://scripts/ui/messages/DayTransition.gd")

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

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	_load_demo_data()
	_build()
	visibility_changed.connect(_on_visibility_changed)

func focus_first_conversation() -> void:
	if conversation_list != null and screen_mode == "list":
		conversation_list.focus_first_card()

func open_thread(thread_id: String) -> void:
	if is_off_phone_transition_active() or is_day_transition_active():
		return
	var selected := _thread_for(thread_id)
	if selected.is_empty():
		return
	_save_reading_position()
	var first_unread_message_id := _first_unread_message_id(thread_id)
	_mark_thread_read(thread_id)
	active_thread_id = thread_id
	screen_mode = "conversation"
	conversation_list.visible = false
	conversation_screen.visible = true
	if notification_banner != null and str(notification_banner.notification.get("thread_id", "")) == thread_id:
		_hide_notification()
	var messages := _dictionary_array(transcripts.get(thread_id, []))
	var choices := _dictionary_array(available_choices.get(thread_id, []))
	var position := int(reading_positions.get(thread_id, -1))
	conversation_screen.configure(selected, messages, choices, characters, PORTRAIT_THEME, position, first_unread_message_id)
	_sync_active_typing()

func return_to_list() -> void:
	if is_off_phone_transition_active() or is_day_transition_active():
		return
	_save_reading_position()
	conversation_screen.hide_typing()
	screen_mode = "list"
	conversation_screen.visible = false
	conversation_list.visible = true
	conversation_list.call_deferred("focus_thread", active_thread_id)

func activate_first_choice() -> void:
	if is_off_phone_transition_active() or is_day_transition_active():
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
		conversation_screen.show_typing(author, _reduced_motion_enabled())

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
	screen_mode = "off_phone"
	_set_gallery_navigation_blocked(true)
	off_phone_transition.configure(str(off_phone_state.get("label", "")), PORTRAIT_THEME, _reduced_motion_enabled())

func finish_off_phone_transition() -> void:
	if is_day_transition_active():
		return
	if not is_off_phone_transition_active():
		return
	var saved_state := off_phone_state.duplicate(false)
	var thread_id := str(saved_state.get("thread_id", ""))
	off_phone_transition.dismiss()
	screen_mode = "conversation"
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
	screen_mode = "day_transition"
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
	var saved_state := day_transition_state.duplicate(false)
	var to_day := int(saved_state.get("to_day", current_demo_day_value))
	var previous_thread_id := str(saved_state.get("previous_thread_id", ""))
	day_transition.reset_surface()
	var updated_thread_id := _apply_demo_day_delta(to_day)
	current_demo_day_value = to_day
	if previous_thread_id != "":
		typing_states_by_thread.erase(previous_thread_id)
	_hide_notification()
	screen_mode = "list"
	conversation_screen.visible = false
	conversation_list.visible = true
	conversation_list.configure(threads, characters, PORTRAIT_THEME)
	day_transition_state = {}
	_set_gallery_navigation_blocked(false, bool(saved_state.get("shell_was_processing_unhandled_input", false)))
	var focus_thread_id := updated_thread_id if updated_thread_id != "" else previous_thread_id
	conversation_list.call_deferred("focus_thread", focus_thread_id)

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
		"day_transition_subtitle": day_transition.display_subtitle() if day_transition != null else "",
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
	conversation_list.configure(threads, characters, PORTRAIT_THEME)
	conversation_screen = CONVERSATION_SCREEN_SCENE.instantiate()
	conversation_screen.name = "PortraitConversationScreen"
	conversation_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	conversation_screen.visible = false
	conversation_screen.back_requested.connect(return_to_list)
	conversation_screen.choice_selected.connect(_on_choice_selected)
	conversation_screen.image_requested.connect(_on_image_requested)
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
	if screen_mode != "conversation" or is_off_phone_transition_active() or is_day_transition_active():
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
		"source_kind": "messages",
		"character_id": str(accepted.get("author_id", "")),
		"display_name": str(author.get("display_name", "")),
		"accent_color": Color.from_string(str(author.get("accent_color", "#8D63E6")), PORTRAIT_THEME.MESSAGE_ACCENT),
		"context_label": "Conversation",
		"timestamp": str(accepted.get("timestamp", "")),
		"caption": str(accepted.get("text", "")),
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
	if focus_target is Control and is_instance_valid(focus_target) and focus_target.is_visible_in_tree() and focus_target.focus_mode != Control.FOCUS_NONE and (not focus_target is BaseButton or not focus_target.disabled):
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
	if is_off_phone_transition_active() or is_day_transition_active():
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
	return true

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
	conversation_screen.show_typing(author, _reduced_motion_enabled())

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

func _off_phone_presentation_for(thread_id: String) -> Dictionary:
	for message in _dictionary_array(transcripts.get(thread_id, [])):
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
