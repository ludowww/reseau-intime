#!/usr/bin/env python3
"""Warn when Player is absent from important choice reactions.

Usage from repository root:

    python3 tools/player_presence_check.py game/data/conversations/chapter_05_*.json

This is an authoring helper only. It does not modify game data.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from narrative_check_common import (
    choice_label,
    expand_paths,
    iter_choices,
    iter_message_nodes,
    load_json,
    next_messages,
    print_warnings,
    relative_path,
    sender_of,
    text_of,
)

PLAYER_CHOICE_HINTS = [
    "avouer",
    "mentir",
    "minimiser",
    "provoquer",
    "retenir",
    "poser une limite",
    "ouvrir",
    "jaloux",
    "vérité",
    "flou",
    "supprimer",
    "garder",
    "effacer",
    "assumer",
]


def choice_looks_strong(label: str) -> bool:
    lowered = label.lower()
    return any(hint in lowered for hint in PLAYER_CHOICE_HINTS)


def has_player_reply(choice: dict[str, object], player: str) -> bool:
    for node in next_messages(choice):
        if sender_of(node) == player and text_of(node).strip():
            return True
    return False


def message_presence_stats(messages: list[dict[str, object]], player: str) -> tuple[int, int]:
    non_player_messages = 0
    longest_non_player_streak = 0
    current_streak = 0
    for node in messages:
        if sender_of(node) == player and text_of(node).strip():
            longest_non_player_streak = max(longest_non_player_streak, current_streak)
            current_streak = 0
        else:
            non_player_messages += 1
            current_streak += 1
    longest_non_player_streak = max(longest_non_player_streak, current_streak)
    return non_player_messages, longest_non_player_streak


def report_file(path: Path, player: str, min_ratio: float) -> int:
    try:
        data = load_json(path)
    except Exception as exc:
        print(f"ERROR {path}: {exc}")
        return 1

    messages = iter_message_nodes(data)
    choices = iter_choices(data)
    player_messages = [node for node in messages if sender_of(node) == player and text_of(node).strip()]
    non_player_messages, longest_non_player_streak = message_presence_stats(messages, player)
    choices_with_next = [choice for choice in choices if next_messages(choice)]
    choices_with_player = [choice for choice in choices if has_player_reply(choice, player)]
    strong_choices = [choice for choice in choices if choice_looks_strong(choice_label(choice))]
    strong_without_player = [choice for choice in strong_choices if not has_player_reply(choice, player)]

    ratio = (len(choices_with_player) / len(choices)) if choices else 1.0
    player_message_ratio = (len(player_messages) / len(messages)) if messages else 0.0

    print(f"\n# {relative_path(path)}")
    print(f"messages: {len(messages)}")
    print(f"non_player_messages: {non_player_messages}")
    print(f"player_messages: {len(player_messages)}")
    print(f"player_message_ratio: {player_message_ratio:.2f}")
    print(f"longest_player_absence_streak: {longest_non_player_streak}")
    print(f"choices: {len(choices)}")
    print(f"choices_with_next_messages: {len(choices_with_next)}/{len(choices)}")
    print(f"choices_with_player_reply: {len(choices_with_player)}/{len(choices)}")
    print(f"player_reply_ratio: {ratio:.2f}")
    print(f"strong_choices: {len(strong_choices)}")

    warnings: list[str] = []
    if messages and not player_messages:
        warnings.append("no visible Player messages; check whether Player is only implied by UI choices")
    if choices and not choices_with_next:
        warnings.append("choices have no next_messages; scene may feel abstract or flat")
    if choices and ratio < min_ratio:
        warnings.append(
            f"low Player reply ratio after choices: {len(choices_with_player)}/{len(choices)} < {min_ratio:.2f}"
        )
    if longest_non_player_streak >= 5:
        warnings.append(f"Player absent for {longest_non_player_streak} consecutive messages")
    if strong_without_player:
        labels = "; ".join(choice_label(choice) for choice in strong_without_player[:5])
        warnings.append("strong choice(s) without visible Player reply: " + labels)
    if choices and len(choices) >= 3 and len(choices_with_player) == 0:
        warnings.append("multiple choices but no visible Player response; likely J5/J6 regression risk")

    print_warnings(warnings)
    return 1 if warnings else 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Check visible Player presence after choices.")
    parser.add_argument("files", nargs="+", help="JSON dialogue files or glob patterns")
    parser.add_argument("--player", default="ludo", help="Player sender key, default: ludo")
    parser.add_argument(
        "--min-ratio",
        type=float,
        default=0.50,
        help="Minimum ratio of choices with visible Player replies before warning",
    )
    parser.add_argument("--strict", action="store_true", help="Return non-zero when warnings are found")
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
        file_status = report_file(path, args.player, args.min_ratio)
        if args.strict:
            status |= file_status
    return status


if __name__ == "__main__":
    sys.exit(main())
