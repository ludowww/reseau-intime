import json
import subprocess
import unittest
from pathlib import Path

from tools.a11_plan_draft_export import (
    N2_DECISION_PATH,
    N2_SOURCE_PATH,
    editorial_source_content_sha256,
)


ROOT = Path(__file__).resolve().parents[1]
BASELINE = "2bd49d728fb1e812a16fc18b7fdd844d74f51dbf"
BASELINE_TAG = "r8c-n4-1-canon-runtime-placement-clarification"
BUNDLE_PATH = ROOT / "game/data/narrative_scenes/r8c_n5_sandra_blue_chairs_staged.json"
REPORT_PATH = ROOT / "narrative_tool/a11/revisions/sandra_blue_chairs_r8c_n5.projection_report.json"
DOC_PATH = ROOT / "docs/narrative/R8C_N5_SANDRA_BLUE_CHAIRS_STAGED_SEASON_PROJECTION.md"
SCENE_ID = "sandra_blue_chairs_definition"
VARIANT_ID = "sandra_blue_chairs_canonical"
MEDIA_ID = "photo_sandra_cafe_blue_chairs"
TRACE_ID = "sandra_recontact_importance_received_understood"
TRACE_TEXT = "Sandra a reçu et compris que la reprise du contact compte pour Player."
SOURCE_CONTENT_SHA256 = "aac0ab82b735467e0d65df6d555f2ff62be2956e6acb5227e5b838112cfa5d77"


class R8CN5SandraBlueChairsStagedProjectionTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.source = json.loads(N2_SOURCE_PATH.read_text(encoding="utf-8"))
        cls.decision = json.loads(N2_DECISION_PATH.read_text(encoding="utf-8"))
        cls.bundle = json.loads(BUNDLE_PATH.read_text(encoding="utf-8"))
        cls.report = json.loads(REPORT_PATH.read_text(encoding="utf-8"))
        cls.entry = cls.bundle["definitions"][0]
        cls.definition = cls.entry["definition"]

    def test_exact_baseline_parent_and_deliverables(self):
        self.assertEqual(
            BASELINE,
            subprocess.check_output(
                ["git", "rev-parse", f"{BASELINE_TAG}^{{}}"], cwd=ROOT, text=True
            ).strip(),
        )
        self.assertEqual(
            BASELINE,
            subprocess.check_output(
                ["git", "merge-base", "HEAD", BASELINE_TAG], cwd=ROOT, text=True
            ).strip(),
        )
        self.assertTrue(BUNDLE_PATH.is_file())
        self.assertTrue(REPORT_PATH.is_file())
        self.assertTrue(DOC_PATH.is_file())

    def test_n2_canon_source_is_exact_and_unchanged(self):
        self.assertEqual("CANON_APPROVED", self.decision["decision"])
        self.assertEqual(SOURCE_CONTENT_SHA256, editorial_source_content_sha256(self.source))
        self.assertEqual(SOURCE_CONTENT_SHA256, self.report["canonical_source"]["source_content_sha256"])
        stored_elements = (
            len(self.source["pre_choice_messages"])
            + sum(len(option["reception_messages"]) for option in self.source["choice"]["options"])
            + len(self.source["convergence_messages"])
        )
        self.assertEqual(96, stored_elements)

        messages = {
            message["message_id"]: message
            for message in self.source["pre_choice_messages"] + self.source["convergence_messages"]
        }
        self.assertEqual("ou alors je deviens vieille 😅", messages["m04"]["text"])
        self.assertEqual("bonne soirée", messages["m91"]["text"])
        self.assertEqual("🙂", messages["m93"]["text"])
        self.assertEqual({"😅", "🙂"}, {
            character
            for message in messages.values()
            for character in message["text"]
            if character in {"😅", "🙂"}
        })

    def test_choices_receptions_and_convergence_are_preserved(self):
        source_choice = self.source["choice"]
        self.assertEqual("player_response_to_sandra_test", source_choice["choice_id"])
        self.assertEqual("m53", source_choice["converge_at_message_id"])
        self.assertEqual(
            ["careful_warmth", "ironic_withdrawal"],
            [option["option_id"] for option in source_choice["options"]],
        )
        self.assertEqual(
            ["Que ça m’avait manqué.", "Que nos agendas sont nuls."],
            [option["formulation"] for option in source_choice["options"]],
        )
        self.assertEqual(
            ["m47A", "m48A", "m49A", "m50A", "m51A", "m51A-2", "m51A-3"],
            [message["message_id"] for message in source_choice["options"][0]["reception_messages"]],
        )
        self.assertEqual(
            ["m47B", "m48B", "m49B", "m50B", "m51B", "m52B"],
            [message["message_id"] for message in source_choice["options"][1]["reception_messages"]],
        )
        self.assertEqual(
            ["careful_warmth", "ironic_withdrawal"],
            [choice["choix_id"] for choice in self.definition["choix"]],
        )
        self.assertEqual(
            ["Que ça m’avait manqué.", "Que nos agendas sont nuls."],
            [choice["formulation"] for choice in self.definition["choix"]],
        )

    def test_a6_definition_is_closed_canonical_and_staged(self):
        self.assertEqual("R8C_A6_SCENE_LIBRARY", self.bundle["format"])
        self.assertEqual(1, self.bundle["version"])
        self.assertEqual(1, len(self.bundle["definitions"]))
        self.assertEqual(SCENE_ID, self.entry["scene_definition_id"])
        self.assertEqual(VARIANT_ID, self.entry["variant_id"])
        self.assertEqual(SCENE_ID, self.definition["scene_id"])
        self.assertEqual("MODULAIRE", self.definition["nature"])
        self.assertEqual("UNIQUE", self.definition["politique_unicite"])
        self.assertEqual(
            ["player", "sandra"],
            [participant["personnage_id"] for participant in self.definition["participants_requis"]],
        )
        for identity in (SCENE_ID, VARIANT_ID, self.definition["structure_id"]):
            lowered = identity.casefold()
            self.assertNotIn("j04", lowered)
            self.assertNotIn("chapter_04", lowered)
            self.assertNotRegex(lowered, r"\b\d{1,2}:\d{2}\b")
        for forbidden_field in ("messages", "media", "media_requirement", "author_metadata", "projection_status"):
            self.assertNotIn(forbidden_field, self.definition)
        self.assertEqual("RUNTIME_PROJECTION_STAGED", self.report["status"])
        self.assertEqual("EXPLICIT_PATH_TESTS_AND_SMOKES_ONLY", self.report["staged_bundle"]["load_mode"])

    def test_a1_a3_prerequisites_are_discrete_and_bounded(self):
        expected_required = [
            "sandra_recontact_reactivated",
            "sandra_first_complicity_restored",
            "sandra_shared_lunch_memory_available",
            "sandra_short_pause_after_recontact_elapsed",
        ]
        expected_forbidden = [
            "sandra_distance_requested",
            "sandra_conflict_active",
            "sandra_new_lunch_agreed",
            "sandra_progression_advanced",
            "sandra_explicit_intimacy_established",
            "sandra_route_locked",
        ]
        self.assertEqual(expected_required, self.definition["conditions_dures"]["evenements_requis"])
        self.assertEqual(expected_forbidden, self.definition["exclusions_dures"]["evenements_interdits"])
        mappings = self.report["a1_a3_prerequisites"]["required_events"]
        self.assertEqual(expected_required, [mapping["event_id"] for mapping in mappings])
        self.assertTrue(all(mapping["kind"] == "MINIMAL_DISCRETE_BRIDGE_EVENT" for mapping in mappings))
        self.assertTrue(all(mapping["season_1_provenance"] for mapping in mappings))
        self.assertFalse(self.report["a1_a3_prerequisites"]["activation_bridge_implemented"])

    def test_only_one_durable_fact_can_be_written_after_resolution(self):
        resolutions = self.definition["resolutions"]
        self.assertEqual({"careful_warmth_received", "ironic_withdrawal_received"}, set(resolutions))
        for resolution in resolutions.values():
            self.assertEqual("DURABLE", resolution["portee_micro_signal"])
            self.assertEqual("RECUE_INTERPRETEE", resolution["reception"])
            self.assertEqual("RETOUR_NOYAU_COMMUN", resolution["convergence"])
            self.assertEqual(1, len(resolution["faits_relationnels"]))
            fact = resolution["faits_relationnels"][0]
            self.assertEqual(TRACE_ID, fact["fait_id"])
            self.assertEqual("sandra", fact["recu_par"])
            self.assertFalse(fact["permission_future"])
        trace = self.report["durable_trace"]
        self.assertEqual(TRACE_ID, trace["fact_id"])
        self.assertEqual(TRACE_TEXT, trace["text"])
        self.assertTrue(trace["created_only_after_complete_resolution"])
        for phase in (
            "created_at_eligibility",
            "created_at_reservation",
            "created_at_proposal",
            "created_at_window_open",
            "created_at_expiration",
        ):
            self.assertFalse(trace[phase])
        self.assertFalse(trace["score_or_accumulator"])

    def test_a8_and_a9_projection_are_strict(self):
        a8 = self.report["a8_policy"]
        self.assertEqual("CLOSE_SILENTLY", a8["before_proposal"])
        self.assertEqual("NOT_SELECTED_WITHOUT_A5_INSTANCE", a8["before_proposal_result"])
        self.assertEqual("KEEP_PROPOSED_INSTANCE_PLAYABLE_UNTIL_RESOLUTION", a8["after_proposal"])
        self.assertEqual("REJECTED_FOR_THIS_SCENE", a8["mark_missed_if_proposed"])
        self.assertFalse(a8["missed_relation_consequence"])
        self.assertFalse(a8["a1_trace_on_expiration"])
        self.assertIn("no public operation", a8["known_activation_blocker"])

        projection = self.report["runtime_projection"]
        self.assertEqual("16:30", projection["opens_at"])
        self.assertEqual("18:04", projection["last_schedulable_minute"])
        self.assertEqual("18:05", projection["hard_next_scene_starts_at"])
        self.assertEqual("18:00", projection["planned_end"])
        self.assertEqual(4, projection["buffer_before_next_scene_minutes"])
        self.assertEqual(
            ["chapter_04_nico_saved_seat_followup", SCENE_ID, "chapter_04_marie_household_report"],
            projection["author_order"],
        )
        slot = self.report["a9_slot"]
        self.assertEqual("18:04", slot["ends_at"])
        self.assertEqual("18:05", slot["reject_end_at_or_after"])
        self.assertFalse(slot["numeric_priority"])

    def test_j05_incompatibility_uses_stable_identity_without_rewrite(self):
        rule = self.report["j05_incompatibility"]
        self.assertEqual("chapter_05_sandra_photo_continuity", rule["conversation_id"])
        self.assertEqual("sandra_saturday_photo_continuity_01", rule["stable_scene_id"])
        self.assertEqual("SILENTLY_INELIGIBLE_BEFORE_PROPOSAL", rule["if_n2_proposed"])
        self.assertEqual("EVALUATE_NORMALLY", rule["if_n2_never_proposed"])
        self.assertFalse(rule["missed"])
        self.assertFalse(rule["absence_narrative"])
        self.assertFalse(rule["relation_consequence"])
        self.assertFalse(rule["runtime_bridge_implemented"])
        changed = subprocess.check_output(
            [
                "git",
                "diff",
                "--name-only",
                BASELINE,
                "--",
                "game/data/conversations/chapter_05_sandra_photo_continuity.json",
                "game/scripts/runtime/season_1/J05RuntimeProvider.gd",
                "game/scripts/runtime/season_1/Season1State.gd",
            ],
            cwd=ROOT,
            text=True,
        ).splitlines()
        self.assertEqual([], changed)

    def test_missing_media_blocks_activation_without_placeholder_or_gallery(self):
        media = self.report["media_gate"]
        self.assertEqual(MEDIA_ID, media["media_id"])
        self.assertEqual("ASSET_REQUIRED_NOT_READY", media["status"])
        for field in (
            "final_asset_present",
            "visible_placeholder",
            "old_asset_reused",
            "gallery_unlock",
            "player_activation_allowed",
        ):
            self.assertFalse(media[field])

        active_roots = [
            ROOT / "game/scripts/runtime/season_1",
            ROOT / "game/scripts/ui",
            ROOT / "game/scenes/portrait",
            ROOT / "game/data/conversations",
            ROOT / "game/data/runtime/season_1",
            ROOT / "game/data/visual_content",
            ROOT / "game/assets",
        ]
        needles = (SCENE_ID, VARIANT_ID, BUNDLE_PATH.name, MEDIA_ID)
        offenders = []
        for root in active_roots:
            if not root.exists():
                continue
            for path in root.rglob("*"):
                if not path.is_file():
                    continue
                try:
                    content = path.read_text(encoding="utf-8")
                except UnicodeDecodeError:
                    continue
                for needle in needles:
                    if needle in content:
                        offenders.append(f"{path.relative_to(ROOT)}:{needle}")
        self.assertEqual([], offenders)
        self.assertTrue(all(value is False for value in self.report["player_reachability"].values()))

    def test_json_and_forbidden_mechanism_controls(self):
        self.assertIsInstance(self.bundle, dict)
        self.assertIsInstance(self.report, dict)
        serialized_bundle = json.dumps(self.bundle, ensure_ascii=False).casefold()
        for token in (
            "score",
            "ranking",
            "priority",
            "random",
            "legacy",
            "season1runtimeprovider",
            "chapter_04",
        ):
            self.assertNotIn(token, serialized_bundle)
        self.assertNotIn("politique_non_resolution", self.definition)


if __name__ == "__main__":
    unittest.main()
