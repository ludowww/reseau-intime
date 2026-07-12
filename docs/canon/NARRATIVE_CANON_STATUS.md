# Narrative Canon Status — Current

> Narrative and implementation status after the V0.88 first-repetition runtime-integration planning pass.  
> Runtime remains playable from Tuesday through Friday at V0.86 + V0.86a.  
> V0.87 defines the first repetition wave; V0.88 defines the smallest future runtime slice. Neither is playable yet.

## 1. Core rule

```text
V0.78 defines modular story movement.
V0.79 defines the Tuesday–Friday opening content.
V0.80 defines phased runtime integration.
V0.81 implements Wednesday.
V0.82 implements Thursday topology and Marie return.
V0.83 defines authoritative temporal flow and J1 replacement.
V0.84 makes temporal flow authoritative in runtime.
V0.85 replaces active Tuesday with reconciled J1.
V0.86 implements Friday and closes the opening band.
V0.86a makes time and notifications feel like a smartphone.
V0.87 defines the first post-opening repetition wave.
V0.88 maps the first Marie -> Mathilde -> Marie runtime slice.
V0.89 may implement only that validated slice.
Legacy runtime is not automatic narrative canon.
Documented or planned scenes are not current playable state until integrated.
```

---

## 2. Current source stack

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md

docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md

docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md
docs/canon/J1_RUNTIME_RECONCILIATION_SCENE_CARDS.md

docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md

docs/runtime/V0_88_FIRST_REPETITION_RUNTIME_INTEGRATION_PLAN.md

docs/V0_86_Friday_Public_Traces_And_Opening_Completion_Report.md
docs/V0_86A_Temporal_UX_Notification_Polish_Report.md
docs/V0_87_Next_Act_I_Windows_Source_Pack_Report.md
docs/V0_88_First_Repetition_Runtime_Integration_Plan_Report.md
```

Read the relevant full character canon before changing any character scene.

---

## 3. Current playable access

```text
launch
-> Tuesday active
-> Wednesday locked
-> Thursday locked
-> Friday locked
```

Day progression:

```text
Tuesday complete -> Wednesday
Wednesday complete -> Thursday
Thursday complete -> Friday
Friday complete -> no later playable day
```

Current runtime endpoint:

```text
Friday evening
opening_band_complete = true
```

Saturday, Sunday, Monday, the V0.87 repetition windows, and the V0.88 slice are not yet in the build.

Completed days remain read-only archives.

---

## 4. Current implemented opening

### Tuesday — canonical J1

```text
18:12 Marie remote opening + M1
19:15 / 19:35 dinner and walk
22:57 Sandra soft trace + S1
23:25 / 23:28 final Marie/shared-life return
Tuesday complete
```

Guarantees:

- bread is future action at choice time;
- M1 has three comparable presence postures;
- timestamps remain Tuesday and monotonic;
- Mathilde is indirect only;
- Sandra shares one imperfect image and closes herself;
- no numeric route effect;
- Tuesday ends on Marie/shared life.

### Wednesday — household change

```text
12:10 Marie / make room
-> 18:18 arrival trace
-> 18:22 Mathilde arrival
-> household settling
-> Wednesday complete
```

Result:

```text
Mathilde stay = active
Mathilde = R1 Ordinary Access
sexual intention = not established
```

### Thursday — movement and topology

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> complete or expire Sandra
-> 16:05 Marie required
-> one O5 topology branch
-> 22:10 Marie return required
-> Thursday complete
```

Guarantees:

- Raphaëlle reaches R1 through work;
- exactly one topology is selected;
- every topology returns to Marie;
- no Friday opportunity replaces O6;
- couple remains `HABITUAL_WARMTH`.

### Friday — traces and residue

```text
08:35 Pauline public group-photo relay + P0
14:05 Nico saved-seat follow-up + N0
18:05 Marie + Mathilde household echoes
18:25 household close
-> opening_band_complete
```

Guarantees:

- Pauline reaches R1 through legitimate image competence;
- Bastien remains visible;
- image origin and audience are explicit;
- no private alternate exists;
- Nico reaches R1 as a real friend and social mirror;
- Nico may know Mathilde is staying without sexualizing it;
- no image request, cover arrangement, rivalry, or dangerous frame opens;
- the opening closes on ordinary household life.

---

## 5. Current temporal and phone state

Day lifecycle:

```text
LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
```

Phase lifecycle:

```text
LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

Current phone presentation:

```text
last message
-> contact offline
-> two-second pause
-> four-second accelerated conversation-side clock
-> compact cross-thread notification
```

Same-thread continuation:

```text
clock advances
-> no same-contact notification
-> next episode continues below existing history
```

Current UI excludes:

- blank weekday/moment cards;
- `Le temps passe` prompts;
- left-column scheduler controls;
- visible explanatory offline beats;
- `Moments hors ligne` archive sections.

Internal continuity flags and records may remain stored without becoming player-facing exposition.

---

## 6. Current runtime character and route status

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE

Sandra = soft trace / ordinary continuity
Mathilde = R1 Ordinary Access
Raphaëlle = R1 Ordinary Work Access
Pauline = R1 Legitimate Social Access
Nico = R1 Ordinary Friendship / Social Access

Pauline private compartment = false
Nico dangerous shared-gaze frame = false
hard secrets = none
adult frames = none
routes R2+ = none
opening_band_complete = true
```

The later NSFW engines exist in full canon, but none is active merely because ordinary access exists.

---

## 7. V0.87 documented wave

Blueprint placement:

```text
Act I S4 — Private attention repeats
```

Core question:

```text
Which repeated attention changes meaning first?
```

Fixed structure:

```text
W9  Marie claims one shared hour
W10 weekend repetition opportunity
W11 mandatory Marie return
W12 first-workday repetition opportunity
W13 wave close / couple balance
```

Budget:

```text
fixed Marie foreground
+ maximum two external foreground tickets
+ zero to two echoes per window
+ maximum one charged-access owner
```

Candidate scenes:

```text
Mathilde — morning gaze acknowledged
Sandra — chosen work-afterglow contact
Raphaëlle — outside-work lunch walk
Pauline — second legitimate social cycle with Bastien visible
Nico — quiet friendship repetition
```

---

## 8. V0.87 route-stage contract

### Marie / Player

```text
start: HABITUAL_WARMTH
end: HABITUAL_WARMTH + reconnection or drift evidence
```

One weekend choice does not change couple mode.

Every external foreground creates or pays a Marie/shared-life return obligation.

### Mathilde

```text
start: R1
maximum documented: R2 Charged Access
```

R2 means only:

- Player's gaze was acknowledged;
- Mathilde did not reject the acknowledgement;
- deliberate seduction remains unconfirmed;
- no image or adult permission exists.

### Sandra

```text
start: R1 / soft continuity
maximum documented: R2 Charged Access
```

R2 means only:

- Sandra deliberately selected Player for a quiet interval;
- Player read without pressure;
- Sandra kept a soft limit;
- no confession, affair, or new image exists.

### Raphaëlle

```text
start: R1 work access
maximum documented: R2 Charged Access
```

R2 means only:

- Raphaëlle selected one ordinary outside-work layer;
- Player joined without using her as refuge;
- no creative account, costume, image, or named attraction exists.

### Pauline

```text
start: R1
maximum documented: R1
```

V0.87 gives Pauline a second legitimate social cycle with Bastien and Marie active.

No private alternate, secret test, reciprocal proof, or double-addressed image opens.

### Nico

```text
start: R1
maximum documented: R1
```

V0.87 gives Nico a second friendship cycle and quiet ordinary mode.

No shared gaze, domestic photo request, alibi, or rivalry frame opens.

### Global ceiling

```text
charged_access_owner = none | mathilde | sandra | raphaelle
maximum one owner
hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
relationship frame change = none
```

This is the authorized ceiling for future integration, not current save state.

---

## 9. V0.87 choice and consequence status

Meaningful nodes:

```text
M2 — Marie shared hour
MT1 — Mathilde owns the gaze question
S2 — Sandra chosen late contact
R1 — Raphaëlle outside-work interval
P1 — Pauline legitimate social plan
N1 — Nico ordinary friendship time
M3 — Marie concrete return
```

All foreground nodes use three choices.

Each node has one primary axis.

Every external foreground returns to `marie_concrete_return_due_01` before another opportunity may outrank it.

No choice writes an affection/desire score by itself.

---

## 10. V0.87 trace and image status

V0.87 requires no new image asset.

Existing opening traces remain unchanged:

```text
j1_sandra_lunch_memory_soft
mathilde_arrival_room_01
marie_laverriere_setup_01
laverriere_public_group_photo_set_01
```

No source-pack scene creates:

- a private crop;
- a second audience;
- a sexy image;
- forwarding permission;
- a proof object;
- an adult collectible.

Private attention is not automatically a hard secret.

---

## 11. V0.87 selection and replay status

The two external foreground tickets are selected deterministically from:

- current obligations;
- physical/time context;
- prior topology;
- character availability;
- scene cooldown;
- foreground history;
- charged-owner state;
- authored priority.

A single run should not show every character scene.

Quiet windows are valid.

Missed scenes:

- expire;
- mutate;
- or require a fresh reason.

No exact offer waits forever.

---

## 12. V0.88 integration boundary

V0.88 selects the first future runtime proof:

```text
Saturday W9 Marie shared hour
-> Sunday Mathilde morning candidate or silent defer
-> Sunday W11 Marie concrete return
```

The slice is intentionally incomplete.

It may write:

```text
first_repetition_slice_01_complete
```

It must not write:

```text
first_repetition_wave_complete
```

Monday remains unavailable.

### Why Mathilde is first

- her stay and household access already exist;
- `thread_mathilde_private` already exists;
- no new image or social hub is required;
- the scene grows directly from ordinary household continuity;
- it tests candidate eligibility, expiry, R1/R2 gating, and return priority;
- Marie and family trust remain active in the meaning;
- selection is based on fit, not the excitement of Mathilde's later adult route.

Sandra, Raphaëlle, Pauline, and Nico remain authored future candidates.

---

## 13. V0.88 runtime-state plan

Separation of concerns:

```text
TimelineState
= chronology, days, phases, episodes, expiry

GameState.story_ledgers.first_repetition
= wave-level foreground history, charged owner, scene lifecycle,
  cooldowns, and obligations

flat flags
= observable authored branch facts

index data
= authored limits and deterministic candidate order
```

Planned ledger fields:

```text
opportunity_window_ordinal
external_foreground_scene_ids
external_foreground_character_ids
charged_access_owner
scene_status
cooldown_until_ordinal
obligations
```

The current prototype has no persistent save/load migration path.

V0.89 must not invent a full save system. Missing ledger keys receive safe defaults.

---

## 14. V0.88 selection and charged-owner plan

A future `FirstRepetitionSelector.gd` returns:

```text
one eligible candidate
or
none
```

Selection order:

```text
safety / aftermath
-> due Marie consequence
-> external ticket budget
-> character already foregrounded
-> authored candidate order
-> hard requirements
-> hard exclusions
-> scene lifecycle / cooldown
-> physical and temporal context
```

No random scheduler and no route menu are allowed.

Mathilde may claim:

```text
charged_access_owner = mathilde
```

only if:

- MT1A or MT1B was chosen;
- positive household trust or playful history exists;
- no unresolved overstep exists;
- no other owner exists;
- no due Marie consequence was bypassed.

If the claim fails, Mathilde remains R1 while the soft gaze flag remains valid.

---

## 15. V0.88 obligation plan

First-slice obligation statuses:

```text
SCHEDULED
DUE
PAID
FAILED
CARRIED
```

Key outcomes:

- M2A pays the shared hour through internal continuity;
- M2B schedules and pays the bounded Saturday alternative in this limited slice;
- M2C lets Marie enjoy her hour independently and schedules the Sunday return;
- Mathilde completion schedules a Marie return;
- a due Marie return blocks another external opportunity;
- M3A pays the return;
- M3B carries a bounded Monday-morning obligation without pretending it is paid;
- M3C resolves the current obligation as honest non-repair.

Couple mode remains `HABITUAL_WARMTH` throughout the first slice.

---

## 16. V0.88 communication and voice plan

The slice reuses V0.86a:

```text
last message
-> contact offline
-> two-second pause
-> four-second clock animation
-> compact cross-thread notification
```

Same-thread Marie episodes resume directly.

Co-present actions remain off-chat and receive no explanatory card.

Voice gate:

```text
Marie = shared life, food, movement, practical humor
Mathilde = speed, correction, bad faith, image + limited legal seasoning
Player = short, dry, observant, imperfect action
```

Recurring legal humor outside Mathilde remains prohibited.

---

## 17. Legacy and deprecation status

Do not restore:

- Mathilde canapé-photo foundation;
- oversized grey-sweater identity;
- immediate Pauline private crop;
- indestructible Pauline/Marie friendship;
- immediate Nico photo pact or alibi;
- Nico as pure voyeur/NTR mechanism;
- Raphaëlle private costume/account access before outside-work person;
- new Sandra photo as automatic progression;
- fixed character order;
- old blank interstitial presentation.

Full current character canon, voice distinction, V0.87 scene cards, and V0.88 integration plan control.

---

## 18. Validation and implementation status

V0.88 is documentation-only.

Expected repository scope:

```text
docs/**
ROADMAP.md
```

No `game/**`, `tests/**`, or `tools/**` change belongs in this milestone.

Next required milestone:

```text
V0.89 — First Repetition Vertical Slice
```

Authorized runtime boundary:

```text
W9 Marie shared hour
+ Sunday Mathilde candidate or silent defer
+ W11 Marie return
```

V0.89 must not include the complete candidate pool or second external ticket.

---

## 19. Final rule

```text
The playable story still ends Friday.
The authorized story knows what may repeat next.
The integration plan now knows the first truthful runtime proof.

One repeated attention may become charged.
It does not yet become permission.
```
