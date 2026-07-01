from __future__ import annotations

import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOOLS = ROOT / "tools"
if str(TOOLS) not in sys.path:
    sys.path.insert(0, str(TOOLS))

import run_dialogue_qa  # noqa: E402


DAY_1 = ROOT / "narrative_tool" / "drafts" / "day_01_sandra_photo_trigger.draft.json"
DAY_2 = ROOT / "narrative_tool" / "drafts" / "day_02_sandra_callback.draft.json"


class NarrativeToolQATests(unittest.TestCase):
    def test_run_dialogue_qa_uses_current_scene_id_for_day_1_and_day_2(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            report_dir = Path(tmp)

            day_1 = run_dialogue_qa.run_qa(DAY_1, report_dir=report_dir, emit=False)
            day_2 = run_dialogue_qa.run_qa(DAY_2, report_dir=report_dir, emit=False)

            self.assertEqual(day_1["report"]["scene_id"], "day_01_sandra_photo_trigger")
            self.assertEqual(day_2["report"]["scene_id"], "day_02_sandra_callback")
            self.assertEqual(day_1["report"]["status"], "pass")
            self.assertEqual(day_2["report"]["status"], "pass")
            self.assertNotEqual(day_1["report_path"], day_2["report_path"])
            self.assertEqual(day_1["report_path"].name, "day_01_sandra_photo_trigger.qa.json")
            self.assertEqual(day_2["report_path"].name, "day_02_sandra_callback.qa.json")
            self.assertTrue(day_1["report_path"].exists())
            self.assertTrue(day_2["report_path"].exists())


if __name__ == "__main__":
    unittest.main()
