# Documentation Reading Order — Canon Current

> Canon entry point after the V0.87 first-repetition source-pack and voice-distinction pass.  
> Runtime remains implemented from Tuesday through Friday at V0.86.  
> V0.87 defines, but does not yet implement, the first post-opening repetition wave.

## 1. Core rules

```text
Write people from full character canon.
Preserve cross-character voice distinction.
Write story movement from V0.78.
Write the opening from V0.79 and its reconciliation sources.
Write the first post-opening repetition wave from V0.87.
Write communication realism from the diegetic-time canon.
Write chronological access from the temporal-flow canon.
Treat V0.84–V0.86a as the current runtime foundation.
Use three choices by default.
Legacy runtime is not automatic narrative canon.
Documented is not the same as implemented.
```

---

## 2. Official reading order

1. `docs/canon/NARRATIVE_CANON_STATUS.md`
2. `docs/canon/CHOICE_DESIGN_CANON.md`
3. `docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md`
4. `docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md`
5. temporal and communication rules:
   - `docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md`
   - `docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md`
6. concrete opening narrative:
   - `docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md`
   - `docs/canon/ACT_I_OPENING_SCENE_CARDS.md`
   - `docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md`
7. reconciled Tuesday sources:
   - `docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md`
   - `docs/canon/J1_RUNTIME_RECONCILIATION_SCENE_CARDS.md`
8. first post-opening repetition wave:
   - `docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md`
   - `docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md`
   - `docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md`
9. runtime audit, plans, and current reports:
   - `docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md`
   - `docs/V0_80_First_Modular_Runtime_Integration_Plan.md`
   - `docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md`
   - `docs/V0_81_Tuesday_Handoff_And_Wednesday_Runtime_Report.md`
   - `docs/runtime/V0_82_THURSDAY_TOPOLOGY_IMPLEMENTATION_PLAN.md`
   - `docs/V0_82_Thursday_Topology_And_Marie_Return_Runtime_Report.md`
   - `docs/V0_83_Temporal_Flow_And_J1_Reconciliation_Report.md`
   - `docs/runtime/V0_84_DAY_AND_MOMENT_FLOW_IMPLEMENTATION_PLAN.md`
   - `docs/V0_84_Day_And_Moment_Flow_Runtime_Report.md`
   - `docs/runtime/V0_85_J1_CANON_RUNTIME_RECONCILIATION_PLAN.md`
   - `docs/V0_85_J1_Canon_Runtime_Reconciliation_Report.md`
   - `docs/runtime/V0_86_FRIDAY_PUBLIC_TRACES_IMPLEMENTATION_PLAN.md`
   - `docs/V0_86_Friday_Public_Traces_And_Opening_Completion_Report.md`
   - `docs/runtime/V0_86A_TEMPORAL_UX_NOTIFICATION_POLISH_PLAN.md`
   - `docs/V0_86A_Temporal_UX_Notification_Polish_Report.md`
   - `docs/V0_87_Next_Act_I_Windows_Source_Pack_Report.md`
   - `docs/runtime/V0_88_FIRST_REPETITION_RUNTIME_PREPARATION_NOTE.md`
10. `docs/canon/characters/CHARACTER_CANON_INDEX.md`
11. relevant principal full-canon file
12. `docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md`
13. `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` when adult tension, images, voyeurism, cheating, sharing, roleplay, NTR/cuckold, group content, or dark consequences are involved
14. relevant character deprecation map
15. `docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md` when a supporting character appears or is affected
16. historical J1 sources only when auditing line origin:
    - `docs/canon/J1_CANON_SOURCE_PACK.md`
    - `docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md`
17. voice/intensity bibles as support only
18. older fixed-day plans, summaries, route matrices, proof maps, and inactive runtime only after explicit cross-checking

`docs/canon/CHARACTERS_CANON_CURRENT.md` remains a doorway only.

---

## 3. Voice authority

The full character canon defines the person. The voice-distinction canon prevents strong markers from leaking across the cast.

```text
Mathilde's legal seasoning is not shared cast vocabulary.
Marie moves shared life.
Sandra protects a trace.
Pauline controls timing and audience.
Nico makes food, rooms, friendship, and desire concrete.
Raphaëlle selects detail and asks one clear question.
Player remains short, dry, observant, and imperfect.
```

Literal professional vocabulary remains possible where context requires it. Recurring legal punchlines outside Mathilde are rejected unless the borrowing itself is deliberately meaningful.

---

## 4. Current source hierarchy

```text
full character canon
+ character voice distinction canon
+ choice canon
+ V0.78 modular architecture
= identity, voice, and movement truth

V0.79 opening source pack / cards / temporal map
+ V0.83 J1 reconciliation sources
= opening narrative truth

V0.83 temporal-flow canon
+ V0.84 timeline state / phase gates / archives
+ V0.85 active Tuesday
+ V0.86 Friday opening completion
+ V0.86a phone-time and notification UX
= current implemented runtime truth

V0.87 first-repetition source pack / cards / temporal map
= current authorized post-opening narrative truth
= not yet implemented

legacy Chapter 1–9 files
= inactive technical/history material unless a current index explicitly references them
```

Important distinction:

```text
A scene can be canonically authored
without being available in the current build.
```

---

## 5. Current playable runtime

Active indexes:

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
chapter_04_modular_index.json
```

Chronological visibility:

```text
launch: Tuesday only
Tuesday complete -> Wednesday unlock/select
Wednesday complete -> Thursday unlock/select
Thursday complete -> Friday unlock/select
Friday complete -> no later day yet
```

The current build ends Friday evening at:

```text
opening_band_complete = true
```

V0.87 Saturday/Monday windows are not yet playable.

---

## 6. Tuesday — reconciled J1

```text
18:12 Marie remote opening
-> M1: present / playful-present / delayed-flat

19:15 or 19:35
-> dinner and walk off phone

22:57 Sandra soft trace
-> S1: safe warmth / precise observation / cautious

23:25 or 23:28
-> final Marie/shared-life return

Tuesday complete -> Wednesday
```

Active files:

```text
game/data/conversations/chapter_01_marie_opening.json
game/data/conversations/chapter_01_sandra_trace.json
```

Guarantees:

- bread is requested before it is obtained;
- timestamps remain monotonic and before midnight;
- Mathilde is indirect only;
- Sandra shares one soft image trace;
- no numeric route effect;
- the day ends on Marie/shared life.

---

## 7. Wednesday and Thursday

Wednesday:

```text
12:10 Marie / make room
-> 18:18 arrival trace
-> 18:22 Mathilde arrival
-> household settling
-> Wednesday complete
```

Thursday:

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> complete or expire Sandra
-> 16:05 Marie required
-> exactly one O5 branch
-> 22:10 Marie return required
-> Thursday complete
```

Topology:

```text
join Marie early
OR stay at the shared home
OR finish real work and promise to join
```

Every branch returns to Marie before Friday.

---

## 8. Friday — public traces and opening close

```text
08:35 Pauline / authorized group-photo relay
-> P0: practical / dry joke / defer to Marie

14:05 Nico / saved-seat follow-up
-> N0: honest / playful / ask about Marie

18:05 Marie + Mathilde household echoes
-> both required, separate private threads

18:25 household close
-> household_rhythm_confirmed
-> opening_band_complete
```

Friday guarantees:

- Pauline reaches R1 through legitimate public-image competence;
- Bastien remains visible in her social world;
- no private crop or secret audience exists;
- Nico reaches R1 as a genuine friend and social mirror;
- no image request, cover arrangement, rivalry, or adult frame opens;
- the opening closes on the enlarged household.

---

## 9. Current phone-time presentation

The active V0.86a path uses:

```text
last visible message
-> contact offline
-> two-second pause
-> four-second accelerated clock at Speed x1
-> cross-thread compact notification
```

When the next episode belongs to the already open contact:

```text
clock advances
-> no same-contact notification
-> conversation resumes directly
```

Current UI rules:

- time, Wi-Fi, and battery stay in the fixed conversation header;
- notifications show a compact preview and keep the transcript at the bottom;
- no blank moment-of-day page;
- no `Le temps passe` prompt;
- no visible `Moments hors ligne` section;
- co-present action is inferred or handled outside chat rather than explained in prose.

---

## 10. V0.87 — first repetition wave

```text
W9  Marie claims one shared hour
W10 weekend repetition opportunity
W11 mandatory Marie return
W12 first-workday repetition opportunity
W13 wave close / couple balance
```

Wave budget:

```text
fixed Marie foreground
+ maximum two external foreground tickets
+ maximum one charged-access owner
+ mandatory couple returns
```

Candidate external scenes:

```text
Mathilde — morning gaze acknowledged
Sandra — work-afterglow confidence
Raphaëlle — outside-work person
Pauline — legitimate social repetition with Bastien visible
Nico — quiet friendship repetition
```

Route ceilings:

```text
Mathilde / Sandra / Raphaëlle = R1 or one of them R2 at most
Pauline = R1
Nico = R1
Marie / Player = HABITUAL_WARMTH + evidence only
hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
```

V0.87 creates no required image asset and no fixed character order.

---

## 11. First repetition selection rule

```text
safety / aftermath
-> fixed spine
-> obligation due
-> compatible continuation
-> context fit
-> unseen eligible scene
-> longest deferred
-> least recently foregrounded
-> authored order
```

Global constraints:

- one foreground per window;
- zero to two echoes;
- the same character cannot consume both external tickets;
- a Marie consequence outranks a new external opportunity;
- silence is valid when no scene fits;
- timestamps describe chronology but never grant access alone.

---

## 12. Current traces

```text
j1_sandra_lunch_memory_soft
mathilde_arrival_room_01
marie_laverriere_setup_01
laverriere_public_group_photo_set_01
```

V0.87 leaves all four in their existing frame.

No new crop, audience, sexual function, forwarding permission, or adult collectible is created.

---

## 13. Current route and intensity status

Runtime end state remains:

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra = soft trace / ordinary continuity
Mathilde = R1 Ordinary Access
Raphaëlle = R1 Ordinary Work Access
Pauline = R1 Legitimate Social Access
Nico = R1 Ordinary Friendship / Social Access
hard secrets = none
adult frames = none
opening_band_complete = true
```

Documented future ceiling after a V0.88+ implementation:

```text
one of Mathilde / Sandra / Raphaëlle may reach R2
Pauline and Nico remain R1
```

Do not treat that documented ceiling as current save state.

---

## 14. Legacy policy

Legacy files remain on disk for rollback, history, and technical comparison.

Important inactive examples:

```text
game/data/conversations/chapter_01_marie.json
game/data/conversations/chapter_01_sandra.json
game/data/conversations/chapter_04_index.json
game/data/visual_content/chapter_04_proofs.json
```

Do not restore old fixed day orders, Mathilde canapé foundations, Pauline instant private crops, Nico immediate photo pacts, or Raphaëlle early costume access merely because those ideas exist historically.

---

## 15. Next implementation step

```text
V0.88 — First Repetition Runtime Integration Plan
```

It must map the approved source pack onto current state and choose a small vertical slice.

Recommended first-slice boundary:

```text
W9 Marie shared hour
+ one external candidate
+ mandatory Marie return
```

No V0.87 scene enters runtime before that plan is validated.

---

## 16. Maintenance rule

If scene meaning or voice changes:

1. update the V0.87 source pack;
2. update the matching scene card if engine, posture, or consequence changes;
3. update the voice-distinction canon when a cross-character rule changes;
4. update the temporal map when time, place, or delivery changes;
5. update full character canon only if identity changes;
6. update global NSFW canon only if adult rules change;
7. update status/report/roadmap;
8. validate documentation;
9. only then update the runtime plan.

```text
A correction is incomplete
while source pack, card, temporal map, voice policy, and current status disagree.
```

---

## 17. Final rule

```text
V0.86 proves ordinary access.
V0.87 proves that repetition can change meaning.
V0.88 must integrate only the smallest truthful slice.

Every character must remain recognizable before desire intensifies.
No later adult engine may erase the ordinary person who earned it.
```
