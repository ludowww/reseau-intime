# Integration Readiness Checklist

## Purpose
Define what must be checked before a `narrative_tool` draft can become a canonical runtime conversation in `game/data/conversations`.

This checklist does not integrate any scene. It only defines readiness requirements.

## What this checklist prevents
- copying prototype JSON directly into runtime
- breaking existing conversation IDs
- creating choice effects without state mapping
- losing narrative memory continuity
- creating route locks too early
- mixing editorial prototypes with canonical game data
- integrating cross-route pressure before solo route foundations are ready

## Integration stages
1. Stage 0 — Candidate selection
2. Stage 1 — Narrative readiness
3. Stage 2 — Runtime mapping
4. Stage 3 — State and memory mapping
5. Stage 4 — Choice and consequence mapping
6. Stage 5 — Day / notification / placement mapping
7. Stage 6 — QA and regression validation
8. Stage 7 — Human review after integration

## Stage 0 — Candidate selection
- [ ] Draft has `technical_pass`.
- [ ] Draft has `editorial_pass` or better.
- [ ] Draft is not marked `needs_editorial_revision`.
- [ ] Draft has a clear route and day.
- [ ] Draft has an integration reason beyond “it exists”.
- [ ] Draft is not cross-route unless solo route foundations are already integrated.

Current likely first candidates: Sandra Day 1 or Marie Day 1.

## Stage 1 — Narrative readiness
- [ ] Scene has a clear concrete trigger.
- [ ] Character voices remain identifiable without labels.
- [ ] Player is present as a character.
- [ ] Choices are sendable SMS, not author labels.
- [ ] Desire/tension is appropriate for the day and route phase.
- [ ] No forced confession, crisis, or route lock too early.
- [ ] Human review has no automatic rejection flags.
- [ ] Revision notes are either resolved or consciously deferred.

## Stage 2 — Runtime mapping
- [ ] Runtime conversation file target is chosen.
- [ ] Existing game data format is inspected before writing.
- [ ] Conversation ID naming is decided.
- [ ] Message IDs are mapped or regenerated consistently.
- [ ] Speaker identifiers match runtime conventions.
- [ ] Any media/photo references are mapped to existing or planned runtime assets.
- [ ] Prototype-only metadata is removed or converted.
- [ ] The scene is marked canon only after integration validation.

Do not assume `narrative_tool` JSON structure matches runtime game conversation format.

## Stage 3 — State and memory mapping
- [ ] Relevant `memory_in` entries are mapped to runtime state or omitted consciously.
- [ ] `memory_out` entries are mapped to runtime state/event flags if needed.
- [ ] Route state changes are defined.
- [ ] Relationship state changes are defined.
- [ ] Cross-route effects are avoided unless explicitly scoped.
- [ ] Existing save/state systems are inspected before adding new flags.
- [ ] No new memory/state key is added without a clear future use.

## Stage 4 — Choice and consequence mapping
- [ ] Every player choice has a runtime consequence or intentionally neutral consequence.
- [ ] Choice labels/text remain natural SMS.
- [ ] Choice effects match existing game state conventions.
- [ ] No choice creates an unintended route lock.
- [ ] Clean withdrawal or low-pressure choices remain possible when appropriate.
- [ ] Consequences are tested through route simulation if runtime state changes.

## Stage 5 — Day / notification / placement mapping
- [ ] Day placement is decided.
- [ ] Contact/thread placement is decided.
- [ ] Notification behavior is decided.
- [ ] Unlock timing is decided.
- [ ] Scene does not overload the day with too many conversations.
- [ ] Existing day rhythm and character introduction pacing are respected.

## Stage 6 — QA and regression validation
- [ ] Narrative draft QA still passes if draft remains in `narrative_tool`.
- [ ] Runtime data validation passes.
- [ ] Route path simulation passes.
- [ ] Godot headless passes.
- [ ] Godot 1280x720 headless passes.
- [ ] Unit tests pass.
- [ ] No unintended reports or generated files are committed.
- [ ] Diff scope contains only intended files.

Commands:
```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

## Stage 7 — Human review after integration
- [ ] Integrated runtime scene still feels like the reviewed draft.
- [ ] Runtime constraints did not flatten character voice.
- [ ] Player choices remain sendable SMS.
- [ ] Scene still respects day/route intensity.
- [ ] Any cut or changed lines are noted.
- [ ] If the integrated scene differs significantly, create a new human review.

## Scene-specific notes
- Sandra Day 1: strong emotional reference; likely first candidate if the goal is to establish the Sandra route.
- Marie Day 1: strong couple anchor; likely first candidate if the goal is to stabilize the official relationship first.
- Sandra Day 2 and Marie Day 2: should generally wait until their Day 1 scenes are mapped.
- Cross-route Day 2: should wait until Sandra and Marie solo foundations exist in runtime.

## Current recommended candidates
| Candidate | Why | Caution |
|---|---|---|
| Sandra Day 1 | Strong emotional route opener and validated editorial pass. | Needs careful placement with Marie context. |
| Marie Day 1 | Strong official-couple anchor and validated editorial pass. | Must avoid flattening into domestic filler. |

## Do not integrate yet
Cross-route Day 2 should not be first integration. Day 2 callbacks should not be integrated before their Day 1 foundations. Any draft without an integration readiness pass should remain `prototype_not_canon`.
