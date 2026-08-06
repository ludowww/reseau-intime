import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EVENT = "game/scripts/narrative_state/SequenceResolutionEventV1.gd"
COORDINATOR = "game/scripts/narrative_scene/SequenceResolutionCommitCoordinator.gd"
FACADE = "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd"
INSTANCE = "game/scripts/narrative_scene/SceneInstance.gd"
ENGINE = "game/scripts/narrative_scene/MinimalSceneEngine.gd"
STATE = "game/scripts/narrative_state/EtatNarratif.gd"
CODEC = "game/scripts/narrative_scene/A5NarrativeStateCodec.gd"
SMOKE = "game/tests/R8C_N14_1CAtomicResolutionSmokeDriver.gd"
SCENE = "game/tests/R8C_N14_1CAtomicResolutionSmokeTest.tscn"


class R8CN141CAtomicResolutionStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_unittest_discover_collects_real_test_case_and_expected_files(self):
        self.assertTrue(issubclass(type(self), unittest.TestCase))
        expected = [EVENT, COORDINATOR, FACADE, INSTANCE, ENGINE, STATE, CODEC, SMOKE, SCENE]
        self.assertEqual([], [path for path in expected if not (ROOT / path).is_file()])

    def test_closed_a1_event_and_deterministic_identifier(self):
        source = self.read(EVENT)
        self.assertIn('const EVENT_TYPE := "R8C_A1_SEQUENCE_RESOLUTION_V1"', source)
        self.assertIn('const FIELDS := ["event_id", "event_type", "provenance", "payload"]', source)
        self.assertIn('return "r8c-a1:%s:sequence-resolution:%s"', source)
        provenance = re.search(r"const PROVENANCE_FIELDS := \[(.*?)\]", source, re.S).group(1)
        self.assertEqual(
            [
                "event_id", "source_scene_id", "source_scene_instance_id",
                "source_a10_choice_id", "source_a10_resolution_id", "source_sequence_id",
                "source_authored_version", "source_resolution_id", "moment_diegetique",
            ],
            re.findall(r'"([a-z0-9_]+)"', provenance),
        )

    def test_payload_has_exact_six_categories_in_normative_order(self):
        source = self.read(EVENT)
        payload = re.search(r"const PAYLOAD_FIELDS := \[(.*?)\]", source, re.S).group(1)
        self.assertEqual(
            ["facts", "knowledge", "traces", "promises", "obligations", "media_deliveries"],
            re.findall(r'"([a-z_]+)"', payload),
        )
        self.assertIn('payload[category] = manifest[category].duplicate(true)', source)
        self.assertNotIn('payload["binding"]', source)

    def test_receipt_is_closed_and_persisted_only_for_unified_resolution(self):
        source = self.read(INSTANCE)
        receipt = re.search(r"const CHAMPS_RECU_RESOLUTION_SEQUENCE := \[(.*?)\]", source, re.S).group(1)
        self.assertEqual(
            [
                "operation", "transaction_id", "event_id", "choice_id", "resolution_id",
                "a10_choice_id", "a10_resolution_id", "sequence_id", "authored_version",
                "authored_resolution_id", "terminal_checkpoint_id", "event_keys",
            ],
            re.findall(r'"([a-z0-9_]+)"', receipt),
        )
        self.assertIn('if terminaison.get("operation") == "RESOLVE_SCENE":', source)
        self.assertIn('snapshot["resolution_receipt"] = terminaison.duplicate(true)', source)
        self.assertIn('value["transaction_id"] != value["event_id"]', source)

    def test_flow_validates_expected_identity_before_terminal_and_proposed_checks(self):
        source = self.read(COORDINATOR)
        self.assertLess(source.index("_prepare_expected("), source.index("InstanceModele.RESOLVED"))
        self.assertLess(source.index("InstanceModele.RESOLVED"), source.index("InstanceModele.PROPOSED"))
        preparation = source[source.index("func _prepare_expected") : source.index("func _publish")]
        for token in [
            'envelope["instance_id"]', 'instance_snapshot.get("scene_id")',
            'instance_snapshot.get("version_contrat")', 'envelope["a10_choice_id"]',
            'envelope["a10_resolution_id"]', 'resolution.get("portee_micro_signal") != "DURABLE"',
            'binding["sequence_id"]', 'binding["authored_version"]', 'binding["resolution_id"]',
            'envelope["terminal_checkpoint_id"]', 'envelope["event_keys"] != expected_event_keys',
        ]:
            self.assertIn(token, preparation)

    def test_terminal_replay_precedes_proposed_and_never_reduces_or_republishes(self):
        source = self.read(COORDINATOR)
        replay = source[source.index('if instance.obtenir_statut() == InstanceModele.RESOLVED:') : source.index('if not existing_receipt.is_empty():')]
        self.assertIn('return _success(instance, "IDEMPOTENT")', replay)
        for forbidden in ["Reducer.preparer", "candidate_a1", "preparer_registre_resolution_sequence", "_publish("]:
            self.assertNotIn(forbidden, replay)

    def test_a1_and_a5_are_fully_prepared_before_publication(self):
        source = self.read(COORDINATOR)
        self.assertLess(source.index("Reducer.preparer("), source.index("Codec.valider(candidate_a1)"))
        self.assertLess(source.index("Codec.valider(candidate_a1)"), source.index("preparer_registre_resolution_sequence("))
        self.assertLess(source.index("preparer_registre_resolution_sequence("), source.index("_publish(etat_narratif"))
        engine = self.read(ENGINE)
        self.assertIn("RegistreModele.creer_depuis_snapshot(_registre.obtenir_snapshot())", engine)
        self.assertIn("RegistreModele.creer_depuis_snapshot(registre_candidat.obtenir_snapshot())", engine)

    def test_publication_zone_is_synchronous_non_reentrant_and_branch_free(self):
        source = self.read(COORDINATOR)
        publish = source[source.index("func _publish") : source.index("static func _manifest_event_keys")]
        self.assertIn("_publication_en_cours = true", publish)
        self.assertLess(publish.index("_publier_candidat_prepare"), publish.index("_publier_registre_prepare"))
        self.assertIn("_publication_en_cours = false", publish)
        for forbidden in [
            "await", "emit_signal", "call_deferred", "set_deferred", "Callable", ".call(",
            "Thread", "Timer", "FileAccess", "user://", "if ", "match ", "rollback", "compens",
        ]:
            self.assertNotIn(forbidden, publish, forbidden)

    def test_no_late_failure_exists_in_the_two_replacement_primitives(self):
        state = self.read(STATE)
        state_publish = state[state.index("func _publier_candidat_prepare") : state.index("func _valider_evenement")]
        self.assertRegex(state_publish, r"_etat = candidat\s*$", "A1 publication must be one assignment")
        engine = self.read(ENGINE)
        registry_publish = engine[engine.index("func _publier_registre_prepare") : engine.index("func declarer_reprise_temporaire")]
        self.assertRegex(registry_publish, r"_registre = registre_candidat\s*$", "A5 publication must be one assignment")

    def test_restore_cross_checks_both_directions(self):
        source = self.read(ENGINE)
        restore = source[source.index("static func creer_depuis_snapshot") : source.index("func reevaluer_instance")]
        self.assertIn("_registre_coherent_avec_evenements", restore)
        coherence = source[source.index("static func _registre_coherent_avec_evenements") : source.index("static func _valider_enveloppe_snapshot")]
        self.assertIn("SequenceResolutionEvent.EVENT_TYPE", coherence)
        self.assertIn('instance_snapshot.has("resolution_receipt")', coherence)
        self.assertIn('evenements.has(receipt.get("event_id"))', coherence)

    def test_a10_surface_remains_exactly_seven_operations(self):
        source = self.read(FACADE)
        public = re.findall(r"^(?:static )?func ([a-z][a-z0-9_]*)", source, re.M)
        self.assertEqual(
            ["create", "find_candidates", "compose_slot", "activate_option", "resolve_scene", "save_state", "restore_state"],
            public,
        )
        self.assertIn('if context.has("sequence_resolution"):', source)

    def test_n13_external_schema_tokens_remain_v1(self):
        snapshot = self.read("game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd")
        self.assertIn('const SCHEMA_ID := "reseau_intime.unified_runtime"', snapshot)
        self.assertIn("const SCHEMA_VERSION := 1", snapshot)
        self.assertIn('const DOMAIN_FIELDS := ["version", "narrative_state", "scene_registry"]', snapshot)
        engine = self.read(ENGINE)
        self.assertIn("const SNAPSHOT_VERSION := 1", engine)
        self.assertIn('"version": SNAPSHOT_VERSION', engine)
        self.assertIn("const FORMAT_VERSION := 2", self.read(CODEC))

    def test_production_scope_has_no_ui_disk_legacy_score_or_deferred_wiring(self):
        production = "\n".join(self.read(path) for path in [EVENT, COORDINATOR, FACADE, INSTANCE, ENGINE, STATE, CODEC])
        for forbidden in [
            "Photo" + "Viewer", "Galerie", "Season" + "1Runtime",
            "conversation", "score", "route_points", "FileAccess", "user://", "emit_signal",
            "call_deferred", "set_deferred",
        ]:
            self.assertNotIn(forbidden.casefold(), production.casefold(), forbidden)

    def test_smoke_names_positive_negative_atomicity_and_replay_controls(self):
        smoke = self.read(SMOKE)
        required = [
            "instance PROPOSED prepared", "event type exact", "deterministic event id exact",
            "provenance exact", "payload six categories exact and ordered", "knowledge registry published",
            "traces registry published", "promises registry published", "obligations registry published",
            "media registry published", "closed terminal receipt persisted", "public receipt resolved after publication",
            "immediate terminal replay idempotent", "replay adds no event reducer call receipt or A5 mutation",
            "replay after restoration idempotent", "missing sequence_resolution rejected",
            "extra sequence_resolution field rejected", "divergent instance rejected", "divergent binding rejected",
            "divergent authored version rejected", "divergent A10 choice rejected", "divergent A10 resolution rejected",
            "missing event_keys rejected", "extra event_keys rejected", "different event_keys order rejected",
            "A1 event present without A5 termination", "A5 termination present without A1 event",
            "same transaction divergent A1 payload", "same transaction divergent provenance",
            "incomplete terminal receipt", "terminal receipt unknown field", "first reducer failure",
            "last reducer failure", "A5 preparation failure", "non reentrant call rejected",
            "historical synthetic A1 path remains green", "A1 and A5 visible together",
            "divergent scene definition rejected", "divergent definition version rejected",
            "instance non PROPOSED without termination rejected", "already RESOLVED with other A10 choice",
            "already RESOLVED with other A10 resolution", "invalid A1 candidate rejected",
            "invalid A5 registry candidate rejected", "same event_id divergent without A5 termination",
        ]
        self.assertEqual([], [token for token in required if token not in smoke])
        self.assertIn("R8C_N14_1C_ATOMIC_RESOLUTION: OK (%d controls)", smoke)


if __name__ == "__main__":
    unittest.main()
