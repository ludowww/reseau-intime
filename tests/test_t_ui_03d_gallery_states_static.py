import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class TUI03DGalleryStatesStaticTests(unittest.TestCase):
    PRODUCTION = [
        "game/scripts/ui/PortraitShell.gd",
        "game/scripts/ui/gallery/GalleryDemoData.gd",
        "game/scripts/ui/gallery/GalleryScreen.gd",
        "game/scripts/ui/gallery/GalleryTile.gd",
        "game/scripts/ui/gallery/PhotoViewer.gd",
        "game/scripts/ui/messages/MessagesScreen.gd",
    ]
    REQUIRED = PRODUCTION + [
        "game/tests/T_UI_03DGalleryStatesSmokeDriver.gd",
        "game/tests/T_UI_03DGalleryStatesSmokeTest.tscn",
        "tests/test_t_ui_03d_gallery_states_static.py",
        "tools/test_t_ui_03d_gallery_states.sh",
    ]

    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def method(self, relative: str, name: str) -> str:
        source = self.read(relative)
        marker = f"func {name}"
        self.assertIn(marker, source, relative)
        return marker + source.split(marker, 1)[1].split("\nfunc ", 1)[0]

    def test_01_required_files_exist(self):
        self.assertEqual([p for p in self.REQUIRED if not (ROOT / p).exists()], [])

    def test_02_model_and_exact_fixture_distribution(self):
        data = self.read("game/scripts/ui/gallery/GalleryDemoData.gd")
        for token in ['"state"', '"is_new"', '"UNLOCKED"', '"LOCKED"']:
            self.assertIn(token, data)
        self.assertNotRegex(data, r'"state"\s*:\s*"VIEWED"')
        self.assertEqual(data.count('_item("marie_'), 7)
        self.assertEqual(data.count('_item("sandra_'), 4)
        self.assertEqual(data.count('_item("mathilde_'), 3)
        self.assertEqual(data.count('_item("raphaelle_'), 2)
        self.assertRegex(data, r'(?s)"pauline"\s*:\s*\{.*?"items"\s*:\s*\[\]')
        for expected in [
            '_item("marie_02", "marie", "Photo démo 02", 2, "UNLOCKED", true)',
            '_item("marie_03", "marie", "", 3, "LOCKED")',
            '_item("marie_06", "marie", "Photo démo 06", 6, "UNLOCKED", true)',
            '_item("sandra_02", "sandra", "Photo démo 02", 2, "UNLOCKED", true)',
            '_item("sandra_04", "sandra", "", 4, "LOCKED")',
            '_item("mathilde_01", "mathilde", "Photo démo 01", 1, "UNLOCKED", true)',
            '_item("mathilde_03", "mathilde", "", 3, "LOCKED")',
            '_item("raphaelle_02", "raphaelle", "", 2, "LOCKED")',
        ]:
            self.assertIn(expected, data)

    def test_03_locked_factory_forces_false_and_erases_refs(self):
        helper = self.method("game/scripts/ui/gallery/GalleryDemoData.gd", "_item")
        self.assertIn('state == "LOCKED"', helper)
        self.assertRegex(helper, r'"thumbnail_label"\s*:\s*""\s+if locked')
        self.assertRegex(helper, r'"full_ref"\s*:\s*""\s+if locked')
        self.assertRegex(helper, r'"is_new"\s*:\s*false\s+if locked')

    def test_04_display_state_is_derived_not_stored(self):
        method = self.method("game/scripts/ui/gallery/GalleryScreen.gd", "display_state_for_item")
        for token in ['"LOCKED"', '"UNLOCKED"', '"NEW"', '"VIEWED"', '"is_new"']:
            self.assertIn(token, method)
        self.assertLess(method.index('"LOCKED"'), method.index('"NEW"'))

    def test_05_tile_renders_new_viewed_and_neutral_locked(self):
        tile = self.read("game/scripts/ui/gallery/GalleryTile.gd")
        for signature in [
            "func display_state()", "func is_locked()", "func is_new()",
            "func mark_viewed()", "func new_badge_visible()",
            "func locked_copy_visible()", "func displayed_primary_text()",
        ]:
            self.assertIn(signature, tile)
        for token in ['"Nouveau"', '"🔒\\nPhoto verrouillée"', "Control.FOCUS_NONE", "Control.MOUSE_FILTER_IGNORE"]:
            self.assertIn(token, tile)
        self.assertIn("Control.FOCUS_ALL", tile)
        self.assertNotIn("disabled = true", tile)
        self.assertIn("CURSOR_ARROW", tile)
        self.assertIn('tooltip_text = ""', tile)
        for forbidden in ["Tween", "create_tween", "AnimationPlayer", "Timer", '"Vue"', '"Déjà vue"']:
            self.assertNotIn(forbidden, tile)

    def test_06_locked_activation_is_blocked_before_emission(self):
        activation = self.method("game/scripts/ui/gallery/GalleryTile.gd", "_emit_photo_requested")
        self.assertIn("is_locked()", activation)
        self.assertIn("return", activation)
        self.assertLess(activation.index("is_locked()"), activation.index("photo_requested.emit"))
        request = self.method("game/scripts/ui/gallery/GalleryScreen.gd", "_on_photo_requested")
        self.assertIn('"UNLOCKED"', request)
        self.assertLess(request.index('"UNLOCKED"'), request.index("photo_request_count += 1"))
        self.assertLess(request.index("photo_request_count += 1"), request.index("photo_requested.emit"))

    def test_07_mark_viewed_is_bounded_without_rebuild_scroll_or_focus(self):
        method = self.method("game/scripts/ui/gallery/GalleryScreen.gd", "mark_viewed")
        for token in ['-> bool', '"UNLOCKED"', '"is_new"', 'item["is_new"] = false', "tile.mark_viewed()"]:
            self.assertIn(token, method)
        for forbidden in ["_rebuild_content", "select_character", "grid_scroll.scroll_vertical =", "grab_focus", "ensure_control_visible"]:
            self.assertNotIn(forbidden, method)

    def test_08_counts_and_render_proofs_extend_describe_state(self):
        screen = self.read("game/scripts/ui/gallery/GalleryScreen.gd")
        for signature in [
            "func unlocked_item_count(", "func new_item_count(", "func locked_item_count(",
        ]:
            self.assertIn(signature, screen)
        describe = self.method("game/scripts/ui/gallery/GalleryScreen.gd", "describe_state")
        for token in [
            '"unlocked_item_count"', '"new_item_count"', '"locked_item_count"',
            '"focused_tile_state"', '"visible_new_badge_count"', '"visible_locked_tile_count"',
        ]:
            self.assertIn(token, describe)

    def test_09_gallery_sequence_filters_locked_and_rejects_index_origin(self):
        sequence = self.method("game/scripts/ui/gallery/GalleryScreen.gd", "viewer_sequence_for_selected_character")
        for token in ['"UNLOCKED"', "continue", "sort_key", '"access_state": "UNLOCKED"']:
            self.assertIn(token, sequence)
        index = self.method("game/scripts/ui/gallery/GalleryScreen.gd", "viewer_index_for_item")
        origin = self.method("game/scripts/ui/gallery/GalleryScreen.gd", "viewer_origin_for_item")
        self.assertIn("return -1", index)
        self.assertIn("viewer_index_for_item", origin)
        self.assertIn("return {}", origin)

    def test_10_shell_marks_only_after_success_and_navigation_is_gallery_only(self):
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        gateway = self.method("game/scripts/ui/PortraitShell.gd", "_on_gallery_photo_requested")
        opener = self.method("game/scripts/ui/PortraitShell.gd", "_open_photo_viewer")
        callback = self.method("game/scripts/ui/PortraitShell.gd", "_on_photo_viewer_current_photo_changed")
        self.assertIn("if _open_photo_viewer", gateway)
        self.assertLess(gateway.index("_open_photo_viewer"), gateway.index("mark_viewed"))
        self.assertIn("-> bool", opener)
        self.assertIn("return false", opener)
        self.assertLess(opener.index("photo_viewer.visible = true"), opener.rindex("return true"))
        self.assertEqual(shell.count("current_photo_changed.connect(_on_photo_viewer_current_photo_changed)"), 1)
        self.assertIn("is_photo_viewer_active()", callback)
        self.assertIn("TAG_GALLERY", callback)
        self.assertIn("gallery_screen.mark_viewed(photo_id)", callback)

    def test_11_viewer_requires_unlocked_and_only_displays_accessible(self):
        viewer = self.read("game/scripts/ui/gallery/PhotoViewer.gd")
        configure = self.method("game/scripts/ui/gallery/PhotoViewer.gd", "configure")
        self.assertIn('presentation.get("access_state", "")', configure)
        self.assertIn('"UNLOCKED"', configure)
        self.assertIn("return false", configure)
        self.assertIn('"Accessible"', viewer)
        self.assertIn("func displayed_access_state()", viewer)
        for token in ['"NEW"', '"VIEWED"', '"LOCKED"', '"Nouveau"', '"Vue"']:
            self.assertNotIn(token, viewer)

    def test_12_messages_adds_only_access_state_without_gallery_dependency(self):
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        gateway = self.method("game/scripts/ui/messages/MessagesScreen.gd", "_on_image_requested")
        self.assertIn('"access_state": "UNLOCKED"', gateway)
        self.assertEqual(gateway.count('"UNLOCKED"'), 1)
        for token in ['"NEW"', '"VIEWED"', '"LOCKED"', "GalleryDemoData", "GalleryScreen"]:
            self.assertNotIn(token, messages)

    def test_13_scope_has_no_persistence_runtime_assets_removed_or_sha(self):
        contents = "\n".join(self.read(path) for path in self.PRODUCTION)
        for token in [
            "GameState", "DataLoader", "TimelineState", "PhonePrototype", "ConversationView",
            "save_game", "autosave", "res://data/", ".json", '"REMOVED"',
        ]:
            self.assertNotIn(token, contents)
        self.assertIsNone(re.search(r"\b[0-9a-f]{40}\b", contents, re.I))
        self.assertNotRegex(contents, r"res://.*\.(png|jpe?g|webp)")

    def test_14_old_contracts_and_exact_smoke_matrix_are_preserved(self):
        a = self.read("tests/test_t_ui_03a_gallery_core_static.py")
        b = self.read("tests/test_t_ui_03b_image_message_static.py")
        c = self.read("tests/test_t_ui_03c_photo_viewer_static.py")
        for token in ["UNSEEN", "REMOVED", "premium", "save_game", "autosave", "SCENARIO_COUNT"]:
            self.assertIn(token, a)
        for token in ['"NEW"', '"VIEWED"', '"LOCKED"', '"REMOVED"']:
            self.assertIn(token, b)
        self.assertIn("SCENARIO_COUNT", self.read("tools/test_t_ui_03b_image_message.sh"))
        for token in ["REMOVED", "viewer_global_rect", "gallery changed scroll must use minimal movement", "SCENARIO_COUNT"]:
            self.assertIn(token, c)
        runner = self.read("tools/test_t_ui_03d_gallery_states.sh")
        driver = self.read("game/tests/T_UI_03DGalleryStatesSmokeDriver.gd")
        for token in ["720x1280 1080x1920 1080x2340", "none tall-portrait", "true false", "SCENARIO_COUNT"]:
            self.assertIn(token, runner)
        self.assertIn('test "${SCENARIO_COUNT}" -eq 12', runner)
        for token in ["--capture", "save_png", "marie_03", "marie_02", "marie_06", "Accessible"]:
            self.assertIn(token, driver)


if __name__ == "__main__":
    unittest.main()
