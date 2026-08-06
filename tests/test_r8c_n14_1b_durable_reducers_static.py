from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FILES = [
    "game/scripts/narrative_state/ReducerRelation.gd",
    "game/scripts/narrative_state/ReducerConnaissance.gd",
    "game/scripts/narrative_state/ReducerTraceNarrative.gd",
    "game/scripts/narrative_state/ReducerPromesse.gd",
    "game/scripts/narrative_state/ReducerObligation.gd",
    "game/scripts/narrative_state/ReducerLivraisonMedia.gd",
    "game/scripts/narrative_state/ReducerResolutionSequence.gd",
    "game/tests/R8C_N14_1BDurableReducersSmokeDriver.gd",
    "game/tests/R8C_N14_1BDurableReducersSmokeTest.tscn",
]

def test_n14_1b_files_and_contracts():
    for rel in FILES:
        assert (ROOT / rel).is_file(), rel
    text = (ROOT / FILES[6]).read_text(encoding="utf-8")
    assert 'const ROOTS := ["facts", "knowledge", "traces", "promises", "obligations", "media_deliveries"]' in text
    assert 'const PROVENANCE :=' in text
    assert "preparer_faits" in (ROOT / FILES[0]).read_text(encoding="utf-8")
    for rel in FILES[1:7]:
        assert "statut" in (ROOT / rel).read_text(encoding="utf-8")

def test_n14_1b_scope_guards():
    for rel in FILES[:6]:
        text = (ROOT / rel).read_text(encoding="utf-8")
        assert "_etat" not in text
        assert "evenements" not in text
