#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m unittest tests.test_runtime_s1_05_j05_playable_static -v
GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_PROJECT_PATH="${GODOT_PROJECT_PATH:-game}"
SCENARIO_COUNT=0
for resolution in 540x960 720x800 720x960 720x1280 1080x1920 1080x2340 1280x720; do
  SCENARIO_COUNT=$((SCENARIO_COUNT + 1))
  echo "=== RUNTIME-S1-05 ${resolution} ==="
  "${GODOT_BIN}" --headless --path "${GODOT_PROJECT_PATH}" --resolution "${resolution}" res://tests/RUNTIME_S1_05J05PlayableSmokeTest.tscn -- "--runtime-size=${resolution}"
done
test "${SCENARIO_COUNT}" -eq 7
echo "SCENARIO_COUNT=${SCENARIO_COUNT}"
echo "RUNTIME-S1-05 J05 playable: OK"
