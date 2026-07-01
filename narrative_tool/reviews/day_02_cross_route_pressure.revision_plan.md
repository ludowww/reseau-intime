# day_02_cross_route_pressure — Editorial Revision Plan

## Status
revision_plan_only

No draft changes in V0.16.

## Revision goal
Turn the cross-route pressure draft from a useful prototype into a more natural editorial draft by reducing visible orchestration, strengthening private voice fingerprints, and making Sandra/Marie transitions feel lived rather than tool-managed.

## Source review summary
Status: needs_editorial_revision. The prototype correctly shows Sandra/Marie pressure. Player stays coherent. The scene avoids melodrama. But transitions feel stitched together, some lines read like route management, and the draft is not yet reference quality.

## Current strengths to preserve
- Cross-route pressure is readable.
- No forced confrontation.
- Marie does not name Sandra.
- Sandra does not attack Marie.
- Player remains coherent.
- Choices are usable SMS.
- The scene has a useful pressure structure.

## Main editorial problems
- Too much visible orchestration between Sandra and Marie threads.
- Some lines sound like they exist to demonstrate the route interaction model.
- Sandra and Marie are distinct, but not always privately specific enough.
- Player sometimes says the subtext too cleanly.
- The scene is structurally correct but not messy enough to feel fully human.
- Some transitions feel like “now switch to Marie / now switch to Sandra” instead of natural message flow.

## Lines / beats to watch
Watch especially for:
- lines where Player names his internal state too cleanly
- lines where Sandra states the ambiguity too directly
- lines where Marie conveniently detects the exact pressure beat
- lines that repeat tool vocabulary: “coherent”, “present”, “pressure”, “clear”, “problem”
- thread switches that feel mechanically timed

Short fragments to keep in mind:
- “je fais de mon mieux pour rester cohérent”
- “c’est ça le problème”
- “j’aime quand c’est clair”
- “tu réponds en pointillés”

## Revision strategy
1. Keep the same overall pressure arc.
2. Make each thread less explanatory.
3. Replace meta-lines with concrete SMS behavior.
4. Add one or two mundane interruptions.
5. Let Marie notice presence through a practical need, not an exact diagnosis.
6. Let Sandra dodge more and define less.
7. Let Player repair through action-oriented SMS instead of self-analysis.

## Sandra voice adjustments
Sandra should feel like returning complicity, not a perfectly calibrated ambiguity engine.

Recommended direction:
- more small dodges
- more unfinished teasing
- more concrete callback to past lunch / photo / remembered tone
- less direct naming of “problem”
- less perfect aim
- more plausible hesitation after she goes too far

Example direction, not final line:
- replace direct ambiguity with a half-joke
- make Sandra back off once instead of always landing the exact beat
- let her test whether Player follows rather than stating what is happening

## Marie voice adjustments
Marie should feel like present-life intimacy, not a pressure detector.

Recommended direction:
- more domestic specificity
- less exact reading of Player’s emotional state
- one practical interruption
- one tender ordinary line before the presence check
- avoid making her too conveniently perceptive
- keep her non-punitive and non-suspicious

Example direction:
- Marie can ask about timing, dinner, keys, bread, sofa, fatigue
- Marie should notice the quality of presence through a small practical mismatch
- Marie should not sound like she knows the cross-route structure

## Player adjustments
Player should feel divided through pacing and small evasions, not through clean self-description.

Recommended direction:
- reduce self-analysis
- increase tiny repairs
- show hesitation through delayed, shorter, or corrected messages
- make him sincere but not perfectly articulate
- make him avoid cruelty without sounding morally engineered

## Transition / threading adjustments
Thread switches should feel like notifications interrupting attention, not scene beats firing.

Recommended direction:
- use one or two small delays
- let Player answer one message too quickly and another too late
- avoid symmetrical Sandra block → Marie block → Sandra block rhythm
- create messier overlap without making the JSON confusing

Important:
- Do not modify QA tools to support complex threading.
- Keep the accepted message format.

## Choice adjustments
- Keep choices as sendable SMS.
- Reduce any choice that sounds like an author label.
- Make one Marie choice more concrete/action-based.
- Make one Sandra choice more hesitant or less perfectly phrased.
- Keep no route lock.

## What must not change
- No forced confession.
- No Marie accusation.
- No Sandra attack on Marie.
- No route lock.
- No runtime integration.
- No modification of memory contracts.
- No change to route_interaction_rules.json.
- No increase above cross-route intensity 2.
- No explicit adult escalation.

## Acceptance criteria for V0.17
- QA Cross-route Day 2 remains pass.
- No tools modified.
- No route lock added.
- Marie remains non-suspicious and non-punitive.
- Sandra remains deniable and non-forceful.
- Player remains coherent.
- At least two tool-like/meta lines are replaced by concrete SMS behavior.
- Thread transitions feel less mechanically stitched.
- Human review status can move from needs_editorial_revision to editorial_pass.

## Proposed V0.17 scope
V0.17 should revise only:
- narrative_tool/drafts/day_02_cross_route_pressure.draft.json
- narrative_tool/reviews/day_02_cross_route_pressure.human_review.md, only if the human score changes after revision

V0.17 should not modify tools, memory contracts, route rules, runtime game data, or existing Sandra/Marie solo drafts.
