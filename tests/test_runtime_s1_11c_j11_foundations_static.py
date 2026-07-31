import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RuntimeS111CJ11FoundationsStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def load(self, relative: str):
        return json.loads(self.read(relative))

    def test_foundation_files_exist_without_exposing_empty_j11(self):
        for path in [
            "game/data/runtime/season_1/j11_runtime_map.json",
            "game/scripts/runtime/season_1/J11ContinuationSelector.gd",
            "game/scripts/runtime/season_1/J11RuntimeProvider.gd",
        ]:
            self.assertTrue((ROOT / path).exists(), path)
        j10 = self.load("game/data/runtime/season_1/j10_runtime_map.json")
        j11 = self.load("game/data/runtime/season_1/j11_runtime_map.json")
        self.assertEqual("CONTENT_END", j10["day_end"]["transition_mode"])
        self.assertTrue(j10["day_end"]["content_end"])
        self.assertEqual("FOUNDATION_ONLY", j11["implementation_status"])
        self.assertEqual({}, j11["conversation_paths"])
        self.assertEqual([], j11["gallery_presentations"])

    def test_selector_contains_exact_22_outcomes_and_is_pure(self):
        selector = self.read("game/scripts/runtime/season_1/J11ContinuationSelector.gd")
        expected = {
            "SANDRA": {
                "CAFE_HELD_CALM_PRESENCE": "RESPIRATION",
                "CAFE_HELD_MISSING_NAMED": "SANDRA",
                "CAFE_HELD_FRIENDSHIP_BOUNDED": "RESPIRATION",
                "CAFE_SATURDAY_CONDITIONAL": "RESPIRATION",
                "CAFE_OPPORTUNITY_CLOSED": "RESPIRATION",
            },
            "MATHILDE": {
                "OUTFIT_PRECISE_NON_APPROPRIATIVE": "MATHILDE",
                "OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED": "MATHILDE",
                "OUTFIT_PRACTICAL_WEATHER": "RESPIRATION",
            },
            "RAPHAELLE": {
                "PROCESS_HELPED_VISIT_BOUNDED": "RAPHAELLE",
                "PROCESS_HELPED_REMOTE": "RAPHAELLE",
                "RESULT_ONLY": "RAPHAELLE",
                "PROFESSIONAL_BOUNDARY": "RESPIRATION",
            },
            "NICO": {
                "DIFFERENCE_ACKNOWLEDGED_NO_IMAGE": "NICO",
                "NICO_OBSERVATION_REQUESTED": "NICO",
                "COMPARISON_CLOSED": "RESPIRATION",
                "THURSDAY_MEETING_CANCELLED": "RESPIRATION",
            },
            "NONE": {
                "DUE_DINNER_PAID": "MARIE",
                "DUE_DINNER_FAILED_LATE": "MARIE",
                "DUE_DINNER_CANCELLED": "MARIE",
                "ORDINARY_MEAL_JOINED": "MARIE",
                "LATE_RETURN_SEPARATE": "MARIE",
                "ABSENCE_ANNOUNCED": "MARIE",
            },
        }
        self.assertEqual(22, sum(len(outcomes) for outcomes in expected.values()))
        for source_pivot, outcomes in expected.items():
            self.assertIn(f'"{source_pivot}": {{', selector)
            for outcome, destination in outcomes.items():
                self.assertRegex(selector, rf'"{re.escape(outcome)}": \["{destination}",')
        rule_lines = re.findall(r'^\s*"[A-Z0-9_]+": \["(?:SANDRA|MATHILDE|RAPHAELLE|NICO|MARIE|RESPIRATION)"', selector, re.MULTILINE)
        self.assertEqual(22, len(rule_lines))
        for forbidden in ["state.", "promises[", "traces[", "knowledge["]:
            self.assertNotIn(forbidden, selector)
        self.assertIn('"blocking_obligation_ids"', selector)
        self.assertIn('"blocking_promise_ids"', selector)
        self.assertIn('"evidence"', selector)

    def test_state_has_j11_ledgers_fail_closed_fields_and_methods(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in [
            "var obligations: Dictionary = {}",
            'var j11_pivot := ""',
            'var j11_pivot_reason := ""',
            'var j11_pivot_outcome := ""',
            'var j11_physical_level := "NONE"',
            "var mathilde_has_independent_sleep_option := false",
            "var mathilde_can_leave_safely := false",
            "var marie_absence_not_engineered := false",
            "func begin_j11() -> bool",
            "func set_j11_continuation",
            "func apply_j11_p10_choice",
            "func pay_j11_p10",
            "func confirm_or_expire_j11_p11_counterparty",
            "func establish_j11_mathilde_physical_event",
            "func establish_j11_sandra_private_image",
            "func establish_j11_raphaelle_result",
            "func establish_j11_marie_adult_event",
            "func resolve_j11_aftercare",
            "func _j11_records_consistent",
        ]:
            self.assertIn(token, state)
        self.assertIn('pivot == "RESPIRATION"', state)
        self.assertIn('restored_obligations.is_empty()', state)

    def test_p10_p11_and_aftercare_follow_locked_contracts(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        p10 = state.split("func apply_j11_p10_choice", 1)[1].split("func pay_j11_p10", 1)[0]
        for token in [
            '"choice_j11_p10_maintain"', '"MAINTAINED"',
            '"choice_j11_p10_cancel"', 'p10["status"] = "CANCELLED"',
            '"choice_j11_p10_late"', '"LATE_INCOMPATIBLE"',
        ]:
            self.assertIn(token, p10)
        payment = state.split("func pay_j11_p10", 1)[1].split("func confirm_or_expire_j11_p11_counterparty", 1)[0]
        self.assertIn('p10["status"] = "PAID"', payment)
        self.assertIn('p10["status"] = "FAILED"', payment)
        self.assertIn('p10["paid_or_closed_at"] = "J11 20:30"', payment)
        p11 = state.split("func confirm_or_expire_j11_p11_counterparty", 1)[1].split("func configure_j11_mathilde_safety", 1)[0]
        self.assertIn('p11["counterparty_confirmed_by"] = "Sandra"', p11)
        self.assertNotIn('p11["status"] = "ACTIVE"', p11)
        self.assertIn('p11["status"] = "EXPIRED"', p11)
        self.assertIn("func _j11_p10_blocks_external_physical", state)
        raphaelle_outcome = state.split("func set_j11_raphaelle_outcome", 1)[1].split("func establish_j11_marie_adult_event", 1)[0]
        for gate in ["attraction_named", "reciprocal_consent", "distinct_meeting", "_j11_p10_blocks_external_physical()", "_has_due_obligation()"]:
            self.assertIn(gate, raphaelle_outcome)
        obligation = state.split("func _create_j11_aftercare", 1)[1].split("func _j11_selection_matches_j10", 1)[0]
        for field in ["obligation_id", "obligation_type", "created_at", "concerned_people", "due_before", "status", "paid_by", "failure_effect"]:
            self.assertIn(f'"{field}"', obligation)

    def test_trace_fact_pairs_are_atomic_and_mathilde_trace_is_text(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for trace_id, fact_id in [
            ("j11_sandra_chosen_image_01", "fact_sandra_chose_private_image_for_player"),
            ("j11_raphaelle_chosen_result_01", "fact_raphaelle_chose_player_for_result_image"),
            ("j11_mathilde_physical_aftercare_01", "fact_mathilde_physical_event_occurred"),
        ]:
            self.assertIn(f'traces["{trace_id}"]', state)
            self.assertIn(f'knowledge["{fact_id}"]', state)
        mathilde = state.split("func establish_j11_mathilde_physical_event", 1)[1].split("func establish_j11_sandra_private_image", 1)[0]
        self.assertIn('"trace_type": "TEXT_MESSAGE"', mathilde)
        self.assertNotIn('"trace_type": "PHOTO"', mathilde)
        raphaelle = state.split("func establish_j11_raphaelle_result", 1)[1].split("func set_j11_raphaelle_outcome", 1)[0]
        self.assertIn('"creator": "Maud"', raphaelle)
        self.assertIn('"selected_by": "Raphaëlle"', raphaelle)
        self.assertIn('"controller": "Raphaëlle"', raphaelle)

    def test_snapshot_versions_and_explicit_foundation_handoff(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        provider = self.read("game/scripts/runtime/season_1/J11RuntimeProvider.gd")
        self.assertIn("const SNAPSHOT_VERSION := 9", state)
        self.assertIn("const SNAPSHOT_VERSION := 10", season)
        self.assertIn("const SNAPSHOT_VERSION := 1", provider)
        self.assertIn('version < SNAPSHOT_VERSION and str(value.get("current_day", "")) == "J11"', state)
        self.assertIn('if str(value.get("current_day", "")) in ["J08", "J09", "J10", "J11"]:', state)
        self.assertIn('not _j11_selection_matches_j10(pivot, reason, str(value.get("j10_pivot", "")), str(value.get("j10_pivot_outcome", "")))', state)
        self.assertIn('version < SNAPSHOT_VERSION and str(value.get("active_day", "")) == "J11"', season)
        self.assertIn('"J11": j11_provider.snapshot() if j11_provider != null else {}', season)
        self.assertIn("func begin_j11_foundation_handoff", season)
        self.assertIn("func _handoff_to_j11", season)
        self.assertEqual(1, season.count('state.restore_snapshot(value["state"])'))
        self.assertIn('"foundation_handoff"', season)
        self.assertNotIn('_handoff_to_j11()', season.split("func begin_j11_foundation_handoff", 1)[0])


if __name__ == "__main__":
    unittest.main()
