# Outils d’aide à l’écriture des dialogues

## Objectif

Ces outils servent à aider l’écriture data-first des dialogues de Réseau Intime.

Ils ne changent pas le runtime du jeu. Ils ne génèrent pas automatiquement une route. Ils fournissent :

```text
- un contexte personnage / jour / risque ;
- des garde-fous de voix ;
- des variantes de ton ;
- des rapports de rythme ;
- des alertes de cohérence simples.
```

Le principe est :

```text
préparer → écrire → vérifier → corriger
```

et non :

```text
générer → accepter automatiquement
```

## Pourquoi maintenant

À partir de J5, plusieurs routes sont ouvertes en même temps : Marie, Sandra, Mathilde, Pauline, Raphaëlle et Nico/Marie.

Le risque n’est pas seulement technique. Le risque est narratif :

```text
- personnages qui se ressemblent ;
- scènes qui répètent les mêmes mécaniques ;
- emojis uniformes ;
- personnage qui sait quelque chose qu’il ne devrait pas savoir ;
- routes qui avancent toutes au même rythme ;
- scènes trop fonctionnelles, pas assez incarnées.
```

Ces outils doivent empêcher l’histoire de perdre sa mémoire.

## Architecture

### Documentation humaine

```text
docs/writing/characters/VOICE_PROFILES.md
```

Cette documentation décrit les voix adaptatives : base stable, évolution possible, risques, exemples, états d’intimité.

### Données légères

```text
game/data/writing/character_voice_profiles.json
game/data/writing/knowledge_state.json
```

Ces fichiers ne sont pas chargés par le jeu. Ils sont seulement lus par les scripts.

Attention : ils évitent volontairement les clés runtime sensibles comme `id`, `effects`, `content_id` ou `res://` pour ne pas perturber le validateur global.

### Scripts

```text
tools/dialogue_context_pack.py
tools/dialogue_rhythm_report.py
tools/dialogue_voice_check.py
```

## Usage recommandé

### 1. Préparer une scène

```bash
python3 tools/dialogue_context_pack.py --character raphaelle --day 6 --stage intimacy_1 --risk medium
```

Exemple d’usage : avant d’écrire une scène Raphaëlle J6, le script rappelle :

```text
- son fil précédent ;
- ce qu’elle sait ;
- ce qu’elle ne sait pas ;
- les limites de ton ;
- les emojis recommandés ;
- ce qui serait trop tôt.
```

### 2. Relire le rythme

```bash
python3 tools/dialogue_rhythm_report.py game/data/conversations/chapter_05_raphaelle_boundary.json
```

Le rapport mesure :

```text
- nombre de messages ;
- longueur moyenne ;
- questions ;
- emojis ;
- contenus visuels ;
- nombre de choix ;
- présence de réponses après choix.
```

### 3. Vérifier la voix

```bash
python3 tools/dialogue_voice_check.py game/data/conversations/chapter_05_raphaelle_boundary.json --character raphaelle --stage intimacy_1 --risk medium
```

Le script signale des alertes, pas des décisions.

Exemples :

```text
⚠️ trop d’emojis pour Raphaëlle
⚠️ trop de phrases abstraites consécutives
⚠️ mention possible d’un fait inconnu du personnage
⚠️ scène trop courte par rapport à la fonction demandée
```

## Ce que les outils peuvent faire

```text
- rappeler l’état narratif d’un personnage ;
- proposer la bonne variante de ton ;
- aider à différencier les voix ;
- détecter des répétitions ou déséquilibres ;
- vérifier des limites simples de connaissance ;
- repérer les scènes trop sèches ou trop mécaniques.
```

## Ce qu’ils ne doivent pas faire

```text
- écrire toute une journée à la place de l’auteur ;
- décider qu’une scène est bonne ;
- multiplier automatiquement les branches ;
- remplacer la validation narrative humaine ;
- transformer les routes en système mathématique lourd ;
- créer de nouvelles variables gameplay.
```

## Règle de sécurité

```text
Les outils peuvent multiplier les analyses.
Ils ne doivent pas multiplier les scènes.
```

Une scène peut avoir plusieurs variantes d’écriture en préparation, mais le runtime doit rester lisible : une scène intégrée, quelques choix, des effets simples, et une progression claire.

## Principe adaptatif

Chaque personnage possède une voix stable, mais cette voix varie selon :

```text
- le jour ;
- le stade d’intimité ;
- le niveau de risque ;
- l’humeur ;
- les faits connus ;
- les faits inconnus ;
- les derniers événements.
```

Exemple :

```text
Raphaëlle ne doit pas rester froide pour toujours.
Elle peut devenir plus chaleureuse.
Mais elle ne doit pas devenir une cachette romantique immédiate.
```

## Workflow conseillé pour J6+

```text
1. Lancer context_pack pour chaque scène prévue.
2. Écrire ou faire écrire la scène.
3. Lancer rhythm_report sur la scène.
4. Lancer voice_check avec character/stage/risk.
5. Corriger manuellement.
6. Lancer les validateurs projet habituels.
```

Validations projet inchangées :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```
