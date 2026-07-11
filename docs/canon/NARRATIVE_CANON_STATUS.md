# Narrative Canon Status — Current

> Narrative and implementation status after V0.83 temporal-flow and J1 reconciliation planning.  
> V0.82 remains the playable baseline through Thursday night. Friday is postponed until chronology and J1 are corrected.

## 1. Core rule

```text
V0.78 defines modular story movement.
V0.79 defines the Tuesday–Friday opening content.
V0.80 defines phased runtime integration.
V0.81 implements Wednesday.
V0.82 implements Thursday topology and Marie return.
V0.83 corrects chronological access and active J1 truth.
Legacy runtime is not automatic narrative canon.
```

## 2. Current source stack

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/TEMPORAL_FLOW_AND_DAY_TRANSITION_CANON.md
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md
docs/V0_83_Temporal_Flow_And_J1_Reconciliation_Report.md
docs/runtime/V0_84_DAY_AND_MOMENT_FLOW_IMPLEMENTATION_PLAN.md
docs/runtime/V0_85_J1_CANON_RUNTIME_RECONCILIATION_PLAN.md
```

Read current character canon and global NSFW canon when relevant.

---

## 3. Current playable baseline

V0.82 currently exposes:

```text
Mardi
Mercredi
Jeudi
```

Active indexes:

```text
chapter_01_modular_index.json
chapter_02_modular_index.json
chapter_03_modular_index.json
```

Playable narrative content still ends Thursday night after O6 Marie.

No Friday, Pauline, Nico, R2, hard secret, or adult frame is active.

---

## 4. Confirmed temporal debt

### Days are immediately selectable

The phone currently renders every loaded active day from startup.

This allows the player to enter Wednesday or Thursday before completing Tuesday.

Target after V0.84:

```text
Tuesday active
Wednesday locked
Thursday locked

Tuesday complete
-> transition
-> Wednesday unlocked and selected

Wednesday complete
-> transition
-> Thursday unlocked and selected
```

Past days become read-only archives.

### No day-transition interstitial

Target sequence:

```text
MARDI — FIN DE JOURNÉE

MERCREDI — MIDI
Faire de la place
```

### Thursday phases overlap

Current V0.82 behavior unlocks:

```text
Sandra 13:50
Marie 16:05
```

simultaneously after Raphaëlle.

Target after V0.84:

```text
09:10 Raphaëlle required
-> 13:50 Sandra optional
-> explicit advance
-> Sandra seen or expired
-> 16:05 Marie required
```

Sandra cannot remain answerable after the timeline advances.

---

## 5. Temporal-flow canon

Day lifecycle:

```text
LOCKED
AVAILABLE
ACTIVE
COMPLETE
ARCHIVED
```

Phase lifecycle:

```text
LOCKED
CURRENT
COMPLETE
SKIPPED
EXPIRED
```

Core rule:

```text
Time labels describe chronology.
Timeline state controls access.
```

Optional scenes must be seen, skipped, expired, or mutated before the story moves beyond their window.

---

## 6. Confirmed active J1 debt

The current active Tuesday index filters a few legacy Mathilde items but still uses the large historical Marie/Sandra conversations.

Confirmed issues:

- Player says `On est mercredi` during active Tuesday;
- timestamps move backward inside Marie and Sandra;
- all Marie content occurs before all Sandra content;
- the day ends on Sandra rather than Marie/shared life;
- promised dinner/walk is not represented as a real offline event;
- Sandra includes lake/nature, romance-novel, deep confidence, and missing-each-other escalation beyond J1's soft-trace function;
- old numeric effects still write attachment/attention/neglect/priority scores;
- dozens of fixed Player lines are presented as one-option clicks.

These are not current story decisions to preserve.

---

## 7. Corrected J1 source

Future active Tuesday structure:

```text
18:12 Marie remote opening
-> dinner / bread / walk
-> M1: present / playful-present / delayed-flat
-> La Verrière + indirect Mathilde seed

19:15 shared dinner/walk offline beat

22:57 Sandra old lunch trace
-> S1: safe warmth / precise observation / cautious
-> soft boundary

23:25 final Marie/shared-life offline beat

Tuesday complete
-> transition
-> Wednesday unlock
```

The active J1 must use new concise files rather than filter the legacy files further.

State writes are flags only.

---

## 8. Current route and character status

V0.83 changes documentation only.

Playable state remains:

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Mathilde = R1 Ordinary Access
Raphaëlle = R1 Ordinary Work Access
Sandra = soft continuity
Pauline = inactive
Nico = inactive
hard secrets = none
adult frames = none
```

---

## 9. V0.84 implementation boundary

V0.84 implements only:

- day lock/unlock state;
- phase state;
- day-end/day-start interstitial;
- intra-day transition cards;
- archive-safe navigation;
- required vs optional phase gating;
- Sandra optional expiry before Marie Thursday;
- source-episode completion tracking;
- Friday remaining absent.

It does not rewrite J1 or add story content.

---

## 10. V0.85 implementation boundary

V0.85 implements only:

- new active Marie/Sandra J1 conversation files;
- concise M1/S1 three-choice nodes;
- Tuesday shared-evening offline beat;
- Tuesday final Marie offline beat;
- flag-only state;
- removal of filter-based active J1 references;
- Wednesday unlocking only after final Marie beat.

It does not alter Wednesday/Thursday story meaning or add Friday.

---

## 11. Current validation status

V0.82 was validated before merge:

```text
74 tests OK
validate_game_data OK
writing tools OK
git diff --check OK
Godot headless boots OK
```

V0.83 adds documentation only and requires no runtime execution.

V0.84 and V0.85 will each require dedicated static tests, writing checks, diff check, and both Godot headless boots.

---

## 12. Roadmap

```text
V0.83 — temporal-flow and J1 documentation correction
V0.84 — day and moment flow runtime foundation
V0.85 — J1 canon runtime reconciliation
V0.86 — Friday public traces and opening completion
```

Friday must not begin before V0.84 and V0.85 are validated.

---

## 13. Final rule

```text
Current playable canon ends Thursday night.
The next work is not more content.
It is making time authoritative and Tuesday truthful.
```
