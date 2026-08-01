import json, unittest
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
class RuntimeS116J16PlayableStaticTests(unittest.TestCase):
    def read(self, path): return (ROOT / path).read_text(encoding="utf-8")
    def load(self, path): return json.loads(self.read(path))
    def test_contract(self):
        data=self.load("game/data/runtime/season_1/j16_runtime_map.json"); self.assertEqual("PLAYABLE", data["implementation_status"])
        corpus=self.read("game/data/conversations/chapter_16_priority_payment.json")
        for token in ["j16_priority_marie","j16_priority_mathilde","j16_fallback","j16_departure_ordinary","j16_departure_distance","j16_j17_proposal"]: self.assertIn(token, corpus)
    def test_state_and_handoff(self):
        state=self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in ["func begin_j16","func select_j16_priority","func apply_j16_consequence_choice","func establish_j16_departure","func apply_j16_j17_choice","j16_consequence_payment_record_01","marie_j16_couple_conversation_j17"]: self.assertIn(token,state)
        season=self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd"); self.assertIn("const SNAPSHOT_VERSION := 20",season); self.assertIn("func _handoff_to_j16",season)
        j15=self.load("game/data/runtime/season_1/j15_runtime_map.json"); self.assertEqual("day_handoff",j15["day_end"]["transition_mode"]); self.assertFalse(j15["day_end"]["content_end"])
if __name__ == "__main__": unittest.main()
