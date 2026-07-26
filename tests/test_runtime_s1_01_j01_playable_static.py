import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class RuntimeS101J01PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_required_runtime_and_test_files_exist(self):
        required = [
            "game/scripts/runtime/season_1/Season1State.gd",
            "game/scripts/runtime/season_1/J01RuntimeProvider.gd",
            "game/data/runtime/season_1/j01_runtime_map.json",
            "game/tests/RUNTIME_S1_01J01PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_01J01PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_01_j01_playable.sh",
        ]
        self.assertEqual([], [p for p in required if not (ROOT / p).exists()])

    def test_runtime_map_is_bounded_and_canonical(self):
        data = json.loads(self.read("game/data/runtime/season_1/j01_runtime_map.json"))
        self.assertEqual(data["conversation_paths"], {
            "chapter_01_marie_opening": "res://data/conversations/chapter_01_marie_opening.json",
            "chapter_01_sandra_trace": "res://data/conversations/chapter_01_sandra_trace.json",
        })
        image = data["sandra_image"]
        self.assertEqual(image["media_ref"], "S1_A1_J01_DPH_SANDRA_LUNCH_SELECTED_01")
        self.assertEqual(image["trace_id"], "j01_sandra_lunch_memory_soft")
        self.assertEqual(image["after_message_id"], "msg_j1_sandra_trace_004")
        self.assertEqual(image["placeholder_label"], "Visuel non produit")
        self.assertEqual(data["initial_unlocked_threads"], ["thread_marie_private"])

    def test_state_contract_mutations_and_snapshot_are_explicit(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in [
            'current_day := "J01"', 'day_status := "ACTIVE"',
            'couple_state := "BASELINE_SHARED_LIFE"', 'sandra_state := "DISTANT_FRIEND"',
            "marie_j01_shared_evening", "j01_sandra_lunch_memory_soft",
            "fact_marie_player_couple_exists", "fact_sandra_preexisting_friendship",
            "fact_player_saw_sandra_lunch_photo", "func apply_choice(",
            "func activate_sandra_trace(", "func observe_sandra_photo(",
            "func pay_marie_promise(", "func complete_day(",
            "func snapshot() -> Dictionary", "func restore_snapshot(value: Dictionary) -> bool",
        ]:
            self.assertIn(token, state)
        self.assertIn("func restore_snapshot(value: Dictionary) -> bool", state)
        self.assertNotIn("ESTAB" + "LISHED", state)
        for fact_id in [
            "fact_marie_player_couple_exists",
            "fact_sandra_preexisting_friendship",
        ]:
            self.assertRegex(
                state,
                rf'(?s)"{fact_id}"\s*:\s*\{{[^}}]*"certainty"\s*:\s*"CONFIRMED"',
            )
        self.assertIn('not in ["ACTIVE", "AMENDED"]', state)
        self.assertIn('traces.get("j01_sandra_lunch_memory_soft"', state)
        self.assertIn('trace.get("current_state"', state)
        self.assertIn('!= "ACTIVE"', state)

    def test_provider_loads_signed_json_and_exposes_progression_snapshot(self):
        provider = self.read("game/scripts/runtime/season_1/J01RuntimeProvider.gd")
        for token in [
            "DataLoader.load_json", "j01_runtime_map.json", "func presentation_source() -> Dictionary",
            "func apply_choice(thread_id: String, choice_id: String) -> Dictionary",
            "func confirm_transition() -> Dictionary", "func mark_photo_opened() -> bool",
            "func snapshot() -> Dictionary", "func restore_snapshot(value: Dictionary) -> bool",
            "produced_message_ids", "pending_transition", "unlocked_thread_ids",
            "msg_j1_sandra_trace_017_precise", "choice_j1_sandra_precise_observation",
        ]:
            self.assertIn(token, provider)
        self.assertNotIn("EffectApplier", provider)

    def test_production_and_demo_sources_are_separated_before_ready(self):
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        main_scene = self.read("game/scenes/portrait/PortraitMain.tscn")
        demo = self.read("game/scripts/ui/PortraitShellDemo.gd")
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        gallery = self.read("game/scripts/ui/gallery/GalleryScreen.gd")
        self.assertIn('@export_enum("demo", "runtime_s1_j01") var content_mode', shell)
        self.assertIn('content_mode = "runtime_s1_j01"', main_scene)
        self.assertIn('shell.content_mode = "demo"', demo)
        self.assertIn("configure_content_source", messages)
        self.assertIn("configure_content_source", gallery)
        self.assertIn('if content_mode == "demo"', shell)
        self.assertNotIn("MessagesDemoData", main_scene)
        self.assertNotIn("GalleryDemoData", main_scene)

    def test_ui_has_runtime_photo_transition_and_end_contract(self):
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        conversation = self.read("game/scripts/ui/messages/PortraitConversationScreen.gd")
        image = self.read("game/scripts/ui/messages/ImageMessage.gd")
        viewer = self.read("game/scripts/ui/gallery/PhotoViewer.gd")
        day = self.read("game/scripts/ui/messages/DayTransition.gd")
        for token in ["append_runtime_messages", "replace_runtime_choices", "refresh_from_runtime", "apply_runtime_choice"]:
            self.assertIn(token, messages)
        self.assertIn("append_messages", conversation)
        self.assertIn("replace_choices", conversation)
        self.assertIn("placeholder_label", image)
        self.assertIn("placeholder_label", viewer)
        for token in ["eyebrow", "action_label"]:
            self.assertIn(token, day)
        for exact in ["MARDI — FIN DE JOURNÉE", "J01 terminé", "Les choses qu'on remarque", "Fin temporaire de cette version jouable.", "Terminer"]:
            self.assertIn(exact, self.read("game/data/runtime/season_1/j01_runtime_map.json"))

    def test_runner_starts_portrait_main_and_covers_two_portrait_sizes(self):
        driver = self.read("game/tests/RUNTIME_S1_01J01PlayableSmokeDriver.gd")
        runner = self.read("tools/test_runtime_s1_01_j01_playable.sh")
        self.assertIn('preload("res://scenes/portrait/PortraitMain.tscn")', driver)
        self.assertNotIn("PortraitShellDemo", driver)
        self.assertIn("720x1280 1080x1920", runner)
        self.assertIn("RUNTIME_S1_01J01PlayableSmokeTest.tscn", runner)
        for token in ["choice_j1_marie_present", "choice_j1_marie_delayed_flat", "choice_j1_sandra_precise_observation", "choice_j1_sandra_cautious", "snapshot", "Visuel non produit"]:
            self.assertIn(token, driver)


if __name__ == "__main__":
    unittest.main()
