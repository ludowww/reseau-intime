# Runtime — état technique courant

> **Statut :** `ACTIVE_RUNTIME_ORACLE_TEMPORAIRE`
> **Baseline R8C-A4 :** `4dda96f437d1e44658b7fc0748dca421ab98c0cc`

## Chaîne démarrée

`game/project.godot` lance `PortraitMain.tscn`. La coque portrait monte
`Season1RuntimeProvider`, `Season1State` et les providers J01–J21. Les providers
chargent explicitement les runtime maps puis leurs `conversation_paths`.

Cette chaîne est encore jouable et doit rester verte jusqu'à son remplacement.
Elle sert d'oracle de corpus et de comportement, pas de contrainte de modèle :

- ses noms `jNN_*`, sa progression fixe et ses snapshots ne doivent pas entrer
  dans les nouveaux modules R8C;
- aucune nouvelle compatibilité de sauvegarde legacy n'est autorisée;
- aucun score, signal passif accumulatif ou ancien loader n'est réintroduit;
- son retrait demande un lot de cutover explicite, pas un nettoyage silencieux.

## Dépendances conservées

- `DataLoader.load_json` pour les chemins explicites des providers;
- `DataLoader.get_visual_content` pour le pipeline média;
- `TimelineState.mark_day_complete` pour la chaîne active;
- providers, runtime maps et conversations référencées J01–J21;
- composants UI portrait, messages et galerie.

Les modules R8C-A1/A3 restent isolés et testés par leurs scènes smoke. La fixture
A3 sous `game/tests/fixtures/` n'est jamais une source de contenu canonique.

## Sauvegardes de développement

Aucun `SaveManager`, fichier `user://` ou format de sauvegarde sur disque
n'existe. Le runtime expose seulement des snapshots `Dictionary` en mémoire.
R8C-A4 ne change pas leur format. Au futur cutover, une version incompatible
pourra être refusée/réinitialisée sans migration longue, puisqu'aucune donnée de
production n'est à préserver.

## Gate canonique

Depuis la racine du dépôt :

```bash
python tools/validate_game_data.py
python tools/simulate_route_paths.py
python -m unittest discover -s tests -p "test_*.py" -v
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
git diff --check
```

Smokes R8C ciblés :

```bash
godot --headless --path game res://tests/R8CANarrativeStateSmokeTest.tscn
godot --headless --path game res://tests/R8CAMinimalScenePrototypeSmokeTest.tscn
```

`simulate_route_paths.py` valide désormais les branches qualitatives de la
fixture synthétique R8C-A3; il ne calcule aucune route dominante ni aucun score.

## Autorité

Pour le modèle futur, lire `docs/architecture/README.md`. Pour les décisions et
suppressions A4, lire
`docs/maintenance/R8C_A4_CONSOLIDATION_CANONIQUE_ET_NETTOYAGE_LEGACY.md`.
