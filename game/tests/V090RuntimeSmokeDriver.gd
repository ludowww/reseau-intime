extends "res://tests/V090RuntimeSmokeTest.gd"

func _conversation_for_episode(phone, episode_id: String) -> Dictionary:
	var available_ids: Array = phone._available_conversation_ids_for_day(DAY)
	if not available_ids.has(episode_id):
		return {}
	var raw_conversation = DataLoader.conversations_by_id.get(episode_id, {})
	if typeof(raw_conversation) != TYPE_DICTIONARY:
		return {}
	var grouped: Dictionary = DataLoader.get_segmented_conversation_entry(raw_conversation)
	return phone._filter_conversation_to_available_episodes(DAY, grouped)

func _open_and_play(phone, episode_id: String, choice_indexes: Array) -> void:
	var conversation := _conversation_for_episode(phone, episode_id)
	_expect(
		not conversation.is_empty(),
		"Missing available conversation for %s — %s" % [episode_id, _candidate_debug(phone)]
	)
	if conversation.is_empty():
		return
	phone._open_conversation(DAY, conversation)
	var view = phone.conversation_view
	for raw_index in choice_indexes:
		var choice_index := int(raw_index)
		var choices_ready := await _wait_until(
			func(): return bool(view.active_state.get("waiting_choices", false)) and view.choice_buttons.size() > choice_index,
			DEFAULT_TIMEOUT_SECONDS
		)
		_expect(
			choices_ready,
			"Choices not ready for %s index %d — %s" % [episode_id, choice_index, _candidate_debug(phone)]
		)
		if not choices_ready:
			return
		var button: Button = view.choice_buttons[choice_index]
		button.emit_signal("pressed")
		await get_tree().process_frame
	var completed := await _wait_until(
		func(): return TimelineState.is_episode_completed(DAY, episode_id),
		DEFAULT_TIMEOUT_SECONDS
	)
	_expect(completed, "Conversation did not complete: %s — %s" % [episode_id, _candidate_debug(phone)])

func _scenario_e_sandra_expiry() -> void:
	var context := await _new_phone_context()
	var phone = context["phone"]
	_prepare_sandra_eligibility()
	await phone._activate_phase(DAY, DataLoader.get_timeline_phase(DAY, SANDRA_PHASE_ID), false)
	var offered := await _wait_until(func(): return _scene_status(_ledger()) == "OFFERED", 1.5)
	_expect(offered, "E: Sandra candidate was not offered — %s" % _candidate_debug(phone))
	if offered:
		var expired := await _wait_until(func(): return _scene_status(_ledger()) == "EXPIRED", 4.0)
		_expect(expired, "E: Sandra optional window did not expire — %s" % _expiry_debug(phone))
		var ledger := _ledger()
		_expect(
			TimelineState.is_conversation_expired(DAY, SANDRA_CONVERSATION_ID),
			"E: conversation not marked expired — %s" % _expiry_debug(phone)
		)
		_expect(
			not ledger.get("external_foreground_character_ids", []).has("sandra"),
			"E: expiry consumed Sandra foreground"
		)
		var silent := await _wait_until(func(): return _has_flag("sandra_second_window_silent"), 4.0)
		_expect(silent, "E: silent resolution flag missing — %s" % _expiry_debug(phone))
	await _dispose_context(context)

func _expiry_debug(phone) -> String:
	return "%s opened=%s completed=%s expired=%s optional_token=%s time_token=%s time_in_progress=%s transition=%s" % [
		_candidate_debug(phone),
		TimelineState.is_optional_opened(DAY, SANDRA_CONVERSATION_ID),
		TimelineState.is_episode_completed(DAY, SANDRA_CONVERSATION_ID),
		TimelineState.is_conversation_expired(DAY, SANDRA_CONVERSATION_ID),
		phone.optional_window_token,
		phone.time_passage_token,
		phone.time_passage_in_progress,
		phone.transition_in_progress,
	]
