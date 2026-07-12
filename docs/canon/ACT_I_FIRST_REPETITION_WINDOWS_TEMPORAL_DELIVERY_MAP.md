# Act I First Repetition Windows Temporal & Delivery Map — V0.87

> Canon companion to the V0.87 source pack and scene cards.  
> Locks chronology, physical positions, message justification, clock behavior, and opportunity expiry for the first post-opening repetition wave.  
> Documentation only; this map does not change runtime.

## 1. Authority

Read with:

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
```

For active phone presentation, V0.86a controls over older blank-card examples:

```text
docs/runtime/V0_86A_TEMPORAL_UX_NOTIFICATION_POLISH_PLAN.md
docs/V0_86A_Temporal_UX_Notification_Polish_Report.md
```

Therefore V0.87 uses:

- the fixed conversation-side clock;
- a two-second pause after a completed thread;
- a four-second accelerated clock passage at normal speed;
- compact cross-thread notifications;
- direct same-thread continuation without a notification;
- no blank weekday or moment-of-day card;
- no visible explanatory offline beat;
- no `Moments hors ligne` archive section.

This map defines story time and delivery meaning, not a requirement to expose all internal state to the player.

---

## 2. Calendar anchor

V0.86 ends:

```text
Friday 18:25
opening_band_complete = true
```

The first repetition wave occupies:

```text
Saturday morning
-> weekend opportunity windows
-> weekend couple return
-> first one or two workdays
-> final couple return / wave close
```

Approved default calendar:

```text
Saturday = fixed Marie shared-hour entry + possible household opportunity
Sunday   = social or quiet private opportunity
Monday   = first workday opportunity
Tuesday  = overflow only when a real schedule or deferred obligation requires it
```

The runtime plan may move an exact scene within its approved range.

It may not reorder physical cause and effect or make all opportunities occur on the same day.

---

## 3. Wave budget and time tickets

The source pack provides three compatible opportunity bands but only two external foreground tickets.

```text
Ticket A = first compatible external foreground
Ticket B = second compatible external foreground
```

Approved opportunity bands:

```text
Weekend household band
Weekend social / quiet band
First-workday band
```

Once both tickets are consumed:

- later candidates defer, mutate, or become an ordinary echo;
- no third external foreground is inserted;
- a due Marie return still occurs;
- silence remains acceptable.

A charged-access scene consumes one normal foreground ticket; it does not create an extra slot.

---

## 4. Full temporal grid

| Anchor | Approved range | Window / pool | Physical situation | Communication mode | Felt-time cue |
|---|---:|---|---|---|---|
| Saturday morning | 09:30–10:20 | W9 Marie shared hour | Marie already outside; Player at home or leaving; Mathilde occupied separately | `REMOTE_ASYNC` -> offline shared time if joined | returned keys, market, coffee, free hour |
| Saturday late morning / midday | 10:15–13:00 | weekend household band | household positions vary; Marie outside or in another real activity | `AFTERGLOW_REMOTE`, short `SEPARATE_ROOMS_PING`, or no message | coffee, shower, insurer, errands, room routine |
| Saturday late afternoon / Sunday early evening | 16:30–19:30 | weekend social band | Pauline/Bastien hosting or Nico before shift; Player elsewhere before possible meeting | `REMOTE_ASYNC` -> offline social time | leftovers, dinner setup, pre-shift lunch, travel time |
| Sunday night | 22:20–23:30 | quiet private band | Sandra after a real poste; Player at home or elsewhere; Jeff remains part of her life without forced exposition | `REMOTE_ASYNC` / `AFTERGLOW_REMOTE` | ticket recurrence, hot chocolate, late quiet |
| Same evening or next morning | 19:30–22:30 / 09:00–10:30 | W11 Marie return | branch-specific separation or co-presence | `AFTERGLOW_REMOTE` or implicit offline act | dinner, arrival, bounded hour, phone put away |
| Monday midday | 12:05–13:15 | first-workday band | Player and Raphaëlle at separate work positions before a lunch walk | `WORK_CHAT` -> offline walk -> short `AFTERGLOW_REMOTE` | prototype validated, lunch break, point de 14h |
| Monday late afternoon / evening | 17:30–22:15 | deferred opportunity or W13 return | character-specific real schedule; Player and Marie may be apart or home | character-specific remote mode or implicit offline act | end of workday, commute, shared evening |
| Tuesday only if needed | compatible natural range | one bounded deferred promise | fresh real reason; never a frozen Monday scene | same mode as mutated scene | elapsed day, changed availability, no fake waiting |

---

## 5. Smartphone clock contract

## 5.1 Normal cross-thread passage

```text
last visible message
-> contact is shown offline
-> approximately two real seconds
-> clock advances for approximately four real seconds at Speed x1
-> target conversation becomes unread
-> compact cross-thread notification appears
-> previous transcript stays at the bottom
```

Notification preview:

```text
first ten characters + ...
```

The notification is a switch shortcut, not a duplicate message bubble.

## 5.2 Same-thread continuation

When a later episode belongs to the currently open persistent thread:

```text
last message
-> contact is shown offline
-> clock advances
-> no incoming-message banner for the same contact
-> new episode continues directly below the existing history
```

Use for:

- later Marie episode inside `thread_marie_private`;
- later Sandra episode inside `thread_sandra_private`;
- any future continuation where the player is already looking at the correct contact.

## 5.3 No available scene

If time advances but no authored foreground or visible echo fits:

- the clock may advance only when another visible event is actually due;
- the interface does not display a filler card;
- no fake notification is manufactured;
- the player may remain in the current conversation or return to the contact list.

## 5.4 Day change

A day change uses the same clock continuity.

```text
late evening
-> accelerated clock crosses midnight
-> next visible message arrives at its real next-day time
```

No empty `SAMEDI — MATIN`, `DIMANCHE — SOIR`, or `LUNDI — MIDI` page is required.

Weekday and moment remain available through day labels, conversation timestamps, and the changing phone clock.

---

# 6. W9 — Marie shared hour delivery contract

```yaml
scene_id: marie_saturday_shared_hour_01
calendar_anchor: Saturday
time_band: MORNING
approximate_clock_range: 09:30-10:20
communication_mode: REMOTE_ASYNC
physical_context:
  Marie:
    - outside the apartment
    - returning La Verrière keys, visiting market, bakery, or one real errand
  Player:
    - at home or leaving
  Mathilde:
    - asleep, showering, on insurer call, or handling own morning
why_message_is_used:
  - Marie is already outside
  - the invitation expires inside one bounded hour
reply_latency:
  - a few minutes acceptable
  - a reply after the hour mutates to missed / later return
when_messaging_stops:
  - when Player meets Marie
possible_offline_continuation:
  - coffee
  - market walk
  - carrying one bag
  - ordinary shared conversation
```

### Branch timing

M2A:

```text
reply by roughly 09:45
-> Player leaves
-> shared hour occurs before 10:30
```

M2B:

```text
alternative must contain a bounded later time
-> paid before the weekend return
-> otherwise mutates to missed promise
```

M2C:

```text
Marie continues alone immediately
-> later return remains Player's responsibility
```

---

# 7. Mathilde morning kitchen delivery contract

```yaml
scene_id: mathilde_morning_kitchen_afterglow_01
calendar_anchor:
  - Saturday late morning
  - Sunday morning
  - first compatible weekday morning
time_band: MORNING
approximate_clock_range: 10:15-11:30
communication_mode: AFTERGLOW_REMOTE
physical_context_before_chat:
  - Player and Mathilde briefly shared the kitchen
  - Marie was absent for a real reason
  - Mathilde wore normal fitted homewear
  - Player looked; Mathilde noticed
physical_context_during_chat:
  - Mathilde has left for work, insurer, laundry, contractor, or another errand
  - Player is elsewhere
why_message_is_used:
  - the shared-room moment has ended
  - distance gives Mathilde control over wording
when_messaging_stops:
  - Mathilde closes after one short branch
```

Forbidden staging:

- long chat while they remain in the kitchen together;
- a hidden camera or outfit photo;
- Marie conveniently disappearing without a schedule;
- the phone explaining the whole offline moment in prose.

The player infers the kitchen event from Mathilde's message and prior timestamps.

### Cooldown placement

If Thursday O5B was the immediately previous Mathilde foreground:

- do not place this on Saturday morning;
- move it to Sunday or first compatible weekday;
- or use an ordinary Mathilde work/household echo instead.

---

# 8. Sandra work-afterglow delivery contract

```yaml
scene_id: sandra_ticket_ghost_hot_chocolate_01
calendar_anchor:
  - Sunday night
  - next compatible end-of-post
time_band: NIGHT
approximate_clock_range: 22:20-23:30
communication_mode: REMOTE_ASYNC / AFTERGLOW_REMOTE
physical_context:
  Sandra:
    - home after work or in a quiet break after a late poste
    - not co-present with Player
  Player:
    - home or elsewhere, still awake
  Jeff:
    - part of Sandra's real domestic life
    - not required to be absent, cruel, or named in every line
why_message_is_used:
  - Sandra chooses a distant private contact after a concrete work recurrence
reply_latency:
  - short delay acceptable
  - no demand for immediate answer
expiry:
  - this exact quiet interval expires the same night
```

If Player does not open the conversation before the interval expires:

- do not deliver it the next afternoon unchanged;
- mutate to a colder work echo or defer to a fresh event;
- no automatic route penalty.

If Thursday Sandra was ignored:

- prefer deferral;
- only offer after sufficient elapsed time and retained J1 warmth;
- do not act as though no missed window occurred.

---

# 9. Raphaëlle lunch walk delivery contract

```yaml
scene_id: raphaelle_lunch_walk_outside_work_01
calendar_anchor: first compatible workday
time_band: MIDDAY
approximate_clock_range: 12:05-13:15
communication_mode:
  opening: WORK_CHAT
  middle: OFFLINE_WALK
  closing: AFTERGLOW_REMOTE after separation
physical_context_opening:
  - Player and Raphaëlle at separate workstations / rooms / hybrid locations
  - shared task has genuinely resolved
physical_context_middle:
  - short public lunch walk
  - no professional dependency or evaluation
physical_context_closing:
  - they have returned to separate work positions
why_message_is_used:
  - exact work handoff belongs in writing
  - invitation happens while separated
  - optional personal afterglow occurs only after separation
when_messaging_stops:
  - if they become co-present at the same table or during the walk
```

Forbidden staging:

- emotional confession inside deadline panic;
- a long text conversation while walking together;
- private costume/account reveal through work chat;
- Player using the walk to hide from an overdue Marie act.

### Deferred walk expiry

One honest defer may create:

```text
one next compatible workday
```

If not paid:

- the exact invitation expires;
- a fresh reason is required;
- Raphaëlle does not remain permanently available.

---

# 10. Pauline Sunday table delivery contract

```yaml
scene_id: pauline_bastien_sunday_table_01
calendar_anchor:
  - Saturday late afternoon
  - Sunday late afternoon / early evening
time_band: LATE_AFTERNOON -> EVENING
approximate_clock_range: 16:30-19:30
communication_mode:
  invitation: REMOTE_ASYNC
  dinner: OFFLINE_GROUP_EVENT
  later message: only after physical separation and with a new reason
physical_context:
  Pauline:
    - at shared apartment or shopping / preparing with Bastien
  Bastien:
    - actively hosting, cooking, or planning
  Marie:
    - separately deciding whether to attend
  Player:
    - elsewhere when invitation arrives
why_message_is_used:
  - legitimate arrival / contribution logistics
when_messaging_stops:
  - when Player reaches the apartment or group setting
```

No private Player/Pauline chat continues under the table as an automatic route beat.

If a later message occurs:

- everyone must be physically separated;
- it needs an ordinary new reason;
- it cannot contain the private alternate prohibited by V0.87.

If Player declines but Marie attends:

- Pauline and Marie have a real evening without Player;
- the runtime should not expose their whole offline conversation;
- later state may remember Marie's social independence.

---

# 11. Nico pre-shift lunch delivery contract

```yaml
scene_id: nico_pre_shift_lunch_friendship_01
calendar_anchor:
  - weekend midday / afternoon
  - first compatible weekday before service
time_band: MIDDAY -> AFTERNOON
approximate_clock_range: 13:00-15:15
communication_mode:
  invitation: REMOTE_ASYNC
  lunch: OFFLINE_FRIENDSHIP
  closing: AFTERGLOW_REMOTE after separation if needed
physical_context:
  Nico:
    - at home, near L'Annexe, or on a quiet pre-shift meal
    - sober
  Player:
    - elsewhere when invitation arrives
why_message_is_used:
  - invitation and timing are remote
when_messaging_stops:
  - when Player joins Nico
```

Lunch content may include:

- food;
- work;
- football failure;
- the silence after a loud service;
- one ordinary friendship detail.

It may not include in V0.87:

- a Marie or Mathilde photo request;
- `you show me home, I show you outside`;
- an alibi;
- a body catalogue;
- intoxication as access.

A deferred Tuesday lunch has one exact date.

If missed:

- debt mutates into cooler friendship evidence;
- Nico does not wait with the same omelette forever.

---

# 12. Marie concrete return delivery contract

```yaml
scene_id: marie_concrete_return_due_01
calendar_anchor:
  - same evening after external foreground
  - next morning only when the promised act is explicitly next-morning
time_band:
  - EVENING
  - MORNING for bounded carryover
approximate_clock_range:
  evening: 19:30-22:30
  morning: 09:00-10:30
communication_mode:
  - AFTERGLOW_REMOTE when apart
  - OFFLINE_SHARED_TIME when co-present
physical_context:
  - branch-specific and always explicit
why_message_is_used:
  - only when Marie and Player are separated
when_messaging_stops:
  - when Player returns or joins her
```

### Paid variant presentation

If the shared act happened offline:

- do not display an explanatory recap card;
- use changed tone in the next visible Marie exchange;
- internal state may record that the obligation was paid.

### Unpaid variant presentation

If Marie and Player are apart:

- short message exchange allowed;
- M3 choices are real messages;
- immediate action stops messaging when they meet.

If co-present:

- the choice is represented as action or local dialogue, not Messenger;
- future implementation must not force a fake chat for technical convenience.

### Priority rule

```text
Marie return due
outranks
new external opportunity
```

No second external ticket activates while the return remains overdue.

---

## 13. Opportunity expiry matrix

| Scene | Offer lifetime | If unopened | If opened but unfinished | If deferred |
|---|---|---|---|---|
| Marie shared hour | bounded morning hour | Marie goes on | must resolve before hour loses meaning | M2B creates explicit later obligation |
| Mathilde morning afterglow | same morning / early day | exact moment closes | no automatic time jump through active chat | fresh engine after cooldown |
| Sandra late contact | same night | expires or mutates | time waits until exchange closes | no indefinite deferral |
| Raphaëlle lunch walk | lunch interval | walk happens alone | workday does not advance through unresolved choice | one compatible workday |
| Pauline table | before hosting logistics close | dinner occurs without Player | arrival decision must resolve before event | fresh social plan required |
| Nico lunch | before pre-shift hour closes | Nico eats / works | no automatic expiry after Player opens | one named later date |
| Marie return | until paid or failed | remains highest-priority consequence | blocks external opportunity | bounded promise only |

---

## 14. Foreground and echo delivery

Each opportunity band allows:

```text
one foreground
zero to two echoes
```

Echo rules:

- an echo may arrive in another thread only if physical distance and timing justify it;
- a new cross-thread echo receives a compact notification;
- a same-thread echo continues directly;
- an echo never interrupts an unresolved foreground choice;
- an echo cannot secretly carry a major route advance;
- an echo cannot create an extra foreground ticket.

Examples:

- Marie confirms a dinner time while Pauline is foreground;
- Mathilde sends one household correction after a Nico lunch;
- Raphaëlle closes a work item while Sandra is foreground that night;
- Nico sends ordinary logistics while Pauline's dinner invitation is foreground.

Do not stack all available echoes merely because the system permits two.

---

## 15. Charged-access scheduling

When Mathilde, Sandra, or Raphaëlle qualifies for R2:

```text
charged scene resolves
-> contact goes offline
-> Marie consequence becomes due
-> no other external notification until Marie return resolves
```

The phone may still display:

- ordinary unread history already delivered;
- contact list state;
- non-route system UI.

It may not deliver the next route opportunity as though nothing changed.

If another charged candidate reaches its natural time while the owner already exists:

- use ordinary branch if authored and contextually true;
- otherwise defer/mutate;
- do not silently create a second R2.

---

## 16. Day and moment cues

The player should feel time through:

- the fixed phone clock;
- message timestamps;
- weekday labels in the temporary navigation;
- work / weekend context;
- reply latency;
- who is physically available;
- ordinary objects and schedule language;
- notifications arriving only after clock passage.

Do not use:

- a blank full-screen moment card;
- `Le temps passe` text;
- `Continuer vers 16:05`-style scheduler controls;
- an explicit prose recap of off-phone activity.

```text
Time should be seen moving on the phone
and understood through changed availability.
```

---

## 17. Archive contract

Completed days remain read-only.

Archives may show:

- authored conversation history from that day;
- message timestamps;
- choices already made;
- contact names and day labels.

Archives do not show:

- a `Moments hors ligne` section;
- explanatory prose revealing inferred activity;
- future episode leakage;
- new unread markers;
- new notifications;
- replayable choices;
- time movement.

Internal obligation and beat state may remain stored for continuity/debugging.

---

## 18. Implementation-plan questions reserved for V0.88

V0.88 must decide, without changing this story meaning:

- how foreground tickets are represented in current timeline state;
- how deterministic candidate selection reads context;
- how one charged-access owner is stored;
- how same-thread episode continuation works across new days;
- how co-present action choices are represented without fake messages;
- how expired opportunities mutate to a new scene ID;
- how current V0.86a clock animation handles long cross-midnight gaps;
- how save compatibility is handled;
- which smallest vertical slice integrates first.

V0.87 does not answer these with runtime code.

---

## 19. Final temporal rule

```text
A repeated scene is earned by time,
context,
and prior behavior.

The clock does not summon a character.
It only makes a real opportunity arrive
when that person could actually be there.
```
