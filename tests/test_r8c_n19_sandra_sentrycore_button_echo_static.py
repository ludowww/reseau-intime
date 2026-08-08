import hashlib
import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
SEQUENCE = GAME / "data/unified_runtime/sequences/sandra_sentrycore_button_echo_01.json"
PRESENTATION = GAME / "data/unified_runtime/presentation"
MESSAGES = PRESENTATION / "sandra_sentrycore_button_echo_01_messages.json"
PHYSICAL = PRESENTATION / "sandra_sentrycore_button_echo_01_physical.json"
MEDIA = PRESENTATION / "sandra_sentrycore_button_echo_01_media.json"
CATALOG = GAME / "tests/fixtures/unified_runtime/capability_catalog_n17_n22.json"
SOURCE = GAME / "data/conversations/chapter_03_sandra_continuity.json"
SMOKE = GAME / "tests/R8C_N19SandraSentryCoreButtonEchoSmokeDriver.gd"

MATHILDE_HASHES = {
    "data/unified_runtime/sequences/mathilde_returns_with_chosen_intent_01.json": "d17e6c18e341e52381435c32bc4ad99bd9736f1935c6fc54f08ebd63f9ea780b",
    "data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_messages.json": "aa66059551666bbbdf9604cede69ec2085f9aba3f9a7781093c03fb33cc54261",
    "data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_physical.json": "bb7bd963c7a3cdec2f650b27402ea22eb8681d5afa3ba1acec98ad722a7ae091",
    "data/unified_runtime/presentation/mathilde_returns_with_chosen_intent_01_media.json": "49120e5e9ddf2997d9871defef50c05ab998ca3da65338161fa400d6b3c6840a",
}


class R8CN19SandraSentryCoreButtonEchoStaticTests(unittest.TestCase):
    def load(self, path: Path):
        return json.loads(path.read_text(encoding="utf-8"))

    def test_identity_provenance_and_catalog_order(self):
        sequence = self.load(SEQUENCE)
        self.assertEqual("sandra_sentrycore_button_echo_01", sequence["sequence_id"])
        self.assertEqual("1.0.0", sequence["authored_version"])
        self.assertEqual("season_1", sequence["season_id"])
        self.assertEqual("movement_i", sequence["dramatic_movement_id"])
        self.assertEqual("ECHO", sequence["narrative_function"])
        self.assertEqual("CANON_APPROVED", sequence["canonical_status"])
        a6 = sequence["orchestration"]["a6_entry"]
        self.assertEqual("sandra_sentrycore_button_echo_01", a6["scene_definition_id"])
        self.assertEqual("sandra_sentrycore_button_echo_canonical", a6["variant_id"])
        self.assertEqual("MODULAIRE", a6["definition"]["nature"])
        self.assertEqual("ECHO", a6["definition"]["fonction_principale"])
        self.assertEqual("UNIQUE", a6["definition"]["politique_unicite"])
        provenance = json.dumps(sequence["author_provenance"], ensure_ascii=False)
        for source in [
            "game/data/conversations/chapter_03_sandra_continuity.json",
            "docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md",
            "docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md",
            "docs/canon/characters/SANDRA_CANON_FULL.md",
        ]:
            self.assertIn(source, provenance)
        catalog = self.load(CATALOG)
        self.assertEqual(
            [
                "mathilde_returns_with_chosen_intent_01",
                "sandra_sentrycore_button_echo_01",
                "marie_evening_return_01",
                "nico_saved_seat_01",
                "marie_household_report_01",
            ],
            [package["sequence_id"] for package in catalog["packages"]],
        )
        self.assertIn("capability_catalog_n17_n22.json", SMOKE.read_text(encoding="utf-8"))

    def test_exact_graph_bubbles_and_temporal_projection(self):
        sequence = self.load(SEQUENCE)
        self.assertEqual(["MESSAGE", "CHOICE", "RETURN"], [beat["type"] for beat in sequence["beats"]])
        message_beat, choice_beat, return_beat = sequence["beats"]
        source = self.load(SOURCE)
        source_segment = source["segments"][0]
        self.assertEqual(
            ["Poste du matin terminé.", "Le bouton est revenu.", "J'hésite entre miracle et menace."],
            [message["text"] for message in message_beat["content"]["messages"]],
        )
        self.assertEqual(
            [message["text"] for message in source_segment["messages"]],
            [message["text"] for message in message_beat["content"]["messages"]],
        )
        self.assertEqual("Journée sauvée alors.", choice_beat["content"]["choices"][0]["text"])
        messages = self.load(MESSAGES)
        self.assertEqual("N'allons pas jusque-là.", messages["entries"][0]["messages"][0]["text"])
        self.assertEqual("sandra_thread", message_beat["content"]["thread_id"])
        self.assertEqual("sandra_thread", choice_beat["content"]["thread_id"])
        self.assertEqual("NONE", return_beat["content"]["delay"]["mode"])
        self.assertEqual(
            [
                "2032-03-05T13:50:00+01:00",
                "2032-03-05T13:50:05+01:00",
                "2032-03-05T13:51:00+01:00",
                "2032-03-05T13:53:00+01:00",
            ],
            [message["diegetic_at"] for message in message_beat["content"]["messages"]]
            + [messages["entries"][0]["messages"][0]["diegetic_at"]],
        )

    def test_exact_single_durable_fact_and_no_other_effect(self):
        sequence = self.load(SEQUENCE)
        a6_resolution = sequence["orchestration"]["a6_entry"]["definition"]["resolutions"]["sandra_button_echo_resolution"]
        manifest = a6_resolution["durable_manifest"]
        self.assertEqual(["sandra_first_complicity_restored"], [item["event_key"] for item in manifest["facts"]])
        self.assertEqual(["sandra_first_complicity_restored"], [item["fact"]["fait_id"] for item in manifest["facts"]])
        for category in ["knowledge", "traces", "promises", "obligations", "media_deliveries"]:
            self.assertEqual([], manifest[category])
        resolution = sequence["resolutions"]["resolution_sandra_button_echo"]
        self.assertEqual(["sandra_first_complicity_restored"], resolution["fact_ids"])
        for field in ["knowledge_ids", "trace_ids", "promise_effects", "obligation_effects", "consequence_ids", "media_effects"]:
            self.assertEqual([], resolution[field])
        self.assertEqual({}, sequence["media"])
        self.assertEqual([], self.load(PHYSICAL)["entries"])
        self.assertEqual([], self.load(MEDIA)["entries"])

    def test_generic_empty_contract_guards_remain_closed(self):
        authored = (GAME / "scripts/unified_runtime/contracts/AuthoredSequenceValidator.gd").read_text(encoding="utf-8")
        physical_contract = (GAME / "scripts/unified_runtime/contracts/PhysicalPresentationContentV1.gd").read_text(encoding="utf-8")
        physical_resolver = (GAME / "scripts/unified_runtime/projection/PhysicalContentResolver.gd").read_text(encoding="utf-8")
        media_resolver = (GAME / "scripts/unified_runtime/projection/AuthoredMediaResolver.gd").read_text(encoding="utf-8")
        media_validation = authored.split("static func _validate_media(", 1)[1].split(
            "static func _validate_references(", 1
        )[0]
        self.assertNotIn("value.is_empty()", media_validation)
        self.assertIn('"root.media", "expected_dictionary"', media_validation)
        self.assertIn('"MEDIA_REVEAL"', authored)
        self.assertIn('"unknown_media"', authored)
        self.assertIn('path + ".media_effects", "unknown_media_', authored)
        self.assertNotIn('"expected_non_empty_array"', physical_contract)
        self.assertIn('beat["type"] == "PHYSICAL_BEAT"', physical_resolver)
        self.assertIn('_creation_failure("UNRESOLVED_CONTENT_REF")', physical_resolver)
        self.assertIn('typeof(value["entries"]) != TYPE_ARRAY', media_resolver)

    def test_mathilde_resources_are_blob_identical(self):
        for relative, expected in MATHILDE_HASHES.items():
            self.assertEqual(expected, hashlib.sha256((GAME / relative).read_bytes()).hexdigest())

    def test_production_smoke_locks_all_required_boundaries(self):
        source = SMOKE.read_text(encoding="utf-8")
        for proof in [
            "Mathilde active au démarrage et Sandra inactive",
            "aucun handoff Sandra avant le RETURN Mathilde de 09:06",
            "frontière handoff active-null incomplète est refusée fail-closed",
            "trois messages Sandra et choix unique conservés après reload",
            "commit A10 Sandra exactement une fois",
            "Galerie Mathilde reste ouvrable pendant l offre Sandra",
            "ancien save N18 refusé par fingerprint",
			"Sandra COMPLETE expose l opportunité Marie",
			"reload après Sandra reconstruit une seule offre Marie",
        ]:
            self.assertIn(proof, source)
        scene = (GAME / "tests/R8C_N19SandraSentryCoreButtonEchoSmokeTest.tscn").read_text(encoding="utf-8")
        self.assertIn("R8C_N19SandraSentryCoreButtonEchoSmokeDriver.gd", scene)


if __name__ == "__main__":
    unittest.main()
