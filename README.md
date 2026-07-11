# Réseau Intime

**Réseau Intime** est un jeu narratif adulte en interface smartphone, développé avec Godot 4.6.x.

Le joueur incarne **Player** — nom temporaire — en couple avec **Marie**. Leur vie commune reste réelle et désirable, mais la routine, les images, les secrets, la jalousie et les désirs croisés obligent chacun à choisir ce qu’il veut préserver, cacher, partager ou quitter.

```text
Quand les personnages sont ensemble, ils parlent.
Quand la distance, la logistique, la confidentialité, une trace ou l'après-coup le justifie, le téléphone enregistre l'échange.
```

## Question centrale

```text
Le couple Player / Marie
peut-il redevenir un choix actif ?
```

## Architecture

```text
tronc dramatique fixe
+ choix topologiques
+ fenêtres narratives
+ scènes modulaires
+ obligations et traces persistantes
+ conséquences revenant vers le couple
```

Les routes utilisent :

```text
R0 Background
R1 Ordinary Access
R2 Charged Access
R3 Acknowledged Intent
R4 Consequential Frame
R5 Integration / Aftermath
```

Les choix définissent ce que Player fait. Ils ne présentent pas les personnages comme un menu de routes.

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

## Temps et communication

Canon :

```text
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
```

Le runtime doit rendre lisibles :

- le jour ;
- le moment de la journée ;
- le temps écoulé ;
- la raison d’utiliser le téléphone ;
- le passage hors ligne lorsque les personnages se rejoignent.

Modes principaux :

```text
REMOTE_ASYNC
TRACE_DELIVERY
SEPARATE_ROOMS_PING
SAME_VENUE_LOGISTICS
WORK_CHAT
OFFLINE_BEAT
AFTERGLOW_REMOTE
```

## État jouable actuel — V0.81

### Mardi soir

```text
J1 — Les choses qu'on remarque
couple mode = HABITUAL_WARMTH
```

Fils actifs :

- Marie ;
- Sandra.

Le raccord actif ne montre plus Mathilde déjà installée. Les anciens messages de sacs, chaussures, sport et raquette sont filtrés par l’index modulaire.

### Mercredi

```text
12:10 — Marie / faire de la place
18:18 — Marie / trace d'arrivée
18:22 — Mathilde / arrivée
18:46, 18:50 ou 19:15 — installation hors ligne
```

V0.81 implémente :

- Mardi / Mercredi pilotés par les données ;
- un seul fil persistant par personnage ;
- M0 et MT0 à trois choix ;
- déblocage séquentiel ;
- `mathilde_arrival_room_01` ;
- un `time_separator` sémantique ;
- un `offline_beat` sans faux expéditeur ;
- une heure narrative qui ne fuit pas depuis les épisodes verrouillés et ne recule pas ;
- des flags observables plutôt que de nouveaux scores de route.

État après mercredi :

```text
Mathilde stay = active
Mathilde = R1 Ordinary Access
hard secrets = none
adult frames = none
Thursday = not implemented
Friday = not implemented
```

## Navigation active

Le chargeur canonique expose seulement :

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
```

Les anciens Chapter 2–9 restent dans le dépôt pour historique et rollback, mais ne sont pas présentés comme la continuation courante.

## Sources actuelles

Commencer par :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
```

Sources runtime V0.81 :

```text
docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
docs/V0_80_First_Modular_Runtime_Integration_Plan.md
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
docs/V0_81_Tuesday_Handoff_And_Wednesday_Runtime_Report.md
```

## Workflow

```text
1. canon et architecture
2. source pack et cartes
3. plan runtime
4. petite tranche verticale
5. validation
6. extension incrémentale
```

Pas de gros refactoring ni de modification narrative silencieuse pendant l’implémentation.

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

Après validation de V0.81 :

```text
V0.82 — Thursday topology and mandatory Marie return
```
