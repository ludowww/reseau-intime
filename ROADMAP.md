# Roadmap

## 1. État actuel

```text
Moteur : Godot 4.6.x
Workflow : documentation validée avant runtime
Choix : 3 maximum par défaut
PR : courtes, ciblées, sans gros refactoring
```

### Canon personnages

Complet pour :

```text
Marie
Sandra
Player
Mathilde
Pauline
Nico
Raphaëlle
```

Les personnages secondaires restent proportionnels.

### Architecture

V0.78 a verrouillé :

```text
tronc dramatique fixe
+ fenêtres narratives
+ scènes modulaires
+ obligations / traces
+ conséquences revenant vers le couple
```

### Ouverture narrative

V0.79 a écrit :

```text
Mardi soir = J1
Mercredi = urgence / arrivée Mathilde
Jeudi = travail / événement / topologie / retour Marie
Vendredi = Pauline / Nico / foyer
```

### Runtime

Le prototype actuel reste pré-modulaire.

V0.80 a audité :

- DataLoader ;
- GameState / EffectApplier ;
- PhonePrototype / ConversationView ;
- indexes Chapter 1–4 ;
- ancien Chapter 2 ;
- visuels placeholders ;
- tests et outils de validation.

Constat : la base technique est réutilisable, mais le runtime n’a pas encore les branches conditionnelles, `offline_beat`, temps piloté par les données, ni navigation limitée aux jours canoniques.

## 2. Écart à corriger en premier

Le J1 jouable affiche encore Mathilde comme déjà installée :

- sacs dans l’entrée ;
- baskets ;
- sac de sport / raquette ;
- visuel domestique associé.

Le canon exige :

```text
Mardi = Mathilde indirecte
Mercredi = urgence et arrivée
```

Le prochain runtime doit corriger ce raccord sans réécrire tout J1.

## 3. Séquence officielle

```text
V0.80 — First Modular Runtime Integration Plan
V0.81 — Tuesday handoff + Wednesday runtime vertical slice
V0.82 — Thursday topology and mandatory Marie return
V0.83 — Friday public traces and opening completion
V0.84+ — extension incrémentale de l'Acte I
```

## 4. V0.80 — statut

Documentation uniquement.

Sources :

```text
docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
docs/V0_80_First_Modular_Runtime_Integration_Plan.md
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
```

Décision principale :

```text
ne pas intégrer O0–O8 en une seule PR
```

## 5. V0.81 — première tranche runtime

Périmètre strict :

### Raccord mardi

- retirer les sacs/baskets/raquette de Mathilde du J1 actif ;
- supprimer la référence `j1_mathilde_bag_domestic_trace` ;
- conserver Mathilde indirecte ;
- ajouter les métadonnées Mardi.

### Mercredi

```text
O1 — Marie / faire de la place
O2 — Marie / trace d'arrivée
O2 — Mathilde / arrivée
OFFLINE_BEAT — installation face à face
```

### UI / fondation

- boutons Mardi / Mercredi ;
- heure de statut pilotée par les données ;
- métadonnées uniquement pour épisodes débloqués ;
- présentation `time_separator` ;
- présentation `offline_beat` ;
- indexes actifs Chapter 1–2 uniquement ;
- un visuel `mathilde_arrival_room_01` ;
- flags uniquement.

### Choix

```text
M0  — proactive / joueuse-présente / passive
MT0 — pratique / taquine / distante
```

### Exclusions

- aucun jeudi ;
- aucun vendredi ;
- aucune route R2 ;
- aucun secret ;
- aucun contenu adulte ;
- aucun score d’affection supplémentaire ;
- aucun scheduler universel ;
- aucune suppression massive des anciens fichiers.

## 6. V0.82 — topologie du jeudi

Après validation de V0.81 :

- Raphaëlle travail ;
- écho Sandra ;
- invitation Marie ;
- flags topologiques ;
- déblocage conditionnel d’une seule branche ;
- variantes conditionnelles ;
- O5A / O5B / O5C ;
- retour O6 obligatoire vers Marie ;
- temporalité du jeudi ;
- communication réaliste selon co-présence.

Fondation technique minimale :

```text
after_conversation_completed
+ conditions de flags
= unlock conditionnel
```

Pas de moteur de scheduling généralisé.

## 7. V0.83 — vendredi

Après validation de V0.82 :

- relais public Pauline ;
- photo de groupe autorisée ;
- Bastien visible ;
- suivi Nico l’après-midi ;
- respiration du foyer ;
- vérification de l’état final V0.79 ;
- aucun crop privé, pacte photo ou route adulte.

## 8. Validation runtime permanente

Chaque PR doit exécuter :

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 tools/player_choice_text_check.py
python3 tools/player_presence_check.py
python3 tools/simulate_route_paths.py
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Le simulateur de routes reste un probe legacy tant qu’il n’a pas été réécrit explicitement.

## 9. Principes techniques permanents

- réutiliser les fils persistants existants ;
- conserver un fil visible par personnage ;
- utiliser les indexes comme orchestration explicite ;
- ne pas afficher un temps futur avant son déblocage ;
- arrêter le chat lors de la co-présence ;
- représenter le hors-ligne sans faux expéditeur ;
- mémoriser d’abord par flags observables ;
- éviter les nouveaux scores abstraits ;
- masquer les anciens jours suspendus sans les supprimer ;
- garantir le rollback par PR squashable ;
- mettre à jour les tests qui protègent des hypothèses désormais dépréciées.

## 10. Contenu futur après V0.83

Une fois l’ouverture V0.79 entièrement jouable :

- poursuivre l’Acte I par nouveaux source packs ;
- écrire les premières répétitions privées S4 ;
- introduire une première limite S5 ;
- faire muter les occasions manquées ;
- seulement ensuite ouvrir R2 puis R3 ;
- ne pas accélérer l’adulte pour justifier l’architecture.

## 11. À éviter

- intégrer mardi–vendredi en une seule PR ;
- laisser les anciens J3+ cliquables après le nouveau mercredi ;
- garder Mathilde déjà installée dans J1 ;
- ajouter un moteur de branches universel avant le besoin du jeudi ;
- utiliser les anciens scores comme canon ;
- simuler une conversation face à face par Messenger ;
- afficher `09:41` en permanence ;
- supprimer tous les fichiers legacy ;
- changer les lignes V0.79 pour contourner une limitation sans revue ;
- mélanger documentation, jeudi, vendredi et adulte dans V0.81.

## 12. Prochaine action

Après validation de V0.80 :

```text
transmettre à Hermes/Codex
le plan V0.81 Wednesday vertical slice
```
