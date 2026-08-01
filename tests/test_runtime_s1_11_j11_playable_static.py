import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RuntimeS111J11PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def load(self, relative: str):
        return json.loads(self.read(relative))

    def test_required_runtime_data_tests_and_runner_exist(self):
        for relative in [
            "game/data/runtime/season_1/j11_runtime_map.json",
            "game/scripts/runtime/season_1/J11RuntimeProvider.gd",
            "game/tests/RUNTIME_S1_11J11PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_11J11PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_11_j11_playable.sh",
        ]:
            self.assertTrue((ROOT / relative).exists(), relative)

    def test_six_signed_sources_are_playable_without_changing_gallery_contract(self):
        runtime_map = self.load("game/data/runtime/season_1/j11_runtime_map.json")
        self.assertEqual("PLAYABLE", runtime_map["implementation_status"])
        self.assertEqual(6, len(runtime_map["conversation_paths"]))
        self.assertEqual(
            {
                "S1_A3_J11_SCN_MATHILDE_PROXIMITY_STATE_01",
                "S1_A3_J11_SCN_MARIE_COUPLE_STATE_01",
            },
            {item["asset_id"] for item in runtime_map["gallery_presentations"]},
        )
        self.assertEqual(6, len(runtime_map["gallery_children"]))

    def test_signed_lines_and_primary_choices_are_data_first(self):
        expected = {
            "game/data/conversations/chapter_11_obligations.json": [
                "20 h 30 tient toujours ?",
                "Samedi 11 h tient de mon côté.",
                "choice_j11_p10_maintain",
                "choice_j11_p10_cancel",
                "choice_j11_p10_late",
            ],
            "game/data/conversations/chapter_11_sandra_image.json": [
                "Je n’en ai gardé qu’une.",
                "tu veux que je la voie seulement ou je peux la garder",
                "C’était le tri.",
            ],
            "game/data/conversations/chapter_11_mathilde_return.json": [
                "Je veux que tu regardes.",
                "Et si je dis stop, tu t’arrêtes.",
                "on n’a pas besoin de décider ce soir",
            ],
            "game/data/conversations/chapter_11_raphaelle_result.json": [
                "Pas pour le diagnostic technique cette fois.",
                "Si je te plais quand le travail est fini.",
                "Ce n’était pas le rôle.",
            ],
            "game/data/conversations/chapter_11_nico_guardrail.json": [
                "Je ne veux pas être ton conseiller neutre quand Marie ou Mathilde est dans la pièce.",
                "Mais on ne règle rien entre nous avec elles.",
                "Samedi, je suis juste Nico.",
            ],
            "game/data/conversations/chapter_11_marie_return.json": [
                "Pas d’utiliser le sexe pour effacer les jours précédents.",
                "Téléphone hors de la chambre.",
                "On mange. On dort. On verra demain.",
            ],
        }
        all_ids = set()
        for relative, tokens in expected.items():
            source = self.read(relative)
            data = self.load(relative)
            self.assertEqual(11, data["day"])
            for token in tokens:
                self.assertIn(token, source)
            for segment in data["segments"]:
                for message in segment.get("messages", []):
                    self.assertNotIn(message["id"], all_ids)
                    all_ids.add(message["id"])
                for choice in segment.get("choices", []):
                    self.assertNotIn(choice["id"], all_ids)
                    all_ids.add(choice["id"])
                    for message in choice.get("next_messages", []):
                        self.assertNotIn(message["id"], all_ids)
                        all_ids.add(message["id"])

    def test_provider_preserves_delivery_time_snapshot_and_exclusive_pivot(self):
        provider = self.read("game/scripts/runtime/season_1/J11RuntimeProvider.gd")
        for token in [
            "RUNTIME_UNREAD.incoming_batch_fully_presented",
            "CONTINUATION_SELECTOR.new().select",
            '"source_day": 11',
            "pending_choice_ids_by_thread",
            "presented_time_message_ids",
            "func snapshot()",
            "func restore_snapshot",
            "func _restored_phase_consistent",
            "func _marie_adult_eligible",
            "func _mathilde_physical_eligible",
            "func _raphaelle_kiss_eligible",
        ]:
            self.assertIn(token, provider)
        self.assertNotIn("candidate_pool", provider)
        self.assertNotIn("route_score", provider)

    def test_state_closes_j11_and_preserves_locked_consequence_gates(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        for token in [
            "func record_j11_choice",
            "func update_j11_sandra_image_access",
            "func complete_j11",
            '"j11_sandra_chosen_image_01"',
            '"j11_raphaelle_chosen_result_01"',
            '"aftercare_mathilde_j11"',
            '"aftercare_marie_j11"',
        ]:
            self.assertIn(token, state)

    def test_season_handoff_snapshot_and_content_end_move_to_j11(self):
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertIn("const SNAPSHOT_VERSION := 21", season)
        self.assertIn('active_day == "J10" and j10_provider.phase == "complete"', season)
        self.assertIn('active_day == "J11" and j11_provider.phase == "complete"', season)
        self.assertIn('active_day in ["J02", "J03", "J04", "J05", "J06", "J07", "J08", "J09", "J10", "J11", "J12", "J13", "J14", "J15", "J16", "J17", "J18", "J19", "J20", "J21"]', season)


if __name__ == "__main__":
    unittest.main()
