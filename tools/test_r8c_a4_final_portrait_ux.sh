#!/usr/bin/env bash
set -euo pipefail

GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_PROJECT_PATH="${GODOT_PROJECT_PATH:-game}"

"${GODOT_BIN}" --headless --path "${GODOT_PROJECT_PATH}" --resolution 720x1280 \
  res://tests/RUNTIME_S1_01J01PlayableSmokeTest.tscn -- --runtime-size=720x1280
"${GODOT_BIN}" --headless --path "${GODOT_PROJECT_PATH}" --resolution 720x1280 \
  res://tests/RUNTIME_S1_09J09PlayableSmokeTest.tscn -- --runtime-size=720x1280
"${GODOT_BIN}" --headless --path "${GODOT_PROJECT_PATH}" --resolution 720x1280 \
  res://tests/R8CA4FinalPortraitUXSmokeTest.tscn

echo "R8C-A4 final PortraitMain UX J01/J09/J12/J15/J21: OK"
