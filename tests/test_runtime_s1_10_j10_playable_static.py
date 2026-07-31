import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


class RuntimeS110J10PlayableStaticTests(unittest.TestCase):
    def read(self, relative: str) -> str:
        return (ROOT / relative).read_text(encoding="utf-8")

    def load(self, relative: str):
        return json.loads(self.read(relative))

    def test_required_runtime_files_exist(self):
        required = [
            "game/data/runtime/season_1/j10_runtime_map.json",
            "game/data/conversations/chapter_10_marie_obligations.json",
            "game/data/conversations/chapter_10_sandra_cafe.json",
            "game/data/conversations/chapter_10_mathilde_outfit.json",
            "game/data/conversations/chapter_10_raphaelle_process.json",
            "game/data/conversations/chapter_10_nico_observation.json",
            "game/scripts/runtime/season_1/J10PivotSelector.gd",
            "game/scripts/runtime/season_1/J10RuntimeProvider.gd",
            "game/tests/RUNTIME_S1_10J10PlayableSmokeDriver.gd",
            "game/tests/RUNTIME_S1_10J10PlayableSmokeTest.tscn",
            "tools/test_runtime_s1_10_j10_playable.sh",
        ]
        self.assertEqual([], [path for path in required if not (ROOT / path).exists()])

    def test_j09_hands_off_and_only_j10_is_content_end(self):
        j09 = self.load("game/data/runtime/season_1/j09_runtime_map.json")
        j10 = self.load("game/data/runtime/season_1/j10_runtime_map.json")
        self.assertEqual("day_handoff", j09["day_end"]["transition_mode"])
        self.assertFalse(j09["day_end"]["content_end"])
        self.assertEqual("Une ligne devient réelle", j09["day_end"]["next_day_presentation"]["title"])
        self.assertEqual("CONTENT_END", j10["day_end"]["transition_mode"])
        self.assertTrue(j10["day_end"]["content_end"])
        self.assertEqual("08:21", j10["initial_time"])
        self.assertEqual("Jeu.", j10["narrative_day_short"])

    def test_five_data_first_conversations_contain_signed_lines(self):
        paths = {
            "chapter_10_marie_obligations": "chapter_10_marie_obligations.json",
            "chapter_10_sandra_cafe": "chapter_10_sandra_cafe.json",
            "chapter_10_mathilde_outfit": "chapter_10_mathilde_outfit.json",
            "chapter_10_raphaelle_process": "chapter_10_raphaelle_process.json",
            "chapter_10_nico_observation": "chapter_10_nico_observation.json",
        }
        runtime = self.load("game/data/runtime/season_1/j10_runtime_map.json")
        self.assertEqual(
            {key: f"res://data/conversations/{filename}" for key, filename in paths.items()},
            runtime["conversation_paths"],
        )
        serialized = "\n".join(
            json.dumps(self.load(f"game/data/conversations/{filename}"), ensure_ascii=False)
            for filename in paths.values()
        )
        for line in [
            "20 h 30 tient toujours ?",
            "Je déplace. Je ne garde pas les deux soirs en attente.",
            "Le café près de la gare existe toujours, apparemment.",
            "Je t’envoie avant de lui demander.",
            "J’ai deux réparations visibles. J’ai besoin d’un regard qui n’a pas passé trois heures à les fabriquer.",
            "Si tu veux que je les garde, confirme avant midi.",
            "Je ne garde rien.",
            "Tu confirmes 18 h 20 ?",
            "Et je précise : je ne te demande pas de me montrer quoi que ce soit.",
            "Il y aura assez pour trois, mais ce n’est pas une convocation.",
        ]:
            self.assertIn(line, serialized)
        for forbidden in ["route_score", "candidate_pool", "wave_owner", "adult_access", "sexual"]:
            self.assertNotIn(forbidden, serialized.lower())
        self.assertNotIn('"sender": "player"', serialized)

        sandra = self.load("game/data/conversations/chapter_10_sandra_cafe.json")
        sandra_segments = {segment["id"]: segment for segment in sandra["segments"]}
        sandra_open = sandra_segments["j10_sandra_opening"]
        self.assertEqual(["12:21", "12:21", "12:22"], [message["time_label"] for message in sandra_open["messages"]])
        sandra_choices = {choice["id"]: choice for choice in sandra_open["choices"]}
        self.assertEqual(["12:23", "12:23"], [message["time_label"] for message in sandra_choices["choice_j10_sandra_accept_now"]["next_messages"]])
        for choice_id in ["choice_j10_sandra_saturday", "choice_j10_sandra_close"]:
            self.assertEqual(["12:23", "12:24", "12:24"], [message["time_label"] for message in sandra_choices[choice_id]["next_messages"]])
        self.assertEqual(["13:27", "13:27"], [message["time_label"] for message in sandra_segments["j10_sandra_after_cafe"]["messages"]])

        mathilde = self.load("game/data/conversations/chapter_10_mathilde_outfit.json")
        mathilde_open = {segment["id"]: segment for segment in mathilde["segments"]}["j10_mathilde_opening"]
        self.assertEqual(["17:14", "17:14", "17:15", "17:15", "17:15", "17:15"], [message["time_label"] for message in mathilde_open["messages"]])

        raphaelle = self.load("game/data/conversations/chapter_10_raphaelle_process.json")
        raphaelle_segments = {segment["id"]: segment for segment in raphaelle["segments"]}
        self.assertEqual(["17:38", "17:38", "17:39", "17:39"], [message["time_label"] for message in raphaelle_segments["j10_raphaelle_opening"]["messages"]])
        self.assertEqual(["17:41", "17:41"], [message["time_label"] for message in raphaelle_segments["j10_raphaelle_comparison"]["messages"]])
        comparison_choice = raphaelle_segments["j10_raphaelle_comparison"]["choices"][0]
        self.assertEqual(["17:42", "17:43"], [message["time_label"] for message in comparison_choice["next_messages"]])
        for choice in raphaelle_segments["j10_raphaelle_visit_choice"]["choices"]:
            self.assertEqual(["17:44", "17:44"], [message["time_label"] for message in choice["next_messages"]])
        self.assertEqual(["19:02", "19:02", "19:03"], [message["time_label"] for message in raphaelle_segments["j10_raphaelle_visit_after"]["messages"]])

        marie = self.load("game/data/conversations/chapter_10_marie_obligations.json")
        marie_segments = {segment["id"]: segment for segment in marie["segments"]}
        due = marie_segments["j10_marie_due_dinner"]
        self.assertTrue(all(message["time_label"] == "19:52" for message in due["messages"]))
        self.assertTrue(all(message["time_label"] == "19:52" for choice in due["choices"] for message in choice["next_messages"]))
        self.assertTrue(all(message["time_label"] == "19:48" for message in marie_segments["j10_marie_ordinary_meal"]["messages"]))

        self.assertEqual("12:21", runtime["to_sandra"]["to_time"])
        self.assertEqual("13:27", runtime["sandra_cafe_off_phone"]["to_time"])
        self.assertEqual("17:14", runtime["to_mathilde"]["to_time"])
        self.assertEqual("17:38", runtime["to_raphaelle"]["to_time"])
        self.assertEqual("17:41", runtime["raphaelle_comparison"]["to_time"])
        self.assertEqual("19:02", runtime["raphaelle_visit_off_phone"]["to_time"])
        self.assertEqual("18:15–18:38 — aide bornée hors téléphone. Aucun dialogue oral n’est montré.", runtime["raphaelle_visit_off_phone"]["text"])
        self.assertEqual("19:48", runtime["to_ordinary_evening"]["to_time"])
        self.assertEqual("19:52", runtime["to_due_dinner"]["to_time"])
        self.assertNotIn("to_evening", runtime)

    def test_p07_signed_amendment_and_existing_1812_exchange_are_separate(self):
        nico = self.load("game/data/conversations/chapter_10_nico_observation.json")
        segments = {segment["id"]: segment for segment in nico["segments"]}
        morning = segments["j10_nico_morning_confirmation"]
        self.assertEqual(
            ["choice_j10_nico_morning_confirm", "choice_j10_nico_morning_refuse"],
            [choice["id"] for choice in morning["choices"]],
        )
        self.assertEqual(
            ["choice_j10_nico_1812_keep", "choice_j10_nico_1812_cancel"],
            [choice["id"] for choice in segments["j10_nico_1812"]["choices"]],
        )
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        morning_block = state.split("func apply_j10_nico_morning_choice", 1)[1].split(
            "func expire_j10_nico_morning_confirmation", 1
        )[0]
        for token in [
            'p07["status"] = "ACTIVE"',
            'p07["activated_at"] = "J10 11:43"',
            'p07["accepted_at"] = "J10 11:43"',
            'p07["due_at"] = "J10 18:20"',
            'p07["status"] = "REFUSED"',
            'p07["due_at"] = ""',
        ]:
            self.assertIn(token, morning_block)
        expire = state.split("func expire_j10_nico_morning_confirmation", 1)[1].split(
            "func set_j10_pivot_selection", 1
        )[0]
        self.assertIn('p07["status"] = "EXPIRED"', expire)
        existing = state.split("func apply_j10_nico_1812_choice", 1)[1].split(
            "func pay_j10_nico_meeting", 1
        )[0]
        self.assertIn('str(p07.get("status", "")) != "ACTIVE"', existing)
        self.assertNotIn('"ACTIVE"', existing.split('"choice_j10_nico_1812_keep"', 1)[1].split(
            '"choice_j10_nico_1812_cancel"', 1
        )[0])

    def test_selector_is_pure_priority_ordered_and_strict(self):
        selector = self.read("game/scripts/runtime/season_1/J10PivotSelector.gd")
        self.assertIn('const AUTHORED_ORDER := ["SANDRA", "MATHILDE", "RAPHAELLE", "NICO"]', selector)
        p07_position = selector.index('"DUE_PROMISE_P07"')
        marie_position = selector.index('"MARIE_CONSEQUENCE_PRIORITY"')
        eligible_position = selector.index("var eligible")
        self.assertLess(p07_position, marie_position)
        self.assertLess(marie_position, eligible_position)
        for token in [
            '"RECONNECTION_OPEN"',
            '"RESPONDED"',
            '"THREAD_MAINTAINED"',
            '"LOOK_ACKNOWLEDGED"',
            '"NO_PROMISE"',
            '"fact_mathilde_stay_started"',
            '"PROFESSIONAL_ONLY"',
            '"RESPONSIBILITY_ACKNOWLEDGED"',
            '"TRANSFERRED_HONESTLY"',
            '"CONFIDENCE_ACTIVE"',
            '"PAID_SHORT"',
        ]:
            self.assertIn(token, selector)
        for mutation in ["state.", "promises[", "traces[", "knowledge[", "append(choice"]:
            self.assertNotIn(mutation, selector)
        self.assertIn('"ALL_ACCESS_CLOSED"', selector)
        self.assertIn('"NO_ELIGIBLE_PIVOT"', selector)

    def test_bounded_outcomes_and_only_authorized_relationship_changes(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        j10 = state.split("func begin_j10", 1)[1].split("func resolve_j07_morning_consequence", 1)[0]
        for outcome in [
            "CAFE_HELD_CALM_PRESENCE",
            "CAFE_HELD_MISSING_NAMED",
            "CAFE_HELD_FRIENDSHIP_BOUNDED",
            "CAFE_SATURDAY_CONDITIONAL",
            "CAFE_OPPORTUNITY_CLOSED",
            "OUTFIT_PRECISE_NON_APPROPRIATIVE",
            "OUTFIT_EFFECT_ACKNOWLEDGED_BOUNDED",
            "OUTFIT_PRACTICAL_WEATHER",
            "PROCESS_HELPED_VISIT_BOUNDED",
            "PROCESS_HELPED_REMOTE",
            "RESULT_ONLY",
            "PROFESSIONAL_BOUNDARY",
            "DIFFERENCE_ACKNOWLEDGED_NO_IMAGE",
            "NICO_OBSERVATION_REQUESTED",
            "COMPARISON_CLOSED",
            "THURSDAY_MEETING_CANCELLED",
            "DUE_DINNER_PAID",
            "DUE_DINNER_FAILED_LATE",
            "DUE_DINNER_CANCELLED",
            "ORDINARY_MEAL_JOINED",
            "LATE_RETURN_SEPARATE",
            "ABSENCE_ANNOUNCED",
        ]:
            self.assertIn(outcome, j10)
        sandra = j10.split("func apply_j10_sandra_outcome", 1)[1].split(
            "func establish_j10_mathilde_records", 1
        )[0]
        self.assertNotIn("sandra_state =", sandra)
        self.assertEqual(1, j10.count('mathilde_state = "INTENT_OPEN"'))
        self.assertEqual(1, j10.count('raphaelle_state = "CREATIVE_ACCESS"'))
        for forbidden in ["GUARDRAIL", "LIMITED_CONFIDANT", "HONEST_RIVAL"]:
            self.assertNotIn(forbidden, j10)

    def test_p09_p10_have_real_maintenance_amendment_and_closure(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        block = state.split("func apply_j10_marie_morning_choice", 1)[1].split(
            "func apply_j10_nico_morning_choice", 1
        )[0]
        self.assertIn('"choice_j10_marie_keep_thursday"', block)
        self.assertIn('"choice_j10_marie_amend_friday"', block)
        self.assertIn('"choice_j10_marie_cancel_morning"', block)
        self.assertIn('p09["status"] = "AMENDED"', block)
        self.assertIn('"status": "ACTIVE"', block)
        self.assertIn('"due_at": "J11 20:30"', block)
        self.assertIn('"amends": "marie_j09_dinner_j10_2030"', block)
        self.assertIn('p09["status"] = "CANCELLED"', block)
        self.assertIn('"choice_j10_marie_friday_confirm_guided"', block)
        j10 = state.split("func begin_j10", 1)[1].split("func resolve_j07_morning_consequence", 1)[0]
        self.assertIn('"created_at": "J10 12:24"', j10)
        evening = j10.split("func apply_j10_evening_choice", 1)[1].split("func complete_j10", 1)[0]
        self.assertEqual(2, evening.count('p09["paid_or_closed_at"] = "J10 19:52"'))

    def test_only_mathilde_creates_the_single_trace_fact_pair(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        j10 = state.split("func begin_j10", 1)[1].split("func resolve_j07_morning_consequence", 1)[0]
        self.assertEqual(1, j10.count('traces["j10_mathilde_outfit_choice_01"]'))
        self.assertEqual(1, j10.count('knowledge["fact_mathilde_chose_player_as_outfit_audience"]'))
        for token in [
            '"creator": "Mathilde"',
            '"owner": "Mathilde"',
            '"initial_audience": ["Mathilde", "Player"]',
            '"saving_rule": "IN_THREAD_ONLY"',
            '"transfer_rule": "FORBIDDEN"',
            '"current_state": "PRIVATE_ACTIVE"',
        ]:
            self.assertIn(token, j10)
        consistency = state.split("func _j10_records_consistent", 1)[1]
        self.assertIn("has_t10 != has_mathilde_fact", consistency)
        self.assertNotIn('traces["j10_', j10.split("func establish_j10_mathilde_records", 1)[0])

    def test_seven_visual_parents_zero_variants_and_conditional_serving(self):
        runtime = self.load("game/data/runtime/season_1/j10_runtime_map.json")
        assets = [item["asset_id"] for item in runtime["gallery_presentations"]]
        presentations = {item["asset_id"]: item for item in runtime["gallery_presentations"]}
        self.assertEqual(7, len(assets))
        self.assertEqual(7, len(set(assets)))
        self.assertEqual([], runtime["visual_variant_presentations"])
        self.assertEqual(
            {
                "S1_A3_J10_SCN_SANDRA_CAFE_HELD_01",
                "S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01",
                "S1_A3_J10_SCN_MATHILDE_SOCIAL_RESULT_01",
                "S1_A3_J10_DPH_RAPHAELLE_PROCESS_DETAIL_01",
                "S1_A3_J10_DPH_RAPHAELLE_PROCESS_COMPARISON_02",
                "S1_A3_J10_DPH_ANNEXE_MARIE_PUBLIC_01",
                "S1_A3_J10_DPH_ANNEXE_MATHILDE_PUBLIC_01",
            },
            set(assets),
        )
        self.assertEqual(
            {"creator": "Mathilde", "owner": "Mathilde", "initial_audience": ["Mathilde", "Player"], "saving_rule": "IN_THREAD_ONLY"},
            {key: presentations["S1_A3_J10_DPH_MATHILDE_OUTFIT_CHOICE_01"][key] for key in ["creator", "owner", "initial_audience", "saving_rule"]},
        )
        for asset_id in ["S1_A3_J10_DPH_RAPHAELLE_PROCESS_DETAIL_01", "S1_A3_J10_DPH_RAPHAELLE_PROCESS_COMPARISON_02"]:
            item = presentations[asset_id]
            self.assertEqual("Raphaëlle", item["creator"])
            self.assertEqual("Raphaëlle", item["owner"])
            self.assertEqual(["Raphaëlle", "Player"], item["initial_audience"])
            self.assertEqual("IN_THREAD_ONLY", item["saving_rule"])
            self.assertEqual("FORBIDDEN", item["transfer_rule"])
        for asset_id in ["S1_A3_J10_DPH_ANNEXE_MARIE_PUBLIC_01", "S1_A3_J10_DPH_ANNEXE_MATHILDE_PUBLIC_01"]:
            item = presentations[asset_id]
            self.assertEqual("Sophie", item["creator"])
            self.assertNotEqual("Nico", item["owner"])
            self.assertEqual(["publication ou groupe autorisé nommé"], item["initial_audience"])
            self.assertEqual("PUBLIC_SOURCE_RULES", item["saving_rule"])
            self.assertEqual("PUBLIC_SOURCE_RULES", item["transfer_rule"])
        provider = self.read("game/scripts/runtime/season_1/J10RuntimeProvider.gd")
        self.assertEqual(1, provider.count("_unlock_visual(SANDRA_CAFE_ASSET)"))
        self.assertIn('"raphaelle_comparison":', provider)
        self.assertNotIn("_unlock_visual", provider.split('elif choice_id in ["choice_j10_raphaelle_result"', 1)[1].split(
            'elif choice_id == "choice_j10_raphaelle_visit"', 1
        )[0])
        self.assertNotIn("resolved_visual_variant_by_asset[", provider)
        self.assertIn('var transition_key := "to_due_dinner" if _thursday_dinner_due() else "to_ordinary_evening"', provider)
        self.assertIn('_schedule_evening("mathilde_after")', provider)
        self.assertIn('_schedule_evening("nico_common")', provider)
        self.assertIn('_schedule_evening("day_close")', provider)
        after_external = provider.split("func _after_external_pivot", 1)[1].split("func _schedule_evening", 1)[0]
        self.assertIn('_schedule_evening("day_close")', after_external)
        self.assertGreaterEqual(provider.count("_after_external_pivot()"), 4)

    def test_snapshot_versions_handoff_and_legacy_j09_restore(self):
        state = self.read("game/scripts/runtime/season_1/Season1State.gd")
        season = self.read("game/scripts/runtime/season_1/Season1RuntimeProvider.gd")
        self.assertIn("const SNAPSHOT_VERSION := 9", state)
        self.assertIn("const SNAPSHOT_VERSION := 10", season)
        self.assertIn("[1, 2, 3, 4, 5, 6, 7, 8, SNAPSHOT_VERSION]", state)
        self.assertIn("[2, 3, 4, 5, 6, 7, 8, 9, SNAPSHOT_VERSION]", season)
        self.assertIn('version < 8 and str(value.get("current_day", "")) == "J10"', state)
        self.assertIn('version < 8 and str(value.get("active_day", "")) == "J09"', season)
        self.assertIn('version < 9 and str(value.get("active_day", "")) == "J10"', season)
        self.assertIn("_handoff_to_j10", season)
        self.assertIn('"J10":', season)
        self.assertEqual(1, season.count('state.restore_snapshot(value["state"])'))

    def test_runner_covers_all_resolutions_and_two_capture_orientations(self):
        runner = self.read("tools/test_runtime_s1_10_j10_playable.sh")
        driver = self.read("game/tests/RUNTIME_S1_10J10PlayableSmokeDriver.gd")
        for size in ["540x960", "720x800", "720x960", "720x1280", "1080x1920", "1080x2340", "1280x720"]:
            self.assertIn(size, runner)
        self.assertIn('"720x1280"', runner)
        self.assertIn('"1280x720"', runner)
        for label in [
            "j09_to_j10_handoff",
            "marie_morning_j10",
            "pivot_choice_j10",
            "gallery_j10",
            "content_end_j10",
        ]:
            self.assertIn(label, driver)
        self.assertIn("func _confirm_transition_monotonic", driver)
        self.assertNotIn("provider.confirm_transition()", driver.split("func _confirm_transition_monotonic", 1)[0])
        self.assertIn("target >= before", driver)


if __name__ == "__main__":
    unittest.main()
