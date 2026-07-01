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
- `profiles/player_sandra_proximity.json` : socle relationnel initial.
- `profiles/relationships/player_sandra.json` : état relationnel de départ.
- `routes/sandra_fantasy_profile.json` : fantasme spécifique de la route Sandra.
- `routes/sandra_route_arc.json` : phases longues de la route.
- `scene_contracts/day_01_sandra_photo_trigger.contract.json` : contrat de scène.
- `drafts/day_01_sandra_photo_trigger.draft.json` : petit draft de test, non final.
- `tools/dialogue_qa_rules_v0.json` : seuils QA V0.

## Lancer la QA

Depuis la racine du repo :

```bash
python3 tools/dialogue_qa.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
```

Le rapport est écrit dans :

```text
narrative_tool/reports/day_01_sandra_photo_trigger.qa.json
```

Wrappers disponibles :

```bash
python3 tools/validate_dialogue_json.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
python3 tools/check_player_presence.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
python3 tools/check_dialogue_rhythm.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
python3 tools/check_choice_text.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
python3 tools/check_intensity.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
python3 tools/check_route.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
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

## Notes de V0

Certains noms initialement prévus (`run_dialogue_qa.py`, `check_choice_sms_quality.py`, `check_desire_intensity.py`, `check_route_fantasy_presence.py`, `profiles/proximity/`) ont été raccourcis côté branche pour rester compatibles avec les restrictions du connecteur GitHub utilisé pendant la création du patch.

## Ajouter une scène plus tard

1. Créer un contrat dans `narrative_tool/scene_contracts/`.
2. Créer un draft dans `narrative_tool/drafts/`.
3. Ajouter ou adapter les seuils QA si nécessaire.
4. Lancer `tools/dialogue_qa.py` sur le draft.
5. Lire le rapport avant toute intégration dans `game_data`.
