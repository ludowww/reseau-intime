# Données de jeu

Le runtime portrait charge explicitement :

- `runtime/season_1/j01_runtime_map.json` à `j21_runtime_map.json`;
- les conversations listées par leurs `conversation_paths`;
- les catalogues sous `visual_content/` nécessaires au pipeline média;
- les profils d'écriture sous `writing/` utilisés par les outils d'auteur.

Il n'existe aucun scan automatique de `game/tests/fixtures/`. La fixture R8C-A3
est synthétique et ne peut pas devenir du contenu canonique par le loader courant.

Les anciens index de navigation, l'état initial à scores et les conversations
absentes des 21 runtime maps ont été supprimés par R8C-A4. Git en conserve
l'historique.

Validation :

```bash
python tools/validate_game_data.py
```

Le validateur parse tous les JSON restants, vérifie l'unicité des identifiants,
les chemins `res://data/` et les références de médias et de flags. Aucun effet à
score ou signal passif accumulatif n'est accepté.
