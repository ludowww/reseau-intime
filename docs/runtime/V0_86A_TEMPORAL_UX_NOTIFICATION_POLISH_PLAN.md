# V0.86a — Temporal UX & Unread Notification Polish Plan

> Small UX/runtime polish pass requested during V0.86 review.  
> No narrative lines, route states, image rules, or character canon are changed.

## Goals

1. Remove scheduler-like progression controls from the contact list.
2. Keep the completed conversation visible while several narrative hours pass.
3. Replace blank moment-of-day interstitials with an accelerated smartphone clock.
4. Put time, Wi‑Fi, and battery information in the fixed conversation header.
5. Deliver the next message as a normal in-thread notification.
6. Keep unread contacts immediately identifiable.
7. Keep offline activity implicit rather than explaining it to the player.

## Product decisions

### Conversation completion

After the last visible message:

```text
Contact est hors ligne
```

is appended as a centered interface status. The thread remains visible.

### Conversation-side smartphone status

The active phone status strip belongs above the contact header, on the conversation side:

```text
09:14                         ▮▮  Wi‑Fi  82%
Raphaëlle
En ligne
```

The temporary left prototype panel no longer owns a visible status strip. It may keep an invisible clock model for compatibility until the full smartphone layout replaces it.

The status strip is fixed: messages scroll below it.

### Accelerated clock

Two real seconds after conversation completion, the fixed conversation clock advances from the last visible message time to the next narrative message time.

Normal-speed timing:

```text
pre-animation pause: 2 seconds
clock animation: 4 seconds
```

The clock may cross midnight. Debug speed may shorten the animation, but `Speed x1` preserves the four-second passage.

The active flow displays no:

- `Le temps passe` banner;
- moment-of-day title;
- blank transition page;
- left-column continue button.

### Incoming notification

At the end of the clock animation:

1. the next phase becomes active;
2. its conversation becomes unread;
3. the previous conversation remains visible;
4. a compact notification appears below the contact header;
5. clicking it opens the target thread.

This also applies to a new episode in the same persistent contact thread.

### Optional windows

An optional conversation appears as a normal unread notification.

- opening it cancels automatic expiry;
- completing it advances naturally;
- leaving it unopened permits the existing expiry rule;
- no progression button is shown.

### Offline activity

Authored offline beats remain internal continuity/state operations. They may still:

- select the correct variant;
- apply existing flags;
- preserve internal day-log data for debugging and continuity.

They must not be shown as:

- a centered explanatory note;
- a full-screen card;
- a `Moments hors ligne` archive section;
- a replayable clue about what Player supposedly did off screen.

The player infers elapsed activity from the clock, later dialogue, objects, consequences, and character knowledge.

Existing inline `offline_beat` authoring items are consumed silently by the active V0.86a conversation adapter.

### Day changes

A day change uses the same accelerated clock with midnight rollover. The old conversation remains visible until the next day’s first notification appears.

No weekday/moment landing page is used in the active flow.

### Unread styling

Unread cards retain:

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

They extend the V0.85/V0.84 foundations and preserve V0.86 narrative data.

`TimelineTransitionView.gd` remains legacy/history-compatible but is not used by active intra-day or day-start progression.

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
-> conversation-side clock advances for four seconds
-> no blank moment screen
-> next-message banner appears below the fixed header
-> clicking it opens the unread contact
```

Also verify:

- time/Wi‑Fi/battery appear above every opened contact;
- the left prototype panel has no duplicate visible status strip;
- optional Sandra can be opened before expiry;
- ignoring Sandra eventually produces Marie’s later notification;
- same-thread next episodes still notify;
- midnight rollover changes day without a text-only landing page;
- no active or archived `Moments hors ligne` section is visible.

## Explicit exclusions

- no narrative dialogue edit;
- no Friday story expansion;
- no app-wide contact redesign;
- no route or score change;
- no R2 or adult escalation;
- no save migration;
- no legacy-data deletion;
- no removal of the temporary left-side prototype panel yet.