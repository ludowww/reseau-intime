# V0.86a — Temporal UX & Unread Notification Polish Plan

> Small UX/runtime polish pass requested during V0.86 review.  
> No narrative lines, route states, image rules, or character canon are changed.

## Goals

1. Remove scheduler-like daytime buttons from the contact list.
2. Preserve the last visible message until the player explicitly acknowledges that time passes.
3. Keep every timeline card visible until the player clicks.
4. Surface incoming messages from another thread inside the currently open conversation as a clickable shortcut.
5. Make unread contacts immediately identifiable.

## Product decisions

### Intra-day progression

- No `Continuer la journée` or time-coded advance button in the left column.
- Completing a phase queues the next time window instead of opening it immediately.
- The open conversation receives a compact contextual shortcut such as:

```text
Le temps passe · 16:05
Nouveau message de Marie : ...
```

- Clicking the shortcut acknowledges the elapsed time, opens the relevant timeline card when one exists, then unlocks the next phase and its notification.
- An optional conversation can still be ignored: clicking the time-passage shortcut expires it according to the existing V0.84 rule.
- If an optional conversation has been opened but not completed, the time-passage shortcut is hidden until that exchange is finished.

### Timeline cards

- Ordinary intra-day cards are never triggered directly by the completion of a conversation.
- A card appears only after the player clicks the contextual time-passage shortcut or the explicit end-of-day action.
- Once visible, a card remains on screen until a mouse or keyboard click after its short minimum display time.
- `duration` remains available only for explicitly configured non-click cards; click-to-dismiss is the default.

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
- use the same visual location for the distinct time-passage shortcut;
- the existing left-side contact list remains the main day-level contact hub;
- no separate Contacts application is added.

### Unread styling

Unread contact cards use:

- stronger contact-name treatment;
- stronger preview text;
- more visible unread dot and `NON LU` label;
- accent border/background already provided by the pending card style.

Read, active, archived, and unread states must remain distinct.

## Runtime strategy

Use narrow adapters:

```text
game/scripts/ui/PhonePrototypeV086A.gd
game/scripts/ui/ConversationViewV086A.gd
```

Also adjust the existing timeline overlay so click-to-dismiss is the default:

```text
game/scripts/ui/TimelineTransitionView.gd
```

They extend the current V0.85/V0.84 adapters and preserve V0.86 data.

No scheduler refactor, save migration, or narrative-data rewrite.

## Expected files

- `game/scripts/ui/PhonePrototypeV086A.gd`
- `game/scripts/ui/ConversationViewV086A.gd`
- `game/scripts/ui/TimelineTransitionView.gd`
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
