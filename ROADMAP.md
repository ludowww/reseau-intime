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
- V0.85 : J1 actif remplacé par le contenu canonique concis.

## 2. Runtime actif V0.85

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
Vendredi absent
```

Progression :

```text
fin Mardi -> interstitiel -> Mercredi
fin Mercredi -> interstitiel -> Jeudi
fin Jeudi -> aucune suite disponible
```

Le runtime reste en R1 maximum, sans secret dur ni contenu adulte.

## 3. Mardi réconcilié

```text
18:12 Marie / dîner, pain et marche
-> M1 à trois choix

19:15 ou 19:35
-> dîner et marche hors ligne

22:57 Sandra / ancienne photo floue
-> S1 à trois choix

23:25 ou 23:28
-> final Marie / vie commune hors ligne

fin Mardi -> Mercredi
```

### M1

```text
présent
joueur-présent
retardé-plat
```

### S1

```text
chaleur sûre
observation précise
prudence
```

### Garanties

- le pain est une action future au moment du choix ;
- timestamps monotones et avant minuit ;
- Mathilde indirecte uniquement ;
- Sandra reste une trace douce ;
- aucun ancien score numérique ;
- mardi finit sur Marie.

## 4. Acquis techniques V0.84–V0.85

### État temporel

```text
Day: LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
Phase: LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

### Interface

- interstitiels de changement de jour ;
- cartes courtes pour grands sauts horaires ;
- délai minimal de lecture ;
- skip après ce délai ;
- jours terminés en historique lecture seule.

### Phases hors ligne

V0.85 ajoute :

```text
game/scripts/ui/PhonePrototypeV085.gd
```

pour exécuter des phases sans conversation :

- dîner/marche ;
- retour final Marie.

Ces phases sont enregistrées dans le journal du jour et apparaissent une seule fois dans l’archive.

### Ordre narratif

- un jour futur ne peut pas être ouvert manuellement ;
- un épisode futur ne fuit pas par son heure ;
- Sandra jeudi doit être terminée ou expirée avant Marie ;
- une conversation expirée n’est plus répondable ;
- O6 Marie termine toujours jeudi ;
- mardi exige le final Marie avant mercredi.

## 5. État narratif après jeudi

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra J1 = soft trace seed only
Mathilde = R1 domestique
Raphaëlle = R1 travail
Sandra jeudi = continuité douce ou écho expiré
Pauline = inactive
Nico = inactive
hard secrets = none
adult frames = none
```

## 6. Prochaine étape — V0.86

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
- transition temporelle cohérente ;
- état d’ouverture vérifié.

## 7. Validation V0.85

Avant merge :

```bash
python3 tools/validate_game_data.py
python3 -m unittest \
  tests.test_godot_prototype_static \
  tests.test_v081_wednesday_static \
  tests.test_v082_thursday_static \
  tests.test_v084_temporal_flow_static \
  tests.test_v085_j1_reconciliation_static \
  -v
python3 tools/player_choice_text_check.py \
  game/data/conversations/chapter_01_marie_opening.json \
  game/data/conversations/chapter_01_sandra_trace.json
python3 tools/player_presence_check.py \
  game/data/conversations/chapter_01_marie_opening.json \
  game/data/conversations/chapter_01_sandra_trace.json
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Le connecteur GitHub ne peut pas exécuter ces commandes ; Hermes/local/CI doit confirmer.

## 8. Principes permanents

- le temps contrôle l’accès ;
- un timestamp seul ne débloque rien ;
- futurs jours verrouillés ;
- archives en lecture seule et limitées au jour choisi ;
- scènes optionnelles vues ou expirées ;
- conséquence obligatoire avant fin de journée ;
- final J1 sur Marie ;
- un fil visible par personnage ;
- co-présence hors ligne ;
- flags avant scores abstraits ;
- legacy conservé mais inactif ;
- rollback simple par squash ;
- aucune modification narrative silencieuse.

## 9. À éviter

- commencer vendredi avant validation de V0.85 ;
- réactiver les gros fichiers J1 ;
- prétendre que le pain a déjà été acheté avant le choix ;
- permettre des timestamps `24:xx` dans Mardi ;
- finir J1 sur Sandra ;
- réintroduire les anciens scores ;
- confondre archive et replay ;
- construire un scheduler général ou aléatoire ;
- ouvrir R2 ou l’adulte.

## 10. Séquence officielle

```text
V0.85 — J1 Canon Runtime Reconciliation
V0.86 — Friday Public Traces & Opening Completion
V0.87+ — extension incrémentale de l'Acte I
```
