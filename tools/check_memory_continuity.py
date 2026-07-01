#!/usr/bin/env python3
"""Standalone continuity check for Sandra Day 1 -> Day 2."""

from __future__ import annotations

import json
import sys
from pathlib import Path

REQUIRED_MEMORY_IN = {
    "day_01_sandra_reconnection",
    "day_01_sandra_photo_shared",
    "player_admitted_lunch_mattered",
    "sandra_noticed_player_was_not_only_joking",
    "sandra_returned_after_distance",
}

CALLBACK_TERMS = ("photo", "recalled", "repensé", "gardé", "souvenir", "revoir", "revu", "mémoire")
DAY_1_SCENE_ID = "day_01_sandra_photo_trigger"
MAX_INTENSITY = 4


def load_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"expected object JSON in {path}")
    return data


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: python3 tools/check_memory_continuity.py <memory_contract.json> <draft.json>")
        return 1

    memory_path = Path(sys.argv[1])
    draft_path = Path(sys.argv[2])

    errors: list[str] = []

    try:
        memory = load_json(memory_path)
    except Exception as exc:
        print(f"ERROR memory contract: {exc}")
        return 1

    try:
        draft = load_json(draft_path)
    except Exception as exc:
        print(f"ERROR draft: {exc}")
        return 1

    if memory.get("memory_contract_id") != "sandra_day_01_memory_contract":
        errors.append("memory_contract_id mismatch")
    if memory.get("source_day") != 1:
        errors.append("memory contract source_day must be 1")
    if memory.get("route") != "sandra":
        errors.append("memory contract route must be sandra")
    if draft.get("source_memory_contract") != memory.get("memory_contract_id"):
        errors.append("draft.source_memory_contract must match memory contract id")

    memory_in = draft.get("memory_in")
    if not isinstance(memory_in, list):
        errors.append("draft.memory_in must exist as a list")
        memory_in = []
    else:
        missing = sorted(REQUIRED_MEMORY_IN - {str(item) for item in memory_in})
        if missing:
            errors.append(f"missing required memory_in items: {', '.join(missing)}")

    if "memory_out" not in draft or not isinstance(draft.get("memory_out"), list):
        errors.append("draft.memory_out must exist as a list")

    scene_id = str(draft.get("scene_id", ""))
    if scene_id == DAY_1_SCENE_ID:
        errors.append("day 2 scene_id must not reuse day 1 scene_id")

    intensity = draft.get("declared_max_desire_intensity")
    if not isinstance(intensity, int) or intensity > MAX_INTENSITY:
        errors.append("declared_max_desire_intensity must be an integer <= 4")

    messages = draft.get("messages")
    if not isinstance(messages, list):
        errors.append("draft.messages must exist as a list")
        messages = []

    text_blob = " ".join(
        str(node.get("text", "")) for node in messages if isinstance(node, dict)
    ).lower()
    if not any(term in text_blob for term in CALLBACK_TERMS):
        errors.append("draft does not contain an explicit callback signal")

    if not any(isinstance(node, dict) and node.get("sender") == "Sandra" and "photo" in str(node.get("text", "")).lower() for node in messages):
        errors.append("draft must include a Sandra callback to the photo/memory")

    if errors:
        print("FAIL")
        for error in errors:
            print(f"- {error}")
        return 1

    print("PASS")
    print(f"memory contract: {memory_path}")
    print(f"draft: {draft_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
