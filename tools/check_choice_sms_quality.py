#!/usr/bin/env python3
"""Detect choice text that sounds like author instructions rather than SMS.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

from narrative_check_common import choice_label, expand_paths, iter_choices, load_json, relative_path

BAD_PREFIXES = (
    "exprimer",
    "avouer",
    "rassurer",
    "flirter",
    "demander",
    "dire",
    "répondre",
    "ignorer",
    "éviter",
    "proposer",
    "tester",
    "relancer",
    "faire",
    "poser",
)


def analyze(path: Path) -> dict[str, object]:
    result: dict[str, object] = {"file": str(path), "status": "pass", "summary": {}, "warnings": [], "errors": []}
    try:
        data = load_json(path)
    except Exception as exc:
        result["status"] = "fail"
        result["errors"].append(f"JSON parse failed: {exc}")
        return result

    choices = iter_choices(data)
    flagged: list[str] = []
    for choice in choices:
        text = choice_label(choice).strip()
        lowered = re.sub(r"\s+", " ", text.lower())
        if lowered.startswith(BAD_PREFIXES):
            flagged.append(f"{choice.get('id', '<choice>')}: instruction-like start")
        if len(text) > 95:
            flagged.append(f"{choice.get('id', '<choice>')}: too long for a compact SMS")
        if not (
            lowered.startswith(("je ", "j'", "j’", "oui", "non", "on ", "tu "))
            or " je " in lowered
            or " tu " in lowered
        ):
            flagged.append(f"{choice.get('id', '<choice>')}: may not read like a real SMS reply")

    result["summary"] = {"choices": len(choices), "flagged": len(flagged)}
    if flagged:
        result["warnings"].extend(flagged)
        result["status"] = "warning"
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description="Check choice SMS quality heuristics.")
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
