import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class R8CA8OpportunityWindowsExclusiveConflictsStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_expected_files_exist(self):
        expected = [
            "game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd",
            "game/tests/R8CAOpportunityWindowsExclusiveConflictsSmokeTest.gd",
            "game/tests/R8CAOpportunityWindowsExclusiveConflictsSmokeTest.tscn",
            "docs/architecture/R8C_A8_FENETRES_OPPORTUNITE_ET_CONFLITS_EXCLUSIFS.md",
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).exists()])

    def test_window_and_option_contracts_are_closed_bounded_and_explicit(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd"
        )
        self.assertIn("const CHAMPS_FENETRE", coordinator)
        self.assertIn("const CHAMPS_OPTION", coordinator)
        self.assertIn("const MAX_OPTIONS := 32", coordinator)
        self.assertIn(
            "typeof(options) != TYPE_ARRAY or options.is_empty() or options.size() > MAX_OPTIONS",
            coordinator,
        )
        self.assertNotIn("options.size() < 2", coordinator)
        self.assertIn("DefinitionModele.moment_normalise_valide", coordinator)
        self.assertIn('specification["opens_at"] >= specification["closes_at"]', coordinator)
        self.assertIn('option_ids.has(option["option_id"])', coordinator)
        self.assertIn('instance_ids.has(option["instance_id"])', coordinator)
        self.assertIn("not _cles_exactes(specification, CHAMPS_FENETRE)", coordinator)
        self.assertIn("not _cles_exactes(option, CHAMPS_OPTION)", coordinator)

    def test_only_three_conflict_policies_exist_and_states_stay_distinct(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd"
        )
        self.assertIn('const CLOSE_SILENTLY := "CLOSE_SILENTLY"', coordinator)
        self.assertIn('const MARK_MISSED_IF_PROPOSED := "MARK_MISSED_IF_PROPOSED"', coordinator)
        self.assertIn('const DEFER := "DEFER"', coordinator)
        policies = coordinator[
            coordinator.index("const CLOSE_SILENTLY") : coordinator.index("const OPEN")
        ]
        self.assertEqual(3, len(re.findall(r'const \w+ := "(?:CLOSE_SILENTLY|MARK_MISSED_IF_PROPOSED|DEFER)"', policies)))
        for state in [
            "CANDIDATE",
            "RESERVED",
            "PROPOSED",
            "NOT_SELECTED",
            "MISSED",
            "CANCELLED",
            "DEFERRED",
        ]:
            self.assertIn(f'const {state} := "{state}"', coordinator)
        self.assertNotIn('const RESERVED := "RESERVED"', self.read("game/scripts/narrative_scene/SceneInstance.gd"))

    def test_a8_delegates_to_a6_a7_a3_a5_without_persisting_windows(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd"
        )
        self.assertIn("_bibliotheque.query_candidates", coordinator)
        self.assertIn("_bibliotheque.verifier_candidat_action", coordinator)
        self.assertIn("_coordinateur_a7.executer(", coordinator)
        self.assertIn("_coordinateur_a7.executer_dev(", coordinator)
        self.assertIn("instance.preparer_transition(", coordinator)
        self.assertIn("appliquer_transition_preparee", coordinator)
        self.assertNotIn("func obtenir_snapshot", coordinator)
        self.assertNotIn("PersistentSceneRegistry", coordinator)
        instance = self.read("game/scripts/narrative_scene/SceneInstance.gd")
        persistent = instance[instance.index("func obtenir_snapshot_persistant") : instance.index("func obtenir_instance_id")]
        for forbidden in ["window_id", "option_id", "conflict_policy", "preuve_provenance"]:
            self.assertNotIn(forbidden, persistent)

    def test_revalidation_precedes_materialization_and_every_closure(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd"
        )
        action = coordinator[
            coordinator.index("func _agir_sur_option(") : coordinator.index("func _fermer_conflit_exclusif(")
        ]
        self.assertLess(action.index("_charger_candidat"), action.index("_coordinateur_a7.executer("))
        closing = coordinator[
            coordinator.index("func _fermer_conflit_exclusif(") : coordinator.index("func _preparer_fermeture(")
        ]
        self.assertLess(
            closing.index("_preparer_fermeture"),
            closing.index('for changement in preparation["changements"]'),
        )
        preflight = coordinator[
            coordinator.index("func _preparer_fermeture(") : coordinator.index("func _cible_conflit(")
        ]
        self.assertIn("_charger_candidat", preflight)
        self.assertIn("replay.get(\"idempotent\", false)", preflight)
        self.assertIn('contexte["moment_diegetique"] < instance.obtenir_dernier_instant()', preflight)

    def test_only_a_visible_proposal_can_be_missed_by_conflict(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd"
        )
        target = coordinator[
            coordinator.index("func _cible_conflit(") : coordinator.index("func _charger_candidat(")
        ]
        self.assertIn("if state == PROPOSED:", target)
        self.assertIn("return MISSED", target)
        self.assertIn("if state == RESERVED:", target)
        self.assertIn("return CANCELLED", target)
        self.assertIn("return NOT_SELECTED", target)
        preflight = coordinator[
            coordinator.index("func _preparer_fermeture(") : coordinator.index("func _cible_conflit(")
        ]
        self.assertIn('option["state"] in [RESERVED, PROPOSED]', preflight)
        self.assertIn('politique["proposition_expire"] != InstanceModele.MISSED', preflight)
        prepared = coordinator[
            coordinator.index("func _preparer_transition_conflit") : coordinator.index("static func _changement_option")
        ]
        self.assertIn("InstanceModele.MISSED", prepared)
        self.assertIn('"operation": "MANQUEE"', prepared)

    def test_idempotence_context_atomicity_and_runtime_sanitization_are_covered(self):
        coordinator = self.read(
            "game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd"
        )
        self.assertIn('fenetre["selected_option_id"] == option_id_retenue', coordinator)
        self.assertIn('"idempotent": idempotente', coordinator)
        self.assertIn('return "CONTEXTE_FENETRE_CHANGE"', coordinator)
        self.assertIn('return "FENETRE_EXPIREE_OU_NON_OUVERTE"', coordinator)
        self.assertIn("func ouvrir_fenetre_dev", coordinator)
        self.assertIn("func agir_sur_option_dev", coordinator)
        self.assertIn("func fermer_conflit_exclusif_dev", coordinator)
        self.assertIn("OS.is_debug_build() or Engine.is_editor_hint()", coordinator)
        self.assertIn('var resultat := {"ok": false, "erreur": "OPERATION_FENETRE_REFUSEE"}', coordinator)

    def test_smoke_names_all_required_regressions(self):
        smoke = self.read("game/tests/R8CAOpportunityWindowsExclusiveConflictsSmokeTest.gd")
        required = [
            "zero option reste refuse avec OPTIONS_FENETRE_INVALIDES",
            "une option ouvre CANDIDATE sans instance A5",
            "MAX_OPTIONS options restent acceptees",
            "MAX_OPTIONS plus une option reste refuse",
            "cycle mono-option PROPOSE ferme sans perdant",
            "cycle mono-option RESERVE ferme sans perdant",
            "mono-option cree une seule A5 sans consequence durable de conflit",
            "abandon mono-option retire ownership sans A5",
            "mono-option refuse instance A5 preexistante",
            "creation fenetre valide avec plusieurs candidats",
            "candidat non retenu sans instance ni absence",
            "reservation sans proposition ni absence",
            "proposition cree instance PROPOSED",
            "CLOSE_SILENTLY sans consequence relationnelle",
            "seule alternative proposee devient MISSED",
            "jamais proposee ne devient jamais absence",
            "DEFER laisse candidat ephemere",
            "candidat differe reeligible et transferable plus tard",
            "conflit rejoue idempotent",
            "contexte change sans mutation partielle",
            "fenetre expiree sans mutation partielle",
            "UNIQUE preserve sans mutation partielle",
            "alternative UNIQUE perdante fermable apres choix",
            "REPETABLE preserve deux materialisations",
            "provenance A6 A7 fermee sans mutation",
            "instance A5 non partageable entre fenetres",
            "politique incompatible sans commit partiel",
            "MARK_MISSED refuse cible A5 CANCELLED",
            "aucune regression A1 A3 A5 A6 A7",
        ]
        for token in required:
            self.assertIn(token, smoke)
        self.assertIn("controles != 94", smoke)
        self.assertIn("get_tree().quit(0)", smoke)
        self.assertIn("get_tree().quit(1)", smoke)

    def test_a8_has_no_automatic_selection_score_random_priority_or_legacy_connection(self):
        sources = "\n".join(
            self.read(path)
            for path in [
                "game/scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd",
                "game/tests/R8CAOpportunityWindowsExclusiveConflictsSmokeTest.gd",
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
