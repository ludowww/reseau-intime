#!/usr/bin/env python3
"""Run the V0 narrative SMS QA stack and write a JSON report.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from check_choice_sms_quality import analyze as analyze_choice_quality
from check_desire_intensity import analyze as analyze_desire_intensity
from check_dialogue_rhythm import analyze as analyze_rhythm
from check_player_presence import analyze as analyze_player_presence
from check_route_fantasy_presence import analyze as analyze_route_fantasy
from validate_dialogue_json import validate as validate_dialogue

ROOT = Path(__file__).resolve().parents[1]
REPORT_DIR = ROOT / "narrative_tool" / "reports"
SCENE_ID = "day_01_sandra_photo_trigger"


def aggregate(result_map: dict[str, dict[str, object]]) -> dict[str, object]:
    warnings: list[str] = []
    errors: list[str] = []
    status = "pass"
    for name, result in result_map.items():
        warnings.extend(f"{name}: {warning}" for warning in result.get("warnings", []))
        errors.extend(f"{name}: {error}" for error in result.get("errors", []))
        if result.get("status") == "fail":
            status = "fail"
        elif result.get("status") == "warning" and status == "pass":
            status = "warning"
    summary = {name: result.get("summary", {}) for name, result in result_map.items()}
    return {"status": status, "summary": summary, "warnings": warnings, "errors": errors}


def main() -> int:
    parser = argparse.ArgumentParser(description="Run the narrative SMS QA stack.")
    parser.add_argument("draft", help="Path to the draft JSON file")
    args = parser.parse_args()

    draft_path = Path(args.draft)
    if not draft_path.exists():
        print(f"ERROR missing: {draft_path}")
        return 1

    validators = {
        "validate_dialogue_json": validate_dialogue(draft_path),
        "check_player_presence": analyze_player_presence(draft_path, player="Player", min_ratio=0.35),
        "check_dialogue_rhythm": analyze_rhythm(draft_path),
        "check_choice_sms_quality": analyze_choice_quality(draft_path),
        "check_desire_intensity": analyze_desire_intensity(draft_path),
        "check_route_fantasy_presence": analyze_route_fantasy(draft_path),
    }
    overall = aggregate(validators)
    report = {
        "scene_id": SCENE_ID,
        "status": overall["status"],
        "summary": overall["summary"],
        "checks": validators,
        "warnings": overall["warnings"],
        "errors": overall["errors"],
    }

    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    report_path = REPORT_DIR / f"{SCENE_ID}.qa.json"
    report_path.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(json.dumps(report, ensure_ascii=False, indent=2))
    print(f"wrote: {report_path}")
    return 0 if report["status"] != "fail" else 1


if __name__ == "__main__":
    sys.exit(main())
