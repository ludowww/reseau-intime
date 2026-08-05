extends RefCounted

class_name R8CAuthoredSequenceValidator

const Contract := preload("res://scripts/unified_runtime/contracts/AuthoredSequenceV1.gd")
const SceneDefinition := preload("res://scripts/narrative_scene/SceneDefinition.gd")


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
			var scene_error: String = SceneDefinition.valider_fermee(a6["definition"])
			if not scene_error.is_empty():
				_add_error(errors, "root.orchestration.a6_entry.definition", "invalid_a3_definition_%s" % scene_error)
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
	if not SceneDefinition.moment_normalise_valide(opens_at):
		_add_error(errors, "root.temporal_projection.resolved_window.opens_at", "invalid_normalized_moment")
	if not SceneDefinition.moment_normalise_valide(closes_at):
		_add_error(errors, "root.temporal_projection.resolved_window.closes_at", "invalid_normalized_moment")
	if (
		typeof(opens_at) == TYPE_STRING
		and typeof(closes_at) == TYPE_STRING
		and SceneDefinition.moment_normalise_valide(opens_at)
		and SceneDefinition.moment_normalise_valide(closes_at)
		and (opens_at >= closes_at or not SceneDefinition.meme_offset(opens_at, closes_at))
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
		if not SceneDefinition.moment_normalise_valide(message["diegetic_at"]):
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
		_validate_nullable_identifier(choice["resolution_id"], choice_path + ".resolution_id", errors)
		_validate_nullable_identifier(choice["next_beat_id"], choice_path + ".next_beat_id", errors)
		if choice["resolution_id"] == null and choice["next_beat_id"] == null:
			_add_error(errors, choice_path, "choice_without_resolution_or_next_beat")
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

	var a10_choice_ids := {}
	var orchestration = sequence.get("orchestration")
	var a6_entry = orchestration.get("a6_entry", {}) if typeof(orchestration) == TYPE_DICTIONARY else {}
	var definition = a6_entry.get("definition", {}) if typeof(a6_entry) == TYPE_DICTIONARY else {}
	if typeof(definition) == TYPE_DICTIONARY and typeof(definition.get("choix", [])) == TYPE_ARRAY:
		for option in definition.get("choix", []):
			if typeof(option) == TYPE_DICTIONARY:
				a10_choice_ids[option.get("choix_id")] = true
	var resolution_ids: Array = resolutions.keys()
	resolution_ids.sort()
	for resolution_id in resolution_ids:
		var resolution: Dictionary = resolutions[resolution_id]
		var path := "root.resolutions.%s" % resolution_id
		if not choices.has(resolution["choice_id"]):
			_add_error(errors, path + ".choice_id", "unknown_choice")
		elif choices[resolution["choice_id"]]["checkpoint_after"] != resolution["terminal_checkpoint_id"]:
			_add_error(errors, path + ".terminal_checkpoint_id", "choice_checkpoint_mismatch")
		if not a10_choice_ids.has(resolution["a10_choice_id"]):
			_add_error(errors, path + ".a10_choice_id", "unknown_a6_choice")
		if not checkpoints.has(resolution["terminal_checkpoint_id"]):
			_add_error(errors, path + ".terminal_checkpoint_id", "unknown_checkpoint")
		if resolution["next_beat_id"] != null:
			if not beats.has(resolution["next_beat_id"]):
				_add_error(errors, path + ".next_beat_id", "unknown_beat")
			elif beats[resolution["next_beat_id"]]["type"] != "RETURN":
				_add_error(errors, path + ".next_beat_id", "expected_return_beat")
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
	if not _is_integer_value(value) or float(value) <= 0.0:
		_add_error(errors, path, "expected_positive_integer")


static func _validate_non_negative_integer(value, path: String, errors: Array[String]) -> void:
	if not _is_integer_value(value) or float(value) < 0.0:
		_add_error(errors, path, "expected_non_negative_integer")


static func _is_integer_value(value) -> bool:
	return (
		typeof(value) in [TYPE_INT, TYPE_FLOAT]
		and is_finite(float(value))
		and float(value) == floor(float(value))
	)


static func _integer_equals(value, expected: int) -> bool:
	return _is_integer_value(value) and int(value) == expected


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
