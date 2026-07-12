# V0.88 — First Repetition Runtime Integration Plan Report

> Documentation-only milestone after V0.87.  
> Defines the smallest runtime integration slice for the first-repetition wave.  
> No runtime, JSON, GDScript, test, scene, or asset is changed by this report.

## 1. Baseline

```text
Repository: ludowww/reseau-intime
Base version: V0.87 documentation / V0.86 runtime
Base main commit: 1d739454a280c17c76c33c74eab3c6e8a81f2a24
Branch: work/first-repetition-runtime-integration-plan-v0-88
Playable endpoint: Friday evening
opening_band_complete = true
```

Current runtime remains:

```text
Tuesday -> Friday
R1 maximum
hard secrets = none
adult frames = none
```

---

## 2. Decision

The first runtime vertical slice will be:

```text
Saturday W9 Marie shared hour
-> Sunday Mathilde morning-attention opportunity or silent defer
-> Sunday W11 Marie concrete return
```

The future implementation target is V0.89.

It will not implement the full V0.87 wave.

---

## 3. Why Mathilde first

Mathilde was selected because:

- her temporary stay already exists in runtime;
- the household rhythm is already confirmed;
- her persistent thread already exists;
- her scene requires no new image;
- her scene tests a real co-presence-to-distance transition;
- she can remain R1 or become the single first R2 owner;
- Marie and family trust remain active in the meaning;
- the slice can validate ticket, expiry, charged-owner, and return logic with limited surface area.

She was not selected because her later adult route is considered a priority.

Sandra, Raphaëlle, Pauline, and Nico remain authored V0.87 candidates for later small integrations.

---

## 4. Runtime audit conclusion

Current systems already provide:

```text
TimelineState
  day / phase / episode chronology

GameState
  narrative state and flags

DataLoader
  active indexes, phase lookup, thread grouping

PhonePrototypeV086A
  accelerated clock, expiry, notifications, same-thread continuation

ConversationViewV086A
  persistent-thread append, compact banner, offline suppression
```

Missing state concerns:

```text
foreground tickets
charged-access owner
structured obligations
scene lifecycle
cooldowns
candidate-pool selection
partial-wave completion
```

V0.88 places those concerns in a small structured ledger under `GameState.current_state` rather than expanding flat flags indefinitely.

---

## 5. State decision

Planned state root:

```text
story_ledgers.first_repetition
```

Planned fields:

```text
opportunity_window_ordinal
external_foreground_scene_ids
external_foreground_character_ids
charged_access_owner
scene_status
cooldown_until_ordinal
obligations
```

Chronology remains in `TimelineState`.

Observable branch facts remain flat flags.

Authored limits remain in index data.

---

## 6. Deterministic selection

A future small helper:

```text
FirstRepetitionSelector.gd
```

will return:

```text
one eligible candidate
or
none
```

Selection priority:

```text
safety / aftermath
-> due Marie consequence
-> ticket budget
-> character already used
-> authored candidate order
-> hard requirements
-> hard exclusions
-> cooldown / scene status
-> physical and temporal context
```

No random choice and no character-selection menu are planned.

The first candidate pool contains only Mathilde, but already follows the one-or-none interface.

---

## 7. Day plan

### Saturday — day 5

```text
09:35 Marie shared-hour conversation + M2
-> silent shared-hour resolution
-> Saturday complete
```

### Sunday — day 6

```text
10:25 Mathilde candidate or silent defer
-> 19:30–22:30 Marie return + M3 when due
-> first_repetition_slice_01_complete
```

The slice does not set:

```text
first_repetition_wave_complete
```

Monday remains unavailable.

---

## 8. Charged-access decision

Mathilde can claim:

```text
charged_access_owner = mathilde
```

only when:

- MT1A or MT1B was chosen;
- positive household trust/playful history exists;
- no unresolved overstep exists;
- no other owner exists;
- no due Marie consequence was bypassed.

Failure to claim leaves Mathilde at R1 while preserving the soft gaze flag.

R2 still grants no:

```text
deliberate seduction
image permission
adult permission
hard secret
```

---

## 9. Obligation decision

W9 and W11 use structured statuses:

```text
SCHEDULED
DUE
PAID
FAILED
CARRIED
```

Important cases:

- M2A pays the shared hour through a silent internal result;
- M2B schedules and pays the bounded Saturday alternative because no competing content is inserted before it in the first slice;
- M2C schedules a Sunday return without freezing Marie;
- Mathilde completion schedules a Marie return;
- M3B carries a concrete Monday-morning obligation without marking it paid;
- M3C resolves the current obligation as honest failure rather than leaving it dangling.

---

## 10. Communication decision

The future slice preserves V0.86a:

```text
last message
-> contact offline
-> 2-second pause
-> 4-second clock animation
-> compact notification for another thread
```

Same-thread Marie episodes continue directly without a redundant notification.

Co-present scenes remain off-chat.

No blank day card, `Le temps passe` prompt, or visible `Moments hors ligne` section returns.

---

## 11. Image decision

V0.89 will require no new visual asset.

No existing image receives:

- a new crop;
- a new audience;
- a sexual function;
- a forwarding permission;
- a proof-object role.

---

## 12. Planned implementation files

New:

```text
game/data/conversations/chapter_05_modular_index.json
game/data/conversations/chapter_05_marie_shared_hour.json
game/data/conversations/chapter_06_modular_index.json
game/data/conversations/chapter_06_mathilde_morning_afterglow.json
game/data/conversations/chapter_06_marie_concrete_return.json
game/scripts/narrative/FirstRepetitionSelector.gd
game/scripts/ui/PhonePrototypeV089.gd
tests/test_v089_first_repetition_static.py
```

Modified:

```text
game/data/conversations/chapter_04_modular_index.json
game/data/state/initial_state.json
game/scripts/core/DataLoader.gd
game/scripts/core/GameState.gd
game/scenes/smartphone/PhonePrototype.tscn
```

No `ConversationView` change is planned.

---

## 13. Voice decision

The runtime plan explicitly requires:

```text
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
```

Marie keeps domestic/social/practical humor.

Mathilde may use at most one light legal formulation in the scene.

Player remains short, imperfect, and actionable.

No legal-register spillover is authorized for Marie or Player.

---

## 14. Save/default decision

The current prototype has no persistent save/load migration path.

V0.89 will not invent one.

Missing ledger data must receive safe defaults through `GameState` helpers.

The nested dictionary is chosen so future serialization can preserve it without redesigning route state.

---

## 15. Validation decision

Future V0.89 validation must cover:

- Saturday and Sunday unlock order;
- no Monday content;
- exactly three choices for M2, MT1, and M3;
- one candidate or none;
- ticket not consumed on expiry;
- Mathilde R1 when gate fails;
- one charged owner maximum;
- mandatory Marie return;
- carried M3B obligation;
- no `first_repetition_wave_complete`;
- no new image;
- no visible offline explanation;
- both Godot headless boots;
- voice distinction.

---

## 16. Rollback

V0.89 must be one squashable vertical-slice PR.

One revert must restore:

```text
Friday as final active day
PhonePrototypeV086A as active adapter
no first-repetition ledger requirement
no Saturday/Sunday runtime data
```

No Tuesday–Friday migration may be required.

---

## 17. Result

V0.88 converts V0.87 from a broad authored wave into one implementable proof:

```text
Marie creates a real shared-life opportunity.
Mathilde may become a repeated attention under strict conditions.
The story returns to Marie before opening another route possibility.
```

No runtime work is authorized until this plan is validated.
