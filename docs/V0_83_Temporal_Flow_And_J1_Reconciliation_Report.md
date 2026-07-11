# V0.83 — Temporal Flow & J1 Reconciliation Report

> Documentation-only correction after V0.82.  
> Suspends Friday implementation until chronological progression and J1 coherence are repaired.  
> No runtime, JSON, GDScript, tests, assets, or playable content are changed.

## 1. Trigger

Product review identified three issues:

1. days do not transition automatically;
2. J1 contains possible inconsistencies;
3. several conversations may be available at once even though their timestamps imply a fixed chronological order.

The audit confirms all three.

---

## 2. Current runtime issue — days are a menu

V0.82 loads Tuesday, Wednesday, and Thursday indexes at startup.

The phone immediately renders a button for every loaded day.

Consequences:

- the player may open Wednesday or Thursday before completing Tuesday;
- no end-of-day state exists;
- no start-of-day transition exists;
- selecting a day is closer to debug navigation than lived chronology;
- archived-day visits may recreate pending-state behavior;
- the story does not automatically advance.

Decision:

```text
Future days must be locked.
Completing a day must unlock and select the next day.
A readable transition interstitial must mediate the change.
```

---

## 3. Current runtime issue — timestamps do not gate access

V0.82 correctly prevents the status-bar clock from moving backward.

However, the availability model still allows earlier and later conversations to coexist.

Current Thursday behavior after Raphaëlle:

```text
Sandra unlocks at 13:50
Marie unlocks at 16:05
```

Both become available at once.

The player may open Marie first and Sandra afterward.

The clock remains at 16:05 or later, but Sandra's messages still display 13:50.

Decision:

```text
A monotonic clock is not enough.
Temporal phases must gate conversation access.
```

Correct Thursday sequence:

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> explicit advance
-> Sandra seen or expired
-> 16:05 Marie required
-> one O5 branch
-> 22:10 Marie return required
```

---

## 4. J1 audit verdict

The active Tuesday index filters only the most obvious Mathilde contradiction from two legacy conversation files.

The remaining active content is not aligned with the V0.69 line source or current temporal rules.

### Confirmed contradictions

#### Wrong weekday inside Tuesday

Sandra says:

```text
une question à laquelle je ne vais pas répondre un mardi soir
```

Player later replies:

```text
On est mercredi.
```

The active day is Tuesday.

#### Timestamps move backward

Marie reaches later timestamps, then a subsequent segment restarts earlier.

Sandra reaches approximately 23:26, then a later main segment restarts around 23:07.

The status bar may hide this visually, but bubble timestamps remain contradictory.

#### J1 ends on Sandra

Current active structure:

```text
all Marie content
-> all Sandra content
-> day ends
```

Canon requires:

```text
Marie opening
-> shared-life action
-> Sandra trace
-> final return to Marie/shared life
```

#### Shared evening is missing

The runtime promises:

- bread;
- dinner;
- a walk;
- phone set down.

But the actual face-to-face evening is not represented before the late Sandra thread.

#### Sandra advances too far

Legacy content adds:

- lake/nature memory;
- romance-novel exposition;
- missing-each-other escalation;
- `Toi` as an explicit answer;
- Player's deep `absent de moi-même` confidence;
- numeric attachment/priority effects.

This exceeds J1's intended soft-trace function.

#### Excessive one-option clicking

The legacy files convert dozens of fixed Player lines into separate one-option buttons.

This creates mechanical fragmentation rather than meaningful choice.

#### Legacy numeric state

J1 still writes old scores such as:

```text
marie_attention_score
marie_neglect_score
sandra.attachment
sandra_priority_score
truth_tendency
```

Wednesday/Thursday now use observable flags instead.

---

## 5. V0.83 canon decisions

### Decision A — explicit timeline state

Add canonical day and phase lifecycles:

```text
Day: LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
Phase: LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

### Decision B — transition interstitials

Day transition example:

```text
MARDI — FIN DE JOURNÉE

MERCREDI — MIDI
Faire de la place
```

Intra-day transition example:

```text
JEUDI — FIN D'APRÈS-MIDI
16:05
```

### Decision C — future days locked

Only the current day and completed archives are selectable.

### Decision D — optional scenes expire

Sandra's Thursday echo may be seen or skipped before advancing to Marie.

It cannot be answered later at 13:50 after the story has moved to 16:05.

### Decision E — replace active J1 files

Do not keep expanding the current filter.

Create new concise modular J1 files and leave the large legacy files inactive.

### Decision F — J1 ends on Marie

Tuesday completes only after a mandatory final Marie/shared-life offline beat.

### Decision G — no Friday yet

Pauline/Nico Friday integration is postponed until temporal flow and J1 are repaired.

---

## 6. New documents

```text
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md
docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md
docs/runtime/V0_84_DAY_AND_MOMENT_FLOW_IMPLEMENTATION_PLAN.md
docs/runtime/V0_85_J1_CANON_RUNTIME_RECONCILIATION_PLAN.md
docs/V0_83_Temporal_Flow_And_J1_Reconciliation_Report.md
```

---

## 7. J1 replacement structure

```text
18:12 Marie remote opening
-> M1 three choices
-> La Verrière / indirect Mathilde seed

19:15 shared dinner/walk offline beat

22:57 Sandra old lunch trace
-> S1 three choices
-> soft boundary

23:25 final Marie/shared-life offline beat

Tuesday complete
-> day transition
-> Wednesday unlock
```

Meaningful choices:

```text
M1 — present / playful-present / delayed-flat
S1 — safe warmth / precise observation / cautious
```

No numeric effects.

---

## 8. Runtime sequence

The corrected roadmap becomes:

```text
V0.83 — documentation correction
V0.84 — day and moment flow foundation
V0.85 — J1 canon runtime reconciliation
V0.86 — Friday public traces and opening completion
```

V0.84 does not rewrite dialogue.

V0.85 does not modify Wednesday/Thursday story meaning.

V0.86 resumes the previously planned Pauline/Nico Friday content.

---

## 9. V0.84 acceptance focus

- Tuesday initially visible; Wednesday/Thursday locked;
- automatic day transitions;
- readable interstitials;
- archived days read-only;
- temporal phases;
- Sandra optional 13:50 before Marie 16:05;
- explicit skip/expiry;
- no answering expired conversations;
- Thursday final Marie consequence required;
- Friday absent.

---

## 10. V0.85 acceptance focus

- new active J1 files;
- no filter-based legacy Tuesday;
- timestamps monotonic;
- no wrong weekday;
- concise Marie opening;
- offline dinner/walk;
- concise Sandra trace;
- no deep Sandra escalation;
- no legacy numeric effects;
- final Marie/shared-life beat;
- Wednesday unlock only after final beat.

---

## 11. Scope verification

V0.83 changes documentation only.

It changes no:

- `game/` file;
- conversation JSON;
- GDScript;
- scene;
- visual asset;
- test;
- current playable line;
- current runtime state.

V0.82 remains the playable baseline while V0.83 is reviewed.

---

## 12. Product decisions to review

1. Friday is postponed.
2. Future days are locked rather than immediately selectable.
3. Day completion automatically transitions to the next day.
4. Day transitions use a short full-screen/phone-screen interstitial.
5. Large intra-day jumps use shorter transition cards.
6. Optional scenes expire when their phase is skipped.
7. Thursday Sandra must occur or expire before Marie 16:05.
8. Current J1 legacy files become inactive rather than increasingly filtered.
9. J1 is rebuilt from V0.69 into two concise conversations and two offline beats.
10. J1 uses two three-choice nodes only.
11. J1 writes flags rather than old numeric scores.
12. Tuesday ends on Marie/shared life before Wednesday unlocks.

---

## 13. Final rule

```text
Do not add Friday to a chronology the player can rearrange.

First make time advance.
Then make the first evening true.
Then continue the opening.
```
