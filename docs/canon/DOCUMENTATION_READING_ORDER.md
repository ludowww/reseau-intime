# Documentation Reading Order — Canon Current

> Canon entry point after the V0.84 day-and-moment runtime foundation.  
> Runtime is playable through Thursday with chronological day/phase gating.  
> J1 dialogue remains temporary legacy content until V0.85; Friday remains postponed.

## 1. Core rules

```text
Write people from full character canon.
Write story movement from V0.78.
Write opening content from V0.79.
Write communication realism from the diegetic-time canon.
Write chronological access from the temporal-flow canon.
Treat V0.84 as the current runtime access model.
Use the V0.85 source pack before replacing active J1.
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
7. planned J1 replacement:
   - `docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md`
   - `docs/canon/J1_RUNTIME_RECONCILIATION_SCENE_CARDS.md`
8. runtime audit, plans, and current reports:
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

## 3. Current source hierarchy

```text
full character canon
+ choice canon
+ V0.78 modular architecture
+ V0.79 opening source pack / cards / temporal map
= narrative truth

V0.83 temporal-flow canon
= chronological-access truth

V0.84 runtime state, phase metadata, transition overlay, and archive adapters
= current playable access implementation

V0.83 J1 reconciliation source pack / cards
+ V0.85 plan
= next Tuesday-content replacement

legacy Chapter 1–9 files
= inactive technical/history material unless a current index explicitly references them
```

## 4. Current playable runtime

The active loader contains:

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
```

But visibility is chronological:

```text
launch: Tuesday only
Tuesday complete -> Wednesday unlock/select
Wednesday complete -> Thursday unlock/select
Thursday complete -> no Friday yet
```

The old free day menu is no longer the intended V0.84 behavior.

## 5. Timeline state

Current day lifecycle:

```text
LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
```

Current phase lifecycle:

```text
LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

Implementation sources:

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/TimelineTransitionView.gd
game/scripts/ui/ConversationViewV084.gd
```

Core rule:

```text
Time labels describe chronology.
Timeline state controls access.
```

## 6. Day and moment transitions

Day completion shows a blocking, readable interstitial before the next day unlocks.

Example:

```text
MARDI — FIN DE JOURNÉE

MERCREDI — MIDI
Faire de la place · 12:10
```

Large intra-day jumps show shorter cards:

```text
JEUDI — DÉBUT D'APRÈS-MIDI
13:50
```

The overlay may be skipped only after a short minimum display time and leaves a neutral landing view for the new moment.

## 7. Thursday order

Current chronological Thursday:

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> explicit advance
-> Sandra completed or expired
-> 16:05 Marie required
-> exactly one O5 branch
-> 22:10 Marie return required
-> Thursday complete
```

If Player advances without opening Sandra:

```text
chapter_03_sandra_continuity = expired
thursday_sandra_echo_missed = true
```

Sandra cannot be answered after the story reaches 16:05.

## 8. Read-only archives

Completed days remain selectable as history.

Archive access:

- shows no pending badge or notification;
- permits no new choice or effect;
- does not move narrative time;
- does not reactivate expired scenes;
- filters persistent-thread history by source episode/day so Tuesday does not reveal later Marie/Sandra content.

## 9. Temporary J1 status

V0.84 deliberately preserves the filtered legacy Tuesday content.

This is temporary technical continuity only.

V0.85 will replace active J1 with:

```text
18:12 Marie remote opening + M1
19:15 dinner/walk offline beat
22:57 Sandra soft trace + S1
23:25 final Marie/shared-life offline beat
Tuesday complete -> Wednesday
```

No Friday work starts before V0.85 is validated.

## 10. Current route/intensity ceiling

```text
Mathilde = R1 Ordinary Access
Raphaëlle = R1 Ordinary Work Access
Sandra = soft continuity or expired Thursday echo
Marie/Player = HABITUAL_WARMTH
hard secrets = none
adult frames = none
Friday = not implemented
```

V0.84 adds no story state beyond temporal/expiry flags.

## 11. Implementation sequence

```text
V0.84 — Day & Moment Flow Runtime Foundation
V0.85 — J1 Canon Runtime Reconciliation
V0.86 — Friday Public Traces & Opening Completion
```

## 12. Maintenance rule

If a runtime constraint changes story meaning:

1. stop implementation expansion;
2. update canon/source pack first;
3. update the relevant plan/report;
4. obtain Product Owner validation;
5. resume implementation.

Do not bypass phase order merely because a legacy unlock rule is already true.

## 13. Final rule

```text
V0.84 controls when the existing story may happen.
V0.85 will correct what Tuesday actually says.
Friday waits until both are trustworthy.
```
