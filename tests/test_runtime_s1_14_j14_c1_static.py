import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RuntimeS114J14C1StaticTests(unittest.TestCase):
    def read(self, path):
        return (ROOT / path).read_text(encoding="utf-8")

    def load(self, path):
        return json.loads(self.read(path))

    def block(self, source, start, end):
        return source[source.index(start):source.index(end, source.index(start))]

    def assert_tokens(self, source, tokens):
        for token in tokens:
            with self.subTest(token=token):
                self.assertIn(token, source)

    def test_c1_marie_absence_is_negative_evidence_not_overridden_by_j12_history(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        evidence = self.block(
            state,
            "func record_j14_presence_evidence",
            "func select_j14_variant",
        )
        self.assertNotIn(
            '_j13_trace_accessible_for_j14("j12_laverriere_public_group_set_01")',
            evidence,
        )
        self.assertNotIn('public_trace.get("subjects", []).has("Marie")', evidence)
        self.assertIn('not bool(evidence.get("physically_present", false))', evidence)
        self.assertIn('not bool(evidence.get("presented_before_selection", false))', evidence)

    def test_c1_mathilde_resident_alone_is_not_proof_of_shared_screen_presence(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        evidence = self.block(
            state,
            "func record_j14_presence_evidence",
            "func select_j14_variant",
        )
        self.assertNotIn("household_rhythm_confirmed and mathilde_state", evidence)
        self.assertNotIn("fact_mathilde_left_household", evidence)
        self.assertIn('not bool(evidence.get("physically_present", false))', evidence)
        self.assertIn('evidence.get("reason_near_screen", "")', evidence)

    def test_c1_missing_near_screen_reason_fails_closed(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        recording = self.block(
            state,
            "func record_j14_presence_evidence",
            "func select_j14_variant",
        )
        selection = self.block(state, "func select_j14_variant", "func _set_j14_no_discovery_mutation")
        self.assertIn('evidence.get("reason_near_screen", "")', recording)
        self.assertIn('expected.get("reason_near_screen", "")', recording)
        self.assertIn("not _j14_presence_evidence_admissible", selection)
        self.assertIn("_set_j14_no_discovery_mutation()", selection)

    def test_c1_fallback_is_s27_mutation_without_discovery_segment(self):
        corpus = self.load("game/data/conversations/chapter_14_discovery.json")
        segment_ids = {segment["id"] for segment in corpus["segments"]}
        self.assertNotIn("j14_fallback", segment_ids)

        provider = self.read("game/scripts/runtime/season_1/J14RuntimeProvider.gd")
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        runtime_map = self.read("game/data/runtime/season_1/j14_runtime_map.json")
        self.assertIn("S27_MUTATION_NO_DISCOVERY", provider + state + runtime_map)
        self.assertNotIn('"j14_" + selected_pivot.to_lower()', self.block(
            provider, '"to_discovery":', '"to_controller":'
        ))

    def test_c1_fallback_never_creates_t20_f26_p14_or_p15(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        fallback_mutation = self.block(
            state,
            "func _set_j14_no_discovery_mutation",
            "func _j14_contract_for_variant",
        )
        self.assertIn('j14_variant = "S27_MUTATION_NO_DISCOVERY"', fallback_mutation)
        for forbidden in [
            "j14_discovery_event_01",
            "fact_witness_saw_limited_trace",
            "j14_witness_clarification",
            "j14_inform_trace_controller",
        ]:
            with self.subTest(forbidden=forbidden):
                self.assertNotIn(forbidden, fallback_mutation)
        establish = self.block(
            state,
            "func establish_j14_discovery",
            "func apply_j14_choice",
        )
        self.assertNotIn('"FALLBACK"', establish)
        complete = self.block(state, "func complete_j14", "func begin_j15")
        self.assertNotIn('"limited_discovery"', complete)

    def test_c1_t20_contains_the_complete_canonical_fact_record(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        establish = self.block(
            state,
            "func establish_j14_discovery",
            "func apply_j14_choice",
        )
        self.assert_tokens(establish, [
            '"trace_id":"j14_discovery_event_01"',
            '"trace_type":"FACT_RECORD"',
            '"source_day":"J14"',
            '"source_scene":"S27 photo au mauvais écran"',
            '"creator":"système narratif à partir d’une trace existante"',
            '"subjects":[j14_witness,"Player",controller]',
            '"owner":"état narratif"',
            '"initial_audience":"NOT_APPLICABLE"',
            '"current_audience":"NOT_APPLICABLE"',
            '"storage_location":"registre de connaissances"',
            '"saving_rule":"NONE"',
            '"transfer_rule":"FORBIDDEN"',
            '"replaces_or_derives_from":[j14_source_trace_id]',
            '"current_state":"ACTIVE"',
            '"discovered_trace_id"',
            '"witness_id"',
            '"discovery_mode"',
            '"visible_fields"',
            '"visible_duration"',
            '"player_reaction"',
            '"source_trace_unchanged":true',
        ])

    def test_c1_f26_contains_only_observed_visible_values(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        establish = self.block(
            state,
            "func establish_j14_discovery",
            "func apply_j14_choice",
        )
        self.assert_tokens(establish, [
            '"fact_id":"fact_witness_saw_limited_trace"',
            '"source_type":"DIRECT_OBSERVATION"',
            '"source_ref":"j14_discovery_event_01"',
            '"certainty":"OBSERVED"',
            '"context_certainty":"INCOMPLETE"',
            '"shareability":"FACTUAL_ONLY"',
            '"witness_id"',
            '"discovered_trace_id"',
            '"visible_fields"',
            '"visible_values"',
            '"visible_duration"',
            '"player_reaction"',
        ])
        contracts = self.block(
            state,
            "func _j14_contract_for_variant",
            "func establish_j14_discovery",
        )
        self.assert_tokens(contracts, [
            '"PAULINE":{"witness_id":"Marie","discovery_mode":"OPEN_CONVERSATION","visible_fields":["thread_name","thumbnail"]',
            '"SANDRA":{"witness_id":"Mathilde","discovery_mode":"OPEN_CONVERSATION","visible_fields":["thread_name","thumbnail"]',
            '"MATHILDE":{"witness_id":"Marie","discovery_mode":"TEXT_NOTIFICATION","visible_fields":["sender_name","first_line","received_at"]',
            '"RAPHAELLE":{"witness_id":"Marie","discovery_mode":"OPEN_GALLERY_OR_SELECTION","visible_fields":["thumbnail","thread_name"]',
            '"NICO":{"witness_id":"Marie","discovery_mode":"TEXT_NOTIFICATION","visible_fields":["sender_name","first_line","received_at"]',
        ])

    def test_c1_deep_consistency_validates_every_t20_and_f26_field(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        consistency = self.block(
            state,
            "func _j14_records_consistent",
            "func _j15_records_consistent",
        )
        for field in [
            "creator", "subjects", "owner", "initial_audience", "current_audience",
            "storage_location", "saving_rule", "transfer_rule", "replaces_or_derives_from",
            "visible_fields", "visible_values", "visible_duration", "player_reaction",
            "source_trace_unchanged",
        ]:
            with self.subTest(field=field):
                self.assertGreaterEqual(consistency.count(field), 1)
        self.assertIn('discovery.get("visible_values", {})', consistency)
        self.assertIn('discovery_fact.get("visible_values", {})', consistency)
        self.assertIn('discovery_fact.get("player_reaction", "")', consistency)

    def test_c1_p14_has_exact_statuses_due_times_and_authorship(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        p14 = self.block(
            state,
            "func _create_j14_witness_clarification",
            "func _j14_private_audience_compromised",
        )
        self.assert_tokens(p14, [
            '"PAULINE":"J14 21:30"',
            '"SANDRA":"J15 19:00"',
            '"MATHILDE":"J14 20:30"',
            '"RAPHAELLE":"J14 22:00"',
            '"status":"ACTIVE"',
            '"created_by":"Player"',
            '"proposed_to":j14_witness',
            '"accepted_by_player":true',
            '"source_choice_id":choice_id',
            '"failure_effect":failure_effect',
        ])
        consistency = self.block(
            state,
            "func _j14_records_consistent",
            "func _j15_records_consistent",
        )
        for status in ["ACTIVE", "AMENDED", "PAID", "FAILED", "CANCELLED"]:
            self.assertIn(status, consistency)

    def test_c1_p14_terminal_transition_uses_its_due_and_attributed_actor(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        j15 = self.block(state, "func apply_j15_choice", "func complete_j15")
        self.assertNotIn('clarification["paid_or_closed_at"] = "J15 20:00"', j15)
        self.assertIn('clarification.get("due_at", "")', j15)
        self.assertIn('clarification["paid_or_closed_by"]', j15)
        terminal = self.block(
            state,
            "func resolve_j14_witness_clarification",
            "func j14_clarification_due_on_j14",
        )
        self.assertIn('["PAID","AMENDED","FAILED","CANCELLED"]', terminal)
        self.assertIn('status in ["AMENDED","CANCELLED"] and actor != j14_witness', terminal)
        self.assertIn('promise["paid_or_closed_at"] = presented_at', terminal)
        self.assertIn('promise["paid_or_closed_by"] = actor', terminal)

    def test_c1_p15_is_paid_only_after_specific_player_message_presentation(self):
        provider = self.read("game/scripts/runtime/season_1/J14RuntimeProvider.gd")
        transition = self.block(
            provider,
            "func confirm_transition",
            "func mark_thread_batch_presented",
        )
        presentation = self.block(
            provider,
            "func mark_thread_batch_presented",
            "func snapshot",
        )
        self.assertNotIn("resolve_j14_controller_informed", transition)
        self.assertIn("resolve_j14_controller_informed", presentation)

        corpus = self.load("game/data/conversations/chapter_14_discovery.json")
        controllers = [segment for segment in corpus["segments"] if segment["id"].startswith("j14_controller_")]
        self.assertEqual(5, len(controllers))
        for segment in controllers:
            with self.subTest(segment=segment["id"]):
                self.assertEqual("player", segment["messages"][0]["sender"])
                self.assertTrue(segment["messages"][0]["text"].strip())

    def test_c1_p15_has_failed_and_paid_paths_after_real_presentation(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        self.assertIn("func fail_j14_controller_notice", state)
        self.assertIn("fact_trace_controller_not_informed", state)
        controller = self.block(
            state,
            "func resolve_j14_controller_informed",
            "func complete_j14",
        )
        self.assertIn('promise["status"] = "PAID"', controller)
        self.assertIn('promise["status"] = "FAILED"', controller)
        complete = self.block(state, "func complete_j14", "func begin_j15")
        self.assertRegex(complete, r'\["PAID",\s*"FAILED"\]')
        consistency = self.block(
            state,
            "func _j14_records_consistent",
            "func _j15_records_consistent",
        )
        self.assertRegex(consistency, r'\["ACTIVE",\s*"PAID",\s*"FAILED"\]')

    def test_c1_state_accepts_only_current_snapshot_and_rejects_corruption(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        restore = self.block(state, "func restore_snapshot", "func _snapshot_ledgers_have_dictionary_records")
        self.assertIn("if version != SNAPSHOT_VERSION", restore)
        self.assertNotIn("func _migrate_", state)
        posture = self.block(state, "func _j14_posture_for_choice", "func _j14_player_statement_for_choice")
        self.assertIn('variant == "NICO" and choice_id == "choice_j14_nico_defer": return "PROTECT_AND_ANSWER_NOW"', posture)
        consistency = self.block(state, "func _j14_records_consistent", "func _j15_records_consistent")
        self.assertIn('outcome == "PROTECT_AND_ANSWER_NOW" and variant != "NICO"', consistency)
        handoff = self.block(state, "func select_j15_mode", "func establish_j15_mode")
        self.assertIn('j14_outcome == "PROTECT_AND_ANSWER_NOW": return "NO_OBLIGATION"', handoff)
    def test_c1_j14_current_snapshot_covers_all_phases_and_fail_closed_corruptions(self):
        provider = self.read("game/scripts/runtime/season_1/J14RuntimeProvider.gd")
        restore = self.block(provider, "func restore_snapshot", "func _append_j14_clarification_messages")
        self.assertIn("const J14_SNAPSHOT_VERSION := 4", provider)
        self.assertNotIn("LEGACY_J14_SNAPSHOT_VERSIONS", provider)
        self.assertIn("int(value.get(\"version\", -1)) != J14_SNAPSHOT_VERSION", restore)
        expected_phases = {
            "day_start_pending", "to_presence_context", "to_discovery", "priority_incoming",
            "priority_choice", "to_controller", "echo_incoming", "to_clarification",
            "clarification_incoming", "day_close", "complete",
        }
        match = re.search(r'const J14_PHASES := \[([^]]+)\]', provider)
        self.assertIsNotNone(match)
        self.assertEqual(expected_phases, set(re.findall(r'"([^"]+)"', match.group(1))))
        self.assertIn("return _restored_phase_consistent()", restore)

if __name__ == "__main__":
    unittest.main()
