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
- V0.80 : plan runtime phasé ;
- V0.81 : mercredi intégré ;
- V0.82 : jeudi topologique intégré ;
- V0.83 : canon du flux temporel et réconciliation J1 ;
- V0.84 : fondation runtime des jours/phases/interstitiels.

## 2. Runtime actif V0.84

Contenu chargé :

```text
Mardi
Mercredi
Jeudi
```

Accès initial :

```text
Mardi actif
Mercredi verrouillé
Jeudi verrouillé
```

Progression :

```text
fin Mardi -> interstitiel -> Mercredi
fin Mercredi -> interstitiel -> Jeudi
fin Jeudi -> aucune suite disponible
```

Le runtime reste en R1 maximum, sans secret dur ni contenu adulte.

## 3. Acquis techniques V0.84

### État temporel

```text
Day: LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
Phase: LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

### Interface

- interstitiels de changement de jour ;
- cartes courtes pour grands sauts horaires ;
- délai minimal de lecture ;
- skip souris/clavier après ce délai ;
- page neutre au nouveau moment ;
- jours terminés en historique lecture seule.

### Ordre narratif

- un jour futur ne peut plus être ouvert manuellement ;
- un épisode futur ne fuit plus par son heure ;
- Sandra jeudi doit être terminée ou expirée avant Marie ;
- une conversation expirée n’est plus répondable ;
- O6 Marie termine toujours jeudi.

### Archives

- aucun choix ou effet réappliqué ;
- aucun badge/notification ;
- aucune modification de l’heure ;
- historique filtré par épisode source pour ne pas révéler les jours ultérieurs d’un fil persistant.

## 4. État narratif après jeudi

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Mathilde = R1 domestique
Raphaëlle = R1 travail
Sandra = continuité douce ou écho jeudi expiré
Pauline = inactive
Nico = inactive
hard secrets = none
adult frames = none
```

## 5. Dette restante — J1

V0.84 conserve temporairement le J1 legacy filtré.

Problèmes encore présents :

- contradiction Mardi/Mercredi ;
- timestamps qui reculent ;
- dîner/marche absents comme beat hors ligne ;
- journée terminée sur Sandra ;
- Sandra trop avancée ;
- anciens scores ;
- trop de clics à réponse unique.

Cette dette ne doit pas être contournée dans V0.84.

## 6. Prochaine étape — V0.85

```text
V0.85 — J1 Canon Runtime Reconciliation
```

### Nouveau Mardi actif

```text
18:12 Marie / dîner, pain, marche
19:15 dîner et marche hors ligne
22:57 Sandra / photo floue
23:25 final Marie / vie commune hors ligne
fin Mardi -> Mercredi
```

### Choix

```text
M1 — présent / joueur-présent / retardé-plat
S1 — chaleur sûre / observation précise / prudence
```

### État

Flags observables uniquement.

Ne plus écrire :

```text
marie_attention_score
marie_neglect_score
sandra.attachment
sandra_priority_score
truth_tendency
```

### Stratégie fichiers

- créer de nouveaux fichiers J1 actifs ;
- conserver les gros fichiers legacy sur disque ;
- ne plus les référencer dans l’index Mardi ;
- préserver sans modification la fondation temporelle V0.84 ;
- ne pas changer Mercredi/Jeudi.

## 7. Étape suivante — V0.86

Après validation de V0.85 :

```text
V0.86 — Friday Public Traces & Opening Completion
```

### Vendredi matin

- Pauline R1 ;
- photos publiques autorisées ;
- Bastien visible ;
- choix P0 ;
- aucun crop privé.

### Vendredi après-midi

- Nico R1 ;
- place/table gardée ;
- choix N0 ;
- aucun voyeurisme, pacte photo ou alibi.

### Vendredi fin de journée

- respiration du foyer ;
- clôture du pack V0.79 ;
- transition temporelle cohérente.

## 8. Validation V0.84

Avant merge :

```bash
python3 tools/validate_game_data.py
python3 -m unittest \
  tests.test_godot_prototype_static \
  tests.test_v081_wednesday_static \
  tests.test_v082_thursday_static \
  tests.test_v084_temporal_flow_static \
  -v
python3 tools/player_choice_text_check.py <fichiers actifs mercredi/jeudi>
python3 tools/player_presence_check.py <fichiers actifs mercredi/jeudi>
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Le connecteur GitHub ne peut pas exécuter ces commandes ; Hermes/local/CI doit confirmer.

## 9. Principes permanents

- le temps contrôle l’accès ;
- un timestamp seul ne débloque rien ;
- futurs jours verrouillés ;
- archives en lecture seule et limitées au jour choisi ;
- scènes optionnelles vues ou expirées ;
- aucune réponse après expiration de la fenêtre ;
- conséquence obligatoire avant fin de journée ;
- final J1 sur Marie ;
- un fil visible par personnage ;
- co-présence hors ligne ;
- flags avant scores abstraits ;
- legacy conservé mais inactif ;
- rollback simple par squash ;
- aucune modification narrative silencieuse.

## 10. À éviter

- commencer vendredi avant V0.85 ;
- réafficher tous les jours dès le lancement ;
- permettre Sandra 13:50 après Marie 16:05 ;
- confondre archive et replay ;
- utiliser l’horloge monotone pour masquer des timestamps incohérents ;
- continuer à filtrer indéfiniment les gros fichiers J1 ;
- finir J1 sur Sandra ;
- réintroduire les anciens scores ;
- construire un scheduler général ou aléatoire ;
- ouvrir R2 ou l’adulte.

## 11. Séquence officielle

```text
V0.84 — Day & Moment Flow Runtime Foundation
V0.85 — J1 Canon Runtime Reconciliation
V0.86 — Friday Public Traces & Opening Completion
V0.87+ — extension incrémentale de l'Acte I
```
