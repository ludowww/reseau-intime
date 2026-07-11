# Documentation Reading Order — Canon Current

> Canon entry point after the V0.85 J1 runtime reconciliation.  
> Runtime is playable through Thursday with authoritative day/phase order.  
> Tuesday now uses current canon rather than filtered legacy dialogue; Friday remains postponed.

## 1. Core rules

```text
Write people from full character canon.
Write story movement from V0.78.
Write opening content from V0.79.
Write communication realism from the diegetic-time canon.
Write chronological access from the temporal-flow canon.
Treat V0.84 as the current day/phase access model.
Treat V0.85 as the current active J1 content.
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
7. current J1 replacement sources:
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
   - `docs/V0_85_J1_Canon_Runtime_Reconciliation_Report.md`
9. `docs/canon/characters/CHARACTER_CANON_INDEX.md`
10. relevant principal full-canon file
11. `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` when adult tension, images, voyeurism, cheating, sharing, roleplay, NTR/cuckold, group content, or dark consequences are involved
12. relevant character deprecation map
13. `docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md` when a supporting character appears or is affected
14. historical J1 sources only when auditing line origin:
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
+ V0.84 timeline state, interstitials, phase gates, and archives
= chronological-access truth and implementation

V0.83 J1 reconciliation source pack / cards
+ V0.85 active Tuesday files and authored offline phases
= current J1 truth and implementation

legacy Chapter 1–9 files
= inactive technical/history material unless a current index explicitly references them
```

## 4. Current playable runtime

Active indexes:

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
```

Chronological visibility:

```text
launch: Tuesday only
Tuesday complete -> Wednesday unlock/select
Wednesday complete -> Thursday unlock/select
Thursday complete -> no Friday yet
```

## 5. Active Tuesday — reconciled J1

```text
18:12 Marie remote opening
-> M1: present / playful-present / delayed-flat

19:15 or 19:35
-> dinner and walk offline

22:57 Sandra soft trace
-> S1: safe warmth / precise observation / cautious

23:25 or 23:28
-> final Marie/shared-life offline return

Tuesday complete
-> Wednesday transition
```

Active files:

```text
game/data/conversations/chapter_01_marie_opening.json
game/data/conversations/chapter_01_sandra_trace.json
```

The active Tuesday index no longer references or filters the large legacy Marie/Sandra files.

J1 guarantees:

- bread is requested before it is obtained;
- all bubble timestamps remain Tuesday and monotonic;
- Mathilde is indirect only;
- Sandra shares one imperfect image and closes the exchange herself;
- no numeric route effects;
- the day ends on Marie/shared life, not Sandra.

## 6. Timeline and offline phases

Day lifecycle:

```text
LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
```

Phase lifecycle:

```text
LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

Current runtime sources:

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/PhonePrototypeV085.gd
game/scripts/ui/TimelineTransitionView.gd
game/scripts/ui/ConversationViewV084.gd
```

V0.85 adds authored, conversation-free phases for:

- the dinner/walk;
- the final Marie return.

These phases are selected by flags, displayed as temporal cards, recorded once in the completed-day log, and remain read-only in archives.

## 7. Wednesday and Thursday status

Wednesday remains:

```text
12:10 Marie / make room
-> 18:18 arrival trace
-> 18:22 Mathilde arrival + offline settling
-> Wednesday complete
```

Thursday remains:

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> complete or expire Sandra
-> 16:05 Marie required
-> exactly one O5 branch
-> 22:10 Marie return required
-> Thursday complete
```

V0.85 does not change their dialogue or route meaning.

## 8. Archive behavior

Completed days remain selectable as read-only history.

Archive access:

- shows no pending badge or notification;
- permits no new choice or effect;
- does not move narrative time;
- does not reactivate expired content;
- filters persistent-thread history by source episode/day;
- now also lists completed authored offline moments once under `Moments hors ligne`.

## 9. Current route and intensity ceiling

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra J1 = soft trace seed only
Mathilde = R1 Ordinary Access after Wednesday
Raphaëlle = R1 Ordinary Work Access after Thursday
Pauline = inactive
Nico = inactive
hard secrets = none
adult frames = none
Friday = not implemented
```

## 10. Historical J1 status

The following remain on disk but are inactive:

```text
game/data/conversations/chapter_01_marie.json
game/data/conversations/chapter_01_sandra.json
```

Their former issues—weekday contradiction, 24:xx timestamps, deep Sandra escalation, old scores, excessive guided clicking, and ending on Sandra—are not current behavior.

Do not restore them through filters.

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

## 13. Final rule

```text
V0.84 controls when the story may happen.
V0.85 makes Tuesday truthful.
Friday waits until this reconciled opening is validated in runtime.
```
