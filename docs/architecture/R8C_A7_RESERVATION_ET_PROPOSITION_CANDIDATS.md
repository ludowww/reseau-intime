# R8C-A7 — Réservation et proposition de candidats

> **Statut :** `IMPLEMENTED_PROTOTYPE_NON_CANONIQUE`
> **Base :** R8C-A6 verrouillé au SHA `e02a7bc8170761e52b63c0d4c40d5249ad8a3a22`
> **Contenu :** bundle prototype A6 uniquement; aucun contenu Saison 1.

## Frontière A7

`R8CCandidateReservationProposalCoordinator` est l'unique pont entre un
candidat A6 et une instance A5. Son entrée est un candidat retourné par
`query_candidates()`, l'état et le contexte courants, puis une intention
explicite `RESERVE` ou `PROPOSE`. Il ne choisit aucun candidat et ne construit
ni journée ni séquence.

La bibliothèque A6 joint au candidat une preuve opaque, éphémère et liée à la
bibliothèque chargée, aux trois identités et au contexte exact. A7 refuse un
candidat sans preuve valide, issu d'une autre bibliothèque, modifié, périmé ou
présenté avec un contexte différent. La définition est toujours relue depuis le
bundle chargé; le candidat ne transporte jamais une définition faisant autorité.

## Transaction

L'ordre est fermé :

1. vérifier l'intention, le candidat, sa provenance et son contexte;
2. relire la définition A6 et revalider toutes les conditions via A3;
3. détecter le rejeu déterministe par `instance_id`;
4. créer puis enregistrer une instance A5 seulement si tout est valide.

Pour `PROPOSE`, A3 prépare la transition `ELIGIBLE → PROPOSED` sur l'instance
détachée avant son enregistrement A5. Un refus d'identité, de contexte,
d'unicité, de fenêtre, de disponibilité ou de condition ne publie donc aucune
instance et ne modifie pas A1.

## Réservation sans nouvel état

Aucun état `RESERVED` n'est ajouté. Une réservation est une instance A5
`ELIGIBLE` matérialisée et conservée en interne. Elle n'a jamais été rendue
perceptible au joueur : elle ne peut donc pas devenir `MISSED`. Elle peut être
annulée par la transition A3 existante vers `CANCELLED`, sans événement
relationnel implicite.

Une proposition est créée directement en `PROPOSED`. Elle seule peut ensuite
être résolue, annulée ou devenir `MISSED` selon la politique A3 de la définition.
Le bundle prototype A6 déclare une expiration locale `MISSED`, sans conséquence
relationnelle authored.

## Identité et idempotence

- `scene_definition_id` et `variant_id` viennent exclusivement de l'entrée A6;
- `instance_id` vient du contexte explicite et identifie la demande déterministe;
- le même candidat, contexte et intention retourne la même instance sans mutation;
- une intention incompatible sur le même `instance_id` est refusée;
- une autre demande sur une définition `UNIQUE` est refusée à la revalidation;
- une définition `REPETABLE` accepte des `instance_id` distincts.

La preuve du candidat est éphémère et n'entre pas dans le snapshot A5. Les trois
identités sont rendues séparément dans le résultat A7; aucune clé concaténée ne
devient une nouvelle source de vérité.

## Diagnostics et limites

`executer()` rend uniquement le verdict, les identités, l'intention, l'état et
le marqueur d'idempotence. Les raisons A3 détaillées restent derrière
`executer_dev()`, disponible seulement en build de développement, tests ou
éditeur.

A7 n'ajoute aucune sélection automatique, préférence, pondération, priorité,
randomisation, topologie de journée, séquence, UX Portrait ou connexion au
runtime Saison 1.

## Validation ciblée

```bash
python -m unittest tests.test_r8c_a1_narrative_state_static tests.test_r8c_a3_minimal_scene_prototype_static tests.test_r8c_a5_persistent_scene_registry_static tests.test_r8c_a6_minimal_narrative_library_static tests.test_r8c_a7_candidate_reservation_proposal_static -v
godot --headless --path game res://tests/R8CACandidateReservationProposalSmokeTest.tscn
```
