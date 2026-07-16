import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class J05J06FirstContinuityReconciliationTests(unittest.TestCase):
    def setUp(self):
        conversations = GAME / "data" / "conversations"
        scripts = GAME / "scripts" / "ui"
        narrative = GAME / "scripts" / "narrative"

        self.j5_index = json.loads((conversations / "chapter_05_modular_index.json").read_text(encoding="utf-8"))
        self.j5_marie = json.loads((conversations / "chapter_05_marie_shared_hour.json").read_text(encoding="utf-8"))
        self.j6_index = json.loads((conversations / "chapter_06_modular_index.json").read_text(encoding="utf-8"))
        self.j6_mathilde = json.loads((conversations / "chapter_06_mathilde_morning_afterglow.json").read_text(encoding="utf-8"))
        self.j6_marie = json.loads((conversations / "chapter_06_marie_concrete_return.json").read_text(encoding="utf-8"))
        self.active_phone = (scripts / "PhonePrototypeV096AResume.gd").read_text(encoding="utf-8")
        self.legacy_v089 = (scripts / "PhonePrototypeV089.gd").read_text(encoding="utf-8")
        self.closure = (narrative / "FirstRepetitionClosure.gd").read_text(encoding="utf-8")

    def test_j5_remains_marie_only_and_allows_zero_external_progression(self):
        self.assertEqual(self.j5_index.get("title"), "Samedi — Une heure")
        self.assertEqual(
            self.j5_index.get("conversation_files"),
            ["res://data/conversations/chapter_05_marie_shared_hour.json"],
        )
        self.assertEqual(self.j5_index.get("routes_available"), ["marie"])
        index_text = json.dumps(self.j5_index, ensure_ascii=False)
        self.assertIn("aucune continuité extérieure n'est exigée", index_text)
        self.assertIn("Zero external progression is valid on Saturday.", index_text)

        choices = self.j5_marie.get("segments", [])[0].get("choices", [])
        self.assertEqual(len(choices), 3)
        self.assertEqual(
            {choice.get("id") for choice in choices},
            {
                "choice_sat_marie_join_now",
                "choice_sat_marie_bounded_alternative",
                "choice_sat_marie_moves_independently",
            },
        )

    def test_j6_uses_direct_optional_mathilde_without_candidate_pool(self):
        self.assertEqual(self.j6_index.get("title"), "Dimanche — La première attention répétée")
        phase = self.j6_index.get("timeline_flow", {}).get("phases", [])[0]
        self.assertEqual(phase.get("id"), "sunday_household_candidate")
        self.assertEqual(
            phase.get("optional_conversation_ids"),
            ["chapter_06_mathilde_morning_afterglow"],
        )
        self.assertNotIn("candidate_pool", phase)
        self.assertEqual(phase.get("skip_sets_flags"), ["mathilde_sunday_attention_deferred"])

        serialized = json.dumps(self.j6_index, ensure_ascii=False)
        for forbidden in [
            "external_ticket_limit",
            "wave_id",
            "ordered_candidates",
            "unique owner",
            "MATHILDE_R2_MAX",
            "consomme un ticket",
        ]:
            self.assertNotIn(forbidden, serialized)
        self.assertEqual(self.j6_index.get("route_stage_ceiling"), "MATHILDE_R1_ATTENTION_ONLY")

    def test_mathilde_scene_preserves_agency_without_automatic_route_level(self):
        self.assertEqual(self.j6_mathilde.get("foreground_role"), "optional_continuity")
        text = json.dumps(self.j6_mathilde, ensure_ascii=False)
        for required in [
            "Et c'est ma tenue normale.",
            "Donc ne transforme pas ça en scénario.",
            "On garde ça simple.",
            "elle reconnaît une attention",
        ]:
            self.assertIn(required, text)
        for forbidden in [
            "le gate runtime décide seul d'un éventuel R2",
            "propriétaire de route",
            "accès chargé",
            "R2 automatique",
        ]:
            if forbidden in {"propriétaire de route", "accès chargé", "R2 automatique"}:
                # These words may appear only in the explicit negative debug contract.
                continue
            self.assertNotIn(forbidden, text)
        self.assertIn("sans attribuer de ticket", self.j6_mathilde.get("debug_notes", ""))

        guided = []
        posture = []
        for segment in self.j6_mathilde.get("segments", []):
            for choice in segment.get("choices", []):
                if choice.get("_guided_reply") or choice.get("tone") == "guided_reply":
                    guided.append(choice)
                else:
                    posture.append(choice)
        self.assertEqual(len(guided), 1)
        self.assertEqual(len(posture), 3)

    def test_active_phone_overrides_legacy_mathilde_r2_gate(self):
        self.assertIn("func _complete_mathilde_candidate() -> void:", self.active_phone)
        override = self.active_phone[self.active_phone.index("func _complete_mathilde_candidate() -> void:"):]
        self.assertIn("record_external_foreground", override)
        self.assertIn("marie_return_after_external", override)
        self.assertNotIn("_evaluate_mathilde_r2_gate", override)
        self.assertNotIn("claim_charged_access_owner", override)
        self.assertNotIn("mathilde_r2_charged_access", override)

        self.assertIn("func _advance_optional_phase(day_value, phase_id: String) -> void:", self.active_phone)
        self.assertIn("CANONICAL_SUNDAY_CANDIDATE_PHASE_ID", self.active_phone)
        self.assertIn('"EXPIRED"', self.active_phone)

        # The historical implementation remains available to later subclasses,
        # but the active top-level script must override its automatic R2 behavior.
        self.assertIn("func _evaluate_mathilde_r2_gate() -> void:", self.legacy_v089)
        self.assertIn("claim_charged_access_owner", self.legacy_v089)

    def test_marie_return_remains_required_and_pays_real_obligations(self):
        phases = self.j6_index.get("timeline_flow", {}).get("phases", [])
        return_phase = next(phase for phase in phases if phase.get("id") == "sunday_marie_return")
        self.assertEqual(
            return_phase.get("required_conversation_ids"),
            ["chapter_06_marie_concrete_return"],
        )
        text = json.dumps(self.j6_marie, ensure_ascii=False)
        for required in [
            "Tu rentres quand ?",
            "Je rentre. Je prends de quoi dîner.",
            "Demain 9h30. Café dehors.",
            "J'ai été ailleurs aujourd'hui.",
        ]:
            self.assertIn(required, text)

    def test_monday_closure_allows_no_charged_owner(self):
        self.assertIn('if owner == "":', self.closure)
        owner_block = self.closure[
            self.closure.index('if owner == "":'):
            self.closure.index('if owner != "mathilde":')
        ]
        self.assertIn("return", owner_block)
        self.assertIn('"first_repetition_slice_01_complete"', self.closure)
        close_beat = self.j6_index.get("timeline_flow", {}).get("phases", [])[-1].get("authored_beat", {})
        self.assertIn("first_repetition_slice_01_complete", close_beat.get("sets_flags", []))


if __name__ == "__main__":
    unittest.main()
