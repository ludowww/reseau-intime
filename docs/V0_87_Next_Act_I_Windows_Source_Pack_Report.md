# V0.87 — Next Act I Windows Source Pack Report

> Documentation-only milestone after V0.86 opening completion.  
> Defines the first post-opening repetition wave and its route ceilings.  
> Does not modify runtime, JSON, GDScript, scenes, tests, or assets.

## 1. Baseline

```text
Repository: ludowww/reseau-intime
Base version: V0.86
Base main commit: ba22baf1f901e932f9c755344712363274a827ae
Branch: work/next-act-i-windows-source-pack-v0-87
Runtime baseline: Tuesday–Friday opening complete
```

Inherited state:

```text
opening_band_complete = true
household_rhythm_confirmed = true

Marie / Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE

Sandra = soft trace / ordinary continuity
Mathilde = R1 household access
Raphaëlle = R1 work access
Pauline = R1 social/public access
Nico = R1 friendship/social access

hard secrets = none
adult frames = none
routes R2+ = none
```

---

## 2. Goal

V0.87 answers the first question after ordinary access:

```text
Which repeated attention changes meaning first?
```

The milestone does not write the rest of Act I.

It defines a short first repetition wave across:

```text
the weekend after Friday
through the first one or two workdays
```

The wave must remain modular, replayable, and psychologically selective.

---

## 3. New canonical documents

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
```

Boundary note for the next implementation phase:

```text
docs/runtime/V0_88_FIRST_REPETITION_RUNTIME_PREPARATION_NOTE.md
```

---

## 4. Fixed architecture

```text
W9  — Marie claims one shared hour
W10 — weekend repetition opportunity
W11 — mandatory couple return
W12 — first-workday repetition opportunity
W13 — wave close / couple balance
```

The wave contains:

```text
one fixed Marie foreground
+ two external foreground tickets maximum
+ mandatory Marie/shared-life returns
+ zero to two echoes per window
```

No character-selection menu exists.

No playthrough should show every external character foreground.

---

## 5. Foreground scene pool

```text
marie_saturday_shared_hour_01
mathilde_morning_kitchen_afterglow_01
sandra_ticket_ghost_hot_chocolate_01
raphaelle_lunch_walk_outside_work_01
pauline_bastien_sunday_table_01
nico_pre_shift_lunch_friendship_01
marie_concrete_return_due_01
```

### Marie

Marie receives a fixed positive scene for herself.

She has already left the apartment, completed a real errand, and offers Player one bounded shared hour.

Player may:

- join now;
- propose a real bounded alternative;
- leave Marie to enjoy the hour independently.

The scene creates observable reconnection or drift evidence without changing couple mode after one choice.

### Mathilde

An ordinary morning kitchen moment becomes readable only after Mathilde notices Player's gaze and later reopens the subject from a distance.

The scene distinguishes:

```text
normal fitted clothing
from
chosen sexual intent
```

Mathilde may become the single R2 owner, but deliberate intent, image permission, and adult consent remain false.

### Sandra

Sandra chooses Player for a late work-afterglow conversation about a recurring SentryCore problem and a hot chocolate.

No new photograph is sent.

The scene may become R2 only when prior precision and respected boundaries justify it.

### Raphaëlle

A resolved work task opens a short lunch walk.

The route progresses through one selected ordinary layer outside work, not a costume, private account, photo, or therapy scene.

Raphaëlle may become the single R2 owner if Player joins without using her as refuge from Marie.

### Pauline

Pauline and Bastien host a real ordinary social plan.

The scene completes Pauline's required second legitimate cycle.

It keeps:

- Bastien visible;
- Marie active;
- Pauline socially competent;
- private selectivity locked.

Pauline remains R1.

### Nico

Nico offers a pre-shift lunch and exists in a quiet friendship mode rather than as a voyeur or jealousy button.

No photo request, domestic-view exchange, or alibi is allowed.

Nico remains R1.

---

## 6. Charged-access rule

Only three characters may become first charged-access candidates in this pack:

```text
Mathilde
Sandra
Raphaëlle
```

Global ceiling:

```text
charged_access_owner = none | mathilde | sandra | raphaelle
maximum one owner
```

If one route reaches R2:

- the other charged candidates remain ordinary or defer;
- a Marie consequence becomes due before another external opportunity;
- no adult permission or relationship-frame change occurs.

Pauline and Nico remain R1 because their dangerous engines require another validated cycle after their ordinary repetition.

---

## 7. Couple centrality

Every external foreground returns to:

```text
marie_concrete_return_due_01
```

The return asks for:

- an immediate real act;
- a bounded later act;
- or honest acknowledgement that no repair is currently being made.

It does not demand a grand confession when no explicit couple boundary has been crossed.

The consequence is:

- opportunity cost;
- changed presence;
- a paid or missed shared act;
- evidence toward active reconnection or parallel drift.

Couple mode remains:

```text
HABITUAL_WARMTH
```

throughout V0.87 source content.

---

## 8. Route ceilings

| Character | Start | V0.87 maximum | Explicitly still locked |
|---|---|---|---|
| Marie | `HABITUAL_WARMTH` | same mode + evidence | instant mode change |
| Sandra | R1 | R2 at most | image, confession, affair |
| Mathilde | R1 | R2 at most | deliberate seduction, image, adult permission |
| Raphaëlle | R1 | R2 at most | creative account, costume, image, named attraction |
| Pauline | R1 | R1 | private alternate, secret test, reciprocal proof |
| Nico | R1 | R1 | shared gaze, image request, alibi |

Global exclusions:

```text
hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
relationship frame change = none
```

---

## 9. Temporal model

Default chronology:

```text
Saturday morning — Marie shared hour
Saturday / Sunday — first compatible repetition ticket
same evening / next morning — Marie return
Monday / Tuesday — second compatible repetition ticket
same evening — Marie return and wave close
```

The exact selected character depends on:

- state;
- location;
- schedule;
- prior topology;
- cooldown;
- whether another consequence is due;
- whether the two-ticket budget is already consumed.

The clock does not summon a character merely because their JSON exists.

---

## 10. Communication model

V0.87 preserves current smartphone behavior:

```text
last message
-> contact offline
-> two-second pause
-> four-second accelerated clock at Speed x1
-> cross-thread compact notification
```

When the next episode belongs to the currently open thread:

```text
clock advances
-> no notification for the same contact
-> conversation resumes directly
```

The source pack requires:

- no blank moment page;
- no `Le temps passe` prompt;
- no visible offline-beat explanation;
- no `Moments hors ligne` archive section;
- no long Messenger chat between co-present characters.

---

## 11. Trace and image decision

V0.87 requires no new visual asset.

Existing traces retain their original origin, audience, and function.

```text
j1_sandra_lunch_memory_soft
mathilde_arrival_room_01
marie_laverriere_setup_01
laverriere_public_group_photo_set_01
```

No trace is recropped, privately forwarded, or converted into adult permission.

This deliberate image restraint prevents every route from becoming a photo loop and preserves later image escalation as meaningful.

---

## 12. Replay model

One playthrough should produce:

```text
Marie fixed entry
+ zero to two external foregrounds
+ mandatory return consequences
+ selected echoes
```

Replay changes:

- which characters receive the two tickets;
- whether one route reaches R2;
- which invitations defer or expire;
- whether Player pays Marie's shared-hour promise;
- whether the weekend becomes joined or parallel.

Replay does not change consent rules, character identity, or route ceiling.

---

## 13. Cooldown and mutation

Every authored opportunity has:

- a bounded offer interval;
- an explicit cooldown;
- an ignored/missed result;
- a future mutation;
- a fresh-reason requirement.

Examples:

- Mathilde stops asking about the exact gaze if ignored;
- Sandra's late interval expires that night;
- Raphaëlle offers one deferred walk, not permanent availability;
- Pauline's dinner happens without Player;
- Nico eats and starts his shift;
- Marie's hour belongs to Marie if Player does not join.

No frozen scene waits forever.

---

## 14. Documentation maintenance

The V0.87 pass updates:

- reading order;
- current narrative status;
- character doorway / current activation notes;
- global story state;
- continuity matrix;
- README;
- roadmap;
- runtime documentation index;
- the V0.87 preparation note.

Character identity files are not rewritten because V0.87 does not change who the characters are.

---

## 15. Validation checklist

Documentation review must confirm:

- [ ] source pack, scene cards, and temporal map agree;
- [ ] exactly two external foreground tickets maximum;
- [ ] exactly one charged-access owner maximum;
- [ ] Pauline and Nico remain R1;
- [ ] Marie receives a fixed positive scene and mandatory returns;
- [ ] every scene has conditions, exclusions, cooldown, mutation, and fallback;
- [ ] no new image is required;
- [ ] no hard secret or adult frame appears;
- [ ] no co-present fake chat is authored;
- [ ] current V0.86a time/notification behavior is preserved;
- [ ] no runtime file is changed.

Repository checks for this documentation-only branch:

```bash
git diff --check

git diff --name-only main...HEAD
```

Expected changed-file scope:

```text
docs/**
README.md
ROADMAP.md
```

No `game/**`, `tests/**`, or `tools/**` file should change.

---

## 16. Next step

After Product Owner validation:

```text
V0.88 — First Repetition Runtime Integration Plan
```

V0.88 remains documentation-first.

It must map:

- foreground tickets;
- deterministic selection;
- one charged-access owner;
- obligation priority;
- same-thread continuation;
- expiry/mutation;
- conceptual state labels to current runtime state;
- the smallest possible vertical slice.

No V0.87 scene should enter runtime before that plan is validated.

---

## 17. Final result

```text
V0.86 completed ordinary access.
V0.87 decides how repetition acquires charge.

The next adult power comes from a person choosing attention again,
not from the game opening every fantasy at once.
```
