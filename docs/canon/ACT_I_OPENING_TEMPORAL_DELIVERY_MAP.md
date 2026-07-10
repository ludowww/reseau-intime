# Act I Opening Temporal & Delivery Map — V0.79

> Canon companion to `ACT_I_OPENING_WINDOWS_SOURCE_PACK.md` and `ACT_I_OPENING_SCENE_CARDS.md`.  
> Locks the felt chronology, physical positions, and believable communication mode for the opening post-J1 slice.  
> Where this map is more specific than the broader source pack, this map controls temporal placement and message delivery.

## 1. Calendar anchor

The current opening uses the weekday clues already present in J1.

J1 states:

- the La Verrière event is on Thursday;
- Mathilde intends to inspect the installation `tomorrow`.

Current concrete calendar:

```text
Tuesday evening   = J1 — Les choses qu'on remarque
Wednesday         = household emergency and Mathilde arrival
Thursday          = work access, La Verrière event, topology, and return
Friday            = public photo relay, Nico follow-up, household breather
```

This calendar gives the player a clear sense of progression without restoring a rigid `J2–J10` production model.

```text
Weekdays and time bands are canon.
Exact displayed minutes may vary inside the approved range.
```

---

## 2. Required runtime cues

Each major window must display or imply:

- weekday;
- moment of day;
- representative timestamp;
- elapsed time when a jump is significant;
- location or activity cue when needed.

Recommended UI separators:

```text
MERCREDI — MIDI
MERCREDI — FIN DE JOURNÉE
JEUDI — MATIN
JEUDI — FIN D'APRÈS-MIDI
JEUDI — SOIR
JEUDI — NUIT
VENDREDI — MATIN
VENDREDI — APRÈS-MIDI
VENDREDI — FIN DE JOURNÉE
```

Suggested exact timestamps are implementation guidance, not mandatory fixed seconds.

---

## 3. Full temporal grid

| Anchor | Approved range | Window | Physical situation | Communication mode | Felt-time cue |
|---|---:|---|---|---|---|
| Tuesday evening | 19:00–22:15 | Current J1 | Marie and Player move between home, bread errand, and walk; Sandra elsewhere after work | Existing J1 delivery | dinner, bread, 19h mail, evening walk, Sandra after poste |
| Wednesday midday | 12:05–12:35 | O1 Marie / make room | Marie at La Verrière lunch break or between tasks; Player at work or in transit; Mathilde at damaged apartment | `REMOTE_ASYNC` | lunch break, water-damage call, practical urgency |
| Wednesday late afternoon / early evening | 18:15–19:15 | O2 Mathilde arrival | Marie and Mathilde at shared apartment; Player still commuting or completing bedding / household errand | `TRACE_DELIVERY` + `REMOTE_ASYNC` | commute, arrival bags, evening light, room preparation |
| Wednesday evening | 19:15–20:30 | O2 offline continuation | Player reaches apartment; all are physically present | `OFFLINE_BEAT` | carrying boxes, showing room, dinner / takeaway, settling |
| Thursday morning | 09:05–09:40 | O3 Raphaëlle blue-folder review | Player and Raphaëlle at separate workstations / rooms or hybrid; shared file open | `WORK_CHAT` | start of workday, coffee, client point approaching |
| Thursday early afternoon | 13:45–14:20 | Sandra continuity echo | Sandra has finished a poste du matin; Player is at work | `REMOTE_ASYNC` | end of morning shift, delayed non-urgent reply |
| Thursday late afternoon | 16:00–16:30 | O4 Marie offers movement | Marie at La Verrière setup; Player at work / home / commute | `REMOTE_ASYNC` | event approaching, setup pressure, 18h request |
| Thursday early evening | 17:50–20:15 | O5A joined topology | Player and Marie at La Verrière but often on opposite sides of a busy venue | `SAME_VENUE_LOGISTICS` | guests arriving, noise, equipment, room movement |
| Thursday early evening | 18:15–19:10 | O5B home topology | Player in living room / office; Mathilde unpacking in spare room behind closed door; Marie at La Verrière | `SEPARATE_ROOMS_PING` + Marie `REMOTE_ASYNC` echo | quiet apartment, insurer callback, dinner preparation |
| Thursday late afternoon / evening | 17:40–19:15 | O5C work topology | Player at desk; Raphaëlle in another workroom / remote workstation; Marie at La Verrière | `WORK_CHAT` + Marie remote promise thread | workday ending, deadline, event clock advancing |
| Thursday late evening / night | 21:45–23:15 | O6 return to Marie | Branch-specific separation: Marie still closing / in transit / home later; Player at L'Annexe, in transit, at work, or already home | `AFTERGLOW_REMOTE` or `OFFLINE_BEAT` | venue closing, travel home, late fatigue, promise consequence |
| Friday morning | 08:15–10:00 | O7 Pauline public relay | Pauline at home / commute / bank start; Player elsewhere; Marie driving or already busy | `TRACE_DELIVERY` + `REMOTE_ASYNC` | morning after event, photo selection, workday start |
| Friday afternoon | 13:30–15:15 | O8 Nico follow-up | Nico awake before L'Annexe shift or on late lunch; Player elsewhere | `REMOTE_ASYNC` | after-event banter, late hospitality rhythm |
| Friday late afternoon / early evening | 17:45–18:30 | household breather | Marie at La Verrière or commuting; Player commuting / elsewhere; Mathilde at apartment | `REMOTE_ASYNC` echoes, or `OFFLINE_BEAT` if co-present | end of workweek/day, bathroom joke, enlarged household rhythm |

---

## 4. Scene-by-scene communication contract

## O1 — `marie_mathilde_emergency_make_room_01`

```text
calendar_anchor: Wednesday
 time_band: MIDDAY
 approximate_clock_range: 12:05–12:35
physical_context:
- Marie is at La Verrière during lunch or between tasks.
- Player is at work or in transit.
- Mathilde is at her damaged apartment.
communication_mode: REMOTE_ASYNC
why_message_is_used:
- the emergency happens while Marie and Player are apart;
- Marie needs a shared-home answer before confirming logistics.
when_messaging_stops:
- no physical meeting occurs inside this scene.
```

The exchange may be interrupted briefly by work and does not need instantaneous replies.

---

## O2 — `mathilde_arrival_too_much_luggage_01`

```text
calendar_anchor: Wednesday
 time_band: LATE_AFTERNOON -> EVENING
 approximate_clock_range: 18:15–19:15
physical_context:
- Marie and Mathilde are inside the apartment.
- Player has not returned yet because he is commuting or completing a practical errand.
communication_mode:
- TRACE_DELIVERY for Marie's room photo
- REMOTE_ASYNC for Mathilde's direct thread
why_message_is_used:
- Player is not yet physically present;
- the photo documents the arrival and room state.
when_messaging_stops:
- when Player enters the apartment.
possible_offline_beat:
- carrying boxes;
- showing storage and bathroom logistics;
- setting up bedding;
- ordinary dinner or takeaway.
```

### Marie arrival echo

The short Marie echo is shown as chat only when Player is still outside the apartment.

If Player has already returned, it becomes an `OFFLINE_BEAT` and must not appear as a Messenger exchange between co-present partners.

---

## O3 — `raphaelle_blue_folder_review_01`

```text
calendar_anchor: Thursday
 time_band: MORNING
 approximate_clock_range: 09:05–09:40
physical_context:
- Player and Raphaëlle are at separate workstations, rooms, or hybrid locations.
- They are reviewing the same file asynchronously.
communication_mode: WORK_CHAT
why_message_is_used:
- exact line references belong in writing;
- one may be in a meeting or focused work block;
- they are not sitting face to face.
when_messaging_stops:
- if they move to the same table or meeting room, the correction continues offline.
possible_offline_beat:
- file corrected;
- brief client-point preparation;
- sandwich recovered from the printer area.
```

The scene cannot be staged as a long chat between two colleagues seated beside one another.

---

## Sandra echo — `sandra_poste_matin_continuity_01`

```text
calendar_anchor: Thursday
 time_band: AFTERNOON
 approximate_clock_range: 13:45–14:20
physical_context:
- Sandra has finished a poste du matin.
- Player remains at work or elsewhere.
communication_mode: REMOTE_ASYNC
why_message_is_used:
- ordinary post-work contact across distance.
reply_latency:
- may be delayed by work;
- Sandra does not demand an immediate answer.
```

---

## O4 — `marie_thursday_movement_offer_01`

```text
calendar_anchor: Thursday
 time_band: AFTERNOON -> LATE_AFTERNOON
 approximate_clock_range: 16:00–16:30
physical_context:
- Marie is already at La Verrière or moving between setup tasks.
- Player is elsewhere.
communication_mode: REMOTE_ASYNC
why_message_is_used:
- Marie needs a concrete answer before 18h;
- location and timing determine the evening topology.
expiry:
- an answer after the event has begun mutates into lateness or missed-opportunity handling.
```

---

## O5A — `marie_laverriere_setup_joined_01`

```text
calendar_anchor: Thursday
 time_band: LATE_AFTERNOON -> EVENING
 approximate_clock_range: 17:50–20:15
physical_context:
- Player and Marie share La Verrière but are separated by guests, equipment, noise, and tasks.
communication_mode: SAME_VENUE_LOGISTICS
why_message_is_used:
- locating one another;
- requesting equipment;
- discreet practical asides across the room.
when_messaging_stops:
- when they are beside one another and free to speak.
possible_offline_beat:
- moving tables together;
- handling the extension cord;
- greeting guests;
- one brief face-to-face reaction to Player's participation.
```

The Messenger thread must stay short and practical.

The emotional evaluation belongs in O6 after separation, not in an extended same-room chat.

### O5A exit beat

Any `Merci d'être venu tôt` line is delivered only after Player and Marie have separated briefly:

- Player has gone toward L'Annexe;
- Player is carrying equipment to a car;
- Player has started home;
- Marie remains inside with Élodie to close.

Otherwise the line becomes an offline face-to-face beat and is not displayed as a message.

---

## O5B — `mathilde_spare_room_charger_01`

```text
calendar_anchor: Thursday
 time_band: EVENING
 approximate_clock_range: 18:15–19:10
physical_context:
- Player is in the living room / office.
- Mathilde is unpacking in the spare room behind a closed door.
- Marie is at La Verrière.
communication_mode: SEPARATE_ROOMS_PING
why_message_is_used:
- a short practical request avoids shouting across the apartment;
- Mathilde may send a photo of the cable pile.
when_messaging_stops:
- Player enters the spare room after writing `j'arrive`;
- searching and helping continue offline.
possible_offline_beat:
- locate charger;
- shift one box;
- clarify where shared household items are kept.
```

No emotional or sexual conversation continues by chat after they are in the same room.

Marie remains remote and can send the social echo naturally.

---

## O5C — `raphaelle_accessibility_review_late_01`

```text
calendar_anchor: Thursday
 time_band: LATE_AFTERNOON -> EVENING
 approximate_clock_range: 17:40–19:15
physical_context:
- Player is at his workstation.
- Raphaëlle is in another room, test space, or remote workstation.
- Marie is at La Verrière.
communication_mode: WORK_CHAT
why_message_is_used:
- shared-file decision and exact deadline;
- separate physical work positions;
- Player's promise to Marie exists in a different personal thread.
when_messaging_stops:
- if Player and Raphaëlle meet at one table for the final review, the rest happens offline.
possible_offline_beat:
- one final prototype check;
- Raphaëlle leaves after completing her part;
- Player chooses whether to leave or continue alone.
```

Raphaëlle does not conduct an emotional chat while co-present or invite Player to remain.

---

## O6 — `marie_after_first_event_return_01`

```text
calendar_anchor: Thursday
 time_band: EVENING -> NIGHT
 approximate_clock_range: 21:45–23:15
communication_mode:
- AFTERGLOW_REMOTE when Marie and Player are separated
- OFFLINE_BEAT when they return together
```

### Branch A — Player joined

Preferred message context:

- Marie remains at La Verrière to close with Élodie;
- Player has gone toward L'Annexe, the car, public transport, or home;
- the thank-you / observation arrives after physical separation.

If Player and Marie walk or return home together, the same emotional content happens face to face and is represented as an offline consequence rather than a fake chat.

### Branch B — Player stayed home

Message context:

- Marie is leaving La Verrière or in transit;
- Player remains at home;
- remote chat is natural.

### Branch C — Player worked

Message context:

- Marie is at the event, in transit, or home;
- Player is at work, commuting, arriving late, or absent;
- promise consequence is naturally delivered remotely.

### Universal rule

If both are physically together and free to talk:

```text
no Messenger exchange
```

The scene remains mandatory, but its delivery mode changes to `OFFLINE_BEAT`.

---

## O7 — `pauline_public_group_photo_relay_01`

```text
calendar_anchor: Friday
 time_band: EARLY_MORNING -> MORNING
 approximate_clock_range: 08:15–10:00
physical_context:
- Pauline is at home, commuting, or beginning her bank day.
- Player is elsewhere.
- Marie is driving, at La Verrière, or otherwise unable to handle the selection immediately.
communication_mode:
- TRACE_DELIVERY
- REMOTE_ASYNC
why_message_is_used:
- the actual content is a set of photographs;
- the relay occurs the morning after the event.
```

The next-day timing helps the event feel finished and avoids overcrowding Thursday night.

---

## O8 — `nico_saved_seat_followup_01`

```text
calendar_anchor: Friday
 time_band: AFTERNOON
 approximate_clock_range: 13:30–15:15
physical_context:
- Nico is awake before a later L'Annexe shift or on a late lunch.
- Player is elsewhere.
communication_mode: REMOTE_ASYNC
why_message_is_used:
- ordinary after-event friendship follow-up;
- their hospitality / office rhythms differ.
```

The timing prevents Nico from unrealistically writing at 08h after a late close unless a specific route later establishes that he never slept.

---

## Household breather

```text
calendar_anchor: Friday
 time_band: LATE_AFTERNOON
 approximate_clock_range: 17:45–18:30
physical_context:
- preferred: Marie at work or commuting, Player elsewhere, Mathilde at home;
- alternative: characters become co-present during the beat.
communication_mode:
- REMOTE_ASYNC while separated
- OFFLINE_BEAT after co-presence begins
```

If all three are already together, the bathroom-duration joke is spoken offline and must not appear as a three-person artificial chat.

---

## 5. Temporal continuity after missed choices

### M1A — Join Marie early

Approved rhythm:

```text
16:00 invitation
17:50 arrival / setup
19:00 public event
21:45+ afterglow or offline return
```

### M1B — Stay home

Approved rhythm:

```text
16:00 invitation
18:15 Mathilde practical ping
19:00 Marie social echo
22:30 Marie in transit / return consequence
```

### M1C — Work then join

Approved rhythm:

```text
16:00 promise
17:40 work decision
18:40 intended departure
19:00–20:00 kept / amended / missed outcome
21:45+ couple consequence according to actual result
```

A promise answered after its window cannot still produce the on-time arrival variant.

---

## 6. Temporal mutation rules

### O1 delayed too long

If Player does not answer before Mathilde's practical arrival logistics must be confirmed:

- Marie confirms the emergency stay herself;
- Player's branch becomes passive / missed participation;
- the scene does not wait unchanged into evening.

### O4 answered after 18h

- M1A `join early` is no longer available;
- the answer mutates into late arrival, separate obligation, or missed-event consequence;
- runtime must not show an impossible on-time choice.

### RW0 honest delay

The delay must be communicated before the promised arrival time expires.

A message sent after the event is effectively missed is not `honest amendment`; it is late explanation.

### O7 photo relay

The group-photo relay normally belongs to Friday morning.

Sending it Thursday night is allowed only if O6 has already occurred and the message load remains readable.

### O8 Nico follow-up

If Nico writes Thursday night after closing, use a late-night variant and preserve his work rhythm.

Default remains Friday afternoon.

---

## 7. Scene-card supplement

For all V0.79 scene cards, add these mandatory companion fields from this map:

```text
calendar_anchor
time_band
approximate_clock_range
physical_context
communication_mode
why_message_is_used
when_messaging_stops
possible_offline_beat
```

The V0.80 runtime integration plan must map them explicitly.

---

## 8. Review checklist

V0.79 is temporally and communicatively coherent only if:

- [ ] J1 is felt as Tuesday evening;
- [ ] Wednesday contains the emergency and arrival;
- [ ] Thursday clearly progresses from morning work to afternoon setup, evening event, and night consequence;
- [ ] Friday contains next-day traces and follow-up;
- [ ] day/time separators or equivalent cues are planned;
- [ ] Marie and Player do not exchange long messages while together in the same room;
- [ ] Player and Mathilde stop messaging when he enters the spare room;
- [ ] same-venue Marie messages remain logistical and short;
- [ ] Raphaëlle work chat is justified by physical separation / shared-file review;
- [ ] O6 can switch between remote message and offline beat;
- [ ] reply timing respects Sandra's poste, Nico's late work, and Pauline's morning routine;
- [ ] missed deadlines mutate choices rather than preserving impossible options;
- [ ] offline actions remain visible through later traces and consequences.

---

## 9. Final rule

```text
The opening now has a real week:
Tuesday warmth,
Wednesday disruption,
Thursday movement,
and Friday residue.

The phone records distance, logistics, traces, and aftermath.
When people are together, they speak.
```
