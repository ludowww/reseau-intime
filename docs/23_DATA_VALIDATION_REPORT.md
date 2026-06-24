# 23 — Rapport initial de validation des données

## Statut

Validateur ajouté, à exécuter localement.

## Fichiers ajoutés

```text
tools/validate_game_data.py
docs/22_DATA_VALIDATION_PLAN.md
docs/23_DATA_VALIDATION_REPORT.md
```

## Commande

Depuis la racine du dépôt :

```bash
python3 tools/validate_game_data.py
```

## Ce qui est couvert

Le validateur vérifie statiquement :

- tous les JSON sous `game/data/` ;
- les erreurs de parsing JSON ;
- les IDs dupliqués ;
- les références `res://data/...` ;
- les références `content_id` ;
- les variables inconnues dans les `effects` ;
- les flags créés via `sets_flags` ;
- les tokens utilisés dans les conditions ;
- certains warnings structurels sur les fichiers de conversation.

## Ce qui n’est pas encore couvert

Le validateur ne fait pas encore :

- simulation de route complète ;
- exécution réelle des conditions ;
- vérification de tous les assets `res://assets/...` ;
- validation Godot ;
- test d’interface ;
- test de lisibilité narrative.

## Points d’attention connus

Les conditions sont actuellement écrites sous forme textuelle, par exemple :

```text
opened_pauline_first_party_day3 OR answered_pauline_pressure_private_day3
marie_neglect_score >= 2
```

Le validateur extrait les tokens probables, mais n’est pas encore un moteur logique complet. C’est suffisant pour repérer des flags ou variables inconnus, mais pas pour simuler toutes les branches.

## Étape suivante recommandée

1. Exécuter le validateur localement.
2. Corriger les erreurs bloquantes s’il y en a.
3. Ajouter ensuite un validateur narratif plus avancé :

```text
tools/simulate_route_paths.py
```

Ce futur script devra tester des parcours de référence : Marie, Mathilde, Sandra, Pauline, Nico/Marie, Raphaëlle.

## Règle finale

> La validation statique protège le chargement. La simulation protégera les routes.