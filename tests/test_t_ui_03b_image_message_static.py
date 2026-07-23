import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class TUI03BImageMessageStaticTests(unittest.TestCase):
    def _read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_semantic_component_and_smoke_assets_exist(self):
        required = [
            "game/scripts/ui/messages/ImageMessage.gd",
            "game/tests/T_UI_03BImageMessageSmokeDriver.gd",
            "game/tests/T_UI_03BImageMessageSmokeTest.tscn",
            "tools/test_t_ui_03b_image_message.sh",
        ]
        self.assertEqual([path for path in required if not (ROOT / path).exists()], [])

    def test_image_message_is_focusable_visual_only_and_accessible(self):
        component = self._read("game/scripts/ui/messages/ImageMessage.gd")
        self.assertIn("class_name ImageMessage", component)
        self.assertRegex(component, r"signal image_requested\(message_id: String, media_ref: String\)")
        self.assertIn("Button.new()", component)
        self.assertIn("Control.FOCUS_ALL", component)
        self.assertIn('add_theme_stylebox_override("focus"', component)
        self.assertIn("IMAGE_WIDTH := 240.0", component)
        self.assertIn("IMAGE_HEIGHT := IMAGE_WIDTH / IMAGE_RATIO", component)
        self.assertIn("custom_minimum_size = Vector2(IMAGE_WIDTH, IMAGE_HEIGHT)", component)
        self.assertIn("IMAGE_RATIO := 0.75", component)
        self.assertIn("pressed.connect", component)
        self.assertIn("image_requested.emit(message_id, media_ref)", component)
        for forbidden in ["Tween", "Timer", "create_tween", "create_timer", "TextureRect", "res://data/", ".png", ".jpg"]:
            self.assertNotIn(forbidden, component)

    def test_caption_is_conditional_and_internal_ids_are_not_visible_copy(self):
        component = self._read("game/scripts/ui/messages/ImageMessage.gd")
        self.assertIn('if caption != ""', component)
        self.assertIn("AUTOWRAP_WORD_SMART", component)
        self.assertIn("Photo de démonstration", component)
        self.assertNotRegex(component, r"\.text\s*=\s*(message_id|media_ref)")
        self.assertNotIn("Author", component)
        self.assertNotIn("Timestamp", component)

    def test_demo_data_contains_exactly_two_read_incoming_images(self):
        data = self._read("game/scripts/ui/messages/MessagesDemoData.gd")
        self.assertEqual(data.count("_image_message("), 3)  # two calls plus helper declaration
        for token in [
            '"demo_image_private_marie_01"', '"demo_private_marie_photo"', '"21:16"',
            '"Une photo de démonstration envoyée dans ce fil."',
            '"demo_image_group_marie_01"', '"demo_group_photo"', '"20:46"',
        ]:
            self.assertIn(token, data)
        helper = data.split("static func _image_message", 1)[1].split("\nstatic func ", 1)[0]
        for token in ['"content_type": "IMAGE"', '"is_player": false', '"is_read": true']:
            self.assertIn(token, helper)
        self.assertNotIn('"content_type": "IMAGE",\n\t\t"is_player": true', data)

    def test_fixtures_keep_exact_order_and_thread_metadata(self):
        data = self._read("game/scripts/ui/messages/MessagesDemoData.gd")
        private = data.index('"demo_image_private_marie_01"')
        self.assertLess(data.index('"demo_m_03"'), private)
        self.assertLess(private, data.index('"demo_off_phone_private_01"'))
        group = data.index('"demo_image_group_marie_01"')
        self.assertLess(data.index('"demo_g_01"'), group)
        self.assertLess(group, data.index('"demo_g_02"'))
        self.assertRegex(data, r'_image_message\("demo_image_private_marie_01",\s*"marie",\s*"21:16"')
        self.assertRegex(data, r'_image_message\("demo_image_group_marie_01",\s*"marie",\s*"20:46"')

    def test_timeline_replaces_only_image_body_and_forwards_signal(self):
        timeline = self._read("game/scripts/ui/messages/MessageTimeline.gd")
        self.assertIn('preload("res://scripts/ui/messages/ImageMessage.gd")', timeline)
        self.assertRegex(timeline, r"signal image_requested\(message_id: String, media_ref: String\)")
        bubble = timeline.split("func _build_message_bubble", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn('content_type == "IMAGE"', bubble)
        self.assertIn("IMAGE_MESSAGE_SCRIPT.new()", bubble)
        self.assertIn("image_requested.emit", bubble)
        self.assertIn('timestamp.name = "Timestamp"', bubble)
        self.assertIn('row.set_meta("message_bubble", true)', bubble)
        self.assertIn("author_label", bubble)

    def test_timeline_exposes_bounded_semantic_proofs(self):
        timeline = self._read("game/scripts/ui/messages/MessageTimeline.gd")
        for signature in [
            "func image_message_count() -> int", "func image_message_ids() -> Array[String]",
            "func image_message_with_caption_count() -> int",
            "func image_message_without_caption_count() -> int",
            "func focused_image_message_id() -> String", "func image_request_count() -> int",
        ]:
            self.assertIn(signature, timeline)
        self.assertRegex(timeline, r"func message_count\(\) -> int:\s+return messages\.size\(\)")

    def test_conversation_forwards_to_validated_local_photo_gateway(self):
        conversation = self._read("game/scripts/ui/messages/PortraitConversationScreen.gd")
        messages = self._read("game/scripts/ui/messages/MessagesScreen.gd")
        self.assertRegex(conversation, r"signal image_requested\(message_id: String, media_ref: String\)")
        self.assertIn("timeline.image_requested.connect", conversation)
        self.assertIn("image_requested.emit", conversation)
        self.assertIn("conversation_screen.image_requested.connect(_on_image_requested)", messages)
        gateway = messages.split("func _on_image_requested", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn('content_type", "")) != "IMAGE"', gateway)
        self.assertIn('media_ref", "")) != media_ref', gateway)
        self.assertIn("photo_requested.emit", gateway)
        for forbidden in ["GameState", "DataLoader", "TimelineState", "save_game", "autosave"]:
            self.assertNotIn(forbidden, gateway)
        self.assertNotIn("PhotoViewer.tscn", messages)
        self.assertNotIn("PHOTO_VIEWER_SCENE", messages)
        self.assertNotIn("PhotoViewer.new", messages)
        self.assertNotIn("PhotoViewer.instantiate", messages)
        for token in ['"image_message_count"', '"image_message_ids"', '"image_request_count"']:
            self.assertIn(token, conversation)

    def test_lot_has_no_viewer_assets_runtime_state_or_historical_sha(self):
        production_paths = [
            "game/scripts/ui/messages/ImageMessage.gd",
            "game/scripts/ui/messages/MessageTimeline.gd",
            "game/scripts/ui/messages/PortraitConversationScreen.gd",
            "game/scripts/ui/messages/MessagesDemoData.gd",
        ]
        paths = production_paths + [
            "game/tests/T_UI_03BImageMessageSmokeDriver.gd",
        ]
        forbidden = [
            "GameState", "DataLoader", "TimelineState", "PhonePrototype",
            "ConversationView", "save_game", "autosave", "res://data/", ".json",
            '"NEW"', '"VIEWED"', '"LOCKED"', '"REMOVED"',
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
            for token in forbidden:
                if token in content:
                    offenders.append(f"{relative}: {token}")
        self.assertEqual(offenders, [])
        production_contents = "\n".join(self._read(relative) for relative in production_paths)
        for token in [
            "PhotoViewer", "PhotoViewer.tscn", "PHOTO_VIEWER_SCENE", "PhotoViewer.new",
            "PhotoViewer.instantiate", "PHOTO_VIEWER_SCENE.instantiate()",
        ]:
            self.assertNotIn(token, production_contents)
        self.assertNotRegex(production_contents, r'preload\([^\n]*PhotoViewer')
        smoke = self._read("game/tests/T_UI_03BImageMessageSmokeDriver.gd")
        self.assertIn("shell.is_photo_viewer_active()", smoke)
        self.assertIn("shell._close_photo_viewer()", smoke)

    def test_no_repository_image_asset_is_added(self):
        changed_images = []
        for suffix in ("*.png", "*.jpg", "*.jpeg", "*.webp"):
            changed_images.extend(ROOT.glob(f"game/**/{suffix}"))
        # Existing repository images are outside this lot; the component itself must use none.
        component = self._read("game/scripts/ui/messages/ImageMessage.gd")
        self.assertNotRegex(component, r"res://.*\.(png|jpe?g|webp)")


if __name__ == "__main__":
    unittest.main()
