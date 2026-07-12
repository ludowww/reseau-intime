# V0.86a — Temporal UX & Unread Notification Polish Report

> Small UX/runtime correction integrated during V0.86 review.  
> No narrative data, character canon, route state, or adult-content rule is changed.

## Trigger

Manual review identified five usability problems:

1. `Continuer vers 16:05` and `Continuer la journée` felt like scheduler controls.
2. `Le temps passe` was not a natural smartphone message.
3. Text-only interstitials hid the last message and broke reading rhythm.
4. Some newly available messages did not surface as an in-thread notification.
5. Unread contact cards were too subtle.

## Implemented behavior

### No left-column daytime control

The optional-phase progression button is removed entirely from the contact list.

There is no visible:

```text
Continuer la journée
```

or time-coded equivalent.

### Contact goes offline

When a conversation finishes, the final message stays visible and a centered status is appended beneath it:

```text
Contact est hors ligne
```

This status is UI feedback, not a new authored dialogue line or relationship state.

### Accelerated smartphone clock

Two seconds after completion, the status-bar clock animates from the last visible message time to the next narrative time.

At normal speed:

```text
pause after final message = 2 seconds
clock animation = 5 seconds
```

The conversation remains on screen throughout. The active path no longer opens a blank card containing only a weekday, moment label, or timestamp.

The clock animation supports midnight rollover for day changes.

### Next-message notification

After the clock reaches the destination time:

1. the next timeline phase becomes active;
2. its conversation becomes unread;
3. the completed thread remains visible;
4. a compact notification appears below its header;
5. clicking that notification opens the target thread.

The same behavior applies when the new episode belongs to the same persistent contact thread.

If a data rule intentionally had no notification payload, V0.86a derives a normal contact name and first-message preview so the arrival is still perceptible.

### Optional conversation behavior

Optional scenes no longer need a continue button.

- opening the optional notification cancels automatic expiry;
- finishing the optional exchange starts the next clock passage;
- leaving it unopened allows the existing V0.84 expiry rule to run after a short real-time window;
- opening but not finishing it prevents expiry until the exchange is resolved.

### Authored offline beats

Canonical offline actions such as dinner, walking, returning to Marie, or the household close remain active.

They are now shown as centered system notes inside the current phone view rather than full-screen text cards. They continue to:

- apply their existing flags;
- write their existing day-log entry;
- appear once in read-only archives.

### Day changes

A day change uses the same clock animation instead of an empty day-start page.

The old thread remains visible until the next day's first-message notification appears. The left prototype panel updates only after the accelerated clock reaches the new day.

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

`TimelineTransitionView.gd` remains present for legacy/history compatibility, but V0.86a does not call it for active intra-day or day-start progression.

## Test coverage

```text
tests/test_v086a_temporal_ux_static.py
```

The test verifies:

- active adapter wiring;
- absence of scheduler buttons and `Le temps passe` prompts;
- two-second delay and five-second clock animation;
- contact-offline status beneath the last message;
- no active call to text-only transition overlays;
- inline authored offline beats;
- natural optional-scene expiry;
- in-thread new-message notifications;
- unread-card styling;
- UX-only scope plus reuse of existing offline-beat flags.

## Explicit exclusions

- no dialogue or narrative JSON edit;
- no Friday story expansion;
- no route or score change;
- no R2/adult escalation;
- no Contacts application;
- no save migration;
- no removal of the temporary left-side prototype panel;
- no legacy deletion.
