import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


def load_json(relative: str):
    return json.loads((GAME / relative).read_text(encoding="utf-8"))


class V084TemporalFlowStaticTests(unittest.TestCase):
    def test_timeline_state_is_registered_and_active_scenes_preserve_v084_foundation(self):
        project = (GAME / "project.godot").read_text(encoding="utf-8")
        phone_scene = (GAME / "scenes/smartphone/PhonePrototype.tscn").read_text(encoding="utf-8")
        conversation_scene = (GAME / "scenes/smartphone/ConversationView.tscn").read_text(encoding="utf-8")
        self.assertIn('TimelineState="*res://scripts/core/TimelineState.gd"', project)
        self.assertIn("PhonePrototypeV089.gd", phone_scene)
        self.assertIn("ConversationViewV086A.gd", conversation_scene)

        state = (GAME / "scripts/core/TimelineState.gd").read_text(encoding="utf-8")
        for expected in [
            "unlocked_day_keys",
            "completed_day_keys",
            "current_phase_id_by_day",
            "completed_phase_ids_by_day",
            "skipped_phase_ids_by_day",
            "expired_conversation_ids_by_day",
            "completed_episode_ids_by_day",
            "opened_optional_conversation_ids_by_day",
            "day_log_entries_by_day",
            "record_episode_completed",
            "record_day_log_entry",
            "get_day_log_entries",
            "expire_conversation",
            "reset_timeline",
        ]:
            self.assertIn(expected, state)

        phone_v089 = (GAME / "scripts/ui/PhonePrototypeV089.gd").read_text(encoding="utf-8")
        phone_v086a = (GAME / "scripts/ui/PhonePrototypeV086A.gd").read_text(encoding="utf-8")
        phone_v085 = (GAME / "scripts/ui/PhonePrototypeV085.gd").read_text(encoding="utf-8")
        phone_v084 = (GAME / "scripts/ui/PhonePrototypeV084.gd").read_text(encoding="utf-8")
        conversation_v086a = (GAME / "scripts/ui/ConversationViewV086A.gd").read_text(encoding="utf-8")
        conversation_v084 = (GAME / "scripts/ui/ConversationViewV084.gd").read_text(encoding="utf-8")
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV086A.gd"', phone_v089)
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV085.gd"', phone_v086a)
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV084.gd"', phone_v085)
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV082.gd"', phone_v084)
        self.assertIn('extends "res://scripts/ui/ConversationViewV084.gd"', conversation_v086a)
        self.assertIn('extends "res://scripts/ui/ConversationViewV082.gd"', conversation_v084)

    def test_only_tuesday_is_initially_available_and_six_day_chain_is_explicit(self):
        indexes = [
            load_json("data/conversations/chapter_01_modular_index.json"),
            load_json("data/conversations/chapter_02_modular_index.json"),
            load_json("data/conversations/chapter_03_modular_index.json"),
            load_json("data/conversations/chapter_04_modular_index.json"),
            load_json("data/conversations/chapter_05_modular_index.json"),
            load_json("data/conversations/chapter_06_modular_index.json"),
        ]
        self.assertEqual(
            [index.get("timeline_flow", {}).get("initial_state") for index in indexes],
            ["AVAILABLE", "LOCKED", "LOCKED", "LOCKED", "LOCKED", "LOCKED"],
        )
        self.assertEqual(indexes[0]["timeline_flow"].get("next_day"), 2)
        self.assertEqual(indexes[1]["timeline_flow"].get("next_day"), 3)
        self.assertEqual(indexes[2]["timeline_flow"].get("next_day"), 4)
        self.assertEqual(indexes[3]["timeline_flow"].get("next_day"), 5)
        self.assertEqual(indexes[4]["timeline_flow"].get("next_day"), 6)
        self.assertIsNone(indexes[5]["timeline_flow"].get("next_day"))
        self.assertEqual(indexes[0]["timeline_flow"]["day_end_card"]["eyebrow"], "MARDI — FIN DE JOURNÉE")
        self.assertEqual(indexes[1]["timeline_flow"]["day_start_card"]["eyebrow"], "MERCREDI — MIDI")
        self.assertEqual(indexes[2]["timeline_flow"]["day_start_card"]["eyebrow"], "JEUDI — MATIN")
        self.assertEqual(indexes[3]["timeline_flow"]["day_start_card"]["eyebrow"], "VENDREDI — MATIN")
        self.assertEqual(indexes[4]["timeline_flow"]["day_start_card"]["eyebrow"], "SAMEDI — MATIN")
        self.assertEqual(indexes[5]["timeline_flow"]["day_start_card"]["eyebrow"], "DIMANCHE — MATIN")

    def test_all_active_indexes_define_ordered_timeline_phases(self):
        expected = {
            "data/conversations/chapter_01_modular_index.json": [
                ("tuesday_marie_opening", ["chapter_01_marie_opening"], [], []),
                ("tuesday_shared_evening", [], [], []),
                ("tuesday_sandra_trace", ["chapter_01_sandra_trace"], [], []),
                ("tuesday_marie_final_return", [], [], []),
            ],
            "data/conversations/chapter_02_modular_index.json": [
                ("wednesday_make_room", ["chapter_02_marie_make_room"], [], []),
                ("wednesday_arrival_trace", ["chapter_02_marie_arrival_trace"], [], []),
                ("wednesday_mathilde_arrival", ["chapter_02_mathilde_arrival"], [], []),
            ],
            "data/conversations/chapter_03_modular_index.json": [
                ("thursday_raphaelle_work", ["chapter_03_raphaelle_blue_folder"], [], []),
                ("thursday_sandra_optional", [], ["chapter_03_sandra_continuity"], []),
                ("thursday_marie_offer", ["chapter_03_marie_event_offer"], [], []),
                (
                    "thursday_selected_topology",
                    [],
                    [],
                    [
                        "chapter_03_marie_event_joined",
                        "chapter_03_mathilde_home_charger",
                        "chapter_03_raphaelle_late_review",
                    ],
                ),
                ("thursday_marie_return", ["chapter_03_marie_event_return"], [], []),
            ],
            "data/conversations/chapter_04_modular_index.json": [
                ("friday_pauline_public_relay", ["chapter_04_pauline_public_photo_relay"], [], []),
                ("friday_nico_followup", ["chapter_04_nico_saved_seat_followup"], [], []),
                (
                    "friday_household_echoes",
                    ["chapter_04_marie_household_report", "chapter_04_mathilde_bathroom_correction"],
                    [],
                    [],
                ),
                ("friday_opening_close", [], [], []),
            ],
            "data/conversations/chapter_05_modular_index.json": [
                ("saturday_marie_shared_hour", ["chapter_05_marie_shared_hour"], [], []),
                ("saturday_shared_hour_resolution", [], [], []),
            ],
            "data/conversations/chapter_06_modular_index.json": [
                ("sunday_household_candidate", [], ["chapter_06_mathilde_morning_afterglow"], []),
                ("sunday_marie_return", ["chapter_06_marie_concrete_return"], [], []),
                ("sunday_slice_close", [], [], []),
            ],
        }
        for relative, phase_expectations in expected.items():
            phases = load_json(relative)["timeline_flow"]["phases"]
            actual = [
                (
                    phase.get("id"),
                    phase.get("required_conversation_ids", []),
                    phase.get("optional_conversation_ids", []),
                    phase.get("required_any_conversation_ids", []),
                )
                for phase in phases
            ]
            self.assertEqual(actual, phase_expectations, relative)

    def test_thursday_optional_phase_expires_before_marie(self):
        index = load_json("data/conversations/chapter_03_modular_index.json")
        phases = index["timeline_flow"]["phases"]
        sandra = phases[1]
        marie = phases[2]
        self.assertEqual(sandra.get("time_label"), "13:50")
        self.assertEqual(sandra.get("advance_label"), "Continuer la journée")
        self.assertEqual(sandra.get("skip_sets_flags"), ["thursday_sandra_echo_missed"])
        self.assertEqual(marie.get("time_label"), "16:05")
        self.assertEqual(marie.get("required_conversation_ids"), ["chapter_03_marie_event_offer"])

        phone = (GAME / "scripts/ui/PhonePrototypeV084.gd").read_text(encoding="utf-8")
        for expected in [
            "_add_phase_advance_control",
            "_advance_optional_phase",
            "TimelineState.expire_conversation",
            "TimelineState.mark_optional_opened",
            "EffectApplier.apply_flags",
            "TimelineState.is_episode_completed",
            "_clear_pending_for_episode",
        ]:
            self.assertIn(expected, phone)

    def test_phase_gating_uses_source_episode_completion_and_existing_conditions(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV084.gd").read_text(encoding="utf-8")
        for expected in [
            "TimelineState.record_episode_completed",
            "DataLoader.get_timeline_phase_for_conversation",
            "_phase_requirements_are_met",
            "required_any_conversation_ids",
            "_unlock_rule_ready",
            'rule.get("after_conversation_completed"',
            'rule.get("after_any_conversation_completed"',
            '_conditions_are_met(rule.get("conditions"',
            "TimelineState.is_conversation_expired",
        ]:
            self.assertIn(expected, phone)

        conversation = (GAME / "scripts/ui/ConversationView.gd").read_text(encoding="utf-8")
        self.assertIn("_completion_id_for_current_segment", conversation)
        self.assertIn('data.get("_source_conversation_id"', conversation)

    def test_transition_overlay_remains_available_as_technical_compatibility(self):
        scene = (GAME / "scenes/smartphone/TimelineTransitionView.tscn").read_text(encoding="utf-8")
        script = (GAME / "scripts/ui/TimelineTransitionView.gd").read_text(encoding="utf-8")
        self.assertIn("TimelineTransitionView.gd", scene)
        for expected in [
            "show_moment_transition",
            "show_day_transition",
            "MOUSE_FILTER_STOP",
            "FOCUS_ALL",
            "grab_focus",
            "clear_transition",
            "transition_finished",
        ]:
            self.assertIn(expected, script)

    def test_archive_navigation_is_day_scoped_read_only_and_keeps_day_logs_internal(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV084.gd").read_text(encoding="utf-8")
        for expected in [
            "_render_archived_day",
            "Journée terminée · lecture seule",
            "if TimelineState.is_day_completed(day_value):",
            "if viewing_archived_day:",
            "return false",
        ]:
            self.assertIn(expected, phone)
        archived_block = phone[phone.index("func _render_archived_day") : phone.index("func _on_day_button_pressed")]
        self.assertNotIn("_initialize_initial_pending_for_day", archived_block)
        self.assertNotIn("_refresh_status_time", archived_block)
        self.assertNotIn("GameState.set_context", archived_block)

        v085 = (GAME / "scripts/ui/PhonePrototypeV085.gd").read_text(encoding="utf-8")
        self.assertNotIn('"Moments hors ligne"', v085)
        self.assertNotIn("TimelineState.get_day_log_entries", v085)

        state = (GAME / "scripts/core/TimelineState.gd").read_text(encoding="utf-8")
        self.assertIn("record_day_log_entry", state)
        self.assertIn("get_day_log_entries", state)

        archive = (GAME / "scripts/ui/ConversationViewV084.gd").read_text(encoding="utf-8")
        for expected in [
            "show_archive_conversation",
            "show_timeline_landing",
            'annotated["_source_conversation_id"]',
            "allowed_episode_ids",
            "archived_history",
            "Historique en lecture seule.",
            "_render_archive_history_entry",
            "if not archive_rendering:",
        ]:
            self.assertIn(expected, archive)
        self.assertNotIn("EffectApplier.apply_choice", archive)
        self.assertNotIn("GameState.set_context", archive)

    def test_reset_returns_to_tuesday_and_clears_transition_state(self):
        phone = (GAME / "scripts/ui/PhonePrototypeV084.gd").read_text(encoding="utf-8")
        self.assertIn("TimelineState.reset_timeline()", phone)
        self.assertIn("timeline_transition_view.clear_transition()", phone)
        self.assertIn("transition_in_progress = false", phone)
        state = (GAME / "scripts/core/TimelineState.gd").read_text(encoding="utf-8")
        self.assertIn("unlocked_day_keys[first_key] = true", state)
        self.assertIn("current_day_key = first_key", state)
        self.assertIn("day_log_entries_by_day.clear()", state)

    def test_sunday_is_final_active_day_after_weekend_completion(self):
        loader = (GAME / "scripts/core/DataLoader.gd").read_text(encoding="utf-8")
        active_indexes = loader[loader.index("const CHAPTER_INDEX_PATHS") : loader.index("const LEGACY_CHAPTER_INDEX_PATHS")]
        self.assertIn("chapter_05_modular_index.json", active_indexes)
        self.assertIn("chapter_06_modular_index.json", active_indexes)
        friday = load_json("data/conversations/chapter_04_modular_index.json")
        saturday = load_json("data/conversations/chapter_05_modular_index.json")
        sunday = load_json("data/conversations/chapter_06_modular_index.json")
        self.assertEqual(friday["timeline_flow"].get("next_day"), 5)
        self.assertEqual(saturday["timeline_flow"].get("next_day"), 6)
        self.assertIsNone(sunday["timeline_flow"].get("next_day"))
        self.assertIn("La suite n'est pas encore disponible", sunday["timeline_flow"]["day_end_card"]["subtitle"])


if __name__ == "__main__":
    unittest.main()
