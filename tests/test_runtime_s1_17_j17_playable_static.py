import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STATE_PATH = "game/scripts/runtime/season_1/Season1State.gd"
PROVIDER_PATH = "game/scripts/runtime/season_1/J17RuntimeProvider.gd"
DATA_PATH = "game/data/conversations/chapter_17_departure_and_couple.json"


class J17N8StaticContractTests(unittest.TestCase):
    def read(self, path):
        return (ROOT / path).read_text(encoding="utf-8")

    def data(self):
        return json.loads(self.read(DATA_PATH))

    def test_runtime_remains_playable_and_local(self):
        runtime_map = json.loads(self.read("game/data/runtime/season_1/j17_runtime_map.json"))
        self.assertEqual("PLAYABLE", runtime_map["implementation_status"])
        state = self.read(STATE_PATH)
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertIn("func begin_j17", state)
        self.assertIn("func _resolve_j17_couple_state", state)
        self.assertIn("const SNAPSHOT_VERSION := 21", season)
        self.assertIn("func _handoff_to_j17", season)

    def test_four_couple_choices_and_ui_order_are_unchanged(self):
        segments = {segment["id"]: segment for segment in self.data()["segments"]}
        due = [choice["id"] for choice in segments["j17_couple_due"]["choices"]]
        refused = [choice["id"] for choice in segments["j17_couple_refused"]["choices"]]
        self.assertEqual(
            ["choice_j17_reconquest", "choice_j17_provisional", "choice_j17_separation"],
            due,
        )
        self.assertEqual(["choice_j17_refused_acknowledge"], refused)
        self.assertEqual(4, len(due + refused))

    def test_authored_proofs_are_explicit(self):
        segments = {segment["id"]: segment for segment in self.data()["segments"]}
        choices = {choice["id"]: choice["text"].casefold() for choice in segments["j17_couple_due"]["choices"]}
        reconquest = choices["choice_j17_reconquest"]
        for phrase in ("aucun faux horaire", "aucun faux lieu", "aucune nouvelle progression extérieure", "prochain point"):
            self.assertIn(phrase, reconquest)
        provisional = choices["choice_j17_provisional"]
        for phrase in (
            "ce qui a existé dehors",
            "aucune nouvelle étape",
            "prochain point",
            "ni une ouverture ni une permission rétroactive",
            "personne d’autre n’est engagé",
            "tu peux refuser toute reconfiguration",
        ):
            self.assertIn(phrase, provisional)

    def test_six_states_and_eight_rules_are_closed_and_ordered(self):
        state = self.read(STATE_PATH)
        states = [
            "SEPARATION",
            "FRACTURE",
            "DOUBLE_LIFE_FRAGILE",
            "PROVISIONAL_AGREEMENT",
            "RECONQUEST_ACTIVE",
            "RECONFIGURATION_NEGOTIATION",
        ]
        constant = re.search(r"const J17_COUPLE_STATES := \[(.*?)\]", state).group(1)
        self.assertEqual(states, re.findall(r'"([A-Z_]+)"', constant))
        positions = [state.index(f"# Rule {number}:") for number in range(1, 9)]
        self.assertEqual(positions, sorted(positions))
        self.assertNotIn("RECONFIGURATION_NEGOTIATING", state)

    def test_predicates_and_exact_derived_formulas_are_present(self):
        state = self.read(STATE_PATH)
        for helper in (
            "_j17_marie_known_severe_violation_unrepaired",
            "_j17_material_fact_hidden",
            "_j17_incompatible_version_active",
            "_j17_repeated_marie_acts_proven",
            "_j17_concrete_rule_proven",
            "_j17_external_desire_acknowledged",
            "_j17_audiences_safe_or_repaired",
            "_j17_external_progression_pause_accepted",
            "_j17_marie_full_refusal_right_explicitly_acknowledged",
        ):
            self.assertIn(f"func {helper}", state)
        self.assertIn(
            "_j17_structural_input_valid(value) and not _j17_material_fact_hidden(value) and not _j17_incompatible_version_active(value)",
            state,
        )
        self.assertIn(
            "not _j17_marie_known_severe_violation_unrepaired(value) and not _j17_material_fact_hidden(value) and not _j17_incompatible_version_active(value)",
            state,
        )
        self.assertNotRegex(state, r"var\s+j17_no_active_violation")

    def test_record_schema_and_vocabularies_are_closed(self):
        state = self.read(STATE_PATH)
        for field in (
            "choice_id",
            "couple_state",
            "triggered_guard_fact_ids",
            "satisfied_constructive_condition_ids",
            "mathilde_micro_return_delivered",
            "marie_micro_return_delivered",
            "temporal_projection",
            "couple_discussion_due_at",
            "resolved_at",
        ):
            self.assertIn(f'"{field}"', state)
        self.assertIn("const J17_GUARD_FACT_IDS", state)
        self.assertIn("const J17_CONSTRUCTIVE_CONDITION_IDS", state)
        j17_block = state[state.index("const J17_COUPLE_STATES") : state.index("func complete_j17")]
        self.assertNotRegex(j17_block, r"(?i)route_points|consent_score|relationship_score|[a-z0-9_]+_score")

    def test_two_micro_returns_are_closed_and_have_no_choices(self):
        data = self.data()
        returns = data["micro_returns"]
        self.assertEqual(
            {
                "help_ordinary",
                "distance_ordinary",
                "help_aftercare_paid",
                "distance_aftercare_paid",
                "help_aftercare_failed",
                "distance_aftercare_failed",
            },
            set(returns["mathilde"]),
        )
        self.assertEqual(
            {
                "SEPARATION",
                "FRACTURE",
                "DOUBLE_LIFE_FRAGILE",
                "PROVISIONAL_AGREEMENT",
                "RECONQUEST_ACTIVE",
                "RECONFIGURATION_NEGOTIATION",
            },
            set(returns["marie"]),
        )
        for group in returns.values():
            for message in group.values():
                self.assertEqual({"id", "sender", "time_label", "text"}, set(message))
                self.assertNotIn("choices", message)
        provider = self.read(PROVIDER_PATH)
        self.assertIn("_deliver_mathilde_micro_return", provider)
        self.assertIn("_deliver_marie_micro_return", provider)
        self.assertIn("mark_j17_marie_micro_return_delivered", provider)
        self.assertNotIn("s1_m5_marie_player_final_conversation", provider + json.dumps(data))

    def test_forbidden_scores_and_identifier_are_absent_from_runtime(self):
        runtime = self.read(STATE_PATH) + self.read(PROVIDER_PATH) + self.read(DATA_PATH)
        for token in ("route_points", "consent_score", "attraction_score", "relationship_score", "passive_signals"):
            self.assertNotIn(token, runtime)
        self.assertNotIn("RECONFIGURATION_NEGOTIATING", runtime)


if __name__ == "__main__":
    unittest.main()
