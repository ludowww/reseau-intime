import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RuntimeS107J07PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def load(self, relative: str):
        return json.loads(self.read(relative))

    def test_required_files_exist(self):
        required = [
            "game/data/runtime/season_1/j07_runtime_map.json",
            "game/data/conversations/chapter_07_raphaelle_mobile_review_obligation.json",
            "game/data/conversations/chapter_07_nico_quiet_confidence.json",
            "game/data/conversations/chapter_07_marie_household_request.json",
            "game/scripts/runtime/season_1/J07RuntimeProvider.gd",
            "game/tests/RUNTIME_S1_07J07PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_07J07PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_07_j07_playable.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_runtime_map_has_exact_day_contract(self):
        data = self.load("game/data/runtime/season_1/j07_runtime_map.json")
        self.assertEqual("Lun.", data["narrative_day_short"])
        self.assertEqual("09:30", data["initial_time"])
        self.assertEqual(
            [
                "chapter_07_raphaelle_mobile_review_obligation",
                "chapter_07_nico_quiet_confidence",
                "chapter_07_marie_household_request",
            ],
            list(data["conversation_paths"]),
        )
        self.assertEqual(["OFF_PHONE"], data["morning_consequence"]["flow_phases"])
        self.assertEqual("11:04", data["morning_consequence"]["to_time"])
        self.assertEqual("22:46", data["to_nico"]["to_time"])
        self.assertEqual("23:16", data["to_marie"]["to_time"])
        self.assertEqual("day_handoff", data["day_end"]["transition_mode"])
        self.assertFalse(data["day_end"]["content_end"])
        self.assertEqual("MARDI — MATIN", data["day_end"]["next_day_presentation"]["eyebrow"])
        self.assertEqual("J07 terminé", data["day_end"]["title"])

    def test_visual_contract_is_exactly_three_non_diegetic_beats(self):
        data = self.load("game/data/runtime/season_1/j07_runtime_map.json")
        expected = [
            "S1_A2_J07_SCN_RAPHAELLE_MOBILE_REVIEW_DUE_01",
            "S1_A2_J07_SCN_NICO_AFTER_SERVICE_CONFIDENCE_01",
            "S1_A2_J07_SCN_MARIE_HOUSEHOLD_REQUEST_01",
        ]
        self.assertEqual(expected, [item["asset_id"] for item in data["gallery_presentations"]])
        self.assertEqual(expected, data["visual_beat_matrix"]["all_paths"])
        self.assertEqual(3, len(set(expected)))
        for item in data["gallery_presentations"]:
            self.assertEqual("SCENE_IMAGE", item["content_type"])
            self.assertFalse(item["is_diegetic"])
            self.assertFalse(item["can_share"])
            self.assertFalse(item["discoverable_by_character"])
            self.assertFalse(item["eligible_for_j14"])
            self.assertFalse(item["eligible_for_j21"])
            self.assertEqual("FORBIDDEN", item["transfer_rule"])
        self.assertEqual(
            ["S1_A1_J03_SCN_RAPHAELLE_GARMENT_BAG_01"],
            data["context_anchor_asset_ids"],
        )
        self.assertNotIn("S1_A1_J03_SCN_RAPHAELLE_GARMENT_BAG_01", expected)

    def test_raphaelle_script_is_signed_and_professional_only(self):
        data = self.load("game/data/conversations/chapter_07_raphaelle_mobile_review_obligation.json")
        self.assertEqual(7, data["day"])
        self.assertEqual("WORK_CHAT", data["communication_mode"])
        self.assertEqual("professional_secondary", data["foreground_role"])
        text = self.read("game/data/conversations/chapter_07_raphaelle_mobile_review_obligation.json")
        for line in [
            "Le point client passe à mercredi, 9 h.",
            "La version mobile doit être relue demain avant 19 h.",
            "Je t’envoie le lien à 17 h. C’est toujours ta section.",
            "La version mobile est toujours à toi. Je précise parce que le passé récent est instructif.",
            "oui. si je bloque, je te le dis avant 17 h",
            "j’avais compris le concept",
            "Tu avais aussi compris « à vérifier ».",
            "Ce n’est pas un reproche. C’est une date.",
        ]:
            self.assertIn(line, text)
        self.assertEqual([], data["routes_nourished"])

    def test_nico_has_exact_three_by_three_choices_and_signed_lines(self):
        data = self.load("game/data/conversations/chapter_07_nico_quiet_confidence.json")
        self.assertEqual("major_pivot", data["foreground_role"])
        self.assertEqual("REMOTE_ASYNC", data["communication_mode"])
        self.assertEqual(
            [
                "choice_j07_nico_acknowledge_contradiction",
                "choice_j07_nico_request_social_view",
                "choice_j07_nico_stay_vague",
            ],
            [choice["id"] for choice in data["segments"][2]["choices"]],
        )
        self.assertEqual(
            [
                "choice_j07_nico_tuesday_accepted",
                "choice_j07_nico_thursday_conditional",
                "choice_j07_nico_continuation_closed",
            ],
            [choice["id"] for choice in data["segments"][4]["choices"]],
        )
        text = self.read("game/data/conversations/chapter_07_nico_quiet_confidence.json")
        for line in [
            "Vendredi, tu m’as demandé si Marie avait l’air bien.",
            "Vendredi, on parlait d’une chaise et tu as quand même fini par revenir à Marie.",
            "Ça ne me donne rien.",
            "Mais ne me demande pas un alibi un jour en prétendant que je n’avais rien compris.",
            "Ne me fais pas garder une chaise pour une philosophie.",
        ]:
            self.assertIn(line, text)
        self.assertEqual([], data["routes_nourished"])

    def test_marie_has_four_messages_and_three_exact_choices(self):
        data = self.load("game/data/conversations/chapter_07_marie_household_request.json")
        segment = data["segments"][0]
        self.assertEqual(4, len(segment["messages"]))
        self.assertEqual(
            ["23:16", "23:16", "23:17", "23:17"],
            [message["time_label"] for message in segment["messages"]],
        )
        self.assertEqual(
            [
                "choice_j07_marie_presence_confirmed",
                "choice_j07_marie_precise_alternative",
                "choice_j07_marie_honest_refusal",
            ],
            [choice["id"] for choice in segment["choices"]],
        )
        self.assertEqual([], data["routes_nourished"])

    def test_all_new_ids_are_unique_across_season_and_source_day_is_seven(self):
        occurrences = {}

        def visit(value, path):
            if isinstance(value, dict):
                for key, child in value.items():
                    if key == "id" and isinstance(child, str):
                        occurrences.setdefault(child, []).append(path)
                    visit(child, path)
            elif isinstance(value, list):
                for child in value:
                    visit(child, path)

        for path in sorted((ROOT / "game/data/conversations").glob("*.json")):
            visit(json.loads(path.read_text(encoding="utf-8")), str(path))
        new_ids = set()
        for name in [
            "chapter_07_raphaelle_mobile_review_obligation.json",
            "chapter_07_nico_quiet_confidence.json",
            "chapter_07_marie_household_request.json",
        ]:
            data = json.loads((ROOT / "game/data/conversations" / name).read_text(encoding="utf-8"))

            def collect(value):
                if isinstance(value, dict):
                    for key, child in value.items():
                        if key == "id" and isinstance(child, str) and child.startswith(("msg_", "choice_", "segment_")):
                            self.assertNotIn(child, new_ids)
                            new_ids.add(child)
                        collect(child)
                elif isinstance(value, list):
                    for child in value:
                        collect(child)

            collect(data)
        self.assertTrue(new_ids)
        for new_id in new_ids:
            self.assertEqual(1, len(occurrences.get(new_id, [])), new_id)
        provider = self.read("game/scripts/runtime/season_1/J07RuntimeProvider.gd")
        self.assertIn('"source_day": 7', provider)
        self.assertNotIn('"source_day": 6', provider)

    def test_state_has_bounded_idempotent_j07_records(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in [
            "func begin_j07",
            "func resolve_j07_morning_consequence",
            "func apply_j07_raphaelle_choice",
            "func apply_j07_nico_main_choice",
            "func apply_j07_nico_continuation",
            "func apply_j07_marie_choice",
            "func complete_j07",
            "raphaelle_j07_mobile_review",
            "nico_j07_tuesday_1845",
            "nico_j07_thursday_conditional",
            "marie_j07_household_request",
            "j07_nico_confidence_01",
            "fact_nico_received_player_confidence",
            "CONFIDENCE_ACTIVE",
            "PROFESSIONAL_ONLY",
            "J10 12:00",
            "PRIVATE_DO_NOT_SHARE",
        ]:
            self.assertIn(token, state)
        j07 = state.split("func begin_j07", 1)[1].split("func is_mathilde_j06_eligible", 1)[0]
        for forbidden in [
            "candidate_pool",
            "ticket",
            "wave_id",
            "wave_owner",
            "route_owner",
            "lie_score",
            "truth_tendency",
            "AUTHORIZED_GAZE_PARTNER",
            "CONSCIOUS_ACCOMPLICE",
        ]:
            self.assertNotIn(forbidden, j07)
        self.assertIn("const SNAPSHOT_VERSION := 6", state)

    def test_nico_p06_distinguishes_acceptance_from_refusal_closure(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        n1 = state.split('"choice_j07_nico_tuesday_accepted":', 1)[1].split(
            '"choice_j07_nico_thursday_conditional":', 1
        )[0]
        n3 = state.split('"choice_j07_nico_continuation_closed":', 1)[1].split(
            "\n\t\t_:", 1
        )[0]
        for token in [
            '"accepted_at": "J07 23:01"',
            '"accepted_by_player": true',
            '"due_at": "J08 18:45"',
            '"status": "ACTIVE"',
        ]:
            self.assertIn(token, n1)
        self.assertNotIn('"paid_or_closed_at"', n1)
        for token in [
            '"accepted_at": ""',
            '"accepted_by_player": false',
            '"due_at": ""',
            '"paid_or_closed_at": "J07 23:01"',
            '"paid_or_closed_by": "Player"',
            '"status": "REFUSED"',
        ]:
            self.assertIn(token, n3)
        self.assertNotIn('"promise_id": "nico_j07_thursday_conditional"', n3)

    def test_provider_preserves_unread_time_gallery_and_foreground_contracts(self):
        provider = self.read("game/scripts/runtime/season_1/J07RuntimeProvider.gd")
        for token in [
            'preload("res://scripts/runtime/season_1/RuntimeUnread.gd")',
            'preload("res://scripts/runtime/season_1/NarrativeTime.gd")',
            '"morning_consequence"',
            '"raphaelle_incoming"',
            '"nico_main_choice"',
            '"nico_continuation_choice"',
            '"marie_choice"',
            '"day_close"',
            '"complete"',
            '"body": "Nouveau message !"',
            '"professional_secondary"',
            '"major_pivot"',
            '"household_return"',
            "served_visual_beat_ids",
            "TimelineState.mark_day_complete(7)",
        ]:
            self.assertIn(token, provider)
        serialized = provider + self.read("game/data/runtime/season_1/j07_runtime_map.json")
        for legacy in [
            "chapter_07_index",
            "chapter_07_mathilde_too_close",
            "chapter_07_marie_senses_difference",
            "chapter_07_sandra_lamp_soft",
            "chapter_07_pauline_less_theoretical",
            "chapter_07_sandra_end_of_shift",
            "chapter_07_proofs",
            "j7_mathilde_doorway_after",
            "j7_marie_kitchen_still",
            "j7_sandra_lamp_soft",
        ]:
            self.assertNotIn(legacy, serialized)

    def test_handoff_and_snapshot_versions_are_backward_compatible(self):
        j06 = self.load("game/data/runtime/season_1/j06_runtime_map.json")
        j07 = self.load("game/data/runtime/season_1/j07_runtime_map.json")
        self.assertEqual("day_handoff", j06["day_end"]["transition_mode"])
        self.assertFalse(j06["day_end"]["content_end"])
        self.assertEqual("day_handoff", j07["day_end"]["transition_mode"])
        self.assertFalse(j07["day_end"]["content_end"])
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        for token in [
            'preload("res://scripts/runtime/season_1/J07RuntimeProvider.gd")',
            "j07_provider",
            "j07_snapshot",
            "_handoff_to_j07",
            'active_day = "J07"',
            '"J07":',
            "[2, 3, 4, 5, 6, SNAPSHOT_VERSION]",
            'version < 5 and str(value.get("active_day", "")) == "J06"',
            'version < 6 and str(value.get("active_day", "")) == "J07"',
        ]:
            self.assertIn(token, season)
        self.assertIn("const SNAPSHOT_VERSION := 7", season)

    def test_smoke_runner_declares_all_required_sizes_and_capture_labels(self):
        driver = self.read("game/tests/RUNTIME_S1_07J07PlayableSmokeDriver.gd")
        runner = self.read("tools/test_runtime_s1_07_j07_playable.sh")
        for token in [
            "CONTRADICTION_ACKNOWLEDGED",
            "SOCIAL_VIEW_REQUESTED",
            "CONFIDENCE_DECLINED",
            "TUESDAY_ACCEPTED",
            "THURSDAY_CONDITIONAL",
            "CONTINUATION_CLOSED",
            "PRESENCE_CONFIRMED",
            "PRECISE_ALTERNATIVE",
            "HONEST_REFUSAL",
            "provider.snapshot()",
            "restore_snapshot(snapshot)",
            "raphaelle_unread",
            "nico_main_choices",
            "nico_continuation_choices",
            "marie_choices",
            "gallery_j07",
            "content_end",
        ]:
            self.assertIn(token, driver)
        for size in ["540x960", "720x800", "720x960", "720x1280", "1080x1920", "1080x2340", "1280x720"]:
            self.assertIn(size, runner)


if __name__ == "__main__":
    unittest.main()
