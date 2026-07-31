#!/usr/bin/env bash
set -euo pipefail

PYTHON_BIN="${PYTHON_BIN:-python3}"
"${PYTHON_BIN}" -m unittest tests.test_runtime_s1_12_j12_playable_static -v

GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_PROJECT_PATH="${GODOT_PROJECT_PATH:-game}"
"${GODOT_BIN}" --headless --path "${GODOT_PROJECT_PATH}" res://tests/RUNTIME_S1_12J12PlayableSmokeTest.tscn

echo "RUNTIME-S1-12 J12 playable: OK"
