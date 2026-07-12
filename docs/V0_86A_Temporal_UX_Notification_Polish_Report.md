# V0.86a — Temporal UX & Unread Notification Polish Report

> Small UX/runtime correction integrated during V0.86 review.  
> No narrative data, character canon, route state, or adult-content rule is changed.

## Trigger

Manual review identified ten usability problems:

1. `Continuer vers 16:05` and `Continuer la journée` felt like scheduler controls.
2. `Le temps passe` was not a natural smartphone message.
3. Text-only interstitials hid the last message.
4. Some newly available messages lacked an in-thread notification.
5. Unread contact cards were too subtle.
6. Time/Wi‑Fi/battery information belonged with the conversation UI rather than the temporary left panel.
7. Explicit `Moments hors ligne` notes over-explained activity the player should infer.
8. Showing a notification could move the transcript away from its final messages.
9. Full-message notification previews overloaded the header.
10. Same-thread continuations incorrectly displayed a switch shortcut and choice-free conversations displayed an unnecessary empty-choice hint.

## Implemented behavior

### No left-column daytime control

There is no visible daytime progression button or time-coded equivalent.

### Contact goes offline

After the last message, the thread remains visible and receives an interface status:

```text
Contact est hors ligne
```

This is not authored dialogue or route state.

Choice-free conversations no longer display:

```text
Aucun choix direct dans cette conversation.
```

### Fixed conversation-side phone status

A fixed strip appears above the contact header:

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

### Compact notification for another thread

When the next message belongs to another contact:

1. the target conversation becomes unread;
2. the completed thread remains visible and stays scrolled to its bottom;
3. the notification is inserted below the fixed header without taking focus;
4. its preview is reduced to the first ten characters followed by `...`;
5. a short fade/flash pulse attracts attention;
6. clicking it opens the target thread.

If a phase contains several required contacts, completing one now surfaces the next unfinished unread contact. This covers the Friday Marie/Mathilde pair even though Mathilde’s simultaneous unlock is initially silent to avoid competing banners.

If a rule has no authored notification payload, the adapter derives a contact name and first-message preview before applying the same compact presentation.

### Direct continuation in the already open thread

When the clock reaches a later episode belonging to the thread already displayed:

- no notification banner appears;
- the thread is marked read automatically;
- the newly available segment is merged into the existing conversation state;
- messages resume directly below the previous history with normal typing cadence.

A notification now means “switch to another conversation,” not merely “more content exists.”

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

A day change uses the same conversation-side clock animation with midnight rollover. The previous thread stays visible until another thread notifies, or resumes directly when the first new episode belongs to that same thread.

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
tests/test_v085_j1_reconciliation_static.py
tests/test_v086a_temporal_ux_static.py
```

Coverage verifies:

- active adapter wiring;
- absence of scheduler buttons and `Le temps passe` prompts;
- two-second delay and four-second clock animation;
- fixed conversation-side status strip;
- hidden left-side compatibility clock;
- contact-offline status beneath the last message;
- no empty-choice hint in the active adapter;
- no active text-only transition overlay;
- silent authored and inline offline beats;
- no visible or archived `Moments hors ligne` section;
- natural optional-scene expiry;
- compact ten-character notification previews;
- non-focusing insertion/flash behavior;
- bottom-preserving external-thread notifications;
- direct same-thread continuation without a banner;
- remaining-contact notification inside multi-contact phases;
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
