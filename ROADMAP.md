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
- V0.78 : architecture narrative modulaire ;
- V0.79 : ouverture mardi–vendredi écrite ;
- V0.80 : audit et découpage runtime validés.

### Runtime V0.81

V0.81 rend jouable :

```text
Mardi soir — J1 actif filtré
Mercredi midi — O1 Marie / faire de la place
Mercredi fin de journée — O2 trace d'arrivée
Mercredi soir — O2 Mathilde / arrivée
Fin de scène — installation hors ligne
```

Le runtime actif utilise :

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
```

Les anciens jours restent sur disque mais ne sont plus navigables comme continuation courante.

## 2. Acquis techniques V0.81

- raccord J1 Mathilde corrigé par filtre d’index ;
- Mardi / Mercredi pilotés par les données ;
- heure narrative dynamique ;
- épisodes verrouillés exclus des métadonnées de contact ;
- fils persistants Marie / Mathilde ;
- déblocage séquentiel O1 → trace → Mathilde ;
- `time_separator` ;
- `offline_beat` centré, persistant et sans doublon ;
- horloge monotone dans la journée ;
- un visuel autorisé `mathilde_arrival_room_01` ;
- flags observables uniquement ;
- tests statiques dédiés.

## 3. État narratif après mercredi

```text
Mathilde stay = active
Mathilde route stage = R1 Ordinary Access
couple mode = HABITUAL_WARMTH
hard secrets = none
adult frames = none
```

Aucun jeudi ou vendredi n’est encore jouable.

## 4. Prochaine étape — V0.82

```text
V0.82 — Thursday topology and mandatory Marie return
```

Périmètre prévu :

### Jeudi matin / début d’après-midi

- O3 Raphaëlle travail ;
- écho Sandra conditionnel ;
- métadonnées temporelles du jeudi.

### Jeudi fin d’après-midi

- O4 Marie propose le vernissage ;
- M1 à trois choix :
  - rejoindre Marie tôt ;
  - rester au foyer ;
  - finir le travail et promettre de venir.

### Jeudi soir

Débloquer exactement une branche :

```text
O5A — Marie / La Verrière
OU
O5B — Mathilde / foyer
OU
O5C — Raphaëlle / travail
```

### Jeudi nuit

- O6 retour obligatoire vers Marie ;
- variante selon la branche et la qualité de présence ;
- `AFTERGLOW_REMOTE` ou `OFFLINE_BEAT` selon la position physique.

## 5. Fondation technique V0.82

Ajouter seulement :

```text
after_conversation_completed
+ conditions de flags
= déblocage conditionnel
```

et :

```text
conditions sur messages / segments
= variante de conséquence
```

Ne pas ajouter un scheduler universel.

Garanties :

- une seule branche O5 ;
- O6 non contournable ;
- trois choix maximum ;
- temps futur non visible avant déblocage ;
- co-présence traitée hors ligne ;
- aucune route adulte.

## 6. Étape suivante — V0.83

Après validation de V0.82 :

```text
V0.83 — Friday public traces and opening completion
```

Contenu :

- relais photo publique Pauline ;
- Bastien visible ;
- suivi Nico l’après-midi ;
- respiration du foyer ;
- fin de l’ouverture V0.79 ;
- Pauline et Nico en R1 uniquement.

## 7. Validation permanente

Chaque PR runtime doit exécuter :

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 -m unittest tests.test_v081_wednesday_static -v
python3 tools/player_choice_text_check.py <fichiers actifs>
python3 tools/player_presence_check.py <fichiers actifs>
python3 tools/simulate_route_paths.py
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Le simulateur de routes reste un probe legacy.

Le connecteur GitHub utilisé pour V0.81 ne peut pas exécuter localement ces commandes ; elles doivent être confirmées par CI ou environnement Hermes/Codex avant merge.

## 8. Principes techniques permanents

- réutiliser les fils persistants ;
- un fil visible par personnage ;
- indexes explicites et auditables ;
- horloge narrative pilotée par les épisodes disponibles ;
- arrêt du chat lors de la co-présence ;
- `offline_beat` sans faux expéditeur ;
- flags avant scores abstraits ;
- legacy conservé mais inactif ;
- rollback simple par squash commit ;
- aucune modification de sens narratif pour contourner une contrainte technique.

## 9. À éviter

- réactiver les anciens J3+ ;
- intégrer jeudi et vendredi dans la même PR ;
- transformer les adapters V0.81 en refactor global avant validation ;
- ajouter des scores de désir ou de couple ;
- rendre Mathilde sexuellement intentionnelle dès mercredi ;
- laisser une heure future apparaître avant déblocage ;
- simuler une discussion face à face par Messenger ;
- introduire Pauline/Nico avant leur fenêtre vendredi ;
- supprimer les fichiers legacy ;
- ouvrir R2 ou du contenu adulte dans V0.82.

## 10. Séquence officielle

```text
V0.81 — Tuesday handoff + Wednesday runtime vertical slice
V0.82 — Thursday topology and mandatory Marie return
V0.83 — Friday public traces and opening completion
V0.84+ — extension incrémentale de l'Acte I
```
