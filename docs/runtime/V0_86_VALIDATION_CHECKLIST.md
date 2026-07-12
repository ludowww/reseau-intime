# V0.86 — Validation Checklist

## Branch

```text
work/friday-public-traces-opening-completion-v0-86
```

Record the tested SHA before reporting results.

## Automated validation

```bash
python3 tools/validate_game_data.py

python3 -m unittest \
  tests.test_godot_prototype_static \
  tests.test_v081_wednesday_static \
  tests.test_v082_thursday_static \
  tests.test_v084_temporal_flow_static \
  tests.test_v085_j1_reconciliation_static \
  tests.test_v086_friday_opening_static \
  -v

python3 tools/player_choice_text_check.py \
  game/data/conversations/chapter_04_pauline_public_photo_relay.json \
  game/data/conversations/chapter_04_nico_saved_seat_followup.json \
  game/data/conversations/chapter_04_marie_household_report.json \
  game/data/conversations/chapter_04_mathilde_bathroom_correction.json

python3 tools/player_presence_check.py \
  game/data/conversations/chapter_04_pauline_public_photo_relay.json \
  game/data/conversations/chapter_04_nico_saved_seat_followup.json

git diff --check

godot --headless --path game --quit

godot --headless --path game --resolution 1280x720 --quit
```

## Manual walkthrough

- [ ] Only Tuesday is visible after reset.
- [ ] Tuesday, Wednesday, and Thursday still progress as validated in V0.85.
- [ ] Thursday O6 remains mandatory.
- [ ] Thursday completion displays the Friday start card.
- [ ] Friday starts at `08:35` with Pauline only.
- [ ] Pauline displays exactly one authorized public group-photo set.
- [ ] Bastien remains present in the image context.
- [ ] P0 displays exactly three choices.
- [ ] No private alternate, one-view version, or body crop appears.
- [ ] Nico starts at `14:05` after Pauline completion.
- [ ] Nico's opening lines match the Thursday path.
- [ ] N0 displays exactly three choices on every tested topology.
- [ ] The Mathilde-stay echo remains practical and non-sexualized.
- [ ] Marie and Mathilde unlock together at `18:05` in separate threads.
- [ ] Mathilde does not create a second notification banner.
- [ ] Both household echoes must complete before the closing beat.
- [ ] The `18:25` household close is offline and appears once.
- [ ] Friday writes `household_rhythm_confirmed` and `opening_band_complete`.
- [ ] Friday becomes read-only after completion.
- [ ] No later day appears.

## Report format

```text
Branch:
SHA:
Git status:

Files changed locally:

Automated validations:

Manual walkthrough:

Warnings:
```
