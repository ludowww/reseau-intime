extends Node

const FacadeModel := preload("res://scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
const LibraryModel := preload("res://scripts/narrative_scene/NarrativeSceneLibrary.gd")
const NarrativeStateModel := preload("res://scripts/narrative_state/EtatNarratif.gd")
const Reducer := preload("res://scripts/narrative_state/ReducerResolutionSequence.gd")
const ResolutionEvent := preload("res://scripts/narrative_state/SequenceResolutionEventV1.gd")

const FIXTURE_PATH := "res://tests/fixtures/unified_runtime/n13_a10_durable_integration_valid.json"
const INSTANCE_ID := "synthetic_n13_durable_instance"
const CATEGORIES := ["facts", "knowledge", "traces", "promises", "obligations", "media_deliveries"]

var _checks := 0
var _failed := false


func _ready() -> void:
	var sequence := _load_sequence()
	sequence["orchestration"]["a6_entry"]["definition"]["resolutions"]["a10_resolution_commit"]["durable_manifest"] = _full_manifest()
	_test_success_replay_restore(sequence)
	_test_closed_rejections(sequence)
	_test_persisted_inconsistencies(sequence)
	_test_restored_event_payload_rejections(sequence)
	_test_preparation_failures(sequence)
	_test_additional_negative_matrix(sequence)
	_test_non_reentrant_guard(sequence)
	_test_historical_path()
	_finish()


func _test_success_replay_restore(sequence: Dictionary) -> void:
	var env := _activated_environment(sequence)
	_expect(not env.is_empty(), "instance PROPOSED prepared")
	var facade = env["facade"]
	var envelope := _envelope(sequence)
	var context := _context_with_envelope(envelope)
	var before: Dictionary = facade.save_state()
	var result: Dictionary = facade.resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", context
	)
	var after: Dictionary = facade.save_state()
	_expect(result["ok"] and result["statut"] == "RESOLVED", "public receipt resolved after publication")
	_expect(result["state"] == "RESOLVED" and result["transaction_status"] == "APPLIQUE", "A1 and A5 visible together")
	_expect(before != after and before["scene_registry"][0]["state"] == "PROPOSED", "no real state changed before publication")
	var event_id := "r8c-a1:%s:sequence-resolution:a10_resolution_commit" % INSTANCE_ID
	var event: Dictionary = after["narrative_state"]["evenements"][event_id]
	_expect(event.keys() == ResolutionEvent.FIELDS, "event envelope exact and ordered")
	_expect(event["event_type"] == "R8C_A1_SEQUENCE_RESOLUTION_V1", "event type exact")
	_expect(event["event_id"] == event_id and ResolutionEvent.validate(event), "deterministic event id exact")
	_expect(event["provenance"] == _expected_provenance(event_id), "provenance exact")
	_expect(event["payload"].keys() == CATEGORIES, "payload six categories exact and ordered")
	_expect(event["payload"] == _full_manifest_payload(), "payload is ordered deep manifest copy")
	_expect(after["narrative_state"]["relations"]["sandra"]["faits"].size() == 1, "facts reducer published")
	_expect(after["narrative_state"]["connaissances"].has("n14_1c_knowledge"), "knowledge registry published")
	_expect(after["narrative_state"]["traces_narratives"].has("n14_1c_trace"), "traces registry published")
	_expect(after["narrative_state"]["promesses"].has("n14_1c_promise"), "promises registry published")
	_expect(after["narrative_state"]["obligations"].has("n14_1c_obligation"), "obligations registry published")
	_expect(after["narrative_state"]["livraison_medias"].has("n14_1c_media"), "media registry published")
	var persistent_instance: Dictionary = after["scene_registry"][0]
	var receipt: Dictionary = persistent_instance["resolution_receipt"]
	_expect(persistent_instance["state"] == "RESOLVED", "A5 instance resolved")
	_expect(receipt.keys().size() == 12 and receipt["operation"] == "RESOLVE_SCENE", "closed terminal receipt persisted")
	_expect(receipt["event_id"] == event_id and receipt["transaction_id"] == event_id, "receipt binds A1 event and transaction")
	_expect(receipt["event_keys"] == envelope["event_keys"], "receipt preserves ordered event keys")

	var replay_before := after.duplicate(true)
	var replay: Dictionary = facade.resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", context
	)
	_expect(replay["ok"] and replay["statut"] == "IDEMPOTENT" and replay["idempotent"], "immediate terminal replay idempotent")
	_expect(facade.save_state() == replay_before, "replay adds no event reducer call receipt or A5 mutation")

	var restored = _new_facade(sequence)
	_expect(restored != null and restored.restore_state(after)["ok"], "save_state restore_state accepted coherent pair")
	var restored_before: Dictionary = restored.save_state()
	var restored_replay: Dictionary = restored.resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", context
	)
	_expect(restored_replay["ok"] and restored_replay["statut"] == "IDEMPOTENT", "replay after restoration idempotent")
	_expect(restored.save_state() == restored_before, "same event and receipt after restoration without mutation")

	var divergent_checkpoint := envelope.duplicate(true)
	divergent_checkpoint["terminal_checkpoint_id"] = "checkpoint_other"
	_assert_terminal_rejection(
		facade,
		_context_with_envelope(divergent_checkpoint),
		"RESOLUTION_TERMINALE_DIFFERENTE",
		"terminal checkpoint divergence",
	)
	var divergent_authored_choice := envelope.duplicate(true)
	divergent_authored_choice["choice_id"] = "choice_other"
	_assert_terminal_rejection(
		facade,
		_context_with_envelope(divergent_authored_choice),
		"RESOLUTION_TERMINALE_DIFFERENTE",
		"terminal authored choice divergence",
	)
	var divergent_keys := envelope.duplicate(true)
	divergent_keys["event_keys"] = envelope["event_keys"].duplicate(true)
	divergent_keys["event_keys"].reverse()
	_assert_terminal_rejection(
		facade,
		_context_with_envelope(divergent_keys),
		"RESOLUTION_TERMINALE_DIFFERENTE",
		"terminal ordered event keys divergence",
	)


func _test_closed_rejections(sequence: Dictionary) -> void:
	var base := _envelope(sequence)
	var cases := []
	var extra := base.duplicate(true)
	extra["unexpected"] = true
	cases.append([extra, "extra sequence_resolution field rejected"])
	var wrong_instance := base.duplicate(true)
	wrong_instance["instance_id"] = "other_instance"
	cases.append([wrong_instance, "divergent instance rejected"])
	var wrong_sequence := base.duplicate(true)
	wrong_sequence["sequence_id"] = "other_sequence"
	cases.append([wrong_sequence, "divergent binding rejected"])
	var wrong_version := base.duplicate(true)
	wrong_version["authored_version"] = "2.0.0"
	cases.append([wrong_version, "divergent authored version rejected"])
	var wrong_resolution := base.duplicate(true)
	wrong_resolution["resolution_id"] = "other_resolution"
	cases.append([wrong_resolution, "divergent authored resolution rejected"])
	var missing_keys := base.duplicate(true)
	missing_keys["event_keys"].pop_back()
	cases.append([missing_keys, "missing event_keys rejected"])
	var extra_keys := base.duplicate(true)
	extra_keys["event_keys"].append("unexpected_key")
	cases.append([extra_keys, "extra event_keys rejected"])
	var wrong_order := base.duplicate(true)
	wrong_order["event_keys"].reverse()
	cases.append([wrong_order, "different event_keys order rejected"])
	for case in cases:
		_assert_new_rejection(sequence, _context_with_envelope(case[0]), case[1])
	_assert_new_rejection(sequence, _context(), "missing sequence_resolution rejected by coordinator", true)

	var choice_env := _activated_environment(sequence)
	var choice_before: Dictionary = choice_env["facade"].save_state()
	var wrong_choice: Dictionary = choice_env["facade"].resolve_scene(
		INSTANCE_ID, "other_choice", "a10_resolution_commit", _context_with_envelope(base)
	)
	_expect(not wrong_choice["ok"] and choice_env["facade"].save_state() == choice_before, "divergent A10 choice rejected without mutation")
	var resolution_env := _activated_environment(sequence)
	var resolution_before: Dictionary = resolution_env["facade"].save_state()
	var wrong_a10_resolution: Dictionary = resolution_env["facade"].resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "other_resolution", _context_with_envelope(base)
	)
	_expect(not wrong_a10_resolution["ok"] and resolution_env["facade"].save_state() == resolution_before, "divergent A10 resolution rejected without mutation")


func _test_persisted_inconsistencies(sequence: Dictionary) -> void:
	var source := _activated_environment(sequence)
	var envelope := _envelope(sequence)
	var proposed: Dictionary = source["facade"].save_state()
	source["facade"].resolve_scene(INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", _context_with_envelope(envelope))
	var resolved: Dictionary = source["facade"].save_state()
	var event_id: String = resolved["scene_registry"][0]["resolution_receipt"]["event_id"]

	var event_without_a5 := resolved.duplicate(true)
	event_without_a5["scene_registry"] = proposed["scene_registry"].duplicate(true)
	_assert_restore_rejection(sequence, event_without_a5, "A1 event present without A5 termination")
	var divergent_event_without_a5 := event_without_a5.duplicate(true)
	divergent_event_without_a5["narrative_state"]["evenements"][event_id]["payload"]["knowledge"][0]["subject_id"] = "other_subject"
	_assert_restore_rejection(sequence, divergent_event_without_a5, "same event_id divergent without A5 termination")
	var a5_without_event := resolved.duplicate(true)
	a5_without_event["narrative_state"]["evenements"].erase(event_id)
	_assert_restore_rejection(sequence, a5_without_event, "A5 termination present without A1 event")
	var divergent_event := resolved.duplicate(true)
	divergent_event["narrative_state"]["evenements"][event_id]["payload"]["knowledge"][0]["subject_id"] = "other_subject"
	_assert_restored_replay_rejection(
		sequence, divergent_event, "TERMINAISON_PERSISTEE_INCOHERENTE", "same transaction divergent A1 payload"
	)
	var divergent_provenance := resolved.duplicate(true)
	divergent_provenance["narrative_state"]["evenements"][event_id]["provenance"]["source_sequence_id"] = "other_sequence"
	_assert_restore_rejection(sequence, divergent_provenance, "same transaction divergent provenance")
	var incomplete_receipt := resolved.duplicate(true)
	incomplete_receipt["scene_registry"][0]["resolution_receipt"].erase("event_keys")
	_assert_restore_rejection(sequence, incomplete_receipt, "incomplete terminal receipt")
	var extra_receipt := resolved.duplicate(true)
	extra_receipt["scene_registry"][0]["resolution_receipt"]["unexpected"] = true
	_assert_restore_rejection(sequence, extra_receipt, "terminal receipt unknown field")
	var receipt_on_proposed := proposed.duplicate(true)
	receipt_on_proposed["scene_registry"][0]["resolution_receipt"] = resolved["scene_registry"][0]["resolution_receipt"].duplicate(true)
	_assert_restore_rejection(sequence, receipt_on_proposed, "terminal receipt on non RESOLVED instance")
	var divergent_receipt := resolved.duplicate(true)
	divergent_receipt["scene_registry"][0]["resolution_receipt"]["terminal_checkpoint_id"] = "checkpoint_other"
	_assert_restored_replay_rejection(
		sequence, divergent_receipt, "RESOLUTION_TERMINALE_DIFFERENTE", "restored incoherent snapshot"
	)


func _test_restored_event_payload_rejections(sequence: Dictionary) -> void:
	var source := _activated_environment(sequence)
	var envelope := _envelope(sequence)
	var resolved_result: Dictionary = source["facade"].resolve_scene(
		INSTANCE_ID,
		"a10_choice_commit",
		"a10_resolution_commit",
		_context_with_envelope(envelope),
	)
	_expect(resolved_result["ok"], "resolved snapshot source built for restored payload rejection matrix")
	var resolved: Dictionary = source["facade"].save_state()
	var event_id: String = resolved["scene_registry"][0]["resolution_receipt"]["event_id"]
	var cases: Array = []
	var falsified: Dictionary

	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["facts"] = [42]
	cases.append([falsified, "scalar facts entry"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["knowledge"] = [42]
	cases.append([falsified, "scalar knowledge entry"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["traces"] = [42]
	cases.append([falsified, "scalar traces entry"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["promises"] = [42]
	cases.append([falsified, "scalar promises entry"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["obligations"] = [42]
	cases.append([falsified, "scalar obligations entry"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["media_deliveries"] = [42]
	cases.append([falsified, "scalar media entry"])

	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["facts"][0]["fact"]["unexpected"] = true
	cases.append([falsified, "unknown nested fact field"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["knowledge"][0]["unexpected"] = true
	cases.append([falsified, "unknown knowledge field"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["traces"][0]["unexpected"] = true
	cases.append([falsified, "unknown trace field"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["promises"][0]["unexpected"] = true
	cases.append([falsified, "unknown promise field"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["obligations"][0]["unexpected"] = true
	cases.append([falsified, "unknown obligation field"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["media_deliveries"][0]["unexpected"] = true
	cases.append([falsified, "unknown media field"])

	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["knowledge"][0]["effect"] = "UNKNOWN"
	cases.append([falsified, "unknown knowledge effect"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["traces"][0]["effect"] = "UNKNOWN"
	cases.append([falsified, "unknown trace effect"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["promises"][0]["effect"] = "UNKNOWN"
	cases.append([falsified, "unknown promise effect"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["obligations"][0]["effect"] = "UNKNOWN"
	cases.append([falsified, "unknown obligation effect"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["media_deliveries"][0]["effect"] = "UNKNOWN"
	cases.append([falsified, "unknown media effect"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["traces"][0]["effect"] = "WITHDRAW"
	cases.append([falsified, "trace shape incompatible with effect"])

	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["facts"][0]["event_key"] = ""
	cases.append([falsified, "empty event_key"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["knowledge"][0]["event_key"] = " spaced_event_key "
	cases.append([falsified, "event_key with surrounding spaces"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["traces"][0]["event_key"] = "A_NOT_DURABLE_KEY"
	cases.append([falsified, "event_key outside durable identifier alphabet"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["promises"][0]["event_key"] = "x".repeat(97)
	cases.append([falsified, "event_key above durable identifier limit"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["facts"].append(
		falsified["narrative_state"]["evenements"][event_id]["payload"]["facts"][0].duplicate(true)
	)
	cases.append([falsified, "duplicate event_key within category"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["knowledge"][0]["event_key"] = "n14_1c_fact"
	cases.append([falsified, "duplicate event_key across categories"])

	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["knowledge"][0].erase("knowledge_id")
	cases.append([falsified, "missing mandatory business identifier"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["knowledge"][0]["holder_ids"] = "player"
	cases.append([falsified, "identifier list with wrong type"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["knowledge"][0]["holder_ids"] = ["player", "player"]
	cases.append([falsified, "duplicate identifier in list"])
	falsified = resolved.duplicate(true)
	var duplicate_business_entry: Dictionary = falsified["narrative_state"]["evenements"][event_id]["payload"]["knowledge"][0].duplicate(true)
	duplicate_business_entry["event_key"] = "n14_1c_knowledge_second_operation"
	falsified["narrative_state"]["evenements"][event_id]["payload"]["knowledge"].append(duplicate_business_entry)
	cases.append([falsified, "duplicate business identifier within category"])

	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["facts"][0]["scope"] = "UNKNOWN"
	cases.append([falsified, "unknown fact scope"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["facts"][0].erase("personnage_id")
	cases.append([falsified, "RELATION without personnage_id"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["facts"][0]["scope"] = "RELATION_CENTRALE"
	cases.append([falsified, "RELATION_CENTRALE with personnage_id"])

	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["promises"][0]["effect"] = "NONE"
	cases.append([falsified, "NONE promise effect"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["obligations"][0]["effect"] = "NONE"
	cases.append([falsified, "NONE obligation effect"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["media_deliveries"][0]["effect"] = "NONE"
	cases.append([falsified, "NONE media effect"])

	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["media_deliveries"][0] = {
		"event_key": "n14_1c_media",
		"effect": "GRANT_ACCESS",
		"media_id": "n14_1c_media",
		"diegetic_status": "CREATED",
		"fictional_audience_ids": [],
		"gallery_status": "UNKNOWN",
	}
	cases.append([falsified, "unknown gallery_status"])
	falsified = resolved.duplicate(true)
	falsified["narrative_state"]["evenements"][event_id]["payload"]["media_deliveries"][0] = {
		"event_key": "n14_1c_media",
		"effect": "GRANT_ACCESS",
		"media_id": "n14_1c_media",
		"diegetic_status": "UNKNOWN",
		"fictional_audience_ids": [],
		"gallery_status": "AVAILABLE",
	}
	cases.append([falsified, "unknown diegetic_status"])

	for case in cases:
		_assert_payload_restore_rejection(sequence, case[0], case[1])

	var invalid_event: Dictionary = resolved["narrative_state"]["evenements"][event_id].duplicate(true)
	invalid_event["payload"]["facts"] = [42]
	_expect(ResolutionEvent.event_keys(invalid_event).is_empty(), "event_keys safely rejects scalar payload entry")
	var empty_event: Dictionary = resolved["narrative_state"]["evenements"][event_id].duplicate(true)
	for category in CATEGORIES:
		empty_event["payload"][category] = []
	_expect(
		ResolutionEvent.validate(empty_event) and ResolutionEvent.event_keys(empty_event).is_empty(),
		"globally empty event payload policy preserved",
	)


func _test_preparation_failures(sequence: Dictionary) -> void:
	var env := _activated_environment(sequence)
	var envelope := _envelope(sequence)
	var early_context := _context_with_envelope(envelope)
	early_context["moment_diegetique"] = "2032-03-04T10:00:00+01:00"
	var before: Dictionary = env["facade"].save_state()
	var a5_failure: Dictionary = env["facade"].resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", early_context
	)
	_expect(not a5_failure["ok"] and env["facade"].save_state() == before, "A5 preparation failure leaves A1 and A5 intact")

	var state = NarrativeStateModel.creer_synthetique(_central_state())
	var payload := _full_manifest_payload()
	payload["facts"] = [{"event_key": "first_reducer_failure", "scope": "RELATION", "personnage_id": "absent", "fact": {"fait_id": "bad"}}]
	var state_before: Dictionary = state.obtenir_snapshot()
	var first_failure: Dictionary = Reducer.preparer(state_before, payload, _expected_provenance("synthetic_failure"))
	_expect(not first_failure["ok"] and state.obtenir_snapshot() == state_before, "first reducer failure changes no real state")
	payload = _full_manifest_payload()
	payload["media_deliveries"] = [{"event_key": "last_reducer_failure", "effect": "WITHDRAW", "media_id": "absent_media"}]
	var last_failure: Dictionary = Reducer.preparer(state_before, payload, _expected_provenance("synthetic_failure"))
	_expect(not last_failure["ok"] and state.obtenir_snapshot() == state_before, "last reducer failure changes no real state")


func _test_additional_negative_matrix(sequence: Dictionary) -> void:
	var envelope := _envelope(sequence)
	var env := _activated_environment(sequence)
	var facade = env["facade"]
	var instance = facade._moteur.obtenir_instance(INSTANCE_ID)
	var definition: Dictionary = facade._bibliotheque.obtenir_definition(instance.obtenir_scene_definition_id())
	var before: Dictionary = facade.save_state()
	var wrong_definition := definition.duplicate(true)
	wrong_definition["scene_id"] = "other_definition"
	var definition_result: Dictionary = facade._coordinateur_resolution.resolve(
		facade._moteur, facade._etat_narratif, instance, wrong_definition,
		"a10_choice_commit", "a10_resolution_commit", _context_with_envelope(envelope)
	)
	_expect(not definition_result["ok"] and facade.save_state() == before, "divergent scene definition rejected without mutation")
	var wrong_version := definition.duplicate(true)
	wrong_version["version_contrat"] = "2.0.0"
	var version_result: Dictionary = facade._coordinateur_resolution.resolve(
		facade._moteur, facade._etat_narratif, instance, wrong_version,
		"a10_choice_commit", "a10_resolution_commit", _context_with_envelope(envelope)
	)
	_expect(not version_result["ok"] and facade.save_state() == before, "divergent definition version rejected without mutation")

	var proposed: Dictionary = before.duplicate(true)
	proposed["scene_registry"][0]["state"] = "ELIGIBLE"
	var non_proposed = _new_facade(sequence)
	_expect(non_proposed.restore_state(proposed)["ok"], "non PROPOSED fixture restored without termination")
	var non_proposed_before: Dictionary = non_proposed.save_state()
	var non_proposed_result: Dictionary = non_proposed.resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", _context_with_envelope(envelope)
	)
	_expect(not non_proposed_result["ok"] and non_proposed.save_state() == non_proposed_before, "instance non PROPOSED without termination rejected without mutation")

	facade.resolve_scene(INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", _context_with_envelope(envelope))
	var terminal_before: Dictionary = facade.save_state()
	var other_choice: Dictionary = facade.resolve_scene(
		INSTANCE_ID, "other_choice", "a10_resolution_commit", _context_with_envelope(envelope)
	)
	_expect(not other_choice["ok"] and other_choice["erreur"] == "RESOLUTION_TERMINALE_DIFFERENTE" and facade.save_state() == terminal_before, "already RESOLVED with other A10 choice rejected without mutation")
	var other_resolution: Dictionary = facade.resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "other_resolution", _context_with_envelope(envelope)
	)
	_expect(not other_resolution["ok"] and other_resolution["erreur"] == "RESOLUTION_TERMINALE_DIFFERENTE" and facade.save_state() == terminal_before, "already RESOLVED with other A10 resolution rejected without mutation")

	var invalid_a1 := _activated_environment(sequence)
	var invalid_a1_facade = invalid_a1["facade"]
	invalid_a1_facade._etat_narratif._etat["format_version"] = 99
	var invalid_a1_state: Dictionary = invalid_a1_facade._etat_narratif.obtenir_snapshot()
	var invalid_a1_registry: Array = invalid_a1_facade._moteur._registre.obtenir_snapshot()
	var invalid_a1_result: Dictionary = invalid_a1_facade.resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", _context_with_envelope(envelope)
	)
	_expect(not invalid_a1_result["ok"] and invalid_a1_facade._etat_narratif.obtenir_snapshot() == invalid_a1_state, "invalid A1 candidate rejected without A1 mutation")
	_expect(invalid_a1_facade._moteur._registre.obtenir_snapshot() == invalid_a1_registry, "invalid A1 candidate leaves A5 PROPOSED")

	var invalid_a5 := _activated_environment(sequence)
	var invalid_a5_facade = invalid_a5["facade"]
	invalid_a5_facade._moteur.obtenir_instance(INSTANCE_ID)._donnees["created_at"] = "INVALID"
	var invalid_a5_state: Dictionary = invalid_a5_facade._etat_narratif.obtenir_snapshot()
	var invalid_a5_registry: Array = invalid_a5_facade._moteur._registre.obtenir_snapshot()
	var invalid_a5_result: Dictionary = invalid_a5_facade.resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", _context_with_envelope(envelope)
	)
	_expect(not invalid_a5_result["ok"] and invalid_a5_facade._etat_narratif.obtenir_snapshot() == invalid_a5_state, "invalid A5 registry candidate rejected without A1 mutation")
	_expect(invalid_a5_facade._moteur._registre.obtenir_snapshot() == invalid_a5_registry, "invalid A5 registry candidate leaves real registry unchanged")


func _test_non_reentrant_guard(sequence: Dictionary) -> void:
	var env := _activated_environment(sequence)
	var facade = env["facade"]
	var before: Dictionary = facade.save_state()
	facade._coordinateur_resolution._publication_en_cours = true
	var rejected: Dictionary = facade.resolve_scene(
		INSTANCE_ID,
		"a10_choice_commit",
		"a10_resolution_commit",
		_context_with_envelope(_envelope(sequence)),
	)
	facade._coordinateur_resolution._publication_en_cours = false
	_expect(not rejected["ok"] and rejected["erreur"] == "N14_1_BLOCKED_ATOMIC_PUBLICATION", "non reentrant call rejected")
	_expect(facade.save_state() == before, "non reentrant rejection changes no snapshot")


func _test_historical_path() -> void:
	var sequence := _load_sequence()
	var env := _activated_environment(sequence)
	var result: Dictionary = env["facade"].resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", _context()
	)
	_expect(result["ok"] and result["state"] == "RESOLVED", "historical synthetic A1 path remains green")
	_expect(not env["facade"].save_state()["scene_registry"][0].has("resolution_receipt"), "historical A5 shape remains compatible")


func _assert_new_rejection(sequence: Dictionary, context: Dictionary, label: String, coordinator_direct := false) -> void:
	var env := _activated_environment(sequence)
	var facade = env["facade"]
	var before: Dictionary = facade.save_state()
	var result: Dictionary
	if coordinator_direct:
		var instance = facade._moteur.obtenir_instance(INSTANCE_ID)
		var definition = facade._bibliotheque.obtenir_definition(instance.obtenir_scene_definition_id())
		result = facade._coordinateur_resolution.resolve(
			facade._moteur, facade._etat_narratif, instance, definition,
			"a10_choice_commit", "a10_resolution_commit", context
		)
	else:
		result = facade.resolve_scene(INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", context)
	_expect(not result["ok"] and facade.save_state() == before, label + " without mutation")


func _assert_terminal_rejection(facade, context: Dictionary, error: String, label: String) -> void:
	var before: Dictionary = facade.save_state()
	var result: Dictionary = facade.resolve_scene(
		INSTANCE_ID, "a10_choice_commit", "a10_resolution_commit", context
	)
	_expect(not result["ok"] and result["erreur"] == error, label + " rejected")
	_expect(facade.save_state() == before, label + " leaves terminal snapshot identical")


func _assert_restore_rejection(sequence: Dictionary, snapshot: Dictionary, label: String) -> void:
	var facade = _new_facade(sequence)
	var before: Dictionary = facade.save_state()
	var result: Dictionary = facade.restore_state(snapshot)
	_expect(not result["ok"] and facade.save_state() == before, label + " rejected before publication")


func _assert_payload_restore_rejection(sequence: Dictionary, snapshot: Dictionary, label: String) -> void:
	var facade = _new_facade(sequence)
	var before: Dictionary = facade.save_state()
	var narrative_before: Dictionary = before["narrative_state"].duplicate(true)
	var ledger_before: Dictionary = narrative_before["evenements"].duplicate(true)
	var registry_before: Array = before["scene_registry"].duplicate(true)
	var result: Dictionary = facade.restore_state(snapshot)
	var after: Dictionary = facade.save_state()
	_expect(not result["ok"], label + " restore_state rejected")
	_expect(after["narrative_state"] == narrative_before, label + " narrative target unchanged")
	_expect(after["narrative_state"]["evenements"] == ledger_before, label + " ledger unchanged and no event added")
	_expect(after["scene_registry"] == registry_before, label + " A5 registry and instances unchanged")
	_expect(after == before, label + " complete target state unchanged")


func _assert_restored_replay_rejection(
	sequence: Dictionary, snapshot: Dictionary, error: String, label: String
) -> void:
	var facade = _new_facade(sequence)
	_expect(facade.restore_state(snapshot)["ok"], label + " restored for deferred cross-check")
	var before: Dictionary = facade.save_state()
	var result: Dictionary = facade.resolve_scene(
		INSTANCE_ID,
		"a10_choice_commit",
		"a10_resolution_commit",
		_context_with_envelope(_envelope(sequence)),
	)
	_expect(not result["ok"] and result["erreur"] == error, label + " rejected on terminal replay")
	_expect(facade.save_state() == before, label + " changes no restored state")


func _activated_environment(sequence: Dictionary) -> Dictionary:
	var facade = _new_facade(sequence)
	if facade == null:
		return {}
	var candidates: Dictionary = facade.find_candidates(_context())
	if not candidates.get("ok", false) or candidates["candidats"].size() != 1:
		print("N14_1C candidates failure: ", candidates)
		return {}
	var composition: Dictionary = facade.compose_slot(_slot_request(candidates["candidats"][0]))
	if not composition.get("ok", false):
		print("N14_1C composition failure: ", composition)
		return {}
	var activation: Dictionary = facade.activate_option(
		composition["plan"], "primary_option", {"intention": "PROPOSE", "context": _context()}
	)
	if not activation.get("ok", false):
		print("N14_1C activation failure: ", activation)
		return {}
	return {"facade": facade, "activation": activation}


func _new_facade(sequence: Dictionary):
	var entry: Dictionary = sequence["orchestration"]["a6_entry"]
	var loaded := LibraryModel.charger_depuis_bundle({
		"format": "R8C_A6_SCENE_LIBRARY", "version": 1, "definitions": [entry.duplicate(true)],
	})
	if not loaded.get("ok", false):
		print("N14_1C library failure: ", loaded)
		return null
	return FacadeModel.create(loaded["bibliotheque"], NarrativeStateModel.creer_synthetique(_central_state()))


func _envelope(sequence: Dictionary) -> Dictionary:
	var manifest: Dictionary = sequence["orchestration"]["a6_entry"]["definition"]["resolutions"]["a10_resolution_commit"]["durable_manifest"]
	var keys: Array = []
	for category in CATEGORIES:
		for effect in manifest[category]:
			keys.append(effect["event_key"])
	return {
		"instance_id": INSTANCE_ID,
		"sequence_id": manifest["binding"]["sequence_id"],
		"authored_version": manifest["binding"]["authored_version"],
		"choice_id": "choice_finish",
		"resolution_id": manifest["binding"]["resolution_id"],
		"a10_choice_id": "a10_choice_commit",
		"a10_resolution_id": "a10_resolution_commit",
		"terminal_checkpoint_id": "checkpoint_resolution_ready",
		"event_keys": keys,
	}


func _full_manifest() -> Dictionary:
	var manifest := _full_manifest_payload()
	manifest = {"binding": {"sequence_id": "synthetic_n13_durable_sequence", "authored_version": "1.0.0", "resolution_id": "resolution_complete"}}.merged(manifest)
	return manifest


func _full_manifest_payload() -> Dictionary:
	return {
		"facts": [{"event_key": "n14_1c_fact", "scope": "RELATION", "personnage_id": "sandra", "fact": {"fait_id": "n14_1c_fact", "nature": "OBSERVATION"}}],
		"knowledge": [{"event_key": "n14_1c_knowledge", "effect": "ACQUIRE", "knowledge_id": "n14_1c_knowledge", "subject_id": "n14_1c_subject", "holder_ids": ["player", "sandra"]}],
		"traces": [{"event_key": "n14_1c_trace", "effect": "CREATE", "trace_id": "n14_1c_trace", "creator_id": "sandra", "audience_ids": [], "controller_ids": [], "accessible_to_ids": []}],
		"promises": [{"event_key": "n14_1c_promise", "effect": "CREATE", "promise_id": "n14_1c_promise", "author_id": "sandra", "beneficiary_ids": ["player"], "content_ref": "n14_1c_content"}],
		"obligations": [{"event_key": "n14_1c_obligation", "effect": "CREATE_DUE", "obligation_id": "n14_1c_obligation", "debtor_id": "player", "beneficiary_ids": ["sandra"], "kind": "FOLLOW_UP"}],
		"media_deliveries": [{"event_key": "n14_1c_media", "effect": "CREATE_DIEGETIC", "media_id": "n14_1c_media", "fictional_audience_ids": []}],
	}


func _expected_provenance(event_id: String) -> Dictionary:
	return {
		"event_id": event_id,
		"source_scene_id": "synthetic_n13_durable_scene",
		"source_scene_instance_id": INSTANCE_ID,
		"source_a10_choice_id": "a10_choice_commit",
		"source_a10_resolution_id": "a10_resolution_commit",
		"source_sequence_id": "synthetic_n13_durable_sequence",
		"source_authored_version": "1.0.0",
		"source_resolution_id": "resolution_complete",
		"moment_diegetique": "2032-03-04T10:30:00+01:00",
	}


func _context_with_envelope(envelope: Dictionary) -> Dictionary:
	var value := _context()
	value["sequence_resolution"] = envelope.duplicate(true)
	return value


func _context() -> Dictionary:
	return {"acte_courant": "SYNTHETIC_TEST_ONLY", "moment_diegetique": "2032-03-04T10:30:00+01:00", "participants_disponibles": {"sandra": true}, "opportunite_valide": true}


func _central_state() -> Dictionary:
	return {"statut_couple": "EN_CLARIFICATION", "contrat_couple": null, "etat_divulgation": "PARTIEL", "etat_foyer": null, "relation_apres_separation": null, "dernier_evenement_majeur_id": null, "faits": [], "cadre_provisoire": null}


func _slot_request(candidate: Dictionary) -> Dictionary:
	return {
		"slot_id": "synthetic_n13_slot", "narrative_date": "2032-03-04", "starts_at": "2032-03-04T10:30:00+01:00", "ends_at": "2032-03-04T11:00:00+01:00", "context": _context(),
		"window": {"window_id": "synthetic_n13_window", "opens_at": "2032-03-04T10:00:00+01:00", "closes_at": "2032-03-04T11:00:00+01:00", "duration_minutes": 20, "not_before": "2032-03-04T10:30:00+01:00", "not_after": "2032-03-04T11:00:00+01:00", "options": [
			{"option_id": "primary_option", "candidate": candidate.duplicate(true), "instance_id": INSTANCE_ID, "conflict_policy": "CLOSE_SILENTLY"},
			{"option_id": "alternative_option", "candidate": candidate.duplicate(true), "instance_id": "synthetic_n13_alternative_instance", "conflict_policy": "CLOSE_SILENTLY"},
		]},
	}


func _load_sequence() -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(FIXTURE_PATH))
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	parsed["schema_version"] = int(parsed["schema_version"])
	parsed["orchestration"]["a6_entry"]["definition"]["contrat_temporel"]["duree_minutes"] = int(parsed["orchestration"]["a6_entry"]["definition"]["contrat_temporel"]["duree_minutes"])
	return parsed


func _expect(condition: bool, label: String) -> void:
	_checks += 1
	if not condition:
		_failed = true
		push_error("R8C_N14_1C_ATOMIC_RESOLUTION: failed control: %s" % label)


func _finish() -> void:
	if _failed:
		push_error("R8C_N14_1C_ATOMIC_RESOLUTION: KO (%d controls)" % _checks)
		get_tree().quit(1)
		return
	print("R8C_N14_1C_ATOMIC_RESOLUTION: OK (%d controls)" % _checks)
	get_tree().quit(0)
