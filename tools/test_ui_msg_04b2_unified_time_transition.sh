#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 tests/test_ui_msg_04b2_unified_time_transition_static.py
SCENARIO_COUNT=0
for resolution in 540x960 720x800 720x960 720x1280 1080x1920; do
  for safe_area in none tall-portrait; do
    SCENARIO_COUNT=$((SCENARIO_COUNT + 1))
    godot --headless --path game --resolution "${resolution}" \
      res://tests/UI_MSG_04B2UnifiedTimeTransitionSmokeTest.tscn -- \
      "--runtime-size=${resolution}" "--safe-area=${safe_area}"
  done
done
test "${SCENARIO_COUNT}" -eq 10
printf 'SCENARIO_COUNT=%s\nUI-MSG-04B2 unified time transition: OK\n' "${SCENARIO_COUNT}"
