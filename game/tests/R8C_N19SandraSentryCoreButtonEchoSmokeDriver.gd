extends Node

const PortraitMainScene := preload("res://scenes/portrait/PortraitMain.tscn")
const PortraitShellScene := preload("res://scenes/portrait/PortraitShell.tscn")
const AuthoredValidator := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
)
const PhysicalResolver := preload(
	"res://scripts/unified_runtime/projection/PhysicalContentResolver.gd"
)
const MediaResolver := preload(
	"res://scripts/unified_runtime/projection/AuthoredMediaResolver.gd"
)
const CatalogContract := preload(
	"res://scripts/unified_runtime/contracts/AuthoredSequenceCatalogV1.gd"
)
const CatalogLoader := preload(
	"res://scripts/unified_runtime/application/AuthoredSequenceCatalogLoader.gd"
)
const SeasonRunner := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonRunner.gd"
)
const SeasonSnapshot := preload(
	"res://scripts/unified_runtime/application/UnifiedSeasonSnapshotV1.gd"
)
const SaveStore := preload(
	"res://scripts/unified_runtime/application/UnifiedPlayerRuntimeSaveStore.gd"
)
const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)

const PRODUCTION_CATALOG := "res://data/unified_runtime/catalogs/season_1_v1.json"
const SANDRA_SEQUENCE := (
	"res://data/unified_runtime/sequences/sandra_sentrycore_button_echo_01.json"
)
const SANDRA_PHYSICAL := (
	"res://data/unified_runtime/presentation/sandra_sentrycore_button_echo_01_physical.json"
)
const SANDRA_MEDIA := (
	"res://data/unified_runtime/presentation/sandra_sentrycore_button_echo_01_media.json"
)
const MATHILDE_ID := "mathilde_returns_with_chosen_intent_01"
const SANDRA_ID := "sandra_sentrycore_button_echo_01"
const MARIE_ID := "marie_evening_return_01"
const SANDRA_FACT := "sandra_first_complicity_restored"
const SAVE_ROOT := "user://r8c_n19_smoke/"

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
	var sequence := _load(SANDRA_SEQUENCE)
	_test_empty_physical_and_media_contracts(sequence)
	await _test_production_mathilde_sandra_flow()
	await _frames(3)
	if failures.is_empty():
		print("R8C_N19_SANDRA_SENTRYCORE_BUTTON_ECHO: OK (%d controls)" % controls)
		get_tree().quit(0)
	else:
		for failure in failures:
			push_error(failure)
		get_tree().quit(1)


func _test_empty_physical_and_media_contracts(sequence: Dictionary) -> void:
	var physical: Dictionary = _load(SANDRA_PHYSICAL)
	var media: Dictionary = _load(SANDRA_MEDIA)
	_expect(
		AuthoredValidator.validate(sequence, true)["valid"]
		and PhysicalResolver.create(sequence, physical, true)["ok"],
		"aucun PHYSICAL_BEAT avec entries vide est accepté",
	)

	var with_physical: Dictionary = sequence.duplicate(true)
	with_physical["beats"][0]["next"]["beat_id"] = "sandra_button_echo_physical"
	with_physical["beats"].insert(1, {
		"beat_id": "sandra_button_echo_physical",
		"type": "PHYSICAL_BEAT",
		"content": {
			"physical_beat_id": "sandra_button_echo_physical_prompt",
			"content_ref": "missing_physical_content",
			"withdrawal_choice_ids": ["sandra_button_echo_reply"],
		},
		"participant_ids": ["sandra"],
		"local_conditions": [],
		"projection_target": "PHYSICAL",
		"checkpoint_before": null,
		"checkpoint_after": "sandra_button_echo_physical_presented",
		"next": {"mode": "DIRECT", "beat_id": "sandra_button_echo_choice"},
	})
	var empty_refusal := PhysicalResolver.create(with_physical, physical, true)
	_expect(
		AuthoredValidator.validate(with_physical, true)["valid"]
		and not empty_refusal["ok"]
		and empty_refusal["error_code"] == "UNRESOLVED_CONTENT_REF",
		"PHYSICAL_BEAT avec entries vide est refusé à la création",
	)
	var wrong_catalog: Dictionary = physical.duplicate(true)
	wrong_catalog["entries"] = [{
		"content_ref": "another_physical_content",
		"title": "Test",
		"body": "Test uniquement.",
		"steps": ["Ne rien projeter."],
		"continue_label": "Continuer",
	}]
	var wrong_refusal := PhysicalResolver.create(with_physical, wrong_catalog, true)
	_expect(
		not wrong_refusal["ok"] and wrong_refusal["error_code"] == "UNRESOLVED_CONTENT_REF",
		"PHYSICAL_BEAT avec mauvais content_ref est refusé à la création",
	)

	_expect(
		MediaResolver.create(sequence, media, true)["ok"],
		"media vide sans MEDIA_REVEAL ni effet est accepté",
	)
	var with_reveal: Dictionary = sequence.duplicate(true)
	with_reveal["beats"][0]["next"]["beat_id"] = "sandra_button_echo_media"
	with_reveal["beats"].insert(1, {
		"beat_id": "sandra_button_echo_media",
		"type": "MEDIA_REVEAL",
		"content": {"media_id": "missing_media", "reveal_context": {}, "requires_ack": true},
		"participant_ids": ["sandra"],
		"local_conditions": [],
		"projection_target": "MEDIA",
		"checkpoint_before": null,
		"checkpoint_after": "sandra_button_echo_media_presented",
		"next": {"mode": "DIRECT", "beat_id": "sandra_button_echo_choice"},
	})
	_expect(
		not AuthoredValidator.validate(with_reveal, true)["valid"],
		"media vide avec MEDIA_REVEAL est refusé",
	)
	var with_effect: Dictionary = sequence.duplicate(true)
	with_effect["resolutions"]["resolution_sandra_button_echo"]["media_effects"] = [{
		"media_id": "missing_media", "effect": "GRANT_ACCESS",
	}]
	_expect(
		not AuthoredValidator.validate(with_effect, true)["valid"],
		"media vide avec media_effect est refusé",
	)


func _test_production_mathilde_sandra_flow() -> void:
	var save_path := SAVE_ROOT + "production_flow.json"
	var boundary_path := SAVE_ROOT + "handoff_boundary.json"
	var old_n18_path := SAVE_ROOT + "old_n18_fingerprint.json"
	for path in [save_path, boundary_path, old_n18_path]:
		_remove_save(path)
	var main = await _new_production_main(save_path)
	if main == null:
		return
	var runner = main.season_runner
	var session = main.runtime_session
	_expect(
		runner.catalog["manifest"]["packages"].size() == 3
		and runner.active_sequence_id == MATHILDE_ID
		and runner.completed_sequence_ids.is_empty()
		and _message_ids_for_thread(session.presentation_source(), "sandra_thread").is_empty(),
		"Mathilde active au démarrage et Sandra inactive",
	)
	_expect(
		await _complete_current_messages(session)
		and await _continue_physical(main)
		and await _continue_physical(main),
		"parcours Mathilde réel atteint les médias",
	)
	var media_ok := true
	for _index in range(3):
		if not await _continue_media(main):
			media_ok = false
			break
	_expect(
		media_ok and await _complete_current_messages(session),
		"parcours Mathilde réel atteint le choix MA3",
	)
	var mathilde_counter := CountingFacade.new(session._facade)
	session._facade = mathilde_counter
	session._executor._facade = mathilde_counter
	var selected_ma3 := await _select_choice(session, "mathilde_thread", "mathilde_mb3_ma3")
	_expect(selected_ma3.get("accepted", false), "choix MA3 accepté")
	_expect(
		await _complete_current_messages(session)
		and runner.active_sequence_id == MATHILDE_ID
		and mathilde_counter.resolve_scene_calls == 1,
		"aucun handoff Sandra avant le RETURN Mathilde de 09:06",
	)
	_expect(
		session.execution_state()["execution_status"] == "RESOLVED_RETURN_PENDING"
		and session.advance_narrative_time("2032-03-05T09:05:00+01:00")["ok"]
		and runner.active_sequence_id == MATHILDE_ID,
		"Mathilde reste seule active à 09:05",
	)
	_expect(
		session.advance_narrative_time("2032-03-05T09:06:00+01:00")["ok"]
		and await _wait_for_status(session, "WAITING_FOR_PROJECTION_ACK"),
		"RETURN Mathilde devient visible à 09:06",
	)
	var mathilde_ids_before := _message_ids_for_thread(
		session.presentation_source(), "mathilde_thread"
	)
	var gallery_before_sandra: Dictionary = session.gallery_source()
	var media_registry_before: Dictionary = session.durable_state()["narrative_state"]["livraison_medias"].duplicate(true)
	_expect(await _complete_current_messages(session), "Mathilde atteint COMPLETE réel")
	await _frames(5)
	runner = main.season_runner
	_expect(
		runner.completed_sequence_ids == [MATHILDE_ID]
		and runner.active_sequence_id.is_empty()
		and runner.active_session == null
		and runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
		and runner.describe_state()["opportunity"]["sequence_id"] == SANDRA_ID,
		"handoff Mathilde expose Sandra sans démarrage automatique",
	)
	var opportunity_source: Dictionary = runner.presentation_source()
	_expect(
		_message_ids_for_thread(opportunity_source, "mathilde_thread") == mathilde_ids_before
		and opportunity_source["choices_by_thread"]["mathilde_thread"].is_empty()
		and _texts_for_thread(opportunity_source, "sandra_thread").is_empty(),
		"transcript Mathilde intact et transcript Sandra vide pendant l offre",
	)
	_expect(
		_gallery_triplet_valid(runner.gallery_source())
		and runner.gallery_source() == gallery_before_sandra
		and _gallery_triplet_openable(main),
		"Galerie Mathilde reste ouvrable pendant l offre Sandra",
	)
	_expect(runner.activate_opportunity("sandra_thread")["ok"], "clic Sandra active l opportunité")
	await _frames(5)
	session = main.runtime_session
	if session == null:
		_expect(false, "activation Sandra compose une session active")
		main.queue_free()
		return
	_expect(
		runner.active_sequence_id == SANDRA_ID
		and runner.describe_state()["active_session_count"] == 1
		and session.narrative_time() == "2032-03-05T13:50:00+01:00",
		"Sandra démarre au premier message authored après clic",
	)
	var sandra_source: Dictionary = session.presentation_source()
	var physical_button = main.shell.messages_screen.find_child("PhysicalContinue", true, false)
	_expect(
		physical_button == null or not physical_button.visible,
		"surface Physical Mathilde détachée pendant Sandra",
	)

	var boundary := SeasonSnapshot.create(
		runner.catalog,
		"",
		[MATHILDE_ID],
		null,
		runner._persistent_messages_state,
	)
	_expect(
		boundary["ok"]
		and SaveStore.create(boundary_path)["store"].save_snapshot(boundary["snapshot"])["ok"],
		"Mathilde COMPLETE est sauvegardée avant composition Sandra",
	)
	var boundary_shell = PortraitShellScene.instantiate()
	boundary_shell.content_mode = "unified"
	add_child(boundary_shell)
	await _frames(3)
	var boundary_refused := SeasonRunner.create(boundary_shell, boundary_path)
	_expect(
		not boundary_refused["ok"]
		and boundary_refused["error_code"] == "UNRESTORABLE_INCOMPLETE_HANDOFF_SAVE",
		"frontière handoff active-null incomplète est refusée fail-closed",
	)
	boundary_shell.queue_free()
	await get_tree().process_frame

	var old_manifest: Dictionary = runner.catalog["manifest"].duplicate(true)
	old_manifest["packages"] = [old_manifest["packages"][0].duplicate(true)]
	var old_n18_save: Dictionary = boundary["snapshot"].duplicate(true)
	old_n18_save["catalog_fingerprint"] = CatalogContract.fingerprint(old_manifest)
	_expect(
		SaveStore.create(old_n18_path)["store"].save_snapshot(old_n18_save)["ok"],
		"ancienne enveloppe N18 installée avec son fingerprint Mathilde-only",
	)
	var refused_shell = PortraitShellScene.instantiate()
	refused_shell.content_mode = "unified"
	add_child(refused_shell)
	await _frames(3)
	var refused := SeasonRunner.create(refused_shell, old_n18_path)
	_expect(
		not refused["ok"] and refused["error_code"] == "INVALID_SEASON_SAVE",
		"ancien save N18 refusé par fingerprint",
	)
	refused_shell.queue_free()
	await get_tree().process_frame

	_expect(await _complete_current_messages(session), "trois messages Sandra présentés")
	_expect(session.save_now()["ok"], "save avant choix Sandra")
	var before_choice_source: Dictionary = session.presentation_source()
	main.queue_free()
	await get_tree().process_frame
	main = await _new_production_main(save_path)
	if main == null:
		return
	runner = main.season_runner
	session = main.runtime_session
	var choices: Array = session.presentation_source()["choices_by_thread"]["sandra_thread"]
	_expect(
		runner.completed_sequence_ids == [MATHILDE_ID]
		and runner.active_sequence_id == SANDRA_ID
		and _texts_for_beat(session, "sandra_button_echo_message") == [
			"Poste du matin terminé.",
			"Le bouton est revenu.",
			"J'hésite entre miracle et menace.",
		]
		and choices.size() == 1
		and choices[0]["choice_id"] == "sandra_button_echo_reply"
		and choices[0]["text"] == "Journée sauvée alors."
		and _message_ids_for_thread(session.presentation_source(), "mathilde_thread") == mathilde_ids_before
		and session.presentation_source() == before_choice_source,
		"trois messages Sandra et choix unique conservés après reload",
	)
	var sandra_counter := CountingFacade.new(session._facade)
	session._facade = sandra_counter
	session._executor._facade = sandra_counter
	var selected_sandra := await _select_choice(
		session, "sandra_thread", "sandra_button_echo_reply"
	)
	var facts_after_commit := _sandra_fact_records(session.durable_state())
	_expect(
		selected_sandra.get("accepted", false)
		and sandra_counter.resolve_scene_calls == 1
		and session.execution_state().get("durable_commit_status") == "APPLIED"
		and facts_after_commit.size() == 1
		and facts_after_commit[0].get("fait_id") == SANDRA_FACT,
		"commit A10 Sandra exactement une fois",
	)
	_expect(
		session.execution_state().get("current_beat_id") == "sandra_button_echo_return"
		and session.execution_state().get("execution_status") == "WAITING_FOR_PROJECTION_ACK"
		and _texts_for_beat(session, "sandra_button_echo_return") == ["N'allons pas jusque-là."],
		"RETURN Sandra exact est purement projectionnel après commit",
	)
	_expect(
		session.gallery_source() == gallery_before_sandra
		and session.durable_state()["narrative_state"]["livraison_medias"] == media_registry_before,
		"Sandra ne crée aucune tuile ni record média durable",
	)
	var durable_after_commit: Dictionary = session.durable_state()
	_expect(session.save_now()["ok"], "save après résolution Sandra")
	main.queue_free()
	await get_tree().process_frame
	main = await _new_production_main(save_path)
	if main == null:
		return
	runner = main.season_runner
	session = main.runtime_session
	_expect(
		runner.active_sequence_id == SANDRA_ID
		and session.durable_state() == durable_after_commit
		and _sandra_fact_records(session.durable_state()).size() == 1
		and session.execution_state().get("current_beat_id") == "sandra_button_echo_return",
		"reload post-résolution ne rejoue pas le commit Sandra",
	)
	_expect(await _complete_current_messages(session), "RETURN Sandra présenté et COMPLETE atteint")
	await _frames(5)
	runner = main.season_runner
	var marie_source: Dictionary = runner.presentation_source()
	var handoff_ids := _all_message_ids(marie_source)
	_expect(
		runner.completed_sequence_ids == [MATHILDE_ID, SANDRA_ID]
		and runner.active_sequence_id.is_empty()
		and runner.active_session == null
		and runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE,
		"Sandra COMPLETE expose l opportunité Marie",
	)
	_expect(
		handoff_ids.size() == _unique_count(handoff_ids)
		and _texts_for_thread(marie_source, "mathilde_thread").size() > 0
		and _texts_for_thread(marie_source, "sandra_thread") == [
			"Poste du matin terminé.",
			"Le bouton est revenu.",
			"J'hésite entre miracle et menace.",
			"Journée sauvée alors.",
			"N'allons pas jusque-là.",
		]
		and _texts_for_thread(marie_source, "marie_thread").is_empty()
		and marie_source["choices_by_thread"]["mathilde_thread"].is_empty()
		and marie_source["choices_by_thread"]["sandra_thread"].is_empty(),
		"transcripts Mathilde et Sandra restent consultables pendant l offre Marie",
	)
	main.queue_free()
	await get_tree().process_frame
	main = await _new_production_main(save_path, false)
	if main != null:
		_expect(
			main.season_runner.completed_sequence_ids == [MATHILDE_ID, SANDRA_ID]
			and main.season_runner.active_sequence_id.is_empty()
			and main.season_runner.status() == SeasonRunner.OPPORTUNITY_AVAILABLE
			and main.runtime_session == null
			and main.season_runner.presentation_source() == marie_source,
			"reload après Sandra reconstruit une seule offre Marie",
		)
		_expect(main.season_runner.activate_opportunity("marie_thread")["ok"], "clic Marie active l opportunité")
		await _frames(4)
		_expect(
			main.season_runner.active_sequence_id == MARIE_ID
			and main.runtime_session != null,
			"Marie démarre exactement une fois après clic",
		)
		main.queue_free()
		await get_tree().process_frame
	for path in [save_path, boundary_path, old_n18_path]:
		_remove_save(path)


func _new_production_main(save_path: String, expect_session := true):
	var main = PortraitMainScene.instantiate()
	main.unified_save_path_override = save_path
	add_child(main)
	await _frames(4)
	_expect(main.season_runner != null, "PortraitMain compose le vrai catalogue production")
	if main.season_runner == null:
		main.queue_free()
		await get_tree().process_frame
		return null
	if expect_session:
		_expect(main.runtime_session != null, "le catalogue production compose une session active")
		if main.runtime_session == null:
			main.queue_free()
			await get_tree().process_frame
			return null
	main.shell.messages_screen.runtime_delivery_time_scale = 0.001
	return main


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


func _continue_physical(main) -> bool:
	var session = main.runtime_session
	if not await _wait_for_status(session, "WAITING_FOR_PLAYER"):
		return false
	var prior_beat_id: String = session.execution_state().get("current_beat_id", "")
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
	var prior_beat_id: String = session.execution_state().get("current_beat_id", "")
	var viewer = main.shell.photo_viewer
	if viewer == null or not viewer.visible or viewer.back_button == null:
		return false
	viewer.back_button.emit_signal("pressed")
	await _frames(4)
	return session.execution_state().get("current_beat_id") != prior_beat_id


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


func _gallery_triplet_valid(source: Dictionary) -> bool:
	if source.get("character_order") != ["mathilde"]:
		return false
	var items: Array = source.get("fixtures", {}).get("mathilde", {}).get("items", [])
	return (
		items.size() == 1
		and items[0].get("sequence_child_ids") == [
			"S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY",
			"S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01",
			"S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01",
		]
	)


func _gallery_triplet_openable(main) -> bool:
	var gallery = main.shell.gallery_screen
	if gallery == null:
		return false
	gallery.refresh_content_source(main.season_runner.gallery_source())
	gallery.select_character("mathilde")
	var items: Array = gallery.fixtures.get("mathilde", {}).get("items", [])
	if items.size() != 1:
		return false
	return gallery.viewer_sequence_for_item(str(items[0].get("item_id", ""))).size() == 3


func _sandra_fact_records(durable: Dictionary) -> Array:
	var facts: Array = durable.get("narrative_state", {}).get("relations", {}).get(
		"sandra", {}
	).get("faits", [])
	return facts.filter(func(fact): return fact.get("fait_id") == SANDRA_FACT)


func _texts_for_beat(session, beat_id: String) -> Array:
	var texts: Array = []
	for thread_id in session.presentation_source().get("messages_by_thread", {}):
		for message in session.presentation_source()["messages_by_thread"][thread_id]:
			if message.get("beat_id") == beat_id:
				texts.append(message.get("text"))
	return texts


func _message_ids_for_thread(source: Dictionary, thread_id: String) -> Array:
	return source.get("messages_by_thread", {}).get(thread_id, []).map(
		func(message): return message.get("message_id")
	)


func _texts_for_thread(source: Dictionary, thread_id: String) -> Array:
	return source.get("messages_by_thread", {}).get(thread_id, []).map(
		func(message): return message.get("text")
	)


func _all_message_ids(source: Dictionary) -> Array:
	var ids: Array = []
	for thread_id in source.get("messages_by_thread", {}):
		ids.append_array(_message_ids_for_thread(source, str(thread_id)))
	return ids


func _unique_count(values: Array) -> int:
	var unique := {}
	for value in values:
		unique[value] = true
	return unique.size()


func _wait_for_status(session, expected: String, max_frames := 50) -> bool:
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
