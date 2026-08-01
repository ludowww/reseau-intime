import json,unittest
from pathlib import Path
R=Path(__file__).resolve().parents[1]
class T(unittest.TestCase):
 def test_contract(self):
  runtime=json.loads((R/"game/data/runtime/season_1/j18_runtime_map.json").read_text(encoding="utf-8"));self.assertEqual("PLAYABLE",runtime["implementation_status"]);self.assertEqual("Ven.",runtime["narrative_day_short"])
  s=(R/"game/scripts/runtime/season_1/Season1State.gd").read_text(encoding="utf-8");p=(R/"game/scripts/runtime/season_1/J18RuntimeProvider.gd").read_text(encoding="utf-8");season=(R/"game/scripts/runtime/season_1/Season1RuntimeProvider.gd").read_text(encoding="utf-8")
  self.assertIn("j18_sandra_lunch_print_01",s);self.assertIn("func apply_j18_choice",s);self.assertIn("func _j18_records_consistent",s);self.assertIn("func restore_snapshot",p);self.assertIn("const SNAPSHOT_VERSION := 19",season);self.assertIn('"J18": j18_provider.snapshot()',season)
if __name__=="__main__":unittest.main()
