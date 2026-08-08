import hashlib
import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
DATA = GAME / "data/unified_runtime"
SEQUENCE = DATA / "sequences/marie_bread_and_ten_minutes_01.json"
MESSAGES = DATA / "presentation/marie_bread_and_ten_minutes_01_messages.json"
PHYSICAL = DATA / "presentation/marie_bread_and_ten_minutes_01_physical.json"
MEDIA = DATA / "presentation/marie_bread_and_ten_minutes_01_media.json"
PRODUCTION = DATA / "catalogs/season_1_v1.json"
CAPABILITY = GAME / "tests/fixtures/unified_runtime/capability_catalog_n17_n22.json"
SOURCE = GAME / "data/conversations/chapter_01_marie_opening.json"

CAPABILITY_IDS = [
    "mathilde_returns_with_chosen_intent_01",
    "sandra_sentrycore_button_echo_01",
    "marie_evening_return_01",
    "nico_saved_seat_01",
    "marie_household_report_01",
]

PROTECTED_HASHES = {
    "data/unified_runtime/sequences/mathilde_returns_with_chosen_intent_01.json": "d17e6c18e341e52381435c32bc4ad99bd9736f1935c6fc54f08ebd63f9ea780b",
    "data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_messages.json": "aa66059551666bbbdf9604cede69ec2085f9aba3f9a7781093c03fb33cc54261",
    "data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_physical.json": "bb7bd963c7a3cdec2f650b27402ea22eb8681d5afa3ba1acec98ad722a7ae091",
    "data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_media.json": "49120e5e9ddf2997d9871defef50c05ab998ca3da65338161fa400d6b3c6840a",
    "data/unified_runtime/sequences/sandra_sentrycore_button_echo_01.json": "5cd7942a1f130bee5e2f75d0289f9db154251d2acc6b3934335bc5a4406b3979",
    "data/unified_runtime/presentation/sandra_sentrycore_button_echo_01_messages.json": "7e8072bc10acd272a18078bf3e79d5d396fb89bc9f938148bf19725099964216",
    "data/unified_runtime/presentation/sandra_sentrycore_button_echo_01_physical.json": "69c150db9975d78250e5c904f3704d2158f52058d7d596161dd76f82e50fe53f",
    "data/unified_runtime/presentation/sandra_sentrycore_button_echo_01_media.json": "29ce5e65d4cbab95e5000d4d7a886f547f42b4d70c2b11c707578ac3e0ae8147",
    "data/unified_runtime/sequences/marie_evening_return_01.json": "50d7c9a28fccd7bfd1ccb61ffad75bad18c21f1098d9057463788b8570965741",
    "data/unified_runtime/presentation/marie_evening_return_01_messages.json": "90ede96bd90bc16d7adc43ec1de8578811eb8ee12fd1596a9d381afbcbb6627d",
    "data/unified_runtime/presentation/marie_evening_return_01_physical.json": "40398d56103f1c3d0ac72ad13a0d45196de509caa13cc7d1eb2d01b64201d5eb",
    "data/unified_runtime/presentation/marie_evening_return_01_media.json": "a040d65c93a1295d8699886ac668af4ac51ec7935dc89eff265623ead4ec4246",
    "data/unified_runtime/sequences/nico_saved_seat_01.json": "562b9c3a3e2673f6915af70871dc432c14eb435ef12aa99f4a88382947b0bd2a",
    "data/unified_runtime/presentation/nico_saved_seat_01_messages.json": "bfa89b619ddc4f25400e80a5853421b1c110a717cc7575ce6686c0d66986eba0",
    "data/unified_runtime/presentation/nico_saved_seat_01_physical.json": "8d459b1c3206072a5121272069799f8fdc9b21f04beaf5040760a6665fbe63e9",
    "data/unified_runtime/presentation/nico_saved_seat_01_media.json": "50b10faed39f31c8ec976ee888ddcd9dd2e6bce80105539cb6366e8ca945df90",
    "data/unified_runtime/sequences/marie_household_report_01.json": "0a01210fcae84fbc0a7656bd2e58b6d92d1ffb823724b4dc515f77a4ed6e662e",
    "data/unified_runtime/presentation/marie_household_report_01_messages.json": "611f7050ca28cc73c7ba67f605dca9a6c741fee31250b7ff2b0034a2cddbc791",
    "data/unified_runtime/presentation/marie_household_report_01_physical.json": "fdc17b77826e59c1358c772111c016cc249cf149f4965f94a19c2b89270fd8ef",
    "data/unified_runtime/presentation/marie_household_report_01_media.json": "d7e959cd84b709938fa595108061b41e1be3e8757d4c28e4ffd27ba78a554516",
}

FROZEN_RUNTIME = {
    "scripts/unified_runtime/contracts/AuthoredSequenceV1.gd": "10f6e3441569f16d5b29643a9a815ac8a2d7ca8529abb092137c42e6024b0fa7",
    "scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd": "24ab1f73eb049977483883a4ede18c539d38a753cde2cb0c35314a10e851892a",
    "scripts/unified_runtime/execution/SequenceExecutor.gd": "df5489acc55b7a041d3146ff5f90ba8d02a9b59fcca0f3793166ed0df6eeba53",
    "scripts/unified_runtime/application/SequenceExecutorV2.gd": "32cc8327d1a215b690f955dc86c2581aa84d3483a23d06ed0775eecd9cababb8",
    "scripts/unified_runtime/contracts/SequenceExecutionV1.gd": "cf5e11bfa619a52f3c738066024875e5802ccfb7f828ba814cfd4a29fc61e604",
    "scripts/unified_runtime/application/SequenceExecutionV2.gd": "11cb26e26a715fe5ad7d4ee63013e5ebffd7536bee279a9567d65e385185f4b1",
    "scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd": "fbf8c2c0d6f1eb5bf10f64feb1dcac1e4907a98bd2e165dbcf8dfafff0813d9c",
    "scripts/unified_runtime/application/UnifiedRuntimeSnapshotV2.gd": "c88f40499a923bb4af3cfff6e8157177aa8465d7f1fc377beb75f1cf49f0e4a5",
    "scripts/unified_runtime/application/UnifiedSeasonSnapshotV2.gd": "9e1ec24556f699dc2ee8ef7408b81b195aac567c3c30f1ed98b9a2045e153f18",
    "scripts/narrative_scene/NarrativeOrchestrationFacade.gd": "338433a0331f9d527c66c9ed7730491e8332e422b00cc617409314a1debcbd09",
}


class S1OA01MarieBreadAndTenMinutesStaticTests(unittest.TestCase):
    def load(self, path: Path):
        return json.loads(path.read_text(encoding="utf-8"))

    def sha256(self, path: Path) -> str:
        return hashlib.sha256(path.read_bytes()).hexdigest()

    def test_semantic_identity_and_exact_catalog_boundaries(self):
        sequence = self.load(SEQUENCE)
        self.assertEqual("marie_bread_and_ten_minutes_01", sequence["sequence_id"])
        self.assertEqual("1.0.0", sequence["authored_version"])
        self.assertEqual("season_1", sequence["season_id"])
        self.assertEqual("movement_i", sequence["dramatic_movement_id"])
        self.assertEqual("RELATION", sequence["narrative_function"])
        self.assertEqual("CANON_APPROVED", sequence["canonical_status"])
        modern_ids = []
        modern_ids.extend([sequence["sequence_id"], sequence["entry_beat_id"]])
        modern_ids.extend(beat["beat_id"] for beat in sequence["beats"])
        modern_ids.extend(sequence["resolutions"])
        modern_ids.extend(sequence["media"])
        self.assertFalse(any(re.search(r"(?:j0?1|day_?1|chapter_01)", value, re.I) for value in modern_ids))

        production = self.load(PRODUCTION)
        self.assertEqual(
            ("reseau_intime.authored_sequence_catalog", 1, "season_1_v1", "season_1"),
            (production["schema_id"], production["schema_version"], production["catalog_id"], production["season_id"]),
        )
        self.assertEqual(
            ["marie_bread_and_ten_minutes_01", "sandra_kept_lunch_photo_01"],
            [item["sequence_id"] for item in production["packages"]],
        )
        capability = self.load(CAPABILITY)
        self.assertEqual("season_1_v1", capability["catalog_id"])
        self.assertEqual(CAPABILITY_IDS, [item["sequence_id"] for item in capability["packages"]])

    def test_historical_sources_and_twenty_capability_json_are_blob_identical(self):
        self.assertEqual("2542154e22bc373d7be5e82c78fcca86d3952cc3f2ddfca15c930597b011502d", self.sha256(SOURCE))
        for relative, expected in PROTECTED_HASHES.items():
            self.assertEqual(expected, self.sha256(GAME / relative), relative)

    def test_source_text_is_preserved_with_only_two_interactive_guided_replies(self):
        source = self.load(SOURCE)
        sequence = self.load(SEQUENCE)
        messages = self.load(MESSAGES)
        authored_text = json.dumps([sequence, messages], ensure_ascii=False)
        source_texts = []
        for segment in source["segments"]:
            source_texts.extend(item["text"] for item in segment["messages"])
            for choice in segment["choices"]:
                source_texts.append(choice["text"])
                source_texts.extend(item["text"] for item in choice["next_messages"])
        for text in source_texts:
            self.assertIn(text, authored_text, text)

        choice_beats = [beat for beat in sequence["beats"] if beat["type"] == "CHOICE"]
        self.assertEqual([1, 1, 3], [len(beat["content"]["choices"]) for beat in choice_beats])
        self.assertEqual(
            ["Ça dépend de l'optimisme. Donc oui.", "On est en crise ?"],
            [beat["content"]["choices"][0]["text"] for beat in choice_beats[:2]],
        )
        local = [sequence["resolutions"][item] for item in ["resolution_optimism_guided", "resolution_crisis_guided"]]
        self.assertTrue(all(item["a10_choice_id"] is None and item["a10_resolution_id"] is None for item in local))
        durable = [item for item in sequence["resolutions"].values() if item["a10_choice_id"] is not None]
        self.assertEqual(3, len(durable))
        self.assertEqual(
            [
                "Ok. Je prends le pain et on marche. Je participe à la survie du dîner.",
                "Je viens. Je prends le pain, mais je râle un peu pour la forme.",
                "Désolé, j'avais un mail. Je prends le pain et je viens marcher.",
            ],
            [item["text"] for item in choice_beats[2]["content"]["choices"]],
        )

    def test_post_choice_guided_lines_are_player_messages_in_every_return(self):
        messages = self.load(MESSAGES)
        for entry in messages["entries"]:
            player_messages = [(item["text"], item["author_id"]) for item in entry["messages"] if item["author_id"] == "player"]
            self.assertEqual(
                [("Dangereux, le « normalement ».", "player"), ("Ça lui ressemble.", "player")],
                player_messages,
            )
        sequence = self.load(SEQUENCE)
        interactive = [choice["text"] for beat in sequence["beats"] if beat["type"] == "CHOICE" for choice in beat["content"]["choices"]]
        self.assertNotIn("Dangereux, le « normalement ».", interactive)
        self.assertNotIn("Ça lui ressemble.", interactive)

    def test_each_posture_has_one_a10_common_facts_one_exclusive_fact_and_no_promise(self):
        sequence = self.load(SEQUENCE)
        expected_postures = {
            "resolution_present": "marie_shared_evening_presence_chosen",
            "resolution_playful": "marie_shared_evening_playful_presence",
            "resolution_delayed": "marie_shared_evening_delayed_presence_kept",
        }
        all_postures = set(expected_postures.values())
        for resolution_id, posture_fact in expected_postures.items():
            resolution = sequence["resolutions"][resolution_id]
            self.assertIsNotNone(resolution["a10_choice_id"])
            self.assertIsNotNone(resolution["a10_resolution_id"])
            self.assertEqual(
                {"marie_player_shared_life_anchor_established", "marie_shared_evening_completed", posture_fact},
                set(resolution["fact_ids"]),
            )
            self.assertEqual({posture_fact}, set(resolution["fact_ids"]) & all_postures)
            self.assertEqual([], resolution["promise_effects"])
            manifest = sequence["orchestration"]["a6_entry"]["definition"]["resolutions"][resolution["a10_resolution_id"]]["durable_manifest"]
            self.assertEqual([], manifest["promises"])
            self.assertEqual([], manifest["obligations"])
            self.assertEqual(3, len(manifest["facts"]))
            self.assertEqual(1, len(manifest["media_deliveries"]))
        self.assertNotIn("marie_j01_shared_evening", json.dumps(sequence))

    def test_return_physical_and_media_contracts(self):
        sequence = self.load(SEQUENCE)
        physical = self.load(PHYSICAL)
        returns = [beat for beat in sequence["beats"] if beat["type"] == "RETURN"]
        physical_beats = [beat for beat in sequence["beats"] if beat["type"] == "PHYSICAL_BEAT"]
        self.assertEqual(3, len(returns))
        self.assertEqual(3, len(physical_beats))
        self.assertTrue(all(beat["next"]["mode"] == "TERMINAL" for beat in physical_beats))
        self.assertTrue(all(beat["content"]["withdrawal_choice_ids"] == [] for beat in physical_beats))
        delayed = next(item for item in physical["entries"] if "delayed" in item["content_ref"])
        self.assertIn("retard", json.dumps(delayed, ensure_ascii=False).lower())
        self.assertFalse(any(word in json.dumps(delayed).upper() for word in ["MISSED", "FAILED", "PENALTY"]))

        media = sequence["media"]
        self.assertEqual(["s1_opening_marie_shared_kitchen_01"], list(media))
        definition = media["s1_opening_marie_shared_kitchen_01"]
        self.assertEqual(
            ("V0", None, "SPECIFIED_NOT_PRODUCED", "NON_DIEGETIC", "ON_ACCESS", "SELF", "NEVER"),
            (definition["visual_level"], definition["analytic_level"], definition["production_status"], definition["diegesis"], definition["gallery_policy"], definition["thumbnail_policy"], definition["removal_policy"]),
        )
        self.assertNotIn("alias", definition)
        presentation = self.load(MEDIA)["entries"]
        self.assertEqual(1, len(presentation))
        self.assertEqual("", presentation[0]["visual_ref"])
        self.assertEqual("Visuel non livré", presentation[0]["placeholder_label"])
        self.assertEqual(["marie"], presentation[0]["gallery_character_ids"])

    def test_runtime_core_contracts_are_blob_identical(self):
        for relative, expected in FROZEN_RUNTIME.items():
            self.assertEqual(expected, self.sha256(GAME / relative), relative)

    def test_temporal_projection_is_strict_and_new_fingerprint_is_exact(self):
        sequence = self.load(SEQUENCE)
        self.assertEqual(
            {"opens_at": "2032-03-02T18:12:00+01:00", "closes_at": "2032-03-02T20:15:00+01:00"},
            sequence["temporal_projection"]["resolved_window"],
        )
        inline_times = [
            message["diegetic_at"]
            for beat in sequence["beats"]
            if beat["type"] == "MESSAGE"
            for message in beat["content"]["messages"]
        ]
        self.assertEqual(inline_times, sorted(inline_times))
        self.assertEqual(len(inline_times), len(set(inline_times)))
        for entry in self.load(MESSAGES)["entries"]:
            times = inline_times + [message["diegetic_at"] for message in entry["messages"]]
            self.assertEqual(times, sorted(times))
            self.assertEqual(len(times), len(set(times)))

        catalog = self.load(PRODUCTION)
        canonical = {key: catalog[key] for key in ["schema_id", "schema_version", "catalog_id", "season_id"]}
        canonical["packages"] = [
            {
                key: package[key]
                for key in [
                    "package_id", "sequence_id", "authored_version", "sequence_path",
                    "messages_path", "physical_path", "media_path",
                ]
            }
            for package in catalog["packages"]
        ]
        serialized = json.dumps(canonical, ensure_ascii=False, separators=(",", ":"), sort_keys=True)
        fingerprint = hashlib.sha256(serialized.encode("utf-8")).hexdigest()
        self.assertEqual("62ac928c595b122919c45395648a4981da3f405cd7d71d322758b5068866dd17", fingerprint)
        self.assertNotEqual("13933f53a12cd8665a78e6f1714ef47627d7768c4087b18fdf43ea43e931ed57", fingerprint)
        self.assertNotEqual("df4aaf48487c38fe49a883a39f75db1a5cb035aa77c6377e083cea1efacff01e", fingerprint)

    def test_capability_smokes_use_explicit_fixture_and_oa01_smoke_locks_the_gate(self):
        drivers = [
            "R8C_N17UnifiedPlayerBootstrapSmokeDriver.gd",
            "R8C_N18CanonicalCatalogSeasonRunnerSmokeDriver.gd",
            "R8C_N19SandraSentryCoreButtonEchoSmokeDriver.gd",
            "R8C_N20MarieEveningReturnSmokeDriver.gd",
            "R8C_N21VisibleSingleCandidateOpportunitySmokeDriver.gd",
            "R8C_N22FirstCompetingOpportunitiesSmokeDriver.gd",
            "R8C_N22AutomaticTerminalV1SmokeDriver.gd",
        ]
        combined = "\n".join((GAME / "tests" / driver).read_text(encoding="utf-8") for driver in drivers)
        self.assertIn("capability_catalog_n17_n22.json", combined)
        for driver in drivers[:5]:
            self.assertIn("create_for_test", (GAME / "tests" / driver).read_text(encoding="utf-8"), driver)
        self.assertNotIn(
            "data/unified_runtime/catalogs/season_1_v1.json",
            (GAME / "tests/R8C_N22FirstCompetingOpportunitiesSmokeDriver.gd").read_text(encoding="utf-8"),
        )
        self.assertNotIn(
            "data/unified_runtime/catalogs/season_1_v1.json",
            (GAME / "tests/R8C_N22AutomaticTerminalV1SmokeDriver.gd").read_text(encoding="utf-8"),
        )

        smoke_path = GAME / "tests/S1_OA01MarieBreadAndTenMinutesSmokeDriver.gd"
        scene_path = GAME / "tests/S1_OA01MarieBreadAndTenMinutesSmokeTest.tscn"
        smoke = smoke_path.read_text(encoding="utf-8")
        for proof in [
            "deux guided locals ont zéro A10",
            "exactement un A10 publie les trois faits et le média",
            "fresh boot montre Marie seule",
            "reload exact sans replay ni duplication",
            "pendant RETURN",
            "pendant PHYSICAL",
            "COMPLETE puis OPPORTUNITY_AVAILABLE Sandra",
            "INVALID_SEASON_SAVE",
            "S1_OA01_NARRATIVE_REVIEW_BEGIN",
            "S1_OA01_NARRATIVE_REVIEW_END",
        ]:
            self.assertIn(proof, smoke)
        self.assertIn(smoke_path.name, scene_path.read_text(encoding="utf-8"))


if __name__ == "__main__":
    unittest.main()
