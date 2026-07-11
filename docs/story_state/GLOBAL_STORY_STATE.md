# État global de l’histoire — V0.86

> Résumé opérationnel après intégration des traces publiques du vendredi et clôture de l’ouverture V0.79.  
> Le runtime est jouable du mardi au vendredi avec ordre temporel autoritaire.  
> L’ouverture se termine sur `opening_band_complete`, sans route R2 ni cadre adulte.

## 1. Hiérarchie actuelle

```text
canon personnages
+ V0.78 architecture
+ V0.79 ouverture
= vérité narrative large

V0.83 flux temporel et source J1 réconciliée
= vérité corrective

V0.84–V0.85
= temps autoritaire, archives et contenu mardi actif

V0.86
= vendredi actif et ouverture concrète terminée

legacy Chapter 1–9
= historique technique sauf référence active explicite
```

## 2. Visibilité initiale et chaîne des jours

Au lancement :

```text
Mardi = actif
Mercredi = verrouillé
Jeudi = verrouillé
Vendredi = verrouillé
```

Progression :

```text
fin Mardi -> interstitiel -> Mercredi
fin Mercredi -> interstitiel -> Jeudi
fin Jeudi -> interstitiel -> Vendredi
fin Vendredi -> aucune suite disponible
```

Les jours suivants peuvent être chargés, mais leur état temporel contrôle l’accès.

## 3. Mardi — J1 réconcilié

```text
18:12 Marie / dîner, pain et marche
-> M1 à trois choix

19:15 ou 19:35
-> dîner et marche hors ligne

22:57 Sandra / ancienne photo floue
-> S1 à trois choix

23:25 ou 23:28
-> retour final Marie hors ligne

fin Mardi -> Mercredi
```

Garanties :

- pain encore à acheter au moment du choix ;
- timestamps monotones et avant minuit ;
- Mathilde indirecte ;
- Sandra limitée à une trace douce ;
- aucun score de route ;
- final sur Marie et la vie commune.

## 4. Mercredi — changement du foyer

```text
12:10 Marie / faire de la place
-> 18:18 trace d'arrivée
-> 18:22 Mathilde / arrivée
-> installation hors ligne
-> fin Mercredi / début Jeudi
```

État :

```text
Mathilde stay = active
Mathilde = R1 Ordinary Access
sexual intention = none
```

## 5. Jeudi — mouvement et topologie

```text
09:10 Raphaëlle obligatoire
-> 13:50 Sandra optionnelle
-> Sandra vue ou expirée
-> 16:05 Marie obligatoire
-> une branche O5
-> 22:10 O6 Marie obligatoire
-> fin Jeudi / début Vendredi
```

Si Sandra est ignorée :

```text
chapter_03_sandra_continuity = EXPIRED
thursday_sandra_echo_missed = true
```

État :

```text
Raphaëlle = R1 travail
first topology = remembered
Marie consequence = paid
couple mode = HABITUAL_WARMTH
```

## 6. Vendredi — traces et résidu

### 08:35 — Pauline

```text
set de trois photos de groupe autorisées
-> P0 : pratique / plaisanterie sèche / renvoi vers Marie
```

Résultat :

```text
Pauline = R1 Legitimate Social Access
Bastien visible = true
public group-photo trace = exists
private crop = none
```

### 14:05 — Nico

```text
suivi de la place gardée selon la topologie de jeudi
-> N0 : honnête / joueur / demander pour Marie
```

Résultat :

```text
Nico = R1 Ordinary Friendship / Social Access
saved-seat trace = resolved
Mathilde stay may be known
sexualization = none
```

### 18:05 — Foyer

Deux échos séparés :

```text
Marie / rapport de la salle de bain
Mathilde / correction officielle
```

Ils appartiennent à la même phase mais à deux fils privés distincts.

### 18:25 — Fermeture hors ligne

```text
Player retrouve Marie et Mathilde.
Le nouveau rythme tient pour ce soir.
```

Écrit :

```text
household_rhythm_confirmed
opening_band_complete
```

## 7. Trace publique du vendredi

```text
laverriere_public_group_photo_set_01
```

Origine :

```text
Pauline + télécommande compacte
```

Public prévu :

```text
groupe photographié
+ archive/publication La Verrière
```

Contexte visible :

- Marie ;
- Pauline ;
- Bastien ;
- Élodie ;
- Nico possible ;
- Player selon sa présence ;
- Mathilde absente.

Règles :

- image autorisée et sociale ;
- risque 0 ;
- aucune version privée ;
- aucune vue unique ;
- aucun recadrage corporel ;
- aucune fonction adulte ;
- le caractère public ne crée pas une autorisation générale de transmission privée.

## 8. Temps et phases hors ligne

Jour :

```text
LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
```

Phase :

```text
LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

Phases hors ligne actives :

- mardi dîner/marche ;
- mardi retour final Marie ;
- vendredi fermeture du foyer.

Elles sont affichées une fois et conservées une fois dans l’archive sous `Moments hors ligne`.

## 9. Archives

Une journée terminée :

- reste consultable ;
- n’affiche aucun badge pending ;
- ne produit aucune notification ;
- n’offre aucun nouveau choix ;
- ne réapplique aucun effet ;
- ne change pas l’heure ;
- ne réactive pas une scène expirée ;
- filtre les fils persistants par épisode source ;
- affiche ses beats hors ligne en lecture seule.

## 10. État narratif à la fin de l’ouverture

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE

Sandra = soft trace / continuité ordinaire refroidie ou disponible
Mathilde = R1 domestique, stay active
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

## 11. Fichiers actifs ajoutés vendredi

```text
game/data/conversations/chapter_04_modular_index.json
game/data/conversations/chapter_04_pauline_public_photo_relay.json
game/data/conversations/chapter_04_nico_saved_seat_followup.json
game/data/conversations/chapter_04_marie_household_report.json
game/data/conversations/chapter_04_mathilde_bathroom_correction.json
game/data/visual_content/chapter_04_opening_proofs.json
```

Les fichiers Chapter 4 legacy restent sur disque et inactifs.

## 12. Validation

Nouveau test :

```text
tests/test_v086_friday_opening_static.py
```

Les commandes Python et Godot doivent être exécutées par Hermes/local/CI avant merge.

## 13. Prochaine version

```text
V0.87 — Next Act I Windows Source Pack
```

V0.87 doit revenir à la documentation avant toute nouvelle extension runtime.

Il définira les premières répétitions et attentions privées après l’accès ordinaire, sans autoriser automatiquement R2.

## 14. Résumé opérationnel

```text
Runtime : jouable mardi–vendredi, ordre imposé.
Ouverture V0.79 : implémentée et terminée.
Pauline : R1 public/social.
Nico : R1 amitié/social.
Foyer : nouveau rythme confirmé.
Secrets / adulte / R2 : absents.
Prochaine étape : nouveau source pack Acte I, documentation d'abord.
```
