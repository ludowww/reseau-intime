extends Node

const STATE := preload("res://scripts/runtime/season_1/Season1State.gd")
const PROVIDER := preload("res://scripts/runtime/season_1/J14RuntimeProvider.gd")
const TIME := preload("res://scripts/runtime/season_1/NarrativeTime.gd")
const J13_SMOKE := preload("res://tests/RUNTIME_S1_13J13PlayableSmokeDriver.gd")
const J12_SMOKE := preload("res://tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd")
var failures: Array[String] = []
var j13_helper

func _ready() -> void:
	j13_helper = J13_SMOKE.new(); j13_helper.j12_helper = J12_SMOKE.new()
	j13_helper.j12_helper.marie_j11_base_snapshot = j13_helper.j12_helper._build_real_j11_base_snapshot("MARIE")
	j13_helper.j12_helper.mathilde_j11_base_snapshot = j13_helper.j12_helper._build_real_j11_base_snapshot("MATHILDE")
	_exercise_private_runtime("choice_j14_pauline_truth", "TRUTH_LIMITED", false)
	_exercise_private_runtime("choice_j14_pauline_lie", "MINIMIZE_OR_LIE", false)
	_exercise_private_runtime("choice_j14_pauline_defer", "PROTECT_AND_DEFER", true)
	_exercise_public_mutation()
	_exercise_presence_negatives()
	_exercise_variant_and_posture_matrix()
	_exercise_p15_failed_path()
	_exercise_state_migrations_and_corruption()
	_exercise_authentic_v23_state_snapshots()
	_exercise_provider_legacy_phases()
	for failure in j13_helper.failures: failures.append("J13 helper: " + failure)
	for failure in j13_helper.j12_helper.failures: failures.append("J12 helper: " + failure)
	j13_helper.j12_helper.free(); j13_helper.free()
	if failures.is_empty(): print("RUNTIME_S1_14_J14_PLAYABLE: OK"); get_tree().quit(0); return
	for failure in failures: push_error(failure)
	get_tree().quit(1)

func _exercise_private_runtime(choice_id: String, expected_outcome: String, expects_j14_p14: bool) -> void:
	var state = _completed_j13_state("PAULINE"); var source_before: Dictionary = state.traces[state.j13_j14_trace_id].duplicate(true); var provider = _new_provider(state)
	_expect(bool(provider.start_day().get("accepted", false)) and provider.phase == "to_presence_context" and provider.selected_pivot == "", choice_id + " waits for explicit J14 context")
	_expect(state.j14_variant == "" and state.j14_witness_presence_evidence.is_empty() and not state.traces.has("j14_discovery_event_01"), choice_id + " has no synthetic proof or early T20")
	_confirm(provider)
	_expect(provider.phase == "to_discovery" and provider.selected_pivot == "PAULINE" and state.j14_variant == "PAULINE", choice_id + " selects only after context presentation")
	_expect(str(state.j14_witness_presence_evidence.get("source_day", "")) == "J14" and bool(state.j14_witness_presence_evidence.get("physically_present", false)) and str(state.j14_witness_presence_evidence.get("reason_near_screen", "")) != "" and str(state.j14_witness_presence_evidence.get("shared_context", "")) != "", choice_id + " stores cumulative presence proof")
	_expect_state_round_trip(state, choice_id + " selected state"); _expect_round_trip(provider, choice_id + " selected provider")
	_confirm(provider)
	_expect(provider.phase == "priority_incoming" and not state.traces.has("j14_discovery_event_01") and not state.knowledge.has("fact_witness_saw_limited_trace") and not state.promises.has("j14_inform_trace_controller"), choice_id + " presents before atomic ledger creation")
	_present(provider, "thread_marie_private")
	_expect(provider.phase == "priority_choice" and state.traces.has("j14_discovery_event_01") and state.knowledge.has("fact_witness_saw_limited_trace") and state.promises.has("j14_inform_trace_controller"), choice_id + " creates T20 F26 P15 atomically after presentation")
	var t20: Dictionary = state.traces["j14_discovery_event_01"]; var f26: Dictionary = state.knowledge["fact_witness_saw_limited_trace"]
	_expect(t20.get("visible_values", {}) == state.j14_visible_values and f26.get("visible_values", {}) == state.j14_visible_values and t20.get("replaces_or_derives_from", []) == [state.j14_source_trace_id], choice_id + " stores exact visible values and unique derivation")
	_expect(state.traces[state.j14_source_trace_id] == source_before, choice_id + " preserves source byte-for-byte")
	_expect(bool(provider.apply_choice("thread_marie_private", choice_id).get("accepted", false)) and state.j14_outcome == expected_outcome, choice_id + " stores semantic posture")
	_expect(state.promises.has("j14_witness_clarification") == expects_j14_p14, choice_id + " creates P14 only for precise defer")
	if expects_j14_p14: _expect(str(state.promises["j14_witness_clarification"].get("due_at", "")) == "J14 21:30", choice_id + " keeps exact P14 hour")
	_confirm(provider); _expect(provider.phase == "echo_incoming" and str(state.promises["j14_inform_trace_controller"].get("status", "")) == "ACTIVE", choice_id + " keeps P15 active before message presentation")
	_present(provider, "thread_pauline_private")
	_expect(str(state.promises["j14_inform_trace_controller"].get("status", "")) == "PAID" and state.j14_controller_notified, choice_id + " pays P15 after specific reply presentation")
	if expects_j14_p14:
		_expect(provider.phase == "to_clarification", choice_id + " schedules exact P14 before J15"); _confirm(provider); _present(provider, "thread_marie_private")
		_expect(str(state.promises["j14_witness_clarification"].get("status", "")) == "PAID" and str(state.promises["j14_witness_clarification"].get("paid_or_closed_at", "")) == "J14 21:30", choice_id + " makes J14 P14 terminal at presented hour")
	_expect(provider.phase == "day_close", choice_id + " reaches day close with terminal obligations"); _confirm(provider)
	_expect(provider.phase == "complete" and state.day_status == "COMPLETE" and state._j14_records_consistent(state.snapshot()), choice_id + " completes consistent J14")
	_expect_state_round_trip(state, choice_id + " completed state")

func _exercise_public_mutation() -> void:
	var state = _completed_j13_state("RESPIRATION"); var source_before: Dictionary = state.traces[state.j13_j14_trace_id].duplicate(true); var provider = _new_provider(state)
	_expect(bool(provider.start_day().get("accepted", false)) and provider.selected_pivot == "S27_MUTATION_NO_DISCOVERY" and provider.phase == "day_close", "public-only T14 selects mutation-only fallback")
	_expect(state.j14_witness == "" and state.j14_visible_fields.is_empty() and state.j14_visible_values.is_empty(), "mutation has no fake witness or visibility")
	_expect(provider.transcripts_by_thread.values().all(func(messages): return (messages as Array).filter(func(message): return int(message.get("source_day", 0)) == 14).is_empty()), "mutation opens no J14 conversation")
	_confirm(provider)
	_expect(provider.phase == "complete" and state.traces[state.j13_j14_trace_id] == source_before, "mutation completes and preserves public source")
	_expect(not state.traces.has("j14_discovery_event_01") and not state.knowledge.has("fact_witness_saw_limited_trace") and not state.promises.has("j14_witness_clarification") and not state.promises.has("j14_inform_trace_controller"), "mutation creates no T20 F26 P14 or P15")

func _exercise_presence_negatives() -> void:
	for mutation in [
		{"label":"Marie absente","change":func(e): e["physically_present"] = false},
		{"label":"raison absente","change":func(e): e["reason_near_screen"] = ""},
		{"label":"contexte absent","change":func(e): e["shared_context"] = ""},
	]:
		var state = _completed_j13_state("PAULINE"); _expect(state.begin_j14(), str(mutation.label) + " begins"); var evidence: Dictionary = state.j14_presence_contract(); evidence.merge({"evidence_id":"negative","source_day":"J14","recorded_at":"J14 18:34","physically_present":true,"presented_before_selection":true}, true); mutation.change.call(evidence)
		_expect(not state.record_j14_presence_evidence(evidence) and state.select_j14_variant() == "S27_MUTATION_NO_DISCOVERY", str(mutation.label) + " fails to mutation")
	var sandra = _finish_j13(j13_helper._completed_r5b_j12("SANDRA_RULE_CLARIFIED", "SANDRA", "choice_j12_sandra_clear", "C12"), "SANDRA", "j13_sandra_clear", "choice_j13_sandra_clear_confirm")
	sandra.household_rhythm_confirmed = true; sandra.mathilde_state = "FAMILY_GUEST"
	_expect(sandra.begin_j14() and sandra.select_j14_variant() == "S27_MUTATION_NO_DISCOVERY", "Mathilde resident alone is not J14 presence proof")

func _exercise_variant_and_posture_matrix() -> void:
	var fixtures := [
		{"state":_completed_j13_state("PAULINE"),"variant":"PAULINE","witness":"Marie","due":"J14 21:30"},
		{"state":_finish_j13(j13_helper._completed_r5b_j12("SANDRA_RULE_CLARIFIED", "SANDRA", "choice_j12_sandra_clear", "C12"), "SANDRA", "j13_sandra_clear", "choice_j13_sandra_clear_confirm"),"variant":"SANDRA","witness":"Mathilde","due":"J15 19:00"},
		{"state":_finish_j13(j13_helper._completed_semantic_j12("MATHILDE_M_B2", "choice_j12_mathilde_m_b2_ack", false), "MATHILDE", "j13_mathilde_m_b2", "choice_j13_mathilde_m_b2_debt"),"variant":"MATHILDE","witness":"Marie","due":"J14 20:30"},
		{"state":_finish_j13(j13_helper._completed_r5b_j12("FIRST_KISS", "RAPHAELLE", "choice_j12_raphaelle_public", "C12"), "RAPHAELLE", "j13_raphaelle", "choice_j13_raphaelle_process"),"variant":"RAPHAELLE","witness":"Marie","due":"J14 22:00"},
		{"state":_finish_j13(j13_helper._completed_r5b_j12("NICO_GUARDRAIL_HELD", "NICO", "choice_j12_nico_accept", "B12"), "NICO", "j13_nico_guardrail", "choice_j13_nico_guardrail_truth"),"variant":"NICO","witness":"Marie","due":""},
	]
	for fixture in fixtures:
		var state = fixture.state; _expect(state.begin_j14(), str(fixture.variant) + " begins"); var evidence: Dictionary = state.j14_presence_contract(); evidence.merge({"evidence_id":"matrix_" + str(fixture.variant).to_lower(),"source_day":"J14","recorded_at":"J14 18:34","physically_present":true,"presented_before_selection":true}, true)
		_expect(state.record_j14_presence_evidence(evidence) and state.select_j14_variant() == fixture.variant and state.j14_witness == fixture.witness, str(fixture.variant) + " consumes explicit witness proof")
		_expect(state.establish_j14_discovery(fixture.variant), str(fixture.variant) + " establishes canonical ledgers"); var base: Dictionary = state.snapshot()
		for posture in [{"suffix":"truth","outcome":"TRUTH_LIMITED"},{"suffix":"lie","outcome":"MINIMIZE_OR_LIE"},{"suffix":"defer","outcome":"PROTECT_AND_DEFER"}]:
			var branch = STATE.new(); _expect(branch.restore_snapshot(base), str(fixture.variant) + " restores for " + str(posture.outcome)); var choice_id := "choice_j14_" + str(fixture.variant).to_lower() + "_" + str(posture.suffix)
			_expect(branch.apply_j14_choice(choice_id, fixture.variant) and branch.j14_outcome == posture.outcome, str(fixture.variant) + " applies " + str(posture.outcome))
			var expects_p14: bool = posture.outcome == "PROTECT_AND_DEFER" and str(fixture.due) != ""
			_expect(branch.promises.has("j14_witness_clarification") == expects_p14, str(fixture.variant) + " P14 posture contract")
			if expects_p14:
				_expect(str(branch.promises["j14_witness_clarification"].get("due_at", "")) == fixture.due, str(fixture.variant) + " exact P14 due")
				var terminal_base: Dictionary = branch.snapshot()
				for resolution in [{"status":"PAID","actor":"Player"},{"status":"AMENDED","actor":str(fixture.witness)},{"status":"FAILED","actor":"Player"},{"status":"CANCELLED","actor":str(fixture.witness)}]:
					var terminal = STATE.new(); _expect(terminal.restore_snapshot(terminal_base) and terminal.resolve_j14_witness_clarification(resolution.status, resolution.actor, str(fixture.due)) and str(terminal.promises["j14_witness_clarification"].get("paid_or_closed_by", "")) == resolution.actor, str(fixture.variant) + " supports attributed P14 " + str(resolution.status))

func _exercise_p15_failed_path() -> void:
	var state = _completed_j13_state("PAULINE"); var provider = _new_provider(state); provider.start_day(); _confirm(provider); _confirm(provider); _present(provider, "thread_marie_private"); provider.apply_choice("thread_marie_private", "choice_j14_pauline_truth")
	_expect(bool(provider.fail_controller_notice("REFUSED").get("accepted", false)) and str(state.promises["j14_inform_trace_controller"].get("status", "")) == "FAILED" and str(state.knowledge.get("fact_trace_controller_not_informed", {}).get("failed_by", "")) == "Player", "P15 exposes attributable refusal path")
	_confirm(provider); _expect(provider.phase == "complete", "failed P15 is terminal before J15")

func _exercise_state_migrations_and_corruption() -> void:
	var end_j13 = _completed_j13_state("PAULINE")
	for version in [23,24]:
		var snapshot: Dictionary = end_j13.snapshot(); snapshot["version"] = version; if version == 23: snapshot.erase("j14_visible_values")
		var restored = STATE.new(); _expect(restored.restore_snapshot(snapshot) and int(restored.snapshot().get("version", -1)) == 25, "state v" + str(version) + " end-J13 migrates to v25")
	var state = _completed_j13_state("PAULINE"); state.begin_j14(); _expect_legacy_state_versions(state, "J14 begun"); var evidence: Dictionary = state.j14_presence_contract(); evidence.merge({"evidence_id":"migration","source_day":"J14","recorded_at":"J14 18:34","physically_present":true,"presented_before_selection":true}, true); state.record_j14_presence_evidence(evidence); state.select_j14_variant(); _expect_legacy_state_versions(state, "J14 selected"); state.establish_j14_discovery("PAULINE"); _expect_legacy_state_versions(state, "J14 discovery presented"); state.apply_j14_choice("choice_j14_pauline_truth", "PAULINE"); _expect_legacy_state_versions(state, "J14 posture selected")
	for version in [23,24]:
		var legacy: Dictionary = state.snapshot(); legacy["version"] = version; var migrated = STATE.new(); _expect(migrated.restore_snapshot(legacy) and migrated._j14_records_consistent(migrated.snapshot()), "state v" + str(version) + " active J14 migrates complete ledgers")
	for corruption in ["presence","creator","visible_values","p15"]:
		var broken: Dictionary = state.snapshot()
		if corruption == "presence": broken["j14_witness_presence_evidence"].erase("reason_near_screen")
		elif corruption == "creator": broken["traces"]["j14_discovery_event_01"]["creator"] = "wrong"
		elif corruption == "visible_values": broken["knowledge"]["fact_witness_saw_limited_trace"]["visible_values"] = {}
		else: broken["promises"]["j14_inform_trace_controller"]["controller"] = "Marie"
		_expect(not STATE.new().restore_snapshot(broken), "corrupt " + corruption + " snapshot fails closed")
	state.resolve_j14_controller_informed("J14 20:15"); _expect_legacy_state_versions(state, "J14 P15 terminal"); state.complete_j14(); _expect_legacy_state_versions(state, "J14 complete")
	state.begin_j15(); _expect_legacy_state_versions(state, "J15 begun"); state.establish_j15_mode(state.select_j15_mode()); _expect_legacy_state_versions(state, "J15 mode selected"); state.apply_j15_choice("choice_j15_clean_acknowledge_marie"); _expect_legacy_state_versions(state, "J15 choice applied"); state.complete_j15(); _expect_legacy_state_versions(state, "J15 complete")

func _expect_legacy_state_versions(state, label: String) -> void:
	for version in [23,24]:
		var legacy: Dictionary = state.snapshot(); legacy["version"] = version; var restored = STATE.new(); _expect(restored.restore_snapshot(legacy) and int(restored.snapshot().get("version", -1)) == 25, label + " v" + str(version) + " migrates")

func _exercise_authentic_v23_state_snapshots() -> void:
	var base_state = _completed_j13_state("PAULINE"); var begun: Dictionary = base_state.snapshot(); begun["version"] = 23; begun["current_day"] = "J14"; begun["day_status"] = "ACTIVE"; begun["j14_variant"] = ""; begun["j14_outcome"] = "UNESTABLISHED"; begun["j14_witness"] = ""
	for key in ["j14_witness_presence_evidence","j14_discovery_mode","j14_visible_fields","j14_visible_values","j14_source_trace_id","j14_secondary_trace_id","j14_player_initial_reaction","j14_player_explanation","j14_j15_obligation_id","j14_controller_notified"]: begun.erase(key)
	var discovered: Dictionary = begun.duplicate(true); discovered["j14_variant"] = "PAULINE"; discovered["j14_witness"] = "Marie"; discovered["traces"]["j14_discovery_event_01"] = {"trace_id":"j14_discovery_event_01","trace_type":"FACT_RECORD","source_day":"J14","discovered_trace_id":discovered["j13_j14_trace_id"],"witness":"Marie","visible_scope":"LIMITED_PREVIEW_OR_NOTIFICATION","source_trace_unchanged":true,"knowledge_created":"fact_witness_saw_limited_trace"}; discovered["knowledge"]["fact_witness_saw_limited_trace"] = {"fact_id":"fact_witness_saw_limited_trace","source_type":"DIRECT_OBSERVATION","source_ref":"j14_discovery_event_01","initial_knowers":["Marie","Player"],"certainty":"CONFIRMED","shareability":"WITNESS_BOUNDED","source_day":"J14","discovered_trace_id":discovered["j13_j14_trace_id"]}
	var chosen: Dictionary = discovered.duplicate(true); chosen["j14_outcome"] = "PAULINE_TRUTH"; chosen["selected_choice_ids"].append("choice_j14_pauline_truth"); chosen["knowledge"]["fact_player_explanation_to_witness"] = {"fact_id":"fact_player_explanation_to_witness","source_type":"DIRECT_STATEMENT","source_ref":"choice_j14_pauline_truth","initial_knowers":["Marie","Player"],"certainty":"CONFIRMED","shareability":"WITNESS_BOUNDED","source_day":"J14"}; chosen["promises"]["j14_inform_trace_controller"] = {"promise_id":"j14_inform_trace_controller","promise_type":"AUDIENCE_NOTICE","status":"ACTIVE","accepted_by_player":true,"due_at":"J14 20:14","outcome":"NOTICE_DUE","controller":"Pauline"}
	var paid: Dictionary = chosen.duplicate(true); paid["promises"]["j14_inform_trace_controller"]["status"] = "PAID"; paid["promises"]["j14_inform_trace_controller"]["paid_or_closed_at"] = "J14 20:14"; paid["promises"]["j14_inform_trace_controller"]["paid_or_closed_by"] = "Player"; paid["knowledge"]["fact_trace_controller_informed_of_audience_breach"] = {"fact_id":"fact_trace_controller_informed_of_audience_breach","source_type":"DIRECT_MESSAGE","source_ref":"j14_inform_trace_controller","initial_knowers":["Pauline","Player"],"certainty":"CONFIRMED","shareability":"PRIVATE","source_day":"J14"}
	var complete: Dictionary = paid.duplicate(true); complete["day_status"] = "COMPLETE"; complete["completed_conversation_ids"].append("chapter_14_discovery"); complete["foreground_history"].append({"day_id":"J14","character_id":"marie","function":"limited_discovery"})
	for fixture in [{"name":"begun","value":begun},{"name":"discovered","value":discovered},{"name":"chosen","value":chosen},{"name":"paid","value":paid},{"name":"complete","value":complete}]:
		var migrated = STATE.new(); _expect(migrated.restore_snapshot(fixture.value) and int(migrated.snapshot().get("version", -1)) == 25 and migrated._j14_records_consistent(migrated.snapshot()), "authentic v23 J14 " + str(fixture.name) + " migrates")

func _exercise_provider_legacy_phases() -> void:
	var state = _completed_j13_state("PAULINE"); var provider = _new_provider(state); var fixtures: Array[Dictionary] = []
	_append_legacy_fixture(fixtures, provider, state, 2)
	provider.start_day(); _confirm(provider); _append_legacy_fixture(fixtures, provider, state, 2)
	_confirm(provider); _append_legacy_fixture(fixtures, provider, state, 2)
	_present(provider, "thread_marie_private"); _append_legacy_fixture(fixtures, provider, state, 2)
	provider.apply_choice("thread_marie_private", "choice_j14_pauline_truth"); _append_legacy_fixture(fixtures, provider, state, 2)
	_confirm(provider); var echo: Dictionary = provider.snapshot(); echo["version"] = 2; var echo_state: Dictionary = state.snapshot(); fixtures.append({"provider":echo,"state":echo_state})
	_present(provider, "thread_pauline_private"); _append_legacy_fixture(fixtures, provider, state, 2)
	_confirm(provider); _append_legacy_fixture(fixtures, provider, state, 2)
	for fixture in fixtures:
		var restored_state = STATE.new(); var restored = PROVIDER.new(); var phase_name := str(fixture.provider.get("phase", "")); _expect(restored_state.restore_snapshot(fixture.state) and restored.initialize(restored_state, {}, {}, [], []) and restored.restore_snapshot(fixture.provider), "provider legacy phase " + phase_name + " migrates")
	var paid_state = STATE.new(); paid_state.restore_snapshot(echo_state); paid_state.resolve_j14_controller_informed("J14 20:15"); var paid_echo: Dictionary = echo.duplicate(true); paid_echo["transcripts_by_thread"]["thread_pauline_private"] = [{"message_id":"msg_j14_controller_001","author_id":"system","timestamp":"20:14","content_type":"TEXT","text":"message générique legacy","media_ref":"","is_player":false,"is_read":false,"source_day":14}]; paid_echo["produced_message_ids"].erase("msg_j14_controller_pauline_001"); paid_echo["produced_message_ids"].erase("msg_j14_controller_pauline_002"); paid_echo["produced_message_ids"]["msg_j14_controller_001"] = true
	var migrated_paid = PROVIDER.new(); _expect(migrated_paid.initialize(paid_state, {}, {}, [], []) and migrated_paid.restore_snapshot(paid_echo) and migrated_paid.phase == "day_close" and not migrated_paid.produced_message_ids.has("msg_j14_controller_001") and migrated_paid.produced_message_ids.has("msg_j14_controller_pauline_001"), "legacy paid echo migrates without double payment or generic message")
	var incoming_fixture: Dictionary = fixtures[2]; var corruptions: Array[Dictionary] = []
	var bad_pivot: Dictionary = incoming_fixture.provider.duplicate(true); bad_pivot["version"] = 4; bad_pivot["selected_pivot"] = "NICO"; corruptions.append(bad_pivot)
	var bad_choices: Dictionary = incoming_fixture.provider.duplicate(true); bad_choices["version"] = 4; bad_choices["pending_choice_ids_by_thread"]["thread_marie_private"] = ["choice_j14_nico_truth"]; corruptions.append(bad_choices)
	var bad_messages: Dictionary = incoming_fixture.provider.duplicate(true); bad_messages["version"] = 4; bad_messages["produced_message_ids"].erase("msg_j14_pauline_001"); corruptions.append(bad_messages)
	for corrupted in corruptions:
		var corrupted_state = STATE.new(); var rejected = PROVIDER.new(); _expect(corrupted_state.restore_snapshot(incoming_fixture.state) and rejected.initialize(corrupted_state, {}, {}, [], []) and not rejected.restore_snapshot(corrupted), "corrupt J14 provider snapshot fails closed")

func _append_legacy_fixture(fixtures: Array[Dictionary], provider, state, version: int) -> void:
	var provider_snapshot: Dictionary = provider.snapshot(); provider_snapshot["version"] = version; fixtures.append({"provider":provider_snapshot,"state":state.snapshot()})

func _finish_j13(state, pivot: String, segment_id: String, choice_id: String):
	_expect(state.begin_j13() and state.set_j13_priority(pivot) and state.deliver_j13_priority(pivot, segment_id) and state.apply_j13_choice(choice_id, pivot) and state.complete_j13(), pivot + " route completes J13")
	return state

func _completed_j13_state(pivot: String):
	var state = j13_helper._completed_network_state(pivot == "PAULINE")
	_expect(state.begin_j13(), "fixture enters J13"); _expect(state.set_j13_priority(pivot), "fixture selects J13 pivot")
	var choice := "choice_j13_pauline_rule" if pivot == "PAULINE" else "choice_j13_respiration_bread"
	_expect(state.deliver_j13_priority(pivot, "j13_pauline" if pivot == "PAULINE" else "j13_respiration"), "fixture delivers J13 consequence")
	_expect(state.apply_j13_choice(choice, pivot), "fixture resolves J13 pivot"); _expect(state.complete_j13(), "fixture completes J13")
	return state

func _new_provider(state):
	var provider = PROVIDER.new(); _expect(provider.initialize(state, {}, {}, [], []), "J14 provider initializes"); return provider

func _present(provider, thread_id: String) -> void:
	for message in provider.transcript_for(thread_id):
		if int(message.get("source_day", 0)) == 14 and not bool(message.get("is_player", false)) and not provider.presented_time_message_ids.has(str(message.get("message_id", ""))): provider.mark_message_presented(str(message.get("message_id", "")))
	_expect(provider.mark_thread_batch_presented(thread_id), "batch presents for " + thread_id)

func _confirm(provider) -> void:
	var target_text := str(provider.pending_transition.get("to_time", ""))
	if target_text != "":
		var target := TIME.parse_narrative_time(target_text)
		if target >= provider.current_narrative_time_minutes(): provider.commit_narrative_time(target)
	_expect(bool(provider.confirm_transition().get("accepted", false)), "transition confirms")

func _expect_round_trip(provider, label: String) -> void:
	var snap: Dictionary = provider.snapshot(); var restored = PROVIDER.new(); _expect(restored.initialize(provider.state, {}, {}, [], []), label + " initializes"); _expect(restored.restore_snapshot(snap), label + " restores"); _expect(restored.snapshot() == snap, label + " is exact")

func _expect_state_round_trip(state, label: String) -> void:
	var snap: Dictionary = state.snapshot(); var restored = STATE.new(); var accepted := restored.restore_snapshot(snap)
	_expect(accepted, label + " restores"); _expect(accepted and restored.snapshot() == snap, label + " is exact")

func _expect(condition: bool, label: String) -> void:
	if not condition: failures.append(label)
