import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

class RuntimeS112J12PlayableStaticTests(unittest.TestCase):
    def read(self, relative): return (ROOT / relative).read_text(encoding="utf-8")
    def load(self, relative): return json.loads(self.read(relative))

    def test_playable_map_and_canonical_data(self):
        data = self.load("game/data/runtime/season_1/j12_runtime_map.json")
        self.assertEqual("PLAYABLE", data["implementation_status"])
        self.assertEqual(3, len(data["conversation_paths"]))
        self.assertEqual([], data["gallery_presentations"])
        corpus = "\n".join(self.read(path) for path in ["game/data/conversations/chapter_12_obligations.json", "game/data/conversations/chapter_12_laverriere.json", "game/data/conversations/chapter_12_annexe.json"])
        for token in ["J’ai donc besoin de savoir quelle version de toi existe ce soir.", "La 3 attend que chacun confirme qu’il accepte son propre visage.", "Tu viens, tu viens une heure ou tu rentres ?", "La règle a tenu."]:
            self.assertIn(token, corpus)

    def test_four_functional_visuals_and_registered_trace_ids(self):
        corpus = self.read("game/data/conversations/chapter_12_laverriere.json") + self.read("game/data/conversations/chapter_12_annexe.json")
        for ref in ["J12_PLACEHOLDER_V1_MARIE_LAVERRIERE", "j12_laverriere_public_group_set_01", "J12_PLACEHOLDER_V3_PAULINE_BASTIEN", "j12_annexe_public_group_set_01"]:
            self.assertIn(ref, corpus)
        self.assertIn("aucun asset définitif", self.read("game/data/runtime/season_1/j12_runtime_map.json"))

    def test_state_and_provider_preserve_priority_and_snapshots(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        provider = self.read("game/scripts/runtime/season_1/J12RuntimeProvider.gd")
        for token in ["func begin_j12", "func apply_j12_choice", "func establish_j12_priority_consequence", "func complete_j12", '"j12_priority_route"']:
            self.assertIn(token, state)
        for token in ["RUNTIME_UNREAD.incoming_batch_fully_presented", "func snapshot()", "func restore_snapshot", "func _priority_route", '"source_day":12']:
            self.assertIn(token, provider)

    def test_r5a_exact_outcomes_morning_aftercare_and_fail_closed_migration(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        j11 = self.read("game/scripts/runtime/season_1/J11RuntimeProvider.gd")
        j12 = self.read("game/scripts/runtime/season_1/J12RuntimeProvider.gd")
        obligations = self.read("game/data/conversations/chapter_12_obligations.json")
        for outcome in [
            "MARIE_ADULT_RECONQUEST", "MARIE_NON_ADULT_RECONNECTION",
            "MARIE_SEX_NOT_USED_AS_BANDAGE", "MARIE_HONEST_REFUSAL", "MARIE_NO_RECONQUEST",
            "MATHILDE_LOOK_ONLY", "MATHILDE_M_B1", "MATHILDE_M_B2", "MATHILDE_M_B3",
            "MATHILDE_CLEAN_STOP", "MATHILDE_DISTANCE_RESTORED",
        ]:
            self.assertIn(outcome, state)
            self.assertIn(outcome, j12)
        self.assertIn("func set_j11_semantic_outcome", state)
        self.assertIn("func _migrate_r5a_j11_semantic_outcome", state)
        self.assertIn("ambiguous", self.read("game/tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd"))
        self.assertNotIn('resolve_j11_aftercare("aftercare_marie_j11"', j11.split("func confirm_scene_sequence", 1)[1].split("func ", 1)[0])
        for token in ["Café dans dix minutes.", "hier soir ne te dispense pas d’être une personne ce matin.", "j12_marie_morning_aftercare"]:
            self.assertIn(token, obligations)
        self.assertIn("state.pay_j12_marie_aftercare()", j12)
        self.assertIn('return "MATHILDE"', j12.split("func _priority_route", 1)[1])
        self.assertIn("MATHILDE_HOUSEHOLD_AFTERCARE", state)

    def test_r5a_branch_data_preserves_silence_and_distinct_consequences(self):
        laverriere = self.load("game/data/conversations/chapter_12_laverriere.json")
        annexe = self.load("game/data/conversations/chapter_12_annexe.json")
        lav_ids = {segment["id"] for segment in laverriere["segments"]}
        after_ids = {segment["id"] for segment in annexe["segments"]}
        for segment_id in [
            "j12_mathilde_look_module", "j12_mathilde_m_b1_module", "j12_mathilde_m_b2_module",
            "j12_mathilde_m_b3_module", "j12_marie_non_adult_module", "j12_marie_no_bandage_module",
        ]:
            self.assertIn(segment_id, lav_ids)
        for segment_id in [
            "j12_after_mathilde_look", "j12_after_mathilde_m_b1", "j12_after_mathilde_m_b2",
            "j12_after_mathilde_clean_stop", "j12_after_marie_non_adult",
            "j12_after_marie_no_bandage", "j12_after_marie_distance",
        ]:
            self.assertIn(segment_id, after_ids)
        provider = self.read("game/scripts/runtime/season_1/J12RuntimeProvider.gd")
        self.assertIn('"MATHILDE_DISTANCE_RESTORED":""', provider)
        self.assertIn('"MARIE_HONEST_REFUSAL":"j12_after_marie_distance"', provider)
        self.assertIn('"MARIE_NO_RECONQUEST":"j12_after_marie_distance"', provider)

    def test_handoff_moves_content_end_to_j12(self):
        j11 = self.load("game/data/runtime/season_1/j11_runtime_map.json")
        self.assertEqual("day_handoff", j11["day_end"]["transition_mode"])
        self.assertFalse(j11["day_end"]["content_end"])
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertIn("const SNAPSHOT_VERSION := 21", season)
        self.assertIn("func _handoff_to_j12", season)
        self.assertIn('active_day == "J12" and j12_provider.phase == "complete"', season)

    def test_targeted_runner_and_smoke_exist(self):
        for path in ["game/tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd", "game/tests/RUNTIME_S1_12J12PlayableSmokeTest.tscn", "tools/test_runtime_s1_12_j12_playable.sh"]:
            self.assertTrue((ROOT / path).exists(), path)

if __name__ == "__main__": unittest.main()
