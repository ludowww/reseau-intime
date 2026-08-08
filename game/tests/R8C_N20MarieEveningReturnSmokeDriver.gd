extends Node

const PortraitShellScene := preload("res://scenes/portrait/PortraitShell.tscn")
const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const MessagesResolver := preload(
	"res://scripts/unified_runtime/application/ReferencedMessagesContentResolver.gd"
)
const PhysicalResolver := preload(
	"res://scripts/unified_runtime/projection/PhysicalContentResolver.gd"
)
const MediaResolver := preload(
	"res://scripts/unified_runtime/projection/AuthoredMediaResolver.gd"
)
const ExecutorV2 := preload("res://scripts/unified_runtime/application/SequenceExecutorV2.gd")
const CompositionRoot := preload(
	"res://scripts/unified_runtime/bootstrap/UnifiedPlayerRuntimeCompositionRoot.gd"
)
const MessagesPhysicalPort := preload(
	"res://scripts/unified_runtime/projection/MessagesPhysicalProjectionPort.gd"
)
const MediaPort := preload("res://scripts/unified_runtime/projection/MediaProjectionPort.gd")
const CompositePort := preload(
	"res://scripts/unified_runtime/projection/CompositePlayerProjectionPort.gd"
)
const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)
const CatalogContract := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceCatalogV1.gd"
)
const SeasonRunner := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonRunner.gd"
)
const SeasonSnapshot := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonSnapshotV2.gd"
)
const SaveStore := preload(
	"res://scripts/unified_runtime/application/UnifiedPlayerRuntimeSaveStore.gd"
)
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)

const SEQUENCE_PATH := "res://data/unified_runtime/sequences/marie_evening_return_01.json"
const MESSAGES_PATH := "res://data/unified_runtime/presentation/marie_evening_return_01_messages.json"
const PHYSICAL_PATH := "res://data/unified_runtime/presentation/marie_evening_return_01_physical.json"
const MEDIA_PATH := "res://data/unified_runtime/presentation/marie_evening_return_01_media.json"
const CAPABILITY_CATALOG := (
	"res://tests/fixtures/unified_runtime/capability_catalog_n17_n22.json"
)
const MATHILDE_ID := "mathilde_returns_with_chosen_intent_01"
const SANDRA_ID := "sandra_sentrycore_button_echo_01"
const MARIE_ID := "marie_evening_return_01"
const MARIE_MEDIA := "S1_A1_J03_SCN_MARIE_HOME_FROM_LAVERRIERE_01"
const SAVE_ROOT := "user://r8c_n20_smoke/"

class TestRuntimeHost:
	var shell
	var season_runner
	var runtime_session

	func queue_free() -> void:
		if shell != null:
			shell.queue_free()

class CountingFacade:
	extends RefCounted

	var delegate
	var resolve_scene_calls := 0

	func _init(value) -> void:
		delegate = value

	func resolve_scene(
		instance_id: String,
		choice_id: String,
		resolution_id: String,
		context: Dictionary,
	) -> Dictionary:
		resolve_scene_calls += 1
		return delegate.resolve_scene(instance_id, choice_id, resolution_id, context)

	func save_state() -> Dictionary:
		return delegate.save_state()

	func restore_state(snapshot: Dictionary) -> Dictionary:
		return delegate.restore_state(snapshot)


var failures: Array[String] = []
var controls := 0


func _ready() -> void:
	var sequence := _load(SEQUENCE_PATH)
	_test_contracts_and_bounded_validation(sequence)
	for branch in [
		{
			"choice_id": "marie_evening_active",
			"fact_id": "marie_evening_shared_presence_chosen",
			"return_id": "return_active",
			"outcome_id": "marie_evening_active_outcome",
		},
		{
			"choice_id": "marie_evening_bounded",
			"fact_id": "marie_evening_bounded_return_chosen",
			"return_id": "return_bounded",
			"outcome_id": "marie_evening_bounded_outcome",
		},
		{
			"choice_id": "marie_evening_drift",
			"fact_id": "marie_evening_household_continues_without_player",
			"return_id": "return_drift",
			"outcome_id": "marie_evening_drift_outcome",
		},
	]:
		_test_direct_branch(sequence, branch)
	await _test_production_flow()
	await _frames(3)
	if failures.is_empty():
		print("R8C_N20_MARIE_EVENING_RETURN: OK (%d controls)" % controls)
		get_tree().quit(0)
	else:
		for failure in failures:
			push_error(failure)
		get_tree().quit(1)


func _test_contracts_and_bounded_validation(sequence: Dictionary) -> void:
	_expect(
		AuthoredValidator.validate(sequence, true)["valid"]
		and not AuthoredValidator.validate(sequence)["valid"],
		"V2 accepte RETURN vers PHYSICAL terminal et V1 le refuse",
	)
	_expect(
		MessagesResolver.create(sequence, _load(MESSAGES_PATH), true)["ok"]
		and PhysicalResolver.create(sequence, _load(PHYSICAL_PATH), true)["ok"]
		and MediaResolver.create(sequence, _load(MEDIA_PATH), true)["ok"],
		"les trois catalogues de présentation Marie sont résolus",
	)
	var local: Dictionary = sequence["resolutions"]["resolution_guided_reply"]
	_expect(
		local["a10_choice_id"] == null
		and local["a10_resolution_id"] == null
		and not _resolution_has_durable_effect(local),
		"choix local null/null valide et strictement sans durable",
	)
	for field in ["fact_ids", "event_refs", "media_effects"]:
		var invalid_local: Dictionary = sequence.duplicate(true)
		match field:
			"fact_ids":
				invalid_local["resolutions"]["resolution_guided_reply"][field] = ["forbidden_fact"]
			"event_refs":
				invalid_local["resolutions"]["resolution_guided_reply"][field] = [{
					"event_type": "durable_manifest_event",
					"event_key": "forbidden_event",
					"reducer_id": "a6_durable_manifest",
				}]
			"media_effects":
				invalid_local["resolutions"]["resolution_guided_reply"][field] = [{
					"media_id": MARIE_MEDIA, "effect": "GRANT_ACCESS",
				}]
		_expect(
			not AuthoredValidator.validate(invalid_local, true)["valid"],
			"résolution locale avec %s est refusée" % field,
		)
	var missing_a10_choice: Dictionary = sequence.duplicate(true)
	missing_a10_choice["resolutions"]["resolution_active"]["a10_choice_id"] = null
	_expect(
		not AuthoredValidator.validate(missing_a10_choice, true)["valid"],
		"résolution durable sans a10_choice_id est refusée",
	)

	var return_to_choice: Dictionary = sequence.duplicate(true)
	return_to_choice["beats"][4]["next"]["beat_id"] = "marie_evening_posture_choice"
	_expect(
		not AuthoredValidator.validate(return_to_choice, true)["valid"],
		"RETURN vers CHOICE est refusé",
	)
	var return_to_media: Dictionary = sequence.duplicate(true)
	return_to_media["beats"][5]["type"] = "MEDIA_REVEAL"
	return_to_media["beats"][5]["content"] = {
		"media_id": MARIE_MEDIA, "reveal_context": {}, "requires_ack": true,
	}
	return_to_media["beats"][5]["projection_target"] = "MEDIA"
	_expect(
		not AuthoredValidator.validate(return_to_media, true)["valid"],
		"RETURN vers MEDIA_REVEAL est refusé",
	)
	var non_terminal: Dictionary = sequence.duplicate(true)
	non_terminal["beats"][5]["next"] = {
		"mode": "DIRECT", "beat_id": "marie_evening_meal_messages",
	}
	_expect(
		not AuthoredValidator.validate(non_terminal, true)["valid"],
		"RETURN vers PHYSICAL non terminal est refusé",
	)
	var with_resolution: Dictionary = sequence.duplicate(true)
	with_resolution["beats"][5]["content"]["withdrawal_choice_ids"] = ["marie_evening_active"]
	_expect(
		not AuthoredValidator.validate(with_resolution, true)["valid"],
		"RETURN vers PHYSICAL avec nouvelle résolution est refusé",
	)


func _test_direct_branch(sequence: Dictionary, branch: Dictionary) -> void:
	var graph: Dictionary = CompositionRoot._new_domain_graph(sequence)
	var activation: Dictionary = CompositionRoot._activate_sequence(graph["facade"], sequence)
	var port_result := _projection_port(sequence)
	var created: Dictionary = ExecutorV2.create(
		graph["facade"], port_result.get("port"), sequence, activation
	)
	_expect(
		activation.get("ok", false)
		and port_result.get("ok", false)
		and created.get("ok", false)
		and created["executor"].start()["ok"],
		"executor direct Marie démarre pour " + branch["choice_id"],
	)
	if not created.get("ok", false):
		return
	var executor = created["executor"]
	var counter := CountingFacade.new(graph["facade"])
	executor._facade = counter
	for _index in range(8):
		if executor.execution_state()["execution_status"] == "RESOLUTION_READY":
			break
		var beat: Dictionary = executor.current_beat()
		var choice_id = null
		if beat["beat_id"] == "marie_evening_guided_choice":
			choice_id = "marie_evening_guided_reply"
		elif beat["beat_id"] == "marie_evening_posture_choice":
			choice_id = branch["choice_id"]
		var advanced := _advance_direct_projection(executor, choice_id, "drive_" + branch["choice_id"])
		if beat["beat_id"] == "marie_evening_guided_choice":
			_expect(
				advanced
				and counter.resolve_scene_calls == 0
				and executor.execution_state()["current_beat_id"] == "marie_evening_meal_messages"
				and executor.execution_state()["durable_commit_status"] == "NOT_REQUESTED",
				"choix guidé avance sans aucun appel A10",
			)
		if not advanced:
			break
	_expect(
		executor.execution_state()["execution_status"] == "RESOLUTION_READY",
		"posture durable atteint RESOLUTION_READY pour " + branch["choice_id"],
	)
	var commit_context := {
		"moment_diegetique": "2032-03-05T18:23:00+01:00",
		"acte_courant": "MARIE_EVENING_RETURN",
		"participants_disponibles": {"marie": true, "player": true},
		"opportunite_valide": true,
	}
	var committed: Dictionary = executor.commit_resolution(commit_context)
	var replayed: Dictionary = executor.commit_resolution(commit_context)
	var durable: Dictionary = counter.save_state()
	_expect(
		committed.get("ok", false)
		and replayed.get("ok", false)
		and replayed.get("idempotent", false)
		and counter.resolve_scene_calls == 1
		and _state_has_exact_branch_fact(durable, branch["fact_id"])
		and JSON.stringify(durable).contains(MARIE_MEDIA),
		"commit A10 unique publie seulement fait et média pour " + branch["choice_id"],
	)
	_expect(
		executor.execution_state()["current_beat_id"] == branch["return_id"]
		and executor.execution_state()["durable_commit_status"] in ["APPLIED", "IDEMPOTENT"],
		"RETURN dédié suit le commit pour " + branch["choice_id"],
	)

	var return_snapshot: Dictionary = executor.snapshot(
		_empty_messages_snapshot(), "2032-03-05T18:23:00+01:00"
	)
	var return_graph: Dictionary = CompositionRoot._new_domain_graph(sequence)
	var return_port := _projection_port(sequence)
	var return_restored: Dictionary = ExecutorV2.restore(
		return_graph["facade"], return_port["port"], sequence,
		return_snapshot.get("payload", {}).get("snapshot", {})
	)
	_expect(return_snapshot["ok"] and return_restored["ok"], "reload au RETURN accepté")
	if not return_restored.get("ok", false):
		return
	var return_counter := CountingFacade.new(return_graph["facade"])
	var restored_executor = return_restored["executor"]
	restored_executor._facade = return_counter
	_expect(
		_advance_direct_projection(restored_executor, null, "return_" + branch["choice_id"])
		and restored_executor.execution_state()["current_beat_id"] == branch["outcome_id"]
		and restored_executor.execution_state()["scheduled_returns"].is_empty()
		and return_counter.resolve_scene_calls == 0,
		"reload au RETURN ne rejoue pas A10 Marie",
	)
	var physical_snapshot: Dictionary = restored_executor.snapshot(
		_empty_messages_snapshot(), "2032-03-05T18:23:00+01:00"
	)
	var physical_graph: Dictionary = CompositionRoot._new_domain_graph(sequence)
	var physical_port := _projection_port(sequence)
	var physical_restored: Dictionary = ExecutorV2.restore(
		physical_graph["facade"], physical_port["port"], sequence,
		physical_snapshot.get("payload", {}).get("snapshot", {})
	)
	_expect(
		physical_snapshot["ok"]
		and physical_restored["ok"]
		and physical_restored["executor"].execution_state()["current_beat_id"] == branch["outcome_id"],
		"reload au PHYSICAL reprend le seul outcome choisi",
	)
	if not physical_restored.get("ok", false):
		return
	var physical_counter := CountingFacade.new(physical_graph["facade"])
	physical_restored["executor"]._facade = physical_counter
	_expect(
		_advance_direct_projection(
			physical_restored["executor"], null, "physical_" + branch["choice_id"]
		)
		and physical_restored["executor"].execution_state()["execution_status"] == "COMPLETE"
		and physical_counter.resolve_scene_calls == 0,
		"branche %s converge COMPLETE sans second A10" % branch["choice_id"],
	)
	if branch["choice_id"] == "marie_evening_drift":
		_expect(true, "branches ACTIVE BOUNDED DRIFT convergent chacune sans second A10")


func _test_production_flow() -> void:
	var save_path := SAVE_ROOT + "production.json"
	var boundary_path := SAVE_ROOT + "sandra_boundary.json"
	var old_n19_path := SAVE_ROOT + "old_n19.json"
	for path in [save_path, boundary_path, old_n19_path]:
		_remove_save(path)
	var main = await _new_production_main(save_path)
	if main == null:
		return
	_expect(await _drive_mathilde_and_sandra(main), "préfixe production Mathilde vers Sandra inchangé")
	await _frames(5)
	var runner = main.season_runner
	var session = main.runtime_session
	if session == null:
		_expect(false, "Marie devient active après Sandra")
		main.queue_free()
		return
	var opening_source: Dictionary = session.presentation_source()
	var gallery_before: Dictionary = session.gallery_source()
	_expect(
			runner.catalog["manifest"]["packages"].size() == 5
		and runner.completed_sequence_ids == [MATHILDE_ID, SANDRA_ID]
		and runner.active_sequence_id == MARIE_ID
		and _texts_for_thread(opening_source, "marie_thread") == [
			"Tu rentres vers quelle heure ?",
			"Mathilde a retrouvé son chargeur. Enfin un chargeur.",
		]
		and _texts_for_thread(opening_source, "mathilde_thread").size() > 0
		and _texts_for_thread(opening_source, "sandra_thread").size() == 5
		and gallery_before.get("character_order") == ["mathilde"],
		"Marie démarre à 18:20 avec transcripts et Galerie Mathilde intacts",
	)

	var boundary := SeasonSnapshot.create(
		runner.catalog,
		"",
		[MATHILDE_ID, SANDRA_ID],
		[],
		null,
		runner._persistent_messages_state,
	)
	_expect(
		boundary["ok"]
		and SaveStore.create(boundary_path)["store"].save_snapshot(boundary["snapshot"])["ok"],
		"Sandra COMPLETE sauvegardée avant détachement",
	)
	var old_manifest: Dictionary = runner.catalog["manifest"].duplicate(true)
	old_manifest["packages"].resize(2)
	var old_save: Dictionary = boundary["snapshot"].duplicate(true)
	old_save["catalog_fingerprint"] = CatalogContract.fingerprint(old_manifest)
	_expect(
		SaveStore.create(old_n19_path)["store"].save_snapshot(old_save)["ok"],
		"save N19 installé avec ancien fingerprint",
	)
	var refused_shell = PortraitShellScene.instantiate()
	refused_shell.content_mode = "unified"
	add_child(refused_shell)
	await _frames(3)
	var refused := SeasonRunner.create_for_test(CAPABILITY_CATALOG, refused_shell, old_n19_path)
	_expect(
		not refused["ok"] and refused["error_code"] == "INVALID_SEASON_SAVE",
		"ancien save N19 refusé par fingerprint",
	)
	refused_shell.queue_free()
	await get_tree().process_frame
	var boundary_shell = PortraitShellScene.instantiate()
	boundary_shell.content_mode = "unified"
	add_child(boundary_shell)
	await _frames(3)
	var boundary_restore := SeasonRunner.create_for_test(
		CAPABILITY_CATALOG, boundary_shell, boundary_path
	)
	_expect(
		not boundary_restore["ok"]
		and boundary_restore["error_code"] == "UNRESTORABLE_INCOMPLETE_HANDOFF_SAVE",
		"frontière active-null incomplète est refusée fail-closed",
	)
	boundary_shell.queue_free()
	await get_tree().process_frame

	_expect(session.save_now()["ok"], "save après messages d'ouverture")
	main.queue_free()
	await get_tree().process_frame
	main = await _new_production_main(save_path)
	if main == null:
		return
	session = main.runtime_session
	_expect(
		_texts_for_thread(session.presentation_source(), "marie_thread") == [
			"Tu rentres vers quelle heure ?",
			"Mathilde a retrouvé son chargeur. Enfin un chargeur.",
		],
		"reload après ouverture conserve le transcript exact",
	)
	_expect(await _complete_current_messages(session), "ouverture Marie présentée")
	var guided_choices: Array = session.presentation_source()["choices_by_thread"]["marie_thread"]
	_expect(
		guided_choices.size() == 1
		and guided_choices[0]["text"] == "Vers 19 h. Pourquoi ?",
		"choix guidé exact disponible une fois",
	)
	var local_counter := CountingFacade.new(session._facade)
	session._facade = local_counter
	session._executor._facade = local_counter
	_expect(
		(await _select_choice(session, "marie_thread", "marie_evening_guided_reply")).get("accepted", false)
		and local_counter.resolve_scene_calls == 0
		and _texts_for_thread(session.presentation_source(), "marie_thread").count("Vers 19 h. Pourquoi ?") == 1,
		"choix guidé Player persiste une fois avec zéro A10",
	)
	_expect(session.save_now()["ok"], "save après réponse guidée")
	main.queue_free()
	await get_tree().process_frame
	main = await _new_production_main(save_path)
	if main == null:
		return
	session = main.runtime_session
	_expect(
		_texts_for_beat(session, "marie_evening_meal_messages") == [
			"J'ai laissé une soupe au frigo.",
			"Et j'aimerais bien qu'on mange ensemble sans déplacer ça à demain.",
		]
		and session.execution_state()["durable_commit_status"] == "NOT_REQUESTED",
		"reload après réponse guidée atteint les deux messages soupe sans A10",
	)
	_expect(await _complete_current_messages(session), "messages soupe présentés")
	var posture_choices: Array = session.presentation_source()["choices_by_thread"]["marie_thread"]
	_expect(
		posture_choices.map(func(choice): return choice["text"]) == [
			"Je rentre à 19 h. Je prends quelque chose avec la soupe.",
			"Je finis ça et je rentre à 19 h 30.",
			"Je sais pas encore. Commencez sans moi.",
		],
		"trois postures exactes disponibles une fois",
	)
	_expect(session.save_now()["ok"], "save avant choix durable Marie")
	main.queue_free()
	await get_tree().process_frame
	main = await _new_production_main(save_path)
	if main == null:
		return
	runner = main.season_runner
	session = main.runtime_session
	var counter := CountingFacade.new(session._facade)
	session._facade = counter
	session._executor._facade = counter
	var selected := await _select_choice(session, "marie_thread", "marie_evening_active")
	var durable_after_commit: Dictionary = session.durable_state()
	_expect(
		selected.get("accepted", false)
		and counter.resolve_scene_calls == 1
		and _state_has_exact_branch_fact(durable_after_commit, "marie_evening_shared_presence_chosen")
		and session.gallery_source().get("character_order") == ["marie", "mathilde"]
		and not session.gallery_source().get("fixtures", {}).has("sandra")
		and JSON.stringify(durable_after_commit).contains(MARIE_MEDIA),
		"A10 Marie unique publie fait ACTIVE et GRANT_ACCESS non diégétique",
	)
	_expect(
		session.execution_state()["current_beat_id"] == "return_active"
		and _texts_for_beat(session, "return_active") == [
			"Parfait.",
			"Prends un truc qui croque. Cette soupe a besoin d'aide.",
		],
		"RETURN ACTIVE exact présenté",
	)
	_expect(session.save_now()["ok"], "save pendant RETURN Marie")
	main.queue_free()
	await get_tree().process_frame
	main = await _new_production_main(save_path)
	if main == null:
		return
	session = main.runtime_session
	_expect(
		session.durable_state() == durable_after_commit
		and session.execution_state()["current_beat_id"] == "return_active",
		"reload au RETURN ne rejoue pas A10 Marie",
	)
	_expect(await _complete_current_messages(session), "RETURN Marie consommé")
	_expect(
		session.execution_state()["current_beat_id"] == "marie_evening_active_outcome"
		and session.execution_state()["selected_resolution_id"] == "resolution_active"
		and session.execution_state()["durable_commit_status"] in ["APPLIED", "IDEMPOTENT"]
		and session.execution_state()["scheduled_returns"].is_empty(),
		"tail V2 ouvre le PHYSICAL terminal en conservant la résolution",
	)
	_expect(session.save_now()["ok"], "save pendant PHYSICAL outcome")
	main.queue_free()
	await get_tree().process_frame
	main = await _new_production_main(save_path)
	if main == null:
		return
	session = main.runtime_session
	_expect(
		session.execution_state()["current_beat_id"] == "marie_evening_active_outcome"
		and session.durable_state() == durable_after_commit,
		"reload au PHYSICAL reprend le seul outcome choisi",
	)
	_expect(await _continue_physical(main), "PHYSICAL ACTIVE exact continue vers COMPLETE")
	await _frames(5)
	runner = main.season_runner
	var idle_source: Dictionary = runner.presentation_source()
	_expect(
		runner.completed_sequence_ids == [MATHILDE_ID, SANDRA_ID, MARIE_ID]
		and runner.active_sequence_id.is_empty()
		and runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
		and runner.active_session == null
		and runner.describe_state()["opportunities"].size() == 2,
		"handoff final contient Mathilde Sandra Marie puis la paire N22",
	)
	_expect(
		_texts_for_thread(idle_source, "mathilde_thread").size() > 0
		and _texts_for_thread(idle_source, "sandra_thread").size() == 5
		and _texts_for_thread(idle_source, "marie_thread").size() == 8
		and idle_source["choices_by_thread"]["mathilde_thread"].is_empty()
		and idle_source["choices_by_thread"]["sandra_thread"].is_empty()
		and idle_source["choices_by_thread"]["marie_thread"].is_empty(),
		"transcripts persistants sans bouton obsolète en idle",
	)
	main.queue_free()
	await get_tree().process_frame
	for path in [save_path, boundary_path, old_n19_path]:
		_remove_save(path)


func _drive_mathilde_and_sandra(main) -> bool:
	var session = main.runtime_session
	if not (
		await _complete_current_messages(session)
		and await _continue_physical(main)
		and await _continue_physical(main)
	):
		return false
	for _index in range(3):
		if not await _continue_media(main):
			return false
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "mathilde_thread", "mathilde_mb3_ma1")).get("accepted", false):
		return false
	if not await _complete_current_messages(session):
		return false
	await _frames(5)
	if not (
		main.season_runner.active_sequence_id.is_empty()
		and main.season_runner.active_session == null
		and main.season_runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
		and main.season_runner.describe_state()["opportunity"]["thread_id"] == "sandra_thread"
	):
		return false
	if not main.season_runner.activate_opportunity("sandra_thread")["ok"]:
		return false
	await _frames(4)
	if main.season_runner.active_sequence_id != SANDRA_ID:
		return false
	session = main.runtime_session
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "sandra_thread", "sandra_button_echo_reply")).get("accepted", false):
		return false
	if not await _complete_current_messages(session):
		return false
	await _frames(5)
	if not (
		main.season_runner.active_sequence_id.is_empty()
		and main.season_runner.active_session == null
		and main.season_runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
		and main.season_runner.describe_state()["opportunity"]["thread_id"] == "marie_thread"
	):
		return false
	if not main.season_runner.activate_opportunity("marie_thread")["ok"]:
		return false
	await _frames(4)
	return main.season_runner.active_sequence_id == MARIE_ID


func _advance_direct_projection(executor, choice_id, command_suffix: String) -> bool:
	var beat: Dictionary = executor.current_beat()
	var opened: Dictionary = executor.open_current_projection()
	if not opened.get("ok", false):
		return false
	var request: Dictionary = opened["payload"]["request"]
	var receipt := {
		"presentation_id": ProjectionContracts.presentation_id_for(request),
		"instance_id": request["instance_id"],
		"sequence_id": request["sequence_id"],
		"authored_version": request["authored_version"],
		"beat_id": request["beat_id"],
		"beat_type": request["beat_type"],
		"projection_target": request["projection_target"],
		"kind": "PRESENTED",
		"subject_id": beat["beat_id"],
	}
	if not executor.receive_ack(receipt).get("ok", false):
		return false
	var is_choice: bool = beat["type"] == "CHOICE"
	return executor.receive_command({
		"command_id": "n20_" + command_suffix + "_" + beat["beat_id"],
		"instance_id": request["instance_id"],
		"beat_id": beat["beat_id"],
		"kind": "SELECT_CHOICE" if is_choice else "CONTINUE",
		"choice_id": choice_id if is_choice else null,
	}).get("ok", false)


func _projection_port(sequence: Dictionary) -> Dictionary:
	return CompositePort.create(MessagesPhysicalPort.new(sequence, true), MediaPort.new(sequence, true))


func _new_production_main(save_path: String):
	var main := TestRuntimeHost.new()
	main.shell = PortraitShellScene.instantiate()
	main.shell.content_mode = "unified"
	add_child(main.shell)
	await _frames(5)
	var created: Dictionary = SeasonRunner.create_for_test(CAPABILITY_CATALOG, main.shell, save_path)
	_expect(created["ok"], "factory TEST_ONLY N20 compose le catalogue capability")
	if not created["ok"]:
		main.queue_free()
		await get_tree().process_frame
		return null
	main.season_runner = created["runner"]
	main.runtime_session = main.season_runner.active_session
	main.season_runner.active_session_changed.connect(
		_on_test_active_session_changed.bind(main)
	)
	if main.runtime_session != null:
		_expect(main.shell.configure_unified_runtime(main.runtime_session), "shell TEST_ONLY N20 configuré")
	var begun: Dictionary = main.season_runner.begin()
	_expect(begun["ok"], "runner TEST_ONLY N20 démarre")
	if main.runtime_session == null:
		_expect(false, "catalogue capability compose une session active")
		main.queue_free()
		await get_tree().process_frame
		return null
	main.shell.messages_screen.runtime_delivery_time_scale = 0.001
	return main


func _on_test_active_session_changed(_previous_session, next_session, host: TestRuntimeHost) -> void:
	host.runtime_session = next_session
	host.shell.clear_unified_runtime(
		host.season_runner.presentation_source(),
		host.season_runner.gallery_source(),
		host.season_runner,
	)
	if next_session != null:
		_expect(host.shell.configure_unified_runtime(next_session), "handoff TEST_ONLY N20 configuré")


func _complete_current_messages(session) -> bool:
	if not await _wait_for_status(session, "WAITING_FOR_PROJECTION_ACK"):
		return false
	var beat_id: String = session.execution_state()["current_beat_id"]
	var source: Dictionary = session.presentation_source()
	var thread_id := ""
	var active_messages: Array = []
	for candidate_thread_id in source.get("messages_by_thread", {}):
		for message in source["messages_by_thread"][candidate_thread_id]:
			if message.get("beat_id") == beat_id:
				thread_id = str(candidate_thread_id)
				active_messages.append(message)
	if active_messages.is_empty():
		return false
	var presented: Array = session.presented_message_ids_by_thread().get(thread_id, [])
	for message in active_messages:
		if message["message_id"] not in presented:
			if not session.mark_message_presented(str(message["message_id"])):
				return false
	var read: Dictionary = session.on_thread_read(thread_id, str(active_messages[-1]["message_id"]))
	await _frames(4)
	return read.get("ok", false)


func _select_choice(session, thread_id: String, choice_id: String) -> Dictionary:
	if not await _wait_for_status(session, "WAITING_FOR_PROJECTION_ACK"):
		return {"accepted": false, "error_code": "CHOICE_NOT_READY"}
	var choices: Array = session.presentation_source()["choices_by_thread"].get(thread_id, [])
	var ids: Array = choices.map(func(choice): return choice["choice_id"])
	if not session.on_choices_presented(thread_id, ids).get("ok", false):
		return {"accepted": false, "error_code": "CHOICE_PRESENTATION_REFUSED"}
	var selected: Dictionary = session.apply_choice(thread_id, choice_id)
	if not selected.get("accepted", false):
		return selected
	for bubble in selected.get("new_messages", []):
		session.mark_message_presented(str(bubble["message_id"]))
	session.mark_thread_batch_presented(thread_id)
	await _frames(4)
	return selected


func _continue_physical(main) -> bool:
	var session = main.runtime_session
	if not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	var prior_beat_id = session.execution_state().get("current_beat_id")
	var button = main.shell.messages_screen.find_child("PhysicalContinue", true, false)
	if button == null or not button.visible:
		return false
	button.emit_signal("pressed")
	await _frames(4)
	return session.execution_state().get("current_beat_id") != prior_beat_id


func _continue_media(main) -> bool:
	var session = main.runtime_session
	if not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	var prior_beat_id = session.execution_state().get("current_beat_id")
	var viewer = main.shell.photo_viewer
	if viewer == null or not viewer.visible or viewer.back_button == null:
		return false
	viewer.back_button.emit_signal("pressed")
	await _frames(4)
	return session.execution_state().get("current_beat_id") != prior_beat_id


func _resolution_has_durable_effect(resolution: Dictionary) -> bool:
	for field in [
		"event_refs", "fact_ids", "knowledge_ids", "trace_ids", "promise_effects",
		"obligation_effects", "consequence_ids", "media_effects",
	]:
		if not resolution[field].is_empty():
			return true
	return false


func _state_has_exact_branch_fact(state: Dictionary, expected_fact_id: String) -> bool:
	var serialized := JSON.stringify(state)
	if not serialized.contains(expected_fact_id):
		return false
	for other_fact_id in [
		"marie_evening_shared_presence_chosen",
		"marie_evening_bounded_return_chosen",
		"marie_evening_household_continues_without_player",
	]:
		if other_fact_id != expected_fact_id and serialized.contains(other_fact_id):
			return false
	return true


func _empty_messages_snapshot() -> Dictionary:
	return {
		"active": {},
		"notification_dismissed": false,
		"notification_presented": false,
		"presented_message_ids_by_thread": {},
		"progression_ack_sent": false,
		"progression_command_sent": false,
		"snapshot_version": 1,
		"source": {},
	}


func _texts_for_beat(session, beat_id: String) -> Array:
	var texts: Array = []
	for thread_id in session.presentation_source().get("messages_by_thread", {}):
		for message in session.presentation_source()["messages_by_thread"][thread_id]:
			if message.get("beat_id") == beat_id:
				texts.append(message.get("text"))
	return texts


func _texts_for_thread(source: Dictionary, thread_id: String) -> Array:
	return source.get("messages_by_thread", {}).get(thread_id, []).map(
		func(message): return message.get("text")
	)


func _wait_for_status(session, expected: String, max_frames := 60) -> bool:
	for _index in range(max_frames):
		if session.execution_state().get("execution_status") == expected:
			return true
		await get_tree().process_frame
	return false


func _load(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return JsonNormalizer.normalize(parsed) if typeof(parsed) == TYPE_DICTIONARY else {}


func _expect(condition: bool, message: String) -> void:
	controls += 1
	if not condition:
		failures.append(message)


func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame


func _remove_save(save_path: String) -> void:
	for suffix in ["", ".tmp", ".previous", ".corrupt"]:
		var path: String = save_path + suffix
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
