import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PORT = "game/scripts/unified_runtime/projection/MessagesPhysicalProjectionPort.gd"
EXECUTOR = "game/scripts/unified_runtime/execution/SequenceExecutor.gd"
EXECUTION = "game/scripts/unified_runtime/contracts/SequenceExecutionV1.gd"
FIXTURE = "game/tests/fixtures/unified_runtime/n15_messages_physical_projection_valid.json"
SMOKE = "game/tests/R8C_N15_1MessagesPhysicalProjectionSmokeDriver.gd"
SCENE = "game/tests/R8C_N15_1MessagesPhysicalProjectionSmokeTest.tscn"


class R8CN151MessagesPhysicalProjectionStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def gdscript_function(self, source: str, name: str) -> str:
        match = re.search(
            rf"^func {re.escape(name)}\([^\n]*\)(?: -> [^:]+)?:\n(.*?)(?=^func |^static func |\Z)",
            source,
            re.M | re.S,
        )
        self.assertIsNotNone(match, name)
        return match.group(0)

    def test_expected_files_exist_and_unittest_collects(self):
        self.assertTrue(issubclass(type(self), unittest.TestCase))
        expected = [PORT, EXECUTOR, EXECUTION, FIXTURE, SMOKE, SCENE]
        self.assertEqual([], [path for path in expected if not (ROOT / path).is_file()])

    def test_port_is_concrete_and_supports_exactly_two_targets(self):
        source = self.read(PORT)
        self.assertIn('extends "res://scripts/unified_runtime/contracts/PlayerProjectionPort.gd"', source)
        targets = re.search(r"const SUPPORTED_TARGETS := \[(.*?)\]", source, re.S)
        self.assertIsNotNone(targets)
        self.assertEqual(["MESSAGES", "PHYSICAL"], re.findall(r'"([A-Z_]+)"', targets.group(1)))
        support = self.gdscript_function(source, "supports_projection")
        self.assertIn('"UNSUPPORTED_PROJECTION"', support)
        self.assertNotIn("fallback", support.lower())

    def test_command_mapping_is_closed_and_media_reveal_is_absent(self):
        source = self.read(PORT)
        mapping = re.search(r"const COMMANDS_BY_BEAT_TYPE := \{(.*?)^\}", source, re.M | re.S)
        self.assertIsNotNone(mapping)
        pairs = re.findall(r'"([A-Z_]+)": \[([^\]]*)\]', mapping.group(1))
        actual = {beat: re.findall(r'"([A-Z_]+)"', commands) for beat, commands in pairs}
        self.assertEqual(
            {
                "MESSAGE": ["CONTINUE"],
                "CHOICE": ["SELECT_CHOICE"],
                "TRANSITION": ["CONTINUE"],
                "PHYSICAL_BEAT": ["CONTINUE", "WITHDRAW"],
                "AFTERCARE": ["CONTINUE"],
                "RETURN": ["CONTINUE"],
            },
            actual,
        )
        self.assertNotIn("MEDIA_REVEAL", actual)

    def test_payload_is_minimal_and_content_is_deep_copied(self):
        source = self.read(PORT)
        accepted = self.gdscript_function(source, "_accepted_result")
        payload = re.search(r'"payload": \{(.*?)\n\s*\},', accepted, re.S)
        self.assertIsNotNone(payload)
        self.assertEqual(
            ["beat_type", "participant_ids", "content"],
            re.findall(r'^\s*"([a-z_]+)":', payload.group(1), re.M),
        )
        self.assertIn('beat["content"].duplicate(true)', accepted)
        for invented in ["title", "avatar", "color", "day", "source_day", "unread", "notification"]:
            self.assertNotRegex(accepted, rf'"{invented}"\s*:')

    def test_port_snapshot_stays_v1_and_restore_is_validate_then_publish(self):
        source = self.read(PORT)
        snapshot = self.gdscript_function(source, "snapshot")
        self.assertIn('"snapshot_version": 1', snapshot)
        self.assertIn('"open_requests": _open_requests.duplicate(true)', snapshot)
        self.assertIn('"receipts": _receipts.duplicate(true)', snapshot)
        restore = self.gdscript_function(source, "restore")
        validation = 'ProjectionContracts.validate_port_snapshot(snapshot_data)["valid"]'
        self.assertIn(validation, restore)
        self.assertLess(restore.index(validation), restore.index("_open_requests ="))
        self.assertLess(restore.index(validation), restore.index("_receipts ="))

    def test_port_contains_no_narrative_persistence_ui_disk_or_nondeterminism(self):
        source = self.read(PORT)
        for forbidden in [
            "resolve_scene", "save_state", "restore_state", "EtatNarratif", "SceneInstance",
            "MinimalSceneEngine", "MessagesScreen", "PortraitMain", "Galerie", "PhotoViewer",
            "FileAccess", "DirAccess", "user://", "randf", "randi", "RandomNumberGenerator",
            "score", "ranking", "priority", "season_1", "runtime/season_1",
        ]:
            self.assertNotIn(forbidden, source, forbidden)

    def test_physical_pending_keeps_n13_shape_and_exact_withdrawal_ids(self):
        executor = self.gdscript_function(self.read(EXECUTOR), "receive_ack")
        self.assertIn('elif beat["type"] == "PHYSICAL_BEAT":', executor)
        self.assertIn('"kind": "CONTINUE"', executor)
        self.assertIn('"allowed_choice_ids": beat["content"]["withdrawal_choice_ids"].duplicate()', executor)
        contract = self.read(EXECUTION)
        pending = re.search(r"const PENDING_PLAYER_INPUT_FIELDS := \[(.*?)\]", contract, re.S)
        self.assertEqual(
            ["kind", "beat_id", "allowed_choice_ids"],
            re.findall(r'"([a-z_]+)"', pending.group(1)),
        )

    def test_withdraw_and_select_choice_share_one_consumption_path(self):
        source = self.read(EXECUTOR)
        receive = self.gdscript_function(source, "receive_command")
        self.assertIn('command["kind"] in ["SELECT_CHOICE", "WITHDRAW"]', receive)
        self.assertEqual(1, receive.count("_consume_choice_selection(selected_choice_context)"))
        helper = self.gdscript_function(source, "_consume_choice_selection")
        self.assertIn('_execution["current_beat_id"] = owner_beat["beat_id"]', helper)
        self.assertIn('_reach_checkpoint(owner_beat["checkpoint_after"])', helper)
        self.assertIn('_execution["consumed_choice_ids"].append(choice["choice_id"])', helper)
        self.assertIn('_execution["execution_status"] = "RESOLUTION_READY"', helper)
        self.assertNotIn("open_current_projection", helper)

    def test_checkpoint_validation_is_not_weakened(self):
        source = self.read(EXECUTION)
        checkpoint = re.search(
            r"static func _validate_current_checkpoint\((.*?)\n\nstatic func ", source, re.S
        )
        self.assertIsNotNone(checkpoint)
        body = checkpoint.group(0)
        self.assertIn('index["checkpoints"][checkpoint_id]["beat_id"] != current_beat_id', body)
        self.assertIn('"current_beat_checkpoint_mismatch"', body)
        for permissive in ["PHYSICAL_BEAT", "WITHDRAW", "withdrawal_choice_ids", "owner_beat"]:
            self.assertNotIn(permissive, body)

    def test_fixture_is_explicitly_synthetic_noncanonical_non_season_one(self):
        fixture = json.loads(self.read(FIXTURE))
        provenance = fixture["author_provenance"]
        self.assertTrue(fixture["sequence_id"].startswith("synthetic_n15_"))
        self.assertEqual("synthetic_non_season_1", fixture["season_id"])
        self.assertEqual("SYNTHETIC_NON_CANONICAL_TEST_ONLY", provenance["approval_ref"])
        self.assertTrue(all("synthetic" in path for path in provenance["source_document_paths"]))
        self.assertNotIn("season_1", json.dumps(fixture).lower().replace("synthetic_non_season_1", ""))

    def test_fixture_covers_required_beats_and_physical_withdrawal_owner(self):
        fixture = json.loads(self.read(FIXTURE))
        beats = {beat["beat_id"]: beat for beat in fixture["beats"]}
        self.assertEqual(
            {"MESSAGE", "CHOICE", "TRANSITION", "PHYSICAL_BEAT", "MEDIA_REVEAL", "AFTERCARE", "RETURN"},
            {beat["type"] for beat in fixture["beats"]},
        )
        self.assertEqual(["choice_finish"], beats["beat_physical"]["content"]["withdrawal_choice_ids"])
        owner = beats["beat_choice"]
        choice = owner["content"]["choices"][0]
        resolution = fixture["resolutions"][choice["resolution_id"]]
        self.assertEqual(choice["choice_id"], resolution["choice_id"])
        self.assertEqual(owner["checkpoint_after"], resolution["terminal_checkpoint_id"])

    def test_smoke_proves_withdrawal_convergence_no_owner_projection_and_no_early_write(self):
        source = self.read(SMOKE)
        scenario = self.gdscript_function(source, "_test_withdrawal_convergence")
        for proof in [
            'pending == {', '"kind": "CONTINUE"', '"allowed_choice_ids": ["choice_finish"]',
            'state["execution_status"] == "RESOLUTION_READY"',
            'state["current_beat_id"] == "beat_choice"',
            'state["checkpoint_id"] == "checkpoint_resolution_ready"',
            'state["consumed_choice_ids"].count("choice_finish") == 1',
            'owner_presentation not in state["opened_projection_ids"]',
            'save_state() == domain_before', 'replay["ok"] and replay["idempotent"]',
            'executor.commit_resolution(_context())', 'save_state() != domain_before',
        ]:
            self.assertIn(proof, scenario)
        self.assertIn("WITHDRAW converge avec SELECT_CHOICE", scenario)

    def test_external_snapshot_contract_remains_v1(self):
        source = self.read("game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd")
        self.assertIn('const SCHEMA_ID := "reseau_intime.unified_runtime"', source)
        self.assertIn("const SCHEMA_VERSION := 1", source)
        self.assertIn('const DOMAIN_FIELDS := ["version", "narrative_state", "scene_registry"]', source)
        self.assertIn('domain["version"] == 1', source)

    def test_a10_public_surface_still_exposes_exactly_seven_operations(self):
        source = self.read("game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
        public = re.findall(r"^(?:static )?func ([a-z][a-z0-9_]*)\(", source, re.M)
        self.assertEqual(
            ["create", "find_candidates", "compose_slot", "activate_option", "resolve_scene", "save_state", "restore_state"],
            [name for name in public if not name.startswith("_")],
        )

    def test_smoke_scene_points_to_driver_and_success_marker_is_present(self):
        scene = self.read(SCENE)
        self.assertIn("res://tests/R8C_N15_1MessagesPhysicalProjectionSmokeDriver.gd", scene)
        smoke = self.read(SMOKE)
        self.assertIn("R8C_N15_1_MESSAGES_PHYSICAL_PROJECTION: OK (%d controls)", smoke)


if __name__ == "__main__":
    unittest.main()
