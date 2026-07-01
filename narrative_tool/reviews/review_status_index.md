# Narrative Review Status Index

## Purpose
Provide a quick index of technical QA, memory continuity, human review status, and integration readiness for `narrative_tool` drafts.

This index is not runtime data and does not make any draft canonical.

## Status legend
- `technical_pass` — the draft passes dialogue QA.
- `memory_source_pass` — the source draft produces expected memory traces.
- `memory_future_pass` — a later draft respects a previous memory contract.
- `editorial_pass` — human review says the draft is editorially usable.
- `validated_reference_quality` — strong reference for future generation.
- `needs_editorial_revision` — useful but not yet editorially solid.
- `prototype_not_canon` — QA/editorial prototype, not game runtime canon.
- `integration_candidate` — could be considered for future runtime integration after a dedicated readiness pass.

## Global summary
All five current drafts pass technical QA. Sandra Day 2 and Marie Day 2 pass future memory continuity. Marie Day 1 passes source memory coverage. All five drafts now have human reviews. All five current drafts are non-canonical `narrative_tool` prototypes. Cross-route Day 2 moved from `needs_editorial_revision` to `editorial_pass` in V0.17. No draft is currently marked as runtime-ready.

## Draft status table
| Draft | Route(s) | Day | Type | QA | Memory | Human status | Canon status | Integration note |
|---|---|---:|---|---|---|---|---|---|
| Sandra Day 1 | sandra | 1 | benchmark / opener draft | technical_pass | source memory contract exists | editorial_pass | prototype_not_canon | strong Sandra reference; possible integration candidate after readiness checklist |
| Sandra Day 2 | sandra | 2 | callback draft | technical_pass | memory_future_pass | editorial_pass | prototype_not_canon | useful callback reference, depends on Sandra Day 1 integration decisions |
| Marie Day 1 | marie | 1 | couple anchor draft | technical_pass | memory_source_pass | editorial_pass | prototype_not_canon | strong official-couple anchor; possible integration candidate after readiness checklist |
| Marie Day 2 | marie | 2 | callback draft | technical_pass | memory_future_pass | editorial_pass | prototype_not_canon | useful Marie continuity reference, depends on Marie Day 1 integration decisions |
| Cross-route Day 2 | sandra / marie | 2 | cross-route pressure prototype | technical_pass | not checked by continuity tool yet | editorial_pass | prototype_not_canon | useful later prototype, not first integration candidate |

## Memory continuity status
| Contract | Draft | Mode | Status | Note |
|---|---|---|---|---|
| sandra_day_01_memory_contract | day_02_sandra_callback | future_continuity_check | PASS | Sandra Day 2 respects Sandra Day 1 memory continuity. |
| marie_day_01_memory_contract | day_01_marie_couple_anchor | source_memory_coverage_check | PASS | Marie Day 1 produces the expected source memory coverage. |
| marie_day_01_memory_contract | day_02_marie_callback | future_continuity_check | PASS | Marie Day 2 respects Marie Day 1 memory continuity. |

Cross-route pressure draft currently has `memory_out`, but no dedicated cross-route memory continuity contract/check yet.

## Editorial readiness
Editorial pass does not mean runtime-ready. Sandra Day 1 and Marie Day 1 are the strongest candidates for future integration planning. Sandra Day 2 and Marie Day 2 should follow only after Day 1 integration choices are made. Cross-route Day 2 should remain a later prototype until solo route integration is clearer.

## Integration readiness notes
Before runtime integration, each candidate needs:
- canonical scene contract mapping to game data
- message ID / conversation ID mapping
- choice effect mapping
- route/memory state mapping
- notification/day placement
- validation against existing game conversations
- decision on whether the draft remains prototype or becomes canon

No current `narrative_tool` draft should be copied directly into `game/data/conversations` without an integration readiness pass.

## Next recommended actions
- V0.19 — Integration Readiness Checklist.
- V0.20 — First Integration Candidate Plan.
- Recommended first candidates: Sandra Day 1 or Marie Day 1.
- Do not integrate Cross-route Day 2 first.
