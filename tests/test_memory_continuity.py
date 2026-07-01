from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOOLS = ROOT / "tools"
if str(TOOLS) not in sys.path:
    sys.path.insert(0, str(TOOLS))

import check_memory_continuity as cmc  # noqa: E402


SANDRA_CONTRACT = ROOT / "narrative_tool" / "memory" / "sandra_day_01_memory_contract.json"
SANDRA_DRAFT = ROOT / "narrative_tool" / "drafts" / "day_02_sandra_callback.draft.json"
MARIE_CONTRACT = ROOT / "narrative_tool" / "memory" / "marie_day_01_memory_contract.json"
MARIE_DRAFT = ROOT / "narrative_tool" / "drafts" / "day_01_marie_couple_anchor.draft.json"


class MemoryContinuityTests(unittest.TestCase):
    def test_sandra_future_continuity_passes(self) -> None:
        report = cmc.run_memory_continuity_check(SANDRA_CONTRACT, SANDRA_DRAFT, emit=False)
        self.assertEqual(report["status"], "pass")
        self.assertEqual(report["mode"], "future_continuity_check")

    def test_marie_source_memory_coverage_passes(self) -> None:
        report = cmc.run_memory_continuity_check(MARIE_CONTRACT, MARIE_DRAFT, emit=False)
        self.assertEqual(report["status"], "pass")
        self.assertEqual(report["mode"], "source_memory_coverage_check")

    def test_mode_detection_switches_between_source_and_future(self) -> None:
        sandra_contract = cmc.load_json(SANDRA_CONTRACT)
        sandra_draft = cmc.load_json(SANDRA_DRAFT)
        marie_contract = cmc.load_json(MARIE_CONTRACT)
        marie_draft = cmc.load_json(MARIE_DRAFT)

        self.assertEqual(cmc.detect_check_mode(sandra_contract, sandra_draft), "future_continuity_check")
        self.assertEqual(cmc.detect_check_mode(marie_contract, marie_draft), "source_memory_coverage_check")

    def test_mismatch_fails_cleanly_with_readable_error(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            draft_path = Path(tmp) / "bad_marie_draft.json"
            draft_path.write_text(
                json.dumps(
                    {
                        "scene_id": "day_99_bad_mismatch",
                        "route": "sandra",
                        "memory_in": [],
                        "messages": [],
                        "choices": [],
                        "memory_out": [],
                        "description": "",
                        "summary": "",
                    },
                    ensure_ascii=False,
                    indent=2,
                ),
                encoding="utf-8",
            )

            report = cmc.run_memory_continuity_check(MARIE_CONTRACT, draft_path, emit=False)

            self.assertEqual(report["status"], "fail")
            self.assertTrue(report["errors"])
            self.assertTrue(
                any(
                    "scene_id mismatch" in error or "route mismatch" in error or "memory_in" in error
                    for error in report["errors"]
                )
            )


if __name__ == "__main__":
    unittest.main()
