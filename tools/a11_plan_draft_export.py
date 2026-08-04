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
        planning_fingerprint,
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
    from a11_scene_planning import (  # type: ignore
        load_planning_case,
        planning_fingerprint,
        validate_scene_plan,
    )
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
PILOT_DIR = ROOT / "narrative_tool" / "a11" / "pilots"
PILOT_SOURCE_PATH = PILOT_DIR / "sandra_blue_chairs.source.json"
PILOT_PROVENANCE_PATH = PILOT_DIR / "sandra_blue_chairs.provenance.json"
PILOT_PLAN_PATH = ROOT / "narrative_tool" / "a11" / "planning" / "sandra_blue_chairs.json"
PILOT_DRAFT_PATH = DRAFTING_DIR / "sandra_blue_chairs.draft.json"
PILOT_VALIDATION_PATH = DRAFTING_DIR / "sandra_blue_chairs.validation_report.json"
PILOT_TRACEABILITY_PATH = DRAFTING_DIR / "sandra_blue_chairs.traceability_report.json"
PILOT_BLIND_READING_PATH = DRAFTING_DIR / "sandra_blue_chairs.blind_reading.md"
PILOT_HUMAN_REVIEW_PATH = DRAFTING_DIR / "sandra_blue_chairs.human_review.md"
PILOT_DECISION_PATH = DRAFTING_DIR / "sandra_blue_chairs.canon_decision.json"
N2_DIR = ROOT / "narrative_tool" / "a11" / "revisions"
N2_LOCKED_SOURCE_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.locked.md"
N2_SOURCE_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.source.json"
N2_PROVENANCE_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.provenance.json"
N2_PLAN_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.plan_projection.json"
N2_DRAFT_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.draft.json"
N2_VALIDATION_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.validation_report.json"
N2_COMPARISON_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.comparison_report.json"
N2_TRACEABILITY_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.traceability_report.json"
N2_BLIND_READING_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.blind_reading.md"
N2_HUMAN_REVIEW_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.human_review.md"
N2_DECISION_PATH = N2_DIR / "sandra_blue_chairs_r8c_n2.canon_decision.json"

FORMAT_COMPOSITE_APPROVAL = "R8C_A11_COMPOSITE_APPROVAL"
FORMAT_PROJECTION_REPORT = "R8C_A11_A6_PROJECTION_REPORT"
FORMAT_EDITORIAL_SOURCE = "R8C_A11_EDITORIAL_SOURCE"
FORMAT_NARRATIVE_PROVENANCE = "R8C_A11_NARRATIVE_PROVENANCE"
FORMAT_EDITORIAL_VALIDATION = "R8C_A11_EDITORIAL_VALIDATION_REPORT"
FORMAT_EDITORIAL_TRACEABILITY = "R8C_A11_EDITORIAL_TRACEABILITY_REPORT"
FORMAT_CANON_DECISION = "R8C_A11_CANON_REVIEW_DECISION"
FORMAT_N2_COMPARISON = "R8C_N2_NARRATIVE_COMPARISON_REPORT"
VERSION = 1
VALIDATOR_VERSION = "a11-plan-draft-validator-1.2"
EDITORIAL_VALIDATOR_VERSION = "a11-first-editorial-pilot-validator-1.0"
N2_VALIDATOR_VERSION = "r8c-n2-sandra-blue-chairs-validator-1.1"
N2_REVIEWED_COMMIT = "128d49ffa210b58f698188860b247b5df6856aca"
N2_FINAL_CANONICAL_CORRECTION = {
    "message_id": "m91",
    "before": "bonne soirée, Ludo",
    "after": "bonne soirée",
    "resolution": "FALLBACK_NO_CANONICAL_PLAYER_NAME_TOKEN",
}
REVIEW_STATUSES = {
    "DRAFT",
    "NEEDS_REVISION",
    "APPROVED_FOR_A6_TEST_EXPORT",
    "REJECTED",
}
CANON_REVIEW_STATUSES = {
    "DRAFT",
    "NEEDS_NARRATIVE_REVISION",
    "APPROVED_FOR_CANON_REVIEW",
    "REJECTED",
}
N2_REVIEW_STATUSES = {
    "NEEDS_NARRATIVE_REVISION",
    "CANON_APPROVED",
    "REJECTED",
}
N2_PROFILE = {
    "lot_label": "R8C-N2",
    "validator_version": N2_VALIDATOR_VERSION,
    "expected_stored_count": 96,
    "expected_path_counts": {"careful_warmth": 90, "ironic_withdrawal": 89},
    "expected_after_message_id": "m46",
    "expected_converge_at_message_id": "m53",
}
EDITORIAL_BEAT_IDS = (
    "concrete_photo",
    "familiar_complicity",
    "lightly_charged_memory",
    "indirect_relaunch",
    "sandra_test_and_choice",
    "reception_and_limit",
    "protective_exit",
)
EDITORIAL_SOURCE_KEYS = {
    "format",
    "version",
    "source_id",
    "title",
    "media",
    "pre_choice_messages",
    "choice",
    "convergence_messages",
}
EDITORIAL_SOURCE_MEDIA_KEYS = {"media_id", "kind", "description"}
EDITORIAL_SOURCE_MESSAGE_KEYS = {"message_id", "speaker_id", "kind", "text"}
EDITORIAL_SOURCE_CHOICE_KEYS = {
    "choice_id",
    "after_message_id",
    "options",
    "converge_at_message_id",
}
EDITORIAL_SOURCE_OPTION_KEYS = {
    "option_id",
    "formulation",
    "reception_messages",
}
PROVENANCE_KEYS = {
    "format",
    "version",
    "provenance_id",
    "source_id",
    "source_content_sha256",
    "canonical_inputs",
    "local_facts",
    "limits",
    "non_persistent_elements",
}
PROVENANCE_CANONICAL_KEYS = {"input_id", "text", "source_ref"}
PROVENANCE_LOCAL_FACT_KEYS = {"fact_id", "text", "known_by", "persistence"}
PROVENANCE_LIMIT_KEYS = {"limit_id", "text"}
PROVENANCE_NON_PERSISTENT_KEYS = {"element_id", "description"}
EDITORIAL_VALIDATION_KEYS = {
    "format",
    "version",
    "validator_version",
    "source_id",
    "draft_id",
    "draft_revision",
    "source_content_sha256",
    "validation_fingerprint",
    "status",
    "blocking_errors",
    "warnings",
    "counts",
}
EDITORIAL_COUNT_KEYS = {
    "stored_message_elements",
    "playable_path_elements",
    "burst_groups_stored",
    "burst_groups_by_path",
    "weak_messages_stored",
    "weak_messages_by_path",
    "beat_count",
}
EDITORIAL_TRACEABILITY_KEYS = {
    "format",
    "version",
    "source_content_sha256",
    "validation_fingerprint",
    "participant_ids",
    "counts",
    "beat_trace",
    "choice_trace",
    "media_trace",
    "fact_trace",
    "voice_validation",
    "narrative_integrity",
    "a6_export",
    "runtime_wiring",
}
CANON_DECISION_KEYS = {
    "format",
    "version",
    "draft_id",
    "draft_revision",
    "source_content_sha256",
    "validation_fingerprint",
    "status",
    "reviewed_by",
    "blind_reading_result",
    "narrative_remarks",
    "decision",
    "next_action",
    "decision_fingerprint",
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


def validate_editorial_source_format(
    document: Any,
    path: str = "source",
) -> list[Issue]:
    issues: list[Issue] = []
    if not _closed(document, EDITORIAL_SOURCE_KEYS, path, issues):
        return issues
    if document["format"] != FORMAT_EDITORIAL_SOURCE:
        _issue(issues, "FORMAT_UNKNOWN", f"{path}.format", FORMAT_EDITORIAL_SOURCE)
    if document["version"] != VERSION:
        _issue(issues, "VERSION_UNKNOWN", f"{path}.version", str(VERSION))
    for field in ("source_id", "title"):
        if not _nonempty(document[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.{field}", "chaîne non vide attendue")
    media = document["media"]
    if _closed(media, EDITORIAL_SOURCE_MEDIA_KEYS, f"{path}.media", issues):
        for field in EDITORIAL_SOURCE_MEDIA_KEYS:
            if not _nonempty(media[field]):
                _issue(issues, "TEXT_REQUIRED", f"{path}.media.{field}", "chaîne non vide attendue")

    all_messages: list[Mapping[str, Any]] = []

    def validate_messages(value: Any, value_path: str) -> None:
        if not isinstance(value, list) or not value:
            _issue(issues, "MESSAGE_LIST_REQUIRED", value_path, "tableau non vide attendu")
            return
        for index, message in enumerate(value):
            message_path = f"{value_path}[{index}]"
            if not _closed(message, EDITORIAL_SOURCE_MESSAGE_KEYS, message_path, issues):
                continue
            for field in EDITORIAL_SOURCE_MESSAGE_KEYS:
                if not _nonempty(message[field]):
                    _issue(issues, "TEXT_REQUIRED", f"{message_path}.{field}", "chaîne non vide attendue")
            if message["speaker_id"] not in {"player", "sandra"}:
                _issue(issues, "UNEXPECTED_PARTICIPANT", f"{message_path}.speaker_id", message["speaker_id"])
            if message["kind"] not in {"TEXT", "IMAGE"}:
                _issue(issues, "MESSAGE_KIND_UNKNOWN", f"{message_path}.kind", message["kind"])
            all_messages.append(message)

    validate_messages(document["pre_choice_messages"], f"{path}.pre_choice_messages")
    choice = document["choice"]
    if _closed(choice, EDITORIAL_SOURCE_CHOICE_KEYS, f"{path}.choice", issues):
        for field in ("choice_id", "after_message_id", "converge_at_message_id"):
            if not _nonempty(choice[field]):
                _issue(issues, "TEXT_REQUIRED", f"{path}.choice.{field}", "chaîne non vide attendue")
        options = choice["options"]
        if not isinstance(options, list) or len(options) != 2:
            _issue(issues, "CHOICE_OPTIONS_REQUIRED", f"{path}.choice.options", "deux options attendues")
        else:
            for index, option in enumerate(options):
                option_path = f"{path}.choice.options[{index}]"
                if not _closed(option, EDITORIAL_SOURCE_OPTION_KEYS, option_path, issues):
                    continue
                for field in ("option_id", "formulation"):
                    if not _nonempty(option[field]):
                        _issue(issues, "TEXT_REQUIRED", f"{option_path}.{field}", "chaîne non vide attendue")
                validate_messages(option["reception_messages"], f"{option_path}.reception_messages")
    validate_messages(document["convergence_messages"], f"{path}.convergence_messages")
    message_ids = [message["message_id"] for message in all_messages]
    if len(message_ids) != len(set(message_ids)):
        _issue(issues, "MESSAGE_ID_DUPLICATE", path, "identités dupliquées")
    image_ids = [message["message_id"] for message in all_messages if message["kind"] == "IMAGE"]
    if image_ids != ["m01"]:
        _issue(issues, "SOURCE_MEDIA_TOPOLOGY_INVALID", path, str(image_ids))
    return issues


def validate_provenance_format(
    document: Any,
    path: str = "provenance",
) -> list[Issue]:
    issues: list[Issue] = []
    if not _closed(document, PROVENANCE_KEYS, path, issues):
        return issues
    if document["format"] != FORMAT_NARRATIVE_PROVENANCE:
        _issue(issues, "FORMAT_UNKNOWN", f"{path}.format", FORMAT_NARRATIVE_PROVENANCE)
    if document["version"] != VERSION:
        _issue(issues, "VERSION_UNKNOWN", f"{path}.version", str(VERSION))
    for field in ("provenance_id", "source_id", "source_content_sha256"):
        if not _nonempty(document[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.{field}", "chaîne non vide attendue")
    specs = (
        ("canonical_inputs", PROVENANCE_CANONICAL_KEYS),
        ("local_facts", PROVENANCE_LOCAL_FACT_KEYS),
        ("limits", PROVENANCE_LIMIT_KEYS),
        ("non_persistent_elements", PROVENANCE_NON_PERSISTENT_KEYS),
    )
    for field, keys in specs:
        values = document[field]
        if not isinstance(values, list) or not values:
            _issue(issues, "OBJECT_LIST_REQUIRED", f"{path}.{field}", "tableau non vide attendu")
            continue
        for index, value in enumerate(values):
            value_path = f"{path}.{field}[{index}]"
            if not _closed(value, keys, value_path, issues):
                continue
            for key in keys - {"known_by"}:
                if not _nonempty(value[key]):
                    _issue(issues, "TEXT_REQUIRED", f"{value_path}.{key}", "chaîne non vide attendue")
            if "known_by" in keys:
                _string_list(value["known_by"], f"{value_path}.known_by", issues, nonempty=True)
    local_ids = [
        fact["fact_id"]
        for fact in document["local_facts"]
        if isinstance(fact, dict) and "fact_id" in fact
    ]
    if len(local_ids) != len(set(local_ids)):
        _issue(issues, "LOCAL_FACT_DUPLICATE", f"{path}.local_facts", "identités dupliquées")
    return issues


def editorial_source_projection(source: Mapping[str, Any]) -> dict[str, Any]:
    def normalized(message: Mapping[str, Any], branch: str) -> dict[str, str]:
        return {
            "message_id": message["message_id"],
            "speaker_id": message["speaker_id"],
            "kind": message["kind"],
            "text": message["text"],
            "branch": branch,
        }

    messages = [normalized(message, "COMMON") for message in source["pre_choice_messages"]]
    options = []
    for option in source["choice"]["options"]:
        reception_ids = [message["message_id"] for message in option["reception_messages"]]
        messages.extend(normalized(message, option["option_id"]) for message in option["reception_messages"])
        options.append({
            "option_id": option["option_id"],
            "formulation": option["formulation"],
            "reception_message_ids": reception_ids,
        })
    messages.extend(normalized(message, "COMMON") for message in source["convergence_messages"])
    return {
        "title": source["title"],
        "media": copy.deepcopy(source["media"]),
        "messages": messages,
        "choice": {
            "choice_id": source["choice"]["choice_id"],
            "after_message_id": source["choice"]["after_message_id"],
            "converge_at_message_id": source["choice"]["converge_at_message_id"],
            "options": options,
        },
    }


def editorial_draft_projection(workspace: Mapping[str, Any]) -> dict[str, Any]:
    draft = workspace["draft"]
    images = [message for message in draft["messages"] if message["kind"] == "IMAGE"]
    media = images[0]["media"] if len(images) == 1 and isinstance(images[0]["media"], dict) else {}
    return {
        "title": workspace["planning"]["plan"]["title"],
        "media": {
            "media_id": media.get("media_id"),
            "kind": media.get("kind"),
            "description": media.get("description"),
        },
        "messages": [
            {
                "message_id": message["message_id"],
                "speaker_id": message["speaker_id"],
                "kind": message["kind"],
                "text": message["text"],
                "branch": message["branch"],
            }
            for message in draft["messages"]
        ],
        "choice": {
            "choice_id": draft["choice"]["choice_id"],
            "after_message_id": draft["choice"]["after_message_id"],
            "converge_at_message_id": draft["choice"]["converge_at_message_id"],
            "options": [
                {
                    "option_id": option["option_id"],
                    "formulation": option["formulation"],
                    "reception_message_ids": list(option["reception_message_ids"]),
                }
                for option in draft["choice"]["options"]
            ],
        },
    }


def editorial_source_content_sha256(source: Mapping[str, Any]) -> str:
    return _sha256(editorial_source_projection(source))


def _editorial_calibration(provenance: Mapping[str, Any]) -> dict[str, Any]:
    calibration = load_calibration_case("sandra")
    for fact in provenance["local_facts"]:
        calibration["relationship"]["relationship"]["shared_facts"].append({
            "fact_id": fact["fact_id"],
            "text": fact["text"],
            "known_by": list(fact["known_by"]),
        })
        calibration["character"]["known_facts"].append({
            "fact_id": fact["fact_id"],
            "text": fact["text"],
            "source": "provenance locale R8C-A11.5 non persistante",
        })
    return calibration


def default_editorial_paths() -> dict[str, Path]:
    return {
        "source_path": PILOT_SOURCE_PATH,
        "provenance_path": PILOT_PROVENANCE_PATH,
        "plan_path": PILOT_PLAN_PATH,
        "draft_path": PILOT_DRAFT_PATH,
        "validation_path": PILOT_VALIDATION_PATH,
        "traceability_path": PILOT_TRACEABILITY_PATH,
        "decision_path": PILOT_DECISION_PATH,
    }


def load_editorial_pilot_workspace(
    source_path: Path = PILOT_SOURCE_PATH,
    provenance_path: Path = PILOT_PROVENANCE_PATH,
    plan_path: Path = PILOT_PLAN_PATH,
    draft_path: Path = PILOT_DRAFT_PATH,
    validation_path: Path = PILOT_VALIDATION_PATH,
    traceability_path: Path = PILOT_TRACEABILITY_PATH,
    decision_path: Path = PILOT_DECISION_PATH,
    *,
    include_outputs: bool = True,
) -> dict[str, Any]:
    source = _read_json(Path(source_path))
    provenance = _read_json(Path(provenance_path))
    planning = load_planning_case(Path(plan_path))
    draft = _read_json(Path(draft_path))
    issues = validate_editorial_source_format(source)
    issues.extend(validate_provenance_format(provenance))
    issues.extend(validate_draft_format(draft))
    if issues:
        raise A114ValidationError(issues)
    calibration = _editorial_calibration(provenance)
    workspace = {
        "source": source,
        "provenance": provenance,
        "planning": planning,
        "character_contract": calibration["character"],
        "relationship_register": calibration["relationship"],
        "foreign_calibrations": {
            name: {
                "character": foreign["character"],
                "relationship": foreign["relationship"],
            }
            for name in ("marie", "mathilde")
            for foreign in (load_calibration_case(name),)
        },
        "draft": draft,
        "validation_report": None,
        "traceability_report": None,
        "decision": None,
    }
    if include_outputs:
        workspace["validation_report"] = _read_json(Path(validation_path))
        workspace["traceability_report"] = _read_json(Path(traceability_path))
        workspace["decision"] = _read_json(Path(decision_path))
    return copy.deepcopy(workspace)


def editorial_validation_fingerprint(workspace: Mapping[str, Any]) -> str:
    payload = {
        "validator_version": EDITORIAL_VALIDATOR_VERSION,
        "source": workspace.get("source"),
        "provenance": workspace.get("provenance"),
        "planning": workspace.get("planning"),
        "draft": workspace.get("draft"),
        "character_contract": workspace.get("character_contract"),
        "relationship_register": workspace.get("relationship_register"),
        "foreign_calibrations": workspace.get("foreign_calibrations"),
    }
    profile = workspace.get("editorial_profile")
    if isinstance(profile, Mapping):
        payload["validator_version"] = profile.get("validator_version", EDITORIAL_VALIDATOR_VERSION)
        payload["editorial_profile"] = profile
    return _sha256(payload)


def _editorial_counts(workspace: Mapping[str, Any]) -> dict[str, Any]:
    draft = workspace.get("draft")
    draft = draft if isinstance(draft, Mapping) else {}
    messages = draft.get("messages")
    messages = messages if isinstance(messages, list) else []
    choice = draft.get("choice")
    choice = choice if isinstance(choice, Mapping) else {}
    options = choice.get("options")
    options = options if isinstance(options, list) else []
    option_ids = [
        option["option_id"]
        for option in options
        if isinstance(option, Mapping) and _nonempty(option.get("option_id"))
    ]

    def path_messages(option_id: str) -> list[Mapping[str, Any]]:
        return [
            message
            for message in messages
            if isinstance(message, Mapping) and message.get("branch") in {"COMMON", option_id}
        ]

    def burst_count(values: Sequence[Mapping[str, Any]]) -> int:
        return len({message.get("burst_id") for message in values if message.get("burst_id")})

    valid_messages = [message for message in messages if isinstance(message, Mapping)]
    planning = workspace.get("planning")
    planning = planning if isinstance(planning, Mapping) else {}
    plan = planning.get("plan")
    plan = plan if isinstance(plan, Mapping) else {}
    beats = plan.get("beats")
    beats = beats if isinstance(beats, list) else []

    return {
        "stored_message_elements": len(messages),
        "playable_path_elements": {option_id: len(path_messages(option_id)) for option_id in option_ids},
        "burst_groups_stored": burst_count(valid_messages),
        "burst_groups_by_path": {option_id: burst_count(path_messages(option_id)) for option_id in option_ids},
        "weak_messages_stored": sum(message.get("strength") == "WEAK" for message in valid_messages),
        "weak_messages_by_path": {
            option_id: sum(message.get("strength") == "WEAK" for message in path_messages(option_id))
            for option_id in option_ids
        },
        "beat_count": len(beats),
    }


def _editorial_validation_result(
    workspace: Mapping[str, Any],
    errors: Sequence[Issue],
    warnings: Sequence[Issue],
) -> dict[str, Any]:
    source = workspace.get("source")
    source = source if isinstance(source, Mapping) else {}
    draft = workspace.get("draft")
    draft = draft if isinstance(draft, Mapping) else {}
    try:
        source_hash = editorial_source_content_sha256(source)
    except (KeyError, TypeError, IndexError):
        source_hash = ""
    profile = workspace.get("editorial_profile")
    profile = profile if isinstance(profile, Mapping) else {}
    return {
        "format": FORMAT_EDITORIAL_VALIDATION,
        "version": VERSION,
        "validator_version": profile.get("validator_version", EDITORIAL_VALIDATOR_VERSION),
        "source_id": source.get("source_id", ""),
        "draft_id": draft.get("draft_id", ""),
        "draft_revision": draft.get("revision", ""),
        "source_content_sha256": source_hash,
        "validation_fingerprint": editorial_validation_fingerprint(workspace),
        "status": "BLOCKED" if errors else ("READY_WITH_WARNINGS" if warnings else "READY"),
        "blocking_errors": [issue.as_json() for issue in errors],
        "warnings": [issue.as_json() for issue in warnings],
        "counts": _editorial_counts(workspace),
    }


def validate_editorial_pilot(workspace: Mapping[str, Any]) -> dict[str, Any]:
    errors: list[Issue] = []
    warnings: list[Issue] = []
    profile = workspace.get("editorial_profile")
    profile = profile if isinstance(profile, Mapping) else {}
    expected_stored_count = int(profile.get("expected_stored_count", 98))
    expected_path_counts = profile.get(
        "expected_path_counts",
        {"careful_warmth": 93, "ironic_withdrawal": 93},
    )
    expected_after_message_id = profile.get("expected_after_message_id", "m46")
    expected_converge_at_message_id = profile.get("expected_converge_at_message_id", "m52")
    source = workspace["source"]
    provenance = workspace["provenance"]
    planning = workspace["planning"]
    draft = workspace["draft"]

    errors.extend(validate_editorial_source_format(source))
    errors.extend(validate_provenance_format(provenance))
    errors.extend(validate_draft_format(draft))
    if errors:
        return _editorial_validation_result(workspace, errors, warnings)

    plan = planning["plan"]
    messages = draft["messages"]
    relation = workspace["relationship_register"]["relationship"]

    source_hash = editorial_source_content_sha256(source)
    if provenance["source_id"] != source["source_id"]:
        _issue(errors, "PROVENANCE_SOURCE_MISMATCH", "provenance.source_id", source["source_id"])
    if provenance["source_content_sha256"] != source_hash:
        _issue(errors, "SOURCE_FINGERPRINT_MISMATCH", "provenance.source_content_sha256", source_hash)
    if editorial_draft_projection(workspace) != editorial_source_projection(source):
        _issue(errors, "SOURCE_CONTENT_MISMATCH", "draft", "le contenu intégré diffère de la source verrouillée")

    plan_report = validate_scene_plan(
        planning,
        {
            "character": workspace["character_contract"],
            "relationship": workspace["relationship_register"],
        },
        workspace["foreign_calibrations"],
    )
    for item in plan_report["blocking_errors"]:
        _issue(errors, item["code"], item["path"], item["message"])
    for item in plan_report["warnings"]:
        _issue(warnings, item["code"], item["path"], item["message"])
    if tuple(beat["beat_id"] for beat in plan["beats"]) != EDITORIAL_BEAT_IDS:
        _issue(errors, "EDITORIAL_BEAT_ORDER_INVALID", "planning.plan.beats", ", ".join(EDITORIAL_BEAT_IDS))
    if draft["plan_id"] != plan["plan_id"]:
        _issue(errors, "DRAFT_PLAN_MISMATCH", "draft.plan_id", plan["plan_id"])
    if set(plan["participant_ids"]) != {"player", "sandra"}:
        _issue(errors, "UNEXPECTED_PARTICIPANT", "planning.plan.participant_ids", "Sandra et Player uniquement")

    message_ids = [message["message_id"] for message in messages]
    message_index = {message_id: index for index, message_id in enumerate(message_ids)}
    if len(messages) != expected_stored_count:
        _issue(
            errors,
            "EDITORIAL_ELEMENT_COUNT_INVALID",
            "draft.messages",
            f"{expected_stored_count} éléments stockés attendus",
        )
    if len(message_ids) != len(set(message_ids)):
        _issue(errors, "MESSAGE_ID_DUPLICATE", "draft.messages", "identités dupliquées")
    beats = {beat["beat_id"]: beat for beat in plan["beats"]}
    beat_order = {beat_id: index for index, beat_id in enumerate(EDITORIAL_BEAT_IDS)}
    movements = {movement["movement_id"]: movement for movement in relation["movements"]}
    states = {state["state_id"]: state for state in relation["local_states"]}
    facts = {fact["fact_id"]: fact for fact in relation["shared_facts"]}
    usable_facts = set(plan["fact_policy"]["usable_fact_ids"])
    previous_beat = -1
    used_beats: set[str] = set()
    for index, message in enumerate(messages):
        path = f"draft.messages[{index}]"
        speaker = message["speaker_id"]
        beat_id = message["beat_id"]
        movement_id = message["conversation_move"]
        if speaker not in {"player", "sandra"}:
            _issue(errors, "UNEXPECTED_PARTICIPANT", f"{path}.speaker_id", speaker)
        if message["objective_actor_id"] != speaker:
            _issue(errors, "MESSAGE_OBJECTIVE_INVALID", f"{path}.objective_actor_id", speaker)
        if beat_id not in beats:
            _issue(errors, "MESSAGE_BEAT_UNKNOWN", f"{path}.beat_id", beat_id)
        else:
            used_beats.add(beat_id)
            current_beat = beat_order[beat_id]
            if current_beat < previous_beat:
                _issue(errors, "BEAT_ORDER_REGRESSION", f"{path}.beat_id", beat_id)
            previous_beat = max(previous_beat, current_beat)
        movement = movements.get(movement_id)
        if movement is None or movement["actor_id"] != speaker:
            _issue(errors, "MESSAGE_MOVEMENT_INCOMPATIBLE", f"{path}.conversation_move", movement_id)
        state = states.get(message["local_state"])
        if state is None or movement_id not in state["movement_ids"]:
            _issue(errors, "MESSAGE_LOCAL_STATE_INCOMPATIBLE", f"{path}.local_state", message["local_state"])
        for fact_id in message["fact_refs"]:
            fact = facts.get(fact_id)
            if fact is None or fact_id not in usable_facts:
                _issue(errors, "FACT_NOT_AUTHORIZED", f"{path}.fact_refs", fact_id)
            elif speaker not in fact["known_by"]:
                _issue(errors, "FACT_NOT_KNOWN_BY_SPEAKER", f"{path}.fact_refs", f"{speaker}: {fact_id}")
        reply_to = message["reply_to"]
        if reply_to is not None:
            if reply_to not in message_index or message_index[reply_to] >= index:
                _issue(errors, "REPLY_REFERENCE_INVALID", f"{path}.reply_to", str(reply_to))
            else:
                replied_branch = messages[message_index[reply_to]]["branch"]
                if replied_branch != "COMMON" and replied_branch != message["branch"]:
                    _issue(errors, "REPLY_CROSSES_BRANCH", f"{path}.reply_to", reply_to)
        if len(message["text"]) > 120:
            _issue(warnings, "STYLE_LONG_BUBBLE", f"{path}.text", "bulle longue à relire")
    if set(EDITORIAL_BEAT_IDS) != used_beats:
        _issue(errors, "REQUIRED_BEAT_MISSING", "draft.messages", ", ".join(sorted(set(EDITORIAL_BEAT_IDS) - used_beats)))

    local_ids = {fact["fact_id"] for fact in provenance["local_facts"]}
    if local_ids != {"local_cafe", "local_blue_chairs", "local_cold_fries", "local_terrace_photo"}:
        _issue(errors, "LOCAL_FACT_SET_INVALID", "provenance.local_facts", ", ".join(sorted(local_ids)))
    for index, fact in enumerate(provenance["local_facts"]):
        if fact["persistence"] != "SCENE_LOCAL_ONLY":
            _issue(errors, "LOCAL_FACT_BECAME_DURABLE", f"provenance.local_facts[{index}].persistence", fact["fact_id"])
        if set(fact["known_by"]) != {"player", "sandra"}:
            _issue(errors, "LOCAL_FACT_KNOWLEDGE_INVALID", f"provenance.local_facts[{index}].known_by", fact["fact_id"])

    media_messages = [message for message in messages if message["kind"] == "IMAGE"]
    requirement = plan["media_requirement"]
    if requirement["media_decision"] != "REQUIRED" or len(media_messages) != 1:
        _issue(errors, "MEDIA_REQUIRED", "draft.messages", "un média obligatoire attendu")
    elif media_messages[0]["message_id"] != "m01" or not isinstance(media_messages[0]["media"], dict):
        _issue(errors, "MEDIA_REQUIRED", "draft.messages", "m01 doit porter le média")
    else:
        media = media_messages[0]["media"]
        expected_media = source["media"]
        if (
            media["media_id"] != expected_media["media_id"]
            or media["kind"] != requirement["kind"]
            or media["description"] != expected_media["description"]
            or media["linked_fact_id"] != requirement["linked_fact_id"]
            or media["justification"] != requirement["justification"]
            or media["linked_fact_id"] not in media_messages[0]["fact_refs"]
        ):
            _issue(errors, "MEDIA_UNJUSTIFIED", "draft.messages[0].media", "média source, fait et justification exacts requis")

    choice = draft["choice"]
    option_ids = [option["option_id"] for option in choice["options"]]
    plan_option_ids = [option["option_id"] for option in plan["choice"]["options"]]
    if choice["choice_id"] != plan["choice"]["choice_id"] or option_ids != plan_option_ids:
        _issue(errors, "CHOICE_OPTION_MISMATCH", "draft.choice", "choix du plan attendu")
    if (
        choice["after_message_id"] != expected_after_message_id
        or choice["converge_at_message_id"] != expected_converge_at_message_id
    ):
        _issue(
            errors,
            "CHOICE_MESSAGE_REFERENCE_INVALID",
            "draft.choice",
            f"{expected_after_message_id} puis {expected_converge_at_message_id} attendus",
        )
    if any(len(option["formulation"]) > 70 for option in choice["options"]):
        _issue(errors, "CHOICE_FORMULATION_LONG", "draft.choice.options", "choix court requis")
    receptions: list[tuple[tuple[str, str], ...]] = []
    declared_receptions: set[str] = set()
    for option in choice["options"]:
        reception: list[tuple[str, str]] = []
        for reception_id in option["reception_message_ids"]:
            declared_receptions.add(reception_id)
            if reception_id not in message_index:
                _issue(errors, "CHOICE_RECEPTION_UNKNOWN", "draft.choice.options", reception_id)
                continue
            message = messages[message_index[reception_id]]
            if message["branch"] != option["option_id"]:
                _issue(errors, "CHOICE_RECEPTION_BRANCH_INVALID", "draft.choice.options", reception_id)
            reception.append((message["speaker_id"], message["text"].casefold()))
        receptions.append(tuple(reception))
    if len(receptions) == 2 and receptions[0] == receptions[1]:
        _issue(errors, "CHOICE_RECEPTION_NOT_DISTINCT", "draft.choice.options", "réceptions distinctes requises")
    allowed_branches = {"COMMON", *option_ids}
    for index, message in enumerate(messages):
        if message["branch"] not in allowed_branches:
            _issue(errors, "MESSAGE_BRANCH_UNKNOWN", f"draft.messages[{index}].branch", message["branch"])
        if message["branch"] != "COMMON" and message["message_id"] not in declared_receptions:
            _issue(errors, "BRANCHED_MESSAGE_NOT_DECLARED", f"draft.messages[{index}].message_id", message["message_id"])

    counts = _editorial_counts(workspace)
    if counts["playable_path_elements"] != expected_path_counts:
        _issue(errors, "PLAYABLE_PATH_COUNT_INVALID", "draft.messages", str(counts["playable_path_elements"]))
    if not 8 <= counts["burst_groups_stored"] <= 16:
        _issue(warnings, "BURST_COUNT_WARNING", "draft.messages", str(counts["burst_groups_stored"]))
    burst_groups: dict[str, list[int]] = {}
    for index, message in enumerate(messages):
        if message["burst_id"]:
            burst_groups.setdefault(message["burst_id"], []).append(index)
    for burst_id, indexes in burst_groups.items():
        speakers = {messages[index]["speaker_id"] for index in indexes}
        branches = {messages[index]["branch"] for index in indexes}
        if len(indexes) < 2 or len(speakers) != 1 or len(branches) != 1 or indexes != list(range(indexes[0], indexes[-1] + 1)):
            _issue(errors, "BURST_INVALID", "draft.messages", burst_id)
    if not 10 <= counts["weak_messages_stored"] <= 20:
        _issue(warnings, "WEAK_MESSAGE_COUNT_WARNING", "draft.messages", str(counts["weak_messages_stored"]))

    authored_text = "\n".join(message["text"].casefold() for message in messages)
    authored_text += "\n" + "\n".join(option["formulation"].casefold() for option in choice["options"])
    for phrase in _phrase_hits(authored_text, DIRECT_DECLARATIONS):
        _issue(errors, "DIRECT_ROMANTIC_DECLARATION", "draft", phrase)
    for phrase in _pattern_hits(authored_text, DIRECT_DECLARATION_PATTERNS):
        _issue(errors, "DIRECT_ROMANTIC_DECLARATION", "draft", phrase)
    for phrase in _phrase_hits(authored_text, ACQUIRED_MEETINGS):
        _issue(errors, "MEETING_PRESENTED_AS_ACQUIRED", "draft", phrase)
    for phrase in _pattern_hits(authored_text, ACQUIRED_MEETING_PATTERNS):
        _issue(errors, "MEETING_PRESENTED_AS_ACQUIRED", "draft", phrase)
    for phrase in _phrase_hits(authored_text, DURABLE_CONSEQUENCES):
        _issue(errors, "DURABLE_CONSEQUENCE_FORBIDDEN", "draft", phrase)

    repeated = sorted({
        message["text"].casefold()
        for message in messages
        if sum(other["text"].casefold() == message["text"].casefold() for other in messages) > 1
    })
    if repeated:
        _issue(warnings, "SOURCE_REPETITION_REVIEW", "draft.messages", ", ".join(repeated))

    specificity = dialogue_specificity(workspace)
    for issue in specificity["sandra"]:
        _issue(errors, "DIALOGUE_SANDRA_CONTRACT_INCOMPATIBLE", issue["path"], issue["code"])
    for name in ("marie", "mathilde"):
        codes = {issue["code"] for issue in specificity[name]}
        missing = FOREIGN_DIALOGUE_SPECIFICITY_CODES - codes
        if missing:
            _issue(errors, "DIALOGUE_INTERCHANGEABLE", "draft.messages", f"{name}: preuves absentes={sorted(missing)}")
    return _editorial_validation_result(workspace, errors, warnings)


def build_editorial_traceability(workspace: Mapping[str, Any]) -> dict[str, Any]:
    report = validate_editorial_pilot(workspace)
    draft = workspace["draft"]
    plan = workspace["planning"]["plan"]
    specificity = dialogue_specificity(workspace)
    return {
        "format": FORMAT_EDITORIAL_TRACEABILITY,
        "version": VERSION,
        "source_content_sha256": report["source_content_sha256"],
        "validation_fingerprint": report["validation_fingerprint"],
        "participant_ids": list(plan["participant_ids"]),
        "counts": copy.deepcopy(report["counts"]),
        "beat_trace": [
            {
                "position": index + 1,
                "beat_id": beat["beat_id"],
                "message_ids": [
                    message["message_id"] for message in draft["messages"] if message["beat_id"] == beat["beat_id"]
                ],
            }
            for index, beat in enumerate(plan["beats"])
        ],
        "choice_trace": {
            "choice_id": draft["choice"]["choice_id"],
            "after_message_id": draft["choice"]["after_message_id"],
            "receptions": {
                option["option_id"]: list(option["reception_message_ids"])
                for option in draft["choice"]["options"]
            },
            "converge_at_message_id": draft["choice"]["converge_at_message_id"],
        },
        "media_trace": {
            "message_id": "m01",
            "media_id": workspace["source"]["media"]["media_id"],
            "linked_fact_id": plan["media_requirement"]["linked_fact_id"],
            "justification": plan["media_requirement"]["justification"],
        },
        "fact_trace": {
            "canonical_input_ids": [item["input_id"] for item in workspace["provenance"]["canonical_inputs"]],
            "local_fact_ids": [item["fact_id"] for item in workspace["provenance"]["local_facts"]],
            "local_persistence": "SCENE_LOCAL_ONLY",
            "durable_effect": False,
        },
        "voice_validation": {
            "sandra": {
                "compatible": not specificity["sandra"],
                "issue_codes": sorted({issue["code"] for issue in specificity["sandra"]}),
            },
            "player": {
                "compatible": all(
                    message["conversation_move"] == "sandra_player_returns_carefully"
                    for message in draft["messages"]
                    if message["speaker_id"] == "player"
                ),
                "basis": "mouvement Player–Sandra indirect et absence de déclaration, pression ou promesse acquise",
            },
            "marie": {
                "compatible": False,
                "issue_codes": sorted({issue["code"] for issue in specificity["marie"]}),
            },
            "mathilde": {
                "compatible": False,
                "issue_codes": sorted({issue["code"] for issue in specificity["mathilde"]}),
            },
        },
        "narrative_integrity": editorial_draft_projection(workspace) == editorial_source_projection(workspace["source"]),
        "a6_export": False,
        "runtime_wiring": False,
    }


def editorial_decision_fingerprint(decision: Mapping[str, Any]) -> str:
    payload = {key: value for key, value in decision.items() if key != "decision_fingerprint"}
    return _sha256({"validator_version": EDITORIAL_VALIDATOR_VERSION, "decision": payload})


def validate_editorial_decision(
    workspace: Mapping[str, Any],
    decision: Mapping[str, Any],
    *,
    allowed_statuses: set[str] = CANON_REVIEW_STATUSES,
    ready_status: str = "APPROVED_FOR_CANON_REVIEW",
    ready_action: str = "CANON_REVIEW",
) -> list[Issue]:
    issues: list[Issue] = []
    if not _closed(decision, CANON_DECISION_KEYS, "decision", issues):
        return issues
    if decision["format"] != FORMAT_CANON_DECISION or decision["version"] != VERSION:
        _issue(issues, "CANON_DECISION_FORMAT_INVALID", "decision", FORMAT_CANON_DECISION)
    if decision["status"] not in allowed_statuses:
        _issue(issues, "CANON_REVIEW_STATUS_UNKNOWN", "decision.status", str(decision["status"]))
    for field in (
        "draft_id",
        "draft_revision",
        "source_content_sha256",
        "validation_fingerprint",
        "reviewed_by",
        "decision",
        "next_action",
        "decision_fingerprint",
    ):
        if not _nonempty(decision[field]):
            _issue(issues, "TEXT_REQUIRED", f"decision.{field}", "chaîne non vide attendue")
    report = validate_editorial_pilot(workspace)
    if decision["draft_id"] != workspace["draft"]["draft_id"] or decision["draft_revision"] != workspace["draft"]["revision"]:
        _issue(issues, "CANON_DECISION_DRAFT_MISMATCH", "decision", workspace["draft"]["draft_id"])
    if decision["source_content_sha256"] != report["source_content_sha256"]:
        _issue(issues, "CANON_DECISION_SOURCE_STALE", "decision.source_content_sha256", report["source_content_sha256"])
    if decision["validation_fingerprint"] != report["validation_fingerprint"]:
        _issue(issues, "CANON_DECISION_VALIDATION_STALE", "decision.validation_fingerprint", report["validation_fingerprint"])
    if decision["status"] == ready_status and report["status"] == "BLOCKED":
        _issue(issues, "BLOCKED_DRAFT_APPROVED", "decision.status", report["status"])
    if decision["status"] == ready_status and decision["decision"] != ready_action:
        _issue(issues, "CANON_DECISION_ACTION_INVALID", "decision.decision", ready_action)
    blind = decision["blind_reading_result"]
    blind_keys = {
        "voice_a_identification",
        "voice_b_identification",
        "identifying_markers",
        "too_written_passages",
        "marie_or_mathilde_overlap",
        "repetitions_to_discuss",
    }
    if _closed(blind, blind_keys, "decision.blind_reading_result", issues):
        for field in ("voice_a_identification", "voice_b_identification"):
            if not _nonempty(blind[field]):
                _issue(issues, "TEXT_REQUIRED", f"decision.blind_reading_result.{field}", "réponse humaine requise")
        for field in blind_keys - {"voice_a_identification", "voice_b_identification"}:
            _string_list(blind[field], f"decision.blind_reading_result.{field}", issues, nonempty=True)
    _string_list(decision["narrative_remarks"], "decision.narrative_remarks", issues, nonempty=True)
    expected = editorial_decision_fingerprint(decision)
    if decision["decision_fingerprint"] != expected:
        _issue(issues, "CANON_DECISION_FINGERPRINT_STALE", "decision.decision_fingerprint", expected)
    return issues


def _blind_text(text: str) -> str:
    return text.replace("Ludo", "[Voix B]").replace("Sandra", "[Voix A]")


def render_editorial_blind_reading(workspace: Mapping[str, Any]) -> str:
    draft = workspace["draft"]
    messages = {message["message_id"]: message for message in draft["messages"]}

    def render_message(message: Mapping[str, Any]) -> str:
        voice = "Voix A" if message["speaker_id"] == "sandra" else "Voix B"
        if message["kind"] == "IMAGE":
            return (
                f"[{message['message_id']}] **{voice}** — *{_blind_text(message['text'])}*\n\n"
                "*[Média anonymisé : terrasse de café et chaises bleues]*"
            )
        return f"[{message['message_id']}] **{voice}**\n\n{_blind_text(message['text'])}"

    source = workspace["source"]
    profile = workspace.get("editorial_profile")
    profile = profile if isinstance(profile, Mapping) else {}
    lot_label = profile.get("lot_label", "R8C-A11.5")
    lines = [
        f"# {lot_label} — Lecture en aveugle — Les chaises bleues",
        "",
        "Les identités et le nom du média sont masqués. La dérivation ne modifie pas le brouillon intégré.",
        "",
        "## Tronc avant choix",
        "",
    ]
    lines.extend(render_message(messages[item["message_id"]]) + "\n" for item in source["pre_choice_messages"])
    lines.extend(["## Choix de Voix B", ""])
    for option in draft["choice"]["options"]:
        label = "Option A" if option["option_id"] == "careful_warmth" else "Option B"
        lines.extend([f"### {label}", "", f"**{option['formulation']}**", ""])
        lines.extend(render_message(messages[message_id]) + "\n" for message_id in option["reception_message_ids"])
    lines.extend(["## Convergence", ""])
    lines.extend(render_message(messages[item["message_id"]]) + "\n" for item in source["convergence_messages"])
    lines.extend([
        "## Fiche humaine",
        "",
        "- Quelle voix est Sandra ?",
        "- Quels marqueurs permettent de l’identifier ?",
        "- Quels passages semblent trop écrits ?",
        "- Quels passages pourraient appartenir à Marie ou Mathilde ?",
        "- Quelles répétitions doivent être discutées en revue narrative ?",
        "",
        "Aucune notation automatique n’est produite.",
    ])
    return "\n".join(lines) + "\n"


def render_editorial_human_review(
    workspace: Mapping[str, Any],
    decision: Mapping[str, Any],
) -> str:
    blind = decision["blind_reading_result"]
    profile = workspace.get("editorial_profile")
    profile = profile if isinstance(profile, Mapping) else {}
    lot_label = profile.get("lot_label", "R8C-A11.5")
    lines = [
        f"# {lot_label} — Relecture humaine — Sandra — Les chaises bleues",
        "",
        f"> **Brouillon :** `{decision['draft_id']}` — `{decision['draft_revision']}`",
        f"> **Statut humain :** `{decision['status']}`",
        f"> **Relecteur :** `{decision['reviewed_by']}`",
        f"> **Empreinte source :** `{decision['source_content_sha256']}`",
        "",
        "## Lecture en aveugle complétée",
        "",
        f"- Voix A identifiée comme : **{blind['voice_a_identification']}**",
        f"- Voix B identifiée comme : **{blind['voice_b_identification']}**",
        "- Marqueurs d'identification :",
    ]
    lines.extend(f"  - {item}" for item in blind["identifying_markers"])
    lines.append("- Passages semblant trop écrits :")
    lines.extend(f"  - {item}" for item in blind["too_written_passages"])
    lines.append("- Passages pouvant glisser vers Marie ou Mathilde :")
    lines.extend(f"  - {item}" for item in blind["marie_or_mathilde_overlap"])
    lines.append("- Répétitions à discuter :")
    lines.extend(f"  - {item}" for item in blind["repetitions_to_discuss"])
    lines.extend(["", "## Remarques narratives", ""])
    lines.extend(f"- {item}" for item in decision["narrative_remarks"])
    lines.extend([
        "",
        "## Décision",
        "",
        f"- Action : `{decision['decision']}`",
        f"- Suite : {decision['next_action']}",
        "- Cette décision ne produit ni export A6, ni fait A1, ni branchement runtime.",
    ])
    return "\n".join(lines) + "\n"


def n2_locked_source_sha256(text: str | None = None) -> str:
    content = N2_LOCKED_SOURCE_PATH.read_text(encoding="utf-8") if text is None else text
    return hashlib.sha256(content.rstrip("\r\n").encode("utf-8")).hexdigest()


def parse_n2_locked_source(text: str | None = None) -> dict[str, Any]:
    content = N2_LOCKED_SOURCE_PATH.read_text(encoding="utf-8") if text is None else text
    required_markers = (
        "# Sandra — Les chaises bleues",
        "`R8C-N2_REVISION_CANDIDATE`",
        "`R8C-A11.5`",
        "`R8C-N1 — NEEDS_MINOR_NARRATIVE_REVISION`",
        "# Manifeste de révision",
        "Les anciens `m64–m69` sont remplacés par les nouveaux `m64–m67`.",
        "Les anciens `m70–m71` sont retirés, car ils dépendaient directement de la plaisanterie supprimée sur la phrase notée puis réutilisée.",
        "Les anciens `m75–m78` sont remplacés par les nouveaux `m75–m78`.",
    )
    missing = [marker for marker in required_markers if marker not in content]
    if missing:
        raise A114ValidationError(
            [Issue("N2_LOCKED_SOURCE_INCOMPLETE", str(N2_LOCKED_SOURCE_PATH), marker) for marker in missing]
        )
    lines = content.splitlines()
    choice_index = lines.index("## Choix Player")
    option_a_index = lines.index("### Option A — chaleur prudente")
    option_b_index = lines.index("### Option B — retrait ironique")
    convergence_index = lines.index("## Convergence")
    manifest_index = lines.index("# Manifeste de révision")
    message_pattern = re.compile(
        r"^\[([^\]]+)\]\s+\*\*(Sandra|Player)\*\*(?:\s+—\s+\*(.*)\*)?\s*$"
    )

    def messages_between(start: int, end: int) -> list[dict[str, str]]:
        result: list[dict[str, str]] = []
        index = start
        while index < end:
            match = message_pattern.match(lines[index])
            if match is None:
                index += 1
                continue
            message_id, speaker, inline_text = match.groups()
            if inline_text is None:
                text_index = index + 1
                while text_index < end and not lines[text_index].strip():
                    text_index += 1
                if text_index >= end:
                    raise A114ValidationError(
                        [Issue("N2_MESSAGE_TEXT_MISSING", message_id, "texte de bulle attendu")]
                    )
                message_text = lines[text_index]
            else:
                message_text = inline_text
            result.append({
                "message_id": message_id,
                "speaker_id": speaker.casefold(),
                "kind": "IMAGE" if message_id == "m01" else "TEXT",
                "text": message_text,
            })
            index += 1
        return result

    def formulation_after(heading_index: int, end: int) -> str:
        for line in lines[heading_index + 1:end]:
            stripped = line.strip()
            if stripped.startswith("**") and stripped.endswith("**"):
                return stripped[2:-2]
        raise A114ValidationError(
            [Issue("N2_CHOICE_FORMULATION_MISSING", str(heading_index), "formulation attendue")]
        )

    media_id_index = lines.index("`photo_sandra_cafe_blue_chairs`")
    media_description = next(line for line in lines[media_id_index + 1:] if line.strip())
    return {
        "format": FORMAT_EDITORIAL_SOURCE,
        "version": VERSION,
        "source_id": "r8c_n2_sandra_blue_chairs_locked_source",
        "title": "Sandra — Les chaises bleues",
        "media": {
            "media_id": "photo_sandra_cafe_blue_chairs",
            "kind": "PHOTO",
            "description": media_description,
        },
        "pre_choice_messages": messages_between(0, choice_index),
        "choice": {
            "choice_id": "player_response_to_sandra_test",
            "after_message_id": "m46",
            "options": [
                {
                    "option_id": "careful_warmth",
                    "formulation": formulation_after(option_a_index, option_b_index),
                    "reception_messages": messages_between(option_a_index, option_b_index),
                },
                {
                    "option_id": "ironic_withdrawal",
                    "formulation": formulation_after(option_b_index, convergence_index),
                    "reception_messages": messages_between(option_b_index, convergence_index),
                },
            ],
            "converge_at_message_id": "m53",
        },
        "convergence_messages": messages_between(convergence_index, manifest_index),
    }


def apply_n2_final_canonical_correction(source: Mapping[str, Any]) -> dict[str, Any]:
    corrected = copy.deepcopy(source)
    matches = [
        message
        for message in corrected["convergence_messages"]
        if message["message_id"] == N2_FINAL_CANONICAL_CORRECTION["message_id"]
    ]
    if len(matches) != 1 or matches[0]["text"] != N2_FINAL_CANONICAL_CORRECTION["before"]:
        raise A114ValidationError([
            Issue(
                "N2_FINAL_CORRECTION_SOURCE_INVALID",
                "source.m91",
                "la réplique revue bonne soirée, Ludo est attendue exactement une fois",
            )
        ])
    matches[0]["text"] = N2_FINAL_CANONICAL_CORRECTION["after"]
    return corrected


def validate_n2_final_canonical_correction(
    reviewed_source: Mapping[str, Any],
    candidate_source: Mapping[str, Any],
) -> list[Issue]:
    try:
        expected = apply_n2_final_canonical_correction(reviewed_source)
    except A114ValidationError as exc:
        return exc.issues
    if editorial_source_projection(expected) == editorial_source_projection(candidate_source):
        return []
    return [
        Issue(
            "N2_FINAL_CORRECTION_DIFF_INVALID",
            "source",
            "le diff narratif depuis le commit revu doit être limité au texte de m91",
        )
    ]


def _build_n2_provenance(source: Mapping[str, Any]) -> dict[str, Any]:
    provenance = _read_json(PILOT_PROVENANCE_PATH)
    provenance["provenance_id"] = "r8c_n2_sandra_blue_chairs_provenance"
    provenance["source_id"] = source["source_id"]
    provenance["source_content_sha256"] = editorial_source_content_sha256(source)
    provenance["canonical_inputs"].append({
        "input_id": "r8c_n1_minor_revision_decision",
        "text": "Pont propre à l’option A, simplification des passages m64–m69 et m75–m78, sans perte des limites narratives.",
        "source_ref": "docs/narrative/R8C_N1_CANON_REVIEW_SANDRA_BLUE_CHAIRS.md",
    })
    provenance["canonical_inputs"].append({
        "input_id": "r8c_n2_final_player_name_review",
        "text": "Aucun token auteur canonique et validable du prénom Player n’existe dans le dépôt; le repli autorisé retire le prénom historique de m91.",
        "source_ref": "docs/decisions/DECISION_006_PLAYER_NAME_AND_THREAD_MODEL.md",
    })
    provenance["limits"][0]["text"] = (
        "La candidate corrigée ne peut différer du texte R8C-N2 verrouillé que par le repli fermé de m91: bonne soirée."
    )
    provenance["limits"][1]["text"] = (
        "Sandra reçoit et comprend que la reprise du contact compte pour Player; un déjeuner ultérieur reste seulement possible."
    )
    return provenance


def _build_n2_plan(provenance: Mapping[str, Any]) -> dict[str, Any]:
    planning = _read_json(PILOT_PLAN_PATH)
    planning["case_id"] = "r8c_n2_sandra_blue_chairs"
    planning["human_selection"]["selected_by"] = "chatgpt_source_owner_r8c_n2"
    planning["plan"]["plan_id"] = "r8c_n2_sandra_blue_chairs_plan"
    planning["diagnostic"]["present_information"][2]["text"] = (
        "Les 96 éléments stockés et les deux formulations du choix sont verrouillés par la source N2."
    )
    planning["human_review"]["reviewed_by"] = "codex_plan_projection_r8c_n2"
    planning["human_review"]["notes"] = [
        "Les sept battements A11.5 restent inchangés.",
        "La projection ne change que les identités techniques, le nombre d’éléments et la structure de branche requise par N2.",
        "Le média et les quatre détails locaux ne persistent pas dans A1 et aucun export A6 n’est autorisé.",
    ]
    calibration = _editorial_calibration(provenance)
    planning["human_review"]["plan_fingerprint"] = planning_fingerprint(planning, calibration)
    return planning


def _build_n2_draft(
    source: Mapping[str, Any],
    planning: Mapping[str, Any],
) -> dict[str, Any]:
    base = _read_json(PILOT_DRAFT_PATH)
    templates = {message["message_id"]: message for message in base["messages"]}
    messages: list[dict[str, Any]] = []

    def materialize(
        source_message: Mapping[str, Any],
        branch: str,
        reply_to: str | None,
    ) -> dict[str, Any]:
        message_id = source_message["message_id"]
        template_id = "m52" if message_id == "m52B" else message_id
        template = copy.deepcopy(templates.get(template_id, templates["m63"]))
        template.update({
            "message_id": message_id,
            "speaker_id": source_message["speaker_id"],
            "kind": source_message["kind"],
            "text": source_message["text"],
            "branch": branch,
            "reply_to": reply_to,
            "media": copy.deepcopy(templates["m01"]["media"]) if message_id == "m01" else None,
        })
        if branch != "COMMON":
            template["beat_id"] = "sandra_test_and_choice"
        if message_id in {"m51A-2", "m52B"}:
            template.update({
                "objective_actor_id": "player",
                "conversation_move": "sandra_player_returns_carefully",
                "fact_refs": ["sandra_current_distance"],
                "burst_id": None,
                "strength": "NORMAL",
            })
        elif message_id == "m51A-3":
            template.update({
                "objective_actor_id": "sandra",
                "conversation_move": "sandra_prolongs_without_claim",
                "fact_refs": ["sandra_current_distance"],
                "burst_id": None,
                "strength": "WEAK",
            })
        elif message_id in {"m64", "m67", "m75", "m78"}:
            template.update({
                "objective_actor_id": "player",
                "conversation_move": "sandra_player_returns_carefully",
                "fact_refs": ["sandra_current_distance"],
                "burst_id": None,
                "strength": "NORMAL",
            })
        elif message_id in {"m65", "m66", "m76", "m77"}:
            template.update({
                "objective_actor_id": "sandra",
                "conversation_move": "sandra_prolongs_without_claim",
                "fact_refs": ["sandra_current_distance"],
                "burst_id": "burst_limit_received" if message_id in {"m65", "m66"} else "burst_uncertainty",
                "strength": "WEAK" if message_id in {"m65", "m76"} else "NORMAL",
            })
        elif message_id == "m72":
            template["burst_id"] = None
        return template

    previous: str | None = None
    for source_message in source["pre_choice_messages"]:
        messages.append(materialize(source_message, "COMMON", previous))
        previous = source_message["message_id"]
    reception_ids: dict[str, list[str]] = {}
    for option in source["choice"]["options"]:
        previous = source["choice"]["after_message_id"]
        reception_ids[option["option_id"]] = []
        for source_message in option["reception_messages"]:
            messages.append(materialize(source_message, option["option_id"], previous))
            reception_ids[option["option_id"]].append(source_message["message_id"])
            previous = source_message["message_id"]
    previous = None
    for source_message in source["convergence_messages"]:
        messages.append(materialize(source_message, "COMMON", previous))
        previous = source_message["message_id"]
    return {
        "format": base["format"],
        "version": base["version"],
        "draft_id": "r8c_n2_sandra_blue_chairs_draft",
        "revision": "R8C-N2_REVISION_CANDIDATE",
        "plan_id": planning["plan"]["plan_id"],
        "messages": messages,
        "choice": {
            "choice_id": source["choice"]["choice_id"],
            "after_message_id": source["choice"]["after_message_id"],
            "converge_at_message_id": source["choice"]["converge_at_message_id"],
            "options": [
                {
                    "option_id": option["option_id"],
                    "formulation": option["formulation"],
                    "reception_message_ids": reception_ids[option["option_id"]],
                }
                for option in source["choice"]["options"]
            ],
        },
    }


def _source_message_index(source: Mapping[str, Any]) -> dict[str, dict[str, str]]:
    result: dict[str, dict[str, str]] = {}

    def add(message: Mapping[str, Any], branch: str) -> None:
        result[message["message_id"]] = {
            "message_id": message["message_id"],
            "speaker_id": message["speaker_id"],
            "kind": message["kind"],
            "text": message["text"],
            "branch": branch,
        }

    for message in source["pre_choice_messages"]:
        add(message, "COMMON")
    for option in source["choice"]["options"]:
        for message in option["reception_messages"]:
            add(message, option["option_id"])
    for message in source["convergence_messages"]:
        add(message, "COMMON")
    return result


def validate_n2_manifest(
    historical_source: Mapping[str, Any],
    candidate_source: Mapping[str, Any],
) -> list[Issue]:
    issues: list[Issue] = []
    historical = _source_message_index(historical_source)
    candidate = _source_message_index(candidate_source)
    changed_historical_ids = {"m52", "m64", "m65", "m66", "m67", "m68", "m69", "m70", "m71", "m75", "m76", "m77", "m78", "m91"}
    changed_candidate_ids = {"m51A-2", "m51A-3", "m52B", "m64", "m65", "m66", "m67", "m75", "m76", "m77", "m78", "m91"}
    unchanged_ids = set(historical) - changed_historical_ids
    expected_candidate_ids = unchanged_ids | changed_candidate_ids
    if set(candidate) != expected_candidate_ids:
        _issue(
            issues,
            "N2_MANIFEST_ELEMENT_SET_INVALID",
            "source",
            f"manquants={sorted(expected_candidate_ids - set(candidate))}; étrangers={sorted(set(candidate) - expected_candidate_ids)}",
        )
    expected_order: list[str] = []
    for message_id in historical:
        if message_id in {"m52", "m68", "m69", "m70", "m71"}:
            continue
        expected_order.append(message_id)
        if message_id == "m51A":
            expected_order.extend(("m51A-2", "m51A-3"))
        elif message_id == "m51B":
            expected_order.append("m52B")
    if list(candidate) != expected_order:
        _issue(
            issues,
            "N2_MESSAGE_ORDER_INVALID",
            "source",
            "ordre narratif A11.5 attendu avec seules insertions et suppressions du manifeste",
        )
    for message_id in sorted(unchanged_ids & set(candidate)):
        if historical[message_id] != candidate[message_id]:
            _issue(issues, "N2_UNLISTED_NARRATIVE_CHANGE", f"source.{message_id}", "contenu A11.5 inchangé attendu")
    if historical_source["media"] != candidate_source["media"]:
        _issue(issues, "N2_UNLISTED_NARRATIVE_CHANGE", "source.media", "média A11.5 inchangé attendu")
    for field in ("choice_id", "after_message_id"):
        if historical_source["choice"][field] != candidate_source["choice"][field]:
            _issue(issues, "N2_UNLISTED_NARRATIVE_CHANGE", f"source.choice.{field}", "valeur A11.5 attendue")
    old_options = historical_source["choice"]["options"]
    new_options = candidate_source["choice"]["options"]
    if [item["option_id"] for item in old_options] != [item["option_id"] for item in new_options]:
        _issue(issues, "N2_UNLISTED_NARRATIVE_CHANGE", "source.choice.options", "options A11.5 attendues")
    if [item["formulation"] for item in old_options] != [item["formulation"] for item in new_options]:
        _issue(issues, "N2_UNLISTED_NARRATIVE_CHANGE", "source.choice.options.formulation", "formulations A11.5 attendues")
    if candidate_source["choice"]["converge_at_message_id"] != "m53":
        _issue(issues, "N2_OLD_CONVERGENCE_PRESENT", "source.choice.converge_at_message_id", "m53 attendu")
    if "m52" in candidate or any(message_id in candidate for message_id in ("m68", "m69", "m70", "m71")):
        _issue(issues, "N2_RETIRED_SEQUENCE_PRESENT", "source", "ancienne convergence ou ancienne séquence encore présente")
    expected_m91 = copy.deepcopy(historical.get("m91"))
    if expected_m91 is not None:
        expected_m91["text"] = N2_FINAL_CANONICAL_CORRECTION["after"]
    if candidate.get("m91") != expected_m91:
        _issue(issues, "N2_FINAL_CORRECTION_DIFF_INVALID", "source.m91", "repli exact bonne soirée attendu")
    return issues


def build_n2_comparison(
    historical_source: Mapping[str, Any],
    candidate_source: Mapping[str, Any],
) -> dict[str, Any]:
    old = _source_message_index(historical_source)
    new = _source_message_index(candidate_source)
    changed_old = {"m52", "m64", "m65", "m66", "m67", "m68", "m69", "m70", "m71", "m75", "m76", "m77", "m78", "m91"}
    unchanged_ids = [message_id for message_id in old if message_id not in changed_old]
    return {
        "format": FORMAT_N2_COMPARISON,
        "version": VERSION,
        "historical_source_id": historical_source["source_id"],
        "historical_source_content_sha256": editorial_source_content_sha256(historical_source),
        "candidate_source_id": candidate_source["source_id"],
        "candidate_source_content_sha256": editorial_source_content_sha256(candidate_source),
        "parent_decision": "R8C-N1 — NEEDS_MINOR_NARRATIVE_REVISION",
        "comparison_basis": "Contenu narratif complet (locuteur, type, texte et branche), pas seulement identifiants ou nombres.",
        "additions": [new[message_id] for message_id in ("m51A-2", "m51A-3")],
        "replacements": [
            {
                "revision_id": "option_b_specific_bridge",
                "before": [old["m52"]],
                "after": [new["m52B"]],
                "reason_from_n1": "Rendre distinctes les deux sorties de choix avant une convergence naturelle à m53.",
            },
            {
                "revision_id": "limit_received_without_overwriting",
                "before": [old[message_id] for message_id in ("m64", "m65", "m66", "m67", "m68", "m69")],
                "after": [new[message_id] for message_id in ("m64", "m65", "m66", "m67")],
                "reason_from_n1": "Simplifier la limite reçue sans dialogue trop construit et préserver un Player non insistant.",
            },
            {
                "revision_id": "sandra_uncertainty",
                "before": [old[message_id] for message_id in ("m75", "m76", "m77", "m78")],
                "after": [new[message_id] for message_id in ("m75", "m76", "m77", "m78")],
                "reason_from_n1": "Remplacer la formule composée par une incertitude prudente et assumée de Sandra.",
            },
            {
                "revision_id": "player_name_canonical_fallback",
                "before": [old["m91"]],
                "after": [new["m91"]],
                "reason_from_final_review": "Retirer le prénom historique faute de token auteur canonique et validable pour le prénom choisi par le joueur.",
            },
        ],
        "removals": [old[message_id] for message_id in ("m70", "m71")],
        "unchanged": [old[message_id] for message_id in unchanged_ids],
        "unchanged_structural_elements": {
            "title": historical_source["title"],
            "media": historical_source["media"],
            "choice_id": historical_source["choice"]["choice_id"],
            "after_message_id": historical_source["choice"]["after_message_id"],
            "option_ids": [option["option_id"] for option in historical_source["choice"]["options"]],
            "option_formulations": [option["formulation"] for option in historical_source["choice"]["options"]],
        },
        "choice_transitions": {
            "careful_warmth": ["m51A", "m51A-2", "m51A-3", "m53"],
            "ironic_withdrawal": ["m51B", "m52B", "m53"],
            "common_convergence_starts_at": "m53",
        },
        "final_canonical_correction": {
            "reviewed_commit": N2_REVIEWED_COMMIT,
            "message_id": N2_FINAL_CANONICAL_CORRECTION["message_id"],
            "before": N2_FINAL_CANONICAL_CORRECTION["before"],
            "after": N2_FINAL_CANONICAL_CORRECTION["after"],
            "resolution": N2_FINAL_CANONICAL_CORRECTION["resolution"],
            "unexpected_changes": [
                issue.as_json()
                for issue in validate_n2_final_canonical_correction(parse_n2_locked_source(), candidate_source)
            ],
        },
        "manifest_validation": {
            "content_compared": True,
            "unexpected_changes": [issue.as_json() for issue in validate_n2_manifest(historical_source, candidate_source)],
        },
    }


def load_n2_workspace(*, include_outputs: bool = True) -> dict[str, Any]:
    workspace = load_editorial_pilot_workspace(
        source_path=N2_SOURCE_PATH,
        provenance_path=N2_PROVENANCE_PATH,
        plan_path=N2_PLAN_PATH,
        draft_path=N2_DRAFT_PATH,
        validation_path=N2_VALIDATION_PATH,
        traceability_path=N2_TRACEABILITY_PATH,
        decision_path=N2_DECISION_PATH,
        include_outputs=include_outputs,
    )
    workspace["editorial_profile"] = copy.deepcopy(N2_PROFILE)
    return workspace


def validate_n2_revision(workspace: Mapping[str, Any]) -> dict[str, Any]:
    base = validate_editorial_pilot(workspace)
    errors = [Issue(item["code"], item["path"], item["message"]) for item in base["blocking_errors"]]
    warnings = [Issue(item["code"], item["path"], item["message"]) for item in base["warnings"]]
    try:
        locked_projection = parse_n2_locked_source()
    except A114ValidationError as exc:
        errors.extend(exc.issues)
    else:
        errors.extend(validate_n2_final_canonical_correction(locked_projection, workspace["source"]))
    errors.extend(validate_n2_manifest(_read_json(PILOT_SOURCE_PATH), workspace["source"]))
    return _editorial_validation_result(workspace, errors, warnings)


def validate_n2_decision(workspace: Mapping[str, Any], decision: Mapping[str, Any]) -> list[Issue]:
    return validate_editorial_decision(
        workspace,
        decision,
        allowed_statuses=N2_REVIEW_STATUSES,
        ready_status="CANON_APPROVED",
        ready_action="CANON_APPROVED",
    )


def generate_n2_artifacts() -> dict[str, Any]:
    source = apply_n2_final_canonical_correction(parse_n2_locked_source())
    provenance = _build_n2_provenance(source)
    planning = _build_n2_plan(provenance)
    draft = _build_n2_draft(source, planning)
    calibration = _editorial_calibration(provenance)
    workspace = {
        "source": source,
        "provenance": provenance,
        "planning": planning,
        "character_contract": calibration["character"],
        "relationship_register": calibration["relationship"],
        "foreign_calibrations": {
            name: {"character": foreign["character"], "relationship": foreign["relationship"]}
            for name in ("marie", "mathilde")
            for foreign in (load_calibration_case(name),)
        },
        "draft": draft,
        "validation_report": None,
        "traceability_report": None,
        "decision": None,
        "editorial_profile": copy.deepcopy(N2_PROFILE),
    }
    validation = validate_n2_revision(workspace)
    traceability = build_editorial_traceability(workspace)
    comparison = build_n2_comparison(_read_json(PILOT_SOURCE_PATH), source)
    if validation["status"] == "BLOCKED":
        raise A114ValidationError(
            [
                Issue(item["code"], item["path"], item["message"])
                for item in validation["blocking_errors"]
            ]
        )
    if comparison["manifest_validation"]["unexpected_changes"]:
        raise A114ValidationError(
            [
                Issue(item["code"], item["path"], item["message"])
                for item in comparison["manifest_validation"]["unexpected_changes"]
            ]
        )
    artifacts = {
        N2_SOURCE_PATH: source,
        N2_PROVENANCE_PATH: provenance,
        N2_PLAN_PATH: planning,
        N2_DRAFT_PATH: draft,
        N2_VALIDATION_PATH: validation,
        N2_COMPARISON_PATH: comparison,
        N2_TRACEABILITY_PATH: traceability,
    }
    for path, value in artifacts.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    N2_BLIND_READING_PATH.write_text(render_editorial_blind_reading(workspace), encoding="utf-8", newline="\n")
    return {
        "ok": True,
        "locked_source_sha256": n2_locked_source_sha256(),
        "source_content_sha256": validation["source_content_sha256"],
        "counts": validation["counts"],
    }


def validate_n2_json_library() -> dict[str, Any]:
    workspace = load_n2_workspace()
    generated_validation = validate_n2_revision(workspace)
    if generated_validation != workspace["validation_report"]:
        raise A114ValidationError([Issue("N2_VALIDATION_STALE", "validation_report", "rapport différent")])
    generated_traceability = build_editorial_traceability(workspace)
    if generated_traceability != workspace["traceability_report"]:
        raise A114ValidationError([Issue("N2_TRACEABILITY_STALE", "traceability_report", "rapport différent")])
    generated_comparison = build_n2_comparison(_read_json(PILOT_SOURCE_PATH), workspace["source"])
    if generated_comparison != _read_json(N2_COMPARISON_PATH):
        raise A114ValidationError([Issue("N2_COMPARISON_STALE", "comparison_report", "rapport différent")])
    decision_issues = validate_n2_decision(workspace, workspace["decision"])
    if decision_issues:
        raise A114ValidationError(decision_issues)
    if render_editorial_blind_reading(workspace) != N2_BLIND_READING_PATH.read_text(encoding="utf-8"):
        raise A114ValidationError([Issue("N2_BLIND_READING_STALE", str(N2_BLIND_READING_PATH), "rendu différent")])
    if render_editorial_human_review(workspace, workspace["decision"]) != N2_HUMAN_REVIEW_PATH.read_text(encoding="utf-8"):
        raise A114ValidationError([Issue("N2_HUMAN_REVIEW_STALE", str(N2_HUMAN_REVIEW_PATH), "rendu différent")])
    return {
        "ok": True,
        "status": workspace["decision"]["status"],
        "locked_source_sha256": n2_locked_source_sha256(),
        "source_content_sha256": generated_validation["source_content_sha256"],
        "counts": generated_validation["counts"],
        "a6_export": False,
        "runtime_wiring": False,
    }


def run_n2_smoke() -> dict[str, Any]:
    workspace = load_n2_workspace(include_outputs=False)
    first = validate_n2_revision(workspace)
    second = validate_n2_revision(workspace)
    if first != second or first["status"] == "BLOCKED":
        raise AssertionError("validation R8C-N2 non déterministe ou bloquée")

    def mutation_codes(mutant: Mapping[str, Any]) -> set[str]:
        return {item["code"] for item in validate_n2_revision(mutant)["blocking_errors"]}

    mutations: dict[str, set[str]] = {}
    foreign = copy.deepcopy(workspace)
    foreign["draft"]["messages"][1]["text"] += " !"
    mutations["foreign_bubble_change"] = mutation_codes(foreign)
    old_convergence = copy.deepcopy(workspace)
    old_convergence["draft"]["choice"]["converge_at_message_id"] = "m52"
    mutations["old_convergence"] = mutation_codes(old_convergence)
    acquired = copy.deepcopy(workspace)
    by_id = {message["message_id"]: message for message in acquired["draft"]["messages"]}
    by_id["m79"]["text"] = "On déjeune vendredi à 20 h"
    mutations["acquired_meeting"] = mutation_codes(acquired)
    foreign_participant = copy.deepcopy(workspace)
    foreign_participant["planning"]["plan"]["participant_ids"].append("marie")
    mutations["foreign_participant"] = mutation_codes(foreign_participant)
    expected = {
        "foreign_bubble_change": "SOURCE_CONTENT_MISMATCH",
        "old_convergence": "CHOICE_MESSAGE_REFERENCE_INVALID",
        "acquired_meeting": "MEETING_PRESENTED_AS_ACQUIRED",
        "foreign_participant": "UNEXPECTED_PARTICIPANT",
    }
    for name, expected_code in expected.items():
        if expected_code not in mutations[name]:
            raise AssertionError(f"mutation {name} non rejetée par {expected_code}: {sorted(mutations[name])}")
    return {
        "ok": True,
        "source_content_sha256": first["source_content_sha256"],
        "counts": first["counts"],
        "warning_codes": [item["code"] for item in first["warnings"]],
        "mutation_error_codes": {name: sorted(codes) for name, codes in mutations.items()},
        "a6_export": False,
        "runtime_wiring": False,
    }


def validate_editorial_json_library() -> dict[str, Any]:
    workspace = load_editorial_pilot_workspace(**default_editorial_paths())
    generated_validation = validate_editorial_pilot(workspace)
    if generated_validation != workspace["validation_report"]:
        raise A114ValidationError([Issue("EDITORIAL_VALIDATION_STALE", "validation_report", "rapport différent")])
    generated_traceability = build_editorial_traceability(workspace)
    if generated_traceability != workspace["traceability_report"]:
        raise A114ValidationError([Issue("EDITORIAL_TRACEABILITY_STALE", "traceability_report", "rapport différent")])
    decision_issues = validate_editorial_decision(workspace, workspace["decision"])
    if decision_issues:
        raise A114ValidationError(decision_issues)
    if render_editorial_blind_reading(workspace) != PILOT_BLIND_READING_PATH.read_text(encoding="utf-8"):
        raise A114ValidationError([Issue("BLIND_READING_STALE", str(PILOT_BLIND_READING_PATH), "rendu différent")])
    if render_editorial_human_review(workspace, workspace["decision"]) != PILOT_HUMAN_REVIEW_PATH.read_text(encoding="utf-8"):
        raise A114ValidationError([Issue("EDITORIAL_HUMAN_REVIEW_STALE", str(PILOT_HUMAN_REVIEW_PATH), "rendu différent")])
    return {
        "ok": True,
        "draft_id": workspace["draft"]["draft_id"],
        "status": workspace["decision"]["status"],
        "source_content_sha256": generated_validation["source_content_sha256"],
        "counts": generated_validation["counts"],
    }


def run_editorial_pilot_smoke() -> dict[str, Any]:
    workspace = load_editorial_pilot_workspace(include_outputs=False)
    first = validate_editorial_pilot(workspace)
    second = validate_editorial_pilot(workspace)
    if first != second or first["status"] == "BLOCKED":
        raise AssertionError("validation A11.5 non déterministe ou bloquée")

    def mutation_codes(mutant: Mapping[str, Any]) -> set[str]:
        return {item["code"] for item in validate_editorial_pilot(mutant)["blocking_errors"]}

    mutations: dict[str, set[str]] = {}
    added = copy.deepcopy(workspace)
    extra = copy.deepcopy(added["draft"]["messages"][-1])
    extra["message_id"] = "m94"
    extra["reply_to"] = "m93"
    added["draft"]["messages"].append(extra)
    mutations["added"] = mutation_codes(added)
    removed = copy.deepcopy(workspace)
    removed["draft"]["messages"].pop()
    mutations["removed"] = mutation_codes(removed)
    modified = copy.deepcopy(workspace)
    modified["draft"]["messages"][1]["text"] += " !"
    mutations["modified"] = mutation_codes(modified)
    media_missing = copy.deepcopy(workspace)
    media_missing["draft"]["messages"][0]["kind"] = "TEXT"
    media_missing["draft"]["messages"][0]["media"] = None
    mutations["media_missing"] = mutation_codes(media_missing)
    acquired = copy.deepcopy(workspace)
    acquired["draft"]["messages"][78]["text"] = "On se voit vendredi à 20 h"
    mutations["acquired_meeting"] = mutation_codes(acquired)
    marie = copy.deepcopy(workspace)
    marie["planning"]["plan"]["participant_ids"].append("marie")
    mutations["marie_participant"] = mutation_codes(marie)
    identical = copy.deepcopy(workspace)
    messages_by_id = {message["message_id"]: message for message in identical["draft"]["messages"]}
    for a_id, b_id in zip(
        identical["draft"]["choice"]["options"][0]["reception_message_ids"],
        identical["draft"]["choice"]["options"][1]["reception_message_ids"],
    ):
        messages_by_id[b_id]["speaker_id"] = messages_by_id[a_id]["speaker_id"]
        messages_by_id[b_id]["objective_actor_id"] = messages_by_id[a_id]["objective_actor_id"]
        messages_by_id[b_id]["conversation_move"] = messages_by_id[a_id]["conversation_move"]
        messages_by_id[b_id]["text"] = messages_by_id[a_id]["text"]
    mutations["identical_reception"] = mutation_codes(identical)
    durable = copy.deepcopy(workspace)
    durable["provenance"]["local_facts"][0]["persistence"] = "A1_DURABLE_FACT"
    mutations["durable_local_fact"] = mutation_codes(durable)
    expected = {
        "added": "EDITORIAL_ELEMENT_COUNT_INVALID",
        "removed": "EDITORIAL_ELEMENT_COUNT_INVALID",
        "modified": "SOURCE_CONTENT_MISMATCH",
        "media_missing": "MEDIA_REQUIRED",
        "acquired_meeting": "MEETING_PRESENTED_AS_ACQUIRED",
        "marie_participant": "UNEXPECTED_PARTICIPANT",
        "identical_reception": "CHOICE_RECEPTION_NOT_DISTINCT",
        "durable_local_fact": "LOCAL_FACT_BECAME_DURABLE",
    }
    for name, expected_code in expected.items():
        if expected_code not in mutations[name]:
            raise AssertionError(f"mutation {name} non rejetée par {expected_code}: {sorted(mutations[name])}")
    return {
        "ok": True,
        "source_content_sha256": first["source_content_sha256"],
        "counts": first["counts"],
        "warning_codes": [item["code"] for item in first["warnings"]],
        "mutation_error_codes": {name: sorted(codes) for name, codes in mutations.items()},
        "a6_export": False,
        "runtime_wiring": False,
    }


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
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8")
    parser = argparse.ArgumentParser(
        description="Offline R8C-A11.4 plan-to-draft export and A11.5 editorial pilot review"
    )
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("validate-json")
    subparsers.add_parser("validate")
    subparsers.add_parser("review")
    export_parser = subparsers.add_parser("export")
    export_parser.add_argument("--dry-run", action="store_true")
    export_parser.add_argument("--output", type=Path)
    export_parser.add_argument("--projection-report-output", type=Path)
    subparsers.add_parser("smoke")
    subparsers.add_parser("validate-pilot")
    subparsers.add_parser("pilot-review")
    subparsers.add_parser("pilot-blind")
    subparsers.add_parser("pilot-smoke")
    subparsers.add_parser("n2-generate")
    subparsers.add_parser("validate-n2")
    subparsers.add_parser("n2-review")
    subparsers.add_parser("n2-blind")
    subparsers.add_parser("n2-smoke")
    args = parser.parse_args(argv)
    try:
        if args.command == "validate-pilot":
            _emit(validate_editorial_json_library())
        elif args.command == "pilot-review":
            workspace = load_editorial_pilot_workspace()
            print(render_editorial_human_review(workspace, workspace["decision"]), end="")
        elif args.command == "pilot-blind":
            print(render_editorial_blind_reading(load_editorial_pilot_workspace()), end="")
        elif args.command == "pilot-smoke":
            _emit(run_editorial_pilot_smoke())
        elif args.command == "n2-generate":
            _emit(generate_n2_artifacts())
        elif args.command == "validate-n2":
            _emit(validate_n2_json_library())
        elif args.command == "n2-review":
            workspace = load_n2_workspace()
            print(render_editorial_human_review(workspace, workspace["decision"]), end="")
        elif args.command == "n2-blind":
            print(render_editorial_blind_reading(load_n2_workspace()), end="")
        elif args.command == "n2-smoke":
            _emit(run_n2_smoke())
        else:
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
