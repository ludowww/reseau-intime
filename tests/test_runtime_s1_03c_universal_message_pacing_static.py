import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class RuntimeS103CUniversalMessagePacingStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_required_assets_exist(self):
        required = [
            "game/tests/RUNTIME_S1_03CUniversalMessagePacingSmokeDriver.gd",
            "game/tests/RUNTIME_S1_03CUniversalMessagePacingSmokeTest.tscn",
            "tests/test_runtime_s1_03c_universal_message_pacing_static.py",
            "tools/test_runtime_s1_03c_universal_message_pacing.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_provider_visual_pending_state_and_reconciliation_are_explicit(self):
        source = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "runtime_presented_message_ids_by_thread",
            "runtime_pending_messages_by_thread",
            "runtime_pending_choices_by_thread",
            "runtime_pending_transition_by_thread",
            "func _reconcile_runtime_source(",
            "func _start_pending_delivery_for_thread(",
            "runtime_typing_started",
            "runtime_message_delivered",
        ]:
            self.assertIn(token, source)
        self.assertNotIn("\t_apply_content_source(next_source)\n", source)
        self.assertIn("_normalized_runtime_transcript(visual_messages)", source)
        self.assertIn("_normalized_runtime_transcript(provider_messages.slice(0, visual_messages.size()))", source)
        self.assertIn("func _runtime_presented_ids_match_visual_sequence", source)
        self.assertIn("if pending.is_empty() and normalized_visual != normalized_provider", source)
        self.assertIn("presented message ID sequence does not match visual transcript", source)

    def test_active_thread_delivery_is_read_before_visual_insertion(self):
        source = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        self.assertIn("func _runtime_message_for_visual_insertion", source)
        self.assertIn('visual_message["is_read"] = true', source)
        self.assertIn("var visual_message := _runtime_message_for_visual_insertion", source)

    def test_atomic_typing_replacement_and_stable_follow_exist(self):
        timeline = self.read("game/scripts/ui/messages/MessageTimeline.gd")
        self.assertIn("func replace_typing_with_message(message: Dictionary, force_follow := true)", timeline)
        self.assertIn("var typing_index: int = typing_indicator.get_index()", timeline)
        self.assertIn("message_box.add_child(message_bubble)", timeline)
        self.assertIn("message_box.move_child(message_bubble, typing_index)", timeline)
        self.assertIn("func bottom_gap() -> float", timeline)
        for token in [
            "ReplacementSpacer",
            "replacement_spacer_active",
            "replacement_spacer_count",
            "replacement_spacer_height",
            "replacement_spacer_created_count",
            "replacement_spacer_removed_count",
            "outgoing_indicator.size.y",
            "Control.MOUSE_FILTER_IGNORE",
        ]:
            self.assertIn(token, timeline)
        replacement_body = timeline.split("func replace_typing_with_message", 1)[1].split("func show_typing", 1)[0]
        self.assertNotIn("scroll_to_last_message_after_layout(true)", replacement_body)
        delivery = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        forbidden = "stop_typing(thread_id)\n\t\t\tawait get_tree().process_frame\n\t\t\tif not _runtime_delivery_request_is_current"
        self.assertNotIn(forbidden, delivery)
        self.assertIn("replace_typing_with_message", delivery)

    def test_duration_formula_dynamic_wait_and_player_speed_are_separate(self):
        source = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "INTER_MESSAGE_PAUSE_SECONDS := 0.30",
            "IMAGE_TYPING_DURATION_SECONDS := 1.50",
            "clampf(0.90 + float(text.length()) * 0.024, 1.20, 5.20)",
            "reading_speed_multiplier",
            "runtime_delivery_time_scale",
            "await get_tree().process_frame",
            "MIN_TYPING_SECONDS_X3 := 0.35",
            "MIN_TYPING_SECONDS_X8 := 0.22",
            "MIN_PAUSE_SECONDS := 0.04",
        ]:
            self.assertIn(token, source)
        self.assertNotIn("create_timer(seconds", source)

    def test_speed_button_has_exact_states_tooltips_and_target(self):
        source = self.read("game/scripts/ui/PortraitShell.gd")
        for token in [
            "reading_speed_button",
            "reading_speed_multiplier",
            'const READING_SPEEDS := [1.0, 3.0, 8.0]',
            'const READING_SPEED_LABELS := ["×1", "×3", "×8"]',
            '"Vitesse de lecture : normale"',
            '"Vitesse de lecture : rapide"',
            '"Vitesse de lecture : très rapide"',
            "Vector2(44, 44)",
        ]:
            self.assertIn(token, source)
        self.assertNotIn("debug", source.lower())

    def test_typing_animation_speed_is_configurable_and_reduced_motion_static(self):
        source = self.read("game/scripts/ui/messages/TypingIndicator.gd")
        for token in ["1.05", "0.70", "0.45", "reading_speed_multiplier", "reduced_motion_enabled"]:
            self.assertIn(token, source)

    def test_reduced_motion_reconfigures_active_typing_both_directions(self):
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        self.assertIn("messages_screen.reconfigure_active_typing()", shell)
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        self.assertIn("func reconfigure_active_typing()", messages)
        body = messages.split("func reconfigure_active_typing()", 1)[1].split("func ", 1)[0]
        self.assertIn("_sync_active_typing()", body)

    def test_smoke_uses_real_ui_and_three_resolutions(self):
        driver = self.read("game/tests/RUNTIME_S1_03CUniversalMessagePacingSmokeDriver.gd")
        runner = self.read("tools/test_runtime_s1_03c_universal_message_pacing.sh")
        self.assertIn('preload("res://scenes/portrait/PortraitMain.tscn")', driver)
        self.assertIn('emit_signal("pressed")', driver)
        for phrase in [
            "initial Marie messages must remain pending",
            "each incoming TEXT or IMAGE must have exactly one typing phase",
            "reopening a thread must not replay presented messages",
            "atomic replacement must never expose an empty frame",
            "bottom gap must remain at most two pixels",
            "speed must persist between threads and days",
            "speed change must affect the current wait",
            "choices must remain hidden until delivery completes",
            "final visual order must strictly match provider",
            "speed button must not crop at portrait resolution",
            "J01 Marie mandatory initial/segment typing exactly once",
            "J01 Sandra mandatory initial/segment typing exactly once",
            "J02 Marie start mandatory initial/segment typing exactly once",
            "J02 Marie 18:18 mandatory initial/segment typing exactly once",
            "J02 Mathilde mandatory initial/segment typing exactly once",
            "J03 Raphaelle mandatory initial/segment typing exactly once",
            "J03 Sandra mandatory initial/segment typing exactly once",
            "J03 Marie mandatory initial/segment typing exactly once",
            "speed cycle must be ×1→×3→×8→×1",
            "reduced motion ×8 typing must remain static",
            "speed button must remain visible inside header",
            "replacement spacer lifecycle must stabilize",
        ]:
            self.assertIn(phrase, driver)
        self.assertIn("540x960 720x1280 1080x1920", runner)


if __name__ == "__main__":
    unittest.main()
