import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class TUI02B2TypingIndicatorStaticTests(unittest.TestCase):
    def _read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_semantic_component_and_smoke_assets_exist(self):
        required = [
            "game/scripts/ui/messages/TypingIndicator.gd",
            "game/tests/T_UI_02B2TypingIndicatorSmokeDriver.gd",
            "game/tests/T_UI_02B2TypingIndicatorSmokeTest.tscn",
            "tools/test_t_ui_02b2_typing_indicator.sh",
        ]
        self.assertEqual([path for path in required if not (ROOT / path).exists()], [])

    def test_indicator_is_visual_only_and_accessible(self):
        indicator = self._read("game/scripts/ui/messages/TypingIndicator.gd")
        for forbidden in [
            "MessagePresentation", "messages.append", "unread_count", "is_read",
            "GameState", "DataLoader", "TimelineState", "PhonePrototype",
            "ConversationView", "LegacyMain", "res://data/", ".json",
            "DayDivider", "OffPhoneTransition",
        ]:
            self.assertNotIn(forbidden, indicator)
        self.assertIn("Control.FOCUS_NONE", indicator)
        self.assertIn("Control.MOUSE_FILTER_IGNORE", indicator)
        self.assertNotIn("Button.new", indicator)
        self.assertNotIn("timestamp", indicator.lower())
        self.assertIn("font_size", indicator)
        self.assertRegex(indicator, r"font_size[^\n]*1[4-9]")

    def test_timer_is_visual_only_and_reduced_motion_never_starts_it(self):
        indicator = self._read("game/scripts/ui/messages/TypingIndicator.gd")
        self.assertIn("Timer.new()", indicator)
        configure = indicator.split("func configure", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("phase_index = 0", configure)
        self.assertLess(configure.index("phase_index = 0"), configure.index("if reduced_motion:"))
        self.assertIn("if reduced_motion:", configure)
        reduced_branch = configure.split("if reduced_motion:", 1)[1].split("\telse:", 1)[0]
        self.assertIn("…", reduced_branch)
        self.assertNotIn("start(", reduced_branch)
        self.assertIn("_advance_visual_phase", indicator)
        self.assertNotIn("emit_signal", indicator)

    def test_messages_screen_owns_bounded_thread_local_state(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "typing_states_by_thread: Dictionary",
            "func start_typing(thread_id: String, author_id: String)",
            "func stop_typing(thread_id: String)",
            "func is_thread_typing(thread_id: String) -> bool",
            'author_id.to_lower() == "player"',
            'typing_states_by_thread[thread_id]',
            "_thread_accepts_author",
        ]:
            self.assertIn(token, screen)
        start = screen.split("func start_typing", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("if thread.is_empty():", start)
        self.assertIn("if author.is_empty():", start)
        self.assertIn("return", start)

    def test_timeline_hosts_at_most_one_indicator_without_mutating_messages(self):
        timeline = self._read("game/scripts/ui/messages/MessageTimeline.gd")
        for signature in [
            "func show_typing(author: Dictionary, reduced_motion: bool)",
            "func hide_typing()",
            "func typing_visible() -> bool",
            "func typing_instance_count() -> int",
            "func typing_animation_running() -> bool",
            "func advance_typing_phase()",
        ]:
            self.assertIn(signature, timeline)
        show = timeline.split("func show_typing", 1)[1].split("\nfunc ", 1)[0]
        hide = timeline.split("func hide_typing", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("typing_indicator == null", show)
        self.assertNotIn("messages.append", show)
        self.assertNotIn("messages.append", hide)
        self.assertNotIn("divider_count", hide)

    def test_typing_preserves_restored_scroll_and_only_follows_an_existing_bottom(self):
        timeline = self._read("game/scripts/ui/messages/MessageTimeline.gd")
        show = timeline.split("func show_typing", 1)[1].split("\nfunc ", 1)[0]
        for token in [
            "reading_position_restore_pending",
            "is_last_message_visible()",
            "should_follow_bottom",
        ]:
            self.assertIn(token, timeline)
        self.assertIn("should_follow_bottom", show)
        self.assertNotIn('call_deferred("scroll_to_last_message")', show)
        self.assertNotIn("scroll_to_last_message()", show)

    def test_b1_keeps_runtime_dependency_guards_without_obsolete_typing_ban(self):
        b1 = self._read("tests/test_t_ui_02b1_unread_notification_static.py")
        forbidden_block = b1.split("forbidden = [", 1)[1].split("]", 1)[0]
        self.assertNotIn("TypingIndicator", forbidden_block)
        for token in [
            "GameState", "DataLoader", "TimelineState", "PhonePrototype",
            "ConversationView", "LegacyMain", "res://data/", ".json",
        ]:
            self.assertIn(token, forbidden_block)

    def test_incoming_message_stops_only_its_thread_typing_first(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        method = screen.split("func simulate_incoming_message", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("stop_typing(thread_id)", method)
        self.assertLess(method.index("stop_typing(thread_id)"), method.index("thread_messages.append"))
        self.assertNotIn("stop_typing(active_thread_id)", method)

    def test_new_lot_has_no_historical_sha_or_visible_internal_mechanics(self):
        paths = [
            ROOT / "game/scripts/ui/messages/TypingIndicator.gd",
            ROOT / "game/tests/T_UI_02B2TypingIndicatorSmokeDriver.gd",
            ROOT / "tests/test_t_ui_02b2_typing_indicator_static.py",
        ]
        sha = re.compile(r"\b[0-9a-f]{40}\b", re.IGNORECASE)
        self.assertEqual([str(path) for path in paths if path.exists() and sha.search(path.read_text(encoding="utf-8"))], [])
        visible = self._read("game/scripts/ui/messages/TypingIndicator.gd")
        quoted = re.compile(r'"([^"\\]*(?:\\.[^"\\]*)*)"')
        forbidden = re.compile(r"\b(route|score|tier|trace_id|promise_id|fact_id|thread_id|author_id)\b", re.IGNORECASE)
        self.assertEqual([value for value in quoted.findall(visible) if forbidden.search(value)], [])


if __name__ == "__main__":
    unittest.main()
