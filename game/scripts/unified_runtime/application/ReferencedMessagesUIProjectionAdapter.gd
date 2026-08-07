extends "res://scripts/unified_runtime/projection/MessagesUIProjectionAdapter.gd"

class_name R8CReferencedMessagesUIProjectionAdapter

const REFERENCED_BEAT_TYPES := ["AFTERCARE", "RETURN"]

var _referenced_content_resolver


static func create(executor, projection_port, configuration) -> Dictionary:
	if typeof(configuration) != TYPE_DICTIONARY:
		return {"ok": false, "error_code": "INVALID_CONFIGURATION", "adapter": null}
	var presentation_metadata = configuration.get("presentation_metadata")
	var referenced_content_resolver = configuration.get("referenced_content_resolver")
	if (
		referenced_content_resolver == null
		or typeof(referenced_content_resolver) != TYPE_OBJECT
		or not referenced_content_resolver.has_method("resolve")
	):
		return {
			"ok": false,
			"error_code": "INVALID_REFERENCED_CONTENT_RESOLVER",
			"adapter": null,
		}
	var adapter := new()
	var error_code: String = adapter._initialize(
		executor, projection_port, presentation_metadata
	)
	if not error_code.is_empty():
		return {"ok": false, "error_code": error_code, "adapter": null}
	adapter._referenced_content_resolver = referenced_content_resolver
	return {"ok": true, "error_code": null, "adapter": adapter}


func settle_durable_boundary() -> Dictionary:
	if _active.is_empty():
		return {"accepted": true, "error_code": null}
	if (
		not bool(_active.get("projection_closed", false))
		or _executor.execution_state().get("execution_status")
		not in ["RESOLVED_RETURN_PENDING", "COMPLETE"]
	):
		return {"accepted": false, "error_code": "PROJECTION_NOT_DURABLY_CLOSED"}
	var player_bubble_id := str(_active.get("player_bubble_id", ""))
	if not player_bubble_id.is_empty():
		_record_presented_message(str(_active.get("thread_id", "")), player_bubble_id)
	_active = {}
	_notification_presented = false
	_notification_dismissed = false
	_progression_ack_sent = false
	_progression_command_sent = false
	return {"accepted": true, "error_code": null}


func _prepare_beat(beat: Dictionary) -> Dictionary:
	if beat.get("type") not in REFERENCED_BEAT_TYPES:
		return super._prepare_beat(beat)
	if beat.is_empty():
		return {"ok": false, "error_code": "NO_CURRENT_BEAT"}
	if beat.get("projection_target") != "MESSAGES":
		return {"ok": false, "error_code": "UNSUPPORTED_TARGET"}
	var referenced = _referenced_content_resolver.resolve(beat)
	if typeof(referenced) != TYPE_DICTIONARY:
		return {"ok": false, "error_code": "UNRESOLVED_CONTENT_REF"}
	if not referenced.get("ok", false):
		return {
			"ok": false,
			"error_code": str(referenced.get("error_code", "UNRESOLVED_CONTENT_REF")),
		}
	var content: Dictionary = referenced.get("content", {}).duplicate(true)
	var resolved := _resolve_thread(beat.get("participant_ids", []))
	if not resolved["ok"]:
		return resolved
	if str(content.get("thread_id", "")) != str(resolved["thread"].get("thread_id", "")):
		return {"ok": false, "error_code": "THREAD_ID_MISMATCH"}
	return {
		"ok": true,
		"error_code": null,
		"thread": resolved["thread"],
		"content": content,
	}


func _is_message_beat_type(beat_type) -> bool:
	return beat_type == "MESSAGE" or beat_type in REFERENCED_BEAT_TYPES


func _should_automatically_open_next_projection() -> bool:
	return false
