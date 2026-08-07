import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class RuntimeS102J02PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_required_files_exist(self):
        required = [
            "game/data/runtime/season_1/j02_runtime_map.json",
            "game/scripts/runtime/season_1/J02RuntimeProvider.gd",
            "game/scripts/runtime/season_1/Season1RuntimeProvider.gd",
            "game/tests/RUNTIME_S1_02J02PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_02J02PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_02_j02_playable.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_runtime_map_is_bounded_to_three_authorized_sources(self):
        data = json.loads(self.read("game/data/runtime/season_1/j02_runtime_map.json"))
        self.assertEqual(data["conversation_paths"], {
            "chapter_02_marie_make_room": "res://data/conversations/chapter_02_marie_make_room.json",
            "chapter_02_marie_arrival_trace": "res://data/conversations/chapter_02_marie_arrival_trace.json",
            "chapter_02_mathilde_arrival": "res://data/conversations/chapter_02_mathilde_arrival.json",
        })
        self.assertEqual(data["excluded_message_ids"], ["msg_wed_marie_arrival_002"])
        self.assertEqual(data["excluded_segment_ids"], ["segment_wednesday_mathilde_photo_defense"])
        all_text = json.dumps(data)
        self.assertNotIn("chapter_02_proofs", all_text)
        self.assertNotIn("mathilde_arrival_room_01", all_text)

    def test_exact_transition_cards_and_gallery_contract(self):
        data = json.loads(self.read("game/data/runtime/season_1/j02_runtime_map.json"))
        day_start = data["day_start"].copy()
        self.assertEqual(day_start.pop("transition_mode", None), "day_boundary")
        self.assertEqual(day_start, {
            "eyebrow": "MERCREDI — MIDI", "title": "Faire de la place", "subtitle": "12:10",
            "body": "Mathilde doit quitter temporairement son appartement. Marie et Player font de la place avant son arrivée.",
            "action_label": "Commencer",
        })
        self.assertEqual(data["phase_transitions"]["18:18"]["title"], "18:18")
        self.assertEqual(data["phase_transitions"]["18:22"]["title"], "18:22")
        self.assertEqual(data["day_end"]["title"], "J02 terminé")
        gallery = data["gallery_presentations"]
        self.assertEqual([item["asset_id"] for item in gallery], [
            "S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01",
            "S1_A1_J02_SCN_MARIE_HOLDS_HOUSEHOLD_01",
            "S1_A1_J02_SCN_FIRST_SHARED_EVENING_01",
        ])
        for item in gallery:
            self.assertEqual(item["placeholder_label"], "Visuel non produit")
            self.assertEqual(item["source_kind"], "gallery")
            self.assertEqual(item["content_type"], "SCENE_IMAGE")
            self.assertFalse(item["can_share"])
            self.assertEqual(item["transfer_rule"], "FORBIDDEN")
            self.assertFalse(item["is_diegetic"])

    def test_state_provider_and_snapshot_contract_are_explicit(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        j02 = self.read("game/scripts/runtime/season_1/J02RuntimeProvider.gd")
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        for token in ["mathilde_j02_arrival_help", "DEPARTURE_SUPPORT", "marie_make_room_outcome",
                      "mathilde_welcome_outcome", "j02_mathilde_arrival_room_01", "FACT_RECORD",
                      "fact_mathilde_stay_started", "initial_knowers", "mark_day_complete(2)"]:
            self.assertIn(token, state + j02)
        for token in ["func snapshot() -> Dictionary", "func restore_snapshot(value: Dictionary) -> bool",
                      "active_day", "active_provider", "j01_snapshot", "j02_snapshot"]:
            self.assertIn(token, season)
        forbidden = ["sets_" + "flags", "routes_" + "nourished", "candidate_" + "pool",
                     "dominant_" + "route", "secondary_" + "route", "attachment_" + "score",
                     "trust_" + "score", "lie_" + "score", "R2 owner", "wave owner"]
        for path in ["game/data/runtime/season_1/j02_runtime_map.json",
                     "game/scripts/runtime/season_1/J02RuntimeProvider.gd",
                     "game/scripts/runtime/season_1/Season1RuntimeProvider.gd"]:
            text = self.read(path)
            for token in forbidden:
                self.assertNotIn(token, text)

    def test_production_mode_and_demo_separation(self):
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        main = self.read("game/scenes/portrait/PortraitMain.tscn")
        demo = self.read("game/scripts/ui/PortraitShellDemo.gd")
        self.assertIn('@export_enum("demo", "runtime_s1", "unified")', shell)
        self.assertIn("Season1RuntimeProvider.gd", shell)
        self.assertIn('content_mode = "unified"', main)
        self.assertIn('shell.content_mode = "demo"', demo)
        self.assertNotIn("MessagesDemoData", main)
        self.assertNotIn("GalleryDemoData", main)

    def test_smoke_starts_real_main_uses_buttons_and_two_sizes(self):
        driver = self.read("game/tests/RUNTIME_S1_02J02PlayableSmokeDriver.gd")
        runner = self.read("tools/test_runtime_s1_02_j02_playable.sh")
        self.assertIn('preload("res://scenes/portrait/PortraitMain.tscn")', driver)
        self.assertIn('get_node("PortraitShell").content_mode = "runtime_s1"', driver)
        self.assertIn('emit_signal("pressed")', driver)
        self.assertIn("720x1280 1080x1920", runner)
        for token in ["choice_wed_make_room_proactive", "choice_wed_make_room_playful",
                      "choice_wed_make_room_passive", "choice_wed_mathilde_practical",
                      "choice_wed_mathilde_playful", "choice_wed_mathilde_distant",
                      "PAID", "FAILED", "REFUSED", "snapshot", "msg_wed_marie_arrival_002",
                      "_run_ui_outcome", "completed snapshot round trip"]:
            self.assertIn(token, driver)
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertNotIn("debug_handoff_to_j02", season + driver)


if __name__ == "__main__":
    unittest.main()
