#!/usr/bin/env python3
"""Simulate simple deterministic narrative route paths for days 1-4.

This is a product/debug probe, not a full game engine. Paths are manually
curated from the current J1-J3 truth, including the domestic nocturnal
Mathilde pivot on J3, with J4+ kept as legacy / prospective route probes.
Run from repository root:

    python3 tools/simulate_route_paths.py
"""

from __future__ import annotations

import copy
import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
INITIAL_STATE_PATH = ROOT / "game" / "data" / "state" / "initial_state.json"

ROUTES = ("marie", "mathilde", "sandra", "pauline", "nico_marie")
STRONG_ROUTE_MARGIN = 8
FINAL_LOCK_SCORE = 90
BALANCED_STRONG_SCORE = 25

# J3 labels intentionally reference the domestic/night pivot instead of the old party-day wording.
# Pauline / Nico routes remain as future or J4+ legacy probes, not as active J3 party beats.


@dataclass(frozen=True)
class Step:
    label: str
    effects: dict[str, int] = field(default_factory=dict)
    flags: tuple[str, ...] = ()
    passive: dict[str, int] = field(default_factory=dict)


@dataclass(frozen=True)
class PathSpec:
    name: str
    expected_route: str | None
    expected_threat: str
    steps: tuple[Step, ...]
    allow_strong_route: bool = True


def load_initial_state() -> dict[str, Any]:
    with INITIAL_STATE_PATH.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def get_value(state: dict[str, Any], key: str) -> int:
    if "." in key:
        character, stat = key.split(".", 1)
        return int(state["characters"][character][stat])
    if key in state["global"]:
        return int(state["global"][key])
    if key in state["passive_signals"]:
        return int(state["passive_signals"][key])
    raise KeyError(f"Unknown variable: {key}")


def add_value(state: dict[str, Any], key: str, delta: int) -> None:
    if "." in key:
        character, stat = key.split(".", 1)
        state["characters"][character][stat] = int(state["characters"][character][stat]) + delta
        return
    if key in state["global"]:
        state["global"][key] = int(state["global"][key]) + delta
        return
    if key in state["passive_signals"]:
        state["passive_signals"][key] = int(state["passive_signals"][key]) + delta
        return
    raise KeyError(f"Unknown variable: {key}")


def apply_step(state: dict[str, Any], step: Step) -> None:
    for key, delta in step.effects.items():
        add_value(state, key, delta)
    for key, delta in step.passive.items():
        add_value(state, key, delta)
    flags = set(state.get("flags", []))
    flags.update(step.flags)
    state["flags"] = sorted(flags)


def route_scores(state: dict[str, Any]) -> dict[str, int]:
    """Score route pressure from day-1 baseline deltas, not final locks."""
    flags = set(state["flags"])
    scores = {
        "marie": (
            (get_value(state, "marie.trust") - 60) * 3
            + (get_value(state, "truth_tendency") - 30) * 2
            + get_value(state, "marie_attention_score") * 8
            - get_value(state, "lie_score") * 2
            - get_value(state, "marie_neglect_score") * 6
        ),
        "mathilde": (
            (get_value(state, "mathilde.desire") - 20) * 3
            + get_value(state, "mathilde_attention_score") * 8
            + get_value(state, "lie_score") * 2
            + (8 if "first_proof_mathilde_warning_photo_day4" in flags else 0)
            - max(0, get_value(state, "mathilde.loyalty") - 80) // 2
        ),
        "sandra": (
            (get_value(state, "sandra.attachment") - 25) * 3
            + get_value(state, "sandra_priority_score") * 9
            + get_value(state, "lie_score")
            + (8 if "first_proof_sandra_deleted_thread_day4" in flags else 0)
            - max(0, get_value(state, "sandra.exposure") - 5)
        ),
        "pauline": (
            (get_value(state, "pauline.interest") - 25) * 2
            + (get_value(state, "pauline.control") - 30) * 2
            + get_value(state, "pauline_risk_score") * 9
            + (get_value(state, "social_pressure") - 10) * 2
            + (10 if "first_proof_pauline_capture_day4" in flags else 0)
        ),
        "nico_marie": (
            (get_value(state, "ludo_jealousy") - 10) * 2
            + (get_value(state, "nico.place_near_marie") - 20) * 2
            + get_value(state, "nico_surveillance_score") * 10
            + get_value(state, "marie_neglect_score") * 8
            + (10 if "first_proof_nico_marie_story_day4" in flags else 0)
        ),
    }
    return scores


SECONDARY_ROUTE_MIN_SCORE = 10


def probable_routes(scores: dict[str, int]) -> tuple[str | None, str | None, bool]:
    ordered = sorted(scores.items(), key=lambda item: (-item[1], item[0]))
    dominant, dominant_score = ordered[0]
    secondary, secondary_score = ordered[1]
    has_strong_route = dominant_score >= BALANCED_STRONG_SCORE and dominant_score - secondary_score >= STRONG_ROUTE_MARGIN
    probable_secondary = secondary if has_strong_route and secondary_score >= SECONDARY_ROUTE_MIN_SCORE else None
    return (dominant if has_strong_route else None, probable_secondary, has_strong_route)


def active_threat(state: dict[str, Any], scores: dict[str, int], dominant: str | None) -> str:
    if scores["pauline"] >= 82 or "first_proof_pauline_capture_day4" in state["flags"]:
        return "proof_capture"
    if scores["nico_marie"] >= 62 or dominant == "nico_marie":
        return "nico"
    if dominant == "mathilde":
        return "marie_or_mathilde_guilt"
    if dominant == "sandra":
        return "exposure_or_marie"
    if dominant == "marie":
        return "contained_secrets"
    return "low_pressure"


def relationship_mode_seed(dominant: str | None, state: dict[str, Any]) -> str:
    if dominant == "marie":
        return "EXCLUSIF_REPARATION"
    if dominant in {"mathilde", "pauline"}:
        return "SECRET_AFFAIR"
    if dominant == "sandra":
        return "SECRET_AFFAIR_EMOTIONAL"
    if dominant == "nico_marie":
        return "NTR_SUBI_SEED"
    if get_value(state, "truth_tendency") >= get_value(state, "lie_score") + 30:
        return "HONEST_UNRESOLVED"
    return "UNRESOLVED"


def visible_variables(state: dict[str, Any]) -> dict[str, int]:
    keys = [
        "marie.trust",
        "marie.lucidity",
        "lie_score",
        "truth_tendency",
        "social_pressure",
        "ludo_jealousy",
        "mathilde.desire",
        "mathilde.loyalty",
        "sandra.attachment",
        "sandra.exposure",
        "pauline.interest",
        "pauline.control",
        "nico.place_near_marie",
        "marie_attention_score",
        "marie_neglect_score",
        "mathilde_attention_score",
        "sandra_priority_score",
        "pauline_risk_score",
        "nico_surveillance_score",
    ]
    return {key: get_value(state, key) for key in keys}


def strongest_flags(state: dict[str, Any]) -> list[str]:
    priority_prefixes = (
        "day4_closer_",
        "first_proof_",
        "opened_",
        "answered_",
        "replied_",
        "put_phone_down",
        "truth_",
        "pauline_",
        "watched_",
    )
    selected = [flag for flag in state["flags"] if flag.startswith(priority_prefixes)]
    return selected[:10]


def simulate(path: PathSpec, initial_state: dict[str, Any]) -> dict[str, Any]:
    state = copy.deepcopy(initial_state)
    for step in path.steps:
        apply_step(state, step)
    scores = route_scores(state)
    dominant, secondary, has_strong_route = probable_routes(scores)
    threat = active_threat(state, scores, dominant)
    mode = relationship_mode_seed(dominant, state)
    locked_routes = [route for route, score in scores.items() if score >= FINAL_LOCK_SCORE]
    checks = {
        "no_final_route_locked": not locked_routes,
        "expected_route_probable": dominant == path.expected_route if path.expected_route else not has_strong_route,
        "coherent_threat": threat == path.expected_threat,
        "balanced_no_strong_route": True if path.allow_strong_route else not has_strong_route,
    }
    return {
        "state": state,
        "scores": scores,
        "dominant": dominant,
        "secondary": secondary,
        "threat": threat,
        "mode": mode,
        "locked_routes": locked_routes,
        "checks": checks,
    }


PATHS = (
    PathSpec(
        name="marie_repair_path",
        expected_route="marie",
        expected_threat="contained_secrets",
        steps=(
            Step("Jour 1: répondre à Marie", {"marie.trust": 2, "truth_tendency": 2}, ("answered_marie_day1",), {"marie_attention_score": 1}),
            Step("Jour 2: rassurer Marie après la story", {"marie.trust": 2, "truth_tendency": 2}, ("replied_to_marie_story_day2",), {"marie_attention_score": 1}),
            Step("Jour 3: poser le téléphone pendant le pivot Mathilde nocturne", {"marie.trust": 2, "truth_tendency": 1}, ("put_phone_down_for_marie_j3_domestic_night",), {"marie_attention_score": 1}),
            Step("Jour 4: vérité partielle", {"marie.trust": 1, "marie.lucidity": 1, "truth_tendency": 2}, ("day4_closer_marie_truth",), {}),
        ),
    ),
    PathSpec(
        name="mathilde_attention_path",
        expected_route="mathilde",
        expected_threat="marie_or_mathilde_guilt",
        steps=(
            Step("Jour 1: tension domestique", {"mathilde.desire": 2, "lie_score": 1}, ("mathilde_home_scene_seen",), {"mathilde_attention_score": 1}),
            Step("Jour 2: sous-entendu accepté", {"mathilde.desire": 3, "lie_score": 1}, ("mathilde_ambiguous_joke_accepted",), {"mathilde_attention_score": 1}),
            Step("Jour 3: ouvrir Mathilde en premier dans le pivot domestique nocturne", {"mathilde.desire": 2, "marie.lucidity": 1}, ("opened_mathilde_first_j3_domestic_night",), {"mathilde_attention_score": 1}),
            Step("Jour 4: preuve Mathilde", {"mathilde.desire": 1}, ("first_proof_mathilde_warning_photo_day4", "day4_closer_mathilde_guilt"), {}),
        ),
    ),
    PathSpec(
        name="sandra_emotional_path",
        expected_route="sandra",
        expected_threat="exposure_or_marie",
        steps=(
            Step("Jour 1: vulnérabilité partagée", {"sandra.attachment": 3, "truth_tendency": 1}, ("shared_small_vulnerability_with_sandra_day1",), {"sandra_priority_score": 1}),
            Step("Jour 2: priorité émotionnelle", {"sandra.attachment": 3, "lie_score": 1}, ("answered_sandra_light_day2",), {"sandra_priority_score": 1, "marie_neglect_score": 1}),
            Step("Jour 3: ouvrir Sandra hors du faux panel", {"sandra.attachment": 2, "sandra.exposure": 1}, ("opened_sandra_first_j3_domestic_night", "answered_sandra_during_j3_domestic_night"), {"sandra_priority_score": 1}),
            Step("Jour 4: fil supprimé", {"sandra.attachment": 1, "lie_score": 1}, ("first_proof_sandra_deleted_thread_day4", "day4_closer_sandra_reasonable"), {}),
        ),
    ),
    PathSpec(
        name="pauline_future_legacy_probe",
        expected_route="pauline",
        expected_threat="proof_capture",
        steps=(
            Step("Jour 1: accepter le jeu social", {"pauline.interest": 2, "social_pressure": 1}, ("noticed_pauline_social_game_day1",), {"pauline_risk_score": 1}),
            Step("Jour 2: répondre à Pauline", {"pauline.interest": 2, "pauline.control": 2, "lie_score": 1}, ("answered_pauline_provocation_day2",), {"pauline_risk_score": 1}),
            Step("Jour 3: Pauline reste future / legacy", {"pauline.interest": 2, "pauline.control": 2, "social_pressure": 1}, ("opened_pauline_first_j3_domestic_night",), {"pauline_risk_score": 1}),
            Step("Jour 4: capture Pauline", {"pauline.control": 2, "lie_score": 1}, ("first_proof_pauline_capture_day4", "day4_closer_pauline_control"), {}),
        ),
    ),
    PathSpec(
        name="nico_marie_future_legacy_probe",
        expected_route="nico_marie",
        expected_threat="nico",
        steps=(
            Step("Jour 1: laisser Nico prendre de la place", {"nico.place_near_marie": 3, "ludo_jealousy": 2}, ("nico_complimented_marie_seen_day1",), {"nico_surveillance_score": 1}),
            Step("Jour 2: regarder la story Nico/Marie", {"ludo_jealousy": 3, "nico.place_near_marie": 2}, ("checked_marie_nico_story_day2",), {"nico_surveillance_score": 1, "marie_neglect_score": 1}),
            Step("Jour 3: Nico reste futur / legacy", {"ludo_jealousy": 2, "nico.place_near_marie": 1, "lie_score": 1}, ("watched_nico_marie_story_j3_domestic_night",), {"nico_surveillance_score": 1, "marie_neglect_score": 1}),
            Step("Jour 4: preuve story Nico/Marie", {"ludo_jealousy": 1}, ("first_proof_nico_marie_story_day4", "day4_closer_nico_jealousy"), {}),
        ),
    ),
    PathSpec(
        name="balanced_no_lock_path",
        expected_route=None,
        expected_threat="low_pressure",
        allow_strong_route=False,
        steps=(
            Step("Jour 1: répondre sans ambiguïté", {"marie.trust": 1, "truth_tendency": 1}, ("answered_marie_day1",), {"marie_attention_score": 1}),
            Step("Jour 2: café Raphaëlle clair", {"raphaelle.attachment": 1, "raphaelle.clarity": 1, "truth_tendency": 1}, ("accepted_raphaelle_coffee_clear_day2",), {"raphaelle_clarity_score": 1}),
            Step("Jour 3: J3 domestique sans verrou", {"social_pressure": 1}, ("put_phone_down_for_marie_j3_domestic_night",), {}),
            Step("Jour 4: bilan ouvert", {"truth_tendency": 1}, ("day4_balanced_open_state",), {}),
        ),
    ),
)


def print_result(path: PathSpec, result: dict[str, Any]) -> None:
    print(f"PATH {path.name}")
    print("  variables finales:")
    for key, value in visible_variables(result["state"]).items():
        print(f"    {key}: {value}")
    print("  route_scores:")
    for route, score in sorted(result["scores"].items()):
        print(f"    {route}: {score}")
    print("  flags principaux:")
    flags = strongest_flags(result["state"])
    print("    " + (", ".join(flags) if flags else "none"))
    print(f"  route_dominante_probable: {result['dominant'] or 'none'}")
    print(f"  route_secondaire_probable: {result['secondary'] or 'none'}")
    print(f"  menace_active_probable: {result['threat']}")
    print(f"  mode_relationnel_seed: {result['mode']}")
    print("  checks:")
    for name, ok in result["checks"].items():
        print(f"    {'PASS' if ok else 'FAIL'} {name}")
    print()


def main() -> int:
    initial_state = load_initial_state()
    failures: list[str] = []
    print("ROUTE PATH SIMULATION — days 1-4")
    print(f"initial_state: {INITIAL_STATE_PATH.relative_to(ROOT)}")
    print(f"paths: {len(PATHS)}")
    print()
    for path in PATHS:
        result = simulate(path, initial_state)
        print_result(path, result)
        for check_name, ok in result["checks"].items():
            if not ok:
                failures.append(f"{path.name}: {check_name}")
    if failures:
        print("SIMULATION FAILED")
        for failure in failures:
            print(f"  - {failure}")
        return 1
    print("SIMULATION OK: all route path checks passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
