extends RefCounted

class_name R8CPersistentMessagesStateV1

const SCHEMA_VERSION := 1
const FIELDS := ["schema_version", "source", "presented_message_ids_by_thread"]
const SOURCE_FIELDS := ["characters", "threads", "messages_by_thread", "choices_by_thread"]
const MUTABLE_THREAD_FIELDS := [
	"last_preview", "last_timestamp", "unread_count", "has_unread_content",
]


static func empty(metadata: Dictionary) -> Dictionary:
	var messages_by_thread := {}
	var choices_by_thread := {}
	var presented := {}
	for thread in metadata.get("threads", []):
		var thread_id := str(thread.get("thread_id", ""))
		messages_by_thread[thread_id] = []
		choices_by_thread[thread_id] = []
		presented[thread_id] = []
	return {
		"schema_version": SCHEMA_VERSION,
		"source": {
			"characters": metadata.get("characters", {}).duplicate(true),
			"threads": metadata.get("threads", []).duplicate(true),
			"messages_by_thread": messages_by_thread,
			"choices_by_thread": choices_by_thread,
		},
		"presented_message_ids_by_thread": presented,
	}


static func merge_with_active(
	persistent_state: Dictionary,
	active_source: Dictionary,
	active_presented: Dictionary,
	metadata: Dictionary,
) -> Dictionary:
	var base_validation := validate(persistent_state, metadata)
	if not base_validation["valid"]:
		return _failure("INVALID_PERSISTENT_MESSAGES_STATE")
	var merged: Dictionary = persistent_state.duplicate(true)
	var source: Dictionary = merged["source"]
	for thread_id in active_source.get("messages_by_thread", {}):
		if not source["messages_by_thread"].has(thread_id):
			return _failure("UNKNOWN_GLOBAL_THREAD")
		var existing: Array = source["messages_by_thread"][thread_id]
		var by_id := {}
		for message in existing:
			by_id[str(message.get("message_id", ""))] = message
		for message in active_source["messages_by_thread"][thread_id]:
			var message_id := str(message.get("message_id", ""))
			if by_id.has(message_id):
				if by_id[message_id] != message:
					return _failure("CONFLICTING_GLOBAL_MESSAGE_ID")
				continue
			existing.append(message.duplicate(true))
			by_id[message_id] = message
		source["messages_by_thread"][thread_id] = existing
		_update_thread_tail(source, thread_id)
	for thread_id in source["choices_by_thread"]:
		source["choices_by_thread"][thread_id] = active_source.get("choices_by_thread", {}).get(thread_id, []).duplicate(true)
	for thread_id in active_presented:
		if not merged["presented_message_ids_by_thread"].has(thread_id):
			return _failure("UNKNOWN_GLOBAL_THREAD")
		var ids: Array = merged["presented_message_ids_by_thread"][thread_id]
		for message_id in active_presented[thread_id]:
			if message_id not in ids:
				ids.append(message_id)
		merged["presented_message_ids_by_thread"][thread_id] = ids
	var validation := validate(merged, metadata)
	if not validation["valid"]:
		return _failure("INVALID_MERGED_MESSAGES_STATE")
	return {"ok": true, "error_code": null, "state": merged}


static func without_active_choices(state: Dictionary) -> Dictionary:
	var result: Dictionary = state.duplicate(true)
	for thread_id in result.get("source", {}).get("choices_by_thread", {}):
		result["source"]["choices_by_thread"][thread_id] = []
	return result


static func without_sequence(state: Dictionary, sequence_id: String) -> Dictionary:
	var result: Dictionary = without_active_choices(state)
	if sequence_id.is_empty():
		return result
	var source: Dictionary = result.get("source", {})
	for thread_id in source.get("messages_by_thread", {}):
		var kept: Array = []
		var kept_ids := {}
		for message in source["messages_by_thread"][thread_id]:
			if str(message.get("sequence_id", "")) == sequence_id:
				continue
			kept.append(message)
			kept_ids[str(message.get("message_id", ""))] = true
		source["messages_by_thread"][thread_id] = kept
		var kept_presented: Array = []
		for message_id in result["presented_message_ids_by_thread"].get(thread_id, []):
			if kept_ids.has(message_id):
				kept_presented.append(message_id)
		result["presented_message_ids_by_thread"][thread_id] = kept_presented
		_update_thread_tail(source, thread_id)
	return result


static func validate(value, metadata: Dictionary, catalog: Dictionary = {}) -> Dictionary:
	var errors: Array[String] = []
	if typeof(value) != TYPE_DICTIONARY or not _exact(value, FIELDS):
		return _result(["persistent_messages_state:unexpected_fields"])
	if value["schema_version"] != SCHEMA_VERSION:
		errors.append("persistent_messages_state.schema_version:unsupported_version")
	var source = value["source"]
	if typeof(source) != TYPE_DICTIONARY or not _exact(source, SOURCE_FIELDS):
		return _result(["persistent_messages_state.source:unexpected_fields"])
	if source["characters"] != metadata.get("characters", {}):
		errors.append("persistent_messages_state.source.characters:catalog_mismatch")
	var expected_threads: Array = metadata.get("threads", [])
	if typeof(source["threads"]) != TYPE_ARRAY or source["threads"].size() != expected_threads.size():
		errors.append("persistent_messages_state.source.threads:catalog_mismatch")
	else:
		for index in expected_threads.size():
			if not _thread_matches(source["threads"][index], expected_threads[index]):
				errors.append("persistent_messages_state.source.threads:catalog_mismatch")
				break
	var thread_ids: Array = []
	for thread in expected_threads:
		thread_ids.append(str(thread.get("thread_id", "")))
	for field in ["messages_by_thread", "choices_by_thread"]:
		if typeof(source[field]) != TYPE_DICTIONARY or not _same_keys(source[field], thread_ids):
			errors.append("persistent_messages_state.source.%s:thread_mismatch" % field)
	if (
		typeof(value["presented_message_ids_by_thread"]) != TYPE_DICTIONARY
		or not _same_keys(value["presented_message_ids_by_thread"], thread_ids)
	):
		errors.append("persistent_messages_state.presented_message_ids_by_thread:thread_mismatch")
	if not errors.is_empty():
		return _result(errors)
	var seen_ids := {}
	for thread_id in thread_ids:
		var messages = source["messages_by_thread"][thread_id]
		var choices = source["choices_by_thread"][thread_id]
		var presented = value["presented_message_ids_by_thread"][thread_id]
		if typeof(messages) != TYPE_ARRAY or typeof(choices) != TYPE_ARRAY or typeof(presented) != TYPE_ARRAY:
			errors.append("persistent_messages_state.source:expected_arrays")
			continue
		var source_ids: Array = []
		for message in messages:
			var message_id := str(message.get("message_id", "")) if typeof(message) == TYPE_DICTIONARY else ""
			if message_id.is_empty() or seen_ids.has(message_id):
				errors.append("persistent_messages_state.source:invalid_or_duplicate_message_id")
				continue
			seen_ids[message_id] = true
			source_ids.append(message_id)
			if not catalog.is_empty() and not _message_matches_catalog(message, thread_id, catalog):
				errors.append("persistent_messages_state.source:message_catalog_mismatch:" + message_id)
		var seen_presented := {}
		for message_id in presented:
			if typeof(message_id) != TYPE_STRING or seen_presented.has(message_id) or message_id not in source_ids:
				errors.append("persistent_messages_state.presented_message_ids_by_thread:invalid_prefix")
				break
			seen_presented[message_id] = true
		if presented != source_ids.slice(0, presented.size()):
			errors.append("persistent_messages_state.presented_message_ids_by_thread:not_prefix")
	return _result(errors)


static func _message_matches_catalog(message, thread_id: String, catalog: Dictionary) -> bool:
	if typeof(message) != TYPE_DICTIONARY:
		return false
	if message.has("choice_id"):
		var choice = catalog.get("choice_definitions", {}).get(message.get("choice_id"))
		return (
			typeof(choice) == TYPE_DICTIONARY
			and choice.get("thread_id") == thread_id
			and choice.get("sequence_id") == message.get("sequence_id")
			and choice.get("beat_id") == message.get("beat_id")
			and choice.get("text") == message.get("text")
			and message.get("author_id") == "player"
		)
	var authored = catalog.get("message_definitions", {}).get(message.get("message_id"))
	return (
		typeof(authored) == TYPE_DICTIONARY
		and authored.get("thread_id") == thread_id
		and authored.get("sequence_id") == message.get("sequence_id")
		and authored.get("beat_id") == message.get("beat_id")
		and authored.get("author_id") == message.get("author_id")
		and authored.get("text") == message.get("text")
		and authored.get("diegetic_at") == message.get("diegetic_at")
		and authored.get("relative_order") == message.get("relative_order")
	)


static func _thread_matches(candidate, expected) -> bool:
	if typeof(candidate) != TYPE_DICTIONARY or typeof(expected) != TYPE_DICTIONARY:
		return false
	if not _same_keys(candidate, expected.keys()):
		return false
	for field in expected:
		if field not in MUTABLE_THREAD_FIELDS and candidate[field] != expected[field]:
			return false
	return (
		typeof(candidate.get("last_preview")) == TYPE_STRING
		and typeof(candidate.get("last_timestamp")) == TYPE_STRING
		and typeof(candidate.get("unread_count")) == TYPE_INT
		and int(candidate.get("unread_count")) >= 0
		and typeof(candidate.get("has_unread_content")) == TYPE_BOOL
	)


static func _update_thread_tail(source: Dictionary, thread_id: String) -> void:
	var messages: Array = source["messages_by_thread"][thread_id]
	var unread := 0
	for message in messages:
		if not bool(message.get("is_player", false)) and not bool(message.get("is_read", false)):
			unread += 1
	for thread in source["threads"]:
		if str(thread.get("thread_id", "")) != thread_id:
			continue
		thread["unread_count"] = unread
		thread["has_unread_content"] = unread > 0
		if not messages.is_empty():
			thread["last_preview"] = str(messages[-1].get("text", ""))
			thread["last_timestamp"] = str(messages[-1].get("timestamp", ""))
		return


static func _exact(value: Dictionary, fields: Array) -> bool:
	return value.size() == fields.size() and _same_keys(value, fields)


static func _same_keys(value: Dictionary, expected_fields: Array) -> bool:
	if value.size() != expected_fields.size():
		return false
	for field in expected_fields:
		if not value.has(field):
			return false
	return true


static func _result(errors: Array) -> Dictionary:
	return {"valid": errors.is_empty(), "errors": errors.duplicate()}


static func _failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "state": {}}
