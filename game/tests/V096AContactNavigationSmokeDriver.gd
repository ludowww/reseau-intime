extends Node

const PHONE_SCRIPT = preload("res://scripts/ui/PhonePrototypeV096A.gd")
const CONVERSATION_SCRIPT = preload("res://scripts/ui/ConversationViewV096A.gd")

var failures: Array[String] = []

func _ready() -> void:
	call_deferred("_run")

func _run() -> void:
	DataLoader.load_all()
	var phone := PHONE_SCRIPT.new()
	phone._ensure_v096_content_loaded()
	GameState.reset_state()
	TimelineState.reset_timeline()
	phone._build_layout()
	phone._render_days()
	TimelineState.unlock_day(9)
	phone._unlock_conversation(9, "chapter_09_mathilde_visual_boundary")
	phone._unlock_conversation(9, "chapter_09_sandra_visual_boundary")
	phone._unlock_conversation(9, "chapter_09_marie_pauline_social_set")
	phone._render_conversations(9)
	match _scenario():
		"A": _scenario_a(phone)
		"B": _scenario_b(phone)
		"C": _scenario_c(phone)
		"D": _scenario_d(phone)
		"E": _scenario_e(phone)
		"F": _scenario_f(phone)
		"G": _scenario_g(phone)
		"H": _scenario_h(phone)
		"I": _scenario_i(phone)
		"J": _scenario_j(phone)
		_:
			failures.append("Unknown scenario: %s" % _scenario())
	await get_tree().process_frame
	if failures.is_empty():
		print("V0.96a contact navigation smoke %s: OK" % _scenario())
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	print("V0.96a contact navigation smoke %s: FAILED (%d)" % [_scenario(), failures.size()])
	get_tree().quit(1)

func _scenario() -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--scenario="):
			return arg.trim_prefix("--scenario=")
	return ""

func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _scenario_a(phone) -> void:
	phone._show_contacts()
	_expect(not phone.day_list.visible, "A: day list must stay hidden")
	_expect(phone.phone_mode == "CONTACTS", "A: messages screen must default to contacts")

func _scenario_b(phone) -> void:
	phone._show_contacts()
	var threads: Array = phone._collect_global_threads()
	var ids: Array[String] = []
	for conversation in threads:
		var id := str(conversation.get("id", ""))
		_expect(not ids.has(id), "B: duplicate thread id %s" % id)
		ids.append(id)

func _scenario_c(phone) -> void:
	phone._show_history()
	_expect(phone.phone_mode == "HISTORY", "C: history mode not set")
	phone._show_history_day(9)
	_expect(phone.history_day_value == 9, "C: history day not opened")
	phone._show_contacts()
	_expect(phone.phone_mode == "CONTACTS", "C: contacts not restored")

func _scenario_d(phone) -> void:
	var threads: Array = phone._collect_global_threads()
	var convo: Dictionary = {}
	if not threads.is_empty():
		convo = threads.front()
	if convo.is_empty():
		return
	phone._open_conversation(9, convo)
	var current_id := str(phone.conversation_view.call("current_thread_id"))
	phone._show_contacts()
	_expect(current_id == str(phone.conversation_view.call("current_thread_id")), "D: conversation state changed on contacts return")

func _scenario_e(phone) -> void:
	phone._show_contacts()
	phone._show_conversation_notification(9, "chapter_09_sandra_visual_boundary", "Sandra", "Je dois déplacer notre déjeuner.")
	_expect(phone.pending_thread_ids.has("thread_sandra_private"), "E: pending not recorded")
	_expect(phone.notification_target_conversation_id == "thread_sandra_private", "E: notification target missing")

func _scenario_f(phone) -> void:
	phone._show_conversation_notification(9, "chapter_09_marie_pauline_social_set", "Marie + Pauline", "Nico garde la table encore quelques minutes.")
	phone._show_contacts()
	phone._show_conversation_notification(9, "chapter_09_marie_pauline_social_set", "Marie + Pauline", "Nico garde la table encore quelques minutes.")
	_expect(phone.pending_thread_ids.has("thread_marie_pauline_social"), "F: same-thread pending missing")

func _scenario_g(phone) -> void:
	phone._show_conversation_notification(9, "chapter_09_mathilde_visual_boundary", "Mathilde", "J’ai enfin eu le réparateur.")
	phone._unlock_conversation(9, "chapter_09_mathilde_visual_boundary")
	phone._open_notification_target()
	_expect(not phone.pending_thread_ids.has("thread_mathilde_private"), "G: pending must clear once")

func _scenario_h(phone) -> void:
	var chapter9 := FileAccess.get_file_as_string("res://data/conversations/chapter_09_modular_index.json")
	var parsed: Dictionary = JSON.parse_string(chapter9)
	_expect(str(parsed.get("conversation_availability", {}).get("unlocks", {}).get("chapter_09_mathilde_visual_boundary", {}).get("notification", {}).get("title", "")) == "Mathilde", "H: Mathilde notification missing")
	_expect(str(parsed.get("conversation_availability", {}).get("unlocks", {}).get("chapter_09_sandra_visual_boundary", {}).get("notification", {}).get("title", "")) == "Sandra", "H: Sandra notification missing")

func _scenario_i(phone) -> void:
	var chapter9 := FileAccess.get_file_as_string("res://data/conversations/chapter_09_modular_index.json")
	var parsed: Dictionary = JSON.parse_string(chapter9)
	_expect(str(parsed.get("conversation_availability", {}).get("unlocks", {}).get("chapter_09_marie_pauline_social_set", {}).get("notification", {}).get("title", "")) == "Marie + Pauline", "I: social set notification missing")

func _scenario_j(phone) -> void:
	phone._show_history()
	phone._show_conversation_notification(9, "chapter_09_sandra_visual_boundary", "Sandra", "Je dois déplacer notre déjeuner.")
	phone._hide_notification()
	phone._show_contacts()
	_expect(phone.phone_mode == "CONTACTS", "J: reset/navigate state broken")
