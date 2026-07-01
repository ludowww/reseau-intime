#!/usr/bin/env python3
"""Inspect basic dialogue rhythm and repetition signals.
"""

from __future__ import annotations

import argparse
import json
import statistics
import sys
from pathlib import Path

from narrative_check_common import expand_paths, iter_message_nodes, load_json, relative_path, sender_of, text_of


def _punctuation_profile(texts: list[str]) -> dict[str, int]:
    profile = {"?": 0, "!": 0, "…": 0, ".": 0}
    for text in texts:
        for char in profile:
            profile[char] += text.count(char)
    return profile


def analyze(path: Path) -> dict[str, object]:
    result: dict[str, object] = {"file": str(path), "status": "pass", "summary": {}, "warnings": [], "errors": []}
    try:
        data = load_json(path)
    except Exception as exc:
        result["status"] = "fail"
        result["errors"].append(f"JSON parse failed: {exc}")
        return result

    messages = [node for node in iter_message_nodes(data) if text_of(node).strip()]
    texts = [text_of(node).strip() for node in messages]
    lengths = [len(text) for text in texts]
    sender_runs: list[tuple[str, int]] = []
    current_sender = None
    current_run = 0
    for node in messages:
        sender = sender_of(node)
        if sender == current_sender:
            current_run += 1
        else:
            if current_sender is not None:
                sender_runs.append((current_sender, current_run))
            current_sender = sender
            current_run = 1
    if current_sender is not None:
        sender_runs.append((current_sender, current_run))

    repeated_prefixes = {}
    for text in texts:
        prefix = text[:18].lower()
        repeated_prefixes[prefix] = repeated_prefixes.get(prefix, 0) + 1

    result["summary"] = {
        "messages": len(messages),
        "avg_length": round(statistics.mean(lengths), 1) if lengths else 0.0,
        "median_length": round(statistics.median(lengths), 1) if lengths else 0.0,
        "longest_run": max((run for _, run in sender_runs), default=0),
        "punctuation": _punctuation_profile(texts),
    }

    if lengths and statistics.mean(lengths) > 160:
        result["warnings"].append("average message length is high for SMS")
    if any(length > 220 for length in lengths):
        result["warnings"].append("one or more messages are very long")
    if max((run for _, run in sender_runs), default=0) >= 4:
        result["warnings"].append("long same-speaker run detected")
    if any(count >= 3 for count in repeated_prefixes.values()):
        result["warnings"].append("simple repetition detected in message openings")
    if result["summary"]["punctuation"]["?"] == 0 and result["summary"]["punctuation"]["!"] == 0:
        result["warnings"].append("little punctuation variety detected")

    if result["errors"]:
        result["status"] = "fail"
    elif result["warnings"]:
        result["status"] = "warning"
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description="Check dialogue rhythm heuristics.")
    parser.add_argument("files", nargs="+", help="JSON draft files or glob patterns")
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
        result = analyze(path)
        print(f"# {relative_path(path)}")
        print(json.dumps(result, ensure_ascii=False, indent=2))
        if result["status"] == "fail":
            status = 1
    return status


if __name__ == "__main__":
    sys.exit(main())
