extends "res://tests/V090RuntimeSmokeDriver.gd"

func _activate_and_play_sandra(phone, main_choice_index: int) -> void:
	await phone._activate_phase(DAY, DataLoader.get_timeline_phase(DAY, SANDRA_PHASE_ID), false)
	var offered := await _wait_until(func(): return _scene_status(_ledger()) == "OFFERED", 1.5)
	_expect(offered, "Sandra candidate was not offered — %s" % _candidate_debug(phone))
	if not offered:
		return
	TimelineState.set_current_phase(DAY, SANDRA_PHASE_ID)
	await _open_and_play(phone, SANDRA_CONVERSATION_ID, [0, main_choice_index])
	var resolved := await _wait_until(func(): return _scene_status(_ledger()) == "RESOLVED", DEFAULT_TIMEOUT_SECONDS)
	_expect(resolved, "Sandra conversation did not reach RESOLVED — %s" % _candidate_debug(phone))

func _scenario_e_sandra_expiry() -> void:
	var context := await _new_phone_context()
	var phone = context["phone"]
	_prepare_sandra_eligibility()
	await phone._activate_phase(DAY, DataLoader.get_timeline_phase(DAY, SANDRA_PHASE_ID), false)
	var offered := await _wait_until(func(): return _scene_status(_ledger()) == "OFFERED", 1.5)
	_expect(offered, "E: Sandra candidate was not offered — %s" % _candidate_debug(phone))
	if offered:
		TimelineState.set_current_phase(DAY, SANDRA_PHASE_ID)
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
