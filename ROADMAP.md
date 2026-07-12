# Roadmap

## 1. État actuel

```text
Moteur : Godot 4.6.x
Workflow : documentation validée avant runtime
Choix : 3 maximum par défaut
PR : courtes, ciblées, sans gros refactoring
```

### Canon, architecture et intégration

- sept personnages principaux complètement définis ;
- V0.78 : architecture narrative modulaire ;
- V0.79 : ouverture mardi–vendredi écrite ;
- V0.80 : plan runtime phasé ;
- V0.81 : mercredi intégré ;
- V0.82 : jeudi topologique intégré ;
- V0.83 : canon du flux temporel et réconciliation J1 ;
- V0.84 : fondation runtime jours/phases/archives ;
- V0.85 : J1 actif réconcilié ;
- V0.86 : vendredi public/social et clôture de l’ouverture ;
- V0.86a : simulation temporelle smartphone, notifications et non-lus ;
- V0.87 : première vague de répétitions post-ouverture documentée.

---

## 2. Runtime actif V0.86 + V0.86a

Contenu chargé :

```text
Mardi
Mercredi
Jeudi
Vendredi
```

Accès initial :

```text
Mardi actif
Mercredi verrouillé
Jeudi verrouillé
Vendredi verrouillé
```

Progression active :

```text
fin d'échange
-> contact hors ligne
-> pause 2 secondes
-> horloge accélérée 4 secondes à Speed x1
-> notification compacte si le prochain épisode appartient à un autre fil
```

Même fil :

```text
horloge
-> aucune notification même contact
-> reprise directe de la conversation
```

Le runtime se termine vendredi soir sur :

```text
household_rhythm_confirmed = true
opening_band_complete = true
```

Il reste en R1 maximum, sans secret dur ni cadre adulte.

---

## 3. Ouverture concrète terminée

### Mardi

```text
Marie + M1
-> activité commune hors téléphone
-> Sandra + S1
-> retour final vers Marie
```

### Mercredi

```text
urgence Mathilde
-> faire de la place
-> arrivée
-> installation hors téléphone
```

### Jeudi

```text
Raphaëlle travail
-> Sandra optionnelle
-> invitation Marie
-> une seule topologie
-> retour Marie obligatoire
```

### Vendredi

```text
08:35 Pauline / photo publique + P0
14:05 Nico / place gardée + N0
18:05 Marie + Mathilde / échos du foyer
18:25 continuité interne du foyer
-> opening_band_complete
```

---

## 4. État narratif runtime

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra = soft trace / continuité ordinaire
Mathilde = R1 domestique
Raphaëlle = R1 travail
Pauline = R1 social/public
Nico = R1 amitié/social

Pauline private compartment = false
Nico dangerous shared-gaze frame = false
hard secrets = none
adult frames = none
routes R2+ = none
opening_band_complete = true
```

---

## 5. Acquis techniques V0.84–V0.86a

### Temps et accès

```text
Day: LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
Phase: LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

- le temps contrôle l’accès ;
- un timestamp seul ne débloque rien ;
- les jours futurs restent verrouillés ;
- une scène optionnelle est vue ou expire ;
- une conséquence due passe avant une nouvelle opportunité.

### Interface smartphone

- heure, Wi-Fi et batterie dans la barre fixe de conversation ;
- dernier message visible pendant le passage du temps ;
- notification compacte limitée à dix caractères puis `...` ;
- bref effet d’insertion/flash ;
- transcript maintenu en bas ;
- non-lus visuellement forts ;
- aucun bouton `Continuer la journée` ;
- aucune page vide de moment/jour ;
- pas de notification lorsque le bon fil est déjà ouvert.

### Activité hors téléphone

Les états internes peuvent :

- sélectionner une variante ;
- appliquer des flags ;
- maintenir l’ordre et les conséquences ;
- faciliter le débogage.

Ils ne sont pas exposés comme :

- carte plein écran ;
- note explicative ;
- rubrique `Moments hors ligne` ;
- indice d’archive rejouable.

---

## 6. V0.87 — First Repetition Windows Source Pack

Statut :

```text
documentation écrite
runtime non modifié
validation produit requise avant V0.88
```

Sources :

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
docs/V0_87_Next_Act_I_Windows_Source_Pack_Report.md
```

### Architecture de vague

```text
W9  Marie réclame une heure partagée
W10 opportunité de répétition week-end
W11 retour obligatoire vers Marie
W12 opportunité de répétition premier jour ouvré
W13 fermeture de vague / équilibre du couple
```

Budget :

```text
1 foreground Marie fixe
+ 2 foregrounds externes maximum
+ 0–2 échos par fenêtre
+ 1 seul propriétaire d'accès chargé maximum
```

Sélection :

```text
sécurité / aftermath
-> tronc fixe
-> obligation due
-> continuation compatible
-> contexte réel
-> scène éligible non vue
-> scène la plus différée
-> personnage le moins récemment foreground
-> ordre authored
```

Aucune sélection aléatoire avant ces règles.

---

## 7. Scènes V0.87 autorisées

### Marie — heure partagée

```text
marie_saturday_shared_hour_01
```

- Marie a déjà une vraie matinée ;
- Player rejoint, propose un horaire borné ou la laisse profiter seule ;
- preuve de reconnexion ou dérive, sans changement immédiat de mode du couple.

### Mathilde — regard cuisine

```text
mathilde_morning_kitchen_afterglow_01
```

- tenue ajustée ordinaire ;
- regard reconnu après séparation physique ;
- R2 possible au maximum ;
- intention délibérée, image et consentement adulte toujours absents.

### Sandra — après-poste choisi

```text
sandra_ticket_ghost_hot_chocolate_01
```

- détail SentryCore concret ;
- aucune nouvelle photo ;
- R2 possible seulement si précision et limites antérieures le justifient.

### Raphaëlle — marche hors travail

```text
raphaelle_lunch_walk_outside_work_01
```

- vrai dossier résolu ;
- une couche ordinaire hors bureau ;
- R2 possible au maximum ;
- compte créatif, costume, photo et attraction nommée toujours verrouillés.

### Pauline — deuxième cycle social légitime

```text
pauline_bastien_sunday_table_01
```

- Bastien présent et humain ;
- Marie autonome ;
- aucun crop privé, test secret ou alibi ;
- Pauline reste R1.

### Nico — deuxième cycle d’amitié

```text
nico_pre_shift_lunch_friendship_01
```

- Nico calme et ordinaire ;
- vraie amitié avant le futur regard partagé ;
- aucune photo, alibi ou demande domestique ;
- Nico reste R1.

### Marie — retour concret

```text
marie_concrete_return_due_01
```

Après chaque foreground externe :

- acte immédiat ;
- acte futur borné ;
- ou reconnaissance honnête d’une non-réparation.

Cette conséquence a priorité sur toute nouvelle opportunité.

---

## 8. Plafond V0.87 documenté

```text
charged_access_owner = none | mathilde | sandra | raphaelle
maximum one owner
```

| Personnage | Runtime actuel | Maximum futur autorisé par V0.87 |
|---|---|---|
| Marie | `HABITUAL_WARMTH` | même mode + preuves reconnexion/dérive |
| Sandra | R1/soft | R2 max |
| Mathilde | R1 | R2 max |
| Raphaëlle | R1 | R2 max |
| Pauline | R1 | R1 |
| Nico | R1 | R1 |

Toujours exclus :

```text
hard secret
adult frame
adult image
route R3+
relationship-frame change
```

Le plafond V0.87 ne correspond pas encore à la sauvegarde/runtime actuel.

---

## 9. Traces et images

V0.87 ne demande aucun nouvel asset visuel.

Traces existantes :

```text
j1_sandra_lunch_memory_soft
mathilde_arrival_room_01
marie_laverriere_setup_01
laverriere_public_group_photo_set_01
```

Aucun :

- recadrage ;
- second public ;
- transfert privé ;
- sens sexuel ajouté ;
- collectible adulte.

---

## 10. Cooldowns et replay

- deux tickets externes maximum par partie ;
- même personnage interdit sur les deux tickets ;
- scène manquée = expiration, mutation ou nouvelle raison requise ;
- aucune scène offerte indéfiniment ;
- une fenêtre silencieuse est valide ;
- tous les personnages ne sont pas foreground dans la même partie.

Replay :

- change le personnage sélectionné ;
- change le propriétaire chargé éventuel ;
- change les promesses payées ou manquées ;
- ne change pas les règles de consentement ou les identités.

---

## 11. V0.87 validation documentaire

Avant merge :

```bash
git diff --check
git diff --name-only main...HEAD
```

Scope attendu :

```text
docs/**
README.md
ROADMAP.md
```

Scope interdit :

```text
game/**
tests/**
tools/**
```

Questions produit :

- Marie reçoit-elle bien une scène positive pour elle-même ?
- Deux tickets externes suffisent-ils à créer du replay sans surcharge ?
- Le plafond d’un seul R2 est-il assez lisible ?
- Pauline et Nico restent-ils assez distincts sans activer trop tôt leurs moteurs dangereux ?
- Mathilde, Sandra et Raphaëlle ont-elles chacune une grammaire de charge différente ?
- Les conséquences reviennent-elles assez concrètement vers Marie ?
- Les scènes manquées mutent-elles au lieu d’attendre ?

---

## 12. Prochaine étape — V0.88

```text
V0.88 — First Repetition Runtime Integration Plan
```

Documentation d’abord.

V0.88 doit mapper :

- tickets foreground ;
- sélection déterministe ;
- propriétaire chargé ;
- obligations Marie ;
- cooldowns/expiry/mutation ;
- continuité même fil ;
- représentation de la co-présence ;
- compatibilité sauvegarde ;
- petite tranche d’intégration ;
- rollback et validations.

Tranche recommandée :

```text
W9 Marie
+ un candidat externe
+ retour Marie obligatoire
```

Aucun fichier runtime ne doit changer avant validation du plan.

---

## 13. Principes permanents

- documentation avant runtime ;
- trois choix par défaut ;
- un timestamp ne donne pas accès ;
- une scène existe seulement si le contexte physique et social la justifie ;
- conséquence due avant nouvelle tentation ;
- co-présence hors chat ;
- image = origine + public + permission ;
- privé ≠ secret ;
- chargé ≠ consentement ;
- flags observables avant scores abstraits ;
- legacy conservé mais inactif ;
- aucune modification narrative silencieuse.

---

## 14. À éviter

- intégrer V0.87 directement sans V0.88 ;
- afficher les cinq personnages externes dans une partie ;
- donner plus de deux tickets externes ;
- donner R2 à plus d’un personnage ;
- donner un crop privé à Pauline ;
- activer le pacte photo/alibi de Nico ;
- transformer la tenue Mathilde en permission ;
- donner une nouvelle photo à Sandra ;
- révéler le compte/costume Raphaëlle trop tôt ;
- oublier le retour Marie ;
- réintroduire les pages textuelles de temps ;
- exposer les activités hors téléphone ;
- construire un scheduler aléatoire général.

---

## 15. Séquence officielle

```text
V0.86 — Friday Public Traces & Opening Completion
V0.86a — Smartphone Time & Notification Polish
V0.87 — First Repetition Windows Source Pack
V0.88 — First Repetition Runtime Integration Plan
V0.89+ — petites tranches runtime validées
```
