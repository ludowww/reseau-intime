import unittest

from tools.validate_game_data import res_path_exists


class DataPathBoundaryTests(unittest.TestCase):
    def test_canonical_data_path_is_allowed(self):
        self.assertTrue(res_path_exists("res://data/runtime/season_1/j01_runtime_map.json"))

    def test_noncanonical_fixture_cannot_escape_through_parent_segments(self):
        self.assertFalse(
            res_path_exists("res://data/../tests/fixtures/r8c_a3_minimal_scene_definitions.json")
        )


if __name__ == "__main__":
    unittest.main()
