import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RuntimeS106J06PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def load(self, relative: str):
        return json.loads(self.read(relative))

    def test_required_files_exist(self):
        required = [
            "game/data/runtime/season_1/j06_runtime_map.json",
            "game/scripts/runtime/season_1/J06RuntimeProvider.gd",
            "game/tests/RUNTIME_S1_06J06PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_06J06PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_06_j06_playable.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_signed_mathilde_dialogue_is_unchanged(self):
        data = self.load("game/data/conversations/chapter_06_mathilde_morning_afterglow.json")
        self.assertEqual(
            ["segment_sunday_mathilde_opening_reply", "segment_sunday_mathilde_gaze_choice"],
            [segment["id"] for segment in data["segments"]],
        )
        self.assertEqual(
            [
                "choice_sun_mathilde_acknowledge_gaze",
                "choice_sun_mathilde_playful_gaze",
                "choice_sun_mathilde_restore_distance",
            ],
            [choice["id"] for choice in data["segments"][1]["choices"]],
        )
        self.assertEqual(
            [
                "J'ai regardé, oui. Pas une raison pour te mettre mal à l'aise.",
                "J'étais surtout inquiet pour le café. La tenue n'a pas aidé.",
                "J'aurais dû être plus discret. On garde ça simple.",
            ],
            [choice["text"] for choice in data["segments"][1]["choices"]],
        )
        self.assertEqual("sur quoi", data["segments"][0]["choices"][0]["text"])

    def test_signed_marie_variants_and_m3_are_unchanged(self):
        data = self.load("game/data/conversations/chapter_06_marie_concrete_return.json")
        self.assertEqual(
            [
                "segment_sunday_marie_warm_paid_echo",
                "segment_sunday_marie_external_opening",
                "segment_sunday_marie_independent_opening",
                "segment_sunday_marie_return_choice",
            ],
            [segment["id"] for segment in data["segments"]],
        )
        self.assertEqual(
            [
                "choice_sun_marie_return_immediate",
                "choice_sun_marie_return_bounded",
                "choice_sun_marie_return_honest_drift",
            ],
            [choice["id"] for choice in data["segments"][3]["choices"]],
        )
        self.assertEqual("performance historique", data["segments"][0]["choices"][0]["text"])

    def test_visual_matrix_is_exactly_three_beats_per_path(self):
        data = self.load("game/data/runtime/season_1/j06_runtime_map.json")
        self.assertEqual("Dim.", data["narrative_day_short"])
        self.assertEqual("10:25", data["initial_time"])
        self.assertEqual("CONTENT_END", data["day_end"]["transition_mode"])
        self.assertTrue(data["day_end"]["content_end"])
        self.assertEqual(
            [
                "S1_A2_J06_SCN_MATHILDE_LOOK_ACKNOWLEDGED_01",
                "S1_A2_J06_SCN_SUNDAY_WITHOUT_EXTERNAL_PROGRESS_01",
                "S1_A2_J06_SCN_MARIE_CONCRETE_RETURN_01",
            ],
            [item["asset_id"] for item in data["gallery_presentations"]],
        )
        for item in data["gallery_presentations"]:
            self.assertEqual("SCENE_IMAGE", item["content_type"])
            self.assertFalse(item["is_diegetic"])
            self.assertFalse(item["can_share"])
            self.assertEqual("FORBIDDEN", item["transfer_rule"])
        for path in data["visual_beat_matrix"].values():
            self.assertEqual(3, len(path))
            self.assertEqual(3, len(set(path)))
            self.assertEqual("S1_A1_J04_SCN_HOUSEHOLD_THREE_RHYTHM_01", path[1])
            self.assertEqual("S1_A2_J06_SCN_MARIE_CONCRETE_RETURN_01", path[2])
        self.assertEqual(
            ["S1_A1_J02_SCN_MATHILDE_FIRST_INSTALLED_VIEW_01"],
            data["context_anchor_asset_ids"],
        )

    def test_state_has_bounded_j06_records_and_no_artificial_p04(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in [
            "func begin_j06",
            "func is_mathilde_j06_eligible",
            "func apply_j06_mathilde_choice",
            "func apply_j06_marie_choice",
            "func complete_j06",
            "mathilde_j06_outcome",
            "j06_external_continuity_resolution",
            "marie_j06_return_outcome",
            "marie_j06_return_due_at",
            '"ACKNOWLEDGED_RESPECTFUL"',
            '"ACKNOWLEDGED_PLAYFUL"',
            '"DISTANCE_RESTORED"',
            '"LOOK_ACKNOWLEDGED"',
            '"J07 09:30"',
            '"j06_mathilde_look_acknowledged_01"',
            '"fact_mathilde_knows_player_noticed_her"',
            '"TEXT_MESSAGE"',
            '"DIRECT_MESSAGE"',
            '"PRIVATE_DO_NOT_SHARE"',
        ]:
            self.assertIn(token, state)
        eligibility = state.split("func is_mathilde_j06_eligible", 1)[1].split("\nfunc ", 1)[0]
        for token in [
            '["FAMILY_GUEST", "DOMESTIC_FAMILIARITY"]',
            '"fact_mathilde_stay_started"',
            '"j02_mathilde_arrival_room_01"',
            '"ACTIVE"',
        ]:
            self.assertIn(token, eligibility)
        for forbidden in [
            "score",
            "candidate_pool",
            "wave_id",
            "route_owner",
            "R2",
            "sandra_j05_outcome",
        ]:
            self.assertNotIn(forbidden, eligibility)
        self.assertNotIn('promises["j06_external_continuity_window"] = {', state)
        self.assertIn('restored_promises.has("j06_external_continuity_window")', state)

    def test_provider_uses_only_signed_j06_sources_and_common_contracts(self):
        provider = self.read("game/scripts/runtime/season_1/J06RuntimeProvider.gd")
        for token in [
            'preload("res://scripts/runtime/season_1/RuntimeUnread.gd")',
            'preload("res://scripts/runtime/season_1/NarrativeTime.gd")',
            '"source_day": 6',
            '"mathilde_incoming"',
            '"mathilde_exchange"',
            '"household_beat"',
            '"marie_incoming"',
            '"marie_return"',
            '"day_close"',
            '"complete"',
            '"body": "Nouveau message !"',
            "TimelineState.mark_day_complete(6)",
            "served_visual_beat_ids",
        ]:
            self.assertIn(token, provider)
        for forbidden in [
            "chapter_06_index",
            "chapter_06_nico",
            "chapter_06_marie_morning_after_outing",
            "candidate_pool",
            "wave_id",
            "route_owner",
            "R2",
            "ImageMessage",
        ]:
            self.assertNotIn(forbidden, provider)

    def test_j05_hands_off_and_only_j06_is_content_end(self):
        j05 = self.load("game/data/runtime/season_1/j05_runtime_map.json")
        j06 = self.load("game/data/runtime/season_1/j06_runtime_map.json")
        self.assertNotEqual("CONTENT_END", j05["day_end"]["transition_mode"])
        self.assertFalse(j05["day_end"]["content_end"])
        self.assertIn("NEW_DAY", j05["day_close"]["flow_phases"])
        self.assertEqual("DIMANCHE — MATIN", j05["day_close"]["next_day_presentation"]["eyebrow"])
        self.assertEqual("CONTENT_END", j06["day_end"]["transition_mode"])
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        for token in [
            'preload("res://scripts/runtime/season_1/J06RuntimeProvider.gd")',
            "j06_provider",
            "j06_snapshot",
            "_handoff_to_j06",
            'active_day = "J06"',
            '"J06":',
            '["J01", "J02", "J03", "J04", "J05", "J06"]',
        ]:
            self.assertIn(token, season)
        self.assertIn("const SNAPSHOT_VERSION := 5", season)
        self.assertIn("const SNAPSHOT_VERSION := 4", self.read("game/scripts/runtime/season_1/Season1State.gd"))

    def test_closed_characters_and_legacy_are_not_mutated(self):
        provider = self.read("game/scripts/runtime/season_1/J06RuntimeProvider.gd")
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        j06_state = state.split("func begin_j06", 1)[1].split("func apply_j05_marie_choice", 1)[0]
        for forbidden in [
            "sandra_state =",
            "pauline_state =",
            "raphaelle_state =",
            "nico_state =",
        ]:
            self.assertNotIn(forbidden, j06_state)
        serialized = provider + self.read("game/data/runtime/season_1/j06_runtime_map.json")
        for legacy in [
            "chapter_06_marie_morning_after_outing",
            "chapter_06_nico_midday_notices_marie",
            "chapter_06_nico_late_afternoon_limit",
            "chapter_06_marie_evening_recenter",
            "chapter_06_proofs",
        ]:
            self.assertNotIn(legacy, serialized)

    def test_smoke_runner_declares_all_required_sizes(self):
        driver = self.read("game/tests/RUNTIME_S1_06J06PlayableSmokeDriver.gd")
        runner = self.read("tools/test_runtime_s1_06_j06_playable.sh")
        for token in [
            "ACKNOWLEDGED_RESPECTFUL",
            "ACKNOWLEDGED_PLAYFUL",
            "DISTANCE_RESTORED",
            "UNAVAILABLE",
            "WARM_ECHO",
            "IMMEDIATE_ACT",
            "BOUNDED_NEXT_ACT",
            "HONEST_DRIFT",
            "provider.snapshot()",
            "restore_snapshot(snapshot)",
            "thread_has_unread_content",
            "notification_banner.emit_signal",
        ]:
            self.assertIn(token, driver)
        for size in ["540x960", "720x800", "720x960", "720x1280", "1080x1920", "1080x2340", "1280x720"]:
            self.assertIn(size, runner)


if __name__ == "__main__":
    unittest.main()
