import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class R8CA9ControlledNarrativeSlotCompositionStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_expected_files_exist(self):
        expected = [
            "game/scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd",
            "game/tests/R8CAControlledNarrativeSlotCompositionSmokeTest.gd",
            "game/tests/R8CAControlledNarrativeSlotCompositionSmokeTest.tscn",
            "docs/architecture/R8C_A9_COMPOSITION_CONTROLEE_CRENEAU_NARRATIF.md",
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).exists()])

    def test_slot_window_and_plan_contracts_are_closed_and_bounded(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd"
        )
        for token in [
            "const CHAMPS_SPECIFICATION",
            "const CHAMPS_CONTEXTE_COURANT",
            "const CHAMPS_CONTEXTE_PLAN",
            "const CHAMPS_FENETRE_ENTREE",
            "const CHAMPS_PLAN",
            "const CHAMPS_FENETRE_PLAN",
            "const MAX_WINDOWS := 32",
            "const MAX_PARTICIPANTS := 32",
            "const MAX_DURATION_MINUTES := 1440",
            "DefinitionModele.moment_normalise_valide",
            "DefinitionModele.meme_offset",
            'return "WINDOW_ID_DUPLIQUE"',
            'return "ORDRE_AUTEUR_DUPLIQUE"',
            'return "DUREE_FENETRE_INVALIDE"',
            'return "FENETRE_HORS_CRENEAU"',
        ]:
            self.assertIn(token, coordinator)
        self.assertGreaterEqual(coordinator.count("not _cles_exactes("), 5)

    def test_a9_delegates_only_to_a8_and_never_materializes_or_persists(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd"
        )
        for token in [
            "_coordinateur_a8.obtenir_fenetre",
            "_coordinateur_a8.revalider_fenetre_planifiable(",
            "_coordinateur_a8.revalider_fenetre_planifiable_dev(",
        ]:
            self.assertIn(token, coordinator)
        for forbidden in [
            "CandidateReservationProposalCoordinator",
            "MinimalSceneEngine",
            "PersistentSceneRegistry",
            "EtatNarratif",
            "creer_instance",
            "agir_sur_option",
            "ouvrir_fenetre",
            "fermer_conflit_exclusif",
            "func obtenir_snapshot",
            "func restaurer",
            "var _plans",
            "var _slots",
        ]:
            self.assertNotIn(forbidden, coordinator)

    def test_a8_exposes_read_only_plan_revalidation_with_closed_provenance(self):
        a8 = self.read(
            "game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd"
        )
        self.assertIn("func revalider_fenetre_planifiable(", a8)
        self.assertIn("func revalider_fenetre_planifiable_dev(", a8)
        revalidation = a8[
            a8.index("func _revalider_fenetre_planifiable(") : a8.index("func _ouvrir_fenetre(")
        ]
        for token in [
            'fenetre["state"] != OPEN',
            "_valider_liaison_contexte",
            'return _echec("FENETRE_EXPIREE"',
            'debut_planifie >= fin_planifiee',
            'fin_planifiee > fenetre["closes_at"]',
            'contexte["moment_diegetique"] > debut_planifie',
            "_option_appartient",
            "_moteur.obtenir_instance",
            "_charger_candidat",
            '"window_fingerprint": _empreinte_fenetre(fenetre)',
        ]:
            self.assertIn(token, revalidation)
        for forbidden in [
            "_coordinateur_a7.executer",
            "preparer_transition",
            "appliquer_transition_preparee",
        ]:
            self.assertNotIn(forbidden, revalidation)
        summary = a8[a8.index("func _resume_fenetre(") : a8.index("func _succes_fenetre(")]
        self.assertNotIn("preuve_provenance", summary)
        self.assertNotIn('"context"', summary)

    def test_earliest_fit_uses_exact_author_order_without_optimization(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd"
        )
        composition = coordinator[
            coordinator.index("func _calculer_implantation(") : coordinator.index(
                "static func _descriptions_depuis_plan("
            )
        ]
        self.assertIn("for position in author_order.size():", composition)
        self.assertIn("var window_id: String = author_order[position]", composition)
        self.assertIn("var debut_minutes: int = max(", composition)
        self.assertIn("curseur = fin_minutes", composition)
        self.assertIn('return _calcul_refuse("ORDRE_AUTEUR_IMPOSSIBLE"', composition)
        for forbidden in ["sort_custom", ".sort(", "shuffle", "permutation", "best_fit"]:
            self.assertNotIn(forbidden, composition)

    def test_plan_fingerprint_is_canonical_and_binds_order_context_and_a8_windows(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd"
        )
        self.assertIn('"context": _contexte_plan(specification["context"])', coordinator)
        self.assertIn('"author_order": specification["author_order"].duplicate()', coordinator)
        self.assertIn(
            'fenetre_plan["window_fingerprint"] = verification["window_fingerprint"]',
            coordinator,
        )
        self.assertIn('plan["fingerprint"] = _empreinte_contenu_plan(plan)', coordinator)
        fingerprint = coordinator[
            coordinator.index("static func _empreinte_contenu_plan") : coordinator.index(
                "static func _empreinte_valide"
            )
        ]
        self.assertIn('contenu.erase("fingerprint")', fingerprint)
        self.assertIn('JSON.stringify(contenu, "", true, true).sha256_text()', fingerprint)

    def test_revalidation_checks_integrity_context_overlap_and_a8_before_success(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd"
        )
        revalidation = coordinator[
            coordinator.index("func _revalider_plan(") : coordinator.index(
                "func _valider_specification("
            )
        ]
        for token in [
            "_valider_plan(plan)",
            "_contexte_plan(contexte_courant) != plan[\"context\"]",
            "_empreinte_contenu_plan(plan) != plan[\"fingerprint\"]",
            "_calculer_implantation(",
            '"IMPLANTATION_NON_CANONIQUE"',
            "revalider_fenetre_planifiable(",
            'verification["window_fingerprint"] != fenetre_plan["window_fingerprint"]',
        ]:
            self.assertIn(token, revalidation)
        self.assertLess(
            revalidation.index("_empreinte_contenu_plan(plan)"),
            revalidation.index('"ok": true'),
        )
        validator = coordinator[
            coordinator.index("func _valider_plan(") : coordinator.index(
                "func _valider_resume_a8("
            )
        ]
        self.assertIn('return "CHEVAUCHEMENT_PLAN"', validator)
        self.assertIn('return "IMPLANTATION_PLAN_INVALIDE"', validator)

    def test_runtime_is_sanitized_and_dev_diagnostics_are_gated(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd"
        )
        self.assertIn("func composer_dev", coordinator)
        self.assertIn("func revalider_plan_dev", coordinator)
        self.assertIn("OS.is_debug_build() or Engine.is_editor_hint()", coordinator)
        self.assertIn(
            'var resultat := {"ok": false, "erreur": "COMPOSITION_CRENEAU_REFUSEE", "plan": {}}',
            coordinator,
        )
        self.assertIn(
            'var resultat := {"ok": false, "erreur": "REVALIDATION_PLAN_REFUSEE", "valid": false}',
            coordinator,
        )
        smoke = self.read("game/tests/R8CAControlledNarrativeSlotCompositionSmokeTest.gd")
        self.assertIn("surface runtime assainie", smoke)
        self.assertIn("diagnostics dev complets", smoke)
        self.assertIn("provenance A8 fermee", smoke)

    def test_smoke_names_all_required_regressions(self):
        smoke = self.read("game/tests/R8CAControlledNarrativeSlotCompositionSmokeTest.gd")
        required = [
            "composition valide de plusieurs fenetres dans un creneau",
            "ordre auteur respecte exactement",
            "aucune tentative de reordonnancement automatique",
            "plan deterministe et idempotent pour la meme entree",
            "doublon de fenetre refuse",
            "duree nulle refusee",
            "duree negative refusee",
            "date narrative invalide refusee",
            "heure invalide refusee",
            "fenetre hors borne du creneau refusee",
            "chevauchement ou depassement refuse atomiquement",
            "contexte change rend plan obsolete",
            "fenetre expiree rend plan obsolete",
            "implantation deja depassee refusee",
            "plan decale reempreinte refuse car non canonique",
            "contraintes de plan hors creneau refusees",
            "empreinte de plan change si contexte change",
            "empreinte de plan change si ordre change",
            "empreinte de plan change si fenetres changent",
            "plan ephemere aucun snapshot A5 modifie",
            "aucune instance reservation proposition ou absence creee",
            "aucun evenement A1 cree",
            "provenance A8 fermee",
            "surface runtime assainie",
            "diagnostics dev complets",
            "invariants A1 A3 A5 A6 A7 A8 conserves",
        ]
        for token in required:
            self.assertIn(token, smoke)
        self.assertIn("controles != 66", smoke)
        self.assertIn("get_tree().quit(0)", smoke)
        self.assertIn("get_tree().quit(1)", smoke)

    def test_a9_has_no_automatic_selection_accumulator_randomness_or_legacy_connection(self):
        sources = "\n".join(
            self.read(path)
            for path in [
                "game/scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd",
                "game/tests/R8CAControlledNarrativeSlotCompositionSmokeTest.gd",
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
