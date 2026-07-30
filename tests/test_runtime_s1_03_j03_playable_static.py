import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class RuntimeS103J03PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_required_files_exist(self):
        required = [
            "game/data/runtime/season_1/j03_runtime_map.json",
            "game/scripts/runtime/season_1/J03RuntimeProvider.gd",
            "game/tests/RUNTIME_S1_03J03PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_03J03PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_03_j03_playable.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_map_uses_only_three_authorized_sources_and_exact_cards(self):
        data = json.loads(self.read("game/data/runtime/season_1/j03_runtime_map.json"))
        self.assertEqual(data["conversation_paths"], {
            "chapter_03_raphaelle_blue_folder": "res://data/conversations/chapter_03_raphaelle_blue_folder.json",
            "chapter_03_sandra_continuity": "res://data/conversations/chapter_03_sandra_continuity.json",
            "chapter_03_marie_evening_return": "res://data/conversations/chapter_03_marie_evening_return.json",
        })
        day_start = data["day_start"].copy()
        self.assertEqual(day_start.pop("transition_mode", None), "day_boundary")
        self.assertEqual(day_start, {
            "eyebrow": "JEUDI — MATIN", "title": "Les vies qui existent ailleurs", "subtitle": "09:10",
            "body": "Un dossier à corriger. Des vies qui continuent ailleurs.", "action_label": "Commencer",
        })
        self.assertEqual(data["sandra_offer"]["secondary_action_label"], "Continuer la journée")
        self.assertEqual(data["sandra_offer"]["action_label"], "Ouvrir Sandra")
        self.assertEqual(data["marie_time_card"]["title"], "18:20")
        self.assertEqual(data["day_end"]["transition_mode"], "day_handoff")
        self.assertEqual(data["day_end"]["flow_phases"], ["CLOCK", "OFF_PHONE", "NIGHT"])
        self.assertEqual(data["day_end"]["next_day_presentation"]["subtitle"], "08:35")
        serialized = json.dumps(data, ensure_ascii=False)
        for excluded in ["chapter_03_raphaelle_late_review", "chapter_03_marie_event_return",
                         "chapter_03_proofs", "mathilde_home_charger", "event_offer", "event_joined", "J04"]:
            self.assertNotIn(excluded, serialized)

    def test_offline_beats_gallery_and_state_records_are_exact(self):
        data = json.loads(self.read("game/data/runtime/season_1/j03_runtime_map.json"))
        self.assertEqual(data["raphaelle_offline"]["message_id"], "j03_raphaelle_garment_bag_beat")
        self.assertEqual(data["raphaelle_offline"]["text"],
            "À la fin du point, Raphaëlle referme le dossier bleu, range son carnet et récupère une housse à vêtements fermée près de son poste.\nElle n’en fait pas un sujet. Player remarque seulement que sa journée ne s’arrête pas au dossier.")
        self.assertEqual(set(data["marie_offline"]), {"ACTIVE", "BOUNDED", "DRIFT"})
        self.assertEqual([item["asset_id"] for item in data["gallery_presentations"]], [
            "S1_A1_J03_SCN_RAPHAELLE_ACCESSIBILITY_REVIEW_01",
            "S1_A1_J03_SCN_RAPHAELLE_GARMENT_BAG_01",
            "S1_A1_J03_SCN_MARIE_HOME_FROM_LAVERRIERE_01",
        ])
        for item in data["gallery_presentations"]:
            self.assertEqual(item["placeholder_label"], "Visuel non produit")
            self.assertEqual(item["content_type"], "SCENE_IMAGE")
            self.assertFalse(item["can_share"])
            self.assertEqual(item["transfer_rule"], "FORBIDDEN")
            self.assertFalse(item["is_diegetic"])

    def test_snapshot_v2_and_additive_secondary_action_contract(self):
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        j01 = self.read("game/scripts/runtime/season_1/J01RuntimeProvider.gd")
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        day = self.read("game/scripts/ui/messages/DayTransition.gd")
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        self.assertIn("const SNAPSHOT_VERSION := 6", season)
        self.assertIn("version not in [2, 3, 4, 5, SNAPSHOT_VERSION]", season)
        for token in ['"state"', '"provider_snapshots"', '"J01"', '"J02"', '"J03"', '"J04"', '"J05"', '"J06"']:
            self.assertIn(token, season)
        self.assertIn("progress_snapshot", j01)
        self.assertIn("restore_progress_snapshot", j01)
        self.assertIn("signal secondary_requested", day)
        self.assertIn("secondary_action_label", day)
        self.assertIn("secondary_requested.connect", messages)
        for token in ["raphaelle_state", "raphaelle_work_outcome", "sandra_j03_echo_outcome",
                      "marie_j03_return_outcome", "fact_raphaelle_professional_relationship_exists",
                      "j03_marie_laverriere_setup_01", "fact_marie_laverriere_world_exists"]:
            self.assertIn(token, state)

    def test_j03_handoff_failure_and_restored_phase_are_bounded(self):
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        j03 = self.read("game/scripts/runtime/season_1/J03RuntimeProvider.gd")
        self.assertIn("func _handoff_to_j03() -> bool:", season)
        self.assertIn("if not candidate.initialize(", season)
        self.assertIn("state_restore_count", season)
        self.assertIn('phase not in ["day_start_pending", "raphaelle_work", "raphaelle_offline", "sandra_offer", "sandra_echo", "marie_time_card", "marie_return", "marie_offline", "complete"]', j03)

    def test_thread_participants_use_explicit_unaccented_runtime_ids(self):
        j03 = self.read("game/scripts/runtime/season_1/J03RuntimeProvider.gd")
        self.assertIn('"thread_marie_private": "marie"', j03)
        self.assertIn('"thread_sandra_private": "sandra"', j03)
        self.assertIn('"thread_mathilde_private": "mathilde"', j03)
        self.assertIn('"thread_raphaelle_private": "raphaelle"', j03)
        self.assertNotIn('[title.to_lower(), "player"]', j03)
        self.assertIn('[participant_id, "player"]', j03)

    def test_new_runtime_files_contain_no_forbidden_legacy_concepts(self):
        forbidden = ["sets_" + "flags", "routes_" + "nourished", "candidate_" + "pool",
                     "dominant_" + "route", "secondary_" + "route", "attachment_" + "score",
                     "trust_" + "score", "lie_" + "score", "event_" + "offer", "event_" + "joined",
                     "work_" + "promise", "vern" + "issage", "R2 owner", "wave owner"]
        for path in ["game/data/runtime/season_1/j03_runtime_map.json",
                     "game/scripts/runtime/season_1/J03RuntimeProvider.gd"]:
            text = self.read(path)
            for token in forbidden:
                self.assertNotIn(token, text)

    def test_smoke_uses_real_main_buttons_and_two_portrait_sizes(self):
        driver = self.read("game/tests/RUNTIME_S1_03J03PlayableSmokeDriver.gd")
        runner = self.read("tools/test_runtime_s1_03_j03_playable.sh")
        self.assertIn('preload("res://scenes/portrait/PortraitMain.tscn")', driver)
        self.assertIn('emit_signal("pressed")', driver)
        self.assertIn("720x1280 1080x1920", runner)
        for token in ["RESPONDED", "EXPIRED", "UNAVAILABLE", "ACCOUNTABLE", "DRY_HUMOR", "DELAYED",
                      "ACTIVE", "BOUNDED", "DRIFT", "snapshot", "secondary_button", "FACT_RECORD"]:
            self.assertIn(token, driver)


if __name__ == "__main__":
    unittest.main()
