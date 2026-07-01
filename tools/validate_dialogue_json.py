#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from pathlib import Path

from dialogue_qa import check_json


def main():
    if len(sys.argv) != 2:
        print("Usage: python3 tools/validate_dialogue_json.py <scene.json>", file=sys.stderr)
        return 2
    scene = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
    result = check_json(scene)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 1 if result["status"] == "fail" else 0


if __name__ == "__main__":
    raise SystemExit(main())
