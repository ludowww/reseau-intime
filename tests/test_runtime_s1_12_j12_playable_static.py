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

    def test_r5c_p11_p12_and_p13_have_exact_lifecycle_contracts(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        provider = self.read("game/scripts/runtime/season_1/J12RuntimeProvider.gd")
        self.assertIn("const SNAPSHOT_VERSION := 25", state)
        for token in [
            '"due_at": "J12 11:00"',
            '"counterparty_confirmation_deadline": "J11 18:00"',
            '"player_confirmation_deadline": "J12 09:30"',
            "func expire_j12_p11_player_confirmation",
            "func pay_j12_p11",
            "func pay_j12_laverriere_presence",
            "func pay_j12_annexe_continuation",
            '"L-A":"J12 17:45"',
            '"L-B":"J12 19:15"',
            '"L-C":"J12 20:15–21:15"',
            '"due_at":"J12 22:50"',
        ]:
            self.assertIn(token, state)
        self.assertIn("P11_PLAYER_CONFIRMATION_DEADLINE_MINUTES := 570", provider)
        self.assertIn("_expire_overdue_p11()", provider)
        self.assertIn("state.pay_j12_laverriere_presence()", provider)
        self.assertIn("state.pay_j12_annexe_continuation()", provider)
        complete_j12 = state.split("func complete_j12", 1)[1].split("func begin_j13", 1)[0]
        self.assertNotIn('presence["status"] = "PAID"', complete_j12)
        self.assertNotIn('annexe["status"] = "PAID"', complete_j12)

    def test_r5c_public_traces_t16_and_f20_preserve_epistemic_distinctions(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        provider = self.read("game/scripts/runtime/season_1/J12RuntimeProvider.gd")
        for token in [
            "func establish_j12_laverriere_public_trace",
            '"creator":"Élodie"', '"owner":"La Verrière"',
            '"current_state":"PUBLIC_ACTIVE"', '"shareability":"PUBLIC"',
            "func establish_j12_annexe_public_trace",
            '"creator":"Sophie"', '"owner":"Sophie"',
            '"player_present":j12_annexe_choice != "C12"',
            '"player_photographed":j12_annexe_choice != "C12"',
            '"player_received_trace":true',
            "func establish_j12_sandra_public_context_view",
            '"fact_sandra_saw_public_j12_context"',
            "func establish_j12_unusual_behavior",
            '"source_type":"DIRECT_OBSERVATION"',
            '"certainty":"OBSERVED"', '"meaning_certainty":"INFERRED"',
            '"shareability":"FACTUAL_ONLY"',
        ]:
            self.assertIn(token, state)
        self.assertIn("state.establish_j12_sandra_public_context_view()", provider)
        self.assertIn('str(trace.get("current_state", "")) != "REMOVED"', provider)
        smoke = self.read("game/tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd")
        for route in ["choice_j12_presence_la", "choice_j12_presence_lb", "choice_j12_presence_lc", "choice_j12_annexe_a12", "choice_j12_annexe_b12", "choice_j12_annexe_c12"]:
            self.assertIn(route, smoke)

    def test_r5c_t14_requires_explicit_physical_presence(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        helper = state.split("func _j12_laverriere_subjects", 1)[1].split("func ", 1)[0]
        self.assertIn('J12_LAVERRIERE_EXPLICIT_SUBJECTS := ["Marie", "Player", "Pauline", "Bastien", "Élodie"]', state)
        self.assertIn("return J12_LAVERRIERE_EXPLICIT_SUBJECTS.duplicate()", helper)
        for inferred_subject in ["Mathilde", "Raphaëlle", "Sandra", "Nico", "j11_pivot", "j11_pivot_outcome", "aftercare"]:
            self.assertNotIn(inferred_subject, helper)
        smoke = self.read("game/tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd")
        for evidence in ["FIRST_KISS does not infer Raphaëlle as a T14 subject", "M-B2 does not infer Mathilde as a T14 subject"]:
            self.assertIn(evidence, smoke)

    def test_j12_priority_debt_is_canonical_and_old_snapshots_are_rejected(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        smoke = self.read("game/tests/RUNTIME_S1_12J12PlayableSmokeDriver.gd")
        for route in ["SANDRA", "MATHILDE", "RAPHAELLE", "NICO", "MARIE", "NETWORK"]:
            self.assertIn(f'"{route}"', state)
        for token in [
            "j12_priority_route", "j12_failed_aftercare_processed", "func begin_j12", "func complete_j12",
            '"due_at":"J13 avant toute nouvelle opportunité"', '"route":route',
            "MATHILDE_HOUSEHOLD_AFTERCARE", "const SNAPSHOT_VERSION := 25", "if version != SNAPSHOT_VERSION",
        ]:
            self.assertIn(token, state)
        self.assertNotIn("func _migrate_r5c_j12_registers", state)
        self.assertIn("current v25 snapshot round-trips", smoke)
        self.assertIn("obsolete state snapshot is rejected", smoke)
        self.assertIn('if state.j11_pivot_outcome == "SANDRA_IMAGE_REMOVED": return "NETWORK"', self.read("game/scripts/runtime/season_1/J12RuntimeProvider.gd"))
    def test_j11_exact_outcomes_and_morning_aftercare_use_current_state(self):
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
        self.assertNotIn('resolve_j11_aftercare("aftercare_marie_j11"', j11.split("func confirm_scene_sequence", 1)[1].split("func ", 1)[0])
        for token in ["Café dans dix minutes.", "hier soir ne te dispense pas d’être une personne ce matin.", "j12_marie_morning_aftercare"]:
            self.assertIn(token, obligations)
        self.assertIn("state.pay_j12_marie_aftercare()", j12)
        self.assertIn('return "MATHILDE"', j12.split("func _priority_route", 1)[1])
        self.assertIn("MATHILDE_HOUSEHOLD_AFTERCARE", state)
        self.assertIn("const SNAPSHOT_VERSION := 25", state)
        self.assertIn("if version != SNAPSHOT_VERSION", state)
        self.assertNotIn("func _migrate_r5a_j11_semantic_outcome", state)
        self.assertNotIn("func _migrate_r5b_j11_semantic_outcome", state)
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

    def test_r5b_exact_outcomes_modules_aftercare_and_silence(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        j11 = self.read("game/scripts/runtime/season_1/J11RuntimeProvider.gd")
        j12 = self.read("game/scripts/runtime/season_1/J12RuntimeProvider.gd")
        laverriere = self.load("game/data/conversations/chapter_12_laverriere.json")
        annexe = self.load("game/data/conversations/chapter_12_annexe.json")
        outcomes = [
            "SANDRA_RULE_CLARIFIED", "SANDRA_DESIRE_BOUNDED", "SANDRA_IMAGE_REMOVED",
            "FIRST_KISS", "KISS_DECLINED", "RESULT_SENT_ATTRACTION_NAMED", "RESULT_SENT_BOUNDARY_HELD",
            "NICO_GUARDRAIL_HELD", "NICO_RIVALRY_MAINTAINED", "NICO_CLEAN_CLOSE",
        ]
        for outcome in outcomes:
            self.assertIn(outcome, state)
            self.assertIn(outcome, j12)
        for outcome in ["SANDRA_RULE_CLARIFIED", "SANDRA_DESIRE_BOUNDED", "SANDRA_IMAGE_REMOVED", "NICO_GUARDRAIL_HELD", "NICO_RIVALRY_MAINTAINED", "NICO_CLEAN_CLOSE"]:
            self.assertIn(outcome, j11)
        for private_outcome in ["SANDRA_RESPONSE_CLEAR", "SANDRA_RESPONSE_DELAYED", "SANDRA_EXIT_CLEAN"]:
            self.assertIn(private_outcome, state)
            self.assertIn(private_outcome, j12)
        lav_ids = {segment["id"] for segment in laverriere["segments"]}
        annexe_ids = {segment["id"] for segment in annexe["segments"]}
        for segment_id in [
            "j12_sandra_rule_context", "j12_sandra_desire_context",
            "j12_raphaelle_first_kiss_context", "j12_raphaelle_attraction_context",
            "j12_raphaelle_kiss_declined_context", "j12_raphaelle_boundary_context",
        ]:
            self.assertIn(segment_id, lav_ids)
        for segment_id in [
            "j12_after_sandra_clear", "j12_after_sandra_delayed", "j12_after_sandra_exit",
            "j12_after_raphaelle_first_kiss", "j12_after_raphaelle_attraction",
            "j12_after_raphaelle_kiss_declined", "j12_after_raphaelle_boundary",
            "j12_nico_guardrail_module", "j12_nico_rivalry_module",
            "j12_after_nico_guardrail", "j12_after_nico_rivalry",
        ]:
            self.assertIn(segment_id, annexe_ids)
        self.assertNotIn("j12_after_sandra_removed", annexe_ids)
        self.assertNotIn("j12_after_nico_clean_close", annexe_ids)
        self.assertIn('"SANDRA_IMAGE_REMOVED": return ""', j12)
        self.assertIn('"NICO_CLEAN_CLOSE": return ""', j12)

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
