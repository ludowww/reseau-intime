# Temporal Flow & Day Transition Canon — Current

> Canon rules for chronological progression, phase gating, opportunity expiry, day completion, smartphone-time presentation, and archives.  
> Reconciled through V0.87.  
> Companion to `DIEGETIC_TIME_AND_COMMUNICATION_CANON.md` and the active temporal maps.

## 1. Purpose

`Réseau Intime` must feel like a lived chronology rather than a menu of already-open days.

The player must understand:

```text
what time it is
what is currently happening
what may still happen now
what has been missed
when a consequence is due
when the next day has genuinely begun
```

A timestamp is not enough.

The runtime controls narrative time explicitly.

---

## 2. Core rule

```text
Time labels describe chronology.
Timeline state controls access.
```

A conversation is not available merely because:

- its JSON is loaded;
- its timestamp is later;
- its contact exists in another day;
- the player can see an archived thread;
- a later route engine exists in canon.

A past optional scene cannot remain playable as though its original context still existed.

---

## 3. Day lifecycle

Every active story day uses one lifecycle state:

```text
LOCKED
AVAILABLE
ACTIVE
COMPLETE
ARCHIVED
```

### `LOCKED`

- unavailable and normally hidden;
- cannot be selected;
- leaks no conversation, notification, timestamp, visual, or route state.

### `AVAILABLE`

- unlocked by completion of the previous day;
- may be selected;
- becomes `ACTIVE` when entered.

### `ACTIVE`

- current narrative day;
- only current-phase content and retained past thread history are accessible;
- future phases remain inaccessible.

### `COMPLETE`

A day becomes complete only when:

- every required phase is resolved;
- optional opportunities have a terminal state;
- the final required consequence/shared-life anchor is resolved;
- no safety, consent, discovery, or aftermath scene remains due;
- end-state writes are applied.

The presence of a final timestamp does not complete a day by itself.

### `ARCHIVED`

- previous completed day;
- reviewable in read-only form;
- creates no new notification, choice, effect, or route change;
- never changes current narrative time.

```text
Revisiting history is not replaying time.
```

---

## 4. Temporal phase lifecycle

Each day is divided into authored phases.

Examples:

```text
MORNING_WORK
MIDDAY_OPTIONAL
LATE_AFTERNOON_DECISION
EVENING_TOPOLOGY
NIGHT_CONSEQUENCE
```

A phase uses:

```text
LOCKED
CURRENT
COMPLETE
SKIPPED
EXPIRED
```

### `LOCKED`

Future phase. Its conversations, choices, and timestamps are inaccessible.

### `CURRENT`

The only phase allowed to create new playable content.

### `COMPLETE`

All required content and the phase's authored contract are resolved.

### `SKIPPED`

The player deliberately advanced without seeing an optional opportunity when that action exists in the current interaction model.

### `EXPIRED`

The original physical, temporal, or social context no longer exists.

A skipped or expired scene may later create:

- a missed-opportunity flag;
- a colder mutation;
- a delayed consequence;
- no effect when deliberately low-stakes.

It may not remain frozen at its old hour.

---

## 5. Opportunity lifecycle

Post-opening modular scenes use a separate authored lifecycle:

```text
DORMANT
ELIGIBLE
OFFERED
SEEN
DEFERRED
MISSED
MUTATED
EXPIRED
CONSEQUENCE_DUE
RESOLVED
```

### Rules

- `ELIGIBLE` means conditions fit; it does not guarantee selection.
- `OFFERED` is bounded by real availability.
- opening an offer may pause automatic expiry until its choice resolves.
- ignoring an offer lets the authored window close.
- one honest defer may create a named later obligation when the scene contract allows it.
- missed content mutates or needs a fresh reason.
- no exact offer waits indefinitely.

V0.87 adds a foreground-ticket budget:

```text
maximum two external foreground tickets
maximum one charged-access owner
same character cannot consume both tickets
```

A quiet window is valid when no scene fits.

---

## 6. Required, optional, and selected content

Every phase declares the relevant categories:

```text
required_conversation_ids
optional_conversation_ids
required_any_conversation_ids
selected topology / candidate result when applicable
```

### Required content

The phase cannot advance until required content is resolved.

Examples:

- Marie's opening request;
- selected O5 branch;
- O6 return to Marie;
- mandatory couple return after charged external attention;
- safety or aftermath consequence.

### Optional content

The player may:

- open it during its real window;
- leave it unopened and let it expire;
- defer only when the scene contract defines a bounded mutation.

Optional does not mean timeless.

### Selected opportunity

A modular pool may have several eligible scenes but only one selected foreground.

Selection must respect:

```text
safety / aftermath
-> fixed spine
-> obligation due
-> compatible continuation
-> physical and temporal context
-> unseen eligible scene
-> longest deferred
-> least recently foregrounded
-> authored deterministic order
```

Free randomness does not precede these rules.

---

## 7. Advancing time without a scheduler button

The active smartphone flow does not expose technical commands such as:

```text
Passer à 16:05
Continuer la journée
Aller au lendemain
```

Instead, progression follows authored completion and real opportunity expiry.

Normal cross-thread sequence at `Speed x1`:

```text
last visible message
-> contact shown offline
-> approximately two real seconds
-> conversation-side clock accelerates for approximately four seconds
-> target phase becomes current
-> target thread becomes unread
-> compact cross-thread notification appears
```

The transcript stays at the bottom.

Notification preview:

```text
first ten characters + ...
```

The notification is a shortcut to another thread, not a duplicate message bubble.

### Same-thread continuation

When the next episode belongs to the already open persistent thread:

```text
contact offline
-> clock advances
-> no same-contact notification
-> new episode continues directly below existing history
```

### Optional window expiry

An unopened optional notification may remain available for its authored real-time window.

When that window closes:

1. the optional episode becomes `SKIPPED` or `EXPIRED`;
2. configured missed flags are applied;
3. the episode is no longer answerable;
4. the clock advances toward the next visible event;
5. the next notification appears only when its phase becomes current.

If the optional conversation has been opened but not completed, time does not jump through the unresolved exchange.

---

## 8. Day completion and couple centrality

A day with meaningful external attention closes only after the required shared-life consequence.

The final required function must return to:

- Marie;
- the shared home;
- a concrete couple act;
- an explicit couple consequence;
- or a documented immediate carryover.

Implemented examples:

```text
Tuesday ends on Marie/shared life.
Thursday ends on O6 Marie.
Friday ends on the enlarged household.
```

V0.87 documented rule:

```text
external foreground
-> Marie/shared-life return due
-> no later external opportunity outranks it
```

Private attention does not automatically require confession when no named boundary was crossed.

It does require the story to account for changed time, presence, and opportunity cost.

---

## 9. Day-transition presentation

The active flow no longer uses a blank full-screen or phone-screen card containing only:

- weekday;
- moment label;
- title;
- timestamp.

Day change uses the fixed smartphone clock:

```text
late current-day time
-> accelerated passage crosses midnight
-> next day's visible message time
-> next day becomes active
-> notification or same-thread continuation
```

The previous conversation may remain visible until the next event arrives.

Weekday and moment are communicated through:

- current day label/navigation while the prototype panel exists;
- fixed phone clock;
- message timestamps;
- work/weekend language;
- character schedules and changed availability.

No text-only landing page is required.

---

## 10. Intra-day time passage

Large jumps within a day use the same clock animation, not a separate moment card.

Use visible time passage when:

- several narrative hours pass;
- a work block ends;
- an optional window expires;
- a character becomes newly available;
- physical context materially changes;
- evening or night begins and a visible event follows.

Do not animate a trivial five-minute change merely to decorate time.

Do not advance the clock without a real next event or state transition.

The conversation remains visible throughout.

---

## 11. Offline and co-present activity

When characters are together, important conversation normally happens offline.

Internal authored beats may still:

- select a branch-specific variant;
- apply flags;
- maintain chronology;
- record internal continuity/debug state;
- complete a phase.

They are not player-facing exposition by default.

The active UI does not display them as:

- full-screen card;
- centered prose note;
- `Moments hors ligne` archive section;
- replayable clue.

The player infers off-phone activity from:

- elapsed time;
- later dialogue;
- object positions;
- knowledge changes;
- fulfilled or missed promises;
- consequences.

```text
Internal state may know more than the interface explains.
```

---

## 12. Notifications

A notification belongs to one active temporal phase.

It may appear only when:

- target day is `ACTIVE`;
- target phase is `CURRENT`;
- conversation is available;
- conditions are satisfied;
- it has not been opened or expired;
- the target thread differs from the currently open thread.

A notification cannot make time advance by itself.

Time/state advances first; notification reflects that result.

When a phase contains multiple required contacts:

- the first authored notification appears according to the phase contract;
- after completing one contact, the next unfinished required contact may receive a compact notification;
- silent unlock does not mean permanently invisible;
- same-thread continuation still uses no banner.

---

## 13. Timestamp rule

Within one active chronology:

- message timestamps are non-decreasing;
- phase time is non-decreasing;
- archived messages keep historical time without changing the current clock;
- a new episode with an earlier time is invalid unless explicitly framed as an imported past trace;
- `24:xx` is not used as a disguised next-day time;
- the status clock cannot hide contradictory source timestamps.

```text
The source data itself must remain chronologically coherent.
```

---

## 14. Current-day and archive navigation

### Current/future

- only unlocked days are usable;
- future days remain hidden by default;
- visible locked previews require explicit Product Owner validation.

### Archived days

Opening an archive:

- creates no pending badge;
- replays no notification;
- offers no new choice;
- applies no effect;
- changes no current day/phase/time;
- reactivates no expired scene;
- exposes no future episode;
- shows no internal offline-beat journal.

The interface must distinguish archive review from current play.

---

## 15. Reset rule

Reset restores:

- first active day only;
- initial phase of that day;
- no pending later-phase history;
- no expired/missed state from the prior run;
- no clock animation in progress;
- no notification shortcut left visible;
- no future-day access;
- no duplicate internal day-log record.

---

## 16. Current implemented chronology

```text
Tuesday initially active
Wednesday locked
Thursday locked
Friday locked

Tuesday complete -> Wednesday
Wednesday complete -> Thursday
Thursday complete -> Friday
Friday complete -> no later playable day
```

Thursday:

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> Sandra seen or expired
-> 16:05 Marie required
-> selected O5 branch
-> 22:10 Marie return required
-> Thursday complete
```

The player cannot answer Sandra at 13:50 after the chronology has reached 16:05.

---

## 17. V0.87 documented chronology

V0.87 is not yet implemented.

Authorized wave:

```text
Saturday morning — Marie shared hour
weekend — one selected external opportunity
same evening / next morning — Marie return
first workday — one second external opportunity maximum
same evening — Marie return and wave close
```

Constraints:

```text
maximum two external foreground tickets
maximum one charged-access owner
Pauline and Nico remain R1
no hard secret
no adult frame
no new image
```

V0.88 must map these semantics onto runtime state before any new day/index is added.

---

## 18. Data-contract principles

Exact field names belong to the integration plan, but every authored phase/opportunity must expose semantics equivalent to:

```text
id
calendar/time band
required/optional/selected content
entry conditions
exclusions
current/terminal state
expiry rule
cooldown
missed mutation
obligation writes
next eligible transition
```

Post-opening selection additionally needs:

```text
foreground ticket budget
last foreground character
charged-access owner
consequence due priority
```

Conceptual labels in source packs are not automatically final JSON keys.

---

## 19. Validation checklist

A temporal implementation is valid only if:

- [ ] future days remain inaccessible before unlock;
- [ ] only the current phase creates new content;
- [ ] the clock visibly bridges meaningful time gaps;
- [ ] no blank time-of-day card interrupts the transcript;
- [ ] same-thread episodes resume directly;
- [ ] cross-thread notifications remain compact and clickable;
- [ ] archived days remain read-only;
- [ ] required phases cannot be skipped;
- [ ] optional windows expire or mutate;
- [ ] an opened unresolved conversation blocks time advance;
- [ ] no conversation can be answered after its context expires;
- [ ] future timestamps do not appear early;
- [ ] timestamps never move backward;
- [ ] co-present activity is not rewritten as fake long chat;
- [ ] offline continuity is not over-explained;
- [ ] final couple/shared-life consequence is paid before completion;
- [ ] reset restores the initial chronology cleanly.

V0.87/V0.88 additional checks:

- [ ] external ticket cap is enforced;
- [ ] one charged owner maximum;
- [ ] obligation due outranks external opportunity;
- [ ] same character cannot consume both external tickets;
- [ ] no exact offer waits indefinitely.

---

## 20. Final rule

```text
The player may choose what to do inside time.
The player may not rearrange time by opening whatever thread is visible.

Days unlock.
Moments advance on the phone.
Opportunities expire.
Consequences take priority.
The story does not explain every hour the player did not see.
```
