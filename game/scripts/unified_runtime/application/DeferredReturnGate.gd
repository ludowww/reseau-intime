extends RefCounted

class_name R8CDeferredReturnGate

const SequenceExecution := preload(
	"res://scripts/unified_runtime/application/SequenceExecutionV2.gd"
)
const Moment := preload("res://scripts/unified_runtime/application/NarrativeMoment.gd")

const ELIGIBLE := "ELIGIBLE"
const NOT_ELIGIBLE := "NOT_ELIGIBLE"
const RESULT_FIELDS := ["ok", "error_code", "status"]


static func evaluate(execution, current_narrative_time, durable_domain) -> Dictionary:
	var structure := SequenceExecution.validate_structure(execution)
	if not structure["valid"]:
		return _error("INVALID_EXECUTION_V2")
	if execution.get("execution_status") != "RESOLVED_RETURN_PENDING":
		return _error("RETURN_NOT_PENDING")
	var schedules: Array = execution.get("scheduled_returns", [])
	if schedules.size() != 1:
		return _error("INVALID_SCHEDULED_RETURN_COUNT")
	if not Moment.validate(current_narrative_time):
		return _error("INVALID_NARRATIVE_TIME")
	var schedule: Dictionary = schedules[0]
	match schedule["delay_mode"]:
		"NONE":
			return _success(ELIGIBLE)
		"DIEGETIC_MINUTES":
			return _success(
				ELIGIBLE
				if Moment.compare(current_narrative_time, schedule["eligible_at"]) >= 0
				else NOT_ELIGIBLE
			)
		"AFTER_EVENT":
			var events = _durable_events(durable_domain)
			if events == null:
				return _error("INVALID_DURABLE_EVENT_REGISTRY")
			return _success(ELIGIBLE if events.has(schedule["after_event_id"]) else NOT_ELIGIBLE)
		_:
			return _error("UNKNOWN_DELAY_MODE")


static func _durable_events(domain):
	if typeof(domain) != TYPE_DICTIONARY:
		return null
	var narrative_state = domain.get("narrative_state")
	if typeof(narrative_state) != TYPE_DICTIONARY:
		return null
	var events = narrative_state.get("evenements")
	return events if typeof(events) == TYPE_DICTIONARY else null


static func _success(status: String) -> Dictionary:
	return {"ok": true, "error_code": null, "status": status}


static func _error(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "status": null}
