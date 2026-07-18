# Réseau Intime — Registre canonique des connaissances J01–J21

## Statut

**Catégorie : Contrat narratif pré-runtime**

**Périmètre : faits capables de modifier un dialogue, une réaction, une découverte ou une conséquence**

Ce document interdit l’omniscience implicite.

Une personne ne sait quelque chose que par :

- observation directe ;
- message reçu ;
- déclaration attribuable ;
- trace visible ;
- déduction raisonnable explicitement marquée comme telle.

Une proximité sociale, une amitié ou une intuition ne crée pas automatiquement un fait précis.

---

# 1. Schéma canonique

Chaque connaissance est une entrée :

```text
knowledge_id
fact_id
knower
source_type
source_ref
acquired_at
certainty
scope
shareability
still_valid
contradicted_by
```

## 1.1 `source_type`

```text
DIRECT_OBSERVATION
DIRECT_MESSAGE
DIRECT_STATEMENT
PUBLIC_TRACE
PRIVATE_TRACE
THIRD_PARTY_STATEMENT
INFERENCE
```

## 1.2 `certainty`

```text
OBSERVED
TOLD_DIRECTLY
CONFIRMED
INFERRED
SUSPECTED
DENIED
UNKNOWN
```

## 1.3 `shareability`

```text
PRIVATE_DO_NOT_SHARE
FACTUAL_ONLY
SAME_AUDIENCE_ONLY
PUBLIC
OWNER_CONFIRMATION_REQUIRED
PROTECTIVE_DISCLOSURE_ONLY
```

## 1.4 Règle de persistance

Une connaissance ne disparaît pas avec la suppression du fichier.

Elle peut :

- être corrigée ;
- devenir moins certaine ;
- être contredite ;
- changer de portée.

Elle ne revient jamais à `UNKNOWN` uniquement parce qu’une image est retirée.

---

# 2. Faits publics et relationnels de base

## F01 — Couple Marie / Player au début

```text
fact_id: fact_marie_player_couple_exists
truth: Marie et Player vivent comme un couple au début de la saison
public_scope: réseau proche
```

Connaisseurs autorisés :

```text
Marie, Player, Sandra, Mathilde, Pauline, Raphaëlle selon contexte professionnel,
Nico, Bastien, Jeff selon relations établies
```

La connaissance du couple ne donne aucun accès à ses règles privées.

## F02 — Séjour Mathilde actif

```text
fact_id: fact_mathilde_stay_started
source_ref: j02_mathilde_arrival_room_01
```

Connaisseurs initiaux :

```text
Marie, Player, Mathilde
```

Nico, Pauline ou d’autres personnes peuvent l’apprendre uniquement par une déclaration directe ou un contexte social crédible.

## F03 — Pauline et Bastien forment un couple réel

```text
fact_id: fact_pauline_bastien_couple_public
source_ref: j04_pauline_bastien_public_set_01
certainty: PUBLIC / CONFIRMED
```

Cette connaissance n’indique pas :

- la fidélité réelle de Pauline ;
- ce que Bastien sait ;
- l’existence d’un compartiment privé.

## F04 — Marie possède une vie La Verrière autonome

```text
fact_id: fact_marie_laverriere_world_exists
source_ref: j03_marie_laverriere_setup_01 ou j09_marie_laverriere_public_01
```

Player ne peut pas réduire cette vie à une obligation de couple.

## F05 — Raphaëlle est une collègue réelle

```text
fact_id: fact_raphaelle_professional_relationship_exists
source: travail partagé
```

Cette connaissance n’implique aucun accès créatif ou privé.

## F06 — Nico est un ami réel avec son propre monde

```text
fact_id: fact_nico_friendship_exists
source: historique de relation et L’Annexe
```

Cette connaissance n’implique ni confidence ni alibi.

## F07 — Sandra connaît Player d’avant Marie

```text
fact_id: fact_sandra_preexisting_friendship
source: historique canonique
```

Marie peut connaître cette ancienneté sans connaître la proximité privée actuelle.

---

# 3. Faits privés d’ouverture

## F08 — Player a vu la photographie du déjeuner Sandra

```text
fact_id: fact_player_saw_sandra_lunch_photo
source_type: PRIVATE_TRACE
source_ref: j01_sandra_lunch_memory_soft
initial_knowers: [Sandra, Player]
certainty: OBSERVED pour Player, CONFIRMED pour Sandra
shareability: PRIVATE_DO_NOT_SHARE
```

Marie ne connaît pas cette image automatiquement.

## F09 — Mathilde sait que Player l’a remarquée

```text
fact_id: fact_mathilde_knows_player_noticed_her
source_type: DIRECT_MESSAGE
source_ref: j06_mathilde_look_acknowledged_01
initial_knowers: [Mathilde, Player]
certainty: CONFIRMED ou SUSPECTED selon choix
shareability: PRIVATE_DO_NOT_SHARE
```

Ce fait ne signifie pas :

- que Mathilde a choisi l’effet ;
- qu’elle désire Player ;
- qu’elle autorise une répétition.

## F10 — Nico a reçu une confidence de Player

```text
fact_id: fact_nico_received_player_confidence
source_type: DIRECT_MESSAGE
source_ref: j07_nico_confidence_01
initial_knowers: [Nico, Player]
certainty: TOLD_DIRECTLY
shareability: PRIVATE_DO_NOT_SHARE
```

Nico peut parler de sa propre limite.

Il ne peut pas relayer la confidence comme vérité sur une femme.

## F11 — Player a reçu l’image Marie robe noire

```text
fact_id: fact_player_received_marie_black_dress_image
source_type: PRIVATE_TRACE
source_ref: j09_marie_black_dress_private_01
initial_knowers: [Marie, Player]
certainty: OBSERVED
shareability: PRIVATE_DO_NOT_SHARE
```

## F12 — Version publique Marie à La Verrière

```text
fact_id: fact_marie_public_professional_version_visible
source_type: PUBLIC_TRACE
source_ref: j09_marie_laverriere_public_01
initial_knowers: audience sociale de la trace
certainty: OBSERVED ou PUBLIC
shareability: PUBLIC_SOURCE_RULES
```

L’image publique n’explique pas la qualité de présence de Player.

---

# 4. Faits de route J10–J11

## F13 — Mathilde a choisi Player comme audience vestimentaire

```text
fact_id: fact_mathilde_chose_player_as_outfit_audience
source_type: PRIVATE_TRACE
source_ref: j10_mathilde_outfit_choice_01
initial_knowers: [Mathilde, Player]
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE
```

Ce fait ne donne aucun droit d’envoi à Nico.

## F14 — Sandra a choisi une image privée pour Player

```text
fact_id: fact_sandra_chose_private_image_for_player
source_type: PRIVATE_TRACE
source_ref: j11_sandra_chosen_image_01
initial_knowers: [Sandra, Player]
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE
```

Sous-états :

```text
view_only
in_thread_allowed
removed
```

## F15 — Raphaëlle a choisi Player pour une image de résultat

```text
fact_id: fact_raphaelle_chose_player_for_result_image
source_type: PRIVATE_TRACE
source_ref: j11_raphaelle_chosen_result_01
initial_knowers: [Raphaëlle, Maud, Player]
certainty: CONFIRMED
scope: Maud connaît la production et l’envoi seulement si Raphaëlle le lui dit ou si elle participe au transfert
shareability: PRIVATE_DO_NOT_SHARE
```

Maud ne connaît pas automatiquement les messages Player / Raphaëlle.

## F16 — Passage physique Mathilde a eu lieu

```text
fact_id: fact_mathilde_physical_event_occurred
source_type: DIRECT_OBSERVATION
source_ref: événement hors téléphone J11
initial_knowers: [Mathilde, Player]
certainty: OBSERVED
shareability: PRIVATE_DO_NOT_SHARE
```

Marie ne le connaît pas automatiquement.

Le fait crée :

```text
aftercare_mathilde_due
couple_consequence_possible
```

## F17 — Mathilde a refusé ou arrêté

```text
fact_id: fact_mathilde_stop_or_boundary
source_type: DIRECT_MESSAGE ou DIRECT_OBSERVATION
source_ref: scène J11 Mathilde
initial_knowers: [Mathilde, Player]
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE
```

Toute future scène doit respecter ce fait.

---

# 5. Faits de convergence J12

## F18 — Participants réels à La Verrière

```text
fact_id: fact_j12_laverriere_participants
source_type: DIRECT_OBSERVATION / PUBLIC_TRACE
source_ref: j12_laverriere_public_group_set_01
knowers: personnes présentes et audience publique
certainty: OBSERVED
shareability: PUBLIC
```

Le fait contient uniquement les identifiants réellement présents.

Il ne contient aucune route privée.

## F19 — Participants réels à L’Annexe

```text
fact_id: fact_j12_annexe_participants
source_type: DIRECT_OBSERVATION / PUBLIC_TRACE
source_ref: j12_annexe_public_group_set_01
knowers: personnes présentes et audience de la trace
certainty: OBSERVED
shareability: SAME_AUDIENCE_ONLY ou PUBLIC selon canal final
```

## F20 — Comportement inhabituel observé

```text
fact_id: fact_j12_unusual_behavior_observed
source_type: DIRECT_OBSERVATION
source_ref: comportement exact du personnage
certainty: OBSERVED pour le geste, INFERRED pour sa signification
shareability: FACTUAL_ONLY
```

Exemple :

```text
Marie voit Player fermer rapidement un écran.
```

Elle peut savoir que l’écran a été fermé.

Elle ne sait pas pourquoi sans autre source.

## F21 — Sandra a vu le contexte public J12

```text
fact_id: fact_sandra_saw_public_j12_context
source_type: PUBLIC_TRACE
source_ref: j12_sandra_public_context_view_01
initial_knowers: [Sandra]
certainty: OBSERVED
shareability: PUBLIC_SOURCE_RULES
```

Sandra ne déduit pas automatiquement la présence privée d’une autre route.

---

# 6. Faits J13

## F22 — Pauline a créé une double adresse privée

```text
fact_id: fact_pauline_created_private_double_address
source_type: PRIVATE_TRACE
source_ref: j13_pauline_private_version_01
initial_knowers: [Pauline, Player]
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE
```

Bastien ne connaît pas automatiquement cette version.

Marie ne la connaît pas avant une source J14 ou une déclaration.

## F23 — Raphaëlle possède une version privée liée au rôle

```text
fact_id: fact_raphaelle_private_role_version_exists
source_type: PRIVATE_TRACE ou ACCESS_GRANT
source_ref: j13_raphaelle_masked_version_01
initial_knowers: [Raphaëlle, Maud selon production, Player si accès]
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE
```

## F24 — Nico connaît une heure ou une demande d’alibi précise

```text
fact_id: fact_nico_knows_specific_hour_or_alibi_request
source_type: DIRECT_MESSAGE
source_ref: j13_nico_alibi_or_hour_message_01
initial_knowers: [Nico, Player]
certainty: TOLD_DIRECTLY
shareability: FACTUAL_ONLY pour le fait observé ; PRIVATE_DO_NOT_SHARE pour la confidence
```

Deux connaissances doivent être séparées :

```text
Nico connaît l’heure observée.
Nico connaît la version demandée par Player.
```

## F25 — Pauline connaît une fragilité du couple

```text
fact_id: fact_pauline_knows_marie_couple_fragility
initial_state: NOT_CREATED
```

Ce fait ne peut exister que par :

- une déclaration directe de Marie ;
- un message précis dont Pauline est destinataire ;
- une scène sociale où Marie dit un fait borné.

Une simple amitié ne suffit pas.

Tant qu’aucune source n’est consolidée au lot C, le dialogue J19 doit utiliser la version réduite :

```text
Je suis son amie.
Je sais que ce qu’on fait la concerne maintenant.
```

---

# 7. Découverte J14

## F26 — Un témoin a vu une trace limitée

```text
fact_id: fact_witness_saw_limited_trace
source_type: DIRECT_OBSERVATION
source_ref: j14_discovery_event_01
certainty: OBSERVED pour les champs visibles
shareability: FACTUAL_ONLY
```

Instance obligatoire :

```text
witness_id
discovered_trace_id
visible_fields
visible_duration
player_reaction
```

Le témoin connaît seulement :

- les champs réellement visibles ;
- le geste de Player ;
- les mots ensuite reçus.

## F27 — Marie a vu la version privée Pauline

```text
fact_id: fact_marie_saw_pauline_private_version
source_type: DIRECT_OBSERVATION
source_ref: j14_discovery_event_01 + j13_pauline_private_version_01
knower: Marie
certainty: OBSERVED pour l’existence de l’image ; UNKNOWN pour l’intention complète
shareability: OWNER_CONFIRMATION_REQUIRED
```

Marie peut savoir :

- Pauline est représentée ;
- la soirée correspond à J12 ;
- l’image est dans un fil privé ;
- Player a fermé l’écran.

Elle ne sait pas automatiquement :

- la règle de sauvegarde ;
- ce que Bastien sait ;
- ce que Player a répondu ;
- si le compartiment existe déjà.

## F28 — La personne contrôlant la trace a été informée

```text
fact_id: fact_trace_controller_informed_of_audience_breach
source_type: DIRECT_MESSAGE
source_ref: promise j14_inform_trace_controller
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE
```

Si Player refuse, le fait devient :

```text
fact_trace_controller_not_informed
```

et bloque les progressions concernées.

## F29 — Explication de Player au témoin

```text
fact_id: fact_player_explanation_to_witness
source_type: DIRECT_MESSAGE
source_ref: clarification J14
certainty: TOLD_DIRECTLY, pas nécessairement vrai
shareability: FACTUAL_ONLY
```

La vérité réelle et la version donnée restent deux entrées distinctes.

---

# 8. Faits de collision et paiement J15–J16

## F30 — Player a priorisé une obligation

```text
fact_id: fact_player_prioritized_obligation
source_type: DIRECT_OBSERVATION / PROMISE_RECORD
source_ref: j15_obligation_collision_record_01
certainty: CONFIRMED
shareability: FACTUAL_ONLY
```

Paramètres :

```text
chosen_promise_id
failed_or_amended_promise_ids
```

## F31 — Une personne a attendu sans information

```text
fact_id: fact_person_waited_without_information
source_type: PROMISE_RECORD
source_ref: promise FAILED
certainty: CONFIRMED
shareability: FACTUAL_ONLY
```

## F32 — La conséquence prioritaire a été payée

```text
fact_id: fact_priority_consequence_paid
source_type: DIRECT_ACTION
source_ref: j16_consequence_payment_record_01
certainty: CONFIRMED
shareability: FACTUAL_ONLY ou PRIVATE selon scène
```

## F33 — La conséquence prioritaire a été refusée

```text
fact_id: fact_priority_consequence_refused
source_type: DIRECT_MESSAGE / ABSENCE
source_ref: j16_consequence_payment_record_01
certainty: CONFIRMED
shareability: FACTUAL_ONLY
```

---

# 9. Faits de résolution J17–J20

## F34 — État du couple défini

```text
fact_id: fact_couple_state_defined
source_type: DIRECT_STATEMENT + conséquence
source_ref: j17_couple_definition_record_01
initial_knowers: [Marie, Player]
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE par défaut
```

Une personne extérieure ne connaît l’état que si Marie ou Player le lui dit.

## F35 — Mathilde a quitté le foyer

```text
fact_id: fact_mathilde_left_household
source_type: DIRECT_OBSERVATION
source_ref: départ J17
initial_knowers: [Marie, Player, Mathilde]
certainty: OBSERVED
shareability: FACTUAL_ONLY
```

Ce fait ne définit pas la qualité de la relation Mathilde / Player.

## F36 — Sandra a défini ce qu’elle garde

```text
fact_id: fact_sandra_trace_decision_defined
source_type: DIRECT_MESSAGE / DIRECT_ACTION
source_ref: J18
initial_knowers: [Sandra, Player] selon branche
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE
```

Jeff ne connaît que ce que Sandra lui dit.

## F37 — Pauline a défini le compartiment

```text
fact_id: fact_pauline_private_state_defined
source_type: DIRECT_MESSAGE
source_ref: J19
initial_knowers: [Pauline, Player]
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE
```

## F38 — Raphaëlle a défini l’accès futur

```text
fact_id: fact_raphaelle_access_state_defined
source_type: DIRECT_MESSAGE / ACCESS_GRANT
source_ref: j19_raphaelle_creative_access_01
initial_knowers: [Raphaëlle, Player, Maud seulement pour le processus qu’elle partage]
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE
```

## F39 — Nico a défini sa place

```text
fact_id: fact_nico_friendship_position_defined
source_type: DIRECT_MESSAGE
source_ref: J20
initial_knowers: [Nico, Player]
certainty: CONFIRMED
shareability: PRIVATE_DO_NOT_SHARE sauf faits précis
```

## F40 — Un tiers a reçu une heure exacte de Nico

```text
fact_id: fact_third_party_received_exact_hour
source_type: THIRD_PARTY_STATEMENT
source_ref: j20_nico_exact_hour_record_01
knowers: [Nico, tiers demandeur, Player si Nico l’informe]
certainty: CONFIRMED
shareability: FACTUAL_ONLY
```

## F41 — Nico a vu puis supprimé une copie non autorisée

```text
fact_id: fact_nico_saw_then_deleted_unauthorized_trace
source_type: DIRECT_OBSERVATION + DIRECT_ACTION
source_ref: j20_nico_unauthorized_copy_deleted_01
initial_knowers: [Nico, Player, personne représentée après information]
certainty: CONFIRMED
shareability: PROTECTIVE_DISCLOSURE_ONLY
```

---

# 10. Faits de finale J21

## F42 — Trace finale sélectionnée

```text
fact_id: fact_final_trace_selected
source_type: STATE_SELECTION
source_ref: final_trace_id
knower: système narratif ; personnages selon audience de la trace
certainty: CONFIRMED
```

Les personnages ne voient pas le mécanisme de sélection.

## F43 — Posture finale choisie

```text
fact_id: fact_final_posture
values: RULE_ACTED, LOSS_ACKNOWLEDGED, EXISTING_CONTRADICTION_MAINTAINED
source_type: DIRECT_ACTION
certainty: CONFIRMED
```

## F44 — Contradiction existante

```text
fact_id: fact_existing_contradiction
source_ref: existing_contradiction_id
certainty: CONFIRMED dans l’état narratif
```

La posture sombre n’est visible que si F44 existe avant J21.

---

# 11. Matrice de connaissances par personnage

## Marie

Peut connaître directement :

- sa vie de couple ;
- les promesses qui la concernent ;
- les heures et absences observées ;
- les traces publiques ;
- une trace privée vue en J14 ;
- les déclarations Player qu’elle reçoit.

Ne connaît pas automatiquement :

- image Sandra ;
- intention Mathilde ;
- messages Pauline ;
- image Raphaëlle ;
- confidence Nico ;
- décisions Jeff ou Bastien.

## Sandra

Connaît :

- ses propres traces ;
- les messages Player ;
- le contexte public qu’elle voit ;
- ce que Player lui dit du couple.

Ne connaît pas automatiquement :

- vérité du couple ;
- route Mathilde ;
- compartiment Pauline ;
- image Raphaëlle ;
- alibi Nico.

## Mathilde

Connaît :

- son séjour ;
- ses échanges avec Player ;
- les conséquences domestiques observées ;
- les limites ou décisions Marie qu’elle reçoit directement.

Ne connaît pas automatiquement :

- toutes les routes privées ;
- l’état exact du couple après son départ ;
- les images des autres femmes.

## Pauline

Connaît :

- sa surface publique ;
- son compartiment ;
- Bastien ;
- ce que Marie lui a réellement dit ;
- les traces qu’elle contrôle.

Ne connaît pas automatiquement :

- toutes les lignes Player ;
- les confidences Sandra ou Nico ;
- le processus Raphaëlle.

## Raphaëlle

Connaît :

- son travail ;
- son processus ;
- Maud ;
- son image ;
- ce que Player dit de Marie.

Ne suppose jamais que Marie est informée sans source.

## Nico

Connaît :

- ses propres observations ;
- les confidences Player ;
- les heures vécues ;
- les images que l’autrice l’autorise directement à voir.

Ne connaît pas automatiquement :

- les choix des femmes ;
- les messages complets ;
- le couple au-delà des déclarations Player et faits observés.

## Jeff, Bastien, Maud, Élodie

Leur connaissance reste limitée à :

- leur vie ;
- leur partenaire ou travail ;
- les faits publics ;
- les déclarations reçues ;
- les scènes auxquelles ils participent.

Ils ne servent jamais de canal omniscient.

---

# 12. Règles de dialogue

Avant une ligne affirmant un fait, le script doit pouvoir répondre :

```text
Quel knowledge_id autorise cette phrase ?
```

Si aucun identifiant ne l’autorise :

- transformer la phrase en question ;
- la transformer en soupçon ;
- réduire sa portée ;
- ou créer une vraie source antérieure.

Exemple interdit sans source :

```text
Je sais exactement ce que Marie t’a dit.
```

Exemple autorisé :

```text
Je sais qu’elle est concernée.
```

si le personnage connaît le couple et ses propres actes.

---

# 13. Invariants

1. Une trace supprimée ne supprime pas la connaissance.
2. Une déduction n’est jamais enregistrée comme observation.
3. Une déclaration Player peut être fausse ; elle reste `TOLD_DIRECTLY`.
4. La connaissance du couple ne révèle pas son contrat.
5. La connaissance d’une image publique ne révèle pas sa version privée.
6. Un témoin J14 ne lit pas l’historique complet.
7. La personne représentée est informée d’un changement d’audience.
8. Nico partage les faits qu’il a observés, pas les hypothèses de Player.
9. Maud connaît le processus, pas automatiquement le désir.
10. Jeff et Bastien restent capables d’agir sans être rendus omniscients.

---

# 14. Verdict

```text
FAITS DE BRANCHE : IDENTIFIÉS
CERTITUDE : SÉPARÉE DE LA VÉRITÉ
SOURCES : OBLIGATOIRES
OMNISCIENCE : INTERDITE
CONNAISSANCE PAULINE / MARIE : BLOQUÉE SANS SOURCE
J14 : MODÈLE DE DÉCOUVERTE NORMALISÉ
```

> **Une personne peut avoir raison sans savoir. Le registre conserve la différence entre ce qu’elle soupçonne, ce qu’elle a vu et ce qu’on a choisi de lui dire.**
