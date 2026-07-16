import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class OpeningJ3J4ReconciliationTests(unittest.TestCase):
    def setUp(self):
        conversations = GAME / "data" / "conversations"
        visuals = GAME / "data" / "visual_content"

        self.j3_index = json.loads((conversations / "chapter_03_modular_index.json").read_text(encoding="utf-8"))
        self.j3_marie = json.loads((conversations / "chapter_03_marie_evening_return.json").read_text(encoding="utf-8"))
        self.j3_visuals = json.loads((visuals / "chapter_03_proofs.json").read_text(encoding="utf-8"))

        self.j4_index = json.loads((conversations / "chapter_04_modular_index.json").read_text(encoding="utf-8"))
        self.j4_pauline = json.loads((conversations / "chapter_04_pauline_public_photo_relay.json").read_text(encoding="utf-8"))
        self.j4_nico = json.loads((conversations / "chapter_04_nico_saved_seat_followup.json").read_text(encoding="utf-8"))
        self.j4_visuals = json.loads((visuals / "chapter_04_opening_proofs.json").read_text(encoding="utf-8"))

    def test_j3_active_index_removes_event_and_exclusive_topology(self):
        self.assertEqual(self.j3_index.get("title"), "Jeudi — Les vies ailleurs")
        self.assertEqual(
            self.j3_index.get("conversation_files"),
            [
                "res://data/conversations/chapter_03_raphaelle_blue_folder.json",
                "res://data/conversations/chapter_03_sandra_continuity.json",
                "res://data/conversations/chapter_03_marie_evening_return.json",
            ],
        )
        active = json.dumps({
            "default_order": self.j3_index.get("default_order", []),
            "conversation_files": self.j3_index.get("conversation_files", []),
            "moment_flow": self.j3_index.get("moment_flow", []),
            "timeline_flow": self.j3_index.get("timeline_flow", {}),
            "availability": self.j3_index.get("conversation_availability", {}),
        }, ensure_ascii=False)
        for forbidden in [
            "chapter_03_marie_event_offer",
            "chapter_03_marie_event_joined",
            "chapter_03_mathilde_home_charger",
            "chapter_03_raphaelle_late_review",
            "chapter_03_marie_event_return",
            "opening_topology",
            "work_promise",
            "selected_topology",
        ]:
            self.assertNotIn(forbidden, active)

        phases = [phase.get("id") for phase in self.j3_index.get("timeline_flow", {}).get("phases", [])]
        self.assertEqual(
            phases,
            [
                "thursday_raphaelle_work",
                "thursday_sandra_optional",
                "thursday_marie_evening_return",
                "thursday_shared_evening",
            ],
        )
        self.assertEqual(self.j3_index.get("route_stage_ceiling"), "R1")

    def test_j3_marie_returns_to_an_ordinary_household(self):
        text = json.dumps(self.j3_marie, ensure_ascii=False)
        for required in [
            "Tu rentres vers quelle heure ?",
            "Mathilde a retrouvé son chargeur. Enfin un chargeur.",
            "J'ai laissé une soupe au frigo.",
            "sans déplacer ça à demain",
            "Je rentre à 19 h.",
            "je rentre à 19 h 30",
            "Commencez sans moi",
        ]:
            self.assertIn(required, text)
        for forbidden in ["vernissage", "La Verrière ouvre", "opening_topology", "route_lock", "vocal"]:
            self.assertNotIn(forbidden, text)

        guided = []
        posture = []
        for segment in self.j3_marie.get("segments", []):
            for choice in segment.get("choices", []):
                if choice.get("_guided_reply") or choice.get("tone") == "guided_reply":
                    guided.append(choice)
                else:
                    posture.append(choice)
        self.assertEqual(len(guided), 1)
        self.assertEqual(len(posture), 3)
        self.assertEqual(
            {flag for choice in posture for flag in choice.get("sets_flags", [])},
            {"marie_j3_return_active", "marie_j3_return_bounded", "marie_j3_return_drift"},
        )

    def test_j3_laverriere_visual_is_legacy_and_relocated(self):
        item = self.j3_visuals.get("items", [])[0]
        self.assertEqual(item.get("id"), "marie_laverriere_setup_01")
        self.assertIn("non référencé", item.get("context", ""))
        self.assertIn("relocated_to_j09", item.get("tags", []))
        self.assertIn("not_active_j3", item.get("tags", []))

    def test_j4_index_has_autonomous_social_origins(self):
        self.assertEqual(self.j4_index.get("title"), "Vendredi — Le réseau devient concret")
        index_text = json.dumps(self.j4_index, ensure_ascii=False)
        for required in [
            "récent dîner chez elle et Bastien",
            "Nico écrit avant son service à L'Annexe",
            "No J04 line depends on an event or topology from J03.",
        ]:
            self.assertIn(required, index_text)

        active = json.dumps({
            "conversation_files": self.j4_index.get("conversation_files", []),
            "moment_flow": self.j4_index.get("moment_flow", []),
            "timeline_flow": self.j4_index.get("timeline_flow", {}),
            "availability": self.j4_index.get("conversation_availability", {}),
        }, ensure_ascii=False)
        for forbidden in ["opening_topology", "work_promise", "chapter_03_marie_event_offer"]:
            self.assertNotIn(forbidden, active)

    def test_pauline_voice_and_photo_context_no_longer_depend_on_j3(self):
        text = json.dumps(self.j4_pauline, ensure_ascii=False)
        for required in [
            "les trois versions de dimanche",
            "Bastien insiste",
            "C'est pour ça que ça avance.",
            "Bastien mérite cette vérité.",
            "recent_group_photo_trace_exists",
        ]:
            self.assertIn(required, text)
        for forbidden in ["C'est la méthode La Verrière.", "vernissage", "laverriere_public_group_photo_trace_exists"]:
            self.assertNotIn(forbidden, text)

        guided = []
        posture = []
        for segment in self.j4_pauline.get("segments", []):
            for choice in segment.get("choices", []):
                if choice.get("_guided_reply") or choice.get("tone") == "guided_reply":
                    guided.append(choice)
                else:
                    posture.append(choice)
        self.assertEqual(len(guided), 1)
        self.assertEqual(len(posture), 3)

    def test_nico_voice_is_an_autonomous_friendship_opening(self):
        text = json.dumps(self.j4_nico, ensure_ascii=False)
        for required in [
            "Je bosse ce soir.",
            "La chaise qui ne penche pas est encore libre.",
            "Le peut-être annule la réservation.",
            "Marie m'a dit pour Mathilde.",
            "nico_knows_mathilde_stay",
        ]:
            self.assertIn(required, text)
        for forbidden in ["opening_topology", "work_promise", "rallonges", "vernissage", "vocal"]:
            self.assertNotIn(forbidden, text)

        guided = []
        posture = []
        for segment in self.j4_nico.get("segments", []):
            for choice in segment.get("choices", []):
                if choice.get("_guided_reply") or choice.get("tone") == "guided_reply":
                    guided.append(choice)
                else:
                    posture.append(choice)
        self.assertEqual(len(guided), 2)
        self.assertEqual(len(posture), 3)

    def test_j4_visual_keeps_id_but_uses_recent_dinner_metadata(self):
        item = self.j4_visuals.get("items", [])[0]
        self.assertEqual(item.get("id"), "laverriere_public_group_photo_set_01")
        self.assertIn("récent dîner chez elle et Bastien", item.get("context", ""))
        self.assertIn("legacy_id_retained", item.get("tags", []))
        self.assertIn("recent_group_dinner", item.get("tags", []))
        self.assertEqual(
            item.get("intended_audience"),
            ["photographed_group", "friends_group_chat", "approved_social_share"],
        )
        self.assertNotIn("nico", item.get("can_be_discovered_by", []))


if __name__ == "__main__":
    unittest.main()
