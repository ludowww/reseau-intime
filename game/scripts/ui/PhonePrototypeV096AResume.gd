extends "res://scripts/ui/PhonePrototypeV096A.gd"

const CONTACT_PRIORITY_PENDING := 3
const CONTACT_PRIORITY_ACTIONABLE := 2
const CONTACT_PRIORITY_CURRENT_COMPLETE := 1

func _render_contacts_view(day_value) -> void:
	_add_label(conversation_list, "Contacts", 18)
	var conversations := _collect_global_threads()
	if conversations.is_empty():
		_add_muted_label(conversation_list, "Aucun contact disponible.", 12)
		return
	var actionable_names: Array[String] = []
	for conversation in conversations:
		if _is_contact_actionable(conversation):
			var contact_name := _conversation_name(conversation)
			if contact_name != "" and not actionable_names.has(contact_name):
				actionable_names.append(contact_name)
	if actionable_names.is_empty():
		_add_muted_label(conversation_list, "Aucun nouveau message. Les autres fils s’ouvrent en lecture seule.", 12)
	else:
		_add_muted_label(conversation_list, "À poursuivre : %s" % " · ".join(actionable_names), 12)
	for conversation in conversations:
		var source_day_value = int(conversation.get("_source_day_value", day_value))
		_add_conversation_card(source_day_value, conversation)

func _collect_global_threads() -> Array:
	var entries: Array = super._collect_global_threads()
	for raw_entry in entries:
		if typeof(raw_entry) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = raw_entry
		var source_day_value = entry.get("_source_day_value", current_day_value)
		entry["_contact_actionable"] = _thread_is_actionable(source_day_value, entry)
	entries.sort_custom(func(a, b):
		var a_priority := _contact_priority(a)
		var b_priority := _contact_priority(b)
		if a_priority != b_priority:
			return a_priority > b_priority
		return int(a.get("_sort_score", 0)) > int(b.get("_sort_score", 0))
	)
	return entries

func _contact_priority(conversation: Dictionary) -> int:
	if _is_conversation_pending(conversation):
		return CONTACT_PRIORITY_PENDING
	if _is_contact_actionable(conversation):
		return CONTACT_PRIORITY_ACTIONABLE
	var source_day_value = conversation.get("_source_day_value", null)
	if source_day_value != null and TimelineState.is_current_day(source_day_value):
		return CONTACT_PRIORITY_CURRENT_COMPLETE
	return 0

func _is_contact_actionable(conversation: Dictionary) -> bool:
	return bool(conversation.get("_contact_actionable", false))

func _thread_is_actionable(day_value, conversation: Dictionary) -> bool:
	if day_value == null or not TimelineState.is_current_day(day_value):
		return false
	for raw_episode_id in _conversation_episode_ids(conversation):
		var episode_id := str(raw_episode_id)
		if TimelineState.is_episode_completed(day_value, episode_id):
			continue
		if TimelineState.is_conversation_expired(day_value, episode_id):
			continue
		if _is_episode_available(day_value, episode_id):
			return true
	return false

func _conversation_status_text(conversation: Dictionary) -> String:
	if _is_conversation_pending(conversation):
		return "Nouveau"
	if _is_contact_actionable(conversation):
		return "À poursuivre"
	var source_day_value = conversation.get("_source_day_value", null)
	if source_day_value != null and TimelineState.is_current_day(source_day_value):
		return "Terminé"
	return "Historique"

func _conversation_has_activity_badge(conversation: Dictionary) -> bool:
	return _is_conversation_pending(conversation) or _is_contact_actionable(conversation)

func _open_conversation(day_value, conversation: Dictionary) -> void:
	if not _thread_is_actionable(day_value, conversation):
		_open_history_conversation(day_value, conversation)
		return
	super._open_conversation(day_value, conversation)
