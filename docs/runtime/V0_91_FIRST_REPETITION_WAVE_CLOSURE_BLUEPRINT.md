# V0.91 — First Repetition Wave Closure Blueprint

> Documentation-only product and runtime blueprint after the locked V0.90 second-repetition slice.  
> This document authorizes no runtime, JSON, GDScript, test, scene, asset, save, merge, or tag change by itself.  
> Future implementation begins only after Product Owner validation.

## 1. Authority and locked baseline

Repository:

```text
ludowww/reseau-intime
```

Locked baseline:

```text
version: V0.90 — Second Repetition Sandra Vertical Slice
main / origin/main: 851ad02200ac2bef974eef89c4b56ed9b14f8bd1
tag: v0.90-second-repetition-sandra-vertical-slice
PR: #41
engine: Godot 4.6.x
```

Validated V0.90 runtime:

```text
Saturday W9
  Marie shared hour

Sunday W10
  Mathilde candidate / expiry / defer
  mandatory Marie return W11
  first_repetition_slice_01_complete

Monday W12
  carried morning promise paid when present
  Sandra candidate / expiry / defer
  mandatory Marie return W13
  first_repetition_slice_02_complete
```

V0.90 validation at lock:

```text
152 static tests passed
runtime smoke A–I passed
data validation passed
Player choice/presence checks passed
Godot headless and 1280×720 boot passed
```

Known non-blocking technical debt:

```text
ObjectDB instances leaked at exit
```

This warning belongs to the isolated runtime-smoke harness. It is not part of the V0.91 narrative closure scope.

Read this blueprint after:

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
docs/runtime/V0_88_FIRST_REPETITION_RUNTIME_INTEGRATION_PLAN.md
```

V0.87 remains the narrative authority. V0.91 decides how the already implemented W9–W13 runtime closes truthfully.

---

## 2. Product decision

The first-repetition wave is now narratively complete enough to close.

V0.91 decides:

```text
W13 already exists in V0.90.
The Monday Marie return is the final couple anchor.
No third external foreground is required.
No additional character scene is required.
```

The future runtime implementation target is:

```text
V0.92 — First Repetition Wave Closure Runtime
```

V0.92 should add one small, silent, guarded closure step after the existing Monday slice close.

It should write:

```text
first_repetition_wave_complete
```

It should not open another day or another narrative wave.

---

## 3. Why the wave closes now

The V0.87 source pack defined:

```text
one fixed Marie foreground
+ zero to two external foregrounds
+ mandatory Marie returns
+ maximum one charged-access owner
```

The implemented runtime now provides:

```text
fixed Marie W9 foreground
weekend Mathilde opportunity
mandatory Sunday Marie return
first-workday Sandra opportunity
mandatory Monday Marie return
```

This satisfies the authored W9–W13 shape even when:

- Mathilde is deferred or expires;
- Sandra is deferred or expires;
- only one external foreground is completed;
- both external foregrounds are completed;
- no charged owner is created;
- Mathilde becomes the charged owner;
- Marie evidence is positive, distant, or mixed.

```text
Wave completion means that the bounded opportunity sequence ended.
It does not mean that every route scene appeared.
```

Raphaëlle, Pauline, and Nico remain valid future material. They are not owed a foreground inside this already bounded first wave.

Keeping the wave artificially open to include them would violate:

- the maximum two-ticket budget;
- the W9–W13 duration;
- the rule that a quiet or deferred opportunity is valid;
- the current replay value of Mathilde/Sandra outcomes;
- the requirement to return to documentation before opening another wave.

---

## 4. Closure placement

Current Monday phase order:

```text
monday_morning_commitment
monday_sandra_end_shift_candidate
monday_sandra_resolution
monday_marie_return
monday_marie_resolution
monday_slice_close
```

Future V0.92 should append one internal phase:

```text
monday_first_repetition_wave_close
```

Resulting order:

```text
monday_morning_commitment
monday_sandra_end_shift_candidate
monday_sandra_resolution
monday_marie_return
monday_marie_resolution
monday_slice_close
monday_first_repetition_wave_close
```

The new phase must:

- contain no conversation;
- contain no player choice;
- produce no notification;
- produce no visible explanatory card;
- produce no archive-facing “Moments hors ligne” entry;
- run only after `first_repetition_slice_02_complete`;
- call one small closure predicate;
- write `first_repetition_wave_complete` only when the predicate passes;
- remain idempotent.

Monday remains the playable endpoint.

```text
chapter_07_modular_index.json next_day = null
```

V0.92 does not unlock Tuesday.

---

## 5. Authoritative closure predicate

The wave is closable only when all conditions below are true.

### 5.1 Slice completion

Required flags:

```text
first_repetition_slice_01_complete
first_repetition_slice_02_complete
```

The closure predicate must not infer slice completion from time, ordinal, or episode count alone.

### 5.2 Final Marie anchor

The Monday Marie return must have completed.

At least one final posture flag must exist:

```text
marie_monday_return_active
or
marie_monday_return_bounded
or
marie_monday_return_honest_distance
```

The corresponding resolution state must already be applied:

```text
marie_monday_return_realized
or
marie_monday_bounded_time_paid
or
marie_monday_evening_separate
```

The closure does not require a positive Marie result. Honest distance is a valid terminal result.

### 5.3 Obligations are terminal

No obligation in:

```text
story_ledgers.first_repetition.obligations
```

may remain in:

```text
SCHEDULED
DUE
CARRIED
```

Allowed terminal statuses:

```text
PAID
FAILED
```

An empty obligation dictionary is also valid.

The closure must be blocked if any obligation is still waiting for a future act.

The Sunday M3B morning promise is not a loophole: V0.90 pays it before Monday’s Sandra opportunity. If it remains `CARRIED`, closure fails.

### 5.4 Candidate lifecycle is terminal

The implemented candidate scenes are:

```text
mathilde_morning_kitchen_afterglow_01
sandra_end_of_shift_twenty_minutes_01
```

If either scene appears in `scene_status`, its status must be one of:

```text
RESOLVED
EXPIRED
DEFERRED
```

Closure must reject:

```text
DORMANT
ELIGIBLE
OFFERED
SEEN
```

A missing scene-status entry is valid only when that candidate was never evaluated by the implemented topology. The normal V0.89/V0.90 path should produce a terminal status for both opportunities.

### 5.5 Foreground integrity

Required invariants:

```text
external_foreground_scene_ids.size <= 2
external_foreground_character_ids.size <= 2
both arrays have the same size
no duplicate scene
no duplicate character
```

Implemented foreground characters are currently:

```text
mathilde
sandra
```

Zero foregrounds is valid.

### 5.6 Charged-owner integrity

The closure does not create, transfer, or clear the owner.

Currently reachable runtime values are:

```text
charged_access_owner = ""
charged_access_owner = "mathilde"
```

Sandra remains R1 in V0.90 and must not be promoted retroactively.

If an owner exists:

- the owner must already be present in `external_foreground_character_ids`;
- the owner must remain unchanged through closure;
- the owner means only first charged access;
- the owner grants no adult permission, image permission, secret, priority override, or future automatic scene.

Unexpected owner values are integrity failures in the V0.92 implementation. They are not silently erased.

---

## 6. State written at closure

The only new narrative fact required is:

```text
first_repetition_wave_complete = true
```

Do not add a new mutable ledger schema merely to repeat that fact.

No new fields are required in:

```text
story_ledgers.first_repetition
```

The existing ledger becomes historical evidence and remains readable:

```text
opportunity_window_ordinal
external_foreground_scene_ids
external_foreground_character_ids
charged_access_owner
scene_status
cooldown_until_ordinal
obligations
```

Do not reset or compact it at closure.

### 6.1 Preserve scene history

Keep terminal scene statuses unchanged.

Examples:

```text
Mathilde = RESOLVED
Sandra = EXPIRED
```

or:

```text
Mathilde = DEFERRED
Sandra = RESOLVED
```

These distinctions are useful future continuity.

### 6.2 Preserve cooldown history

Cooldown values remain historical metadata.

The closed wave no longer selects candidates from this ledger, so the closure does not need to advance or clear cooldowns.

### 6.3 Preserve Marie evidence

Existing evidence flags remain independent:

```text
active_reconnection_evidence
parallel_drift_evidence_soft
```

Both may coexist.

The closure does not synthesize a final relationship verdict and does not select one “winning” evidence family.

### 6.4 Preserve the charged owner

```text
none stays none
mathilde stays mathilde
```

A later source pack may define how charged access matures, cools, transfers, or closes. V0.91 does not.

---

## 7. Relationship and route state at exit

After closure:

```text
opening_band_complete = true
first_repetition_slice_01_complete = true
first_repetition_slice_02_complete = true
first_repetition_wave_complete = true

Marie / Player mode = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE

external foreground repetitions = 0–2
charged_access_owner = none | mathilde

Mathilde = R1 or R2 Charged Access
Sandra = R1 maximum in the implemented wave
Raphaëlle = R1
Pauline = R1
Nico = R1

hard secrets = none
adult frames = none
adult images = none
routes R3+ = none
```

Wave closure must not:

- convert evidence into a breakup or repair lock;
- create a confession obligation;
- create an affair flag;
- promote Sandra to R2;
- promote Raphaëlle, Pauline, or Nico;
- reopen an expired scene;
- imply that Marie knows private threads;
- imply permission from attention or jealousy.

---

## 8. Next-wave handoff contract

V0.92 ends on the completed Monday.

It must not decide the next playable day.

A later documentation milestone should define:

```text
V0.93 — Next Act I Wave Source Pack
```

The next wave may begin only when:

```text
first_repetition_wave_complete = true
```

The next wave should not reset `story_ledgers.first_repetition`.

Recommended future architecture:

```text
first_repetition ledger = immutable historical wave record
new wave = new dedicated ledger or explicitly named state root
```

The exact name and structure of the next ledger remain out of scope for V0.91.

Tuesday remains unavailable until that later source pack and integration plan are validated.

---

## 9. Future V0.92 implementation boundary

Expected new files:

```text
game/scripts/narrative/FirstRepetitionClosure.gd
game/scripts/ui/PhonePrototypeV092.gd
tests/test_v092_first_repetition_wave_close_static.py
game/tests/V092RuntimeSmokeScenarioDriver.gd
```

Expected modified files:

```text
game/data/conversations/chapter_07_modular_index.json
game/scenes/smartphone/PhonePrototype.tscn
tools/test_v092_runtime_smoke.sh
```

Potentially modified documentation after implementation:

```text
README.md
ROADMAP.md
docs/canon/NARRATIVE_CANON_STATUS.md
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/runtime/README.md
```

Expected unchanged files:

```text
game/data/conversations/chapter_07_sandra_end_of_shift.json
game/data/conversations/chapter_07_marie_monday_return.json
game/data/visual_content/**
game/scripts/core/TimelineState.gd
game/scripts/core/EffectApplier.gd
game/scripts/ui/ConversationViewV086A.gd
```

A future implementation must justify any change outside this boundary.

### 9.1 Closure helper contract

`FirstRepetitionClosure.gd` should be a pure helper.

Suggested interface:

```gdscript
static func evaluate(flags: Array, ledger: Dictionary) -> Dictionary
```

Suggested result:

```text
{
  "closable": bool,
  "blocking_reasons": Array[String]
}
```

The helper must not mutate `GameState` or `TimelineState`.

### 9.2 Phone adapter responsibility

`PhonePrototypeV092.gd` should:

- extend `PhonePrototypeV090.gd`;
- invoke the pure closure helper in the final internal phase;
- apply `first_repetition_wave_complete` when closable;
- remain idempotent;
- push a precise runtime error when closure is blocked;
- keep Monday as the endpoint;
- avoid all conversation-view changes.

---

## 10. Runtime validation matrix for V0.92

The future runtime smoke should keep one isolated Godot process per scenario.

### A — no completed external foreground

```text
Mathilde deferred or expired
Sandra deferred or expired
Marie returns resolved
-> wave closes
```

Expected:

```text
external foreground count = 0
charged_access_owner = ""
first_repetition_wave_complete = true
```

### B — one completed external foreground

```text
Mathilde resolved
Sandra deferred or expired
Marie returns resolved
-> wave closes
```

### C — two completed external foregrounds

```text
Mathilde resolved
Sandra resolved
Marie returns resolved
-> wave closes
```

Expected:

```text
foreground characters = [mathilde, sandra] in authored history order
count = 2
```

### D — Mathilde owns charged access

```text
charged_access_owner = mathilde
Sandra remains R1
Marie return resolves
-> owner preserved
-> wave closes
```

### E — honest-distance Marie ending

```text
marie_monday_return_honest_distance
marie_monday_evening_separate
obligation = FAILED
-> wave closes
-> relationship mode unchanged
```

### F — mixed evidence

```text
active_reconnection_evidence
parallel_drift_evidence_soft
-> both preserved
-> wave closes
-> no synthesized verdict
```

### G — unresolved obligation blocks closure

Inject one obligation in:

```text
SCHEDULED
DUE
or
CARRIED
```

Expected:

```text
first_repetition_wave_complete absent
blocking reason identifies the obligation
Monday remains the endpoint
```

### H — non-terminal candidate blocks closure

Inject:

```text
scene_status = OFFERED
```

Expected:

```text
closure blocked
no lifecycle mutation
```

### I — idempotency

Run the closure resolver twice.

Expected:

```text
first_repetition_wave_complete remains true
ledger unchanged
no duplicate log, notification, or state mutation
```

---

## 11. Static validation requirements

Future tests must verify:

- the Monday index appends exactly one internal closure phase;
- Monday `next_day` remains `null`;
- no new conversation file is added;
- no new character is foregrounded;
- the closure helper is pure;
- all non-terminal obligation statuses block closure;
- `PAID`, `FAILED`, and empty obligations permit closure;
- terminal Mathilde/Sandra statuses permit closure;
- `OFFERED`, `SEEN`, and `ELIGIBLE` block closure;
- foreground arrays cannot exceed two or contain duplicates;
- the owner is preserved and not manufactured;
- the currently supported owner is empty or Mathilde;
- Marie active, bounded, and honest-distance results can all close;
- `HABITUAL_WARMTH` and `ASSUMED_EXCLUSIVE` remain unchanged;
- no adult, secret, image, R3, route-menu, or next-day token appears;
- the runtime closure is idempotent;
- V0.90 smoke A–I remains green.

Expected validation commands for V0.92:

```bash
python3 tools/validate_game_data.py

python3 -m unittest \
  tests.test_godot_prototype_static \
  tests.test_v081_wednesday_static \
  tests.test_v082_thursday_static \
  tests.test_v084_temporal_flow_static \
  tests.test_v085_j1_reconciliation_static \
  tests.test_v086_friday_opening_static \
  tests.test_v086a_temporal_ux_static \
  tests.test_v089_first_repetition_static \
  tests.test_v090_sandra_repetition_static \
  tests.test_v090_selector_day_normalization_static \
  tests.test_v090_expiry_persistence_static \
  tests.test_v092_first_repetition_wave_close_static \
  -v

bash tools/test_v090_runtime_smoke.sh
bash tools/test_v092_runtime_smoke.sh

git diff --check

godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

The existing non-blocking ObjectDB leak warning may be reported separately. Fixing it is not a V0.92 acceptance criterion unless it becomes a functional failure.

---

## 12. Explicit exclusions

Reject any V0.91 interpretation or V0.92 implementation that adds:

- a third external foreground;
- a Raphaëlle foreground;
- a Pauline foreground;
- a Nico foreground;
- another Sandra route stage;
- a new Mathilde scene;
- a new Marie conversation;
- a new day;
- Tuesday runtime;
- a route-selection menu;
- a new image or visual-content bundle;
- an adult frame or adult image;
- a hard secret, confession, alibi, or affair;
- a relationship-mode change;
- a route R3+;
- a second charged owner;
- automatic owner transfer or owner clearing;
- a summary screen;
- a visible wave-complete card;
- a save system or migration layer;
- a general scheduler refactor;
- a `TimelineState` lifecycle rewrite;
- a `ConversationView` rewrite;
- ObjectDB leak cleanup bundled into the narrative closure.

---

## 13. Rollback boundary

V0.92 should remain squashable as one small runtime change.

Rollback must restore:

```text
PhonePrototype scene -> V090 adapter
no FirstRepetitionClosure helper
no Monday wave-close phase
first_repetition_wave_complete remains absent
V0.90 runtime endpoint preserved
```

No prior conversation or state data should require reverse migration.

---

## 14. Acceptance criteria for V0.91

V0.91 is ready for Product Owner validation when:

- the decision to close after existing W13 is explicit;
- zero to two foregrounds are all valid exits;
- no third route scene is required;
- the closure predicate is exact and testable;
- unresolved obligations block closure;
- terminal candidate states are defined;
- foreground and owner integrity rules are explicit;
- Mathilde owner is preserved rather than cleared;
- Sandra remains R1 in the implemented wave;
- Marie positive, bounded, and honest-distance outcomes all remain valid;
- couple mode and relationship frame remain unchanged;
- Monday remains the endpoint;
- Tuesday remains unavailable;
- the next wave receives a clean handoff contract;
- future V0.92 scope is smaller than a new narrative slice;
- ObjectDB leak work remains separate;
- this documentation branch changes no runtime file.

---

## 15. Final rule

```text
V0.89 proved the first repetition window.
V0.90 proved the second.

V0.91 does not search for a third temptation.
It closes the bounded wave after the story has returned to Marie.

What repeated is now history.
What it means next requires a new wave.
```