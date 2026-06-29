#!/usr/bin/env python3
"""Warn about route compatibility risks in dialogue JSON files.

Usage from repository root:

    python3 tools/route_compatibility_check.py game/data/conversations/chapter_06_*.json

This tool maps broad route-state language to the narrative compatibility rules.
It is intentionally heuristic and meant for author review.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from narrative_check_common import count_term_hits, expand_paths, joined_text, load_json, print_warnings, relative_path

ROUTE_TERMS: dict[str, list[str]] = {
    "truth_clarity": ["vérité", "clair", "clarté", "honnête", "dire", "nommer", "cadre", "règle"],
    "lie_hiding": ["mensonge", "mentir", "cacher", "cache", "flou", "faire semblant", "minimiser"],
    "marie_revenge_nico": ["nico", "jaloux", "jalousie", "venge", "draguer", "rendre jaloux"],
    "open_relationship": ["ouverture", "ouvrir", "relation libre", "polyamour", "trio", "quatuor", "libertinage"],
    "pauline_control": ["pauline", "preuve", "silence", "contrôle", "défi", "chantage", "je garde"],
    "raphaelle_clarity": ["raphaëlle", "clarté", "clair", "cachette", "refuge", "limite"],
    "mathilde_domestic": ["mathilde", "maison", "marie", "photo", "supprimer", "garder", "salle de bain"],
    "sandra_trust": ["sandra", "confiance", "valoriser", "restaurant", "manqué", "photo", "confidence"],
}


def report_file(path: Path) -> tuple[int, dict[str, int]]:
    try:
        data = load_json(path)
    except Exception as exc:
        print(f"ERROR {path}: {exc}")
        return 1, {}

    text = joined_text(data)
    counts = {name: count_term_hits(text, terms) for name, terms in ROUTE_TERMS.items()}

    print(f"\n# {relative_path(path)}")
    for name, count in sorted(counts.items()):
        print(f"{name}: {count}")

    warnings: list[str] = []
    if counts["raphaelle_clarity"] > 0 and counts["lie_hiding"] > 2:
        warnings.append("Raphaëlle/clarté appears with hiding language; verify she is not used as a cachette")
    if counts["open_relationship"] > 0 and counts["lie_hiding"] > 2:
        warnings.append("opening/poly language appears with hiding language; verify opening is not excusing old lies")
    if counts["marie_revenge_nico"] > 0 and counts["truth_clarity"] == 0:
        warnings.append("Marie/Nico jealousy appears without clarity language; verify whether this is revenge/cold war")
    if counts["pauline_control"] > 3 and counts["truth_clarity"] > 3:
        warnings.append("Pauline control and clarity both high; verify her route is transforming, not still blackmail-driven")
    if counts["mathilde_domestic"] > 0 and counts["open_relationship"] > 0:
        warnings.append("Mathilde/domestic route appears with opening language; ensure Marie loyalty conflict is treated")
    if counts["sandra_trust"] > 0 and counts["lie_hiding"] > 3:
        warnings.append("Sandra trust appears with heavy hiding language; verify she is not only a hidden route")

    active_routes = [name for name, count in counts.items() if count > 0]
    if len(active_routes) >= 6:
        warnings.append("many route families active in one file; check whether scene is overloaded")

    print_warnings(warnings)
    return (1 if warnings else 0), counts


def main() -> int:
    parser = argparse.ArgumentParser(description="Check route compatibility risk language.")
    parser.add_argument("files", nargs="+", help="JSON dialogue files or glob patterns")
    parser.add_argument("--strict", action="store_true", help="Return non-zero when warnings are found")
    args = parser.parse_args()

    paths = expand_paths(args.files)
    if not paths:
        print("No files matched.")
        return 1

    status = 0
    aggregate: dict[str, int] = {name: 0 for name in ROUTE_TERMS}
    for path in paths:
        if not path.exists():
            print(f"ERROR missing: {path}")
            status = 1
            continue
        file_status, counts = report_file(path)
        for name, count in counts.items():
            aggregate[name] += count
        if args.strict:
            status |= file_status

    if len(paths) > 1:
        print("\n# Aggregate route language")
        for name in sorted(aggregate):
            print(f"{name}: {aggregate[name]}")
        warnings: list[str] = []
        if aggregate["lie_hiding"] > aggregate["truth_clarity"] * 2 and aggregate["raphaelle_clarity"] > 0:
            warnings.append("day-level hiding strongly exceeds clarity while Raphaëlle is active")
        if aggregate["open_relationship"] > 0 and aggregate["truth_clarity"] == 0:
            warnings.append("opening/poly route language appears without truth/clarity language")
        print_warnings(warnings)
        if args.strict and warnings:
            status = 1

    return status


if __name__ == "__main__":
    sys.exit(main())
