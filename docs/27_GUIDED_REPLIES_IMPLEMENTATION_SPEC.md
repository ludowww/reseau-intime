# 27 — Spécification d’implémentation des réponses guidées

## Objectif

Corriger le ressenti de monologue dans le prototype Godot.

Le joueur doit avoir l’impression que Ludo participe activement aux conversations, même quand il n’est pas en train de prendre une grande décision narrative.

## Base actuelle

Le prototype affiche correctement :

- jours ;
- conversations ;
- messages ;
- choix ;
- effects ;
- flags ;
- debug.

Mais les conversations ressemblent encore trop souvent à :

```text
Personnage : message
Personnage : message
Personnage : message
Choix joueur
Personnage : réponse
```

Il faut viser :

```text
Personnage : message
Personnage : message
Ludo : réponse guidée
Personnage : réponse
Personnage : relance
Ludo : réponse guidée ou choix narratif
```

## Principe d’implémentation MVP

Ne pas refondre tout le format JSON immédiatement.

Pour la première passe :

```text
Si un segment contient exactement 1 choix, l’UI doit le présenter comme une réponse guidée.
Si un segment contient plusieurs choix, l’UI continue de le présenter comme un vrai choix narratif.
```

## UI attendue

### Cas choix unique

Afficher un titre :

```text
Réponse
```

ou aucun titre si le bouton est clairement une réponse.

Le bouton doit ressembler davantage à un message sortant.

Après clic :

```text
Ludo : [texte du choix]
```

Puis afficher les `next_messages` et `automatic_followup`.

Ne pas afficher :

```text
Choix appliqué : ...
```

Ou alors le garder seulement en debug.

### Cas choix multiple

Conserver :

```text
Choix disponibles
```

Après clic :

```text
Choix appliqué : ...
```

Ce cas correspond à un vrai choix de route ou de ton.

## Data recommandée à terme

Le format pourra évoluer vers :

```json
{
  "id": "reply_example",
  "type": "guided_reply",
  "text": "Je suis là.",
  "effects": {},
  "sets_flags": []
}
```

Mais cette évolution n’est pas obligatoire pour la première passe.

## Première passe data recommandée

Créer une branche courte pour modifier seulement quelques scènes afin de tester le rythme.

Scènes prioritaires :

```text
game/data/conversations/chapter_01_sandra.json
game/data/conversations/chapter_01_marie.json
game/data/conversations/chapter_02_raphaelle_midday.json
game/data/conversations/chapter_02_sandra_evening.json
```

Objectif : introduire davantage de segments avec un seul choix / réponse guidée.

Ne pas réécrire tous les Jours 1 à 4 en une seule fois.

## Exemple cible — Sandra Jour 1

Au lieu de :

```text
Sandra : Hey, tu survis ?
Sandra : J’ai pensé à toi.
Sandra : Enfin pas comme ça.
Choix A / B / C
```

Viser :

```text
Sandra : Hey, tu survis ?
Sandra : J’ai pensé à toi tout à l’heure.

Réponse guidée :
À peine. Pourquoi ?

Sandra : Rien.
Sandra : Enfin si.
Sandra : Tu as cette façon de dire que ça va quand ça ne va pas.

Choix narratif éventuel :
- Je fais semblant avec talent.
- Tu me connais trop bien.
- Ça va vraiment.
```

## Effets et flags

Les réponses guidées peuvent appliquer des effets très faibles :

```text
+1 attachment
+1 trust
flag de pacing
```

Mais éviter :

```text
+3 ou plus
lie_score fort
preuve
route lock
```

## Tests attendus

Après modification :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

## Critère de réussite manuel

Dans Godot, ouvrir une scène modifiée et vérifier :

```text
Le joueur clique plusieurs fois sur des réponses courtes.
La conversation ressemble davantage à un échange.
Les vrais choix multiples restent identifiables.
Le debug continue de fonctionner.
Les autres choix sont désactivés après sélection.
```

## Prompt Hermes recommandé

```text
Repo : ludowww/reseau-intime
Base : main actuel après UI readability.
Objectif : implémenter le support UI des réponses guidées et adapter quelques scènes prioritaires.

Contraintes :
- Ne pas réécrire tout le contenu.
- Ne pas modifier les routes globales.
- Si un segment a exactement 1 choix, l’afficher comme réponse guidée.
- Si un segment a plusieurs choix, garder Choix disponibles.
- Ajouter/adapter seulement quelques segments de Jour 1 / Jour 2 pour tester le rythme.
- Ne pas ajouter de nouvelle feature narrative.
- Aucun asset adulte.

Validation :
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit

Retour attendu :
- fichiers modifiés ;
- capture ou description du rythme après test ;
- SHA commit ;
- limites restantes.
```

## Règle finale

> Le bouton unique fait avancer la parole. Le choix multiple oriente l’histoire.