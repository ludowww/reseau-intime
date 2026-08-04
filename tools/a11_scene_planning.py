#!/usr/bin/env python3
"""Offline A11.3 assisted scene planning, bounded to one Sandra prototype."""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import re
import sys
from pathlib import Path
from typing import Any, Mapping, Sequence

try:
    from tools.a11_authoring_workshop import Issue
    from tools.a11_voice_calibration import CASE_NAMES, load_case as load_calibration_case
except ModuleNotFoundError:  # Direct execution from tools/.
    from a11_authoring_workshop import Issue
    from a11_voice_calibration import CASE_NAMES, load_case as load_calibration_case


ROOT = Path(__file__).resolve().parents[1]
PLANNING_DIR = ROOT / "narrative_tool" / "a11" / "planning"
DEFAULT_CASE_PATH = PLANNING_DIR / "sandra_recontact_after_silence.json"

FORMAT_ASSISTED_SCENE_PLANNING = "R8C_A11_ASSISTED_SCENE_PLANNING"
VERSION = 1
VALIDATOR_VERSION = "a11-planning-validator-1.0"

ACTIVE_PARTICIPANTS = {"player", "sandra"}
MANDATORY_DECISION_IDS = (
    "select_concrete_hook",
    "select_maximum_change",
    "select_choice_mode",
)
DECISION_PLAN_VALUES = {
    "select_concrete_hook": lambda plan: plan["hook"]["selection_option_id"],
    "select_maximum_change": lambda plan: plan["maximum_change"]["outcome_id"],
    "select_choice_mode": lambda plan: plan["choice_mode"],
}
ALLOWED_OUTCOMES = {
    "recontact",
    "possible_meeting",
    "small_importance_confirmation",
    "deferred_opening",
    "distance_reaffirmed_without_break",
}
FORBIDDEN_OUTCOMES = {
    "romantic_declaration",
    "mutual_desire_recognized",
    "direct_jealousy",
    "break_with_marie",
    "locked_route",
    "acquired_intimacy",
    "automatic_durable_consequence",
}
REVIEW_STATUSES = {
    "DRAFT",
    "NEEDS_REVISION",
    "APPROVED_FOR_DRAFT_GENERATION",
    "REJECTED",
}
SPECIFICITY_CODES = {
    "RELATIONSHIP_MEMORY_INCOMPATIBLE",
    "DEFLECTION_STRATEGY_INCOMPATIBLE",
    "PROXIMITY_NATURE_INCOMPATIBLE",
    "RELATIONSHIP_LIMIT_INCOMPATIBLE",
    "RELATIONSHIP_MOVEMENT_INCOMPATIBLE",
}

ROOT_KEYS = {
    "format",
    "version",
    "case_id",
    "active_character_id",
    "active_relationship_id",
    "intention",
    "diagnostic",
    "human_selection",
    "plan",
    "human_review",
}
INTENTION_KEYS = {
    "author_text",
    "active_participant_ids",
    "contextual_character_ids",
    "desired_motion",
    "indirectness_constraint",
}
DIAGNOSTIC_KEYS = {
    "present_information",
    "selectable_information_gaps",
    "mandatory_human_decision_ids",
}
INFORMATION_KEYS = {"information_id", "text", "source_refs"}
GAP_KEYS = {"decision_id", "question", "options"}
OPTION_KEYS = {"option_id", "label", "plan_value", "effect"}
SELECTION_KEYS = {"selected_by", "decisions"}
SELECTION_ITEM_KEYS = {"decision_id", "selected_option_id"}
PLAN_KEYS = {
    "plan_id",
    "title",
    "participant_ids",
    "relationship_id",
    "relationship_nature",
    "hook",
    "objectives",
    "local_risk",
    "maximum_change",
    "fact_policy",
    "initial_state_id",
    "required_limit_ids",
    "movement_ids",
    "beats",
    "choice_mode",
    "choice",
    "expected_reception",
    "cautious_opening",
    "protective_close",
    "media_requirement",
    "planned_outcome_ids",
}
HOOK_KEYS = {"selection_option_id", "fact_id", "description", "concrete"}
OBJECTIVE_KEYS = {"actor_id", "intent", "method"}
MAXIMUM_CHANGE_KEYS = {"selection_option_id", "outcome_id", "description"}
FACT_POLICY_KEYS = {"usable_fact_ids", "forbidden_fact_ids"}
BEAT_KEYS = {"beat_id", "function", "driver_id", "summary", "movement_refs", "fact_refs"}
CHOICE_KEYS = {"choice_id", "after_beat_id", "focus", "options", "receptions"}
CHOICE_OPTION_KEYS = {"option_id", "attitude"}
RECEPTION_KEYS = {"option_id", "character_id", "description", "movement_refs"}
EXPECTED_RECEPTION_KEYS = {"character_id", "description", "movement_refs"}
PROTECTIVE_CLOSE_KEYS = {"description", "protects", "punitive"}
MEDIA_KEYS = {"required", "kind", "linked_fact_id", "justification"}
REVIEW_KEYS = {"status", "reviewed_by", "plan_fingerprint", "notes"}


class A113PlanningError(ValueError):
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
    actual = set(value)
    if actual != keys:
        _issue(
            issues,
            "CLOSED_SCHEMA_MISMATCH",
            path,
            f"champs manquants={sorted(keys - actual)}; champs inconnus={sorted(actual - keys)}",
        )
        return False
    return True


def _string_list(
    value: Any,
    path: str,
    issues: list[Issue],
    *,
    nonempty: bool = False,
) -> bool:
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
    value: Any,
    keys: set[str],
    identity_key: str,
    path: str,
    issues: list[Issue],
    *,
    nonempty: bool = False,
) -> list[dict[str, Any]]:
    if not isinstance(value, list) or (nonempty and not value):
        _issue(issues, "OBJECT_LIST_REQUIRED", path, "tableau d'objets attendu")
        return []
    valid: list[dict[str, Any]] = []
    identities: set[str] = set()
    for index, item in enumerate(value):
        item_path = f"{path}[{index}]"
        if not _closed(item, keys, item_path, issues):
            continue
        identity = item[identity_key]
        if not _nonempty(identity):
            _issue(issues, "TEXT_REQUIRED", f"{item_path}.{identity_key}", "identité requise")
        elif identity in identities:
            _issue(issues, "IDENTITY_DUPLICATE", f"{item_path}.{identity_key}", identity)
        else:
            identities.add(identity)
        valid.append(item)
    return valid


def planning_fingerprint(document: Mapping[str, Any]) -> str:
    reviewed_content = {
        "case_id": document["case_id"],
        "intention": document["intention"],
        "diagnostic": document["diagnostic"],
        "human_selection": document["human_selection"],
        "plan": document["plan"],
        "validator_version": VALIDATOR_VERSION,
    }
    return hashlib.sha256(_canonical(reviewed_content).encode("utf-8")).hexdigest()


def validate_planning_case(document: Any, path: str = "case") -> list[Issue]:
    issues: list[Issue] = []
    if not _closed(document, ROOT_KEYS, path, issues):
        return issues
    if document["format"] != FORMAT_ASSISTED_SCENE_PLANNING:
        _issue(issues, "FORMAT_UNKNOWN", f"{path}.format", FORMAT_ASSISTED_SCENE_PLANNING)
    if type(document["version"]) is not int or document["version"] != VERSION:
        _issue(issues, "VERSION_UNKNOWN", f"{path}.version", str(VERSION))
    for field in ("case_id", "active_character_id", "active_relationship_id"):
        if not _nonempty(document[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.{field}", "chaîne non vide attendue")

    intention = document["intention"]
    if _closed(intention, INTENTION_KEYS, f"{path}.intention", issues):
        for field in ("author_text", "desired_motion", "indirectness_constraint"):
            if not _nonempty(intention[field]):
                _issue(issues, "TEXT_REQUIRED", f"{path}.intention.{field}", "texte requis")
        _string_list(
            intention["active_participant_ids"],
            f"{path}.intention.active_participant_ids",
            issues,
            nonempty=True,
        )
        _string_list(
            intention["contextual_character_ids"],
            f"{path}.intention.contextual_character_ids",
            issues,
        )

    diagnostic = document["diagnostic"]
    if _closed(diagnostic, DIAGNOSTIC_KEYS, f"{path}.diagnostic", issues):
        information = _unique_objects(
            diagnostic["present_information"],
            INFORMATION_KEYS,
            "information_id",
            f"{path}.diagnostic.present_information",
            issues,
            nonempty=True,
        )
        for index, item in enumerate(information):
            if not _nonempty(item["text"]):
                _issue(issues, "TEXT_REQUIRED", f"{path}.diagnostic.present_information[{index}].text", "texte requis")
            _string_list(
                item["source_refs"],
                f"{path}.diagnostic.present_information[{index}].source_refs",
                issues,
                nonempty=True,
            )
        gaps = _unique_objects(
            diagnostic["selectable_information_gaps"],
            GAP_KEYS,
            "decision_id",
            f"{path}.diagnostic.selectable_information_gaps",
            issues,
            nonempty=True,
        )
        for gap_index, gap in enumerate(gaps):
            gap_path = f"{path}.diagnostic.selectable_information_gaps[{gap_index}]"
            if not _nonempty(gap["question"]):
                _issue(issues, "TEXT_REQUIRED", f"{gap_path}.question", "question requise")
            options = _unique_objects(
                gap["options"], OPTION_KEYS, "option_id", f"{gap_path}.options", issues, nonempty=True
            )
            if len(options) > 3:
                _issue(issues, "BOUNDED_OPTIONS_EXCEEDED", f"{gap_path}.options", "trois options maximum")
            for option_index, option in enumerate(options):
                option_path = f"{gap_path}.options[{option_index}]"
                for field in ("label", "plan_value", "effect"):
                    if not _nonempty(option[field]):
                        _issue(issues, "TEXT_REQUIRED", f"{option_path}.{field}", "texte requis")
        if _string_list(
            diagnostic["mandatory_human_decision_ids"],
            f"{path}.diagnostic.mandatory_human_decision_ids",
            issues,
            nonempty=True,
        ):
            decision_ids = {gap["decision_id"] for gap in gaps}
            if set(diagnostic["mandatory_human_decision_ids"]) != decision_ids:
                _issue(
                    issues,
                    "MANDATORY_DECISIONS_MISMATCH",
                    f"{path}.diagnostic.mandatory_human_decision_ids",
                    "toute information sélectionnable exige une décision humaine",
                )
            if tuple(diagnostic["mandatory_human_decision_ids"]) != MANDATORY_DECISION_IDS:
                _issue(
                    issues,
                    "PROTOTYPE_DECISIONS_MISMATCH",
                    f"{path}.diagnostic.mandatory_human_decision_ids",
                    "les trois décisions du prototype sont requises dans l'ordre auteur",
                )

    selection = document["human_selection"]
    if _closed(selection, SELECTION_KEYS, f"{path}.human_selection", issues):
        if not _nonempty(selection["selected_by"]):
            _issue(issues, "HUMAN_SELECTION_REQUIRED", f"{path}.human_selection.selected_by", "identité humaine requise")
        decisions = _unique_objects(
            selection["decisions"],
            SELECTION_ITEM_KEYS,
            "decision_id",
            f"{path}.human_selection.decisions",
            issues,
            nonempty=True,
        )
        for index, decision in enumerate(decisions):
            if not _nonempty(decision["selected_option_id"]):
                _issue(issues, "HUMAN_SELECTION_REQUIRED", f"{path}.human_selection.decisions[{index}]", "option humaine requise")

    _validate_plan_shape(document["plan"], f"{path}.plan", issues)
    _validate_review_shape(document["human_review"], f"{path}.human_review", issues)
    return issues


def _validate_plan_shape(plan: Any, path: str, issues: list[Issue]) -> None:
    if not _closed(plan, PLAN_KEYS, path, issues):
        return
    for field in ("plan_id", "title", "relationship_id", "relationship_nature", "local_risk", "initial_state_id", "cautious_opening"):
        if not isinstance(plan[field], str):
            _issue(issues, "TEXT_TYPE_REQUIRED", f"{path}.{field}", "chaîne attendue")
    _string_list(plan["participant_ids"], f"{path}.participant_ids", issues, nonempty=True)
    _string_list(plan["required_limit_ids"], f"{path}.required_limit_ids", issues, nonempty=True)
    _string_list(plan["movement_ids"], f"{path}.movement_ids", issues, nonempty=True)
    _string_list(plan["planned_outcome_ids"], f"{path}.planned_outcome_ids", issues, nonempty=True)

    hook = plan["hook"]
    if _closed(hook, HOOK_KEYS, f"{path}.hook", issues):
        for field in ("selection_option_id", "fact_id", "description"):
            if not isinstance(hook[field], str):
                _issue(issues, "TEXT_TYPE_REQUIRED", f"{path}.hook.{field}", "chaîne attendue")
        if type(hook["concrete"]) is not bool:
            _issue(issues, "BOOLEAN_REQUIRED", f"{path}.hook.concrete", "booléen attendu")

    objectives = _unique_objects(
        plan["objectives"], OBJECTIVE_KEYS, "actor_id", f"{path}.objectives", issues
    )
    for index, objective in enumerate(objectives):
        for field in ("intent", "method"):
            if not isinstance(objective[field], str):
                _issue(issues, "TEXT_TYPE_REQUIRED", f"{path}.objectives[{index}].{field}", "chaîne attendue")

    maximum = plan["maximum_change"]
    if _closed(maximum, MAXIMUM_CHANGE_KEYS, f"{path}.maximum_change", issues):
        for field in MAXIMUM_CHANGE_KEYS:
            if not isinstance(maximum[field], str):
                _issue(issues, "TEXT_TYPE_REQUIRED", f"{path}.maximum_change.{field}", "chaîne attendue")

    facts = plan["fact_policy"]
    if _closed(facts, FACT_POLICY_KEYS, f"{path}.fact_policy", issues):
        _string_list(facts["usable_fact_ids"], f"{path}.fact_policy.usable_fact_ids", issues, nonempty=True)
        _string_list(facts["forbidden_fact_ids"], f"{path}.fact_policy.forbidden_fact_ids", issues, nonempty=True)

    beats = _unique_objects(plan["beats"], BEAT_KEYS, "beat_id", f"{path}.beats", issues)
    for index, beat in enumerate(beats):
        for field in ("function", "driver_id", "summary"):
            if not isinstance(beat[field], str):
                _issue(issues, "TEXT_TYPE_REQUIRED", f"{path}.beats[{index}].{field}", "chaîne attendue")
        _string_list(beat["movement_refs"], f"{path}.beats[{index}].movement_refs", issues, nonempty=True)
        _string_list(beat["fact_refs"], f"{path}.beats[{index}].fact_refs", issues)

    if plan["choice_mode"] not in {"NONE", "ONE"}:
        _issue(issues, "CHOICE_MODE_UNKNOWN", f"{path}.choice_mode", "NONE ou ONE attendu")
    if plan["choice"] is not None:
        _validate_choice_shape(plan["choice"], f"{path}.choice", issues)

    reception = plan["expected_reception"]
    if _closed(reception, EXPECTED_RECEPTION_KEYS, f"{path}.expected_reception", issues):
        for field in ("character_id", "description"):
            if not isinstance(reception[field], str):
                _issue(issues, "TEXT_TYPE_REQUIRED", f"{path}.expected_reception.{field}", "chaîne attendue")
        _string_list(reception["movement_refs"], f"{path}.expected_reception.movement_refs", issues, nonempty=True)

    close = plan["protective_close"]
    if _closed(close, PROTECTIVE_CLOSE_KEYS, f"{path}.protective_close", issues):
        for field in ("description", "protects"):
            if not isinstance(close[field], str):
                _issue(issues, "TEXT_TYPE_REQUIRED", f"{path}.protective_close.{field}", "chaîne attendue")
        if type(close["punitive"]) is not bool:
            _issue(issues, "BOOLEAN_REQUIRED", f"{path}.protective_close.punitive", "booléen attendu")

    media = plan["media_requirement"]
    if _closed(media, MEDIA_KEYS, f"{path}.media_requirement", issues):
        if type(media["required"]) is not bool:
            _issue(issues, "BOOLEAN_REQUIRED", f"{path}.media_requirement.required", "booléen attendu")
        for field in ("kind", "linked_fact_id", "justification"):
            if media[field] is not None and not isinstance(media[field], str):
                _issue(issues, "OPTIONAL_TEXT_INVALID", f"{path}.media_requirement.{field}", "chaîne ou null attendu")


def _validate_choice_shape(choice: Any, path: str, issues: list[Issue]) -> None:
    if not _closed(choice, CHOICE_KEYS, path, issues):
        return
    for field in ("choice_id", "after_beat_id", "focus"):
        if not isinstance(choice[field], str):
            _issue(issues, "TEXT_TYPE_REQUIRED", f"{path}.{field}", "chaîne attendue")
    options = _unique_objects(choice["options"], CHOICE_OPTION_KEYS, "option_id", f"{path}.options", issues)
    if len(options) > 3:
        _issue(issues, "CHOICE_OPTIONS_EXCEEDED", f"{path}.options", "trois options maximum")
    for index, option in enumerate(options):
        if not isinstance(option["attitude"], str):
            _issue(issues, "TEXT_TYPE_REQUIRED", f"{path}.options[{index}].attitude", "chaîne attendue")
    receptions = _unique_objects(
        choice["receptions"], RECEPTION_KEYS, "option_id", f"{path}.receptions", issues
    )
    for index, reception in enumerate(receptions):
        for field in ("character_id", "description"):
            if not isinstance(reception[field], str):
                _issue(issues, "TEXT_TYPE_REQUIRED", f"{path}.receptions[{index}].{field}", "chaîne attendue")
        _string_list(reception["movement_refs"], f"{path}.receptions[{index}].movement_refs", issues, nonempty=True)


def _validate_review_shape(review: Any, path: str, issues: list[Issue]) -> None:
    if not _closed(review, REVIEW_KEYS, path, issues):
        return
    if review["status"] not in REVIEW_STATUSES:
        _issue(issues, "REVIEW_STATUS_UNKNOWN", f"{path}.status", str(review["status"]))
    for field in ("reviewed_by", "plan_fingerprint"):
        if review[field] is not None and not isinstance(review[field], str):
            _issue(issues, "OPTIONAL_TEXT_INVALID", f"{path}.{field}", "chaîne ou null attendu")
    _string_list(review["notes"], f"{path}.notes", issues)


def validate_human_selection(document: Mapping[str, Any]) -> list[Issue]:
    issues: list[Issue] = []
    diagnostic = document["diagnostic"]
    selection = document["human_selection"]
    if not _nonempty(selection.get("selected_by")):
        _issue(issues, "HUMAN_SELECTION_REQUIRED", "human_selection.selected_by", "identité humaine requise")
    gaps = {gap["decision_id"]: gap for gap in diagnostic["selectable_information_gaps"]}
    selections = selection.get("decisions", [])
    selected_ids = [item.get("decision_id") for item in selections if isinstance(item, dict)]
    required = diagnostic["mandatory_human_decision_ids"]
    if selected_ids != required:
        _issue(
            issues,
            "HUMAN_SELECTION_INCOMPLETE",
            "human_selection.decisions",
            "une sélection humaine est requise, dans l'ordre auteur, pour chaque décision",
        )
        return issues
    for index, item in enumerate(selections):
        gap = gaps.get(item["decision_id"])
        option_ids = [option["option_id"] for option in gap["options"]] if gap else []
        if item["selected_option_id"] not in option_ids:
            _issue(
                issues,
                "SELECTED_OPTION_UNKNOWN",
                f"human_selection.decisions[{index}].selected_option_id",
                item["selected_option_id"],
            )
    return issues


def _selected_plan_values(document: Mapping[str, Any]) -> dict[str, str]:
    gaps = {
        gap["decision_id"]: gap
        for gap in document["diagnostic"]["selectable_information_gaps"]
    }
    values: dict[str, str] = {}
    for selection in document["human_selection"]["decisions"]:
        gap = gaps.get(selection["decision_id"])
        if gap is None:
            continue
        option = next(
            (item for item in gap["options"] if item["option_id"] == selection["selected_option_id"]),
            None,
        )
        if option is not None:
            values[selection["decision_id"]] = option["plan_value"]
    return values


def validate_plan_against_relationship(
    plan: Mapping[str, Any], relationship_document: Mapping[str, Any]
) -> list[Issue]:
    issues: list[Issue] = []
    relation = relationship_document["relationship"]
    facts = {item["fact_id"] for item in relation["shared_facts"]}
    limits = {item["limit_id"] for item in relation["limits"]}
    movements = {item["movement_id"] for item in relation["movements"]}
    states = {item["state_id"]: item for item in relation["local_states"]}

    for fact_id in plan["fact_policy"]["usable_fact_ids"]:
        if fact_id not in facts:
            _issue(issues, "RELATIONSHIP_MEMORY_INCOMPATIBLE", "plan.fact_policy.usable_fact_ids", fact_id)
    state = states.get(plan["initial_state_id"])
    if state is None:
        _issue(issues, "DEFLECTION_STRATEGY_INCOMPATIBLE", "plan.initial_state_id", plan["initial_state_id"])
    elif not set(state["movement_ids"]).issubset(plan["movement_ids"]):
        _issue(issues, "DEFLECTION_STRATEGY_INCOMPATIBLE", "plan.movement_ids", state["strategy"])
    if plan["relationship_nature"] != relation["nature"]:
        _issue(issues, "PROXIMITY_NATURE_INCOMPATIBLE", "plan.relationship_nature", relation["nature"])
    for limit_id in plan["required_limit_ids"]:
        if limit_id not in limits:
            _issue(issues, "RELATIONSHIP_LIMIT_INCOMPATIBLE", "plan.required_limit_ids", limit_id)
    for movement_id in plan["movement_ids"]:
        if movement_id not in movements:
            _issue(issues, "RELATIONSHIP_MOVEMENT_INCOMPATIBLE", "plan.movement_ids", movement_id)
    return issues


def _contains_final_dialogue(text: str) -> bool:
    if not isinstance(text, str):
        return False
    return bool(
        re.search(r"[«»\"“”]", text)
        or re.search(r"\b(?:player|sandra|marie|mathilde)\s*[:—-]", text, re.IGNORECASE)
        or re.search(r"(?:^|\n)\s*[—-]\s+\S", text)
        or re.search(r"(?<!-)\b(?:je|tu|toi|te|nous|vous)\b", text, re.IGNORECASE)
        or re.search(r"(?:^|\s)(?:j|t)['’]\w+", text, re.IGNORECASE)
    )


def _plan_texts(plan: Mapping[str, Any]) -> list[tuple[str, str]]:
    texts = [
        ("plan.title", plan["title"]),
        ("plan.relationship_nature", plan["relationship_nature"]),
        ("plan.hook.description", plan["hook"]["description"]),
        ("plan.local_risk", plan["local_risk"]),
        ("plan.maximum_change.description", plan["maximum_change"]["description"]),
        ("plan.cautious_opening", plan["cautious_opening"]),
        ("plan.protective_close.description", plan["protective_close"]["description"]),
    ]
    for index, objective in enumerate(plan["objectives"]):
        texts.extend(
            (
                (f"plan.objectives[{index}].intent", objective["intent"]),
                (f"plan.objectives[{index}].method", objective["method"]),
            )
        )
    for index, beat in enumerate(plan["beats"]):
        texts.append((f"plan.beats[{index}].summary", beat["summary"]))
    choice = plan["choice"]
    if isinstance(choice, dict):
        texts.append(("plan.choice.focus", choice["focus"]))
        for index, option in enumerate(choice["options"]):
            texts.append((f"plan.choice.options[{index}].attitude", option["attitude"]))
        for index, reception in enumerate(choice["receptions"]):
            texts.append((f"plan.choice.receptions[{index}].description", reception["description"]))
    return texts


def validate_scene_plan(
    document: Mapping[str, Any],
    calibration_workspace: Mapping[str, Any],
    foreign_workspaces: Mapping[str, Mapping[str, Any]] | None = None,
) -> dict[str, Any]:
    plan = document["plan"]
    relation = calibration_workspace["relationship"]["relationship"]
    relation_movements = {item["movement_id"]: item for item in relation["movements"]}
    errors: list[Issue] = []
    warnings: list[Issue] = []

    errors.extend(validate_human_selection(document))
    selected_values = _selected_plan_values(document)
    selected_option_ids = {
        item["decision_id"]: item["selected_option_id"]
        for item in document["human_selection"]["decisions"]
        if isinstance(item, dict) and "decision_id" in item and "selected_option_id" in item
    }
    for decision_id in MANDATORY_DECISION_IDS:
        if decision_id not in selected_values:
            _issue(errors, "HUMAN_SELECTION_INCOMPLETE", "human_selection.decisions", decision_id)
            continue
        actual = DECISION_PLAN_VALUES[decision_id](plan)
        if actual != selected_values[decision_id]:
            _issue(
                errors,
                "PLAN_SELECTION_MISMATCH",
                f"plan.{decision_id}",
                f"attendu={selected_values[decision_id]}; reçu={actual}",
            )
    bound_selection_ids = {
        "select_concrete_hook": plan["hook"]["selection_option_id"],
        "select_maximum_change": plan["maximum_change"]["selection_option_id"],
    }
    for decision_id, actual_option_id in bound_selection_ids.items():
        expected_option_id = selected_option_ids.get(decision_id)
        if expected_option_id is not None and actual_option_id != expected_option_id:
            _issue(
                errors,
                "PLAN_SELECTION_MISMATCH",
                f"plan.{decision_id}.selection_option_id",
                f"attendu={expected_option_id}; reçu={actual_option_id}",
            )

    if set(plan["participant_ids"]) != ACTIVE_PARTICIPANTS:
        _issue(errors, "UNEXPECTED_PARTICIPANT", "plan.participant_ids", "Sandra et Player uniquement")
    if set(document["intention"]["active_participant_ids"]) != ACTIVE_PARTICIPANTS:
        _issue(errors, "UNEXPECTED_PARTICIPANT", "intention.active_participant_ids", "Sandra et Player uniquement")
    if document["active_character_id"] != "sandra":
        _issue(errors, "UNEXPECTED_PARTICIPANT", "active_character_id", document["active_character_id"])
    unexpected_context = set(document["intention"]["contextual_character_ids"]) - {"marie"}
    if unexpected_context:
        _issue(errors, "UNEXPECTED_PARTICIPANT", "intention.contextual_character_ids", ", ".join(sorted(unexpected_context)))
    if "marie" in plan["participant_ids"]:
        _issue(errors, "CONTEXTUAL_CHARACTER_ACTIVATED", "plan.participant_ids", "Marie reste contextuelle")
    if document["active_relationship_id"] != relation["relationship_id"] or plan["relationship_id"] != relation["relationship_id"]:
        _issue(errors, "RELATIONSHIP_REGISTER_MISSING", "plan.relationship_id", relation["relationship_id"])
    errors.extend(validate_plan_against_relationship(plan, calibration_workspace["relationship"]))

    objectives = {item["actor_id"]: item for item in plan["objectives"]}
    for actor_id in sorted(set(objectives) - ACTIVE_PARTICIPANTS):
        _issue(errors, "UNEXPECTED_PARTICIPANT", "plan.objectives", actor_id)
    for participant_id in ACTIVE_PARTICIPANTS:
        objective = objectives.get(participant_id)
        if objective is None or not _nonempty(objective["intent"]) or not _nonempty(objective["method"]):
            _issue(errors, "OBJECTIVE_MISSING", "plan.objectives", participant_id)
    if len(objectives) != len(plan["objectives"]):
        _issue(errors, "OBJECTIVE_DUPLICATE", "plan.objectives", "un objectif par participant")
    if len(objectives) == 2:
        signatures = {
            (item["intent"].casefold(), item["method"].casefold())
            for item in objectives.values()
        }
        if len(signatures) == 1:
            _issue(warnings, "OBJECTIVES_SYMMETRIC", "plan.objectives", "objectifs asymétriques attendus")

    beats = plan["beats"]
    if not 5 <= len(beats) <= 7:
        _issue(errors, "BEAT_COUNT_BLOCKING", "plan.beats", "cinq à sept battements requis")
    beat_ids = {beat["beat_id"] for beat in beats}
    functions: list[str] = []
    summaries: list[str] = []
    for index, beat in enumerate(beats):
        beat_path = f"plan.beats[{index}]"
        if not _nonempty(beat["function"]):
            _issue(errors, "BEAT_FUNCTION_MISSING", f"{beat_path}.function", beat["beat_id"])
        else:
            functions.append(beat["function"])
        if beat["driver_id"] not in ACTIVE_PARTICIPANTS:
            _issue(errors, "BEAT_DRIVER_MISSING", f"{beat_path}.driver_id", beat["driver_id"])
        if not beat["movement_refs"]:
            _issue(errors, "BEAT_ENGINE_MISSING", f"{beat_path}.movement_refs", beat["beat_id"])
        if not _nonempty(beat["summary"]):
            _issue(errors, "BEAT_SUMMARY_MISSING", f"{beat_path}.summary", beat["beat_id"])
        matching_driver_movements = [
            movement_id
            for movement_id in beat["movement_refs"]
            if relation_movements.get(movement_id, {}).get("actor_id") == beat["driver_id"]
        ]
        if beat["movement_refs"] and not matching_driver_movements:
            _issue(errors, "BEAT_DRIVER_MOVEMENT_MISMATCH", f"{beat_path}.movement_refs", beat["driver_id"])
        summaries.append(beat["summary"].casefold())
    if len(functions) != len(set(functions)) or len(summaries) != len(set(summaries)):
        _issue(warnings, "BEATS_REDUNDANT", "plan.beats", "fonction ou résumé répété")

    relation_facts = {item["fact_id"] for item in relation["shared_facts"]}
    relation_limits = {item["limit_id"] for item in relation["limits"]}
    usable_facts = set(plan["fact_policy"]["usable_fact_ids"])
    forbidden_facts = set(plan["fact_policy"]["forbidden_fact_ids"])
    explicitly_unknown = {
        item["fact_id"] for item in calibration_workspace["character"]["unknown_facts"]
    }
    for fact_id in sorted(forbidden_facts):
        if fact_id not in explicitly_unknown:
            _issue(errors, "FORBIDDEN_FACT_UNKNOWN", "plan.fact_policy.forbidden_fact_ids", fact_id)
    used_facts = {plan["hook"]["fact_id"]}
    for beat in beats:
        used_facts.update(beat["fact_refs"])
    for fact_id in sorted(used_facts):
        if fact_id not in relation_facts:
            _issue(errors, "FACT_UNKNOWN", "plan.fact_policy", fact_id)
        elif fact_id not in usable_facts:
            _issue(errors, "FACT_NOT_DECLARED_USABLE", "plan.fact_policy.usable_fact_ids", fact_id)
        if fact_id in forbidden_facts:
            _issue(errors, "FORBIDDEN_FACT_USED", "plan.fact_policy.forbidden_fact_ids", fact_id)
    for limit_id in plan["required_limit_ids"]:
        if limit_id not in relation_limits:
            _issue(errors, "LIMIT_VIOLATED", "plan.required_limit_ids", limit_id)
    for movement_id in plan["movement_ids"]:
        if movement_id not in relation_movements:
            _issue(errors, "MOVEMENT_UNKNOWN", "plan.movement_ids", movement_id)
            continue
        for limit_id in relation_movements[movement_id]["requires_limit_ids"]:
            if limit_id not in plan["required_limit_ids"]:
                _issue(errors, "LIMIT_VIOLATED", "plan.required_limit_ids", f"{movement_id}: {limit_id}")
    for index, beat in enumerate(beats):
        for movement_id in beat["movement_refs"]:
            if movement_id not in plan["movement_ids"]:
                _issue(errors, "BEAT_MOVEMENT_UNDECLARED", f"plan.beats[{index}].movement_refs", movement_id)

    maximum_outcome = plan["maximum_change"]["outcome_id"]
    if not _nonempty(plan["maximum_change"]["description"]):
        _issue(errors, "MAXIMUM_CHANGE_MISSING", "plan.maximum_change.description", "description requise")
    if maximum_outcome not in ALLOWED_OUTCOMES:
        _issue(errors, "MAXIMUM_CHANGE_EXCEEDED", "plan.maximum_change.outcome_id", maximum_outcome)
    for outcome_id in plan["planned_outcome_ids"]:
        if outcome_id in FORBIDDEN_OUTCOMES:
            _issue(errors, "FORBIDDEN_CONSEQUENCE", "plan.planned_outcome_ids", outcome_id)
        elif outcome_id not in ALLOWED_OUTCOMES:
            _issue(errors, "MAXIMUM_CHANGE_EXCEEDED", "plan.planned_outcome_ids", outcome_id)
        elif outcome_id != maximum_outcome:
            _issue(errors, "MAXIMUM_CHANGE_EXCEEDED", "plan.planned_outcome_ids", outcome_id)
    if len(plan["planned_outcome_ids"]) > 1:
        _issue(warnings, "EVOLUTION_TOO_IMPORTANT", "plan.planned_outcome_ids", "une seule progression locale attendue")

    choice = plan["choice"]
    if plan["choice_mode"] == "NONE" and choice is not None:
        _issue(errors, "CHOICE_MODE_MISMATCH", "plan.choice", "aucun choix attendu")
    if plan["choice_mode"] == "ONE":
        if not isinstance(choice, dict):
            _issue(errors, "CHOICE_REQUIRED", "plan.choice", "un choix borné attendu")
        else:
            if choice["after_beat_id"] not in beat_ids:
                _issue(errors, "CHOICE_BEAT_UNKNOWN", "plan.choice.after_beat_id", choice["after_beat_id"])
            if not _nonempty(choice["focus"]):
                _issue(errors, "CHOICE_FOCUS_MISSING", "plan.choice.focus", "fonction du choix requise")
            option_ids = [option["option_id"] for option in choice["options"]]
            reception_ids = [reception["option_id"] for reception in choice["receptions"]]
            if not 1 <= len(option_ids) <= 3:
                _issue(errors, "CHOICE_OPTIONS_INVALID", "plan.choice.options", "une à trois attitudes attendues")
            for index, option in enumerate(choice["options"]):
                if not _nonempty(option["attitude"]):
                    _issue(errors, "CHOICE_OPTION_MISSING", f"plan.choice.options[{index}].attitude", option["option_id"])
            if option_ids != reception_ids:
                _issue(errors, "CHOICE_RECEPTION_MISSING", "plan.choice.receptions", "une réception ordonnée par option")
            for index, reception in enumerate(choice["receptions"]):
                if (
                    reception["character_id"] != "sandra"
                    or not _nonempty(reception["description"])
                    or not reception["movement_refs"]
                    or not set(reception["movement_refs"]).issubset(plan["movement_ids"])
                    or any(
                        relation_movements.get(movement_id, {}).get("actor_id") != reception["character_id"]
                        for movement_id in reception["movement_refs"]
                    )
                ):
                    _issue(errors, "CHOICE_RECEPTION_MISSING", f"plan.choice.receptions[{index}]", "réception de Sandra requise")

    expected = plan["expected_reception"]
    if (
        expected["character_id"] != "sandra"
        or not _nonempty(expected["description"])
        or not set(expected["movement_refs"]).issubset(plan["movement_ids"])
        or any(
            relation_movements.get(movement_id, {}).get("actor_id") != expected["character_id"]
            for movement_id in expected["movement_refs"]
        )
    ):
        _issue(errors, "EXPECTED_RECEPTION_MISSING", "plan.expected_reception", "réception de Sandra requise")

    media = plan["media_requirement"]
    media_payload = [media["kind"], media["linked_fact_id"], media["justification"]]
    if media["required"]:
        if any(not _nonempty(item) for item in media_payload) or media["linked_fact_id"] not in usable_facts:
            _issue(errors, "MEDIA_UNJUSTIFIED", "plan.media_requirement", "média relié à un fait utilisable requis")
    elif any(item is not None for item in media_payload):
        _issue(errors, "MEDIA_UNJUSTIFIED", "plan.media_requirement", "aucun média ne doit être décrit")

    if plan["protective_close"]["punitive"]:
        _issue(errors, "PROTECTIVE_CLOSE_PUNITIVE", "plan.protective_close.punitive", "la protection ne punit pas Player")
    if not _nonempty(plan["protective_close"]["description"]) or not _nonempty(plan["protective_close"]["protects"]):
        _issue(errors, "PROTECTIVE_CLOSE_MISSING", "plan.protective_close", "fermeture et protection requises")
    if not _nonempty(plan["cautious_opening"]):
        _issue(errors, "CAUTIOUS_OPENING_MISSING", "plan.cautious_opening", "ouverture prudente requise")

    for text_path, text in _plan_texts(plan):
        if _contains_final_dialogue(text):
            _issue(errors, "FINAL_DIALOGUE_IN_PLAN", text_path, "décrire le mouvement sans écrire la bulle")

    if (
        not plan["hook"]["concrete"]
        or not _nonempty(plan["hook"]["fact_id"])
        or not _nonempty(plan["hook"]["description"])
    ):
        _issue(warnings, "HOOK_ABSTRACT", "plan.hook", "accroche factuelle concrète attendue")
    if not _nonempty(plan["local_risk"]):
        _issue(warnings, "LOCAL_RISK_MISSING", "plan.local_risk", "risque local à expliciter")
    perfect_markers = ("tout est réglé", "réconciliation acquise", "aucun malaise", "issue parfaite")
    if any(marker in plan["protective_close"]["description"].casefold() for marker in perfect_markers):
        _issue(warnings, "EXIT_TOO_PERFECT", "plan.protective_close.description", "conserver une réserve locale")
    if beats and all(beat["driver_id"] == "player" for beat in beats):
        _issue(warnings, "PLAYER_DRIVES_ENTIRE_SCENE", "plan.beats", "Sandra doit aussi produire des mouvements")
    sandra_movements = {
        movement_id
        for movement_id in plan["movement_ids"]
        if relation_movements.get(movement_id, {}).get("actor_id") == "sandra"
    }
    if not sandra_movements or not any(beat["driver_id"] == "sandra" for beat in beats):
        _issue(warnings, "SANDRA_REDUCED_TO_REACTION", "plan.beats", "Sandra doit conduire une partie de l'échange")

    if foreign_workspaces:
        for name in ("marie", "mathilde"):
            foreign = foreign_workspaces.get(name)
            if foreign is None:
                continue
            specificity = validate_plan_against_relationship(plan, foreign["relationship"])
            if not {issue.code for issue in specificity}.intersection(SPECIFICITY_CODES):
                _issue(warnings, "PLAN_INTERCHANGEABLE", "plan", f"aucune incompatibilité structurelle sous {name}")

    review = document["human_review"]
    expected_fingerprint = planning_fingerprint(document)
    if (
        review["status"] != "APPROVED_FOR_DRAFT_GENERATION"
        or not _nonempty(review.get("reviewed_by"))
        or review.get("plan_fingerprint") != expected_fingerprint
    ):
        _issue(errors, "HUMAN_APPROVAL_ABSENT", "human_review", "approbation humaine du plan exact requise")

    status = "BLOCKED" if errors else ("READY_WITH_WARNINGS" if warnings else "READY")
    return {
        "status": status,
        "blocking_errors": [issue.as_json() for issue in errors],
        "warnings": [issue.as_json() for issue in warnings],
    }


def _read_json(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise A113PlanningError([Issue("JSON_READ_FAILED", str(path), str(exc))]) from exc
    if not isinstance(value, dict):
        raise A113PlanningError([Issue("JSON_OBJECT_REQUIRED", str(path), "racine objet attendue")])
    return value


def load_planning_case(path: Path = DEFAULT_CASE_PATH) -> dict[str, Any]:
    document = _read_json(path)
    issues = validate_planning_case(document)
    if issues:
        raise A113PlanningError(issues)
    return copy.deepcopy(document)


def diagnose_intention(document: Mapping[str, Any]) -> dict[str, Any]:
    return copy.deepcopy(document["diagnostic"])


def bounded_options(document: Mapping[str, Any]) -> list[dict[str, Any]]:
    return copy.deepcopy(document["diagnostic"]["selectable_information_gaps"])


def run_workflow(document: Mapping[str, Any]) -> dict[str, Any]:
    calibration = load_calibration_case("sandra")
    foreign = {name: load_calibration_case(name) for name in ("marie", "mathilde")}
    validation = validate_scene_plan(document, calibration, foreign)
    return {
        "chain": [
            "human_intention",
            "diagnostic",
            "bounded_options",
            "human_selection",
            "plan",
            "validation",
            "human_review",
        ],
        "intention": copy.deepcopy(document["intention"]),
        "diagnostic": diagnose_intention(document),
        "bounded_options": bounded_options(document),
        "human_selection": copy.deepcopy(document["human_selection"]),
        "plan": copy.deepcopy(document["plan"]),
        "validation": validation,
        "human_review": copy.deepcopy(document["human_review"]),
    }


def cross_validate_sandra_plan(document: Mapping[str, Any]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for name in CASE_NAMES:
        workspace = load_calibration_case(name)
        issues = validate_plan_against_relationship(document["plan"], workspace["relationship"])
        result[name] = {
            "compatible": not issues,
            "issues": [issue.as_json() for issue in issues],
        }
    return result


def validate_json_library() -> dict[str, Any]:
    document = load_planning_case()
    validation = validate_scene_plan(
        document,
        load_calibration_case("sandra"),
        {name: load_calibration_case(name) for name in ("marie", "mathilde")},
    )
    if validation["status"] == "BLOCKED":
        raise A113PlanningError(
            [Issue(item["code"], item["path"], item["message"]) for item in validation["blocking_errors"]]
        )
    return {
        "ok": True,
        "format": FORMAT_ASSISTED_SCENE_PLANNING,
        "case_id": document["case_id"],
    }


def run_smoke() -> dict[str, Any]:
    document = load_planning_case()
    first = run_workflow(document)
    second = run_workflow(document)
    if first != second:
        raise AssertionError("workflow non déterministe")
    if first["validation"]["status"] == "BLOCKED":
        raise AssertionError("plan approuvé bloqué")
    cross = cross_validate_sandra_plan(document)
    if not cross["sandra"]["compatible"]:
        raise AssertionError("contrat Sandra rejeté")
    for name in ("marie", "mathilde"):
        codes = {issue["code"] for issue in cross[name]["issues"]}
        if not SPECIFICITY_CODES.issubset(codes):
            raise AssertionError(f"preuve structurelle incomplète sous {name}: {sorted(codes)}")
    return {
        "ok": True,
        "case_id": document["case_id"],
        "beat_count": len(document["plan"]["beats"]),
        "review_status": document["human_review"]["status"],
        "workflow_sha256": hashlib.sha256(_canonical(first).encode("utf-8")).hexdigest(),
        "foreign_contracts": {
            name: sorted({issue["code"] for issue in cross[name]["issues"]})
            for name in ("marie", "mathilde")
        },
    }


def _emit(value: Any) -> None:
    print(json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True))


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Planification de scène hors ligne R8C-A11.3")
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("validate-json")
    subparsers.add_parser("diagnostic")
    subparsers.add_parser("options")
    subparsers.add_parser("workflow")
    subparsers.add_parser("cross-validate")
    subparsers.add_parser("smoke")
    args = parser.parse_args(argv)
    try:
        if args.command == "validate-json":
            _emit(validate_json_library())
        elif args.command == "diagnostic":
            _emit(diagnose_intention(load_planning_case()))
        elif args.command == "options":
            _emit(bounded_options(load_planning_case()))
        elif args.command == "workflow":
            _emit(run_workflow(load_planning_case()))
        elif args.command == "cross-validate":
            _emit(cross_validate_sandra_plan(load_planning_case()))
        else:
            _emit(run_smoke())
    except (A113PlanningError, AssertionError) as exc:
        print(f"A11.3_ERROR: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
