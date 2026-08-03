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

    def test_visual_delivery_matrix_and_placeholder_contracts_are_exact(self):
        data = self.load("game/data/conversations/chapter_13_priority.json")
        segments = {segment["id"]: segment for segment in data["segments"]}
        photos = {
            segment_id: [message for message in segment["messages"] if message.get("content_type") == "PHOTO"]
            for segment_id, segment in segments.items()
        }
        self.assertEqual({"j13_pauline": 1, "j13_raphaelle": 1, "j13_marie_close": 1}, {key: len(value) for key, value in photos.items() if value})
        private_contracts = {
            "j13_pauline": (
                "msg_j13_pauline_photo_001",
                "j13_pauline_private_version_01",
                "S1_A4_J13_DPH_PAULINE_PRIVATE_VERSION_01",
                "Visuel canonique non produit · quatrième frame privée Pauline",
            ),
            "j13_raphaelle": (
                "msg_j13_raphaelle_photo_001",
                "j13_raphaelle_masked_version_01",
                "S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01",
                "Visuel canonique non produit · masque et posture Raphaëlle",
            ),
        }
        for segment_id, (message_id, trace_id, asset_id, label) in private_contracts.items():
            message = photos[segment_id][0]
            self.assertEqual(message_id, message["id"])
            self.assertEqual(trace_id, message["trace_id"])
            self.assertEqual(asset_id, message["asset_id"])
            self.assertEqual(asset_id, message["media_ref"])
            self.assertNotEqual(message["id"], trace_id)
            self.assertNotEqual(trace_id, asset_id)
            self.assertEqual(label, message["placeholder_label"])
            self.assertFalse(message["viewer_enabled"])
        for segment_id in [
            "j13_raphaelle_pressed", "j13_raphaelle_boundary", "j13_nico_guardrail", "j13_nico_rivalry",
            "j13_sandra_clear", "j13_sandra_delayed", "j13_sandra_exit", "j13_mathilde_look",
            "j13_mathilde_m_b1", "j13_mathilde_m_b2", "j13_mathilde_m_b3", "j13_mathilde_clean_stop",
            "j13_mathilde_distance", "j13_mathilde_failed", "j13_marie_non_adult", "j13_marie_no_bandage",
            "j13_marie_distance", "j13_respiration", "j13_marie_echo",
        ]:
            self.assertEqual([], photos[segment_id], segment_id)

    def test_runtime_maps_visuals_to_image_messages_and_neutralizes_removals(self):
        provider = self.read("game/scripts/runtime/season_1/J13RuntimeProvider.gd")
        for token in [
            '"content_type":"IMAGE" if authored_type == "PHOTO" else authored_type',
            'item["trace_id"] = trace_id',
            'item["asset_id"] = str(message.get("asset_id", ""))',
            'item["viewer_enabled"] = bool(message.get("viewer_enabled", true))',
            'served_visual_beat_ids.append(trace_id)',
            'func presentation_count_by_trace_id',
            'func _visual_snapshot_consistent',
            'item["content_type"] = "TEXT"',
            'item["text"] = REMOVED_CONTENT_LABEL',
            'item["media_ref"] = ""',
            '"updated_messages":updated_messages',
            'choice_j13_sandra_clear_more',
        ]:
            self.assertIn(token, provider)
        self.assertNotIn("gallery_asset_ids.append", provider)
        runtime_map = self.load("game/data/runtime/season_1/j13_runtime_map.json")
        self.assertEqual([], runtime_map["gallery_presentations"])
        self.assertEqual([], runtime_map["visual_variant_presentations"])

    def test_t17_t18_state_assets_and_t18b_runtime_absence(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        provider = self.read("game/scripts/runtime/season_1/J13RuntimeProvider.gd")
        data = self.read("game/data/conversations/chapter_13_priority.json")
        for token in [
            '"asset_id":"S1_A4_J13_DPH_PAULINE_PRIVATE_VERSION_01"',
            '"parent_content_id":"C12-03"',
            '"parent_asset_id":"S1_A3_J12_DPH_PAULINE_BASTIEN_ANNEXE_01"',
            '"asset_id":"S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01"',
        ]:
            self.assertIn(token, state)
        self.assertNotIn("j13_raphaelle_masked_adult_selected_01", state + provider + data)
        self.assertNotIn("S1_A4_J13_DPH_RAPHAELLE_MASKED_ADULT_SELECTED_01", state + provider + data)

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

    def test_trace_knowledge_contracts_use_canonical_ids(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        smoke = self.read("game/tests/RUNTIME_S1_13J13PlayableSmokeDriver.gd")
        contracts = {
            "j13_pauline_private_version_01": "fact_pauline_created_private_double_address",
            "j13_raphaelle_masked_version_01": "fact_raphaelle_chose_player_for_masked_posture_image",
            "j13_nico_alibi_or_hour_message_01": "fact_nico_knows_specific_hour_or_alibi_request",
        }
        for trace_id, fact_id in contracts.items():
            self.assertIn('"knowledge_created":"%s"' % fact_id, state)
            self.assertIn('"source_ref":"%s"' % trace_id, state)
            self.assertIn(fact_id, smoke)
        for token in [
            '"saving_rule":"IN_THREAD_ONLY"',
            '"source_type":"DIRECT_MESSAGE"',
            '"certainty":"TOLD_DIRECTLY"',
            '"request_or_boundary":request_or_boundary',
            '"source_choice_id":choice_id',
        ]:
            self.assertIn(token, state)
        for bounded_value in ["TRUTH_LIMIT", "ALIBI_REQUEST", "COVERAGE_CLOSED"]:
            self.assertIn(bounded_value, state)
            self.assertIn(bounded_value, smoke)
        legacy_ids = [
            "fact_pauline_" + "sent_private_j12_version",
            "fact_raphaelle_" + "selected_masked_version",
        ]
        for legacy_id in legacy_ids:
            self.assertNotIn(legacy_id, state)
            self.assertNotIn(legacy_id, smoke)

    def test_current_snapshot_versions_and_j13_visual_restore_checks_phase(self):
        provider = self.read("game/scripts/runtime/season_1/J13RuntimeProvider.gd")
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertIn("const SNAPSHOT_VERSION := 2", provider)
        self.assertIn("if version != SNAPSHOT_VERSION", provider)
        self.assertNotIn("func _migrate_", provider)
        self.assertIn("const SNAPSHOT_VERSION := 25", state)
        self.assertIn("const SNAPSHOT_VERSION := 21", season)
        self.assertLess(season.index('state.restore_snapshot(value["state"])'), season.index('j13_provider.restore_snapshot(providers.get("J13", {}))'))
        for token in ["func _restored_phase_consistent", "selected_pivot != state.j13_pivot", "trace_by_message_id", 'content_type == "PHOTO"', "served_visual_beat_ids.size() != presented.size()"]:
            self.assertIn(token, provider)

if __name__ == "__main__":
    unittest.main()
