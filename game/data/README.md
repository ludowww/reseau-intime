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
  chapter_01_raphaelle.json
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
- Les conversations peuvent être longues si elles installent la familiarité, mais elles ne doivent pas multiplier les choix visibles.
- Les premières images de profil doivent ancrer rapidement le casting.

## Scope actuel

Le contenu couvre seulement le Jour 1 du vertical slice :

- routine avec Marie ;
- premier message de Sandra, plus long pour installer leur familiarité ;
- premier échange avec Raphaëlle au travail ;
- annonce de la soirée chez Pauline dans le groupe amis ;
- première image de groupe ;
- photos de profil initiales des personnages principaux.

Aucune route dominante ne doit être verrouillée au Jour 1. Ce chapitre sert à installer les voix, le téléphone, les images mentales du casting, les habitudes de conversation et les premiers signaux faibles.
