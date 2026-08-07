import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
APP = ROOT / "game/scripts/unified_runtime/application"
BOOTSTRAP = ROOT / "game/scripts/unified_runtime/bootstrap/UnifiedPlayerRuntimeCompositionRoot.gd"
SEQUENCE = ROOT / "game/data/unified_runtime/sequences/mathilde_returns_with_chosen_intent_01.json"
MESSAGES = ROOT / "game/data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_messages.json"
MEDIA = ROOT / "game/data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_media.json"
SMOKE = ROOT / "game/tests/R8C_N17UnifiedPlayerBootstrapSmokeDriver.gd"

MEDIA_IDS = [
    "S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY",
    "S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01",
    "S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01",
]


class R8CN17UnifiedPlayerBootstrapStaticTests(unittest.TestCase):
    def read(self, path: Path) -> str:
        return path.read_text(encoding="utf-8")

    def test_v2_is_versioned_outside_closed_v1_directories(self):
        expected = {
            "DeferredReturnGate.gd",
            "JsonValueNormalizer.gd",
            "NarrativeMoment.gd",
            "ReferencedMessagesContentResolver.gd",
            "ReferencedMessagesUIProjectionAdapter.gd",
            "SequenceExecutionV2.gd",
            "SequenceExecutorV2.gd",
            "UnifiedPlayerRuntimeSaveStore.gd",
            "UnifiedPlayerRuntimeSession.gd",
            "UnifiedRuntimeSnapshotV2.gd",
        }
        self.assertTrue(expected.issubset({path.name for path in APP.glob("*.gd")}))
        execution_v2 = self.read(APP / "SequenceExecutionV2.gd")
        for field in [
            '"delay_mode"', '"scheduled_from"', '"eligible_at"', '"after_event_id"'
        ]:
            self.assertIn(field, execution_v2)
        self.assertIn('"UNSUPPORTED_V1_DEFERRED_RETURN_STATE"', execution_v2)
        snapshot = self.read(APP / "UnifiedRuntimeSnapshotV2.gd")
        self.assertIn('const SCHEMA_VERSION := 2', snapshot)
        self.assertIn('"narrative_time"', snapshot)
        self.assertIn('"messages_adapter"', snapshot)
        v1 = self.read(ROOT / "game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd")
        self.assertIn('const SCHEMA_VERSION := 1', v1)

    def test_deferred_return_is_narrative_and_pure(self):
        gate = self.read(APP / "DeferredReturnGate.gd")
        for proof in [
            '"NONE"', '"DIEGETIC_MINUTES"', '"AFTER_EVENT"',
            'Moment.compare(current_narrative_time, schedule["eligible_at"])',
            'events.has(schedule["after_event_id"])',
        ]:
            self.assertIn(proof, gate)
        self.assertNotRegex(gate, r"Time\.|get_unix_time_from_system|datetime_dict_from_system")

    def test_referenced_messages_are_closed_and_injected(self):
        resolver = self.read(APP / "ReferencedMessagesContentResolver.gd")
        self.assertIn('const REFERENCED_TYPES := ["AFTERCARE", "RETURN"]', resolver)
        self.assertIn('authored_identity_mismatch', resolver)
        self.assertNotIn("DataLoader", resolver)
        self.assertNotIn("season_1/", resolver)
        adapter = self.read(ROOT / "game/scripts/unified_runtime/projection/MessagesUIProjectionAdapter.gd")
        self.assertIn('const SUPPORTED_BEAT_TYPES := ["MESSAGE", "CHOICE"]', adapter)
        self.assertNotIn("REFERENCED_BEAT_TYPES", adapter)
        referenced_adapter = self.read(APP / "ReferencedMessagesUIProjectionAdapter.gd")
        self.assertIn('const REFERENCED_BEAT_TYPES := ["AFTERCARE", "RETURN"]', referenced_adapter)
        self.assertIn("_referenced_content_resolver.resolve(beat)", referenced_adapter)

    def test_session_is_the_only_player_facing_commit_owner(self):
        session = self.read(APP / "UnifiedPlayerRuntimeSession.gd")
        self.assertEqual(1, session.count("_executor.commit_resolution(context)"))
        for proof in [
            'execution_state().get("execution_status") != "RESOLUTION_READY"',
            '_settle_durable_boundary()',
            '_gallery_source_from_domain()',
            'ReturnGate.evaluate',
            'advance_narrative_time(explicit_moment',
        ]:
            self.assertIn(proof, session)
        production = "\n".join(
            path.read_text(encoding="utf-8")
            for path in (ROOT / "game/scripts").rglob("*.gd")
            if path.name != "SequenceExecutor.gd" and path.name != "SequenceExecutorV2.gd"
        )
        self.assertEqual(1, production.count(".commit_resolution(context)"))

    def test_composition_root_uses_real_a6_a10_and_no_season_runtime(self):
        root = self.read(BOOTSTRAP)
        for proof in [
            "LibraryModel.charger_depuis_bundle",
            "facade.find_candidates(context)",
            "facade.compose_slot",
            "facade.activate_option",
            '"intention": "PROPOSE"',
            "CompositePort.create",
            "RuntimeSession.create",
        ]:
            self.assertIn(proof, root)
        self.assertNotIn("DataLoader", root)
        self.assertNotIn("runtime/season_1", root)
        self.assertNotIn("mathilde", re.sub(r"mathilde_returns_with_chosen_intent_01", "", root, flags=re.I).lower())

    def test_canonical_sequence_and_terminal_obligation_manifests(self):
        sequence = json.loads(self.read(SEQUENCE))
        self.assertEqual("mathilde_returns_with_chosen_intent_01", sequence["sequence_id"])
        self.assertEqual("mathilde_returns_with_chosen_intent_canonical", sequence["orchestration"]["a6_entry"]["variant_id"])
        resolutions = sequence["orchestration"]["a6_entry"]["definition"]["resolutions"]
        expected = {
            "mathilde_mb3_ma1_resolution": "CREATE_PAID",
            "mathilde_mb3_ma2_resolution": "CREATE_PAID",
            "mathilde_mb3_ma3_resolution": "CREATE_FAILED",
        }
        for resolution_id, effect in expected.items():
            obligations = resolutions[resolution_id]["durable_manifest"]["obligations"]
            self.assertEqual(1, len(obligations))
            self.assertEqual(
                {
                    "event_key", "effect", "obligation_id", "debtor_id",
                    "beneficiary_ids", "kind",
                },
                set(obligations[0]),
            )
            self.assertEqual(effect, obligations[0]["effect"])
            self.assertEqual("mathilde_secret_intimacy_aftercare", obligations[0]["obligation_id"])
            self.assertEqual("player", obligations[0]["debtor_id"])
            self.assertEqual(["mathilde"], obligations[0]["beneficiary_ids"])
            self.assertEqual("AFTERCARE", obligations[0]["kind"])
            self.assertEqual(MEDIA_IDS, [item["media_id"] for item in resolutions[resolution_id]["durable_manifest"]["media_deliveries"]])
        serialized = json.dumps(sequence, ensure_ascii=False)
        self.assertNotIn("CREATE_DUE", serialized)
        obligation_ids = {
            obligation["obligation_id"]
            for resolution in resolutions.values()
            for obligation in resolution["durable_manifest"]["obligations"]
        }
        self.assertTrue(obligation_ids)
        self.assertTrue(all(not re.search(r"j11|j12", value) for value in obligation_ids))

    def test_media_gallery_is_one_tile_with_three_canonical_children(self):
        sequence = json.loads(self.read(SEQUENCE))
        self.assertEqual(MEDIA_IDS, list(sequence["media"]))
        self.assertIsNone(sequence["media"][MEDIA_IDS[0]]["parent_media_id"])
        self.assertEqual(MEDIA_IDS[0], sequence["media"][MEDIA_IDS[1]]["parent_media_id"])
        self.assertEqual(MEDIA_IDS[0], sequence["media"][MEDIA_IDS[2]]["parent_media_id"])
        catalog = json.loads(self.read(MEDIA))
        self.assertEqual(MEDIA_IDS, [entry["media_id"] for entry in catalog["entries"]])
        self.assertTrue(all(entry["gallery_character_ids"] == ["mathilde"] for entry in catalog["entries"]))
        self.assertEqual("Moment vécu", catalog["entries"][0]["display_name"])
        gallery = self.read(ROOT / "game/scripts/unified_runtime/projection/DurableGalleryProjection.gd")
        self.assertIn('item["sequence_child_ids"] = sequence_child_ids', gallery)
        self.assertIn('"children_by_id": children_by_id', gallery)

    def test_ma3_return_and_save_restore_are_explicit(self):
        sequence = json.loads(self.read(SEQUENCE))
        beat = next(item for item in sequence["beats"] if item["beat_id"] == "mathilde_mb3_failed_return")
        self.assertEqual({"mode": "DIEGETIC_MINUTES", "value": 674}, beat["content"]["delay"])
        catalog = json.loads(self.read(MESSAGES))
        failed = next(item for item in catalog["entries"] if item["content_ref"] == "mathilde_mb3_failed_return_content")
        self.assertEqual(
            [
                "Hier, tu as demandé la suite avant de vérifier comment j’étais.",
                "Je ne viens pas ce soir.",
                "Et on ne recommence rien.",
            ],
            [item["text"] for item in failed["messages"]],
        )
        store = self.read(APP / "UnifiedPlayerRuntimeSaveStore.gd")
        for proof in [
            'return _path + ".tmp"', "DirAccess.rename_absolute", "MAX_SAVE_BYTES",
            "MAX_JSON_DEPTH", "_is_confined_user_path", "_promote_recovery",
        ]:
            self.assertIn(proof, store)
        smoke = self.read(SMOKE)
        for proof in [
            '"RETURN invisible à 09:05"',
            '"RETURN devient visible exactement à 09:06"',
            '"reload après commit ne rappelle jamais A10"',
            '"second reload conserve le schedule"',
        ]:
            self.assertIn(proof, smoke)

    def test_portrait_main_is_unified_without_eager_season_runtime(self):
        scene = self.read(ROOT / "game/scenes/portrait/PortraitMain.tscn")
        self.assertIn('content_mode = "unified"', scene)
        shell = self.read(ROOT / "game/scripts/ui/PortraitShell.gd")
        self.assertNotIn('preload("res://scripts/runtime/season_1/Season1RuntimeProvider.gd")', shell)
        self.assertIn('load(SEASON_RUNTIME_PROVIDER_PATH)', shell)
        main = self.read(ROOT / "game/scripts/ui/PortraitMain.gd")
        self.assertIn("UnifiedCompositionRoot.compose", main)
        self.assertNotIn("runtime_s1", main)
        messages = self.read(ROOT / "game/scripts/ui/messages/MessagesScreen.gd")
        self.assertNotIn("runtime/season_1/NarrativeTime.gd", messages)

    def test_canonical_media_ids_have_specialized_durable_validation(self):
        authored = self.read(ROOT / "game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd")
        scene = self.read(ROOT / "game/scripts/narrative_scene/SceneDefinition.gd")
        event = self.read(ROOT / "game/scripts/narrative_state/SequenceResolutionEventV1.gd")
        self.assertIn('category == "media_deliveries"', authored)
        self.assertIn("_validate_media_id(business_id", authored)
        self.assertIn("_identifiant_media_durable", scene)
        self.assertIn("_register_media_identifiers", event)


if __name__ == "__main__":
    unittest.main()
