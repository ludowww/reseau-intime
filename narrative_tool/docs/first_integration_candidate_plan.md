# First Integration Candidate Plan

## Purpose
Choose the best first `narrative_tool` draft to prepare for future runtime integration, without integrating it yet.

This plan does not make any draft canonical and does not modify `game/data/conversations`.

## Current baseline
V0.18 created the review status index. V0.19 created the integration readiness checklist and template. All five current drafts pass technical QA. All five current drafts have `editorial_pass` human reviews. No `narrative_tool` draft is currently runtime-ready.

## Candidates compared
This plan compares only:
- `day_01_sandra_photo_trigger`
- `day_01_marie_couple_anchor`

Day 2 callbacks depend on Day 1 integration decisions. Cross-route Day 2 should wait until Sandra and Marie solo foundations exist in runtime.

## Runtime context observed
Read-only inspection of `game/data/conversations/` and `game/data/` shows:
- `chapter_01_index.json` exists and currently places Marie first, then Sandra.
- `chapter_02_index.json` exists and keeps Marie active early, with Sandra later in the day.
- `chapter_03_index.json` exists and still treats Marie and Sandra as established solo threads.
- `chapter_04_index.json`, `chapter_05_index.json`, `chapter_06_index.json`, and `chapter_07_index.json` also reference both characters in later runtime structure.
- Marie and Sandra already exist in runtime conversation data.
- There is an existing Day 1 placement to preserve: Marie is initial in chapter 1, while Sandra is unlocked after Marie.

## Candidate A — Sandra Day 1

### Narrative value
Strong emotional route opener. The photo trigger, old-complicity tone, and controlled ambiguity make the scene immediately distinctive.

### Integration value
It gives the Sandra route an early emotional hook and sets up the specific memory texture needed for later Sandra callbacks.

### Risks
It can pull Day 1 toward emotional intensity too early and can make Marie feel secondary if placement is not handled carefully.

### Runtime mapping complexity
Moderate. The scene needs careful placement against the existing Marie-first Day 1 rhythm and must not collide with current unlock timing.

### Memory implications
Useful for later Sandra continuity, but it depends on the couple context already being legible in runtime.

### Why it could be first
If the main goal is emotional hook and route desire, Sandra Day 1 is the strongest opener.

### Why it might wait
It needs Marie context already established so the ambiguity reads as tension, not displacement.

## Candidate B — Marie Day 1

### Narrative value
Strong official-couple anchor. It stabilizes the present-life relationship, routine, and tenderness before route pressure increases.

### Integration value
It gives the runtime a clean couple foundation and makes later Sandra tension read ethically and emotionally against a visible baseline.

### Risks
If flattened, it can feel like domestic filler instead of a meaningful anchor scene.

### Runtime mapping complexity
Low to moderate. It aligns naturally with the current Day 1 placement and with the existing Marie-first structure already visible in runtime data.

### Memory implications
Very useful for state and tone continuity because it anchors the couple before later deviations.

### Why it could be first
If the priority is stabilizing the official couple and day rhythm, Marie Day 1 is the safest first integration.

### Why it might wait
It may feel less immediately provocative than Sandra Day 1 if the team wants the first runtime integration to lead with the strongest emotional hook.

## Comparison table

| Criterion | Sandra Day 1 | Marie Day 1 | Advantage |
|---|---|---|---|
| Route identity | Strong Sandra-route opener | Strong official-couple anchor | Tie |
| Emotional hook | Higher | Lower but steady | Sandra Day 1 |
| Runtime safety | Needs careful placement | Matches existing Day 1 rhythm | Marie Day 1 |
| State/memory simplicity | Good, but depends on Marie context | Cleanest baseline | Marie Day 1 |
| Future callback dependency | Needed for Sandra Day 2 | Needed for Marie Day 2 | Tie |
| Day 1 pacing | Risk of early intensity | Better pacing stabilizer | Marie Day 1 |
| Risk of flattening | Lower | Higher if mishandled | Sandra Day 1 |
| Risk of premature ambiguity | Higher | Lower | Marie Day 1 |
| Best first integration value | Strong if hook is priority | Strong if stability is priority | Marie Day 1 |

## Recommendation
Recommended first integration candidate: **Marie Day 1**

Reason: the observed runtime already uses Marie as the initial Day 1 anchor, and Marie Day 1 best preserves that structure while giving a clean base for later Sandra tension. It is the safest first integration if the priority is stabilizing the official couple and day rhythm. Sandra Day 1 remains the strongest secondary candidate if the next branch is meant to maximize emotional hook and route desire.

Secondary candidate: **Sandra Day 1**

## Proposed future integration branch
`work/runtime-integration-day-01-marie-couple-anchor-v0-21`

## Non-goals
No runtime integration in V0.20. No changes to `game/data/conversations`. No new route lock. No changes to save/state systems. No changes to QA scripts. No draft rewrite. No copy-paste of `narrative_tool` JSON into runtime.

## Risks
- runtime format mismatch
- day pacing overload
- choice effects without state mapping
- photo/media reference not available
- `memory_out` not mapped
- turning editorial SMS into rigid game data

## Required validations for future integration
```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```
If the `narrative_tool` draft remains modified during future integration, its dialogue QA must still pass. If runtime state changes are added, route simulation must explicitly cover them.

## Next step
V0.21 should be a scoped runtime integration branch for the recommended candidate only, if Ludovic validates this plan.
