import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class TUI02AMessagesStaticTests(unittest.TestCase):
    def _read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_semantic_messages_components_exist(self):
        required = [
            "game/scenes/portrait/messages/MessagesScreen.tscn",
            "game/scenes/portrait/messages/PortraitConversationScreen.tscn",
            "game/scripts/ui/messages/MessagesScreen.gd",
            "game/scripts/ui/messages/ConversationList.gd",
            "game/scripts/ui/messages/PortraitConversationScreen.gd",
            "game/scripts/ui/messages/MessageTimeline.gd",
            "game/scripts/ui/messages/ChoiceBar.gd",
            "game/scripts/ui/messages/MessagesDemoData.gd",
            "game/tests/T_UI_02AMessagesSmokeTest.tscn",
            "game/tests/T_UI_02AMessagesSmokeDriver.gd",
            "tools/test_t_ui_02a_messages.sh",
        ]
        missing = [path for path in required if not (ROOT / path).exists()]
        self.assertEqual(missing, [])

    def test_portrait_shell_hosts_messages_screen_and_dedicated_gallery_screen(self):
        shell = self._read("game/scripts/ui/PortraitShell.gd")
        self.assertIn('preload("res://scenes/portrait/messages/MessagesScreen.tscn")', shell)
        self.assertIn("messages_screen", shell)
        self.assertIn("MESSAGES_SCREEN_SCENE.instantiate()", shell)
        self.assertIn("_build_gallery_panel", shell)
        self.assertIn('preload("res://scenes/portrait/gallery/GalleryScreen.tscn")', shell)
        self.assertIn("GALLERY_SCREEN_SCENE.instantiate()", shell)
        self.assertNotIn("_make_thread_row", shell)

    def test_demo_data_is_separate_and_implements_presentation_contracts(self):
        data = self._read("game/scripts/ui/messages/MessagesDemoData.gd")
        for contract in [
            "CharacterPresentation",
            "ConversationThreadPresentation",
            "MessagePresentation",
            "ChoicePresentation",
        ]:
            self.assertIn(contract, data)
        for field in [
            '"character_id"', '"display_name"', '"accent_color"', '"avatar_ref"',
            '"thread_id"', '"participant_ids"', '"last_preview"', '"last_timestamp"',
            '"unread_count"', '"availability_state"', '"is_group"', '"is_archived"',
            '"message_id"', '"author_id"', '"timestamp"', '"content_type"', '"text"',
            '"media_ref"', '"is_player"', '"is_read"', '"source_day"',
            '"choice_id"', '"enabled"', '"confirmation_required"',
        ]:
            self.assertIn(field, data)
        for forbidden in ["DataLoader", "GameState", "TimelineState", ".json"]:
            self.assertNotIn(forbidden, data)
        self.assertIn("Texte de démonstration non canonique", data)

    def test_conversation_card_contains_required_visible_fields(self):
        component = self._read("game/scripts/ui/messages/ConversationList.gd")
        for token in ["ConversationCard", "display_name", "last_preview", "last_timestamp", "unread_count", "avatar_ref"]:
            self.assertIn(token, component)
        self.assertIn("AUTOWRAP_WORD_SMART", component)

    def test_message_bubble_distinguishes_player_and_interlocutor(self):
        timeline = self._read("game/scripts/ui/messages/MessageTimeline.gd")
        for token in ["MessageBubble", "is_player", "author_id", "timestamp", "PLAYER_ACCENT", "GroupAuthorAvatar"]:
            self.assertIn(token, timeline)
        self.assertIn("HORIZONTAL_ALIGNMENT_RIGHT", timeline)
        self.assertIn("HORIZONTAL_ALIGNMENT_LEFT", timeline)

    def test_choice_bar_accepts_one_to_three_responses(self):
        choices = self._read("game/scripts/ui/messages/ChoiceBar.gd")
        for token in ["ChoiceBar", "ChoiceButton", "choices.size() < 1", "choices.size() > 3", "choice_selected"]:
            self.assertIn(token, choices)
        self.assertIn("AUTOWRAP_WORD_SMART", choices)

    def test_choice_contract_is_exactly_one_player_message_without_auto_reply(self):
        screen = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        conversation = self._read("game/scripts/ui/messages/PortraitConversationScreen.gd")
        for token in ["player_message_count", "append_player_choice", "available_choices[active_thread_id] = []", "return_to_list"]:
            self.assertIn(token, screen)
        self.assertIn("choice_bar.clear_choices", conversation)
        self.assertNotIn("append_character", screen)
        self.assertNotIn("GameState", screen)

    def test_visible_demo_copy_exposes_no_progression_mechanics(self):
        paths = [
            ROOT / "game/scripts/ui/messages/MessagesDemoData.gd",
            ROOT / "game/scripts/ui/messages/ConversationList.gd",
            ROOT / "game/scripts/ui/messages/PortraitConversationScreen.gd",
            ROOT / "game/scripts/ui/messages/MessageTimeline.gd",
            ROOT / "game/scripts/ui/messages/ChoiceBar.gd",
        ]
        quoted = re.compile(r'"([^"\\]*(?:\\.[^"\\]*)*)"')
        forbidden = re.compile(r"\b(route|score|tier|trace_id|promise_id|fact_id)\b", re.IGNORECASE)
        offenders = []
        for path in paths:
            for value in quoted.findall(path.read_text(encoding="utf-8")):
                if forbidden.search(value):
                    offenders.append(f"{path.relative_to(ROOT)}: {value}")
        self.assertEqual(offenders, [])

    def test_messages_scripts_and_scenes_do_not_reference_legacy_runtime(self):
        paths = [
            "game/scenes/portrait/messages/MessagesScreen.tscn",
            "game/scenes/portrait/messages/PortraitConversationScreen.tscn",
            "game/scripts/ui/messages/ChoiceBar.gd",
            "game/scripts/ui/messages/ConversationList.gd",
            "game/scripts/ui/messages/MessageTimeline.gd",
            "game/scripts/ui/messages/MessagesDemoData.gd",
            "game/scripts/ui/messages/MessagesScreen.gd",
            "game/scripts/ui/messages/PortraitConversationScreen.gd",
        ]
        forbidden = [
            "GameState",
            "DataLoader",
            "TimelineState",
            "PhonePrototype",
            "ConversationView",
            "PhotoGalleryView",
            "LegacyMain",
            "res://data/",
            ".json",
        ]
        offenders = []
        for path in paths:
            content = self._read(path)
            for token in forbidden:
                if token in content:
                    offenders.append(f"{path}: {token}")
        self.assertEqual(offenders, [])


if __name__ == "__main__":
    unittest.main()
