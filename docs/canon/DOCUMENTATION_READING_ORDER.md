# Documentation Reading Order — Canon Current

> Canon entry point after the V0.81 Tuesday-to-Wednesday runtime slice.  
> Read this file before older character, route, proof, day-plan, or runtime documentation.  
> Current playable runtime is canonical only through Wednesday; Thursday and Friday remain documented but unimplemented.

## 1. Core rules

```text
Write people from full character canon.
Write story movement from V0.78.
Write opening content from V0.79.
Write time and delivery from the temporal canon and map.
Read V0.80 for the technical audit and phased plan.
Treat V0.81 as the current runtime implementation boundary.
Use three choices by default.
Existing legacy runtime is not automatic narrative canon.
```

## 2. Official reading order

1. `docs/canon/NARRATIVE_CANON_STATUS.md`
2. `docs/canon/CHOICE_DESIGN_CANON.md`
3. `docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md`
4. `docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md`
5. `docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md`
6. first post-J1 narrative content:
   - `docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md`
   - `docs/canon/ACT_I_OPENING_SCENE_CARDS.md`
   - `docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md`
7. runtime audit, plan, and current implementation report:
   - `docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md`
   - `docs/V0_80_First_Modular_Runtime_Integration_Plan.md`
   - `docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md`
   - `docs/V0_81_Tuesday_Handoff_And_Wednesday_Runtime_Report.md`
8. `docs/canon/characters/CHARACTER_CANON_INDEX.md`
9. relevant principal full-canon file
10. `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` when adult tension, images, voyeurism, cheating, sharing, roleplay, NTR/cuckold, group content, or dark consequences are involved
11. relevant character deprecation map
12. `docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md` when a supporting character appears or is affected
13. current J1 exact sources:
    - `docs/canon/J1_CANON_SOURCE_PACK.md`
    - `docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md`
14. voice/intensity bibles as support only
15. older fixed-day plans, summaries, route matrices, proof maps, and inactive runtime only after explicit cross-checking

`docs/canon/CHARACTERS_CANON_CURRENT.md` remains a doorway only.

## 3. Current source hierarchy

```text
full character canon
+ choice canon
+ V0.78 modular architecture
+ V0.79 opening source pack / cards / temporal map
= narrative truth

V0.80 audit and implementation plan
= technical design truth

V0.81 active indexes, conversations, visual metadata, adapters, and tests
= current playable runtime truth through Wednesday

legacy Chapter 2–9 files
= inactive technical/history material
```

## 4. V0.81 current runtime scope

The active loader exposes only:

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
```

Current playable chronology:

```text
Mardi soir
= J1 Marie + Sandra

Mercredi midi
= Marie / faire de la place

Mercredi fin de journée
= Marie / trace d'arrivée de Mathilde

Mercredi soir
= Mathilde / arrivée puis installation hors ligne
```

V0.81 implements:

- a filtered J1 handoff where Mathilde is indirect rather than already installed;
- data-driven Tuesday/Wednesday labels;
- narrative status-bar time;
- currently available episode metadata only;
- persistent Marie and Mathilde threads;
- sequential Wednesday unlocks;
- M0 and MT0 with exactly three choices;
- observable action flags only;
- `time_separator` and `offline_beat` semantic presentations;
- one authorized ordinary visual: `mathilde_arrival_room_01`;
- inactive legacy days retained on disk but hidden from current navigation.

## 5. J1 handoff rule

The active Tuesday index filters out:

```text
msg_marie_291
msg_marie_292
j1_mathilde_bag_domestic_trace
```

Therefore Tuesday no longer shows Mathilde's bags, shoes, sport bag, or racket as if she were already living at the apartment.

The original files remain available as legacy data, but the active modular index controls playable continuity.

Mathilde has no active Tuesday thread.

## 6. Wednesday choice and state ceiling

Implemented choice nodes:

```text
M0  — proactive / playful-present / passive assent
MT0 — practical / teasing-helpful / distant welcome
```

Runtime writes only:

```text
opening_make_room_proactive
opening_make_room_playful
opening_make_room_passive
mathilde_arrival_practical
mathilde_arrival_playful
mathilde_arrival_distant
mathilde_stay_active
opening_wednesday_complete
```

No new affection, desire, jealousy, route, secret, or couple-mode score is written.

Current ceiling:

```text
Mathilde = R1 Ordinary Access
adult frames = none
hard secrets = none
```

## 7. Time and communication rule in runtime

The phone now uses data-driven narrative time rather than the hardcoded current-scene value.

Wednesday advances through:

```text
12:10
18:18
18:22
18:46 / 18:50 / 19:15 according to MT0
```

A previous authored separator cannot move the clock backward after a later episode unlocks.

When Player returns home:

```text
Messenger stops
-> installation continues as an authored offline beat
```

The offline beat:

- has no sender;
- shows no typing indicator;
- is centered;
- remains in conversation history;
- updates narrative time;
- does not duplicate when the thread is reopened.

## 8. Persistent-thread rule

Marie has two Wednesday episodes inside:

```text
thread_marie_private
```

Mathilde opens:

```text
thread_mathilde_private
```

The contact list remains one visible card per character. Locked future episodes do not leak their time into current contact metadata.

## 9. Legacy-runtime policy

Legacy indexes and conversation files remain in the repository for:

- rollback;
- history;
- technical comparison;
- isolated future recovery.

They are not loaded by the current canonical phone navigation.

Do not delete or rewrite Chapter 3+ during V0.81 review.

## 10. Current exclusions

V0.81 does not implement:

- Thursday Raphaëlle/Sandra content;
- Marie's topology invitation;
- O5A/O5B/O5C;
- mandatory Thursday return to Marie;
- Pauline or Nico opening access;
- branch-conditioned unlocks;
- route R2+;
- adult images or adult content;
- hard secrets;
- a universal scheduler;
- a new couple-state engine.

## 11. Next runtime step

After V0.81 validation and merge:

```text
V0.82 — Thursday topology and mandatory Marie return
```

V0.82 may add only the condition-aware unlock/content foundation required by O3–O6. It must not become a universal scheduling refactor.

## 12. Maintenance rule

When runtime constraints affect story meaning:

- stop implementation expansion;
- update the source pack/card/map first;
- update the relevant runtime plan/report;
- obtain Product Owner validation;
- then resume code work.

## 13. Final rule

```text
V0.81 proves that Tuesday can become Wednesday coherently.
The engine does not learn Thursday branching until this small slice is validated.
```
