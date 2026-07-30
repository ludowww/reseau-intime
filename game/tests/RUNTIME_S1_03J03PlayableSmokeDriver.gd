extends Node

const MAIN_SCENE := preload("res://scenes/portrait/PortraitMain.tscn")
const SEASON_PROVIDER := preload("res://scripts/runtime/season_1/Season1RuntimeProvider.gd")
const RAPH_SOURCE := "res://data/conversations/chapter_03_raphaelle_blue_folder.json"
const SANDRA_SOURCE := "res://data/conversations/chapter_03_sandra_continuity.json"
const MARIE_SOURCE := "res://data/conversations/chapter_03_marie_evening_return.json"
const GARMENT_TEXT := "À la fin du point, Raphaëlle referme le dossier bleu, range son carnet et récupère une housse à vêtements fermée près de son poste.\nElle n’en fait pas un sujet. Player remarque seulement que sa journée ne s’arrête pas au dossier."
const MARIE_BEATS := {
	"ACTIVE": ["j3_shared_evening_active", "19:05 — Player rentre à l'heure avec quelque chose de croustillant pour sauver la soupe. Marie et Mathilde ont sorti trois bols pour deux personnes, puis prétendent toutes les deux que c'est normal. Ils mangent ensemble. Le téléphone reste posé."],
	"BOUNDED": ["j3_shared_evening_bounded", "19:35 — Player rentre à 19 h 30 comme annoncé. Marie a attendu avant de réchauffer la soupe. Mathilde a mangé un morceau de pain en prétendant que cela ne comptait pas. Le retard existe. La parole tenue aussi."],
	"DRIFT": ["j3_shared_evening_drift", "20:30 — Marie et Mathilde mangent sans attendre davantage. Quand Player rentre, la soupe est encore au frigo pour lui et les deux bols sont dans l'évier. Personne ne transforme cela en grande scène. La soirée a simplement continué sans lui."],
}
const RAPH_ASSETS := ["S1_A1_J03_SCN_RAPHAELLE_ACCESSIBILITY_REVIEW_01", "S1_A1_J03_SCN_RAPHAELLE_GARMENT_BAG_01"]
const MARIE_ASSET := "S1_A1_J03_SCN_MARIE_HOME_FROM_LAVERRIERE_01"
const J02_ASSETS := ["S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01", "S1_A1_J02_SCN_MARIE_HOLDS_HOUSEHOLD_01", "S1_A1_J02_SCN_FIRST_SHARED_EVENING_01"]
var failures: Array[String] = []

func _ready() -> void: call_deferred("_run")

func _run() -> void:
	get_window().size = _parse_size(_arg("--runtime-size", "720x1280"))
	await _test_real_ui()
	await _test_sandra_secondary_real_button_ui()
	_test_exact_dialogue_and_state_variants()
	_test_sandra_paths()
	_test_marie_paths_and_records()
	_test_snapshots_with_continuation()
	_test_invalid_j03_phase()
	_finish()

func _test_real_ui() -> void:
	var main = MAIN_SCENE.instantiate(); add_child(main); await _frames(4)
	main.shell.set_reduced_motion_enabled(true)
	var messages = main.shell.messages_screen
	var provider = main.shell.runtime_provider
	messages.runtime_delivery_time_scale = 0.01
	_expect(provider.active_day == "J01", "J03 inaccessible before earlier days")
	_expect(messages._thread_for("thread_raphaelle_private").is_empty(), "Raphaëlle visible before J03")
	await _play_j01_ui(messages)
	_expect(provider.active_day == "J02" and not messages.day_transition.visible, "automatic J01 to J02 handoff missing")
	await _play_j02_ui(messages)
	var cumulative: Dictionary = provider.j02_provider.transcripts_by_thread.duplicate(true)
	_expect(provider.active_day == "J03" and not messages.day_transition.visible, "automatic J02 to J03 handoff missing")
	_expect(provider.state.current_day == "J03" and provider.state.day_status == "ACTIVE", "J03 automatic state start")
	for thread_id in cumulative:
		_expect(provider.j03_provider.transcripts_by_thread.get(thread_id, []).slice(0, cumulative[thread_id].size()) == cumulative[thread_id], "J01-J02 transcript changed: " + thread_id)
	var unlocked: Array = provider.j03_provider.unlocked_thread_ids.duplicate(); unlocked.sort()
	_expect(unlocked == ["thread_marie_private", "thread_mathilde_private", "thread_raphaelle_private", "thread_sandra_private"], "cumulative thread presence")
	_expect(messages.screen_mode == "list", "J03 must return to list")
	var focused_raphaelle := false
	for index in range(messages.conversation_list.threads.size()):
		if messages.conversation_list.threads[index].get("thread_id", "") == "thread_raphaelle_private": focused_raphaelle = messages.conversation_list.cards[index].has_focus()
	_expect(focused_raphaelle, "J03 list focus Raphaëlle")
	var raphaelle_thread: Dictionary = messages._thread_for("thread_raphaelle_private")
	_expect(not raphaelle_thread.is_empty(), "Raphaëlle thread missing")
	_expect(raphaelle_thread.get("participant_ids", []) == ["raphaelle", "player"], "Raphaëlle participant IDs")
	_expect(raphaelle_thread.get("title", "") == "Raphaëlle", "Raphaëlle visible title keeps accent")
	_expect(messages.thread_has_unread_content("thread_raphaelle_private"), "J03 Raphaëlle initial incoming lot must be unread after NEW_DAY")
	_expect(_card_is_strong_unread(messages, "thread_raphaelle_private"), "J03 Raphaëlle initial card must use strong primary unread styling")
	await _open(messages, "thread_raphaelle_private"); await _frames(2)
	_expect(not messages.thread_has_unread_content("thread_raphaelle_private"), "J03 Raphaëlle becomes read only after full presentation")
	_expect(_card_is_restored_read(messages, "thread_raphaelle_private"), "J03 Raphaëlle card restores its real secondary preview")
	messages.start_typing("thread_raphaelle_private", "raphaelle"); await _frames(2)
	_expect(messages.is_thread_typing("thread_raphaelle_private"), "Raphaëlle thread typing state")
	_expect(messages.conversation_screen.typing_visible(), "Raphaëlle typing indicator visible")
	messages.stop_typing("thread_raphaelle_private"); await _frames(2)
	_expect(not messages.is_thread_typing("thread_raphaelle_private"), "Raphaëlle thread typing did not stop")
	_expect(not messages.conversation_screen.typing_visible(), "Raphaëlle typing indicator did not disappear")
	await _choose(messages, "choice_thu_raph_method_guided")
	_expect(_ui_choices(messages) == _source_choices(RAPH_SOURCE, 1), "Raphaëlle exact three UI choices")
	await _choose_twice(messages, "choice_thu_raph_accountable"); await _frames(2)
	_expect(provider.presentation_count_by_id("j03_raphaelle_garment_bag_beat") == 1, "garment beat unique")
	await _wait_clock_transition(messages)
	_assert_card(messages, {"eyebrow": "JEUDI — DÉBUT D’APRÈS-MIDI", "title": "13:50", "subtitle": "Sandra vient de terminer son poste du matin.", "body": "Un message bref attend dans son fil. Rien n’oblige Player à le rouvrir.", "action_label": "Ouvrir Sandra", "secondary_action_label": "Continuer la journée", "transition_mode": "clock_then_card", "to_time": "13:50", "duration_seconds": 4.0}, 2, "Sandra offer")
	_expect(messages.day_transition.action_has_focus(), "Sandra primary focus")
	_expect(messages.day_transition.continue_button.mouse_filter == Control.MOUSE_FILTER_STOP and messages.day_transition.secondary_button.mouse_filter == Control.MOUSE_FILTER_STOP and not messages.day_transition.continue_button.disabled and not messages.day_transition.secondary_button.disabled, "Sandra mouse actions available")
	_expect(not _control_tree_cropped(messages.day_transition), "Sandra card actual crop")
	await _keyboard_activate(messages.day_transition.continue_button)
	await _wait_runtime_delivery_complete(messages)
	_expect(messages.active_thread_id == "thread_sandra_private", "Sandra keyboard primary action")
	_expect(_ui_choices(messages) == _source_choices(SANDRA_SOURCE, 0), "Sandra sole exact UI choice")
	await _choose(messages, "choice_thu_sandra_day_saved"); await _frames(2)
	_expect(not messages.day_transition.visible, "Marie 18:20 informational card removed")
	await _wait_runtime_delivery_complete(messages); await _frames(2)
	_expect(messages.active_thread_id == "thread_marie_private", "Marie return did not open")
	await _choose(messages, "choice_j3_marie_evening_why_guided")
	_expect(_ui_choices(messages) == _source_choices(MARIE_SOURCE, 1), "Marie exact three UI choices")
	await _choose(messages, "choice_j3_marie_return_active"); await _frames(2)
	_expect(provider.presentation_count_by_id("j3_shared_evening_active") == 1, "ACTIVE exact UI beat")
	_expect(provider.active_day == "J04" and provider.state.current_day == "J04", "J03 hands off automatically to J04")
	_expect(not messages.day_transition.visible and messages.screen_mode == "list", "no obsolete J03 CONTENT_END card")
	_expect(not messages.describe_state().get("has_horizontal_crop", true), "portrait screen crop")
	_expect(JSON.stringify(provider.snapshot()).contains("J04"), "J04 snapshot included after handoff")
	main.queue_free(); await _frames(2)

func _test_sandra_secondary_real_button_ui() -> void:
	var main = MAIN_SCENE.instantiate(); add_child(main); await _frames(4)
	main.shell.set_reduced_motion_enabled(true)
	var messages = main.shell.messages_screen; var provider = main.shell.runtime_provider
	messages.runtime_delivery_time_scale = 0.01
	await _play_j01_ui(messages)
	await _play_j02_ui(messages)
	await _open(messages, "thread_raphaelle_private"); await _choose(messages, "choice_thu_raph_method_guided"); await _choose(messages, "choice_thu_raph_accountable"); await _frames(2)
	await _wait_clock_transition(messages)
	_expect(messages.day_transition.secondary_button != null and messages.day_transition.secondary_button.mouse_filter == Control.MOUSE_FILTER_STOP, "Sandra real secondary mouse button")
	messages.day_transition.secondary_button.emit_signal("pressed"); await _wait_clock_transition(messages)
	await _wait_runtime_delivery_complete(messages)
	_expect(provider.state.sandra_j03_echo_outcome == "EXPIRED" and messages.active_thread_id == "thread_marie_private" and not messages.day_transition.visible, "Sandra real secondary button action")
	_expect(provider.presentation_count_by_id("msg_thu_sandra_001") == 0, "Sandra secondary UI injected message")
	main.queue_free(); await _frames(2)

func _test_exact_dialogue_and_state_variants() -> void:
	var variants := [["choice_thu_raph_accountable", "ACCOUNTABLE"], ["choice_thu_raph_playful", "DRY_HUMOR"], ["choice_thu_raph_delay", "DELAYED"]]
	for variant in variants:
		var season = _season_at_j03(true)
		var promises: Dictionary = season.state.promises.duplicate(true)
		var traces: Dictionary = season.state.traces.duplicate(true)
		_assert_and_play_source(season, RAPH_SOURCE, "thread_raphaelle_private", ["choice_thu_raph_method_guided", variant[0]])
		_expect(season.state.raphaelle_state == "PROFESSIONAL_ONLY" and season.state.raphaelle_work_outcome == variant[1], "Raphaëlle state %s" % variant[1])
		_expect(season.state.promises == promises and season.state.traces == traces, "Raphaëlle created promise/trace")
		_expect(not bool(season.apply_choice("thread_raphaelle_private", variant[0]).get("accepted", false)), "duplicate Raphaëlle choice accepted")
		_expect(season.presentation_count_by_id(str(variant[0]) + "_player") == 1, "double Raphaëlle Player bubble")
		var f05: Dictionary = season.state.knowledge.get("fact_raphaelle_professional_relationship_exists", {})
		_expect(f05 == {"fact_id": "fact_raphaelle_professional_relationship_exists", "source_type": "DIRECT_OBSERVATION", "source_ref": "chapter_03_raphaelle_blue_folder", "certainty": "CONFIRMED", "initial_knowers": ["Player", "Raphaëlle"]}, "F05 complete exact record")
		var beat := _message(season, "thread_raphaelle_private", "j03_raphaelle_garment_bag_beat")
		_expect(beat.get("content_type") == "OFF_PHONE_TRANSITION" and beat.get("text") == GARMENT_TEXT and beat.get("author_id") == "system", "Raphaëlle beat exact/type/no speech")
		_expect(season.presentation_count_by_id("j03_raphaelle_garment_bag_beat") == 1, "Raphaëlle beat not unique")
		_expect(_j03_content_type_count(season, "IMAGE") == 0, "J03 IMAGE presentation")
		_expect(_j03_content_type_count(season, "AUDIO") == 0, "J03 oral presentation")
		season.confirm_transition()
		_expect(season.j03_provider.gallery_asset_ids.slice(3) == RAPH_ASSETS, "Raphaëlle gallery IDs/order")
		_assert_gallery(season, false)

func _card_is_strong_unread(messages, thread_id: String) -> bool:
	var view: Dictionary = messages.conversation_list.card_views.get(thread_id, {})
	if view.is_empty(): return false
	var name: Label = view.get("display_name")
	var preview: Label = view.get("preview")
	var name_font: Font = name.get_theme_font("font")
	var preview_font: Font = preview.get_theme_font("font")
	return preview.text == "Nouveau message !" and name.get_theme_color("font_color") == messages.PORTRAIT_THEME.TEXT_PRIMARY and preview.get_theme_color("font_color") == messages.PORTRAIT_THEME.TEXT_PRIMARY and name_font is FontVariation and preview_font is FontVariation and is_equal_approx(name_font.variation_embolden, 1.5) and is_equal_approx(preview_font.variation_embolden, 1.5)

func _card_is_restored_read(messages, thread_id: String) -> bool:
	var view: Dictionary = messages.conversation_list.card_views.get(thread_id, {})
	var thread: Dictionary = messages._thread_for(thread_id)
	if view.is_empty() or thread.is_empty(): return false
	var name: Label = view.get("display_name")
	var preview: Label = view.get("preview")
	return preview.text == str(thread.get("last_preview", "")) and preview.get_theme_color("font_color") == messages.PORTRAIT_THEME.TEXT_SECONDARY and not name.has_theme_font_override("font") and not preview.has_theme_font_override("font")

func _test_sandra_paths() -> void:
	# RESPONDED: source dialogue, T01, traces and promises are byte-for-byte stable.
	var responded = _season_on_sandra_offer(true)
	var t01: Dictionary = responded.state.traces["j01_sandra_lunch_memory_soft"].duplicate(true)
	var traces: Dictionary = responded.state.traces.duplicate(true); var promises: Dictionary = responded.state.promises.duplicate(true)
	responded.confirm_day_transition()
	_assert_and_play_source(responded, SANDRA_SOURCE, "thread_sandra_private", ["choice_thu_sandra_day_saved"])
	_expect(responded.state.sandra_j03_echo_outcome == "RESPONDED", "RESPONDED missing")
	_assert_sandra_unchanged(responded, t01, traces, promises, "RESPONDED")
	# EXPIRED: use the real secondary Button signal path on a real MessagesScreen in the main smoke; provider result proves no injection.
	var expired = _season_on_sandra_offer(true)
	t01 = expired.state.traces["j01_sandra_lunch_memory_soft"].duplicate(true); traces = expired.state.traces.duplicate(true); promises = expired.state.promises.duplicate(true)
	var before_sandra := _day3_text_count(expired, "thread_sandra_private")
	var result: Dictionary = expired.confirm_secondary_day_transition()
	_expect(bool(result.get("accepted", false)) and expired.state.sandra_j03_echo_outcome == "EXPIRED", "EXPIRED missing")
	_expect(_day3_text_count(expired, "thread_sandra_private") == before_sandra, "Sandra injected/bubbled on EXPIRED")
	_assert_sandra_unchanged(expired, t01, traces, promises, "EXPIRED")
	# UNAVAILABLE from DISTANT_FRIEND.
	var unavailable = _season_on_sandra_offer(false)
	t01 = unavailable.state.traces["j01_sandra_lunch_memory_soft"].duplicate(true); traces = unavailable.state.traces.duplicate(true); promises = unavailable.state.promises.duplicate(true)
	_expect(unavailable.state.sandra_j03_echo_outcome == "UNAVAILABLE" and unavailable.j03_provider.phase == "marie_time_card", "UNAVAILABLE path")
	_expect(_day3_text_count(unavailable, "thread_sandra_private") == 0, "Sandra injected on UNAVAILABLE")
	_assert_sandra_unchanged(unavailable, t01, traces, promises, "UNAVAILABLE")

func _test_marie_paths_and_records() -> void:
	var variants := [["choice_j3_marie_return_active", "ACTIVE"], ["choice_j3_marie_return_bounded", "BOUNDED"], ["choice_j3_marie_return_drift", "DRIFT"]]
	for variant in variants:
		var season = _season_before_marie()
		var promises: Dictionary = season.state.promises.duplicate(true)
		season.confirm_day_transition()
		_assert_and_play_source(season, MARIE_SOURCE, "thread_marie_private", ["choice_j3_marie_evening_why_guided", variant[0]])
		_expect(season.state.marie_j03_return_outcome == variant[1], "Marie outcome %s" % variant[1])
		var beat_id: String = MARIE_BEATS[variant[1]][0]; var beat_text: String = MARIE_BEATS[variant[1]][1]
		var beat := _message(season, "thread_marie_private", beat_id)
		_expect(beat.get("text") == beat_text and beat.get("content_type") == "OFF_PHONE_TRANSITION" and season.presentation_count_by_id(beat_id) == 1, "Marie exact unique beat %s" % variant[1])
		season.confirm_transition()
		_expect(season.state.promises == promises, "J03 created PromiseState %s" % variant[1])
		var t03: Dictionary = season.state.traces.get("j03_marie_laverriere_setup_01", {})
		_expect(t03 == {"trace_id": "j03_marie_laverriere_setup_01", "trace_type": "FACT_RECORD", "source_day": "J03", "source_scene": "vie professionnelle Marie établie", "creator": "none", "subjects": ["Marie"], "owner": "état narratif La Verrière", "saving_rule": "NONE", "transfer_rule": "FORBIDDEN", "current_state": "ACTIVE"}, "T03 complete exact")
		var f04: Dictionary = season.state.knowledge.get("fact_marie_laverriere_world_exists", {})
		_expect(f04 == {"fact_id": "fact_marie_laverriere_world_exists", "source_type": "DIRECT_OBSERVATION", "source_ref": "j03_marie_laverriere_setup_01", "certainty": "CONFIRMED", "initial_knowers": ["Marie", "Player"]}, "F04 complete exact")
		_expect(season.state.day_status == "COMPLETE" and season.state.current_day == "J03", "J03 complete state")
		_expect(season.j03_provider.gallery_asset_ids.count(MARIE_ASSET) == 1, "Marie gallery duplicated/missing")
		_assert_gallery(season, true)
		_expect(_j03_content_type_count(season, "IMAGE") == 0, "J03 IMAGE after completion")
		_expect(season.j03_provider.conversations.keys() == ["chapter_03_raphaelle_blue_folder", "chapter_03_sandra_continuity", "chapter_03_marie_evening_return"], "unauthorized J03 source loaded")

func _test_snapshots_with_continuation() -> void:
	# Point 1: during Raphaëlle; continue through the beat after restoration.
	var season = _season_at_j03(true); season.apply_choice("thread_raphaelle_private", "choice_thu_raph_method_guided")
	var restored = _restore_exact(season.snapshot(), "snapshot during Raphaëlle")
	restored.apply_choice("thread_raphaelle_private", "choice_thu_raph_playful")
	_expect(restored.presentation_count_by_id("choice_thu_raph_playful_player") == 1 and restored.presentation_count_by_id("j03_raphaelle_garment_bag_beat") == 1, "Raphaëlle restore replay/continuation")
	restored.confirm_transition()
	# Point 2: Sandra card; skip after restoration.
	restored = _restore_exact(restored.snapshot(), "snapshot on Sandra card")
	restored.confirm_secondary_day_transition()
	_expect(restored.state.sandra_j03_echo_outcome == "EXPIRED" and restored.presentation_count_by_id("msg_thu_sandra_001") == 0, "Sandra card restore continuation")
	# Point 3: before Marie; continue to full completion after restoration.
	restored = _restore_exact(restored.snapshot(), "snapshot before Marie")
	restored.confirm_day_transition(); restored.apply_choice("thread_marie_private", "choice_j3_marie_evening_why_guided"); restored.apply_choice("thread_marie_private", "choice_j3_marie_return_bounded"); restored.confirm_transition()
	_expect(restored.presentation_count_by_id("j3_shared_evening_bounded") == 1 and restored.j03_provider.gallery_asset_ids.size() == 6, "Marie restore replay/duplication")
	# Point 4: completed J03 remains exact and hands off once to J04.
	var complete = _restore_exact(restored.snapshot(), "snapshot after J03")
	_expect(bool(complete.confirm_day_transition().get("accepted", false)) and complete.active_day == "J04", "completed J03 restore handoff")

func _test_invalid_j03_phase() -> void:
	var season = _season_at_j03(true)
	var snapshot: Dictionary = season.snapshot()
	snapshot["provider_snapshots"]["J03"]["phase"] = "future_generic_phase"
	var restored = SEASON_PROVIDER.new(); restored.initialize()
	_expect(not restored.restore_snapshot(snapshot), "unknown restored J03 phase accepted")

func _restore_exact(snapshot: Dictionary, label: String):
	_expect(int(snapshot.get("version", 0)) == 6 and snapshot.keys() == ["version", "active_day", "state", "provider_snapshots"], label + " v6 shape")
	var restored = SEASON_PROVIDER.new(); _expect(restored.initialize(), label + " initialize")
	_expect(restored.restore_snapshot(snapshot), label + " restore")
	_expect(restored.state_restore_count == 1, label + " Season1State restore count")
	_expect(restored.snapshot() == snapshot, label + " exact round trip")
	return restored

func _assert_and_play_source(season, path: String, thread_id: String, selected_ids: Array) -> void:
	var source: Dictionary = DataLoader.load_json(path)
	var expected: Array = []
	for segment_index in range(source.get("segments", []).size()):
		var segment: Dictionary = source["segments"][segment_index]
		for message in segment.get("messages", []): expected.append(_normalized_source_message(message, false))
		var expected_choices: Array = []
		for choice in segment.get("choices", []): expected_choices.append({"choice_id": str(choice["id"]), "text": str(choice["text"]), "enabled": true, "confirmation_required": false})
		_expect(season.j03_provider.choices_for(thread_id) == expected_choices, "%s segment %d exact choices" % [source["id"], segment_index])
		var selected_id: String = selected_ids[segment_index]
		var selected: Dictionary = {}
		for choice in segment.get("choices", []):
			if str(choice["id"]) == selected_id: selected = choice
		_expect(not selected.is_empty(), "%s selected choice exists" % selected_id)
		expected.append({"message_id": selected_id + "_player", "author_id": "player", "timestamp": season.current_narrative_time_text(), "content_type": "TEXT", "text": str(selected.get("text", "")), "is_player": true, "source_day": 3})
		for message in selected.get("next_messages", []): expected.append(_normalized_source_message(message, false))
		_expect(bool(season.apply_choice(thread_id, selected_id).get("accepted", false)), "%s accepted" % selected_id)
	var actual: Array = []
	for item in season.j03_provider.transcript_for(thread_id):
		if int(item.get("source_day", 0)) == 3 and str(item.get("content_type", "")) == "TEXT": actual.append(_normalized_runtime_message(item))
	_expect(actual == expected, "%s exact messages/choices from authorized JSON" % source["id"])

func _normalized_source_message(message: Dictionary, is_player: bool) -> Dictionary:
	return {"message_id": str(message["id"]), "author_id": str(message["sender"]), "timestamp": str(message["time_label"]), "content_type": "TEXT", "text": str(message["text"]), "is_player": is_player, "source_day": 3}
func _normalized_runtime_message(item: Dictionary) -> Dictionary:
	return {"message_id": str(item.get("message_id", "")), "author_id": str(item.get("author_id", "")), "timestamp": str(item.get("timestamp", "")), "content_type": str(item.get("content_type", "")), "text": str(item.get("text", "")), "is_player": bool(item.get("is_player", false)), "source_day": int(item.get("source_day", 0))}

func _assert_sandra_unchanged(season, t01: Dictionary, traces: Dictionary, promises: Dictionary, label: String) -> void:
	_expect(season.state.traces["j01_sandra_lunch_memory_soft"] == t01, "T01 strictly changed on " + label)
	_expect(season.state.traces == traces, "Sandra trace created on " + label)
	_expect(season.state.promises == promises, "Sandra promise created on " + label)
	_expect(season.state.sandra_state == ("RECONNECTION_OPEN" if label != "UNAVAILABLE" else "DISTANT_FRIEND"), "Sandra state changed on " + label)

func _assert_gallery(season, completed: bool) -> void:
	var expected_ids: Array = J02_ASSETS + RAPH_ASSETS + ([MARIE_ASSET] if completed else [])
	_expect(season.j03_provider.gallery_asset_ids == expected_ids, "gallery cumulative IDs/order")
	var unique := {}; for id in season.j03_provider.gallery_asset_ids: unique[id] = true
	_expect(unique.size() == season.j03_provider.gallery_asset_ids.size(), "gallery asset IDs duplicated")
	var source: Dictionary = season.gallery_source()
	_expect(source.get("character_order") == ["marie", "sandra", "mathilde", "raphaelle"], "gallery tab order")
	var found := {}
	for character_id in source.get("fixtures", {}):
		for item in source["fixtures"][character_id].get("items", []):
			var id := str(item.get("asset_id", "")); found[id] = int(found.get(id, 0)) + 1
			_expect(item.get("placeholder_label") == "Visuel non produit" and item.get("source_kind") == "gallery" and item.get("content_type") == "SCENE_IMAGE" and not item.get("can_share", true) and item.get("transfer_rule") == "FORBIDDEN" and not item.get("is_diegetic", true), "gallery metadata " + id)
	for id in expected_ids: _expect(found.has(id), "gallery missing " + id)
	_expect(int(found.get("S1_A1_J02_SCN_FIRST_SHARED_EVENING_01", 0)) == 2, "J02 shared presentation conservation")
	_expect(not found.has("S1_A1_J03_SCN_SANDRA"), "new Sandra gallery image")

func _assert_card(messages, expected: Dictionary, count: int, label: String) -> void:
	var card = messages.day_transition
	_expect(card.eyebrow_text == expected.get("eyebrow", "") and card.display_title() == expected.get("title", "") and card.display_subtitle() == expected.get("subtitle", "") and card.body_text == expected.get("body", "") and card.continue_button.text == expected.get("action_label", ""), label + " exact card")
	_expect(card.action_count() == count, label + " action count")
	if count == 2: _expect(card.secondary_button != null and card.secondary_button.text == expected.get("secondary_action_label", ""), label + " secondary exact")
	_expect(not _control_tree_cropped(card), label + " actual crop")
func _assert_old_card(messages, label: String) -> void: _assert_card(messages, {"eyebrow": messages.day_transition.eyebrow_text, "title": messages.day_transition.display_title(), "subtitle": messages.day_transition.display_subtitle(), "body": messages.day_transition.body_text, "action_label": messages.day_transition.continue_button.text}, 1, label)
func _control_tree_cropped(root: Control) -> bool:
	var bounds := root.get_global_rect()
	for child in root.find_children("*", "Control", true, false):
		if child is Control and child.visible:
			var rect: Rect2 = child.get_global_rect()
			if rect.position.x < bounds.position.x - 1.0 or rect.end.x > bounds.end.x + 1.0 or rect.position.y < bounds.position.y - 1.0 or rect.end.y > bounds.end.y + 1.0: return true
	return false

func _season_on_sandra_offer(reconnect: bool):
	var season = _season_at_j03(reconnect)
	season.apply_choice("thread_raphaelle_private", "choice_thu_raph_method_guided"); season.apply_choice("thread_raphaelle_private", "choice_thu_raph_accountable"); season.confirm_transition()
	return season
func _season_before_marie():
	var season = _season_on_sandra_offer(false)
	return season
func _season_at_j03(reconnect: bool):
	var season = SEASON_PROVIDER.new(); _expect(season.initialize(), "season initialize")
	_play_j01_provider(season, reconnect)
	season.confirm_day_transition(); season.confirm_day_transition()
	_play_j02_provider(season)
	_expect(season.active_day == "J02", "provider J03 inaccessible before Terminer")
	season.confirm_day_transition()
	_expect(season.active_day == "J03" and season.state.current_day == "J02", "provider J03 handoff card before start")
	season.confirm_day_transition()
	return season
func _play_j01_provider(season, reconnect: bool) -> void:
	for id in ["choice_j1_marie_optimism_guided", "choice_j1_marie_crisis_guided", "choice_j1_marie_present", "choice_j1_marie_laverriere_guided", "choice_j1_marie_mathilde_guided"]: season.apply_choice("thread_marie_private", id)
	season.confirm_transition()
	for id in ["choice_j1_sandra_what_guided", "choice_j1_sandra_art_guided", "choice_j1_sandra_safe_warmth" if reconnect else "choice_j1_sandra_cautious", "choice_j1_sandra_thanks_guided", "choice_j1_sandra_goodnight_guided"]: season.apply_choice("thread_sandra_private", id)
	season.confirm_transition()
func _play_j02_provider(season) -> void:
	season.apply_choice("thread_marie_private", "choice_wed_marie_emergency_guided"); season.apply_choice("thread_marie_private", "choice_wed_make_room_proactive")
	season.confirm_day_transition(); season.on_thread_returned("thread_marie_private"); season.confirm_day_transition()
	season.apply_choice("thread_mathilde_private", "choice_wed_mathilde_practical"); season.confirm_transition()
func _play_j01_ui(messages) -> void:
	await _open(messages, "thread_marie_private")
	for id in ["choice_j1_marie_optimism_guided", "choice_j1_marie_crisis_guided", "choice_j1_marie_present", "choice_j1_marie_laverriere_guided", "choice_j1_marie_mathilde_guided"]: await _choose(messages, id)
	await _frames(2)
	await _open(messages, "thread_sandra_private")
	for id in ["choice_j1_sandra_what_guided", "choice_j1_sandra_art_guided", "choice_j1_sandra_safe_warmth", "choice_j1_sandra_thanks_guided", "choice_j1_sandra_goodnight_guided"]: await _choose(messages, id)
	await _frames(2)
func _play_j02_ui(messages) -> void:
	await _open(messages, "thread_marie_private"); await _choose(messages, "choice_wed_marie_emergency_guided"); await _choose(messages, "choice_wed_make_room_proactive")
	_expect(not messages.day_transition.visible and messages.runtime_provider.current_narrative_time_minutes() >= 1098, "J02 18:18 clock_only")
	messages.conversation_screen.back_button.emit_signal("pressed"); await _wait_clock_transition(messages)
	_expect(not messages.day_transition.visible and messages.runtime_provider.current_narrative_time_text() == "18:22", "J02 18:22 clock_only")
	await _open(messages, "thread_mathilde_private"); await _choose(messages, "choice_wed_mathilde_practical"); await _frames(2)

func _source_choices(path: String, segment: int) -> Array:
	var result: Array = []; var source: Dictionary = DataLoader.load_json(path)
	for choice in source["segments"][segment].get("choices", []): result.append({"choice_id": str(choice["id"]), "text": str(choice["text"]), "enabled": true, "confirmation_required": false})
	return result
func _ui_choices(messages) -> Array: return messages.available_choices.get(messages.active_thread_id, [])
func _message(season, thread_id: String, id: String) -> Dictionary:
	for item in season.j03_provider.transcript_for(thread_id):
		if str(item.get("message_id", "")) == id: return item
	return {}
func _j03_content_type_count(season, kind: String) -> int:
	var count := 0
	for thread in season.j03_provider.transcripts_by_thread:
		for item in season.j03_provider.transcripts_by_thread[thread]:
			if int(item.get("source_day", 0)) == 3 and str(item.get("content_type", "")) == kind: count += 1
	return count
func _day3_text_count(season, thread: String) -> int:
	var count := 0
	for item in season.j03_provider.transcript_for(thread):
		if int(item.get("source_day", 0)) == 3 and str(item.get("content_type", "")) == "TEXT": count += 1
	return count
func _transcript_sizes(transcripts: Dictionary) -> Dictionary:
	var result := {}; for id in transcripts: result[id] = transcripts[id].size()
	return result
func _choose(messages, id: String) -> void:
	for index in range(messages.available_choices.get(messages.active_thread_id, []).size()):
		if messages.available_choices[messages.active_thread_id][index].get("choice_id", "") == id:
			if index >= messages.conversation_screen.choice_bar.buttons.size():
				_expect(false, "choice model/render mismatch: " + id)
				return
			messages.conversation_screen.choice_bar.buttons[index].emit_signal("pressed")
			await _wait_runtime_delivery_complete(messages)
			return
	_expect(false, "choice unavailable: " + id)
func _choose_twice(messages, id: String) -> void:
	var before: int = messages.thread_player_message_count(messages.active_thread_id)
	for index in range(messages.available_choices.get(messages.active_thread_id, []).size()):
		if messages.available_choices[messages.active_thread_id][index].get("choice_id", "") == id:
			var button = messages.conversation_screen.choice_bar.buttons[index]; button.emit_signal("pressed"); button.emit_signal("pressed"); break
	_expect(messages.thread_player_message_count(messages.active_thread_id) == before + 1, "double click duplicated Player bubble")
	await _wait_runtime_delivery_complete(messages)
func _wait_runtime_delivery_complete(messages) -> void:
	await get_tree().process_frame
	for _index in range(600):
		if not messages.runtime_delivery_active and messages.runtime_delivery_queue.is_empty() and not messages.conversation_screen.typing_visible(): return
		await get_tree().create_timer(0.01).timeout
	_expect(false, "runtime delivery timed out")
func _wait_clock_transition(messages) -> void:
	await get_tree().process_frame
	for _index in range(600):
		if not messages.narrative_clock_animation_active: return
		await get_tree().create_timer(0.01).timeout
	_expect(false, "narrative clock transition timed out")
func _open(messages, id: String) -> void:
	for index in range(messages.conversation_list.threads.size()):
		if messages.conversation_list.threads[index].get("thread_id", "") == id:
			messages.conversation_list.cards[index].emit_signal("pressed")
			await _wait_runtime_delivery_complete(messages)
			return
	_expect(false, "thread unavailable: " + id)
func _keyboard_activate(button: Button) -> void:
	button.grab_focus(); await _frames(1)
	var event := InputEventAction.new(); event.action = "ui_accept"; event.pressed = true; Input.parse_input_event(event); await _frames(1); event = event.duplicate(); event.pressed = false; Input.parse_input_event(event); await _frames(2)
func _frames(count: int) -> void:
	for _i in range(count): await get_tree().process_frame
func _arg(prefix: String, fallback: String) -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(prefix + "="): return arg.trim_prefix(prefix + "=")
	return fallback
func _parse_size(value: String) -> Vector2i:
	var parts := value.split("x"); return Vector2i(int(parts[0]), int(parts[1]))
func _expect(value: bool, message: String) -> void:
	if not value: failures.append(message)
func _finish() -> void:
	if failures.is_empty(): print("RUNTIME-S1-03 J03 playable smoke: OK"); get_tree().quit(0); return
	for failure in failures: push_error(failure)
	print("RUNTIME-S1-03 J03 playable smoke: FAILED (%d)" % failures.size()); get_tree().quit(1)
