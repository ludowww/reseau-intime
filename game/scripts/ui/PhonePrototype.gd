extends Control

const APP_BACKGROUND_COLOR := Color(0.025, 0.028, 0.04)
const PHONE_BACKGROUND_COLOR := Color(0.045, 0.05, 0.075)
const PHONE_FRAME_COLOR := Color(0.015, 0.016, 0.022)
const PHONE_PANEL_COLOR := Color(0.075, 0.082, 0.12)
const CARD_COLOR := Color(0.095, 0.105, 0.15)
const CARD_HOVER_COLOR := Color(0.13, 0.145, 0.20)
const PENDING_CARD_COLOR := Color(0.12, 0.13, 0.19)
const ACCENT_COLOR := Color(0.35, 0.48, 0.70)
const PENDING_COLOR := Color(0.54, 0.72, 0.95)
const MUTED_TEXT_COLOR := Color(0.66, 0.69, 0.76)

var day_list: VBoxContainer
var conversation_list: VBoxContainer
var conversation_cards: VBoxContainer
var conversation_view: VBoxContainer
var debug_panel: VBoxContainer
var debug_scroll: ScrollContainer
var notification_banner: PanelContainer
var notification_label: Label
var current_day_value = null
var pending_conversation_ids: Dictionary = {}
var pending_thread_ids: Dictionary = {}
var unlocked_conversation_ids_by_day: Dictionary = {}
var unlocked_thread_ids_by_day: Dictionary = {}
var initialized_pending_days: Dictionary = {}
var notification_target_conversation_id := ""
var notification_target_day_value = null
var debug_speed_button: Button
var debug_speed_index := 0
var debug_speed_levels := [1.0, 3.0, 8.0]
var debug_speed_labels := ["Speed x1", "Speed x3", "Speed x8"]

func _ready() -> void:
	if DataLoader.chapter_indexes.is_empty():
		DataLoader.load_all()
	GameState.reset_state()
	_build_layout()
	_render_days()

func _build_layout() -> void:
	for child in get_children():
		child.queue_free()

	var background := PanelContainer.new()
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	background.add_theme_stylebox_override("panel", _panel_style(APP_BACKGROUND_COLOR, 0))
	add_child(background)

	var root := HBoxContainer.new()
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 16)
	background.add_child(root)

	_build_phone_shell(root)

	conversation_view = preload("res://scenes/smartphone/ConversationView.tscn").instantiate()
	conversation_view.custom_minimum_size = Vector2(600, 0)
	conversation_view.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	conversation_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
	conversation_view.choice_selected.connect(_on_choice_selected)
	conversation_view.segment_changed.connect(_on_segment_changed)
	conversation_view.conversation_completed.connect(_on_conversation_completed)
	root.add_child(conversation_view)

	debug_scroll = ScrollContainer.new()
	debug_scroll.custom_minimum_size = Vector2(260, 0)
	debug_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	debug_scroll.visible = false
	root.add_child(debug_scroll)
	debug_panel = preload("res://scenes/smartphone/DebugPanel.tscn").instantiate()
	debug_scroll.add_child(debug_panel)

func _build_phone_shell(root: Node) -> void:
	var phone_frame := PanelContainer.new()
	phone_frame.custom_minimum_size = Vector2(420, 680)
	phone_frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	phone_frame.add_theme_stylebox_override("panel", _panel_style(PHONE_FRAME_COLOR, 28))
	root.add_child(phone_frame)

	var phone_body := VBoxContainer.new()
	phone_body.add_theme_constant_override("separation", 12)
	phone_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	phone_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	phone_frame.add_child(phone_body)

	var phone_screen := PanelContainer.new()
	phone_screen.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	phone_screen.size_flags_vertical = Control.SIZE_EXPAND_FILL
	phone_screen.add_theme_stylebox_override("panel", _panel_style(PHONE_BACKGROUND_COLOR, 22))
	phone_body.add_child(phone_screen)

	var screen_column := VBoxContainer.new()
	screen_column.add_theme_constant_override("separation", 10)
	screen_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	screen_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	phone_screen.add_child(screen_column)

	_add_status_bar(screen_column)
	_add_home_navigation(screen_column)
	_add_notification_banner(screen_column)

	day_list = VBoxContainer.new()
	day_list.custom_minimum_size = Vector2(160, 0)
	day_list.add_theme_constant_override("separation", 8)
	day_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	screen_column.add_child(day_list)

	var list_scroll := ScrollContainer.new()
	list_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	screen_column.add_child(list_scroll)

	conversation_list = VBoxContainer.new()
	conversation_list.add_theme_constant_override("separation", 8)
	conversation_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_scroll.add_child(conversation_list)
	conversation_cards = conversation_list

func _add_status_bar(parent: Node) -> void:
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 8)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(bar)
	_add_label(bar, "09:41", 13)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(spacer)
	_add_label(bar, "▮▮  Wi‑Fi  82%", 12)

func _add_home_navigation(parent: Node) -> void:
	var title := Label.new()
	title.text = "Réseau Intime"
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", Color(0.92, 0.93, 0.98))
	parent.add_child(title)

	var nav := HBoxContainer.new()
	nav.add_theme_constant_override("separation", 8)
	nav.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(nav)
	var messages_button := _add_button(nav, "Messages")
	messages_button.pressed.connect(func(): _focus_messages())
	var debug_button := _add_button(nav, "Debug")
	debug_button.pressed.connect(func(): _toggle_debug(debug_button))
	debug_speed_button = _add_button(nav, _debug_speed_label())
	debug_speed_button.pressed.connect(func(): _cycle_debug_speed())
	var reset_button := _add_button(nav, "Reset")
	reset_button.pressed.connect(func(): GameState.reset_state(); conversation_view.reset_ui_state(); pending_conversation_ids.clear(); pending_thread_ids.clear(); unlocked_conversation_ids_by_day.clear(); unlocked_thread_ids_by_day.clear(); initialized_pending_days.clear(); _hide_notification(); _set_debug_speed_index(0); _render_conversations(current_day_value); debug_panel.refresh())

func _add_notification_banner(parent: Node) -> void:
	notification_banner = PanelContainer.new()
	notification_banner.visible = false
	notification_banner.mouse_filter = Control.MOUSE_FILTER_STOP
	notification_banner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	notification_banner.add_theme_stylebox_override("panel", _panel_style(Color(0.10, 0.14, 0.20), 16))
	notification_banner.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_open_notification_target()
	)
	parent.add_child(notification_banner)
	notification_label = Label.new()
	notification_label.text = ""
	notification_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	notification_label.add_theme_font_size_override("font_size", 12)
	notification_label.add_theme_color_override("font_color", Color(0.86, 0.91, 1.0))
	notification_banner.add_child(notification_label)

func _render_days() -> void:
	_clear(day_list)
	_add_label(day_list, "Jours", 15)
	var first_day = null
	for index in DataLoader.chapter_indexes:
		var day_value = index.get("day", index.get("chapter", 0))
		if first_day == null:
			first_day = day_value
		var button := _add_button(day_list, _format_day_label(day_value))
		button.tooltip_text = str(index.get("title", ""))
		button.pressed.connect(func(): _render_conversations(day_value))
	if first_day != null:
		_render_conversations(first_day)

func _focus_messages() -> void:
	if current_day_value != null:
		_render_conversations(current_day_value)

func _render_conversations(day_value) -> void:
	if day_value == null:
		return
	if current_day_value != null and str(current_day_value) != str(day_value):
		pending_conversation_ids.clear()
		pending_thread_ids.clear()
		initialized_pending_days.clear()
		notification_target_conversation_id = ""
		notification_target_day_value = null
		_hide_notification()
	current_day_value = day_value
	_initialize_initial_pending_for_day(day_value)
	_clear(conversation_list)
	_add_label(conversation_list, "%s — Discussions" % _format_day_label(day_value), 18)
	_add_day_moment_hint(day_value)
	_render_conversation_buttons(day_value, _collect_contact_conversations_for_day(day_value))

func _render_conversation_buttons(day_value, conversations: Array) -> void:
	for conversation in conversations:
		_add_conversation_card(day_value, conversation)

func _add_day_moment_hint(day_value) -> void:
	var hints: Array[String] = []
	for item in _moment_metadata_by_conversation_id(day_value).values():
		if typeof(item) != TYPE_DICTIONARY:
			continue
		for label in item.get("labels", []):
			if str(label) != "" and not hints.has(str(label)):
				hints.append(str(label))
		for time in item.get("times", []):
			if str(time) != "" and not hints.has(str(time)):
				hints.append(str(time))
	if hints.is_empty():
		_add_muted_label(conversation_list, "Contacts disponibles", 12)
	else:
		_add_muted_label(conversation_list, "Repères du jour : %s" % " · ".join(hints.slice(0, 4)), 12)

func _collect_contact_conversations_for_day(day_value) -> Array:
	var metadata := _moment_metadata_by_conversation_id(day_value)
	var by_id: Dictionary = {}
	for conversation in DataLoader.get_conversations_for_day(day_value):
		if typeof(conversation) != TYPE_DICTIONARY:
			continue
		if not _is_conversation_available(day_value, conversation):
			continue
		var entry := _filter_conversation_to_available_episodes(day_value, conversation)
		var conversation_id := _conversation_id(entry)
		if metadata.has(conversation_id):
			entry["_moment_metadata"] = metadata[conversation_id]
		by_id[conversation_id] = entry
	for moment in DataLoader.get_moments_for_day(day_value):
		for conversation in DataLoader.get_conversations_for_moment(day_value, moment):
			if typeof(conversation) != TYPE_DICTIONARY:
				continue
			if not _is_conversation_available(day_value, conversation):
				continue
			var entry := _filter_conversation_to_available_episodes(day_value, conversation)
			var conversation_id := _conversation_id(entry)
			if not by_id.has(conversation_id):
				if metadata.has(conversation_id):
					entry["_moment_metadata"] = metadata[conversation_id]
				by_id[conversation_id] = entry
	var contacts: Array = []
	for entry in by_id.values():
		contacts.append(entry)
	return contacts

func _moment_metadata_by_conversation_id(day_value) -> Dictionary:
	var metadata: Dictionary = {}
	for item in DataLoader.get_conversations_for_day(day_value):
		if typeof(item) == TYPE_DICTIONARY:
			var base_id := _conversation_id(item)
			if not metadata.has(base_id):
				metadata[base_id] = {"labels": [], "times": [], "transitions": []}
	for moment in DataLoader.get_moments_for_day(day_value):
		for conversation_id in moment.get("conversation_ids", []):
			var key := _thread_id_for_conversation_id(day_value, str(conversation_id))
			if not metadata.has(key):
				metadata[key] = {"labels": [], "times": [], "transitions": []}
			var bucket: Dictionary = metadata[key]
			_add_unique(bucket["labels"], str(moment.get("moment_label", "")))
			_add_unique(bucket["times"], str(moment.get("time_label", "")))
			_add_unique(bucket["transitions"], str(moment.get("transition_text", "")))
	return metadata

func _add_conversation_card(day_value, conversation: Dictionary) -> void:
	var is_pending := _is_conversation_pending(conversation)
	var card := _make_card(is_pending)
	conversation_cards.add_child(card)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_child(row)

	_add_avatar(row, _avatar_initial(conversation))

	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text_box)
	_add_label(text_box, _conversation_name(conversation), 15)
	_add_muted_label(text_box, _conversation_subtitle(conversation), 12)

	var status_box := VBoxContainer.new()
	status_box.custom_minimum_size = Vector2(72, 0)
	row.add_child(status_box)
	_add_muted_label(status_box, _conversation_status_text(conversation), 11)
	if _conversation_has_activity_badge(conversation):
		var badge := Label.new()
		badge.name = "badge"
		badge.text = "•"
		badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		badge.add_theme_font_size_override("font_size", 24)
		badge.add_theme_color_override("font_color", PENDING_COLOR if is_pending else ACCENT_COLOR)
		status_box.add_child(badge)
		if is_pending:
			_add_muted_label(status_box, "nouveau", 10)

	card.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_open_conversation(day_value, conversation)
	)

func _make_card(pending := false) -> PanelContainer:
	var card := PanelContainer.new()
	card.mouse_filter = Control.MOUSE_FILTER_STOP
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.add_theme_stylebox_override("panel", _card_style(PENDING_CARD_COLOR if pending else CARD_COLOR, pending))
	return card

func _add_avatar(parent: Node, text: String) -> void:
	var avatar := PanelContainer.new()
	avatar.name = "avatar_placeholder"
	avatar.custom_minimum_size = Vector2(44, 44)
	avatar.add_theme_stylebox_override("panel", _panel_style(Color(0.22, 0.20, 0.30), 22))
	parent.add_child(avatar)
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 17)
	avatar.add_child(label)

func _open_conversation(day_value, conversation: Dictionary) -> void:
	var conversation_id := _conversation_id(conversation)
	if not _is_conversation_available(day_value, conversation):
		return
	_clear_pending_for_conversation(conversation_id)
	var segment_id := str(conversation.get("_current_segment_id", conversation.get("id", "")))
	GameState.set_context(day_value, conversation_id, segment_id)
	conversation_view.show_conversation(conversation)
	_render_conversations(day_value)
	debug_panel.refresh()

func _clear_pending_for_conversation(conversation_id: String) -> void:
	if pending_thread_ids.has(conversation_id):
		pending_thread_ids.erase(conversation_id)
	if pending_conversation_ids.has(conversation_id):
		pending_conversation_ids.erase(conversation_id)
	if pending_thread_ids.is_empty():
		_hide_notification()

func _on_conversation_completed(day_value, conversation_id: String) -> void:
	_unlock_conversations_after_completion(day_value, conversation_id)
	debug_panel.refresh()

func _unlock_conversations_after_completion(day_value, completed_conversation_id: String) -> void:
	var availability := _conversation_availability_for_day(day_value)
	var unlocks: Dictionary = availability.get("progression", availability.get("unlocks", {}))
	for target_id in unlocks.keys():
		var rule: Dictionary = unlocks[target_id]
		if str(rule.get("after_conversation_completed", "")) != completed_conversation_id:
			continue
		if _unlock_conversation(day_value, str(target_id)):
			var thread_id := _thread_id_for_conversation_id(day_value, str(target_id))
			pending_thread_ids[thread_id] = true
			pending_conversation_ids[thread_id] = true
			var notification: Dictionary = rule.get("notification", {})
			_show_conversation_notification(day_value, thread_id, str(notification.get("title", target_id)), str(notification.get("body", "Nouveau message de %s" % target_id)))
	if current_day_value != null and str(current_day_value) == str(day_value):
		_render_conversations(day_value)

func _unlock_conversation(day_value, conversation_id: String) -> bool:
	var day_key := str(day_value)
	if not unlocked_conversation_ids_by_day.has(day_key):
		unlocked_conversation_ids_by_day[day_key] = {}
	if not unlocked_thread_ids_by_day.has(day_key):
		unlocked_thread_ids_by_day[day_key] = {}
	var day_unlocks: Dictionary = unlocked_conversation_ids_by_day[day_key]
	if bool(day_unlocks.get(conversation_id, false)):
		return false
	day_unlocks[conversation_id] = true
	unlocked_conversation_ids_by_day[day_key] = day_unlocks
	var thread_unlocks: Dictionary = unlocked_thread_ids_by_day[day_key]
	thread_unlocks[_thread_id_for_conversation_id(day_value, conversation_id)] = true
	unlocked_thread_ids_by_day[day_key] = thread_unlocks
	return true

func _available_conversation_ids_for_day(day_value) -> Array:
	var availability := _conversation_availability_for_day(day_value)
	var initial_ids: Array = availability.get("initial_conversation_ids", [])
	var ids: Array = []
	for conversation_id in initial_ids:
		_add_unique(ids, str(conversation_id))
	var day_unlocks: Dictionary = unlocked_conversation_ids_by_day.get(str(day_value), {})
	for conversation_id in day_unlocks.keys():
		if bool(day_unlocks[conversation_id]):
			_add_unique(ids, str(conversation_id))
	return ids

func _initialize_initial_pending_for_day(day_value) -> void:
	var day_key := str(day_value)
	if bool(initialized_pending_days.get(day_key, false)):
		return
	initialized_pending_days[day_key] = true
	for conversation_id in _conversation_availability_for_day(day_value).get("initial_conversation_ids", []):
		var thread_id := _thread_id_for_conversation_id(day_value, str(conversation_id))
		pending_thread_ids[thread_id] = true
		pending_conversation_ids[thread_id] = true

func _is_conversation_available(day_value, conversation: Dictionary) -> bool:
	var availability := _conversation_availability_for_day(day_value)
	if availability.is_empty():
		return true
	for episode_id in _conversation_episode_ids(conversation):
		if _is_episode_available(day_value, episode_id):
			return true
	return false

func _conversation_availability_for_day(day_value) -> Dictionary:
	return DataLoader.get_index_for_day(day_value).get("conversation_availability", {})

func _conversation_episode_ids(conversation: Dictionary) -> Array:
	var ids: Array = []
	for episode_id in conversation.get("_episode_ids", []):
		_add_unique(ids, str(episode_id))
	if ids.is_empty():
		_add_unique(ids, str(conversation.get("id", conversation.get("_parent_conversation_id", ""))))
	return ids

func _is_episode_available(day_value, episode_id: String) -> bool:
	return _available_conversation_ids_for_day(day_value).has(episode_id)

func _first_available_episode_id(day_value, conversation: Dictionary) -> String:
	for episode_id in _conversation_episode_ids(conversation):
		if _is_episode_available(day_value, episode_id):
			return episode_id
	return ""

func _filter_conversation_to_available_episodes(day_value, conversation: Dictionary) -> Dictionary:
	var entry: Dictionary = conversation.duplicate(true)
	var available_episode_ids: Array = []
	for episode_id in _conversation_episode_ids(conversation):
		if _is_episode_available(day_value, episode_id):
			available_episode_ids.append(episode_id)
	if available_episode_ids.is_empty():
		return entry
	var filtered_segments: Array = []
	for segment in entry.get("segments", []):
		if typeof(segment) != TYPE_DICTIONARY:
			continue
		if available_episode_ids.has(str(segment.get("_source_conversation_id", ""))):
			filtered_segments.append(segment)
	entry["segments"] = filtered_segments
	entry["_episode_ids"] = available_episode_ids
	entry["_segment_count"] = filtered_segments.size()
	entry["_current_segment_index"] = 0
	if not filtered_segments.is_empty():
		entry["_current_segment_id"] = "%s__segment_1" % str(filtered_segments[0].get("_source_conversation_id", _conversation_id(entry)))
	return entry

func _thread_id_for_conversation_id(day_value, conversation_id: String) -> String:
	for conversation in DataLoader.get_conversations_for_day(day_value):
		if typeof(conversation) != TYPE_DICTIONARY:
			continue
		if _conversation_episode_ids(conversation).has(conversation_id):
			return _conversation_id(conversation)
	return conversation_id

func _show_conversation_notification(day_value, conversation_id: String, title: String, body: String) -> void:
	notification_target_day_value = day_value
	notification_target_conversation_id = conversation_id
	_show_notification("%s — %s" % [title, body])
	var expected_target := notification_target_conversation_id
	await get_tree().create_timer(4.0).timeout
	if notification_target_conversation_id == expected_target:
		_hide_notification()

func _open_notification_target() -> void:
	if notification_target_conversation_id == "" or notification_target_day_value == null:
		return
	for conversation in _collect_contact_conversations_for_day(notification_target_day_value):
		if _conversation_id(conversation) == notification_target_conversation_id:
			_open_conversation(notification_target_day_value, conversation)
			_hide_notification()
			return

func _show_notification(text: String) -> void:
	if notification_banner == null or notification_label == null:
		return
	notification_label.text = text
	notification_banner.visible = true

func _hide_notification() -> void:
	if notification_banner == null:
		return
	notification_banner.visible = false
	notification_target_conversation_id = ""
	notification_target_day_value = null
	if notification_label != null:
		notification_label.text = ""

func _on_segment_changed(day_value, conversation_id: String, segment_id: String) -> void:
	GameState.set_context(day_value, conversation_id, segment_id)
	debug_panel.refresh()

func _on_choice_selected(choice: Dictionary) -> void:
	EffectApplier.apply_choice(choice)
	conversation_view.append_choice_result(choice)
	debug_panel.refresh()

func _toggle_debug(button: Button) -> void:
	debug_scroll.visible = not debug_scroll.visible
	button.text = "Debug ✓" if debug_scroll.visible else "Debug"
	if debug_scroll.visible:
		debug_panel.refresh()

func _debug_speed_label() -> String:
	return debug_speed_labels[debug_speed_index]

func _cycle_debug_speed() -> void:
	_set_debug_speed_index((debug_speed_index + 1) % debug_speed_levels.size())

func _set_debug_speed_index(index: int) -> void:
	debug_speed_index = clamp(index, 0, debug_speed_levels.size() - 1)
	if is_instance_valid(debug_speed_button):
		debug_speed_button.text = _debug_speed_label()
	if is_instance_valid(conversation_view):
		conversation_view.set_debug_speed_multiplier(debug_speed_levels[debug_speed_index])

func _format_day_label(day_value) -> String:
	return "Jour %d" % int(day_value)

func _conversation_id(conversation: Dictionary) -> String:
	return str(conversation.get("_parent_conversation_id", conversation.get("id", "")))

func _conversation_name(conversation: Dictionary) -> String:
	var thread = conversation.get("thread", {})
	if typeof(thread) == TYPE_DICTIONARY and str(thread.get("display_name", "")) != "":
		return str(thread.get("display_name"))
	return str(conversation.get("title", conversation.get("id", "Conversation")))

func _conversation_subtitle(conversation: Dictionary) -> String:
	var last_text := _last_message_text(conversation)
	if last_text != "":
		return last_text
	var metadata = conversation.get("_moment_metadata", {})
	if typeof(metadata) == TYPE_DICTIONARY and not metadata.get("transitions", []).is_empty():
		return str(metadata.get("transitions", [])[0])
	if str(conversation.get("description", "")) != "":
		return str(conversation.get("description"))
	return "Conversation disponible"

func _conversation_status_text(conversation: Dictionary) -> String:
	if _is_conversation_pending(conversation):
		return "En attente"
	var metadata = conversation.get("_moment_metadata", {})
	if typeof(metadata) == TYPE_DICTIONARY:
		var times: Array = metadata.get("times", [])
		if not times.is_empty():
			return str(times.back())
		var labels: Array = metadata.get("labels", [])
		if not labels.is_empty():
			return str(labels.back())
	if str(conversation.get("time_label", "")) != "":
		return str(conversation.get("time_label"))
	if str(conversation.get("moment_label", "")) != "":
		return str(conversation.get("moment_label"))
	return "actif"

func _conversation_has_activity_badge(conversation: Dictionary) -> bool:
	if _is_conversation_pending(conversation):
		return true
	if bool(conversation.get("unread", false)) or bool(conversation.get("active", false)):
		return true
	return not _collect_choices(conversation).is_empty()

func _is_conversation_pending(conversation: Dictionary) -> bool:
	return bool(pending_thread_ids.get(_conversation_id(conversation), false))

func _last_message_text(conversation: Dictionary) -> String:
	var messages := _collect_messages(conversation)
	if messages.is_empty():
		return ""
	var message: Dictionary = messages.back()
	var sender := str(message.get("sender", message.get("author", "")))
	var body := str(message.get("text", message.get("body", message.get("reaction", ""))))
	if body.length() > 58:
		body = body.substr(0, 55) + "..."
	if sender != "":
		return "%s : %s" % [sender.capitalize(), body]
	return body

func _collect_messages(conversation: Dictionary) -> Array:
	var messages: Array = []
	for key in ["messages", "beats", "segments", "social_items", "incoming_notifications", "conditional_aftershocks", "conditional_proofs", "conditional_closers"]:
		for entry in conversation.get(key, []):
			if typeof(entry) == TYPE_DICTIONARY:
				if entry.has("messages"):
					for message in entry.get("messages", []):
						if typeof(message) == TYPE_DICTIONARY:
							messages.append(message)
				elif entry.has("text") or entry.has("body") or entry.has("reaction"):
					messages.append(entry)
	for key in ["default_aftershock", "default_proof", "default_closer"]:
		var entry = conversation.get(key, null)
		if typeof(entry) == TYPE_DICTIONARY:
			if entry.has("messages"):
				for message in entry.get("messages", []):
					if typeof(message) == TYPE_DICTIONARY:
						messages.append(message)
			elif entry.has("text") or entry.has("body") or entry.has("reaction"):
				messages.append(entry)
	return messages

func _collect_choices(conversation: Dictionary) -> Array:
	var choices: Array = []
	for key in ["choices", "priority_choices"]:
		choices.append_array(conversation.get(key, []))
	for container_key in ["beats", "segments"]:
		for entry in conversation.get(container_key, []):
			if typeof(entry) == TYPE_DICTIONARY:
				choices.append_array(entry.get("choices", []))
				choices.append_array(entry.get("priority_choices", []))
	return choices

func _avatar_initial(conversation: Dictionary) -> String:
	var name := _conversation_name(conversation)
	if name == "":
		return "?"
	return name.substr(0, 1).to_upper()

func _add_unique(items: Array, value: String) -> void:
	if value == "":
		return
	if not items.has(value):
		items.append(value)

func _add_label(parent: Node, text: String, size: int = 14) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color(0.90, 0.91, 0.96))
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(label)
	return label

func _add_muted_label(parent: Node, text: String, size: int = 12) -> Label:
	var label := _add_label(parent, text, size)
	label.add_theme_color_override("font_color", MUTED_TEXT_COLOR)
	return label

func _add_button(parent: Node, text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.custom_minimum_size = Vector2(0, 42)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_stylebox_override("normal", _panel_style(PHONE_PANEL_COLOR, 16))
	button.add_theme_stylebox_override("hover", _panel_style(CARD_HOVER_COLOR, 16))
	button.add_theme_stylebox_override("pressed", _panel_style(ACCENT_COLOR, 16))
	parent.add_child(button)
	return button

func _card_style(color: Color, pending := false) -> StyleBoxFlat:
	var style := _panel_style(color, 18)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = PENDING_COLOR if pending else Color(0.18, 0.20, 0.28)
	return style

func _panel_style(color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style

func _clear(parent: Node) -> void:
	for child in parent.get_children():
		child.queue_free()
