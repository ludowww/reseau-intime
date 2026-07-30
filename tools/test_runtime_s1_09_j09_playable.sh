#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN="${PYTHON_BIN:-python3}"
"${PYTHON_BIN}" -m unittest tests.test_runtime_s1_09_j09_playable_static -v

GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_PROJECT_PATH="${GODOT_PROJECT_PATH:-game}"
CAPTURE_DIR="${CAPTURE_DIR:-}"

for resolution in 540x960 720x800 720x960 720x1280 1080x1920 1080x2340 1280x720; do
  args=("--runtime-size=${resolution}")
  display_args=("--headless")
  if [[ -n "${CAPTURE_DIR}" ]] && [[ "${resolution}" == "720x1280" || "${resolution}" == "1280x720" ]]; then
    args+=("--capture-dir=${CAPTURE_DIR}")
    display_args=()
  fi
  "${GODOT_BIN}" "${display_args[@]}" --path "${GODOT_PROJECT_PATH}" --resolution "${resolution}" \
    res://tests/RUNTIME_S1_09J09PlayableSmokeTest.tscn -- "${args[@]}"
done

echo "RUNTIME-S1-09 J09 playable: OK"
