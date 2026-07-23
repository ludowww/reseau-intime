#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

SCENARIO_COUNT=0
for resolution in 720x1280 1080x1920 1080x2340; do
  for safe_area in none tall-portrait; do
    for reduced_motion in true false; do
      SCENARIO_COUNT=$((SCENARIO_COUNT + 1))
      echo "=== T-UI-03A ${resolution} / ${safe_area} / reduced=${reduced_motion} ==="
      godot --headless \
        --path game \
        --resolution "${resolution}" \
        res://tests/T_UI_03AGalleryCoreSmokeTest.tscn \
        -- \
        "--demo-size=${resolution}" \
        "--safe-area=${safe_area}" \
        "--reduced-motion=${reduced_motion}"
    done
  done
done

test "${SCENARIO_COUNT}" -eq 12
echo "SCENARIO_COUNT=${SCENARIO_COUNT}"
echo "T-UI-03A Gallery Core matrix: OK"
