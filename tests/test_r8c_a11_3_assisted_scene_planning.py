import copy
import json
import subprocess
import sys
import unittest
from pathlib import Path

from tools.a11_scene_planning import (
    DEFAULT_CASE_PATH,
    FORMAT_ASSISTED_SCENE_PLANNING,
    REVIEW_STATUSES,
    SPECIFICITY_CODES,
    bounded_options,
    cross_validate_sandra_plan,
    diagnose_intention,
    load_planning_case,
    planning_fingerprint,
    run_smoke,
    run_workflow,
    validate_human_selection,
    validate_plan_against_relationship,
    validate_planning_case,
    validate_scene_plan,
)
from tools.a11_voice_calibration import load_case as load_calibration_case


ROOT = Path(__file__).resolve().parents[1]
TOOL = ROOT / "tools/a11_scene_planning.py"
DOC = ROOT / "docs/architecture/R8C_A11_3_PLANIFICATION_ASSISTEE_SCENE.md"
REVIEW = ROOT / "narrative_tool/a11/planning/sandra_recontact_after_silence.human_review.md"


class R8CA113AssistedScenePlanningTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.case = load_planning_case()
        cls.sandra = load_calibration_case("sandra")
        cls.foreign = {
            "marie": load_calibration_case("marie"),
            "mathilde": load_calibration_case("mathilde"),
        }

    def validation(self, document, foreign=None):
        return validate_scene_plan(
            document,
            self.sandra,
            self.foreign if foreign is None else foreign,
        )

    @staticmethod
    def codes(report, kind="blocking_errors"):
        return {issue["code"] for issue in report[kind]}

    def test_expected_files_and_single_closed_versioned_extension(self):
        self.assertTrue(TOOL.is_file())
        self.assertTrue(DEFAULT_CASE_PATH.is_file())
        self.assertTrue(DOC.is_file())
        self.assertTrue(REVIEW.is_file())
        self.assertEqual(FORMAT_ASSISTED_SCENE_PLANNING, self.case["format"])
        self.assertEqual(1, self.case["version"])
        self.assertEqual([], validate_planning_case(self.case))

        unexpected = copy.deepcopy(self.case)
        unexpected["unexpected"] = True
        self.assertIn("CLOSED_SCHEMA_MISMATCH", {issue.code for issue in validate_planning_case(unexpected)})
        old = copy.deepcopy(self.case)
        old["version"] = 0
        self.assertIn("VERSION_UNKNOWN", {issue.code for issue in validate_planning_case(old)})

    def test_exact_human_intention_and_diagnostic_categories(self):
        expected = (
            "Player reprend contact avec Sandra après plusieurs jours de silence. "
            "Il veut vérifier que leur rapprochement récent n’était pas seulement un moment isolé, "
            "sans lui demander frontalement ce qu’elle ressent."
        )
        self.assertEqual(expected, self.case["intention"]["author_text"])
        diagnostic = diagnose_intention(self.case)
        self.assertEqual(
            {"present_information", "selectable_information_gaps", "mandatory_human_decision_ids"},
            set(diagnostic),
        )
        self.assertTrue(diagnostic["present_information"])
        self.assertTrue(diagnostic["selectable_information_gaps"])
        serialized = json.dumps(diagnostic, ensure_ascii=False).casefold()
        self.assertNotIn("completeness", serialized)
        self.assertNotIn("complétude", serialized)

    def test_bounded_options_keep_author_order_and_no_automatic_pick(self):
        gaps = bounded_options(self.case)
        self.assertEqual(
            ["select_concrete_hook", "select_maximum_change", "select_choice_mode"],
            [gap["decision_id"] for gap in gaps],
        )
        self.assertEqual(
            ["folded_ticket", "old_bus_shelter", "overinfused_tea"],
            [option["option_id"] for option in gaps[0]["options"]],
        )
        self.assertTrue(all(1 <= len(gap["options"]) <= 3 for gap in gaps))
        self.assertEqual([], validate_human_selection(self.case))

        missing = copy.deepcopy(self.case)
        missing["human_selection"]["decisions"].pop()
        self.assertIn("HUMAN_SELECTION_INCOMPLETE", {issue.code for issue in validate_human_selection(missing)})
        reordered = copy.deepcopy(self.case)
        reordered["human_selection"]["decisions"].reverse()
        self.assertIn("HUMAN_SELECTION_INCOMPLETE", {issue.code for issue in validate_human_selection(reordered)})
        anonymous = copy.deepcopy(self.case)
        anonymous["human_selection"]["selected_by"] = ""
        self.assertIn("HUMAN_SELECTION_REQUIRED", {issue.code for issue in validate_human_selection(anonymous)})
        wrong_decisions = copy.deepcopy(self.case)
        wrong_decisions["diagnostic"]["mandatory_human_decision_ids"][0] = "different_decision"
        self.assertIn(
            "PROTOTYPE_DECISIONS_MISMATCH",
            {issue.code for issue in validate_planning_case(wrong_decisions)},
        )

    def test_selected_options_must_bind_the_plan(self):
        mutant = copy.deepcopy(self.case)
        mutant["plan"]["hook"]["selection_option_id"] = "old_bus_shelter"
        self.assertIn("PLAN_SELECTION_MISMATCH", self.codes(self.validation(mutant)))
        mutant = copy.deepcopy(self.case)
        mutant["plan"]["maximum_change"]["outcome_id"] = "recontact"
        self.assertIn("PLAN_SELECTION_MISMATCH", self.codes(self.validation(mutant)))
        mutant = copy.deepcopy(self.case)
        mutant["plan"]["maximum_change"]["selection_option_id"] = "recontact_only"
        self.assertIn("PLAN_SELECTION_MISMATCH", self.codes(self.validation(mutant)))
        mutant = copy.deepcopy(self.case)
        mutant["plan"]["choice_mode"] = "NONE"
        self.assertIn("PLAN_SELECTION_MISMATCH", self.codes(self.validation(mutant)))

    def test_final_plan_contains_required_bounded_structure(self):
        plan = self.case["plan"]
        self.assertEqual(["player", "sandra"], plan["participant_ids"])
        self.assertEqual(7, len(plan["beats"]))
        self.assertEqual(
            [
                "accroche_concrete",
                "calibration",
                "relance_indirecte",
                "esquive_ou_test_de_sandra",
                "positionnement_eventuel_de_player",
                "reception",
                "sortie",
            ],
            [beat["function"] for beat in plan["beats"]],
        )
        self.assertEqual({"player", "sandra"}, {objective["actor_id"] for objective in plan["objectives"]})
        self.assertTrue(plan["local_risk"])
        self.assertEqual("possible_meeting", plan["maximum_change"]["outcome_id"])
        self.assertEqual("ONE", plan["choice_mode"])
        self.assertEqual("NONE", plan["media_requirement"]["media_decision"])
        self.assertFalse(plan["protective_close"]["punitive"])
        self.assertEqual("READY", self.validation(self.case)["status"])

        minimal_beat_fields = {
            "scene_kind",
            "narrative_moment",
            "state_before",
            "possible_local_delta",
            "transition_condition",
            "forbidden_elements",
        }
        for beat in plan["beats"]:
            self.assertTrue(minimal_beat_fields.issubset(beat))
            self.assertIn(beat["scene_kind"], {"MODULAR", "SIGNATURE"})
            self.assertTrue(beat["forbidden_elements"])

        missing_field = copy.deepcopy(self.case)
        missing_field["plan"]["beats"][0].pop("transition_condition")
        self.assertIn(
            "CLOSED_SCHEMA_MISMATCH",
            {issue.code for issue in validate_planning_case(missing_field)},
        )

    def test_unexpected_participant_and_missing_register_block(self):
        participant = copy.deepcopy(self.case)
        participant["plan"]["participant_ids"].append("marie")
        self.assertTrue(
            {"UNEXPECTED_PARTICIPANT", "CONTEXTUAL_CHARACTER_ACTIVATED"}.issubset(
                self.codes(self.validation(participant))
            )
        )
        register = copy.deepcopy(self.case)
        register["active_relationship_id"] = "unknown_relation"
        self.assertIn("RELATIONSHIP_REGISTER_MISSING", self.codes(self.validation(register)))
        active = copy.deepcopy(self.case)
        active["active_character_id"] = "marie"
        active["intention"]["contextual_character_ids"].append("mathilde")
        self.assertIn("UNEXPECTED_PARTICIPANT", self.codes(self.validation(active)))

    def test_missing_objective_or_beat_function_and_engine_block(self):
        objective = copy.deepcopy(self.case)
        objective["plan"]["objectives"] = objective["plan"]["objectives"][:1]
        self.assertIn("OBJECTIVE_MISSING", self.codes(self.validation(objective)))
        foreign_objective = copy.deepcopy(self.case)
        foreign_objective["plan"]["objectives"].append(
            {"actor_id": "marie", "intent": "Observer.", "method": "Réagir."}
        )
        self.assertIn("UNEXPECTED_PARTICIPANT", self.codes(self.validation(foreign_objective)))

        beat = copy.deepcopy(self.case)
        beat["plan"]["beats"][2]["function"] = ""
        beat["plan"]["beats"][2]["movement_refs"] = []
        codes = self.codes(self.validation(beat))
        self.assertIn("BEAT_FUNCTION_MISSING", codes)
        self.assertIn("BEAT_ENGINE_MISSING", codes)
        empty_summary = copy.deepcopy(self.case)
        empty_summary["plan"]["beats"][2]["summary"] = ""
        self.assertIn("BEAT_SUMMARY_MISSING", self.codes(self.validation(empty_summary)))
        wrong_driver = copy.deepcopy(self.case)
        wrong_driver["plan"]["beats"][1]["movement_refs"] = ["sandra_player_returns_carefully"]
        self.assertIn("BEAT_DRIVER_MOVEMENT_MISMATCH", self.codes(self.validation(wrong_driver)))

    def test_unknown_or_forbidden_fact_and_missing_limit_block(self):
        unknown = copy.deepcopy(self.case)
        unknown["plan"]["beats"][0]["fact_refs"] = ["unknown_memory"]
        self.assertIn("FACT_UNKNOWN", self.codes(self.validation(unknown)))

        forbidden = copy.deepcopy(self.case)
        forbidden["plan"]["beats"][0]["fact_refs"] = ["marie_missed_commitment"]
        forbidden["plan"]["fact_policy"]["usable_fact_ids"].append("marie_missed_commitment")
        self.assertTrue(
            {"FACT_UNKNOWN", "FORBIDDEN_FACT_USED"}.issubset(self.codes(self.validation(forbidden)))
        )

        limit = copy.deepcopy(self.case)
        limit["plan"]["required_limit_ids"].remove("sandra_slow_progress")
        self.assertIn("LIMIT_VIOLATED", self.codes(self.validation(limit)))
        unknown_forbidden = copy.deepcopy(self.case)
        unknown_forbidden["plan"]["fact_policy"]["forbidden_fact_ids"][0] = "invented_private_fact"
        self.assertIn("FORBIDDEN_FACT_UNKNOWN", self.codes(self.validation(unknown_forbidden)))

    def test_maximum_change_and_forbidden_consequence_block(self):
        maximum = copy.deepcopy(self.case)
        maximum["diagnostic"]["selectable_information_gaps"][1]["options"][1]["plan_value"] = "locked_route"
        maximum["plan"]["maximum_change"]["outcome_id"] = "locked_route"
        maximum["plan"]["planned_outcome_ids"] = ["locked_route"]
        codes = self.codes(self.validation(maximum))
        self.assertIn("MAXIMUM_CHANGE_EXCEEDED", codes)
        self.assertIn("FORBIDDEN_CONSEQUENCE", codes)
        different_allowed = copy.deepcopy(self.case)
        different_allowed["plan"]["planned_outcome_ids"] = ["recontact"]
        self.assertIn("MAXIMUM_CHANGE_EXCEEDED", self.codes(self.validation(different_allowed)))
        no_description = copy.deepcopy(self.case)
        no_description["plan"]["maximum_change"]["description"] = ""
        self.assertIn("MAXIMUM_CHANGE_MISSING", self.codes(self.validation(no_description)))

    def test_choice_requires_ordered_reception_for_every_option(self):
        mutant = copy.deepcopy(self.case)
        mutant["plan"]["choice"]["receptions"].pop()
        self.assertIn("CHOICE_RECEPTION_MISSING", self.codes(self.validation(mutant)))
        empty = copy.deepcopy(self.case)
        empty["plan"]["choice"]["receptions"][0]["description"] = ""
        empty["plan"]["choice"]["options"][0]["attitude"] = ""
        codes = self.codes(self.validation(empty))
        self.assertIn("CHOICE_RECEPTION_MISSING", codes)
        self.assertIn("CHOICE_OPTION_MISSING", codes)
        unknown_movement = copy.deepcopy(self.case)
        unknown_movement["plan"]["choice"]["receptions"][0]["movement_refs"] = ["foreign_movement"]
        self.assertIn("CHOICE_RECEPTION_MISSING", self.codes(self.validation(unknown_movement)))
        wrong_actor = copy.deepcopy(self.case)
        wrong_actor["plan"]["choice"]["receptions"][0]["movement_refs"] = [
            "sandra_player_returns_carefully"
        ]
        self.assertIn("CHOICE_RECEPTION_MISSING", self.codes(self.validation(wrong_actor)))
        expected_wrong_actor = copy.deepcopy(self.case)
        expected_wrong_actor["plan"]["expected_reception"]["movement_refs"] = [
            "sandra_player_returns_carefully"
        ]
        self.assertIn("EXPECTED_RECEPTION_MISSING", self.codes(self.validation(expected_wrong_actor)))

    def test_media_must_be_absent_or_factually_justified(self):
        stray = copy.deepcopy(self.case)
        stray["plan"]["media_requirement"]["kind"] = "PHOTO"
        self.assertIn("MEDIA_UNJUSTIFIED", self.codes(self.validation(stray)))
        pending = copy.deepcopy(self.case)
        pending["plan"]["media_requirement"] = {
            "media_decision": "HUMAN_DECISION_PENDING",
            "kind": "PHOTO",
            "linked_fact_id": "unknown_memory",
            "justification": "Décision à prendre.",
        }
        self.assertIn("MEDIA_UNJUSTIFIED", self.codes(self.validation(pending)))
        implicit = copy.deepcopy(self.case)
        implicit["plan"]["media_requirement"].pop("media_decision")
        self.assertIn(
            "CLOSED_SCHEMA_MISMATCH",
            {issue.code for issue in validate_planning_case(implicit)},
        )

    def test_protective_close_is_valid_but_punishment_blocks(self):
        self.assertFalse(self.case["plan"]["protective_close"]["punitive"])
        self.assertIn("autonomie", self.case["plan"]["protective_close"]["protects"])
        mutant = copy.deepcopy(self.case)
        mutant["plan"]["protective_close"]["punitive"] = True
        self.assertIn("PROTECTIVE_CLOSE_PUNITIVE", self.codes(self.validation(mutant)))

        disguised = copy.deepcopy(self.case)
        disguised["plan"]["protective_close"]["punitive"] = False
        disguised["plan"]["protective_close"]["description"] = (
            "Sandra humilie Player, rompt le lien et ferme toute reprise"
        )
        self.assertIn("PROTECTIVE_CLOSE_PUNITIVE", self.codes(self.validation(disguised)))

        no_future = copy.deepcopy(self.case)
        no_future["plan"]["protective_close"]["future_possibility"] = "NONE"
        self.assertIn("PROTECTIVE_CLOSE_FUTURE_MISSING", self.codes(self.validation(no_future)))

        no_autonomy = copy.deepcopy(self.case)
        no_autonomy["plan"]["protective_close"]["autonomous_exit_character_id"] = "player"
        self.assertIn("PROTECTIVE_CLOSE_AUTONOMY_MISSING", self.codes(self.validation(no_autonomy)))

    def test_final_dialogue_is_refused_in_every_editorial_plan_text(self):
        injections = (
            (
                ("beats", 2, "summary"),
                "Sandra : « Tu veux vraiment reprendre ? »",
            ),
            (
                ("expected_reception", "description"),
                "Je voulais savoir si ce moment comptait pour toi.",
            ),
            (
                ("protective_close", "protects"),
                "— Reviens quand tu auras compris.",
            ),
            (("media_requirement", "justification"), "Player : Tu dois regarder cette image."),
        )
        for path, final_line in injections:
            mutant = copy.deepcopy(self.case)
            target = mutant["plan"]
            for key in path[:-1]:
                target = target[key]
            target[path[-1]] = final_line
            self.assertIn(
                "FINAL_DIALOGUE_IN_PLAN",
                self.codes(self.validation(mutant)),
                ".".join(str(part) for part in path),
            )

    def test_human_review_status_and_exact_fingerprint_are_mandatory(self):
        self.assertEqual(
            {"DRAFT", "NEEDS_REVISION", "APPROVED_FOR_DRAFT_GENERATION", "REJECTED"},
            REVIEW_STATUSES,
        )
        self.assertEqual(
            planning_fingerprint(self.case, self.sandra),
            self.case["human_review"]["plan_fingerprint"],
        )
        for status in ("DRAFT", "NEEDS_REVISION", "REJECTED"):
            mutant = copy.deepcopy(self.case)
            mutant["human_review"]["status"] = status
            self.assertIn("HUMAN_APPROVAL_ABSENT", self.codes(self.validation(mutant)))
        changed = copy.deepcopy(self.case)
        changed["plan"]["local_risk"] += " Révision."
        self.assertIn("HUMAN_APPROVAL_ABSENT", self.codes(self.validation(changed)))

        changed_contract = copy.deepcopy(self.sandra)
        changed_contract["character"]["voice"]["rhythm"] += " Révision du contrat."
        self.assertIn(
            "HUMAN_APPROVAL_ABSENT",
            self.codes(
                validate_scene_plan(
                    self.case,
                    changed_contract,
                    self.foreign,
                )
            ),
        )

    def test_warning_catalog_is_exercised_without_aggregate_result(self):
        mutant = copy.deepcopy(self.case)
        mutant["plan"]["hook"]["concrete"] = False
        mutant["plan"]["objectives"][1]["intent"] = mutant["plan"]["objectives"][0]["intent"]
        mutant["plan"]["objectives"][1]["method"] = mutant["plan"]["objectives"][0]["method"]
        mutant["plan"]["beats"][1]["function"] = mutant["plan"]["beats"][0]["function"]
        mutant["plan"]["local_risk"] = ""
        mutant["plan"]["protective_close"]["description"] = "Tout est réglé dans une issue parfaite."
        mutant["plan"]["planned_outcome_ids"].append("recontact")
        for beat in mutant["plan"]["beats"]:
            beat["driver_id"] = "player"
        fake_foreign = {
            "marie": {"relationship": copy.deepcopy(self.sandra["relationship"])},
            "mathilde": {"relationship": copy.deepcopy(self.sandra["relationship"])},
        }
        codes = self.codes(self.validation(mutant, fake_foreign), "warnings")
        self.assertTrue(
            {
                "HOOK_ABSTRACT",
                "BEATS_REDUNDANT",
                "LOCAL_RISK_MISSING",
                "EXIT_TOO_PERFECT",
                "EVOLUTION_TOO_IMPORTANT",
                "PLAN_INTERCHANGEABLE",
                "PLAYER_DRIVES_ENTIRE_SCENE",
                "SANDRA_REDUCED_TO_REACTION",
            }.issubset(codes)
        )
        report = self.validation(self.case)
        self.assertEqual({"status", "blocking_errors", "warnings"}, set(report))

        empty_hook = copy.deepcopy(self.case)
        empty_hook["plan"]["hook"]["description"] = ""
        self.assertIn("HOOK_ABSTRACT", self.codes(self.validation(empty_hook), "warnings"))

    def test_missing_warning_cases_are_structural_and_non_blocking(self):
        unused_hook = copy.deepcopy(self.case)
        hook_fact_id = unused_hook["plan"]["hook"]["fact_id"]
        for beat in unused_hook["plan"]["beats"]:
            beat["fact_refs"] = [
                fact_id for fact_id in beat["fact_refs"] if fact_id != hook_fact_id
            ]
        unused_hook["human_review"]["plan_fingerprint"] = planning_fingerprint(unused_hook, self.sandra)
        unused_hook_report = self.validation(unused_hook)
        self.assertEqual("READY_WITH_WARNINGS", unused_hook_report["status"])
        self.assertIn(
            "CONCRETE_DETAIL_WITHOUT_FUNCTION",
            self.codes(unused_hook_report, "warnings"),
        )

        romantic_only = copy.deepcopy(self.case)
        romantic_only["plan"]["local_risk"] = "Une attirance demeure ambiguë."
        romantic_only["plan"]["objectives"][0]["intent"] = (
            "Entretenir une ambiguïté affective."
        )
        romantic_only["plan"]["objectives"][0]["method"] = (
            "Maintenir un sous-entendu romantique."
        )
        romantic_only["plan"]["objectives"][1]["intent"] = "Observer une attirance."
        romantic_only["plan"]["objectives"][1]["method"] = "Prolonger un désir romantique."
        romantic_only["human_review"]["plan_fingerprint"] = planning_fingerprint(
            romantic_only,
            self.sandra,
        )
        romantic_report = self.validation(romantic_only)
        self.assertEqual("READY_WITH_WARNINGS", romantic_report["status"])
        self.assertIn(
            "ROMANTIC_SUBTEXT_ONLY_TENSION",
            self.codes(romantic_report, "warnings"),
        )

        symmetric = copy.deepcopy(self.case)
        symmetric["plan"]["objectives"][1]["intent"] = symmetric["plan"]["objectives"][0][
            "intent"
        ]
        symmetric["plan"]["objectives"][1]["method"] = symmetric["plan"]["objectives"][0][
            "method"
        ]
        shared_movements = list(symmetric["plan"]["movement_ids"])
        for beat in symmetric["plan"]["beats"]:
            beat["movement_refs"] = shared_movements
        symmetric["human_review"]["plan_fingerprint"] = planning_fingerprint(
            symmetric,
            self.sandra,
        )
        symmetric_report = self.validation(symmetric)
        self.assertEqual("READY_WITH_WARNINGS", symmetric_report["status"])
        self.assertIn(
            "OBJECTIVES_SYMMETRIC",
            self.codes(symmetric_report, "warnings"),
        )

    def test_sandra_specificity_fails_under_marie_and_mathilde_structurally(self):
        cross = cross_validate_sandra_plan(self.case)
        self.assertTrue(cross["sandra"]["compatible"])
        self.assertEqual([], cross["sandra"]["issues"])
        for name in ("marie", "mathilde"):
            self.assertFalse(cross[name]["compatible"])
            self.assertTrue(SPECIFICITY_CODES.issubset({issue["code"] for issue in cross[name]["issues"]}))

    def test_specificity_proof_does_not_depend_on_names_or_lexicon(self):
        neutral = copy.deepcopy(self.case["plan"])
        neutral["title"] = "Plan neutre"
        neutral["hook"]["description"] = "Mouvement éditorial neutre."
        neutral["relationship_nature"] = self.case["plan"]["relationship_nature"]
        for index, beat in enumerate(neutral["beats"]):
            beat["summary"] = f"Mouvement éditorial neutre {index + 1}."
        for name in ("marie", "mathilde"):
            issues = validate_plan_against_relationship(neutral, self.foreign[name]["relationship"])
            self.assertTrue(SPECIFICITY_CODES.issubset({issue.code for issue in issues}))

    def test_workflow_chain_stops_at_approved_plan(self):
        workflow = run_workflow(self.case)
        self.assertEqual(
            [
                "human_intention",
                "diagnostic",
                "bounded_options",
                "human_selection",
                "plan",
                "validation",
                "human_review",
            ],
            workflow["chain"],
        )
        self.assertEqual("READY", workflow["validation"]["status"])
        self.assertNotIn("draft", workflow)
        self.assertNotIn("a6", workflow)

    def test_review_sheet_carries_all_statuses_and_no_side_effect(self):
        content = REVIEW.read_text(encoding="utf-8")
        for status in REVIEW_STATUSES:
            self.assertIn(f"`{status}`", content)
        self.assertIn(self.case["human_review"]["plan_fingerprint"], content)
        self.assertIn("aucun export A6", content)
        self.assertIn("ne déclenche aucune opération", content)

    def test_lot_is_offline_bounded_and_disconnected_from_game(self):
        paths = [TOOL, DOC, REVIEW, DEFAULT_CASE_PATH]
        sources = "\n".join(path.read_text(encoding="utf-8") for path in paths).casefold()
        forbidden = [
            "sco" + "re",
            "rank" + "ing",
            "prior" + "ity",
            "priorit" + "é",
            "rand" + "om",
            "has" + "ard",
            "leg" + "acy",
            "portrait" + "main",
            "season" + "1runtimeprovider",
            "scripts/runtime/" + "season_1",
            "scripts/" + "narrative_state",
            "http://",
            "https://",
        ]
        for token in forbidden:
            self.assertNotIn(token, sources, token)
        self.assertEqual([], list((ROOT / "game").rglob("*a11_3*")))
        self.assertNotIn("export_a6", TOOL.read_text(encoding="utf-8"))
        self.assertNotIn("write_text", TOOL.read_text(encoding="utf-8"))

    def test_cli_diagnostic_options_workflow_cross_validation_and_smoke(self):
        smoke = run_smoke()
        self.assertTrue(smoke["ok"])
        self.assertEqual(7, smoke["beat_count"])
        for command in ("validate-json", "diagnostic", "options", "workflow", "cross-validate", "smoke"):
            result = subprocess.run(
                [sys.executable, "tools/a11_scene_planning.py", command],
                cwd=ROOT,
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(0, result.returncode, result.stderr)
            self.assertTrue(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
