from __future__ import annotations

import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOOLS = ROOT / "tools"


class DialogueEmojiToolsTests(unittest.TestCase):
    def run_tool(self, *args: str) -> str:
        result = subprocess.run(
            [sys.executable, *args],
            cwd=ROOT,
            check=True,
            text=True,
            capture_output=True,
        )
        return result.stdout

    def test_context_pack_mentions_emoji_evolution_for_sandra_stage_3_medium(self) -> None:
        output = self.run_tool(
            str(TOOLS / "dialogue_context_pack.py"),
            "--character",
            "sandra",
            "--day",
            "9",
            "--stage",
            "stage_3_intimite_naissante",
            "--risk",
            "medium",
        )

        self.assertIn("Emoji evolution guidance", output)
        self.assertIn("stage_3_intimite_naissante", output)
        self.assertIn("Palette de base", output)
        self.assertIn("emojis rares mais plus chargés", output)

    def test_rhythm_report_signals_emoji_absence(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "dialogue.json"
            path.write_text(
                json.dumps(
                    {
                        "thread": {"participants": ["ludo", "sandra"]},
                        "messages": [
                            {"sender": "sandra", "text": "Je passe ce soir."},
                            {"sender": "ludo", "text": "Ok."},
                        ],
                    },
                    ensure_ascii=False,
                ),
                encoding="utf-8",
            )

            output = self.run_tool(str(TOOLS / "dialogue_rhythm_report.py"), str(path))

        self.assertIn("emoji_count: 0", output)
        self.assertIn("emoji_unique_count: 0", output)
        self.assertIn("emoji_absence_note", output)

    def test_voice_check_warns_when_raphaelle_is_overly_emoji_heavy(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "dialogue.json"
            path.write_text(
                json.dumps(
                    {
                        "thread": {"participants": ["ludo", "raphaelle"]},
                        "messages": [
                            {"sender": "raphaelle", "text": "Tu fais quoi ce soir 😇🙃🫠"},
                            {"sender": "raphaelle", "text": "J’insiste un peu 😇"},
                            {"sender": "ludo", "text": "..."},
                        ],
                    },
                    ensure_ascii=False,
                ),
                encoding="utf-8",
            )

            output = self.run_tool(
                str(TOOLS / "dialogue_voice_check.py"),
                str(path),
                "--character",
                "raphaelle",
                "--stage",
                "stage_1_familiarite",
                "--risk",
                "low",
            )

        self.assertIn("Emoji voice check", output)
        self.assertIn("too many emojis", output)
        self.assertIn("unexpected emojis", output)
        self.assertIn("⚠️", output)


if __name__ == "__main__":
    unittest.main()
