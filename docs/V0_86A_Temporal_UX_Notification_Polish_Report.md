# V0.86a — Temporal UX & Unread Notification Polish Report

> Small UX/runtime correction integrated during V0.86 review.  
> No narrative data, character canon, route state, or adult-content rule is changed.

## Trigger

Manual review identified seven usability problems:

1. `Continuer vers 16:05` and `Continuer la journée` felt like scheduler controls.
2. `Le temps passe` was not a natural smartphone message.
3. Text-only interstitials hid the last message.
4. Some newly available messages lacked an in-thread notification.
5. Unread contact cards were too subtle.
6. Time/Wi‑Fi/battery information belonged with the conversation UI rather than the temporary left panel.
7. Explicit `Moments hors ligne` notes over-explained activity the player should infer.

## Implemented behavior

### No left-column daytime control

There is no visible daytime progression button or time-coded equivalent.

### Contact goes offline

After the last message, the thread remains visible and receives an interface status:

```text
Contact est hors ligne
```

This is not authored dialogue or route state.

### Fixed conversation-side phone status

A fixed strip now appears above the contact header:

```text
09:14                         ▮▮  Wi‑Fi  82%
Raphaëlle
En ligne
```

The strip stays fixed while messages scroll. The temporary left prototype panel keeps only an invisible compatibility clock, so the time is not duplicated visually.

### Accelerated smartphone clock

Two seconds after completion, the fixed conversation clock animates from the last visible message time to the next narrative time.

At `Speed x1`:

```text
pause after final message = 2 seconds
clock animation = 4 seconds
```

The animation supports midnight rollover. The conversation remains visible throughout; no blank weekday/moment/timestamp card opens.

### Next-message notification

After the clock reaches the destination time:

1. the next phase becomes active;
2. its conversation becomes unread;
3. the completed thread remains visible;
4. a compact notification appears below its header;
5. clicking it opens the target thread.

The same behavior applies to a later episode in the same persistent contact thread. If a rule has no authored notification payload, the adapter derives a contact name and first-message preview.

### Optional conversation behavior

Optional scenes require no continue button.

- opening the notification cancels automatic expiry;
- finishing the exchange starts the next clock passage;
- leaving it unopened permits the existing V0.84 expiry rule;
- opening but not finishing it prevents expiry.

### Offline activity is implicit

Canonical offline actions remain internal continuity operations. Their variants, flags, and internal day-log records are preserved, but V0.86a does not display their explanatory text.

The active UI shows no:

```text
Moments hors ligne
```

section, no centered offline-beat explanation, and no replayable archive clue. Inline `offline_beat` authoring items are consumed silently.

The player infers off-screen activity through elapsed time, later dialogue, objects, state, and consequences.

### Day changes

A day change uses the same conversation-side clock animation with midnight rollover. The previous thread stays visible until the next day’s first notification appears.

No day-start landing page containing only weekday or moment text is used.

### Strong unread state

Unread cards retain:

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

`TimelineTransitionView.gd` remains for legacy/history compatibility, but active V0.86a progression does not use it.

## Test coverage

```text
tests/test_v086a_temporal_ux_static.py
```

Coverage verifies:

- active adapter wiring;
- absence of scheduler buttons and `Le temps passe` prompts;
- two-second delay and four-second clock animation;
- fixed conversation-side status strip;
- hidden left-side compatibility clock;
- contact-offline status beneath the last message;
- no active text-only transition overlay;
- silent authored and inline offline beats;
- no visible or archived `Moments hors ligne` section;
- natural optional-scene expiry;
- in-thread new-message notifications;
- unread-card styling;
- UX-only scope plus reuse of existing state flags.

## Explicit exclusions

- no dialogue or narrative JSON edit;
- no Friday story expansion;
- no route or score change;
- no R2/adult escalation;
- no Contacts application;
- no save migration;
- no removal of the temporary left-side prototype panel;
- no legacy deletion.