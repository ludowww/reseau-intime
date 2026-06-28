# J3 — Brief d’intégration data-first

## Statut

Brief opérationnel pour intégrer le Jour 3 dans le prototype data-first.

Ce document ne remplace pas `docs/J3_WRITING_FOUNDATION.md`. Il le transforme en consignes techniques et narratives exploitables pour une branche d’intégration.

## Base de travail

Base stable recommandée pour l’intégration runtime/data :

```text
main / origin/main = 3b29d73514d1cbbbca55e00635c4faac6c1e4f62
```

La branche documentaire source est :

```text
work/j3-j5-desire-tension-visual-routes-docs
```

Ne pas intégrer J4/J5 en data-first dans le même patch. J4/J5 sont cadrés, mais la première intégration doit rester limitée à J3.

## Objectif du patch J3

Ajouter un Jour 3 jouable data-first qui prolonge J2 sans casser le modèle actuel :

```text
J3 — Retour maison + premier désir domestique visible + premiers secrets conscients
```

Le patch doit prouver :

- que Player est physiquement revenu après J2 ;
- que Mathilde a bien dormi chez Marie / Player ;
- que les photos deviennent des traces et pas seulement des récompenses ;
- que Marie reste ancrage et désir ;
- que Sandra reste rare et émotionnelle ;
- que Raphaëlle sert de clarté calme ;
- qu’aucune route dominante n’est verrouillée en J3.

## Scope strict

### À faire

- Ajouter `game/data/conversations/chapter_03_index.json` si le fichier actuel est vide, placeholder ou non aligné.
- Ajouter / remplacer les conversations J3 nécessaires dans `game/data/conversations/`.
- Ajouter les contenus visuels placeholder J3 nécessaires dans `game/data/visual_content/placeholders.json` ou dans un fichier de catalogue approprié si le projet en possède déjà un pour les chapitres.
- Garder une ligne Messages visible par personnage.
- Réutiliser les threads existants par personnage : Marie, Mathilde, Raphaëlle, Sandra.
- Ajouter des notifications / unlocks réels via `conversation_availability`.
- Utiliser les réponses Player uniquement via `choices`, pas comme messages automatiques.
- Faire passer les validations existantes.

### À ne pas faire

- Ne pas intégrer J4/J5.
- Ne pas activer Pauline/Nico comme conversations lourdes en J3.
- Ne pas créer de groupe actif obligatoire en J3.
- Ne pas modifier J1/J2 sauf nécessité technique minimale.
- Ne pas produire d’assets définitifs.
- Ne pas ajouter de système lourd de galerie.
- Ne pas verrouiller de route dominante.
- Ne pas changer le modèle Messages existant.

## Fichiers probables à créer

```text
game/data/conversations/chapter_03_index.json
game/data/conversations/chapter_03_marie_morning.json
game/data/conversations/chapter_03_mathilde_morning.json
game/data/conversations/chapter_03_raphaelle_midday.json
game/data/conversations/chapter_03_sandra_evening.json
game/data/conversations/chapter_03_marie_night.json
```

## Fichiers probables à modifier

```text
game/data/visual_content/placeholders.json
game/scripts/core/DataLoader.gd
tests/test_godot_prototype_static.py
```

Modifier `DataLoader.gd` seulement si `chapter_03_index.json` n’est pas déjà référencé ou chargé.

Modifier les tests uniquement pour refléter l’existence attendue de J3, jamais pour affaiblir les garanties J1/J2 existantes.

## Structure J3 à intégrer

```text
1. chapter_03_marie_morning — retour physique / maison
2. chapter_03_mathilde_morning — réveil canapé / photo ambiguë
3. chapter_03_raphaelle_midday — clarté calme
4. chapter_03_sandra_evening — jeudi maintenu / message ou photo retenue
5. chapter_03_marie_night — clôture Marie / présence réelle
```

## Modèle d’index J3 recommandé

`chapter_03_index.json` doit rester proche du modèle J2 : `moment_flow`, `conversation_files`, `required_reveals`, `routes_available`, `routes_locked_to_seed_only`, `debug_expected_outcomes`, `conversation_availability`.

### Moments recommandés

```text
08:12 — Marie matin / retour physique
09:34 — Mathilde matin / canapé
12:41 — Raphaëlle midi / clarté
18:27 — Sandra soir / jeudi
23:02 — Marie nuit / présence
```

### Conversations initiales / unlocks

Initial :

```text
chapter_03_marie_morning
```

Unlocks séquentiels recommandés :

```text
chapter_03_mathilde_morning après chapter_03_marie_morning
chapter_03_raphaelle_midday après chapter_03_mathilde_morning
chapter_03_sandra_evening après chapter_03_raphaelle_midday
chapter_03_marie_night après chapter_03_sandra_evening
```

Chaque unlock doit avoir `pending: true` et une notification courte.

### Notifications proposées

```text
Mathilde — Votre canapé demande réparation.
Raphaëlle — Tu avais l’air ailleurs ce matin.
Sandra — Je fais semblant de ne pas penser à jeudi.
Marie — Tu viens vraiment te poser ?
```

## Threads à réutiliser

Les conversations doivent garder un fil visible par personnage :

```text
thread_marie_private
thread_mathilde_private
thread_raphaelle_private
thread_sandra_private
```

Ne pas créer `thread_marie_morning`, `thread_marie_night`, etc.

## Contenus visuels J3

### Obligatoire — Mathilde canapé matin

ID recommandé :

```text
mathilde_j3_morning_couch_placeholder
```

Type : `photo`.

Tier : 1 ou 2 selon convention actuelle.

Source : `messages`.

Risk : preuve domestique, risque 3 recommandé.

Context :

```text
Mathilde au réveil sur le canapé de Marie et Player, plaid autour d’elle, cheveux un peu défaits, tasse à moitié pleine près d’elle. Elle sourit comme si la situation était normale, mais le cadrage rend la scène plus intime qu’elle ne devrait l’être.
```

`can_be_discovered_by` recommandé :

```json
["marie", "mathilde", "pauline"]
```

### Conditionnel — Marie maison / retour

ID recommandé :

```text
marie_j3_home_tender_placeholder
```

Type : `photo`.

Tier : 1.

Source : `messages`.

Risk : faible, non preuve ou preuve légère.

Context :

```text
Marie dans la cuisine ou le salon, lumière douce du matin, tenue simple mais flatteuse, un détail de maison visible. L’image est tendre, intime, et rappelle que le couple possède encore une sensualité réelle.
```

### Trace Sandra — pas forcément une vraie photo

Ne pas créer forcément une nouvelle photo Sandra réelle en J3.

Préférer un message supprimé, une photo presque envoyée, ou un flag :

```text
sandra_deleted_message_j3
sandra_almost_sent_photo_j3
```

## Conversation J3 — exigences narratives

### Marie matin

Fonction : réinstaller Marie comme ancrage et désir.

Doit contenir :

- retour physique ;
- maison / café / fatigue ;
- téléphone comme détail ;
- Marie qui sent que Player est là sans être totalement revenu ;
- possibilité de répondre avec tendresse, esquive, vérité partielle ou désir couple.

Choix minimum :

```text
rassurer tendrement
minimiser / esquiver
être sincère mais incomplet
réactiver le couple
```

### Mathilde matin

Fonction : conséquence de la nuit chez eux.

Doit contenir :

- canapé / plaid / tasse / salon ;
- humour Mathilde ;
- photo obligatoire ;
- choix de rester léger, flirter doucement, poser une limite, conserver ou supprimer.

La photo ne doit pas être explicite ; elle doit être intime par contexte.

### Raphaëlle midi

Fonction : clarté calme.

Doit contenir :

- travail / pause ;
- observation de la fatigue de Player ;
- possibilité de dire que ça va, reconnaître le flou ou chercher un appui ;
- limite douce de Raphaëlle.

Pas de photo obligatoire.

### Sandra soir

Fonction : rareté émotionnelle et jeudi maintenu.

Doit contenir :

- jeudi ;
- photo J1 ou souvenir ;
- message supprimé ou phrase retenue ;
- choix de rassurer, pousser, esquiver par humour, parler de jeudi.

Pas de nouvelle grosse photo Sandra.

### Marie nuit

Fonction : fermer J3 sur Marie.

Doit contenir :

- demande de présence ;
- douceur inquiète ;
- choix de revenir vers elle, mentir doucement, avouer une partie, esquiver par tendresse ;
- dernier message fort.

## Variables utilisables

Respecter les variables connues par `tools/validate_game_data.py` :

```text
marie_trust
lie_score
truth_tendency
ludo_jealousy
social_pressure
marie.trust
marie.lucidity
mathilde.desire
mathilde.loyalty
sandra.attachment
sandra.exposure
raphaelle.attachment
raphaelle.clarity
pauline.interest
pauline.control
nico.desire_for_marie
nico.place_near_marie
marie_attention_score
marie_neglect_score
mathilde_attention_score
sandra_priority_score
raphaelle_clarity_score
pauline_risk_score
nico_surveillance_score
```

Ne pas inventer de nouvelles variables sans mettre à jour explicitement les validateurs et sans justification.

## Flags recommandés

Flags J3 possibles :

```text
player_returned_home_j3
marie_noticed_distance_j3
mathilde_morning_after_home_j3
photo_mathilde_canape_morning_j3_received
photo_mathilde_canape_morning_j3_kept
photo_mathilde_canape_morning_j3_deleted
photo_marie_home_j3_available
photo_marie_home_j3_received
raphaelle_noticed_fatigue_j3
raphaelle_boundary_seed_j3
sandra_deleted_message_j3
sandra_almost_sent_photo_j3
sandra_thursday_confirmed_j3
truth_seed_marie_j3
lie_to_marie_j3
```

Si un flag est utilisé en condition, il doit être créé quelque part par `sets_flags` ou être traité comme condition connue.

## Effets recommandés

Limiter les effets par choix à 1-3 variables / flags.

Exemples :

```json
"effects": {
  "marie_trust": 1,
  "lie_score": -1,
  "marie_attention_score": 1
}
```

```json
"effects": {
  "mathilde.desire": 2,
  "mathilde.loyalty": -1,
  "lie_score": 1
}
```

```json
"sets_flags": ["sandra_thursday_confirmed_j3"]
```

## Tests / validations à faire

Commandes recommandées après intégration :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

## Tests statiques à adapter ou ajouter

Ajouter des tests pour garantir :

- `DataLoader.gd` référence `res://data/conversations/chapter_03_index.json` si nécessaire ;
- `chapter_03_index.json` existe ;
- J3 initial conversation = `chapter_03_marie_morning` ;
- J3 utilise les fils visibles Marie / Mathilde / Raphaëlle / Sandra ;
- Pauline et Nico ne sont pas conversations lourdes J3 ;
- Mathilde J3 contient un contenu visuel référencé dans le catalogue ;
- les réponses Player restent uniquement dans `choices` ;
- pas de sender automatique `player`, `ludo` ou `joueur` dans les messages narratifs ;
- aucun contenu J4/J5 n’est intégré dans ce patch.

## Critères d’acceptation

Le patch J3 est acceptable si :

- J3 est jouable depuis la progression existante ;
- les cinq conversations J3 s’enchaînent proprement ;
- les pending/unread suivent uniquement les vrais unlocks ;
- les fils visibles restent groupés par personnage ;
- la photo Mathilde J3 est cataloguée et référencée ;
- aucune route dominante n’est verrouillée ;
- J4/J5 restent documentation-only ;
- toutes les validations passent.

## Résumé opérationnel

```text
Intégrer J3 comme une journée courte mais dense :
Marie ouvre, Mathilde rend la nuit visible, Raphaëlle clarifie, Sandra maintient jeudi, Marie clôt.
La photo Mathilde J3 est la première preuve domestique consciente.
Marie reste une route de désir, pas seulement la personne à qui l’on ment.
Sandra reste rare.
Raphaëlle reste claire.
Pauline/Nico attendent J4.
```
