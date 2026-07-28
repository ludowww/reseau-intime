import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class UIMsg04C1DayDividerAndSpeedScopeStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_timeline_normalizes_days_and_never_bubbles_system_dividers(self):
        source = self.read("game/scripts/ui/messages/MessageTimeline.gd")
        for token in ['1: "Mardi"', '2: "Mercredi"', '3: "Jeudi"',
                      "func _append_presentation_node", "func _day_label_for",
                      'content_type == "SYSTEM_DAY_DIVIDER"']:
            self.assertIn(token, source)
        render_block = source.split("func _append_presentation_node", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("DAY_DIVIDER_SCRIPT.new()", render_block)
        self.assertIn("_build_message_bubble", render_block)
        bubble_block = source.split("func _build_message_bubble", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn('content_type != "SYSTEM_DAY_DIVIDER"', bubble_block)

    def test_rebuild_append_and_typing_replacement_share_the_renderer(self):
        source = self.read("game/scripts/ui/messages/MessageTimeline.gd")
        for function_name in ["_build", "append_incoming_message", "replace_typing_with_message"]:
            block = source.split(f"func {function_name}", 1)[1].split("\nfunc ", 1)[0]
            self.assertIn("_append_presentation_node", block, function_name)
        self.assertIn("_rendered_source_days", source)
        self.assertIn("FIN DE JOURNÉE", source)

    def test_transition_overlay_is_real_time_and_hides_speed_control(self):
        overlay = self.read("game/scripts/ui/messages/TimePassageOverlay.gd")
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        process_block = overlay.split("func _process", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("real_elapsed += delta", process_block)
        self.assertIn("real_elapsed >= phase_duration", process_block)
        self.assertIn("_update_clock(phase, real_elapsed)", process_block)
        self.assertNotIn("speed_multiplier", overlay)
        self.assertNotIn("speed_scaled_elapsed", overlay)
        self.assertIn("speed_button.visible = false", overlay)
        self.assertNotIn("time_passage_overlay.set_speed_multiplier", messages)

    def test_message_and_typing_pacing_keep_reading_speed(self):
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        timeline = self.read("game/scripts/ui/messages/MessageTimeline.gd")
        self.assertIn("reading_speed_multiplier", messages)
        self.assertIn("progress += delta * reading_speed_multiplier", messages)
        self.assertIn("show_typing(author, _reduced_motion_enabled(), true, reading_speed_multiplier)", messages)
        self.assertIn("speed_multiplier := 1.0", timeline)
        self.assertIn("typing_indicator.configure(author, is_group, PORTRAIT_THEME, reduced_motion, speed_multiplier)", timeline)

    def test_dedicated_smoke_and_runner_exist(self):
        for relative in [
            "game/tests/UI_MSG_04C1DayDividerSpeedScopeSmokeDriver.gd",
            "game/tests/UI_MSG_04C1DayDividerSpeedScopeSmokeTest.tscn",
            "tools/test_ui_msg_04c1_day_divider_speed_scope.sh",
        ]:
            self.assertTrue((ROOT / relative).exists(), relative)


if __name__ == "__main__":
    unittest.main()
