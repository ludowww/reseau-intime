#!/usr/bin/env python3
"""Generic continuity checker for narrative memory contracts.

Supports two implicit modes:
- source_memory_coverage_check: draft.scene_id == contract.source_scene
- future_continuity_check: otherwise (or legacy contracts without source_scene)
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any, Iterable

STOPWORDS = {
    "a",
    "ai",
    "au",
    "aux",
    "avec",
    "ce",
    "ces",
    "cet",
    "cette",
    "dans",
    "de",
    "des",
    "du",
    "et",
    "est",
    "il",
    "je",
    "la",
    "le",
    "les",
    "leur",
    "leurs",
    "lui",
    "mais",
    "ne",
    "nous",
    "nous",
    "on",
    "ou",
    "par",
    "pas",
    "pour",
    "que",
    "qui",
    "se",
    "ses",
    "sur",
    "tandis",
    "te",
    "tes",
    "toi",
    "ton",
    "tous",
    "tout",
    "tu",
    "un",
    "une",
    "vos",
    "vous",
    "the",
    "and",
    "or",
    "not",
    "with",
}

MODE_SOURCE_COVERAGE = "source_memory_coverage_check"
MODE_FUTURE_CONTINUITY = "future_continuity_check"


def load_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as handle:
        data = json.load(handle)
    if not isinstance(data, dict):
        raise ValueError(f"expected object JSON in {path}")
    return data


def first_string(data: dict[str, Any], keys: Iterable[str]) -> str:
    for key in keys:
        value = data.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
    return ""


def as_string_list(value: Any) -> list[str]:
    if not isinstance(value, list):
        return []
    return [str(item) for item in value if item is not None]


def collect_text_fragments(value: Any) -> list[str]:
    fragments: list[str] = []
    if value is None:
        return fragments
    if isinstance(value, str):
        fragments.append(value)
    elif isinstance(value, dict):
        for item in value.values():
            fragments.extend(collect_text_fragments(item))
    elif isinstance(value, list):
        for item in value:
            fragments.extend(collect_text_fragments(item))
    elif isinstance(value, (int, float, bool)):
        fragments.append(str(value))
    return fragments


_TOKEN_RE = re.compile(r"[0-9A-Za-zÀ-ÖØ-öø-ÿ_']+")


def tokenize(*values: Any) -> set[str]:
    tokens: set[str] = set()
    for fragment in collect_text_fragments(list(values)):
        for raw in _TOKEN_RE.findall(fragment.lower()):
            token = raw.strip("_'")
            if len(token) < 3:
                continue
            if token in STOPWORDS:
                continue
            tokens.add(token)
    return tokens


def format_errors(errors: list[str]) -> None:
    print("FAIL")
    for error in errors:
        print(f"- {error}")


def detect_check_mode(contract: dict[str, Any], draft: dict[str, Any]) -> str:
    source_scene = first_string(contract, ("source_scene", "source_scene_id", "source_scene_contract"))
    target_scene = first_string(draft, ("scene_id",))
    if source_scene and target_scene == source_scene:
        return MODE_SOURCE_COVERAGE
    return MODE_FUTURE_CONTINUITY


def validate_route_consistency(contract: dict[str, Any], draft: dict[str, Any], errors: list[str]) -> None:
    contract_route = first_string(contract, ("route", "route_id"))
    draft_route = first_string(draft, ("route", "route_id"))
    if contract_route and draft_route and contract_route != draft_route:
        errors.append(f"route mismatch: contract={contract_route} draft={draft_route}")


def validate_direct_phrase_matches(phrases: list[str], text: str, min_overlap: int = 1) -> bool:
    text_terms = tokenize(text)
    if not phrases:
        return False
    best_overlap = 0
    for phrase in phrases:
        phrase_terms = tokenize(phrase)
        if not phrase_terms:
            continue
        overlap = len(phrase_terms & text_terms)
        if overlap > best_overlap:
            best_overlap = overlap
    return best_overlap >= min_overlap


def validate_future_continuity(contract: dict[str, Any], draft: dict[str, Any], errors: list[str], warnings: list[str]) -> None:
    target_scene = first_string(draft, ("scene_id",))
    if not target_scene:
        errors.append("draft.scene_id is required")

    memory_in = as_string_list(draft.get("memory_in"))
    if not memory_in:
        errors.append("draft.memory_in must exist as a non-empty list")

    expected_memory_in = as_string_list(
        contract.get("required_memory_in")
        or contract.get("required_day_2_callbacks")
        or contract.get("required_future_callbacks")
    )
    if expected_memory_in:
        exact_overlap = sorted(set(expected_memory_in) & set(memory_in))
        if exact_overlap:
            pass
        else:
            draft_text_terms = tokenize(draft)
            phrase_overlap = [phrase for phrase in expected_memory_in if len(tokenize(phrase) & draft_text_terms) >= 1]
            if not phrase_overlap:
                errors.append("draft does not recall any required memory/callback from the contract")
            elif len(phrase_overlap) < 1:
                errors.append("draft does not contain a readable callback to the contract")

    draft_terms = tokenize(draft)
    contract_terms = tokenize(
        contract.get("facts_created"),
        contract.get("interpreted_memories"),
        contract.get("required_future_callbacks"),
        contract.get("required_day_2_callbacks"),
        contract.get("continuity_tests"),
        contract.get("source_scene"),
        contract.get("route"),
    )
    if len(contract_terms & draft_terms) < 4:
        errors.append("draft does not use enough readable traces from the memory contract")

    forbidden_phrases = as_string_list(
        contract.get("forbidden_future_resets") or contract.get("forbidden_day_2_resets")
    )
    if forbidden_phrases:
        direct_text = " ".join(collect_text_fragments(draft)).lower()
        forbidden_hits = [phrase for phrase in forbidden_phrases if phrase.lower().strip() and phrase.lower().strip() in direct_text]
        if forbidden_hits:
            errors.append(f"draft contradicts forbidden reset(s): {', '.join(forbidden_hits)}")


def validate_source_coverage(contract: dict[str, Any], draft: dict[str, Any], errors: list[str]) -> None:
    source_scene = first_string(contract, ("source_scene", "source_scene_id", "source_scene_contract"))
    target_scene = first_string(draft, ("scene_id",))
    if not source_scene:
        errors.append("contract.source_scene is required for source coverage checks")
    if not target_scene:
        errors.append("draft.scene_id is required")
    if source_scene and target_scene and target_scene != source_scene:
        errors.append(f"scene_id mismatch: contract={source_scene} draft={target_scene}")

    memory_out_raw = draft.get("memory_out")
    memory_out = memory_out_raw if isinstance(memory_out_raw, list) else []
    if not memory_out:
        errors.append("draft.memory_out must exist as a non-empty list")

    memory_out_entries: list[dict[str, Any]] = [item for item in memory_out if isinstance(item, dict)]
    if memory_out and len(memory_out_entries) != len(memory_out):
        errors.append("draft.memory_out must contain only objects")

    memory_out_ids = [str(entry.get("id", "")).strip() for entry in memory_out_entries if str(entry.get("id", "")).strip()]
    if len(memory_out_ids) != len(set(memory_out_ids)):
        errors.append("draft.memory_out ids must be unique")
    if memory_out and not memory_out_ids:
        errors.append("draft.memory_out entries need readable ids")

    for entry in memory_out_entries:
        if not str(entry.get("id", "")).strip():
            errors.append("draft.memory_out entries need non-empty ids")
        if not str(entry.get("summary", "")).strip():
            errors.append(f"memory_out entry {entry.get('id', '<unknown>')} needs a summary")

    draft_memory_terms = tokenize(memory_out_ids, [entry.get("summary", "") for entry in memory_out_entries], draft)
    fact_terms = tokenize(contract.get("facts_created"))
    interpreted_terms = tokenize(contract.get("interpreted_memories"))

    if not fact_terms & draft_memory_terms:
        errors.append("draft.memory_out does not reflect the contract facts_created")
    if not interpreted_terms & draft_memory_terms:
        errors.append("draft.memory_out does not reflect the contract interpreted_memories")
    if len((fact_terms | interpreted_terms) & draft_memory_terms) < 4:
        errors.append("draft.memory_out is too weakly connected to the contract memory traces")

    route_state = contract.get("route_state_after_day_1") or contract.get("route_state_after_scene")
    if isinstance(route_state, dict):
        route_state_terms = tokenize(route_state)
        if route_state_terms and len(route_state_terms & draft_memory_terms) == 0:
            warnings.append("draft.memory_out does not explicitly echo route_state_after_scene terms")

    forbidden_phrases = as_string_list(
        contract.get("forbidden_future_resets") or contract.get("forbidden_day_2_resets")
    )
    if forbidden_phrases:
        direct_text = " ".join(collect_text_fragments(draft)).lower()
        forbidden_hits = [phrase for phrase in forbidden_phrases if phrase.lower().strip() and phrase.lower().strip() in direct_text]
        if forbidden_hits:
            errors.append(f"draft contradicts forbidden reset(s): {', '.join(forbidden_hits)}")


def run_memory_continuity_check(contract_path: Path, draft_path: Path, emit: bool = True) -> dict[str, Any]:
    errors: list[str] = []
    warnings: list[str] = []

    try:
        contract = load_json(contract_path)
    except Exception as exc:  # pragma: no cover - handled in CLI
        report = {
            "status": "fail",
            "mode": None,
            "contract_id": None,
            "source_scene": None,
            "target_scene": None,
            "errors": [f"memory contract: {exc}"],
            "warnings": [],
        }
        if emit:
            format_errors(report["errors"])
        return report

    try:
        draft = load_json(draft_path)
    except Exception as exc:  # pragma: no cover - handled in CLI
        report = {
            "status": "fail",
            "mode": None,
            "contract_id": first_string(contract, ("memory_contract_id",)),
            "source_scene": first_string(contract, ("source_scene", "source_scene_id", "source_scene_contract")) or None,
            "target_scene": None,
            "errors": [f"draft: {exc}"],
            "warnings": [],
        }
        if emit:
            format_errors(report["errors"])
        return report

    contract_id = first_string(contract, ("memory_contract_id",)) or None
    source_scene = first_string(contract, ("source_scene", "source_scene_id", "source_scene_contract")) or None
    target_scene = first_string(draft, ("scene_id",)) or None
    mode = detect_check_mode(contract, draft)

    if not contract_id:
        errors.append("contract.memory_contract_id is required")
    if not target_scene:
        errors.append("draft.scene_id is required")

    validate_route_consistency(contract, draft, errors)

    if mode == MODE_SOURCE_COVERAGE:
        validate_source_coverage(contract, draft, errors)
    else:
        validate_future_continuity(contract, draft, errors, warnings)

    status = "pass" if not errors else "fail"
    report = {
        "status": status,
        "mode": mode,
        "contract_id": contract_id,
        "source_scene": source_scene,
        "target_scene": target_scene,
        "errors": errors,
        "warnings": warnings,
    }

    if emit:
        if status == "pass":
            print(
                f"PASS mode: {mode} contract: {contract_id} source_scene: {source_scene or '-'} target_scene: {target_scene or '-'}"
            )
            for warning in warnings:
                print(f"WARNING: {warning}")
        else:
            print(f"FAIL mode: {mode} contract: {contract_id} source_scene: {source_scene or '-'} target_scene: {target_scene or '-'}")
            for error in errors:
                print(f"- {error}")
            for warning in warnings:
                print(f"WARNING: {warning}")

    return report


def main(argv: list[str] | None = None) -> int:
    args = sys.argv[1:] if argv is None else argv
    if len(args) != 2:
        print("Usage: python3 tools/check_memory_continuity.py <memory_contract.json> <draft.json>")
        return 1

    contract_path = Path(args[0])
    draft_path = Path(args[1])
    report = run_memory_continuity_check(contract_path, draft_path, emit=True)
    return 0 if report["status"] == "pass" else 1


if __name__ == "__main__":
    raise SystemExit(main())
