import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class RuntimeS105J05PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def load(self, relative: str):
        return json.loads(self.read(relative))

    def test_required_files_exist(self):
        required = [
            "game/data/conversations/chapter_05_sandra_photo_continuity.json",
            "game/data/runtime/season_1/j05_runtime_map.json",
            "game/scripts/runtime/season_1/J05RuntimeProvider.gd",
            "game/tests/RUNTIME_S1_05J05PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_05J05PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_05_j05_playable.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_day_start_content_end_and_visual_contract(self):
        data = self.load("game/data/runtime/season_1/j05_runtime_map.json")
        self.assertEqual("Sam.", data["narrative_day_short"])
        self.assertEqual("09:35", data["initial_time"])
        self.assertEqual(
            {
                "eyebrow": "SAMEDI — MATIN",
                "title": "Une heure réelle",
                "subtitle": "09:35",
                "body": "Marie a déjà commencé sa journée.",
                "action_label": "Commencer",
                "transition_mode": "day_boundary",
            },
            data["day_start"],
        )
        self.assertEqual("CONTENT_END", data["day_end"]["transition_mode"])
        self.assertEqual("J05 terminé", data["day_end"]["title"])
        self.assertEqual(
            "Une heure réelle ne se remplace pas par une intention.",
            data["day_end"]["subtitle"],
        )
        gallery = data["gallery_presentations"]
        self.assertEqual(
            [
                "S1_A2_J05_SCN_MARIE_REAL_HOUR_01",
                "S1_A2_J05_SCN_MARIE_SATURDAY_CONTINUES_01",
            ],
            [item["asset_id"] for item in gallery],
        )
        for item in gallery:
            self.assertEqual(["marie"], item["character_ids"])
            self.assertEqual("SCENE_IMAGE", item["content_type"])
            self.assertFalse(item["is_diegetic"])
            self.assertFalse(item["can_share"])
            self.assertEqual("FORBIDDEN", item["transfer_rule"])
        self.assertEqual(
            [
                "S1_A1_J04_SCN_MARIE_SOCIAL_MOTION_01",
                "S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01",
            ],
            data["reused_asset_ids"],
        )

    def test_marie_source_is_used_directly_with_only_three_choices(self):
        data = self.load("game/data/conversations/chapter_05_marie_shared_hour.json")
        choices = data["segments"][0]["choices"]
        self.assertEqual(
            [
                "choice_sat_marie_join_now",
                "choice_sat_marie_bounded_alternative",
                "choice_sat_marie_moves_independently",
            ],
            [choice["id"] for choice in choices],
        )

    def test_sandra_dialogue_is_exact_and_never_creates_an_image(self):
        data = self.load("game/data/conversations/chapter_05_sandra_photo_continuity.json")
        segments = data["segments"]
        self.assertEqual(
            [
                "Je cherchais la facture du resto.",
                "Je suis retombée sur la photo que je t'avais envoyée.",
                "J'ai failli la supprimer.",
                "Et puis non.",
                "Je l'ai laissée. Voilà.",
            ],
            [message["text"] for message in segments[0]["messages"]],
        )
        self.assertEqual(
            [
                "Tu as bien fait de la garder.",
                "Elle m'a surtout rappelé qu'on ne s'était pas vus depuis longtemps.",
                "Tu peux la supprimer si elle finit par te gêner. Je ne vais pas te demander de la garder.",
                "Garde-la alors. Et si tu en as une autre du même genre, je prends.",
            ],
            [choice["text"] for choice in segments[0]["choices"]],
        )
        self.assertEqual(
            ["D'accord.", "Tu le prends mal pour rien."],
            [choice["text"] for choice in segments[1]["choices"]],
        )
        self.assertEqual(
            ["Non.", "Tu viens juste de me rappeler pourquoi j'avais hésité.", "Bonne nuit."],
            [message["text"] for message in segments[1]["choices"][1]["next_messages"]],
        )
        serialized = json.dumps(data, ensure_ascii=False)
        for forbidden in ["ImageMessage", '"content_type": "IMAGE"', '"trace_id"', '"asset_id"']:
            self.assertNotIn(forbidden, serialized)

    def test_state_has_bounded_j05_outcomes_and_single_p03(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in [
            "marie_j05_shared_hour_outcome",
            "marie_j05_shared_hour_resolution",
            "sandra_j05_outcome",
            '"JOIN_NOW"',
            '"PRECISE_ALTERNATIVE"',
            '"REFUSED"',
            '"PAID"',
            '"NO_PROMISE"',
            '"UNAVAILABLE"',
            '"THREAD_MAINTAINED"',
            '"GAP_ACKNOWLEDGED"',
            '"BOUNDARY_RESPECTED"',
            '"CONTINUITY_COOLED"',
            '"CONTINUITY_CLOSED"',
            '"J05 09:48"',
            '"J05 12:30"',
        ]:
            self.assertIn(token, state)
        self.assertEqual(1, state.count('promises["marie_j05_shared_hour"] = {'))
        refused = state.split('if outcome != "REFUSED":', 1)[1].split("func resolve_j05_marie_hour", 1)[0]
        self.assertNotIn('"status": "REFUSED"', refused)
        eligibility = state.split("func is_sandra_j05_eligible", 1)[1].split("\nfunc ", 1)[0]
        for token in [
            '["JOIN_NOW", "PRECISE_ALTERNATIVE"]',
            'marie_j05_shared_hour_resolution != "PAID"',
            'sandra_state != "RECONNECTION_OPEN"',
            '"j01_sandra_lunch_memory_soft"',
            '"ACTIVE"',
        ]:
            self.assertIn(token, eligibility)
        for forbidden in ["photo_opened", "sandra_j03_echo_outcome", "candidate_pool", "route_score"]:
            self.assertNotIn(forbidden, eligibility)
        self.assertIn("const SNAPSHOT_VERSION := 3", state)
        self.assertIn("version not in [1, 2, SNAPSHOT_VERSION]", state)

    def test_provider_uses_common_runtime_contract(self):
        provider = self.read("game/scripts/runtime/season_1/J05RuntimeProvider.gd")
        for token in [
            'preload("res://scripts/runtime/season_1/RuntimeUnread.gd")',
            "incoming_unread_count",
            "incoming_batch_fully_presented",
            '"source_day": 5',
            '"day_start_pending"',
            '"marie_shared_hour"',
            '"marie_resolution"',
            '"sandra_incoming"',
            '"sandra_exchange"',
            '"sandra_limit_followup"',
            '"day_close"',
            '"complete"',
            '"body": "Nouveau message !"',
            "TimelineState.mark_day_complete(5)",
            "S1_A2_J05_SCN_MARIE_REAL_HOUR_01",
            "S1_A2_J05_SCN_MARIE_SATURDAY_CONTINUES_01",
        ]:
            self.assertIn(token, provider)
        for forbidden in [
            "chapter_05_index",
            "chapter_05_pauline_late_morning",
            "chapter_05_marie_before_outing",
            "candidate_pool",
            "route_owner",
            "route_score",
            "ImageMessage",
        ]:
            self.assertNotIn(forbidden, provider)
        self.assertEqual(1, provider.count('"body": "Nouveau message !"'))

    def test_j04_hands_off_and_only_j05_is_content_end(self):
        j04 = self.load("game/data/runtime/season_1/j04_runtime_map.json")
        j05 = self.load("game/data/runtime/season_1/j05_runtime_map.json")
        self.assertNotEqual("CONTENT_END", j04["day_end"]["transition_mode"])
        self.assertFalse(j04["day_end"]["content_end"])
        self.assertEqual(["CLOCK", "OFF_PHONE", "NIGHT", "NEW_DAY"], j04["household_close"]["flow_phases"])
        self.assertEqual("SAMEDI — MATIN", j04["day_end"]["next_day_presentation"]["eyebrow"])
        self.assertEqual("09:35", j04["day_end"]["next_day_presentation"]["subtitle"])
        self.assertEqual("CONTENT_END", j05["day_end"]["transition_mode"])
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        for token in [
            'preload("res://scripts/runtime/season_1/J05RuntimeProvider.gd")',
            "j05_provider",
            "j05_snapshot",
            "_handoff_to_j05",
            'active_day = "J05"',
            '"J05":',
            '["J01", "J02", "J03", "J04", "J05"]',
        ]:
            self.assertIn(token, season)
        self.assertIn("const SNAPSHOT_VERSION := 4", season)
        self.assertIn("version not in [2, 3, SNAPSHOT_VERSION]", season)

    def test_smoke_and_runner_cover_all_required_paths_and_sizes(self):
        driver = self.read("game/tests/RUNTIME_S1_05J05PlayableSmokeDriver.gd")
        runner = self.read("tools/test_runtime_s1_05_j05_playable.sh")
        for token in [
            "JOIN_NOW",
            "PRECISE_ALTERNATIVE",
            "REFUSED",
            "UNAVAILABLE",
            "THREAD_MAINTAINED",
            "CONTINUITY_COOLED",
            "CONTINUITY_CLOSED",
            "Bonne nuit.",
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
