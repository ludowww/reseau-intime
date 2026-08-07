import json
import re
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
N14_1A_BASE_SHA = "103c9f9084d92b32ce6b60def7f21e6bdd8ba3e6"
N14_1A_FINAL_SHA = "df698afc5cf8366f78c2a84524794d2a7ade1c63"
FIXTURE_DIR = ROOT / "game/tests/fixtures/unified_runtime"
MANIFEST_FIELDS = {
    "binding",
    "facts",
    "knowledge",
    "traces",
    "promises",
    "obligations",
    "media_deliveries",
}
BINDING_FIELDS = {"sequence_id", "authored_version", "resolution_id"}
DURABLE_CATEGORIES = (
    "facts",
    "knowledge",
    "traces",
    "promises",
    "obligations",
    "media_deliveries",
)
NARRATIVE_ROOTS_V2 = {
    "format_version",
    "progression_saison",
    "relation_centrale",
    "relations",
    "evenements",
    "promesses",
    "obligations",
    "traces_narratives",
    "connaissances",
    "livraison_medias",
}
ALLOWED_PATHS = {
    "game/scripts/narrative_scene/SceneDefinition.gd",
    "game/scripts/unified_runtime/contracts/AuthoredSequenceV1.gd",
    "game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd",
    "game/scripts/narrative_scene/A5NarrativeStateCodec.gd",
    "game/scripts/narrative_state/EtatNarratif.gd",
    "game/tests/fixtures/unified_runtime/authored_sequence_v1_minimal_valid.json",
    "game/tests/fixtures/unified_runtime/n13_a10_durable_integration_valid.json",
    "tests/test_r8c_n12_unified_content_contract_static.py",
    "tests/test_r8c_n13_minimal_sequence_executor_static.py",
    "tests/test_r8c_n14_1a_manifest_codec_v2_static.py",
    "game/tests/R8C_N14_1AManifestCodecV2SmokeDriver.gd",
    "game/tests/R8C_N14_1AManifestCodecV2SmokeTest.tscn",
    "game/tests/R8C_N13MinimalSequenceExecutorSmokeDriver.gd",
}
PROTECTED_N13 = {
    "game/scripts/unified_runtime/execution/SequenceExecutor.gd",
    "game/scripts/unified_runtime/execution/SequenceResolutionEnvelopeV1.gd",
    "game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd",
    "game/scripts/unified_runtime/contracts/SequenceExecutionV1.gd",
    "game/scripts/unified_runtime/contracts/PlayerProjectionPort.gd",
    "game/scripts/unified_runtime/contracts/PlayerProjectionContracts.gd",
    "game/scripts/narrative_scene/MinimalSceneEngine.gd",
    "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd",
}


class R8CN141AManifestCodecV2StaticTests(unittest.TestCase):
    def read(self, path: str) -> str:
        return (ROOT / path).read_text(encoding="utf-8")

    def fixture(self, name: str) -> dict:
        return json.loads((FIXTURE_DIR / name).read_text(encoding="utf-8"))

    def test_exact_new_test_files_and_allowed_production_files_exist(self):
        required = {
            "tests/test_r8c_n14_1a_manifest_codec_v2_static.py",
            "game/tests/R8C_N14_1AManifestCodecV2SmokeDriver.gd",
            "game/tests/R8C_N14_1AManifestCodecV2SmokeTest.tscn",
        }
        for path in required | {
            "game/scripts/narrative_scene/SceneDefinition.gd",
            "game/scripts/unified_runtime/contracts/AuthoredSequenceV1.gd",
            "game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd",
            "game/scripts/narrative_scene/A5NarrativeStateCodec.gd",
            "game/scripts/narrative_state/EtatNarratif.gd",
        }:
            self.assertTrue((ROOT / path).is_file(), path)

    def test_positive_fixtures_have_exact_non_empty_bound_manifests(self):
        for name in (
            "authored_sequence_v1_minimal_valid.json",
            "n13_a10_durable_integration_valid.json",
        ):
            sequence = self.fixture(name)
            definition = sequence["orchestration"]["a6_entry"]["definition"]
            linked = 0
            for resolution_id, resolution in sequence["resolutions"].items():
                a10_resolution_id = resolution["a10_resolution_id"]
                if a10_resolution_id is None:
                    continue
                linked += 1
                manifest = definition["resolutions"][a10_resolution_id]["durable_manifest"]
                self.assertEqual(set(manifest), MANIFEST_FIELDS)
                self.assertTrue(any(manifest[field] for field in MANIFEST_FIELDS - {"binding"}))
                self.assertEqual(set(manifest["binding"]), BINDING_FIELDS)
                self.assertEqual(
                    manifest["binding"],
                    {
                        "sequence_id": sequence["sequence_id"],
                        "authored_version": sequence["authored_version"],
                        "resolution_id": resolution_id,
                    },
                )
                entries = [
                    entry
                    for category in DURABLE_CATEGORIES
                    for entry in manifest[category]
                ]
                self.assertEqual(
                    [entry["event_key"] for entry in entries],
                    [event_ref["event_key"] for event_ref in resolution["event_refs"]],
                )
                self.assertEqual(
                    [entry["fact"]["fait_id"] for entry in manifest["facts"]],
                    resolution["fact_ids"],
                )
                self.assertEqual(
                    [entry["knowledge_id"] for entry in manifest["knowledge"]],
                    resolution["knowledge_ids"],
                )
                self.assertEqual(
                    [entry["trace_id"] for entry in manifest["traces"]],
                    resolution["trace_ids"],
                )
                for category, authored_field, id_field in (
                    ("promises", "promise_effects", "promise_id"),
                    ("obligations", "obligation_effects", "obligation_id"),
                    ("media_deliveries", "media_effects", "media_id"),
                ):
                    self.assertEqual(
                        [
                            {id_field: entry[id_field], "effect": entry["effect"]}
                            for entry in manifest[category]
                        ],
                        [
                            effect
                            for effect in resolution[authored_field]
                            if effect["effect"] != "NONE"
                        ],
                    )
            self.assertGreater(linked, 0)

    def test_both_a6_validators_duplicate_the_same_closed_manifest_contract(self):
        scene = self.read("game/scripts/narrative_scene/SceneDefinition.gd")
        authored = self.read("game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd")
        for token in MANIFEST_FIELDS | BINDING_FIELDS | {
            "RELATION_CENTRALE",
            "ACQUIRE",
            "CREATE_DUE",
            "CREATE_DIEGETIC",
            "GRANT_ACCESS",
            "REVOKE_ACCESS",
            "WITHDRAW",
        }:
            self.assertIn(f'"{token}"', scene)
            self.assertIn(f'"{token}"', authored)
        for function in (
            "_valider_manifeste_durable",
            "_valider_effet_durable",
            "_valider_fait_durable",
        ):
            self.assertIn(f"static func {function}", scene)
        for function in (
            "_validate_a6_durable_manifest",
            "_validate_a6_durable_effect",
            "_validate_a6_manifest_binding",
            "_validate_a6_manifest_authored_effects",
            "_authored_non_none_effects",
        ):
            self.assertIn(f"static func {function}", authored)
        self.assertNotIn("SceneDefinition", authored)

    def test_authored_media_withdraw_keeps_schema_v1(self):
        contract = self.read("game/scripts/unified_runtime/contracts/AuthoredSequenceV1.gd")
        self.assertIn("const SCHEMA_VERSION := 1", contract)
        media_effects = re.search(r"const MEDIA_EFFECTS := \[(.*?)\]", contract)
        self.assertIsNotNone(media_effects)
        self.assertEqual(
            [
                "CREATE_DIEGETIC",
                "GRANT_ACCESS",
                "REVOKE_ACCESS",
                "WITHDRAW",
                "NONE",
            ],
            re.findall(r'"([A-Z_]+)"', media_effects.group(1)),
        )

    def test_authored_terminal_obligation_creation_effects_are_exact(self):
        contract = self.read("game/scripts/unified_runtime/contracts/AuthoredSequenceV1.gd")
        obligation_effects = re.search(r"const OBLIGATION_EFFECTS := \[(.*?)\]", contract, re.S)
        self.assertIsNotNone(obligation_effects)
        self.assertEqual(
            ["CREATE_DUE", "CREATE_PAID", "CREATE_FAILED", "PAY", "FAIL", "NONE"],
            re.findall(r'"([A-Z_]+)"', obligation_effects.group(1)),
        )

    def test_manifest_validation_preserves_authored_order_and_has_no_generic_architecture(self):
        scene = self.read("game/scripts/narrative_scene/SceneDefinition.gd")
        authored = self.read("game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd")
        scene_manifest = scene[
            scene.index("static func _valider_manifeste_durable") : scene.index("static func _valider_choix")
        ]
        authored_manifest = authored[
            authored.index("static func _validate_a6_durable_manifest") : authored.index("static func _validate_a6_relational_facts")
        ]
        self.assertNotIn(".sort()", scene_manifest)
        self.assertNotIn(".sort()", authored_manifest)
        for forbidden in ("service_locator", "event_bus", "schema_registry", "plugin_registry"):
            self.assertNotIn(forbidden, (scene_manifest + authored_manifest).lower())

    def test_codec_v2_has_exact_historical_roots_and_controlled_v1_normalization(self):
        codec = self.read("game/scripts/narrative_scene/A5NarrativeStateCodec.gd")
        state = self.read("game/scripts/narrative_state/EtatNarratif.gd")
        self.assertIn("const FORMAT_VERSION := 2", codec)
        self.assertIn("const FORMAT_VERSION := 2", state)
        root_block = re.search(r"const CHAMPS_ETAT := \[(.*?)\n\]", codec, re.S)
        self.assertIsNotNone(root_block)
        roots = set(re.findall(r'"([a-z_]+)"', root_block.group(1)))
        self.assertEqual(roots, NARRATIVE_ROOTS_V2)
        for token in (
            'etat.duplicate(true)',
            'candidat.has("format_version")',
            'typeof(candidat["format_version"]) != TYPE_INT',
            'candidat["format_version"] = FORMAT_VERSION',
            "not candidat[registre].is_empty()",
            "EtatNarratifModele.creer_depuis_snapshot(normalise)",
        ):
            self.assertIn(token, codec)
        self.assertNotIn('"progression"', codec)
        self.assertNotIn('"events"', codec)

    def test_five_registry_records_are_closed_and_transitions_are_checked(self):
        codec = self.read("game/scripts/narrative_scene/A5NarrativeStateCodec.gd")
        expected_functions = {
            "_connaissances_valides",
            "_traces_valides",
            "_promesses_valides",
            "_obligations_valides",
            "_livraisons_medias_valides",
            "_provenance_durable_valide",
            "_tableau_identifiants_valide",
        }
        for function in expected_functions:
            self.assertIn(f"static func {function}", codec)
        for status in (
            "KNOWN",
            "ACTIVE",
            "WITHDRAWN",
            "PAID",
            "FAILED",
            "DUE",
            "LOCKED",
            "ACCESSIBLE",
            "REVOKED",
            "HIDDEN",
            "AVAILABLE",
        ):
            self.assertIn(f'"{status}"', codec)
        for field in (
            "event_id",
            "source_scene_id",
            "source_scene_instance_id",
            "source_a10_choice_id",
            "source_a10_resolution_id",
            "source_sequence_id",
            "source_authored_version",
            "source_resolution_id",
            "moment_diegetique",
        ):
            self.assertIn(f'"{field}"', codec)

    def test_smoke_covers_required_manifest_and_codec_failures(self):
        smoke = self.read("game/tests/R8C_N14_1AManifestCodecV2SmokeDriver.gd")
        required_labels = (
            "local manifest absent accepted",
            "local empty manifest accepted",
            "minimal durable manifest valid",
            "local authored NONE has no manifest entry or event_key",
            "six ordered categories accepted",
            "CREATE_PAID complete obligation accepted with authored projection",
            "CREATE_FAILED complete obligation accepted with authored projection",
            "CREATE_PAID terminal short shape rejected with parity",
            "CREATE_FAILED unknown field rejected with parity",
            "unknown obligation effect rejected with parity",
            "duplicate obligation business id rejected with parity",
            "unknown manifest category rejected",
            "incomplete binding rejected",
            "binding unknown field rejected",
            "divergent binding rejected",
            "divergent sequence binding rejected",
            "divergent version binding rejected",
            "committable resolution requires manifest",
            "committable effectless manifest rejected with parity",
            "non-empty local manifest rejected",
            "NONE present in manifest rejected",
            "manifest provenance rejected",
            "derived status rejected",
            "empty event key rejected",
            "duplicate event key in category rejected",
            "duplicate event key across categories rejected",
            "RELATION requires personnage_id",
            "RELATION_CENTRALE forbids personnage_id even null",
            "authored category and entry order preserved",
            "missing authored event_ref rejected",
            "extra authored event_ref rejected",
            "duplicate authored event_ref rejected",
            "divergent authored event_ref order rejected",
            "divergent authored fact_ids rejected",
            "divergent authored knowledge_ids rejected",
            "divergent authored trace_ids rejected",
            "divergent authored promise effect rejected",
            "divergent authored obligation effect rejected",
            "divergent authored media effect rejected",
            "manifest effect without authored representation rejected",
            "coherent authored manifest WITHDRAW accepted",
            "divergent authored manifest WITHDRAW rejected",
            "empty v2 snapshot valid",
            "v2 with all five registries valid",
            "v1 with missing registries accepted",
            "v1 with five empty registries accepted",
            "v1 normalized to complete v2",
            "accepted v1 input not mutated",
            "snapshot after v1 restoration is v2",
            "v1 with non-empty registry rejected",
            "explicit format version 1 rejected",
            "unknown format version rejected",
            "missing v2 root rejected",
            "wrong registry root type rejected",
            "unknown durable record field rejected",
            "unknown durable status rejected",
            "duplicate identifier array rejected",
            "incomplete provenance rejected",
            "record key identity divergence rejected",
            "N13 outer snapshot envelope remains v1",
        )
        for label in required_labels:
            self.assertIn(label, smoke)
        self.assertIn("R8C_N14_1A_MANIFEST_CODEC_V2: OK", smoke)
        self.assertIn("get_tree().quit(0)", smoke)
        self.assertIn("get_tree().quit(1)", smoke)

    def test_n14_1a_historical_scope_is_allowlisted_and_n13_protected(self):
        for label, sha in (
            ("N14.1a base", N14_1A_BASE_SHA),
            ("N14.1a final", N14_1A_FINAL_SHA),
        ):
            exists = subprocess.run(
                ["git", "cat-file", "-e", f"{sha}^{{commit}}"],
                cwd=ROOT,
                capture_output=True,
                text=True,
            )
            self.assertEqual(exists.returncode, 0, f"missing historical commit: {label} {sha}")
        base_to_final = subprocess.run(
            ["git", "merge-base", "--is-ancestor", N14_1A_BASE_SHA, N14_1A_FINAL_SHA],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )
        self.assertEqual(
            base_to_final.returncode,
            0,
            "invalid N14.1a history: base is not an ancestor of final",
        )
        final_to_head = subprocess.run(
            ["git", "merge-base", "--is-ancestor", N14_1A_FINAL_SHA, "HEAD"],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )
        self.assertEqual(
            final_to_head.returncode,
            0,
            "invalid N14.1a history: final is not an ancestor of HEAD",
        )
        changed = set(
            subprocess.check_output(
                [
                    "git",
                    "diff",
                    "--name-only",
                    f"{N14_1A_BASE_SHA}..{N14_1A_FINAL_SHA}",
                ],
                cwd=ROOT,
                text=True,
            ).splitlines()
        )
        self.assertFalse(changed & PROTECTED_N13, changed & PROTECTED_N13)
        self.assertTrue(changed <= ALLOWED_PATHS, changed - ALLOWED_PATHS)
        snapshot = self.read("game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd")
        self.assertIn('const SCHEMA_ID := "reseau_intime.unified_runtime"', snapshot)
        self.assertIn("const SCHEMA_VERSION := 1", snapshot)
        self.assertIn('const DOMAIN_FIELDS := ["version", "narrative_state", "scene_registry"]', snapshot)

    def test_no_durable_publication_reducer_disk_ui_or_legacy_wiring_was_added(self):
        production_paths = (
            "game/scripts/narrative_scene/SceneDefinition.gd",
            "game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd",
            "game/scripts/narrative_scene/A5NarrativeStateCodec.gd",
            "game/scripts/narrative_state/EtatNarratif.gd",
        )
        diff = subprocess.check_output(
            [
                "git",
                "diff",
                "--unified=0",
                f"{N14_1A_BASE_SHA}..{N14_1A_FINAL_SHA}",
                "--",
                *production_paths,
            ],
            cwd=ROOT,
            text=True,
        )
        production = "\n".join(
            line[1:] for line in diff.splitlines() if line.startswith("+") and not line.startswith("+++")
        )
        for forbidden in (
            "resolve_scene",
            "FileAccess",
            "user://",
            "PhotoViewer",
            "Galerie",
            "Mathilde",
            "legacy",
            "score",
            "ReducerKnowledge",
            "ReducerPromise",
            "ReducerObligation",
            "ReducerMedia",
        ):
            self.assertNotIn(forbidden.lower(), production.lower())


if __name__ == "__main__":
    unittest.main()
