#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
godot --headless --path game res://tests/V090RuntimeSmokeTest.tscn
