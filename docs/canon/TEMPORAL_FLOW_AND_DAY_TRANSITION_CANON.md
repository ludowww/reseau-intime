# Temporal Flow & Day Transition Canon — V0.83

> Canon rules for chronological progression, moment gating, optional-scene expiry, day completion, and transition presentation.  
> Companion to `DIEGETIC_TIME_AND_COMMUNICATION_CANON.md`.  
> Documentation only: no runtime, JSON, GDScript, tests, assets, or playable content are changed here.

## 1. Purpose

`Réseau Intime` must feel like a lived chronology rather than a menu of already-open days.

The player must understand:

```text
what time it is
what is currently happening
what may still happen now
what has been missed
when the day is genuinely over
why the next day has begun
```

A timestamp is not enough.

The runtime must control narrative time explicitly.

---

## 2. Core rule

```text
Time labels describe chronology.
Timeline state controls access.
```

A conversation is not available merely because it has a later timestamp in the same index.

A future day is not selectable merely because its index is loaded.

A past optional scene is not still playable as though its original hour had not passed.

---

## 3. Day lifecycle

Every active story day uses one lifecycle state.

```text
LOCKED
AVAILABLE
ACTIVE
COMPLETE
ARCHIVED
```

### `LOCKED`

- not visible or visibly disabled according to the approved UI;
- cannot be selected;
- no conversation, notification, timestamp, or visual from that day may leak into the current day.

### `AVAILABLE`

- unlocked by completion of the previous day;
- may be selected;
- becomes `ACTIVE` when entered.

### `ACTIVE`

- current narrative day;
- only the current temporal phase and retained past conversations are accessible;
- future phases remain hidden.

### `COMPLETE`

- all mandatory phases are resolved;
- all optional opportunities are seen, explicitly deferred, missed, or expired;
- no mandatory consequence remains due;
- the day-end transition may run.

### `ARCHIVED`

- previous completed day;
- remains reviewable through message history;
- cannot create new notifications, choices, or route changes merely because the player revisits it.

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

A phase uses one of:

```text
LOCKED
CURRENT
COMPLETE
SKIPPED
EXPIRED
```

### `LOCKED`

Future phase. Its conversations and timestamps are inaccessible.

### `CURRENT`

The only phase allowed to create new playable content.

### `COMPLETE`

All mandatory content for the phase is resolved and the phase has advanced.

### `SKIPPED`

The player explicitly chose to advance without seeing an optional scene.

### `EXPIRED`

The original context no longer exists. The exact scene cannot be opened later.

A skipped or expired scene may later create:

- a missed-opportunity flag;
- a colder mutation;
- a delayed consequence;
- no effect, when the opportunity was deliberately low-stakes.

It may not remain frozen at its old timestamp.

---

## 5. Required and optional content

Every temporal phase declares:

```text
required_conversation_ids
optional_conversation_ids
```

### Required content

The phase cannot advance until every required item is complete.

Examples:

- Marie's opening request;
- the selected O5 branch;
- the mandatory O6 return to Marie;
- a consent or aftermath consequence.

### Optional content

The player may:

- open it now;
- ignore it and continue;
- deliberately defer it only when the authored contract provides a later mutation.

Optional does not mean timeless.

---

## 6. Advancing a phase

When required content is complete, the interface may display an explicit action:

```text
Continuer
Passer à 16:05
Terminer la soirée
Aller au lendemain
```

If optional content remains unseen, the advance action must communicate consequence clearly enough for the context.

Examples:

```text
Passer à 16:05
Sandra ne sera plus disponible dans cette fenêtre.
```

or, for a low-pressure echo:

```text
Continuer
```

The advance operation must:

1. mark the current phase `COMPLETE`;
2. mark unseen optional scenes `SKIPPED` or `EXPIRED`;
3. write any configured missed flags;
4. hide those expired episodes from active interaction;
5. activate the next phase;
6. update narrative time;
7. display the appropriate temporal transition.

---

## 7. Day completion contract

A day is complete only when:

- every required phase is complete;
- the final consequence or shared-life anchor is resolved;
- no safety, consent, discovery, or aftermath scene is due;
- all optional content has a terminal state;
- the day-end state writes have been applied.

The presence of a final timestamp does not complete a day by itself.

### Couple-centrality requirement

When the day contains meaningful external attention, the final required phase must return to:

- Marie;
- the shared home;
- an explicit couple consequence;
- or a documented reason why the shared-life return belongs to the next immediate phase.

J1 must end on Marie/shared life.

Thursday must end on O6 Marie.

---

## 8. Day-transition interstitial

A completed day transitions through a full-screen or phone-screen overlay.

Recommended sequence:

```text
<MARDI — FIN DE JOURNÉE>

then

<MERCREDI — MIDI>
<Faire de la place>
```

### Presentation contract

The interstitial should:

- cover or clearly replace the conversation list;
- use large readable weekday typography;
- optionally show the next narrative title;
- use a short fade or cut;
- last long enough to be perceived, but not become a loading screen;
- be skippable after a minimum readable delay;
- block interaction with future conversations until completion;
- automatically select the newly unlocked day.

Recommended default timing:

```text
end card: 0.9–1.2 seconds
start card: 1.2–1.6 seconds
minimum before skip: 0.35 seconds
```

Exact animation timing is a runtime decision within this range.

### No false loading promise

The overlay is an authored time transition, not evidence of background loading.

---

## 9. Intra-day transition card

Large changes within a day use a shorter overlay or timeline card.

Examples:

```text
JEUDI — DÉBUT D'APRÈS-MIDI
13:50
```

```text
JEUDI — FIN D'APRÈS-MIDI
16:05
```

Recommended duration:

```text
0.7–1.1 seconds
```

The card may be skipped after a brief readable delay.

A minor five-minute progression does not require an overlay.

Use an intra-day card when:

- several hours have passed;
- work has ended;
- the location/context changes materially;
- an optional window closes;
- the story moves from setup to an event;
- evening or night begins.

---

## 10. Current-day and archive navigation

### Current/future

- only unlocked days appear as usable buttons;
- future days remain hidden by default;
- a visible locked preview is allowed only if Product Owner explicitly validates it.

### Past days

Past completed days remain reviewable.

Opening an archived day:

- does not recreate pending badges;
- does not replay notifications;
- does not rerun choices;
- does not change current narrative time;
- does not reactivate missed optional scenes;
- does not overwrite active-day context.

The interface should visibly distinguish:

```text
archive review
vs
current playable day
```

---

## 11. Notification rule

A notification belongs to one active temporal phase.

It may appear only when:

- the target day is `ACTIVE`;
- the target phase is `CURRENT`;
- the conversation is available in that phase;
- its conditions are satisfied;
- it has not already been opened or expired.

Opening another conversation with a later timestamp must never be possible before the timeline has advanced to that phase.

A notification cannot move time by itself without the corresponding phase transition.

---

## 12. Timestamp rule

Within one active chronology:

- message timestamps are non-decreasing;
- phase time is non-decreasing;
- an archived old message may show its historical time without changing the current clock;
- a new episode with an earlier timestamp than current narrative time is invalid unless explicitly framed as an old imported trace.

```text
The status-bar clock must not be used to hide contradictory message timestamps.
```

The source data itself must remain chronologically coherent.

---

## 13. Data contract

Recommended index structure:

```json
{
  "timeline_flow": {
    "initial_phase_id": "thursday_morning_work",
    "phases": [
      {
        "id": "thursday_morning_work",
        "calendar_label": "Jeudi",
        "moment_label": "matin",
        "time_label": "09:10",
        "required_conversation_ids": [
          "chapter_03_raphaelle_blue_folder"
        ],
        "optional_conversation_ids": [],
        "entry_card": {
          "eyebrow": "JEUDI — MATIN",
          "title": "Être là"
        },
        "next_phase_id": "thursday_midday_optional"
      },
      {
        "id": "thursday_midday_optional",
        "calendar_label": "Jeudi",
        "moment_label": "début d'après-midi",
        "time_label": "13:50",
        "required_conversation_ids": [],
        "optional_conversation_ids": [
          "chapter_03_sandra_continuity"
        ],
        "advance_label": "Passer à 16:05",
        "expire_optional_on_advance": true,
        "missed_flags": [
          "thursday_sandra_echo_missed"
        ],
        "next_phase_id": "thursday_marie_offer"
      }
    ]
  }
}
```

Field names remain subject to the V0.84 implementation plan, but the semantics are canonical.

---

## 14. Thursday correction

The current V0.82 behavior unlocks Sandra at 13:50 and Marie at 16:05 simultaneously after Raphaëlle.

That is no longer the target behavior.

Correct flow:

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> explicit advance
-> Sandra seen or expired
-> 16:05 Marie required
-> selected O5 branch
-> 22:10 Marie return required
-> Thursday complete
```

The player may skip Sandra.

The player may not answer Sandra at 13:50 after already acting at 16:05 or later.

---

## 15. Tuesday–Wednesday correction

The current runtime exposes Tuesday, Wednesday, and Thursday from the beginning.

Target behavior:

```text
Tuesday is initially active.
Wednesday remains locked.
Thursday remains locked.

Tuesday complete
-> day-end/start interstitial
-> Wednesday unlocked and selected

Wednesday complete
-> day-end/start interstitial
-> Thursday unlocked and selected
```

Thursday completion may show a day-end card while Friday remains unavailable until its later implementation.

---

## 16. Reset rule

Reset must restore:

- first active day only;
- initial phase of that day;
- no pending history from later phases;
- no expired/missed flags;
- no transition overlay left visible;
- no future-day button;
- no duplicate archived offline beat.

---

## 17. Validation checklist

A temporal implementation is valid only if:

- [ ] future days are inaccessible before unlock;
- [ ] completing a day automatically unlocks/selects the next day;
- [ ] a readable day-end/start interstitial appears;
- [ ] archived days remain read-only;
- [ ] required phases cannot be skipped;
- [ ] optional phases can be explicitly skipped;
- [ ] skipped optional conversations expire or mutate;
- [ ] no conversation can be answered after its time window has passed;
- [ ] future timestamps do not appear early;
- [ ] message timestamps never move backward within active chronology;
- [ ] final day consequence is paid before completion;
- [ ] reset restores the initial chronology cleanly.

---

## 18. Final rule

```text
The player may choose what to do inside time.
The player may not rearrange time by opening whatever thread is visible.

Days unlock.
Moments advance.
Opportunities expire.
Consequences close the day.
```
