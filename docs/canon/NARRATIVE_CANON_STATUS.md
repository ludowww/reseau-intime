# Narrative Canon Status — Current

> Narrative status after the V0.87 first-repetition source-pack pass.  
> Runtime remains playable from Tuesday through Friday at V0.86.  
> V0.87 defines the first post-opening repetition wave but does not yet implement it.

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
Legacy runtime is not automatic narrative canon.
Documented scenes are not current playable state until integrated.
```

---

## 2. Current source stack

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md

docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md

docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md
docs/canon/J1_RUNTIME_RECONCILIATION_SCENE_CARDS.md

docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md

docs/V0_86_Friday_Public_Traces_And_Opening_Completion_Report.md
docs/V0_86A_Temporal_UX_Notification_Polish_Report.md
docs/V0_87_Next_Act_I_Windows_Source_Pack_Report.md
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

Saturday, Sunday, Monday, and the V0.87 repetition windows are not yet in the build.

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

No source pack scene creates:

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

## 12. Legacy and deprecation status

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

Full current character canon and V0.87 scene cards control.

---

## 13. Validation and implementation status

V0.87 is documentation-only.

Expected repository scope:

```text
docs/**
README.md
ROADMAP.md
```

No `game/**`, `tests/**`, or `tools/**` change belongs in this milestone.

Next required milestone:

```text
V0.88 — First Repetition Runtime Integration Plan
```

Recommended first vertical slice:

```text
W9 Marie shared hour
+ one external candidate
+ mandatory Marie return
```

No V0.87 scene enters runtime before V0.88 is validated.

---

## 14. Final rule

```text
The playable story still ends Friday.
The authorized story now knows what may repeat next.

One repeated attention may become charged.
It does not yet become permission.
```
