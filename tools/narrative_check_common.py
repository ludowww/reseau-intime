#!/usr/bin/env python3
"""Shared helpers for narrative authoring checks.

These helpers are intentionally conservative. They are used by authoring tools that
emit warnings for review, not hard judgments about story quality.
"""

from __future__ import annotations

import glob
import json
import re
from pathlib import Path
from typing import Any, Iterable

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
        raise ValueError(f"expected JSON object: {path}")
    return data


def relative_path(path: Path) -> str:
    try:
        return str(path.resolve().relative_to(ROOT))
    except ValueError:
        return str(path)


def walk_dicts(root: Any) -> Iterable[dict[str, Any]]:
    if isinstance(root, dict):
        yield root
        for child in root.values():
            yield from walk_dicts(child)
    elif isinstance(root, list):
        for child in root:
            yield from walk_dicts(child)


def iter_message_nodes(root: Any) -> list[dict[str, Any]]:
    nodes: list[dict[str, Any]] = []
    for value in walk_dicts(root):
        if isinstance(value.get("text"), str) and (
            "sender" in value or "author" in value or "content_behavior" in value
        ):
            nodes.append(value)
    return nodes


def iter_choices(root: Any) -> list[dict[str, Any]]:
    choices: list[dict[str, Any]] = []
    for value in walk_dicts(root):
        maybe = value.get("choices")
        if isinstance(maybe, list):
            choices.extend(item for item in maybe if isinstance(item, dict))
    return choices


def sender_of(node: dict[str, Any]) -> str:
    return str(node.get("sender", node.get("author", ""))).strip()


def text_of(node: dict[str, Any]) -> str:
    value = node.get("text")
    return value if isinstance(value, str) else ""


def choice_label(choice: dict[str, Any]) -> str:
    for key in ("text", "label", "title", "caption", "choice_text"):
        value = choice.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
    return "<choice>"


def next_messages(choice: dict[str, Any]) -> list[dict[str, Any]]:
    value = choice.get("next_messages")
    if not isinstance(value, list):
        return []
    return [item for item in value if isinstance(item, dict)]


def collect_texts(root: Any) -> list[str]:
    texts: list[str] = []
    for value in walk_dicts(root):
        for key in ("text", "label", "title", "caption", "description", "summary"):
            item = value.get(key)
            if isinstance(item, str) and item.strip():
                texts.append(item.strip())
    return texts


def joined_text(root: Any) -> str:
    return "\n".join(collect_texts(root))


def normalize_text(text: str) -> str:
    lowered = text.lower()
    # Keep accented letters and apostrophes useful for French dialogue checks.
    return re.sub(r"[^a-zàâçéèêëîïôûùüÿñæœ0-9'’\s-]", " ", lowered)


def count_term_hits(text: str, terms: list[str]) -> int:
    normalized = normalize_text(text)
    hits = 0
    for term in terms:
        normalized_term = normalize_text(term).strip()
        if not normalized_term:
            continue
        # Simple substring matching is deliberate: terms are authoring hints,
        # not strict linguistic categories.
        hits += normalized.count(normalized_term)
    return hits


def content_reference_nodes(root: Any) -> list[dict[str, Any]]:
    nodes: list[dict[str, Any]] = []
    for value in walk_dicts(root):
        if any(
            isinstance(value.get(key), str) and value.get(key)
            for key in ("content_id", "visual_content_id", "photo_id", "image_id")
        ):
            nodes.append(value)
        elif isinstance(value.get("content_ids"), list) or isinstance(value.get("visual_content_ids"), list):
            nodes.append(value)
    return nodes


def looks_like_emoji(char: str) -> bool:
    code = ord(char)
    return 0x1F300 <= code <= 0x1FAFF or 0x2600 <= code <= 0x27BF


def count_emoji(text: str) -> int:
    return sum(1 for char in text if looks_like_emoji(char))


def print_warnings(warnings: list[str]) -> None:
    if warnings:
        print("warnings:")
        for warning in warnings:
            print(f"  - {warning}")
    else:
        print("warnings: none")
