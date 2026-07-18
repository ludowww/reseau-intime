import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
TOOLS = ROOT / "tools"


class TUI01PortraitShellStaticTests(unittest.TestCase):
    def test_new_shell_files_exist(self):
        required = [
            GAME / "scenes" / "portrait" / "PortraitShell.tscn",
            GAME / "scenes" / "portrait" / "PortraitShellDemo.tscn",
            GAME / "scripts" / "ui" / "PortraitShell.gd",
            GAME / "scripts" / "ui" / "PortraitShellDemo.gd",
            GAME / "scripts" / "ui" / "SafeAreaContainer.gd",
            GAME / "scripts" / "ui" / "PortraitShellTheme.gd",
            GAME / "tests" / "T_UI_01PortraitShellSmokeTest.tscn",
            GAME / "tests" / "T_UI_01PortraitShellSmokeDriver.gd",
            TOOLS / "test_t_ui_01_portrait_shell.sh",
        ]
        missing = [path.relative_to(ROOT).as_posix() for path in required if not path.exists()]
        self.assertEqual(missing, [])

    def test_demo_scene_points_to_demo_script(self):
        scene = (GAME / "scenes" / "portrait" / "PortraitShellDemo.tscn").read_text(encoding="utf-8")
        driver = (GAME / "scripts" / "ui" / "PortraitShellDemo.gd").read_text(encoding="utf-8")
        self.assertIn("PortraitShellDemo.gd", scene)
        self.assertIn('const SHELL_SCENE := preload("res://scenes/portrait/PortraitShell.tscn")', driver)
        self.assertIn('shell.set_safe_area_preset(safe_area)', driver)
        self.assertIn('shell.set_reduced_motion_enabled', driver)
        self.assertIn('safe_area_mode', driver)
        self.assertNotIn("DataLoader", driver)
        self.assertNotIn("GameState", driver)
        self.assertNotIn("TimelineState", driver)

    def test_shell_mentions_the_authorized_additive_surface_only(self):
        shell = (GAME / "scripts" / "ui" / "PortraitShell.gd").read_text(encoding="utf-8")
        for token in [
            "SafeAreaContainer",
            "activate_messages",
            "activate_gallery",
            "reduced_motion_enabled",
            "messages_button_pressed",
            "gallery_button_pressed",
            "messages_alpha",
            "gallery_alpha",
            "transition_running",
            "Messages",
            "Galerie",
            "PortraitShellTheme",
            "describe_layout",
            "_refresh_nav_button_styles",
            'accent_for("Marie")',
            'accent_for("Sandra")',
            'accent_for("Mathilde")',
        ]:
            self.assertIn(token, shell)
        for forbidden in [
            "DataLoader",
            "GameState",
            "TimelineState",
            "chapter_",
            "conversation_json",
            "Main.tscn",
            "PhonePrototype",
        ]:
            self.assertNotIn(forbidden, shell)

    def test_safe_area_helper_handles_presets(self):
        helper = (GAME / "scripts" / "ui" / "SafeAreaContainer.gd").read_text(encoding="utf-8")
        for token in [
            'set_test_safe_area_preset(preset: String)',
            'safe_area_mode',
            '"none"',
            '"top-notch"',
            '"bottom-reserved"',
            '"tall-portrait"',
            'refresh_safe_area()',
            'NOTIFICATION_RESIZED',
            '_preset_safe_area_for(viewport_size: Vector2i, preset: String)',
            '_platform_safe_area(viewport_size: Vector2i)',
        ]:
            self.assertIn(token, helper)
        self.assertNotIn('screen_get_usable_rect', helper)

    def test_theme_defines_the_canonical_identity_accents(self):
        helper = (GAME / "scripts" / "ui" / "PortraitShellTheme.gd").read_text(encoding="utf-8")
        for token in [
            'MARIE_ACCENT',
            'SANDRA_ACCENT',
            'MATHILDE_ACCENT',
            'PAULINE_ACCENT',
            'RAPHAELLE_ACCENT',
            'NICO_ACCENT',
            'GROUP_ACCENT',
            'PLAYER_ACCENT',
            'IDENTITY_ACCENTS',
            'func accent_for(identity: String) -> Color:',
        ]:
            self.assertIn(token, helper)

    def test_smoke_script_covers_required_resolutions_and_presets(self):
        shell = (TOOLS / "test_t_ui_01_portrait_shell.sh").read_text(encoding="utf-8")
        for token in [
            '720x1280',
            '1080x1920',
            '1080x2340',
            '1280x720',
            'for safe_area in none top-notch bottom-reserved tall-portrait; do',
            '"--safe-area=${safe_area}"',
            '"--demo-size=${resolution}"',
            'res://tests/T_UI_01PortraitShellSmokeTest.tscn',
        ]:
            self.assertIn(token, shell)


if __name__ == "__main__":
    unittest.main()
