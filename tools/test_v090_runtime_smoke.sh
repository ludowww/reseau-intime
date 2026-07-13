#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

for scenario in A B C D E F G H I; do
  echo "=== V0.90 runtime smoke ${scenario} ==="
  godot --headless --path game res://tests/V090RuntimeSmokeTest.tscn -- "--scenario=${scenario}"
done

echo "V0.90 runtime smoke: OK (A-I)"
