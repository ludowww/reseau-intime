import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class TUI02B3DayDividerStaticTests(unittest.TestCase):
    def _read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_semantic_component_and_smoke_assets_exist(self):
        required = [
            "game/scripts/ui/messages/DayDivider.gd",
            "game/tests/T_UI_02B3DayDividerSmokeDriver.gd",
            "game/tests/T_UI_02B3DayDividerSmokeTest.tscn",
            "tools/test_t_ui_02b3_day_divider.sh",
        ]
        self.assertEqual([path for path in required if not (ROOT / path).exists()], [])

    def test_day_divider_is_visual_only_non_interactive_and_has_no_metadata(self):
        divider = self._read("game/scripts/ui/messages/DayDivider.gd")
        self.assertIn("class_name DayDivider", divider)
        self.assertIn("Control.FOCUS_NONE", divider)
        self.assertIn("Control.MOUSE_FILTER_IGNORE", divider)
        self.assertNotIn("Button.new", divider)
        for forbidden in [
            "GameState", "DataLoader", "TimelineState", "PhonePrototype",
            "ConversationView", "LegacyMain", "res://data/", ".json",
            "messages.append", "unread_count", "TypingIndicator", "UnreadDivider",
            "avatar", "author", "timestamp", "OffPhoneTransition",
        ]:
            self.assertNotIn(forbidden.lower(), divider.lower())

    def test_timeline_detects_system_day_divider_without_reinserting_data(self):
        timeline = self._read("game/scripts/ui/messages/MessageTimeline.gd")
        self.assertIn('message.get("content_type", "")', timeline)
        self.assertIn('== "SYSTEM_DAY_DIVIDER"', timeline)
        self.assertIn('preload("res://scripts/ui/messages/DayDivider.gd")', timeline)
        build = timeline.split("func _build()", 1)[1].split("\nfunc ", 1)[0]
        self.assertIn("DAY_DIVIDER_SCRIPT.new()", build)
        self.assertNotIn("messages.append", build)
        self.assertIn("message_box.add_child", build)

    def test_unread_and_typing_remain_distinct_and_ordered(self):
        timeline = self._read("game/scripts/ui/messages/MessageTimeline.gd")
        self.assertIn("UNREAD_DIVIDER_SCRIPT", timeline)
        self.assertIn("TYPING_INDICATOR_SCRIPT", timeline)
        self.assertIn("DAY_DIVIDER_SCRIPT", timeline)
        self.assertIn("func day_divider_precedes_unread_divider() -> bool", timeline)
        self.assertIn("func typing_is_last_item() -> bool", timeline)

    def test_counting_contract_includes_system_data_but_excludes_visual_dividers_from_bubbles(self):
        timeline = self._read("game/scripts/ui/messages/MessageTimeline.gd")
        self.assertRegex(timeline, r"func message_count\(\) -> int:\s+return messages\.size\(\)")
        for signature in [
            "func day_divider_count() -> int",
            "func day_divider_labels() -> Array[String]",
            "func message_bubble_count() -> int",
            "func day_divider_has_timestamp() -> bool",
            "func day_divider_has_author() -> bool",
        ]:
            self.assertIn(signature, timeline)
        bubble_count = timeline.split("func message_bubble_count()", 1)[1].split("\nfunc ", 1)[0]
        self.assertNotIn("messages.size()", bubble_count)

    def test_demo_data_contains_private_and_group_day_markers_with_read_contract(self):
        data = self._read("game/scripts/ui/messages/MessagesDemoData.gd")
        self.assertGreaterEqual(data.count('"SYSTEM_DAY_DIVIDER"'), 1)
        self.assertIn('_day_divider("demo_day_private_01", "Mardi", 2)', data)
        self.assertIn('_day_divider("demo_day_private_02", "Plus tard ce soir", 2)', data)
        self.assertIn('_day_divider("demo_day_group_01", "Mercredi", 3)', data)
        helper = data.split("static func _day_divider", 1)[1].split("\nstatic func ", 1)[0]
        for token in [
            '"author_id": "system"', '"timestamp": ""', '"media_ref": ""',
            '"is_player": false', '"is_read": true', '"source_day": source_day',
        ]:
            self.assertIn(token, helper)
        self.assertGreaterEqual(data.count("false, false)"), 2)

    def test_portrait_screen_exposes_bounded_day_divider_proofs(self):
        screen = self._read("game/scripts/ui/messages/PortraitConversationScreen.gd")
        for token in [
            '"day_divider_count"', '"day_divider_labels"', '"message_bubble_count"',
            '"day_divider_has_timestamp"', '"day_divider_has_author"',
            '"day_divider_precedes_unread"',
        ]:
            self.assertIn(token, screen)

    def test_lot_has_no_runtime_legacy_dependencies_or_historical_sha(self):
        paths = [
            "game/scripts/ui/messages/DayDivider.gd",
            "game/scripts/ui/messages/MessageTimeline.gd",
            "game/scripts/ui/messages/MessagesDemoData.gd",
            "game/scripts/ui/messages/PortraitConversationScreen.gd",
            "game/tests/T_UI_02B3DayDividerSmokeDriver.gd",
        ]
        forbidden = [
            "GameState", "DataLoader", "TimelineState", "PhonePrototype",
            "ConversationView", "LegacyMain", "res://data/", ".json",
            "OffPhoneTransition",
        ]
        sha = re.compile(r"\b[0-9a-f]{40}\b", re.IGNORECASE)
        offenders = []
        for relative in paths:
            path = ROOT / relative
            if not path.exists():
                continue
            content = path.read_text(encoding="utf-8")
            if sha.search(content):
                offenders.append(f"{relative}: historical SHA")
            for token in forbidden:
                if token in content:
                    offenders.append(f"{relative}: {token}")
        self.assertEqual(offenders, [])

    def test_day_divider_visible_copy_has_no_internal_mechanics(self):
        paths = [
            ROOT / "game/scripts/ui/messages/DayDivider.gd",
            ROOT / "game/scripts/ui/messages/MessagesDemoData.gd",
        ]
        quoted = re.compile(r'"([^"\\]*(?:\\.[^"\\]*)*)"')
        forbidden = re.compile(
            r"\b(route|score|tier|trace_id|promise_id|fact_id|source_day|chapter|sequence|moment_id|day_[0-9]+)\b",
            re.IGNORECASE,
        )
        offenders = []
        for path in paths:
            if not path.exists():
                continue
            for value in quoted.findall(path.read_text(encoding="utf-8")):
                if forbidden.search(value) and value not in {"source_day"}:
                    offenders.append(f"{path.relative_to(ROOT)}: {value}")
        self.assertEqual(offenders, [])


if __name__ == "__main__":
    unittest.main()
