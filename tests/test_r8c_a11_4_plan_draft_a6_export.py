import copy
import json
import re
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import tools.a11_plan_draft_export as a114
from tools.a11_plan_draft_export import (
    A114ApprovalError,
    FORMAT_COMPOSITE_APPROVAL,
    FORMAT_PROJECTION_REPORT,
    REVIEW_QUESTIONS,
    build_projection_report,
    composite_approval_fingerprint,
    default_paths,
    export_a6,
    load_workspace,
    render_human_review,
    run_smoke,
    validate_approval,
    validate_composite_approval_format,
    validate_draft,
    validate_draft_format,
    validate_projection_report_format,
)


ROOT = Path(__file__).resolve().parents[1]
A6_FIXTURE = (
    ROOT
    / "game/data/narrative_scenes/r8c_a11_4_sandra_recontact_after_silence_export.json"
)


class R8CA114PlanDraftA6ExportTests(unittest.TestCase):
    def setUp(self):
        self.workspace = load_workspace(**default_paths())

    def codes(self, report, field="blocking_errors"):
        return {issue["code"] for issue in report[field]}

    def read(self, relative):
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_expected_files_and_minimal_new_formats_exist(self):
        expected = [
            "tools/a11_plan_draft_export.py",
            "narrative_tool/a11/drafting/sandra_recontact_after_silence.draft.json",
            "narrative_tool/a11/drafting/sandra_recontact_after_silence.validation_report.json",
            "narrative_tool/a11/drafting/sandra_recontact_after_silence.composite_approval.json",
            "narrative_tool/a11/drafting/sandra_recontact_after_silence.human_review.md",
            "narrative_tool/a11/drafting/sandra_recontact_after_silence.projection_report.json",
            "game/data/narrative_scenes/r8c_a11_4_sandra_recontact_after_silence_export.json",
            "game/tests/R8CA114PlanDraftA6ExportSmokeTest.gd",
            "game/tests/R8CA114PlanDraftA6ExportSmokeTest.tscn",
            "docs/architecture/R8C_A11_4_PLAN_BROUILLON_EXPORT_A6_TEST.md",
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).exists()])
        self.assertEqual("R8C_A11_DIALOGUE_DRAFT", self.workspace["draft"]["format"])
        self.assertEqual(2, self.workspace["draft"]["version"])
        self.assertEqual(FORMAT_COMPOSITE_APPROVAL, self.workspace["approval"]["format"])
        self.assertEqual(FORMAT_PROJECTION_REPORT, self.workspace["projection_report"]["format"])

    def test_all_a114_formats_are_closed_and_versioned(self):
        validators = [
            (validate_draft_format, self.workspace["draft"]),
            (validate_composite_approval_format, self.workspace["approval"]),
            (validate_projection_report_format, self.workspace["projection_report"]),
        ]
        for validator, document in validators:
            self.assertEqual([], validator(document))
            mutant = copy.deepcopy(document)
            mutant["unexpected"] = True
            self.assertIn("CLOSED_SCHEMA_MISMATCH", {issue.code for issue in validator(mutant)})
            old = copy.deepcopy(document)
            old["version"] = 0
            self.assertIn("VERSION_UNKNOWN", {issue.code for issue in validator(old)})
            for invalid_version in (True, float(document["version"])):
                mutant = copy.deepcopy(document)
                mutant["version"] = invalid_version
                self.assertIn(
                    "VERSION_UNKNOWN",
                    {issue.code for issue in validator(mutant)},
                )

    def test_draft_has_complete_traceability_texture_and_no_media(self):
        draft = self.workspace["draft"]
        messages = draft["messages"]
        self.assertEqual(60, len(messages))
        self.assertEqual({"player", "sandra"}, {message["speaker_id"] for message in messages})
        self.assertEqual(7, len({message["beat_id"] for message in messages}))
        self.assertEqual(4, len({message["burst_id"] for message in messages if message["burst_id"]}))
        self.assertEqual(7, sum(message["strength"] == "WEAK" for message in messages))
        for message in messages:
            for field in (
                "message_id",
                "speaker_id",
                "beat_id",
                "objective_actor_id",
                "conversation_move",
                "local_state",
                "burst_id",
                "text",
                "reply_to",
            ):
                self.assertIn(field, message)
            self.assertTrue(message["fact_refs"])
            self.assertEqual("TEXT", message["kind"])
            self.assertIsNone(message["media"])
        report = validate_draft(self.workspace)
        self.assertEqual("READY", report["status"])
        self.assertEqual([], report["blocking_errors"])
        self.assertEqual([], report["warnings"])

    def test_draft_uses_only_the_approved_cinema_hook_without_date_or_proper_name(self):
        corpus = "\n".join(message["text"].casefold() for message in self.workspace["draft"]["messages"])
        self.assertNotIn("palace", corpus)
        self.assertNotIn("vendredi", corpus)
        self.assertIn("cinéma", corpus)
        self.assertIn("sans date", self.workspace["planning"]["plan"]["maximum_change"]["description"])

    def test_all_seven_approved_beats_are_realized_and_ticket_keeps_a_function(self):
        plan = self.workspace["planning"]["plan"]
        draft = self.workspace["draft"]
        expected = [beat["beat_id"] for beat in plan["beats"]]
        actual = list(dict.fromkeys(message["beat_id"] for message in draft["messages"]))
        self.assertEqual(expected, actual)
        ticket_beats = {
            message["beat_id"]
            for message in draft["messages"]
            if "sandra_folded_ticket" in message["fact_refs"]
        }
        self.assertGreater(len(ticket_beats), 1)
        self.assertIn("sandra_test", ticket_beats)
        self.assertIn("protective_exit", ticket_beats)

    def test_choice_realizes_two_attitudes_with_distinct_receptions_then_converges(self):
        draft_choice = self.workspace["draft"]["choice"]
        plan_choice = self.workspace["planning"]["plan"]["choice"]
        self.assertEqual(
            [option["option_id"] for option in plan_choice["options"]],
            [option["option_id"] for option in draft_choice["options"]],
        )
        self.assertEqual(
            ["Parce que l'autre soir a compté.", "Parce que ce ticket méritait mieux."],
            [option["formulation"] for option in draft_choice["options"]],
        )
        self.assertEqual("m45", draft_choice["converge_at_message_id"])
        reception_sets = [set(option["reception_message_ids"]) for option in draft_choice["options"]]
        self.assertTrue(reception_sets[0].isdisjoint(reception_sets[1]))
        self.assertEqual([], validate_draft(self.workspace)["blocking_errors"])

    def test_foreign_fact_direct_declaration_acquired_meeting_and_media_are_refused(self):
        mutations = []
        foreign_fact = copy.deepcopy(self.workspace)
        foreign_fact["draft"]["messages"][0]["fact_refs"] = ["marie_missed_commitment"]
        mutations.append((foreign_fact, "FACT_NOT_AUTHORIZED"))
        declaration = copy.deepcopy(self.workspace)
        declaration["draft"]["messages"][0]["text"] = "Je t'aime."
        mutations.append((declaration, "DIRECT_ROMANTIC_DECLARATION"))
        meeting = copy.deepcopy(self.workspace)
        meeting["draft"]["messages"][49]["text"] = "On se voit vendredi."
        mutations.append((meeting, "MEETING_PRESENTED_AS_ACQUIRED"))
        media = copy.deepcopy(self.workspace)
        media["draft"]["messages"][0]["kind"] = "IMAGE"
        media["draft"]["messages"][0]["media"] = {"kind": "PHOTO"}
        mutations.append((media, "MEDIA_FORBIDDEN"))
        for mutant, expected_code in mutations:
            self.assertIn(expected_code, self.codes(validate_draft(mutant)))

    def test_all_authored_choice_text_and_common_paraphrases_are_refused(self):
        cases = (
            ("Je suis amoureuse de toi.", "DIRECT_ROMANTIC_DECLARATION"),
            ("Vendredi à 20 h devant le Palace, alors.", "MEETING_PRESENTED_AS_ACQUIRED"),
            ("Dis-moi ce que tu ressens.", "AFFECTIVE_RESPONSE_DEMANDED"),
        )
        for formulation, expected_code in cases:
            mutant = copy.deepcopy(self.workspace)
            mutant["draft"]["choice"]["options"][0]["formulation"] = formulation
            self.assertIn(expected_code, self.codes(validate_draft(mutant)))

    def test_malformed_draft_returns_blocked_report_without_semantic_dereference(self):
        for mutation in ("root", "message"):
            mutant = copy.deepcopy(self.workspace)
            if mutation == "root":
                del mutant["draft"]["messages"]
            else:
                del mutant["draft"]["messages"][0]["fact_refs"]
            report = validate_draft(mutant)
            self.assertEqual("BLOCKED", report["status"])
            self.assertIn("CLOSED_SCHEMA_MISMATCH", self.codes(report))

    def test_validation_uses_only_fingerprinted_sandra_sources(self):
        with patch.object(a114, "load_calibration_case", side_effect=AssertionError("unexpected I/O")):
            self.assertEqual("READY", validate_draft(self.workspace)["status"])

    def test_beat_order_and_choice_branch_lifecycle_are_blocking_invariants(self):
        reordered = copy.deepcopy(self.workspace)
        reordered["draft"]["messages"][0]["beat_id"], reordered["draft"]["messages"][8]["beat_id"] = (
            reordered["draft"]["messages"][8]["beat_id"],
            reordered["draft"]["messages"][0]["beat_id"],
        )
        self.assertIn("BEAT_ORDER_REGRESSION", self.codes(validate_draft(reordered)))

        invalid_branch = copy.deepcopy(self.workspace)
        invalid_branch["draft"]["messages"][-1]["branch"] = "BOGUS"
        report = validate_draft(invalid_branch)
        self.assertIn("MESSAGE_BRANCH_UNKNOWN", self.codes(report))
        self.assertIn("MESSAGE_BRANCH_OUTSIDE_CHOICE", self.codes(report))

    def test_choice_without_reception_is_refused_and_cosmetic_reception_warned(self):
        missing = copy.deepcopy(self.workspace)
        missing["draft"]["choice"]["options"][0]["reception_message_ids"] = []
        self.assertIn("STRING_LIST_REQUIRED", self.codes(validate_draft(missing)))

        cosmetic = copy.deepcopy(self.workspace)
        messages = {message["message_id"]: message for message in cosmetic["draft"]["messages"]}
        first_ids = cosmetic["draft"]["choice"]["options"][0]["reception_message_ids"]
        second_ids = cosmetic["draft"]["choice"]["options"][1]["reception_message_ids"]
        for first_id, second_id in zip(first_ids, second_ids):
            messages[second_id]["text"] = messages[first_id]["text"]
            messages[second_id]["conversation_move"] = messages[first_id]["conversation_move"]
        self.assertIn("CHOICE_RECEPTION_COSMETIC", self.codes(validate_draft(cosmetic), "warnings"))

    def test_absent_weak_messages_and_bursts_are_independent_warnings(self):
        no_weak = copy.deepcopy(self.workspace)
        for message in no_weak["draft"]["messages"]:
            message["strength"] = "NORMAL"
        report = validate_draft(no_weak)
        self.assertIn("WEAK_MESSAGES_ABSENT", self.codes(report, "warnings"))
        self.assertNotIn("BURSTS_ABSENT", self.codes(report, "warnings"))

        no_bursts = copy.deepcopy(self.workspace)
        for message in no_bursts["draft"]["messages"]:
            message["burst_id"] = None
        report = validate_draft(no_bursts)
        self.assertIn("BURSTS_ABSENT", self.codes(report, "warnings"))
        self.assertNotIn("WEAK_MESSAGES_ABSENT", self.codes(report, "warnings"))

    def test_editorial_warning_catalog_remains_independent_and_non_aggregated(self):
        cases = []
        explanatory = copy.deepcopy(self.workspace)
        for index, prefix in enumerate(("Ce que je veux dire", "Pour être clair", "Autrement dit")):
            explanatory["draft"]["messages"][index]["text"] = f"{prefix} {index}."
        cases.append((explanatory, "TOO_MANY_EXPLANATORY_MESSAGES"))

        humor = copy.deepcopy(self.workspace)
        for index in range(4):
            humor["draft"]["messages"][index]["text"] = f"Je plaisante, version {index}."
        cases.append((humor, "HUMOR_MECHANICAL"))

        romantic_only = copy.deepcopy(self.workspace)
        for index, message in enumerate(romantic_only["draft"]["messages"]):
            message["text"] = f"Attirance, sentiments, romantique {index}."
        cases.append((romantic_only, "ROMANTIC_SUBTEXT_ONLY_TENSION"))

        perfect = copy.deepcopy(self.workspace)
        perfect["draft"]["messages"][-1]["text"] = "Tout est réglé."
        cases.append((perfect, "EXIT_TOO_PERFECT"))

        theatrical = copy.deepcopy(self.workspace)
        theatrical["draft"]["messages"][2]["text"] = "Le destin, donc."
        theatrical["draft"]["messages"][5]["text"] = "Quelle tragédie."
        cases.append((theatrical, "SANDRA_THEATRICAL"))

        available = copy.deepcopy(self.workspace)
        available["draft"]["messages"][2]["text"] = "Je suis toujours disponible."
        cases.append((available, "SANDRA_UNRESERVED_AVAILABILITY"))

        perfect_player = copy.deepcopy(self.workspace)
        perfect_player["draft"]["messages"][0]["text"] = (
            "Je voulais simplement respecter exactement la situation."
        )
        cases.append((perfect_player, "PLAYER_TOO_PERFECT"))

        weak_reception = copy.deepcopy(self.workspace)
        weak_reception["draft"]["choice"]["options"][0]["reception_message_ids"] = ["m37"]
        cases.append((weak_reception, "CHOICE_RECEPTION_WEAK"))

        for mutant, expected_code in cases:
            report = validate_draft(mutant)
            self.assertIn(expected_code, self.codes(report, "warnings"))
            self.assertNotIn("quality", report)
            self.assertNotIn("aggregate", report)

    def test_affective_demand_and_immediate_seduction_are_blocked(self):
        demanded = copy.deepcopy(self.workspace)
        demanded["draft"]["messages"][0]["text"] = "Dis-moi ce que tu ressens."
        self.assertIn("AFFECTIVE_RESPONSE_DEMANDED", self.codes(validate_draft(demanded)))

        seductive = copy.deepcopy(self.workspace)
        seductive["draft"]["messages"][2]["text"] = "Embrasse-moi maintenant."
        self.assertIn("IMMEDIATE_SEDUCTION_FORBIDDEN", self.codes(validate_draft(seductive)))

    def test_plan_contract_register_draft_choice_and_projection_mutations_invalidate_approval(self):
        fingerprint = composite_approval_fingerprint(self.workspace)
        mutants = []
        changed_plan = copy.deepcopy(self.workspace)
        changed_plan["planning"]["plan"]["title"] += " !"
        mutants.append(changed_plan)
        changed_contract = copy.deepcopy(self.workspace)
        changed_contract["character_contract"]["role"] += " !"
        mutants.append(changed_contract)
        changed_register = copy.deepcopy(self.workspace)
        changed_register["relationship_register"]["relationship"]["nature"] += " !"
        mutants.append(changed_register)
        changed_bubble = copy.deepcopy(self.workspace)
        changed_bubble["draft"]["messages"][0]["text"] += " !"
        mutants.append(changed_bubble)
        changed_choice = copy.deepcopy(self.workspace)
        changed_choice["draft"]["choice"]["options"][0]["formulation"] += " !"
        mutants.append(changed_choice)
        changed_projection = copy.deepcopy(self.workspace)
        changed_projection["approval"]["projection_config"]["duration_minutes"] += 1
        mutants.append(changed_projection)
        changed_report = copy.deepcopy(self.workspace)
        changed_report["validation_report"]["status"] = "READY_WITH_WARNINGS"
        changed_report["validation_report"]["warnings"] = [
            {"code": "TEST", "path": "test", "message": "test"}
        ]
        mutants.append(changed_report)
        for mutant in mutants:
            self.assertNotEqual(fingerprint, composite_approval_fingerprint(mutant))
            self.assertIn("APPROVAL_FINGERPRINT_STALE", {issue.code for issue in validate_approval(mutant)})
        with patch.object(a114, "VALIDATOR_VERSION", "a11-plan-draft-validator-next"):
            self.assertNotEqual(fingerprint, composite_approval_fingerprint(self.workspace))

    def test_export_requires_exact_human_status_report_revision_and_fingerprint(self):
        generated = validate_draft(self.workspace)
        self.assertEqual(self.workspace["validation_report"], generated)
        for mutation in ("status", "revision", "fingerprint"):
            mutant = copy.deepcopy(self.workspace)
            if mutation == "status":
                mutant["approval"]["human_review"]["status"] = "DRAFT"
                mutant["approval"]["approval_fingerprint"] = composite_approval_fingerprint(mutant)
            elif mutation == "revision":
                mutant["draft"]["revision"] = "rev_02"
            else:
                mutant["approval"]["approval_fingerprint"] = "stale"
            with self.assertRaises(A114ApprovalError):
                export_a6(mutant)
        bundle, projection = export_a6(self.workspace)
        self.assertEqual(json.loads(A6_FIXTURE.read_text(encoding="utf-8")), bundle)
        self.assertEqual(self.workspace["projection_report"], projection)

    def test_invalid_a6_projection_and_collapsed_receptions_block_export(self):
        mutations = []
        invalid_nature = copy.deepcopy(self.workspace)
        invalid_nature["approval"]["projection_config"]["nature"] = "BOGUS"
        mutations.append((invalid_nature, "A6_ENUM_INVALID"))
        invalid_id = copy.deepcopy(self.workspace)
        invalid_id["approval"]["projection_config"]["variant_id"] = "Upper Case"
        mutations.append((invalid_id, "A6_ID_INVALID"))
        invalid_window = copy.deepcopy(self.workspace)
        invalid_window["approval"]["projection_config"]["opening_time"] = "23:00"
        invalid_window["approval"]["projection_config"]["closing_time"] = "20:00"
        mutations.append((invalid_window, "A6_TEMPORAL_WINDOW_INVALID"))
        collapsed = copy.deepcopy(self.workspace)
        mappings = collapsed["approval"]["projection_config"]["choice_mappings"]
        mappings[1]["signal"] = mappings[0]["signal"]
        mappings[1]["reception_interpretation"] = mappings[0]["reception_interpretation"]
        mutations.append((collapsed, "A6_CHOICE_MAPPING_NOT_DISTINCT"))
        for mutant, expected_code in mutations:
            mutant["approval"]["approval_fingerprint"] = composite_approval_fingerprint(mutant)
            self.assertIn(expected_code, {issue.code for issue in validate_approval(mutant)})
            with self.assertRaises(A114ApprovalError):
                export_a6(mutant)

    def test_human_review_has_exact_status_questions_and_deterministic_render(self):
        review = self.workspace["approval"]["human_review"]
        self.assertEqual("APPROVED_FOR_A6_TEST_EXPORT", review["status"])
        self.assertEqual(
            [(question_id, question, response) for question_id, question, response in REVIEW_QUESTIONS],
            [
                (check["question_id"], check["question"], check["response"])
                for check in review["checks"]
            ],
        )
        checked = self.read(
            "narrative_tool/a11/drafting/sandra_recontact_after_silence.human_review.md"
        )
        self.assertEqual(checked, render_human_review(self.workspace))
        self.assertEqual(10, checked.count("- [x]"))

    def test_a6_projection_is_closed_local_and_explicit_about_unrepresentable_authoring_data(self):
        bundle, report = export_a6(self.workspace)
        self.assertEqual({"format", "version", "definitions"}, set(bundle))
        entry = bundle["definitions"][0]
        self.assertEqual(
            "r8c_a11_4_sandra_recontact_after_silence_definition",
            entry["scene_definition_id"],
        )
        self.assertEqual("sandra_recontact_after_silence_test", entry["variant_id"])
        definition = entry["definition"]
        self.assertEqual(
            ["player", "sandra"],
            [participant["personnage_id"] for participant in definition["participants_requis"]],
        )
        self.assertEqual(2, len(definition["choix"]))
        self.assertEqual(2, len(definition["resolutions"]))
        self.assertEqual(
            {
                "acknowledge_importance_without_claim_reception": "importance_entendue_rythme_protege",
                "maintain_light_indirectness_reception": "detour_accepte_portee_ambigue",
            },
            {
                resolution_id: resolution["interpretation"]
                for resolution_id, resolution in definition["resolutions"].items()
            },
        )
        for resolution in definition["resolutions"].values():
            self.assertEqual("LOCALE", resolution["portee_micro_signal"])
            self.assertEqual("NON_PERSISTANTE", resolution["reception"])
            self.assertEqual([], resolution["faits_relationnels"])
            self.assertEqual("RETOUR_NOYAU_COMMUN", resolution["convergence"])
        self.assertNotIn("messages", definition)
        self.assertNotIn("approval_fingerprint", definition)
        sources = {item["source"] for item in report["unrepresentable_elements"]}
        self.assertIn("draft.messages", sources)
        self.assertIn("static validation creates no A5 instance", report["preserved_invariants"])
        self.assertEqual(report, build_projection_report(self.workspace, bundle))

    def test_fixture_is_not_referenced_by_portrait_or_season_one_runtime(self):
        token = "r8c_a11_4_sandra_recontact_after_silence_export"
        runtime_files = list((ROOT / "game/scripts").rglob("*.gd"))
        runtime_files.extend((ROOT / "game/scenes/portrait").rglob("*.tscn"))
        references = [
            str(path.relative_to(ROOT))
            for path in runtime_files
            if token in path.read_text(encoding="utf-8")
        ]
        self.assertEqual([], references)
        source = self.read("tools/a11_plan_draft_export.py")
        for forbidden in (
            "creer" + "_instance",
            "Persistent" + "SceneRegistry",
            "Scene" + "Instance.gd",
            "Season" + "1RuntimeProvider",
            "Portrait" + "Main.tscn",
        ):
            self.assertNotIn(forbidden, source)

    def test_lot_has_no_numeric_selection_random_ranking_priority_or_legacy_connection(self):
        paths = [
            "tools/a11_plan_draft_export.py",
            "narrative_tool/a11/drafting/sandra_recontact_after_silence.draft.json",
            "narrative_tool/a11/drafting/sandra_recontact_after_silence.validation_report.json",
            "narrative_tool/a11/drafting/sandra_recontact_after_silence.composite_approval.json",
            "narrative_tool/a11/drafting/sandra_recontact_after_silence.projection_report.json",
            "game/data/narrative_scenes/r8c_a11_4_sandra_recontact_after_silence_export.json",
            "game/tests/R8CA114PlanDraftA6ExportSmokeTest.gd",
        ]
        sources = "\n".join(self.read(path) for path in paths).casefold()
        forbidden = [
            "sco" + "re",
            "rank" + "ing",
            "prior" + "ity",
            "priorit" + "é",
            "random" + "numbergenerator",
            "randi(",
            "randf(",
            "route" + "_points",
            "consent" + "_score",
            "attraction" + "_score",
        ]
        for token in forbidden:
            self.assertNotIn(token, sources, token)
        self.assertEqual([], re.findall(r"(?i)\bhas" + r"ard\b", sources))

    def test_cli_commands_and_smoke_cover_checked_fixtures(self):
        result = run_smoke()
        self.assertTrue(result["ok"])
        self.assertEqual(60, result["bubble_count"])
        self.assertEqual(4, result["burst_count"])
        self.assertEqual(7, result["weak_message_count"])
        for command in ("validate-json", "validate", "review", "export", "smoke"):
            arguments = [sys.executable, "tools/a11_plan_draft_export.py", command]
            if command == "export":
                arguments.append("--dry-run")
            completed = subprocess.run(
                arguments,
                cwd=ROOT,
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(0, completed.returncode, completed.stderr)

    def test_cli_writes_bundle_and_projection_as_an_explicit_pair(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "bundle.json"
            projection = Path(directory) / "projection.json"
            completed = subprocess.run(
                [
                    sys.executable,
                    "tools/a11_plan_draft_export.py",
                    "export",
                    "--output",
                    str(output),
                    "--projection-report-output",
                    str(projection),
                ],
                cwd=ROOT,
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(0, completed.returncode, completed.stderr)
            self.assertEqual(
                json.loads(A6_FIXTURE.read_text(encoding="utf-8")),
                json.loads(output.read_text(encoding="utf-8")),
            )
            self.assertEqual(
                self.workspace["projection_report"],
                json.loads(projection.read_text(encoding="utf-8")),
            )

            incomplete = subprocess.run(
                [
                    sys.executable,
                    "tools/a11_plan_draft_export.py",
                    "export",
                    "--output",
                    str(output),
                ],
                cwd=ROOT,
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(1, incomplete.returncode)
            self.assertIn("both export output paths are required together", incomplete.stderr)


if __name__ == "__main__":
    unittest.main()
