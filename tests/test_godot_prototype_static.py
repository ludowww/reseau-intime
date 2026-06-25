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
        self.assertIn("Vector2(220, 0)", script)
        self.assertIn("Vector2(260, 0)", script)
        self.assertIn("SIZE_EXPAND_FILL", script)

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
            "_show_choices_for_segment",
        ]:
            self.assertIn(expected, script)
        self.assertNotIn("✓ %s", script)
        self.assertNotIn("écrit...", script)

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

    def test_debug_panel_has_readable_compact_sections(self):
        script = (GAME / "scripts" / "ui" / "DebugPanel.gd").read_text(encoding="utf-8")
        self.assertIn("custom_minimum_size", script)
        self.assertIn("Résumé", script)
        self.assertIn("_add_json_section", script)
        self.assertIn("visible = false", script)


if __name__ == "__main__":
    unittest.main()
