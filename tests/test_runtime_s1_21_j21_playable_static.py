import json, unittest
from pathlib import Path

R = Path(__file__).resolve().parents[1]

class TestJ21Playable(unittest.TestCase):
    def test_canonical_finale_contract(self):
        runtime = json.loads((R / "game/data/runtime/season_1/j21_runtime_map.json").read_text(encoding="utf-8"))
        conversation = json.loads((R / "game/data/conversations/chapter_21_final_trace.json").read_text(encoding="utf-8"))
        state = (R / "game/scripts/runtime/season_1/Season1State.gd").read_text(encoding="utf-8")
        provider = (R / "game/scripts/runtime/season_1/J21RuntimeProvider.gd").read_text(encoding="utf-8")
        season = (R / "game/scripts/runtime/season_1/Season1RuntimeProvider.gd").read_text(encoding="utf-8")
        self.assertEqual("PLAYABLE", runtime["implementation_status"])
        self.assertTrue(runtime["day_end"]["content_end"])
        self.assertEqual([], runtime["gallery_presentations"])
        self.assertIn("func begin_j21", state)
        self.assertIn("func apply_j21_final_posture", state)
        self.assertIn('if existing_contradiction_id!="":final_posture_options.append', state)
        self.assertIn("fact_final_posture", state)
        self.assertIn("func restore_snapshot", provider)
        self.assertIn("const SNAPSHOT_VERSION := 21", season)
        self.assertIn('"J21": j21_provider.snapshot()', season)
        choice_ids = {choice["id"] for segment in conversation["segments"] for choice in segment.get("choices", [])}
        self.assertTrue({"choice_j21_rule", "choice_j21_loss", "choice_j21_contradiction"}.issubset(choice_ids))

if __name__ == "__main__": unittest.main()
