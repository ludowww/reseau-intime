import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class R8CA5PersistentSceneRegistryStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_expected_files_exist(self):
        expected = [
            "game/scripts/narrative_scene/A5NarrativeStateCodec.gd",
            "game/scripts/narrative_scene/PersistentSceneRegistry.gd",
            "game/tests/R8CAPersistentSceneRegistrySmokeTest.gd",
            "game/tests/R8CAPersistentSceneRegistrySmokeTest.tscn",
            "docs/architecture/R8C_A5_PERSISTANCE_MINIMALE_SCENES_ET_OPPORTUNITES.md",
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).exists()])

    def test_persistent_instance_schema_is_minimal_and_explicit(self):
        instance = self.read("game/scripts/narrative_scene/SceneInstance.gd")
        expected_fields = {
            "instance_id",
            "scene_definition_id",
            "definition_version",
            "uniqueness_policy",
            "state",
            "created_at",
            "last_transition_at",
            "operation",
            "choice_id",
            "resolution_id",
            "transaction_id",
            "temporary_traces",
        }
        block = instance[
            instance.index("const CHAMPS_SNAPSHOT_PERSISTANT") : instance.index("const CHAMPS_TRACE_TEMPORAIRE")
        ]
        self.assertEqual(expected_fields, set(re.findall(r'"([a-z_]+)"', block)))
        self.assertIn("func creer_depuis_snapshot_persistant", instance)
        self.assertIn("func obtenir_snapshot_persistant", instance)

    def test_local_effect_is_excluded_from_persistent_projection(self):
        instance = self.read("game/scripts/narrative_scene/SceneInstance.gd")
        projection = instance[
            instance.index("func obtenir_snapshot_persistant") : instance.index("func obtenir_instance_id")
        ]
        self.assertNotIn("LOCALE", projection)
        self.assertNotIn("portee_micro_signal", projection)
        self.assertNotIn("signal_recu", projection)
        self.assertNotIn("interpretation", projection)

    def test_temporary_traces_are_bounded_to_active_instances(self):
        instance = self.read("game/scripts/narrative_scene/SceneInstance.gd")
        self.assertIn("if obtenir_statut() == PROPOSED", instance)
        self.assertIn('if preparation["statut"] in STATUTS_TERMINAUX:', instance)
        self.assertIn('_donnees["traces_temporaires"].clear()', instance)
        self.assertIn("const CHAMPS_TRACE_TEMPORAIRE", instance)
        self.assertIn('trace.get("scope") != "TEMPORAIRE"', instance)
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        self.assertIn("func declarer_reprise_temporaire", engine)
        self.assertIn('resolution.get("portee_micro_signal") != "TEMPORAIRE"', engine)

    def test_engine_uses_one_registry_and_no_parallel_uniqueness_cache(self):
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        registry = self.read("game/scripts/narrative_scene/PersistentSceneRegistry.gd")
        self.assertIn("var _registre = RegistreModele.new()", engine)
        self.assertNotIn("var _instances_par_id", engine)
        self.assertNotIn("_scenes_uniques_resolues", engine)
        self.assertIn("class_name R8CPersistentSceneRegistry", registry)
        self.assertIn("var _instances_par_id", registry)
        self.assertIn("scene_unique_connue", registry)

    def test_snapshot_is_current_only_and_restoration_is_an_atomic_factory(self):
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        self.assertIn("const SNAPSHOT_VERSION := 1", engine)
        self.assertIn('"narrative_state": etat_snapshot', engine)
        self.assertIn("EtatNarratifCodec.valider(etat_snapshot)", engine)
        self.assertIn('"scene_registry": _registre.obtenir_snapshot()', engine)
        restore = engine[engine.index("static func creer_depuis_snapshot") : engine.index("func reevaluer_instance")]
        self.assertLess(restore.index("creer_depuis_snapshot(value"), restore.index("moteur_candidat._registre"))
        self.assertNotIn("func restaurer_snapshot", engine)
        self.assertIn("SNAPSHOT_A5_VERSION_INCOMPATIBLE", engine)
        self.assertIn("REGISTRE_SCENES_INVALIDE", engine)
        self.assertIn("ETAT_NARRATIF_INVALIDE", engine)

    def test_a1_reconstruction_validates_before_returning(self):
        etat = self.read("game/scripts/narrative_state/EtatNarratif.gd")
        factory = etat[etat.index("static func creer_depuis_snapshot") : etat.index("func traiter_evenement")]
        self.assertLess(factory.index("_valider_etat_complet"), factory.index("return candidat"))
        self.assertIn("etat narratif: racines inattendues", etat)

    def test_smoke_names_every_required_regression(self):
        smoke = self.read("game/tests/R8CAPersistentSceneRegistrySmokeTest.gd")
        for token in [
            "round-trip PROPOSED",
            "round-trip RESOLVED",
            "round-trip MISSED",
            "round-trip CANCELLED",
            "unicite UNIQUE reconstruite apres reload",
            "scene REPETABLE reutilisable apres reload",
            "transaction_id conserve",
            "reprise identique idempotente apres reload",
            "seconde resolution differente refusee apres reload",
            "effet LOCAL absent du snapshot",
            "TEMPORAIRE conservee pour instance active",
            "TEMPORAIRE nettoyee a la cloture",
            "snapshot ancien refuse sans mutation",
            "registre invalide refuse sans mutation partielle",
            "six relations A1 conservees",
        ]:
            self.assertIn(token, smoke)

    def test_a5_does_not_connect_to_portrait_or_legacy_runtime(self):
        sources = "\n".join(
            self.read(path)
            for path in [
                "game/scripts/narrative_scene/PersistentSceneRegistry.gd",
                "game/scripts/narrative_scene/A5NarrativeStateCodec.gd",
                "game/scripts/narrative_scene/SceneInstance.gd",
                "game/scripts/narrative_scene/MinimalSceneEngine.gd",
                "game/tests/R8CAPersistentSceneRegistrySmokeTest.gd",
            ]
        )
        for forbidden in [
            "Season" + "1RuntimeProvider",
            "Season" + "1State",
            "Portrait" + "Main",
            "Phone" + "Prototype",
            "route" + "_points",
            "consent" + "_score",
        ]:
            self.assertNotIn(forbidden.lower(), sources.lower(), forbidden)


if __name__ == "__main__":
    unittest.main()
