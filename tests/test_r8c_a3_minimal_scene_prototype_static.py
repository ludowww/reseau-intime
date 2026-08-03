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

    def test_expected_files_exist_and_fixture_stays_explicitly_synthetic(self):
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
        self.assertEqual(self.data["statut_contenu"], "FIXTURE_NON_CANONIQUE")
        self.assertEqual(
            set(self.definitions),
            {"signature_sandra", "module_distance_sandra", "module_distance_raphaelle"},
        )

    def test_definition_contract_is_bounded_consumed_and_without_rule_language(self):
        required = {
            "scene_id",
            "version_contrat",
            "nature",
            "fonction_principale",
            "participants_requis",
            "conditions_dures",
            "exclusions_dures",
            "contrat_temporel",
            "politique_unicite",
            "resolutions",
        }
        decorative = {"lectures_etat", "observabilite", "sortie", "referentiel_calendrier"}
        for name, definition in self.definitions.items():
            self.assertTrue(required.issubset(definition), name)
            self.assertTrue(decorative.isdisjoint(definition), name)
            self.assertLessEqual(len(definition.get("choix", [])), 3, name)
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

    def test_choice_resolution_and_signal_chain_is_explicit(self):
        for name, definition in self.definitions.items():
            for choice in definition.get("choix", []):
                self.assertTrue(choice["signal_emis"], name)
                for resolution_id in choice["resolution_ids"]:
                    resolution = definition["resolutions"][resolution_id]
                    self.assertEqual(choice["signal_emis"], resolution["signal_recu"], name)
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        signature = re.search(r"func resoudre\((.*?)\) -> Dictionary:", engine, re.DOTALL)
        self.assertIsNotNone(signature)
        self.assertIn("choix_id: String", signature.group(1))
        self.assertIn("resolution_id: String", signature.group(1))
        self.assertIn("RESOLUTION_INCOMPATIBLE_AVEC_CHOIX", engine)
        self.assertIn("CHAINE_SIGNAL_INCOHERENTE", engine)

    def test_instance_declares_real_six_state_lifecycle_and_preparation_boundary(self):
        instance = self.read("game/scripts/narrative_scene/SceneInstance.gd")
        declared = re.findall(
            r'^const (INELIGIBLE|ELIGIBLE|PROPOSED|RESOLVED|MISSED|CANCELLED) := "([A-Z]+)"',
            instance,
            re.MULTILINE,
        )
        statuses = ["INELIGIBLE", "ELIGIBLE", "PROPOSED", "RESOLVED", "MISSED", "CANCELLED"]
        self.assertEqual(declared, [(status, status) for status in statuses])
        self.assertIn("statut_courant == INELIGIBLE and nouveau_statut in [ELIGIBLE, CANCELLED]", instance)
        self.assertIn("statut_courant == ELIGIBLE and nouveau_statut in [INELIGIBLE, PROPOSED, CANCELLED]", instance)
        self.assertIn("func preparer_transition", instance)
        self.assertIn("func appliquer_transition_preparee", instance)
        self.assertIn("func nettoyer_traces_temporaires", instance)
        self.assertNotIn('"PLANIFIEE"', instance)

    def test_resolution_revalidates_and_prepares_before_a1_commit(self):
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        resoudre = engine[engine.index("func resoudre("):engine.index("func manquer(")]
        self.assertIn('"AVANT_PROPOSITION_ET_RESOLUTION"', resoudre)
        self.assertIn("evaluer_definition(definition, etat_narratif, contexte_revalidation)", resoudre)
        self.assertIn("REVALIDATION_RESOLUTION_INELIGIBLE", resoudre)
        self.assertLess(resoudre.index("instance.preparer_transition("), resoudre.index("return _finaliser("))
        finaliser = engine[engine.index("func _finaliser("):engine.index("func _verifier_reprise(")]
        self.assertLess(finaliser.index("etat_narratif.traiter_evenement(evenement)"), finaliser.index("instance.appliquer_transition_preparee(preparation)"))
        self.assertNotIn("transitionner(", finaliser)

    def test_deterministic_transaction_and_terminal_idempotence_are_explicit(self):
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        instance = self.read("game/scripts/narrative_scene/SceneInstance.gd")
        self.assertIn('"r8c-a3:%s:resolution:%s"', engine)
        self.assertIn("func _verifier_reprise", engine)
        self.assertIn('"IDEMPOTENT"', engine)
        self.assertIn("RESOLUTION_TERMINALE_DIFFERENTE", engine)
        self.assertIn('"terminaison"', instance)
        self.assertIn('"transaction_id"', instance)

    def test_unique_and_repeatable_policies_distinguish_definition_from_instance(self):
        self.assertEqual(self.definitions["signature_sandra"]["politique_unicite"], "UNIQUE")
        self.assertEqual(self.definitions["module_distance_sandra"]["politique_unicite"], "REPETABLE")
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        for token in [
            "_instances_par_id",
            "INSTANCE_ID_DUPLIQUE",
            "SCENE_UNIQUE_DEJA_INSTANCIEE",
            "SCENE_DEJA_RESOLUE_OU_INSTANCIEE",
            "CONDITION_SCENE_REPETABLE",
        ]:
            self.assertIn(token, engine)

    def test_three_micro_signal_scopes_have_distinct_storage(self):
        signature = self.definitions["signature_sandra"]["resolutions"]
        temporary = self.definitions["module_distance_sandra"]["resolutions"]["echo_sandra_local"]
        self.assertEqual(signature["resolution_commune"]["portee_micro_signal"], "LOCALE")
        self.assertEqual(temporary["portee_micro_signal"], "TEMPORAIRE")
        self.assertEqual(signature["signal_chaleureux_recu"]["portee_micro_signal"], "DURABLE")
        self.assertEqual(signature["resolution_commune"]["faits_relationnels"], [])
        self.assertEqual(temporary["faits_relationnels"], [])
        self.assertIn("trace_temporaire", temporary)
        definition = self.read("game/scripts/narrative_scene/SceneDefinition.gd")
        self.assertIn('["LOCALE", "TEMPORAIRE", "DURABLE"]', definition)
        self.assertIn("durable exige reception, interpretation et fait explicites", definition)

    def test_zero_choice_and_zero_durable_event_are_supported_by_schema(self):
        definition = self.read("game/scripts/narrative_scene/SceneDefinition.gd")
        self.assertIn("zero a trois choix ecrits sont autorises", definition)
        self.assertNotIn("resolutions doit etre un dictionnaire non vide", definition)
        smoke = self.read("game/tests/R8CAMinimalScenePrototypeSmokeTest.gd")
        self.assertIn('sans_choix["choix"] = []', smoke)
        self.assertIn('sans_choix["resolutions"] = {}', smoke)
        self.assertIn("scene sans evenement durable valide", smoke)

    def test_time_is_validated_and_hours_are_compared_as_minutes(self):
        definition = self.read("game/scripts/narrative_scene/SceneDefinition.gd")
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        self.assertIn("func heure_en_minutes", definition)
        self.assertIn("func moment_valide", definition)
        self.assertIn("func _date_valide", definition)
        self.assertIn("DefinitionModele.heure_en_minutes", engine)
        self.assertIn("revalidation_requise_avant", engine)
        self.assertNotIn('"revalidation_requise_a"', engine)

    def test_non_selection_missed_and_authored_variants_remain_separate(self):
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        self.assertNotIn("func non_selection", engine)
        self.assertIn("func manquer", engine)
        signature = self.definitions["signature_sandra"]
        self.assertEqual(signature["politique_non_resolution"]["proposition_expire"], "MISSED")
        self.assertEqual(
            set(signature["politique_non_resolution"]),
            {"proposition_expire", "consequence_manquee"},
        )
        sandra = self.definitions["module_distance_sandra"]
        raphaelle = self.definitions["module_distance_raphaelle"]
        self.assertEqual(sandra["structure_id"], raphaelle["structure_id"])
        self.assertNotEqual(sandra["scene_id"], raphaelle["scene_id"])
        self.assertNotEqual(sandra["participants_requis"], raphaelle["participants_requis"])
        self.assertNotEqual(sandra["resolutions"], raphaelle["resolutions"])

    def test_a1_public_contract_is_unchanged(self):
        etat = self.read("game/scripts/narrative_state/EtatNarratif.gd")
        public_functions = re.findall(r"^(?:static )?func ([a-z][a-z0-9_]*)", etat, re.MULTILINE)
        self.assertEqual(public_functions, ["creer_synthetique", "traiter_evenement", "obtenir_snapshot"])
        self.assertEqual(
            set(re.findall(r'"(R8C_A1_[A-Z_]+_SYNTHETIQUE)"', etat)),
            {"R8C_A1_RELATION_CENTRALE_SYNTHETIQUE", "R8C_A1_RELATION_SYNTHETIQUE"},
        )
        self.assertIn("ReducerRelation", etat)

    def test_required_behavioral_regressions_are_named_in_smoke(self):
        smoke = self.read("game/tests/R8CAMinimalScenePrototypeSmokeTest.gd")
        required_tests = [
            "_test_resolution_incompatible_avec_choix",
            "_test_revalidation_acte_avant_mutation",
            "_test_fenetre_fermee_apres_proposition",
            "_test_participant_devenu_indisponible",
            "_test_unicite_instances_et_resolution_concurrente",
            "_test_scene_repetable_plusieurs_instances",
            "_test_transition_non_preparable_preserve_a1",
            "_test_reprise_idempotente_et_seconde_resolution_refusee",
            "_test_reprise_apres_commit_a1_avant_transition_instance",
            "_test_effet_local_non_persiste",
            "_test_trace_temporaire_creee_puis_nettoyee",
            "_test_durable_exige_reception_interpretation",
            "_test_limite_uniquement_depuis_choix_audacieux",
            "_test_scene_sans_choix_et_sans_evenement_durable",
            "_test_invariants_a1_conserves",
        ]
        for test_name in required_tests:
            self.assertIn(f"func {test_name}", smoke)
        self.assertIn("get_tree().quit(0)", smoke)
        self.assertIn("get_tree().quit(1)", smoke)

    def test_prototype_has_no_hidden_scores_counters_random_or_numeric_priority(self):
        combined = "\n".join(self.implementation_sources().values()).lower()
        forbidden = [
            "attraction" + "_score",
            "consent" + "_score",
            "boldness" + "_points",
            "emoji" + "_count",
            "route" + "_points",
            "psychological" + "_profile",
            "profil" + "_psychologique",
            "priorite_numerique",
        ]
        for token in forbidden:
            self.assertNotIn(token, combined, token)
        self.assertEqual([], re.findall(r"(?i)\brandom\b|\brandi\b|\brandf\b", combined))


if __name__ == "__main__":
    unittest.main()
