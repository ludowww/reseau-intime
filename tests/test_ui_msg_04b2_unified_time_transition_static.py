import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class UIMsg04B2UnifiedTimeTransitionStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_unified_overlay_assets_and_native_phases_exist(self):
        required = [
            "game/scripts/ui/messages/TimePassageOverlay.gd",
            "game/scenes/portrait/messages/TimePassageOverlay.tscn",
            "game/tests/UI_MSG_04B2UnifiedTimeTransitionSmokeDriver.gd",
            "game/tests/UI_MSG_04B2UnifiedTimeTransitionSmokeTest.tscn",
            "tools/test_ui_msg_04b2_unified_time_transition.sh",
        ]
        for path in required:
            self.assertTrue((ROOT / path).exists(), path)
        overlay = self.read(required[0])
        for token in [
            'PHASE_CLOCK', 'PHASE_OFF_PHONE', 'PHASE_NIGHT', 'PHASE_NEW_DAY',
            'signal flow_finished', 'func play_flow', 'func set_speed_multiplier',
            'func set_reduced_motion', 'request_id', 'Zzz', '_unhandled_key_input',
            'KEY_ENTER', 'KEY_SPACE', 'MINIMUM_SKIP_DELAY_SECONDS',
            'speed_scaled_elapsed += delta * speed_multiplier', 'MINIMUM_AUTOMATIC_VISIBLE_SECONDS',
        ]:
            self.assertIn(token, overlay)
        forbidden = [".gif", "AnimatedTexture", "VideoStream", "Sprite2D"]
        for token in forbidden:
            self.assertNotIn(token, overlay)

    def test_player_timestamps_are_provider_authoritative(self):
        for day in ["J01", "J02", "J03"]:
            source = self.read(f"game/scripts/runtime/season_1/{day}RuntimeProvider.gd")
            self.assertIn('"timestamp": current_narrative_time_text()', source)
            self.assertNotIn('"timestamp": "maintenant"', source)

    def test_runtime_metadata_describes_automatic_flows(self):
        j01 = json.loads(self.read("game/data/runtime/season_1/j01_runtime_map.json"))
        j02 = json.loads(self.read("game/data/runtime/season_1/j02_runtime_map.json"))
        j03 = json.loads(self.read("game/data/runtime/season_1/j03_runtime_map.json"))
        self.assertEqual("OFF_PHONE", j01["transitions"]["marie"]["overlay_phase"])
        self.assertEqual(["OFF_PHONE", "NIGHT", "NEW_DAY"], j01["transitions"]["sandra"]["flow_phases"])
        self.assertEqual(["OFF_PHONE", "NIGHT", "NEW_DAY"], j02["day_end"]["flow_phases"])
        self.assertEqual("clock_only", j02["phase_transitions"]["18:18"]["transition_mode"])
        self.assertEqual("clock_only", j02["phase_transitions"]["18:22"]["transition_mode"])
        self.assertEqual("clock_then_card", j03["sandra_offer"]["transition_mode"])
        self.assertEqual("clock_only", j03["marie_time_card"]["transition_mode"])
        self.assertEqual("CONTENT_END", j03["day_end"]["transition_mode"])
        self.assertNotIn("J04", json.dumps(j03))
        self.assertEqual("19:05", j03["marie_offline"]["ACTIVE"]["time"])
        self.assertEqual("19:35", j03["marie_offline"]["BOUNDED"]["time"])
        self.assertEqual("20:30", j03["marie_offline"]["DRIFT"]["time"])

    def test_messages_screen_keeps_phone_mounted_under_one_overlay(self):
        source = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "TIME_PASSAGE_OVERLAY_SCENE", "time_passage_overlay", "transition_flow_active",
            "transition_flow_request_id", "transition_flow_phase", "transition_flow_presentation",
            "transition_flow_from_minutes", "transition_flow_to_minutes",
            "_start_time_passage_flow", "_on_time_passage_flow_finished",
            "set_speed_multiplier(reading_speed_multiplier)",
        ]:
            self.assertIn(token, source)
        flow = source.split("func _start_time_passage_flow", 1)[1].split("func ", 1)[0]
        self.assertNotIn("conversation_screen.visible = false", flow)
        self.assertNotIn("conversation_list.visible = false", flow)
        self.assertIn("z_index", flow)

    def test_day_handoffs_are_automatic_and_final_content_end_is_explicit(self):
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        for token in [
            "automatic_day_handoff", "next_day_presentation", "content_end",
            "pending_transition_flow", "complete_pending_transition_flow",
            '"resume_action": "automatic_day_handoff"',
            '"resume_action": "start_day"',
        ]:
            self.assertIn(token, season)
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        self.assertIn('"CONTENT_END"', messages)
        self.assertIn('"DECISION"', messages)
        self.assertIn('clock_then_card', messages)
        self.assertIn("_resume_authoritative_transition_flow", messages)
        self.assertIn('result.get("focus_thread_id", result.get("unlocked_thread_id", ""))', messages)

    def test_smoke_covers_surfaces_speed_reduced_motion_snapshots_and_responsive(self):
        driver = self.read("game/tests/UI_MSG_04B2UnifiedTimeTransitionSmokeDriver.gd")
        for token in [
            'preload("res://scenes/portrait/PortraitMain.tscn")', "clock from list",
            "clock from conversation", "phone remains mounted", "single overlay instance",
            "reduced motion", "snapshot", "CONTENT_END", "×1", "×3", "×8",
            "Input.parse_input_event", "clock skip is forbidden", "clock target is exact",
            "speed change remains monotone", "Sandra notification focus",
            "restored authoritative transition resumes exactly once",
        ]:
            self.assertIn(token, driver)
        runner = self.read("tools/test_ui_msg_04b2_unified_time_transition.sh")
        for resolution in ["540x960", "720x800", "720x960", "720x1280", "1080x1920"]:
            self.assertIn(resolution, runner)


if __name__ == "__main__":
    unittest.main()
