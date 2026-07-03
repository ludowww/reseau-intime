#!/usr/bin/env python3
"""Report basic rhythm metrics for dialogue JSON files.

Usage from repository root:

    python3 tools/dialogue_rhythm_report.py game/data/conversations/chapter_05_*.json

This is an authoring helper only. It does not modify game data.
"""

from __future__ import annotations

import argparse
from collections import Counter
import glob
import json
import statistics
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]


def expand_paths(patterns: list[str]) -> list[Path]:
    result: list[Path] = []
    for pattern in patterns:
        matches = glob.glob(pattern)
        if matches:
            result.extend(Path(match) for match in matches)
        else:
            result.append(Path(pattern))
    return sorted(dict.fromkeys(result))


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError("expected JSON object")
    return data


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


def looks_like_emoji(char: str) -> bool:
    code = ord(char)
    return (
        0x1F300 <= code <= 0x1FAFF
        or 0x2600 <= code <= 0x27BF
    )


def count_emoji(text: str) -> int:
    return sum(1 for char in text if looks_like_emoji(char))


def extract_emoji_chars(texts: list[str]) -> list[str]:
    return [char for text in texts for char in text if looks_like_emoji(char)]


def median_or_zero(values: list[int]) -> float:
    return float(statistics.median(values)) if values else 0.0


def avg_or_zero(values: list[int]) -> float:
    return float(statistics.mean(values)) if values else 0.0


def report_file(path: Path) -> int:
    try:
        data = load_json(path)
    except Exception as exc:
        print(f"ERROR {path}: {exc}")
        return 1

    messages = iter_message_nodes(data)
    choices = iter_choices(data)
    texts = [str(node.get("text", "")) for node in messages if str(node.get("text", ""))]
    lengths = [len(text) for text in texts]
    emoji_chars = extract_emoji_chars(texts)
    emoji_count = len(emoji_chars)
    emoji_unique_count = len(set(emoji_chars))
    emoji_counter = Counter(emoji_chars)
    dominant_emoji = None
    dominant_count = 0
    if emoji_counter:
        dominant_emoji, dominant_count = emoji_counter.most_common(1)[0]
    total_chars = sum(lengths)
    emoji_density = (emoji_count / total_chars * 100.0) if total_chars else 0.0
    question_count = sum(text.count("?") for text in texts)
    content_refs = sum(1 for node in messages if isinstance(node.get("content_id"), str))
    next_message_choices = sum(1 for choice in choices if isinstance(choice.get("next_messages"), list))
    senders: dict[str, int] = {}
    for node in messages:
        sender = str(node.get("sender", node.get("author", "unknown")))
        senders[sender] = senders.get(sender, 0) + 1

    rel = path.relative_to(ROOT) if path.is_absolute() and ROOT in path.parents else path
    print(f"\n# {rel}")
    print(f"messages: {len(messages)}")
    print(f"choices: {len(choices)}")
    print(f"choices_with_reactions: {next_message_choices}/{len(choices)}")
    print(f"content_refs: {content_refs}")
    print(f"questions: {question_count}")
    print(f"emoji_count: {emoji_count}")
    print(f"emoji_unique_count: {emoji_unique_count}")
    print(f"emoji_density_approx: {emoji_density:.2f} per 100 chars")
    if emoji_count == 0:
        print("emoji_absence_note: absence à justifier si la scène n’est pas volontairement sèche / grave / retenue")
    else:
        print("emoji_absence_note: présence d’emojis ; relire la densité selon la voix, le stage et le risque")
    print(f"avg_message_chars: {avg_or_zero(lengths):.1f}")
    print(f"median_message_chars: {median_or_zero(lengths):.1f}")
    print("senders: " + (", ".join(f"{key}={value}" for key, value in sorted(senders.items())) or "—"))

    notes: list[str] = []
    warnings: list[str] = []
    if messages and len(messages) < 6:
        warnings.append("scene very short: check whether it is too functional")
    if choices and next_message_choices == 0:
        warnings.append("no reactions after choices: possible flat scene")
    if lengths and avg_or_zero(lengths) > 120:
        warnings.append("messages are long on average: check SMS naturalness")
    if question_count >= max(4, len(messages) // 2):
        warnings.append("many questions: check interrogation rhythm")
    if emoji_count == 0:
        notes.append("absence to justify if the scene is not intentionally dry / grave / restrained")
    elif emoji_count >= 5:
        notes.append("many emojis: verify that this matches the voice, stage and risk")
    if len({sender for sender in senders if sender != "unknown"}) > 1 and emoji_count > 0:
        notes.append("several characters in scene: reread emoji differentiation by voice")
    if dominant_emoji and emoji_count >= 3 and dominant_count / emoji_count >= 0.6:
        warnings.append(f"emoji_repeated_pattern warning: {dominant_emoji} dominates {dominant_count}/{emoji_count} emoji uses")

    if notes:
        print("notes:")
        for note in notes:
            print(f"  - {note}")
    if warnings:
        print("warnings:")
        for warning in warnings:
            print(f"  - {warning}")
    else:
        print("warnings: none")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Report dialogue rhythm metrics.")
    parser.add_argument("files", nargs="+", help="JSON dialogue files or glob patterns")
    args = parser.parse_args()

    paths = expand_paths(args.files)
    if not paths:
        print("No files matched.")
        return 1

    status = 0
    for path in paths:
        if not path.exists():
            print(f"ERROR missing: {path}")
            status = 1
            continue
        status |= report_file(path)
    return status


if __name__ == "__main__":
    sys.exit(main())
