# Outils de validation narrative V2

## Statut

Documentation d’usage pour les nouveaux outils d’aide auteur.

Ces outils ne modifient pas les données.
Ils produisent des rapports et des warnings pour revue humaine.

Ils ne décident pas qu’une scène est bonne ou mauvaise.

## Objectif

Éviter les régressions narratives identifiées sur J5/J6 :

```text
- Player absent ou seulement implicite ;
- scènes qui tournent en rond ;
- motifs répétés sans nouvelle fonction ;
- absence de pivot concret ;
- photos trop rares ou sans fonction ;
- routes incompatibles avancées en même temps ;
- ouverture/polyamour utilisée pour excuser le mensonge ;
- Raphaëlle utilisée comme cachette ;
- Sandra maintenue en attente ;
- Mathilde réduite à “photo gardée ?”.
```

## Outils ajoutés

### `tools/player_presence_check.py`

Vérifie si Player a des réponses visibles, surtout après les choix.

Usage :

```bash
python3 tools/player_presence_check.py game/data/conversations/chapter_05_*.json
```

Usage strict :

```bash
python3 tools/player_presence_check.py game/data/conversations/chapter_05_*.json --strict
```

Signale notamment :

```text
- aucun message visible de Player ;
- choix forts sans réponse Player ;
- choix avec peu ou pas de next_messages ;
- ratio trop faible de choix avec réponse Player.
```

### `tools/motif_repetition_check.py`

Repère les motifs qui peuvent créer une impression de boucle.

Usage :

```bash
python3 tools/motif_repetition_check.py game/data/conversations/chapter_05_*.json
```

Motifs surveillés :

```text
- téléphone / absence / écran ;
- Sandra “plus tard” / attente ;
- photo / trace / preuve gardée ;
- Pauline preuve / contrôle ;
- Raphaëlle refuge / cachette ;
- Marie / Nico / jalousie.
```

Important : un motif peut revenir s’il change de fonction. L’outil demande seulement de le vérifier.

### `tools/scenario_pivot_check.py`

Cherche si une scène expose un vrai pivot : action, conséquence, état de route, preuve, décision.

Usage :

```bash
python3 tools/scenario_pivot_check.py game/data/conversations/chapter_06_*.json
```

Signale notamment :

```text
- choix sans conséquence visible ;
- absence de vocabulaire d’action ou de décision ;
- scène très courte ;
- J5/J6 sans action visible de Player.
```

### `tools/photo_density_check.py`

Rapporte la densité de contenus visuels et le langage photo.

Usage :

```bash
python3 tools/photo_density_check.py game/data/conversations/chapter_06_*.json
```

Il compare au garde-fou souple : environ 3 photos par jour, sauf choix narratif contraire.

Signale notamment :

```text
- journée sous le niveau cible ;
- dialogue assez long sans photo ni langage visuel ;
- contenu visuel sans contexte ;
- vocabulaire explicite sans référence visuelle prévue.
```

### `tools/route_compatibility_check.py`

Repère les risques de compatibilité entre routes.

Usage :

```bash
python3 tools/route_compatibility_check.py game/data/conversations/chapter_06_*.json
```

Signale notamment :

```text
- Raphaëlle active avec beaucoup de langage de cachette/mensonge ;
- ouverture/polyamour avec trop de mensonge ;
- Marie/Nico sans clarté relationnelle ;
- Mathilde + ouverture sans conflit de loyauté ;
- Sandra confiance + route fortement cachée ;
- trop de familles de routes actives dans une seule scène.
```

## Workflow recommandé avant rewrite J5/J6

Après écriture d’une version J5 :

```bash
python3 tools/dialogue_rhythm_report.py game/data/conversations/chapter_05_*.json
python3 tools/player_presence_check.py game/data/conversations/chapter_05_*.json
python3 tools/motif_repetition_check.py game/data/conversations/chapter_05_*.json
python3 tools/scenario_pivot_check.py game/data/conversations/chapter_05_*.json
python3 tools/photo_density_check.py game/data/conversations/chapter_05_*.json
python3 tools/route_compatibility_check.py game/data/conversations/chapter_05_*.json
```

Après écriture d’une version J6 :

```bash
python3 tools/dialogue_rhythm_report.py game/data/conversations/chapter_06_*.json
python3 tools/player_presence_check.py game/data/conversations/chapter_06_*.json
python3 tools/motif_repetition_check.py game/data/conversations/chapter_06_*.json
python3 tools/scenario_pivot_check.py game/data/conversations/chapter_06_*.json
python3 tools/photo_density_check.py game/data/conversations/chapter_06_*.json
python3 tools/route_compatibility_check.py game/data/conversations/chapter_06_*.json
```

Puis compléter par :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

## Interprétation des warnings

Un warning n’est pas forcément un blocage.

Il devient bloquant si :

```text
- il confirme une boucle déjà identifiée ;
- Player disparaît des choix forts ;
- J5 ne rend pas Marie active ;
- J6 ne contient aucun acte concret de Player ;
- une route claire avance dans un cadre de mensonge non reconnu ;
- la journée n’a aucune photo sans justification narrative.
```

## Règle finale

```text
Les outils alertent.
L’auteur décide.
Mais une scène qui déclenche les mêmes warnings que J5/J6 actuels doit être reprise avant validation narrative.
```
