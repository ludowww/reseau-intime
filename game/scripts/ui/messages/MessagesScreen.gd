extends Control

class_name MessagesScreen

const DEMO_DATA := preload("res://scripts/ui/messages/MessagesDemoData.gd")
const CONVERSATION_LIST_SCRIPT := preload("res://scripts/ui/messages/ConversationList.gd")
const CONVERSATION_SCREEN_SCENE := preload("res://scenes/portrait/messages/PortraitConversationScreen.tscn")
const NOTIFICATION_BANNER_SCRIPT := preload("res://scripts/ui/messages/NotificationBanner.gd")

var PORTRAIT_THEME = preload("res://scripts/ui/PortraitShellTheme.gd").new()
var characters: Dictionary = {}
var threads: Array[Dictionary] = []
var transcripts: Dictionary = {}
var available_choices: Dictionary = {}
var reading_positions: Dictionary = {}
var incoming_by_thread: Dictionary = {}
var incoming_sequence_by_thread: Dictionary = {}
var typing_states_by_thread: Dictionary = {}
var conversation_list
var conversation_screen
var notification_banner
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
	_save_reading_position()
	conversation_screen.hide_typing()
	screen_mode = "list"
	conversation_screen.visible = false
	conversation_list.visible = true
	conversation_list.call_deferred("focus_thread", active_thread_id)

func activate_first_choice() -> void:
	if screen_mode == "conversation":
		conversation_screen.activate_first_choice()

func start_typing(thread_id: String, author_id: String) -> void:
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
	if not typing_states_by_thread.has(thread_id):
		return
	typing_states_by_thread.erase(thread_id)
	if screen_mode == "conversation" and active_thread_id == thread_id:
		conversation_screen.hide_typing()

func is_thread_typing(thread_id: String) -> bool:
	var state: Dictionary = typing_states_by_thread.get(thread_id, {})
	return bool(state.get("active", false))

func simulate_incoming_message(thread_id: String) -> void:
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

func describe_state() -> Dictionary:
	var state := {
		"screen": screen_mode,
		"active_thread_id": active_thread_id,
		"thread_count": threads.size(),
		"list_visible": conversation_list != null and conversation_list.visible,
		"list_has_focus": conversation_list != null and conversation_list.first_card_has_focus(),
		"private_thread_id": _first_thread_id(false),
		"group_thread_id": _first_thread_id(true),
		"unread_thread_id": _first_thread_by_unread(true),
		"read_thread_id": _first_thread_by_unread(false),
		"notification_visible": notification_banner != null and notification_banner.visible,
		"notification_thread_id": str(notification_banner.notification.get("thread_id", "")) if notification_banner != null and notification_banner.visible else "",
		"has_horizontal_crop": conversation_list != null and conversation_list.has_horizontal_crop(),
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
	add_child(conversation_screen)
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

func _on_choice_selected(choice: Dictionary) -> void:
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
	else:
		_sync_active_typing()

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
