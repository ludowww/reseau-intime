# V0.86a — Temporal UX & Unread Notification Polish Plan

> Small UX/runtime polish pass requested during V0.86 review.  
> No narrative lines, route states, image rules, or character canon are changed.

## Goals

1. Replace technical time-jump labels such as `Continuer vers 16:05` with a natural progression action.
2. Remove automatic intra-day transition cards.
3. Make end-of-day transition player-triggered so the last message remains readable.
4. Surface incoming messages from another thread inside the currently open conversation as a clickable shortcut.
5. Make unread contacts immediately identifiable.

## Product decisions

### Intra-day progression

- No automatic full-screen moment card between phases.
- Optional-phase advance button label: `Continuer la journée`.
- The status bar and contact timestamps remain the time cues.

### End of day

- Completing the final required phase does not immediately open the transition overlay.
- The conversation remains visible.
- A `Finir la journée` button appears in the left conversation list.
- Only clicking that button displays the end-day/start-next-day transition.

### Contextual notification

When another thread receives a new message while a conversation is open:

- display a compact banner directly below the current conversation header;
- show contact name, short preview, and current narrative time;
- clicking the banner opens the target thread;
- the existing left-side contact list remains the main day-level contact hub;
- no separate Contacts application is added.

### Unread styling

Unread contact cards use:

- bold contact name;
- stronger preview text;
- more visible unread dot and `non lu` label;
- accent border/background already provided by the pending card style.

Read, active, archived, and unread states must remain distinct.

## Runtime strategy

Use narrow adapters:

```text
game/scripts/ui/PhonePrototypeV086A.gd
game/scripts/ui/ConversationViewV086A.gd
```

They extend the current V0.85/V0.84 adapters and preserve V0.86 data.

No scheduler refactor, save migration, or narrative-data rewrite.

## Expected files

- `game/scripts/ui/PhonePrototypeV086A.gd`
- `game/scripts/ui/ConversationViewV086A.gd`
- `game/scenes/smartphone/PhonePrototype.tscn`
- `game/scenes/smartphone/ConversationView.tscn`
- targeted tests
- minimal README/roadmap/runtime-doc updates

## Validation

```bash
python3 tools/validate_game_data.py
python3 -m unittest \
  tests.test_godot_prototype_static \
  tests.test_v081_wednesday_static \
  tests.test_v082_thursday_static \
  tests.test_v084_temporal_flow_static \
  tests.test_v085_j1_reconciliation_static \
  tests.test_v086_friday_opening_static \
  tests.test_v086a_temporal_ux_static \
  -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

## Explicit exclusions

- no narrative edits;
- no Friday scope expansion;
- no app-wide contact redesign;
- no route/state changes;
- no R2 or adult escalation;
- no new timeline scheduler;
- no legacy-data deletion.
