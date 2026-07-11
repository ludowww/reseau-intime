# Documentation Reading Order — Canon Current

> Canon entry point after the V0.82 Thursday topology runtime slice.  
> Current playable runtime is canonical through Thursday night. Friday remains authored in V0.79 but unimplemented.

## 1. Core rules

```text
Write people from full character canon.
Write story movement from V0.78.
Write opening content from V0.79.
Write time and delivery from the temporal canon and map.
Read V0.80 for the phased technical strategy.
Treat V0.81 and V0.82 as the current runtime implementation boundary.
Use three choices by default.
Legacy runtime is not automatic narrative canon.
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
7. runtime audit, plans, and reports:
   - `docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md`
   - `docs/V0_80_First_Modular_Runtime_Integration_Plan.md`
   - `docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md`
   - `docs/V0_81_Tuesday_Handoff_And_Wednesday_Runtime_Report.md`
   - `docs/runtime/V0_82_THURSDAY_TOPOLOGY_IMPLEMENTATION_PLAN.md`
   - `docs/V0_82_Thursday_Topology_And_Marie_Return_Runtime_Report.md`
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

V0.80 phased plan
= technical strategy

V0.81 Tuesday–Wednesday runtime
+ V0.82 Thursday conditional topology runtime
= current playable truth through Thursday night

legacy Chapter 2–9 files
= inactive technical/history material
```

## 4. Current playable chronology

```text
Mardi soir
= J1 Marie + Sandra

Mercredi midi
= Marie / faire de la place

Mercredi fin de journée
= Marie / trace d'arrivée

Mercredi soir
= Mathilde / arrivée + installation hors ligne

Jeudi matin
= Raphaëlle / travail ordinaire

Jeudi début d'après-midi
= écho Sandra optionnel

Jeudi fin d'après-midi
= Marie / choix topologique M1

Jeudi soir
= une seule branche O5A, O5B ou O5C

Jeudi nuit
= retour O6 obligatoire vers Marie
```

Friday remains absent from active navigation.

## 5. Active runtime indexes

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
```

Legacy indexes remain on disk but are not loaded.

## 6. V0.82 topology rule

M1 contains exactly three actions:

```text
1. join Marie early
2. stay at the shared home
3. finish work and promise to join later
```

The selected flag unlocks exactly one:

```text
opening_topology_join_marie
-> O5A Marie / La Verrière

opening_topology_stay_home
-> O5B Mathilde / foyer

opening_topology_work_then_join
-> O5C Raphaëlle / travail
```

Any completed branch unlocks the single O6 Marie consequence.

No branch is a direct character-route menu.

## 7. Conditional runtime foundation

V0.82 adds only:

```text
unlock conditions
+ after_any_conversation_completed
+ conditional messages/choices
+ cross-day cumulative thread merge
```

It does not add a universal scheduler.

The same persistent contact may now append unseen Thursday episodes while preserving Tuesday/Wednesday history.

## 8. Time and communication

Core rule:

```text
If characters are co-present and can talk,
they do not conduct a long Messenger conversation.
```

Thursday modes:

```text
Raphaëlle O3       = WORK_CHAT
Sandra echo        = REMOTE_ASYNC
Marie O4           = REMOTE_ASYNC
Marie O5A          = SAME_VENUE_LOGISTICS
Mathilde O5B       = SEPARATE_ROOMS_PING -> OFFLINE_BEAT for helpful branches
Raphaëlle O5C      = WORK_CHAT
Marie O6           = AFTERGLOW_REMOTE
```

The joined branch keeps emotional evaluation for O6 after separation.

## 9. Current route and state ceiling

After Thursday:

```text
Mathilde = R1 Ordinary Access
Raphaëlle = R1 Ordinary Work Access
Sandra = soft continuity echo
Marie/Player = HABITUAL_WARMTH with remembered reconnection/drift candidates
hard secrets = none
adult frames = none
```

Runtime writes observable flags, not new affection/desire scores or a forced couple-mode transition.

## 10. Current exclusions

Not implemented:

- Friday O7/O8;
- Pauline or Nico threads;
- public group-photo relay;
- route R2+;
- hard secrets;
- adult content;
- open-couple negotiation;
- NTR/cuckold logic;
- universal scheduler;
- save migration;
- legacy-file deletion.

## 11. Next step

After V0.82 validation and merge:

```text
V0.83 — Friday public traces and opening completion
```

## 12. Maintenance rule

If a runtime constraint changes story meaning:

1. stop expansion;
2. update the relevant source pack/card/temporal map;
3. update the runtime plan/report;
4. obtain Product Owner validation;
5. resume implementation.

## 13. Final rule

```text
V0.82 opens one Thursday context and always returns its consequence to Marie.
Friday does not begin until that topology is validated.
```
