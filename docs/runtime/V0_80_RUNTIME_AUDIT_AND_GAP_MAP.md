# V0.80 — Runtime Audit & Gap Map

> Technical-documentation audit of the current Godot/data prototype against the validated V0.78–V0.79 modular opening.  
> No runtime, JSON, GDScript, tests, assets, or playable content are modified by this file.

## 1. Audit purpose

The goal is not to design a new engine from scratch.

The goal is to answer:

```text
What can the current prototype already do?
What prevents the V0.79 opening from running correctly?
What is the smallest safe implementation slice?
```

The audit uses the current `main` baseline:

```text
V0.79
commit 71d8602aa2ca541f75a40b69e96978cc810268be
```

Canonical content sources:

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
```

---

## 2. Runtime files inspected

### Core

```text
game/scripts/core/DataLoader.gd
game/scripts/core/GameState.gd
game/scripts/core/EffectApplier.gd
game/scripts/core/DebugRouteProbe.gd
```

### Smartphone UI

```text
game/scripts/ui/PhonePrototype.gd
game/scripts/ui/ConversationView.gd
```

### Current active data

```text
game/data/state/initial_state.json
game/data/conversations/chapter_01_index.json
game/data/conversations/chapter_01_marie.json
game/data/conversations/chapter_01_sandra.json
game/data/conversations/chapter_02_index.json
game/data/conversations/chapter_02_*.json
game/data/conversations/chapter_03_index.json
game/data/conversations/chapter_04_index.json
game/data/visual_content/placeholders.json
game/data/visual_content/chapter_01_proofs.json
```

### Validation

```text
tools/validate_game_data.py
tools/simulate_route_paths.py
tests/test_godot_prototype_static.py
```

---

## 3. What the current prototype already supports

### 3.1 Persistent contact threads

`DataLoader.gd` groups separate conversation episodes by `thread.id`.

This is directly useful for the modular opening.

Example target:

```text
chapter_02_marie_make_room
chapter_02_marie_arrival_trace
```

can both use:

```text
thread_marie_private
```

and appear as one continuing Marie thread.

No new thread system is required.

### 3.2 Segmented conversations

A conversation may contain multiple segments.

`ConversationView.gd`:

- renders segments progressively;
- preserves history per thread;
- reopens a thread at its current segment;
- emits completion per source conversation episode;
- supports guided replies and three-way narrative choices;
- prevents duplicate Player bubbles after a choice.

The V0.79 line sources can therefore remain data-first JSON.

### 3.3 Sequential unlocks and notifications

`PhonePrototype.gd` already supports:

```text
initial_conversation_ids
locked_conversation_ids
after_conversation_completed
notification title/body
```

This is enough for a linear Wednesday slice:

```text
Marie O1
-> Marie arrival trace
-> Mathilde arrival
```

No scheduler is required for that first slice.

### 3.4 Moment and timestamp metadata

Chapter indexes already support:

```text
moment_flow
moment_label
time_label
transition_text
```

Conversation cards can display moment/time metadata.

Message bubbles already render `time_label` separately from message text.

The prototype therefore has a useful base for felt time.

### 3.5 One visible thread per character

The UI groups episodes by persistent thread and renders contacts, not a separate card for every moment.

This matches the product requirement:

```text
one visible thread per character
```

### 3.6 Choice effects and flags

`EffectApplier.gd` supports:

- numeric effects on known state variables;
- `sets_flags`;
- content unlocks;
- simple condition evaluation for one flag, numeric comparisons, and `OR`.

For the first vertical slice, flags are sufficient.

No new route-score model is needed.

### 3.7 Centered system-note rendering

`ConversationView.gd` can already render centered system notes and restore them from history.

This is close to what an `OFFLINE_BEAT` needs, although the current representation is internal/debug-oriented rather than a clean authored semantic type.

---

## 4. Current blockers and mismatches

## 4.1 The current J1 handoff contradicts V0.79

The playable J1 still contains:

- Mathilde's bags already in the entrance;
- sports shoes;
- a sports bag / racket visual;
- wording suggesting that she is already installed.

Current visual:

```text
j1_mathilde_bag_domestic_trace
```

V0.79 instead requires:

```text
Tuesday evening
Mathilde indirect only
-> Wednesday water-damage emergency
-> Wednesday arrival
```

This is a hard continuity conflict.

The Wednesday slice cannot be integrated cleanly unless the J1 handoff is patched narrowly.

Required compatibility correction:

- remove the already-installed bag/shoe/racket messages from J1 runtime;
- remove the corresponding J1 visual reference;
- replace them with the validated indirect installation/light seed from V0.69 when a Mathilde seed is desired;
- keep Mathilde without an active J1 thread.

This is not a new J1 rewrite.

It is a minimal continuity prerequisite for V0.81.

## 4.2 Chapter 2 is the deprecated fixed opening

The current `chapter_02_index.json` hardcodes:

```text
08:12 Marie morning
12:27 Raphaëlle
17:36 Marie
17:52 Mathilde
18:38 Sandra
18:56 Marie
19:04 Mathilde canapé selfie
```

It also locks:

- old sport/racket identity;
- old tool/badge Raphaëlle visual;
- old lake/book Sandra visual;
- a fixed linear order;
- Pauline and Nico absence by day-number rule;
- the deprecated canapé selfie.

This file cannot be incrementally edited into V0.79 without leaving contradictory old episodes active.

Recommended action:

```text
replace the active chapter_02 index and referenced episode set
rather than patching each old conversation in place
```

The old files may remain unreferenced on disk during the first runtime PR for history and rollback.

## 4.3 All legacy days are exposed in the playable day list

`DataLoader.gd` currently loads indexes for:

```text
01, 02, 03, 04, 05, 06, 07, 09
```

`PhonePrototype.gd` renders a day button for every loaded index.

Therefore, even after rewriting Wednesday, the player could manually open old J3+ content that is narratively suspended and inconsistent with V0.79.

The first canonical vertical slice must not leave those legacy days selectable as if they followed the new opening.

Smallest safe solution for V0.81:

```text
load only the canonically active indexes:
chapter_01_index.json
chapter_02_index.json
```

Keep all legacy files in the repository.

Re-add a day/index only when its replacement slice is validated and implemented.

This is a whitelist change, not a data deletion or large migration.

## 4.4 Unlocks are sequential, not branch-conditional

The current unlock system checks only:

```text
after_conversation_completed
```

It does not evaluate a choice flag before unlocking a target conversation.

This is sufficient for Wednesday O1–O2.

It is not sufficient for Thursday O4–O6, where one Marie choice must unlock exactly one of:

```text
O5A Marie/social
O5B Mathilde/home
O5C Raphaëlle/work
```

Conclusion:

```text
Do not implement Thursday topology in V0.81.
```

Condition-aware unlock support belongs to the next runtime slice after the Wednesday foundation is validated.

## 4.5 No semantic offline-beat type

The UI can show a centered system note, but authored data does not have a clean public `offline_beat` presentation contract.

V0.79 requires transitions such as:

```text
Player returns home.
The remaining boxes are carried and the room is finished face to face.
```

This should not be rendered as a message from Marie or Mathilde.

Recommended minimal support:

```json
{
  "type": "offline_beat",
  "time_label": "19:15",
  "text": "Player rentre. L'installation continue hors ligne."
}
```

`ConversationView.gd` should render it as a centered, visually distinct event note and preserve it in history.

No prose-cutscene engine is required.

## 4.6 Time is partly supported but not globally coherent

Useful current behavior:

- messages show timestamps;
- indexes expose moment labels and times;
- conversation cards show moment metadata.

Current gaps:

- phone status-bar time is hardcoded to `09:41`;
- day buttons display only `Jour N`;
- the UI exposes no canonical weekday label;
- the current metadata aggregation may show the latest time for a thread even when its later episode is still locked;
- no explicit day/phase separator exists inside conversation history.

Required V0.81 foundation:

- allow index metadata such as `calendar_label` and `display_label`;
- render `Mardi` / `Mercredi` instead of only `Jour 1` / `Jour 2`;
- keep a reference to the status-bar time label and update it from the active day/moment;
- compute contact-card moment metadata from currently available episodes only;
- use the approved Wednesday time ranges;
- support a centered day/phase or offline event note when needed.

A live clock simulation is not required.

## 4.7 Current state is route-score-oriented and overbroad for the opening

`initial_state.json` and `DebugRouteProbe.gd` are based on older concepts:

- desire/attachment/control scores;
- a dominant route;
- a probable threat;
- old `NTR_SUBI_SEED`-style output.

The V0.79 opening needs only remembered behavior such as:

- made room proactively / playfully / passively;
- welcomed Mathilde practically / playfully / distantly;
- Mathilde stay active;
- Wednesday opening complete.

Recommended V0.81 state strategy:

```text
flags only
```

Do not add new numeric affection variables.

Do not rewrite the full initial-state model or DebugRouteProbe in the first slice.

Treat the old route probe as legacy debug output outside the new narrative source of truth.

## 4.8 Static tests pin deprecated content

Current tests assert:

- every old chapter index remains hardcoded in `DataLoader.gd`;
- integer `Jour N` labels;
- hardcoded status-bar time `09:41`;
- old J2/J3 visual placeholders, including the canapé selfie;
- exact old J3 structures and titles;
- old route simulation labels.

A correct V0.81 implementation will therefore require narrow test updates.

Test changes are not a failure of the implementation.

They are necessary because the tests currently protect suspended narrative assumptions.

## 4.9 Visual loading has no active Chapter 2 bundle

`DataLoader.gd` currently loads:

- global placeholders;
- chapter 01 proofs;
- chapter 04+ proof bundles;

It does not load a Chapter 2 visual bundle.

The active V0.79 Wednesday slice needs one current visual:

```text
mathilde_arrival_room_01
```

Recommended V0.81 action:

- add `game/data/visual_content/chapter_02_proofs.json`;
- add that path to `VISUAL_CONTENT_PATHS`;
- do not delete all old global placeholder entries in the same PR;
- ensure no active new conversation references the deprecated canapé visual.

---

## 5. Gap classification

| Area | Current support | Gap | V0.81 action |
|---|---|---|---|
| Persistent threads | Good | none | reuse |
| Segments / history | Good | none | reuse |
| Three choices | Good | old content inconsistent | author current M0/MT0 |
| Sequential unlocks | Good | no branch conditions | enough for Wednesday |
| Conditional topology | Missing | required Thursday | defer |
| Day/moment metadata | Partial | weekday and active-time handling | small UI/index extension |
| Status-bar time | Hardcoded | not diegetic | make data-driven |
| Co-presence | No semantic type | phone may fake speech | add `offline_beat` rendering |
| State | Old scores | too broad | use flags only |
| Visuals | Placeholder catalog | no current C02 bundle | add one bundle/item |
| Legacy days | All selectable | continuity break | active-index whitelist |
| Tests | Broad | protect deprecated runtime | narrow updates |

---

## 6. Recommended implementation decomposition

## V0.81 — Tuesday handoff + Wednesday vertical slice

Implement only:

- narrow J1 Mathilde-handoff correction;
- active Tuesday/Mercredi labels;
- O1 Marie make-room scene;
- O2 Marie arrival trace;
- O2 Mathilde arrival scene;
- one current Mathilde arrival visual;
- semantic offline beat;
- flags for M0/MT0;
- hide legacy J3+ indexes from active navigation;
- targeted tests.

No Thursday topology.

## V0.82 — Thursday topology foundation

After V0.81 is validated:

- condition-aware conversation unlocks;
- O3 Raphaëlle work;
- Sandra echo;
- O4 Marie invitation;
- one-of-three O5 branch unlock;
- O6 mandatory Marie return;
- Thursday time flow;
- conditional return variants.

## V0.83 — Friday residue

After V0.82:

- O7 Pauline public-image relay;
- O8 Nico saved-seat follow-up;
- household breather;
- Friday visuals and timing;
- end-of-pack state verification.

This decomposition preserves short PRs and avoids building a universal scheduler before the opening proves itself in runtime.

---

## 7. Files explicitly out of scope for V0.81

Do not rewrite in the first runtime slice:

```text
game/data/conversations/chapter_03_*.json
game/data/conversations/chapter_04_*.json
game/data/conversations/chapter_05_*.json
game/data/conversations/chapter_06_*.json
game/data/conversations/chapter_07_*.json
game/data/conversations/chapter_09_*.json
tools/simulate_route_paths.py
game/scripts/core/DebugRouteProbe.gd
```

They may remain on disk but must not be presented as current playable continuation.

---

## 8. Audit conclusion

The current prototype does not need a large rewrite.

The reusable foundation is already substantial:

- persistent threads;
- segmented conversations;
- choice rendering;
- flags;
- sequential unlocks;
- notifications;
- message timestamps;
- visual placeholders.

The first safe step is not full modular scheduling.

It is:

```text
repair the J1 handoff
make Wednesday canonical and playable
make time visible
make offline interaction semantically representable
hide suspended legacy days
validate before adding Thursday branching
```

That is the recommended V0.81 boundary.
