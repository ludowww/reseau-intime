extends Node

const SceneDefinition := preload("res://scripts/narrative_scene/SceneDefinition.gd")
const AuthoredValidator := preload("res://scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd")
const NarrativeStateCodec := preload("res://scripts/narrative_scene/A5NarrativeStateCodec.gd")
const NarrativeState := preload("res://scripts/narrative_state/EtatNarratif.gd")
const RuntimeSnapshot := preload("res://scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd")

const FIXTURE_PATH := "res://tests/fixtures/unified_runtime/authored_sequence_v1_minimal_valid.json"
const DURABLE_CATEGORIES := ["facts", "knowledge", "traces", "promises", "obligations", "media_deliveries"]

var failures: Array[String] = []
var controls := 0


func _ready() -> void:
	_test_manifests()
	_test_codec_v2()
	_finish()


func _test_manifests() -> void:
	var sequence := _load_sequence()
	_expect(not sequence.is_empty(), "manifest fixture loaded")
	if sequence.is_empty():
		return
	_expect(AuthoredValidator.validate(sequence)["valid"], "minimal durable manifest valid")
	_expect(_definition_valid(sequence), "minimal durable manifest valid in A6")
	_expect(
		sequence["resolutions"]["resolution_complete"]["media_effects"] == [{
			"media_id": "synthetic_media", "effect": "NONE",
		}]
		and _manifest(sequence)["media_deliveries"].is_empty()
		and not _authored_event_keys(sequence, "resolution_complete").has("synthetic_media"),
		"local authored NONE has no manifest entry or event_key",
	)

	var local_absent: Dictionary = sequence["orchestration"]["a6_entry"]["definition"].duplicate(true)
	_make_resolution_local(local_absent["resolutions"]["a3_resolution_continue"])
	local_absent["resolutions"]["a3_resolution_continue"].erase("durable_manifest")
	_expect(SceneDefinition.valider_fermee(local_absent).is_empty(), "local manifest absent accepted")
	var local_empty: Dictionary = local_absent.duplicate(true)
	local_empty["resolutions"]["a3_resolution_continue"]["durable_manifest"] = {}
	_expect(SceneDefinition.valider_fermee(local_empty).is_empty(), "local empty manifest accepted")

	var full := sequence.duplicate(true)
	full["orchestration"]["a6_entry"]["definition"]["resolutions"]["a3_resolution_continue"]["durable_manifest"] = _full_manifest()
	_bind_authored_effects_to_manifest(full, "resolution_complete")
	_expect(AuthoredValidator.validate(full)["valid"] and _definition_valid(full), "six ordered categories accepted")
	var order_before: Dictionary = _manifest(full).duplicate(true)
	AuthoredValidator.validate(full)
	SceneDefinition.valider_fermee(full["orchestration"]["a6_entry"]["definition"])
	_expect(_manifest(full) == order_before, "authored category and entry order preserved")

	var missing_event_ref := full.duplicate(true)
	missing_event_ref["resolutions"]["resolution_complete"]["event_refs"].remove_at(0)
	_expect(not AuthoredValidator.validate(missing_event_ref)["valid"], "missing authored event_ref rejected")
	var extra_event_ref := full.duplicate(true)
	extra_event_ref["resolutions"]["resolution_complete"]["event_refs"].append({
		"event_type": "durable_manifest_event",
		"event_key": "unexpected_manifest_event",
		"reducer_id": "a6_durable_manifest",
	})
	_expect(not AuthoredValidator.validate(extra_event_ref)["valid"], "extra authored event_ref rejected")
	var duplicate_event_ref := full.duplicate(true)
	duplicate_event_ref["resolutions"]["resolution_complete"]["event_refs"].append(
		duplicate_event_ref["resolutions"]["resolution_complete"]["event_refs"][0].duplicate(true)
	)
	_expect(not AuthoredValidator.validate(duplicate_event_ref)["valid"], "duplicate authored event_ref rejected")
	var divergent_event_order := full.duplicate(true)
	var reordered_refs: Array = divergent_event_order["resolutions"]["resolution_complete"]["event_refs"]
	var first_ref = reordered_refs[0]
	reordered_refs[0] = reordered_refs[1]
	reordered_refs[1] = first_ref
	_expect(not AuthoredValidator.validate(divergent_event_order)["valid"], "divergent authored event_ref order rejected")

	var divergent_fact_ids := full.duplicate(true)
	divergent_fact_ids["resolutions"]["resolution_complete"]["fact_ids"][0] = "other_fact"
	_expect(not AuthoredValidator.validate(divergent_fact_ids)["valid"], "divergent authored fact_ids rejected")
	var divergent_knowledge_ids := full.duplicate(true)
	divergent_knowledge_ids["resolutions"]["resolution_complete"]["knowledge_ids"][0] = "other_knowledge"
	_expect(not AuthoredValidator.validate(divergent_knowledge_ids)["valid"], "divergent authored knowledge_ids rejected")
	var divergent_trace_ids := full.duplicate(true)
	divergent_trace_ids["resolutions"]["resolution_complete"]["trace_ids"][0] = "other_trace"
	_expect(not AuthoredValidator.validate(divergent_trace_ids)["valid"], "divergent authored trace_ids rejected")
	var divergent_promise := full.duplicate(true)
	divergent_promise["resolutions"]["resolution_complete"]["promise_effects"][0]["effect"] = "PAY"
	_expect(not AuthoredValidator.validate(divergent_promise)["valid"], "divergent authored promise effect rejected")
	var divergent_obligation := full.duplicate(true)
	divergent_obligation["resolutions"]["resolution_complete"]["obligation_effects"][0]["effect"] = "FAIL"
	_expect(not AuthoredValidator.validate(divergent_obligation)["valid"], "divergent authored obligation effect rejected")
	var divergent_media := full.duplicate(true)
	divergent_media["resolutions"]["resolution_complete"]["media_effects"][0]["effect"] = "REVOKE_ACCESS"
	_expect(not AuthoredValidator.validate(divergent_media)["valid"], "divergent authored media effect rejected")
	var unrepresented_manifest_effect := full.duplicate(true)
	unrepresented_manifest_effect["resolutions"]["resolution_complete"]["promise_effects"] = []
	_expect(not AuthoredValidator.validate(unrepresented_manifest_effect)["valid"], "manifest effect without authored representation rejected")

	var extra_category := full.duplicate(true)
	_manifest(extra_category)["unknown_category"] = []
	_expect(_both_reject(extra_category), "unknown manifest category rejected with parity")
	var binding_missing := full.duplicate(true)
	_manifest(binding_missing)["binding"].erase("resolution_id")
	_expect(_both_reject(binding_missing), "incomplete binding rejected with parity")
	var binding_extra := full.duplicate(true)
	_manifest(binding_extra)["binding"]["unexpected"] = true
	_expect(_both_reject(binding_extra), "binding unknown field rejected with parity")
	var binding_mismatch := full.duplicate(true)
	_manifest(binding_mismatch)["binding"]["resolution_id"] = "resolution_stop"
	_expect(not AuthoredValidator.validate(binding_mismatch)["valid"], "divergent binding rejected")
	var sequence_binding_mismatch := full.duplicate(true)
	_manifest(sequence_binding_mismatch)["binding"]["sequence_id"] = "other_sequence"
	_expect(not AuthoredValidator.validate(sequence_binding_mismatch)["valid"], "divergent sequence binding rejected")
	var version_binding_mismatch := full.duplicate(true)
	_manifest(version_binding_mismatch)["binding"]["authored_version"] = "2.0.0"
	_expect(not AuthoredValidator.validate(version_binding_mismatch)["valid"], "divergent version binding rejected")
	var missing_manifest := sequence.duplicate(true)
	missing_manifest["orchestration"]["a6_entry"]["definition"]["resolutions"]["a3_resolution_continue"].erase("durable_manifest")
	_expect(not AuthoredValidator.validate(missing_manifest)["valid"], "committable resolution requires manifest")
	var effectless_manifest := full.duplicate(true)
	for category in DURABLE_CATEGORIES:
		_manifest(effectless_manifest)[category] = []
	_expect(_both_reject(effectless_manifest), "committable effectless manifest rejected with parity")
	var local_non_empty := full.duplicate(true)
	_make_resolution_local(local_non_empty["orchestration"]["a6_entry"]["definition"]["resolutions"]["a3_resolution_continue"])
	_expect(_both_reject(local_non_empty), "non-empty local manifest rejected with parity")

	var unknown_effect := full.duplicate(true)
	_manifest(unknown_effect)["promises"][0]["effect"] = "NONE"
	_expect(_both_reject(unknown_effect), "NONE present in manifest rejected with parity")
	var unknown_field := full.duplicate(true)
	_manifest(unknown_field)["knowledge"][0]["provenance"] = {}
	_expect(_both_reject(unknown_field), "manifest provenance rejected with parity")
	var derived_status := full.duplicate(true)
	_manifest(derived_status)["knowledge"][0]["status"] = "KNOWN"
	_expect(_both_reject(derived_status), "derived status rejected with parity")
	var empty_event_key := full.duplicate(true)
	_manifest(empty_event_key)["facts"][0]["event_key"] = ""
	_expect(_both_reject(empty_event_key), "empty event key rejected with parity")
	var duplicate_inside := full.duplicate(true)
	_manifest(duplicate_inside)["facts"][1]["event_key"] = _manifest(duplicate_inside)["facts"][0]["event_key"]
	_expect(_both_reject(duplicate_inside), "duplicate event key in category rejected with parity")
	var duplicate_across := full.duplicate(true)
	_manifest(duplicate_across)["knowledge"][0]["event_key"] = _manifest(duplicate_across)["facts"][0]["event_key"]
	_expect(_both_reject(duplicate_across), "duplicate event key across categories rejected with parity")

	var relation_missing_person := full.duplicate(true)
	_manifest(relation_missing_person)["facts"][0].erase("personnage_id")
	_expect(_both_reject(relation_missing_person), "RELATION requires personnage_id")
	var central_with_person := full.duplicate(true)
	_manifest(central_with_person)["facts"][1]["personnage_id"] = null
	_expect(_both_reject(central_with_person), "RELATION_CENTRALE forbids personnage_id even null")
	var incoherent_fact := full.duplicate(true)
	_manifest(incoherent_fact)["facts"][0]["fact"] = {"nature": "SYNTHETIC_TEST_ONLY"}
	_expect(_both_reject(incoherent_fact), "incoherent relational fact rejected with parity")
	var empty_business_id := full.duplicate(true)
	_manifest(empty_business_id)["traces"][0]["trace_id"] = ""
	_expect(_both_reject(empty_business_id), "empty durable business id rejected with parity")
	_expect(
		_manifest(full)["facts"][0]["scope"] == "RELATION"
		and _manifest(full)["facts"][1]["scope"] == "RELATION_CENTRALE",
		"RELATION and RELATION_CENTRALE valid forms covered",
	)

	var withdraw := full.duplicate(true)
	_manifest(withdraw)["media_deliveries"] = [{
		"event_key": "manifest_media",
		"effect": "WITHDRAW",
		"media_id": "synthetic_media",
	}]
	_bind_authored_effects_to_manifest(withdraw, "resolution_complete")
	_expect(AuthoredValidator.validate(withdraw)["valid"] and _definition_valid(withdraw), "coherent authored manifest WITHDRAW accepted")
	var divergent_withdraw := withdraw.duplicate(true)
	divergent_withdraw["resolutions"]["resolution_complete"]["media_effects"][0]["effect"] = "REVOKE_ACCESS"
	_expect(not AuthoredValidator.validate(divergent_withdraw)["valid"], "divergent authored manifest WITHDRAW rejected")


func _test_codec_v2() -> void:
	var state = _new_state()
	_expect(state != null, "synthetic narrative state created")
	if state == null:
		return
	var empty_v2: Dictionary = state.obtenir_snapshot()
	_expect(empty_v2["format_version"] == 2 and NarrativeStateCodec.valider(empty_v2), "empty v2 snapshot valid")

	var populated := empty_v2.duplicate(true)
	_populate_registries(populated)
	_expect(NarrativeStateCodec.valider(populated), "v2 with all five registries valid")
	var restored_v2 = NarrativeStateCodec.creer_etat(populated)
	_expect(restored_v2 != null and restored_v2.obtenir_snapshot() == populated, "v2 restores exactly")

	var v1_missing := empty_v2.duplicate(true)
	v1_missing.erase("format_version")
	for registry in NarrativeStateCodec.REGISTRES_DURABLES:
		v1_missing.erase(registry)
	var v1_missing_before := v1_missing.duplicate(true)
	var restored_missing = NarrativeStateCodec.creer_etat(v1_missing)
	_expect(restored_missing != null, "v1 with missing registries accepted")
	_expect(v1_missing == v1_missing_before, "accepted v1 input not mutated")
	if restored_missing != null:
		var normalized: Dictionary = restored_missing.obtenir_snapshot()
		var normalized_empty: bool = normalized.get("format_version") == 2
		for registry in NarrativeStateCodec.REGISTRES_DURABLES:
			normalized_empty = normalized_empty and normalized.has(registry) and normalized[registry].is_empty()
		_expect(normalized_empty, "v1 normalized to complete v2")
		_expect(NarrativeStateCodec.valider(normalized), "snapshot after v1 restoration is v2")

	var v1_empty := empty_v2.duplicate(true)
	v1_empty.erase("format_version")
	_expect(NarrativeStateCodec.creer_etat(v1_empty) != null, "v1 with five empty registries accepted")
	var v1_non_empty := v1_empty.duplicate(true)
	v1_non_empty["promesses"]["legacy_promise"] = {}
	var rejected_before := v1_non_empty.duplicate(true)
	_expect(NarrativeStateCodec.creer_etat(v1_non_empty) == null, "v1 with non-empty registry rejected")
	_expect(v1_non_empty == rejected_before, "rejected v1 input not mutated")

	var explicit_v1 := empty_v2.duplicate(true)
	explicit_v1["format_version"] = 1
	_expect(not NarrativeStateCodec.valider(explicit_v1), "explicit format version 1 rejected")
	var unknown_version := empty_v2.duplicate(true)
	unknown_version["format_version"] = 3
	_expect(not NarrativeStateCodec.valider(unknown_version), "unknown format version rejected")
	var float_version := empty_v2.duplicate(true)
	float_version["format_version"] = 2.0
	_expect(not NarrativeStateCodec.valider(float_version), "non-integer format version rejected")
	var missing_root := empty_v2.duplicate(true)
	missing_root.erase("relations")
	_expect(not NarrativeStateCodec.valider(missing_root), "missing v2 root rejected")
	var wrong_root_type := empty_v2.duplicate(true)
	wrong_root_type["connaissances"] = []
	_expect(not NarrativeStateCodec.valider(wrong_root_type), "wrong registry root type rejected")

	var extra_record_field := populated.duplicate(true)
	extra_record_field["connaissances"]["synthetic_knowledge"]["unexpected"] = true
	_expect(not NarrativeStateCodec.valider(extra_record_field), "unknown durable record field rejected")
	var unknown_status := populated.duplicate(true)
	unknown_status["promesses"]["synthetic_promise"]["status"] = "UNKNOWN"
	_expect(not NarrativeStateCodec.valider(unknown_status), "unknown durable status rejected")
	var duplicate_ids := populated.duplicate(true)
	duplicate_ids["connaissances"]["synthetic_knowledge"]["holder_ids"].append("player")
	_expect(not NarrativeStateCodec.valider(duplicate_ids), "duplicate identifier array rejected")
	var incomplete_provenance := populated.duplicate(true)
	incomplete_provenance["obligations"]["synthetic_obligation"]["provenance"].erase("source_resolution_id")
	_expect(not NarrativeStateCodec.valider(incomplete_provenance), "incomplete provenance rejected")
	var divergent_record := populated.duplicate(true)
	divergent_record["traces_narratives"]["synthetic_trace"]["trace_id"] = "other_trace"
	_expect(not NarrativeStateCodec.valider(divergent_record), "record key identity divergence rejected")
	var incoherent_transition := populated.duplicate(true)
	incoherent_transition["promesses"]["synthetic_promise"]["resolved_at"] = _moment()
	_expect(not NarrativeStateCodec.valider(incoherent_transition), "incoherent represented transition rejected")
	_expect(
		RuntimeSnapshot.SCHEMA_ID == "reseau_intime.unified_runtime"
		and RuntimeSnapshot.SCHEMA_VERSION == 1
		and RuntimeSnapshot.DOMAIN_FIELDS == ["version", "narrative_state", "scene_registry"],
		"N13 outer snapshot envelope remains v1",
	)


func _full_manifest() -> Dictionary:
	return {
		"binding": {
			"sequence_id": "synthetic_projection_contract_01",
			"authored_version": "1.0.0",
			"resolution_id": "resolution_complete",
		},
		"facts": [
			{
				"event_key": "manifest_relation_fact",
				"scope": "RELATION",
				"personnage_id": "synthetic_actor",
				"fact": {"fait_id": "manifest_relation_fact", "nature": "SYNTHETIC_TEST_ONLY"},
			},
			{
				"event_key": "manifest_central_fact",
				"scope": "RELATION_CENTRALE",
				"fact": {"fait_id": "manifest_central_fact", "nature": "SYNTHETIC_TEST_ONLY"},
			},
		],
		"knowledge": [{
			"event_key": "manifest_knowledge", "effect": "ACQUIRE", "knowledge_id": "synthetic_knowledge",
			"subject_id": "synthetic_subject", "holder_ids": ["player"],
		}],
		"traces": [{
			"event_key": "manifest_trace", "effect": "CREATE", "trace_id": "synthetic_trace",
			"creator_id": "synthetic_actor", "audience_ids": ["synthetic_actor"], "controller_ids": [],
			"accessible_to_ids": ["player"],
		}],
		"promises": [{
			"event_key": "manifest_promise", "effect": "CREATE", "promise_id": "synthetic_promise",
			"author_id": "synthetic_actor", "beneficiary_ids": ["player"], "content_ref": "synthetic_content",
		}],
		"obligations": [{
			"event_key": "manifest_obligation", "effect": "PAY", "obligation_id": "synthetic_obligation",
		}],
		"media_deliveries": [{
			"event_key": "manifest_media", "effect": "GRANT_ACCESS", "media_id": "synthetic_media",
			"diegetic_status": "NOT_APPLICABLE", "fictional_audience_ids": [], "gallery_status": "HIDDEN",
		}],
	}


func _bind_authored_effects_to_manifest(sequence: Dictionary, resolution_id: String) -> void:
	var resolution: Dictionary = sequence["resolutions"][resolution_id]
	var a10_resolution_id: String = resolution["a10_resolution_id"]
	var manifest: Dictionary = sequence["orchestration"]["a6_entry"]["definition"]["resolutions"][a10_resolution_id]["durable_manifest"]
	resolution["event_refs"] = []
	resolution["fact_ids"] = []
	resolution["knowledge_ids"] = []
	resolution["trace_ids"] = []
	resolution["promise_effects"] = []
	resolution["obligation_effects"] = []
	resolution["media_effects"] = []
	for category in DURABLE_CATEGORIES:
		for entry in manifest[category]:
			resolution["event_refs"].append({
				"event_type": "durable_manifest_event",
				"event_key": entry["event_key"],
				"reducer_id": "a6_durable_manifest",
			})
			if category == "facts":
				resolution["fact_ids"].append(entry["fact"]["fait_id"])
			elif category == "knowledge":
				resolution["knowledge_ids"].append(entry["knowledge_id"])
			elif category == "traces":
				resolution["trace_ids"].append(entry["trace_id"])
			elif category == "promises":
				resolution["promise_effects"].append({
					"promise_id": entry["promise_id"], "effect": entry["effect"],
				})
			elif category == "obligations":
				resolution["obligation_effects"].append({
					"obligation_id": entry["obligation_id"], "effect": entry["effect"],
				})
			elif category == "media_deliveries":
				resolution["media_effects"].append({
					"media_id": entry["media_id"], "effect": entry["effect"],
				})


func _authored_event_keys(sequence: Dictionary, resolution_id: String) -> Array:
	var event_keys: Array = []
	for event_ref in sequence["resolutions"][resolution_id]["event_refs"]:
		event_keys.append(event_ref["event_key"])
	return event_keys


func _populate_registries(snapshot: Dictionary) -> void:
	var provenance := _provenance()
	snapshot["connaissances"]["synthetic_knowledge"] = {
		"knowledge_id": "synthetic_knowledge", "subject_id": "synthetic_subject", "holder_ids": ["player"],
		"status": "KNOWN", "provenance": provenance.duplicate(true),
	}
	snapshot["traces_narratives"]["synthetic_trace"] = {
		"trace_id": "synthetic_trace", "creator_id": "synthetic_actor", "audience_ids": ["synthetic_actor"],
		"controller_ids": [], "accessible_to_ids": ["player"], "status": "ACTIVE",
		"provenance": provenance.duplicate(true), "withdrawn_at": null,
	}
	snapshot["promesses"]["synthetic_promise"] = {
		"promise_id": "synthetic_promise", "author_id": "synthetic_actor", "beneficiary_ids": ["player"],
		"content_ref": "synthetic_content", "status": "ACTIVE", "provenance": provenance.duplicate(true),
		"resolved_at": null,
	}
	snapshot["obligations"]["synthetic_obligation"] = {
		"obligation_id": "synthetic_obligation", "debtor_id": "synthetic_actor", "beneficiary_ids": ["player"],
		"kind": "SYNTHETIC_TEST_ONLY", "status": "DUE", "provenance": provenance.duplicate(true),
		"resolved_at": null,
	}
	snapshot["livraison_medias"]["synthetic_media"] = {
		"media_id": "synthetic_media", "diegetic_status": "NOT_APPLICABLE", "fictional_audience_ids": [],
		"access_status": "ACCESSIBLE", "gallery_status": "AVAILABLE", "withdrawal_status": "ACTIVE",
		"provenance": provenance.duplicate(true),
	}


func _provenance() -> Dictionary:
	return {
		"event_id": "r8c-a1:synthetic-instance:sequence-resolution:a3_resolution_continue",
		"source_scene_id": "synthetic_scene",
		"source_scene_instance_id": "synthetic_instance",
		"source_a10_choice_id": "choice_start",
		"source_a10_resolution_id": "a3_resolution_continue",
		"source_sequence_id": "synthetic_projection_contract_01",
		"source_authored_version": "1.0.0",
		"source_resolution_id": "resolution_complete",
		"moment_diegetique": _moment(),
	}


func _moment() -> String:
	return "2032-03-04T10:30:00+01:00"


func _new_state():
	return NarrativeState.creer_synthetique({
		"statut_couple": "EN_CLARIFICATION", "contrat_couple": null, "etat_divulgation": "PARTIEL",
		"etat_foyer": null, "relation_apres_separation": null, "dernier_evenement_majeur_id": null,
		"faits": [], "cadre_provisoire": null,
	})


func _manifest(sequence: Dictionary) -> Dictionary:
	return sequence["orchestration"]["a6_entry"]["definition"]["resolutions"]["a3_resolution_continue"]["durable_manifest"]


func _definition_valid(sequence: Dictionary) -> bool:
	return SceneDefinition.valider_fermee(sequence["orchestration"]["a6_entry"]["definition"]).is_empty()


func _both_reject(sequence: Dictionary) -> bool:
	return not AuthoredValidator.validate(sequence)["valid"] and not _definition_valid(sequence)


func _make_resolution_local(resolution: Dictionary) -> void:
	resolution["portee_micro_signal"] = "LOCALE"
	resolution["reception"] = "NON_PERSISTANTE"
	resolution["faits_relationnels"] = []


func _load_sequence() -> Dictionary:
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(FIXTURE_PATH))
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	parsed["schema_version"] = int(parsed["schema_version"])
	parsed["orchestration"]["a6_entry"]["definition"]["contrat_temporel"]["duree_minutes"] = int(
		parsed["orchestration"]["a6_entry"]["definition"]["contrat_temporel"]["duree_minutes"]
	)
	parsed["orchestration"]["a9_slot"]["duration_minutes"] = int(parsed["orchestration"]["a9_slot"]["duration_minutes"])
	parsed["orchestration"]["a9_slot"]["relative_order"] = int(parsed["orchestration"]["a9_slot"]["relative_order"])
	parsed["temporal_projection"]["offset_minutes"] = int(parsed["temporal_projection"]["offset_minutes"])
	parsed["temporal_projection"]["relative_order"] = int(parsed["temporal_projection"]["relative_order"])
	if parsed["temporal_projection"]["delay"]["value"] != null:
		parsed["temporal_projection"]["delay"]["value"] = int(parsed["temporal_projection"]["delay"]["value"])
	for beat in parsed["beats"]:
		if beat["type"] == "MESSAGE":
			for message in beat["content"]["messages"]:
				message["relative_order"] = int(message["relative_order"])
		if beat["type"] == "RETURN" and beat["content"]["delay"]["value"] != null:
			beat["content"]["delay"]["value"] = int(beat["content"]["delay"]["value"])
	return parsed


func _expect(condition: bool, message: String) -> void:
	controls += 1
	if not condition:
		failures.append(message)


func _finish() -> void:
	if failures.is_empty():
		print("R8C_N14_1A_MANIFEST_CODEC_V2: OK (%d controls)" % controls)
		get_tree().quit(0)
		return
	for failure in failures:
		push_error("R8C_N14_1A: " + failure)
	get_tree().quit(1)
