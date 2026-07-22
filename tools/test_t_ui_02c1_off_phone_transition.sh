#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

count=0
for resolution in 720x1280 1080x1920 1080x2340; do
  for safe_area in none tall-portrait; do
    for reduced_motion in true false; do
      echo "=== T-UI-02C1 ${resolution} / ${safe_area} / reduced=${reduced_motion} ==="
      godot --headless \
        --path game \
        --resolution "${resolution}" \
        res://tests/T_UI_02C1OffPhoneTransitionSmokeTest.tscn \
        -- \
        "--demo-size=${resolution}" \
        "--safe-area=${safe_area}" \
        "--reduced-motion=${reduced_motion}"
      count=$((count + 1))
    done
  done
done

[[ "$count" -eq 12 ]]
echo "T-UI-02C1 off-phone transition smoke matrix: ${count}/12 OK"
