#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

for scenario in A B C D E F G H I J K L M N; do
  echo "=== V0.96a contact navigation smoke ${scenario} ==="
  godot --headless --path game res://tests/V096AContactNavigationSmokeTest.tscn -- "--scenario=${scenario}"
done

echo "V0.96a contact navigation smoke: OK (A-N)"
