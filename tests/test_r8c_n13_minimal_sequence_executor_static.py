import json
import re
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASELINE = "f7f81d866fa7f573f6fca4d7da62ccf9cfc4b859"
EXECUTION_DIR = ROOT / "game/scripts/unified_runtime/execution"
FIXTURE = ROOT / "game/tests/fixtures/unified_runtime/n13_a10_durable_integration_valid.json"
PRODUCTION_FILES = {
    "SequenceResolutionEnvelopeV1.gd",
    "UnifiedRuntimeSnapshotV1.gd",
    "SequenceExecutor.gd",
}
BEAT_TYPES = {
    "MESSAGE",
    "CHOICE",
    "TRANSITION",
    "PHYSICAL_BEAT",
    "MEDIA_REVEAL",
    "AFTERCARE",
    "RETURN",
}
PUBLIC_EXECUTOR_API = {
    "create",
    "restore",
    "start",
    "execution_state",
    "current_beat",
    "open_current_projection",
    "receive_ack",
    "receive_command",
    "commit_resolution",
    "snapshot",
}


class R8CN13MinimalSequenceExecutorStaticTests(unittest.TestCase):
    def setUp(self):
        self.fixture = json.loads(FIXTURE.read_text(encoding="utf-8"))

    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def const_strings(self, source: str, name: str) -> list[str]:
        match = re.search(
            rf"const\s+{re.escape(name)}\s*:=\s*\[(.*?)\]",
            source,
            re.DOTALL,
        )
        self.assertIsNotNone(match, name)
        return re.findall(r'"([A-Za-z0-9_]+)"', match.group(1))

    def test_exact_n13_files_exist_and_production_directory_is_closed(self):
        expected = {
            "game/scripts/unified_runtime/execution/SequenceResolutionEnvelopeV1.gd",
            "game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd",
            "game/scripts/unified_runtime/execution/SequenceExecutor.gd",
            "game/tests/fixtures/unified_runtime/n13_a10_durable_integration_valid.json",
            "tests/test_r8c_n13_minimal_sequence_executor_static.py",
            "game/tests/R8C_N13MinimalSequenceExecutorSmokeDriver.gd",
            "game/tests/R8C_N13MinimalSequenceExecutorSmokeTest.tscn",
        }
        self.assertEqual([], [path for path in expected if not (ROOT / path).is_file()])
        self.assertEqual(PRODUCTION_FILES, {path.name for path in EXECUTION_DIR.glob("*.gd")})

    def test_fixture_is_closed_synthetic_and_covers_each_beat_type_once(self):
        self.assertEqual("reseau_intime.authored_sequence", self.fixture["schema_id"])
        self.assertEqual(1, self.fixture["schema_version"])
        self.assertEqual("SYNTHETIC_TEST_ONLY", self.fixture["author_provenance"]["approval_ref"])
        self.assertEqual("sequence_entered", self.fixture["beats"][0]["checkpoint_before"])
        types = [beat["type"] for beat in self.fixture["beats"]]
        self.assertEqual(BEAT_TYPES, set(types))
        self.assertEqual(len(BEAT_TYPES), len(types))
        raw = FIXTURE.read_text(encoding="utf-8").lower()
        for forbidden in ("mathilde", "legacy", "season1state", "j11", "chapter_"):
            self.assertNotIn(forbidden, raw)

    def test_fixture_uses_only_existing_durable_relational_fact_path(self):
        definition = self.fixture["orchestration"]["a6_entry"]["definition"]
        self.assertEqual(["sandra"], self.fixture["participants"]["present_character_ids"])
        self.assertEqual({"a10_resolution_commit"}, set(definition["resolutions"]))
        a3_resolution = definition["resolutions"]["a10_resolution_commit"]
        self.assertEqual("DURABLE", a3_resolution["portee_micro_signal"])
        self.assertEqual("RECUE_INTERPRETEE", a3_resolution["reception"])
        self.assertEqual(
            ["synthetic_n13_relation_fact"],
            [fact["fait_id"] for fact in a3_resolution["faits_relationnels"]],
        )
        resolution = self.fixture["resolutions"]["resolution_complete"]
        self.assertEqual("choice_finish", resolution["choice_id"])
        self.assertEqual("a10_choice_commit", resolution["a10_choice_id"])
        self.assertEqual("a10_resolution_commit", resolution["a10_resolution_id"])
        self.assertEqual(["synthetic_n13_relation_fact"], resolution["fact_ids"])
        for field in (
            "event_refs",
            "knowledge_ids",
            "trace_ids",
            "promise_effects",
            "obligation_effects",
            "consequence_ids",
            "media_effects",
        ):
            self.assertEqual([], resolution[field], field)

    def test_resolution_envelope_has_exact_closed_binding(self):
        source = self.read(
            "game/scripts/unified_runtime/execution/SequenceResolutionEnvelopeV1.gd"
        )
        self.assertEqual(
            {
                "instance_id",
                "sequence_id",
                "authored_version",
                "choice_id",
                "resolution_id",
                "a10_choice_id",
                "a10_resolution_id",
                "terminal_checkpoint_id",
                "event_keys",
            },
            set(self.const_strings(source, "FIELDS")),
        )
        self.assertIn("AuthoredValidator.validate", source)
        self.assertIn("SequenceExecution.validate", source)
        self.assertIn('a10_resolution["portee_micro_signal"] != "DURABLE"', source)
        self.assertIn("a10_resolution_choice_mismatch", source)
        for forbidden in ("score", "desir", "confiance", "consentement", "payload"):
            self.assertNotRegex(source.lower(), rf"\b{forbidden}\b")

    def test_snapshot_is_exact_closed_in_memory_state(self):
        source = self.read(
            "game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd"
        )
        self.assertIn('const SCHEMA_ID := "reseau_intime.unified_runtime"', source)
        self.assertIn("const SCHEMA_VERSION := 1", source)
        self.assertEqual(
            {
                "schema_id",
                "schema_version",
                "sequence_id",
                "authored_version",
                "domain",
                "execution",
                "projection_port",
            },
            set(self.const_strings(source, "FIELDS")),
        )
        self.assertIn("SequenceExecution.validate", source)
        self.assertIn("ProjectionContracts.validate_port_snapshot", source)
        self.assertIn("restore_into", source)
        self.assertNotIn("FileAccess", source)
        self.assertNotIn("DirAccess", source)

    def test_executor_api_is_compact_and_calls_only_a10_resolution_boundary(self):
        source = self.read("game/scripts/unified_runtime/execution/SequenceExecutor.gd")
        functions = set(re.findall(r"^(?:static )?func\s+([a-z0-9_]+)\s*\(", source, re.M))
        public = {name for name in functions if not name.startswith("_")}
        self.assertEqual(PUBLIC_EXECUTOR_API, public)
        self.assertEqual(1, source.count("_facade.resolve_scene("))
        self.assertIn('envelope["a10_choice_id"]', source)
        self.assertIn('envelope["a10_resolution_id"]', source)
        self.assertNotRegex(source, r'_facade\.resolve_scene\([^)]*envelope\["resolution_id"\]')
        self.assertIn("consumed_choice_ids", source)
        self.assertIn("DIVERGENT_COMMIT", source)
        self.assertIn("COMPLETE", source)

    def test_production_has_no_ui_legacy_score_disk_or_concrete_port(self):
        sources = "\n".join(path.read_text(encoding="utf-8") for path in EXECUTION_DIR.glob("*.gd"))
        forbidden_patterns = (
            r"Season1State",
            r"scripts/runtime/season_1",
            r"MessagesScreen",
            r"ChoiceBar",
            r"GalleryScreen",
            r"PhotoViewer",
            r"Mathilde",
            r"FileAccess",
            r"DirAccess",
            r"\bscore\b",
            r"\bday\b",
            r"traiter_evenement",
            r"MinimalSceneEngine",
            r"ReducerRelation",
        )
        for pattern in forbidden_patterns:
            self.assertNotRegex(sources, pattern)
        self.assertNotRegex(sources, r"class_name\s+.*(?:Memory|Fake).*Port")
        for preload in re.findall(r'preload\("res://([^\"]+)"\)', sources):
            self.assertTrue(preload.startswith("scripts/unified_runtime/"), preload)

    def test_a10_still_has_exactly_seven_public_operations(self):
        source = self.read("game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
        functions = set(re.findall(r"^(?:static )?func\s+([a-z0-9_]+)\s*\(", source, re.M))
        public = {name for name in functions if not name.startswith("_")}
        self.assertEqual(
            {
                "create",
                "find_candidates",
                "compose_slot",
                "activate_option",
                "resolve_scene",
                "save_state",
                "restore_state",
            },
            public,
        )

    def test_locked_contracts_a1_to_a10_and_bootstrap_are_unchanged(self):
        protected = [
            "game/project.godot",
            "game/scripts/narrative_state",
            "game/scripts/narrative_scene",
            "game/scripts/unified_runtime/contracts",
            "game/tests/fixtures/unified_runtime/authored_sequence_v1_minimal_valid.json",
        ]
        result = subprocess.run(
            ["git", "diff", "--exit-code", BASELINE, "--", *protected],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual("", result.stdout + result.stderr)
        self.assertEqual(0, result.returncode)

    def test_smoke_covers_nominal_restores_idempotence_and_negative_cases(self):
        source = self.read("game/tests/R8C_N13MinimalSequenceExecutorSmokeDriver.gd")
        self.assertIn("class FakeProjectionPort extends ProjectionPort", source)
        self.assertEqual(3, source.count("_restore_executor(sequence, executor.snapshot()"))
        required = {
            "fixture authored invalide refusee",
            "activation absente refusee",
            "activation non proposee refusee",
            "mauvais %s refuse",
            "mapping authored A10 incoherent refuse",
            "choix inconnu refuse",
            "double choix identique idempotent",
            "accuse etranger refuse",
            "projection non supportee refusee",
            "double commit identique idempotent",
            "double commit divergent refuse",
            "namespace etranger refuse",
            "snapshot autre sequence refuse",
            "snapshot port incoherent refuse",
            "restauration sans fixture refusee",
            "progression apres complete refusee",
        }
        for message in required:
            self.assertIn(f'"{message}"', source)
        self.assertIn("R8C_N13_MINIMAL_SEQUENCE_EXECUTOR: OK", source)
        self.assertIn("controls", source)


if __name__ == "__main__":
    unittest.main()
