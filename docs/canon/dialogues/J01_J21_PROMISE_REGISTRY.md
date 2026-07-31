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
activated_at si activation différée
created_by
proposed_to
accepted_at
accepted_by_player
action_due
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
CONDITIONAL → REFUSED
ACTIVE → PAID
ACTIVE → AMENDED
ACTIVE → CANCELLED
ACTIVE → FAILED
ACTIVE → CLOSED
AMENDED → ACTIVE
AMENDED → PAID
AMENDED → REFUSED
AMENDED → CANCELLED
AMENDED → CLOSED
FAILED → CLOSED
```

Une promesse dont le statut est `PAID`, `REFUSED`, `FAILED`, `EXPIRED`, `CANCELLED` ou `CLOSED` ne redevient jamais `ACTIVE` avec le même `promise_id`.

Toute nouvelle proposition exige :

```text
une source signée nouvelle
+ une action future précise
+ une acceptation attribuable
+ un nouveau promise_id
```

Une phrase de disponibilité, une attirance, une photographie, une notification ou un silence ne constituent jamais une promesse.

---

# 2. Règles générales

1. Une proposition n’est pas une promesse tant que Player ne l’accepte pas.
2. Une réponse guidée unique ne peut pas créer une promesse.
3. Une alternative précise amende l’ancienne promesse ; elle ne garde pas deux horaires actifs.
4. Un refus doit fermer explicitement l’attente.
5. Une personne ne se déplace pas sur une supposition.
6. Toute promesse active apparaît dans la sélection des obligations avant une nouvelle opportunité.
7. J15 utilise uniquement des promesses dont la responsabilité est créée avant J15 et dont l’activation est attribuable.
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

Transitions J10 signées :

```text
J10 11:43, Player confirme « oui. 18 h 20 »
→ CONDITIONAL → ACTIVE
→ activated_at = J10 11:43
→ accepted_at = J10 11:43
→ due_at = J10 18:20

J10 11:43, Player refuse
→ CONDITIONAL → REFUSED
→ paid_or_closed_at = J10 11:43
→ paid_or_closed_by = Player
→ due_at reste vide

J10 12:00, aucune confirmation attribuable
→ CONDITIONAL → EXPIRED
```

L’échange de 18 h 12 maintient ou annule une promesse déjà `ACTIVE`.

Il ne peut jamais activer P07 après son `confirmation_deadline`.

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
created_at: J14 choix D-C uniquement, à l’instant où une heure précise est proposée
created_by: Player
proposed_to: témoin J14
accepted_at: lorsque le témoin accepte l’heure précise
accepted_by_player: true
action_due: clarification exacte promise au témoin
due_at: heure précise dans la même journée ou J15 au plus tard
confirmation_deadline: immédiate
status: ACTIVE, AMENDED, PAID, FAILED ou CANCELLED
paid_or_closed_at: null tant que la clarification reste due ; horodatage obligatoire à la sortie
paid_or_closed_by: clarification tenue, amendement accepté, échec attribuable ou annulation du témoin
related_scene: S27 photo au mauvais écran
related_trace_ids: [j14_discovery_event_01]
```

P14 est créée seulement par D-C avec heure précise acceptée.

Transitions :

```text
ACTIVE → PAID | AMENDED | FAILED | CANCELLED
AMENDED → ACTIVE | PAID | FAILED | CANCELLED
```

Une vérité limitée immédiatement donnée ne crée jamais P14.

P14 reste `ACTIVE` uniquement tant que la clarification exacte reste réellement due.

Avant toute nouvelle fiche Marie, comparer `action_due` :

```text
P14 ACTIVE + même action_due
→ utiliser P14
→ aucune nouvelle fiche

P14 PAID | FAILED | CANCELLED + même action_due
→ respecter la terminalité
→ aucune recréation sous un nouveau promise_id
```

## P15 — Information de la personne représentée

```text
promise_id: j14_inform_trace_controller
promise_type: CLARIFICATION
created_at: J14 dès qu’une audience privée est compromise
created_by: responsabilité narrative
proposed_to: Player
accepted_at: obligatoire par responsabilité signée
accepted_by_player: action attribuable à Player
due_at: J14, heure pratique la plus proche
confirmation_deadline: avant toute nouvelle progression et avant J15
status: ACTIVE, PAID ou FAILED
paid_or_closed_at: null à la création ; horodatage J14 obligatoire à la sortie
paid_or_closed_by: message factuel à la personne représentée, ou refus/omission attribuable
related_scene: conséquence audience J14
related_trace_ids: [trace réellement vue]
```

Transitions :

```text
ACTIVE → PAID | FAILED
FAILED → CLOSED
```

Si la personne représentée est informée en J14, P15 devient `PAID`.

P15 ne reste jamais artificiellement `ACTIVE` jusqu’à J15.

Un compte rendu, une confirmation d’audience ou une réponse ultérieure reçoit un `promise_id` distinct parmi les sept entrées NAR-CANON-01.

## NAR-CANON-01 — Sept promesses conditionnelles J14→J15

Les sept entrées suivantes n’existent que si leur source signée s’est réellement produite.

Une entrée absente n’est jamais simulée par un objet `ACTIVE`.

### `marie_j14_pauline_player_account_j15`

```text
promise_id: marie_j14_pauline_player_account_j15
promise_type: COUPLE_REVIEW
created_at: sortie Pauline J14 laissant la conversation Marie due
activated_at: J15 08:09 après proposition de la fenêtre Marie et acceptation explicite de Player
created_by: Marie
proposed_to: Player
accepted_at: J15 08:09, branche d’acceptation
accepted_by_player: true uniquement pour une acceptation explicite telle que « oui. 19 h »
action_due: répondre à Marie sur ce que Player a accepté
due_at: J15 19:00–20:00, ou heure J14 précise reprise
confirmation_deadline: J15 08:09
status: CONDITIONAL
activation_rule: CONDITIONAL → ACTIVE uniquement à activated_at
transitions autorisées: CONDITIONAL → ACTIVE | REFUSED | EXPIRED ; ACTIVE → PAID | AMENDED | CANCELLED | FAILED | CLOSED ; AMENDED → ACTIVE | PAID | REFUSED | CANCELLED | CLOSED
paid_or_closed_at: null à la création ; obligatoire à la sortie
paid_or_closed_by: Marie et Player par présence, amendement, refus, annulation ou échec
related_scene: J14 Pauline / J15 §§10.2–10.8
related_trace_ids: [j14_discovery_event_01, j13_pauline_private_version_01]
source signée exacte: J14 §10 « conversation couple J15 due » ; J15 §10.3 « Hier, tu as dit mardi », « J’ai 19 h à 20 h », Player « oui. 19 h »
branche: Pauline
collision possible avec: pauline_j14_post_breach_return_j15
condition d’absence: variante Pauline absente, conversation déjà payée, heure refusée, ou P14 couvrant exactement la même action_due
condition de fermeture: présence, amendement accepté, refus avant attente, annulation ou échec attribuable
```

### `pauline_j14_post_breach_return_j15`

```text
promise_id: pauline_j14_post_breach_return_j15
promise_type: CLARIFICATION
created_at: J14 après compromission, information de Pauline et naissance d’une responsabilité distincte de retour
activated_at: J15 lorsque Pauline formule la demande précise et que Player accepte le retour avant la collision
created_by: responsabilité distincte envers Pauline née en J14
proposed_to: Player
accepted_at: avant collision lorsque le retour est réellement accepté
accepted_by_player: true uniquement si l’acceptation est enregistrée
action_due: dire à Pauline ce qui a réellement été expliqué avant sa décision
due_at: après l’échange Marie et avant J15 19:25
confirmation_deadline: avant sélection S28, au plus tard J15 18:42
status: CONDITIONAL
activation_rule: CONDITIONAL → ACTIVE uniquement à activated_at
transitions autorisées: CONDITIONAL → ACTIVE | REFUSED | EXPIRED ; ACTIVE → PAID | AMENDED | CANCELLED | FAILED | CLOSED ; AMENDED → ACTIVE | PAID | REFUSED | CANCELLED | CLOSED
paid_or_closed_at: null à la création ; obligatoire à la sortie
paid_or_closed_by: Pauline par décision autonome, ou Player par compte rendu, refus ou échec
related_scene: J14 Pauline / J15 §§10.4–10.8
related_trace_ids: [j14_discovery_event_01, j13_pauline_private_version_01]
source signée exacte: J14 §§21/25/26, compromission, information de Pauline et responsabilité distincte laissée ouverte ; J15 §10.4 « Je veux savoir avant ce que tu auras réellement dit à Marie », « À 19 h 25, je décide sans toi » ; J15 §10.6 « j’ai accepté ton heure entière et son retour après »
branche: Pauline
collision possible avec: marie_j14_pauline_player_account_j15
condition d’absence: P15 non PAID, aucune responsabilité distincte laissée par J14, aucun retour demandé, retour refusé, attente déjà fermée
condition de fermeture: compte rendu exact, refus avant attente, décision autonome Pauline, compartiment fermé
```

### `household_j14_sandra_rule_j15`

```text
promise_id: household_j14_sandra_rule_j15
promise_type: BOUNDARY_REVIEW
created_at: J14 S14-C lorsque Player promet de répondre sur l’appartement et Marie
activated_at: J15 08:20 lorsque la règle reste due et que la fenêtre est explicitement résolue
created_by: Player envers Mathilde et le foyer
proposed_to: Mathilde, Marie concernée
accepted_at: J14 S14-C
accepted_by_player: true uniquement par l’acte signé ou par responsabilité attribuable confirmée
action_due: fixer la règle du foyer avec Mathilde et/ou Marie
due_at: J15 19:00–19:15
confirmation_deadline: J15 08:20
status: CONDITIONAL
activation_rule: CONDITIONAL → ACTIVE uniquement à activated_at
transitions autorisées: CONDITIONAL → ACTIVE | EXPIRED | REFUSED ; ACTIVE → PAID | AMENDED | CANCELLED | FAILED | CLOSED ; AMENDED → ACTIVE | PAID | REFUSED | CANCELLED | CLOSED
paid_or_closed_at: null à la création ; obligatoire à la sortie
paid_or_closed_by: Mathilde/Marie par règle du foyer, ou Player par réponse, refus, amendement ou échec
related_scene: J14 Sandra / J15 §§11.2–11.8
related_trace_ids: [j14_discovery_event_01, j11_sandra_chosen_image_01]
source signée exacte: J14 S14-C « après, je te réponds sur ce que ça change dans l’appartement et avec Marie » ; J15 §11.3 « À 19 h, je veux qu’on sache au moins si je vis ici en couvrant quelque chose ou non », « Je demande la règle »
branche: Sandra
collision possible avec: sandra_j14_breach_account_j15
condition d’absence: Mathilde non témoin, aucune règle due, réponse déjà payée, attente fermée
condition de fermeture: règle donnée, amendement accepté, refus/exclusion acté, foyer réorganisé sans Player
```

### `sandra_j14_breach_account_j15`

```text
promise_id: sandra_j14_breach_account_j15
promise_type: CLARIFICATION
created_at: J14 après compromission, information de Sandra et naissance d’une responsabilité distincte de compte rendu
activated_at: J15 13:08–13:09 lorsque Sandra formule la demande précise et que la fenêtre est confirmée
created_by: responsabilité d’audience signée, précisée par Sandra
proposed_to: Player
accepted_at: J14 par responsabilité ; fenêtre confirmée J15 13:08
accepted_by_player: true uniquement si la compromission est attribuable et si le retour reste dû
action_due: dire à Sandra exactement ce qui a été vu, dit et éventuellement transmis
due_at: J15 19:00–19:15
confirmation_deadline: J15 13:09
status: CONDITIONAL
activation_rule: CONDITIONAL → ACTIVE uniquement à activated_at
transitions autorisées: CONDITIONAL → ACTIVE | EXPIRED | REFUSED ; ACTIVE → PAID | AMENDED | CANCELLED | FAILED | CLOSED ; AMENDED → ACTIVE | PAID | REFUSED | CANCELLED | CLOSED
paid_or_closed_at: null à la création ; obligatoire à la sortie
paid_or_closed_by: Sandra par retrait/fermeture, ou Player par compte rendu, refus ou échec
related_scene: J14 §§21/25/26 Sandra / J15 §§11.4–11.8
related_trace_ids: [j14_discovery_event_01, j11_sandra_chosen_image_01]
source signée exacte: J14 §21 Sandra doit savoir ce que Player a dit ; J14 §25 « vérité à donner en J15 » ; J15 §11.4 « j’ai besoin de savoir qui sait quoi », « Entre 19 h et 19 h 15 »
branche: Sandra
collision possible avec: household_j14_sandra_rule_j15
condition d’absence: aucune compromission Sandra, P15 non PAID, aucune responsabilité distincte laissée par J14, faits déjà rendus, retrait avec fermeture
condition de fermeture: compte rendu payé, refus annoncé, retrait/fermeture Sandra, échec attribuable
```

### `mathilde_j14_household_safety_rule_j15`

```text
promise_id: mathilde_j14_household_safety_rule_j15
promise_type: BOUNDARY_REVIEW
created_at: J14 lorsqu’une règle de sécurité, distance ou foyer est signée
activated_at: J15 08:05 lorsque la règle reste due et que sa fenêtre exacte est confirmée
created_by: Mathilde ou Marie
proposed_to: Player
accepted_at: J14 par acceptation ou responsabilité signée
accepted_by_player: true uniquement par acceptation explicite ou responsabilité attribuable
action_due: garantir la sécurité, la distance ou la règle du foyer
due_at: J15 18:00–20:00 pour sécurité, ou 18:30–19:15 pour entretien séparé
confirmation_deadline: J15 08:05
status: CONDITIONAL
activation_rule: CONDITIONAL → ACTIVE uniquement à activated_at
transitions autorisées: CONDITIONAL → ACTIVE | EXPIRED | REFUSED ; ACTIVE → PAID | AMENDED | CANCELLED | FAILED | CLOSED ; AMENDED → ACTIVE | PAID | REFUSED | CANCELLED | CLOSED
paid_or_closed_at: null à la création ; obligatoire à la sortie
paid_or_closed_by: Mathilde/Marie par règle et organisation, ou Player par respect, refus, contestation ou violation
related_scene: J14 Mathilde / J15 §§12–14
related_trace_ids: [j14_discovery_event_01, j10_mathilde_outfit_choice_01, j11_mathilde_physical_aftercare_01]
source signée exacte: J14 M14-A « Tu ne restes pas seul avec elle ce soir » ; J14 M14-C « la phrase concerne une limite dans le foyer » ; J15 §12.3 « Mathilde veut me parler seule de 18 h 30 à 19 h 15 » ou « Tu ne rentres pas pendant cette fenêtre »
branche: Mathilde
collision possible avec: un autre promise_id antérieur, distinct, réellement signé et ACTIVE ; aucun exemple automatique
condition d’absence: aucune règle, règle déjà payée/fermée, source non attribuable
condition de fermeture: sécurité/distance respectée, entretien accompli, foyer réorganisé, refus/violation enregistré
```

### `marie_j14_raphaelle_position_j15`

```text
promise_id: marie_j14_raphaelle_position_j15
promise_type: COUPLE_REVIEW
created_at: sortie Raphaëlle J14 laissant la place réelle de Player à clarifier auprès de Marie
activated_at: J15 08:28 après proposition de la fenêtre Marie et acceptation explicite de Player
created_by: Marie
proposed_to: Player
accepted_at: J15 après 08:28, branche d’acceptation
accepted_by_player: true uniquement si Player accepte la fenêtre
action_due: répondre à Marie sur la place réelle de Player
due_at: J15 19:45–20:30
confirmation_deadline: J15 08:28
status: CONDITIONAL
activation_rule: CONDITIONAL → ACTIVE uniquement à activated_at
transitions autorisées: CONDITIONAL → ACTIVE | REFUSED | EXPIRED ; ACTIVE → PAID | AMENDED | CANCELLED | FAILED | CLOSED ; AMENDED → ACTIVE | PAID | REFUSED | CANCELLED | CLOSED
paid_or_closed_at: null à la création ; obligatoire à la sortie
paid_or_closed_by: Marie et Player par présence, refus, amendement ou échec
related_scene: J14 Raphaëlle / J15 §§15.2–15.8
related_trace_ids: [j14_discovery_event_01, j13_raphaelle_masked_version_01, j11_raphaelle_chosen_result_01]
source signée exacte: J14 R14-C « à 22 h je te réponds sur ma place dans cette histoire » si encore due ; J15 §15.3 « Hier tu as dit mardi », « J’ai 19 h 45 à 20 h 30 », acceptation réelle
branche: Raphaëlle
collision possible avec: uniquement un autre promise_id antérieur, distinct, réellement signé et ACTIVE
condition d’absence: aucune découverte, clarification déjà payée, heure refusée, ou P14 couvrant exactement la même action_due
condition de fermeture: présence/réponse, refus avant attente, amendement, annulation ou échec
```

Aucune seconde obligation professionnelle Raphaëlle/Maud n’est enregistrée : aucune source signée antérieure exacte ne la crée.

### `marie_j14_nico_hour_account_j15`

```text
promise_id: marie_j14_nico_hour_account_j15
promise_type: COUPLE_REVIEW
created_at: sortie Nico J14 laissant l’heure réelle ou la vérité couple due
activated_at: J15 08:12 après proposition de la fenêtre Marie et acceptation explicite de Player
created_by: Marie
proposed_to: Player
accepted_at: J15 08:12 dans la branche d’acceptation
accepted_by_player: true uniquement après acceptation explicite
action_due: donner à Marie l’heure réelle et expliquer l’écart
due_at: J15 18:45–19:30
confirmation_deadline: J15 08:12
status: CONDITIONAL
activation_rule: CONDITIONAL → ACTIVE uniquement à activated_at
transitions autorisées: CONDITIONAL → ACTIVE | REFUSED | EXPIRED ; ACTIVE → PAID | AMENDED | CANCELLED | FAILED | CLOSED ; AMENDED → ACTIVE | PAID | REFUSED | CANCELLED | CLOSED
paid_or_closed_at: null à la création ; obligatoire à la sortie
paid_or_closed_by: Marie/Player par vérité, refus, amendement ou échec ; Nico fournit éventuellement le fait sans devenir créancier
related_scene: J14 Nico / J15 §§16.1–16.6
related_trace_ids: [j14_discovery_event_01, j13_nico_alibi_or_hour_message_01]
source signée exacte: J14 N14-A « conversation couple due » si encore impayée ; J15 §16.2 « Je veux l’heure réelle ce soir », « 18 h 45 à 19 h 30 », acceptation réelle
branche: Nico
collision possible avec: uniquement un second promise_id antérieur distinct, signé, accepté et incompatible
condition d’absence: vérité donnée immédiatement en N14-A/N14-C, heure non due, fenêtre refusée, ou P14 couvrant exactement la même action_due
condition de fermeture: heure donnée, refus avant attente, fait fourni par Nico, conséquence de mensonge transmise
```

## P16 — Validation des engagements J15

J15 ne crée pas une promesse générique.

Une collision complète référence exactement deux fiches admissibles possédant chacune :

```text
promise_id distinct
status = ACTIVE
created_at = source signée J14
activated_at < début de la collision J15
source signée exacte
personne concernée
action_due distincte
due_at ou fenêtre exacte
accepted_by_player attribuable
paid_or_closed_at = null
```

Les deux fenêtres doivent être objectivement incompatibles.

Deux formulations de la même action ne comptent pas comme deux promesses.

Une promesse `PAID`, `REFUSED`, `FAILED`, `EXPIRED`, `CANCELLED` ou `CLOSED` est inadmissible.

Lorsque le validateur échoue :

```text
sequence_id: S28_MUTATION_NO_COLLISION
```

La mutation paie, amende, refuse ou ferme l’unique obligation réelle. Elle ne crée aucune seconde obligation.

Le record J15 contient :

```text
collision_id
collision_mode: FULL_COLLISION | NO_COLLISION
eligible_active_promise_ids
chosen_priority
amended_promise_ids
failed_promise_ids
closed_promise_ids
urgent_consequence_remaining
```

## P17 — Paiement prioritaire J16

```text
promise_id: j16_priority_consequence_payment
promise_type: CLARIFICATION ou TASK
created_at: fin J15 uniquement si une conséquence réelle reste due
created_by: personne lésée ou conséquence
proposed_to: Player
accepted_at: choix J16
accepted_by_player: variable
due_at: J16 fenêtre précise
confirmation_deadline: avant toute nouvelle opportunité
status: ACTIVE, AMENDED, REFUSED, PAID ou FAILED
paid_or_closed_at: null à la création ; obligatoire à la sortie
paid_or_closed_by: action de réparation, vérité limitée, retrait, refus ou échec
related_scene: paiement J16
related_trace_ids: [j15_obligation_collision_record_01, j16_consequence_payment_record_01]
```

P17 est créée après une collision complète ou `S28_MUTATION_NO_COLLISION` seulement si :

- une obligation a échoué ;
- une obligation a été refusée avec conséquence signée ;
- une obligation reste impayée ;
- un mensonge ou une violation laisse une action de réparation précise.

P17 n’est pas créée si l’unique obligation a été proprement `PAID`, `CANCELLED` ou `CLOSED` et qu’aucune dette urgente ne subsiste.

Dans ce cas, J16 utilise sa priorité 8 : fermeture propre.

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
1. obligation de sécurité ou audience due
2. promise ACTIVE dont due_at est aujourd’hui
3. promise ACTIVE avec confirmation_deadline aujourd’hui
4. conséquence réelle restante
5. opportunité de route
6. respiration
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
6. J15 complet exige deux fiches actives, deux actions distinctes et deux fenêtres incompatibles.
7. `S28_MUTATION_NO_COLLISION` ne crée aucune dette compensatoire.
8. J16 paie une conséquence avant toute nouvelle progression.
9. P17 est absente après paiement ou fermeture propre sans urgence.
10. Une rencontre hors téléphone arrête le chat.
11. Les promesses futures post-J21 restent des hooks préparés, pas des scènes déjà gagnées.
12. Le couple ne promet personne extérieure.
13. La séparation ne transforme pas une invitation extérieure conditionnelle en promesse active.

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
SEPT PROMESSES J14→J15 : CONTRACTUALISÉES
S28 COMPLET : DEUX FICHES PROUVÉES REQUISES
S28 SANS DEUX FICHES : MUTATION NO_COLLISION
P17 : CONDITIONNELLE À UNE CONSÉQUENCE RÉELLE
CHECKPOINT COUPLE : POSTÉRIEUR À J21
```

> **Une promesse n’est pas une ligne séduisante dans un fil. C’est une personne qui a commencé à organiser sa vie autour d’une réponse précise.**
