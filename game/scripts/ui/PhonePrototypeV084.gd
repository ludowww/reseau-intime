extends "res://scripts/ui/PhonePrototypeV082.gd"

# V0.84 makes time an explicit access state without replacing the existing
# thread, choice, notification, or conditional-unlock engines.
var timeline_transition_view: Control
var viewing_archived_day := false
var transition_in_progress := false

func _build_layout() -> void:
	super._build_layout()
	timeline_transition_view = preload("res://scenes/smartphone/TimelineTransitionView.tscn").instantiate()
	timeline_transition_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(timeline_transition_view)
	timeline_transition_view.move_to_front()

func _render_days() -> void:
	TimelineState.ensure_initialized()
	_clear(day_list)
	_add_label(day_list, "Jours", 15)
	for index in DataLoader.chapter_indexes:
		var day_value = index.get("day", index.get("chapter", 0))
		if not TimelineState.is_day_unlocked(day_value) and not TimelineState.is_day_completed(day_value):
			continue
		var label := _format_day_label(day_value)
		if TimelineState.is_day_completed(day_value):
			label += " · Terminé" if TimelineState.is_current_day(day_value) else " · Historique"
		var button := _add_button(day_list, label)
		button.tooltip_text = str(index.get("title", ""))
		button.disabled = transition_in_progress
		var target_day = day_value
		button.pressed.connect(func(): _on_day_button_pressed(target_day))
	var active_day = _timeline_current_day_value()
	if active_day != null:
		if TimelineState.is_day_completed(active_day):
			_render_archived_day(active_day)
		else:
			_render_active_day(active_day)

func _render_conversations(day_value) -> void:
	if day_value == null or not TimelineState.is_day_unlocked(day_value):
		return
	if TimelineState.is_day_completed(day_value):
		_render_archived_day(day_value)
	elif TimelineState.is_current_day(day_value):
		_render_active_day(day_value)

func _render_active_day(day_value) -> void:
	viewing_archived_day = false
	super._render_conversations(day_value)
	_add_phase_advance_control(day_value)

func _render_archived_day(day_value) -> void:
	viewing_archived_day = true
	_clear(conversation_list)
	_add_label(conversation_list, "%s — Historique" % _format_day_label(day_value), 18)
	_add_muted_label(conversation_list, "Journée terminée · lecture seule", 12)
	_render_conversation_buttons(day_value, _collect_contact_conversations_for_day(day_value))
	if TimelineState.is_current_day(day_value) and DataLoader.get_timeline_next_day(day_value) == null:
		_add_muted_label(conversation_list, "La suite n'est pas encore disponible.", 12)

func _on_day_button_pressed(day_value) -> void:
	if transition_in_progress:
		return
	if TimelineState.is_day_completed(day_value):
		_render_archived_day(day_value)
	elif TimelineState.is_current_day(day_value):
		_render_active_day(day_value)

func _open_conversation(day_value, conversation: Dictionary) -> void:
	if TimelineState.is_day_completed(day_value):
		conversation_view.show_conversation(conversation)
		return
	var phase := DataLoader.get_timeline_phase(day_value, TimelineState.current_phase_id(day_value))
	for optional_id in phase.get("optional_conversation_ids", []):
		if _conversation_episode_ids(conversation).has(str(optional_id)):
			TimelineState.mark_optional_opened(day_value, str(optional_id))
			break
	super._open_conversation(day_value, conversation)

func _is_conversation_pending(conversation: Dictionary) -> bool:
	if viewing_archived_day:
		return false
	return super._is_conversation_pending(conversation)

func _conversation_has_activity_badge(conversation: Dictionary) -> bool:
	if viewing_archived_day:
		return false
	return super._conversation_has_activity_badge(conversation)

func _is_episode_available(day_value, episode_id: String) -> bool:
	if not TimelineState.is_day_unlocked(day_value):
		return false
	if TimelineState.is_conversation_expired(day_value, episode_id):
		return false
	if not super._is_episode_available(day_value, episode_id):
		return false
	var phase := DataLoader.get_timeline_phase_for_conversation(day_value, episode_id)
	if phase.is_empty() or TimelineState.is_day_completed(day_value):
		return true
	var phase_id := str(phase.get("id", ""))
	return (
		phase_id == TimelineState.current_phase_id(day_value)
		or TimelineState.is_phase_complete(day_value, phase_id)
		or TimelineState.is_phase_skipped(day_value, phase_id)
	)

func _on_conversation_completed(day_value, conversation_id: String) -> void:
	TimelineState.record_episode_completed(day_value, conversation_id)
	var phase := DataLoader.get_timeline_phase_for_conversation(day_value, conversation_id)
	if phase.is_empty():
		super._on_conversation_completed(day_value, conversation_id)
		return
	var phase_id := str(phase.get("id", ""))
	if phase_id != TimelineState.current_phase_id(day_value):
		debug_panel.refresh()
		return
	if _phase_is_optional(phase):
		_render_active_day(day_value)
		debug_panel.refresh()
		return
	if _phase_requirements_are_met(day_value, phase):
		TimelineState.complete_phase(day_value, phase_id)
		await _advance_after_phase(day_value, phase_id)
	debug_panel.refresh()

func _advance_after_phase(day_value, phase_id: String) -> void:
	if transition_in_progress:
		return
	var phases := DataLoader.get_timeline_phases(day_value)
	var current_index := -1
	for index in range(phases.size()):
		if typeof(phases[index]) == TYPE_DICTIONARY and str(phases[index].get("id", "")) == phase_id:
			current_index = index
			break
	if current_index >= 0 and current_index + 1 < phases.size():
		await _activate_phase(day_value, phases[current_index + 1], true)
	else:
		await _complete_day(day_value)

func _activate_phase(day_value, phase: Dictionary, show_transition: bool) -> void:
	if phase.is_empty():
		return
	transition_in_progress = true
	_hide_notification()
	var phase_id := str(phase.get("id", ""))
	TimelineState.set_current_phase(day_value, phase_id)
	if show_transition:
		var card := _transition_card_for_phase(day_value, phase)
		if not card.is_empty():
			await timeline_transition_view.show_moment_transition(card)
	var notifications := _unlock_phase_conversations(day_value, phase)
	transition_in_progress = false
	_render_active_day(day_value)
	_render_days_buttons_only()
	for notification in notifications:
		_show_conversation_notification(
			day_value,
			str(notification.get("thread_id", "")),
			str(notification.get("title", "")),
			str(notification.get("body", ""))
		)

func _unlock_phase_conversations(day_value, phase: Dictionary) -> Array:
	var notifications: Array = []
	var initial_ids: Array = _conversation_availability_for_day(day_value).get("initial_conversation_ids", [])
	for target_id in _phase_conversation_ids(phase):
		if TimelineState.is_conversation_expired(day_value, target_id):
			continue
		if not _unlock_rule_ready(day_value, target_id, initial_ids):
			continue
		var rule := _unlock_rule_for_target(day_value, target_id)
		var newly_unlocked := initial_ids.has(target_id)
		if not newly_unlocked:
			newly_unlocked = _unlock_conversation(day_value, target_id)
		if not newly_unlocked and not _is_episode_available_without_phase_gate(day_value, target_id):
			continue
		if bool(rule.get("pending", true)):
			var thread_id := _thread_id_for_conversation_id(day_value, target_id)
			pending_thread_ids[thread_id] = true
			pending_conversation_ids[thread_id] = true
		if bool(rule.get("notify", true)) and not rule.is_empty():
			var notification: Dictionary = rule.get("notification", {})
			notifications.append({
				"thread_id": _thread_id_for_conversation_id(day_value, target_id),
				"title": str(notification.get("title", target_id)),
				"body": str(notification.get("body", "Nouveau message de %s" % target_id)),
			})
	return notifications

func _unlock_rule_ready(day_value, target_id: String, initial_ids: Array) -> bool:
	if initial_ids.has(target_id):
		return true
	var rule := _unlock_rule_for_target(day_value, target_id)
	if rule.is_empty() or not _conditions_are_met(rule.get("conditions", [])):
		return false
	var expected := str(rule.get("after_conversation_completed", ""))
	if expected != "" and not TimelineState.is_episode_completed(day_value, expected):
		return false
	var candidates: Array = rule.get("after_any_conversation_completed", [])
	if not candidates.is_empty():
		var any_complete := false
		for candidate in candidates:
			if TimelineState.is_episode_completed(day_value, str(candidate)):
				any_complete = true
				break
		if not any_complete:
			return false
	return true

func _unlock_rule_for_target(day_value, target_id: String) -> Dictionary:
	var availability := _conversation_availability_for_day(day_value)
	var unlocks: Dictionary = availability.get("progression", availability.get("unlocks", {}))
	var raw_rule = unlocks.get(target_id, {})
	return raw_rule if typeof(raw_rule) == TYPE_DICTIONARY else {}

func _is_episode_available_without_phase_gate(day_value, episode_id: String) -> bool:
	return super._is_episode_available(day_value, episode_id)

func _phase_requirements_are_met(day_value, phase: Dictionary) -> bool:
	for required_id in phase.get("required_conversation_ids", []):
		if not TimelineState.is_episode_completed(day_value, str(required_id)):
			return false
	var required_any: Array = phase.get("required_any_conversation_ids", [])
	if not required_any.is_empty():
		for candidate in required_any:
			if TimelineState.is_episode_completed(day_value, str(candidate)):
				return true
		return false
	return true

func _phase_is_optional(phase: Dictionary) -> bool:
	return not phase.get("optional_conversation_ids", []).is_empty()

func _add_phase_advance_control(day_value) -> void:
	if transition_in_progress or TimelineState.is_day_completed(day_value):
		return
	var phase := DataLoader.get_timeline_phase(day_value, TimelineState.current_phase_id(day_value))
	var optional_ids: Array = phase.get("optional_conversation_ids", [])
	if optional_ids.is_empty():
		return
	var opened_incomplete := false
	var any_completed := false
	for raw_id in optional_ids:
		var conversation_id := str(raw_id)
		if TimelineState.is_episode_completed(day_value, conversation_id):
			any_completed = true
		elif TimelineState.is_optional_opened(day_value, conversation_id):
			opened_incomplete = true
	var label := str(phase.get("advance_label", "Continuer"))
	if any_completed:
		label = str(phase.get("advance_label_completed", label))
	elif opened_incomplete:
		label = str(phase.get("advance_label_blocked", "Terminer la conversation avant de continuer"))
	var button := _add_button(conversation_list, label)
	button.disabled = opened_incomplete
	var phase_id := str(phase.get("id", ""))
	button.pressed.connect(func(): _advance_optional_phase(day_value, phase_id))

func _advance_optional_phase(day_value, phase_id: String) -> void:
	if transition_in_progress or phase_id != TimelineState.current_phase_id(day_value):
		return
	var phase := DataLoader.get_timeline_phase(day_value, phase_id)
	var any_completed := false
	for raw_id in phase.get("optional_conversation_ids", []):
		var conversation_id := str(raw_id)
		if TimelineState.is_optional_opened(day_value, conversation_id) and not TimelineState.is_episode_completed(day_value, conversation_id):
			return
		if TimelineState.is_episode_completed(day_value, conversation_id):
			any_completed = true
	if any_completed:
		TimelineState.complete_phase(day_value, phase_id)
	else:
		for raw_id in phase.get("optional_conversation_ids", []):
			TimelineState.expire_conversation(day_value, str(raw_id))
		EffectApplier.apply_flags(phase.get("skip_sets_flags", []))
		TimelineState.skip_phase(day_value, phase_id)
	await _advance_after_phase(day_value, phase_id)

func _complete_day(day_value) -> void:
	if transition_in_progress:
		return
	transition_in_progress = true
	_hide_notification()
	_clear_pending_for_day(day_value)
	TimelineState.mark_day_complete(day_value)
	var end_card := DataLoader.get_timeline_day_end_card(day_value)
	var next_day = DataLoader.get_timeline_next_day(day_value)
	if next_day != null:
		var start_card := DataLoader.get_timeline_day_start_card(next_day)
		await timeline_transition_view.show_day_transition(end_card, start_card)
		TimelineState.unlock_day(next_day)
		TimelineState.set_current_day(next_day)
		current_day_value = next_day
		viewing_archived_day = false
		transition_in_progress = false
		_render_days()
	else:
		if not end_card.is_empty():
			await timeline_transition_view.show_moment_transition(end_card)
		transition_in_progress = false
		_render_days()

func _clear_pending_for_day(day_value) -> void:
	for conversation in DataLoader.get_conversations_for_day(day_value):
		if typeof(conversation) != TYPE_DICTIONARY:
			continue
		var thread_id := _conversation_id(conversation)
		pending_thread_ids.erase(thread_id)
		pending_conversation_ids.erase(thread_id)

func _transition_card_for_phase(day_value, phase: Dictionary) -> Dictionary:
	var direct = phase.get("transition_card", {})
	if typeof(direct) == TYPE_DICTIONARY and not direct.is_empty():
		return direct
	var by_conversation = phase.get("transition_cards_by_conversation", {})
	if typeof(by_conversation) == TYPE_DICTIONARY:
		var initial_ids: Array = _conversation_availability_for_day(day_value).get("initial_conversation_ids", [])
		for conversation_id in by_conversation.keys():
			if _unlock_rule_ready(day_value, str(conversation_id), initial_ids):
				var card = by_conversation[conversation_id]
				if typeof(card) == TYPE_DICTIONARY:
					return card
	var eyebrow := "%s — %s" % [
		DataLoader.get_day_calendar_label(day_value).to_upper(),
		str(phase.get("moment_label", "")).to_upper(),
	]
	return {
		"eyebrow": eyebrow,
		"title": str(phase.get("time_label", "")),
		"duration": 0.9,
		"min_time": 0.35,
	}

func _phase_conversation_ids(phase: Dictionary) -> Array:
	var ids: Array = []
	for key in ["required_conversation_ids", "optional_conversation_ids", "required_any_conversation_ids"]:
		for raw_id in phase.get(key, []):
			var conversation_id := str(raw_id)
			if conversation_id != "" and not ids.has(conversation_id):
				ids.append(conversation_id)
	return ids

func _render_days_buttons_only() -> void:
	_clear(day_list)
	_add_label(day_list, "Jours", 15)
	for index in DataLoader.chapter_indexes:
		var day_value = index.get("day", index.get("chapter", 0))
		if not TimelineState.is_day_unlocked(day_value) and not TimelineState.is_day_completed(day_value):
			continue
		var label := _format_day_label(day_value)
		if TimelineState.is_day_completed(day_value):
			label += " · Terminé" if TimelineState.is_current_day(day_value) else " · Historique"
		var button := _add_button(day_list, label)
		button.tooltip_text = str(index.get("title", ""))
		button.disabled = transition_in_progress
		var target_day = day_value
		button.pressed.connect(func(): _on_day_button_pressed(target_day))

func _timeline_current_day_value():
	for index in DataLoader.chapter_indexes:
		var day_value = index.get("day", index.get("chapter", null))
		if TimelineState.day_key(day_value) == TimelineState.current_day_key:
			return day_value
	return null

func _on_game_state_changed() -> void:
	super._on_game_state_changed()
	if GameState.context.get("day", null) == null and str(GameState.context.get("last_choice", "")) == "":
		TimelineState.reset_timeline()
		transition_in_progress = false
		viewing_archived_day = false
		if is_instance_valid(timeline_transition_view):
			timeline_transition_view.clear_transition()
		current_day_value = _timeline_current_day_value()
		_render_days.call_deferred()
