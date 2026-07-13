import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class V090SelectorDayNormalizationStaticTests(unittest.TestCase):
    def test_selector_normalizes_json_float_days_against_runtime_integer_days(self):
        selector = (GAME / "scripts/narrative/FirstRepetitionSelector.gd").read_text(encoding="utf-8")
        self.assertIn("func _normalized_day_key", selector)
        self.assertIn("TYPE_INT or value_type == TYPE_FLOAT", selector)
        self.assertIn("return str(int(day_value))", selector)
        self.assertIn("return str(int(float(text)))", selector)
        self.assertIn("_normalized_day_key(raw_day) == expected_key", selector)
        self.assertNotIn("str(raw_day) == str(day_value)", selector)


if __name__ == "__main__":
    unittest.main()
