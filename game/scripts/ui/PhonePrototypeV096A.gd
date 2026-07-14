extends "res://scripts/ui/PhonePrototypeV096.gd"

const MODE_CONTACTS := "CONTACTS"
const MODE_HISTORY := "HISTORY"
const _V096A_RUNTIME_REFERENCES := "PhotoGalleryView.tscn | VisualDayContract.evaluate"

var phone_mode := MODE_CONTACTS
var history_day_value = null
var landing_panel: PanelContainer
var history_button: Button

func _ensure_named_boundaries_ledger() -> Dictionary:
	return super._ensure_named_boundaries_ledger()

func _record_named_boundaries_visual_route(conversation_id: String) -> void:
	super._record_named_boundaries_visual_route(conversation_id)

func _apply_named_boundaries_social_set_outcome() -> void:
	super._apply_named_boundaries_social_set_outcome()

func _activate_candidate_phase(day_value, phase: Dictionary, show_transition: bool) -> void:
	await super._activate_candidate_phase(day_value, phase, show_transition)

func _activate_authored_beat_silently(day_value, phase: Dictionary) -> void:
	await super._activate_authored_beat_silently(day_value, phase)

func _build_layout() -> void:
	super._build_layout()
	_ensure_v096a_layout()

func _ensure_v096a_layout() -> void:
	if is_instance_valid(day_list):
		day_list.visible = false
		day_list.custom_minimum_size = Vector2.ZERO
	var root := conversation_view.get_parent() if is_instance_valid(conversation_view) else null
	if root == null:
		return
	if not is_instance_valid(landing_panel):
		landing_panel = PanelContainer.new()
		landing_panel.name = "MessagesLandingPanel"
		landing_panel.custom_minimum_size = Vector2(600, 0)
		landing_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		landing_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
		landing_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.055, 0.06, 0.09), 18))
		var landing_column := VBoxContainer.new()
		landing_column.add_theme_constant_override("separation", 8)
		landing_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		landing_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
		landing_panel.add_child(landing_column)
		var title := Label.new()
		title.text = "Messages"
		title.add_theme_font_size_override("font_size", 24)
		title.add_theme_color_override("font_color", Color(0.94, 0.96, 1.0))
		landing_column.add_child(title)
		var subtitle := Label.new()
		subtitle.text = "Choisis un contact ou ouvre l’historique."
		subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		subtitle.add_theme_font_size_override("font_size", 13)
		subtitle.add_theme_color_override("font_color", Color(0.74, 0.78, 0.86))
		landing_column.add_child(subtitle)
		root.add_child(landing_panel)
		if is_instance_valid(debug_scroll):
			root.move_child(landing_panel, debug_scroll.get_index())
	if is_instance_valid(conversation_view) and conversation_view.has_signal("contacts_requested"):
		var back_callback := Callable(self, "_show_contacts")
		if not conversation_view.is_connected("contacts_requested", back_callback):
			conversation_view.connect("contacts_requested", back_callback)
	if is_instance_valid(conversation_view) and conversation_view.has_signal("thread_notification_pressed"):
		var thread_callback := Callable(self, "_open_notification_target")
		if not conversation_view.is_connected("thread_notification_pressed", thread_callback):
			conversation_view.connect("thread_notification_pressed", thread_callback)
	_show_contacts()

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
	messages_button.pressed.connect(func(): _show_contacts())
	history_button = _add_button(primary_nav, "Historique")
	history_button.pressed.connect(func(): _show_history())
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
	reset_button.pressed.connect(func():
		GameState.reset_state()
		conversation_view.reset_ui_state()
		pending_conversation_ids.clear()
		pending_thread_ids.clear()
		unlocked_conversation_ids_by_day.clear()
		unlocked_thread_ids_by_day.clear()
		initialized_pending_days.clear()
		history_day_value = null
		phone_mode = MODE_CONTACTS
		_hide_notification()
		_set_debug_speed_index(0)
		_show_contacts()
		debug_panel.refresh()
	)

func _focus_messages() -> void:
	_show_contacts()

func _show_contacts() -> void:
	phone_mode = MODE_CONTACTS
	history_day_value = null
	_set_thread_view_visible(false)
	if is_instance_valid(photo_gallery_view):
		photo_gallery_view.visible = false
	_render_conversations(current_day_value)
	if is_instance_valid(landing_panel):
		landing_panel.visible = true

func _show_history() -> void:
	phone_mode = MODE_HISTORY
	history_day_value = null
	_set_thread_view_visible(false)
	if is_instance_valid(photo_gallery_view):
		photo_gallery_view.visible = false
	_render_conversations(current_day_value)
	if is_instance_valid(landing_panel):
		landing_panel.visible = true

func _show_history_day(day_value) -> void:
	phone_mode = MODE_HISTORY
	history_day_value = day_value
	_set_thread_view_visible(false)
	if is_instance_valid(photo_gallery_view):
		photo_gallery_view.visible = false
	_render_conversations(current_day_value)
	if is_instance_valid(landing_panel):
		landing_panel.visible = true

func _show_gallery(content_id: String = "") -> void:
	if is_instance_valid(landing_panel):
		landing_panel.visible = false
	super._show_gallery(content_id)

func _set_thread_view_visible(visible: bool) -> void:
	if is_instance_valid(conversation_view):
		conversation_view.visible = visible
		if not visible and conversation_view.has_method("hide_thread_notification"):
			conversation_view.call("hide_thread_notification")
	if is_instance_valid(landing_panel):
		landing_panel.visible = not visible

func _render_conversations(day_value) -> void:
	if day_value == null:
		return
	current_day_value = day_value
	_initialize_initial_pending_for_day(day_value)
	_clear(conversation_list)
	if phone_mode == MODE_HISTORY:
		_render_history_navigation()
		if history_day_value == null:
			_render_history_day_buttons()
		else:
			_render_history_day(history_day_value)
		return
	_render_contacts_view(day_value)

func _render_contacts_view(day_value) -> void:
	_add_label(conversation_list, "Contacts", 18)
	_add_muted_label(conversation_list, "Une ligne = un fil. Les fils récents et en attente passent en premier.", 12)
	var conversations := _collect_global_threads()
	if conversations.is_empty():
		_add_muted_label(conversation_list, "Aucun contact disponible.", 12)
		return
	for conversation in conversations:
		var source_day_value = int(conversation.get("_source_day_value", day_value))
		_add_conversation_card(source_day_value, conversation)

func _render_history_navigation() -> void:
	var back_button := _add_button(conversation_list, "← Contacts")
	back_button.pressed.connect(func(): _show_contacts())
	_add_label(conversation_list, "Historique", 18)
	_add_muted_label(conversation_list, "Journées terminées ou déverrouillées.", 12)

func _render_history_day_buttons() -> void:
	for day_value in _history_day_values():
		var index := DataLoader.get_index_for_day(day_value)
		var button := _add_button(conversation_list, _history_day_label(day_value))
		button.tooltip_text = str(index.get("title", ""))
		var selected_day = day_value
		button.pressed.connect(func(): _show_history_day(selected_day))

func _render_history_day(day_value) -> void:
	_add_label(conversation_list, _history_day_label(day_value), 18)
	_add_muted_label(conversation_list, "Lecture seule.", 12)
	for conversation in _collect_day_threads(day_value):
		var card := PanelContainer.new()
		card.mouse_filter = Control.MOUSE_FILTER_STOP
		card.focus_mode = Control.FOCUS_ALL
		card.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		card.add_theme_stylebox_override("panel", _panel_style(Color(0.10, 0.11, 0.16), 14))
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		conversation_list.add_child(card)
		var column := VBoxContainer.new()
		column.add_theme_constant_override("separation", 4)
		card.add_child(column)
		_add_label(column, _conversation_name(conversation), 16)
		_add_muted_label(column, _conversation_subtitle(conversation), 12)
		_add_muted_label(column, _conversation_status_text(conversation), 11)
		var selected_day = day_value
		var selected_conversation: Dictionary = conversation.duplicate(true)
		card.gui_input.connect(func(event):
			var activated := false
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				activated = true
			elif event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_ENTER, KEY_KP_ENTER, KEY_SPACE]:
				activated = true
			if activated:
				_open_history_conversation(selected_day, selected_conversation)
		)

func _open_history_conversation(day_value, conversation: Dictionary) -> void:
	phone_mode = MODE_HISTORY
	history_day_value = day_value
	if is_instance_valid(photo_gallery_view):
		photo_gallery_view.visible = false
	_set_thread_view_visible(true)
	if is_instance_valid(conversation_view):
		if conversation_view.has_method("show_archive_conversation"):
			conversation_view.call("show_archive_conversation", conversation)
		else:
			conversation_view.show_conversation(conversation)
		conversation_view.active_conversation_id = "archive::%s::%s" % [str(day_value), _conversation_id(conversation)]
	if is_instance_valid(landing_panel):
		landing_panel.visible = false
	_sync_conversation_phone_status()

func _collect_global_threads() -> Array:
	var by_thread: Dictionary = {}
	for day_value in _history_day_values():
		for conversation in _collect_contact_conversations_for_day(day_value):
			if typeof(conversation) != TYPE_DICTIONARY:
				continue
			var entry := _annotate_source_day(day_value, conversation)
			var thread_id := _conversation_id(entry)
			var score := _conversation_recency_score(entry)
			if not by_thread.has(thread_id) or score > int(by_thread[thread_id].get("_sort_score", -1)):
				entry["_sort_score"] = score
				by_thread[thread_id] = entry
	var entries: Array = by_thread.values()
	entries.sort_custom(func(a, b):
		var a_pending := _is_conversation_pending(a)
		var b_pending := _is_conversation_pending(b)
		if a_pending != b_pending:
			return a_pending and not b_pending
		var a_score := int(a.get("_sort_score", 0))
		var b_score := int(b.get("_sort_score", 0))
		return a_score > b_score
	)
	return entries

func _collect_day_threads(day_value) -> Array:
	var by_thread: Dictionary = {}
	for conversation in DataLoader.get_conversations_for_day(day_value):
		if typeof(conversation) != TYPE_DICTIONARY:
			continue
		var filtered := _filter_history_conversation_to_unlocked_episodes(day_value, conversation)
		if filtered.is_empty():
			continue
		var entry := _annotate_source_day(day_value, filtered)
		var thread_id := _conversation_id(entry)
		if not by_thread.has(thread_id):
			by_thread[thread_id] = entry
	return by_thread.values()

func _filter_history_conversation_to_unlocked_episodes(day_value, conversation: Dictionary) -> Dictionary:
	var unlocked_episode_ids: Array = []
	for raw_episode_id in _conversation_episode_ids(conversation):
		var episode_id := str(raw_episode_id)
		if _is_episode_available_without_phase_gate(day_value, episode_id):
			unlocked_episode_ids.append(episode_id)
	if unlocked_episode_ids.is_empty():
		return {}
	var entry: Dictionary = conversation.duplicate(true)
	var filtered_segments: Array = []
	for raw_segment in entry.get("segments", []):
		if typeof(raw_segment) != TYPE_DICTIONARY:
			continue
		var segment: Dictionary = raw_segment
		var source_id := str(segment.get("_source_conversation_id", ""))
		if source_id == "" or unlocked_episode_ids.has(source_id):
			filtered_segments.append(segment)
	entry["segments"] = filtered_segments
	entry["_episode_ids"] = unlocked_episode_ids
	entry["_segment_count"] = filtered_segments.size()
	entry["_current_segment_index"] = 0
	if not filtered_segments.is_empty():
		entry["_current_segment_id"] = "%s__segment_1" % str(filtered_segments[0].get("_source_conversation_id", _conversation_id(entry)))
	return entry

func _annotate_source_day(day_value, conversation: Dictionary) -> Dictionary:
	var entry: Dictionary = conversation.duplicate(true)
	entry["_source_day_value"] = day_value
	if not entry.has("day"):
		entry["day"] = day_value
	if not entry.has("chapter"):
		entry["chapter"] = day_value
	return entry

func _conversation_recency_score(conversation: Dictionary) -> int:
	var day_score := int(conversation.get("_source_day_value", 0)) * 1000
	var time_score := _time_score(str(conversation.get("time_label", conversation.get("moment_label", ""))))
	return day_score + time_score

func _time_score(value: String) -> int:
	var parts := value.split(":")
	if parts.size() != 2:
		return 0
	if not parts[0].is_valid_int() or not parts[1].is_valid_int():
		return 0
	return int(parts[0]) * 60 + int(parts[1])

func _history_day_values() -> Array:
	var days: Array = []
	for index in DataLoader.chapter_indexes:
		var day_value = index.get("day", index.get("chapter", 0))
		if TimelineState.is_day_unlocked(day_value) or TimelineState.is_day_completed(day_value):
			days.append(day_value)
	days.sort()
	return days

func _history_day_label(day_value) -> String:
	var index := DataLoader.get_index_for_day(day_value)
	var title := str(index.get("display_label", index.get("title", _format_day_label(day_value))))
	return title

func _hide_notification() -> void:
	super._hide_notification()
	if is_instance_valid(conversation_view) and conversation_view.has_method("hide_thread_notification"):
		conversation_view.call("hide_thread_notification")

func _show_conversation_notification(day_value, conversation_id: String, title: String, body: String) -> void:
	notification_target_day_value = day_value
	var thread_id := conversation_id
	if has_method("_thread_id_for_conversation_id"):
		var resolved_thread_id := str(_thread_id_for_conversation_id(day_value, conversation_id))
		if resolved_thread_id != "":
			thread_id = resolved_thread_id
	notification_target_conversation_id = thread_id
	pending_thread_ids[thread_id] = true
	pending_conversation_ids[thread_id] = true
	if (
		is_instance_valid(conversation_view)
		and conversation_view.visible
		and not conversation_view.current_conversation.is_empty()
		and conversation_view.has_method("show_thread_notification")
	):
		conversation_view.call(
			"show_thread_notification",
			title,
			body,
			_notification_time_for_thread(day_value, thread_id)
		)
		return
	_show_notification("%s — %s" % [title, _compact_notification_preview(body)])

func _open_notification_target() -> void:
	if notification_target_conversation_id == "" or notification_target_day_value == null:
		return
	var target_id := notification_target_conversation_id
	var updated_conversation := _conversation_for_thread(notification_target_day_value, target_id)
	if updated_conversation.is_empty():
		pending_thread_ids.erase(target_id)
		pending_conversation_ids.erase(target_id)
		_hide_notification()
		return
	var same_thread := (
		is_instance_valid(conversation_view)
		and conversation_view.has_method("current_thread_id")
		and str(conversation_view.call("current_thread_id")) == target_id
	)
	if same_thread:
		phone_mode = MODE_CONTACTS
		history_day_value = null
		_set_thread_view_visible(true)
		if conversation_view.has_method("continue_active_thread"):
			conversation_view.call("continue_active_thread", updated_conversation)
	else:
		_open_conversation(notification_target_day_value, updated_conversation)
	_clear_pending_for_conversation(target_id)
	pending_thread_ids.erase(target_id)
	pending_conversation_ids.erase(target_id)
	_hide_notification()
	_render_conversations(current_day_value)
	if is_instance_valid(debug_panel):
		debug_panel.refresh()

func _conversation_for_thread(day_value, thread_id: String) -> Dictionary:
	for conversation in _collect_day_threads(day_value):
		if _conversation_id(conversation) == thread_id:
			return conversation
	return {}

func _clear_pending_for_conversation(conversation_id: String) -> void:
	super._clear_pending_for_conversation(conversation_id)
	if pending_thread_ids.is_empty() and pending_conversation_ids.is_empty():
		if is_instance_valid(conversation_view) and conversation_view.has_method("hide_thread_notification"):
			conversation_view.call("hide_thread_notification")

func _open_conversation(day_value, conversation: Dictionary) -> void:
	phone_mode = MODE_CONTACTS
	history_day_value = null
	_set_thread_view_visible(true)
	super._open_conversation(day_value, conversation)
	if is_instance_valid(landing_panel):
		landing_panel.visible = false

func _add_conversation_card(day_value, conversation: Dictionary) -> void:
	if phone_mode == MODE_HISTORY:
		return
	super._add_conversation_card(day_value, conversation)
