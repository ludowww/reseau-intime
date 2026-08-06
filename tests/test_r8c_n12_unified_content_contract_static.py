import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CONTRACT_DIR = ROOT / "game/scripts/unified_runtime/contracts"
FIXTURE_DIR = ROOT / "game/tests/fixtures/unified_runtime"
VALID_FIXTURE = FIXTURE_DIR / "authored_sequence_v1_minimal_valid.json"
INVALID_FIXTURE = FIXTURE_DIR / "authored_sequence_v1_invalid_cases.json"
ARCHITECTURE_CONTRACT = (
    ROOT
    / "docs/architecture/R8C_N12_1_AUTHORED_A10_RESOLUTION_BINDING_AND_N13_ENTRY_CONTRACT.md"
)

BEAT_TYPES = {
    "MESSAGE",
    "CHOICE",
    "TRANSITION",
    "PHYSICAL_BEAT",
    "MEDIA_REVEAL",
    "AFTERCARE",
    "RETURN",
}
ROOT_FIELDS = {
    "schema_id",
    "schema_version",
    "sequence_id",
    "authored_version",
    "season_id",
    "dramatic_movement_id",
    "narrative_function",
    "canonical_status",
    "author_provenance",
    "participants",
    "orchestration",
    "temporal_projection",
    "entry_beat_id",
    "beats",
    "resolutions",
    "media",
}
BEAT_FIELDS = {
    "beat_id",
    "type",
    "content",
    "participant_ids",
    "local_conditions",
    "projection_target",
    "checkpoint_before",
    "checkpoint_after",
    "next",
}
CONTENT_FIELDS = {
    "MESSAGE": {"thread_id", "messages"},
    "CHOICE": {"thread_id", "choices"},
    "TRANSITION": {
        "transition_id",
        "mode",
        "from_anchor",
        "to_anchor",
        "continuation_label",
    },
    "PHYSICAL_BEAT": {
        "physical_beat_id",
        "content_ref",
        "withdrawal_choice_ids",
    },
    "MEDIA_REVEAL": {"media_id", "reveal_context", "requires_ack"},
    "AFTERCARE": {"aftercare_id", "content_ref", "obligation_id"},
    "RETURN": {"return_id", "content_ref", "delay", "eligible_resolution_ids"},
}
RESOLUTION_FIELDS = {
    "resolution_id",
    "choice_id",
    "a10_choice_id",
    "a10_resolution_id",
    "terminal_checkpoint_id",
    "event_refs",
    "fact_ids",
    "knowledge_ids",
    "trace_ids",
    "promise_effects",
    "obligation_effects",
    "consequence_ids",
    "media_effects",
    "convergence",
    "next_beat_id",
}
INVALID_CASE_IDS = {
    "forbidden_dependency",
    "unknown_key",
    "missing_required_field",
    "forbidden_beat_type",
    "duplicate_identifier",
    "missing_transition_target",
    "missing_resolution",
    "missing_a10_resolution_mapping",
    "invalid_a10_resolution_mapping_type",
    "unknown_a10_resolution_mapping",
    "incompatible_a10_resolution_mapping",
    "duplicate_a10_resolution_mapping",
    "durable_effect_without_a10_mapping",
    "missing_media",
    "missing_checkpoint",
    "cycle",
    "day_based_identifier",
    "invalid_version",
    "invalid_canonical_status",
    "legacy_field",
    "execution_receipt_before_open",
    "choice_uses_other_resolution",
    "option_resolution_target_mismatch",
    "orphan_resolution",
    "resolution_reused",
    "return_without_reciprocal_resolution",
    "return_with_foreign_resolution",
    "integer_as_float",
    "nested_unknown_beat",
    "nested_unknown_choice",
    "nested_unknown_resolution",
    "nested_unknown_media",
    "nested_unknown_a6",
    "nested_unknown_a8",
    "nested_unknown_a9",
    "nested_unknown_temporal",
    "nested_unknown_participant",
    "execution_choice_non_choice_beat",
    "execution_unknown_choice",
    "execution_waiting_without_open",
    "execution_projection_other_instance",
    "nested_unknown_execution",
    "projection_ack_other_beat",
    "projection_foreign_state_receipt",
    "projection_foreign_snapshot_receipt",
    "nested_unknown_projection_request",
    "nested_unknown_projection_command",
    "nested_unknown_projection_receipt",
    "nested_unknown_projection_result",
    "nested_unknown_snapshot",
}
PRODUCTION_N12_FILES = (
    "game/scripts/unified_runtime/contracts/AuthoredSequenceV1.gd",
    "game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd",
    "game/scripts/unified_runtime/contracts/SequenceExecutionV1.gd",
    "game/scripts/unified_runtime/contracts/PlayerProjectionContracts.gd",
    "game/scripts/unified_runtime/contracts/PlayerProjectionPort.gd",
)


class R8CN12UnifiedContentContractStaticTests(unittest.TestCase):
    def setUp(self):
        self.valid = json.loads(VALID_FIXTURE.read_text(encoding="utf-8"))
        self.invalid = json.loads(INVALID_FIXTURE.read_text(encoding="utf-8"))

    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def gdscript_const_strings(self, source: str, name: str) -> list[str]:
        match = re.search(
            rf"const\s+{re.escape(name)}\s*:=\s*\[(.*?)\]",
            source,
            flags=re.DOTALL,
        )
        self.assertIsNotNone(match, name)
        return re.findall(r'"([A-Z0-9_]+|[a-z0-9_]+)"', match.group(1))

    def test_expected_files_exist_in_isolated_n12_locations(self):
        expected = [
            "docs/architecture/R8C_N12_1_AUTHORED_A10_RESOLUTION_BINDING_AND_N13_ENTRY_CONTRACT.md",
            "game/scripts/unified_runtime/contracts/AuthoredSequenceV1.gd",
            "game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd",
            "game/scripts/unified_runtime/contracts/SequenceExecutionV1.gd",
            "game/scripts/unified_runtime/contracts/PlayerProjectionContracts.gd",
            "game/scripts/unified_runtime/contracts/PlayerProjectionPort.gd",
            "game/tests/fixtures/unified_runtime/authored_sequence_v1_minimal_valid.json",
            "game/tests/fixtures/unified_runtime/authored_sequence_v1_invalid_cases.json",
            "game/tests/R8C_N12UnifiedContentContractSmokeDriver.gd",
            "game/tests/R8C_N12UnifiedContentContractSmokeTest.tscn",
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).is_file()])

    def test_n12_1_architecture_contract_records_preproduction_exception_and_n13_entry(self):
        source = ARCHITECTURE_CONTRACT.read_text(encoding="utf-8")
        for required in (
            "resolution_id",
            "a10_choice_id",
            "a10_resolution_id",
            "sequence_resolution",
            "sequence_entered",
            "n13_a10_durable_integration_valid.json",
            "schema_id = reseau_intime.authored_sequence",
            "schema_version = 1",
            "exception explicitement autorisée avant production",
            "N13_REMAINS_STOPPED",
        ):
            self.assertIn(required, source)
        self.assertIn("aucune huitième opération", source)
        self.assertRegex(source, r"N14.*codec A5")

    def test_root_schema_is_exact_closed_and_versioned(self):
        self.assertEqual(ROOT_FIELDS, set(self.valid))
        self.assertEqual("reseau_intime.authored_sequence", self.valid["schema_id"])
        self.assertEqual(1, self.valid["schema_version"])
        self.assertEqual("CANON_APPROVED", self.valid["canonical_status"])
        self.assertRegex(self.valid["authored_version"], r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$")

        source = self.read(
            "game/scripts/unified_runtime/contracts/AuthoredSequenceV1.gd"
        )
        self.assertEqual(ROOT_FIELDS, set(self.gdscript_const_strings(source, "ROOT_FIELDS")))
        self.assertIn('const SCHEMA_ID := "reseau_intime.authored_sequence"', source)
        self.assertIn("const SCHEMA_VERSION := 1", source)
        self.assertIn('const CANONICAL_STATUS := "CANON_APPROVED"', source)

    def test_valid_fixture_covers_only_the_seven_closed_beat_types(self):
        beats = self.valid["beats"]
        self.assertEqual(BEAT_TYPES, {beat["type"] for beat in beats})
        self.assertTrue(all(set(beat) == BEAT_FIELDS for beat in beats))
        for beat in beats:
            self.assertEqual(CONTENT_FIELDS[beat["type"]], set(beat["content"]))

        source = self.read(
            "game/scripts/unified_runtime/contracts/AuthoredSequenceV1.gd"
        )
        self.assertEqual(BEAT_TYPES, set(self.gdscript_const_strings(source, "BEAT_TYPES")))
        self.assertNotIn("SCRIPT", BEAT_TYPES)

    def test_initial_sequence_entered_checkpoint_is_materialized(self):
        self.assertEqual(
            "sequence_entered", self.valid["beats"][0]["checkpoint_before"]
        )

    def test_authored_resolutions_have_closed_explicit_nullable_a10_binding(self):
        source = self.read(
            "game/scripts/unified_runtime/contracts/AuthoredSequenceV1.gd"
        )
        self.assertEqual(
            RESOLUTION_FIELDS,
            set(self.gdscript_const_strings(source, "RESOLUTION_FIELDS")),
        )

        resolutions = self.valid["resolutions"]
        self.assertTrue(all(set(resolution) == RESOLUTION_FIELDS for resolution in resolutions.values()))
        self.assertIsNone(resolutions["resolution_start"]["a10_resolution_id"])
        self.assertEqual(
            "a3_resolution_continue",
            resolutions["resolution_complete"]["a10_resolution_id"],
        )
        self.assertEqual(
            "a3_resolution_stop",
            resolutions["resolution_stop"]["a10_resolution_id"],
        )
        self.assertTrue(
            all(
                resolution["a10_resolution_id"] is None
                or isinstance(resolution["a10_resolution_id"], str)
                for resolution in resolutions.values()
            )
        )

        definition = self.valid["orchestration"]["a6_entry"]["definition"]
        a10_choices = {
            choice["choix_id"]: set(choice["resolution_ids"])
            for choice in definition["choix"]
        }
        claimed = set()
        for resolution in resolutions.values():
            a10_resolution_id = resolution["a10_resolution_id"]
            if a10_resolution_id is None:
                continue
            self.assertIn(a10_resolution_id, definition["resolutions"])
            self.assertIn(a10_resolution_id, a10_choices[resolution["a10_choice_id"]])
            self.assertNotIn(a10_resolution_id, claimed)
            claimed.add(a10_resolution_id)

        durable_fields = {
            "event_refs",
            "fact_ids",
            "knowledge_ids",
            "trace_ids",
            "promise_effects",
            "obligation_effects",
            "consequence_ids",
            "media_effects",
        }
        for resolution in resolutions.values():
            if any(resolution[field] for field in durable_fields):
                self.assertIsNotNone(resolution["a10_resolution_id"])
        self.assertTrue(
            all(not resolutions["resolution_start"][field] for field in durable_fields)
        )

    def test_validator_closes_every_a10_resolution_mapping_failure(self):
        source = self.read(
            "game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
        )
        self.assertIn(
            'resolution["a10_resolution_id"], path + ".a10_resolution_id", errors',
            source,
        )
        for error_code in (
            "unknown_a6_resolution",
            "a10_resolution_choice_mismatch",
            "a10_resolution_reused",
            "durable_effect_requires_a10_resolution",
        ):
            self.assertIn(error_code, source)
        cases = {case["case_id"]: case for case in self.invalid["cases"]}
        expected_mutations = {
            "missing_a10_resolution_mapping": "remove_a10_resolution_id",
            "invalid_a10_resolution_mapping_type": "set_a10_resolution_id_integer",
            "unknown_a10_resolution_mapping": "set_unknown_a10_resolution_id",
            "incompatible_a10_resolution_mapping": "set_incompatible_a10_resolution_choice",
            "duplicate_a10_resolution_mapping": "reuse_a10_resolution_id",
            "durable_effect_without_a10_mapping": "clear_durable_a10_resolution_id",
        }
        for case_id, mutation in expected_mutations.items():
            self.assertEqual(mutation, cases[case_id]["mutation"])

    def test_valid_fixture_graph_is_referentially_complete_acyclic_and_reachable(self):
        beats = {beat["beat_id"]: beat for beat in self.valid["beats"]}
        self.assertEqual(len(beats), len(self.valid["beats"]))
        self.assertIn(self.valid["entry_beat_id"], beats)
        choices = {}
        checkpoints = set()
        adjacency = {beat_id: set() for beat_id in beats}

        for beat_id, beat in beats.items():
            for checkpoint in (beat["checkpoint_before"], beat["checkpoint_after"]):
                if checkpoint is not None:
                    self.assertNotIn(checkpoint, checkpoints)
                    checkpoints.add(checkpoint)
            if beat["type"] == "CHOICE":
                local_choices = {item["choice_id"]: item for item in beat["content"]["choices"]}
                self.assertTrue(set(local_choices).isdisjoint(choices))
                choices.update(local_choices)
                self.assertEqual(set(local_choices), set(beat["next"]["branches"]))
                for choice_id, target in beat["next"]["branches"].items():
                    self.assertEqual(local_choices[choice_id]["next_beat_id"], target)
                    self.assertIn(target, beats)
                    adjacency[beat_id].add(target)
            elif beat["next"]["mode"] == "DIRECT":
                self.assertIn(beat["next"]["beat_id"], beats)
                adjacency[beat_id].add(beat["next"]["beat_id"])
            else:
                self.assertEqual({"mode": "TERMINAL", "beat_id": None}, beat["next"])

        self.assertEqual(len(choices), len(set(choices)))
        claimed_resolutions = {}
        for choice_id, choice in choices.items():
            resolution_id = choice["resolution_id"]
            self.assertIsNotNone(resolution_id)
            self.assertNotIn(resolution_id, claimed_resolutions)
            claimed_resolutions[resolution_id] = choice_id
            resolution = self.valid["resolutions"][resolution_id]
            self.assertEqual(choice_id, resolution["choice_id"])
            self.assertEqual(choice["next_beat_id"], resolution["next_beat_id"])
        for resolution_id, resolution in self.valid["resolutions"].items():
            self.assertEqual(resolution_id, resolution["resolution_id"])
            self.assertIn(resolution["choice_id"], choices)
            self.assertIn(resolution["terminal_checkpoint_id"], checkpoints)
            self.assertIn(resolution["next_beat_id"], beats)
            self.assertEqual(resolution_id, choices[resolution["choice_id"]]["resolution_id"])
        self.assertEqual(set(self.valid["resolutions"]), set(claimed_resolutions))
        for beat_id, beat in beats.items():
            if beat["type"] != "RETURN":
                continue
            declared = set(beat["content"]["eligible_resolution_ids"])
            targeted = {
                resolution_id
                for resolution_id, resolution in self.valid["resolutions"].items()
                if resolution["next_beat_id"] == beat_id
            }
            self.assertEqual(targeted, declared)
        for beat in beats.values():
            if beat["type"] == "MEDIA_REVEAL":
                self.assertIn(beat["content"]["media_id"], self.valid["media"])

        visiting, visited = set(), set()

        def visit(node: str):
            self.assertNotIn(node, visiting, "cycle authored")
            if node in visited:
                return
            visiting.add(node)
            for target in adjacency[node]:
                visit(target)
            visiting.remove(node)
            visited.add(node)

        visit(self.valid["entry_beat_id"])
        self.assertEqual(set(beats), visited)

    def test_fixture_is_synthetic_non_canonical_content_and_has_no_day_identity(self):
        raw = VALID_FIXTURE.read_text(encoding="utf-8")
        self.assertIn("synthetic_test_fixture_only", raw)
        self.assertNotIn("season_1", raw)
        for real_name in ("mathilde", "sandra", "marie", "pauline", "raphaelle", "nico"):
            self.assertNotIn(real_name, raw.lower())

        identifier_values = []

        def collect(value, key=""):
            if isinstance(value, dict):
                for child_key, child in value.items():
                    if child_key.endswith("_id") and isinstance(child, str):
                        identifier_values.append(child)
                    collect(child, child_key)
            elif isinstance(value, list):
                for child in value:
                    collect(child, key)

        collect(self.valid)
        day_pattern = re.compile(r"(^|_)j\d{2}($|_)|(^|_)chapter_\d{2}($|_)", re.I)
        self.assertEqual([], [value for value in identifier_values if day_pattern.search(value)])

    def test_media_is_synthetic_non_diegetic_and_not_produced(self):
        self.assertEqual({"synthetic_media"}, set(self.valid["media"]))
        media = self.valid["media"]["synthetic_media"]
        self.assertEqual("SPECIFIED_NOT_PRODUCED", media["production_status"])
        self.assertEqual("NON_DIEGETIC", media["diegesis"])
        for audience_id in media["audience_ids"]:
            self.assertEqual([], self.valid["participants"]["initial_audiences"][audience_id])

    def test_invalid_fixture_covers_every_required_failure_family(self):
        self.assertEqual("SYNTHETIC_NON_CANONICAL_INVALID_CASES", self.invalid["fixture_kind"])
        cases = self.invalid["cases"]
        self.assertEqual(INVALID_CASE_IDS, {case["case_id"] for case in cases})
        self.assertEqual(len(cases), len({case["mutation"] for case in cases}))
        for case in cases:
            self.assertEqual(
                {"case_id", "target", "mutation", "expected_error"}, set(case)
            )
            self.assertIn(
                case["target"],
                {"static", "authored_sequence", "sequence_execution", "projection_contract"},
            )
            self.assertTrue(case["expected_error"])

    def test_validator_has_structural_referential_and_graph_validation(self):
        source = self.read(
            "game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd"
        )
        functions = set(re.findall(r"^static func\s+([a-z0-9_]+)", source, re.M))
        required = {
            "validate",
            "_validate_exact_fields",
            "_validate_beats",
            "_validate_resolutions",
            "_validate_media",
            "_validate_references",
            "_validate_graph",
            "_visit_cycle",
            "_collect_reachable",
        }
        self.assertTrue(required.issubset(functions))
        self.assertIn('return {"valid": errors.is_empty(), "errors": errors.duplicate()}', source)
        self.assertIn("errors.sort()", source)
        self.assertNotIn("assert(", source)
        self.assertNotIn("SceneDefinition", source)
        self.assertIn("_validate_choice_resolution_reciprocity", source)
        self.assertIn("return typeof(value) == TYPE_INT", source)
        self.assertNotIn("TYPE_INT, TYPE_FLOAT", source)

    def test_integer_fields_are_json_integers_and_float_mutation_is_covered(self):
        self.assertIs(type(self.valid["schema_version"]), int)
        self.assertIs(
            type(self.valid["orchestration"]["a6_entry"]["definition"]["contrat_temporel"]["duree_minutes"]),
            int,
        )
        self.assertIs(type(self.valid["orchestration"]["a9_slot"]["duration_minutes"]), int)
        self.assertIs(type(self.valid["temporal_projection"]["offset_minutes"]), int)
        self.assertIn("integer_as_float", {case["case_id"] for case in self.invalid["cases"]})

    def test_nested_unknown_field_mutations_cover_every_closed_family(self):
        mutations = {case["mutation"] for case in self.invalid["cases"]}
        required = {
            "add_unknown_beat_field",
            "add_unknown_choice_field",
            "add_unknown_resolution_field",
            "add_unknown_media_field",
            "add_unknown_a6_field",
            "add_unknown_a8_field",
            "add_unknown_a9_field",
            "add_unknown_temporal_field",
            "add_unknown_participant_field",
            "add_unknown_execution_field",
            "add_unknown_projection_request_field",
            "add_unknown_projection_command_field",
            "add_unknown_projection_receipt_field",
            "add_unknown_projection_result_field",
            "add_unknown_snapshot_field",
        }
        self.assertTrue(required.issubset(mutations))

    def test_sequence_execution_is_closed_operational_state_only(self):
        source = self.read(
            "game/scripts/unified_runtime/contracts/SequenceExecutionV1.gd"
        )
        expected_fields = {
            "instance_id",
            "sequence_id",
            "authored_version",
            "execution_status",
            "checkpoint_id",
            "current_beat_id",
            "consumed_choice_ids",
            "reached_checkpoint_ids",
            "opened_projection_ids",
            "projection_receipts",
            "pending_player_input",
            "scheduled_returns",
            "selected_resolution_id",
            "durable_commit_status",
        }
        self.assertEqual(expected_fields, set(self.gdscript_const_strings(source, "FIELDS")))
        forbidden = {
            "relation",
            "knowledge",
            "promise",
            "obligation",
            "accessible_media_ids",
            "score",
        }
        self.assertTrue(forbidden.isdisjoint(expected_fields))
        self.assertNotRegex(source, r"func\s+(advance|execute|run_sequence|resolve_scene)\b")
        self.assertRegex(source, r"static func\s+validate_structure\b")
        self.assertRegex(source, r"static func\s+validate_against_sequence\b")
        self.assertIn("waiting_without_open_projection", source)
        self.assertIn("waiting_without_pending_ack", source)
        self.assertIn("choice_input_requires_choice_beat", source)

    def test_projection_contracts_and_abstract_port_are_closed(self):
        contracts = self.read(
            "game/scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
        )
        port = self.read(
            "game/scripts/unified_runtime/contracts/PlayerProjectionPort.gd"
        )
        self.assertIn("PROJECTION_REQUEST_FIELDS", contracts)
        self.assertIn("PROJECTION_COMMAND_FIELDS", contracts)
        self.assertIn("PRESENTATION_RECEIPT_FIELDS", contracts)
        self.assertIn("PROJECTION_RESULT_FIELDS", contracts)
        self.assertIn("PORT_SNAPSHOT_FIELDS", contracts)
        self.assertEqual(
            {
                "presentation_id",
                "instance_id",
                "sequence_id",
                "authored_version",
                "beat_id",
                "beat_type",
                "projection_target",
                "kind",
                "subject_id",
            },
            set(self.gdscript_const_strings(contracts, "PRESENTATION_RECEIPT_FIELDS")),
        )
        self.assertIn("validate_receipt_against_request", contracts)
        self.assertIn("_validate_receipt_identity", contracts)
        self.assertIn("duplicate_receipt", contracts)
        self.assertIn("const ABSTRACT_PORT := true", port)
        methods = set(re.findall(r"^func\s+([a-z_]+)", port, re.M))
        self.assertEqual(
            {
                "supports_projection",
                "open",
                "submit",
                "acknowledge",
                "snapshot",
                "restore",
                "close",
            },
            methods,
        )
        self.assertGreaterEqual(port.count('"NOT_IMPLEMENTED"'), 3)

    def test_production_contracts_have_no_ui_legacy_score_or_durable_write(self):
        sources = "\n".join(
            self.read(path)
            for path in PRODUCTION_N12_FILES
        )
        forbidden_patterns = [
            r"narrative_state",
            r"narrative_scene",
            r"scripts/runtime/season_1",
            r"\bseason_1\b",
            r"\bJNN\w*Provider\b",
            r"J\d{2}RuntimeProvider",
            r"Season1State",
            r"MessagesScreen",
            r"ChoiceBar",
            r"GalleryScreen",
            r"PhotoViewer",
            r"FileAccess",
            r"DirAccess",
            r"save_state\(",
            r"traiter_evenement",
            r"\bscore\b",
            r"route_points",
        ]
        for pattern in forbidden_patterns:
            self.assertNotRegex(sources, pattern)
        for path in PRODUCTION_N12_FILES:
            source = self.read(path)
            for preload_path in re.findall(r'preload\("res://([^\"]+)"\)', source):
                self.assertTrue(
                    preload_path.startswith("scripts/unified_runtime/contracts/"),
                    f"forbidden production dependency in {path}: {preload_path}",
                )
        dependency_probe = 'preload("res://scripts/narrative_state/Forbidden.gd")'
        self.assertRegex(dependency_probe, r"narrative_state")
        port = self.read(
            "game/scripts/unified_runtime/contracts/PlayerProjectionPort.gd"
        )
        self.assertNotRegex(port, r"narrative_scene|narrative_state|A10|A1")


if __name__ == "__main__":
    unittest.main()
