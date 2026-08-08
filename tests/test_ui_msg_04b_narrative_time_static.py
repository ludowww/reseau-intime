import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class UIMsg04BNarrativeTimeStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_dedicated_assets_exist(self):
        for path in [
            "game/tests/UI_MSG_04BNarrativeTimeSmokeDriver.gd",
            "game/tests/UI_MSG_04BNarrativeTimeSmokeTest.tscn",
            "tests/test_ui_msg_04b_narrative_time_static.py",
            "tools/test_ui_msg_04b_narrative_time.sh",
        ]:
            self.assertTrue((ROOT / path).exists(), path)

    def test_runtime_maps_define_only_explicit_temporal_metadata(self):
        expected = {"j01": "18:12", "j02": "12:10", "j03": "09:10"}
        for day, initial in expected.items():
            data = json.loads(self.read(f"game/data/runtime/season_1/{day}_runtime_map.json"))
            self.assertEqual(initial, data["initial_time"])
        j02 = json.loads(self.read("game/data/runtime/season_1/j02_runtime_map.json"))
        self.assertEqual("clock_only", j02["phase_transitions"]["18:18"]["transition_mode"])
        self.assertEqual("18:18", j02["phase_transitions"]["18:18"]["to_time"])
        self.assertEqual("18:18", j02["phase_transitions"]["18:22"]["from_time"])
        self.assertEqual("18:22", j02["phase_transitions"]["18:22"]["to_time"])
        j03 = json.loads(self.read("game/data/runtime/season_1/j03_runtime_map.json"))
        self.assertEqual("clock_then_card", j03["sandra_offer"]["transition_mode"])
        self.assertEqual("13:50", j03["sandra_offer"]["to_time"])
        # UI-MSG-04B2 replaces the informational Marie card with an automatic CLOCK.
        self.assertEqual("clock_only", j03["marie_time_card"]["transition_mode"])
        self.assertEqual("18:20", j03["marie_time_card"]["to_time"])

    def test_providers_own_time_and_snapshots(self):
        providers = [
            self.read("game/scripts/runtime/season_1/J01RuntimeProvider.gd"),
            self.read("game/scripts/runtime/season_1/J02RuntimeProvider.gd"),
            self.read("game/scripts/runtime/season_1/J03RuntimeProvider.gd"),
        ]
        for source in providers:
            for token in [
                "current_time_minutes", "current_narrative_time_minutes", "current_narrative_time_text",
                "mark_message_presented", '"narrative_time"', '"current_time_minutes"',
            ]:
                self.assertIn(token, source)
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        for token in ["current_narrative_time_minutes", "current_narrative_time_text", "mark_message_presented"]:
            self.assertIn(token, season)

    def test_parser_is_strict_and_system_clock_is_forbidden(self):
        utility = self.read("game/scripts/shared/NarrativeTime.gd")
        self.assertIn("func parse_narrative_time", utility)
        self.assertIn("func format_narrative_time", utility)
        production = "\n".join(self.read(path) for path in [
            "game/scripts/shared/NarrativeTime.gd",
            "game/scripts/runtime/season_1/NarrativeTime.gd",
            "game/scripts/runtime/season_1/J01RuntimeProvider.gd",
            "game/scripts/runtime/season_1/J02RuntimeProvider.gd",
            "game/scripts/runtime/season_1/J03RuntimeProvider.gd",
            "game/scripts/ui/messages/MessagesScreen.gd",
        ])
        for forbidden in ["Time.get_time_", "Time.get_datetime_", 'get("title").split', 'get("body").split']:
            self.assertNotIn(forbidden, production)

    def test_ui_has_bounded_dynamic_clock_state(self):
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "narrative_clock_animation_active", "narrative_clock_request_id",
            "narrative_clock_from_minutes", "narrative_clock_to_minutes",
            "narrative_clock_base_duration", "narrative_clock_progress",
            "narrative_clock_pending_transition", "_start_narrative_clock_transition",
            "reading_speed_multiplier / maxf(runtime_delivery_time_scale",
            "REDUCED_MOTION_CLOCK_DELAY_SECONDS", "mark_message_presented",
        ]:
            self.assertIn(token, messages)
        self.assertNotIn("create_timer", messages.split("func _run_narrative_clock", 1)[1].split("func ", 1)[0])

    def test_smoke_uses_real_portrait_main_and_speed_button(self):
        driver = self.read("game/tests/UI_MSG_04BNarrativeTimeSmokeDriver.gd")
        self.assertIn('preload("res://scenes/portrait/PortraitMain.tscn")', driver)
        self.assertIn('main.get_node("PortraitShell").content_mode = "runtime_s1"', driver)
        self.assertIn('emit_signal("pressed")', driver)
        self.assertIn("narrative header starts at Mar. · 18:12", driver)
        runner = self.read("tools/test_ui_msg_04b_narrative_time.sh")
        for resolution in ["540x960", "720x800", "720x960", "720x1280", "1080x1920"]:
            self.assertIn(resolution, runner)
        for preset in ["none", "tall-portrait"]:
            self.assertIn(preset, runner)


if __name__ == "__main__":
    unittest.main()
