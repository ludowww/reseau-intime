import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class V096WednesdayCarryoverSocialStaticTests(unittest.TestCase):
    def setUp(self):
        self.chapter8 = json.loads((GAME / "data" / "conversations" / "chapter_08_modular_index.json").read_text(encoding="utf-8"))
        self.chapter9 = json.loads((GAME / "data" / "conversations" / "chapter_09_modular_index.json").read_text(encoding="utf-8"))
        self.selector = (GAME / "scripts" / "narrative" / "NamedBoundariesSelector.gd").read_text(encoding="utf-8")
        self.phone = (GAME / "scripts" / "ui" / "PhonePrototypeV096A.gd").read_text(encoding="utf-8")
        self.phone_scene = (GAME / "scenes" / "smartphone" / "PhonePrototype.tscn").read_text(encoding="utf-8")
        self.conversation_scene = (GAME / "scenes" / "smartphone" / "ConversationView.tscn").read_text(encoding="utf-8")
        self.visual_bundle = json.loads((GAME / "data" / "visual_content" / "chapter_09_named_boundaries_visuals.json").read_text(encoding="utf-8"))
        self.visuals = {item["id"]: item for item in self.visual_bundle.get("items", [])}

    def test_day8_opens_day9_and_day9_closes_locally(self):
        self.assertEqual(self.chapter8.get("timeline_flow", {}).get("next_day"), 9)
        self.assertIsNone(self.chapter9.get("timeline_flow", {}).get("next_day"))
        phases = [phase.get("id") for phase in self.chapter9.get("timeline_flow", {}).get("phases", [])]
        self.assertEqual(phases, [
            "wednesday_carryover_select",
            "wednesday_carryover_route",
            "wednesday_social_set",
            "wednesday_visual_contract_close",
            "wednesday_named_boundaries_slice_close",
        ])

    def test_visual_contract_guarantees_three_social_slots(self):
        contract = self.chapter9.get("daily_visual_contract", {})
        self.assertEqual(contract.get("minimum_unlocks"), 3)
        self.assertEqual([slot.get("id") for slot in contract.get("slots", [])], [
            "slot_marie_wednesday_lannexe_social_01",
            "slot_pauline_wednesday_green_dress_02",
            "slot_marie_pauline_wednesday_duo_03",
        ])
        self.assertEqual([cid for slot in contract.get("slots", []) for cid in slot.get("any_content_ids", [])], [
            "marie_wednesday_lannexe_social_01",
            "pauline_wednesday_green_dress_02",
            "marie_pauline_wednesday_duo_03",
        ])

    def test_selector_is_pure_and_prioritises_expected_sources(self):
        self.assertIn("select_carryover(first_repetition_ledger: Dictionary, flags: Array) -> Dictionary", self.selector)
        self.assertNotIn("GameState.", self.selector)
        self.assertNotIn("TimelineState.", self.selector)
        self.assertNotIn("DataLoader.", self.selector)
        self.assertIn('charged_access_owner=mathilde', self.selector)
        self.assertIn('foreground_history_resolved=%s', self.selector)

    def test_phone_targets_v096_assets_and_prototype_ledger(self):
        self.assertIn("PhonePrototypeV096AResume.gd", self.phone_scene)
        self.assertIn("ConversationViewV096AResume.gd", self.conversation_scene)
        self.assertIn('_record_named_boundaries_visual_route(', self.phone)
        self.assertNotIn('secondary_risk_seed', self.phone)
        self.assertNotIn('chapter_09_index.json', self.phone)

    def test_social_set_and_route_assets_are_prototype_photos(self):
        expected_ids = [
            "marie_wednesday_lannexe_social_01",
            "pauline_wednesday_green_dress_02",
            "marie_pauline_wednesday_duo_03",
            "mathilde_wednesday_homewear_mirror_01",
            "mathilde_wednesday_outfit_choice_02",
            "mathilde_wednesday_deliberate_pose_03",
            "mathilde_wednesday_deliberate_pose_cold_alt_03",
            "sandra_wednesday_fitted_outfit_01",
            "sandra_wednesday_mirror_hesitation_02",
            "sandra_wednesday_private_extra_03",
            "sandra_wednesday_composed_close_alt_03",
        ]
        self.assertEqual([item.get("id") for item in self.visual_bundle.get("items", [])], expected_ids)
        for content_id in expected_ids:
            item = self.visuals[content_id]
            self.assertEqual(item.get("type"), "photo")
            self.assertEqual(item.get("asset_status"), "PROTOTYPE")
            asset_path = GAME / item.get("asset_path", "").removeprefix("res://")
            self.assertTrue(asset_path.exists(), asset_path)
            self.assertGreater(asset_path.stat().st_size, 1000)

    def test_social_conversation_contains_required_facts(self):
        convo = json.loads((GAME / "data" / "conversations" / "chapter_09_marie_pauline_social_set.json").read_text(encoding="utf-8"))
        text = json.dumps(convo, ensure_ascii=False)
        for token in ["20 h 45", "Bastien", "Pauline", "La Verrière"]:
            self.assertIn(token, text)
        self.assertNotIn("secondary_risk_seed", text)
        self.assertNotIn("crop", text.lower())


if __name__ == "__main__":
    unittest.main()
