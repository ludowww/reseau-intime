import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class R8CA10VerticalSliceOrchestrationStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_expected_files_exist(self):
        expected = [
            "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd",
            "game/tests/R8CAVerticalSliceOrchestrationSmokeTest.gd",
            "game/tests/R8CAVerticalSliceOrchestrationSmokeTest.tscn",
            "docs/architecture/R8C_A10_VERTICAL_SLICE_ORCHESTRATION_ET_SIMPLIFICATION_API.md",
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).exists()])

    def test_facade_has_exactly_seven_bounded_public_operations(self):
        facade = self.read(
            "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd"
        )
        operations = re.findall(r"^(?:static )?func ([a-z][a-z0-9_]*)\(", facade, re.MULTILINE)
        self.assertEqual(
            [
                "create",
                "find_candidates",
                "compose_slot",
                "activate_option",
                "resolve_scene",
                "save_state",
                "restore_state",
            ],
            operations,
        )
        self.assertNotIn("func _dev", facade)

    def test_facade_wires_and_delegates_to_a3_through_a9(self):
        facade = self.read(
            "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd"
        )
        for token in [
            "MinimalSceneEngine.gd",
            "CandidateReservationProposalCoordinator.gd",
            "OpportunityWindowExclusiveConflictCoordinator.gd",
            "ControlledNarrativeSlotCompositionCoordinator.gd",
            "_bibliotheque.query_candidates(",
            "_coordinateur_a8.ouvrir_fenetre(",
            "_coordinateur_a8.abandonner_fenetre_non_materialisee(",
            "_coordinateur_a9.composer(",
            "_coordinateur_a9.revalider_plan(",
            "_coordinateur_a8.agir_sur_option(",
            "_coordinateur_a8.fermer_conflit_exclusif(",
            "_moteur.resoudre(",
            "_moteur.obtenir_snapshot(",
            "MoteurModele.creer_depuis_snapshot(",
        ]:
            self.assertIn(token, facade)

    def test_facade_does_not_duplicate_domain_validation_or_transactions(self):
        facade = self.read(
            "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd"
        )
        for forbidden in [
            "evaluer_definition(",
            "verifier_candidat_action(",
            "creer_instance(",
            "traiter_evenement(",
            "preparer_transition(",
            "appliquer_transition_preparee(",
            "sha256_text(",
            "CHAMPS_PLAN",
            "CHAMPS_OPTION",
            "CHAMPS_PROVENANCE",
        ]:
            self.assertNotIn(forbidden, facade)

    def test_proofs_definitions_and_development_diagnostics_remain_internal(self):
        facade = self.read(
            "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd"
        )
        public_part = facade[: facade.index("func _installer_dependances")]
        for forbidden in [
            '"preuve_provenance"',
            '"definition"',
            '"diagnostic"',
            "query_candidates_dev",
            "executer_dev",
            "ouvrir_fenetre_dev",
            "composer_dev",
            "revalider_plan_dev",
        ]:
            self.assertNotIn(forbidden, public_part)

    def test_single_window_projection_preserves_explicit_authored_identity(self):
        facade = self.read(
            "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd"
        )
        compose = facade[
            facade.index("func compose_slot(") : facade.index("func activate_option(")
        ]
        self.assertIn('"window_id": window_request.get("window_id")', compose)
        self.assertIn('"options": _options_a8(window_request.get("options"))', compose)
        self.assertIn('"author_order": [window_id]', compose)
        self.assertIn('candidat.get("scene_definition_id")', facade)
        self.assertIn('candidat.get("variant_id")', facade)
        for forbidden in ["sort_custom", ".sort(", "shuffle", "best_fit", "permutation"]:
            self.assertNotIn(forbidden, compose)

    def test_activation_revalidates_before_a8_a7_materialization_and_closure(self):
        facade = self.read(
            "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd"
        )
        activation = facade[
            facade.index("func activate_option(") : facade.index("func resolve_scene(")
        ]
        self.assertLess(
            activation.index("_coordinateur_a9.revalider_plan("),
            activation.index("_coordinateur_a8.agir_sur_option("),
        )
        self.assertLess(
            activation.index("_coordinateur_a8.agir_sur_option("),
            activation.index("_coordinateur_a8.fermer_conflit_exclusif("),
        )
        self.assertIn('windows.size() != 1', activation)
        self.assertIn('reprise["plan"] == plan', activation)
        self.assertIn('reprise["action"] == action', activation)
        self.assertIn("intention != CoordinateurA7Modele.PROPOSE", activation)
        self.assertNotIn('reprise["resultat"]', activation)
        self.assertIn("_resultat_activation(plan, option_id, true)", activation)

    def test_resolution_and_persistence_hide_internal_object_graph(self):
        facade = self.read(
            "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd"
        )
        resolution = facade[
            facade.index("func resolve_scene(") : facade.index("func save_state(")
        ]
        self.assertIn("_moteur.obtenir_instance(instance_id)", resolution)
        self.assertIn("_bibliotheque.obtenir_definition(", resolution)
        self.assertIn("_moteur.resoudre(", resolution)
        self.assertIn('contexte_resolution["instance_id"] = instance_id', resolution)
        self.assertNotIn('"evenement_candidat"', resolution)
        self.assertNotIn('"diagnostic_signal"', resolution)
        self.assertNotIn('"diagnostic_revalidation"', resolution)
        persistence = facade[
            facade.index("func save_state(") : facade.index("func _installer_dependances(")
        ]
        self.assertIn("_moteur.obtenir_snapshot(_etat_narratif)", persistence)
        self.assertIn("MoteurModele.creer_depuis_snapshot(snapshot)", persistence)
        self.assertIn("_reprises_activation.clear()", persistence)

    def test_complexity_budget_adds_no_persistent_state_or_policy(self):
        facade = self.read(
            "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd"
        )
        for forbidden in [
            "FileAccess",
            "ResourceSaver",
            "SNAPSHOT_VERSION",
            "FORMAT_PLAN",
            "POLITIQUES_CONFLIT",
            "var _plans",
            "var _windows",
            "var _journee",
            "sequence_engine",
        ]:
            self.assertNotIn(forbidden, facade)
        self.assertIn("var _reprises_activation: Dictionary = {}", facade)

    def test_a8_rollback_only_discards_open_unmaterialized_candidates(self):
        a8 = self.read(
            "game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd"
        )
        rollback = a8[
            a8.index("func abandonner_fenetre_non_materialisee(") : a8.index(
                "func revalider_fenetre_planifiable("
            )
        ]
        for token in [
            'fenetre["state"] != OPEN',
            'not fenetre["selected_option_id"].is_empty()',
            'option["state"] != CANDIDATE',
            '_moteur.obtenir_instance(option["instance_id"]) != null',
            '_option_appartient(window_id, option)',
            '_proprietaires_instance.erase(option["instance_id"])',
            "_fenetres.erase(window_id)",
        ]:
            self.assertIn(token, rollback)
        for forbidden in ["transitionner", "traiter_evenement", "appliquer_transition_preparee"]:
            self.assertNotIn(forbidden, rollback)

    def test_smoke_covers_vertical_slice_and_required_failures(self):
        smoke = self.read("game/tests/R8CAVerticalSliceOrchestrationSmokeTest.gd")
        required = [
            "recherche A6 via facade",
            "creation fenetre A8 et composition A9 via facade",
            "activation controlee A9 A8 A7 A5",
            "resolution A3 via facade",
            "transaction durable A1 appliquee",
            "CLOSE_SILENTLY ferme l alternative jamais proposee",
            "aucune consequence pour alternative jamais proposee",
            "activation idempotente",
            "replay activation distingue activation historique et etat A5 courant",
            "resolution idempotente apres reload",
            "RESERVE refuse par la facade avant mutation",
            "rollback A8 libere le meme window_id",
            "plan A9 falsifie refuse sans mutation",
            "contexte change refuse avant activation",
            "reload conserve instance et transaction durable",
            "facade n expose aucun diagnostic dev",
            "aucune selection automatique ni reordonnancement",
        ]
        for token in required:
            self.assertIn(token, smoke)
        self.assertIn("controles != 50", smoke)
        self.assertIn("get_tree().quit(0)", smoke)
        self.assertIn("get_tree().quit(1)", smoke)

    def test_a8_regression_keeps_missed_limited_to_visible_proposals(self):
        smoke_a8 = self.read(
            "game/tests/R8CAOpportunityWindowsExclusiveConflictsSmokeTest.gd"
        )
        static_a8 = self.read(
            "tests/test_r8c_a8_opportunity_windows_exclusive_conflicts_static.py"
        )
        for token in [
            "seule alternative proposee devient MISSED",
            "jamais proposee ne devient jamais absence",
            "MARK_MISSED_IF_PROPOSED",
        ]:
            self.assertIn(token, smoke_a8 + static_a8)

    def test_a10_has_no_automatic_selection_accumulator_randomness_or_legacy_connection(self):
        sources = "\n".join(
            self.read(path)
            for path in [
                "game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd",
                "game/tests/R8CAVerticalSliceOrchestrationSmokeTest.gd",
            ]
        ).lower()
        forbidden = [
            "route" + "_points",
            "consent" + "_score",
            "attraction" + "_score",
            "rank" + "ing",
            "priorite" + "_numerique",
            "random" + "numbergenerator",
            "randi(",
            "randf(",
            "season" + "1runtimeprovider",
            "portrait" + "main",
            "day" + "builder",
            "sequence" + "engine",
            "auto" + "_select(",
        ]
        for token in forbidden:
            self.assertNotIn(token, sources, token)
        self.assertEqual([], re.findall(r"(?i)\bscore\b|\bhasard\b", sources))


if __name__ == "__main__":
    unittest.main()
