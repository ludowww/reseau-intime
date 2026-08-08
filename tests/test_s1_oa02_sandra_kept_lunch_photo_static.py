import hashlib
import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
DATA = GAME / "data/unified_runtime"
SEQUENCE = DATA / "sequences/sandra_kept_lunch_photo_01.json"
MESSAGES = DATA / "presentation/sandra_kept_lunch_photo_01_messages.json"
PHYSICAL = DATA / "presentation/sandra_kept_lunch_photo_01_physical.json"
MEDIA = DATA / "presentation/sandra_kept_lunch_photo_01_media.json"
PRODUCTION = DATA / "catalogs/season_1_v1.json"
SOURCE = GAME / "data/conversations/chapter_01_sandra_trace.json"
CANON = ROOT / "docs/canon/dialogues/J01_J06_SOURCE_CANON_CONSOLIDE.md"
PROOFS = GAME / "data/visual_content/chapter_01_proofs.json"
RUNTIME_MAP = GAME / "data/runtime/season_1/j01_runtime_map.json"
CAPABILITY = GAME / "tests/fixtures/unified_runtime/capability_catalog_n17_n22.json"
OA01_BASELINE_CATALOG = GAME / "tests/fixtures/unified_runtime/s1_oa01_baseline_catalog.json"
POLICY = ROOT / "docs/runtime/README.md"

OA01_HASHES = {
    "data/unified_runtime/sequences/marie_bread_and_ten_minutes_01.json": "631ba58cccdeff009d9e4946566eb24e3bcb59f335dee2493110515dd8fd8943",
    "data/unified_runtime/presentation/marie_bread_and_ten_minutes_01_messages.json": "df7a4eaccc1da2d5de39290474434e589c5d517930580c7f31c02321d4719bc5",
    "data/unified_runtime/presentation/marie_bread_and_ten_minutes_01_physical.json": "26d26a50b09333551eb5ef662a44c01c4ca77c2141800404885b997eb2cf9639",
    "data/unified_runtime/presentation/marie_bread_and_ten_minutes_01_media.json": "30ab44f75ae8f8f86d1faa6adb823bf5cadbfe348279d96b8ae6202400241ba1",
}

FROZEN_CORE = {
    "scripts/shared/DurableMediaIdentifier.gd": "c99102011d3df95e8fbb1de6bc1a4c7094eaf4c406a31e8bcab118095d7064bf",
    "scripts/narrative_state/EtatNarratif.gd": "8cf164a6ca931f92fd0039becbf1bfdfa416801609010495e57c5931dafa177e",
    "scripts/narrative_scene/MinimalSceneEngine.gd": "e08a07193f807b1effd5c753d056fd0fb61c19626683476ddab7919c2f811420",
    "scripts/narrative_scene/PersistentSceneRegistry.gd": "c1c119fc066e9406deb3d8c9bb0dea4de4df199a00a232de19dfeb2380b2ca1c",
    "scripts/narrative_scene/A5NarrativeStateCodec.gd": "66daaea65f5fcabefd4840f31136c1c4ae0a4f184666338e3741f0a52a54eff7",
    "scripts/narrative_scene/NarrativeSceneLibrary.gd": "4b7f5b0c6e6aa3e87eadee961cd4a2f74f486752e80503693adc75e7e9883af4",
    "scripts/narrative_scene/CandidateReservationProposalCoordinator.gd": "3a1d49aaf8fa4f0862ac7a5a518951361b9d67872285bddfa19e706815f75d43",
    "scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd": "a118de33f8092e59bad156d1411bcf471789b21545982376b5f6da7cdf1bff65",
    "scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd": "033e9901a565693d944d23548dca2a65fbe9f23bc5f73232cacfaffb6a41ab92",
    "scripts/narrative_scene/SequenceResolutionCommitCoordinator.gd": "83498f208e4cd0242ea38a992cef19d083141018781c0d12634b725ff29c5d02",
    "scripts/narrative_scene/NarrativeOrchestrationFacade.gd": "338433a0331f9d527c66c9ed7730491e8332e422b00cc617409314a1debcbd09",
    "scripts/unified_runtime/contracts/AuthoredSequenceV1.gd": "10f6e3441569f16d5b29643a9a815ac8a2d7ca8529abb092137c42e6024b0fa7",
    "scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd": "24ab1f73eb049977483883a4ede18c539d38a753cde2cb0c35314a10e851892a",
    "scripts/unified_runtime/execution/SequenceExecutor.gd": "df5489acc55b7a041d3146ff5f90ba8d02a9b59fcca0f3793166ed0df6eeba53",
    "scripts/unified_runtime/application/SequenceExecutorV2.gd": "32cc8327d1a215b690f955dc86c2581aa84d3483a23d06ed0775eecd9cababb8",
    "scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd": "fbf8c2c0d6f1eb5bf10f64feb1dcac1e4907a98bd2e165dbcf8dfafff0813d9c",
    "scripts/unified_runtime/application/UnifiedRuntimeSnapshotV2.gd": "c88f40499a923bb4af3cfff6e8157177aa8465d7f1fc377beb75f1cf49f0e4a5",
    "scripts/unified_runtime/application/UnifiedSeasonSnapshotV2.gd": "9e1ec24556f699dc2ee8ef7408b81b195aac567c3c30f1ed98b9a2045e153f18",
    "scripts/unified_runtime/application/UnifiedSeasonRunner.gd": "622e5e0af6f0561d200fd7e6b7e509a67accef3cb675a7cef9b59e51a23f3521",
    "scripts/ui/messages/MessagesScreen.gd": "d1d7221f3a0fc749532811784d8804627164623c5ada1b76f64b2f352033582c",
    "scripts/ui/gallery/GalleryScreen.gd": "4ccc13ae1ff79cadecde4a2d95172c858e474d95d828d47b75eaa8786704a283",
    "scripts/ui/gallery/PhotoViewer.gd": "4db60964f2f17989a85d7fb7befdb0cb6f1545891595cfb0a846409e4975bb77",
}

HISTORICAL_TRACE_ID = "j01_sandra_lunch_memory_soft"
RUNTIME_TRACE_ID = "sandra_kept_lunch_photo_private_trace"
HISTORICAL_MEDIA_ID = "S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01"
RUNTIME_MEDIA_ID = "s1_opening_sandra_lunch_selected_01"
KNOWLEDGE_ID = "fact_player_saw_sandra_lunch_photo"


class S1OA02SandraKeptLunchPhotoStaticTests(unittest.TestCase):
    def load(self, path: Path):
        return json.loads(path.read_text(encoding="utf-8"))

    def sha256(self, path: Path) -> str:
        return hashlib.sha256(path.read_bytes()).hexdigest()

    def test_locked_sources_oa01_and_capability_suite_are_blob_identical(self):
        self.assertEqual(
            "010d7dd83e3202cee7a7f5a6a6019f583f31cf4ca304afcbfaa7db114f66d807",
            self.sha256(SOURCE),
        )
        self.assertEqual(
            "de54e9da78ddb44dd02f570fca1c6a765dd19acf109a126c49f1a20e2475ed8a",
            self.sha256(CANON),
        )
        self.assertEqual(
            "8efd0def581567d4efa59ef246f00bc118bcd27cc79506a5c2cdaa3edf659e0f",
            self.sha256(PROOFS),
        )
        self.assertEqual(
            "7f061120faf6cfeb36ce72710d47c2a8df394bb5330abaf7bf0d6076762f1fa4",
            self.sha256(RUNTIME_MAP),
        )
        self.assertEqual(
            "146ceff348f4411941d9b5041b1450d775a44135ed74c465dcd745d19efddd4c",
            self.sha256(CAPABILITY),
        )
        for relative, expected in OA01_HASHES.items():
            self.assertEqual(expected, self.sha256(GAME / relative), relative)

        from tests.test_s1_oa01_marie_bread_and_ten_minutes_static import (
            CAPABILITY_IDS,
            PROTECTED_HASHES,
        )

        capability = self.load(CAPABILITY)
        self.assertEqual(CAPABILITY_IDS, [item["sequence_id"] for item in capability["packages"]])
        self.assertEqual(20, len(PROTECTED_HASHES))
        for relative, expected in PROTECTED_HASHES.items():
            self.assertEqual(expected, self.sha256(GAME / relative), relative)

        oa01_catalog = self.load(OA01_BASELINE_CATALOG)
        production = self.load(PRODUCTION)
        self.assertEqual(production["packages"][:1], oa01_catalog["packages"])
        serialized = json.dumps(oa01_catalog, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
        self.assertEqual(
            "13933f53a12cd8665a78e6f1714ef47627d7768c4087b18fdf43ea43e931ed57",
            hashlib.sha256(serialized.encode("utf-8")).hexdigest(),
        )

    def test_production_catalog_is_exactly_marie_then_sandra(self):
        catalog = self.load(PRODUCTION)
        self.assertEqual(
            ["marie_bread_and_ten_minutes_01", "sandra_kept_lunch_photo_01"],
            [item["sequence_id"] for item in catalog["packages"]],
        )
        self.assertEqual(2, len(catalog["packages"]))

    def test_authored_identity_and_modern_ids_exclude_historical_day_tokens(self):
        sequence = self.load(SEQUENCE)
        self.assertEqual(
            ("sandra_kept_lunch_photo_01", "1.0.0", "season_1", "movement_i", "RELATION", "CANON_APPROVED"),
            (
                sequence["sequence_id"],
                sequence["authored_version"],
                sequence["season_id"],
                sequence["dramatic_movement_id"],
                sequence["narrative_function"],
                sequence["canonical_status"],
            ),
        )
        provenance = sequence["author_provenance"]
        self.assertEqual([HISTORICAL_MEDIA_ID], provenance["source_sequence_ids"])
        runtime_sequence = {key: value for key, value in sequence.items() if key != "author_provenance"}
        runtime_ids = []

        def collect_ids(value):
            if isinstance(value, dict):
                for key, child in value.items():
                    if key.endswith("_id") and isinstance(child, str):
                        runtime_ids.append(child)
                    elif key.endswith("_ids") and isinstance(child, list):
                        runtime_ids.extend(item for item in child if isinstance(item, str))
                    collect_ids(child)
            elif isinstance(value, list):
                for child in value:
                    collect_ids(child)

        collect_ids([runtime_sequence, self.load(MESSAGES), self.load(PHYSICAL), self.load(MEDIA)])
        self.assertFalse(any(re.search(r"(?:j01|j1_|day_|chapter_)", item, re.I) for item in runtime_ids))

    def test_historical_to_runtime_identity_mapping_is_explicit_and_lossless(self):
        sequence = self.load(SEQUENCE)
        canon = CANON.read_text(encoding="utf-8")
        proofs = self.load(PROOFS)
        runtime_map = self.load(RUNTIME_MAP)
        authored_runtime = json.dumps(
            {key: value for key, value in sequence.items() if key != "author_provenance"},
            ensure_ascii=False,
        )

        self.assertIn(HISTORICAL_TRACE_ID, canon)
        self.assertIn(HISTORICAL_TRACE_ID, json.dumps(runtime_map))
        self.assertIn(HISTORICAL_MEDIA_ID, json.dumps([proofs, runtime_map]))
        self.assertEqual([HISTORICAL_MEDIA_ID], sequence["author_provenance"]["source_sequence_ids"])
        self.assertNotIn(HISTORICAL_TRACE_ID, authored_runtime)
        self.assertNotIn(HISTORICAL_MEDIA_ID, authored_runtime)
        self.assertIn(RUNTIME_TRACE_ID, authored_runtime)
        self.assertIn(RUNTIME_MEDIA_ID, authored_runtime)

    def test_graph_has_two_local_guided_choices_media_and_three_durable_postures(self):
        sequence = self.load(SEQUENCE)
        self.assertEqual(
            ["MESSAGE", "CHOICE", "MESSAGE", "MEDIA_REVEAL", "CHOICE", "MESSAGE", "CHOICE"],
            [beat["type"] for beat in sequence["beats"][:7]],
        )
        choices = [beat for beat in sequence["beats"] if beat["type"] == "CHOICE"]
        self.assertEqual([1, 1, 3], [len(beat["content"]["choices"]) for beat in choices])
        self.assertEqual(
            ["De quoi ?", "Tu l'avais gardée ?"],
            [beat["content"]["choices"][0]["text"] for beat in choices[:2]],
        )
        local = [
            sequence["resolutions"]["resolution_photo_subject_guided"],
            sequence["resolutions"]["resolution_photo_kept_guided"],
        ]
        self.assertTrue(all(item["a10_choice_id"] is None and item["a10_resolution_id"] is None for item in local))
        self.assertTrue(all(not item["event_refs"] for item in local))
        self.assertEqual(
            [
                "Je suis content que tu l'aies gardée.",
                "Tu as choisi celle où tu souriais.",
                "Ah oui. Je me souviens.",
            ],
            [item["text"] for item in choices[2]["content"]["choices"]],
        )
        reveal = [beat for beat in sequence["beats"] if beat["type"] == "MEDIA_REVEAL"]
        self.assertEqual(1, len(reveal))
        self.assertEqual(RUNTIME_MEDIA_ID, reveal[0]["content"]["media_id"])

    def test_source_text_and_branch_condition_are_preserved_in_order(self):
        source = self.load(SOURCE)
        authored = json.dumps([self.load(SEQUENCE), self.load(MESSAGES)], ensure_ascii=False)
        for segment in source["segments"]:
            for message in segment["messages"]:
                self.assertIn(message["text"], authored)
            for choice in segment["choices"]:
                self.assertIn(choice["text"], authored)
                for message in choice["next_messages"]:
                    self.assertIn(message["text"], authored)

        entries = {item["content_ref"]: item["messages"] for item in self.load(MESSAGES)["entries"]}
        precise = entries["sandra_photo_intention_noticed_return_content"]
        precise_text = [item["text"] for item in precise]
        conditional = "Et pour la photo... je n'ai pas choisi celle-là au hasard."
        self.assertIn(conditional, precise_text)
        self.assertNotIn(conditional, [item["text"] for item in entries["sandra_kept_photo_warm_return_content"]])
        self.assertNotIn(conditional, [item["text"] for item in entries["sandra_photo_memory_contained_return_content"]])
        self.assertLess(
            precise_text.index("Mais je n'ai pas choisi au hasard non plus."),
            precise_text.index("J'ai déjà passé trop de temps à choisir une photo que j'avais soi-disant juste retrouvée."),
        )

    def test_post_choice_guided_lines_are_messages_not_choices(self):
        sequence = self.load(SEQUENCE)
        messages = self.load(MESSAGES)
        guided = [
            "Merci. Je vais pas lui faire dire plus que ça.",
            "On s'arrête là pour ce soir ? Bonne nuit Sandra.",
        ]
        interactive = [
            choice["text"]
            for beat in sequence["beats"]
            if beat["type"] == "CHOICE"
            for choice in beat["content"]["choices"]
        ]
        for entry in messages["entries"]:
            self.assertEqual(guided, [item["text"] for item in entry["messages"] if item["author_id"] == "player"])
        for text in guided:
            self.assertNotIn(text, interactive)

    def test_each_posture_publishes_one_fact_and_shared_private_state_in_one_a10(self):
        sequence = self.load(SEQUENCE)
        a6 = sequence["orchestration"]["a6_entry"]["definition"]["resolutions"]
        expected = {
            "resolution_warm": "sandra_kept_photo_warmly_received",
            "resolution_precise": "sandra_photo_choice_intention_noticed",
            "resolution_cautious": "sandra_photo_memory_acknowledged_without_escalation",
        }
        all_facts = set(expected.values())
        for resolution_id, posture_fact in expected.items():
            resolution = sequence["resolutions"][resolution_id]
            self.assertIsNotNone(resolution["a10_choice_id"])
            self.assertIsNotNone(resolution["a10_resolution_id"])
            self.assertEqual([posture_fact], resolution["fact_ids"])
            self.assertEqual({posture_fact}, set(resolution["fact_ids"]) & all_facts)
            self.assertEqual([KNOWLEDGE_ID], resolution["knowledge_ids"])
            self.assertEqual([RUNTIME_TRACE_ID], resolution["trace_ids"])
            self.assertEqual([{"media_id": RUNTIME_MEDIA_ID, "effect": "GRANT_ACCESS"}], resolution["media_effects"])
            self.assertEqual([], resolution["promise_effects"])
            self.assertEqual([], resolution["obligation_effects"])
            manifest = a6[resolution["a10_resolution_id"]]["durable_manifest"]
            self.assertEqual((1, 1, 1, 0, 0, 1), tuple(len(manifest[key]) for key in ["facts", "knowledge", "traces", "promises", "obligations", "media_deliveries"]))
            trace = manifest["traces"][0]
            self.assertEqual(
                ("sandra", ["sandra", "player"], ["sandra"], ["sandra", "player"]),
                (trace["creator_id"], trace["audience_ids"], trace["controller_ids"], trace["accessible_to_ids"]),
            )
            self.assertEqual(["sandra", "player"], manifest["knowledge"][0]["holder_ids"])
            self.assertEqual(["sandra", "player"], manifest["media_deliveries"][0]["fictional_audience_ids"])

    def test_media_rights_placeholder_return_and_terminal_physical_are_closed(self):
        sequence = self.load(SEQUENCE)
        self.assertEqual([RUNTIME_MEDIA_ID], list(sequence["media"]))
        definition = sequence["media"][RUNTIME_MEDIA_ID]
        self.assertEqual(
            ("V0", "NV1", "SPECIFIED_NOT_PRODUCED", "DIEGETIC", "ON_ACCESS", "AUTHORED_RESOLUTION_ONLY"),
            (
                definition["visual_level"],
                definition["analytic_level"],
                definition["production_status"],
                definition["diegesis"],
                definition["gallery_policy"],
                definition["removal_policy"],
            ),
        )
        self.assertEqual(["sandra_player_private"], definition["audience_ids"])
        self.assertEqual(["sandra", "player"], sequence["participants"]["initial_audiences"]["sandra_player_private"])
        presentation = self.load(MEDIA)["entries"]
        self.assertEqual(1, len(presentation))
        self.assertEqual("", presentation[0]["visual_ref"])
        self.assertEqual("Visuel non livré", presentation[0]["placeholder_label"])
        self.assertEqual(["sandra"], presentation[0]["gallery_character_ids"])

        returns = [beat for beat in sequence["beats"] if beat["type"] == "RETURN"]
        physical = [beat for beat in sequence["beats"] if beat["type"] == "PHYSICAL_BEAT"]
        self.assertEqual(3, len(returns))
        self.assertEqual(1, len(physical))
        self.assertTrue(all(beat["next"]["beat_id"] == physical[0]["beat_id"] for beat in returns))
        self.assertEqual("TERMINAL", physical[0]["next"]["mode"])
        physical_entry = self.load(PHYSICAL)["entries"][0]
        self.assertEqual("Player pose le téléphone et revient vers Marie.", physical_entry["body"])
        self.assertEqual(["La fin de soirée se déroule hors écran."], physical_entry["steps"])

        serialized = json.dumps([sequence, self.load(MESSAGES), self.load(MEDIA)], ensure_ascii=False).lower()
        for forbidden in ["forward", "wallpaper", "save_as", "transfer", "not_selected", "route_score"]:
            self.assertNotIn(forbidden, serialized)

    def test_runtime_core_is_blob_identical_and_save_policy_is_explicit(self):
        for relative, expected in FROZEN_CORE.items():
            self.assertEqual(expected, self.sha256(GAME / relative), relative)
        policy = POLICY.read_text(encoding="utf-8")
        self.assertIn("PRE_RELEASE_CATALOG_SAVE_POLICY", policy)
        self.assertIn("un autre fingerprint est refusé fail-closed", policy)
        self.assertIn("sans migration automatique", policy)

    def test_smoke_and_scene_lock_full_oa02_product_gate(self):
        smoke_path = GAME / "tests/S1_OA02SandraKeptLunchPhotoSmokeDriver.gd"
        scene_path = GAME / "tests/S1_OA02SandraKeptLunchPhotoSmokeTest.tscn"
        smoke = smoke_path.read_text(encoding="utf-8")
        for proof in [
            "fresh boot montre Marie seule",
            "Continuer avec Sandra",
            "zéro A5 Sandra avant activation",
            "save/reload reconstruit l'opportunité Sandra",
            "exactement un A10 Sandra",
            "un seul média Sandra disponible",
            "Player pose le téléphone et revient vers Marie.",
            "INVALID_SEASON_SAVE",
            "S1_OA02_NARRATIVE_REVIEW_BEGIN",
            "S1_OA02_NARRATIVE_REVIEW_END",
        ]:
            self.assertIn(proof, smoke)
        self.assertIn(smoke_path.name, scene_path.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
