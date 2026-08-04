#!/usr/bin/env python3
"""Offline A11.2 voice and relationship calibration, with no runtime output."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path
from typing import Any, Mapping, Sequence

try:
    from tools.a11_authoring_workshop import Issue, validate_character
except ModuleNotFoundError:  # Direct script execution keeps only tools/ on sys.path.
    from a11_authoring_workshop import Issue, validate_character


ROOT = Path(__file__).resolve().parents[1]
CALIBRATION_DIR = ROOT / "narrative_tool" / "a11" / "calibration"

FORMAT_RELATIONSHIP_CALIBRATION = "R8C_A11_RELATIONSHIP_CALIBRATION_REGISTER"
FORMAT_VOICE_CALIBRATION_CASE = "R8C_A11_VOICE_CALIBRATION_CASE"
VERSION = 1
CASE_NAMES = ("sandra", "marie", "mathilde")

RELATIONSHIP_ROOT_KEYS = {"format", "version", "relationship"}
RELATIONSHIP_KEYS = {
    "relationship_id",
    "participant_ids",
    "nature",
    "shared_facts",
    "limits",
    "movements",
    "local_states",
}
FACT_KEYS = {"fact_id", "text", "known_by"}
LIMIT_KEYS = {"limit_id", "text"}
MOVEMENT_KEYS = {"movement_id", "actor_id", "text", "requires_limit_ids"}
STATE_KEYS = {"state_id", "description", "strategy", "movement_ids"}

CASE_ROOT_KEYS = {
    "format",
    "version",
    "case_id",
    "active_character_id",
    "active_relationship_id",
    "local_state_id",
    "useful_fact_ids",
    "useful_limit_ids",
    "expected_movement_ids",
    "voice_evidence",
    "messages",
}
VOICE_EVIDENCE_KEYS = {"rule_group", "rule_text", "message_ids"}
MESSAGE_KEYS = {"message_id", "speaker_id", "text", "fact_refs", "movement_refs"}


class A112CalibrationError(ValueError):
    def __init__(self, issues: Sequence[Issue]):
        self.issues = tuple(issues)
        super().__init__("; ".join(f"{issue.code} at {issue.path}" for issue in self.issues))


def _canonical(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


def _issue(issues: list[Issue], code: str, path: str, message: str) -> None:
    issues.append(Issue(code, path, message))


def _nonempty(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip()) and value == value.strip()


def _closed(value: Any, keys: set[str], path: str, issues: list[Issue]) -> bool:
    if not isinstance(value, dict):
        _issue(issues, "OBJECT_REQUIRED", path, "objet JSON attendu")
        return False
    if set(value) != keys:
        _issue(
            issues,
            "CLOSED_SCHEMA_MISMATCH",
            path,
            f"champs manquants={sorted(keys - set(value))}; champs inconnus={sorted(set(value) - keys)}",
        )
        return False
    return True


def _string_list(value: Any, path: str, issues: list[Issue], *, nonempty: bool = False) -> bool:
    if not isinstance(value, list) or (nonempty and not value):
        _issue(issues, "STRING_LIST_REQUIRED", path, "tableau de chaînes attendu")
        return False
    if any(not _nonempty(item) for item in value):
        _issue(issues, "STRING_LIST_INVALID", path, "chaîne vide ou type invalide")
        return False
    if len(value) != len(set(value)):
        _issue(issues, "STRING_LIST_DUPLICATE", path, "valeurs dupliquées")
        return False
    return True


def _unique_objects(
    values: Any,
    keys: set[str],
    identity_key: str,
    path: str,
    issues: list[Issue],
) -> list[dict[str, Any]]:
    if not isinstance(values, list) or not values:
        _issue(issues, "OBJECT_LIST_REQUIRED", path, "tableau non vide attendu")
        return []
    valid: list[dict[str, Any]] = []
    seen: set[str] = set()
    for index, value in enumerate(values):
        item_path = f"{path}[{index}]"
        if not _closed(value, keys, item_path, issues):
            continue
        identity = value[identity_key]
        if not _nonempty(identity):
            _issue(issues, "TEXT_REQUIRED", f"{item_path}.{identity_key}", "identité requise")
        elif identity in seen:
            _issue(issues, "IDENTITY_DUPLICATE", f"{item_path}.{identity_key}", identity)
        else:
            seen.add(identity)
        valid.append(value)
    return valid


def validate_relationship_calibration(document: Any, path: str = "relationship") -> list[Issue]:
    issues: list[Issue] = []
    if not _closed(document, RELATIONSHIP_ROOT_KEYS, path, issues):
        return issues
    if document["format"] != FORMAT_RELATIONSHIP_CALIBRATION:
        _issue(issues, "FORMAT_UNKNOWN", f"{path}.format", FORMAT_RELATIONSHIP_CALIBRATION)
    if type(document["version"]) is not int or document["version"] != VERSION:
        _issue(issues, "VERSION_UNKNOWN", f"{path}.version", str(VERSION))
    relation = document["relationship"]
    if not _closed(relation, RELATIONSHIP_KEYS, f"{path}.relationship", issues):
        return issues
    for field in ("relationship_id", "nature"):
        if not _nonempty(relation[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.relationship.{field}", "chaîne non vide attendue")
    participants_valid = _string_list(
        relation["participant_ids"], f"{path}.relationship.participant_ids", issues, nonempty=True
    )
    if not participants_valid or len(relation["participant_ids"]) != 2:
        _issue(issues, "RELATION_PAIR_REQUIRED", f"{path}.relationship.participant_ids", "deux participants attendus")
    participant_ids = set(relation["participant_ids"]) if participants_valid else set()

    facts = _unique_objects(relation["shared_facts"], FACT_KEYS, "fact_id", f"{path}.relationship.shared_facts", issues)
    for index, fact in enumerate(facts):
        fact_path = f"{path}.relationship.shared_facts[{index}]"
        if not _nonempty(fact["text"]):
            _issue(issues, "TEXT_REQUIRED", f"{fact_path}.text", "texte requis")
        if _string_list(fact["known_by"], f"{fact_path}.known_by", issues, nonempty=True):
            if not set(fact["known_by"]).issubset(participant_ids):
                _issue(issues, "FACT_KNOWLEDGE_OUTSIDE_RELATION", f"{fact_path}.known_by", fact["fact_id"])

    limits = _unique_objects(relation["limits"], LIMIT_KEYS, "limit_id", f"{path}.relationship.limits", issues)
    for index, limit in enumerate(limits):
        if not _nonempty(limit["text"]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.relationship.limits[{index}].text", "texte requis")
    limit_ids = {limit["limit_id"] for limit in limits}

    movements = _unique_objects(
        relation["movements"], MOVEMENT_KEYS, "movement_id", f"{path}.relationship.movements", issues
    )
    movement_ids = {movement["movement_id"] for movement in movements}
    for index, movement in enumerate(movements):
        movement_path = f"{path}.relationship.movements[{index}]"
        if movement["actor_id"] not in participant_ids:
            _issue(issues, "MOVEMENT_ACTOR_OUTSIDE_RELATION", f"{movement_path}.actor_id", movement["actor_id"])
        if not _nonempty(movement["text"]):
            _issue(issues, "TEXT_REQUIRED", f"{movement_path}.text", "texte requis")
        if _string_list(movement["requires_limit_ids"], f"{movement_path}.requires_limit_ids", issues):
            for limit_id in movement["requires_limit_ids"]:
                if limit_id not in limit_ids:
                    _issue(issues, "MOVEMENT_LIMIT_UNKNOWN", f"{movement_path}.requires_limit_ids", limit_id)

    states = _unique_objects(relation["local_states"], STATE_KEYS, "state_id", f"{path}.relationship.local_states", issues)
    if len(states) < 2:
        _issue(issues, "LOCAL_STATE_VARIATION_REQUIRED", f"{path}.relationship.local_states", "deux états locaux minimum")
    for index, state in enumerate(states):
        state_path = f"{path}.relationship.local_states[{index}]"
        for field in ("description", "strategy"):
            if not _nonempty(state[field]):
                _issue(issues, "TEXT_REQUIRED", f"{state_path}.{field}", "texte requis")
        if _string_list(state["movement_ids"], f"{state_path}.movement_ids", issues, nonempty=True):
            for movement_id in state["movement_ids"]:
                if movement_id not in movement_ids:
                    _issue(issues, "STATE_MOVEMENT_UNKNOWN", f"{state_path}.movement_ids", movement_id)
    return issues


def validate_calibration_case(document: Any, path: str = "case") -> list[Issue]:
    issues: list[Issue] = []
    if not _closed(document, CASE_ROOT_KEYS, path, issues):
        return issues
    if document["format"] != FORMAT_VOICE_CALIBRATION_CASE:
        _issue(issues, "FORMAT_UNKNOWN", f"{path}.format", FORMAT_VOICE_CALIBRATION_CASE)
    if type(document["version"]) is not int or document["version"] != VERSION:
        _issue(issues, "VERSION_UNKNOWN", f"{path}.version", str(VERSION))
    for field in ("case_id", "active_character_id", "active_relationship_id", "local_state_id"):
        if not _nonempty(document[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.{field}", "chaîne non vide attendue")
    for field in ("useful_fact_ids", "useful_limit_ids", "expected_movement_ids"):
        _string_list(document[field], f"{path}.{field}", issues, nonempty=True)

    evidence = _unique_objects(
        document["voice_evidence"], VOICE_EVIDENCE_KEYS, "rule_text", f"{path}.voice_evidence", issues
    )
    for index, item in enumerate(evidence):
        item_path = f"{path}.voice_evidence[{index}]"
        if item["rule_group"] not in {"tone_markers", "style_rules"}:
            _issue(issues, "VOICE_RULE_GROUP_UNKNOWN", f"{item_path}.rule_group", str(item["rule_group"]))
        _string_list(item["message_ids"], f"{item_path}.message_ids", issues, nonempty=True)

    messages = _unique_objects(document["messages"], MESSAGE_KEYS, "message_id", f"{path}.messages", issues)
    if not 8 <= len(messages) <= 14:
        _issue(issues, "CORPUS_BUBBLE_BOUND", f"{path}.messages", "8 à 14 bulles requises")
    if messages and messages[0]["speaker_id"] != "player":
        _issue(issues, "CORPUS_PLAYER_REOPENING_REQUIRED", f"{path}.messages[0].speaker_id", "player")
    if messages and not any(message["speaker_id"] == document["active_character_id"] for message in messages):
        _issue(issues, "ACTIVE_VOICE_MISSING", f"{path}.messages", document["active_character_id"])
    for index, message in enumerate(messages):
        message_path = f"{path}.messages[{index}]"
        if not _nonempty(message["speaker_id"]) or not _nonempty(message["text"]):
            _issue(issues, "MESSAGE_INVALID", message_path, "locuteur et texte requis")
        _string_list(message["fact_refs"], f"{message_path}.fact_refs", issues)
        _string_list(message["movement_refs"], f"{message_path}.movement_refs", issues, nonempty=True)
    message_ids = {message["message_id"] for message in messages}
    for index, item in enumerate(evidence):
        for message_id in item["message_ids"]:
            if message_id not in message_ids:
                _issue(issues, "VOICE_EVIDENCE_MESSAGE_UNKNOWN", f"{path}.voice_evidence[{index}].message_ids", message_id)
    return issues


def validate_compatibility(
    case: Mapping[str, Any],
    character: Mapping[str, Any],
    relationship_document: Mapping[str, Any],
) -> list[Issue]:
    issues: list[Issue] = []
    relation = relationship_document["relationship"]
    character_id = character["character_id"]
    if case["active_character_id"] != character_id:
        _issue(issues, "ACTIVE_CHARACTER_MISMATCH", "case.active_character_id", character_id)
    if case["active_relationship_id"] != relation["relationship_id"]:
        _issue(issues, "ACTIVE_RELATIONSHIP_MISMATCH", "case.active_relationship_id", relation["relationship_id"])
    if character_id not in relation["participant_ids"] or "player" not in relation["participant_ids"]:
        _issue(issues, "ACTIVE_PAIR_MISMATCH", "relationship.participant_ids", character_id)

    for index, item in enumerate(case["voice_evidence"]):
        available = character["voice"].get(item["rule_group"], [])
        if item["rule_text"] not in available:
            _issue(
                issues,
                "VOICE_RULE_INCOMPATIBLE",
                f"case.voice_evidence[{index}].rule_text",
                item["rule_text"],
            )

    facts = {fact["fact_id"]: fact for fact in relation["shared_facts"]}
    character_fact_ids = {fact["fact_id"] for fact in character["known_facts"]}
    limits = {limit["limit_id"]: limit for limit in relation["limits"]}
    movements = {movement["movement_id"]: movement for movement in relation["movements"]}
    states = {state["state_id"]: state for state in relation["local_states"]}
    for index, fact_id in enumerate(case["useful_fact_ids"]):
        if fact_id not in facts or character_id not in facts[fact_id]["known_by"]:
            _issue(issues, "FACT_UNAVAILABLE", f"case.useful_fact_ids[{index}]", fact_id)
        elif fact_id not in character_fact_ids:
            _issue(issues, "FACT_OUTSIDE_CHARACTER_CONTRACT", f"case.useful_fact_ids[{index}]", fact_id)
    for index, limit_id in enumerate(case["useful_limit_ids"]):
        if limit_id not in limits:
            _issue(issues, "LIMIT_INCOMPATIBLE", f"case.useful_limit_ids[{index}]", limit_id)
    for index, movement_id in enumerate(case["expected_movement_ids"]):
        if movement_id not in movements:
            _issue(issues, "MOVEMENT_INCOMPATIBLE", f"case.expected_movement_ids[{index}]", movement_id)

    state = states.get(case["local_state_id"])
    if state is None:
        _issue(issues, "LOCAL_STATE_INCOMPATIBLE", "case.local_state_id", case["local_state_id"])
    else:
        for movement_id in state["movement_ids"]:
            if movement_id not in case["expected_movement_ids"]:
                _issue(issues, "STATE_MOVEMENT_MISSING", "case.expected_movement_ids", movement_id)

    expected_movements = set(case["expected_movement_ids"])
    useful_facts = set(case["useful_fact_ids"])
    useful_limits = set(case["useful_limit_ids"])
    for movement_id in expected_movements:
        movement = movements.get(movement_id)
        if movement is None:
            continue
        for limit_id in movement["requires_limit_ids"]:
            if limit_id not in useful_limits:
                _issue(issues, "MOVEMENT_REQUIRED_LIMIT_MISSING", "case.useful_limit_ids", f"{movement_id}: {limit_id}")

    allowed_speakers = set(relation["participant_ids"])
    for index, message in enumerate(case["messages"]):
        message_path = f"case.messages[{index}]"
        if message["speaker_id"] not in allowed_speakers:
            _issue(issues, "MESSAGE_SPEAKER_INCOMPATIBLE", f"{message_path}.speaker_id", message["speaker_id"])
        for fact_id in message["fact_refs"]:
            if fact_id not in useful_facts or fact_id not in facts:
                _issue(issues, "MESSAGE_FACT_INCOMPATIBLE", f"{message_path}.fact_refs", fact_id)
        for movement_id in message["movement_refs"]:
            movement = movements.get(movement_id)
            if movement_id not in expected_movements or movement is None:
                _issue(issues, "MESSAGE_MOVEMENT_INCOMPATIBLE", f"{message_path}.movement_refs", movement_id)
            elif movement["actor_id"] != message["speaker_id"]:
                _issue(issues, "MESSAGE_MOVEMENT_ACTOR_MISMATCH", f"{message_path}.movement_refs", movement_id)
    return issues


def _read_json(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise A112CalibrationError([Issue("JSON_READ_FAILED", str(path), str(exc))]) from exc
    if not isinstance(value, dict):
        raise A112CalibrationError([Issue("JSON_OBJECT_REQUIRED", str(path), "racine objet attendue")])
    return value


def case_paths(name: str) -> dict[str, Path]:
    if name not in CASE_NAMES:
        raise A112CalibrationError([Issue("CASE_UNKNOWN", "name", name)])
    return {
        "character": CALIBRATION_DIR / "contracts" / f"{name}.json",
        "relationship": CALIBRATION_DIR / "registers" / f"player_{name}.json",
        "case": CALIBRATION_DIR / "corpora" / f"{name}.json",
    }


def load_case(name: str) -> dict[str, Any]:
    paths = case_paths(name)
    workspace = {key: _read_json(path) for key, path in paths.items()}
    issues: list[Issue] = []
    issues.extend(validate_character(workspace["character"], "character"))
    issues.extend(validate_relationship_calibration(workspace["relationship"], "relationship"))
    issues.extend(validate_calibration_case(workspace["case"], "case"))
    if not issues:
        issues.extend(validate_compatibility(workspace["case"], workspace["character"], workspace["relationship"]))
    if issues:
        raise A112CalibrationError(issues)
    return workspace


def compile_minimal_context(workspace: Mapping[str, Any], local_state_id: str | None = None) -> str:
    character = workspace["character"]
    relation = workspace["relationship"]["relationship"]
    case = workspace["case"]
    state_id = local_state_id or case["local_state_id"]
    states = {state["state_id"]: state for state in relation["local_states"]}
    if state_id not in states:
        raise A112CalibrationError([Issue("LOCAL_STATE_UNKNOWN", "local_state_id", state_id)])
    state = states[state_id]
    fact_ids = set(case["useful_fact_ids"])
    limit_ids = set(case["useful_limit_ids"])
    movement_ids = set(state["movement_ids"] if local_state_id is not None else case["expected_movement_ids"])
    active_character = {
        "character_id": character["character_id"],
        "display_name": character["display_name"],
        "role": character["role"],
        "voice": character["voice"],
    }
    active_relation = {
        "relationship_id": relation["relationship_id"],
        "participant_ids": relation["participant_ids"],
        "nature": relation["nature"],
    }
    sections = [
        "# A11.2 minimal calibration context",
        "## active_character",
        _canonical(active_character),
        "## active_player_relationship",
        _canonical(active_relation),
        "## local_state",
        _canonical(state),
        "## useful_facts",
        _canonical([fact for fact in relation["shared_facts"] if fact["fact_id"] in fact_ids]),
        "## useful_limits",
        _canonical([limit for limit in relation["limits"] if limit["limit_id"] in limit_ids]),
        "## expected_movements",
        _canonical([movement for movement in relation["movements"] if movement["movement_id"] in movement_ids]),
    ]
    return "\n".join(sections) + "\n"


def validate_json_library() -> dict[str, Any]:
    cases = {name: load_case(name) for name in CASE_NAMES}
    return {
        "ok": True,
        "formats": [FORMAT_RELATIONSHIP_CALIBRATION, FORMAT_VOICE_CALIBRATION_CASE],
        "cases": list(cases),
    }


def cross_validate_library() -> dict[str, Any]:
    workspaces = {name: load_case(name) for name in CASE_NAMES}
    result: dict[str, Any] = {}
    for source_name, source in workspaces.items():
        targets: dict[str, Any] = {}
        for target_name, target in workspaces.items():
            issues = validate_compatibility(source["case"], target["character"], target["relationship"])
            targets[target_name] = {
                "compatible": not issues,
                "issues": [issue.as_json() for issue in issues],
            }
        result[source_name] = targets
    return result


def run_smoke() -> dict[str, Any]:
    workspaces = {name: load_case(name) for name in CASE_NAMES}
    cross_validation = cross_validate_library()
    context_digests: dict[str, str] = {}
    for name, workspace in workspaces.items():
        context = compile_minimal_context(workspace)
        if context != compile_minimal_context(workspace):
            raise AssertionError(f"contexte non déterministe: {name}")
        if cross_validation[name][name]["issues"]:
            raise AssertionError(f"contrat propre rejeté: {name}")
        foreign = [
            target for target in CASE_NAMES
            if target != name and cross_validation[name][target]["issues"]
        ]
        if not foreign:
            raise AssertionError(f"aucun contrat étranger ne rejette: {name}")
        context_digests[name] = hashlib.sha256(context.encode("utf-8")).hexdigest()
    foreign_alerts: dict[str, Any] = {}
    preferred_codes = {
        "VOICE_RULE_INCOMPATIBLE",
        "FACT_UNAVAILABLE",
        "LIMIT_INCOMPATIBLE",
        "MOVEMENT_INCOMPATIBLE",
        "LOCAL_STATE_INCOMPATIBLE",
    }
    for source_name in CASE_NAMES:
        foreign_alerts[source_name] = {}
        for target_name in CASE_NAMES:
            if source_name == target_name:
                continue
            causes: list[dict[str, str]] = []
            seen_codes: set[str] = set()
            for issue in cross_validation[source_name][target_name]["issues"]:
                if issue["code"] in preferred_codes and issue["code"] not in seen_codes:
                    causes.append(issue)
                    seen_codes.add(issue["code"])
            foreign_alerts[source_name][target_name] = causes
    return {
        "ok": True,
        "cases": list(workspaces),
        "context_sha256": context_digests,
        "foreign_contract_alerts": foreign_alerts,
    }


def _emit(value: Any) -> None:
    print(json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True))


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Calibration relationnelle hors ligne R8C-A11.2")
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("validate-json")
    context_parser = subparsers.add_parser("context")
    context_parser.add_argument("case", choices=CASE_NAMES)
    subparsers.add_parser("cross-validate")
    subparsers.add_parser("smoke")
    args = parser.parse_args(argv)
    try:
        if args.command == "validate-json":
            _emit(validate_json_library())
        elif args.command == "context":
            print(compile_minimal_context(load_case(args.case)), end="")
        elif args.command == "cross-validate":
            _emit(cross_validate_library())
        else:
            _emit(run_smoke())
    except (A112CalibrationError, AssertionError) as exc:
        print(f"A11.2_ERROR: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
