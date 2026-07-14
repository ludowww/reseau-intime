# Act I Named Boundaries Wave Temporal Delivery Map — V0.93

> Canon delivery map for the V0.93 named-boundaries wave.
> Companion to the source pack and scene cards.
> Documentation only: no runtime, JSON, GDScript, test, asset, save, merge, or tag change is authorized by this map alone.

## 1. Purpose

This map defines:

- the next calendar days after locked V0.92;
- the order and timing of W14–W18;
- which beats are remote, co-present, silent, optional, or mandatory;
- how the historical first-repetition ledger selects one carry-over consequence;
- when obligations become due;
- when scenes expire or defer;
- how the wave closes without unlocking a later day prematurely.

It does not define final JSON or GDScript.

---

## 2. Entry and endpoint

Entry condition:

```text
current playable endpoint = Monday evening
first_repetition_wave_complete = true
```

Next calendar day:

```text
runtime day 8 = Tuesday, following week
```

Wave calendar:

```text
day 8  Tuesday    W14 Marie real plan
day 9  Wednesday  W15 carry-over boundary + W16 social hub
day 10 Thursday   W17 Nico completion when needed + W18 Marie return and close
```

Wave endpoint:

```text
Thursday evening
named boundaries wave complete
next day unavailable
```

A future implementation should keep:

```text
Thursday next_day = null
```

until a later source pack defines the following wave.

---

## 3. Global delivery rules

### 3.1 One persistent thread per character

Use the existing persistent threads:

```text
thread_marie_private
thread_mathilde_private
thread_sandra_private
thread_pauline_private
thread_nico_private
thread_raphaelle_private
```

Do not create a new thread merely because the week changed.

The group/social hub does not require a permanent new group thread unless a later runtime plan proves one already exists and is necessary.

### 3.2 Player messages remain manual

```text
one Player choice = one manual Player message
```

No automatic Player message may be inserted to bridge a time jump, summarize attendance, apologize, or claim an action.

### 3.3 Maximum message runs

Before a Player action:

```text
recommended maximum incoming run = 3 messages
```

A fourth incoming message requires a concrete delivery reason and should normally be split by time, action, or a guided acknowledgement.

### 3.4 Co-present action is not simulated as chat

La Verrière closing, the L'Annexe table, Thursday dinner, and shared walks are co-present or offline actions.

Represent them through:

- compact logistics;
- state writes;
- short later echoes;
- contact status;
- chronology;
- no fake transcript of people messaging while seated together.

### 3.5 Silent phases remain invisible

A silent phase may:

- select the carry-over source;
- mark a scene deferred;
- pay a known state transition;
- close the wave.

It may not produce:

- a visible explanatory card;
- a `Moments hors ligne` archive entry;
- a fake system message;
- a summary of internal flags.

---

## 4. Day 8 — Tuesday

### 4.1 Day start

Recommended start:

```text
17:42
```

Marie is still at La Verrière or leaving a work task.

Player is available by phone.

Mathilde may be at the apartment, commuting, or handling her own work.

No carry-over route scene opens before Marie's fixed request.

### 4.2 Phase T8-1 — Marie real plan

Recommended phase id:

```text
tuesday_marie_real_plan
```

Time band:

```text
17:42–18:05
```

Delivery:

```text
REMOTE_ASYNC
required conversation
```

Conversation source:

```text
marie_next_week_real_plan_01
```

Opening delivery:

```text
Marie gives Wednesday La Verrière timing
-> Pauline and Bastien availability
-> Nico table deadline
-> three concrete Player actions
```

The M4 choice immediately writes exactly one topology and exactly one obligation.

### 4.3 M4 topology effects

#### M4A — Join from start

```text
Wednesday arrival target = La Verrière before close
Wednesday social hub = joined
Thursday couple-time obligation = none
```

#### M4B — Precise late arrival

```text
Wednesday arrival target = 20:45 at L'Annexe
Wednesday social hub = late
warning deadline = before 20:15
```

#### M4C — Protect Thursday

```text
Wednesday social hub = Marie independent
Thursday couple-time target = 19:30
Wednesday surveillance delivery = forbidden
```

### 4.4 Phase T8-2 — Tuesday settle

Recommended phase id:

```text
tuesday_real_plan_settle
```

Time band:

```text
18:05–22:30
```

Delivery:

```text
silent internal continuity
```

Functions:

- store the M4 obligation;
- keep Tuesday active until the required Marie exchange completes;
- unlock Wednesday only after M4 is resolved;
- do not offer Mathilde, Sandra, Pauline, Nico, or Raphaëlle as a second Tuesday foreground.

Tuesday end state:

```text
M4 topology known
one obligation scheduled
Wednesday unlocked
no route stage changed
```

---

## 5. Day 9 — Wednesday carry-over selection

### 5.1 Selection phase

Recommended phase id:

```text
wednesday_carryover_boundary_select
```

This phase is internal and deterministic.

Selection order:

```text
1. overdue safety / aftermath
2. Mathilde charged-owner consequence
3. most recent resolved historical foreground
4. earlier resolved historical foreground
5. none
```

Current possible outputs:

```text
mathilde_named_gaze_boundary_01
sandra_not_a_secret_routine_01
none
```

The selected consequence must already be justified by `story_ledgers.first_repetition`.

No new candidate is created from character popularity.

### 5.2 Mathilde delivery

Preferred time:

```text
07:55–08:12
```

Recommended phase id:

```text
wednesday_mathilde_named_boundary
```

Delivery:

```text
SEPARATE_ROOMS_PING -> brief co-present kitchen consequence
```

Rules:

- Mathilde may send one practical opener if needed;
- the meaningful boundary occurs in the kitchen or immediately afterward;
- do not create a long Messenger exchange while both remain in the apartment;
- no notification if the Mathilde thread is already open and active;
- the phase is required only when selected.

Completion:

```text
RESOLVED
```

Possible negative but terminal outcome:

```text
access cooled
boundary still named
```

The scene does not expire merely because Player chose a poor reply.

### 5.3 Sandra delivery

Preferred time:

```text
12:35–12:55
```

Alternative:

```text
18:05 after a later end of post
```

Recommended phase id:

```text
wednesday_sandra_named_boundary
```

Delivery:

```text
REMOTE_ASYNC
```

Rules:

- Sandra begins from a concrete trace: passing the café, a lunch-break detail, or end-of-post fatigue;
- no new photo is required;
- no immediate meeting follows;
- Sandra can close the exchange herself;
- the phase is required only when selected.

Completion:

```text
RESOLVED
```

Cooling after deflection remains a resolved consequence, not a technical expiry.

### 5.4 Quiet carry-over path

When no historical foreground resolved:

```text
selected carry-over = none
```

Runtime behavior:

- mark carry-over selection terminal;
- produce no placeholder conversation;
- produce no `nobody wrote` message;
- advance to the social-hub preparation.

---

## 6. Day 9 — Wednesday social hub

### 6.1 La Verrière preparation

Recommended phase id:

```text
wednesday_laverriere_plan_payment
```

Time band:

```text
18:35–19:15
```

#### M4A

Player must arrive before the closing task ends.

Result:

```text
marie_wednesday_shared_presence = PAID
```

If Player does not arrive:

```text
marie_wednesday_shared_presence = FAILED
```

No automatic apology is written.

#### M4B

Player is not required at La Verrière.

The precise-arrival obligation remains scheduled.

#### M4C

Player is not expected.

Marie closes with colleagues or Pauline without a punishment message.

### 6.2 L'Annexe table

Recommended phase id:

```text
wednesday_lannexe_social_hub
```

Time band:

```text
19:35–22:35
```

Scene source:

```text
lannexe_legitimate_social_return_01
```

Primary delivery:

```text
CO_PRESENT_SOCIAL_HUB
```

Phone delivery is limited to:

- table confirmation;
- exact arrival information;
- one deadline-aware amendment;
- one compact notification when Player is elsewhere.

### 6.3 M4B deadline

Target:

```text
20:45
```

Amendment deadline:

```text
20:15
```

Outcomes:

```text
arrives by target
-> PAID

warns before deadline with new concrete target accepted by Marie
-> AMENDED

misses without accepted amendment
-> FAILED
```

An amendment is not accepted automatically.

Marie may refuse a time that empties the plan of meaning.

### 6.4 M4C information boundary

When Player chose Thursday couple time:

- Marie may send a normal arrival/home logistics message;
- Player does not receive a minute-by-minute account of the table;
- no public photo is pushed as jealousy bait;
- Pauline or Nico does not privately report Marie's behavior;
- Thursday remains the actual obligation deadline.

### 6.5 Hub state writes

Terminal hub state should record:

```text
social hub occurred
Pauline legitimate social cycle 02 resolved
Bastien present
Nico public competence observed
M4 Wednesday obligation paid / amended / failed / not applicable
```

No route stage changes inside the hub.

---

## 7. W17 — Nico delivery

### 7.1 Attended or late-arrival path

Preferred time:

```text
23:05–23:28 Wednesday
```

Recommended phase id:

```text
wednesday_nico_quiet_truth
```

Delivery variants:

```text
brief co-present exchange after the room thins
OR
short remote follow-up after Player leaves
```

The runtime plan must choose one coherent delivery per topology.

Do not duplicate both versions in one run.

### 7.2 Marie-independent path

When Player did not attend by prior agreement:

Preferred time:

```text
11:45–12:05 Thursday
```

Recommended phase id:

```text
thursday_nico_empty_seat_followup
```

Delivery:

```text
REMOTE_ASYNC
```

Nico may mention:

- the empty chair;
- Marie's ordinary social energy;
- Player's choice to protect Thursday;
- whether Player actually intends to pay that choice.

Nico may not provide:

- surveillance detail;
- sexualized report;
- image;
- alibi;
- claim about Marie's private intention.

### 7.3 N2 completion

The three N2 choices must write one terminal Nico outcome:

```text
nico_truth_without_private_exchange
OR
nico_complicity_risk_soft
OR
nico_gaze_boundary_set
```

All three also write:

```text
nico_quiet_friendship_cycle_02_complete
```

The phase may defer only for a real availability or higher-priority consequence conflict.

It must not remain offered indefinitely.

---

## 8. Day 10 — Thursday Marie return

### 8.1 Day start

Recommended start:

```text
11:45 if Nico follow-up is due
otherwise ordinary daytime remains silent
```

Raphaëlle may appear as ordinary work texture only:

- one work question;
- a meeting detail;
- a corrected note;
- no outside-work invitation;
- no private account;
- no route foreground.

This echo must not delay the due Marie obligation.

### 8.2 Thursday couple deadline

Preferred phase id:

```text
thursday_marie_real_plan_return
```

Preferred time:

```text
19:30–20:10
```

Scene source:

```text
marie_named_boundary_return_01
```

#### If M4A or M4B was already paid

Thursday is an ordinary shared-life return.

The scene may be shorter and warmer.

It should not invent another test because Player already acted.

#### If M4B was amended

Marie reads whether the amendment itself was paid.

A chain of amendments cannot replace action indefinitely.

#### If M4B failed

Marie names the consequence through the evening that already happened without Player.

No grand confrontation is required.

#### If M4C

Thursday is the actual promised couple time.

Outcomes:

```text
paid
amended before deadline
failed honestly
```

No vague pending state survives the night.

### 8.3 Offline result

When paid, the dinner or walk is offline.

Do not simulate the shared activity as a long chat.

When failed, Marie continues her evening.

Do not show her frozen beside an untouched plate.

---

## 9. Internal wave close

Recommended phase id:

```text
thursday_named_boundaries_wave_close
```

Preferred time:

```text
21:10
```

Delivery:

```text
internal silent phase
```

Required closure predicate:

```text
first_repetition_wave_complete
M4 obligation terminal
carry-over selection terminal
selected carry-over scene terminal or absent
social hub terminal
Nico cycle terminal or explicitly deferred
Marie Thursday consequence terminal
no SCHEDULED / DUE obligation without an authorized carried contract
```

Recommended completion fact:

```text
named_boundaries_wave_complete
```

The exact flag and ledger schema remain for the integration plan.

The close must:

- be idempotent;
- write no day-log exposition;
- create no notification;
- unlock no Friday;
- preserve historical ledgers;
- preserve evidence families independently;
- preserve Mathilde historical owner if present.

---

## 10. Phase ordering summary

### Tuesday / day 8

```text
tuesday_marie_real_plan
tuesday_real_plan_settle
```

### Wednesday / day 9

```text
wednesday_carryover_boundary_select
wednesday_mathilde_named_boundary OR wednesday_sandra_named_boundary OR silent none
wednesday_laverriere_plan_payment
wednesday_lannexe_social_hub
wednesday_nico_quiet_truth when topology supports it
```

### Thursday / day 10

```text
thursday_nico_empty_seat_followup when due
thursday_marie_real_plan_return
thursday_named_boundaries_wave_close
```

No phase may be shown as a scheduler button.

---

## 11. Obligation lifecycle

Supported statuses for the future runtime plan:

```text
SCHEDULED
DUE
PAID
AMENDED
FAILED
CARRIED only with explicit later contract
```

V0.93 recommends no carried obligation beyond Thursday.

### M4A obligation

```text
created Tuesday
expected Wednesday La Verrière close
terminal Wednesday
```

### M4B obligation

```text
created Tuesday
amendment deadline Wednesday 20:15
target Wednesday 20:45
terminal Wednesday
```

### M4C obligation

```text
created Tuesday
expected Thursday 19:30
terminal Thursday
```

No obligation may be silently deleted.

---

## 12. Notification rules

### Marie

- initial Tuesday message may create the normal pending notification;
- obligation reminders should not spam;
- no same-thread banner when Marie thread is already open;
- no automatic Player reply.

### Mathilde

- use no notification when the interaction begins through immediate household presence;
- a short ping is allowed only when rooms are separate;
- no fake `Mathilde is in the kitchen` system prose.

### Sandra

- normal compact notification allowed;
- no image preview;
- no café meeting notification after boundary completion.

### Pauline

- social logistics may appear through Marie or Pauline according to authored origin;
- no private alternate notification;
- Bastien's presence must remain in the social information.

### Nico

- compact notification allowed for the Thursday follow-up;
- no same-contact duplicate after a Wednesday co-present scene;
- no image or alibi preview.

### Raphaëlle

- ordinary work echo only;
- no route-signaling notification.

---

## 13. Archive rules

Completed Tuesday, Wednesday, and Thursday remain day-scoped read-only archives.

Archives may show:

- actual message history;
- completed contact threads;
- existing public trace references already shown in conversation.

Archives may not show:

- internal carry-over selection;
- invisible boundary priority;
- obligation tables;
- `named boundary source` labels;
- route stages;
- hidden knowledge states;
- `Moments hors ligne` summaries.

---

## 14. Validation scenario matrix

### A — no first-wave foreground

```text
carry-over = none
Marie M4 resolves
social hub resolves
Nico resolves
Marie return resolves
-> wave closable
```

### B — Mathilde charged owner

```text
Mathilde boundary selected
owner preserved
no R3
-> wave closable after terminal consequence
```

### C — Mathilde resolved, no owner, Sandra absent

```text
Mathilde ordinary boundary selected
route remains R1
-> wave closable
```

### D — Sandra most recent resolved foreground

```text
Sandra boundary selected
Sandra remains R1
no new image
-> wave closable
```

### E — both Mathilde and Sandra resolved, Mathilde owner

```text
Mathilde owner consequence outranks recency
Sandra receives no second foreground
-> wave closable
```

### F — M4A paid

```text
Player joins from start
Marie obligation paid Wednesday
Thursday return remains ordinary
-> wave closable
```

### G — M4B paid

```text
Player arrives 20:45 or accepted target
obligation paid or amended then paid
-> wave closable
```

### H — M4B failed

```text
no accepted warning
obligation failed
Marie remains active
-> wave still closable with drift evidence
```

### I — M4C paid

```text
Marie attends independently Wednesday
Thursday couple time paid
-> wave closable
```

### J — M4C failed honestly

```text
Thursday obligation failed
no false repair
-> wave closable with drift evidence
```

### K — Nico honest

```text
truth without private exchange
shared gaze remains false
-> wave closable
```

### L — Nico soft complicity

```text
risk marker may exist
no image or alibi
-> wave closable
```

### M — Nico boundary

```text
women-not-content boundary set
friendship remains active
-> wave closable
```

### N — unresolved obligation

```text
any M4 obligation remains SCHEDULED or DUE
-> closure blocked
```

### O — knowledge leak

```text
Nico receives domestic Mathilde detail without disclosure
OR Marie knows Sandra private line without source
-> validation failure
```

### P — later-day leak

```text
Friday unlocks
-> validation failure
```

---

## 15. Runtime slicing recommendation

Do not integrate all three days in one first patch.

Recommended sequence:

```text
slice 1: Tuesday M4 + obligation creation
slice 2: carry-over selector + Mathilde/Sandra consequence
slice 3: social hub + Nico cycle
slice 4: Marie return + guarded closure
```

Each slice should include:

- static structure tests;
- isolated runtime smoke scenarios;
- existing smoke non-regression;
- `git diff --check`;
- Godot headless boot;
- no unrelated narrative JSON changes.

---

## 16. Final temporal rule

```text
Tuesday creates the action.
Wednesday reveals what prior attention now costs.
The social room makes ordinary life visible.
Nico names the edited pattern.
Thursday proves whether Player's chosen action existed.

Then the wave closes.
It does not open the next day by assumption.
```
