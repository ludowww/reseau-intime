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
const SeasonRunner := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonRunner.gd"
)
const SaveStore := preload(
	"res://scripts/unified_runtime/application/UnifiedPlayerRuntimeSaveStore.gd"
)
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)

const SEQUENCE_PATH := (
	"res://data/unified_runtime/sequences/sandra_kept_lunch_photo_01.json"
)
const MESSAGES_PATH := (
	"res://data/unified_runtime/presentation/sandra_kept_lunch_photo_01_messages.json"
)
const PHYSICAL_PATH := (
	"res://data/unified_runtime/presentation/sandra_kept_lunch_photo_01_physical.json"
)
const MEDIA_PATH := (
	"res://data/unified_runtime/presentation/sandra_kept_lunch_photo_01_media.json"
)
const OA01_BASELINE_CATALOG_PATH := (
	"res://tests/fixtures/unified_runtime/s1_oa01_baseline_catalog.json"
)
const MARIE_SEQUENCE_ID := "marie_bread_and_ten_minutes_01"
const SEQUENCE_ID := "sandra_kept_lunch_photo_01"
const MEDIA_ID := "s1_opening_sandra_lunch_selected_01"
const TRACE_ID := "sandra_kept_lunch_photo_private_trace"
const KNOWLEDGE_ID := "fact_player_saw_sandra_lunch_photo"
const OA01_FINGERPRINT := "13933f53a12cd8665a78e6f1714ef47627d7768c4087b18fdf43ea43e931ed57"
const SAVE_ROOT := "user://s1_oa02_smoke/"

const POST_GUIDED := [
	"Merci. Je vais pas lui faire dire plus que ça.",
	"On s'arrête là pour ce soir ? Bonne nuit Sandra.",
]
const POSTURE_FACTS := [
	"sandra_kept_photo_warmly_received",
	"sandra_photo_choice_intention_noticed",
	"sandra_photo_memory_acknowledged_without_escalation",
]
const BRANCHES := [
	{
		"name": "WARM",
		"choice_id": "sandra_kept_photo_warm",
		"resolution_id": "resolution_warm",
		"posture_fact": "sandra_kept_photo_warmly_received",
		"return_id": "return_warm",
		"return_text": [
			"C'est gentil.",
			"Et presque raisonnable. Ne gâchons pas tout de suite.",
			"Je vais te laisser. Je travaille tôt demain.",
			"J'ai déjà passé trop de temps à choisir une photo que j'avais soi-disant juste retrouvée.",
			"Merci. Je vais pas lui faire dire plus que ça.",
			"Bien.",
			"On va dire que c'était sans conséquence.",
			"On s'arrête là pour ce soir ? Bonne nuit Sandra.",
			"Oui. Pour ce soir.",
			"Bonne nuit, Player 🙂",
		],
	},
	{
		"name": "PRECISE",
		"choice_id": "sandra_photo_intention_noticed",
		"resolution_id": "resolution_precise",
		"posture_fact": "sandra_photo_choice_intention_noticed",
		"return_id": "return_precise",
		"return_text": [
			"Haha.",
			"Je n'ai pas dit que c'était pour le sourire.",
			"Mais je n'ai pas choisi au hasard non plus.",
			"Je vais te laisser. Je travaille tôt demain.",
			"J'ai déjà passé trop de temps à choisir une photo que j'avais soi-disant juste retrouvée.",
			"Merci. Je vais pas lui faire dire plus que ça.",
			"Bien.",
			"On va dire que c'était sans conséquence.",
			"On s'arrête là pour ce soir ? Bonne nuit Sandra.",
			"Oui. Pour ce soir.",
			"Et pour la photo... je n'ai pas choisi celle-là au hasard.",
			"Bonne nuit, Player 🙂",
		],
	},
	{
		"name": "CAUTIOUS",
		"choice_id": "sandra_photo_memory_contained",
		"resolution_id": "resolution_cautious",
		"posture_fact": "sandra_photo_memory_acknowledged_without_escalation",
		"return_id": "return_cautious",
		"return_text": [
			"Réponse prudente.",
			"Ce n'est pas mal. Juste un peu propre.",
			"Je vais te laisser. Je travaille tôt demain.",
			"J'ai déjà passé trop de temps à choisir une photo que j'avais soi-disant juste retrouvée.",
			"Merci. Je vais pas lui faire dire plus que ça.",
			"Bien.",
			"On va dire que c'était sans conséquence.",
			"On s'arrête là pour ce soir ? Bonne nuit Sandra.",
			"Oui. Pour ce soir.",
			"Bonne nuit, Player 🙂",
		],
	},
]


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


class TestRuntimeHost:
	var shell
	var season_runner
	var runtime_session

	func queue_free() -> void:
		if shell != null:
			shell.queue_free()


var failures: Array[String] = []
var controls := 0


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(SAVE_ROOT))
	_test_closed_contracts()
	for index in BRANCHES.size():
		await _test_production_branch(BRANCHES[index], index == 0)
	await _test_oa01_catalog_snapshot_refusal()
	_print_narrative_review()
	await _frames(3)
	if failures.is_empty():
		print("S1_OA02_SANDRA_KEPT_LUNCH_PHOTO: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)


func _test_closed_contracts() -> void:
	var sequence := _load(SEQUENCE_PATH)
	var authored: Dictionary = AuthoredValidator.validate(sequence, true)
	var messages: Dictionary = MessagesResolver.create(sequence, _load(MESSAGES_PATH), true)
	var physical: Dictionary = PhysicalResolver.create(sequence, _load(PHYSICAL_PATH), true)
	var media: Dictionary = MediaResolver.create(sequence, _load(MEDIA_PATH), true)
	_expect(authored["valid"], "séquence OA02 conforme: %s" % [authored.get("errors", [])])
	_expect(messages["ok"], "RETURN OA02 conforme: %s" % [messages.get("errors", [])])
	_expect(physical["ok"], "PHYSICAL OA02 conforme: %s" % [physical.get("errors", [])])
	_expect(media["ok"], "média OA02 conforme: %s" % [media.get("errors", [])])
	var guided := [
		sequence["resolutions"]["resolution_photo_subject_guided"],
		sequence["resolutions"]["resolution_photo_kept_guided"],
	]
	var local_only := true
	for resolution in guided:
		local_only = (
			local_only
			and resolution["a10_choice_id"] == null
			and resolution["a10_resolution_id"] == null
			and resolution["event_refs"].is_empty()
		)
	_expect(local_only, "deux guided locals ont zéro A10")
	_expect(
		sequence["media"].keys() == [MEDIA_ID]
		and sequence["media"][MEDIA_ID]["removal_policy"] == "AUTHORED_RESOLUTION_ONLY",
		"MEDIA_REVEAL canonique unique et retrait authored",
	)


func _test_production_branch(branch: Dictionary, deep_restore: bool) -> void:
	var save_path: String = SAVE_ROOT + str(branch["name"]).to_lower() + ".json"
	_remove_save(save_path)
	var main = await _new_production_main(save_path, true)
	if main == null:
		return
	var runner = main.season_runner
	var session = main.runtime_session
	_expect(
		runner.catalog["manifest"]["packages"].size() == 2
		and runner.active_sequence_id == MARIE_SEQUENCE_ID
		and _visible_threads(main) == ["marie_thread"]
		and _gallery_media_count(runner.gallery_source(), MEDIA_ID) == 0,
		"fresh boot montre Marie seule " + branch["name"],
	)
	_expect(await _complete_oa01(main), "OA01 Marie atteint COMPLETE " + branch["name"])
	await _frames(4)
	runner = main.season_runner
	var before_activation: Dictionary = runner.catalog["facade"].save_state()
	_expect(
		runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
		and runner.active_session == null
		and runner.active_sequence_id.is_empty()
		and runner.completed_sequence_ids == [MARIE_SEQUENCE_ID]
		and runner.describe_state().get("opportunity", {}).get("sequence_id") == SEQUENCE_ID
		and runner.describe_state().get("opportunity", {}).get("action_label")
		== "Continuer avec Sandra"
		and _offered_thread(runner.presentation_source(), "sandra_thread", "Continuer avec Sandra"),
		"OA01 COMPLETE expose Continuer avec Sandra " + branch["name"],
	)
	_expect(
		_instance_count(runner, SEQUENCE_ID) == 0
		and not JSON.stringify(before_activation).contains(TRACE_ID)
		and not JSON.stringify(before_activation).contains(KNOWLEDGE_ID)
		and not JSON.stringify(before_activation).contains(MEDIA_ID),
		"zéro A5 Sandra avant activation et zéro durable Sandra " + branch["name"],
	)

	await _dispose_main(main)
	main = await _new_production_main(save_path, false)
	if main == null:
		return
	runner = main.season_runner
	_expect(
		runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
		and runner.completed_sequence_ids == [MARIE_SEQUENCE_ID]
		and runner.describe_state().get("opportunity", {}).get("sequence_id") == SEQUENCE_ID
		and _instance_count(runner, SEQUENCE_ID) == 0
		and runner.catalog["facade"].save_state() == before_activation,
		"save/reload reconstruit l'opportunité Sandra sans A5 " + branch["name"],
	)

	var activated: Dictionary = runner.activate_opportunity("sandra_thread")
	await _frames(5)
	session = main.runtime_session
	_expect(
		activated.get("ok", false)
		and runner.status() == SeasonRunner.ACTIVE_SEQUENCE
		and runner.active_sequence_id == SEQUENCE_ID
		and session != null
		and _instance_count(runner, SEQUENCE_ID) == 1
		and runner.not_selected_sequence_ids.is_empty(),
		"clic Sandra crée une seule A5 sans not_selected " + branch["name"],
	)
	if session == null:
		await _dispose_main(main)
		_remove_save(save_path)
		return

	_expect(
		_texts_for_beat(session, "sandra_photo_reappearance")
		== ["Je tombe peut-être mal.", "Mais j'ai retrouvé une photo."],
		"ouverture Sandra exacte " + branch["name"],
	)
	_expect(await _complete_current_messages(session), "ouverture Sandra présentée " + branch["name"])
	var local_one := await _select_choice(
		session, "sandra_thread", "sandra_photo_subject_guided_reply"
	)
	_expect(
		local_one.get("accepted", false)
		and session.execution_state()["durable_commit_status"] == "NOT_REQUESTED"
		and not JSON.stringify(session.durable_state()).contains(TRACE_ID),
		"guided 1 a zéro A10 " + branch["name"],
	)
	_expect(
		_texts_for_beat(session, "sandra_last_lunch_context") == [
			"De notre dernier déjeuner.",
			"Deux verres, un coin de table, et moi un peu de travers sur le bord.",
		]
		and await _complete_current_messages(session),
		"dernier déjeuner exact " + branch["name"],
	)
	_expect(
		_gallery_media_count(session.gallery_source(), MEDIA_ID) == 0,
		"aucun tile Sandra avant MEDIA_REVEAL " + branch["name"],
	)
	_expect(await _complete_current_media(session), "MEDIA_REVEAL présenté " + branch["name"])
	var local_two := await _select_choice(
		session, "sandra_thread", "sandra_photo_kept_guided_reply"
	)
	_expect(
		local_two.get("accepted", false)
		and session.execution_state()["durable_commit_status"] == "NOT_REQUESTED"
		and not JSON.stringify(session.durable_state()).contains(TRACE_ID),
		"guided 2 a zéro A10 " + branch["name"],
	)
	_expect(
		_texts_for_beat(session, "sandra_photo_selection_context") == [
			"Oui.",
			"Je l'avais revue après, puis gardée dans un dossier à part.",
			"J'ai imprimé quelques photos après mon poste. Celle-là aussi.",
			"Et j'ai recadré un peu avant de te l'envoyer.",
			"SentryCore a fait semblant de coopérer. Un ticket fantôme, quand même.",
		]
		and await _complete_current_messages(session),
		"contexte gardé et recadré exact " + branch["name"],
	)

	var counter := CountingFacade.new(session._facade)
	session._facade = counter
	session._executor._facade = counter
	var selected := await _select_choice(session, "sandra_thread", branch["choice_id"])
	var durable: Dictionary = session.durable_state()
	_expect(
		selected.get("accepted", false)
		and counter.resolve_scene_calls == 1
		and _durable_has_exact_branch(durable, branch["posture_fact"]),
		"exactement un A10 Sandra publie trace connaissance média et fait " + branch["name"],
	)
	_expect(
		_gallery_media_count(session.gallery_source(), MEDIA_ID) == 1
		and _gallery_has_sandra_placeholder(session.gallery_source()),
		"un seul média Sandra disponible après résolution " + branch["name"],
	)
	_expect(
		session.execution_state()["current_beat_id"] == branch["return_id"]
		and _texts_for_beat(session, branch["return_id"]) == branch["return_text"]
		and _return_player_lines(session, branch["return_id"]) == POST_GUIDED,
		"RETURN exact avec deux guided devenus messages " + branch["name"],
	)

	if deep_restore:
		main = await _reload_active(
			main, save_path, branch["return_id"], branch["resolution_id"], "pendant RETURN Sandra"
		)
		if main == null:
			_remove_save(save_path)
			return
		session = main.runtime_session
		_expect(
			session.durable_state() == durable
			and _gallery_media_count(session.gallery_source(), MEDIA_ID) == 1,
			"reload RETURN ne rejoue pas A10 et ne duplique pas le média",
		)

	_expect(await _complete_current_messages(session), "RETURN présenté " + branch["name"])
	_expect(
		session.execution_state()["current_beat_id"] == "sandra_photo_return_to_marie"
		and _load(PHYSICAL_PATH)["entries"][0]["body"]
		== "Player pose le téléphone et revient vers Marie."
		and _load(PHYSICAL_PATH)["entries"][0]["steps"]
		== ["La fin de soirée se déroule hors écran."],
		"Player pose le téléphone et revient vers Marie. " + branch["name"],
	)
	var before_physical: Dictionary = session.durable_state()
	_expect(await _continue_physical(main), "PHYSICAL Marie continué " + branch["name"])
	await _frames(5)
	runner = main.season_runner
	_expect(
		runner.status() == SeasonRunner.IDLE_NO_ELIGIBLE_SEQUENCE
		and runner.active_session == null
		and runner.completed_sequence_ids == [MARIE_SEQUENCE_ID, SEQUENCE_ID]
		and runner.catalog["facade"].save_state() == before_physical
		and _gallery_media_count(runner.gallery_source(), MEDIA_ID) == 1
		and _messages_have_unique_ids(runner.presentation_source()),
		"COMPLETE puis final IDLE sans OA03 " + branch["name"],
	)

	await _dispose_main(main)
	main = await _new_production_main(save_path, false)
	if main != null:
		_expect(
			main.season_runner.status() == SeasonRunner.IDLE_NO_ELIGIBLE_SEQUENCE
			and main.season_runner.completed_sequence_ids == [MARIE_SEQUENCE_ID, SEQUENCE_ID]
			and main.runtime_session == null
			and _gallery_media_count(main.season_runner.gallery_source(), MEDIA_ID) == 1
			and _messages_have_unique_ids(main.season_runner.presentation_source()),
			"reload COMPLETE reste IDLE et idempotent " + branch["name"],
		)
		await _dispose_main(main)
	_remove_save(save_path)


func _complete_oa01(main) -> bool:
	var session = main.runtime_session
	if session == null or session.execution_state().get("sequence_id") != MARIE_SEQUENCE_ID:
		return false
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "marie_thread", "marie_optimism_guided_reply")).get("accepted", false):
		return false
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "marie_thread", "marie_crisis_guided_reply")).get("accepted", false):
		return false
	if not await _complete_current_messages(session):
		return false
	if not (await _select_choice(session, "marie_thread", "marie_shared_evening_present")).get("accepted", false):
		return false
	if not await _complete_current_messages(session):
		return false
	if not await _continue_physical(main):
		return false
	await _frames(5)
	return (
		main.season_runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
		and main.season_runner.completed_sequence_ids == [MARIE_SEQUENCE_ID]
	)


func _test_oa01_catalog_snapshot_refusal() -> void:
	var baseline_save := SAVE_ROOT + "oa01_baseline_snapshot.json"
	var refusal_path := SAVE_ROOT + "oa01_snapshot_against_oa02.json"
	_remove_save(baseline_save)
	_remove_save(refusal_path)

	var shell = PortraitShellScene.instantiate()
	shell.content_mode = "unified"
	add_child(shell)
	await _frames(3)
	var created: Dictionary = SeasonRunner.create_for_test(
		OA01_BASELINE_CATALOG_PATH, shell, baseline_save
	)
	_expect(
		created.get("ok", false),
		"runner réel OA01 baseline créé depuis 9672551: %s" % created.get("error_code"),
	)
	if not created.get("ok", false):
		shell.queue_free()
		return
	var old_runner = created["runner"]
	var old_session = old_runner.active_session
	_expect(old_runner.begin()["ok"] and old_session != null, "OA01 baseline démarrée")
	if old_session == null:
		shell.queue_free()
		return
	_expect(old_session.save_now()["ok"], "vrai snapshot Saison OA01 sauvegardé")
	var loaded: Dictionary = SaveStore.create(baseline_save)["store"].load_snapshot()
	var snapshot: Dictionary = loaded.get("snapshot", {})
	_expect(
		loaded.get("ok", false)
		and snapshot.get("schema_id") == "reseau_intime.unified_season"
		and snapshot.get("schema_version") == 2
		and snapshot.get("catalog_fingerprint") == OA01_FINGERPRINT,
		"snapshot OA01 baseline porte le fingerprint exact",
	)
	_expect(
		SaveStore.create(refusal_path)["store"].save_snapshot(snapshot)["ok"],
		"snapshot OA01 installé contre OA02",
	)
	old_session.detach()
	if old_session._save_store != null and old_session._save_store.has_method("release"):
		old_session._save_store.release()
	old_runner.active_session = null
	shell.queue_free()
	await get_tree().process_frame

	var production_shell = PortraitShellScene.instantiate()
	production_shell.content_mode = "unified"
	add_child(production_shell)
	await _frames(3)
	var refused: Dictionary = SeasonRunner.create(production_shell, refusal_path)
	_expect(
		not refused.get("ok", false) and refused.get("error_code") == "INVALID_SEASON_SAVE",
		"ancien snapshot OA01 refusé fail-closed avec code exact INVALID_SEASON_SAVE",
	)
	production_shell.queue_free()
	await get_tree().process_frame
	_remove_save(baseline_save)
	_remove_save(refusal_path)


func _new_production_main(save_path: String, expect_active: bool):
	var main := TestRuntimeHost.new()
	main.shell = PortraitShellScene.instantiate()
	main.shell.content_mode = "unified"
	add_child(main.shell)
	await _frames(5)
	var created: Dictionary = SeasonRunner.create(main.shell, save_path)
	_expect(created["ok"], "factory production compose OA01 → OA02")
	if not created["ok"]:
		main.queue_free()
		await get_tree().process_frame
		return null
	main.season_runner = created["runner"]
	main.runtime_session = main.season_runner.active_session
	main.season_runner.active_session_changed.connect(
		_on_production_active_session_changed.bind(main)
	)
	if main.runtime_session != null:
		_expect(main.shell.configure_unified_runtime(main.runtime_session), "shell production configuré")
	var begun: Dictionary = main.season_runner.begin()
	_expect(begun["ok"], "runner production démarre")
	if main.runtime_session == null:
		main.shell.clear_unified_runtime(
			main.season_runner.presentation_source(),
			main.season_runner.gallery_source(),
			main.season_runner,
		)
	if expect_active:
		_expect(main.runtime_session != null, "session production active attendue")
		if main.runtime_session == null:
			main.queue_free()
			await get_tree().process_frame
			return null
	else:
		_expect(main.runtime_session == null, "aucune session active attendue")
	main.shell.messages_screen.runtime_delivery_time_scale = 0.001
	return main


func _reload_active(
	main,
	save_path: String,
	expected_beat_id: String,
	expected_resolution_id,
	label: String,
):
	var session = main.runtime_session
	var expected_presented: Dictionary = session.presented_message_ids_by_thread()
	var expected_durable: Dictionary = session.durable_state()
	var expected_consumed: Array = session.execution_state()["consumed_choice_ids"].duplicate()
	_expect(session.save_now()["ok"], "save " + label)
	await _dispose_main(main)
	var reloaded = await _new_production_main(save_path, true)
	if reloaded == null:
		return null
	var restored = reloaded.runtime_session
	_expect(
		restored.execution_state()["current_beat_id"] == expected_beat_id
		and restored.execution_state()["selected_resolution_id"] == expected_resolution_id
		and restored.execution_state()["consumed_choice_ids"] == expected_consumed
		and restored.presented_message_ids_by_thread() == expected_presented
		and restored.durable_state() == expected_durable
		and _messages_have_unique_ids(restored.presentation_source()),
		"reload exact sans replay ni duplication " + label,
	)
	return reloaded


func _dispose_main(main) -> void:
	if main == null:
		return
	var runner = main.season_runner
	var session = main.runtime_session
	if runner != null:
		for connection in runner.active_session_changed.get_connections():
			var callback: Callable = connection["callable"]
			if runner.active_session_changed.is_connected(callback):
				runner.active_session_changed.disconnect(callback)
	if session != null:
		session.detach()
		if session._save_store != null and session._save_store.has_method("release"):
			session._save_store.release()
	if runner != null:
		runner.active_session = null
	main.runtime_session = null
	main.season_runner = null
	var shell = main.shell
	main.shell = null
	if shell != null:
		shell.queue_free()
	await get_tree().process_frame


func _on_production_active_session_changed(
	_previous_session, next_session, host: TestRuntimeHost
) -> void:
	host.runtime_session = next_session
	host.shell.clear_unified_runtime(
		host.season_runner.presentation_source(),
		host.season_runner.gallery_source(),
		host.season_runner,
	)
	if next_session != null:
		_expect(
			host.shell.configure_unified_runtime(next_session),
			"handoff production configure la session Sandra",
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
	var presented: Array = session.presented_message_ids_by_thread().get(thread_id, [])
	for message in active_messages:
		if message["message_id"] not in presented:
			if not session.mark_message_presented(str(message["message_id"])):
				return false
	var read: Dictionary = session.on_thread_read(thread_id, str(active_messages[-1]["message_id"]))
	await _frames(4)
	return read.get("ok", false)


func _complete_current_media(session) -> bool:
	if session.execution_state().get("current_beat_id") != "sandra_kept_lunch_photo_reveal":
		return false
	var status := ""
	for _index in range(40):
		status = str(session.execution_state().get("execution_status", ""))
		if status in ["WAITING_FOR_PROJECTION_ACK", "WAITING_FOR_PLAYER"]:
			break
		await get_tree().process_frame
	if status not in ["WAITING_FOR_PROJECTION_ACK", "WAITING_FOR_PLAYER"]:
		return false
	var viewer = session._media_adapter.photo_viewer()
	if viewer == null or not viewer.visible:
		return false
	if viewer.displayed_media_status() != "NOT_DELIVERED":
		return false
	if status == "WAITING_FOR_PROJECTION_ACK":
		viewer.media_presented.emit(MEDIA_ID, "NOT_DELIVERED")
		await _frames(3)
	if not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	viewer.close_requested.emit()
	await _frames(4)
	return session.execution_state().get("current_beat_id") == "sandra_photo_kept_guided_choice"


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
	if session == null or not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	var prior_beat_id = session.execution_state().get("current_beat_id")
	var button = main.shell.messages_screen.find_child("PhysicalContinue", true, false)
	if button == null or not button.visible:
		return false
	button.emit_signal("pressed")
	await _frames(5)
	return session.execution_state().get("current_beat_id") != prior_beat_id


func _durable_has_exact_branch(state: Dictionary, expected_posture: String) -> bool:
	var narrative: Dictionary = state.get("narrative_state", {})
	var traces: Dictionary = narrative.get("traces_narratives", {})
	var knowledge: Dictionary = narrative.get("connaissances", {})
	var media: Dictionary = narrative.get("livraison_medias", {})
	var relation: Dictionary = narrative.get("relations", {}).get("sandra", {})
	var fact_ids: Array = relation.get("faits", []).map(func(fact): return fact.get("fait_id"))
	var trace: Dictionary = traces.get(TRACE_ID, {})
	var known: Dictionary = knowledge.get(KNOWLEDGE_ID, {})
	var delivery: Dictionary = media.get(MEDIA_ID, {})
	if fact_ids.count(expected_posture) != 1:
		return false
	for posture in POSTURE_FACTS:
		if posture != expected_posture and posture in fact_ids:
			return false
	return (
		traces.size() == 1
		and trace.get("creator_id") == "sandra"
		and trace.get("audience_ids") == ["sandra", "player"]
		and trace.get("controller_ids") == ["sandra"]
		and trace.get("accessible_to_ids") == ["sandra", "player"]
		and knowledge.size() == 1
		and known.get("subject_id") == TRACE_ID
		and known.get("holder_ids") == ["sandra", "player"]
		and media.has(MEDIA_ID)
		and delivery.get("diegetic_status") == "CREATED"
		and delivery.get("fictional_audience_ids") == ["sandra", "player"]
		and delivery.get("access_status") == "ACCESSIBLE"
		and delivery.get("gallery_status") == "AVAILABLE"
		and delivery.get("withdrawal_status") == "ACTIVE"
		and narrative.get("promesses", {}).is_empty()
		and narrative.get("obligations", {}).is_empty()
	)


func _gallery_media_count(source: Dictionary, media_id: String) -> int:
	var count := 0
	for character in source.get("fixtures", {}).values():
		for item in character.get("items", []):
			if str(item.get("item_id", "")) == media_id:
				count += 1
	return count


func _gallery_has_sandra_placeholder(source: Dictionary) -> bool:
	var items: Array = source.get("fixtures", {}).get("sandra", {}).get("items", [])
	return (
		items.size() == 1
		and items[0].get("item_id") == MEDIA_ID
		and items[0].get("placeholder_label") == "Visuel non livré"
	)


func _offered_thread(source: Dictionary, thread_id: String, action_label: String) -> bool:
	for thread in source.get("threads", []):
		if str(thread.get("thread_id", "")) == thread_id:
			return (
				thread.get("availability_state") == SeasonRunner.OPPORTUNITY_AVAILABLE
				and thread.get("opportunity_action_label") == action_label
				and thread.get("last_preview") == "Nouveau moment disponible"
				and thread.get("unread_count") == 0
				and not thread.get("has_unread_content", true)
			)
	return false


func _instance_count(runner, sequence_id: String) -> int:
	var expected := "unified_player_" + sequence_id
	var count := 0
	for instance in runner.catalog["facade"].save_state().get("scene_registry", []):
		if str(instance.get("instance_id", "")) == expected:
			count += 1
	return count


func _messages_have_unique_ids(source: Dictionary) -> bool:
	var ids: Array = []
	var unique := {}
	for thread_id in source.get("messages_by_thread", {}):
		for message in source["messages_by_thread"][thread_id]:
			var message_id := str(message.get("message_id", ""))
			ids.append(message_id)
			unique[message_id] = true
	return not ids.has("") and ids.size() == unique.size()


func _return_player_lines(session, beat_id: String) -> Array:
	var result: Array = []
	for message in session.presentation_source().get("messages_by_thread", {}).get("sandra_thread", []):
		if message.get("beat_id") == beat_id and message.get("author_id") == "player":
			result.append(message.get("text"))
	return result


func _texts_for_beat(session, beat_id: String) -> Array:
	var result: Array = []
	for thread_id in session.presentation_source().get("messages_by_thread", {}):
		for message in session.presentation_source()["messages_by_thread"][thread_id]:
			if message.get("beat_id") == beat_id:
				result.append(message.get("text"))
	return result


func _visible_threads(main) -> Array:
	return main.shell.messages_screen.conversation_list.threads.map(
		func(thread): return str(thread.get("thread_id", ""))
	)


func _wait_for_status(session, expected: String, max_frames := 50) -> bool:
	for _index in range(max_frames):
		if session.execution_state().get("execution_status") == expected:
			return true
		await get_tree().process_frame
	return false


func _load(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return JsonNormalizer.normalize(parsed) if typeof(parsed) == TYPE_DICTIONARY else {}


func _print_narrative_review() -> void:
	print("S1_OA02_NARRATIVE_REVIEW_BEGIN")
	print("Sandra: Je tombe peut-être mal. Mais j'ai retrouvé une photo.")
	print("Sandra: Je l'avais revue après, puis gardée dans un dossier à part.")
	print("Sandra: Et j'ai recadré un peu avant de te l'envoyer.")
	print("Player postures: Je suis content que tu l'aies gardée. | Tu as choisi celle où tu souriais. | Ah oui. Je me souviens.")
	print("Sandra: J'ai déjà passé trop de temps à choisir une photo que j'avais soi-disant juste retrouvée.")
	print("Sandra: On va dire que c'était sans conséquence.")
	print("Retour: Player pose le téléphone et revient vers Marie. La fin de soirée se déroule hors écran.")
	print("Review: geste personnel ambigu, sans séduction explicite; retour Marie naturel, sans leçon morale.")
	print("S1_OA02_NARRATIVE_REVIEW_END")


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
