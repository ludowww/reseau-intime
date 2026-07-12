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
- V0.84 : fondation runtime des jours/phases/interstitiels ;
- V0.85 : J1 actif réconcilié ;
- V0.86 : vendredi public/social et clôture de l’ouverture ;
- V0.86a : simulation temporelle smartphone, notifications et non-lus.

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
-> horloge accélérée 4 secondes
-> notification du prochain message
```

Le franchissement de minuit remplace les anciennes pages textuelles de début de journée.

Le runtime reste en R1 maximum, sans secret dur ni contenu adulte.

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

## 4. État narratif après l’ouverture

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
household_rhythm_confirmed = true
opening_band_complete = true
```

## 5. Acquis techniques V0.84–V0.86a

### État temporel

```text
Day: LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
Phase: LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

### Interface smartphone

- l’heure, le Wi‑Fi et la batterie sont affichés dans une barre fixe au-dessus du contact ;
- le panneau gauche temporaire ne duplique plus visuellement le statut ;
- le dernier message reste visible pendant le passage du temps ;
- l’horloge avance en accéléré pendant quatre secondes à vitesse normale ;
- la notification suivante apparaît sous l’en-tête du fil courant ;
- les fils non lus utilisent un état visuel fort ;
- aucun bouton `Continuer la journée` ;
- aucune page vide indiquant seulement un moment ou un jour.

### Activité hors téléphone

Les phases hors téléphone restent dans l’état interne pour :

- sélectionner une variante ;
- appliquer les flags ;
- maintenir l’ordre et la cohérence ;
- faciliter le débogage.

Elles ne sont plus exposées comme notes, cartes ou rubrique `Moments hors ligne` dans les archives. Le joueur les infère à partir du temps écoulé et des conséquences.

### Ordre narratif

- un jour futur ne peut pas être ouvert manuellement ;
- un épisode futur ne fuit pas par son heure ;
- une scène optionnelle doit être vue ou expirer ;
- les conséquences dues passent avant la nouvelle tentation ;
- le final vendredi exige les deux échos du foyer ;
- aucun jour ultérieur n’est exposé.

## 6. Pauline et l’image publique

V0.86 établit :

```text
laverriere_public_group_photo_set_01
```

Règles :

- origine Pauline / télécommande ;
- public groupe photographié + La Verrière ;
- Bastien visible ;
- Mathilde absente ;
- risque 0 ;
- aucun crop privé ;
- aucun public secret ;
- aucune fonction adulte.

P0 reste un choix de participation publique, pas une route privée.

## 7. Nico et l’amitié ordinaire

V0.86 établit :

```text
Nico R1
saved-seat trace resolved
social mirror seed possible
Mathilde stay known possible
```

N0 propose :

```text
honnête
joueur
demander pour Marie
```

Aucun commentaire de corps, demande d’image, rivalité ou cadre adulte n’est ouvert.

## 8. Prochaine étape — V0.87

```text
V0.87 — Next Act I Windows Source Pack
```

Documentation uniquement dans un premier temps.

Le pack doit définir :

- les premières répétitions après accès ordinaire ;
- les fenêtres privées qui deviennent plausibles ;
- les conditions et exclusions par personnage ;
- les cooldowns ;
- les occasions manquées ;
- les conséquences revenant vers Marie ;
- le plafond précis entre R1 et les premiers signaux pré-R2.

Il ne doit pas écrire directement tout l’Acte I ni intégrer le runtime dans la même PR.

## 9. Directions possibles du prochain pack

### Marie

- présence active répétée ;
- scène pour elle-même ;
- désir du couple avant concurrence externe.

### Sandra

- reprise douce ou refroidissement ;
- aucun nouveau visuel automatique ;
- confiance précise plutôt que séduction générique.

### Mathilde

- cuisine, matin ou chambre d’appoint selon participation ;
- sensualité ordinaire sans intention reconnue ;
- changement d’intention seulement après répétition.

### Raphaëlle

- seconde scène de travail ou respiration extérieure ;
- aucun compte privé immédiatement ;
- accès personnel seulement si le contexte le justifie.

### Pauline

- nouvelle scène publique/sociale avant toute sélection privée ;
- Bastien et Marie restent réels ;
- première fissure seulement si la compartimentation est construite.

### Nico

- seconde scène d’amitié avant le regard partagé ;
- sa propre vie et son travail restent visibles ;
- envie domestique seulement après connaissance/contextes répétés.

## 10. Validation V0.86 + V0.86a

Avant merge :

```bash
python3 tools/validate_game_data.py
python3 -m unittest \
  tests.test_godot_prototype_static \
  tests.test_v081_wednesday_static \
  tests.test_v082_thursday_static \
  tests.test_v084_temporal_flow_static \
  tests.test_v085_j1_reconciliation_static \
  tests.test_v086_friday_opening_static \
  tests.test_v086a_temporal_ux_static \
  -v
python3 tools/player_choice_text_check.py \
  game/data/conversations/chapter_04_pauline_public_photo_relay.json \
  game/data/conversations/chapter_04_nico_saved_seat_followup.json \
  game/data/conversations/chapter_04_marie_household_report.json \
  game/data/conversations/chapter_04_mathilde_bathroom_correction.json
python3 tools/player_presence_check.py \
  game/data/conversations/chapter_04_pauline_public_photo_relay.json \
  game/data/conversations/chapter_04_nico_saved_seat_followup.json
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Le connecteur GitHub ne peut pas exécuter ces commandes ; Hermes/local/CI doit confirmer.

## 11. Principes permanents

- le temps contrôle l’accès ;
- un timestamp seul ne débloque rien ;
- futurs jours verrouillés ;
- archives en lecture seule et limitées au jour choisi ;
- scènes optionnelles vues ou expirées ;
- conséquence obligatoire avant nouvelle fenêtre ;
- un fil visible par personnage ;
- co-présence et activité hors téléphone non transformées en fausses bulles ;
- activité hors téléphone suggérée, pas expliquée par une rubrique de journal ;
- image = origine + public + permission ;
- flags avant scores abstraits ;
- legacy conservé mais inactif ;
- rollback simple par squash ;
- aucune modification narrative silencieuse.

## 12. À éviter

- ouvrir directement R2 après `opening_band_complete` ;
- donner à Pauline un crop privé dès sa seconde scène ;
- activer le pacte d’image Nico immédiatement ;
- transformer la connaissance de Mathilde en commentaire de corps ;
- oublier Bastien dans la réalité de Pauline ;
- ajouter une nouvelle photo Sandra sans besoin ;
- réintroduire des écrans textuels de moment de journée ;
- exposer les activités hors téléphone comme indices explicites ;
- confondre archive et replay ;
- construire un scheduler général ou aléatoire ;
- écrire le prochain source pack et son runtime dans la même PR.

## 13. Séquence officielle

```text
V0.86 — Friday Public Traces & Opening Completion
V0.86a — Smartphone Time & Notification Polish
V0.87 — Next Act I Windows Source Pack
V0.88 — Next Act I Runtime Integration Plan
V0.89+ — petites tranches runtime validées
```