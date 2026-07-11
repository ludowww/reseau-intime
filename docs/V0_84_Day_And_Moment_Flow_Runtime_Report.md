# V0.84 — Day & Moment Flow Runtime Report

> Runtime foundation implementing the temporal-flow canon validated in V0.83.  
> V0.84 changes access, transitions, archives, and optional-scene expiry.  
> It does not rewrite J1 dialogue, add Friday, open R2, or add adult content.

## 1. Baseline

```text
Base version: V0.83
Base commit: c43ed6929d927c24f364577ca02be8a640a641d9
Branch: work/day-and-moment-flow-v0-84
```

Primary sources:

```text
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md
docs/runtime/V0_84_DAY_AND_MOMENT_FLOW_IMPLEMENTATION_PLAN.md
```

## 2. Product result

The phone no longer treats Tuesday, Wednesday, and Thursday as freely selectable debug pages.

Current lifecycle:

```text
Tuesday AVAILABLE / ACTIVE
Wednesday LOCKED
Thursday LOCKED
```

Completing Tuesday:

```text
MARDI — FIN DE JOURNÉE
-> MERCREDI — MIDI
-> Wednesday unlocks and becomes current
```

Completing Wednesday:

```text
MERCREDI — FIN DE JOURNÉE
-> JEUDI — MATIN
-> Thursday unlocks and becomes current
```

Completing Thursday:

```text
JEUDI — FIN DE JOURNÉE
La suite n'est pas encore disponible.
```

Friday remains absent.

## 3. New timeline state

New autoload:

```text
game/scripts/core/TimelineState.gd
```

It tracks ephemeral prototype state for:

- unlocked days;
- completed days;
- current day;
- current phase per day;
- completed phases;
- skipped phases;
- expired conversations;
- completed source episodes;
- opened optional conversations.

No save migration or persistence format is introduced.

Reset restores:

```text
Tuesday current
Wednesday locked
Thursday locked
no completed/skipped/expired phase
```

## 4. Timeline metadata in active indexes

The three active modular indexes now contain `timeline_flow`.

### Tuesday

```text
tuesday_marie
-> tuesday_sandra
-> Tuesday complete
-> Wednesday
```

This still uses the temporary filtered legacy J1. V0.85 will replace its content.

### Wednesday

```text
wednesday_make_room
-> wednesday_arrival_trace
-> wednesday_mathilde_arrival
-> Wednesday complete
-> Thursday
```

The final phase includes the existing branch-specific offline settling beat.

### Thursday

```text
thursday_raphaelle_work
-> thursday_sandra_optional
-> thursday_marie_offer
-> thursday_selected_topology
-> thursday_marie_return
-> Thursday complete
```

## 5. Transition interstitials

New files:

```text
game/scenes/smartphone/TimelineTransitionView.tscn
game/scripts/ui/TimelineTransitionView.gd
```

The overlay:

- covers and blocks the phone during transition;
- uses the existing dark visual language;
- has a minimum readable duration;
- permits mouse or keyboard skip only after that minimum;
- supports one-card moment transitions;
- supports two-card day-end/day-start transitions;
- leaves a neutral landing view for the new moment after closing.

Examples:

```text
JEUDI — DÉBUT D'APRÈS-MIDI
13:50
```

```text
MARDI — FIN DE JOURNÉE

MERCREDI — MIDI
Faire de la place · 12:10
```

## 6. Phase-gated access

New phone adapter:

```text
game/scripts/ui/PhonePrototypeV084.gd
```

It extends V0.82 rather than replacing the existing thread/choice engines.

A conversation is visible only when:

1. its day is unlocked;
2. its old sequential/conditional unlock rule is ready;
3. its temporal phase is current or already completed;
4. it has not expired.

The implementation records completion by **source episode ID**, preserving persistent contact threads across days.

## 7. Thursday Sandra correction

After Raphaëlle at 09:10:

```text
13:50 Sandra becomes the only new optional window.
Marie 16:05 remains hidden.
```

The contact list exposes:

```text
Passer à 16:05
```

If Sandra is completed:

```text
Continue toward 16:05
```

If Sandra was never opened and Player advances:

- the Sandra episode is marked expired;
- its pending state is removed;
- `thursday_sandra_echo_missed` is set;
- Marie 16:05 becomes current;
- Sandra cannot be answered afterward at the old time.

If Sandra was opened but not completed, advancement is blocked until the exchange finishes.

## 8. Topology and Marie return preserved

V0.84 does not change M1 or any O5/O6 line.

The existing V0.82 guarantees remain:

- one topology flag;
- exactly one O5 branch;
- branch-specific time card;
- O6 Marie required after any O5;
- Thursday completes only after O6.

## 9. Read-only archives

Completed days remain visible with:

```text
Journée terminée · lecture seule
```

New conversation adapter:

```text
game/scripts/ui/ConversationViewV084.gd
```

It:

- annotates rendered history by source episode;
- filters an archived contact to the episodes from the selected day;
- prevents Tuesday archives from revealing Wednesday/Thursday segments in the same persistent thread;
- shows no choices;
- reapplies no effects;
- emits no pending state or notification;
- does not move narrative time;
- renders archived visual entries without unlocking content again.

## 10. Active runtime files

### Added

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/ConversationViewV084.gd
game/scripts/ui/TimelineTransitionView.gd
game/scenes/smartphone/TimelineTransitionView.tscn
tests/test_v084_temporal_flow_static.py
```

### Updated

```text
game/project.godot
game/scripts/core/DataLoader.gd
game/scenes/smartphone/PhonePrototype.tscn
game/scenes/smartphone/ConversationView.tscn
game/data/conversations/chapter_01_modular_index.json
game/data/conversations/chapter_02_modular_index.json
game/data/conversations/chapter_03_modular_index.json
tests/test_v081_wednesday_static.py
tests/test_v082_thursday_static.py
```

## 11. Narrative scope verification

V0.84 changes no conversation line.

It adds no:

- reconciled J1 content;
- Friday index;
- Pauline or Nico conversation;
- R2 state;
- adult image;
- hard secret;
- route score;
- real-time clock;
- random scheduler;
- save migration;
- deletion of legacy data.

V0.82 remains the narrative-content baseline while the timing foundation changes access.

## 12. Tests

New static module:

```text
tests/test_v084_temporal_flow_static.py
```

Coverage includes:

- TimelineState autoload and state fields;
- initial Tuesday-only visibility;
- day chain Tuesday -> Wednesday -> Thursday;
- ordered phases in all active indexes;
- Sandra expiry before Marie;
- source-episode completion;
- preservation of V0.82 conditions;
- transition overlay input behavior;
- read-only, day-scoped archives;
- reset behavior;
- Friday absence.

V0.81 and V0.82 regression tests are updated only for the new V0.84 adapter inheritance.

## 13. Validation commands

Run before merge:

```bash
python3 tools/validate_game_data.py
python3 -m unittest \
  tests.test_godot_prototype_static \
  tests.test_v081_wednesday_static \
  tests.test_v082_thursday_static \
  tests.test_v084_temporal_flow_static \
  -v
python3 tools/player_choice_text_check.py \
  game/data/conversations/chapter_02_marie_make_room.json \
  game/data/conversations/chapter_02_marie_arrival_trace.json \
  game/data/conversations/chapter_02_mathilde_arrival.json \
  game/data/conversations/chapter_03_raphaelle_blue_folder.json \
  game/data/conversations/chapter_03_sandra_continuity.json \
  game/data/conversations/chapter_03_marie_event_offer.json \
  game/data/conversations/chapter_03_marie_event_joined.json \
  game/data/conversations/chapter_03_mathilde_home_charger.json \
  game/data/conversations/chapter_03_raphaelle_late_review.json \
  game/data/conversations/chapter_03_marie_event_return.json
python3 tools/player_presence_check.py \
  game/data/conversations/chapter_02_marie_make_room.json \
  game/data/conversations/chapter_02_mathilde_arrival.json \
  game/data/conversations/chapter_03_raphaelle_blue_folder.json \
  game/data/conversations/chapter_03_sandra_continuity.json \
  game/data/conversations/chapter_03_marie_event_offer.json \
  game/data/conversations/chapter_03_marie_event_joined.json \
  game/data/conversations/chapter_03_mathilde_home_charger.json \
  game/data/conversations/chapter_03_raphaelle_late_review.json \
  game/data/conversations/chapter_03_marie_event_return.json
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

The current GitHub connector cannot execute these commands. Results must be supplied by Hermes/local/CI before merge.

## 14. Manual walkthrough

1. Reset: only Tuesday is visible.
2. Complete Marie Tuesday: the `MARDI — NUIT / 22:57` card appears and Sandra becomes current.
3. Complete Sandra: Tuesday end and Wednesday start cards appear; Wednesday becomes selected.
4. Reopen Tuesday: it is read-only and does not show Wednesday episodes in Marie's thread.
5. Complete Wednesday phases: each time jump receives a card; Thursday stays hidden until Mathilde's offline beat completes.
6. Thursday opens at 09:10 with Raphaëlle only.
7. Complete Raphaëlle: Sandra becomes optional at 13:50; Marie remains hidden.
8. Skip Sandra: she disappears, `thursday_sandra_echo_missed` is set, and Marie appears after the 16:05 card.
9. Alternative run: open Sandra; the advance button is blocked until completion, then allows continuation.
10. Complete M1 and one O5 branch: only the selected branch appears, followed by O6 at 22:10.
11. Complete O6: Thursday end card appears; Friday remains unavailable.
12. Reopen any completed day: no badge, notification, choice, effect, time change, or future-day leakage.

## 15. Rollback

V0.84 is designed for squash merge.

Reverting the squash commit restores:

- V0.82 day-menu navigation;
- V0.82 simultaneous Thursday availability;
- prior phone/conversation adapters;
- no data migration requirement.

All legacy files remain present.

## 16. Next step

After Product Owner validation and executable checks:

```text
V0.85 — J1 Canon Runtime Reconciliation
```

V0.85 will replace active Tuesday content only. It must not alter the V0.84 timeline foundation or Wednesday/Thursday story meaning.

## 17. Final rule

```text
V0.84 adds no new story.
It makes the existing story happen in an order the player can actually feel and cannot rearrange.
```
