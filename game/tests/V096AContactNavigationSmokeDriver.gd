extends Node

const PHONE_SCRIPT = preload("res://scripts/ui/PhonePrototypeV096AResume.gd")
const CONVERSATION_SCRIPT = preload("res://scripts/ui/ConversationViewV096AResume.gd")

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
	TimelineState.set_current_day(9)
	TimelineState.set_current_phase(9, "wednesday_carryover_route")
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
		"K": _scenario_k(phone)
		"L": _scenario_l(phone)
		"M": _scenario_m(phone)
		"N": _scenario_n(phone)
		"O": _scenario_o(phone)
		"P": _scenario_p(phone)
		"Q": _scenario_q(phone)
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

func _thread_by_id(phone, thread_id: String) -> Dictionary:
	for conversation in phone._collect_global_threads():
		if phone._conversation_id(conversation) == thread_id:
			return conversation
	return {}

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
	phone._open_conversation(int(convo.get("_source_day_value", 9)), convo)
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

func _scenario_k(phone) -> void:
	var chapter9 := FileAccess.get_file_as_string("res://data/conversations/chapter_09_modular_index.json")
	var parsed: Dictionary = JSON.parse_string(chapter9)
	var availability: Dictionary = parsed.get("conversation_availability", {})
	var initial_ids: Array = availability.get("initial_conversation_ids", [])
	var unlocks: Dictionary = availability.get("unlocks", {})
	_expect(initial_ids.is_empty(), "K: social set is pending before its authored phase")
	for conversation_id in [
		"chapter_09_mathilde_visual_boundary",
		"chapter_09_sandra_visual_boundary",
		"chapter_09_marie_pauline_social_set",
	]:
		var rule: Dictionary = unlocks.get(conversation_id, {})
		_expect(not rule.has("after_conversation_completed"), "K: cross-day completion gate remains for %s" % conversation_id)
		_expect(phone._unlock_rule_ready(9, conversation_id, initial_ids), "K: day 9 unlock rule is not phase-ready for %s" % conversation_id)

func _scenario_l(phone) -> void:
	phone._unlock_conversation(9, "chapter_09_mathilde_visual_boundary")
	phone._show_history_day(9)
	var threads: Array = phone._collect_day_threads(9)
	_expect(not threads.is_empty(), "L: no history thread available")
	if threads.is_empty():
		return
	phone._open_history_conversation(9, threads.front())
	_expect(phone.phone_mode == "HISTORY", "L: opening archive left history mode")
	_expect(phone.conversation_view.visible, "L: archive thread is not visible")
	_expect(str(phone.conversation_view.active_conversation_id).begins_with("archive::9::"), "L: history did not use read-only archive rendering")

func _scenario_m(phone) -> void:
	var mathilde := _thread_by_id(phone, "thread_mathilde_private")
	if mathilde.is_empty():
		for conversation in DataLoader.get_conversations_for_day(9):
			if typeof(conversation) != TYPE_DICTIONARY:
				continue
			if str(conversation.get("thread_id", "")) == "thread_mathilde_private" or str(conversation.get("id", "")) == "thread_mathilde_private":
				mathilde = conversation
				break
	_expect(not mathilde.is_empty(), "M: Mathilde thread missing")
	if mathilde.is_empty():
		return
	phone._open_conversation(9, mathilde)
	phone._show_contacts()
	phone._show_conversation_notification(9, "chapter_09_sandra_visual_boundary", "Sandra", "Je dois déplacer notre déjeuner.")
	_expect(phone.notification_banner.visible, "M: phone banner is not visible from Contacts")
	if is_instance_valid(phone.conversation_view.thread_notification_panel):
		_expect(not phone.conversation_view.thread_notification_panel.visible, "M: notification was sent to a hidden thread banner")

func _scenario_n(phone) -> void:
	phone._show_contacts()
	_expect(phone.landing_panel.visible, "N: contacts landing must start visible")
	phone._show_gallery()
	_expect(not phone.landing_panel.visible, "N: gallery did not hide Messages landing")
	_expect(phone.photo_gallery_view.visible, "N: gallery is not visible")

func _scenario_o(phone) -> void:
	var historical: Dictionary = {}
	for conversation in phone._collect_global_threads():
		if int(conversation.get("_source_day_value", 9)) != 9:
			historical = conversation
			break
	_expect(not historical.is_empty(), "O: no historical contact available")
	if historical.is_empty():
		return
	var source_day := int(historical.get("_source_day_value", 1))
	phone._open_conversation(source_day, historical)
	_expect(str(phone.conversation_view.active_conversation_id).begins_with("archive::"), "O: historical contact opened as an active thread")
	_expect(TimelineState.is_current_day(9), "O: historical contact changed the narrative day")
	_expect(int(phone.current_day_value) == 9, "O: historical contact changed the phone current day")

func _scenario_p(phone) -> void:
	var mathilde := _thread_by_id(phone, "thread_mathilde_private")
	_expect(not mathilde.is_empty(), "P: Mathilde actionable thread missing")
	if mathilde.is_empty():
		return
	_expect(phone._is_contact_actionable(mathilde), "P: current unfinished thread is not actionable")
	_expect(phone._conversation_status_text(mathilde) in ["Nouveau", "À poursuivre"], "P: actionable status is unclear")
	_expect(phone._conversation_has_activity_badge(mathilde), "P: actionable thread has no badge")
	TimelineState.record_episode_completed(9, "chapter_09_mathilde_visual_boundary")
	var completed := _thread_by_id(phone, "thread_mathilde_private")
	_expect(not completed.is_empty(), "P: completed Mathilde thread disappeared")
	if completed.is_empty():
		return
	_expect(not phone._is_contact_actionable(completed), "P: completed thread remains actionable")
	_expect(not phone._conversation_has_activity_badge(completed), "P: completed thread keeps a misleading badge")

func _scenario_q(phone) -> void:
	var mathilde := _thread_by_id(phone, "thread_mathilde_private")
	_expect(not mathilde.is_empty(), "Q: Mathilde thread missing")
	if mathilde.is_empty():
		return
	phone._open_conversation(9, mathilde)
	var view = phone.conversation_view
	view.active_state["sequence_complete"] = true
	view._show_completion_controls()
	var button := view.choice_area.get_node_or_null("CompletedReturnToContactsButton")
	_expect(button != null, "Q: completed conversation has no return button")
	if button == null:
		return
	phone.phone_mode = "HISTORY"
	button.pressed.emit()
	_expect(phone.phone_mode == "CONTACTS", "Q: completed return button did not restore Contacts")
