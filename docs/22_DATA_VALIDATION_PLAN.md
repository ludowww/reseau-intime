# 22 — Plan de validation des données

## Objectif

Sécuriser les données JSON avant intégration Godot.

Le vertical slice contient maintenant des données narratives sur plusieurs jours, avec :

- personnages ;
- état initial ;
- conversations segmentées ;
- choix ;
- flags ;
- variables ;
- contenus visuels ;
- preuves conditionnelles ;
- aftershocks ;
- calcul debug de route probable.

Il faut donc valider automatiquement ce qui peut l’être.

## Ce que le validateur doit vérifier

### JSON valide

Tous les fichiers `.json` sous `game/data/` doivent être lisibles par Python.

### IDs uniques

Le validateur doit détecter les collisions d’IDs dans :

```text
id
message id
choice id
flag id
content id
conversation_segment_id
notification id
```

### Références de fichiers

Les chemins `res://data/...` présents dans les index doivent pointer vers un fichier réel du dépôt.

### Références de contenu visuel

Les `content_id` utilisés dans les conversations doivent exister dans :

```text
game/data/visual_content/placeholders.json
game/data/visual_content/chapter_04_proofs.json
```

### Variables connues

Les effets de choix doivent utiliser des variables connues.

Variables globales connues :

```text
marie_trust
lie_score
truth_tendency
ludo_jealousy
social_pressure
```

Variables personnage connues :

```text
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
```

Signaux passifs connus :

```text
marie_attention_score
marie_neglect_score
mathilde_attention_score
sandra_priority_score
raphaelle_clarity_score
pauline_risk_score
nico_surveillance_score
```

### Flags

Les flags peuvent être créés librement dans les données, mais le validateur doit :

- lister tous les flags créés ;
- lister tous les flags référencés dans des conditions ;
- signaler les flags utilisés en condition mais jamais créés.

### Conditions

Le validateur doit repérer les conditions textuelles contenant :

```text
OR
AND
>=
<=
```

Il ne doit pas encore essayer de tout exécuter comme un moteur logique complet. Il doit seulement extraire les tokens probables et vérifier les références évidentes.

### Erreurs bloquantes

Sont bloquants :

- JSON invalide ;
- référence `res://data/...` inexistante ;
- `content_id` inexistant ;
- variable inconnue dans `effects` ;
- ID dupliqué.

### Avertissements

Sont des warnings :

- flag utilisé en condition mais jamais créé ;
- champ recommandé manquant ;
- fichier d’index sans `conversation_files` ;
- conversation sans `debug_notes` ;
- choix sans `effects` explicite.

## Commande cible

```bash
python tools/validate_game_data.py
```

## Résultat attendu

Le script doit afficher :

```text
OK: JSON files parsed
OK: no duplicate ids
OK: content references valid
OK: variable references valid
WARN: ...
```

Il doit retourner :

```text
0 si aucune erreur bloquante
1 si au moins une erreur bloquante
```

## Limite

Ce validateur vérifie la cohérence statique des données. Il ne remplace pas :

- un test de gameplay ;
- une simulation complète des routes ;
- une validation narrative humaine ;
- une vérification Godot des scènes et UI.

## Règle finale

> Les données doivent être assez cohérentes pour être chargées, puis assez lisibles pour être corrigées.