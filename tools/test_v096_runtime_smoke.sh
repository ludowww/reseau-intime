#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

for scenario in A B C D E F G H I; do
  echo "=== V0.96 runtime smoke ${scenario} ==="
  godot --headless --path game res://tests/V096RuntimeSmokeTest.tscn -- "--scenario=${scenario}"
done

echo "V0.96 runtime smoke: OK (A-I)"
