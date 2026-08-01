import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RuntimeS109J09PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def load(self, relative: str):
        return json.loads(self.read(relative))

    def test_required_files_exist(self):
        required = [
            "game/data/runtime/season_1/j09_runtime_map.json",
            "game/data/conversations/chapter_09_marie_laverriere.json",
            "game/scripts/runtime/season_1/J09RuntimeProvider.gd",
            "game/tests/RUNTIME_S1_09J09PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_09J09PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_09_j09_playable.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_runtime_map_loads_only_canonical_marie_conversation(self):
        data = self.load("game/data/runtime/season_1/j09_runtime_map.json")
        self.assertEqual("Mer.", data["narrative_day_short"])
        self.assertEqual("15:48", data["initial_time"])
        self.assertEqual(
            {"chapter_09_marie_laverriere": "res://data/conversations/chapter_09_marie_laverriere.json"},
            data["conversation_paths"],
        )
        serialized = json.dumps(data, ensure_ascii=False).lower()
        for forbidden in [
            "chapter_09_index",
            "chapter_09_modular_index",
            "chapter_09_sandra",
            "chapter_09_mathilde",
            "chapter_09_marie_pauline",
            "candidate_pool",
            "routes_available",
            "wave",
            "ticket",
        ]:
            self.assertNotIn(forbidden, serialized)

    def test_j08_j09_and_j10_hand_off_to_playable_j11(self):
        j08 = self.load("game/data/runtime/season_1/j08_runtime_map.json")
        j09 = self.load("game/data/runtime/season_1/j09_runtime_map.json")
        j10 = self.load("game/data/runtime/season_1/j10_runtime_map.json")
        self.assertEqual("day_handoff", j08["day_end"]["transition_mode"])
        self.assertFalse(j08["day_end"]["content_end"])
        self.assertEqual("MERCREDI — APRÈS-MIDI", j08["day_end"]["next_day_presentation"]["eyebrow"])
        self.assertEqual("Dans son élément", j08["day_end"]["next_day_presentation"]["title"])
        self.assertEqual("day_handoff", j09["day_end"]["transition_mode"])
        self.assertFalse(j09["day_end"]["content_end"])
        self.assertEqual("J09 terminé", j09["day_end"]["title"])
        self.assertEqual("Une ligne devient réelle", j09["day_end"]["next_day_presentation"]["title"])
        self.assertEqual("day_handoff", j10["day_end"]["transition_mode"])
        self.assertFalse(j10["day_end"]["content_end"])
        self.assertEqual("Ce qui était encore défendable", j10["day_end"]["next_day_presentation"]["title"])

    def test_exact_hours_and_signed_dialogue_are_data_first(self):
        data = self.load("game/data/conversations/chapter_09_marie_laverriere.json")
        serialized = json.dumps(data, ensure_ascii=False)
        for time_label in ["15:48", "15:49", "16:02", "20:12", "20:37", "23:05", "23:07", "23:10"]:
            self.assertIn(f'"time_label": "{time_label}"', serialized)
        for line in [
            "J’ai besoin de deux bras à 18 h.",
            "Et j’ai envie que tu viennes.",
            "Ce sont deux raisons différentes.",
            "Je te préviens. Je ne relance pas le vote.",
            "Pas pour te faire venir à 21 h.",
            "Élodie vient de me renvoyer la dernière.",
            "Demain, ne bloque rien pour moi.",
            "Mais ce n’est pas pareil.",
            "Demain 20 h 30, tu es là ?",
        ]:
            self.assertIn(line, serialized)
        self.assertEqual(
            [
                "choice_j09_presence_early",
                "choice_j09_presence_late",
                "choice_j09_presence_absent",
            ],
            [choice["id"] for choice in next(segment for segment in data["segments"] if segment["id"] == "j09_presence_choice")["choices"]],
        )

    def test_quality_choices_are_canonical_actions_not_transcript_dialogue(self):
        runtime = self.load("game/data/runtime/season_1/j09_runtime_map.json")
        conversation = self.read("game/data/conversations/chapter_09_marie_laverriere.json")
        labels = [choice["text"] for choice in runtime["early_quality_choices"] + runtime["late_quality_choices"]]
        self.assertEqual(6, len(labels))
        for label in labels:
            self.assertNotIn(label, conversation)
        provider = self.read("game/scripts/runtime/season_1/J09RuntimeProvider.gd")
        block = provider.split("func _apply_quality_choice", 1)[1].split("func _apply_state_choice", 1)[0]
        self.assertNotIn("_append_player_choice", block)
        self.assertNotIn("_append_messages", block)

    def test_four_canonical_gallery_parents_are_separate_from_three_traces(self):
        data = self.load("game/data/runtime/season_1/j09_runtime_map.json")
        asset_ids = [
            "S1_A3_J09_SCN_LAVERRIERE_INSTALLATION_01",
            "S1_A3_J09_DPH_MARIE_BLACK_DRESS_PRIVATE_01",
            "S1_A3_J09_DPH_MARIE_LAVERRIERE_PUBLIC_01",
            "S1_A3_J09_DPH_MARIE_LAVERRIERE_AFTER_01",
        ]
        trace_ids = [
            "j09_marie_black_dress_private_01",
            "j09_marie_laverriere_public_01",
            "j09_marie_laverriere_after_01",
        ]
        presentations = data["gallery_presentations"]
        self.assertEqual(asset_ids, [item["asset_id"] for item in presentations])
        self.assertEqual(asset_ids, data["visual_beat_matrix"]["all_paths"])
        self.assertEqual(4, len(presentations))
        self.assertEqual(4, len(set(asset_ids)))
        self.assertTrue(set(asset_ids).isdisjoint(trace_ids))
        for item in presentations:
            self.assertEqual(["marie"], item["character_ids"])
            self.assertEqual("Visuel canonique non produit", item["placeholder_label"])
            self.assertNotIn("asset_path", item)
            self.assertNotIn("thumbnail_ref", item)
            self.assertNotIn("full_ref", item)
        installation = presentations[0]
        self.assertEqual("SCENE_IMAGE", installation["content_type"])
        self.assertEqual("SOUVENIR_IMAGE_DE_SCÈNE", installation["canonical_type"])
        self.assertEqual(
            "préparation et installation professionnelle de La Verrière",
            installation["function"],
        )
        self.assertFalse(installation["is_diegetic"])
        self.assertFalse(installation["can_share"])
        self.assertEqual("FORBIDDEN", installation["transfer_rule"])
        self.assertFalse(installation["discoverable_by_character"])
        self.assertFalse(installation["eligible_for_j14"])
        self.assertFalse(installation["eligible_for_j21"])
        self.assertNotIn("trace_id", installation)
        photos = presentations[1:]
        self.assertEqual(trace_ids, [item["trace_id"] for item in photos])
        for item in photos:
            self.assertEqual("PHOTO", item["content_type"])
            self.assertTrue(item["is_diegetic"])
            self.assertTrue(item["eligible_for_j14"])
            self.assertTrue(item["eligible_for_j21"])
        self.assertFalse(photos[0]["can_share"])
        self.assertEqual("PUBLIC_SOURCE_RULES", photos[1]["transfer_rule"])
        self.assertFalse(photos[2]["can_share"])
        serialized = json.dumps(data, ensure_ascii=False)
        self.assertNotIn("resolved_visual_variants", serialized)

    def test_state_uses_bounded_outcomes_promises_and_three_registered_facts(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        j09 = state.split("func begin_j09", 1)[1].split("func begin_j10", 1)[0]
        for token in [
            "presence_active",
            "presence_playful_useful",
            "presence_distracted",
            "presence_late_active",
            "presence_spectator",
            "presence_bounded_reliable",
            "absence_honest",
            "marie_j09_dinner_j10_2030",
            "marie_j09_dinner_friday_2030",
            "fact_player_received_marie_black_dress_image",
            "fact_marie_public_professional_version_visible",
            "fact_marie_recontextualized_evening_for_player",
        ]:
            self.assertIn(token, j09)
        self.assertEqual(1, j09.count('"fact_id": "fact_player_received_marie_black_dress_image"'))
        self.assertEqual(1, j09.count('"fact_id": "fact_marie_public_professional_version_visible"'))
        self.assertEqual(1, j09.count('"fact_id": "fact_marie_recontextualized_evening_for_player"'))
        after_trace = j09.split("func establish_j09_after_trace", 1)[1].split("func apply_j09_dinner_choice", 1)[0]
        self.assertIn(
            'traces.has("j09_marie_laverriere_after_01") or knowledge.has("fact_marie_recontextualized_evening_for_player")',
            after_trace,
        )
        for token in [
            '"source_type": "PRIVATE_TRACE"',
            '"source_ref": "j09_marie_laverriere_after_01"',
            '"initial_knowers": ["Marie", "Player"]',
        ]:
            self.assertIn(token, after_trace)
        consistency = state.split("func _j09_records_consistent", 1)[1]
        self.assertIn("has_after != has_f13", consistency)
        self.assertIn('restored_knowledge["fact_marie_recontextualized_evening_for_player"]', consistency)
        self.assertIn('str(f13.get("source_ref", "")) != "j09_marie_laverriere_after_01"', consistency)
        self.assertIn('str(f13.get("source_type", "")) != "PRIVATE_TRACE"', consistency)
        self.assertIn('f13.get("initial_knowers", []) != ["Marie", "Player"]', consistency)
        self.assertEqual(3, j09.count('traces["j09_'))
        self.assertNotIn("S1_A3_J09_SCN_LAVERRIERE_INSTALLATION_01", j09)
        for forbidden in [
            "route_score",
            "candidate_pool",
            "wave_owner",
            "sexual",
            "adult_access",
            "nico_state =",
            "sandra_state =",
            "mathilde_state =",
            "pauline_state =",
            "raphaelle_state =",
        ]:
            self.assertNotIn(forbidden, j09.lower())
        self.assertIn('couple_state = "STRAIN_VISIBLE"', j09)

    def test_snapshot_versions_keep_j08_restore_and_add_j09_once(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertIn("const SNAPSHOT_VERSION := 13", state)
        self.assertIn("const SNAPSHOT_VERSION := 15", season)
        self.assertIn("[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, SNAPSHOT_VERSION]", state)
        self.assertIn("[2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, SNAPSHOT_VERSION]", season)
        self.assertIn('version < 7 and str(value.get("active_day", "")) == "J08"', season)
        self.assertIn('version < 8 and str(value.get("active_day", "")) == "J09"', season)
        self.assertIn('version < 9 and str(value.get("active_day", "")) == "J10"', season)
        self.assertIn('preload("res://scripts/runtime/season_1/J09RuntimeProvider.gd")', season)
        self.assertIn("_handoff_to_j09", season)
        self.assertIn('"J09":', season)
        self.assertIn("state_restore_count += 1", season)
        self.assertEqual(1, season.count("state.restore_snapshot(value[\"state\"])"))

    def test_runner_covers_portrait_landscape_and_required_captures(self):
        runner = self.read("tools/test_runtime_s1_09_j09_playable.sh")
        driver = self.read("game/tests/RUNTIME_S1_09J09PlayableSmokeDriver.gd")
        for size in ["540x960", "720x800", "720x960", "720x1280", "1080x1920", "1080x2340", "1280x720"]:
            self.assertIn(size, runner)
        for label in [
            "j08_to_j09_handoff",
            "main_scene_j09",
            "presence_choice_j09",
            "gallery_j09",
            "content_end_j09",
        ]:
            self.assertIn(label, driver)


if __name__ == "__main__":
    unittest.main()
