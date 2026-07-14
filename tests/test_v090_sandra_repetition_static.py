import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"

MONDAY_INDEX = "data/conversations/chapter_07_modular_index.json"
SANDRA_W12 = "data/conversations/chapter_07_sandra_end_of_shift.json"
MARIE_W13 = "data/conversations/chapter_07_marie_monday_return.json"
NEW_DATA_FILES = [MONDAY_INDEX, SANDRA_W12, MARIE_W13]


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


def method_block(source: str, method_name: str, next_method_name: str) -> str:
    return source[source.index(f"func {method_name}") : source.index(f"func {next_method_name}")]


def is_reusable_thread_definition(node: dict) -> bool:
    return isinstance(node.get("participants"), list) and str(node.get("id", "")).startswith("thread_")


class V090SandraRepetitionStaticTests(unittest.TestCase):
    def test_active_scene_keeps_v090_runtime_under_v092_closure_adapter(self):
        scene = (GAME / "scenes/smartphone/PhonePrototype.tscn").read_text(encoding="utf-8")
        phone_v090 = (GAME / "scripts/ui/PhonePrototypeV090.gd").read_text(encoding="utf-8")
        phone_v092 = (GAME / "scripts/ui/PhonePrototypeV092.gd").read_text(encoding="utf-8")
        self.assertIn("PhonePrototypeV092.gd", scene)
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV090.gd"', phone_v092)
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV089.gd"', phone_v090)
        self.assertIn('MONDAY_INDEX_PATH := "res://data/conversations/chapter_07_modular_index.json"', phone_v090)
        self.assertIn("DataLoader.get_index_for_day(7)", phone_v090)
        self.assertIn("DataLoader._load_index_conversations(index)", phone_v090)
        self.assertNotIn("chapter_07_index.json", phone_v090)

    def test_chronology_unlocks_monday_and_stops_before_tuesday(self):
        sunday = load_json("data/conversations/chapter_06_modular_index.json")
        monday = load_json(MONDAY_INDEX)
        self.assertEqual(sunday["timeline_flow"].get("next_day"), 7)
        self.assertIsNone(monday["timeline_flow"].get("next_day"))
        self.assertEqual(monday.get("calendar_label"), "Lundi")
        self.assertEqual(monday.get("day_start_time"), "09:30")
        self.assertEqual(monday.get("window_range"), "W12-W13")

    def test_monday_phase_order_preserves_v090_prefix_before_v092_close(self):
        index = load_json(MONDAY_INDEX)
        phases = index["timeline_flow"]["phases"]
        self.assertEqual(
            [phase.get("id") for phase in phases],
            [
                "monday_morning_commitment",
                "monday_sandra_end_shift_candidate",
                "monday_sandra_resolution",
                "monday_marie_return",
                "monday_marie_resolution",
                "monday_slice_close",
                "monday_first_repetition_wave_close",
            ],
        )
        morning = phases[0].get("authored_beat_variants", [])
        self.assertEqual(len(morning), 2)
        self.assertEqual(morning[0].get("conditions"), ["marie_next_morning_obligation_scheduled"])
        self.assertIn("marie_monday_morning_paid", morning[0].get("sets_flags", []))
        self.assertEqual(phases[3].get("required_conversation_ids"), ["chapter_07_marie_monday_return"])
        self.assertEqual(phases[5]["authored_beat"].get("sets_flags"), ["first_repetition_slice_02_complete"])
        self.assertEqual(phases[6].get("internal_closure"), "first_repetition")
        self.assertNotIn("sets_flags", phases[6].get("authored_beat", {}))

    def test_sandra_pool_is_single_deterministic_candidate_or_silent_defer(self):
        index = load_json(MONDAY_INDEX)
        phase = index["timeline_flow"]["phases"][1]
        pool = phase["candidate_pool"]
        self.assertEqual(pool.get("fallback"), "silent_defer")
        self.assertEqual(pool.get("external_ticket_limit"), 2)
        candidates = pool.get("ordered_candidates", [])
        self.assertEqual(len(candidates), 1)
        candidate = candidates[0]
        self.assertEqual(candidate.get("scene_id"), "sandra_end_of_shift_twenty_minutes_01")
        self.assertEqual(candidate.get("conversation_id"), "chapter_07_sandra_end_of_shift")
        self.assertEqual(candidate.get("character_id"), "sandra")
        self.assertEqual(
            candidate.get("requires_all_flags"),
            ["first_repetition_slice_01_complete", "j1_sandra_trace_complete"],
        )
        self.assertEqual(candidate.get("compatible_days"), [7])
        self.assertEqual(candidate.get("compatible_phase_ids"), ["monday_sandra_end_shift_candidate"])

    def test_sandra_reuses_persistent_thread_and_prior_echo(self):
        data = load_json(SANDRA_W12)
        self.assertEqual(data.get("thread", {}).get("id"), "thread_sandra_private")
        self.assertEqual(data.get("communication_mode"), "REMOTE_ASYNC")
        text = json.dumps(data, ensure_ascii=False)
        for expected in [
            "sandra_thursday_echo_seen",
            "Le bouton tient toujours.",
            "Tu as raté l'annonce officielle.",
            "café de la photo",
            "vingt minutes avant mon train",
        ]:
            self.assertIn(expected, text)
        opening = data["segments"][0]["messages"]
        missed = next(message for message in opening if message.get("id") == "msg_mon_sandra_shift_001_missed")
        self.assertEqual(missed.get("unless_conditions"), ["sandra_thursday_echo_seen"])
        self.assertNotIn("conditions", missed)
        self.assertFalse(
            any(isinstance(node, dict) and "content_id" in node for node in walk(data)),
            "message payload must not add a visual content_id",
        )
        self.assertEqual(data["thread"].get("profile_content_id"), "profile_sandra_placeholder")

    def test_sandra_has_one_guided_sms_then_three_real_postures(self):
        data = load_json(SANDRA_W12)
        segments = {segment.get("id"): segment for segment in data.get("segments", [])}
        guided = segments["segment_monday_sandra_concrete_trigger"].get("choices", [])
        self.assertEqual(len(guided), 1)
        self.assertTrue(guided[0].get("_guided_reply"))
        self.assertEqual(guided[0].get("text"), "Tu me racontes ça comme une coïncidence ?")
        choices = segments["segment_monday_sandra_twenty_minute_choice"].get("choices", [])
        self.assertEqual(len(choices), 3)
        self.assertEqual(
            [choice.get("text") for choice in choices],
            [
                "Oui. Je suis à dix minutes. Prends-nous une table, j'arrive.",
                "Pas assez près ce soir. Mais on se cale un déjeuner la semaine prochaine.",
                "Non. Garde tes vingt minutes pour souffler. On évite la deuxième photo floue.",
            ],
        )
        self.assertEqual(
            [choice.get("sets_flags") for choice in choices],
            [
                ["sandra_end_shift_joined"],
                ["sandra_lunch_rescheduled", "sandra_next_lunch_scheduled"],
                ["sandra_boundary_respected_soft"],
            ],
        )
        self.assertTrue(all("effects" not in choice for choice in choices))

    def test_sandra_remains_r1_and_never_claims_charged_access(self):
        index = load_json(MONDAY_INDEX)
        phone = (GAME / "scripts/ui/PhonePrototypeV090.gd").read_text(encoding="utf-8")
        self.assertEqual(index.get("route_stage_ceiling"), "SANDRA_R1_MAX")
        completion = method_block(phone, "_complete_sandra_candidate", "_apply_sandra_resolution_state")
        self.assertIn('record_external_foreground(LEDGER_ID, SANDRA_SCENE_ID, "sandra")', completion)
        self.assertIn("set_scene_cooldown", completion)
        self.assertNotIn("claim_charged_access_owner", completion)
        self.assertNotIn("sandra_r2", (json.dumps(index) + phone).lower())

    def test_sandra_resolution_state_is_immediate_and_idempotent_with_authored_beats(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV090.gd").read_text(encoding="utf-8")
        completion = method_block(phone, "_complete_sandra_candidate", "_apply_sandra_resolution_state")
        resolution = method_block(phone, "_apply_sandra_resolution_state", "_pay_monday_morning_obligations")
        self.assertIn("_apply_sandra_resolution_state()", completion)
        for expected in [
            "sandra_end_shift_meeting_complete",
            "sandra_lunch_plan_recorded",
            "sandra_soft_boundary_kept",
            "sandra_r1_repeat_complete",
        ]:
            self.assertIn(expected, resolution)

    def test_ticket_is_consumed_only_on_sandra_completion_not_expiry(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV090.gd").read_text(encoding="utf-8")
        expiry = method_block(phone, "_advance_optional_phase", "_on_conversation_completed")
        completion = method_block(phone, "_complete_sandra_candidate", "_apply_sandra_resolution_state")
        self.assertIn('set_scene_status(LEDGER_ID, SANDRA_SCENE_ID, "EXPIRED")', expiry)
        self.assertIn("TimelineState.expire_conversation", expiry)
        self.assertNotIn("record_external_foreground", expiry)
        self.assertIn("record_external_foreground", completion)
        self.assertIn('set_scene_status(LEDGER_ID, SANDRA_SCENE_ID, "RESOLVED")', completion)

    def test_monday_optional_expiry_uses_debug_speed_without_changing_x1_duration(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV090.gd").read_text(encoding="utf-8")
        schedule = method_block(phone, "_schedule_optional_expiry", "_advance_optional_phase")
        self.assertIn("MONDAY_SANDRA_PHASE_ID", schedule)
        self.assertIn("_scaled_seconds(OPTIONAL_WINDOW_SECONDS)", schedule)
        self.assertIn("await _advance_optional_phase(day_value, phase_id)", schedule)

    def test_carried_monday_obligations_are_paid_before_candidate_selection(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV090.gd").read_text(encoding="utf-8")
        payment = method_block(phone, "_pay_monday_morning_obligations", "_mark_monday_obligations_due")
        self.assertIn("expected_by == MONDAY_MORNING_EXPECTED_BY", payment)
        self.assertIn('status == "CARRIED" and result == "monday_morning"', payment)
        self.assertIn('entry["status"] = "PAID"', payment)
        self.assertIn('entry["resolved_by"] = MONDAY_MORNING_PHASE_ID', payment)
        authored = method_block(phone, "_activate_authored_beat_silently", "_open_conversation")
        self.assertIn("_pay_monday_morning_obligations()", authored)

    def test_marie_return_is_mandatory_and_has_three_manual_actions(self):
        index = load_json(MONDAY_INDEX)
        data = load_json(MARIE_W13)
        self.assertEqual(data.get("thread", {}).get("id"), "thread_marie_private")
        phases = index["timeline_flow"]["phases"]
        self.assertEqual(phases[3].get("required_conversation_ids"), ["chapter_07_marie_monday_return"])
        choices = data["segments"][0].get("choices", [])
        self.assertEqual(len(choices), 3)
        self.assertEqual(
            [choice.get("sets_flags") for choice in choices],
            [
                ["marie_monday_return_active", "marie_monday_return_paid", "active_reconnection_evidence"],
                ["marie_monday_return_bounded", "marie_monday_evening_time_scheduled"],
                ["marie_monday_return_honest_distance", "parallel_drift_evidence_soft"],
            ],
        )
        self.assertTrue(all(str(choice.get("text", "")).strip() for choice in choices))
        self.assertTrue(all("effects" not in choice for choice in choices))

    def test_marie_obligation_is_promoted_due_and_resolved_even_for_direct_probe_completion(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV090.gd").read_text(encoding="utf-8")
        completion = method_block(phone, "_complete_sandra_candidate", "_apply_sandra_resolution_state")
        self.assertIn('"marie_return_after_sandra"', completion)
        self.assertIn('"status": "SCHEDULED"', completion)
        self.assertIn('"expected_by": MONDAY_MARIE_RETURN_PHASE_ID', completion)
        due = method_block(phone, "_mark_monday_obligations_due", "_apply_monday_marie_return_outcome")
        self.assertIn('entry["status"] = "DUE"', due)
        outcome = method_block(phone, "_apply_monday_marie_return_outcome", "_apply_monday_marie_resolution_state")
        self.assertIn("_mark_monday_obligations_due()", outcome)
        self.assertIn('"PAID", "active_return"', outcome)
        self.assertIn('"PAID", "bounded_return"', outcome)
        self.assertIn('"FAILED", "honest_distance"', outcome)

    def test_marie_resolution_state_is_immediate_and_authored_close_remains_separate(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV090.gd").read_text(encoding="utf-8")
        resolution = method_block(phone, "_apply_monday_marie_resolution_state", "_resolve_monday_due_obligations")
        for expected in [
            "marie_monday_return_realized",
            "marie_monday_bounded_time_paid",
            "marie_monday_evening_separate",
            "active_reconnection_evidence",
        ]:
            self.assertIn(expected, resolution)
        self.assertNotIn("first_repetition_slice_02_complete", resolution)

    def test_all_player_messages_are_manual_and_ids_are_unique(self):
        seen: set[str] = set()
        for relative in [SANDRA_W12, MARIE_W13]:
            data = load_json(relative)
            automatic_player_nodes = [
                node.get("id", "?")
                for node in walk(data)
                if isinstance(node, dict) and str(node.get("sender", "")).lower() in {"ludo", "player", "joueur"}
            ]
            self.assertEqual(automatic_player_nodes, [], relative)
            for node in walk(data):
                if not isinstance(node, dict):
                    continue
                node_id = str(node.get("id", ""))
                if node_id and not is_reusable_thread_definition(node):
                    self.assertNotIn(node_id, seen, f"duplicate id {node_id}")
                    seen.add(node_id)
                self.assertNotIn("effects", node, relative)
                self.assertNotIn("content_id", node, relative)

    def test_player_presence_tool_measures_authored_runs_not_flattened_branches(self):
        tool = (ROOT / "tools/player_presence_check.py").read_text(encoding="utf-8")
        for expected in [
            "iter_authored_message_runs",
            "_collapse_same_slot_condition_variants",
            "longest_authored_non_player_streak",
            "runs separated by visible Player choices",
        ]:
            self.assertIn(expected, tool)
        self.assertNotIn("message_presence_stats(messages, player)", tool)

    def test_no_other_route_asset_wave_completion_or_adult_frame_is_added(self):
        data_text = "\n".join((GAME / relative).read_text(encoding="utf-8") for relative in NEW_DATA_FILES)
        phone = (GAME / "scripts/ui/PhonePrototypeV090.gd").read_text(encoding="utf-8")
        combined = (data_text + "\n" + phone).lower()
        for external in ["raphaelle", "pauline", "nico"]:
            self.assertNotIn(external, combined)
        self.assertNotIn("first_repetition_wave_complete", combined)
        for token in ["adult_frame", "hard_secret", "cuckold", "voyeurisme", "alibi", "relationship_mode"]:
            self.assertIsNone(re.search(rf"\b{re.escape(token)}\b", combined))
        self.assertNotIn("claim_charged_access_owner", phone)
        self.assertEqual(load_json(MONDAY_INDEX).get("proof_content_files"), [])

    def test_sandra_voice_markers_do_not_leak_to_marie(self):
        sandra_text = json.dumps(load_json(SANDRA_W12), ensure_ascii=False).lower()
        marie_text = json.dumps(load_json(MARIE_W13), ensure_ascii=False).lower()
        for marker in ["bouton", "photo floue", "mémoire pénible", "presque décevant"]:
            self.assertIn(marker, sandra_text)
            self.assertNotIn(marker, marie_text)
        for forbidden in ["objection", "irrecevable", "pièce à conviction", "verdict"]:
            self.assertNotIn(forbidden, sandra_text + marie_text)


if __name__ == "__main__":
    unittest.main()
