import json, unittest
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
class RuntimeS113J13PlayableStaticTests(unittest.TestCase):
    def read(self, path): return (ROOT / path).read_text(encoding="utf-8")
    def load(self, path): return json.loads(self.read(path))
    def test_map_and_exclusive_canonical_routes(self):
        data = self.load("game/data/runtime/season_1/j13_runtime_map.json"); self.assertEqual("PLAYABLE", data["implementation_status"])
        corpus = self.read("game/data/conversations/chapter_13_priority.json")
        for segment in ["j13_pauline", "j13_raphaelle", "j13_nico", "j13_sandra", "j13_mathilde", "j13_marie", "j13_respiration", "j13_marie_echo"]: self.assertIn(segment, corpus)
        for line in ["La 2 reste dans le groupe.", "Le rôle est dans l’image.", "J’ai répondu l’heure réelle.", "J’ai besoin de savoir si on l’était."]: self.assertIn(line, corpus)
    def test_state_trace_and_snapshot_contract(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd"); provider = self.read("game/scripts/runtime/season_1/J13RuntimeProvider.gd")
        for token in ["func begin_j13", "func set_j13_priority", "func apply_j13_choice", "func complete_j13", '"j13_j14_trace_id"']: self.assertIn(token, state)
        for token in ["func _select_pivot", "func snapshot()", "func restore_snapshot", "incoming_batch_fully_presented"]: self.assertIn(token, provider)
    def test_handoff_and_placeholders(self):
        j12 = self.load("game/data/runtime/season_1/j12_runtime_map.json"); self.assertEqual("day_handoff", j12["day_end"]["transition_mode"]); self.assertFalse(j12["day_end"]["content_end"])
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd"); self.assertIn("const SNAPSHOT_VERSION := 16", season); self.assertIn("func _handoff_to_j13", season)
        corpus = self.read("game/data/conversations/chapter_13_priority.json"); self.assertIn("S1_A4_J13_DPH_PAULINE_PRIVATE_VERSION_01", corpus); self.assertIn("S1_A4_J13_DPH_RAPHAELLE_MASKED_POSTURE_01", corpus)
if __name__ == "__main__": unittest.main()
