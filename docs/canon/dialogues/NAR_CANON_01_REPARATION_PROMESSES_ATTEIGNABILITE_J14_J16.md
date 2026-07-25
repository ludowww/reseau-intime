# NAR-CANON-01 — Réparation des promesses et de l’atteignabilité J14→J16

## 1. Statut, périmètre et autorités

```text
document_id: NAR-CANON-01
document_name: NAR_CANON_01_REPARATION_PROMESSES_ATTEIGNABILITE_J14_J16.md
baseline: 5adad5cca6f5dcc793f9824b49abf0fcd43dcdbf
category: correctif canonique documentaire pré-runtime
scope: J14 → J15 → J16
verdict: READY_WITH_REGISTRY_PATCH
VALIDATION PRODUIT: PASS
```

Ce correctif répare le contrat des promesses, l’atteignabilité de S28 et le passage vers J16. Il ne réécrit aucun dialogue signé et ne crée aucun rendez-vous, retour, alibi, contenu visuel, route ou progression adulte.

Sources autoritatives :

- `J14_SCRIPT_NARRATIF_COMPLET.md` ;
- `J15_SCRIPT_NARRATIF_COMPLET.md` ;
- `J16_SCRIPT_NARRATIF_COMPLET.md` ;
- `J01_J21_PROMISE_REGISTRY.md` ;
- `J01_J21_REACHABILITY_MATRIX.md` ;
- `SEASON_1_NARRATIVE_STATE_CONTRACT.md`.

Fichiers canoniques corrigés par ce lot :

1. `docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md` ;
2. `docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md` ;
3. `docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md`.

Les scripts J14, J15 et J16 restent inchangés.

---

## 2. Diagnostic

À la baseline, J14 et J15 décrivent des actions dues précises, mais le registre ne fournit que :

- P14 `j14_witness_clarification` ;
- P15 `j14_inform_trace_controller`.

P14 n’existe que pour D-C avec heure précise. P15 est immédiate et doit être `PAID` ou `FAILED` avant J15. Les retours ultérieurs ne sont pas P15. Les promesses P01–P13 terminales ne peuvent pas être réactivées.

Sans correctif, S28 pourrait :

- réactiver une promesse terminée ;
- créer la seconde obligation le mardi ;
- compter deux formulations de la même action ;
- confondre une notification avec une promesse ;
- transmettre une fausse dette à J16.

Le correctif impose donc deux fiches admissibles pour `FULL_COLLISION` et définit `S28_MUTATION_NO_COLLISION` lorsque cette preuve manque.

---

## 3. Décisions verrouillées

1. Exactement sept nouvelles promesses conditionnelles.
2. Aucune huitième entrée de remplacement.
3. `created_at` provient de J14 ; `activated_at` correspond à la confirmation J15.
4. Une attente, une disponibilité, une attirance, une image, une notification ou un silence ne crée aucune promesse.
5. P14 ne naît que de D-C avec heure précise acceptée.
6. P15 est immédiate et terminée en J14.
7. P01–P13 terminales ne redeviennent jamais `ACTIVE`.
8. Deux actions et deux fenêtres objectivement incompatibles sont requises pour S28 complet.
9. Raphaëlle n’a aucune seconde obligation professionnelle signée : mutation obligatoire.
10. Nico utilise la mutation par défaut.
11. T21 et T22 restent des `FACT_RECORD` sans asset.
12. P17 n’est créée que si une conséquence réelle reste due.
13. Une bonne gestion peut mener directement à la priorité 8 de J16.

---

## 4. Règles communes des nouvelles promesses

```text
created_at:
  sortie, responsabilité ou engagement signé de J14

activated_at:
  confirmation explicite et résolution de la fenêtre en J15

due_at:
  fenêtre exacte J15

status: CONDITIONAL
activation_rule: CONDITIONAL → ACTIVE uniquement à activated_at
```

Une entrée absente n’est jamais représentée par un objet `ACTIVE`.

Transitions communes autorisées selon la fiche :

```text
CONDITIONAL → ACTIVE | EXPIRED | REFUSED
ACTIVE → PAID | AMENDED | CANCELLED | FAILED | CLOSED
AMENDED → ACTIVE | PAID | REFUSED | CANCELLED | CLOSED
FAILED → CLOSED
```

Une promesse `PAID`, `REFUSED`, `FAILED`, `EXPIRED`, `CANCELLED` ou `CLOSED` ne revient jamais à `ACTIVE` avec le même `promise_id`.

Deux fiches ne comptent comme deux promesses que si leurs `action_due` sont distinctes.

Avant toute nouvelle fiche Marie :

```text
P14 ACTIVE + même action_due
→ utiliser P14
→ aucune nouvelle fiche

P14 PAID | FAILED | CANCELLED + même action_due
→ respecter la terminalité
→ aucune recréation
```

---

## 5. Sept promesses conditionnelles

### 5.1 `marie_j14_pauline_player_account_j15`

```text
promise_type: COUPLE_REVIEW
created_at: sortie Pauline J14 laissant la conversation Marie due
activated_at: J15 08:09 après acceptation explicite de la fenêtre Marie
action_due: répondre à Marie sur ce que Player a accepté
due_at: J15 19:00–20:00, ou heure J14 précise reprise
collision_possible_with: pauline_j14_post_breach_return_j15
condition_absence: action déjà payée, heure refusée, ou P14 couvrant la même action
```

### 5.2 `pauline_j14_post_breach_return_j15`

```text
promise_type: CLARIFICATION
created_at: J14 après compromission, information de Pauline et responsabilité distincte de retour
activated_at: demande précise Pauline J15 + acceptation Player
action_due: dire à Pauline ce qui a réellement été expliqué avant sa décision
due_at: après l’échange Marie et avant J15 19:25
collision_possible_with: marie_j14_pauline_player_account_j15
condition_absence: P15 non PAID, aucune responsabilité distincte, retour non demandé ou refusé
```

### 5.3 `household_j14_sandra_rule_j15`

```text
promise_type: BOUNDARY_REVIEW
created_at: J14 S14-C lorsque Player promet de répondre sur l’appartement et Marie
activated_at: J15 08:20 lorsque la fenêtre foyer est résolue
action_due: fixer la règle du foyer avec Mathilde et/ou Marie
due_at: J15 19:00–19:15
collision_possible_with: sandra_j14_breach_account_j15
condition_absence: aucune règle due ou attente déjà fermée
```

### 5.4 `sandra_j14_breach_account_j15`

```text
promise_type: CLARIFICATION
created_at: J14 après compromission, information de Sandra et responsabilité distincte de compte rendu
activated_at: J15 13:08–13:09 après demande précise
action_due: dire à Sandra exactement ce qui a été vu, dit et éventuellement transmis
due_at: J15 19:00–19:15
collision_possible_with: household_j14_sandra_rule_j15
condition_absence: P15 non PAID, faits déjà rendus ou retrait avec fermeture
```

### 5.5 `mathilde_j14_household_safety_rule_j15`

```text
promise_type: BOUNDARY_REVIEW
created_at: J14 lorsqu’une règle de sécurité, distance ou foyer est signée
activated_at: J15 08:05 lorsque la fenêtre exacte est confirmée
action_due: garantir la sécurité, la distance ou la règle du foyer
due_at: J15 18:00–20:00 ou 18:30–19:15
collision_possible_with: uniquement une autre promesse antérieure réelle et ACTIVE
condition_absence: aucune règle, règle déjà payée ou source non attribuable
```

### 5.6 `marie_j14_raphaelle_position_j15`

```text
promise_type: COUPLE_REVIEW
created_at: sortie Raphaëlle J14 laissant la place réelle de Player à clarifier
activated_at: J15 08:28 après acceptation de la fenêtre Marie
action_due: répondre à Marie sur la place réelle de Player
due_at: J15 19:45–20:30
collision_possible_with: aucune seconde promesse signée par défaut
condition_absence: clarification payée, heure refusée ou P14 couvrant la même action
```

Aucune source signée antérieure exacte ne montre Player acceptant un rendu futur pour Raphaëlle et Maud. Il est interdit d’utiliser J15 comme preuve de sa propre précondition, de réactiver P05 ou de transformer l’accès créatif en tâche.

```text
Raphaëlle: S28_MUTATION_NO_COLLISION
Raphaëlle collision complète: MISSING_SIGNED_SOURCE
```

### 5.7 `marie_j14_nico_hour_account_j15`

```text
promise_type: COUPLE_REVIEW
created_at: sortie Nico J14 laissant l’heure réelle ou la vérité couple due
activated_at: J15 08:12 après acceptation de la fenêtre Marie
action_due: donner à Marie l’heure réelle et expliquer l’écart
due_at: J15 18:45–19:30
collision_possible_with: uniquement une seconde promesse antérieure distincte, signée et incompatible
condition_absence: vérité donnée en J14, heure non due, fenêtre refusée ou P14 couvrant la même action
```

Le service de Nico, une ancienne chaise ou une ancienne rencontre terminale ne constituent jamais une seconde promesse.

---

## 6. P14 et P15

### P14 `j14_witness_clarification`

P14 existe uniquement si D-C propose une heure précise acceptée.

```text
ACTIVE → PAID | AMENDED | FAILED | CANCELLED
AMENDED → ACTIVE | PAID | FAILED | CANCELLED
```

Une vérité immédiatement donnée ne crée pas P14.

### P15 `j14_inform_trace_controller`

P15 naît immédiatement lorsqu’une audience privée est compromise.

```text
ACTIVE → PAID | FAILED
FAILED → CLOSED
```

Informer la personne représentée en J14 rend P15 `PAID`. P15 ne reste jamais artificiellement `ACTIVE` jusqu’à J15.

---

## 7. Atteignabilité des branches

| Branche | Promise A | Promise B | Verdict |
|---|---|---|---|
| Pauline | `marie_j14_pauline_player_account_j15` | `pauline_j14_post_breach_return_j15` | `READY_WITH_REGISTRY_PATCH` si deux `ACTIVE` |
| Sandra | `household_j14_sandra_rule_j15` | `sandra_j14_breach_account_j15` | `READY_WITH_REGISTRY_PATCH` si deux `ACTIVE` |
| Mathilde | `mathilde_j14_household_safety_rule_j15` | autre fiche antérieure admissible | READY seulement avec O2 réelle ; mutation sinon |
| Raphaëlle | `marie_j14_raphaelle_position_j15` | aucune seconde fiche signée | `S28_MUTATION_NO_COLLISION` |
| Nico | `marie_j14_nico_hour_account_j15` | seconde fiche à prouver | mutation par défaut |
| Composite | paire du personnage réellement identifié | seconde fiche de cette paire | READY selon preuve ; mutation sinon |

La notification composite n’est jamais une promesse.

---

## 8. Validateur S28

Avant `FULL_COLLISION`, deux fiches distinctes doivent chacune satisfaire :

```text
status == ACTIVE
created_at < collision_start
activated_at <= collision_start
source_signed_ref != null
concerned_person != null
action_due != null
due_at != null
accepted_by_player attribuable
paid_or_closed_at == null
```

Rejeter la paire si :

- les identifiants sont identiques ;
- les actions sont identiques ou reformulent le même dû ;
- les fenêtres sont compatibles ;
- une promesse est terminale ;
- une action aurait déjà dû être payée en J14 ;
- la seconde obligation est créée le mardi pour provoquer S28.

Une incompatibilité objective exige qu’il soit matériellement impossible de réaliser honnêtement les deux actions dans leurs fenêtres.

---

## 9. `S28_MUTATION_NO_COLLISION`

```text
sequence_id: S28_MUTATION_NO_COLLISION

eligibility:
  - moins de deux promesses admissibles
  - ou fenêtres compatibles
  - ou seconde obligation non signée
  - ou bonne gestion ayant fermé les autres attentes

function:
  - payer, amender, refuser ou fermer l’unique obligation réelle
  - montrer les autres personnages continuant leur vie
  - conserver une conséquence Marie ou foyer uniquement si elle existe
  - préparer J16 sans simuler une collision

forbidden:
  - créer une seconde obligation mardi
  - rouvrir une promesse fermée
  - imposer un mensonge
  - punir la bonne gestion
  - ouvrir une route
  - créer une progression adulte
  - ajouter un fichier visuel
```

T21, lorsqu’il est nécessaire :

```text
trace_id: j15_obligation_collision_record_01
record_type: FACT_RECORD
collision_mode: NO_COLLISION
eligible_active_promise_ids: [zéro ou un promise_id]
selected_promise_id: promise_id réel ou null
promise_outcome: PAID | AMENDED | REFUSED | FAILED | CANCELLED | CLOSED | NONE
incompatible_windows_proven: false
second_signed_obligation_present: false
urgent_consequence_remaining: true | false
current_state: ACTIVE
visual_asset: none
```

Sans record :

```text
trace_id: j15_obligation_collision_record_01
current_state: NOT_CREATED
```

---

## 10. Handoff J15→J16

P17 `j16_priority_consequence_payment` n’est créée que si une conséquence réelle reste due après J15.

P17 est créée si :

- l’unique obligation a échoué ;
- un refus laisse une conséquence signée ;
- une obligation reste impayée ;
- un mensonge ou une violation laisse une réparation précise.

P17 est absente après paiement ou fermeture propre sans urgence.

T22 :

```text
trace_id: j16_consequence_payment_record_01
current_state: ACTIVE
record_type: FACT_RECORD
source_t21_id: j15_obligation_collision_record_01 | null
source_collision_mode: FULL_COLLISION | NO_COLLISION
source_promise_ids: []
p17_created: true | false
consequence_outcome:
  CONSEQUENCE_PAID
  | CONSEQUENCE_FAILED
  | NO_URGENT_CONSEQUENCE
  | DIRECT_TO_MATHILDE_MARIE_J17_PREPARATION
urgent_consequence_remaining: true | false
next_priority: 1..8
visual_asset: none
```

Sans T22 :

```text
trace_id: j16_consequence_payment_record_01
current_state: NOT_CREATED
```

Lorsque `urgent_consequence_remaining == false`, J16 peut utiliser la priorité 8.

---

## 11. Tests documentaires

- D-A donne immédiatement la vérité → P14 absente.
- D-C sans heure précise → P14 absente.
- D-C avec heure précise acceptée → P14 `ACTIVE`.
- personne représentée informée J14 → P15 `PAID`.
- P06/P07/P13 terminale → aucune réactivation.
- deux fiches `ACTIVE`, actions distinctes, fenêtres incompatibles → `FULL_COLLISION` admissible.
- même action reformulée, fiche terminale, source non signée ou fenêtres compatibles → mutation.
- Raphaëlle avec seule obligation Marie → mutation.
- Nico avec seule obligation d’heure → mutation.
- unique obligation `PAID` ou `CLOSED`, aucune urgence → P17 absente, priorité 8.
- unique obligation `FAILED` ou mensonge prouvé → P17 créée.
- bonne gestion antérieure → aucune dette de substitution.

---

## 12. Impact sur NAR-PROD-05

Comptages inchangés :

```text
12 beats servis
10 nouveaux contenus principaux
12 réutilisations antérieures distinctes
11 nouveaux fichiers sources
1 fichier enfant
1 variante conditionnelle
```

Le correctif ne crée aucun dialogue, aucun asset, aucun fichier visuel et aucune variante visuelle supplémentaire.

```text
verdict NAR-CANON-01: READY_WITH_REGISTRY_PATCH
verdict de déblocage NAR-PROD-05: READY_WITH_REGISTRY_PATCH
VALIDATION PRODUIT: PASS
```

La validation est acquise uniquement parce que le correctif ne fabrique aucune obligation, ne ressuscite aucune promesse et ne force aucune collision.
