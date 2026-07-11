# V0.85 — J1 Canon Runtime Reconciliation Plan

> Proposed runtime content replacement after V0.84 temporal-flow foundation.  
> Replaces the filtered legacy Tuesday runtime with a concise modular J1 aligned to V0.69 and V0.83.  
> Does not modify Wednesday, Thursday, Friday, or adult routes.

## 1. Goal

Replace the current active Tuesday implementation.

The current `chapter_01_modular_index.json` still references:

```text
chapter_01_marie.json
chapter_01_sandra.json
```

and filters only a few deprecated Mathilde items.

V0.85 must instead use newly authored active files from:

```text
docs/canon/J1_RUNTIME_RECONCILIATION_SOURCE_PACK.md
```

Legacy J1 files remain on disk and inactive.

---

## 2. Required foundation

V0.85 assumes V0.84 already provides:

- day locking/unlocking;
- temporal phases;
- transition overlay;
- day-level offline beats;
- optional-scene terminal states;
- archive-safe navigation.

Do not implement V0.85 before V0.84 is validated.

---

## 3. Branch and PR

Recommended branch:

```text
work/j1-canon-runtime-reconciliation-v0-85
```

Recommended PR title:

```text
runtime: reconcile J1 with current canon
```

Scope should remain:

- new Tuesday index/content files;
- Tuesday timeline-flow metadata;
- any required J1 visual bundle cleanup;
- targeted tests;
- synchronized docs.

Do not edit Wednesday/Thursday narrative content.

---

## 4. New active files

Create:

```text
game/data/conversations/chapter_01_marie_opening.json
game/data/conversations/chapter_01_sandra_trace.json
```

Replace active Tuesday index content in:

```text
game/data/conversations/chapter_01_modular_index.json
```

with only those two conversation files plus day-level timeline beats.

Stop using `conversation_filters` for the active Tuesday story.

---

## 5. Tuesday timeline-flow

Recommended phases:

```text
tuesday_marie_opening
-> tuesday_shared_evening
-> tuesday_sandra_trace
-> tuesday_marie_final_return
-> day complete
```

### Phase 1 — Marie opening

```text
18:12
required: chapter_01_marie_opening
```

### Phase 2 — Shared evening

```text
approximately 19:15
required authored offline beat
conditional variant by M1 flag
```

### Phase 3 — Sandra trace

```text
22:57
required: chapter_01_sandra_trace
```

### Phase 4 — Marie final return

```text
approximately 23:25
required authored offline beat
conditional variant by M1 flag
```

### Completion

```text
j1_day_complete
-> Tuesday complete
-> day transition to Wednesday
```

No optional phase exists in the reconciled J1.

---

## 6. Marie opening file

Use exact content from V0.83 source pack.

Requirements:

- `thread_marie_private`;
- `communication_mode = REMOTE_ASYNC`;
- one concise guided setup;
- one M1 node with exactly three choices;
- compact La Verrière color beat;
- one optional-in-authoring but selected-in-canon Mathilde lighting seed;
- no automatic Player messages outside guided/choice rendering;
- timestamps non-decreasing;
- no numeric effects.

Choice flags:

```text
j1_marie_present
j1_marie_playful_present
j1_marie_delayed_flat
j1_shared_evening_due
```

Do not write:

```text
marie.trust
marie_attention_score
marie_neglect_score
truth_tendency
```

---

## 7. Shared evening beat

Use V0.84 day-level authored beat support.

Conditions:

```text
present/playful variant
OR
delayed/flat variant
```

Requirements:

- no sender;
- no typing indicator;
- no conversation card;
- visible time/moment transition;
- writes completion flag once;
- persists in timeline history or day log without duplication;
- does not become replayable choice content in archive.

Flags:

```text
j1_shared_evening_completed
j1_marie_return_active
or
j1_marie_return_delayed
```

---

## 8. Sandra trace file

Use exact content from V0.83 source pack.

Requirements:

- `thread_sandra_private`;
- `communication_mode = REMOTE_ASYNC`;
- one old photograph only;
- one compact guided setup;
- S1 with exactly three choices;
- one soft boundary ending;
- optional precise-observation echo only;
- timestamps non-decreasing;
- no numeric effects.

Choice flags:

```text
j1_sandra_safe_warmth
j1_sandra_precise_observation
j1_sandra_cautious
j1_sandra_trace_complete
```

Do not include:

- `On est mercredi`;
- lake/nature scene;
- romance novel;
- tomatoes diversion;
- `absent de moi-même` confidence;
- `Moi aussi, ça m'avait manqué` / `Toi` escalation;
- `sandra.attachment` or `sandra_priority_score`.

---

## 9. Marie final return beat

Use day-level authored beat support.

Requirements:

- mandatory after Sandra completion;
- Player and Marie physically co-present;
- present/playful or delayed/flat variant;
- final emotional center on shared life;
- no additional choice;
- writes `j1_day_complete` once;
- triggers day completion only after rendering.

This beat contains the active motif:

```text
Message à prouver.
Coupe le fromage.
```

---

## 10. Visual content

Active J1 visual bundle should contain only current J1 traces:

```text
j1_marie_kitchen_soft
j1_sandra_lunch_memory_soft
```

Review whether `j1_marie_kitchen_soft` still matches the new source.

If its context implies a photo message no longer present in the exact source, either:

- remove it from active J1; or
- add one concise, canon-consistent Marie image delivery before Player returns.

Preferred conservative option:

```text
remove the kitchen visual from active J1 unless Product Owner validates the photo line
```

`j1_mathilde_bag_domestic_trace` remains legacy only.

No new binary asset is required unless the active bundle references one.

---

## 11. Choice and pacing rule

The active J1 should contain:

```text
2 meaningful three-choice nodes
```

and a small number of guided replies needed for Player voice.

Target interaction budget:

```text
Marie opening: 2–4 guided interactions + M1
Sandra trace: 2–4 guided interactions + S1
```

Do not reproduce the legacy pattern of dozens of one-option clicks.

---

## 12. State cleanup

V0.85 does not need to delete old state keys from `initial_state.json` globally.

It must ensure the active Tuesday content does not write them.

A later state-deprecation pass may remove unused legacy fields after all active content stops referencing them.

Add a static test that scans active J1 files for forbidden numeric-effect keys.

---

## 13. Tests

Add:

```text
tests/test_v085_j1_reconciliation_static.py
```

Cover:

- active Tuesday index references only new modular files;
- no conversation filters;
- phase order Marie -> offline -> Sandra -> Marie offline;
- Tuesday timestamps non-decreasing;
- no `On est mercredi`;
- Mathilde indirect only;
- exact M1 and S1 three-choice counts;
- no automatic Player messages;
- no numeric effects;
- no lake, romance novel, tomatoes, racket, bag, already-installed material;
- final beat requires Marie/shared-life return;
- Tuesday completion requires final Marie beat;
- Wednesday unlocks only afterward;
- legacy J1 files remain present but inactive.

Update existing tests that expect the legacy `chapter_01_marie.json` / `chapter_01_sandra.json` active references.

---

## 14. Manual acceptance walkthrough

1. Launch: Tuesday only.
2. Marie opens at 18:12 with dinner/bread/walk.
3. M1 shows exactly three postures.
4. La Verrière and indirect Mathilde seed appear concisely.
5. Advance to the shared-evening offline beat.
6. Confirm no phone chat while Player and Marie are together.
7. Sandra opens at 22:57 with one blurry lunch trace.
8. S1 shows exactly three postures.
9. Confirm no lake, romance novel, deep absence confession, or Wednesday correction.
10. Complete Sandra's soft boundary.
11. Confirm mandatory final Marie/shared-life offline beat.
12. Confirm Tuesday day-end / Wednesday start interstitial.
13. Reopen Tuesday archive; choices and notifications do not replay.
14. Confirm Wednesday and Thursday content remain unchanged.

---

## 15. Validation commands

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_godot_prototype_static -v
python3 -m unittest tests.test_v081_wednesday_static -v
python3 -m unittest tests.test_v082_thursday_static -v
python3 -m unittest tests.test_v084_temporal_flow_static -v
python3 -m unittest tests.test_v085_j1_reconciliation_static -v
python3 tools/player_choice_text_check.py \
  game/data/conversations/chapter_01_marie_opening.json \
  game/data/conversations/chapter_01_sandra_trace.json
python3 tools/player_presence_check.py \
  game/data/conversations/chapter_01_marie_opening.json \
  game/data/conversations/chapter_01_sandra_trace.json
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

---

## 16. Explicit exclusions

V0.85 must not:

- alter Wednesday content;
- alter Thursday topology or O6 meaning;
- add Friday;
- add Pauline/Nico;
- add R2 or adult content;
- remove all legacy state keys;
- delete legacy J1 files;
- refactor the timeline foundation;
- add save migration.

---

## 17. Rollback

Legacy J1 files remain untouched.

Reverting the V0.85 squash commit restores the previous active index references without data recovery.

---

## 18. Final rule

```text
V0.85 does not expand the opening.
It makes the first evening honest, concise, chronological, and centered on Marie.
```
