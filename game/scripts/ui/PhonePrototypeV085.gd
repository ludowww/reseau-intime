extends "res://scripts/ui/PhonePrototypeV084.gd"

# V0.85 adds only the authored, conversation-free offline phases required by
# the reconciled Tuesday. The V0.84 day/phase engine remains authoritative.
func _activate_phase(day_value, phase: Dictionary, show_transition: bool) -> void:
	if _phase_has_authored_beat(phase):
		await _activate_authored_beat_phase(day_value, phase)
		return
	await super._activate_phase(day_value, phase, show_transition)

func _render_archived_day(day_value) -> void:
	super._render_archived_day(day_value)
	var entries: Array = TimelineState.get_day_log_entries(day_value)
	if entries.is_empty():
		return
	_add_label(conversation_list, "Moments hors ligne", 15)
	for raw_entry in entries:
		if typeof(raw_entry) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = raw_entry
		var lines: Array[String] = []
		var time_label := str(entry.get("time_label", ""))
		var title := str(entry.get("title", ""))
		var text := str(entry.get("text", ""))
		if time_label != "":
			lines.append(time_label)
		if title != "":
			lines.append(title)
		if text != "" and text != title:
			lines.append(text)
		_add_muted_label(conversation_list, "\n".join(lines), 12)

func _phase_has_authored_beat(phase: Dictionary) -> bool:
	return phase.has("authored_beat") or not phase.get("authored_beat_variants", []).is_empty()

func _activate_authored_beat_phase(day_value, phase: Dictionary) -> void:
	if phase.is_empty() or transition_in_progress:
		return
	transition_in_progress = true
	_hide_notification()
	var phase_id := str(phase.get("id", ""))
	TimelineState.set_current_phase(day_value, phase_id)
	var beat := _authored_beat_for_phase(phase)
	if beat.is_empty():
		push_error("No authored beat variant matched timeline phase: %s" % phase_id)
		transition_in_progress = false
		_render_active_day(day_value)
		return
	var time_label := str(beat.get("time_label", phase.get("time_label", "")))
	if time_label != "":
		_on_narrative_time_changed(time_label)
	var card := _card_for_authored_beat(day_value, phase, beat)
	await timeline_transition_view.show_moment_transition(card)
	TimelineState.record_day_log_entry(day_value, {
		"id": str(beat.get("id", phase_id)),
		"phase_id": phase_id,
		"time_label": time_label,
		"title": str(beat.get("title", "")),
		"text": str(beat.get("text", beat.get("subtitle", ""))),
	})
	EffectApplier.apply_flags(beat.get("sets_flags", []))
	TimelineState.complete_phase(day_value, phase_id)
	transition_in_progress = false
	_render_active_day(day_value)
	_render_days_buttons_only()
	await _advance_after_phase(day_value, phase_id)

func _authored_beat_for_phase(phase: Dictionary) -> Dictionary:
	var direct = phase.get("authored_beat", {})
	if typeof(direct) == TYPE_DICTIONARY and not direct.is_empty() and _entry_conditions_are_met(direct):
		return direct
	for raw_variant in phase.get("authored_beat_variants", []):
		if typeof(raw_variant) != TYPE_DICTIONARY:
			continue
		var variant: Dictionary = raw_variant
		if _entry_conditions_are_met(variant):
			return variant
	return {}

func _card_for_authored_beat(day_value, phase: Dictionary, beat: Dictionary) -> Dictionary:
	var eyebrow := str(beat.get("eyebrow", ""))
	if eyebrow == "":
		eyebrow = "%s — %s" % [
			DataLoader.get_day_calendar_label(day_value).to_upper(),
			str(phase.get("moment_label", "")).to_upper(),
		]
	return {
		"eyebrow": eyebrow,
		"title": str(beat.get("title", "")),
		"subtitle": str(beat.get("subtitle", beat.get("text", ""))),
		"duration": float(beat.get("duration", 2.2)),
		"min_time": float(beat.get("min_time", 0.5)),
		"show_skip_hint": bool(beat.get("show_skip_hint", true)),
		"show_landing": bool(beat.get("show_landing", false)),
	}
