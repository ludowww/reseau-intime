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
            "res://data/visual_content/placeholders.json",
            "res://data/visual_content/chapter_04_proofs.json",
        ]:
            self.assertIn(required, loader)

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
            "_mark_other_conversations_pending",
            "_clear_pending_for_conversation",
            "_show_notification",
            "Nouveau message",
            "En attente",
            "pending",
        ]:
            self.assertIn(expected, script)

    def test_conversation_view_wraps_choices_and_renders_ludo_reply(self):
        script = (GAME / "scripts" / "ui" / "ConversationView.gd").read_text(encoding="utf-8")
        self.assertIn("choice_buttons", script)
        self.assertIn("AUTOWRAP_WORD_SMART", script)
        self.assertIn("disabled = true", script)
        self.assertIn("_append_ludo_reply", script)
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
            choice_counts = [len(segment.get("choices", [])) for segment in segments]
            self.assertIn(1, choice_counts, relative)
            self.assertTrue(any(count > 1 for count in choice_counts), relative)

    def test_day1_progressive_content_keeps_only_marie_and_sandra_active(self):
        index = json.loads((GAME / "data/conversations/chapter_01_index.json").read_text(encoding="utf-8"))
        self.assertEqual(index.get("default_order"), ["chapter_01_marie", "chapter_01_sandra"])
        self.assertEqual(index.get("conversation_files"), [
            "res://data/conversations/chapter_01_marie.json",
            "res://data/conversations/chapter_01_sandra.json",
        ])
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

        self.assertIn("chargeur", marie_text)
        self.assertIn("téléphone", marie_text)
        self.assertIn("pain", marie_text)
        self.assertIn("mathilde", marie_text)
        self.assertNotIn("pauline", marie_text)
        self.assertNotIn("nico", marie_text)
        self.assertNotIn("rapha", marie_text)

        self.assertIn("déjeuner", sandra_text)
        self.assertIn("photo", sandra_text)
        self.assertIn("doucement", sandra_text)
        self.assertIn("profile_sandra_placeholder", sandra.get("unlocks_content", []))
        self.assertNotIn("pauline", sandra_text)
        self.assertNotIn("nico", sandra_text)
        self.assertNotIn("rapha", sandra_text)

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
        self.assertNotIn("Continuer", script)
        self.assertNotIn("continue_button", script)

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
            "clamp(delay, 0.45, 2.4)",
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

    def test_debug_panel_has_readable_compact_sections(self):
        script = (GAME / "scripts" / "ui" / "DebugPanel.gd").read_text(encoding="utf-8")
        self.assertIn("custom_minimum_size", script)
        self.assertIn("Résumé", script)
        self.assertIn("_add_json_section", script)
        self.assertIn("visible = false", script)


if __name__ == "__main__":
    unittest.main()
