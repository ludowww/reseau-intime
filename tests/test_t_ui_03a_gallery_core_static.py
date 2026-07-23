import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class TUI03AGalleryCoreStaticTests(unittest.TestCase):
    COMPONENTS = [
        "game/scripts/ui/gallery/GalleryScreen.gd",
        "game/scripts/ui/gallery/GalleryDemoData.gd",
        "game/scripts/ui/gallery/CharacterTabs.gd",
        "game/scripts/ui/gallery/GalleryTile.gd",
        "game/scenes/portrait/gallery/GalleryScreen.tscn",
        "game/tests/T_UI_03AGalleryCoreSmokeDriver.gd",
        "game/tests/T_UI_03AGalleryCoreSmokeTest.tscn",
        "tools/test_t_ui_03a_gallery_core.sh",
    ]

    def _read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_gallery_components_exist(self):
        missing = [path for path in self.COMPONENTS if not (ROOT / path).exists()]
        self.assertEqual(missing, [])

    def test_portrait_shell_instances_dedicated_gallery_scene(self):
        shell = self._read("game/scripts/ui/PortraitShell.gd")
        self.assertIn('preload("res://scenes/portrait/gallery/GalleryScreen.tscn")', shell)
        self.assertIn("GALLERY_SCREEN_SCENE.instantiate()", shell)
        self.assertIn("gallery_screen", shell)
        self.assertIn(".gui_input.connect(_on_bottom_nav_gui_input", shell)
        self.assertIn("func _on_bottom_nav_gui_input", shell)
        self.assertNotIn("for i in range(6)", shell)
        self.assertNotIn("Maquette factice", shell)

    def test_demo_fixtures_are_local_non_canonical_and_exact(self):
        data = self._read("game/scripts/ui/gallery/GalleryDemoData.gd")
        for token in [
            "Données locales de démonstration non canoniques",
            '"character_id"', '"display_name"', '"accent_color"', '"avatar_ref"',
            '"items"', '"item_id"', '"thumbnail_label"', '"sort_key"',
            '"marie"', '"sandra"', '"mathilde"', '"pauline"', '"raphaelle"',
        ]:
            self.assertIn(token, data)
        self.assertNotIn('"nico"', data.lower())
        self.assertRegex(data, r'(?s)"pauline"\s*:\s*\{.*?"items"\s*:\s*\[\]')
        self.assertEqual(data.count('_item("marie_'), 7)
        self.assertEqual(data.count('_item("sandra_'), 4)
        self.assertEqual(data.count('_item("mathilde_'), 3)
        self.assertEqual(data.count('_item("raphaelle_'), 2)

    def test_tabs_and_tiles_are_focusable_accessible_and_visibly_identified(self):
        tabs = self._read("game/scripts/ui/gallery/CharacterTabs.gd")
        tile = self._read("game/scripts/ui/gallery/GalleryTile.gd")
        for content in [tabs, tile]:
            self.assertIn("Control.FOCUS_ALL", content)
            self.assertIn("focus_style()", content)
            self.assertIn("custom_minimum_size", content)
        self.assertIn("Vector2(0, 48)", tabs)
        self.assertIn("display_name", tabs)
        self.assertIn("avatar_ref", tabs)
        self.assertIn("photo_requested", tile)
        self.assertIn("KEY_LEFT", tile)
        self.assertIn("KEY_RIGHT", tile)
        self.assertIn("KEY_UP", tile)
        self.assertIn("KEY_DOWN", tile)

    def test_gallery_has_scrollable_tabs_grid_empty_state_and_responsive_columns(self):
        screen = self._read("game/scripts/ui/gallery/GalleryScreen.gd")
        for token in [
            "ScrollContainer.SCROLL_MODE_AUTO",
            "ScrollContainer.SCROLL_MODE_DISABLED",
            "GridContainer",
            "Aucune photo disponible",
            "empty_state_visible",
            "grid_visible",
            "NARROW_WIDTH_THRESHOLD",
            "return 2",
            "return 3",
            "TILE_ASPECT_RATIO",
            "describe_state()",
            "has_horizontal_crop",
        ]:
            self.assertIn(token, screen)

    def test_gallery_components_have_no_animation_runtime_or_future_photo_states(self):
        contents = "\n".join(self._read(path) for path in self.COMPONENTS if path.endswith((".gd", ".tscn")))
        forbidden = [
            "Tween", "Timer", "PhotoViewer", "ImageMessage", "GameState", "DataLoader",
            "TimelineState", "PhonePrototype", "ConversationView", "save_game", "autosave",
            "res://data/", ".json", "LOCKED", "UNSEEN", "VIEWED", "REMOVED",
            "can_share", "can_remove_local", "premium", "ad835a0",
        ]
        offenders = [token for token in forbidden if token in contents]
        self.assertEqual(offenders, [])
        self.assertNotRegex(contents, r'load\([^\n]*\+')
        self.assertNotRegex(contents, r'preload\([^\n]*\+')

    def test_visible_gallery_copy_exposes_no_progression_mechanics_or_ids(self):
        paths = [
            "game/scripts/ui/gallery/GalleryScreen.gd",
            "game/scripts/ui/gallery/CharacterTabs.gd",
            "game/scripts/ui/gallery/GalleryTile.gd",
            "game/scripts/ui/gallery/GalleryDemoData.gd",
        ]
        quoted = re.compile(r'"([^"\\]*(?:\\.[^"\\]*)*)"')
        forbidden = re.compile(r"\b(route|score|flag|tier|pourcentage|percent)\b", re.IGNORECASE)
        offenders = []
        for path in paths:
            for value in quoted.findall(self._read(path)):
                if forbidden.search(value):
                    offenders.append(f"{path}: {value}")
        self.assertEqual(offenders, [])

    def test_smoke_declares_exact_twelve_case_matrix_and_capture_support(self):
        smoke = self._read("tools/test_t_ui_03a_gallery_core.sh")
        driver = self._read("game/tests/T_UI_03AGalleryCoreSmokeDriver.gd")
        for token in ["720x1280", "1080x1920", "1080x2340", "none tall-portrait", "true false", "SCENARIO_COUNT"]:
            self.assertIn(token, smoke)
        for token in ["--capture", "save_png", "selected_character_id", "tile_count", "column_count", "photo_request_count"]:
            self.assertIn(token, driver)


if __name__ == "__main__":
    unittest.main()
