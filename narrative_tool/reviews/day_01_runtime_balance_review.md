# Day 1 Runtime Balance Review

## Status
needs_joint_runtime_polish

## Source
Marie runtime review: `narrative_tool/reviews/day_01_marie_runtime_integration_review.md`
Sandra runtime review: `narrative_tool/reviews/day_01_sandra_runtime_integration_review.md`
Marie runtime baseline: `v0.21-runtime-marie-day1-anchor`
Sandra runtime baseline: `v0.23-runtime-sandra-day1-anchor`
Current baseline: `v0.24-runtime-sandra-day1-review`

## Runtime files reviewed
`game/data/conversations/chapter_01_index.json`
`game/data/conversations/chapter_01_marie.json`
`game/data/conversations/chapter_01_sandra.json`

This review evaluates the runtime Day 1 sequence, not the narrative_tool drafts alone.

## Summary
Marie is the official-couple anchor and keeps the opening grounded in routine, fatigue, and domestic proximity.
Sandra is the second emotional thread and arrives with a concrete memory trigger that feels readable in runtime.
Both scenes are runtime-stable and both remain accepted with polish recommended.
The main question is not whether the scenes work individually, but whether the Day 1 sequence has the right emotional pacing.
On balance, the structure works, but the transition still benefits from a joint polish pass.

## Day 1 flow assessment
The Marie → Sandra order works and matches the locked Day 1 structure.
Day 1 feels balanced rather than overloaded: Marie establishes the baseline, then Sandra opens a second thread without turning the day into a crisis.
The player gets enough context before Sandra because Marie first anchors the couple, the household rhythm, and the phone-distance texture.
Sandra creates intrigue without overwhelming Marie, because her recontact reads as a continuation of the day rather than a replacement for it.
The overall flow feels like a believable evening of private messages, with enough room for tension while keeping the sequence calm.

## Marie anchor assessment
Marie still functions as the official relationship anchor.
The domestic tenderness is present, along with fatigue, proximity, and the sense that the phone is part of the couple’s distance.
Choice quality is solid, though the guided-reply surface is visible in runtime.
The main risk is not failure, but domestic filler if the scene stays too visibly scaffolded.
Marie establishes enough emotional baseline before Sandra, so the later thread has something to stand against.

## Sandra anchor assessment
Sandra still reads as a returning complicity thread rather than a new escalation.
The photo / déjeuner / souvenir trigger is concrete and gives her a believable reason to reopen contact.
The deniable tension is correct for Day 1: present, but not overcooked.
Choice quality is usable, though the guided-reply structure remains a little tool-shaped.
Sandra works better because Marie came first, since the couple baseline makes the ambiguity feel pointed instead of generic.

## Marie → Sandra transition
Does Sandra arrive too soon? No, the unlock timing and Marie-first order keep the handoff readable.
Does Sandra arrive too strongly? Not yet; the scene stays prudent and does not break Day 1 balance.
Does Marie remain present in the player’s mind? Yes, because the opening scene is still the emotional baseline when Sandra appears.
Does Sandra feel like a second thread rather than replacement? Yes, that is the current runtime strength.
Does the sequence invite continuation into Day 2? Yes, but the invitation is still somewhat understated and would benefit from more texture.

## Scores
| Dimension | Score | Note |
|---|---:|---|
| day1_structure | 4 | Marie → Sandra is the right runtime order. |
| marie_anchor_strength | 4 | Marie clearly holds the couple baseline. |
| sandra_anchor_strength | 4 | Sandra opens a distinct second thread. |
| transition_quality | 3 | Works, but still wants joint smoothing. |
| emotional_pacing | 3 | Balanced, slightly light, not broken. |
| player_orientation | 3 | Player is present, though the surface is visible. |
| sms_runtime_naturalness | 3 | Sendable, but a bit guided in places. |
| guided_reply_surface | 2 | The scaffolding still shows. |
| route_balance | 4 | Marie is not erased by Sandra. |
| future_day2_setup | 3 | Good setup, but texture can be stronger. |
| runtime_stability | 4 | Runtime remains stable and readable. |

## Automatic rejection flags
- Marie erased by Sandra
- Sandra too aggressive for Day 1
- Day 1 creates premature jealousy/crisis
- Day 1 creates route lock
- Player feels incoherent between threads
- SMS choices no longer feel sendable
- runtime JSON invalid
- unsupported state/memory system introduced
- Day 2 / cross-route accidentally modified

Aucun.

## Strengths
- Marie-first order is product-aligned and keeps the official couple anchor readable.
- Sandra arrives as a second thread, not a replacement.
- Both runtime anchors are technically stable.
- There is no route lock or premature crisis in the current Day 1 sequence.
- The concrete bread / photo / déjeuner details create useful memory texture.
- The sequence keeps both domestic anchor and intrigue hook in view.

## Weaknesses
- Both scenes are still light integrations, so the runtime layer feels more scaffolded than the source drafts.
- The guided-reply surface remains visible in both threads.
- Marie and Sandra likely need a joint polish pass to feel fully coherent together.
- Day 1 could use a slightly more natural transition rhythm.
- Runtime scene depth is still below the source draft depth.

## Balance risks
If we continue without polish, Day 2 callbacks may rely on emotional texture that is not fully present in runtime yet.
Sandra may feel underbuilt if only the opener is strengthened in isolation.
Marie is stable, but she may remain slightly functional unless the rhythm is softened.
A future cross-route scene should not be integrated until the Day 1 polish picture is clearer.

## Decision
Day 1 structure accepted; joint polish recommended.

## Recommended next action
V0.26 — Marie/Sandra Day 1 Joint Runtime Polish

Recommended scope:
- short polish only
- modify `chapter_01_marie.json` and `chapter_01_sandra.json` only if needed
- no Day 2
- no cross-route
- no new state/memory system
- no route lock
- preserve Marie → Sandra order
- reduce guided/tool-shaped texture
- strengthen concrete intimacy and transition rhythm