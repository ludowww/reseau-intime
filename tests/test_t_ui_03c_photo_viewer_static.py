import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class TUI03CPhotoViewerStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_required_component_scene_smoke_and_runner_exist(self):
        required = [
            "game/scripts/ui/gallery/PhotoViewer.gd",
            "game/scenes/portrait/gallery/PhotoViewer.tscn",
            "game/tests/T_UI_03CPhotoViewerSmokeDriver.gd",
            "game/tests/T_UI_03CPhotoViewerSmokeTest.tscn",
            "tools/test_t_ui_03c_photo_viewer.sh",
        ]
        self.assertEqual([p for p in required if not (ROOT / p).exists()], [])

    def test_shell_owns_one_safe_area_viewer_and_hides_whole_column(self):
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        self.assertEqual(shell.count('preload("res://scenes/portrait/gallery/PhotoViewer.tscn")'), 1)
        self.assertEqual(shell.count("PHOTO_VIEWER_SCENE.instantiate()"), 1)
        non_owners = [
            "game/scripts/ui/gallery/GalleryScreen.gd",
            "game/scripts/ui/messages/MessagesScreen.gd",
            "game/scripts/ui/messages/ImageMessage.gd",
            "game/scripts/ui/messages/MessageTimeline.gd",
            "game/scripts/ui/messages/PortraitConversationScreen.gd",
        ]
        forbidden_owner_tokens = [
            "PhotoViewer", "PhotoViewer.tscn", "PHOTO_VIEWER_SCENE", "PhotoViewer.new",
            "PHOTO_VIEWER_SCENE.instantiate()",
        ]
        for relative in non_owners:
            content = self.read(relative)
            for token in forbidden_owner_tokens:
                self.assertNotIn(token, content, relative)
            self.assertNotRegex(content, r'preload\([^\n]*PhotoViewer', relative)
        build = shell.split("func _build_shell", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("safe_area_container.add_child(shell_column)", build)
        self.assertIn("safe_area_container.add_child(photo_viewer)", build)
        self.assertIn("shell_column.add_child(header_panel)", build)
        self.assertIn("shell_column.add_child(bottom_navigation)", build)
        opened = shell.split("func _open_photo_viewer", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("shell_column.visible = false", opened)
        self.assertIn("photo_viewer.visible = true", opened)
        self.assertNotRegex(shell, r'active_tab\s*=\s*["\']photo')

    def test_viewer_contract_navigation_ratio_focus_and_cancel(self):
        viewer = self.read("game/scripts/ui/gallery/PhotoViewer.gd")
        for token in [
            "signal close_requested", "signal current_photo_changed", "func configure(",
            "sequence.is_empty()", "start_index < 0", 'expected_source != "messages" and expected_source != "gallery"',
            'expected_source == "gallery"', 'presentation.get("character_id", "")',
            "IMAGE_RATIO := 0.75", "Control.FOCUS_NONE", "Control.FOCUS_ALL",
            'add_theme_stylebox_override("focus"', 'event.is_action_pressed("ui_cancel")',
            "show_previous()", "show_next()", "current_index - 1", "current_index + 1",
            "previous_button.disabled = current_index <= 0", "next_button.disabled = current_index >= presentations.size() - 1",
            "custom_minimum_size = Vector2(0, 52)", "back_button.grab_focus()",
        ]:
            self.assertIn(token, viewer)
        self.assertNotIn("posmod", viewer)
        self.assertNotIn("TextureRect", viewer)
        self.assertNotRegex(viewer, r"res://.*\.(png|jpe?g|webp)")
        navigation = viewer.split("func handle_navigation_event", 1)[1].split("\nfunc ", 1)[0]
        self.assertLess(
            navigation.index('event.is_action_pressed("ui_cancel")'),
            navigation.index("event is InputEventKey"),
        )
        self.assertNotIn("KEY_ESCAPE", navigation)
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        shell_input = shell.split("func _unhandled_input", 1)[1].split("\nfunc ", 1)[0]
        active_guard = shell_input.split("if is_photo_viewer_active():", 1)[1].split("\n\tif ", 1)[0]
        self.assertRegex(active_guard, r"^\s*return\s*$")
        self.assertNotIn("handle_navigation_event", shell_input)

    def test_local_message_gateway_is_validated_and_restored(self):
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        self.assertIn("signal photo_requested(presentation: Dictionary, provenance: Dictionary)", messages)
        self.assertIn("conversation_screen.image_requested.connect(_on_image_requested)", messages)
        gateway = messages.split("func _on_image_requested", 1)[1].split("\nfunc ", 1)[0]
        for token in [
            'screen_mode != "conversation"', "is_off_phone_transition_active()", "is_day_transition_active()",
            "_thread_for(active_thread_id).is_empty()",
            'content_type", "")) != "IMAGE"', 'media_ref", "")) != media_ref', 'is_player", false)',
            '"source_kind": "messages"', '"reading_position"', "photo_requested.emit",
        ]:
            self.assertIn(token, gateway)
        restore = messages.split("func restore_after_photo_viewer", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("set_reading_position", restore)
        self.assertIn("reading_positions", restore)
        self.assertIn("focus_image_message", restore)
        self.assertLess(restore.index("focus_target.grab_focus()"), restore.index("focus_image_message"))
        self.assertLess(restore.index("focus_image_message"), restore.index("back_button.grab_focus()"))
        for forbidden in ["GameState", "DataLoader", "TimelineState", "save_game", "autosave"]:
            self.assertNotIn(forbidden, gateway + restore)

    def test_shell_rejects_hidden_sources_and_incoherent_provenance(self):
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        message_gateway = shell.split("func _on_message_photo_requested", 1)[1].split("\nfunc ", 1)[0]
        gallery_gateway = shell.split("func _on_gallery_photo_requested", 1)[1].split("\nfunc ", 1)[0]
        opener = shell.split("func _open_photo_viewer", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("active_tab != TAG_MESSAGES", message_gateway)
        self.assertIn('provenance.get("source_kind", "")', message_gateway)
        self.assertIn("active_tab != TAG_GALLERY", gallery_gateway)
        self.assertIn("active_tab != requested_source", opener)

    def test_gallery_sequence_is_character_local_sorted_and_restored(self):
        gallery = self.read("game/scripts/ui/gallery/GalleryScreen.gd")
        for signature in [
            "func viewer_sequence_for_selected_character()", "func viewer_index_for_item(item_id: String)",
            "func viewer_origin_for_item(item_id: String)", "func focus_item(item_id: String, ensure_visible: bool)",
            "func restore_after_photo_viewer(",
        ]:
            self.assertIn(signature, gallery)
        sequence = gallery.split("func viewer_sequence_for_selected_character", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn('fixtures.get(selected_character_id', sequence)
        self.assertIn("sort_key", sequence)
        self.assertIn('"source_kind": "gallery"', sequence)
        restore = gallery.split("func restore_after_photo_viewer", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("grid_scroll.scroll_vertical", restore)
        self.assertIn("focus_item", restore)
        data = self.read("game/scripts/ui/gallery/GalleryDemoData.gd")
        self.assertIn('"full_ref"', data)
        self.assertIn('"demo_gallery_%s"', data)

    def test_no_assets_runtime_future_states_or_historical_sha(self):
        paths = [
            "game/scripts/ui/gallery/PhotoViewer.gd", "game/scenes/portrait/gallery/PhotoViewer.tscn",
            "game/scripts/ui/PortraitShell.gd", "game/scripts/ui/messages/MessagesScreen.gd",
            "game/scripts/ui/gallery/GalleryScreen.gd", "game/scripts/ui/gallery/GalleryDemoData.gd",
        ]
        contents = "\n".join(self.read(p) for p in paths)
        for token in ["GameState", "DataLoader", "TimelineState", "PhonePrototype", "ConversationView",
                      "save_game", "autosave", "res://data/", ".json", '"NEW"', '"VIEWED"',
                      '"LOCKED"', '"REMOVED"']:
            self.assertNotIn(token, contents)
        self.assertIsNone(re.search(r"\b[0-9a-f]{40}\b", contents, re.I))
        self.assertNotRegex(contents, r"\.(png|jpe?g|webp)")

    def test_smoke_declares_exact_matrix_and_capture_support(self):
        runner = self.read("tools/test_t_ui_03c_photo_viewer.sh")
        driver = self.read("game/tests/T_UI_03CPhotoViewerSmokeDriver.gd")
        for token in ["720x1280 1080x1920 1080x2340", "none tall-portrait", "true false", "SCENARIO_COUNT"]:
            self.assertIn(token, runner)
        self.assertIn('test "${SCENARIO_COUNT}" -eq 12', runner)
        for token in ["--capture", "save_png", "messages", "gallery", "ui_cancel"]:
            self.assertIn(token, driver)
        self.assertIn("InputEventAction.new()", driver)
        self.assertIn('cancel.action = "ui_cancel"', driver)
        self.assertIn("Input.parse_input_event(cancel)", driver)
        for token in [
            "viewer_global_rect", "visual_global_rect", "visible_bounds", "actual_visual_ratio",
            "invalid viewer requests must not mutate state", "message arrows must be no-op",
            "unknown active thread must reject injected transcript",
            "hidden gallery request must be rejected", "hidden messages request must be rejected",
            "gallery unchanged scroll must restore exactly", "gallery changed scroll must use minimal movement",
        ]:
            self.assertIn(token, driver)


if __name__ == "__main__":
    unittest.main()
