extends Node

const AuthoredContract := preload("res://scripts/unified_runtime/contracts/AuthoredSequenceV1.gd")
const AuthoredValidator := preload("res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd")
const ProjectionContracts := preload("res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd")
const ProjectionPort := preload("res://scripts/unified_runtime/contracts/PlayerProjectionPort.gd")
const ResolutionEnvelope := preload("res://scripts/unified_runtime/execution/SequenceResolutionEnvelopeV1.gd")
const RuntimeSnapshot := preload("res://scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd")
const SequenceExecutor := preload("res://scripts/unified_runtime/execution/SequenceExecutor.gd")
const FacadeModel := preload("res://scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
const LibraryModel := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const NarrativeStateModel := preload("res://scripts/narrative_state/EtatNarratif.gd")

const FIXTURE_PATH := "res://tests/fixtures/unified_runtime/n13_a10_durable_integration_valid.json"
const INSTANCE_ID := "synthetic_n13_instance"
const EXPECTED_BEAT_TYPES := [
	"MESSAGE", "TRANSITION", "PHYSICAL_BEAT", "MEDIA_REVEAL", "AFTERCARE", "CHOICE", "RETURN",
]

var failures: Array[String] = []
var controls := 0


class FakeProjectionPort extends ProjectionPort:
	var open_requests: Array = []
	var receipts: Array = []
	var beat_types_seen: Array = []
	var unsupported_target := ""
	var reject_restore_after_mutation_once := false
	var restore_mutation_observed := false
	var target_port_state_observed_before_refusal := false
	var target_domain_observed_before_refusal := false
	var facade_to_observe
	var expected_domain_during_refusal: Dictionary = {}

	func supports_projection(projection_target: String) -> Dictionary:
		var supported: bool = (
			projection_target in AuthoredContract.PROJECTION_TARGETS
			and projection_target != unsupported_target
		)
		return {
			"supported": supported,
			"error_code": null if supported else "UNSUPPORTED_PROJECTION",
		}

	func open(request: Dictionary) -> Dictionary:
		if not ProjectionContracts.validate_projection_request(request)["valid"]:
			return _error_result(request.get("projection_target", "NONE"), "INVALID_REQUEST")
		var presentation_id := ProjectionContracts.presentation_id_for(request)
		for existing in open_requests:
			if ProjectionContracts.presentation_id_for(existing) == presentation_id:
				return _accepted_result(request["projection_target"], presentation_id, true)
		if not open_requests.is_empty():
			return _error_result(request["projection_target"], "PROJECTION_ALREADY_OPEN")
		open_requests.append(request.duplicate(true))
		if request["beat_type"] not in beat_types_seen:
			beat_types_seen.append(request["beat_type"])
		return _accepted_result(request["projection_target"], presentation_id, false)

	func submit(command: Dictionary) -> Dictionary:
		if not ProjectionContracts.validate_projection_command(command)["valid"]:
			return _error_result("NONE", "INVALID_COMMAND")
		for request in open_requests:
			if request["instance_id"] == command["instance_id"] and request["beat_id"] == command["beat_id"]:
				return _accepted_result(
					request["projection_target"], ProjectionContracts.presentation_id_for(request), false
				)
		return _error_result("NONE", "PROJECTION_NOT_OPEN")

	func acknowledge(receipt: Dictionary) -> Dictionary:
		if not ProjectionContracts.validate_presentation_receipt(receipt)["valid"]:
			return _error_result("NONE", "INVALID_RECEIPT")
		var request := _request_for(receipt["presentation_id"])
		if request.is_empty():
			return _error_result("NONE", "RECEIPT_WITHOUT_OPEN")
		if not ProjectionContracts.validate_receipt_against_request(receipt, request)["valid"]:
			return _error_result(request["projection_target"], "RECEIPT_IDENTITY_MISMATCH")
		for existing in receipts:
			if existing == receipt:
				return _accepted_result(request["projection_target"], receipt["presentation_id"], true)
		receipts.append(receipt.duplicate(true))
		return _accepted_result(request["projection_target"], receipt["presentation_id"], false)

	func snapshot() -> Dictionary:
		var data := {
			"snapshot_version": 1,
			"open_requests": open_requests.duplicate(true),
			"receipts": receipts.duplicate(true),
		}
		return {"accepted": true, "snapshot": data, "error_code": null}

	func restore(snapshot_data: Dictionary) -> Dictionary:
		if not ProjectionContracts.validate_port_snapshot(snapshot_data)["valid"]:
			return {"accepted": false, "error_code": "INVALID_SNAPSHOT"}
		open_requests = snapshot_data["open_requests"].duplicate(true)
		receipts = snapshot_data["receipts"].duplicate(true)
		if reject_restore_after_mutation_once:
			reject_restore_after_mutation_once = false
			restore_mutation_observed = true
			target_port_state_observed_before_refusal = (
				open_requests == snapshot_data["open_requests"]
				and receipts == snapshot_data["receipts"]
			)
			target_domain_observed_before_refusal = (
				facade_to_observe != null
				and facade_to_observe.save_state() == expected_domain_during_refusal
			)
			return {"accepted": false, "error_code": "TEST_LATE_RESTORE_REFUSAL"}
		return {"accepted": true, "error_code": null}

	func close(presentation_id: String) -> Dictionary:
		for index in open_requests.size():
			var request: Dictionary = open_requests[index]
			if ProjectionContracts.presentation_id_for(request) != presentation_id:
				continue
			open_requests.remove_at(index)
			for receipt_index in range(receipts.size() - 1, -1, -1):
				if receipts[receipt_index]["presentation_id"] == presentation_id:
					receipts.remove_at(receipt_index)
			return _accepted_result(request["projection_target"], presentation_id, false)
		return _error_result("NONE", "PROJECTION_NOT_OPEN")

	func _request_for(presentation_id: String) -> Dictionary:
		for request in open_requests:
			if ProjectionContracts.presentation_id_for(request) == presentation_id:
				return request
		return {}

	func _accepted_result(target: String, presentation_id: String, idempotent: bool) -> Dictionary:
		return {
			"accepted": true,
			"idempotent": idempotent,
			"projection_target": target,
			"presentation_id": presentation_id,
			"payload": {},
			"next_command_kinds": ["CONTINUE", "SELECT_CHOICE"],
			"error_code": null,
		}

	func _error_result(target: String, error_code: String) -> Dictionary:
		return {
			"accepted": false,
			"idempotent": false,
			"projection_target": target if target in AuthoredContract.PROJECTION_TARGETS else "NONE",
			"presentation_id": null,
			"payload": {},
			"next_command_kinds": [],
			"error_code": error_code,
		}


class RealIdempotentFacadeProxy extends RefCounted:
	var delegate
	var first_resolution_result: Dictionary = {}
	var second_resolution_result: Dictionary = {}

	func _init(real_facade) -> void:
		delegate = real_facade

	func save_state() -> Dictionary:
		return delegate.save_state()

	func restore_state(snapshot) -> Dictionary:
		return delegate.restore_state(snapshot)

	func resolve_scene(
		instance_id: String,
		choice_id: String,
		resolution_id: String,
		context: Dictionary
	) -> Dictionary:
		first_resolution_result = delegate.resolve_scene(
			instance_id, choice_id, resolution_id, context.duplicate(true)
		)
		second_resolution_result = delegate.resolve_scene(
			instance_id, choice_id, resolution_id, context.duplicate(true)
		)
		return second_resolution_result.duplicate(true)


func _ready() -> void:
	_run()
	_finish()


func _run() -> void:
	var sequence := _load_sequence()
	var fixture_validation: Dictionary = AuthoredValidator.validate(sequence)
	if not fixture_validation["valid"]:
		print("R8C_N13_FIXTURE_ERRORS: ", fixture_validation["errors"])
	_expect(fixture_validation["valid"], "fixture N13 authored valide")
	_expect(_closed_fixture_effects(sequence), "fixture sans effets N14")
	var continuous := _run_complete(sequence, false)
	var restored := _run_complete(sequence, true)
	_expect(not continuous.is_empty(), "flux continu termine")
	_expect(not restored.is_empty(), "flux restaure trois fois termine")
	if not continuous.is_empty() and not restored.is_empty():
		_expect(continuous["execution"] == restored["execution"], "execution finale identique")
		_expect(continuous["domain"] == restored["domain"], "domaine final identique")
		_expect(continuous["port_snapshot"] == restored["port_snapshot"], "port final identique")
		_expect(continuous["port"].beat_types_seen == EXPECTED_BEAT_TYPES, "sept types projetes")
		_expect(_count_relation_fact(continuous["domain"]) == 1, "fait relationnel durable unique")
		_expect(_count_resolution_events(continuous["domain"]) == 1, "evenement A1 durable unique")
	_test_transactional_restore_rollback(sequence)
	_test_real_a10_idempotence(sequence)
	_test_executor_receives_real_a10_idempotence(sequence)
	_test_negative_cases(sequence)


func _run_complete(sequence: Dictionary, with_restores: bool) -> Dictionary:
	var environment := _activated_environment(sequence)
	if environment.is_empty():
		return {}
	var created := SequenceExecutor.create(
		environment["facade"], environment["port"], sequence, environment["activation"]
	)
	if not created["ok"]:
		return {}
	var executor = created["executor"]
	if not executor.start()["ok"]:
		return {}

	while executor.current_beat().get("type") != "CHOICE":
		if not _present_and_command(executor, null):
			return {}
	if not _open_and_ack(executor):
		return {}
	if with_restores:
		var first := _restore_executor(sequence, executor.snapshot()["payload"]["snapshot"])
		if first.is_empty():
			return {}
		environment = first
		executor = first["executor"]
		_expect(executor.execution_state()["execution_status"] == "WAITING_FOR_PLAYER", "reprise avant choix")

	var choice_command := _command_for(executor, "SELECT_CHOICE", "choice_finish")
	if not executor.receive_command(choice_command)["ok"]:
		return {}
	if with_restores:
		var second := _restore_executor(sequence, executor.snapshot()["payload"]["snapshot"])
		if second.is_empty():
			return {}
		environment = second
		executor = second["executor"]
		_expect(executor.execution_state()["execution_status"] == "RESOLUTION_READY", "reprise apres choix")

	var committed: Dictionary = executor.commit_resolution(_context())
	if not committed["ok"]:
		return {}
	_expect(committed["payload"]["a10_result"]["transaction_status"] == "APPLIQUE", "commit A10 applique")
	_expect(committed["payload"]["sequence_resolution"]["resolution_id"] == "resolution_complete", "resolution authored conservee")
	_expect(committed["payload"]["sequence_resolution"]["a10_resolution_id"] == "a10_resolution_commit", "resolution A10 explicite")
	if with_restores:
		var third := _restore_executor(sequence, executor.snapshot()["payload"]["snapshot"])
		if third.is_empty():
			return {}
		environment = third
		executor = third["executor"]
		_expect(executor.execution_state()["execution_status"] == "RESOLVED_RETURN_PENDING", "reprise apres commit")

	if not _present_and_command(executor, null):
		return {}
	_expect(executor.execution_state()["execution_status"] == "COMPLETE", "execution complete")
	var port_snapshot: Dictionary = environment["port"].snapshot()["snapshot"]
	return {
		"execution": executor.execution_state(),
		"domain": environment["facade"].save_state(),
		"port_snapshot": port_snapshot,
		"port": environment["port"],
	}


func _test_transactional_restore_rollback(sequence: Dictionary) -> void:
	var target_environment := _executor_waiting_for_choice(sequence)
	if target_environment.is_empty():
		_expect(false, "snapshot cible valide pour refus tardif cree")
		return
	var target_result: Dictionary = target_environment["executor"].snapshot()
	if not target_result["ok"]:
		_expect(false, "snapshot cible valide pour refus tardif capture")
		return
	var target_snapshot: Dictionary = target_result["payload"]["snapshot"]
	var destination := _new_graph(sequence)
	var initial_domain: Dictionary = destination["facade"].save_state().duplicate(true)
	var initial_port_result: Dictionary = destination["port"].snapshot()
	var initial_port: Dictionary = initial_port_result["snapshot"].duplicate(true)
	_expect(initial_domain != target_snapshot["domain"], "domaine initial distinct de la cible")
	_expect(initial_port != target_snapshot["projection_port"], "port initial distinct de la cible")

	var late_refusal_port: FakeProjectionPort = destination["port"]
	late_refusal_port.facade_to_observe = destination["facade"]
	late_refusal_port.expected_domain_during_refusal = target_snapshot["domain"].duplicate(true)
	late_refusal_port.reject_restore_after_mutation_once = true
	var restored: Dictionary = SequenceExecutor.restore(
		destination["facade"], late_refusal_port, sequence, target_snapshot
	)
	_expect(not restored["ok"] and restored["error_code"] == "PORT_RESTORE_REFUSED", "refus tardif port conserve")
	_expect(restored["executor"] == null, "aucun executeur publie apres refus tardif")
	_expect(late_refusal_port.restore_mutation_observed, "faux port mute avant refus")
	_expect(
		late_refusal_port.target_port_state_observed_before_refusal,
		"snapshot port cible observe avant refus",
	)
	_expect(
		late_refusal_port.target_domain_observed_before_refusal,
		"domaine cible restaure avant refus du port",
	)
	_expect(destination["facade"].save_state() == initial_domain, "rollback domaine initial exact")
	var current_port_result: Dictionary = late_refusal_port.snapshot()
	_expect(current_port_result["accepted"], "snapshot port accepte apres rollback")
	_expect(current_port_result["snapshot"] == initial_port, "rollback port initial exact")


func _test_real_a10_idempotence(sequence: Dictionary) -> void:
	var environment := _activated_environment(sequence)
	if environment.is_empty():
		_expect(false, "environnement rejeu A10 direct cree")
		return
	var resolution_context := _context()
	var first: Dictionary = environment["facade"].resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", resolution_context
	)
	var after_first: Dictionary = environment["facade"].save_state()
	var second: Dictionary = environment["facade"].resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", resolution_context
	)
	var after_second: Dictionary = environment["facade"].save_state()
	_expect(first["ok"] and first["transaction_status"] == "APPLIQUE", "A10 direct applique au premier passage")
	_expect(
		second["ok"] and second["transaction_status"] == "IDEMPOTENT" and second["idempotent"],
		"A10 direct retourne un vrai IDEMPOTENT",
	)
	_expect(after_second == after_first, "rejeu A10 direct sans seconde mutation")
	_expect(_count_relation_fact(after_second) == 1, "rejeu A10 direct conserve un fait")
	_expect(_count_resolution_events(after_second) == 1, "rejeu A10 direct conserve un evenement")


func _test_executor_receives_real_a10_idempotence(sequence: Dictionary) -> void:
	var environment := _activated_environment(sequence)
	if environment.is_empty():
		_expect(false, "environnement proxy A10 cree")
		return
	var proxy := RealIdempotentFacadeProxy.new(environment["facade"])
	var created := SequenceExecutor.create(proxy, environment["port"], sequence, environment["activation"])
	if not created["ok"]:
		_expect(false, "executeur proxy A10 cree")
		return
	var executor = created["executor"]
	if not executor.start()["ok"]:
		_expect(false, "executeur proxy A10 demarre")
		return
	while executor.current_beat().get("type") != "CHOICE":
		if not _present_and_command(executor, null):
			_expect(false, "executeur proxy atteint le choix")
			return
	if not _open_and_ack(executor):
		_expect(false, "choix proxy presente")
		return
	if not executor.receive_command(_command_for(executor, "SELECT_CHOICE", "choice_finish"))["ok"]:
		_expect(false, "choix proxy consomme")
		return
	var committed: Dictionary = executor.commit_resolution(_context())
	_expect(proxy.first_resolution_result.get("transaction_status") == "APPLIQUE", "proxy observe APPLIQUE reel")
	_expect(proxy.second_resolution_result.get("transaction_status") == "IDEMPOTENT", "proxy observe IDEMPOTENT reel")
	_expect(committed["ok"] and committed["idempotent"], "executeur accepte IDEMPOTENT reel")
	_expect(
		committed.get("payload", {}).get("a10_result", {}).get("transaction_status") == "IDEMPOTENT",
		"resultat executeur expose IDEMPOTENT A10",
	)
	_expect(
		executor.execution_state()["durable_commit_status"] == "IDEMPOTENT",
		"execution enregistre IDEMPOTENT",
	)
	var committed_domain: Dictionary = proxy.save_state()
	_expect(_count_relation_fact(committed_domain) == 1, "proxy produit un seul fait durable")
	_expect(_count_resolution_events(committed_domain) == 1, "proxy produit un seul evenement durable")
	_expect(_present_and_command(executor, null), "retour apres IDEMPOTENT progresse")
	_expect(executor.execution_state()["execution_status"] == "COMPLETE", "sequence IDEMPOTENT complete")


func _test_negative_cases(sequence: Dictionary) -> void:
	var invalid_authored := sequence.duplicate(true)
	invalid_authored["unknown"] = true
	var base := _activated_environment(sequence)
	if base.is_empty():
		_expect(false, "environnement negatif active cree")
		return
	_expect(
		not SequenceExecutor.create(base["facade"], base["port"], invalid_authored, base["activation"])["ok"],
		"fixture authored invalide refusee",
	)
	_expect(
		not SequenceExecutor.create(base["facade"], base["port"], sequence, null)["ok"],
		"activation absente refusee",
	)
	var reserved: Dictionary = base["activation"].duplicate(true)
	reserved["activation_state"] = "RESERVED"
	_expect(
		not SequenceExecutor.create(base["facade"], base["port"], sequence, reserved)["ok"],
		"activation non proposee refusee",
	)

	var ready := _executor_waiting_for_choice(sequence)
	if ready.is_empty():
		_expect(false, "environnement negatif choix cree")
		return
	var executor = ready["executor"]
	var before_unknown: Dictionary = executor.execution_state()
	var unknown := _command_for(executor, "SELECT_CHOICE", "choice_unknown")
	_expect(not executor.receive_command(unknown)["ok"], "choix inconnu refuse")
	_expect(executor.execution_state() == before_unknown, "choix inconnu sans mutation")
	var valid_command := _command_for(executor, "SELECT_CHOICE", "choice_finish")
	_expect(executor.receive_command(valid_command)["ok"], "choix valide consomme")
	var after_choice: Dictionary = executor.execution_state()
	var replay_choice: Dictionary = executor.receive_command(valid_command)
	_expect(replay_choice["ok"] and replay_choice["idempotent"], "double choix identique idempotent")
	_expect(executor.execution_state() == after_choice, "double choix sans mutation")

	var envelope: Dictionary = ResolutionEnvelope.create(sequence, executor.execution_state())["envelope"]
	for field in ["a10_choice_id", "a10_resolution_id"]:
		var divergent: Dictionary = envelope.duplicate(true)
		divergent[field] = "foreign_identifier"
		_expect(
			not ResolutionEnvelope.validate(divergent, sequence, executor.execution_state())["valid"],
			"mauvais %s refuse" % field,
		)
	var mismapped := envelope.duplicate(true)
	mismapped["resolution_id"] = "foreign_resolution"
	_expect(
		not ResolutionEnvelope.validate(mismapped, sequence, executor.execution_state())["valid"],
		"mapping authored A10 incoherent refuse",
	)
	var incompatible_sequence := sequence.duplicate(true)
	var incompatible_definition: Dictionary = incompatible_sequence["orchestration"]["a6_entry"]["definition"]
	var other_resolution: Dictionary = incompatible_definition["resolutions"]["a10_resolution_commit"].duplicate(true)
	other_resolution["signal_recu"] = "SYNTHETIC_N13_OTHER_SIGNAL"
	incompatible_definition["resolutions"]["a10_resolution_other"] = other_resolution
	incompatible_definition["choix"].append({
		"choix_id": "a10_choice_other",
		"formulation": "Synthetic N13 other choice",
		"signal_emis": "SYNTHETIC_N13_OTHER_SIGNAL",
		"resolution_ids": ["a10_resolution_other"],
	})
	incompatible_sequence["resolutions"]["resolution_complete"]["a10_choice_id"] = "a10_choice_other"
	incompatible_sequence["resolutions"]["resolution_complete"]["a10_resolution_id"] = "a10_resolution_commit"
	_expect(
		incompatible_definition["resolutions"].has("a10_resolution_commit")
		and incompatible_definition["resolutions"].has("a10_resolution_other"),
		"deux resolutions A10 existantes pour mapping incompatible",
	)
	_expect(
		incompatible_definition["choix"][0]["resolution_ids"] == ["a10_resolution_commit"]
		and incompatible_definition["choix"][1]["resolution_ids"] == ["a10_resolution_other"],
		"deux couples A10 individuellement valides",
	)
	var incompatible_validation: Dictionary = AuthoredValidator.validate(incompatible_sequence)
	_expect(
		not incompatible_validation["valid"]
		and _errors_contain_code(incompatible_validation["errors"], "a10_resolution_choice_mismatch"),
		"a10_resolution_choice_mismatch avec identifiants existants",
	)

	var commit: Dictionary = executor.commit_resolution(_context())
	_expect(commit["ok"], "commit negatif de reference applique")
	var domain_after_commit: Dictionary = ready["facade"].save_state()
	var replay_commit: Dictionary = executor.commit_resolution(_context())
	_expect(replay_commit["ok"] and replay_commit["idempotent"], "double commit identique idempotent")
	_expect(ready["facade"].save_state() == domain_after_commit, "double commit sans effet")
	var divergent_context := _context()
	var bad_envelope: Dictionary = replay_commit["payload"]["sequence_resolution"].duplicate(true)
	bad_envelope["choice_id"] = "foreign_choice"
	divergent_context["sequence_resolution"] = bad_envelope
	_expect(executor.commit_resolution(divergent_context)["error_code"] == "DIVERGENT_COMMIT", "double commit divergent refuse")
	_expect(ready["facade"].save_state() == domain_after_commit, "commit divergent sans effet")

	var foreign_env := _activated_environment(sequence)
	var foreign_created := SequenceExecutor.create(
		foreign_env["facade"], foreign_env["port"], sequence, foreign_env["activation"]
	)
	var foreign_executor = foreign_created["executor"]
	foreign_executor.start()
	var opened: Dictionary = foreign_executor.open_current_projection()
	var foreign_receipt := _receipt_for(opened["payload"]["request"])
	foreign_receipt["instance_id"] = "foreign_instance"
	var before_receipt: Dictionary = foreign_executor.execution_state()
	_expect(not foreign_executor.receive_ack(foreign_receipt)["ok"], "accuse etranger refuse")
	_expect(foreign_executor.execution_state() == before_receipt, "accuse etranger sans mutation")

	var unsupported_env := _activated_environment(sequence)
	unsupported_env["port"].unsupported_target = "MESSAGES"
	var unsupported_created := SequenceExecutor.create(
		unsupported_env["facade"], unsupported_env["port"], sequence, unsupported_env["activation"]
	)
	var unsupported_executor = unsupported_created["executor"]
	unsupported_executor.start()
	_expect(unsupported_executor.open_current_projection()["error_code"] == "UNSUPPORTED_PROJECTION", "projection non supportee refusee")

	var snapshot_result: Dictionary = executor.snapshot()
	var snapshot: Dictionary = snapshot_result["payload"]["snapshot"]
	var wrong_namespace := snapshot.duplicate(true)
	wrong_namespace["schema_id"] = "foreign.runtime"
	_expect(not RuntimeSnapshot.validate(wrong_namespace, sequence)["valid"], "namespace etranger refuse")
	var wrong_sequence := snapshot.duplicate(true)
	wrong_sequence["sequence_id"] = "foreign_sequence"
	_expect(not RuntimeSnapshot.validate(wrong_sequence, sequence)["valid"], "snapshot autre sequence refuse")
	var wrong_port := snapshot.duplicate(true)
	wrong_port["projection_port"]["open_requests"] = []
	wrong_port["projection_port"]["receipts"] = [_receipt_for({
		"instance_id": INSTANCE_ID,
		"sequence_id": sequence["sequence_id"],
		"authored_version": sequence["authored_version"],
		"beat_id": "beat_return",
		"beat_type": "RETURN",
		"projection_target": "MESSAGES",
		"presentation_state": [],
	})]
	_expect(not RuntimeSnapshot.validate(wrong_port, sequence)["valid"], "snapshot port incoherent refuse")

	var restore_graph := _new_graph(sequence)
	var pristine: Dictionary = restore_graph["facade"].save_state()
	_expect(
		not SequenceExecutor.restore(restore_graph["facade"], restore_graph["port"], {}, snapshot)["ok"],
		"restauration sans fixture refusee",
	)
	_expect(restore_graph["facade"].save_state() == pristine, "restauration invalide sans mutation")

	while executor.execution_state()["execution_status"] != "COMPLETE":
		if not _present_and_command(executor, null):
			break
	_expect(executor.execution_state()["execution_status"] == "COMPLETE", "execution negative terminee")
	_expect(executor.open_current_projection()["error_code"] == "EXECUTION_COMPLETE", "progression apres complete refusee")


func _executor_waiting_for_choice(sequence: Dictionary) -> Dictionary:
	var environment := _activated_environment(sequence)
	var created := SequenceExecutor.create(
		environment["facade"], environment["port"], sequence, environment["activation"]
	)
	if not created["ok"]:
		return {}
	var executor = created["executor"]
	executor.start()
	while executor.current_beat().get("type") != "CHOICE":
		if not _present_and_command(executor, null):
			return {}
	if not _open_and_ack(executor):
		return {}
	environment["executor"] = executor
	return environment


func _present_and_command(executor, choice_id) -> bool:
	if not _open_and_ack(executor):
		return false
	var kind := "SELECT_CHOICE" if executor.current_beat()["type"] == "CHOICE" else "CONTINUE"
	return executor.receive_command(_command_for(executor, kind, choice_id))["ok"]


func _open_and_ack(executor) -> bool:
	var opened: Dictionary = executor.open_current_projection()
	if not opened["ok"]:
		return false
	var receipt := _receipt_for(opened["payload"]["request"])
	return executor.receive_ack(receipt)["ok"]


func _command_for(executor, kind: String, choice_id) -> Dictionary:
	var state: Dictionary = executor.execution_state()
	return {
		"command_id": "command_%s_%s" % [state["current_beat_id"], kind.to_lower()],
		"instance_id": state["instance_id"],
		"beat_id": state["current_beat_id"],
		"kind": kind,
		"choice_id": choice_id,
	}


func _receipt_for(request: Dictionary) -> Dictionary:
	return {
		"presentation_id": ProjectionContracts.presentation_id_for(request),
		"instance_id": request["instance_id"],
		"sequence_id": request["sequence_id"],
		"authored_version": request["authored_version"],
		"beat_id": request["beat_id"],
		"beat_type": request["beat_type"],
		"projection_target": request["projection_target"],
		"kind": "PRESENTED",
		"subject_id": request["beat_id"],
	}


func _restore_executor(sequence: Dictionary, snapshot: Dictionary) -> Dictionary:
	var graph := _new_graph(sequence)
	var restored := SequenceExecutor.restore(graph["facade"], graph["port"], sequence, snapshot)
	if not restored["ok"]:
		return {}
	graph["executor"] = restored["executor"]
	return graph


func _activated_environment(sequence: Dictionary) -> Dictionary:
	var graph := _new_graph(sequence)
	if graph.is_empty():
		return {}
	var candidates: Dictionary = graph["facade"].find_candidates(_context())
	if not candidates.get("ok", false) or candidates["candidats"].size() != 1:
		print("R8C_N13_CANDIDATES_ERROR: ", candidates)
		return {}
	var composition: Dictionary = graph["facade"].compose_slot(
		_slot_request(candidates["candidats"][0])
	)
	if not composition.get("ok", false):
		print("R8C_N13_COMPOSITION_ERROR: ", composition)
		return {}
	var activation: Dictionary = graph["facade"].activate_option(
		composition["plan"],
		"primary_option",
		{"intention": "PROPOSE", "context": _context()},
	)
	if not activation.get("ok", false):
		print("R8C_N13_ACTIVATION_ERROR: ", activation)
		return {}
	graph["activation"] = activation
	return graph


func _new_graph(sequence: Dictionary) -> Dictionary:
	var entry: Dictionary = sequence["orchestration"]["a6_entry"]
	var loaded := LibraryModel.charger_depuis_bundle({
		"format": "R8C_A6_SCENE_LIBRARY",
		"version": 1,
		"definitions": [entry.duplicate(true)],
	})
	if not loaded.get("ok", false):
		return {}
	var state = NarrativeStateModel.creer_synthetique({
		"statut_couple": "EN_CLARIFICATION",
		"contrat_couple": null,
		"etat_divulgation": "PARTIEL",
		"etat_foyer": null,
		"relation_apres_separation": null,
		"dernier_evenement_majeur_id": null,
		"faits": [],
		"cadre_provisoire": null,
	})
	var facade = FacadeModel.create(loaded["bibliotheque"], state)
	if facade == null:
		return {}
	return {"facade": facade, "port": FakeProjectionPort.new()}


func _slot_request(candidate: Dictionary) -> Dictionary:
	return {
		"slot_id": "synthetic_n13_slot",
		"narrative_date": "2032-03-04",
		"starts_at": "2032-03-04T10:30:00+01:00",
		"ends_at": "2032-03-04T11:00:00+01:00",
		"context": _context(),
		"window": {
			"window_id": "synthetic_n13_window",
			"opens_at": "2032-03-04T10:00:00+01:00",
			"closes_at": "2032-03-04T11:00:00+01:00",
			"duration_minutes": 20,
			"not_before": "2032-03-04T10:30:00+01:00",
			"not_after": "2032-03-04T11:00:00+01:00",
			"options": [
				{
					"option_id": "primary_option",
					"candidate": candidate.duplicate(true),
					"instance_id": INSTANCE_ID,
					"conflict_policy": "CLOSE_SILENTLY",
				},
				{
					"option_id": "alternative_option",
					"candidate": candidate.duplicate(true),
					"instance_id": "synthetic_n13_alternative_instance",
					"conflict_policy": "CLOSE_SILENTLY",
				},
			],
		},
	}


func _context() -> Dictionary:
	return {
		"acte_courant": "SYNTHETIC_TEST_ONLY",
		"moment_diegetique": "2032-03-04T10:30:00+01:00",
		"participants_disponibles": {"sandra": true},
		"opportunite_valide": true,
	}


func _load_sequence() -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(FIXTURE_PATH))
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	_restore_integer_types(parsed)
	return parsed


func _restore_integer_types(sequence: Dictionary) -> void:
	sequence["schema_version"] = int(sequence["schema_version"])
	var orchestration: Dictionary = sequence["orchestration"]
	orchestration["a6_entry"]["definition"]["contrat_temporel"]["duree_minutes"] = int(
		orchestration["a6_entry"]["definition"]["contrat_temporel"]["duree_minutes"]
	)
	orchestration["a9_slot"]["duration_minutes"] = int(orchestration["a9_slot"]["duration_minutes"])
	orchestration["a9_slot"]["relative_order"] = int(orchestration["a9_slot"]["relative_order"])
	sequence["temporal_projection"]["offset_minutes"] = int(sequence["temporal_projection"]["offset_minutes"])
	sequence["temporal_projection"]["relative_order"] = int(sequence["temporal_projection"]["relative_order"])
	for beat in sequence["beats"]:
		if beat["type"] == "MESSAGE":
			for message in beat["content"]["messages"]:
				message["relative_order"] = int(message["relative_order"])
		if beat["type"] == "RETURN":
			beat["content"]["delay"]["value"] = int(beat["content"]["delay"]["value"])


func _closed_fixture_effects(sequence: Dictionary) -> bool:
	for resolution in sequence["resolutions"].values():
		if (
			not resolution["event_refs"].is_empty()
			or not resolution["knowledge_ids"].is_empty()
			or not resolution["trace_ids"].is_empty()
			or not resolution["promise_effects"].is_empty()
			or not resolution["obligation_effects"].is_empty()
			or not resolution["consequence_ids"].is_empty()
			or not resolution["media_effects"].is_empty()
		):
			return false
	return true


func _count_relation_fact(domain: Dictionary) -> int:
	var count := 0
	for fact in domain["narrative_state"]["relations"]["sandra"]["faits"]:
		if fact.get("fait_id") == "synthetic_n13_relation_fact":
			count += 1
	return count


func _count_resolution_events(domain: Dictionary) -> int:
	var count := 0
	for event in domain["narrative_state"]["evenements"].values():
		if event.get("provenance", {}).get("source_scene_instance_id") == INSTANCE_ID:
			count += 1
	return count


func _errors_contain_code(errors: Array, code: String) -> bool:
	for error in errors:
		if str(error).ends_with(": " + code):
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	controls += 1
	if not condition:
		failures.append(message)


func _finish() -> void:
	if failures.is_empty():
		print("R8C_N13_MINIMAL_SEQUENCE_EXECUTOR: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error("R8C_N13: " + failure)
	get_tree().quit(1)
