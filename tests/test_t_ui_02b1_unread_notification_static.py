import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class TUI02B1UnreadNotificationStaticTests(unittest.TestCase):
    def _read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_semantic_components_and_smoke_assets_exist(self):
        required = [
            "game/scripts/ui/messages/UnreadDivider.gd",
            "game/scripts/ui/messages/NotificationBanner.gd",
            "game/tests/T_UI_02B1UnreadNotificationSmokeDriver.gd",
            "game/tests/T_UI_02B1UnreadNotificationSmokeTest.tscn",
            "tools/test_t_ui_02b1_unread_notification.sh",
        ]
        self.assertEqual([path for path in required if not (ROOT / path).exists()], [])

    def test_typing_indicator_and_forbidden_runtime_dependencies_are_absent(self):
        paths = [
            "game/scripts/ui/messages/MessagesScreen.gd",
            "game/scripts/ui/messages/ConversationList.gd",
            "game/scripts/ui/messages/MessageTimeline.gd",
            "game/scripts/ui/messages/MessagesDemoData.gd",
            "game/scripts/ui/messages/PortraitConversationScreen.gd",
            "game/scripts/ui/messages/UnreadDivider.gd",
            "game/scripts/ui/messages/NotificationBanner.gd",
        ]
        forbidden = [
            "TypingIndicator", "GameState", "DataLoader", "TimelineState",
            "PhonePrototype", "ConversationView", "LegacyMain", "res://data/", ".json",
        ]
        offenders = []
        for path in paths:
            content = self._read(path)
            for token in forbidden:
                if token in content:
                    offenders.append(f"{path}: {token}")
        self.assertEqual(offenders, [])

    def test_unread_state_is_updated_per_thread_and_messages_become_read(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "simulate_incoming_message(thread_id: String)",
            "_first_unread_message_id",
            'message["is_read"] = true',
            'thread["unread_count"]',
            "update_thread_presentation(thread)",
        ]:
            self.assertIn(token, screen)
        self.assertIn('str(thread.get("thread_id", "")) == thread_id', screen)

    def test_conversation_list_has_targeted_refresh_without_rebuilding(self):
        component = self._read("game/scripts/ui/messages/ConversationList.gd")
        self.assertIn("func update_thread_presentation(thread: Dictionary)", component)
        for field in ["LastPreview", "LastTimestamp", "UnreadCount"]:
            self.assertIn(field, component)
        method = component.split("func update_thread_presentation", 1)[1].split("\nfunc ", 1)[0]
        self.assertNotIn("_build()", method)

    def test_unread_divider_is_visual_only_and_bounded_by_message_id(self):
        timeline = self._read("game/scripts/ui/messages/MessageTimeline.gd")
        divider = self._read("game/scripts/ui/messages/UnreadDivider.gd")
        self.assertIn("first_unread_message_id", timeline)
        self.assertIn('message.get("message_id", "")', timeline)
        self.assertIn("Nouveaux messages", divider)
        self.assertNotIn("messages.append", divider)
        self.assertNotIn("MessagePresentation", divider)

    def test_notification_banner_actions_are_accessible_without_automatic_focus(self):
        banner = self._read("game/scripts/ui/messages/NotificationBanner.gd")
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        self.assertIn("FOCUS_NONE", banner)
        self.assertGreaterEqual(banner.count("Control.FOCUS_ALL"), 2)
        self.assertGreaterEqual(banner.count('add_theme_stylebox_override("focus", PORTRAIT_THEME.focus_style())'), 2)
        self.assertIn("Vector2(72, 48)", banner)
        self.assertIn("Vector2(48, 48)", banner)
        self.assertNotIn("grab_focus", banner)
        self.assertNotIn("Timer", screen)
        self.assertNotIn("create_timer", screen)
        self.assertIn("notification_banner", screen)

    def test_open_thread_simulation_preserves_a_foreign_notification(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        method = screen.split("func simulate_incoming_message", 1)[1].split("\nfunc ", 1)[0]
        open_branch = method.split("if is_open:", 1)[1].split("\telse:", 1)[0]
        self.assertIn("_notification_targets(thread_id)", open_branch)
        self.assertNotIn("notification_banner != null", open_branch)
        self.assertIn('notification_banner.notification.get("thread_id", "")', screen)

    def test_invalid_thread_is_an_explicit_no_op(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        method = screen.split("func simulate_incoming_message", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("if thread.is_empty():", method)
        self.assertIn("return", method)

    def test_demo_has_one_unread_thread_and_multiple_unread_incoming_messages(self):
        data = self._read("game/scripts/ui/messages/MessagesDemoData.gd")
        self.assertIn('"unread_count": 2', data)
        self.assertIn('"unread_count": 0', data)
        self.assertGreaterEqual(data.count("false, false)"), 2)
        self.assertIn("incoming_by_thread", data)

    def test_no_historical_sha_or_visible_progression_mechanic_copy(self):
        test_paths = [
            ROOT / "tests/test_t_ui_02b1_unread_notification_static.py",
            ROOT / "game/tests/T_UI_02B1UnreadNotificationSmokeDriver.gd",
        ]
        sha = re.compile(r"\b[0-9a-f]{40}\b", re.IGNORECASE)
        self.assertEqual([str(path) for path in test_paths if sha.search(path.read_text(encoding="utf-8"))], [])

        visible_paths = [
            ROOT / "game/scripts/ui/messages/MessagesDemoData.gd",
            ROOT / "game/scripts/ui/messages/UnreadDivider.gd",
            ROOT / "game/scripts/ui/messages/NotificationBanner.gd",
        ]
        quoted = re.compile(r'"([^"\\]*(?:\\.[^"\\]*)*)"')
        forbidden = re.compile(r"\b(route|score|tier|trace_id|promise_id|fact_id)\b", re.IGNORECASE)
        offenders = []
        for path in visible_paths:
            for value in quoted.findall(path.read_text(encoding="utf-8")):
                if forbidden.search(value):
                    offenders.append(f"{path.relative_to(ROOT)}: {value}")
        self.assertEqual(offenders, [])


if __name__ == "__main__":
    unittest.main()
