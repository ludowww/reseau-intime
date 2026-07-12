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

    def test_last_message_stays_visible_during_four_second_clock(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "TIME_PASSAGE_DELAY_SECONDS := 2.0",
            "CLOCK_ANIMATION_SECONDS := 4.0",
            "_run_clock_passage",
            "_animate_status_clock",
            "_minutes_to_clock",
            "_set_phone_clock_text",
            "current_last_message_time",
        ]:
            self.assertIn(expected, phone + "\n" + conversation)
        self.assertIn("show_contact_offline", conversation)
        self.assertIn('"%s est hors ligne"', conversation)
        self.assertNotIn("show_moment_transition", phone)
        self.assertNotIn("show_day_transition", phone)
        self.assertNotIn("timeline_transition_view", phone)

    def test_phone_status_is_fixed_above_contact_and_left_copy_is_hidden(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "ConversationPhoneStatusBar",
            "ConversationPhoneClock",
            "ConversationPhoneConnectivity",
            "set_phone_status",
            "set_phone_clock_emphasis",
            "Wi‑Fi",
            "82%",
            "chat_shell.move_child(phone_status_panel, 0)",
        ]:
            self.assertIn(expected, conversation)
        for expected in [
            "HiddenNarrativeClock",
            "status_time_label.visible = false",
            "_sync_conversation_phone_status",
            "PHONE_CONNECTIVITY_TEXT",
        ]:
            self.assertIn(expected, phone)

    def test_choice_free_threads_do_not_explain_the_absence_of_choices(self):
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        self.assertIn("func _show_choices_for_segment", conversation)
        self.assertIn("super._show_choices_for_segment(data, false, persist_state)", conversation)
        self.assertNotIn("Aucun choix direct dans cette conversation.", conversation)

    def test_offline_activity_remains_internal_and_is_not_rendered_or_archived(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "_activate_authored_beat_silently",
            "TimelineState.record_day_log_entry",
            "EffectApplier.apply_flags",
            'str(message.get("presentation", "")) == "offline_beat"',
            "_record_authored_history_key",
        ]:
            self.assertIn(expected, phone + "\n" + conversation)
        self.assertNotIn("show_offline_beat", phone + "\n" + conversation)

        archive = phone[phone.index("func _render_archived_day") : phone.index("func _add_phase_advance_control")]
        self.assertNotIn("get_day_log_entries", archive)
        self.assertNotIn('_add_label(conversation_list, "Moments hors ligne"', archive)
        self.assertNotIn("super._render_archived_day", archive)

    def test_optional_window_can_expire_without_left_column_control(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "OPTIONAL_WINDOW_SECONDS := 8.0",
            "_schedule_optional_expiry",
            "TimelineState.is_optional_opened",
            "_advance_optional_phase",
        ]:
            self.assertIn(expected, phone)

    def test_external_notification_is_compact_animated_and_preserves_bottom(self):
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "NOTIFICATION_PREVIEW_CHARACTERS := 10",
            "_compact_notification_preview",
            "normalized.substr(0, NOTIFICATION_PREVIEW_CHARACTERS)",
            "_play_thread_notification_arrival",
            "create_tween()",
            '"modulate"',
            "_scroll_to_bottom.call_deferred()",
        ]:
            self.assertIn(expected, conversation)
        self.assertNotIn("thread_notification_panel.grab_focus", conversation)

    def test_same_thread_resumes_without_notification_banner(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "if has_open_thread and active_thread_id == conversation_id",
            "_continue_active_thread",
            'conversation_view.call("continue_active_thread"',
            "current_thread_id",
            "continue_active_thread",
            "_resume_active_thread",
            "_auto_advance_segments_until_choice",
        ]:
            self.assertIn(expected, phone + "\n" + conversation)

    def test_multi_contact_phase_surfaces_next_unfinished_thread(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        for expected in [
            "_next_unfinished_phase_notification",
            "_notification_for_episode",
            "TimelineState.is_episode_completed",
            "remaining_notification",
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

    def test_scope_remains_ux_and_existing_state_foundation_only(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8").lower()
        conversation = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8").lower()
        combined = phone + "\n" + conversation
        for forbidden in ["apply_choice", "route_stage", "adult_frame", "cuckold"]:
            self.assertNotIn(forbidden, combined)
        self.assertIsNone(re.search(r"\bntr\b", combined), "standalone NTR token found in UX-only adapters")


if __name__ == "__main__":
    unittest.main()
