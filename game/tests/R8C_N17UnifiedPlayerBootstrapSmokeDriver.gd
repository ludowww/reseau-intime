extends Node

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
const NarrativeMoment := preload(
	"res://scripts/unified_runtime/application/NarrativeMoment.gd"
)
const RuntimeSnapshotV2 := preload(
	"res://scripts/unified_runtime/application/UnifiedRuntimeSnapshotV2.gd"
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
const SaveStore := preload(
	"res://scripts/unified_runtime/application/UnifiedPlayerRuntimeSaveStore.gd"
)
const DurableMediaIdentifier := preload("res://scripts/shared/DurableMediaIdentifier.gd")
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)
const PortraitMainScene := preload("res://scenes/portrait/PortraitMain.tscn")

const SEQUENCE_PATH := "res://data/unified_runtime/sequences/mathilde_returns_with_chosen_intent_01.json"
const MESSAGES_PATH := "res://data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_messages.json"
const PHYSICAL_PATH := "res://data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_physical.json"
const MEDIA_PATH := "res://data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_media.json"
const SAVE_ROOT := "user://r8c_n17_smoke/"

class CountingFacade:
	extends RefCounted

	var delegate
	var resolve_scene_calls := 0

	func _init(value) -> void:
		delegate = value

	func resolve_scene(instance_id: String, choice_id: String, resolution_id: String, context: Dictionary) -> Dictionary:
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
	var validation := AuthoredValidator.validate(sequence, true)
	_expect(
		validation["valid"] and not AuthoredValidator.validate(sequence)["valid"],
		"séquence Mathilde conforme en V2 et refusée par le contrat V1",
	)
	var messages := MessagesResolver.create(sequence, _load(MESSAGES_PATH), true)
	_expect(
		messages["ok"],
		"catalogue AFTERCARE/RETURN conforme: %s" % [messages.get("errors", [])],
	)
	_expect(
		PhysicalResolver.create(sequence, _load(PHYSICAL_PATH), true)["ok"],
		"catalogue Physical conforme",
	)
	_expect(MediaResolver.create(sequence, _load(MEDIA_PATH), true)["ok"], "catalogue Media conforme")
	_expect(
		not SaveStore.create("user://../r8c_n17_escape.json")["ok"],
		"save store refuse la traversée hors user://",
	)
	_expect(
		NarrativeMoment.validate("2032-03-04T21:52:00-05:00")
		and not NarrativeMoment.validate("2032-03-04T21:52:00+14:01"),
		"temps narratif accepte les offsets normalisés signés et borne ±14:00",
	)
	_test_durable_media_identifiers()
	_test_save_recovery()
	_test_resolution_ready_snapshot()
	await _run_paid_path("mathilde_mb3_ma1", "PAID", SAVE_ROOT + "ma1.json")
	await _run_paid_path("mathilde_mb3_ma2", "PAID", SAVE_ROOT + "ma2.json")
	await _run_failed_deferred_path(SAVE_ROOT + "ma3.json")
	if failures.is_empty():
		print("R8C_N17_UNIFIED_PLAYER_BOOTSTRAP: OK (%d controls)" % controls)
		get_tree().quit(0)
	else:
		for failure in failures:
			push_error(failure)
		get_tree().quit(1)


func _load(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return JsonNormalizer.normalize(parsed) if typeof(parsed) == TYPE_DICTIONARY else {}


func _expect(condition: bool, message: String) -> void:
	controls += 1
	if not condition:
		failures.append(message)


func _run_paid_path(choice_id: String, expected_status: String, save_path: String) -> void:
	_remove_smoke_save(save_path)
	var portrait_main = await _new_portrait_main(save_path)
	if portrait_main == null:
		return
	var session = portrait_main.runtime_session
	var reached_choice := await _drive_to_aftercare_choice(portrait_main)
	_expect(reached_choice, "%s atteint MA1/MA2/MA3" % choice_id)
	if not reached_choice:
		print("R8C_N17_PATH_REFUSED: ", choice_id, " ", session.describe_state())
		portrait_main.queue_free()
		await get_tree().process_frame
		return
	var selected: Dictionary = await _select_aftercare_choice(session, choice_id)
	if not selected.get("accepted", false):
		print("R8C_N17_SELECTION_REFUSED: ", choice_id, " ", selected, " ", session.describe_state())
	_expect(selected.get("accepted", false), "%s accepté par l’UI Messages" % choice_id)
	if not selected.get("accepted", false):
		portrait_main.queue_free()
		await get_tree().process_frame
		return
	_expect(
		session.execution_state().get("durable_commit_status") == "APPLIED",
		"%s applique la frontière A10 unique" % choice_id,
	)
	_expect(
		session.durable_state()["narrative_state"]["obligations"]["mathilde_secret_intimacy_aftercare"]["status"] == expected_status,
		"%s crée atomiquement l’obligation %s" % [choice_id, expected_status],
	)
	_expect(_gallery_triplet_valid(session.gallery_source()), "%s débloque une tuile et trois enfants" % choice_id)
	var completed_messages := await _complete_current_messages(session)
	if not completed_messages:
		print("R8C_N17_RETURN_REFUSED: ", choice_id, " ", session.describe_state())
	_expect(completed_messages, "%s présente sa réponse canonique" % choice_id)
	_expect(session.execution_state()["execution_status"] == "COMPLETE", "%s termine la séquence" % choice_id)
	portrait_main.queue_free()
	await get_tree().process_frame
	_remove_smoke_save(save_path)


func _run_failed_deferred_path(save_path: String) -> void:
	_remove_smoke_save(save_path)
	var portrait_main = await _new_portrait_main(save_path)
	if portrait_main == null:
		return
	var session = portrait_main.runtime_session
	_expect(
		session.narrative_time() == "2032-03-04T21:06:00+01:00",
		"runtime démarre au premier moment authored réellement présenté",
	)
	var early_checkpoint := await _present_current_messages_through(
		session, "mathilde_mb3_open_08"
	)
	_expect(early_checkpoint, "messages initiaux présentés jusqu’à 21:08:05")
	_expect(
		session.narrative_time() == "2032-03-04T21:08:05+01:00",
		"temps narratif suit le dernier message initial présenté",
	)
	var early_source: Dictionary = session.presentation_source()
	var early_presented: Dictionary = session.presented_message_ids_by_thread()
	var early_store = SaveStore.create(save_path)["store"]
	var early_snapshot: Dictionary = early_store.load_snapshot()
	_expect(
		early_snapshot["ok"]
		and early_snapshot["snapshot"]["narrative_time"] == "2032-03-04T21:08:05+01:00",
		"snapshot Messages initial ne contient plus 21:52",
	)
	portrait_main.queue_free()
	await get_tree().process_frame
	portrait_main = await _new_portrait_main(save_path)
	if portrait_main == null:
		return
	session = portrait_main.runtime_session
	_expect(
		session.narrative_time() == "2032-03-04T21:08:05+01:00"
		and session.presentation_source() == early_source
		and session.presented_message_ids_by_thread() == early_presented,
		"reload Messages conserve transcript, présentations et temps exacts",
	)
	_expect(await _complete_current_messages(session), "messages d’entrée terminés après reload")
	_expect(
		session.narrative_time() == "2032-03-04T21:14:30+01:00",
		"temps narratif atteint 21:14:30 après les messages d’entrée",
	)
	var reached_choice := await _drive_to_aftercare_choice(portrait_main, false)
	_expect(reached_choice, "MA3 atteint le choix aftercare")
	if not reached_choice:
		portrait_main.queue_free()
		await get_tree().process_frame
		return
	_expect(
		session.narrative_time() == "2032-03-04T21:52:00+01:00",
		"temps narratif atteint 21:52 après l’aftercare commun",
	)
	var choices_before: Array = session.presentation_source()["choices_by_thread"]["mathilde_thread"].duplicate(true)
	_expect(session.save_now()["ok"], "sauvegarde avant choix aftercare")
	portrait_main.queue_free()
	await get_tree().process_frame
	portrait_main = await _new_portrait_main(save_path)
	if portrait_main == null:
		return
	session = portrait_main.runtime_session
	var choices_after: Array = session.presentation_source()["choices_by_thread"]["mathilde_thread"]
	var choice_ids_after: Array = choices_after.map(func(choice): return choice["choice_id"])
	_expect(
		choices_after == choices_before
		and choice_ids_after == ["mathilde_mb3_ma1", "mathilde_mb3_ma2", "mathilde_mb3_ma3"],
		"reload avant choix conserve les trois choix une seule fois",
	)
	var counting_facade := CountingFacade.new(session._facade)
	session._facade = counting_facade
	session._executor._facade = counting_facade
	var selected: Dictionary = await _select_aftercare_choice(session, "mathilde_mb3_ma3")
	_expect(selected.get("accepted", false), "MA3 accepté par l’UI Messages")
	_expect(
		session.execution_state().get("durable_commit_status") == "APPLIED",
		"MA3 applique la frontière A10 unique",
	)
	var durable: Dictionary = session.durable_state()["narrative_state"]
	_expect(
		durable["obligations"]["mathilde_secret_intimacy_aftercare"]["status"] == "FAILED",
		"MA3 crée atomiquement CREATE_FAILED",
	)
	_expect(_gallery_triplet_valid(session.gallery_source()), "MA3 débloque une tuile et trois enfants")
	var committed_domain: Dictionary = session.durable_state()
	var immediate: Dictionary = session.execution_state()
	var immediate_schedule: Dictionary = immediate.get("scheduled_returns", [{}])[0]
	_expect(
		immediate.get("current_beat_id") == "mathilde_mb3_ma3_immediate_return"
		and immediate_schedule.get("delay_mode") == "NONE"
		and immediate_schedule.get("scheduled_from") == "2032-03-04T21:52:00+01:00",
		"MA3 ouvre d’abord le RETURN canonique immédiat",
	)
	_expect(
		await _complete_current_messages(session)
		and _messages_for_beat(session, "mathilde_mb3_ma3_immediate_return").map(
			func(message): return message["text"]
		) == ["Non.", "Pas cette question maintenant.", "Je vais dormir."],
		"réponse immédiate MA3 respecte les trois messages canoniques",
	)
	_expect(
		counting_facade.resolve_scene_calls == 1
		and session.durable_state() == committed_domain
		and session.execution_state().get("durable_commit_status") == "APPLIED",
		"passage au second RETURN conserve exactement un appel A10 et aucun durable muté",
	)
	var pending: Dictionary = session.execution_state()
	var schedule: Dictionary = pending.get("scheduled_returns", [{}])[0]
	_expect(
		pending.get("execution_status") == "RESOLVED_RETURN_PENDING"
		and schedule.get("delay_mode") == "DIEGETIC_MINUTES"
		and schedule.get("scheduled_from") == "2032-03-04T21:52:00+01:00"
		and schedule.get("eligible_at") == "2032-03-05T09:06:00+01:00",
		"MA3 persiste l’éligibilité RETURN calculée une seule fois",
	)
	var store = SaveStore.create(save_path)["store"]
	var stored: Dictionary = store.load_snapshot()
	_expect(
		stored["ok"] and stored["snapshot"]["messages_adapter"]["active"].is_empty(),
		"frontière post-A10 sauvegarde un adapter Messages cohérent",
	)
	if stored["ok"]:
		var tampered: Dictionary = stored["snapshot"].duplicate(true)
		tampered["execution"]["scheduled_returns"][0]["resolution_id"] = "mathilde_mb3_ma1_resolution"
		_expect(
			not RuntimeSnapshotV2.validate(tampered, _load(SEQUENCE_PATH))["valid"],
			"snapshot V2 refuse un schedule RETURN lié à une autre résolution",
		)
		var tampered_origin: Dictionary = stored["snapshot"].duplicate(true)
		tampered_origin["execution"]["scheduled_returns"][0]["scheduled_from"] = "2032-03-04T20:52:00+01:00"
		tampered_origin["execution"]["scheduled_returns"][0]["eligible_at"] = "2032-03-05T08:06:00+01:00"
		_expect(
			not RuntimeSnapshotV2.validate(tampered_origin, _load(SEQUENCE_PATH))["valid"],
			"snapshot V2 lie le schedule RETURN au moment durable A10",
		)
		var delayed_chain_sequence: Dictionary = _load(SEQUENCE_PATH)
		for beat in delayed_chain_sequence["beats"]:
			if beat["beat_id"] == "mathilde_mb3_ma3_immediate_return":
				beat["content"]["delay"] = {"mode": "DIEGETIC_MINUTES", "value": 5}
		var delayed_chain_snapshot: Dictionary = stored["snapshot"].duplicate(true)
		delayed_chain_snapshot["narrative_time"] = "2032-03-04T21:57:00+01:00"
		delayed_chain_snapshot["execution"]["scheduled_returns"][0]["scheduled_from"] = "2032-03-04T21:57:00+01:00"
		delayed_chain_snapshot["execution"]["scheduled_returns"][0]["eligible_at"] = "2032-03-05T09:11:00+01:00"
		_expect(
			RuntimeSnapshotV2.validate(delayed_chain_snapshot, delayed_chain_sequence)["valid"],
			"snapshot V2 dérive l’origine d’un maillon après un RETURN retardé",
		)
	portrait_main.queue_free()
	await get_tree().process_frame
	portrait_main = await _new_portrait_main(save_path)
	if portrait_main == null:
		return
	session = portrait_main.runtime_session
	_expect(session.execution_state()["scheduled_returns"] == pending["scheduled_returns"], "reload conserve exactement le RETURN différé")
	_expect(session.durable_state() == committed_domain, "reload après commit ne rappelle jamais A10")
	_expect(session.advance_narrative_time("2032-03-05T09:05:00+01:00")["ok"], "temps narratif explicite avance à 09:05")
	_expect(session.execution_state()["execution_status"] == "RESOLVED_RETURN_PENDING", "RETURN invisible à 09:05")
	portrait_main.queue_free()
	await get_tree().process_frame
	portrait_main = await _new_portrait_main(save_path)
	if portrait_main == null:
		return
	session = portrait_main.runtime_session
	_expect(session.execution_state()["scheduled_returns"] == pending["scheduled_returns"], "second reload conserve le schedule")
	var advanced: Dictionary = session.advance_narrative_time("2032-03-05T09:06:00+01:00")
	if not advanced["ok"]:
		print("R8C_N17_0906_REFUSED: ", advanced, " ", session.describe_state())
	_expect(advanced["ok"], "temps narratif explicite atteint 09:06")
	await _frames(2)
	_expect(session.execution_state()["execution_status"] == "WAITING_FOR_PROJECTION_ACK", "RETURN devient visible exactement à 09:06")
	_expect(await _complete_current_messages(session), "RETURN J12 canonique présenté")
	_expect(session.execution_state()["execution_status"] == "COMPLETE", "MA3 termine après le RETURN")
	portrait_main.queue_free()
	await get_tree().process_frame
	_remove_smoke_save(save_path)


func _new_portrait_main(save_path: String):
	var portrait_main = PortraitMainScene.instantiate()
	portrait_main.unified_save_path_override = save_path
	add_child(portrait_main)
	await _frames(3)
	_expect(portrait_main.runtime_session != null, "PortraitMain compose la session unifiée réelle")
	if portrait_main.runtime_session == null:
		portrait_main.queue_free()
		await get_tree().process_frame
		return null
	portrait_main.shell.messages_screen.runtime_delivery_time_scale = 0.001
	return portrait_main


func _drive_to_aftercare_choice(portrait_main, complete_opening := true) -> bool:
	var session = portrait_main.runtime_session
	if complete_opening and not await _complete_current_messages(session):
		return false
	if not await _continue_physical(portrait_main):
		return false
	if not await _continue_physical(portrait_main):
		return false
	for _index in range(3):
		if not await _continue_media(portrait_main):
			return false
	if not await _complete_current_messages(session):
		return false
	return (
		await _wait_for_status(session, "WAITING_FOR_PROJECTION_ACK")
		and not session.presentation_source().get("choices_by_thread", {}).get(
			"mathilde_thread", []
		).is_empty()
	)


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
	var presented: Dictionary = session.presented_message_ids_by_thread()
	var presented_in_thread: Array = presented.get(thread_id, [])
	for message in active_messages:
		if message["message_id"] in presented_in_thread:
			continue
		if not session.mark_message_presented(str(message["message_id"])):
			print("R8C_N17_MESSAGE_PRESENT_REFUSED: ", message["message_id"], " ", session.describe_state())
			return false
	var result: Dictionary = session.on_thread_read(thread_id, str(active_messages[-1]["message_id"]))
	if not result.get("ok", false):
		print("R8C_N17_THREAD_READ_REFUSED: ", result, " ", session.describe_state())
		return false
	await _frames(3)
	return true


func _present_current_messages_through(session, terminal_message_id: String) -> bool:
	if not await _wait_for_status(session, "WAITING_FOR_PROJECTION_ACK"):
		return false
	var beat_id: String = session.execution_state()["current_beat_id"]
	var messages := _messages_for_beat(session, beat_id)
	for message in messages:
		if not session.mark_message_presented(str(message["message_id"])):
			return false
		if str(message["message_id"]) == terminal_message_id:
			return true
	return false


func _messages_for_beat(session, beat_id: String) -> Array:
	var result: Array = []
	var source: Dictionary = session.presentation_source()
	for thread_id in source.get("messages_by_thread", {}):
		for message in source["messages_by_thread"][thread_id]:
			if str(message.get("beat_id", "")) == beat_id:
				result.append(message)
	return result


func _continue_physical(portrait_main) -> bool:
	var session = portrait_main.runtime_session
	if not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	var prior_beat_id: String = session.execution_state().get("current_beat_id", "")
	var button = portrait_main.shell.messages_screen.find_child("PhysicalContinue", true, false)
	if button == null or not button.visible:
		return false
	button.emit_signal("pressed")
	await _frames(3)
	return session.execution_state().get("current_beat_id") != prior_beat_id


func _continue_media(portrait_main) -> bool:
	var session = portrait_main.runtime_session
	if not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	var prior_beat_id: String = session.execution_state().get("current_beat_id", "")
	var viewer = portrait_main.shell.photo_viewer
	if viewer == null or not viewer.visible or viewer.back_button == null:
		return false
	viewer.back_button.emit_signal("pressed")
	await _frames(3)
	return session.execution_state().get("current_beat_id") != prior_beat_id


func _select_aftercare_choice(session, choice_id: String) -> Dictionary:
	var source: Dictionary = session.presentation_source()
	var choices: Array = source["choices_by_thread"].get("mathilde_thread", [])
	var choice_ids: Array = []
	for choice in choices:
		choice_ids.append(choice["choice_id"])
	var presented: Dictionary = session.on_choices_presented("mathilde_thread", choice_ids)
	if not presented.get("ok", false):
		return {"accepted": false, "error_code": presented.get("error_code")}
	var selected: Dictionary = session.apply_choice("mathilde_thread", choice_id)
	if not selected.get("accepted", false):
		return selected
	for bubble in selected.get("new_messages", []):
		session.mark_message_presented(str(bubble["message_id"]))
	session.mark_thread_batch_presented("mathilde_thread")
	await _frames(3)
	return selected


func _gallery_triplet_valid(source: Dictionary) -> bool:
	if source.get("character_order") != ["mathilde"]:
		return false
	var items: Array = source.get("fixtures", {}).get("mathilde", {}).get("items", [])
	if items.size() != 1 or items[0].get("thumbnail_label") != "Moment vécu":
		return false
	return items[0].get("sequence_child_ids") == [
		"S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY",
		"S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01",
		"S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01",
	]


func _test_resolution_ready_snapshot() -> void:
	var sequence := _load(SEQUENCE_PATH)
	var graph: Dictionary = CompositionRoot._new_domain_graph(sequence)
	_expect(not graph.is_empty(), "graphe A6/A10 direct créé")
	if graph.is_empty():
		return
	var activation: Dictionary = CompositionRoot._activate_sequence(graph["facade"], sequence)
	var port_result: Dictionary = _projection_port(sequence)
	_expect(activation.get("ok", false) and port_result.get("ok", false), "activation et port V2 directs créés")
	if not activation.get("ok", false) or not port_result.get("ok", false):
		return
	var created: Dictionary = ExecutorV2.create(
		graph["facade"], port_result["port"], sequence, activation
	)
	_expect(created["ok"] and created["executor"].start()["ok"], "executor V2 direct démarré")
	if not created["ok"]:
		return
	var executor = created["executor"]
	for _index in range(16):
		if executor.execution_state()["execution_status"] == "RESOLUTION_READY":
			break
		var beat: Dictionary = executor.current_beat()
		var opened: Dictionary = executor.open_current_projection()
		if not opened["ok"]:
			break
		var request: Dictionary = opened["payload"]["request"]
		var receipt := {
			"presentation_id": ProjectionContracts.presentation_id_for(request),
			"instance_id": request["instance_id"],
			"sequence_id": request["sequence_id"],
			"authored_version": request["authored_version"],
			"beat_id": request["beat_id"],
			"beat_type": request["beat_type"],
			"projection_target": request["projection_target"],
			"kind": "VIEWED" if beat["type"] == "MEDIA_REVEAL" else "PRESENTED",
			"subject_id": beat["content"]["media_id"] if beat["type"] == "MEDIA_REVEAL" else beat["beat_id"],
		}
		if not executor.receive_ack(receipt)["ok"]:
			break
		var is_choice: bool = beat["type"] == "CHOICE"
		var command := {
			"command_id": "n17_resolution_ready_" + beat["beat_id"],
			"instance_id": request["instance_id"],
			"beat_id": beat["beat_id"],
			"kind": "SELECT_CHOICE" if is_choice else "CONTINUE",
			"choice_id": "mathilde_mb3_ma3" if is_choice else null,
		}
		if not executor.receive_command(command)["ok"]:
			break
	var ready: Dictionary = executor.execution_state()
	_expect(
		ready["execution_status"] == "RESOLUTION_READY"
		and ready["selected_resolution_id"] == "resolution_ma3"
		and ready["consumed_choice_ids"] == ["mathilde_mb3_ma3"],
		"frontière executor V2 consomme le choix avant commit",
	)
	var snapshot_result: Dictionary = executor.snapshot(
		_empty_messages_snapshot(), "2032-03-04T21:52:00+01:00"
	)
	_expect(snapshot_result["ok"], "snapshot V2 accepté à RESOLUTION_READY")
	if not snapshot_result["ok"]:
		return
	var restore_graph: Dictionary = CompositionRoot._new_domain_graph(sequence)
	var restore_port: Dictionary = _projection_port(sequence)
	var restored: Dictionary = ExecutorV2.restore(
		restore_graph["facade"], restore_port["port"], sequence,
		snapshot_result["payload"]["snapshot"]
	)
	_expect(
		restored["ok"]
		and restored["executor"].execution_state() == ready
		and restored["narrative_time"] == "2032-03-04T21:52:00+01:00",
		"restore RESOLUTION_READY conserve sélection et temps exacts",
	)
	if not restored["ok"]:
		return
	var counting_facade := CountingFacade.new(restore_graph["facade"])
	restored["executor"]._facade = counting_facade
	var commit_context := {
		"moment_diegetique": "2032-03-04T21:52:00+01:00",
		"acte_courant": "MATHILDE_M_B3_CANONICAL",
		"participants_disponibles": {"mathilde": true, "player": true},
		"opportunite_valide": true,
	}
	var committed: Dictionary = restored["executor"].commit_resolution(commit_context)
	var replayed: Dictionary = restored["executor"].commit_resolution(commit_context)
	_expect(
		committed["ok"]
		and committed["payload"]["a10_result"]["transaction_status"] == "APPLIQUE",
		"restore RESOLUTION_READY applique A10",
	)
	_expect(
		replayed["ok"] and replayed["idempotent"] and counting_facade.resolve_scene_calls == 1,
		"commit V2 rejoué ne rappelle pas resolve_scene après l’unique appel A10",
	)


func _projection_port(sequence: Dictionary) -> Dictionary:
	return CompositePort.create(MessagesPhysicalPort.new(sequence, true), MediaPort.new(sequence, true))


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


func _test_durable_media_identifiers() -> void:
	for media_id in [
		"normal_media_identifier",
		"S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY",
		"S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01",
		"S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01",
	]:
		_expect(DurableMediaIdentifier.validate(media_id), "media_id canonique accepté: " + media_id)
	for media_id in [
		"new_j11_media", "new_J11_media", "J11_NEW_MEDIA", "SOMETHING_J12_NEW",
		"chapter_11_media", "CHAPTER_11_NEW_MEDIA",
	]:
		_expect(not DurableMediaIdentifier.validate(media_id), "media_id jour refusé: " + media_id)
	for media_id in [
		"S2_A3_J11_SCN_MEDIA", "S1_A03_J11_SCN_MEDIA", "S1_A3_J1_SCN_MEDIA",
		"S1_A3_J11_SCENE_MEDIA", "S1_A3_J11_SCN_media", "S1_A3_J11_SCN__MEDIA",
		"ARBITRARY_UPPERCASE_MEDIA",
	]:
		_expect(not DurableMediaIdentifier.validate(media_id), "famille legacy mal formée refusée: " + media_id)


func _wait_for_status(session, expected: String, max_frames := 30) -> bool:
	for _index in range(max_frames):
		if session.execution_state().get("execution_status") == expected:
			return true
		await get_tree().process_frame
	return false


func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame


func _test_save_recovery() -> void:
	var save_path := SAVE_ROOT + "recovery.json"
	_remove_smoke_save(save_path)
	var store_result := SaveStore.create(save_path)
	_expect(store_result["ok"], "save store de récupération créé")
	if not store_result["ok"]:
		return
	var store = store_result["store"]
	_expect(store.save_snapshot({"probe": 17})["ok"], "save temporaire vérifiée et remplacée")
	var backup_path := save_path + ".previous"
	var moved := DirAccess.rename_absolute(
		ProjectSettings.globalize_path(save_path), ProjectSettings.globalize_path(backup_path)
	) == OK
	_expect(moved, "fixture simule une interruption entre backup et replace")
	if moved:
		var recovered: Dictionary = store.load_snapshot()
		_expect(
			recovered["ok"]
			and recovered["snapshot"] == {"probe": 17}
			and FileAccess.file_exists(save_path),
			"démarrage récupère et promeut automatiquement le backup valide",
		)
	_remove_smoke_save(save_path)


func _remove_smoke_save(save_path: String) -> void:
	for suffix in ["", ".tmp", ".previous", ".corrupt"]:
		var path: String = save_path + suffix
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
