# Roadmap

## 1. Project rules

```text
Engine: Godot 4.6.x
Workflow: documentation validated before runtime
Choices: 3 maximum by default
PRs: short, targeted, squashable
Runtime refactors: local and justified only
```

Central question:

```text
Can Player and Marie make their couple an active choice again?
```

## 2. Completed canon and runtime milestones

```text
V0.65  consolidated documentation canon
V0.66  full character files
V0.67  global NSFW canon
V0.68  narrative reconciliation
V0.69  canonical J1 text
V0.70  3-choice default
V0.71  J1 runtime plan
V0.72  J1 runtime alignment
V0.73  Mathilde full concrete + NSFW canon
V0.74  Pauline full concrete + double-life canon
V0.75  Nico full concrete + voyeur/photo correction
V0.76  Raphaëlle full concrete + chosen-version canon
V0.77  supporting-character policy
V0.78  modular narrative arc blueprint
V0.79  Tuesday–Friday opening source pack
V0.80  phased runtime audit and integration plan
V0.81  Wednesday vertical slice
V0.82  Thursday topology and Marie return
V0.83  temporal-flow canon and J1 reconciliation
V0.84  authoritative runtime days/phases
V0.85  reconciled active Tuesday
V0.86  Friday public traces and opening completion
V0.86a smartphone time, notifications, unread state, and hidden offline exposition
V0.87  first repetition windows source pack + voice-distinction canon
```

## 3. Current implemented runtime

Playable content:

```text
Tuesday
Wednesday
Thursday
Friday
```

Initial access:

```text
Tuesday active
Wednesday locked
Thursday locked
Friday locked
```

Current phone-time behavior:

```text
last message
-> contact offline
-> 2-second pause
-> clock advances for 4 seconds at Speed x1
-> compact notification for another thread
```

Same-thread continuation resumes directly without a redundant notification.

Current endpoint:

```text
opening_band_complete = true
Friday evening
```

Runtime state:

```text
Marie/Player = HABITUAL_WARMTH
relationship frame = ASSUMED_EXCLUSIVE
Sandra = soft trace / ordinary continuity
Mathilde = R1 household access
Raphaëlle = R1 work access
Pauline = R1 social/public access
Nico = R1 friendship/social access
hard secrets = none
adult frames = none
routes R2+ = none
```

No Saturday, Sunday, or Monday content is currently loaded.

## 4. V0.87 authorized narrative wave

```text
W9  Marie claims one shared hour
W10 weekend repetition opportunity
W11 mandatory Marie return
W12 first-workday repetition opportunity
W13 wave close / couple balance
```

Wave limits:

```text
maximum 2 external foreground tickets
maximum 1 charged-access owner
same character cannot consume both tickets
Marie consequence outranks a new external opportunity
quiet windows are valid
```

Character ceilings:

```text
Mathilde = R1 or R2 at most
Sandra = R1 or R2 at most
Raphaëlle = R1 or R2 at most
Pauline = R1
Nico = R1
```

Only one of Mathilde, Sandra, or Raphaëlle may own first charged access.

No hard secret, adult image, adult frame, R3+, or relationship-frame change is authorized.

## 5. Current milestone — V0.88

```text
V0.88 — First Repetition Runtime Integration Plan
```

Status:

```text
documentation only
runtime unchanged
```

Approved planning slice:

```text
Saturday W9 Marie shared hour
-> Sunday Mathilde morning candidate or silent defer
-> Sunday W11 Marie concrete return
```

Mathilde is selected because:

- the stay and household state already exist;
- her persistent thread already exists;
- no image is required;
- the scene tests context selection, expiry, R1/R2 gating, and couple return;
- Marie/family trust remains central;
- the choice is based on implementation fit, not later erotic priority.

## 6. V0.88 state architecture

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

Separation of concerns:

```text
TimelineState = chronology
GameState story ledger = wave state
flat flags = observable branch facts
index data = authored limits and candidate order
```

Candidate selection is deterministic and returns one episode or none.

No random scheduler or character-selection menu is planned.

## 7. Planned V0.89 vertical slice

Future implementation files are expected to add:

```text
Saturday index + Marie W9 conversation
Sunday index + Mathilde opportunity + Marie W11 return
FirstRepetitionSelector.gd
PhonePrototypeV089.gd
story-ledger defaults/helpers
one static test module
```

The first implementation must not add:

- Sandra;
- Raphaëlle;
- Pauline;
- Nico;
- the second external ticket;
- the complete W12/W13 wave;
- new images;
- adult content;
- a full save system.

The slice ends with:

```text
first_repetition_slice_01_complete = true
first_repetition_wave_complete = false / absent
```

Monday remains unavailable.

## 8. Voice requirement

Current source:

```text
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
```

Runtime authoring must preserve:

```text
Marie = shared life, movement, food, practical humor
Mathilde = speed, correction, bad faith, image + limited legal seasoning
Player = short, dry, observant, imperfect action
```

Legal-register jokes must not spread from Mathilde to the rest of the cast.

## 9. Validation requirement for V0.89

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
  -v
python3 tools/player_choice_text_check.py <three new conversation files>
python3 tools/player_presence_check.py <three new conversation files>
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Manual validation must cover:

- Mathilde eligible and R2;
- Mathilde eligible but R1;
- Mathilde notification expired;
- Mathilde ineligible / silent defer;
- Marie immediate return;
- Marie bounded carried promise;
- honest non-repair;
- no blank interstitial or visible offline explanation.

## 10. Official sequence

```text
V0.87  First Repetition Windows Source Pack        merged
V0.88  First Repetition Runtime Integration Plan   current documentation milestone
V0.89  Marie -> Mathilde -> Marie vertical slice   next after validation
V0.90+ remaining candidate pools in small PRs
```

## 11. Permanent guardrails

- documentation before runtime;
- consequences before new temptation;
- one foreground per window;
- no route menu;
- three choices by default;
- time and physical context are hard conditions;
- co-presence is not converted into fake Messenger dialogue;
- images keep origin, audience, and permission;
- no visible `Moments hors ligne` exposition;
- character voice remains distinct;
- no large refactor before a proven slice;
- rollback remains one squash commit.

## 12. Final direction

```text
V0.86 proved ordinary access.
V0.87 defined how repetition may acquire charge.
V0.88 selects the smallest honest runtime proof.
V0.89 may implement only that proof.
```
