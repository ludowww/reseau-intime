extends "res://scripts/unified_runtime/execution/SequenceExecutor.gd"

class_name R8CSequenceExecutorV2

const SequenceExecutionV2 := preload(
	"res://scripts/unified_runtime/application/SequenceExecutionV2.gd"
)
const RuntimeSnapshotV2 := preload(
	"res://scripts/unified_runtime/application/UnifiedRuntimeSnapshotV2.gd"
)
const Moment := preload("res://scripts/unified_runtime/application/NarrativeMoment.gd")


static func create(facade, projection_port, authored_sequence, activation_receipt) -> Dictionary:
	var dependency_error := _validate_dependencies(facade, projection_port)
	if not dependency_error.is_empty():
		return {"ok": false, "error_code": dependency_error, "executor": null}
	if not AuthoredValidator.validate(authored_sequence, true)["valid"]:
		return {"ok": false, "error_code": "INVALID_AUTHORED_SEQUENCE", "executor": null}
	var activation_error := _validate_activation(facade, authored_sequence, activation_receipt)
	if not activation_error.is_empty():
		return {"ok": false, "error_code": activation_error, "executor": null}
	var executor := new()
	executor._facade = facade
	executor._projection_port = projection_port
	executor._authored_sequence = authored_sequence.duplicate(true)
	executor._activation_receipt = activation_receipt.duplicate(true)
	return {"ok": true, "error_code": null, "executor": executor}


static func restore(facade, projection_port, authored_sequence, snapshot) -> Dictionary:
	var restored := RuntimeSnapshotV2.restore_core_into(
		facade, projection_port, authored_sequence, snapshot
	)
	if not restored.get("ok", false):
		return {"ok": false, "error_code": restored.get("error_code"), "executor": null}
	var executor := new()
	executor._facade = facade
	executor._projection_port = projection_port
	executor._authored_sequence = authored_sequence.duplicate(true)
	executor._execution = restored["execution"].duplicate(true)
	executor._started = true
	return {
		"ok": true,
		"error_code": null,
		"executor": executor,
		"messages_adapter": restored["messages_adapter"].duplicate(true),
		"narrative_time": restored["narrative_time"],
	}


func start() -> Dictionary:
	if _started:
		return _result(false, "ALREADY_STARTED")
	var entry_beat: Dictionary = _beat_by_id(_authored_sequence["entry_beat_id"])
	var reached: Array = []
	var checkpoint = entry_beat["checkpoint_before"]
	if checkpoint != null:
		reached.append(checkpoint)
	var candidate := {
		"instance_id": _activation_receipt["instance_id"],
		"sequence_id": _authored_sequence["sequence_id"],
		"authored_version": _authored_sequence["authored_version"],
		"execution_status": "ACTIVE",
		"checkpoint_id": checkpoint,
		"current_beat_id": entry_beat["beat_id"],
		"consumed_choice_ids": [],
		"reached_checkpoint_ids": reached,
		"opened_projection_ids": [],
		"projection_receipts": {},
		"pending_player_input": null,
		"scheduled_returns": [],
		"selected_resolution_id": null,
		"durable_commit_status": "NOT_REQUESTED",
	}
	if not SequenceExecutionV2.validate(candidate, _authored_sequence)["valid"]:
		return _result(false, "INVALID_INITIAL_EXECUTION")
	_execution = candidate
	_started = true
	return _result(true)


func receive_command(command) -> Dictionary:
	if not _started or _execution.get("execution_status") == "COMPLETE":
		return super.receive_command(command)
	var beat := current_beat()
	if beat.get("type") != "RETURN" or beat.get("next", {}).get("mode") != "DIRECT":
		return super.receive_command(command)
	return _receive_chained_return_command(command, beat)


func commit_resolution(context) -> Dictionary:
	if not _started:
		return _result(false, "NOT_STARTED")
	if typeof(context) != TYPE_DICTIONARY or not Moment.validate(context.get("moment_diegetique")):
		return _result(false, "INVALID_RESOLUTION_CONTEXT")
	if _execution.get("durable_commit_status") in ["APPLIED", "IDEMPOTENT"]:
		var committed_envelope := _envelope_from_selection()
		if context.has("sequence_resolution") and context["sequence_resolution"] != committed_envelope:
			return _result(false, "DIVERGENT_COMMIT")
		return _result(true, null, true, {"sequence_resolution": committed_envelope})
	if _execution["execution_status"] != "RESOLUTION_READY":
		return _result(false, "RESOLUTION_NOT_READY")
	var envelope: Dictionary = _envelope_from_selection()
	if envelope.is_empty():
		return _result(false, "RESOLUTION_NOT_SELECTED")
	if context.has("sequence_resolution") and context["sequence_resolution"] != envelope:
		return _result(false, "DIVERGENT_COMMIT")
	var authored_resolution: Dictionary = _authored_sequence["resolutions"][envelope["resolution_id"]]
	var next_beat_id = authored_resolution["next_beat_id"]
	var next_beat: Dictionary = {}
	var planned_schedule: Dictionary = {}
	if next_beat_id != null:
		next_beat = _beat_by_id(next_beat_id)
		planned_schedule = _schedule_return(
			next_beat, envelope["resolution_id"], context["moment_diegetique"]
		)
		if planned_schedule.is_empty():
			return _result(false, "INVALID_RETURN_DELAY")
	var resolution_context: Dictionary = context.duplicate(true)
	resolution_context["sequence_resolution"] = envelope.duplicate(true)
	_execution["durable_commit_status"] = "PENDING"
	var resolution_result = _facade.resolve_scene(
		envelope["instance_id"],
		envelope["a10_choice_id"],
		envelope["a10_resolution_id"],
		resolution_context,
	)
	if (
		typeof(resolution_result) != TYPE_DICTIONARY
		or not resolution_result.get("ok", false)
		or resolution_result.get("state") != "RESOLVED"
		or resolution_result.get("transaction_status") not in ["APPLIQUE", "IDEMPOTENT"]
	):
		_execution["durable_commit_status"] = "NOT_REQUESTED"
		return _result(false, "A10_RESOLUTION_REFUSED")
	_execution["durable_commit_status"] = (
		"IDEMPOTENT" if resolution_result["transaction_status"] == "IDEMPOTENT" else "APPLIED"
	)
	if next_beat_id == null:
		_complete_execution()
	else:
		_execution["checkpoint_id"] = next_beat["checkpoint_before"]
		if next_beat["checkpoint_before"] != null:
			_reach_checkpoint(next_beat["checkpoint_before"])
		_execution["current_beat_id"] = next_beat_id
		_execution["execution_status"] = "RESOLVED_RETURN_PENDING"
		_execution["scheduled_returns"] = [planned_schedule]
	if not _execution_valid():
		return _result(false, "INVALID_EXECUTION_TRANSITION")
	return _result(
		true,
		null,
		resolution_result["transaction_status"] == "IDEMPOTENT",
		{"sequence_resolution": envelope, "a10_result": resolution_result},
	)


func snapshot(messages_adapter_snapshot: Dictionary = {}, narrative_time = null) -> Dictionary:
	if not _started:
		return _result(false, "NOT_STARTED")
	var built := RuntimeSnapshotV2.create(
		_facade,
		_projection_port,
		_authored_sequence,
		_execution,
		messages_adapter_snapshot,
		narrative_time,
	)
	if not built["ok"]:
		return _result(false, built["error_code"])
	return _result(true, null, false, {"snapshot": built["snapshot"]})


func _receive_chained_return_command(command, beat: Dictionary) -> Dictionary:
	var validation := ProjectionContracts.validate_projection_command(command)
	if not validation["valid"]:
		return _result(false, "INVALID_COMMAND")
	if command["instance_id"] != _execution["instance_id"]:
		return _result(false, "COMMAND_BEAT_MISMATCH")
	if command["beat_id"] != _execution["current_beat_id"]:
		return _result(false, "COMMAND_BEAT_MISMATCH")
	if _execution["execution_status"] != "WAITING_FOR_PLAYER":
		return _result(false, "EXECUTION_NOT_WAITING_FOR_COMMAND")
	var pending: Dictionary = _execution["pending_player_input"]
	if command["kind"] != "CONTINUE" or command["kind"] != pending["kind"]:
		return _result(false, "COMMAND_KIND_MISMATCH")
	var next_beat := _beat_by_id(beat["next"]["beat_id"])
	if next_beat.get("type") != "RETURN":
		return _result(false, "INVALID_RETURN_CHAIN")
	var schedules: Array = _execution.get("scheduled_returns", [])
	if schedules.size() != 1 or not Moment.validate(schedules[0].get("eligible_at")):
		return _result(false, "INVALID_RETURN_CHAIN")
	var planned_schedule := _schedule_return(
		next_beat, str(_execution["selected_resolution_id"]), schedules[0]["eligible_at"]
	)
	if planned_schedule.is_empty():
		return _result(false, "INVALID_RETURN_DELAY")
	var submitted = _projection_port.submit(command)
	if not ProjectionContracts.validate_projection_result(submitted)["valid"] or not submitted["accepted"]:
		return _result(false, "PORT_COMMAND_REFUSED")
	var presentation_id := ProjectionContracts.presentation_id_for(_projection_request(beat))
	var closed = _projection_port.close(presentation_id)
	if not ProjectionContracts.validate_projection_result(closed)["valid"] or not closed["accepted"]:
		return _result(false, "PORT_CLOSE_REFUSED")
	_execution["pending_player_input"] = null
	_execution["current_beat_id"] = next_beat["beat_id"]
	_execution["checkpoint_id"] = next_beat["checkpoint_before"]
	if next_beat["checkpoint_before"] != null:
		_reach_checkpoint(next_beat["checkpoint_before"])
	_execution["execution_status"] = "RESOLVED_RETURN_PENDING"
	_execution["scheduled_returns"] = [planned_schedule]
	if not _execution_valid():
		return _result(false, "INVALID_EXECUTION_TRANSITION")
	return _result(true, null, submitted["idempotent"], {"port_result": submitted})


func _schedule_return(beat: Dictionary, resolution_id: String, scheduled_from: String) -> Dictionary:
	if beat.get("type") != "RETURN":
		return {}
	if resolution_id not in beat.get("content", {}).get("eligible_resolution_ids", []):
		return {}
	var delay: Dictionary = beat.get("content", {}).get("delay", {})
	var mode := str(delay.get("mode", ""))
	var eligible_at = null
	var after_event_id = null
	match mode:
		"NONE":
			eligible_at = scheduled_from
		"DIEGETIC_MINUTES":
			eligible_at = Moment.add_minutes(scheduled_from, delay.get("value"))
			if str(eligible_at).is_empty():
				return {}
		"AFTER_EVENT":
			after_event_id = delay.get("value")
			if typeof(after_event_id) != TYPE_STRING or after_event_id.is_empty():
				return {}
		_:
			return {}
	return {
		"beat_id": beat["beat_id"],
		"resolution_id": resolution_id,
		"presentation_id": _presentation_id_for_beat(beat),
		"delay_mode": mode,
		"scheduled_from": scheduled_from,
		"eligible_at": eligible_at,
		"after_event_id": after_event_id,
	}


func _execution_valid() -> bool:
	return SequenceExecutionV2.validate(_execution, _authored_sequence)["valid"]
