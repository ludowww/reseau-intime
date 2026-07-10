# Diegetic Time & Communication Realism Canon

> Canon rules for temporal orientation and believable smartphone communication.  
> Applies to every future source pack, modular scene card, runtime integration plan, and playable conversation.  
> Documentation only: no runtime, JSON, Godot scene, script, test, asset, or playable content is changed here.

## 1. Core purpose

`Réseau Intime` is a smartphone-first narrative game.

That does not mean every interaction happens through messages.

The interface must preserve two kinds of realism at the same time:

```text
the player must understand when life is happening
and why a message is being sent instead of spoken
```

A scene is not credible if:

- two adults stand within normal conversational reach and exchange a long chat for no reason;
- several hours pass without a readable temporal cue;
- work, meals, travel, sleep, and evening routines have no influence on availability;
- an emotional conversation is forced into Messenger only because Messenger is the main interface.

---

## 2. Time must be felt

The player does not need a minute-by-minute simulation clock.

The player does need to feel:

- the day of the week when it matters;
- morning, midday, afternoon, evening, and night;
- meaningful elapsed time;
- work and travel rhythms;
- whether a reply is immediate, delayed, or sent the following day;
- whether an event is approaching, underway, or finished;
- whether a character is tired because it is late rather than because the script says so.

```text
Time is a narrative condition,
not decorative metadata.
```

## 2.1 Required temporal fields

Every foreground window and authored scene card must identify:

```text
calendar_anchor
time_band
approximate_clock_range
elapsed_since_previous_window
temporal_cues
```

### `calendar_anchor`

Use one of:

- named weekday when the story has a real anchor;
- relative day such as `D+1` when the weekday is intentionally unknown;
- event-relative anchor such as `the morning after the vernissage`.

Do not use a bare scene order as the only time reference.

### `time_band`

Canonical bands:

```text
EARLY_MORNING    06:00–09:00
MORNING          09:00–12:00
MIDDAY           12:00–14:00
AFTERNOON        14:00–17:00
LATE_AFTERNOON   17:00–19:00
EVENING          19:00–22:30
NIGHT            22:30–02:00
```

The clock ranges are guidance, not rigid simulation boundaries.

### `approximate_clock_range`

Use a plausible range rather than one exact minute during documentation.

Example:

```text
Jeudi — 17:50–18:20
```

Runtime may choose a precise displayed timestamp within the approved range.

### `elapsed_since_previous_window`

Examples:

- `35 minutes`;
- `after lunch`;
- `the following morning`;
- `two hours after the event ended`;
- `after a full workday`.

### `temporal_cues`

Use concrete life markers:

- alarm or commute;
- coffee, lunch, dinner, late snack;
- light outside;
- work start or end;
- `poste du matin` / `poste du soir` / `poste de nuit`;
- shop or venue opening/closing;
- transport delay;
- battery level only when relevant;
- pajamas, coat, shower, or bed preparation;
- next-day photo relay;
- `vu à` / delayed reply when narratively meaningful.

Do not repeat a time label in every message. Use enough cues for orientation.

---

## 3. Runtime presentation rule

A meaningful time jump should be visible through at least one of:

- weekday / time-band separator;
- message timestamp;
- notification timestamp;
- social-post age;
- explicit character line;
- lighting or visual context;
- work / meal / transport cue;
- short system card such as `Jeudi — Soir`.

Recommended separator style:

```text
MERCREDI — MIDI
JEUDI — FIN D'APRÈS-MIDI
JEUDI — NUIT
VENDREDI — MATIN
```

The UI may also show a representative time:

```text
Jeudi — 18:04
```

Exact clock display is an implementation decision, but the approved time band is narrative canon.

---

## 4. Physical co-presence rule

```text
If two characters are in the same room
and can speak normally,
they do not conduct a full Messenger conversation.
```

They may send one item while co-present when the medium itself matters:

- a photo;
- a link;
- an address;
- a document;
- a private aside that cannot be spoken publicly;
- a message intended to remain as a trace.

Even then, the surrounding conversation normally happens aloud.

A long emotional exchange between co-present characters is written as an offline beat, not as artificial text messages.

## 4.1 Same home, different rooms

Short practical messages are credible when characters are:

- behind a closed door;
- unpacking in another room;
- in the shower or kitchen while the other works elsewhere;
- avoiding shouting across the apartment;
- sending a photo or precise object location.

Allowed:

```text
Mathilde : Tu as vu mon chargeur ?
Player : boîte bleue sous le bureau
Player : j'arrive
```

When Player enters the room, the chat stops.

Not allowed:

```text
Player and Mathilde remain face to face
and continue fifteen messages about their emotional tension.
```

## 4.2 Same venue, spatially separated

Short messages are credible when characters are:

- on opposite sides of a busy venue;
- separated by noise, guests, or work tasks;
- coordinating objects, timings, or arrivals;
- sending a discreet aside in public.

Allowed:

```text
Marie : Tu es où ?
Player : derrière les chaises
Marie : rallonge noire côté scène
```

Not allowed:

- a full relationship confrontation while both are standing ten metres apart and free to speak;
- several paragraphs of emotional explanation during active setup.

Move the emotional content to:

- a quieter face-to-face offline beat;
- the walk home;
- a later message after they separate;
- an aftermath window.

## 4.3 Same workplace

Work chat remains plausible when characters are:

- in different rooms;
- working remotely or hybrid;
- reviewing a shared file asynchronously;
- avoiding interrupting another meeting;
- sending exact references that belong in writing.

If Player and Raphaëlle sit at the same table for the final review, the Messenger exchange stops and the offline result is summarized afterward.

---

## 5. Canon communication modes

Every foreground scene card must identify one primary communication mode.

### `REMOTE_ASYNC`

Characters are in different locations.

Suitable for:

- normal Messenger dialogue;
- delayed replies;
- longer personal exchanges;
- promises and follow-ups.

### `TRACE_DELIVERY`

The message exists because a photo, screenshot, file, or link is being delivered.

Characters may be geographically close or far apart, but origin and audience remain explicit.

### `SEPARATE_ROOMS_PING`

Characters share a home or building but occupy separate rooms.

Suitable only for:

- brief practical requests;
- object location;
- short private aside;
- invitation to come into the room.

The chat stops when they meet.

### `SAME_VENUE_LOGISTICS`

Characters are in one event space but separated by distance, noise, guests, or tasks.

Suitable for:

- location;
- equipment;
- timing;
- brief public-private aside.

Not suitable for a long emotional scene.

### `WORK_CHAT`

Professional written exchange justified by separate workstations, shared files, asynchronous review, or hybrid work.

It must not become automatic intimacy.

### `OFFLINE_BEAT`

The meaningful exchange occurs face to face.

The smartphone UI represents it through one or more of:

- a short event card;
- a later message referring to what was said;
- changed state / tone;
- a photograph or object trace;
- a concise summary in the source pack.

The game must not fabricate a chat transcript for an offline conversation.

### `AFTERGLOW_REMOTE`

The characters have just separated after a shared event.

Suitable for:

- thanks;
- one honest observation;
- promise or consequence;
- late-night emotional residue.

The documentation must state why they are no longer co-present.

---

## 6. Required communication fields

Every foreground scene card must identify:

```text
physical_context
communication_mode
why_message_is_used
when_messaging_stops
possible_offline_beat
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

### `possible_offline_beat`

Describe what happens face to face without inventing a full transcript unless that offline scene is deliberately authored.

---

## 7. Reply latency

Replies should reflect life.

Possible patterns:

- immediate logistics: seconds to a few minutes;
- work reply: a few minutes to an hour;
- emotional hesitation: visible delay;
- late-night non-urgent message: may wait until morning;
- supporting-character work schedules: respect current shift or closing rhythm;
- no character must answer every thread instantly.

A delay can mean:

- work;
- sleep;
- travel;
- uncertainty;
- deliberate distance;
- another person being physically present.

It should not always mean route punishment.

---

## 8. Offline action and smartphone consequences

Offline events may still drive a smartphone game.

Correct pattern:

```text
message creates or arranges an offline event
-> event happens without fake chat
-> later message / trace / notification shows consequence
```

Examples:

- Player helps Mathilde carry boxes; later she sends a short thank-you or Marie comments on the room.
- Player and Marie walk home; the next message references a promise made during the walk.
- Raphaëlle and Player finish a review at the same table; the task state changes and later work chat reflects the result.
- A group photo records a face-to-face event and creates a later message window.

Do not try to make every spoken sentence visible just because the UI is a phone.

---

## 9. Scene-selection interaction

Time and communication mode are hard eligibility conditions.

A scene is blocked when:

- the character is asleep or working incompatibly;
- the required venue is closed;
- the character is physically co-present and the scene requires remote emotional messaging;
- the time band exceeds the scene's intensity or privacy logic;
- a promised `tomorrow morning` follow-up is being offered the same night without cause;
- a late reply would contradict the established schedule.

A scene may mutate when the intended time window is missed.

Example:

```text
invitation before 18h
-> accepted in time = arrival scene
-> answered after 20h = missed-opportunity consequence
-> not answered until morning = invitation expired
```

---

## 10. Review checklist

A scene is not temporally or communicatively ready unless:

- [ ] weekday or relative day is known;
- [ ] time band is known;
- [ ] elapsed time from the prior major window is readable;
- [ ] each character's location is known;
- [ ] communication mode is identified;
- [ ] the reason for messaging is credible;
- [ ] co-present characters do not conduct artificial long chats;
- [ ] transition from message to offline interaction is defined when relevant;
- [ ] reply latency fits work, sleep, travel, and emotional context;
- [ ] visual lighting / clothing / meal / work cues match the time;
- [ ] a missed time window mutates or expires rather than waiting forever;
- [ ] runtime planning includes day separators or equivalent temporal cues.

---

## 11. Final rule

```text
The phone shows the parts of life
that genuinely pass through a phone.

Time continues outside the chat.
People speak when they are together.
Messages begin when distance, privacy, logistics, or traces make them believable.
```
