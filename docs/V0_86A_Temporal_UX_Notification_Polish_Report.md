# V0.86a — Temporal UX & Unread Notification Polish Report

> Small UX/runtime correction integrated during V0.86 review.  
> No narrative data, character canon, route state, or adult-content rule is changed.

## Trigger

Manual review identified four usability problems:

1. `Continuer vers 16:05` sounded like a technical scheduler command.
2. Automatic moment cards interrupted reading and appeared too frequently.
3. A new message in another thread lacked a smartphone-like shortcut inside the currently open conversation.
4. Unread contact cards were too subtle.

## Implemented behavior

### Natural progression action

Optional phases now use:

```text
Continuer la journée
```

When a started optional conversation is incomplete, the control becomes disabled and reads:

```text
Terminer la conversation avant de continuer
```

Exact time remains visible through the status bar and message/contact timestamps rather than the main button label.

### No automatic ordinary moment overlay

Ordinary intra-day phase changes no longer open a full-screen transition card automatically.

The runtime still preserves authored offline beats because they communicate actual off-phone story action rather than only a clock change.

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

When no conversation is open, the existing phone-side notification remains the fallback.

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
- generic progression label;
- no automatic ordinary moment overlay;
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
