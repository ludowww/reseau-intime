# Narrative Canon Status — Current

> Narrative and implementation status after V0.81.  
> Current playable runtime is canonical through Wednesday only. Thursday and Friday remain authored in V0.79 but unimplemented.

## 1. Core rule

```text
V0.78 defines modular story movement.
V0.79 defines the Tuesday–Friday opening content.
V0.80 defines the phased runtime plan.
V0.81 implements only the Tuesday handoff and Wednesday slice.
Legacy runtime is not automatic narrative canon.
```

## 2. Current source stack

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
docs/V0_80_First_Modular_Runtime_Integration_Plan.md
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
docs/V0_81_Tuesday_Handoff_And_Wednesday_Runtime_Report.md
```

Then read the relevant full character canon and NSFW canon when applicable.

## 3. Current playable chronology

### Tuesday evening — J1

Active threads:

- Marie;
- Sandra.

Current result:

```text
couple mode = HABITUAL_WARMTH
Mathilde = indirect only
hard secrets = none
adult frames = none
```

The active modular index removes the deprecated messages and visual reference that presented Mathilde as already installed.

### Wednesday midday — O1

Marie announces Mathilde's water-damage emergency.

M0 records how Player makes room:

- proactive;
- playful-present;
- passive assent.

No choice denies emergency shelter.

### Wednesday late afternoon — O2 trace

Marie sends the authorized ordinary image:

```text
mathilde_arrival_room_01
```

The image is practical, low-risk, and known to Mathilde.

### Wednesday evening — O2 Mathilde

Mathilde opens her persistent direct thread.

MT0 records a practical, teasing-helpful, or distant welcome.

When Player returns, chat stops and settling continues through an authored `offline_beat`.

## 4. Current runtime architecture

Active indexes:

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
```

Legacy Chapter 1–9 files remain on disk but Chapter 3+ is not selectable in current navigation.

The implementation reuses:

- persistent thread grouping;
- segmented conversations;
- sequential unlocks;
- notifications;
- existing choices and effects;
- placeholder visual cards.

Narrow V0.81 adapters add:

- data-driven day labels;
- data-driven narrative time;
- available-episode-only metadata;
- authored `time_separator` and `offline_beat` handling;
- persistent/deduplicated system notes;
- narrative-time updates from offline beats.

## 5. Current state writes

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

These are observable-history flags.

V0.81 does not write:

- new affection/desire scores;
- route dominance;
- jealousy state;
- hard secrets;
- adult consent frames;
- couple-mode transitions.

## 6. Time and communication status

Current UI labels:

```text
Mardi — Les choses qu'on remarque
Mercredi — Faire de la place
```

Wednesday narrative times:

```text
12:10
18:18
18:22
18:46 / 18:50 / 19:15
```

Rules enforced by the slice:

- locked episodes do not leak future time metadata;
- narrative time cannot move backward inside the active day;
- authored time separators and offline beats have no sender or typing indicator;
- offline beats are restored without duplication;
- co-present settling is not simulated as Messenger dialogue.

## 7. Character status after Wednesday

### Marie

- remains the active family/couple bridge;
- receives Player's participation response;
- keeps one persistent thread across Tuesday and Wednesday.

### Mathilde

```text
stay = active
route stage = R1 Ordinary Access
sexual intention = not established
```

### Sandra

- remains Tuesday trace only in current playable runtime;
- Thursday echo is not implemented.

### Raphaëlle, Pauline, Nico

- no current playable post-J1 access yet;
- their V0.79 entry scenes wait for V0.82/V0.83.

## 8. Current exclusions

Not implemented:

- Thursday O3–O6;
- condition-aware topology branches;
- mandatory Thursday return variants;
- Friday O7–O8;
- adult content;
- route R2+;
- hard secret load;
- universal scheduler;
- save migration.

## 9. Validation status

The branch contains targeted static tests in:

```text
tests/test_v081_wednesday_static.py
```

They cover:

- active index whitelist;
- J1 filter;
- Wednesday unlock sequence;
- persistent threads;
- three-choice shape and flag-only effects;
- no automatic Player messages;
- semantic temporal/offline items;
- visual risk;
- exclusion of Thursday/Friday/adult content;
- wrapper connection and offline-note deduplication.

The current connector environment cannot execute the repository or Godot binaries. Command execution must be confirmed by CI or a local Hermes/Codex environment before merge.

## 10. Next step

After V0.81 validation:

```text
V0.82 — Thursday topology and mandatory Marie return
```

## 11. Final rule

```text
Current playable canon ends Wednesday night.
The next branch must teach one Thursday topology without reopening the old linear days.
```
