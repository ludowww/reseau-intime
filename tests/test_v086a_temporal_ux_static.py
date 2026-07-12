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

    def test_no_scheduler_button_or_time_prompt_remains(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        block = phone[phone.index("func _add_phase_advance_control") : phone.index("func _on_conversation_completed")]
        self.assertIn("return", block)
        for forbidden in [
            "ContinueDayButton",
            '"Continuer la journée"',
            '"Le temps passe"',
            "timeline_prompt_action",
            "show_timeline_prompt",
            "FinishDayButton",
            '"Finir la journée"',
        ]:
            self.assertNotIn(forbidden, phone)

    def test_last_message_stays_visible_during_accelerated_clock(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "TIME_PASSAGE_DELAY_SECONDS := 2.0",
            "CLOCK_ANIMATION_SECONDS := 5.0",
            "_run_clock_passage",
            "_animate_status_clock",
            "_minutes_to_clock",
            "status_time_label.text",
            "current_last_message_time",
        ]:
            self.assertIn(expected, phone + "\n" + conversation)
        self.assertIn("show_contact_offline", conversation)
        self.assertIn('"%s est hors ligne"', conversation)
        self.assertNotIn("show_moment_transition", phone)
        self.assertNotIn("show_day_transition", phone)
        self.assertNotIn("timeline_transition_view", phone)

    def test_authored_offline_beats_render_inside_current_thread(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "_activate_authored_beat_inline",
            "TimelineState.record_day_log_entry",
            "EffectApplier.apply_flags",
            "show_offline_beat",
        ]:
            self.assertIn(expected, phone + "\n" + conversation)

    def test_optional_window_can_expire_without_left_column_control(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "OPTIONAL_WINDOW_SECONDS := 8.0",
            "_schedule_optional_expiry",
            "TimelineState.is_optional_opened",
            "_advance_optional_phase",
        ]:
            self.assertIn(expected, phone)

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
        self.assertIn("_primary_notification_for_phase", phone)
        self.assertIn("if has_open_thread and conversation_view.has_method", phone)

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

    def test_scope_remains_ux_and_existing_offline_foundation_only(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8").lower()
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8").lower()
        combined = phone + "\n" + conversation
        for forbidden in ["apply_choice", "route_stage", "adult_frame", "cuckold"]:
            self.assertNotIn(forbidden, combined)
        self.assertIsNone(re.search(r"\bntr\b", combined), "standalone NTR token found in UX-only adapters")


if __name__ == "__main__":
    unittest.main()
