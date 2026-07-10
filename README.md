# Réseau Intime

**Réseau Intime** est un jeu narratif adulte en interface smartphone, développé avec Godot 4.6.x.

Le joueur incarne **Player** — nom générique temporaire, remplacé à terme par le prénom choisi — en couple avec **Marie**. Leur vie commune reste réelle, tendre et désirable, mais la routine, les notifications, les images, les secrets et les désirs croisés obligent progressivement chacun à choisir ce qu’il veut préserver, cacher, partager ou quitter.

Le jeu se déroule principalement via :

- messagerie instantanée ;
- notifications ;
- publications sociales ;
- photographies et vidéos ;
- conversations privées ou de groupe ;
- traces numériques et conséquences dans la vie ordinaire.

## Promesse du jeu

```text
Toutes les routes racontent la même histoire :
un couple en routine entouré de désirs qui se réveillent.

Ce qui change,
c'est la manière dont Player gère cette vérité :
participer, mentir, avouer, partager, contrôler, subir, réparer ou partir.
```

Le projet n’est pas une romance classique ni un porno générique.

La crédibilité psychologique existe pour rendre les scènes adultes, la tromperie, le voyeurisme, la jalousie, le NTR/cuckold, le partage, les trios, les groupes, les images et les secrets plus forts et plus spécifiques aux personnages.

## Décisions validées

```text
Titre officiel : Réseau Intime
Moteur : Godot 4.6.x
Interface principale : smartphone
Architecture : tronc dramatique fixe + fenêtres narratives + scènes modulaires
Choix : 3 maximum par défaut
Méthode : documentation validée avant runtime
```

## Question centrale

```text
Le couple Player / Marie
peut-il redevenir un choix actif ?
```

Les autres personnages ne constituent pas des histoires séparées. Ils offrent des réponses, tentations ou conséquences différentes autour de la crise du couple.

```text
Marie      = le couple et la reconquête active
Sandra     = la confidence et la vérité privée choisie
Mathilde   = la proximité domestique et le changement d'intention
Pauline    = l'image, la compartimentation et la double vie
Nico       = le regard social, l'envie domestique, le voyeurisme et la rivalité
Raphaëlle  = la version choisie, le cadre explicite et l'après-rôle
Player     = le regard qui devient acte, choix ou mauvaise foi
```

## Architecture narrative actuelle

Depuis V0.78, l’ancien déroulement fixe J2–J10 n’est plus le modèle de production.

Le modèle actuel est :

```text
tronc dramatique fixe
+ choix qui changent le contexte
+ fenêtres narratives
+ scènes modulaires propres aux personnages
+ obligations et traces persistantes
+ conséquences qui reviennent vers le couple
```

Une fenêtre contient normalement :

```text
1 scène principale
0–2 échos
```

Les choix ne présentent pas les personnages comme un menu de routes. Ils définissent ce que Player fait, où il se trouve, qui est réellement disponible et quelle conséquence devient due.

## État narratif actuel

### J1

`J1 — Les choses qu'on remarque` est le contenu canon actuel et runtime-aligné.

Il établit :

- Marie et Player encore ensemble dans une chaleur habituelle ;
- Sandra réintroduite par une trace douce ;
- Mathilde indirecte seulement ;
- Pauline, Nico et Raphaëlle absents des fils actifs ;
- aucune route verrouillée ;
- aucun secret dur ;
- aucun contenu explicite.

### Première ouverture post-J1

V0.79 fournit le premier source pack modulaire concret :

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
```

Il définit :

- le séjour temporaire de Mathilde après un dégât des eaux ;
- les premiers choix de participation au foyer ;
- l’entrée professionnelle ordinaire de Raphaëlle ;
- une continuité Sandra mesurée ;
- le premier choix topologique autour d’un événement de Marie ;
- un retour obligatoire vers le couple ;
- l’entrée sociale ordinaire de Pauline et Nico ;
- aucune route adulte ou trahison active.

Ce contenu est documentaire et n’est pas encore intégré au runtime.

### J2+ historique

L’ancien J2 intégré et les anciennes fondations J3–J10 restent disponibles comme référence technique ou historique.

Ils ne sont plus une source narrative automatique.

Le selfie canapé Mathilde, l’ordre fixe J2 et les anciens calendriers de routes sont suspendus lorsqu’ils contredisent le canon actuel.

## Canon à lire

Commencer par :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
```

Principales sources :

```text
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/CHOICE_DESIGN_CANON.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/characters/CHARACTER_CANON_INDEX.md
docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md
```

## Piliers de conception

- Smartphone immersif et conversations multiples.
- Marie et la vie commune restent le centre vivant.
- Les scènes adultes peuvent devenir directes et pornographiques lorsque le cadre est mérité.
- Chaque personnage conserve sa voix et son moteur propre.
- Images, messages, promesses, alibis et suppressions deviennent des traces.
- Les conséquences dues passent avant les nouvelles tentations.
- Les personnages secondaires restent humains sans recevoir automatiquement une route.
- La rejouabilité vient des contextes, connaissances, obligations et conséquences, pas seulement de scènes à collectionner.

## Règles adultes fondamentales

```text
Ignorer n'est pas consentir.
Une connaissance partielle n'est pas une permission.
La jalousie ou l'excitation n'est pas une permission.
Une image publique n'est pas une permission de transmettre.
Un vêtement ou un costume n'est pas un consentement global.
Un secret clairement nommé reste une trahison.
Une négociation tardive ne réécrit pas une trahison antérieure.
```

## Workflow

```text
1. canon et architecture
2. source pack concret
3. cartes de scènes
4. plan d'intégration runtime
5. petite tranche verticale
6. validation
7. extension pool par pool
```

Pas de gros refactoring ni de modification runtime avant validation documentaire.

## Prochaine étape

```text
V0.80 — First Modular Runtime Integration Plan
```

V0.80 doit inspecter le runtime existant et proposer une intégration minimale de la tranche V0.79, sans encore modifier Godot ou les JSON narratifs.
