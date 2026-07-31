#!/usr/bin/env bash
set -euo pipefail
PYTHON_BIN="${PYTHON_BIN:-python3}"
"${PYTHON_BIN}" -m unittest tests.test_runtime_s1_13_j13_playable_static -v
GODOT_BIN="${GODOT_BIN:-godot}"
"${GODOT_BIN}" --headless --path "${GODOT_PROJECT_PATH:-game}" res://tests/RUNTIME_S1_13J13PlayableSmokeTest.tscn
echo "RUNTIME-S1-13 J13 playable: OK"
