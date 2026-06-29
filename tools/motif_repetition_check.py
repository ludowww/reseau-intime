#!/usr/bin/env python3
"""Warn about repeated narrative motifs that can make scenes loop.

Usage from repository root:

    python3 tools/motif_repetition_check.py game/data/conversations/chapter_05_*.json

The script is deliberately heuristic. It flags motifs for author review; it does
not decide that a scene is bad.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from narrative_check_common import count_term_hits, expand_paths, joined_text, load_json, print_warnings, relative_path

MOTIFS: dict[str, list[str]] = {
    "phone_absence": [
        "téléphone",
        "tel",
        "portable",
        "écran",
        "ailleurs",
        "pas là",
        "distrait",
        "notifications",
    ],
    "sandra_later_waiting": [
        "plus tard",
        "attendre",
        "j'attends",
        "je t'attends",
        "pas maintenant",
        "une autre fois",
    ],
    "photo_trace_kept": [
        "gardé la photo",
        "gardée",
        "supprimé",
        "supprimer",
        "effacé",
        "trace",
        "preuve",
        "photo",
    ],
    "pauline_proof_control": [
        "preuve",
        "silence",
        "je garde",
        "j'ai vu",
        "photo",
        "détail",
        "contrôle",
    ],
    "raphaelle_refuge_hideout": [
        "cachette",
        "refuge",
        "cacher",
        "clarté",
        "faire semblant",
        "je peux écouter",
    ],
    "marie_jealousy_nico": [
        "nico",
        "jaloux",
        "jalousie",
        "draguer",
        "regard",
        "rendre jaloux",
    ],
}


def report_file(path: Path, max_hits: int) -> tuple[int, dict[str, int]]:
    try:
        data = load_json(path)
    except Exception as exc:
        print(f"ERROR {path}: {exc}")
        return 1, {}

    text = joined_text(data)
    counts = {name: count_term_hits(text, terms) for name, terms in MOTIFS.items()}

    print(f"\n# {relative_path(path)}")
    for name, count in sorted(counts.items()):
        print(f"{name}: {count}")

    warnings: list[str] = []
    for name, count in sorted(counts.items()):
        if count > max_hits:
            warnings.append(f"motif '{name}' appears {count} times; verify it has a new function")

    # Special J5/J6 risks from the scenario documentation.
    if counts.get("phone_absence", 0) > 0 and "marie" in str(path).lower():
        warnings.append("Marie scene mentions phone/absence motif; ensure it is not the old pivot")
    if counts.get("sandra_later_waiting", 0) > 0 and "sandra" in str(path).lower():
        warnings.append("Sandra waiting/later motif detected; ensure availability changes or there is a consequence")
    if counts.get("raphaelle_refuge_hideout", 0) > 0 and "raphaelle" in str(path).lower():
        warnings.append("Raphaëlle refuge/cachette motif detected; avoid repeating the same boundary")

    print_warnings(warnings)
    return (1 if warnings else 0), counts


def main() -> int:
    parser = argparse.ArgumentParser(description="Check repeated narrative motifs.")
    parser.add_argument("files", nargs="+", help="JSON dialogue files or glob patterns")
    parser.add_argument("--max-hits", type=int, default=4, help="Warn when a motif appears more than this")
    parser.add_argument("--strict", action="store_true", help="Return non-zero when warnings are found")
    args = parser.parse_args()

    paths = expand_paths(args.files)
    if not paths:
        print("No files matched.")
        return 1

    status = 0
    aggregate: dict[str, int] = {name: 0 for name in MOTIFS}
    files_by_motif: dict[str, int] = {name: 0 for name in MOTIFS}

    for path in paths:
        if not path.exists():
            print(f"ERROR missing: {path}")
            status = 1
            continue
        file_status, counts = report_file(path, args.max_hits)
        for name, count in counts.items():
            aggregate[name] += count
            if count:
                files_by_motif[name] += 1
        if args.strict:
            status |= file_status

    if len(paths) > 1:
        print("\n# Aggregate motif spread")
        aggregate_warnings: list[str] = []
        for name in sorted(MOTIFS):
            print(f"{name}: hits={aggregate[name]} files={files_by_motif[name]}")
            if files_by_motif[name] >= 3 and aggregate[name] > args.max_hits:
                aggregate_warnings.append(
                    f"motif '{name}' appears across {files_by_motif[name]} files; check day-level repetition"
                )
        print_warnings(aggregate_warnings)
        if args.strict and aggregate_warnings:
            status = 1

    return status


if __name__ == "__main__":
    sys.exit(main())
