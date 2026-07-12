# V0.86a — Temporal UX & Unread Notification Polish Plan

> Small UX/runtime polish pass requested during V0.86 review.  
> No narrative lines, route states, image rules, or character canon are changed.

## Goals

1. Remove scheduler-like progression controls from the contact list.
2. Keep the completed conversation visible while several narrative hours pass.
3. Replace blank moment-of-day interstitials with an accelerated smartphone-clock animation.
4. Deliver the next message as a normal in-thread notification after the clock finishes.
5. Keep unread contacts immediately identifiable.

## Product decisions

### Conversation completion

After the last visible message of a conversation:

```text
Contact est hors ligne
```

is appended as a centered system status inside the current thread.

The thread remains visible. The player is not moved to a blank screen.

### Accelerated clock

Two real seconds after the conversation completes, the status-bar clock begins to advance from the last visible message time to the next narrative message time.

Default normal-speed timing:

```text
pre-animation pause: 2 seconds
clock animation: 5 seconds
```

The clock can cross midnight for a day change. Debug speed may shorten the delay and animation, but normal speed preserves the five-second passage.

The animation changes only the smartphone clock. It does not display:

- `Le temps passe`;
- a moment-of-day title;
- an empty transition card;
- a left-column continue button.

### Incoming notification

At the end of the clock animation:

1. the next phase is activated;
2. its messages become unread;
3. the previous conversation remains on screen;
4. a compact notification appears below its header;
5. clicking the notification opens the target thread.

This applies even when the next episode belongs to the same persistent contact thread.

### Optional windows

An optional conversation is presented through a normal unread notification.

- opening it cancels automatic expiry;
- completing it advances naturally to the next time window;
- leaving it unopened allows the existing expiry rule to run after a short real-time window;
- no `Continuer la journée` control is shown.

The V0.84 narrative distinction between `seen` and `expired` remains intact.

### Authored offline beats

Existing authored offline beats remain canonical, but they no longer use a full-screen text card.

They are rendered as centered in-thread system notes, recorded in the day log, and restored in read-only archives through the existing V0.85 foundation.

### Day changes

A day change uses the same accelerated clock, including midnight rollover. The old conversation stays visible until the next day's first message notification arrives.

No day-start screen containing only weekday/moment text is used in the active flow.

### Unread styling

Unread contact cards retain:

- stronger contact-name treatment;
- stronger preview text;
- visible unread dot and `NON LU` label;
- accent border/background.

Read, active, archived, and unread states remain distinct.

## Runtime strategy

Use the narrow adapters:

```text
game/scripts/ui/PhonePrototypeV086A.gd
game/scripts/ui/ConversationViewV086A.gd
```

They extend the current V0.85/V0.84 foundations and preserve V0.86 narrative data.

`TimelineTransitionView.gd` remains available to legacy/history code, but the V0.86a active progression path does not invoke it for intra-day or day-start text screens.

No save migration, route refactor, universal scheduler, or narrative rewrite is introduced.

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

## Manual acceptance path

```text
last message remains visible
-> Contact est hors ligne
-> two-second pause
-> status clock advances for five seconds
-> no blank moment screen
-> next-message banner appears in the same visible thread
-> clicking it opens the unread contact
```

Also verify:

- optional Sandra can be opened before expiry;
- ignoring Sandra eventually produces Marie's later notification;
- same-thread next episodes still produce a notification;
- midnight rollover leads to the next day without a text-only day-start page.

## Explicit exclusions

- no narrative dialogue edit;
- no Friday story expansion;
- no app-wide contact redesign;
- no route or score change;
- no R2 or adult escalation;
- no save migration;
- no legacy-data deletion;
- no removal of the temporary left-side prototype panel yet.
