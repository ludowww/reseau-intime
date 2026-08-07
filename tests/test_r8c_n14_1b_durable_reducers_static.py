import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
REDUCERS = (
    "game/scripts/narrative_state/ReducerRelation.gd",
    "game/scripts/narrative_state/ReducerConnaissance.gd",
    "game/scripts/narrative_state/ReducerTraceNarrative.gd",
    "game/scripts/narrative_state/ReducerPromesse.gd",
    "game/scripts/narrative_state/ReducerObligation.gd",
    "game/scripts/narrative_state/ReducerLivraisonMedia.gd",
)
ORCHESTRATOR = "game/scripts/narrative_state/ReducerResolutionSequence.gd"
SMOKE = "game/tests/R8C_N14_1BDurableReducersSmokeDriver.gd"
SCENE = "game/tests/R8C_N14_1BDurableReducersSmokeTest.tscn"
STATIC = "tests/test_r8c_n14_1b_durable_reducers_static.py"


class R8CN141BDurableReducersStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def test_n14_1b_expected_files_exist(self):
        for relative in (*REDUCERS, ORCHESTRATOR, SMOKE, SCENE, STATIC):
            self.assertTrue((ROOT / relative).is_file(), relative)

    def test_orchestrator_is_strict_v2_closed_and_sequential(self):
        source = self.read(ORCHESTRATOR)
        self.assertIn('const ROOTS := ["facts", "knowledge", "traces", "promises", "obligations", "media_deliveries"]', source)
        self.assertIn("_strict_v2_state", source)
        self.assertIn('typeof(state.get("format_version")) == TYPE_INT', source)
        self.assertIn('state["format_version"] == 2', source)
        self.assertIn("total_effects == 0", source)
        self.assertIn("event_keys.has(event_key)", source)
        self.assertIn("business_ids.has(business_id)", source)
        self.assertIn("_strict_semver", source)
        self.assertIn("moment_normalise_valide", source)
        self.assertNotIn("var steps", source)
        calls = (
            "Facts.preparer_faits",
            "Knowledge.preparer_mutations",
            "Traces.preparer_mutations",
            "Promises.preparer_mutations",
            "Obligations.preparer_mutations",
            "Media.preparer_mutations",
        )
        positions = [source.index(call) for call in calls]
        self.assertEqual(positions, sorted(positions))
        for left, right in zip(positions, positions[1:]):
            self.assertIn('if not result["ok"]', source[left:right])

    def test_reducers_close_shapes_identifiers_and_transitions(self):
        combined = "\n".join(self.read(path) for path in REDUCERS)
        for token in (
            "event_key",
            "_champs_exacts",
            "IDEMPOTENT",
            "APPLIQUE",
            "REJETE",
            "CREATE",
            "GRANT_ACCESS",
            "REVOKE_ACCESS",
            "WITHDRAW",
            "PAY",
            "FAIL",
            "CREATE_DUE",
            "CREATE_PAID",
            "CREATE_FAILED",
            "CREATE_DIEGETIC",
        ):
            self.assertIn(token, combined)
        relation = self.read(REDUCERS[0])
        self.assertIn("_champs_autorises(fact, FACT_FIELDS)", relation)
        media = self.read(REDUCERS[5])
        self.assertIn('const GALLERY_STATUSES := ["HIDDEN", "AVAILABLE"]', media)
        self.assertIn('record["gallery_status"] == "AVAILABLE" and item["gallery_status"] == "HIDDEN"', media)
        self.assertIn("_ids(item[\"fictional_audience_ids\"], false)", media)

    def test_no_publication_dynamic_dispatch_or_forbidden_dependencies(self):
        production = "\n".join(self.read(path) for path in (*REDUCERS, ORCHESTRATOR))
        for forbidden in (
            "._etat",
            '["evenements"]',
            "resolve_scene",
            "NarrativeOrchestrationFacade",
            "MinimalSceneEngine",
            "FileAccess",
            "user://",
            "PhotoViewer",
            "res://ui/",
            "legacy",
            "score",
            "Callable",
            ".call(",
            "signal ",
        ):
            self.assertNotIn(forbidden.lower(), production.lower())
        for reducer in REDUCERS:
            self.assertNotIn("A5NarrativeStateCodec", self.read(reducer))
        orchestrator = self.read(ORCHESTRATOR)
        self.assertIn("A5NarrativeStateCodec.gd", orchestrator)
        self.assertNotIn(".new()", orchestrator)

    def test_smoke_executes_full_positive_and_negative_matrix(self):
        smoke = self.read(SMOKE)
        required_labels = (
            "minimal relation fact created",
            "complete central fact created",
            "knowledge created with ordered holders",
            "trace access granted in requested order",
            "trace access revoke limited to requested ids",
            "trace withdrawn",
            "promise created then paid",
            "promise created then failed separately",
            "obligation created then paid",
            "CREATE_DUE then PAY identical replay remains idempotent",
            "obligation created then failed separately",
            "CREATE_DUE then FAIL identical replay remains idempotent",
            "CREATE_PAID creates obligation from fresh state",
            "CREATE_PAID record is terminal at provenance moment",
            "CREATE_PAID identical replay idempotent",
            "CREATE_PAID replay different moment rejected",
            "CREATE_PAID to CREATE_FAILED status change rejected",
            "CREATE_PAID divergent debtor rejected",
            "CREATE_PAID divergent beneficiaries rejected",
            "CREATE_PAID divergent kind rejected",
            "PAY on CREATE_PAID obligation rejected",
            "PAY on CREATE_PAID obligation rejected with different provenance",
            "CREATE_FAILED creates obligation from fresh state",
            "CREATE_FAILED record is terminal at provenance moment",
            "CREATE_FAILED identical replay idempotent",
            "FAIL on CREATE_FAILED obligation rejected",
            "CREATE_DUE and PAY same obligation rejected as duplicate business identifier",
            "obligation paid before due rejected",
            "obligation failed before due rejected",
            "media created with empty audience",
            "media gallery available granted",
            "v1 source rejected by reducer orchestrator",
            "empty payload rejected",
            "duplicate event_key across categories rejected",
            "duplicate business identifier rejected",
            "unknown gallery status rejected",
            "last reducer failure leaves source intact",
        )
        for label in required_labels:
            self.assertIn(label, smoke)
        self.assertIn("R8C_N14_1B_DURABLE_REDUCERS: OK (%d controls)", smoke)
        self.assertIn("get_tree().quit(0)", smoke)
        self.assertIn("get_tree().quit(1)", smoke)

    def test_unittest_collection_contract(self):
        source = self.read(STATIC)
        self.assertIn("class R8CN141BDurableReducersStaticTests(unittest.TestCase):", source)
        self.assertFalse(any(line.strip().startswith("import pytest") for line in source.splitlines()))
        self.assertGreaterEqual(source.count("    def test_"), 6)


if __name__ == "__main__":
    unittest.main()
