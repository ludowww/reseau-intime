#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

for resolution in 720x1280 1080x1920 1080x2340 1280x720; do
  for safe_area in none top-notch bottom-reserved tall-portrait; do
    echo "=== T-UI-01A portrait shell ${resolution} / ${safe_area} ==="
    godot --headless --path game --resolution "${resolution}" res://tests/T_UI_01PortraitShellSmokeTest.tscn -- "--safe-area=${safe_area}" "--demo-size=${resolution}"
  done
done

echo "T-UI-01A portrait shell smoke: OK"
