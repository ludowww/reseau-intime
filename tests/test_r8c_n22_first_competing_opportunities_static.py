import hashlib
import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
DATA = GAME / "data/unified_runtime"

NEW_IDS = ["nico_saved_seat_01", "marie_household_report_01"]
OLD_HASHES = {
    "sequences/mathilde_returns_with_chosen_intent_01.json": "d17e6c18e341e52381435c32bc4ad99bd9736f1935c6fc54f08ebd63f9ea780b",
    "presentation/mathilde_returns_with_chosen_intent_01_messages.json": "aa66059551666bbbdf9604cede69ec2085f9aba3f9a7781093c03fb33cc54261",
    "presentation/mathilde_returns_with_chosen_intent_01_physical.json": "bb7bd963c7a3cdec2f650b27402ea22eb8681d5afa3ba1acec98ad722a7ae091",
    "presentation/mathilde_returns_with_chosen_intent_01_media.json": "49120e5e9ddf2997d9871defef50c05ab998ca3da65338161fa400d6b3c6840a",
    "sequences/sandra_sentrycore_button_echo_01.json": "5cd7942a1f130bee5e2f75d0289f9db154251d2acc6b3934335bc5a4406b3979",
    "presentation/sandra_sentrycore_button_echo_01_messages.json": "7e8072bc10acd272a18078bf3e79d5d396fb89bc9f938148bf19725099964216",
    "presentation/sandra_sentrycore_button_echo_01_physical.json": "69c150db9975d78250e5c904f3704d2158f52058d7d596161dd76f82e50fe53f",
    "presentation/sandra_sentrycore_button_echo_01_media.json": "29ce5e65d4cbab95e5000d4d7a886f547f42b4d70c2b11c707578ac3e0ae8147",
    "sequences/marie_evening_return_01.json": "50d7c9a28fccd7bfd1ccb61ffad75bad18c21f1098d9057463788b8570965741",
    "presentation/marie_evening_return_01_messages.json": "90ede96bd90bc16d7adc43ec1de8578811eb8ee12fd1596a9d381afbcbb6627d",
    "presentation/marie_evening_return_01_physical.json": "40398d56103f1c3d0ac72ad13a0d45196de509caa13cc7d1eb2d01b64201d5eb",
    "presentation/marie_evening_return_01_media.json": "a040d65c93a1295d8699886ac668af4ac51ec7935dc89eff265623ead4ec4246",
}
FROZEN_CORE = {
    "scripts/narrative_scene/CandidateReservationProposalCoordinator.gd": "3a1d49aaf8fa4f0862ac7a5a518951361b9d67872285bddfa19e706815f75d43",
    "scripts/narrative_scene/OpportunityWindowExclusiveConflictCoordinator.gd": "a118de33f8092e59bad156d1411bcf471789b21545982376b5f6da7cdf1bff65",
    "scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd": "033e9901a565693d944d23548dca2a65fbe9f23bc5f73232cacfaffb6a41ab92",
    "scripts/unified_runtime/contracts/AuthoredSequenceV1.gd": "10f6e3441569f16d5b29643a9a815ac8a2d7ca8529abb092137c42e6024b0fa7",
    "scripts/unified_runtime/application/SequenceExecutorV2.gd": "32cc8327d1a215b690f955dc86c2581aa84d3483a23d06ed0775eecd9cababb8",
    "scripts/unified_runtime/contracts/PlayerProjectionContracts.gd": "6401a51b9c23ecd23ac02e3784dfc7d701ccc69da6a1c6ab907313ffa23871c4",
    "scripts/unified_runtime/application/UnifiedRuntimeSnapshotV2.gd": "c88f40499a923bb4af3cfff6e8157177aa8465d7f1fc377beb75f1cf49f0e4a5",
    "scripts/narrative_scene/PersistentSceneRegistry.gd": "c1c119fc066e9406deb3d8c9bb0dea4de4df199a00a232de19dfeb2380b2ca1c",
}


class R8CN22FirstCompetingOpportunitiesStaticTests(unittest.TestCase):
    def load(self, path: Path):
        return json.loads(path.read_text(encoding="utf-8"))

    def source(self, relative: str) -> str:
        return (GAME / relative).read_text(encoding="utf-8")

    def test_exactly_two_packages_and_eight_json_are_added(self):
        catalog = self.load(DATA / "catalogs/season_1_v1.json")
        self.assertEqual(
            [
                "mathilde_returns_with_chosen_intent_01",
                "sandra_sentrycore_button_echo_01",
                "marie_evening_return_01",
                *NEW_IDS,
            ],
            [package["sequence_id"] for package in catalog["packages"]],
        )
        for sequence_id in NEW_IDS:
            self.assertTrue((DATA / f"sequences/{sequence_id}.json").is_file())
            for suffix in ["messages", "physical", "media"]:
                self.assertTrue((DATA / f"presentation/{sequence_id}_{suffix}.json").is_file())

    def test_twelve_existing_json_are_blob_identical(self):
        for relative, expected in OLD_HASHES.items():
            self.assertEqual(expected, hashlib.sha256((DATA / relative).read_bytes()).hexdigest())

    def test_source_dialogue_is_exact_and_nico_only_retimed(self):
        legacy = self.load(GAME / "data/conversations/chapter_04_nico_saved_seat_followup.json")
        sequence = self.load(DATA / "sequences/nico_saved_seat_01.json")
        source_texts = []
        source_times = []
        for segment in legacy["segments"]:
            for message in segment["messages"]:
                source_texts.append(message["text"]); source_times.append(message["time_label"])
            for choice in segment["choices"]:
                source_texts.append(choice["text"])
                for message in choice["next_messages"]:
                    source_texts.append(message["text"]); source_times.append(message["time_label"])
        authored = json.dumps(sequence, ensure_ascii=False)
        referenced = (DATA / "presentation/nico_saved_seat_01_messages.json").read_text(encoding="utf-8")
        for text in source_texts:
            self.assertIn(text, authored + referenced, text)
        self.assertNotIn("14:0", authored + referenced)
        self.assertEqual("18:05", min(re.findall(r'18:0[5-9]', authored + referenced)))
        self.assertIn("18:09", authored + referenced)

    def test_common_window_real_options_and_policies(self):
        nico = self.load(DATA / "sequences/nico_saved_seat_01.json")
        marie = self.load(DATA / "sequences/marie_household_report_01.json")
        expected_window = {
            "opens_at": "2032-03-05T18:05:00+01:00",
            "closes_at": "2032-03-05T18:09:00+01:00",
        }
        self.assertEqual(expected_window, nico["temporal_projection"]["resolved_window"])
        self.assertEqual(expected_window, marie["temporal_projection"]["resolved_window"])
        self.assertEqual("n22_friday_attention_window", nico["orchestration"]["a8_window"]["window_id"])
        self.assertEqual("n22_friday_attention_slot", marie["orchestration"]["a9_slot"]["slot_role"])
        self.assertEqual("CLOSE_SILENTLY", nico["orchestration"]["a8_window"]["conflict_policy"])
        self.assertEqual("DEFER", marie["orchestration"]["a8_window"]["conflict_policy"])
        root = self.source("scripts/unified_runtime/bootstrap/UnifiedPlayerRuntimeCompositionRoot.gd")
        self.assertIn('"nico_option"', root)
        self.assertIn('"marie_option"', root)
        self.assertNotIn("alternative_option", root)

    def test_marie_is_exact_automatic_terminal_profile(self):
        marie = self.load(DATA / "sequences/marie_household_report_01.json")
        self.assertEqual({}, marie["resolutions"])
        self.assertEqual({}, marie["orchestration"]["a6_entry"]["definition"]["resolutions"])
        self.assertEqual([], marie["orchestration"]["a6_entry"]["definition"]["choix"])
        self.assertEqual(1, len(marie["beats"]))
        beat = marie["beats"][0]
        self.assertEqual(("MESSAGE", "MESSAGES", [], {"mode": "TERMINAL", "beat_id": None}),
                         (beat["type"], beat["projection_target"], beat["local_conditions"], beat["next"]))
        self.assertNotIn('"type": "CHOICE"', json.dumps(marie))

    def test_season_v2_migration_and_not_selected_are_bounded(self):
        snapshot = self.source("scripts/unified_runtime/application/UnifiedSeasonSnapshotV2.gd")
        expected = {
            "schema_id", "schema_version", "catalog_id", "catalog_fingerprint", "season_id",
            "active_sequence_id", "completed_sequence_ids", "not_selected_sequence_ids",
            "active_runtime_snapshot", "persistent_messages_state",
        }
        fields = re.search(r"const FIELDS := \[(.*?)\]", snapshot, re.S).group(1)
        self.assertEqual(expected, set(re.findall(r'"([a-z_]+)"', fields)))
        for proof in [
            'const SCHEMA_VERSION := 2',
            'N21_CATALOG_FINGERPRINT := "ec869bd0eb4d0ce7c16ad41b08f70f24e0a08367a039f9f1306ddd58c7673beb"',
            '"nico_thread"', 'UNSUPPORTED_N21_SEASON_SNAPSHOT',
            'not_selected_sequence_ids:not_disjoint',
        ]:
            self.assertIn(proof, snapshot)
        self.assertNotIn("deferred_sequence_ids", snapshot)
        self.assertNotIn("automatic_completed_sequence_ids", snapshot)

    def test_runner_is_two_card_bounded_without_ranking(self):
        runner = self.source("scripts/unified_runtime/application/UnifiedSeasonRunner.gd")
        for proof in [
            "var not_selected_sequence_ids: Array = []", "var _opportunities: Array = []",
            '"opportunities": _sanitized_opportunities()',
            'sequence["sequence_id"] in not_selected_sequence_ids',
            'not_selected_sequence_ids.append("nico_saved_seat_01")',
            "func activate_opportunity(thread_id: String)",
        ]:
            self.assertIn(proof, runner)
        combined = runner + self.source("scripts/unified_runtime/bootstrap/UnifiedPlayerRuntimeCompositionRoot.gd")
        for forbidden in ["choose_route", "rank_opportunities", "select_candidate_group", "scheduler", "random"]:
            self.assertNotIn(forbidden, combined.lower())

    def test_automatic_completion_is_internal_and_public_a10_stays_seven(self):
        facade = self.source("scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
        public = re.findall(r"^(?:static )?func ([a-z][a-z0-9_]*)\(", facade, re.M)
        self.assertEqual(
            ["create", "find_candidates", "compose_slot", "activate_option", "resolve_scene", "save_state", "restore_state"],
            [name for name in public if not name.startswith("_")],
        )
        executor = self.source("scripts/unified_runtime/execution/SequenceExecutor.gd")
        automatic = executor.split("func _complete_automatic_terminal", 1)[1].split("func _reach_checkpoint", 1)[0]
        self.assertIn("_prepare_automatic_scene_completion_internal", automatic)
        self.assertIn("_publish_automatic_scene_completion_internal", automatic)
        self.assertNotIn("resolve_scene", automatic)
        self.assertNotIn("commit_resolution", automatic)

    def test_frozen_core_and_runtime_snapshot_v2_are_blob_identical(self):
        for relative, expected in FROZEN_CORE.items():
            self.assertEqual(expected, hashlib.sha256((GAME / relative).read_bytes()).hexdigest(), relative)

    def test_existing_thread_refresh_uses_the_merged_session_source(self):
        session = self.source(
            "scripts/unified_runtime/application/UnifiedPlayerRuntimeSession.gd"
        )
        self.assertIn("class MessagesScreenBridge:", session)
        self.assertIn(
            "screen.refresh_from_runtime(session.presentation_source())", session
        )

    def test_smokes_lock_v1_v2_migration_branches_and_rollback(self):
        product = self.source("tests/R8C_N22FirstCompetingOpportunitiesSmokeDriver.gd")
        v1 = self.source("tests/R8C_N22AutomaticTerminalV1SmokeDriver.gd")
        for proof in [
            "Marie-first", "Nico-first", "migration save Mathilde actif",
            "migration save Sandra actif", "migration save Marie J03 actif",
            "migration checkpoint COMPLETE N21", "not_selected_sequence_ids",
        ]:
            self.assertIn(proof, product)
        for proof in [
            "AUTOMATIC_COMPLETION_APPLIED", "COMPLETE_AUTOMATIC", "RuntimeSnapshotV1.validate",
            "EXECUTION_COMPLETE", "rejeu A5 idempotent",
            "refus A5 conserve executor non COMPLETE et interdit save terminal",
        ]:
            self.assertIn(proof, v1)


if __name__ == "__main__":
    unittest.main()
