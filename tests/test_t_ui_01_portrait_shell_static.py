import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
TOOLS = ROOT / "tools"


class TUI01PortraitShellStaticTests(unittest.TestCase):
    def test_new_shell_files_exist(self):
        required = [
            GAME / "scenes" / "portrait" / "PortraitMain.tscn",
            GAME / "scenes" / "portrait" / "PortraitShell.tscn",
            GAME / "scenes" / "portrait" / "PortraitShellDemo.tscn",
            GAME / "scenes" / "legacy" / "LegacyMain.tscn",
            GAME / "scripts" / "ui" / "PortraitShell.gd",
            GAME / "scripts" / "ui" / "PortraitShellDemo.gd",
            GAME / "scripts" / "ui" / "PortraitMain.gd",
            GAME / "scripts" / "ui" / "LegacyMain.gd",
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

    def test_portrait_main_scene_instances_the_shell(self):
        scene = (GAME / "scenes" / "portrait" / "PortraitMain.tscn").read_text(encoding="utf-8")
        self.assertIn('res://scenes/portrait/PortraitShell.tscn', scene)
        self.assertIn('PortraitShell', scene)
        self.assertNotIn('PortraitShellDemo', scene)

    def test_legacy_main_scene_is_isolated_and_reinstates_historic_canvas(self):
        scene = (GAME / "scenes" / "legacy" / "LegacyMain.tscn").read_text(encoding="utf-8")
        script = (GAME / "scripts" / "ui" / "LegacyMain.gd").read_text(encoding="utf-8")
        for token in [
            'res://scenes/Main.tscn',
            'LegacyMain.gd',
        ]:
            self.assertIn(token, scene)
        self.assertNotIn('PortraitShell.tscn', scene)
        for token in [
            'content_scale_size = Vector2i(1280, 720)',
            'Window.CONTENT_SCALE_MODE_DISABLED',
            'Window.CONTENT_SCALE_ASPECT_KEEP',
            'root.get_visible_rect()',
            '--t-ui-01b-legacy-smoke',
            'find_child("PortraitShell", true, false)',
        ]:
            self.assertIn(token, script)
        self.assertNotIn('SHELL_SCENE', (GAME / "scripts" / "ui" / "PortraitMain.gd").read_text(encoding="utf-8"))

    def test_project_defaults_to_portrait_shell_and_portrait_stretch(self):
        project = (GAME / "project.godot").read_text(encoding="utf-8")
        for token in [
            'run/main_scene="res://scenes/portrait/PortraitMain.tscn"',
            'window/size/viewport_width=720',
            'window/size/viewport_height=1280',
            'window/stretch/mode="canvas_items"',
            'window/stretch/aspect="keep_width"',
        ]:
            self.assertIn(token, project)

    def test_legacy_main_scene_still_exists_and_stays_horizontal(self):
        main_scene = (GAME / "scenes" / "Main.tscn").read_text(encoding="utf-8")
        self.assertIn('PhonePrototype.tscn', main_scene)
        self.assertNotIn('PortraitShell.tscn', main_scene)

    def test_smoke_script_covers_required_resolutions_default_launch_and_legacy_launch(self):
        shell = (TOOLS / "test_t_ui_01_portrait_shell.sh").read_text(encoding="utf-8")
        for token in [
            '720x1280',
            '1080x1920',
            '1080x2340',
            'for safe_area in none top-notch bottom-reserved tall-portrait; do',
            '"--safe-area=${safe_area}"',
            '"--demo-size=${resolution}"',
            'res://tests/T_UI_01PortraitShellSmokeTest.tscn',
            'godot --headless --path game --quit',
            'res://scenes/legacy/LegacyMain.tscn',
            '--t-ui-01b-legacy-smoke',
        ]:
            self.assertIn(token, shell)


if __name__ == "__main__":
    unittest.main()
