#!/usr/bin/env python3
"""Validate a narrative SMS draft JSON file.

Usage from repository root:

    python3 tools/validate_dialogue_json.py narrative_tool/drafts/day_01_sandra_photo_trigger.draft.json
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

from narrative_check_common import expand_paths, iter_choices, iter_message_nodes, load_json, next_messages, sender_of, text_of

ALLOWED_SPEAKERS = {"Player", "Sandra", "Marie"}


def _validate_media(node: dict[str, Any], errors: list[str]) -> None:
    media = node.get("media")
    if media is None:
        return
    if not isinstance(media, list) or not media:
        errors.append(f"{node.get('id', '<message>')}: media must be a non-empty list")
        return
    for item in media:
        if not isinstance(item, dict):
            errors.append(f"{node.get('id', '<message>')}: media item must be an object")
            continue
        media_type = item.get("type") or item.get("media_type")
        media_id = item.get("id") or item.get("media_id")
        media_uri = item.get("uri") or item.get("url") or item.get("source")
        if not isinstance(media_type, str) or not media_type.strip():
            errors.append(f"{node.get('id', '<message>')}: media item missing type")
        if not isinstance(media_id, str) or not media_id.strip():
            errors.append(f"{node.get('id', '<message>')}: media item missing id")
        if not isinstance(media_uri, str) or not media_uri.strip():
            errors.append(f"{node.get('id', '<message>')}: media item missing uri/url/source")


def validate(path: Path) -> dict[str, Any]:
    result: dict[str, Any] = {"file": str(path), "status": "pass", "warnings": [], "errors": []}
    try:
        data = load_json(path)
    except Exception as exc:
        result["status"] = "fail"
        result["errors"].append(f"JSON parse failed: {exc}")
        return result

    if not isinstance(data, dict):
        result["status"] = "fail"
        result["errors"].append("top-level JSON must be an object")
        return result

    for key in ("scene_id", "messages"):
        if key not in data:
            result["errors"].append(f"missing required key: {key}")
    if result["errors"]:
        result["status"] = "fail"
        return result

    if not isinstance(data.get("scene_id"), str) or not data["scene_id"].strip():
        result["errors"].append("scene_id must be a non-empty string")
    if not isinstance(data.get("messages"), list) or not data["messages"]:
        result["errors"].append("messages must be a non-empty list")

    ids: list[str] = []
    message_count = 0
    player_count = 0
    choice_count = 0

    for node in data.get("messages", []):
        if not isinstance(node, dict):
            result["errors"].append("messages entries must be objects")
            continue
        message_count += 1
        node_id = node.get("id")
        if not isinstance(node_id, str) or not node_id.strip():
            result["errors"].append("message missing id")
        else:
            ids.append(node_id.strip())
        sender = sender_of(node)
        if sender not in ALLOWED_SPEAKERS:
            result["errors"].append(f"{node_id or '<message>'}: invalid sender '{sender}'")
        if not text_of(node).strip():
            result["errors"].append(f"{node_id or '<message>'}: text must be non-empty")
        elif sender == "Player":
            player_count += 1
        _validate_media(node, result["errors"])

    for choice in iter_choices(data):
        choice_count += 1
        node_id = choice.get("id")
        if not isinstance(node_id, str) or not node_id.strip():
            result["errors"].append("choice missing id")
        else:
            ids.append(node_id.strip())
        text = choice.get("text")
        if not isinstance(text, str) or not text.strip():
            result["errors"].append(f"{node_id or '<choice>'}: choice text must be non-empty")
        for msg in next_messages(choice):
            if not isinstance(msg, dict):
                result["errors"].append(f"{node_id or '<choice>'}: next_messages must contain objects")
                continue
            msg_id = msg.get("id")
            if isinstance(msg_id, str) and msg_id.strip():
                ids.append(msg_id.strip())
            if sender_of(msg) not in ALLOWED_SPEAKERS:
                result["errors"].append(f"{node_id or '<choice>'}: invalid next_message sender '{sender_of(msg)}'")
            if not text_of(msg).strip():
                result["errors"].append(f"{node_id or '<choice>'}: next_message text must be non-empty")

    if ids and len(ids) != len(set(ids)):
        result["errors"].append("ids must be unique across messages, choices and next_messages")

    if "choices" in data and not isinstance(data["choices"], list):
        result["errors"].append("choices must be a list when present")

    if message_count < 20:
        result["warnings"].append("draft is short; QA harness may only be partially exercised")
    if choice_count < 3:
        result["warnings"].append("fewer than 3 choices detected")
    if player_count == 0:
        result["warnings"].append("no Player messages detected")

    if result["errors"]:
        result["status"] = "fail"
    elif result["warnings"]:
        result["status"] = "warning"
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate narrative SMS JSON drafts.")
    parser.add_argument("files", nargs="+", help="JSON draft files or glob patterns")
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
        result = validate(path)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        if result["status"] == "fail":
            status = 1
    return status


if __name__ == "__main__":
    sys.exit(main())
