# Runtime Documentation Index

Read the canonical entry point first:

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
```

## Current implemented runtime documents

```text
V0_80_RUNTIME_AUDIT_AND_GAP_MAP.md
V0_81_WEDNESDAY_VERTICAL_SLICE_IMPLEMENTATION_PLAN.md
V0_82_THURSDAY_TOPOLOGY_IMPLEMENTATION_PLAN.md
V0_84_DAY_AND_MOMENT_FLOW_IMPLEMENTATION_PLAN.md
V0_85_J1_CANON_RUNTIME_RECONCILIATION_PLAN.md
V0_86_FRIDAY_PUBLIC_TRACES_IMPLEMENTATION_PLAN.md
V0_86_VALIDATION_CHECKLIST.md
V0_86A_TEMPORAL_UX_NOTIFICATION_POLISH_PLAN.md
```

Related implementation reports:

```text
docs/V0_86_Friday_Public_Traces_And_Opening_Completion_Report.md
docs/V0_86A_Temporal_UX_Notification_Polish_Report.md
```

## Current documentation-only progression

V0.87 authored sources:

```text
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SOURCE_PACK.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_SCENE_CARDS.md
docs/canon/ACT_I_FIRST_REPETITION_WINDOWS_TEMPORAL_DELIVERY_MAP.md
docs/V0_87_Next_Act_I_Windows_Source_Pack_Report.md
```

Voice distinction:

```text
docs/canon/CHARACTER_VOICE_DISTINCTION_CANON.md
```

Fulfilled V0.88 boundary note:

```text
V0_88_FIRST_REPETITION_RUNTIME_PREPARATION_NOTE.md
```

Current integration plan:

```text
V0_88_FIRST_REPETITION_RUNTIME_INTEGRATION_PLAN.md
docs/V0_88_First_Repetition_Runtime_Integration_Plan_Report.md
```

## Runtime status after V0.86 + V0.86a

```text
Tuesday–Friday opening implemented
conversation-side fixed time / Wi-Fi / battery strip
2-second pause + 4-second accelerated clock
compact 10-character notification shortcut for another thread
same-thread episodes resume directly without a notification banner
external notifications preserve transcript bottom and use insertion flash
strong unread-contact styling
no explanatory empty-choice hint
no active text-only timeline landing pages
no visible or archived Moments hors ligne section
opening_band_complete = true
runtime route ceiling = R1
```

Offline phases may still apply internal continuity flags and records, but their explanatory text is not player-facing.

No Saturday, Sunday, or Monday content is currently loaded.

## V0.87 documented wave

```text
W9  Marie shared hour
W10 weekend external opportunity
W11 mandatory Marie return
W12 first-workday external opportunity
W13 wave close / couple balance
```

Budget:

```text
maximum 2 external foreground tickets
maximum 1 charged-access owner
Pauline remains R1
Nico remains R1
Mathilde / Sandra / Raphaëlle may reach R2 at most after future integration
```

V0.87 does not change runtime.

## V0.88 planning result

The first planned runtime slice is:

```text
Saturday W9 Marie shared hour
-> Sunday Mathilde morning candidate or silent defer
-> Sunday W11 Marie concrete return
```

The plan chooses Mathilde because the household state and persistent thread already exist and because the scene tests candidate selection, expiry, R1/R2 gating, and Marie consequence without a new image or social hub.

Planned state structure:

```text
story_ledgers.first_repetition
```

It will hold:

- external foreground history;
- one charged-access owner;
- scene lifecycle;
- cooldowns;
- structured obligations.

Chronology remains in `TimelineState`.

Observable branch facts remain flat flags.

## Next milestone

```text
V0.89 — First Repetition Vertical Slice
```

V0.89 may implement only:

```text
W9 Marie
+ Mathilde candidate
+ W11 Marie return
```

It must not add Sandra, Raphaëlle, Pauline, Nico, the second external ticket, or the complete wave in the same PR.

## V0.89 validation boundary

Expected executable validation:

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
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

The implementation must also run the Player-choice and Player-presence tools on the three new conversation files.

Older runtime plans remain historical evidence of the phased integration path and must not override current canon/status files.
