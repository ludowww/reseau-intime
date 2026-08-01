import json,unittest
from pathlib import Path
R=Path(__file__).resolve().parents[1]
class T(unittest.TestCase):
 def test_contract(self):
  runtime=json.loads((R/"game/data/runtime/season_1/j19_runtime_map.json").read_text(encoding="utf-8"));self.assertEqual("PLAYABLE",runtime["implementation_status"]);self.assertEqual("Sam.",runtime["narrative_day_short"])
  state=(R/"game/scripts/runtime/season_1/Season1State.gd").read_text(encoding="utf-8");provider=(R/"game/scripts/runtime/season_1/J19RuntimeProvider.gd").read_text(encoding="utf-8");season=(R/"game/scripts/runtime/season_1/Season1RuntimeProvider.gd").read_text(encoding="utf-8")
  self.assertIn("func select_j19_pivot",state);self.assertIn("j19_raphaelle_creative_access_01",state);self.assertIn("fact_pauline_private_state_defined",state);self.assertIn("func restore_snapshot",provider);self.assertIn("const SNAPSHOT_VERSION := 20",season);self.assertIn('"J19": j19_provider.snapshot()',season)
if __name__=="__main__":unittest.main()
