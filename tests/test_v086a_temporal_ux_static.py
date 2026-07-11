import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class V086ATemporalUxStaticTests(unittest.TestCase):
    def test_active_scenes_use_v086a_adapters(self):
        phone_scene = (GAME / "scenes/smartphone/PhonePrototype.tscn").read_text(encoding="utf-8")
        conversation_scene = (GAME / "scenes/smartphone/ConversationView.tscn").read_text(encoding="utf-8")
        self.assertIn("PhonePrototypeV086A.gd", phone_scene)
        self.assertIn("ConversationViewV086A.gd", conversation_scene)

        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV085.gd"', phone)
        self.assertIn('extends "res://scripts/ui/ConversationViewV084.gd"', conversation)

    def test_optional_advance_uses_natural_label_without_exact_time(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        self.assertIn('var label := "Continuer la journée"', phone)
        self.assertNotIn('"Continuer vers 16:05"', phone)
        self.assertIn('button.name = "ContinueDayButton"', phone)

    def test_ordinary_phase_activation_has_no_automatic_moment_overlay(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        start = phone.index("func _activate_phase")
        end = phone.index("func _add_phase_advance_control")
        block = phone[start:end]
        self.assertNotIn("show_moment_transition", block)
        self.assertIn("_phase_has_authored_beat", block)
        self.assertIn("_unlock_phase_conversations", block)

    def test_end_of_day_requires_player_click(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        self.assertIn("day_finish_ready", phone)
        self.assertIn('"Finir la journée"', phone)
        self.assertIn("_finish_day_requested", phone)
        advance = phone[phone.index("func _advance_after_phase") : phone.index("func _activate_phase")]
        self.assertNotIn("_complete_day(day_value)", advance)
        self.assertIn("day_finish_ready[str(day_value)] = true", advance)

    def test_in_thread_notification_is_clickable_and_switches_target(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "show_thread_notification",
            "hide_thread_notification",
            "thread_notification_pressed",
            "Nouveau message · %s",
            "ThreadNotificationShortcut",
        ]:
            self.assertIn(expected, conversation)
        self.assertIn('conversation_view.connect("thread_notification_pressed"', phone)
        self.assertIn("_open_notification_target", phone)
        self.assertIn("_notification_time_for_thread", phone)

    def test_unread_cards_have_strong_distinct_styling(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        for expected in [
            '"UnreadContactCard"',
            '"ActiveContactCard"',
            '"ReadContactCard"',
            '"NON LU"',
            'badge.text = "●"',
            "PENDING_COLOR",
            "outline_size",
        ]:
            self.assertIn(expected, phone)

    def test_scope_remains_ux_only(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8").lower()
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8").lower()
        combined = phone + "\n" + conversation
        for forbidden in ["sets_flags", "apply_choice", "route_stage", "adult_frame", "cuckold"]:
            self.assertNotIn(forbidden, combined)
        self.assertIsNone(re.search(r"\bntr\b", combined), "standalone NTR token found in UX-only adapters")


if __name__ == "__main__":
    unittest.main()
