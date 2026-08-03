import copy
import subprocess
import sys
import unittest
from pathlib import Path

from tools.simulate_route_paths import lint_fixture, load_fixture

ROOT = Path(__file__).resolve().parents[1]


class CanonicalRouteSimulationTests(unittest.TestCase):
    def test_fixture_remains_explicitly_non_canonical(self):
        self.assertEqual(3, lint_fixture())

    def test_cli_reports_a_successful_fixture_lint(self):
        result = subprocess.run(
            [sys.executable, "tools/simulate_route_paths.py"],
            cwd=ROOT,
            check=True,
            capture_output=True,
            text=True,
            encoding="utf-8",
        )
        self.assertIn("FIXTURE LINT OK: 3 definitions", result.stdout)

    def test_fixture_boundary_violations_fail_closed(self):
        mutations = []

        def hidden_score(data):
            data["relationship_score"] = 1

        def invalid_definition_type(data):
            data["definitions"]["module_distance_raphaelle"] = None

        def canonical_marker(data):
            data["statut_contenu"] = "CANONIQUE"

        mutations.extend([
            hidden_score,
            invalid_definition_type,
            canonical_marker,
        ])
        source = load_fixture()
        for mutation in mutations:
            with self.subTest(mutation=mutation.__name__):
                fixture = copy.deepcopy(source)
                mutation(fixture)
                with self.assertRaises(ValueError):
                    lint_fixture(fixture)


if __name__ == "__main__":
    unittest.main()
