# V0.81 — Tuesday Handoff & Wednesday Runtime Vertical Slice Report

> First runtime implementation of the modular post-J1 architecture.  
> Scope is intentionally limited to the Tuesday handoff and Wednesday O1–O2 slice.  
> Thursday, Friday, adult routes, and condition-aware topology remain out of scope.

## 1. Baseline

```text
Base version: V0.80
Base commit: 7ded8f95e374368e866788f893ce56a910cd0458
Branch: work/wednesday-modular-runtime-slice-v0-81
```

Narrative sources:

```text
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
```

Technical source:

```text
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
```

## 2. Implemented product slice

### Tuesday

The active runtime no longer presents Mathilde as already installed.

The modular Tuesday index filters:

```text
msg_marie_291
msg_marie_292
j1_mathilde_bag_domestic_trace
```

Therefore the active J1 does not show:

- bags in the entrance;
- shoes near the biscuits;
- sports/racket domestic occupation;
- the old Mathilde bag visual.

Marie and Sandra remain the only active Tuesday threads.

### Wednesday midday — O1

Marie announces Mathilde's water-damage emergency.

M0 has exactly three choices:

```text
proactive
playful-present
passive assent
```

The choices write flags only.

### Wednesday late afternoon — O2 trace

Marie sends:

```text
mathilde_arrival_room_01
```

The trace is:

- authorized;
- ordinary;
- private to the household context;
- low risk;
- not a proof;
- not an adult image.

### Wednesday evening — O2 Mathilde

Mathilde opens `thread_mathilde_private`.

MT0 has exactly three choices:

```text
practical welcome
teasing-helpful welcome
distant welcome
```

Each branch writes:

- one arrival-posture flag;
- `mathilde_stay_active`;
- `opening_wednesday_complete`.

When Player returns, the chat ends and the move-in continues face to face through an authored `offline_beat`.

## 3. Active data layout

The current loader exposes only:

```text
game/data/conversations/chapter_01_modular_index.json
game/data/conversations/chapter_02_modular_index.json
```

This differs intentionally from rewriting the original indexes in place.

Reason:

- legacy indexes remain intact for rollback and historical inspection;
- current navigation is explicit and auditable;
- no destructive migration is required;
- reverting the V0.81 squash commit restores the old loader immediately.

Legacy index paths remain listed separately in `DataLoader.gd` but are not loaded.

## 4. New runtime data

```text
game/data/conversations/chapter_01_modular_index.json
game/data/conversations/chapter_02_modular_index.json
game/data/conversations/chapter_02_marie_make_room.json
game/data/conversations/chapter_02_marie_arrival_trace.json
game/data/conversations/chapter_02_mathilde_arrival.json
game/data/visual_content/chapter_02_proofs.json
```

## 5. Runtime foundation

### DataLoader

V0.81 adds:

- canonical active-index whitelist;
- separate legacy index/visual lists;
- recursive conversation filters for the narrow J1 handoff correction;
- data-driven day labels and day-start times;
- unchanged persistent-thread grouping.

### Phone adapter

`PhonePrototypeV081.gd` adds:

- Tuesday/Wednesday display labels;
- data-driven status time;
- currently available episode metadata only;
- authored narrative-time updates;
- per-day time override memory;
- monotonic time comparison so a previous separator cannot move the clock backward;
- reset handling.

The base phone implementation remains intact.

### Conversation adapter

`ConversationViewV081.gd` adds semantic handling for:

```text
time_separator
offline_beat
```

Authored items:

- have no sender bubble;
- show no typing indicator;
- render as centered notes;
- persist in history;
- do not duplicate after reopening;
- emit narrative-time updates.

The base conversation engine remains intact.

### Scene wiring

```text
game/scenes/smartphone/PhonePrototype.tscn
game/scenes/smartphone/ConversationView.tscn
```

now point to the narrow V0.81 adapters.

## 6. Persistent threads

Marie Wednesday episodes both use:

```text
thread_marie_private
```

The phone therefore shows one Marie contact with progressively unlocked episodes.

Mathilde uses:

```text
thread_mathilde_private
```

A locked evening episode cannot leak its timestamp into the contact card before unlock.

## 7. Time progression

Current playable times:

```text
Tuesday start: 18:12
Wednesday start: 12:10
Marie arrival trace: 18:18
Mathilde thread: 18:22
Offline return: 18:46 / 18:50 / 19:15
```

The status-bar time is narrative metadata, not a real-time simulation.

It advances according to available episodes and authored offline events.

## 8. State writes

```text
opening_make_room_proactive
opening_make_room_playful
opening_make_room_passive
mathilde_arrival_practical
mathilde_arrival_playful
mathilde_arrival_distant
mathilde_stay_active
opening_wednesday_complete
```

No numeric effect is used by M0 or MT0.

V0.81 does not add or change:

- affection scores;
- desire scores;
- jealousy scores;
- dominant route;
- couple mode;
- relationship agreement;
- adult consent state.

## 9. Tests added

```text
tests/test_v081_wednesday_static.py
```

The test module covers:

- active/legacy loader separation;
- active adapter scene wiring;
- Tuesday handoff filters;
- exact Wednesday index and unlock chain;
- persistent thread IDs;
- communication-mode metadata;
- exact three-choice counts;
- flag-only state writes;
- Player lines remaining choice-driven;
- authored time separator and offline beats;
- offline-note persistence/deduplication hooks;
- ordinary low-risk visual metadata;
- exclusion of Thursday, Friday, and adult route material.

The legacy static test suite remains unchanged so historical files can still be inspected.

## 10. Validation limitation

The GitHub connector environment used for this implementation cannot:

- clone the repository through local DNS;
- execute Python validation commands against the branch;
- run the Godot binary.

Therefore no claim is made that the commands have executed successfully in this environment.

Before merge, run in CI or a local Hermes/Codex environment:

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 -m unittest tests.test_v081_wednesday_static -v
python3 tools/player_choice_text_check.py \
  game/data/conversations/chapter_02_marie_make_room.json \
  game/data/conversations/chapter_02_marie_arrival_trace.json \
  game/data/conversations/chapter_02_mathilde_arrival.json
python3 tools/player_presence_check.py \
  game/data/conversations/chapter_02_marie_make_room.json \
  game/data/conversations/chapter_02_mathilde_arrival.json
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

`tools/simulate_route_paths.py` may also be run as a legacy regression probe, but its output is not modular-canon truth.

## 11. Manual acceptance walkthrough

1. Launch the phone.
2. Confirm only Tuesday and Wednesday appear.
3. Open Tuesday and confirm the active Marie thread does not show the bags/shoes/racket trace.
4. Open Wednesday; confirm Marie shows 12:10.
5. Complete the guided reply and choose one of three M0 postures.
6. Confirm the Marie arrival episode unlocks at 18:18.
7. Open the arrival trace; confirm one `mathilde_arrival_room_01` placeholder.
8. Confirm Mathilde unlocks at 18:22.
9. Complete the guided reply and choose one of three MT0 postures.
10. Confirm one centered offline beat appears at the branch-specific return time.
11. Reopen the Mathilde thread; confirm the offline beat is present once, without a typing animation or sender.
12. Confirm Thursday and Friday are absent.

## 12. Explicit exclusions

V0.81 contains no:

- Raphaëlle Thursday scene;
- Sandra Thursday echo;
- Marie event invitation;
- O5 topology branch;
- O6 Thursday return;
- Pauline or Nico opening;
- condition-aware unlock engine;
- R2 route state;
- adult content;
- hard secret;
- save migration;
- universal scheduler;
- deletion of legacy data.

## 13. Rollback

The implementation is designed for squash merge.

Rollback:

1. revert the V0.81 squash commit;
2. scene files return to base scripts;
3. DataLoader returns to legacy active indexes;
4. all old files are still present;
5. no save or binary-asset migration is required.

## 14. Next step

After Product Owner validation and successful execution checks:

```text
V0.82 — Thursday topology and mandatory Marie return
```

V0.82 should add only the minimal flag-conditioned unlock and conditional-content support required by O3–O6.

## 15. Final rule

```text
V0.81 proves one thing well:
Tuesday can become Wednesday without breaking time, threads, choices, or physical communication realism.

Thursday branching remains a separate problem and a separate PR.
```
