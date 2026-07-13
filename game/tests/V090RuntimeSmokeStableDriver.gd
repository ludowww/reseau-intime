extends "res://tests/V090RuntimeSmokePhaseDriver.gd"

func _open_and_play(phone, episode_id: String, choice_indexes: Array) -> void:
	var conversation := _conversation_for_episode(phone, episode_id)
	_expect(
		not conversation.is_empty(),
		"Missing available conversation for %s — %s" % [episode_id, _candidate_debug(phone)]
	)
	if conversation.is_empty():
		return

	var phase_id := MARIE_PHASE_ID
	if episode_id == SANDRA_CONVERSATION_ID:
		phase_id = SANDRA_PHASE_ID
	TimelineState.set_current_phase(DAY, phase_id)
	phone._open_conversation(DAY, conversation)

	# PhonePrototype._open_conversation applies the real opening side effects. The
	# smoke then restores the tested phase and restarts only the view rendering so
	# a list refresh cannot invalidate the asynchronous choice sequence.
	TimelineState.set_current_phase(DAY, phase_id)
	var view = phone.conversation_view
	view.reset_ui_state()
	view.set_debug_speed_multiplier(DEBUG_SPEED)
	view.show_conversation(conversation)

	for raw_index in choice_indexes:
		var choice_index := int(raw_index)
		var choices_ready := await _wait_until(
			func(): return bool(view.active_state.get("waiting_choices", false)) and view.choice_buttons.size() > choice_index,
			DEFAULT_TIMEOUT_SECONDS
		)
		_expect(
			choices_ready,
			"Choices not ready for %s index %d — %s segments=%d active_segment=%d history=%d" % [
				episode_id,
				choice_index,
				_candidate_debug(phone),
				conversation.get("segments", []).size(),
				int(view.active_state.get("current_segment_index", -1)),
				view.active_state.get("history", []).size(),
			]
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
	var phase := DataLoader.get_timeline_phase(DAY, SANDRA_PHASE_ID)
	await phone._activate_phase(DAY, phase, false)
	var offered := await _wait_until(func(): return _scene_status(_ledger()) == "OFFERED", 1.5)
	_expect(offered, "E: Sandra candidate was not offered — %s" % _candidate_debug(phone))
	if offered:
		TimelineState.set_current_phase(DAY, SANDRA_PHASE_ID)
		phone.time_passage_in_progress = false
		phone.transition_in_progress = false
		# Cancel the timer started during candidate activation, then await one
		# authoritative timer with the restored phase context.
		phone.optional_window_token += 1
		await phone._schedule_optional_expiry(DAY, phase)
		var ledger := _ledger()
		_expect(_scene_status(ledger) == "EXPIRED", "E: Sandra optional window did not expire — %s" % _expiry_debug(phone))
		_expect(
			TimelineState.is_conversation_expired(DAY, SANDRA_CONVERSATION_ID),
			"E: conversation not marked expired — %s" % _expiry_debug(phone)
		)
		_expect(
			not ledger.get("external_foreground_character_ids", []).has("sandra"),
			"E: expiry consumed Sandra foreground"
		)
		_expect(_has_flag("sandra_second_window_silent"), "E: silent resolution flag missing — %s" % _expiry_debug(phone))
	await _dispose_context(context)
