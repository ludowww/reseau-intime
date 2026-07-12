# V0.88 — First Repetition Runtime Integration Plan

> Documentation-first integration plan for the V0.87 first-repetition wave.  
> This document authorizes no runtime change by itself.  
> Runtime work begins only after Product Owner validation.

## 1. Authority and baseline

Read first:

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
docs/V0_87_Next_Act_I_Windows_Source_Pack_Report.md
```

Runtime baseline:

```text
repository: ludowww/reseau-intime
engine: Godot 4.6.x
implemented version: V0.86 + V0.86a
main commit at planning start: 1d739454a280c17c76c33c74eab3c6e8a81f2a24
playable chronology: Tuesday -> Friday
runtime endpoint: opening_band_complete = true
runtime route ceiling: R1
```

V0.87 is current narrative authority for the first post-opening repetition wave.

V0.88 decides only how to integrate the smallest truthful portion of that authority.

---

## 2. Product decision — first vertical slice

The first runtime slice will be:

```text
W9  Marie claims one shared hour
-> first compatible Mathilde morning-attention opportunity
-> W11 Marie concrete return
```

Concrete runtime calendar:

```text
Saturday
  W9 Marie shared hour

Sunday
  Mathilde morning afterglow opportunity or silent defer
  W11 Marie concrete return
```

The slice ends after the Sunday return.

It does **not** write:

```text
first_repetition_wave_complete
```

because W12 and W13 remain unimplemented.

The intended future implementation milestone is V0.89.

---

## 3. Why Mathilde is the first external candidate

Mathilde is selected for the first slice for technical and narrative fit, not because her later adult route is considered more important.

### 3.1 Narrative fit

- her temporary stay is already active;
- the household rhythm is already confirmed;
- the source scene grows directly from the opening topology;
- the scene distinguishes ordinary sensuality from deliberate intent;
- Marie and family trust remain present in the meaning;
- the scene can remain R1 or become the single first R2 owner;
- no image, secret, or adult frame is required.

### 3.2 Technical fit

- `thread_mathilde_private` already exists;
- Mathilde already has active profile and conversation support;
- current runtime already supports cross-thread notification to Mathilde;
- current runtime already suppresses visible offline exposition;
- current runtime already supports persistent-thread continuation;
- no new visual asset is required;
- the scene needs one short remote afterglow, not a new social hub;
- it exercises candidate selection, expiry, charged-owner claiming, and Marie consequence without requiring all five route pools.

### 3.3 Why the other candidates wait

Sandra requires her missed-Thursday mutation and a late-night expiry pass.

Raphaëlle requires a work-chat -> offline walk -> same-thread afterglow chain.

Pauline and Nico deliberately remain R1 and are better integrated after the ticket/ledger foundation exists.

None of those scenes is removed. They remain the next candidates after this vertical slice proves the architecture.

---

## 4. Explicit non-goals

V0.88 does not plan one giant implementation of the whole V0.87 wave.

The first runtime PR must not add:

- Sandra W10/W12 foreground;
- Raphaëlle W12 foreground;
- Pauline second social cycle;
- Nico second friendship cycle;
- a second external ticket;
- a second charged candidate;
- a private image;
- a new visual bundle;
- a hard secret;
- an adult frame;
- R3 or higher;
- a relationship-frame change;
- a general random scheduler;
- a full save system;
- a smartphone-dimension redesign;
- removal of the temporary left navigation panel.

The first implementation proves one path through the architecture.

It does not complete the architecture.

---

## 5. Runtime audit

## 5.1 Current authoritative systems

### `TimelineState.gd`

Already owns:

```text
unlocked/completed days
current phase per day
completed/skipped phases
expired conversations
completed episodes
opened optional conversations
internal day log
```

It should remain responsible for chronology.

It should not become the owner of route meaning, charged access, or cross-day obligations.

### `GameState.gd`

Already owns:

```text
current narrative state
flat flags
numeric legacy state
current conversation context
reset state
```

It is the correct home for a small structured story ledger because:

- it is already the canonical narrative-state container;
- reset already rebuilds it from `initial_state.json`;
- a nested dictionary remains serializable for future save work;
- it avoids spreading route state across UI scripts.

### `EffectApplier.gd`

Already supports:

```text
sets_flags
numeric effects
flag conditions
OR conditions
```

It should continue applying authored choice flags.

It should not be expanded into a generic mutation language for arbitrary nested ledgers in the first slice.

### `DataLoader.gd`

Already supports:

```text
active day indexes
persistent-thread grouping
required / optional / required-any phases
unlock rules
conditions
day flow
```

It needs only enough extension to expose candidate-pool metadata and include candidate episode IDs in phase lookup.

### `PhonePrototypeV086A.gd`

Already supports:

```text
2-second pause
4-second accelerated clock
cross-midnight time passage
compact cross-thread notifications
same-thread continuation
optional-window expiry
silent authored beats
no blank interstitial
no visible Moments hors ligne
```

A future `PhonePrototypeV089.gd` should extend it and add only:

```text
candidate-pool activation
ledger-aware obligation priority
foreground ticket recording
charged-owner finalization
```

### `ConversationViewV086A.gd`

Already supports:

```text
persistent thread append
same-thread direct continuation
compact notification banner
notification flash
transcript bottom preservation
contact offline marker
suppressed explanatory offline beats
```

No new conversation-view adapter is planned for the first slice.

---

## 6. Current gaps

The current runtime does not yet represent:

- wave-level foreground ticket history;
- one charged-access owner;
- structured cross-day obligations;
- scene lifecycle beyond episode/day status;
- cooldown by compatible opportunity window;
- deterministic candidate selection from a pool;
- silent defer of a candidate without exposing all contacts;
- a partial-wave completion state distinct from full-wave completion.

These gaps must be solved with the smallest reusable state surface.

---

## 7. Planned runtime file scope for V0.89

Expected new files:

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

Expected modified files:

```text
game/data/conversations/chapter_04_modular_index.json
game/data/state/initial_state.json
game/scripts/core/DataLoader.gd
game/scripts/core/GameState.gd
game/scenes/smartphone/PhonePrototype.tscn
README.md
ROADMAP.md
docs/** relevant runtime/status/report files
```

Expected unchanged files:

```text
game/scripts/core/TimelineState.gd
game/scripts/core/EffectApplier.gd
game/scripts/ui/ConversationViewV086A.gd
game/data/visual_content/**
```

A change to an expected-unchanged file requires an explicit justification in the implementation PR.

---

## 8. Day topology

## 8.1 Friday handoff

Current Friday:

```json
"next_day": null
```

Future V0.89:

```json
"next_day": 5
```

Friday narrative content remains unchanged.

Only its chronological handoff changes after `opening_band_complete`.

## 8.2 Saturday — day 5

Proposed active index:

```text
chapter_05_modular_index.json
calendar_label: Samedi
display_label: Samedi — Une heure
day_start_time: 09:35
next_day: 6
```

Phases:

```text
saturday_marie_shared_hour
saturday_shared_hour_resolution
```

### `saturday_marie_shared_hour`

Required:

```text
chapter_05_marie_shared_hour
```

Purpose:

- present M2;
- record Player's observable weekend-presence posture;
- create or pay a bounded shared-time obligation;
- preserve Marie's independent agency.

### `saturday_shared_hour_resolution`

Silent internal authored-beat variants selected by M2 flag.

The phase may:

- record that Player joined Marie;
- record that the bounded alternative happened;
- record that Marie enjoyed the hour independently;
- schedule a Sunday return obligation;
- advance the clock without displaying explanatory prose.

No player-facing offline card is allowed.

## 8.3 Sunday — day 6

Proposed active index:

```text
chapter_06_modular_index.json
calendar_label: Dimanche
display_label: Dimanche — Ce qu'on a vu
day_start_time: 10:25
next_day: null
```

Phases:

```text
sunday_household_candidate
sunday_marie_return
sunday_slice_close
```

### `sunday_household_candidate`

Candidate pool:

```text
first_repeat_weekend_household_a
```

First-slice candidate list:

```text
chapter_06_mathilde_morning_afterglow
```

The pool may return:

```text
Mathilde episode
or
no visible episode
```

No other candidate is loaded in this first slice.

### `sunday_marie_return`

Required:

```text
chapter_06_marie_concrete_return
```

It runs after the Mathilde candidate is:

- completed;
- declined;
- expired;
- or silently deferred as ineligible.

### `sunday_slice_close`

Silent internal phase writes:

```text
first_repetition_slice_01_complete
```

It must not write:

```text
first_repetition_wave_complete
```

---

## 9. Structured story ledger

Add a top-level dictionary to `initial_state.json`:

```json
"story_ledgers": {
  "first_repetition": {
    "opportunity_window_ordinal": 0,
    "external_foreground_scene_ids": [],
    "external_foreground_character_ids": [],
    "charged_access_owner": "",
    "scene_status": {},
    "cooldown_until_ordinal": {},
    "obligations": {}
  }
}
```

Authored limits remain data, not mutable save values:

```text
external foreground limit = 2
charged owner limit = 1
same character foreground twice = forbidden
```

## 9.1 Why a ledger instead of more flat flags

Flat flags remain appropriate for observable branch facts:

```text
marie_shared_hour_joined
mathilde_gaze_acknowledged_soft
marie_return_paid
```

They are not sufficient for:

- counting foreground tickets;
- selecting the first eligible candidate;
- storing one owner identity;
- tracking a scene through `DEFERRED` / `EXPIRED` / `MUTATED`;
- comparing cooldowns across future opportunity windows;
- preserving cross-day obligations cleanly.

The ledger prevents dozens of mutually dependent bookkeeping flags.

## 9.2 Planned `GameState.gd` helpers

Small explicit helpers only:

```text
ensure_story_ledger(ledger_id, defaults)
get_story_ledger(ledger_id)
set_story_ledger_value(ledger_id, key, value)
record_external_foreground(ledger_id, scene_id, character_id)
claim_charged_access_owner(ledger_id, character_id)
set_scene_status(ledger_id, scene_id, status)
set_scene_cooldown(ledger_id, scene_id, until_ordinal)
set_obligation_status(ledger_id, obligation_id, entry)
get_obligation_status(ledger_id, obligation_id)
```

These helpers must:

- create missing dictionaries safely;
- avoid duplicate foreground records;
- refuse a third external foreground;
- refuse a second charged owner;
- preserve current state when a claim fails;
- emit `state_changed` once per logical mutation where practical.

They must not become a generic scripting language.

---

## 10. Scene lifecycle mapping

Canonical scene states:

```text
DORMANT
ELIGIBLE
OFFERED
SEEN
DEFERRED
MISSED
EXPIRED
MUTATED
RESOLVED
```

First-slice usage:

### Mathilde candidate

```text
DORMANT
-> ELIGIBLE
-> OFFERED
-> SEEN / EXPIRED
```

If hard requirements fail:

```text
DORMANT -> DEFERRED
```

If notification expires unopened:

```text
OFFERED -> EXPIRED
```

The exact scene ID may not be offered again unchanged after `EXPIRED`.

A future pack must provide a mutated scene ID or fresh reason.

### Marie scenes

W9 is a fixed spine scene and does not use opportunity selection.

W11 is a fixed consequence and cannot be skipped while due.

---

## 11. Foreground-ticket representation

A foreground ticket is consumed only when a selected external foreground is completed.

It is not consumed when the scene is merely:

- eligible;
- offered;
- notified;
- ignored;
- expired;
- deferred before opening.

On Mathilde completion:

```text
record_external_foreground(
  first_repetition,
  mathilde_morning_kitchen_afterglow_01,
  mathilde
)
```

Expected first-slice result:

```text
external_foreground_scene_ids size = 0 or 1
external_foreground_character_ids size = 0 or 1
```

The runtime must never expose a route-menu concept such as:

```text
Choose Mathilde
```

It exposes a notification only when the authored context makes Mathilde available.

---

## 12. Candidate-pool data contract

A timeline phase may add:

```json
"candidate_pool": {
  "id": "first_repeat_weekend_household_a",
  "wave_id": "first_repetition",
  "external_ticket_limit": 2,
  "ordered_candidates": [
    {
      "scene_id": "mathilde_morning_kitchen_afterglow_01",
      "conversation_id": "chapter_06_mathilde_morning_afterglow",
      "character_id": "mathilde",
      "requires_all_flags": [
        "opening_band_complete",
        "household_rhythm_confirmed",
        "mathilde_stay_active"
      ],
      "excludes_any_flags": [
        "mathilde_route_closed",
        "mathilde_boundary_broken"
      ],
      "cooldown_windows": 2
    }
  ],
  "fallback": "silent_defer"
}
```

Field names remain implementation details until V0.89, but semantics are fixed.

`DataLoader.gd` must include candidate conversation IDs when resolving:

```text
get_timeline_phase_for_conversation
```

The loader must not automatically unlock every candidate.

---

## 13. Deterministic selection algorithm

`FirstRepetitionSelector.gd` must be a small pure helper.

Input:

```text
candidate pool
current flags
first-repetition ledger
current day / phase
```

Output:

```text
one candidate descriptor
or
empty result
```

Selection order:

```text
1. reject if a due safety/aftermath obligation exists
2. reject if a due Marie return exists
3. reject if external ticket limit is reached
4. reject a character already foregrounded in the wave
5. iterate candidates in authored order
6. test hard required flags
7. test hard excluded flags
8. test scene lifecycle and cooldown
9. test physical/time phase compatibility
10. return first eligible candidate
11. otherwise return empty
```

No random number is used.

The first slice contains one candidate, but the selector contract must already return exactly one or none.

It must not build unused weighting, scoring, or procedural dialogue systems.

---

## 14. Mathilde scene eligibility

Hard requirements:

```text
opening_band_complete
household_rhythm_confirmed
mathilde_stay_active
no unresolved Mathilde boundary breach
no Mathilde route closure
no due Marie consequence at candidate activation
scene not inside cooldown
```

The Sunday placement intentionally satisfies the V0.87 cooldown caution after Thursday O5B.

The scene can still occur at R1 after a distant opening posture.

Prior positive household history controls the R2 gate, not basic scene existence.

Useful existing positive reads:

```text
opening_make_room_proactive
opening_make_room_playful
mathilde_arrival_practical
mathilde_arrival_playful
household_participation_positive
mathilde_home_help
mathilde_home_playful_help
```

Useful cooling reads:

```text
opening_make_room_passive
mathilde_arrival_distant
mathilde_home_distance
```

Cooling reads do not automatically close the scene.

They prevent an unearned R2 transition unless later positive evidence exists.

---

## 15. Charged-access owner

Choice JSON writes only observable branch flags.

For MT1:

```text
MT1A -> mathilde_gaze_acknowledged_soft
MT1B -> mathilde_gaze_playful_soft
MT1C -> mathilde_distance_respected
```

After the conversation completes, `PhonePrototypeV089.gd` evaluates the R2 gate.

Mathilde may claim the owner only when all are true:

```text
choice = MT1A or MT1B
positive household trust / playful history exists
no unresolved overstep
charged_access_owner is empty or already mathilde
no due Marie obligation was bypassed
```

Atomic claim:

```text
claim_charged_access_owner(first_repetition, mathilde)
```

On success:

```text
charged_access_owner = mathilde
flag mathilde_r2_charged_access added
```

On failure:

```text
charged_access_owner unchanged
Mathilde remains R1
soft gaze flag remains valid
```

R2 still means only:

- Player's gaze was acknowledged;
- Mathilde did not reject the acknowledgement;
- deliberate intent remains false;
- no image permission exists;
- no adult permission exists;
- no hard secret exists.

---

## 16. Obligation model

Obligations live in:

```text
story_ledgers.first_repetition.obligations
```

Recommended entry shape:

```json
{
  "status": "SCHEDULED",
  "owner": "player",
  "expected_by": "sunday_marie_return",
  "created_by": "marie_saturday_shared_hour_01",
  "resolved_by": "",
  "result": ""
}
```

Allowed first-slice statuses:

```text
SCHEDULED
DUE
PAID
FAILED
CARRIED
```

## 16.1 W9 obligations

### M2A — join now

Choice flag:

```text
marie_shared_hour_joined
```

Silent Saturday resolution writes:

```text
marie_shared_hour_paid
active_reconnection_evidence
```

### M2B — bounded alternative

Choice flags:

```text
marie_shared_hour_rescheduled
marie_shared_time_scheduled
```

Because the first slice inserts no competing foreground before the promised Saturday lunch/walk, the silent Saturday resolution may pay this exact promise.

It writes:

```text
marie_shared_time_paid
active_reconnection_evidence
```

If a future implementation inserts a conflict before payment, it must replace this automatic resolution with a real consequence window. It may not silently keep the promise paid.

### M2C — Marie acts independently

Choice flags:

```text
marie_moves_without_player
marie_weekend_return_scheduled
parallel_drift_evidence_soft
```

The obligation is `SCHEDULED`, not immediately `DUE`.

It becomes due at W11.

## 16.2 External foreground consequence

Completing Mathilde always schedules:

```text
marie_return_after_external
```

The obligation becomes `DUE` when Sunday reaches W11.

No later external candidate may open while it is due.

## 16.3 M3 results

### M3A — immediate act

```text
marie_return_paid
active_reconnection_evidence
obligation = PAID
```

### M3B — bounded next-morning act

```text
marie_next_morning_obligation_scheduled
obligation = CARRIED
expected_by = monday_morning
```

Sunday may complete because the obligation is not due until Monday.

The runtime must retain it even though Monday is not yet implemented.

The UI should state only that the continuation is unavailable, not pretend the promise was paid.

### M3C — honest non-repair

```text
marie_return_honest_drift
parallel_drift_evidence
obligation = FAILED
```

The consequence is resolved honestly rather than left dangling.

---

## 17. Cooldown mapping

The ledger stores:

```text
opportunity_window_ordinal
cooldown_until_ordinal[scene_id]
```

The ordinal increases only when a compatible external opportunity window is evaluated.

It does not increase for:

- fixed Marie scenes;
- silent authored beats;
- ordinary same-thread continuation;
- archive visits;
- phone-clock animation alone.

When Mathilde is completed at ordinal `N`:

```text
cooldown_until_ordinal = N + 3
```

Meaning:

- next compatible window blocked;
- second compatible window blocked;
- eligibility may return at the following compatible window with a fresh scene/engine.

If Mathilde expires unopened:

```text
scene_status = EXPIRED
```

The same exact scene ID may not be re-offered.

A future mutation requires a new scene ID or explicit mutation mapping.

---

## 18. Optional-window behavior

Mathilde remains an opportunity, not mandatory route content.

The candidate notification may use the current V0.86a optional-window behavior:

```text
notification appears
-> bounded real-time affordance
-> opening the conversation cancels expiry
-> opened conversation blocks time until resolved
-> unopened conversation expires and time continues
```

The existing default is eight real seconds.

V0.89 may make the duration phase-configurable only if the change remains local and defaults to current behavior.

The real-time affordance is not the diegetic duration.

The diegetic duration is represented by the Sunday morning clock range and scene expiry state.

---

## 19. Communication and co-presence

## 19.1 W9 Marie

```text
Marie outside
Player at home / leaving
REMOTE_ASYNC
```

If Player joins, messaging stops when they meet.

The shared hour is internal state and later tone, not an explanatory card.

## 19.2 Mathilde

Before chat:

```text
Player and Mathilde briefly shared the kitchen
Marie absent for a real reason
Mathilde in ordinary fitted homewear
Player looked
Mathilde noticed
```

During chat:

```text
Mathilde has left the room/home for a real errand
Player is elsewhere
AFTERGLOW_REMOTE
```

The runtime must not display a long conversation while they remain together in the kitchen.

The phone does not narrate the whole kitchen event in prose.

## 19.3 Marie return

If Player and Marie are apart, M3 uses real messages.

If they become co-present through M3A, the chat stops at the meeting point.

A paid offline act changes state and later tone without a visible `Moments hors ligne` explanation.

---

## 20. Thread and notification behavior

Persistent threads remain:

```text
Marie    -> thread_marie_private
Mathilde -> thread_mathilde_private
```

Expected flow:

### Saturday to Sunday Mathilde

If Marie thread remains open:

```text
clock crosses midnight
-> Mathilde becomes unread
-> compact Mathilde notification appears
```

### Mathilde to Marie return

If Mathilde thread is open:

```text
clock advances to evening
-> Marie becomes unread
-> compact Marie notification appears
```

### Same-thread Marie continuation

If no Mathilde scene was offered and Marie thread remains active:

```text
clock advances
-> no redundant Marie notification
-> Sunday Marie episode continues directly
```

No `ConversationView` rewrite is planned.

---

## 21. Conversation data contract

## 21.1 `chapter_05_marie_shared_hour.json`

Required:

- thread `thread_marie_private`;
- exact V0.87 M2 line source, with voice-distinction corrections preserved;
- three choices only;
- no numeric effects;
- no route-name labels;
- Player messages remain real messages;
- no explanatory offline paragraph rendered as chat.

Choice flags:

```text
M2A marie_shared_hour_joined
M2B marie_shared_hour_rescheduled
M2C marie_moves_without_player
```

## 21.2 `chapter_06_mathilde_morning_afterglow.json`

Required:

- thread `thread_mathilde_private`;
- exact V0.87 MT1 meaning;
- three choices only;
- at most one light legal formulation from Mathilde;
- no legal register borrowed by Player or Marie;
- no image;
- no deliberate outfit selection;
- no consent inference;
- no score effects.

Choice flags:

```text
MT1A mathilde_gaze_acknowledged_soft
MT1B mathilde_gaze_playful_soft
MT1C mathilde_distance_respected
```

## 21.3 `chapter_06_marie_concrete_return.json`

Required variants:

```text
warm paid echo
unpaid / independent-Marie return with M3
external-attention return with M3
```

M3 remains three choices:

```text
immediate act
bounded next-morning act
honest non-repair
```

No grand confession is demanded when no named couple boundary was crossed.

---

## 22. Voice-distinction gate

Every runtime JSON review must read:

```text
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
```

Specific first-slice guardrails:

### Marie

Use:

- shared life;
- food;
- movement;
- practical humor;
- concrete time.

Do not give her repeated legal, contractual, evidence, or case-file jokes.

### Mathilde

One light legal formulation may remain.

The legal register is seasoning, not the scene structure.

### Player

Keep replies short, slightly awkward, observable, and actionable.

Do not turn him into a polished narrator or a second Mathilde.

A future static test should reject obvious cross-voice leakage in the three new files.

---

## 23. Save/default compatibility

The current prototype has no persistent save/load migration path.

V0.89 must not invent a full save architecture.

Compatibility rule:

```text
missing story_ledgers
or missing first_repetition keys
-> create safe defaults at runtime
```

`GameState.ensure_story_ledger` must be called:

- after reset;
- before candidate selection;
- before obligation reads;
- before charged-owner claim.

This gives future serialized saves a deterministic default path without adding unused migration code now.

Existing flat flags and legacy numeric keys remain untouched.

---

## 24. Small code boundary

The future runtime implementation should use:

```text
one small GameState ledger extension
one pure selector helper
one PhonePrototype adapter
new day/conversation JSON
one static test module
```

It should not modify:

- global conversation rendering;
- TimelineState lifecycle semantics;
- EffectApplier effect grammar;
- visual-content systems;
- route scoring;
- archive behavior;
- V0.86a clock duration or notification layout.

---

## 25. Validation plan for V0.89

## 25.1 Data validation

```bash
python3 tools/validate_game_data.py
```

Expected:

- all JSON parses;
- unique IDs;
- active paths resolve;
- candidate episode references resolve;
- no new visual-content reference;
- only known informational Chapter 7 warnings remain.

## 25.2 Static tests

```bash
python3 -m unittest \
  tests.test_godot_prototype_static \
  tests.test_v081_wednesday_static \
  tests.test_v082_thursday_static \
  tests.test_v084_temporal_flow_static \
  tests.test_v085_j1_reconciliation_static \
  tests.test_v086_friday_opening_static \
  tests.test_v086a_temporal_ux_static \
  tests.test_v089_first_repetition_static \
  -v
```

New static coverage must verify:

- Friday unlocks Saturday only after completion;
- Saturday unlocks Sunday;
- no Monday index is active yet;
- W9 has exactly three choices;
- MT1 has exactly three choices;
- M3 has exactly three choices;
- no numeric effects in the three new conversations;
- candidate selection returns one or none;
- no second candidate is exposed;
- no external ticket is consumed on expiry;
- no more than one charged owner can be claimed;
- Mathilde remains R1 when R2 gate fails;
- Marie return is required after Mathilde;
- M3B obligation persists as carried state;
- `first_repetition_wave_complete` is absent;
- no new visual asset is referenced;
- no visible offline explanation is introduced;
- active phone adapter preserves V0.86a inheritance;
- voice distinction prevents repeated legal register outside Mathilde.

## 25.3 Player text checks

```bash
python3 tools/player_choice_text_check.py \
  game/data/conversations/chapter_05_marie_shared_hour.json \
  game/data/conversations/chapter_06_mathilde_morning_afterglow.json \
  game/data/conversations/chapter_06_marie_concrete_return.json
```

```bash
python3 tools/player_presence_check.py \
  game/data/conversations/chapter_05_marie_shared_hour.json \
  game/data/conversations/chapter_06_mathilde_morning_afterglow.json \
  game/data/conversations/chapter_06_marie_concrete_return.json
```

## 25.4 Repository and Godot checks

```bash
git diff --check

godot --headless --path game --quit

godot --headless --path game --resolution 1280x720 --quit
```

---

## 26. Manual validation matrix

Test at `Speed x1`.

### Flow A — Marie joined, Mathilde eligible, MT1A reaches R2

```text
Friday completes
-> clock crosses midnight
-> Saturday Marie notification
-> M2A
-> shared hour resolved silently
-> clock crosses to Sunday
-> Mathilde notification
-> MT1A
-> charged_access_owner = mathilde
-> Marie notification
-> M3
-> Sunday closes
```

Checks:

- no blank day card;
- no explicit offline summary;
- no image;
- exactly one external foreground;
- exactly one charged owner;
- Marie consequence occurs before any future opportunity.

### Flow B — Mathilde eligible but R2 gate fails

Use distant/cool opening history.

Expected:

```text
Mathilde scene may still appear
MT1A/MT1B writes soft gaze state
charged_access_owner remains empty
route remains R1
Marie return still occurs
```

### Flow C — Mathilde notification ignored

Expected:

```text
candidate expires
no foreground ticket consumed
scene status = EXPIRED
no R2
Marie return continues
```

### Flow D — Mathilde ineligible

Expected:

```text
no Mathilde notification
no fake filler
candidate status = DEFERRED
clock advances to Marie return
same-thread Marie continuation when appropriate
```

### Flow E — M2C + M3C

Expected:

```text
Marie enjoys Saturday independently
Sunday return becomes due
Player admits non-repair
obligation resolved as FAILED
parallel-drift evidence recorded
couple mode remains HABITUAL_WARMTH
```

### Flow F — M3B

Expected:

```text
next-morning obligation stored as CARRIED
Sunday may complete
Monday remains unavailable
promise is not marked paid
first_repetition_wave_complete remains false
```

---

## 27. Rollback boundary

The first runtime PR must remain squashable as one vertical slice.

Rollback must be possible by reverting one squash commit.

Rollback restores:

```text
DataLoader active indexes through Friday only
Friday next_day = null
PhonePrototype scene -> V086A adapter
no story-ledger first-repetition defaults required
no Saturday/Sunday conversations loaded
```

Existing Tuesday–Friday data and scripts must not require reverse migration.

---

## 28. Implementation order

After V0.88 Product Owner validation:

```text
1. create V0.89 runtime branch from validated main
2. add ledger defaults/helpers
3. add pure selector helper
4. add Saturday/Sunday indexes and three conversations
5. add PhonePrototypeV089 adapter
6. add static tests
7. run executable validation
8. perform manual branch matrix
9. Product Owner review
10. squash merge
```

No dialogue or state meaning may change silently during implementation.

Any implementation constraint that changes the approved story must return to documentation first.

---

## 29. Acceptance criteria for V0.88

V0.88 is ready for validation when:

- the first vertical slice is explicitly bounded;
- Mathilde is justified as the first candidate for fit rather than later erotic value;
- current runtime inventory is accurate;
- ticket, charged owner, obligation, scene status, and cooldown state have one clear home;
- candidate selection is deterministic;
- no route menu is created;
- W9, Mathilde, and W11 map to concrete future files;
- co-presence remains off-chat;
- same-thread and cross-thread behavior reuse V0.86a;
- no new image is required;
- no save system is invented;
- rollback is one squash commit;
- validation covers eligible, ineligible, expired, R1, R2, and carried-obligation paths;
- the plan changes no runtime file.

---

## 30. Final rule

```text
V0.89 should not prove that the whole modular engine exists.

It should prove one honest chain:
Marie creates shared life,
Mathilde becomes a plausible repeated attention,
and the story returns to Marie before opening another possibility.
```
