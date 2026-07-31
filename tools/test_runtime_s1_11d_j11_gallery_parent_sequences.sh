#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

PYTHON_BIN="${PYTHON_BIN:-python3}"
"${PYTHON_BIN}" -m unittest \
  tests.test_t_ui_03a_gallery_core_static \
  tests.test_t_ui_03c_photo_viewer_static \
  tests.test_t_ui_03d_gallery_states_static \
  tests.test_runtime_s1_11c_j11_foundations_static \
  tests.test_runtime_s1_11d_j11_gallery_parent_sequences_static -v

GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_PROJECT_PATH="${GODOT_PROJECT_PATH:-game}"
"${GODOT_BIN}" --headless --path "${GODOT_PROJECT_PATH}" \
  res://tests/RUNTIME_S1_11DGalleryParentSequencesSmokeTest.tscn
"${GODOT_BIN}" --headless --path "${GODOT_PROJECT_PATH}" \
  res://tests/T_UI_03CPhotoViewerSmokeTest.tscn

echo "RUNTIME-S1-11D J11 gallery parent sequences: OK"
