import json,unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
class T(unittest.TestCase):
 def read(self,p):return (ROOT/p).read_text(encoding="utf-8")
 def test_contract(self):
  d=json.loads(self.read("game/data/runtime/season_1/j17_runtime_map.json"));self.assertEqual("PLAYABLE",d["implementation_status"])
  s=self.read("game/scripts/runtime/season_1/Season1State.gd")
  for x in ["fact_mathilde_left_household","j17_couple_definition_record_01","fact_couple_state_defined","func begin_j17","func apply_j17_couple_choice"]:self.assertIn(x,s)
  season=self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd");self.assertIn("const SNAPSHOT_VERSION := 17",season);self.assertIn("func _handoff_to_j17",season)
if __name__=="__main__":unittest.main()
