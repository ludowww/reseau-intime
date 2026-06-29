#!/usr/bin/env python3
"""Warn when a scene may lack a concrete narrative pivot.

Usage from repository root:

    python3 tools/scenario_pivot_check.py game/data/conversations/chapter_06_*.json

The check looks for signs of action, consequence, route-state movement, proof
movement, and concrete Player decisions. It is a prompt for author review, not a
quality verdict.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

from narrative_check_common import (
    choice_label,
    count_term_hits,
    expand_paths,
    iter_choices,
    iter_message_nodes,
    joined_text,
    load_json,
    next_messages,
    print_warnings,
    relative_path,
    sender_of,
    text_of,
)

PIVOT_TERMS = [
    "choisir",
    "décider",
    "décision",
    "agir",
    "supprimer",
    "effacer",
    "garder",
    "assumer",
    "dire la vérité",
    "mentir",
    "ouvrir",
    "règle",
    "cadre",
    "limite",
    "preuve",
    "conséquence",
    "jaloux",
    "nico",
    "marie",
]

STATE_TERMS = [
    "truth_discussion",
    "open_discussion",
    "revenge",
    "broken_trust",
    "cold_war",
    "reconnection",
    "couple_state",
    "player_posture",
    "route_pressure",
    "proof_state",
    "clarity_level",
]

CONCRETE_ACTION_TERMS = [
    "supprime",
    "supprimer",
    "efface",
    "effacer",
    "garde",
    "garder",
    "envoie",
    "envoyer",
    "montre",
    "montrer",
    "avoue",
    "avouer",
    "mens",
    "mentir",
    "propose",
    "proposer",
    "refuse",
    "refuser",
]


def choice_has_consequence(choice: dict[str, object]) -> bool:
    if next_messages(choice):
        return True
    for key in ("effects", "state_changes", "set_flags", "unlock", "route_effects", "consequence"):
        value = choice.get(key)
        if value:
            return True
    return False


def report_file(path: Path, player: str) -> int:
    try:
        data = load_json(path)
    except Exception as exc:
        print(f"ERROR {path}: {exc}")
        return 1

    text = joined_text(data)
    messages = iter_message_nodes(data)
    choices = iter_choices(data)
    pivot_hits = count_term_hits(text, PIVOT_TERMS)
    state_hits = count_term_hits(text, STATE_TERMS)
    action_hits = count_term_hits(text, CONCRETE_ACTION_TERMS)
    choices_with_consequence = [choice for choice in choices if choice_has_consequence(choice)]
    player_messages = [node for node in messages if sender_of(node) == player and text_of(node).strip()]
    player_action_messages = [
        node for node in player_messages if count_term_hits(text_of(node), CONCRETE_ACTION_TERMS) > 0
    ]

    print(f"\n# {relative_path(path)}")
    print(f"messages: {len(messages)}")
    print(f"choices: {len(choices)}")
    print(f"choices_with_consequence: {len(choices_with_consequence)}/{len(choices)}")
    print(f"player_messages: {len(player_messages)}")
    print(f"player_action_messages: {len(player_action_messages)}")
    print(f"pivot_term_hits: {pivot_hits}")
    print(f"state_term_hits: {state_hits}")
    print(f"action_term_hits: {action_hits}")

    warnings: list[str] = []
    if len(messages) < 6:
        warnings.append("scene is very short; verify it is not only functional")
    if choices and len(choices_with_consequence) == 0:
        warnings.append("choices do not expose next_messages/effects; pivot may be invisible")
    if pivot_hits == 0 and state_hits == 0:
        warnings.append("no obvious pivot/state language detected; verify what changes in this scene")
    if choices and action_hits == 0:
        warnings.append("choices exist but no concrete action terms detected; check whether Player actually acts")
    if "chapter_05" in str(path) or "chapter_06" in str(path):
        if not player_action_messages and "marie" in str(path).lower():
            warnings.append("J5/J6 Marie-related scene has no visible Player action message")
        if choices and len(choices_with_consequence) < len(choices):
            labels = [choice_label(choice) for choice in choices if not choice_has_consequence(choice)]
            warnings.append("choice(s) without visible consequence: " + "; ".join(labels[:5]))

    print_warnings(warnings)
    return 1 if warnings else 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Check whether dialogue scenes expose a narrative pivot.")
    parser.add_argument("files", nargs="+", help="JSON dialogue files or glob patterns")
    parser.add_argument("--player", default="ludo", help="Player sender key, default: ludo")
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
        file_status = report_file(path, args.player)
        if args.strict:
            status |= file_status
    return status


if __name__ == "__main__":
    sys.exit(main())
