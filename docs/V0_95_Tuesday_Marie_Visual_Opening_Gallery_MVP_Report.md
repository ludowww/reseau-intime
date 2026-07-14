# V0.95 — Tuesday Marie Visual Opening + Gallery MVP — Implementation Report

> Runtime implementation branch from locked V0.94.
> This report describes the branch state before local Godot validation and Product Owner visual approval.

## Baseline

```text
base: 12f7360263a65c92cf3cce14760a0fef75bd4517
tag: v0.94-visual-first-named-boundaries-runtime-integration-plan
branch: work/tuesday-marie-gallery-mvp-v0-95
```

## Implemented scope

```text
day 8 Tuesday local endpoint
Marie black-dress conversation
three individually unlockable Marie visuals
actual TextureRect rendering from asset_path
Gallery MVP backed by GameState.unlocked_content
three-slot VisualDayContract
named_boundaries_wave ledger initialization
one M4 obligation
static tests
runtime smoke A–I
```

## Visual assets

The branch includes three distinct prototype illustrations:

```text
marie_tuesday_black_dress_mirror_01
marie_tuesday_black_dress_turn_02
marie_tuesday_black_dress_close_03
```

They are real PNG textures and not missing-file fallback cards.

They remain marked:

```text
asset_status = PROTOTYPE
```

Technical validation can prove rendering and gallery behavior.
Product lock still requires manual visual QA against the desired elegant, sexy, photographic direction.

## Runtime boundary

Monday hands off to day 8 through `PhonePrototypeV095.gd`.

Day 8 ends locally:

```text
next_day = null
named_boundaries_slice_01_complete = true
```

Wednesday is not implemented or unlocked.

## M4 outcomes

```text
join Marie at La Verrière and leave together
take responsibility for the L'Annexe table and arrive at 20:45
let Marie attend independently and reserve Thursday private continuation
```

Each branch schedules one structured obligation in:

```text
story_ledgers.named_boundaries_wave.obligations
```

The historical `story_ledgers.first_repetition` is never reset or rewritten.

## Validation status

Not run in this GitHub-only authoring session.

Required local validation:

```bash
python3 tools/validate_game_data.py
python3 -m unittest tests.test_v095_marie_visual_opening_static -v
python3 -m unittest tests.test_godot_prototype_static -v
bash tools/test_v095_runtime_smoke.sh
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Manual QA must confirm:

- all three images render inside the thread;
- each opens in Gallery detail;
- Gallery survives thread switching;
- image 1, 2 and 3 are visibly distinct;
- the visual direction is strong enough for product approval;
- Tuesday cannot close with one image missing;
- reset clears the new Tuesday state;
- Monday history remains unchanged.
