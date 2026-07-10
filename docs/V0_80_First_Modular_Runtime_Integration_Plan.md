# V0.80 — First Modular Runtime Integration Plan

> Documentation-only implementation plan after the V0.79 opening-source pack.  
> No runtime, JSON, GDScript, tests, assets, or playable content are changed by V0.80.  
> Runtime work begins only after Product Owner validation.

## 1. Purpose

V0.79 defines the first modular opening from Tuesday evening through Friday.

V0.80 determines how to integrate it into the existing Godot prototype without:

- a large refactor;
- rewriting all legacy days at once;
- pretending the current fixed-day runtime already supports topology branches;
- exposing suspended J3+ content after the new opening;
- losing the realistic time and communication rules validated in V0.79.

The plan is based on direct inspection of the current runtime.

Detailed audit:

```text
docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
```

First implementation specification:

```text
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
```

---

## 2. Audit verdict

The prototype already has a useful data-first foundation:

- persistent contact threads;
- multiple episodes merged into one thread;
- segmented conversations;
- guided replies and multi-choice nodes;
- message history;
- message timestamps;
- sequential unlocks;
- notifications;
- flags and numeric effects;
- placeholder visual cards;
- contact-only conversation navigation.

The prototype does **not** yet have:

- conditional branch unlocks based on a selected choice;
- conditional message/segment rendering;
- a semantic offline-beat presentation;
- data-driven weekday labels and status-bar time;
- protection against exposing suspended legacy days;
- a current state model aligned with V0.78 route/couple architecture.

The correct strategy is therefore:

```text
reuse the existing thread and choice engine
add only the missing foundation needed by the next slice
integrate one chronological band at a time
```

---

## 3. Critical runtime continuity issue

The current J1 playable runtime still shows:

- Mathilde's bags in the entrance;
- her sports shoes;
- a sports bag / racket visual;
- wording implying she is already installed.

V0.79 canon requires:

```text
Tuesday evening = Mathilde indirect only
Wednesday = water-damage emergency and arrival
```

A narrow J1 handoff patch is therefore mandatory before Wednesday can be integrated.

V0.81 must remove the already-installed Mathilde trace and either:

- use the V0.69 indirect installation/light seed; or
- omit the optional Mathilde seed entirely.

It must not perform a broad J1 rewrite.

---

## 4. Integration principle

The full V0.79 opening must not be implemented in one PR.

A single O0–O8 implementation would combine:

- J1 compatibility work;
- weekday UI;
- offline beats;
- rewritten Chapter 2;
- branch-conditioned unlocks;
- conditional return variants;
- three new principal-character entries;
- several visuals;
- replacement of legacy navigation;
- extensive static-test rewrites.

That scope would violate the project's short-PR and no-large-refactor rules.

The approved implementation sequence should be:

```text
V0.81 — Tuesday handoff + Wednesday vertical slice
V0.82 — Thursday topology and mandatory Marie return
V0.83 — Friday public traces and household residue
```

Each slice remains independently testable and revertible.

---

# 5. V0.81 — Tuesday handoff + Wednesday vertical slice

## 5.1 Narrative scope

Implement:

```text
J1 Mathilde handoff correction
O1 Marie / make room
O2 Marie / arrival trace
O2 Mathilde / arrival
Wednesday offline settling beat
```

Do not implement Thursday or Friday.

## 5.2 Technical foundation

V0.81 adds only the foundation required by Wednesday:

- active-index whitelist for current canon days;
- Tuesday / Wednesday display labels;
- data-driven status-bar time;
- available-episode-only moment metadata;
- semantic `time_separator` and `offline_beat` presentation;
- current Chapter 2 visual bundle;
- flags for M0 and MT0;
- targeted static tests.

## 5.3 Active navigation

During V0.81, only the following indexes are active:

```text
chapter_01_index.json
chapter_02_index.json
```

Legacy J3+ files remain in the repository but are not selectable.

This prevents an incoherent jump from the new Wednesday into suspended old days.

## 5.4 State strategy

Use only explicit flags representing observed actions:

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

No new affection, desire, jealousy, route, or couple-mode score is added.

## 5.5 Acceptance target

V0.81 is complete when the player can:

- finish Tuesday without seeing Mathilde already installed;
- select Wednesday;
- see midday become evening;
- make room through three choices;
- receive the authorized arrival photo;
- open Mathilde's persistent thread;
- answer through three choices;
- see the phone exchange stop when Player returns;
- finish on an offline household-settling beat;
- see no current day after Wednesday.

Full specification:

```text
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
```

---

# 6. V0.82 — Thursday topology and Marie return

V0.82 is not implemented by the current plan, but its required foundation must be explicit so V0.81 does not paint the project into a corner.

## 6.1 Narrative scope

```text
O3 Raphaëlle ordinary work
conditional Sandra echo
O4 Marie offers movement
O5A Marie/social OR O5B Mathilde/home OR O5C Raphaëlle/work
O6 mandatory Marie return
```

## 6.2 Required branch flags

Recommended topology flags:

```text
opening_topology_join_marie
opening_topology_stay_home
opening_topology_work_then_join
```

Branch-quality flags remain scene-specific:

```text
marie_event_initiative
marie_event_playful_help
marie_event_distracted

mathilde_home_help
mathilde_home_playful_help
mathilde_home_distance

work_promise_kept
work_promise_amended
work_promise_missed
```

No numeric affection effects are required for the first topology pass.

## 6.3 Conditional unlock extension

Current runtime unlocks only by completed conversation ID.

V0.82 should allow an unlock rule to include:

```json
"conditions": [
  "opening_topology_join_marie"
]
```

Required logic:

```text
after_conversation_completed matches
AND every condition is currently met
-> unlock target
```

Implement a small helper such as:

```text
EffectApplier.conditions_are_met(conditions: Array) -> bool
```

It should evaluate every array entry through the existing `condition_is_met` function.

Do not build a general scheduler.

## 6.4 Conditional content extension

O6 must reflect the quality of the earlier branch.

V0.82 should support `conditions` on authored messages, message groups, or segments.

Recommended minimal rule:

```text
an item with no conditions renders
an item with conditions renders only when every condition is met
```

This permits one Marie return episode to contain validated variants without creating nine separate files.

The renderer must skip non-matching content before typing indicators or history recording.

## 6.5 One-foreground guarantee

Only one O5 conversation may unlock.

The other two remain unavailable for that event and must not queue for later unchanged.

The index/test contract should assert exactly one topology flag and exactly one O5 foreground unlocked.

## 6.6 Communication modes

- O3 Raphaëlle: `WORK_CHAT` from separate positions;
- Sandra echo: `REMOTE_ASYNC`;
- O4 Marie: `REMOTE_ASYNC` around 16h;
- O5A: `SAME_VENUE_LOGISTICS`, short only;
- O5B: `SEPARATE_ROOMS_PING`, stops on entry;
- O5C: `WORK_CHAT`, stops if co-present;
- O6: `AFTERGLOW_REMOTE` or `OFFLINE_BEAT` depending on branch context.

V0.82 must not simulate face-to-face relationship dialogue as chat.

---

# 7. V0.83 — Friday traces and residue

## 7.1 Narrative scope

```text
O7 Pauline public group-photo relay
O8 Nico saved-seat follow-up
household breather
opening-pack completion state
```

## 7.2 New active threads

Persistent thread IDs:

```text
thread_pauline_private
thread_nico_private
```

They open at R1 ordinary access only.

## 7.3 Visuals

Add the current authorized public set:

```text
laverriere_public_group_photo_set_01
```

If Thursday includes the setup image, also add:

```text
marie_laverriere_setup_01
```

The public group photo must preserve:

- known origin;
- photographed adults;
- public/social audience;
- no adult function;
- no private crop;
- no unauthorized forwarding.

## 7.4 Friday timing

```text
Friday morning = Pauline trace delivery
Friday afternoon = Nico follow-up
Friday late afternoon = household residue
```

Nico's default follow-up must not appear implausibly early after a late hospitality close.

## 7.5 Pack completion validation

At the end of V0.83 runtime:

```text
Mathilde stay active
Raphaëlle R1 established
Pauline R1 established
Nico R1 established
Sandra trace active or cooled
no hard secret
no adult frame
couple frame assumed exclusive
couple mode not forcibly changed
```

---

## 8. Runtime metadata contract

To keep data auditable without building a scheduler, each new conversation episode should include non-breaking metadata.

Recommended fields:

```json
{
  "window_id": "O1",
  "calendar_label": "Mercredi",
  "time_band": "MIDDAY",
  "communication_mode": "REMOTE_ASYNC",
  "foreground_role": "spine",
  "physical_context": "Marie à La Verrière ; Player au travail ou en trajet."
}
```

Allowed `foreground_role` values:

```text
spine
foreground
echo
consequence
breather
```

These fields may initially be used only by tests/debug documentation.

They should not trigger a runtime refactor.

---

## 9. Day and time presentation plan

## 9.1 Keep numeric compatibility

Continue storing:

```json
"day": 1
"day": 2
```

because current state/context APIs expect numeric days.

Add human-readable index metadata:

```json
"calendar_label": "Mardi"
"display_label": "Mardi — Les choses qu'on remarque"
"day_start_time": "18:12"
```

## 9.2 Data-driven status bar

Replace hardcoded `09:41` with a label updated from active day/moment metadata.

The status time represents the current narrative moment, not a real-time clock.

## 9.3 Contact-card metadata

Moment metadata must include only episodes currently available.

A locked evening episode must not make a midday card display `18:18`.

## 9.4 In-thread temporal markers

Support:

```text
time_separator
offline_beat
```

Examples:

```text
MERCREDI — FIN DE JOURNÉE
```

and:

```text
Player rentre. L'installation continue face à face.
```

These are not messages from a character.

---

## 10. Legacy-data strategy

The repository keeps legacy runtime files for:

- history;
- rollback;
- isolated technical recovery;
- future comparison.

The canonical loader should expose only completed current slices.

Recommended progression:

```text
V0.81 active indexes: 01, 02
V0.82 active indexes: 01, 02, 03
V0.83 active indexes: 01, 02, 03, 04 or another chosen active mapping
```

The exact numeric mapping for Thursday/Friday may be chosen during their integration plans.

Do not rename all legacy files in the first PR.

Do not delete them merely to make the active list clean.

---

## 11. State-model policy

The old initial state and debug route probe remain temporarily present.

They are not the current narrative source of truth.

For O1–O8 integration:

- prefer flags describing events;
- do not write dominant-route fields;
- do not add affection points merely because a choice is warm;
- do not convert `HABITUAL_WARMTH` into one integer;
- do not implement R0–R5 as a universal engine before scenes require it.

After V0.83, a later state-reconciliation pass may decide which conceptual dimensions deserve runtime structures.

---

## 12. Validation strategy

Each runtime slice must run:

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 tools/player_choice_text_check.py
python3 tools/player_presence_check.py
python3 tools/simulate_route_paths.py
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Additional slice-specific tests must assert:

- active index list;
- exact conversation files;
- choice counts;
- unlock chain;
- branch exclusivity when introduced;
- time labels;
- current content IDs;
- no Player messages outside choices;
- offline-beat rendering;
- no legacy day exposed;
- no adult route state.

`simulate_route_paths.py` remains a legacy regression probe until a later dedicated rewrite.

Its output must not be treated as modular-canon route truth.

---

## 13. Risk matrix

| Risk | Impact | Mitigation |
|---|---|---|
| J1 still implies Mathilde is installed | Wednesday contradiction | narrow J1 handoff patch in V0.81 |
| Legacy J3+ clickable | incoherent continuation | active-index whitelist |
| Future locked time shown early | breaks felt chronology | available-episode metadata filtering |
| Co-present chat feels artificial | undermines product premise | semantic offline beats + communication modes |
| Full O0–O8 PR becomes too large | review/rollback risk | split V0.81/V0.82/V0.83 |
| Old tests block correct content | false regression | narrow test reconciliation |
| Old route scores influence opening | premature route logic | flags only |
| Conditional branches unlock together | topology failure | condition-aware unlock in V0.82 |
| Return to Marie can be skipped | centrality failure | mandatory consequence unlock/test |
| Visual origin becomes ambiguous | consent/trace inconsistency | dedicated current bundles and metadata |

---

## 14. Acceptance criteria for V0.80

V0.80 is complete if it:

- documents the current runtime architecture accurately;
- identifies the J1 Mathilde handoff contradiction;
- explains why full O0–O8 integration is too large;
- defines a short V0.81 slice;
- identifies exact V0.81 files, flags, metadata, UI changes, tests, and exclusions;
- defines how Thursday conditional topology should be added later;
- defines how Friday access should follow;
- preserves time and communication realism;
- keeps old files for rollback but hides them from current navigation;
- avoids numeric route-score expansion;
- leaves runtime untouched.

---

## 15. Current roadmap after approval

```text
V0.80 — First Modular Runtime Integration Plan
V0.81 — Tuesday handoff + Wednesday runtime vertical slice
V0.82 — Thursday topology and Marie return
V0.83 — Friday public traces and opening completion
```

No later slice begins before the previous one is validated in runtime.

---

## 16. Final rule

```text
Do not teach the prototype every future route at once.

First, make Tuesday hand cleanly into Wednesday.
Then teach one real branch on Thursday.
Then let Friday remember what happened.

The modular architecture should grow by validated use,
not by speculative systems.
```
