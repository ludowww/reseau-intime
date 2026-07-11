# Narrative Canon Status — Current

> Narrative and implementation status after V0.82.  
> Current playable runtime is canonical through Thursday night. Friday remains authored in V0.79 but unimplemented.

## 1. Core rule

```text
V0.78 defines modular story movement.
V0.79 defines the Tuesday–Friday opening content.
V0.80 defines the phased runtime plan.
V0.81 implements Tuesday and Wednesday.
V0.82 implements Thursday topology and the mandatory Marie return.
Legacy runtime is not automatic narrative canon.
```

## 2. Current source stack

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
docs/V0_80_First_Modular_Runtime_Integration_Plan.md
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
docs/V0_81_Tuesday_Handoff_And_Wednesday_Runtime_Report.md
docs/runtime/V0_82_THURSDAY_TOPOLOGY_IMPLEMENTATION_PLAN.md
docs/V0_82_Thursday_Topology_And_Marie_Return_Runtime_Report.md
```

Then read relevant character canon and the global NSFW canon when applicable.

## 3. Current playable chronology

### Tuesday evening — J1

- Marie and Sandra active;
- Mathilde indirect only;
- couple in `HABITUAL_WARMTH`;
- no route lock, hard secret, adult frame, or changed relationship agreement.

### Wednesday — O1/O2

- Marie asks Player to make room after Mathilde's water damage;
- Mathilde arrives;
- `mathilde_arrival_room_01` is an authorized ordinary image;
- Player's welcome creates observable flags;
- co-present settling continues as `offline_beat`;
- Mathilde reaches R1 only.

### Thursday morning — O3 Raphaëlle

Raphaëlle appears through ordinary peer work.

R0 records accountable, playful-active, or delayed professional behavior.

```text
Raphaëlle = R1 Ordinary Work Access
```

No personal/private route opens.

### Thursday early afternoon — Sandra echo

Sandra may be opened after a poste du matin.

The echo adds:

- no new image;
- no promise;
- no route-stage increase.

It remains optional and does not gate Marie.

### Thursday late afternoon — O4 Marie

Marie proposes the La Verrière vernissage and M1 asks where/how Player will be present.

M1 sets exactly one topology flag.

### Thursday evening — O5

Exactly one branch unlocks:

```text
O5A — Player joins Marie at La Verrière
O5B — Player stays home with Mathilde in another room
O5C — Player finishes work with Raphaëlle and handles his promise
```

The other two remain unavailable.

### Thursday night — O6 Marie

Every branch completion unlocks the same Marie consequence episode.

Messages and guided acknowledgements are filtered from the actual quality flag.

O6 cannot be replaced by another route opportunity and does not offer a new topology.

## 4. Current runtime architecture

Active indexes:

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
```

V0.82 reuses V0.81 time/thread adapters and adds narrow condition-aware adapters.

### PhonePrototypeV082

Supports:

- `conditions` on unlock rules;
- `after_any_conversation_completed`;
- `notify: false` for silent echo access;
- condition-aware contact messages/choices.

### ConversationViewV082

Supports:

- conditional messages and choices;
- `unless_conditions`;
- suppressed empty-choice hint for pure consequence variants;
- cumulative cross-day segment/episode merging while preserving history.

No base-script refactor or scheduler is introduced.

## 5. Thursday state writes

### Raphaëlle

```text
raphaelle_work_accountable
raphaelle_work_playful
raphaelle_work_delayed
raphaelle_r1_established
```

### Topology

```text
opening_topology_join_marie
opening_topology_stay_home
opening_topology_work_then_join
join_after_work_obligation
```

### Joined branch

```text
marie_event_initiative
marie_event_playful_help
marie_event_distracted
couple_reconnection_candidate
couple_presence_strained
```

### Home branch

```text
mathilde_home_help
mathilde_home_playful_help
mathilde_home_distance
household_participation_positive
parallel_drift_candidate
```

### Work branch

```text
work_promise_kept
work_promise_amended
work_promise_missed
couple_reconnection_candidate
parallel_drift_candidate
```

These are remembered actions/tendencies, not new route scores.

## 6. Time and communication status

Thursday sequence:

```text
09:10 Raphaëlle
13:50 Sandra
16:05 Marie offer
17:45 / 17:55 / 18:20 selected branch
22:10+ Marie return
```

Communication remains realistic:

- same-venue Marie messages are short logistics;
- helpful Mathilde branches stop chat when Player enters the room;
- Raphaëlle work chat requires physical separation;
- emotional consequence arrives later through Marie's afterglow thread.

## 7. Character status after Thursday

### Marie

- remains the central event and consequence anchor;
- knows whether Player joined, helped elsewhere, amended a promise, or missed it;
- couple remains in `HABITUAL_WARMTH`.

### Mathilde

- temporary stay active;
- R1 ordinary domestic access;
- optional practical Thursday scene only when Player stays home;
- no deliberate sexual intention.

### Raphaëlle

- R1 work access established;
- may become Thursday branch only when Player chose work;
- no private creative/sexual frame.

### Sandra

- soft continuity echo only;
- no new image or route escalation.

### Pauline and Nico

- no current playable post-J1 access;
- wait for V0.83 Friday.

## 8. Visual status

Current Thursday visual:

```text
marie_laverriere_setup_01
```

It is authorized, ordinary, event-contextual, non-proof, and risk zero.

No adult or private-route visual exists.

## 9. Current exclusions

Not implemented:

- Friday O7/O8;
- Pauline/Nico threads;
- public group-photo relay;
- route R2+;
- hard secrets;
- adult content;
- open-couple or group negotiation;
- NTR/cuckold logic;
- universal scheduler;
- save migration;
- legacy-file deletion.

## 10. Validation status

Static coverage includes:

```text
tests/test_v081_wednesday_static.py
tests/test_v082_thursday_static.py
```

The GitHub connector cannot execute Python/Godot commands or the manual walkthrough. CI or a local Hermes/Codex environment must confirm them before merge.

## 11. Next step

After V0.82 validation:

```text
V0.83 — Friday public traces and opening completion
```

## 12. Final rule

```text
Current playable canon ends Thursday night after Marie has received the consequence of the selected topology.
Friday remains unavailable until V0.82 is validated.
```
