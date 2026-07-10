# Narrative Canon Status — Current

> Consolidated narrative and implementation status after V0.80 runtime audit.  
> V0.80 changes documentation only. Current runtime remains the pre-modular prototype until V0.81 is implemented and validated.

## 1. Core rule

```text
V0.78 defines how the modular story moves.
V0.79 defines the first authored opening.
V0.80 defines the smallest safe runtime integration path.
Existing runtime is not automatic narrative canon.
```

## 2. Current canon and plan stack

Read:

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/CHOICE_DESIGN_CANON.md
docs/canon/MODULAR_NARRATIVE_ARC_BLUEPRINT.md
docs/canon/MODULAR_SCENE_AUTHORING_CONTRACT.md
docs/canon/DIEGETIC_TIME_AND_COMMUNICATION_CANON.md
docs/canon/ACT_I_OPENING_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_OPENING_SCENE_CARDS.md
docs/canon/ACT_I_OPENING_TEMPORAL_DELIVERY_MAP.md
docs/runtime/V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
docs/V0_80_First_Modular_Runtime_Integration_Plan.md
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
```

Then read relevant character canon and the global NSFW canon when needed.

## 3. J1 narrative status

Current narrative truth:

```text
J1 — Les choses qu'on remarque
Tuesday evening
couple mode = HABITUAL_WARMTH
```

J1 should establish:

- Marie and Player still warm and together;
- differences in Player's presence;
- Sandra's soft trace;
- Mathilde indirect only;
- no active Nico, Pauline, Raphaëlle, or Mathilde thread;
- no route lock, hard secret, adult frame, or changed relationship agreement.

### Current runtime handoff mismatch

The playable J1 still contains a deprecated Mathilde domestic trace:

- bags already in the entrance;
- shoes / sport bag / racket;
- wording suggesting she is already installed;
- `j1_mathilde_bag_domestic_trace`.

This conflicts with the V0.79 Wednesday water-damage arrival.

V0.81 must remove only that handoff contradiction and may restore the validated V0.69 indirect installation/light seed.

The wider J1 story remains outside the V0.81 rewrite scope.

## 4. V0.79 opening narrative status

V0.79 is canonically written but not yet playable.

Calendar:

```text
Tuesday evening = J1
Wednesday = Mathilde emergency and arrival
Thursday = work, Marie event topology, and couple return
Friday = Pauline/Nico public residue and household breather
```

Windows:

```text
O0 J1 carry-over
O1 make room
O2 Mathilde arrival
O3 Raphaëlle work + Sandra echo
O4 Marie offers movement
O5 selected topology foreground
O6 mandatory return to Marie
O7 Pauline public image relay
O8 Nico follow-up + household breather
```

At the end of the complete opening:

- Mathilde, Raphaëlle, Pauline, and Nico reach R1 ordinary access;
- Sandra remains active or cooled;
- no hard secret or adult frame exists;
- the couple remains `HABITUAL_WARMTH` with only reconnection/drift candidates.

## 5. Current runtime architecture status

### Reusable

The prototype already supports:

- persistent contact threads;
- separate episodes merged into one thread;
- segmented conversations and history;
- choices and guided replies;
- sequential unlocks and notifications;
- message timestamps;
- flags/effects;
- visual placeholder cards.

### Missing for full V0.79

The prototype does not yet support:

- choice-conditioned unlocks;
- conditional message/segment variants;
- semantic offline beats;
- data-driven weekday/status time;
- filtering suspended legacy days from current navigation.

### Current active-runtime problem

`DataLoader.gd` loads legacy indexes through Chapter 9, and `PhonePrototype.gd` renders them as selectable days.

A new Wednesday cannot safely coexist with those old continuations as current story.

## 6. Approved implementation decomposition

### V0.81 — Tuesday handoff + Wednesday vertical slice

Implement:

- narrow J1 Mathilde handoff correction;
- active Tuesday/Wednesday labels;
- data-driven narrative time;
- O1 Marie make-room with M0;
- O2 Marie arrival trace;
- O2 Mathilde arrival with MT0;
- one arrival visual;
- semantic `offline_beat`;
- flags only;
- active Chapter 1–2 index whitelist;
- targeted tests.

Do not implement Thursday or Friday.

### V0.82 — Thursday topology and Marie return

After V0.81 validation:

- add condition-aware unlocks;
- add conditional authored content;
- implement O3–O6;
- guarantee exactly one O5 branch;
- guarantee O6 return to Marie.

### V0.83 — Friday opening completion

After V0.82 validation:

- implement Pauline public photo relay;
- implement Nico saved-seat follow-up;
- implement household breather;
- verify final V0.79 opening state.

## 7. V0.81 state and route ceiling

V0.81 uses event flags only:

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

It must not add:

- route scores;
- desire/attachment points;
- couple-mode transitions;
- hidden secrets;
- adult permissions;
- dominant-route state.

Route ceiling:

```text
R0 -> Mathilde R1 ordinary access only
```

## 8. Time and communication status

Core rule:

```text
If characters are co-present and can talk,
they do not conduct a long Messenger conversation.
```

V0.81 must prove:

- Tuesday/Wednesday labels;
- midday-to-evening progression;
- dynamic status time;
- arrival trace while Player is still away;
- messaging stops when Player returns;
- offline settling is represented as an authored `offline_beat`, not a character bubble.

## 9. Legacy runtime status

The following remain on disk but are narratively suspended:

```text
old chapter_02 conversations
chapter_03–chapter_09 indexes and conversations
old J2 visual placeholders
old route-score simulation assumptions
```

For V0.81, only Chapter 1 and rewritten Chapter 2 should be active in the loader.

Legacy files are retained for rollback/history and must not be deleted in the first slice.

## 10. Choice status

Default:

```text
3 choices per node
```

V0.81 implements:

```text
M0  — quality of making room
MT0 — quality of welcoming Mathilde
```

No four-choice exception.

Player dialogue remains choice-driven, never auto-rendered as prewritten Player messages.

## 11. Validation status

A future V0.81 PR must run:

```text
validate_game_data
static unittest suite
choice-text check
player-presence check
legacy route simulation as regression only
git diff --check
Godot headless boot checks
```

Tests protecting deprecated active-day, visual, and hardcoded-clock assumptions must be updated narrowly.

## 12. Runtime authorization boundary

V0.80 authorizes no code change by itself.

After Product Owner validation, Hermes/Codex may implement only the scope in:

```text
docs/runtime/V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
```

Any discovered constraint requiring story changes must return to documentation review before implementation continues.

## 13. Current roadmap

```text
V0.80 — First Modular Runtime Integration Plan
V0.81 — Tuesday handoff + Wednesday vertical slice
V0.82 — Thursday topology and Marie return
V0.83 — Friday traces and opening completion
```

## 14. Final rule

```text
Narrative canon is ready through Friday.
Runtime should first prove only Tuesday -> Wednesday.
A validated small slice is more valuable than a speculative universal system.
```
