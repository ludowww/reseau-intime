import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PROJECTION = "game/scripts/unified_runtime/projection"
MEDIA_PORT = f"{PROJECTION}/MediaProjectionPort.gd"
COMPOSITE_PORT = f"{PROJECTION}/CompositePlayerProjectionPort.gd"
RESOLVER = f"{PROJECTION}/AuthoredMediaResolver.gd"
ADAPTER = f"{PROJECTION}/MediaUIProjectionAdapter.gd"
COORDINATOR = f"{PROJECTION}/UnifiedPlayerProjectionCoordinator.gd"
GALLERY_PROJECTION = f"{PROJECTION}/DurableGalleryProjection.gd"
PHOTO_VIEWER = "game/scripts/ui/gallery/PhotoViewer.gd"
GALLERY_SCREEN = "game/scripts/ui/gallery/GalleryScreen.gd"
GALLERY_TILE = "game/scripts/ui/gallery/GalleryTile.gd"
FIXTURE = "game/tests/fixtures/unified_runtime/n16_media_projection_fixture.json"
SMOKE = "game/tests/R8C_N16MediaRevealGalleryProjectionSmokeDriver.gd"
SMOKE_SCENE = "game/tests/R8C_N16MediaRevealGalleryProjectionSmokeTest.tscn"


class R8CN16MediaRevealGalleryProjectionStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def function(self, source: str, name: str) -> str:
        match = re.search(
            rf"^(?:static )?func {re.escape(name)}\([\s\S]*?\)(?: -> [^:\n]+)?:\n(.*?)(?=^(?:static )?func |\Z)",
            source,
            re.M | re.S,
        )
        self.assertIsNotNone(match, name)
        return match.group(0)

    def test_expected_files_exist_and_surfaces_remain_unique(self):
        expected = [
            MEDIA_PORT,
            COMPOSITE_PORT,
            RESOLVER,
            ADAPTER,
            COORDINATOR,
            GALLERY_PROJECTION,
            PHOTO_VIEWER,
            GALLERY_SCREEN,
            GALLERY_TILE,
            FIXTURE,
            SMOKE,
            SMOKE_SCENE,
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).is_file()])
        godot_sources = "\n".join(
            path.read_text(encoding="utf-8")
            for path in (ROOT / "game").rglob("*.gd")
        )
        self.assertEqual(1, len(re.findall(r"^class_name PhotoViewer$", godot_sources, re.M)))
        self.assertEqual(1, len(re.findall(r"^class_name GalleryScreen$", godot_sources, re.M)))

    def test_media_port_is_closed_idempotent_and_ack_specific(self):
        source = self.read(MEDIA_PORT)
        self.assertIn('const SUPPORTED_TARGET := "MEDIA"', source)
        self.assertIn('beat["type"] != "MEDIA_REVEAL"', source)
        acknowledge = self.function(source, "acknowledge")
        self.assertIn('"VIEWED" if beat["content"]["requires_ack"] else "PRESENTED"', acknowledge)
        self.assertIn('receipt["subject_id"] != beat["content"]["media_id"]', acknowledge)
        self.assertIn('return _accepted_result(request, beat, true)', acknowledge)
        self.assertEqual(['"CONTINUE"'], re.findall(r'"next_command_kinds": \[("CONTINUE")\]', source))

    def test_composite_only_delegates_explicit_targets_and_keeps_snapshot_v1(self):
        source = self.read(COMPOSITE_PORT)
        delegate = self.function(source, "_delegate_for_target")
        self.assertIn('"MESSAGES", "PHYSICAL"', delegate)
        self.assertIn('"MEDIA"', delegate)
        self.assertIn("return null", delegate)
        snapshot = self.function(source, "snapshot")
        self.assertIn('"snapshot_version": 1', snapshot)
        self.assertIn('"open_requests": []', snapshot)
        self.assertIn('"receipts": []', snapshot)
        self.assertNotIn("priority", source.lower())
        self.assertNotIn("fallback", source.lower())

    def test_resolver_is_authored_injected_asset_only_and_fails_closed(self):
        source = self.read(RESOLVER)
        self.assertIn("AuthoredValidator.validate", self.function(source, "create"))
        self.assertIn('"UNKNOWN_CATALOG_MEDIA"', self.function(source, "create"))
        self.assertIn('"UNKNOWN_MEDIA"', self.function(source, "_resolve"))
        self.assertIn('"MEDIA_NOT_AUTONOMOUS"', self.function(source, "_resolve"))
        self.assertIn('"SPECIFIED_NOT_PRODUCED"', self.function(source, "_resolve"))
        self.assertIn('"INVALID_PRESENTATION_ASSET"', self.function(source, "_resolve"))
        self.assertIn('const NOT_DELIVERED_LABEL := "Visuel non livré"', source)
        self.assertIn("ResourceLoader", source)
        self.assertNotIn("DataLoader", source)
        self.assertNotIn("VisualMediaResolver", source)
        self.assertNotIn("livraison_medias", source)
        self.assertIn('"gallery_character_ids"', source)
        catalog_validation = self.function(source, "_validate_catalog")
        self.assertIn("gallery_character_ids.is_empty()", catalog_validation)
        self.assertIn("seen_character_ids.has(character_id)", catalog_validation)
        resolution = self.function(source, "_resolution_success")
        self.assertIn('entry.get("gallery_character_ids", []).duplicate()', resolution)

    def test_adapter_preflights_before_open_and_emits_exact_progression_receipt(self):
        source = self.read(ADAPTER)
        opening = self.function(source, "open_current_projection")
        self.assertLess(opening.index("_prepare_beat(beat)"), opening.index("_executor.open_current_projection()"))
        prepare = self.function(source, "_prepare_beat")
        self.assertIn('beat.get("type") != "MEDIA_REVEAL"', prepare)
        self.assertIn('_resolver.resolve(media_id)', prepare)
        visible = self.function(source, "_on_media_presented")
        self.assertEqual(1, visible.count("_executor.receive_ack(receipt)"))
        self.assertIn('"VIEWED" if _active["requires_ack"] else "PRESENTED"', visible)
        command = self.function(source, "_command_for")
        self.assertIn('"kind": "CONTINUE"', command)
        self.assertIn('"choice_id": null', command)
        self.assertNotIn("commit_resolution", source)

    def test_photo_viewer_accepts_resolved_media_without_breaking_legacy(self):
        source = self.read(PHOTO_VIEWER)
        self.assertIn('signal media_presented(media_id: String, display_status: String)', source)
        self.assertIn('"media"', self.function(source, "configure"))
        refresh = self.function(source, "_refresh")
        self.assertLess(refresh.index('presentation.get("resolved_media")'), refresh.index("MEDIA_RESOLVER.resolve"))
        self.assertIn('_emit_media_presented_if_visible', refresh)
        emitted = self.function(source, "_emit_media_presented_if_visible")
        self.assertIn("is_visible_in_tree()", emitted)
        self.assertIn("media_presented.emit", emitted)

    def test_gallery_projection_filters_durable_truth_and_ui_state_is_local(self):
        source = self.read(GALLERY_PROJECTION)
        accessible = self.function(source, "_is_gallery_accessible")
        for proof in [
            'record["access_status"] == "ACCESSIBLE"',
            'record["gallery_status"] == "AVAILABLE"',
            'record["withdrawal_status"] == "ACTIVE"',
        ]:
            self.assertIn(proof, accessible)
        self.assertNotIn("commit_resolution", source)
        self.assertNotIn("ReducerLivraisonMedia", source)
        content_source = self.function(source, "content_source")
        self.assertNotIn('definition["audience_ids"]', content_source)
        self.assertNotIn('"player_only"', content_source)
        self.assertIn('full_presentation["gallery_character_ids"]', content_source)
        self.assertIn("for character_id in gallery_character_ids", content_source)
        self.assertIn('definition["gallery_policy"] == "NEVER"', content_source)
        self.assertIn('"AVAILABLE_MEDIA_FORBIDDEN_BY_GALLERY_POLICY"', content_source)
        gallery = self.read(GALLERY_SCREEN)
        mark_viewed = self.function(gallery, "mark_viewed")
        self.assertIn('item["is_new"] = false', mark_viewed)
        self.assertNotIn("livraison_medias", gallery + self.read(GALLERY_TILE) + self.read(PHOTO_VIEWER))

    def test_snapshot_schema_and_closed_components_remain_unchanged_in_shape(self):
        snapshot = self.read("game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd")
        self.assertIn("const SCHEMA_VERSION := 1", snapshot)
        self.assertNotRegex(snapshot, r'"(?:media|gallery|viewer)_[^"]*"')
        facade = self.read("game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
        public = re.findall(r"^(?:static )?func ([a-z][a-z0-9_]*)\(", facade, re.M)
        self.assertEqual(
            ["create", "find_candidates", "compose_slot", "activate_option", "resolve_scene", "save_state", "restore_state"],
            [name for name in public if not name.startswith("_")],
        )

    def test_fixture_smoke_and_architecture_proofs_are_explicit(self):
        fixture = json.loads(self.read(FIXTURE))
        statuses = {
            item["production_status"] for item in fixture["media_definitions"].values()
        }
        self.assertEqual({"PRODUCED", "VALIDATED"}, statuses)
        self.assertEqual(
            ["marie", "pauline"],
            next(
                entry["gallery_character_ids"]
                for entry in fixture["presentation_catalog"]["entries"]
                if entry["media_id"] == "photo_multi_character"
            ),
        )
        audience_separated = fixture["media_definitions"]["photo_audience_separated"]
        self.assertEqual(["player_only"], audience_separated["audience_ids"])
        self.assertEqual(
            ["sandra"],
            next(
                entry["gallery_character_ids"]
                for entry in fixture["presentation_catalog"]["entries"]
                if entry["media_id"] == "photo_audience_separated"
            ),
        )
        smoke = self.read(SMOKE)
        for proof in [
            '"media inconnu refuse avant open"',
            '"aucune progression avant visibilite VIEWED"',
            '"VIEWED unique requires_ack true"',
            '"PRESENTED unique requires_ack false"',
            '"reveal sans ecriture livraison_medias ni A1-A5"',
            '"reprise WAITING_FOR_PROJECTION_ACK reconstruit viewer"',
            '"reprise WAITING_FOR_PLAYER reconstruit viewer"',
            '"GRANT_ACCESS AVAILABLE rend media visible"',
            '"meme media visible dans Marie et Pauline"',
            '"multi-onglets conserve un media_id et un record durable"',
            '"audience player_only projetee sous Sandra sans onglet audience"',
            '"AVAILABLE avec gallery_policy NEVER refuse sans affichage"',
            '"incoherence gallery_policy refusee sans mutation durable"',
            '"clic Galerie sans mutation durable A1-A5"',
            '"routing MEDIA vers MESSAGES et viewer ferme"',
        ]:
            self.assertIn(proof, smoke)
        self.assertIn("R8C_N16_MEDIA_REVEAL_GALLERY_PROJECTION: OK (%d controls)", smoke)
        self.assertIn(
            "res://tests/R8C_N16MediaRevealGalleryProjectionSmokeDriver.gd",
            self.read(SMOKE_SCENE),
        )

    def test_n16_sources_have_no_parallel_runtime_or_forbidden_business_logic(self):
        sources = "\n".join(
            self.read(path)
            for path in [MEDIA_PORT, COMPOSITE_PORT, RESOLVER, ADAPTER, COORDINATOR, GALLERY_PROJECTION]
        )
        for forbidden in [
            "DataLoader",
            "Season1RuntimeProvider",
            "season_1",
            "randf",
            "randi",
            "RandomNumberGenerator",
            "ranking",
            "commit_resolution",
        ]:
            self.assertNotIn(forbidden, sources, forbidden)


if __name__ == "__main__":
    unittest.main()
