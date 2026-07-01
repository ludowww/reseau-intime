# Memory Continuity Model

## Purpose

Ce modèle sert à éviter que les scènes SMS à routes repartent de zéro après chaque journée.
Il formalise ce qu’une scène laisse derrière elle afin que la scène suivante puisse reprendre le fil sans casser le ton, la mémoire émotionnelle ou la logique de route.

## Core principle

Une scène importante ne produit pas seulement un état mécanique. Elle laisse des traces différentes selon le personnage, la route et le joueur.

Ces traces peuvent être relues ensuite comme des faits, des interprétations, des sensations et des états de route.

## Memory layers

Le modèle distingue quatre niveaux complémentaires.

### facts_created

Ce qui s’est objectivement passé.

Exemples :
- un personnage a repris contact ;
- une photo a été envoyée ;
- un choix Player a montré plus de sincérité ;
- une limite a été respectée ;
- une invitation est restée implicite.

### interpreted_memories

Ce que chaque personnage pense que cela voulait dire.

Un même événement peut être retenu différemment par Player, par le personnage concerné et par la route.

Exemple :
- Player retient : elle est revenue vers moi ;
- Sandra retient : il a répondu avec plus de plaisir qu’il ne voulait le montrer ;
- Route retient : première ambiguïté douce ouverte.

### emotional_traces

Les niveaux émotionnels laissés par la scène.

Ce ne sont pas des vérités psychologiques. Ce sont des repères de génération et de QA.

Axes possibles :
- openness
- caution
- nostalgia
- curiosity
- desire_intensity
- trust
- awkward_sincerity
- distance
- risk
- guilt

### route_state_after_scene

Les changements utilisables par les scènes suivantes.

Ce niveau sert à piloter la continuité narrative : callbacks possibles, intensité autorisée, état relationnel, tension ouverte, mémoire réutilisable.

## Required callbacks

Un callback de mémoire doit :
- rappeler une trace ;
- faire sentir que le personnage s’en souvient ;
- ne pas tout expliquer ;
- faire avancer légèrement le lien ;
- ne pas répéter mécaniquement le même déclencheur.

Le callback doit transformer la mémoire, pas la ressaisir comme une information brute.

## Forbidden resets

Une scène ne doit pas :
- traiter un personnage comme s’il ne s’était rien passé ;
- répéter exactement la même scène ;
- ignorer une phrase importante du Player ;
- ignorer une initiative importante du personnage ;
- monter l’intensité sans respecter la progression ;
- faire disparaître Marie ou le contexte social si la route en dépend.

## Continuity tests

Un bon test de continuité vérifie :
- qu’au moins une trace explicite revient ;
- que la scène suivante sait ce qui s’est déjà joué ;
- que la mémoire est interprétée, pas seulement rappelée ;
- que l’intensité reste cohérente ;
- que le callback n’efface pas la scène précédente.

## Difference between callback and repetition

Un callback transforme une trace passée. Une répétition rejoue le même événement.

Exemple :
- Répétition : Sandra renvoie encore une photo du déjeuner comme si c’était nouveau.
- Callback : Sandra demande si Player a gardé la photo ou y a repensé.

Le callback parle de ce que la scène précédente a laissé derrière elle. La répétition ne fait que remettre le même objet en circulation.

## Example: Sandra Day 1 → Day 2

Day 1 : Sandra revient, photo, complicité, ambiguïté.

Mémoire : la photo devient un test relationnel.

Day 2 : Sandra revient sur la photo pour tester si Player s’en souvient.

QA : memory continuity PASS.

## Future use

Ce modèle doit servir de base pour toutes les futures routes à mémoire.

Il permet de :
- réutiliser la logique validée sans copier Sandra mécaniquement ;
- garder des callbacks lisibles ;
- préserver la progression émotionnelle ;
- écrire des scènes qui reconnaissent les traces déjà posées ;
- tester la continuité sans appauvrir l’écriture.