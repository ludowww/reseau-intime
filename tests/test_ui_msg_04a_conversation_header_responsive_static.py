import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class UIMsg04AConversationHeaderResponsiveStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_exact_dedicated_assets_exist(self):
        required = [
            "game/tests/UI_MSG_04AConversationHeaderResponsiveSmokeDriver.gd",
            "game/tests/UI_MSG_04AConversationHeaderResponsiveSmokeTest.tscn",
            "tests/test_ui_msg_04a_conversation_header_responsive_static.py",
            "tools/test_ui_msg_04a_conversation_header_responsive.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_surface_signal_and_global_header_policy_are_explicit(self):
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        self.assertIn("signal screen_mode_changed(mode: String)", messages)
        self.assertIn("func _set_screen_mode(mode: String)", messages)
        self.assertIn("if screen_mode == mode:", messages)
        self.assertIn("screen_mode_changed.emit(screen_mode)", messages)
        self.assertIn("messages_screen.screen_mode_changed.connect(_set_messages_surface_mode)", shell)
        self.assertIn("func _set_messages_surface_mode(mode: String)", shell)
        self.assertIn('header_panel.visible = active_tab == TAG_GALLERY or mode == "list"', shell)
        header_build = shell.split('header_label = _make_label("Réseau Intime"', 1)[1].split("header_subtitle =", 1)[0]
        self.assertNotIn("ReadingSpeed", header_build)
        self.assertNotIn("_process(", shell)

    def test_conversation_header_has_identity_time_and_single_shell_speed_authority(self):
        conversation = self.read("game/scripts/ui/messages/PortraitConversationScreen.gd")
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        for token in [
            'conversation_header.name = "ConversationHeader"',
            'header_row.name = "HeaderRow"',
            'back_button.name = "Back"',
            'avatar_label.name = "Avatar"',
            'identity_column.name = "IdentityColumn"',
            'title_label.name = "ConversationName"',
            'narrative_time_label.name = "NarrativeTime"',
            'reading_speed_button.name = "ReadingSpeed"',
            "signal reading_speed_requested",
            "Vector2(44, 44)",
        ]:
            self.assertIn(token, conversation)
        self.assertIn('const READING_SPEEDS := [1.0, 3.0, 8.0]', shell)
        self.assertIn('const READING_SPEED_LABELS := ["×1", "×3", "×8"]', shell)
        self.assertEqual(1, shell.count("var reading_speed_index"))
        self.assertNotIn("reading_speed_index", conversation)
        self.assertNotIn("debug", (shell + conversation).lower())

    def test_narrative_time_is_visual_only_and_strict(self):
        conversation = self.read("game/scripts/ui/messages/PortraitConversationScreen.gd")
        self.assertIn("var narrative_time_label: Label", conversation)
        self.assertIn("func set_narrative_time(value: String)", conversation)
        self.assertIn('narrative_time = value if _is_valid_narrative_time(value) else ""', conversation)
        self.assertIn('narrative_time_label.visible = narrative_time != ""', conversation)
        self.assertIn("func _is_valid_narrative_time(value: String)", conversation)
        self.assertNotIn("Time.get_time", conversation)
        self.assertNotIn("get_datetime", conversation)
        self.assertNotIn("last_timestamp", conversation)

    def test_compact_mode_diagnostics_and_responsive_transitions_exist(self):
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        off_phone = self.read("game/scripts/ui/messages/OffPhoneTransition.gd")
        day = self.read("game/scripts/ui/messages/DayTransition.gd")
        self.assertIn("get_visible_bounds().size.y < 900", shell)
        self.assertIn("func _refresh_compact_height_mode()", shell)
        self.assertIn("func set_compact_height_mode(enabled: bool)", messages)
        for key in [
            "screen_mode", "compact_height_mode", "header_visible",
            "conversation_header_visible", "reading_speed_visible",
            "reading_speed_label", "narrative_time_visible", "narrative_time_text",
            "content_rect", "conversation_header_rect", "timeline_rect", "choice_bar_rect",
            "bottom_navigation_rect", "off_phone_transition_rect", "day_transition_rect",
            "has_vertical_crop",
        ]:
            self.assertIn(f'"{key}"', shell + messages + self.read("game/scripts/ui/messages/PortraitConversationScreen.gd"))
        self.assertIn("func surface_rect()", off_phone)
        self.assertIn("func surface_rect()", day)
        self.assertNotIn("Vector2(420, 330)", off_phone)
        self.assertNotIn("Vector2(380, 0)", day)

    def test_smoke_matrix_uses_real_main_scene_buttons_and_safe_areas(self):
        driver = self.read("game/tests/UI_MSG_04AConversationHeaderResponsiveSmokeDriver.gd")
        runner = self.read("tools/test_ui_msg_04a_conversation_header_responsive.sh")
        self.assertIn('preload("res://scenes/portrait/PortraitMain.tscn")', driver)
        self.assertIn('preload("res://scripts/ui/messages/MessagesDemoData.gd")', driver)
        self.assertIn('main.unified_save_path_override = SAVE_PATH', driver)
        self.assertIn('MessagesDemoData.build()', driver)
        self.assertIn('messages._apply_content_source(demo_source)', driver)
        self.assertIn('"demo_private_marie"', driver)
        self.assertIn('"demo_group_verriere"', driver)
        self.assertNotIn('"thread_marie_private"', driver)
        self.assertIn('if not _press_thread_card', driver)
        self.assertIn('return ""', driver)
        self.assertIn('emit_signal("pressed")', driver)
        for phrase in [
            "list global header visible", "conversation global header hidden",
            "conversation has no residual global header space", "one speed button visible",
            "speed persists across threads", "off-phone transition contained",
            "day transition contained", "no vertical crop", "no horizontal crop",
            "empty narrative time has no residual height",
            "narrative time displays exactly Mar. · 18:20",
        ]:
            self.assertIn(phrase, driver)
        for resolution in ["540x960", "720x800", "720x960", "720x1280", "1080x1920"]:
            self.assertIn(resolution, runner)
        for preset in ["none", "tall-portrait"]:
            self.assertIn(preset, runner)


if __name__ == "__main__":
    unittest.main()
