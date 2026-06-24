import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class GodotPrototypeStaticTests(unittest.TestCase):
    def test_minimal_godot_project_files_exist(self):
        required = [
            GAME / "project.godot",
            GAME / "scenes" / "Main.tscn",
            GAME / "scenes" / "smartphone" / "PhonePrototype.tscn",
            GAME / "scenes" / "smartphone" / "ConversationView.tscn",
            GAME / "scenes" / "smartphone" / "DebugPanel.tscn",
            GAME / "scripts" / "core" / "GameState.gd",
            GAME / "scripts" / "core" / "DataLoader.gd",
            GAME / "scripts" / "core" / "EffectApplier.gd",
            GAME / "scripts" / "core" / "DebugRouteProbe.gd",
            GAME / "scripts" / "ui" / "PhonePrototype.gd",
            GAME / "scripts" / "ui" / "ConversationView.gd",
            GAME / "scripts" / "ui" / "DebugPanel.gd",
            GAME / "assets" / "placeholders" / ".gitkeep",
        ]
        missing = [path.relative_to(ROOT).as_posix() for path in required if not path.exists()]
        self.assertEqual(missing, [])

    def test_project_boots_on_main_scene_and_registers_autoloads(self):
        project = (GAME / "project.godot").read_text(encoding="utf-8")
        self.assertIn('run/main_scene="res://scenes/Main.tscn"', project)
        self.assertIn('GameState="*res://scripts/core/GameState.gd"', project)
        self.assertIn('DataLoader="*res://scripts/core/DataLoader.gd"', project)
        self.assertIn('EffectApplier="*res://scripts/core/EffectApplier.gd"', project)
        self.assertIn('DebugRouteProbe="*res://scripts/core/DebugRouteProbe.gd"', project)

    def test_loader_references_required_vertical_slice_json(self):
        loader = (GAME / "scripts" / "core" / "DataLoader.gd").read_text(encoding="utf-8")
        for required in [
            "res://data/state/initial_state.json",
            "res://data/conversations/chapter_01_index.json",
            "res://data/conversations/chapter_02_index.json",
            "res://data/conversations/chapter_03_index.json",
            "res://data/conversations/chapter_04_index.json",
            "res://data/visual_content/placeholders.json",
            "res://data/visual_content/chapter_04_proofs.json",
        ]:
            self.assertIn(required, loader)

    def test_effect_applier_supports_dotted_global_passive_flags_and_unknowns(self):
        script = (GAME / "scripts" / "core" / "EffectApplier.gd").read_text(encoding="utf-8")
        for expected in [
            "apply_choice",
            "apply_effects",
            "apply_flags",
            "characters",
            "passive_signals",
            "global",
            "unknown_effects",
            "sets_flags",
        ]:
            self.assertIn(expected, script)


if __name__ == "__main__":
    unittest.main()
