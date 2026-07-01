#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from pathlib import Path

PLAYER_MIN = 0.35
MAX_SAME = 6
MAX_NO_PLAYER = 7
MAX_CHOICE = 160
MAX_LEVEL_SANDRA_D1 = 3
BAD_CHOICE_PREFIXES = ("Exprimer", "Avouer", "Rassurer", "Flirter", "Demander", "Changer de sujet", "Faire une blague")
ROUTE_ELEMENTS = ("photo_pretext", "shared_memory", "playful_ambiguity", "sandra_deflection", "future_opening", "memory_out")
ROUTE_MEMORIES = ("day_01_sandra_reconnection", "day_01_sandra_photo_shared")


def msg_text(msg):
    if msg.get("type") == "media":
        return str(msg.get("media", {}).get("caption", ""))
    return str(msg.get("text", ""))


def pack(name, errors, warnings, summary):
    return {
        "check": name,
        "status": "fail" if errors else ("warning" if warnings else "pass"),
        "summary": summary,
        "errors": errors,
        "warnings": warnings,
    }


def check_json(scene):
    errors = []
    participants = scene.get("participants", [])
    messages = scene.get("messages", [])
    ids = set()
    if not scene.get("scene_id"):
        errors.append("Missing scene_id.")
    if not participants:
        errors.append("Missing participants.")
    if not messages:
        errors.append("Missing messages.")
    for i, msg in enumerate(messages):
        mid = str(msg.get("id", "")).strip()
        if not mid:
            errors.append(f"Message #{i} missing id.")
        elif mid in ids:
            errors.append(f"Duplicate message id: {mid}")
        ids.add(mid)
        if msg.get("speaker") not in participants:
            errors.append(f"Message {mid or i} has invalid speaker.")
        if msg.get("type") == "media":
            media = msg.get("media", {})
            if not isinstance(media, dict) or not media.get("kind"):
                errors.append(f"Media message {mid or i} is incomplete.")
        elif not msg_text(msg).strip():
            errors.append(f"Message {mid or i} has empty text.")
    for choice in scene.get("choices", []) or []:
        if choice.get("after_message") and choice["after_message"] not in ids:
            errors.append(f"Choice references unknown message {choice['after_message']}.")
        for opt in choice.get("options", []) or []:
            if not opt.get("id") or not str(opt.get("text", "")).strip():
                errors.append("Choice option missing id or text.")
    return pack("json_validity", errors, [], {"messages": len(messages), "choice_blocks": len(scene.get("choices", []) or [])})


def check_player(scene):
    messages = [m for m in scene.get("messages", []) if m.get("speaker")]
    total = len(messages)
    player_count = sum(1 for m in messages if m.get("speaker") == "Player")
    ratio = player_count / total if total else 0
    longest = 0
    current = 0
    for msg in messages:
        if msg.get("speaker") == "Player":
            current = 0
        else:
            current += 1
            longest = max(longest, current)
    warnings = []
    if ratio < PLAYER_MIN:
        warnings.append(f"Player ratio {ratio:.2f} below {PLAYER_MIN:.2f}.")
    if longest > MAX_NO_PLAYER:
        warnings.append(f"Longest non-Player streak {longest} exceeds {MAX_NO_PLAYER}.")
    return pack("player_presence", [], warnings, {"player_ratio": round(ratio, 3), "player_messages": player_count, "longest_non_player_streak": longest})


def check_rhythm(scene):
    messages = scene.get("messages", [])
    lengths = [len(msg_text(m)) for m in messages if msg_text(m)]
    longest = 0
    last = None
    streak = 0
    for msg in messages:
        speaker = msg.get("speaker")
        streak = streak + 1 if speaker == last else 1
        last = speaker
        longest = max(longest, streak)
    warnings = []
    if longest > MAX_SAME:
        warnings.append(f"Longest same-speaker streak {longest} exceeds {MAX_SAME}.")
    return pack("dialogue_rhythm", [], warnings, {"avg_message_length": round(sum(lengths) / len(lengths), 2) if lengths else 0, "longest_same_speaker_streak": longest})


def check_choices(scene):
    errors = []
    warnings = []
    checked = 0
    for choice in scene.get("choices", []) or []:
        for opt in choice.get("options", []) or []:
            checked += 1
            text = str(opt.get("text", "")).strip()
            if text.startswith(BAD_CHOICE_PREFIXES):
                errors.append(f"Choice {opt.get('id', '?')} starts like an instruction, not a SMS.")
            if len(text) > MAX_CHOICE:
                warnings.append(f"Choice {opt.get('id', '?')} is long for SMS.")
    if checked == 0:
        warnings.append("No choices found.")
    return pack("choice_sms_quality", errors, warnings, {"choices_checked": checked})


def check_level(scene):
    warnings = []
    errors = []
    declared = scene.get("declared_max_desire_intensity", scene.get("state_out", {}).get("player_sandra", {}).get("desire_intensity"))
    allowed = MAX_LEVEL_SANDRA_D1 if scene.get("route") == "sandra" and scene.get("day") == 1 else None
    if declared is None:
        warnings.append("No level declared.")
    elif allowed is not None and declared > allowed:
        errors.append(f"Declared level {declared} exceeds allowed max {allowed}.")
    return pack("desire_intensity", errors, warnings, {"declared_intensity": declared, "allowed_max": allowed})


def check_route(scene):
    present = set(scene.get("route_fantasy_elements", []) or [])
    if scene.get("memory_out"):
        present.add("memory_out")
    if any(m.get("type") == "media" and m.get("media", {}).get("kind") == "photo" for m in scene.get("messages", [])):
        present.add("photo_pretext")
    memories = {m.get("id") for m in scene.get("memory_out", []) if isinstance(m, dict)}
    warnings = []
    missing = [x for x in ROUTE_ELEMENTS if x not in present]
    missing_mem = [x for x in ROUTE_MEMORIES if x not in memories]
    if missing:
        warnings.append(f"Missing route elements: {missing}.")
    if missing_mem:
        warnings.append(f"Missing route memories: {missing_mem}.")
    return pack("route_fantasy_presence", [], warnings, {"present_elements": sorted(present), "present_memories": sorted(memories)})


CHECKS = (check_json, check_player, check_rhythm, check_choices, check_level, check_route)


def run(scene_path):
    path = Path(scene_path)
    scene = json.loads(path.read_text(encoding="utf-8"))
    details = [check(scene) for check in CHECKS]
    overall = "fail" if any(d["status"] == "fail" for d in details) else ("warning" if any(d["status"] == "warning" for d in details) else "pass")
    report = {
        "scene_id": scene.get("scene_id", path.stem),
        "status": overall,
        "summary": {"source": str(path), "messages": len(scene.get("messages", [])), "choices": sum(len(c.get("options", [])) for c in scene.get("choices", []) or [])},
        "checks": {d["check"]: d["status"] for d in details},
        "warnings": [{"check": d["check"], "detail": w} for d in details for w in d["warnings"]],
        "errors": [{"check": d["check"], "detail": e} for d in details for e in d["errors"]],
        "details": details,
    }
    root = next((p for p in [path.resolve().parent, *path.resolve().parents] if (p / "narrative_tool").exists()), Path.cwd())
    reports = root / "narrative_tool" / "reports"
    reports.mkdir(parents=True, exist_ok=True)
    out = reports / f"{report['scene_id']}.qa.json"
    out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    report["report_path"] = str(out)
    return report


def main():
    if len(sys.argv) != 2:
        print("Usage: python3 tools/dialogue_qa.py <scene.json>", file=sys.stderr)
        return 2
    report = run(sys.argv[1])
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 1 if report["status"] == "fail" else 0


if __name__ == "__main__":
    raise SystemExit(main())
