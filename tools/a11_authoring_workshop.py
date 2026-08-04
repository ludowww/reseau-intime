#!/usr/bin/env python3
"""Offline A11 authoring workshop: closed inputs, human gate, A6 projection."""

from __future__ import annotations

import argparse
import copy
import hashlib
import json
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Mapping, Sequence


ROOT = Path(__file__).resolve().parents[1]
FIXTURE_DIR = ROOT / "narrative_tool" / "a11" / "fixtures"
A6_FIXTURE = ROOT / "game" / "data" / "narrative_scenes" / "r8c_a11_sandra_last_lunch_export.json"

FORMAT_CHARACTER = "R8C_A11_CHARACTER_SHEET"
FORMAT_RELATIONSHIPS = "R8C_A11_RELATIONSHIP_REGISTER"
FORMAT_PLAN = "R8C_A11_SCENE_PLAN"
FORMAT_DRAFT = "R8C_A11_DIALOGUE_DRAFT"
FORMAT_REPORT = "R8C_A11_VALIDATION_REPORT"
VERSION = 1
DRAFT_VERSIONS = {1, 2, 3}
VALIDATOR_VERSION = "a11-validator-1.1"

ROOT_KEYS = {
    FORMAT_CHARACTER: {
        "format", "version", "character_id", "display_name", "role", "voice",
        "known_facts", "unknown_facts",
    },
    FORMAT_RELATIONSHIPS: {"format", "version", "relations"},
    FORMAT_PLAN: {
        "format", "version", "plan_id", "title", "participant_ids", "premise",
        "shared_detail", "required_beats", "choice", "media_requirement", "limits",
        "a6_projection",
    },
    FORMAT_DRAFT: {"format", "version", "draft_id", "revision", "plan_id", "messages", "choice"},
    FORMAT_REPORT: {
        "format", "version", "draft_id", "draft_revision", "approval_fingerprint",
        "status", "blocking_errors", "warnings", "human_approval",
    },
}

VOICE_FORBIDDEN_MOTIFS = {
    "déclaration frontale": ("je t'aime", "tu me manques"),
    "séduction immédiate": ("embrasse-moi maintenant", "viens chez moi maintenant"),
    "culpabilisation de Player": ("c'est ta faute", "tu me fais souffrir"),
    "devenir un obstacle": ("tu n'as pas le droit de lui parler",),
    "accusation sans preuve": ("je sais que tu me trompes",),
    "parler comme Sandra": ("notre vieux déjeuner", "nos frites froides"),
}

DRAFT_MESSAGE_KEYS = {
    1: {
        "message_id", "speaker_id", "kind", "text", "fact_refs", "beat_id", "branch",
        "burst_id", "strength", "media",
    },
    2: {
        "message_id", "speaker_id", "kind", "beat_id", "objective_actor_id",
        "conversation_move", "fact_refs", "local_state", "branch", "burst_id", "strength",
        "text", "reply_to", "media",
    },
    3: {
        "message_id", "speaker_id", "kind", "beat_id", "objective_actor_id",
        "conversation_move", "fact_refs", "local_state", "branch", "burst_id", "strength",
        "text", "reply_to", "media",
    },
}
DRAFT_CHOICE_OPTION_KEYS = {
    1: {"option_id", "reception_message_ids"},
    2: {"option_id", "formulation", "reception_message_ids"},
    3: {"option_id", "formulation", "reception_message_ids"},
}


@dataclass(frozen=True)
class Issue:
    code: str
    path: str
    message: str

    def as_json(self) -> dict[str, str]:
        return {"code": self.code, "path": self.path, "message": self.message}


class A11ValidationError(ValueError):
    def __init__(self, issues: Sequence[Issue]):
        self.issues = tuple(issues)
        super().__init__("; ".join(f"{issue.code} at {issue.path}" for issue in self.issues))


class A11ApprovalError(ValueError):
    pass


def _canonical(value: Any) -> str:
    return json.dumps(value, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


def approval_fingerprint(workspace: Mapping[str, Any]) -> str:
    characters = sorted(
        workspace["characters"], key=lambda character: character["character_id"]
    )
    editorial_contract = {
        "characters": characters,
        "relationships": workspace["relationships"],
        "plan": workspace["plan"],
        "draft": workspace["draft"],
        "validator_version": VALIDATOR_VERSION,
    }
    return hashlib.sha256(_canonical(editorial_contract).encode("utf-8")).hexdigest()


def validate_voice_sample(
    character: Mapping[str, Any], messages: Sequence[str]
) -> list[Issue]:
    issues: list[Issue] = []
    if not messages or any(not _nonempty(message) for message in messages):
        _issue(issues, "VOICE_SAMPLE_INVALID", "messages", "messages anonymisés non vides requis")
        return issues
    voice = character["voice"]
    corpus = "\n".join(messages).casefold()
    anchors = [anchor.casefold() for anchor in voice["concrete_anchors"]]
    if not any(anchor in corpus for anchor in anchors):
        _issue(
            issues,
            "VOICE_CONCRETE_ANCHOR_MISSING",
            "messages",
            character["character_id"],
        )
    for forbidden_move in voice["forbidden_moves"]:
        for motif in VOICE_FORBIDDEN_MOTIFS.get(forbidden_move, ()):
            if motif in corpus:
                _issue(
                    issues,
                    "VOICE_FORBIDDEN_MOTIF",
                    "messages",
                    forbidden_move,
                )
                break
    return issues


def _issue(issues: list[Issue], code: str, path: str, message: str) -> None:
    issues.append(Issue(code, path, message))


def _closed(value: Any, keys: set[str], path: str, issues: list[Issue]) -> bool:
    if not isinstance(value, dict):
        _issue(issues, "OBJECT_REQUIRED", path, "objet JSON attendu")
        return False
    actual = set(value)
    if actual != keys:
        missing = sorted(keys - actual)
        unknown = sorted(actual - keys)
        _issue(
            issues,
            "CLOSED_SCHEMA_MISMATCH",
            path,
            f"champs manquants={missing}; champs inconnus={unknown}",
        )
        return False
    return True


def _nonempty(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip()) and value == value.strip()


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


def _validate_header(document: Any, expected_format: str, path: str, issues: list[Issue]) -> bool:
    if not _closed(document, ROOT_KEYS[expected_format], path, issues):
        return False
    if document["format"] != expected_format:
        _issue(issues, "FORMAT_UNKNOWN", f"{path}.format", expected_format)
    if type(document["version"]) is not int or document["version"] != VERSION:
        _issue(issues, "VERSION_UNKNOWN", f"{path}.version", str(VERSION))
    return True


def validate_character(document: Any, path: str = "character") -> list[Issue]:
    issues: list[Issue] = []
    if not _validate_header(document, FORMAT_CHARACTER, path, issues):
        return issues
    for field in ("character_id", "display_name", "role"):
        if not _nonempty(document[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.{field}", "chaîne non vide attendue")
    voice = document["voice"]
    voice_keys = {"rhythm", "tone_markers", "style_rules", "forbidden_moves", "concrete_anchors"}
    if _closed(voice, voice_keys, f"{path}.voice", issues):
        if not _nonempty(voice["rhythm"]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.voice.rhythm", "rythme requis")
        for field in voice_keys - {"rhythm"}:
            _string_list(voice[field], f"{path}.voice.{field}", issues, nonempty=True)
    fact_keys = {"fact_id", "text", "source"}
    seen: set[str] = set()
    for collection_name in ("known_facts", "unknown_facts"):
        collection = document[collection_name]
        if not isinstance(collection, list):
            _issue(issues, "FACT_LIST_REQUIRED", f"{path}.{collection_name}", "tableau attendu")
            continue
        for index, fact in enumerate(collection):
            fact_path = f"{path}.{collection_name}[{index}]"
            if not _closed(fact, fact_keys, fact_path, issues):
                continue
            for field in fact_keys:
                if not _nonempty(fact[field]):
                    _issue(issues, "TEXT_REQUIRED", f"{fact_path}.{field}", "chaîne non vide attendue")
            fact_id = fact.get("fact_id")
            if fact_id in seen:
                _issue(issues, "FACT_ID_DUPLICATE", f"{fact_path}.fact_id", str(fact_id))
            elif _nonempty(fact_id):
                seen.add(fact_id)
    return issues


def validate_relationships(document: Any, path: str = "relationships") -> list[Issue]:
    issues: list[Issue] = []
    if not _validate_header(document, FORMAT_RELATIONSHIPS, path, issues):
        return issues
    relations = document["relations"]
    if not isinstance(relations, list) or not relations:
        _issue(issues, "RELATION_LIST_REQUIRED", f"{path}.relations", "tableau non vide attendu")
        return issues
    relation_keys = {"relation_id", "participant_ids", "kind", "shared_facts", "boundaries"}
    fact_keys = {"fact_id", "text", "known_by"}
    seen_relations: set[str] = set()
    for index, relation in enumerate(relations):
        seen_facts: set[str] = set()
        relation_path = f"{path}.relations[{index}]"
        if not _closed(relation, relation_keys, relation_path, issues):
            continue
        for field in ("relation_id", "kind"):
            if not _nonempty(relation[field]):
                _issue(issues, "TEXT_REQUIRED", f"{relation_path}.{field}", "chaîne non vide attendue")
        relation_id = relation.get("relation_id")
        if relation_id in seen_relations:
            _issue(issues, "RELATION_ID_DUPLICATE", f"{relation_path}.relation_id", str(relation_id))
        elif _nonempty(relation_id):
            seen_relations.add(relation_id)
        participants = relation["participant_ids"]
        participants_valid = _string_list(
            participants, f"{relation_path}.participant_ids", issues, nonempty=True
        )
        if not participants_valid or len(participants) != 2:
            _issue(issues, "RELATION_PAIR_REQUIRED", f"{relation_path}.participant_ids", "deux participants distincts attendus")
        participant_set = set(participants) if participants_valid else set()
        _string_list(relation["boundaries"], f"{relation_path}.boundaries", issues, nonempty=True)
        shared_facts = relation["shared_facts"]
        if not isinstance(shared_facts, list) or not shared_facts:
            _issue(issues, "SHARED_FACT_LIST_REQUIRED", f"{relation_path}.shared_facts", "tableau non vide attendu")
            continue
        for fact_index, fact in enumerate(shared_facts):
            fact_path = f"{relation_path}.shared_facts[{fact_index}]"
            if not _closed(fact, fact_keys, fact_path, issues):
                continue
            if not _nonempty(fact["fact_id"]) or not _nonempty(fact["text"]):
                _issue(issues, "SHARED_FACT_INVALID", fact_path, "identité et texte requis")
            known_by_valid = _string_list(
                fact["known_by"], f"{fact_path}.known_by", issues, nonempty=True
            )
            if known_by_valid and not set(fact["known_by"]).issubset(participant_set):
                _issue(issues, "SHARED_FACT_KNOWLEDGE_INVALID", f"{fact_path}.known_by", "personnage hors relation")
            if fact["fact_id"] in seen_facts:
                _issue(issues, "FACT_ID_DUPLICATE", f"{fact_path}.fact_id", fact["fact_id"])
            seen_facts.add(fact["fact_id"])
    return issues


def validate_plan(document: Any, path: str = "plan") -> list[Issue]:
    issues: list[Issue] = []
    if not _validate_header(document, FORMAT_PLAN, path, issues):
        return issues
    for field in ("plan_id", "title", "premise", "shared_detail"):
        if not _nonempty(document[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.{field}", "chaîne non vide attendue")
    _string_list(document["participant_ids"], f"{path}.participant_ids", issues, nonempty=True)
    beats = document["required_beats"]
    beat_keys = {"beat_id", "goal"}
    beat_ids: set[str] = set()
    if not isinstance(beats, list) or not beats:
        _issue(issues, "BEAT_LIST_REQUIRED", f"{path}.required_beats", "tableau non vide attendu")
    else:
        for index, beat in enumerate(beats):
            beat_path = f"{path}.required_beats[{index}]"
            if not _closed(beat, beat_keys, beat_path, issues):
                continue
            if not _nonempty(beat["beat_id"]) or not _nonempty(beat["goal"]):
                _issue(issues, "BEAT_INVALID", beat_path, "identité et but requis")
            if beat["beat_id"] in beat_ids:
                _issue(issues, "BEAT_ID_DUPLICATE", f"{beat_path}.beat_id", beat["beat_id"])
            beat_ids.add(beat["beat_id"])
    choice = document["choice"]
    choice_keys = {"choice_id", "prompt", "after_beat_id", "converge_beat_id", "options"}
    option_keys = {"option_id", "attitude", "formulation", "signal", "sandra_local_state"}
    if _closed(choice, choice_keys, f"{path}.choice", issues):
        for field in choice_keys - {"options"}:
            if not _nonempty(choice[field]):
                _issue(issues, "TEXT_REQUIRED", f"{path}.choice.{field}", "chaîne non vide attendue")
        if choice["after_beat_id"] not in beat_ids or choice["converge_beat_id"] not in beat_ids:
            _issue(issues, "CHOICE_BEAT_REFERENCE_INVALID", f"{path}.choice", "beat de choix ou convergence inconnu")
        options = choice["options"]
        if not isinstance(options, list) or len(options) != 2:
            _issue(issues, "CHOICE_OPTIONS_REQUIRED", f"{path}.choice.options", "exactement deux attitudes attendues")
        else:
            option_ids: set[str] = set()
            states: set[str] = set()
            for index, option in enumerate(options):
                option_path = f"{path}.choice.options[{index}]"
                if not _closed(option, option_keys, option_path, issues):
                    continue
                for field in option_keys:
                    if not _nonempty(option[field]):
                        _issue(issues, "TEXT_REQUIRED", f"{option_path}.{field}", "chaîne non vide attendue")
                option_ids.add(option["option_id"])
                states.add(option["sandra_local_state"])
            if len(option_ids) != 2 or len(states) != 2:
                _issue(issues, "CHOICE_RECEPTION_NOT_DISTINCT", f"{path}.choice.options", "identités et états locaux distincts attendus")
    media = document["media_requirement"]
    media_keys = {"required", "kind", "linked_fact_id", "justification"}
    if _closed(media, media_keys, f"{path}.media_requirement", issues):
        if type(media["required"]) is not bool:
            _issue(issues, "BOOLEAN_REQUIRED", f"{path}.media_requirement.required", "booléen attendu")
        for field in media_keys - {"required"}:
            if not _nonempty(media[field]):
                _issue(issues, "TEXT_REQUIRED", f"{path}.media_requirement.{field}", "chaîne non vide attendue")
    limits = document["limits"]
    limit_keys = {"forbidden_phrases", "forbidden_outcomes", "route_lock_allowed", "major_consequence_allowed"}
    if _closed(limits, limit_keys, f"{path}.limits", issues):
        _string_list(limits["forbidden_phrases"], f"{path}.limits.forbidden_phrases", issues, nonempty=True)
        _string_list(limits["forbidden_outcomes"], f"{path}.limits.forbidden_outcomes", issues, nonempty=True)
        for field in ("route_lock_allowed", "major_consequence_allowed"):
            if type(limits[field]) is not bool or limits[field]:
                _issue(issues, "LIMIT_MUST_REMAIN_FALSE", f"{path}.limits.{field}", "false requis dans ce prototype")
    projection = document["a6_projection"]
    projection_keys = {
        "scene_definition_id", "variant_id", "version_contract", "nature", "function",
        "compatible_act_ids", "required_event_ids", "forbidden_event_ids", "start_date",
        "end_date", "opening_time", "closing_time", "duration_minutes", "uniqueness",
        "expiration_policy",
    }
    if _closed(projection, projection_keys, f"{path}.a6_projection", issues):
        for field in projection_keys - {"compatible_act_ids", "required_event_ids", "forbidden_event_ids", "duration_minutes"}:
            if not _nonempty(projection[field]):
                _issue(issues, "TEXT_REQUIRED", f"{path}.a6_projection.{field}", "chaîne non vide attendue")
        for field in ("compatible_act_ids", "required_event_ids", "forbidden_event_ids"):
            _string_list(projection[field], f"{path}.a6_projection.{field}", issues, nonempty=field == "compatible_act_ids")
        if type(projection["duration_minutes"]) is not int or projection["duration_minutes"] <= 0:
            _issue(issues, "DURATION_INVALID", f"{path}.a6_projection.duration_minutes", "entier positif attendu")
    return issues


def validate_draft_format(document: Any, path: str = "draft") -> list[Issue]:
    issues: list[Issue] = []
    if not _closed(document, ROOT_KEYS[FORMAT_DRAFT], path, issues):
        return issues
    if document["format"] != FORMAT_DRAFT:
        _issue(issues, "FORMAT_UNKNOWN", f"{path}.format", FORMAT_DRAFT)
    version = document["version"]
    if type(version) is not int or version not in DRAFT_VERSIONS:
        _issue(
            issues,
            "VERSION_UNKNOWN",
            f"{path}.version",
            ", ".join(str(item) for item in sorted(DRAFT_VERSIONS)),
        )
        return issues
    for field in ("draft_id", "revision", "plan_id"):
        if not _nonempty(document[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.{field}", "chaîne non vide attendue")
    messages = document["messages"]
    media_keys = {"media_id", "kind", "description", "justification", "linked_fact_id"}
    if not isinstance(messages, list):
        _issue(issues, "MESSAGE_LIST_REQUIRED", f"{path}.messages", "tableau attendu")
    else:
        for index, message in enumerate(messages):
            message_path = f"{path}.messages[{index}]"
            if not _closed(message, DRAFT_MESSAGE_KEYS[version], message_path, issues):
                continue
            for field in ("message_id", "speaker_id", "kind", "text", "beat_id", "branch", "strength"):
                if not _nonempty(message[field]):
                    _issue(issues, "TEXT_REQUIRED", f"{message_path}.{field}", "chaîne non vide attendue")
            if version in {2, 3}:
                for field in ("objective_actor_id", "conversation_move", "local_state"):
                    if not _nonempty(message[field]):
                        _issue(issues, "TEXT_REQUIRED", f"{message_path}.{field}", "chaîne non vide attendue")
            _string_list(
                message["fact_refs"],
                f"{message_path}.fact_refs",
                issues,
                nonempty=version == 2,
            )
            allowed_kinds = {"TEXT"} if version == 2 else {"TEXT", "IMAGE"}
            if message["kind"] not in allowed_kinds:
                _issue(issues, "MESSAGE_KIND_UNKNOWN", f"{message_path}.kind", str(message["kind"]))
            if message["strength"] not in {"WEAK", "NORMAL"}:
                _issue(issues, "MESSAGE_STRENGTH_UNKNOWN", f"{message_path}.strength", str(message["strength"]))
            if message["burst_id"] is not None and not _nonempty(message["burst_id"]):
                _issue(issues, "BURST_ID_INVALID", f"{message_path}.burst_id", "null ou chaîne non vide attendu")
            if version in {2, 3}:
                if message["reply_to"] is not None and not _nonempty(message["reply_to"]):
                    _issue(
                        issues,
                        "REFERENCE_INVALID",
                        f"{message_path}.reply_to",
                        "null ou chaîne non vide attendu",
                    )
            if version == 2:
                if message["media"] is not None:
                    _issue(issues, "MEDIA_FORBIDDEN", message_path, "texte sans média attendu")
            elif version == 3 and message["kind"] == "IMAGE":
                if _closed(message["media"], media_keys, f"{message_path}.media", issues):
                    for field in media_keys:
                        if not _nonempty(message["media"][field]):
                            _issue(issues, "MEDIA_FIELD_REQUIRED", f"{message_path}.media.{field}", "chaîne non vide attendue")
            elif version == 3 and message["media"] is not None:
                _issue(issues, "TEXT_MEDIA_FORBIDDEN", f"{message_path}.media", "null attendu pour un texte")
            elif message["kind"] == "IMAGE":
                if _closed(message["media"], media_keys, f"{message_path}.media", issues):
                    for field in media_keys:
                        if not _nonempty(message["media"][field]):
                            _issue(issues, "MEDIA_FIELD_REQUIRED", f"{message_path}.media.{field}", "chaîne non vide attendue")
            elif message["media"] is not None:
                _issue(issues, "TEXT_MEDIA_FORBIDDEN", f"{message_path}.media", "null attendu pour un texte")
    choice = document["choice"]
    choice_keys = {"choice_id", "after_message_id", "converge_at_message_id", "options"}
    if _closed(choice, choice_keys, f"{path}.choice", issues):
        for field in choice_keys - {"options"}:
            if not _nonempty(choice[field]):
                _issue(issues, "TEXT_REQUIRED", f"{path}.choice.{field}", "chaîne non vide attendue")
        options = choice["options"]
        if not isinstance(options, list) or len(options) != 2:
            _issue(issues, "CHOICE_OPTIONS_REQUIRED", f"{path}.choice.options", "deux options attendues")
        else:
            for index, option in enumerate(options):
                option_path = f"{path}.choice.options[{index}]"
                if _closed(option, DRAFT_CHOICE_OPTION_KEYS[version], option_path, issues):
                    if not _nonempty(option["option_id"]):
                        _issue(issues, "TEXT_REQUIRED", f"{option_path}.option_id", "identité requise")
                    if version in {2, 3} and not _nonempty(option["formulation"]):
                        _issue(issues, "TEXT_REQUIRED", f"{option_path}.formulation", "formulation requise")
                    _string_list(option["reception_message_ids"], f"{option_path}.reception_message_ids", issues, nonempty=True)
    return issues


def validate_report_format(document: Any, path: str = "report") -> list[Issue]:
    issues: list[Issue] = []
    if not _validate_header(document, FORMAT_REPORT, path, issues):
        return issues
    for field in ("draft_id", "draft_revision", "approval_fingerprint", "status"):
        if not _nonempty(document[field]):
            _issue(issues, "TEXT_REQUIRED", f"{path}.{field}", "chaîne non vide attendue")
    if document["status"] not in {"BLOCKED", "READY", "READY_WITH_WARNINGS"}:
        _issue(issues, "REPORT_STATUS_UNKNOWN", f"{path}.status", str(document["status"]))
    issue_keys = {"code", "path", "message"}
    for field in ("blocking_errors", "warnings"):
        values = document[field]
        if not isinstance(values, list):
            _issue(issues, "ISSUE_LIST_REQUIRED", f"{path}.{field}", "tableau attendu")
            continue
        for index, value in enumerate(values):
            value_path = f"{path}.{field}[{index}]"
            if _closed(value, issue_keys, value_path, issues):
                for key in issue_keys:
                    if not _nonempty(value[key]):
                        _issue(issues, "ISSUE_INVALID", f"{value_path}.{key}", "chaîne non vide attendue")
    approval = document["human_approval"]
    approval_keys = {"decision", "approved_by", "draft_revision", "approval_fingerprint"}
    if approval is not None and _closed(approval, approval_keys, f"{path}.human_approval", issues):
        if approval["decision"] != "APPROVED":
            _issue(issues, "APPROVAL_DECISION_INVALID", f"{path}.human_approval.decision", "APPROVED attendu")
        for field in approval_keys - {"decision"}:
            if not _nonempty(approval[field]):
                _issue(issues, "APPROVAL_FIELD_REQUIRED", f"{path}.human_approval.{field}", "chaîne non vide attendue")
    if document["status"] == "BLOCKED" and not document["blocking_errors"]:
        _issue(issues, "BLOCKED_REPORT_WITHOUT_ERROR", path, "une erreur bloquante est requise")
    if document["status"] != "BLOCKED" and document["blocking_errors"]:
        _issue(issues, "READY_REPORT_WITH_ERROR", path, "aucune erreur bloquante permise")
    return issues


def _read_json(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise A11ValidationError([Issue("JSON_READ_FAILED", str(path), str(exc))]) from exc
    if not isinstance(value, dict):
        raise A11ValidationError([Issue("JSON_OBJECT_REQUIRED", str(path), "racine objet attendue")])
    return value


def load_workspace(
    character_paths: Sequence[Path],
    relationship_path: Path,
    plan_path: Path,
    draft_path: Path,
    report_path: Path | None = None,
) -> dict[str, Any]:
    candidates = {
        "characters": [_read_json(Path(path)) for path in character_paths],
        "relationships": _read_json(Path(relationship_path)),
        "plan": _read_json(Path(plan_path)),
        "draft": _read_json(Path(draft_path)),
        "report": _read_json(Path(report_path)) if report_path is not None else None,
    }
    issues: list[Issue] = []
    for index, character in enumerate(candidates["characters"]):
        issues.extend(validate_character(character, f"characters[{index}]"))
    issues.extend(validate_relationships(candidates["relationships"]))
    issues.extend(validate_plan(candidates["plan"]))
    issues.extend(validate_draft_format(candidates["draft"]))
    if candidates["report"] is not None:
        issues.extend(validate_report_format(candidates["report"]))
    if not issues:
        issues.extend(_validate_references(candidates))
    if issues:
        raise A11ValidationError(issues)
    return copy.deepcopy(candidates)


def _validate_references(workspace: Mapping[str, Any]) -> list[Issue]:
    issues: list[Issue] = []
    characters = workspace["characters"]
    character_ids = [character["character_id"] for character in characters]
    if len(character_ids) != len(set(character_ids)):
        _issue(issues, "CHARACTER_ID_DUPLICATE", "characters", "identités dupliquées")
    character_set = set(character_ids)
    relations = workspace["relationships"]["relations"]
    relation_pairs: set[frozenset[str]] = set()
    for index, relation in enumerate(relations):
        pair = set(relation["participant_ids"])
        if not pair.issubset(character_set):
            _issue(issues, "RELATION_CHARACTER_UNKNOWN", f"relationships.relations[{index}]", "personnage inconnu")
        relation_pairs.add(frozenset(pair))
    required_pairs = {
        frozenset(("sandra", "player")),
        frozenset(("marie", "player")),
        frozenset(("sandra", "marie")),
    }
    if not required_pairs.issubset(relation_pairs):
        _issue(issues, "PROTOTYPE_RELATION_MISSING", "relationships.relations", "les trois relations Sandra/Marie/Player sont requises")
    plan = workspace["plan"]
    if not set(plan["participant_ids"]).issubset(character_set):
        _issue(issues, "PLAN_CHARACTER_UNKNOWN", "plan.participant_ids", "personnage inconnu")
    draft = workspace["draft"]
    if draft["plan_id"] != plan["plan_id"]:
        _issue(issues, "DRAFT_PLAN_MISMATCH", "draft.plan_id", plan["plan_id"])
    if workspace["report"] is not None:
        report = workspace["report"]
        if report["draft_id"] != draft["draft_id"]:
            _issue(issues, "REPORT_DRAFT_MISMATCH", "report.draft_id", draft["draft_id"])
        if report["draft_revision"] != draft["revision"]:
            _issue(issues, "REPORT_REVISION_MISMATCH", "report.draft_revision", draft["revision"])
        fingerprint = approval_fingerprint(workspace)
        if report["approval_fingerprint"] != fingerprint:
            _issue(issues, "REPORT_FINGERPRINT_MISMATCH", "report.approval_fingerprint", "empreinte éditoriale différente")
        approval = report["human_approval"]
        if approval is not None:
            if approval["draft_revision"] != draft["revision"]:
                _issue(issues, "APPROVAL_REVISION_MISMATCH", "report.human_approval.draft_revision", draft["revision"])
            if approval["approval_fingerprint"] != fingerprint:
                _issue(issues, "APPROVAL_FINGERPRINT_MISMATCH", "report.human_approval.approval_fingerprint", "empreinte éditoriale différente")
    return issues


def compile_context(workspace: Mapping[str, Any]) -> str:
    plan = workspace["plan"]
    characters = sorted(
        workspace["characters"],
        key=lambda character: character["character_id"],
    )
    relations = sorted(
        workspace["relationships"]["relations"],
        key=lambda relation: relation["relation_id"],
    )
    sections = [
        "# A11 deterministic authoring context",
        f"plan={plan['plan_id']}",
        "active_participants=" + ",".join(plan["participant_ids"]),
        "## plan",
        _canonical({key: plan[key] for key in sorted(plan) if key not in {"format", "version"}}),
        "## characters",
        _canonical(characters),
        "## relationships",
        _canonical(relations),
    ]
    return "\n".join(sections) + "\n"


def validate_draft(workspace: Mapping[str, Any]) -> dict[str, Any]:
    draft = workspace["draft"]
    plan = workspace["plan"]
    errors: list[Issue] = []
    warnings: list[Issue] = []
    messages = draft["messages"]
    if not 45 <= len(messages) <= 70:
        _issue(errors, "DRAFT_BUBBLE_COUNT_BLOCKING", "draft.messages", "45 à 70 bulles requises")
    message_ids = [message["message_id"] for message in messages]
    if len(message_ids) != len(set(message_ids)):
        _issue(errors, "MESSAGE_ID_DUPLICATE", "draft.messages", "identités dupliquées")
    message_index = {message["message_id"]: index for index, message in enumerate(messages)}
    participant_ids = set(plan["participant_ids"])
    beat_ids = {beat["beat_id"] for beat in plan["required_beats"]}
    used_beats: set[str] = set()

    known_by: dict[str, set[str]] = {}
    unknown_by: dict[str, set[str]] = {}
    for character in workspace["characters"]:
        character_id = character["character_id"]
        for fact in character["known_facts"]:
            known_by.setdefault(fact["fact_id"], set()).add(character_id)
        for fact in character["unknown_facts"]:
            unknown_by.setdefault(fact["fact_id"], set()).add(character_id)
    for relation in workspace["relationships"]["relations"]:
        for fact in relation["shared_facts"]:
            known_by.setdefault(fact["fact_id"], set()).update(fact["known_by"])

    media_messages: list[dict[str, Any]] = []
    lowered_texts: list[str] = []
    for index, message in enumerate(messages):
        message_path = f"draft.messages[{index}]"
        speaker = message["speaker_id"]
        if speaker not in participant_ids:
            _issue(errors, "MESSAGE_SPEAKER_UNKNOWN", f"{message_path}.speaker_id", speaker)
        if message["beat_id"] not in beat_ids:
            _issue(errors, "MESSAGE_BEAT_UNKNOWN", f"{message_path}.beat_id", message["beat_id"])
        used_beats.add(message["beat_id"])
        for fact_id in message["fact_refs"]:
            if fact_id in unknown_by and speaker in unknown_by[fact_id]:
                _issue(errors, "FACT_EXPLICITLY_UNKNOWN", f"{message_path}.fact_refs", f"{speaker}: {fact_id}")
            elif speaker not in known_by.get(fact_id, set()):
                _issue(errors, "FACT_NOT_KNOWN_BY_SPEAKER", f"{message_path}.fact_refs", f"{speaker}: {fact_id}")
        lowered_texts.append(message["text"].casefold())
        if len(message["text"]) > 120:
            _issue(warnings, "STYLE_LONG_BUBBLE", f"{message_path}.text", "bulle longue à relire")
        if message["kind"] == "IMAGE":
            media_messages.append(message)
    missing_beats = sorted(beat_ids - used_beats)
    if missing_beats:
        _issue(errors, "REQUIRED_BEAT_MISSING", "draft.messages", ", ".join(missing_beats))

    media_requirement = plan["media_requirement"]
    matching_media = [
        message for message in media_messages
        if message["media"]["kind"] == media_requirement["kind"]
        and message["media"]["linked_fact_id"] == media_requirement["linked_fact_id"]
        and media_requirement["linked_fact_id"] in message["fact_refs"]
        and message["media"]["justification"] == media_requirement["justification"]
    ]
    if media_requirement["required"] and len(matching_media) != 1:
        _issue(errors, "MEDIA_JUSTIFICATION_BLOCKING", "draft.messages", "un média relié au détail partagé est requis")

    choice = draft["choice"]
    plan_choice = plan["choice"]
    if choice["choice_id"] != plan_choice["choice_id"]:
        _issue(errors, "CHOICE_ID_MISMATCH", "draft.choice.choice_id", plan_choice["choice_id"])
    if choice["after_message_id"] not in message_index or choice["converge_at_message_id"] not in message_index:
        _issue(errors, "CHOICE_MESSAGE_REFERENCE_UNKNOWN", "draft.choice", "ancrage ou convergence inconnu")
    else:
        after_index = message_index[choice["after_message_id"]]
        converge_index = message_index[choice["converge_at_message_id"]]
        expected_options = {option["option_id"]: option for option in plan_choice["options"]}
        actual_options = {option["option_id"]: option for option in choice["options"]}
        if set(actual_options) != set(expected_options):
            _issue(errors, "CHOICE_OPTION_MISMATCH", "draft.choice.options", "options différentes du plan")
        for option_id, option in actual_options.items():
            for reception_id in option["reception_message_ids"]:
                if reception_id not in message_index:
                    _issue(errors, "CHOICE_RECEPTION_UNKNOWN", "draft.choice.options", reception_id)
                    continue
                reception_index = message_index[reception_id]
                if not after_index < reception_index < converge_index:
                    _issue(errors, "CHOICE_RECEPTION_ORDER_INVALID", "draft.choice.options", reception_id)
                if messages[reception_index]["branch"] != option_id:
                    _issue(errors, "CHOICE_RECEPTION_BRANCH_INVALID", "draft.choice.options", reception_id)
        if converge_index <= after_index:
            _issue(errors, "CHOICE_CONVERGENCE_ORDER_INVALID", "draft.choice", "convergence trop tôt")

    complete_text = "\n".join(lowered_texts)
    for phrase in plan["limits"]["forbidden_phrases"]:
        if phrase.casefold() in complete_text:
            _issue(errors, "FORBIDDEN_PHRASE", "draft.messages", phrase)

    profiles = {character["character_id"]: character for character in workspace["characters"]}
    if profiles["sandra"]["voice"]["tone_markers"] == profiles["marie"]["voice"]["tone_markers"]:
        _issue(errors, "VOICES_NOT_DIFFERENTIATED", "characters", "Sandra et Marie doivent rester distinctes")

    status = "BLOCKED" if errors else ("READY_WITH_WARNINGS" if warnings else "READY")
    return {
        "format": FORMAT_REPORT,
        "version": VERSION,
        "draft_id": draft["draft_id"],
        "draft_revision": draft["revision"],
        "approval_fingerprint": approval_fingerprint(workspace),
        "status": status,
        "blocking_errors": [issue.as_json() for issue in errors],
        "warnings": [issue.as_json() for issue in warnings],
        "human_approval": None,
    }


def approve_report(
    report: Mapping[str, Any], workspace: Mapping[str, Any], approved_by: str
) -> dict[str, Any]:
    issues = validate_report_format(report)
    if issues:
        raise A11ValidationError(issues)
    if not _nonempty(approved_by):
        raise A11ApprovalError("approved_by must be a non-empty human identifier")
    draft = workspace["draft"]
    fingerprint = approval_fingerprint(workspace)
    if (
        report["status"] == "BLOCKED"
        or report["blocking_errors"]
        or report["draft_id"] != draft["draft_id"]
        or report["draft_revision"] != draft["revision"]
        or report["approval_fingerprint"] != fingerprint
    ):
        raise A11ApprovalError("report is not approvable for this draft revision")
    approved = copy.deepcopy(report)
    approved["human_approval"] = {
        "decision": "APPROVED",
        "approved_by": approved_by,
        "draft_revision": draft["revision"],
        "approval_fingerprint": fingerprint,
    }
    return approved


def build_a6_scene_library(
    *,
    scene_definition_id: str,
    variant_id: str,
    version_contract: str,
    title: str,
    nature: str,
    function: str,
    participant_ids: Sequence[str],
    compatible_act_ids: Sequence[str],
    required_event_ids: Sequence[str],
    forbidden_event_ids: Sequence[str],
    start_date: str,
    end_date: str,
    opening_time: str,
    closing_time: str,
    duration_minutes: int,
    uniqueness: str,
    relation_or_question: str,
    stable_core: str,
    structure_id: str,
    choices: Sequence[Mapping[str, str]],
    expiration_policy: str,
    resolution_character_id: str = "sandra",
) -> dict[str, Any]:
    """Serialize one normalized A11 scene into the closed A6 test bundle shape."""
    exported_choices: list[dict[str, Any]] = []
    resolutions: dict[str, dict[str, Any]] = {}
    for option in choices:
        resolution_id = f"{option['option_id']}_reception"
        exported_choices.append({
            "choix_id": option["option_id"],
            "formulation": option["formulation"],
            "signal_emis": option["signal"],
            "resolution_ids": [resolution_id],
        })
        resolutions[resolution_id] = {
            "personnage_id": resolution_character_id,
            "portee_micro_signal": "LOCALE",
            "signal_recu": option["signal"],
            "reception": "NON_PERSISTANTE",
            "interpretation": option["reception_interpretation"],
            "faits_relationnels": [],
            "convergence": "RETOUR_NOYAU_COMMUN",
        }
    definition = {
        "scene_id": scene_definition_id,
        "version_contrat": version_contract,
        "titre_interne": title,
        "nature": nature,
        "fonction_principale": function,
        "participants_requis": [
            {"personnage_id": participant_id, "role": "PARTICIPANT_AUTEUR"}
            for participant_id in participant_ids
        ],
        "conditions_dures": {
            "actes_compatibles": list(compatible_act_ids),
            "evenements_requis": list(required_event_ids),
        },
        "exclusions_dures": {"evenements_interdits": list(forbidden_event_ids)},
        "contrat_temporel": {
            "date_debut": start_date,
            "date_fin": end_date,
            "heure_ouverture": opening_time,
            "heure_fermeture": closing_time,
            "duree_minutes": duration_minutes,
            "revalidation": "AVANT_PROPOSITION_ET_RESOLUTION",
        },
        "politique_unicite": uniqueness,
        "relation_ou_question_focale": relation_or_question,
        "noyau_stable": stable_core,
        "structure_id": structure_id,
        "choix": exported_choices,
        "resolutions": resolutions,
        "politique_non_resolution": {"proposition_expire": expiration_policy},
    }
    return {
        "format": "R8C_A6_SCENE_LIBRARY",
        "version": VERSION,
        "definitions": [{
            "scene_definition_id": scene_definition_id,
            "variant_id": variant_id,
            "definition": definition,
        }],
    }


def export_a6(workspace: Mapping[str, Any], report: Mapping[str, Any]) -> dict[str, Any]:
    draft = workspace["draft"]
    plan = workspace["plan"]
    fingerprint = approval_fingerprint(workspace)
    approval = report.get("human_approval")
    if (
        report.get("status") == "BLOCKED"
        or report.get("blocking_errors")
        or report.get("draft_id") != draft["draft_id"]
        or report.get("draft_revision") != draft["revision"]
        or report.get("approval_fingerprint") != fingerprint
        or not isinstance(approval, dict)
        or approval.get("decision") != "APPROVED"
        or approval.get("draft_revision") != draft["revision"]
        or approval.get("approval_fingerprint") != fingerprint
    ):
        raise A11ApprovalError("A6 export refused: exact approved revision required")
    projection = plan["a6_projection"]
    options = plan["choice"]["options"]
    normalized_choices = [
        {
            "option_id": option["option_id"],
            "formulation": option["formulation"],
            "signal": option["signal"],
            "reception_interpretation": option["sandra_local_state"],
        }
        for option in options
    ]
    return build_a6_scene_library(
        scene_definition_id=projection["scene_definition_id"],
        variant_id=projection["variant_id"],
        version_contract=projection["version_contract"],
        title=plan["title"],
        nature=projection["nature"],
        function=projection["function"],
        participant_ids=plan["participant_ids"],
        compatible_act_ids=projection["compatible_act_ids"],
        required_event_ids=projection["required_event_ids"],
        forbidden_event_ids=projection["forbidden_event_ids"],
        start_date=projection["start_date"],
        end_date=projection["end_date"],
        opening_time=projection["opening_time"],
        closing_time=projection["closing_time"],
        duration_minutes=projection["duration_minutes"],
        uniqueness=projection["uniqueness"],
        relation_or_question=plan["premise"],
        stable_core=plan["shared_detail"],
        structure_id=plan["plan_id"],
        choices=normalized_choices,
        expiration_policy=projection["expiration_policy"],
    )


def default_paths(*, invalid: bool = False) -> dict[str, Any]:
    return {
        "character_paths": [
            FIXTURE_DIR / "character_sandra.json",
            FIXTURE_DIR / "character_marie.json",
            FIXTURE_DIR / "character_player.json",
        ],
        "relationship_path": FIXTURE_DIR / "relationship_register.json",
        "plan_path": FIXTURE_DIR / "scene_plan_a11_sandra_last_lunch_detail.json",
        "draft_path": FIXTURE_DIR / ("dialogue_draft_invalid.json" if invalid else "dialogue_draft_a11_sandra_last_lunch_detail.json"),
        "report_path": None if invalid else FIXTURE_DIR / "validation_report_a11_sandra_last_lunch_detail.json",
    }


def _emit(value: Any) -> None:
    print(json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True))


def run_smoke() -> dict[str, Any]:
    workspace = load_workspace(**default_paths())
    context = compile_context(workspace)
    if context != compile_context(workspace):
        raise AssertionError("context is not deterministic")
    generated = validate_draft(workspace)
    if generated["status"] == "BLOCKED":
        raise AssertionError("valid fixture is blocked")
    try:
        export_a6(workspace, generated)
    except A11ApprovalError:
        refused_without_approval = True
    else:
        refused_without_approval = False
    if not refused_without_approval:
        raise AssertionError("export must be refused without approval")
    exported = export_a6(workspace, workspace["report"])
    if exported != _read_json(A6_FIXTURE):
        raise AssertionError("checked-in A6 fixture differs from approved export")
    invalid_workspace = load_workspace(**default_paths(invalid=True))
    invalid_report = validate_draft(invalid_workspace)
    if invalid_report["status"] != "BLOCKED":
        raise AssertionError("invalid fixture must be blocked")
    return {
        "ok": True,
        "bubble_count": len(workspace["draft"]["messages"]),
        "context_sha256": hashlib.sha256(context.encode("utf-8")).hexdigest(),
        "warnings": len(generated["warnings"]),
        "invalid_error_codes": [issue["code"] for issue in invalid_report["blocking_errors"]],
        "a6_scene_definition_id": exported["definitions"][0]["scene_definition_id"],
    }


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Offline R8C-A11 authoring workshop")
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("context")
    subparsers.add_parser("validate")
    export_parser = subparsers.add_parser("export")
    export_parser.add_argument("--dry-run", action="store_true")
    export_parser.add_argument("--output", type=Path)
    subparsers.add_parser("smoke")
    args = parser.parse_args(argv)
    try:
        workspace = load_workspace(**default_paths())
        if args.command == "context":
            print(compile_context(workspace), end="")
        elif args.command == "validate":
            _emit(validate_draft(workspace))
        elif args.command == "export":
            exported = export_a6(workspace, workspace["report"])
            if args.output is not None and not args.dry_run:
                args.output.write_text(json.dumps(exported, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
            else:
                _emit(exported)
        else:
            _emit(run_smoke())
    except (A11ValidationError, A11ApprovalError, AssertionError) as exc:
        print(f"A11_ERROR: {exc}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
