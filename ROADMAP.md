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
- V0.87 : première vague de répétitions post-ouverture documentée ;
- V0.88 : première tranche d’intégration runtime planifiée, sans modification du jeu.

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
documentation validée et mergée
runtime non modifié
```

Sources :

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
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

V0.87 et V0.88 ne demandent aucun nouvel asset visuel.

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

## 11. V0.88 — First Repetition Runtime Integration Plan

Statut :

```text
documentation uniquement
runtime inchangé
```

Sources :

```text
docs/runtime/V0_88_FIRST_REPETITION_RUNTIME_INTEGRATION_PLAN.md
docs/V0_88_First_Repetition_Runtime_Integration_Plan_Report.md
docs/runtime/V0_88_FIRST_REPETITION_RUNTIME_PREPARATION_NOTE.md
```

### Première tranche retenue

```text
Samedi W9 — Marie réclame une heure partagée
-> Dimanche — Mathilde candidate ou différée silencieusement
-> Dimanche W11 — retour Marie obligatoire
```

La tranche ne termine pas toute la vague.

Elle pourra écrire :

```text
first_repetition_slice_01_complete
```

Elle ne devra pas écrire :

```text
first_repetition_wave_complete
```

Lundi restera indisponible.

### Pourquoi Mathilde est retenue

- son séjour est déjà actif ;
- le rythme du foyer est confirmé ;
- son fil privé existe déjà ;
- aucune image n’est nécessaire ;
- la scène teste éligibilité, expiration, maintien R1 ou passage R2 ;
- le retour vers Marie reste obligatoire ;
- ce choix répond au contexte et à la surface technique, pas à une priorité de sa future route adulte.

Sandra, Raphaëlle, Pauline et Nico restent des candidats V0.87 pour des PR ultérieures.

---

## 12. Architecture d’état V0.88

Séparation prévue :

```text
TimelineState
= jours, phases, épisodes, expiration

GameState.story_ledgers.first_repetition
= foregrounds, propriétaire chargé, lifecycle,
  cooldowns et obligations

flags plats
= faits observables des choix

index narratifs
= limites et ordre déterministe
```

Ledger prévu :

```text
opportunity_window_ordinal
external_foreground_scene_ids
external_foreground_character_ids
charged_access_owner
scene_status
cooldown_until_ordinal
obligations
```

Le sélecteur futur retourne :

```text
un candidat éligible
ou aucun
```

Il n’utilise ni hasard libre, ni score d’affection, ni menu de personnages.

---

## 13. Plafond de la tranche Mathilde

Mathilde peut devenir :

```text
charged_access_owner = mathilde
```

seulement si :

- MT1A ou MT1B est choisi ;
- l’historique positif ou joueur du foyer existe ;
- aucune limite non résolue n’existe ;
- aucun autre propriétaire n’existe ;
- aucune conséquence Marie due n’a été contournée.

Si le gate échoue :

```text
soft gaze flag conservé
Mathilde reste R1
charged_access_owner reste vide
```

R2 ne crée toujours aucune :

```text
intention de séduction reconnue
permission d'image
permission sexuelle
secret dur
cadre adulte
```

---

## 14. Obligations V0.88

Statuts prévus :

```text
SCHEDULED
DUE
PAID
FAILED
CARRIED
```

Règles :

- M2A paie l’heure partagée par continuité interne ;
- M2B programme et paie l’alternative bornée du samedi dans cette tranche limitée ;
- M2C laisse Marie profiter seule et programme le retour du dimanche ;
- terminer Mathilde programme un retour Marie ;
- une conséquence Marie `DUE` bloque une nouvelle opportunité externe ;
- M3A paie le retour ;
- M3B garde une promesse du lundi comme `CARRIED` sans la marquer payée ;
- M3C résout honnêtement la non-réparation comme `FAILED`.

Le couple reste `HABITUAL_WARMTH`.

---

## 15. Communication et voix

V0.89 devra réutiliser :

```text
dernier message
-> contact hors ligne
-> pause 2 secondes
-> horloge 4 secondes
-> notification compacte autre fil
```

Même fil Marie : reprise directe.

Co-présence : hors chat, sans carte explicative.

Canon vocal obligatoire :

```text
Marie = vie commune, nourriture, mouvement, humour pratique
Mathilde = vitesse, correction, mauvaise foi, image
           + vocabulaire juridique très dosé
Player = court, sec, observateur, imparfait
```

Le vocabulaire juridique ne doit pas contaminer Marie ou Player.

---

## 16. Validation V0.88 documentaire

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

Aucun test Godot n’est requis pour une PR documentaire, mais aucune validation exécutable ne doit être revendiquée sans exécution locale.

---

## 17. Prochaine étape — V0.89

```text
V0.89 — First Repetition Vertical Slice
```

V0.89 pourra intégrer uniquement :

```text
W9 Marie
+ candidat Mathilde ou différé silencieux
+ W11 retour Marie
```

Elle ne devra pas ajouter dans la même PR :

- Sandra ;
- Raphaëlle ;
- Pauline ;
- Nico ;
- le deuxième ticket externe ;
- W12/W13 complets ;
- une nouvelle image ;
- un cadre adulte ;
- un système de sauvegarde complet.

---

## 18. Principes permanents

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
- voix distinctes par personnage ;
- legacy conservé mais inactif ;
- aucune modification narrative silencieuse ;
- rollback en un squash commit.

---

## 19. À éviter

- intégrer toute la V0.87 dans une seule PR ;
- dépasser la tranche Marie -> Mathilde -> Marie en V0.89 ;
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
- construire un scheduler aléatoire général ;
- construire un système de sauvegarde non requis par la tranche.

---

## 20. Séquence officielle

```text
V0.86  Friday Public Traces & Opening Completion
V0.86a Smartphone Time & Notification Polish
V0.87  First Repetition Windows Source Pack
V0.88  First Repetition Runtime Integration Plan
V0.89  Marie -> Mathilde -> Marie vertical slice
V0.90+ autres candidats en petites tranches validées
```
