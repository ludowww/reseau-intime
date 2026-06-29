#!/usr/bin/env python3
"""Build a compact writing context pack for one character.

Usage from repository root:

    python3 tools/dialogue_context_pack.py --character raphaelle --day 6 --stage stage_1_familiarite --risk medium

This is an authoring helper only. It does not modify game data.
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
    try:
        with path.open("r", encoding="utf-8") as handle:
            data = json.load(handle)
    except FileNotFoundError:
        raise SystemExit(f"Missing file: {path.relative_to(ROOT)}")
    except json.JSONDecodeError as exc:
        raise SystemExit(f"Invalid JSON: {path.relative_to(ROOT)}:{exc.lineno}:{exc.colno}: {exc.msg}")
    if not isinstance(data, dict):
        raise SystemExit(f"Expected JSON object: {path.relative_to(ROOT)}")
    return data


def bullet_list(title: str, values: list[str] | None) -> list[str]:
    lines = [f"\n## {title}"]
    if not values:
        lines.append("- —")
        return lines
    lines.extend(f"- {value}" for value in values)
    return lines


def main() -> int:
    parser = argparse.ArgumentParser(description="Build a dialogue writing context pack.")
    parser.add_argument("--character", required=True, help="Character key, e.g. marie, sandra, raphaelle")
    parser.add_argument("--day", type=int, default=None, help="Target story day, e.g. 6")
    parser.add_argument("--stage", default=None, help="Relationship stage override, e.g. stage_2_complicite")
    parser.add_argument("--risk", default=None, help="Risk level override: low, medium, high, critical")
    parser.add_argument("--json", action="store_true", help="Print raw assembled context as JSON")
    args = parser.parse_args()

    voice_data = load_json(VOICE_PATH)
    knowledge_data = load_json(KNOWLEDGE_PATH)

    profiles = voice_data.get("characters", {})
    knowledge = knowledge_data.get("characters", {})
    if args.character not in profiles:
        available = ", ".join(sorted(profiles))
        raise SystemExit(f"Unknown character '{args.character}'. Available: {available}")

    profile = profiles[args.character]
    character_knowledge = knowledge.get(args.character, {})
    stage = args.stage or character_knowledge.get("current_stage_hint") or "stage_1_familiarite"
    risk = args.risk or character_knowledge.get("current_risk_hint") or "medium"

    assembled = {
        "character": args.character,
        "display_name": profile.get("display_name", args.character),
        "target_day": args.day,
        "stage": stage,
        "stage_meaning": voice_data.get("stage_scale", {}).get(stage, "unknown stage"),
        "risk": risk,
        "risk_meaning": voice_data.get("risk_scale", {}).get(risk, "unknown risk"),
        "base_voice": profile.get("base_voice", []),
        "stable_rules": profile.get("stable_rules", []),
        "can_evolve_toward": profile.get("can_evolve_toward", []),
        "too_early_or_forbidden": profile.get("too_early_or_forbidden", []),
        "emoji_allowed": profile.get("emoji_allowed", []),
        "emoji_max_default": profile.get("emoji_max_default"),
        "stage_variant": profile.get("stage_variants", {}).get(stage),
        "risk_variant": profile.get("risk_variants", {}).get(risk),
        "good_anchor_words": profile.get("good_anchor_words", []),
        "abstract_warning_words": profile.get("abstract_warning_words", []),
        "recent_beats": character_knowledge.get("recent_beats", []),
        "knows": character_knowledge.get("knows", []),
        "suspects": character_knowledge.get("suspects", []),
        "does_not_know": character_knowledge.get("does_not_know", []),
        "scene_prompts": character_knowledge.get("scene_prompts", []),
        "global_known_state": knowledge_data.get("global_known_state", []),
    }

    if args.json:
        print(json.dumps(assembled, ensure_ascii=False, indent=2))
        return 0

    lines: list[str] = []
    day_suffix = f" J{args.day}" if args.day else ""
    lines.append(f"# Context pack — {assembled['display_name']}{day_suffix}")
    lines.append(f"\nStage: {stage} — {assembled['stage_meaning']}")
    lines.append(f"Risque: {risk} — {assembled['risk_meaning']}")

    for title, key in [
        ("Voix de base", "base_voice"),
        ("Règles stables", "stable_rules"),
        ("Peut évoluer vers", "can_evolve_toward"),
        ("Trop tôt / interdit", "too_early_or_forbidden"),
        ("Événements récents", "recent_beats"),
        ("Ce que le personnage sait", "knows"),
        ("Ce que le personnage soupçonne", "suspects"),
        ("Ce que le personnage ne sait pas", "does_not_know"),
        ("Questions utiles pour la scène", "scene_prompts"),
    ]:
        lines.extend(bullet_list(title, assembled.get(key)))

    lines.append("\n## Variante active")
    lines.append(f"- Stade : {assembled.get('stage_variant') or 'pas de variante spécifique'}")
    lines.append(f"- Risque : {assembled.get('risk_variant') or 'pas de variante spécifique'}")

    lines.append("\n## Emojis")
    allowed = assembled.get("emoji_allowed") or []
    lines.append(f"- Autorisés : {' '.join(allowed) if allowed else 'aucun ou très rare'}")
    lines.append(f"- Maximum indicatif : {assembled.get('emoji_max_default')}")

    lines.append("\n## Ancrages concrets recommandés")
    anchors = assembled.get("good_anchor_words") or []
    lines.append(f"- {', '.join(anchors) if anchors else '—'}")

    lines.append("\n## Mots abstraits à surveiller")
    abstract = assembled.get("abstract_warning_words") or []
    lines.append(f"- {', '.join(abstract) if abstract else '—'}")

    print("\n".join(lines))
    return 0


if __name__ == "__main__":
    sys.exit(main())
