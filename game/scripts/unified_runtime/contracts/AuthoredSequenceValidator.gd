extends RefCounted

class_name R8CAuthoredSequenceValidator

const Contract := preload("res://scripts/unified_runtime/contracts/AuthoredSequenceV1.gd")

const A6_DEFINITION_REQUIRED_FIELDS := [
	"scene_id", "version_contrat", "nature", "fonction_principale", "participants_requis",
	"conditions_dures", "exclusions_dures", "contrat_temporel", "politique_unicite", "resolutions",
]
const A6_DEFINITION_OPTIONAL_FIELDS := [
	"titre_interne", "relation_ou_question_focale", "noyau_stable", "structure_id", "choix",
	"politique_non_resolution",
]
const A6_PARTICIPANT_FIELDS := ["personnage_id", "role"]
const A6_CONDITION_FIELDS := ["actes_compatibles", "evenements_requis"]
const A6_EXCLUSION_FIELDS := ["evenements_interdits"]
const A6_TEMPORAL_FIELDS := [
	"date_debut", "date_fin", "heure_ouverture", "heure_fermeture", "duree_minutes", "revalidation",
]
const A6_CHOICE_FIELDS := ["choix_id", "formulation", "signal_emis", "resolution_ids"]
const A6_RESOLUTION_FIELDS := [
	"personnage_id", "portee_micro_signal", "signal_recu", "reception", "interpretation",
	"faits_relationnels", "convergence", "trace_temporaire", "durable_manifest",
]
const A6_RESOLUTION_REQUIRED_FIELDS := [
	"personnage_id", "portee_micro_signal", "signal_recu", "reception", "interpretation",
	"faits_relationnels", "convergence",
]
const A6_TRACE_FIELDS := ["trace_id", "contenu"]
const A6_RELATIONAL_FACT_FIELDS := [
	"fait_id", "nature", "recu_par", "permission_future", "formulee_par",
]
const A6_NON_RESOLUTION_FIELDS := ["proposition_expire", "consequence_manquee"]
const A6_MISSED_CONSEQUENCE_FIELDS := ["personnage_id", "fait_relationnel"]
const A6_NATURES := ["SIGNATURE", "MODULAIRE"]
const A6_FUNCTIONS := ["RELATION", "OPPORTUNITE", "ECHO", "RESPIRATION"]
const A6_UNIQUENESS_POLICIES := ["UNIQUE", "REPETABLE"]
const A6_SIGNAL_SCOPES := ["LOCALE", "TEMPORAIRE", "DURABLE"]
const A6_RECEPTIONS := ["NON_PERSISTANTE", "RECUE_INTERPRETEE", "LIMITE_EXPLICITE"]
const A6_REVALIDATION_POLICIES := ["AVANT_PROPOSITION", "AVANT_PROPOSITION_ET_RESOLUTION"]
const AUTHORED_DURABLE_EFFECT_FIELDS := [
	"event_refs",
	"fact_ids",
	"knowledge_ids",
	"trace_ids",
	"promise_effects",
	"obligation_effects",
	"consequence_ids",
	"media_effects",
]
const A6_DURABLE_MANIFEST_FIELDS := [
	"binding", "facts", "knowledge", "traces", "promises", "obligations", "media_deliveries",
]
const A6_DURABLE_BINDING_FIELDS := ["sequence_id", "authored_version", "resolution_id"]
const A6_DURABLE_CATEGORIES := ["facts", "knowledge", "traces", "promises", "obligations", "media_deliveries"]
const A6_DURABLE_FACT_RELATION_FIELDS := ["event_key", "scope", "personnage_id", "fact"]
const A6_DURABLE_FACT_CENTRAL_FIELDS := ["event_key", "scope", "fact"]
const A6_DURABLE_KNOWLEDGE_FIELDS := ["event_key", "effect", "knowledge_id", "subject_id", "holder_ids"]
const A6_DURABLE_TRACE_CREATE_FIELDS := [
	"event_key", "effect", "trace_id", "creator_id", "audience_ids", "controller_ids", "accessible_to_ids",
]
const A6_DURABLE_TRACE_ACCESS_FIELDS := ["event_key", "effect", "trace_id", "accessible_to_ids"]
const A6_DURABLE_TRACE_TERMINAL_FIELDS := ["event_key", "effect", "trace_id"]
const A6_DURABLE_PROMISE_CREATE_FIELDS := [
	"event_key", "effect", "promise_id", "author_id", "beneficiary_ids", "content_ref",
]
const A6_DURABLE_PROMISE_TERMINAL_FIELDS := ["event_key", "effect", "promise_id"]
const A6_DURABLE_OBLIGATION_CREATE_FIELDS := [
	"event_key", "effect", "obligation_id", "debtor_id", "beneficiary_ids", "kind",
]
const A6_DURABLE_OBLIGATION_TERMINAL_FIELDS := ["event_key", "effect", "obligation_id"]
const A6_DURABLE_MEDIA_CREATE_FIELDS := ["event_key", "effect", "media_id", "fictional_audience_ids"]
const A6_DURABLE_MEDIA_GRANT_FIELDS := [
	"event_key", "effect", "media_id", "diegetic_status", "fictional_audience_ids", "gallery_status",
]
const A6_DURABLE_MEDIA_TERMINAL_FIELDS := ["event_key", "effect", "media_id"]
const A6_DURABLE_FACT_FIELDS := ["fait_id", "nature", "recu_par", "permission_future", "formulee_par"]


static func validate(value) -> Dictionary:
	var errors: Array[String] = []
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, "root", "expected_dictionary")
		return _result(errors)
	var sequence: Dictionary = value
	_validate_exact_fields(sequence, Contract.ROOT_FIELDS, "root", errors)
	if not _has_required_fields(sequence, Contract.ROOT_FIELDS):
		return _result(errors)

	_validate_root_scalars(sequence, errors)
	_validate_author_provenance(sequence["author_provenance"], errors)
	var participant_context := _validate_participants(sequence["participants"], errors)
	_validate_orchestration(sequence["orchestration"], errors)
	_validate_temporal_projection(sequence["temporal_projection"], sequence["orchestration"], errors)

	var graph_context := _validate_beats(sequence["beats"], participant_context, errors)
	var resolution_context := _validate_resolutions(sequence["resolutions"], errors)
	var media_context := _validate_media(sequence["media"], participant_context, errors)
	_validate_references(sequence, graph_context, resolution_context, media_context, errors)
	_validate_graph(sequence.get("entry_beat_id"), graph_context, errors)
	return _result(errors)


static func _validate_root_scalars(sequence: Dictionary, errors: Array[String]) -> void:
	if sequence["schema_id"] != Contract.SCHEMA_ID:
		_add_error(errors, "root.schema_id", "expected_reseau_intime_authored_sequence")
	if not _integer_equals(sequence["schema_version"], Contract.SCHEMA_VERSION):
		_add_error(errors, "root.schema_version", "expected_integer_1")
	_validate_business_id(sequence["sequence_id"], "root.sequence_id", errors)
	if not _is_semver(sequence["authored_version"]):
		_add_error(errors, "root.authored_version", "expected_major_minor_patch")
	_validate_business_id(sequence["season_id"], "root.season_id", errors)
	if sequence["dramatic_movement_id"] not in Contract.DRAMATIC_MOVEMENTS:
		_add_error(errors, "root.dramatic_movement_id", "unknown_value")
	if sequence["narrative_function"] not in Contract.NARRATIVE_FUNCTIONS:
		_add_error(errors, "root.narrative_function", "unknown_value")
	if sequence["canonical_status"] != Contract.CANONICAL_STATUS:
		_add_error(errors, "root.canonical_status", "expected_canon_approved")
	_validate_business_id(sequence["entry_beat_id"], "root.entry_beat_id", errors)


static func _validate_author_provenance(value, errors: Array[String]) -> void:
	if not _validate_dictionary(value, Contract.AUTHOR_PROVENANCE_FIELDS, "root.author_provenance", errors):
		return
	_validate_non_empty_string_array(
		value["source_document_paths"], "root.author_provenance.source_document_paths", errors
	)
	_validate_non_empty_string_array(
		value["source_sequence_ids"], "root.author_provenance.source_sequence_ids", errors
	)
	_validate_non_empty_string(value["approval_ref"], "root.author_provenance.approval_ref", errors)
	if value["authoring_tool_ref"] != null:
		_validate_non_empty_string(
			value["authoring_tool_ref"], "root.author_provenance.authoring_tool_ref", errors
		)


static func _validate_participants(value, errors: Array[String]) -> Dictionary:
	var context := {"all_ids": {}, "audiences": {}}
	if not _validate_dictionary(value, Contract.PARTICIPANTS_FIELDS, "root.participants", errors):
		return context
	var present := _validate_id_array(
		value["present_character_ids"], "root.participants.present_character_ids", errors, true
	)
	var absent := _validate_id_array(
		value["concerned_absent_character_ids"],
		"root.participants.concerned_absent_character_ids",
		errors,
		false,
	)
	for participant_id in present:
		context["all_ids"][participant_id] = true
	for participant_id in absent:
		if context["all_ids"].has(participant_id):
			_add_error(errors, "root.participants", "present_and_absent_overlap_%s" % participant_id)
		context["all_ids"][participant_id] = true
	if typeof(value["initial_audiences"]) != TYPE_DICTIONARY:
		_add_error(errors, "root.participants.initial_audiences", "expected_dictionary")
	else:
		var audience_ids: Array = value["initial_audiences"].keys()
		audience_ids.sort()
		for audience_id in audience_ids:
			_validate_business_id(audience_id, "root.participants.initial_audiences", errors)
			var members := _validate_id_array(
				value["initial_audiences"][audience_id],
				"root.participants.initial_audiences.%s" % audience_id,
				errors,
				false,
			)
			for member_id in members:
				if not context["all_ids"].has(member_id):
					_add_error(
						errors,
						"root.participants.initial_audiences.%s" % audience_id,
						"unknown_participant_%s" % member_id,
					)
			context["audiences"][audience_id] = members
	if value["player_role"] not in Contract.PLAYER_ROLES:
		_add_error(errors, "root.participants.player_role", "unknown_value")
	return context


static func _validate_orchestration(value, errors: Array[String]) -> void:
	if not _validate_dictionary(value, Contract.ORCHESTRATION_FIELDS, "root.orchestration", errors):
		return
	var a6 = value["a6_entry"]
	if _validate_dictionary(a6, Contract.A6_ENTRY_FIELDS, "root.orchestration.a6_entry", errors):
		_validate_business_id(a6["scene_definition_id"], "root.orchestration.a6_entry.scene_definition_id", errors)
		_validate_business_id(a6["variant_id"], "root.orchestration.a6_entry.variant_id", errors)
		if typeof(a6["definition"]) != TYPE_DICTIONARY:
			_add_error(errors, "root.orchestration.a6_entry.definition", "expected_dictionary")
		else:
			if a6["definition"].get("scene_id") != a6["scene_definition_id"]:
				_add_error(errors, "root.orchestration.a6_entry.definition.scene_id", "identity_mismatch")
			_validate_a6_definition(
				a6["definition"], "root.orchestration.a6_entry.definition", errors
			)
	var a8 = value["a8_window"]
	if _validate_dictionary(a8, Contract.A8_WINDOW_FIELDS, "root.orchestration.a8_window", errors):
		_validate_business_id(a8["window_id"], "root.orchestration.a8_window.window_id", errors)
		if a8["conflict_policy"] not in Contract.CONFLICT_POLICIES:
			_add_error(errors, "root.orchestration.a8_window.conflict_policy", "unknown_value")
	var a9 = value["a9_slot"]
	if _validate_dictionary(a9, Contract.A9_SLOT_FIELDS, "root.orchestration.a9_slot", errors):
		_validate_business_id(a9["slot_role"], "root.orchestration.a9_slot.slot_role", errors)
		_validate_positive_integer(a9["duration_minutes"], "root.orchestration.a9_slot.duration_minutes", errors)
		_validate_non_negative_integer(a9["relative_order"], "root.orchestration.a9_slot.relative_order", errors)
		_validate_nullable_identifier(a9["not_before_anchor"], "root.orchestration.a9_slot.not_before_anchor", errors)
		_validate_nullable_identifier(a9["not_after_anchor"], "root.orchestration.a9_slot.not_after_anchor", errors)


static func _validate_temporal_projection(value, orchestration, errors: Array[String]) -> void:
	if not _validate_dictionary(
		value, Contract.TEMPORAL_PROJECTION_FIELDS, "root.temporal_projection", errors
	):
		return
	_validate_business_id(value["anchor_id"], "root.temporal_projection.anchor_id", errors)
	if not _is_integer_value(value["offset_minutes"]):
		_add_error(errors, "root.temporal_projection.offset_minutes", "expected_integer")
	_validate_non_negative_integer(value["relative_order"], "root.temporal_projection.relative_order", errors)
	_validate_delay(value["delay"], "root.temporal_projection.delay", errors)
	if not _validate_dictionary(
		value["resolved_window"],
		Contract.RESOLVED_WINDOW_FIELDS,
		"root.temporal_projection.resolved_window",
		errors,
	):
		return
	var opens_at = value["resolved_window"]["opens_at"]
	var closes_at = value["resolved_window"]["closes_at"]
	if not _normalized_moment_valid(opens_at):
		_add_error(errors, "root.temporal_projection.resolved_window.opens_at", "invalid_normalized_moment")
	if not _normalized_moment_valid(closes_at):
		_add_error(errors, "root.temporal_projection.resolved_window.closes_at", "invalid_normalized_moment")
	if (
		typeof(opens_at) == TYPE_STRING
		and typeof(closes_at) == TYPE_STRING
		and _normalized_moment_valid(opens_at)
		and _normalized_moment_valid(closes_at)
		and (opens_at >= closes_at or not _same_offset(opens_at, closes_at))
	):
		_add_error(errors, "root.temporal_projection.resolved_window", "incoherent_window")
	if typeof(orchestration) == TYPE_DICTIONARY:
		var a6_entry = orchestration.get("a6_entry", {})
		var definition = a6_entry.get("definition", {}) if typeof(a6_entry) == TYPE_DICTIONARY else {}
		var temporal = definition.get("contrat_temporel", {}) if typeof(definition) == TYPE_DICTIONARY else {}
		if typeof(temporal) == TYPE_DICTIONARY and typeof(opens_at) == TYPE_STRING and typeof(closes_at) == TYPE_STRING:
			if (
				opens_at.length() >= 16
				and closes_at.length() >= 16
				and (
					opens_at.substr(0, 10) != temporal.get("date_debut")
					or opens_at.substr(11, 5) != temporal.get("heure_ouverture")
					or closes_at.substr(0, 10) != temporal.get("date_fin")
					or closes_at.substr(11, 5) != temporal.get("heure_fermeture")
				)
			):
				_add_error(errors, "root.temporal_projection.resolved_window", "a3_transport_mismatch")


static func _validate_delay(value, path: String, errors: Array[String]) -> void:
	if not _validate_dictionary(value, Contract.DELAY_FIELDS, path, errors):
		return
	if value["mode"] not in Contract.DELAY_MODES:
		_add_error(errors, path + ".mode", "unknown_value")
		return
	match value["mode"]:
		"NONE":
			if value["value"] != null:
				_add_error(errors, path + ".value", "expected_null_for_none")
		"DIEGETIC_MINUTES":
			_validate_non_negative_integer(value["value"], path + ".value", errors)
		"AFTER_EVENT":
			_validate_business_id(value["value"], path + ".value", errors)


static func _validate_beats(value, participant_context: Dictionary, errors: Array[String]) -> Dictionary:
	var context := {
		"beats": {},
		"choices": {},
		"checkpoints": {},
		"media_references": {},
		"withdrawal_choice_ids": [],
		"return_resolution_ids": [],
	}
	if typeof(value) != TYPE_ARRAY or value.is_empty():
		_add_error(errors, "root.beats", "expected_non_empty_array")
		return context
	for index in value.size():
		var path := "root.beats[%d]" % index
		var beat = value[index]
		if not _validate_dictionary(beat, Contract.BEAT_FIELDS, path, errors):
			continue
		_validate_business_id(beat["beat_id"], path + ".beat_id", errors)
		if typeof(beat["beat_id"]) == TYPE_STRING:
			if context["beats"].has(beat["beat_id"]):
				_add_error(errors, path + ".beat_id", "duplicate")
			else:
				context["beats"][beat["beat_id"]] = beat
		if beat["type"] not in Contract.BEAT_TYPES:
			_add_error(errors, path + ".type", "unknown_beat_type")
		_validate_participant_subset(beat["participant_ids"], participant_context, path, errors)
		_validate_local_conditions(beat["local_conditions"], path, errors)
		if beat["projection_target"] not in Contract.PROJECTION_TARGETS:
			_add_error(errors, path + ".projection_target", "unknown_value")
		_validate_checkpoint_declaration(beat["checkpoint_before"], path + ".checkpoint_before", context, errors)
		_validate_checkpoint_declaration(beat["checkpoint_after"], path + ".checkpoint_after", context, errors)
		_validate_next(beat["next"], beat.get("type"), path + ".next", errors)
		_validate_beat_content(beat, path, participant_context, context, errors)
	return context


static func _validate_participant_subset(value, participant_context: Dictionary, path: String, errors: Array[String]) -> void:
	var ids := _validate_id_array(value, path + ".participant_ids", errors, false)
	for participant_id in ids:
		if not participant_context["all_ids"].has(participant_id):
			_add_error(errors, path + ".participant_ids", "unknown_participant_%s" % participant_id)


static func _validate_local_conditions(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, path + ".local_conditions", "expected_array")
		return
	var signatures := {}
	for index in value.size():
		var condition_path := path + ".local_conditions[%d]" % index
		var condition = value[index]
		if not _validate_dictionary(condition, Contract.LOCAL_CONDITION_FIELDS, condition_path, errors):
			continue
		if condition["kind"] not in Contract.LOCAL_CONDITION_KINDS:
			_add_error(errors, condition_path + ".kind", "unknown_value")
		_validate_business_id(condition["ref_id"], condition_path + ".ref_id", errors)
		if typeof(condition["expected"]) != TYPE_BOOL:
			_add_error(errors, condition_path + ".expected", "expected_boolean")
		var signature := "%s:%s:%s" % [condition["kind"], condition["ref_id"], condition["expected"]]
		if signatures.has(signature):
			_add_error(errors, condition_path, "duplicate")
		signatures[signature] = true


static func _validate_checkpoint_declaration(value, path: String, context: Dictionary, errors: Array[String]) -> void:
	if value == null:
		return
	_validate_business_id(value, path, errors)
	if typeof(value) != TYPE_STRING:
		return
	if context["checkpoints"].has(value):
		_add_error(errors, path, "duplicate_checkpoint_%s" % value)
	else:
		context["checkpoints"][value] = path


static func _validate_next(value, beat_type, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, path, "expected_dictionary")
		return
	var mode = value.get("mode")
	if mode not in Contract.NEXT_MODES:
		_add_error(errors, path + ".mode", "unknown_value")
		return
	match mode:
		"DIRECT":
			_validate_exact_fields(value, Contract.NEXT_DIRECT_FIELDS, path, errors)
			if value.has("beat_id"):
				_validate_business_id(value["beat_id"], path + ".beat_id", errors)
		"BRANCH":
			_validate_exact_fields(value, Contract.NEXT_BRANCH_FIELDS, path, errors)
			if beat_type != "CHOICE":
				_add_error(errors, path, "branch_requires_choice_beat")
			if value.has("branches"):
				if typeof(value["branches"]) != TYPE_DICTIONARY or value["branches"].is_empty():
					_add_error(errors, path + ".branches", "expected_non_empty_dictionary")
				else:
					var branch_ids: Array = value["branches"].keys()
					branch_ids.sort()
					for choice_id in branch_ids:
						_validate_business_id(choice_id, path + ".branches", errors)
						_validate_business_id(value["branches"][choice_id], path + ".branches.%s" % choice_id, errors)
		"TERMINAL":
			_validate_exact_fields(value, Contract.NEXT_TERMINAL_FIELDS, path, errors)
			if value.get("beat_id") != null:
				_add_error(errors, path + ".beat_id", "expected_null")
	if beat_type == "CHOICE" and mode != "BRANCH":
		_add_error(errors, path, "choice_requires_branch")
	if beat_type == "RETURN" and mode != "TERMINAL":
		_add_error(errors, path, "return_requires_terminal")


static func _validate_beat_content(
	beat: Dictionary,
	path: String,
	participant_context: Dictionary,
	context: Dictionary,
	errors: Array[String]
) -> void:
	var content = beat["content"]
	match beat["type"]:
		"MESSAGE":
			_validate_message_content(content, path, participant_context, errors)
		"CHOICE":
			_validate_choice_content(content, beat, path, context, errors)
		"TRANSITION":
			_validate_transition_content(content, path, errors)
		"PHYSICAL_BEAT":
			_validate_physical_content(content, path, context, errors)
		"MEDIA_REVEAL":
			_validate_media_reveal_content(content, path, context, errors)
		"AFTERCARE":
			_validate_aftercare_content(content, path, errors)
		"RETURN":
			_validate_return_content(content, path, context, errors)
		_:
			if typeof(content) != TYPE_DICTIONARY:
				_add_error(errors, path + ".content", "expected_dictionary")


static func _validate_message_content(value, path: String, participant_context: Dictionary, errors: Array[String]) -> void:
	path += ".content"
	if not _validate_dictionary(value, Contract.MESSAGE_CONTENT_FIELDS, path, errors):
		return
	_validate_business_id(value["thread_id"], path + ".thread_id", errors)
	if typeof(value["messages"]) != TYPE_ARRAY or value["messages"].is_empty():
		_add_error(errors, path + ".messages", "expected_non_empty_array")
		return
	var message_ids := {}
	var orders := {}
	for index in value["messages"].size():
		var message_path := path + ".messages[%d]" % index
		var message = value["messages"][index]
		if not _validate_dictionary(message, Contract.MESSAGE_FIELDS, message_path, errors):
			continue
		_validate_business_id(message["message_id"], message_path + ".message_id", errors)
		_validate_business_id(message["author_id"], message_path + ".author_id", errors)
		if typeof(message["author_id"]) == TYPE_STRING and not participant_context["all_ids"].has(message["author_id"]):
			_add_error(errors, message_path + ".author_id", "unknown_participant")
		_validate_non_empty_string(message["text"], message_path + ".text", errors)
		if not _normalized_moment_valid(message["diegetic_at"]):
			_add_error(errors, message_path + ".diegetic_at", "invalid_normalized_moment")
		_validate_non_negative_integer(message["relative_order"], message_path + ".relative_order", errors)
		if message_ids.has(message["message_id"]):
			_add_error(errors, message_path + ".message_id", "duplicate")
		message_ids[message["message_id"]] = true
		if orders.has(message["relative_order"]):
			_add_error(errors, message_path + ".relative_order", "duplicate")
		orders[message["relative_order"]] = true


static func _validate_choice_content(
	value,
	beat: Dictionary,
	path: String,
	context: Dictionary,
	errors: Array[String]
) -> void:
	path += ".content"
	if not _validate_dictionary(value, Contract.CHOICE_CONTENT_FIELDS, path, errors):
		return
	_validate_business_id(value["thread_id"], path + ".thread_id", errors)
	if typeof(value["choices"]) != TYPE_ARRAY or value["choices"].is_empty() or value["choices"].size() > 4:
		_add_error(errors, path + ".choices", "expected_one_to_four_choices")
		return
	var local_choices := {}
	for index in value["choices"].size():
		var choice_path := path + ".choices[%d]" % index
		var choice = value["choices"][index]
		if not _validate_dictionary(choice, Contract.CHOICE_FIELDS, choice_path, errors):
			continue
		_validate_business_id(choice["choice_id"], choice_path + ".choice_id", errors)
		_validate_non_empty_string(choice["text"], choice_path + ".text", errors)
		_validate_business_id(choice["resolution_id"], choice_path + ".resolution_id", errors)
		_validate_business_id(choice["next_beat_id"], choice_path + ".next_beat_id", errors)
		if local_choices.has(choice["choice_id"]):
			_add_error(errors, choice_path + ".choice_id", "duplicate")
		local_choices[choice["choice_id"]] = true
		if context["choices"].has(choice["choice_id"]):
			_add_error(errors, choice_path + ".choice_id", "duplicate_global")
		else:
			context["choices"][choice["choice_id"]] = {
				"choice": choice,
				"beat_id": beat["beat_id"],
				"checkpoint_after": beat["checkpoint_after"],
			}


static func _validate_transition_content(value, path: String, errors: Array[String]) -> void:
	path += ".content"
	if not _validate_dictionary(value, Contract.TRANSITION_CONTENT_FIELDS, path, errors):
		return
	_validate_business_id(value["transition_id"], path + ".transition_id", errors)
	if value["mode"] not in Contract.TRANSITION_MODES:
		_add_error(errors, path + ".mode", "unknown_value")
	_validate_business_id(value["from_anchor"], path + ".from_anchor", errors)
	_validate_business_id(value["to_anchor"], path + ".to_anchor", errors)
	_validate_non_empty_string(value["continuation_label"], path + ".continuation_label", errors)


static func _validate_physical_content(value, path: String, context: Dictionary, errors: Array[String]) -> void:
	path += ".content"
	if not _validate_dictionary(value, Contract.PHYSICAL_BEAT_CONTENT_FIELDS, path, errors):
		return
	_validate_business_id(value["physical_beat_id"], path + ".physical_beat_id", errors)
	_validate_non_empty_string(value["content_ref"], path + ".content_ref", errors)
	var withdrawal_ids := _validate_id_array(
		value["withdrawal_choice_ids"], path + ".withdrawal_choice_ids", errors, true
	)
	context["withdrawal_choice_ids"].append_array(withdrawal_ids)


static func _validate_media_reveal_content(value, path: String, context: Dictionary, errors: Array[String]) -> void:
	path += ".content"
	if not _validate_dictionary(value, Contract.MEDIA_REVEAL_CONTENT_FIELDS, path, errors):
		return
	_validate_media_id(value["media_id"], path + ".media_id", errors)
	if typeof(value["reveal_context"]) != TYPE_DICTIONARY or not value["reveal_context"].is_empty():
		_add_error(errors, path + ".reveal_context", "expected_empty_dictionary_in_v1")
	if typeof(value["requires_ack"]) != TYPE_BOOL:
		_add_error(errors, path + ".requires_ack", "expected_boolean")
	if typeof(value["media_id"]) == TYPE_STRING:
		context["media_references"][value["media_id"]] = true


static func _validate_aftercare_content(value, path: String, errors: Array[String]) -> void:
	path += ".content"
	if not _validate_dictionary(value, Contract.AFTERCARE_CONTENT_FIELDS, path, errors):
		return
	_validate_business_id(value["aftercare_id"], path + ".aftercare_id", errors)
	_validate_non_empty_string(value["content_ref"], path + ".content_ref", errors)
	_validate_business_id(value["obligation_id"], path + ".obligation_id", errors)


static func _validate_return_content(value, path: String, context: Dictionary, errors: Array[String]) -> void:
	path += ".content"
	if not _validate_dictionary(value, Contract.RETURN_CONTENT_FIELDS, path, errors):
		return
	_validate_business_id(value["return_id"], path + ".return_id", errors)
	_validate_non_empty_string(value["content_ref"], path + ".content_ref", errors)
	_validate_delay(value["delay"], path + ".delay", errors)
	var resolution_ids := _validate_id_array(
		value["eligible_resolution_ids"], path + ".eligible_resolution_ids", errors, true
	)
	context["return_resolution_ids"].append_array(resolution_ids)


static func _validate_resolutions(value, errors: Array[String]) -> Dictionary:
	var context := {"resolutions": {}, "media_effect_references": {}}
	if typeof(value) != TYPE_DICTIONARY or value.is_empty():
		_add_error(errors, "root.resolutions", "expected_non_empty_dictionary")
		return context
	var resolution_ids: Array = value.keys()
	resolution_ids.sort()
	for resolution_id in resolution_ids:
		var path := "root.resolutions.%s" % resolution_id
		_validate_business_id(resolution_id, "root.resolutions", errors)
		var resolution = value[resolution_id]
		if not _validate_dictionary(resolution, Contract.RESOLUTION_FIELDS, path, errors):
			continue
		if resolution["resolution_id"] != resolution_id:
			_add_error(errors, path + ".resolution_id", "identity_mismatch")
		_validate_business_id(resolution["choice_id"], path + ".choice_id", errors)
		_validate_business_id(resolution["a10_choice_id"], path + ".a10_choice_id", errors)
		_validate_nullable_identifier(
			resolution["a10_resolution_id"], path + ".a10_resolution_id", errors
		)
		_validate_business_id(resolution["terminal_checkpoint_id"], path + ".terminal_checkpoint_id", errors)
		_validate_event_refs(resolution["event_refs"], path, errors)
		_validate_id_array(resolution["fact_ids"], path + ".fact_ids", errors, false)
		_validate_id_array(resolution["knowledge_ids"], path + ".knowledge_ids", errors, false)
		_validate_id_array(resolution["trace_ids"], path + ".trace_ids", errors, false)
		_validate_effects(resolution["promise_effects"], Contract.PROMISE_EFFECT_FIELDS, Contract.PROMISE_EFFECTS, "promise_id", path + ".promise_effects", errors)
		_validate_effects(resolution["obligation_effects"], Contract.OBLIGATION_EFFECT_FIELDS, Contract.OBLIGATION_EFFECTS, "obligation_id", path + ".obligation_effects", errors)
		_validate_id_array(resolution["consequence_ids"], path + ".consequence_ids", errors, false)
		_validate_media_effects(resolution["media_effects"], path + ".media_effects", context, errors)
		if resolution["convergence"] not in Contract.CONVERGENCES:
			_add_error(errors, path + ".convergence", "unknown_value")
		_validate_nullable_identifier(resolution["next_beat_id"], path + ".next_beat_id", errors)
		context["resolutions"][resolution_id] = resolution
	return context


static func _validate_event_refs(value, path: String, errors: Array[String]) -> void:
	path += ".event_refs"
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, path, "expected_array")
		return
	var event_keys := {}
	for index in value.size():
		var item_path := path + "[%d]" % index
		var item = value[index]
		if not _validate_dictionary(item, Contract.EVENT_REF_FIELDS, item_path, errors):
			continue
		for field in Contract.EVENT_REF_FIELDS:
			_validate_business_id(item[field], item_path + "." + field, errors)
		if event_keys.has(item["event_key"]):
			_add_error(errors, item_path + ".event_key", "duplicate")
		event_keys[item["event_key"]] = true


static func _validate_effects(
	value,
	fields: Array,
	allowed_effects: Array,
	id_field: String,
	path: String,
	errors: Array[String]
) -> void:
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, path, "expected_array")
		return
	var ids := {}
	for index in value.size():
		var item_path := path + "[%d]" % index
		var item = value[index]
		if not _validate_dictionary(item, fields, item_path, errors):
			continue
		_validate_business_id(item[id_field], item_path + "." + id_field, errors)
		if item["effect"] not in allowed_effects:
			_add_error(errors, item_path + ".effect", "unknown_value")
		if ids.has(item[id_field]):
			_add_error(errors, item_path + "." + id_field, "duplicate")
		ids[item[id_field]] = true


static func _validate_media_effects(value, path: String, context: Dictionary, errors: Array[String]) -> void:
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, path, "expected_array")
		return
	var ids := {}
	for index in value.size():
		var item_path := path + "[%d]" % index
		var item = value[index]
		if not _validate_dictionary(item, Contract.MEDIA_EFFECT_FIELDS, item_path, errors):
			continue
		_validate_media_id(item["media_id"], item_path + ".media_id", errors)
		if item["effect"] not in Contract.MEDIA_EFFECTS:
			_add_error(errors, item_path + ".effect", "unknown_value")
		if ids.has(item["media_id"]):
			_add_error(errors, item_path + ".media_id", "duplicate")
		ids[item["media_id"]] = true
		context["media_effect_references"][item["media_id"]] = true


static func _validate_media(value, participant_context: Dictionary, errors: Array[String]) -> Dictionary:
	var context := {"media": {}}
	if typeof(value) != TYPE_DICTIONARY or value.is_empty():
		_add_error(errors, "root.media", "expected_non_empty_dictionary")
		return context
	var media_ids: Array = value.keys()
	media_ids.sort()
	for media_id in media_ids:
		var path := "root.media.%s" % media_id
		_validate_media_id(media_id, "root.media", errors)
		var media = value[media_id]
		if not _validate_dictionary(media, Contract.MEDIA_FIELDS, path, errors):
			continue
		if media["media_id"] != media_id:
			_add_error(errors, path + ".media_id", "identity_mismatch")
		if media["visual_level"] not in Contract.VISUAL_LEVELS:
			_add_error(errors, path + ".visual_level", "unknown_value")
		if media["analytic_level"] != null and media["analytic_level"] not in Contract.ANALYTIC_LEVELS:
			_add_error(errors, path + ".analytic_level", "unknown_value")
		if media["production_status"] not in Contract.PRODUCTION_STATUSES:
			_add_error(errors, path + ".production_status", "unknown_value")
		if media["diegesis"] not in Contract.DIEGESIS_VALUES:
			_add_error(errors, path + ".diegesis", "unknown_value")
		var audience_ids := _validate_id_array(media["audience_ids"], path + ".audience_ids", errors, true)
		for audience_id in audience_ids:
			if not participant_context["audiences"].has(audience_id):
				_add_error(errors, path + ".audience_ids", "unknown_audience_%s" % audience_id)
			elif media["diegesis"] == "NON_DIEGETIC" and not participant_context["audiences"][audience_id].is_empty():
				_add_error(errors, path + ".audience_ids", "non_diegetic_fictional_audience_%s" % audience_id)
		if media["gallery_policy"] not in Contract.GALLERY_POLICIES:
			_add_error(errors, path + ".gallery_policy", "unknown_value")
		_validate_nullable_media_id(media["parent_media_id"], path + ".parent_media_id", errors)
		if media["thumbnail_policy"] not in Contract.THUMBNAIL_POLICIES:
			_add_error(errors, path + ".thumbnail_policy", "unknown_value")
		_validate_nullable_media_id(media["thumbnail_media_id"], path + ".thumbnail_media_id", errors)
		if media["thumbnail_policy"] == "REUSE_MEDIA" and media["thumbnail_media_id"] == null:
			_add_error(errors, path + ".thumbnail_media_id", "required_for_reuse_media")
		if media["thumbnail_policy"] != "REUSE_MEDIA" and media["thumbnail_media_id"] != null:
			_add_error(errors, path + ".thumbnail_media_id", "must_be_null_unless_reuse_media")
		if media["removal_policy"] not in Contract.REMOVAL_POLICIES:
			_add_error(errors, path + ".removal_policy", "unknown_value")
		if media["production_status"] == "DERIVED_OR_REUSED_NOT_SEPARATELY_PRODUCED" and media["parent_media_id"] != null:
			_add_error(errors, path + ".parent_media_id", "derived_parent_cannot_be_child")
		context["media"][media_id] = media
	return context


static func _validate_references(
	sequence: Dictionary,
	graph_context: Dictionary,
	resolution_context: Dictionary,
	media_context: Dictionary,
	errors: Array[String]
) -> void:
	var beats: Dictionary = graph_context["beats"]
	var choices: Dictionary = graph_context["choices"]
	var checkpoints: Dictionary = graph_context["checkpoints"]
	var resolutions: Dictionary = resolution_context["resolutions"]
	var media: Dictionary = media_context["media"]
	if not beats.has(sequence["entry_beat_id"]):
		_add_error(errors, "root.entry_beat_id", "unknown_beat")

	var beat_ids: Array = beats.keys()
	beat_ids.sort()
	for beat_id in beat_ids:
		var beat: Dictionary = beats[beat_id]
		var path := "root.beats.%s" % beat_id
		_validate_next_references(beat, beats, choices, path, errors)
		_validate_local_condition_references(beat, choices, checkpoints, resolutions, path, errors)
		var content = beat.get("content")
		if typeof(content) != TYPE_DICTIONARY:
			continue
		match beat["type"]:
			"CHOICE":
				if typeof(content.get("choices")) != TYPE_ARRAY:
					continue
				for choice in content["choices"]:
					if typeof(choice) != TYPE_DICTIONARY:
						continue
					if choice["resolution_id"] != null and not resolutions.has(choice["resolution_id"]):
						_add_error(errors, path + ".content.choices", "unknown_resolution_%s" % choice["resolution_id"])
					if choice["next_beat_id"] != null and not beats.has(choice["next_beat_id"]):
						_add_error(errors, path + ".content.choices", "unknown_next_beat_%s" % choice["next_beat_id"])
			"MEDIA_REVEAL":
				if not content.has("media_id"):
					continue
				var media_id = content["media_id"]
				if not media.has(media_id):
					_add_error(errors, path + ".content.media_id", "unknown_media")
				elif media[media_id]["production_status"] == "DERIVED_OR_REUSED_NOT_SEPARATELY_PRODUCED":
					_add_error(errors, path + ".content.media_id", "derived_parent_cannot_be_revealed")
			"PHYSICAL_BEAT":
				if typeof(content.get("withdrawal_choice_ids")) != TYPE_ARRAY:
					continue
				for choice_id in content["withdrawal_choice_ids"]:
					if not choices.has(choice_id):
						_add_error(errors, path + ".content.withdrawal_choice_ids", "unknown_choice_%s" % choice_id)
			"RETURN":
				if typeof(content.get("eligible_resolution_ids")) != TYPE_ARRAY:
					continue
				for resolution_id in content["eligible_resolution_ids"]:
					if not resolutions.has(resolution_id):
						_add_error(errors, path + ".content.eligible_resolution_ids", "unknown_resolution_%s" % resolution_id)

	_validate_choice_resolution_reciprocity(beats, choices, resolutions, errors)

	var a10_choice_resolution_ids := {}
	var a10_resolution_ids := {}
	var a10_resolutions := {}
	var orchestration = sequence.get("orchestration")
	var a6_entry = orchestration.get("a6_entry", {}) if typeof(orchestration) == TYPE_DICTIONARY else {}
	var definition = a6_entry.get("definition", {}) if typeof(a6_entry) == TYPE_DICTIONARY else {}
	if typeof(definition) == TYPE_DICTIONARY and typeof(definition.get("resolutions")) == TYPE_DICTIONARY:
		for a10_resolution_id in definition["resolutions"]:
			a10_resolution_ids[a10_resolution_id] = true
			a10_resolutions[a10_resolution_id] = definition["resolutions"][a10_resolution_id]
	if typeof(definition) == TYPE_DICTIONARY and typeof(definition.get("choix", [])) == TYPE_ARRAY:
		for option in definition.get("choix", []):
			if typeof(option) == TYPE_DICTIONARY:
				var choice_resolution_ids := {}
				if typeof(option.get("resolution_ids")) == TYPE_ARRAY:
					for a10_resolution_id in option["resolution_ids"]:
						choice_resolution_ids[a10_resolution_id] = true
				a10_choice_resolution_ids[option.get("choix_id")] = choice_resolution_ids
	var claimed_a10_resolutions := {}
	var resolution_ids: Array = resolutions.keys()
	resolution_ids.sort()
	for resolution_id in resolution_ids:
		var resolution: Dictionary = resolutions[resolution_id]
		var path := "root.resolutions.%s" % resolution_id
		if not choices.has(resolution["choice_id"]):
			_add_error(errors, path + ".choice_id", "unknown_choice")
		elif choices[resolution["choice_id"]]["checkpoint_after"] != resolution["terminal_checkpoint_id"]:
			_add_error(errors, path + ".terminal_checkpoint_id", "choice_checkpoint_mismatch")
		var a10_choice_id = resolution["a10_choice_id"]
		var a10_resolution_id = resolution["a10_resolution_id"]
		if not a10_choice_resolution_ids.has(a10_choice_id):
			_add_error(errors, path + ".a10_choice_id", "unknown_a6_choice")
		if a10_resolution_id == null:
			if _has_authored_durable_effects(resolution):
				_add_error(
					errors,
					path + ".a10_resolution_id",
					"durable_effect_requires_a10_resolution",
				)
		elif typeof(a10_resolution_id) == TYPE_STRING:
			if not a10_resolution_ids.has(a10_resolution_id):
				_add_error(errors, path + ".a10_resolution_id", "unknown_a6_resolution")
			elif (
				a10_choice_resolution_ids.has(a10_choice_id)
				and not a10_choice_resolution_ids[a10_choice_id].has(a10_resolution_id)
			):
				_add_error(errors, path + ".a10_resolution_id", "a10_resolution_choice_mismatch")
			if claimed_a10_resolutions.has(a10_resolution_id):
				_add_error(errors, path + ".a10_resolution_id", "a10_resolution_reused")
			else:
				claimed_a10_resolutions[a10_resolution_id] = resolution_id
			if a10_resolutions.has(a10_resolution_id) and typeof(a10_resolutions[a10_resolution_id]) == TYPE_DICTIONARY:
				_validate_a6_manifest_binding(
					a10_resolutions[a10_resolution_id], sequence, resolution, resolution_id, path, errors
				)
		if not checkpoints.has(resolution["terminal_checkpoint_id"]):
			_add_error(errors, path + ".terminal_checkpoint_id", "unknown_checkpoint")
		if resolution["next_beat_id"] != null and not beats.has(resolution["next_beat_id"]):
			_add_error(errors, path + ".next_beat_id", "unknown_beat")
		if typeof(resolution["media_effects"]) != TYPE_ARRAY:
			continue
		for effect in resolution["media_effects"]:
			if typeof(effect) == TYPE_DICTIONARY and not media.has(effect.get("media_id")):
				_add_error(errors, path + ".media_effects", "unknown_media_%s" % effect.get("media_id"))

	var media_ids: Array = media.keys()
	media_ids.sort()
	for media_id in media_ids:
		var item: Dictionary = media[media_id]
		var path := "root.media.%s" % media_id
		if item["parent_media_id"] != null and not media.has(item["parent_media_id"]):
			_add_error(errors, path + ".parent_media_id", "unknown_media")
		if item["thumbnail_media_id"] != null and not media.has(item["thumbnail_media_id"]):
			_add_error(errors, path + ".thumbnail_media_id", "unknown_media")


static func _has_authored_durable_effects(resolution: Dictionary) -> bool:
	for field in AUTHORED_DURABLE_EFFECT_FIELDS:
		var effects = resolution.get(field)
		if typeof(effects) == TYPE_ARRAY and not effects.is_empty():
			return true
	return false


static func _validate_choice_resolution_reciprocity(
	beats: Dictionary,
	choices: Dictionary,
	resolutions: Dictionary,
	errors: Array[String]
) -> void:
	var claimed_resolutions := {}
	var choice_ids: Array = choices.keys()
	choice_ids.sort()
	for choice_id in choice_ids:
		var choice_context: Dictionary = choices[choice_id]
		var option: Dictionary = choice_context["choice"]
		var path := "root.beats.%s.content.choices.%s" % [choice_context["beat_id"], choice_id]
		var resolution_id = option.get("resolution_id")
		if not resolutions.has(resolution_id):
			continue
		if claimed_resolutions.has(resolution_id):
			_add_error(errors, path + ".resolution_id", "resolution_reused")
		else:
			claimed_resolutions[resolution_id] = choice_id
		var resolution: Dictionary = resolutions[resolution_id]
		if resolution.get("choice_id") != choice_id:
			_add_error(errors, path + ".resolution_id", "resolution_choice_mismatch")
		if resolution.get("next_beat_id") != option.get("next_beat_id"):
			_add_error(errors, path + ".next_beat_id", "resolution_target_mismatch")

	var return_claims := {}
	var beat_ids: Array = beats.keys()
	beat_ids.sort()
	for beat_id in beat_ids:
		var beat: Dictionary = beats[beat_id]
		if beat.get("type") != "RETURN" or typeof(beat.get("content")) != TYPE_DICTIONARY:
			continue
		var declared = beat["content"].get("eligible_resolution_ids")
		if typeof(declared) != TYPE_ARRAY:
			continue
		for resolution_id in declared:
			var path := "root.beats.%s.content.eligible_resolution_ids" % beat_id
			if not resolutions.has(resolution_id):
				continue
			if return_claims.has(resolution_id):
				_add_error(errors, path, "resolution_declared_by_multiple_returns_%s" % resolution_id)
			else:
				return_claims[resolution_id] = beat_id
			if resolutions[resolution_id].get("next_beat_id") != beat_id:
				_add_error(errors, path, "foreign_resolution_%s" % resolution_id)

	var resolution_ids: Array = resolutions.keys()
	resolution_ids.sort()
	for resolution_id in resolution_ids:
		var resolution: Dictionary = resolutions[resolution_id]
		var path := "root.resolutions.%s" % resolution_id
		if not claimed_resolutions.has(resolution_id):
			_add_error(errors, path, "orphan_resolution")
		var target_id = resolution.get("next_beat_id")
		if not beats.has(target_id):
			continue
		if beats[target_id].get("type") == "RETURN":
			if not return_claims.has(resolution_id):
				_add_error(errors, path + ".next_beat_id", "return_missing_reciprocal_resolution")
			elif return_claims[resolution_id] != target_id:
				_add_error(errors, path + ".next_beat_id", "return_resolution_mismatch")
		elif return_claims.has(resolution_id):
			_add_error(errors, path + ".next_beat_id", "non_return_resolution_declared_by_return")


static func _validate_next_references(
	beat: Dictionary,
	beats: Dictionary,
	choices: Dictionary,
	path: String,
	errors: Array[String]
) -> void:
	var next = beat.get("next")
	if typeof(next) != TYPE_DICTIONARY:
		return
	match next.get("mode"):
		"DIRECT":
			if not beats.has(next.get("beat_id")):
				_add_error(errors, path + ".next.beat_id", "unknown_beat")
		"BRANCH":
			var content_choices := {}
			if beat["type"] == "CHOICE" and typeof(beat["content"]) == TYPE_DICTIONARY:
				for choice in beat["content"].get("choices", []):
					if typeof(choice) == TYPE_DICTIONARY:
						content_choices[choice.get("choice_id")] = choice.get("next_beat_id")
			if typeof(next.get("branches")) == TYPE_DICTIONARY:
				var branch_ids: Array = next["branches"].keys()
				branch_ids.sort()
				for choice_id in branch_ids:
					var target = next["branches"][choice_id]
					if not choices.has(choice_id) or not content_choices.has(choice_id):
						_add_error(errors, path + ".next.branches", "unknown_choice_%s" % choice_id)
					if not beats.has(target):
						_add_error(errors, path + ".next.branches.%s" % choice_id, "unknown_beat")
					if content_choices.get(choice_id) != target:
						_add_error(errors, path + ".next.branches.%s" % choice_id, "choice_target_mismatch")
				if branch_ids.size() != content_choices.size():
					_add_error(errors, path + ".next.branches", "choice_set_mismatch")


static func _validate_local_condition_references(
	beat: Dictionary,
	choices: Dictionary,
	checkpoints: Dictionary,
	resolutions: Dictionary,
	path: String,
	errors: Array[String]
) -> void:
	if typeof(beat.get("local_conditions")) != TYPE_ARRAY:
		return
	for condition in beat["local_conditions"]:
		if typeof(condition) != TYPE_DICTIONARY:
			continue
		match condition.get("kind"):
			"CHOICE_CONSUMED":
				if not choices.has(condition.get("ref_id")):
					_add_error(errors, path + ".local_conditions", "unknown_choice_%s" % condition.get("ref_id"))
			"CHECKPOINT_REACHED":
				if not checkpoints.has(condition.get("ref_id")):
					_add_error(errors, path + ".local_conditions", "unknown_checkpoint_%s" % condition.get("ref_id"))
			"RESOLUTION_SELECTED":
				if not resolutions.has(condition.get("ref_id")):
					_add_error(errors, path + ".local_conditions", "unknown_resolution_%s" % condition.get("ref_id"))


static func _validate_graph(entry_beat_id, context: Dictionary, errors: Array[String]) -> void:
	var beats: Dictionary = context["beats"]
	if typeof(entry_beat_id) != TYPE_STRING or not beats.has(entry_beat_id):
		return
	var adjacency := {}
	var beat_ids: Array = beats.keys()
	beat_ids.sort()
	for beat_id in beat_ids:
		adjacency[beat_id] = _next_targets(beats[beat_id])
	var visiting := {}
	var visited := {}
	if _visit_cycle(entry_beat_id, adjacency, visiting, visited):
		_add_error(errors, "root.beats", "cycle_detected")
	var reachable := {}
	_collect_reachable(entry_beat_id, adjacency, reachable)
	for beat_id in beat_ids:
		if not reachable.has(beat_id):
			_add_error(errors, "root.beats.%s" % beat_id, "orphan_beat")


static func _next_targets(beat: Dictionary) -> Array:
	var targets: Array = []
	var next = beat.get("next", {})
	if typeof(next) != TYPE_DICTIONARY:
		return targets
	if next.get("mode") == "DIRECT" and typeof(next.get("beat_id")) == TYPE_STRING:
		targets.append(next["beat_id"])
	elif next.get("mode") == "BRANCH" and typeof(next.get("branches")) == TYPE_DICTIONARY:
		for target in next["branches"].values():
			if typeof(target) == TYPE_STRING and target not in targets:
				targets.append(target)
	targets.sort()
	return targets


static func _visit_cycle(node: String, adjacency: Dictionary, visiting: Dictionary, visited: Dictionary) -> bool:
	if visiting.has(node):
		return true
	if visited.has(node):
		return false
	visiting[node] = true
	for target in adjacency.get(node, []):
		if adjacency.has(target) and _visit_cycle(target, adjacency, visiting, visited):
			return true
	visiting.erase(node)
	visited[node] = true
	return false


static func _collect_reachable(node: String, adjacency: Dictionary, reachable: Dictionary) -> void:
	if reachable.has(node):
		return
	reachable[node] = true
	for target in adjacency.get(node, []):
		if adjacency.has(target):
			_collect_reachable(target, adjacency, reachable)


static func _validate_a6_definition(value: Dictionary, path: String, errors: Array[String]) -> void:
	var allowed_fields := A6_DEFINITION_REQUIRED_FIELDS + A6_DEFINITION_OPTIONAL_FIELDS
	_validate_closed_dictionary(value, allowed_fields, A6_DEFINITION_REQUIRED_FIELDS, path, errors)
	if not _has_required_fields(value, A6_DEFINITION_REQUIRED_FIELDS):
		return
	_validate_business_id(value["scene_id"], path + ".scene_id", errors)
	if not _is_semver(value["version_contrat"]):
		_add_error(errors, path + ".version_contrat", "expected_major_minor_patch")
	if value["nature"] not in A6_NATURES:
		_add_error(errors, path + ".nature", "unknown_value")
	if value["fonction_principale"] not in A6_FUNCTIONS:
		_add_error(errors, path + ".fonction_principale", "unknown_value")
	if value["politique_unicite"] not in A6_UNIQUENESS_POLICIES:
		_add_error(errors, path + ".politique_unicite", "unknown_value")
	for field in ["titre_interne", "relation_ou_question_focale", "noyau_stable", "structure_id"]:
		if value.has(field):
			_validate_non_empty_string(value[field], path + "." + field, errors)
	var participant_ids := _validate_a6_participants(value["participants_requis"], path, errors)
	_validate_a6_conditions(value["conditions_dures"], value["exclusions_dures"], path, errors)
	_validate_a6_temporal(value["contrat_temporel"], path + ".contrat_temporel", errors)
	var resolution_signals := _validate_a6_resolutions(
		value["resolutions"], participant_ids, path + ".resolutions", errors
	)
	_validate_a6_choices(value.get("choix", []), resolution_signals, path + ".choix", errors)
	if value.has("politique_non_resolution"):
		_validate_a6_non_resolution(
			value["politique_non_resolution"], participant_ids, path + ".politique_non_resolution", errors
		)


static func _validate_a6_participants(value, path: String, errors: Array[String]) -> Dictionary:
	var participant_ids := {}
	path += ".participants_requis"
	if typeof(value) != TYPE_ARRAY or value.is_empty():
		_add_error(errors, path, "expected_non_empty_array")
		return participant_ids
	for index in value.size():
		var item_path := path + "[%d]" % index
		var participant = value[index]
		if not _validate_dictionary(participant, A6_PARTICIPANT_FIELDS, item_path, errors):
			continue
		_validate_business_id(participant["personnage_id"], item_path + ".personnage_id", errors)
		_validate_non_empty_string(participant["role"], item_path + ".role", errors)
		if participant_ids.has(participant["personnage_id"]):
			_add_error(errors, item_path + ".personnage_id", "duplicate")
		participant_ids[participant["personnage_id"]] = true
	return participant_ids


static func _validate_a6_conditions(conditions, exclusions, path: String, errors: Array[String]) -> void:
	if _validate_dictionary(conditions, A6_CONDITION_FIELDS, path + ".conditions_dures", errors):
		_validate_non_empty_string_array(
			conditions["actes_compatibles"], path + ".conditions_dures.actes_compatibles", errors
		)
		_validate_string_array(
			conditions["evenements_requis"], path + ".conditions_dures.evenements_requis", errors
		)
	if _validate_dictionary(exclusions, A6_EXCLUSION_FIELDS, path + ".exclusions_dures", errors):
		_validate_string_array(
			exclusions["evenements_interdits"], path + ".exclusions_dures.evenements_interdits", errors
		)


static func _validate_a6_temporal(value, path: String, errors: Array[String]) -> void:
	if not _validate_dictionary(value, A6_TEMPORAL_FIELDS, path, errors):
		return
	if not _date_valid(value["date_debut"]):
		_add_error(errors, path + ".date_debut", "invalid_date")
	if not _date_valid(value["date_fin"]):
		_add_error(errors, path + ".date_fin", "invalid_date")
	var opens := _time_in_minutes(value["heure_ouverture"])
	var closes := _time_in_minutes(value["heure_fermeture"])
	if opens < 0:
		_add_error(errors, path + ".heure_ouverture", "invalid_time")
	if closes < 0:
		_add_error(errors, path + ".heure_fermeture", "invalid_time")
	if _date_valid(value["date_debut"]) and _date_valid(value["date_fin"]):
		if value["date_debut"] > value["date_fin"] or opens >= closes:
			_add_error(errors, path, "incoherent_window")
	_validate_positive_integer(value["duree_minutes"], path + ".duree_minutes", errors)
	if value["revalidation"] not in A6_REVALIDATION_POLICIES:
		_add_error(errors, path + ".revalidation", "unknown_value")


static func _validate_a6_resolutions(
	value,
	participant_ids: Dictionary,
	path: String,
	errors: Array[String]
) -> Dictionary:
	var signals := {}
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, path, "expected_dictionary")
		return signals
	var resolution_ids: Array = value.keys()
	resolution_ids.sort()
	for resolution_id in resolution_ids:
		var item_path := path + "." + str(resolution_id)
		_validate_business_id(resolution_id, path, errors)
		var resolution = value[resolution_id]
		if typeof(resolution) != TYPE_DICTIONARY:
			_add_error(errors, item_path, "expected_dictionary")
			continue
		_validate_closed_dictionary(
			resolution, A6_RESOLUTION_FIELDS, A6_RESOLUTION_REQUIRED_FIELDS, item_path, errors
		)
		if not _has_required_fields(resolution, A6_RESOLUTION_REQUIRED_FIELDS):
			continue
		_validate_business_id(resolution["personnage_id"], item_path + ".personnage_id", errors)
		if not participant_ids.has(resolution["personnage_id"]):
			_add_error(errors, item_path + ".personnage_id", "unknown_participant")
		if resolution["portee_micro_signal"] not in A6_SIGNAL_SCOPES:
			_add_error(errors, item_path + ".portee_micro_signal", "unknown_value")
		if resolution["reception"] not in A6_RECEPTIONS:
			_add_error(errors, item_path + ".reception", "unknown_value")
		_validate_non_empty_string(resolution["signal_recu"], item_path + ".signal_recu", errors)
		_validate_non_empty_string(resolution["interpretation"], item_path + ".interpretation", errors)
		if resolution["convergence"] != "RETOUR_NOYAU_COMMUN":
			_add_error(errors, item_path + ".convergence", "unknown_value")
		_validate_a6_relational_facts(resolution["faits_relationnels"], item_path, errors)
		var scope = resolution["portee_micro_signal"]
		var reception = resolution["reception"]
		if scope == "LOCALE" and reception != "NON_PERSISTANTE":
			_add_error(errors, item_path, "local_signal_must_be_non_persistent")
		if scope in ["LOCALE", "TEMPORAIRE"] and typeof(resolution["faits_relationnels"]) == TYPE_ARRAY and not resolution["faits_relationnels"].is_empty():
			_add_error(errors, item_path + ".faits_relationnels", "durable_fact_forbidden")
		var trace_valid := false
		if resolution.has("trace_temporaire"):
			var trace = resolution["trace_temporaire"]
			if typeof(trace) != TYPE_DICTIONARY:
				_add_error(errors, item_path + ".trace_temporaire", "expected_dictionary")
			elif _validate_dictionary(trace, A6_TRACE_FIELDS, item_path + ".trace_temporaire", errors):
				trace_valid = true
				_validate_business_id(trace["trace_id"], item_path + ".trace_temporaire.trace_id", errors)
				_validate_non_empty_string(trace["contenu"], item_path + ".trace_temporaire.contenu", errors)
		if scope == "TEMPORAIRE":
			if not trace_valid:
				_add_error(errors, item_path + ".trace_temporaire", "required_for_temporary_signal")
		if scope == "DURABLE" and (
			reception == "NON_PERSISTANTE"
			or typeof(resolution["faits_relationnels"]) != TYPE_ARRAY
			or resolution["faits_relationnels"].is_empty()
		):
			_add_error(errors, item_path, "durable_signal_requires_fact")
		var durable_manifest = resolution.get("durable_manifest", {})
		_validate_a6_durable_manifest(durable_manifest, item_path + ".durable_manifest", errors)
		if scope != "DURABLE" and typeof(durable_manifest) == TYPE_DICTIONARY and not durable_manifest.is_empty():
			_add_error(errors, item_path + ".durable_manifest", "forbidden_for_local_resolution")
		signals[resolution_id] = resolution["signal_recu"]
	return signals


static func _validate_a6_manifest_binding(
	a6_resolution: Dictionary,
	sequence: Dictionary,
	authored_resolution: Dictionary,
	resolution_id,
	path: String,
	errors: Array[String]
) -> void:
	var manifest = a6_resolution.get("durable_manifest")
	if typeof(manifest) != TYPE_DICTIONARY or manifest.is_empty():
		_add_error(errors, path + ".a10_resolution_id", "non_empty_durable_manifest_required")
		return
	var binding = manifest.get("binding")
	if typeof(binding) != TYPE_DICTIONARY:
		return
	if binding.get("sequence_id") != sequence.get("sequence_id"):
		_add_error(errors, path + ".a10_resolution_id", "durable_manifest_sequence_binding_mismatch")
	if binding.get("authored_version") != sequence.get("authored_version"):
		_add_error(errors, path + ".a10_resolution_id", "durable_manifest_version_binding_mismatch")
	if binding.get("resolution_id") != resolution_id:
		_add_error(errors, path + ".a10_resolution_id", "durable_manifest_resolution_binding_mismatch")
	_validate_a6_manifest_authored_effects(manifest, authored_resolution, path, errors)


static func _validate_a6_manifest_authored_effects(
	manifest: Dictionary,
	resolution: Dictionary,
	path: String,
	errors: Array[String]
) -> void:
	var expected := {
		"event_keys": [],
		"fact_ids": [],
		"knowledge_ids": [],
		"trace_ids": [],
		"promise_effects": [],
		"obligation_effects": [],
		"media_effects": [],
	}
	for category in A6_DURABLE_CATEGORIES:
		var entries = manifest.get(category)
		if typeof(entries) != TYPE_ARRAY:
			continue
		for entry in entries:
			if typeof(entry) != TYPE_DICTIONARY:
				continue
			expected["event_keys"].append(entry.get("event_key"))
			if category == "facts":
				var fact = entry.get("fact")
				expected["fact_ids"].append(
					fact.get("fait_id") if typeof(fact) == TYPE_DICTIONARY else null
				)
			elif category == "knowledge":
				expected["knowledge_ids"].append(entry.get("knowledge_id"))
			elif category == "traces":
				expected["trace_ids"].append(entry.get("trace_id"))
			elif category == "promises":
				expected["promise_effects"].append({
					"promise_id": entry.get("promise_id"), "effect": entry.get("effect"),
				})
			elif category == "obligations":
				expected["obligation_effects"].append({
					"obligation_id": entry.get("obligation_id"), "effect": entry.get("effect"),
				})
			elif category == "media_deliveries":
				expected["media_effects"].append({
					"media_id": entry.get("media_id"), "effect": entry.get("effect"),
				})

	var authored_event_keys: Array = []
	var event_refs = resolution.get("event_refs")
	if typeof(event_refs) == TYPE_ARRAY:
		for event_ref in event_refs:
			if typeof(event_ref) == TYPE_DICTIONARY:
				authored_event_keys.append(event_ref.get("event_key"))
	_validate_a6_authored_projection(
		authored_event_keys, expected["event_keys"], path + ".event_refs", "durable_manifest_event_keys_mismatch", errors
	)
	for field in ["fact_ids", "knowledge_ids", "trace_ids"]:
		_validate_a6_authored_projection(
			resolution.get(field),
			expected[field],
			path + "." + field,
			"durable_manifest_%s_mismatch" % field,
			errors,
		)
	for effect_binding in [
		["promise_effects", "promise_id"],
		["obligation_effects", "obligation_id"],
		["media_effects", "media_id"],
	]:
		var field: String = effect_binding[0]
		_validate_a6_authored_projection(
			_authored_non_none_effects(resolution.get(field), effect_binding[1]),
			expected[field],
			path + "." + field,
			"durable_manifest_%s_mismatch" % field,
			errors,
		)


static func _authored_non_none_effects(value, id_field: String) -> Array:
	var result: Array = []
	if typeof(value) != TYPE_ARRAY:
		return result
	for item in value:
		if typeof(item) != TYPE_DICTIONARY or item.get("effect") == "NONE":
			continue
		var projected := {"effect": item.get("effect")}
		projected[id_field] = item.get(id_field)
		result.append(projected)
	return result


static func _validate_a6_authored_projection(
	actual,
	expected: Array,
	path: String,
	reason: String,
	errors: Array[String]
) -> void:
	if actual != expected:
		_add_error(errors, path, reason)


static func _validate_a6_durable_manifest(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, path, "expected_dictionary")
		return
	if value.is_empty():
		return
	_validate_closed_dictionary(value, A6_DURABLE_MANIFEST_FIELDS, A6_DURABLE_MANIFEST_FIELDS, path, errors)
	if not _has_required_fields(value, A6_DURABLE_MANIFEST_FIELDS):
		return
	var binding = value["binding"]
	if _validate_dictionary(binding, A6_DURABLE_BINDING_FIELDS, path + ".binding", errors):
		_validate_business_id(binding["sequence_id"], path + ".binding.sequence_id", errors)
		if not _is_semver(binding["authored_version"]):
			_add_error(errors, path + ".binding.authored_version", "expected_major_minor_patch")
		_validate_business_id(binding["resolution_id"], path + ".binding.resolution_id", errors)
	var event_keys := {}
	var effect_count := 0
	for category in A6_DURABLE_CATEGORIES:
		var entries = value[category]
		var category_path: String = path + "." + str(category)
		if typeof(entries) != TYPE_ARRAY:
			_add_error(errors, category_path, "expected_array")
			continue
		var business_ids := {}
		for index in entries.size():
			effect_count += 1
			var item_path: String = category_path + "[%d]" % index
			var entry = entries[index]
			if typeof(entry) != TYPE_DICTIONARY:
				_add_error(errors, item_path, "expected_dictionary")
				continue
			var fields := _a6_durable_effect_fields(category, entry)
			if fields.is_empty():
				_add_error(errors, item_path, "unknown_effect")
				continue
			_validate_exact_fields(entry, fields, item_path, errors)
			if not _has_required_fields(entry, fields):
				continue
			_validate_business_id(entry["event_key"], item_path + ".event_key", errors)
			if event_keys.has(entry["event_key"]):
				_add_error(errors, item_path + ".event_key", "duplicate_across_manifest")
			else:
				event_keys[entry["event_key"]] = true
			_validate_a6_durable_effect(category, entry, item_path, errors)
			var business_id = _a6_durable_business_id(category, entry)
			if business_id == null:
				continue
			_validate_business_id(business_id, item_path + ".business_id", errors)
			if business_ids.has(business_id):
				_add_error(errors, item_path + ".business_id", "duplicate")
			else:
				business_ids[business_id] = true
	if effect_count == 0:
		_add_error(errors, path, "non_empty_effect_set_required")


static func _a6_durable_effect_fields(category: String, entry: Dictionary) -> Array:
	if category == "facts":
		if entry.get("scope") == "RELATION":
			return A6_DURABLE_FACT_RELATION_FIELDS
		if entry.get("scope") == "RELATION_CENTRALE":
			return A6_DURABLE_FACT_CENTRAL_FIELDS
		return []
	var effect = entry.get("effect")
	if category == "knowledge":
		return A6_DURABLE_KNOWLEDGE_FIELDS if effect == "ACQUIRE" else []
	if category == "traces":
		if effect == "CREATE":
			return A6_DURABLE_TRACE_CREATE_FIELDS
		if effect in ["GRANT_ACCESS", "REVOKE_ACCESS"]:
			return A6_DURABLE_TRACE_ACCESS_FIELDS
		return A6_DURABLE_TRACE_TERMINAL_FIELDS if effect == "WITHDRAW" else []
	if category == "promises":
		return A6_DURABLE_PROMISE_CREATE_FIELDS if effect == "CREATE" else (
			A6_DURABLE_PROMISE_TERMINAL_FIELDS if effect in ["PAY", "FAIL"] else []
		)
	if category == "obligations":
		return A6_DURABLE_OBLIGATION_CREATE_FIELDS if effect == "CREATE_DUE" else (
			A6_DURABLE_OBLIGATION_TERMINAL_FIELDS if effect in ["PAY", "FAIL"] else []
		)
	if category == "media_deliveries":
		if effect == "CREATE_DIEGETIC":
			return A6_DURABLE_MEDIA_CREATE_FIELDS
		if effect == "GRANT_ACCESS":
			return A6_DURABLE_MEDIA_GRANT_FIELDS
		return A6_DURABLE_MEDIA_TERMINAL_FIELDS if effect in ["REVOKE_ACCESS", "WITHDRAW"] else []
	return []


static func _validate_a6_durable_effect(
	category: String,
	entry: Dictionary,
	path: String,
	errors: Array[String]
) -> void:
	if category == "facts":
		if entry["scope"] == "RELATION":
			_validate_business_id(entry["personnage_id"], path + ".personnage_id", errors)
		elif entry.has("personnage_id"):
			_add_error(errors, path + ".personnage_id", "forbidden_for_central_relation")
		var fact = entry["fact"]
		if typeof(fact) != TYPE_DICTIONARY:
			_add_error(errors, path + ".fact", "expected_dictionary")
		else:
			_validate_closed_dictionary(fact, A6_DURABLE_FACT_FIELDS, ["fait_id"], path + ".fact", errors)
			if fact.has("fait_id"):
				_validate_business_id(fact["fait_id"], path + ".fact.fait_id", errors)
			for field in fact:
				if field == "permission_future":
					if typeof(fact[field]) != TYPE_BOOL:
						_add_error(errors, path + ".fact.permission_future", "expected_boolean")
				else:
					_validate_durable_string(fact[field], path + ".fact." + field, errors)
		return
	if category == "knowledge":
		_validate_business_id(entry["knowledge_id"], path + ".knowledge_id", errors)
		_validate_business_id(entry["subject_id"], path + ".subject_id", errors)
		_validate_id_array(entry["holder_ids"], path + ".holder_ids", errors, true)
		return
	if category == "traces":
		_validate_business_id(entry["trace_id"], path + ".trace_id", errors)
		if entry["effect"] == "CREATE":
			_validate_business_id(entry["creator_id"], path + ".creator_id", errors)
			for field in ["audience_ids", "controller_ids", "accessible_to_ids"]:
				_validate_id_array(entry[field], path + "." + field, errors, false)
		elif entry["effect"] in ["GRANT_ACCESS", "REVOKE_ACCESS"]:
			_validate_id_array(entry["accessible_to_ids"], path + ".accessible_to_ids", errors, true)
		return
	if category == "promises":
		_validate_business_id(entry["promise_id"], path + ".promise_id", errors)
		if entry["effect"] == "CREATE":
			_validate_business_id(entry["author_id"], path + ".author_id", errors)
			_validate_id_array(entry["beneficiary_ids"], path + ".beneficiary_ids", errors, true)
			_validate_durable_string(entry["content_ref"], path + ".content_ref", errors)
		return
	if category == "obligations":
		_validate_business_id(entry["obligation_id"], path + ".obligation_id", errors)
		if entry["effect"] == "CREATE_DUE":
			_validate_business_id(entry["debtor_id"], path + ".debtor_id", errors)
			_validate_id_array(entry["beneficiary_ids"], path + ".beneficiary_ids", errors, true)
			_validate_durable_string(entry["kind"], path + ".kind", errors)
		return
	_validate_business_id(entry["media_id"], path + ".media_id", errors)
	if entry["effect"] in ["CREATE_DIEGETIC", "GRANT_ACCESS"]:
		_validate_id_array(entry["fictional_audience_ids"], path + ".fictional_audience_ids", errors, false)
	if entry["effect"] == "GRANT_ACCESS":
		if entry["diegetic_status"] not in ["NOT_APPLICABLE", "CREATED"]:
			_add_error(errors, path + ".diegetic_status", "unknown_value")
		if entry["gallery_status"] not in ["HIDDEN", "AVAILABLE"]:
			_add_error(errors, path + ".gallery_status", "unknown_value")


static func _a6_durable_business_id(category: String, entry: Dictionary):
	if category == "facts":
		return entry["fact"].get("fait_id") if typeof(entry.get("fact")) == TYPE_DICTIONARY else null
	var fields := {
		"knowledge": "knowledge_id", "traces": "trace_id", "promises": "promise_id",
		"obligations": "obligation_id", "media_deliveries": "media_id",
	}
	return entry.get(fields.get(category, ""))


static func _validate_a6_relational_facts(value, path: String, errors: Array[String]) -> void:
	path += ".faits_relationnels"
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, path, "expected_array")
		return
	var fact_ids := {}
	for index in value.size():
		var item_path := path + "[%d]" % index
		var fact = value[index]
		if typeof(fact) != TYPE_DICTIONARY:
			_add_error(errors, item_path, "expected_dictionary")
			continue
		_validate_closed_dictionary(fact, A6_RELATIONAL_FACT_FIELDS, ["fait_id"], item_path, errors)
		if not fact.has("fait_id"):
			continue
		_validate_business_id(fact["fait_id"], item_path + ".fait_id", errors)
		if fact_ids.has(fact["fait_id"]):
			_add_error(errors, item_path + ".fait_id", "duplicate")
		fact_ids[fact["fait_id"]] = true


static func _validate_a6_choices(value, resolution_signals: Dictionary, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_ARRAY or value.size() > 3:
		_add_error(errors, path, "expected_zero_to_three_choices")
		return
	if value.is_empty() and not resolution_signals.is_empty():
		_add_error(errors, path, "orphan_resolutions")
	var choice_ids := {}
	var claimed_resolutions := {}
	for index in value.size():
		var item_path := path + "[%d]" % index
		var choice = value[index]
		if not _validate_dictionary(choice, A6_CHOICE_FIELDS, item_path, errors):
			continue
		_validate_business_id(choice["choix_id"], item_path + ".choix_id", errors)
		_validate_non_empty_string(choice["formulation"], item_path + ".formulation", errors)
		_validate_non_empty_string(choice["signal_emis"], item_path + ".signal_emis", errors)
		if choice_ids.has(choice["choix_id"]):
			_add_error(errors, item_path + ".choix_id", "duplicate")
		choice_ids[choice["choix_id"]] = true
		var resolution_ids := _validate_id_array(
			choice["resolution_ids"], item_path + ".resolution_ids", errors, true
		)
		for resolution_id in resolution_ids:
			if not resolution_signals.has(resolution_id):
				_add_error(errors, item_path + ".resolution_ids", "unknown_resolution_%s" % resolution_id)
			elif resolution_signals[resolution_id] != choice["signal_emis"]:
				_add_error(errors, item_path + ".resolution_ids", "signal_mismatch_%s" % resolution_id)
			if claimed_resolutions.has(resolution_id):
				_add_error(errors, item_path + ".resolution_ids", "resolution_reused_%s" % resolution_id)
			claimed_resolutions[resolution_id] = true
	for resolution_id in resolution_signals:
		if not claimed_resolutions.has(resolution_id):
			_add_error(errors, path, "orphan_resolution_%s" % resolution_id)


static func _validate_a6_non_resolution(
	value,
	participant_ids: Dictionary,
	path: String,
	errors: Array[String]
) -> void:
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, path, "expected_dictionary")
		return
	_validate_closed_dictionary(value, A6_NON_RESOLUTION_FIELDS, ["proposition_expire"], path, errors)
	if not value.has("proposition_expire"):
		return
	if value["proposition_expire"] not in ["MISSED", "CANCELLED"]:
		_add_error(errors, path + ".proposition_expire", "unknown_value")
	if value.has("consequence_manquee") and value["consequence_manquee"] != null:
		var consequence = value["consequence_manquee"]
		if not _validate_dictionary(consequence, A6_MISSED_CONSEQUENCE_FIELDS, path + ".consequence_manquee", errors):
			return
		if not participant_ids.has(consequence["personnage_id"]):
			_add_error(errors, path + ".consequence_manquee.personnage_id", "unknown_participant")
		var fact = consequence["fait_relationnel"]
		if typeof(fact) != TYPE_DICTIONARY:
			_add_error(errors, path + ".consequence_manquee.fait_relationnel", "expected_dictionary")
		else:
			_validate_closed_dictionary(
				fact, A6_RELATIONAL_FACT_FIELDS, ["fait_id"], path + ".consequence_manquee.fait_relationnel", errors
			)


static func _validate_closed_dictionary(
	value: Dictionary,
	allowed_fields: Array,
	required_fields: Array,
	path: String,
	errors: Array[String]
) -> void:
	for field in required_fields:
		if not value.has(field):
			_add_error(errors, path + "." + field, "missing_required_field")
	var actual_fields: Array = value.keys()
	actual_fields.sort()
	for field in actual_fields:
		if field not in allowed_fields:
			_add_error(errors, path + "." + str(field), "unknown_field")


static func _validate_string_array(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, path, "expected_array")
		return
	var seen := {}
	for index in value.size():
		_validate_non_empty_string(value[index], path + "[%d]" % index, errors)
		if seen.has(value[index]):
			_add_error(errors, path + "[%d]" % index, "duplicate")
		seen[value[index]] = true


static func _normalized_moment_valid(value) -> bool:
	if typeof(value) != TYPE_STRING or value.length() != 25:
		return false
	if value.substr(10, 1) != "T" or value.substr(16, 1) != ":":
		return false
	if value.substr(19, 1) not in ["+", "-"] or value.substr(22, 1) != ":":
		return false
	if not _date_valid(value.substr(0, 10)) or _time_in_minutes(value.substr(11, 5)) < 0:
		return false
	var seconds: String = value.substr(17, 2)
	var offset_hours: String = value.substr(20, 2)
	var offset_minutes: String = value.substr(23, 2)
	if not seconds.is_valid_int() or not offset_hours.is_valid_int() or not offset_minutes.is_valid_int():
		return false
	var second_value := int(seconds)
	var hour_value := int(offset_hours)
	var minute_value := int(offset_minutes)
	return (
		second_value >= 0 and second_value <= 59
		and hour_value >= 0 and hour_value <= 14
		and minute_value >= 0 and minute_value <= 59
		and (hour_value < 14 or minute_value == 0)
	)


static func _same_offset(first: String, second: String) -> bool:
	return _normalized_moment_valid(first) and _normalized_moment_valid(second) and first.substr(19, 6) == second.substr(19, 6)


static func _time_in_minutes(value) -> int:
	if typeof(value) != TYPE_STRING:
		return -1
	var parts: PackedStringArray = value.split(":")
	if parts.size() != 2 or parts[0].length() != 2 or parts[1].length() != 2:
		return -1
	if not parts[0].is_valid_int() or not parts[1].is_valid_int():
		return -1
	var hours := int(parts[0])
	var minutes := int(parts[1])
	if hours < 0 or hours > 23 or minutes < 0 or minutes > 59:
		return -1
	return hours * 60 + minutes


static func _date_valid(value) -> bool:
	if typeof(value) != TYPE_STRING or value.length() != 10:
		return false
	var parts: PackedStringArray = value.split("-")
	if parts.size() != 3 or parts[0].length() != 4 or parts[1].length() != 2 or parts[2].length() != 2:
		return false
	for part in parts:
		if not part.is_valid_int():
			return false
	var year := int(parts[0])
	var month := int(parts[1])
	var day := int(parts[2])
	if year < 1 or month < 1 or month > 12:
		return false
	var days := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if month == 2 and (year % 400 == 0 or (year % 4 == 0 and year % 100 != 0)):
		days[1] = 29
	return day >= 1 and day <= days[month - 1]


static func _validate_dictionary(value, fields: Array, path: String, errors: Array[String]) -> bool:
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, path, "expected_dictionary")
		return false
	_validate_exact_fields(value, fields, path, errors)
	return _has_required_fields(value, fields)


static func _validate_exact_fields(value: Dictionary, fields: Array, path: String, errors: Array[String]) -> void:
	for field in fields:
		if not value.has(field):
			_add_error(errors, path + "." + field, "missing_required_field")
	var actual_fields: Array = value.keys()
	actual_fields.sort()
	for field in actual_fields:
		if field not in fields:
			_add_error(errors, path + "." + str(field), "unknown_field")


static func _has_required_fields(value: Dictionary, fields: Array) -> bool:
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _validate_non_empty_string(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_STRING or value.is_empty() or value != value.strip_edges():
		_add_error(errors, path, "expected_non_empty_string")


static func _validate_durable_string(value, path: String, errors: Array[String]) -> void:
	if (
		typeof(value) != TYPE_STRING
		or value.is_empty()
		or value.length() > 512
		or value != value.strip_edges()
	):
		_add_error(errors, path, "invalid_durable_string")


static func _validate_non_empty_string_array(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_ARRAY or value.is_empty():
		_add_error(errors, path, "expected_non_empty_array")
		return
	var seen := {}
	for index in value.size():
		_validate_non_empty_string(value[index], path + "[%d]" % index, errors)
		if seen.has(value[index]):
			_add_error(errors, path + "[%d]" % index, "duplicate")
		seen[value[index]] = true


static func _validate_id_array(value, path: String, errors: Array[String], require_non_empty: bool) -> Array:
	var result: Array = []
	if typeof(value) != TYPE_ARRAY or (require_non_empty and value.is_empty()):
		_add_error(errors, path, "expected_%sarray" % ("non_empty_" if require_non_empty else ""))
		return result
	var seen := {}
	for index in value.size():
		var item = value[index]
		_validate_business_id(item, path + "[%d]" % index, errors)
		if seen.has(item):
			_add_error(errors, path + "[%d]" % index, "duplicate")
		else:
			seen[item] = true
			result.append(item)
	return result


static func _validate_business_id(value, path: String, errors: Array[String]) -> void:
	if not _is_business_id(value):
		_add_error(errors, path, "invalid_identifier")
	elif _contains_day_identity(value):
		_add_error(errors, path, "day_based_identifier_forbidden")


static func _validate_media_id(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_STRING or value.is_empty() or value.length() > 160 or value != value.strip_edges():
		_add_error(errors, path, "invalid_media_identifier")
		return
	for index in value.length():
		var character: String = value.substr(index, 1)
		if character not in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_":
			_add_error(errors, path, "invalid_media_identifier")
			return
	if value == value.to_lower() and _contains_day_identity(value):
		_add_error(errors, path, "day_based_identifier_forbidden")


static func _validate_nullable_identifier(value, path: String, errors: Array[String]) -> void:
	if value != null:
		_validate_business_id(value, path, errors)


static func _validate_nullable_media_id(value, path: String, errors: Array[String]) -> void:
	if value != null:
		_validate_media_id(value, path, errors)


static func _validate_positive_integer(value, path: String, errors: Array[String]) -> void:
	if not _is_integer_value(value) or value <= 0:
		_add_error(errors, path, "expected_positive_integer")


static func _validate_non_negative_integer(value, path: String, errors: Array[String]) -> void:
	if not _is_integer_value(value) or value < 0:
		_add_error(errors, path, "expected_non_negative_integer")


static func _is_integer_value(value) -> bool:
	return typeof(value) == TYPE_INT


static func _integer_equals(value, expected: int) -> bool:
	return _is_integer_value(value) and value == expected


static func _is_business_id(value) -> bool:
	if typeof(value) != TYPE_STRING or value.is_empty() or value.length() > 96 or value != value.strip_edges():
		return false
	for index in value.length():
		if value.substr(index, 1) not in "abcdefghijklmnopqrstuvwxyz0123456789_":
			return false
	return true


static func _contains_day_identity(value: String) -> bool:
	var parts: PackedStringArray = value.to_lower().split("_", false)
	for index in parts.size():
		var part: String = parts[index]
		if part.length() == 3 and part.begins_with("j") and part.substr(1, 2).is_valid_int():
			return true
		if part == "chapter" and index + 1 < parts.size():
			var number: String = parts[index + 1]
			if number.length() == 2 and number.is_valid_int():
				return true
	return false


static func _is_semver(value) -> bool:
	if typeof(value) != TYPE_STRING:
		return false
	var parts: PackedStringArray = value.split(".", false)
	if parts.size() != 3:
		return false
	for part in parts:
		if not part.is_valid_int() or int(part) < 0 or (part.length() > 1 and part.begins_with("0")):
			return false
	return true


static func _add_error(errors: Array[String], path: String, code: String) -> void:
	errors.append("%s: %s" % [path, code])


static func _result(errors: Array[String]) -> Dictionary:
	errors.sort()
	return {"valid": errors.is_empty(), "errors": errors.duplicate()}
