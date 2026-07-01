#!/usr/bin/env python3
"""Measure visible Player presence in a draft dialogue JSON.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from narrative_check_common import expand_paths, iter_message_nodes, load_json, relative_path, sender_of, text_of


def analyze(path: Path, player: str = "Player", min_ratio: float = 0.35) -> dict[str, object]:
    result: dict[str, object] = {"file": str(path), "status": "pass", "summary": {}, "warnings": [], "errors": []}
    try:
        data = load_json(path)
    except Exception as exc:
        result["status"] = "fail"
        result["errors"].append(f"JSON parse failed: {exc}")
        return result

    messages = [node for node in iter_message_nodes(data) if text_of(node).strip()]
    player_messages = [node for node in messages if sender_of(node) == player]
    ratio = (len(player_messages) / len(messages)) if messages else 0.0
    longest_absence = 0
    streak = 0
    for node in messages:
        if sender_of(node) == player:
            longest_absence = max(longest_absence, streak)
            streak = 0
        else:
            streak += 1
    longest_absence = max(longest_absence, streak)

    result["summary"] = {
        "messages": len(messages),
        "player_messages": len(player_messages),
        "player_ratio": round(ratio, 3),
        "longest_player_absence": longest_absence,
    }

    if messages and not player_messages:
        result["warnings"].append("no visible Player messages")
    if messages and ratio < min_ratio:
        result["warnings"].append(f"Player ratio below minimum {min_ratio:.2f}")
    if longest_absence >= 5:
        result["warnings"].append(f"Player absent for {longest_absence} consecutive messages")

    if result["errors"]:
        result["status"] = "fail"
    elif result["warnings"]:
        result["status"] = "warning"
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description="Check Player presence in dialogue drafts.")
    parser.add_argument("files", nargs="+", help="JSON draft files or glob patterns")
    parser.add_argument("--player", default="Player")
    parser.add_argument("--min-ratio", type=float, default=0.35)
    args = parser.parse_args()

    paths = expand_paths(args.files)
    if not paths:
        print("No files matched.")
        return 1

    status = 0
    for path in paths:
        if not path.exists():
            print(f"ERROR missing: {path}")
            status = 1
            continue
        result = analyze(path, args.player, args.min_ratio)
        print(f"# {relative_path(path)}")
        print(json.dumps(result, ensure_ascii=False, indent=2))
        if result["status"] == "fail":
            status = 1
    return status


if __name__ == "__main__":
    sys.exit(main())
