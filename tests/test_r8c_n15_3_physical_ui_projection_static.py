import json
import re
import subprocess
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASELINE = "63326041b86b97092e5e66c279c866728df1cdc6"
CONTRACT = "game/scripts/unified_runtime/contracts/PhysicalPresentationContentV1.gd"
RESOLVER = "game/scripts/unified_runtime/projection/PhysicalContentResolver.gd"
ADAPTER = "game/scripts/unified_runtime/projection/PhysicalUIProjectionAdapter.gd"
COORDINATOR = "game/scripts/unified_runtime/projection/MessagesPhysicalUIProjectionCoordinator.gd"
SCREEN = "game/scripts/ui/physical/PhysicalProjectionScreen.gd"
SCREEN_SCENE = "game/scenes/portrait/physical/PhysicalProjectionScreen.tscn"
FIXTURE = "game/tests/fixtures/unified_runtime/n15_3_physical_content_catalog_valid.json"
SMOKE = "game/tests/R8C_N15_3PhysicalUIProjectionSmokeDriver.gd"
SMOKE_SCENE = "game/tests/R8C_N15_3PhysicalUIProjectionSmokeTest.tscn"


class R8CN153PhysicalUIProjectionStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def gdscript_function(self, source: str, name: str) -> str:
        match = re.search(
            rf"^(?:static )?func {re.escape(name)}\([\s\S]*?\)(?: -> [^:\n]+)?:\n(.*?)(?=^(?:static )?func |\Z)",
            source,
            re.M | re.S,
        )
        self.assertIsNotNone(match, name)
        return match.group(0)

    def test_expected_files_exist_and_unittest_collects(self):
        self.assertTrue(issubclass(type(self), unittest.TestCase))
        expected = [
            CONTRACT,
            RESOLVER,
            ADAPTER,
            COORDINATOR,
            SCREEN,
            SCREEN_SCENE,
            FIXTURE,
            SMOKE,
            SMOKE_SCENE,
        ]
        self.assertEqual([], [path for path in expected if not (ROOT / path).is_file()])

    def test_production_scope_is_exactly_the_six_new_files(self):
        production = [CONTRACT, RESOLVER, ADAPTER, COORDINATOR, SCREEN, SCREEN_SCENE]
        changed = subprocess.check_output(
            ["git", "diff", "--name-only", BASELINE, "--", "game/scripts", "game/scenes"],
            cwd=ROOT,
            text=True,
        ).splitlines()
        changed.extend(
            subprocess.check_output(
                [
                    "git",
                    "ls-files",
                    "--others",
                    "--exclude-standard",
                    "--",
                    "game/scripts",
                    "game/scenes",
                ],
                cwd=ROOT,
                text=True,
            ).splitlines()
        )
        self.assertEqual(sorted(production), sorted(changed))
        protected = [
            "game/scripts/unified_runtime/projection/MessagesPhysicalProjectionPort.gd",
            "game/scripts/unified_runtime/execution/SequenceExecutor.gd",
            "game/scripts/unified_runtime/contracts/SequenceExecutionV1.gd",
            "game/scripts/unified_runtime/contracts/AuthoredSequenceV1.gd",
            "game/scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd",
            "game/scripts/unified_runtime/projection/MessagesUIProjectionAdapter.gd",
            "game/scripts/ui/messages/MessagesScreen.gd",
            "game/scripts/ui/messages/OffPhoneTransition.gd",
            "game/scripts/ui/PortraitShell.gd",
            "game/scripts/ui/PortraitMain.gd",
            "game/project.godot",
        ]
        for path in protected:
            self.assertEqual(
                "",
                subprocess.check_output(
                    ["git", "diff", BASELINE, "--", path], cwd=ROOT, text=True
                ),
                path,
            )

    def test_contract_is_closed_minimal_and_bounded(self):
        source = self.read(CONTRACT)
        self.assertIn('SCHEMA_ID := "reseau_intime.physical_presentation_catalog"', source)
        self.assertIn("SCHEMA_VERSION := 1", source)
        self.assertIn('"schema_id", "schema_version", "sequence_id", "authored_version", "entries"', source)
        self.assertIn('["content_ref", "title", "body", "steps", "continue_label"]', source)
        self.assertIn("const MIN_STEPS := 1", source)
        self.assertIn("const MAX_STEPS := 6", source)
        validation = self.gdscript_function(source, "_validate_dictionary")
        self.assertIn('"unknown_field"', validation)
        entries = self.gdscript_function(source, "_validate_entries")
        self.assertIn('"duplicate"', entries)
        self.assertIn("content_refs", entries)

    def test_fixture_has_exact_schema_and_no_withdrawal_or_consequence_data(self):
        payload = json.loads(self.read(FIXTURE))
        self.assertEqual(
            {
                "schema_id",
                "schema_version",
                "sequence_id",
                "authored_version",
                "entries",
            },
            set(payload),
        )
        self.assertEqual(
            {"content_ref", "title", "body", "steps", "continue_label"},
            set(payload["entries"][0]),
        )
        serialized = json.dumps(payload).lower()
        for forbidden in [
            "withdrawal_choice_id",
            "resolution_id",
            "consequence",
            "event_ref",
            "score",
            "mathilde",
            "media",
        ]:
            self.assertNotIn(forbidden, serialized)

    def test_resolver_validates_both_inputs_identity_and_builds_authored_choice_index(self):
        source = self.read(RESOLVER)
        create = self.gdscript_function(source, "create")
        self.assertLess(create.index("AuthoredValidator.validate"), create.index("var resolver := new()"))
        self.assertLess(create.index("PhysicalCatalog.validate"), create.index("var resolver := new()"))
        self.assertIn('"SEQUENCE_ID_MISMATCH"', create)
        self.assertIn('"AUTHORED_VERSION_MISMATCH"', create)
        self.assertIn('beat["type"] != "CHOICE"', create)
        self.assertIn('choice["choice_id"]', create)
        self.assertNotIn("FileAccess", source)
        self.assertNotIn("DataLoader", source)

    def test_resolver_uses_catalog_only_for_presentation_and_choice_text_for_withdrawals(self):
        resolve = self.gdscript_function(self.read(RESOLVER), "resolve_physical_beat")
        self.assertIn('beat.get("type") != "PHYSICAL_BEAT"', resolve)
        self.assertIn('beat.get("projection_target") != "PHYSICAL"', resolve)
        self.assertIn('not _entries_by_ref.has(content_ref)', resolve)
        self.assertIn('"DUPLICATE_WITHDRAWAL_CHOICE"', resolve)
        self.assertIn('"UNKNOWN_WITHDRAWAL_CHOICE"', resolve)
        self.assertIn('"text": _choices_by_id[choice_id]["text"]', resolve)
        self.assertIn('for choice_id in withdrawal_choice_ids:', resolve)
        for forbidden in ["resolution_id", "a10", "consequence", "score", "priority"]:
            self.assertNotIn(forbidden, resolve.lower())

    def test_adapter_preflights_before_executor_open_and_acks_after_screen_presentation(self):
        source = self.read(ADAPTER)
        opening = self.gdscript_function(source, "open_current_projection")
        self.assertLess(opening.index("_prepare_beat(beat)"), opening.index("_executor.open_current_projection()"))
        prepare = self.gdscript_function(source, "_prepare_beat")
        self.assertIn("_resolver.resolve_physical_beat(beat)", prepare)
        self.assertNotIn("resolve_physical_beat", prepare.split('if beat.get("type") == "TRANSITION":')[1].split('if beat.get("type") != "PHYSICAL_BEAT":')[0])
        ready = self.gdscript_function(source, "_on_presentation_ready")
        self.assertEqual(1, ready.count("_executor.receive_ack(receipt)"))
        self.assertIn('"PRESENTED"', ready)
        self.assertIn('_active["subject_id"]', ready)

    def test_adapter_commands_are_exact_and_never_commit(self):
        source = self.read(ADAPTER)
        self.assertIn('return _submit_command("CONTINUE", null)', self.gdscript_function(source, "continue_current_projection"))
        withdrawal = self.gdscript_function(source, "withdraw")
        self.assertIn('choice_id not in _active.get("withdrawal_choice_ids", [])', withdrawal)
        self.assertIn('return _submit_command("WITHDRAW", choice_id)', withdrawal)
        submit = self.gdscript_function(source, "_submit_command")
        self.assertEqual(1, submit.count("_executor.receive_command(command)"))
        self.assertLess(submit.index("_screen.dismiss()"), submit.index("projection_completed.emit"))
        self.assertNotIn("commit_resolution", source)

    def test_resume_is_reconstructed_without_physical_snapshot(self):
        source = self.read(ADAPTER)
        self.assertIsNone(re.search(r"^func snapshot\(", source, re.M))
        self.assertIsNone(re.search(r"^func restore\(", source, re.M))
        resume = self.gdscript_function(source, "resume_from_execution")
        self.assertIn('"WAITING_FOR_PROJECTION_ACK"', resume)
        self.assertIn('"WAITING_FOR_PLAYER"', resume)
        self.assertIn("open_requests.size() != 1", resume)
        self.assertIn("open_requests[0] != expected_request", resume)
        self.assertIn("receipts != [expected_receipt]", resume)
        self.assertIn("_pending_input_matches", resume)
        self.assertLess(resume.index("RESUME_STATE_MISMATCH"), resume.index("_apply_opened_projection"))

    def test_screen_is_independent_full_surface_focusable_and_data_only(self):
        source = self.read(SCREEN)
        self.assertIn("class_name R8CPhysicalProjectionScreen", source)
        self.assertIn("signal continue_requested", source)
        self.assertIn("signal withdraw_requested(choice_id: String)", source)
        self.assertIn("Control.MOUSE_FILTER_STOP", source)
        self.assertIn("Control.PRESET_FULL_RECT", source)
        self.assertIn("_continue_button.grab_focus()", source)
        self.assertIn("_reduced_motion", source)
        self.assertIn("_apply_safe_area", source)
        self.assertIn("ScrollContainer", source)
        for forbidden in [
            "OffPhoneTransition",
            "PhotoViewer",
            "Gallery",
            "resolution_id",
            "commit_resolution",
            "season_1",
            "J11",
        ]:
            self.assertNotIn(forbidden, source)

    def test_coordinator_delegates_messages_mounts_one_overlay_and_routes_targets(self):
        source = self.read(COORDINATOR)
        for delegation in [
            "presentation_source",
            "presented_message_ids_by_thread",
            "mark_message_presented",
            "mark_thread_batch_presented",
            "on_messages_delivery_completed",
            "on_notification_presented",
            "on_notification_dismissed",
            "on_choices_presented",
        ]:
            body = self.gdscript_function(source, delegation)
            self.assertIn(f"_messages_adapter.{delegation}", body)
        attach = self.gdscript_function(source, "attach_messages_screen")
        self.assertIn("_messages_adapter.attach_messages_screen(screen)", attach)
        self.assertIn("_mount_physical_screen", attach)
        mount = self.gdscript_function(source, "_mount_physical_screen")
        self.assertIn("_messages_screen.add_child(_physical_screen)", mount)
        route = self.gdscript_function(source, "_route_current_projection")
        self.assertIn('"MESSAGES":', route)
        self.assertIn('"PHYSICAL":', route)
        self.assertIn('"UNSUPPORTED_PROJECTION_TARGET"', route)
        for forbidden in ["Season1RuntimeProvider", "season_1", "gallery", "PhotoViewer", "J11"]:
            self.assertNotIn(forbidden, source)

    def test_production_has_no_disk_nondeterminism_scoring_or_legacy_fallback(self):
        sources = "\n".join(self.read(path) for path in [RESOLVER, ADAPTER, COORDINATOR, SCREEN])
        for forbidden in [
            "FileAccess",
            "DirAccess",
            "DataLoader",
            "user://",
            "randf",
            "randi",
            "RandomNumberGenerator",
            "score",
            "ranking",
            "legacy",
            "commit_resolution",
        ]:
            self.assertNotIn(forbidden, sources, forbidden)

    def test_n13_snapshot_and_a10_surface_remain_unchanged(self):
        runtime_snapshot = self.read("game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd")
        self.assertIn("const SCHEMA_VERSION := 1", runtime_snapshot)
        facade = self.read("game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
        public = re.findall(r"^(?:static )?func ([a-z][a-z0-9_]*)\(", facade, re.M)
        self.assertEqual(
            [
                "create",
                "find_candidates",
                "compose_slot",
                "activate_option",
                "resolve_scene",
                "save_state",
                "restore_state",
            ],
            [name for name in public if not name.startswith("_")],
        )

    def test_smoke_covers_required_runtime_flows(self):
        smoke = self.read(SMOKE)
        for proof in [
            '"resolution avant ouverture"',
            '"surface transition physique reellement visible"',
            '"transition sans narration inventee"',
            '"telephone sous-jacent non interactif"',
            '"surface physique unique"',
            '"PHYSICAL_BEAT reellement visible"',
            '"libelle WITHDRAW issu de CHOICE.text"',
            '"aucune crop a 1280x720"',
            '"routing PHYSICAL vers MESSAGES"',
            '"choix hors liste sans mutation"',
            '"WITHDRAW converge vers RESOLUTION_READY"',
            '"aucun beat CHOICE projete"',
            '"aucun commit durable"',
            '"snapshot durant WAITING_FOR_PROJECTION_ACK"',
            '"pas de double ACK"',
            '"memes actions CONTINUE WITHDRAW"',
            '"aucune mutation A1-A5"',
        ]:
            self.assertIn(proof, smoke)
        self.assertIn(
            "R8C_N15_3_PHYSICAL_UI_PROJECTION: OK (%d controls)", smoke
        )
        self.assertIn(
            "res://tests/R8C_N15_3PhysicalUIProjectionSmokeDriver.gd",
            self.read(SMOKE_SCENE),
        )


if __name__ == "__main__":
    unittest.main()
