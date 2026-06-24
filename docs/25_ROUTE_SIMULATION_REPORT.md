# 25 — Rapport de simulation des routes Jours 1 à 4

## Statut

```text
OK
```

Le simulateur `tools/simulate_route_paths.py` couvre les six parcours demandés et vérifie que le Jour 4 produit des routes probables sans verrouiller de route finale.

## Commande

```bash
python tools/simulate_route_paths.py
```

## Résultat synthétique

| Parcours | Dominante probable | Secondaire probable | Menace active | Mode seed | Statut |
| --- | --- | --- | --- | --- | --- |
| `marie_repair_path` | `marie` | `none` | `contained_secrets` | `EXCLUSIF_REPARATION` | PASS |
| `mathilde_attention_path` | `mathilde` | `none` | `marie_or_mathilde_guilt` | `SECRET_AFFAIR` | PASS |
| `sandra_emotional_path` | `sandra` | `none` | `exposure_or_marie` | `SECRET_AFFAIR_EMOTIONAL` | PASS |
| `pauline_risk_path` | `pauline` | `none` | `proof_capture` | `SECRET_AFFAIR` | PASS |
| `nico_marie_jealousy_path` | `nico_marie` | `none` | `nico` | `NTR_SUBI_SEED` | PASS |
| `balanced_no_lock_path` | `none` | `none` | `low_pressure` | `HONEST_UNRESOLVED` | PASS |

## Checks validés

Tous les parcours passent :

```text
PASS no_final_route_locked
PASS expected_route_probable
PASS coherent_threat
PASS balanced_no_strong_route
```

## Lecture produit

- Les routes fortes du vertical slice sont atteignables par accumulation de signaux, pas par un seul choix.
- Les menaces associées restent cohérentes : Marie/secrets, culpabilité Mathilde, exposition Sandra, preuve Pauline, Nico.
- Le parcours équilibré ne force aucune route forte.
- Le script reste volontairement déterministe et manuel : c’est un outil de validation produit, pas encore un moteur narratif.

## Limites restantes

- Les listes de choix sont représentatives, pas exhaustives.
- Les seuils de score sont des heuristiques de debug.
- Le script ne parse pas encore automatiquement les arbres de conversations.
