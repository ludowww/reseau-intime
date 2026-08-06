extends Node

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)
const SequenceExecution := preload(
	"res://scripts/unified_runtime/contracts/SequenceExecutionV1.gd"
)
const ProjectionPort := preload(
	"res://scripts/unified_runtime/projection/MessagesPhysicalProjectionPort.gd"
)
const SequenceExecutor := preload(
	"res://scripts/unified_runtime/execution/SequenceExecutor.gd"
)
const FacadeModel := preload("res://scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
const LibraryModel := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const NarrativeStateModel := preload("res://scripts/narrative_state/EtatNarratif.gd")

const FIXTURE_PATH := "res://tests/fixtures/unified_runtime/n15_messages_physical_projection_valid.json"
const INSTANCE_ID := "synthetic_n15_instance"
const EXPECTED_COMMANDS := {
	"MESSAGE": ["CONTINUE"],
	"CHOICE": ["SELECT_CHOICE"],
	"TRANSITION": ["CONTINUE"],
	"PHYSICAL_BEAT": ["CONTINUE", "WITHDRAW"],
	"AFTERCARE": ["CONTINUE"],
	"RETURN": ["CONTINUE"],
}

var failures: Array[String] = []
var controls := 0


func _ready() -> void:
	var sequence := _load_sequence()
	_expect(AuthoredValidator.validate(sequence)["valid"], "fixture N15.1 authored valide")
	_test_port_contract(sequence)
	_test_snapshot_restore(sequence)
	_test_withdrawal_convergence(sequence)
	_finish()


func _test_port_contract(sequence: Dictionary) -> void:
	var expected_ids := {
		"MESSAGE": "beat_message",
		"CHOICE": "beat_choice",
		"TRANSITION": "beat_transition",
		"PHYSICAL_BEAT": "beat_physical",
		"AFTERCARE": "beat_aftercare",
		"RETURN": "beat_return",
	}
	for target in ["MESSAGES", "PHYSICAL"]:
		_expect(ProjectionPort.new(sequence).supports_projection(target)["supported"], "%s supporte" % target)
	for target in ["MEDIA", "GALLERY", "PHOTO_VIEWER", "NONE"]:
		var support: Dictionary = ProjectionPort.new(sequence).supports_projection(target)
		_expect(not support["supported"] and support["error_code"] == "UNSUPPORTED_PROJECTION", "%s refuse" % target)

	for beat_type in EXPECTED_COMMANDS:
		var port = ProjectionPort.new(sequence)
		var beat: Dictionary = _beat(sequence, expected_ids[beat_type])
		var request := _request(sequence, beat, "synthetic_n15_port_instance")
		var opened: Dictionary = port.open(request)
		_expect(opened["accepted"], "%s ouvert" % beat_type)
		_expect(opened["next_command_kinds"] == EXPECTED_COMMANDS[beat_type], "%s commandes fermees" % beat_type)
		_expect(_sorted_keys(opened["payload"]) == ["beat_type", "content", "participant_ids"], "%s payload minimal" % beat_type)
		_expect(opened["payload"]["beat_type"] == beat_type, "%s type projete" % beat_type)
		_expect(opened["payload"]["participant_ids"] == beat["participant_ids"], "%s participants copies" % beat_type)
		_expect(opened["payload"]["content"] == beat["content"], "%s contenu copie" % beat_type)
		var replay: Dictionary = port.open(request)
		_expect(replay["accepted"] and replay["idempotent"], "%s ouverture idempotente" % beat_type)
		var receipt := _receipt(request)
		_expect(port.acknowledge(receipt)["accepted"], "%s receipt accepte" % beat_type)
		var receipt_replay: Dictionary = port.acknowledge(receipt)
		_expect(receipt_replay["accepted"] and receipt_replay["idempotent"], "%s receipt idempotent" % beat_type)

	var message_port = ProjectionPort.new(sequence)
	var message_request := _request(sequence, _beat(sequence, "beat_message"), "synthetic_n15_payload_instance")
	var message_open: Dictionary = message_port.open(message_request)
	message_open["payload"]["content"]["messages"][0]["text"] = "mutated outside port"
	_expect(
		message_port.open(message_request)["payload"]["content"]["messages"][0]["text"]
		== _beat(sequence, "beat_message")["content"]["messages"][0]["text"],
		"contenu du payload est une copie profonde",
	)

	var negative_port = ProjectionPort.new(sequence)
	var negative_request := _request(sequence, _beat(sequence, "beat_message"), "synthetic_n15_negative_instance")
	negative_port.open(negative_request)
	var forbidden := _command(negative_request, "WITHDRAW", "choice_finish")
	_expect(negative_port.submit(forbidden)["error_code"] == "COMMAND_NOT_ALLOWED", "commande interdite refusee")
	var missing_choice := _command(negative_request, "WITHDRAW", null)
	_expect(negative_port.submit(missing_choice)["error_code"] == "INVALID_COMMAND", "WITHDRAW sans choice refuse")

	var physical_port = ProjectionPort.new(sequence)
	var physical_request := _request(sequence, _beat(sequence, "beat_physical"), "synthetic_n15_physical_negative")
	physical_port.open(physical_request)
	var wrong_withdrawal := _command(physical_request, "WITHDRAW", "choice_other")
	_expect(
		physical_port.submit(wrong_withdrawal)["error_code"] == "WITHDRAWAL_CHOICE_NOT_ALLOWED",
		"choice hors withdrawal_choice_ids refuse",
	)
	var valid_withdrawal := _command(physical_request, "WITHDRAW", "choice_finish")
	_expect(physical_port.submit(valid_withdrawal)["accepted"], "WITHDRAW physique autorise")

	var media_port = ProjectionPort.new(sequence)
	var media_request := _request(sequence, _beat(sequence, "beat_media"), "synthetic_n15_media_instance")
	_expect(media_port.open(media_request)["error_code"] == "UNSUPPORTED_PROJECTION", "MEDIA sans fallback")


func _test_snapshot_restore(sequence: Dictionary) -> void:
	var source = ProjectionPort.new(sequence)
	var request := _request(sequence, _beat(sequence, "beat_message"), "synthetic_n15_snapshot_instance")
	_expect(source.open(request)["accepted"], "requete snapshot ouverte")
	_expect(source.acknowledge(_receipt(request))["accepted"], "receipt snapshot accepte")
	var source_snapshot: Dictionary = source.snapshot()
	_expect(source_snapshot["accepted"], "snapshot port accepte")
	_expect(ProjectionContracts.validate_port_snapshot(source_snapshot["snapshot"])["valid"], "snapshot port v1 valide")

	var restored = ProjectionPort.new(sequence)
	_expect(restored.restore(source_snapshot["snapshot"])["accepted"], "restauration port acceptee")
	_expect(restored.snapshot()["snapshot"] == source_snapshot["snapshot"], "restauration port exacte")
	var before_invalid: Dictionary = restored.snapshot()["snapshot"]
	var invalid := before_invalid.duplicate(true)
	invalid["snapshot_version"] = 2
	_expect(restored.restore(invalid)["error_code"] == "INVALID_SNAPSHOT", "snapshot version invalide refuse")
	_expect(restored.snapshot()["snapshot"] == before_invalid, "snapshot invalide sans mutation")
	var malformed := before_invalid.duplicate(true)
	malformed["unknown"] = true
	_expect(restored.restore(malformed)["error_code"] == "INVALID_SNAPSHOT", "snapshot mal forme refuse")
	_expect(restored.snapshot()["snapshot"] == before_invalid, "snapshot mal forme sans mutation")


func _test_withdrawal_convergence(sequence: Dictionary) -> void:
	var withdrawal_environment := _executor_at_physical(sequence)
	_expect(not withdrawal_environment.is_empty(), "executeur retrait atteint PHYSICAL_BEAT")
	if withdrawal_environment.is_empty():
		return
	var executor = withdrawal_environment["executor"]
	var pending: Dictionary = executor.execution_state()["pending_player_input"]
	_expect(pending == {
		"kind": "CONTINUE",
		"beat_id": "beat_physical",
		"allowed_choice_ids": ["choice_finish"],
	}, "pending physique N13 conserve avec retraits autorises")
	var before_invalid: Dictionary = executor.execution_state()
	var missing_choice := _command_for_executor(executor, "WITHDRAW", null)
	_expect(executor.receive_command(missing_choice)["error_code"] == "INVALID_COMMAND", "retrait sans choice refuse")
	_expect(executor.execution_state() == before_invalid, "retrait sans choice sans mutation")
	var unknown_choice := _command_for_executor(executor, "WITHDRAW", "choice_unknown")
	_expect(executor.receive_command(unknown_choice)["error_code"] == "UNKNOWN_CHOICE", "retrait choice inexistant refuse")
	_expect(executor.execution_state() == before_invalid, "retrait choice inexistant sans mutation")

	var domain_before: Dictionary = withdrawal_environment["facade"].save_state()
	var withdrawal_command := _command_for_executor(executor, "WITHDRAW", "choice_finish")
	var withdrawn: Dictionary = executor.receive_command(withdrawal_command)
	_expect(withdrawn["ok"], "WITHDRAW execute")
	var state: Dictionary = executor.execution_state()
	_expect(SequenceExecution.validate(state, sequence)["valid"], "etat retire valide N13")
	_expect(state["execution_status"] == "RESOLUTION_READY", "retrait atteint RESOLUTION_READY")
	_expect(state["current_beat_id"] == "beat_choice", "retrait retrouve le beat CHOICE proprietaire")
	_expect(state["checkpoint_id"] == "checkpoint_resolution_ready", "retrait rejoint checkpoint_after proprietaire")
	_expect(
		state["checkpoint_id"] == sequence["resolutions"]["resolution_complete"]["terminal_checkpoint_id"],
		"checkpoint retrait egal terminal checkpoint resolution",
	)
	_expect(state["selected_resolution_id"] == "resolution_complete", "resolution authored selectionnee")
	_expect(state["consumed_choice_ids"].count("choice_finish") == 1, "choice retrait consomme une fois")
	var owner_presentation := "%s__beat_choice__MESSAGES" % INSTANCE_ID
	_expect(owner_presentation not in state["opened_projection_ids"], "beat CHOICE proprietaire non projete")
	_expect(withdrawal_environment["port"].snapshot()["snapshot"]["open_requests"].is_empty(), "projection physique fermee")
	_expect(withdrawal_environment["facade"].save_state() == domain_before, "aucune ecriture durable avant commit")
	var replay: Dictionary = executor.receive_command(withdrawal_command)
	_expect(replay["ok"] and replay["idempotent"], "rejeu WITHDRAW idempotent")
	_expect(executor.execution_state()["consumed_choice_ids"].count("choice_finish") == 1, "rejeu ne reconsomme pas le choice")
	_expect(withdrawal_environment["facade"].save_state() == domain_before, "rejeu sans ecriture durable")

	var normal_sequence := _sequence_without_media(sequence)
	_expect(AuthoredValidator.validate(normal_sequence)["valid"], "fixture derivee SELECT_CHOICE valide")
	var selection_environment := _executor_at_choice(normal_sequence)
	_expect(not selection_environment.is_empty(), "executeur SELECT_CHOICE atteint le choix")
	if not selection_environment.is_empty():
		var selected: Dictionary = selection_environment["executor"].receive_command(
			_command_for_executor(selection_environment["executor"], "SELECT_CHOICE", "choice_finish")
		)
		_expect(selected["ok"], "SELECT_CHOICE normal execute")
		var selected_state: Dictionary = selection_environment["executor"].execution_state()
		for field in ["execution_status", "current_beat_id", "checkpoint_id", "consumed_choice_ids", "selected_resolution_id"]:
			_expect(selected_state[field] == state[field], "WITHDRAW converge avec SELECT_CHOICE sur %s" % field)

	var committed: Dictionary = executor.commit_resolution(_context())
	_expect(committed["ok"], "commit apres retrait accepte")
	_expect(withdrawal_environment["facade"].save_state() != domain_before, "ecriture durable uniquement au commit")


func _executor_at_physical(sequence: Dictionary) -> Dictionary:
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
	for kind in ["CONTINUE", "CONTINUE"]:
		if not _present_ack_command(executor, kind, null):
			return {}
	if executor.current_beat().get("type") != "PHYSICAL_BEAT" or not _open_and_ack(executor):
		return {}
	environment["executor"] = executor
	return environment


func _executor_at_choice(sequence: Dictionary) -> Dictionary:
	var environment := _executor_at_physical(sequence)
	if environment.is_empty():
		return {}
	var executor = environment["executor"]
	if not executor.receive_command(_command_for_executor(executor, "CONTINUE", null))["ok"]:
		return {}
	if not _present_ack_command(executor, "CONTINUE", null):
		return {}
	if executor.current_beat().get("type") != "CHOICE" or not _open_and_ack(executor):
		return {}
	return environment


func _present_ack_command(executor, kind: String, choice_id) -> bool:
	if not _open_and_ack(executor):
		return false
	return executor.receive_command(_command_for_executor(executor, kind, choice_id))["ok"]


func _open_and_ack(executor) -> bool:
	var opened: Dictionary = executor.open_current_projection()
	if not opened["ok"]:
		return false
	return executor.receive_ack(_receipt(opened["payload"]["request"]))["ok"]


func _sequence_without_media(sequence: Dictionary) -> Dictionary:
	var result := sequence.duplicate(true)
	for index in range(result["beats"].size() - 1, -1, -1):
		if result["beats"][index]["beat_id"] == "beat_media":
			result["beats"].remove_at(index)
	var physical: Dictionary = _beat(result, "beat_physical")
	physical["next"]["beat_id"] = "beat_aftercare"
	return result


func _activated_environment(sequence: Dictionary) -> Dictionary:
	var graph := _new_graph(sequence)
	if graph.is_empty():
		return {}
	var candidates: Dictionary = graph["facade"].find_candidates(_context())
	if not candidates.get("ok", false) or candidates["candidats"].size() != 1:
		return {}
	var composition: Dictionary = graph["facade"].compose_slot(_slot_request(candidates["candidats"][0]))
	if not composition.get("ok", false):
		return {}
	var activation: Dictionary = graph["facade"].activate_option(
		composition["plan"],
		"primary_option",
		{"intention": "PROPOSE", "context": _context()},
	)
	if not activation.get("ok", false):
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
	return {"facade": facade, "port": ProjectionPort.new(sequence)}


func _slot_request(candidate: Dictionary) -> Dictionary:
	return {
		"slot_id": "synthetic_n15_slot",
		"narrative_date": "2032-03-04",
		"starts_at": "2032-03-04T10:30:00+01:00",
		"ends_at": "2032-03-04T11:00:00+01:00",
		"context": _context(),
		"window": {
			"window_id": "synthetic_n15_window",
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
					"instance_id": "synthetic_n15_alternative_instance",
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


func _request(sequence: Dictionary, beat: Dictionary, instance_id: String) -> Dictionary:
	return {
		"instance_id": instance_id,
		"sequence_id": sequence["sequence_id"],
		"authored_version": sequence["authored_version"],
		"beat_id": beat["beat_id"],
		"beat_type": beat["type"],
		"projection_target": beat["projection_target"],
		"presentation_state": [],
	}


func _receipt(request: Dictionary) -> Dictionary:
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


func _command(request: Dictionary, kind: String, choice_id) -> Dictionary:
	return {
		"command_id": "command_%s_%s" % [request["beat_id"], kind.to_lower()],
		"instance_id": request["instance_id"],
		"beat_id": request["beat_id"],
		"kind": kind,
		"choice_id": choice_id,
	}


func _command_for_executor(executor, kind: String, choice_id) -> Dictionary:
	var state: Dictionary = executor.execution_state()
	return {
		"command_id": "command_%s_%s" % [state["current_beat_id"], kind.to_lower()],
		"instance_id": state["instance_id"],
		"beat_id": state["current_beat_id"],
		"kind": kind,
		"choice_id": choice_id,
	}


func _beat(sequence: Dictionary, beat_id: String) -> Dictionary:
	for beat in sequence["beats"]:
		if beat["beat_id"] == beat_id:
			return beat
	return {}


func _sorted_keys(value: Dictionary) -> Array:
	var keys: Array = value.keys()
	keys.sort()
	return keys


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


func _expect(condition: bool, message: String) -> void:
	controls += 1
	if not condition:
		failures.append(message)


func _finish() -> void:
	if failures.is_empty():
		print("R8C_N15_1_MESSAGES_PHYSICAL_PROJECTION: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error("R8C_N15_1: " + failure)
	get_tree().quit(1)
