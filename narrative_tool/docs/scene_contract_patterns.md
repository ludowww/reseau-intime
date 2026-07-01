# Scene Contract Patterns

## Purpose

Cette documentation décrit les patterns de contrats de scènes pour les routes SMS.
Elle sert à préparer la scène avant l’écriture, afin que chaque scène ait une fonction narrative claire.

## What a scene contract is

Un contrat de scène n’est pas un dialogue. C’est une promesse de fonction narrative.

Il décrit ce que la scène doit accomplir avant d’écrire les SMS : pourquoi elle existe, ce qu’elle doit faire bouger, ce qu’elle doit éviter et comment elle sera validée.

## Required fields

Un contrat de scène devrait inclure au minimum :

- scene_id
- day
- conversation_id
- type
- participants
- source_memory_contract
- optional trigger
- objectives
- state_initial
- state_final
- beats_required
- limit_intensity
- target_message_count
- player_presence_minimum
- choice_count_required
- choices_must_be_real_sms
- success_criteria
- forbidden_patterns

## Scene types

### pillar_conversation

Scène longue qui change la relation.
Elle porte la route, le désir, la confiance ou la rupture de dynamique.

### memory_callback

Scène courte ou moyenne qui réactive une trace.
Elle rappelle un événement passé et le transforme légèrement.

### route_pressure

Scène qui teste une conséquence ou une tension.
Elle met la route sous contrainte sans casser la continuité.

### ambient_ping

Petit message de vie hors écran.
Il donne de la présence sans surcharger l’arc narratif.

### media_event

Scène centrée sur photo, vocal, capture ou statut.
Le média compte comme acte relationnel, pas comme décoration.

## Choice design

Les choix doivent être des SMS envoyables, pas des intentions d’auteur.

Types de choix utiles :
- playful_probe
- soft_disclosure
- protective_deflection
- boundary_respect
- repair
- topic_shift
- intimacy_bid

Un bon choix doit pouvoir être envoyé par le Player sans réécriture de l’intention en prose technique.

## State in / state out

Le contrat doit montrer comment la scène lit et écrit l’état.

- state_initial : ce qui est vrai au début de la scène.
- state_final : ce qui doit être vrai à la fin si la scène réussit.
- memory_in : les traces relues ou activées.
- memory_out : les traces nouvelles ou transformées.

Cela permet de vérifier que la scène n’est pas isolée mais reliée à la route.

## Human review checklist

Avant validation, vérifier :

- Est-ce que la scène a une raison d’exister ?
- Est-ce que le personnage a une volonté propre ?
- Est-ce que Player est présent ?
- Est-ce que les choix sont de vrais SMS ?
- Est-ce que la scène respecte l’intensité autorisée ?
- Est-ce qu’elle crée ou transforme une mémoire ?
- Est-ce qu’elle évite les resets émotionnels ?
- Est-ce qu’elle avance la route sans la répéter ?

## Forbidden patterns

À éviter absolument :
- scène sans fonction narrative ;
- personnage passif ;
- Player décoratif ;
- choix abstraits ou non envoyables ;
- intensité hors contrat ;
- callback qui répète au lieu de transformer ;
- scène qui oublie les traces déjà posées ;
- scène qui remplace la progression par une simple reformulation.

## Future use

Ces patterns doivent servir à standardiser la préparation des scènes tout en laissant à chaque route son propre rythme, sa propre mémoire et ses propres coûts émotionnels.