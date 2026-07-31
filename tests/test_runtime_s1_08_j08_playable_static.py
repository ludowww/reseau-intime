import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RuntimeS108J08PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def load(self, relative: str):
        return json.loads(self.read(relative))

    def test_required_files_exist(self):
        required = [
            "game/data/runtime/season_1/j08_runtime_map.json",
            "game/data/conversations/chapter_08_marie_household_and_j09_bridge.json",
            "game/data/conversations/chapter_08_raphaelle_mobile_review_resolution.json",
            "game/data/conversations/chapter_08_nico_chair_resolution.json",
            "game/scripts/runtime/season_1/J08RuntimeProvider.gd",
            "game/tests/RUNTIME_S1_08J08PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_08J08PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_08_j08_playable.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_runtime_map_loads_only_three_canonical_conversations(self):
        data = self.load("game/data/runtime/season_1/j08_runtime_map.json")
        self.assertEqual("Mar.", data["narrative_day_short"])
        self.assertEqual("08:42", data["initial_time"])
        self.assertEqual(
            [
                "chapter_08_marie_household_and_j09_bridge",
                "chapter_08_raphaelle_mobile_review_resolution",
                "chapter_08_nico_chair_resolution",
            ],
            list(data["conversation_paths"]),
        )
        serialized = json.dumps(data, ensure_ascii=False)
        for legacy in [
            "chapter_08_index",
            "chapter_08_raphaelle_clarity",
            "chapter_08_marie_counterpoint",
            "chapter_08_marie_black_dress",
        ]:
            self.assertNotIn(legacy, serialized)

    def test_day_handoffs_continue_through_j08(self):
        j07 = self.load("game/data/runtime/season_1/j07_runtime_map.json")
        j08 = self.load("game/data/runtime/season_1/j08_runtime_map.json")
        self.assertEqual("day_handoff", j07["day_end"]["transition_mode"])
        self.assertFalse(j07["day_end"]["content_end"])
        self.assertEqual("MARDI — MATIN", j07["day_end"]["next_day_presentation"]["eyebrow"])
        self.assertEqual("Ce qui ne tient pas ensemble", j07["day_end"]["next_day_presentation"]["title"])
        self.assertEqual("day_handoff", j08["day_end"]["transition_mode"])
        self.assertFalse(j08["day_end"]["content_end"])
        self.assertEqual("J08 terminé", j08["day_end"]["title"])
        self.assertEqual("MERCREDI — APRÈS-MIDI", j08["day_end"]["next_day_presentation"]["eyebrow"])
        self.assertEqual("Dans son élément", j08["day_end"]["next_day_presentation"]["title"])

    def test_global_priority_labels_are_exact_and_data_only(self):
        data = self.load("game/data/runtime/season_1/j08_runtime_map.json")
        self.assertEqual(
            [
                "Payer l’engagement le plus ancien",
                "Payer la présence physique la plus immédiate",
                "Ne pas choisir clairement",
            ],
            [choice["text"] for choice in data["priority_choices"]],
        )
        dialogue_text = "\n".join(
            self.read(path)
            for path in [
                "game/data/conversations/chapter_08_marie_household_and_j09_bridge.json",
                "game/data/conversations/chapter_08_raphaelle_mobile_review_resolution.json",
                "game/data/conversations/chapter_08_nico_chair_resolution.json",
            ]
        )
        for label in [choice["text"] for choice in data["priority_choices"]]:
            self.assertNotIn(label, dialogue_text)

    def test_signed_fallback_and_key_dialogue_are_exact(self):
        serialized = "\n".join(
            self.read(path)
            for path in [
                "game/data/conversations/chapter_08_marie_household_and_j09_bridge.json",
                "game/data/conversations/chapter_08_raphaelle_mobile_review_resolution.json",
                "game/data/conversations/chapter_08_nico_chair_resolution.json",
            ]
        )
        for line in [
            "je valide le build maintenant. tu as la réponse dans quatre minutes",
            "je termine ma partie maintenant. envoi avant 19 h",
            "J’ouvre à 19 h.",
            "Ta chaise existe jusqu’à 18 h 50.",
            "La pochette bleue est sur le meuble de l’entrée.",
            "Le lien est à jour.",
            "Demain je finis tard à La Verrière.",
            "d’accord. repose-toi avant de sauver la rallonge",
        ]:
            self.assertIn(line, serialized)

    def test_no_forbidden_new_content_contract(self):
        files = [
            self.load("game/data/conversations/chapter_08_marie_household_and_j09_bridge.json"),
            self.load("game/data/conversations/chapter_08_raphaelle_mobile_review_resolution.json"),
            self.load("game/data/conversations/chapter_08_nico_chair_resolution.json"),
        ]
        serialized = json.dumps(files, ensure_ascii=False)
        for forbidden in [
            '"content_id"',
            '"fact_id"',
            '"promise_id"',
            '"trace_id"',
            '"audio"',
            '"call"',
            '"group"',
            '"sandra"',
            '"pauline"',
        ]:
            self.assertNotIn(forbidden, serialized.lower())
        self.assertNotIn("mathilde_state", serialized)

    def test_visual_contract_has_three_parents_and_six_bounded_variants(self):
        data = self.load("game/data/runtime/season_1/j08_runtime_map.json")
        parents = [
            "S1_A2_J08_SCN_RAPHAELLE_WORK_STATE_01",
            "S1_A2_J08_SCN_NICO_CHAIR_STATE_01",
            "S1_A2_J08_SCN_HOUSEHOLD_STATE_01",
        ]
        self.assertEqual(parents, [item["asset_id"] for item in data["gallery_presentations"]])
        self.assertEqual(parents, data["visual_beat_matrix"]["all_paths"])
        self.assertEqual(set(parents), set(data["resolved_visual_variants"]))
        self.assertEqual(6, sum(len(values) for values in data["resolved_visual_variants"].values()))
        self.assertEqual(["marie"], data["gallery_presentations"][2]["character_ids"])
        for item in data["gallery_presentations"]:
            self.assertEqual("SCENE_IMAGE", item["content_type"])
            self.assertFalse(item["is_diegetic"])
            self.assertFalse(item["can_share"])
            self.assertEqual("FORBIDDEN", item["transfer_rule"])
            self.assertFalse(item["eligible_for_j14"])
            self.assertFalse(item["eligible_for_j21"])

    def test_state_uses_bounded_j08_outcomes_without_relationship_progression(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        j08 = state.split("func begin_j08", 1)[1].split("func begin_j09", 1)[0]
        for token in [
            "func begin_j08",
            "func resolve_j08_state_b_household",
            "func resolve_j08_single_obligation",
            "func apply_j08_priority_choice",
            "func complete_j08",
            "PAID_ON_TIME",
            "PAID_LATE",
            "TRANSFERRED_HONESTLY",
            "ABANDONED_VAGUELY",
            "PAID_SHORT",
            "CANCELLED_HONESTLY",
            "FAILED_VAGUE",
            "NOT_DUE",
            "CLEAR_HOURS",
            "HONEST_REFUSAL",
            "VAGUE_OR_MISSED",
        ]:
            self.assertIn(token, state)
        for forbidden in [
            "raphaelle_state =",
            "nico_state =",
            "mathilde_state =",
            "sandra_state =",
            "pauline_state =",
            "couple_state =",
        ]:
            self.assertNotIn(forbidden, j08)
        self.assertIn("const SNAPSHOT_VERSION := 7", state)

    def test_provider_distributes_global_choices_without_transcript_label(self):
        provider = self.read("game/scripts/runtime/season_1/J08RuntimeProvider.gd")
        self.assertIn('if phase == "priority_choice"', provider)
        self.assertIn("state.apply_j08_priority_choice(choice_id)", provider)
        self.assertIn("_append_priority_resolution(choice_id, nico_was_due)", provider)
        priority_block = provider.split("func _apply_priority_choice", 1)[1].split(
            "func _apply_standard_state_choice", 1
        )[0]
        self.assertNotIn("_append_player_choice", priority_block)
        self.assertNotIn('"text": str(selected', priority_block)
        self.assertIn("var before := transcript_for(thread_id).size()", priority_block)
        self.assertIn('"new_messages": transcript_for(thread_id).slice(before)', priority_block)
        self.assertIn("collision_pending_threads", provider)

    def test_visual_smoke_uses_real_messages_screen_for_global_choice(self):
        driver = self.read("game/tests/RUNTIME_S1_08J08PlayableSmokeDriver.gd")
        visual_path = driver.split("func _exercise_real_portrait_surfaces", 1)[1].split(
            "func _advance_to_preparation", 1
        )[0]
        self.assertIn(
            'messages.apply_runtime_choice("choice_j08_priority_vague")',
            visual_path,
        )
        self.assertNotIn(
            'provider.apply_choice("thread_raphaelle_private", "choice_j08_priority_vague")',
            visual_path,
        )
        for token in [
            "global priority UI delivery completes",
            "active visual transcript strictly matches provider",
            "global choices disappear from UI",
            "other-thread messages remain available after resync",
            "real MessagesScreen global vague choice",
        ]:
            self.assertIn(token, visual_path)

    def test_snapshot_versions_and_old_j07_restore_contract(self):
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertIn("const SNAPSHOT_VERSION := 11", season)
        self.assertIn('preload("res://scripts/runtime/season_1/J08RuntimeProvider.gd")', season)
        self.assertIn("[2, 3, 4, 5, 6, 7, 8, 9, 10, SNAPSHOT_VERSION]", season)
        self.assertIn('version < 6 and str(value.get("active_day", "")) == "J07"', season)
        self.assertIn('version < 7 and str(value.get("active_day", "")) == "J08"', season)
        self.assertIn("_handoff_to_j08", season)
        self.assertIn('"J08":', season)
        self.assertIn("const SNAPSHOT_VERSION := 1", self.read("game/scripts/runtime/season_1/J08RuntimeProvider.gd"))

    def test_runner_declares_all_sizes_and_required_capture_labels(self):
        runner = self.read("tools/test_runtime_s1_08_j08_playable.sh")
        driver = self.read("game/tests/RUNTIME_S1_08J08PlayableSmokeDriver.gd")
        for size in ["540x960", "720x800", "720x960", "720x1280", "1080x1920", "1080x2340", "1280x720"]:
            self.assertIn(size, runner)
        for label in [
            "j07_to_j08_handoff",
            "raphaelle_preparation",
            "triple_overlap",
            "global_priority",
            "household_return",
            "gallery_j08",
            "day_end_j08_handoff",
        ]:
            self.assertIn(label, driver)


if __name__ == "__main__":
    unittest.main()
