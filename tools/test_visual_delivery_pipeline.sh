#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

godot --headless \
  --path game \
  --import

godot --headless \
  --path game \
  --resolution 1280x720 \
  res://tests/VisualDeliveryPipelineSmokeTest.tscn

echo "VISUAL DELIVERY PIPELINE smoke: OK"
