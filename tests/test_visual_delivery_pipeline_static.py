import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class VisualDeliveryPipelineStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_pipeline_files_and_landscape_smoke_exist(self):
        required = [
            "game/scripts/ui/media/VisualMediaResolver.gd",
            "game/tests/VisualDeliveryPipelineSmokeDriver.gd",
            "game/tests/VisualDeliveryPipelineSmokeTest.tscn",
            "game/tests/fixtures/visual_delivery_test_pattern.svg",
            "game/tests/fixtures/visual_delivery_test_pattern.svg.import",
            "tools/test_visual_delivery_pipeline.sh",
        ]
        self.assertEqual([path for path in required if not (ROOT / path).exists()], [])
        runner = self.read("tools/test_visual_delivery_pipeline.sh")
        self.assertIn("--import", runner)
        self.assertIn("--resolution 1280x720", runner)
        self.assertIn("VisualDeliveryPipelineSmokeTest.tscn", runner)
        self.assertLess(runner.index("--import"), runner.index("VisualDeliveryPipelineSmokeTest.tscn"))

    def test_resolver_distinguishes_delivery_states_and_loads_defensively(self):
        resolver = self.read("game/scripts/ui/media/VisualMediaResolver.gd")
        for token in [
            'STATUS_LOADED := "LOADED"',
            'STATUS_MISSING_REFERENCE := "MISSING_REFERENCE"',
            'STATUS_INVALID_REFERENCE := "INVALID_REFERENCE"',
            'STATUS_DEVELOPMENT_PLACEHOLDER := "DEVELOPMENT_PLACEHOLDER"',
            'STATUS_NOT_DELIVERED := "NOT_DELIVERED"',
            'STATUS_LOAD_FAILED := "LOAD_FAILED"',
            'NOT_DELIVERED_LABEL := "Visuel non livré"',
            "DataLoader.get_visual_content(normalized_reference)",
            'asset_status in ["PROTOTYPE", "PLACEHOLDER", "DEVELOPMENT_PLACEHOLDER"]',
            "ResourceLoader.exists(asset_path)",
            'ResourceLoader.load(asset_path, "", ResourceLoader.CACHE_MODE_REUSE)',
            "not resource is Texture2D",
        ]:
            self.assertIn(token, resolver)
        for forbidden in [
            "FileAccess",
            "Image.load_from_file",
            "ImageTexture.create_from_image",
            "ProjectSettings.globalize_path",
        ]:
            self.assertNotIn(forbidden, resolver)
        self.assertIn('normalized_reference.begins_with("res://")', resolver)
        self.assertIn('asset_path.begins_with(PLACEHOLDER_ROOT)', resolver)

    def test_existing_catalog_is_completed_without_direct_asset_paths_in_ui(self):
        loader = self.read("game/scripts/core/DataLoader.gd")
        self.assertIn('"res://data/visual_content/chapter_08_named_boundaries_visuals.json"', loader)
        self.assertIn('"res://data/visual_content/chapter_09_named_boundaries_visuals.json"', loader)
        for relative in [
            "game/scripts/ui/messages/ImageMessage.gd",
            "game/scripts/ui/gallery/GalleryTile.gd",
            "game/scripts/ui/gallery/PhotoViewer.gd",
        ]:
            source = self.read(relative)
            self.assertIn('preload("res://scripts/ui/media/VisualMediaResolver.gd")', source)
            self.assertNotRegex(source, r'res://assets/.*\.(png|jpe?g|webp)')

    def test_prototype_demo_is_not_used_as_the_delivered_fixture(self):
        prototype_reference = "marie_tuesday_black_dress_mirror_01"
        messages = self.read("game/scripts/ui/messages/MessagesDemoData.gd")
        gallery = self.read("game/scripts/ui/gallery/GalleryDemoData.gd")
        catalog = self.read("game/data/visual_content/chapter_08_named_boundaries_visuals.json")
        smoke = self.read("game/tests/VisualDeliveryPipelineSmokeDriver.gd")
        self.assertIn(prototype_reference, messages)
        self.assertIn('PROTOTYPE_DEMO_REF := "marie_tuesday_black_dress_mirror_01"', gallery)
        self.assertRegex(catalog, r'"id": "marie_tuesday_black_dress_mirror_01"[\s\S]*?"asset_status": "PROTOTYPE"')
        self.assertIn('const TECHNICAL_REF := "pipeline_technical_texture"', smoke)
        self.assertIn('const TECHNICAL_PATH := "res://tests/fixtures/visual_delivery_test_pattern.svg"', smoke)
        self.assertIn('DataLoader.visual_content_by_id[TECHNICAL_REF]', smoke)
        self.assertNotIn("pipeline_technical_texture", self.read("game/scripts/core/DataLoader.gd"))
        self.assertTrue((ROOT / "game/tests/fixtures/visual_delivery_test_pattern.svg").exists())
        sidecar = self.read("game/tests/fixtures/visual_delivery_test_pattern.svg.import")
        self.assertIn('source_file="res://tests/fixtures/visual_delivery_test_pattern.svg"', sidecar)

    def test_smoke_covers_texture_fallback_placeholder_ratio_and_thumbnail(self):
        driver = self.read("game/tests/VisualDeliveryPipelineSmokeDriver.gd")
        for token in [
            "valid imported texture must load a Texture2D through ResourceLoader",
            "ResourceLoader cache must reuse the loaded Texture2D",
            "PROTOTYPE must resolve to DEVELOPMENT_PLACEHOLDER",
            "PROTOTYPE must never expose a loaded texture",
            "empty reference status mismatch",
            "invalid reference status mismatch",
            "development placeholder status mismatch",
            "not-delivered status mismatch",
            "missing resource must remain LOAD_FAILED without crashing",
            "wrong resource type must remain LOAD_FAILED without crashing",
            "ImageMessage must load a valid imported texture",
            "ImageMessage must open the requested content",
            "GalleryTile must load valid thumbnail_ref",
            "PhotoViewer must load valid visual_ref",
            "PhotoViewer must preserve texture aspect ratio",
            "PhotoViewer frame ratio mismatch at 1280x720",
            "PhotoViewer must hide placeholder_label for a valid texture",
            "PROTOTYPE ImageMessage must display Visuel non livré",
            "PROTOTYPE GalleryTile must display Visuel non livré",
            "PROTOTYPE PhotoViewer must display Visuel non livré",
        ]:
            self.assertIn(token, driver)

    def test_no_export_preset_requires_static_resource_loader_guard(self):
        self.assertFalse((ROOT / "game/export_presets.cfg").exists())
        resolver = self.read("game/scripts/ui/media/VisualMediaResolver.gd")
        self.assertIn("ResourceLoader.exists(asset_path)", resolver)
        self.assertIn("ResourceLoader.load(asset_path", resolver)
        self.assertNotIn("FileAccess", resolver)


if __name__ == "__main__":
    unittest.main()
