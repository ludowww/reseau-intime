#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

for scenario in A B C D E F G H I; do
  echo "=== V0.92 runtime smoke ${scenario} ==="
  godot --headless --path game res://tests/V092RuntimeSmokeTest.tscn -- "--scenario=${scenario}"
done

echo "V0.92 runtime smoke: OK (A-I)"
