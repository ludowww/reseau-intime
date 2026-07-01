# day_01_marie — Runtime Integration Review

## Status
needs_runtime_polish

## Source
Narrative source draft: `narrative_tool/drafts/day_01_marie_couple_anchor.draft.json`
Human review source: `narrative_tool/reviews/day_01_marie_couple_anchor.human_review.md`
Integration plan source: `narrative_tool/docs/first_integration_candidate_plan.md`
Runtime baseline: `v0.21-runtime-marie-day1-anchor`

## Runtime file reviewed
`game/data/conversations/chapter_01_marie.json`

This review evaluates the runtime file, not the narrative_tool draft alone.

## Summary
V0.21 keeps Marie as the official Day 1 couple anchor and preserves the domestic bread/photo hook in a runtime-safe form.
The scene remains playable, with sendable SMS choices and a clear evening-return rhythm.
The integration is intentionally light, but it still adds memory texture and keeps the official couple frame readable.
Marie stays recognizably Marie, even if a few guided-reply lines read a little tool-shaped in runtime.

## Runtime integration assessment
Runtime format preservation is solid: the scene stays in the existing `messages` conversation structure and does not introduce a new runtime format.
Marie voice preservation is good overall. Her warmth, teasing, and domestic authority remain present, though the guided-reply scaffolding slightly smooths her edges.

Couple-anchor value remains strong. The bread/photo detail and the return-home rhythm continue to anchor the official relationship instead of drifting into abstract tension.
Choice quality is usable and mostly natural as SMS. The options are short, readable, and feel sendable, though some guided replies are a bit visibly authored.

Day pacing stays appropriate for Day 1. The scene does not jump into jealousy, crisis, or premature route pressure, and it keeps the day anchored in routine plus slight fatigue.
State and memory restraint is good: the integration keeps the scene light and does not introduce a new state/memory system. The existing runtime remains easy to reason about.

Compared with the source draft, the runtime version is more constrained and more structured. That is acceptable here because the scene still reads as a first anchor, not as a flattened rewrite.

## Scores
| Dimension | Score | Note |
|---|---:|---|
| runtime_format_fit | 4 | Native runtime structure preserved. |
| marie_voice_preservation | 3 | Marie stays herself, with minor tooling surface. |
| couple_anchor_strength | 4 | Strong official-couple grounding. |
| sms_choice_quality | 3 | Sendable and readable, slightly guided. |
| day_1_pacing | 4 | Calm, domestic, and correctly paced. |
| state_memory_restraint | 4 | No new memory/state system introduced. |
| source_draft_preservation | 3 | Core intent kept, some compression from draft. |
| integration_subtlety | 4 | Light touch, minimal disruption. |
| runtime_playability | 4 | Scene is technically and narratively playable. |
| post_integration_confidence | 3 | Solid anchor, but a full pass could still polish tone. |

## Automatic rejection flags
- runtime JSON invalid
- Marie voice flattened
- choices no longer feel like SMS
- scene creates premature jealousy/crisis
- scene creates route lock
- new unsupported state/memory system introduced
- Sandra or Day 2 accidentally modified

Aucun.

## Strengths
- The light integration keeps the runtime stable and avoids overfitting the scene into a heavy prototype layer.
- The bread/photo detail adds memory texture without introducing new systems.
- The choices are still natural enough to be sendable SMS, which preserves the branch’s playability.
- Marie remains the first Day 1 anchor, so the official couple frame is immediately legible.

## Weaknesses
- The integration is intentionally light, so it does not yet fully rework the draft into a deeper runtime-specific scene.
- A few guided-reply lines still feel slightly tool-shaped, which a future runtime polish pass could soften.
- The scene would benefit from a full playthrough review once Sandra Day 1 is also integrated.

## Specific runtime notes
V0.21 changed only `chapter_01_marie.json`. The integration changed a small number of lines.
The scene remains structurally the existing runtime Marie Day 1.
No Sandra / Day 2 / cross-route files were modified.
No new memory/state system was introduced.
The runtime keeps the official couple anchor intact while staying below any route-lock threshold.

## Decision
Accepted with polish recommended.

## Recommended next action
V0.23 — Sandra Day 1 runtime anchor, if Ludovic wants to build the second Day 1 pillar.

Recommended: Sandra Day 1 runtime anchor next, because Marie Day 1 is stable enough as a first anchor and the Day 1 balance now needs Sandra.
