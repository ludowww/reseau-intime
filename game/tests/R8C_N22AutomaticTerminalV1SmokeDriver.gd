extends Node

const CatalogLoader := preload(
	"res://scripts/unified_runtime/application/AuthoredSequenceCatalogLoader.gd"
)
const FacadeModel := preload("res://scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
const NarrativeStateModel := preload("res://scripts/narrative_state/EtatNarratif.gd")
const SequenceExecutor := preload(
	"res://scripts/unified_runtime/execution/SequenceExecutor.gd"
)
const MessagesPort := preload(
	"res://scripts/unified_runtime/projection/MessagesPhysicalProjectionPort.gd"
)
const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)
const RuntimeSnapshotV1 := preload(
	"res://scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd"
)
const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const SequenceExecutionV1 := preload(
	"res://scripts/unified_runtime/contracts/SequenceExecutionV1.gd"
)
const SequenceExecutionV2 := preload(
	"res://scripts/unified_runtime/application/SequenceExecutionV2.gd"
)

var failures: Array[String] = []


func _ready() -> void:
	var loaded := CatalogLoader.load_catalog(
		"res://data/unified_runtime/catalogs/season_1_v1.json", "season_1_v1", "season_1"
	)
	if not loaded["ok"]:
		return _finish(["catalogue N22 refusé"])
	var catalog: Dictionary = loaded["catalog"]
	var sequence: Dictionary = catalog["package_by_sequence_id"]["marie_household_report_01"]["sequence"]
	_probe_authored_guards(sequence)
	var facade = _new_facade(catalog)
	var activation := _activate(facade, sequence)
	var port = MessagesPort.new(sequence)
	var created := SequenceExecutor.create(facade, port, sequence, activation)
	if not created["ok"]:
		return _finish(["executor V1 refusé"])
	var executor = created["executor"]
	var narrative_before: Dictionary = facade.save_state()["narrative_state"].duplicate(true)
	_check(executor.start()["ok"], "start V1")
	var opened: Dictionary = executor.open_current_projection()
	var request: Dictionary = opened.get("payload", {}).get("request", {})
	var receipt := {
		"presentation_id": ProjectionContracts.presentation_id_for(request),
		"instance_id": request.get("instance_id"),
		"sequence_id": request.get("sequence_id"),
		"authored_version": request.get("authored_version"),
		"beat_id": request.get("beat_id"),
		"beat_type": request.get("beat_type"),
		"projection_target": request.get("projection_target"),
		"kind": "READ",
		"subject_id": "msg_friday_marie_household_003",
	}
	_check(opened["ok"] and executor.receive_ack(receipt)["ok"], "ACK V1")
	var command := {
		"command_id": "command_marie_household_continue",
		"instance_id": request.get("instance_id"),
		"beat_id": request.get("beat_id"),
		"kind": "CONTINUE",
		"choice_id": null,
	}
	_check(executor.receive_command(command)["ok"], "CONTINUE V1")
	var execution: Dictionary = executor.execution_state()
	_check(
		execution["execution_status"] == "COMPLETE"
		and execution["durable_commit_status"] == "AUTOMATIC_COMPLETION_APPLIED"
		and execution["selected_resolution_id"] == null
		and execution["consumed_choice_ids"].is_empty(),
		"état final automatique exact",
	)
	var wrong_commit: Dictionary = execution.duplicate(true)
	wrong_commit["durable_commit_status"] = "APPLIED"
	_check(
		not SequenceExecutionV1.validate(wrong_commit, sequence)["valid"]
		and not SequenceExecutionV2.validate(wrong_commit, sequence)["valid"],
		"V1 et V2 refusent COMPLETE automatique avec commit classique",
	)
	var instance := _instance(facade.save_state(), request["instance_id"])
	_check(
		instance.get("state") == "RESOLVED"
		and instance.get("operation") == "COMPLETE_AUTOMATIC"
		and instance.get("choice_id") == ""
		and instance.get("resolution_id") == ""
		and facade.save_state()["narrative_state"] == narrative_before,
		"A5 seule mutation durable",
	)
	var built: Dictionary = executor.snapshot()
	var snapshot: Dictionary = built.get("payload", {}).get("snapshot", {})
	_check(built["ok"] and RuntimeSnapshotV1.validate(snapshot, sequence)["valid"], "snapshot V1")
	var restored := SequenceExecutor.restore(facade, port, sequence, snapshot)
	_check(
		restored["ok"]
		and restored["executor"].receive_command(command).get("error_code") == "EXECUTION_COMPLETE",
		"restore COMPLETE sans replay",
	)
	var replay: Dictionary = facade._prepare_automatic_scene_completion_internal(
		request["instance_id"], sequence["sequence_id"], request["beat_id"],
		"2032-03-05T18:06:00+01:00"
	)
	_check(replay.get("ok", false) and replay.get("idempotent", false), "rejeu A5 idempotent")
	var divergent: Dictionary = facade._prepare_automatic_scene_completion_internal(
		request["instance_id"], sequence["sequence_id"], "autre_beat_terminal",
		"2032-03-05T18:06:00+01:00"
	)
	_check(not divergent.get("ok", false), "rejeu A5 divergent refusé")
	var forged: Dictionary = snapshot.duplicate(true)
	forged["domain"]["scene_registry"][0]["state"] = "PROPOSED"
	_check(not RuntimeSnapshotV1.validate(forged, sequence)["valid"], "snapshot A5 forgé refusé")
	_check(
		facade.find_candidates(_context(sequence)).get("candidats", []).is_empty(),
		"UNIQUE fermé après restore",
	)
	_probe_refused_completion(catalog, sequence)
	_finish(failures)


func _probe_authored_guards(sequence: Dictionary) -> void:
	var invalid_cases: Array = []
	var extra_beat: Dictionary = sequence.duplicate(true)
	extra_beat["beats"].append(sequence["beats"][0].duplicate(true))
	extra_beat["beats"][1]["beat_id"] = "second_automatic_beat"
	invalid_cases.append(extra_beat)
	var local_condition: Dictionary = sequence.duplicate(true)
	local_condition["beats"][0]["local_conditions"] = [
		{"kind": "CHECKPOINT_REACHED", "ref_id": "forged_checkpoint", "expected": true}
	]
	invalid_cases.append(local_condition)
	var wrong_target: Dictionary = sequence.duplicate(true)
	wrong_target["beats"][0]["projection_target"] = "NONE"
	invalid_cases.append(wrong_target)
	var terminal_target: Dictionary = sequence.duplicate(true)
	terminal_target["beats"][0]["next"]["beat_id"] = "forged_target"
	invalid_cases.append(terminal_target)
	var root_resolution: Dictionary = sequence.duplicate(true)
	root_resolution["resolutions"] = []
	invalid_cases.append(root_resolution)
	var a6_choice: Dictionary = sequence.duplicate(true)
	a6_choice["orchestration"]["a6_entry"]["definition"]["choix"] = [{
		"choix_id": "forged_choice", "formulation": "Faux choix",
		"signal_emis": "FAUX", "resolution_ids": [],
	}]
	invalid_cases.append(a6_choice)
	for invalid in invalid_cases:
		_check(not AuthoredValidator.validate(invalid)["valid"], "garde authored automatique négative")


func _probe_refused_completion(catalog: Dictionary, sequence: Dictionary) -> void:
	var facade = _new_facade(catalog)
	var activation := _activate(facade, sequence)
	var port = MessagesPort.new(sequence)
	var created := SequenceExecutor.create(facade, port, sequence, activation)
	var executor = created.get("executor")
	if executor == null or not executor.start()["ok"]:
		return _check(false, "setup refus completion")
	var opened: Dictionary = executor.open_current_projection()
	var request: Dictionary = opened["payload"]["request"]
	var receipt := {
		"presentation_id": ProjectionContracts.presentation_id_for(request),
		"instance_id": request["instance_id"], "sequence_id": request["sequence_id"],
		"authored_version": request["authored_version"], "beat_id": request["beat_id"],
		"beat_type": request["beat_type"], "projection_target": request["projection_target"],
		"kind": "READ", "subject_id": "msg_friday_marie_household_003",
	}
	executor.receive_ack(receipt)
	var instance = facade._moteur.obtenir_instance(request["instance_id"])
	facade._moteur.annuler(instance, "TEST_REFUS_AUTOMATIQUE", "2032-03-05T18:06:00+01:00")
	var command := {
		"command_id": "command_refused_automatic", "instance_id": request["instance_id"],
		"beat_id": request["beat_id"], "kind": "CONTINUE", "choice_id": null,
	}
	var refused: Dictionary = executor.receive_command(command)
	_check(
		not refused["ok"]
		and refused["error_code"] == "AUTOMATIC_COMPLETION_REFUSED"
		and executor.execution_state()["execution_status"] == "WAITING_FOR_PLAYER"
		and not executor.snapshot()["ok"],
		"refus A5 conserve executor non COMPLETE et interdit save terminal",
	)


func _new_facade(catalog: Dictionary):
	var state = NarrativeStateModel.creer_synthetique({
		"statut_couple": "EN_CLARIFICATION", "contrat_couple": null,
		"etat_divulgation": "PARTIEL", "etat_foyer": null,
		"relation_apres_separation": null, "dernier_evenement_majeur_id": null,
		"faits": [], "cadre_provisoire": null,
	})
	return FacadeModel.create(catalog["library"], state)


func _activate(facade, sequence: Dictionary) -> Dictionary:
	var context := _context(sequence)
	var candidates: Dictionary = facade.find_candidates(context)
	var entry: Dictionary = sequence["orchestration"]["a6_entry"]
	var candidate := {}
	for value in candidates.get("candidats", []):
		if value.get("scene_definition_id") == entry["scene_definition_id"]:
			candidate = value
	var temporal: Dictionary = sequence["temporal_projection"]["resolved_window"]
	var composition: Dictionary = facade.compose_slot({
		"slot_id": sequence["orchestration"]["a9_slot"]["slot_role"],
		"narrative_date": "2032-03-05", "starts_at": temporal["opens_at"],
		"ends_at": temporal["closes_at"], "context": context,
		"window": {
			"window_id": sequence["orchestration"]["a8_window"]["window_id"],
			"opens_at": temporal["opens_at"], "closes_at": temporal["closes_at"],
			"duration_minutes": 4, "not_before": temporal["opens_at"],
			"not_after": temporal["closes_at"], "options": [{
				"option_id": "primary_option", "candidate": candidate,
				"instance_id": "unified_player_" + sequence["sequence_id"],
				"conflict_policy": sequence["orchestration"]["a8_window"]["conflict_policy"],
			}],
		},
	})
	return facade.activate_option(
		composition["plan"], "primary_option", {"intention": "PROPOSE", "context": context}
	)


func _context(sequence: Dictionary) -> Dictionary:
	return {
		"acte_courant": "N22_FRIDAY_ATTENTION",
		"moment_diegetique": "2032-03-05T18:05:00+01:00",
		"participants_disponibles": {"marie": true, "player": true},
		"opportunite_valide": true,
	}


func _instance(domain: Dictionary, instance_id: String) -> Dictionary:
	for instance in domain.get("scene_registry", []):
		if instance.get("instance_id") == instance_id:
			return instance
	return {}


func _check(condition: bool, label: String) -> void:
	if not condition:
		failures.append(label)


func _finish(errors: Array) -> void:
	if errors.is_empty():
		print("R8C_N22_AUTOMATIC_TERMINAL_V1: OK")
		get_tree().quit(0)
		return
	for error in errors:
		push_error(str(error))
	get_tree().quit(1)
