#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN="${PYTHON_BIN:-python3}"
"${PYTHON_BIN}" -m unittest tests.test_runtime_s1_06_j06_playable_static -v

GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_PROJECT_PATH="${GODOT_PROJECT_PATH:-game}"
CAPTURE_DIR="${CAPTURE_DIR:-}"

for resolution in 540x960 720x800 720x960 720x1280 1080x1920 1080x2340 1280x720; do
  args=("--runtime-size=${resolution}")
  if [[ -n "${CAPTURE_DIR}" ]]; then
    args+=("--capture-dir=${CAPTURE_DIR}")
  fi
  "${GODOT_BIN}" --headless --path "${GODOT_PROJECT_PATH}" --resolution "${resolution}" \
    res://tests/RUNTIME_S1_06J06PlayableSmokeTest.tscn -- "${args[@]}"
done

echo "RUNTIME-S1-06 J06 playable: OK"
