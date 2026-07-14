import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
INDEX_PATH = GAME / "data/conversations/chapter_07_modular_index.json"
HELPER_PATH = GAME / "scripts/narrative/FirstRepetitionClosure.gd"
PHONE_PATH = GAME / "scripts/ui/PhonePrototypeV092.gd"
SCENE_PATH = GAME / "scenes/smartphone/PhonePrototype.tscn"


def load_index():
    return json.loads(INDEX_PATH.read_text(encoding="utf-8"))


def method_block(source: str, method_name: str, next_method_name: str | None = None) -> str:
    start = source.index(f"func {method_name}")
    if next_method_name is None:
        return source[start:]
    return source[start : source.index(f"func {next_method_name}", start)]


class V092FirstRepetitionWaveCloseStaticTests(unittest.TestCase):
    def test_active_phone_uses_v092_and_preserves_v090_inheritance(self):
        scene = SCENE_PATH.read_text(encoding="utf-8")
        phone = PHONE_PATH.read_text(encoding="utf-8")
        self.assertIn("PhonePrototypeV092.gd", scene)
        self.assertIn('extends "res://scripts/ui/PhonePrototypeV090.gd"', phone)
        self.assertIn('preload("res://scripts/narrative/FirstRepetitionClosure.gd")', phone)

    def test_monday_appends_exactly_one_internal_close_and_still_has_no_next_day(self):
        index = load_index()
        flow = index["timeline_flow"]
        self.assertIsNone(flow.get("next_day"))
        ids = [phase.get("id") for phase in flow.get("phases", [])]
        self.assertEqual(ids[-2:], ["monday_slice_close", "monday_first_repetition_wave_close"])
        self.assertEqual(ids.count("monday_first_repetition_wave_close"), 1)
        close = flow["phases"][-1]
        self.assertEqual(close.get("internal_closure"), "first_repetition")
        beat = close.get("authored_beat", {})
        self.assertEqual(beat.get("id"), "monday_first_repetition_wave_close_internal")
        for forbidden in ["title", "text", "sets_flags", "conversation_ids", "required_conversation_ids", "optional_conversation_ids"]:
            self.assertNotIn(forbidden, beat if forbidden in {"title", "text", "sets_flags"} else close)

    def test_closure_helper_is_pure_and_returns_reasons(self):
        source = HELPER_PATH.read_text(encoding="utf-8")
        self.assertIn("static func evaluate(flags: Array, ledger: Dictionary) -> Dictionary", source)
        self.assertIn('"closable": blocking_reasons.is_empty()', source)
        self.assertIn('"blocking_reasons": blocking_reasons', source)
        for forbidden in ["GameState", "TimelineState", "EffectApplier", "DataLoader", "get_tree()"]:
            self.assertNotIn(forbidden, source)

    def test_slice_and_marie_anchor_contract_is_explicit(self):
        source = HELPER_PATH.read_text(encoding="utf-8")
        for expected in [
            "first_repetition_slice_01_complete",
            "first_repetition_slice_02_complete",
            "marie_monday_return_active",
            "marie_monday_return_realized",
            "marie_monday_return_bounded",
            "marie_monday_bounded_time_paid",
            "marie_monday_return_honest_distance",
            "marie_monday_evening_separate",
        ]:
            self.assertIn(expected, source)

    def test_only_paid_failed_or_empty_obligations_can_close(self):
        source = HELPER_PATH.read_text(encoding="utf-8")
        self.assertIn('TERMINAL_OBLIGATION_STATUSES := ["PAID", "FAILED"]', source)
        for blocked in ["SCHEDULED", "DUE", "CARRIED"]:
            self.assertNotIn(f'"{blocked}"', source.split("TERMINAL_OBLIGATION_STATUSES", 1)[0])
        self.assertIn("non-terminal obligation", source)

    def test_candidate_lifecycle_accepts_only_terminal_states(self):
        source = HELPER_PATH.read_text(encoding="utf-8")
        self.assertIn('TERMINAL_SCENE_STATUSES := ["RESOLVED", "EXPIRED", "DEFERRED"]', source)
        self.assertIn("mathilde_morning_kitchen_afterglow_01", source)
        self.assertIn("sandra_end_of_shift_twenty_minutes_01", source)
        self.assertIn("non-terminal scene", source)

    def test_foreground_integrity_is_bounded_and_pair_checked(self):
        source = HELPER_PATH.read_text(encoding="utf-8")
        for expected in [
            "external foreground scene limit exceeded",
            "external foreground character limit exceeded",
            "external foreground arrays have different sizes",
            "duplicate external foreground scene",
            "duplicate external foreground character",
            "foreground scene/character mismatch",
        ]:
            self.assertIn(expected, source)
        self.assertIn('MATHILDE_SCENE_ID: "mathilde"', source)
        self.assertIn('SANDRA_SCENE_ID: "sandra"', source)

    def test_only_empty_or_mathilde_owner_is_supported_and_preserved(self):
        source = HELPER_PATH.read_text(encoding="utf-8")
        self.assertIn('if owner == ""', source)
        self.assertIn('if owner != "mathilde"', source)
        self.assertIn("charged access owner is not an external foreground", source)
        phone = PHONE_PATH.read_text(encoding="utf-8")
        self.assertNotIn("claim_charged_access_owner", phone)
        self.assertNotIn('charged_access_owner"', phone)

    def test_phone_close_is_silent_guarded_and_idempotent(self):
        source = PHONE_PATH.read_text(encoding="utf-8")
        block = method_block(source, "_activate_first_repetition_wave_close")
        self.assertIn("FirstRepetitionClosure.evaluate", block)
        self.assertIn("TimelineState.is_phase_complete", block)
        self.assertIn("First repetition wave closure blocked", block)
        self.assertIn("EffectApplier.apply_flags([WAVE_COMPLETE_FLAG])", block)
        self.assertIn("TimelineState.complete_phase", block)
        self.assertNotIn("record_day_log_entry", block)
        self.assertNotIn("_show_conversation_notification", block)

    def test_wave_flag_exists_only_in_v092_runtime_not_monday_json_effects(self):
        phone = PHONE_PATH.read_text(encoding="utf-8")
        index_text = INDEX_PATH.read_text(encoding="utf-8")
        self.assertIn('WAVE_COMPLETE_FLAG := "first_repetition_wave_complete"', phone)
        self.assertNotIn("first_repetition_wave_complete", index_text)

    def test_no_new_dialogue_asset_or_route_expansion_is_declared(self):
        index = load_index()
        self.assertEqual(
            index.get("conversation_files"),
            [
                "res://data/conversations/chapter_07_sandra_end_of_shift.json",
                "res://data/conversations/chapter_07_marie_monday_return.json",
            ],
        )
        self.assertEqual(index.get("proof_content_files"), [])
        self.assertEqual(index.get("routes_available"), ["marie", "sandra"])
        self.assertEqual(index.get("route_stage_ceiling"), "SANDRA_R1_MAX")

    def test_v092_smoke_is_isolated_a_to_i(self):
        driver = (GAME / "tests/V092RuntimeSmokeScenarioDriver.gd").read_text(encoding="utf-8")
        scene = (GAME / "tests/V092RuntimeSmokeTest.tscn").read_text(encoding="utf-8")
        shell = (ROOT / "tools/test_v092_runtime_smoke.sh").read_text(encoding="utf-8")
        self.assertIn("V092RuntimeSmokeScenarioDriver.gd", scene)
        for scenario in "ABCDEFGHI":
            self.assertIn(f'"{scenario}"', driver)
        self.assertIn("for scenario in A B C D E F G H I", shell)
        self.assertIn('"--scenario=${scenario}"', shell)


if __name__ == "__main__":
    unittest.main()
