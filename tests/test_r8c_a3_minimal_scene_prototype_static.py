import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "game/tests/fixtures/r8c_a3_minimal_scene_definitions.json"


class R8CA3MinimalScenePrototypeStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def setUp(self):
        self.data = json.loads(FIXTURE.read_text(encoding="utf-8"))
        self.definitions = self.data["definitions"]

    def implementation_sources(self) -> dict[str, str]:
        paths = [
            "game/scripts/narrative_scene/SceneDefinition.gd",
            "game/scripts/narrative_scene/SceneInstance.gd",
            "game/scripts/narrative_scene/MinimalSceneEngine.gd",
            "game/tests/fixtures/r8c_a3_minimal_scene_definitions.json",
        ]
        return {path: self.read(path) for path in paths}

    def test_expected_files_exist(self):
        expected = [
            ROOT / "game/scripts/narrative_scene/SceneDefinition.gd",
            ROOT / "game/scripts/narrative_scene/SceneInstance.gd",
            ROOT / "game/scripts/narrative_scene/MinimalSceneEngine.gd",
            FIXTURE,
            ROOT / "game/tests/R8CAMinimalScenePrototypeSmokeTest.gd",
            ROOT / "game/tests/R8CAMinimalScenePrototypeSmokeTest.tscn",
            ROOT / "docs/architecture/R8C_A3_PROTOTYPE_MINIMAL_SCENE_NARRATIVE.md",
        ]
        self.assertEqual([], [str(path.relative_to(ROOT)) for path in expected if not path.exists()])

    def test_fixture_is_explicitly_synthetic_and_contains_three_bounded_definitions(self):
        self.assertEqual(self.data["statut_contenu"], "FIXTURE_NON_CANONIQUE")
        self.assertEqual(
            set(self.definitions),
            {"signature_sandra", "module_distance_sandra", "module_distance_raphaelle"},
        )
        self.assertEqual(self.definitions["signature_sandra"]["nature"], "SIGNATURE")
        self.assertEqual(self.definitions["module_distance_sandra"]["nature"], "MODULAIRE")
        self.assertEqual(self.definitions["module_distance_raphaelle"]["nature"], "MODULAIRE")

    def test_definition_contract_is_data_first_bounded_and_without_rule_language(self):
        required = {
            "scene_id",
            "version_contrat",
            "titre_interne",
            "nature",
            "fonction_principale",
            "participants_requis",
            "relation_ou_question_focale",
            "noyau_stable",
            "conditions_dures",
            "exclusions_dures",
            "lectures_etat",
            "contrat_temporel",
            "resolutions",
            "politique_non_resolution",
            "sortie",
            "observabilite",
        }
        for name, definition in self.definitions.items():
            self.assertTrue(required.issubset(definition), name)
            self.assertLessEqual(len(definition["choix"]), 3, name)
            self.assertEqual(
                set(definition["conditions_dures"]),
                {"actes_compatibles", "evenements_requis"},
                name,
            )
            self.assertEqual(set(definition["exclusions_dures"]), {"evenements_interdits"}, name)
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        self.assertNotIn("Expression", engine)
        self.assertNotIn("eval(", engine)
        self.assertNotIn("rule_language", engine.lower())

    def test_instance_declares_exact_minimal_lifecycle_and_inspectable_transitions(self):
        instance = self.read("game/scripts/narrative_scene/SceneInstance.gd")
        declared = re.findall(r'^const (INELIGIBLE|ELIGIBLE|PROPOSED|RESOLVED|MISSED|CANCELLED) := "([A-Z]+)"', instance, re.MULTILINE)
        self.assertEqual(
            declared,
            [(status, status) for status in ["INELIGIBLE", "ELIGIBLE", "PROPOSED", "RESOLVED", "MISSED", "CANCELLED"]],
        )
        for field in [
            "instance_id",
            "scene_id",
            "version_contrat",
            "date_diegetique_effective",
            "creneau",
            "participants",
            "reference_etat",
            "transitions",
            "code_raison",
            "source_decision",
        ]:
            self.assertIn(f'"{field}"', instance)
        self.assertNotIn('"PLANIFIEE"', instance)

    def test_engine_covers_only_the_six_named_condition_families_with_readable_reasons(self):
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        for helper in [
            "_evaluer_acte",
            "_evaluer_evenements",
            "_evaluer_participants",
            "_evaluer_unicite",
            "_evaluer_fenetre",
            "_evaluer_opportunite",
        ]:
            self.assertIn(f"func {helper}", engine)
        for code in [
            "ACTE_INCOMPATIBLE",
            "EVENEMENT_REQUIS_ABSENT",
            "EVENEMENT_INTERDIT_PRESENT",
            "PARTICIPANT_INDISPONIBLE",
            "SCENE_DEJA_RESOLUE",
            "FENETRE_FERMEE",
            "OPPORTUNITE_INVALIDE",
        ]:
            self.assertIn(code, engine)
        self.assertEqual([], re.findall(r"(?i)random|randi|randf|priority|priorite_numerique", engine))

    def test_non_selection_and_missed_opportunity_are_separate(self):
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        self.assertNotIn("func non_selection", engine)
        self.assertIn("func manquer", engine)
        self.assertIn("INSTANCE_NON_PROPOSEE", engine)
        self.assertIn("ECHEANCE_NON_FRANCHIE", engine)
        signature = self.definitions["signature_sandra"]
        self.assertEqual(signature["politique_non_resolution"]["sans_proposition"], "EXPIRATION_SILENCIEUSE")
        self.assertEqual(signature["politique_non_resolution"]["proposition_expire"], "MISSED")

    def test_resolution_uses_a1_transaction_boundary_without_extending_a1(self):
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        self.assertIn("etat_narratif.traiter_evenement(evenement)", engine)
        self.assertIn('transaction["statut"] not in ["APPLIQUE", "IDEMPOTENT"]', engine)
        self.assertIn("ReducerRelation", self.read("game/scripts/narrative_state/EtatNarratif.gd"))

        etat = self.read("game/scripts/narrative_state/EtatNarratif.gd")
        public_functions = re.findall(r"^(?:static )?func ([a-z][a-z0-9_]*)", etat, re.MULTILINE)
        self.assertEqual(public_functions, ["creer_synthetique", "traiter_evenement", "obtenir_snapshot"])
        self.assertEqual(
            set(re.findall(r'"(R8C_A1_[A-Z_]+_SYNTHETIQUE)"', etat)),
            {"R8C_A1_RELATION_CENTRALE_SYNTHETIQUE", "R8C_A1_RELATION_SYNTHETIQUE"},
        )

    def test_micro_signals_separate_local_reception_interpretation_and_limit(self):
        signature = self.definitions["signature_sandra"]
        resolutions = signature["resolutions"]
        local = resolutions["resolution_commune"]
        warm = resolutions["signal_chaleureux_recu"]
        limit = resolutions["limite_audace_explicite"]
        self.assertEqual((local["portee_micro_signal"], local["reception"]), ("LOCALE", "NON_PERSISTANTE"))
        self.assertEqual((warm["portee_micro_signal"], warm["reception"]), ("DURABLE", "RECUE_INTERPRETEE"))
        self.assertEqual(limit["reception"], "LIMITE_EXPLICITE")
        self.assertIn("sandra_limite_registre_audacieux_formulee", [fact["fait_id"] for fact in limit["faits_relationnels"]])
        for resolution in resolutions.values():
            self.assertEqual(resolution["convergence"], "RETOUR_NOYAU_COMMUN")

    def test_sandra_and_raphaelle_modules_share_structure_but_not_authored_contracts(self):
        sandra = self.definitions["module_distance_sandra"]
        raphaelle = self.definitions["module_distance_raphaelle"]
        self.assertEqual(sandra["structure_id"], raphaelle["structure_id"])
        self.assertNotEqual(sandra["scene_id"], raphaelle["scene_id"])
        self.assertNotEqual(sandra["participants_requis"], raphaelle["participants_requis"])
        self.assertNotEqual(sandra["conditions_dures"], raphaelle["conditions_dures"])
        self.assertNotEqual(sandra["noyau_stable"], raphaelle["noyau_stable"])
        self.assertNotEqual(sandra["resolutions"], raphaelle["resolutions"])

    def test_prototype_has_no_hidden_scores_counters_or_psychological_profile(self):
        combined = "\n".join(self.implementation_sources().values()).lower()
        forbidden = [
            "attraction" + "_score",
            "consent" + "_score",
            "boldness" + "_points",
            "emoji" + "_count",
            "route" + "_points",
            "psychological" + "_profile",
            "profil" + "_psychologique",
        ]
        for token in forbidden:
            self.assertNotIn(token, combined, token)

    def test_smoke_declares_all_thirty_three_acceptance_checks(self):
        smoke = self.read("game/tests/R8CAMinimalScenePrototypeSmokeTest.gd")
        for number in range(1, 34):
            self.assertRegex(smoke, rf'"{number:02d} [^"]+"')
        self.assertIn("get_tree().quit(0)", smoke)
        self.assertIn("get_tree().quit(1)", smoke)


if __name__ == "__main__":
    unittest.main()
