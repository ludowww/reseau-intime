import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class UIMsg04B3TransitionReadabilityStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_overlay_uses_phase_specific_opaque_backgrounds(self):
        source = self.read("game/scripts/ui/messages/TimePassageOverlay.gd")
        for token in [
            "CLOCK_BACKGROUND", "OFF_PHONE_BACKGROUND", "NIGHT_BACKGROUND", "NEW_DAY_BACKGROUND",
            "Color(0.015, 0.02, 0.04, 0.96)", "Color(0.015, 0.02, 0.04, 0.97)",
            "Color(0.005, 0.008, 0.018, 1.0)", "Color(0.015, 0.02, 0.04, 1.0)",
        ]:
            self.assertIn(token, source)
        clock_block = source.split("func _apply_phase", 1)[1].split("func _update_clock", 1)[0]
        self.assertIn("eyebrow_label.visible = kind == PHASE_NEW_DAY", clock_block)
        self.assertIn("title_label.visible = kind == PHASE_NEW_DAY", clock_block)
        self.assertNotIn("0.62", source)

    def test_all_phases_use_real_elapsed_and_stable_native_labels(self):
        source = self.read("game/scripts/ui/messages/TimePassageOverlay.gd")
        scene = self.read("game/scenes/portrait/messages/TimePassageOverlay.tscn")
        self.assertIn("real_elapsed += delta", source)
        self.assertIn("_update_clock(phase, real_elapsed)", source)
        self.assertNotIn("speed_scaled_elapsed", source)
        self.assertNotIn("speed_multiplier", source)
        self.assertIn("speed_button.visible = false", source)
        self.assertIn("_update_sleep(real_elapsed)", source)
        self.assertIn("NIGHT_DURATION_SECONDS := 2.6", source)
        self.assertNotIn("ping_pong", source.lower())
        for name in ["SleepContainer", "SleepZ", "SleepZz", "SleepZzz"]:
            self.assertIn(f'name="{name}"', scene.replace(" ", ""))
        self.assertIn("_set_sleep_label_progress", source)
        self.assertIn("reduced_motion", source)

    def test_j01_resume_descriptor_is_provider_authoritative(self):
        source = self.read("game/scripts/runtime/season_1/J01RuntimeProvider.gd")
        block = source.split('if kind == "marie_shared_evening":', 1)[1].split('if kind == "sandra_final_return":', 1)[0]
        for token in [
            '"destination": "conversation"',
            '"resume_destination": "conversation"',
            '"resume_thread_id": "thread_marie_private"',
            '"thread_id": "thread_marie_private"',
            '"unlocked_thread_id": "thread_sandra_private"',
        ]:
            self.assertIn(token, block)

    def test_conversation_header_owns_local_notification_host(self):
        conversation = self.read("game/scripts/ui/messages/PortraitConversationScreen.gd")
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "HeaderNotificationHost", "show_header_notification", "hide_header_notification",
            "header_notification_visible", "header_notification_open_requested",
        ]:
            self.assertIn(token, conversation)
        present_block = messages.split("func _present_notification", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn('screen_mode == "conversation"', present_block)
        self.assertIn("conversation_screen.show_header_notification", present_block)
        self.assertNotIn("offset_top", present_block)
        self.assertNotIn("_set_content_banner_spacing", messages)

    def test_notification_surface_is_clickable_and_real_time_auto_dismissed(self):
        source = self.read("game/scripts/ui/messages/NotificationBanner.gd")
        for token in [
            "AUTO_DISMISS_SECONDS", "auto_dismiss_timer", "_on_gui_input",
            "InputEventMouseButton", "open_requested.emit", "timeout.connect",
            "TRANS_CUBIC", "EASE_OUT",
        ]:
            self.assertIn(token, source)
        self.assertNotIn("speed_multiplier", source)

    def test_narrative_day_short_is_explicit_and_rendered_with_time(self):
        expected = {"j01": "Mar.", "j02": "Mer.", "j03": "Jeu."}
        for day, label in expected.items():
            runtime_map = json.loads(self.read(f"game/data/runtime/season_1/{day}_runtime_map.json"))
            self.assertEqual(label, runtime_map["narrative_day_short"])
            provider = self.read(f"game/scripts/runtime/season_1/{day.upper()}RuntimeProvider.gd")
            self.assertIn('"narrative_day_short"', provider)
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        conversation = self.read("game/scripts/ui/messages/PortraitConversationScreen.gd")
        self.assertIn("func current_narrative_day_short", season)
        self.assertIn('" · "', conversation)
        for forbidden in ["Time.get_date", "Time.get_datetime", "OS.get_date", "locale"]:
            self.assertNotIn(forbidden, conversation)

    def test_04b3_runtime_smoke_and_full_matrix_exist(self):
        driver = self.read("game/tests/UI_MSG_04B3TransitionReadabilitySmokeDriver.gd")
        self.assertIn('main.get_node("PortraitShell").content_mode = "runtime_s1"', driver)
        required = [
            "game/tests/UI_MSG_04B3TransitionReadabilitySmokeDriver.gd",
            "game/tests/UI_MSG_04B3TransitionReadabilitySmokeTest.tscn",
            "tools/test_ui_msg_04b3_transition_readability.sh",
        ]
        for relative in required:
            self.assertTrue((ROOT / relative).exists(), relative)
        runner = self.read(required[-1])
        for resolution in ["540x960", "720x800", "720x960", "720x1280", "1080x1920", "1080x2340", "1280x720"]:
            self.assertIn(resolution, runner)


if __name__ == "__main__":
    unittest.main()
