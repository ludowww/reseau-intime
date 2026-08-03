#!/usr/bin/env python3
"""Lint the non-canonical A3 fixture and optionally run its canonical Godot smoke."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import subprocess
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
FIXTURE_PATH = ROOT / "game/tests/fixtures/r8c_a3_minimal_scene_definitions.json"
FORBIDDEN_ACCUMULATORS = {
    "route_points",
    "consent_score",
    "attraction_score",
    "passive_signals",
}


def load_fixture() -> dict[str, Any]:
    return json.loads(FIXTURE_PATH.read_text(encoding="utf-8"))


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def _reject_forbidden_keys(value: Any, path: str = "fixture") -> None:
    if isinstance(value, dict):
        for key, child in value.items():
            normalized = str(key).casefold()
            _require(
                normalized not in FORBIDDEN_ACCUMULATORS and not normalized.endswith("_score"),
                f"forbidden accumulator key at {path}.{key}",
            )
            _reject_forbidden_keys(child, f"{path}.{key}")
    elif isinstance(value, list):
        for index, child in enumerate(value):
            _reject_forbidden_keys(child, f"{path}[{index}]")


def lint_fixture(fixture: dict[str, Any] | None = None) -> int:
    data = fixture if fixture is not None else load_fixture()
    _require(data.get("statut_contenu") == "FIXTURE_NON_CANONIQUE", "fixture must remain non-canonical")
    _reject_forbidden_keys(data)
    definitions = data.get("definitions", {})
    _require(isinstance(definitions, dict) and definitions, "fixture definitions missing")
    _require(all(isinstance(definition, dict) for definition in definitions.values()), "invalid scene definition type")
    return len(definitions)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--godot", type=Path, help="Godot console executable used to run the canonical A3 smoke")
    args = parser.parse_args()
    try:
        definition_count = lint_fixture()
    except (OSError, json.JSONDecodeError, ValueError) as exc:
        print(f"FIXTURE LINT FAILED: {exc}")
        return 1
    print("R8C-A3 NON-CANONICAL FIXTURE LINT")
    print(f"fixture: {FIXTURE_PATH.relative_to(ROOT)}")
    print(f"FIXTURE LINT OK: {definition_count} definitions, no forbidden accumulator")
    if args.godot is not None:
        command = [
            str(args.godot),
            "--headless",
            "--path",
            str(ROOT / "game"),
            "res://tests/R8CAMinimalScenePrototypeSmokeTest.tscn",
        ]
        result = subprocess.run(command, cwd=ROOT, text=True, encoding="utf-8", errors="replace")
        if result.returncode != 0:
            print("CANONICAL GODOT SIMULATION FAILED")
            return result.returncode
        print("CANONICAL GODOT SIMULATION OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
