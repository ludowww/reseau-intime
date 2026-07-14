# V0.91 — First Repetition Wave Closure Blueprint Report

> Documentation-only milestone after locked V0.90.
> Defines how the implemented W9–W13 first-repetition wave closes before any new narrative wave begins.
> No runtime, JSON, GDScript, test, scene, asset, save, merge, or tag change is made by this report.

## 1. Baseline

```text
Repository: ludowww/reseau-intime
Base version: V0.90 — Second Repetition Sandra Vertical Slice
Base main commit: 851ad02200ac2bef974eef89c4b56ed9b14f8bd1
Base tag: v0.90-second-repetition-sandra-vertical-slice
Planning branch: work/first-repetition-wave-closure-blueprint-v0-91
```

Locked V0.90 already implements:

```text
W9  Marie shared hour
W10 Mathilde opportunity
W11 Marie return
W12 Sandra opportunity
W13 Marie return
```

It writes:

```text
first_repetition_slice_01_complete
first_repetition_slice_02_complete
```

It intentionally does not yet write:

```text
first_repetition_wave_complete
```

---

## 2. Product decision

The first-repetition wave closes after the existing Monday W13 return.

No third external foreground is added.

The future runtime target is:

```text
V0.92 — First Repetition Wave Closure Runtime
```

V0.92 should add one silent guarded closure phase and no new conversation, character, image, day, route stage, or relationship frame.

Monday remains the runtime endpoint.

---

## 3. Why no third foreground is needed

The V0.87 source pack authorized:

```text
zero to two external foregrounds
maximum two tickets
maximum one charged owner
mandatory Marie returns
```

The current runtime already supplies two bounded opportunities:

```text
Mathilde
Sandra
```

Each opportunity may resolve, expire, or defer.

Wave completion records the end of the bounded sequence. It does not require every route candidate to appear.

Raphaëlle, Pauline, and Nico remain future material for a later wave rather than being compressed into W13.

---

## 4. Closure contract

Required before closure:

```text
first_repetition_slice_01_complete
first_repetition_slice_02_complete
Monday Marie return completed and resolved
no SCHEDULED / DUE / CARRIED obligation
Mathilde and Sandra lifecycle terminal when present
foreground count <= 2
foreground arrays consistent and duplicate-free
charged owner valid and already foregrounded
```

Terminal obligation statuses:

```text
PAID
FAILED
```

Terminal scene statuses:

```text
RESOLVED
EXPIRED
DEFERRED
```

The only new narrative fact required is:

```text
first_repetition_wave_complete = true
```

No new ledger field is required.

---

## 5. Charged-owner decision

The closure preserves the current owner.

Reachable V0.90 values:

```text
charged_access_owner = ""
charged_access_owner = "mathilde"
```

Sandra remains R1 in the implemented wave.

Closure does not:

- promote Sandra;
- clear Mathilde;
- transfer ownership;
- create a second owner;
- grant adult or image permission;
- create a secret or automatic next scene.

---

## 6. Couple-state decision

All three Monday Marie outcomes may close the wave:

```text
active return
bounded return
honest distance
```

The closure preserves existing evidence instead of producing a final verdict.

```text
Marie / Player mode = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
```

Positive and drift evidence may coexist.

No repair lock, breakup lock, confession, affair, or frame change is created.

---

## 7. Future V0.92 scope

Expected small implementation boundary:

```text
new pure FirstRepetitionClosure helper
new PhonePrototypeV092 adapter
one final Monday internal phase
one static test module
one isolated runtime smoke suite
```

Expected unchanged narrative content:

```text
chapter_07_sandra_end_of_shift.json
chapter_07_marie_monday_return.json
all visual-content bundles
```

V0.92 must keep:

```text
chapter_07 next_day = null
```

Tuesday remains unavailable.

---

## 8. Next-wave handoff

A later documentation milestone should define:

```text
V0.93 — Next Act I Wave Source Pack
```

Its entry condition is:

```text
first_repetition_wave_complete = true
```

The closed `first_repetition` ledger remains historical and is not reset.

A later wave should use a new named ledger or state root rather than reopening the first wave.

---

## 9. Explicit exclusions

V0.91 and future V0.92 exclude:

- third external foreground;
- Raphaëlle, Pauline, or Nico foreground;
- new Sandra or Mathilde scene;
- new Marie conversation;
- new day or Tuesday runtime;
- image or visual bundle;
- hard secret or affair;
- adult frame or adult image;
- R3+;
- relationship-mode change;
- route-selection menu;
- summary screen or visible closure card;
- save system;
- TimelineState or ConversationView rewrite;
- ObjectDB leak cleanup bundled into closure.

---

## 10. Documentation result

Created:

```text
docs/runtime/V0_91_FIRST_REPETITION_WAVE_CLOSURE_BLUEPRINT.md
docs/V0_91_First_Repetition_Wave_Closure_Blueprint_Report.md
```

No general documentation is reconciled in this branch before Product Owner validation.

No runtime or test file is changed.

---

## 11. Product validation checklist

- [ ] W13 is the correct closure point.
- [ ] Zero to two external foregrounds are all valid exits.
- [ ] No third foreground is required.
- [ ] Unresolved obligations correctly block closure.
- [ ] Terminal candidate statuses are complete.
- [ ] Mathilde owner is preserved rather than cleared.
- [ ] Sandra correctly remains R1.
- [ ] Honest distance is a valid terminal outcome.
- [ ] Couple mode and relationship frame remain unchanged.
- [ ] Monday remains the endpoint.
- [ ] Tuesday waits for a later source pack.
- [ ] The future V0.92 implementation boundary is sufficiently small.
- [ ] ObjectDB leak work remains separate.

## 12. Final decision line

```text
Close the first repetition wave after the existing Monday Marie return.
Preserve what happened.
Do not invent a third temptation to justify completion.
```
