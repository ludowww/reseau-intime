# Documentation Reading Order — Canon Current

> Canon entry point after V0.80 runtime audit and integration planning.  
> Read this file before older character, route, proof, day-plan, or runtime documentation.  
> Runtime remains unchanged until a later V0.81 implementation PR.

## 1. Core rules

```text
Write people from full character canon.
Write story movement from the V0.78 modular blueprint.
Write the opening from the V0.79 source pack and scene cards.
Write time and delivery from the temporal canon and map.
Plan runtime from V0.80.
Implement only the approved V0.81 slice afterward.
Use three choices by default.
Existing runtime is not automatic narrative canon.
```

## 2. Official reading order

Read in this order:

1. `docs/canon/NARRATIVE_CANON_STATUS.md`
2. `docs/canon/CHOICE_DESIGN_CANON.md`
3. `docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md`
4. `docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md`
5. `docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md`
6. first post-J1 content:
   - `docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md`
   - `docs/canon/ACT_I_OPENING_SCENE_CARDS.md`
   - `docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md`
7. runtime planning:
   - `docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md`
   - `docs/V0_80_First_Modular_Runtime_Integration_Plan.md`
   - `docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md`
8. `docs/canon/characters/CHARACTER_CANON_INDEX.md`
9. the relevant principal full-canon file:
   - `docs/canon/characters/MARIE_CANON_FULL.md`
   - `docs/canon/characters/SANDRA_CANON_FULL.md`
   - `docs/canon/characters/PLAYER_CANON_FULL.md`
   - `docs/canon/characters/MATHILDE_CANON_FULL.md`
   - `docs/canon/characters/PAULINE_CANON_FULL.md`
   - `docs/canon/characters/NICO_CANON_FULL.md`
   - `docs/canon/characters/RAPHAELLE_CANON_FULL.md`
10. `docs/canon/characters/NSFW_CHARACTER_ROUTE_CANON.md` when adult tension, explicit content, images, voyeurism, cheating, NTR/cuckold, sharing, open arrangements, trio/quatuor, group content, roleplay, or dark consequences are involved
11. the relevant character deprecation map when older material may conflict
12. `docs/canon/SUPPORTING_CHARACTER_CANON_POLICY.md` when a supporting character appears or is affected
13. current J1 exact sources:
    - `docs/canon/J1_CANON_SOURCE_PACK.md`
    - `docs/V0_69_J1_Canon_Text_Review_And_Final_Line_Source.md`
14. voice and intensity bibles only as support material
15. older arcs, fixed-day plans, proof maps, route matrices, summaries, version reports, and runtime only after explicit cross-checking

`docs/canon/CHARACTERS_CANON_CURRENT.md` remains a doorway only.

---

## 3. Current source hierarchy

```text
full character canon
+ choice canon
+ V0.78 modular architecture
+ modular scene contract
+ diegetic time / communication canon
+ V0.79 opening source pack
+ V0.79 scene cards
+ V0.79 temporal map
= narrative truth

V0.80 audit and integration plan
= technical implementation truth for the next PR

current runtime
= prototype implementation, not automatic narrative truth
```

## 4. V0.78 architecture status

`MODULAR_NARRATIVE_ARC_BLUEPRINT.md` controls:

- fixed dramatic spine;
- Act 0–V structure;
- couple dimensions and modes;
- R0–R5 route lifecycle;
- topology choices;
- narrative windows and scene pools;
- obligations, traces, knowledge, consent, and aftermath;
- selection priority and replayability.

It replaces fixed J2–J10 chronology.

`MODULAR_SCENE_AUTHORING_CONTRACT.md` controls:

- scene requirements and exclusions;
- availability;
- choice contracts;
- state reads/writes;
- trace, knowledge, consent, consequence, cooldown, mutation, and fallback.

## 5. V0.79 opening status

V0.79 writes:

```text
Tuesday evening = J1
Wednesday = Mathilde emergency and arrival
Thursday = work, event topology, and Marie return
Friday = Pauline/Nico traces and household residue
```

Relative windows:

```text
O0 J1 carry-over
O1 make room
O2 Mathilde arrival
O3 Raphaëlle work + Sandra echo
O4 Marie offers movement
O5 one topology foreground
O6 mandatory Marie return
O7 Pauline public photo relay
O8 Nico follow-up + household breather
```

V0.79 remains at R0–R1 with no adult frame, hard secret, or changed relationship agreement.

## 6. Time and communication status

Core rule:

```text
If two characters are in the same room
and can speak normally,
they do not conduct a full Messenger conversation.
```

Current modes:

```text
REMOTE_ASYNC
TRACE_DELIVERY
SEPARATE_ROOMS_PING
SAME_VENUE_LOGISTICS
WORK_CHAT
OFFLINE_BEAT
AFTERGLOW_REMOTE
```

A future runtime scene must include:

- weekday or relative-day anchor;
- moment of day;
- plausible timestamp range;
- physical context;
- reason the phone is used;
- point where messaging stops when co-presence begins.

## 7. V0.80 audit result

The current prototype already supports:

- persistent threads;
- multiple episodes per contact;
- segmented messages;
- three-way choices;
- sequential unlocks;
- notifications;
- timestamps;
- flags;
- placeholder visuals.

It does not yet support:

- branch-conditioned unlocks;
- conditional content variants;
- semantic offline beats;
- data-driven weekday/status time;
- active-only day navigation.

The current J1 runtime also still shows Mathilde's bags/shoes/racket as if she were already installed. This conflicts with Wednesday's water-damage arrival.

V0.81 must repair that handoff narrowly before integrating Wednesday.

## 8. Approved implementation decomposition

```text
V0.81 — Tuesday handoff + Wednesday vertical slice
V0.82 — Thursday topology + mandatory Marie return
V0.83 — Friday public traces + opening completion
```

Do not combine these into one large runtime PR.

### V0.81

Implement only:

- J1 Mathilde handoff correction;
- Tuesday/Wednesday labels and status time;
- O1 Marie make-room;
- O2 Marie arrival trace;
- O2 Mathilde arrival;
- semantic offline beat;
- one current arrival visual;
- flags only;
- active indexes 01–02 only;
- targeted tests.

### V0.82

May add after V0.81 validation:

- condition-aware unlocks;
- conditional message/segment variants;
- O3–O6 Thursday topology;
- mandatory branch-specific Marie consequence.

### V0.83

May add after V0.82 validation:

- Pauline public photo relay;
- Nico saved-seat follow-up;
- household breather;
- Friday opening completion.

## 9. Choice rule

Default:

```text
3 choices per node
```

V0.81 includes only:

```text
M0 — how Player makes room
MT0 — how Player welcomes Mathilde
```

No four-choice exception is planned.

V0.81 uses flags describing actions, not affection or route points.

## 10. Legacy runtime policy

Legacy J2+ files remain on disk for history, rollback, and technical inspection.

They must not be presented as the current continuation until replaced by validated slices.

For V0.81, the canonical loader should expose only:

```text
chapter_01_index.json
chapter_02_index.json
```

Do not delete old Chapter 3+ files in the first implementation PR.

## 11. Runtime boundary

V0.80 is documentation only.

No runtime work is authorized before Product Owner validation of this plan.

After validation, Hermes/Codex must follow:

```text
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
```

and must not expand into Thursday/Friday without another validated plan.

## 12. Historical documents

The following remain historical or technical support:

```text
docs/J2_WRITING_FOUNDATION.md
docs/story_state/J2_SUMMARY.md
existing old Chapter 2–9 runtime
old fixed-day arcs and route matrices
```

They do not override current canon or V0.80 implementation boundaries.

## 13. Maintenance rule

When implementation constraints require a narrative change:

- stop runtime expansion;
- update the relevant source pack/card/map first;
- update V0.80/V0.81 plan if technical scope changes;
- obtain Product Owner validation;
- then resume runtime work.

Do not silently solve a technical problem by changing character or story meaning.

## 14. Current roadmap

```text
V0.80 — First Modular Runtime Integration Plan
V0.81 — Tuesday handoff + Wednesday runtime vertical slice
V0.82 — Thursday topology and Marie return
V0.83 — Friday traces and opening completion
```

## 15. Final rule

```text
The canon defines the opening.
V0.80 defines the smallest safe path into the prototype.
V0.81 must prove Tuesday can become Wednesday before the engine learns Thursday branching.
```
