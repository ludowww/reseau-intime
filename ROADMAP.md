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
- V0.82 : jeudi topologique intégré.

### Runtime actif

```text
Mardi
Mercredi
Jeudi
```

Le runtime reste en R1 maximum et sans contenu adulte.

## 2. Audit V0.83

Trois problèmes sont confirmés :

### Jours immédiatement accessibles

Mardi, Mercredi et Jeudi sont tous visibles dès le lancement.

La navigation fonctionne comme un menu de jours plutôt que comme une chronologie vécue.

### Phases horaires concurrentes

Après Raphaëlle jeudi, Sandra 13:50 et Marie 16:05 deviennent disponibles ensemble.

Le joueur peut agir à 16:05 puis revenir répondre à 13:50.

### J1 legacy incohérent

Le mardi actif contient encore :

- contradiction Mardi/Mercredi ;
- timestamps qui reculent ;
- absence du dîner/marche hors ligne ;
- fin sur Sandra plutôt que Marie ;
- Sandra trop avancée ;
- anciens scores ;
- trop de clics guidés.

## 3. Décision produit

```text
Vendredi est reporté.
```

La priorité devient :

```text
1. rendre le temps autoritaire
2. reconstruire J1
3. reprendre Pauline/Nico
```

## 4. Séquence officielle

```text
V0.83 — Temporal Flow & J1 Reconciliation Spec
V0.84 — Day & Moment Flow Runtime Foundation
V0.85 — J1 Canon Runtime Reconciliation
V0.86 — Friday Public Traces & Opening Completion
V0.87+ — extension incrémentale de l'Acte I
```

## 5. V0.83 — documentation actuelle

Nouveaux canons/plans :

```text
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md
docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md
docs/runtime/V0_84_DAY_AND_MOMENT_FLOW_IMPLEMENTATION_PLAN.md
docs/runtime/V0_85_J1_CANON_RUNTIME_RECONCILIATION_PLAN.md
docs/V0_83_Temporal_Flow_And_J1_Reconciliation_Report.md
```

Aucun runtime modifié.

## 6. V0.84 — fondation temps

### Jours

```text
LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
```

- Mardi seul au lancement ;
- Mercredi déverrouillé après fin Mardi ;
- Jeudi déverrouillé après fin Mercredi ;
- anciens jours en lecture seule ;
- futur invisible ou verrouillé.

### Interstitiels

```text
MARDI — FIN DE JOURNÉE
MERCREDI — MIDI / Faire de la place
```

et cartes courtes pour grands sauts intrajournaliers.

### Phases

```text
LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

Jeudi cible :

```text
09:10 Raphaëlle obligatoire
13:50 Sandra optionnelle
16:05 Marie obligatoire
soir une branche O5
22:10 retour Marie obligatoire
```

Si Sandra est ignorée, elle expire avant 16:05.

### Exclusions V0.84

- aucun dialogue J1 réécrit ;
- aucun vendredi ;
- aucun R2 ;
- aucun scheduler universel ;
- aucune migration de sauvegarde.

## 7. V0.85 — reconstruction J1

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

Créer de nouveaux fichiers J1 actifs.

Conserver les gros fichiers legacy mais ne plus les référencer dans l’index Mardi.

### Exclusions V0.85

- aucun changement mercredi/jeudi ;
- aucun vendredi ;
- aucune suppression globale de state legacy ;
- aucun contenu adulte.

## 8. V0.86 — vendredi

Après validation V0.84 et V0.85 :

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

## 9. Validation permanente

Chaque PR runtime doit exécuter :

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 -m unittest tests.test_v081_wednesday_static -v
python3 -m unittest tests.test_v082_thursday_static -v
python3 -m unittest <tests de la version> -v
python3 tools/player_choice_text_check.py <fichiers actifs>
python3 tools/player_presence_check.py <fichiers actifs>
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

## 10. Principes permanents

- le temps contrôle l’accès ;
- un timestamp seul ne débloque rien ;
- futurs jours verrouillés ;
- archives en lecture seule ;
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

## 11. À éviter

- commencer V0.86 avant V0.84/V0.85 ;
- afficher tous les jours dès le lancement ;
- permettre Sandra 13:50 après Marie 16:05 ;
- utiliser l’horloge monotone pour masquer des timestamps incohérents ;
- continuer à filtrer indéfiniment les gros fichiers J1 ;
- garder `On est mercredi` dans Mardi ;
- finir J1 sur Sandra ;
- réintroduire les anciens scores ;
- construire un scheduler général ou aléatoire ;
- ouvrir R2 ou l’adulte.

## 12. Prochaine action après validation V0.83

```text
transmettre à Hermes/Codex
le plan V0.84 Day & Moment Flow Runtime Foundation
```
