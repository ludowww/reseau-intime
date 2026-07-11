# Narrative Canon Status — Current

> Narrative and implementation status after V0.85 J1 runtime reconciliation.  
> Runtime is playable through Thursday with chronological access.  
> Tuesday now uses current canon rather than filtered legacy dialogue; Friday remains postponed.

## 1. Core rule

```text
V0.78 defines modular story movement.
V0.79 defines the Tuesday–Friday opening content.
V0.80 defines phased runtime integration.
V0.81 implements Wednesday.
V0.82 implements Thursday topology and Marie return.
V0.83 defines authoritative temporal flow and the J1 replacement.
V0.84 makes temporal flow authoritative in runtime.
V0.85 replaces active Tuesday with the reconciled J1.
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
docs/canon/J1_RUNTIME_RECONCILIATION_SCENE_CARDS.md
docs/V0_84_Day_And_Moment_Flow_Runtime_Report.md
docs/runtime/V0_85_J1_CANON_RUNTIME_RECONCILIATION_PLAN.md
docs/V0_85_J1_Canon_Runtime_Reconciliation_Report.md
```

Read current character canon and global NSFW canon when relevant.

## 3. Current playable access

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

## 4. Current Tuesday — canonical J1

Active sequence:

```text
18:12 Marie remote opening
-> M1 presence posture

19:15 / 19:35
-> dinner and walk offline

22:57 Sandra soft trace
-> S1 trace-reading posture

23:25 / 23:28
-> final Marie/shared-life offline return

Tuesday complete
```

Active source files:

```text
game/data/conversations/chapter_01_marie_opening.json
game/data/conversations/chapter_01_sandra_trace.json
```

### Marie opening guarantees

- bread is still a future action when Player chooses;
- Player and Marie are physically separated while messaging;
- M1 offers exactly three comparable presence postures;
- La Verrière seeds Thursday without opening it;
- Mathilde remains indirect only;
- no numeric route effect.

### Shared evening guarantee

Player returns with the bread, dinner happens, and the short walk happens face to face.

No Messenger transcript replaces co-presence.

### Sandra guarantee

Sandra returns through one imperfect lunch photograph.

The exchange contains:

- one concrete trace;
- SentryCore/work color;
- one S1 node with three choices;
- a soft boundary initiated by Sandra;
- no route activation.

It contains no:

- Tuesday/Wednesday contradiction;
- 24:xx timestamp;
- lake/nature expansion;
- romance-novel exposition;
- deep Player confession;
- attachment/priority score.

### Final Marie guarantee

Tuesday cannot complete immediately after Sandra.

The mandatory final offline phase returns Player to Marie/shared life and sets `j1_day_complete` before Wednesday unlocks.

## 5. Current temporal state

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
game/scripts/ui/PhonePrototypeV085.gd
game/scripts/ui/TimelineTransitionView.gd
game/scripts/ui/ConversationViewV084.gd
```

V0.85 adds day-log entries for authored offline phases. They are displayed once during play and restored read-only in completed-day archives.

Core rule:

```text
Time labels describe chronology.
Timeline state controls access.
```

## 6. Current day sequence

### Tuesday

```text
18:12 Marie required
-> 19:15/19:35 shared evening offline
-> 22:57 Sandra required
-> 23:25/23:28 final Marie return offline
-> Tuesday complete
```

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

## 7. Choice/state status

J1 meaningful nodes:

```text
M1 = present / playful-present / delayed-flat
S1 = safe warmth / precise observation / cautious
```

J1 writes only observable flags:

```text
j1_marie_present
j1_marie_playful_present
j1_marie_delayed_flat
j1_shared_evening_due
j1_shared_evening_completed
j1_marie_return_active / delayed
j1_sandra_safe_warmth
j1_sandra_precise_observation
j1_sandra_cautious
j1_sandra_trace_complete
j1_marie_final_return_present / delayed
j1_day_complete
```

No J1 affection, trust, neglect, truth, attachment, priority, or route score is written.

## 8. Archive behavior

Completed days are read-only.

Archive access:

- creates no pending marker or notification;
- offers no new choice;
- applies no effect;
- does not change current day, phase, or status time;
- cannot reactivate expired content;
- filters persistent-thread history by source episode/day;
- lists authored offline phases once under `Moments hors ligne`.

## 9. Historical J1 files

The former active files remain on disk but are inactive:

```text
game/data/conversations/chapter_01_marie.json
game/data/conversations/chapter_01_sandra.json
```

They are retained for rollback/history only.

Do not restore them through active-index filtering.

## 10. Current route and character status

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra J1 = soft trace seed only
Mathilde = R1 Ordinary Access after Wednesday
Raphaëlle = R1 Ordinary Work Access after Thursday
Pauline = inactive
Nico = inactive
hard secrets = none
adult frames = none
Friday = not implemented
```

## 11. Validation status

V0.84 was validated before merge.

V0.85 adds dedicated static coverage in:

```text
tests/test_v085_j1_reconciliation_static.py
```

Executable validation and both Godot headless boots must be confirmed by Hermes/local/CI before V0.85 merge.

## 12. Roadmap

```text
V0.85 — J1 canon runtime reconciliation
V0.86 — Friday public traces and opening completion
```

Friday must not begin before V0.85 is validated.

## 13. Final rule

```text
Current playable story ends Thursday night.
Its order is authoritative.
Its first evening now says what the canon means.
```
