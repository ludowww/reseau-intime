import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RuntimeS113J13PlayableStaticTests(unittest.TestCase):
    def read(self, path):
        return (ROOT / path).read_text(encoding="utf-8")

    def load(self, path):
        return json.loads(self.read(path))

    def test_map_and_exact_canonical_variant_matrix(self):
        runtime_map = self.load("game/data/runtime/season_1/j13_runtime_map.json")
        self.assertEqual("PLAYABLE", runtime_map["implementation_status"])
        data = self.load("game/data/conversations/chapter_13_priority.json")
        segments = {segment["id"]: segment for segment in data["segments"]}
        expected = {
            "j13_pauline",
            "j13_raphaelle",
            "j13_raphaelle_pressed",
            "j13_raphaelle_boundary",
            "j13_nico_guardrail",
            "j13_nico_rivalry",
            "j13_sandra_clear",
            "j13_sandra_delayed",
            "j13_sandra_exit",
            "j13_mathilde_look",
            "j13_mathilde_m_b1",
            "j13_mathilde_m_b2",
            "j13_mathilde_m_b3",
            "j13_mathilde_clean_stop",
            "j13_mathilde_distance",
            "j13_mathilde_failed",
            "j13_marie_close",
            "j13_marie_non_adult",
            "j13_marie_no_bandage",
            "j13_marie_distance",
            "j13_respiration",
            "j13_marie_echo",
        }
        self.assertEqual(expected, set(segments))
        self.assertEqual(len(data["segments"]), len(segments))
        choice_ids = [choice["id"] for segment in data["segments"] for choice in segment.get("choices", [])]
        self.assertEqual(len(choice_ids), len(set(choice_ids)))
        self.assertEqual(63, len(choice_ids))

    def test_nico_is_neutral_and_boundary_paths_have_no_private_image(self):
        data = self.load("game/data/conversations/chapter_13_priority.json")
        segments = {segment["id"]: segment for segment in data["segments"]}
        nico = json.dumps(
            [segments["j13_nico_guardrail"], segments["j13_nico_rivalry"]],
            ensure_ascii=False,
        )
        for invented_claim in ["Marie m’a demandé", "J’ai répondu l’heure réelle", "elle m’a demandé l’heure"]:
            self.assertNotIn(invented_claim, nico)
        self.assertIn("Je préfère être clair sur hier.", nico)
        self.assertIn("Je ne construis pas une heure ou une version à ta place.", nico)
        for segment_id in ["j13_raphaelle_pressed", "j13_raphaelle_boundary"]:
            self.assertNotIn("PHOTO", json.dumps(segments[segment_id]))

    def test_obligation_is_authoritative_and_delivery_is_atomic(self):
        provider = self.read("game/scripts/runtime/season_1/J13RuntimeProvider.gd")
        selector = provider[provider.index("func _select_pivot"):provider.index("func _pauline_eligible")]
        self.assertIn('state.obligations.get("j12_priority_consequence_j13", {})', selector)
        for key in ["status", "route", "origin", "concerned_people", "due_at", "failure_effect"]:
            self.assertIn('"%s"' % key, selector)
        self.assertIn('str(obligation.get("status", "")) != "DUE"', selector)
        self.assertIn("route != state.j12_priority_route", selector)
        self.assertIn('"NICO": return "" if state.j11_pivot_outcome == "NICO_CLEAN_CLOSE"', selector)

        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        select_block = state[state.index("func set_j13_priority"):state.index("func j13_pauline_eligible")]
        self.assertNotIn("j13_pauline_private_version_01", select_block)
        self.assertNotIn("j13_raphaelle_masked_version_01", select_block)
        delivery_block = state[state.index("func deliver_j13_priority"):state.index("func apply_j13_choice")]
        self.assertIn("j13_pauline_private_version_01", delivery_block)
        self.assertIn("j13_raphaelle_masked_version_01", delivery_block)
        confirm_block = provider[provider.index("func confirm_transition"):provider.index("func mark_message_presented")]
        self.assertLess(confirm_block.index("deliver_j13_priority"), confirm_block.index("_enter_segment"))

    def test_every_authored_choice_has_an_explicit_settlement(self):
        data = self.load("game/data/conversations/chapter_13_priority.json")
        choice_ids = [choice["id"] for segment in data["segments"] for choice in segment.get("choices", [])]
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        settlement = state[state.index("func _j13_resolution_for_choice"):state.index("func _close_j13_trace")]
        for choice_id in choice_ids:
            self.assertIn('"%s"' % choice_id, settlement)
        for status in ['return "PAID"', 'return "FAILED"', 'return "CLOSED"']:
            self.assertIn(status, settlement)

    def test_handoff_requires_accessible_player_trace(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in [
            "func _j13_trace_accessible_for_j14",
            'trace.get("current_audience", []).has("Player")',
            'trace.get("eligible_for_j14", canonical_legacy)',
            "func _j13_records_consistent",
            "not _j13_trace_accessible_for_j14(j13_j14_trace_id)",
        ]:
            self.assertIn(token, state)
        corpus = self.read("game/data/conversations/chapter_13_priority.json")
        self.assertIn("S1_A4_J13_DPH_PAULINE_PRIVATE_VERSION_01", corpus)
        self.assertIn("S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01", corpus)
        self.assertNotIn("S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT", corpus)

    def test_snapshot_versions_are_unchanged_and_restore_checks_phase(self):
        provider = self.read("game/scripts/runtime/season_1/J13RuntimeProvider.gd")
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertIn("const SNAPSHOT_VERSION := 1", provider)
        self.assertIn("const SNAPSHOT_VERSION := 22", state)
        self.assertIn("const SNAPSHOT_VERSION := 21", season)
        for token in ["func restore_snapshot", "func _restored_phase_consistent", "selected_pivot != state.j13_pivot"]:
            self.assertIn(token, provider)


if __name__ == "__main__":
    unittest.main()
