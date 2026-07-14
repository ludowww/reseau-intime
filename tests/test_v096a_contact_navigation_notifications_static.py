import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class V096AContactNavigationNotificationsStaticTests(unittest.TestCase):
    def setUp(self):
        self.phone_scene = (GAME / "scenes" / "smartphone" / "PhonePrototype.tscn").read_text(encoding="utf-8")
        self.conversation_scene = (GAME / "scenes" / "smartphone" / "ConversationView.tscn").read_text(encoding="utf-8")
        self.phone = (GAME / "scripts" / "ui" / "PhonePrototypeV096A.gd").read_text(encoding="utf-8")
        self.conversation = (GAME / "scripts" / "ui" / "ConversationViewV096A.gd").read_text(encoding="utf-8")
        self.chapter9 = json.loads((GAME / "data" / "conversations" / "chapter_09_modular_index.json").read_text(encoding="utf-8"))

    def test_scenes_point_to_v096a_scripts(self):
        self.assertIn("PhonePrototypeV096A.gd", self.phone_scene)
        self.assertIn("ConversationViewV096A.gd", self.conversation_scene)

    def test_phone_script_exposes_contacts_and_history_navigation(self):
        for token in [
            'const MODE_CONTACTS := "CONTACTS"',
            'const MODE_HISTORY := "HISTORY"',
            '_show_contacts()',
            '_show_history()',
            '_show_history_day(',
            '_collect_global_threads(',
            '_open_notification_target(',
            '_ensure_named_boundaries_ledger()',
            '_record_named_boundaries_visual_route(',
            'PhotoGalleryView.tscn',
            'VisualDayContract.evaluate',
        ]:
            self.assertIn(token, self.phone)

    def test_conversation_back_button_signal_exists(self):
        self.assertIn('signal contacts_requested', self.conversation)
        self.assertIn('ContactsBackButton', self.conversation)
        self.assertIn('Retour aux contacts', self.conversation)

    def test_day9_unlocks_and_notifications_exist_without_cross_day_gate(self):
        availability = self.chapter9.get("conversation_availability", {})
        unlocks = availability.get("unlocks", {})
        for convo_id, title, body in [
            ("chapter_09_mathilde_visual_boundary", "Mathilde", "J’ai enfin eu le réparateur."),
            ("chapter_09_sandra_visual_boundary", "Sandra", "Je dois déplacer notre déjeuner."),
            ("chapter_09_marie_pauline_social_set", "Marie + Pauline", "Nico garde la table encore quelques minutes."),
        ]:
            self.assertIn(convo_id, unlocks)
            rule = unlocks[convo_id]
            self.assertTrue(rule.get("pending"), convo_id)
            self.assertNotIn("after_conversation_completed", rule, convo_id)
            self.assertEqual(rule.get("notification", {}).get("title"), title)
            self.assertIn(body, rule.get("notification", {}).get("body", ""))

    def test_social_set_waits_for_its_phase(self):
        availability = self.chapter9.get("conversation_availability", {})
        self.assertEqual(availability.get("initial_conversation_ids", []), [])
        self.assertIn("chapter_09_marie_pauline_social_set", availability.get("unlocks", {}))

    def test_history_cards_open_read_only_threads(self):
        for token in [
            '_open_history_conversation(',
            'show_archive_conversation',
            'card.gui_input.connect',
            'phone_mode = MODE_HISTORY',
        ]:
            self.assertIn(token, self.phone)

    def test_hidden_conversation_uses_visible_phone_notification(self):
        self.assertIn('and conversation_view.visible', self.phone)
        self.assertIn('_show_notification("%s — %s"', self.phone)

    def test_gallery_hides_messages_landing(self):
        self.assertIn('func _show_gallery(content_id: String = "") -> void:', self.phone)
        self.assertIn('landing_panel.visible = false', self.phone)
        self.assertIn('super._show_gallery(content_id)', self.phone)

    def test_same_thread_notification_reopens_hidden_thread(self):
        self.assertIn('var same_thread :=', self.phone)
        self.assertIn('_set_thread_view_visible(true)', self.phone)
        self.assertIn('continue_active_thread', self.phone)


if __name__ == "__main__":
    unittest.main()
