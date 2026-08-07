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
const SaveStore := preload(
	"res://scripts/unified_runtime/application/UnifiedPlayerRuntimeSaveStore.gd"
)
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)
const PortraitMainScene := preload("res://scenes/portrait/PortraitMain.tscn")

const SEQUENCE_PATH := "res://data/unified_runtime/sequences/mathilde_returns_with_chosen_intent_01.json"
const MESSAGES_PATH := "res://data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_messages.json"
const PHYSICAL_PATH := "res://data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_physical.json"
const MEDIA_PATH := "res://data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_media.json"
const SAVE_ROOT := "user://r8c_n17_smoke/"

var failures: Array[String] = []
var controls := 0


func _ready() -> void:
	var sequence := _load(SEQUENCE_PATH)
	var validation := AuthoredValidator.validate(sequence)
	_expect(validation["valid"], "séquence Mathilde conforme: %s" % [validation["errors"]])
	var messages := MessagesResolver.create(sequence, _load(MESSAGES_PATH))
	_expect(
		messages["ok"],
		"catalogue AFTERCARE/RETURN conforme: %s" % [messages.get("errors", [])],
	)
	_expect(PhysicalResolver.create(sequence, _load(PHYSICAL_PATH))["ok"], "catalogue Physical conforme")
	_expect(MediaResolver.create(sequence, _load(MEDIA_PATH))["ok"], "catalogue Media conforme")
	_expect(
		not SaveStore.create("user://../r8c_n17_escape.json")["ok"],
		"save store refuse la traversée hors user://",
	)
	_expect(
		NarrativeMoment.validate("2032-03-04T21:52:00-05:00")
		and not NarrativeMoment.validate("2032-03-04T21:52:00+14:01"),
		"temps narratif accepte les offsets normalisés signés et borne ±14:00",
	)
	_test_save_recovery()
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
	var reached_choice := await _drive_to_aftercare_choice(portrait_main)
	_expect(reached_choice, "MA3 atteint le choix aftercare")
	if not reached_choice:
		portrait_main.queue_free()
		await get_tree().process_frame
		return
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
	var committed_domain: Dictionary = session.durable_state()
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


func _drive_to_aftercare_choice(portrait_main) -> bool:
	var session = portrait_main.runtime_session
	if not await _complete_current_messages(session):
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
	for message in active_messages:
		if not session.mark_message_presented(str(message["message_id"])):
			return false
	var result: Dictionary = session.on_thread_read(thread_id, str(active_messages[-1]["message_id"]))
	if not result.get("ok", false):
		return false
	await _frames(3)
	return true


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
