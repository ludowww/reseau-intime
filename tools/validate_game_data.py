#!/usr/bin/env python3
"""Validate Réseau Intime game data JSON files.

This script performs static checks only. It does not simulate gameplay.
Run from the repository root:

    python tools/validate_game_data.py
"""

from __future__ import annotations

import json
import re
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any, Iterable

ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = ROOT / "game" / "data"

FORBIDDEN_STATE_KEYS = {
    "route_points",
    "consent_score",
    "attraction_score",
    "passive_signals",
}

KNOWN_CONDITION_TOKENS = {
    "marie_shared_hour_paid",
    "marie_shared_time_paid",
    "scene_reveals_wallpaper",
}

ID_KEYS = {
    "id",
    "conversation_segment_id",
}

FLAG_CREATION_KEYS = {
    "sets_flags",
}

CONDITION_KEYS = {
    "conditions",
    "trigger_conditions",
}

RES_DATA_PREFIX = "res://data/"


def iter_json_files() -> list[Path]:
    return sorted(DATA_DIR.rglob("*.json"))


def load_json_files() -> tuple[dict[Path, Any], list[str]]:
    errors: list[str] = []
    data: dict[Path, Any] = {}
    for path in iter_json_files():
        try:
            with path.open("r", encoding="utf-8") as handle:
                data[path] = json.load(handle)
        except json.JSONDecodeError as exc:
            errors.append(f"JSON invalid: {path.relative_to(ROOT)}:{exc.lineno}:{exc.colno}: {exc.msg}")
        except OSError as exc:
            errors.append(f"Cannot read: {path.relative_to(ROOT)}: {exc}")
    return data, errors


def walk(value: Any, path: str = "") -> Iterable[tuple[str, Any]]:
    yield path, value
    if isinstance(value, dict):
        for key, child in value.items():
            child_path = f"{path}.{key}" if path else str(key)
            yield from walk(child, child_path)
    elif isinstance(value, list):
        for index, child in enumerate(value):
            child_path = f"{path}[{index}]"
            yield from walk(child, child_path)


def is_reusable_thread_definition(node_path: str, node: dict[str, Any], key: str) -> bool:
    """Thread ids identify persistent phone threads reused across chapters."""
    if key != "id":
        return False
    if not isinstance(node.get("participants"), list):
        return False
    return node_path == "thread" or node_path.endswith(".thread")


def collect_ids(data: dict[Path, Any]) -> tuple[dict[str, list[str]], dict[str, list[str]]]:
    ids: dict[str, list[str]] = defaultdict(list)
    content_ids: dict[str, list[str]] = defaultdict(list)

    for file_path, root in data.items():
        rel = str(file_path.relative_to(ROOT))
        for node_path, node in walk(root):
            if isinstance(node, dict):
                for key in ID_KEYS:
                    value = node.get(key)
                    if isinstance(value, str) and value and not is_reusable_thread_definition(node_path, node, key):
                        ids[value].append(f"{rel}:{node_path or '$'}:{key}")
                if node.get("type") in {"photo", "profile_photo", "wallpaper", "group_photo", "story", "capture"}:
                    value = node.get("id")
                    if isinstance(value, str) and value:
                        content_ids[value].append(f"{rel}:{node_path or '$'}:id")
    return ids, content_ids


def collect_content_catalog(data: dict[Path, Any]) -> set[str]:
    catalog: set[str] = set()
    for file_path, root in data.items():
        if "visual_content" not in file_path.parts:
            continue
        for _node_path, node in walk(root):
            if isinstance(node, dict) and isinstance(node.get("id"), str):
                catalog.add(node["id"])
    return catalog


def collect_forbidden_state_keys(data: dict[Path, Any]) -> dict[str, list[str]]:
    forbidden: dict[str, list[str]] = defaultdict(list)
    for file_path, root in data.items():
        rel = str(file_path.relative_to(ROOT))
        for node_path, node in walk(root):
            if not isinstance(node, dict):
                continue
            for key in node:
                normalized = str(key).casefold()
                if normalized in FORBIDDEN_STATE_KEYS or normalized.endswith("_score"):
                    forbidden[str(key)].append(f"{rel}:{node_path or '$'}")
    return forbidden


def collect_res_paths(data: dict[Path, Any]) -> dict[str, list[str]]:
    refs: dict[str, list[str]] = defaultdict(list)
    for file_path, root in data.items():
        rel = str(file_path.relative_to(ROOT))
        for node_path, node in walk(root):
            if isinstance(node, str) and node.startswith(RES_DATA_PREFIX):
                refs[node].append(f"{rel}:{node_path}")
    return refs


def res_path_exists(res_path: str) -> bool:
    relative = res_path.removeprefix("res://")
    data_root = DATA_DIR.resolve()
    candidate = (ROOT / "game" / relative).resolve()
    try:
        candidate.relative_to(data_root)
    except ValueError:
        return False
    return candidate.exists()


def collect_content_references(data: dict[Path, Any]) -> dict[str, list[str]]:
    refs: dict[str, list[str]] = defaultdict(list)
    for file_path, root in data.items():
        rel = str(file_path.relative_to(ROOT))
        for node_path, node in walk(root):
            if isinstance(node, dict):
                value = node.get("content_id")
                if isinstance(value, str) and value:
                    refs[value].append(f"{rel}:{node_path}.content_id")
                for key in ("unlocks_content", "initial_visual_anchors"):
                    values = node.get(key)
                    if isinstance(values, list):
                        for item in values:
                            if isinstance(item, str):
                                refs[item].append(f"{rel}:{node_path}.{key}")
    return refs


def collect_flags(data: dict[Path, Any]) -> tuple[dict[str, list[str]], dict[str, list[str]]]:
    created: dict[str, list[str]] = defaultdict(list)
    referenced: dict[str, list[str]] = defaultdict(list)

    for file_path, root in data.items():
        rel = str(file_path.relative_to(ROOT))
        for node_path, node in walk(root):
            if not isinstance(node, dict):
                continue
            for key in FLAG_CREATION_KEYS:
                values = node.get(key)
                if isinstance(values, list):
                    for flag in values:
                        if isinstance(flag, str) and flag:
                            created[flag].append(f"{rel}:{node_path}.{key}")
            for key in CONDITION_KEYS:
                values = node.get(key)
                if isinstance(values, list):
                    for condition in values:
                        if isinstance(condition, str):
                            for token in extract_condition_tokens(condition):
                                referenced[token].append(f"{rel}:{node_path}.{key}: {condition}")
    return created, referenced


def extract_condition_tokens(condition: str) -> set[str]:
    # Remove operators and numeric comparisons, keep likely flag/variable tokens.
    candidates = set(re.findall(r"[A-Za-z_][A-Za-z0-9_\.]*", condition))
    keywords = {"OR", "AND", "true", "false", "null"}
    return {token for token in candidates if token not in keywords and not token.isupper()}


def main() -> int:
    data, errors = load_json_files()
    warnings: list[str] = []

    if errors:
        print("ERROR: JSON parse errors found")
        for error in errors:
            print(f"  - {error}")
        return 1

    print(f"OK: parsed {len(data)} JSON files")

    all_ids, _content_like_ids = collect_ids(data)
    duplicates = {key: locs for key, locs in all_ids.items() if len(locs) > 1}
    if duplicates:
        errors.append("Duplicate ids found:")
        for key, locs in sorted(duplicates.items()):
            errors.append(f"  {key}: " + "; ".join(locs))
    else:
        print("OK: no duplicate ids")

    res_refs = collect_res_paths(data)
    missing_res = {ref: locs for ref, locs in res_refs.items() if not res_path_exists(ref)}
    if missing_res:
        errors.append("Missing res://data references:")
        for ref, locs in sorted(missing_res.items()):
            errors.append(f"  {ref}: " + "; ".join(locs))
    else:
        print("OK: res://data references valid")

    catalog = collect_content_catalog(data)
    content_refs = collect_content_references(data)
    missing_content = {ref: locs for ref, locs in content_refs.items() if ref not in catalog}
    if missing_content:
        errors.append("Missing content_id references:")
        for ref, locs in sorted(missing_content.items()):
            errors.append(f"  {ref}: " + "; ".join(locs))
    else:
        print(f"OK: content references valid ({len(catalog)} content ids cataloged)")

    forbidden_keys = collect_forbidden_state_keys(data)
    if forbidden_keys:
        errors.append("Forbidden score or accumulator keys found:")
        for key, locs in sorted(forbidden_keys.items()):
            errors.append(f"  {key}: " + "; ".join(locs))
    else:
        print("OK: no score or accumulator keys")

    created_flags, referenced_tokens = collect_flags(data)
    known_condition_tokens = set(KNOWN_CONDITION_TOKENS) | set(created_flags)
    unresolved = {
        token: locs
        for token, locs in referenced_tokens.items()
        if token not in known_condition_tokens
    }
    if unresolved:
        warnings.append("Flags/tokens referenced in conditions but not created as flags or variables:")
        for token, locs in sorted(unresolved.items()):
            warnings.append(f"  {token}: " + "; ".join(locs[:3]) + ("; ..." if len(locs) > 3 else ""))
    else:
        print("OK: condition references look resolvable")

    if warnings:
        print("WARNINGS:")
        for warning in warnings:
            print(f"  - {warning}")
    else:
        print("OK: no warnings")

    if errors:
        print("ERRORS:")
        for error in errors:
            print(f"  - {error}")
        return 1

    print("OK: data validation completed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
