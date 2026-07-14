extends "res://scripts/ui/PhonePrototypeV090.gd"

const FirstRepetitionClosure = preload("res://scripts/narrative/FirstRepetitionClosure.gd")
const MONDAY_WAVE_CLOSE_PHASE_ID := "monday_first_repetition_wave_close"
const WAVE_COMPLETE_FLAG := "first_repetition_wave_complete"

func _activate_authored_beat_silently(day_value, phase: Dictionary) -> void:
	if str(phase.get("id", "")) != MONDAY_WAVE_CLOSE_PHASE_ID:
		await super._activate_authored_beat_silently(day_value, phase)
		return
	await _activate_first_repetition_wave_close(day_value, phase)

func _activate_first_repetition_wave_close(day_value, phase: Dictionary) -> void:
	if phase.is_empty():
		return
	transition_in_progress = true
	var phase_id := str(phase.get("id", ""))
	TimelineState.set_current_phase(day_value, phase_id)
	if TimelineState.is_phase_complete(day_value, phase_id):
		transition_in_progress = false
		return
	var flags: Array = GameState.current_state.get("flags", [])
	if flags.has(WAVE_COMPLETE_FLAG):
		TimelineState.complete_phase(day_value, phase_id)
		transition_in_progress = false
		_render_active_day(day_value)
		_render_days_buttons_only()
		await _advance_after_phase(day_value, phase_id)
		return
	var result := FirstRepetitionClosure.evaluate(flags, _ensure_first_repetition_ledger())
	if not bool(result.get("closable", false)):
		push_error("First repetition wave closure blocked: %s" % str(result.get("blocking_reasons", [])))
		transition_in_progress = false
		_render_active_day(day_value)
		_render_days_buttons_only()
		return
	EffectApplier.apply_flags([WAVE_COMPLETE_FLAG])
	TimelineState.complete_phase(day_value, phase_id)
	transition_in_progress = false
	_render_active_day(day_value)
	_render_days_buttons_only()
	await _advance_after_phase(day_value, phase_id)
