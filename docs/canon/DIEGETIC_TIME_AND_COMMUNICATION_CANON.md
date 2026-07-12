# Diegetic Time & Communication Realism Canon — Current

> Canon rules for temporal orientation and believable smartphone communication.  
> Reconciled through V0.87 and the V0.86a smartphone-time presentation.  
> Applies to every source pack, scene card, runtime plan, and playable conversation.

## 1. Core purpose

`Réseau Intime` is a smartphone-first narrative game.

That does not mean every interaction happens through messages.

The interface must preserve two forms of realism:

```text
the player understands when life is happening
and
understands why a message is sent instead of spoken
```

A scene is not credible if:

- two adults stand within normal conversational reach and conduct a long chat without a reason;
- several hours pass without a readable time cue;
- work, meals, travel, sleep, weekends, and venue schedules do not affect availability;
- an emotional conversation is forced into Messenger only because the phone is the main interface;
- the game explains every off-phone action instead of letting the player infer life.

---

## 2. Time must be felt

The game does not need minute-by-minute simulation.

The player must feel:

- weekday or relative day when relevant;
- morning, midday, afternoon, evening, and night;
- meaningful elapsed time;
- work, weekend, travel, meal, and sleep rhythm;
- immediate, delayed, or next-day reply;
- whether an event is approaching, underway, or over;
- whether an opportunity is still physically possible;
- whether a promise has reached its real deadline.

```text
Time is a narrative condition,
not decorative metadata.
```

## 2.1 Required temporal fields

Every foreground window and scene card identifies:

```text
calendar_anchor
time_band
approximate_clock_range
elapsed_since_previous_window
temporal_cues
```

### `calendar_anchor`

Use:

- named weekday when established;
- relative day such as `D+1` when intentionally unknown;
- event-relative anchor such as `the morning after the vernissage`.

Do not use bare scene order as the only time reference.

### `time_band`

Canonical guidance:

```text
EARLY_MORNING    06:00–09:00
MORNING          09:00–12:00
MIDDAY           12:00–14:00
AFTERNOON        14:00–17:00
LATE_AFTERNOON   17:00–19:00
EVENING          19:00–22:30
NIGHT            22:30–02:00
```

Ranges guide plausibility; they are not rigid simulation walls.

### `approximate_clock_range`

Documentation uses a plausible range:

```text
Lundi — 12:05–13:15
```

Runtime may choose precise displayed minutes inside the approved range.

### `elapsed_since_previous_window`

Examples:

- `35 minutes`;
- `after lunch`;
- `the following morning`;
- `two hours after the event ended`;
- `after a full workday`;
- `after one social cycle`.

### `temporal_cues`

Use life markers:

- alarm or commute;
- coffee, lunch, dinner, late snack;
- light outside;
- work start/end;
- `poste du matin`, `poste du soir`, `poste de nuit`;
- venue opening/closing;
- transport delay;
- shower, pajamas, coat, bed preparation;
- a work file finally closing;
- a next-day photo relay;
- delayed `vu à` when narratively meaningful.

Do not repeat time labels in every message. Use enough cues for orientation.

---

## 3. Current smartphone time presentation

A meaningful gap is presented primarily through the fixed conversation-side phone clock.

At normal speed:

```text
last visible message
-> contact shown offline
-> approximately two real seconds
-> fixed clock advances for approximately four seconds
-> next visible event arrives
```

### Cross-thread event

When the next event belongs to another contact:

```text
clock reaches target time
-> target thread becomes unread
-> compact notification appears under the fixed header
```

The notification:

- previews only the first ten characters plus `...` when needed;
- uses a brief insertion/flash effect;
- keeps the transcript at the bottom;
- acts as a thread-switch shortcut;
- does not duplicate the whole incoming message.

### Same-thread continuation

When the next episode belongs to the already open contact:

```text
clock advances
-> no same-contact notification
-> new messages continue directly below existing history
```

### Day change

A day change uses the same clock continuity, including midnight rollover.

The active flow does not use a blank page containing only:

- weekday;
- moment label;
- story title;
- timestamp.

Temporal orientation may also come from:

- current day label while the prototype navigation exists;
- message timestamps;
- notification time;
- work/meal/transport language;
- changed character availability;
- visual and object context.

```text
The phone shows time moving.
The story shows what changed because it moved.
```

---

## 4. Physical co-presence rule

```text
If two characters are in the same room
and can speak normally,
they do not conduct a full Messenger conversation.
```

They may send one medium-specific item while co-present:

- photo;
- link;
- address;
- document;
- exact object location;
- private aside that cannot be spoken publicly;
- message intended to remain as a trace.

The surrounding conversation normally happens aloud.

A long emotional exchange between co-present characters is an offline scene or consequence, not an artificial transcript.

## 4.1 Same home, different rooms

Short practical messages are credible when characters are:

- behind a closed door;
- unpacking in another room;
- in shower/kitchen while another works elsewhere;
- avoiding shouting across the apartment;
- sending a photo or exact object location.

Allowed:

```text
Mathilde : Tu as vu mon chargeur ?
Player : boîte bleue sous le bureau
Player : j'arrive
```

When Player enters the room, chat stops.

Not allowed:

```text
Player and Mathilde remain face to face
and continue fifteen messages about their tension.
```

## 4.2 Same venue, spatially separated

Short messages are credible when characters are:

- on opposite sides of a busy venue;
- separated by noise, guests, equipment, or tasks;
- coordinating location, timings, or objects;
- sending a discreet aside in public.

Allowed:

```text
Marie : Tu es où ?
Player : derrière les chaises
Marie : rallonge noire côté scène
```

Not allowed:

- full relationship confrontation while free to speak;
- paragraphs of emotional explanation during setup.

Move emotional meaning to:

- a quiet face-to-face beat;
- walk home;
- later message after separation;
- aftermath window.

## 4.3 Same workplace

Work chat is plausible when characters are:

- in different rooms;
- remote/hybrid;
- reviewing a file asynchronously;
- avoiding interrupting a meeting;
- sending exact written references.

If Player and Raphaëlle sit at the same table, Messenger stops and the result is understood through later state or a later message after separation.

---

## 5. Canon communication modes

Every foreground scene card identifies one primary mode.

### `REMOTE_ASYNC`

Different locations.

Suitable for:

- normal personal messaging;
- delayed replies;
- longer remote exchanges;
- promises and follow-ups.

### `TRACE_DELIVERY`

A message exists because a photo, screenshot, file, or link is delivered.

Origin, intended audience, and function remain explicit.

### `SEPARATE_ROOMS_PING`

Same home/building, separate rooms.

Suitable only for:

- brief practical request;
- object location;
- short private aside;
- invitation to enter the room.

Chat stops when they meet.

### `SAME_VENUE_LOGISTICS`

Same venue but separated by distance, noise, guests, or tasks.

Suitable for:

- location;
- equipment;
- timing;
- brief public-private aside.

Not suitable for a long emotional scene.

### `WORK_CHAT`

Professional written exchange justified by separate workstations, shared files, asynchronous review, or hybrid work.

It must not become automatic intimacy.

### `AFTERGLOW_REMOTE`

Characters have just separated after a shared moment.

Suitable for:

- thanks;
- one honest observation;
- promise or consequence;
- late emotional residue;
- reopening an awkward physical moment at a safer distance.

Documentation states why they are no longer co-present.

### `OFFLINE_BEAT`

Meaningful interaction happens face to face or outside the phone.

It may change:

- flags;
- knowledge;
- object position;
- obligation state;
- relationship tone;
- phase completion.

The active interface does not automatically display an explanatory card or transcript.

The player infers the result through:

- elapsed time;
- later messages;
- changed tone;
- object traces;
- fulfilled/missed promises;
- later consequences.

Internal state may retain a concise authored summary for continuity/debugging.

It is not shown as a `Moments hors ligne` archive section.

---

## 6. Required communication fields

Every foreground scene card identifies:

```text
physical_context
communication_mode
why_message_is_used
when_messaging_stops
possible_offline_continuation
```

### `physical_context`

Example:

```text
Marie remains inside La Verrière with Élodie.
Player has left for L'Annexe or home.
```

### `why_message_is_used`

Example:

```text
The venue is noisy and they are on opposite sides of the room.
```

### `when_messaging_stops`

Example:

```text
When Player enters the spare room, the practical exchange continues offline.
```

### `possible_offline_continuation`

Describe the action/function without inventing a full transcript unless a face-to-face scene is deliberately authored.

Do not make the phone narrate that summary to the player by default.

---

## 7. Reply latency

Replies reflect life.

Possible patterns:

- urgent logistics: seconds to a few minutes;
- work reply: minutes to an hour;
- emotional hesitation: visible delay;
- late non-urgent message: may wait until morning;
- weekend/work schedule: depends on real availability;
- no character answers every thread instantly.

A delay can mean:

- work;
- sleep;
- travel;
- uncertainty;
- deliberate distance;
- another person physically present;
- opportunity expiry.

Delay is not always route punishment.

---

## 8. Offline action and smartphone consequence

Correct pattern:

```text
message creates or arranges an offline event
-> event happens without fake chat
-> time passes visibly
-> later message / object / changed state shows consequence
```

Examples:

- Player joins Marie for coffee; next Marie tone remembers the shared hour.
- Player helps Mathilde; later household knowledge and object placement reflect it.
- Player and Raphaëlle walk; a short post-walk message occurs only after separation.
- Pauline/Bastien dinner happens offline; later social state knows who attended.
- Nico lunch occurs without a full friendship transcript; a later line can acknowledge it.

Do not make every spoken sentence visible because the interface is a phone.

Do not explain every action through a system note.

---

## 9. Opportunity and scene-selection interaction

Time and communication mode are hard eligibility conditions.

A scene is blocked when:

- character is asleep or working incompatibly;
- required venue is closed;
- character is co-present while the scene requires remote emotional messaging;
- time band contradicts privacy/intensity logic;
- a promised future follow-up is offered too early;
- reply timing contradicts established schedule;
- a higher-priority consequence is due;
- foreground ticket budget is exhausted;
- exact scene is in cooldown.

A scene may mutate when its intended window is missed.

Example:

```text
invitation before 18h
-> accepted in time = arrival scene
-> answered after event starts = lateness consequence
-> not answered until morning = invitation expired
```

V0.87 adds:

```text
maximum two external foreground tickets
maximum one charged-access owner
same character cannot consume both tickets
Marie consequence outranks later external opportunity
```

A quiet interval is valid.

---

## 10. Notifications and interruptions

A new notification may interrupt a completed thread only when:

- target phase is current;
- target conversation is available;
- target thread differs from the open thread;
- no unresolved choice is on screen;
- arrival time has been reached.

A notification does not interrupt:

- an unresolved foreground choice;
- an active typing sequence;
- an opened optional exchange;
- a co-present action represented outside chat.

If one phase has several required contacts, completing one may reveal the next unfinished contact through a compact notification.

A silent data unlock must not strand required content permanently invisible.

---

## 11. Images and traces during communication

A message carrying an image must identify:

- origin;
- intended audience;
- intended function;
- saving/deletion rule when relevant;
- whether the sender and subject are the same person;
- consequence if the image leaves its frame.

A public/social image is not permission for:

- private recrop;
- sexual reinterpretation shared with another person;
- forwarding;
- permanent saving;
- adult use.

V0.87 requires no new image.

---

## 12. Review checklist

A scene is not temporally or communicatively ready unless:

- [ ] weekday or relative day is known;
- [ ] time band and approximate range are known;
- [ ] elapsed time from prior major window is readable;
- [ ] each character's location is known;
- [ ] communication mode is identified;
- [ ] reason for messaging is credible;
- [ ] messaging stop point is defined;
- [ ] co-present characters do not conduct artificial long chats;
- [ ] reply latency fits work, sleep, travel, and emotional context;
- [ ] visual/clothing/meal/work cues fit the time;
- [ ] a missed window mutates or expires;
- [ ] no exact offer waits forever;
- [ ] current fixed clock can express the time jump;
- [ ] same-thread continuation avoids redundant notification;
- [ ] cross-thread notification is compact and justified;
- [ ] offline action is inferred rather than over-explained;
- [ ] future timestamps do not appear early;
- [ ] consequence due has priority over new temptation.

---

## 13. Final rule

```text
The phone shows the parts of life
that genuinely pass through a phone.

Time continues outside the chat.
People speak when they are together.
Messages begin when distance, privacy, logistics, or traces make them believable.

The interface shows elapsed time.
It does not narrate every unseen hour.
```
