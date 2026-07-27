#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
python3 -m unittest tests.test_ui_msg_04a_conversation_header_responsive_static -v
SCENARIO_COUNT=0
for resolution in 540x960 720x800 720x960 720x1280 1080x1920; do
  for safe_area in none tall-portrait; do
    SCENARIO_COUNT=$((SCENARIO_COUNT + 1))
    echo "=== UI-MSG-04A ${resolution} ${safe_area} ==="
    godot --headless --path game --resolution "${resolution}" \
      res://tests/UI_MSG_04AConversationHeaderResponsiveSmokeTest.tscn -- \
      "--runtime-size=${resolution}" "--safe-area=${safe_area}"
  done
done
test "${SCENARIO_COUNT}" -eq 10
echo "SCENARIO_COUNT=${SCENARIO_COUNT}"
echo "UI-MSG-04A conversation header responsive: OK"
