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
	"res://data/unified_runtime/sequences/marie_bread_and_ten_minutes_01.json"
)
const MESSAGES_PATH := (
	"res://data/unified_runtime/presentation/marie_bread_and_ten_minutes_01_messages.json"
)
const PHYSICAL_PATH := (
	"res://data/unified_runtime/presentation/marie_bread_and_ten_minutes_01_physical.json"
)
const MEDIA_PATH := (
	"res://data/unified_runtime/presentation/marie_bread_and_ten_minutes_01_media.json"
)
const CAPABILITY_CATALOG := (
	"res://tests/fixtures/unified_runtime/capability_catalog_n17_n22.json"
)
const SEQUENCE_ID := "marie_bread_and_ten_minutes_01"
const MEDIA_ID := "s1_opening_marie_shared_kitchen_01"
const N23_FINGERPRINT := "df4aaf48487c38fe49a883a39f75db1a5cb035aa77c6377e083cea1efacff01e"
const SAVE_ROOT := "user://s1_oa01_smoke/"

const BRANCHES := [
	{
		"name": "DIRECT",
		"choice_id": "marie_shared_evening_present",
		"resolution_id": "resolution_present",
		"posture_fact": "marie_shared_evening_presence_chosen",
		"return_id": "return_present",
		"outcome_id": "marie_shared_evening_present_outcome",
		"return_opening": ["Voilà 🙂", "C'est beau, un homme qui accepte sa mission."],
	},
	{
		"name": "PLAYFUL",
		"choice_id": "marie_shared_evening_playful",
		"resolution_id": "resolution_playful",
		"posture_fact": "marie_shared_evening_playful_presence",
		"return_id": "return_playful",
		"outcome_id": "marie_shared_evening_playful_outcome",
		"return_opening": ["Accepté.", "Râle en marchant, c'est cardio."],
	},
	{
		"name": "DELAYED",
		"choice_id": "marie_shared_evening_delayed",
		"resolution_id": "resolution_delayed",
		"posture_fact": "marie_shared_evening_delayed_presence_kept",
		"return_id": "return_delayed",
		"outcome_id": "marie_shared_evening_delayed_outcome",
		"return_opening": [
			"Ton mail peut acheter du pain ?",
			"Alors je préfère toi. Mais en version présente, si possible.",
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
	var sequence := _load(SEQUENCE_PATH)
	_test_closed_contracts(sequence)
	for branch in BRANCHES:
		_test_direct_branch(sequence, branch)
	for index in BRANCHES.size():
		await _test_production_branch(BRANCHES[index], index == 0)
	await _test_real_n23_save_refusal()
	_print_narrative_review()
	await _frames(3)
	if failures.is_empty():
		print("S1_OA01_MARIE_BREAD_AND_TEN_MINUTES: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)


func _test_closed_contracts(sequence: Dictionary) -> void:
	var authored: Dictionary = AuthoredValidator.validate(sequence, true)
	var messages: Dictionary = MessagesResolver.create(sequence, _load(MESSAGES_PATH), true)
	var physical: Dictionary = PhysicalResolver.create(sequence, _load(PHYSICAL_PATH), true)
	var media: Dictionary = MediaResolver.create(sequence, _load(MEDIA_PATH), true)
	_expect(authored["valid"], "séquence OA01 conforme: %s" % [authored.get("errors", [])])
	_expect(messages["ok"], "RETURN OA01 conforme: %s" % [messages.get("errors", [])])
	_expect(physical["ok"], "PHYSICAL OA01 conforme: %s" % [physical.get("errors", [])])
	_expect(media["ok"], "média OA01 conforme: %s" % [media.get("errors", [])])
	var guided := [
		sequence["resolutions"]["resolution_optimism_guided"],
		sequence["resolutions"]["resolution_crisis_guided"],
	]
	var guided_are_local := true
	for resolution in guided:
		guided_are_local = (
			guided_are_local
			and resolution["a10_choice_id"] == null
			and resolution["a10_resolution_id"] == null
			and resolution["event_refs"].is_empty()
		)
	_expect(guided_are_local, "deux guided locals ont zéro A10 et zéro durable")


func _test_direct_branch(sequence: Dictionary, branch: Dictionary) -> void:
	var graph: Dictionary = CompositionRoot._new_domain_graph(sequence)
	var activation: Dictionary = CompositionRoot._activate_sequence(graph["facade"], sequence)
	var port_result: Dictionary = _projection_port(sequence)
	var created: Dictionary = ExecutorV2.create(
		graph["facade"], port_result.get("port"), sequence, activation
	)
	_expect(
		activation.get("ok", false)
		and port_result.get("ok", false)
		and created.get("ok", false)
		and created["executor"].start()["ok"],
		"executor direct démarre " + branch["name"],
	)
	if not created.get("ok", false):
		return
	var executor = created["executor"]
	var counter := CountingFacade.new(graph["facade"])
	executor._facade = counter
	for _index in range(14):
		if executor.execution_state()["execution_status"] == "RESOLUTION_READY":
			break
		var beat: Dictionary = executor.current_beat()
		var choice_id = null
		if beat["beat_id"] == "marie_optimism_guided_choice":
			choice_id = "marie_optimism_guided_reply"
		elif beat["beat_id"] == "marie_crisis_guided_choice":
			choice_id = "marie_crisis_guided_reply"
		elif beat["beat_id"] == "marie_shared_evening_posture_choice":
			choice_id = branch["choice_id"]
		var advanced := _advance_direct_projection(
			executor, choice_id, "drive_" + branch["name"].to_lower()
		)
		if beat["beat_id"] in ["marie_optimism_guided_choice", "marie_crisis_guided_choice"]:
			_expect(
				advanced
				and counter.resolve_scene_calls == 0
				and executor.execution_state()["durable_commit_status"] == "NOT_REQUESTED",
				"guided local avance sans A10 " + branch["name"],
			)
		if not advanced:
			break
	_expect(
		executor.execution_state()["execution_status"] == "RESOLUTION_READY",
		"posture atteint RESOLUTION_READY " + branch["name"],
	)
	var committed: Dictionary = executor.commit_resolution({
		"moment_diegetique": "2032-03-02T18:23:05+01:00",
		"acte_courant": "OPENING_ARC",
		"participants_disponibles": {"marie": true, "player": true},
		"opportunite_valide": true,
	})
	var replayed: Dictionary = executor.commit_resolution({
		"moment_diegetique": "2032-03-02T18:23:05+01:00",
		"acte_courant": "OPENING_ARC",
		"participants_disponibles": {"marie": true, "player": true},
		"opportunite_valide": true,
	})
	var durable: Dictionary = counter.save_state()
	_expect(
		committed.get("ok", false)
		and replayed.get("idempotent", false)
		and counter.resolve_scene_calls == 1
		and _durable_has_exact_branch(durable, branch["posture_fact"]),
		"exactement un A10 publie les trois faits et le média " + branch["name"],
	)
	_expect(
		executor.execution_state()["current_beat_id"] == branch["return_id"]
		and JSON.stringify(durable).contains(MEDIA_ID)
		and not JSON.stringify(durable).contains("marie_j01_shared_evening"),
		"RETURN suit le commit sans Promise " + branch["name"],
	)

	var return_snapshot: Dictionary = executor.snapshot(
		_empty_messages_snapshot(), "2032-03-02T18:23:05+01:00"
	)
	var return_graph: Dictionary = CompositionRoot._new_domain_graph(sequence)
	var return_port: Dictionary = _projection_port(sequence)
	var return_restored: Dictionary = ExecutorV2.restore(
		return_graph["facade"], return_port["port"], sequence,
		return_snapshot.get("payload", {}).get("snapshot", {})
	)
	_expect(return_snapshot["ok"] and return_restored["ok"], "reload RETURN " + branch["name"])
	if not return_restored.get("ok", false):
		return
	var return_counter := CountingFacade.new(return_graph["facade"])
	var restored_executor = return_restored["executor"]
	restored_executor._facade = return_counter
	_expect(
		_advance_direct_projection(restored_executor, null, "return_" + branch["name"].to_lower())
		and restored_executor.execution_state()["current_beat_id"] == branch["outcome_id"]
		and restored_executor.execution_state()["selected_resolution_id"] == branch["resolution_id"]
		and return_counter.resolve_scene_calls == 0,
		"reload RETURN conserve posture sans rejouer A10 " + branch["name"],
	)
	var physical_snapshot: Dictionary = restored_executor.snapshot(
		_empty_messages_snapshot(), "2032-03-02T19:15:00+01:00"
	)
	var physical_graph: Dictionary = CompositionRoot._new_domain_graph(sequence)
	var physical_port: Dictionary = _projection_port(sequence)
	var physical_restored: Dictionary = ExecutorV2.restore(
		physical_graph["facade"], physical_port["port"], sequence,
		physical_snapshot.get("payload", {}).get("snapshot", {})
	)
	_expect(
		physical_snapshot["ok"]
		and physical_restored["ok"]
		and physical_restored["executor"].execution_state()["current_beat_id"] == branch["outcome_id"],
		"reload PHYSICAL conserve posture " + branch["name"],
	)
	if not physical_restored.get("ok", false):
		return
	var physical_counter := CountingFacade.new(physical_graph["facade"])
	physical_restored["executor"]._facade = physical_counter
	_expect(
		_advance_direct_projection(
			physical_restored["executor"], null, "physical_" + branch["name"].to_lower()
		)
		and physical_restored["executor"].execution_state()["execution_status"] == "COMPLETE"
		and physical_counter.resolve_scene_calls == 0,
		"PHYSICAL terminal converge COMPLETE sans second A10 " + branch["name"],
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
		and runner.active_sequence_id == SEQUENCE_ID
		and _visible_threads(main) == ["marie_thread"]
		and _texts_for_beat(session, "marie_dinner_question") == [
			"Question importante.",
			"Deux tomates, un reste de fromage et beaucoup d'optimisme, ça fait un dîner ?",
		]
		and session.gallery_source().get("character_order", []).is_empty(),
		"fresh boot montre Marie seule et aucun média " + branch["name"],
	)
	if deep_restore:
		main = await _reload_active(main, save_path, "marie_dinner_question", null, "ouverture")
		if main == null:
			return
		session = main.runtime_session
	_expect(await _complete_current_messages(session), "ouverture présentée " + branch["name"])
	var local_one := await _select_choice(session, "marie_thread", "marie_optimism_guided_reply")
	_expect(
		local_one.get("accepted", false)
		and session.execution_state()["durable_commit_status"] == "NOT_REQUESTED"
		and not JSON.stringify(session.durable_state()).contains("marie_player_shared_life_anchor_established"),
		"guided 1 a zéro A10 " + branch["name"],
	)
	if deep_restore:
		main = await _reload_active(main, save_path, "marie_bread_and_walk_setup", null, "après guided 1")
		if main == null:
			return
		session = main.runtime_session
	_expect(
		_texts_for_beat(session, "marie_bread_and_walk_setup") == [
			"Moyen.",
			"Mais courageux 😅",
			"Bonne réponse. Il manque juste le pain.",
			"Évidemment.",
			"Et petite marche après. Dix minutes.",
			"Pas une randonnée de couple en crise.",
		]
		and await _complete_current_messages(session),
		"texte pain et marche exact " + branch["name"],
	)
	var local_two := await _select_choice(session, "marie_thread", "marie_crisis_guided_reply")
	_expect(
		local_two.get("accepted", false)
		and session.execution_state()["durable_commit_status"] == "NOT_REQUESTED",
		"guided 2 a zéro A10 " + branch["name"],
	)
	if deep_restore:
		main = await _reload_active(main, save_path, "marie_not_in_crisis", null, "après guided 2")
		if main == null:
			return
		session = main.runtime_session
	_expect(
		_texts_for_beat(session, "marie_not_in_crisis") == [
			"Non. Justement.",
			"Je refuse qu'on attende d'être tristes pour sortir marcher.",
		]
		and await _complete_current_messages(session),
		"réponse non-crise exacte " + branch["name"],
	)
	var posture_texts: Array = session.presentation_source()["choices_by_thread"]["marie_thread"].map(
		func(choice): return choice["text"]
	)
	_expect(
		posture_texts == [
			"Ok. Je prends le pain et on marche. Je participe à la survie du dîner.",
			"Je viens. Je prends le pain, mais je râle un peu pour la forme.",
			"Désolé, j'avais un mail. Je prends le pain et je viens marcher.",
		],
		"trois postures exactes sans refus " + branch["name"],
	)
	if deep_restore:
		main = await _reload_active(
			main, save_path, "marie_shared_evening_posture_choice", null, "avant posture"
		)
		if main == null:
			return
		session = main.runtime_session
	var counter := CountingFacade.new(session._facade)
	session._facade = counter
	session._executor._facade = counter
	var selected := await _select_choice(session, "marie_thread", branch["choice_id"])
	var durable: Dictionary = session.durable_state()
	_expect(
		selected.get("accepted", false)
		and counter.resolve_scene_calls == 1
		and _durable_has_exact_branch(durable, branch["posture_fact"])
		and session.gallery_source().get("character_order") == ["marie"]
		and _gallery_has_one_marie_tile(session.gallery_source()),
		"posture applique un A10, trois faits et un tile Marie " + branch["name"],
	)
	_expect(
		session.execution_state()["current_beat_id"] == branch["return_id"]
		and _texts_for_beat(session, branch["return_id"]).slice(0, 2) == branch["return_opening"]
		and _return_player_lines(session, branch["return_id"]) == [
			"Dangereux, le « normalement ».", "Ça lui ressemble."
		],
		"RETURN exact et guided post-choice authored Player " + branch["name"],
	)
	if deep_restore:
		main = await _reload_active(
			main, save_path, branch["return_id"], branch["resolution_id"], "pendant RETURN"
		)
		if main == null:
			return
		session = main.runtime_session
		_expect(session.durable_state() == durable, "reload RETURN ne rejoue pas A10")
	_expect(await _complete_current_messages(session), "RETURN présenté " + branch["name"])
	_expect(
		session.execution_state()["current_beat_id"] == branch["outcome_id"]
		and session.execution_state()["selected_resolution_id"] == branch["resolution_id"],
		"PHYSICAL choisi conserve la posture " + branch["name"],
	)
	if branch["name"] == "DELAYED":
		var delayed_text := JSON.stringify(_load(PHYSICAL_PATH)).to_lower()
		_expect(
			delayed_text.contains("retard")
			and not delayed_text.contains("missed")
			and not delayed_text.contains("failed")
			and not delayed_text.contains("penalty"),
			"retard perceptible sans échec ni pénalité",
		)
	if deep_restore:
		main = await _reload_active(
			main, save_path, branch["outcome_id"], branch["resolution_id"], "pendant PHYSICAL"
		)
		if main == null:
			return
		session = main.runtime_session
	_expect(await _continue_physical(main), "Continue PHYSICAL " + branch["name"])
	await _frames(5)
	runner = main.season_runner
	_expect(
		runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
		and runner.active_sequence_id.is_empty()
		and runner.active_session == null
		and runner.completed_sequence_ids == [SEQUENCE_ID]
		and runner.describe_state().get("opportunity", {}).get("sequence_id")
		== "sandra_kept_lunch_photo_01"
		and runner.describe_state().get("opportunity", {}).get("thread_id") == "sandra_thread"
		and runner.describe_state().get("opportunity", {}).get("action_label")
		== "Continuer avec Sandra"
		and _gallery_has_one_marie_tile(runner.gallery_source())
		and _messages_have_unique_ids(runner.presentation_source()),
		"COMPLETE puis OPPORTUNITY_AVAILABLE Sandra sans auto-lancement " + branch["name"],
	)
	await _dispose_main(main)
	main = await _new_production_main(save_path, false)
	if main != null:
		_expect(
			main.season_runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
			and main.season_runner.completed_sequence_ids == [SEQUENCE_ID]
			and main.runtime_session == null
			and main.season_runner.describe_state().get("opportunity", {}).get("sequence_id")
			== "sandra_kept_lunch_photo_01"
			and main.season_runner.describe_state().get("opportunity", {}).get("action_label")
			== "Continuer avec Sandra"
			and _gallery_has_one_marie_tile(main.season_runner.gallery_source())
			and _messages_have_unique_ids(main.season_runner.presentation_source()),
			"reload COMPLETE reconstruit l'opportunité Sandra et conserve transcript/média "
			+ branch["name"],
		)
		await _dispose_main(main)
	_remove_save(save_path)


func _test_real_n23_save_refusal() -> void:
	var capability_path := SAVE_ROOT + "real_n23.json"
	var old_save_path := SAVE_ROOT + "old_n23_against_oa01.json"
	_remove_save(capability_path)
	_remove_save(old_save_path)
	var shell = PortraitShellScene.instantiate()
	shell.content_mode = "unified"
	add_child(shell)
	await _frames(3)
	var created: Dictionary = SeasonRunner.create_for_test(CAPABILITY_CATALOG, shell, capability_path)
	_expect(created["ok"], "runner capability N23 réel créé")
	if not created["ok"]:
		shell.queue_free()
		return
	var runner = created["runner"]
	var session = runner.active_session
	if session != null:
		shell.configure_unified_runtime(session)
	_expect(runner.begin()["ok"] and session != null, "snapshot N23 produit par un vrai runtime")
	if session == null:
		shell.queue_free()
		return
	_expect(session.save_now()["ok"], "vrai snapshot Saison V2 N23 sauvegardé")
	var loaded: Dictionary = SaveStore.create(capability_path)["store"].load_snapshot()
	var snapshot: Dictionary = loaded.get("snapshot", {})
	_expect(
		loaded.get("ok", false)
		and snapshot.get("schema_id") == "reseau_intime.unified_season"
		and snapshot.get("schema_version") == 2
		and snapshot.get("catalog_fingerprint") == N23_FINGERPRINT,
		"fingerprint baseline N23 réel est exact",
	)
	_expect(
		SaveStore.create(old_save_path)["store"].save_snapshot(snapshot)["ok"],
		"snapshot N23 exact installé contre OA01",
	)
	session.detach()
	if session._save_store != null and session._save_store.has_method("release"):
		session._save_store.release()
	runner.active_session = null
	shell.queue_free()
	await get_tree().process_frame
	var production_shell = PortraitShellScene.instantiate()
	production_shell.content_mode = "unified"
	add_child(production_shell)
	await _frames(3)
	var refused: Dictionary = SeasonRunner.create(production_shell, old_save_path)
	_expect(
		not refused["ok"] and refused["error_code"] == "INVALID_SEASON_SAVE",
		"ancien save N23 refusé fail-closed avec code INVALID_SEASON_SAVE",
	)
	production_shell.queue_free()
	await get_tree().process_frame
	_remove_save(capability_path)
	_remove_save(old_save_path)


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


func _new_production_main(save_path: String, expect_active: bool):
	var main := TestRuntimeHost.new()
	main.shell = PortraitShellScene.instantiate()
	main.shell.content_mode = "unified"
	add_child(main.shell)
	await _frames(5)
	var created: Dictionary = SeasonRunner.create(main.shell, save_path)
	_expect(created["ok"], "factory production compose le catalogue OA01")
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
		_expect(main.shell.configure_unified_runtime(main.runtime_session), "shell production OA01 configuré")
	var begun: Dictionary = main.season_runner.begin()
	_expect(begun["ok"], "runner production OA01 démarre")
	if main.runtime_session == null:
		main.shell.clear_unified_runtime(
			main.season_runner.presentation_source(),
			main.season_runner.gallery_source(),
			main.season_runner,
		)
	if expect_active:
		_expect(main.runtime_session != null, "session OA01 active attendue")
		if main.runtime_session == null:
			main.queue_free()
			await get_tree().process_frame
			return null
	else:
		_expect(main.runtime_session == null, "aucune session active après COMPLETE")
	main.shell.messages_screen.runtime_delivery_time_scale = 0.001
	return main


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
			"handoff production OA01 configure la nouvelle session",
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
	await _frames(5)
	return session.execution_state().get("current_beat_id") != prior_beat_id


func _advance_direct_projection(executor, choice_id, suffix: String) -> bool:
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
		"command_id": "oa01_" + suffix + "_" + beat["beat_id"],
		"instance_id": request["instance_id"],
		"beat_id": request["beat_id"],
		"kind": "SELECT_CHOICE" if is_choice else "CONTINUE",
		"choice_id": choice_id if is_choice else null,
	}).get("ok", false)


func _projection_port(sequence: Dictionary) -> Dictionary:
	return CompositePort.create(MessagesPhysicalPort.new(sequence, true), MediaPort.new(sequence, true))


func _durable_has_exact_branch(state: Dictionary, expected_posture: String) -> bool:
	var serialized := JSON.stringify(state)
	if not serialized.contains("marie_player_shared_life_anchor_established"):
		return false
	if not serialized.contains("marie_shared_evening_completed"):
		return false
	if not serialized.contains(expected_posture) or not serialized.contains(MEDIA_ID):
		return false
	for posture in [
		"marie_shared_evening_presence_chosen",
		"marie_shared_evening_playful_presence",
		"marie_shared_evening_delayed_presence_kept",
	]:
		if posture != expected_posture and serialized.contains(posture):
			return false
	return not serialized.contains("marie_j01_shared_evening")


func _gallery_has_one_marie_tile(source: Dictionary) -> bool:
	var items: Array = source.get("fixtures", {}).get("marie", {}).get("items", [])
	return (
		source.get("character_order") == ["marie"]
		and items.size() == 1
		and items[0].get("item_id") == MEDIA_ID
		and items[0].get("placeholder_label") == "Visuel non livré"
	)


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
	for message in session.presentation_source().get("messages_by_thread", {}).get("marie_thread", []):
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


func _wait_for_status(session, expected: String, max_frames := 40) -> bool:
	for _index in range(max_frames):
		if session.execution_state().get("execution_status") == expected:
			return true
		await get_tree().process_frame
	return false


func _load(path: String) -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(path))
	return JsonNormalizer.normalize(parsed) if typeof(parsed) == TYPE_DICTIONARY else {}


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


func _print_narrative_review() -> void:
	var sequence := _load(SEQUENCE_PATH)
	var messages := _load(MESSAGES_PATH)
	print("S1_OA01_NARRATIVE_REVIEW_BEGIN")
	print("Marie: Question importante.")
	print("Marie: Deux tomates, un reste de fromage et beaucoup d'optimisme, ça fait un dîner ?")
	print("Player: Ça dépend de l'optimisme. Donc oui.")
	print("Marie: Bonne réponse. Il manque juste le pain.")
	print("Marie: Et petite marche après. Dix minutes.")
	print("Player postures: ", sequence["beats"][5]["content"]["choices"].map(
		func(choice): return choice["text"]
	))
	print("Marie RETURN direct: ", messages["entries"][0]["messages"].map(
		func(message): return message["text"]
	))
	print("Payoff: dîner ensemble, marche dix minutes, téléphone dans la poche.")
	print("Review question: le joueur comprend-il Marie et leur quotidien avant toute capacité moteur ?")
	print("S1_OA01_NARRATIVE_REVIEW_END")


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
