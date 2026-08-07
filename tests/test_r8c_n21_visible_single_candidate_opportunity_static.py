import hashlib
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"

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
    "data/unified_runtime/catalogs/season_1_v1.json": "b030ecd73a61709a70021f2d46357eb617ea77556f9b464985484e5049c630ea",
    "scripts/unified_runtime/application/UnifiedRuntimeSnapshotV2.gd": "c88f40499a923bb4af3cfff6e8157177aa8465d7f1fc377beb75f1cf49f0e4a5",
    "scripts/unified_runtime/application/UnifiedSeasonSnapshotV1.gd": "b9979f66655ac18f848ca81eba3761719b068d29bf3d0859809e581eadfa4a0e",
    "scripts/narrative_scene/ControlledNarrativeSlotCompositionCoordinator.gd": "033e9901a565693d944d23548dca2a65fbe9f23bc5f73232cacfaffb6a41ab92",
    "scripts/narrative_scene/NarrativeOrchestrationFacade.gd": "270d5be939c271b081e24311eefcb75242198c6350f6db147e600705b1631de7",
}


class R8CN21VisibleSingleCandidateOpportunityStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (GAME / relative).read_text(encoding="utf-8")

    def test_catalog_packages_snapshots_a9_and_a10_are_blob_identical(self):
        for relative, expected in PROTECTED_HASHES.items():
            self.assertEqual(
                expected,
                hashlib.sha256((GAME / relative).read_bytes()).hexdigest(),
                relative,
            )

    def test_runner_has_bounded_reconstructible_opportunity_state(self):
        runner = self.read("scripts/unified_runtime/application/UnifiedSeasonRunner.gd")
        for proof in [
            'const OPPORTUNITY_AVAILABLE := "OPPORTUNITY_AVAILABLE"',
            "func activate_opportunity(thread_id: String)",
            '"UNRESTORABLE_INCOMPLETE_HANDOFF_SAVE"',
            '"SEASON_HANDOFF_COMPLETE_CHECKPOINT_REFUSED"',
            "func _transition_restored_complete(",
            "func _verify_complete_checkpoint(",
            "func _capture_opportunity_checkpoint(",
            "func _checkpoint_is_unchanged(",
            '"OPPORTUNITY_CHECKPOINT_ROLLBACK_REFUSED"',
            'thread["last_preview"] = "Nouveau moment disponible"',
            '"action_label": "Continuer avec " + title',
        ]:
            self.assertIn(proof, runner)
        describe = runner.split("func describe_state()", 1)[1].split(
            "func activate_opportunity", 1
        )[0]
        self.assertIn('"sequence_id"', describe)
        self.assertIn('"thread_id"', describe)
        self.assertIn('"action_label"', describe)
        self.assertNotIn('"prepared_plan"', describe)
        self.assertNotIn('"activation_context"', describe)
        self.assertNotIn("SeasonSnapshot.create(\n\t\tcatalog,\n\t\t\"\"", runner)

    def test_production_prepares_exactly_one_option_without_false_alternative(self):
        root = self.read(
            "scripts/unified_runtime/bootstrap/UnifiedPlayerRuntimeCompositionRoot.gd"
        )
        prepare = root.split("static func prepare_sequence", 1)[1].split(
            "static func activate_prepared_sequence", 1
        )[0]
        self.assertIn('"options": [', prepare)
        options = prepare.split('"options": [', 1)[1].split("\n\t\t\t],", 1)[0]
        self.assertEqual(1, options.count('"option_id": "primary_option"'))
        self.assertIn('composition.get("window", {}).get("options", []).size() != 1', prepare)
        self.assertNotIn("alternative_option", root)
        self.assertNotIn("activate_option", prepare)
        activate = root.split("static func activate_prepared_sequence", 1)[1].split(
            "static func _activate_sequence", 1
        )[0]
        self.assertIn("facade.activate_option", activate)
        self.assertIn('{"intention": "PROPOSE"', activate)

    def test_future_threads_are_projection_filtered_and_cta_is_noninteractive(self):
        messages = self.read("scripts/ui/messages/MessagesScreen.gd")
        conversation_list = self.read("scripts/ui/messages/ConversationList.gd")
        self.assertIn("func _visible_runtime_threads(source: Dictionary)", messages)
        for proof in [
            'messages_by_thread.get(thread_id, [])).is_empty()',
            'choices_by_thread.get(thread_id, [])).is_empty()',
            'thread.get("availability_state", "")) == "OPPORTUNITY_AVAILABLE"',
            'runtime_provider.call("activate_opportunity", thread_id)',
        ]:
            self.assertIn(proof, messages)
        self.assertIn('opportunity_action.name = "OpportunityActionLabel"', conversation_list)
        self.assertIn('var opportunity_action := _label("", 14,', conversation_list)
        self.assertIn("func _apply_opportunity_style", conversation_list)
        self.assertEqual(1, conversation_list.count('button.name = "OpenConversation"'))

    def test_no_selection_engine_or_scheduler_was_added(self):
        sources = (
            self.read("scripts/unified_runtime/application/UnifiedSeasonRunner.gd")
            + self.read(
                "scripts/unified_runtime/bootstrap/UnifiedPlayerRuntimeCompositionRoot.gd"
            )
        ).lower()
        for forbidden in ["ranking", "random", "scheduler", "player_profile", "weight_score"]:
            self.assertNotIn(forbidden, sources)
        self.assertIn("var package: dictionary = eligible[0]", sources)

    def test_smoke_proves_checkpoint_reload_a5_ui_and_final_idle(self):
        smoke = self.read("tests/R8C_N21VisibleSingleCandidateOpportunitySmokeDriver.gd")
        for proof in [
            "Mathilde active au bootstrap, Sandra et Marie invisibles",
            "fenêtre Sandra contient une option et zéro A5 avant clic",
            "checkpoint disque Mathilde COMPLETE conserve le domaine",
            "reload reconstruit Sandra sans session, A5 ni perte Mathilde",
            "échec de composition après PROPOSE rollback A5 et conserve le checkpoint",
            "clic carte ouvre Sandra avec exactement une session",
            "offre Marie préserve transcripts et Galerie avec zéro A5 avant clic",
            "checkpoint disque Sandra COMPLETE conserve le domaine",
            "reload reconstruit Marie sans session, A5 ni perte Sandra",
            "clic carte ouvre Marie avec une session et une matérialisation A5",
            "reload final converge avant rendu vers le même IDLE",
        ]:
            self.assertIn(proof, smoke)
        scene = self.read("tests/R8C_N21VisibleSingleCandidateOpportunitySmokeTest.tscn")
        self.assertIn("R8C_N21VisibleSingleCandidateOpportunitySmokeDriver.gd", scene)


if __name__ == "__main__":
    unittest.main()
