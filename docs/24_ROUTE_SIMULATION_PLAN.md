# 24 — Plan de simulation des routes Jours 1 à 4

## Objectif

Ajouter un simulateur simple, déterministe et lisible pour vérifier que les données actuelles permettent de projeter des routes probables à la fin du Jour 4.

Ce simulateur n’est pas un moteur de jeu complet. Il sert uniquement de sonde produit/debug pour le vertical slice.

## Entrée

Le script part de :

```text
game/data/state/initial_state.json
```

Il conserve les valeurs initiales, puis applique manuellement des pas de parcours représentatifs : effets de choix, signaux passifs et flags.

## Parcours couverts

```text
marie_repair_path
mathilde_attention_path
sandra_emotional_path
pauline_risk_path
nico_marie_jealousy_path
balanced_no_lock_path
```

## Ce que le script calcule

Pour chaque parcours :

- variables finales ;
- flags principaux ;
- scores de pression de route ;
- route dominante probable ;
- route secondaire probable ;
- menace active probable ;
- mode relationnel seed.

Les scores sont des scores de pression issus des deltas depuis l’état initial, pas des verrous de fin de route.

## Règles de validation

Chaque parcours doit vérifier :

```text
PASS no_final_route_locked
PASS expected_route_probable
PASS coherent_threat
PASS balanced_no_strong_route
```

Interprétation :

- aucune route finale n’est verrouillée au Jour 4 ;
- le parcours ciblé rend la route attendue probable ;
- la menace active reste cohérente avec la route ;
- `balanced_no_lock_path` reste volontairement sans route forte.

## Limites assumées

MVP :

- parcours codés manuellement ;
- pas de parsing automatique de tous les choix narratifs ;
- pas de moteur de conditions complet ;
- pas de verrouillage de fins.

Plus tard :

- ingestion automatique des choix JSON ;
- matrice de reachability plus exhaustive ;
- génération de rapports comparatifs entre commits.

À éviter maintenant :

- refactor large des données narratives ;
- simulation temps réel ;
- ajout de contenu narratif pour faire passer les tests.
