extends RefCounted

class_name RuntimeUnread

const INCOMING_CONTENT_TYPES := ["TEXT", "IMAGE"]

static func incoming_unread_count(transcript: Array[Dictionary], presented_message_ids: Dictionary, source_day: int) -> int:
	var count := 0
	for message in transcript:
		if not _is_unread_incoming(message, source_day):
			continue
		if not presented_message_ids.has(str(message.get("message_id", ""))):
			count += 1
	return count

static func incoming_batch_fully_presented(transcript: Array[Dictionary], presented_message_ids: Dictionary, source_day: int) -> bool:
	var has_incoming := false
	for message in transcript:
		if not _is_unread_incoming(message, source_day):
			continue
		has_incoming = true
		if not presented_message_ids.has(str(message.get("message_id", ""))):
			return false
	return has_incoming

static func _is_unread_incoming(message: Dictionary, source_day: int) -> bool:
	return (
		int(message.get("source_day", 0)) == source_day
		and not bool(message.get("is_player", false))
		and str(message.get("content_type", "")) in INCOMING_CONTENT_TYPES
		and not bool(message.get("is_read", true))
	)
