import copy
import json
import subprocess
import sys
import unittest
from pathlib import Path

from tools.a11_authoring_workshop import validate_draft_format
from tools.a11_plan_draft_export import (
    CANON_DECISION_KEYS,
    CANON_REVIEW_STATUSES,
    EDITORIAL_BEAT_IDS,
    EDITORIAL_TRACEABILITY_KEYS,
    EDITORIAL_VALIDATION_KEYS,
    PILOT_BLIND_READING_PATH,
    PILOT_DECISION_PATH,
    PILOT_DRAFT_PATH,
    PILOT_HUMAN_REVIEW_PATH,
    PILOT_PLAN_PATH,
    PILOT_PROVENANCE_PATH,
    PILOT_SOURCE_PATH,
    PILOT_TRACEABILITY_PATH,
    PILOT_VALIDATION_PATH,
    build_editorial_traceability,
    editorial_draft_projection,
    editorial_source_content_sha256,
    editorial_source_projection,
    load_editorial_pilot_workspace,
    render_editorial_blind_reading,
    render_editorial_human_review,
    run_editorial_pilot_smoke,
    validate_editorial_decision,
    validate_editorial_json_library,
    validate_editorial_pilot,
    validate_editorial_source_format,
    validate_provenance_format,
)


ROOT = Path(__file__).resolve().parents[1]
TOOL = ROOT / "tools/a11_plan_draft_export.py"
DOC = ROOT / "docs/architecture/R8C_A11_5_PREMIERE_SCENE_PILOTE_EDITORIALE.md"
BASELINE = "93d8bbf6095ceaaaffc281b8d42048e1389ba5d3"
SOURCE_SHA256 = "9167120abc55dbf4275ac67eb7b4f774a58322587d87c9310644e3bcf85982dd"


class R8CA115FirstEditorialScenePilotTests(unittest.TestCase):
    def setUp(self):
        self.workspace = load_editorial_pilot_workspace()

    @staticmethod
    def codes(report, field="blocking_errors"):
        return {item["code"] for item in report[field]}

    def mutant(self):
        return load_editorial_pilot_workspace(include_outputs=False)

    def test_exact_baseline_branch_and_expected_files(self):
        expected = [
            PILOT_SOURCE_PATH,
            PILOT_PROVENANCE_PATH,
            PILOT_PLAN_PATH,
            PILOT_DRAFT_PATH,
            PILOT_VALIDATION_PATH,
            PILOT_TRACEABILITY_PATH,
            PILOT_BLIND_READING_PATH,
            PILOT_HUMAN_REVIEW_PATH,
            PILOT_DECISION_PATH,
            TOOL,
            DOC,
        ]
        self.assertEqual([], [str(path) for path in expected if not path.is_file()])
        self.assertEqual(
            BASELINE,
            subprocess.check_output(
                ["git", "rev-parse", "r8c-a11-4-plan-draft-a6-test-export^{}"],
                cwd=ROOT,
                text=True,
            ).strip(),
        )
        self.assertEqual(
            "work/r8c-a11-5-first-editorial-scene-pilot",
            subprocess.check_output(
                ["git", "branch", "--show-current"], cwd=ROOT, text=True
            ).strip(),
        )

    def test_source_is_byte_for_byte_equivalent_to_integrated_narrative(self):
        source = self.workspace["source"]
        self.assertEqual(SOURCE_SHA256, editorial_source_content_sha256(source))
        self.assertEqual(
            editorial_source_projection(source),
            editorial_draft_projection(self.workspace),
        )
        self.assertEqual("Sandra — Les chaises bleues", source["title"])
        self.assertEqual(46, len(source["pre_choice_messages"]))
        self.assertEqual([5, 5], [len(option["reception_messages"]) for option in source["choice"]["options"]])
        self.assertEqual(42, len(source["convergence_messages"]))
        self.assertEqual(
            ["Que ça m’avait manqué.", "Que nos agendas sont nuls."],
            [option["formulation"] for option in source["choice"]["options"]],
        )
        self.assertEqual("🙂", source["convergence_messages"][-1]["text"])

    def test_closed_source_provenance_draft_and_output_contracts(self):
        self.assertEqual([], validate_editorial_source_format(self.workspace["source"]))
        self.assertEqual([], validate_provenance_format(self.workspace["provenance"]))
        self.assertEqual([], validate_draft_format(self.workspace["draft"]))
        self.assertEqual(3, self.workspace["draft"]["version"])
        self.assertEqual(EDITORIAL_VALIDATION_KEYS, set(self.workspace["validation_report"]))
        self.assertEqual(EDITORIAL_TRACEABILITY_KEYS, set(self.workspace["traceability_report"]))
        self.assertEqual(CANON_DECISION_KEYS, set(self.workspace["decision"]))

        for validator, key in (
            (validate_editorial_source_format, "source"),
            (validate_provenance_format, "provenance"),
        ):
            document = copy.deepcopy(self.workspace[key])
            document["unexpected"] = True
            self.assertIn("CLOSED_SCHEMA_MISMATCH", {issue.code for issue in validator(document)})

        malformed_provenance = copy.deepcopy(self.workspace["provenance"])
        del malformed_provenance["local_facts"][0]["fact_id"]
        self.assertIn(
            "CLOSED_SCHEMA_MISMATCH",
            {issue.code for issue in validate_provenance_format(malformed_provenance)},
        )

    def test_plan_realizes_the_seven_ordered_beats_and_only_two_participants(self):
        plan = self.workspace["planning"]["plan"]
        self.assertEqual(list(EDITORIAL_BEAT_IDS), [beat["beat_id"] for beat in plan["beats"]])
        self.assertEqual(["player", "sandra"], plan["participant_ids"])
        self.assertEqual("ONE", plan["choice_mode"])
        self.assertEqual("small_importance_confirmation", plan["maximum_change"]["outcome_id"])
        self.assertIn("reste possible", plan["maximum_change"]["description"])
        self.assertEqual("REVOCABLE_RECONTACT", plan["protective_close"]["future_possibility"])
        self.assertEqual("REQUIRED", plan["media_requirement"]["media_decision"])

        trace = self.workspace["traceability_report"]
        self.assertEqual(list(range(1, 8)), [beat["position"] for beat in trace["beat_trace"]])
        self.assertEqual(list(EDITORIAL_BEAT_IDS), [beat["beat_id"] for beat in trace["beat_trace"]])
        self.assertTrue(all(beat["message_ids"] for beat in trace["beat_trace"]))

    def test_counts_bursts_weak_messages_choice_and_media_are_explicit(self):
        counts = validate_editorial_pilot(self.workspace)["counts"]
        self.assertEqual(98, counts["stored_message_elements"])
        self.assertEqual(
            {"careful_warmth": 93, "ironic_withdrawal": 93},
            counts["playable_path_elements"],
        )
        self.assertEqual(13, counts["burst_groups_stored"])
        self.assertEqual(15, counts["weak_messages_stored"])

        draft = self.workspace["draft"]
        self.assertEqual("m46", draft["choice"]["after_message_id"])
        self.assertEqual("m52", draft["choice"]["converge_at_message_id"])
        receptions = [set(option["reception_message_ids"]) for option in draft["choice"]["options"]]
        self.assertTrue(receptions[0].isdisjoint(receptions[1]))
        images = [message for message in draft["messages"] if message["kind"] == "IMAGE"]
        self.assertEqual(["m01"], [message["message_id"] for message in images])
        self.assertEqual("photo_sandra_cafe_blue_chairs", images[0]["media"]["media_id"])
        self.assertEqual("local_terrace_photo", images[0]["media"]["linked_fact_id"])

    def test_provenance_is_local_and_does_not_change_persisted_a11_sources(self):
        provenance = self.workspace["provenance"]
        self.assertEqual(
            {"local_cafe", "local_blue_chairs", "local_cold_fries", "local_terrace_photo"},
            {fact["fact_id"] for fact in provenance["local_facts"]},
        )
        for fact in provenance["local_facts"]:
            self.assertEqual("SCENE_LOCAL_ONLY", fact["persistence"])
            self.assertEqual({"player", "sandra"}, set(fact["known_by"]))
        self.assertFalse(self.workspace["traceability_report"]["fact_trace"]["durable_effect"])

        a11_sources = subprocess.check_output(
            ["git", "diff", "--name-only", BASELINE, "--", "narrative_tool/a11/characters", "narrative_tool/a11/relationships"],
            cwd=ROOT,
            text=True,
        ).splitlines()
        self.assertEqual([], a11_sources)

    def test_validation_is_deterministic_and_voice_specific(self):
        first = validate_editorial_pilot(self.workspace)
        second = validate_editorial_pilot(self.workspace)
        self.assertEqual(first, second)
        self.assertEqual("READY_WITH_WARNINGS", first["status"])
        self.assertEqual([], first["blocking_errors"])
        self.assertEqual({"SOURCE_REPETITION_REVIEW"}, self.codes(first, "warnings"))
        voices = build_editorial_traceability(self.workspace)["voice_validation"]
        self.assertTrue(voices["sandra"]["compatible"])
        self.assertTrue(voices["player"]["compatible"])
        self.assertFalse(voices["marie"]["compatible"])
        self.assertFalse(voices["mathilde"]["compatible"])
        self.assertIn("VOICE_RULE_INCOMPATIBLE", voices["marie"]["issue_codes"])
        self.assertIn("VOICE_RULE_INCOMPATIBLE", voices["mathilde"]["issue_codes"])

    def test_added_removed_and_modified_bubbles_are_refused(self):
        added = self.mutant()
        extra = copy.deepcopy(added["draft"]["messages"][-1])
        extra["message_id"] = "m94"
        extra["reply_to"] = "m93"
        added["draft"]["messages"].append(extra)
        self.assertIn("EDITORIAL_ELEMENT_COUNT_INVALID", self.codes(validate_editorial_pilot(added)))

        removed = self.mutant()
        removed["draft"]["messages"].pop()
        self.assertIn("EDITORIAL_ELEMENT_COUNT_INVALID", self.codes(validate_editorial_pilot(removed)))

        modified = self.mutant()
        modified["draft"]["messages"][1]["text"] += " !"
        self.assertIn("SOURCE_CONTENT_MISMATCH", self.codes(validate_editorial_pilot(modified)))

        malformed = self.mutant()
        del malformed["draft"]["messages"]
        malformed_report = validate_editorial_pilot(malformed)
        self.assertEqual("BLOCKED", malformed_report["status"])
        self.assertIn("CLOSED_SCHEMA_MISMATCH", self.codes(malformed_report))

    def test_missing_or_unjustified_media_and_unapproved_fact_are_refused(self):
        missing = self.mutant()
        missing["draft"]["messages"][0]["kind"] = "TEXT"
        missing["draft"]["messages"][0]["media"] = None
        self.assertIn("MEDIA_REQUIRED", self.codes(validate_editorial_pilot(missing)))

        unjustified = self.mutant()
        unjustified["draft"]["messages"][0]["media"]["justification"] = "Prétexte visuel."
        self.assertIn("MEDIA_UNJUSTIFIED", self.codes(validate_editorial_pilot(unjustified)))

        foreign_fact = self.mutant()
        foreign_fact["draft"]["messages"][1]["fact_refs"] = ["marie_missed_commitment"]
        self.assertIn("FACT_NOT_AUTHORIZED", self.codes(validate_editorial_pilot(foreign_fact)))

    def test_acquired_meeting_and_durable_local_fact_are_refused(self):
        acquired = self.mutant()
        acquired["draft"]["messages"][78]["text"] = "On se voit vendredi à 20 h"
        self.assertIn("MEETING_PRESENTED_AS_ACQUIRED", self.codes(validate_editorial_pilot(acquired)))

        durable = self.mutant()
        durable["provenance"]["local_facts"][0]["persistence"] = "A1_DURABLE_FACT"
        self.assertIn("LOCAL_FACT_BECAME_DURABLE", self.codes(validate_editorial_pilot(durable)))

    def test_marie_participation_and_identical_receptions_are_refused(self):
        marie = self.mutant()
        marie["planning"]["plan"]["participant_ids"].append("marie")
        self.assertIn("UNEXPECTED_PARTICIPANT", self.codes(validate_editorial_pilot(marie)))

        identical = self.mutant()
        by_id = {message["message_id"]: message for message in identical["draft"]["messages"]}
        option_a, option_b = identical["draft"]["choice"]["options"]
        for a_id, b_id in zip(option_a["reception_message_ids"], option_b["reception_message_ids"]):
            for field in ("speaker_id", "objective_actor_id", "conversation_move", "text"):
                by_id[b_id][field] = by_id[a_id][field]
        self.assertIn("CHOICE_RECEPTION_NOT_DISTINCT", self.codes(validate_editorial_pilot(identical)))

    def test_blind_reading_is_anonymized_and_human_only(self):
        rendered = render_editorial_blind_reading(self.workspace)
        dialogue, questionnaire = rendered.split("## Fiche humaine", 1)
        self.assertNotIn("Sandra", dialogue)
        self.assertNotIn("Ludo", dialogue)
        self.assertNotIn("Player", dialogue)
        self.assertNotIn("photo_sandra_cafe_blue_chairs", dialogue)
        self.assertIn("**Voix A**", dialogue)
        self.assertIn("**Voix B**", dialogue)
        self.assertEqual(5, questionnaire.count("- "))
        self.assertIn("Aucune notation automatique", questionnaire)
        self.assertEqual(PILOT_BLIND_READING_PATH.read_text(encoding="utf-8"), rendered)

    def test_human_decision_is_closed_allowed_and_not_automatic(self):
        decision = self.workspace["decision"]
        self.assertIn(decision["status"], CANON_REVIEW_STATUSES)
        self.assertEqual("APPROVED_FOR_CANON_REVIEW", decision["status"])
        self.assertEqual("CANON_REVIEW", decision["decision"])
        self.assertEqual([], validate_editorial_decision(self.workspace, decision))
        self.assertTrue(decision["blind_reading_result"]["too_written_passages"])
        self.assertTrue(decision["blind_reading_result"]["marie_or_mathilde_overlap"])
        self.assertTrue(decision["blind_reading_result"]["repetitions_to_discuss"])
        serialized = json.dumps(decision, ensure_ascii=False).casefold()
        self.assertNotIn("automatic_" + "sco" + "re", serialized)
        self.assertEqual(
            PILOT_HUMAN_REVIEW_PATH.read_text(encoding="utf-8"),
            render_editorial_human_review(self.workspace, decision),
        )

    def test_library_cli_and_mutation_smoke(self):
        library = validate_editorial_json_library()
        self.assertTrue(library["ok"])
        self.assertEqual(SOURCE_SHA256, library["source_content_sha256"])
        smoke = run_editorial_pilot_smoke()
        self.assertTrue(smoke["ok"])
        self.assertFalse(smoke["a6_export"])
        self.assertFalse(smoke["runtime_wiring"])

        for command in ("validate-pilot", "pilot-review", "pilot-blind", "pilot-smoke"):
            completed = subprocess.run(
                [sys.executable, str(TOOL), command],
                cwd=ROOT,
                text=True,
                encoding="utf-8",
                capture_output=True,
                check=False,
            )
            self.assertEqual(0, completed.returncode, completed.stderr)

    def test_no_game_a6_or_runtime_mutation_and_no_forbidden_mechanisms(self):
        changed_game = subprocess.check_output(
            ["git", "diff", "--name-only", BASELINE, "--", "game"], cwd=ROOT, text=True
        ).splitlines()
        self.assertEqual([], changed_game)
        self.assertEqual([], subprocess.check_output(["git", "status", "--short", "game"], cwd=ROOT, text=True).splitlines())
        self.assertFalse(self.workspace["traceability_report"]["a6_export"])
        self.assertFalse(self.workspace["traceability_report"]["runtime_wiring"])

        lot_paths = [
            TOOL,
            ROOT / "tools/a11_authoring_workshop.py",
            ROOT / "tools/a11_scene_planning.py",
            PILOT_SOURCE_PATH,
            PILOT_PROVENANCE_PATH,
            PILOT_PLAN_PATH,
            PILOT_DRAFT_PATH,
            PILOT_VALIDATION_PATH,
            PILOT_TRACEABILITY_PATH,
            PILOT_DECISION_PATH,
        ]
        corpus = "\n".join(path.read_text(encoding="utf-8").casefold() for path in lot_paths)
        forbidden = (
            "sco" + "re",
            "rank" + "ing",
            "prior" + "ity",
            "ran" + "domnumbergenerator",
            "ran" + "di(",
            "ran" + "df(",
            "sea" + "son1runtimeprovider",
            "lega" + "cy",
        )
        for token in forbidden:
            self.assertNotIn(token, corpus)


if __name__ == "__main__":
    unittest.main()
