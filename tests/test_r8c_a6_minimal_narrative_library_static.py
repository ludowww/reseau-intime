import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BUNDLE = ROOT / "game/data/narrative_scenes/r8c_a6_prototype_library.json"


class R8CA6MinimalNarrativeLibraryStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def setUp(self):
        self.bundle = json.loads(BUNDLE.read_text(encoding="utf-8"))

    def test_expected_files_exist(self):
        expected = [
            "game/scripts/narrative_scene/NarrativeSceneLibrary.gd",
            "game/data/narrative_scenes/r8c_a6_prototype_library.json",
            "game/tests/R8CAMinimalNarrativeLibrarySmokeTest.gd",
            "game/tests/R8CAMinimalNarrativeLibrarySmokeTest.tscn",
            "docs/architecture/R8C_A6_BIBLIOTHEQUE_NARRATIVE_MINIMALE_IMPLEMENTATION.md",
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).exists()])

    def test_bundle_root_is_closed_versioned_and_prototype_bounded(self):
        self.assertEqual(set(self.bundle), {"format", "version", "definitions"})
        self.assertEqual(self.bundle["format"], "R8C_A6_SCENE_LIBRARY")
        self.assertEqual(self.bundle["version"], 1)
        self.assertEqual(len(self.bundle["definitions"]), 3)
        for entry in self.bundle["definitions"]:
            self.assertEqual(set(entry), {"scene_definition_id", "variant_id", "definition"})
            self.assertEqual(entry["scene_definition_id"], entry["definition"]["scene_id"])
            self.assertTrue(entry["definition"]["version_contrat"].endswith("-prototype"))

    def test_explicit_identities_are_unique_stable_and_not_derived(self):
        entries = self.bundle["definitions"]
        scene_ids = [entry["scene_definition_id"] for entry in entries]
        variant_ids = [entry["variant_id"] for entry in entries]
        self.assertEqual(len(scene_ids), len(set(scene_ids)))
        self.assertEqual(len(variant_ids), len(set(variant_ids)))
        self.assertTrue(all(scene_ids))
        self.assertTrue(all(variant_ids))
        self.assertTrue(set(scene_ids).isdisjoint(variant_ids))
        source = self.read("game/scripts/narrative_scene/NarrativeSceneLibrary.gd")
        self.assertIn('var scene_definition_id = entree["scene_definition_id"]', source)
        self.assertIn('var variant_id = entree["variant_id"]', source)
        self.assertNotIn('scene_definition_id = variant_id +', source)
        self.assertNotIn('variant_id = scene_definition_id +', source)

    def test_modular_variants_share_structure_but_are_not_interchangeable(self):
        definitions = {
            entry["variant_id"]: entry["definition"] for entry in self.bundle["definitions"]
        }
        sandra = definitions["sandra_distance"]
        raphaelle = definitions["raphaelle_distance"]
        self.assertEqual(sandra["nature"], "MODULAIRE")
        self.assertEqual(raphaelle["nature"], "MODULAIRE")
        self.assertEqual(sandra["structure_id"], raphaelle["structure_id"])
        self.assertNotEqual(sandra["scene_id"], raphaelle["scene_id"])
        self.assertNotEqual(sandra["participants_requis"], raphaelle["participants_requis"])
        self.assertNotEqual(sandra["conditions_dures"], raphaelle["conditions_dures"])
        self.assertIn("sandra_signature", definitions)
        self.assertEqual(definitions["sandra_signature"]["nature"], "SIGNATURE")

    def test_a3_exposes_one_closed_validator_used_by_a6(self):
        definition = self.read("game/scripts/narrative_scene/SceneDefinition.gd")
        library = self.read("game/scripts/narrative_scene/NarrativeSceneLibrary.gd")
        self.assertIn("const CHAMPS_AUTORISES", definition)
        self.assertIn("static func valider_fermee", definition)
        self.assertIn("champ inconnu", definition)
        self.assertIn("DefinitionModele.valider_fermee(definition)", library)
        self.assertNotIn("CHAMPS_REQUIS", library)

    def test_loader_uses_one_explicit_path_and_atomic_factory(self):
        library = self.read("game/scripts/narrative_scene/NarrativeSceneLibrary.gd")
        self.assertIn(
            'const DOSSIER_BUNDLES_NARRATIFS := "res://data/narrative_scenes/"', library
        )
        self.assertIn("static func charger_depuis_json", library)
        self.assertIn("static func charger_depuis_bundle", library)
        self.assertIn("entrees_candidates", library)
        self.assertLess(library.index("entrees_candidates.sort_custom"), library.index("._publier("))
        self.assertNotIn("DirAccess", library)
        self.assertNotIn("list_dir", library)
        self.assertNotIn("load_all", library)

    def test_query_delegates_only_to_a3_and_never_instantiates(self):
        library = self.read("game/scripts/narrative_scene/NarrativeSceneLibrary.gd")
        query = library[library.index("func _query_candidates(") : library.index("static func _cles_exactes")]
        self.assertIn("moteur.evaluer_definition", query)
        self.assertNotIn("creer" + "_instance", query)
        self.assertNotIn("proposer(", query)
        self.assertNotIn("manquer(", query)
        self.assertNotIn("traiter_evenement", query)
        self.assertNotIn(".obtenir_snapshot(", query)

    def test_diagnostics_have_a_debug_gate_and_safe_result_is_sanitized(self):
        library = self.read("game/scripts/narrative_scene/NarrativeSceneLibrary.gd")
        self.assertIn("func query_candidates_dev", library)
        self.assertIn("OS.is_debug_build() or Engine.is_editor_hint()", library)
        self.assertIn('"DIAGNOSTICS_INDISPONIBLES"', library)
        self.assertIn("if inclure_diagnostics:", library)
        self.assertIn('candidat["revalidation_requise_avant"]', library)
        smoke = self.read("game/tests/R8CAMinimalNarrativeLibrarySmokeTest.gd")
        self.assertIn("refus absents du resultat joueur", smoke)
        self.assertIn("details A3 conserves en test", smoke)

    def test_order_is_a_structured_tuple_not_source_order(self):
        library = self.read("game/scripts/narrative_scene/NarrativeSceneLibrary.gd")
        comparator = library[library.index("static func _entree_avant") : library.index("static func _diagnostics")]
        self.assertIn('a["scene_definition_id"]', comparator)
        self.assertIn('a["variant_id"]', comparator)
        self.assertNotIn("hash", comparator.lower())
        smoke = self.read("game/tests/R8CAMinimalNarrativeLibrarySmokeTest.gd")
        self.assertIn("ordre stable apres permutation", smoke)

    def test_smoke_names_all_required_behavioral_regressions(self):
        smoke = self.read("game/tests/R8CAMinimalNarrativeLibrarySmokeTest.gd")
        required = [
            "rejet atomique partiel",
            "version inconnue",
            "scene_definition_id duplique",
            "variant_id duplique",
            "variant_id explicite requis",
            "ordre stable apres permutation",
            "query sans mutation A1",
            "query sans instance ni snapshot A5",
            "filtre acte",
            "filtre disponibilite",
            "filtre fenetre",
            "filtre opportunite",
            "filtre evenement interdit",
            "structure commune sans variantes interchangeables",
            "UNIQUE deja connue exclue",
            "aucune opportunite manquee creee",
        ]
        for token in required:
            self.assertIn(token, smoke)
        self.assertIn("controles != 34", smoke)
        self.assertIn("%d/34", smoke)
        self.assertIn("get_tree().quit(0)", smoke)
        self.assertIn("get_tree().quit(1)", smoke)

    def test_a6_has_no_selection_score_random_priority_or_legacy_connection(self):
        sources = "\n".join(
            self.read(path)
            for path in [
                "game/scripts/narrative_scene/NarrativeSceneLibrary.gd",
                "game/data/narrative_scenes/r8c_a6_prototype_library.json",
                "game/tests/R8CAMinimalNarrativeLibrarySmokeTest.gd",
            ]
        ).lower()
        forbidden = [
            "route" + "_points",
            "consent" + "_score",
            "attraction" + "_score",
            "priority",
            "priorite" + "_numerique",
            "ranking",
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
