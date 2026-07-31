#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN="${PYTHON_BIN:-python3}"
"${PYTHON_BIN}" -m unittest \
  tests.test_runtime_s1_10_j10_playable_static \
  tests.test_runtime_s1_11c_j11_foundations_static -v

GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_PROJECT_PATH="${GODOT_PROJECT_PATH:-game}"
"${GODOT_BIN}" --headless --path "${GODOT_PROJECT_PATH}" \
  res://tests/RUNTIME_S1_11CJ11FoundationsSmokeTest.tscn

echo "RUNTIME-S1-11C J11 foundations: OK"
