#!/usr/bin/env python3
"""Warn when choice text reads like writer instructions instead of Player speech.

Usage from repository root:

    python3 tools/player_choice_text_check.py game/data/conversations/chapter_*.json

This helper is intentionally conservative: it emits warnings for review but does not
rewrite data or fail unless --strict is passed.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

from narrative_check_common import choice_label, expand_paths, iter_choices, load_json, print_warnings, relative_path

ENGLISH_DEBUG_TERMS = ("dodge", "say", "tell", "ask", "reply", "answer")
FRENCH_INSTRUCTION_PREFIXES = ("dire qu", "répondre qu", "demander", "esquiver", "minimiser", "avouer", "faire")
DIRECT_SPEECH_HINTS = (
    "je ",
    "j'",
    "j’",
    "oui",
    "non",
    "c'est",
    "c’est",
    "moi",
    "on ",
    "tu ",
    "nous",
)


def _normalized_label(label: str) -> str:
    return " ".join(label.strip().split())


def choice_issues(label: str) -> list[str]:
    text = _normalized_label(label)
    lowered = text.lower()
    issues: list[str] = []
    if "mais en français" in lowered:
        issues.append("contains meta phrase 'mais en français'")
    if any(re.search(rf"\b{re.escape(term)}\b", lowered) for term in ENGLISH_DEBUG_TERMS):
        issues.append("contains English debug wording")
    if lowered.startswith(FRENCH_INSTRUCTION_PREFIXES):
        issues.append("sounds like a writing instruction rather than a spoken reply")
    if not any(lowered.startswith(hint) for hint in DIRECT_SPEECH_HINTS) and lowered.endswith(".") and len(lowered) <= 48:
        if lowered.startswith(("faire ", "demander ", "répondre ", "dire ", "avouer ", "minimiser ", "esquiver ")):
            issues.append("may need a more direct first-person rewrite")
    return issues


def report_file(path: Path) -> int:
    try:
        data = load_json(path)
    except Exception as exc:
        print(f"ERROR {path}: {exc}")
        return 1

    warnings: list[str] = []
    choices = iter_choices(data)
    flagged = []
    for choice in choices:
        label = choice_label(choice)
        issues = choice_issues(label)
        if issues:
            choice_id = str(choice.get("id", "<choice>"))
            flagged.append(f"{choice_id}: {label} — {', '.join(issues)}")
    print(f"\n# {relative_path(path)}")
    print(f"choices: {len(choices)}")
    if flagged:
        warnings.extend(flagged)
    print_warnings(warnings)
    return 1 if warnings else 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Check choice text for obvious writer-instruction phrasing.")
    parser.add_argument("files", nargs="+", help="JSON dialogue files or glob patterns")
    parser.add_argument("--strict", action="store_true", help="Return non-zero when warnings are found")
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
        file_status = report_file(path)
        if args.strict:
            status |= file_status
    return status


if __name__ == "__main__":
    sys.exit(main())
