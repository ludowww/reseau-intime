import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class V095MarieVisualOpeningStaticTests(unittest.TestCase):
    def setUp(self):
        self.index = json.loads(
            (GAME / "data" / "conversations" / "chapter_08_modular_index.json").read_text(encoding="utf-8")
        )
        self.conversation = json.loads(
            (GAME / "data" / "conversations" / "chapter_08_marie_black_dress.json").read_text(encoding="utf-8")
        )
        bundle = json.loads(
            (GAME / "data" / "visual_content" / "chapter_08_named_boundaries_visuals.json").read_text(encoding="utf-8")
        )
        self.visuals = {item["id"]: item for item in bundle.get("items", [])}

    def test_day8_is_local_endpoint_and_has_three_slot_contract(self):
        self.assertEqual(self.index.get("day"), 8)
        self.assertEqual(self.index.get("timeline_flow", {}).get("next_day"), 9)
        contract = self.index.get("daily_visual_contract", {})
        self.assertEqual(contract.get("minimum_unlocks"), 3)
        self.assertEqual(len(contract.get("slots", [])), 3)
        slot_ids = [cid for slot in contract["slots"] for cid in slot.get("any_content_ids", [])]
        self.assertEqual(len(slot_ids), 3)
        self.assertEqual(len(set(slot_ids)), 3)
        self.assertTrue(all(self.visuals[cid].get("type") == "photo" for cid in slot_ids))

    def test_m4_has_exactly_three_distinct_action_fantasy_choices(self):
        segment = next(seg for seg in self.conversation["segments"] if seg["id"] == "tuesday_marie_real_plan_choice")
        choices = segment.get("choices", [])
        self.assertEqual(len(choices), 3)
        self.assertEqual(
            {choice["id"] for choice in choices},
            {
                "choice_d8_m4_join_movement",
                "choice_d8_m4_take_table",
                "choice_d8_m4_private_thursday",
            },
        )
        texts = " ".join(choice["text"] for choice in choices)
        self.assertIn("La Verrière", texts)
        self.assertIn("20 h 45", texts)
        self.assertIn("jeudi soir", texts)

    def test_three_assets_are_distinct_and_visual_first(self):
        expected = [
            "marie_tuesday_black_dress_mirror_01",
            "marie_tuesday_black_dress_turn_02",
            "marie_tuesday_black_dress_close_03",
        ]
        paths = []
        for content_id in expected:
            self.assertIn(content_id, self.visuals)
            item = self.visuals[content_id]
            self.assertEqual(item.get("character"), "marie")
            self.assertIn(item.get("intensity_tier"), {"V1_ELEGANT", "V2_SEXY"})
            self.assertEqual(item.get("visibility"), "PRIVATE")
            self.assertEqual(item.get("asset_status"), "PROTOTYPE")
            asset = item.get("asset_path", "").replace("res://", "")
            path = GAME / asset
            self.assertTrue(path.exists(), path)
            self.assertGreater(path.stat().st_size, 1000)
            paths.append(item["asset_path"])
        self.assertEqual(len(paths), len(set(paths)))

    def test_runtime_adapters_and_gallery_are_wired(self):
        phone_scene = (GAME / "scenes" / "smartphone" / "PhonePrototype.tscn").read_text(encoding="utf-8")
        conversation_scene = (GAME / "scenes" / "smartphone" / "ConversationView.tscn").read_text(encoding="utf-8")
        phone_script = (GAME / "scripts" / "ui" / "PhonePrototypeV096A.gd").read_text(encoding="utf-8")
        conversation_script = (GAME / "scripts" / "ui" / "ConversationViewV096A.gd").read_text(encoding="utf-8")
        gallery_script = (GAME / "scripts" / "ui" / "PhotoGalleryView.gd").read_text(encoding="utf-8")
        self.assertIn("PhonePrototypeV096A.gd", phone_scene)
        self.assertIn("ConversationViewV096A.gd", conversation_scene)
        self.assertIn("PhotoGalleryView.tscn", phone_script)
        self.assertIn("VisualDayContract.evaluate", phone_script)
        self.assertIn("signal contacts_requested", conversation_script)
        self.assertIn("ContactsBackButton", conversation_script)
        self.assertIn("GameState.current_state.get(\"unlocked_content\"", gallery_script)
        self.assertNotIn("next_day = 9", phone_script)

    def test_first_repetition_is_read_only_and_new_ledger_is_separate(self):
        phone_script = (GAME / "scripts" / "ui" / "PhonePrototypeV096A.gd").read_text(encoding="utf-8")
        self.assertIn('_ensure_named_boundaries_ledger()', phone_script)
        self.assertIn('_record_named_boundaries_visual_route(', phone_script)
        self.assertNotIn('set_obligation_status("first_repetition"', phone_script)


if __name__ == "__main__":
    unittest.main()
