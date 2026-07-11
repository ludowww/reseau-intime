# Documentation Reading Order — Canon Current

> Canon entry point after V0.83 temporal-flow and J1 reconciliation planning.  
> V0.82 remains the current playable baseline. Friday implementation is suspended until V0.84 and V0.85 are validated.

## 1. Core rules

```text
Write people from full character canon.
Write story movement from V0.78.
Write opening content from V0.79.
Write communication realism from the diegetic-time canon.
Write chronological access from the V0.83 temporal-flow canon.
Write active Tuesday from the V0.83 J1 source pack and scene cards.
Use V0.84 and V0.85 plans before changing runtime.
Use three choices by default.
Legacy runtime is not automatic narrative canon.
```

## 2. Official reading order

1. `docs/canon/NARRATIVE_CANON_STATUS.md`
2. `docs/canon/CHOICE_DESIGN_CANON.md`
3. `docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md`
4. `docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md`
5. temporal and communication rules:
   - `docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md`
   - `docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md`
6. opening narrative content:
   - `docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md`
   - `docs/canon/ACT_I_OPENING_SCENE_CARDS.md`
   - `docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md`
7. current Tuesday correction:
   - `docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md`
   - `docs/canon/J1_RUNTIME_RECONCILIATION_SCENE_CARDS.md`
8. runtime audit, plans, and reports:
   - `docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md`
   - `docs/V0_80_First_Modular_Runtime_Integration_Plan.md`
   - `docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md`
   - `docs/V0_81_Tuesday_Handoff_And_Wednesday_Runtime_Report.md`
   - `docs/runtime/V0_82_THURSDAY_TOPOLOGY_IMPLEMENTATION_PLAN.md`
   - `docs/V0_82_Thursday_Topology_And_Marie_Return_Runtime_Report.md`
   - `docs/V0_83_Temporal_Flow_And_J1_Reconciliation_Report.md`
   - `docs/runtime/V0_84_DAY_AND_MOMENT_FLOW_IMPLEMENTATION_PLAN.md`
   - `docs/runtime/V0_85_J1_CANON_RUNTIME_RECONCILIATION_PLAN.md`
9. `docs/canon/characters/CHARACTER_CANON_INDEX.md`
10. relevant principal full-canon file
11. `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` when adult tension, images, voyeurism, cheating, sharing, roleplay, NTR/cuckold, group content, or dark consequences are involved
12. relevant character deprecation map
13. `docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md` when a supporting character appears or is affected
14. historical J1 sources when auditing line origin:
    - `docs/canon/J1_CANON_SOURCE_PACK.md`
    - `docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md`
15. voice/intensity bibles as support only
16. older fixed-day plans, summaries, route matrices, proof maps, and inactive runtime only after explicit cross-checking

`docs/canon/CHARACTERS_CANON_CURRENT.md` remains a doorway only.

---

## 3. Current source hierarchy

```text
full character canon
+ choice canon
+ V0.78 modular architecture
+ V0.79 opening source pack / cards / temporal map
= broad narrative truth

V0.83 temporal-flow canon
+ V0.83 J1 reconciliation source pack / scene cards
= corrected chronology and Tuesday truth

V0.80–V0.82 reports
= current implemented technical history

V0.84 / V0.85 plans
= next approved implementation sequence after Product Owner validation

legacy Chapter 1–9 files
= inactive technical/history material unless explicitly retained by current indexes
```

---

## 4. Current playable baseline

V0.82 remains playable through Thursday night:

```text
Mardi
Mercredi
Jeudi
```

Current active indexes:

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
```

However, V0.83 identifies two current limitations:

1. all active days are immediately selectable instead of unlocking chronologically;
2. active J1 still derives from large legacy files with confirmed temporal and narrative contradictions.

These limitations are documented debt, not current canon to preserve.

---

## 5. Temporal-flow correction

`TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md` now controls:

- day lifecycle: `LOCKED / AVAILABLE / ACTIVE / COMPLETE / ARCHIVED`;
- phase lifecycle: `LOCKED / CURRENT / COMPLETE / SKIPPED / EXPIRED`;
- future-day locking;
- automatic next-day selection;
- day-end/day-start interstitials;
- shorter intra-day transition cards;
- required vs optional phases;
- explicit skip/expiry behavior;
- read-only archived days;
- chronological notification gating;
- non-decreasing source timestamps.

Core rule:

```text
Time labels describe chronology.
Timeline state controls access.
```

---

## 6. Thursday correction

The current V0.82 runtime unlocks Sandra 13:50 and Marie 16:05 together after Raphaëlle.

That behavior is not the target after V0.83.

Correct future flow:

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> explicit advance
-> Sandra seen or expired
-> 16:05 Marie required
-> one O5 branch
-> 22:10 Marie return required
-> Thursday complete
```

The player cannot answer Sandra after advancing to 16:05.

---

## 7. J1 correction

The active Tuesday runtime must be replaced rather than further filtered.

Future active structure:

```text
18:12 Marie remote opening
-> M1 three choices
-> La Verrière / indirect Mathilde seed

19:15 dinner and walk offline beat

22:57 Sandra old lunch trace
-> S1 three choices
-> soft boundary

23:25 final Marie/shared-life offline beat

Tuesday complete
-> transition
-> Wednesday unlock
```

J1 uses flags only and ends on Marie/shared life.

The current legacy files remain inactive for history/rollback.

---

## 8. Current route and intensity ceiling

V0.83 changes no playable route state.

Current runtime remains:

```text
Mathilde = R1 Ordinary Access
Raphaëlle = R1 Ordinary Work Access
Sandra = soft continuity
Marie/Player = HABITUAL_WARMTH
hard secrets = none
adult frames = none
Friday = not implemented
```

---

## 9. Approved implementation sequence

```text
V0.83 — temporal-flow and J1 documentation correction
V0.84 — day and moment flow runtime foundation
V0.85 — J1 canon runtime reconciliation
V0.86 — Friday public traces and opening completion
```

Do not implement Friday before V0.84 and V0.85 are validated.

---

## 10. V0.84 boundary

V0.84 may add:

- day/phase state;
- transition overlay;
- future-day locking;
- archive-safe navigation;
- explicit phase advance;
- optional-scene expiry;
- sequential Sandra -> Marie Thursday flow.

It must not rewrite J1 dialogue or add Friday.

---

## 11. V0.85 boundary

V0.85 may add:

- new concise active J1 files;
- Tuesday timeline phases and offline beats;
- replacement of filter-based active J1;
- flag-only M1/S1 state;
- final Marie/shared-life completion.

It must not change Wednesday/Thursday meaning or add Friday.

---

## 12. Maintenance rule

If runtime constraints alter story meaning:

1. stop expansion;
2. update canon/source pack first;
3. update the relevant implementation plan/report;
4. obtain Product Owner validation;
5. resume implementation.

Do not keep a contradictory runtime behavior merely because tests currently encode it.

---

## 13. Final rule

```text
The current runtime proves the branches.
V0.83 corrects when those branches may be entered and what the first day actually says.
Friday waits until time and J1 are trustworthy.
```
