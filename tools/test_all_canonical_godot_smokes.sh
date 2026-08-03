#!/usr/bin/env bash
set -euo pipefail

GODOT_BIN="${GODOT_BIN:-godot}"
GODOT_PROJECT_PATH="${GODOT_PROJECT_PATH:-game}"
resolution="${SMOKE_RESOLUTION:-720x1280}"
count=0

for scene_path in "${GODOT_PROJECT_PATH}"/tests/*SmokeTest.tscn; do
  scene_name="$(basename "${scene_path}")"
  scene="res://tests/${scene_name}"
  case "${scene_name}" in
    T_UI_*)
      "${GODOT_BIN}" --headless --quit-after 1200 --path "${GODOT_PROJECT_PATH}" \
        --resolution "${resolution}" "${scene}" -- \
        "--demo-size=${resolution}" "--safe-area=none" "--reduced-motion=true"
      ;;
    RUNTIME_*)
      "${GODOT_BIN}" --headless --quit-after 1200 --path "${GODOT_PROJECT_PATH}" \
        --resolution "${resolution}" "${scene}" -- "--runtime-size=${resolution}"
      ;;
    VisualDeliveryPipelineSmokeTest.tscn)
      "${GODOT_BIN}" --headless --quit-after 1200 --path "${GODOT_PROJECT_PATH}" \
        --resolution 1280x720 "${scene}"
      ;;
    *)
      "${GODOT_BIN}" --headless --quit-after 1200 --path "${GODOT_PROJECT_PATH}" "${scene}"
      ;;
  esac
  count=$((count + 1))
done

echo "CANONICAL_GODOT_SMOKES=${count}/${count}: OK"
