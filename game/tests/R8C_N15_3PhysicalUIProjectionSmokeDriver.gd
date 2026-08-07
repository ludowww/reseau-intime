extends Node

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const PhysicalCatalogContract := preload(
	"res://scripts/unified_runtime/contracts/PhysicalPresentationContentV1.gd"
)
const PhysicalResolver := preload(
	"res://scripts/unified_runtime/projection/PhysicalContentResolver.gd"
)
const ProjectionPort := preload(
	"res://scripts/unified_runtime/projection/MessagesPhysicalProjectionPort.gd"
)
const MessagesAdapter := preload(
	"res://scripts/unified_runtime/projection/MessagesUIProjectionAdapter.gd"
)
const PhysicalAdapter := preload(
	"res://scripts/unified_runtime/projection/PhysicalUIProjectionAdapter.gd"
)
const Coordinator := preload(
	"res://scripts/unified_runtime/projection/MessagesPhysicalUIProjectionCoordinator.gd"
)
const SequenceExecutor := preload(
	"res://scripts/unified_runtime/execution/SequenceExecutor.gd"
)
const FacadeModel := preload("res://scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
const LibraryModel := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const NarrativeStateModel := preload("res://scripts/narrative_state/EtatNarratif.gd")
const MessagesScreenScene := preload("res://scenes/portrait/messages/MessagesScreen.tscn")
const PhysicalScreenScene := preload(
	"res://scenes/portrait/physical/PhysicalProjectionScreen.tscn"
)

const SEQUENCE_PATH := "res://tests/fixtures/unified_runtime/n15_messages_physical_projection_valid.json"
const CATALOG_PATH := "res://tests/fixtures/unified_runtime/n15_3_physical_content_catalog_valid.json"
const INSTANCE_ID := "synthetic_n15_3_instance"
const THREAD_ID := "synthetic_n15_thread"
const WITHDRAWAL_CHOICE_ID := "choice_finish"

var failures: Array[String] = []
var controls := 0


class ProjectionProbePort:
	extends RefCounted

	func snapshot() -> Dictionary:
		return {
			"accepted": true,
			"snapshot": {"snapshot_version": 1, "open_requests": [], "receipts": []},
			"error_code": null,
		}


class ProjectionProbeExecutor:
	extends RefCounted

	var beat: Dictionary
	var open_calls := 0

	func _init(value: Dictionary) -> void:
		beat = value.duplicate(true)

	func current_beat() -> Dictionary:
		return beat.duplicate(true)

	func execution_state() -> Dictionary:
		return {
			"instance_id": "synthetic_probe_instance",
			"sequence_id": "synthetic_n15_durable_sequence",
			"authored_version": "1.0.0",
			"execution_status": "ACTIVE",
			"current_beat_id": beat.get("beat_id"),
		}

	func open_current_projection() -> Dictionary:
		open_calls += 1
		return {"ok": false, "error_code": "PROBE_OPENED"}

	func receive_ack(_receipt: Dictionary) -> Dictionary:
		return {"ok": false, "error_code": "PROBE_ACK"}

	func receive_command(_command: Dictionary) -> Dictionary:
		return {"ok": false, "error_code": "PROBE_COMMAND"}


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	get_window().size = Vector2i(1280, 720)
	var base_sequence := _load_json(SEQUENCE_PATH)
	var catalog := _load_json(CATALOG_PATH)
	_restore_integer_types(base_sequence, catalog)
	_expect(AuthoredValidator.validate(base_sequence)["valid"], "fixture authored N15 valide")
	_test_contract_and_resolver(base_sequence, catalog)
	await _test_preflight_before_open(base_sequence, catalog)
	await _test_messages_physical_messages_routing(base_sequence, catalog)
	await _test_withdrawal(base_sequence, catalog)
	await _test_resume_waiting_for_projection_ack(base_sequence, catalog)
	await _test_resume_waiting_for_player(base_sequence, catalog)
	_finish()


func _test_contract_and_resolver(sequence: Dictionary, catalog: Dictionary) -> void:
	_expect(PhysicalCatalogContract.validate(catalog)["valid"], "catalogue physique valide")
	_expect(_sorted_keys(catalog) == ["authored_version", "entries", "schema_id", "schema_version", "sequence_id"], "champs racine exacts")
	_expect(_sorted_keys(catalog["entries"][0]) == ["body", "content_ref", "continue_label", "steps", "title"], "champs entree exacts")
	_expect(not JSON.stringify(catalog).contains("withdraw"), "catalogue ne contenant aucun retrait")

	var invalid := catalog.duplicate(true)
	invalid["schema_id"] = "wrong"
	_expect(not PhysicalCatalogContract.validate(invalid)["valid"], "mauvais schema refuse")
	invalid = catalog.duplicate(true)
	invalid["schema_version"] = 2
	_expect(not PhysicalCatalogContract.validate(invalid)["valid"], "mauvaise version refusee")
	invalid = catalog.duplicate(true)
	invalid["unknown"] = true
	_expect(not PhysicalCatalogContract.validate(invalid)["valid"], "champ racine inconnu refuse")
	invalid = catalog.duplicate(true)
	invalid["entries"][0]["resolution_id"] = "forbidden"
	_expect(not PhysicalCatalogContract.validate(invalid)["valid"], "champ entree inconnu refuse")
	invalid = catalog.duplicate(true)
	invalid["entries"][0]["steps"] = [" "]
	_expect(not PhysicalCatalogContract.validate(invalid)["valid"], "step invalide refuse")
	invalid = catalog.duplicate(true)
	invalid["entries"].append(invalid["entries"][0].duplicate(true))
	_expect(not PhysicalCatalogContract.validate(invalid)["valid"], "content_ref duplique refuse")

	var wrong_identity := catalog.duplicate(true)
	wrong_identity["sequence_id"] = "another_sequence"
	_expect(PhysicalResolver.create(sequence, wrong_identity)["error_code"] == "SEQUENCE_ID_MISMATCH", "mauvais sequence_id refuse")
	wrong_identity = catalog.duplicate(true)
	wrong_identity["authored_version"] = "2.0.0"
	_expect(PhysicalResolver.create(sequence, wrong_identity)["error_code"] == "AUTHORED_VERSION_MISMATCH", "mauvais authored_version refuse")

	var created: Dictionary = PhysicalResolver.create(sequence, catalog)
	_expect(created["ok"], "resolver cree")
	if not created["ok"]:
		return
	var resolver = created["resolver"]
	var physical := _beat(sequence, "beat_physical")
	var resolved: Dictionary = resolver.resolve_physical_beat(physical)
	_expect(resolved["ok"], "PHYSICAL_BEAT resolu")
	_expect(resolved["presentation"]["withdrawal_actions"] == [{"choice_id": WITHDRAWAL_CHOICE_ID, "text": "Commit the synthetic result"}], "texte retrait toujours derive du CHOICE authored")
	var missing_ref := physical.duplicate(true)
	missing_ref["content"]["content_ref"] = "missing_content_ref"
	_expect(resolver.resolve_physical_beat(missing_ref)["error_code"] == "UNRESOLVED_CONTENT_REF", "content_ref absent refuse")
	var duplicate_withdrawals := physical.duplicate(true)
	duplicate_withdrawals["content"]["withdrawal_choice_ids"] = [WITHDRAWAL_CHOICE_ID, WITHDRAWAL_CHOICE_ID]
	_expect(resolver.resolve_physical_beat(duplicate_withdrawals)["error_code"] == "DUPLICATE_WITHDRAWAL_CHOICE", "retrait duplique refuse")
	var unknown_withdrawal := physical.duplicate(true)
	unknown_withdrawal["content"]["withdrawal_choice_ids"] = ["unknown_choice"]
	_expect(resolver.resolve_physical_beat(unknown_withdrawal)["error_code"] == "UNKNOWN_WITHDRAWAL_CHOICE", "retrait inconnu refuse")
	var ordered := physical.duplicate(true)
	ordered["content"]["withdrawal_choice_ids"] = [WITHDRAWAL_CHOICE_ID]
	_expect(resolver.resolve_physical_beat(ordered)["presentation"]["withdrawal_actions"][0]["choice_id"] == ordered["content"]["withdrawal_choice_ids"][0], "ordre retrait identique a withdrawal_choice_ids")


func _test_preflight_before_open(sequence: Dictionary, catalog: Dictionary) -> void:
	var resolver_result: Dictionary = PhysicalResolver.create(sequence, catalog)
	var bad_beat := _beat(sequence, "beat_physical").duplicate(true)
	bad_beat["content"]["content_ref"] = "missing_content_ref"
	var executor := ProjectionProbeExecutor.new(bad_beat)
	var screen = PhysicalScreenScene.instantiate()
	add_child(screen)
	await get_tree().process_frame
	var created: Dictionary = PhysicalAdapter.create(
		executor, ProjectionProbePort.new(), resolver_result["resolver"], screen
	)
	_expect(created["ok"], "adaptateur preflight cree")
	var before: Dictionary = executor.execution_state()
	var result: Dictionary = created["adapter"].open_current_projection()
	_expect(not result["ok"] and result["error_code"] == "UNRESOLVED_CONTENT_REF", "resolution avant ouverture")
	_expect(executor.open_calls == 0 and executor.execution_state() == before, "echec preflight sans ouverture ni mutation")
	screen.queue_free()
	await get_tree().process_frame


func _test_messages_physical_messages_routing(sequence: Dictionary, catalog: Dictionary) -> void:
	var routing_sequence := _routing_sequence(sequence)
	_expect(AuthoredValidator.validate(routing_sequence)["valid"], "fixture MESSAGES PHYSICAL MESSAGES valide")
	var environment := _started_environment(routing_sequence)
	_expect(not environment.is_empty(), "environnement routing cree")
	if environment.is_empty():
		return
	var package := _build_ui_package(environment, routing_sequence, catalog)
	_expect(not package.is_empty(), "vrai coordinator et vraies surfaces crees")
	if package.is_empty():
		return
	await _frames(2)
	var coordinator = package["coordinator"]
	var messages = package["messages_adapter"]
	var physical = package["physical_adapter"]
	var physical_screen = package["physical_screen"]
	var messages_screen = package["messages_screen"]
	physical_screen.set_reduced_motion(true)
	physical_screen.set_safe_area_override(Rect2i(Vector2i(24, 18), Vector2i(1232, 684)))
	_expect(coordinator.open_current_projection()["ok"], "projection MESSAGES initiale ouverte")
	_expect(messages.mark_message_presented("synthetic_n15_message"), "message reel marque presente")
	_expect(coordinator.on_thread_read(THREAD_ID, "synthetic_n15_message")["ok"], "message lu et CONTINUE")
	await _wait_for(func(): return environment["executor"].current_beat().get("beat_id") == "beat_transition" and environment["executor"].execution_state().get("execution_status") == "WAITING_FOR_PLAYER", 30)
	_expect(physical_screen.visible and physical_screen.presentation_mode() == "TRANSITION", "surface transition physique reellement visible")
	_expect(_sorted_keys(physical_screen.presentation_data()) == ["continuation_label", "transition_id"], "transition sans narration inventee")
	_expect(physical_screen.presentation_data()["continuation_label"] == "Synthetic test-only transition", "continuation_label authored exact")
	_expect(physical_screen.action_count() == 1, "transition avec action unique")
	_expect(_receipt_kind_count(environment["executor"], "PRESENTED") == 1, "ACK PRESENTED transition unique")
	_expect(physical_screen.action_has_focus(), "focus clavier transition")
	_expect(physical_screen.is_input_blocking() and physical_screen.get_index() == messages_screen.get_child_count() - 1, "telephone sous-jacent non interactif")
	_expect(messages_screen.find_children("PhysicalProjectionScreen", "", true, false).size() == 1, "surface physique unique")

	_expect(physical.continue_current_projection()["ok"], "CONTINUE transition unique")
	await _wait_for(func(): return environment["executor"].current_beat().get("beat_id") == "beat_physical" and environment["executor"].execution_state().get("execution_status") == "WAITING_FOR_PLAYER", 30)
	var displayed: Dictionary = physical_screen.presentation_data()
	var expected: Dictionary = catalog["entries"][0]
	_expect(physical_screen.visible and physical_screen.presentation_mode() == "PHYSICAL_BEAT", "PHYSICAL_BEAT reellement visible")
	if displayed.is_empty():
		_expect(false, "routing physique: %s" % coordinator.last_result())
		_dispose_package(package)
		await get_tree().process_frame
		return
	_expect(displayed["title"] == expected["title"] and displayed["body"] == expected["body"], "title et body exacts")
	_expect(displayed["steps"] == expected["steps"], "steps exacts et ordonnes")
	_expect(displayed["continue_label"] == expected["continue_label"], "bouton CONTINUE exact")
	_expect(physical_screen.withdrawal_choice_ids() == [WITHDRAWAL_CHOICE_ID], "boutons WITHDRAW exactement authored")
	_expect(physical_screen.withdrawal_texts() == ["Commit the synthetic result"], "libelle WITHDRAW issu de CHOICE.text")
	_expect(physical_screen.reduced_motion_enabled(), "reduced motion respecte")
	_expect(physical_screen.action_has_focus(), "focus clavier physical")
	_expect(not physical_screen.has_horizontal_crop(), "aucune crop a 1280x720")

	_expect(physical.continue_current_projection()["ok"], "CONTINUE PHYSICAL unique")
	await _wait_for(func(): return environment["executor"].current_beat().get("beat_id") == "beat_message_return" and environment["executor"].execution_state().get("execution_status") == "WAITING_FOR_PROJECTION_ACK", 30)
	_expect(not physical_screen.visible, "surface physique fermee apres CONTINUE")
	_expect(messages.presentation_source()["messages_by_thread"][THREAD_ID][-1]["message_id"] == "synthetic_n15_message_return", "routing PHYSICAL vers MESSAGES")
	_expect(environment["executor"].execution_state()["opened_projection_ids"].size() == 4, "chaque projection ouverte une fois")
	_dispose_package(package)
	await get_tree().process_frame


func _test_withdrawal(sequence: Dictionary, catalog: Dictionary) -> void:
	var physical_sequence := _physical_entry_sequence(sequence)
	_expect(AuthoredValidator.validate(physical_sequence)["valid"], "fixture retrait direct valide")
	var environment := _started_environment(physical_sequence)
	if environment.is_empty():
		_expect(false, "environnement retrait cree")
		return
	var domain_before: Dictionary = environment["facade"].save_state()
	var package := _build_ui_package(environment, physical_sequence, catalog)
	await _frames(2)
	var withdrawal_open: Dictionary = package["coordinator"].open_current_projection()
	_expect(withdrawal_open["ok"], "projection retrait ouverte: %s" % withdrawal_open)
	await _wait_for(func(): return environment["executor"].execution_state().get("execution_status") == "WAITING_FOR_PLAYER", 20)
	var before_execution: Dictionary = environment["executor"].execution_state()
	var before_port: Dictionary = environment["port"].snapshot()["snapshot"]
	var refused: Dictionary = package["physical_adapter"].withdraw("foreign_choice")
	_expect(not refused["ok"] and refused["error_code"] == "WITHDRAWAL_CHOICE_NOT_ALLOWED", "choix hors liste refuse")
	_expect(environment["executor"].execution_state() == before_execution and environment["port"].snapshot()["snapshot"] == before_port, "choix hors liste sans mutation")
	_expect(package["physical_adapter"].withdraw(WITHDRAWAL_CHOICE_ID)["ok"], "WITHDRAW exact accepte")
	await _frames(2)
	var execution: Dictionary = environment["executor"].execution_state()
	_expect(execution["execution_status"] == "RESOLUTION_READY", "WITHDRAW converge vers RESOLUTION_READY")
	_expect(execution["current_beat_id"] == "beat_choice", "convergence vers beat CHOICE proprietaire")
	_expect(execution["consumed_choice_ids"].count(WITHDRAWAL_CHOICE_ID) == 1, "choix consomme exactement une fois")
	_expect(not package["physical_screen"].visible, "surface physique fermee apres WITHDRAW")
	_expect(execution["opened_projection_ids"].size() == 1, "aucun beat CHOICE projete")
	_expect(execution["durable_commit_status"] == "NOT_REQUESTED", "aucun commit durable")
	_expect(environment["facade"].save_state() == domain_before, "aucune mutation A1-A5")
	_dispose_package(package)
	await get_tree().process_frame


func _test_resume_waiting_for_projection_ack(sequence: Dictionary, catalog: Dictionary) -> void:
	var physical_sequence := _physical_entry_sequence(sequence)
	var environment := _started_environment(physical_sequence)
	var package := _build_ui_package(environment, physical_sequence, catalog)
	await _frames(2)
	var ack_open: Dictionary = package["coordinator"].open_current_projection()
	_expect(ack_open["ok"], "projection ouverte avant snapshot ACK: %s" % ack_open)
	_expect(environment["executor"].execution_state()["execution_status"] == "WAITING_FOR_PROJECTION_ACK", "snapshot durant WAITING_FOR_PROJECTION_ACK")
	var snapshot: Dictionary = environment["executor"].snapshot()
	_expect(snapshot["ok"], "snapshot N13 avant ACK")
	_dispose_package(package)
	var restored := _restored_environment(environment, physical_sequence, snapshot["payload"]["snapshot"])
	_expect(not restored.is_empty(), "executeur restaure avant ACK")
	if restored.is_empty():
		return
	var restored_package := _build_ui_package(restored, physical_sequence, catalog)
	await _frames(2)
	_expect(restored_package["coordinator"].resume_from_execution()["ok"], "reprise explicite avant ACK")
	_expect(restored["executor"].execution_state()["execution_status"] == "WAITING_FOR_PROJECTION_ACK", "aucune mutation avant presentation reelle")
	await _wait_for(func(): return restored["executor"].execution_state().get("execution_status") == "WAITING_FOR_PLAYER", 20)
	_expect(restored_package["physical_screen"].visible, "surface reconstruite avant ACK")
	_expect(_receipt_kind_count(restored["executor"], "PRESENTED") == 1, "PRESENTED unique apres reprise ACK")
	_expect(restored_package["messages_screen"].find_children("PhysicalProjectionScreen", "", true, false).size() == 1, "une seule surface apres reprise ACK")
	_dispose_package(restored_package)
	await get_tree().process_frame


func _test_resume_waiting_for_player(sequence: Dictionary, catalog: Dictionary) -> void:
	var physical_sequence := _physical_entry_sequence(sequence)
	var environment := _started_environment(physical_sequence)
	var package := _build_ui_package(environment, physical_sequence, catalog)
	await _frames(2)
	var player_open: Dictionary = package["coordinator"].open_current_projection()
	_expect(player_open["ok"], "projection ouverte avant snapshot joueur: %s" % player_open)
	await _wait_for(func(): return environment["executor"].execution_state().get("execution_status") == "WAITING_FOR_PLAYER", 20)
	var snapshot: Dictionary = environment["executor"].snapshot()
	var original_actions: Array = package["physical_screen"].withdrawal_choice_ids()
	_expect(snapshot["ok"], "snapshot N13 durant WAITING_FOR_PLAYER")
	_dispose_package(package)
	var restored := _restored_environment(environment, physical_sequence, snapshot["payload"]["snapshot"])
	if restored.is_empty():
		_expect(false, "executeur restaure joueur")
		return
	var restored_package := _build_ui_package(restored, physical_sequence, catalog)
	await _frames(2)
	var ack_count_before := _receipt_kind_count(restored["executor"], "PRESENTED")
	_expect(restored_package["coordinator"].resume_from_execution()["ok"], "reprise explicite joueur")
	await _frames(3)
	_expect(restored["executor"].execution_state()["execution_status"] == "WAITING_FOR_PLAYER", "reste WAITING_FOR_PLAYER")
	_expect(_receipt_kind_count(restored["executor"], "PRESENTED") == ack_count_before, "pas de double ACK")
	_expect(restored_package["physical_screen"].withdrawal_choice_ids() == original_actions, "memes actions CONTINUE WITHDRAW")
	_expect(restored_package["physical_screen"].action_count() == 2, "actions restaurees exactement")
	_dispose_package(restored_package)
	await get_tree().process_frame


func _build_ui_package(environment: Dictionary, sequence: Dictionary, catalog: Dictionary) -> Dictionary:
	var resolver_result: Dictionary = PhysicalResolver.create(sequence, catalog)
	if not resolver_result["ok"]:
		return {}
	var messages_result: Dictionary = MessagesAdapter.create(
		environment["executor"], environment["port"], _metadata()
	)
	if not messages_result["ok"]:
		return {}
	var physical_screen = PhysicalScreenScene.instantiate()
	var physical_result: Dictionary = PhysicalAdapter.create(
		environment["executor"], environment["port"], resolver_result["resolver"], physical_screen
	)
	if not physical_result["ok"]:
		return {}
	var coordinator_result: Dictionary = Coordinator.create(
		messages_result["adapter"], physical_result["adapter"]
	)
	if not coordinator_result["ok"]:
		return {}
	var messages_screen = MessagesScreenScene.instantiate()
	messages_screen.configure_content_source(
		messages_result["adapter"].presentation_source(), coordinator_result["coordinator"]
	)
	add_child(messages_screen)
	return {
		"messages_adapter": messages_result["adapter"],
		"physical_adapter": physical_result["adapter"],
		"coordinator": coordinator_result["coordinator"],
		"physical_screen": physical_screen,
		"messages_screen": messages_screen,
	}


func _dispose_package(package: Dictionary) -> void:
	var screen = package.get("messages_screen")
	if screen != null and is_instance_valid(screen):
		if screen.get_parent() != null:
			screen.get_parent().remove_child(screen)
		screen.queue_free()


func _started_environment(sequence: Dictionary) -> Dictionary:
	var environment := _activated_environment(sequence)
	if environment.is_empty():
		return {}
	var created: Dictionary = SequenceExecutor.create(
		environment["facade"], environment["port"], sequence, environment["activation"]
	)
	if not created["ok"] or not created["executor"].start()["ok"]:
		return {}
	environment["executor"] = created["executor"]
	return environment


func _restored_environment(
	original: Dictionary,
	sequence: Dictionary,
	snapshot: Dictionary,
) -> Dictionary:
	var port = ProjectionPort.new(sequence)
	var restored: Dictionary = SequenceExecutor.restore(
		original["facade"], port, sequence, snapshot
	)
	if not restored["ok"]:
		return {}
	return {"facade": original["facade"], "port": port, "executor": restored["executor"]}


func _activated_environment(sequence: Dictionary) -> Dictionary:
	var graph := _new_graph(sequence)
	if graph.is_empty():
		return {}
	var candidates: Dictionary = graph["facade"].find_candidates(_context())
	if not candidates.get("ok", false) or candidates["candidats"].size() != 1:
		return {}
	var composition: Dictionary = graph["facade"].compose_slot(
		_slot_request(candidates["candidats"][0])
	)
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
		"slot_id": "synthetic_n15_3_slot",
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
					"instance_id": "synthetic_n15_3_alternative_instance",
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


func _metadata() -> Dictionary:
	return {
		"characters": {
			"sandra": {
				"character_id": "sandra",
				"display_name": "Sandra",
				"accent_color": "#20C7C9",
				"avatar_ref": "S",
			},
			"player": {
				"character_id": "player",
				"display_name": "Player",
				"accent_color": "#8D63E6",
				"avatar_ref": "P",
			},
		},
		"threads": [{
			"thread_id": THREAD_ID,
			"title": "Sandra",
			"participant_ids": ["sandra", "player"],
			"last_preview": "",
			"last_timestamp": "",
			"unread_count": 0,
			"has_unread_content": false,
			"availability_state": "AVAILABLE",
			"is_group": false,
			"is_archived": false,
			"avatar_ref": "S",
			"accent_color": "#20C7C9",
		}],
	}


func _routing_sequence(sequence: Dictionary) -> Dictionary:
	var result := sequence.duplicate(true)
	var message: Dictionary = _beat(result, "beat_message")
	var transition: Dictionary = _beat(result, "beat_transition")
	var physical: Dictionary = _beat(result, "beat_physical")
	var choice: Dictionary = _beat(result, "beat_choice")
	var return_beat: Dictionary = _beat(result, "beat_return")
	var return_message := message.duplicate(true)
	return_message["beat_id"] = "beat_message_return"
	return_message["checkpoint_before"] = null
	return_message["checkpoint_after"] = "checkpoint_message_return_presented"
	return_message["content"]["messages"][0]["message_id"] = "synthetic_n15_message_return"
	return_message["content"]["messages"][0]["text"] = "Synthetic return to the phone."
	return_message["content"]["messages"][0]["diegetic_at"] = "2032-03-04T10:02:00+01:00"
	return_message["next"] = {"mode": "DIRECT", "beat_id": "beat_choice"}
	message["next"]["beat_id"] = "beat_transition"
	transition["next"]["beat_id"] = "beat_physical"
	physical["next"]["beat_id"] = "beat_message_return"
	result["beats"] = [message, transition, physical, return_message, choice, return_beat]
	return result


func _physical_entry_sequence(sequence: Dictionary) -> Dictionary:
	var result := _routing_sequence(sequence)
	result["entry_beat_id"] = "beat_physical"
	var physical: Dictionary = _beat(result, "beat_physical")
	physical["checkpoint_before"] = "sequence_entered"
	result["beats"] = [
		physical,
		_beat(result, "beat_message_return"),
		_beat(result, "beat_choice"),
		_beat(result, "beat_return"),
	]
	return result


func _beat(sequence: Dictionary, beat_id: String) -> Dictionary:
	for beat in sequence["beats"]:
		if beat["beat_id"] == beat_id:
			return beat
	return {}


func _receipt_kind_count(executor, kind: String) -> int:
	var count := 0
	for receipt_kind in executor.execution_state().get("projection_receipts", {}).values():
		if receipt_kind == kind:
			count += 1
	return count


func _wait_for(predicate: Callable, max_frames: int) -> void:
	for _index in range(max_frames):
		if predicate.call():
			return
		await get_tree().process_frame
	_expect(false, "condition asynchrone atteinte avant timeout")


func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame


func _sorted_keys(value: Dictionary) -> Array:
	var keys: Array = value.keys()
	keys.sort()
	return keys


func _load_json(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed if typeof(parsed) == TYPE_DICTIONARY else {}


func _restore_integer_types(sequence: Dictionary, catalog: Dictionary) -> void:
	sequence["schema_version"] = int(sequence["schema_version"])
	catalog["schema_version"] = int(catalog["schema_version"])
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
		print("R8C_N15_3_PHYSICAL_UI_PROJECTION: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error("R8C_N15_3_PHYSICAL_UI_PROJECTION: " + failure)
	get_tree().quit(1)
