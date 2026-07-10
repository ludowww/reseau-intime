# Réseau Intime

**Réseau Intime** est un jeu narratif adulte en interface smartphone, développé avec Godot 4.6.x.

Le joueur incarne **Player** — nom temporaire — en couple avec **Marie**. Leur vie commune reste réelle et désirable, mais la routine, les images, les secrets, la jalousie et les désirs croisés obligent chacun à choisir ce qu’il veut préserver, cacher, partager ou quitter.

Le téléphone est l’interface principale, pas un remplacement artificiel de toute conversation face à face.

```text
Quand les personnages sont ensemble, ils parlent.
Quand la distance, la logistique, la confidentialité, une trace ou l'après-coup le justifie, le téléphone enregistre l'échange.
```

## Question centrale

```text
Le couple Player / Marie
peut-il redevenir un choix actif ?
```

## Personnages principaux

```text
Marie      = couple et reconquête active
Sandra     = confidence et vérité privée choisie
Mathilde   = proximité domestique et changement d'intention
Pauline    = image, compartimentation et double vie
Nico       = regard social, envie domestique, voyeurisme et rivalité
Raphaëlle  = version choisie, cadre explicite et après-rôle
Player     = regard devenant acte, choix ou mauvaise foi
```

Les sept personnages disposent d’un canon concret complet.

## Architecture narrative

Depuis V0.78 :

```text
tronc dramatique fixe
+ choix topologiques
+ fenêtres narratives
+ scènes modulaires
+ obligations et traces persistantes
+ conséquences revenant vers le couple
```

Une fenêtre contient normalement :

```text
1 scène principale
0–2 échos
```

Les routes suivent :

```text
R0 Background
R1 Ordinary Access
R2 Charged Access
R3 Acknowledged Intent
R4 Consequential Frame
R5 Integration / Aftermath
```

Les choix ne présentent pas une liste de femmes. Ils définissent ce que Player fait et quel contexte devient plausible.

## Temps et communication

Canon général :

```text
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
```

Chaque scène doit identifier :

- jour ou repère relatif ;
- moment de la journée ;
- plage horaire plausible ;
- positions physiques ;
- raison d’utiliser le téléphone ;
- moment où le chat s’arrête si les personnages se rejoignent.

Modes :

```text
REMOTE_ASYNC
TRACE_DELIVERY
SEPARATE_ROOMS_PING
SAME_VENUE_LOGISTICS
WORK_CHAT
OFFLINE_BEAT
AFTERGLOW_REMOTE
```

## État narratif

### J1

```text
Mardi soir — Les choses qu'on remarque
couple mode = HABITUAL_WARMTH
```

J1 est jouable, mais l’audit V0.80 a identifié un raccord runtime à corriger : il montre encore les sacs, baskets et raquette de Mathilde comme si elle était déjà installée. Le canon actuel exige qu’elle reste indirecte jusqu’à l’urgence du mercredi.

### Ouverture Acte I — V0.79

La narration est écrite pour :

```text
Mercredi = urgence et arrivée Mathilde
Jeudi = travail, événement, topologie et retour Marie
Vendredi = photos publiques, suivi Nico et foyer
```

Sources :

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
```

Cette ouverture n’est pas encore intégrée au runtime.

## Plan runtime actuel — V0.80

Sources :

```text
docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
docs/V0_80_First_Modular_Runtime_Integration_Plan.md
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
```

L’audit confirme que le prototype sait déjà :

- grouper plusieurs épisodes dans un fil persistant ;
- afficher segments, choix, historique et timestamps ;
- débloquer séquentiellement des conversations ;
- afficher notifications, flags et visuels placeholders.

Il ne sait pas encore :

- débloquer une branche selon un choix ;
- filtrer des variantes conditionnelles ;
- afficher un `offline_beat` sémantique ;
- piloter le jour et l’heure depuis les données ;
- masquer les anciens jours suspendus.

## Découpage d’intégration

```text
V0.81 — raccord J1 + tranche mercredi
V0.82 — topologie du jeudi + retour Marie
V0.83 — traces du vendredi + clôture de l'ouverture
```

### V0.81

La première PR runtime doit uniquement :

- retirer le faux Mathilde déjà installé du J1 ;
- rendre Mardi / Mercredi visibles ;
- intégrer O1 Marie / faire de la place ;
- intégrer la trace d’arrivée ;
- ouvrir le fil Mathilde ;
- proposer M0 et MT0 à trois choix ;
- arrêter le chat quand Player rentre ;
- afficher l’installation comme `OFFLINE_BEAT` ;
- n’exposer que les indexes Chapter 1 et 2 ;
- utiliser des flags, sans scores de route.

Elle ne doit pas intégrer jeudi ou vendredi.

## Workflow

```text
1. canon et architecture
2. source pack
3. cartes et temporalité
4. audit / plan runtime
5. petite tranche verticale
6. validation
7. extension incrémentale
```

Pas de gros refactoring ni de modification narrative silencieuse pendant l’implémentation.

## Canon à lire

Commencer par :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
```

## Règles adultes fondamentales

```text
Ignorer n'est pas consentir.
Une connaissance partielle n'est pas une permission.
La jalousie ou l'excitation n'est pas une permission.
Une image publique n'est pas une permission de transmettre.
Un vêtement ou costume n'est pas un consentement global.
Un secret clairement nommé reste une trahison.
Une négociation tardive ne réécrit pas une trahison antérieure.
```

## Prochaine étape

Après validation de V0.80 :

```text
V0.81 — Tuesday handoff + Wednesday runtime vertical slice
```
