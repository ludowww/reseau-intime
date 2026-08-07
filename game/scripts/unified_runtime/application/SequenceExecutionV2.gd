extends RefCounted

class_name R8CSequenceExecutionV2

const V1 := preload("res://scripts/unified_runtime/contracts/SequenceExecutionV1.gd")
const Moment := preload("res://scripts/unified_runtime/application/NarrativeMoment.gd")

const SCHEMA_VERSION := 2
const SCHEDULED_RETURN_FIELDS := [
	"beat_id", "resolution_id", "presentation_id", "delay_mode", "scheduled_from",
	"eligible_at", "after_event_id",
]
const DELAY_MODES := ["NONE", "DIEGETIC_MINUTES", "AFTER_EVENT"]


static func validate(value, authored_sequence) -> Dictionary:
	return validate_against_sequence(value, authored_sequence)


static func validate_structure(value) -> Dictionary:
	var errors: Array[String] = []
	_validate_v2_schedules(value, {}, false, errors)
	_validate_schedule_binding(value, {}, false, errors)
	var base := V1.validate_structure(to_v1_shape(value))
	for error in base.get("errors", []):
		errors.append(str(error))
	return _result(errors)


static func validate_against_sequence(value, authored_sequence) -> Dictionary:
	var errors: Array[String] = []
	var base := V1.validate_against_sequence(to_v1_shape(value), authored_sequence)
	for error in base.get("errors", []):
		errors.append(str(error))
	_validate_v2_schedules(value, authored_sequence, true, errors)
	_validate_schedule_binding(value, authored_sequence, true, errors)
	return _result(errors)


static func migrate_v1_execution(value, authored_sequence, scheduled_from) -> Dictionary:
	var validation := V1.validate(value, authored_sequence)
	if not validation["valid"]:
		return {"ok": false, "error_code": "INVALID_V1_EXECUTION", "execution": {}}
	if not value.get("scheduled_returns", []).is_empty():
		return {
			"ok": false,
			"error_code": "UNSUPPORTED_V1_DEFERRED_RETURN_STATE",
			"execution": {},
		}
	if not Moment.validate(scheduled_from):
		return {"ok": false, "error_code": "INVALID_NARRATIVE_TIME", "execution": {}}
	var migrated: Dictionary = value.duplicate(true)
	var migrated_validation := validate(migrated, authored_sequence)
	if not migrated_validation["valid"]:
		return {"ok": false, "error_code": "INVALID_V2_EXECUTION", "execution": {}}
	return {"ok": true, "error_code": null, "execution": migrated}


static func to_v1_shape(value):
	if typeof(value) != TYPE_DICTIONARY:
		return value
	var adapted: Dictionary = value.duplicate(true)
	var schedules = adapted.get("scheduled_returns")
	if typeof(schedules) != TYPE_ARRAY:
		return adapted
	var v1_schedules: Array = []
	for schedule in schedules:
		if typeof(schedule) != TYPE_DICTIONARY:
			v1_schedules.append(schedule)
			continue
		v1_schedules.append({
			"beat_id": schedule.get("beat_id"),
			"resolution_id": schedule.get("resolution_id"),
			"presentation_id": schedule.get("presentation_id"),
		})
	adapted["scheduled_returns"] = v1_schedules
	return adapted


static func _validate_v2_schedules(
	value,
	authored_sequence,
	with_authored: bool,
	errors: Array[String],
) -> void:
	if typeof(value) != TYPE_DICTIONARY:
		return
	var schedules = value.get("scheduled_returns")
	if typeof(schedules) != TYPE_ARRAY:
		return
	for index in schedules.size():
		var path := "execution.scheduled_returns[%d]" % index
		var schedule = schedules[index]
		if typeof(schedule) != TYPE_DICTIONARY:
			_add_error(errors, path, "expected_dictionary")
			continue
		if not _exact(schedule, SCHEDULED_RETURN_FIELDS):
			_add_error(errors, path, "unexpected_fields")
			continue
		var delay_mode = schedule["delay_mode"]
		if delay_mode not in DELAY_MODES:
			_add_error(errors, path + ".delay_mode", "unknown_value")
			continue
		if not Moment.validate(schedule["scheduled_from"]):
			_add_error(errors, path + ".scheduled_from", "invalid_normalized_moment")
		if delay_mode == "NONE":
			if schedule["eligible_at"] != schedule["scheduled_from"]:
				_add_error(errors, path + ".eligible_at", "must_equal_scheduled_from")
			if schedule["after_event_id"] != null:
				_add_error(errors, path + ".after_event_id", "expected_null")
		elif delay_mode == "DIEGETIC_MINUTES":
			if not Moment.validate(schedule["eligible_at"]):
				_add_error(errors, path + ".eligible_at", "invalid_normalized_moment")
			elif not Moment.same_offset(schedule["scheduled_from"], schedule["eligible_at"]):
				_add_error(errors, path + ".eligible_at", "offset_mismatch")
			if schedule["after_event_id"] != null:
				_add_error(errors, path + ".after_event_id", "expected_null")
		else:
			if schedule["eligible_at"] != null:
				_add_error(errors, path + ".eligible_at", "expected_null")
			if not _identifier(schedule["after_event_id"]):
				_add_error(errors, path + ".after_event_id", "expected_identifier")
		if with_authored:
			_validate_authored_schedule(schedule, authored_sequence, path, errors)


static func _validate_authored_schedule(
	schedule: Dictionary,
	authored_sequence,
	path: String,
	errors: Array[String],
) -> void:
	if typeof(authored_sequence) != TYPE_DICTIONARY:
		return
	var return_beat := {}
	for beat in authored_sequence.get("beats", []):
		if beat.get("beat_id") == schedule["beat_id"]:
			return_beat = beat
			break
	if return_beat.get("type") != "RETURN":
		return
	var delay: Dictionary = return_beat.get("content", {}).get("delay", {})
	if schedule["delay_mode"] != delay.get("mode"):
		_add_error(errors, path + ".delay_mode", "authored_delay_mismatch")
		return
	match schedule["delay_mode"]:
		"NONE":
			pass
		"DIEGETIC_MINUTES":
			var expected := Moment.add_minutes(schedule["scheduled_from"], delay.get("value"))
			if expected.is_empty() or schedule["eligible_at"] != expected:
				_add_error(errors, path + ".eligible_at", "authored_delay_mismatch")
		"AFTER_EVENT":
			if schedule["after_event_id"] != delay.get("value"):
				_add_error(errors, path + ".after_event_id", "authored_delay_mismatch")


static func _validate_schedule_binding(
	value,
	authored_sequence,
	with_authored: bool,
	errors: Array[String],
) -> void:
	if typeof(value) != TYPE_DICTIONARY or typeof(value.get("scheduled_returns")) != TYPE_ARRAY:
		return
	var schedules: Array = value["scheduled_returns"]
	var status = value.get("execution_status")
	if schedules.is_empty():
		if status == "RESOLVED_RETURN_PENDING":
			_add_error(errors, "execution.scheduled_returns", "expected_exactly_one_pending_return")
		return
	if status not in [
		"RESOLVED_RETURN_PENDING", "WAITING_FOR_PROJECTION_ACK", "WAITING_FOR_PLAYER",
	]:
		_add_error(errors, "execution.scheduled_returns", "unexpected_outside_return_lifecycle")
		return
	if schedules.size() != 1 or typeof(schedules[0]) != TYPE_DICTIONARY:
		_add_error(errors, "execution.scheduled_returns", "expected_exactly_one_return_schedule")
		return
	var schedule: Dictionary = schedules[0]
	if schedule.get("beat_id") != value.get("current_beat_id"):
		_add_error(errors, "execution.scheduled_returns[0].beat_id", "current_beat_mismatch")
	if schedule.get("resolution_id") != value.get("selected_resolution_id"):
		_add_error(errors, "execution.scheduled_returns[0].resolution_id", "selected_resolution_mismatch")
	if not with_authored or typeof(authored_sequence) != TYPE_DICTIONARY:
		return
	var beat := {}
	for candidate in authored_sequence.get("beats", []):
		if candidate.get("beat_id") == schedule.get("beat_id"):
			beat = candidate
			break
	if beat.is_empty():
		return
	var expected_presentation_id := "%s__%s__%s" % [
		value.get("instance_id"), beat.get("beat_id"), beat.get("projection_target"),
	]
	if schedule.get("presentation_id") != expected_presentation_id:
		_add_error(errors, "execution.scheduled_returns[0].presentation_id", "deterministic_identity_mismatch")


static func _exact(value: Dictionary, fields: Array) -> bool:
	if value.size() != fields.size():
		return false
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _identifier(value) -> bool:
	return typeof(value) == TYPE_STRING and not value.is_empty() and value == value.strip_edges()


static func _add_error(errors: Array[String], path: String, code: String) -> void:
	errors.append(path + ":" + code)


static func _result(errors: Array[String]) -> Dictionary:
	return {"valid": errors.is_empty(), "errors": errors.duplicate()}
