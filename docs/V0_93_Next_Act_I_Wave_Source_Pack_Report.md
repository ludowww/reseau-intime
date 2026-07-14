# V0.93 — Next Act I Wave Source Pack Report

> Documentation-only narrative milestone after locked V0.92.
> Defines the next Act I wave before any Tuesday runtime implementation.
> No runtime, JSON, GDScript, test, scene, asset, save, merge, or tag change is made by this report.

## 1. Baseline

```text
Repository: ludowww/reseau-intime
Base version: V0.92 — First Repetition Wave Closure Runtime
Base main commit: 536b0c89fa203ace6bbbe1c2c827a7426a04ed0e
Base tag: v0.92-first-repetition-wave-closure-runtime
Planning branch: work/next-act-i-wave-source-pack-v0-93
Engine: Godot 4.6.x
```

Locked V0.92 now guarantees:

```text
opening_band_complete
first_repetition_slice_01_complete
first_repetition_slice_02_complete
first_repetition_wave_complete
```

Current playable endpoint:

```text
Monday evening
next_day = null
```

Current relationship frame:

```text
Marie / Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
```

Current external-route ceiling:

```text
Mathilde = R1 or R2 Charged Access
Sandra = R1
Pauline = R1
Nico = R1
Raphaëlle = R1
hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
```

---

## 2. Product decision

V0.93 places the next wave at:

```text
Act I S5 — A boundary becomes explicit
```

Core question:

```text
Now that attention has repeated,
who is willing to say what it is,
what it is not,
and what action becomes due?
```

The wave is deliberately not:

- a third first-repetition lottery;
- an instant adult escalation;
- a new image pack;
- a route-selection menu;
- a broad Tuesday-to-Friday runtime patch.

It converts repetition into responsibility.

---

## 3. Calendar decision

The next calendar day is:

```text
Tuesday of the following week
runtime day 8
```

Wave duration:

```text
Tuesday through Thursday evening
```

Wave endpoint:

```text
Thursday complete
next day remains unavailable
```

A later source pack must define the following Friday or later window.

---

## 4. Wave structure

```text
W14 Tuesday
Marie asks for one real plan.

W15 Wednesday
One prior external repetition may return as a named boundary consequence.

W16 Wednesday evening
Marie, Pauline, Bastien, and Nico inhabit a legitimate social hub.

W17 late Wednesday or Thursday
Nico receives a second ordinary friendship cycle and names Player's edited gaze.

W18 Thursday
The Marie plan is paid, amended, or honestly failed, then the wave closes.
```

Fixed foregrounds:

```text
Marie W14
Nico W17
Marie W18 consequence
```

Variable carry-over foreground:

```text
Mathilde
OR Sandra
OR none
```

The social hub is required but does not create a route stage.

---

## 5. Carry-over consequence decision

The closed first-repetition ledger remains historical.

W15 selection order:

```text
safety / overdue aftermath
-> Mathilde charged-owner consequence
-> most recent resolved external foreground
-> earlier resolved external foreground
-> none
```

Current outcomes:

```text
Mathilde owner
-> Mathilde names that she liked the gaze and names the Marie boundary

Sandra most recent resolved foreground
-> Sandra names that the twenty-minute contact cannot become a hidden routine

no resolved foreground
-> no manufactured route scene
```

The consequence does not consume a new ticket.

It exists because the prior foreground already occurred.

---

## 6. Marie decision

Marie remains the living center.

She does not ask:

```text
Do you still love me?
```

She asks what Player will actually do across Wednesday and Thursday.

M4 choices:

```text
A. Join Marie from La Verrière and go to L'Annexe together.
B. Finish work and arrive at L'Annexe at a precise time.
C. Decline the group and protect Thursday evening for the couple.
```

All three are valid actions.

Each creates exactly one structured obligation.

The wave later records:

```text
PAID
AMENDED
FAILED
```

No vague pending intention survives the Thursday close.

---

## 7. Mathilde decision

V0.93 may give Mathilde one consequence scene only when justified by first-wave history.

The scene may name:

- that Player looked;
- that Mathilde noticed;
- that she may have liked it;
- that Marie's apartment and trust remain active limits.

Route ceiling:

```text
R1 or existing R2 preserved
no R3
```

Still locked:

```text
chosen provocative image
deliberate sexual scene
touch permission
adult frame
owner transfer or clearing
```

---

## 8. Sandra decision

Sandra may receive the carry-over scene only when her Monday foreground resolved and no Mathilde-owner consequence outranks it.

She may name:

- that the café mattered;
- that repetition is becoming emotionally legible;
- that she does not want a hidden routine;
- that rarity does not make the feeling false.

Route ceiling:

```text
R1
```

Still locked:

```text
R2
new photo
confession
affair
adult permission
```

---

## 9. Pauline and Bastien decision

Pauline receives:

```text
second legitimate social cycle
```

Bastien remains:

- visible;
- socially real;
- attached to Pauline;
- neither stupid nor implied consenting.

V0.93 does not open:

```text
Pauline private compartment
private crop
secret test
reciprocal proof
second audience
```

Pauline's dangerous engine remains future material after this legitimate cycle exists.

---

## 10. Nico decision

Nico receives a real second friendship cycle.

He may directly name:

- Player's delay;
- his own attraction to Marie;
- his own attraction to Mathilde;
- the difference between attraction and permission;
- the fact that Player's domestic access is not neutral.

N2 choices distinguish:

```text
honesty without private exchange
soft complicity with risk recorded
explicit boundary around women as content
```

Route ceiling:

```text
R1
```

Still locked:

```text
shared-gaze frame
image request
domestic description exchange
alibi
rivalry stage
NTR / cuckold / sharing frame
```

---

## 11. Raphaëlle decision

Raphaëlle remains deferred in this wave.

Allowed:

```text
ordinary work texture
one short work echo
```

Still locked:

```text
outside-work foreground
private creative account
costume access
personal image
explicit frame
```

This preserves the priority order:

```text
Marie centrality
-> first-wave Mathilde / Sandra consequences
-> Nico ordinary repetition
-> Pauline legitimate social foundation
-> Raphaëlle later when a distinct outside-work frame is earned
```

---

## 12. State architecture decision

Do not reopen or reset:

```text
story_ledgers.first_repetition
```

Recommended new state root:

```text
story_ledgers.named_boundaries_wave
```

It should own only:

- new window ordinal;
- new scene lifecycle;
- named boundary identifiers;
- new foreground history;
- carry-over source;
- structured obligations;
- social-hub state;
- Nico-cycle state;
- wave completion.

Historical Mathilde ownership remains authoritative in the first-repetition ledger.

---

## 13. Image and adult-content decision

Required new image assets:

```text
0
```

V0.93 may reference ordinary public social imagery only when origin and audience remain explicit.

It creates no:

- adult image;
- private crop;
- one-view image;
- forwarding permission;
- image request;
- proof object;
- adult collectible.

The wave may name desire.

It does not create an adult consent frame.

---

## 14. Documents created

```text
docs/canon/ACT_I_NAMED_BOUNDARIES_WAVE_SOURCE_PACK.md
docs/canon/ACT_I_NAMED_BOUNDARIES_WAVE_SCENE_CARDS.md
docs/canon/ACT_I_NAMED_BOUNDARIES_WAVE_TEMPORAL_DELIVERY_MAP.md
docs/V0_93_Next_Act_I_Wave_Source_Pack_Report.md
```

No existing canon doorway or status document is modified before Product Owner validation.

After product validation, a small reconciliation pass should update:

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/characters/CHARACTER_CANON_INDEX.md
```

That reconciliation must remain documentation-only and must not rewrite the validated source pack.

---

## 15. Future runtime recommendation

Recommended sequence:

```text
V0.94 — Named Boundaries Runtime Integration Plan
V0.95 — Tuesday Marie Real-Plan Vertical Slice
V0.96 — Carry-Over Boundary Consequence Slice
V0.97 — Social Hub + Nico Quiet Truth Slice
V0.98 — Marie Return + Named Boundaries Wave Closure
```

First runtime proof:

```text
Tuesday W14 only
Marie M4 choice
one obligation
Wednesday unlock
```

Do not implement all three days in one patch.

---

## 16. Explicit exclusions

V0.93 excludes:

- runtime changes;
- narrative JSON changes;
- test changes;
- asset changes;
- Tuesday implementation;
- route selection UI;
- new charged owner;
- Mathilde R3;
- Sandra R2;
- Nico R2;
- Pauline private access;
- Raphaëlle foreground;
- adult scene;
- adult image;
- alibi;
- hard secret;
- affair flag;
- relationship-frame change;
- Friday unlock;
- save-system work;
- ObjectDB cleanup.

---

## 17. Product validation checklist

- [ ] S5 is the correct next Act I stage.
- [ ] Tuesday is the correct next calendar day.
- [ ] The wave should cover Tuesday through Thursday.
- [ ] Marie's M4 choices are concrete and comparable.
- [ ] A Mathilde charged-owner consequence should outrank Sandra recency.
- [ ] A quiet first wave should remain valid without manufactured consequence.
- [ ] Mathilde may name pleasure and limit without reaching R3.
- [ ] Sandra may name emotional repetition without reaching R2.
- [ ] Pauline and Bastien should receive a legitimate social cycle only.
- [ ] Nico should receive the next full new-character foreground.
- [ ] Nico should name attraction but not request an image or alibi.
- [ ] Raphaëlle should remain deferred.
- [ ] No new image asset is required.
- [ ] Thursday should close without unlocking Friday.
- [ ] A new ledger should own the wave without resetting first repetition.
- [ ] The proposed runtime sequence is sufficiently small.

---

## 18. Final decision line

```text
The first repetition wave is history.

V0.93 does not search for another accidental temptation.
It makes Player, Marie, Mathilde or Sandra, and Nico speak more clearly about what the existing attention now means.

The next escalation must come from a named choice after this boundary,
not from pretending the boundary never existed.
```
