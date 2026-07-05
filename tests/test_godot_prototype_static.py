import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GAME = ROOT / "game"


class GodotPrototypeStaticTests(unittest.TestCase):
    def test_minimal_godot_project_files_exist(self):
        required = [
            GAME / "project.godot",
            GAME / "scenes" / "Main.tscn",
            GAME / "scenes" / "smartphone" / "PhonePrototype.tscn",
            GAME / "scenes" / "smartphone" / "ConversationView.tscn",
            GAME / "scenes" / "smartphone" / "DebugPanel.tscn",
            GAME / "scripts" / "core" / "GameState.gd",
            GAME / "scripts" / "core" / "DataLoader.gd",
            GAME / "scripts" / "core" / "EffectApplier.gd",
            GAME / "scripts" / "core" / "DebugRouteProbe.gd",
            GAME / "scripts" / "ui" / "PhonePrototype.gd",
            GAME / "scripts" / "ui" / "ConversationView.gd",
            GAME / "scripts" / "ui" / "DebugPanel.gd",
            GAME / "assets" / "placeholders" / ".gitkeep",
        ]
        missing = [path.relative_to(ROOT).as_posix() for path in required if not path.exists()]
        self.assertEqual(missing, [])

    def test_project_boots_on_main_scene_and_registers_autoloads(self):
        project = (GAME / "project.godot").read_text(encoding="utf-8")
        self.assertIn('run/main_scene="res://scenes/Main.tscn"', project)
        self.assertIn('GameState="*res://scripts/core/GameState.gd"', project)
        self.assertIn('DataLoader="*res://scripts/core/DataLoader.gd"', project)
        self.assertIn('EffectApplier="*res://scripts/core/EffectApplier.gd"', project)
        self.assertIn('DebugRouteProbe="*res://scripts/core/DebugRouteProbe.gd"', project)

    def test_loader_references_required_vertical_slice_json(self):
        loader = (GAME / "scripts" / "core" / "DataLoader.gd").read_text(encoding="utf-8")
        for required in [
            "res://data/state/initial_state.json",
            "res://data/conversations/chapter_01_index.json",
            "res://data/conversations/chapter_02_index.json",
            "res://data/conversations/chapter_03_index.json",
            "res://data/conversations/chapter_04_index.json",
            "res://data/conversations/chapter_05_index.json",
            "res://data/conversations/chapter_07_index.json",
            "res://data/conversations/chapter_09_index.json",
            "res://data/visual_content/placeholders.json",
            "res://data/visual_content/chapter_01_proofs.json",
            "res://data/visual_content/chapter_04_proofs.json",
            "res://data/visual_content/chapter_05_proofs.json",
            "res://data/visual_content/chapter_06_proofs.json",
            "res://data/visual_content/chapter_07_proofs.json",
            "res://data/visual_content/chapter_09_proofs.json",
            "func _day_key(day_value) -> String:",
            "conversations_by_day.get(_day_key(day_value), [])",
            "if _day_key(index.get(\"day\", index.get(\"chapter\", \"\"))) == _day_key(day_value):",
            "labels.append(\"Jour %s\" % _day_key(index.get(\"day\", index.get(\"chapter\", \"?\"))))",
        ]:
            self.assertIn(required, loader)
        self.assertNotIn("res://data/visual_content/chapter_03_placeholders.json", loader)

    def test_day3_index_wires_four_private_threads_and_soft_visuals(self):
        index = json.loads((GAME / "data" / "conversations" / "chapter_03_index.json").read_text(encoding="utf-8"))
        self.assertEqual(index.get("title"), "Jour 3 — La maison respire / Mathilde appelle tard")
        self.assertEqual([moment.get("time_label") for moment in index.get("moment_flow", [])], ["08:26", "12:18", "20:17", "23:43"])
        self.assertEqual(
            [moment.get("conversation_ids") for moment in index.get("moment_flow", [])],
            [
                ["chapter_03_marie_morning"],
                ["chapter_03_sandra_midday"],
                ["chapter_03_marie_evening"],
                ["chapter_03_mathilde_late_night"],
            ],
        )
        self.assertEqual(
            index.get("conversation_files"),
            [
                "res://data/conversations/chapter_03_marie_morning.json",
                "res://data/conversations/chapter_03_sandra_midday.json",
                "res://data/conversations/chapter_03_marie_evening.json",
                "res://data/conversations/chapter_03_mathilde_late_night.json",
            ],
        )
        self.assertEqual(index.get("routes_available"), ["marie", "mathilde", "sandra"])
        self.assertNotIn("routes_locked_to_seed_only", index)
        availability = index.get("conversation_availability", {})
        self.assertEqual(availability.get("initial_conversation_ids"), ["chapter_03_marie_morning"])
        self.assertEqual(
            availability.get("locked_conversation_ids"),
            ["chapter_03_sandra_midday", "chapter_03_marie_evening", "chapter_03_mathilde_late_night"],
        )
        for convo_id, expected_after in {
            "chapter_03_sandra_midday": "chapter_03_marie_morning",
            "chapter_03_marie_evening": "chapter_03_sandra_midday",
            "chapter_03_mathilde_late_night": "chapter_03_marie_evening",
        }.items():
            self.assertEqual(availability.get("unlocks", {}).get(convo_id, {}).get("after_conversation_completed"), expected_after)
        self.assertNotIn("Mathilde", availability.get("unlocks", {}).get("chapter_03_marie_evening", {}).get("notification", {}).get("body", ""))
        self.assertNotIn("plafond", availability.get("unlocks", {}).get("chapter_03_marie_evening", {}).get("notification", {}).get("body", "").lower())
        placeholders = json.loads((GAME / "data" / "visual_content" / "placeholders.json").read_text(encoding="utf-8"))
        visual_items = {item["id"]: item for item in placeholders.get("items", []) if isinstance(item, dict)}
        for expected in [
            "profile_marie_placeholder",
            "profile_sandra_placeholder",
            "profile_mathilde_placeholder",
            "profile_raphaelle_placeholder",
            "profile_pauline_placeholder",
            "profile_nico_placeholder",
            "marie_j2_morning_soft_placeholder",
            "mathilde_j2_arrival_marie_placeholder",
            "mathilde_j2_couch_innocent_selfie_placeholder",
            "sandra_j2_lake_book_soft_placeholder",
            "raphaelle_j2_work_badge_placeholder",
        ]:
            self.assertIn(expected, visual_items)
        for expected in [
            "marie_j3_kitchen_soft_placeholder",
            "sandra_j3_lake_page_placeholder",
            "mathilde_j3_ceiling_spider_placeholder",
            "mathilde_j3_room_recovered_placeholder",
        ]:
            self.assertIn(expected, visual_items)
            self.assertFalse(visual_items[expected].get("is_proof"))
            self.assertLessEqual(int(visual_items[expected].get("risk_level", 99)), 1)
        for convo_path in [
            GAME / "data" / "conversations" / "chapter_03_marie_morning.json",
            GAME / "data" / "conversations" / "chapter_03_sandra_midday.json",
            GAME / "data" / "conversations" / "chapter_03_marie_evening.json",
            GAME / "data" / "conversations" / "chapter_03_mathilde_late_night.json",
        ]:
            convo = json.loads(convo_path.read_text(encoding="utf-8"))
            for segment in convo.get("segments", []):
                for message in segment.get("messages", []):
                    self.assertNotEqual(message.get("sender"), "ludo")
                    self.assertNotIn(message.get("sender"), {"Player", "player", "joueur"})
                for choice in segment.get("choices", []):
                    for reply in choice.get("next_messages", []):
                        self.assertNotEqual(reply.get("sender"), "ludo")
                        self.assertNotIn(reply.get("sender"), {"Player", "player", "joueur"})
        active_tokens = json.dumps({
            "conversation_ids": [cid for moment in index.get("moment_flow", []) for cid in moment.get("conversation_ids", [])],
            "conversation_files": index.get("conversation_files", []),
        }, ensure_ascii=False)
        self.assertNotIn("Nico", active_tokens)
        self.assertNotIn("Pauline", active_tokens)
        self.assertNotIn("Raphaëlle", active_tokens)
        chapter03_text = "\n".join(
            (GAME / "data" / "conversations" / name).read_text(encoding="utf-8")
            for name in [
                "chapter_03_marie_morning.json",
                "chapter_03_sandra_midday.json",
                "chapter_03_marie_evening.json",
                "chapter_03_mathilde_late_night.json",
            ]
        )
        marie_evening_text = (GAME / "data" / "conversations" / "chapter_03_marie_evening.json").read_text(encoding="utf-8")
        mathilde_night_text = (GAME / "data" / "conversations" / "chapter_03_mathilde_late_night.json").read_text(encoding="utf-8")
        marie_evening = json.loads(marie_evening_text)
        mathilde_night = json.loads(mathilde_night_text)
        self.assertNotIn("Mathilde m’a écrit", marie_evening_text)
        self.assertNotIn("problème au plafond", marie_evening_text)
        self.assertIn("Je prépare le calme pour demain.", marie_evening_text)
        self.assertIn("Je préviens Marie si tu veux.", mathilde_night_text)
        self.assertFalse(any(
            str(message.get("content_id", "")).startswith("mathilde_j3_")
            for segment in marie_evening.get("segments", [])
            for message in segment.get("messages", [])
        ))
        self.assertEqual(
            [
                message.get("content_id")
                for segment in mathilde_night.get("segments", [])
                for message in segment.get("messages", [])
                if message.get("content_id") == "mathilde_j3_room_recovered_placeholder"
            ],
            ["mathilde_j3_room_recovered_placeholder"],
        )
        for required in ["araignée", "plafond", "chambre"]:
            self.assertIn(required, mathilde_night_text)
        for forbidden in [
            "canapé",
            "canape",
            "Tu sais très bien ce que cette photo fait",
            "mathilde.desire",
            "lie_score",
            "marie_attention_score",
            "sets_flags",
            "Raphaëlle",
            "raphaelle",
            "Pauline",
            "pauline",
            "Nico",
            "nico",
        ]:
            self.assertNotIn(forbidden, chapter03_text)

    def test_effect_applier_supports_dotted_global_passive_flags_and_unknowns(self):
        script = (GAME / "scripts" / "core" / "EffectApplier.gd").read_text(encoding="utf-8")
        for expected in [
            "apply_choice",
            "apply_effects",
            "apply_flags",
            "characters",
            "passive_signals",
            "global",
            "unknown_effects",
            "sets_flags",
        ]:
            self.assertIn(expected, script)

    def test_phone_layout_targets_1280_width_and_integer_day_labels(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        self.assertIn("_format_day_label", script)
        self.assertIn("int(day_value)", script)
        self.assertIn("Vector2(160, 0)", script)
        self.assertIn("Vector2(260, 0)", script)
        self.assertIn("Vector2(420, 680)", script)
        self.assertIn("SIZE_EXPAND_FILL", script)

    def test_phone_home_uses_dark_smartphone_shell_and_main_navigation(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        for expected in [
            "PHONE_BACKGROUND_COLOR",
            "PHONE_FRAME_COLOR",
            "_build_phone_shell",
            "_add_status_bar",
            "09:41",
            "Messages",
            "Debug",
            "Speed x1",
            "Reset",
            "debug_scroll.visible = false",
            "PanelContainer",
            "StyleBoxFlat",
        ]:
            self.assertIn(expected, script)

    def test_conversation_list_uses_grouped_mobile_cards_with_avatar_and_badge(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        for expected in [
            "conversation_cards",
            "_add_conversation_card",
            "_conversation_subtitle",
            "_conversation_status_text",
            "_conversation_has_activity_badge",
            "avatar_placeholder",
            "badge",
            "_card_style",
            "_avatar_initial",
        ]:
            self.assertIn(expected, script)
        self.assertNotIn("_render_conversation_buttons(day_value, _flatten", script)

    def test_conversation_list_is_contacts_only_not_moment_menu(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        self.assertIn("_collect_contact_conversations_for_day", script)
        self.assertIn("_moment_metadata_by_conversation_id", script)
        self.assertIn("_add_day_moment_hint", script)
        self.assertNotIn("func _add_moment_card", script)
        self.assertNotIn("_render_moment_conversations", script)
        self.assertNotIn("moment_label", script[script.index("func _render_conversations"):script.index("func _render_conversation_buttons")])

    def test_phone_has_pending_badges_and_simple_notifications(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        for expected in [
            "pending_conversation_ids",
            "notification_banner",
            "_unlock_conversations_after_completion",
            "_clear_pending_for_conversation",
            "_show_notification",
            "Nouveau message",
            "En attente",
            "pending",
            "Speed x1",
            "_debug_speed_label",
            "_cycle_debug_speed",
            "_set_debug_speed_index",
        ]:
            self.assertIn(expected, script)

    def test_authoring_helpers_include_choice_text_check_and_presence_diagnostics(self):
        choice_script = (ROOT / "tools" / "player_choice_text_check.py").read_text(encoding="utf-8")
        presence_script = (ROOT / "tools" / "player_presence_check.py").read_text(encoding="utf-8")
        self.assertIn("choice_issues", choice_script)
        self.assertIn("mais en français", choice_script)
        self.assertIn("player_choice_text_check.py", choice_script)
        self.assertIn("non_player_messages", presence_script)
        self.assertIn("player_message_ratio", presence_script)
        self.assertIn("longest_player_absence_streak", presence_script)

    def test_day1_time_gate_metadata_keeps_sandra_locked_until_marie_progress(self):
        index = json.loads((GAME / "data/conversations/chapter_01_index.json").read_text(encoding="utf-8"))
        gate = index.get("conversation_availability", {})
        self.assertEqual(gate.get("initial_conversation_ids"), ["chapter_01_marie"])
        self.assertIn("chapter_01_sandra", gate.get("locked_conversation_ids", []))
        sandra_unlock = gate.get("unlocks", {}).get("chapter_01_sandra", {})
        self.assertEqual(sandra_unlock.get("after_conversation_completed"), "chapter_01_marie")
        self.assertEqual(sandra_unlock.get("time_label"), "22:57")
        self.assertEqual(sandra_unlock.get("notification", {}).get("title"), "Sandra")
        self.assertIn("Mon téléphone vient de me ressortir ça.", sandra_unlock.get("notification", {}).get("body", ""))

    def test_phone_applies_day1_time_gates_and_clickable_conversation_notifications(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        for expected in [
            "unlocked_conversation_ids_by_day",
            "notification_target_conversation_id",
            "_available_conversation_ids_for_day",
            "_is_conversation_available",
            "_unlock_conversation",
            "_unlock_conversations_after_completion",
            "_show_conversation_notification",
            "_open_notification_target",
            "conversation_completed.connect(_on_conversation_completed)",
            "after_conversation_completed",
            "locked_conversation_ids",
            "initial_conversation_ids",
            "create_timer(4.0)",
        ]:
            self.assertIn(expected, script)
        self.assertIn("card.gui_input.connect", script)
        self.assertIn("notification_banner.gui_input.connect", script)

    def test_conversation_view_emits_completion_for_time_gated_unlocks(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        self.assertIn("signal conversation_completed(day_value, conversation_id: String)", script)
        self.assertIn("conversation_completed.emit", script)
        self.assertIn("_emit_conversation_completed_once", script)
        self.assertIn('"completion_emitted"', script)

    def test_conversation_view_wraps_choices_and_renders_ludo_reply(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        self.assertIn("choice_buttons", script)
        self.assertIn("AUTOWRAP_WORD_SMART", script)
        self.assertIn("disabled = true", script)
        self.assertIn("_append_ludo_reply", script)
        self.assertIn("_should_skip_repeated_choice_reply", script)
        self.assertIn("_choice_reply_text", script)
        self.assertIn("strip_edges()", script)
        self.assertIn("debug_speed_multiplier", script)
        self.assertIn("set_debug_speed_multiplier", script)
        self.assertNotIn("Choix appliqué :", script)
        self.assertIn("_format_message_text", script)
        self.assertIn("_render_chat_bubble", script)

    def test_conversation_view_distinguishes_guided_replies_from_narrative_choices(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        self.assertIn("_is_guided_reply", script)
        self.assertIn("choices.size() == 1", script)
        self.assertIn("Réponse", script)
        self.assertIn("_guided_reply", script)
        self.assertIn("Choix disponibles", script)
        self.assertIn("choice_area", script)

    def test_conversation_view_requires_click_for_single_guided_reply(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        guided_block = script[script.index("var is_guided_reply := choices.size() == 1"):script.index("func append_choice_result")]
        self.assertIn('choice["_guided_reply"] = true', guided_block)
        self.assertIn("Button.new()", guided_block)
        self.assertIn("button.pressed.connect", guided_block)
        self.assertIn("_select_choice(choice, button)", guided_block)
        self.assertNotIn("choice_selected.emit(choice)", guided_block)
        self.assertNotIn("append_choice_result(choice)", guided_block)
        self.assertNotIn("_select_choice(choice", guided_block.split("button.pressed.connect", 1)[0])

    def test_conversation_view_uses_wider_bubbles_and_time_metadata_outside_text(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        for expected in [
            "BUBBLE_MAX_WIDTH",
            "BUBBLE_MIN_WIDTH",
            "_bubble_text_width",
            "Vector2(BUBBLE_MAX_WIDTH",
            "time_label",
            "HORIZONTAL_ALIGNMENT_RIGHT",
        ]:
            self.assertIn(expected, script)
        format_block = script[script.index("func _format_message_text"):script.index("func _message_time_text")]
        self.assertNotIn('"[%s] %s"', format_block)
        self.assertNotIn("time_label", format_block)
        typing_block = script[script.index("func _show_typing_indicator"):script.index("func _animate_typing_indicator")]
        self.assertIn('typing_message.erase("time_label")', typing_block)

    def test_conversation_view_uses_mobile_chat_bubbles_and_header(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        for expected in [
            "_build_chat_shell",
            "_add_chat_header",
            "avatar_placeholder",
            "message_thread",
            "choice_area",
            "_is_ludo_sender",
            "ALIGNMENT_BEGIN",
            "ALIGNMENT_END",
            "StyleBoxFlat",
            "corner_radius_top_left",
            "Color(0.05, 0.06, 0.09)",
            "_add_placeholder_card",
        ]:
            self.assertIn(expected, script)

    def test_guided_replies_spec_is_present(self):
        spec = ROOT / "docs" / "27_GUIDED_REPLIES_IMPLEMENTATION_SPEC.md"
        self.assertTrue(spec.exists())
        text = spec.read_text(encoding="utf-8")
        self.assertIn("Si un segment contient exactement 1 choix", text)
        self.assertIn("Ludo : [texte du choix]", text)

    def test_day1_sandra_and_marie_have_guided_reply_segments(self):
        for relative in [
            "data/conversations/chapter_01_sandra.json",
            "data/conversations/chapter_01_marie.json",
        ]:
            data = json.loads((GAME / relative).read_text(encoding="utf-8"))
            segments = data.get("segments", [])
            self.assertGreaterEqual(len(segments), 2, relative)

            guided_choices = [
                choice
                for segment in segments
                for choice in segment.get("choices", [])
                if choice.get("tone") == "guided_reply"
            ]
            posture_choices = [
                choice
                for segment in segments
                for choice in segment.get("choices", [])
                if choice.get("tone") != "guided_reply"
            ]

            self.assertGreaterEqual(len(guided_choices), 1, relative)
            self.assertGreaterEqual(len(posture_choices), 2, relative)
            self.assertLessEqual(len(posture_choices), 3, relative)
            self.assertTrue(any(len(segment.get("messages", [])) >= 2 for segment in segments), relative)
            self.assertTrue(any(len(segment.get("messages", [])) == 0 for segment in segments), relative)

    def test_day1_player_lines_are_choices_not_auto_messages(self):
        for relative in [
            "data/conversations/chapter_01_sandra.json",
            "data/conversations/chapter_01_marie.json",
        ]:
            data = json.loads((GAME / relative).read_text(encoding="utf-8"))
            offenders = []

            def walk(value, path):
                if isinstance(value, dict):
                    sender = str(value.get("sender", "")).lower()
                    if sender in {"ludo", "player", "joueur"}:
                        offenders.append("%s:%s" % ("/".join(path), value.get("id", "?")))
                    for key, child in value.items():
                        walk(child, path + [key])
                elif isinstance(value, list):
                    for child in value:
                        walk(child, path)

            walk(data, [])
            self.assertEqual(offenders, [], relative)

    def test_day1_one_choice_produces_exactly_one_player_bubble(self):
        for relative in [
            "data/conversations/chapter_01_sandra.json",
            "data/conversations/chapter_01_marie.json",
        ]:
            data = json.loads((GAME / relative).read_text(encoding="utf-8"))
            offenders = []
            for segment in data.get("segments", []):
                for choice in segment.get("choices", []) + segment.get("priority_choices", []):
                    if str(choice.get("text", "")).strip() == "":
                        offenders.append("empty:%s" % choice.get("id", "?"))
                    extra_player_bubbles = [message for message in choice.get("next_messages", []) if str(message.get("sender", "")).lower() in {"ludo", "player", "joueur"}]
                    if extra_player_bubbles:
                        offenders.append("extra:%s" % choice.get("id", "?"))
            self.assertEqual(offenders, [], relative)

    def test_conversation_view_keeps_player_bubbles_post_choice_only(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        append_block = script[script.index("func _append_ludo_reply"):script.index("func _is_guided_reply")]
        self.assertIn('"sender": "ludo"', append_block)
        auto_block = script[script.index("func _auto_advance_segments_until_choice"):script.index("func _render_segment_messages_with_typing")]
        self.assertIn("_show_choices_for_segment(data", auto_block)
        self.assertNotIn("_append_ludo_reply", auto_block)

    def test_day1_progressive_content_keeps_only_marie_and_sandra_active(self):
        index = json.loads((GAME / "data/conversations/chapter_01_index.json").read_text(encoding="utf-8"))
        self.assertEqual(index.get("default_order"), ["chapter_01_marie", "chapter_01_sandra"])
        self.assertEqual(index.get("conversation_files"), [
            "res://data/conversations/chapter_01_marie.json",
            "res://data/conversations/chapter_01_sandra.json",
        ])
        self.assertEqual(index.get("proof_content_files"), ["res://data/visual_content/chapter_01_proofs.json"])
        proofs = json.loads((GAME / "data/visual_content/chapter_01_proofs.json").read_text(encoding="utf-8"))
        self.assertEqual([item.get("id") for item in proofs.get("items", [])], [
            "j1_marie_kitchen_soft",
            "j1_mathilde_bag_domestic_trace",
            "j1_sandra_lunch_memory_soft",
        ])
        self.assertEqual(proofs.get("version"), 1)
        self.assertEqual(len(proofs.get("items", [])), 3)
        serialized_index = json.dumps(index, ensure_ascii=False).lower()
        for forbidden in ["rapha", "pauline", "nico", "groupe", "photo_group_last_party_placeholder"]:
            self.assertNotIn(forbidden, serialized_index)
        self.assertIn("Mathilde", "\n".join(index.get("end_of_day_player_knowledge", [])))

        initial_state = json.loads((GAME / "data/state/initial_state.json").read_text(encoding="utf-8"))
        unlocked_content = initial_state.get("unlocked_content", [])
        self.assertNotIn("profile_raphaelle_placeholder", unlocked_content)
        self.assertNotIn("profile_pauline_placeholder", unlocked_content)
        self.assertNotIn("profile_nico_placeholder", unlocked_content)
        self.assertNotIn("photo_group_last_party_placeholder", unlocked_content)

    def test_day1_marie_and_sandra_content_matches_progressive_scope(self):
        marie = json.loads((GAME / "data/conversations/chapter_01_marie.json").read_text(encoding="utf-8"))
        sandra = json.loads((GAME / "data/conversations/chapter_01_sandra.json").read_text(encoding="utf-8"))
        marie_text = json.dumps(marie, ensure_ascii=False).lower()
        sandra_text = json.dumps(sandra, ensure_ascii=False).lower()

        self.assertIn("pain", marie_text)
        self.assertIn("biscuits", marie_text)
        self.assertIn("tasse", marie_text)
        self.assertIn("mathilde", marie_text)
        self.assertIn("sacs", marie_text)
        self.assertIn("sensations fortes", marie_text)
        self.assertIn("j1_marie_kitchen_soft", marie.get("unlocks_content", []))
        self.assertIn("j1_mathilde_bag_domestic_trace", marie.get("unlocks_content", []))
        self.assertNotIn("pauline", marie_text)
        self.assertNotIn("nico", marie_text)
        self.assertNotIn("rapha", marie_text)

        self.assertIn("déjeuner", sandra_text)
        self.assertIn("photo", sandra_text)
        self.assertIn("café", sandra_text)
        self.assertIn("marche", sandra_text)
        self.assertIn("lac", sandra_text)
        self.assertIn("roman", sandra_text)
        self.assertIn("distance", sandra_text)
        self.assertIn("tomates", sandra_text)
        self.assertIn("profile_sandra_placeholder", sandra.get("unlocks_content", []))
        self.assertIn("j1_sandra_lunch_memory_soft", sandra.get("unlocks_content", []))
        self.assertNotIn("pauline", sandra_text)
        self.assertNotIn("nico", sandra_text)
        self.assertNotIn("rapha", sandra_text)

    def test_day1_emojis_stay_natural_and_avoid_forbidden_symbols(self):
        marie = json.loads((GAME / "data/conversations/chapter_01_marie.json").read_text(encoding="utf-8"))
        sandra = json.loads((GAME / "data/conversations/chapter_01_sandra.json").read_text(encoding="utf-8"))
        marie_text = json.dumps(marie, ensure_ascii=False)
        sandra_text = json.dumps(sandra, ensure_ascii=False)
        allowed = ["😅", "🙄", "🙂", "😂", "🫠"]
        marie_count = sum(marie_text.count(emoji) for emoji in allowed)
        sandra_count = sum(sandra_text.count(emoji) for emoji in allowed)
        self.assertGreaterEqual(marie_count, 10)
        self.assertLessEqual(marie_count, 14)
        self.assertGreaterEqual(sandra_count, 8)
        self.assertLessEqual(sandra_count, 12)
        self.assertLessEqual(marie_text.count("🫠") + sandra_text.count("🫠"), 1)
        for forbidden in ["❤️", "❤", "😍", "😘", "😏", "🍆", "💦", "🥵", "🍑", "🌶️"]:
            self.assertNotIn(forbidden, marie_text)
            self.assertNotIn(forbidden, sandra_text)

    def test_segmented_conversations_stay_grouped_in_moment_lists(self):
        loader = (GAME / "scripts" / "core" / "DataLoader.gd").read_text(encoding="utf-8")
        self.assertIn("get_segmented_conversation_entry", loader)
        self.assertIn("_segment_count", loader)
        self.assertNotIn("return _flatten_segments(source)", loader)
        self.assertNotIn("return _flatten_segments(conversations_by_day.get(str(day_value), []))", loader)

    def test_conversation_view_auto_flows_segments_without_continue_button(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        self.assertIn("signal segment_changed", script)
        self.assertIn("_auto_advance_segments_until_choice", script)
        self.assertIn("_render_segment_messages_with_typing", script)
        self.assertIn("current_segment_index", script)
        self.assertIn("_segment_id_for_current_index", script)
        auto_block = script[script.index("func _auto_advance_segments_until_choice"):script.index("func _render_segment_messages_with_typing")]
        self.assertIn("_show_choices_for_segment(data", auto_block)
        self.assertNotIn("choices.size() > 1", auto_block)
        self.assertNotIn("choices.size() == 1", auto_block)
        self.assertNotIn("Continuer", script)
        self.assertNotIn("continue_button", script)

    def test_conversation_view_does_not_render_choice_followups_before_click(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        flatten_block = script[script.index("func _flatten_render_entry"):script.index("func _current_segment_data")]
        self.assertIn("_has_direct_choices(item)", flatten_block)
        self.assertLess(flatten_block.index("_has_direct_choices(item)"), flatten_block.index('item.has("automatic_followup")'))
        self.assertIn("return", flatten_block[flatten_block.index("_has_direct_choices(item)"):flatten_block.index('item.has("automatic_followup")')])

    def test_conversation_view_guided_replies_remain_clickable_buttons_globally(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        choices_block = script[script.index("func _show_choices_for_segment"):script.index("func append_choice_result")]
        self.assertIn("choices.size() == 1", choices_block)
        self.assertIn("Button.new()", choices_block)
        self.assertIn("button.pressed.connect", choices_block)
        self.assertNotIn("choice_selected.emit(choice)", choices_block)
        self.assertNotIn("append_choice_result(choice)", choices_block)

    def test_phone_updates_debug_context_when_segment_continues(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        self.assertIn("segment_changed.connect(_on_segment_changed)", script)
        self.assertIn("func _on_segment_changed", script)
        self.assertIn("GameState.set_context(day_value", script)

    def test_conversation_view_polishes_post_choice_typing_flow(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        for expected in [
            "_clear_node(choice_area)",
            "_play_followup_sequence",
            "_show_typing_indicator",
            "_typing_delay_for_message",
            "0.35 + char_count * 0.018",
            "clamp(delay / max(debug_speed_multiplier, 1.0), 0.08, 2.4)",
            "await get_tree().create_timer",
            'typing_message["text"] = "..."',
            "_animate_typing_indicator",
            '[".", "..", "..."]',
            "_show_choices_for_segment",
        ]:
            self.assertIn(expected, script)
        self.assertNotIn("✓ %s", script)
        self.assertNotIn("écrit...", script)
        self.assertNotIn('typing_message["time_label"]', script)

    def test_conversation_view_has_fixed_header_scroll_thread_and_fixed_choice_area(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        for expected in [
            "header_panel",
            "message_scroll",
            "message_thread",
            "choice_area",
            "follow_focus = true",
            "ScrollContainer",
            "scroll_vertical",
            "_scroll_to_bottom",
        ]:
            self.assertIn(expected, script)
        self.assertLess(script.index("header_panel"), script.index("message_scroll"))
        self.assertLess(script.index("message_scroll"), script.index("choice_area"))

    def test_conversation_view_has_no_visible_segment_separator(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        self.assertNotIn("_add_timeline_separator", script)
        self.assertNotIn('"—"', script)
        self.assertNotIn('"-"', script)

    def test_conversation_view_has_character_bubble_palette(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        for expected in [
            "CHARACTER_BUBBLE_COLORS",
            '"ludo"',
            '"marie"',
            '"mathilde"',
            '"sandra"',
            '"raphaelle"',
            '"raphaëlle"',
            '"pauline"',
            '"nico"',
            '"groupe amis"',
            "_bubble_color_for_sender",
        ]:
            self.assertIn(expected, script)

    def test_conversation_view_isolates_state_and_guards_async_renders(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        for expected in [
            "conversation_states",
            "active_conversation_id",
            "current_render_token",
            "_is_render_current",
            "_conversation_key",
            "_restore_state_to_view",
            "_record_history_entry",
            "reset_ui_state",
            '"history"',
            '"waiting_choices"',
            '"choice_was_applied"',
            '"message_index"',
            '"followup_index"',
            '"segment_id"',
            '"sequence_in_progress"',
            '"sequence_complete"',
            "_resume_incomplete_sequence",
            "_flatten_render_queue",
        ]:
            self.assertIn(expected, script)
        self.assertGreaterEqual(script.count("_is_render_current(conversation_id, token)"), 5)
        self.assertIn("current_render_token += 1", script)

    def test_conversation_view_resume_keeps_logic_state_separate_from_render_token(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        self.assertIn("active_state[\"message_index\"] = index", script)
        self.assertIn("active_state[\"message_index\"] = index + 1", script)
        self.assertIn("active_state[\"followup_index\"] = index", script)
        self.assertIn("active_state[\"followup_index\"] = index + 1", script)
        self.assertIn("return", script[script.index("func _is_render_current"):script.index("func _record_history_entry")])
        self.assertIn("_restore_state_to_view(active_state)", script)
        self.assertIn("_resume_incomplete_sequence(conversation_id, token)", script)
        self.assertNotIn("active_state.clear()", script[script.index("func show_conversation"):script.index("func _build_chat_shell")])

    def test_conversation_view_restores_waiting_choices_without_replay_or_duplicates(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        self.assertIn("if bool(state.get(\"waiting_choices\", false))", script)
        self.assertIn("_show_choices_for_segment(state.get(\"choice_data\", {}), bool(state.get(\"show_empty_hint\", true)), false)", script)
        self.assertIn("rendered_message_keys", script)
        self.assertIn("_message_history_key", script)
        self.assertIn("if _history_contains_message(message):", script)
        self.assertIn("return", script[script.index("if _history_contains_message(message):"):script.index("func _show_typing_indicator")])

    def test_phone_reset_clears_conversation_ui_state(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        self.assertIn("conversation_view.reset_ui_state()", script)
        self.assertIn("pending_conversation_ids.clear()", script)
        self.assertIn("pending_thread_ids.clear()", script)
        self.assertIn("unlocked_conversation_ids_by_day.clear()", script)
        self.assertIn("unlocked_thread_ids_by_day.clear()", script)
    def test_day2_thread_metadata_groups_multiple_episodes_per_visible_contact(self):
        index = json.loads((GAME / "data/conversations/chapter_02_index.json").read_text(encoding="utf-8"))
        expected_flow = [
            ("08:12", "chapter_02_marie_morning", "thread_marie_private"),
            ("12:27", "chapter_02_raphaelle_midday", "thread_raphaelle_private"),
            ("17:36", "chapter_02_marie_afternoon", "thread_marie_private"),
            ("17:52", "chapter_02_mathilde_evening", "thread_mathilde_private"),
            ("18:38", "chapter_02_sandra_evening", "thread_sandra_private"),
            ("18:56", "chapter_02_marie_night", "thread_marie_private"),
            ("19:04", "chapter_02_mathilde_night", "thread_mathilde_private"),
        ]
        actual_flow = []
        for moment in index.get("moment_flow", []):
            self.assertEqual(len(moment.get("conversation_ids", [])), 1)
            conversation_id = moment["conversation_ids"][0]
            data = json.loads((GAME / "data/conversations" / f"{conversation_id}.json").read_text(encoding="utf-8"))
            actual_flow.append((moment.get("time_label"), conversation_id, data.get("thread", {}).get("id")))
        self.assertEqual(actual_flow, expected_flow)
        marie = [item for item in actual_flow if item[2] == "thread_marie_private"]
        mathilde = [item for item in actual_flow if item[2] == "thread_mathilde_private"]
        self.assertEqual(len(marie), 3)
        self.assertEqual(len(mathilde), 2)

    def test_loader_groups_day2_episodes_by_thread_not_by_episode_title(self):
        loader = (GAME / "scripts" / "core" / "DataLoader.gd").read_text(encoding="utf-8")
        for expected in [
            "_thread_key",
            "_group_conversations_by_thread",
            "_episode_ids",
            "_source_conversation_id",
            "thread_id",
        ]:
            self.assertIn(expected, loader)
        grouping_entry = loader[loader.index("func _group_segmented_conversations"):loader.index("func _group_conversations_by_thread")]
        self.assertNotIn("entries.append(get_segmented_conversation_entry(conversation))", grouping_entry)

    def test_day7_index_keeps_one_visible_thread_per_character_and_ma_cousine_correction(self):
        index = json.loads((GAME / "data/conversations/chapter_07_index.json").read_text(encoding="utf-8"))
        availability = index.get("conversation_availability", {})
        self.assertEqual(availability.get("initial_conversation_ids"), ["chapter_07_mathilde_too_close"])
        unlocks = availability.get("unlocks", {})
        self.assertEqual(unlocks.get("chapter_07_marie_senses_difference", {}).get("after_conversation_completed"), "chapter_07_mathilde_too_close")
        self.assertEqual(unlocks.get("chapter_07_sandra_lamp_soft", {}).get("after_conversation_completed"), "chapter_07_marie_senses_difference")
        self.assertEqual(unlocks.get("chapter_07_pauline_less_theoretical", {}).get("after_conversation_completed"), "chapter_07_sandra_lamp_soft")
        self.assertEqual(index.get("routes_available"), ["marie", "mathilde", "sandra", "pauline"])
        self.assertEqual(index.get("routes_locked_to_seed_only"), ["nico_marie"])

        mathilde = json.loads((GAME / "data/conversations/chapter_07_mathilde_too_close.json").read_text(encoding="utf-8"))
        self.assertEqual(mathilde.get("thread", {}).get("id"), "thread_mathilde_private")
        self.assertEqual(mathilde.get("segments", [])[0].get("messages", [])[0].get("text"), "Mission du jour. Très importante. Presque héroïque 😇")
        self.assertIn("ma cousine", json.dumps(mathilde, ensure_ascii=False))
        self.assertNotIn("meilleure amie", json.dumps(mathilde, ensure_ascii=False))

    def test_phone_availability_and_pending_use_episode_ids_inside_visible_threads(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        for expected in [
            "_conversation_episode_ids",
            "_first_available_episode_id",
            "_is_episode_available",
            "_thread_id_for_conversation_id",
            "pending_thread_ids",
            "unlocked_thread_ids_by_day",
            "if current_day_value != null and str(current_day_value) != str(day_value):",
        ]:
            self.assertIn(expected, script)
        self.assertIn("_conversation_episode_ids(conversation)", script)
        self.assertIn("_thread_id_for_conversation_id(day_value, str(target_id))", script)

    def test_day9_index_keeps_sandra_only_runtime_option_a_and_three_soft_visuals(self):
        index = json.loads((GAME / "data/conversations/chapter_09_index.json").read_text(encoding="utf-8"))
        availability = index.get("conversation_availability", {})
        self.assertEqual(availability.get("initial_conversation_ids"), ["chapter_09_sandra_relance"])
        self.assertEqual(availability.get("locked_conversation_ids"), [])
        self.assertEqual(availability.get("unlocks"), {})
        self.assertEqual(index.get("routes_available"), ["sandra"])
        self.assertEqual(index.get("routes_locked_to_seed_only"), [])
        self.assertEqual(index.get("proof_content_files"), ["res://data/visual_content/chapter_09_proofs.json"])
        self.assertEqual(index.get("conversation_files"), ["res://data/conversations/chapter_09_sandra_relance.json"])
        self.assertIn("Sandra", index.get("description", ""))
        self.assertIn("pas de panel", index.get("debug_notes", ""))

        conversation = json.loads((GAME / "data/conversations/chapter_09_sandra_relance.json").read_text(encoding="utf-8"))
        self.assertEqual(conversation.get("thread", {}).get("id"), "thread_sandra_private")
        self.assertEqual(conversation.get("segments", [])[0].get("messages", [])[0].get("sender"), "sandra")
        self.assertEqual(len(conversation.get("segments", [])[0].get("choices", [])), 3)
        self.assertNotIn("thread_marie_private", json.dumps(conversation, ensure_ascii=False))
        self.assertNotIn("thread_pauline_private", json.dumps(conversation, ensure_ascii=False))

        proofs = json.loads((GAME / "data/visual_content/chapter_09_proofs.json").read_text(encoding="utf-8"))
        self.assertEqual([item.get("id") for item in proofs.get("items", [])], [
            "j9_sandra_lunch_photo_soft",
            "j9_marie_daily_trace",
            "j9_pauline_indirect_story",
        ])
        self.assertEqual(proofs.get("version"), 1)
        self.assertEqual(len(proofs.get("items", [])), 3)
        self.assertTrue(any(item.get("character") == "sandra" for item in proofs.get("items", [])))

    def test_day5_index_reworks_nico_as_first_pivot_with_three_visual_traces(self):
        index = json.loads((GAME / "data/conversations/chapter_05_index.json").read_text(encoding="utf-8"))
        availability = index.get("conversation_availability", {})
        self.assertIn("res://data/conversations/chapter_05_social_story.json", index.get("conversation_files", []))
        self.assertEqual(availability.get("initial_conversation_ids"), ["chapter_05_marie_couple_vacille"])

        expected_flow = [
            ("08:12", "chapter_05_marie_couple_vacille", "thread_marie_private"),
            ("10:06", "chapter_05_social_story", "thread_nico_private"),
            ("10:22", "chapter_05_mathilde_kitchen_trial", "thread_mathilde_private"),
            ("11:18", "chapter_05_pauline_understands", "thread_pauline_private"),
            ("17:54", "chapter_05_raphaelle_work_breath", "thread_raphaelle_private"),
            ("20:18", "chapter_05_sandra_first_truth_game", "thread_sandra_private"),
            ("21:07", "chapter_05_pauline_last_photo", "thread_pauline_private"),
        ]
        conversation_by_id = {}
        for rel_path in index.get("conversation_files", []):
            data = json.loads((GAME / rel_path.removeprefix("res://")).read_text(encoding="utf-8"))
            conversation_by_id[data.get("id")] = data

        actual_flow = []
        for moment in index.get("moment_flow", []):
            self.assertEqual(len(moment.get("conversation_ids", [])), 1)
            conversation_id = moment["conversation_ids"][0]
            data = conversation_by_id[conversation_id]
            actual_flow.append((moment.get("time_label"), conversation_id, data.get("thread", {}).get("id")))
        self.assertEqual(actual_flow, expected_flow)

        self.assertEqual(index.get("routes_available"), ["marie", "mathilde", "pauline", "raphaelle", "sandra", "nico_marie"])
        self.assertEqual(availability.get("unlocks", {}).get("chapter_05_social_story", {}).get("after_conversation_completed"), "chapter_05_marie_couple_vacille")

        conversation = conversation_by_id["chapter_05_social_story"]
        self.assertEqual(conversation.get("thread", {}).get("id"), "thread_nico_private")
        self.assertEqual(conversation.get("thread", {}).get("display_name"), "Nico")
        self.assertEqual(conversation.get("thread", {}).get("type"), "private")
        self.assertEqual(len(conversation.get("segments", [])), 1)
        self.assertEqual(len(conversation.get("segments", [])[0].get("choices", [])), 5)
        scene_text = json.dumps(conversation.get("segments", []), ensure_ascii=False)
        for forbidden in ["photo intime", "non consentie", "volée", "Mathilde", "Pauline", "Sandra", "Raphaëlle"]:
            self.assertNotIn(forbidden, scene_text)

        proofs = json.loads((GAME / "data/visual_content/chapter_05_proofs.json").read_text(encoding="utf-8"))
        proof_ids = {item.get("id") for item in proofs.get("items", [])}
        for expected in ["j5_marie_party_nico_frame", "j5_nico_thread_capture", "j5_nico_bar_context"]:
            self.assertIn(expected, proof_ids)

    def test_conversation_view_resumes_newly_unlocked_episode_in_existing_thread(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        for expected in [
            "_merge_updated_conversation",
            "_has_next_segment()",
            "_completion_id_for_current_segment",
            '"_source_conversation_id"',
            "conversation_completed.emit",
        ]:
            self.assertIn(expected, script)
        restore_block = script[script.index('if bool(active_state.get("initialized", false)):'):script.index('active_state["initialized"] = true')]
        self.assertIn("_auto_advance_segments_until_choice(conversation_id, token)", restore_block)
        self.assertIn("sequence_complete", restore_block)


    def test_pending_threads_are_only_set_by_real_unlocks_not_by_opening_threads(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        open_block = script[script.index("func _open_conversation"):script.index("func _on_conversation_completed")]
        self.assertNotIn("_mark_other_conversations_pending", open_block)
        self.assertNotIn("pending_thread_ids[", open_block)
        self.assertIn("_clear_pending_for_conversation(conversation_id)", open_block)

        unlock_block = script[script.index("func _unlock_conversations_after_completion"):script.index("\nfunc _unlock_conversation(day_value")]
        self.assertIn("pending_thread_ids[thread_id] = true", unlock_block)
        self.assertIn("pending_conversation_ids[thread_id] = true", unlock_block)
        self.assertIn("_thread_id_for_conversation_id(day_value, str(target_id))", unlock_block)

    def test_pending_contract_covers_day1_day2_unlock_sequence_and_reset(self):
        script = (GAME / "scripts" / "ui" / "PhonePrototype.gd").read_text(encoding="utf-8")
        self.assertIn("pending_thread_ids.clear()", script)
        self.assertIn("unlocked_thread_ids_by_day.clear()", script)
        self.assertIn("initialized_pending_days.clear()", script)
        self.assertIn("_initialize_initial_pending_for_day(day_value)", script)
        self.assertIn("pending_thread_ids[thread_id] = true", script)
        self.assertIn("_clear_pending_for_conversation(conversation_id)", script)
        self.assertIn("func _is_conversation_pending", script)
        self.assertIn("pending_thread_ids.get(_conversation_id(conversation)", script)

        day1 = json.loads((GAME / "data/conversations/chapter_01_index.json").read_text(encoding="utf-8"))
        day1_unlocks = day1.get("conversation_availability", {}).get("unlocks", {})
        self.assertEqual(day1_unlocks.get("chapter_01_sandra", {}).get("after_conversation_completed"), "chapter_01_marie")

        day2 = json.loads((GAME / "data/conversations/chapter_02_index.json").read_text(encoding="utf-8"))
        unlocks = day2.get("conversation_availability", {}).get("unlocks", {})
        self.assertEqual(unlocks.get("chapter_02_raphaelle_midday", {}).get("after_conversation_completed"), "chapter_02_marie_morning")
        self.assertEqual(unlocks.get("chapter_02_marie_afternoon", {}).get("after_conversation_completed"), "chapter_02_raphaelle_midday")
        self.assertEqual(unlocks.get("chapter_02_mathilde_evening", {}).get("after_conversation_completed"), "chapter_02_marie_afternoon")
        self.assertEqual(unlocks.get("chapter_02_sandra_evening", {}).get("after_conversation_completed"), "chapter_02_mathilde_evening")
        self.assertEqual(unlocks.get("chapter_02_marie_night", {}).get("after_conversation_completed"), "chapter_02_sandra_evening")
        self.assertEqual(unlocks.get("chapter_02_mathilde_night", {}).get("after_conversation_completed"), "chapter_02_marie_night")


    def test_debug_panel_has_readable_compact_sections(self):
        script = (GAME / "scripts" / "ui" / "DebugPanel.gd").read_text(encoding="utf-8")
        self.assertIn("custom_minimum_size", script)
        self.assertIn("Résumé", script)
        self.assertIn("_add_json_section", script)
        self.assertIn("visible = false", script)


if __name__ == "__main__":
    unittest.main()
