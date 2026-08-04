import copy
import json
import re
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import tools.a11_authoring_workshop as a11
from tools.a11_authoring_workshop import (
    A11ApprovalError,
    A11ValidationError,
    FORMAT_CHARACTER,
    FORMAT_DRAFT,
    FORMAT_PLAN,
    FORMAT_RELATIONSHIPS,
    FORMAT_REPORT,
    ROOT_KEYS,
    approval_fingerprint,
    approve_report,
    compile_context,
    default_paths,
    export_a6,
    load_workspace,
    run_smoke,
    validate_character,
    validate_draft,
    validate_draft_format,
    validate_plan,
    validate_relationships,
    validate_report_format,
    validate_voice_sample,
)


ROOT = Path(__file__).resolve().parents[1]
A6_FIXTURE = ROOT / "game/data/narrative_scenes/r8c_a11_sandra_last_lunch_export.json"


class R8CA11AuthoringWorkshopTests(unittest.TestCase):
    def setUp(self):
        self.paths = default_paths()
        self.workspace = load_workspace(**self.paths)

    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_expected_files_and_exactly_five_closed_versioned_formats(self):
        expected = [
            "tools/a11_authoring_workshop.py",
            "narrative_tool/a11/fixtures/character_sandra.json",
            "narrative_tool/a11/fixtures/character_marie.json",
            "narrative_tool/a11/fixtures/character_player.json",
            "narrative_tool/a11/fixtures/relationship_register.json",
            "narrative_tool/a11/fixtures/scene_plan_a11_sandra_last_lunch_detail.json",
            "narrative_tool/a11/fixtures/dialogue_draft_a11_sandra_last_lunch_detail.json",
            "narrative_tool/a11/fixtures/dialogue_draft_invalid.json",
            "narrative_tool/a11/fixtures/validation_report_a11_sandra_last_lunch_detail.json",
            "game/data/narrative_scenes/r8c_a11_sandra_last_lunch_export.json",
            "game/tests/R8CA11AuthoringExportSmokeTest.gd",
            "game/tests/R8CA11AuthoringExportSmokeTest.tscn",
            "docs/architecture/R8C_A11_ATELIER_AUTEUR_ASSISTE_VERTICAL_SLICE.md",
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).exists()])
        self.assertEqual(
            {FORMAT_CHARACTER, FORMAT_RELATIONSHIPS, FORMAT_PLAN, FORMAT_DRAFT, FORMAT_REPORT},
            set(ROOT_KEYS),
        )
        validators_and_documents = [
            (validate_character, self.workspace["characters"][0]),
            (validate_relationships, self.workspace["relationships"]),
            (validate_plan, self.workspace["plan"]),
            (validate_draft_format, self.workspace["draft"]),
            (validate_report_format, self.workspace["report"]),
        ]
        for validator, document in validators_and_documents:
            self.assertEqual([], validator(document))
            mutant = copy.deepcopy(document)
            mutant["unexpected"] = True
            self.assertIn("CLOSED_SCHEMA_MISMATCH", {issue.code for issue in validator(mutant)})
            old_version = copy.deepcopy(document)
            old_version["version"] = 0
            self.assertIn("VERSION_UNKNOWN", {issue.code for issue in validator(old_version)})

    def test_atomic_loader_rejects_cross_references_without_partial_workspace(self):
        bad_plan = copy.deepcopy(self.workspace["plan"])
        bad_plan["participant_ids"].append("unknown_character")
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "bad_plan.json"
            path.write_text(json.dumps(bad_plan, ensure_ascii=False), encoding="utf-8")
            bad_paths = dict(self.paths)
            bad_paths["plan_path"] = path
            with self.assertRaises(A11ValidationError) as caught:
                load_workspace(**bad_paths)
        self.assertIn("PLAN_CHARACTER_UNKNOWN", {issue.code for issue in caught.exception.issues})

    def test_generation_context_is_deterministic_and_input_order_independent(self):
        first = compile_context(self.workspace)
        reversed_paths = dict(self.paths)
        reversed_paths["character_paths"] = list(reversed(self.paths["character_paths"]))
        second = compile_context(load_workspace(**reversed_paths))
        self.assertEqual(first, second)
        self.assertIn("a11_sandra_last_lunch_detail", first)
        self.assertIn("active_participants=sandra,player", first)
        self.assertIn('"character_id":"marie"', first)
        self.assertIn('"relation_id":"marie_player"', first)
        self.assertIn('"relation_id":"sandra_marie"', first)
        self.assertNotIn("provider", first.casefold())

    def test_known_and_unknown_facts_are_enforced_by_explicit_identity(self):
        valid = validate_draft(self.workspace)
        self.assertEqual([], valid["blocking_errors"])
        invalid_paths = default_paths(invalid=True)
        invalid = validate_draft(load_workspace(**invalid_paths))
        codes = {issue["code"] for issue in invalid["blocking_errors"]}
        self.assertIn("FACT_EXPLICITLY_UNKNOWN", codes)
        self.assertIn("DRAFT_BUBBLE_COUNT_BLOCKING", codes)

    def test_sandra_prototype_has_exact_content_bounds_bursts_and_weak_messages(self):
        draft = self.workspace["draft"]
        plan = self.workspace["plan"]
        self.assertEqual("a11_sandra_last_lunch_detail", plan["plan_id"])
        self.assertEqual(["sandra", "player"], plan["participant_ids"])
        self.assertEqual(50, len(draft["messages"]))
        self.assertEqual({"sandra", "player"}, {message["speaker_id"] for message in draft["messages"]})
        self.assertGreaterEqual(sum(message["burst_id"] is not None for message in draft["messages"]), 6)
        self.assertGreaterEqual(sum(message["strength"] == "WEAK" for message in draft["messages"]), 4)
        corpus = "\n".join(message["text"] for message in draft["messages"])
        self.assertNotIn("Marie", corpus)
        for text in [
            "La petite étoile sur le bord",
            "Mais après c'était plus calme.",
            "Tu fais une élégie aux frites molles maintenant ?",
            "Retour à la vraie vie",
        ]:
            self.assertIn(text, corpus)
        sandra = next(character for character in self.workspace["characters"] if character["character_id"] == "sandra")
        marie = next(character for character in self.workspace["characters"] if character["character_id"] == "marie")
        self.assertNotEqual(sandra["voice"]["tone_markers"], marie["voice"]["tone_markers"])

    def test_anonymous_voice_samples_are_qualitatively_non_interchangeable(self):
        profiles = {character["character_id"]: character for character in self.workspace["characters"]}
        first_anonymous_sample = [
            "Cette photo du déjeuner est terrible.",
            "Le verre fêlé avait au moins plus d'allure que les frites froides.",
        ]
        second_anonymous_sample = [
            "Tu peux prendre du pain en rentrant ?",
            "J'ai posé le café à côté du sac de courses.",
        ]
        self.assertEqual([], validate_voice_sample(profiles["sandra"], first_anonymous_sample))
        self.assertEqual([], validate_voice_sample(profiles["marie"], second_anonymous_sample))
        self.assertIn(
            "VOICE_CONCRETE_ANCHOR_MISSING",
            {issue.code for issue in validate_voice_sample(profiles["sandra"], second_anonymous_sample)},
        )
        self.assertIn(
            "VOICE_CONCRETE_ANCHOR_MISSING",
            {issue.code for issue in validate_voice_sample(profiles["marie"], first_anonymous_sample)},
        )
        self.assertIn(
            "VOICE_FORBIDDEN_MOTIF",
            {issue.code for issue in validate_voice_sample(profiles["sandra"], ["Je t'aime."])},
        )
        self.assertIn(
            "VOICE_FORBIDDEN_MOTIF",
            {issue.code for issue in validate_voice_sample(profiles["marie"], ["Nos frites froides."])},
        )

    def test_choice_has_two_local_receptions_then_allowed_convergence(self):
        plan_options = {option["option_id"]: option for option in self.workspace["plan"]["choice"]["options"]}
        self.assertEqual({"careful_warmth", "ironic_withdrawal"}, set(plan_options))
        self.assertEqual("chaleur prudente", plan_options["careful_warmth"]["attitude"])
        self.assertEqual("retrait ironique", plan_options["ironic_withdrawal"]["attitude"])
        self.assertEqual("intriguée_touchée", plan_options["careful_warmth"]["sandra_local_state"])
        self.assertEqual("défensive_embarrassée", plan_options["ironic_withdrawal"]["sandra_local_state"])
        choice = self.workspace["draft"]["choice"]
        self.assertEqual(2, len(choice["options"]))
        self.assertEqual("m35", choice["converge_at_message_id"])
        self.assertEqual([], validate_draft(self.workspace)["blocking_errors"])

    def test_media_must_be_unique_linked_and_justified(self):
        report = validate_draft(self.workspace)
        self.assertNotIn("MEDIA_JUSTIFICATION_BLOCKING", {issue["code"] for issue in report["blocking_errors"]})
        mutant = copy.deepcopy(self.workspace)
        media_message = next(message for message in mutant["draft"]["messages"] if message["kind"] == "IMAGE")
        media_message["media"]["justification"] = "Décoration sans lien avec la scène."
        blocked = validate_draft(mutant)
        self.assertIn("MEDIA_JUSTIFICATION_BLOCKING", {issue["code"] for issue in blocked["blocking_errors"]})

    def test_style_warning_is_non_blocking_and_preserved_in_closed_report(self):
        report = validate_draft(self.workspace)
        self.assertEqual("READY_WITH_WARNINGS", report["status"])
        self.assertEqual([], report["blocking_errors"])
        self.assertEqual(["STYLE_LONG_BUBBLE"], [warning["code"] for warning in report["warnings"]])
        self.assertEqual([], validate_report_format(report))
        self.assertEqual(report["warnings"], self.workspace["report"]["warnings"])

    def test_export_refused_without_approval_and_accepted_for_exact_revision(self):
        report = validate_draft(self.workspace)
        with self.assertRaises(A11ApprovalError):
            export_a6(self.workspace, report)
        approved = approve_report(report, self.workspace, "human_reviewer")
        self.assertEqual("rev_01", approved["human_approval"]["draft_revision"])
        exported = export_a6(self.workspace, approved)
        self.assertEqual("R8C_A6_SCENE_LIBRARY", exported["format"])
        changed = copy.deepcopy(self.workspace)
        changed["draft"]["revision"] = "rev_02"
        with self.assertRaises(A11ApprovalError):
            export_a6(changed, approved)
        changed_plan = copy.deepcopy(self.workspace)
        changed_plan["plan"]["title"] += " — modifié"
        with self.assertRaises(A11ApprovalError):
            export_a6(changed_plan, approved)
        changed_character = copy.deepcopy(self.workspace)
        changed_character["characters"][0]["role"] += " — modifié"
        with self.assertRaises(A11ApprovalError):
            export_a6(changed_character, approved)
        changed_relationship = copy.deepcopy(self.workspace)
        changed_relationship["relationships"]["relations"][0]["kind"] += " — modifié"
        with self.assertRaises(A11ApprovalError):
            export_a6(changed_relationship, approved)
        with patch.object(a11, "VALIDATOR_VERSION", "a11-validator-next"):
            with self.assertRaises(A11ApprovalError):
                export_a6(self.workspace, approved)

    def test_a6_projection_matches_checked_fixture_and_closed_a3_shape(self):
        exported = export_a6(self.workspace, self.workspace["report"])
        checked = json.loads(A6_FIXTURE.read_text(encoding="utf-8"))
        self.assertEqual(checked, exported)
        self.assertEqual({"format", "version", "definitions"}, set(exported))
        entry = exported["definitions"][0]
        self.assertEqual({"scene_definition_id", "variant_id", "definition"}, set(entry))
        definition = entry["definition"]
        self.assertEqual(
            ["sandra", "player"],
            [participant["personnage_id"] for participant in definition["participants_requis"]],
        )
        self.assertEqual(2, len(definition["choix"]))
        self.assertEqual(2, len(definition["resolutions"]))
        for resolution in definition["resolutions"].values():
            self.assertEqual("LOCALE", resolution["portee_micro_signal"])
            self.assertEqual("NON_PERSISTANTE", resolution["reception"])
            self.assertEqual([], resolution["faits_relationnels"])
            self.assertEqual("RETOUR_NOYAU_COMMUN", resolution["convergence"])

    def test_approval_fingerprint_covers_all_editorial_inputs_and_validator(self):
        fingerprint = approval_fingerprint(self.workspace)
        self.assertEqual(fingerprint, self.workspace["report"]["approval_fingerprint"])
        mutations = []
        changed_draft = copy.deepcopy(self.workspace)
        changed_draft["draft"]["messages"][0]["text"] += "!"
        mutations.append(changed_draft)
        changed_plan = copy.deepcopy(self.workspace)
        changed_plan["plan"]["title"] += "!"
        mutations.append(changed_plan)
        changed_character = copy.deepcopy(self.workspace)
        changed_character["characters"][0]["role"] += "!"
        mutations.append(changed_character)
        changed_relationship = copy.deepcopy(self.workspace)
        changed_relationship["relationships"]["relations"][0]["kind"] += "!"
        mutations.append(changed_relationship)
        for mutant in mutations:
            self.assertNotEqual(fingerprint, approval_fingerprint(mutant))
        with patch.object(a11, "VALIDATOR_VERSION", "a11-validator-next"):
            self.assertNotEqual(fingerprint, approval_fingerprint(self.workspace))

    def test_documented_minimal_contract_names_fields_absences_reason_and_invariant(self):
        contract = self.read("docs/architecture/R8C_A11_ATELIER_AUTEUR_ASSISTE_VERTICAL_SLICE.md")
        self.assertIn("## A11.1 minimal contract", contract)
        for token in ["Inclus", "Délibérément absent", "Pourquoi", "Invariant protégé"]:
            self.assertIn(token, contract)

    def test_lot_has_no_runtime_connections_automatic_selection_or_numeric_evaluation(self):
        paths = [
            "tools/a11_authoring_workshop.py",
            "game/tests/R8CA11AuthoringExportSmokeTest.gd",
            "game/data/narrative_scenes/r8c_a11_sandra_last_lunch_export.json",
        ]
        paths.extend(
            str(path.relative_to(ROOT)).replace("\\", "/")
            for path in sorted((ROOT / "narrative_tool/a11/fixtures").glob("*.json"))
        )
        sources = "\n".join(self.read(path) for path in paths).casefold()
        forbidden = [
            "sco" + "re", "rank" + "ing", "prior" + "ity", "priorit" + "é",
            "random" + "numbergenerator", "randi(", "randf(", "season" + "1runtimeprovider",
            "portrait" + "main", "scripts/narrative_state", "scripts/runtime/season_1",
        ]
        for token in forbidden:
            self.assertNotIn(token, sources, token)
        self.assertEqual([], re.findall(r"(?i)\\bhas" + r"ard\\b", sources))

    def test_cli_smoke_exercises_invalid_fixture_and_checked_export(self):
        result = run_smoke()
        self.assertTrue(result["ok"])
        self.assertEqual(50, result["bubble_count"])
        self.assertIn("FACT_EXPLICITLY_UNKNOWN", result["invalid_error_codes"])
        command = subprocess.run(
            [sys.executable, "tools/a11_authoring_workshop.py", "smoke"],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(0, command.returncode, command.stderr)
        self.assertIn('"ok": true', command.stdout)


if __name__ == "__main__":
    unittest.main()
