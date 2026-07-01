#!/usr/bin/env python3
"""Check desire intensity against the Sandra day-1 contract.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from narrative_check_common import expand_paths, joined_text, load_json, relative_path

ROOT = Path(__file__).resolve().parents[1]


def _load_contract(scene_id: str) -> dict[str, object] | None:
    contract = ROOT / "narrative_tool" / "scene_contracts" / f"{scene_id}.contract.json"
    if contract.exists():
        with contract.open("r", encoding="utf-8") as handle:
            return json.load(handle)
    return None


def analyze(path: Path) -> dict[str, object]:
    result: dict[str, object] = {"file": str(path), "status": "pass", "summary": {}, "warnings": [], "errors": []}
    try:
        data = load_json(path)
    except Exception as exc:
        result["status"] = "fail"
        result["errors"].append(f"JSON parse failed: {exc}")
        return result

    scene_id = str(data.get("scene_id", "")).strip()
    intensity = data.get("desire_intensity")
    beats = data.get("beats") if isinstance(data.get("beats"), list) else []
    beat_intensities = [beat.get("intensity") for beat in beats if isinstance(beat, dict) and isinstance(beat.get("intensity"), int)]
    seen_values = []
    if isinstance(intensity, int):
        seen_values.append(intensity)
    seen_values.extend(int(v) for v in beat_intensities)
    max_seen = max(seen_values) if seen_values else None

    contract = _load_contract(scene_id) if scene_id else None
    limit = None
    if contract and isinstance(contract.get("limit_intensity"), int):
        limit = int(contract["limit_intensity"])

    text = joined_text(data).lower()
    expected_signals = ["complicité", "photo", "souvenir", "ambigu", "humour", "interdit"]
    signal_hits = {term: text.count(term.lower()) for term in expected_signals}

    result["summary"] = {
        "scene_id": scene_id or None,
        "declared_intensity": intensity,
        "max_seen_intensity": max_seen,
        "contract_limit": limit,
        "signal_hits": signal_hits,
    }

    if intensity is None and max_seen is None:
        result["warnings"].append("no desire intensity declared")
    if isinstance(intensity, int) and limit is not None and intensity > limit:
        result["warnings"].append(f"declared desire intensity {intensity} exceeds contract limit {limit}")
    if max_seen is not None and limit is not None and max_seen > limit:
        result["warnings"].append(f"beat desire intensity {max_seen} exceeds contract limit {limit}")
    if signal_hits["photo"] == 0 or signal_hits["souvenir"] == 0:
        result["warnings"].append("expected photo/souvenir signals are thin or missing")
    if signal_hits["ambigu"] == 0:
        result["warnings"].append("no obvious ambiguity signal detected")
    if result["warnings"]:
        result["status"] = "warning"
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description="Check desire intensity levels.")
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
