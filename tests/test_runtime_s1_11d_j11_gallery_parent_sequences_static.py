import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
MAP_PATH = "game/data/runtime/season_1/j11_runtime_map.json"
MATHILDE_PARENT = "S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01"
MARIE_PARENT = "S1_A3_J11_SCN_MARIE_COUPLE_STATE_01"
MATHILDE_CHILDREN = [
    "S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01_PROXIMITY",
    "S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_CENTRAL_01",
    "S1_A3_J11_SCN_MATHILDE_SECRET_INTIMACY_AFTERCARE_01",
]
MARIE_CHILDREN = [
    "S1_A3_J11_SCN_MARIE_COUPLE_STATE_01_RECONNECTION",
    "S1_A3_J11_SCN_MARIE_RECONQUEST_ADULT_PAYOFF_01",
    "S1_A3_J11_SCN_MARIE_RECONQUEST_AFTERCARE_01",
]


class RuntimeS111DGalleryParentSequencesStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def load(self, relative: str):
        return json.loads(self.read(relative))

    def method(self, relative: str, name: str) -> str:
        source = self.read(relative)
        marker = f"func {name}"
        self.assertIn(marker, source, relative)
        return marker + source.split(marker, 1)[1].split("\nfunc ", 1)[0]

    def test_required_runtime_test_and_runner_files_exist(self):
        for relative in [
            MAP_PATH,
            "game/scripts/runtime/season_1/J11RuntimeProvider.gd",
            "game/scripts/ui/gallery/GalleryScreen.gd",
            "game/scripts/ui/PortraitShell.gd",
            "game/tests/RUNTIME_S1_11DGalleryParentSequencesSmokeDriver.gd",
            "game/tests/RUNTIME_S1_11DGalleryParentSequencesSmokeTest.tscn",
            "tools/test_runtime_s1_11d_j11_gallery_parent_sequences.sh",
        ]:
            self.assertTrue((ROOT / relative).exists(), relative)

    def test_canonical_parents_reference_exact_ordered_triplets(self):
        runtime_map = self.load(MAP_PATH)
        self.assertEqual("PLAYABLE", runtime_map["implementation_status"])
        self.assertEqual(6, len(runtime_map["conversation_paths"]))
        parents = {item["asset_id"]: item for item in runtime_map["gallery_presentations"]}
        self.assertEqual({MATHILDE_PARENT, MARIE_PARENT}, set(parents))
        self.assertEqual(MATHILDE_CHILDREN, parents[MATHILDE_PARENT]["sequence_child_ids"])
        self.assertEqual(MARIE_CHILDREN, parents[MARIE_PARENT]["sequence_child_ids"])
        self.assertEqual("MATHILDE_J11_SECRET_INTIMACY", parents[MATHILDE_PARENT]["sequence_id"])
        self.assertEqual("MARIE_J11_RECONQUEST", parents[MARIE_PARENT]["sequence_id"])
        for parent in parents.values():
            self.assertEqual("Moment vécu", parent["placeholder_label"])
            self.assertEqual("SCENE_IMAGE", parent["content_type"])

    def test_six_children_are_addressable_non_diegetic_and_not_tiles(self):
        runtime_map = self.load(MAP_PATH)
        children = {item["asset_id"]: item for item in runtime_map["gallery_children"]}
        expected = set(MATHILDE_CHILDREN + MARIE_CHILDREN)
        self.assertEqual(expected, set(children))
        parent_ids = {item["asset_id"] for item in runtime_map["gallery_presentations"]}
        self.assertTrue(expected.isdisjoint(parent_ids))
        for child_id, child in children.items():
            expected_parent = MATHILDE_PARENT if child_id in MATHILDE_CHILDREN else MARIE_PARENT
            self.assertEqual(expected_parent, child["parent_asset_id"])
            self.assertEqual("gallery", child["source_kind"])
            self.assertEqual("SOUVENIR_IMAGE_DE_SCÈNE", child["canonical_type"])
            self.assertFalse(child["is_diegetic"])
            self.assertFalse(child["can_share"])
            self.assertEqual("FORBIDDEN", child["transfer_rule"])
            self.assertFalse(child["discoverable_by_character"])
            self.assertNotIn("state", child)
            self.assertNotIn("is_new", child)

    def test_placeholder_debt_is_explicit_without_fake_final_assets(self):
        runtime_map = self.load(MAP_PATH)
        self.assertIn("aucun asset définitif", runtime_map["gallery_asset_debt"])
        serialized = json.dumps(runtime_map, ensure_ascii=False)
        self.assertNotIn("asset_path", serialized)
        self.assertNotRegex(serialized, r"res://.*\.(?:png|jpe?g|webp)")
        for child in runtime_map["gallery_children"]:
            self.assertRegex(child["placeholder_label"], r"Visuel canonique non produit · [123]/3")

    def test_provider_consumes_unlocks_deduplicates_and_publishes_child_catalog(self):
        gallery_source = self.method("game/scripts/runtime/season_1/J11RuntimeProvider.gd", "gallery_source")
        for token in [
            'gallery_asset_ids.has(asset_id)', 'added_item_keys.has(item_key)',
            'day_map.get("gallery_children", [])', '"children_by_id": included_children',
            'range(2, 12)',
        ]:
            self.assertIn(token, gallery_source)
        for forbidden in [
            "state.", "traces", "knowledge", "outcome", "promise", "obligation",
            "aftercare", "relationship", "TimelineState", "unlock_visual",
        ]:
            self.assertNotIn(forbidden, gallery_source)

    def test_gallery_scopes_parent_sequence_and_fails_closed(self):
        screen = self.read("game/scripts/ui/gallery/GalleryScreen.gd")
        scoped = self.method("game/scripts/ui/gallery/GalleryScreen.gd", "viewer_sequence_for_item")
        grouped = self.method("game/scripts/ui/gallery/GalleryScreen.gd", "_viewer_sequence_for_parent")
        self.assertIn("viewer_sequence_for_selected_character", scoped)
        self.assertIn("_viewer_sequence_for_parent", scoped)
        for token in [
            'content_source.get("children_by_id", {})', 'child.get("parent_asset_id", "")',
            'child.get("source_kind", "")',
            "seen_ids.has(child_id)", "return []",
        ]:
            self.assertIn(token, grouped)
        self.assertNotIn('child.get("character_id", "")', grouped)
        self.assertIn('"character_id": selected_character_id', screen)
        self.assertIn('"parent_sequence"', screen)
        self.assertIn("focus_item_id := origin_item_id if parent_sequence", screen)

    def test_shell_opens_item_scoped_sequence_and_marks_parent_only(self):
        gateway = self.method("game/scripts/ui/PortraitShell.gd", "_on_gallery_photo_requested")
        callback = self.method("game/scripts/ui/PortraitShell.gd", "_on_photo_viewer_current_photo_changed")
        self.assertIn("viewer_sequence_for_item(item_id)", gateway)
        self.assertLess(gateway.index("_open_photo_viewer"), gateway.index("mark_viewed(item_id)"))
        self.assertIn('provenance.get("parent_sequence", false)', callback)
        self.assertIn('provenance.get("item_id", "")', callback)
        self.assertIn("gallery_screen.mark_viewed(photo_id)", callback)

    def test_existing_snapshot_scope_is_preserved_without_fake_seen_persistence(self):
        provider = self.read("game/scripts/runtime/season_1/J11RuntimeProvider.gd")
        snapshot = self.method("game/scripts/runtime/season_1/J11RuntimeProvider.gd", "snapshot")
        restore = self.method("game/scripts/runtime/season_1/J11RuntimeProvider.gd", "restore_snapshot")
        self.assertIn('"gallery_asset_ids"', snapshot)
        self.assertIn('"gallery_asset_ids"', restore)
        self.assertNotIn("is_new", snapshot + restore)
        self.assertNotIn("viewed_gallery", provider)

    def test_smoke_covers_required_matrix_and_photo_viewer_regression(self):
        driver = self.read("game/tests/RUNTIME_S1_11DGalleryParentSequencesSmokeDriver.gd")
        runner = self.read("tools/test_runtime_s1_11d_j11_gallery_parent_sequences.sh")
        for token in [
            "legacy simple entry remains independently openable",
            "Mathilde parent exposes its exact ordered triplet",
            "Marie parent exposes its exact ordered triplet",
            "child leaked into grid", "gallery rebuild creates no duplicate tile",
            "opening Mathilde marks parent viewed", "opening Marie marks parent viewed",
            "missing child fails parent sequence closed",
            "gallery consultation does not mutate narrative state",
            "gallery unlock snapshot round trip is exact",
        ]:
            self.assertIn(token, driver)
        self.assertIn("RUNTIME_S1_11DGalleryParentSequencesSmokeTest.tscn", runner)
        self.assertIn("T_UI_03CPhotoViewerSmokeTest.tscn", runner)


if __name__ == "__main__":
    unittest.main()
