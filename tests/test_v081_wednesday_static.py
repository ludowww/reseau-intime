import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
DATA = GAME / "data"


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


class V081WednesdayStaticTests(unittest.TestCase):
    def test_active_loader_preserves_modular_tuesday_and_wednesday_with_thursday_extension(self):
        loader = (GAME / "scripts/core/DataLoader.gd").read_text(encoding="utf-8")
        active_block = loader[loader.index("const CHAPTER_INDEX_PATHS") : loader.index("const LEGACY_CHAPTER_INDEX_PATHS")]
        self.assertIn("chapter_01_modular_index.json", active_block)
        self.assertIn("chapter_02_modular_index.json", active_block)
        self.assertIn("chapter_03_modular_index.json", active_block)
        for legacy_day in ["chapter_01_index.json", "chapter_02_index.json", "chapter_03_index.json", "chapter_09_index.json"]:
            self.assertNotIn(legacy_day, active_block)
            self.assertIn(legacy_day, loader)
        visual_block = loader[loader.index("const VISUAL_CONTENT_PATHS") : loader.index("const LEGACY_VISUAL_CONTENT_PATHS")]
        self.assertIn("chapter_01_proofs.json", visual_block)
        self.assertIn("chapter_02_proofs.json", visual_block)
        self.assertIn("chapter_03_proofs.json", visual_block)
        self.assertNotIn("chapter_04_proofs.json", visual_block)

    def test_active_phone_scenes_use_v082_adapters_that_extend_v081(self):
        phone_scene = (GAME / "scenes/smartphone/PhonePrototype.tscn").read_text(encoding="utf-8")
        conversation_scene = (GAME / "scenes/smartphone/ConversationView.tscn").read_text(encoding="utf-8")
        self.assertIn("PhonePrototypeV082.gd", phone_scene)
        self.assertIn("ConversationViewV082.gd", conversation_scene)

        phone_v082 = (GAME / "scripts/ui/PhonePrototypeV082.gd").read_text(encoding="utf-8")
        conversation_v082 = (GAME / "scripts/ui/ConversationViewV082.gd").read_text(encoding="utf-8")
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV081.gd"', phone_v082)
        self.assertIn('extends "res://scripts/ui/ConversationViewV081.gd"', conversation_v082)

        phone_adapter = (GAME / "scripts/ui/PhonePrototypeV081.gd").read_text(encoding="utf-8")
        for expected in [
            "status_time_label",
            "narrative_time_by_day",
            "narrative_time_changed",
            "_on_narrative_time_changed",
            "_on_game_state_changed",
            "DataLoader.get_day_display_label",
            "DataLoader.get_day_start_time",
            "_is_episode_available",
            "_refresh_status_time",
            '"--:--"',
        ]:
            self.assertIn(expected, phone_adapter)
        self.assertNotIn("09:41", phone_adapter)

        conversation_adapter = (GAME / "scripts/ui/ConversationViewV081.gd").read_text(encoding="utf-8")
        for expected in [
            '"time_separator"',
            '"offline_beat"',
            "_add_system_note",
            "rendered_authored_keys",
            "_history_contains_authored_item",
            "narrative_time_changed.emit",
            "await super._render_message_with_typing",
        ]:
            self.assertIn(expected, conversation_adapter)

    def test_tuesday_modular_index_filters_deprecated_mathilde_handoff(self):
        index = load_json("data/conversations/chapter_01_modular_index.json")
        self.assertEqual(index.get("calendar_label"), "Mardi")
        self.assertEqual(index.get("day_start_time"), "18:12")
        self.assertEqual(index.get("conversation_files"), [
            "res://data/conversations/chapter_01_marie.json",
            "res://data/conversations/chapter_01_sandra.json",
        ])
        filters = index.get("conversation_filters", {}).get("chapter_01_marie", {})
        self.assertEqual(filters.get("exclude_item_ids"), ["msg_marie_291", "msg_marie_292"])
        self.assertEqual(filters.get("exclude_content_ids"), ["j1_mathilde_bag_domestic_trace"])
        self.assertNotIn("thread_mathilde_private", json.dumps(index, ensure_ascii=False))

        loader = (GAME / "scripts/core/DataLoader.gd").read_text(encoding="utf-8")
        self.assertIn("_apply_conversation_filter", loader)
        self.assertIn("_dictionary_is_excluded", loader)
        self.assertIn("exclude_content_ids", loader)

    def test_wednesday_index_has_exact_sequential_slice(self):
        index = load_json("data/conversations/chapter_02_modular_index.json")
        self.assertEqual(index.get("calendar_label"), "Mercredi")
        self.assertEqual(index.get("display_label"), "Mercredi — Faire de la place")
        self.assertEqual(index.get("day_start_time"), "12:10")
        self.assertEqual(index.get("route_stage_ceiling"), "R1")
        self.assertEqual(index.get("conversation_files"), [
            "res://data/conversations/chapter_02_marie_make_room.json",
            "res://data/conversations/chapter_02_marie_arrival_trace.json",
            "res://data/conversations/chapter_02_mathilde_arrival.json",
        ])
        self.assertEqual(
            [(moment.get("time_label"), moment.get("conversation_ids")) for moment in index.get("moment_flow", [])],
            [
                ("12:10", ["chapter_02_marie_make_room"]),
                ("18:18", ["chapter_02_marie_arrival_trace"]),
                ("18:22", ["chapter_02_mathilde_arrival"]),
            ],
        )
        availability = index.get("conversation_availability", {})
        self.assertEqual(availability.get("initial_conversation_ids"), ["chapter_02_marie_make_room"])
        self.assertEqual(
            availability.get("unlocks", {}).get("chapter_02_marie_arrival_trace", {}).get("after_conversation_completed"),
            "chapter_02_marie_make_room",
        )
        self.assertEqual(
            availability.get("unlocks", {}).get("chapter_02_mathilde_arrival", {}).get("after_conversation_completed"),
            "chapter_02_marie_arrival_trace",
        )

    def test_wednesday_uses_persistent_marie_thread_and_one_mathilde_thread(self):
        make_room = load_json("data/conversations/chapter_02_marie_make_room.json")
        arrival_trace = load_json("data/conversations/chapter_02_marie_arrival_trace.json")
        mathilde = load_json("data/conversations/chapter_02_mathilde_arrival.json")
        self.assertEqual(make_room.get("thread", {}).get("id"), "thread_marie_private")
        self.assertEqual(arrival_trace.get("thread", {}).get("id"), "thread_marie_private")
        self.assertEqual(mathilde.get("thread", {}).get("id"), "thread_mathilde_private")
        self.assertEqual(make_room.get("communication_mode"), "REMOTE_ASYNC")
        self.assertEqual(arrival_trace.get("communication_mode"), "TRACE_DELIVERY")
        self.assertEqual(mathilde.get("communication_mode"), "REMOTE_ASYNC_TO_OFFLINE_BEAT")

    def test_m0_and_mt0_have_exactly_three_posture_choices_and_flags_only(self):
        make_room = load_json("data/conversations/chapter_02_marie_make_room.json")
        mathilde = load_json("data/conversations/chapter_02_mathilde_arrival.json")

        m0 = next(segment for segment in make_room.get("segments", []) if segment.get("id") == "segment_wednesday_marie_make_room_choice")
        mt0 = next(segment for segment in mathilde.get("segments", []) if segment.get("id") == "segment_wednesday_mathilde_welcome_choice")
        self.assertEqual(len(m0.get("choices", [])), 3)
        self.assertEqual(len(mt0.get("choices", [])), 3)

        self.assertEqual(
            {flag for choice in m0["choices"] for flag in choice.get("sets_flags", [])},
            {"opening_make_room_proactive", "opening_make_room_playful", "opening_make_room_passive"},
        )
        self.assertEqual(
            {flag for choice in mt0["choices"] for flag in choice.get("sets_flags", [])},
            {
                "mathilde_arrival_practical",
                "mathilde_arrival_playful",
                "mathilde_arrival_distant",
                "mathilde_stay_active",
                "opening_wednesday_complete",
            },
        )
        for choice in m0["choices"] + mt0["choices"]:
            self.assertNotIn("effects", choice)
            self.assertNotEqual(str(choice.get("text", "")).strip(), "")

    def test_player_lines_remain_choices_not_automatic_messages(self):
        files = [
            "data/conversations/chapter_02_marie_make_room.json",
            "data/conversations/chapter_02_marie_arrival_trace.json",
            "data/conversations/chapter_02_mathilde_arrival.json",
        ]
        for relative in files:
            data = load_json(relative)
            offenders = []
            for node in walk(data):
                if isinstance(node, dict) and str(node.get("sender", "")).lower() in {"ludo", "player", "joueur"}:
                    offenders.append(node.get("id", "?"))
            self.assertEqual(offenders, [], relative)

    def test_arrival_trace_and_offline_beats_have_authored_semantics(self):
        arrival_trace = load_json("data/conversations/chapter_02_marie_arrival_trace.json")
        trace_messages = arrival_trace.get("segments", [])[0].get("messages", [])
        time_separator = next(item for item in trace_messages if item.get("presentation") == "time_separator")
        self.assertTrue(time_separator.get("_system_note"))
        self.assertEqual(time_separator.get("time_label"), "18:18")
        self.assertEqual(
            [item.get("content_id") for item in trace_messages if item.get("content_id")],
            ["mathilde_arrival_room_01"],
        )

        mathilde = load_json("data/conversations/chapter_02_mathilde_arrival.json")
        offline_items = [
            node
            for node in walk(mathilde)
            if isinstance(node, dict) and node.get("presentation") == "offline_beat"
        ]
        self.assertEqual(len(offline_items), 3)
        self.assertEqual(
            {item.get("time_label") for item in offline_items},
            {"18:46", "18:50", "19:15"},
        )
        for offline in offline_items:
            self.assertTrue(offline.get("_system_note"))
            self.assertNotIn("sender", offline)
            self.assertIn("face à face", offline.get("text", ""))

    def test_current_arrival_visual_is_ordinary_low_risk(self):
        bundle = load_json("data/visual_content/chapter_02_proofs.json")
        items = {item.get("id"): item for item in bundle.get("items", [])}
        self.assertEqual(set(items), {"mathilde_arrival_room_01"})
        item = items["mathilde_arrival_room_01"]
        self.assertFalse(item.get("is_proof"))
        self.assertEqual(item.get("risk_level"), 0)
        self.assertFalse(item.get("can_set_as_wallpaper"))
        self.assertIn("ordinary", item.get("tags", []))

    def test_active_wednesday_contains_no_thursday_friday_or_adult_route_content(self):
        combined = "\n".join(
            (GAME / path).read_text(encoding="utf-8")
            for path in [
                "data/conversations/chapter_02_modular_index.json",
                "data/conversations/chapter_02_marie_make_room.json",
                "data/conversations/chapter_02_marie_arrival_trace.json",
                "data/conversations/chapter_02_mathilde_arrival.json",
            ]
        ).lower()
        for forbidden in [
            "canapé",
            "canape",
            "raphaëlle",
            "raphaelle",
            "pauline",
            "nico",
            "ntr",
            "cuckold",
            "mathilde.desire",
            "lie_score",
            "opening_topology_",
        ]:
            self.assertNotIn(forbidden, combined)


if __name__ == "__main__":
    unittest.main()
