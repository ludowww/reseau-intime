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


def condition_met(condition: str, flags: set[str]) -> bool:
    text = condition.strip()
    if not text:
        return True
    return any(part.strip() in flags for part in text.split(" OR "))


def entry_visible(entry: dict, flags: set[str]) -> bool:
    conditions = entry.get("conditions", [])
    if not isinstance(conditions, list):
        conditions = [conditions]
    if not all(condition_met(str(condition), flags) for condition in conditions):
        return False
    exclusions = entry.get("unless_conditions", [])
    if not isinstance(exclusions, list):
        exclusions = [exclusions]
    return not any(
        condition_met(str(condition), flags)
        for condition in exclusions
        if str(condition).strip()
    )


class V082ThursdayStaticTests(unittest.TestCase):
    THURSDAY_FILES = [
        "data/conversations/chapter_03_raphaelle_blue_folder.json",
        "data/conversations/chapter_03_sandra_continuity.json",
        "data/conversations/chapter_03_marie_event_offer.json",
        "data/conversations/chapter_03_marie_event_joined.json",
        "data/conversations/chapter_03_mathilde_home_charger.json",
        "data/conversations/chapter_03_raphaelle_late_review.json",
        "data/conversations/chapter_03_marie_event_return.json",
    ]

    def test_active_loader_exposes_modular_tuesday_through_thursday(self):
        loader = (GAME / "scripts/core/DataLoader.gd").read_text(encoding="utf-8")
        active_indexes = loader[loader.index("const CHAPTER_INDEX_PATHS") : loader.index("const LEGACY_CHAPTER_INDEX_PATHS")]
        self.assertIn("chapter_01_modular_index.json", active_indexes)
        self.assertIn("chapter_02_modular_index.json", active_indexes)
        self.assertIn("chapter_03_modular_index.json", active_indexes)
        self.assertNotIn('"res://data/conversations/chapter_03_index.json"', active_indexes)

        active_visuals = loader[loader.index("const VISUAL_CONTENT_PATHS") : loader.index("const LEGACY_VISUAL_CONTENT_PATHS")]
        for bundle in ["chapter_01_proofs.json", "chapter_02_proofs.json", "chapter_03_proofs.json"]:
            self.assertIn(bundle, active_visuals)
        self.assertNotIn("chapter_04_proofs.json", active_visuals)

    def test_thursday_index_has_exact_moments_and_conversations(self):
        index = load_json("data/conversations/chapter_03_modular_index.json")
        self.assertEqual(index.get("calendar_label"), "Jeudi")
        self.assertEqual(index.get("display_label"), "Jeudi — Être là")
        self.assertEqual(index.get("day_start_time"), "09:10")
        self.assertEqual(index.get("window_range"), "O3-O6")
        self.assertEqual(index.get("route_stage_ceiling"), "R1")
        self.assertEqual(index.get("conversation_files"), [f"res://{path}" for path in self.THURSDAY_FILES])
        self.assertEqual(
            [(item.get("time_label"), item.get("conversation_ids")) for item in index.get("moment_flow", [])],
            [
                ("09:10", ["chapter_03_raphaelle_blue_folder"]),
                ("13:50", ["chapter_03_sandra_continuity"]),
                ("16:05", ["chapter_03_marie_event_offer"]),
                ("17:45", ["chapter_03_raphaelle_late_review"]),
                ("17:55", ["chapter_03_marie_event_joined"]),
                ("18:20", ["chapter_03_mathilde_home_charger"]),
                ("22:10", ["chapter_03_marie_event_return"]),
            ],
        )

    def test_unlock_graph_preserves_topology_and_mandatory_return(self):
        index = load_json("data/conversations/chapter_03_modular_index.json")
        availability = index.get("conversation_availability", {})
        unlocks = availability.get("unlocks", {})
        self.assertEqual(availability.get("initial_conversation_ids"), ["chapter_03_raphaelle_blue_folder"])

        sandra = unlocks["chapter_03_sandra_continuity"]
        marie_offer = unlocks["chapter_03_marie_event_offer"]
        self.assertEqual(sandra.get("after_conversation_completed"), "chapter_03_raphaelle_blue_folder")
        self.assertFalse(sandra.get("notify"))
        self.assertEqual(marie_offer.get("after_conversation_completed"), "chapter_03_raphaelle_blue_folder")

        phases = index.get("timeline_flow", {}).get("phases", [])
        self.assertEqual(
            [phase.get("id") for phase in phases],
            [
                "thursday_raphaelle_work",
                "thursday_sandra_optional",
                "thursday_marie_offer",
                "thursday_selected_topology",
                "thursday_marie_return",
            ],
        )
        self.assertEqual(phases[1].get("optional_conversation_ids"), ["chapter_03_sandra_continuity"])
        self.assertEqual(phases[2].get("required_conversation_ids"), ["chapter_03_marie_event_offer"])

        topology_rules = {
            "chapter_03_marie_event_joined": "opening_topology_join_marie",
            "chapter_03_mathilde_home_charger": "opening_topology_stay_home",
            "chapter_03_raphaelle_late_review": "opening_topology_work_then_join",
        }
        for target, expected_flag in topology_rules.items():
            rule = unlocks[target]
            self.assertEqual(rule.get("after_conversation_completed"), "chapter_03_marie_event_offer")
            self.assertEqual(rule.get("conditions"), [expected_flag])

        return_rule = unlocks["chapter_03_marie_event_return"]
        self.assertEqual(
            return_rule.get("after_any_conversation_completed"),
            [
                "chapter_03_marie_event_joined",
                "chapter_03_mathilde_home_charger",
                "chapter_03_raphaelle_late_review",
            ],
        )

    def test_m1_contains_exactly_three_exclusive_topology_choices(self):
        offer = load_json("data/conversations/chapter_03_marie_event_offer.json")
        segment = next(item for item in offer.get("segments", []) if item.get("id") == "segment_thursday_marie_topology_choice")
        choices = segment.get("choices", [])
        self.assertEqual(len(choices), 3)
        topology_flags = {
            flag
            for choice in choices
            for flag in choice.get("sets_flags", [])
            if str(flag).startswith("opening_topology_")
        }
        self.assertEqual(
            topology_flags,
            {
                "opening_topology_join_marie",
                "opening_topology_stay_home",
                "opening_topology_work_then_join",
            },
        )
        for choice in choices:
            self.assertEqual(len([flag for flag in choice.get("sets_flags", []) if flag.startswith("opening_topology_")]), 1)
            self.assertNotIn("effects", choice)

    def test_each_thursday_foreground_choice_node_has_three_postures_and_flags_only(self):
        cases = [
            ("data/conversations/chapter_03_raphaelle_blue_folder.json", "segment_thursday_raphaelle_work_choice"),
            ("data/conversations/chapter_03_marie_event_joined.json", "segment_thursday_marie_event_participation"),
            ("data/conversations/chapter_03_mathilde_home_charger.json", "segment_thursday_mathilde_home_choice"),
            ("data/conversations/chapter_03_raphaelle_late_review.json", "segment_thursday_raphaelle_late_review"),
        ]
        for relative, segment_id in cases:
            data = load_json(relative)
            segment = next(item for item in data.get("segments", []) if item.get("id") == segment_id)
            self.assertEqual(len(segment.get("choices", [])), 3, relative)
            for choice in segment.get("choices", []):
                self.assertTrue(choice.get("sets_flags"), (relative, choice.get("id")))
                self.assertNotIn("effects", choice)

    def test_threads_and_communication_modes_match_the_topologies(self):
        expected = {
            "data/conversations/chapter_03_raphaelle_blue_folder.json": ("thread_raphaelle_private", "WORK_CHAT"),
            "data/conversations/chapter_03_sandra_continuity.json": ("thread_sandra_private", "REMOTE_ASYNC"),
            "data/conversations/chapter_03_marie_event_offer.json": ("thread_marie_private", "REMOTE_ASYNC"),
            "data/conversations/chapter_03_marie_event_joined.json": ("thread_marie_private", "SAME_VENUE_LOGISTICS"),
            "data/conversations/chapter_03_mathilde_home_charger.json": ("thread_mathilde_private", "SEPARATE_ROOMS_PING"),
            "data/conversations/chapter_03_raphaelle_late_review.json": ("thread_raphaelle_private", "WORK_CHAT"),
            "data/conversations/chapter_03_marie_event_return.json": ("thread_marie_private", "AFTERGLOW_REMOTE"),
        }
        for relative, (thread_id, communication_mode) in expected.items():
            data = load_json(relative)
            self.assertEqual(data.get("thread", {}).get("id"), thread_id, relative)
            self.assertEqual(data.get("communication_mode"), communication_mode, relative)

    def test_return_variants_are_conditionally_exclusive_and_never_offer_a_new_topology(self):
        data = load_json("data/conversations/chapter_03_marie_event_return.json")
        self.assertTrue(data.get("suppress_empty_hint"))
        segment = data.get("segments", [])[0]
        self.assertTrue(segment.get("suppress_empty_hint"))

        scenarios = [
            {"marie_event_initiative"},
            {"marie_event_playful_help"},
            {"marie_event_distracted"},
            {"mathilde_home_help"},
            {"mathilde_home_playful_help"},
            {"mathilde_home_distance"},
            {"work_promise_kept"},
            {"work_promise_amended"},
            {"work_promise_missed"},
        ]
        for flags in scenarios:
            visible_messages = [item for item in segment.get("messages", []) if entry_visible(item, flags)]
            visible_choices = [item for item in segment.get("choices", []) if entry_visible(item, flags)]
            self.assertTrue(visible_messages, flags)
            self.assertLessEqual(len(visible_choices), 1, flags)
            for choice in visible_choices:
                self.assertFalse(any(str(flag).startswith("opening_topology_") for flag in choice.get("sets_flags", [])))

        for node in segment.get("messages", []) + segment.get("choices", []):
            self.assertTrue(node.get("conditions"), node.get("id"))

    def test_player_dialogue_is_choice_driven_in_all_thursday_files(self):
        for relative in self.THURSDAY_FILES:
            data = load_json(relative)
            offenders = [
                node.get("id", "?")
                for node in walk(data)
                if isinstance(node, dict) and str(node.get("sender", "")).lower() in {"ludo", "player", "joueur"}
            ]
            self.assertEqual(offenders, [], relative)

    def test_active_adapters_preserve_v082_foundation(self):
        phone_scene = (GAME / "scenes/smartphone/PhonePrototype.tscn").read_text(encoding="utf-8")
        conversation_scene = (GAME / "scenes/smartphone/ConversationView.tscn").read_text(encoding="utf-8")
        self.assertIn("PhonePrototypeV089.gd", phone_scene)
        self.assertIn("ConversationViewV086A.gd", conversation_scene)

        phone_v089 = (GAME / "scripts/ui/PhonePrototypeV089.gd").read_text(encoding="utf-8")
        phone_v086a = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        phone_v085 = (GAME / "scripts/ui/PhonePrototypeV085.gd").read_text(encoding="utf-8")
        phone_v084 = (GAME / "scripts/ui/PhonePrototypeV084.gd").read_text(encoding="utf-8")
        phone_v082 = (GAME / "scripts/ui/PhonePrototypeV082.gd").read_text(encoding="utf-8")
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV086A.gd"', phone_v089)
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV085.gd"', phone_v086a)
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV084.gd"', phone_v085)
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV082.gd"', phone_v084)
        for expected in [
            'extends "res://scripts/ui/PhonePrototypeV081.gd"',
            "after_any_conversation_completed",
            "_rule_completion_matches",
            "_conditions_are_met",
            'rule.get("notify", true)',
            "EffectApplier.condition_is_met",
        ]:
            self.assertIn(expected, phone_v082)

        conversation_v086a = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        conversation_v084 = (GAME / "scripts/ui/ConversationViewV084.gd").read_text(encoding="utf-8")
        conversation_v082 = (GAME / "scripts/ui/ConversationViewV082.gd").read_text(encoding="utf-8")
        self.assertIn('extends "res://scripts/ui/ConversationViewV084.gd"', conversation_v086a)
        self.assertIn('extends "res://scripts/ui/ConversationViewV082.gd"', conversation_v084)
        for expected in [
            'extends "res://scripts/ui/ConversationViewV081.gd"',
            "_merge_updated_conversation",
            "_segment_merge_key",
            'segment.get("_source_conversation_id"',
            'entry.get("conditions"',
            'entry.get("unless_conditions"',
            "suppress_empty_hint",
            "EffectApplier.condition_is_met",
        ]:
            self.assertIn(expected, conversation_v082)

    def test_thursday_visual_is_authorized_ordinary_and_low_risk(self):
        bundle = load_json("data/visual_content/chapter_03_proofs.json")
        items = {item.get("id"): item for item in bundle.get("items", [])}
        self.assertEqual(set(items), {"marie_laverriere_setup_01"})
        item = items["marie_laverriere_setup_01"]
        self.assertFalse(item.get("is_proof"))
        self.assertEqual(item.get("risk_level"), 0)
        self.assertFalse(item.get("can_set_as_wallpaper"))
        self.assertIn("ordinary", item.get("tags", []))

    def test_no_friday_or_adult_scope_leaks_into_thursday_files(self):
        combined = "\n".join((GAME / path).read_text(encoding="utf-8") for path in self.THURSDAY_FILES).lower()
        for forbidden in [
            "pauline",
            "nico",
            "vendredi",
            "private crop",
            "one-view",
            "cuckold",
            "adult_frame",
            "mathilde.desire",
        ]:
            self.assertNotIn(forbidden, combined)
        self.assertIsNone(re.search(r"\bntr\b", combined), "standalone NTR token found in active Thursday content")


if __name__ == "__main__":
    unittest.main()
