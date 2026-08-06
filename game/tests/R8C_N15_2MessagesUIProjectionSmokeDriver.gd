extends Node

const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const ProjectionContracts := preload(
	"res://scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
)
const ProjectionPort := preload(
	"res://scripts/unified_runtime/projection/MessagesPhysicalProjectionPort.gd"
)
const ProjectionAdapter := preload(
	"res://scripts/unified_runtime/projection/MessagesUIProjectionAdapter.gd"
)
const SequenceExecutor := preload(
	"res://scripts/unified_runtime/execution/SequenceExecutor.gd"
)
const FacadeModel := preload("res://scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
const LibraryModel := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const NarrativeStateModel := preload("res://scripts/narrative_state/EtatNarratif.gd")
const MessagesScreenScene := preload("res://scenes/portrait/messages/MessagesScreen.tscn")

const FIXTURE_PATH := "res://tests/fixtures/unified_runtime/n15_messages_physical_projection_valid.json"
const INSTANCE_ID := "synthetic_n15_2_instance"
const THREAD_ID := "synthetic_n15_thread"
const MESSAGE_ID := "synthetic_n15_message"
const SECOND_MESSAGE_ID := "synthetic_n15_message_second"
const CHOICE_ID := "choice_finish"

var failures: Array[String] = []
var controls := 0
var typing_events: Array[String] = []
var delivered_events: Array[String] = []


class ProjectionProbePort:
	extends RefCounted

	func open(_request: Dictionary) -> Dictionary:
		return {}

	func acknowledge(_receipt: Dictionary) -> Dictionary:
		return {}

	func snapshot() -> Dictionary:
		return {"accepted": true, "snapshot": {}, "error_code": null}


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
			"instance_id": "probe_instance",
			"current_beat_id": beat.get("beat_id"),
			"execution_status": "ACTIVE",
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
	get_window().size = Vector2i(720, 1280)
	var sequence := _message_choice_sequence(_load_sequence())
	_expect(AuthoredValidator.validate(sequence)["valid"], "fixture MESSAGE vers CHOICE valide")
	_test_preflight_refusals()
	await _test_snapshot_restore(sequence)
	await _test_real_messages_ui(sequence)
	_finish()


func _test_real_messages_ui(sequence: Dictionary) -> void:
	var environment := _started_environment(sequence)
	_expect(not environment.is_empty(), "environnement executeur cree")
	if environment.is_empty():
		return
	var executor = environment["executor"]
	var port = environment["port"]
	var domain_before: Dictionary = environment["facade"].save_state()
	var created: Dictionary = ProjectionAdapter.create(executor, port, _metadata())
	_expect(created["ok"], "adaptateur cree sans provider Saison 1")
	if not created["ok"]:
		return
	var adapter = created["adapter"]
	_expect(adapter.open_current_projection()["ok"], "projection MESSAGE ouverte")
	var source: Dictionary = adapter.presentation_source()
	_expect(_sorted_keys(source) == ["characters", "choices_by_thread", "messages_by_thread", "threads"], "source DTO canonique")
	_expect(source["messages_by_thread"][THREAD_ID].size() == 1, "message authored projete une fois")
	var message: Dictionary = source["messages_by_thread"][THREAD_ID][0]
	_expect(message["message_id"] == MESSAGE_ID, "message_id conserve")
	_expect(message["author_id"] == "sandra", "author_id conserve")
	_expect(message["text"] == "Synthetic test-only runtime message.", "texte authored conserve")
	_expect(message["timestamp"] == "10:01", "diegetic_at traduit pour timestamp")
	_expect(message["diegetic_at"] == "2032-03-04T10:01:00+01:00", "diegetic_at complet conserve")
	_expect(message["content_type"] == "TEXT" and message["media_ref"] == "", "DTO texte sans media invente")
	_expect(message["sequence_id"] == sequence["sequence_id"] and message["beat_id"] == "beat_message", "provenance conservee")

	var screen = MessagesScreenScene.instantiate()
	screen.configure_content_source(source, adapter)
	screen.runtime_delivery_time_scale = 0.001
	screen.reading_speed_multiplier = 8.0
	screen.runtime_typing_started.connect(func(_thread_id: String, message_id: String, _author_id: String): typing_events.append(message_id))
	screen.runtime_message_delivered.connect(func(_thread_id: String, message_id: String): delivered_events.append(message_id))
	add_child(screen)
	await _frames(4)
	var initial_state: Dictionary = screen.describe_state()
	_expect(initial_state["notification_visible"], "notification reellement visible")
	_expect(initial_state["notification_id"] == "%s::%s" % [THREAD_ID, MESSAGE_ID], "notification deterministe")
	_expect(_receipt_count(port, "PRESENTED", initial_state["notification_id"]) == 1, "receipt notification PRESENTED")
	var stale_result: Dictionary = adapter.on_notification_dismissed({
		"notification_id": "stale",
		"thread_id": THREAD_ID,
		"message_id": MESSAGE_ID,
	})
	_expect(not stale_result["ok"] and stale_result["error_code"] == "STALE_NOTIFICATION", "callback notification perime refuse")
	var foreign_receipt := _receipt_for_open(port, "PRESENTED", "foreign_subject")
	var foreign_result: Dictionary = adapter.acknowledge_presentation(foreign_receipt)
	_expect(not foreign_result["ok"] and foreign_result["error_code"] == "FOREIGN_RECEIPT", "receipt etranger refuse")

	screen.call("_on_notification_dismiss_requested", int(initial_state["notification_generation"]))
	await _frames(2)
	_expect(not screen.describe_state()["notification_visible"], "notification dismissed")
	_expect(screen.thread_unread_count(THREAD_ID) == 1, "dismissal conserve unread")
	_expect(_receipt_count(port, "DISMISSED", initial_state["notification_id"]) == 1, "receipt notification DISMISSED")
	_expect(executor.execution_state()["execution_status"] == "WAITING_FOR_PROJECTION_ACK", "notification sans progression")

	screen.open_thread(THREAD_ID)
	await _frames(2)
	await _wait_for(func(): return not screen.runtime_delivery_active, 240)
	await _wait_for(func(): return executor.current_beat().get("type") == "CHOICE", 120)
	await _frames(4)
	_expect(typing_events == [MESSAGE_ID], "typing unique")
	_expect(delivered_events.count(MESSAGE_ID) == 1, "bulle MESSAGE presentee une fois")
	_expect(screen.describe_state()["typing_instance_count"] == 0, "typing remplace atomiquement")
	_expect(screen.presentation_count_by_id(MESSAGE_ID) == 1, "aucune duplication MESSAGE")
	_expect(screen.all_messages_read(THREAD_ID), "fil effectivement lu")
	_expect(screen.thread_unread_count(THREAD_ID) == 0, "unread efface a la lecture")
	_expect(_execution_receipt_count(executor, "READ") == 1, "ACK READ de progression unique")
	_expect(executor.current_beat().get("beat_id") == "beat_choice", "CONTINUE unique vers CHOICE")
	_expect(screen.thread_choice_count(THREAD_ID) == 1, "ChoiceBar authored rendue")
	_expect(executor.execution_state()["execution_status"] == "WAITING_FOR_PLAYER", "CHOICE ACK PRESENTED")
	_expect(_execution_receipt_count(executor, "PRESENTED") == 1, "ACK PRESENTED CHOICE unique")

	var choice_source: Dictionary = adapter.presentation_source()
	var choice: Dictionary = choice_source["choices_by_thread"][THREAD_ID][0]
	_expect(choice["choice_id"] == CHOICE_ID and choice["text"] == "Commit the synthetic result", "mapping choix authored exact")
	_expect(choice["enabled"] and not choice.has("confirmation_required"), "choix utilisable sans confirmation inventee")
	screen.activate_first_choice()
	await _wait_for(func(): return not screen.runtime_delivery_active, 180)
	await _frames(4)
	var player_bubble_id := "%s__beat_choice__MESSAGES__choice__%s__player" % [INSTANCE_ID, CHOICE_ID]
	_expect(screen.thread_player_message_count(THREAD_ID) == 1, "bulle Player unique")
	_expect(screen.presentation_count_by_id(player_bubble_id) == 1, "identite bulle Player deterministe")
	_expect(executor.execution_state()["consumed_choice_ids"].count(CHOICE_ID) == 1, "choix consomme exactement une fois")
	_expect(executor.execution_state()["execution_status"] == "RESOLUTION_READY", "convergence N13 normale")
	_expect(port.snapshot()["snapshot"]["open_requests"].is_empty(), "projection CHOICE fermee")
	_expect(port.snapshot()["snapshot"]["receipts"].is_empty(), "receipts presentation-only consommes a la fermeture")
	var player_count_before: int = screen.thread_player_message_count(THREAD_ID)
	screen.call("_on_choice_selected", choice)
	await _frames(3)
	_expect(screen.thread_player_message_count(THREAD_ID) == player_count_before, "replay sans seconde bulle Player")
	_expect(environment["facade"].save_state() == domain_before, "aucune mutation A1-A5 avant commit externe")
	var after_close: Dictionary = adapter.acknowledge_presentation(foreign_receipt)
	_expect(not after_close["ok"] and after_close["error_code"] == "PROJECTION_NOT_OPEN", "action apres fermeture refusee")
	_expect(screen.notification_banner_count() == 1, "banner existant unique reutilise")
	_expect(screen.scene_file_path == "res://scenes/portrait/messages/MessagesScreen.tscn", "MessagesScreen canonique reutilise")
	screen.queue_free()
	await _frames(2)


func _test_snapshot_restore(sequence: Dictionary) -> void:
	var snapshot_sequence := _snapshot_sequence(sequence)
	_expect(AuthoredValidator.validate(snapshot_sequence)["valid"], "fixture snapshot multi-message valide")
	var environment := _started_environment(snapshot_sequence)
	_expect(not environment.is_empty(), "environnement snapshot cree")
	if environment.is_empty():
		return
	var created: Dictionary = ProjectionAdapter.create(environment["executor"], environment["port"], _metadata())
	if not created["ok"]:
		_expect(false, "adaptateur snapshot cree")
		return
	var adapter = created["adapter"]
	_expect(adapter.open_current_projection()["ok"], "projection snapshot ouverte")
	var notification := {
		"notification_id": "%s::%s" % [THREAD_ID, SECOND_MESSAGE_ID],
		"thread_id": THREAD_ID,
		"message_id": SECOND_MESSAGE_ID,
	}
	_expect(adapter.on_notification_presented(notification)["ok"], "receipt ouvert avant snapshot")
	var runtime_snapshot: Dictionary = environment["executor"].snapshot()
	var adapter_snapshot: Dictionary = adapter.snapshot()
	_expect(runtime_snapshot["ok"] and adapter_snapshot["accepted"], "snapshots runtime et UI acceptes")
	_test_open_message_snapshot_refusals(adapter, adapter_snapshot["snapshot"])
	var restored_port = ProjectionPort.new(snapshot_sequence)
	var restored_executor_result: Dictionary = SequenceExecutor.restore(
		environment["facade"], restored_port, snapshot_sequence, runtime_snapshot["payload"]["snapshot"]
	)
	_expect(restored_executor_result["ok"], "executeur restaure")
	if not restored_executor_result["ok"]:
		return
	var restored_created: Dictionary = ProjectionAdapter.create(
		restored_executor_result["executor"], restored_port, _metadata()
	)
	_expect(restored_created["ok"], "adaptateur de reprise cree")
	if not restored_created["ok"]:
		return
	var restored = restored_created["adapter"]
	_expect(restored.restore(adapter_snapshot["snapshot"])["ok"], "snapshot adaptateur restaure")
	_expect(restored.presentation_source() == adapter.presentation_source(), "source UI restauree exactement")
	_expect(restored_port.snapshot()["snapshot"]["receipts"] == environment["port"].snapshot()["snapshot"]["receipts"], "receipts ouverts restaures par port")
	var restored_screen = MessagesScreenScene.instantiate()
	restored_screen.configure_content_source(restored.presentation_source(), restored)
	restored_screen.runtime_delivery_time_scale = 0.001
	restored_screen.reading_speed_multiplier = 8.0
	add_child(restored_screen)
	await _frames(4)
	_expect(restored_screen.notification_banner_count() == 1, "reprise sans second banner")
	_expect(restored_screen.thread_message_count(THREAD_ID) == 0, "message non presente reste suffixe pending")
	restored_screen.open_thread(THREAD_ID)
	await _frames(2)
	await _wait_for(func(): return not restored_screen.runtime_delivery_active, 240)
	await _frames(3)
	_expect(restored_screen.presentation_count_by_id(MESSAGE_ID) == 1, "reprise sans duplication de bulle")
	_expect(restored_screen.presentation_count_by_id(SECOND_MESSAGE_ID) == 1, "second message restaure sans duplication")
	_expect(restored_screen.describe_state()["typing_instance_count"] == 0, "reprise sans typing residuel")
	await _wait_for(func(): return restored_executor_result["executor"].current_beat().get("type") == "CHOICE", 120)
	await _wait_for(func(): return restored_screen.thread_choice_count(THREAD_ID) == 1, 120)
	var choice_snapshot: Dictionary = restored.snapshot()["snapshot"]
	var forged_choice_ids := choice_snapshot.duplicate(true)
	forged_choice_ids["active"]["choice_ids"] = ["forged_choice"]
	_expect_invalid_snapshot_unchanged(restored, forged_choice_ids, "active.choice_ids CHOICE falsifie")
	var selected: Dictionary = restored.apply_choice(THREAD_ID, CHOICE_ID)
	_expect(selected["accepted"], "choix ferme disponible pour snapshot")
	var closed_snapshot: Dictionary = restored.snapshot()["snapshot"]
	_expect(restored.restore(closed_snapshot)["ok"], "snapshot CHOICE ferme coherent accepte")
	var forged_selected := closed_snapshot.duplicate(true)
	forged_selected["active"]["selected_choice_id"] = "forged_choice"
	_expect_invalid_snapshot_unchanged(restored, forged_selected, "selected_choice_id ferme divergeant")
	var forged_bubble := closed_snapshot.duplicate(true)
	forged_bubble["active"]["player_bubble_id"] = "forged_player_bubble"
	_expect_invalid_snapshot_unchanged(restored, forged_bubble, "player_bubble_id ferme divergeant")
	restored_screen.queue_free()
	await _frames(2)


func _test_open_message_snapshot_refusals(adapter, valid_snapshot: Dictionary) -> void:
	var unknown_thread := valid_snapshot.duplicate(true)
	var injected_thread: Dictionary = unknown_thread["source"]["threads"][0].duplicate(true)
	injected_thread["thread_id"] = "unknown_thread"
	unknown_thread["source"]["threads"].append(injected_thread)
	_expect_invalid_snapshot_unchanged(adapter, unknown_thread, "thread inconnu ajoute")

	var missing_thread := valid_snapshot.duplicate(true)
	missing_thread["source"]["threads"].clear()
	_expect_invalid_snapshot_unchanged(adapter, missing_thread, "thread connu retire")

	var forged_participants := valid_snapshot.duplicate(true)
	forged_participants["source"]["threads"][0]["participant_ids"] = ["sandra"]
	_expect_invalid_snapshot_unchanged(adapter, forged_participants, "participants immuables falsifies")
	var forged_title := valid_snapshot.duplicate(true)
	forged_title["source"]["threads"][0]["title"] = "Forged title"
	_expect_invalid_snapshot_unchanged(adapter, forged_title, "titre immutable falsifie")
	var forged_avatar := valid_snapshot.duplicate(true)
	forged_avatar["source"]["threads"][0]["avatar_ref"] = "X"
	_expect_invalid_snapshot_unchanged(adapter, forged_avatar, "avatar immutable falsifie")

	var unknown_messages_key := valid_snapshot.duplicate(true)
	unknown_messages_key["source"]["messages_by_thread"]["unknown_thread"] = []
	_expect_invalid_snapshot_unchanged(adapter, unknown_messages_key, "cle messages_by_thread inconnue")
	var unknown_choices_key := valid_snapshot.duplicate(true)
	unknown_choices_key["source"]["choices_by_thread"]["unknown_thread"] = []
	_expect_invalid_snapshot_unchanged(adapter, unknown_choices_key, "cle choices_by_thread inconnue")

	var forged_message := valid_snapshot.duplicate(true)
	forged_message["source"]["messages_by_thread"][THREAD_ID][0]["text"] = "Forged text"
	_expect_invalid_snapshot_unchanged(adapter, forged_message, "message authored falsifie")
	var injected_message := valid_snapshot.duplicate(true)
	var fake: Dictionary = injected_message["source"]["messages_by_thread"][THREAD_ID][-1].duplicate(true)
	fake["message_id"] = "injected_message"
	fake["text"] = "Injected text"
	fake["relative_order"] = 2
	injected_message["source"]["messages_by_thread"][THREAD_ID].append(fake)
	injected_message["source"]["threads"][0]["last_preview"] = fake["text"]
	injected_message["source"]["threads"][0]["unread_count"] = 3
	_expect_invalid_snapshot_unchanged(adapter, injected_message, "message injecte refuse")

	var unknown_presented := valid_snapshot.duplicate(true)
	unknown_presented["presented_message_ids_by_thread"][THREAD_ID] = ["unknown_message"]
	_expect_invalid_snapshot_unchanged(adapter, unknown_presented, "ID presente inconnu")
	var wrong_prefix := valid_snapshot.duplicate(true)
	wrong_prefix["presented_message_ids_by_thread"][THREAD_ID] = [SECOND_MESSAGE_ID, MESSAGE_ID]
	_expect_invalid_snapshot_unchanged(adapter, wrong_prefix, "ordre prefixe presente falsifie")

	var forged_active_thread := valid_snapshot.duplicate(true)
	forged_active_thread["active"]["thread_id"] = "unknown_thread"
	_expect_invalid_snapshot_unchanged(adapter, forged_active_thread, "active.thread_id falsifie")
	var forged_message_ids := valid_snapshot.duplicate(true)
	forged_message_ids["active"]["message_ids"] = [SECOND_MESSAGE_ID, MESSAGE_ID]
	_expect_invalid_snapshot_unchanged(adapter, forged_message_ids, "active.message_ids MESSAGE falsifie")


func _expect_invalid_snapshot_unchanged(adapter, candidate: Dictionary, label: String) -> void:
	var before: Dictionary = adapter.snapshot()["snapshot"]
	var refused: Dictionary = adapter.restore(candidate)
	_expect(not refused["ok"] and refused["error_code"] == "INVALID_SNAPSHOT", "%s refuse INVALID_SNAPSHOT" % label)
	_expect(adapter.snapshot()["snapshot"] == before, "%s sans mutation adaptateur" % label)


func _test_preflight_refusals() -> void:
	var base_beat := {
		"beat_id": "probe_message",
		"type": "MESSAGE",
		"content": {
			"thread_id": THREAD_ID,
			"messages": [{
				"message_id": "probe_message_id",
				"author_id": "sandra",
				"text": "Probe",
				"diegetic_at": "2032-03-04T10:01:00+01:00",
				"relative_order": 0,
			}],
		},
		"participant_ids": ["sandra"],
		"projection_target": "MESSAGES",
	}
	_expect_refusal(base_beat.merged({"participant_ids": ["unknown"]}, true), _metadata(), "UNRESOLVED_PARTICIPANT")
	var absent_metadata := _metadata()
	absent_metadata["characters"]["marie"] = {
		"character_id": "marie", "display_name": "Marie", "accent_color": "#4F8BFF", "avatar_ref": "M",
	}
	_expect_refusal(base_beat.merged({"participant_ids": ["marie"]}, true), absent_metadata, "THREAD_NOT_FOUND")
	var ambiguous_metadata := _metadata()
	var duplicate_thread: Dictionary = ambiguous_metadata["threads"][0].duplicate(true)
	duplicate_thread["thread_id"] = "synthetic_n15_thread_duplicate"
	ambiguous_metadata["threads"].append(duplicate_thread)
	_expect_refusal(base_beat, ambiguous_metadata, "AMBIGUOUS_THREAD")
	_expect_refusal(base_beat.merged({"projection_target": "PHYSICAL"}, true), _metadata(), "UNSUPPORTED_TARGET")
	for beat_type in ["AFTERCARE", "RETURN"]:
		var content := {"content_ref": "synthetic_unresolved"}
		if beat_type == "AFTERCARE":
			content["aftercare_id"] = "probe_aftercare"
			content["obligation_id"] = "probe_obligation"
		else:
			content["return_id"] = "probe_return"
		var beat := base_beat.merged({"type": beat_type, "content": content}, true)
		_expect_refusal(beat, _metadata(), "UNRESOLVED_CONTENT_REF")


func _expect_refusal(beat: Dictionary, metadata: Dictionary, error_code: String) -> void:
	var executor := ProjectionProbeExecutor.new(beat)
	var created: Dictionary = ProjectionAdapter.create(executor, ProjectionProbePort.new(), metadata)
	_expect(created["ok"], "probe %s cree" % error_code)
	if not created["ok"]:
		return
	var before: Dictionary = executor.execution_state()
	var result: Dictionary = created["adapter"].open_current_projection()
	_expect(not result["ok"] and result["error_code"] == error_code, "%s explicite" % error_code)
	_expect(executor.open_calls == 0 and executor.execution_state() == before, "%s sans mutation" % error_code)


func _started_environment(sequence: Dictionary) -> Dictionary:
	var environment := _activated_environment(sequence)
	if environment.is_empty():
		return {}
	var created: Dictionary = SequenceExecutor.create(
		environment["facade"], environment["port"], sequence, environment["activation"]
	)
	if not created["ok"]:
		return {}
	var executor = created["executor"]
	if not executor.start()["ok"]:
		return {}
	environment["executor"] = executor
	return environment


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
		"slot_id": "synthetic_n15_2_slot",
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
					"instance_id": "synthetic_n15_2_alternative_instance",
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


func _message_choice_sequence(sequence: Dictionary) -> Dictionary:
	var result := sequence.duplicate(true)
	var kept_beats: Array = []
	for beat in result["beats"]:
		if beat["beat_id"] in ["beat_message", "beat_choice", "beat_return"]:
			kept_beats.append(beat)
	result["beats"] = kept_beats
	for beat in result["beats"]:
		if beat["beat_id"] == "beat_message":
			beat["next"]["beat_id"] = "beat_choice"
	return result


func _snapshot_sequence(sequence: Dictionary) -> Dictionary:
	var result := sequence.duplicate(true)
	for beat in result["beats"]:
		if beat.get("beat_id") != "beat_message":
			continue
		var second_message: Dictionary = beat["content"]["messages"][0].duplicate(true)
		second_message["message_id"] = SECOND_MESSAGE_ID
		second_message["text"] = "Synthetic second snapshot message."
		second_message["diegetic_at"] = "2032-03-04T10:02:00+01:00"
		second_message["relative_order"] = 1
		beat["content"]["messages"].append(second_message)
		break
	return result


func _receipt_for_open(port, kind: String, subject_id: String) -> Dictionary:
	var snapshot: Dictionary = port.snapshot()["snapshot"]
	if snapshot["open_requests"].is_empty():
		return {}
	var request: Dictionary = snapshot["open_requests"][0]
	return {
		"presentation_id": ProjectionContracts.presentation_id_for(request),
		"instance_id": request["instance_id"],
		"sequence_id": request["sequence_id"],
		"authored_version": request["authored_version"],
		"beat_id": request["beat_id"],
		"beat_type": request["beat_type"],
		"projection_target": request["projection_target"],
		"kind": kind,
		"subject_id": subject_id,
	}


func _receipt_count(port, kind: String, subject_id: String) -> int:
	var count := 0
	for receipt in port.snapshot()["snapshot"]["receipts"]:
		if receipt["kind"] == kind and receipt["subject_id"] == subject_id:
			count += 1
	return count


func _execution_receipt_count(executor, kind: String) -> int:
	var count := 0
	for receipt_kind in executor.execution_state()["projection_receipts"].values():
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
		print("R8C_N15_2_MESSAGES_UI_PROJECTION: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error("R8C_N15_2: " + failure)
	get_tree().quit(1)
