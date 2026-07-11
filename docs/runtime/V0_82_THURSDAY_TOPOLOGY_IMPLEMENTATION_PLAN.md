# V0.82 — Thursday Topology & Mandatory Marie Return — Implementation Plan

> Runtime implementation specification for the Thursday O3–O6 slice.  
> Based on validated V0.79 source lines/cards/temporal map and the phased V0.80 plan.  
> This plan intentionally excludes Friday, R2 routes, hard secrets, and adult content.

## 1. Goal

Extend the active modular runtime from Wednesday night through Thursday night:

```text
Thursday morning
-> O3 Raphaëlle ordinary work

Thursday early afternoon
-> optional Sandra continuity echo

Thursday late afternoon
-> O4 Marie offers movement / M1

Thursday evening
-> exactly one of O5A / O5B / O5C

Thursday night
-> O6 mandatory Marie consequence
```

The implementation must prove:

- flag-conditioned conversation unlocks;
- flag-conditioned authored messages and guided replies;
- exactly one topology branch;
- mandatory return to Marie after every branch;
- persistent contact history across days;
- realistic remote / same-venue / separate-room / work / offline communication;
- no route stage above R1.

---

## 2. Active day structure

Add:

```text
game/data/conversations/chapter_03_modular_index.json
```

Metadata:

```text
calendar_label = Jeudi
display_label = Jeudi — Être là
day_start_time = 09:10
window_range = O3–O6
route_stage_ceiling = R1
```

Active moments:

```text
09:10 — Raphaëlle blue-folder review
13:50 — Sandra continuity echo
16:05 — Marie event offer
17:45 — work topology branch
17:55 — joined topology branch
18:20 — home topology branch
22:10 — mandatory Marie return
```

Only currently unlocked moments may influence contact metadata or phone time.

---

## 3. Conversation files

Create:

```text
chapter_03_raphaelle_blue_folder.json
chapter_03_sandra_continuity.json
chapter_03_marie_event_offer.json
chapter_03_marie_event_joined.json
chapter_03_mathilde_home_charger.json
chapter_03_raphaelle_late_review.json
chapter_03_marie_event_return.json
```

Persistent threads:

```text
Marie      -> thread_marie_private
Sandra     -> thread_sandra_private
Mathilde   -> thread_mathilde_private
Raphaëlle  -> thread_raphaelle_private
```

No Pauline or Nico thread opens in V0.82.

---

## 4. Unlock topology

Initial Thursday episode:

```text
chapter_03_raphaelle_blue_folder
```

After Raphaëlle completes, unlock simultaneously:

```text
chapter_03_sandra_continuity  (pending, no banner notification)
chapter_03_marie_event_offer  (pending, banner notification)
```

M1 writes exactly one topology flag:

```text
opening_topology_join_marie
opening_topology_stay_home
opening_topology_work_then_join
```

After Marie's offer, conditionally unlock exactly one:

```text
opening_topology_join_marie
-> chapter_03_marie_event_joined

opening_topology_stay_home
-> chapter_03_mathilde_home_charger

opening_topology_work_then_join
-> chapter_03_raphaelle_late_review
```

After any one branch completes, unlock:

```text
chapter_03_marie_event_return
```

Required unlock extensions:

```text
conditions: [flag...]
after_any_conversation_completed: [conversation IDs...]
notify: false for optional silent echoes
```

No scheduler or generalized event queue is introduced.

---

## 5. Conditional authored content

Add a narrow V0.82 conversation adapter supporting:

```text
conditions
unless_conditions
```

on:

- messages;
- authored temporal/offline items;
- guided-reply choices.

Every condition is evaluated through `EffectApplier.condition_is_met`.

O6 uses one conversation file with conditional Marie lines and conditionally visible guided acknowledgements.

If the active variant has no Player acknowledgement, the segment must complete without rendering `Aucun choix direct...`.

---

## 6. Cross-day persistent-thread correction

V0.81 reused thread IDs across days, but the base conversation merge keeps the stored conversation whenever the newly opened day has fewer segments.

V0.82 must override the merge behavior to:

- preserve stored history;
- append unseen segments from the new day by stable source/segment key;
- merge episode IDs without duplication;
- keep current segment/history state;
- allow a completed Tuesday/Wednesday Marie thread to auto-advance into Thursday when new segments unlock.

Do not reset conversation history on day switch.

Do not copy all previous-day files into every new index.

---

## 7. Choice flags

### Raphaëlle R0

```text
raphaelle_work_accountable
raphaelle_work_playful
raphaelle_work_delayed
raphaelle_r1_established
```

### M1 topology

```text
opening_topology_join_marie
opening_topology_stay_home
opening_topology_work_then_join
join_after_work_obligation (M1C only)
```

### MA0 joined branch

```text
marie_event_initiative
marie_event_playful_help
marie_event_distracted
couple_reconnection_candidate (A/B)
couple_presence_strained (C)
```

### MH0 home branch

```text
mathilde_home_help
mathilde_home_playful_help
mathilde_home_distance
household_participation_positive (A/B)
parallel_drift_candidate (C)
```

### RW0 work branch

```text
work_promise_kept
work_promise_amended
work_promise_missed
couple_reconnection_candidate (kept)
parallel_drift_candidate (missed)
```

No numeric route/couple effects.

---

## 8. Communication modes

```text
O3 Raphaëlle      = WORK_CHAT
Sandra echo       = REMOTE_ASYNC
O4 Marie          = REMOTE_ASYNC
O5A Marie         = SAME_VENUE_LOGISTICS
O5B Mathilde      = SEPARATE_ROOMS_PING -> OFFLINE_BEAT for A/B
O5C Raphaëlle     = WORK_CHAT
O6 Marie          = AFTERGLOW_REMOTE in runtime variants
```

V0.82 does not simulate long face-to-face conversations through Messenger.

The joined branch's emotional evaluation remains in O6 after physical separation.

---

## 9. Visuals

Add one current Thursday visual bundle:

```text
game/data/visual_content/chapter_03_proofs.json
```

Current item:

```text
marie_laverriere_setup_01
```

Properties:

- authorized event image;
- taken with Marie's knowledge;
- social/event context;
- no erotic crop;
- not a proof;
- low risk;
- no forwarding into an adult context.

No Raphaëlle personal image, Mathilde body image, Pauline crop, Nico image, or hidden capture.

---

## 10. Runtime adapters

Create:

```text
game/scripts/ui/PhonePrototypeV082.gd
game/scripts/ui/ConversationViewV082.gd
```

They extend V0.81 adapters.

### Phone adapter responsibilities

- conditional unlock rules;
- `after_any_conversation_completed`;
- optional banner notifications;
- condition-filtered contact subtitles/choice badges;
- preserve V0.81 time behavior.

### Conversation adapter responsibilities

- condition-filtered messages and choices;
- suppress empty choice hints for consequence-only variants;
- cumulative cross-day segment merge;
- preserve V0.81 authored-time/offline handling.

Update smartphone scenes to point to V0.82 adapters.

---

## 11. Test plan

Add:

```text
tests/test_v082_thursday_static.py
```

Cover:

- active indexes Tuesday–Thursday;
- V0.82 scene adapter wiring;
- V0.82 adapters extend V0.81;
- exact Thursday conversations/times;
- simultaneous Raphaëlle -> Sandra + Marie unlock;
- Sandra `notify: false`;
- three M1 topology choices;
- exactly one conditional branch rule per topology flag;
- O6 `after_any_conversation_completed` rule;
- exact three choices in R0/MA0/MH0/RW0;
- condition-filtered O6 variants;
- no automatic non-guided Player messages;
- cumulative thread merge hooks;
- `marie_laverriere_setup_01` metadata;
- no Friday, Pauline, Nico, R2, NTR, adult, or hard-secret content.

Update the V0.81 adapter-wiring test to expect the V0.82 adapters while preserving the inheritance chain.

---

## 12. Validation commands

Run before merge:

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 -m unittest tests.test_v081_wednesday_static -v
python3 -m unittest tests.test_v082_thursday_static -v
python3 tools/player_choice_text_check.py <active Thursday conversation files>
python3 tools/player_presence_check.py <active choice-bearing Thursday files>
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

The GitHub connector cannot execute these commands; CI/local Hermes must confirm them.

---

## 13. Explicit exclusions

Do not implement:

- Friday O7/O8;
- Pauline or Nico threads;
- public group-photo relay;
- route R2+;
- hard secrets;
- adult content;
- open-couple negotiation;
- NTR/cuckold logic;
- universal scheduler;
- save migration;
- legacy data deletion;
- major base-script refactor.

---

## 14. Acceptance rule

```text
V0.82 succeeds when Thursday offers one real topology choice,
opens exactly one context-specific evening,
and always brings the consequence back to Marie.

The other two branches remain unavailable,
and Friday remains absent.
```
