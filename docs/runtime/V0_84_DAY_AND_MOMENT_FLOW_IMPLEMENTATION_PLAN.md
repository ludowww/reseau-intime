# V0.84 — Day & Moment Flow Runtime Foundation

> Proposed runtime implementation after V0.83 validation.  
> Adds chronological gating, transition interstitials, optional-scene expiry, and archive-safe day navigation.  
> Does not rewrite J1 dialogue or add Friday content.

## 1. Goal

Make narrative time an explicit runtime state.

V0.84 must solve three current problems:

1. Tuesday, Wednesday, and Thursday are all selectable from the beginning.
2. No transition page marks the end of one day or the start of the next.
3. Thursday unlocks Sandra 13:50 and Marie 16:05 simultaneously, allowing the player to answer the earlier conversation after acting later.

V0.84 implements infrastructure only.

J1 content reconciliation belongs to V0.85.

Friday remains deferred.

---

## 2. Required sources

```text
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
docs/runtime/V0_84_DAY_AND_MOMENT_FLOW_IMPLEMENTATION_PLAN.md
```

Inspect current V0.82 runtime before editing:

```text
game/scripts/core/DataLoader.gd
game/scripts/core/GameState.gd
game/scripts/ui/PhonePrototypeV081.gd
game/scripts/ui/PhonePrototypeV082.gd
game/scripts/ui/ConversationViewV082.gd
game/data/conversations/chapter_01_modular_index.json
game/data/conversations/chapter_02_modular_index.json
game/data/conversations/chapter_03_modular_index.json
tests/test_v081_wednesday_static.py
tests/test_v082_thursday_static.py
```

---

## 3. Branch and PR

Recommended branch:

```text
work/day-and-moment-flow-v0-84
```

Recommended PR title:

```text
runtime: add V0.84 day and moment flow
```

Expected scope:

- one new timeline state/helper script or one narrow phone adapter;
- one transition overlay scene/script;
- metadata updates to three active indexes;
- targeted tests;
- synchronized documentation.

Do not refactor base conversation rendering.

---

## 4. Runtime state

Add explicit ephemeral timeline state.

Recommended shape:

```gdscript
var unlocked_day_keys: Dictionary = {}
var completed_day_keys: Dictionary = {}
var current_phase_id_by_day: Dictionary = {}
var completed_phase_ids_by_day: Dictionary = {}
var skipped_phase_ids_by_day: Dictionary = {}
var expired_conversation_ids_by_day: Dictionary = {}
```

The prototype currently resets on launch, so no save migration is required.

Initial state:

```text
Tuesday unlocked and active
Wednesday locked
Thursday locked
```

Archived days remain readable after completion.

---

## 5. Index metadata

Add `timeline_flow` to active indexes.

### Tuesday temporary mapping

V0.84 may use the current active J1 episodes only as a temporary bridge:

```text
phase 1: current Marie conversation required
phase 2: current Sandra conversation required
day complete
```

V0.85 will replace this mapping with the reconciled Tuesday phases and offline beats.

### Wednesday mapping

```text
phase 1 — 12:10 Marie make room required
phase 2 — 18:18 Marie arrival trace required
phase 3 — 18:22 Mathilde arrival required
phase 4 — branch-specific offline beat complete
Wednesday complete
```

### Thursday mapping

```text
phase 1 — 09:10 Raphaëlle required
phase 2 — 13:50 Sandra optional
phase 3 — 16:05 Marie required
phase 4 — selected O5 branch required
phase 5 — 22:10 Marie return required
Thursday complete
```

---

## 6. Phase activation

Only conversations belonging to:

- completed phases; or
- the current phase

may be visible.

Future-phase conversations are hidden even if their old unlock rule would otherwise evaluate true.

Past completed conversations remain visible as history.

Expired optional conversations are not visible as actionable threads.

---

## 7. Required completion

A required phase completes when every `required_conversation_id` is complete.

Completion must be tracked by source episode ID, not only persistent thread ID.

Reason:

- Marie may have multiple episodes in one thread;
- completing an older Marie episode must not satisfy a later phase.

Use the source conversation IDs already emitted by `conversation_completed`.

---

## 8. Optional phase handling

Thursday Sandra is the first required use case.

After Raphaëlle completes:

```text
activate 13:50 phase
Sandra becomes optional and available
Marie remains hidden
```

The interface displays:

```text
Passer à 16:05
```

### If Sandra is opened and completed

- mark optional conversation seen;
- phase may advance;
- no missed flag.

### If Player advances without opening Sandra

- mark `chapter_03_sandra_continuity` expired for this run;
- write `thursday_sandra_echo_missed`;
- hide the thread episode from active Thursday interaction;
- advance to 16:05 Marie.

### If Player opens Sandra but leaves before completion

Recommended V0.84 rule:

```text
advance is disabled until the opened optional conversation is completed
```

This avoids half-consumed conversations in the first foundation pass.

A later version may support abandonment/mutation explicitly.

---

## 9. Day navigation

### Initial UI

Show only Tuesday as active/selectable.

Wednesday and Thursday remain hidden by default.

### Completed archive

After Tuesday completes:

- Tuesday remains visible as archived;
- Wednesday becomes visible and active;
- Thursday remains hidden.

After Wednesday completes:

- Tuesday/Wednesday remain visible as archived;
- Thursday becomes active.

### Archive behavior

Opening an archived day must not:

- create pending badges;
- show notification banners;
- change the active narrative clock;
- reapply choices;
- reactivate expired scenes.

Provide a visible `Historique` or muted archived-state treatment if feasible without expanding scope.

---

## 10. Transition overlay

Create a narrow overlay such as:

```text
game/scenes/smartphone/TimelineTransitionView.tscn
game/scripts/ui/TimelineTransitionView.gd
```

or an equivalent dynamically built control.

Required presentation methods:

```text
show_moment_transition(card: Dictionary)
show_day_transition(end_card: Dictionary, start_card: Dictionary)
```

### Day transition sequence

Example:

```text
MARDI — FIN DE JOURNÉE
```

then:

```text
MERCREDI — MIDI
Faire de la place
```

### Input behavior

- block underlying phone input;
- allow skip only after minimum readable time;
- finish automatically;
- unlock/select the new day only at the correct transition point;
- clear itself safely on reset.

### Style

Reuse current phone colors and typography.

Do not introduce a new visual design system.

---

## 11. Intra-day transition

When advancing phases separated by hours, display a short card.

Required current transitions:

```text
MERCREDI — FIN DE JOURNÉE
18:18

MERCREDI — SOIR
18:22

JEUDI — DÉBUT D'APRÈS-MIDI
13:50

JEUDI — FIN D'APRÈS-MIDI
16:05

JEUDI — SOIR
branch time

JEUDI — NUIT
22:10
```

The transition card changes timeline state before notifications for the new phase appear.

---

## 12. Notification ordering

Correct order:

```text
phase becomes current
-> transition card completes
-> conversations in phase become available
-> pending state is set
-> notification may appear
```

Do not show Marie's 16:05 notification while the 13:50 phase is still active.

Do not show a future-day notification before the day-start card completes.

---

## 13. Existing unlock rules

V0.84 should preserve V0.82 condition evaluation for topology branches.

Recommended strategy:

- timeline phase controls whether an unlock rule may be processed;
- existing `after_conversation_completed`, `after_any_conversation_completed`, and `conditions` remain valid within the active phase;
- phase transitions activate the rules belonging to the next phase.

Do not remove the V0.82 condition foundation.

---

## 14. Day completion definitions

### Temporary Tuesday

Until V0.85:

```text
current Sandra episode completed
-> Tuesday complete
```

V0.85 replaces this with a mandatory final Marie offline beat.

### Wednesday

```text
Mathilde arrival episode and branch offline beat completed
-> Wednesday complete
```

### Thursday

```text
chapter_03_marie_event_return completed
-> Thursday complete
```

Since Friday is not active yet, show:

```text
JEUDI — FIN DE JOURNÉE
La suite n'est pas encore disponible.
```

Do not create or expose Friday.

---

## 15. Reset behavior

Reset must restore:

```text
Tuesday active
Wednesday hidden
Thursday hidden
first Tuesday phase current
no expired Sandra flag
no transition overlay
no pending notification from later phases
```

Existing conversation histories and flags must clear according to the current reset behavior.

---

## 16. Tests

Add:

```text
tests/test_v084_temporal_flow_static.py
```

Cover:

- active indexes contain `timeline_flow`;
- only Tuesday initially unlocked;
- Wednesday/Thursday unlock sequence;
- phase IDs and required/optional episode IDs;
- Sandra optional phase precedes Marie;
- `thursday_sandra_echo_missed` on skip;
- future conversations hidden by phase;
- source episode completion tracking;
- transition overlay blocking/skip hooks;
- archive navigation does not mutate current time;
- day-end and day-start cards;
- reset behavior;
- Friday remains absent.

Update existing V0.82 tests that currently expect Sandra and Marie to unlock simultaneously.

The new expected behavior is sequential by phase.

---

## 17. Manual acceptance walkthrough

1. Launch: only Tuesday is visible.
2. Complete Tuesday.
3. See `MARDI — FIN DE JOURNÉE`.
4. See `MERCREDI — MIDI / Faire de la place`.
5. Wednesday unlocks and selects automatically.
6. Complete Wednesday phases with visible time transitions.
7. See Wednesday end / Thursday start.
8. Thursday starts at Raphaëlle 09:10.
9. After Raphaëlle, only Sandra optional is available at 13:50.
10. Confirm Marie is not yet accessible.
11. Skip Sandra through `Passer à 16:05`.
12. Confirm Sandra expires and Marie unlocks.
13. Repeat after reset and complete Sandra instead; Marie unlocks only after explicit phase advance.
14. Complete one O5 branch and O6.
15. See Thursday end card; Friday remains absent.
16. Reopen Tuesday archive; confirm no pending badges or clock mutation.

---

## 18. Validation commands

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 -m unittest tests.test_v081_wednesday_static -v
python3 -m unittest tests.test_v082_thursday_static -v
python3 -m unittest tests.test_v084_temporal_flow_static -v
python3 tools/player_choice_text_check.py <active conversation files>
python3 tools/player_presence_check.py <active conversation files>
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

---

## 19. Explicit exclusions

V0.84 must not:

- rewrite J1 dialogue;
- add the reconciled J1 files;
- add Pauline/Nico or Friday;
- add R2 routes;
- add adult content;
- implement save migration;
- implement real-time clock simulation;
- implement random scheduling;
- delete legacy files;
- refactor the full phone/conversation architecture.

---

## 20. Rollback

Keep the implementation squashable.

All current indexes and conversations remain available.

Reverting the V0.84 squash commit restores the V0.82 navigation and unlock behavior without data migration.

---

## 21. Final rule

```text
V0.84 does not add more story.
It teaches the prototype when the existing story is allowed to happen.
```
