import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


def load_json(relative: str):
    return json.loads((GAME / relative).read_text(encoding="utf-8"))


def walk(value):
    yield value
    if isinstance(value, dict):
        for child in value.values():
            yield from walk(child)
    elif isinstance(value, list):
        for child in value:
            yield from walk(child)


def time_to_minutes(value: str) -> int:
    hours, minutes = value.split(":", 1)
    return int(hours) * 60 + int(minutes)


class V085J1ReconciliationStaticTests(unittest.TestCase):
    def test_active_tuesday_uses_only_new_reconciled_conversations(self):
        index = load_json("data/conversations/chapter_01_modular_index.json")
        self.assertEqual(
            index.get("conversation_files"),
            [
                "res://data/conversations/chapter_01_marie_opening.json",
                "res://data/conversations/chapter_01_sandra_trace.json",
            ],
        )
        self.assertEqual(
            index.get("default_order"),
            ["chapter_01_marie_opening", "chapter_01_sandra_trace"],
        )
        self.assertNotIn("conversation_filters", index)
        active_text = json.dumps(index, ensure_ascii=False)
        self.assertNotIn("chapter_01_marie.json", active_text)
        self.assertNotIn("chapter_01_sandra.json", active_text)
        self.assertTrue((GAME / "data/conversations/chapter_01_marie.json").exists())
        self.assertTrue((GAME / "data/conversations/chapter_01_sandra.json").exists())

    def test_tuesday_phase_order_is_marie_offline_sandra_offline(self):
        index = load_json("data/conversations/chapter_01_modular_index.json")
        phases = index["timeline_flow"]["phases"]
        self.assertEqual(
            [phase.get("id") for phase in phases],
            [
                "tuesday_marie_opening",
                "tuesday_shared_evening",
                "tuesday_sandra_trace",
                "tuesday_marie_final_return",
            ],
        )
        self.assertEqual(phases[0].get("required_conversation_ids"), ["chapter_01_marie_opening"])
        self.assertEqual(len(phases[1].get("authored_beat_variants", [])), 2)
        self.assertEqual(phases[2].get("required_conversation_ids"), ["chapter_01_sandra_trace"])
        self.assertEqual(len(phases[3].get("authored_beat_variants", [])), 2)
        self.assertEqual(index["timeline_flow"].get("next_day"), 2)

    def test_phone_uses_v085_authored_beat_adapter_and_day_log(self):
        phone_scene = (GAME / "scenes/smartphone/PhonePrototype.tscn").read_text(encoding="utf-8")
        phone = (GAME / "scripts/ui/PhonePrototypeV085.gd").read_text(encoding="utf-8")
        state = (GAME / "scripts/core/TimelineState.gd").read_text(encoding="utf-8")
        self.assertIn("PhonePrototypeV085.gd", phone_scene)
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV084.gd"', phone)
        for expected in [
            "_phase_has_authored_beat",
            "_activate_authored_beat_phase",
            "_authored_beat_for_phase",
            "_card_for_authored_beat",
            "TimelineState.record_day_log_entry",
            "EffectApplier.apply_flags",
            "TimelineState.complete_phase",
            "await _advance_after_phase",
            "Moments hors ligne",
        ]:
            self.assertIn(expected, phone)
        for expected in [
            "day_log_entries_by_day",
            "record_day_log_entry",
            "get_day_log_entries",
            "day_log_entries_by_day.clear()",
        ]:
            self.assertIn(expected, state)

    def test_m1_and_s1_are_the_only_three_choice_nodes(self):
        marie = load_json("data/conversations/chapter_01_marie_opening.json")
        sandra = load_json("data/conversations/chapter_01_sandra_trace.json")
        all_segments = marie.get("segments", []) + sandra.get("segments", [])
        meaningful = [segment for segment in all_segments if len(segment.get("choices", [])) == 3]
        self.assertEqual(
            [segment.get("id") for segment in meaningful],
            ["segment_j1_marie_presence_choice", "segment_j1_sandra_reading_choice"],
        )
        for segment in all_segments:
            choices = segment.get("choices", [])
            self.assertLessEqual(len(choices), 3)
            if len(choices) == 1:
                self.assertTrue(choices[0].get("_guided_reply"), segment.get("id"))

    def test_j1_choices_write_flags_only_and_no_numeric_route_effects(self):
        paths = [
            "data/conversations/chapter_01_marie_opening.json",
            "data/conversations/chapter_01_sandra_trace.json",
        ]
        combined = "\n".join((GAME / path).read_text(encoding="utf-8") for path in paths)
        for forbidden in [
            '"effects"',
            "marie.trust",
            "marie_attention_score",
            "marie_neglect_score",
            "truth_tendency",
            "sandra.attachment",
            "sandra_priority_score",
        ]:
            self.assertNotIn(forbidden, combined)
        for relative in paths:
            for node in walk(load_json(relative)):
                if isinstance(node, dict) and "choices" in node:
                    for choice in node.get("choices", []):
                        self.assertNotIn("effects", choice)

    def test_player_lines_are_choice_driven_only(self):
        for relative in [
            "data/conversations/chapter_01_marie_opening.json",
            "data/conversations/chapter_01_sandra_trace.json",
        ]:
            offenders = []
            for node in walk(load_json(relative)):
                if isinstance(node, dict) and str(node.get("sender", "")).lower() in {
                    "ludo",
                    "player",
                    "joueur",
                }:
                    offenders.append(node.get("id", "?"))
            self.assertEqual(offenders, [], relative)

    def test_active_j1_has_valid_monotone_timestamps_before_midnight(self):
        for relative in [
            "data/conversations/chapter_01_marie_opening.json",
            "data/conversations/chapter_01_sandra_trace.json",
        ]:
            data = load_json(relative)
            previous_segment_max = -1
            for segment in data.get("segments", []):
                segment_times = []
                for message in segment.get("messages", []):
                    if message.get("time_label"):
                        segment_times.append(time_to_minutes(message["time_label"]))
                for choice in segment.get("choices", []):
                    branch_times = [
                        time_to_minutes(message["time_label"])
                        for message in choice.get("next_messages", [])
                        if message.get("time_label")
                    ]
                    self.assertEqual(branch_times, sorted(branch_times), (relative, choice.get("id")))
                    segment_times.extend(branch_times)
                if segment_times:
                    self.assertTrue(all(0 <= value < 24 * 60 for value in segment_times))
                    self.assertGreaterEqual(min(segment_times), previous_segment_max, (relative, segment.get("id")))
                    previous_segment_max = max(segment_times)
            text = json.dumps(data, ensure_ascii=False)
            self.assertNotIn("24:", text)

    def test_sandra_remains_one_soft_trace_and_never_calls_tuesday_wednesday(self):
        sandra_text = (GAME / "data/conversations/chapter_01_sandra_trace.json").read_text(encoding="utf-8")
        lowered = sandra_text.lower()
        for forbidden in [
            "on est mercredi",
            "nature",
            "roman d'amour",
            "roman d’amour",
            "absent de moi-même",
            "moi aussi, ça m'avait manqué",
            '"toi"',
            "tomates",
        ]:
            self.assertNotIn(forbidden, lowered)
        self.assertIsNone(
            re.search(r"\blac\b", lowered),
            "standalone 'lac' found in active Sandra J1 content",
        )
        sandra = load_json("data/conversations/chapter_01_sandra_trace.json")
        content_ids = [
            node.get("content_id")
            for node in walk(sandra)
            if isinstance(node, dict) and node.get("content_id")
        ]
        self.assertEqual(content_ids, ["j1_sandra_lunch_memory_soft"])

    def test_mathilde_is_indirect_only_on_tuesday(self):
        index = load_json("data/conversations/chapter_01_modular_index.json")
        marie_text = (GAME / "data/conversations/chapter_01_marie_opening.json").read_text(encoding="utf-8")
        active = json.dumps(index, ensure_ascii=False) + marie_text
        self.assertIn("Mathilde veut passer voir l'installation demain", active)
        self.assertIn("juger l'éclairage", active)
        for forbidden in [
            "thread_mathilde_private",
            "j1_mathilde_bag_domestic_trace",
            "sac de sport",
            "raquette",
            "chargeur",
            "déjà installée",
        ]:
            self.assertNotIn(forbidden, active)

    def test_final_marie_beat_is_required_before_tuesday_completion(self):
        index = load_json("data/conversations/chapter_01_modular_index.json")
        phases = index["timeline_flow"]["phases"]
        final_phase = phases[-1]
        final_variants = final_phase.get("authored_beat_variants", [])
        self.assertEqual(final_phase.get("id"), "tuesday_marie_final_return")
        self.assertEqual(len(final_variants), 2)
        for variant in final_variants:
            self.assertIn("j1_day_complete", variant.get("sets_flags", []))
            self.assertIn("Marie", variant.get("text", ""))
        all_prior_flags = {
            flag
            for phase in phases[:-1]
            for variant in phase.get("authored_beat_variants", [])
            for flag in variant.get("sets_flags", [])
        }
        self.assertNotIn("j1_day_complete", all_prior_flags)
        self.assertEqual(index["timeline_flow"].get("next_day"), 2)

    def test_active_visual_is_reconciled_and_other_j1_visuals_are_legacy_only(self):
        bundle = load_json("data/visual_content/chapter_01_proofs.json")
        items = {item.get("id"): item for item in bundle.get("items", [])}
        active = items["j1_sandra_lunch_memory_soft"]
        self.assertEqual(active.get("risk_level"), 0)
        self.assertFalse(active.get("can_set_as_wallpaper"))
        self.assertIn("two_glasses", active.get("tags", []))
        self.assertNotIn("lake", active.get("tags", []))
        self.assertIn("legacy", items["j1_marie_kitchen_soft"].get("tags", []))
        self.assertIn("legacy", items["j1_mathilde_bag_domestic_trace"].get("tags", []))


if __name__ == "__main__":
    unittest.main()
