# Réseau Intime — Registre canonique des promesses J01–J21

## Statut

**Catégorie : Contrat narratif pré-runtime**

**Périmètre : rendez-vous, présences, clarifications et actions futures capables de créer une dette**

Ce document empêche :

- les promesses forcées ;
- les horaires sans statut ;
- les rendez-vous qui disparaissent ;
- les refus qui laissent quand même une personne attendre ;
- les booléens vagues de type `meeting_planned = true` ;
- les collisions J15 construites à partir d’obligations inventées le jour même.

---

# 1. Schéma canonique

Chaque promesse possède :

```text
promise_id
promise_type
created_at
created_by
proposed_to
accepted_at
accepted_by_player
due_at
confirmation_deadline
status
amends
paid_or_closed_at
paid_or_closed_by
related_scene
related_trace_ids
```

## 1.1 Types

```text
PRESENCE
MEETING
TASK
CLARIFICATION
COUPLE_REVIEW
BOUNDARY_REVIEW
DEPARTURE_SUPPORT
```

## 1.2 Statuts

```text
PROPOSED
CONDITIONAL
ACTIVE
AMENDED
PAID
REFUSED
CANCELLED
EXPIRED
FAILED
CLOSED
```

## 1.3 Transitions autorisées

```text
PROPOSED → ACTIVE
PROPOSED → REFUSED
PROPOSED → CONDITIONAL
CONDITIONAL → ACTIVE
CONDITIONAL → EXPIRED
ACTIVE → PAID
ACTIVE → AMENDED
ACTIVE → CANCELLED
ACTIVE → FAILED
AMENDED → ACTIVE
AMENDED → PAID
AMENDED → REFUSED
```

Une promesse `REFUSED`, `EXPIRED`, `CANCELLED` ou `CLOSED` ne redevient pas active sans un nouveau `promise_id`.

---

# 2. Règles générales

1. Une proposition n’est pas une promesse tant que Player ne l’accepte pas.
2. Une réponse guidée unique ne peut pas créer une promesse.
3. Une alternative précise amende l’ancienne promesse ; elle ne garde pas deux horaires actifs.
4. Un refus doit fermer explicitement l’attente.
5. Une personne ne se déplace pas sur une supposition.
6. Toute promesse active apparaît dans la sélection des obligations avant une nouvelle opportunité.
7. J15 utilise uniquement des promesses créées avant J15.
8. Une promesse peut être payée hors téléphone ; son résultat revient après séparation réelle.
9. Une promesse échouée crée une conséquence attribuable à son `promise_id`.
10. Aucun score relationnel ne remplace le statut d’une promesse.

---

# 3. Promesses J01–J06

## P01 — Temps partagé Marie J01

```text
promise_id: marie_j01_shared_evening
promise_type: PRESENCE
created_at: J01 matin ou journée selon script consolidé
created_by: Marie
proposed_to: Player
accepted_at: choix Player J01
accepted_by_player: variable
due_at: J01 soir, horaire précis du script consolidé
confirmation_deadline: avant le départ ou l’achat nécessaire
status: ACTIVE, REFUSED, AMENDED ou PAID
paid_or_closed_by: temps partagé, alternative précise ou refus
related_scene: J01 retour Marie
related_trace_ids: []
```

Un `plus tard` sans heure ne crée pas de promesse.

## P02 — Aide à l’arrivée Mathilde

```text
promise_id: mathilde_j02_arrival_help
promise_type: DEPARTURE_SUPPORT
created_at: J02 urgence
created_by: Marie
proposed_to: Player
accepted_at: choix Player J02
accepted_by_player: variable
due_at: J02 fenêtre d’arrivée
confirmation_deadline: avant le déplacement de Player
status: ACTIVE, REFUSED, PAID ou FAILED
paid_or_closed_by: aide réelle, refus annoncé ou absence non annoncée
related_scene: installation Mathilde
related_trace_ids: [j02_mathilde_arrival_room_01]
```

Le fait que Mathilde arrive dans tous les cas n’efface pas la qualité de participation de Player.

## P03 — Heure Marie J05

```text
promise_id: marie_j05_shared_hour
promise_type: MEETING
created_at: J05
created_by: Marie
proposed_to: Player
accepted_at: choix Player J05
accepted_by_player: variable
due_at: horaire exact choisi J05
confirmation_deadline: avant que Marie bloque son heure
status: ACTIVE, AMENDED, REFUSED, PAID ou FAILED
paid_or_closed_by: heure tenue, alternative tenue, autonomie Marie ou attente déçue
related_scene: J05 Une heure
related_trace_ids: []
```

## P04 — Continuité optionnelle J06

```text
promise_id: j06_external_continuity_window
promise_type: MEETING ou TASK selon personnage
created_at: J05 ou J06 uniquement si explicitement choisi
created_by: personnage concerné
proposed_to: Player
accepted_at: choix réel Player
accepted_by_player: variable
due_at: fenêtre J06 résolue
confirmation_deadline: avant déplacement
status: ACTIVE, REFUSED, EXPIRED, PAID ou FAILED
paid_or_closed_by: variante directe ou fermeture
related_scene: continuité extérieure J06
related_trace_ids: [j06_mathilde_look_acknowledged_01] si Mathilde
```

Cette promesse ne possède :

- aucun ticket ;
- aucune propriétaire automatique ;
- aucun R2 automatique.

---

# 4. Promesses J07–J09

## P05 — Revue mobile Raphaëlle

```text
promise_id: raphaelle_j07_mobile_review
promise_type: TASK
created_at: J07
created_by: Raphaëlle
proposed_to: Player
accepted_at: réponse Player ou obligation professionnelle déjà reconnue
accepted_by_player: variable
due_at: J08 fenêtre professionnelle
confirmation_deadline: avant le début de la revue
status: ACTIVE, AMENDED, REFUSED, PAID ou FAILED
paid_or_closed_by: travail rendu, heure amendée ou refus explicite
related_scene: j07_raphaelle_mobile_review_obligation
related_trace_ids: []
```

## P06 — Chaise Nico mardi 18 h 45

```text
promise_id: nico_j07_tuesday_1845
promise_type: MEETING
created_at: J07 après proposition Nico
created_by: Nico
proposed_to: Player
accepted_at: choix N1 uniquement
accepted_by_player: true seulement pour N1
due_at: J08 mardi 18 h 45
confirmation_deadline: J08 avant que Nico garde la chaise
status: ACTIVE, REFUSED, AMENDED, PAID ou FAILED
paid_or_closed_by: présence, annulation, alternative conditionnelle ou absence
related_scene: j07_nico_quiet_confidence
related_trace_ids: [j07_nico_confidence_01]
```

Choix J07 :

```text
N1 accepter → ACTIVE
N2 jeudi conditionnel → nouvelle promesse nico_j07_thursday_conditional
N3 fermer → REFUSED
```

J08 ne lit P06 que si son statut est `ACTIVE`.

## P07 — Confirmation Nico jeudi conditionnelle

```text
promise_id: nico_j07_thursday_conditional
promise_type: MEETING
created_at: J07 choix N2
created_by: Player
proposed_to: Nico
accepted_at: Nico accepte uniquement une confirmation avant midi
due_at: jeudi avant service, heure à fixer lors de confirmation
confirmation_deadline: jeudi 12 h
status: CONDITIONAL, ACTIVE, EXPIRED, REFUSED ou PAID
paid_or_closed_by: confirmation précise, absence de confirmation ou refus
related_scene: continuation Nico future
related_trace_ids: [j07_nico_confidence_01]
```

Elle ne crée aucune attente mardi.

## P08 — Demande foyer J07

```text
promise_id: marie_j07_household_request
promise_type: TASK ou PRESENCE
created_at: J07
created_by: Marie
proposed_to: Player
accepted_at: choix Player
accepted_by_player: variable
due_at: J08 fenêtre foyer exacte
confirmation_deadline: avant que Marie ou Mathilde organise sans Player
status: ACTIVE, AMENDED, REFUSED, PAID ou FAILED
paid_or_closed_by: action foyer, alternative ou autonomie du foyer
related_scene: j07_marie_household_request
related_trace_ids: []
```

## P09 — Dîner Marie J10

```text
promise_id: marie_j09_dinner_j10_2030
promise_type: MEETING
created_at: J09 retour après La Verrière
created_by: Marie
proposed_to: Player
accepted_at: choix M1 uniquement
accepted_by_player: true seulement pour M1
due_at: J10 jeudi 20 h 30
confirmation_deadline: J10 matin
status: ACTIVE, AMENDED, REFUSED, PAID ou FAILED
paid_or_closed_by: dîner, déplacement vendredi ou refus
related_scene: J09 after separation / J10 priorité couple
related_trace_ids: [j09_marie_laverriere_after_01]
```

## P10 — Dîner Marie vendredi

```text
promise_id: marie_j09_dinner_friday_2030
promise_type: MEETING
created_at: J09 choix M2 ou amendement J10
created_by: Player
proposed_to: Marie
accepted_at: réponse Marie
accepted_by_player: true
due_at: J11 vendredi 20 h 30
confirmation_deadline: J11 avant préparation
status: ACTIVE, REFUSED, PAID ou FAILED
amends: marie_j09_dinner_j10_2030 si créé en J10
paid_or_closed_by: dîner, refus ou absence
related_scene: conséquence couple J11
related_trace_ids: []
```

---

# 5. Promesses J10–J12

## P11 — Café Sandra samedi 11 h

```text
promise_id: sandra_cafe_saturday_1100
promise_type: MEETING
created_at: J10 12 h 24
created_by: Player
proposed_to: Sandra
accepted_at: J11 vendredi avant 18 h puis confirmation Player
accepted_by_player: seulement après confirmation avant J12 9 h 30
due_at: J12 samedi 11 h
confirmation_deadline: J12 9 h 30
status: CONDITIONAL, ACTIVE, REFUSED, EXPIRED ou PAID
paid_or_closed_by: préambule J12, refus ou expiration
related_scene: J12_PRELUDE_SANDRA_CAFE_CONFIRMED
related_trace_ids: [j01_sandra_lunch_memory_soft]
```

Transitions canoniques :

```text
J10 proposition → CONDITIONAL
Sandra ne confirme pas vendredi → EXPIRED
Sandra confirme + Player confirme avant 9 h 30 → ACTIVE
Player refuse → REFUSED
Player ne répond pas avant 9 h 30 → EXPIRED
café tenu → PAID
```

## P12 — Présence La Verrière J12

```text
promise_id: marie_j12_laverriere_presence
promise_type: PRESENCE
created_at: J12 14 h 42
created_by: Marie
proposed_to: Player
accepted_at: choix L-A, L-B ou L-C
accepted_by_player: true
due_at: heure exacte choisie
confirmation_deadline: avant l’heure d’arrivée
status: ACTIVE, PAID ou FAILED
paid_or_closed_by: arrivée et durée réelle
related_scene: S23 La Verrière puis L’Annexe
related_trace_ids: [j12_laverriere_public_group_set_01]
```

Variantes :

```text
L-A → 17 h 45 montage et fermeture
L-B → 19 h 15 événement et fermeture
L-C → 20 h 15–21 h 15 uniquement
```

Une promesse L-C ne crée aucune attente L’Annexe.

## P13 — Continuer à L’Annexe

```text
promise_id: j12_annexe_continuation
promise_type: PRESENCE
created_at: J12 22 h 22
created_by: Nico ou groupe selon branche
proposed_to: Player
accepted_at: choix réel après fermeture La Verrière
accepted_by_player: variable
due_at: J12 22 h 50
confirmation_deadline: avant déplacement du groupe
status: ACTIVE, REFUSED, PAID ou FAILED
paid_or_closed_by: arrivée, refus ou départ du groupe
related_scene: continuation L’Annexe
related_trace_ids: [j12_annexe_public_group_set_01]
```

---

# 6. Promesses J13–J16

## P14 — Clarification J14

```text
promise_id: j14_witness_clarification
promise_type: CLARIFICATION
created_at: J14 choix D-C uniquement
created_by: Player
proposed_to: témoin J14
accepted_at: témoin accepte l’heure proposée
accepted_by_player: true
due_at: heure précise dans la même journée ou J15 au plus tard
confirmation_deadline: immédiate
status: ACTIVE, AMENDED, PAID, FAILED ou CANCELLED
paid_or_closed_by: vérité limitée, aveu du report ou refus du témoin
related_scene: S27 photo au mauvais écran
related_trace_ids: [j14_discovery_event_01]
```

Une clarification sans heure ne crée pas une promesse valide.

## P15 — Information de la personne représentée

```text
promise_id: j14_inform_trace_controller
promise_type: CLARIFICATION
created_at: J14 dès qu’une audience privée est compromise
created_by: responsabilité narrative
proposed_to: Player
accepted_at: obligatoire, pas un choix de route
accepted_by_player: action attendue
due_at: avant toute nouvelle progression et avant J15
confirmation_deadline: immédiate ou heure pratique la plus proche
status: ACTIVE, PAID ou FAILED
paid_or_closed_by: message factuel à la personne représentée
related_scene: conséquence audience J14
related_trace_ids: [trace réellement vue]
```

Le joueur peut refuser de payer ; cela produit `FAILED` et bloque la progression.

## P16 — Engagements incompatibles J15

J15 ne crée pas une promesse générique.

Il référence deux ou plusieurs `promise_id` antérieurs dont :

```text
status = ACTIVE
fenêtres temporelles incompatibles
```

Le record J15 contient :

```text
collision_id
active_promise_ids
chosen_priority
amended_promise_ids
failed_promise_ids
```

## P17 — Paiement prioritaire J16

```text
promise_id: j16_priority_consequence_payment
promise_type: CLARIFICATION ou TASK
created_at: J15 fin de collision
created_by: personne lésée ou conséquence
proposed_to: Player
accepted_at: choix J16
accepted_by_player: variable
due_at: J16 fenêtre précise
confirmation_deadline: avant toute nouvelle opportunité
status: ACTIVE, AMENDED, REFUSED, PAID ou FAILED
paid_or_closed_by: action de réparation, vérité limitée ou retrait
related_scene: paiement J16
related_trace_ids: [j15_obligation_collision_record_01, j16_consequence_payment_record_01]
```

## P18 — Conversation Marie J17

```text
promise_id: marie_j16_couple_conversation_j17
promise_type: CLARIFICATION
created_at: J16
created_by: Marie et Player selon choix
proposed_to: Player
accepted_at: heure choisie ou refusée
due_at: J17 jeudi 20 h 30 si acceptée
confirmation_deadline: J17 19 h 12
status: ACTIVE, AMENDED, REFUSED, PAID ou FAILED
paid_or_closed_by: conversation hors téléphone, définition unilatérale ou déplacement unique
related_scene: définition couple J17
related_trace_ids: [j17_couple_definition_record_01]
```

---

# 7. Promesses de résolution J17–J21

## P19 — Point de contrôle du couple

```text
promise_id: couple_review_due_at
promise_type: COUPLE_REVIEW
created_at: J17 accord provisoire ou reconfiguration
created_by: Marie et Player
proposed_to: [Marie, Player]
accepted_at: J17
accepted_by_player: true pour les sorties concernées
due_at: jeudi suivant J21, 20 h 30
confirmation_deadline: mercredi précédent 20 h ou règle future explicite
status: ACTIVE, AMENDED, PAID, REFUSED ou FAILED
paid_or_closed_by: extension future, hors saison 1
related_scene: extension saison suivante
related_trace_ids: [j17_couple_definition_record_01]
```

J20 et J21 peuvent la rappeler.

Ils ne la paient pas.

## P20 — Journée partagée future Marie

```text
promise_id: couple_shared_day_due_at
promise_type: MEETING
created_at: J17 proposition C17-A2
created_by: Player
proposed_to: Marie
accepted_at: conditionnellement après le point P19
accepted_by_player: true
status: CONDITIONAL
possible_due_at: dimanche suivant le point P19
confirmation_deadline: pendant P19
paid_or_closed_by: extension future
related_scene: future reconquête
related_trace_ids: []
```

Cette promesse n’est jamais active pendant J18–J21.

## P21 — Café futur Sandra

```text
promise_id: sandra_future_cafe_after_j18
promise_type: MEETING
created_at: J18 seulement si Sandra propose ou accepte une heure précise
created_by: Sandra ou Player
proposed_to: autre partie
accepted_at: réponse explicite
due_at: date et heure exactes après J21
confirmation_deadline: avant déplacement
status: ACTIVE, CONDITIONAL, REFUSED ou CLOSED
paid_or_closed_by: extension future
related_scene: continuation Sandra
related_trace_ids: [j01_sandra_lunch_memory_soft, j18_sandra_lunch_print_01]
```

Un simple :

```text
on se revoit
```

ne crée pas P21.

## P22 — Atelier Raphaëlle

```text
promise_id: raphaelle_future_atelier_saturday_1500
promise_type: MEETING
created_at: J19
created_by: Raphaëlle
proposed_to: Player
accepted_at: choix réel Player
due_at: samedi suivant, 15 h–17 h
confirmation_deadline: avant le vendredi précédent
status: ACTIVE, REFUSED, AMENDED ou CLOSED
paid_or_closed_by: extension future
related_scene: atelier Raphaëlle / Maud
related_trace_ids: [j19_raphaelle_creative_access_01]
```

La présence de Maud la première heure fait partie du cadre de P22.

## P23 — Rencontre Nico L’Annexe J20

```text
promise_id: nico_j20_lannexe_2120
promise_type: MEETING
created_at: J20 18 h 57
created_by: Nico
proposed_to: Player
accepted_at: choix Player
due_at: J20 21 h 20
confirmation_deadline: avant fermeture de L’Annexe
status: ACTIVE, REFUSED, PAID ou CANCELLED
paid_or_closed_by: rencontre hors téléphone ou refus
related_scene: résolution Nico
related_trace_ids: [j20_nico_exact_hour_record_01]
```

Refuser P23 ne dégrade pas automatiquement l’amitié.

## P24 — Récupération des cartons

```text
promise_id: marie_player_boxes_wednesday_1830
promise_type: MEETING
created_at: J21 branche séparation
created_by: Marie
proposed_to: Player
accepted_at: Player accepte ou amende immédiatement
due_at: mercredi après J21, 18 h 30
confirmation_deadline: mardi soir
status: ACTIVE, AMENDED ou REFUSED
paid_or_closed_by: extension pratique future
related_scene: organisation de séparation
related_trace_ids: []
```

---

# 8. Obligations non promesses

Les éléments suivants ne sont pas des promesses :

- un désir ;
- une image consultable ;
- une invitation non acceptée ;
- un `peut-être` sans deadline ;
- un personnage qui espère une réponse ;
- une route éligible ;
- un aftercare obligatoire créé par un événement déjà réalisé.

L’aftercare utilise un `obligation_id` dans le contrat d’état, pas une proposition facultative.

---

# 9. Sélection des obligations quotidiennes

Avant chaque pivot :

```text
1. promise ACTIVE dont due_at est aujourd’hui
2. obligation de sécurité ou aftercare due
3. promise ACTIVE avec confirmation_deadline aujourd’hui
4. opportunité de route
5. respiration
```

En cas de plusieurs promesses actives :

```text
sécurité
→ heure la plus ancienne
→ promesse déjà amendée une fois
→ personne ayant déjà attendu
→ ordre authored
```

Aucun score caché ne remplace cet ordre.

---

# 10. Invariants

1. Une promesse active possède une date ou une fenêtre précise.
2. Une promesse amendée ferme l’ancienne heure.
3. Une personne ne reste pas en attente après un refus explicite.
4. Une promesse expirée ne déclenche aucune scène de reproche automatique sans comportement attribuable.
5. J15 ne fabrique pas d’obligation.
6. J16 paie une conséquence avant toute nouvelle progression.
7. Une rencontre hors téléphone arrête le chat.
8. Les promesses futures post-J21 restent des hooks préparés, pas des scènes déjà gagnées.
9. Le couple ne promet personne extérieure.
10. La séparation ne transforme pas une invitation extérieure conditionnelle en promesse active.

---

# 11. Legacy et migration

Les anciens concepts :

```text
ticket
external_ticket_limit
wave owner
candidate pool
```

ne représentent pas des promesses.

Ils ne doivent pas être utilisés pour décider qui attend Player.

Le runtime futur devra stocker une petite collection de promesses structurées, pas une multitude de flags :

```text
active_promises: Array[PromiseState]
```

Le détail technique sera défini seulement après validation narrative.

---

# 12. Verdict

```text
PROMESSES PRINCIPALES : IDENTIFIÉES
PROMESSES FORCÉES : EXCLUES
ALTERNATIVES : TRAITÉES COMME AMENDEMENTS
REFUS : FERMENT L’ATTENTE
PROMESSE SANDRA J10 : PAYABLE EN J12
CHECKPOINT COUPLE : POSTÉRIEUR À J21
```

> **Une promesse n’est pas une ligne séduisante dans un fil. C’est une personne qui a commencé à organiser sa vie autour d’une réponse précise.**
