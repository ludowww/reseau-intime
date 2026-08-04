# R8C-A6 — Bibliothèque narrative minimale : implémentation

> **Statut :** `IMPLEMENTED_AWAITING_PRODUCT_VALIDATION`
> **Base :** brief A6 verrouillé sur `e78b0b3babcef5aa66b2a65046bad59212893c3b`
> **Contenu :** prototype synthétique non canonique, sans connexion joueur.

## Format du bundle

Le loader accepte un chemin explicite terminé par `.json` sous
`res://data/narrative_scenes/`. Il ne parcourt aucun dossier. La racine fermée
contient exactement :

```json
{
  "format": "R8C_A6_SCENE_LIBRARY",
  "version": 1,
  "definitions": [
    {
      "scene_definition_id": "identite_a5_a3",
      "variant_id": "identite_variante_authored",
      "definition": { "scene_id": "identite_a5_a3" }
    }
  ]
}
```

Chaque entrée est fermée aux trois champs affichés. Les deux identifiants sont
des chaînes authored, non vides, bornées, distinctes et non concaténées. Ils sont
uniques dans le bundle. `scene_definition_id` doit être identique au `scene_id`
du contrat A3. La définition est validée par
`SceneDefinition.valider_fermee`, qui prolonge le validateur A3 existant sans
créer une seconde représentation métier.

Toute erreur de racine, version, entrée, identité ou définition invalide le
bundle entier. L'instance de bibliothèque n'est publiée qu'après validation et
tri complets. Les lectures de définitions rendent des copies profondes.

Le bundle `r8c_a6_prototype_library.json` contient seulement trois preuves
synthétiques : une structure modulaire commune avec variantes Sandra et
Raphaëlle non interchangeables, et une scène signature Sandra. Il ne migre ni
n'ingère aucun des 88 JSON historiques.

## API

```gdscript
R8CNarrativeSceneLibrary.charger_depuis_json(path) -> Dictionary
R8CNarrativeSceneLibrary.charger_depuis_bundle(bundle) -> Dictionary

bibliotheque.obtenir_definition(scene_definition_id) -> Dictionary
bibliotheque.obtenir_ids_tries() -> Array[String]
bibliotheque.obtenir_identites_triees() -> Array
bibliotheque.query_candidates(moteur, etat_narratif, contexte) -> Dictionary
bibliotheque.query_candidates_dev(moteur, etat_narratif, contexte) -> Dictionary
```

`query_candidates()` délègue chaque définition à
`MinimalSceneEngine.evaluer_definition`. L'acte, les événements requis ou
interdits, les disponibilités, la fenêtre horaire, l'opportunité et l'unicité A5
restent donc évalués par A3. Le résultat joueur ne contient que les identités,
la version et l'échéance de revalidation des candidats compatibles.

`query_candidates_dev()` ajoute les diagnostics A3 complets des candidats et
des refus. Cette voie est fermée hors build de développement, test ou éditeur.
Les refus ne sont ni journalisés, ni persistés, ni exposés par l'API joueur.

## Déterminisme et invariants

- Le bundle est trié par le tuple structuré
  `(scene_definition_id, variant_id)`, indépendamment de l'ordre source.
- Une requête ne crée aucune instance A5, ne modifie aucun snapshot A1/A5 et ne
  matérialise aucune opportunité manquée.
- Une définition `UNIQUE` déjà connue du registre A5 est exclue par l'évaluateur
  existant; une définition `REPETABLE` reste soumise à ses autres conditions.
- Aucun diagnostic ne devient score, poids, préférence ou choix automatique.
- La bibliothèque n'est ni autoloadée, ni connectée à `PortraitMain` ou à
  l'oracle Saison 1.

## Limites et hors périmètre

La bibliothèque ne sélectionne, ne classe, ne réserve, ne propose, n'instancie
et ne résout aucune scène. Elle n'ajoute ni hasard, priorité numérique, quota,
cooldown, constructeur de journée, moteur de séquence, persistance nouvelle,
contenu canonique ou migration. R8C-A7 reste hors périmètre.

## Validation ciblée

```bash
python -m unittest \
  tests.test_r8c_a1_narrative_state_static \
  tests.test_r8c_a3_minimal_scene_prototype_static \
  tests.test_r8c_a5_persistent_scene_registry_static \
  tests.test_r8c_a6_minimal_narrative_library_static -v

godot --headless --path game res://tests/R8CAMinimalNarrativeLibrarySmokeTest.tscn
```

Le smoke A6 couvre 34 contrôles : construction/rejets atomiques, version et
identités, ordre stable, filtres A3, séparation des variantes, diagnostics,
immutabilité A1/A5 et exclusion d'une scène `UNIQUE` déjà consommée.
