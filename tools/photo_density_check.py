#!/usr/bin/env python3
"""Report visual-content density in dialogue JSON files.

Usage from repository root:

    python3 tools/photo_density_check.py game/data/conversations/chapter_06_*.json

The target of roughly three photos per day is a soft production guide. This
script reports possible gaps; it does not decide that a day is invalid.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from narrative_check_common import (
    content_reference_nodes,
    expand_paths,
    iter_message_nodes,
    joined_text,
    load_json,
    print_warnings,
    relative_path,
)

PHOTO_TERMS = [
    "photo",
    "selfie",
    "image",
    "story",
    "screenshot",
    "capture",
    "regarde",
    "envoyé",
    "envoyer",
]

SOFT_TERMS = ["souvenir", "quotidien", "restaurant", "café", "groupe", "travail", "maison"]
SUGGESTIVE_TERMS = ["sexy", "troublant", "détail", "tenue", "provoque", "provocation"]
PROOF_TERMS = ["preuve", "trace", "gardé", "supprimé", "silence", "jaloux"]
EXPLICIT_TERMS = ["explicite", "nu", "nue", "intime", "sexuel", "pornographique"]


def count_terms(text: str, terms: list[str]) -> int:
    lowered = text.lower()
    return sum(lowered.count(term) for term in terms)


def report_file(path: Path, soft_min: int) -> tuple[int, int]:
    try:
        data = load_json(path)
    except Exception as exc:
        print(f"ERROR {path}: {exc}")
        return 1, 0

    content_nodes = content_reference_nodes(data)
    text = joined_text(data)
    message_count = len(iter_message_nodes(data))
    content_count = len(content_nodes)
    photo_term_hits = count_terms(text, PHOTO_TERMS)
    soft_hits = count_terms(text, SOFT_TERMS)
    suggestive_hits = count_terms(text, SUGGESTIVE_TERMS)
    proof_hits = count_terms(text, PROOF_TERMS)
    explicit_hits = count_terms(text, EXPLICIT_TERMS)

    print(f"\n# {relative_path(path)}")
    print(f"messages: {message_count}")
    print(f"content_refs: {content_count}")
    print(f"photo_term_hits: {photo_term_hits}")
    print(f"photo_language_soft: {soft_hits}")
    print(f"photo_language_suggestive: {suggestive_hits}")
    print(f"photo_language_proof: {proof_hits}")
    print(f"photo_language_explicit: {explicit_hits}")

    warnings: list[str] = []
    if message_count >= 8 and content_count == 0 and photo_term_hits == 0:
        warnings.append("dialogue has enough volume but no visual content reference or photo language")
    if content_count > 0 and soft_hits + suggestive_hits + proof_hits + explicit_hits == 0:
        warnings.append("visual content exists but dialogue has little photo-related language/context")
    if explicit_hits > 0 and content_count == 0:
        warnings.append("explicit/intimate photo language without content reference; verify intended staging")
    if content_count > 0 and content_count < soft_min and "chapter_" in str(path):
        warnings.append(
            f"low per-file content refs ({content_count}); day-level check may still pass if other files contribute"
        )

    print_warnings(warnings)
    return (1 if warnings else 0), content_count


def main() -> int:
    parser = argparse.ArgumentParser(description="Report visual content/photo density.")
    parser.add_argument("files", nargs="+", help="JSON dialogue files or glob patterns")
    parser.add_argument("--day-target", type=int, default=3, help="Soft day-level visual-content target")
    parser.add_argument(
        "--per-file-soft-min",
        type=int,
        default=1,
        help="Soft per-file visual-content minimum before warning when a file has content",
    )
    parser.add_argument("--strict", action="store_true", help="Return non-zero when warnings are found")
    args = parser.parse_args()

    paths = expand_paths(args.files)
    if not paths:
        print("No files matched.")
        return 1

    status = 0
    total_content = 0
    for path in paths:
        if not path.exists():
            print(f"ERROR missing: {path}")
            status = 1
            continue
        file_status, content_count = report_file(path, args.per_file_soft_min)
        total_content += content_count
        if args.strict:
            status |= file_status

    if len(paths) > 1:
        print("\n# Day-level visual content")
        print(f"files: {len(paths)}")
        print(f"content_refs_total: {total_content}")
        warnings: list[str] = []
        if total_content < args.day_target:
            warnings.append(
                f"day-level visual content below soft target: {total_content}/{args.day_target}; explain if intentional"
            )
        print_warnings(warnings)
        if args.strict and warnings:
            status = 1

    return status


if __name__ == "__main__":
    sys.exit(main())
