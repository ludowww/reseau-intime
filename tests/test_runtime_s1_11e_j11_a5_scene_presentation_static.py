import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MAP_PATH = "game/data/runtime/season_1/j11_runtime_map.json"
PROVIDER_PATH = "game/scripts/runtime/season_1/J11RuntimeProvider.gd"
STATE_PATH = "game/scripts/runtime/season_1/Season1State.gd"


class RuntimeS111EJ11A5ScenePresentationStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def load(self, relative: str):
        return json.loads(self.read(relative))

    def method(self, relative: str, name: str) -> str:
        source = self.read(relative)
        marker = f"func {name}"
        self.assertIn(marker, source, relative)
        return marker + source.split(marker, 1)[1].split("\nfunc ", 1)[0]

    def test_required_runtime_files_and_runner_exist(self):
        for relative in [
            MAP_PATH,
            PROVIDER_PATH,
            STATE_PATH,
            "game/data/conversations/chapter_11_mathilde_return.json",
            "game/data/conversations/chapter_11_marie_return.json",
            "game/scripts/ui/gallery/PhotoViewer.gd",
            "game/scripts/ui/messages/MessagesScreen.gd",
            "game/scripts/ui/PortraitShell.gd",
            "tools/test_runtime_s1_11e_j11_a5_scene_presentation.sh",
        ]:
            self.assertTrue((ROOT / relative).exists(), relative)
        runner = self.read("tools/test_runtime_s1_11e_j11_a5_scene_presentation.sh")
        self.assertIn("--resolution 720x1280", runner)
        self.assertIn('"--demo-size=720x1280"', runner)

    def test_mathilde_has_three_explicit_ceiling_choices(self):
        data = self.load("game/data/conversations/chapter_11_mathilde_return.json")
        segment = next(item for item in data["segments"] if item["id"] == "j11_mathilde_physical_entry")
        self.assertEqual(
            [
                "choice_j11_mathilde_m_b3_accept",
                "choice_j11_mathilde_m_b2_hold",
                "choice_j11_mathilde_physical_stop",
            ],
            [choice["id"] for choice in segment["choices"]],
        )
        serialized = json.dumps(segment, ensure_ascii=False)
        for text in [
            "je veux aller plus loin que ça.",
            "Tu ne complètes pas le reste tout seul.",
            "tu décides chaque étape",
            "je t’embrasse seulement",
            "on s’arrête là",
            "je dors ailleurs comme prévu",
        ]:
            self.assertIn(text, serialized)

    def test_mathilde_b2_b3_state_transitions_are_separate(self):
        provider = self.read(PROVIDER_PATH)
        apply_choice = self.method(PROVIDER_PATH, "_apply_state_choice")
        advance = self.method(PROVIDER_PATH, "_advance_after_choice")
        proximity = apply_choice.split('choice_id == "choice_j11_mathilde_proximity"', 1)[1].split("\n\tif ", 1)[0]
        self.assertIn('set_j11_mathilde_proximity("PROXIMITY_CONSENTED")', proximity)
        self.assertNotIn("MATHILDE_M_B2", proximity)
        self.assertIn('establish_j11_mathilde_physical_event("MATHILDE_M_B3", true)', apply_choice)
        self.assertIn('establish_j11_mathilde_physical_event("MATHILDE_M_B2", true)', apply_choice)
        self.assertIn('resume_after_transition = "mathilde_a5_scene"', advance)
        self.assertIn('resume_after_transition = "mathilde_physical_after"', advance)
        self.assertIn('choice_id == "choice_j11_mathilde_physical_stop"', advance)
        b2_block = advance.split('choice_id == "choice_j11_mathilde_m_b2_hold"', 1)[1].split("\n\telif ", 1)[0]
        self.assertNotIn("_unlock_visual", b2_block)
        self.assertNotIn("MATHILDE_PARENT_ASSET", b2_block)
        self.assertNotIn("_unlock_visual(MATHILDE_PARENT_ASSET)", provider)

    def test_scene_sequence_is_non_diegetic_exact_and_archived_after_completion(self):
        runtime_map = self.load(MAP_PATH)
        provider = self.read(PROVIDER_PATH)
        children = {item["asset_id"]: item for item in runtime_map["gallery_children"]}
        self.assertEqual(6, len(children))
        scene_builder = self.method(PROVIDER_PATH, "_scene_presentations")
        self.assertIn('"source_kind": "scene"', scene_builder)
        self.assertIn('"visual_ref": asset_id', scene_builder)
        self.assertIn('"context_label": "Scène vécue · %d/3"', scene_builder)
        self.assertNotIn('"content_type": "IMAGE"', scene_builder)
        completion = self.method(PROVIDER_PATH, "confirm_scene_sequence")
        self.assertIn("_complete_scene_sequence(MATHILDE_PARENT_ASSET)", completion)
        self.assertIn("_complete_scene_sequence(MARIE_PARENT_ASSET)", completion)
        helper = self.method(PROVIDER_PATH, "_complete_scene_sequence")
        self.assertLess(helper.index("served_visual_beat_ids.append"), helper.index("gallery_asset_ids.append"))
        self.assertIn("pending_scene_asset_ids = []", helper)
        self.assertNotIn("gallery_asset_ids.append", self.method(PROVIDER_PATH, "_begin_scene_sequence"))

    def test_marie_aftercare_and_mathilde_aftercare_resume_after_scene(self):
        completion = self.method(PROVIDER_PATH, "confirm_scene_sequence")
        self.assertIn('resolve_j11_aftercare("aftercare_marie_j11", "PAID", "Marie et Player")', completion)
        self.assertIn('"j11_mathilde_physical_after"', completion)
        self.assertIn("_schedule_day_close()", completion)
        state = self.method(STATE_PATH, "establish_j11_mathilde_physical_event")
        self.assertIn('mathilde_j11_state not in ["UNESTABLISHED", "PROXIMITY_CONSENTED"]', state)
        self.assertIn('level not in ["MATHILDE_M_B2", "MATHILDE_M_B3"]', state)

    def test_pending_scene_is_snapshotted_and_fail_closed(self):
        snapshot = self.method(PROVIDER_PATH, "snapshot")
        restore = self.method(PROVIDER_PATH, "restore_snapshot")
        consistent = self.method(PROVIDER_PATH, "_restored_phase_consistent")
        for token in ["pending_scene_asset_ids", "pending_scene_character_id"]:
            self.assertIn(token, snapshot)
            self.assertIn(token, restore)
            self.assertIn(token, consistent)
        self.assertIn('phase == "mathilde_scene_pending"', consistent)
        self.assertIn("pending_scene_asset_ids == MATHILDE_A5_ASSETS", consistent)
        self.assertIn('phase == "marie_scene_pending"', consistent)
        self.assertIn("pending_scene_asset_ids == MARIE_A5_ASSETS", consistent)

    def test_scene_viewer_requires_all_three_beats_and_uses_locked_fallback(self):
        viewer = self.read("game/scripts/ui/gallery/PhotoViewer.gd")
        shell = self.read("game/scripts/ui/PortraitShell.gd")
        messages = self.read("game/scripts/ui/messages/MessagesScreen.gd")
        for token in [
            'expected_source not in ["messages", "gallery", "scene"]',
            'source_kind() not in ["gallery", "scene"]',
            'back_button.text = "Continuer" if scene_source else "Retour"',
            "back_button.disabled = scene_source and current_index < presentations.size() - 1",
            'source_kind() == "scene" and current_index < presentations.size() - 1',
            "MEDIA_RESOLVER.NOT_DELIVERED_LABEL",
        ]:
            self.assertIn(token, viewer)
        self.assertIn("scene_sequence_requested.connect(_on_scene_sequence_requested)", shell)
        self.assertIn('source == "scene" and photo_viewer.current_index < photo_viewer.presentations.size() - 1', shell)
        self.assertIn("complete_runtime_scene_sequence()", shell)
        self.assertIn("signal scene_sequence_requested", messages)
        self.assertIn("runtime_provider.confirm_scene_sequence()", messages)
        self.assertIn("runtime_provider.pending_scene_sequence()", messages)

    def test_gallery_and_j21_contracts_remain_closed(self):
        runtime_map = self.load(MAP_PATH)
        for parent in runtime_map["gallery_presentations"]:
            self.assertFalse(parent["eligible_for_j21"])
            self.assertFalse(parent["is_diegetic"])
            self.assertFalse(parent["can_share"])
            self.assertEqual("FORBIDDEN", parent["transfer_rule"])
        for child in runtime_map["gallery_children"]:
            self.assertFalse(child["is_diegetic"])
            self.assertFalse(child["can_share"])
            self.assertEqual("FORBIDDEN", child["transfer_rule"])


if __name__ == "__main__":
    unittest.main()
