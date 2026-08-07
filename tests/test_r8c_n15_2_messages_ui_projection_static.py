import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ADAPTER = "game/scripts/unified_runtime/projection/MessagesUIProjectionAdapter.gd"
SCREEN = "game/scripts/ui/messages/MessagesScreen.gd"
PORT = "game/scripts/unified_runtime/projection/MessagesPhysicalProjectionPort.gd"
EXECUTOR = "game/scripts/unified_runtime/execution/SequenceExecutor.gd"
CONTRACTS = "game/scripts/unified_runtime/contracts/PlayerProjectionContracts.gd"
FIXTURE = "game/tests/fixtures/unified_runtime/n15_messages_physical_projection_valid.json"
SMOKE = "game/tests/R8C_N15_2MessagesUIProjectionSmokeDriver.gd"
SCENE = "game/tests/R8C_N15_2MessagesUIProjectionSmokeTest.tscn"


class R8CN152MessagesUIProjectionStaticTests(unittest.TestCase):
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
        expected = [ADAPTER, SCREEN, PORT, EXECUTOR, CONTRACTS, FIXTURE, SMOKE, SCENE]
        self.assertEqual([], [path for path in expected if not (ROOT / path).is_file()])

    def test_adapter_has_no_season_one_or_legacy_dependency(self):
        source = self.read(ADAPTER)
        self.assertIn("extends RefCounted", source)
        self.assertIn("class_name R8CMessagesUIProjectionAdapter", source)
        for forbidden in [
            "season_1",
            "Season1RuntimeProvider",
            "J01",
            "J21",
            "legacy",
            "gallery_source",
            "confirm_transition",
            "current_narrative_time",
            "commit_narrative_time",
            "automatic_day_handoff",
        ]:
            self.assertNotIn(forbidden, source, forbidden)

    def test_adapter_has_no_durable_write_nondeterminism_or_scoring(self):
        source = self.read(ADAPTER)
        for forbidden in [
            "commit_resolution",
            "resolve_scene",
            "save_state",
            "restore_state",
            "FileAccess",
            "DirAccess",
            "user://",
            "randf",
            "randi",
            "RandomNumberGenerator",
            "UUID",
            "Time.get_ticks",
            "score",
            "ranking",
            "priority",
        ]:
            self.assertNotIn(forbidden, source, forbidden)

    def test_source_uses_existing_messages_dtos_and_preserves_authored_time(self):
        source = self.read(ADAPTER)
        empty_source = self.gdscript_function(source, "_empty_source")
        for field in ["characters", "threads", "messages_by_thread", "choices_by_thread"]:
            self.assertIn(f'"{field}"', empty_source)
        project = self.gdscript_function(source, "_project_messages")
        self.assertIn("_authored_message_dto(authored_message, _active)", project)
        mapping_helper = self.gdscript_function(source, "_authored_message_dto")
        for mapping in [
            '"message_id": str(authored_message.get("message_id", ""))',
            '"author_id": author_id',
            '"text": str(authored_message.get("text", ""))',
            '"timestamp": _timestamp_for_diegetic(diegetic_at)',
            '"diegetic_at": diegetic_at',
            '"content_type": "TEXT"',
            '"media_ref": ""',
            '"sequence_id": active["sequence_id"]',
            '"beat_id": active["beat_id"]',
            '"presentation_id": active["presentation_id"]',
        ]:
            self.assertIn(mapping, mapping_helper)
        self.assertNotIn('"source_day"', mapping_helper)

    def test_choice_mapping_is_authored_enabled_and_does_not_invent_confirmation(self):
        source = self.read(ADAPTER)
        project = self.gdscript_function(source, "_project_choices")
        self.assertIn("_choice_dto(authored_choice, _active)", project)
        mapping_helper = self.gdscript_function(source, "_choice_dto")
        self.assertIn('"choice_id": str(authored_choice.get("choice_id", ""))', mapping_helper)
        self.assertIn('"text": str(authored_choice.get("text", ""))', mapping_helper)
        self.assertIn('"enabled": true', mapping_helper)
        self.assertNotIn("confirmation_required", mapping_helper)
        for forbidden in ["resolution_id", "score", "route", "preference"]:
            self.assertNotIn(forbidden, mapping_helper)

    def test_thread_resolution_is_exact_and_refuses_zero_or_many(self):
        resolve = self.gdscript_function(self.read(ADAPTER), "_resolve_thread")
        self.assertIn("_normalized_participants(thread.get(\"participant_ids\", [])) == expected", resolve)
        self.assertIn('"UNRESOLVED_PARTICIPANT"', resolve)
        self.assertIn('"THREAD_NOT_FOUND"', resolve)
        self.assertIn('"AMBIGUOUS_THREAD"', resolve)
        prepare = self.gdscript_function(self.read(ADAPTER), "_prepare_beat")
        self.assertIn('"THREAD_ID_MISMATCH"', prepare)
        self.assertLess(prepare.index("_resolve_thread"), prepare.index('"THREAD_ID_MISMATCH"'))

    def test_aftercare_return_and_unsupported_target_refuse_before_open(self):
        source = self.read(ADAPTER)
        prepare = self.gdscript_function(source, "_prepare_beat")
        self.assertIn('beat.get("type") in ["AFTERCARE", "RETURN"]', prepare)
        self.assertIn('"UNRESOLVED_CONTENT_REF"', prepare)
        self.assertIn('"UNSUPPORTED_TARGET"', prepare)
        opening = self.gdscript_function(source, "open_current_projection")
        self.assertLess(opening.index("_prepare_beat"), opening.index("_executor.open_current_projection()"))
        self.assertLess(opening.index("_validate_beat_projection"), opening.index("_executor.open_current_projection()"))

    def test_presentation_receipts_use_port_but_progression_ack_uses_executor(self):
        source = self.read(ADAPTER)
        presentation = self.gdscript_function(source, "acknowledge_presentation")
        self.assertIn("_projection_port.acknowledge(receipt)", presentation)
        self.assertNotIn("_executor.receive_ack", presentation)
        read = self.gdscript_function(source, "on_thread_read")
        self.assertEqual(1, read.count("_executor.receive_ack"))
        self.assertEqual(1, read.count('_command("CONTINUE", null)'))
        self.assertEqual(1, read.count("_executor.receive_command"))
        self.assertLess(read.index("_executor.receive_ack"), read.index("_executor.receive_command"))
        choice = self.gdscript_function(source, "on_choices_presented")
        self.assertEqual(1, choice.count("_executor.receive_ack"))
        self.assertNotIn("receive_command", choice)

    def test_choice_click_uses_select_choice_and_player_bubble_id_is_stable(self):
        source = self.read(ADAPTER)
        apply_choice = self.gdscript_function(source, "apply_choice")
        self.assertIn('_command("SELECT_CHOICE", choice_id)', apply_choice)
        self.assertEqual(1, apply_choice.count("_executor.receive_command"))
        self.assertIn("_player_bubble_dto(selected_choice, _active)", apply_choice)
        bubble = self.gdscript_function(source, "_player_bubble_dto")
        self.assertIn('"is_player": true', bubble)
        self.assertIn('"timestamp": ""', bubble)
        identity = self.gdscript_function(source, "_player_bubble_id")
        self.assertIn('"%s__choice__%s__player"', identity)
        for forbidden in ["rand", "ticks", "unix", "uuid"]:
            self.assertNotIn(forbidden, identity.lower())

    def test_messages_screen_uses_local_capabilities_and_fallback_time(self):
        source = self.read(SCREEN)
        configure = self.gdscript_function(source, "configure_content_source")
        self.assertIn('if _runtime_has("attach_messages_screen"):', configure)
        helper = self.gdscript_function(source, "_runtime_has")
        self.assertIn("runtime_provider.has_method(capability)", helper)
        ready = self.gdscript_function(source, "_ready")
        self.assertIn('_runtime_notify("on_messages_ui_ready")', ready)
        self.assertIn('if _runtime_has("pending_transition_flow"):', ready)
        self.assertIn('if _runtime_has("pending_scene_sequence"):', ready)
        day = self.gdscript_function(source, "_authoritative_narrative_day_short")
        time = self.gdscript_function(source, "_authoritative_narrative_time_text")
        self.assertIn('content_source.get("narrative_day_short", "")', day)
        self.assertIn('content_source.get("narrative_time", "")', time)

    def test_messages_screen_hooks_only_actual_ui_events(self):
        source = self.read(SCREEN)
        present = self.gdscript_function(source, "_present_notification")
        self.assertIn("if _notification_visible():", present)
        self.assertIn('on_notification_presented', present)
        dismiss = self.gdscript_function(source, "_on_notification_dismiss_requested")
        self.assertIn('on_notification_dismissed', dismiss)
        self.assertNotIn("_mark_thread_read", dismiss)
        mark_read = self.gdscript_function(source, "_mark_thread_read")
        self.assertIn('on_thread_read', mark_read)
        choices = self.gdscript_function(source, "_notify_runtime_choices_presented")
        self.assertIn("conversation_screen.choice_bar.choice_count() != choices.size()", choices)
        self.assertIn('on_choices_presented', choices)

    def test_existing_typing_ordered_suffix_and_single_ui_are_reused(self):
        screen = self.read(SCREEN)
        self.assertIn("_replace_runtime_typing_with_message(message)", screen)
        self.assertIn("Runtime provider delta is not a strict normalized ordered suffix", screen)
        self.assertIn("runtime_presented_message_ids_by_thread", screen)
        self.assertEqual(1, screen.count("CONVERSATION_SCREEN_SCENE.instantiate()"))
        self.assertEqual(1, screen.count("NOTIFICATION_BANNER_SCRIPT.new()"))
        self.assertNotIn("MessageTimeline.new()", screen)
        self.assertNotIn("ChoiceBar.new()", screen)

    def test_snapshot_is_bounded_and_port_snapshot_contract_stays_v1(self):
        source = self.read(ADAPTER)
        snapshot = self.gdscript_function(source, "snapshot")
        self.assertIn('"snapshot_version": SNAPSHOT_VERSION', snapshot)
        self.assertIn('"active": _active.duplicate(true)', snapshot)
        self.assertIn('"presented_message_ids_by_thread"', snapshot)
        restore = self.gdscript_function(source, "restore")
        self.assertLess(restore.index("_source_matches_metadata"), restore.index("_source ="))
        self.assertLess(restore.index("_presented_ids_match_source"), restore.index("_source ="))
        self.assertLess(restore.index("_active_matches_execution"), restore.index("_active ="))
        port = self.gdscript_function(self.read(PORT), "snapshot")
        self.assertIn('"snapshot_version": 1', port)
        runtime_snapshot = self.read("game/scripts/unified_runtime/execution/UnifiedRuntimeSnapshotV1.gd")
        self.assertIn("const SCHEMA_VERSION := 1", runtime_snapshot)

    def test_snapshot_candidate_shape_prefix_and_active_are_closed(self):
        source = self.read(ADAPTER)
        source_validation = self.gdscript_function(source, "_source_matches_metadata")
        for proof in [
            "_has_exact_keys(candidate, expected_source.keys())",
            "_thread_snapshot_matches_catalog",
            "_messages_are_closed",
            "_choices_are_closed",
            "_thread_mutable_fields_match_messages",
        ]:
            self.assertIn(proof, source_validation)
        presented = self.gdscript_function(source, "_presented_ids_match_source")
        self.assertIn("_has_exact_keys(candidate, thread_ids)", presented)
        self.assertIn("source_ids.slice(0, presented.size())", presented)
        active = self.gdscript_function(source, "_active_matches_execution")
        self.assertIn("_executor.current_beat()", active)
        self.assertIn("request != expected_request", active)
        self.assertIn('candidate.get("thread_id") != thread_id', active)
        closed_choice = self.gdscript_function(source, "_active_choice_matches")
        self.assertIn('execution.get("execution_status") == "RESOLUTION_READY"', closed_choice)
        self.assertIn("_player_bubble_dto(authored_choice, candidate)", closed_choice)
        self.assertIn('selected_choice_id in execution.get("consumed_choice_ids", [])', closed_choice)

    def test_snapshot_smoke_covers_refusals_and_transactional_state(self):
        smoke = self.read(SMOKE)
        for proof in [
            '"thread inconnu ajoute"',
            '"thread connu retire"',
            '"participants immuables falsifies"',
            '"titre immutable falsifie"',
            '"avatar immutable falsifie"',
            '"cle messages_by_thread inconnue"',
            '"cle choices_by_thread inconnue"',
            '"message authored falsifie"',
            '"message injecte refuse"',
            '"ID presente inconnu"',
            '"ordre prefixe presente falsifie"',
            '"active.thread_id falsifie"',
            '"active.message_ids MESSAGE falsifie"',
            '"active.choice_ids CHOICE falsifie"',
            '"selected_choice_id ferme divergeant"',
            '"player_bubble_id ferme divergeant"',
            '"snapshot CHOICE ferme coherent accepte"',
            "sans mutation adaptateur",
        ]:
            self.assertIn(proof, smoke)

    def test_smoke_covers_real_message_choice_refusals_and_no_early_write(self):
        smoke = self.read(SMOKE)
        for proof in [
            "MessagesScreenScene.instantiate()",
            "screen.configure_content_source(source, adapter)",
            '"notification reellement visible"',
            '"dismissal conserve unread"',
            '"typing unique"',
            '"bulle MESSAGE presentee une fois"',
            '"ACK READ de progression unique"',
            '"ChoiceBar authored rendue"',
            '"bulle Player unique"',
            '"choix consomme exactement une fois"',
            '"replay sans seconde bulle Player"',
            '"aucune mutation A1-A5 avant commit externe"',
            '"UNRESOLVED_PARTICIPANT"',
            '"THREAD_NOT_FOUND"',
            '"AMBIGUOUS_THREAD"',
            '"UNRESOLVED_CONTENT_REF"',
            '"UNSUPPORTED_TARGET"',
            '"snapshot adaptateur restaure"',
        ]:
            self.assertIn(proof, smoke)

    def test_scene_links_smoke_and_success_marker(self):
        self.assertIn(
            "res://tests/R8C_N15_2MessagesUIProjectionSmokeDriver.gd",
            self.read(SCENE),
        )
        self.assertIn(
            "R8C_N15_2_MESSAGES_UI_PROJECTION: OK (%d controls)",
            self.read(SMOKE),
        )

    def test_a10_surface_still_has_exactly_seven_operations(self):
        source = self.read("game/scripts/narrative_scene/NarrativeOrchestrationFacade.gd")
        public = re.findall(r"^(?:static )?func ([a-z][a-z0-9_]*)\(", source, re.M)
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


if __name__ == "__main__":
    unittest.main()
