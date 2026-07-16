import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class SandraJ1SelectedImageTests(unittest.TestCase):
    def setUp(self):
        self.conversation_path = GAME / "data" / "conversations" / "chapter_01_sandra_trace.json"
        self.index_path = GAME / "data" / "conversations" / "chapter_01_modular_index.json"
        self.proofs_path = GAME / "data" / "visual_content" / "chapter_01_proofs.json"

        self.conversation = json.loads(self.conversation_path.read_text(encoding="utf-8"))
        self.index = json.loads(self.index_path.read_text(encoding="utf-8"))
        self.proofs = json.loads(self.proofs_path.read_text(encoding="utf-8"))

    def test_sandra_j1_preserves_runtime_shape_and_single_posture_node(self):
        self.assertEqual(self.conversation.get("id"), "chapter_01_sandra_trace")
        self.assertEqual(self.conversation.get("communication_mode"), "REMOTE_ASYNC")
        self.assertEqual(len(self.conversation.get("segments", [])), 5)

        guided = []
        posture = []
        for segment in self.conversation.get("segments", []):
            for choice in segment.get("choices", []):
                if choice.get("_guided_reply") or choice.get("tone") == "guided_reply":
                    guided.append(choice)
                else:
                    posture.append(choice)

        self.assertEqual(len(guided), 4)
        self.assertEqual(len(posture), 3)
        self.assertEqual(
            {choice.get("id") for choice in posture},
            {
                "choice_j1_sandra_safe_warmth",
                "choice_j1_sandra_precise_observation",
                "choice_j1_sandra_cautious",
            },
        )
        self.assertIn(
            "j1_sandra_trace_complete",
            self.conversation["segments"][-1]["choices"][0].get("sets_flags", []),
        )

    def test_sandra_j1_centers_selected_representation_not_blur_poetry(self):
        text = json.dumps(self.conversation, ensure_ascii=False)

        for required in [
            "Je l'avais revue après, puis gardée dans un dossier à part.",
            "Et j'ai recadré un peu avant de te l'envoyer.",
            "Tu as choisi celle où tu souriais.",
            "Mais je n'ai pas choisi au hasard non plus.",
            "J'ai déjà passé trop de temps à choisir une photo",
            "je n'ai pas choisi celle-là au hasard",
        ]:
            self.assertIn(required, text)

        for legacy in [
            "Juste ratée.",
            "moi floue sur le bord",
            "photo floue comme si elle allait devenir nette",
            "Elle ne deviendra pas nette",
            "c'est peut-être pour ça que je l'aime bien",
        ]:
            self.assertNotIn(legacy, text)

        self.assertEqual(text.count("Haha."), 1)
        self.assertEqual(text.count("🙂"), 1)

    def test_player_lines_remain_choices_and_sandra_closes_the_window(self):
        offenders = []
        for segment in self.conversation.get("segments", []):
            for message in segment.get("messages", []):
                if str(message.get("sender", "")).lower() in {"ludo", "player", "joueur"}:
                    offenders.append(message.get("id"))
            for choice in segment.get("choices", []):
                self.assertTrue(str(choice.get("text", "")).strip())
                for message in choice.get("next_messages", []):
                    if str(message.get("sender", "")).lower() in {"ludo", "player", "joueur"}:
                        offenders.append(message.get("id"))

        self.assertEqual(offenders, [])
        self.assertEqual(
            self.conversation["segments"][-1]["choices"][0]["next_messages"][-1]["text"],
            "Bonne nuit, Player 🙂",
        )
        self.assertIn("aucune activation de route", self.conversation.get("debug_notes", "").lower())

    def test_day1_index_and_visual_metadata_match_the_reconciled_scene(self):
        index_text = json.dumps(self.index, ensure_ascii=False)
        self.assertIn("revue, gardée et recadrée", index_text)
        self.assertNotIn("ancienne photo floue", index_text)
        self.assertIn(
            "chapter_01_sandra_trace",
            self.index.get("default_order", []),
        )

        items = {item.get("id"): item for item in self.proofs.get("items", [])}
        image = items["j1_sandra_lunch_memory_soft"]
        self.assertIn("choisi et recadré", image.get("context", ""))
        self.assertIn("pas le flou", image.get("context", ""))
        self.assertEqual(image.get("reviewed_by"), ["sandra"])
        self.assertEqual(image.get("intended_audience"), ["player"])
        self.assertIn("Aucun transfert", image.get("forwarding_rule", ""))
        self.assertIn("selected_crop", image.get("tags", []))
        self.assertNotIn("blurred_edge", image.get("tags", []))


if __name__ == "__main__":
    unittest.main()
