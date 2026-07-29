import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class RuntimeS104J04PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_required_files_exist(self):
        required = [
            "game/data/runtime/season_1/j04_runtime_map.json",
            "game/scripts/runtime/season_1/J04RuntimeProvider.gd",
            "game/tests/RUNTIME_S1_04J04PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_04J04PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_04_j04_playable.sh",
        ]
        self.assertEqual([], [p for p in required if not (ROOT / p).exists()])

    def test_map_has_exact_sources_handoff_flow_and_gallery(self):
        data = json.loads(self.read("game/data/runtime/season_1/j04_runtime_map.json"))
        self.assertEqual(data["narrative_day_short"], "Ven.")
        self.assertEqual(data["initial_time"], "08:35")
        self.assertEqual(data["conversation_paths"], {
            "chapter_04_pauline_public_photo_relay": "res://data/conversations/chapter_04_pauline_public_photo_relay.json",
            "chapter_04_nico_saved_seat_followup": "res://data/conversations/chapter_04_nico_saved_seat_followup.json",
            "chapter_04_marie_household_report": "res://data/conversations/chapter_04_marie_household_report.json",
            "chapter_04_mathilde_bathroom_correction": "res://data/conversations/chapter_04_mathilde_bathroom_correction.json",
        })
        self.assertEqual(data["day_start"]["subtitle"], "08:35")
        self.assertEqual(data["nico_transition"]["to_time"], "14:05")
        self.assertEqual(data["household_transition"]["to_time"], "18:05")
        self.assertEqual(data["household_close"]["to_time"], "18:25")
        self.assertEqual(data["household_close"]["flow_phases"], ["CLOCK", "OFF_PHONE"])
        self.assertEqual(data["day_end"]["transition_mode"], "CONTENT_END")
        self.assertEqual(data["photo_set"]["placeholder_label"], "Set de 3 photos non produit")
        self.assertEqual(len(data["photo_set"]["children"]), 3)
        self.assertEqual(len(set(data["photo_set"]["children"])), 3)
        gallery = data["gallery_presentations"]
        self.assertEqual([x["asset_id"] for x in gallery], [
            "S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01",
            "S1_A1_J04_SCN_MARIE_SOCIAL_MOTION_01",
            "S1_A1_J04_SCN_NICO_SAVED_SEAT_01",
            "S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01",
        ])
        self.assertEqual(gallery[0]["character_ids"], ["pauline", "marie"])
        self.assertEqual(gallery[1]["character_ids"], ["marie", "pauline"])
        self.assertEqual(gallery[2]["character_ids"], ["nico"])
        self.assertEqual(gallery[3]["character_ids"], ["marie", "mathilde"])
        for item in gallery:
            self.assertEqual(item["placeholder_label"], "Visuel non produit")
        for item in gallery[1:]:
            self.assertFalse(item["can_share"])
            self.assertEqual(item["transfer_rule"], "FORBIDDEN")
            self.assertFalse(item["is_diegetic"])

    def test_provider_contract_is_bounded_and_canonical(self):
        j04 = self.read("game/scripts/runtime/season_1/J04RuntimeProvider.gd")
        for token in [
            'source_day": 4', '"day_start_pending"', '"pauline_public_relay"',
            '"transition_1405"', '"nico_saved_seat"', '"transition_1805"',
            '"household_echoes"', '"household_close"', '"complete"',
            "marie_household_echo_presented", "mathilde_household_echo_presented",
            "visual_friday_pauline_group_set", "S1_A1_J04_DPH_PAULINE_PUBLIC_GROUP_SET_01",
            "notification", "thread_nico_private", "thread_marie_private",
        ]:
            self.assertIn(token, j04)
        forbidden = ["chapter_04_modular_index", "route_score", "route_owner", "candidate_pool",
                     "laverriere_public_group_photo_set_01", "SYSTEM_DAY_DIVIDER"]
        for token in forbidden:
            self.assertNotIn(token, j04)
        self.assertIn('"destination": "conversation", "thread_id": PAULINE_THREAD', j04)
        self.assertIn('"destination": "conversation", "thread_id": NICO_THREAD', j04)
        self.assertEqual(j04.count('"body": "Nouveau message !"'), 2)
        self.assertNotIn("La chaise qui ne penche pas est encore libre.", j04)
        self.assertNotIn("Rapport du foyer.", j04)

    def test_state_has_exact_j04_records_and_backward_compatible_snapshot(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in [
            "pauline_state", "nico_state", "mathilde_state", "pauline_public_selection_outcome",
            "pauline_retained_frame", "nico_friendship_outcome", "opening_band_complete", "household_rhythm_confirmed",
            "j04_pauline_bastien_public_set_01", "fact_pauline_bastien_couple_public",
            "fact_nico_friendship_exists", "fact_mathilde_stay_started", "Marie",
            "PUBLIC_SOURCE_RULES", "PUBLIC_ACTIVE", "eligible_for_j14", "eligible_for_j21",
        ]:
            self.assertIn(token, state)
        self.assertIn("SNAPSHOT_VERSION := 2", state)
        self.assertIn('"choice_friday_pauline_practical": pauline_public_selection_outcome = "FRAME_02_SELECTED"; pauline_retained_frame = "FRAME_02"', state)
        self.assertIn('"choice_friday_pauline_dry": pauline_public_selection_outcome = "FRAME_03_REQUESTED"; pauline_retained_frame = "FRAME_02"', state)
        self.assertIn('"choice_friday_pauline_defer": pauline_public_selection_outcome = "DEFERRED_TO_MARIE"; pauline_retained_frame = "UNESTABLISHED"', state)
        self.assertIn('version not in [1, SNAPSHOT_VERSION]', state)

    def test_knowledge_source_types_stay_within_the_canonical_registry(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        allowed = {
            "DIRECT_OBSERVATION",
            "DIRECT_MESSAGE",
            "DIRECT_STATEMENT",
            "PUBLIC_TRACE",
            "PRIVATE_TRACE",
            "THIRD_PARTY_STATEMENT",
            "INFERENCE",
        }
        source_types = set(re.findall(r'"source_type"\s*:\s*"([^"]+)"', state))
        self.assertTrue(source_types, "Season1State must declare typed knowledge sources")
        self.assertEqual(set(), source_types - allowed)
        self.assertIn("DIRECT_MESSAGE", source_types)

    def test_season_handoff_snapshot_and_content_end_contract(self):
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertIn('preload("res://scripts/runtime/season_1/J04RuntimeProvider.gd")', season)
        for token in ["j04_provider", "j04_snapshot", "_handoff_to_j04", 'active_day = "J04"',
                      '"J04":', '["J01", "J02", "J03", "J04"]']:
            self.assertIn(token, season)
        self.assertIn("const SNAPSHOT_VERSION := 3", season)
        self.assertIn("version not in [2, SNAPSHOT_VERSION]", season)

    def test_j03_terminal_is_a_single_real_j04_handoff(self):
        data = json.loads(self.read("game/data/runtime/season_1/j03_runtime_map.json"))
        self.assertNotEqual(data.get("day_end", {}).get("transition_mode"), "CONTENT_END")
        self.assertEqual(data["day_end"]["flow_phases"], ["CLOCK", "OFF_PHONE", "NIGHT"])
        self.assertEqual(data["day_end"]["next_day_presentation"]["subtitle"], "08:35")
        self.assertEqual(data["day_end"]["next_day_presentation"]["eyebrow"], "VENDREDI — MATIN")

    def test_day_labels_are_calculated_for_j01_to_j21(self):
        timeline = self.read("game/scripts/ui/messages/MessageTimeline.gd")
        self.assertIn("source_day >= 1 and source_day <= 21", timeline)
        self.assertIn("(source_day - 1) % 7", timeline)
        self.assertIn('"Vendredi"', timeline)

    def test_smoke_uses_real_portrait_controls_for_the_full_j04_path(self):
        driver = self.read("game/tests/RUNTIME_S1_04J04PlayableSmokeDriver.gd")
        runner = self.read("tools/test_runtime_s1_04_j04_playable.sh")
        for token in [
            'preload("res://scenes/portrait/PortraitMain.tscn")',
            'card.emit_signal("pressed")', 'button.emit_signal("pressed")',
            'notification_banner.emit_signal("gui_input", event)',
            'header_notification.emit_signal("gui_input", event)',
            'back_button.emit_signal("pressed")',
            'image_button.emit_signal("pressed")', 'shell.is_photo_viewer_active()',
            'photo_viewer_has_horizontal_crop', 'photo_viewer_has_vertical_crop',
            'image_button.has_focus()', 'thread_pauline_private', 'thread_nico_private',
            'Marie then Mathilde', 'Mathilde then Marie', 'household_echoes',
            'household_close', 'opening_band_complete', 'household_rhythm_confirmed',
            'provider.snapshot()', 'restore_snapshot(snapshot)', 'day_divider_labels()',
        ]:
            self.assertIn(token, driver)
        self.assertNotIn('TIMELINE_SCRIPT', driver)
        self.assertNotIn('NOTIFICATION_SCRIPT', driver)
        for size in ["540x960", "720x800", "720x960", "720x1280", "1080x1920", "1080x2340", "1280x720"]:
            self.assertIn(size, runner)


if __name__ == "__main__":
    unittest.main()
