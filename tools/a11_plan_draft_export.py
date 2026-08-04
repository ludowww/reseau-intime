#!/usr/bin/env python3
"""Offline A11.4 plan-to-draft validation and synthetic A6 test export."""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import re
import sys
import tempfile
from datetime import date
from pathlib import Path
from typing import Any, Mapping, Sequence

try:
    from tools.a11_authoring_workshop import (
        FORMAT_REPORT,
        Issue,
        build_a6_scene_library,
        validate_draft_format,
        validate_report_format,
    )
    from tools.a11_scene_planning import (
        load_planning_case,
        validate_scene_plan,
    )
    from tools.a11_voice_calibration import (
        load_case as load_calibration_case,
        validate_compatibility as validate_calibration_compatibility,
    )
except ModuleNotFoundError:
    from a11_authoring_workshop import (  # type: ignore
        FORMAT_REPORT,
        Issue,
        build_a6_scene_library,
        validate_draft_format,
        validate_report_format,
    )
    from a11_scene_planning import load_planning_case, validate_scene_plan  # type: ignore
    from a11_voice_calibration import (  # type: ignore
        load_case as load_calibration_case,
        validate_compatibility as validate_calibration_compatibility,
    )


ROOT = Path(__file__).resolve().parents[1]
DRAFTING_DIR = ROOT / "narrative_tool" / "a11" / "drafting"
PLAN_PATH = ROOT / "narrative_tool" / "a11" / "planning" / "sandra_recontact_after_silence.json"
DRAFT_PATH = DRAFTING_DIR / "sandra_recontact_after_silence.draft.json"
REPORT_PATH = DRAFTING_DIR / "sandra_recontact_after_silence.validation_report.json"
APPROVAL_PATH = DRAFTING_DIR / "sandra_recontact_after_silence.composite_approval.json"
HUMAN_REVIEW_PATH = DRAFTING_DIR / "sandra_recontact_after_silence.human_review.md"
PROJECTION_REPORT_PATH = DRAFTING_DIR / "sandra_recontact_after_silence.projection_report.json"
A6_FIXTURE_PATH = (
    ROOT
    / "game"
    / "data"
    / "narrative_scenes"
    / "r8c_a11_4_sandra_recontact_after_silence_export.json"
)

FORMAT_COMPOSITE_APPROVAL = "R8C_A11_COMPOSITE_APPROVAL"
FORMAT_PROJECTION_REPORT = "R8C_A11_A6_PROJECTION_REPORT"
VERSION = 1
VALIDATOR_VERSION = "a11-plan-draft-validator-1.2"
REVIEW_STATUSES = {
    "DRAFT",
    "NEEDS_REVISION",
    "APPROVED_FOR_A6_TEST_EXPORT",
    "REJECTED",
}

REVIEW_QUESTIONS = (
    (
        "sandra_recognizable",
        "Sandra est-elle reconnaissable sans son nom ?",
        "YES",
    ),
    (
        "player_indirect",
        "Player reste-t-il discret et indirect ?",
        "YES",
    ),
    (
        "all_beats_realized",
        "Chaque battement est-il réellement réalisé ?",
        "YES",
    ),
    (
        "ticket_has_function",
        "Le ticket plié sert-il la scène au-delà de l’accroche ?",
        "YES",
    ),
    (
        "texture_natural",
        "Les messages faibles et rafales semblent-ils naturels ?",
        "YES",
    ),
    (
        "choice_visible_reception",
        "Le choix produit-il une réception visible ?",
        "YES",
    ),
    (
        "meeting_only_possible",
        "Le rendez-vous reste-t-il seulement possible ?",
        "YES",
    ),
    (
        "protective_close_valid",
        "La fermeture protectrice reste-t-elle valide ?",
        "YES",
    ),
    (
        "unplanned_information_added",
        "Une information ou évolution absente du plan a-t-elle été ajoutée ?",
        "NO",
    ),
    (
        "a6_without_false_promise",
        "Le brouillon peut-il être projeté vers A6 sans fausse promesse ?",
        "YES",
    ),
)

APPROVAL_ROOT_KEYS = {
    "format",
    "version",
    "draft_id",
    "draft_revision",
    "human_review",
    "projection_config",
    "approval_fingerprint",
}
HUMAN_REVIEW_KEYS = {"status", "reviewed_by", "checks", "notes"}
REVIEW_CHECK_KEYS = {"question_id", "question", "response", "notes"}
PROJECTION_CONFIG_KEYS = {
    "scene_definition_id",
    "variant_id",
    "version_contract",
    "nature",
    "function",
    "compatible_act_ids",
    "required_event_ids",
    "forbidden_event_ids",
    "start_date",
    "end_date",
    "opening_time",
    "closing_time",
    "duration_minutes",
    "uniqueness",
    "expiration_policy",
    "choice_mappings",
}
CHOICE_MAPPING_KEYS = {"option_id", "signal", "reception_interpretation"}
PROJECTION_REPORT_ROOT_KEYS = {
    "format",
    "version",
    "approval_fingerprint",
    "draft_id",
    "draft_revision",
    "scene_definition_id",
    "variant_id",
    "canonical_json_sha256",
    "exported_elements",
    "unrepresentable_elements",
    "preserved_invariants",
}
EXPORTED_ELEMENT_KEYS = {"source", "target", "detail"}
UNREPRESENTABLE_ELEMENT_KEYS = {"source", "reason", "preserved_in"}

DIRECT_DECLARATIONS = (
    "je t'aime",
    "tu me manques",
    "je suis amoureux",
    "je veux être avec toi",
)
ACQUIRED_MEETINGS = (
    "on se voit vendredi",
    "c'est un rendez-vous",
    "le rendez-vous est fixé",
    "rendez-vous confirmé",
)
SILENCE_REPROACHES = (
    "tu aurais pu répondre",
    "tu m'as ignoré",
    "tu me dois une réponse",
)
DURABLE_CONSEQUENCES = (
    "à partir de maintenant",
    "pour toujours",
    "on est ensemble",
)
PROMISE_MARKERS = ("je te promets", "ça marchera", "tu verras")
EXPLANATORY_MARKERS = (
    "ce que je veux dire",
    "pour être clair",
    "autrement dit",
    "mon intention",
)
MECHANICAL_HUMOR_MARKERS = ("je plaisante", "c'était une blague", "très drôle")
ROMANTIC_TENSION_MARKERS = ("attirance", "sentiments", "romantique", "amoureux")
CONCRETE_STAKE_MARKERS = ("silence", "ticket", "cinéma", "distance", "moment")
PERFECT_EXIT_MARKERS = ("tout est réglé", "plus aucun malaise", "parfait maintenant")
THEATRICAL_MARKERS = ("destin", "éternité", "tragédie")
UNRESERVED_AVAILABILITY_MARKERS = (
    "quand tu veux",
    "toujours disponible",
    "dès que tu veux",
)
AFFECTIVE_DEMAND_MARKERS = (
    "dis-moi ce que tu ressens",
    "tu dois me dire ce que tu ressens",
    "réponds-moi sur tes sentiments",
)
IMMEDIATE_SEDUCTION_MARKERS = ("embrasse-moi maintenant", "viens chez moi maintenant")
PLAYER_PERFECT_MARKERS = (
    "mon intention était parfaitement",
    "je voulais simplement respecter exactement",
)
FOLDED_TICKET_FACT_ID = "sandra_folded_ticket"
PLAYER_FOLDED_TICKET_POSSESSION_PATTERNS = (
    re.compile(r"\bje\s+viens\s+de\s+(?:re)?trouver\b"),
    re.compile(r"\bj['’]ai\s+(?:retrouv[ée]|trouv[ée]|gard[ée]|conserv[ée])\b"),
    re.compile(r"\bje\s+l['’](?:ai|avais)\s+(?:encore|gard[ée]|conserv[ée]|retrouv[ée]|trouv[ée])\b"),
    re.compile(r"\bje\s+le\s+(?:garde|conserve|possède)\b"),
    re.compile(r"\bmon\s+ticket\b"),
    re.compile(r"\b(?:dans|à)\s+ma\s+poche\b"),
    re.compile(r"\bil\s+est\s+(?:chez\s+moi|avec\s+moi)\b"),
)
SANDRA_DIALOGUE_TEXT_SIGNATURES = {
    "protective_detour": (
        "archives",
        "procédure",
        "catégories administratives",
        "colloque",
        "permis de détour",
        "dossier",
        "archiviste",
    ),
    "shared_memory": ("ticket", "cinéma", "coque", "boîte"),
    "slow_reversible_progression": (
        "doucement",
        "pour ce soir",
        "si j'y repasse",
        "peut me revenir",
        "aucune cérémonie",
    ),
}
SANDRA_RELATIONAL_STRATEGY_SIGNATURES = {
    "protective_detour": ("détourner",),
    "shared_memory": ("mémoire",),
    "slow_reversible_progression": ("prolongation légère",),
}
FOREIGN_DIALOGUE_SPECIFICITY_CODES = {
    "VOICE_RULE_INCOMPATIBLE",
    "FACT_UNAVAILABLE",
    "LIMIT_INCOMPATIBLE",
    "MOVEMENT_INCOMPATIBLE",
    "LOCAL_STATE_INCOMPATIBLE",
}
DIRECT_DECLARATION_PATTERNS = (
    re.compile(r"\bje\s+(?:suis\s+amoureux|suis\s+amoureuse|veux\s+être\s+avec\s+toi)\b"),
    re.compile(r"\bje\s+t['’]aime\b"),
)
ACQUIRED_MEETING_PATTERNS = (
    re.compile(r"\b(?:on\s+se\s+voit|rendez[- ]vous\s+(?:est\s+)?(?:fixé|confirmé))\b"),
    re.compile(
        r"\b(?:lundi|mardi|mercredi|jeudi|vendredi|samedi|dimanche)\b"
        r"[^\n]{0,60}\b(?:à\s+\d{1,2}\s*(?:h|:)|devant|près\s+de)\b"
    ),
)
AFFECTIVE_DEMAND_PATTERNS = (
    re.compile(r"\b(?:dis|dites)[- ]moi\s+ce\s+que\s+tu\s+ressens\b"),
    re.compile(r"\btu\s+dois\s+me\s+dire\s+ce\s+que\s+tu\s+ressens\b"),
)
A6_ID_PATTERN = re.compile(r"^[a-z0-9_]{1,96}$")


class A114ValidationError(ValueError):
    def __init__(self, issues: Sequence[Issue]):
        self.issues = tuple(issues)
        super().__init__("; ".join(f"{issue.code} at {issue.path}" for issue in issues))


class A114ApprovalError(ValueError):
    pass


def _canonical(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


def _sha256(value: Any) -> str:
    return hashlib.sha256(_canonical(value).encode("utf-8")).hexdigest()


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


def _read_json(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise A114ValidationError([Issue("JSON_READ_FAILED", str(path), str(exc))]) from exc
    if not isinstance(value, dict):
        raise A114ValidationError(
            [Issue("JSON_OBJECT_REQUIRED", str(path), "racine objet attendue")]
        )
    return value


def validate_composite_approval_format(
    document: Any,
    path: str = "approval",
) -> list[Issue]:
    issues: list[Issue] = []
    if not _closed(document, APPROVAL_ROOT_KEYS, path, issues):
        return issues
    if document["format"] != FORMAT_COMPOSITE_APPROVAL:
        _issue(issues, "FORMAT_UNKNOWN", f"{path}.format", FORMAT_COMPOSITE_APPROVAL)
    if type(document["version"]) is not int or document["version"] != VERSION:
        _issue(issues, "VERSION_UNKNOWN", f"{path}.version", str(VERSION))
    for field in ("draft_id", "draft_revision", "approval_fingerprint"):
        if not _nonempty(document[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.{field}", "chaîne non vide attendue")
    review = document["human_review"]
    if _closed(review, HUMAN_REVIEW_KEYS, f"{path}.human_review", issues):
        if review["status"] not in REVIEW_STATUSES:
            _issue(issues, "REVIEW_STATUS_UNKNOWN", f"{path}.human_review.status", str(review["status"]))
        if not _nonempty(review["reviewed_by"]):
            _issue(issues, "HUMAN_REVIEWER_REQUIRED", f"{path}.human_review.reviewed_by", "identité humaine requise")
        _string_list(review["notes"], f"{path}.human_review.notes", issues)
        checks = review["checks"]
        if not isinstance(checks, list):
            _issue(issues, "REVIEW_CHECKS_REQUIRED", f"{path}.human_review.checks", "tableau attendu")
        else:
            for index, check in enumerate(checks):
                check_path = f"{path}.human_review.checks[{index}]"
                if not _closed(check, REVIEW_CHECK_KEYS, check_path, issues):
                    continue
                for field in REVIEW_CHECK_KEYS:
                    if not _nonempty(check[field]):
                        _issue(issues, "REVIEW_CHECK_INVALID", f"{check_path}.{field}", "chaîne non vide attendue")
                if check["response"] not in {"YES", "NO"}:
                    _issue(issues, "REVIEW_RESPONSE_UNKNOWN", f"{check_path}.response", str(check["response"]))
    config = document["projection_config"]
    if _closed(config, PROJECTION_CONFIG_KEYS, f"{path}.projection_config", issues):
        for field in PROJECTION_CONFIG_KEYS - {
            "compatible_act_ids",
            "required_event_ids",
            "forbidden_event_ids",
            "duration_minutes",
            "choice_mappings",
        }:
            if not _nonempty(config[field]):
                _issue(issues, "TEXT_REQUIRED", f"{path}.projection_config.{field}", "chaîne non vide attendue")
        for field in ("compatible_act_ids", "required_event_ids", "forbidden_event_ids"):
            _string_list(config[field], f"{path}.projection_config.{field}", issues, nonempty=field == "compatible_act_ids")
        if type(config["duration_minutes"]) is not int or config["duration_minutes"] <= 0:
            _issue(issues, "DURATION_INVALID", f"{path}.projection_config.duration_minutes", "entier positif attendu")
        mappings = config["choice_mappings"]
        if not isinstance(mappings, list) or len(mappings) != 2:
            _issue(issues, "CHOICE_MAPPINGS_REQUIRED", f"{path}.projection_config.choice_mappings", "deux mappings attendus")
        else:
            for index, mapping in enumerate(mappings):
                mapping_path = f"{path}.projection_config.choice_mappings[{index}]"
                if _closed(mapping, CHOICE_MAPPING_KEYS, mapping_path, issues):
                    for field in CHOICE_MAPPING_KEYS:
                        if not _nonempty(mapping[field]):
                            _issue(issues, "CHOICE_MAPPING_INVALID", f"{mapping_path}.{field}", "chaîne non vide attendue")
    if not issues:
        issues.extend(validate_projection_config(config, f"{path}.projection_config"))
    return issues


def _date_valid(value: Any) -> bool:
    if not isinstance(value, str) or re.fullmatch(r"\d{4}-\d{2}-\d{2}", value) is None:
        return False
    try:
        date.fromisoformat(value)
    except ValueError:
        return False
    return True


def _time_minutes(value: Any) -> int:
    if not isinstance(value, str) or re.fullmatch(r"\d{2}:\d{2}", value) is None:
        return -1
    hours, minutes = (int(item) for item in value.split(":"))
    if hours > 23 or minutes > 59:
        return -1
    return hours * 60 + minutes


def validate_projection_config(
    config: Mapping[str, Any],
    path: str = "approval.projection_config",
) -> list[Issue]:
    """Mirror the closed A6/A3 constraints exercised by the exported definition."""
    issues: list[Issue] = []
    for field in ("scene_definition_id", "variant_id"):
        value = config.get(field)
        if not isinstance(value, str) or A6_ID_PATTERN.fullmatch(value) is None:
            _issue(issues, "A6_ID_INVALID", f"{path}.{field}", "[a-z0-9_], 1 à 96 caractères")
    if config.get("scene_definition_id") == config.get("variant_id"):
        _issue(issues, "A6_IDENTITIES_COLLIDE", path, "définition et variante doivent rester distinctes")
    for field, allowed in (
        ("nature", {"SIGNATURE", "MODULAIRE"}),
        ("function", {"RELATION", "OPPORTUNITE", "ECHO", "RESPIRATION"}),
        ("uniqueness", {"UNIQUE", "REPETABLE"}),
        ("expiration_policy", {"MISSED", "CANCELLED"}),
    ):
        if config.get(field) not in allowed:
            _issue(issues, "A6_ENUM_INVALID", f"{path}.{field}", ", ".join(sorted(allowed)))
    start = config.get("start_date")
    end = config.get("end_date")
    if not _date_valid(start):
        _issue(issues, "A6_DATE_INVALID", f"{path}.start_date", "YYYY-MM-DD valide attendu")
    if not _date_valid(end):
        _issue(issues, "A6_DATE_INVALID", f"{path}.end_date", "YYYY-MM-DD valide attendu")
    if _date_valid(start) and _date_valid(end) and start > end:
        _issue(issues, "A6_TEMPORAL_WINDOW_INVALID", path, "date_debut <= date_fin attendue")
    opening = _time_minutes(config.get("opening_time"))
    closing = _time_minutes(config.get("closing_time"))
    if opening < 0:
        _issue(issues, "A6_TIME_INVALID", f"{path}.opening_time", "HH:MM valide attendu")
    if closing < 0:
        _issue(issues, "A6_TIME_INVALID", f"{path}.closing_time", "HH:MM valide attendu")
    if opening >= 0 and closing >= 0 and opening >= closing:
        _issue(issues, "A6_TEMPORAL_WINDOW_INVALID", path, "ouverture antérieure à fermeture attendue")
    required = config.get("required_event_ids", [])
    forbidden = config.get("forbidden_event_ids", [])
    if isinstance(required, list) and isinstance(forbidden, list):
        overlap = sorted(set(required) & set(forbidden))
        if overlap:
            _issue(issues, "A6_EVENT_CONTRADICTION", path, ", ".join(overlap))
    mappings = config.get("choice_mappings")
    if isinstance(mappings, list) and len(mappings) == 2 and all(isinstance(item, dict) for item in mappings):
        for field in ("option_id", "signal", "reception_interpretation"):
            values = [mapping.get(field) for mapping in mappings]
            if len(set(values)) != 2:
                _issue(issues, "A6_CHOICE_MAPPING_NOT_DISTINCT", f"{path}.choice_mappings", field)
    return issues


def validate_projection_report_format(
    document: Any,
    path: str = "projection_report",
) -> list[Issue]:
    issues: list[Issue] = []
    if not _closed(document, PROJECTION_REPORT_ROOT_KEYS, path, issues):
        return issues
    if document["format"] != FORMAT_PROJECTION_REPORT:
        _issue(issues, "FORMAT_UNKNOWN", f"{path}.format", FORMAT_PROJECTION_REPORT)
    if type(document["version"]) is not int or document["version"] != VERSION:
        _issue(issues, "VERSION_UNKNOWN", f"{path}.version", str(VERSION))
    for field in (
        "approval_fingerprint",
        "draft_id",
        "draft_revision",
        "scene_definition_id",
        "variant_id",
        "canonical_json_sha256",
    ):
        if not _nonempty(document[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.{field}", "chaîne non vide attendue")
    for field, keys in (
        ("exported_elements", EXPORTED_ELEMENT_KEYS),
        ("unrepresentable_elements", UNREPRESENTABLE_ELEMENT_KEYS),
    ):
        values = document[field]
        if not isinstance(values, list) or not values:
            _issue(issues, "PROJECTION_ITEMS_REQUIRED", f"{path}.{field}", "tableau non vide attendu")
            continue
        for index, value in enumerate(values):
            value_path = f"{path}.{field}[{index}]"
            if _closed(value, keys, value_path, issues):
                for key in keys:
                    if not _nonempty(value[key]):
                        _issue(issues, "PROJECTION_ITEM_INVALID", f"{value_path}.{key}", "chaîne non vide attendue")
    _string_list(document["preserved_invariants"], f"{path}.preserved_invariants", issues, nonempty=True)
    return issues


def default_paths() -> dict[str, Path]:
    return {
        "plan_path": PLAN_PATH,
        "draft_path": DRAFT_PATH,
        "report_path": REPORT_PATH,
        "approval_path": APPROVAL_PATH,
        "projection_report_path": PROJECTION_REPORT_PATH,
    }


def load_workspace(
    plan_path: Path,
    draft_path: Path,
    report_path: Path,
    approval_path: Path,
    projection_report_path: Path,
) -> dict[str, Any]:
    planning = load_planning_case(Path(plan_path))
    calibration = load_calibration_case("sandra")
    foreign_calibrations = {
        name: load_calibration_case(name)
        for name in ("marie", "mathilde")
    }
    workspace = {
        "planning": planning,
        "character_contract": copy.deepcopy(calibration["character"]),
        "relationship_register": copy.deepcopy(calibration["relationship"]),
        "foreign_calibrations": {
            name: {
                "character": copy.deepcopy(foreign["character"]),
                "relationship": copy.deepcopy(foreign["relationship"]),
            }
            for name, foreign in foreign_calibrations.items()
        },
        "draft": _read_json(Path(draft_path)),
        "validation_report": _read_json(Path(report_path)),
        "approval": _read_json(Path(approval_path)),
        "projection_report": _read_json(Path(projection_report_path)),
    }
    issues: list[Issue] = []
    issues.extend(validate_draft_format(workspace["draft"]))
    issues.extend(validate_report_format(workspace["validation_report"]))
    issues.extend(validate_composite_approval_format(workspace["approval"]))
    issues.extend(validate_projection_report_format(workspace["projection_report"]))
    if issues:
        raise A114ValidationError(issues)
    return copy.deepcopy(workspace)


def validation_fingerprint(workspace: Mapping[str, Any]) -> str:
    payload = {
        "validator_version": VALIDATOR_VERSION,
        "character_contract": workspace["character_contract"],
        "relationship_register": workspace["relationship_register"],
        "foreign_calibrations": workspace["foreign_calibrations"],
        "planning_case": workspace["planning"],
        "draft": workspace["draft"],
    }
    return _sha256(payload)


def composite_approval_fingerprint(workspace: Mapping[str, Any]) -> str:
    approval = workspace["approval"]
    payload = {
        "validator_version": VALIDATOR_VERSION,
        "character_contract": workspace["character_contract"],
        "relationship_register": workspace["relationship_register"],
        "foreign_calibrations": workspace["foreign_calibrations"],
        "planning_case": workspace["planning"],
        "draft": workspace["draft"],
        "validation_report": workspace["validation_report"],
        "human_review": approval["human_review"],
        "projection_config": approval["projection_config"],
        "approval_identity": {
            "format": approval["format"],
            "version": approval["version"],
            "draft_id": approval["draft_id"],
            "draft_revision": approval["draft_revision"],
        },
    }
    return _sha256(payload)


def _phrase_hits(corpus: str, phrases: Sequence[str]) -> list[str]:
    return [phrase for phrase in phrases if phrase in corpus]


def _pattern_hits(corpus: str, patterns: Sequence[re.Pattern[str]]) -> list[str]:
    return [match.group(0) for pattern in patterns if (match := pattern.search(corpus))]


def _validation_result(
    workspace: Mapping[str, Any],
    errors: Sequence[Issue],
    warnings: Sequence[Issue],
) -> dict[str, Any]:
    draft = workspace["draft"]
    draft_id = draft.get("draft_id") if isinstance(draft, dict) else None
    revision = draft.get("revision") if isinstance(draft, dict) else None
    status = "BLOCKED" if errors else ("READY_WITH_WARNINGS" if warnings else "READY")
    return {
        "format": FORMAT_REPORT,
        "version": VERSION,
        "draft_id": draft_id if _nonempty(draft_id) else "invalid_draft",
        "draft_revision": revision if _nonempty(revision) else "invalid_revision",
        "approval_fingerprint": validation_fingerprint(workspace),
        "status": status,
        "blocking_errors": [issue.as_json() for issue in errors],
        "warnings": [issue.as_json() for issue in warnings],
        "human_approval": None,
    }


def _dialogue_calibration_case(workspace: Mapping[str, Any]) -> dict[str, Any]:
    plan = workspace["planning"]["plan"]
    messages = workspace["draft"]["messages"]
    voice = workspace["character_contract"]["voice"]
    evidence_specs = (
        ("style_rules", 0, {"sandra_deflects_with_humor"}),
        (
            "style_rules",
            1,
            {"sandra_relaunches_shared_memory", "sandra_prolongs_without_claim"},
        ),
        ("style_rules", 2, {"sandra_prolongs_without_claim"}),
        ("tone_markers", 0, {"sandra_prolongs_without_claim"}),
        ("tone_markers", 1, {"sandra_deflects_with_humor"}),
        ("tone_markers", 2, {"sandra_relaunches_shared_memory"}),
    )
    voice_evidence = []
    for rule_group, rule_index, movement_ids in evidence_specs:
        message_ids = [
            message["message_id"]
            for message in messages
            if message["speaker_id"] == "sandra"
            and message["conversation_move"] in movement_ids
        ]
        voice_evidence.append({
            "rule_group": rule_group,
            "rule_text": voice[rule_group][rule_index],
            "message_ids": message_ids,
        })
    used_facts = {
        fact_id
        for message in messages
        for fact_id in message["fact_refs"]
    }
    used_movements = {message["conversation_move"] for message in messages}
    return {
        "active_character_id": "sandra",
        "active_relationship_id": plan["relationship_id"],
        "local_state_id": plan["initial_state_id"],
        "useful_fact_ids": [
            fact_id
            for fact_id in plan["fact_policy"]["usable_fact_ids"]
            if fact_id in used_facts
        ],
        "useful_limit_ids": list(plan["required_limit_ids"]),
        "expected_movement_ids": [
            movement_id
            for movement_id in plan["movement_ids"]
            if movement_id in used_movements
        ],
        "voice_evidence": voice_evidence,
        "messages": [
            {
                "message_id": message["message_id"],
                "speaker_id": message["speaker_id"],
                "text": message["text"],
                "fact_refs": list(message["fact_refs"]),
                "movement_refs": [message["conversation_move"]],
            }
            for message in messages
        ],
    }


def dialogue_specificity(workspace: Mapping[str, Any]) -> dict[str, list[dict[str, str]]]:
    case = _dialogue_calibration_case(workspace)
    targets = {
        "sandra": {
            "character": workspace["character_contract"],
            "relationship": workspace["relationship_register"],
        },
        **workspace["foreign_calibrations"],
    }
    return {
        name: [
            issue.as_json()
            for issue in validate_calibration_compatibility(
                case,
                target["character"],
                target["relationship"],
            )
        ]
        for name, target in targets.items()
    }


def validate_draft(workspace: Mapping[str, Any]) -> dict[str, Any]:
    planning = workspace["planning"]
    plan = planning["plan"]
    draft = workspace["draft"]
    relation = workspace["relationship_register"]["relationship"]
    errors: list[Issue] = []
    warnings: list[Issue] = []

    errors.extend(validate_draft_format(draft))
    if errors:
        return _validation_result(workspace, errors, warnings)

    plan_report = validate_scene_plan(
        planning,
        {
            "character": workspace["character_contract"],
            "relationship": workspace["relationship_register"],
        },
    )
    for item in plan_report["blocking_errors"]:
        _issue(errors, item["code"], item["path"], item["message"])

    if draft["plan_id"] != plan["plan_id"]:
        _issue(errors, "DRAFT_PLAN_MISMATCH", "draft.plan_id", plan["plan_id"])
    messages = draft["messages"]
    if not 45 <= len(messages) <= 65:
        _issue(errors, "DRAFT_BUBBLE_COUNT_BLOCKING", "draft.messages", "45 à 65 bulles requises")
    message_ids = [message["message_id"] for message in messages]
    if len(message_ids) != len(set(message_ids)):
        _issue(errors, "MESSAGE_ID_DUPLICATE", "draft.messages", "identités dupliquées")
    message_index = {message_id: index for index, message_id in enumerate(message_ids)}
    participants = set(plan["participant_ids"])
    objectives = {objective["actor_id"] for objective in plan["objectives"]}
    beats = {beat["beat_id"]: beat for beat in plan["beats"]}
    beat_order = {beat["beat_id"]: index for index, beat in enumerate(plan["beats"])}
    movements = {item["movement_id"]: item for item in relation["movements"]}
    states = {item["state_id"]: item for item in relation["local_states"]}
    shared_facts = {item["fact_id"]: item for item in relation["shared_facts"]}
    usable_facts = set(plan["fact_policy"]["usable_fact_ids"])
    forbidden_facts = set(plan["fact_policy"]["forbidden_fact_ids"])
    used_beats: set[str] = set()

    for index, message in enumerate(messages):
        path = f"draft.messages[{index}]"
        speaker = message["speaker_id"]
        beat_id = message["beat_id"]
        movement_id = message["conversation_move"]
        state_id = message["local_state"]
        if speaker not in participants:
            _issue(errors, "UNEXPECTED_PARTICIPANT", f"{path}.speaker_id", speaker)
        if beat_id not in beats:
            _issue(errors, "MESSAGE_BEAT_UNKNOWN", f"{path}.beat_id", beat_id)
        else:
            used_beats.add(beat_id)
        if message["objective_actor_id"] != speaker or speaker not in objectives:
            _issue(errors, "MESSAGE_OBJECTIVE_INVALID", f"{path}.objective_actor_id", speaker)
        movement = movements.get(movement_id)
        if movement_id not in plan["movement_ids"] or movement is None:
            _issue(errors, "MESSAGE_MOVEMENT_UNKNOWN", f"{path}.conversation_move", movement_id)
        elif movement["actor_id"] != speaker:
            _issue(errors, "MESSAGE_MOVEMENT_ACTOR_MISMATCH", f"{path}.conversation_move", speaker)
        state = states.get(state_id)
        if state is None:
            _issue(errors, "MESSAGE_LOCAL_STATE_UNKNOWN", f"{path}.local_state", state_id)
        elif movement_id not in state["movement_ids"]:
            _issue(errors, "MESSAGE_LOCAL_STATE_INCOMPATIBLE", f"{path}.local_state", movement_id)
        for fact_id in message["fact_refs"]:
            fact = shared_facts.get(fact_id)
            if fact_id in forbidden_facts or fact_id not in usable_facts or fact is None:
                _issue(errors, "FACT_NOT_AUTHORIZED", f"{path}.fact_refs", fact_id)
            elif speaker not in fact["known_by"]:
                _issue(errors, "FACT_NOT_KNOWN_BY_SPEAKER", f"{path}.fact_refs", f"{speaker}: {fact_id}")
        if message["kind"] != "TEXT" or message["media"] is not None:
            _issue(errors, "MEDIA_FORBIDDEN", path, "media_decision NONE")
        reply_to = message["reply_to"]
        if reply_to is not None:
            if reply_to not in message_index or message_index[reply_to] >= index:
                _issue(errors, "REPLY_REFERENCE_INVALID", f"{path}.reply_to", str(reply_to))
            else:
                replied_branch = messages[message_index[reply_to]]["branch"]
                if replied_branch != "COMMON" and replied_branch != message["branch"]:
                    _issue(errors, "REPLY_CROSSES_BRANCH", f"{path}.reply_to", str(reply_to))
        if len(message["text"]) > 120:
            _issue(warnings, "STYLE_LONG_BUBBLE", f"{path}.text", "bulle longue ou littéraire à relire")
        if speaker == "player" and FOLDED_TICKET_FACT_ID in message["fact_refs"]:
            possession_hits = _pattern_hits(
                message["text"].casefold(),
                PLAYER_FOLDED_TICKET_POSSESSION_PATTERNS,
            )
            if possession_hits:
                _issue(
                    errors,
                    "FOLDED_TICKET_POSSESSION_CONTRADICTION",
                    f"{path}.text",
                    possession_hits[0],
                )

    missing_beats = [beat_id for beat_id in beats if beat_id not in used_beats]
    if missing_beats:
        _issue(errors, "REQUIRED_BEAT_MISSING", "draft.messages", ", ".join(missing_beats))
    previous_beat_index = -1
    for index, message in enumerate(messages):
        current_beat_index = beat_order.get(message["beat_id"])
        if current_beat_index is None:
            continue
        if current_beat_index < previous_beat_index:
            _issue(
                errors,
                "BEAT_ORDER_REGRESSION",
                f"draft.messages[{index}].beat_id",
                message["beat_id"],
            )
        previous_beat_index = max(previous_beat_index, current_beat_index)

    option_branch_ids = {option["option_id"] for option in draft["choice"]["options"]}
    allowed_branches = {"COMMON", *option_branch_ids}
    for index, message in enumerate(messages):
        if message["branch"] not in allowed_branches:
            _issue(
                errors,
                "MESSAGE_BRANCH_UNKNOWN",
                f"draft.messages[{index}].branch",
                message["branch"],
            )

    burst_groups: dict[str, list[int]] = {}
    for index, message in enumerate(messages):
        if message["burst_id"] is not None:
            burst_groups.setdefault(message["burst_id"], []).append(index)
    if not burst_groups:
        _issue(warnings, "BURSTS_ABSENT", "draft.messages", "au moins une rafale naturelle attendue")
    elif not 3 <= len(burst_groups) <= 5:
        _issue(warnings, "BURST_COUNT_WARNING", "draft.messages", "trois à cinq rafales attendues")
    for burst_id, indexes in burst_groups.items():
        speakers = {messages[index]["speaker_id"] for index in indexes}
        branches = {messages[index]["branch"] for index in indexes}
        if len(indexes) < 2 or len(speakers) != 1 or indexes != list(range(indexes[0], indexes[-1] + 1)):
            _issue(errors, "BURST_INVALID", "draft.messages", burst_id)
        if len(branches) != 1:
            _issue(errors, "BURST_CROSSES_BRANCH", "draft.messages", burst_id)
    weak_count = sum(message["strength"] == "WEAK" for message in messages)
    if weak_count == 0:
        _issue(warnings, "WEAK_MESSAGES_ABSENT", "draft.messages", "messages faibles absents")
    elif not 4 <= weak_count <= 8:
        _issue(warnings, "WEAK_MESSAGE_COUNT_WARNING", "draft.messages", "quatre à huit messages faibles attendus")

    player_count = sum(message["speaker_id"] == "player" for message in messages)
    sandra_count = sum(message["speaker_id"] == "sandra" for message in messages)
    if player_count >= sandra_count:
        _issue(warnings, "PLAYER_TOO_TALKATIVE", "draft.messages", "Player ne doit pas parler autant que Sandra")
    duplicate_texts = {
        message["text"].casefold()
        for message in messages
        if sum(other["text"].casefold() == message["text"].casefold() for other in messages) > 1
    }
    if duplicate_texts:
        _issue(warnings, "MESSAGES_REDUNDANT", "draft.messages", ", ".join(sorted(duplicate_texts)))

    complete_text = "\n".join(message["text"].casefold() for message in messages)
    authored_text = complete_text + "\n" + "\n".join(
        option["formulation"].casefold() for option in draft["choice"]["options"]
    )
    for phrase in _phrase_hits(authored_text, DIRECT_DECLARATIONS):
        _issue(errors, "DIRECT_ROMANTIC_DECLARATION", "draft.messages", phrase)
    for phrase in _pattern_hits(authored_text, DIRECT_DECLARATION_PATTERNS):
        _issue(errors, "DIRECT_ROMANTIC_DECLARATION", "draft.authored_text", phrase)
    for phrase in _phrase_hits(authored_text, ACQUIRED_MEETINGS):
        _issue(errors, "MEETING_PRESENTED_AS_ACQUIRED", "draft.messages", phrase)
    for phrase in _pattern_hits(authored_text, ACQUIRED_MEETING_PATTERNS):
        _issue(errors, "MEETING_PRESENTED_AS_ACQUIRED", "draft.authored_text", phrase)
    for phrase in _phrase_hits(authored_text, SILENCE_REPROACHES):
        _issue(errors, "SILENCE_USED_AS_REPROACH", "draft.messages", phrase)
    for phrase in _phrase_hits(authored_text, DURABLE_CONSEQUENCES):
        _issue(errors, "DURABLE_CONSEQUENCE_FORBIDDEN", "draft.messages", phrase)
    for phrase in _phrase_hits(authored_text, AFFECTIVE_DEMAND_MARKERS):
        _issue(errors, "AFFECTIVE_RESPONSE_DEMANDED", "draft.messages", phrase)
    for phrase in _pattern_hits(authored_text, AFFECTIVE_DEMAND_PATTERNS):
        _issue(errors, "AFFECTIVE_RESPONSE_DEMANDED", "draft.authored_text", phrase)
    for phrase in _phrase_hits(authored_text, IMMEDIATE_SEDUCTION_MARKERS):
        _issue(errors, "IMMEDIATE_SEDUCTION_FORBIDDEN", "draft.messages", phrase)

    explanatory_count = sum(
        any(marker in message["text"].casefold() for marker in EXPLANATORY_MARKERS)
        for message in messages
    )
    if explanatory_count >= 3:
        _issue(warnings, "TOO_MANY_EXPLANATORY_MESSAGES", "draft.messages", str(explanatory_count))
    mechanical_humor_count = sum(
        any(marker in message["text"].casefold() for marker in MECHANICAL_HUMOR_MARKERS)
        for message in messages
    )
    if mechanical_humor_count >= 4:
        _issue(warnings, "HUMOR_MECHANICAL", "draft.messages", str(mechanical_humor_count))
    if (
        sum(marker in complete_text for marker in ROMANTIC_TENSION_MARKERS) >= 2
        and not any(marker in complete_text for marker in CONCRETE_STAKE_MARKERS)
    ):
        _issue(warnings, "ROMANTIC_SUBTEXT_ONLY_TENSION", "draft.messages", "enjeu concret absent")
    closing_text = "\n".join(message["text"].casefold() for message in messages[-8:])
    if any(marker in closing_text for marker in PERFECT_EXIT_MARKERS):
        _issue(warnings, "EXIT_TOO_PERFECT", "draft.messages", "conserver une réserve locale")
    beat_counts = {
        beat_id: sum(message["beat_id"] == beat_id for message in messages)
        for beat_id in beats
    }
    if beat_counts and max(beat_counts.values()) > max(18, int(len(messages) * 0.4)):
        _issue(warnings, "BEAT_OVERFILLED", "draft.messages", "trop de bulles remplissent la même fonction")
    sandra_text = "\n".join(
        message["text"].casefold()
        for message in messages
        if message["speaker_id"] == "sandra"
    )
    if sum(marker in sandra_text for marker in THEATRICAL_MARKERS) >= 2:
        _issue(warnings, "SANDRA_THEATRICAL", "draft.messages", "Sandra devient théâtrale")
    if any(marker in sandra_text for marker in UNRESERVED_AVAILABILITY_MARKERS):
        _issue(warnings, "SANDRA_UNRESERVED_AVAILABILITY", "draft.messages", "réserve de Sandra absente")
    player_text = "\n".join(
        message["text"].casefold()
        for message in messages
        if message["speaker_id"] == "player"
    )
    if any(marker in player_text for marker in PLAYER_PERFECT_MARKERS):
        _issue(warnings, "PLAYER_TOO_PERFECT", "draft.messages", "intention formulée trop parfaitement")

    choice = draft["choice"]
    plan_choice = plan["choice"]
    expected_option_ids = [option["option_id"] for option in plan_choice["options"]]
    actual_option_ids = [option["option_id"] for option in choice["options"]]
    if choice["choice_id"] != plan_choice["choice_id"]:
        _issue(errors, "CHOICE_ID_MISMATCH", "draft.choice.choice_id", plan_choice["choice_id"])
    if actual_option_ids != expected_option_ids:
        _issue(errors, "CHOICE_OPTION_MISMATCH", "draft.choice.options", "attitudes du plan attendues dans leur ordre")
    formulations = [option["formulation"] for option in choice["options"]]
    if len({formulation.casefold() for formulation in formulations}) != 2:
        _issue(errors, "CHOICE_FORMULATIONS_NOT_DISTINCT", "draft.choice.options", "formulations distinctes requises")
    for index, formulation in enumerate(formulations):
        if len(formulation) > 70:
            _issue(warnings, "CHOICE_FORMULATION_LONG", f"draft.choice.options[{index}].formulation", "formulation courte attendue")
        for marker in PROMISE_MARKERS:
            if marker in formulation.casefold():
                _issue(errors, "CHOICE_PROMISE_FORBIDDEN", f"draft.choice.options[{index}].formulation", marker)

    after_id = choice["after_message_id"]
    converge_id = choice["converge_at_message_id"]
    if after_id not in message_index or converge_id not in message_index:
        _issue(errors, "CHOICE_MESSAGE_REFERENCE_UNKNOWN", "draft.choice", "ancrage ou convergence inconnu")
    else:
        after_index = message_index[after_id]
        converge_index = message_index[converge_id]
        if messages[after_index]["beat_id"] != plan_choice["after_beat_id"]:
            _issue(errors, "CHOICE_BEAT_MISMATCH", "draft.choice.after_message_id", plan_choice["after_beat_id"])
        if messages[converge_index]["branch"] != "COMMON":
            _issue(errors, "CHOICE_CONVERGENCE_BRANCH_INVALID", "draft.choice.converge_at_message_id", "COMMON attendu")
        reception_texts: list[tuple[str, ...]] = []
        reception_moves: list[tuple[str, ...]] = []
        all_reception_ids: set[str] = set()
        for option in choice["options"]:
            option_texts: list[str] = []
            option_moves: list[str] = []
            if not option["reception_message_ids"]:
                _issue(
                    errors,
                    "CHOICE_RECEPTION_MISSING",
                    "draft.choice.options",
                    option["option_id"],
                )
            elif len(option["reception_message_ids"]) < 2:
                _issue(
                    warnings,
                    "CHOICE_RECEPTION_WEAK",
                    "draft.choice.options",
                    option["option_id"],
                )
            for reception_id in option["reception_message_ids"]:
                if reception_id in all_reception_ids:
                    _issue(errors, "CHOICE_RECEPTION_REUSED", "draft.choice.options", reception_id)
                all_reception_ids.add(reception_id)
                if reception_id not in message_index:
                    _issue(errors, "CHOICE_RECEPTION_UNKNOWN", "draft.choice.options", reception_id)
                    continue
                reception_index = message_index[reception_id]
                reception = messages[reception_index]
                if not after_index < reception_index < converge_index:
                    _issue(errors, "CHOICE_RECEPTION_ORDER_INVALID", "draft.choice.options", reception_id)
                if reception["branch"] != option["option_id"] or reception["speaker_id"] != "sandra":
                    _issue(errors, "CHOICE_RECEPTION_BRANCH_INVALID", "draft.choice.options", reception_id)
                if reception["beat_id"] != "reception":
                    _issue(errors, "CHOICE_RECEPTION_BEAT_INVALID", "draft.choice.options", reception_id)
                option_texts.append(reception["text"].casefold())
                option_moves.append(reception["conversation_move"])
            reception_texts.append(tuple(option_texts))
            reception_moves.append(tuple(option_moves))
        for index, message in enumerate(messages):
            message_id = message["message_id"]
            branch = message["branch"]
            if index <= after_index or index >= converge_index:
                if branch != "COMMON":
                    _issue(
                        errors,
                        "MESSAGE_BRANCH_OUTSIDE_CHOICE",
                        f"draft.messages[{index}].branch",
                        branch,
                    )
            elif branch not in option_branch_ids:
                _issue(
                    errors,
                    "MESSAGE_BRANCH_EXPECTED",
                    f"draft.messages[{index}].branch",
                    branch,
                )
            elif message_id not in all_reception_ids:
                _issue(
                    errors,
                    "BRANCHED_MESSAGE_NOT_DECLARED",
                    f"draft.messages[{index}].message_id",
                    message_id,
                )
        if converge_index <= after_index:
            _issue(errors, "CHOICE_CONVERGENCE_ORDER_INVALID", "draft.choice", "convergence trop tôt")
        elif beat_order.get(messages[converge_index]["beat_id"], -1) <= beat_order.get("reception", -1):
            _issue(errors, "CHOICE_CONVERGENCE_NOT_ALLOWED", "draft.choice", "un battement commun postérieur à la réception est requis")
        if len(reception_texts) == 2 and (
            reception_texts[0] == reception_texts[1]
            or (reception_moves[0] == reception_moves[1] and set(reception_texts[0]) == set(reception_texts[1]))
        ):
            _issue(warnings, "CHOICE_RECEPTION_COSMETIC", "draft.choice.options", "réceptions trop similaires")

    hook_fact = plan["hook"]["fact_id"]
    hook_beats = {
        message["beat_id"]
        for message in messages
        if hook_fact in message["fact_refs"]
    }
    if hook_beats.issubset({"concrete_hook"}):
        _issue(warnings, "CONCRETE_DETAIL_WITHOUT_FUNCTION", "draft.messages", hook_fact)
    sandra_dialogue = "\n".join(
        message["text"].casefold()
        for message in messages
        if message["speaker_id"] == "sandra"
    )
    missing_text_signatures = [
        signature_id
        for signature_id, markers in SANDRA_DIALOGUE_TEXT_SIGNATURES.items()
        if not any(marker in sandra_dialogue for marker in markers)
    ]
    if hook_fact != FOLDED_TICKET_FACT_ID or missing_text_signatures:
        _issue(
            errors,
            "DIALOGUE_INTERCHANGEABLE",
            "draft.messages",
            ", ".join(missing_text_signatures) or hook_fact,
        )
    relationship_states = {
        state["state_id"]: state
        for state in workspace["relationship_register"]["relationship"]["local_states"]
    }
    active_strategy = relationship_states.get(plan["initial_state_id"], {}).get(
        "strategy",
        "",
    ).casefold()
    missing_strategy_signatures = [
        signature_id
        for signature_id, markers in SANDRA_RELATIONAL_STRATEGY_SIGNATURES.items()
        if not any(marker in active_strategy for marker in markers)
    ]
    if missing_strategy_signatures:
        _issue(
            errors,
            "DIALOGUE_RELATIONAL_STRATEGY_INCOMPATIBLE",
            "relationship.local_states.strategy",
            ", ".join(missing_strategy_signatures),
        )
    specificity = dialogue_specificity(workspace)
    for issue in specificity["sandra"]:
        _issue(
            errors,
            "DIALOGUE_SANDRA_CONTRACT_INCOMPATIBLE",
            issue["path"],
            f"{issue['code']}: {issue['message']}",
        )
    for foreign_name in ("marie", "mathilde"):
        foreign_codes = {issue["code"] for issue in specificity[foreign_name]}
        missing_codes = FOREIGN_DIALOGUE_SPECIFICITY_CODES - foreign_codes
        if missing_codes:
            _issue(
                errors,
                "DIALOGUE_INTERCHANGEABLE",
                "draft.messages",
                f"{foreign_name}: preuves absentes={sorted(missing_codes)}",
            )
    if any(marker in "\n".join(message["text"].casefold() for message in messages if message["speaker_id"] == "sandra") for marker in ("je veux te voir", "j'ai des sentiments")):
        _issue(warnings, "SANDRA_TOO_DIRECT", "draft.messages", "Sandra devient trop déclarative")

    return _validation_result(workspace, errors, warnings)


def validate_approval(workspace: Mapping[str, Any]) -> list[Issue]:
    issues = validate_composite_approval_format(workspace["approval"])
    if issues:
        return issues
    approval = workspace["approval"]
    draft = workspace["draft"]
    report = workspace["validation_report"]
    if approval["draft_id"] != draft["draft_id"]:
        _issue(issues, "APPROVAL_DRAFT_MISMATCH", "approval.draft_id", draft["draft_id"])
    if approval["draft_revision"] != draft["revision"]:
        _issue(issues, "APPROVAL_REVISION_MISMATCH", "approval.draft_revision", draft["revision"])
    generated = validate_draft(workspace)
    if report != generated:
        _issue(issues, "VALIDATION_REPORT_STALE", "validation_report", "le rapport exact doit être régénéré")
    review = approval["human_review"]
    expected_checks = [(question_id, question, response) for question_id, question, response in REVIEW_QUESTIONS]
    actual_checks = [
        (check["question_id"], check["question"], check["response"])
        for check in review["checks"]
    ]
    if actual_checks != expected_checks:
        _issue(issues, "HUMAN_REVIEW_INCOMPLETE", "approval.human_review.checks", "les dix questions et réponses attendues sont requises")
    if review["status"] == "APPROVED_FOR_A6_TEST_EXPORT" and (
        report["status"] == "BLOCKED" or report["blocking_errors"]
    ):
        _issue(issues, "BLOCKED_DRAFT_APPROVED", "approval.human_review.status", report["status"])
    plan_options = [option["option_id"] for option in workspace["planning"]["plan"]["choice"]["options"]]
    mapping_options = [mapping["option_id"] for mapping in approval["projection_config"]["choice_mappings"]]
    if mapping_options != plan_options:
        _issue(issues, "PROJECTION_CHOICE_MISMATCH", "approval.projection_config.choice_mappings", "options du plan attendues")
    expected_fingerprint = composite_approval_fingerprint(workspace)
    if approval["approval_fingerprint"] != expected_fingerprint:
        _issue(issues, "APPROVAL_FINGERPRINT_STALE", "approval.approval_fingerprint", expected_fingerprint)
    return issues


def render_human_review(workspace: Mapping[str, Any]) -> str:
    approval = workspace["approval"]
    review = approval["human_review"]
    lines = [
        "# R8C-A11.4 — Relecture humaine du brouillon Sandra",
        "",
        f"> **Brouillon :** `{approval['draft_id']}` — `{approval['draft_revision']}`",
        f"> **Statut :** `{review['status']}`",
        f"> **Relecteur :** `{review['reviewed_by']}`",
        f"> **Empreinte composite :** `{approval['approval_fingerprint']}`",
        "",
        "## Grille",
        "",
    ]
    expected_responses = {
        question_id: expected_response
        for question_id, _question, expected_response in REVIEW_QUESTIONS
    }
    for check in review["checks"]:
        mark = "x" if check["response"] == expected_responses.get(check["question_id"]) else " "
        lines.append(f"- [{mark}] {check['question']} — **{check['response']}** — {check['notes']}")
    lines.extend(["", "## Notes", ""])
    lines.extend(f"- {note}" for note in review["notes"])
    return "\n".join(lines) + "\n"


def _build_a6_bundle(workspace: Mapping[str, Any]) -> dict[str, Any]:
    plan = workspace["planning"]["plan"]
    draft = workspace["draft"]
    config = workspace["approval"]["projection_config"]
    mappings = {mapping["option_id"]: mapping for mapping in config["choice_mappings"]}
    normalized_choices = [
        {
            "option_id": option["option_id"],
            "formulation": option["formulation"],
            "signal": mappings[option["option_id"]]["signal"],
            "reception_interpretation": mappings[option["option_id"]]["reception_interpretation"],
        }
        for option in draft["choice"]["options"]
    ]
    return build_a6_scene_library(
        scene_definition_id=config["scene_definition_id"],
        variant_id=config["variant_id"],
        version_contract=config["version_contract"],
        title=plan["title"],
        nature=config["nature"],
        function=config["function"],
        participant_ids=plan["participant_ids"],
        compatible_act_ids=config["compatible_act_ids"],
        required_event_ids=config["required_event_ids"],
        forbidden_event_ids=config["forbidden_event_ids"],
        start_date=config["start_date"],
        end_date=config["end_date"],
        opening_time=config["opening_time"],
        closing_time=config["closing_time"],
        duration_minutes=config["duration_minutes"],
        uniqueness=config["uniqueness"],
        relation_or_question=workspace["planning"]["intention"]["desired_motion"],
        stable_core=plan["hook"]["description"],
        structure_id=plan["plan_id"],
        choices=normalized_choices,
        expiration_policy=config["expiration_policy"],
    )


def build_projection_report(
    workspace: Mapping[str, Any],
    bundle: Mapping[str, Any],
) -> dict[str, Any]:
    approval = workspace["approval"]
    config = approval["projection_config"]
    draft = workspace["draft"]
    return {
        "format": FORMAT_PROJECTION_REPORT,
        "version": VERSION,
        "approval_fingerprint": approval["approval_fingerprint"],
        "draft_id": draft["draft_id"],
        "draft_revision": draft["revision"],
        "scene_definition_id": config["scene_definition_id"],
        "variant_id": config["variant_id"],
        "canonical_json_sha256": _sha256(bundle),
        "exported_elements": [
            {
                "source": "planning.plan participant_ids and approved projection identity",
                "target": "A6 definition identity, variant and participants_requis",
                "detail": "Sandra and Player remain the only active participants.",
            },
            {
                "source": "draft.choice formulations and projection choice_mappings",
                "target": "A6 choix and resolutions",
                "detail": "Both attitudes keep distinct Sandra receptions before common convergence.",
            },
            {
                "source": "planning maximum_change and protective_close",
                "target": "local non-persistent resolutions without relational facts",
                "detail": "The possible meeting remains revocable and is not exported as an acquired fact.",
            },
        ],
        "unrepresentable_elements": [
            {
                "source": "draft.messages",
                "reason": "The closed A6/A3 definition schema has no dialogue bubble collection.",
                "preserved_in": "R8C_A11_DIALOGUE_DRAFT version 2",
            },
            {
                "source": "message beat, objective, move, local state, burst, weak and reply metadata",
                "reason": "A6 represents eligibility and local resolutions, not authoring traceability.",
                "preserved_in": "A11.4 draft and validation report",
            },
            {
                "source": "human review rationale and composite source evidence",
                "reason": "Editorial approval evidence is intentionally excluded from player/runtime data.",
                "preserved_in": "A11.4 composite approval and human review",
            },
        ],
        "preserved_invariants": [
            "synthetic non-canonical fixture loaded only by explicit path",
            "scene and variant identities remain explicit and distinct",
            "Sandra and Player are the only participants",
            "exactly two authored choices map to two distinct Sandra receptions",
            "all resolutions are local, non-persistent and contain no relational fact",
            "both branches return to the common core",
            "no meeting is acquired and no durable consequence is created",
            "static validation creates no A5 instance",
        ],
    }


def export_a6(workspace: Mapping[str, Any]) -> tuple[dict[str, Any], dict[str, Any]]:
    approval_issues = validate_approval(workspace)
    if approval_issues:
        raise A114ApprovalError(
            "A6 export refused: " + ", ".join(sorted({issue.code for issue in approval_issues}))
        )
    if workspace["approval"]["human_review"]["status"] != "APPROVED_FOR_A6_TEST_EXPORT":
        raise A114ApprovalError("A6 export refused: human review has not approved this exact revision")
    bundle = _build_a6_bundle(workspace)
    return bundle, build_projection_report(workspace, bundle)


def validate_json_library() -> dict[str, Any]:
    workspace = load_workspace(**default_paths())
    report = validate_draft(workspace)
    if report != workspace["validation_report"]:
        raise A114ValidationError([Issue("VALIDATION_REPORT_STALE", "validation_report", "fixture différente")])
    approval_issues = validate_approval(workspace)
    if approval_issues:
        raise A114ValidationError(approval_issues)
    bundle, projection_report = export_a6(workspace)
    if bundle != _read_json(A6_FIXTURE_PATH):
        raise A114ValidationError([Issue("A6_FIXTURE_STALE", str(A6_FIXTURE_PATH), "export différent")])
    if projection_report != workspace["projection_report"]:
        raise A114ValidationError([Issue("PROJECTION_REPORT_STALE", "projection_report", "rapport différent")])
    expected_review = render_human_review(workspace)
    if expected_review != HUMAN_REVIEW_PATH.read_text(encoding="utf-8"):
        raise A114ValidationError([Issue("HUMAN_REVIEW_STALE", str(HUMAN_REVIEW_PATH), "rendu différent")])
    return {
        "ok": True,
        "draft_id": workspace["draft"]["draft_id"],
        "revision": workspace["draft"]["revision"],
        "approval_fingerprint": workspace["approval"]["approval_fingerprint"],
    }


def run_smoke() -> dict[str, Any]:
    workspace = load_workspace(**default_paths())
    first = validate_draft(workspace)
    second = validate_draft(workspace)
    if first != second or first != workspace["validation_report"]:
        raise AssertionError("validation déterministe ou fixture de rapport invalide")
    refused = copy.deepcopy(workspace)
    refused["approval"]["human_review"]["status"] = "DRAFT"
    refused["approval"]["approval_fingerprint"] = composite_approval_fingerprint(refused)
    try:
        export_a6(refused)
    except A114ApprovalError:
        refused_before_approval = True
    else:
        refused_before_approval = False
    if not refused_before_approval:
        raise AssertionError("export autorisé avant approbation humaine")
    bundle, projection_report = export_a6(workspace)
    if bundle != _read_json(A6_FIXTURE_PATH):
        raise AssertionError("fixture A6 différente de la révision approuvée")
    if projection_report != workspace["projection_report"]:
        raise AssertionError("rapport de projection différent")
    messages = workspace["draft"]["messages"]
    return {
        "ok": True,
        "bubble_count": len(messages),
        "burst_count": len({message["burst_id"] for message in messages if message["burst_id"]}),
        "weak_message_count": sum(message["strength"] == "WEAK" for message in messages),
        "beat_count": len({message["beat_id"] for message in messages}),
        "choice_formulations": [option["formulation"] for option in workspace["draft"]["choice"]["options"]],
        "approval_fingerprint": workspace["approval"]["approval_fingerprint"],
        "a6_scene_definition_id": bundle["definitions"][0]["scene_definition_id"],
        "dialogue_specificity": {
            name: sorted({issue["code"] for issue in issues})
            for name, issues in dialogue_specificity(workspace).items()
        },
    }


def _emit(value: Any) -> None:
    print(json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True))


def _write_export_pair(
    bundle: Mapping[str, Any],
    projection_report: Mapping[str, Any],
    output_path: Path,
    projection_report_path: Path,
) -> None:
    if output_path.resolve() == projection_report_path.resolve():
        raise A114ApprovalError("bundle and projection report outputs must be distinct")
    if output_path.is_symlink() or projection_report_path.is_symlink():
        raise A114ApprovalError("symbolic-link export targets are refused")
    temporary_paths: list[Path] = []
    try:
        for target, value in (
            (output_path, bundle),
            (projection_report_path, projection_report),
        ):
            target.parent.mkdir(parents=True, exist_ok=True)
            with tempfile.NamedTemporaryFile(
                mode="w",
                encoding="utf-8",
                newline="\n",
                dir=target.parent,
                prefix=f".{target.name}.",
                suffix=".tmp",
                delete=False,
            ) as handle:
                handle.write(json.dumps(value, ensure_ascii=False, indent=2) + "\n")
                temporary_paths.append(Path(handle.name))
        temporary_paths[0].replace(output_path)
        temporary_paths[1].replace(projection_report_path)
    finally:
        for temporary_path in temporary_paths:
            temporary_path.unlink(missing_ok=True)


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Offline R8C-A11.4 plan-to-draft and A6 test export")
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("validate-json")
    subparsers.add_parser("validate")
    subparsers.add_parser("review")
    export_parser = subparsers.add_parser("export")
    export_parser.add_argument("--dry-run", action="store_true")
    export_parser.add_argument("--output", type=Path)
    export_parser.add_argument("--projection-report-output", type=Path)
    subparsers.add_parser("smoke")
    args = parser.parse_args(argv)
    try:
        workspace = load_workspace(**default_paths())
        if args.command == "validate-json":
            _emit(validate_json_library())
        elif args.command == "validate":
            _emit(validate_draft(workspace))
        elif args.command == "review":
            print(render_human_review(workspace), end="")
        elif args.command == "export":
            bundle, projection_report = export_a6(workspace)
            if (args.output is None) != (args.projection_report_output is None):
                raise A114ApprovalError("both export output paths are required together")
            if args.output is not None and not args.dry_run:
                _write_export_pair(
                    bundle,
                    projection_report,
                    args.output,
                    args.projection_report_output,
                )
            else:
                _emit({"a6_bundle": bundle, "projection_report": projection_report})
        else:
            _emit(run_smoke())
    except (A114ValidationError, A114ApprovalError, AssertionError, OSError) as exc:
        print(f"A11.4_ERROR: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
