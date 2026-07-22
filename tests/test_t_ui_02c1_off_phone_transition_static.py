import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class TUI02C1OffPhoneTransitionStaticTests(unittest.TestCase):
    def _read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_semantic_component_and_smoke_assets_exist(self):
        required = [
            "game/scripts/ui/messages/OffPhoneTransition.gd",
            "game/tests/T_UI_02C1OffPhoneTransitionSmokeDriver.gd",
            "game/tests/T_UI_02C1OffPhoneTransitionSmokeTest.tscn",
            "tools/test_t_ui_02c1_off_phone_transition.sh",
        ]
        self.assertEqual([path for path in required if not (ROOT / path).exists()], [])

    def test_demo_fixture_uses_complete_off_phone_message_contract(self):
        data = self._read("game/scripts/ui/messages/MessagesDemoData.gd")
        self.assertIn('"OFF_PHONE_TRANSITION"', data)
        self.assertIn("_off_phone_transition(", data)
        helper = data.split("static func _off_phone_transition", 1)[1].split("\nstatic func ", 1)[0]
        for token in [
            '"message_id": message_id', '"author_id": "system"', '"timestamp": ""',
            '"content_type": "OFF_PHONE_TRANSITION"', '"text": text', '"media_ref": ""',
            '"is_player": false', '"is_read": true', '"source_day": source_day',
        ]:
            self.assertIn(token, helper)

    def test_timeline_detects_transition_without_rendering_a_message_bubble(self):
        timeline = self._read("game/scripts/ui/messages/MessageTimeline.gd")
        build = timeline.split("func _build()", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn('== "OFF_PHONE_TRANSITION"', build)
        self.assertIn("continue", build)
        off_branch = build.split('== "OFF_PHONE_TRANSITION"', 1)[1].split("continue", 1)[0]
        self.assertNotIn("_build_message_bubble", off_branch)

    def test_messages_screen_owns_one_bounded_local_state_and_api(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            "off_phone_state: Dictionary", "func start_off_phone_transition(thread_id: String) -> void",
            "func finish_off_phone_transition() -> void", "func is_off_phone_transition_active() -> bool",
            'off_phone_state.get("active", false)', '"thread_id": thread_id',
            '"transition_message_id"', '"resume_focus_target"',
        ]:
            self.assertIn(token, screen)
        start = screen.split("func start_off_phone_transition", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("if is_off_phone_transition_active():", start)
        self.assertIn("if thread.is_empty():", start)
        self.assertIn("return", start)
        self.assertNotIn("append", start)

    def test_mutating_and_navigation_apis_are_guarded_during_co_presence(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        for name in [
            "open_thread", "return_to_list", "activate_first_choice", "start_typing",
            "stop_typing", "simulate_incoming_message", "_on_choice_selected",
        ]:
            method = screen.split(f"func {name}", 1)[1].split("\nfunc ", 1)[0]
            self.assertIn("is_off_phone_transition_active()", method, name)
            self.assertIn("return", method, name)

    def test_surface_is_accessible_focusable_and_reduced_motion_is_instant(self):
        surface = self._read("game/scripts/ui/messages/OffPhoneTransition.gd")
        for token in [
            "class_name OffPhoneTransition", 'resume_requested.emit()', 'text = "Reprendre le fil"',
            "custom_minimum_size = Vector2(0, 48)", "card.custom_minimum_size = Vector2(420, 330)", "Control.FOCUS_ALL",
            'add_theme_stylebox_override("focus"', "autowrap_mode", "grab_focus",
        ]:
            self.assertIn(token, surface)
        reduced = surface.split("if reduced_motion:", 1)[1].split("\telse:", 1)[0]
        self.assertNotIn("Tween", reduced)
        self.assertNotIn("Timer", reduced)
        self.assertNotIn("create_tween", reduced)
        self.assertNotIn("Timer.new", surface)

    def test_visual_component_never_mutates_messages_or_runtime_state(self):
        surface = self._read("game/scripts/ui/messages/OffPhoneTransition.gd")
        for forbidden in [
            "messages.append", "messages.erase", "transcripts", "GameState", "DataLoader",
            "TimelineState", "PhonePrototype", "ConversationView", "LegacyMain", "res://data/", ".json",
        ]:
            self.assertNotIn(forbidden, surface)

    def test_lot_has_no_runtime_dependency_historical_sha_or_path_obfuscation(self):
        paths = [
            "game/scripts/ui/messages/OffPhoneTransition.gd",
            "game/scripts/ui/messages/MessagesScreen.gd",
            "game/scripts/ui/messages/MessageTimeline.gd",
            "game/scripts/ui/messages/MessagesDemoData.gd",
            "game/tests/T_UI_02C1OffPhoneTransitionSmokeDriver.gd",
        ]
        forbidden = [
            "GameState", "DataLoader", "TimelineState", "PhonePrototype", "ConversationView",
            "LegacyMain", "res://data/", ".json", "change_day", "next_day",
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
        surface = self._read("game/scripts/ui/messages/OffPhoneTransition.gd")
        quoted = re.compile(r'"([^"\\]*(?:\\.[^"\\]*)*)"')
        forbidden = re.compile(
            r"\b(route|score|flag|tier|trace_id|promise_id|fact_id|moment_id|thread_id|source_day)\b",
            re.IGNORECASE,
        )
        self.assertEqual([value for value in quoted.findall(surface) if forbidden.search(value)], [])

if __name__ == "__main__":
    unittest.main()
