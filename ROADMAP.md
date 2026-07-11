# Roadmap

## 1. État actuel

```text
Moteur : Godot 4.6.x
Workflow : documentation validée avant runtime
Choix : 3 maximum par défaut
PR : courtes, ciblées, sans gros refactoring
```

### Canon et architecture

- sept personnages principaux complètement définis ;
- V0.78 : architecture modulaire ;
- V0.79 : ouverture mardi–vendredi écrite ;
- V0.80 : plan runtime phasé.

### Runtime actif

```text
V0.81 = mardi–mercredi
V0.82 = jeudi conditionnel + retour Marie
```

Jours actifs :

```text
Mardi
Mercredi
Jeudi
```

Vendredi reste non intégré.

## 2. Acquis V0.82

### Contenu

- Raphaëlle R1 travail ;
- écho Sandra optionnel ;
- invitation Marie ;
- M1 à trois choix topologiques ;
- une seule branche O5 ;
- retour O6 obligatoire ;
- visuel événement Marie autorisé ;
- aucun vendredi ou contenu adulte.

### Fondation technique

```text
conditions sur unlocks
conditions sur messages / choix
after_any_conversation_completed
notify: false
fusion cumulative des fils entre les jours
```

Les adaptateurs V0.82 étendent V0.81 ; les scripts de base restent inchangés.

## 3. État narratif après jeudi

```text
Mathilde = R1 domestique
Raphaëlle = R1 travail
Sandra = continuité douce
Marie/Player = HABITUAL_WARMTH
reconnection/drift = candidates seulement
hard secrets = none
adult frames = none
```

## 4. Prochaine étape — V0.83

```text
V0.83 — Friday public traces and opening completion
```

Périmètre :

### Vendredi matin

- O7 Pauline ;
- relais du set de photos publiques autorisées ;
- Bastien visible dans le contexte ;
- choix P0 à trois réponses ;
- aucun crop privé.

### Vendredi après-midi

- O8 Nico ;
- suivi de la place/table gardée ;
- choix N0 à trois réponses ;
- possibilité de savoir que Mathilde séjourne au foyer ;
- aucun voyeurisme, photo pact ou alibi.

### Vendredi fin de journée

- respiration du foyer ;
- clôture du pack V0.79 ;
- état final d’ouverture vérifié.

## 5. Fondation V0.83 attendue

Réutiliser :

- déblocages conditionnels V0.82 ;
- fils persistants ;
- temps piloté par les données ;
- trace metadata ;
- messages/choix conditionnels si nécessaire.

Ne pas ajouter :

- nouveau scheduler ;
- route R2 ;
- système d’image adulte ;
- secret dur ;
- score de couple.

## 6. Validation runtime

Avant merge V0.82 puis V0.83 :

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 -m unittest tests.test_v081_wednesday_static -v
python3 -m unittest tests.test_v082_thursday_static -v
python3 tools/player_choice_text_check.py <fichiers actifs>
python3 tools/player_presence_check.py <fichiers actifs>
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Le connecteur GitHub ne peut pas exécuter ces commandes ; CI ou Hermes/local doit confirmer.

## 7. Principes permanents

- un fil visible par personnage ;
- une topologie seulement par événement ;
- conséquences dues avant nouvelles opportunités ;
- retour vers Marie garanti ;
- temps futur non visible avant déblocage ;
- chat interrompu lors de la co-présence ;
- flags observables avant scores abstraits ;
- legacy conservé mais inactif ;
- rollback simple par squash ;
- aucune modification narrative silencieuse.

## 8. À éviter

- débloquer plusieurs O5 ;
- rendre l’écho Sandra obligatoire pour Marie ;
- faire de Raphaëlle l’excuse de Player ;
- transformer le foyer Mathilde en récompense sexuelle ;
- offrir une quatrième topologie dans O6 ;
- commencer vendredi avant la validation de jeudi ;
- réactiver l’ancien Chapter 3 ;
- ouvrir Pauline/Nico trop tôt ;
- ajouter R2, secrets ou adulte ;
- refactorer les scripts de base sans nécessité.

## 9. Séquence officielle

```text
V0.81 — Tuesday handoff + Wednesday runtime slice
V0.82 — Thursday topology + mandatory Marie return
V0.83 — Friday public traces + opening completion
V0.84+ — extension incrémentale de l'Acte I
```
