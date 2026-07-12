import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"

SATURDAY_INDEX = "data/conversations/chapter_05_modular_index.json"
SUNDAY_INDEX = "data/conversations/chapter_06_modular_index.json"
MARIE_W9 = "data/conversations/chapter_05_marie_shared_hour.json"
MATHILDE_MT1 = "data/conversations/chapter_06_mathilde_morning_afterglow.json"
MARIE_W11 = "data/conversations/chapter_06_marie_concrete_return.json"
NEW_DATA_FILES = [SATURDAY_INDEX, SUNDAY_INDEX, MARIE_W9, MATHILDE_MT1, MARIE_W11]


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


def all_choices(data):
    return [node for node in walk(data) if isinstance(node, dict) and isinstance(node.get("choices"), list) for node in node["choices"]]


def text_values(data):
    return [str(node["text"]) for node in walk(data) if isinstance(node, dict) and "text" in node]


def method_block(source: str, method_name: str, next_method_name: str) -> str:
    return source[source.index(f"func {method_name}") : source.index(f"func {next_method_name}")]


class V089FirstRepetitionStaticTests(unittest.TestCase):
    def test_loader_activates_only_modular_days_five_and_six_and_maps_candidate_ids(self):
        loader = (GAME / "scripts/core/DataLoader.gd").read_text(encoding="utf-8")
        active = loader[loader.index("const CHAPTER_INDEX_PATHS") : loader.index("const LEGACY_CHAPTER_INDEX_PATHS")]
        self.assertIn("chapter_05_modular_index.json", active)
        self.assertIn("chapter_06_modular_index.json", active)
        self.assertNotIn('"res://data/conversations/chapter_05_index.json"', active)
        self.assertNotIn('"res://data/conversations/chapter_06_index.json"', active)
        phase_lookup = method_block(loader, "_timeline_phase_conversation_ids", "get_conversations_for_moment")
        for expected in ["candidate_pool", "ordered_candidates", "conversation_id"]:
            self.assertIn(expected, phase_lookup)

    def test_chronology_is_friday_to_saturday_to_sunday_without_monday(self):
        friday = load_json("data/conversations/chapter_04_modular_index.json")
        saturday = load_json(SATURDAY_INDEX)
        sunday = load_json(SUNDAY_INDEX)
        self.assertEqual(friday["timeline_flow"].get("next_day"), 5)
        self.assertEqual(saturday["timeline_flow"].get("next_day"), 6)
        self.assertIsNone(sunday["timeline_flow"].get("next_day"))
        self.assertEqual(saturday.get("calendar_label"), "Samedi")
        self.assertEqual(sunday.get("calendar_label"), "Dimanche")
        self.assertEqual(saturday.get("day_start_time"), "09:35")
        self.assertEqual(sunday.get("day_start_time"), "10:25")

    def test_saturday_contains_only_marie_w9_and_silent_resolution(self):
        index = load_json(SATURDAY_INDEX)
        self.assertEqual(index.get("conversation_files"), ["res://data/conversations/chapter_05_marie_shared_hour.json"])
        phases = index["timeline_flow"]["phases"]
        self.assertEqual(
            [phase.get("id") for phase in phases],
            ["saturday_marie_shared_hour", "saturday_shared_hour_resolution"],
        )
        variants = phases[1].get("authored_beat_variants", [])
        self.assertEqual(len(variants), 3)
        self.assertTrue(all("sets_flags" in variant for variant in variants))
        self.assertTrue(all("effects" not in variant for variant in variants))

    def test_m2_has_three_real_player_postures_and_flags_only(self):
        data = load_json(MARIE_W9)
        self.assertEqual(data.get("thread", {}).get("id"), "thread_marie_private")
        self.assertEqual(data.get("communication_mode"), "REMOTE_ASYNC")
        segment = data["segments"][0]
        choices = segment.get("choices", [])
        self.assertEqual(len(choices), 3)
        self.assertEqual(
            [choice.get("sets_flags") for choice in choices],
            [
                ["marie_shared_hour_joined"],
                ["marie_shared_hour_rescheduled", "marie_shared_time_scheduled"],
                ["marie_moves_without_player", "marie_weekend_return_scheduled", "parallel_drift_evidence_soft"],
            ],
        )
        self.assertEqual([choice.get("text") for choice in choices], ["oui", "je peux pas tout de suite", "je dois finir deux trucs"])
        self.assertTrue(all(choice.get("next_messages") for choice in choices))
        self.assertTrue(all("effects" not in choice for choice in choices))

    def test_sunday_pool_contains_mathilde_or_silent_defer_only(self):
        index = load_json(SUNDAY_INDEX)
        phases = index["timeline_flow"]["phases"]
        self.assertEqual(
            [phase.get("id") for phase in phases],
            ["sunday_household_candidate", "sunday_marie_return", "sunday_slice_close"],
        )
        pool = phases[0]["candidate_pool"]
        self.assertEqual(pool.get("fallback"), "silent_defer")
        candidates = pool.get("ordered_candidates", [])
        self.assertEqual(len(candidates), 1)
        self.assertEqual(candidates[0].get("character_id"), "mathilde")
        self.assertEqual(candidates[0].get("conversation_id"), "chapter_06_mathilde_morning_afterglow")
        self.assertEqual(phases[1].get("required_conversation_ids"), ["chapter_06_marie_concrete_return"])
        self.assertEqual(phases[2]["authored_beat"].get("sets_flags"), ["first_repetition_slice_01_complete"])
        availability = index["conversation_availability"]
        self.assertEqual(availability.get("initial_conversation_ids"), ["chapter_06_marie_concrete_return"])
        self.assertEqual(availability.get("locked_conversation_ids"), ["chapter_06_mathilde_morning_afterglow"])

    def test_mt1_has_three_choices_one_legal_turn_and_no_permission_escalation(self):
        data = load_json(MATHILDE_MT1)
        self.assertEqual(data.get("thread", {}).get("id"), "thread_mathilde_private")
        self.assertEqual(data.get("communication_mode"), "AFTERGLOW_REMOTE")
        choices = data["segments"][0].get("choices", [])
        self.assertEqual(len(choices), 3)
        self.assertEqual(
            [choice.get("sets_flags") for choice in choices],
            [
                ["mathilde_gaze_acknowledged_soft"],
                ["mathilde_gaze_playful_soft"],
                ["mathilde_distance_respected"],
            ],
        )
        self.assertTrue(all("effects" not in choice for choice in choices))
        dialogue = "\n".join(text_values(data)).lower()
        legal_turns = sum(dialogue.count(term) for term in ["dossier", "objection", "irrecevable", "pièce à conviction", "verdict"])
        self.assertEqual(legal_turns, 1)
        for forbidden in ["permission", "consentement", "photo sexy", "cadre adulte", "secret dur", "séduction délibérée"]:
            self.assertNotIn(forbidden, dialogue)

    def test_marie_return_has_warm_echo_and_exactly_three_m3_actions_when_due(self):
        data = load_json(MARIE_W11)
        self.assertEqual(data.get("thread", {}).get("id"), "thread_marie_private")
        segments = {segment.get("id"): segment for segment in data.get("segments", [])}
        warm = segments["segment_sunday_marie_warm_paid_echo"]
        self.assertEqual(warm.get("choices"), [])
        m3 = segments["segment_sunday_marie_return_choice"].get("choices", [])
        self.assertEqual(len(m3), 3)
        self.assertEqual(
            [choice.get("sets_flags") for choice in m3],
            [
                ["marie_return_immediate_act", "marie_return_paid", "active_reconnection_evidence"],
                ["marie_return_bounded_next_act", "marie_next_morning_obligation_scheduled"],
                ["marie_return_honest_drift", "parallel_drift_evidence"],
            ],
        )
        self.assertTrue(all("effects" not in choice for choice in m3))

    def test_new_conversations_have_unique_ids_no_numeric_effects_and_no_visual_payload(self):
        seen: set[str] = set()
        for relative in [MARIE_W9, MATHILDE_MT1, MARIE_W11]:
            data = load_json(relative)
            for node in walk(data):
                if not isinstance(node, dict):
                    continue
                node_id = str(node.get("id", ""))
                if node_id:
                    self.assertNotIn(node_id, seen, f"duplicate id {node_id}")
                    seen.add(node_id)
                self.assertNotIn("effects", node, relative)
                self.assertNotIn("content_id", node, relative)
            self.assertIn(data.get("thread", {}).get("profile_content_id"), {"profile_marie_placeholder", "profile_mathilde_placeholder"})

    def test_story_ledger_is_seeded_and_helpers_remain_bounded(self):
        state = load_json("data/state/initial_state.json")
        ledger = state["story_ledgers"]["first_repetition"]
        self.assertEqual(
            set(ledger),
            {
                "opportunity_window_ordinal",
                "external_foreground_scene_ids",
                "external_foreground_character_ids",
                "charged_access_owner",
                "scene_status",
                "cooldown_until_ordinal",
                "obligations",
            },
        )
        game_state = (GAME / "scripts/core/GameState.gd").read_text(encoding="utf-8")
        for helper in [
            "ensure_story_ledger",
            "get_story_ledger",
            "set_story_ledger_value",
            "record_external_foreground",
            "claim_charged_access_owner",
            "set_scene_status",
            "set_scene_cooldown",
            "set_obligation_status",
            "get_obligation_status",
        ]:
            self.assertIn(f"func {helper}", game_state)
        self.assertIn("scene_ids.size() >= 2", game_state)
        self.assertIn('if owner != ""', game_state)

    def test_selector_is_deterministic_and_returns_one_candidate_or_empty(self):
        selector = (GAME / "scripts/narrative/FirstRepetitionSelector.gd").read_text(encoding="utf-8")
        for expected in [
            "_has_due_obligation",
            "external_ticket_limit",
            "external_foreground_character_ids",
            "requires_all_flags",
            "excludes_any_flags",
            "cooldown_until_ordinal",
            "compatible_days",
            "compatible_phase_ids",
            "return candidate.duplicate(true)",
            "return {}",
        ]:
            self.assertIn(expected, selector)
        for forbidden in ["rand", "random", "weight", "score_candidate"]:
            self.assertNotIn(forbidden, selector.lower())

    def test_phone_adapter_reuses_v086a_and_records_ticket_only_on_completion(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV089.gd").read_text(encoding="utf-8")
        scene = (GAME / "scenes/smartphone/PhonePrototype.tscn").read_text(encoding="utf-8")
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV086A.gd"', phone)
        self.assertIn("PhonePrototypeV089.gd", scene)
        for status in ["ELIGIBLE", "OFFERED", "SEEN", "DEFERRED", "EXPIRED", "RESOLVED"]:
            self.assertIn(f'"{status}"', phone)
        completion = method_block(phone, "_complete_mathilde_candidate", "_evaluate_mathilde_r2_gate")
        expiry = method_block(phone, "_advance_optional_phase", "_on_conversation_completed")
        self.assertIn("record_external_foreground", completion)
        self.assertNotIn("record_external_foreground", expiry)
        self.assertIn("claim_charged_access_owner", phone)
        self.assertIn("mathilde_r2_charged_access", phone)
        self.assertIn('"CARRIED"', phone)
        self.assertIn('"monday_morning"', phone)

    def test_no_other_external_route_wave_completion_or_adult_frame_is_added(self):
        data_text = "\n".join((GAME / relative).read_text(encoding="utf-8") for relative in NEW_DATA_FILES)
        runtime_text = "\n".join(
            (GAME / relative).read_text(encoding="utf-8")
            for relative in [
                "scripts/narrative/FirstRepetitionSelector.gd",
                "scripts/ui/PhonePrototypeV089.gd",
            ]
        )
        combined = (data_text + "\n" + runtime_text).lower()
        self.assertNotIn("first_repetition_wave_complete", combined)
        for external in ["chapter_06_sandra", "chapter_06_raphaelle", "chapter_06_pauline", "chapter_06_nico"]:
            self.assertNotIn(external, combined)
        for token in ["adult_frame", "hard_secret", "cuckold", "voyeurisme", "alibi"]:
            self.assertIsNone(re.search(rf"\b{re.escape(token)}\b", combined))
        self.assertNotIn("relationship_mode", data_text)

    def test_legal_voice_does_not_leak_to_marie_or_player(self):
        legal_terms = ["objection", "irrecevable", "dossier", "verdict", "accusé", "pièce à conviction", "base contractuelle"]
        for relative in [MARIE_W9, MARIE_W11]:
            text = "\n".join(text_values(load_json(relative))).lower()
            for term in legal_terms:
                self.assertNotIn(term, text, f"voice leakage in {relative}: {term}")
        mathilde = load_json(MATHILDE_MT1)
        for node in walk(mathilde):
            if not isinstance(node, dict) or "text" not in node:
                continue
            sender = str(node.get("sender", "")).lower()
            if sender == "mathilde":
                continue
            lowered = str(node["text"]).lower()
            for term in legal_terms:
                self.assertNotIn(term, lowered, f"Mathilde marker leaked to {sender}: {term}")


if __name__ == "__main__":
    unittest.main()
