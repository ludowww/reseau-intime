# Narrative SMS Tool V0

Outil narratif hors runtime Godot pour générer, critiquer et valider des dialogues SMS à routes.

## Scope V0

Cette version est volontairement data-first et Python-only.

Elle couvre une seule route benchmark :

- Day 1 — Sandra — conversation pilier — photo trigger

Elle fournit :

- des profils narratifs JSON ;
- un contrat de scène ;
- des règles QA ;
- des scripts Python de validation/diagnostic ;
- un rapport QA JSON ;
- un petit draft de test.

## Fichiers importants

- `narrative_tool/project/project_intent.json`
- `narrative_tool/project/desire_intensity_scale.json`
- `narrative_tool/profiles/characters/player.json`
- `narrative_tool/profiles/characters/sandra.json`
- `narrative_tool/profiles/desire/sandra_desire_profile.json`
- `narrative_tool/profiles/proximity/player_sandra_proximity.json`
- `narrative_tool/profiles/relationships/player_sandra.json`
- `narrative_tool/routes/sandra_fantasy_profile.json`
- `narrative_tool/routes/sandra_route_arc.json`
- `narrative_tool/scene_contracts/day_01_sandra_photo_trigger.contract.json`
- `narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json`
- `narrative_tool/qa_rules/*.json`
- `narrative_tool/reports/day_01_sandra_photo_trigger.qa.json`

## Lancer la QA

Depuis la racine du repo :

```bash
python3 tools/run_dialogue_qa.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
```

Le script agrège les vérifications suivantes :

- `tools/validate_dialogue_json.py`
- `tools/check_player_presence.py`
- `tools/check_dialogue_rhythm.py`
- `tools/check_choice_sms_quality.py`
- `tools/check_desire_intensity.py`
- `tools/check_route_fantasy_presence.py`

Le rapport est écrit dans :

- `narrative_tool/reports/day_01_sandra_photo_trigger.qa.json`

## Ce que la V0 ne fait pas encore

- pas d’intégration runtime Godot ;
- pas d’UI ;
- pas de scène de jeu complète ;
- pas de remplacement des dialogues existants ;
- pas de framework lourd ;
- pas de génération automatique de contenu final.

## Ajouter une scène plus tard

1. Créer un nouveau `scene_contracts/<scene_id>.contract.json`.
2. Créer un draft dans `drafts/`.
3. Ajouter ou ajuster les règles QA si nécessaire.
4. Relancer `python3 tools/run_dialogue_qa.py <draft>`.
5. Garder la scène data-first et vérifier les messages réels, les choix envoyables et la cohérence de route.
