# Documentation Reading Order — Canon Current

> Canon entry point after the V0.86 Friday public-trace and opening-completion runtime pass.  
> Runtime is playable from Tuesday through Friday with authoritative day/phase order.  
> The concrete V0.79 opening band is now implemented through `opening_band_complete`.

## 1. Core rules

```text
Write people from full character canon.
Write story movement from V0.78.
Write the opening from V0.79 and its later reconciliation sources.
Write communication realism from the diegetic-time canon.
Write chronological access from the temporal-flow canon.
Treat V0.84–V0.85 as the current time/offline foundation.
Treat V0.86 as the current end of the implemented opening.
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
6. concrete opening narrative:
   - `docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md`
   - `docs/canon/ACT_I_OPENING_SCENE_CARDS.md`
   - `docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md`
7. reconciled Tuesday sources:
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
   - `docs/runtime/V0_86_FRIDAY_PUBLIC_TRACES_IMPLEMENTATION_PLAN.md`
   - `docs/V0_86_Friday_Public_Traces_And_Opening_Completion_Report.md`
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

---

## 3. Current source hierarchy

```text
full character canon
+ choice canon
+ V0.78 modular architecture
+ V0.79 opening source pack / cards / temporal map
= narrative truth for the opening

V0.83 temporal-flow canon
+ V0.84 timeline state, interstitials, phase gates, and archives
= chronological-access truth and implementation

V0.83 J1 reconciliation source pack / cards
+ V0.85 active Tuesday files and authored offline phases
= current J1 truth and implementation

V0.86 Friday index, conversations, visual trace, and final household beat
= current implemented opening completion

legacy Chapter 1–9 files
= inactive technical/history material unless a current index explicitly references them
```

---

## 4. Current playable runtime

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

A day is never available merely because its JSON is loaded.

---

## 5. Tuesday — reconciled J1

```text
18:12 Marie remote opening
-> M1: present / playful-present / delayed-flat

19:15 or 19:35
-> dinner and walk offline

22:57 Sandra soft trace
-> S1: safe warmth / precise observation / cautious

23:25 or 23:28
-> final Marie/shared-life offline return

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

## 6. Wednesday and Thursday

Wednesday:

```text
12:10 Marie / make room
-> 18:18 arrival trace
-> 18:22 Mathilde arrival + offline settling
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

The topology remains:

```text
join Marie early
OR stay at the shared home
OR finish real work and promise to join
```

Every branch returns to Marie before Friday.

---

## 7. Friday — public traces and residue

```text
08:35 Pauline / authorized group-photo relay
-> P0: practical / dry joke / defer to Marie

14:05 Nico / saved-seat follow-up
-> N0: honest / playful / ask about Marie

18:05 Marie + Mathilde household echoes
-> both required, separate private threads

18:25 household close offline
-> household_rhythm_confirmed
-> opening_band_complete
```

Active Friday files:

```text
game/data/conversations/chapter_04_pauline_public_photo_relay.json
game/data/conversations/chapter_04_nico_saved_seat_followup.json
game/data/conversations/chapter_04_marie_household_report.json
game/data/conversations/chapter_04_mathilde_bathroom_correction.json
game/data/visual_content/chapter_04_opening_proofs.json
```

Friday guarantees:

- Pauline reaches R1 through legitimate public-image competence;
- Bastien remains visible in her social world;
- the group-photo origin and audience are explicit;
- no private crop or secret audience exists;
- Nico reaches R1 as a genuine friend and social mirror;
- Nico may know Mathilde is staying without sexualizing it;
- no image request, cover arrangement, rivalry, or adult frame opens;
- the opening closes on the enlarged household.

---

## 8. Timeline and offline phases

Day lifecycle:

```text
LOCKED -> AVAILABLE -> ACTIVE -> COMPLETE -> ARCHIVED
```

Phase lifecycle:

```text
LOCKED -> CURRENT -> COMPLETE / SKIPPED / EXPIRED
```

Runtime sources:

```text
game/scripts/core/TimelineState.gd
game/scripts/ui/PhonePrototypeV084.gd
game/scripts/ui/PhonePrototypeV085.gd
game/scripts/ui/TimelineTransitionView.gd
game/scripts/ui/ConversationViewV084.gd
```

Authored conversation-free phases currently cover:

- Tuesday dinner/walk;
- Tuesday final Marie return;
- Friday final household close.

They are selected by state, displayed once, recorded once in the day log, and restored read-only in archives.

---

## 9. Image and trace status

Current opening traces include:

```text
j1_sandra_lunch_memory_soft
mathilde_arrival_room_01
marie_laverriere_setup_01
laverriere_public_group_photo_set_01
```

The Friday group-photo set is:

- created with Pauline's remote shutter;
- authorized for the photographed group and La Verrière archive/public post;
- ordinary and risk 0;
- visibly connected to Marie, Pauline, Bastien, and Élodie;
- possibly inclusive of Nico and contextually Player;
- explicitly without Mathilde;
- not permission for a private recrop or private redistribution.

---

## 10. Current route and intensity ceiling

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra = soft trace / cooled ordinary continuity
Mathilde = R1 Ordinary Access
Raphaëlle = R1 Ordinary Work Access
Pauline = R1 Legitimate Social Access
Nico = R1 Ordinary Friendship / Social Access
hard secrets = none
adult frames = none
routes R2+ = none
opening_band_complete = true
```

V0.86 completes ordinary access. It does not begin the dangerous route phases.

---

## 11. Legacy policy

Legacy files remain on disk for rollback, history, and technical comparison.

Important inactive examples:

```text
game/data/conversations/chapter_01_marie.json
game/data/conversations/chapter_01_sandra.json
game/data/conversations/chapter_04_index.json
game/data/visual_content/chapter_04_proofs.json
```

Do not restore them merely because they share a chapter number with current modular content.

---

## 12. Next documentation step

The concrete V0.79 opening is now implemented.

Before another runtime expansion, write:

```text
V0.87 — Next Act I Windows Source Pack
```

That pack should define the first repeated/private-attention windows after ordinary access, with explicit conditions, cooldowns, missed opportunities, and couple consequences.

No R2 scene should enter runtime before that documentation is validated.

---

## 13. Maintenance rule

If a runtime constraint changes story meaning:

1. stop implementation expansion;
2. update canon/source pack first;
3. update the relevant plan/report;
4. obtain Product Owner validation;
5. resume implementation.

---

## 14. Final rule

```text
V0.84 controls when the story happens.
V0.85 makes Tuesday truthful.
V0.86 completes the opening through public traces, friendship, and household residue.

The next danger must grow from these people,
not replace their ordinary lives.
```
