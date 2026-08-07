import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
APP = GAME / "scripts/unified_runtime/application"
CONTRACTS = GAME / "scripts/unified_runtime/contracts"
BOOTSTRAP = GAME / "scripts/unified_runtime/bootstrap/UnifiedPlayerRuntimeCompositionRoot.gd"
PRODUCTION_CATALOG = GAME / "data/unified_runtime/catalogs/season_1_v1.json"
FIXTURES = GAME / "tests/fixtures/unified_runtime"


class R8CN18CanonicalCatalogSeasonRunnerStaticTests(unittest.TestCase):
    def read(self, path: Path) -> str:
        return path.read_text(encoding="utf-8")

    def load(self, path: Path):
        return json.loads(self.read(path))

    def test_closed_catalog_contract_and_production_manifest(self):
        contract = self.read(CONTRACTS / "AuthoredSequenceCatalogV1.gd")
        validator = self.read(CONTRACTS / "AuthoredSequenceCatalogValidator.gd")
        for proof in [
            'const SCHEMA_ID := "reseau_intime.authored_sequence_catalog"',
            'const SCHEMA_VERSION := 1',
            '"package_id", "sequence_id", "authored_version", "sequence_path"',
            '"messages_path", "physical_path", "media_path"',
            "JSON.stringify(canonical_manifest(value)",
            ".sha256_text()",
        ]:
            self.assertIn(proof, contract)
        for proof in [
            "FORBIDDEN_PREFIXES",
            '"res://data/runtime/season_1/"',
            '"res://data/conversations/"',
            "FileAccess.file_exists(path)",
            '"message_id", errors',
            "duplicate_global_media_id",
        ]:
            self.assertIn(proof, validator)
        catalog = self.load(PRODUCTION_CATALOG)
        self.assertEqual(
            {"schema_id", "schema_version", "catalog_id", "season_id", "packages"},
            set(catalog),
        )
        self.assertEqual("season_1_v1", catalog["catalog_id"])
        self.assertEqual("season_1", catalog["season_id"])
        self.assertEqual(1, len(catalog["packages"]))
        package = catalog["packages"][0]
        self.assertEqual("mathilde_returns_with_chosen_intent_01", package["sequence_id"])
        self.assertNotIn("tests/fixtures", json.dumps(catalog))
        self.assertNotIn("data/runtime/season_1", json.dumps(catalog))

    def test_loader_builds_one_multi_entry_library_and_catalog_indexes(self):
        loader = self.read(APP / "AuthoredSequenceCatalogLoader.gd")
        self.assertEqual(1, loader.count("LibraryModel.charger_depuis_bundle"))
        for proof in [
            '"definitions": definitions',
            '"package_by_candidate_key"',
            '"package_by_sequence_id"',
            '"messages_metadata"',
            '"message_definitions"',
            '"choice_definitions"',
            "CatalogMediaResolver.create",
        ]:
            self.assertIn(proof, loader)
        self.assertNotIn("DirAccess", loader)
        self.assertNotIn("get_files", loader.lower())

    def test_production_entry_is_closed_and_test_injection_is_explicit(self):
        portrait = self.read(GAME / "scripts/ui/PortraitMain.gd")
        runner = self.read(APP / "UnifiedSeasonRunner.gd")
        self.assertNotIn("unified_catalog_path_override", portrait)
        self.assertNotIn("create_for_test", portrait)
        self.assertNotIn("n18_catalog_alpha_beta", portrait)
        self.assertIn("UnifiedSeasonRunner.create(", portrait)
        for proof in [
            'const PRODUCTION_CATALOG_PATH := "res://data/unified_runtime/catalogs/season_1_v1.json"',
            'const PRODUCTION_CATALOG_ID := "season_1_v1"',
            'const PRODUCTION_SEASON_ID := "season_1"',
            "static func create_for_test(",
            "PRODUCTION_CATALOG_PATH,",
            "PRODUCTION_CATALOG_ID,",
            "PRODUCTION_SEASON_ID,",
        ]:
            self.assertIn(proof, runner)
        smoke = self.read(GAME / "tests/R8C_N18CanonicalCatalogSeasonRunnerSmokeDriver.gd")
        self.assertIn("SeasonRunner.create_for_test", smoke)
        self.assertIn("PortraitShellScene.instantiate()", smoke)
        self.assertNotIn("main.unified_catalog_path_override", smoke)

    def test_sequence_and_choice_indexes_are_globally_fail_closed(self):
        validator = self.read(CONTRACTS / "AuthoredSequenceCatalogValidator.gd")
        loader = self.read(APP / "AuthoredSequenceCatalogLoader.gd")
        for proof in [
            "var sequence_ids := {}",
            'errors.append(path + ".sequence_id:duplicate")',
            "var sequence_versions := {}",
            "var choice_ids := {}",
            "_register_global_choice_identities",
            '"choice_id",',
        ]:
            self.assertIn(proof, validator)
        sequence_guard = loader.index("if package_by_sequence_id.has(sequence_id):")
        sequence_write = loader.index("package_by_sequence_id[sequence_id] = package")
        choice_guard = loader.index("if choice_definitions.has(choice_id):")
        choice_write = loader.index("choice_definitions[choice_id] = {")
        self.assertLess(sequence_guard, sequence_write)
        self.assertLess(choice_guard, choice_write)
        self.assertIn('return _failure("DUPLICATE_SEQUENCE_ID")', loader)
        self.assertIn('"error_code": "DUPLICATE_GLOBAL_CHOICE_ID"', loader)

    def test_collision_fixtures_lock_sequence_and_choice_identity(self):
        duplicate_sequence = self.load(FIXTURES / "n18_catalog_duplicate_sequence_id.json")
        self.assertEqual(
            [("foo", "1.0.0"), ("foo", "2.0.0")],
            [
                (package["sequence_id"], package["authored_version"])
                for package in duplicate_sequence["packages"]
            ],
        )
        duplicate_choice = self.load(FIXTURES / "n18_catalog_duplicate_choice_id.json")
        shared_choices = []
        shared_texts = []
        for package in duplicate_choice["packages"]:
            sequence = self.load(GAME / package["sequence_path"].removeprefix("res://"))
            choices = [
                choice
                for beat in sequence["beats"] if beat["type"] == "CHOICE"
                for choice in beat["content"]["choices"]
            ]
            shared_choices.extend(choice["choice_id"] for choice in choices)
            shared_texts.extend(choice["text"] for choice in choices)
        self.assertEqual(["shared_choice", "shared_choice"], shared_choices)
        self.assertEqual(2, len(set(shared_texts)))
        smoke = self.read(GAME / "tests/R8C_N18CanonicalCatalogSeasonRunnerSmokeDriver.gd")
        for proof in [
            "chaque package shared_choice reste valide isolément",
            "duplicate_global_choice_id:shared_choice",
            "le snapshot Saison reste valide pendant le handoff Alpha vers Beta",
        ]:
            self.assertIn(proof, smoke)

    def test_runner_is_single_active_and_selects_in_manifest_order(self):
        runner = self.read(APP / "UnifiedSeasonRunner.gd")
        for proof in [
            'const IDLE_NO_ELIGIBLE_SEQUENCE := "IDLE_NO_ELIGIBLE_SEQUENCE"',
            "var completed_sequence_ids: Array = []",
            'return _publish(false, "SECOND_ACTIVE_SEQUENCE_REFUSED")',
            "for package in catalog[\"packages\"]",
            "var package: Dictionary = eligible[0]",
            "completed_sequence_ids.append(completed_id)",
            "previous_session.detach()",
            "active_session_changed.emit(previous_session, active_session)",
        ]:
            self.assertIn(proof, runner)
        for forbidden in ["ranking", "priority", "random", "sort_custom", "next_sequence_id"]:
            self.assertNotIn(forbidden, runner.lower())
        smoke = self.read(GAME / "tests/R8C_N18CanonicalCatalogSeasonRunnerSmokeDriver.gd")
        for proof in [
            'CATALOG_BETA_ALPHA',
            'active_sequence_id == "test_sequence_beta"',
            'completed_sequence_ids == ["test_sequence_alpha", "test_sequence_beta"]',
            "IDLE_NO_ELIGIBLE_SEQUENCE",
            "la Galerie catalogue-wide expose les médias durables des deux séquences",
        ]:
            self.assertIn(proof, smoke)

    def test_snapshot_v2_is_unchanged_and_season_envelope_is_external(self):
        v2 = self.read(APP / "UnifiedRuntimeSnapshotV2.gd")
        self.assertIn('const SCHEMA_VERSION := 2', v2)
        for field in ["catalog_id", "catalog_fingerprint", "completed_sequence_ids", "season_id"]:
            self.assertNotIn(field, v2)
        season = self.read(APP / "UnifiedSeasonSnapshotV1.gd")
        for field in [
            '"catalog_id"', '"catalog_fingerprint"', '"season_id"',
            '"active_sequence_id"', '"completed_sequence_ids"',
            '"active_runtime_snapshot"', '"persistent_messages_state"',
        ]:
            self.assertIn(field, season)
        self.assertIn("migrate_n17_v2", season)
        self.assertIn("RuntimeSnapshotV2.validate", season)

    def test_test_only_packages_are_real_closed_packages_and_not_production(self):
        manifests = [
            self.load(FIXTURES / "n18_catalog_alpha_beta.json"),
            self.load(FIXTURES / "n18_catalog_beta_alpha.json"),
        ]
        self.assertEqual(
            ["test_sequence_alpha", "test_sequence_beta"],
            [item["sequence_id"] for item in manifests[0]["packages"]],
        )
        self.assertEqual(
            ["test_sequence_beta", "test_sequence_alpha"],
            [item["sequence_id"] for item in manifests[1]["packages"]],
        )
        global_messages = set()
        global_media = set()
        for sequence_name in ["alpha", "beta"]:
            sequence = self.load(FIXTURES / f"n18_test_sequence_{sequence_name}.json")
            messages = self.load(FIXTURES / f"n18_test_sequence_{sequence_name}_messages.json")
            physical = self.load(FIXTURES / f"n18_test_sequence_{sequence_name}_physical.json")
            media = self.load(FIXTURES / f"n18_test_sequence_{sequence_name}_media.json")
            self.assertEqual(f"test_sequence_{sequence_name}", sequence["sequence_id"])
            self.assertEqual(sequence["sequence_id"], messages["sequence_id"])
            self.assertEqual(sequence["sequence_id"], physical["sequence_id"])
            self.assertEqual(sequence["sequence_id"], media["sequence_id"])
            ids = {
                message["message_id"]
                for beat in sequence["beats"] if beat["type"] == "MESSAGE"
                for message in beat["content"]["messages"]
            } | {
                message["message_id"]
                for entry in messages["entries"] for message in entry["messages"]
            }
            self.assertTrue(global_messages.isdisjoint(ids))
            global_messages |= ids
            media_ids = set(sequence["media"])
            self.assertTrue(global_media.isdisjoint(media_ids))
            global_media |= media_ids
        self.assertEqual(1, len(self.load(PRODUCTION_CATALOG)["packages"]))

    def test_handoff_disconnects_old_ui_providers_and_physical_is_session_local(self):
        session = self.read(APP / "UnifiedPlayerRuntimeSession.gd")
        shell = self.read(GAME / "scripts/ui/PortraitShell.gd")
        media = self.read(GAME / "scripts/unified_runtime/projection/MediaUIProjectionAdapter.gd")
        physical = self.read(GAME / "scripts/unified_runtime/projection/PhysicalUIProjectionAdapter.gd")
        self.assertIn("func detach()", session)
        self.assertIn("_projection_coordinator.detach()", session)
        self.assertIn("_disconnect_unified_runtime_provider", shell)
        self.assertIn("gallery_source_changed.disconnect", shell)
        self.assertIn("media_presented.disconnect", media)
        self.assertIn("close_requested.disconnect", media)
        self.assertIn("continue_requested.disconnect", physical)
        self.assertIn("_screen.queue_free()", physical)
        bootstrap = self.read(BOOTSTRAP)
        self.assertIn("compose_package(", bootstrap)
        self.assertIn("PhysicalScreenScene.instantiate()", bootstrap)
        self.assertNotIn("const SEQUENCE_PATH", bootstrap)
        self.assertNotIn("const MESSAGES_PATH", bootstrap)


if __name__ == "__main__":
    unittest.main()
