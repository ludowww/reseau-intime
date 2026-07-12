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

    def test_optional_phase_has_no_left_column_continue_button(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        block = phone[phone.index("func _add_phase_advance_control") : phone.index("func _queue_phase_activation")]
        self.assertIn("return", block)
        self.assertNotIn("ContinueDayButton", phone)
        self.assertNotIn('"Continuer la journée"', phone)

    def test_time_passage_is_prompted_inside_open_thread_before_phase_activation(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "timeline_prompt_action",
            "_queue_phase_activation",
            "_refresh_timeline_prompt",
            "_on_timeline_prompt_pressed",
            "Le temps passe",
            "Nouveau message de %s",
        ]:
            self.assertIn(expected, phone)
        for expected in [
            "timeline_prompt_pressed",
            "show_timeline_prompt",
            'shortcut_mode = "timeline"',
        ]:
            self.assertIn(expected, conversation)

    def test_ordinary_phase_does_not_auto_activate_from_completion(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        advance = phone[phone.index("func _advance_after_phase") : phone.index("func _activate_phase")]
        self.assertIn("_queue_phase_activation", advance)
        self.assertNotIn("await _activate_phase", advance)

    def test_timeline_cards_wait_for_explicit_click(self):
        transition = (GAME / "scripts/ui/TimelineTransitionView.gd").read_text(encoding="utf-8")
        self.assertIn('card.get("click_required", true)', transition)
        self.assertIn("while token == sequence_token and not skip_requested", transition)
        self.assertIn('hint_label.text = "Cliquer pour continuer"', transition)

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
