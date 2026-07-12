# V0.86a — Temporal UX & Unread Notification Polish Report

> Small UX/runtime correction integrated during V0.86 review.  
> No narrative data, character canon, route state, or adult-content rule is changed.

## Trigger

Manual review identified four usability problems:

1. `Continuer vers 16:05` and later `Continuer la journée` still felt like scheduler controls.
2. Automatic moment cards interrupted reading and disappeared too quickly.
3. A new message in another thread lacked a consistent smartphone-like shortcut inside the currently open conversation.
4. Unread contact cards were too subtle.

## Implemented behavior

### No left-column daytime advance control

The optional-phase progression button is removed entirely from the contact list.

There is no longer a visible:

```text
Continuer la journée
```

or time-coded equivalent.

### Contextual time-passage shortcut

Completing a phase queues the next time window instead of activating it immediately.

The currently open conversation keeps its last message visible and receives a compact shortcut below the header:

```text
Le temps passe · 16:05
Nouveau message de Marie : ...
```

Clicking that shortcut:

1. acknowledges that time has passed;
2. displays the relevant timeline card when one exists;
3. unlocks the next phase;
4. surfaces the new-message notification.

For an optional phase, the same shortcut permits the player to move on without opening the optional thread. The existing expiry and missed-echo rules remain unchanged.

If the player has opened the optional conversation but has not finished it, the time-passage shortcut is hidden until the exchange ends.

### Timeline cards remain until click

Timeline and authored offline cards now default to:

```text
click_required = true
```

After a short minimum display time, the card remains visible until the player clicks or presses a key.

It no longer disappears merely because a duration elapsed.

No card is launched directly by the completion of an ordinary conversation; the player first activates the contextual time-passage shortcut.

### Player-triggered day ending

Completing the final required phase leaves the last conversation visible.

The left panel then displays:

```text
Finir la journée
```

Only that click launches the end-day/start-next-day transition.

### In-thread incoming-message shortcut

When another thread receives a notification while a conversation is open, a compact clickable banner appears directly below the current conversation header:

```text
Nouveau message · Contact · heure
aperçu du message
```

Clicking the banner opens the target thread.

The same banner location is reused for time passage, with a distinct internal mode and signal.

### Strong unread state

Unread cards now use:

- larger, brighter contact name;
- stronger preview;
- accent border/background;
- larger dot;
- explicit `NON LU` label.

Active, unread, read, and archived states remain distinct.

## Runtime files

```text
game/scripts/ui/PhonePrototypeV086A.gd
game/scripts/ui/ConversationViewV086A.gd
game/scripts/ui/TimelineTransitionView.gd
game/scenes/smartphone/PhonePrototype.tscn
game/scenes/smartphone/ConversationView.tscn
```

The adapters extend the existing V0.85/V0.84 implementations. No general phone or timeline refactor is introduced.

## Test coverage

```text
tests/test_v086a_temporal_ux_static.py
```

The test verifies:

- active adapter wiring;
- absence of the left-column daytime advance button;
- contextual time-passage prompting;
- no automatic phase activation after conversation completion;
- click-held timeline cards;
- manual `Finir la journée` flow;
- in-thread notification shortcut;
- unread-card styling;
- UX-only scope.

## Explicit exclusions

- no dialogue or JSON narrative edit;
- no Friday story expansion;
- no route or score change;
- no R2/adult escalation;
- no Contacts application;
- no save migration;
- no new scheduler;
- no legacy deletion.
