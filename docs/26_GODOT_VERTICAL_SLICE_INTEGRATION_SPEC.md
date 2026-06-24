# 26 — Spécification d’intégration Godot du vertical slice

## Statut

Spécification produit/technique à utiliser avant le premier codage Godot.

## Objectif

Définir le prototype Godot minimal capable de charger et jouer les données narratives validées des Jours 1 à 4.

Le but n’est pas encore de construire l’interface finale du jeu. Le but est de prouver que :

```text
Godot démarre.
Les données JSON sont chargées.
Le joueur peut choisir un jour / moment / conversation.
Les messages s’affichent.
Les choix s’affichent.
Les effects modifient les variables.
Les flags s’ajoutent.
Les contenus placeholder sont référencés.
Un écran debug permet de vérifier l’état narratif.
```

## Base de données validée

Base actuelle validée :

```text
main = 62776b80c39a90de2793f06fd114b2c9da7f10a0
Jours 1 à 4 narratifs
Validation statique OK
Simulation routes OK
```

Commandes de validation à préserver :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
```

## Moteur cible

```text
Godot 4.6.2
PC d’abord
Android plus tard
```

## Principe d’intégration

Le prototype Godot doit être data-first.

Godot ne doit pas réécrire la narration en dur dans les scènes. Les scènes doivent lire les JSON sous `game/data/` et afficher leur contenu.

Les premiers scripts doivent être simples, lisibles et spécialisés vertical slice. Il ne faut pas créer un moteur narratif trop générique avant d’avoir un prototype jouable.

## Hors scope du premier prototype Godot

Ne pas faire maintenant :

```text
interface finale complète
animations complexes
assets adultes définitifs
vraie galerie complète
sauvegarde complète
système Android
éditeur de conversation
moteur logique complet de conditions
système de routes définitif
réseau social complet
notifications temps réel
refactor large de données
```

## Structure Godot minimale recommandée

```text
game/
  project.godot
  scenes/
    Main.tscn
    smartphone/
      PhonePrototype.tscn
      ConversationView.tscn
      DebugPanel.tscn
  scripts/
    core/
      GameState.gd
      DataLoader.gd
      EffectApplier.gd
      DebugRouteProbe.gd
    ui/
      PhonePrototype.gd
      ConversationView.gd
      DebugPanel.gd
  data/
    ... JSON existants
  assets/
    placeholders/
      .gitkeep
```

Cette structure peut être ajustée par Hermes si Godot impose un détail pratique, mais l’intention doit rester minimale.

## Données à charger au démarrage

Le prototype doit charger :

```text
game/data/state/initial_state.json
game/data/conversations/chapter_01_index.json
game/data/conversations/chapter_02_index.json
game/data/conversations/chapter_03_index.json
game/data/conversations/chapter_04_index.json
game/data/visual_content/placeholders.json
game/data/visual_content/chapter_04_proofs.json
```

Depuis les index, il doit charger les fichiers listés dans `conversation_files`.

## Écran principal prototype

L’écran principal doit proposer :

```text
Jour 1
Jour 2
Jour 3
Jour 4
Debug
Reset state
```

Quand le joueur choisit un jour, l’interface affiche les moments de la journée issus de `moment_flow` si disponible.

Exemple :

```text
Matin — 09:18
Fin de matinée — 11:42
Midi — 12:36
Après-midi — 16:08
Soir — 21:24
```

Si un fichier de conversation n’a pas encore `moment_flow`, il peut être affiché dans l’ordre simple de l’index.

## Affichage des conversations

Le premier `ConversationView` doit afficher :

```text
titre de conversation
moment_label
time_label
transition_text
availability_state si présent
liste des messages
choix disponibles
```

Les messages doivent afficher au minimum :

```text
sender
text
time_label si présent
content_id si présent sous forme de placeholder textuel
```

Exemple de rendu suffisant :

```text
[21:12] Sandra: Je sais que tu es à ta soirée. Je ne devrais pas écrire.
[content: photo_mathilde_home_tier1_placeholder]
```

## Types de contenus à supporter au minimum

Le prototype doit pouvoir parcourir ces formes présentes dans les JSON :

```text
messages
choices
next_messages
automatic_followup
segments
social_items
incoming_notifications
priority_choices
branches
conditional_aftershocks
conditional_proofs
conditional_closers
default_aftershock
default_proof
default_closer
```

Il n’est pas obligatoire de tout rendre parfaitement dès la première passe. Mais le loader ne doit pas planter quand ces champs existent.

## Première règle de rendu

Pour éviter un moteur trop complexe, le premier prototype peut suivre une règle simple :

```text
Afficher le contenu principal du segment.
Afficher les choices ou priority_choices si présents.
Au clic, appliquer effects + sets_flags.
Afficher les next_messages si présents.
Afficher les automatic_followup après les messages de choix.
```

Les branches conditionnelles complexes peuvent d’abord être affichées de manière debug, puis jouées plus finement dans une passe suivante.

## Effets à appliquer

Le script `EffectApplier.gd` doit supporter les effets de type :

```json
"effects": {
  "marie.trust": 1,
  "lie_score": 1,
  "mathilde_attention_score": 2
}
```

Règles :

```text
Si la clé contient un point : personnage.stat.
Sinon chercher dans global.
Sinon chercher dans passive_signals.
Si la variable est inconnue : log error debug, ne pas crasher.
```

Les valeurs peuvent être positives ou négatives.

## Flags

Le prototype doit supporter :

```json
"sets_flags": ["opened_sandra_first_party_day3"]
```

Règles :

```text
Ajouter le flag une seule fois.
Conserver les flags triés ou au moins sans doublon.
Afficher les flags actifs dans le debug.
```

## Conditions

Pour la première intégration, les conditions peuvent rester simples.

Priorité 1 : supporter les flags simples.

Exemple :

```text
opened_pauline_first_party_day3
```

Priorité 2 : supporter `OR` textuel simple.

Exemple :

```text
opened_pauline_first_party_day3 OR answered_pauline_pressure_private_day3
```

Priorité 3 : supporter les comparaisons simples.

Exemple :

```text
marie_neglect_score >= 2
```

Si une condition est trop complexe, le prototype peut l’afficher comme non résolue dans le debug plutôt que planter.

## Contenus visuels placeholder

Le prototype ne doit pas nécessiter d’assets réels au départ.

Quand un `content_id` est rencontré, afficher un bloc placeholder :

```text
[Image placeholder]
ID: photo_mathilde_home_tier1_placeholder
Tags: mathilde, home, ambiguous, forbidden
Risk: 3
```

Le contenu doit être recherché dans :

```text
game/data/visual_content/placeholders.json
game/data/visual_content/chapter_04_proofs.json
```

Si un `asset_path` n’existe pas encore sous `assets/placeholders/`, ne pas bloquer. Le validateur actuel ne vérifie pas encore tous les assets `res://assets/...`.

## DebugPanel minimal

Le debug doit afficher :

```text
variables globales
variables personnages
signaux passifs
flags actifs
contenus débloqués
jour / conversation / segment actuel
dernier choix cliqué
derniers effects appliqués
route dominante probable si calcul disponible
menace active probable si calcul disponible
```

Le debug peut être visible en permanence dans une colonne ou accessible via bouton.

## Route debug minimale dans Godot

Il n’est pas nécessaire de réimplémenter tout `tools/simulate_route_paths.py` dans Godot dès la première passe.

Mais `DebugRouteProbe.gd` peut fournir une lecture simple :

```text
score Marie
score Mathilde
score Sandra
score Pauline
score Nico/Marie
route probable si score >= seuil
menace probable
```

Les formules peuvent être copiées/simplifiées depuis le simulateur Python pour cohérence.

Important : ces labels restent debug-only.

## Sauvegarde

Pour le premier prototype, la sauvegarde persistante est hors scope.

À faire uniquement :

```text
état mémoire pendant la session
bouton Reset state
```

Sauvegarde disque plus tard.

## Validation attendue après intégration

Hermes doit pouvoir lancer :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
git diff --check
```

Puis vérifier manuellement dans Godot :

```text
le projet s’ouvre ;
Main.tscn démarre ;
les jours 1 à 4 sont visibles ;
un moment de journée peut être ouvert ;
une conversation affiche ses messages ;
un choix applique au moins un effect ;
un flag apparaît dans debug ;
un content_id affiche un placeholder ;
Reset state remet les valeurs initiales.
```

## Premier milestone Godot recommandé

Milestone : `godot-data-loader-prototype`

Scope strict :

```text
Créer projet Godot 4.6.2 minimal.
Charger initial_state.json.
Charger les index Jours 1 à 4.
Afficher liste jours / moments / conversations.
Afficher messages simples.
Afficher choix simples.
Appliquer effects et sets_flags.
Afficher DebugPanel.
Ne pas faire de vraie galerie.
Ne pas faire de routes finales.
Ne pas faire de sauvegarde disque.
```

## Prompt Hermes recommandé

```text
Repo : ludowww/reseau-intime
Base : main validé, SHA 62776b80c39a90de2793f06fd114b2c9da7f10a0
Objectif : créer un prototype Godot minimal data-first selon docs/26_GODOT_VERTICAL_SLICE_INTEGRATION_SPEC.md.

Contraintes :
- Godot 4.6.2.
- Scope minimal.
- Ne pas réécrire les dialogues en dur.
- Charger les JSON existants.
- Ne pas refactor les données.
- Pas de sauvegarde disque.
- Pas de galerie complète.
- Pas d’assets adultes.
- Priorité à lisibilité, debug et chargement.

Avant commit :
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
git diff --check

Retour attendu :
- fichiers créés/modifiés ;
- comment lancer la scène ;
- captures ou description du test manuel ;
- SHA commit ;
- limites restantes.
```

## Règle finale

> Le premier Godot prototype ne doit pas être beau. Il doit prouver que les données vivantes peuvent devenir jouables.