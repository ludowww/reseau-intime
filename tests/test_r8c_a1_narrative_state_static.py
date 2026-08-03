import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NARRATIVE_STATE = ROOT / "game" / "scripts" / "narrative_state"


class R8CA1NarrativeStateStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def implementation_sources(self) -> dict[str, str]:
        paths = [
            "game/scripts/narrative_state/EtatNarratif.gd",
            "game/scripts/narrative_state/EtatRelationCentrale.gd",
            "game/scripts/narrative_state/EtatRelation.gd",
            "game/scripts/narrative_state/ReducerRelation.gd",
            "game/tests/R8CANarrativeStateSmokeTest.gd",
            "game/tests/R8CANarrativeStateSmokeTest.tscn",
        ]
        return {path: self.read(path) for path in paths}

    def test_expected_files_exist(self):
        expected = [
            NARRATIVE_STATE / "EtatNarratif.gd",
            NARRATIVE_STATE / "EtatRelationCentrale.gd",
            NARRATIVE_STATE / "EtatRelation.gd",
            NARRATIVE_STATE / "ReducerRelation.gd",
            ROOT / "game/tests/R8CANarrativeStateSmokeTest.gd",
            ROOT / "game/tests/R8CANarrativeStateSmokeTest.tscn",
            ROOT / "docs/architecture/R8C_A1_FONDATION_ETAT_NARRATIF.md",
        ]
        self.assertEqual([], [str(path.relative_to(ROOT)) for path in expected if not path.exists()])

    def test_new_runtime_is_ref_counted_and_exposes_only_the_minimal_state_api(self):
        sources = self.implementation_sources()
        for path in [
            "game/scripts/narrative_state/EtatNarratif.gd",
            "game/scripts/narrative_state/EtatRelationCentrale.gd",
            "game/scripts/narrative_state/EtatRelation.gd",
            "game/scripts/narrative_state/ReducerRelation.gd",
        ]:
            self.assertTrue(sources[path].startswith("extends RefCounted"), path)
            self.assertNotIn("extends Resource", sources[path])

        etat = sources["game/scripts/narrative_state/EtatNarratif.gd"]
        public_functions = re.findall(r"^(?:static )?func ([a-z][a-z0-9_]*)", etat, re.MULTILINE)
        self.assertEqual(
            ["creer_synthetique", "traiter_evenement", "obtenir_snapshot"],
            public_functions,
        )
        self.assertIn("relation_centrale_initiale: Dictionary", etat)
        self.assertIn("var instance := new()", etat)
        self.assertNotRegex(etat, r"(?m)^func (?:set|definir|modifier)_")

    def test_initial_shape_has_six_relations_without_individual_player_relation(self):
        etat = self.read("game/scripts/narrative_state/EtatNarratif.gd")
        relation = self.read("game/scripts/narrative_state/EtatRelation.gd")
        self.assertIn(
            'const PERSONNAGES := ["marie", "sandra", "mathilde", "pauline", "raphaelle", "nico"]',
            etat,
        )
        self.assertNotIn('"player"', etat.lower())
        self.assertIn('if personnage_id == "nico":', relation)
        self.assertIn('relation["desir"] = "NONE"', relation)
        for root_key in [
            "progression_saison",
            "relation_centrale",
            "relations",
            "evenements",
            "promesses",
            "obligations",
            "traces_narratives",
            "connaissances",
            "livraison_medias",
        ]:
            self.assertIn(f'"{root_key}"', etat)

    def test_only_the_two_provisional_event_types_are_declared(self):
        sources = "\n".join(
            self.read(path)
            for path in [
                "game/scripts/narrative_state/EtatNarratif.gd",
                "game/scripts/narrative_state/ReducerRelation.gd",
            ]
        )
        declared = set(re.findall(r'"(R8C_A1_[A-Z_]+_SYNTHETIQUE)"', sources))
        self.assertEqual(
            {
                "R8C_A1_RELATION_CENTRALE_SYNTHETIQUE",
                "R8C_A1_RELATION_SYNTHETIQUE",
            },
            declared,
        )

    def test_reducer_is_the_only_relation_writer(self):
        scripts = {
            path.name: path.read_text(encoding="utf-8")
            for path in NARRATIVE_STATE.glob("*.gd")
        }
        writer = re.compile(r'\["(?:relation_centrale|relations)"\]\s*=')
        self.assertRegex(scripts["ReducerRelation.gd"], writer)
        for name, source in scripts.items():
            if name != "ReducerRelation.gd":
                self.assertNotRegex(source, writer, name)
        etat = scripts["EtatNarratif.gd"]
        self.assertIn("ReducerRelationModele.preparer_mutations(candidat, copie_evenement)", etat)
        self.assertIn("duplicate(true)", etat)
        self.assertNotIn("JSON.stringify", etat)

    def test_new_implementation_avoids_historical_runtime_concepts(self):
        combined = "\n".join(self.implementation_sources().values())
        forbidden = [
            "Season" + "1State",
            "EtatNarratif" + "Lecture",
            "chapter" + "_",
            "day" + "_",
            "pro" + "vider",
            "Phone" + "Prototype",
            "Data" + "Loader",
            "route" + "_points",
            "consent" + "_score",
            "consentement " + "persistant",
            "UI " + "joueur",
            "JSON " + "narratif",
        ]
        lowered = combined.lower()
        for token in forbidden:
            self.assertNotIn(token.lower(), lowered, token)
        for number in range(1, 22):
            marker = "j" + f"{number:02d}"
            self.assertNotRegex(lowered, rf"(?<![a-z0-9]){marker}(?![a-z0-9])")

    def test_smoke_declares_all_twenty_required_checks(self):
        smoke = self.read("game/tests/R8CANarrativeStateSmokeTest.gd")
        for number in range(1, 21):
            self.assertRegex(smoke, rf'"{number:02d} [^\"]+"')
        self.assertIn("get_tree().quit(0)", smoke)
        self.assertIn("get_tree().quit(1)", smoke)


if __name__ == "__main__":
    unittest.main()
