extends RefCounted

class_name R8CSequenceExecutor

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const SequenceExecution := preload(
	"res://scripts/unified_runtime/contracts/SequenceExecutionV1.gd"
)
const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)
const ProjectionPort := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionPort.gd"
)
const ResolutionEnvelope := preload(
	"res://scripts/unified_runtime/execution/SequenceResolutionEnvelopeV1.gd"
)
const RuntimeSnapshot := preload(
	"res://scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd"
)

var _facade
var _projection_port
var _authored_sequence: Dictionary = {}
var _activation_receipt: Dictionary = {}
var _execution: Dictionary = {}
var _started := false


static func create(facade, projection_port, authored_sequence, activation_receipt) -> Dictionary:
	var error_code := _validate_dependencies(facade, projection_port)
	if not error_code.is_empty():
		return _creation_failure(error_code)
	var authored_validation := AuthoredValidator.validate(authored_sequence)
	if not authored_validation["valid"]:
		return _creation_failure("INVALID_AUTHORED_SEQUENCE")
	var activation_error := _validate_activation(facade, authored_sequence, activation_receipt)
	if not activation_error.is_empty():
		return _creation_failure(activation_error)
	var executor := new()
	executor._facade = facade
	executor._projection_port = projection_port
	executor._authored_sequence = authored_sequence.duplicate(true)
	executor._activation_receipt = activation_receipt.duplicate(true)
	return {"ok": true, "error_code": null, "executor": executor}


static func restore(facade, projection_port, authored_sequence, snapshot) -> Dictionary:
	var error_code := _validate_dependencies(facade, projection_port)
	if not error_code.is_empty():
		return _creation_failure(error_code)
	var restored := RuntimeSnapshot.restore_into(
		facade, projection_port, authored_sequence, snapshot
	)
	if not restored["ok"]:
		return _creation_failure(restored["error_code"])
	var executor := new()
	executor._facade = facade
	executor._projection_port = projection_port
	executor._authored_sequence = authored_sequence.duplicate(true)
	executor._execution = restored["execution"].duplicate(true)
	executor._started = true
	return {"ok": true, "error_code": null, "executor": executor}


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
	var validation := SequenceExecution.validate(candidate, _authored_sequence)
	if not validation["valid"]:
		return _result(false, "INVALID_INITIAL_EXECUTION")
	_execution = candidate
	_started = true
	return _result(true)


func execution_state() -> Dictionary:
	return _execution.duplicate(true)


func current_beat() -> Dictionary:
	if not _started or _execution.get("current_beat_id") == null:
		return {}
	return _beat_by_id(_execution["current_beat_id"]).duplicate(true)


func open_current_projection() -> Dictionary:
	if not _started:
		return _result(false, "NOT_STARTED")
	if _execution["execution_status"] == "COMPLETE":
		return _result(false, "EXECUTION_COMPLETE")
	if _execution["execution_status"] not in ["ACTIVE", "RESOLVED_RETURN_PENDING"]:
		return _result(false, "EXECUTION_NOT_READY_FOR_PROJECTION")
	var beat := current_beat()
	var support = _projection_port.supports_projection(beat["projection_target"])
	if (
		typeof(support) != TYPE_DICTIONARY
		or not support.get("supported", false)
	):
		return _result(false, "UNSUPPORTED_PROJECTION")
	var request := _projection_request(beat)
	var validation := ProjectionContracts.validate_projection_request(request)
	if not validation["valid"]:
		return _result(false, "INVALID_PROJECTION_REQUEST")
	var opened = _projection_port.open(request)
	if not ProjectionContracts.validate_projection_result(opened)["valid"] or not opened["accepted"]:
		return _result(false, "PORT_OPEN_REFUSED")
	var presentation_id: String = opened["presentation_id"]
	if presentation_id not in _execution["opened_projection_ids"]:
		_execution["opened_projection_ids"].append(presentation_id)
	_execution["execution_status"] = "WAITING_FOR_PROJECTION_ACK"
	if not _execution_valid():
		return _result(false, "INVALID_EXECUTION_TRANSITION")
	return _result(true, null, opened["idempotent"], {"request": request, "port_result": opened})


func receive_ack(receipt) -> Dictionary:
	if not _started:
		return _result(false, "NOT_STARTED")
	if _execution["execution_status"] == "COMPLETE":
		return _result(false, "EXECUTION_COMPLETE")
	var request := _projection_request(current_beat())
	var linkage := ProjectionContracts.validate_receipt_against_request(receipt, request)
	if not linkage["valid"]:
		return _result(false, "FOREIGN_RECEIPT")
	var presentation_id: String = receipt["presentation_id"]
	if _execution["projection_receipts"].get(presentation_id) == receipt["kind"]:
		var replay = _projection_port.acknowledge(receipt)
		if ProjectionContracts.validate_projection_result(replay)["valid"] and replay["accepted"]:
			return _result(true, null, true, {"port_result": replay})
		return _result(false, "PORT_ACK_REFUSED")
	if _execution["execution_status"] != "WAITING_FOR_PROJECTION_ACK":
		return _result(false, "EXECUTION_NOT_WAITING_FOR_ACK")
	var acknowledged = _projection_port.acknowledge(receipt)
	if (
		not ProjectionContracts.validate_projection_result(acknowledged)["valid"]
		or not acknowledged["accepted"]
	):
		return _result(false, "PORT_ACK_REFUSED")
	_execution["projection_receipts"][presentation_id] = receipt["kind"]
	var beat := current_beat()
	_reach_checkpoint(beat["checkpoint_after"])
	_execution["execution_status"] = "WAITING_FOR_PLAYER"
	if beat["type"] == "CHOICE":
		var allowed_choice_ids: Array = []
		for choice in beat["content"]["choices"]:
			allowed_choice_ids.append(choice["choice_id"])
		_execution["pending_player_input"] = {
			"kind": "SELECT_CHOICE",
			"beat_id": beat["beat_id"],
			"allowed_choice_ids": allowed_choice_ids,
		}
	elif beat["type"] == "PHYSICAL_BEAT":
		_execution["pending_player_input"] = {
			"kind": "CONTINUE",
			"beat_id": beat["beat_id"],
			"allowed_choice_ids": beat["content"]["withdrawal_choice_ids"].duplicate(),
		}
	else:
		_execution["pending_player_input"] = {
			"kind": "CONTINUE",
			"beat_id": beat["beat_id"],
			"allowed_choice_ids": [],
		}
	if not _execution_valid():
		return _result(false, "INVALID_EXECUTION_TRANSITION")
	return _result(true, null, acknowledged["idempotent"], {"port_result": acknowledged})


func receive_command(command) -> Dictionary:
	if not _started:
		return _result(false, "NOT_STARTED")
	if _execution["execution_status"] == "COMPLETE":
		return _result(false, "EXECUTION_COMPLETE")
	var validation := ProjectionContracts.validate_projection_command(command)
	if not validation["valid"]:
		return _result(false, "INVALID_COMMAND")
	if command["instance_id"] != _execution["instance_id"]:
		return _result(false, "COMMAND_BEAT_MISMATCH")
	if command["choice_id"] != null and command["choice_id"] in _execution["consumed_choice_ids"]:
		if command["beat_id"] == _execution["current_beat_id"] or _is_consumed_withdrawal_replay(command):
			return _result(true, null, true)
		return _result(false, "COMMAND_BEAT_MISMATCH")
	if command["beat_id"] != _execution["current_beat_id"]:
		return _result(false, "COMMAND_BEAT_MISMATCH")
	if _execution["execution_status"] != "WAITING_FOR_PLAYER":
		return _result(false, "EXECUTION_NOT_WAITING_FOR_COMMAND")
	var pending: Dictionary = _execution["pending_player_input"]
	var is_withdrawal: bool = (
		command["kind"] == "WITHDRAW"
		and pending["kind"] == "CONTINUE"
		and current_beat()["type"] == "PHYSICAL_BEAT"
	)
	if command["kind"] != pending["kind"] and not is_withdrawal:
		return _result(false, "COMMAND_KIND_MISMATCH")
	var selected_choice_context := {}
	if command["kind"] in ["SELECT_CHOICE", "WITHDRAW"]:
		if command["choice_id"] not in pending["allowed_choice_ids"]:
			return _result(false, "UNKNOWN_CHOICE")
		selected_choice_context = _choice_with_owner_by_id(command["choice_id"])
		if (
			selected_choice_context.is_empty()
			or (
				command["kind"] == "SELECT_CHOICE"
				and selected_choice_context["owner_beat"]["beat_id"] != current_beat()["beat_id"]
			)
		):
			return _result(false, "UNKNOWN_CHOICE")
	var submitted = _projection_port.submit(command)
	if not ProjectionContracts.validate_projection_result(submitted)["valid"] or not submitted["accepted"]:
		return _result(false, "PORT_COMMAND_REFUSED")
	var presentation_id := ProjectionContracts.presentation_id_for(_projection_request(current_beat()))
	var closed = _projection_port.close(presentation_id)
	if not ProjectionContracts.validate_projection_result(closed)["valid"] or not closed["accepted"]:
		return _result(false, "PORT_CLOSE_REFUSED")
	_execution["pending_player_input"] = null
	if command["kind"] in ["SELECT_CHOICE", "WITHDRAW"]:
		_consume_choice_selection(selected_choice_context)
	elif current_beat()["type"] == "RETURN":
		_complete_execution()
	else:
		_advance_to(current_beat()["next"]["beat_id"])
	if not _execution_valid():
		return _result(false, "INVALID_EXECUTION_TRANSITION")
	return _result(true, null, submitted["idempotent"], {"port_result": submitted})


func commit_resolution(context) -> Dictionary:
	if not _started:
		return _result(false, "NOT_STARTED")
	if typeof(context) != TYPE_DICTIONARY:
		return _result(false, "INVALID_RESOLUTION_CONTEXT")
	if _execution.get("durable_commit_status") in ["APPLIED", "IDEMPOTENT"]:
		var committed_envelope := _envelope_from_selection()
		if context.has("sequence_resolution") and context["sequence_resolution"] != committed_envelope:
			return _result(false, "DIVERGENT_COMMIT")
		return _result(true, null, true, {"sequence_resolution": committed_envelope})
	if _execution["execution_status"] != "RESOLUTION_READY":
		return _result(false, "RESOLUTION_NOT_READY")
	var built := ResolutionEnvelope.create(_authored_sequence, _execution)
	if not built["ok"]:
		return _result(false, built["error_code"])
	var envelope: Dictionary = built["envelope"]
	if context.has("sequence_resolution") and context["sequence_resolution"] != envelope:
		return _result(false, "DIVERGENT_COMMIT")
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
	var authored_resolution: Dictionary = _authored_sequence["resolutions"][envelope["resolution_id"]]
	var next_beat_id = authored_resolution["next_beat_id"]
	if next_beat_id == null:
		_complete_execution()
	else:
		var next_beat := _beat_by_id(next_beat_id)
		_execution["checkpoint_id"] = next_beat["checkpoint_before"]
		if next_beat["checkpoint_before"] != null:
			_reach_checkpoint(next_beat["checkpoint_before"])
		_execution["current_beat_id"] = next_beat_id
		_execution["execution_status"] = "RESOLVED_RETURN_PENDING"
		_execution["scheduled_returns"] = [{
			"beat_id": next_beat_id,
			"resolution_id": envelope["resolution_id"],
			"presentation_id": _presentation_id_for_beat(next_beat),
		}]
	if not _execution_valid():
		return _result(false, "INVALID_EXECUTION_TRANSITION")
	return _result(
		true,
		null,
		resolution_result["transaction_status"] == "IDEMPOTENT",
		{"sequence_resolution": envelope, "a10_result": resolution_result},
	)


func snapshot() -> Dictionary:
	if not _started:
		return _result(false, "NOT_STARTED")
	var built := RuntimeSnapshot.create(
		_facade, _projection_port, _authored_sequence, _execution
	)
	if not built["ok"]:
		return _result(false, built["error_code"])
	return _result(true, null, false, {"snapshot": built["snapshot"]})


func _projection_request(beat: Dictionary) -> Dictionary:
	return {
		"instance_id": _execution["instance_id"],
		"sequence_id": _authored_sequence["sequence_id"],
		"authored_version": _authored_sequence["authored_version"],
		"beat_id": beat["beat_id"],
		"beat_type": beat["type"],
		"projection_target": beat["projection_target"],
		"presentation_state": [],
	}


func _advance_to(beat_id) -> void:
	var beat := _beat_by_id(beat_id)
	_execution["current_beat_id"] = beat_id
	_execution["checkpoint_id"] = beat["checkpoint_before"]
	if beat["checkpoint_before"] != null:
		_reach_checkpoint(beat["checkpoint_before"])
	_execution["execution_status"] = "ACTIVE"


func _complete_execution() -> void:
	_execution["execution_status"] = "COMPLETE"
	_execution["checkpoint_id"] = null
	_execution["current_beat_id"] = null
	_execution["pending_player_input"] = null
	_execution["scheduled_returns"] = []


func _reach_checkpoint(checkpoint) -> void:
	_execution["checkpoint_id"] = checkpoint
	if checkpoint != null and checkpoint not in _execution["reached_checkpoint_ids"]:
		_execution["reached_checkpoint_ids"].append(checkpoint)


func _beat_by_id(beat_id) -> Dictionary:
	for beat in _authored_sequence.get("beats", []):
		if beat.get("beat_id") == beat_id:
			return beat
	return {}


func _choice_by_id(beat: Dictionary, choice_id: String) -> Dictionary:
	if beat.get("type") != "CHOICE":
		return {}
	for choice in beat["content"]["choices"]:
		if choice["choice_id"] == choice_id:
			return choice
	return {}


func _choice_with_owner_by_id(choice_id: String) -> Dictionary:
	for beat in _authored_sequence["beats"]:
		var choice := _choice_by_id(beat, choice_id)
		if not choice.is_empty():
			return {"choice": choice, "owner_beat": beat}
	return {}


func _consume_choice_selection(choice_context: Dictionary) -> void:
	var choice: Dictionary = choice_context["choice"]
	var owner_beat: Dictionary = choice_context["owner_beat"]
	if choice["choice_id"] not in _execution["consumed_choice_ids"]:
		_execution["consumed_choice_ids"].append(choice["choice_id"])
	_execution["current_beat_id"] = owner_beat["beat_id"]
	_reach_checkpoint(owner_beat["checkpoint_after"])
	var resolution: Dictionary = _authored_sequence["resolutions"][choice["resolution_id"]]
	if resolution["a10_resolution_id"] != null:
		_execution["selected_resolution_id"] = resolution["resolution_id"]
		_execution["execution_status"] = "RESOLUTION_READY"
	else:
		_advance_to(choice["next_beat_id"])


func _is_consumed_withdrawal_replay(command: Dictionary) -> bool:
	if command["kind"] != "WITHDRAW" or _execution["execution_status"] != "RESOLUTION_READY":
		return false
	var physical_beat := _beat_by_id(command["beat_id"])
	if (
		physical_beat.is_empty()
		or physical_beat["type"] != "PHYSICAL_BEAT"
		or command["choice_id"] not in physical_beat["content"]["withdrawal_choice_ids"]
	):
		return false
	var choice_context := _choice_with_owner_by_id(command["choice_id"])
	if choice_context.is_empty() or choice_context["owner_beat"]["beat_id"] != _execution["current_beat_id"]:
		return false
	var resolution: Dictionary = _authored_sequence["resolutions"][choice_context["choice"]["resolution_id"]]
	return resolution["resolution_id"] == _execution["selected_resolution_id"]


func _presentation_id_for_beat(beat: Dictionary) -> String:
	return "%s__%s__%s" % [
		_execution["instance_id"], beat["beat_id"], beat["projection_target"],
	]


func _envelope_from_selection() -> Dictionary:
	if not _authored_sequence.get("resolutions", {}).has(_execution.get("selected_resolution_id")):
		return {}
	var resolution: Dictionary = _authored_sequence["resolutions"][_execution["selected_resolution_id"]]
	var event_keys: Array = []
	for event_ref in resolution["event_refs"]:
		event_keys.append(event_ref["event_key"])
	return {
		"instance_id": _execution["instance_id"],
		"sequence_id": _authored_sequence["sequence_id"],
		"authored_version": _authored_sequence["authored_version"],
		"choice_id": resolution["choice_id"],
		"resolution_id": resolution["resolution_id"],
		"a10_choice_id": resolution["a10_choice_id"],
		"a10_resolution_id": resolution["a10_resolution_id"],
		"terminal_checkpoint_id": resolution["terminal_checkpoint_id"],
		"event_keys": event_keys,
	}


func _execution_valid() -> bool:
	return SequenceExecution.validate(_execution, _authored_sequence)["valid"]


static func _validate_dependencies(facade, projection_port) -> String:
	if facade == null or typeof(facade) != TYPE_OBJECT:
		return "INVALID_A10_FACADE"
	for method_name in ["resolve_scene", "save_state", "restore_state"]:
		if not facade.has_method(method_name):
			return "INVALID_A10_FACADE"
	if projection_port == null or typeof(projection_port) != TYPE_OBJECT:
		return "INVALID_PROJECTION_PORT"
	for method_name in ProjectionPort.METHOD_NAMES:
		if not projection_port.has_method(method_name):
			return "INVALID_PROJECTION_PORT"
	return ""


static func _validate_activation(facade, authored_sequence: Dictionary, receipt) -> String:
	if typeof(receipt) != TYPE_DICTIONARY or not receipt.get("ok", false):
		return "ACTIVATION_REQUIRED"
	if receipt.get("activation_state") != "PROPOSED" or receipt.get("scene_state") != "PROPOSED":
		return "ACTIVATION_NOT_PROPOSED"
	for field in ["instance_id", "option_id", "window"]:
		if not receipt.has(field):
			return "INVALID_ACTIVATION_RECEIPT"
	var window = receipt["window"]
	if (
		typeof(window) != TYPE_DICTIONARY
		or window.get("state") != "CLOSED"
		or window.get("selected_option_id") != receipt["option_id"]
	):
		return "INVALID_ACTIVATION_RECEIPT"
	var a6_entry: Dictionary = authored_sequence["orchestration"]["a6_entry"]
	var selected_option := {}
	for option in window.get("options", []):
		if option.get("option_id") == receipt["option_id"]:
			selected_option = option
			break
	if (
		selected_option.is_empty()
		or selected_option.get("instance_id") != receipt["instance_id"]
		or selected_option.get("scene_definition_id") != a6_entry["scene_definition_id"]
		or selected_option.get("variant_id") != a6_entry["variant_id"]
		or selected_option.get("state") != "PROPOSED"
		or not selected_option.get("materialized", false)
	):
		return "ACTIVATION_AUTHORED_MISMATCH"
	var domain = facade.save_state()
	if typeof(domain) != TYPE_DICTIONARY or typeof(domain.get("scene_registry")) != TYPE_ARRAY:
		return "INVALID_A10_STATE"
	var matching := []
	for instance in domain["scene_registry"]:
		if typeof(instance) == TYPE_DICTIONARY and instance.get("instance_id") == receipt["instance_id"]:
			matching.append(instance)
	if (
		matching.size() != 1
		or matching[0].get("state") != "PROPOSED"
		or matching[0].get("scene_definition_id") != a6_entry["scene_definition_id"]
	):
		return "ACTIVATION_DOMAIN_MISMATCH"
	return ""


static func _creation_failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "executor": null}


func _result(
	ok: bool,
	error_code = null,
	idempotent := false,
	payload: Dictionary = {},
) -> Dictionary:
	return {
		"ok": ok,
		"error_code": error_code,
		"idempotent": idempotent,
		"execution": _execution.duplicate(true),
		"payload": payload.duplicate(true),
	}
