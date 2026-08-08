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

Les modules R8C-A1/A3/A5/A6/A7 restent isolés et testés par leurs scènes smoke. La
fixture A3 et le bundle prototype A6 ne sont jamais des sources de contenu canonique.

## Sauvegardes de développement

Aucun `SaveManager`, fichier `user://` ou format de sauvegarde sur disque
n'existe. Le runtime expose seulement des snapshots `Dictionary` en mémoire.
R8C-A4 ne change pas leur format. Au futur cutover, une version incompatible
pourra être refusée/réinitialisée sans migration longue, puisqu'aucune donnée de
production n'est à préserver.

### `PRE_RELEASE_CATALOG_SAVE_POLICY`

Tant que la Saison 1 est en construction, save/reload est garanti uniquement
dans une même révision du catalogue authored. La compatibilité entre deux
fingerprints successifs du catalogue n'est pas garantie : un snapshot portant
un autre fingerprint est refusé fail-closed, sans migration automatique.

Cette politique évite de créer une migration OA01 → OA02 → OA03 pour chaque
ajout de contenu avant stabilisation. Une politique de compatibilité durable
sera définie avant toute distribution publique.

## Gate canonique

Depuis la racine du dépôt :

```bash
python tools/validate_game_data.py
python tools/simulate_route_paths.py
python -m unittest discover -s tests -p "test_*.py" -v
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
bash tools/test_r8c_a4_final_portrait_ux.sh
bash tools/test_all_canonical_godot_smokes.sh
git diff --check
```

Smokes R8C ciblés :

```bash
godot --headless --path game res://tests/R8CANarrativeStateSmokeTest.tscn
godot --headless --path game res://tests/R8CAMinimalScenePrototypeSmokeTest.tscn
godot --headless --path game res://tests/R8CAPersistentSceneRegistrySmokeTest.tscn
godot --headless --path game res://tests/R8CAMinimalNarrativeLibrarySmokeTest.tscn
godot --headless --path game res://tests/R8CACandidateReservationProposalSmokeTest.tscn
```

Le smoke final A4 monte la vraie scène `PortraitMain` et couvre les surfaces
Messages, Galerie et PhotoViewer sur J01, J09, J12, J15 et J21. Il vérifie
également les choix, états de notification/non-lu, transitions temporelles,
retours vers la liste, placeholders et navigation de séquence disponibles.
Le lanceur exhaustif exécute en plus les 50 scènes `*SmokeTest.tscn` encore
présentes avec leurs arguments contractuels; aucune scène canonique n'est tenue
hors gate.

`simulate_route_paths.py` valide désormais les branches qualitatives de la
fixture synthétique R8C-A3; il ne calcule aucune route dominante ni aucun score.

## Autorité

Pour le modèle futur, lire `docs/architecture/README.md`. Pour les décisions et
suppressions A4, lire
`docs/maintenance/R8C_A4_CONSOLIDATION_CANONIQUE_ET_NETTOYAGE_LEGACY.md`.
