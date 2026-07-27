import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class RuntimeS103BMessageDeliveryStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_required_corrective_assets_exist(self):
        required = [
            "game/tests/RUNTIME_S1_03BMessageDeliverySmokeDriver.gd",
            "game/tests/RUNTIME_S1_03BMessageDeliverySmokeTest.tscn",
            "tests/test_runtime_s1_03b_message_delivery_static.py",
            "tools/test_runtime_s1_03b_message_delivery.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_delivery_has_explicit_bounded_state_and_production_timings(self):
        source = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "runtime_delivery_active", "runtime_delivery_thread_id",
            "runtime_delivery_request_id", "runtime_delivery_queue",
            "runtime_delivery_pending_choices", "runtime_delivery_pending_transition",
            "runtime_delivery_time_scale", "runtime_delivery_cancelled",
            "INTER_MESSAGE_PAUSE_SECONDS := 0.25", "IMAGE_TYPING_DURATION_SECONDS := 1.20",
            "clampf(0.70 + float(text.length()) * 0.014, 1.00, 2.00)",
            "_run_runtime_delivery(", "request_id == runtime_delivery_request_id",
        ]:
            self.assertIn(token, source)
        self.assertNotIn("append_runtime_messages(_dictionary_array(result.get(\"new_messages\", [])))", source)

    def test_typing_indicator_is_three_graphic_dots_not_text(self):
        source = self.read("game/scripts/ui/messages/TypingIndicator.gd")
        for token in ["class TypingDot", "draw_circle", "typing_dots", "DOT_COUNT := 3", "WAVE_CYCLE_SECONDS := 1.05", "DOT_PHASE_OFFSET_SECONDS := 0.16", "func _process(delta: float)"]:
            self.assertIn(token, source)
        for forbidden in ['[".", "..", "..."]', 'dots_label', 'text = "…"', "Timer.new()", "create_tween()"]:
            self.assertNotIn(forbidden, source)

    def test_timeline_exposes_bounded_after_layout_follow(self):
        source = self.read("game/scripts/ui/messages/MessageTimeline.gd")
        self.assertIn("func scroll_to_last_message_after_layout(force_follow := true) -> bool", source)
        self.assertIn("layout_follow_request_id", source)
        self.assertIn("await get_tree().process_frame", source)
        self.assertIn("is_last_message_visible()", source)

    def test_provider_sync_is_strict_and_blocks_completion_on_mismatch(self):
        source = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        self.assertIn("func _sync_runtime_delivery_provider(thread_id: String) -> bool", source)
        self.assertIn("provider_messages != visual_messages", source)
        self.assertIn("if not _sync_runtime_delivery_provider(thread_id):", source)
        self.assertIn("await conversation_screen.timeline.scroll_to_last_message_after_layout(true)", source)
        self.assertIn("_complete_runtime_delivery", source)

    def test_production_motion_and_smokes_use_real_delivery_state(self):
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        self.assertIn("var reduced_motion_enabled := false", shell)
        for path in [
            "game/tests/RUNTIME_S1_01J01PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_02J02PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_03J03PlayableSmokeDriver.gd",
        ]:
            source = self.read(path)
            self.assertIn("_wait_runtime_delivery_complete", source)
            self.assertIn("runtime_delivery_active", source)
            self.assertIn("runtime_delivery_queue", source)

    def test_corrective_smoke_uses_real_scene_buttons_and_two_sizes(self):
        driver = self.read("game/tests/RUNTIME_S1_03BMessageDeliverySmokeDriver.gd")
        runner = self.read("tools/test_runtime_s1_03b_message_delivery.sh")
        self.assertIn('preload("res://scenes/portrait/PortraitMain.tscn")', driver)
        self.assertIn('emit_signal("pressed")', driver)
        self.assertIn("runtime_delivery_time_scale", driver)
        for assertion in [
            "first incoming message must arrive alone", "second typing phase must appear after the pause",
            "choices must stay absent before delivery completion", "provider and visual transcripts must match exactly",
            "other thread transcript must remain unchanged", "transition must not start before final delivery",
            "OFF_PHONE_TRANSITION must never render as a bubble", "timeline rect must remain inside Messages bounds",
        ]:
            self.assertIn(assertion, driver)
        self.assertIn("720x1280 1080x1920", runner)


if __name__ == "__main__":
    unittest.main()
