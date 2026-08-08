extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const TIME_SCRIPT := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	var size := _parse_size(_arg("--runtime-size", "720x1280"))
	get_window().size = size
	var main = MAIN_SCENE.instantiate()
	main.get_node("PortraitShell").content_mode = "runtime_s1"
	add_child(main)
	await _frames(5)
	var shell = main.shell
	shell.set_safe_area_preset(_arg("--safe-area", "none"))
	var messages = shell.messages_screen
	messages.runtime_delivery_time_scale = 0.01
	await _frames(4)
	_press_thread_card(messages, "thread_marie_private")
	await _frames(3)
	_expect(messages.conversation_screen.narrative_time_label.text == "Mar. · 18:12", "narrative header starts at Mar. · 18:12")
	_expect(TIME_SCRIPT.parse_narrative_time("18:20") == 1100, "strict parser accepts 18:20")
	_expect(TIME_SCRIPT.parse_narrative_time("18:60") == -1, "strict parser rejects 18:60")
	_expect(TIME_SCRIPT.format_narrative_time(1100) == "18:20", "formatter returns 18:20")
	var provider = shell.runtime_provider
	var before: int = provider.current_narrative_time_minutes()
	provider.mark_message_presented("missing")
	_expect(provider.current_narrative_time_minutes() == before, "missing message cannot change time")
	var speed: Button = shell.reading_speed_button
	speed.emit_signal("pressed")
	_expect(messages.reading_speed_multiplier == 3.0, "real speed button selects x3")
	_finish(size)

func _press_thread_card(messages, thread_id: String) -> void:
	for index in range(messages.conversation_list.threads.size()):
		if str(messages.conversation_list.threads[index].get("thread_id", "")) == thread_id:
			messages.conversation_list.cards[index].emit_signal("pressed")
			return
	_expect(false, "thread unavailable")

func _frames(count: int) -> void:
	for _index in range(count): await get_tree().process_frame
func _arg(prefix: String, fallback: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="): return arg.trim_prefix(prefix + "=")
	return fallback
func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x")
	return Vector2i(int(parts[0]), int(parts[1])) if parts.size() == 2 else Vector2i.ZERO
func _expect(condition: bool, message: String) -> void:
	if not condition: failures.append(message)
func _finish(size: Vector2i) -> void:
	if failures.is_empty():
		print("UI-MSG-04B narrative time smoke %dx%d: OK" % [size.x, size.y])
		get_tree().quit(0)
		return
	for failure in failures: push_error(failure)
	get_tree().quit(1)
