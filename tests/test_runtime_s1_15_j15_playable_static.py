import json, unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class RuntimeS115J15PlayableStaticTests(unittest.TestCase):
    def read(self, path): return (ROOT / path).read_text(encoding="utf-8")
    def load(self, path): return json.loads(self.read(path))

    def test_map_and_no_collision_mutation(self):
        data = self.load("game/data/runtime/season_1/j15_runtime_map.json")
        self.assertEqual("PLAYABLE", data["implementation_status"])
        corpus = self.read("game/data/conversations/chapter_15_obligation_mutation.json")
        for segment in ["j15_due_marie", "j15_repair_marie", "j15_open_marie", "j15_clean_marie", "j15_due_mathilde", "j15_repair_mathilde", "j15_open_mathilde", "j15_clean_mathilde"]:
            self.assertIn(segment, corpus)
        self.assertNotIn("media_ref", corpus)

    def test_state_enforces_amended_canonical_contract(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in ["func begin_j15", "func select_j15_mode", "func establish_j15_mode", "func apply_j15_choice", "func complete_j15", "j15_obligation_collision_record_01", "j16_priority_consequence_payment"]:
            self.assertIn(token, state)
        self.assertIn('"collision_mode":"NO_COLLISION"', state)
        self.assertIn('"incompatible_windows_proven":false', state)
        self.assertIn('"second_signed_obligation_present":false', state)

    def test_handoff_snapshot_and_no_retroactive_promise(self):
        j14 = self.load("game/data/runtime/season_1/j14_runtime_map.json")
        self.assertEqual("day_handoff", j14["day_end"]["transition_mode"])
        self.assertFalse(j14["day_end"]["content_end"])
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        self.assertIn("const SNAPSHOT_VERSION := 17", season)
        self.assertIn("func _handoff_to_j15", season)
        provider = self.read("game/scripts/runtime/season_1/J15RuntimeProvider.gd")
        self.assertIn("func restore_snapshot", provider)
        for forbidden in ["marie_j14_pauline_player_account_j15", "pauline_j14_post_breach_return_j15", "household_j14_sandra_rule_j15", "sandra_j14_breach_account_j15", "mathilde_j14_household_safety_rule_j15", "marie_j14_raphaelle_position_j15", "marie_j14_nico_hour_account_j15"]:
            self.assertNotIn(forbidden, state)


if __name__ == "__main__": unittest.main()
