# État global de l’histoire — V0.81

> Résumé opérationnel après intégration de la première tranche runtime modulaire.  
> Le runtime jouable actuel est canonique jusqu’au mercredi soir seulement.

## 1. Hiérarchie actuelle

```text
canon personnages
+ V0.78 architecture
+ V0.79 source pack / cartes / temps
= vérité narrative

V0.80 audit / plan
= stratégie technique

V0.81 runtime actif
= vérité jouable mardi–mercredi

anciens Chapter 2–9
= fichiers legacy inactifs
```

## 2. Runtime actif

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
```

Seuls Mardi et Mercredi apparaissent dans la navigation actuelle.

Les anciens jours restent sur disque pour historique et rollback.

## 3. Mardi — J1

```text
Marie + Sandra actives
Mathilde indirecte seulement
couple mode = HABITUAL_WARMTH
```

Le runtime actif filtre désormais :

- les sacs de Mathilde dans l’entrée ;
- les baskets / sac de sport / raquette ;
- le visuel `j1_mathilde_bag_domestic_trace`.

Mathilde ne possède aucun fil actif mardi.

## 4. Mercredi — tranche jouable

### 12:10 — Marie / faire de la place

Mathilde subit un dégât des eaux.

Player choisit :

```text
M0A — participer activement
M0B — plaisanter tout en étant présent
M0C — donner un assentiment passif
```

### 18:18 — Marie / trace d’arrivée

Marie envoie :

```text
mathilde_arrival_room_01
```

Image :

- pratique ;
- autorisée ;
- privée ;
- sans fonction sexuelle ;
- non transmissible par défaut.

### 18:22 — Mathilde / arrivée

Player choisit :

```text
MT0A — accueil pratique
MT0B — accueil taquin et serviable
MT0C — accueil distant
```

### Co-présence

Selon la branche, Player rentre vers :

```text
18:46
18:50
19:15
```

À ce moment :

```text
le chat s’arrête
-> l’installation continue face à face
```

Le runtime affiche un `offline_beat` centré, sans expéditeur ni indicateur de frappe.

## 5. État après mercredi

```text
Mathilde stay = active
Mathilde route stage = R1 Ordinary Access
opening Wednesday = complete
hard secrets = none
adult frames = none
Thursday = not implemented
Friday = not implemented
```

Flags possibles :

```text
opening_make_room_proactive
opening_make_room_playful
opening_make_room_passive
mathilde_arrival_practical
mathilde_arrival_playful
mathilde_arrival_distant
mathilde_stay_active
opening_wednesday_complete
```

Aucun score de désir ou de route n’est ajouté.

## 6. Temps et interface

Le statut du téléphone n’est plus figé à `09:41` dans la tranche active.

Il suit les moments débloqués et les événements hors ligne.

Une heure future ne doit pas apparaître avant le déblocage de son épisode.

Un ancien séparateur ne peut pas faire reculer l’heure après un moment plus tardif.

## 7. Fils persistants

Marie conserve un seul fil regroupant :

- J1 ;
- O1 mercredi ;
- O2 trace d’arrivée.

Mathilde ouvre un seul fil mercredi soir.

Le joueur ne voit pas une carte différente pour chaque épisode.

## 8. Visuel actuel

```text
mathilde_arrival_room_01
```

Le catalogue legacy contient encore d’anciens placeholders, mais aucun contenu actif V0.81 ne référence le selfie canapé ou le faux raccord J1.

## 9. Validation

Tests ajoutés :

```text
tests/test_v081_wednesday_static.py
```

Leur exécution doit être confirmée hors du connecteur GitHub actuel, qui ne dispose ni d’un clone local accessible ni du binaire Godot.

## 10. Prochaine étape

```text
V0.82 — Thursday topology and mandatory Marie return
```

V0.82 devra ajouter uniquement :

- Raphaëlle travail ;
- écho Sandra ;
- invitation Marie ;
- un déblocage conditionnel d’une seule branche ;
- O5A/O5B/O5C ;
- retour O6 obligatoire vers Marie.

## 11. Résumé

```text
J1 : raccord Mathilde corrigé dans le runtime actif.
Mercredi : jouable.
Jeudi : écrit mais non intégré.
Vendredi : écrit mais non intégré.
Routes : R1 Mathilde seulement.
Couple : HABITUAL_WARMTH.
```
