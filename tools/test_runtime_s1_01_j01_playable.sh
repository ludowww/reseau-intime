#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m unittest tests.test_runtime_s1_01_j01_playable_static -v
SCENARIO_COUNT=0
for resolution in 720x1280 1080x1920; do
  SCENARIO_COUNT=$((SCENARIO_COUNT + 1))
  echo "=== RUNTIME-S1-01 ${resolution} ==="
  godot --headless --path game --resolution "${resolution}" \
    res://tests/RUNTIME_S1_01J01PlayableSmokeTest.tscn -- "--runtime-size=${resolution}"
done
test "${SCENARIO_COUNT}" -eq 2
echo "SCENARIO_COUNT=${SCENARIO_COUNT}"
echo "RUNTIME-S1-01 J01 playable: OK"
