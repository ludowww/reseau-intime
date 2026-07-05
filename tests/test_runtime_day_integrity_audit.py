import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"
LOADER_PATH = GAME / "scripts" / "core" / "DataLoader.gd"
CONV_DIR = GAME / "data" / "conversations"
VISUAL_DIR = GAME / "data" / "visual_content"


class RuntimeDayIntegrityAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        loader = LOADER_PATH.read_text(encoding="utf-8")
        cls.chapter_index_files = re.findall(r'res://data/conversations/(chapter_\d+_index\.json)', loader)
        cls.visual_bundle_files = re.findall(r'res://data/visual_content/([\w_]+\.json)', loader)
        cls.visual_catalog = {}
        cls.visual_catalog_by_bundle = {}
        for bundle in cls.visual_bundle_files:
            data = cls._load_json(VISUAL_DIR / bundle)
            cls.visual_catalog_by_bundle[bundle] = data
            for item in cls._bundle_items(data):
                item_id = item.get("id")
                if item_id:
                    cls.visual_catalog[item_id] = item

    @staticmethod
    def _load_json(path: Path):
        return json.loads(path.read_text(encoding="utf-8"))

    @staticmethod
    def _bundle_items(bundle: dict):
        for key in ("items", "proofs"):
            for item in bundle.get(key, []):
                if isinstance(item, dict):
                    yield item

    @staticmethod
    def _res_to_path(res_path: str) -> Path:
        if not res_path.startswith("res://"):
            raise AssertionError(f"Unsupported res path: {res_path}")
        return GAME / res_path.removeprefix("res://")

    @staticmethod
    def _extract_content_ids(node):
        found = []
        if isinstance(node, dict):
            for key, value in node.items():
                if key == "content_id" and isinstance(value, str):
                    found.append(value)
                else:
                    found.extend(RuntimeDayIntegrityAuditTests._extract_content_ids(value))
        elif isinstance(node, list):
            for item in node:
                found.extend(RuntimeDayIntegrityAuditTests._extract_content_ids(item))
        return found

    def test_loaded_chapter_indexes_have_consistent_ids_and_availability(self):
        for index_file in self.chapter_index_files:
            index = self._load_json(CONV_DIR / index_file)
            day = int(index.get("day", index.get("chapter", 0)))
            day_prefix = f"chapter_{day:02d}_"

            moment_ids = [cid for moment in index.get("moment_flow", []) for cid in moment.get("conversation_ids", [])]
            conversation_files = index.get("conversation_files", [])
            loaded_conversations = [self._load_json(self._res_to_path(path)) for path in conversation_files]
            loaded_ids = [str(convo.get("id", "")) for convo in loaded_conversations]

            with self.subTest(day=day, check="moment_flow vs loaded conversations"):
                if moment_ids:
                    self.assertEqual(
                        sorted(moment_ids),
                        sorted(loaded_ids),
                        f"J{day}: moment_flow ids doivent correspondre aux conversations chargées",
                    )

            availability = index.get("conversation_availability", {})
            availability_ids = set(availability.get("initial_conversation_ids", []))
            availability_ids.update(availability.get("locked_conversation_ids", []))
            availability_ids.update(availability.get("unlocks", {}).keys())
            availability_ids.update(
                unlock.get("after_conversation_completed")
                for unlock in availability.get("unlocks", {}).values()
                if isinstance(unlock, dict) and unlock.get("after_conversation_completed")
            )

            with self.subTest(day=day, check="availability references"):
                for required_id in availability_ids:
                    self.assertTrue(
                        str(required_id).startswith(day_prefix),
                        f"J{day}: référence hors jour détectée dans conversation_availability: {required_id}",
                    )
                    self.assertIn(
                        required_id,
                        loaded_ids,
                        f"J{day}: référence d'availability absente des conversations chargées: {required_id}",
                    )

            with self.subTest(day=day, check="loaded ids stay declared"):
                declared_ids = set(moment_ids) | availability_ids
                for loaded_id in loaded_ids:
                    self.assertTrue(
                        loaded_id.startswith(day_prefix),
                        f"J{day}: conversation chargée hors jour détectée: {loaded_id}",
                    )
                    self.assertIn(
                        loaded_id,
                        declared_ids,
                        f"J{day}: conversation chargée absente de moment_flow et conversation_availability: {loaded_id}",
                    )

            active_content_ids = sorted(set(self._extract_content_ids(loaded_conversations)))
            with self.subTest(day=day, check="visual content refs"):
                for content_id in active_content_ids:
                    self.assertIn(
                        content_id,
                        self.visual_catalog,
                        f"J{day}: content_id actif absent des bundles visuels chargés: {content_id}",
                    )

    def test_placeholders_catalogue_keeps_essential_profiles_and_j2_j3_visuals(self):
        placeholders = self.visual_catalog_by_bundle.get("placeholders.json", {})
        items = {item.get("id"): item for item in self._bundle_items(placeholders) if item.get("id")}

        # Prevent partial replacement of the shared placeholder catalogue.
        self.assertGreaterEqual(len(items), 19, "placeholders.json semble partiel ou tronqué")

        for expected in [
            "profile_marie_placeholder",
            "profile_sandra_placeholder",
            "profile_mathilde_placeholder",
            "profile_raphaelle_placeholder",
            "profile_pauline_placeholder",
            "profile_nico_placeholder",
        ]:
            self.assertIn(expected, items, f"Placeholder manquant: {expected}")

        for expected in [
            "marie_j2_morning_soft_placeholder",
            "raphaelle_j2_work_badge_placeholder",
            "mathilde_j2_arrival_marie_placeholder",
            "mathilde_j2_couch_innocent_selfie_placeholder",
            "sandra_j2_lake_book_soft_placeholder",
            "marie_j3_kitchen_soft_placeholder",
            "sandra_j3_lake_page_placeholder",
            "mathilde_j3_ceiling_spider_placeholder",
            "mathilde_j3_room_recovered_placeholder",
        ]:
            self.assertIn(expected, items, f"Visuel essentiel manquant dans placeholders.json: {expected}")
            self.assertFalse(items[expected].get("is_proof", False), f"{expected} ne doit pas être un proof")
            self.assertLessEqual(int(items[expected].get("risk_level", 99)), 1, f"{expected} doit rester low-risk")

    def test_day5_day6_ids_match_moment_flow_explicitly(self):
        for index_file in ["chapter_05_index.json", "chapter_06_index.json"]:
            index = self._load_json(CONV_DIR / index_file)
            day = int(index.get("day", index.get("chapter", 0)))
            moment_ids = [cid for moment in index.get("moment_flow", []) for cid in moment.get("conversation_ids", [])]
            loaded_ids = [str(self._load_json(self._res_to_path(path)).get("id", "")) for path in index.get("conversation_files", [])]
            availability = index.get("conversation_availability", {})
            availability_ids = set(availability.get("initial_conversation_ids", []))
            availability_ids.update(availability.get("locked_conversation_ids", []))
            availability_ids.update(availability.get("unlocks", {}).keys())
            availability_ids.update(
                unlock.get("after_conversation_completed")
                for unlock in availability.get("unlocks", {}).values()
                if isinstance(unlock, dict) and unlock.get("after_conversation_completed")
            )

            self.assertEqual(
                sorted(moment_ids),
                sorted(loaded_ids),
                f"J{day}: mismatch explicite entre moment_flow et conversation_files",
            )
            self.assertEqual(
                set(moment_ids),
                availability_ids,
                f"J{day}: les ids actifs doivent aussi être déclarés dans conversation_availability",
            )
