import copy
import hashlib
import json
import subprocess
import sys
import unittest
from pathlib import Path

from tools.a11_plan_draft_export import (
    N2_BLIND_READING_PATH,
    N2_COMPARISON_PATH,
    N2_DECISION_PATH,
    N2_DRAFT_PATH,
    N2_HUMAN_REVIEW_PATH,
    N2_LOCKED_SOURCE_PATH,
    N2_PLAN_PATH,
    N2_PROVENANCE_PATH,
    N2_REVIEW_STATUSES,
    N2_SOURCE_PATH,
    N2_TRACEABILITY_PATH,
    N2_VALIDATION_PATH,
    PILOT_DECISION_PATH,
    PILOT_DRAFT_PATH,
    PILOT_HUMAN_REVIEW_PATH,
    PILOT_PLAN_PATH,
    PILOT_PROVENANCE_PATH,
    PILOT_SOURCE_PATH,
    PILOT_TRACEABILITY_PATH,
    PILOT_VALIDATION_PATH,
    build_n2_comparison,
    editorial_decision_fingerprint,
    editorial_draft_projection,
    editorial_source_content_sha256,
    editorial_source_projection,
    load_n2_workspace,
    n2_locked_source_sha256,
    parse_n2_locked_source,
    render_editorial_blind_reading,
    render_editorial_human_review,
    run_n2_smoke,
    validate_n2_decision,
    validate_n2_json_library,
    validate_n2_manifest,
    validate_n2_revision,
)


ROOT = Path(__file__).resolve().parents[1]
TOOL = ROOT / "tools/a11_plan_draft_export.py"
DOC = ROOT / "docs/narrative/R8C_N2_SANDRA_BLUE_CHAIRS_MINOR_NARRATIVE_REVISION.md"
N1_DOC = ROOT / "docs/narrative/R8C_N1_CANON_REVIEW_SANDRA_BLUE_CHAIRS.md"
BASELINE = "25e8cafac7e14487a2cf57e41c1b1d151873cbbb"
BRANCH = "work/r8c-n2-sandra-blue-chairs-minor-narrative-revision"
LOCKED_SHA256 = "af0e48812a160b701b7e60638407513f86b892bbae2258eea1050d7a6a70b404"
SOURCE_SHA256 = "e1acea2817267d47ffb5e1f6f628aeb03c16056ce5f2f100c0803dcc3cf93a98"
A115_SOURCE_SHA256 = "9167120abc55dbf4275ac67eb7b4f774a58322587d87c9310644e3bcf85982dd"


class R8CN2SandraBlueChairsRevisionTests(unittest.TestCase):
    def setUp(self):
        self.workspace = load_n2_workspace()
        self.historical = json.loads(PILOT_SOURCE_PATH.read_text(encoding="utf-8"))

    @staticmethod
    def codes(report, field="blocking_errors"):
        return {item["code"] for item in report[field]}

    def mutant(self):
        return load_n2_workspace(include_outputs=False)

    def test_exact_baseline_tag_branch_and_deliverables(self):
        self.assertEqual(
            BASELINE,
            subprocess.check_output(
                ["git", "merge-base", "HEAD", "r8c-n1-canon-review-sandra-blue-chairs"],
                cwd=ROOT,
                text=True,
            ).strip(),
        )
        self.assertEqual(
            BASELINE,
            subprocess.check_output(
                ["git", "rev-parse", "r8c-n1-canon-review-sandra-blue-chairs^{}"],
                cwd=ROOT,
                text=True,
            ).strip(),
        )
        self.assertEqual(
            BRANCH,
            subprocess.check_output(["git", "branch", "--show-current"], cwd=ROOT, text=True).strip(),
        )
        expected = [
            N2_LOCKED_SOURCE_PATH,
            N2_SOURCE_PATH,
            N2_PROVENANCE_PATH,
            N2_PLAN_PATH,
            N2_DRAFT_PATH,
            N2_VALIDATION_PATH,
            N2_COMPARISON_PATH,
            N2_TRACEABILITY_PATH,
            N2_BLIND_READING_PATH,
            N2_HUMAN_REVIEW_PATH,
            N2_DECISION_PATH,
            DOC,
            TOOL,
        ]
        self.assertEqual([], [str(path) for path in expected if not path.is_file()])

    def test_a115_historical_artifacts_are_unchanged(self):
        historical_paths = [
            PILOT_SOURCE_PATH,
            PILOT_PROVENANCE_PATH,
            PILOT_PLAN_PATH,
            PILOT_DRAFT_PATH,
            PILOT_VALIDATION_PATH,
            PILOT_TRACEABILITY_PATH,
            PILOT_HUMAN_REVIEW_PATH,
            PILOT_DECISION_PATH,
            N1_DOC,
        ]
        relative = [str(path.relative_to(ROOT)) for path in historical_paths]
        changed = subprocess.check_output(
            ["git", "diff", "--name-only", BASELINE, "--", *relative],
            cwd=ROOT,
            text=True,
        ).splitlines()
        self.assertEqual([], changed)
        self.assertEqual(A115_SOURCE_SHA256, editorial_source_content_sha256(self.historical))

    def test_locked_markdown_and_json_are_exact_projections_of_chatgpt_source(self):
        raw = N2_LOCKED_SOURCE_PATH.read_text(encoding="utf-8")
        self.assertEqual(LOCKED_SHA256, hashlib.sha256(raw.rstrip("\r\n").encode("utf-8")).hexdigest())
        self.assertEqual(LOCKED_SHA256, n2_locked_source_sha256())
        parsed = parse_n2_locked_source(raw)
        source = self.workspace["source"]
        self.assertEqual(editorial_source_projection(parsed), editorial_source_projection(source))
        self.assertEqual(SOURCE_SHA256, editorial_source_content_sha256(source))
        self.assertEqual(editorial_source_projection(source), editorial_draft_projection(self.workspace))

    def test_only_closed_manifest_changes_are_present(self):
        source = self.workspace["source"]
        self.assertEqual([], validate_n2_manifest(self.historical, source))
        comparison = build_n2_comparison(self.historical, source)
        self.assertEqual([], comparison["manifest_validation"]["unexpected_changes"])
        self.assertTrue(comparison["manifest_validation"]["content_compared"])
        self.assertEqual(["m51A-2", "m51A-3"], [item["message_id"] for item in comparison["additions"]])
        self.assertEqual(["m70", "m71"], [item["message_id"] for item in comparison["removals"]])
        self.assertEqual(85, len(comparison["unchanged"]))
        self.assertEqual(
            ["option_b_specific_bridge", "limit_received_without_overwriting", "sandra_uncertainty"],
            [item["revision_id"] for item in comparison["replacements"]],
        )
        stored = json.loads(N2_COMPARISON_PATH.read_text(encoding="utf-8"))
        self.assertEqual(comparison, stored)

        changed = copy.deepcopy(source)
        changed["pre_choice_messages"][1]["text"] += " !"
        self.assertIn("N2_UNLISTED_NARRATIVE_CHANGE", {issue.code for issue in validate_n2_manifest(self.historical, changed)})

        reordered = copy.deepcopy(source)
        reordered["pre_choice_messages"][1], reordered["pre_choice_messages"][2] = (
            reordered["pre_choice_messages"][2],
            reordered["pre_choice_messages"][1],
        )
        self.assertIn("N2_MESSAGE_ORDER_INVALID", {issue.code for issue in validate_n2_manifest(self.historical, reordered)})

    def test_choice_exits_are_distinct_and_converge_naturally_at_m53(self):
        draft = self.workspace["draft"]
        by_id = {message["message_id"]: message for message in draft["messages"]}
        self.assertEqual("m53", draft["choice"]["converge_at_message_id"])
        self.assertEqual(
            ["m47A", "m48A", "m49A", "m50A", "m51A", "m51A-2", "m51A-3"],
            draft["choice"]["options"][0]["reception_message_ids"],
        )
        self.assertEqual(
            ["m47B", "m48B", "m49B", "m50B", "m51B", "m52B"],
            draft["choice"]["options"][1]["reception_message_ids"],
        )
        self.assertEqual("assez", by_id["m51A-3"]["text"])
        self.assertEqual("Pas complètement", by_id["m52B"]["text"])
        self.assertIsNone(by_id["m53"]["reply_to"])
        self.assertEqual("m67", by_id["m72"]["reply_to"])
        self.assertEqual("m78", by_id["m79"]["reply_to"])

    def test_old_convergence_and_replaced_sequences_are_absent(self):
        messages = self.workspace["draft"]["messages"]
        ids = {message["message_id"] for message in messages}
        texts = {message["text"] for message in messages}
        self.assertNotIn("m52", ids)
        self.assertTrue({"m68", "m69", "m70", "m71"}.isdisjoint(ids))
        old_texts = {
            "Je savais pas que j’étais en train de freiner",
            "tu vois",
            "ça c’était presque une bonne phrase",
            "Je la note",
            "surtout pas",
            "après tu vas la réutiliser",
            "Je recycle",
            "le reste reste le reste",
            "Très clair",
            "parfait",
        }
        self.assertTrue(old_texts.isdisjoint(texts))

    def test_counts_participants_photo_voice_and_consequences(self):
        report = validate_n2_revision(self.workspace)
        self.assertEqual("READY_WITH_WARNINGS", report["status"])
        self.assertEqual([], report["blocking_errors"])
        self.assertEqual({"SOURCE_REPETITION_REVIEW"}, self.codes(report, "warnings"))
        self.assertEqual(96, report["counts"]["stored_message_elements"])
        self.assertEqual(
            {"careful_warmth": 90, "ironic_withdrawal": 89},
            report["counts"]["playable_path_elements"],
        )
        trace = self.workspace["traceability_report"]
        self.assertEqual(["player", "sandra"], trace["participant_ids"])
        self.assertEqual("photo_sandra_cafe_blue_chairs", trace["media_trace"]["media_id"])
        self.assertFalse(trace["fact_trace"]["durable_effect"])
        self.assertFalse(trace["a6_export"])
        self.assertFalse(trace["runtime_wiring"])
        self.assertTrue(trace["voice_validation"]["sandra"]["compatible"])
        self.assertTrue(trace["voice_validation"]["player"]["compatible"])
        self.assertFalse(trace["voice_validation"]["marie"]["compatible"])
        self.assertFalse(trace["voice_validation"]["mathilde"]["compatible"])

    def test_human_reading_covers_required_transitions_and_repetitions_without_score(self):
        blind = N2_BLIND_READING_PATH.read_text(encoding="utf-8")
        review = N2_HUMAN_REVIEW_PATH.read_text(encoding="utf-8")
        dialogue, questionnaire = blind.split("## Fiche humaine", 1)
        self.assertNotIn("Sandra", dialogue)
        self.assertNotIn("Player", dialogue)
        self.assertIn("Aucune notation automatique", questionnaire)
        for marker in (
            "m51A-3 → m53",
            "m52B → m53",
            "m64–m67",
            "m67 → m72",
            "m75–m78",
            "m78 → m79",
            "je sais",
            "D’accord",
            "sans promesse",
            "pas complètement",
        ):
            self.assertIn(marker, review)
        self.assertNotIn("automatic_" + "sco" + "re", (blind + review).casefold())
        self.assertEqual(render_editorial_blind_reading(self.workspace), blind)
        self.assertEqual(render_editorial_human_review(self.workspace, self.workspace["decision"]), review)

    def test_decision_uses_only_n2_statuses_and_never_auto_approves_canon(self):
        decision = self.workspace["decision"]
        self.assertEqual(
            {"NEEDS_NARRATIVE_REVISION", "READY_FOR_FINAL_CANON_REVIEW", "REJECTED"},
            N2_REVIEW_STATUSES,
        )
        self.assertEqual("READY_FOR_FINAL_CANON_REVIEW", decision["status"])
        self.assertEqual("FINAL_CANON_REVIEW", decision["decision"])
        self.assertNotEqual("CANON_APPROVED", decision["status"])
        self.assertEqual(editorial_decision_fingerprint(decision), decision["decision_fingerprint"])
        self.assertEqual([], validate_n2_decision(self.workspace, decision))

        invalid = copy.deepcopy(decision)
        invalid["status"] = "CANON_APPROVED"
        invalid["decision_fingerprint"] = editorial_decision_fingerprint(invalid)
        self.assertIn("CANON_REVIEW_STATUS_UNKNOWN", {issue.code for issue in validate_n2_decision(self.workspace, invalid)})

    def test_json_library_cli_smokes_and_mutations(self):
        library = validate_n2_json_library()
        self.assertTrue(library["ok"])
        self.assertEqual(SOURCE_SHA256, library["source_content_sha256"])
        smoke = run_n2_smoke()
        self.assertTrue(smoke["ok"])
        self.assertFalse(smoke["a6_export"])
        self.assertFalse(smoke["runtime_wiring"])
        for command in ("validate-n2", "n2-review", "n2-blind", "n2-smoke"):
            completed = subprocess.run(
                [sys.executable, str(TOOL), command],
                cwd=ROOT,
                text=True,
                encoding="utf-8",
                capture_output=True,
                check=False,
            )
            self.assertEqual(0, completed.returncode, completed.stderr)

    def test_all_n2_json_is_valid_and_no_game_a6_a1_or_forbidden_mechanism_is_added(self):
        json_paths = [
            N2_SOURCE_PATH,
            N2_PROVENANCE_PATH,
            N2_PLAN_PATH,
            N2_DRAFT_PATH,
            N2_VALIDATION_PATH,
            N2_COMPARISON_PATH,
            N2_TRACEABILITY_PATH,
            N2_DECISION_PATH,
        ]
        for path in json_paths:
            self.assertIsInstance(json.loads(path.read_text(encoding="utf-8")), dict)
        changed = subprocess.check_output(
            ["git", "diff", "--name-only", BASELINE], cwd=ROOT, text=True
        ).splitlines()
        self.assertFalse(any(path.startswith("game/") for path in changed))
        self.assertFalse(any("a6" in path.casefold() for path in changed))
        self.assertFalse(any("a1" in path.casefold() and "a11" not in path.casefold() for path in changed))
        structured = "\n".join(path.read_text(encoding="utf-8").casefold() for path in json_paths)
        for token in (
            "sco" + "re",
            "rank" + "ing",
            "prior" + "ity",
            "ran" + "domnumbergenerator",
            "ran" + "di(",
            "ran" + "df(",
            "sea" + "son1runtimeprovider",
            "lega" + "cy",
        ):
            self.assertNotIn(token, structured)


if __name__ == "__main__":
    unittest.main()
