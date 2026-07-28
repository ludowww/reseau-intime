#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCENE="res://tests/UI_MSG_04CInteractiveNotificationSmokeTest.tscn"

python3 "$ROOT/tests/test_ui_msg_04c_interactive_notification_static.py"

for size in 540x960 720x800 720x960 720x1280 1080x1920 1080x2340 1280x720; do
  godot --headless --path "$ROOT/game" --resolution "$size" "$SCENE" -- --runtime-size="$size" --safe-area=none
done
