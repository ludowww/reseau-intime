import hashlib
import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
SEQUENCE = GAME / "data/unified_runtime/sequences/marie_evening_return_01.json"
PRESENTATION = GAME / "data/unified_runtime/presentation"
MESSAGES = PRESENTATION / "marie_evening_return_01_messages.json"
PHYSICAL = PRESENTATION / "marie_evening_return_01_physical.json"
MEDIA = PRESENTATION / "marie_evening_return_01_media.json"
CATALOG = GAME / "data/unified_runtime/catalogs/season_1_v1.json"
SOURCE = GAME / "data/conversations/chapter_03_marie_evening_return.json"
RUNTIME_MAP = GAME / "data/runtime/season_1/j03_runtime_map.json"
SMOKE = GAME / "tests/R8C_N20MarieEveningReturnSmokeDriver.gd"

PROTECTED_HASHES = {
    "data/unified_runtime/sequences/mathilde_returns_with_chosen_intent_01.json": "d17e6c18e341e52381435c32bc4ad99bd9736f1935c6fc54f08ebd63f9ea780b",
    "data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_messages.json": "aa66059551666bbbdf9604cede69ec2085f9aba3f9a7781093c03fb33cc54261",
    "data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_physical.json": "bb7bd963c7a3cdec2f650b27402ea22eb8681d5afa3ba1acec98ad722a7ae091",
    "data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_media.json": "49120e5e9ddf2997d9871defef50c05ab998ca3da65338161fa400d6b3c6840a",
    "data/unified_runtime/sequences/sandra_sentrycore_button_echo_01.json": "5cd7942a1f130bee5e2f75d0289f9db154251d2acc6b3934335bc5a4406b3979",
    "data/unified_runtime/presentation/sandra_sentrycore_button_echo_01_messages.json": "7e8072bc10acd272a18078bf3e79d5d396fb89bc9f938148bf19725099964216",
    "data/unified_runtime/presentation/sandra_sentrycore_button_echo_01_physical.json": "69c150db9975d78250e5c904f3704d2158f52058d7d596161dd76f82e50fe53f",
    "data/unified_runtime/presentation/sandra_sentrycore_button_echo_01_media.json": "29ce5e65d4cbab95e5000d4d7a886f547f42b4d70c2b11c707578ac3e0ae8147",
}


class R8CN20MarieEveningReturnStaticTests(unittest.TestCase):
    def load(self, path: Path):
        return json.loads(path.read_text(encoding="utf-8"))

    def test_identity_provenance_temporality_and_catalog_order(self):
        sequence = self.load(SEQUENCE)
        self.assertEqual("marie_evening_return_01", sequence["sequence_id"])
        self.assertEqual("1.0.0", sequence["authored_version"])
        self.assertEqual("movement_i", sequence["dramatic_movement_id"])
        self.assertEqual("RELATION", sequence["narrative_function"])
        self.assertEqual("CANON_APPROVED", sequence["canonical_status"])
        a6 = sequence["orchestration"]["a6_entry"]
        self.assertEqual("marie_evening_return_01", a6["scene_definition_id"])
        self.assertEqual("marie_evening_return_canonical", a6["variant_id"])
        self.assertEqual("MODULAIRE", a6["definition"]["nature"])
        self.assertEqual("UNIQUE", a6["definition"]["politique_unicite"])
        provenance = json.dumps(sequence["author_provenance"], ensure_ascii=False)
        for source in [
            "chapter_03_marie_evening_return",
            "O4_MARIE_RETURN",
            "NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md",
            "MARIE_CANON_FULL.md",
            "j03_runtime_map.json",
        ]:
            self.assertIn(source, provenance)
        self.assertNotIn("chapter_03_marie_event_return", provenance)
        self.assertEqual(
            {"opens_at": "2032-03-05T18:20:00+01:00", "closes_at": "2032-03-05T20:31:00+01:00"},
            sequence["temporal_projection"]["resolved_window"],
        )
        self.assertEqual(
            [
                "mathilde_returns_with_chosen_intent_01",
                "sandra_sentrycore_button_echo_01",
                "marie_evening_return_01",
                "nico_saved_seat_01",
                "marie_household_report_01",
            ],
            [package["sequence_id"] for package in self.load(CATALOG)["packages"]],
        )

    def test_exact_dialogue_graph_and_local_resolution(self):
        sequence = self.load(SEQUENCE)
        beats = {beat["beat_id"]: beat for beat in sequence["beats"]}
        source = self.load(SOURCE)
        self.assertEqual(
            [message["text"] for message in source["segments"][0]["messages"]],
            [message["text"] for message in beats["marie_evening_opening"]["content"]["messages"]],
        )
        self.assertEqual(
            "Vers 19 h. Pourquoi ?",
            beats["marie_evening_guided_choice"]["content"]["choices"][0]["text"],
        )
        self.assertEqual(
            [message["text"] for message in source["segments"][0]["choices"][0]["next_messages"]],
            [message["text"] for message in beats["marie_evening_meal_messages"]["content"]["messages"]],
        )
        local = sequence["resolutions"]["resolution_guided_reply"]
        self.assertIsNone(local["a10_choice_id"])
        self.assertIsNone(local["a10_resolution_id"])
        for field in [
            "event_refs", "fact_ids", "knowledge_ids", "trace_ids", "promise_effects",
            "obligation_effects", "consequence_ids", "media_effects",
        ]:
            self.assertEqual([], local[field])
        self.assertEqual("marie_evening_meal_messages", local["next_beat_id"])
        self.assertEqual(
            ["MESSAGE", "CHOICE", "MESSAGE", "CHOICE", "RETURN", "PHYSICAL_BEAT", "RETURN", "PHYSICAL_BEAT", "RETURN", "PHYSICAL_BEAT"],
            [beat["type"] for beat in sequence["beats"]],
        )

    def test_exact_three_postures_facts_returns_and_outcomes(self):
        sequence = self.load(SEQUENCE)
        source = self.load(SOURCE)
        beats = {beat["beat_id"]: beat for beat in sequence["beats"]}
        authored_choices = beats["marie_evening_posture_choice"]["content"]["choices"]
        self.assertEqual(
            [choice["text"] for choice in source["segments"][1]["choices"]],
            [choice["text"] for choice in authored_choices],
        )
        a6 = sequence["orchestration"]["a6_entry"]["definition"]
        self.assertEqual(3, len(a6["choix"]))
        self.assertEqual(3, len(a6["resolutions"]))
        expected = {
            "resolution_active": ("marie_evening_shared_presence_chosen", "PRESENCE_COMMUNE_CHOISIE", "return_active", "marie_evening_active_outcome"),
            "resolution_bounded": ("marie_evening_bounded_return_chosen", "DISPONIBILITE_BORNEE_ANNONCEE", "return_bounded", "marie_evening_bounded_outcome"),
            "resolution_drift": ("marie_evening_household_continues_without_player", "SOIREE_CONTINUE_SANS_PLAYER", "return_drift", "marie_evening_drift_outcome"),
        }
        media_id = "S1_A1_J03_SCN_MARIE_HOME_FROM_LAVERRIERE_01"
        for resolution_id, (fact_id, nature, return_id, outcome_id) in expected.items():
            resolution = sequence["resolutions"][resolution_id]
            self.assertEqual([fact_id], resolution["fact_ids"])
            self.assertEqual([{"media_id": media_id, "effect": "GRANT_ACCESS"}], resolution["media_effects"])
            self.assertEqual(return_id, resolution["next_beat_id"])
            self.assertEqual([resolution_id], beats[return_id]["content"]["eligible_resolution_ids"])
            self.assertEqual(outcome_id, beats[return_id]["next"]["beat_id"])
            self.assertEqual({"mode": "TERMINAL", "beat_id": None}, beats[outcome_id]["next"])
            a10_id = resolution["a10_resolution_id"]
            fact = a6["resolutions"][a10_id]["durable_manifest"]["facts"][0]
            self.assertEqual((fact_id, nature, "RELATION", "marie", "marie"), (
                fact["fact"]["fait_id"], fact["fact"]["nature"], fact["scope"], fact["personnage_id"], fact["fact"]["recu_par"],
            ))

        messages = self.load(MESSAGES)
        by_ref = {entry["content_ref"]: entry for entry in messages["entries"]}
        for index, posture in enumerate(["active", "bounded", "drift"]):
            self.assertEqual(
                [message["text"] for message in source["segments"][1]["choices"][index]["next_messages"]],
                [message["text"] for message in by_ref[f"marie_evening_{posture}_return_content"]["messages"]],
            )

        physical = {entry["content_ref"]: entry for entry in self.load(PHYSICAL)["entries"]}
        runtime_outcomes = self.load(RUNTIME_MAP)["marie_offline"]
        for posture, title in [("active", "19:05"), ("bounded", "19:35"), ("drift", "20:30")]:
            entry = physical[f"marie_evening_{posture}_outcome"]
            projected = " ".join([entry["body"], *entry["steps"]])
            exact = runtime_outcomes[posture.upper()]["text"].split(" — ", 1)[1]
            self.assertEqual(title, entry["title"])
            self.assertEqual(exact, projected)
            self.assertEqual("Continuer", entry["continue_label"])

    def test_media_is_single_non_diegetic_gallery_access(self):
        sequence = self.load(SEQUENCE)
        self.assertEqual(1, len(sequence["media"]))
        media_id, media = next(iter(sequence["media"].items()))
        self.assertEqual("S1_A1_J03_SCN_MARIE_HOME_FROM_LAVERRIERE_01", media_id)
        self.assertEqual("V0", media["visual_level"])
        self.assertIsNone(media["analytic_level"])
        self.assertEqual("SPECIFIED_NOT_PRODUCED", media["production_status"])
        self.assertEqual("NON_DIEGETIC", media["diegesis"])
        self.assertEqual(["player_only"], media["audience_ids"])
        self.assertEqual("ON_ACCESS", media["gallery_policy"])
        self.assertEqual("NEVER", media["removal_policy"])
        catalog_entry = self.load(MEDIA)["entries"][0]
        self.assertEqual("Visuel non livré", catalog_entry["placeholder_label"])
        self.assertEqual(["marie"], catalog_entry["gallery_character_ids"])
        self.assertNotIn("DIEGETIC", {media["diegesis"]} - {"NON_DIEGETIC"})

    def test_bounded_core_extensions_and_v1_immutability(self):
        validator = (GAME / "scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd").read_text(encoding="utf-8")
        executor_v2 = (GAME / "scripts/unified_runtime/application/SequenceExecutorV2.gd").read_text(encoding="utf-8")
        executor_v1 = (GAME / "scripts/unified_runtime/execution/SequenceExecutor.gd").read_text(encoding="utf-8")
        for proof in [
            'resolution["a10_choice_id"], path + ".a10_choice_id", errors',
            '"local_resolution_requires_next_beat"',
            '"a10_choice_required_for_durable_resolution"',
            '_is_terminal_post_resolution_physical',
            'content.get("withdrawal_choice_ids") == []',
        ]:
            self.assertIn(proof, validator)
        for proof in [
            '_receive_terminal_physical_command',
            '_execution["scheduled_returns"] = []',
            '_complete_execution()',
        ]:
            self.assertIn(proof, executor_v2)
        self.assertIn(
            "AUTOMATIC_COMPLETION_APPLIED",
            (GAME / "scripts/unified_runtime/execution/SequenceExecutor.gd").read_text(encoding="utf-8"),
        )

    def test_protected_resources_are_blob_identical(self):
        for relative, expected in PROTECTED_HASHES.items():
            self.assertEqual(expected, hashlib.sha256((GAME / relative).read_bytes()).hexdigest())

    def test_smoke_locks_required_runtime_proofs(self):
        source = SMOKE.read_text(encoding="utf-8")
        for proof in [
            "choix local null/null valide et strictement sans durable",
            "choix guidé avance sans aucun appel A10",
            "V2 accepte RETURN vers PHYSICAL terminal et V1 le refuse",
            "ancien save N19 refusé par fingerprint",
            "frontière active-null incomplète est refusée fail-closed",
            "reload au RETURN ne rejoue pas A10 Marie",
            "reload au PHYSICAL reprend le seul outcome choisi",
            "branches ACTIVE BOUNDED DRIFT convergent chacune sans second A10",
            "handoff final contient Mathilde Sandra Marie puis la paire N22",
        ]:
            self.assertIn(proof, source)
        scene = (GAME / "tests/R8C_N20MarieEveningReturnSmokeTest.tscn").read_text(encoding="utf-8")
        self.assertIn("R8C_N20MarieEveningReturnSmokeDriver.gd", scene)


if __name__ == "__main__":
    unittest.main()
