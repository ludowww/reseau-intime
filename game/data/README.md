# Données de jeu

Ce dossier contient les premiers fichiers JSON exploitables par le futur prototype Godot.

## Structure

```text
characters/
  ludo.json
  marie.json
  mathilde.json
  sandra.json
  raphaelle.json
  pauline.json
  nico.json

state/
  initial_state.json

conversations/
  chapter_01_index.json
  chapter_01_marie.json
  chapter_01_sandra.json
  chapter_01_group_friends.json

visual_content/
  placeholders.json
```

## Règles

- Les personnages définissent l’identité narrative et la voix.
- `initial_state.json` définit les variables de départ.
- Les conversations sont organisées par chapitre et par thread.
- Les effets de choix utilisent les noms de variables définis dans la documentation.
- Les placeholders visuels restent neutres tant que le pipeline d’assets adultes n’est pas défini.

## Scope actuel

Le contenu couvre seulement le Jour 1 du vertical slice :

- routine avec Marie ;
- premier message léger de Sandra ;
- annonce de la soirée chez Pauline dans le groupe amis.

Aucune route dominante ne doit être verrouillée au Jour 1. Ce chapitre sert à installer les voix, le téléphone et les premiers signaux faibles.
