#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m unittest tests.test_runtime_s1_03c_universal_message_pacing_static -v
SCENARIO_COUNT=0
for resolution in 540x960 720x1280 1080x1920; do
  SCENARIO_COUNT=$((SCENARIO_COUNT + 1))
  echo "=== RUNTIME-S1-03C ${resolution} ==="
  godot --headless --path game --resolution "${resolution}" \
    res://tests/RUNTIME_S1_03CUniversalMessagePacingSmokeTest.tscn -- "--runtime-size=${resolution}"
done
test "${SCENARIO_COUNT}" -eq 3
echo "SCENARIO_COUNT=${SCENARIO_COUNT}"
echo "RUNTIME-S1-03C universal message pacing: OK"
