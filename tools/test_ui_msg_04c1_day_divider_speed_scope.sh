#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SCENE="res://tests/UI_MSG_04C1DayDividerSpeedScopeSmokeTest.tscn"

python3 "$ROOT/tests/test_ui_msg_04c1_day_divider_speed_scope_static.py"
godot --headless --path "$ROOT/game" "$SCENE"
