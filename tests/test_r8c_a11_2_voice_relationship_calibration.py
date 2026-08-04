import copy
import json
import subprocess
import sys
import unittest
from pathlib import Path

from tools.a11_authoring_workshop import validate_character
from tools.a11_voice_calibration import (
    CALIBRATION_DIR,
    CASE_NAMES,
    FORMAT_RELATIONSHIP_CALIBRATION,
    FORMAT_VOICE_CALIBRATION_CASE,
    compile_minimal_context,
    cross_validate_library,
    load_case,
    run_smoke,
    validate_calibration_case,
    validate_compatibility,
    validate_json_library,
    validate_relationship_calibration,
)


ROOT = Path(__file__).resolve().parents[1]
DOC = ROOT / "docs/architecture/R8C_A11_2_BIBLIOTHEQUE_VOIX_CALIBRATION_RELATIONNELLE.md"
BLIND_DOSSIER = CALIBRATION_DIR / "dossier_lecture_aveugle.md"


class R8CA112VoiceRelationshipCalibrationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.workspaces = {name: load_case(name) for name in CASE_NAMES}

    def test_expected_offline_library_and_two_closed_extensions(self):
        expected = [
            ROOT / "tools/a11_voice_calibration.py",
            DOC,
            BLIND_DOSSIER,
        ]
        for name in CASE_NAMES:
            expected.extend(
                [
                    CALIBRATION_DIR / "contracts" / f"{name}.json",
                    CALIBRATION_DIR / "registers" / f"player_{name}.json",
                    CALIBRATION_DIR / "corpora" / f"{name}.json",
                ]
            )
        self.assertEqual([], [str(path) for path in expected if not path.is_file()])
        for workspace in self.workspaces.values():
            self.assertEqual([], validate_character(workspace["character"]))
            self.assertEqual([], validate_relationship_calibration(workspace["relationship"]))
            self.assertEqual([], validate_calibration_case(workspace["case"]))
            for validator, document in (
                (validate_relationship_calibration, workspace["relationship"]),
                (validate_calibration_case, workspace["case"]),
            ):
                mutant = copy.deepcopy(document)
                mutant["unexpected"] = True
                self.assertIn("CLOSED_SCHEMA_MISMATCH", {issue.code for issue in validator(mutant)})
                old = copy.deepcopy(document)
                old["version"] = 0
                self.assertIn("VERSION_UNKNOWN", {issue.code for issue in validator(old)})
        self.assertEqual(
            [FORMAT_RELATIONSHIP_CALIBRATION, FORMAT_VOICE_CALIBRATION_CASE],
            validate_json_library()["formats"],
        )

    def test_contracts_encode_the_required_character_distinctions(self):
        sandra = self.workspaces["sandra"]["character"]
        marie = self.workspaces["marie"]["character"]
        mathilde = self.workspaces["mathilde"]["character"]
        self.assertIn("antérieure à Marie", sandra["role"])
        self.assertIn("manque indirect", sandra["voice"]["tone_markers"])
        self.assertIn("séduction instantanée", sandra["voice"]["forbidden_moves"])
        self.assertIn("ancre du couple", marie["role"])
        self.assertIn("franchise quotidienne", marie["voice"]["tone_markers"])
        self.assertIn("pardon automatique", marie["voice"]["forbidden_moves"])
        self.assertIn("autonome", mathilde["role"])
        self.assertIn("répétition acquise", mathilde["voice"]["forbidden_moves"])
        self.assertIn("arrêt punitif", mathilde["voice"]["forbidden_moves"])
        voices = [json.dumps(item["voice"], ensure_ascii=False, sort_keys=True) for item in (sandra, marie, mathilde)]
        self.assertEqual(3, len(set(voices)))

    def test_registers_encode_relationship_movements_limits_and_local_variation(self):
        sandra = self.workspaces["sandra"]["relationship"]["relationship"]
        marie = self.workspaces["marie"]["relationship"]["relationship"]
        mathilde = self.workspaces["mathilde"]["relationship"]["relationship"]
        self.assertIn("antérieure au couple avec Marie", sandra["nature"])
        self.assertIn("sandra_deflects_with_humor", {item["movement_id"] for item in sandra["movements"]})
        self.assertIn("marie_names_delay_directly", {item["movement_id"] for item in marie["movements"]})
        mathilde_limits = {item["limit_id"] for item in mathilde["limits"]}
        self.assertTrue(
            {
                "mathilde_no_assumed_permission",
                "mathilde_mb1_nonsexual",
                "mathilde_mb2_distinct_mb3",
                "mathilde_clean_nonpunitive_stop",
                "mathilde_mb3_independent_departure",
                "mathilde_no_acquired_repetition",
            }.issubset(mathilde_limits)
        )
        for relationship in (sandra, marie, mathilde):
            self.assertEqual(2, len(relationship["participant_ids"]))
            self.assertGreaterEqual(len(relationship["local_states"]), 2)

    def test_three_short_corpora_share_the_opening_motion_but_realize_it_differently(self):
        expected_active_movements = {
            "sandra": "sandra_player_returns_carefully",
            "marie": "marie_player_returns_plainly",
            "mathilde": "mathilde_player_reopens_without_claim",
        }
        active_character_movements = {}
        for name, workspace in self.workspaces.items():
            case = workspace["case"]
            self.assertEqual(10, len(case["messages"]))
            self.assertEqual("player", case["messages"][0]["speaker_id"])
            self.assertIn(expected_active_movements[name], case["messages"][0]["movement_refs"])
            active_character_movements[name] = {
                movement
                for message in case["messages"]
                if message["speaker_id"] == name
                for movement in message["movement_refs"]
            }
        self.assertTrue(all(active_character_movements.values()))
        self.assertEqual(3, len({frozenset(value) for value in active_character_movements.values()}))

    def test_own_contracts_pass_and_foreign_contracts_localize_non_interchangeability(self):
        result = cross_validate_library()
        relational_codes = {
            "FACT_UNAVAILABLE",
            "LIMIT_INCOMPATIBLE",
            "MOVEMENT_INCOMPATIBLE",
            "LOCAL_STATE_INCOMPATIBLE",
        }
        for source in CASE_NAMES:
            self.assertTrue(result[source][source]["compatible"])
            self.assertEqual([], result[source][source]["issues"])
            foreign_targets = [target for target in CASE_NAMES if target != source]
            for target in foreign_targets:
                issues = result[source][target]["issues"]
                self.assertTrue(issues, f"{source} sous {target}")
                codes = {issue["code"] for issue in issues}
                self.assertIn("VOICE_RULE_INCOMPATIBLE", codes)
                self.assertTrue(codes.intersection(relational_codes))
                self.assertTrue(all(issue["path"] and issue["message"] for issue in issues))

    def test_sandra_memory_cannot_be_reused_as_marie_or_mathilde_memory(self):
        sandra_case = self.workspaces["sandra"]["case"]
        for target in ("marie", "mathilde"):
            target_workspace = self.workspaces[target]
            issues = validate_compatibility(
                sandra_case,
                target_workspace["character"],
                target_workspace["relationship"],
            )
            unavailable = {
                issue.message for issue in issues
                if issue.code in {"FACT_UNAVAILABLE", "MESSAGE_FACT_INCOMPATIBLE"}
            }
            self.assertIn("sandra_folded_ticket", unavailable)
            self.assertIn("sandra_old_bus_shelter", unavailable)

    def test_marie_cannot_be_rewritten_as_systematic_sandra_humor(self):
        mutant = copy.deepcopy(self.workspaces["marie"]["case"])
        sandra_evidence = self.workspaces["sandra"]["case"]["voice_evidence"]
        mutant["voice_evidence"] = copy.deepcopy(sandra_evidence)
        for message in mutant["messages"]:
            if message["speaker_id"] == "marie":
                message["movement_refs"] = ["sandra_deflects_with_humor"]
        issues = validate_compatibility(
            mutant,
            self.workspaces["marie"]["character"],
            self.workspaces["marie"]["relationship"],
        )
        codes = {issue.code for issue in issues}
        self.assertIn("VOICE_RULE_INCOMPATIBLE", codes)
        self.assertIn("MESSAGE_MOVEMENT_INCOMPATIBLE", codes)
        self.assertIn(
            "marie_names_delay_directly",
            self.workspaces["marie"]["case"]["expected_movement_ids"],
        )

    def test_mathilde_requires_present_permission_and_keeps_a_clean_exit(self):
        mutant = copy.deepcopy(self.workspaces["mathilde"]["case"])
        mutant["useful_limit_ids"].remove("mathilde_no_assumed_permission")
        issues = validate_compatibility(
            mutant,
            self.workspaces["mathilde"]["character"],
            self.workspaces["mathilde"]["relationship"],
        )
        missing = [issue for issue in issues if issue.code == "MOVEMENT_REQUIRED_LIMIT_MISSING"]
        self.assertTrue(missing)
        self.assertTrue(any("mathilde_no_assumed_permission" in issue.message for issue in missing))
        case = self.workspaces["mathilde"]["case"]
        self.assertIn("mathilde_keeps_exit_real", case["expected_movement_ids"])
        self.assertIn("mathilde_names_present_choice", case["expected_movement_ids"])
        last = case["messages"][-1]
        self.assertIn("mathilde_keeps_exit_real", last["movement_refs"])

    def test_local_state_changes_strategy_without_replacing_voice(self):
        alternate_states = {
            "sandra": "sandra_warm_but_guarded",
            "marie": "marie_repair_open_cautious",
            "mathilde": "mathilde_distance_chosen",
        }
        for name, workspace in self.workspaces.items():
            current = compile_minimal_context(workspace)
            alternate = compile_minimal_context(workspace, alternate_states[name])
            current_sections = self._sections(current)
            alternate_sections = self._sections(alternate)
            self.assertEqual(current_sections["active_character"], alternate_sections["active_character"])
            self.assertEqual(
                current_sections["active_player_relationship"],
                alternate_sections["active_player_relationship"],
            )
            self.assertNotEqual(current_sections["local_state"], alternate_sections["local_state"])
            self.assertNotEqual(current_sections["expected_movements"], alternate_sections["expected_movements"])

    def test_compiled_context_is_deterministic_minimal_and_excludes_foreign_material(self):
        expected_sections = {
            "active_character",
            "active_player_relationship",
            "local_state",
            "useful_facts",
            "useful_limits",
            "expected_movements",
        }
        for name, workspace in self.workspaces.items():
            context = compile_minimal_context(workspace)
            self.assertEqual(context, compile_minimal_context(workspace))
            self.assertEqual(expected_sections, set(self._sections(context)))
            for foreign in CASE_NAMES:
                if foreign == name:
                    continue
                self.assertNotIn(f'"character_id":"{foreign}"', context)
                self.assertNotIn(f'"relationship_id":"player_{foreign}"', context)
            for fact in workspace["character"]["unknown_facts"]:
                self.assertNotIn(fact["fact_id"], context)
            self.assertNotIn('"messages"', context)
            self.assertNotIn('"unknown_facts"', context)

    def test_structured_relation_proof_does_not_depend_only_on_words(self):
        for name, workspace in self.workspaces.items():
            neutral = copy.deepcopy(workspace["case"])
            for index, message in enumerate(neutral["messages"]):
                message["text"] = f"Bulle éditoriale neutre {index + 1}."
            self.assertEqual(
                [],
                validate_compatibility(neutral, workspace["character"], workspace["relationship"]),
            )
        sandra = copy.deepcopy(self.workspaces["sandra"]["case"])
        original_texts = [message["text"] for message in sandra["messages"]]
        sandra["useful_fact_ids"][1] = "marie_fridge_note"
        issues = validate_compatibility(
            sandra,
            self.workspaces["sandra"]["character"],
            self.workspaces["sandra"]["relationship"],
        )
        self.assertIn("FACT_UNAVAILABLE", {issue.code for issue in issues})
        self.assertEqual(original_texts, [message["text"] for message in sandra["messages"]])

    def test_blind_dossier_has_three_anonymous_voices_and_human_justification(self):
        content = BLIND_DOSSIER.read_text(encoding="utf-8")
        for label in ("Voix A", "Voix B", "Voix C"):
            self.assertIn(f"## {label}", content)
            self.assertIn(f"| {label} |", content)
        blind_body = content.split("## Fiche d'attribution humaine", 1)[0]
        for name in CASE_NAMES:
            self.assertNotIn(f"> {name.capitalize()} —", blind_body)
        self.assertIn("Attribution proposée", content)
        self.assertIn("Justification synthétique", content)
        self.assertNotIn("attribution attendue", content.casefold())
        mapping = {"Voix A": "sandra", "Voix B": "mathilde", "Voix C": "marie"}
        for label, name in mapping.items():
            start = content.index(f"## {label}")
            end = content.find("\n## ", start + 4)
            section = content[start:] if end == -1 else content[start:end]
            positions = [section.index(message["text"]) for message in self.workspaces[name]["case"]["messages"]]
            self.assertEqual(sorted(positions), positions)

    def test_lot_is_offline_noncanonical_and_disconnected_from_runtime(self):
        paths = [ROOT / "tools/a11_voice_calibration.py", DOC, BLIND_DOSSIER]
        paths.extend(sorted(CALIBRATION_DIR.rglob("*.json")))
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
        ]
        for token in forbidden:
            self.assertNotIn(token, sources, token)
        self.assertNotIn("http://", sources)
        self.assertNotIn("https://", sources)
        self.assertEqual([], list((ROOT / "game").rglob("*a11_2*")))

    def test_cli_smoke_and_json_validation(self):
        smoke = run_smoke()
        self.assertTrue(smoke["ok"])
        self.assertEqual(list(CASE_NAMES), smoke["cases"])
        for command in ("validate-json", "smoke"):
            result = subprocess.run(
                [sys.executable, "tools/a11_voice_calibration.py", command],
                cwd=ROOT,
                text=True,
                capture_output=True,
                check=False,
            )
            self.assertEqual(0, result.returncode, result.stderr)
            self.assertIn('"ok": true', result.stdout)

    @staticmethod
    def _sections(context: str) -> dict[str, str]:
        sections: dict[str, str] = {}
        current = None
        for line in context.splitlines():
            if line.startswith("## "):
                current = line[3:]
                sections[current] = ""
            elif current is not None:
                sections[current] += line + "\n"
        return sections


if __name__ == "__main__":
    unittest.main()
