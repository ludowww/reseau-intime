extends Node

const STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const PROVIDER := preload("res://scripts/runtime/season_1/J13RuntimeProvider.gd")
const TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const J12_SMOKE := preload("res://tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd")

const PUBLIC_TRACE := "j12_laverriere_public_group_set_01"
const PAULINE_TRACE := "j13_pauline_private_version_01"
const RAPHAELLE_TRACE := "j13_raphaelle_masked_version_01"
const NICO_TRACE := "j13_nico_alibi_or_hour_message_01"
const PAULINE_FACT := "fact_pauline_created_private_double_address"
const RAPHAELLE_FACT := "fact_raphaelle_chose_player_for_masked_posture_image"
const NICO_FACT := "fact_nico_knows_specific_hour_or_alibi_request"
const PAULINE_ASSET := "S1_A4_J13_DPH_PAULINE_PRIVATE_VERSION_01"
const RAPHAELLE_ASSET := "S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01"
const SANDRA_ASSET := "S1_A3_J11_DPH_SANDRA_CHOSEN_IMAGE_01"
const PAULINE_PHOTO_MESSAGE := "msg_j13_pauline_photo_001"
const RAPHAELLE_PHOTO_MESSAGE := "msg_j13_raphaelle_photo_001"

var failures: Array[String] = []
var j12_helper


func _ready() -> void:
	j12_helper = J12_SMOKE.new()
	j12_helper.marie_j11_base_snapshot = j12_helper._build_real_j11_base_snapshot("MARIE")
	j12_helper.mathilde_j11_base_snapshot = j12_helper._build_real_j11_base_snapshot("MATHILDE")
	_exercise_network_routes()
	_exercise_sandra_matrix()
	_exercise_mathilde_matrix()
	_exercise_raphaelle_matrix()
	_exercise_nico_matrix()
	_exercise_marie_matrix()
	_exercise_sandra_transcript_removal()
	_exercise_r6b_snapshot_migrations()
	_exercise_v2_visual_snapshot_fail_closed()
	_exercise_invalid_obligations_fail_closed()
	for failure in j12_helper.failures:
		failures.append("J12 helper: " + failure)
	j12_helper.free()
	if failures.is_empty():
		print("RUNTIME_S1_13_J13_PLAYABLE: OK")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error(failure)
	get_tree().quit(1)


func _exercise_network_routes() -> void:
	var pauline = _completed_network_state(true)
	_exercise_case("Pauline eligible", pauline, "PAULINE", "msg_j13_pauline_001", "choice_j13_pauline_rule", "PAID", "NETWORK_J11_CONSEQUENCE", PAULINE_TRACE)
	_assert_private_trace_contract(pauline, PAULINE_TRACE, PAULINE_FACT, "Pauline P-A")
	var addressed = _completed_network_state(true)
	_exercise_case("Pauline double address", addressed, "PAULINE", "msg_j13_pauline_001", "choice_j13_pauline_address", "PAID", "NETWORK_J11_CONSEQUENCE", PAULINE_TRACE)
	_assert_private_trace_contract(addressed, PAULINE_TRACE, PAULINE_FACT, "Pauline P-B")
	var refused = _completed_network_state(true)
	_exercise_case("Pauline clean refusal", refused, "PAULINE", "msg_j13_pauline_001", "choice_j13_pauline_refuse", "CLOSED", "NETWORK_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(str(refused.traces[PAULINE_TRACE].get("current_state", "")) == "REMOVED" and refused.traces[PAULINE_TRACE].get("current_audience", []) == ["Pauline"] and refused.knowledge.has(PAULINE_FACT), "Pauline P-C removes access but preserves F22")
	var respiration = _completed_network_state(false)
	_exercise_case("NETWORK respiration", respiration, "RESPIRATION", "msg_j13_respiration_001", "choice_j13_respiration_bread", "PAID", "NETWORK_J11_CONSEQUENCE", PUBLIC_TRACE)
	var impossible: Dictionary = pauline.snapshot(); impossible["traces"].erase(PAULINE_TRACE); impossible["knowledge"].erase(PAULINE_FACT)
	_expect(not STATE.new().restore_snapshot(impossible), "a completed Pauline snapshot without its delivered trace fails closed")


func _exercise_sandra_matrix() -> void:
	var cases := [
		{"outcome":"SANDRA_RULE_CLARIFIED", "j12_choice":"choice_j12_sandra_clear", "message":"msg_j13_sandra_clear_001", "choice":"choice_j13_sandra_clear_confirm", "status":"PAID"},
		{"outcome":"SANDRA_DESIRE_BOUNDED", "j12_choice":"choice_j12_sandra_delay", "message":"msg_j13_sandra_delayed_001", "choice":"choice_j13_sandra_delayed_withdraw", "status":"PAID"},
		{"outcome":"SANDRA_DESIRE_BOUNDED", "j12_choice":"choice_j12_sandra_exit", "message":"msg_j13_sandra_exit_001", "choice":"choice_j13_sandra_exit_ack", "status":"CLOSED"},
	]
	for test_case in cases:
		var state = _completed_r5b_j12(str(test_case.outcome), "SANDRA", str(test_case.j12_choice), "C12")
		_exercise_case("Sandra " + str(test_case.j12_choice), state, "SANDRA", str(test_case.message), str(test_case.choice), str(test_case.status), "SANDRA_J11_CONSEQUENCE", "j11_sandra_chosen_image_01")
	var overreach = _completed_r5b_j12("SANDRA_RULE_CLARIFIED", "SANDRA", "choice_j12_sandra_clear", "C12")
	_exercise_case("Sandra extra request", overreach, "SANDRA", "msg_j13_sandra_clear_001", "choice_j13_sandra_clear_more", "FAILED", "SANDRA_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(str(overreach.traces["j11_sandra_chosen_image_01"].get("current_state", "")) == "REMOVED" and str(overreach.knowledge["fact_sandra_chose_private_image_for_player"].get("access_mode", "")) == "removed", "Sandra extra request removes file access but preserves historical knowledge")
	var removed = _completed_r5b_j12("SANDRA_IMAGE_REMOVED", "NETWORK", "", "C12")
	_exercise_case("Sandra removed stays silent", removed, "RESPIRATION", "msg_j13_respiration_001", "choice_j13_respiration_walk", "PAID", "NETWORK_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(not removed.traces.has("j11_sandra_chosen_image_01") or str(removed.traces["j11_sandra_chosen_image_01"].get("current_state", "")) == "REMOVED", "Sandra removed never reopens the private image")


func _exercise_mathilde_matrix() -> void:
	var cases := [
		{"outcome":"MATHILDE_M_B1", "private":"choice_j12_mathilde_m_b1_ack", "message":"msg_j13_mathilde_m_b1_001", "choice":"choice_j13_mathilde_m_b1_rule", "trace":PUBLIC_TRACE},
		{"outcome":"MATHILDE_M_B2", "private":"choice_j12_mathilde_m_b2_ack", "message":"msg_j13_mathilde_m_b2_001", "choice":"choice_j13_mathilde_m_b2_debt", "trace":"j11_mathilde_physical_aftercare_01"},
		{"outcome":"MATHILDE_M_B3", "private":"choice_j12_mathilde_m_b3_exit", "message":"msg_j13_mathilde_m_b3_001", "choice":"choice_j13_mathilde_m_b3_rule", "trace":"j11_mathilde_physical_aftercare_01"},
		{"outcome":"MATHILDE_DISTANCE_RESTORED", "private":"", "message":"msg_j13_mathilde_distance_001", "choice":"choice_j13_mathilde_distance_ack", "status":"CLOSED", "trace":PUBLIC_TRACE},
	]
	for test_case in cases:
		var state = _completed_semantic_j12(str(test_case.outcome), str(test_case.private), false)
		_exercise_case("Mathilde " + str(test_case.outcome), state, "MATHILDE", str(test_case.message), str(test_case.choice), str(test_case.get("status", "PAID")), "MATHILDE_J11_CONSEQUENCE", str(test_case.trace))
	var failed = _completed_semantic_j12("MATHILDE_M_B2", "choice_j12_mathilde_m_b2_ack", true)
	_exercise_case("Mathilde failed aftercare", failed, "MATHILDE", "msg_j13_mathilde_failed_001", "choice_j13_mathilde_failed_accept", "PAID", "MATHILDE_HOUSEHOLD_AFTERCARE", "j11_mathilde_physical_aftercare_01")


func _exercise_raphaelle_matrix() -> void:
	var standard = _completed_r5b_j12("FIRST_KISS", "RAPHAELLE", "choice_j12_raphaelle_public", "C12")
	_exercise_case("Raphaelle standard", standard, "RAPHAELLE", "msg_j13_raphaelle_001", "choice_j13_raphaelle_process", "PAID", "RAPHAELLE_J11_CONSEQUENCE", RAPHAELLE_TRACE)
	_assert_private_trace_contract(standard, RAPHAELLE_TRACE, RAPHAELLE_FACT, "Raphaelle process")
	var effect = _completed_r5b_j12("RESULT_SENT_ATTRACTION_NAMED", "RAPHAELLE", "choice_j12_raphaelle_public", "C12")
	_exercise_case("Raphaelle effect", effect, "RAPHAELLE", "msg_j13_raphaelle_001", "choice_j13_raphaelle_effect", "PAID", "RAPHAELLE_J11_CONSEQUENCE", RAPHAELLE_TRACE)
	_assert_private_trace_contract(effect, RAPHAELLE_TRACE, RAPHAELLE_FACT, "Raphaelle effect")
	var product = _completed_r5b_j12("FIRST_KISS", "RAPHAELLE", "choice_j12_raphaelle_public", "C12")
	_exercise_case("Raphaelle product reduction", product, "RAPHAELLE", "msg_j13_raphaelle_001", "choice_j13_raphaelle_product", "FAILED", "RAPHAELLE_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(str(product.traces[RAPHAELLE_TRACE].get("current_state", "")) == "REMOVED" and product.traces[RAPHAELLE_TRACE].get("current_audience", []) == ["Raphaëlle"] and product.knowledge.has(RAPHAELLE_FACT), "Raphaelle product removes T18 but preserves its knowledge")
	var boundary = _completed_r5b_j12("KISS_DECLINED", "RAPHAELLE", "choice_j12_raphaelle_declined_hold", "C12")
	_exercise_case("Raphaelle boundary", boundary, "RAPHAELLE", "msg_j13_raphaelle_boundary_001", "choice_j13_raphaelle_boundary_work", "CLOSED", "RAPHAELLE_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(not boundary.traces.has(RAPHAELLE_TRACE) and not boundary.knowledge.has(RAPHAELLE_FACT), "a declined kiss creates neither T18 nor its knowledge")
	var held = _completed_r5b_j12("RESULT_SENT_BOUNDARY_HELD", "RAPHAELLE", "choice_j12_raphaelle_boundary_hold", "C12")
	_exercise_case("Raphaelle professional boundary", held, "RAPHAELLE", "msg_j13_raphaelle_boundary_001", "choice_j13_raphaelle_boundary_ack", "PAID", "RAPHAELLE_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(not held.traces.has(RAPHAELLE_TRACE) and not held.knowledge.has(RAPHAELLE_FACT), "a professional boundary creates neither T18 nor its knowledge")
	var pressed = _completed_r5b_j12("RESULT_SENT_ATTRACTION_NAMED", "RAPHAELLE", "choice_j12_raphaelle_now", "C12")
	_exercise_case("Raphaelle pressed", pressed, "RAPHAELLE", "msg_j13_raphaelle_pressed_001", "choice_j13_raphaelle_insist_pressure", "FAILED", "RAPHAELLE_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(not pressed.traces.has(RAPHAELLE_TRACE) and not pressed.knowledge.has(RAPHAELLE_FACT), "RAPHAELLE_NOW creates neither T18 nor its knowledge")


func _exercise_nico_matrix() -> void:
	var cases := [
		{"outcome":"NICO_GUARDRAIL_HELD", "j12_choice":"choice_j12_nico_accept", "message":"msg_j13_nico_guardrail_001", "choice":"choice_j13_nico_guardrail_truth", "status":"PAID", "boundary":"TRUTH_LIMIT", "marie":false},
		{"outcome":"NICO_GUARDRAIL_HELD", "j12_choice":"choice_j12_nico_accept", "message":"msg_j13_nico_guardrail_001", "choice":"choice_j13_nico_guardrail_alibi", "status":"FAILED", "boundary":"ALIBI_REQUEST", "marie":false},
		{"outcome":"NICO_GUARDRAIL_HELD", "j12_choice":"choice_j12_nico_accept", "message":"msg_j13_nico_guardrail_001", "choice":"choice_j13_nico_guardrail_close", "status":"CLOSED", "boundary":"COVERAGE_CLOSED", "marie":false},
		{"outcome":"NICO_RIVALRY_MAINTAINED", "j12_choice":"choice_j12_nico_rivalry_leave", "message":"msg_j13_nico_rivalry_001", "choice":"choice_j13_nico_rivalry_truth", "status":"PAID", "boundary":"TRUTH_LIMIT", "marie":true},
		{"outcome":"NICO_RIVALRY_MAINTAINED", "j12_choice":"choice_j12_nico_rivalry_leave", "message":"msg_j13_nico_rivalry_001", "choice":"choice_j13_nico_rivalry_alibi", "status":"FAILED", "boundary":"ALIBI_REQUEST", "marie":true},
		{"outcome":"NICO_RIVALRY_MAINTAINED", "j12_choice":"choice_j12_nico_rivalry_leave", "message":"msg_j13_nico_rivalry_001", "choice":"choice_j13_nico_rivalry_close", "status":"CLOSED", "boundary":"COVERAGE_CLOSED", "marie":true},
	]
	for test_case in cases:
		var state = _completed_r5b_j12(str(test_case.outcome), "NICO", str(test_case.j12_choice), "B12")
		_exercise_case("Nico " + str(test_case.choice), state, "NICO", str(test_case.message), str(test_case.choice), str(test_case.status), "NICO_J11_CONSEQUENCE", NICO_TRACE)
		_assert_nico_contract(state, str(test_case.choice), str(test_case.boundary), bool(test_case.marie))
	var closed = _completed_r5b_j12("NICO_CLEAN_CLOSE", "NETWORK", "", "C12")
	_exercise_case("Nico clean close stays silent", closed, "RESPIRATION", "msg_j13_respiration_001", "choice_j13_respiration_alone", "PAID", "NETWORK_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(not closed.traces.has(NICO_TRACE) and not closed.knowledge.has(NICO_FACT), "NICO_CLEAN_CLOSE creates neither T19 nor F24")


func _exercise_marie_matrix() -> void:
	var close = _completed_semantic_j12("MARIE_ADULT_RECONQUEST", "choice_j12_marie_join", false)
	_exercise_case("Marie close", close, "MARIE", "msg_j13_marie_close_001", "choice_j13_marie_close_truth", "PAID", "MARIE_J11_CONSEQUENCE", PUBLIC_TRACE)
	var distant = _completed_semantic_j12("MARIE_HONEST_REFUSAL", "", false)
	_exercise_case("Marie distant", distant, "MARIE", "msg_j13_marie_distance_001", "choice_j13_marie_distance_space", "CLOSED", "MARIE_J11_CONSEQUENCE", PUBLIC_TRACE)
	_expect(close.completed_conversation_ids.count("chapter_13_priority") == 1 and distant.completed_conversation_ids.count("chapter_13_priority") == 1, "Marie variants complete once without a duplicate echo")


func _exercise_invalid_obligations_fail_closed() -> void:
	for mode in ["missing", "paid", "contradictory", "unknown"]:
		var state = _completed_network_state(false)
		if mode == "missing":
			state.obligations.erase("j12_priority_consequence_j13")
		elif mode == "paid":
			state.obligations["j12_priority_consequence_j13"]["status"] = "PAID"
		elif mode == "contradictory":
			state.obligations["j12_priority_consequence_j13"]["route"] = "MARIE"
		else:
			state.obligations["j12_priority_consequence_j13"]["route"] = "UNKNOWN"
		var provider = _new_provider(state)
		_expect(not bool(provider.start_day().get("accepted", false)), "invalid obligation fails closed: " + mode)
		_expect(state.current_day == "J12" and state.day_status == "COMPLETE" and provider.selected_pivot == "", "invalid obligation cannot mutate the J12 handoff: " + mode)


func _exercise_sandra_transcript_removal() -> void:
	var state = _completed_r5b_j12("SANDRA_RULE_CLARIFIED", "SANDRA", "choice_j12_sandra_clear", "C12")
	var historical := {"thread_sandra_private":[{"message_id":"msg_j11_sandra_photo_001","author_id":"sandra","timestamp":"21:21","content_type":"IMAGE","text":"","media_ref":SANDRA_ASSET,"placeholder_label":"Visuel canonique non produit","viewer_enabled":true,"is_player":false,"is_read":true,"source_day":11}]}
	var provider = PROVIDER.new()
	_expect(provider.initialize(state, historical, {"msg_j11_sandra_photo_001":true}, ["thread_sandra_private"], []), "Sandra removal provider initializes with historical media")
	_expect(bool(provider.start_day().get("accepted", false)), "Sandra removal selects its priority")
	_confirm(provider); _present(provider, "thread_sandra_private")
	_expect(bool(provider.apply_choice("thread_sandra_private", "choice_j13_sandra_clear_more").get("accepted", false)), "Sandra extra request applies")
	var removed := _message_by_id(provider, "thread_sandra_private", "msg_j11_sandra_photo_001")
	_expect(str(removed.get("trace_id", "")) == "j11_sandra_chosen_image_01" and str(removed.get("asset_id", "")) == SANDRA_ASSET, "Sandra removed message keeps trace and asset identity")
	_expect(str(removed.get("content_type", "")) == "TEXT" and str(removed.get("text", "")) == "Contenu retiré" and str(removed.get("media_ref", "")) == "" and not bool(removed.get("viewer_enabled", true)), "Sandra removed message becomes inaccessible in the transcript")
	_expect_round_trip(provider, "Sandra removed historical media")


func _exercise_r6b_snapshot_migrations() -> void:
	var pre_state = _completed_network_state(true); var pre_provider = _new_provider(pre_state)
	_expect(bool(pre_provider.start_day().get("accepted", false)), "R6A to_priority fixture starts")
	_assert_legacy_provider_restore(pre_provider, "R6A to_priority before delivery")
	_confirm(pre_provider)
	_assert_legacy_provider_restore(pre_provider, "R6A Pauline after delivery before choice")
	_present(pre_provider, "thread_pauline_private")
	_expect(bool(pre_provider.apply_choice("thread_pauline_private", "choice_j13_pauline_rule").get("accepted", false)), "R6A Pauline P-A fixture chooses rule")
	_assert_legacy_provider_restore(pre_provider, "R6A Pauline after P-A")
	var pauline_paid_snapshot := _legacy_r6a_provider_snapshot(pre_provider)
	var pauline_removed_state = _completed_network_state(true); var pauline_removed = _new_provider(pauline_removed_state)
	_expect(bool(pauline_removed.start_day().get("accepted", false)), "R6A Pauline P-C fixture starts"); _confirm(pauline_removed); _present(pauline_removed, "thread_pauline_private")
	_expect(bool(pauline_removed.apply_choice("thread_pauline_private", "choice_j13_pauline_refuse").get("accepted", false)), "R6A Pauline P-C fixture removes T17")
	_assert_legacy_provider_restore(pauline_removed, "R6A Pauline after P-C with T17 removed")
	var raphaelle_state = _completed_r5b_j12("FIRST_KISS", "RAPHAELLE", "choice_j12_raphaelle_public", "C12"); var raphaelle = _new_provider(raphaelle_state)
	_expect(bool(raphaelle.start_day().get("accepted", false)), "R6A Raphaelle fixture starts"); _confirm(raphaelle)
	_assert_legacy_provider_restore(raphaelle, "R6A Raphaelle after delivery")
	_present(raphaelle, "thread_raphaelle_private"); _expect(bool(raphaelle.apply_choice("thread_raphaelle_private", "choice_j13_raphaelle_product").get("accepted", false)), "R6A Raphaelle product fixture removes T18")
	_assert_legacy_provider_restore(raphaelle, "R6A Raphaelle product with T18 removed")
	var marie_state = _completed_semantic_j12("MARIE_ADULT_RECONQUEST", "", false); var marie = _new_provider(marie_state)
	_expect(bool(marie.start_day().get("accepted", false)), "R6A Marie close fixture starts"); _confirm(marie)
	_assert_legacy_provider_restore(marie, "R6A Marie close with public T14")
	var sandra_state = _completed_r5b_j12("SANDRA_RULE_CLARIFIED", "SANDRA", "choice_j12_sandra_clear", "C12")
	var historical := {"thread_sandra_private":[{"message_id":"msg_j11_sandra_photo_001","author_id":"sandra","timestamp":"21:21","content_type":"PHOTO","text":"","media_ref":SANDRA_ASSET,"placeholder_label":"Visuel canonique non produit","is_player":false,"is_read":true,"source_day":11}]}
	var sandra = PROVIDER.new(); _expect(sandra.initialize(sandra_state, historical, {"msg_j11_sandra_photo_001":true}, ["thread_sandra_private"], []), "R6A Sandra migration fixture initializes")
	_expect(bool(sandra.start_day().get("accepted", false)), "R6A Sandra migration fixture starts"); _confirm(sandra); _present(sandra, "thread_sandra_private")
	_expect(bool(sandra.apply_choice("thread_sandra_private", "choice_j13_sandra_clear_more").get("accepted", false)), "R6A Sandra migration fixture removes T11")
	_assert_legacy_provider_restore(sandra, "R6A Sandra historical media after removal")
	var completed_state = _completed_network_state(false); var completed = _new_provider(completed_state)
	_expect(bool(completed.start_day().get("accepted", false)), "R6A complete fixture starts"); _confirm(completed); _present(completed, "thread_marie_private")
	_expect(bool(completed.apply_choice("thread_marie_private", "choice_j13_respiration_bread").get("accepted", false)), "R6A complete fixture chooses"); _confirm(completed)
	_expect(completed.phase == "complete", "R6A complete fixture closes J13"); _assert_legacy_provider_restore(completed, "R6A end J13")
	var duplicate := pauline_paid_snapshot.duplicate(true); duplicate["transcripts_by_thread"]["thread_pauline_private"].append(_legacy_message_by_id(duplicate, "thread_pauline_private", PAULINE_PHOTO_MESSAGE))
	var duplicate_restored = PROVIDER.new(); _expect(duplicate_restored.initialize(pre_provider.state, {}, {}, [], []) and not duplicate_restored.restore_snapshot(duplicate), "duplicated R6A exact visual message fails closed")
	var wrong_asset := pauline_paid_snapshot.duplicate(true); _legacy_message_by_id(wrong_asset, "thread_pauline_private", PAULINE_PHOTO_MESSAGE)["media_ref"] = "WRONG"
	var wrong_asset_restored = PROVIDER.new(); _expect(wrong_asset_restored.initialize(pre_provider.state, {}, {}, [], []) and not wrong_asset_restored.restore_snapshot(wrong_asset), "contradictory R6A provider asset fails closed")
	var wrong_pivot := pauline_paid_snapshot.duplicate(true); wrong_pivot["selected_pivot"] = "RAPHAELLE"
	var wrong_pivot_restored = PROVIDER.new(); _expect(wrong_pivot_restored.initialize(pre_provider.state, {}, {}, [], []) and not wrong_pivot_restored.restore_snapshot(wrong_pivot), "contradictory R6A provider pivot fails closed")
	_exercise_r6b_state_snapshot_migration(pre_state, pauline_removed_state, raphaelle_state)
	var nested_state = STATE.new(); _expect(nested_state.restore_snapshot(_legacy_r6a_state_snapshot(pre_state)), "global R6A nested state v22 restores first")
	var nested_provider = PROVIDER.new(); _expect(nested_provider.initialize(nested_state, {}, {}, [], []) and nested_provider.restore_snapshot(pauline_paid_snapshot), "global R6A nested J13 provider v1 restores after state")
	_expect(int(nested_state.snapshot().get("version", -1)) == 23 and int(nested_provider.snapshot().get("version", -1)) == 2, "global R6A nested snapshot round-trips in current formats")


func _exercise_v2_visual_snapshot_fail_closed() -> void:
	var state = _completed_network_state(true); var provider = _new_provider(state)
	_expect(bool(provider.start_day().get("accepted", false)), "v2 strict fixture starts"); _confirm(provider); _present(provider, "thread_pauline_private")
	_expect(bool(provider.apply_choice("thread_pauline_private", "choice_j13_pauline_rule").get("accepted", false)), "v2 strict fixture settles Pauline")
	var canonical: Dictionary = provider.snapshot()
	var wrong_asset := canonical.duplicate(true); _legacy_message_by_id(wrong_asset, "thread_pauline_private", PAULINE_PHOTO_MESSAGE)["asset_id"] = "WRONG"
	_expect_v2_snapshot_rejected(state, wrong_asset, "v2 wrong visual asset fails closed")
	var missing_asset := canonical.duplicate(true); _legacy_message_by_id(missing_asset, "thread_pauline_private", PAULINE_PHOTO_MESSAGE).erase("asset_id")
	_expect_v2_snapshot_rejected(state, missing_asset, "v2 missing visual asset fails closed")
	var wrong_message := canonical.duplicate(true); _legacy_message_by_id(wrong_message, "thread_pauline_private", PAULINE_PHOTO_MESSAGE)["message_id"] = "msg_j13_pauline_photo_wrong"; wrong_message["produced_message_ids"].erase(PAULINE_PHOTO_MESSAGE); wrong_message["produced_message_ids"]["msg_j13_pauline_photo_wrong"] = true
	_expect_v2_snapshot_rejected(state, wrong_message, "v2 wrong visual message id fails closed")
	var wrong_label := canonical.duplicate(true); _legacy_message_by_id(wrong_label, "thread_pauline_private", PAULINE_PHOTO_MESSAGE)["placeholder_label"] = "WRONG"
	_expect_v2_snapshot_rejected(state, wrong_label, "v2 wrong active placeholder label fails closed")
	var unknown_served := canonical.duplicate(true); unknown_served["served_visual_beat_ids"].append("unknown_visual_trace")
	_expect_v2_snapshot_rejected(state, unknown_served, "v2 unknown served visual id fails closed")
	var missing_served := canonical.duplicate(true); missing_served["served_visual_beat_ids"].erase(PAULINE_TRACE)
	_expect_v2_snapshot_rejected(state, missing_served, "v2 missing served visual id fails closed")
	var legacy_photo := canonical.duplicate(true); _legacy_message_by_id(legacy_photo, "thread_pauline_private", PAULINE_PHOTO_MESSAGE)["content_type"] = "PHOTO"
	_expect_v2_snapshot_rejected(state, legacy_photo, "v2 injected PHOTO presentation fails closed")
	var unknown_image := canonical.duplicate(true); unknown_image["transcripts_by_thread"]["thread_pauline_private"].append({"message_id":"msg_j13_unknown_image","author_id":"pauline","timestamp":"11:21","content_type":"IMAGE","text":"","media_ref":"UNKNOWN","placeholder_label":"Unknown","viewer_enabled":false,"is_player":false,"is_read":false,"source_day":13}); unknown_image["produced_message_ids"]["msg_j13_unknown_image"] = true
	_expect_v2_snapshot_rejected(state, unknown_image, "v2 unknown J13 image fails closed")
	var duplicate := canonical.duplicate(true); duplicate["transcripts_by_thread"]["thread_pauline_private"].append(_legacy_message_by_id(duplicate, "thread_pauline_private", PAULINE_PHOTO_MESSAGE).duplicate(true))
	_expect_v2_snapshot_rejected(state, duplicate, "v2 duplicated visual presentation fails closed")
	var missing_produced := canonical.duplicate(true); missing_produced["produced_message_ids"].erase(PAULINE_PHOTO_MESSAGE)
	_expect_v2_snapshot_rejected(state, missing_produced, "v2 missing produced visual id fails closed")
	_expect_round_trip(provider, "v2 canonical snapshot remains restorable")


func _expect_v2_snapshot_rejected(state, snapshot: Dictionary, label: String) -> void:
	var restored = PROVIDER.new()
	_expect(restored.initialize(state, {}, {}, [], []) and not restored.restore_snapshot(snapshot), label)


func _exercise_r6b_state_snapshot_migration(pauline_active_state, pauline_removed_state, raphaelle_removed_state) -> void:
	var before_j13 = _completed_network_state(false); var restored_before = STATE.new()
	_expect(restored_before.restore_snapshot(_legacy_r6a_state_snapshot(before_j13)) and not restored_before.traces.has(PAULINE_TRACE) and not restored_before.traces.has(RAPHAELLE_TRACE), "v22 before J13 migrates without private traces")
	for test_case in [{"label":"Pauline T17 active","state":pauline_active_state,"trace":PAULINE_TRACE,"asset":PAULINE_ASSET},{"label":"Pauline T17 removed","state":pauline_removed_state,"trace":PAULINE_TRACE,"asset":PAULINE_ASSET},{"label":"Raphaelle T18 removed","state":raphaelle_removed_state,"trace":RAPHAELLE_TRACE,"asset":RAPHAELLE_ASSET}]:
		var restored = STATE.new(); _expect(restored.restore_snapshot(_legacy_r6a_state_snapshot(test_case.state)), "v22 " + str(test_case.label) + " restores")
		_expect(str(restored.traces.get(test_case.trace, {}).get("asset_id", "")) == str(test_case.asset), "v22 " + str(test_case.label) + " gains its canonical asset")
	var raphaelle_active_state = _completed_r5b_j12("FIRST_KISS", "RAPHAELLE", "choice_j12_raphaelle_public", "C12"); var raphaelle_active_provider = _new_provider(raphaelle_active_state)
	_expect(bool(raphaelle_active_provider.start_day().get("accepted", false)), "v22 Raphaelle active fixture starts"); _confirm(raphaelle_active_provider)
	var restored_raphaelle = STATE.new(); _expect(restored_raphaelle.restore_snapshot(_legacy_r6a_state_snapshot(raphaelle_active_state)) and str(restored_raphaelle.traces[RAPHAELLE_TRACE].get("asset_id", "")) == RAPHAELLE_ASSET, "v22 Raphaelle T18 active restores")
	var bad_asset := _legacy_r6a_state_snapshot(pauline_active_state); bad_asset["traces"][PAULINE_TRACE]["asset_id"] = "WRONG"; _expect(not STATE.new().restore_snapshot(bad_asset), "v22 contradictory Pauline asset fails closed")
	var bad_parent := _legacy_r6a_state_snapshot(pauline_active_state); bad_parent["traces"][PAULINE_TRACE]["parent_content_id"] = "WRONG"; _expect(not STATE.new().restore_snapshot(bad_parent), "v22 contradictory Pauline parent fails closed")
	var missing_fact := _legacy_r6a_state_snapshot(pauline_active_state); missing_fact["knowledge"].erase(PAULINE_FACT); _expect(not STATE.new().restore_snapshot(missing_fact), "v22 private trace without knowledge fails closed")
	var t18b := _legacy_r6a_state_snapshot(before_j13); t18b["traces"]["j13_raphaelle_masked_adult_selected_01"] = {}; _expect(not STATE.new().restore_snapshot(t18b), "v22 T18B fails closed")
	var wrong_owner := _legacy_r6a_state_snapshot(pauline_active_state); wrong_owner["traces"][PAULINE_TRACE]["owner"] = "Player"; _expect(not STATE.new().restore_snapshot(wrong_owner), "v22 wrong private trace owner fails closed")


func _assert_legacy_provider_restore(provider, label: String) -> void:
	var legacy := _legacy_r6a_provider_snapshot(provider); var gallery_before: Array = legacy["gallery_asset_ids"].duplicate(); var restored = PROVIDER.new()
	_expect(restored.initialize(provider.state, {}, {}, [], []), label + " initializes")
	_expect(restored.restore_snapshot(legacy), label + " restores v1")
	_expect(int(restored.snapshot().get("version", -1)) == 2 and restored.gallery_asset_ids == gallery_before, label + " becomes v2 without Gallery mutation")
	_expect(restored._visual_snapshot_consistent(), label + " satisfies current visual invariants")


func _legacy_r6a_provider_snapshot(provider) -> Dictionary:
	var legacy: Dictionary = provider.snapshot(); legacy["version"] = 1; legacy["served_visual_beat_ids"] = []
	var refs := {PAULINE_PHOTO_MESSAGE:PAULINE_ASSET,RAPHAELLE_PHOTO_MESSAGE:RAPHAELLE_ASSET,"msg_j13_marie_close_photo_001":PUBLIC_TRACE}
	for thread_id in legacy["transcripts_by_thread"]:
		var transcript: Array = legacy["transcripts_by_thread"][thread_id]
		for index in range(transcript.size()):
			var item: Dictionary = transcript[index]; var message_id := str(item.get("message_id", ""))
			if refs.has(message_id):
				item["content_type"] = "PHOTO"; item["media_ref"] = str(refs[message_id]); item.erase("trace_id"); item.erase("asset_id"); item.erase("viewer_enabled")
			elif str(item.get("trace_id", "")) == "j11_sandra_chosen_image_01" or str(item.get("asset_id", "")) == SANDRA_ASSET:
				item["content_type"] = "PHOTO"; item["text"] = ""; item["media_ref"] = SANDRA_ASSET; item["placeholder_label"] = "Visuel canonique non produit"; item.erase("trace_id"); item.erase("asset_id"); item.erase("viewer_enabled")
			transcript[index] = item
		legacy["transcripts_by_thread"][thread_id] = transcript
	return legacy


func _legacy_message_by_id(snapshot: Dictionary, thread_id: String, message_id: String) -> Dictionary:
	for message in snapshot["transcripts_by_thread"].get(thread_id, []):
		if str(message.get("message_id", "")) == message_id: return message
	return {}


func _legacy_r6a_state_snapshot(state) -> Dictionary:
	var legacy: Dictionary = state.snapshot(); legacy["version"] = 22
	if legacy["traces"].has(PAULINE_TRACE): legacy["traces"][PAULINE_TRACE].erase("asset_id"); legacy["traces"][PAULINE_TRACE].erase("parent_content_id"); legacy["traces"][PAULINE_TRACE].erase("parent_asset_id")
	if legacy["traces"].has(RAPHAELLE_TRACE): legacy["traces"][RAPHAELLE_TRACE].erase("asset_id")
	return legacy


func _exercise_case(label: String, state, expected_pivot: String, first_message_id: String, choice_id: String, expected_status: String, expected_origin: String, expected_trace: String) -> void:
	var obligation: Dictionary = state.obligations.get("j12_priority_consequence_j13", {})
	_expect(str(obligation.get("status", "")) == "DUE" and str(obligation.get("origin", "")) == expected_origin, label + " starts from the exact due obligation")
	var provider = _new_provider(state)
	_expect_round_trip(provider, label + " end J12")
	_expect(bool(provider.start_day().get("accepted", false)) and provider.selected_pivot == expected_pivot, label + " selects the exact foreground")
	_expect(not state.traces.has(PAULINE_TRACE) and not state.traces.has(RAPHAELLE_TRACE) and not state.traces.has(NICO_TRACE), label + " creates no J13 trace during selection")
	_expect(not state.knowledge.has(PAULINE_FACT) and not state.knowledge.has(RAPHAELLE_FACT) and not state.knowledge.has(NICO_FACT), label + " creates no J13 knowledge during selection")
	_expect(provider.presentation_count_by_trace_id(PAULINE_TRACE) == 0 and provider.presentation_count_by_trace_id(RAPHAELLE_TRACE) == 0, label + " has no private visual before delivery")
	_expect_round_trip(provider, label + " before delivery")
	_confirm(provider)
	_expect(provider.presentation_count_by_id(first_message_id) == 1, label + " delivers only the exact variant")
	var thread_id := str(PROVIDER.THREADS.get(expected_pivot, "thread_marie_private"))
	var private_visual_trace := PAULINE_TRACE if expected_pivot == "PAULINE" else (RAPHAELLE_TRACE if first_message_id == "msg_j13_raphaelle_001" else "")
	if private_visual_trace == PAULINE_TRACE: _assert_visual_delivery(provider, thread_id, PAULINE_PHOTO_MESSAGE, PAULINE_TRACE, PAULINE_ASSET, "Visuel canonique non produit · quatrième frame privée Pauline", label)
	elif private_visual_trace == RAPHAELLE_TRACE: _assert_visual_delivery(provider, thread_id, RAPHAELLE_PHOTO_MESSAGE, RAPHAELLE_TRACE, RAPHAELLE_ASSET, "Visuel canonique non produit · masque et posture Raphaëlle", label)
	else: _expect(provider.presentation_count_by_trace_id(PAULINE_TRACE) == 0 and provider.presentation_count_by_trace_id(RAPHAELLE_TRACE) == 0, label + " produces no ineligible private visual")
	_expect(provider.gallery_asset_ids.is_empty(), label + " adds no J13 gallery asset")
	if expected_trace == PAULINE_TRACE or expected_trace == RAPHAELLE_TRACE:
		var expected_fact := PAULINE_FACT if expected_trace == PAULINE_TRACE else RAPHAELLE_FACT
		_expect(state.traces.has(expected_trace) and state.knowledge.has(expected_fact), label + " creates its private trace and knowledge at delivery")
	if expected_pivot == "NICO":
		_expect(not state.traces.has(NICO_TRACE) and not state.knowledge.has(NICO_FACT), label + " keeps T19 and F24 absent before the real choice")
	_expect_round_trip(provider, label + " after delivery")
	_present(provider, thread_id)
	_expect_round_trip(provider, label + " before choice")
	_expect(bool(provider.apply_choice(thread_id, choice_id).get("accepted", false)), label + " applies its authored choice")
	_expect(str(state.obligations["j12_priority_consequence_j13"].get("status", "")) == expected_status, label + " settles the debt exactly")
	_expect(str(state.obligations["j12_priority_consequence_j13"].get("paid_by", "")) == "Player" and str(state.obligations["j12_priority_consequence_j13"].get("paid_or_closed_at", "")) != "", label + " preserves settlement attribution")
	_expect(not bool(provider.apply_choice(thread_id, choice_id).get("accepted", false)), label + " cannot settle twice")
	_expect(state.j13_j14_trace_id == expected_trace, label + " hands J14 the exact accessible trace")
	if private_visual_trace != "":
		var visual_message_id := PAULINE_PHOTO_MESSAGE if private_visual_trace == PAULINE_TRACE else RAPHAELLE_PHOTO_MESSAGE
		var visual := _message_by_id(provider, thread_id, visual_message_id); var trace: Dictionary = state.traces.get(private_visual_trace, {})
		if str(trace.get("current_state", "")) == "REMOVED": _expect(str(visual.get("content_type", "")) == "TEXT" and str(visual.get("text", "")) == "Contenu retiré" and str(visual.get("media_ref", "")) == "" and not bool(visual.get("viewer_enabled", true)), label + " neutralizes the removed visual")
		else: _expect(str(visual.get("content_type", "")) == "IMAGE" and not bool(visual.get("viewer_enabled", true)), label + " keeps the accessible placeholder non-viewable")
		_expect(provider.presentation_count_by_trace_id(private_visual_trace) == 1 and provider.served_visual_beat_ids.count(private_visual_trace) == 1, label + " keeps exactly one visual across choice and thread return")
		provider.on_thread_returned(thread_id)
		_expect(provider.presentation_count_by_trace_id(private_visual_trace) == 1, label + " does not duplicate visual on thread return")
	_expect_round_trip(provider, label + " after choice")
	if expected_pivot not in ["MARIE", "RESPIRATION"]:
		_confirm(provider)
		_present(provider, "thread_marie_private")
		_expect(provider.presentation_count_by_id("msg_j13_marie_echo_001") == 1, label + " presents exactly one Marie echo")
		_expect_round_trip(provider, label + " after Marie echo")
	else:
		_expect(provider.presentation_count_by_id("msg_j13_marie_echo_001") == 0, label + " never duplicates Marie as echo")
	_confirm(provider)
	_expect(provider.phase == "complete" and state.day_status == "COMPLETE", label + " completes J13")
	_expect_round_trip(provider, label + " end J13")
	_expect_state_round_trip(state, label + " state end J13")
	var j13_threads: Dictionary = {}
	for candidate_thread in provider.transcripts_by_thread:
		for message in provider.transcripts_by_thread[candidate_thread]:
			if int(message.get("source_day", 0)) == 13:
				j13_threads[candidate_thread] = true
	_expect(j13_threads.size() <= (1 if expected_pivot in ["MARIE", "RESPIRATION"] else 2), label + " unlocks no compensation thread")


func _assert_private_trace_contract(state, trace_id: String, fact_id: String, label: String) -> void:
	var trace: Dictionary = state.traces.get(trace_id, {}); var fact: Dictionary = state.knowledge.get(fact_id, {})
	_expect(not trace.is_empty() and not fact.is_empty(), label + " keeps its trace and knowledge pair")
	_expect(str(trace.get("knowledge_created", "")) == fact_id and str(fact.get("source_ref", "")) == trace_id, label + " links trace and knowledge canonically")
	_expect(str(trace.get("current_state", "")) == "PRIVATE_ACTIVE" and str(trace.get("saving_rule", "")) == "IN_THREAD_ONLY" and str(trace.get("transfer_rule", "")) == "FORBIDDEN", label + " keeps bounded in-thread access")


func _assert_visual_delivery(provider, thread_id: String, message_id: String, trace_id: String, asset_id: String, expected_label: String, label: String) -> void:
	var message := _message_by_id(provider, thread_id, message_id); var trace: Dictionary = provider.state.traces.get(trace_id, {})
	_expect(not message.is_empty() and str(message.get("content_type", "")) == "IMAGE", label + " creates one ImageMessage")
	_expect(str(message.get("trace_id", "")) == trace_id and str(message.get("asset_id", "")) == asset_id and str(message.get("media_ref", "")) == asset_id, label + " separates message, trace and asset ids")
	_expect(str(message.get("placeholder_label", "")) == expected_label and not bool(message.get("viewer_enabled", true)), label + " exposes the specific non-viewable placeholder")
	_expect(str(trace.get("trace_id", "")) == trace_id and str(trace.get("asset_id", "")) == asset_id, label + " trace carries the same deterministic asset contract")
	_expect(provider.presentation_count_by_trace_id(trace_id) == 1 and provider.served_visual_beat_ids.count(trace_id) == 1, label + " serves the visual beat exactly once")


func _message_by_id(provider, thread_id: String, message_id: String) -> Dictionary:
	for message in provider.transcript_for(thread_id):
		if str(message.get("message_id", "")) == message_id: return message
	return {}


func _assert_nico_contract(state, choice_id: String, expected_boundary: String, includes_marie: bool) -> void:
	var trace: Dictionary = state.traces.get(NICO_TRACE, {}); var fact: Dictionary = state.knowledge.get(NICO_FACT, {}); var expected_subjects := ["Nico","Player","Marie"] if includes_marie else ["Nico","Player"]
	_expect(not trace.is_empty() and not fact.is_empty(), choice_id + " creates T19 and F24")
	_expect(trace.get("subjects", []) == expected_subjects, choice_id + " records only the subjects established by its variant")
	_expect(str(trace.get("knowledge_created", "")) == NICO_FACT and str(fact.get("source_ref", "")) == NICO_TRACE, choice_id + " links T19 and F24")
	_expect(str(fact.get("source_choice_id", "")) == choice_id and str(fact.get("request_or_boundary", "")) == expected_boundary, choice_id + " stores its exact bounded meaning")
	_expect(str(fact.get("source_type", "")) == "DIRECT_MESSAGE" and str(fact.get("certainty", "")) == "TOLD_DIRECTLY" and str(fact.get("shareability", "")) == "FACTUAL_ONLY", choice_id + " preserves the canonical F24 epistemic contract")


func _completed_network_state(pauline_eligible: bool):
	var state = STATE.new()
	_expect(state.restore_snapshot(j12_helper.marie_j11_base_snapshot), "NETWORK fixture clones a real J10 to J11 handoff")
	state.j10_pivot = "SANDRA"; state.j10_pivot_reason = "AUTHORED_ORDER"; state.j10_pivot_outcome = "CAFE_HELD_CALM_PRESENCE"
	state.completed_conversation_ids.erase("chapter_10_marie_obligations"); state.completed_conversation_ids.append("chapter_10_sandra_cafe")
	state.j11_pivot = "RESPIRATION"; state.j11_pivot_reason = "J10_NO_LEGITIMATE_CONTINUATION"; state.j11_pivot_outcome = ""; state.j11_physical_level = "NONE"
	_expect(state.complete_j11(), "NETWORK fixture completes J11")
	_expect(state.begin_j12(), "NETWORK fixture enters J12")
	_expect(state.apply_j12_choice("choice_j12_presence_la") and state.establish_j12_laverriere_public_trace() and state.pay_j12_laverriere_presence(), "NETWORK fixture establishes T14")
	var annexe_choice := "choice_j12_annexe_a12" if pauline_eligible else "choice_j12_annexe_c12"
	_expect(state.apply_j12_choice(annexe_choice), "NETWORK fixture chooses P13")
	_expect(state.pay_and_establish_j12_annexe_arrival() if pauline_eligible else state.establish_j12_annexe_public_trace(), "NETWORK fixture establishes T15")
	_expect(state.establish_j12_priority_consequence("NETWORK") and state.complete_j12(), "NETWORK fixture completes J12")
	return state


func _completed_r5b_j12(outcome: String, route: String, private_choice: String, annexe: String):
	var state = j12_helper._completed_r5b_j11_state(outcome)
	return _complete_j12(state, route, private_choice, annexe, false)


func _completed_semantic_j12(outcome: String, private_choice: String, failed_aftercare: bool):
	var state = j12_helper._completed_semantic_j11_state(outcome, "FAILED" if failed_aftercare else "PAID")
	return _complete_j12(state, "MATHILDE" if outcome.begins_with("MATHILDE_") else "MARIE", private_choice, "C12", failed_aftercare)


func _complete_j12(state, route: String, private_choice: String, annexe: String, failed_aftercare: bool):
	_expect(state.begin_j12(), route + " fixture enters J12")
	if failed_aftercare:
		_expect(state.mark_j12_failed_aftercare_processed(), route + " fixture preserves failed aftercare priority")
	_expect(state.apply_j12_choice("choice_j12_presence_la") and state.establish_j12_laverriere_public_trace() and state.pay_j12_laverriere_presence(), route + " fixture establishes and pays T14")
	if private_choice != "":
		_expect(state.apply_j12_choice(private_choice), route + " fixture records exact J12 private consequence")
	_expect(state.apply_j12_choice("choice_j12_annexe_" + annexe.to_lower()), route + " fixture chooses " + annexe)
	_expect(state.pay_and_establish_j12_annexe_arrival() if annexe in ["A12", "B12"] else state.establish_j12_annexe_public_trace(), route + " fixture establishes and settles T15")
	_expect(state.establish_j12_priority_consequence(route), route + " fixture creates exact J13 obligation")
	_expect(state.complete_j12(), route + " fixture completes J12")
	return state


func _new_provider(state):
	var provider = PROVIDER.new()
	_expect(provider.initialize(state, {}, {}, [], []), "J13 provider initializes")
	return provider


func _present(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 13 and not bool(message.get("is_player", false)) and not provider.presented_time_message_ids.has(str(message.get("message_id", ""))):
			provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "batch presents for " + thread_id)


func _confirm(provider) -> void:
	var target_text := str(provider.pending_transition.get("to_time", ""))
	if target_text != "":
		var target := TIME.parse_narrative_time(target_text)
		if target >= provider.current_narrative_time_minutes():
			provider.commit_narrative_time(target)
	_expect(bool(provider.confirm_transition().get("accepted", false)), "transition confirms")


func _expect_round_trip(provider, label: String) -> void:
	var snap: Dictionary = provider.snapshot()
	var restored = PROVIDER.new()
	_expect(restored.initialize(provider.state, {}, {}, [], []), label + " initializes")
	_expect(restored.restore_snapshot(snap), label + " restores")
	_expect(restored.snapshot() == snap, label + " is exact")


func _expect_state_round_trip(state, label: String) -> void:
	var snap: Dictionary = state.snapshot()
	_expect(state._j12_records_consistent(snap), label + " preserves J12 records")
	_expect(state._j13_records_consistent(snap), label + " preserves J13 records")
	var restored = STATE.new()
	_expect(restored.restore_snapshot(snap), label + " restores")
	_expect(restored.snapshot() == snap, label + " is exact")


func _expect(condition: bool, label: String) -> void:
	if not condition:
		failures.append(label)
