import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class R8CA7CandidateReservationProposalStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_expected_files_exist(self):
        expected = [
            "game/scripts/narrative_scene/CandidateReservationProposalCoordinator.gd",
            "game/tests/R8CACandidateReservationProposalSmokeTest.gd",
            "game/tests/R8CACandidateReservationProposalSmokeTest.tscn",
            "docs/architecture/R8C_A7_RESERVATION_ET_PROPOSITION_CANDIDATS.md",
            "docs/maintenance/WORKFLOW_VALIDATION_ET_GATES.md",
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).exists()])

    def test_library_issues_closed_context_bound_provenance(self):
        library = self.read("game/scripts/narrative_scene/NarrativeSceneLibrary.gd")
        self.assertIn("const CHAMPS_CANDIDAT_ACTION", library)
        self.assertIn("func verifier_candidat_action", library)
        self.assertIn('"preuve_provenance"', library)
        self.assertIn('JSON.stringify(contexte, "", true, true)', library)
        self.assertIn("_secret_provenance", library)
        self.assertIn('"CANDIDAT_HORS_BUNDLE_CHARGE"', library)
        self.assertIn('"CANDIDAT_PERIME_OU_CONTEXTE_CHANGE"', library)
        verification = library[
            library.index("func verifier_candidat_action") : library.index("func query_candidates")
        ]
        self.assertIn('definition["version_contrat"] != definition_version', verification)
        self.assertIn('entree["variant_id"] != variant_id', verification)

    def test_coordinator_revalidates_before_atomic_materialization(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/CandidateReservationProposalCoordinator.gd"
        )
        self.assertIn('const RESERVE := "RESERVE"', coordinator)
        self.assertIn('const PROPOSE := "PROPOSE"', coordinator)
        self.assertLess(
            coordinator.index("_moteur.evaluer_definition"),
            coordinator.index("_moteur.creer_instance(definition"),
        )
        self.assertLess(
            coordinator.index('if not diagnostic.get("eligible", false)'),
            coordinator.index("_moteur.creer_instance(definition"),
        )
        engine = self.read("game/scripts/narrative_scene/MinimalSceneEngine.gd")
        atomic = engine[
            engine.index("func _creer_instance_atomique") : engine.index("func obtenir_derniere_erreur_instance")
        ]
        self.assertLess(atomic.index("instance.transitionner"), atomic.index("_registre.enregistrer"))

    def test_reservation_uses_existing_eligible_state_and_proposal_is_explicit(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/CandidateReservationProposalCoordinator.gd"
        )
        self.assertIn(
            "InstanceModele.ELIGIBLE if intention == RESERVE else InstanceModele.PROPOSED",
            coordinator,
        )
        self.assertNotIn('const RESERVED := "RESERVED"', coordinator)
        self.assertIn("creer_instance_proposee_apres_revalidation", coordinator)
        instance = self.read("game/scripts/narrative_scene/SceneInstance.gd")
        self.assertNotIn('const RESERVED := "RESERVED"', instance)
        self.assertIn(
            "statut_courant == PROPOSED and nouveau_statut in [RESOLVED, MISSED, CANCELLED]",
            instance,
        )

    def test_runtime_result_is_sanitized_and_dev_diagnostics_are_gated(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/CandidateReservationProposalCoordinator.gd"
        )
        self.assertIn("func executer_dev", coordinator)
        self.assertIn("OS.is_debug_build() or Engine.is_editor_hint()", coordinator)
        self.assertIn('var resultat := {"ok": false, "erreur": "ACTION_CANDIDAT_REFUSEE"}', coordinator)
        self.assertIn('resultat["diagnostic"]', coordinator)
        smoke = self.read("game/tests/R8CACandidateReservationProposalSmokeTest.gd")
        self.assertIn("resultat runtime assaini", smoke)
        self.assertIn("diagnostics dev complets", smoke)

    def test_smoke_names_all_required_regressions(self):
        smoke = self.read("game/tests/R8CACandidateReservationProposalSmokeTest.gd")
        required = [
            "query seule ne cree rien A5",
            "reservation cree exactement une instance ELIGIBLE",
            "reservation sans evenement A1 ni absence",
            "proposition cree exactement une instance PROPOSED",
            "revalidation echouee atomique",
            "meme demande rejouee idempotente",
            "demande differente meme UNIQUE refusee",
            "candidat fabrique refuse",
            "annulation sans consequence relationnelle implicite",
            "seule une proposition peut devenir MISSED",
            "REPETABLE accepte deux demandes deterministes",
            "aucune mutation A1 hors evenement explicite",
        ]
        for token in required:
            self.assertIn(token, smoke)
        self.assertIn("controles != 38", smoke)
        self.assertIn("get_tree().quit(0)", smoke)
        self.assertIn("get_tree().quit(1)", smoke)

    def test_a7_has_no_selection_or_legacy_runtime_connection(self):
        sources = "\n".join(
            self.read(path)
            for path in [
                "game/scripts/narrative_scene/CandidateReservationProposalCoordinator.gd",
                "game/scripts/narrative_scene/NarrativeSceneLibrary.gd",
                "game/tests/R8CACandidateReservationProposalSmokeTest.gd",
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
        ]
        for token in forbidden:
            self.assertNotIn(token, sources, token)
        self.assertEqual([], re.findall(r"(?i)\bscore\b|\bhasard\b", sources))


if __name__ == "__main__":
    unittest.main()
