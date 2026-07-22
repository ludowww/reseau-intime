import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class TUI02C2DayTransitionStaticTests(unittest.TestCase):
    def _read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def _method(self, source: str, name: str) -> str:
        return source.split(f"func {name}", 1)[1].split("\nfunc ", 1)[0]

    def test_semantic_component_and_smoke_assets_exist(self):
        required = [
            "game/scripts/ui/messages/DayTransition.gd",
            "game/tests/T_UI_02C2DayTransitionSmokeDriver.gd",
            "game/tests/T_UI_02C2DayTransitionSmokeTest.tscn",
            "tools/test_t_ui_02c2_day_transition.sh",
        ]
        self.assertEqual([path for path in required if not (ROOT / path).exists()], [])

    def test_messages_screen_owns_bounded_local_day_state_and_proof_apis(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "day_transition_state: Dictionary", "applied_demo_day_transitions: Dictionary",
            "func start_day_transition(from_day: int, to_day: int) -> void",
            "func finish_day_transition() -> void", "func is_day_transition_active() -> bool",
            "func current_demo_day() -> int", "func day_transition_surface_count() -> int",
            "func day_transition_action_count() -> int", "func day_transition_applied_count(to_day: int) -> int",
            "func presentation_count_by_id(message_id: String) -> int",
            '"previous_screen"', '"previous_thread_id"', '"resume_focus_target"',
            '"typing_snapshot"', '"notification_snapshot"',
        ]:
            self.assertIn(token, screen)

    def test_invalid_days_duplicate_start_and_off_phone_conflict_are_no_ops(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        start = self._method(screen, "start_day_transition")
        self.assertRegex(start, r"from_day\s*<=\s*0")
        self.assertRegex(start, r"to_day\s*<=\s*from_day")
        self.assertIn("is_day_transition_active()", start)
        self.assertIn("is_off_phone_transition_active()", start)
        before_configure = start.split("day_transition.configure", 1)[0]
        self.assertNotIn("transcripts[", before_configure)
        self.assertNotIn("unread_count", before_configure)
        off_start = self._method(screen, "start_off_phone_transition")
        self.assertIn("is_day_transition_active()", off_start)
        off_finish = self._method(screen, "finish_off_phone_transition")
        self.assertIn("is_day_transition_active()", off_finish)

    def test_messages_apis_are_blocked_during_day_transition(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        for name in [
            "open_thread", "return_to_list", "activate_first_choice", "start_typing",
            "stop_typing", "simulate_incoming_message", "start_off_phone_transition",
            "finish_off_phone_transition", "_on_choice_selected",
        ]:
            method = self._method(screen, name)
            self.assertTrue(
                "is_day_transition_active()" in method or "_message_interaction_blocked()" in method,
                name,
            )
            self.assertIn("return", method, name)

    def test_delta_is_local_applied_only_on_finish_and_idempotent(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        data = self._read("game/scripts/ui/messages/MessagesDemoData.gd")
        start = self._method(screen, "start_day_transition")
        finish = self._method(screen, "finish_day_transition")
        apply_delta = self._method(screen, "_apply_demo_day_delta")
        self.assertNotIn("_apply_demo_day_delta", start)
        self.assertIn("_apply_demo_day_delta", finish)
        self.assertIn("applied_demo_day_transitions.has(to_day)", apply_delta)
        self.assertIn("applied_demo_day_transitions[to_day] = 1", apply_delta)
        for token in [
            '"current_demo_day": 2', '"next_demo_day": 3', '"day_transition_deltas"',
            '"demo_day_private_03"', '"demo_day3_marie_01"', '"Mercredi"',
            '"author_id": "marie"', '"is_player": false', '"is_read": false',
        ]:
            self.assertIn(token, data)
        self.assertNotIn('"author_id": "player"', self._method(data, "day_transition_delta"))

    def test_finish_returns_to_list_without_reopening_or_restoring_typing(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        finish = self._method(screen, "finish_day_transition")
        self.assertIn('screen_mode = "list"', finish)
        self.assertIn("conversation_list.visible = true", finish)
        self.assertIn("conversation_screen.visible = false", finish)
        self.assertIn("typing_states_by_thread.erase", finish)
        self.assertNotIn("open_thread(", finish)
        self.assertNotIn("_sync_active_typing", finish)
        self.assertNotIn("_show_notification", finish)
        self.assertIn("focus_thread", finish)

    def test_surface_has_one_accessible_action_and_reduced_motion_is_instant(self):
        surface = self._read("game/scripts/ui/messages/DayTransition.gd")
        for token in [
            "class_name DayTransition", "signal continue_requested", 'text = "Continuer"',
            "custom_minimum_size = Vector2(0, 48)", "Control.FOCUS_ALL",
            'add_theme_stylebox_override("focus"', "autowrap_mode", "grab_focus",
            '"La journée se termine"', "action_count()", "action_height()",
        ]:
            self.assertIn(token, surface)
        reduced = surface.split("if reduced_motion:", 1)[1].split("\telse:", 1)[0]
        self.assertNotIn("Tween", reduced)
        self.assertNotIn("Timer", reduced)
        self.assertNotIn("create_tween", reduced)
        self.assertNotIn("Timer.new", surface)
        self.assertRegex(surface, r"tween_property\([^\n]+0\.(?:15|16|17|18|19|20|21|22|23|24|25)\)")

    def test_lot_has_no_runtime_json_sha_or_composed_resource_path(self):
        paths = [
            "game/scripts/ui/messages/DayTransition.gd",
            "game/scripts/ui/messages/MessagesScreen.gd",
            "game/scripts/ui/messages/MessagesDemoData.gd",
            "game/tests/T_UI_02C2DayTransitionSmokeDriver.gd",
        ]
        forbidden = [
            "GameState", "DataLoader", "TimelineState", "PhonePrototype", "ConversationView",
            "LegacyMain", "res://data/", ".json", "change_day", "save_game", "autosave",
        ]
        sha = re.compile(r"\b[0-9a-f]{40}\b", re.IGNORECASE)
        offenders = []
        for relative in paths:
            path = ROOT / relative
            if not path.exists():
                continue
            content = path.read_text(encoding="utf-8")
            if sha.search(content):
                offenders.append(f"{relative}: historical SHA")
            if '"res://scripts/ui/messages/" + ' in content:
                offenders.append(f"{relative}: composed resource path")
            for token in forbidden:
                if token in content:
                    offenders.append(f"{relative}: {token}")
        self.assertEqual(offenders, [])

    def test_player_facing_copy_exposes_no_internal_mechanics(self):
        surface = self._read("game/scripts/ui/messages/DayTransition.gd")
        quoted = re.compile(r'"([^"\\]*(?:\\.[^"\\]*)*)"')
        forbidden = re.compile(
            r"\b(route|score|flag|tier|trace_id|promise_id|fact_id|moment_id|thread_id|source_day)\b",
            re.IGNORECASE,
        )
        self.assertEqual([value for value in quoted.findall(surface) if forbidden.search(value)], [])


if __name__ == "__main__":
    unittest.main()
