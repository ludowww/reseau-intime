#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

for resolution in 720x1280 1080x1920 1080x2340; do
  for safe_area in none tall-portrait; do
    for reduced_motion in true false; do
      echo "=== T-UI-02B1 ${resolution} / ${safe_area} / reduced=${reduced_motion} ==="
      godot --headless \
        --path game \
        --resolution "${resolution}" \
        res://tests/T_UI_02B1UnreadNotificationSmokeTest.tscn \
        -- \
        "--demo-size=${resolution}" \
        "--safe-area=${safe_area}" \
        "--reduced-motion=${reduced_motion}"
    done
  done
done

echo "T-UI-02B1 unread notification smoke matrix: OK"
