import json, unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class RuntimeS114J14PlayableStaticTests(unittest.TestCase):
    def read(self, path): return (ROOT / path).read_text(encoding="utf-8")
    def load(self, path): return json.loads(self.read(path))

    def test_map_and_bounded_discovery_routes(self):
        data = self.load("game/data/runtime/season_1/j14_runtime_map.json")
        self.assertEqual("PLAYABLE", data["implementation_status"])
        corpus = self.read("game/data/conversations/chapter_14_discovery.json")
        for segment in ["j14_pauline", "j14_sandra", "j14_mathilde", "j14_raphaelle", "j14_nico", "j14_composite", "j14_controller_pauline", "j14_controller_sandra", "j14_controller_mathilde", "j14_controller_raphaelle", "j14_controller_nico"]:
            self.assertIn(segment, corpus)
        self.assertNotIn("j14_fallback", corpus)
        self.assertIn("to_presence_context", data)
        for choice in ["_truth", "_lie", "_defer"]:
            self.assertIn(choice, corpus)

    def test_state_keeps_trace_and_knowledge_separate(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in ["func begin_j14", "func select_j14_variant", "func establish_j14_discovery", "func apply_j14_choice", "func resolve_j14_controller_informed", "func complete_j14"]:
            self.assertIn(token, state)
        for canonical_id in ["j14_discovery_event_01", "fact_witness_saw_limited_trace", "fact_trace_controller_informed_of_audience_breach", "fact_player_explanation_to_witness", "j14_witness_clarification", "j14_inform_trace_controller"]:
            self.assertIn(canonical_id, state)
        self.assertIn('"source_trace_unchanged":true', state)
        self.assertIn('"certainty":"OBSERVED"', state)
        self.assertIn('"context_certainty":"INCOMPLETE"', state)
        self.assertIn('"PAULINE":"J14 21:30"', state)

    def test_selection_uses_only_real_sources_and_composite_is_fail_closed(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for trace_id in ["j13_pauline_private_version_01", "j13_raphaelle_masked_version_01", "j13_nico_alibi_or_hour_message_01", "j11_sandra_chosen_image_01", "j11_mathilde_physical_aftercare_01", "j12_laverriere_public_group_set_01"]:
            self.assertIn(trace_id, state)
        selection = state[state.index("func select_j14_variant"):state.index("func _j14_contract_for_variant")]
        self.assertNotIn('"COMPOSITE"', selection)
        self.assertIn('"j12_laverriere_public_group_set_01":"S27_MUTATION_NO_DISCOVERY"', selection)
        self.assertIn("not _j14_presence_evidence_admissible", selection)

    def test_provider_delays_discovery_and_controller_payment_until_presentation(self):
        provider = self.read("game/scripts/runtime/season_1/J14RuntimeProvider.gd")
        start = provider[provider.index("func start_day"):provider.index("func apply_choice")]
        transition = provider[provider.index("func confirm_transition"):provider.index("func mark_thread_batch_presented")]
        presentation = provider[provider.index("func mark_thread_batch_presented"):provider.index("func snapshot")]
        self.assertNotIn("establish_j14_discovery", start)
        self.assertNotIn("state.establish_j14_discovery(selected_pivot)", transition)
        self.assertIn("state.establish_j14_discovery(selected_pivot)", presentation)
        self.assertNotIn("resolve_j14_controller_informed", transition)
        self.assertIn("state.resolve_j14_controller_informed", presentation)

    def test_handoff_snapshot_and_no_new_media(self):
        j13 = self.load("game/data/runtime/season_1/j13_runtime_map.json")
        self.assertEqual("day_handoff", j13["day_end"]["transition_mode"])
        self.assertFalse(j13["day_end"]["content_end"])
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertIn("const SNAPSHOT_VERSION := 21", season)
        self.assertIn("func _handoff_to_j14", season)
        provider = self.read("game/scripts/runtime/season_1/J14RuntimeProvider.gd")
        self.assertIn("const J14_SNAPSHOT_VERSION := 4", provider)
        self.assertIn("func restore_snapshot", provider)
        corpus = self.load("game/data/conversations/chapter_14_discovery.json")
        self.assertNotIn("media_ref", json.dumps(corpus))


if __name__ == "__main__": unittest.main()
