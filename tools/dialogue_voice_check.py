#!/usr/bin/env python3
"""Check a dialogue JSON against adaptive character voice hints.

Usage from repository root:

    python3 tools/dialogue_voice_check.py game/data/conversations/chapter_05_raphaelle_boundary.json --character raphaelle

This script emits warnings for author review. It does not decide whether a scene is good.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
VOICE_PATH = ROOT / "game" / "data" / "writing" / "character_voice_profiles.json"
KNOWLEDGE_PATH = ROOT / "game" / "data" / "writing" / "knowledge_state.json"


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"expected JSON object: {path}")
    return data


def looks_like_emoji(char: str) -> bool:
    code = ord(char)
    return 0x1F300 <= code <= 0x1FAFF or 0x2600 <= code <= 0x27BF


def count_emoji(text: str) -> int:
    return sum(1 for char in text if looks_like_emoji(char))


def iter_message_nodes(root: Any) -> list[dict[str, Any]]:
    nodes: list[dict[str, Any]] = []

    def walk(value: Any) -> None:
        if isinstance(value, dict):
            if isinstance(value.get("text"), str) and (
                "sender" in value or "author" in value or "content_behavior" in value
            ):
                nodes.append(value)
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for child in value:
                walk(child)

    walk(root)
    return nodes


def iter_choices(root: Any) -> list[dict[str, Any]]:
    choices: list[dict[str, Any]] = []

    def walk(value: Any) -> None:
        if isinstance(value, dict):
            maybe = value.get("choices")
            if isinstance(maybe, list):
                choices.extend(item for item in maybe if isinstance(item, dict))
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for child in value:
                walk(child)

    walk(root)
    return choices


def infer_character(data: dict[str, Any], fallback: str | None) -> str | None:
    if fallback:
        return fallback
    thread = data.get("thread")
    if isinstance(thread, dict):
        participants = thread.get("participants")
        if isinstance(participants, list):
            non_player = [str(item) for item in participants if str(item) != "ludo"]
            if len(non_player) == 1:
                return non_player[0]
    return None


def has_anchor(texts: list[str], anchors: list[str]) -> bool:
    joined = "\n".join(texts).lower()
    return any(anchor.lower() in joined for anchor in anchors)


def contains_unknown_reference(texts: list[str], unknown_facts: list[str]) -> list[str]:
    joined = "\n".join(texts).lower()
    hits: list[str] = []
    # Very conservative keyword extraction: only warn when a distinctive word from the unknown fact appears.
    for fact in unknown_facts:
        words = [word.strip(".,;:!?()[]'’\"").lower() for word in fact.split()]
        distinctive = [word for word in words if len(word) >= 6]
        if distinctive and any(word in joined for word in distinctive[:3]):
            hits.append(fact)
    return hits


def main() -> int:
    parser = argparse.ArgumentParser(description="Check dialogue voice against character profiles.")
    parser.add_argument("file", help="Conversation JSON file")
    parser.add_argument("--character", default=None, help="Character key override")
    parser.add_argument("--stage", default=None, help="Relationship stage override")
    parser.add_argument("--risk", default=None, help="Risk level override")
    parser.add_argument("--strict", action="store_true", help="Return non-zero when warnings are found")
    args = parser.parse_args()

    dialogue_path = Path(args.file)
    data = load_json(dialogue_path)
    voice_data = load_json(VOICE_PATH)
    knowledge_data = load_json(KNOWLEDGE_PATH)
    profiles = voice_data.get("characters", {})
    knowledge = knowledge_data.get("characters", {})

    character = infer_character(data, args.character)
    if not character or character not in profiles:
        available = ", ".join(sorted(profiles))
        print(f"ERROR: cannot infer known character. Use --character. Available: {available}")
        return 2

    profile = profiles[character]
    character_knowledge = knowledge.get(character, {})
    stage = args.stage or character_knowledge.get("current_stage_hint") or "stage_1_familiarite"
    risk = args.risk or character_knowledge.get("current_risk_hint") or "medium"

    messages = iter_message_nodes(data)
    choices = iter_choices(data)
    character_texts = [
        str(node.get("text", ""))
        for node in messages
        if str(node.get("sender", node.get("author", ""))) == character and str(node.get("text", ""))
    ]
    all_texts = [str(node.get("text", "")) for node in messages if str(node.get("text", ""))]
    character_emoji = sum(count_emoji(text) for text in character_texts)
    allowed_emoji = set(profile.get("emoji_allowed", []))
    disallowed_emoji: set[str] = set()
    for text in character_texts:
        for char in text:
            if looks_like_emoji(char) and char not in allowed_emoji:
                disallowed_emoji.add(char)

    warnings: list[str] = []
    emoji_max = int(profile.get("emoji_max_default", 99))
    if character_emoji > emoji_max:
        warnings.append(f"too many emojis for {character}: {character_emoji} > {emoji_max}")
    if disallowed_emoji:
        warnings.append("unexpected emojis for character: " + " ".join(sorted(disallowed_emoji)))

    anchors = list(profile.get("good_anchor_words", []))
    if anchors and not has_anchor(all_texts, anchors):
        warnings.append("no concrete anchor from profile found: " + ", ".join(anchors[:6]))

    abstract_words = list(profile.get("abstract_warning_words", []))
    abstract_hits = [word for word in abstract_words if word.lower() in "\n".join(character_texts).lower()]
    if len(abstract_hits) >= 3:
        warnings.append("many abstract profile words detected; check for moralizing / exposition: " + ", ".join(abstract_hits))

    unknown_hits = contains_unknown_reference(all_texts, list(character_knowledge.get("does_not_know", [])))
    if unknown_hits:
        warnings.append("possible forbidden knowledge reference: " + " | ".join(unknown_hits[:3]))

    if len(messages) < 6:
        warnings.append("scene is very short; check whether character feels present enough")
    if choices and not any(isinstance(choice.get("next_messages"), list) for choice in choices):
        warnings.append("choices have no next_messages; consider adding character reactions")

    print(f"# Voice check — {dialogue_path}")
    print(f"character: {character}")
    print(f"stage: {stage}")
    print(f"risk: {risk}")
    print(f"character_messages: {len(character_texts)}")
    print(f"character_emojis: {character_emoji}")
    print(f"choices: {len(choices)}")
    print("stage_hint: " + str(profile.get("stage_variants", {}).get(stage, "—")))
    print("risk_hint: " + str(profile.get("risk_variants", {}).get(risk, "—")))

    if warnings:
        print("warnings:")
        for warning in warnings:
            print(f"  - {warning}")
    else:
        print("warnings: none")

    return 1 if warnings and args.strict else 0


if __name__ == "__main__":
    sys.exit(main())
