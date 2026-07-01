# Narrative SMS Tool V0

Outil hors runtime pour préparer, critiquer et valider des scènes SMS narratives à routes pour `Réseau Intime`.

## Scope V0

Cette V0 se concentre sur une seule scène benchmark :

`Day 1 — Sandra — conversation pilier — photo trigger`

Elle sert à valider l'architecture minimale :

- profils narratifs JSON ;
- contexte de proximité initiale ;
- fantasme de route ;
- contrat de scène ;
- draft de test ;
- règles QA ;
- scripts Python simples.

Elle ne génère pas encore automatiquement une scène complète et ne modifie pas le runtime Godot.

## Fichiers principaux

- `project/project_intent.json` : intention d'œuvre et promesse joueur.
- `project/desire_intensity_scale.json` : échelle d'intensité 0–10.
- `profiles/characters/player.json` : voix et posture du Player.
- `profiles/characters/sandra.json` : voix SMS et limites de Sandra.
- `profiles/desire/sandra_desire_profile.json` : désir propre de Sandra.
- `profiles/proximity/player_sandra_proximity.json` : socle relationnel initial.
- `profiles/relationships/player_sandra.json` : état relationnel de départ.
- `routes/sandra_fantasy_profile.json` : fantasme spécifique de la route Sandra.
- `routes/sandra_route_arc.json` : phases longues de la route.
- `scene_contracts/day_01_sandra_photo_trigger.contract.json` : contrat de scène.
- `drafts/day_01_sandra_photo_trigger.draft.json` : petit draft de test, non final.
- `qa_rules/*.json` : règles de diagnostic.

## Lancer la QA

Depuis la racine du repo :

```bash
python3 tools/run_dialogue_qa.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
```

Le rapport est écrit dans :

```text
narrative_tool/reports/day_01_sandra_photo_trigger.qa.json
```

## Ce que la V0 vérifie

- JSON parseable et structure minimale.
- Identifiants de messages uniques.
- Speakers valides.
- Présence Player.
- Monologues et rythme basique.
- Choix formulés comme de vrais SMS.
- Intensité de désir compatible avec le contrat.
- Présence des éléments du fantasme Sandra.
- Sorties mémoire/state minimales.

## Ce que la V0 ne fait pas encore

- Pas de génération automatique complète.
- Pas de révision stylistique automatique.
- Pas de comparaison avancée de voix personnage.
- Pas de simulation route multi-jours.
- Pas d'intégration runtime Godot.
- Pas de modification des conversations existantes.

## Ajouter une scène plus tard

1. Créer un contrat dans `narrative_tool/scene_contracts/`.
2. Créer un draft dans `narrative_tool/drafts/`.
3. Ajouter ou adapter les règles QA si nécessaire.
4. Lancer `tools/run_dialogue_qa.py` sur le draft.
5. Lire le rapport avant toute intégration dans `game_data`.
