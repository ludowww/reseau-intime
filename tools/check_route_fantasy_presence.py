#!/usr/bin/env python3
"""Check that a scene still carries the Sandra route fantasy markers.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from narrative_check_common import expand_paths, joined_text, load_json, relative_path


def analyze(path: Path) -> dict[str, object]:
    result: dict[str, object] = {"file": str(path), "status": "pass", "summary": {}, "warnings": [], "errors": []}
    try:
        data = load_json(path)
    except Exception as exc:
        result["status"] = "fail"
        result["errors"].append(f"JSON parse failed: {exc}")
        return result

    text = joined_text(data).lower()
    required = {
        "photo": ["photo", "image"],
        "souvenir": ["souvenir", "déjeuner", "archives"],
        "complicité": ["complicité", "complice", "ancienne", "revoir"],
        "humour/esquive": ["humour", "blague", "esquive", "sourit", "rigole"],
        "ambiguïté": ["ambigu", "trop rapide", "un peu", "peut-être", "double"],
        "interdit doux": ["interdit", "couple", "limite", "dangereux"],
        "mémoire de sortie": ["reprendre contact", "pas oublié", "plusieurs semaines", "dernier déjeuner", "recontact"],
    }
    hits = {name: any(term in text for term in terms) for name, terms in required.items()}
    result["summary"] = {"required_hits": hits, "matched": sum(1 for hit in hits.values() if hit)}

    for name, hit in hits.items():
        if not hit:
            result["warnings"].append(f"missing Sandra fantasy element: {name}")
    if result["warnings"]:
        result["status"] = "warning"
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description="Check route fantasy presence.")
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
