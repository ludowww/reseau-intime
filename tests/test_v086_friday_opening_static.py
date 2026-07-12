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


def visible_text(data) -> str:
    parts: list[str] = []
    for node in walk(data):
        if not isinstance(node, dict):
            continue
        if "text" in node:
            parts.append(str(node["text"]))
    return "\n".join(parts).lower()


class V086FridayOpeningStaticTests(unittest.TestCase):
    FRIDAY_FILES = [
        "data/conversations/chapter_04_pauline_public_photo_relay.json",
        "data/conversations/chapter_04_nico_saved_seat_followup.json",
        "data/conversations/chapter_04_marie_household_report.json",
        "data/conversations/chapter_04_mathilde_bathroom_correction.json",
    ]

    def test_active_loader_adds_modular_friday_and_keeps_legacy_chapter4_inactive(self):
        loader = (GAME / "scripts/core/DataLoader.gd").read_text(encoding="utf-8")
        active_indexes = loader[
            loader.index("const CHAPTER_INDEX_PATHS") : loader.index("const LEGACY_CHAPTER_INDEX_PATHS")
        ]
        legacy_indexes = loader[
            loader.index("const LEGACY_CHAPTER_INDEX_PATHS") : loader.index("const VISUAL_CONTENT_PATHS")
        ]
        active_visuals = loader[
            loader.index("const VISUAL_CONTENT_PATHS") : loader.index("const LEGACY_VISUAL_CONTENT_PATHS")
        ]
        legacy_visuals = loader[loader.index("const LEGACY_VISUAL_CONTENT_PATHS") :]

        self.assertIn("chapter_04_modular_index.json", active_indexes)
        self.assertNotIn('"res://data/conversations/chapter_04_index.json"', active_indexes)
        self.assertIn("chapter_04_index.json", legacy_indexes)
        self.assertIn("chapter_04_opening_proofs.json", active_visuals)
        self.assertNotIn('"res://data/visual_content/chapter_04_proofs.json"', active_visuals)
        self.assertIn("chapter_04_proofs.json", legacy_visuals)

    def test_thursday_unlocks_friday_and_friday_is_the_final_active_day(self):
        thursday = load_json("data/conversations/chapter_03_modular_index.json")
        friday = load_json("data/conversations/chapter_04_modular_index.json")
        self.assertEqual(thursday["timeline_flow"].get("next_day"), 4)
        self.assertEqual(friday["timeline_flow"].get("initial_state"), "LOCKED")
        self.assertEqual(friday["timeline_flow"]["day_start_card"]["eyebrow"], "VENDREDI — MATIN")
        self.assertIsNone(friday["timeline_flow"].get("next_day"))
        self.assertIn("La suite n'est pas encore disponible", friday["timeline_flow"]["day_end_card"]["subtitle"])

    def test_friday_index_has_exact_moments_phase_order_and_unlock_chain(self):
        index = load_json("data/conversations/chapter_04_modular_index.json")
        self.assertEqual(index.get("calendar_label"), "Vendredi")
        self.assertEqual(index.get("display_label"), "Vendredi — Le lendemain")
        self.assertEqual(index.get("day_start_time"), "08:35")
        self.assertEqual(index.get("route_stage_ceiling"), "R1")
        self.assertEqual(
            index.get("conversation_files"),
            [f"res://{relative}" for relative in self.FRIDAY_FILES],
        )
        self.assertEqual(
            [(moment.get("time_label"), moment.get("conversation_ids")) for moment in index.get("moment_flow", [])],
            [
                ("08:35", ["chapter_04_pauline_public_photo_relay"]),
                ("14:05", ["chapter_04_nico_saved_seat_followup"]),
                ("18:05", ["chapter_04_marie_household_report", "chapter_04_mathilde_bathroom_correction"]),
            ],
        )
        phases = index["timeline_flow"]["phases"]
        self.assertEqual(
            [phase.get("id") for phase in phases],
            [
                "friday_pauline_public_relay",
                "friday_nico_followup",
                "friday_household_echoes",
                "friday_opening_close",
            ],
        )
        self.assertEqual(phases[0].get("required_conversation_ids"), ["chapter_04_pauline_public_photo_relay"])
        self.assertEqual(phases[1].get("required_conversation_ids"), ["chapter_04_nico_saved_seat_followup"])
        self.assertEqual(
            phases[2].get("required_conversation_ids"),
            ["chapter_04_marie_household_report", "chapter_04_mathilde_bathroom_correction"],
        )
        self.assertEqual(phases[3].get("time_label"), "18:25")

        availability = index["conversation_availability"]
        self.assertEqual(availability.get("initial_conversation_ids"), ["chapter_04_pauline_public_photo_relay"])
        unlocks = availability["unlocks"]
        self.assertEqual(
            unlocks["chapter_04_nico_saved_seat_followup"].get("after_conversation_completed"),
            "chapter_04_pauline_public_photo_relay",
        )
        for household_id in ["chapter_04_marie_household_report", "chapter_04_mathilde_bathroom_correction"]:
            self.assertEqual(
                unlocks[household_id].get("after_conversation_completed"),
                "chapter_04_nico_saved_seat_followup",
            )
        self.assertTrue(unlocks["chapter_04_marie_household_report"].get("notify", True))
        self.assertFalse(unlocks["chapter_04_mathilde_bathroom_correction"].get("notify", True))

    def test_pauline_has_one_authorized_public_set_and_exactly_three_p0_choices(self):
        data = load_json("data/conversations/chapter_04_pauline_public_photo_relay.json")
        self.assertEqual(data.get("thread", {}).get("id"), "thread_pauline_private")
        self.assertEqual(data.get("communication_mode"), "TRACE_DELIVERY_REMOTE_ASYNC")
        references = [
            node.get("content_id")
            for node in walk(data)
            if isinstance(node, dict) and node.get("content_id")
        ]
        self.assertEqual(references, ["laverriere_public_group_photo_set_01"])
        p0 = next(segment for segment in data["segments"] if segment.get("id") == "segment_friday_pauline_public_selection")
        self.assertEqual(len(p0.get("choices", [])), 3)
        self.assertEqual(
            {choice.get("tone") for choice in p0["choices"]},
            {"practical", "dry_joke", "defer_to_marie"},
        )
        for choice in p0["choices"]:
            self.assertNotIn("effects", choice)
            self.assertIn("pauline_r1_established", choice.get("sets_flags", []))
            self.assertIn("laverriere_public_group_photo_trace_exists", choice.get("sets_flags", []))

    def test_public_visual_preserves_origin_audience_bastien_and_mathilde_absence(self):
        bundle = load_json("data/visual_content/chapter_04_opening_proofs.json")
        items = {item.get("id"): item for item in bundle.get("items", [])}
        self.assertEqual(set(items), {"laverriere_public_group_photo_set_01"})
        item = items["laverriere_public_group_photo_set_01"]
        self.assertFalse(item.get("is_proof"))
        self.assertEqual(item.get("risk_level"), 0)
        self.assertFalse(item.get("can_set_as_wallpaper"))
        self.assertIn("Pauline remote shutter", item.get("origin", ""))
        self.assertIn("bastien_visible", item.get("tags", []))
        self.assertIn("mathilde_absent", item.get("tags", []))
        self.assertIn("authorized", item.get("tags", []))
        self.assertIn("public_event", item.get("tags", []))
        self.assertIn("photographed_group", item.get("intended_audience", []))
        self.assertIn("laverriere_public_post", item.get("intended_audience", []))

    def test_nico_has_one_opening_variant_and_exactly_three_n0_choices_per_topology(self):
        data = load_json("data/conversations/chapter_04_nico_saved_seat_followup.json")
        self.assertEqual(data.get("thread", {}).get("id"), "thread_nico_private")
        self.assertEqual(data.get("communication_mode"), "REMOTE_ASYNC")
        segment = next(item for item in data["segments"] if item.get("id") == "segment_friday_nico_topology_opening")
        scenarios = [
            {"opening_topology_join_marie"},
            {"opening_topology_stay_home"},
            {"opening_topology_work_then_join", "work_promise_kept"},
            {"opening_topology_work_then_join", "work_promise_amended"},
            {"opening_topology_work_then_join", "work_promise_missed"},
        ]
        for flags in scenarios:
            visible_messages = [entry for entry in segment.get("messages", []) if entry_visible(entry, flags)]
            visible_choices = [entry for entry in segment.get("choices", []) if entry_visible(entry, flags)]
            self.assertEqual(len(visible_messages), 2, flags)
            self.assertEqual(len(visible_choices), 3, flags)
            self.assertEqual(len([choice for choice in visible_choices if choice.get("tone") == "honest"]), 1, flags)
            self.assertEqual(
                {choice.get("tone") for choice in visible_choices},
                {"honest", "playful", "social_mirror"},
            )
            for choice in visible_choices:
                self.assertNotIn("effects", choice)
                self.assertIn("nico_r1_established", choice.get("sets_flags", []))
                self.assertIn("nico_saved_seat_resolved", choice.get("sets_flags", []))

    def test_nico_mathilde_echo_is_ordinary_knowledge_only(self):
        data = load_json("data/conversations/chapter_04_nico_saved_seat_followup.json")
        segment = next(item for item in data["segments"] if item.get("id") == "segment_friday_nico_mathilde_knowledge")
        self.assertEqual(len(segment.get("choices", [])), 1)
        choice = segment["choices"][0]
        self.assertTrue(choice.get("_guided_reply"))
        self.assertEqual(choice.get("sets_flags"), ["nico_knows_mathilde_stay"])
        echo = "\n".join(
            [message.get("text", "") for message in segment.get("messages", [])]
            + [message.get("text", "") for message in choice.get("next_messages", [])]
        ).lower()
        self.assertIn("prises électriques", echo)
        self.assertIn("chaussures", echo)
        for forbidden in ["corps", "sexy", "photo de", "envoie", "jaloux", "jalousie"]:
            self.assertNotIn(forbidden, echo)

    def test_household_echoes_are_separate_choice_free_threads(self):
        marie = load_json("data/conversations/chapter_04_marie_household_report.json")
        mathilde = load_json("data/conversations/chapter_04_mathilde_bathroom_correction.json")
        self.assertEqual(marie.get("thread", {}).get("id"), "thread_marie_private")
        self.assertEqual(mathilde.get("thread", {}).get("id"), "thread_mathilde_private")
        self.assertEqual(marie.get("communication_mode"), "REMOTE_ASYNC")
        self.assertEqual(mathilde.get("communication_mode"), "REMOTE_ASYNC")
        for data in [marie, mathilde]:
            self.assertTrue(data.get("segments"))
            self.assertTrue(all(not segment.get("choices", []) for segment in data["segments"]))
            self.assertFalse(any(node.get("sender") == "ludo" for node in walk(data) if isinstance(node, dict)))

    def test_final_household_beat_completes_opening_without_new_route_state(self):
        index = load_json("data/conversations/chapter_04_modular_index.json")
        final_phase = index["timeline_flow"]["phases"][-1]
        beat = final_phase.get("authored_beat", {})
        self.assertEqual(final_phase.get("id"), "friday_opening_close")
        self.assertEqual(beat.get("time_label"), "18:25")
        self.assertEqual(
            set(beat.get("sets_flags", [])),
            {"household_rhythm_confirmed", "opening_band_complete"},
        )
        self.assertIn("Marie", beat.get("text", ""))
        self.assertIn("Mathilde", beat.get("text", ""))
        self.assertNotIn("effects", beat)
        self.assertIsNone(index["timeline_flow"].get("next_day"))

    def test_friday_player_dialogue_is_choice_driven_and_effects_are_flags_only(self):
        for relative in self.FRIDAY_FILES:
            data = load_json(relative)
            offenders = [
                node.get("id", "?")
                for node in walk(data)
                if isinstance(node, dict) and str(node.get("sender", "")).lower() in {"ludo", "player", "joueur"}
            ]
            self.assertEqual(offenders, [], relative)
            self.assertNotIn('"effects"', json.dumps(data, ensure_ascii=False), relative)

    def test_active_friday_contains_no_private_or_adult_escalation(self):
        data = [load_json(relative) for relative in self.FRIDAY_FILES]
        displayed = "\n".join(visible_text(item) for item in data)
        for forbidden_phrase in [
            "crop privé",
            "recadrage privé",
            "vue unique",
            "photo sexy",
            "envoie-moi une photo",
            "pacte photo",
            "cadre adulte",
        ]:
            self.assertNotIn(forbidden_phrase, displayed)
        for token in ["ntr", "cuckold", "voyeurisme", "alibi"]:
            self.assertIsNone(
                re.search(rf"\b{re.escape(token)}\b", displayed),
                f"standalone forbidden token found in active Friday dialogue: {token}",
            )


if __name__ == "__main__":
    unittest.main()
