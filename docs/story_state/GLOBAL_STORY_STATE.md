# État global de l’histoire — V0.80

> Résumé opérationnel après audit du prototype et planification de la première intégration modulaire.  
> V0.80 est documentaire : le runtime reste inchangé.

## 1. Hiérarchie actuelle

```text
canon personnages
+ V0.78 architecture
+ V0.79 source pack / cartes / temps
= vérité narrative

V0.80 audit + plan d'intégration
= vérité technique pour la prochaine PR

runtime actuel
= prototype pré-modulaire, pas vérité narrative automatique
```

Sources V0.80 :

```text
docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
docs/V0_80_First_Modular_Runtime_Integration_Plan.md
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
```

## 2. État narratif canonique

### Mardi soir — J1

```text
couple mode = HABITUAL_WARMTH
Mathilde = indirecte seulement
Sandra = trace douce
routes externes = inactives
```

### Mercredi–vendredi — V0.79

Le contenu est écrit et validable dans la documentation, mais pas encore intégré au prototype.

```text
Mercredi = urgence / arrivée Mathilde
Jeudi = travail / événement / topologie / retour Marie
Vendredi = photos publiques / Nico / foyer
```

## 3. Écart runtime critique

Le J1 jouable actuel montre encore :

- les sacs de Mathilde dans l’entrée ;
- ses baskets ;
- un sac de sport / une raquette ;
- une image `j1_mathilde_bag_domestic_trace`.

Cela contredit l’arrivée du mercredi après dégât des eaux.

Décision V0.80 :

```text
V0.81 corrige uniquement ce raccord J1
avant d'intégrer le mercredi.
```

## 4. Capacités déjà réutilisables

Le prototype sait déjà :

- conserver un fil par personnage ;
- fusionner plusieurs épisodes dans le même fil ;
- afficher des segments, choix, réponses et historiques ;
- débloquer séquentiellement des conversations ;
- afficher notifications, heures et cartes visuelles ;
- enregistrer des flags.

Il ne sait pas encore :

- débloquer une branche selon un choix ;
- filtrer conditionnellement des variantes ;
- représenter proprement un `offline_beat` ;
- piloter le jour et l’heure depuis les données ;
- masquer automatiquement les anciens jours suspendus.

## 5. Découpage runtime approuvé par le plan

```text
V0.81 — raccord mardi + tranche mercredi
V0.82 — topologie du jeudi + retour Marie
V0.83 — traces du vendredi + clôture de l'ouverture
```

Le pack complet O0–O8 ne doit pas être intégré en une seule PR.

## 6. Périmètre V0.81

V0.81 doit implémenter seulement :

```text
J1 : suppression du faux Mathilde déjà installé
Mercredi midi : O1 Marie / faire de la place
Mercredi fin de journée : trace d'arrivée Marie
Mercredi soir : fil Mathilde / arrivée
19h15 environ : installation hors ligne
```

Choix :

```text
M0  — proactive / joueuse-présente / passive
MT0 — pratique / taquine / distante
```

État : flags uniquement.

Aucune route R2, aucun secret, aucun contenu adulte.

## 7. Temps et communication V0.81

- boutons : Mardi / Mercredi ;
- heure de statut pilotée par la fenêtre active ;
- Marie O1 à midi ;
- trace O2 en fin de journée ;
- Mathilde avant le retour de Player ;
- le chat s’arrête lors de la co-présence ;
- l’installation devient un `offline_beat` centré, pas une fausse bulle.

## 8. Navigation active

Pour V0.81 :

```text
indexes actifs = chapter_01 + chapter_02
```

Les anciens Chapter 3+ restent sur disque mais ne sont plus présentés comme continuation actuelle.

Ils sont conservés pour historique, rollback et inspection technique.

## 9. État visé après V0.81

```text
Tuesday handoff = cohérent
Wednesday opening = jouable
Mathilde stay = active
Mathilde route stage = R1 seulement
hard secrets = none
adult frames = none
Thursday = non implémenté
Friday = non implémenté
```

## 10. Prochaine étape

Après validation de V0.80 :

```text
V0.81 — Tuesday handoff + Wednesday runtime vertical slice
```

Hermes/Codex doit suivre strictement :

```text
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
```

## 11. Résumé opérationnel

```text
Narration : écrite jusqu'à vendredi.
Runtime : actuel jusqu'à J1, mais raccord Mathilde incohérent.
Plan : corriger le raccord et rendre uniquement mercredi jouable.
Jeudi conditionnel : V0.82.
Vendredi : V0.83.
```
