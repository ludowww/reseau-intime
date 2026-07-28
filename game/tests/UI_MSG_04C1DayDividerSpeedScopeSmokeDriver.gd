extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const TIMELINE_SCRIPT := preload("res://scripts/ui/messages/MessageTimeline.gd")
var failures: Array[String] = []
var main

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	main = MAIN_SCENE.instantiate()
	add_child(main)
	await _frames(6)
	var messages = main.shell.messages_screen
	messages.runtime_delivery_request_id += 1
	messages.runtime_delivery_active = false
	var timeline = TIMELINE_SCRIPT.new()
	add_child(timeline)
	var fixture: Array[Dictionary] = [
		_message("d1", 1, "Premier message mardi"),
		{"message_id": "legacy_d2", "content_type": "SYSTEM_DAY_DIVIDER", "text": "MERCREDI — FIN DE JOURNÉE", "source_day": 2},
		_message("d2", 2, "Premier message mercredi"),
		_message("d3", 3, "Premier message jeudi"),
	]
	timeline.configure(fixture, messages.characters, false, messages.PORTRAIT_THEME)
	await _frames(2)
	_expect(timeline.day_divider_labels() == ["Mardi", "Mercredi", "Jeudi"], "rebuild inserts normalized Tuesday, Wednesday and Thursday dividers")
	_expect(timeline.day_divider_count() == 3, "rebuild keeps exactly one divider per source day")
	_expect(timeline.message_bubble_count() == 3, "SYSTEM_DAY_DIVIDER is never rendered as a bubble")
	_expect(not "FIN DE JOURNÉE" in " ".join(timeline.day_divider_labels()), "legacy end-of-day text is not rendered")
	_expect(_divider_immediately_precedes_message(timeline, "d1", "Mardi"), "Mardi precedes its first message")
	_expect(_divider_immediately_precedes_message(timeline, "d2", "Mercredi"), "Mercredi precedes its first message")
	_expect(_divider_immediately_precedes_message(timeline, "d3", "Jeudi"), "Jeudi precedes its first message")

	timeline.configure([_message("append_d1", 1, "Mardi")], messages.characters, false, messages.PORTRAIT_THEME)
	timeline.append_incoming_message({"message_id": "append_legacy_d2", "content_type": "SYSTEM_DAY_DIVIDER", "text": "FIN DE JOURNÉE", "source_day": 2})
	timeline.append_incoming_message(_message("append_d2", 2, "Mercredi"))
	_expect(timeline.day_divider_labels() == ["Mardi", "Mercredi"], "dynamic divider is normalized and not duplicated by its first message")
	_expect(timeline.message_bubble_count() == 2, "dynamic SYSTEM_DAY_DIVIDER is not a bubble")
	_expect(_divider_immediately_precedes_message(timeline, "append_d2", "Mercredi"), "dynamic divider precedes the appended message")

	var marie: Dictionary = messages.characters.get("marie", {})
	timeline.show_typing(marie, false, true, 8.0)
	timeline.replace_typing_with_message(_message("typing_d3", 3, "Jeudi"), true)
	await _frames(3)
	_expect(timeline.day_divider_labels() == ["Mardi", "Mercredi", "Jeudi"], "typing replacement inserts the next day divider")
	_expect(timeline.message_bubble_count() == 3, "typing replacement adds only the message bubble")
	_expect(not timeline.typing_visible(), "typing replacement remains atomic")
	_expect(_divider_immediately_precedes_message(timeline, "typing_d3", "Jeudi"), "typing replacement keeps divider before message")

	messages.reading_speed_multiplier = 8.0
	messages.update_active_typing_speed()
	await _exercise_real_time_overlay(messages.time_passage_overlay)
	await _finish()

func _exercise_real_time_overlay(overlay) -> void:
	overlay.set_process(false)
	overlay.set_reduced_motion(false)
	var fixtures: Array[Dictionary] = [
		{"phase": "CLOCK", "from_minutes": 600, "to_minutes": 601, "from_time": "10:00", "to_time": "10:01", "duration_seconds": 1.0},
		{"phase": "OFF_PHONE", "text": "Temps réel", "duration_seconds": 1.0},
		{"phase": "NIGHT", "duration_seconds": 1.0},
		{"phase": "NEW_DAY", "time": "08:00", "duration_seconds": 1.0},
	]
	var request_id := 700
	for phase in fixtures:
		request_id += 1
		_expect(overlay.play_flow([phase], request_id), "%s starts" % phase.phase)
		overlay.set_process(false)
		_expect(not overlay.speed_button.visible, "%s hides the overlay speed button" % phase.phase)
		overlay._process(0.50)
		_expect(overlay.active, "%s remains active after 0.50 real seconds at message speed x8" % phase.phase)
		overlay._process(0.51)
		_expect(not overlay.active, "%s completes after its real-time duration" % phase.phase)
		overlay.dismiss()

func _message(message_id: String, source_day: int, text: String) -> Dictionary:
	return {
		"message_id": message_id,
		"author_id": "marie",
		"timestamp": "10:00",
		"content_type": "TEXT",
		"text": text,
		"media_ref": "",
		"is_player": false,
		"is_read": true,
		"source_day": source_day,
	}

func _divider_immediately_precedes_message(timeline, message_id: String, label: String) -> bool:
	var children: Array[Node] = timeline.message_box.get_children()
	for index in range(1, children.size()):
		if str(children[index].get_meta("message_id", "")) != message_id:
			continue
		var previous = children[index - 1]
		return previous.get_script() == timeline.DAY_DIVIDER_SCRIPT and str(previous.display_text()) == label
	return false

func _frames(count: int) -> void:
	for _index in range(count):
		await get_tree().process_frame

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _finish() -> void:
	main.shell.messages_screen.runtime_delivery_request_id += 1
	main.shell.messages_screen.runtime_delivery_active = false
	await _frames(8)
	main.queue_free()
	await _frames(8)
	if failures.is_empty():
		print("UI-MSG-04C1 day divider and speed scope smoke: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)
