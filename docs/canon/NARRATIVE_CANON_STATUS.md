# Narrative Canon Status — Current

> Narrative and implementation status after V0.84 day-and-moment flow integration.  
> Runtime is playable through Thursday with chronological access.  
> Active J1 dialogue remains temporary legacy content until V0.85; Friday remains postponed.

## 1. Core rule

```text
V0.78 defines modular story movement.
V0.79 defines the Tuesday–Friday opening content.
V0.80 defines phased runtime integration.
V0.81 implements Wednesday.
V0.82 implements Thursday topology and Marie return.
V0.83 defines authoritative temporal flow and the J1 replacement.
V0.84 makes temporal flow authoritative in runtime.
Legacy runtime is not automatic narrative canon.
```

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
docs/V0_83_Temporal_Flow_And_J1_Reconciliation_Report.md
docs/runtime/V0_84_DAY_AND_MOMENT_FLOW_IMPLEMENTATION_PLAN.md
docs/V0_84_Day_And_Moment_Flow_Runtime_Report.md
docs/runtime/V0_85_J1_CANON_RUNTIME_RECONCILIATION_PLAN.md
```

Read current character canon and global NSFW canon when relevant.

## 3. Current playable access

The loader contains Tuesday, Wednesday, and Thursday indexes, but only Tuesday is initially visible.

```text
launch
-> Tuesday active
-> Wednesday locked
-> Thursday locked
```

Day progression:

```text
Tuesday complete
-> Tuesday end card
-> Wednesday start card
-> Wednesday unlock/select

Wednesday complete
-> Wednesday end card
-> Thursday start card
-> Thursday unlock/select

Thursday complete
-> Thursday end card
-> no Friday yet
```

Completed days remain available as read-only archives.

## 4. Current temporal state

Day lifecycle:

```text
LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
```

Phase lifecycle:

```text
LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

Runtime sources:

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/TimelineTransitionView.gd
game/scripts/ui/ConversationViewV084.gd
```

Core rule:

```text
Time labels describe chronology.
Timeline state controls access.
```

## 5. Current day sequence

### Tuesday

Temporary V0.84 phase structure:

```text
18:12 Marie required
-> 22:57 Sandra required
-> Tuesday complete
```

This still uses the filtered legacy J1 content and is not the final Tuesday truth.

### Wednesday

```text
12:10 Marie / make room
-> 18:18 Marie / arrival trace
-> 18:22 Mathilde / arrival + offline settling
-> Wednesday complete
```

### Thursday

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> explicit advance
-> Sandra complete or expired
-> 16:05 Marie required
-> one O5 topology branch
-> 22:10 Marie return required
-> Thursday complete
```

## 6. Thursday Sandra behavior

After Raphaëlle, Marie does not unlock at the same time as Sandra.

Sandra becomes the current optional window at 13:50.

The player may:

- open and complete Sandra, then continue;
- skip the unopened window and advance.

On skip:

```text
chapter_03_sandra_continuity = EXPIRED
thursday_sandra_echo_missed = true
```

An opened but incomplete Sandra exchange blocks advancement. After reaching 16:05, the expired 13:50 conversation cannot be answered.

## 7. Interstitials and time presentation

V0.84 adds:

- blocking day-end/day-start cards;
- shorter intra-day cards;
- minimum readable display time;
- optional click/keyboard skip after that minimum;
- a neutral landing screen for the newly active moment.

Examples:

```text
MARDI — FIN DE JOURNÉE

MERCREDI — MIDI
Faire de la place · 12:10
```

```text
JEUDI — FIN D'APRÈS-MIDI
16:05
```

## 8. Archive behavior

Completed days are read-only.

Archive access:

- creates no pending marker or notification;
- offers no new choice;
- applies no effect;
- does not change current day, phase, or status time;
- cannot reactivate expired content;
- filters persistent-thread history by source episode, preventing future-day leakage into an earlier archive.

## 9. Active J1 debt

V0.84 deliberately does not rewrite J1 dialogue.

Confirmed active Tuesday issues remain until V0.85:

- wrong weekday line;
- non-monotonic bubble timestamps;
- all Marie before all Sandra;
- no real dinner/walk offline beat;
- day ends on Sandra instead of Marie/shared life;
- Sandra progresses beyond soft-trace scope;
- old numeric state effects;
- excessive one-option clicking.

These are documented debt, not canon to preserve.

## 10. V0.85 target

V0.85 will replace active Tuesday with new concise files:

```text
18:12 Marie remote opening + M1
19:15 dinner/walk offline beat
22:57 Sandra soft trace + S1
23:25 final Marie/shared-life offline beat
Tuesday complete -> Wednesday
```

J1 state will use flags only.

V0.85 must preserve the V0.84 day/phase/interstitial/archive foundation and must not alter Wednesday/Thursday story meaning.

## 11. Current route and character status

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Mathilde = R1 Ordinary Access
Raphaëlle = R1 Ordinary Work Access
Sandra = soft continuity or expired Thursday echo
Pauline = inactive
Nico = inactive
hard secrets = none
adult frames = none
Friday = not implemented
```

V0.84 adds only temporal/expiry state.

## 12. Validation status

V0.82 was validated before merge.

V0.84 adds dedicated static coverage in:

```text
tests/test_v084_temporal_flow_static.py
```

Executable validation and both Godot headless boots must be confirmed by Hermes/local/CI before V0.84 merge.

## 13. Roadmap

```text
V0.84 — day and moment flow runtime foundation
V0.85 — J1 canon runtime reconciliation
V0.86 — Friday public traces and opening completion
```

Friday must not begin before V0.85 is validated.

## 14. Final rule

```text
Current playable story still ends Thursday night.
V0.84 makes its order authoritative.
V0.85 will make its first evening truthful.
```
